//video sorce: https://www.youtube.com/watch?v=DYOUtQULYos
//background:  http://girlschannel.net/topics/338713/
/** face and background change*/
#include "opencv2/opencv.hpp"
#include <stdio.h>
#include <time.h>

using namespace cv;
using namespace std;

String face_cascade_name = "lbpcascade_frontalface.xml"; //human face training data
CascadeClassifier face_cascade; //face data classifier


int detectAndDisplay(Mat, Mat);


int main( void ){
  Mat src, dst;
  Mat back, newBack, backMask;
  int frames;

  VideoCapture cap("hw3_sorce.mp4");

  if (!cap.isOpened()){
    printf("Cannot open video.\n");
    return 0;
  }

  newBack = imread("background.jpg");
  if(newBack.data == 0){
    printf("No background image\n");
    return 0;
  }
  frames = cap.get(CV_CAP_PROP_FRAME_COUNT);
  cap.set(CV_CAP_PROP_POS_FRAMES, frames - 5);
  cap >> back;

  cap.set(CV_CAP_PROP_POS_FRAMES, 0);
  resize(newBack, newBack, back.size());

  //import face data
  if(!face_cascade.load(face_cascade_name)){
    printf("--(!)Error loading face cascade\n");
    waitKey(0);
    return -1;
  }

  //enter ESC to exit
  while (char(waitKey(1)) != 27 && cap.isOpened()){
    cap >> src; //get video screen
    if( src.empty() ){
      printf(" --(!) No captured src -- Break!\n");
      break;
    }

    imshow("input video", src);
    src.copyTo(dst); //dst for output

    absdiff(back, dst, backMask);
    cvtColor(backMask, backMask, CV_BGR2GRAY);
    threshold(backMask, backMask, 50, 255, THRESH_BINARY_INV);
    medianBlur(backMask, backMask, 5);
    newBack.copyTo(dst, backMask);
    imshow("Background Mask", backMask);

    //face
    if(detectAndDisplay(src, dst) == -1) break;

  }
  return 0;
}


int detectAndDisplay(Mat src, Mat dst){

  vector<Rect> faces;
  static Rect faceROI;
  Mat src_gray;
  Mat newFace, newFaceMask;
  int i, rectSize, max = 0, maxIndex;

  cvtColor(src, src_gray, COLOR_BGR2GRAY);
  equalizeHist(src_gray, src_gray); //enhance contrast

  newFace = imread("face.jpg");
  newFaceMask = imread("mask.jpg");
  if(newFace.data == 0 || newFaceMask.data == 0){
    printf("No image\n");
    return -1;
  }

  face_cascade.detectMultiScale(src_gray, faces, 1.1, 4, 0, Size(80, 80));
  if(faces.size() != 0){
    //get MAX face
    for(i = 0; i < faces.size(); i++){
      rectSize = faces[i].width * faces[i].height;
      if(max < rectSize){
        max = rectSize;
        maxIndex = i;
      }
    }
    //max face data
    faceROI = faces[maxIndex];
  }
  //change face
  resize(newFace, newFace, Size(faceROI.width, faceROI.height));
  resize(newFaceMask, newFaceMask, Size(faceROI.width, faceROI.height));
  newFace.copyTo(dst(faceROI), newFaceMask);


  imshow("output video", dst);
  waitKey(50);
  return 0;
}