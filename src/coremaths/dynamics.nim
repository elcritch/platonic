
import std/typetraits

type
  SomeVector*[T] = concept vec, var vvar, type V
    V.typeValue is T
    V.cols() is int
    V.size() is int
    
    vec[int, int] is T
    vvar[int, int] = T
  
    type TransposedType = stripGenericParams(V)[T]

  SomeMatrix*[T] = concept mat, var mvar, type M
    M.typeValue is T

    # rows(mat) is int
    # cols(mat) is int
    # size(mat) is int
    
    mat[int, int] is T
    mvar[int, int] = T

    type TransposedType = stripGenericParams(M)[T]
    
  
  SomeSquareMatrix*[T] = SomeMatrix[T]
  
  SomeTransform3D* = SomeMatrix[float]

when isMainModule:
  # Example Procs
  # =============

  proc transposed*(m: SomeMatrix): m.TransposedType =
    for r in 0 ..< m.rows:
      for c in 0 ..< m.cols:
        result[r, c] = m[c, r]

  proc determinant*(m: SomeMatrix): int =
    result = 0

  proc setPerspectiveProjection*(m: SomeTransform3D) =
    echo "set"

  type
    MatrixImpl*[T] = object
      data: seq[T]
      m, n*: int

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
    m: MatrixImpl[int]
    projectionMatrix: MatrixImpl[float]

  let m1: MatrixImpl = m.transposed()
  # echo m.transposed.determinant
  setPerspectiveProjection projectionMatrix
