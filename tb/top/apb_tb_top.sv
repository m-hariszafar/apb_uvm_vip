 import uvm_pkg::*;
	`include "tb/package/apb_package.sv"
	`include "tb/top/apb_interface.sv" 
	`include "src/apb_v3_sram.v"
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

