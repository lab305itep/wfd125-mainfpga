--__________________________________________________________________________________                  
--                             VME TO WB INTERFACE
--
--                                CERN,BE/CO-HT 
--_________________________________________________________________________________
-- File:                      VME_Access_Decode.vhd
--_________________________________________________________________________________
-- Description: This component checks if the board is addressed and if it is, allows 
-- allows the access to WB bus by asserting the CardSel signal.
--
--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- Only A32 and A64 access is considered, all AM's
-- 2e transfers are not supported yet
--		A64:	512 MByte window for memory access
--				VME base addr: zero(27:0) & Addr_Hi(1:0) & GA(4:0) & zero(28:0)
--				mapped to local WB addresses 0-1FFFFFFF
--		A32:	1 Mbyte window for register space
--				VME base addr: zero(4:0) & Addr_Hi(1:0) & GA(4:0) & zero(19:0)
--				mapped to local WB addresses 20000000-200FFFFF
--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
--________________________________________________________________________________________
-- Authors:                                     
--               Svirlex
-- Date         03/2015                                                                           
-- Version      v0.04 

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

use IEEE.NUMERIC_STD.ALL;
use work.vme64x_pack.all;

--===========================================================================
-- Entity declaration
--===========================================================================

entity VME_Access_Decode is
    Port (clk_i           : in  STD_LOGIC;
          reset           : in  STD_LOGIC;
          mainFSMreset    : in  STD_LOGIC;
          decode          : in  STD_LOGIC;
          ModuleEnable    : in  STD_LOGIC;
          Addr            : in  STD_LOGIC_VECTOR (63 downto 0);
          Am              : in  STD_LOGIC_VECTOR (5 downto 0);
          XAm             : in  STD_LOGIC_VECTOR (7 downto 0);		-- not used so far
          BAR_i           : in  STD_LOGIC_VECTOR (4 downto 0);
			 Addr_HI_i       : in  STD_LOGIC_VECTOR (1 downto 0);   
			 AddrWidth       : in  STD_LOGIC_VECTOR (1 downto 0);		-- not used so far
          Base_Addr       : out  STD_LOGIC_VECTOR (63 downto 0);
          CardSel         : out  std_logic
       );

end VME_Access_Decode;
--===========================================================================
-- Architecture declaration
--===========================================================================
architecture Behavioral of VME_Access_Decode is

--===========================================================================
-- Architecture begin
--===========================================================================	
begin

   p_Match : process(clk_i)
   begin
      if rising_edge(clk_i) then
         if mainFSMreset = '1' or reset = '1' then
            CardSel <= '0';
            Base_Addr <= (others => '0');
         elsif decode = '1' and ModuleEnable = '1' then
				if	((Am = c_A32) or					-- hex code 0x09
					 (Am = c_A32_sup) or 			-- hex code 0x0d
					 (Am = c_A32_BLT) or				-- hex code 0x0b  
					 (Am = c_A32_BLT_sup) or 		-- hex code 0x0f
					 (Am = c_A32_MBLT) or			-- hex code 0x08
					 (Am = c_A32_MBLT_sup)) and	-- hex code 0x0c
					Addr(31 downto 27) = "00000" and
					Addr(26 downto 25) = Addr_HI_i and
					Addr(24 downto 20) = BAR_i then 
						CardSel <= '1';
                  Base_Addr(63 downto 28) <= x"FFFFFFFFE";
                  Base_Addr(27 downto 20) <= '0' & Addr_HI_i & BAR_i;
                  Base_Addr(19 downto 0)  <= (others => '0');                
				end if;
				if	((Am = c_A64) or					-- hex code 0x01
					 (Am = c_A64_BLT) or		  		-- hex code 0x03
					 (Am = c_A64_MBLT)) and			-- hex code 0x00
					Addr(63 downto 36) = x"0000000" and
					Addr(35 downto 34) = Addr_HI_i and
					Addr(33 downto 29) = BAR_i then 
						CardSel <= '1';
                  Base_Addr(63 downto 36) <= (others => '0');
                  Base_Addr(35 downto 29) <= Addr_HI_i & BAR_i;
                  Base_Addr(28 downto 0)  <= (others => '0');                
				end if;
			end if;
		end if;
   end process;
	
end Behavioral;
--===========================================================================
-- Architecture end
--===========================================================================
