//
//  NMS.swift
//  CardScan
//
//  Created by Zain on 8/6/19.
//

import Foundation
import os.log
struct NMS{
    static func hardNMS(subsetBoxes: [[Float]], probs: [Float], iouThreshold: Float, topK: Int, candidateSize: Int) -> [Int] {
        /** In this project we implement HARD NMS and NOT Soft NMS
         * I highly recommend checkout SOFT NMS Implementation of Facebook Detectron Framework
         *
         *  Args:
         *  box_scores (N, 5): boxes in corner-form and probabilities.
         *  iou_threshold: intersection over union threshold.
         *  top_k: keep top_k results. If k <= 0, keep all the results.
         *  candidate_size: only consider the candidates with the highest scores.
         *
         *  Returns:
         *  picked: a list of indexes of the kept boxes
         */
        
        
        let sorted = probs.enumerated().sorted(by: {$0.element > $1.element})
        var indices = sorted.map{$0.offset}
        var current: Int = 0
        var currentBox = [Float]()
        var pickedIndices = [Int]()
        
        if(indices.count > 200){
            // TODO Fix This
            indices = Array(indices[0..<200])
            os_log("Exceptional Situation more than 200 candiates found", type: .error)
        }
        
        while(indices.count > 0){
            current = indices.remove(at: 0)
            pickedIndices.append(current)
            
            if topK > 0 && topK == pickedIndices.count || indices.count == 1{
                break;
            }
            currentBox = subsetBoxes[current]
            
            let currentBoxRect = CGRect(x: Double(currentBox[0]), y: Double(currentBox[1]), width: Double(currentBox[2] - currentBox[0]), height: Double(currentBox[3] - currentBox[1]))
            
            indices.removeAll(where: { currentBoxRect.iou(nextBox: CGRect(x: Double(subsetBoxes[$0][0]), y: Double(subsetBoxes[$0][1]), width: Double(subsetBoxes[$0][2] - subsetBoxes[$0][0]), height: Double(subsetBoxes[$0][3] - subsetBoxes[$0][1]))
                ) >= iouThreshold})

        }
        
        return pickedIndices

    }
    
}
