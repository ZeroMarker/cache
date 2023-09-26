Class web.PACBloodType Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 43;

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

Parameter SQLCODE = "BLDT_Code";

Parameter SQLDESCRIPTION = "BLDT_Desc";

Parameter SQLROWID = "BLDT_RowId";

}
