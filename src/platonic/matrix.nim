
import std/typetraits

type

  Matrix* = concept mat, var mvar, type M
    M.dType is typedesc
    mat.cols() is int
    mat.size() is int
    
    mat[int, int] is M.dType
    mvar[int, int] = M.dType
  
    mvar.init(int, int)

    # type TransposedType = stripGenericParams(M)[T]
  
  SquareMatrix* = Matrix
  
  Transform3D* = Matrix

when isMainModule:
  # Example Procs
  # =============

  proc transposed*[M: Matrix](m: M): M =
    result.init(m.rows, m.cols)
    for r in 0 ..< m.rows:
      for c in 0 ..< m.cols:
        result[r, c] = m[c, r]

  proc determinant*(m: Matrix): int =
    result = 0

  proc setPerspectiveProjection*(m: Transform3D) =
    echo "set"


when isMainModule:
  type
    MatrixImplF64* = object
      data: seq[float64]
      m, n*: int

  template dType*(M: typedesc[MatrixImplF64]): typedesc = float64

  proc initMatrixImplF64*(m, n: int): MatrixImplF64 = 
    result.data = newSeq[MatrixImplF64.dType](m*n)
    result.m = m
    result.n = n

  proc init*(mat: var MatrixImplF64, m, n: int) =
    mat.data = newSeq[float64](m*n)
    mat.m = m
    mat.n = n

  # Adapt the Matrix type to the concept's requirements
  proc rows*(mat: MatrixImplF64): int = mat.m
  proc cols*(mat: MatrixImplF64): int = mat.n
  proc size*(mat: MatrixImplF64): int = mat.m*mat.n

  proc `[]`*(mat: MatrixImplF64; m, n: int): float64 =
    mat.data[m * mat.rows() + n]

  proc `[]=`*(M: var MatrixImplF64; m, n: int; v: float64) =
    M.data[m * M.rows + n] = v

  var
    m: MatrixImplF64 = initMatrixImplF64(3, 3)
    projectionMatrix: MatrixImplF64 = initMatrixImplF64(3, 3)

  let m1: MatrixImplF64 = m.transposed()
  echo "m: ", m
  echo "m1: ", m1
  echo "transposed: ", m.transposed
  echo "transposed:det: ", m.transposed.determinant
  setPerspectiveProjection projectionMatrix
