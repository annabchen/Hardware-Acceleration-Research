// outer wrapper:
module rect_loop
  #(parameter
    ROW_LEN = 4,
    COL_LEN = 4) // hard coding the matrix size as of now
   (input logic [31:0] instr, /*instr is a 32-bit encoded variable for providing instructions. lower 12 bits = num swaps*/
    input logic inM[ROW_LEN][COL_LEN],
    output logic outM[ROW_LEN][COL_LEN]);

    // decoding instr to find num of loops
    int numloops = instr[11:0];
    
    initial begin
      for (int i = 0; i < numloops; i++) begin
        // call swap locating module
        swap_locate #(ROW_LEN, COL_LEN) sl(.inM(inM), .outM(outM));
        inM = sl;
      end
    end
endmodule



// swap locating module- determines indices of next attempted swap
module swap_locate
  #(parameter
    ROW_LEN = 4, // can also pass these along as an input atp
    COL_LEN = 4)
   (input logic inM[ROW_LEN][COL_LEN],
    output logic outM[ROW_LEN][COL_LEN]);

    // randomly generate r1 and c1
    int r1 = $urandom_range(0, ROW_LEN-1);
    int c1 = $urandom_range(0, COL_LEN-1);
    int r2 = $urandom_range(0, ROW_LEN-1);
    int c2 = $urandom_range(0, COL_LEN-1);

    // generating confirming values for r2 and c2
  initial begin
    while (inM[r1][c1] == inM[r1][c2]) begin
      r2 = $urandom_range(0, ROW_LEN-1);
    end
  end

  initial begin
    while(inM[r1][c1] != inM[r2][c2]) begin
      c2 = $urandom_range(0, COL_LEN-1);
    end
  end
  // call to swapping module
  swapping #(ROW_LEN, COL_LEN) s(.inM(inM), .r1(r1), .r2(r2), .c1(c1), .c2(c2), .outM(outM));
endmodule



// swapping module- simply complete the swap
module swapping
  #(parameter
    ROW_LEN = 4,
    COL_LEN = 4) 
  (input logic [3:0] inM[4][4], // 4x4 array for now
   input logic [1:0] r1, 		// just needs to be log2(num of squares) long, should be logics instead of ints
   input logic [1:0] r2,
   input logic [1:0] c1,
   input logic [1:0] c2,
   input logic clk,	  			// should have a clk input in case we want it to happen at the same time as another module
   output logic [3:0] outM[4][4]);

  
  // copying over initial array-- NOT necessary!
  
  // not the original values to flip them
  always @(posedge clk)
	begin
      	outM[r1][c1] = ~(inM[r1][c1]); // use non-blocking statements here so they all happen at once
  		outM[r1][c2] = ~(inM[r1][c2]);
 		outM[r2][c1] = ~(inM[r2][c1]);
  		outM[r2][c2] = ~(inM[r2][c2]);
    end
    
endmodule
