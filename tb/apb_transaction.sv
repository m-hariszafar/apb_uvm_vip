class apb_transaction extends uvm_sequence_item;

  rand bit [3:0] paddr;
  rand bit pwrite;
  rand bit [15:0] pwdata; 
  bit [15:0] prdata;

  `uvm_object_utils_begin(apb_transaction)
    `uvm_field_int(paddr,UVM_DEFAULT)
    `uvm_field_int(pwrite, UVM_DEFAULT)
    `uvm_field_int(pwdata,UVM_DEFAULT)
    `uvm_field_int(prdata,UVM_DEFAULT)
  `uvm_object_utils_end

  function new (string name = "apb_transaction");
    super.new(name);
  endfunction

endclass
