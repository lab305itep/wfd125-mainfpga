// THIS FILE IS AUTOGENERATED BY wb_intercon_gen
// ANY MANUAL CHANGES WILL BE LOST
wire [31:0] wb_m2s_VME64xCore_Top_adr;
wire [31:0] wb_m2s_VME64xCore_Top_dat;
wire  [3:0] wb_m2s_VME64xCore_Top_sel;
wire        wb_m2s_VME64xCore_Top_we;
wire        wb_m2s_VME64xCore_Top_cyc;
wire        wb_m2s_VME64xCore_Top_stb;
wire  [2:0] wb_m2s_VME64xCore_Top_cti;
wire  [1:0] wb_m2s_VME64xCore_Top_bte;
wire [31:0] wb_s2m_VME64xCore_Top_dat;
wire        wb_s2m_VME64xCore_Top_ack;
wire        wb_s2m_VME64xCore_Top_err;
wire        wb_s2m_VME64xCore_Top_rty;
wire [31:0] wb_m2s_simple_gpio_adr;
wire [31:0] wb_m2s_simple_gpio_dat;
wire  [3:0] wb_m2s_simple_gpio_sel;
wire        wb_m2s_simple_gpio_we;
wire        wb_m2s_simple_gpio_cyc;
wire        wb_m2s_simple_gpio_stb;
wire  [2:0] wb_m2s_simple_gpio_cti;
wire  [1:0] wb_m2s_simple_gpio_bte;
wire [31:0] wb_s2m_simple_gpio_dat;
wire        wb_s2m_simple_gpio_ack;
wire        wb_s2m_simple_gpio_err;
wire        wb_s2m_simple_gpio_rty;
wire [31:0] wb_m2s_i2c_ms_cbuf_adr;
wire  [7:0] wb_m2s_i2c_ms_cbuf_dat;
wire  [3:0] wb_m2s_i2c_ms_cbuf_sel;
wire        wb_m2s_i2c_ms_cbuf_we;
wire        wb_m2s_i2c_ms_cbuf_cyc;
wire        wb_m2s_i2c_ms_cbuf_stb;
wire  [2:0] wb_m2s_i2c_ms_cbuf_cti;
wire  [1:0] wb_m2s_i2c_ms_cbuf_bte;
wire  [7:0] wb_s2m_i2c_ms_cbuf_dat;
wire        wb_s2m_i2c_ms_cbuf_ack;
wire        wb_s2m_i2c_ms_cbuf_err;
wire        wb_s2m_i2c_ms_cbuf_rty;
wire [31:0] wb_m2s_mymem_adr;
wire [31:0] wb_m2s_mymem_dat;
wire  [3:0] wb_m2s_mymem_sel;
wire        wb_m2s_mymem_we;
wire        wb_m2s_mymem_cyc;
wire        wb_m2s_mymem_stb;
wire  [2:0] wb_m2s_mymem_cti;
wire  [1:0] wb_m2s_mymem_bte;
wire [31:0] wb_s2m_mymem_dat;
wire        wb_s2m_mymem_ack;
wire        wb_s2m_mymem_err;
wire        wb_s2m_mymem_rty;

