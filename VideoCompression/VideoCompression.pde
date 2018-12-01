int blockSize=5;
int frame=0;
int frames=1086;
int keyframeIndex=25;
int w=320;
int h=240;
int frameDifference=2;

PImage img;

Block[][] keyframe;

void setup(){
  size(1080,240);
  surface.setSize(w*3,h);
}

void draw(){
  println("scene"+frame+".png");
  img=loadImage("scene"+addZeros((frame*frameDifference)+1)+".png");
  drawLeft(frames!=0);
  if(frame>0){
    drawKeyframe();
  }
  drawRight(true,frame%keyframeIndex==0);
  saveFrame("result/frame"+frame+".png");
  if(frames!=0){
    if(frame<frames-1){
      frame++;
    } else {
      noLoop();
    }
  }
  stroke(0);
  line(w,0,w,height);
}

void drawLeft(boolean image){
  if(!image){
    for(int x=0;x<round(w);x++){
      for(int y=0;y<height;y++){
        set(x,y,color(sin(x/10)*255,sin(x/5)*255,sin(x/25)*255));
      }
    }
  } else{
    image(img,0,0,w,h);
  }
}

void drawRight(boolean compress,boolean first){
  if(!compress){
    for(int x=w+blockSize;x<width+blockSize;x+=blockSize){
      for(int y=0;y<height+blockSize;y+=blockSize){
        int _x=randomI((w/blockSize)+w)*blockSize;
        int _y=randomI(height/blockSize)*blockSize;
        Block temp = getBlock(_x,_y);
        drawBlock(temp,x,y);
      }
    }
    for(int x=w+blockSize;x<width+blockSize;x+=blockSize){
      for(int y=0;y<height+blockSize;y+=blockSize){
        line(x-blockSize,y,x,y);
        line(x,y-blockSize,x,y);
      }
    }
  } else{
    if(first){
      keyframe=new Block[(w)/blockSize][height/blockSize];
      for(int x=0;x<keyframe.length;x++){
        for(int y=0;y<keyframe[0].length;y++){
          Block temp = getBlock((x*blockSize)+w,y*blockSize);
          drawBlock(temp,(x*blockSize)+w,y*blockSize);
          keyframe[x][y]=temp;
        }
      }
    } else {
      for(int x=0;x<keyframe.length;x++){
        for(int y=0;y<keyframe[0].length;y++){
          Block temp=getClosestBlock(keyframe,getBlock((x*blockSize)+w,y*blockSize));
          drawBlock(temp,(x*blockSize)+w,y*blockSize);
        }
      }
      //for(int x=w+blockSize;x<width+blockSize;x+=blockSize){
      //  for(int y=0;y<height+blockSize;y+=blockSize){
      //    line(x-blockSize,y,x,y);
      //    line(x,y-blockSize,x,y);
      //  }
      //}
    }
  }
}

Block getBlock(int x,int y){
  color[][] t=new color[blockSize][blockSize];
  for(int _x=0;_x<blockSize;_x++){
    for(int _y=0;_y<blockSize;_y++){
      t[_x][_y]=get(((x+_x)-w)-blockSize,y+_y);
    }
  }
  return new Block(t);
}

void drawBlock(Block b,int x,int y){
  for(int _x=0;_x<blockSize;_x++){
    for(int _y=0;_y<blockSize;_y++){
      set((_x+x)-blockSize,_y+y,b.c[_x][_y]);
    }
  }
}

int randomI(int max){
  return round(random(max));
}

String addZeros(int num){
  if(num<10){
    return "0000"+num;
  }
  if(num<100){
    return "000"+num;
  }
  if(num<1000){
    return "00"+num;
  }
  if(num<10000){
    return "0"+num;
  }
  return ""+num;
}

Block getClosestBlock(Block[][] b1,Block b2){
  int _x=0;
  int _y=0;
  float record=9999999;
  for(int x=0;x<b1.length;x++){
    for(int y=0;y<b1[0].length;y++){
      if(b2.compareBlock(b1[x][y])<record){
        record=b2.compareBlock(b1[x][y]);
        _x=x;
        _y=y;
      }
    }
  }
  return b1[_x][_y];
}

void drawKeyframe(){
  for(int x=0;x<keyframe.length;x++){
    for(int y=0;y<keyframe[0].length;y++){
      Block temp=keyframe[x][y];
      drawBlock(temp,(x*blockSize)+w*2,y*blockSize);
    }
  }
}
