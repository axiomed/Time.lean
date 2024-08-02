/-
Copyright (c) 2024 Lean FRO, LLC. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Sofia Rodrigues
-/
prelude
import Time.UnitVal
import Time.Bounded
import Time.LessEq
import Lean.Data.Rat
import Time.Time.Unit.Nanosecond

namespace Time
open Lean

set_option linter.all true

namespace Second

/--
`Ordinal` represents a bounded value for second, which ranges between 0 and 60.
This accounts for potential leap second.
-/
def Ordinal := Bounded.LE 0 60
  deriving Repr, BEq, LE

instance [Le n 60] : OfNat Ordinal n where ofNat := Bounded.LE.ofNat n Le.p

instance : Inhabited Ordinal where default := 0

/--
`Offset` represents an offset in second. It is defined as an `Int`.
-/
def Offset : Type := UnitVal 1
  deriving Repr, BEq, Inhabited, Add, Sub, Mul, Div, Neg, LE, LT, ToString

instance : OfNat Offset n := ⟨UnitVal.ofNat n⟩

namespace Ordinal

/--
Creates an `Ordinal` from a natural number, ensuring the value is within bounds.
-/
@[inline]
def ofNat (data : Nat) (h : data ≤ 60 := by decide) : Ordinal :=
  Bounded.LE.ofNat data h

/--
Creates an `Ordinal` from a `Fin`, ensuring the value is within bounds.
-/
@[inline]
def ofFin (data : Fin 61) : Ordinal :=
  Bounded.LE.ofFin data

/--
Converts an `Ordinal` to an `Offset`.
-/
@[inline]
def toOffset (ordinal : Ordinal) : Offset :=
  UnitVal.ofInt ordinal.val

end Ordinal

namespace Offset

def ofNanosecond (offset : Nanosecond.Offset) : Second.Offset × Nanosecond.Span :=
  let second := offset.val.div 1000000000
  let nano := Bounded.LE.byMod offset.val 1000000000 (by decide)
  ⟨UnitVal.ofInt second, nano⟩

end Offset
end Second
