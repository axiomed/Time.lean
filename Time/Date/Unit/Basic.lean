/-
Copyright (c) 2024 Lean FRO, LLC. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Sofia Rodrigues
-/
prelude
import Time.UnitVal
import Time.Date.Unit.Day
import Time.Date.Unit.Month
import Time.Date.Unit.Year
import Time.Date.Unit.WeekDay
import Time.Date.Unit.WeekOfYear

namespace Date.Day.Ordinal.OfYear

@[inline]
def toMonthAndDay (year: Year.Offset) (ordinal : OfYear year.isLeap) : { val : Month.Ordinal × Ordinal // Year.Offset.valid year (Prod.fst val) (Prod.snd val) } :=
  Month.Ordinal.ofOrdinal ordinal

end Date.Day.Ordinal.OfYear
