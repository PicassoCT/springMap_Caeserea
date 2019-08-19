

        uniform ivec2 texSquare;
        varying vec2 texCoors;

        varying vec4 colorChange;
		varying vec3 fNormal;
		
        uniform float time;
        uniform float points[30];
        uniform int pointSize;
		
		float totalTime= 1.0;
		float PI_HALF= 3.14159/2.0;
		float PI =3.14159;
		float changeRate = 0.0;


        void main(void) {		
				fNormal = normalize(gl_NormalMatrix  * gl_Normal);
			
				// fNormal = gl_Normal.xyz; //normalize(gl_NormalMatrix* gl_Vertex.xyz);
			
				float sigNum = 1.0;
				float relTime = abs(mod(time/totalTime,totalTime));
			//	melting process - a inverse cosinus rising 
				float meltSpeed=abs(cos(relTime/(PI*2.0)));
				float molten = abs(1.0-cos((time/totalTime)*PI_HALF));
				
			//	percentage we scale the vector out or inwards
				float percentage= (sqrt(abs(gl_Normal.y)/(abs(gl_Normal.x)+abs(gl_Normal.z) +0.01)))/50.0; // /50
				
				
				sigNum=(fNormal.y <= 0.0)  ? -1.41  : 1.0;
			  
			 // computate the total melting and end it at max where the molten metall gets hadr
			 // keep Constant Change
			  //changeRate= relTime < 0.5*totalTime? mix(0.0,percentage*sigNum*molten,relTime/0.5*(totalTime)):percentage*sigNum*molten;
			  
				
				//move the position along the gl_Normal and transform it
				vec3 newPosition = gl_Vertex.xyz + fNormal * changeRate;
				gl_Position = gl_ModelViewProjectionMatrix * vec4( newPosition, 1.0  );
        }
		
		