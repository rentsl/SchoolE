//: Playground - noun: a place where people can play

import UIKit

var str1 = "2016-11-24T05:47:47.123Z"

let str2 = "2016-11-24T05:47:47.131Z"

str1 < str2

struct HI {
    var h: String
    var l: String
}

var hi1: [HI] = [HI(h:"hello",l:"world"),HI(h:"hello2",l:"world2")]
print(hi1)

var hi2: [HI] = [HI(h:"hello3",l:"world3"),HI(h:"hello4",l:"world4")]

var newHI: [HI] = hi1 + hi2
newHI.sort {$0.h>$1.h}
print(newHI)

for i in 0...3{
    print(i)
}