extends Node3D

const EDGE_TABLE: Array= [
	0x0  , 0x109, 0x203, 0x30a, 0x406, 0x50f, 0x605, 0x70c,
	0x80c, 0x905, 0xa0f, 0xb06, 0xc0a, 0xd03, 0xe09, 0xf00,
	0x190, 0x99 , 0x393, 0x29a, 0x596, 0x49f, 0x795, 0x69c,
	0x99c, 0x895, 0xb9f, 0xa96, 0xd9a, 0xc93, 0xf99, 0xe90,
	0x230, 0x339, 0x33 , 0x13a, 0x636, 0x73f, 0x435, 0x53c,
	0xa3c, 0xb35, 0x83f, 0x936, 0xe3a, 0xf33, 0xc39, 0xd30,
	0x3a0, 0x2a9, 0x1a3, 0xaa , 0x7a6, 0x6af, 0x5a5, 0x4ac,
	0xbac, 0xaa5, 0x9af, 0x8a6, 0xfaa, 0xea3, 0xda9, 0xca0,
	0x460, 0x569, 0x663, 0x76a, 0x66 , 0x16f, 0x265, 0x36c,
	0xc6c, 0xd65, 0xe6f, 0xf66, 0x86a, 0x963, 0xa69, 0xb60,
	0x5f0, 0x4f9, 0x7f3, 0x6fa, 0x1f6, 0xff , 0x3f5, 0x2fc,
	0xdfc, 0xcf5, 0xfff, 0xef6, 0x9fa, 0x8f3, 0xbf9, 0xaf0,
	0x650, 0x759, 0x453, 0x55a, 0x256, 0x35f, 0x55 , 0x15c,
	0xe5c, 0xf55, 0xc5f, 0xd56, 0xa5a, 0xb53, 0x859, 0x950,
	0x7c0, 0x6c9, 0x5c3, 0x4ca, 0x3c6, 0x2cf, 0x1c5, 0xcc ,
	0xfcc, 0xec5, 0xdcf, 0xcc6, 0xbca, 0xac3, 0x9c9, 0x8c0,
	0x8c0, 0x9c9, 0xac3, 0xbca, 0xcc6, 0xdcf, 0xec5, 0xfcc,
	0xcc , 0x1c5, 0x2cf, 0x3c6, 0x4ca, 0x5c3, 0x6c9, 0x7c0,
	0x950, 0x859, 0xb53, 0xa5a, 0xd56, 0xc5f, 0xf55, 0xe5c,
	0x15c, 0x55 , 0x35f, 0x256, 0x55a, 0x453, 0x759, 0x650,
	0xaf0, 0xbf9, 0x8f3, 0x9fa, 0xef6, 0xfff, 0xcf5, 0xdfc,
	0x2fc, 0x3f5, 0xff , 0x1f6, 0x6fa, 0x7f3, 0x4f9, 0x5f0,
	0xb60, 0xa69, 0x963, 0x86a, 0xf66, 0xe6f, 0xd65, 0xc6c,
	0x36c, 0x265, 0x16f, 0x66 , 0x76a, 0x663, 0x569, 0x460,
	0xca0, 0xda9, 0xea3, 0xfaa, 0x8a6, 0x9af, 0xaa5, 0xbac,
	0x4ac, 0x5a5, 0x6af, 0x7a6, 0xaa , 0x1a3, 0x2a9, 0x3a0,
	0xd30, 0xc39, 0xf33, 0xe3a, 0x936, 0x83f, 0xb35, 0xa3c,
	0x53c, 0x435, 0x73f, 0x636, 0x13a, 0x33 , 0x339, 0x230,
	0xe90, 0xf99, 0xc93, 0xd9a, 0xa96, 0xb9f, 0x895, 0x99c,
	0x69c, 0x795, 0x49f, 0x596, 0x29a, 0x393, 0x99 , 0x190,
	0xf00, 0xe09, 0xd03, 0xc0a, 0xb06, 0xa0f, 0x905, 0x80c,
	0x70c, 0x605, 0x50f, 0x406, 0x30a, 0x203, 0x109, 0x0
]

