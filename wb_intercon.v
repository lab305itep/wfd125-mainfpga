// THIS FILE IS AUTOGENERATED BY wb_intercon_gen
// ANY MANUAL CHANGES WILL BE LOST
module wb_intercon
   (input         wb_clk_i,
    input         wb_rst_i,
    input  [31:0] wb_VME64xCore_Top_adr_i,
    input  [31:0] wb_VME64xCore_Top_dat_i,
    input   [3:0] wb_VME64xCore_Top_sel_i,
    input         wb_VME64xCore_Top_we_i,
    input         wb_VME64xCore_Top_cyc_i,
    input         wb_VME64xCore_Top_stb_i,
    input   [2:0] wb_VME64xCore_Top_cti_i,
    input   [1:0] wb_VME64xCore_Top_bte_i,
    output [31:0] wb_VME64xCore_Top_dat_o,
    output        wb_VME64xCore_Top_ack_o,
    output        wb_VME64xCore_Top_err_o,
    output        wb_VME64xCore_Top_rty_o,
    output [31:0] wb_reg_csr_adr_o,
    output [31:0] wb_reg_csr_dat_o,
    output  [3:0] wb_reg_csr_sel_o,
    output        wb_reg_csr_we_o,
    output        wb_reg_csr_cyc_o,
    output        wb_reg_csr_stb_o,
    output  [2:0] wb_reg_csr_cti_o,
    output  [1:0] wb_reg_csr_bte_o,
    input  [31:0] wb_reg_csr_dat_i,
    input         wb_reg_csr_ack_i,
    input         wb_reg_csr_err_i,
    input         wb_reg_csr_rty_i,
    output [31:0] wb_icx_spi_adr_o,
    output [31:0] wb_icx_spi_dat_o,
    output  [3:0] wb_icx_spi_sel_o,
    output        wb_icx_spi_we_o,
    output        wb_icx_spi_cyc_o,
    output        wb_icx_spi_stb_o,
    output  [2:0] wb_icx_spi_cti_o,
    output  [1:0] wb_icx_spi_bte_o,
    input  [31:0] wb_icx_spi_dat_i,
    input         wb_icx_spi_ack_i,
    input         wb_icx_spi_err_i,
    input         wb_icx_spi_rty_i,
    output [31:0] wb_dac_spi_adr_o,
    output [31:0] wb_dac_spi_dat_o,
    output  [3:0] wb_dac_spi_sel_o,
    output        wb_dac_spi_we_o,
    output        wb_dac_spi_cyc_o,
    output        wb_dac_spi_stb_o,
    output  [2:0] wb_dac_spi_cti_o,
    output  [1:0] wb_dac_spi_bte_o,
    input  [31:0] wb_dac_spi_dat_i,
    input         wb_dac_spi_ack_i,
    input         wb_dac_spi_err_i,
    input         wb_dac_spi_rty_i,
    output [31:0] wb_triggen_adr_o,
    output [31:0] wb_triggen_dat_o,
    output  [3:0] wb_triggen_sel_o,
    output        wb_triggen_we_o,
    output        wb_triggen_cyc_o,
    output        wb_triggen_stb_o,
    output  [2:0] wb_triggen_cti_o,
    output  [1:0] wb_triggen_bte_o,
    input  [31:0] wb_triggen_dat_i,
    input         wb_triggen_ack_i,
    input         wb_triggen_err_i,
    input         wb_triggen_rty_i,
    output [31:0] wb_regA_adr_o,
    output [31:0] wb_regA_dat_o,
    output  [3:0] wb_regA_sel_o,
    output        wb_regA_we_o,
    output        wb_regA_cyc_o,
    output        wb_regA_stb_o,
    output  [2:0] wb_regA_cti_o,
    output  [1:0] wb_regA_bte_o,
    input  [31:0] wb_regA_dat_i,
    input         wb_regA_ack_i,
    input         wb_regA_err_i,
    input         wb_regA_rty_i,
    output [31:0] wb_regB_adr_o,
    output [31:0] wb_regB_dat_o,
    output  [3:0] wb_regB_sel_o,
    output        wb_regB_we_o,
    output        wb_regB_cyc_o,
    output        wb_regB_stb_o,
    output  [2:0] wb_regB_cti_o,
    output  [1:0] wb_regB_bte_o,
    input  [31:0] wb_regB_dat_i,
    input         wb_regB_ack_i,
    input         wb_regB_err_i,
    input         wb_regB_rty_i,
    output [31:0] wb_regC_adr_o,
    output [31:0] wb_regC_dat_o,
    output  [3:0] wb_regC_sel_o,
    output        wb_regC_we_o,
    output        wb_regC_cyc_o,
    output        wb_regC_stb_o,
    output  [2:0] wb_regC_cti_o,
    output  [1:0] wb_regC_bte_o,
    input  [31:0] wb_regC_dat_i,
    input         wb_regC_ack_i,
    input         wb_regC_err_i,
    input         wb_regC_rty_i,
    output [31:0] wb_regD_adr_o,
    output [31:0] wb_regD_dat_o,
    output  [3:0] wb_regD_sel_o,
    output        wb_regD_we_o,
    output        wb_regD_cyc_o,
    output        wb_regD_stb_o,
    output  [2:0] wb_regD_cti_o,
    output  [1:0] wb_regD_bte_o,
    input  [31:0] wb_regD_dat_i,
    input         wb_regD_ack_i,
    input         wb_regD_err_i,
    input         wb_regD_rty_i,
    output [31:0] wb_wb_tmem_adr_o,
    output [31:0] wb_wb_tmem_dat_o,
    output  [3:0] wb_wb_tmem_sel_o,
    output        wb_wb_tmem_we_o,
    output        wb_wb_tmem_cyc_o,
    output        wb_wb_tmem_stb_o,
    output  [2:0] wb_wb_tmem_cti_o,
    output  [1:0] wb_wb_tmem_bte_o,
    input  [31:0] wb_wb_tmem_dat_i,
    input         wb_wb_tmem_ack_i,
    input         wb_wb_tmem_err_i,
    input         wb_wb_tmem_rty_i,
    output [31:0] wb_i2c_ms_cbuf_adr_o,
    output  [7:0] wb_i2c_ms_cbuf_dat_o,
    output  [3:0] wb_i2c_ms_cbuf_sel_o,
    output        wb_i2c_ms_cbuf_we_o,
    output        wb_i2c_ms_cbuf_cyc_o,
    output        wb_i2c_ms_cbuf_stb_o,
    output  [2:0] wb_i2c_ms_cbuf_cti_o,
    output  [1:0] wb_i2c_ms_cbuf_bte_o,
    input   [7:0] wb_i2c_ms_cbuf_dat_i,
    input         wb_i2c_ms_cbuf_ack_i,
    input         wb_i2c_ms_cbuf_err_i,
    input         wb_i2c_ms_cbuf_rty_i,
    output [31:0] wb_fifoA_adr_o,
    output [31:0] wb_fifoA_dat_o,
    output  [3:0] wb_fifoA_sel_o,
    output        wb_fifoA_we_o,
    output        wb_fifoA_cyc_o,
    output        wb_fifoA_stb_o,
    output  [2:0] wb_fifoA_cti_o,
    output  [1:0] wb_fifoA_bte_o,
    input  [31:0] wb_fifoA_dat_i,
    input         wb_fifoA_ack_i,
    input         wb_fifoA_err_i,
    input         wb_fifoA_rty_i,
    output [31:0] wb_fifoB_adr_o,
    output [31:0] wb_fifoB_dat_o,
    output  [3:0] wb_fifoB_sel_o,
    output        wb_fifoB_we_o,
    output        wb_fifoB_cyc_o,
    output        wb_fifoB_stb_o,
    output  [2:0] wb_fifoB_cti_o,
    output  [1:0] wb_fifoB_bte_o,
    input  [31:0] wb_fifoB_dat_i,
    input         wb_fifoB_ack_i,
    input         wb_fifoB_err_i,
    input         wb_fifoB_rty_i,
    output [31:0] wb_fifoC_adr_o,
    output [31:0] wb_fifoC_dat_o,
    output  [3:0] wb_fifoC_sel_o,
    output        wb_fifoC_we_o,
    output        wb_fifoC_cyc_o,
    output        wb_fifoC_stb_o,
    output  [2:0] wb_fifoC_cti_o,
    output  [1:0] wb_fifoC_bte_o,
    input  [31:0] wb_fifoC_dat_i,
    input         wb_fifoC_ack_i,
    input         wb_fifoC_err_i,
    input         wb_fifoC_rty_i,
    output [31:0] wb_fifoD_adr_o,
    output [31:0] wb_fifoD_dat_o,
    output  [3:0] wb_fifoD_sel_o,
    output        wb_fifoD_we_o,
    output        wb_fifoD_cyc_o,
    output        wb_fifoD_stb_o,
    output  [2:0] wb_fifoD_cti_o,
    output  [1:0] wb_fifoD_bte_o,
    input  [31:0] wb_fifoD_dat_i,
    input         wb_fifoD_ack_i,
    input         wb_fifoD_err_i,
    input         wb_fifoD_rty_i);

