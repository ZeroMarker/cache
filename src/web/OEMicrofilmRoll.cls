Class web.OEMicrofilmRoll Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 52;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "OEMF_RollID";

Parameter SQLDESCRIPTION = "OEMF_RollDesc";

Parameter SQLROWID = "OEMF_RowId";

Property dummy As %Library.String(TRUNCATE = 1);

ClassMethod GetRollDesc(RollId As %Library.String, HospitalDR As %Library.String = "") As %Library.String
{
}

ClassMethod GetRollNumber(RowId As %Library.String) As %Library.String
{
}

ClassMethod LookUpBrokerByHosp(itmjs As %Library.String = "", itmjsex As %Library.String = "", HospDR As %Library.String = "", RollID As %Library.String = "") As %Library.Boolean
{
}

}
