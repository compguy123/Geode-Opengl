#version 150

in vec4 vPosition;
in vec4 vColor;
in vec4 vLine;
out vec4 color;
out vec4 position; 

uniform mat4 ModelView;
uniform mat4 Projection;
uniform mat4 Transformation;

uniform int Object;
uniform int Slice;

uniform vec4 Color;

uniform vec4 AmbientProduct, DiffuseProduct, SpecularProduct;
uniform vec4 LightPosition;
uniform float Shininess;

uniform int Perturb;
uniform int Extra;


float rand(vec2 co) {
  return fract(sin(dot(co.xy, vec2(12.9898, 78.233))) * 43758.5453);
}

//give a range for the pertrub based on lerp function 
float randomRange(vec2 seed, float minVal, float maxVal) {
  return mix(minVal, maxVal, rand(seed));
}
void main() 
{

    //lighing model
    vec3 pos = (ModelView * vPosition).xyz;

    vec3 L = normalize( LightPosition.xyz - pos );
    vec3 E = normalize( -pos );
    vec3 H = normalize( L + E );

    // Transform vertex normal into eye coordinates
    vec3 N = normalize( ModelView * vec4(vPosition.xyz,0) ).xyz;

    // Compute terms in the illumination equation
    vec4 ambient = AmbientProduct;

    float Kd = max( dot(L, N), 0.0 );
    vec4  diffuse = Kd*DiffuseProduct;

    float Ks = pow( max(dot(N, H), 0.0), Shininess );
    vec4  specular = Ks * SpecularProduct;
    
    if( dot(L, N) < 0.0 ) {
       specular = vec4(0.0, 0.0, 0.0, 1.0);

       }

        color = ambient + diffuse + specular;
        color.a = 1.0;
        color*=2;
vec4 modifiedPosition = vPosition;
float perturb;



//perturb based on key. 
if(Perturb==1)
//no pertrub
    perturb=0;
 
if(Perturb==2)
//add move the vertex between -.1 and .1 for petrub 
  perturb  = randomRange(vec2(modifiedPosition.x,modifiedPosition.y),-.1,.1);
       
if(Perturb==3)
//add move the vertex between -.2 and .3 for petrub 
    perturb  = randomRange(vec2(modifiedPosition.x,modifiedPosition.y),-.2,.3);
     

     //object 1 is the sphere 
if(Object==1){
    //do slicing distance 
    if(Slice==1){  
        if((modifiedPosition.z>.7)){
        //add pertrub after its been sliced
            modifiedPosition.z=.7 +perturb;
        }else{
        //else changes color for the part that was not sliced 
            color /=2;
        }
     }else if(Slice ==2){
            if((modifiedPosition.z>.4)){
            modifiedPosition.z=.4 +perturb;
        }else{
             color /=2;
        }
     }else if(Slice ==3){
             if((modifiedPosition.z>.1)){
            modifiedPosition.z=.1+perturb;
        }else{
                color /=2;
            }

     }
// THis is for wireframe
}else{
color= Color;
    if(Slice==1){  
    //add .5 so wireplane is slightly above traiangles 
        if((modifiedPosition.z>.7)){
            modifiedPosition.z=.7+perturb+.05;
            modifiedPosition.z*=1.01;
            
            }
     }else if(Slice ==2){
         if((modifiedPosition.z>.4))
           modifiedPosition.z=.4+perturb+.05;
            modifiedPosition.z*=1.01;
            
     }else if(Slice ==3){
        if((modifiedPosition.z>.1)){
            modifiedPosition.z=.1+perturb+.05;
            modifiedPosition.z*=1.01;
            
            }
     }
}

//extra feature 
if(Extra==2){
// Squash the sphere along the y-axis based on distance from the xz plane
  float distFromXZ = length(modifiedPosition.xz);
  modifiedPosition.y -= distFromXZ * 0.3;

 }else if(Extra==3){
 //stretch based on x 
   float stretch = 1.0 + abs(modifiedPosition.x) * 0.5;
  modifiedPosition.y *= stretch;

 }
    gl_Position = Projection  * ModelView * modifiedPosition;
    //send to fragment shader
    position= modifiedPosition;
   
 }
