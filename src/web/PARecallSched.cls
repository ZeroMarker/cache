Class web.PARecallSched Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 156;

ClassMethod webGenerate() As %String
{
}

ClassMethod GetSchedDescription(SchedID As %String, SchemaID As %String) As %String
{
}

ClassMethod FindActiveRSClose(ByRef QHandle As %Binary) As %Status [ PlaceAfter = FindActiveRSExecute ]
{
}

ClassMethod FindActiveRSExecute(ByRef QHandle As %Binary, PatientID As %String) As %Status
{
}

ClassMethod FindActiveRSFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindActiveRSExecute ]
{
}

ClassMethod FindSchedItemsClose(ByRef QHandle As %Binary) As %Status [ PlaceAfter = FindSchedItemsExecute ]
{
}

ClassMethod FindSchedItemsExecute(ByRef QHandle As %Binary, ID As %String, SchemaID As %String) As %Status
{
}

ClassMethod FindSchedItemsFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindSchedItemsExecute ]
{
}

Query FindActiveRS(PatientID As %String) As %Query(CONTAINID = 1, ROWSPEC = "SchedID:%String,RecallSched:%String,Type:%String,Status:%String,StartDate:%Date,Hosp:%String,Loc:%String,Desc:%String")
{
}

Query FindSchedItems(ID As %String, SchemaID As %String) As %Query(CONTAINID = 1, ROWSPEC = "SchedItemID:%String,ItemCount:%String,Offset:%String,ApptDR:%String,ApptDate:%String,ApptTime:%String,ApptService:%String,ApptStatus:%String,StatusColour:%String,WLDR:%String,WLType:%String,WLStatus:%String,WLPrio:%String,OrdersLink:%String")
{
}

}
