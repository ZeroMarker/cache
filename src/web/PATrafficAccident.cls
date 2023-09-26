Include webimport

IncludeGenerator webimport

Class web.PATrafficAccident Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 391;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "TRF_AccidentCode_DR";

Parameter SQLDESCRIPTION = "TRF_RowId";

Parameter SQLROWID = "TRF_RowId";

Property dummy As %Library.String(TRUNCATE = 1);

ClassMethod DeleteEpisodeRef(id As %Library.String = "", PatientID As %Library.String = "")
{
}

ClassMethod DisplayPayorLastAdm(PatientID As %String = "", TrafficID As %String = "") As %String
{
}

/// cjb 13/08/2004 45202 - get the contact from PATrafficAccidentContact not PAAdmInsurance
ClassMethod GetAssignBill(trf As %String = "") As %String
{
}

ClassMethod GetAssignBillOLD(EpisodeID As %String = "", payor As %String = "") As %String
{
}

ClassMethod GetCompensablePayor(EpisodeID As %String = "") As %Library.String
{
}

ClassMethod TrafficAccidentFindClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = TrafficAccidentFindFetch ]
{
}

ClassMethod TrafficAccidentFindExecute(ByRef QHandle As %Library.Binary, PatientID As %Library.String) As %Library.Status
{
}

ClassMethod TrafficAccidentFindFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = TrafficAccidentFindExecute ]
{
}

ClassMethod setPAADM(ID As %Library.String)
{
}

/// Invoked before websysSave - can be used to cancel the save.
ClassMethod websysBeforeSave(compref As %String, ByRef id As %String) As %Boolean
{
}

ClassMethod websysSave(compref As %String, id As %String)
{
}

ClassMethod ValidateCodeTableDates(compid As %String, id As %String) As %String
{
}

ClassMethod zzzTrafficAccidentFindClose(QHandle As %Library.Binary) As %Library.Status
{
}

ClassMethod zzzTrafficAccidentFindExecute(ByRef QHandle As %Library.Binary, TSRTITM As %Library.String, TSRTORD As %Library.String, PatientID As %Library.String) As %Library.Status
{
}

ClassMethod zzzTrafficAccidentFindFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status
{
}

Query TrafficAccidentFind(PatientID As %String) As %Library.Query(CONTAINID = 0, ROWSPEC = "ID:%String,TRFAccidentDate:%String,TRFAccidentTime:%String,TRFPersonDR:%String,TRFInjury:%String,TRFVehInsPolicy:%String")
{
}

Query TrafficAccidentFindDetails(PatientID As %String) As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "ID:%String,TRFAccidentDate:%String,TRFAccidentTime:%String,TRFPersonDR:%String,TRFInjury:%String,TRFVehInsPolicy:%String")
{
SELECT TRF_RowId, TRF_AccidentDate, TRF_AccidentTime, TRF_PERSON_DR, TRF_Injury, TRF_VehInsPolicy
FROM SQLUser.PA_TrafficAccident
WHERE (TRF_PERSON_DR = :PatientID)
}

}