const TRI_TABLE: Array= [
	[-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1],
	[0 , 8 , 3 , -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1],
	[0 , 1 , 9 , -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1],
	[1 , 8 , 3 , 9 , 8 , 1 , -1, -1, -1, -1, -1, -1, -1, -1, -1, -1],
	[1 , 2 , 10, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1],
	[0 , 8 , 3 , 1 , 2 , 10, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1],
	[9 , 2 , 10, 0 , 2 , 9 , -1, -1, -1, -1, -1, -1, -1, -1, -1, -1],
	[2 , 8 , 3 , 2 , 10, 8 , 10, 9 , 8 , -1, -1, -1, -1, -1, -1, -1],
	[3 , 11, 2 , -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1],
	[0 , 11, 2 , 8 , 11, 0 , -1, -1, -1, -1, -1, -1, -1, -1, -1, -1],
	[1 , 9 , 0 , 2 , 3 , 11, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1],
	[1 , 11, 2 , 1 , 9 , 11, 9 , 8 , 11, -1, -1, -1, -1, -1, -1, -1],
	[3 , 10, 1 , 11, 10, 3 , -1, -1, -1, -1, -1, -1, -1, -1, -1, -1],
	[0, 10, 1, 0, 8, 10, 8, 11, 10, -1, -1, -1, -1, -1, -1, -1],
	[3, 9, 0, 3, 11, 9, 11, 10, 9, -1, -1, -1, -1, -1, -1, -1],
	[9, 8, 10, 10, 8, 11, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1],
	[4, 7, 8, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1],
	[4, 3, 0, 7, 3, 4, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1],
	[0, 1, 9, 8, 4, 7, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1],
	[4, 1, 9, 4, 7, 1, 7, 3, 1, -1, -1, -1, -1, -1, -1, -1],
	[1, 2, 10, 8, 4, 7, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1],
	[3, 4, 7, 3, 0, 4, 1, 2, 10, -1, -1, -1, -1, -1, -1, -1],
	[9, 2, 10, 9, 0, 2, 8, 4, 7, -1, -1, -1, -1, -1, -1, -1],
	[2, 10, 9, 2, 9, 7, 2, 7, 3, 7, 9, 4, -1, -1, -1, -1],
	[8, 4, 7, 3, 11, 2, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1],
	[11, 4, 7, 11, 2, 4, 2, 0, 4, -1, -1, -1, -1, -1, -1, -1],
	[9, 0, 1, 8, 4, 7, 2, 3, 11, -1, -1, -1, -1, -1, -1, -1],
	[4, 7, 11, 9, 4, 11, 9, 11, 2, 9, 2, 1, -1, -1, -1, -1],
	[3, 10, 1, 3, 11, 10, 7, 8, 4, -1, -1, -1, -1, -1, -1, -1],
	[1, 11, 10, 1, 4, 11, 1, 0, 4, 7, 11, 4, -1, -1, -1, -1],
	[4, 7, 8, 9, 0, 11, 9, 11, 10, 11, 0, 3, -1, -1, -1, -1],
	[4, 7, 11, 4, 11, 9, 9, 11, 10, -1, -1, -1, -1, -1, -1, -1],
	[9, 5, 4, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1],
	[9, 5, 4, 0, 8, 3, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1],
	[0, 5, 4, 1, 5, 0, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1],
	[8, 5, 4, 8, 3, 5, 3, 1, 5, -1, -1, -1, -1, -1, -1, -1],
	[1, 2, 10, 9, 5, 4, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1],
	[3, 0, 8, 1, 2, 10, 4, 9, 5, -1, -1, -1, -1, -1, -1, -1],
	[5, 2, 10, 5, 4, 2, 4, 0, 2, -1, -1, -1, -1, -1, -1, -1],
	[2, 10, 5, 3, 2, 5, 3, 5, 4, 3, 4, 8, -1, -1, -1, -1],
	[9, 5, 4, 2, 3, 11, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1],
	[0, 11, 2, 0, 8, 11, 4, 9, 5, -1, -1, -1, -1, -1, -1, -1],
	[0, 5, 4, 0, 1, 5, 2, 3, 11, -1, -1, -1, -1, -1, -1, -1],
	[2, 1, 5, 2, 5, 8, 2, 8, 11, 4, 8, 5, -1, -1, -1, -1],
	[10, 3, 11, 10, 1, 3, 9, 5, 4, -1, -1, -1, -1, -1, -1, -1],
	[4, 9, 5, 0, 8, 1, 8, 10, 1, 8, 11, 10, -1, -1, -1, -1],
	[5, 4, 0, 5, 0, 11, 5, 11, 10, 11, 0, 3, -1, -1, -1, -1],
	[5, 4, 8, 5, 8, 10, 10, 8, 11, -1, -1, -1, -1, -1, -1, -1],
	[9, 7, 8, 5, 7, 9, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1],
	[9, 3, 0, 9, 5, 3, 5, 7, 3, -1, -1, -1, -1, -1, -1, -1],
	[0, 7, 8, 0, 1, 7, 1, 5, 7, -1, -1, -1, -1, -1, -1, -1],
	[1, 5, 3, 3, 5, 7, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1],
	[9, 7, 8, 9, 5, 7, 10, 1, 2, -1, -1, -1, -1, -1, -1, -1],
	[10, 1, 2, 9, 5, 0, 5, 3, 0, 5, 7, 3, -1, -1, -1, -1],
	[8, 0, 2, 8, 2, 5, 8, 5, 7, 10, 5, 2, -1, -1, -1, -1],
	[2, 10, 5, 2, 5, 3, 3, 5, 7, -1, -1, -1, -1, -1, -1, -1],
	[7, 9, 5, 7, 8, 9, 3, 11, 2, -1, -1, -1, -1, -1, -1, -1],
	[9, 5, 7, 9, 7, 2, 9, 2, 0, 2, 7, 11, -1, -1, -1, -1],
	[2, 3, 11, 0, 1, 8, 1, 7, 8, 1, 5, 7, -1, -1, -1, -1],
	[11, 2, 1, 11, 1, 7, 7, 1, 5, -1, -1, -1, -1, -1, -1, -1],
	[9, 5, 8, 8, 5, 7, 10, 1, 3, 10, 3, 11, -1, -1, -1, -1],
	[5, 7, 0, 5, 0, 9, 7, 11, 0, 1, 0, 10, 11, 10, 0, -1],
	[11, 10, 0, 11, 0, 3, 10, 5, 0, 8, 0, 7, 5, 7, 0, -1],
	[11, 10, 5, 7, 11, 5, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1],
	[10, 6, 5, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1],
	[0, 8, 3, 5, 10, 6, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1],
	[9, 0, 1, 5, 10, 6, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1],
	[1, 8, 3, 1, 9, 8, 5, 10, 6, -1, -1, -1, -1, -1, -1, -1],
	[1, 6, 5, 2, 6, 1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1],
	[1, 6, 5, 1, 2, 6, 3, 0, 8, -1, -1, -1, -1, -1, -1, -1],
	[9, 6, 5, 9, 0, 6, 0, 2, 6, -1, -1, -1, -1, -1, -1, -1],
	[5, 9, 8, 5, 8, 2, 5, 2, 6, 3, 2, 8, -1, -1, -1, -1],
	[2, 3, 11, 10, 6, 5, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1],
	[11, 0, 8, 11, 2, 0, 10, 6, 5, -1, -1, -1, -1, -1, -1, -1],
	[0, 1, 9, 2, 3, 11, 5, 10, 6, -1, -1, -1, -1, -1, -1, -1],
	[5, 10, 6, 1, 9, 2, 9, 11, 2, 9, 8, 11, -1, -1, -1, -1],
	[6, 3, 11, 6, 5, 3, 5, 1, 3, -1, -1, -1, -1, -1, -1, -1],
	[0, 8, 11, 0, 11, 5, 0, 5, 1, 5, 11, 6, -1, -1, -1, -1],
	[3, 11, 6, 0, 3, 6, 0, 6, 5, 0, 5, 9, -1, -1, -1, -1],
	[6, 5, 9, 6, 9, 11, 11, 9, 8, -1, -1, -1, -1, -1, -1, -1],
	[5, 10, 6, 4, 7, 8, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1],
	[4, 3, 0, 4, 7, 3, 6, 5, 10, -1, -1, -1, -1, -1, -1, -1],
	[1, 9, 0, 5, 10, 6, 8, 4, 7, -1, -1, -1, -1, -1, -1, -1],
	[10, 6, 5, 1, 9, 7, 1, 7, 3, 7, 9, 4, -1, -1, -1, -1],
	[6, 1, 2, 6, 5, 1, 4, 7, 8, -1, -1, -1, -1, -1, -1, -1],
	[1, 2, 5, 5, 2, 6, 3, 0, 4, 3, 4, 7, -1, -1, -1, -1],
	[8, 4, 7, 9, 0, 5, 0, 6, 5, 0, 2, 6, -1, -1, -1, -1],
	[7, 3, 9, 7, 9, 4, 3, 2, 9, 5, 9, 6, 2, 6, 9, -1],
	[3, 11, 2, 7, 8, 4, 10, 6, 5, -1, -1, -1, -1, -1, -1, -1],
	[5, 10, 6, 4, 7, 2, 4, 2, 0, 2, 7, 11, -1, -1, -1, -1],
	[0, 1, 9, 4, 7, 8, 2, 3, 11, 5, 10, 6, -1, -1, -1, -1],
	[9, 2, 1, 9, 11, 2, 9, 4, 11, 7, 11, 4, 5, 10, 6, -1],
	[8, 4, 7, 3, 11, 5, 3, 5, 1, 5, 11, 6, -1, -1, -1, -1],
	[5, 1, 11, 5, 11, 6, 1, 0, 11, 7, 11, 4, 0, 4, 11, -1],
	[0, 5, 9, 0, 6, 5, 0, 3, 6, 11, 6, 3, 8, 4, 7, -1],
	[6, 5, 9, 6, 9, 11, 4, 7, 9, 7, 11, 9, -1, -1, -1, -1],
	[10, 4, 9, 6, 4, 10, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1],
	[4, 10, 6, 4, 9, 10, 0, 8, 3, -1, -1, -1, -1, -1, -1, -1],
	[10, 0, 1, 10, 6, 0, 6, 4, 0, -1, -1, -1, -1, -1, -1, -1],
	[8, 3, 1, 8, 1, 6, 8, 6, 4, 6, 1, 10, -1, -1, -1, -1],
	[1, 4, 9, 1, 2, 4, 2, 6, 4, -1, -1, -1, -1, -1, -1, -1],
	[3, 0, 8, 1, 2, 9, 2, 4, 9, 2, 6, 4, -1, -1, -1, -1],
	[0, 2, 4, 4, 2, 6, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1],
	[8, 3, 2, 8, 2, 4, 4, 2, 6, -1, -1, -1, -1, -1, -1, -1],
	[10, 4, 9, 10, 6, 4, 11, 2, 3, -1, -1, -1, -1, -1, -1, -1],
	[0, 8, 2, 2, 8, 11, 4, 9, 10, 4, 10, 6, -1, -1, -1, -1],
	[3, 11, 2, 0, 1, 6, 0, 6, 4, 6, 1, 10, -1, -1, -1, -1],
	[6, 4, 1, 6, 1, 10, 4, 8, 1, 2, 1, 11, 8, 11, 1, -1],
	[9, 6, 4, 9, 3, 6, 9, 1, 3, 11, 6, 3, -1, -1, -1, -1],
	[8, 11, 1, 8, 1, 0, 11, 6, 1, 9, 1, 4, 6, 4, 1, -1],
	[3, 11, 6, 3, 6, 0, 0, 6, 4, -1, -1, -1, -1, -1, -1, -1],
	[6, 4, 8, 11, 6, 8, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1],
	[7, 10, 6, 7, 8, 10, 8, 9, 10, -1, -1, -1, -1, -1, -1, -1],
	[0, 7, 3, 0, 10, 7, 0, 9, 10, 6, 7, 10, -1, -1, -1, -1],
	[10, 6, 7, 1, 10, 7, 1, 7, 8, 1, 8, 0, -1, -1, -1, -1],
	[10, 6, 7, 10, 7, 1, 1, 7, 3, -1, -1, -1, -1, -1, -1, -1],
	[1, 2, 6, 1, 6, 8, 1, 8, 9, 8, 6, 7, -1, -1, -1, -1],
	[2, 6, 9, 2, 9, 1, 6, 7, 9, 0, 9, 3, 7, 3, 9, -1],
	[7, 8, 0, 7, 0, 6, 6, 0, 2, -1, -1, -1, -1, -1, -1, -1],
	[7, 3, 2, 6, 7, 2, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1],
	[2, 3, 11, 10, 6, 8, 10, 8, 9, 8, 6, 7, -1, -1, -1, -1],
	[2, 0, 7, 2, 7, 11, 0, 9, 7, 6, 7, 10, 9, 10, 7, -1],
	[1, 8, 0, 1, 7, 8, 1, 10, 7, 6, 7, 10, 2, 3, 11, -1],
	[11, 2, 1, 11, 1, 7, 10, 6, 1, 6, 7, 1, -1, -1, -1, -1],
	[8, 9, 6, 8, 6, 7, 9, 1, 6, 11, 6, 3, 1, 3, 6, -1],
	[0, 9, 1, 11, 6, 7, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1],
	[7, 8, 0, 7, 0, 6, 3, 11, 0, 11, 6, 0, -1, -1, -1, -1],
	[7, 11, 6, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1],
	[7, 6, 11, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1],
	[3, 0, 8, 11, 7, 6, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1],
	[0, 1, 9, 11, 7, 6, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1],
	[8, 1, 9, 8, 3, 1, 11, 7, 6, -1, -1, -1, -1, -1, -1, -1],
	[10, 1, 2, 6, 11, 7, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1],
	[1, 2, 10, 3, 0, 8, 6, 11, 7, -1, -1, -1, -1, -1, -1, -1],
	[2, 9, 0, 2, 10, 9, 6, 11, 7, -1, -1, -1, -1, -1, -1, -1],
	[6, 11, 7, 2, 10, 3, 10, 8, 3, 10, 9, 8, -1, -1, -1, -1],
	[7, 2, 3, 6, 2, 7, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1],
	[7, 0, 8, 7, 6, 0, 6, 2, 0, -1, -1, -1, -1, -1, -1, -1],
	[2, 7, 6, 2, 3, 7, 0, 1, 9, -1, -1, -1, -1, -1, -1, -1],
	[1, 6, 2, 1, 8, 6, 1, 9, 8, 8, 7, 6, -1, -1, -1, -1],
	[10, 7, 6, 10, 1, 7, 1, 3, 7, -1, -1, -1, -1, -1, -1, -1],
	[10, 7, 6, 1, 7, 10, 1, 8, 7, 1, 0, 8, -1, -1, -1, -1],
	[0, 3, 7, 0, 7, 10, 0, 10, 9, 6, 10, 7, -1, -1, -1, -1],
	[7, 6, 10, 7, 10, 8, 8, 10, 9, -1, -1, -1, -1, -1, -1, -1],
	[6, 8, 4, 11, 8, 6, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1],
	[3, 6, 11, 3, 0, 6, 0, 4, 6, -1, -1, -1, -1, -1, -1, -1],
	[8, 6, 11, 8, 4, 6, 9, 0, 1, -1, -1, -1, -1, -1, -1, -1],
	[9, 4, 6, 9, 6, 3, 9, 3, 1, 11, 3, 6, -1, -1, -1, -1],
	[6, 8, 4, 6, 11, 8, 2, 10, 1, -1, -1, -1, -1, -1, -1, -1],
	[1, 2, 10, 3, 0, 11, 0, 6, 11, 0, 4, 6, -1, -1, -1, -1],
	[4, 11, 8, 4, 6, 11, 0, 2, 9, 2, 10, 9, -1, -1, -1, -1],
	[10, 9, 3, 10, 3, 2, 9, 4, 3, 11, 3, 6, 4, 6, 3, -1],
	[8, 2, 3, 8, 4, 2, 4, 6, 2, -1, -1, -1, -1, -1, -1, -1],
	[0, 4, 2, 4, 6, 2, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1],
	[1, 9, 0, 2, 3, 4, 2, 4, 6, 4, 3, 8, -1, -1, -1, -1],
	[1, 9, 4, 1, 4, 2, 2, 4, 6, -1, -1, -1, -1, -1, -1, -1],
	[8, 1, 3, 8, 6, 1, 8, 4, 6, 6, 10, 1, -1, -1, -1, -1],
	[10, 1, 0, 10, 0, 6, 6, 0, 4, -1, -1, -1, -1, -1, -1, -1],
	[4, 6, 3, 4, 3, 8, 6, 10, 3, 0, 3, 9, 10, 9, 3, -1],
	[10, 9, 4, 6, 10, 4, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1],
	[4, 9, 5, 7, 6, 11, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1],
	[0, 8, 3, 4, 9, 5, 11, 7, 6, -1, -1, -1, -1, -1, -1, -1],
	[5, 0, 1, 5, 4, 0, 7, 6, 11, -1, -1, -1, -1, -1, -1, -1],
	[11, 7, 6, 8, 3, 4, 3, 5, 4, 3, 1, 5, -1, -1, -1, -1],
	[9, 5, 4, 10, 1, 2, 7, 6, 11, -1, -1, -1, -1, -1, -1, -1],
	[6, 11, 7, 1, 2, 10, 0, 8, 3, 4, 9, 5, -1, -1, -1, -1],
	[7, 6, 11, 5, 4, 10, 4, 2, 10, 4, 0, 2, -1, -1, -1, -1],
	[3, 4, 8, 3, 5, 4, 3, 2, 5, 10, 5, 2, 11, 7, 6, -1],
	[7, 2, 3, 7, 6, 2, 5, 4, 9, -1, -1, -1, -1, -1, -1, -1],
	[9, 5, 4, 0, 8, 6, 0, 6, 2, 6, 8, 7, -1, -1, -1, -1],
	[3, 6, 2, 3, 7, 6, 1, 5, 0, 5, 4, 0, -1, -1, -1, -1],
	[6, 2, 8, 6, 8, 7, 2, 1, 8, 4, 8, 5, 1, 5, 8, -1],
	[9, 5, 4, 10, 1, 6, 1, 7, 6, 1, 3, 7, -1, -1, -1, -1],
	[1, 6, 10, 1, 7, 6, 1, 0, 7, 8, 7, 0, 9, 5, 4, -1],
	[4, 0, 10, 4, 10, 5, 0, 3, 10, 6, 10, 7, 3, 7, 10, -1],
	[7, 6, 10, 7, 10, 8, 5, 4, 10, 4, 8, 10, -1, -1, -1, -1],
	[6, 9, 5, 6, 11, 9, 11, 8, 9, -1, -1, -1, -1, -1, -1, -1],
	[3, 6, 11, 0, 6, 3, 0, 5, 6, 0, 9, 5, -1, -1, -1, -1],
	[0, 11, 8, 0, 5, 11, 0, 1, 5, 5, 6, 11, -1, -1, -1, -1],
	[6, 11, 3, 6, 3, 5, 5, 3, 1, -1, -1, -1, -1, -1, -1, -1],
	[1, 2, 10, 9, 5, 11, 9, 11, 8, 11, 5, 6, -1, -1, -1, -1],
	[0, 11, 3, 0, 6, 11, 0, 9, 6, 5, 6, 9, 1, 2, 10, -1],
	[11, 8, 5, 11, 5, 6, 8, 0, 5, 10, 5, 2, 0, 2, 5, -1],
	[6, 11, 3, 6, 3, 5, 2, 10, 3, 10, 5, 3, -1, -1, -1, -1],
	[5, 8, 9, 5, 2, 8, 5, 6, 2, 3, 8, 2, -1, -1, -1, -1],
	[9, 5, 6, 9, 6, 0, 0, 6, 2, -1, -1, -1, -1, -1, -1, -1],
	[1, 5, 8, 1, 8, 0, 5, 6, 8, 3, 8, 2, 6, 2, 8, -1],
	[1, 5, 6, 2, 1, 6, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1],
	[1, 3, 6, 1, 6, 10, 3, 8, 6, 5, 6, 9, 8, 9, 6, -1],
	[10, 1, 0, 10, 0, 6, 9, 5, 0, 5, 6, 0, -1, -1, -1, -1],
	[0, 3, 8, 5, 6, 10, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1],
	[10, 5, 6, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1],
	[11, 5, 10, 7, 5, 11, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1],
	[11, 5, 10, 11, 7, 5, 8, 3, 0, -1, -1, -1, -1, -1, -1, -1],
	[5, 11, 7, 5, 10, 11, 1, 9, 0, -1, -1, -1, -1, -1, -1, -1],
	[10, 7, 5, 10, 11, 7, 9, 8, 1, 8, 3, 1, -1, -1, -1, -1],
	[11, 1, 2, 11, 7, 1, 7, 5, 1, -1, -1, -1, -1, -1, -1, -1],
	[0, 8, 3, 1, 2, 7, 1, 7, 5, 7, 2, 11, -1, -1, -1, -1],
	[9, 7, 5, 9, 2, 7, 9, 0, 2, 2, 11, 7, -1, -1, -1, -1],
	[7, 5, 2, 7, 2, 11, 5, 9, 2, 3, 2, 8, 9, 8, 2, -1],
	[2, 5, 10, 2, 3, 5, 3, 7, 5, -1, -1, -1, -1, -1, -1, -1],
	[8, 2, 0, 8, 5, 2, 8, 7, 5, 10, 2, 5, -1, -1, -1, -1],
	[9, 0, 1, 5, 10, 3, 5, 3, 7, 3, 10, 2, -1, -1, -1, -1],
	[9, 8, 2, 9, 2, 1, 8, 7, 2, 10, 2, 5, 7, 5, 2, -1],
	[1, 3, 5, 3, 7, 5, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1],
	[0, 8, 7, 0, 7, 1, 1, 7, 5, -1, -1, -1, -1, -1, -1, -1],
	[9, 0, 3, 9, 3, 5, 5, 3, 7, -1, -1, -1, -1, -1, -1, -1],
	[9, 8, 7, 5, 9, 7, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1],
	[5, 8, 4, 5, 10, 8, 10, 11, 8, -1, -1, -1, -1, -1, -1, -1],
	[5, 0, 4, 5, 11, 0, 5, 10, 11, 11, 3, 0, -1, -1, -1, -1],
	[0, 1, 9, 8, 4, 10, 8, 10, 11, 10, 4, 5, -1, -1, -1, -1],
	[10, 11, 4, 10, 4, 5, 11, 3, 4, 9, 4, 1, 3, 1, 4, -1],
	[2, 5, 1, 2, 8, 5, 2, 11, 8, 4, 5, 8, -1, -1, -1, -1],
	[0, 4, 11, 0, 11, 3, 4, 5, 11, 2, 11, 1, 5, 1, 11, -1],
	[0, 2, 5, 0, 5, 9, 2, 11, 5, 4, 5, 8, 11, 8, 5, -1],
	[9, 4, 5, 2, 11, 3, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1],
	[2, 5, 10, 3, 5, 2, 3, 4, 5, 3, 8, 4, -1, -1, -1, -1],
	[5, 10, 2, 5, 2, 4, 4, 2, 0, -1, -1, -1, -1, -1, -1, -1],
	[3, 10, 2, 3, 5, 10, 3, 8, 5, 4, 5, 8, 0, 1, 9, -1],
	[5, 10, 2, 5, 2, 4, 1, 9, 2, 9, 4, 2, -1, -1, -1, -1],
	[8, 4, 5, 8, 5, 3, 3, 5, 1, -1, -1, -1, -1, -1, -1, -1],
	[0, 4, 5, 1, 0, 5, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1],
	[8, 4, 5, 8, 5, 3, 9, 0, 5, 0, 3, 5, -1, -1, -1, -1],
	[9, 4, 5, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1],
	[4, 11, 7, 4, 9, 11, 9, 10, 11, -1, -1, -1, -1, -1, -1, -1],
	[0, 8, 3, 4, 9, 7, 9, 11, 7, 9, 10, 11, -1, -1, -1, -1],
	[1, 10, 11, 1, 11, 4, 1, 4, 0, 7, 4, 11, -1, -1, -1, -1],
	[3, 1, 4, 3, 4, 8, 1, 10, 4, 7, 4, 11, 10, 11, 4, -1],
	[4, 11, 7, 9, 11, 4, 9, 2, 11, 9, 1, 2, -1, -1, -1, -1],
	[9, 7, 4, 9, 11, 7, 9, 1, 11, 2, 11, 1, 0, 8, 3, -1],
	[11, 7, 4, 11, 4, 2, 2, 4, 0, -1, -1, -1, -1, -1, -1, -1],
	[11, 7, 4, 11, 4, 2, 8, 3, 4, 3, 2, 4, -1, -1, -1, -1],
	[2, 9, 10, 2, 7, 9, 2, 3, 7, 7, 4, 9, -1, -1, -1, -1],
	[9, 10, 7, 9, 7, 4, 10, 2, 7, 8, 7, 0, 2, 0, 7, -1],
	[3, 7, 10, 3, 10, 2, 7, 4, 10, 1, 10, 0, 4, 0, 10, -1],
	[1, 10, 2, 8, 7, 4, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1],
	[4, 9, 1, 4, 1, 7, 7, 1, 3, -1, -1, -1, -1, -1, -1, -1],
	[4, 9, 1, 4, 1, 7, 0, 8, 1, 8, 7, 1, -1, -1, -1, -1],
	[4, 0, 3, 7, 4, 3, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1],
	[4, 8, 7, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1],
	[9, 10, 8, 10, 11, 8, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1],
	[3, 0, 9, 3, 9, 11, 11, 9, 10, -1, -1, -1, -1, -1, -1, -1],
	[0, 1, 10, 0, 10, 8, 8, 10, 11, -1, -1, -1, -1, -1, -1, -1],
	[3, 1, 10, 11, 3, 10, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1],
	[1, 2, 11, 1, 11, 9, 9, 11, 8, -1, -1, -1, -1, -1, -1, -1],
	[3, 0, 9, 3, 9, 11, 1, 2, 9, 2, 11, 9, -1, -1, -1, -1],
	[0, 2, 11, 8, 0, 11, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1],
	[3, 2, 11, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1],
	[2, 3, 8, 2, 8, 10, 10, 8, 9, -1, -1, -1, -1, -1, -1, -1],
	[9, 10, 2, 0, 9, 2, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1],
	[2, 3, 8, 2, 8, 10, 0, 1, 8, 1, 10, 8, -1, -1, -1, -1],
	[1, 10, 2, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1],
	[1, 3, 8, 9, 1, 8, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1],
	[0, 9, 1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1],
	[0, 3, 8, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1],
	[-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1]
]

