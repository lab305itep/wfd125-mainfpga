-------------------------------------------------------------------------------
-- Title      : 
-- Project    : 
-------------------------------------------------------------------------------
-- File       : rgmii_mdio.vhd
-- Author     : liyi  <alxiuyain@foxmail.com>
-- Company    : OE@HUST
-- Created    : 2012-12-02
-- Last update: 2012-12-02
-- Platform   : 
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description: 
-------------------------------------------------------------------------------
-- Copyright (c) 2012 OE@HUST
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2012-12-02  1.0      liyi    Created
-------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;
-------------------------------------------------------------------------------
ENTITY rgmii_mdio IS

  PORT (
    iWbClk : IN STD_LOGIC;
    iRst_n : IN STD_LOGIC;

    ---------------------------------------------------------------------------
    -- signals from register file
    ---------------------------------------------------------------------------
    iPHYAddr  : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
    iRegAddr  : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
    iNoPre    : IN STD_LOGIC;
    iData2PHY : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    iClkDiv   : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    iRdOp     : IN STD_LOGIC;
    iWrOp     : IN STD_LOGIC;

    ---------------------------------------------------------------------------
    -- signals to register file
    ---------------------------------------------------------------------------
    oDataFromPHY      : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);  -- data from PHY registers
    oDataFromPHYValid : OUT STD_LOGIC;  -- only valid for 1 clock cycle
    oClrRdOp          : OUT STD_LOGIC;  -- only valid for 1 clock cycle
    oClrWrOp          : OUT STD_LOGIC;  -- only valid for 1 clock cycle
    oMDIOBusy         : OUT STD_LOGIC;  -- manegement is busy

    ---------------------------------------------------------------------------
    -- Management interface
    ---------------------------------------------------------------------------
    iMDI  : IN  STD_LOGIC;
    oMDO  : OUT STD_LOGIC;
    oMDHz : OUT STD_LOGIC;              -- mdio is in HighZ state
    oMDC  : OUT STD_LOGIC
    );

END ENTITY rgmii_mdio;
-------------------------------------------------------------------------------
ARCHITECTURE rtl OF rgmii_mdio IS

  SIGNAL rdPend, wrPend : STD_LOGIC;

  SIGNAL endOp : STD_LOGIC;
  SIGNAL busy  : STD_LOGIC;

  SIGNAL sendEn    : BOOLEAN;  -- Data is output on sendEn. Delay it slightly from the 
  --clock to ensure setup and hold timing is met
  SIGNAL receiveEn : BOOLEAN;  -- Sample read data just before rising edge of MDC

