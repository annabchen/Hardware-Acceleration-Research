// outer wrapper:
module rect_loop
  #(parameter
    ROW_LEN = 4,
    COL_LEN = 4) // hard coding the matrix size as of now
   (input logic [31:0] instr, /*instr is a 32-bit encoded variable for providing instructions. lower 12 bits = num swaps*/
    input logic inM[ROW_LEN][COL_LEN],
    output logic outM[ROW_LEN][COL_LEN]);

    // decoding instr to find num of loops
    logic numloops = instr[11:0];
    
    initial begin
      for (int i = 0; i < numloops; i++) begin
        // call swap locating module
        swap_location sl(inM, outM);
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
    logic r1 = $urandom_range(0, ROW_LEN);
    logic c1 = $urandom_range(0,COL_LEN);

    // generating for r2 and c2
    logic r2 = $urandom_range(0, ROW_LEN);
    logic c2 = $urandom_range(0,COL_LEN);

  initial begin
    while (inM[r1][c1] == inM[r1][c2]) begin
      r2 = $urandom_range(0, ROW_LEN);
    end
  end

  initial begin
    while(inM[r1][c1] != inM[r2][c2]) begin
      c2 = $urandom_range(0, COL_LEN);
    end
  end
  // call to swapping module
  swapping s(inM, r1, r2, c1, c2, outM);
endmodule



// swapping module- checks if the given points form a checkerboard unit and if so, complete the swap
module swapping
  #(parameter
    ROW_LEN = 4,
    COL_LEN = 4) 
   (input logic inM[ROW_LEN][COL_LEN],
    input logic [19:0] r1, // assuming the 20-bit is the max length of the matrix
    input logic [19:0] r2,
    input logic [19:0] c1,
    input logic [19:0] c2,
    output logic outM[ROW_LEN][COL_LEN]);
  
  if(inM[r1][c2] == inM[r2][c1]) begin // just testing for this bc we already know that (r2,c2) has the same value as (r1,c2) and (r1, c2) != (r1,c1)
    outM = inM;
    // XOR the original values to flip them
    outM[r1][c1] = ^(inM[r1][c1]);
    outM[r1][c2] = ^(inM[r1][c2]);
    outM[r2][c1] = ^(inM[r2][c1]);
    outM[r2][c2] = ^(inM[r2][c2]);
  end
endmodule

  
  
