class apb_test extends uvm_test;
  `uvm_component_utils(apb_test)

  function new (string name="apb_test", uvm_component parent=null);
    super.new(name,parent);
  endfunction 

  apb_env env;
	apb_sequences seq;
  
  virtual function void build_phase (uvm_phase phase);
    super.build_phase(phase);
    env = apb_env::type_id::create("env",this);
		seq = apb_sequences::type_id::create("seq");
  endfunction

  task run_phase (uvm_phase phase);
    super.run_phase (phase);

    phase.raise_objection (this);
		/*for (int i=0; i<5; i++)
			wr_data(128*i,i,1); //directed write-seq: wr_data,wr_addr,iteration
		for (int i=0; i<5; i++)
			rd_data(i,1);	*/	//directed read-seq: rd_addr,iteration
		rand_data(1000);		//random seq: iteration
    phase.drop_objection (this);

  endtask

	virtual task wr_data (input logic [15:0] data, input logic [3:0] addr, input logic [3:0] iteration);
		apb_wr_sequence wr_seq;

		wr_seq = apb_wr_sequence::type_id::create("wr_seq");

		wr_seq.data = data;
		wr_seq.addr = addr;
		wr_seq.iteration = iteration;

		wr_seq.start(env.agent.sqr);
	endtask

	virtual task rd_data (input logic [3:0] addr, iteration);
		apb_rd_sequence rd_seq;

		rd_seq = apb_rd_sequence::type_id::create("rd_seq");

		rd_seq.addr = addr;
		rd_seq.iteration = iteration;

		rd_seq.start(env.agent.sqr);
	endtask

	virtual task rand_data (input logic [31:0] iteration);
		apb_sequences rand_seq;

		rand_seq = apb_sequences::type_id::create("rand_seq");
		rand_seq.iteration = iteration;

		rand_seq.start(env.agent.sqr);
	endtask

endclass