const VERTEX_PAIRS: Array[Array]= [
	[0, 1],
	[1, 2],
	[2, 3],
	[3, 0],
	[4, 5],
	[5, 6],
	[6, 7],
	[7, 4],
	[0, 4],
	[1, 5],
	[2, 6],
	[3, 7],
]

@export var isolevel: float= 0.0

@export var player: Node3D
@onready var chunk_holder = $"Chunk Holder"

## === Tick Process ===
var tick_timer: Timer
@export var tick_interval_seconds: float= 0.05
@export var max_add_count_per_tick: int= 5
@export var max_remove_count_per_tick: int= 2


## === World/Chunk/Voxel ===
@export var world_chunk_count:= Vector3i(50, 50, 50)
var world_size_logical: Vector3i
var world_size_physical: Vector3

const CHUNK_SCENE = preload("uid://ravyr8dslrvn")
var chunk_size_logical: int= 8
var chunk_size_physical: float
@export var chunk_load_radius: int= 10
@export var chunk_idle_timeout_time_seconds: float= 5.0
@export var chunk_unload_radius: int= 12
var chunk_atlas: Array[ChunkData]= []
var active_chunks: Dictionary[Vector2i, Chunk]= {}
var current_chunk:= Vector2i.ZERO
var previous_chunk:= Vector2i.MAX

