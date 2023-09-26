Class web.SSInterface Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 335;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "INT_Code";

Parameter SQLDESCRIPTION = "INT_Desc";

Parameter SQLROWID = "INT_RowId";

Property dummy As %Library.String(TRUNCATE = 1);

/// Log 39326 - AI - 24-09-2003 : Method to firstly delete the SSHL7 entries for the Interface. Then deletes the Interface itself.
/// Log 46777 - AI - 04-11-2004 : Replaced INTHL7DR with INTDataType in the parameters. No longer using INTHL7DR - using INTDataType="H" instead.
ClassMethod DeleteInterface(INTRowId As %String = "", INTDataType As %String = "") As %String
{
}

ClassMethod DeleteInterfaceXML(intcode As %String = "", INTDataType As %String = "")
{
}

ClassMethod FindAllClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindAllFetch ]
{
}

/// cjb 05/03/2005 51198 - taken a load of sql out of this query and replaced with cache to speed it up
ClassMethod FindAllExecute(ByRef QHandle As %Library.Binary, refresh As %Library.String = "") As %Library.Status
{
}

/// cjb 05/03/2005 51198 - taken a load of sql out of this query and replaced with cache to speed it up
ClassMethod FindAllFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = FindAllExecute ]
{
}

/// Log 42529 - AI - 22-03-2004 : Returns a list of all SSInterface INTCodes for the javascript to check for duplicates.
ClassMethod GetAllInterfaceCodes() As %String
{
}

/// Log 45359 - AI - 11-08-2004 : Returns a list of the six (6) Action... entries for the given Interface.
/// 							  Called by "actionlist" item on component SSInterface.EditErrorSettings.
ClassMethod GetAllActionsForInterface(int As %String = "") As %String
{
}

/// Log 42529 - AI - 08-03-2004 : LookUp Broker to return extra fields for the javascript to populate the screen's fields.
ClassMethod LookUpForCopyBroker(itmjs As %String = "", itmjsex As %String = "", val As %String = "") As %Boolean
{
}

/// Log 42529 - AI - 11-03-2004 : LookUp to return extra fields for the javascript to populate the screen's fields.
ClassMethod LookUpForCopyClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = LookUpForCopyFetch ]
{
}

/// Log 42529 - AI - 11-03-2004 : LookUp to return extra fields for the javascript to populate the screen's fields.
ClassMethod LookUpForCopyExecute(ByRef QHandle As %Library.Binary, val As %String = "") As %Library.Status
{
}

/// Log 42529 - AI - 11-03-2004 : LookUp to return extra fields for the javascript to populate the screen's fields.
ClassMethod LookUpForCopyFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = LookUpForCopyExecute ]
{
}

/// Invoked after websysSave - can be used to provide extra websysSave functionality while keeping the default websysSave behaviour.
ClassMethod websysAfterSave(compref As %String, ByRef id As %Library.String, new As %Boolean) As %Boolean
{
}

ClassMethod websysBeforeDelete(id As %Library.String)
{
}

/// Invoked before websysSave - can be used to cancel the save.<br>
ClassMethod websysBeforeSave(compref As %String, ByRef id As %String) As %Boolean
{
}

/// Delete an instance - this is provided as a wrapper for %DeleteId functionality.
ClassMethod websysDelete(id As %Library.String) [ CodeMode = generator ]
{
}

/// Log 46777 - AI - 04-11-2004 : Removed the INTHL7DR from piece 7 of the Row Definition.
Query FindAll(refresh As %Library.String) As %Library.Query(CONTAINID = 1, ROWSPEC = "INTRowId,INTCode,INTDesc,INTDataDirection,INTDataType,INTInterfaceType,MONRowId,MONStatus,MONDateLastMessage,MONTimeLastMessage,MONMessageCount,MONNoInQueue,MONDateLastRejected,MONTimeLastRejected,MONNoOfUnackRejections,MONActive,MONTimeStarted,MONDateStarted,isIntStarted,HostName,HostPort")
{
}

Query LookUpForCopy(val As %String = "") As %Library.Query(CONTAINID = "", ROWSPEC = "code:%String,desc:%String,HIDDEN:%String")
{
}

Query VBFindLE(desc As %Library.String) As %Library.Query(CONTAINID = 1, ROWSPEC = "ID,INTDesc:%Library.String")
{
}

Query VBFindLESimple(desc As %Library.String) As %Library.SQLQuery(CONTAINID = 1, ROWSPEC = "ID,INTDesc:%Library.String")
{
SELECT INT_RowId, INT_Desc
FROM SQLUser.SS_Interface
WHERE (INT_Desc %STARTSWITH :desc)
ORDER BY INT_Desc
}

ClassMethod VBFindLEClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = VBFindLEFetch ]
{
}

ClassMethod VBFindLEExecute(ByRef QHandle As %Library.Binary, desc As %Library.String) As %Library.Status
{
}

ClassMethod VBFindLEFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = VBFindLEExecute ]
{
}

}
