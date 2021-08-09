interface apb_interface;
  logic pclk;
  logic presetn;

  logic pselx;

  logic pwrite;
  logic [3:0] paddr;
  logic [15:0] pwdata; 

  logic penable;

  logic pready;
  logic [15:0] prdata;
  logic pslverr;
/*
  clocking cb @(posedge pclk);
//    default input #1ns output #1ns; 
    output pselx;
    output presetn;

    output pwrite;
    output paddr;
    output pwdata; 

    output penable;

    input pready;
    input prdata;
    input pslverr;
  endclocking

  clocking cb_mon @(posedge pclk);
 //   default input #1ns output #1ns; 
    input pselx;
    input presetn;

    input pwrite;
    input paddr;
    input pwdata; 

    input penable;

    input pready;
    input prdata;
    input pslverr;
  endclocking
  */

endinterface
