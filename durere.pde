

   
 import processing.sound.*;
 import KinectPV2.*;
 import KinectPV2.KJoint;
 
 KinectPV2 kinect;

 SoundFile file1;
 SoundFile file2;
 SoundFile file3;
 SoundFile file4;
 SoundFile file5;
 SoundFile file6;
 SoundFile file7; 

 
 int bar1Timeout = 0;
 int bar2Timeout = 0;
 int bar3Timeout = 0;
 int bar4Timeout = 0;
 int bar5Timeout = 0;
 int bar6Timeout = 0;
 int bar7Timeout = 0;
 int timerFrames = 90;
 int fadeInFrames = 10;
 int fadeOutFrames = 20;
 int barWidth = 183;

void setup() {   

 size(1270, 720);
 kinect = new KinectPV2(this);
 kinect.enableSkeleton3DMap(true);
 kinect.init();
 
 file1 = new SoundFile(this,"");

 file1 = new SoundFile(this,"Ab_H_no_01.mp3");
 file2 = new SoundFile(this,"Bb_H_no_01.mp3");
 file3 = new SoundFile(this,"C_H_no_01.mp3");
 file4 = new SoundFile(this,"Db_H_no_01.mp3");
 file5 = new SoundFile(this,"Eb_H_no_01.mp3");
 file6 = new SoundFile(this,"F_H_no_01.mp3");
 file7 = new SoundFile(this,"G_H_no_01.mp3"); 
}  

void draw() {  
   captureKinect();
   background(0);
   bar1Timeout = drawBox(bar1Timeout,220,220,220,1);
   bar2Timeout = drawBox(bar2Timeout,255,255,0,2);
   bar3Timeout = drawBox(bar3Timeout,0,255,255,3);
   bar4Timeout = drawBox(bar4Timeout,0,255,0,4);
   bar5Timeout = drawBox(bar5Timeout,255,0,255,5);
   bar6Timeout = drawBox(bar6Timeout,255,0,0,6);
   bar7Timeout = drawBox(bar7Timeout,0,0,255,7);
} 

void captureKinect() {
   ArrayList<KSkeleton> skeletonArray =  kinect.getSkeleton3d(); 
   println(skeletonArray.size());
}

void keyPressed() {
 if (key == '1') {
    bar1Timeout = 1;
    file1.play();
  } else if (key == '2') {
    bar2Timeout = 1;
    file2.play();
  } else if (key == '3') {
     bar3Timeout = 1;
     file3.play();
  } else if (key == '4') {
     bar4Timeout = 1;
     file4.play();
  } else if (key == '5') {
    bar5Timeout = 1;
    file5.play();
  } else if (key == '6') {
     bar6Timeout = 1;
     file6.play();
  } else if (key == '7') {
     bar7Timeout = 1;
     file7.play();
  }
}

int drawBox(int t, int r, int g, int b, int pos) {
   if ((t > 0) && (t < timerFrames)) {
     float a = 256;
     if (t < fadeInFrames) a = float(t) / float(fadeInFrames) * 256.0;
     if (t > (timerFrames - fadeOutFrames)) a = float(fadeOutFrames - (t + (fadeOutFrames-timerFrames))) / float(fadeOutFrames) * 256.0;
     fill(r,g,b,a);
     rect((barWidth * (pos-1)),0,barWidth,720);
     t++; 
     if (t == timerFrames) t = 0;
   }
   return t;
}