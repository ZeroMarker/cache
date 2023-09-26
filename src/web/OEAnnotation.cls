Class web.OEAnnotation Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 128;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "ANNOT_RowId";

Parameter SQLDESCRIPTION = "ANNOT_RowId";

Parameter SQLROWID = "ANNOT_RowId";

Property dummy As %Library.String(TRUNCATE = 1);

/// Default save method used for updating the database for Components of type Edit.<br>
/// <br>
/// The compref is the  component reference which is the string from which we can deduce the instance of<BR>
/// websysComponent<BR>
/// websysComponentItem<BR>
/// id is the id for the instance of class we wish to update.
ClassMethod websysSave(compref As %String, id As %String) [ CodeMode = generator ]
{
}

ClassMethod websysSaveAnnotation(mradm As %Library.String = "", MRPicRowId As %Library.String = "", OEOrdResId As %Library.String = "", FileName As %Library.String = "", xmlData As %Library.String = "", OrderItemId As %Library.String, SessionId As %Library.String = "", QuestionCode As %Library.String = "") As %Library.String
{
}

/// log50748 TedT
ClassMethod GetAnnotationFromOrderID(OrdID As %String) As %String
{
}

ClassMethod GetAnnotationXML(OrdId As %String, MRPicId As %String) As %String
{
}

//LOG:63888: DMT:

/*
function GetMRPicRowID
parameter: OrderItemId as string
return: List of ANNOT_MRPic_DR. 
ANNOT_MRPic_DR = RowID in ^MR = MR_Adm.MRADM_RowId||PIC_ChildSub  
*/
ClassMethod GetMRPicRowID(OrdID As %String) As %String
{
}

//LOG:63888: END:

}
