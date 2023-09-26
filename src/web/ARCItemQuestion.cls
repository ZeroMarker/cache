Class web.ARCItemQuestion Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 454;

Parameter SQLDATEFROM = "QUES_DateFrom";

Parameter SQLDATETO = "QUES_DateTo";

Parameter SQLCODE = "QUES_RowId";

Parameter SQLDESCRIPTION = "QUES_RowId";

Parameter SQLROWID = "QUES_RowId";

Property dummy As %Library.String(TRUNCATE = 1);

Query FindQuestions(OrderItemID As %String, Age As %String, SexID As %String) As %Library.SQLQuery(CONTAINID = 1, ROWSPEC = "ID,QuestionCode,QuestionDesc,ControlType,Values,QUESMandatory,maxLength,AgeFrom,AgeTo,Sex")
{
SELECT QUES_Question_DR,QUES_Question_DR->QUES_Code,QUES_Question_DR->QUES_Desc,QUES_Question_DR->QUES_ControlType,QUES_Question_DR->QUES_Values,QUES_Mandatory,QUES_Question_DR->QUES_TextLength,QUES_Question_DR->QUES_AgeFrom,QUES_Question_DR->QUES_AgeTo,QUES_Question_DR->QUES_Sex_DR->CTSEX_Desc
FROM SQLUser.ARC_ItemQuestion
WHERE (QUES_ParRef = :OrderItemID)
AND ((QUES_Question_DR->QUES_AgeFrom <= :Age) OR (QUES_Question_DR->QUES_AgeFrom IS NULL) OR(:Age IS NULL))
AND ((QUES_Question_DR->QUES_AgeTo >= :Age) OR (QUES_Question_DR->QUES_AgeTo IS NULL) OR(:Age IS NULL))
AND ((QUES_Question_DR->QUES_Sex_DR = :SexID) OR (QUES_Question_DR->QUES_Sex_DR IS NULL) OR(:SexID IS NULL))
AND ((QUES_DateFrom <= CURRENT_DATE) OR (QUES_DateFrom IS NULL))
AND ((QUES_DateTo >= CURRENT_DATE) OR (QUES_DateTo IS NULL))
}

ClassMethod DisplayQuestions(QCSPFlag As %Library.String = 0)
{
}

/// if using LabTrak -> PatientIDs should be patient rego nums
/// if using external lab system -> PatientIDs ahould be patient rowids
ClassMethod DisplayTestItemResults(PatientIDs As %Library.String = "", QuesID As %Library.String = "")
{
}

/// make sure RowSpec has RowCount as the last item
Query FindAllQuestions(ARCItmMastIDs As %String, PatientID As %String, distinct As %String, NewOrders As %String, EpisodeID As %String) As %Library.Query(CONTAINID = 0, ROWSPEC = "ID,QuestionCode,QuestionDesc,ControlType,Values,Mandatory,maxLength,QuesARCIMDesc,Patients,DefaultAnswer,FldType,DecAllow,PosOnly,Other,DefaultMLAnswer,CurrentAnswer,CurrentMLAnswer,RowCount")
{
}

/// distinct is passed "Y" when updating questions (web.OEOrder.websysSaveAnswers for each distinct order item
ClassMethod FindAllQuestionsExecute(ByRef QHandle As %Library.Binary, ARCItmMastIDs As %Library.String, PatientID As %Library.String, distinct As %Library.String, NewOrders As %Library.String = "", EpisodeID As %Library.String = "") As %Library.Status
{
}

ClassMethod FindAllQuestionsFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = FindAllQuestionsExecute ]
{
}

ClassMethod FindAllQuestionsClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindAllQuestionsFetch ]
{
}

ClassMethod GetDefaultAnswer(ORIRowId As %Library.String, QID As %Library.String) As %Library.String
{
}

ClassMethod GetDefaultMLAnswer(ORIRowId As %Library.String, QID As %Library.String) As %Library.String
{
}

ClassMethod GetCurrentAnswer(ORIRowId As %Library.String, QID As %Library.String, ByRef AnswerID As %Library.String, ByRef Answer As %Library.String, ByRef MLAnswer As %Library.String)
{
}

ClassMethod DrawQuestionLabel(QID As %Library.String = "", RowCount As %Library.String = "", queDesc As %Library.String = "", Mandatory)
{
}

/// ScreenType = A|S where A is for Alert Screen where last answer is defaulted, S is for Summary screen where answer when ordered is defaulted
ClassMethod DrawQuestionControl(QID As %Library.String = "", RowCount As %Library.String = "", ftype As %Library.String = "", ScreenType As %Library.String = "A")
{
}

ClassMethod DrawQuestionOtherML(QID As %Library.String = "", RowCount As %Library.String = "", MLAnswer As %Library.String = "", Answer As %Library.String = "")
{
}

ClassMethod DrawQuestionTestItemRes(QID As %Library.String = "", RowCount As %Library.String = "", applPatIDs As %Library.String = "")
{
}

ClassMethod GetQuestionMultiPatient(ApplPatientIDs As %Library.String = "")
{
}

ClassMethod OEOrderQuestionPresetData(orderlist)
{
}

}