wire [31:0] wb_m2s_resize_i2c_ms_cbuf_adr;
wire [31:0] wb_m2s_resize_i2c_ms_cbuf_dat;
wire  [3:0] wb_m2s_resize_i2c_ms_cbuf_sel;
wire        wb_m2s_resize_i2c_ms_cbuf_we;
wire        wb_m2s_resize_i2c_ms_cbuf_cyc;
wire        wb_m2s_resize_i2c_ms_cbuf_stb;
wire  [2:0] wb_m2s_resize_i2c_ms_cbuf_cti;
wire  [1:0] wb_m2s_resize_i2c_ms_cbuf_bte;
wire [31:0] wb_s2m_resize_i2c_ms_cbuf_dat;
wire        wb_s2m_resize_i2c_ms_cbuf_ack;
wire        wb_s2m_resize_i2c_ms_cbuf_err;
wire        wb_s2m_resize_i2c_ms_cbuf_rty;

wb_mux
  #(.num_slaves (14),
    .MATCH_ADDR ({32'h20010000, 32'h20010040, 32'h20010050, 32'h20010060, 32'h20010070, 32'h20020000, 32'h20040000, 32'h20060000, 32'h20080000, 32'h200a0000, 32'h20010020, 32'h20010010, 32'h20010030, 32'h20010100}),
    .MATCH_MASK ({32'hfffffff8, 32'hfffffff8, 32'hfffffff8, 32'hfffffff8, 32'hfffffff8, 32'hffffffe0, 32'hfffe0000, 32'hfffe0000, 32'hfffe0000, 32'hfffe0000, 32'hfffffff8, 32'hfffffff8, 32'hfffffff8, 32'hffffffc0}))
 wb_mux_VME64xCore_Top
   (.wb_clk_i  (wb_clk_i),
    .wb_rst_i  (wb_rst_i),
    .wbm_adr_i (wb_VME64xCore_Top_adr_i),
    .wbm_dat_i (wb_VME64xCore_Top_dat_i),
    .wbm_sel_i (wb_VME64xCore_Top_sel_i),
    .wbm_we_i  (wb_VME64xCore_Top_we_i),
    .wbm_cyc_i (wb_VME64xCore_Top_cyc_i),
    .wbm_stb_i (wb_VME64xCore_Top_stb_i),
    .wbm_cti_i (wb_VME64xCore_Top_cti_i),
    .wbm_bte_i (wb_VME64xCore_Top_bte_i),
    .wbm_dat_o (wb_VME64xCore_Top_dat_o),
    .wbm_ack_o (wb_VME64xCore_Top_ack_o),
    .wbm_err_o (wb_VME64xCore_Top_err_o),
    .wbm_rty_o (wb_VME64xCore_Top_rty_o),
    .wbs_adr_o ({wb_reg_csr_adr_o, wb_regA_adr_o, wb_regB_adr_o, wb_regC_adr_o, wb_regD_adr_o, wb_m2s_resize_i2c_ms_cbuf_adr, wb_fifoA_adr_o, wb_fifoB_adr_o, wb_fifoC_adr_o, wb_fifoD_adr_o, wb_dac_spi_adr_o, wb_icx_spi_adr_o, wb_triggen_adr_o, wb_wb_tmem_adr_o}),
    .wbs_dat_o ({wb_reg_csr_dat_o, wb_regA_dat_o, wb_regB_dat_o, wb_regC_dat_o, wb_regD_dat_o, wb_m2s_resize_i2c_ms_cbuf_dat, wb_fifoA_dat_o, wb_fifoB_dat_o, wb_fifoC_dat_o, wb_fifoD_dat_o, wb_dac_spi_dat_o, wb_icx_spi_dat_o, wb_triggen_dat_o, wb_wb_tmem_dat_o}),
    .wbs_sel_o ({wb_reg_csr_sel_o, wb_regA_sel_o, wb_regB_sel_o, wb_regC_sel_o, wb_regD_sel_o, wb_m2s_resize_i2c_ms_cbuf_sel, wb_fifoA_sel_o, wb_fifoB_sel_o, wb_fifoC_sel_o, wb_fifoD_sel_o, wb_dac_spi_sel_o, wb_icx_spi_sel_o, wb_triggen_sel_o, wb_wb_tmem_sel_o}),
    .wbs_we_o  ({wb_reg_csr_we_o, wb_regA_we_o, wb_regB_we_o, wb_regC_we_o, wb_regD_we_o, wb_m2s_resize_i2c_ms_cbuf_we, wb_fifoA_we_o, wb_fifoB_we_o, wb_fifoC_we_o, wb_fifoD_we_o, wb_dac_spi_we_o, wb_icx_spi_we_o, wb_triggen_we_o, wb_wb_tmem_we_o}),
    .wbs_cyc_o ({wb_reg_csr_cyc_o, wb_regA_cyc_o, wb_regB_cyc_o, wb_regC_cyc_o, wb_regD_cyc_o, wb_m2s_resize_i2c_ms_cbuf_cyc, wb_fifoA_cyc_o, wb_fifoB_cyc_o, wb_fifoC_cyc_o, wb_fifoD_cyc_o, wb_dac_spi_cyc_o, wb_icx_spi_cyc_o, wb_triggen_cyc_o, wb_wb_tmem_cyc_o}),
    .wbs_stb_o ({wb_reg_csr_stb_o, wb_regA_stb_o, wb_regB_stb_o, wb_regC_stb_o, wb_regD_stb_o, wb_m2s_resize_i2c_ms_cbuf_stb, wb_fifoA_stb_o, wb_fifoB_stb_o, wb_fifoC_stb_o, wb_fifoD_stb_o, wb_dac_spi_stb_o, wb_icx_spi_stb_o, wb_triggen_stb_o, wb_wb_tmem_stb_o}),
    .wbs_cti_o ({wb_reg_csr_cti_o, wb_regA_cti_o, wb_regB_cti_o, wb_regC_cti_o, wb_regD_cti_o, wb_m2s_resize_i2c_ms_cbuf_cti, wb_fifoA_cti_o, wb_fifoB_cti_o, wb_fifoC_cti_o, wb_fifoD_cti_o, wb_dac_spi_cti_o, wb_icx_spi_cti_o, wb_triggen_cti_o, wb_wb_tmem_cti_o}),
    .wbs_bte_o ({wb_reg_csr_bte_o, wb_regA_bte_o, wb_regB_bte_o, wb_regC_bte_o, wb_regD_bte_o, wb_m2s_resize_i2c_ms_cbuf_bte, wb_fifoA_bte_o, wb_fifoB_bte_o, wb_fifoC_bte_o, wb_fifoD_bte_o, wb_dac_spi_bte_o, wb_icx_spi_bte_o, wb_triggen_bte_o, wb_wb_tmem_bte_o}),
    .wbs_dat_i ({wb_reg_csr_dat_i, wb_regA_dat_i, wb_regB_dat_i, wb_regC_dat_i, wb_regD_dat_i, wb_s2m_resize_i2c_ms_cbuf_dat, wb_fifoA_dat_i, wb_fifoB_dat_i, wb_fifoC_dat_i, wb_fifoD_dat_i, wb_dac_spi_dat_i, wb_icx_spi_dat_i, wb_triggen_dat_i, wb_wb_tmem_dat_i}),
    .wbs_ack_i ({wb_reg_csr_ack_i, wb_regA_ack_i, wb_regB_ack_i, wb_regC_ack_i, wb_regD_ack_i, wb_s2m_resize_i2c_ms_cbuf_ack, wb_fifoA_ack_i, wb_fifoB_ack_i, wb_fifoC_ack_i, wb_fifoD_ack_i, wb_dac_spi_ack_i, wb_icx_spi_ack_i, wb_triggen_ack_i, wb_wb_tmem_ack_i}),
    .wbs_err_i ({wb_reg_csr_err_i, wb_regA_err_i, wb_regB_err_i, wb_regC_err_i, wb_regD_err_i, wb_s2m_resize_i2c_ms_cbuf_err, wb_fifoA_err_i, wb_fifoB_err_i, wb_fifoC_err_i, wb_fifoD_err_i, wb_dac_spi_err_i, wb_icx_spi_err_i, wb_triggen_err_i, wb_wb_tmem_err_i}),
    .wbs_rty_i ({wb_reg_csr_rty_i, wb_regA_rty_i, wb_regB_rty_i, wb_regC_rty_i, wb_regD_rty_i, wb_s2m_resize_i2c_ms_cbuf_rty, wb_fifoA_rty_i, wb_fifoB_rty_i, wb_fifoC_rty_i, wb_fifoD_rty_i, wb_dac_spi_rty_i, wb_icx_spi_rty_i, wb_triggen_rty_i, wb_wb_tmem_rty_i}));

