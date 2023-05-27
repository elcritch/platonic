
import std/typetraits

type

  Vector* = concept vec, var vvar, type M
    M.dType() is typedesc

    vec.rows() is int
    vec.size() is int
    
    vec[int] is M.dType
    vvar[int] = M.dType
  
    vvar.init(int)

    # type TransposedType = stripGenericParams(M)[T]
  
  SquareVector* = Vector
  
  Transform3D* = Vector

template zero*[N: SomeNumber](m: typedesc[N]): N = 0
template default*[N: SomeNumber](m: typedesc[N]): N = 0

when isMainModule:
  # Example Procs
  # =============

  proc sum*[M: Vector](m: M): M.dType =
    result = zero(M.dType)
    for r in 0 ..< m.rows:
      result += m[r]

  proc ones*[M: Vector](typ: typedesc[M], m: int, value: M.dType = 1): M =
    result.init(m)
    for r in 0 ..< result.rows:
      result[r] = value

  proc determinant*[M: Vector](m: M): M.dType =
    result = -1

  proc setPerspectiveProjection*(m: Transform3D) =
    echo "set"


when isMainModule:
  type
    VectorImplF64* = object
      data: seq[float64]
      m*: int

  template dType*[M: VectorImplF64](typ: typedesc[M]): typedesc = float64

  proc initVectorImplF64*(m: int): VectorImplF64 = 
    result.data = newSeq[VectorImplF64.dType](m)
    result.m = m

  proc init*(vec: var VectorImplF64, m: int) =
    vec.data = newSeq[float64](m)
    vec.m = m

  # Adapt the Vector type to the concept's requirements
  proc rows*(vec: VectorImplF64): int = vec.m
  proc size*(vec: VectorImplF64): int = vec.m

  proc `[]`*(vec: VectorImplF64; m: int): SomeNumber =
    vec.data[m]

  proc `[]=`*(vec: var VectorImplF64; m: int; v: SomeNumber) =
    vec.data[m] = v

  proc runVectorImplF64() =
    var
      m: VectorImplF64 = initVectorImplF64(3)
      projectionVector: VectorImplF64 = initVectorImplF64(3)

    echo "m: ", m
    echo "m.sum: ", m.sum()

    var m1 = initVectorImplF64(3)
    m1[0] = 1.0
    m1[1] = 1.0
    m1[2] = 1.0

    echo "m1: ", m1
    echo "m1:sum: ", m1.sum()
    setPerspectiveProjection projectionVector
  
  runVectorImplF64()


when isMainModule:
  type

    ScalarKind* = enum
      kFloat64
      kInt64

    NumberGen* = object
      case skind*: ScalarKind
      of kFloat64:
        f64*: float64
      of kInt64:
        i64*: int64
    
    VectorDyn* = object
      data: pointer
      m*: int
      skind: ScalarKind

  template dType*[M: VectorDyn](typ: typedesc[M]): typedesc[float64] =
    float64
  # template dType*[M: VectorDyn](typ: typedesc[M]): typedesc[NumberGen] =
  #   NumberGen

  proc initVectorDyn*(m: int, skind: ScalarKind): VectorDyn = 
    result.data = alloc0[byte](m*8)
    result.m = m
    result.skind = skind

  proc init*(vec: var VectorDyn, m: int) =
    vec.data = alloc0[byte](m*8)
    vec.m = m
    # result.skind = skind

  # Adapt the Vector type to the concept's requirements
  proc rows*(vec: VectorDyn): int = vec.m
  proc size*(vec: VectorDyn): int = vec.m

  proc `[]`*(vec: VectorDyn; m: int): float64 =
    case vec.skind:
    of kFloat64:
      let data = cast[ptr UncheckedArray[float64]](vec.data)
      data[m]
    of kInt64:
      let data = cast[ptr UncheckedArray[int64]](vec.data)
      data[m].toBiggestFloat

  proc `[]=`*(vec: var VectorDyn; m: int; v: float64) =
    case vec.skind:
    of kFloat64:
      let data = cast[ptr UncheckedArray[float64]](vec.data)
      data[m] = v
    of kInt64:
      let data = cast[ptr UncheckedArray[int64]](vec.data)
      data[m] = v.toBiggestInt

  # proc `[]`*(vec: VectorDyn; m: int): NumberDyn =
  #   case vec.skind:
  #   of kFloat64:
  #     let data = cast[ptr UncheckedArray[float64]](vec.data)
  #     NumberDyn(skind: kFloat64, f64: data[m * vec.rows() + n])
  #   of kInt64:
  #     let data = cast[ptr UncheckedArray[int64]](vec.data)
  #     NumberDyn(skind: kInt64, i64: data[m * vec.rows() + n])

  # proc `[]=`*(vec: var VectorDyn; m: int; v: float64) =
  #   case vec.skind:
  #   of kFloat64:
  #     let data = cast[ptr UncheckedArray[float64]](vec.data)
  #     data[m * vec.rows + n] = v
  #   of kInt64:
  #     let data = cast[ptr UncheckedArray[int64]](vec.data)
  #     data[m * vec.rows + n] = v.toBiggestInt

  proc runVectorDyn() =
    var
      m: VectorDyn = initVectorDyn(3, kInt64)
      projectionVector: VectorDyn = initVectorDyn(3, kFloat64)

    m = VectorDyn.ones(3)
    echo "m: ", m
    echo "m.sum: ", m.sum()

    var m1 = initVectorDyn(3, kFloat64)
    m1[0] = 1.0
    m1[1] = 1.0
    m1[2] = 1.0

    echo "m1: ", m1
    echo "m1:sum: ", m1.sum()
    setPerspectiveProjection projectionVector
  
  runVectorDyn()
