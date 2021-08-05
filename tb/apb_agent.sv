class apb_agent extends uvm_agent;
  `uvm_component_utils(apb_agent)

  function new (string name="apb_agent", uvm_component parent=null);
    super.new(name,parent);
  endfunction

  apb_driver drv;
  apb_monitor mon;
  apb_sequencer sqr;
  apb_coverage cov;

  virtual function void build_phase (uvm_phase phase);
    super.build_phase(phase);
    drv = apb_driver::type_id::create("drv",this);
    mon = apb_monitor::type_id::create("mon",this);
    sqr = apb_sequencer::type_id::create("sqr",this);
	cov = apb_coverage::type_id::create("cov",this);
  endfunction

  virtual function void connect_phase (uvm_phase phase);
    super.connect_phase(phase);
    drv.seq_item_port.connect(sqr.seq_item_export);
	mon.cov_port.connect(cov.analysis_export);
  endfunction

endclass
