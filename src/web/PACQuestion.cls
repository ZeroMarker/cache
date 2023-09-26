Class web.PACQuestion Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 39;

Parameter SQLDATEFROM = "QUES_DateFrom";

Parameter SQLDATETO = "QUES_DateTo";

Parameter SQLCODE = "QUES_Code";

Parameter SQLDESCRIPTION = "QUES_Desc";

Parameter SQLROWID = "QUES_ROWID";

/// returns 1 if the question do not apply (patient fall outside restrictions)
/// returns 0 if the question do apply
/// accepts PatientID as concatenated string of IDs
/// passed by reference applicable Patient IDs - PatientIDs where question applies to
ClassMethod IsPatientQuestionRestricted(PatientIDs As %Library.String, QuesID As %Library.String, ByRef applicPatIDs As %Library.String) As %Library.Boolean
{
}

}
