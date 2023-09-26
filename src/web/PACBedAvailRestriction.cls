Class web.PACBedAvailRestriction Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 72;

Property dummy As %Library.String(TRUNCATE = 1);

/// ab 15.10.02
/// checks if bed has any current restrictions, returns reason
/// used on floorplan for icon
ClassMethod IsRestricted(BedID As %Library.String = "", RestrictDate As %Library.String = "", RestrictTime As %Library.String = "", ByRef RESTRICT As %Library.String = "") As %Library.String
{
	// User.PACBedAvailRestriction
	//^PAWARD($P(BedID,"||",1),"BED",$p(BedID,"||",2),"AVR",avrchilidsub)
	quit ""
}

Parameter SQLCODE = "AVR_RowId";

Parameter SQLDATEFROM = "AVR_DateFrom";

Parameter SQLDATETO = "AVR_DateTo";

Parameter SQLDESCRIPTION = "AVR_RowId";

Parameter SQLROWID = "AVR_RowId";

/// 
/// 	AND (AVR_DateTo>:Date OR (AVR_DateTo=:Date AND AVR_TimeTo>:Time))
/// 
Query Find(BedID As %Library.String, Date As %Library.Date, Time As %Library.Time) As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "ID,ReasonID,ReasonDesc,DateFrom,DateTo,TimeFrom,TimeTo")
{
SELECT AVR_Rowid,
 AVR_ReasonNotAvail_DR, 
 AVR_ReasonNotAvail_DR->RNAV_Desc,
 AVR_DateFrom,
 AVR_DateTo,
 AVR_TimeFrom,
 AVR_TimeTo
FROM SQLUser.PAC_BedAvailRestriction
WHERE (AVR_ParRef = :BedID)
 AND ((AVR_DateFrom IS NULL) OR (AVR_DateFrom<:Date) OR (AVR_DateFrom=:Date))
 AND ((AVR_DateTo IS NULL) OR (AVR_DateTo>:Date) OR (AVR_DateTo=:Date))
 AND ((AVR_TimeFrom IS NULL) OR (AVR_TimeFrom <= :Time) AND (AVR_TimeTo >= :Time))
}

Query FindRestrictionByWardID(WardID As %Library.String) As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "ID,Reason,DateFrom:%Library.Date,DateTo:%Library.Date,TimeFrom:%Library.Time,TimeTo:%Library.Time,AVRMonday,AVRTuesday,AVRWednesday,AVRThursday,AVRFriday,AVRSaturday,AVRSunday,BEDCode,ROOMDesc")
{
SELECT AVR_RowId,AVR_ReasonNotAvail_DR->RNAV_Desc,
 AVR_DateFrom,AVR_DateTo,AVR_TimeFrom,AVR_TimeTo,
 AVR_Monday,AVR_Tuesday,AVR_Wednesday,AVR_Thursday,AVR_Friday,AVR_Saturday,AVR_Sunday,
 AVR_ParRef->BED_Code,AVR_ParRef->BED_Room_DR->ROOM_Desc
FROM SQLUser.PAC_BedAvailRestriction
WHERE (AVR_ParRef->BED_WARD_ParRef->WARD_RowID = :WardID)
ORDER BY AVR_DateFrom DESC,AVR_DateTo DESC
}

}
