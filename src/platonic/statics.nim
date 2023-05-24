import std/typetraits

type
  SomeVector*[N: static int; T] = concept vector, var vvar, type V
    V.typeValue is T
    V.cols == N
    V.size == N
    V.dimA == N
    
    vector[int, int] is T
    vvar[int, int] = T

    vvar.init(int)
    type TransposedType = stripGenericParams(V)[N, T]
  
  SomeMatrix*[R, C: static int; T] = concept matrix, var mvar, type M
    M.typeValue is T
    M.rows == R
    M.cols == C
    M.size == R * C
    M.dimA == R
    M.dimB == C
    
    matrix[int, int] is T
    mvar[int, int] = T
    
    mvar.init(int, int)
    type TransposedType = stripGenericParams(M)[C, R, T]
  
  SomeSquareMatrix*[N: static int, T] = SomeMatrix[N, N, T]
  
  SomeTransform3D* = SomeMatrix[4, 4, float]

  SomeTensor3*[A, B, C: static int; T] = concept tensor, var mvar, type T
    T.typeValue is T
    T.rows == A
    T.cols == B
    T.size == A*B*C
    T.dimA == A
    T.dimB == B
    T.dimC == C
    
    tensor[int, int, int] is T
    mvar[int, int, int] = T
    
    mvar.init(int, int, int)
    type TransposedType = stripGenericParams(T)[A, B, C, T]
  
  SomeTensor4*[A, B, C, D: static int; T] = concept tensor, var mvar, type T
    T.typeValue is T
    T.rows == A
    T.cols == B
    T.size == A*B*C*D
    T.dimA == A
    T.dimB == B
    T.dimC == C
    T.dimD == D
    
    tensor[int, int, int, int] is T
    mvar[int, int, int, int] = T
    
    mvar.init(int, int, int, int)
    type TransposedType = stripGenericParams(T)[A, B, C, D, T]
  

when isMainModule:
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

  proc init*(M: var MatrixImpl, m, n: int) =
    discard

  proc `[]`*(M: MatrixImpl; m, n: int): M.T =
    M.data[m * M.N + n]

  proc `[]=`*(M: var MatrixImpl; m, n: int; v: M.T) =
    M.data[m * M.N + n] = v

  # Adapt the Matrix type to the concept's requirements
  template rows*(M: typedesc[MatrixImpl]): int = M.M
  template cols*(M: typedesc[MatrixImpl]): int = M.N
  template size*(M: typedesc[MatrixImpl]): int = M.M * M.N
  template dimA*(M: typedesc[MatrixImpl]): int = M.M
  template dimB*(M: typedesc[MatrixImpl]): int = M.N
  template typeValue*(M: typedesc[MatrixImpl]): typedesc = M.T

  var
    m: MatrixImpl[3, 3, int]
    projectionMatrix: MatrixImpl[4, 4, float]

  echo m.transposed
  echo m.transposed.determinant
  setPerspectiveProjection projectionMatrix
