
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

template zero*[N: SomeNumber](m: typedesc[N]): N = 0
template default*[N: SomeNumber](m: typedesc[N]): N = 0

when isMainModule:
  # Example Procs
  # =============

  proc transposed*[M: Matrix](m: M): M =
    result.init(m.rows, m.cols)
    for r in 0 ..< m.rows:
      for c in 0 ..< m.cols:
        result[r, c] = m[c, r]

  proc sum*[M: Matrix](m: M): M.dType =
    result = zero(M.dType)
    for r in 0 ..< m.rows:
      for c in 0 ..< m.cols:
        result += m[c, r]

  proc eye*[M: Matrix](typ: typedesc[M], m, n: int, value: M.dType = 1): M =
    result.init(m, n)
    for r in 0 ..< result.rows:
      for c in 0 ..< result.cols:
        if r == c:
          result[r, c] = value

  proc determinant*[M: Matrix](m: M): M.dType =
    result = -1

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

  m = MatrixImplF64.eye(3,3)
  echo "m: ", m
  echo "m.sum: ", m.sum()

  var m1 = initMatrixImplF64(3, 3)
  m1[0, 2] = 1.0
  m1[1, 1] = 1.0
  m1[2, 0] = 1.0

  echo "m1: ", m1
  echo "transposed: ", m1.transposed
  echo "transposed:det: ", m1.transposed.determinant
  setPerspectiveProjection projectionMatrix
