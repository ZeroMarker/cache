Class web.RBNotAvail Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 231;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

/// This routine returns "F","P" or "N" depending on whether the slot is fully, 
/// partially or not blocked by a not available
ClassMethod IsSlotBlocked(SlotID As %String = "") As %String
{
}

Parameter SQLCODE = "NA_RowId";

Parameter SQLDESCRIPTION = "NA_RowId";

Parameter SQLROWID = "NA_RowId";

Property dummy As %Library.String(TRUNCATE = 1);

ClassMethod GetConflictMess(ConflictMsg As %Library.String = "^^", fdate As %Library.String, ftime As %Library.String, tdate As %Library.String, ttime As %Library.String, Cid As %Library.String = "") As %Library.String
{
}

/// Log 58511 - GC - 01-06-2006: Checks if atleast ONE of the appointments has status "Arrived"
ClassMethod HasArrivedPatients(ConflictMsg As %Library.String = "^^") As %Library.String
{
}

ClassMethod IsAvailable(Res As %String = "", date As %String = "", time As %String = "", duration As %String = "") As %Library.Boolean
{
}

/// Invoked before websysSave - can be used to cancel the save.<br>
ClassMethod websysBeforeSave(compref As %String, ByRef id As %String) As %Boolean
{
}

ClassMethod websysAfterSave(compref As %String, ByRef id As %String, new As %Boolean) As %Boolean
{
}

ClassMethod websysDeleteNotAvail(compref As %Library.String, ByRef id As %Library.String) As %Library.Boolean
{
}

ClassMethod IsInSesson(resID As %String = "", date As %String = "", stime As %String = "", etime As %String = "") As %Library.Boolean
{
}

ClassMethod GetConflictString(ResID As %String = "", fdate As %String = "", ftime As %String = "", tdate As %String = "", ttime As %String = "", Cid As %String = "") As %Library.Boolean
{
}

Query BuildStrO(TSRTITM As %Library.String, TSRTORD As %Library.String, ResID As %Library.String, dateFROM As %Library.Date, timeFROM As %Library.Time, dateTO As %Library.Date, timeTO As %Library.Time, notavailid As %Library.String) As %Library.Query(CONTAINID = 0, ROWSPEC = "Type:%String,Details:%String,StartDate:%Date,StartTime:%Time,EndDate:%Date,EndTime:%Time")
{
}

/// Default implementation of LookUp Query.
ClassMethod BuildStrOClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = BuildStrOFetch ]
{
}

/// Default implementation of LookUp Query.
ClassMethod BuildStrOExecute(ByRef QHandle As %Library.Binary, TSRTITM As %String = "", TSRTORD As %Library.String = "", ResID As %Library.String = "", StartDate As %Library.Date = "", StartTime As %Library.Time = "", EndDate As %Library.Date = "", EndTime As %Library.Time = "", NotAvailID As %Library.String = "") As %Library.Status [ PlaceAfter = GetIdFromCodeOrDescription ]
{
}

/// Default implementation of LookUp Query.
ClassMethod BuildStrOFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = BuildStrOExecute ]
{
}

}
