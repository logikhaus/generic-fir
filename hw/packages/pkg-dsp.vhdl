/*
	Description
	Synvue Digital Signal Processing package.
	
	@designer(s):
	-	Daniel C.K. Kho	|	daniel.kho (at) opencores [dot] org
						|	daniel.kho (at) synvue [dot] com
	
	Copyright© 2014-2018 Authors and OPENCORES.ORG
	
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
/* TODO try using generic subprograms to have a single subprogram being 
	passed generic types.
*/
library ieee; use ieee.std_logic_1164.all, ieee.numeric_std.all;
package dsp_specific is
	function clamp(s:unsigned; low,high:unsigned) return unsigned;
	function clamp(s:unsigned; low,high:natural) return unsigned;
	function clamp(s:signed; low,high:signed) return signed;
	function clamp(s:signed; low,high:integer) return signed;
	
	function max(l,r:unsigned) return unsigned;
	function max(l,r:signed) return signed;
	function min(l,r:unsigned) return unsigned;
	function min(l,r:signed) return signed;
end package dsp_specific;

package body dsp_specific is
	function clamp(s:unsigned; low,high:unsigned) return unsigned is
		variable clamped:unsigned(s'range);
	begin
		clamped:=low when s<low else high when s>high else s;
		return clamped;
	end function clamp;
	
	function clamp(s:unsigned; low,high:natural) return unsigned is begin
		return clamp(s,to_unsigned(low,s'length),to_unsigned(high,s'length));
	end function clamp;
	
	function clamp(s:signed; low,high:signed) return signed is
		variable clamped:signed(s'range);
	begin
		clamped:=low when s<low else high when s>high else s;
		return clamped;
	end function clamp;
	
	function clamp(s:signed; low,high:integer) return signed is begin
		return clamp(s,to_signed(low,s'length),to_signed(high,s'length));
	end function clamp;
	
	function max(l,r:unsigned) return unsigned is begin
		/* FIXME support this in next standard. */
		--return r when r>l else l;
		
		if r>l then return r; end if;
		return l;
	end function max;
	
	function max(l,r:signed) return signed is begin
		--return r when r>l else l;
		
		if r>l then return r; end if;
		return l;
	end function max;
	
	function min(l,r:unsigned) return unsigned is begin
		--return r when r<l else l;
		
		if r<l then return r; end if;
		return l;
	end function min;
	
	function min(l,r:signed) return signed is begin
		--return r when r<l else l;
		
		if r<l then return r; end if;
		return l;
	end function min;
end package body dsp_specific;


library ieee; use ieee.std_logic_1164.all, ieee.numeric_std.all;
package dsp_generic is generic(
		type T;
		--function "+"(l,r:T) return T is <>;
		--function "<"(l,r:T) return boolean is <>;
		--function ">"(l,r:T) return boolean is <>;
		--function ">"(l:T;r:natural) return boolean is <>;
		--function clamp(s,low,high:T) return T is <>;
		function clamp(s:T; low,high:natural) return T is <>
	);
	
	--function clamp generic(type T) parameter(s:T; low:T; high:T) return T;
end package dsp_generic;

package body dsp_generic is end package body dsp_generic;
