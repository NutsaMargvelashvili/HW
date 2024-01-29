function y = chad

clear 
clc

    imgRGB = imread('pussy.jpg');

figure(1);
imshow(imgRGB);
% Get size of the img 
imageSize = size(imgRGB);
MAXROWS = imageSize(1);
MAXCOLS = imageSize(2);


% Encoder: Convert to YCbCr 4:2:0
imgYCbCr = rgb2ycbcr(imgRGB);
Y__420 = imgYCbCr(:,:,1);
Cb_420 = imgYCbCr(:,:,2);
Cr_420 = imgYCbCr(:,:,3);
Cb_420(:,2:2:end) = [];
Cb_420(2:2:end,:) = [];
Cr_420(:,2:2:end) = [];
Cr_420(2:2:end,:) = [];


% Encoder (Part A): Calculate the 3 bands' 8x8 block DCT transform coefficients.
DCTp = @dct2;
DCTy = blkproc(Y__420, [8 8], DCTp);
DCTy = fix(DCTy);
DCTcb = blkproc(Cb_420, [8 8], DCTp);
DCTcb = fix(DCTcb);
DCTcr = blkproc(Cr_420, [8 8], DCTp);
DCTcr = fix(DCTcr);
figure(2);
imshow(DCTy);


% 1) A: Show the DCT coefficient matrix and the DCT picture. 
% For the brightness component, converted image blocks are the first two blocks in the sixth row of blocks from the top.
figure(3);
subplot(1,2,1), subimage(DCTy(41:48, 1:8)), title('Row 4 Block 1')
subplot(1,2,2), subimage(DCTy(41:48, 9:16)), title('Row 4 Block 2')
r4_blk1 = DCTy(25:32, 1:8)
r4_blk2 = DCTy(25:32, 9:16)

% Encoder (Part B): Use the JPEG luminance and crominance quantizer matrix from the seminar notes to quantize the DCT image.

y_quant_matrix = [
    16  11  10  16  24  40  51  61;
    12  12  14  19  26  58  60  55;
    14  13  16  24  40  57  69  56;
    14  17  22  29  51  87  89  62;
    18  22  37  56  68 109 103  77;
    24  35  55  64  81 104 113  92;
    49  64  78  87 108 121 120 101;
    72  92  95  98 112 100 103  99
    ];
cr_quant_matrix = [
    17 18 24 47 99 99 99 99;
    18 21 26 66 99 99 99 99;
    24 26 56 99 99 99 99 99;
    47 66 99 99 99 99 99 99;
    99 99 99 99 99 99 99 99;
    99 99 99 99 99 99 99 99;
    99 99 99 99 99 99 99 99;
    99 99 99 99 99 99 99 99;
    ];

quantize_y = @(block_struct) ...
    round(block_struct.data ./ y_quant_matrix);
quantize_cbcr = @(block_struct) ...
    round(block_struct.data ./ cr_quant_matrix);

dequantize_y  = @(block_struct) ...
    round(block_struct.data .* y_quant_matrix);
dequantize_cbcr = @(block_struct) ...
    round(block_struct.data .* cr_quant_matrix);


y_quant = blockproc(DCTy, [8 8], quantize_y);
cb_quant = blockproc(DCTcb, [8 8], quantize_cbcr);
cr_quant = blockproc(DCTcr, [8 8], quantize_cbcr);


% 1) B: Only for the first two blocks in the sixth row from the top of the luminance component, report the following output: (a) DC DCT coefficient; and (b) Zigzag scanned AC DCT coefficients.
    % (a): DC DCT Coefficient
    r4_blk1_DC_coefficient = y_quant(41, 1)
    r4_blk2_DC_coefficient = y_quant(41, 9)
    % (b): Zigzag scanned AC DCT coefficients
    r4_blk1_zigzag = zigzag(y_quant(41:48, 1:8))
    r4_blk2_zigzag = zigzag(y_quant(41:48, 9:16))


% Decoder (Part C): Compute the inverse quantized images from step b
y_dequant = blockproc(y_quant, [8 8], dequantize_y);
cb_dequant = blockproc(cb_quant, [8 8], dequantize_cbcr);
cr_dequant = blockproc(cr_quant, [8 8], dequantize_cbcr);


% Decoder (Part D): Reconstruct the image by computing the inverse DCT
% coefficients
pIDCT = @idct2;
y_idct = blkproc(y_dequant, [8 8], pIDCT);
y_idct = fix(y_idct);
cb_idct = blkproc(cb_dequant, [8 8], pIDCT);
cb_idct = fix(cb_idct);
cr_idct = blkproc(cr_dequant, [8 8], pIDCT);
cr_idct = fix(cr_idct);


% Reconstruct from 4:2:0 subsampling using linear interpolation
linearY = uint8(y_idct);
Cb_linear = uint8(zeros(MAXROWS, MAXCOLS));
Cr_linear = uint8(zeros(MAXROWS, MAXCOLS));
Cb_linear(1:2:end, 1:2:end) = cb_idct(1:end,1:end);
Cr_linear(1:2:end, 1:2:end) = cr_idct(1:end,1:end);
for row = 2:2:MAXROWS 
    for col = 1:2:MAXCOLS
        % Identify the pixel's halfway point between above and below.
        if(row ~= MAXROWS)
            Cb_linear(row, col) = Cb_linear(row-1, col)/2 + Cb_linear(row+1, col)/2;
            Cr_linear(row, col) = Cr_linear(row-1, col)/2 + Cr_linear(row+1, col)/2;
        else %special case if at the last pixel in the row
            Cb_linear(row, col) = Cb_linear(row-1, col);
            Cr_linear(row, col) = Cr_linear(row-1, col);
        end
    end
end
% Get the halfway between the left and right pixel by drawing alternating lines now.
for row = 1:MAXROWS
    for col = 2:2:MAXCOLS
        if(col ~= MAXCOLS)
            Cb_linear(row, col) = Cb_linear(row, col-1)/2 + Cb_linear(row, col+1)/2;
            Cr_linear(row, col) = Cr_linear(row, col-1)/2 + Cr_linear(row, col+1)/2;
        else %special case if at the last pixel in the column
            Cb_linear(row, col) = Cb_linear(row, col-1);
            Cr_linear(row, col) = Cr_linear(row, col-1);
        end
    end
end
% Concatenate the three components
YCbCr_linear = cat(3, linearY, Cb_linear, Cr_linear);

% Convert to RGB space
reconstructedRGB = ycbcr2rgb(YCbCr_linear);
figure(4);
imshow(reconstructedRGB);

% Display the error image for the Y-component
errorImage = abs(Y__420(:,:) - linearY(:,:));
figure(5);
imshow(errorImage);

% Compute the PSNR
MSEy = mean(errorImage(:).^2);
PSNR_Y = 10 * log10(255^2/MSEy)
end