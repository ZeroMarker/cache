Class web.ORCASAClassPhActiv Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 34;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

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

ClassMethod LookUpBrokerDesc(itmjs As %Library.String = "", itmjsex As %Library.String = "", desc As %Library.String = "") As %Library.Boolean
{
}

Parameter SQLCODE = "ORASA_Code";

Parameter SQLDESCRIPTION = "ORASA_RowId";

Parameter SQLROWID = "ORASA_RowId";

Query LookUpDesc(desc) As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "ORASACode,ORASADesc ")
{
SELECT ORASA_Code, ORASA_Desc 
FROM SQLUser.ORC_ASA_ClassPhActiv
WHERE (%ALPHAUP ORASA_Desc = %ALPHAUP :desc OR %ALPHAUP ORASA_Desc %STARTSWITH %ALPHAUP :desc) 
OR (%ALPHAUP ORASA_Code = %ALPHAUP :desc OR %ALPHAUP ORASA_Code %STARTSWITH %ALPHAUP :desc)
}

}
