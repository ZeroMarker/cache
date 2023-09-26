Class web.EPVisitActions Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Property dummy As %String(TRUNCATE = 1);

ClassMethod ShowActions(PatientID As %String, LabEpisodeID As %String, PlacerID As %String, OrderIDs As %String, OtherTestSetCodes As %String, Timing As %String, ActionFilter As %String, EntryMode As %String) As %Boolean
{
}

ClassMethod ActionMessagesRequired(PatientID As %String, OrderIDs As %String, ByRef OtherTestSetCodes As %String, Age As %String, SexCode As %String, Timing As %String, UserCode As %String, MRN As %String, ActionFilter As %String) As %Boolean
{
}

ClassMethod GetOrderString(LabEpisodeID As %String, PlacerID As %String, Timing As %String, ActionFilter As %String) As %String
{
}

ClassMethod AutomaticActionsAdd(ActionBuffer As %String, ByRef OtherTestSetCodes As %String, Age As %String, SexCode As %String, Timing As %String, UserCode As %String, MRN As %String, ActionFilter As %String, EntryMode As %String, ByRef TestsAdded As %String, ByRef OrdersAdded As %String) As %Boolean
{
}

ClassMethod OrderActionCheck(TestSetCode As %String, LabEpisodeID As %String, ByRef OtherTestSetCodes As %String, Age As %String, SexCode As %String, Timing As %String, UserCode As %String, MRN As %String, ActionFilter As %String, EntryMode As %String, ByRef TestsAdded As %String, ByRef OrdersAdded As %String, orderid As %String) As %Boolean
{
}

ClassMethod AddOrder(ParentOrderID As %String, ByRef OtherTestSetCodes, testtoadd As %String, LabEpisodeID As %String, EntryMode As %String)
{
}

ClassMethod BuildOrderEntryBuffer(OrderBuffer As %String, OrdersAdded As %String) As %Boolean
{
}

ClassMethod websysSaveActions(id As %String, compref As %String) As %Boolean
{
}

ClassMethod FindActionsForOrdersClose(ByRef QHandle As %Binary) As %Status [ PlaceAfter = FindActionsForOrdersExecute ]
{
}

ClassMethod FindActionsForOrdersExecute(ByRef QHandle As %Binary, ActionBuffer As %String, Timing As %String, PatientID As %String) As %Status
{
}

ClassMethod FindActionsForOrdersFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindActionsForOrdersExecute ]
{
}

Query FindActionsForOrders(ActionBuffer As %String, Timing As %String, PatientID As %String) As %Query(ROWSPEC = "ID:%String,LabEpisodeID:%String,TestID:%String,OrderID:%String,OrderDesc:%String,TestSetCode:%String,ActionMessage:%String,ActionTypeDesc:%String,ActionType:%String,ActionTest:%String,ActionTestSyn:%String,ActionTestDesc:%String,ActionField:%String,ActionData:%String,MRNHidden,AgeHidden,SexCodeHidden,PAPERAge,PAPERSexDR,PAPERTitleDR,PAPERName,PAPERName2,PAPERName3")
{
}

}