var voxel_size_physical:= 1.0


## == Threads/Queues ===
var add_queue:= PriorityQueue.new()
var add_lookup: Dictionary= {}
var remove_queue:= Queue.new()
var remove_lookup: Dictionary= {}
var mesh_queue:= PriorityQueue.new()
var mesh_lookup: Dictionary= {}

@export var max_mesh_thread_count: int= 10
var mesh_threads: Array[Dictionary]= []

## === Noise ===
@export var seed: int= 0
var density_noise:= Noise4D.new()
var carver_noise:= Noise4D.new()
@export var carver_threshold:= Vector2(0.05, 0.065)


func _ready() -> void:
	world_size_logical = world_chunk_count * chunk_size_logical
	world_size_physical = world_size_logical * voxel_size_physical
	chunk_size_physical = chunk_size_logical * voxel_size_physical
	
	chunk_atlas.resize(world_chunk_count.x * world_chunk_count.z)
	mesh_threads.resize(max_mesh_thread_count)
	
	density_noise.seed = seed
	carver_noise.seed = seed + 1
	
	tick_timer = Timer.new()
	tick_timer.wait_time = tick_interval_seconds
	tick_timer.autostart = true
	tick_timer.one_shot = false
	add_child(tick_timer)
	tick_timer.timeout.connect(_process_tick)


