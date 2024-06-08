// 
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU Lesser General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
// 
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU Lesser General Public License for more details.
// 
// You should have received a copy of the GNU Lesser General Public License
// along with this program.  If not, see <http://www.gnu.org/licenses/>.

//!DESC RAVU (step1, yuv, r2, compute)
//!HOOK NATIVE
//!BIND HOOKED
//!BIND ravu_lut2
//!SAVE ravu_int11
//!WHEN HOOKED.w OUTPUT.w / 0.833333 < HOOKED.h OUTPUT.h / 0.833333 < * LUMA.w 0 > *
//!COMPUTE 32 8
shared vec3 inp0[385];
shared float inp_luma0[385];
void hook() {
ivec2 group_base = ivec2(gl_WorkGroupID) * ivec2(gl_WorkGroupSize);
int local_pos = int(gl_LocalInvocationID.x) * 11 + int(gl_LocalInvocationID.y);
for (int id = int(gl_LocalInvocationIndex); id < 385; id += int(gl_WorkGroupSize.x * gl_WorkGroupSize.y)) {
int x = id / 11, y = id % 11;
inp0[id] = HOOKED_tex(HOOKED_pt * vec2(float(group_base.x+x)+(-0.5), float(group_base.y+y)+(-0.5))).xyz;
inp_luma0[id] = inp0[id].x;
}
barrier();
{
float luma0 = inp_luma0[local_pos + 0];
float luma4 = inp_luma0[local_pos + 11];
float luma5 = inp_luma0[local_pos + 12];
float luma6 = inp_luma0[local_pos + 13];
float luma7 = inp_luma0[local_pos + 14];
float luma1 = inp_luma0[local_pos + 1];
float luma8 = inp_luma0[local_pos + 22];
float luma9 = inp_luma0[local_pos + 23];
float luma10 = inp_luma0[local_pos + 24];
float luma11 = inp_luma0[local_pos + 25];
float luma2 = inp_luma0[local_pos + 2];
float luma12 = inp_luma0[local_pos + 33];
float luma13 = inp_luma0[local_pos + 34];
float luma14 = inp_luma0[local_pos + 35];
float luma15 = inp_luma0[local_pos + 36];
float luma3 = inp_luma0[local_pos + 3];
vec3 abd = vec3(0.0);
float gx, gy;
gx = (luma4-luma0);
gy = (luma1-luma0);
abd += vec3(gx * gx, gx * gy, gy * gy) * 0.04792235409415088;
gx = (luma5-luma1);
gy = (luma2-luma0)/2.0;
abd += vec3(gx * gx, gx * gy, gy * gy) * 0.06153352068439959;
gx = (luma6-luma2);
gy = (luma3-luma1)/2.0;
abd += vec3(gx * gx, gx * gy, gy * gy) * 0.06153352068439959;
gx = (luma7-luma3);
gy = (luma3-luma2);
abd += vec3(gx * gx, gx * gy, gy * gy) * 0.04792235409415088;
gx = (luma8-luma0)/2.0;
gy = (luma5-luma4);
abd += vec3(gx * gx, gx * gy, gy * gy) * 0.06153352068439959;
gx = (luma9-luma1)/2.0;
gy = (luma6-luma4)/2.0;
abd += vec3(gx * gx, gx * gy, gy * gy) * 0.07901060453704994;
gx = (luma10-luma2)/2.0;
gy = (luma7-luma5)/2.0;
abd += vec3(gx * gx, gx * gy, gy * gy) * 0.07901060453704994;
gx = (luma11-luma3)/2.0;
gy = (luma7-luma6);
abd += vec3(gx * gx, gx * gy, gy * gy) * 0.06153352068439959;
gx = (luma12-luma4)/2.0;
gy = (luma9-luma8);
abd += vec3(gx * gx, gx * gy, gy * gy) * 0.06153352068439959;
gx = (luma13-luma5)/2.0;
gy = (luma10-luma8)/2.0;
abd += vec3(gx * gx, gx * gy, gy * gy) * 0.07901060453704994;
gx = (luma14-luma6)/2.0;
gy = (luma11-luma9)/2.0;
abd += vec3(gx * gx, gx * gy, gy * gy) * 0.07901060453704994;
gx = (luma15-luma7)/2.0;
gy = (luma11-luma10);
abd += vec3(gx * gx, gx * gy, gy * gy) * 0.06153352068439959;
gx = (luma12-luma8);
gy = (luma13-luma12);
abd += vec3(gx * gx, gx * gy, gy * gy) * 0.04792235409415088;
gx = (luma13-luma9);
gy = (luma14-luma12)/2.0;
abd += vec3(gx * gx, gx * gy, gy * gy) * 0.06153352068439959;
gx = (luma14-luma10);
gy = (luma15-luma13)/2.0;
abd += vec3(gx * gx, gx * gy, gy * gy) * 0.06153352068439959;
gx = (luma15-luma11);
gy = (luma15-luma14);
abd += vec3(gx * gx, gx * gy, gy * gy) * 0.04792235409415088;
float a = abd.x, b = abd.y, d = abd.z;
float T = a + d, D = a * d - b * b;
float delta = sqrt(max(T * T / 4.0 - D, 0.0));
float L1 = T / 2.0 + delta, L2 = T / 2.0 - delta;
float sqrtL1 = sqrt(L1), sqrtL2 = sqrt(L2);
float theta = mix(mod(atan(L1 - a, b) + 3.141592653589793, 3.141592653589793), 0.0, abs(b) < 1.192092896e-7);
float lambda = sqrtL1;
float mu = mix((sqrtL1 - sqrtL2) / (sqrtL1 + sqrtL2), 0.0, sqrtL1 + sqrtL2 < 1.192092896e-7);
float angle = floor(theta * 24.0 / 3.141592653589793);
float strength = clamp(floor(log2(lambda * 2000.0 + 1.192092896e-7)), 0.0, 8.0);
float coherence = mix(mix(0.0, 1.0, mu >= 0.25), 2.0, mu >= 0.5);
float coord_y = ((angle * 9.0 + strength) * 3.0 + coherence + 0.5) / 648.0;
vec3 res = vec3(0.0);
vec4 w;
w = texture(ravu_lut2, vec2(0.25, coord_y));
res += (inp0[local_pos + 0] + inp0[local_pos + 36]) * w[0];
res += (inp0[local_pos + 1] + inp0[local_pos + 35]) * w[1];
res += (inp0[local_pos + 2] + inp0[local_pos + 34]) * w[2];
res += (inp0[local_pos + 3] + inp0[local_pos + 33]) * w[3];
w = texture(ravu_lut2, vec2(0.75, coord_y));
res += (inp0[local_pos + 11] + inp0[local_pos + 25]) * w[0];
res += (inp0[local_pos + 12] + inp0[local_pos + 24]) * w[1];
res += (inp0[local_pos + 13] + inp0[local_pos + 23]) * w[2];
res += (inp0[local_pos + 14] + inp0[local_pos + 22]) * w[3];
res = clamp(res, 0.0, 1.0);
imageStore(out_image, ivec2(gl_GlobalInvocationID), vec4(res, 1.0));
}
}
//!DESC RAVU (step2, yuv, r2, compute)
//!HOOK NATIVE
//!BIND HOOKED
//!BIND ravu_lut2
//!BIND ravu_int11
//!WIDTH 2 HOOKED.w *
//!HEIGHT 2 HOOKED.h *
//!OFFSET -0.500000 -0.500000
//!WHEN HOOKED.w OUTPUT.w / 0.833333 < HOOKED.h OUTPUT.h / 0.833333 < * LUMA.w 0 > *
//!COMPUTE 64 16 32 8
shared vec3 inp0[385];
shared float inp_luma0[385];
shared vec3 inp1[385];
shared float inp_luma1[385];
void hook() {
ivec2 group_base = ivec2(gl_WorkGroupID) * ivec2(gl_WorkGroupSize);
int local_pos = int(gl_LocalInvocationID.x) * 11 + int(gl_LocalInvocationID.y);
for (int id = int(gl_LocalInvocationIndex); id < 385; id += int(gl_WorkGroupSize.x * gl_WorkGroupSize.y)) {
int x = id / 11, y = id % 11;
inp0[id] = ravu_int11_tex(ravu_int11_pt * vec2(float(group_base.x+x)+(-1.5), float(group_base.y+y)+(-1.5))).xyz;
inp_luma0[id] = inp0[id].x;
}
for (int id = int(gl_LocalInvocationIndex); id < 385; id += int(gl_WorkGroupSize.x * gl_WorkGroupSize.y)) {
int x = id / 11, y = id % 11;
inp1[id] = HOOKED_tex(HOOKED_pt * vec2(float(group_base.x+x)+(-0.5), float(group_base.y+y)+(-0.5))).xyz;
inp_luma1[id] = inp1[id].x;
}
barrier();
{
float luma8 = inp_luma0[local_pos + 12];
float luma5 = inp_luma0[local_pos + 13];
float luma2 = inp_luma0[local_pos + 14];
float luma13 = inp_luma0[local_pos + 23];
float luma10 = inp_luma0[local_pos + 24];
float luma7 = inp_luma0[local_pos + 25];
float luma0 = inp_luma0[local_pos + 2];
float luma15 = inp_luma0[local_pos + 35];
float luma12 = inp_luma1[local_pos + 11];
float luma9 = inp_luma1[local_pos + 12];
float luma6 = inp_luma1[local_pos + 13];
float luma3 = inp_luma1[local_pos + 14];
float luma4 = inp_luma1[local_pos + 1];
float luma14 = inp_luma1[local_pos + 23];
float luma11 = inp_luma1[local_pos + 24];
float luma1 = inp_luma1[local_pos + 2];
vec3 abd = vec3(0.0);
float gx, gy;
gx = (luma4-luma0);
gy = (luma1-luma0);
abd += vec3(gx * gx, gx * gy, gy * gy) * 0.04792235409415088;
gx = (luma5-luma1);
gy = (luma2-luma0)/2.0;
abd += vec3(gx * gx, gx * gy, gy * gy) * 0.06153352068439959;
gx = (luma6-luma2);
gy = (luma3-luma1)/2.0;
abd += vec3(gx * gx, gx * gy, gy * gy) * 0.06153352068439959;
gx = (luma7-luma3);
gy = (luma3-luma2);
abd += vec3(gx * gx, gx * gy, gy * gy) * 0.04792235409415088;
gx = (luma8-luma0)/2.0;
gy = (luma5-luma4);
abd += vec3(gx * gx, gx * gy, gy * gy) * 0.06153352068439959;
gx = (luma9-luma1)/2.0;
gy = (luma6-luma4)/2.0;
abd += vec3(gx * gx, gx * gy, gy * gy) * 0.07901060453704994;
gx = (luma10-luma2)/2.0;
gy = (luma7-luma5)/2.0;
abd += vec3(gx * gx, gx * gy, gy * gy) * 0.07901060453704994;
gx = (luma11-luma3)/2.0;
gy = (luma7-luma6);
abd += vec3(gx * gx, gx * gy, gy * gy) * 0.06153352068439959;
gx = (luma12-luma4)/2.0;
gy = (luma9-luma8);
abd += vec3(gx * gx, gx * gy, gy * gy) * 0.06153352068439959;
gx = (luma13-luma5)/2.0;
gy = (luma10-luma8)/2.0;
abd += vec3(gx * gx, gx * gy, gy * gy) * 0.07901060453704994;
gx = (luma14-luma6)/2.0;
gy = (luma11-luma9)/2.0;
abd += vec3(gx * gx, gx * gy, gy * gy) * 0.07901060453704994;
gx = (luma15-luma7)/2.0;
gy = (luma11-luma10);
abd += vec3(gx * gx, gx * gy, gy * gy) * 0.06153352068439959;
gx = (luma12-luma8);
gy = (luma13-luma12);
abd += vec3(gx * gx, gx * gy, gy * gy) * 0.04792235409415088;
gx = (luma13-luma9);
gy = (luma14-luma12)/2.0;
abd += vec3(gx * gx, gx * gy, gy * gy) * 0.06153352068439959;
gx = (luma14-luma10);
gy = (luma15-luma13)/2.0;
abd += vec3(gx * gx, gx * gy, gy * gy) * 0.06153352068439959;
gx = (luma15-luma11);
gy = (luma15-luma14);
abd += vec3(gx * gx, gx * gy, gy * gy) * 0.04792235409415088;
float a = abd.x, b = abd.y, d = abd.z;
float T = a + d, D = a * d - b * b;
float delta = sqrt(max(T * T / 4.0 - D, 0.0));
float L1 = T / 2.0 + delta, L2 = T / 2.0 - delta;
float sqrtL1 = sqrt(L1), sqrtL2 = sqrt(L2);
float theta = mix(mod(atan(L1 - a, b) + 3.141592653589793, 3.141592653589793), 0.0, abs(b) < 1.192092896e-7);
float lambda = sqrtL1;
float mu = mix((sqrtL1 - sqrtL2) / (sqrtL1 + sqrtL2), 0.0, sqrtL1 + sqrtL2 < 1.192092896e-7);
float angle = floor(theta * 24.0 / 3.141592653589793);
float strength = clamp(floor(log2(lambda * 2000.0 + 1.192092896e-7)), 0.0, 8.0);
float coherence = mix(mix(0.0, 1.0, mu >= 0.25), 2.0, mu >= 0.5);
float coord_y = ((angle * 9.0 + strength) * 3.0 + coherence + 0.5) / 648.0;
vec3 res = vec3(0.0);
vec4 w;
w = texture(ravu_lut2, vec2(0.25, coord_y));
res += (inp0[local_pos + 2] + inp0[local_pos + 35]) * w[0];
res += (inp1[local_pos + 2] + inp1[local_pos + 23]) * w[1];
res += (inp0[local_pos + 14] + inp0[local_pos + 23]) * w[2];
res += (inp1[local_pos + 14] + inp1[local_pos + 11]) * w[3];
w = texture(ravu_lut2, vec2(0.75, coord_y));
res += (inp1[local_pos + 1] + inp1[local_pos + 24]) * w[0];
res += (inp0[local_pos + 13] + inp0[local_pos + 24]) * w[1];
res += (inp1[local_pos + 13] + inp1[local_pos + 12]) * w[2];
res += (inp0[local_pos + 25] + inp0[local_pos + 12]) * w[3];
res = clamp(res, 0.0, 1.0);
imageStore(out_image, ivec2(gl_GlobalInvocationID) * 2 + ivec2(0, 1), vec4(res, 1.0));
}
{
float luma4 = inp_luma0[local_pos + 12];
float luma1 = inp_luma0[local_pos + 13];
float luma12 = inp_luma0[local_pos + 22];
float luma9 = inp_luma0[local_pos + 23];
float luma6 = inp_luma0[local_pos + 24];
float luma3 = inp_luma0[local_pos + 25];
float luma14 = inp_luma0[local_pos + 34];
float luma11 = inp_luma0[local_pos + 35];
float luma8 = inp_luma1[local_pos + 11];
float luma5 = inp_luma1[local_pos + 12];
float luma2 = inp_luma1[local_pos + 13];
float luma0 = inp_luma1[local_pos + 1];
float luma13 = inp_luma1[local_pos + 22];
float luma10 = inp_luma1[local_pos + 23];
float luma7 = inp_luma1[local_pos + 24];
float luma15 = inp_luma1[local_pos + 34];
vec3 abd = vec3(0.0);
float gx, gy;
gx = (luma4-luma0);
gy = (luma1-luma0);
abd += vec3(gx * gx, gx * gy, gy * gy) * 0.04792235409415088;
gx = (luma5-luma1);
gy = (luma2-luma0)/2.0;
abd += vec3(gx * gx, gx * gy, gy * gy) * 0.06153352068439959;
gx = (luma6-luma2);
gy = (luma3-luma1)/2.0;
abd += vec3(gx * gx, gx * gy, gy * gy) * 0.06153352068439959;
gx = (luma7-luma3);
gy = (luma3-luma2);
abd += vec3(gx * gx, gx * gy, gy * gy) * 0.04792235409415088;
gx = (luma8-luma0)/2.0;
gy = (luma5-luma4);
abd += vec3(gx * gx, gx * gy, gy * gy) * 0.06153352068439959;
gx = (luma9-luma1)/2.0;
gy = (luma6-luma4)/2.0;
abd += vec3(gx * gx, gx * gy, gy * gy) * 0.07901060453704994;
gx = (luma10-luma2)/2.0;
gy = (luma7-luma5)/2.0;
abd += vec3(gx * gx, gx * gy, gy * gy) * 0.07901060453704994;
gx = (luma11-luma3)/2.0;
gy = (luma7-luma6);
abd += vec3(gx * gx, gx * gy, gy * gy) * 0.06153352068439959;
gx = (luma12-luma4)/2.0;
gy = (luma9-luma8);
abd += vec3(gx * gx, gx * gy, gy * gy) * 0.06153352068439959;
gx = (luma13-luma5)/2.0;
gy = (luma10-luma8)/2.0;
abd += vec3(gx * gx, gx * gy, gy * gy) * 0.07901060453704994;
gx = (luma14-luma6)/2.0;
gy = (luma11-luma9)/2.0;
abd += vec3(gx * gx, gx * gy, gy * gy) * 0.07901060453704994;
gx = (luma15-luma7)/2.0;
gy = (luma11-luma10);
abd += vec3(gx * gx, gx * gy, gy * gy) * 0.06153352068439959;
gx = (luma12-luma8);
gy = (luma13-luma12);
abd += vec3(gx * gx, gx * gy, gy * gy) * 0.04792235409415088;
gx = (luma13-luma9);
gy = (luma14-luma12)/2.0;
abd += vec3(gx * gx, gx * gy, gy * gy) * 0.06153352068439959;
gx = (luma14-luma10);
gy = (luma15-luma13)/2.0;
abd += vec3(gx * gx, gx * gy, gy * gy) * 0.06153352068439959;
gx = (luma15-luma11);
gy = (luma15-luma14);
abd += vec3(gx * gx, gx * gy, gy * gy) * 0.04792235409415088;
float a = abd.x, b = abd.y, d = abd.z;
float T = a + d, D = a * d - b * b;
float delta = sqrt(max(T * T / 4.0 - D, 0.0));
float L1 = T / 2.0 + delta, L2 = T / 2.0 - delta;
float sqrtL1 = sqrt(L1), sqrtL2 = sqrt(L2);
float theta = mix(mod(atan(L1 - a, b) + 3.141592653589793, 3.141592653589793), 0.0, abs(b) < 1.192092896e-7);
float lambda = sqrtL1;
float mu = mix((sqrtL1 - sqrtL2) / (sqrtL1 + sqrtL2), 0.0, sqrtL1 + sqrtL2 < 1.192092896e-7);
float angle = floor(theta * 24.0 / 3.141592653589793);
float strength = clamp(floor(log2(lambda * 2000.0 + 1.192092896e-7)), 0.0, 8.0);
float coherence = mix(mix(0.0, 1.0, mu >= 0.25), 2.0, mu >= 0.5);
float coord_y = ((angle * 9.0 + strength) * 3.0 + coherence + 0.5) / 648.0;
vec3 res = vec3(0.0);
vec4 w;
w = texture(ravu_lut2, vec2(0.25, coord_y));
res += (inp1[local_pos + 1] + inp1[local_pos + 34]) * w[0];
res += (inp0[local_pos + 13] + inp0[local_pos + 34]) * w[1];
res += (inp1[local_pos + 13] + inp1[local_pos + 22]) * w[2];
res += (inp0[local_pos + 25] + inp0[local_pos + 22]) * w[3];
w = texture(ravu_lut2, vec2(0.75, coord_y));
res += (inp0[local_pos + 12] + inp0[local_pos + 35]) * w[0];
res += (inp1[local_pos + 12] + inp1[local_pos + 23]) * w[1];
res += (inp0[local_pos + 24] + inp0[local_pos + 23]) * w[2];
res += (inp1[local_pos + 24] + inp1[local_pos + 11]) * w[3];
res = clamp(res, 0.0, 1.0);
imageStore(out_image, ivec2(gl_GlobalInvocationID) * 2 + ivec2(1, 0), vec4(res, 1.0));
}
vec3 res;
res = inp0[local_pos + 24];
imageStore(out_image, ivec2(gl_GlobalInvocationID) * 2 + ivec2(1, 1), vec4(res, 1.0));
res = inp1[local_pos + 12];
imageStore(out_image, ivec2(gl_GlobalInvocationID) * 2 + ivec2(0, 0), vec4(res, 1.0));
}
//!TEXTURE ravu_lut2
//!SIZE 2 648
//!FORMAT rgba16hf
//!FILTER NEAREST
271f7222ef21f9207024c232cd32a124751a6627d628a9a01e27c131f330ec2c72a8992cc8ac922d21a56d301335b9233521aba4cfa4bd2164a34d346b3485a31898db9b109bb9873e243a33a63324279ca6b627f326d3a31a233a329e32632c951c64a688a6931c00a7b934d33421a70b190fa6b9a67a01b7a48234bc34fca1aea5751a37937ba61324953304344929640ea8a7cfa737976ca8f734143502a8581ceaa776a8949ba1a8da34193530a5559d86a4dca5c4a48ea46434a7345a24f71d1fa934a94b160faa39355b3530a9582087a842a92fa1cfaa01354d3591a24823aba522a8eea71eac9334fa34f5285a216ca972a9011dc4aa3b357235bca91d24d9a8bea933a492acfe3478356c11ad286fa4e9a755ac36b07d342535f82e8d1946a949a9d59ed7aa4b359e3566a9ab221aa88aa927a816ade9348d353625c02a6c9895a461af16b23834093539322e9e82a87fa855a501aa1f35b33520a8f11932a534a985aad1acab34bb356528112b3323c199e4b063b2af3306356b33851fbdaad2abf89aeda83235d53541a96b94e3a5a4abfaa9b8a85b34c8355228bd273a28dc1c33b13fb077309135ab33a122911b059aae22341f963200345a213a9b3b24662419a2f316872e1534de2fc12a3c20b09772adb62942315231d330fe20b6a491a5d722b9a3373492344fa44f14079f7da0e416b81ec8322c344d28279c52213d2245a0d425c8305032b52faf1c47a651a7f31de1a6a334f33492a7451e27a60ca80a15c9a6573405353ba174a08c9e57a33aa4089825334f34122bde18bca738a87b97a2a8e2343135e4a71022b4a74ea9139d3faaab3462359ea3582162a5a8a807a4f8a93e342335f32504212ea9cfa99c158aaa1b358335d8a8ad2535a80baac0a4ffacbc34a035621fa828eaa5eaa962a8edae5e349335f02ae523b8a9adaaa61d29ab1435b53561a93128d1a7daa91da905af8134db35d629532afca142a8afac21b10134ad35f02f76227fa944ab809c9bab0b35ff35fda8432859a53ba87dac1ab012340936982ddc288720471e68af96b1973267353432992087a857abd0a3a9aaa4344636f8a7a9259a9c3fa5e3ada4af7f326636212f5f25fc26422850b076b14c315e352233872069a72faee5198fa74334a836fca8829bea2380a9b9ac16accf2f9c364730882092217b2c49b0fbae5629a43525346b231a0fbba18226812225320d349e221f1d0c24d020e29b9e20ed2e8d33b52f342163a223946824b023892da331ac32992095a43ba61524f6a31e34b93400a55f1aa7a141a2321f649955328134ac28b00ef794b8918b1bff0e90309132ca309c1c36a60ca80220a9a68c34163524a89a2086a6dfa8411d07a8313456357fa308996da18fa51aa124a5da32b134572ba11ad4a783a8bf9184a8cc344f3533a80724c8a73aaa2695abaa7f34b13524a5cc2387a5d2a9c3a024ab0f34963531236b212ca949aafc1b42aa0035a6354ea93826f9a702abb7a2d2ac7a34f835b5990e2896a53dabb2a4edad21340936b025482490a9a1ab3f20f9aaee34ed35dea95827cda526abe6a7e4ad0a345d36ca25072867a09fa9f6a904af34334736a72b372435a932aca6947aabd03447369ca90e26169c56aa18abdbad5e32f036a4298923bb21829e81ad62ae0a317536ba2ec72291a776acdaa130aa3c34b636e6a861226f235fa815adc0ac24309537612bc91b2025ea248aaebeadca2ec8369f2fa0208da33eaf071edfa575334737aaaa36a0472629a5c3add2a5d1272838412c5e9d8c22f92a47af24aaae9ba03710300d211f9c95a0a3260a22f7317c34429570158d24971ee2a59692402b1b35d82f2a92151f749d29284ba5112f7234572e182061a419a70225c4a30534e03405a6901eaca315a51224d69e1732f734ca24322080a265a6452762a28c3152347d2c941b13a687a850212ea67634373592a8d62081a6bea9e32109a80b34a73574a6ea135ca356a7241bbaa6b93222355d289e19c5a7cda8901232a8b3346c358ea8b1238da711ab2a1d01aa5334fa3522a80124a5a5d1aa4910b9aad133f535f89c002101a9baaacd1eada9dd34cc35f9a9e52430a7fdabe9987eab38344f368ea668261fa537acea9b91acd4336d3642a11d243fa918ac8a2173aac5341f36adaaa7246ea380ac51a2e6ab4f33db3622a4f62414990fac93a598ac8532e336141e842401a972ac001706aba4347a367baa94218e20d1ac11a789aa5331ac3715a2961d2a253caa01aa3fab35307e37e826872377a6c1ac29a18fa9df330a3716aa161a902635ac3caa94a8a42e3038a79dbd951a2751a8c5ab9fa9252dfb3737283d204b9f30afda1b58a5ab32b83701ac989f5b2768a98aac139c81278038341c119dcb24e88923ad69a4281b5c3885283b238885e2a04625ad1e29328434929e9224be1f09a4d99ba29c072dae352d2ce222c725269b2cb4a62cdb2e43380624551f0ea40ca8312693a3da33073559a74a1dd6a2cda6ab2621a1fa316535559df822aba523a4e424199f21315f3533245c19aba515a91323a0a55e34583511a9322038a68eaa112505a7c433f135fea8d11aaba422a822258da67a328835d51c8f145aa730a9621a7aa799348a3508a9a521e5a6daab6c2294a81e34403619aa6a2323a695ab0a236ba99a333d36b6a76b1e77a844abf820d8a8b334f535b4aaa221fca568acf11fd8a8e2339f3641aab124d3a4c0ac59212aaa7b33be3679a92323d9a850ac1023c6a99e344a368aab4f204aa118ad8d1c7ba8d0322d3751aa1a22a29717adcb1458a9443244371ca99124f8a883ac0f1b80aa8134a2365aab301b3b1f91ad699c70a64b31df3799aa421a1224faacd8a199a78430dc3728a8842347a6ccac3aa0bea87f33463783abfa00842438ad5da535a4c52f3538dda92494be256aaceaa5d8a5af2e1c3850a62a1c179802af2116fda23d320238e0ac439bc724bfab55a96e98382c633878a6739b0925a6a93ba9c4a1782a4d38f09fc821982096a18a26f318bd31c13418a34f203713d8a6612b0c1ed82ec0355ca26218c6295ca33f2ceda9d72b3f36869c6d1e3ba395a88a27ffa2a9332c3576a8f71cc4a10aa8ee28b8a1ae31ba3551a62d1ce8a146a18329569edd2fe33514a1891412a5aaa99524f1a444347935aaa9181e60a550ab5c278ea565333236c9aa7f1cb5a461a8292811a5e431013613a6a79548a6caa9f91e62a67434af35aaa9361e92a550ac39252da6c433843609ac7921a5a5feabf826bea600338936eeaa541856a70cac96239aa779342e36d7abec1b51a4c2ac2f242ca53f33ef3662ac922136a41cad36260fa60433fd368facb7203fa8a3acf8248ca86e347c3672aca01766a02dad2923fea368325d378dace61ed79e65ad5a247fa448326137a9ac3c2425a98facb81fbaa96534cb364bac3b11ac9436ad0b1c90a17031d13774ac001b041128adca1e3ba24531bf3747ac2922b7a6e2acbf9ab1a762337337a2ac2e12f719bbace6a205a078301b38d6ab3e17811ba1accd9c94a06830033885aba1147b9e8cae9d8505a18b320938d8ad0f8f1f1d52abbea89a98f62d513836a9a410611be3a976a54e9d212d2b3834a80d21511edfa41a2898215631ea3413a3ff1d581b06a8ce2c1717a82e05367ca8b81467aaa3a4da2c962a7b2c6a36f8a7381e99a2b5a80528dea29b333535d1a8701cdba082a78c29f9a08e31cf3596a8ab1c969d54a5302b49a19b2f0f3686a54314e3a4b9a9b32404a542347b35b8a9da1d6ca5e7aa8f273ea55e3336366cab631cd7a49fa66e2887a4d6310a36a5a8ce955aa6b0a9211f41a67334af35d0a9191e20a60eac472583a5c133863655ac6321a4a600ab14278da5fb328b3608ac491897a7d8ab992354a779342f360dacd51b27a564ac34244aa43d33ef36c4ac832101a693ac402628a40133ff3620adb5208ba873acfc243ea86d347c36a4ac8b17f5a38fac2f235ea067325d372eadd71e78a4aaac5e24ba9e4732623767ad3c24baa94cacba1f25a96534cb368fac33118ea174ac0b1ca1947031d13736adf61a37a248acce1e51114531bf3728ad2822b1a7a2acc09ab7a662337337e2ac2a1205a0d6abe7a2f91978301b38bbac361793a085abcd9c881b68300338a1ac9a1404a1d8adcf83789e8a3209388cae0a8f9b9836a9bea81f1df62d513852aba1104c9d33a876a5611b212d2b38e3a93b23ad1e929e4625888529328434e2a09224a29c2d2cd99bbe1f072dae3509a4e222a62c06242cb4c725db2e4338269b551f93a359a731260ea4da3307350ca84a1d21a1559dab26d6a2fa316535cda6f822199f3324e424aba521315f3523a45c19a0a511a91323aba55e34583515a9322005a7fea8112538a6c433f1358eaad11a8da6d51c2225aba47a32883522a88f147aa708a9621a5aa799348a3530a9a52194a819aa6c22e5a61e344036daab6a236ba9b6a70a2323a69a333d3695ab6b1ed8a8b4aaf82077a8b334f53544aba221d8a841aaf11ffca5e2339f3668acb1242aaa79a95921d3a47b33be36c0ac2323c6a98aab1023d9a89e344a3650ac4f207ba851aa8d1c4aa1d0322d3718ad1a2258a91ca9cb14a2974432443717ad912480aa5aab0f1bf8a88134a23683ac301b70a699aa699c3b1f4b31df3791ad421a99a728a8d8a112248430dc37faac8423bea883ab3aa047a67f334637ccacfa0035a4dda95da58424c52f353838ad2494d8a550a6eaa5be25af2e1c386aac2a1cfda2e0ac211617983d32023802af439b6e9878a655a9c724382c6338bfab739bc4a1f09f3ba90925782a4d38a6a90721ba20dd996426b59812327734cd9f73159f92d92fe2a58e24402b1b35971e2c9475a5572e2028a21f182f73345b9d1920caa306a600255fa40634e03418a7901ed69eca241224aca31732f73415a5322062a27d2c452780a28c31523465a6951b2fa692a84f2113a67734373586a8d62009a874a6e32181a60b34a735bea9ea13baa65d28241b5ca3b932223556a79e1932a88ea89012c5a7b3346c35cda8b12301aa22a82a1d8da75334fa3511ab0124b9aaf89c4910a5a5d133f535d1aa0021ada9f9a9cd1e01a9dd34cc35baaae5247eab8ea6e99830a738344f36fdab682691ac42a1ea9b1fa5d4336d3637ac1d2473aaadaa8a213fa9c5341f3618aca724e6ab22a451a26ea34f33db3680acf62498ac141e93a514998532e3360fac842406ab7baa001701a9a4347a3672ac942189aa15a211a78e205331ac37d1ac961d3fabe82601aa2a2535307e373caa87238fa916aa29a177a6df330a37c1ac161a94a8a79d3caa9026a42e303835acbd959fa93728c5ab1a27252dfb3751a83d2058a501acda1b4b9fab32b83730af989f139c341c8aac5b278127803868a9119d69a4852823adcb24281b5c38e8897223f3235823cb2621950832133494a21e1d9e20b52fe49b0c24ee2e8d33d1203621b223ac32672464a2892da33124949820f0a3ffa4172496a41e34b9343da65f1a6499ac28321fa7a15532813441a2b10eff0eca308b1bf79490309132b8919c1ca9a624a8032036a68c3416350ca89a2007a87fa3411d86a631345635dfa8089924a5572b1aa16da1da32b1348fa5a11a84a833a8be91d4a7cc344f3583a80724abaa24a52695c8a77f34b1353aaacc2324ab3123c3a087a50f349635d2a96b2142aa4ea9fc1b2ca90035a63549aa3826d2acb599b7a2f9a77a34f83502ab0e28edadb025b2a496a5213409363dab4824f9aadea93f2090a9ee34ed35a1ab5827e4adca25e6a7cda50a345d3626ab072804afa72bf6a967a0343347369fa937247aab9ca9a69435a9d034473632ac0e26dbada42918ab169c5e32f03656aa892362aeba2e81adbb210a317536829ec72230aae6a8daa191a73c34b63676ac6122c0ac612b15ad6f23243095375fa8c91bbead9f2f8aae2025ca2ec836ea24a020dfa5aaaa071e8da3753347373eaf36a0d2a5412cc3ad4726d127283829a55e9d24aa103047af8c22ae9ba037f92aa122341f5a21ae22911b96320034059a3a9bf316de2f19a23b24872e15346624c12ab629d33072ad3c2042315231b097fe20b9a34fa4d722b6a43734923491a54f14b81e4d28e416079fc8322c347da0279cd425b52f45a05221c83050323d22af1ce1a692a7f31d47a6a334f33451a7451ec9a63ba10a1527a6573405350ca874a00898122b3aa48c9e25334f3457a3de18a2a8e4a77b97bca7e234313538a810223faa9ea3139db4a7ab3462354ea95821f8a9f32507a462a53e342335a8a804218aaad8a89c152ea91b358335cfa9ad25ffac621fc0a435a8bc34a0350baaa828edaef02a62a8eaa55e349335eaa9e52329ab61a9a61db8a91435b535adaa312805afd6291da9d1a78134db35daa9532a21b1f02fafacfca10134ad3542a876229babfda8809c7fa90b35ff3544ab43281ab0982d7dac59a5123409363ba8dc2896b1343268af872097326735471e9920a9aaf8a7d0a387a8a434463657aba925a4af212fe3ad9a9c7f3266363fa55f2576b1223350b0fc264c315e35422887208fa7fca8e51969a74334a8362fae829b16ac4730b9acea23cf2f9c3680a98820fbae253449b092215629a4357b2c95201a1f351f6f22251763337b33b6974b231625ec2e67986023cb3197305e255badd6b1fe2ea9240b302d341a343a9d3e21bba3f0a3c921c8a451347034f0a4509649243627f709eb9c3c33aa33759cb4a23728b22d1c9ec923b73110321423a71c11a734a7a71c6aa6ba34d5348fa62519b7a4faa14d0313a68234bc34bda606a4fe252e2ae7a4189c5f33d233be9f8d0f70a805a8f096aca7f7341535d4a75a1ca2a82fa5969beaa7da34193577a8fe9a0fa4d02452a404a55d34a03450a6fe1d10aa31a9631620a939355b3535a95820d0aa90a22fa187a801354d3542a9882315ac0329d9a7cca59134f83430a85d21c5aabda9071d6ca93b35733573a91d2492ac761133a4d9a8fe347835bea9c6282fb0032f4baca2a47a3422350ba89d19d8aa67a9ce9e47a94b359f354aa9ab2216ad362527a81aa8e9348d358aa9ed2a0bb244324eaf4e9b33340435e5a4239e03aa21a852a583a81f35b33580a8f119d1ac652885aa32a5ab34bb3534a94d2b54b27a33d7b03a22a033fe34719cad1ff2a846a9ab9ac1aa3335d635d6ab7794b9a85128faa9e3a55b34c835a4aba22995af1134edb09c240d30513572996f22351f1a1f9520b6977b33633325176798ec2e16254b235e259730cb316023a924fe2ed6b15bad3a9d1a342d340b30c921f0a3bba33e21f0a470345134c8a4f709362749245096759caa333c33eb9c1c9eb22d3728b4a214231032b731c923a71c34a711a7a71c8fa6d534ba346aa64d03faa1b7a42519bda6bc34823413a6e7a42e2afe2506a4be9fd2335f33189cf09605a870a88d0fd4a71535f734aca7969b2fa5a2a85a1c77a81935da34eaa752a4d0240fa4fe9a50a6a0345d3404a5631631a910aafe1d35a95b35393520a92fa190a2d0aa582042a94d35013587a8d9a7032915ac882330a8f8349134cca5071dbda9c5aa5d2173a973353b356ca933a4761192ac1d24bea97835fe34d9a84bac032f2fb0c6280ba822357a34a2a4ce9e67a9d8aa9d194aa99f354b3547a927a8362516adab228aa98d35e9341aa84eaf44320bb2ed2ae5a4043533344e9b52a521a803aa239e80a8b3351f3583a885aa6528d1acf11934a9bb35ab3432a5d7b07a3354b24d2b719cfe34a0333a22ab9a46a9f2a8ad1fd6abd6353335c1aafaa95128b9a87794a4abc8355b34e3a5edb0113495afa229729951350d309c24ae225a21341fa122059a00349632911b19a2de2ff3163a9b66241534872e3b2472add330b629c12ab097523142313c20d7224fa4b9a3fe2091a592343734b6a4e4164d28b81e4f147da02c34c832079f45a0b52fd425279c3d225032c8305221f31d92a7e1a6af1c51a7f334a33447a60a153ba1c9a6451e0ca80535573427a63aa4122b089874a057a34f3425338c9e7b97e4a7a2a8de1838a83135e234bca7139d9ea33faa10224ea96235ab34b4a707a4f325f8a95821a8a823353e3462a59c15d8a88aaa0421cfa983351b352ea9c0a4621fffacad250baaa035bc3435a862a8f02aedaea828eaa993355e34eaa5a61d61a929abe523adaab5351435b8a91da9d62905af3128daa9db358134d1a7afacf02f21b1532a42a8ad350134fca1809cfda89bab762244abff350b357fa97dac982d1ab043283ba80936123459a568af343296b1dc28471e673597328720d0a3f8a7a9aa992057ab4636a43487a8e3ad212fa4afa9253fa566367f329a9c50b0223376b15f2542285e354c31fc26e519fca88fa787202faea836433469a7b9ac473016ac829b80a99c36cf2fea2349b02534fbae88207b2ca4355629922182269e2281226b23bba10d3425321a0fe29bb52f9e201f1dd0208d33ed2e0c246824ac32b02334212394a331892d63a2152400a5f6a399203ba6b9341e3495a4321fac2864995f1a41a281345532a7a18b1bca30ff0eb00eb89191329030f794022024a8a9a69c1c0ca816358c3436a6411d7fa307a89a20dfa85635313486a61aa1572b24a508998fa5b134da326da1bf9133a884a8a11a83a84f35cc34d4a7269524a5abaa07243aaab1357f34c8a7c3a0312324abcc23d2a996350f3487a5fc1b4ea942aa6b2149aaa63500352ca9b7a2b599d2ac382602abf8357a34f9a7b2a4b025edad0e283dab0936213496a53f20dea9f9aa4824a1abed35ee3490a9e6a7ca25e4ad582726ab5d360a34cda5f6a9a72b04af07289fa94736343367a0a6949ca97aab372432ac4736d03435a918aba429dbad0e2656aaf0365e32169c81adba2e62ae8923829e75360a31bb21daa1e6a830aac72276acb6363c3491a715ad612bc0ac61225fa8953724306f238aae9f2fbeadc91bea24c836ca2e2025071eaaaadfa5a0203eaf473775338da3c3ad412cd2a536a029a52838d127472647af103024aa5e9df92aa037ae9b8c22a32642950a220d2195a07c34f7311f9ce2a5d82f96927015971e1b35402b8d242928572e4ba52a92749d7234112f151f022505a6c4a3182019a7e034053461a41224ca24d69e901e15a5f7341732aca345277d2c62a2322065a652348c3180a2502192a82ea6941b87a83735763413a6e32174a609a8d620bea9a7350b3481a6241b5d28baa6ea1356a72235b9325ca390128ea832a89e19cda86c35b334c5a72a1d22a801aab12311abfa3553348da74910f89cb9aa0124d1aaf535d133a5a5cd1ef9a9ada90021baaacc35dd3401a9e9988ea67eabe524fdab4f36383430a7ea9b42a191ac682637ac6d36d4331fa58a21adaa73aa1d2418ac1f36c5343fa951a222a4e6aba72480acdb364f336ea393a5141e98acf6240face3368532149900177baa06ab842472ac7a36a43401a911a715a289aa9421d1acac3753318e2001aae8263fab961d3caa7e3735302a2529a116aa8fa98723c1ac0a37df3377a63caaa79d94a8161a35ac3038a42e9026c5ab37289fa9bd9551a8fb37252d1a27da1b01ac58a53d2030afb837ab324b9f8aac341c139c989f68a9803881275b2723ad852869a4119de8895c38281bcb244625929ead1e3b23e2a0843429328885d99b2d2ca29c922409a4ae35072dbe1f2cb40624a62ce222269b4338db2ec725312659a793a3551f0ca80735da330ea4ab26559d21a14a1dcda66535fa31d6a2e4243324199ff82223a45f352131aba5132311a9a0a55c1915a958355e34aba51125fea805a732208eaaf135c43338a62225d51c8da6d11a22a888357a32aba4621a08a97aa78f1430a98a3599345aa76c2219aa94a8a521daab40361e34e5a60a23b6a76ba96a2395ab3d369a3323a6f820b4aad8a86b1e44abf535b33477a8f11f41aad8a8a22168ac9f36e233fca5592179a92aaab124c0acbe367b33d3a410238aabc6a9232350ac4a369e34d9a88d1c51aa7ba84f2018ad2d37d0324aa1cb141ca958a91a2217ad44374432a2970f1b5aab80aa912483aca2368134f8a8699c99aa70a6301b91addf374b313b1fd8a128a899a7421afaacdc37843012243aa083abbea88423ccac46377f3347a65da5dda935a4fa0038ad3538c52f8424eaa550a6d8a524946aac1c38af2ebe252116e0acfda22a1c02af02383d32179855a978a66e98439bbfab6338382cc7243ba9f09fc4a1739ba6a94d38782a09258a2618a3f318c82196a1c134bd319820612b5ca20c1e4f20d8a6c035d82e37133f2c869ceda962185ca33f36d72bc6298a2776a8ffa26d1e95a82c35a9333ba3ee2851a6b8a1f71c0aa8ba35ae31c4a1832914a1569e2d1c46a1e335dd2fe8a19524aaa9f1a48914aaa97935443412a55c27c9aa8ea5181e50ab3236653360a5292813a611a57f1c61a80136e431b5a4f91eaaa962a6a795caa9af35743448a6392509ac2da6361e50ac8436c43392a5f826eeaabea67921feab89360033a5a59623d7ab9aa754180cac2e36793456a72f2462ac2ca5ec1bc2acef363f3351a436268fac0fa692211cadfd36043336a4f82472ac8ca8b720a3ac7c366e343fa829238dacfea3a0172dad5d37683266a05a24a9ac7fa4e61e65ad61374832d79eb81f4bacbaa93c248faccb36653425a90b1c74ac90a13b1136add1377031ac94ca1e47ac3ba2001b28adbf3745310411bf9aa2acb1a72922e2ac73376233b7a6e6a2d6ab05a02e12bbac1b387830f719cd9c85ab94a03e17a1ac03386830811b9d85d8ad05a1a1148cae09388b327b9ebea836a99a980f8f52ab5138f62d1f1d76a534a84e9da410e3a92b38212d611b1a2813a398210d21dfa4ea345631511ece2c7ca81717ff1d06a80536a82e581bda2cf8a7962ab814a3a46a367b2c67aa0528d1a8dea2381eb5a835359b3399a28c2996a8f9a0701c82a7cf358e31dba0302b86a549a1ab1c54a50f369b2f969db324b8a904a54314b9a97b354234e3a48f276cab3ea5da1de7aa36365e336ca56e28a5a887a4631c9fa60a36d631d7a4211fd0a941a6ce95b0a9af3573345aa6472555ac83a5191e0eac8636c13320a6142708ac8da5632100ab8b36fb32a4a699230dac54a74918d8ab2f36793497a73424c4ac4aa4d51b64acef363d3327a5402620ad28a4832193acff36013301a6fc24a4ac3ea8b52073ac7c366d348ba82f232ead5ea08b178fac5d376732f5a35e2467adba9ed71eaaac6237473278a4ba1f8fac25a93c244caccb366534baa90b1c36ada194331174acd13770318ea1ce1e28ad5111f61a48acbf37453137a2c09ae2acb7a62822a2ac73376233b1a7e7a2bbacf9192a12d6ab1b38783005a0cd9ca1ac881b361785ab0338683093a0cf838cae789e9a14d8ad09388a3204a1bea852ab1f1d0a8f36a95138f62d9b9876a5e3a9611ba11033a82b38212d4c9d4625e2a088853b23929e84342932ad1ed99b09a4be1f92242d2cae35072da29c2cb4269bc725e22206244338db2ea62c31260ca80ea4551f59a70735da3393a3ab26cda6d6a24a1d559d6535fa3121a1e42423a4aba5f82233245f352131199f132315a9aba55c1911a958355e34a0a511258eaa38a63220fea8f135c43305a7222522a8aba4d11ad51c88357a328da6621a30a95aa78f1408a98a3599347aa76c22daabe5a6a52119aa40361e3494a80a2395ab23a66a23b6a73d369a336ba9f82044ab77a86b1eb4aaf535b334d8a8f11f68acfca5a22141aa9f36e233d8a85921c0acd3a4b12479a9be367b332aaa102350acd9a823238aab4a369e34c6a98d1c18ad4aa14f2051aa2d37d0327ba8cb1417ada2971a221ca94437443258a90f1b83acf8a891245aaba236813480aa699c91ad3b1f301b99aadf374b3170a6d8a1faac1224421a28a8dc37843099a73aa0ccac47a6842383ab46377f33bea85da538ad8424fa00dda93538c52f35a4eaa56aacbe25249450a61c38af2ed8a5211602af17982a1ce0ac02383d32fda255a9bfabc724439b78a66338382c6e983ba9a6a90925739bf09f4d38782ac4a16426cd9fb5980721dd9977341232ba20e2a5971e8e247315d92f1b35402b9f9220285b9da21f2c94572e7334182f75a5002518a75fa4192006a6e0340634caa3122415a5aca3901eca24f7341732d69e452765a680a232207d2c52348c3162a24f2186a813a6951b92a8373577342fa6e321bea981a6d62074a6a7350b3409a8241b56a75ca3ea135d282235b932baa69012cda8c5a79e198ea86c35b33432a82a1d11ab8da7b12322a8fa35533401aa4910d1aaa5a50124f89cf535d133b9aacd1ebaaa01a90021f9a9cc35dd34ada9e998fdab30a7e5248ea64f3638347eabea9b37ac1fa5682642a16d36d43391ac8a2118ac3fa91d24adaa1f36c53473aa51a280ac6ea3a72422a4db364f33e6ab93a50fac1499f624141ee336853298ac001772ac01a984247baa7a36a43406ab11a7d1ac8e20942115a2ac37533189aa01aa3caa2a25961de8267e3735303fab29a1c1ac77a6872316aa0a37df338fa93caa35ac9026161aa79d3038a42e94a8c5ab51a81a27bd953728fb37252d9fa9da1b30af4b9f3d2001acb837ab3258a58aac68a95b27989f341c80388127139c23ade889cb24119d85285c38281b69a4cb2694a221957223582313340832f323e49bd1200c241e1db52f8d33ee2e9e206724249464a23621ac32a331892db22317243da696a49820ffa4b9341e34f0a3321f41a2a7a15f1aac288134553264998b1bb891f794b10eca3091329030ff0e03200ca836a69c1c24a816358c34a9a6411ddfa886a69a207fa35635313407a81aa18fa56da10899572bb134da3224a5be9183a8d4a7a11a33a84f35cc3484a826953aaac8a7072424a5b1357f34abaac3a0d2a987a5cc23312396350f3424abfc1b49aa2ca96b214ea9a635003542aab7a202abf9a73826b599f8357a34d2acb2a43dab96a50e28b02509362134edad3f20a1ab90a94824dea9ed35ee34f9aae6a726abcda55827ca255d360a34e4adf6a99fa967a00728a72b4736343304afa69432ac35a937249ca94736d0347aab18ab56aa169c0e26a429f0365e32dbad81ad829ebb218923ba2e75360a3162aedaa176ac91a7c722e6a8b6363c3430aa15ad5fa86f236122612b95372430c0ac8aaeea242025c91b9f2fc836ca2ebead071e3eaf8da3a020aaaa47377533dfa5c3ad29a5472636a0412c2838d127d2a547aff92a8c225e9d1030a037ae9b24aaae22059a911ba1225a2100349632341f19a266243b243a9bde2f1534872ef31672adb0973c20c12ad33052314231b629d72291a5b6a4fe204fa492343734b9a3e4167da0079f4f144d282c34c832b81e45a03d225221279cb52f5032c830d425f31d51a747a6af1c92a7f334a334e1a60a150ca827a6451e3ba105355734c9a63aa457a38c9e74a0122b4f34253308987b9738a8bca7de18e4a73135e234a2a8139d4ea9b4a710229ea36235ab343faa07a4a8a862a55821f32523353e34f8a99c15cfa92ea90421d8a883351b358aaac0a40baa35a8ad25621fa035bc34ffac62a8eaa9eaa5a828f02a93355e34edaea61dadaab8a9e52361a9b535143529ab1da9daa9d1a73128d629db35813405afafac42a8fca1532af02fad35013421b1809c44ab7fa97622fda8ff350b359bab7dac3ba859a54328982d093612341ab068af471e8720dc2834326735973296b1d0a357ab87a89920f8a74636a434a9aae3ad3fa59a9ca925212f66367f32a4af50b04228fc265f2522335e354c3176b1e5192fae69a78720fca8a83643348fa7b9ac80a9ea23829b47309c36cf2f16ac49b07b2c922188202534a4355629fbae6f22b69725179520351f7b3363331a1f67985e2560234b23ec2e9730cb311625a9243a9d0b305badfe2e1a342d34d6b1c921f0a4c8a43e21f0a370345134bba3f709759ceb9c50963627aa333c3349241c9e1423c923b4a2b22d1032b7313728a71c8fa66aa6a71c34a7d534ba3411a74d03bda613a62519faa1bc348234b7a4e7a4be9f189c06a42e2ad2335f33fe25f096d4a7aca78d0f05a81535f73470a8969b77a8eaa75a1c2fa51935da34a2a852a450a604a5fe9ad024a0345d340fa4631635a920a9fe1d31a95b35393510aa2fa142a987a8582090a24d350135d0aad9a730a8cca588230329f834913415ac071d73a96ca95d21bda973353b35c5aa33a4bea9d9a81d2476117835fe3492ac4bac0ba8a2a4c628032f22357a342fb0ce9e4aa947a99d1967a99f354b35d8aa27a88aa91aa8ab2236258d35e93416ad4eafe5a44e9bed2a4432043533340bb252a580a883a8239e21a8b3351f3503aa85aa34a932a5f1196528bb35ab34d1acd7b0719c3a224d2b7a33fe34a03354b2ab9ad6abc1aaad1f46a9d6353335f2a8faa9a4abe3a577945128c8355b34b9a8edb072999c24a229113451350d3095af
