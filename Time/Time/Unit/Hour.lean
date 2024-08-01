/-
Copyright (c) 2024 Lean FRO, LLC. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Sofia Rodrigues
-/
prelude
import Time.UnitVal
import Time.Bounded
import Time.Classes
import Lean.Data.Rat
import Time.Time.Unit.Minute
import Time.Time.Unit.Second

namespace Time
open Lean

set_option linter.all true

namespace Hour

/--
`Ordinal` represents a bounded value for hours, which ranges between 0 and 23.
-/
def Ordinal := Bounded.LE 0 23
  deriving Repr, BEq, LE

instance [Le n 23] : OfNat Ordinal n where ofNat := Bounded.LE.ofNat n Le.p

instance : Inhabited Ordinal where default := 0

/--
`Offset` represents an offset in hours. It is defined as an `Int`. It starts on the epoch.
-/
def Offset : Type := UnitVal 3600
  deriving Repr, BEq, Inhabited, Add, Sub, Mul, Div, Neg

instance : OfNat Offset n := ⟨UnitVal.ofNat n⟩

namespace Ordinal

/--
Creates an `Ordinal` from a natural number, ensuring the value is within bounds.
-/
@[inline]
def ofNat (data : Nat) (h: data ≤ 23 := by decide) : Ordinal :=
  Bounded.LE.ofNat data h

/--
Creates an `Ordinal` from a `Fin`, ensuring the value is within bounds.
-/
@[inline]
def ofFin (data : Fin 24) : Ordinal :=
  Bounded.LE.ofFin data

/--
Converts an `Ordinal` to an `Offset`.
-/
@[inline]
def toOffset (ordinal : Ordinal) : Offset :=
  UnitVal.ofInt ordinal.val

end Ordinal

namespace Offset

/--
Convert the `Hour` offset to a `Second` Offset.
-/
@[inline]
def toSeconds (val : Offset) : Second.Offset :=
  val.mul 3600

/--
Convert the `Hour` offset to a `Minute` Offset.
-/
@[inline]
def toMinutes (val : Offset) : Minute.Offset :=
  val.mul 60

end Offset
end Hour