func _process(delta: float) -> void:
	current_chunk = Vector2i(
		floori(player.position.x / chunk_size_physical),
		floori(player.position.z / chunk_size_physical)
	)
	
	if current_chunk != previous_chunk:
		check_nearby_chunks()
		previous_chunk = current_chunk
	update_active_chunks(delta)


func check_nearby_chunks() -> void:
	for x in range(-chunk_load_radius, chunk_load_radius + 1):
		for z in range(-chunk_load_radius, chunk_load_radius + 1):
			var coord = current_chunk + Vector2i(x, z)
			var distance = coord.distance_to(current_chunk)
			if distance <= chunk_load_radius:
				add_to_add_queue(coord, distance)


func add_to_add_queue(coord: Vector2i, distance: float) -> void:
	if active_chunks.has(coord):
		return
	
	if add_lookup.has(coord):
		return
	
	if remove_lookup.has(coord):
		## remove from @var:remove_queue too, right?
		remove_lookup.erase(coord)
	add_lookup[coord] = true
	add_queue.push(coord, distance)


func update_active_chunks(delta: float) -> void:
	for coord in active_chunks:
		var distance = current_chunk.distance_to(coord)
		
		if distance <= chunk_load_radius:
			active_chunks[coord].idle_time_seconds = 0.0
		elif distance < chunk_unload_radius:
			active_chunks[coord].idle_time_seconds += delta
			if active_chunks[coord].idle_time_seconds >= chunk_idle_timeout_time_seconds:
				add_to_remove_queue(coord)
		else:
			add_to_remove_queue(coord)


