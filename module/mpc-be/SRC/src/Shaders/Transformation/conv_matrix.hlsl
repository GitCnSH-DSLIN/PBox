// https://www.itu.int/rec/R-REC-BT.709/en
static float4x4 rgb_ycbcr709 = {
	 0.2126,    0.7152,    0.0722,   0.0,
	-0.114572, -0.385428,  0.5,      0.0,
	 0.5,      -0.454153, -0.045847, 0.0,
	 0.0,       0.0,       0.0,      0.0
};
static float4x4 ycbcr709_rgb = {
	1.0,  0.0,       1.5748,   0.0,
	1.0, -0.187324, -0.468124, 0.0,
	1.0,  1.8556,    0.0,      0.0,
	0.0,  0.0,       0.0,      0.0
};

// https://www.itu.int/rec/R-REC-BT.601/en
static float4x4 rgb_ycbcr601 = {
	 0.299,     0.587,     0.114,    0.0,
	-0.168736, -0.331264,  0.5,      0.0,
	 0.5,      -0.418688, -0.081312, 0.0,
	 0.0,       0.0,       0.0,      0.0
};
static float4x4 ycbcr601_rgb = {
	1.0,  0.0,       1.402,    0.0,
	1.0, -0.344136, -0.714136, 0.0,
	1.0,  1.772,     0.0,      0.0,
	0.0,  0.0,       0.0,      0.0
};

// https://www.itu.int/rec/R-REC-BT.2020/en
static float4x4 rgb_ycbcr2020nc = {
	 0.2627,   0.678,     0.0593,   0.0,
	-0.13963, -0.36037,   0.5,      0.0,
	 0.5,     -0.459786, -0.040214, 0.0,
	 0.0,      0.0,       0.0,      0.0
};
static float4x4 ycbcr2020nc_rgb = {
	1.0,  0.0,       1.4746,   0.0,
	1.0, -0.164553, -0.571353, 0.0,
	1.0,  1.8814,    0.0,      0.0,
	0.0,  0.0,       0.0,      0.0
};

// https://en.wikipedia.org/wiki/YCoCg
static float4x4 ycgco_rgb = {
	1.0, -1.0,  1.0, 0.0,
	1.0,  1.0,  0.0, 0.0,
	1.0, -1.0, -1.0, 0.0,
	0.0,  0.0,  0.0, 0.0
};