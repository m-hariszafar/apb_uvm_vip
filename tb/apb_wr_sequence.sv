class apb_wr_sequence extends apb_sequences;
    `uvm_object_utils(apb_wr_sequence)

	logic [3:0] iteration;

    function new (string name="apb_wr_sequence");
        super.new(name);
    endfunction

    virtual task body();
		repeat(iteration) begin
        	`uvm_do_with(item,{ item.pwrite == 1;
								item.pwdata == local::data;
								item.paddr == local::addr;})
			
		end
    endtask

endclass