func add_to_remove_queue(coord: Vector2i) -> void:
	if not active_chunks.has(coord):
		return
	
	if remove_lookup.has(coord):
		return
	
	if add_lookup.has(coord):
		## remove from @var:add_queue too, right?
		add_lookup.erase(coord)
	remove_lookup[coord] = true
	remove_queue.push(coord)


func _process_tick() -> void:
	check_mesh_threads()
	check_add_queue()
	check_remove_queue()


func check_mesh_threads() -> void:
	for index in range(mesh_threads.size()):
		if mesh_threads[index]:
			if not mesh_threads[index].thread.is_alive():
				var surface_array = mesh_threads[index].thread.wait_to_finish()
				var array_mesh = ArrayMesh.new()
				if surface_array[Mesh.ARRAY_VERTEX].size() > 0:
					array_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, surface_array)
				var atlas_coord = get_atlas_coord(mesh_threads[index].coord)
				var atlas_index = get_atlas_index(atlas_coord)
				chunk_atlas[atlas_index].mesh = array_mesh
				if active_chunks.has(mesh_threads[index].coord):
					active_chunks[mesh_threads[index].coord].set_array_mesh(array_mesh)
				mesh_threads[index] = {}
		elif mesh_queue.size() > 0:
			var dict = {"thread": Thread.new(), "coord": mesh_queue.pop()}
			mesh_threads[index] = dict
			mesh_threads[index].thread.start(get_surface_array.bind(dict.coord))


