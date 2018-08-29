//
//  Travia.swift
//  Orange Arrow
//
//  Created by 刘祥 on 7/2/18.
//  Copyright © 2018 Orange Arrow. All rights reserved.
//

import Foundation

class Trivia {
    let title : String = "Trivia"
    let rule : String = "Welcome to OA Trivia! Here is how it plays,Lorem ipsum dolor sit amet, consectetur adipiscing elit. Curabitur felis est, porttitor in dignissim nec, ultricies eget orci. Vestibulum eget sapien rutrum, malesuada erat a, mattis justo. Sed ac eros ipsum. Integer orci mauris, fringilla at enim in, varius sagittis enim. Aenean quis rhoncus purus. Morbi nibh mi, luctus sit amet maximus nec, luctus non magna. Duis tincidunt nibh in ante tincidunt, id ultricies magna pulvinar. Vestibulum euismod nibh a arcu condimentum lacinia. Vestibulum pellentesque fermentum ex id blandit."
//    let questions : [String] = ["When walking with a lady: ","When eating dinner at a restaurant you should: ","When at a theater (play, movie, etc…) you should: "]
    let questions : [[String]] = [["When walking with a lady: ","When eating dinner at a restaurant you should: ","When at a theater (play, movie, etc…) you should: "],["","",""],["","",""],["","",""],["","",""],["","",""],["","",""],["","",""]]

    let choices : [[[String]]] = [[["In front of her","On the outside of her","Behind her"," It doesn’t matter"],["Chew loudly and with your mouth open","Eat with your elbows on the table","Comb your hair at the table","Wipe your mouth with the corners of your napkin"],["Answer your phone during the performance","Keep your phone on ring","Talk to your friends during the show","Turn your phone on silent and be respectful of others in the theater during the performance"]],[["","","",""],["","","",""],["","","",""]]]
    
    let answers : [String:[[Int]]] = ["level1":[[0,1,0,0],[0,0,0,1],[0,0,0,1]],
                                      "level2":[[0,1,0,0],[0,0,0,1],[0,0,0,1]],
                                      "level3":[[0,1,0,0],[0,0,0,1],[0,0,0,1]],
                                      "level4":[[0,1,0,0],[0,0,0,1],[0,0,0,1]],
                                      "level5":[[0,1,0,0],[0,0,0,1],[0,0,0,1]],
                                      "level6":[[0,1,0,0],[0,0,0,1],[0,0,0,1]],
                                      "level7":[[0,1,0,0],[0,0,0,1],[0,0,0,1]],
                                      "level8":[[0,1,0,0],[0,0,0,1],[0,0,0,1]]]
    
    
}
