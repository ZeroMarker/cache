Class web.PACInstrText Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 329;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "INTX_Code";

Parameter SQLDESCRIPTION = "INTX_RowId";

Parameter SQLROWID = "INTX_RowId";

ClassMethod CheckForDuplicateEntry(compref As %Library.String, id As %Library.String) As %Library.Boolean
{
}

ClassMethod FindClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindFetch ]
{
}

/// KK 21/Oct/2002 Log 28991
ClassMethod FindExecute(ByRef QHandle As %Library.Binary, Code As %Library.String = "", Mod1 As %Library.String = "", LT As %Library.String = "", Parag As %Library.String = "", Trust As %Library.String = "", Hosp As %Library.String = "", ModLoc As %Library.String = "", SpecLoc As %Library.String = "", CareProv As %Library.String = "", EpisSubType As %Library.String = "", ARCIM As %Library.String = "", ItemCat As %Library.String = "", ARCInsType As %Library.String = "", ARCSundryDebtor As %Library.String = "", REFPRIDesc As %Library.String = "", LastParams As %Library.String = "") As %Library.Status
{
}

/// KK 21/Oct/2002 Log 28991
ClassMethod FindFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = FindExecute ]
{
}

ClassMethod LookUpLocwithPrinterBroker(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "", repcode As %String = "") As %Library.Boolean
{
}

ClassMethod LookUpLocwithPrinterClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = LookUpLocwithPrinterExecute ]
{
}

ClassMethod LookUpLocwithPrinterExecute(ByRef qHandle As %Binary, val As %String = "", repcode As %String = "") As %Status
{
}

ClassMethod LookUpLocwithPrinterFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = LookUpLocwithPrinterExecute ]
{
}

/// Invoked before websysSave - can be used to cancel the save.<br>
ClassMethod websysBeforeSave(compref As %String, ByRef id As %String) As %Boolean
{
}

/// KK 21/Oct/2002 Log 28991
/// Code,Mod1,LT,Parag,Trust,Hosp,ModLoc,SpecLoc,CareProv,EpisSubType,ARCIM,ItemCat
/// 
Query Find(INTXCode, MODULDesc, LETDesc, INTXParagraph, TRUSTDesc, HOSPDesc, CTLOCDesc, SPCTLOCDesc, CTPCPDesc, SUBTDesc, ARCIMDesc, ARCICDesc, ARCInsType, ARCSundryDebtor, REFPRIDesc, LastParams) As %Library.Query(CONTAINID = 0, ROWSPEC = "ID,TCode,Module,LetterType,Paragraph,Trust,Hospital,ModLocation,SPLocation,CareProvider,EpiSubType,OrderItem,ItemCategory,SPPP,desc,Payor,SundryDebtor,RefPriority,RefStatus,ReasonforRemoval,ReportCode,OfferDesc")
{
}

Query LookUpLocwithPrinter(val As %String = "", repcode As %String = "") As %Query(ROWSPEC = "Desc:%String,HIDDEN:%String,Code:%String,HIDDEN:%String,HIDDEN:%String")
{
}

}
