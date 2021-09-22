module piso(rst,frame_out,parity_type,parity_out,stop_bits,send,baud_out,data_out,p_parity_out,tx_active,tx_done);
input rst;
input [11:0] frame_out;
input [1:0] parity_type;
input  stop_bits;
input  send;                    //to start loading the data into SR_reg and add start and stop bits
input baud_out;
input parity_out;

output reg  data_out;
output reg p_parity_out;
output reg tx_active;
output reg tx_done;
reg [11:0]SR_reg; //12 bits that will be serially transmitted
reg [4:0]counter;

always@(posedge baud_out)
if (rst)
begin
data_out<=1;
tx_active<=0;
tx_done<=0;
p_parity_out<=1'b0;
end
else begin
if(parity_type==2'b11) p_parity_out<=parity_out;
else p_parity_out<=1'b0;
if(send)begin
SR_reg<=frame_out[11:0];
tx_active<=1;
counter<=0;
end 
else begin
data_out<=SR_reg[11];
SR_reg<={SR_reg[10:0],1'b0};
if (SR_reg==0) tx_done<=0;
else if (counter<11)begin
  tx_active<=1;
  counter<=counter+1;
  tx_done<=0;
end
else begin
  counter<=0;
  tx_done<=1;
  tx_active<=0;
end
end  
end
endmodule 