func get_surface_array(chunk_coord: Vector2i) -> Array:
	var vertices: Array[Vector3]= []
	var uvs: Array[Vector2]= []
	var normals: Array[Vector3]= []
	var indices: Array[int]= []
	
	for x in range(chunk_size_logical):
		for y in range(world_size_logical.y):
			for z in range(chunk_size_logical):
				var current_coord:= Vector3i(x, y, z)
				
				var cube_index: int= 0
				var corners: Array[Vector4]= []
				corners.resize(8)
				for neighbor in range(8):
					corners[neighbor] = get_corner(chunk_coord, current_coord, neighbor)
					if corners[neighbor].w < isolevel:
						cube_index |= int(pow(2, neighbor))
				
				if EDGE_TABLE[cube_index] == 0:
					continue
				
				var vertex_list: Array[Vector3]= []
				vertex_list.resize(12)
				for edge in range(12):
					if EDGE_TABLE[cube_index] & int(pow(2, edge)):
						vertex_list[edge] = interpolate(
								corners[VERTEX_PAIRS[edge][0]], 
								corners[VERTEX_PAIRS[edge][1]]
						)
				
				var index = 0
				while TRI_TABLE[cube_index][index] != -1:
					var start = vertices.size()
					vertices.append(vertex_list[TRI_TABLE[cube_index][index + 0]])
					vertices.append(vertex_list[TRI_TABLE[cube_index][index + 1]])
					vertices.append(vertex_list[TRI_TABLE[cube_index][index + 2]])
					
					uvs.append(Vector2(0, 0))
					uvs.append(Vector2(1, 0))
					uvs.append(Vector2(0, 1))
					
					var edge_ca = vertices[start + 2] - vertices[start]
					var edge_ba = vertices[start + 1] - vertices[start]
					var normal = edge_ca.cross(edge_ba).normalized()
					normals.append(normal)
					normals.append(normal)
					normals.append(normal)
					
					indices.append(start + 1)
					indices.append(start + 2)
					indices.append(start + 0)
					
					index += 3
	
	var surface_array = []
	surface_array.resize(Mesh.ARRAY_MAX)
	surface_array[Mesh.ARRAY_VERTEX] = PackedVector3Array(vertices)
	surface_array[Mesh.ARRAY_TEX_UV] = PackedVector2Array(uvs)
	surface_array[Mesh.ARRAY_NORMAL] = PackedVector3Array(normals)
	surface_array[Mesh.ARRAY_INDEX] = PackedInt32Array(indices)
	return surface_array


