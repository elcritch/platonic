
import std/typetraits

type

  Matrix* = concept mat, var mvar, type M
    M.dType is typedesc
    mat.cols() is int
    mat.size() is int
    
    mat[int, int] is M.dType
    mvar[int, int] = M.dType
  
    mvar.init(int)

    # type TransposedType = stripGenericParams(M)[T]
  
  SquareMatrix* = Matrix
  
  Transform3D* = Matrix

when isMainModule:
  # Example Procs
  # =============

  proc transposed*(m: Matrix): Matrix =
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
    MatrixImpl*[T] = object
      data: seq[T]
      m, n*: int

  proc initMatrixImpl*[T](m, n: int): MatrixImpl[T] = 
    result.data = newSeq[T](m*n)
    result.m = m
    result.n = n

  proc init*[T](mat: var MatrixImpl[T], m, n: int) =
    mat.data = newSeq[T](m*n)
    mat.m = m
    mat.n = n

  # Adapt the Matrix type to the concept's requirements
  proc rows*(M: MatrixImpl): int = M.m
  proc cols*(M: MatrixImpl): int = M.n
  proc size*(M: MatrixImpl): int = M.m*M.n
  template dType*(M: typedesc[MatrixImpl]): typedesc = M.T

  proc `[]`*(M: MatrixImpl; m, n: int): M.T =
    M.data[m * M.rows + n]

  proc `[]=`*(M: var MatrixImpl; m, n: int; v: M.T) =
    M.data[m * M.rows + n] = v

  var
    m: MatrixImpl[int] = initMatrixImpl[int](3, 3)
    projectionMatrix: MatrixImpl[float] = initMatrixImpl[float](3, 3)

  let m1: MatrixImpl[int] = m.transposed()
  echo m.transposed
  echo m.transposed.determinant
  setPerspectiveProjection projectionMatrix
