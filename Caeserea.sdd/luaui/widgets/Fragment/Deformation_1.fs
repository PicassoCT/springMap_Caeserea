

            uniform sampler2D texSampler;

            varying vec2 texCoors;

            varying vec4 colorChange;
			varying vec4 vertexWorldPos;

            void main(void) {
                gl_FragColor = texture2D(texSampler, texCoors);
				if (vertexWorldPos.x > 2000. && vertexWorldPos.x < 4000.) {
					float w = sqrt((vertexWorldPos.x - 3000.) * (vertexWorldPos.x - 3000.));
					w /= 1000;
					w = min(1., w);
					gl_FragColor.rgb = mix(vec3(vertexWorldPos.y)/1024., gl_FragColor.rbg, w);//vec3((gl_FragColor.r + gl_FragColor.g + gl_FragColor.b) / 3.);
				}
                //gl_FragColor += colorChange;
            }