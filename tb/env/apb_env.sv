class apb_env extends uvm_env;
  `uvm_component_utils(apb_env)

  function new (string name="apb_env", uvm_component parent=null);
    super.new(name,parent);
  endfunction

  apb_agent agent;
  apb_scoreboard scoreboard;

  virtual function void build_phase (uvm_phase phase);
      super.build_phase(phase);
      agent = apb_agent::type_id::create("agent",this);
      scoreboard = apb_scoreboard::type_id::create("scoreboard",this);
  endfunction 

  virtual function void connect_phase (uvm_phase phase);
    super.connect_phase(phase);
    agent.mon.mon_port.connect(scoreboard.mon2scb_port);
    agent.drv.drv_port.connect(scoreboard.drv2scb_port);
  endfunction

endclass
