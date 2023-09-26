Class web.PACBedDates Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 88;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Property dummy As %Library.String(TRUNCATE = 1);

ClassMethod ColourForDaysOut(DaysOut As %Library.String) As %Library.String
{
}

ClassMethod ColourForEstimatedDischarge(EstDiscDate As %Library.Date) As %Library.String
{
}

/// ab 19.11.02 - checks whether there is already a column displaying totals for this day range
/// this is so we dont tally confirmed+unconfirmed columns into 'totdisch' when not necessary.
/// called from PACWard:FindWardBedStatus
ClassMethod HasTotalColumn(days As %Library.String = "") As %Library.String
{
}

Parameter SQLCODE = "BDATE_Code";

Parameter SQLDESCRIPTION = "BDATE_RowId";

Parameter SQLROWID = "BDATE_RowId";

Query FindBedDatesDesc() As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "BDATEDesc:%String,BDATEColor:%String")
{
SELECT BDATE_Desc, BDATE_Color
FROM SQLUser.PAC_BedDates
ORDER BY BDATE_Code
}

}
