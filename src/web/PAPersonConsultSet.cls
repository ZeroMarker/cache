Include webimport

IncludeGenerator webimport

Class web.PAPersonConsultSet Extends (%Library.RegisteredObject, websys.Abstract) [ Not Abstract, ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 148;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "CONSET_RowId";

Parameter SQLDESCRIPTION = "CONSET_RowId";

Parameter SQLROWID = "CONSET_RowId";

ClassMethod GetPatConsultSetsExecute(QHandle As %Library.Binary, EpisodeID As %Library.String = "", SearchConsultCategoryID As %Library.String = "", SearchSubCatID As %Library.String = "") As %Library.Status
{
}

ClassMethod GetPatConsultSetsFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = GetPatConsultSetsExecute ]
{
}

ClassMethod GetPatConsultSetsClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = GetPatConsultSetsFetch ]
{
}

ClassMethod LookUpPatConsultCatsExecute(QHandle As %Library.Binary, EpisodeID As %Library.String, val As %Library.String = "", FromBroker As %Library.Boolean = 0) As %Library.Status
{
}

ClassMethod LookUpPatConsultCatsFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = LookUpPatConsultCatsExecute ]
{
}

ClassMethod LookUpPatConsultCatsClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = LookUpPatConsultCatsFetch ]
{
}

ClassMethod LookUpBrokerPatConsultCats(itmjs As %Library.String = "", itmjsex As %Library.String = "", EpisodeID As %Library.String = "", val As %Library.String = "") As %Library.Boolean
{
}

ClassMethod LookUpPatConsDiagnosExecute(QHandle As %Library.Binary, EpisodeID As %Library.String, val As %Library.String = "", FromBroker As %Library.Boolean = 0) As %Library.Status
{
}

ClassMethod LookUpPatConsDiagnosFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = LookUpPatConsDiagnosExecute ]
{
}

ClassMethod LookUpPatConsDiagnosClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = LookUpPatConsDiagnosFetch ]
{
}

ClassMethod LookUpBrokerPatConsDiagnos(itmjs As %Library.String = "", itmjsex As %Library.String = "", EpisodeID As %Library.String = "", val As %Library.String = "") As %Library.Boolean
{
}

ClassMethod LookUpConsChiefComplaintExecute(QHandle As %Library.Binary, EpisodeID As %Library.String, val As %Library.String = "", FromBroker As %Library.Boolean = 0) As %Library.Status
{
}

ClassMethod LookUpConsChiefComplaintFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = LookUpConsChiefComplaintExecute ]
{
}

ClassMethod LookUpConsChiefComplaintClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = LookUpConsChiefComplaintFetch ]
{
}

ClassMethod LookUpBrokerConsChiefComplaint(itmjs As %Library.String = "", itmjsex As %Library.String = "", EpisodeID As %Library.String = "", val As %Library.String = "") As %Library.Boolean
{
}

ClassMethod LookUpPatConsCareProvExecute(QHandle As %Library.Binary, EpisodeID As %Library.String, val As %Library.String = "", FromBroker As %Library.Boolean = 0) As %Library.Status
{
}

ClassMethod LookUpPatConsCareProvFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = LookUpPatConsCareProvExecute ]
{
}

ClassMethod LookUpPatConsCareProvClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = LookUpPatConsCareProvFetch ]
{
}

ClassMethod LookUpBrokerPatConsCareProv(itmjs As %Library.String = "", itmjsex As %Library.String = "", EpisodeID As %Library.String = "", val As %Library.String = "") As %Library.Boolean
{
}

ClassMethod LookUpPatConsSubCatExecute(QHandle As %Library.Binary, EpisodeID As %Library.String, val As %Library.String = "", parref As %Library.String = "", FromBroker As %Library.Boolean = 0) As %Library.Status
{
}

ClassMethod LookUpPatConsSubCatFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = LookUpPatConsSubCatExecute ]
{
}

ClassMethod LookUpPatConsSubCatClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = LookUpPatConsSubCatFetch ]
{
}

ClassMethod LookUpBrokerPatConsSubCat(itmjs As %Library.String = "", itmjsex As %Library.String = "", EpisodeID As %Library.String = "", val As %Library.String = "", parref As %Library.String = "") As %Library.Boolean
{
}

Query GetPatConsultSets(EpisodeID As %Library.String = "", SearchConsultCategoryID As %Library.String = "", SearchSubCatID As %Library.String = "") As %Library.Query(CONTAINID = 1, ROWSPEC = "ConsultSetDR,PatientID,ConsultSetDesc,ConsultSetCat,SubCat,HIDDEN")
{
}

Query LookUpPatConsultCats(EpisodeID As %Library.String, val As %Library.String = "") As %Library.Query(CONTAINID = 1, ROWSPEC = "Desc,HIDDEN,Code")
{
}

Query LookUpPatConsDiagnos(EpisodeID As %Library.String, val As %Library.String = "") As %Library.Query(CONTAINID = 1, ROWSPEC = "Desc,HIDDEN,Code,Type")
{
}

Query LookUpConsChiefComplaint(EpisodeID As %Library.String, val As %Library.String = "") As %Library.Query(CONTAINID = 1, ROWSPEC = "Desc,HIDDEN,Code,SNOMED")
{
}

Query LookUpPatConsCareProv(EpisodeID As %Library.String, val As %Library.String = "") As %Library.Query(CONTAINID = 1, ROWSPEC = "Desc,HIDDEN,Code")
{
}

Query LookUpPatConsSubCat(EpisodeID As %Library.String, val As %String = "", parref As %String = "") As %Library.Query(CONTAINID = 1, ROWSPEC = "Description:%String,HIDDEN:%String,Code:%String,HIDDEN:%String,Category:%String")
{
}

}
