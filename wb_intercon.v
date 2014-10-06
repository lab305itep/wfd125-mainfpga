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
    output [31:0] wb_simple_gpio_adr_o,
    output [31:0] wb_simple_gpio_dat_o,
    output  [3:0] wb_simple_gpio_sel_o,
    output        wb_simple_gpio_we_o,
    output        wb_simple_gpio_cyc_o,
    output        wb_simple_gpio_stb_o,
    output  [2:0] wb_simple_gpio_cti_o,
    output  [1:0] wb_simple_gpio_bte_o,
    input  [31:0] wb_simple_gpio_dat_i,
    input         wb_simple_gpio_ack_i,
    input         wb_simple_gpio_err_i,
    input         wb_simple_gpio_rty_i,
    output [31:0] wb_mymemA_adr_o,
    output [31:0] wb_mymemA_dat_o,
    output  [3:0] wb_mymemA_sel_o,
    output        wb_mymemA_we_o,
    output        wb_mymemA_cyc_o,
    output        wb_mymemA_stb_o,
    output  [2:0] wb_mymemA_cti_o,
    output  [1:0] wb_mymemA_bte_o,
    input  [31:0] wb_mymemA_dat_i,
    input         wb_mymemA_ack_i,
    input         wb_mymemA_err_i,
    input         wb_mymemA_rty_i,
    output [31:0] wb_mymemB_adr_o,
    output [31:0] wb_mymemB_dat_o,
    output  [3:0] wb_mymemB_sel_o,
    output        wb_mymemB_we_o,
    output        wb_mymemB_cyc_o,
    output        wb_mymemB_stb_o,
    output  [2:0] wb_mymemB_cti_o,
    output  [1:0] wb_mymemB_bte_o,
    input  [31:0] wb_mymemB_dat_i,
    input         wb_mymemB_ack_i,
    input         wb_mymemB_err_i,
    input         wb_mymemB_rty_i,
    output [31:0] wb_mymemC_adr_o,
    output [31:0] wb_mymemC_dat_o,
    output  [3:0] wb_mymemC_sel_o,
    output        wb_mymemC_we_o,
    output        wb_mymemC_cyc_o,
    output        wb_mymemC_stb_o,
    output  [2:0] wb_mymemC_cti_o,
    output  [1:0] wb_mymemC_bte_o,
    input  [31:0] wb_mymemC_dat_i,
    input         wb_mymemC_ack_i,
    input         wb_mymemC_err_i,
    input         wb_mymemC_rty_i,
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
    output [31:0] wb_mymemD_adr_o,
    output [31:0] wb_mymemD_dat_o,
    output  [3:0] wb_mymemD_sel_o,
    output        wb_mymemD_we_o,
    output        wb_mymemD_cyc_o,
    output        wb_mymemD_stb_o,
    output  [2:0] wb_mymemD_cti_o,
    output  [1:0] wb_mymemD_bte_o,
    input  [31:0] wb_mymemD_dat_i,
    input         wb_mymemD_ack_i,
    input         wb_mymemD_err_i,
    input         wb_mymemD_rty_i,
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
    input         wb_dac_spi_rty_i);

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
  #(.num_slaves (8),
    .MATCH_ADDR ({32'h00010000, 32'h00020000, 32'h00040000, 32'h00060000, 32'h00080000, 32'h000a0000, 32'h00010020, 32'h00010010}),
    .MATCH_MASK ({32'hfffffff8, 32'hffffffe0, 32'hfffff800, 32'hfffff800, 32'hfffff800, 32'hfffff800, 32'hfffffff8, 32'hfffffff8}))
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
    .wbs_adr_o ({wb_simple_gpio_adr_o, wb_m2s_resize_i2c_ms_cbuf_adr, wb_mymemA_adr_o, wb_mymemB_adr_o, wb_mymemC_adr_o, wb_mymemD_adr_o, wb_dac_spi_adr_o, wb_icx_spi_adr_o}),
    .wbs_dat_o ({wb_simple_gpio_dat_o, wb_m2s_resize_i2c_ms_cbuf_dat, wb_mymemA_dat_o, wb_mymemB_dat_o, wb_mymemC_dat_o, wb_mymemD_dat_o, wb_dac_spi_dat_o, wb_icx_spi_dat_o}),
    .wbs_sel_o ({wb_simple_gpio_sel_o, wb_m2s_resize_i2c_ms_cbuf_sel, wb_mymemA_sel_o, wb_mymemB_sel_o, wb_mymemC_sel_o, wb_mymemD_sel_o, wb_dac_spi_sel_o, wb_icx_spi_sel_o}),
    .wbs_we_o  ({wb_simple_gpio_we_o, wb_m2s_resize_i2c_ms_cbuf_we, wb_mymemA_we_o, wb_mymemB_we_o, wb_mymemC_we_o, wb_mymemD_we_o, wb_dac_spi_we_o, wb_icx_spi_we_o}),
    .wbs_cyc_o ({wb_simple_gpio_cyc_o, wb_m2s_resize_i2c_ms_cbuf_cyc, wb_mymemA_cyc_o, wb_mymemB_cyc_o, wb_mymemC_cyc_o, wb_mymemD_cyc_o, wb_dac_spi_cyc_o, wb_icx_spi_cyc_o}),
    .wbs_stb_o ({wb_simple_gpio_stb_o, wb_m2s_resize_i2c_ms_cbuf_stb, wb_mymemA_stb_o, wb_mymemB_stb_o, wb_mymemC_stb_o, wb_mymemD_stb_o, wb_dac_spi_stb_o, wb_icx_spi_stb_o}),
    .wbs_cti_o ({wb_simple_gpio_cti_o, wb_m2s_resize_i2c_ms_cbuf_cti, wb_mymemA_cti_o, wb_mymemB_cti_o, wb_mymemC_cti_o, wb_mymemD_cti_o, wb_dac_spi_cti_o, wb_icx_spi_cti_o}),
    .wbs_bte_o ({wb_simple_gpio_bte_o, wb_m2s_resize_i2c_ms_cbuf_bte, wb_mymemA_bte_o, wb_mymemB_bte_o, wb_mymemC_bte_o, wb_mymemD_bte_o, wb_dac_spi_bte_o, wb_icx_spi_bte_o}),
    .wbs_dat_i ({wb_simple_gpio_dat_i, wb_s2m_resize_i2c_ms_cbuf_dat, wb_mymemA_dat_i, wb_mymemB_dat_i, wb_mymemC_dat_i, wb_mymemD_dat_i, wb_dac_spi_dat_i, wb_icx_spi_dat_i}),
    .wbs_ack_i ({wb_simple_gpio_ack_i, wb_s2m_resize_i2c_ms_cbuf_ack, wb_mymemA_ack_i, wb_mymemB_ack_i, wb_mymemC_ack_i, wb_mymemD_ack_i, wb_dac_spi_ack_i, wb_icx_spi_ack_i}),
    .wbs_err_i ({wb_simple_gpio_err_i, wb_s2m_resize_i2c_ms_cbuf_err, wb_mymemA_err_i, wb_mymemB_err_i, wb_mymemC_err_i, wb_mymemD_err_i, wb_dac_spi_err_i, wb_icx_spi_err_i}),
    .wbs_rty_i ({wb_simple_gpio_rty_i, wb_s2m_resize_i2c_ms_cbuf_rty, wb_mymemA_rty_i, wb_mymemB_rty_i, wb_mymemC_rty_i, wb_mymemD_rty_i, wb_dac_spi_rty_i, wb_icx_spi_rty_i}));

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
