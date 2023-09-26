Class web.ARCItemCatQuestion Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 59;

Property dummy As %Library.String(TRUNCATE = 1);

Parameter SQLCODE = "QUES_RowId";

Parameter SQLDATEFROM = "QUES_DateFrom";

Parameter SQLDATETO = "QUES_DateTo";

Parameter SQLDESCRIPTION = "QUES_RowId";

Parameter SQLROWID = "QUES_RowId";

Query FindQuestions(OrderSubCat As %String, Age As %String, SexID As %String) As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "ID,QuestionCode,QuestionDesc,ControlType,Values,maxLength,QUESMandatory,AgeFrom,AgeTo,Sex")
{
SELECT QUES_Question_DR,QUES_Question_DR->QUES_Code,QUES_Question_DR->QUES_Desc,QUES_Question_DR->QUES_ControlType,QUES_Question_DR->QUES_Values,QUES_Question_DR->QUES_TextLength,QUES_Mandatory,QUES_Question_DR->QUES_AgeFrom,QUES_Question_DR->QUES_AgeTo,QUES_Question_DR->QUES_Sex_DR->CTSEX_Desc
FROM SQLUser.ARC_ItemCatQuestion
WHERE (QUES_ParRef = :OrderSubCat)
AND ((QUES_Question_DR->QUES_AgeFrom <= :Age) OR (QUES_Question_DR->QUES_AgeFrom IS NULL) OR(:Age IS NULL))
AND ((QUES_Question_DR->QUES_AgeTo >= :Age) OR (QUES_Question_DR->QUES_AgeTo IS NULL) OR(:Age IS NULL))
AND ((QUES_Question_DR->QUES_Sex_DR = :SexID) OR (QUES_Question_DR->QUES_Sex_DR IS NULL) OR(:SexID IS NULL))
}

}
