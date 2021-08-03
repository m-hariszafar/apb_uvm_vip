class apb_driver extends uvm_driver #(apb_transaction);
  `uvm_component_utils(apb_driver)

  uvm_analysis_port #(apb_transaction) drv_port;

  function new (string name="apb_driver",uvm_component parent=null);
    super.new(name,parent);
  endfunction

  virtual apb_interface vif;


  virtual function void build_phase (uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(virtual apb_interface)::get(this,"","apb_vif",vif))
      `uvm_fatal("DRIVER","Could not get interface")
    drv_port = new("drv_port",this);
  endfunction

// Run phase: where write/read data transfer to dut
  virtual task run_phase(uvm_phase phase);
    super.run_phase(phase);
    reset();

    forever begin
      apb_transaction item;

      seq_item_port.get_next_item(item);
      `uvm_info(get_type_name(),$sformatf("Contents: %s",item.sprint()),UVM_LOW)
       drv_port.write(item);
       drive(item);
//       drv_port.write(item);
      seq_item_port.item_done();
    end
  endtask

  virtual task drive(apb_transaction item);
      if (item.pwrite)
        apb_write(item);
      else
        apb_read(item);
  endtask

// reset
  virtual task reset();
    @(posedge vif.pclk);
    vif.presetn <= 0;
    vif.pwrite <= 0;
    vif.pselx <= 0;
    vif.paddr <= 0;
    vif.pwdata <= 0;
    vif.penable <= 0;
    @(posedge vif.pclk);
    vif.presetn <= 1;
    @(posedge vif.pclk);
  endtask

// Task to transfer/write data 
  virtual task apb_write (apb_transaction item);
    vif.pwrite <= 1;
    vif.pselx <= 1;
    vif.paddr <= item.paddr;
    vif.pwdata <= item.pwdata;
    vif.penable <= 0;
 
    @(posedge vif.pclk);
    vif.penable <= 1;
    wait(vif.pready);

    @(posedge vif.pclk);
    vif.pselx <= 0;
    vif.penable <=0;

    @(posedge vif.pclk);
  endtask

// Task to receive/read data 
  virtual task apb_read (apb_transaction item);
    vif.pwrite <= 0;
    vif.pselx <= 1;
    vif.paddr <= item.paddr;
    vif.penable <= 0;

    @(posedge vif.pclk);
    vif.penable <= 1;
    wait(vif.pready);

    @(posedge vif.pclk);
    vif.penable <=0;
    vif.pselx <=0 ;

    @(posedge vif.pclk);
  endtask

endclass
