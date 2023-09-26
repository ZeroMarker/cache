Class web.PAPatMasComments Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 40;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "CMT_RowId";

Parameter SQLDESCRIPTION = "CMT_ShortDesc";

Parameter SQLROWID = "CMT_RowId";

/** 
 *  This is called from PAPatMasComments.List component in Dummy field
 */
ClassMethod GetDetails(ID As %Library.String = "")
{
}

ClassMethod IsCommentExist(PatientID As %Library.String = "") As %Library.Boolean
{
}

/// Log 61530 - 30.11.2006 - If atleast ONE comment is ON HOLD return true
ClassMethod IsOnHold(PatientID As %Library.String = "") As %Library.Boolean
{
}

ClassMethod GetLastAccountComment(PatientID As %Library.String = "") As %Library.String
{
}

ClassMethod websysSaveAddComment(compref As %Library.String, id As %Library.String = "", PARREF As %Library.String = "")
{
}

ClassMethod FindClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindFetch ]
{
}

ClassMethod FindExecute(ByRef QHandle As %Library.Binary, PatientID As %Library.String = "") As %Library.Status
{
}

ClassMethod FindFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = FindExecute ]
{
}

Query Find(PatientID As %String) As %Library.Query(CONTAINID = 1, ROWSPEC = "CMTID,CMTComments:%String,CMTDate:%Date,CMTTime:%Time,CMTHosp:%String,CMTUser:%String,CMTFutureDate:%Date,CMTLastUpdateDate:%Date,CMTLastUpdateTime:%Time,CMTLastUpdateUser:%String,CMTLastUpdateHosp:%String,CMTLastUpdateUserID:%String,CMTShortDesc:%String,CMTOnHold:%String")
{
}

}
