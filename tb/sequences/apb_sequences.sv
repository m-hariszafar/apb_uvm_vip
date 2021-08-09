class apb_sequences extends uvm_sequence#(apb_transaction);
  `uvm_object_utils(apb_sequences)

  function new (string name = "apb_sequences");
    super.new(name);
  endfunction

  apb_transaction item;

	logic [31:0] iteration;
    logic [15:0] data;
    logic [3:0] addr;

  virtual task body();
	repeat(iteration) begin
		`uvm_do(item);
	end
  endtask

endclass
