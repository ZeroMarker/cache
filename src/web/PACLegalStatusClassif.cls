Class web.PACLegalStatusClassif Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 46;

Parameter SQLDATEFROM = "LEGST_DateFrom";

Parameter SQLDATETO = "LEGST_DateTo";

Parameter SQLCODE = "LEGST_Code";

Parameter SQLDESCRIPTION = "LEGST_Desc";

Parameter SQLROWID = "LEGST_RowId";

Property dummy As %Library.String(TRUNCATE = 1);

ClassMethod GetDescFromId(rowid As %Library.String) As %Library.String
{
}

Query LookUpByName(LSCode As %String) As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "LSDesc,LSCode")
{
SELECT LEGST_Desc,LEGST_Code
FROM SQLUser.PAC_LegalStatusClassif
ORDER BY	LEGST_Desc
}

ClassMethod LookUpBrokerWithDate(itmjs As %String = "", itmjsex As %String = "", val As %String = "", date As %Date = "", LogonHosp As %String = "") As %Boolean
{
}

Query LookUpWithDate(desc As %String, date As %Date = "", LogonHosp As %String = "") As %Library.Query(CONTAINID = 1, ROWSPEC = "LEGSTDesc,LEGSTCode,HIDDEN,HIDDEN")
{
}

ClassMethod LookUpWithDateExecute(ByRef QHandle As %Library.Binary, desc As %String, date As %Date = "", LogonHosp As %String = "") As %Library.Status
{
}

ClassMethod LookUpWithDateFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = LookUpWithDateExecute ]
{
}

ClassMethod LookUpWithDateClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = LookUpWithDateFetch ]
{
}

}
