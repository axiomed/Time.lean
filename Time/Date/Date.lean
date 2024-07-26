import Time.Date.Basic

namespace Time.Date

/-- Represents a date using year, month and day. -/
structure Date where
  year: Year
  month: Month
  day: Day
  valid: day ≤ (month.days year.isLeap)
  deriving Repr, BEq
