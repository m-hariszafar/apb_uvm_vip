class apb_rd_sequence extends apb_sequences;
    `uvm_object_utils(apb_rd_sequence)

	logic [3:0] iteration;

    function new (string name="apb_rd_sequence");
        super.new(name);
    endfunction
    
    virtual task body();
		repeat(iteration) begin
        `uvm_do_with(item,{ item.pwrite == 0;
							item.paddr == local :: addr;})
		end
    endtask

endclass
