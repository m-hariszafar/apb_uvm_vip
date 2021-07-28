class apb_transaction extends uvm_sequence_item;

  rand bit [31:0] padder;
  rand bit pwrite;
  rand bit [31:0] pwdata; 
  bit [31:0] prdata;

  `uvm_object_utils_begin(apb_transaction)
    `uvm_field_int(padder,UVM_DEFAULT)
    `uvm_field_int(pwrite, UVM_DEFAULT)
    `uvm_field_int(pwdata,UVM_DEFAULT)
    `uvm_field_int(prdata,UVM_DEFAULT)
  `uvm_object_utils_end

  function new (string name = "apb_transaction");
    super.new(name);
  endfunction

endclass
