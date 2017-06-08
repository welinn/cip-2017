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

int detectAndDisplay(Mat, Mat, VideoWriter);
bool skinCheck(bool, Mat, Rect);

int main( void ){
  Mat src, dst;
  Mat back, newBack, backMask;
  int frames;
  Size videoSize;
  VideoWriter writer;
  VideoCapture cap("hw3_sorce.mp4");

  if (!cap.isOpened()){
    printf("Cannot open video.\n");
    return 0;
  }

  videoSize = Size(cap.get(CV_CAP_PROP_FRAME_WIDTH),cap.get(CV_CAP_PROP_FRAME_HEIGHT));
  writer.open("hw3_output.avi", CV_FOURCC('M', 'J', 'P', 'G'), 30, videoSize);

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

    //change background
    absdiff(back, dst, backMask);
    cvtColor(backMask, backMask, CV_BGR2GRAY);
    threshold(backMask, backMask, 30, 255, THRESH_BINARY_INV);
    medianBlur(backMask, backMask, 5);
    newBack.copyTo(dst, backMask);
    imshow("Background Mask", backMask);

    //face
    if(detectAndDisplay(src, dst, writer) == -1) break;
  }
  return 0;
}

int detectAndDisplay(Mat src, Mat dst, VideoWriter writer){

  Mat src_gray;
  Mat newFace, newFaceMask;
  int i, rectSize, max = 0, maxIndex;
  int textMove = dst.cols * 0.01;
  bool changeFace;
  vector<Rect> faces;
  static Rect faceROI((int) dst.cols / 2, (int) dst.rows / 2, dst.cols, dst.rows);
  static Point textPt(dst.cols - textMove - 1, (int)dst.rows * 0.8);
  static bool textRunLeft = true;

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
    //enlarge roi
    faceROI.x -= (int) faceROI.width * 0.1;
    faceROI.y -= (int) faceROI.height * 0.1;
    faceROI.width *= 1.2;
    faceROI.height *= 1.2;

    changeFace = skinCheck(true, src, faceROI);
  }
  else changeFace = skinCheck(false, src, faceROI);

  //change face
  if(changeFace){
    resize(newFace, newFace, Size(faceROI.width, faceROI.height));
    resize(newFaceMask, newFaceMask, Size(faceROI.width, faceROI.height));
    newFace.copyTo(dst(faceROI), newFaceMask);
  }

  textPt.x -= textRunLeft ? textMove : -textMove;
  if(textPt.x < textMove || textPt.x > dst.cols - textMove) textRunLeft = !textRunLeft;
  putText(dst, "M10515103", textPt,
          FONT_HERSHEY_COMPLEX | FONT_ITALIC, 1, CV_RGB(0, 0, 0), 3, CV_AA);

  writer.write(dst);
  imshow("output video", dst);
  waitKey(50);
  return 0;
}

bool skinCheck(bool face, Mat img, Rect roi){

  static int faceSize = 0;
  int size = 0;
  int i, j;
  Mat skin;

  cvtColor(img(roi), skin, CV_BGR2HSV);
  for(i = 0; i < skin.rows; i++){
    for(j = 0; j < skin.cols; j++){
      if(skin.at<Vec3b>(i, j)[0] < 20) size++;
    }
  }

  if(face){
    faceSize = faceSize == 0 ? size : (int) (faceSize + size) / 2;
    return true;
  }
  if(size < faceSize / 2) return false;
  return true;
}