func get_corner(chunk_coord: Vector2i, local_voxel_coord: Vector3i, neighbor: int) -> Vector4:
	var additive
	match neighbor:
		0: additive = Vector3i(0, 0, 0)
		1: additive = Vector3i(1, 0, 0)
		2: additive = Vector3i(1, 0, 1)
		3: additive = Vector3i(0, 0, 1)
		4: additive = Vector3i(0, 1, 0)
		5: additive = Vector3i(1, 1, 0)
		6: additive = Vector3i(1, 1, 1)
		7: additive = Vector3i(0, 1, 1)
	
	var corner_coord = local_voxel_coord + additive
	var global_coord = Vector3i(chunk_coord.x, 0, chunk_coord.y) * chunk_size_logical + corner_coord
	global_coord.x %= world_size_logical.x
	#global_coord.y %= world_size_logical.y
	global_coord.z %= world_size_logical.z
	var theta_x = TAU * global_coord.x / world_size_logical.x
	var theta_z = TAU * global_coord.z / world_size_logical.z
	
	var DEBUG_RADII: float = 50.0
	
	var torus_coord:= Vector4(
			cos(theta_x) * DEBUG_RADII,
			sin(theta_x) * DEBUG_RADII,
			cos(theta_z) * DEBUG_RADII,
			sin(theta_z) * DEBUG_RADII
	)
	var density_value: float= density_noise.get_noise_4dv(torus_coord)
	density_value -= (float(global_coord.y) / world_size_logical.y) * 2.0 - 1.0
	var carver_value:= carver_noise.get_noise_4dv(torus_coord)
	carver_value -= (float(global_coord.y) / world_size_logical.y) * 2.0 - 1.0
	if carver_value >= carver_threshold.x and carver_value < carver_threshold.y:
		density_value -= carver_value
	
	corner_coord *= voxel_size_physical
	return Vector4(corner_coord.x, corner_coord.y, corner_coord.z, density_value)


func interpolate(a: Vector4, b: Vector4) -> Vector3:
	return (Vector3(a.x, a.y, a.z) + Vector3(b.x, b.y, b.z)) * 0.5


func get_atlas_coord(global_coord: Vector2i) -> Vector2i:
	return Vector2i(
		posmod(global_coord.x, world_chunk_count.x),
		posmod(global_coord.y, world_chunk_count.z)
	)


func get_atlas_index(atlas_coord: Vector2i) -> int:
	return atlas_coord.x + (atlas_coord.y * world_chunk_count.x)


func check_add_queue() -> void:
	var counter = 0
	while add_queue.size() > 0 and counter < max_add_count_per_tick:
		var coord = add_queue.pop()
		add_lookup.erase(coord)
		if active_chunks.has(coord):
			continue
		
		#print("adding %s of %s" % [counter, max_add_count_per_tick])
		var data = get_chunk_data(coord)
		var chunk = CHUNK_SCENE.instantiate()
		chunk.init(data)
		chunk.position = Vector3(coord.x, 0, coord.y) * chunk_size_physical
		active_chunks[coord] = chunk
		chunk_holder.add_child.call_deferred(chunk)
		counter += 1


func get_chunk_data(coord: Vector2i) -> ChunkData:
	var atlas_coord = get_atlas_coord(coord)
	var atlas_index = get_atlas_index(atlas_coord)
	
	if chunk_atlas[atlas_index]:
		return chunk_atlas[atlas_index]
	
	add_to_mesh_queue(coord)
	var data = ChunkData.new()
	chunk_atlas[atlas_index] = data
	return data


func add_to_mesh_queue(coord: Vector2i) -> void:
	if mesh_lookup.has(coord):
		return
	
	var priority = 0
	if active_chunks.has(coord):
		priority = -1
	elif add_lookup.has(coord):
		priority = 1
	elif remove_lookup.has(coord):
		priority = 2
	mesh_lookup[coord] = true
	mesh_queue.push(coord, priority)


func check_remove_queue() -> void:
	var counter = 0
	while remove_queue.size() > 0 and counter < max_remove_count_per_tick:
		var coord = remove_queue.pop()
		remove_lookup.erase(coord)
		if not active_chunks.has(coord):
			continue
		
		var chunk = active_chunks[coord]
		if not is_instance_valid(chunk):
			continue
		
		#print("removing %s of %s" % [counter, max_remove_count_per_tick])
		## save data
		active_chunks.erase(coord)
		chunk.queue_free()
		counter += 1
