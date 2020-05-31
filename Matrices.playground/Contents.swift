
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
    init(columnMatrix column: [Double]){
        self.init(numberOfRows: column.count, numberOfCols: 1);
        for i in 0..<column.count{
            self.data[i][0] = column[i];
        }
    }
    init(rowMatrix row: [Double]){
        self.data = [row];
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
            //            print("test: \(col[i])")
            indexOfLargest = abs(col[i]) > abs(col[indexOfLargest]) ? i : indexOfLargest;
        }
        return indexOfLargest
    }
    func indexOfLargestMagnitudeElementInRow(_ rowNum:Int, stopBefore: Int) -> Int{
        let row = getRow(rowNum)
        var indexOfLargest = 0;
        for i in 0..<stopBefore {
            indexOfLargest = abs(row[i]) > abs(row[indexOfLargest]) ? i : indexOfLargest;
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
    mutating func reorderDiagonallySimple(){
        for i in 0..<rowsCount{
            swapRows(i, indexOfLargestMagnitudeElementInCol(i, startAtRow: i))
        }
    }
    mutating func reorderDiagonally(stopBefore: Int){
        for i in 0..<rowsCount{
            swapRows(i, indexOfLargestMagnitudeElementInRow(i, stopBefore: stopBefore))
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
    
    func det() -> Double{
        validateSquare()
        if(rowsCount == 2){
            return (data[0][0] * data[1][1]) - (data[0][1] * data[1][0])
        } else {
            //
        }
        return 0
        
    }
    mutating func augment(with b: Matrix){
        b.validateDimensions(rows: rowsCount)
        for i in 0..<rowsCount{
            data[i] += b.data[i]
        }
    }
    mutating func remove(col colToRemove: Int){
        var newMatrix = Matrix(numberOfRows: rowsCount, numberOfCols: colsCount-1);
        
        var colIndex = 0;
        for i in 0..<rowsCount {
            for j in 0..<colsCount {
                if (j != colToRemove){
                    newMatrix.data[i][colIndex] = data[i][j]
                    colIndex += 1;
                    print(colIndex)
                }
            }
            colIndex = 0;
        }
        self.data = newMatrix.data
    }
}

// for solving using various methods
extension Matrix {
    func validateSquare(){
        if !isSquare {
            preconditionFailure("Must be square matrix")
        }
    }
    func validateDimensions(rows: Int? = nil, cols: Int? = nil){
        if let rowNum = rows {
            if rowNum != rowsCount {
                preconditionFailure("Dimension requirements not met")
            }
        }
        
        if let colNum = cols{
            if colNum != colsCount {
                preconditionFailure("Dimension requirements not met")
            }
        }
    }
    func diagonalHasZeros()->Bool{
        for i in 0..<rowsCount{
            if (data[i][i] == 0){
                return true
            }
        }
        return false;
    }
    mutating func gaussSeidel(constantVector: [Double],
                              initialGuesses: [Double],
                              pivot: Bool = false,
                              iterations: Int = 10,
                              relaxationFactor L: Double = 1
    ){
        validateSquare()
        
        let b = Matrix(columnMatrix: constantVector)
        print(b)
        print(self)
        b.validateDimensions(rows: rowsCount, cols: 1) //must have only 1 column
        
        let solutionsMatrix = Matrix(columnMatrix: initialGuesses)
        solutionsMatrix.validateDimensions(rows: rowsCount, cols: 1)
        
        var solutions = initialGuesses
        
        augment(with: b);
        if(pivot){
            reorderDiagonally(stopBefore: colsCount - 1);
        }
        
        //split it back up after augment
        let constants = self.getCol(self.colsCount-1);
        remove(col: self.colsCount-1)
        
        //iteratively generate new solutions
        for it in 1...iterations{
            print("ITERATION \(it) ---------------\n")
            for i in 0..<rowsCount{
                let oldSolutions = solutions;
                solutions[i] = constants[i]
                print ("solution \(i + 1) = (\(constants[i])", terminator:"")
                for j in 0..<colsCount{
                    if (j != i){
                        //not on diagonal
                        print(" - \(val(i,j)) * \(solutions[j])", terminator:"")
                        solutions[i] -= val(i, j) * solutions[j];
                    }
                }
                print (") / \(val(i, i))")
                solutions[i] = solutions[i] / val(i,i);
                if (L != 1){
                    print ("new solution = (1 - \(L)) * \(oldSolutions[i]) + (L) * \(solutions[i])")
                    solutions[i] = ((1-L) * oldSolutions[i]) + ((L) * solutions[i])
                }
                print("solution \(i+1): \(solutions[i])         %Ea: \(getPercentError(old: oldSolutions[i], new: solutions[i], digits: 5)) \n");
            }
        }
        
        print(self);
        
    }
}

func getPercentError(old: Double, new:Double, digits:Int) -> Double{
    
    let percent:Double = (new - old) * 100 / new;
    let rounded = round(Double(truncating: pow(10,digits) as NSNumber) * percent);
    
    return abs( rounded / Double(truncating: pow(10,digits) as NSNumber))
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


//
//print("test")
//print((2 * myMatrix2))
////myMatrix2.swapRows(0, 3)
//print(myMatrix.isSquare);
//print(myMatrix.largestVal())
//
//myMatrix3.normalize()
//print(myMatrix3)
//
//myMatrix4.reorderDiagonally()
//print(myMatrix4)
//
//print(myMatrix2)
//print(myMatrix2.transpose())
//
//print(myMatrix4.diagonalHasZeros())
//
//var columnMatrix = Matrix(columnMatrix: [1,2,3]);
//print(columnMatrix)
//
//var rowMatrix = Matrix(rowMatrix: [1,2,3]);
//print(rowMatrix)
//
//print(myMatrix.indexOfLargestMagnitudeElementInCol(3, startAtRow: 1));
//
//

var myMatrixN = Matrix([
    [1,0,0,0],
    [0,0,1,0],
    [0,0,0,1],
    [0,1,0,0],
])

//var test = Matrix([
//    [  1,  5,  3],
//    [  3,  7, 13],
//    [ 12,  3, -5],
//])
//test.gaussSeidel(constantVector: [1,28,76], initialGuesses: [1,0,1], pivot: true, iterations: 6);
//print(test);


var test = Matrix([
    [ 27, 6,  -1],
    [ 6,  15, -2],
    [  1, 1,  54],
])
test.gaussSeidel(constantVector: [85,72,110], initialGuesses: [0,0,0], pivot: false, iterations: 9, relaxationFactor: 1.242);
print(test);

//myMatrixN.remove(col: 0);
//
//print(myMatrixN);
