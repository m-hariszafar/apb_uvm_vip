class apb_transaction extends uvm_sequence_item;

  rand bit [3:0] paddr;
  rand bit [15:0] pwdata; 
  rand bit pwrite;

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

//  constraint low_data {pwdata <= (2**8)-1 ;}
//	constraint high_data {pwdata inside {[2**8:2**9]}; }
//	constraint all_value {pwdata dist {[0:2**4]:=20,[2**5:2**8]:=20, [2**8:2**15]:=60}; } 

endclass
