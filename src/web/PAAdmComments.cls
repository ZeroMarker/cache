Class web.PAAdmComments Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 152;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "CMT_RowId";

Parameter SQLDESCRIPTION = "CMT_RowId";

Parameter SQLROWID = "CMT_RowId";

/** 
 *  This is called from PAAdmEpisodeComments.List component in Dummy field
 */
ClassMethod GetDetails(ID As %Library.String = "")
{
}

ClassMethod GetLastEpisodeComment(EpisodeID As %Library.String = "") As %Library.String
{
}

ClassMethod IsCommentExist(EpisodeID As %Library.String = "") As %Library.Boolean
{
}

ClassMethod IsBillCommentExist(EpisodeID As %Library.String = "", BillRowID As %Library.String = "") As %Library.Boolean
{
}

ClassMethod websysSaveAddComment(compref As %Library.String, id As %Library.String = "", PARREF As %Library.String = "")
{
}

ClassMethod FindClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindFetch ]
{
}

ClassMethod FindExecute(ByRef QHandle As %Library.Binary, EpisodeID As %Library.String = "", BillRowID As %Library.String = "", Mode As %Library.String) As %Library.Status
{
}

ClassMethod FindFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = FindExecute ]
{
}

Query Find(EpisodeID As %String, BillRowID As %String, Mode As %String) As %Library.Query(CONTAINID = 1, ROWSPEC = "CMTID,CMTComments:%String,CMTDate:%Date,CMTTime:%Time,CMTHosp:%String,CMTUser:%String,CMTFutureDate:%Date,CMTLastUpdateDate:%Date,CMTLastUpdateTime:%Time,CMTLastUpdateUser:%String,CMTLastUpdateHosp:%String,CMTLastUpdateUserID:%String")
{
}

Query FindComments(EpisodeID As %String) As %Library.SQLQuery(CONTAINID = 1, ROWSPEC = "CMTID,CMTComments:%String,CMTDate:%Date,CMTTime:%Time,CMTHosp:%String,CMTUser:%String,CMTFutureDate:%Date")
{
SELECT CMT_RowId, CMT_Comments, CMT_Date,  CMT_Time, CMT_Hospital_DR->HOSP_Desc, CMT_User_DR->SSUSR_Name, CMT_FutureDate
FROM SQLUser.PA_AdmComments
WHERE (CMT_ParRef = :EpisodeID)
ORDER BY CMT_Date desc, CMT_Time desc
}

}
