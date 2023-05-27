
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
    
proc scalar*(n: int): Scalar = Scalar(skind: kInt64, i64: n)
proc scalar*(n: float): Scalar = Scalar(skind: kFloat64, f64: n)

proc `$`*(s: Scalar): string =
  case s.skind:
  of kFloat64:
    $s.f64
  of kInt64:
    $s.i64
