`define HV_DIM 4096
`define M 2

module qtz_im_fetch(
    input  wire     [3:0]           qlevel,
    input  wire     [`HV_DIM-1:0]   im_hvs      [0:`M-1],
    output logic	[`HV_DIM-1:0]	level_hv
    ); 

    always_comb begin
        case(qlevel)
            0       : level_hv = {im_hvs[0][HV_DIM-1:((HV_DIM)/8)*8-1],im_hvs[1][((HV_DIM)/8)*(8)-1:0]};
            1       : level_hv = {im_hvs[0][HV_DIM-1:((HV_DIM)/8)*7],im_hvs[1][((HV_DIM)/8)*(7)-1:0]};
            2       : level_hv = {im_hvs[0][HV_DIM-1:((HV_DIM)/8)*6],im_hvs[1][((HV_DIM)/8)*(6)-1:0]};
            3       : level_hv = {im_hvs[0][HV_DIM-1:((HV_DIM)/8)*5],im_hvs[1][((HV_DIM)/8)*(5)-1:0]};
            4       : level_hv = {im_hvs[0][HV_DIM-1:((HV_DIM)/8)*4],im_hvs[1][((HV_DIM)/8)*(4)-1:0]};
            5       : level_hv = {im_hvs[0][HV_DIM-1:((HV_DIM)/8)*3],im_hvs[1][((HV_DIM)/8)*(3)-1:0]};
            6       : level_hv = {im_hvs[0][HV_DIM-1:((HV_DIM)/8)*2],im_hvs[1][((HV_DIM)/8)*(2)-1:0]};
            7       : level_hv = {im_hvs[0][HV_DIM-1:((HV_DIM)/8)*1],im_hvs[1][((HV_DIM)/8)*(1)-1:0]};
            default : level_hv = {im_hvs[0][HV_DIM-1:((HV_DIM)/8)*0],im_hvs[1][((HV_DIM)/8)*(0):0]};
        endcase
    end
  
endmodule