wb_intercon wb_intercon0
   (.wb_clk_i                (wb_clk),
    .wb_rst_i                (wb_rst),
    .wb_VME64xCore_Top_adr_i (wb_m2s_VME64xCore_Top_adr),
    .wb_VME64xCore_Top_dat_i (wb_m2s_VME64xCore_Top_dat),
    .wb_VME64xCore_Top_sel_i (wb_m2s_VME64xCore_Top_sel),
    .wb_VME64xCore_Top_we_i  (wb_m2s_VME64xCore_Top_we),
    .wb_VME64xCore_Top_cyc_i (wb_m2s_VME64xCore_Top_cyc),
    .wb_VME64xCore_Top_stb_i (wb_m2s_VME64xCore_Top_stb),
    .wb_VME64xCore_Top_cti_i (wb_m2s_VME64xCore_Top_cti),
    .wb_VME64xCore_Top_bte_i (wb_m2s_VME64xCore_Top_bte),
    .wb_VME64xCore_Top_dat_o (wb_s2m_VME64xCore_Top_dat),
    .wb_VME64xCore_Top_ack_o (wb_s2m_VME64xCore_Top_ack),
    .wb_VME64xCore_Top_err_o (wb_s2m_VME64xCore_Top_err),
    .wb_VME64xCore_Top_rty_o (wb_s2m_VME64xCore_Top_rty),
    .wb_simple_gpio_adr_o    (wb_m2s_simple_gpio_adr),
    .wb_simple_gpio_dat_o    (wb_m2s_simple_gpio_dat),
    .wb_simple_gpio_sel_o    (wb_m2s_simple_gpio_sel),
    .wb_simple_gpio_we_o     (wb_m2s_simple_gpio_we),
    .wb_simple_gpio_cyc_o    (wb_m2s_simple_gpio_cyc),
    .wb_simple_gpio_stb_o    (wb_m2s_simple_gpio_stb),
    .wb_simple_gpio_cti_o    (wb_m2s_simple_gpio_cti),
    .wb_simple_gpio_bte_o    (wb_m2s_simple_gpio_bte),
    .wb_simple_gpio_dat_i    (wb_s2m_simple_gpio_dat),
    .wb_simple_gpio_ack_i    (wb_s2m_simple_gpio_ack),
    .wb_simple_gpio_err_i    (wb_s2m_simple_gpio_err),
    .wb_simple_gpio_rty_i    (wb_s2m_simple_gpio_rty),
    .wb_i2c_ms_cbuf_adr_o    (wb_m2s_i2c_ms_cbuf_adr),
    .wb_i2c_ms_cbuf_dat_o    (wb_m2s_i2c_ms_cbuf_dat),
    .wb_i2c_ms_cbuf_sel_o    (wb_m2s_i2c_ms_cbuf_sel),
    .wb_i2c_ms_cbuf_we_o     (wb_m2s_i2c_ms_cbuf_we),
    .wb_i2c_ms_cbuf_cyc_o    (wb_m2s_i2c_ms_cbuf_cyc),
    .wb_i2c_ms_cbuf_stb_o    (wb_m2s_i2c_ms_cbuf_stb),
    .wb_i2c_ms_cbuf_cti_o    (wb_m2s_i2c_ms_cbuf_cti),
    .wb_i2c_ms_cbuf_bte_o    (wb_m2s_i2c_ms_cbuf_bte),
    .wb_i2c_ms_cbuf_dat_i    (wb_s2m_i2c_ms_cbuf_dat),
    .wb_i2c_ms_cbuf_ack_i    (wb_s2m_i2c_ms_cbuf_ack),
    .wb_i2c_ms_cbuf_err_i    (wb_s2m_i2c_ms_cbuf_err),
    .wb_i2c_ms_cbuf_rty_i    (wb_s2m_i2c_ms_cbuf_rty),
    .wb_mymem_adr_o          (wb_m2s_mymem_adr),
    .wb_mymem_dat_o          (wb_m2s_mymem_dat),
    .wb_mymem_sel_o          (wb_m2s_mymem_sel),
    .wb_mymem_we_o           (wb_m2s_mymem_we),
    .wb_mymem_cyc_o          (wb_m2s_mymem_cyc),
    .wb_mymem_stb_o          (wb_m2s_mymem_stb),
    .wb_mymem_cti_o          (wb_m2s_mymem_cti),
    .wb_mymem_bte_o          (wb_m2s_mymem_bte),
    .wb_mymem_dat_i          (wb_s2m_mymem_dat),
    .wb_mymem_ack_i          (wb_s2m_mymem_ack),
    .wb_mymem_err_i          (wb_s2m_mymem_err),
    .wb_mymem_rty_i          (wb_s2m_mymem_rty));

