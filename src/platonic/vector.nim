
import std/typetraits

type

  Vector* = concept vec, var vvar, type V
    V.dType() is typedesc

    vec.rows() is int
    vec.size() is int
    
    vec[int] is V.dType
    vvar[int] = V.dType
  
    vvar.init(int)

    # zero(vec) is V.dType
    # type TransposedType = stripGenericParams(V)[T]
  
  SquareVector* = Vector
  
  Transform3D* = Vector

template zero*[N: Vector](m: N): N.dType = zero(N.dType)

when isMainModule:
  # Example Procs
  # =============

  proc sum*[V: Vector](m: V): V.dType =
    # result = zero(m)
    for r in 0 ..< m.rows:
      result += m[r]

  proc ones*[V: Vector](typ: typedesc[V], m: int, value: V.dType = V.dType(1)): V =
    result.init(m)
    for r in 0 ..< result.rows:
      result[r] = value

  proc determinant*[V: Vector](m: V): V.dType =
    result = -1

  proc setPerspectiveProjection*(m: Transform3D) =
    echo "set"


when isMainModule:
  type
    VectorImplF64* = object
      data: seq[float64]
      m*: int

  template dType*[V: VectorImplF64](typ: typedesc[V]): typedesc = float64

  proc initVectorImplF64*(m: int): VectorImplF64 = 
    result.data = newSeq[VectorImplF64.dType](m)
    result.m = m

  proc init*(vec: var VectorImplF64, m: int) =
    vec.data = newSeq[float64](m)
    vec.m = m

  template zero*(m: float64): float64 = 0.0

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
    # echo "m.zero: ", m.zero()
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
  import ./priv/dyndispatchEx

  type

    VectorDyn* = object
      data: pointer
      m*: int
      skind: ScalarKind

  template dType*[V: VectorDyn](typ: typedesc[V]): typedesc[Scalar] =
    Scalar
  # template dType*[V: VectorDyn](typ: typedesc[V]): typedesc[NumberGen] =
  #   NumberGen

  proc initVectorDyn*(m: int, skind: ScalarKind): VectorDyn = 
    result.data = alloc0[byte](m*8)
    result.m = m
    result.skind = skind

  proc init*(vec: var VectorDyn, m: int) =
    vec.data = alloc0[byte](m*8)
    vec.m = m
    # result.skind = skind

  proc zero*(m: VectorDyn): Scalar = 0.scalar

  # Adapt the Vector type to the concept's requirements
  proc rows*(vec: VectorDyn): int = vec.m
  proc size*(vec: VectorDyn): int = vec.m

  # proc `[]`*(vec: VectorDyn; m: int): float64 =
  #   case vec.skind:
  #   of kFloat64:
  #     let data = cast[ptr UncheckedArray[float64]](vec.data)
  #     data[m]
  #   of kInt64:
  #     let data = cast[ptr UncheckedArray[int64]](vec.data)
  #     data[m].toBiggestFloat

  # proc `[]=`*(vec: var VectorDyn; m: int; v: Scalar) =
  #   case vec.skind:
  #   of kFloat64:
  #     let data = cast[ptr UncheckedArray[float64]](vec.data)
  #     data[m] = v
  #   of kInt64:
  #     let data = cast[ptr UncheckedArray[int64]](vec.data)
  #     data[m] = v.toBiggestInt

  proc `[]`*(vec: VectorDyn; m: int): Scalar =
    discard
    # case vec.skind:
    # of kFloat64:
    #   let data = cast[ptr UncheckedArray[float64]](vec.data)
    #   Scalar(skind: kFloat64, f64: data[m])
    # of kInt64:
    #   let data = cast[ptr UncheckedArray[int64]](vec.data)
    #   Scalar(skind: kInt64, i64: data[m])

  proc `[]=`*(vec: var VectorDyn; m: int; v: Scalar) =
    discard
    # case vec.skind:
    # of kFloat64:
    #   let data = cast[ptr UncheckedArray[float64]](vec.data)
    #   data[m] = v
    # of kInt64:
    #   let data = cast[ptr UncheckedArray[int64]](vec.data)
    #   data[m] = v.toBiggestInt

  proc runVectorDyn() =
    var
      m: VectorDyn = initVectorDyn(3, kInt64)
      projectionVector: VectorDyn = initVectorDyn(3, kFloat64)

    # m = VectorDyn.ones(3.scalar)
    echo "m: ", m
    echo "m.sum: ", $sum(m)

    var m1 = initVectorDyn(3, kFloat64)
    m1[0] = 1.0.scalar
    m1[1] = 1.0.scalar
    m1[2] = 1.0.scalar

    echo "m1: ", m1
    echo "m1.zero: ", m1.zero()
    echo "m1:sum: ", m1.sum()
    setPerspectiveProjection projectionVector
  
  runVectorDyn()
