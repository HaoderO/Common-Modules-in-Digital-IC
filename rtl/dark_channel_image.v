`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/05/12 10:36:02
// Design Name: 
// Module Name: dark_channel_image
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module dark_channel_image(
    //ʱ��
    input       clk  ,  //50MHz
    input       rst_n,
    
    //����ǰͼ������
    input       pre_gray_vsync,  //����ǰͼ�����ݳ��ź�
    input       pe_gray_valid ,   //����ǰͼ���������ź� 
    input       pe_gray_clken ,   //����ǰͼ����������ʹ��Ч�ź�
    input [7:0] min_rgb_m,        //rgb����Сֵ             
    
    //������ͼ������
    output       pos_gray_vsync,    //������ͼ�����ݳ��ź�   
    output       pos_gray_valid,    //������ͼ���������ź�  
    output       pos_gray_clken,    //������ͼ���������ʹ��Ч�ź�
    output [7:0] dark_chanel_value   //�����ͨ��ֵ    
    );
    
//wire define
wire        matrix_frame_vsync;
wire        matrix_frame_href;
wire        matrix_frame_clken;
wire [7:0]  matrix_p11; //3X3 �������
wire [7:0]  matrix_p12; 
wire [7:0]  matrix_p13;
wire [7:0]  matrix_p21; 
wire [7:0]  matrix_p22; 
wire [7:0]  matrix_p23;
wire [7:0]  matrix_p31; 
wire [7:0]  matrix_p32; 
wire [7:0]  matrix_p33;
wire [7:0]  min_value;    

//*****************************************************
//**                    main code
//*****************************************************
//���ӳٺ�����ź���Ч������ֵ�����Ҷ����ֵ
assign dark_chanel_value = pos_gray_valid? min_value:8'd0;  

generate_3x3_8bit generate_3x3_8bit_1(
    .clk        (clk), 
    .rst_n      (rst_n),
    
    //����ǰͼ������
    .per_frame_vsync    (pre_gray_vsync),
    .per_frame_href     (pe_gray_valid), 
    .per_frame_clken    (pe_gray_clken), 
    .per_img_y          (min_rgb_m),
    
    //������ͼ������
    .matrix_frame_vsync (matrix_frame_vsync),
    .matrix_frame_href  (matrix_frame_href),
    .matrix_frame_clken (matrix_frame_clken),
    .matrix_p11         (matrix_p11),    
    .matrix_p12         (matrix_p12),    
    .matrix_p13         (matrix_p13),
    .matrix_p21         (matrix_p21),    
    .matrix_p22         (matrix_p22),    
    .matrix_p23         (matrix_p23),
    .matrix_p31         (matrix_p31),    
    .matrix_p32         (matrix_p32),    
    .matrix_p33         (matrix_p33)
);

//3x3���е���Сֵֵ�˲�����Ҫ2��ʱ��
min_filter_3x3 min_filter_3x3_0(
    .clk        (clk),
    .rst_n      (rst_n),
    
    .median_frame_vsync (matrix_frame_vsync),
    .median_frame_href  (matrix_frame_href),
    .median_frame_clken (matrix_frame_clken),
    
    //��һ��
    .data11           (matrix_p11)     , 
    .data12           (matrix_p12)     , 
    .data13           (matrix_p13)     ,
    //�ڶ���              
    .data21           (matrix_p21)     , 
    .data22           (matrix_p22)     , 
    .data23           (matrix_p23)     ,
    //������              
    .data31           (matrix_p31)     , 
    .data32           (matrix_p32)     , 
    .data33           (matrix_p33)     ,
    
    .target_data      (min_value)      ,
    .pos_frame_vsync (pos_gray_vsync),
    .pos_frame_href  (pos_gray_valid) ,
    .pos_frame_clken (pos_gray_clken)
    
);

endmodule