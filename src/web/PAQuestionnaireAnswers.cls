Include webimport

IncludeGenerator webimport

Class web.PAQuestionnaireAnswers Extends (%Library.RegisteredObject, websys.Abstract) [ Not Abstract, ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 118;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Property dummy As %String(TRUNCATE = 1);

ClassMethod GetQuestionAnswer(PAQuestionID As %Library.String, ControlID As %Library.String) As %Library.String
{
}

ClassMethod websysInsert(PAQuestID As %Library.String, QuestionnaireID As %Library.String)
{
}

Parameter SQLCODE = "ANS_RowId";

Parameter SQLDESCRIPTION = "ANS_RowId";

Parameter SQLROWID = "ANS_RowId";

Query FindByQuestionnaire(qid As %String) As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID,Text:%String,ControlType:%String,ANSValue:%String,CONValues:%String")
{
SELECT ANS_Rowid,ANS_UserWinControl_DR->CON_Text,ANS_UserWinControl_DR->CON_ControlType,ANS_Value,ANS_UserWinControl_DR->CON_Values
FROM PA_QuestionnaireAnswers
WHERE ANS_ParRef = :qid
}

}
