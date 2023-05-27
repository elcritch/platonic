
type
    ScalarKind* = enum
      kFloat64
      kInt64

    Scalar* = object
      case skind*: ScalarKind
      of kFloat64:
        f64*: float64
      of kInt64:
        i64*: int64
    
proc scalar*(n: int): Scalar =
  result = Scalar(skind: kInt64, i64: n)
proc scalar*(n: float): Scalar =
  result = Scalar(skind: kFloat64, f64: n)

template zero*(m: Scalar): Scalar = 0.0.scalar

proc initScalar*(k: ScalarKind): Scalar =
  case k:
  of kFloat64:
    result = 0.0'f64.scalar
  of kInt64:
    result = 0'i64.scalar

proc `+=`*(s: var Scalar, a: Scalar) =
  assert s.skind == a.skind
  case s.skind:
  of kFloat64:
    s.f64 += a.f64
  of kInt64:
    s.i64 += a.i64

proc `$`*(s: Scalar): string =
  case s.skind:
  of kFloat64:
    $s.f64
  of kInt64:
    $s.i64
