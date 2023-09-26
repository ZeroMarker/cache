Class web.RBApptSchema Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 57;

Parameter SQLCODE = "SCH_RowId";

Parameter SQLDATEFROM = "SCH_DateFrom";

Parameter SQLDATETO = "SCH_DateTo";

Parameter SQLDESCRIPTION = "SCH_Desc";

Parameter SQLROWID = "SCH_RowId";

ClassMethod GenerateSchema(compref As %String = "", id As %String = "")
{
}

ClassMethod websysSave(compref As %String = "", id As %String = "")
{
}

Query FindSchemaAppts(ID As %String = "") As %SQLQuery(CONTAINID = 0, ROWSPEC = "SCHAPID,SCHAPApptNum,SCHAPFreq,SCHAPFreqInt,SCHAPSerDesc")
{
SELECT AP_RowId,AP_ApptNumber,AP_Frequency,AP_FreqInterval,AP_Service_DR->SER_Desc FROM SQLUser.RB_ApptSchemaAppt
WHERE AP_ParRef=:ID
ORDER BY AP_ApptNumber
}

Query FindSchemas(Hospital As %String = "", Location As %String = "", SchemaTypeID As %String = "") As %SQLQuery(CONTAINID = 0, ROWSPEC = "SCHID,SCHDesc,SCHType,SCHNOA,SCHHosp,SCHLoc,SCHDFrom,SCHDTo")
{
SELECT SCH_RowId,SCH_Desc,SCH_Type,SCH_NumberOfAppt,SCH_Hospital_DR->HOSP_Desc,SCH_CTLOC_DR->CTLOC_Desc,SCH_DateFrom,SCH_DateTo 
FROM SQLUser.RB_ApptSchema
WHERE ( (SCH_Type = :SchemaTypeID) OR (:SchemaTypeID IS NULL) )
AND ( (SCH_Hospital_DR->HOSP_Desc = :Hospital) OR (:Hospital IS NULL) )
AND ( (SCH_CTLOC_DR->CTLOC_Desc = :Location) OR (:Location IS NULL) )
}

}
