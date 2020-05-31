
import UIKit

struct Matrix{
    var data:[[Double]];
    init(_ data: [[Double]]){
        self.data = data;
    }
    init(numberOfRows: Int, numberOfCols: Int){
        let rows = [Double](repeating: 0, count: numberOfCols);
        self.data = [[Double]](repeating: rows, count: numberOfRows);
    }
    var colsCount:Int {return data[0].count}
    var rowsCount:Int {return data.count}
    var isSquare:Bool {return colsCount == rowsCount}
    
    func val(_ i: Int, _ j: Int)->Double{
        return data[i][j];
    }
    mutating func val(_ i: Int, _ j: Int, val: Double){
        data[i][j] = val
    }
}

// Look Up Values
extension Matrix{
    func getCol(_ colNum: Int) -> [Double]{
        var col = [Double]();
        for i in 0..<rowsCount {
            col.append(data[i][colNum])
        }
        return col;
    }
    func getRow(_ rowNum: Int) -> [Double]{
        return data[rowNum]
    }
    func indexOfLargestMagnitudeElementInCol(_ colNum:Int, startAtRow: Int) -> Int{
        let col = getCol(colNum);
        var indexOfLargest = startAtRow;
        for i in startAtRow..<col.count {
            print("test: \(col[i])")
            indexOfLargest = col[i] > col[indexOfLargest] ? i : indexOfLargest;
        }
        return indexOfLargest
    }
    func largestVal()->Double{
        return data.map({ (a:[Double]) -> Double in return a.max()! }).max()!
    }
}

// Modify a matrix
extension Matrix{
    //pivot
    mutating func reorderDiagonally(){
        for i in 0..<rowsCount{
            swapRows(i, indexOfLargestMagnitudeElementInCol(i, startAtRow: i))
        }
    }
    mutating func swapRows(_ row1:Int, _ row2:Int){
        let temp = data[row2];
        data[row2] = data[row1];
        data[row1] = temp;
    }
    //normalize -> largest coefficient is 1
    mutating func normalize(){
        self = (1/self.largestVal()) * self
    }
}

extension Matrix: CustomStringConvertible{
    var description: String {
        return "\(data)"
    }
}

// Matrix Operations
extension Matrix{
//    enum operationErrors: Error {
//        case wrongDimensions(String)
//    }
    static func + (left: Matrix, right: Matrix)  -> Matrix {
        if left.colsCount != right.colsCount || left.rowsCount != right.rowsCount {
            preconditionFailure("Matrix dimensions do not match")
        }
        var newMatrix = Matrix(numberOfRows: left.rowsCount, numberOfCols: left.colsCount);
        for i in 0..<left.rowsCount{
            for j in 0..<left.colsCount {
                newMatrix.val(i, j, val: left.val(i, j) + right.val(i, j))
            }
        }
        return newMatrix
    }
    static func - (left: Matrix, right: Matrix)  -> Matrix {
        if left.colsCount != right.colsCount || left.rowsCount != right.rowsCount {
            preconditionFailure("Matrix dimensions do not match")
        }
        var newMatrix = Matrix(numberOfRows: left.rowsCount, numberOfCols: left.colsCount);
        for i in 0..<left.rowsCount{
            for j in 0..<left.colsCount {
                newMatrix.val(i, j, val: left.val(i, j) - right.val(i, j))
            }
        }
        return newMatrix
    }
    static func * (left: Matrix, right: Matrix) -> Matrix{
        if (left.colsCount != right.rowsCount){
            preconditionFailure("Incompatible matrix dimensions \(left.rowsCount)x\(left.colsCount) and \(right.rowsCount)x\(right.colsCount)")
        }
            var newMatrix = Matrix(numberOfRows: left.rowsCount, numberOfCols: right.colsCount);
            for i in 0..<newMatrix.rowsCount{
                for j in 0..<newMatrix.colsCount{
                    var sum:Double = 0.0;
                    for k in 0..<left.colsCount{
                        sum += left.val(i,k) * right.val(k,j)
                    }
                    newMatrix.val(i, j, val: sum)
                }
            }
        return newMatrix;
    }
    static func * (left: Double, right: Matrix) -> Matrix{
            var newMatrix = Matrix(numberOfRows: right.rowsCount, numberOfCols: right.colsCount);
            for i in 0..<newMatrix.rowsCount{
                for j in 0..<newMatrix.colsCount{
                    newMatrix.val(i, j, val: right.data[i][j] * left);
                }
            }
        return newMatrix;
    }
     func transpose() -> Matrix{
        var newMatrix = Matrix(numberOfRows: colsCount, numberOfCols: rowsCount)
        for i in 0..<newMatrix.rowsCount{
            for j in 0..<newMatrix.colsCount{
                newMatrix.data[i][j] = data[j][i]
            }
        }
        return newMatrix
    }
}


var myMatrix = Matrix([
    [0,1,2,15],
    [4,5,6,7],
    [8,9,10,11],
    [8,9,10,11],
])

var myMatrix2 = Matrix([
    [0],
    [4],
    [4],
    [4],
]);

var myMatrix3 = Matrix([
    [2],
    [10000],
]);

var myMatrix4 = Matrix([
    [1,0,0,0],
    [0,0,1,0],
    [0,0,0,1],
    [0,1,0,0],
])



print("test")
print((2 * myMatrix2))
//myMatrix2.swapRows(0, 3)
print(myMatrix.isSquare);
print(myMatrix.largestVal())

myMatrix3.normalize()
print(myMatrix3)

myMatrix4.reorderDiagonally()
print(myMatrix4)

print(myMatrix2)
print(myMatrix2.transpose())

print(myMatrix.indexOfLargestMagnitudeElementInCol(3, startAtRow: 1));