wb_data_resize
  #(.aw  (32),
    .mdw (32),
    .sdw (8))
 wb_data_resize_i2c_ms_cbuf
   (.wbm_adr_i (wb_m2s_resize_i2c_ms_cbuf_adr),
    .wbm_dat_i (wb_m2s_resize_i2c_ms_cbuf_dat),
    .wbm_sel_i (wb_m2s_resize_i2c_ms_cbuf_sel),
    .wbm_we_i  (wb_m2s_resize_i2c_ms_cbuf_we),
    .wbm_cyc_i (wb_m2s_resize_i2c_ms_cbuf_cyc),
    .wbm_stb_i (wb_m2s_resize_i2c_ms_cbuf_stb),
    .wbm_cti_i (wb_m2s_resize_i2c_ms_cbuf_cti),
    .wbm_bte_i (wb_m2s_resize_i2c_ms_cbuf_bte),
    .wbm_dat_o (wb_s2m_resize_i2c_ms_cbuf_dat),
    .wbm_ack_o (wb_s2m_resize_i2c_ms_cbuf_ack),
    .wbm_err_o (wb_s2m_resize_i2c_ms_cbuf_err),
    .wbm_rty_o (wb_s2m_resize_i2c_ms_cbuf_rty),
    .wbs_adr_o (wb_i2c_ms_cbuf_adr_o),
    .wbs_dat_o (wb_i2c_ms_cbuf_dat_o),
    .wbs_we_o  (wb_i2c_ms_cbuf_we_o),
    .wbs_cyc_o (wb_i2c_ms_cbuf_cyc_o),
    .wbs_stb_o (wb_i2c_ms_cbuf_stb_o),
    .wbs_cti_o (wb_i2c_ms_cbuf_cti_o),
    .wbs_bte_o (wb_i2c_ms_cbuf_bte_o),
    .wbs_dat_i (wb_i2c_ms_cbuf_dat_i),
    .wbs_ack_i (wb_i2c_ms_cbuf_ack_i),
    .wbs_err_i (wb_i2c_ms_cbuf_err_i),
    .wbs_rty_i (wb_i2c_ms_cbuf_rty_i));

endmodule
