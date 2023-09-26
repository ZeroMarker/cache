Class web.PAPMIUpdate Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 146;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Property dummy As %Library.String(TRUNCATE = 1);

/// rqg,Log26093: Method to process multiple id's.
ClassMethod BatchResubmit(ids As %Library.String)
{
}

ClassMethod FindRejectHomerClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindRejectHomerFetch ]
{
}

/// KK 13/nov/2002 Log 28206
/// 
ClassMethod FindRejectHomerExecute(ByRef QHandle As %Library.Binary, TSRTITM As %Library.String = "", TSRTORD As %Library.String = "", RegNumber As %Library.String = "", SName As %Library.String = "", AdmNo As %Library.String = "") As %Library.Status
{
}

/// KK 13/nov/2002 Log 28206
ClassMethod FindRejectHomerFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = FindRejectHomerExecute ]
{
}

ClassMethod GotErrors() As %Library.Boolean
{
}

ClassMethod ListRejectFromHomerClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = ListRejectFromHomerFetch ]
{
}

ClassMethod ListRejectFromHomerExecute(ByRef QHandle As %Library.Binary) As %Library.Status
{
}

ClassMethod ListRejectFromHomerFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = ListRejectFromHomerExecute ]
{
}

ClassMethod ReSend(id As %Library.String)
{
}

Parameter SQLCODE = "PMI_RowId";

Parameter SQLDESCRIPTION = "PMI_RowId";

Parameter SQLROWID = "PMI_RowId";

Query FindRejectHomer(TSRTITM As %String, TSRTORD As %String, PMIRego, PAPMIName, PAADMADMNo) As %Library.Query(CONTAINID = 0, ROWSPEC = "ID,Rego,SurName,GivenName,OtherName,ErrorMsg,ADMNo,PDate,PTime,UpdUser")
{
}

Query ListRejectFromHomer() As %Library.Query(CONTAINID = 0, ROWSPEC = "PMIRowID,PMIErrorMessage,PMIRego")
{
}

}
