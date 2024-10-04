class SPI_scorboard extends uvm_scoreboard;
    `uvm_component_utils(SPI_scorboard)
    uvm_tlm_analysis_fifo  #(wishbone_trans) wishbone_in_fifo;
    uvm_tlm_analysis_fifo  #(slave_packet) slave_out_fifo;
    int num_error;
    int num_trans;

    //TODO slave enum sequence in
    wishbone_trans wishbone_in;
    slave_packet slave_out;

    bit [7:0] scbd_SPCR;
    bit [7:0] scbd_SPSR;
    bit [7:0] scbd_SPER;
    
    bit [7:0] Write_buffer[$:4];
    bit [7:0] Read_buffer[$:4];

    bit [1:0] write_replace;
    bit [1:0] read_replace;

    bit [7:0] slave_Read_in_buffer;
    bit [7:0] slave_write_out_buffer;
    bit [2:0] interrupt_count;



    function new(string name, uvm_component parent);
        super.new(name, parent);
        wishbone_in_fifo = new("wishbone_in_fifo", this);
        slave_out_fifo = new("slave_out_fifo", this);
        num_error = 0;
    endfunction

    task run_phase(uvm_phase phase);
      super.run_phase(phase);
      fork
        //THREAD1
        forever begin
          wishbone_in_fifo.get_peek_export.get(wishbone_in);
          if(wishbone_in.rst_i)begin
            scbd_SPCR = 8'h10;
            scbd_SPSR = 8'h05;
            scbd_SPER = 8'h00;
            write_replace = 0;
            read_replace = 0;
            interrupt_count = 0;
          end else if (wishbone_in.cyc_i && wishbone_in.stb_i) begin
              case(wishbone_in.adr_i)
                2'b00:  begin
                          if(wishbone_in.we_i)
                            scbd_SPCR = wishbone_in.dat_i;
                          else
                            num_error += better_compare("SPCR", wishbone_in.dat_o, scbd_SPCR, 8);
                        end
                2'b01:  begin
                          if(wishbone_in.we_i)
                            SPSR_mngr(wishbone_in.dat_i, 1);
                          else
                            num_error += better_compare("SPSR", wishbone_in.dat_o, scbd_SPSR, 8);
                        end
                2'b10:  begin
                          if(!scbd_SPCR[6])begin
                            Write_buffer = {};
                          end else if(wishbone_in.we_i) begin
                            if(Write_buffer.size() == 4)begin
                              SPSR_mngr(,,6,1);            
                              Write_buffer.delete(write_replace);
                              Write_buffer.insert(write_replace, wishbone_in.dat_i);
                              write_replace++;                  
                            end else begin
                              Write_buffer.push_back(wishbone_in.dat_i);
                            end
                          end else begin
                            num_error += better_compare("Read", wishbone_in.dat_o, Read_buffer.pop_front(), 8);
                          end
                        end
                2'b11:  begin
                          if(wishbone_in.we_i)
                            scbd_SPER = wishbone_in.dat_i;
                          else
                            num_error += better_compare("SPER", wishbone_in.dat_o, scbd_SPER, 8);
                        end
              endcase
          end
        end


        //THREAD2
        forever begin
          wait(scbd_SPCR[6]);
          wait(Write_buffer.size() != 0);
          slave_write_out_buffer = Write_buffer.pop_front();
          slave_out_fifo.get_peek_export.get(slave_out);

          num_error += better_compare("mosi", slave_out.out_val, slave_write_out_buffer, 8);
          
          if(Read_buffer.size() == 4)begin
            Read_buffer.delete(read_replace);
            Read_buffer.insert(read_replace, slave_out.in_val);
            read_replace++;                  
          end else begin
            Read_buffer.push_back(slave_out.in_val);
          end

          interrupt_count++;

          if(scbd_SPCR[7] && ((interrupt_count-1) == scbd_SPER[7:6]))begin
            interrupt_count = 0;
            SPSR_mngr(,,7,1);            
          end
        end

        //THREAD3
        forever begin
          #1
              case(Write_buffer.size())            
                0: begin 
                    SPSR_mngr(,,3,0);
                    SPSR_mngr(,,2,1);
                   end
                1: begin 
                    SPSR_mngr(,,3,0);
                    SPSR_mngr(,,2,0);
                   end
                2: begin 
                    SPSR_mngr(,,3,0);
                    SPSR_mngr(,,2,0);
                   end
                3: begin 
                    SPSR_mngr(,,3,0);
                    SPSR_mngr(,,2,0);
                   end
                4: begin 
                    SPSR_mngr(,,3,1);
                    SPSR_mngr(,,2,0);
                   end
              endcase

              case(Read_buffer.size())
                0: begin 
                    SPSR_mngr(,,1,0);
                    SPSR_mngr(,,0,1);
                   end
                1: begin 
                    SPSR_mngr(,,1,0);
                    SPSR_mngr(,,0,0);
                   end
                2: begin 
                    SPSR_mngr(,,1,0);
                    SPSR_mngr(,,0,0);
                   end
                3: begin 
                    SPSR_mngr(,,1,0);
                    SPSR_mngr(,,0,0);
                   end
                4: begin 
                    SPSR_mngr(,,1,1);
                    SPSR_mngr(,,0,0);
                   end
              endcase
        end
      join
    endtask

    


    function bit better_compare(string compare_name, int DUT_data, int scoreboard_data, int check_width);
      uvm_comparer compare;
      compare = new();
        if (!compare.compare_field(compare_name, DUT_data, scoreboard_data, check_width)) begin
        `uvm_error("Better Compare:", $sformatf("%s mismatch DUT %0d Scoreboard %0d", compare_name, DUT_data, scoreboard_data))
        return 1;
      end
      return 0;
    endfunction

    function void SPSR_mngr(bit [7:0] SPSR_write_val = 8'b0, bit write_or_set = 1'b0, bit [2:0]  pos = 3'b0, bit set_value = 1'b0);
        if(write_or_set)begin
          scbd_SPSR [7] = SPSR_write_val[7] ? (0) : (scbd_SPSR [7]);
          scbd_SPSR [6] = SPSR_write_val[6] ? (0) : (scbd_SPSR [6]);
          scbd_SPSR[5:0] = scbd_SPSR[5:0];
        end else begin
          scbd_SPSR[pos] = set_value;
        end
    endfunction

    // function void check_phase(uvm_phase phase);
    //   if(!(chan0_in_fifo.is_empty() && chan1_in_fifo.is_empty() && chan2_in_fifo.is_empty()))
    //     `uvm_error("FIFO_UVM", "fifo_still_full")
    // endfunction
endclass