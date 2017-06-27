function widget:GetInfo()
	return {
		name      = "MapShader",
		desc      = "MapShader demo",
		author    = "gajop",
		date      = "",
		license   = "",
		layer     = 0,
		enabled   = true,
	}
end

local shader, timeID, pointsID, pointsSizeID

local MAX_POINTS = 10
local points = {}

function widget:Initialize()
    local vertexShader = [[
        #define SMF_TEXSQR_SIZE 1024.0

        uniform ivec2 texSquare;
        varying vec2 texCoors;

        varying vec4 colorChange;
		varying vec4 vertexWorldPos;

        uniform float time;
        uniform float points[MAX_POINTS];
        uniform int pointSize;

        void main(void) {
            texCoors = (floor(gl_Vertex.xz) / SMF_TEXSQR_SIZE) - vec2(texSquare);

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
			vertexWorldPos = gl_Vertex;
        }
    ]]
    vertexShader = vertexShader:gsub("MAX_POINTS", tostring(MAX_POINTS*3))
    shader = gl.CreateShader({
        vertex = vertexShader,

        fragment = [[
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
        ]],

        uniformInt = {
            texSampler = 0,
            pointSize  = 0,
        },
        uniformFloat = {
            time = 0,
        },
    })

    local errors = gl.GetShaderLog(shader)
    if errors ~= "" then
        Spring.Log("MapShaders", LOG.ERROR, errors)
    end
    Spring.SetMapShader(shader, 0)
end

function widget:Shutdown()
    Spring.SetMapShader(0, 0)
end

function widget:DrawWorld()
    gl.UseShader(shader)
    if not timeID then
        timeID         = gl.GetUniformLocation(shader, "time")
        pointsID       = gl.GetUniformLocation(shader, "points")
        pointSizeID    = gl.GetUniformLocation(shader, "pointSize")
    end
    gl.Uniform(     timeID,       os.clock())
    gl.UniformInt(  pointSizeID,  #points/3)
    gl.UniformArray(pointsID,     1, points)
    gl.UseShader(0)
end

function widget:MousePress(x, y, button)
    local time = os.clock()
    if button == 1 or button == 3 then
        local result, coords = Spring.TraceScreenRay(x, y, true)
        if result == "ground" then
            if #points >= MAX_POINTS * 3 then
                table.remove(points, 1)
                table.remove(points, 1)
                table.remove(points, 1)
            end
            table.insert(points, coords[1])
            table.insert(points, coords[3])
            table.insert(points, time)
        end
    end
end