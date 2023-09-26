Include webimport

IncludeGenerator webimport

Class web.CTCityArea Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 107;

Parameter SQLDATEFROM = "CITAREA_DateFrom";

Parameter SQLDATETO = "CITAREA_DateTo";

Parameter SQLCODE = "CITAREA_Code";

Parameter SQLDESCRIPTION = "CITAREA_Desc";

Parameter SQLROWID = "CITAREA_RowId";

/// This value of this parameter is appended to the end of the SQL WHERE clause used in both standard lookups and standard broker validation.
/// This is typically used for filtering records to allow only active records to be used.
Parameter SQLFILTER = "((CITAREA_DateFrom <= CURRENT_DATE OR CITAREA_DateFrom IS NULL) AND (CITAREA_DateTo >= CURRENT_DATE OR CITAREA_DateTo IS NULL))";

Property dummy As %String(TRUNCATE = 1);

Query LookUpByCity(desc As %String, city As %String) As %SQLQuery(CONTAINID = 0, ROWSPEC = "CityAreaDesc:%String,CityDesc:%String,HIDDEN:%String,HIDDEN:%String")
{
SELECT CITAREA_Desc, CITAREA_City_DR->CTCIT_Desc, CITAREA_RowID, CITAREA_City_DR
FROM CT_CityArea
WHERE (CITAREA_Desc %STARTSWITH :desc) AND (CITAREA_City_DR->CTCIT_Desc %STARTSWITH :city)
ORDER BY CITAREA_Desc
}

}
