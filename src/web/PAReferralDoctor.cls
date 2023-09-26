Class web.PAReferralDoctor Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 97;

Property dummy As %Library.String(TRUNCATE = 1);

ClassMethod UpdateRefDoctor(PARREF As %Library.String, DocID As %Library.String)
{
}

Parameter SQLCODE = "REFD_RowId";

Parameter SQLDATEFROM = "REFD_DateFrom";

Parameter SQLDATETO = "REFD_DateTo";

Parameter SQLDESCRIPTION = "REFD_RowId";

Parameter SQLROWID = "REFD_RowId";

}
