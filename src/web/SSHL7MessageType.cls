Class web.SSHL7MessageType Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 140;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "HL7MSG_RowId";

Parameter SQLDESCRIPTION = "HL7MSG_RowId";

Parameter SQLROWID = "HL7MSG_RowId";

Property dummy As %Library.String(TRUNCATE = 1);

/// Log 44805 - 17-08-2004 : GetMessages plus the AlsoSendMessage field stored for each.
ClassMethod getAlsoSendMessages(ParRef As %Library.String = "") As %Library.String
{
}

ClassMethod GetMessages(ParRef As %Library.String = "") As %Library.String
{
}

/// Log 44805 - AI - 19-08-2004 : Query definition for Look Up of Also Send Message on SSHL7AlsoSendMessage.Edit.
ClassMethod LookUpForAlsoSendClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = LookUpForAlsoSendFetch ]
{
}

/// Log 44805 - AI - 19-08-2004 : Query definition for Look Up of Also Send Message on SSHL7AlsoSendMessage.Edit.
ClassMethod LookUpForAlsoSendExecute(ByRef QHandle As %Library.Binary, MSGParRef As %Library.String = "", val As %Library.String = "") As %Library.Status
{
}

/// Log 44805 - AI - 19-08-2004 : Query definition for Look Up of Also Send Message on SSHL7AlsoSendMessage.Edit.
ClassMethod LookUpForAlsoSendFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = LookUpForAlsoSendExecute ]
{
}

/// Log 44805 - AI - 19-08-2004 : Broker method for the above.
ClassMethod LookUpForAlsoSendBroker(itmjs As %Library.String = "", itmjsex As %Library.String = "", MSGParRef As %Library.String = "", val As %Library.String = "") As %Library.Boolean
{
}

ClassMethod LookUpForListBoxClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = LookUpForListBoxFetch ]
{
}

ClassMethod LookUpForListBoxExecute(ByRef QHandle As %Library.Binary, ParRef As %Library.String = "") As %Library.Status
{
}

ClassMethod LookUpForListBoxFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = LookUpForListBoxExecute ]
{
}

/// Log 44805 - AI - 19-08-2004 : Method to save the stored selections on SSHL7AlsoSendMessage.Edit.
ClassMethod websysSaveAlsoSendMessages(compref As %Library.String, ParRef As %Library.String = "", selectedMsg As %Library.String = "")
{
}

ClassMethod websysSaveMessages(compref As %Library.String, ParRef As %Library.String = "", selectedMsg As %Library.String = "", Wizard As %Library.String)
{
}

/// Log 44805 - AI - 19-08-2004 : Query definition for Look Up of Also Send Message on SSHL7AlsoSendMessage.Edit.
Query LookUpForAlsoSend(MSGParRef, val) As %Library.Query(CONTAINID = 0, ROWSPEC = "typedesc,type,HIDDEN")
{
}

Query LookUpForListBox(ParRef) As %Library.Query(CONTAINID = 0, ROWSPEC = "type,typedesc")
{
}

}
