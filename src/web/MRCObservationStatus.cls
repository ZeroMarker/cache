Class web.MRCObservationStatus Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 54;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Property dummy As %Library.String(TRUNCATE = 1);

/// Called by the web broker.
/// The main purpose is to convert from code to description dynamically.
/// itmjs - javascript function e.g. Location_lookupsel
/// itmjsex - extended javascript function
ClassMethod LookUpBrokerByTypeRestrict(itmjs As %Library.String, itmjsex As %Library.String, type As %Library.String = "", val As %Library.String = "") As %Library.Boolean
{
}

Parameter SQLCODE = "OBSST_Code";

Parameter SQLDESCRIPTION = "OBSST_Desc";

Parameter SQLROWID = "OBSST_RowId";

Query LookUpByTypeRestrict(type As %String, val As %String) As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "Description,Code,HIDDEN")
{
SELECT Description, Code, StoredValue
FROM websys.StandardTypeItem
WHERE (ParRef='ResultType') 
AND ('A,E' [ (StoredValue) )
}

}
