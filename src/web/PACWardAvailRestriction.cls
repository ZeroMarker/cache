Class web.PACWardAvailRestriction Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 80;

Parameter SQLDATEFROM = "AVR_DateFrom";

Parameter SQLDATETO = "AVR_DateTo";

Parameter SQLCODE = "AVR_RowId";

Parameter SQLDESCRIPTION = "AVR_RowId";

Parameter SQLROWID = "AVR_RowId";

Property Dummy As %Library.String(TRUNCATE = 1);

/// returns a display for the "Y|N|N",etc string that is set for day restrictions
ClassMethod GetDayRestrictionDesc(res As %Library.String = "", timefrom As %Library.String = "", timeto As %Library.String = "") As %Library.String
{
}

ClassMethod IsRestrictedWard(WardID As %String = "", Date As %Library.Date = "", Time As %Library.Time = "") As %Library.Boolean
{
}

Query FindRestrictionByWardID(WardID As %Library.String) As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "ID,ReadsonID,DateFrom:%Library.Date,DateTo:%Library.Date,TimeFrom:%Library.Time,TimeTo:%Library.Time,AVRMonday,AVRTuesday,AVRWednesday,AVRThursday,AVRFriday,AVRSaturday,AVRSunday")
{
SELECT AVR_RowId,AVR_ReasonNotAvail_DR,
 AVR_DateFrom,AVR_DateTo,AVR_TimeFrom,AVR_TimeTo,
 AVR_Monday,AVR_Tuesday,AVR_Wednesday,AVR_Thursday,AVR_Friday,AVR_Saturday,AVR_Sunday
FROM SQLUser.PAC_WardAvailRestriction
WHERE (AVR_ParRef = :WardID)
ORDER BY AVR_DateFrom DESC,AVR_DateTo DESC
}

}
