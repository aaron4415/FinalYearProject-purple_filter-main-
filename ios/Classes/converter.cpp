//
// Created by alexyuyl on 6/3/2023.
//

#include <cmath>
#include <algorithm>
#include <stdint.h>
#include "converter.h"

#include <opencv2/opencv.hpp>
#include <opencv2/core.hpp>
#include <opencv2/imgcodecs.hpp>
#include <opencv2/imgproc.hpp>
#include <opencv2/highgui.hpp>
#include <opencv2/core/utility.hpp>
#include "NumCpp.hpp"

extern "C" {
    using namespace std;

    __attribute__((visibility("default"))) __attribute__((used)) int clamp(int lower, int higher, int val) {
        if (val < lower) return 0;
        else if (val > higher) return 255;
        else return val;
    }

    __attribute__((visibility("default"))) __attribute__((used)) int getRotatedImageByteIndex(int x, int y, int rotatedImageWidth) {
        return rotatedImageWidth * (y+1) - (x+1);
    }

    __attribute__((visibility("default"))) __attribute__((used))
    int *convertImage(uint8_t *plane0, uint8_t *plane12, int size1, int size2, int bytesPerRow, int bytesPerPixel, int width, int height) {
        int bytesPerColumn = size1 / bytesPerRow;

        int x, y, uvIndex, index;
        int yp, up, vp;
        int r, g, b;
        int rt, gt, bt;

        int n = size2;

        uint8_t *plane1 = (uint8_t *)malloc(sizeof(uint8_t) * n / 2);
        uint8_t *plane2 = (uint8_t *)malloc(sizeof(uint8_t) * n / 2);

        int uCount = 0;
        int vCount = 0;
        for (int i = 0; i < n; i++) {
            if (i % 2 == 0) {
                plane1[uCount] = plane12[i];
                uCount++;
            } else if (i % 2 == 1) {
                plane2[vCount] = plane12[i];
                vCount++;
            }
        }

        uCount = 0; vCount = 0;

        vector<int> data0int0; vector<int> data1int0; vector<int> data2int0;

        for (x = 0; x < bytesPerColumn; x++) {
                for (y = 0; y < bytesPerRow; y++) {
                    uvIndex = (x/4) * bytesPerRow +  y/2;
                    index = x * bytesPerRow + y;

                    yp = plane0[index];
                    up = plane1[uvIndex];
                    vp = plane2[uvIndex];

                    rt = round(yp + vp * 1436 / 1024 - 179);
                    gt = round(yp - up * 46549 / 131072 + 44 - vp * 93604 / 131072 + 91);
                    bt = round(yp + up * 1814 / 1024 - 227);
                    r = clamp(0,255,rt);
                    g = clamp(0,255,gt);
                    b = clamp(0,255,bt);

                    data0int0.push_back(r);
                    data1int0.push_back(g);
                    data2int0.push_back(b);
                }
        }

        vector<uchar> data0uchar0; vector<uchar> data1uchar0; vector<uchar> data2uchar0;

        for (int i = 0; i < data0int0.size(); i++) {
            data0uchar0.push_back(static_cast<uchar>(data0int0.at(i)));
            data1uchar0.push_back(static_cast<uchar>(data1int0.at(i)));
            data2uchar0.push_back(static_cast<uchar>(data2int0.at(i)));
        }

        cv::Mat ch0(data0uchar0); cv::Mat ch1(data1uchar0); cv::Mat ch2(data2uchar0);

        ch0 = ch0.reshape(0, bytesPerColumn);
        ch1 = ch1.reshape(0, bytesPerColumn);
        ch2 = ch2.reshape(0, bytesPerColumn);

        cv::Mat mergesrc[3] = {ch0, ch1, ch2}; cv::Mat mergedst;

        cv::merge(mergesrc, 3, mergedst);

        cv::cvtColor(mergedst, mergedst, cv::COLOR_RGB2HLS);

        int Lfilter1 = 50;

        vector<cv::Mat> channels(3);

        cv::split(mergedst, channels);

        vector<uchar> data0uchar1; vector<uchar> data1uchar1; vector<uchar>data2uchar1;

        data0uchar1.assign(channels[0].data, channels[0].data + channels[0].total());
        data1uchar1.assign(channels[1].data, channels[1].data + channels[1].total());
        data2uchar1.assign(channels[2].data, channels[2].data + channels[2].total());

        vector<int> data0int1; vector<int> data1int1; vector<int> data2int1;

        for (int i = 0; i < data0uchar1.size(); i++) {
            data0int1.push_back(static_cast<int>(data0uchar1.at(i)));
            data1int1.push_back(static_cast<int>(data1uchar1.at(i)));
            data2int1.push_back(static_cast<int>(data2uchar1.at(i)));
        }

        int maxL = 0;
        for (int i = 0; i < data0int1.size(); i++) {
            maxL = maxL > data1int1.at(i) ? maxL : data1int1.at(i);
        }
        for (int i = 0; i < data0int1.size(); i++) {
            if (data1int1.at(i) < (maxL - Lfilter1)) {
                data0int1.at(i) = 0;
                data1int1.at(i) = 0;
                data2int1.at(i) = 0;
            }
        }

        int percentageCount = 0;
        for (int i = 0; i < data0int1.size(); i++) {
            if (data1int1.at(i) != 0) {
                percentageCount++;
            }
        }

        double firstFilterPercentage = double(percentageCount) / double(data0int1.size()) * 100;
        if (firstFilterPercentage > 1) {
            int maxL2 = 0; int Lfilter2 = 25;
            for (int i = 0; i < data1int1.size(); i++) {
                maxL2 = maxL2 > data1int1.at(i) ? maxL2 : data1int1.at(i);
            }
            for (int i = 0; i < data0int1.size(); i++) {
                if (data1int1.at(i) < (maxL2 - Lfilter2)) {
                    data0int1.at(i) = 0;
                    data1int1.at(i) = 0;
                    data2int1.at(i) = 0;
                }
            }
        }

        /// This Transform The 2D Array Into 1D Array.
        nc::NdArray<int> columnTotals;
        nc::NdArray<int> data1NdArray(data1int1); data1NdArray.reshape(bytesPerColumn, bytesPerRow);
        columnTotals = nc::sum(data1NdArray, nc::Axis::ROW) / bytesPerColumn;

        int columnTotalsMax = columnTotals.max()[0];
        vector<int> columnTotalsVector;
        for (int i = 0; i < columnTotals.size(); i++) {
            int temp = columnTotals[i];
            if (temp != 0) {
                if (columnTotalsMax / temp > 10) {temp = 0;}
            }
            columnTotalsVector.push_back(temp);
        }

        /// This Will Store All Possible Clusters Of Points.
        vector<vector<int>> dataPointVector;
        bool clusterStart = false;
        int index1 = 0; int index2 = 0;
        int startIndex; int endIndex;
        for (int i = 0; i < columnTotalsVector.size(); i++) {
            if (columnTotalsVector.at(i) != 0 && clusterStart == false) {
                clusterStart = true;
                startIndex = index1;
                index2 += 1;
            } else if (columnTotalsVector.at(i) != 0 && clusterStart == true) {
                index2 += 1;
                if (index1 == columnTotalsVector.size() - 1) {
                    endIndex = index1;
                    if (endIndex - startIndex > 5) {
                        dataPointVector.push_back({startIndex, endIndex});
                        index2 = 0;
                    }
                }
            } else if (columnTotalsVector.at(i) == 0 && clusterStart == true) {
                clusterStart = false;
                if (index2 > 5) {
                    endIndex = startIndex + index2;
                    dataPointVector.push_back({startIndex, endIndex});
                    index2 = 0;
                }
            }
            index1 += 1;
        }

        /// If Detet=ct More Than Two Clusters, This Is The Finally Filter To Merge Very Close Clusters Into One.
        if (dataPointVector.size() == 2) {
            vector<int> pt1 = dataPointVector.at(0);
            vector<int> pt2 = dataPointVector.at(1);

            int startOfPt1 = pt1.at(0); int endOfPt1 = pt1.at(1);
            int startOfPt2 = pt2.at(0); int endOfPt2 = pt2.at(1);

            if (startOfPt2 - endOfPt1 < 20) {
                dataPointVector.clear();
                dataPointVector.push_back({startOfPt1, endOfPt2});
            }
        }

        /// Now Only Deal With One Cluster And Two Clusters. More Than Two Is Not Considered.
        int pixelDifference = -1;
        if (dataPointVector.size() == 1) {
            vector<int> dataPoint = dataPointVector.at(0);
            int startOfPoint = dataPoint.at(0); int endOfPoint = dataPoint.at(1);
            vector<int> columnTotalsVectorCopy(&columnTotalsVector.at(startOfPoint), &columnTotalsVector.at(endOfPoint));
            int singleMax = 0;
            for (int i = 0; i < columnTotalsVectorCopy.size(); i++) {
                singleMax = singleMax > columnTotalsVectorCopy.at(i) ? singleMax : columnTotalsVectorCopy.at(i);
            }

            vector<int> singleMaxCoordinateVector;
            for (int i = 0; i < columnTotalsVectorCopy.size(); i++) {
                if (columnTotalsVectorCopy.at(i) == singleMax) {
                    singleMaxCoordinateVector.push_back(i);
                }
            }
            int singleMaxCoordinate = singleMaxCoordinateVector.at(0);
            if (singleMaxCoordinateVector.size() > 1) {
                int sumOfCoordinate = 0;
                for (int i = 0; i < singleMaxCoordinateVector.size(); i++) {
                    sumOfCoordinate += singleMaxCoordinateVector.at(i);
                }
                singleMaxCoordinate = sumOfCoordinate / singleMaxCoordinateVector.size();
            }
            int projectCoordinate = startOfPoint + singleMaxCoordinate;
            int mirrorCoordinate = columnTotalsVector.size() - projectCoordinate;
            pixelDifference = abs(mirrorCoordinate - projectCoordinate);
        } else if (dataPointVector.size() == 2) {
            vector<int> dataPoint1 = dataPointVector.at(0); vector<int> dataPoint2 = dataPointVector.at(1);
            int startOfPoint1 = dataPoint1.at(0); int endOfPoint1 = dataPoint1.at(1);
            int startOfPoint2 = dataPoint2.at(0); int endOfPoint2 = dataPoint2.at(1);

            vector<int> columnTotalsVectorCopy1(&columnTotalsVector.at(startOfPoint1), &columnTotalsVector.at(endOfPoint1));
            vector<int> columnTotalsVectorCopy2(&columnTotalsVector.at(startOfPoint2), &columnTotalsVector.at(endOfPoint2));

            int firstMax = 0; int secondMax = 0;
            for (int i = 0; i < columnTotalsVectorCopy1.size(); i++) {
                firstMax = firstMax > columnTotalsVectorCopy1.at(i) ? firstMax : columnTotalsVectorCopy1.at(i);
            }
            for (int i = 0; i < columnTotalsVectorCopy2.size(); i++) {
                secondMax = secondMax > columnTotalsVectorCopy2.at(i) ? secondMax : columnTotalsVectorCopy2.at(i);
            }
            vector<int> firstMaxCoordinateVector; vector<int> secondMaxCoordinateVector;
            for (int i = 0; i < columnTotalsVectorCopy1.size(); i++) {
                if (columnTotalsVectorCopy1.at(i) == firstMax) {
                    firstMaxCoordinateVector.push_back(i);
                }
            }
            for (int i = 0; i < columnTotalsVectorCopy2.size(); i++) {
                if (columnTotalsVectorCopy2.at(i) == secondMax) {
                    secondMaxCoordinateVector.push_back(i);
                }
            }

            /// If Finally Succeed To Get Two Cluster, Calculate The Average Point Of Each Cluster
            int firstMaxCoordinate; int secondMaxCoordinate;
            firstMaxCoordinate = firstMaxCoordinateVector.at(0); secondMaxCoordinate = secondMaxCoordinateVector.at(0);
            if (firstMaxCoordinateVector.size() > 1) {
                int sumOfFirstCoordinate = 0;
                for (int i = 0; i < firstMaxCoordinateVector.size(); i++) {
                    sumOfFirstCoordinate += firstMaxCoordinateVector.at(i);
                }
                firstMaxCoordinate = sumOfFirstCoordinate / firstMaxCoordinateVector.size();
            }
            if (secondMaxCoordinateVector.size() > 1) {
                int sumOfSecondCoordinate = 0;
                for (int i = 0; i < secondMaxCoordinateVector.size(); i++) {
                    sumOfSecondCoordinate += secondMaxCoordinateVector.at(i);
                }
                secondMaxCoordinate = sumOfSecondCoordinate / secondMaxCoordinateVector.size();
            }
            int projectCoordinate1 = startOfPoint1 + firstMaxCoordinate;
            int projectCoordinate2 = startOfPoint2 + secondMaxCoordinate;
            pixelDifference = abs(projectCoordinate2 - projectCoordinate1);
        }

        /// Calculate The Percentage Difference
        int value;
        if (pixelDifference != -1) {
            value = pixelDifference * 100 / columnTotalsVector.size();
        } else {
            value = pixelDifference;
        }
        int *valueRef = (int*)malloc(sizeof(int));
        valueRef[0] = value;

        data0int0.clear(); data1int0.clear(); data2int0.clear();
        data0int1.clear(); data1int1.clear(); data2int1.clear();

        data0uchar0.clear(); data1uchar0.clear(); data2uchar0.clear();
        data0uchar1.clear(); data1uchar1.clear(); data2uchar1.clear();

        ch0.release(); ch1.release(); ch2.release(); channels.clear();

        columnTotalsVector.clear(); dataPointVector.clear();

        free(plane1); free(plane2);
        
        return valueRef;
    }
 }
