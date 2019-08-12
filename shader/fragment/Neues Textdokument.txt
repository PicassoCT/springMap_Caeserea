precision highp float;
uniform float time;
uniform vec2 resolution;
varying vec3 fPosition;
varying vec3 fNormal;

vec3 fixedNormal;


vec3 hit= vec3(1.0,0.8,0.3 );


vec3 glowing= vec3(0.9,0.3,0.1);


vec3 cooldown= vec3(0.4,0.1,0.05);


vec3 wreck=vec3(0.185,0.155,0.155);


vec3 currColor;
float averageShadow;

float PI=3.14159;
float privateTime=0.0;
float fixedTime=0.0;
float totalTime=1.0;
float percenTage=0.0;
vec3 emptyVec = vec3(0.0,0.0,0.0);

vec3 clampAfter(vec3 x, float Time, float TimeLimit)
{
    return (Time < TimeLimit ? x :emptyVec);
}

vec3 openEnded(vec3 x, float Time, float TimeLimit, vec3 deFault)
{
  return Time < TimeLimit ? x :deFault;
}

void main()
{
privateTime+=0.1;
percenTage= (mod((time),totalTime))/totalTime*PI;


averageShadow=(fNormal.x*fNormal.x+fNormal.y*fNormal.y+fNormal.z+fNormal.z)/3.25;

currColor=(
 //clampAfter(hit*cos(percenTage)*2.0,percenTage,0.5*PI) 
 (percenTage < 0.5*PI ?  hit*cos(percenTage)*2.0 :emptyVec)
//+ clampAfter(glowing*sin(percenTage)*2.5,percenTage,PI)
+ (percenTage < PI ? glowing*sin(percenTage)*2.5 :emptyVec)
//+clampAfter(cooldown*sin(PI+percenTage)*2.0,PI+percenTage,PI*2.0)
+ (percenTage < PI*2.0 ? cooldown*sin(PI+percenTage)*2.0 :emptyVec)
//+openEnded(wreck*abs(sin(PI+percenTage)),PI+percenTage,PI*2.0,abs(wreck*0.3))
+openEnded(wreck*abs(sin(PI+percenTage)),PI+percenTage,PI*2.0,abs(wreck*0.3))
);

  gl_FragColor = vec4(currColor*(1.0-averageShadow), 1);
}