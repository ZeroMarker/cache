Class web.CTDayOfWeek Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 66;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Property dummy As %Library.String(TRUNCATE = 1);

/// Find the object id given either a code or a description.<br>
/// To provide control over the code that is generated the following parameters can be used:<br>
/// SQLROWID - specify the SQL field name to be returned from the function.<br>
/// SQLCODE - specify the SQL field name to be used in the search by code.<br>
/// SQLDESCRIPTION - specify the SQL field name to be used in the search by descripiton.<br>
/// <br>
/// NOTE that these same parameters are are in the generation of default lookups.<br>
ClassMethod GetIdFromCodeOrDescription(val As %Library.String) As %Library.String
{
}

ClassMethod LookUpDayBroker(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "")
{
}

Parameter SQLCODE = "DOW_RowId";

Parameter SQLDESCRIPTION = "DOW_Name";

Parameter SQLROWID = "DOW_RowId";

Query LookUpDay(desc As %Library.String) As %Library.SQLQuery(CONTAINID = 2, ROWSPEC = "Description:%String,HIDDEN:%String,Code:%String")
{
Select DOW_Name,DOW_RowId,DOW_Day
 FROM	SQLUSER.CT_DayOfWeek
 WHERE	DOW_Name %STARTSWITH :desc
 Order	by DOW_Day
}

}
