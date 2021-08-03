`uvm_analysis_imp_decl (_drv2scb)
`uvm_analysis_imp_decl (_mon2scb)

class apb_scoreboard extends uvm_scoreboard;
  `uvm_component_utils(apb_scoreboard)

  uvm_analysis_imp_mon2scb #(apb_transaction,apb_scoreboard) mon2scb_port;
  uvm_analysis_imp_drv2scb #(apb_transaction,apb_scoreboard) drv2scb_port;

  apb_transaction mon_q[$];
  apb_transaction drv_q[$];

  apb_transaction item;
  apb_transaction exp_item;
  apb_transaction rec_item;

  logic [15:0]ref_mem[0:15] ;
  logic [15:0] expected_data;

  function new (string name="apb_scoreboard", uvm_component parent=null);
    super.new(name,parent);
  endfunction

  virtual function void build_phase (uvm_phase phase);
    super.build_phase(phase);
    mon2scb_port = new ("mon2scb_port",this);
    drv2scb_port = new ("drv2scb_port",this);
    item = new("item");
    exp_item = new("exp_item");
    rec_item = new("rec_item");
  endfunction

  virtual task run_phase (uvm_phase phase);
    super.run_phase(phase);
    clear_memory();
    forever begin
      wait(mon_q.size !=0);
      rec_item = mon_q.pop_front();
      expected_data = ref_mem[rec_item.paddr];
      
      if (expected_data == rec_item.prdata)
        `uvm_info("Compare",{"TEST: PASS"},UVM_LOW)
      else begin
        `uvm_error("Compare","TEST: FAILED")
        $display("Expected Data %0h",expected_data);
      end
    end
  endtask

  virtual function clear_memory();
    for (int i=0; i < 16; i++)
      ref_mem[i] = 16'h0;
  endfunction

  virtual function void write_mon2scb (apb_transaction item);
    if (!item.pwrite) begin
      $display("MON-2-SCB"," Item received");
      item.print();
      mon_q.push_back(item);
    end
  endfunction

  virtual function void write_drv2scb (apb_transaction item);
      if (item.pwrite) begin
        $display("DRV-2-SCB"," Item received");
        item.print();
        ref_mem[item.paddr] = item.pwdata; 
        drv_q.push_back(item);
      end
  endfunction

endclass
