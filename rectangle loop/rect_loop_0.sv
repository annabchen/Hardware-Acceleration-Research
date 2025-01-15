`timescale 1ns / 1ps
//WORKING IMPLEMENTATION
/*
right now im not keeping track of the indices that were generated...
declare another variable (possibly a struct?) to keep track of this
*/

module rectangle_loop 
    #(parameter 
      MATRIX_ROW = 2,
      MATRIX_COL = 2,
      ITERATION = 8/*may be unnecessary*/)
     (input int rnd_row, rnd_col,
      input logic m[MATRIX_ROW][MATRIX_COL],
      output logic m_outm[MATRIX_ROW][MATRIX_COL]);
      
      
    /*
    Variable Declarations
    */
    logic sub_m[2][2]; //submatrix that will be used to check whether we have a checkerboard unit
    logic chkbrd_0[2][2] = '{ '{0,1}, '{1,0} }; //checkerboard unit 
    logic chkbrd_1[2][2] = '{ '{1,0}, '{0,1} }; //checkerboard unit
    
    typedef enum {INIT_ONE, INIT_ZERO} init_states;//case for whether we have 0 or 1 entry after initial generation
    typedef enum {COL_TWO, ROW_TWO_COL, CHKBRD_0, FAIL_0} init_entry_one; //stages of loop algorithm   
    typedef enum {ROW_TWO, COL_TWO_ROW, CHKBRD_1, FAIL_1} init_entry_zero; //stages of loop algorithm
    
    /*
    case variable declarations
    */
    init_states state;
    init_entry_zero stage_0, n_stage_0;
    init_entry_one stage_1, n_stage_1;
    
    always_comb
    begin
    //depending on whether our initial entry is 0 or 1, we differ the way the next entries are chosen
    //hence we execute one state or the other
    if (m[rnd_row][rnd_col] == 1) assign state = INIT_ONE;
    else assign state = INIT_ZERO;
        case (state)
            INIT_ONE: begin//initial entry is 1
                sub_m[0][0] = 1;//
                stage_1 = COL_TWO;
                case (stage_1)
                    COL_TWO: stage_1 = ROW_TWO_COL;
                endcase
            end
                
            INIT_ZERO: begin
                sub_m[0][0] = m[rnd_row][rnd_col];
                stage_0 = ROW_TWO;
                case (stage_0)
                    ROW_TWO: stage_0 = COL_TWO_ROW;
                endcase
            end
        endcase
        if (sub_m == chkbrd_0 || sub_m == chkbrd_1)
        begin
            /*
            XOR corresponding rows and cols with 1
            */
        end
    end
endmodule
