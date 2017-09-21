
#version 330

layout(location = 0) in vec3 pos;
layout(location = 1) in vec2 texCoord;
layout(location = 2) in float layer;
//layout(location = 3) in vec3 norm;


uniform mat4 modelView;
uniform mat4 projection;
uniform vec3 displacement;
in vec3 vertex;
uniform	float time;


out vec2 fragTexCoord;
out float fragLayer;

void main(void) {

	float offset = (sin (time+ vertex.x+ vertex.y+ vertex.z)); //value from -1 to 1; 
	float currentOffset = maxOffset * offset;//value from -maxVertexOffset to maxVertexOffset;
	vec3 layerDisplacement = pow(layer, 3.0) * displacement;
	vec4 newPos = vec4(pos + layerDisplacement, 1.0);
	gl_Position = projection * modelView * newPos + vec4(vertex* currentOffset,1.0);
  
  fragTexCoord = texCoord;
  fragLayer = layer;
}
