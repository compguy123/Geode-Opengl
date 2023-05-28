#version 150

in vec4 color;

out vec4 fColor;

uniform int Object;

uniform int Slice;
in vec4 position;
void main()
{

 //for sphere
if(Object==1){

//change color based on pertrub. This is what give brown color in the petrubed area. 
    if(Slice==1){  
        if((position.z>.7)){
             fColor =color*gl_FragCoord.z/2;
        }else{
            fColor=color;
        }
     }else if(Slice ==2){
            if(position.z>.4){
             fColor =color*gl_FragCoord.z/2;
        }else{
            fColor=color;
        }
     }else if(Slice ==3){
             if((position.z>.1)){
                 fColor =color*gl_FragCoord.z/2;
        }else{
         fColor=color;
            }

     }
     //for wireframe
}else {
fColor= color;

}

}
