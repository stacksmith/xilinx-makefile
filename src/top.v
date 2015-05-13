/******************************************************************************
LED blinker

******************************************************************************/

 module top(
  input   clk
, output  led
);

assign clken = 1;

  reg[24:0] PC;
  always @(posedge clk)
    PC <= PC+1;

  assign led= PC[24];

endmodule