BEGIN  -- ARCHITECTURE rtl

  -----------------------------------------------------------------------------
  -- receive command from wishbone 
  -----------------------------------------------------------------------------
  oMDIOBusy <= busy;
  busy      <= wrPend OR rdPend;
  PROCESS (iWbClk, iRst_n) IS
  BEGIN
    IF iRst_n = '0' THEN
      rdPend        <= '0';
      wrPend        <= '0';
      oClrWrOp      <= '0';
      oClrRdOp      <= '0';
    ELSIF rising_edge(iWbClk) THEN
      oClrWrOp <= '0';
      oClrRdOp <= '0';
      IF busy = '0' THEN
        IF iRdOp = '1' THEN
          rdPend   <= '1';
          oClrRdOp <= '1';
        ELSIF iWrOp = '1' THEN
          wrPend   <= '1';
          oClrWrOp <= '1';
        END IF;
      ELSIF endOp = '1' THEN
        rdPend        <= '0';
        wrPend        <= '0';
      END IF;
    END IF;
  END PROCESS;

  -----------------------------------------------------------------------------
  -- MDC generation
  -----------------------------------------------------------------------------
  mdcGen : BLOCK IS
    SIGNAL mdc       : STD_LOGIC;
    SIGNAL mdcClkDiv : INTEGER RANGE 0 TO 127;
    SIGNAL clkDivTmp : INTEGER RANGE 0 TO 126;
  BEGIN  -- BLOCK mdc
    oMDC      <= mdc;
    clkDivTmp <= 1 WHEN iClkDiv < 4 ELSE (conv_integer(iClkDiv(7 DOWNTO 1))-1);
    sendEn    <= mdc = '1' AND mdcClkDiv = 0;  -- falling edge send
    receiveEn <= mdc = '0' AND mdcClkDiv = 0;  -- rising edge receive
    PROCESS (iWbClk, iRst_n) IS
    BEGIN
      IF iRst_n = '0' THEN
        mdc       <= '0';
        mdcClkDiv <= 0;
      ELSIF rising_edge(iWbClk) THEN
        IF mdcClkDiv = 0 THEN
          mdcClkDiv <= clkDivTmp;
          mdc       <= NOT mdc;
        ELSE
          mdcClkDiv <= mdcClkDiv - 1;
        END IF;
      END IF;
    END PROCESS;
  END BLOCK mdcGen;

  operation : BLOCK IS
    TYPE state_t IS (PREAMBLE, IDLE, CTRL, WRITE, READ);
    SIGNAL state    : state_t;
    SIGNAL bitCnt   : INTEGER RANGE 0 TO 31;
    SIGNAL shiftReg : STD_LOGIC_VECTOR(15 DOWNTO 0);
  BEGIN  -- BLOCK operation
    PROCESS (iWbClk, iRst_n) IS
    BEGIN
      IF iRst_n = '0' THEN
        oMDHz             <= '1';
	oMDO              <= '1';
        state             <= PREAMBLE;
        endOp             <= '0';
        bitCnt            <= 0;
        shiftReg          <= (OTHERS => '0');
        oDataFromPHYValid <= '0';
        oDataFromPHY      <= (OTHERS => '0');
      ELSIF rising_edge(iWbClk) THEN
        endOp             <= '0';
        oDataFromPHYValid <= '0';
        CASE state IS
          WHEN PREAMBLE =>
            IF sendEn THEN
              bitCnt <= bitCnt + 1;
              oMDHz  <= '0';
	      oMDO   <= '1';
              IF bitCnt = 30 THEN
                state <= IDLE;
              END IF;
            END IF;
          WHEN IDLE =>
            IF sendEn THEN
              IF busy = '1' THEN        -- start transaction
                oMDHz    <= '0';        -- firstbit of start word
		oMDO     <= '0';
                state    <= CTRL;
                bitCnt   <= 0;
                shiftReg <= iData2PHY;
              END IF;
            END IF;
          WHEN CTRL =>
            IF sendEn THEN
              bitCnt <= bitCnt + 1;
              CASE bitCnt IS
                WHEN 0  => oMDO <= '1';   -- second bit of start word
		           oMDHz  <= '0';
                --  OPCODE. 1 then 0 for read, 0 then 1 for write
                WHEN 1  => oMDO <= rdPend;
		           oMDHz  <= '0';
                WHEN 2  => oMDO <= NOT rdPend;
		           oMDHz  <= '0';
                -- PHY address
                WHEN 3  => oMDO <= iPHYAddr(4);
		           oMDHz  <= '0';
                WHEN 4  => oMDO <= iPHYAddr(3);
		           oMDHz  <= '0';
                WHEN 5  => oMDO <= iPHYAddr(2);
		           oMDHz  <= '0';
                WHEN 6  => oMDO <= iPHYAddr(1);
		           oMDHz  <= '0';
                WHEN 7  => oMDO <= iPHYAddr(0);
		           oMDHz  <= '0';
                --  Register address
                WHEN 8  => oMDO <= iRegAddr(4);
		           oMDHz  <= '0';
                WHEN 9  => oMDO <= iRegAddr(3);
		           oMDHz  <= '0';
                WHEN 10 => oMDO <= iRegAddr(2);
		           oMDHz  <= '0';
                WHEN 11 => oMDO <= iRegAddr(1);
		           oMDHz  <= '0';
                WHEN 12 => oMDO <= iRegAddr(0);
		           oMDHz  <= '0';
                -- TA
                WHEN 13 => oMDO <= '1';
		           oMDHz  <= rdPend;
                WHEN 14 =>
                  IF rdPend = '0' THEN
                    state  <= WRITE;
                    oMDHz  <= '0';
		    oMDO   <= '0';
                    bitCnt <= 0;
                  END IF;
                WHEN 15 =>
                  state  <= READ;
                  bitCnt <= 0;
                WHEN OTHERS => NULL;
              END CASE;
            END IF;
          WHEN WRITE =>
            IF sendEn THEN
              oMDO     <= shiftReg(15);
	      oMDHz    <= '0';
              shiftReg <= shiftReg(14 DOWNTO 0) & '0';
              bitCnt   <= bitCnt + 1;
              IF bitCnt = 15 THEN
                endOp  <= '1';
                bitCnt <= 0;
                IF iNoPre = '1' THEN
                  state <= IDLE;
                ELSE
                  state <= PREAMBLE;
                END IF;
              END IF;
            END IF;
          WHEN READ =>
            IF receiveEn THEN
              bitCnt   <= bitCnt + 1;
              shiftReg <= shiftReg(14 DOWNTO 0) & iMDI;
              IF bitCnt = 15 THEN
                bitCnt            <= 0;
                endOp             <= '1';
                oDataFromPHY      <= shiftReg(14 DOWNTO 0) & iMDI;
                oDataFromPHYValid <= '1';
                IF iNoPre = '1' THEN
                  state <= IDLE;
                ELSE
                  state <= PREAMBLE;
                END IF;
              END IF;
            END IF;
          WHEN OTHERS => NULL;
        END CASE;
      END IF;
    END PROCESS;
  END BLOCK operation;

END ARCHITECTURE rtl;
