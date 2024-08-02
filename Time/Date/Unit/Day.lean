/-
Copyright (c) 2024 Lean FRO, LLC. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Sofia Rodrigues
-/
prelude
import Time.Time
import Time.UnitVal
import Time.Bounded
import Time.LessEq
import Lean.Data.Rat

namespace Date
open Lean Time

set_option linter.all true

namespace Day

/--
`Ordinal` represents a bounded value for days, which ranges between 0 and 31.
-/
def Ordinal := Bounded.LE 1 31
  deriving Repr, BEq, LE, LT

instance [Le 1 n] [Le n 31] : OfNat Ordinal n where
  ofNat := Bounded.LE.mk (Int.ofNat n) (And.intro (Int.ofNat_le.mpr Le.p) (Int.ofNat_le.mpr Le.p))

instance { x y : Ordinal } : Decidable (x ≤ y) :=
  dite (x.val ≤ y.val) isTrue isFalse

instance : Inhabited Ordinal where default := 1

/--
`Ordinal.OfYear` represents a bounded value for days, which ranges between 0 and 31.
-/
def Ordinal.OfYear (leap : Bool) := Bounded.LE 1 (.ofNat (if leap then 366 else 365))

instance [Le 1 n] [Le n (if leap then 366 else 365)] : OfNat (Ordinal.OfYear leap) n where
  ofNat := Bounded.LE.mk (Int.ofNat n) (And.intro (Int.ofNat_le.mpr Le.p) (Int.ofNat_le.mpr Le.p))

instance : Inhabited (Ordinal.OfYear leap) where
  default := by
    refine ⟨1, And.intro (by decide) ?_⟩
    split <;> simp

/--
`Offset` represents an offset in days. It is defined as an `Int`.
-/
def Offset : Type := UnitVal 86400
  deriving Repr, BEq, Inhabited, Add, Sub, Mul, Div, Neg, LE, LT

instance : OfNat Offset n := ⟨UnitVal.ofNat n⟩

namespace Ordinal

/--
Creates an `Ordinal` from a natural number, ensuring the value is within bounds.
-/
def ofNat (data : Nat) (h : data ≥ 1 ∧ data ≤ 31 := by decide) : Ordinal :=
  Bounded.LE.ofNat' data h

/--
Creates an `Ordinal` from a `Fin`, ensuring the value is within bounds, if its 0 then its converted
to 1.
-/
def ofFin (data : Fin 32) : Ordinal :=
  Bounded.LE.ofFin' data (by decide)

/--
Converts an `Ordinal` to an `Offset`.
-/
def toOffset (ordinal : Ordinal) : Offset :=
  UnitVal.ofInt ordinal.val

end Ordinal

namespace Offset

/--
Convert `Day.Offset` into `Second.Offset`.
-/
def toSeconds (days : Offset) : Second.Offset :=
  days.mul 86400

end Offset
end Day
