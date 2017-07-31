

   
 import processing.sound.*;
 import KinectPV2.*;
 import KinectPV2.KJoint;
 
 KinectPV2 kinect;

 SoundFile audioFile1;
 SoundFile audioFile2;
 SoundFile audioFile3;
 SoundFile audioFile4;
 SoundFile audioFile5;
 SoundFile audioFile6;
 SoundFile audioFile7;
 int[] barTimeouts;
 int[] movementTriggers;
 int trackingSkeleton = 0;
 int timerFrames = 90;
 int fadeInFrames = 10;
 int fadeOutFrames = 20;
 int barWidth = 183;

void setup() {   

 size(1270, 720);
 kinect = new KinectPV2(this);
 kinect.enableSkeleton3DMap(true);
 kinect.init();
 
 barTimeouts = new int[7];
 for (int i=0;i<barTimeouts.length;i++) {
   barTimeouts[i]=0; 
 }
 
 movementTriggers = new int[7];
 for (int i=0;i<barTimeouts.length;i++) {
   movementTriggers[i]=0; 
 }
 audioFile1 = new SoundFile(this,"Ab_H_no_01.mp3");
 audioFile2 = new SoundFile(this,"Bb_H_no_01.mp3");
 audioFile3 = new SoundFile(this,"C_H_no_01.mp3");
 audioFile4 = new SoundFile(this,"Db_H_no_01.mp3");
 audioFile5=  new SoundFile(this,"Eb_H_no_01.mp3");
 audioFile6 = new SoundFile(this,"F_H_no_01.mp3");
 audioFile7 = new SoundFile(this,"G_H_no_01.mp3");
}  

void draw() {  
   captureKinect();
   background(0);
   barTimeouts[0] = drawBox(barTimeouts[0],220,220,220,1);
   barTimeouts[1] = drawBox(barTimeouts[1],255,255,0,2);
   barTimeouts[2] = drawBox(barTimeouts[2],0,255,255,3);
   barTimeouts[3] = drawBox(barTimeouts[3],0,255,0,4);
   barTimeouts[4] = drawBox(barTimeouts[4],255,0,255,5);
   barTimeouts[5] = drawBox(barTimeouts[5],255,0,0,6);
   barTimeouts[6] = drawBox(barTimeouts[6],0,0,255,7);
} 

void captureKinect() {
   ArrayList<KSkeleton> skeletonArray =  kinect.getSkeleton3d(); 
   for (int i=0;i<skeletonArray.size();i++) {
     KSkeleton skeleton = (KSkeleton) skeletonArray.get(i);
     if ((i==trackingSkeleton) && skeleton.isTracked()) {
       KJoint[] joints = skeleton.getJoints();
       movementConditions(joints);
     }
   }
}

void movementConditions(KJoint[] joints) {
   if ((joints[KinectPV2.JointType_HandRight].getY() > joints[KinectPV2.JointType_Head].getY()) && (movementTriggers[0] == 0)) kinectTriggered(0);
   if (joints[KinectPV2.JointType_HandRight].getY() < joints[KinectPV2.JointType_Head].getY()) kinectReset(0);
   if ((joints[KinectPV2.JointType_HandLeft].getY() > joints[KinectPV2.JointType_Head].getY()) && (movementTriggers[1] == 0)) kinectTriggered(1);
   if (joints[KinectPV2.JointType_HandLeft].getY() < joints[KinectPV2.JointType_Head].getY()) kinectReset(1);
}

void kinectReset(int t) {
    movementTriggers[t] = 0; 
}

void kinectTriggered(int t) {
  int k = t+1;
  if (k == 1) {
    resetTimeout(0);
    audioFile1.play();
    movementTriggers[t]=2; 
  }
  if (k == 2) {
    resetTimeout(1);
    audioFile2.play();
    movementTriggers[t]=2; 
  }
}

void keyPressed() {
 if (key == '1') {
    resetTimeout(0);
    audioFile1.play();
  } else if (key == '2') {
    resetTimeout(1);
    audioFile2.play();
  } else if (key == '3') {
    resetTimeout(2);
    audioFile3.play();
  } else if (key == '4') {
    resetTimeout(3);
    audioFile4.play();
  } else if (key == '5') {
    resetTimeout(4);
    audioFile5.play();
  } else if (key == '6') {
    resetTimeout(5);
    audioFile6.play();
  } else if (key == '7') {
     resetTimeout(6);
     audioFile7.play();
  }
}

void resetTimeout(int i) {
   barTimeouts[i]=1; 
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