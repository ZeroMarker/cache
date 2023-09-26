Include webimport

IncludeGenerator webimport

Class web.PAQuestionnaire Extends (%Library.RegisteredObject, websys.Abstract) [ Not Abstract, ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 119;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Property dummy As %String(TRUNCATE = 1);

ClassMethod websysInsert(PatientID As %Library.String, QuestionnaireID As %Library.String, EpisodeID As %Library.String, UserID As %Library.String) As %Library.String
{
}

Parameter SQLCODE = "QUE_RowId";

Parameter SQLDESCRIPTION = "QUE_RowId";

Parameter SQLROWID = "QUE_RowId";

/// KM 24-Jun-2001
Query ListEPR(PatientID As %Library.String, GrpSetCarPrv As %Library.String, QuestionnaireID As %Library.String) As %Library.SQLQuery(CONTAINID = 1, ROWSPEC = "ID,Date,Time,QuestionnaireID,QuestionnaireDesc,Document,Score,User")
{
SELECT QUE_Rowid,QUE_Date,QUE_Time,
     QUE_UserWindow_DR,
     QUE_UserWindow_DR->WIN_Desc,
     QUE_UserWindow_DR->WIN_Document,
     QUE_ComputedScore,
     QUE_User_DR->SSUSR_Name
FROM PA_Questionnaire
WHERE QUE_ParRef = :PatientID
AND ((:GrpSetCarPrv [ (','_%INTERNAL(QUE_User_DR->SSUSR_CareProv_DR->CTPCP_CarPrvTp_DR)_',')) 
OR :GrpSetCarPrv is NULL)
AND (:QuestionnaireID = QUE_UserWindow_DR OR :QuestionnaireID IS NULL)
}

}
