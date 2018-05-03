/*
	Description
	FIR Filter.
	
	@designer(s):
	-	Daniel C.K. Kho	|	daniel.kho (at) opencores [dot] org
						|	daniel.kho (at) synvue [dot] com
	-	Tan Hooi Jing [hooijingtan@gmail.com]
	
	Copyright© 2012-2017 Authors and OPENCORES.ORG
	
	This source file is free software; you can redistribute it 
	and/or modify it under the terms of the GNU Lesser General 
	Public License as published by the Free Software Foundation; 
	either version 2.1 of the License, or (at your option) any 
	later version.
	
	This source is distributed in the hope that it will be 
	useful, but WITHOUT ANY WARRANTY; without even the implied 
	warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR 
	PURPOSE. See the GNU Lesser General Public License for more 
	details.
	
	You should have received a copy of the GNU Lesser General 
	Public License along with this source; if not, download it 
	from http://www.opencores.org/lgpl.shtml.
	
	@dependencies: 
	@created: 
	@info: 
	Revision History: @see Git log for full list of changes.
	
	This source file may be used and distributed without 
	restriction provided that this copyright statement is not 
	removed from the file and that any derivative work contains 
	the original copyright notice and the associated disclaimer.
*/
library ieee;	use ieee.std_logic_1164.all, ieee.numeric_std.all;

/* Filter order = number of unit delays. */
entity fir is generic(
	order:	positive	:= 30
); port(
	/* Asserting reset will start protocol sequence transmission. To restart the re-transmission of the sequence, 
		re-assert this reset signal, and the whole SPI sequence will be re-transmitted again.
	*/
	reset:	in	std_ulogic;			
	clk:	in	std_ulogic;
	
	/* Filter ports. */
	u:		in	u_signed;
	y:		out	u_signed
); end entity fir;

architecture rtl of fir is
	/* Memory I/Os: */
	signal q:	u_signed(u'range);
	
	/* 32-by-N matrix array structure (as in RAM). Similar to integer_vector, difference being base vector is 32-bit unsigned. */
	type	signed_vector	is array(natural range <>) of	u_signed(u'range);
	type	signedx2_vector	is array(natural range <>) of	u_signed(u'length*2-1 downto 0);
	
	/* Default filter coefficients.
		Filter length = number of taps = number of coefficients = order + 1.
		TODO allow user to override default coefficients using TLM interface.
	*/
	constant	b:	signed_vector(0 to order)	:= (
		x"FFEF",
		x"FFED",
		x"FFE8",
		x"FFE6",
		x"FFEB",
		x"0000",
		x"002C",
		x"0075",
		x"00DC",
		x"015F",
		x"01F4",
		x"028E",
		x"031F",
		x"0394",
		x"03E1",
		x"03FC",
		x"03E1",
		x"0394",
		x"031F",
		x"028E",
		x"01F4",
		x"015F",
		x"00DC",
		x"0075",
		x"002C",
		x"0000",
		x"FFEB",
		x"FFE6",
		x"FFE8",
		x"FFED",
		x"FFEF"
	);
	
	/* Pipes and delay chains. */
	signal	y0:		u_signed(u'length*2-1 downto 0);
	signal	u_pipe:	signed_vector(b'range)		:= (others => (others => '0'));
	signal	y_pipe:	signedx2_vector(b'range)	:= (others => (others => '0'));
	
	
	/* Explicitly define all multiplications with the "*" operator to use dedicated DSP hardware multipliers. */
	attribute	multstyle: string;	attribute multstyle		of rtl: architecture is "dsp";	--altera
--	attribute	mult_style: string;	attribute mult_style	of fir: entity is "block";		--xilinx
	
begin
	u_pipe(0)	<= u;
	u_dlyChain: for i in 1 to u_pipe'high generate
		delayChain: process(clk) is begin
			if rising_edge(clk) then
				u_pipe(i)	<= u_pipe(i-1);
			end if;
		end process delayChain;
	end generate u_dlyChain;
	
	y_pipe(0)		<= b(0) * u;
	y_dlyChain: for i in 1 to y_pipe'high generate
		y_pipe(i)	<= b(i) * u_pipe(i) + y_pipe(i-1);
	end generate y_dlyChain;
	
	y0	<= y_pipe(y_pipe'high) when not reset else (others => '0');
	y	<= y0(y'range);
end architecture rtl;
