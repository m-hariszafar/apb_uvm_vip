  import uvm_pkg::*;
    `include "apb_transaction.sv"
	`include "apb_sequences.sv"
    `include "apb_wr_sequence.sv"
    `include "apb_rd_sequence.sv"
    `include "apb_sequencer.sv"
	`include "apb_driver.sv"
	`include "apb_coverage.sv"
	`include "apb_monitor.sv"
	`include "apb_agent.sv"
	`include "apb_scoreboard.sv"
	`include "apb_env.sv"
	`include "apb_test.sv"
  `include "apb_interface.sv"
  `include "../src/apb_v3_sram.v"
module apb_tb_top();

  apb_interface vif();

  apb_v3_sram dut(  .PRESETn(vif.presetn),
                    .PCLK(vif.pclk),
                    .PSEL(vif.pselx),
                    .PENABLE(vif.penable),
                    .PWRITE(vif.pwrite),
                    .PADDR(vif.paddr),
                    .PWDATA(vif.pwdata),
                    .PRDATA(vif.prdata),
                    .PREADY(vif.pready),
                    .PSLVERR(vif.pslverr)
                    );

  initial begin
    uvm_config_db #(virtual apb_interface)::set(null,"*","apb_vif",vif);
    run_test();
  end

  initial begin
    $dumpfile("waves.vcd");
    $dumpvars();
  end

  initial begin
    vif.pclk = 0;
  end

  always 
    #5 vif.pclk = ~vif.pclk;

endmodule

