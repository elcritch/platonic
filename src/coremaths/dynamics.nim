
import std/typetraits

type
  DynVector*[T] = concept vec, var vvar, type V
    V.typeValue is T
    V.cols() is int
    V.size() is int
    
    vec[int, int] is T
    vvar[int, int] = T
  
    vvar.init()
    type TransposedType = stripGenericParams(V)[T]

  DynMatrix*[T] = concept mat, var mvar, type M
    M.typeValue is T

    rows(mat) is int
    cols(mat) is int
    size(mat) is int
    
    mat[int, int] is T
    mvar[int, int] = T

    type TransposedType = stripGenericParams(M)[T]
    
  
  DynSquareMatrix*[T] = DynMatrix[T]
  
  DynTransform3D* = DynMatrix[float]

when isMainModule:
  # Example Procs
  # =============

  proc transposed*(m: DynMatrix): m.TransposedType =
    result.init(m.rows, m.cols)
    for r in 0 ..< m.rows:
      for c in 0 ..< m.cols:
        result[r, c] = m[c, r]

  proc determinant*(m: DynMatrix): int =
    result = 0

  proc setPerspectiveProjection*(m: DynTransform3D) =
    echo "set"

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
  template typeValue*(M: typedesc[MatrixImpl]): typedesc = M.T

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
