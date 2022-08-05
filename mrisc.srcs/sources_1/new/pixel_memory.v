module pixel_memory
 #(
//--------------------------------------------------------------------------


parameter   ADDR_WIDTH          =  10, 

// Addr  Width in bits : 2 *ADDR_WIDTH = RAM Depth
parameter   DATA_WIDTH      =  9  // Data  Width in bits
    //----------------------------------------------------------------------

  ) (
     input clkA,
     input enaA, 
     input weA,
     input [ADDR_WIDTH-1:0] addrA,
     input [DATA_WIDTH-1:0] dinA,
     output reg [DATA_WIDTH-1:0] doutA,
     output reg doa_ok


     );
   // Core Memory  
   reg [(DATA_WIDTH-1):0]   ram_block [(2**ADDR_WIDTH)-1:0];

   // Port-A Operation
  always @ (posedge clkA) 
  begin
     if(enaA) 
     begin         
            if(weA) 
            begin
               ram_block[addrA][(DATA_WIDTH-1):0] <= dinA[(DATA_WIDTH-1):0];
            end         
         doutA <= ram_block[addrA][(DATA_WIDTH-1):0]; 
         doa_ok<=1'b1;
         end
      else 
        doa_ok<=1'b0;    
   end

endmodule // bytewrite_tdp_ram_rf