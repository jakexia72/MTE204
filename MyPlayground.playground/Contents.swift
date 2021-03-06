import UIKit

// Bracketting Methods
func bisectionMethod(iterations: Int, guessXl: Double, guessXu: Double, f: (Double)->Double)->String{
    var xl:Double = guessXl;
    var xu:Double = guessXu;
    
    var xr:Double {
        return (xl + xu) / 2;
    }
    var oldXr:Double = xr;
    
    var rootsArray:[Double] = []
    
    if (f(xl)*f(xu)) > 0.0 {
        print(" f(xl)= \(f(xl))   f(xu)= \(f(xu))")
        return "Not bracketting root, try again"
    }
    
    for i in 0...iterations{
        print("\(i)   xl= \(xl)   xu= \(xu)   xr= \(xr)  |  f(xl)= \(f(xl))   f(xl)= \(f(xu))   f(xl)= \(f(xr))   (\(f(xl)*f(xr) < 0 ? "-" : "+" )) | Ea= %\(abs(round((xr - oldXr) * 1000000 / xr) / 10000))")
        rootsArray.append(xr);
        oldXr = xr
        if f(xl) * f(xr) < 0 {
            xu = xr
        } else if f(xl) * f(xr) > 0 {
            xl = xr
        } else {
            rootsArray.map(){$0}
            return("root found: \(xr)")
        }
    }
    rootsArray.map(){$0}
    return ("Finsished \(iterations) iteration\(iterations > 1 ? "s" : "")")
}

// Open Methods
func simpleFixedPoint(iterations: Int, guess: Double, g: (Double)->Double){
    var xr = guess;
    var oldXr = xr;
    var rootsArray:[Double] = []
    for i in 0...iterations {
        let ea = abs(round((xr - oldXr)*1000000 / xr) / 10000);
        print("\(i)   xr=\(xr)   ea=%\(ea)");
        oldXr = xr;
        xr = g(oldXr);
        rootsArray.append(xr);
    }
    rootsArray.map(){$0}
}

func newtonRaphson(iterations: Int, guess: Double, f: (Double)->Double, fp: (Double)->Double ){
    var x0 = guess
    var xi = x0 - (f(x0) / fp(x0))
    for i in 0...iterations{
        print("\(i)   x\(i)=\(x0)   x\(i+1)=\(xi)   Ea= %\(abs(round((xi - x0) * 1000000 / xi) / 10000))")
        x0 = xi
        xi = x0 - (f(x0) / fp(x0))
    }
}

func secant(iterations: Int, guessX0: Double, guessX1: Double, f: (Double)->Double){
    var x0 = guessX0
    var x1 = guessX1
    for i in 0...iterations{
        print("\(i)   x\(i)=\(x0)   x\(i+1)=\(x1)   Ea= %\(abs(round((x1 - x0) * 1000000 / x1) / 10000))")
        
        let m = (x1 - x0) / (f(x1) - f(x0))
        let temp  = x1
        x1 = x0 - (f(x0) * m)
        x0 = temp
    }
}


// BEGIN PRACTICE QUESTIONS =================
func parachutist_c(_ c: Double)->Double{
    let g = 9.81
    let m = 82.0 //kg
    let v = 36.0 // m/s
    let t = 4.0 // seconds
    
    return ((g*m)/c) * (1-pow(M_E, -1 * (c * t / m))) - v
}


func myFunction(_ x: Double)->Double{
    return -0.5*pow(x,2) + 2.5*x + 4.5;
}

func gFunc(_ x:Double)->Double{
    return pow(M_E, ( -1 * x ))
}

func five(_ x: Double)->Double{
    return pow(x, 2) - sin(x)
}

func sixPoint2(_ x: Double)->Double{
    return ((-2 * pow(x,3)) + (11.7 * pow(x,2)) + 5) / 17.7
}


func sixPoint2_2(_ x: Double)->Double{
    return (2 * pow(x,3)) - (11.7 * pow(x,2)) + 17.7 * x - 5
}

func sixPoint4(_ x: Double)->Double{
    return -1 + 5.5*x - 4*x*x + 0.5*x*x*x
}

func sixPoint4p(_ x: Double)->Double{
    return  5.5 - 8*x + 1.5*x*x
}

//print(bisectionMethod(iterations: 100, guessXl: 3, guessXu: 5, f: parachutist_c, trueVal: 0));
//secant(iterations: 100, guessX0: 0, guessX1: 1, f: { (x) -> Double in
//    return (-1 * x) + pow(M_E, -1*x)
//})
//
//simpleFixedPoint(iterations: 100, guess: 3, g: sixPoint2)
//newtonRaphson(iterations: 3, guess: 3, f: sixPoint2_2) { (x: Double) -> Double in
//    return (6 * pow(x,2)) - (11.7 * 2 * pow(x,1)) + 17.7
//}
//secant(iterations: 3, guessX0: 3, guessX1: 4, f: sixPoint2_2)

