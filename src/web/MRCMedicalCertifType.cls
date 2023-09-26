Class web.MRCMedicalCertifType Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 5;

Parameter SQLCODE = "MEDCT_Code";

Parameter SQLDATEFROM = "MEDCT_DateFrom";

Parameter SQLDATETO = "MEDCT_DateTo";

Parameter SQLDESCRIPTION = "MEDCT_Desc";

Parameter SQLROWID = "MEDCT_RowId";

Property dummy As %String(TRUNCATE = 1);

}
