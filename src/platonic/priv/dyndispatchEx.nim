
type
    ScalarKind* = enum
      kFloat64
      kInt64

    Number* = object
      case skind*: ScalarKind
      of kFloat64:
        f64*: float64
      of kInt64:
        i64*: int64
    