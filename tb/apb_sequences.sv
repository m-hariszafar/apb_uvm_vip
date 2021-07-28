class apb_sequences extends uvm_sequences#(apb_transaction);
  `uvm_object_utils(apb_sequences)

  function new (string name = "apb_sequences");
    super.new(name);
  endfunction

  apb_transaction item;

  virtual task body();
    `uvm_do(item)
  endtask

endclass
