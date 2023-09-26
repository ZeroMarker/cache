Class web.CTLocationListLocations Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 69;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "LOC_RowId";

Parameter SQLDESCRIPTION = "LOC_RowId";

Parameter SQLROWID = "LOC_RowId";

Property Dummy As %Library.String(TRUNCATE = 1);

ClassMethod LookUpBrokerOnCode(itmjs As %Library.String = "", itmjsex As %Library.String = "", LocListID As %Library.String = "", code As %Library.String = "", date As %String = "") As %Library.Boolean
{
}

Query Find(LocListID As %String) As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "ID:%String,CTLOCDesc:%String,CTLOCDR:%String,CTLOCCode:%String")
{
SELECT  LOC_RowId,LOC_CTLOC_DR->CTLOC_Desc,
LOC_CTLOC_DR,LOC_CTLOC_DR->CTLOC_Code
FROM SQLUser.CT_LocationList_Locations
WHERE ((LOC_ParRef=:LocListID) OR (:LocListID IS NULL))
}

Query Find1(LocListID As %String, LocDesc As %String, date As %String) As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "CTLOCDesc:%String,CTLOCCode:%String")
{
SELECT  LOC_CTLOC_DR->CTLOC_Desc,LOC_CTLOC_DR->CTLOC_Code
FROM SQLUser.CT_LocationList_Locations
WHERE LOC_ParRef=:LocListID
AND  LOC_CTLOC_DR->CTLOC_Desc %STARTSWITH :LocDesc
AND ((:date IS NULL) OR ((LOC_CTLOC_DR->CTLOC_DateActiveFrom IS NULL OR LOC_CTLOC_DR->CTLOC_DateActiveFrom <= :date) AND (LOC_CTLOC_DR->CTLOC_DateActiveTo IS NULL OR LOC_CTLOC_DR->CTLOC_DateActiveTo >= :date)))
}

}
