Class web.RBEvent Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 348;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "EV_RowId";

Parameter SQLDESCRIPTION = "EV_Name";

Parameter SQLROWID = "EV_RowId";

Property dummy As %Library.String(TRUNCATE = 1);

ClassMethod EventCopy(EventID As %Library.String)
{
}

ClassMethod EventNum()
{
}

ClassMethod FindEventApptsClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindEventApptsFetch ]
{
}

ClassMethod FindEventApptsExecute(ByRef QHandle As %Library.Binary, id As %Library.String = "", type As %Library.String = "", parref As %Library.String = "") As %Library.Status
{
}

ClassMethod FindEventApptsFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = FindEventApptsExecute ]
{
}

ClassMethod FindEventsClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindEventsFetch ]
{
}

ClassMethod FindEventsExecute(ByRef QHandle As %Library.Binary, EVNumber As %Library.String = "", EVStatusDR As %Library.String = "", EVName As %Library.String = "", EVTypeDR As %Library.String = "", EVClientTypeDR As %Library.String = "", EVMethodOfConductDR As %Library.String = "", EVAdministratorDR As %Library.String = "") As %Library.Status
{
}

ClassMethod FindEventsFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = FindEventsExecute ]
{
}

/// A function to return the episode for all the arrived patients for an event
ClassMethod GetArrivedEpisodes(EventID As %Library.String = "", EventDate As %Library.Date = "", EventTime As %Library.Time = "") As %Library.String
{
}

ClassMethod LookUpEventForCPClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = LookUpEventForCPFetch ]
{
}

ClassMethod LookUpEventForCPExecute(ByRef QHandle As %Library.Binary, res As %Library.String = "", cp As %Library.String = "", evdesc As %Library.String = "", evdate As %Library.String = "", evtime As %Library.String = "") As %Library.Status
{
}

ClassMethod LookUpEventForCPFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = LookUpEventForCPExecute ]
{
}

ClassMethod websysSave(compref As %String, id As %String)
{
}

ClassMethod BoldLinks(id As %String)
{
}

Query FindEventAppts(id As %String, type As %String, parref As %String) As %Library.Query(CONTAINID = 0, ROWSPEC = "rowid:%String,date,stime,rsvp,arrive,PatientID,EpisodeID")
{
}

Query FindEvents(EVNumber As %Library.String, EVStatusDR As %Library.String, EVName As %Library.String, EVTypeDR As %Library.String, EVClientTypeDR As %Library.String = "", EVMethodOfConductDR As %Library.String, EVAdministratorDR As %Library.String) As %Library.Query(CONTAINID = 0, ROWSPEC = "EV_RowId,EV_Number,EV_Status,EV_Name,EVT_Desc,EV_ClientType,MOC_Desc,CTPCP_Desc,EV_Duration,EV_Venue,EV_MaxNumberOfParticipants,EV_Charge,EV_PreparationTime,EV_PredictedTravelTime,EV_PredictedReviewTime,RES_Desc,EV_ConsultCategoryDR,EV_SubType")
{
}

Query LookUpEventForCP(resource, cp, evdesc, evdate, evtime) As %Library.Query(CONTAINID = 0, ROWSPEC = "desc,date,stime,etime,type")
{
}

}
