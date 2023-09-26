Class web.SSHL7 Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 505;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "HL7_Code";

Parameter SQLDESCRIPTION = "HL7_RowId";

Parameter SQLROWID = "HL7_RowId";

Property dummy As %Library.String(TRUNCATE = 1);

/// Author: Bradley Collins
/// Purpose: To list a series of HL7 Protocols based on Code, Name of Facility or Remote Facility Name
/// Date: 29/10/2001
ClassMethod FindClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindFetch ]
{
}

/// Author: Bradley Collins
/// Purpose: To list a series of HL7 Protocols based on Code, Name of Facility or Remote Facility Name
/// Date: 29/10/2001
ClassMethod FindExecute(ByRef QHandle As %Library.Binary, HL7Code As %Library.String, HL7NameOfFacility As %Library.String, HL7RemoteFacilityName As %Library.String) As %Library.Status
{
}

/// Author: Bradley Collins
/// Purpose: To list a series of HL7 Protocols based on Code, Name of Facility or Remote Facility Name
/// Date: 29/10/2001
ClassMethod FindFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = FindExecute ]
{
}

ClassMethod FindLinksData(Code As %Library.String = "") As %Library.String
{
}

ClassMethod ListMsgLogClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = ListMsgLogExecute ]
{
}

/// Log 39327 - AI - 15-10-2003 : Add seq to the input parameters - has a value when called from component OEHL7Messages.List via the "Trace Link" link.
/// Log 42406 - AI - 19-02-2004 : Add sttime, enddate, and endtime to the input parameters.
/// Log 45049 - AI - 26-08-2004 : Add optstr - created in sshl7logframes.csp.
ClassMethod ListMsgLogExecute(ByRef qHandle As %Binary, code As %String = "", date As %String = "", seq As %String = "", sttime As %String = "", enddate As %String = "", endtime As %String = "", optstr As %String = "", searchstr As %String = "") As %Status
{
}

ClassMethod ListMsgLogFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = ListMsgLogExecute ]
{
}

ClassMethod ListMsgLogExecuteOLD(ByRef qHandle As %Binary, code As %String = "", date As %String = "", seq As %String = "", sttime As %String = "", enddate As %String = "", endtime As %String = "", optstr As %String = "", searchstr As %String = "") As %Status
{
}

/// Invoked after websysSave - can be used to provide extra websysSave functionality while keeping the default websysSave behaviour.
ClassMethod websysAfterSave(compref As %String, ByRef id As %String, new As %Boolean) As %Boolean
{
}

/// Invoked before websysSave - can be used to cancel the save.<br>
ClassMethod websysBeforeSave(compref As %String, ByRef id As %String) As %Boolean
{
}

/// ab 9.08.05 54652
ClassMethod websysSaveLog(compref As %String, id As %String)
{
}

ClassMethod websysSaveReplay(compref As %String, id As %String)
{
}

/// Log 39327 - AI - 13-10-2003 : From $$GetMsg^zsb. Called from component SSHL7Log.Edit, items "message" and "messageHEX".
/// 		Fifth input parameter "inx" replaced as a $o function, as we want all messages of the same (Date,Seq,Type) grouped together.
ClassMethod GetMessage(Code As %String, Date As %String, Seq As %String, Type As %String) As %String
{
}

/// Log 40012 - AI - 27-10-2003 : From $$StrToHex^zsb. Called from component SSHL7Log.Edit, items "message" and "messageHEX".
ClassMethod StrToHex(str As %String) As %String
{
}

/// Log 40012 - AI - 27-10-2003 : From $$HexToStr^zsb. Called from component SSHL7Log.Edit, items "message" and "messageHEX".
ClassMethod HexToStr(hex As %String) As %String
{
}

/// cjb 25/08/2005 54651 - called from reload1 button on SSHL7Log.Edit
ClassMethod reload()
{
}

/// Log 40012 - AI - 27-10-2003 : From $$StrSection^zsb. Called from component SSHL7Log.Edit, items "message" and "messageHEX".
/// Log 54649 - AI - 25-08-2005 : Add includeBreaks logic, because we now change between Hex and non-Hex formats after modifying the text.
ClassMethod StrSection(str As %String, noChars As %Integer, includeBreaks As %String = "") As %String
{
}

/// Log 40012 - AI - 27-10-2003 : From $$HexSection^zsb. Called from component SSHL7Log.Edit, items "message" and "messageHEX".
ClassMethod HexSection(Hex As %String, noChars As %Integer) As %String
{
}

/// Log 56732 - ML - 20/12/2005 : Setup Wizard created for HL7 interfaces via Interface Workbench
ClassMethod SetupWizard(SSIntRowId As %String)
{
}

/// ab 11.06.06 57695
ClassMethod ExternalValidation(compref) As %String
{
}

Query Find(HL7Code As %Library.String, HL7NameOfFacility As %Library.String, HL7RemoteFacilityName As %Library.String) As %Library.Query(CONTAINID = 1, ROWSPEC = "ID, Code:%String, NameOfFacility:%String, RemoteFacilityName:%String")
{
}

/// Log 39327 - AI - 15-10-2003 : Add seq to the input parameters - has a value when called from component OEHL7Messages.List via the "Trace Link" link. Also add output field rej.
/// Log 42406 - AI - 19-02-2004 : Add sttime, enddate, and endtime to the input parameters.
/// Log 45047 - AI - 13-09-2004 : Add searchstr parameter. Set up in sshl7logframes.csp.
Query ListMsgLog(code As %String = "", date As %String = "", seq As %String = "", sttime As %String = "", enddate As %String = "", endtime As %String = "", optstr As %String = "", searchstr As %String = "") As %Query(ROWSPEC = "date:%String,type:%String,msg:%String,seq:%String,inx:%String,time:%String,direction:%String,rej:%String")
{
}

}
