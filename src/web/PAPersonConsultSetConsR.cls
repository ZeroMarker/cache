Class web.PAPersonConsultSetConsR Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 102;

Parameter SQLCODE = "CONSR_RowId";

Parameter SQLDATEFROM = "CONSR_CreateDate";

Parameter SQLDATETO = "CONSR_CreateTime";

Parameter SQLDESCRIPTION = "CONSR_RowId";

Parameter SQLROWID = "CONSR_RowId";

Property dummy As %String(TRUNCATE = 1);

/// ab 23.08.06 59768 - called from orders, and discharge summary saves
ClassMethod CreateReferral(ConsultID As %String = "", OrderItem As %String = "", DischSumID As %String = "") As %String
{
}

Query FindReferral(ConsultID As %String, RefFlag As %String, PatientID As %String) As %Library.Query(CONTAINID = 0, ROWSPEC = "ID:%String,CreateDate:%Date,CreateTime:%Time,DSRowId:%String,DSTDesc:%String,DSLink:%String,DocDR:%String,ARCIMDesc:%String,OEORIRowId:%String,ARCIMRowId:%String,Documents:%String")
{
}

ClassMethod FindReferralClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindReferralFetch ]
{
}

/// ab 20.07.06 59776
/// ab 22.12.06 60381 - rewritten to use globals, patientid based search
ClassMethod FindReferralExecute(ByRef QHandle As %Library.Binary, ConsultID As %String = "", RefFlag As %String = "", PatientID As %String = "") As %Library.Status
{
}

ClassMethod FindReferralFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = FindReferralExecute ]
{
}

}
