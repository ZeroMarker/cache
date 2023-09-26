Class web.OEHL7Messages Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 231;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "HL7_TestCode";

Parameter SQLDESCRIPTION = "HL7_RowId";

Parameter SQLROWID = "HL7_RowId";

Property dummy As %Library.String(TRUNCATE = 1);

/// Log 26323 - AI - 29-07-2002 : Look up Broker for HL7 Link ID or Description (same value).
/// I have used this query in Component OEHL7Messages.Find.
/// 
ClassMethod LookUpBrokerHL7Link(itmjs As %Library.String = "", itmjsex As %Library.String = "", Desc As %Library.String = "") As %Library.Boolean
{
}

ClassMethod LookUpHL7LinkClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = LookUpHL7LinkFetch ]
{
}

/// Log 26323 - AI - 29-07-2002 : Look up HL7 Link ID.
/// I have used this query in Component OEHL7Messages.Find.
/// 
ClassMethod LookUpHL7LinkExecute(ByRef QHandle As %Library.Binary, link As %Library.String) As %Library.Status
{
}

ClassMethod LookUpHL7LinkFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = LookUpHL7LinkExecute ]
{
}

Query ListRejection(LinkID As %String = "", DateRecFrom As %String = "", DateRecTo As %String = "", SearchString As %String = "", HL7RejectionType As %String = "", ViewUnAck As %String = "", OEHLRowId As %String = "") As %Query(ROWSPEC = "HL7_RowId:%String,HL7_LinkID:%String,HL7_RegNo:%String,HL7_ExternalReqNo:%String,HL7_PatName:%String,HL7_PatDOB:%String,HL7_Sex:%String,HL7_TestCode:%String,HL7_DateReceived:%String,HL7_TimeReceived:%String,HL7_DateAcknow:%String,HL7_TimeAcknow:%String,HL7_ReasonForFailure:%String,HL7_FillerNumber:%String,HL7_MessageType:%String,HL7_Trace_DR:%String,SSUSR_Initials:%String,SSUSR_Name:%String")
{
}

ClassMethod ListRejectionExecute(ByRef qHandle As %Binary, LinkID As %String = "", DateRecFrom As %String = "", DateRecTo As %String = "", SearchString As %String = "", HL7RejectionType As %String = "", ViewUnAck As %String = "", OEHLRowId As %String = "") As %Status
{
}

ClassMethod ListRejectionFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = ListRejectionExecute ]
{
}

ClassMethod ListRejectionClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = ListRejectionFetch ]
{
}

ClassMethod websysSave(compref As %Library.String, id As %Library.String)
{
}

/// Log 26323 - AI - 29-07-2002 : Look up HL7 Link ID.
/// I have used this query in Component OEHL7Messages.Find.
/// 
Query LookUpHL7Link(link As %String) As %Library.Query(CONTAINID = 0, ROWSPEC = "linkcode:%String,linkdesc:%String")
{
}

/// Invoked before websysSave - can be used to cancel the save.<br>
ClassMethod websysBeforeSave(compref As %String, ByRef id As %String) As %Boolean
{
}

}
