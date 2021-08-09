class apb_monitor extends uvm_monitor #(apb_transaction);
  `uvm_component_utils(apb_monitor)

  virtual apb_interface vif;

  uvm_analysis_port#(apb_transaction) mon_port;
  uvm_analysis_port#(apb_transaction) cov_port;

	apb_transaction item;

  function new (string name="apb_monitor", uvm_component parent =null);
    super.new(name,parent);
  endfunction

  virtual function void build_phase (uvm_phase phase);
    super.build_phase(phase);

    if (!uvm_config_db#(virtual apb_interface)::get(this,"","apb_vif",vif))
      `uvm_fatal("MONITOR","Could not get interface")
    
    mon_port = new("mon_port",this);  
	cov_port = new("cov_port",this);
  endfunction

  virtual task run_phase (uvm_phase phase);
    super.run_phase(phase);
    sample_data();
  endtask

  virtual task sample_data();
    forever begin
       @(posedge vif.pclk);
       if (vif.pselx) begin     // setup transfer
          @(posedge vif.pclk iff vif.penable) begin   // access transfer
            item = apb_transaction::type_id::create("item",this);

            wait (vif.pready);
            item.pwrite = vif.pwrite;
            item.paddr = vif.paddr;
            item.pwdata = vif.pwdata;
            @(posedge vif.pclk);
            item.prdata = vif.prdata;

			cov_port.write(item);

			if (!vif.pwrite) begin
            	`uvm_info(get_type_name(),$sformatf("Read Contents: %s",item.sprint()),UVM_LOW)
            	mon_port.write(item);
			end
          end
       end
    end
  endtask

endclass
