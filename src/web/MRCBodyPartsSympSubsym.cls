Include webimport

IncludeGenerator webimport

Class web.MRCBodyPartsSympSubsym Extends (%Library.RegisteredObject, websys.Abstract) [ Not Abstract, ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 122;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "SUBS_Code";

Parameter SQLDESCRIPTION = "SUBS_Desc";

Parameter SQLROWID = "SUBS_RowId";

Property dummy As %String(TRUNCATE = 1);

ClassMethod LookUpBySymptomBroker(itmjs As %Library.String = "", itmjsex As %Library.String = "", Desc As %String = "", Symp As %String = "", Part As %String = "") As %Boolean
{
}

ClassMethod GetIdFromCodeOrDescWithParent(val As %String = "", val2 As %String = "", val3 As %String = "") As %String
{
}

ClassMethod LookUpBySymptomClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = LookUpBySymptomFetch ]
{
}

ClassMethod LookUpBySymptomExecute(ByRef QHandle As %Library.Binary, Desc As %Library.String = "", Symp As %Library.String = "", Part As %Library.String = "") As %Library.Status
{
}

ClassMethod LookUpBySymptomFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = LookUpBySymptomExecute ]
{
}

Query LookUpBySymptom(Desc As %Library.String, Symp As %Library.String, Part As %Library.String) As %Library.Query(CONTAINID = 1, ROWSPEC = "SubSymptom:%String,Symptom:%String,BodyPart:%String,HIDDEN:%String")
{
}

}
