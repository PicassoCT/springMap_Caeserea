

        uniform ivec2 texSquare;
        varying vec2 texCoors;

        varying vec4 colorChange;

        uniform float time;
        uniform float points[30];
        uniform int pointSize;

        void main(void) {
            texCoors = (floor(gl_Vertex.xz) / 1024.0)- vec2(texSquare);

            vec4 pos = gl_Vertex;
            colorChange = vec4(0, 0, 0, 1);
            for (int i = 0; i < pointSize; i++) {
                float d = distance(vec2(points[i*3], points[i*3+1]), pos.xz);
                float dtime = time - points[i*3+2];

                float timeFalloff = pow(dtime, 3) + 1;
                float rangeFalloff = pow(d/400, 2) + 1;
                float rangeFrequency = sin(d/1000 + 1);
                pos.y += sin(dtime*10) * 200 / rangeFalloff * rangeFrequency / timeFalloff;

                colorChange += vec4(sin(dtime*10) * 200 / rangeFalloff * rangeFrequency / timeFalloff) / 1000;
            }
            gl_Position = gl_ModelViewProjectionMatrix * pos;
        }