//newtonRaphson(iterations: 3, guess: 1, f: { (x) -> Double in
//    return x*x - pow(M_E, -1*x)
//}, fp: { (x) -> Double in
//    return 2*x + pow(M_E, -1*x)
//})

//newtonRaphson(iterations: 100, guess: 6, f: sixPoint4, fp: sixPoint4p)
// guess = 0 ->   x3=0.21433211413106049   Ea= %0.0004
// guess = 2 ->  x3=1.479774541816106  Ea= %0.0003
// guess = 6 ->  x3=6.305897680394437  Ea= %0.0

//
//func six19(_ x: Double)->Double{
//    return .pi*3*x*x - (.pi/3)*x*x*x - 30
//}
//
//func six19p(_ x: Double)->Double{
//    return  .pi*6*x - .pi*x*x
//}

//newtonRaphson(iterations: 5, guess: 3, f: six19, fp: six19p)
//0   x0=3.0   x1=2.0610329539459693   Ea= %45.5581
//1   x1=2.0610329539459693   x2=2.0270420656974903   Ea= %1.6769
//2   x2=2.0270420656974903   x3=2.026905730555795   Ea= %0.0067
//3   x3=2.026905730555795   x4=2.0269057283100134   Ea= %0.0
//

//func six11(_ x: Double)->Double{
//    return e(-0.5 * x) * (4 - x) - 2
//}
//
//func six11p(_ x: Double)->Double{
//    return  -0.5 * e(-0.5 * x) * (4 - x) - e(-0.5 * x)
//}

func e(_ x: Double)->Double{
    return pow(M_E, x)
}
//
//newtonRaphson(iterations: 50, guess: 6, f: six11, fp: six11p)
//// guess 2 ->     5   x5=0.8857088019940231   x6=0.8857088020047771   Ea= %0.0
//// guess 6 -> Does not work, fp = 0
//// guess 8 -> Does not work, fp is near zero and sends x away forever.

//func r(_ R: Double)->Double{
//    return e(-0.005*R) * cos(sqrt(2000 - 0.01 * R * R) * 0.05) - 0.01
//}

//print(bisectionMethod(iterations: 25, guessXl: 0, guessXu: 400, f: r, trueVal: 0))

//func g(_ f: Double)->Double{
//    let insideLog = (0.0015 * pow(10,-3) / (3.7 * 0.005)) + (2.51 / (13743 * sqrt(f)))
//    return (1 / sqrt(f)) + (2 * log10(insideLog))
//}
//print(bisectionMethod(iterations: 25, guessXl: 0.008, guessXu: 0.08, f: g))
//
//func g2(_ f: Double)->Double{
//    let insideLog = (0.0015 * pow(10,-3) / (3.7 * 0.005)) + (2.51 / (13743 * sqrt(f)))
//    return 0.25 / pow(log10(insideLog),2)
//}
//simpleFixedPoint(iterations: 100, guess: 0.008, g: g2)


//func eight4(_ t: Double)->Double{
//    return 1 - e(-0.04 * t) + (4/10) * e(-0.04 * t) - 0.93
//}
//print(bisectionMethod(iterations: 25, guessXl: 50, guessXu: 55, f: eight4))


//func eight39(_ t: Double)->Double{
//    let u = 2200.0
//    let m0 = 160000.0
//    let q = 2680.0
//    let g = 9.81
//    return u * log(m0 / (m0 - q * t)) - g * t - 1000
//}
//print(bisectionMethod(iterations: 25, guessXl: 10, guessXu: 50, f: eight39))
//print(eight39(26.09375))


func quiz1_5(_ H: Double)->Double{
    let g = 9.81
    let L = 4.0
    let v = 5.0
    let t = 2.5

    return sqrt(2*g*H)*tanh((sqrt(2*g*H)*t)/(2*L)) - v
}

bisectionMethod(iterations: 15, guessXl: 0, guessXu: 2, f: quiz1_5)


let a = 1.0
let b = 16.05
let c = 88.75
let d = 192.0375
let f = 116.35


func quiz1_7(_ x: Double)->Double{
    return pow(x, 5) - 16.05 * pow(x,4) + 88.75 * pow(x,3) - 192.0375 * pow(x,2) + 116.35 * x + 31.6875
}

func quiz1_7g(_ x: Double)->Double{
    return 5 * pow(x, 4) - 16.05 * 4 * pow(x,3) + 88.75 * 3 * pow(x,2) - 192.0375 * 2 * pow(x,1) + 116.35
}

newtonRaphson(iterations: 9, guess: 0.5825, f: quiz1_7, fp: quiz1_7g)



