# SQL-Calendar
Implementation of creating a calendar table in SQL.

This repositiory is specific to a use case I had at work. It is not meant to be a solution to a problem that really exists (there's a million implentations of this available).

Previousy, in our use-case we used a variation the following code:

`
datefromparts(
    year(dateadd(d, -21, '2025-01-01')),
    month(dateadd(d, -21, '2025-01-01')),
    22
)
`

or with getdate():

`datefromparts(
    year(dateadd(d, -21, getdate())),
    month(dateadd(d, -21, getdate())),
    22
)
`

With a calendar table, we don't have to deal with finding what year and month it was 21 days ago and forcing it to the 22nd.

We also have a JSWeek, which is useful for, in our case, setting `input[type="week"]` to a value without any conversions.

The rest of it should be relatively self explanatory.

If you find it useful, I'm glad. 

You are free to use this code, modify it, distibute it, tell me its good, tell me its bad, or even read it to little Coder Jr as a bedtime story. 
