

import std/typetraits

type
  SomeVector*[N: static int; T] = concept vec, var vvar, type V
    V.typeValue is T
    V.cols == N
    V.size == N
    
    vec[int, int] is T
    vvar[int, int] = T
  
  SomeMatrix*[R, C: static int; T] = concept mat, var mvar, type M
    M.typeValue is T
    M.rows == R
    M.cols == C
    
    mat[int, int] is T
    mvar[int, int] = T
    
    type TransposedType = stripGenericParams(M)[C, R, T]
  
  SomeSquareMatrix*[N: static int, T] = SomeMatrix[N, N, T]
  
  SomeTransform3D* = SomeMatrix[4, 4, float]

# Example Procs
# =============

proc transposed*(m: SomeMatrix): m.TransposedType =
  for r in 0 ..< m.R:
    for c in 0 ..< m.C:
      result[r, c] = m[c, r]

proc determinant*(m: SomeSquareMatrix): int =
  result = 0

proc setPerspectiveProjection*(m: SomeTransform3D) =
  echo "set"

type
  MatrixImpl*[M, N: static int; T] = object
    data: array[M*N, T]

proc `[]`*(M: MatrixImpl; m, n: int): M.T =
  M.data[m * M.N + n]

proc `[]=`*(M: var MatrixImpl; m, n: int; v: M.T) =
  M.data[m * M.N + n] = v

# Adapt the Matrix type to the concept's requirements
template rows*(M: typedesc[MatrixImpl]): int = M.M
template cols*(M: typedesc[MatrixImpl]): int = M.N
template typeValue*(M: typedesc[MatrixImpl]): typedesc = M.T


var
  m: MatrixImpl[3, 3, int]
  projectionMatrix: MatrixImpl[4, 4, float]

echo m.transposed.determinant
setPerspectiveProjection projectionMatrix
