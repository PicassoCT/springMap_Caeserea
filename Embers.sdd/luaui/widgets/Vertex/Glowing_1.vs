precision highp float;
attribute vec3 position;
attribute vec3 normal;
uniform mat3 normalMatrix;
uniform mat4 modelViewMatrix;
uniform mat4 projectionMatrix;
varying vec3 fNormal;
varying vec3 fPosition;
uniform float time;
varying float changeRate;
float totalTime=1.0;
float PI_HALF= 3.14159/2.0;
float PI =3.14159;



void main()
{
   fNormal = normalize(normalMatrix * normal);
  //vec4 pos = modelViewMatrix * vec4(position, 1.0);

    float sigNum=1.0;
    float relTime=abs(mod(time/totalTime,totalTime));
    //melting process - a inverse cosinus rising 
    float meltSpeed=abs(cos(relTime/(PI*2.0)));
    float molten = abs(1.0-cos((time/totalTime)*PI_HALF));
    
    //percentage we scale the vector out or inwards
    float percentage= (sqrt(abs(normal.y)/(abs(normal.x)+abs(normal.z) +0.01)))/50.0; // /50
    
    
    sigNum=(fNormal.y >= 0.0)  ? -1.41  : 1.0;
  
  //computate the total melting and end it at max where the molten metall gets hadr
  //keep Constant Change
  changeRate= relTime < 0.5*totalTime? mix(0.0,percentage*sigNum*molten,relTime/0.5*(totalTime)):percentage*sigNum*molten;
  
    
    // move the position along the normal and transform it
    vec3 newPosition = position + fNormal * changeRate;
    gl_Position = projectionMatrix * modelViewMatrix * vec4( newPosition, 1.0  );
 
  //gl_Position = projectionMatrix * pos;
}