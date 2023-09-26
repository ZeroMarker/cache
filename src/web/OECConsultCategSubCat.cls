Class web.OECConsultCategSubCat Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 15;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "SUB_Code";

Parameter SQLDESCRIPTION = "SUB_Desc";

Parameter SQLROWID = "SUB_RowId";

ClassMethod LookUpBrokerWithCat(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "", parref As %Library.String) As %Library.Boolean
{
}

Query LookUpWithCat(val As %String, parref As %String) As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "Description:%String,HIDDEN:%String,Code:%String,HIDDEN:%String,Category:%String")
{
  SELECT SUB_Desc,SUB_RowId,SUB_Code,SUB_ParRef->CONS_RowId,SUB_ParRef->CONS_Desc
      FROM SQLUser.OEC_ConsultCategSubCat
      WHERE ((SUB_Desc %STARTSWITH :val OR SUB_Code %STARTSWITH :val) AND (SUB_ParRef->CONS_Desc = :parref OR :parref IS NULL))
      order by SUB_Desc
}

}
