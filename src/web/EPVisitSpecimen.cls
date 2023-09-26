Class web.EPVisitSpecimen Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Parameter BUILD = 82;

Property dummy As %Library.String(TRUNCATE = 1);

ClassMethod AutomaticLabCollect(EpisodeID As %Library.String, LabEpis As %Library.String, OrderIDs As %Library.String, Specimens As %Library.String, CollectionDate As %Library.Date, CollectionTime As %Library.Time, loc As %Library.String = "") As %Library.String
{
}

ClassMethod AutomaticLabReceive(LabEpisodeNo As %Library.String = "", OrderIDs As %Library.String = "", datereceived As %Library.Date = "", timereceived As %Library.Time = "", speclist As %Library.String = "") As %Library.String
{
}

/// YC - Auto Collect/Receive is not programmed for external lab - labtrak only
/// 
/// barcodeSpec is the specimen codes to be collected/received with a comma separator. 
/// If no barcodeSpec is passed in we collect the whole labepisode
/// 
/// Called from BarcodeReceive and websysSaveLabOrderReceive
ClassMethod AutoLabCollectReceive(LabEpisodeNo As %String = "", barcodeSpec As %String = "", recloc As %String = "", AutoCollFlag As %String = "N") As %Library.String
{
}

/// Log 57558 YC
ClassMethod BarcodeReceiveBroker(LabEpisodeID, AutoReceive, AutoCollect)
{
}

/// Log 51794 - Add new Auto Receive Function for barcoding
/// Called from EPVisitSpecimen.LabReceiveBarcode.Find
ClassMethod BarcodeReceive() As %Library.String
{
}

ClassMethod CheckForActions(evnt As %Library.String, id As %Library.String)
{
}

/// Log 43788 - AI - 29-07-2004 : New method created to return the date an arcim will be ready.
ClassMethod DateReady(arcim As %Library.String = "", arcimsub As %Library.String = "", loc As %Library.String = "", prio As %Library.String = "", dt As %Library.String = "", tm As %Library.String = "")
{
}

ClassMethod FindLabOrderCollectionClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindLabOrderCollectionFetch ]
{
}

ClassMethod FindLabOrderCollectionExecute(ByRef QHandle As %Library.Binary, LabEpisodeID As %Library.String, loc As %Library.String, ID As %Library.String, StartDate As %Library.String, EndDate As %Library.String) As %Library.Status
{
}

ClassMethod FindLabOrderCollectionFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = FindLabOrderCollectionExecute ]
{
}

ClassMethod FindLabOrderReceiveClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindLabOrderReceiveFetch ]
{
}

ClassMethod FindLabOrderReceiveExecute(ByRef QHandle As %Library.Binary, LabEpisodeID As %Library.String = "", loc As %Library.String = "") As %Library.Status
{
}

ClassMethod FindLabOrderReceiveFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = FindLabOrderReceiveExecute ]
{
}

ClassMethod GetOrderSpecDetails(order As %Library.String = "", itm As %Library.String = "", ByRef TestSpecList As %Library.String, ByRef errormsg As %Library.String, ByRef alltests As %Library.String, ByRef allspecs As %Library.String) As %Library.String
{
}

ClassMethod GetPatientLocation(EpisodeID As %Library.String = "") As %Library.String
{
}

ClassMethod FindTestSet(arcim As %Library.String = "", epid As %Library.String = "", recloc As %Library.String = "") As %Library.String
{
}

ClassMethod LookUpSpecimenBroker(itmjs As %Library.String, itmjsex As %Library.String, val As %Library.String, Arg1 As %Library.String) As %Library.Status [ PlaceAfter = LookUpSpecimenFetch ]
{
}

ClassMethod LookUpSpecimenClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = LookUpSpecimenFetch ]
{
}

ClassMethod LookUpSpecimenExecute(ByRef QHandle As %Library.Binary, Order As %String, arcim As %Library.String, EpID As %Library.String, ResultProfile As %String, recloc As %String = "") As %Library.Status
{
}

ClassMethod LookUpSpecimenFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = LookUpSpecimenExecute ]
{
}

ClassMethod LookUpAddSpecClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = LookUpSpecimenFetch ]
{
}

ClassMethod LookUpAddSpecExecute(ByRef QHandle As %Library.Binary, specdesc As %String, Order As %Library.String) As %Library.Status
{
}

ClassMethod LookUpAddSpecFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = LookUpSpecimenExecute ]
{
}

/// Log 51069 YC - Calls Issac's routine to print labels
/// Used in EPVisitNumber.ListNonExecutedOrders->Labels
ClassMethod PrintLabels(epid As %Library.String, CompName As %Library.String)
{
}

ClassMethod UpdateOrderItemSpec(OrderID As %Library.String = "", ByRef specs As %Library.String) As %Library.Integer
{
}

ClassMethod UpdateSpecimens(labepis As %Library.String, ByRef specs As %Library.String, OrderID As %Library.String = "") As %Library.Integer
{
}

/// Invoked after websysSave - can be used to provide extra websysSave functionality while keeping the default websysSave behaviour.
ClassMethod websysAfterSave(compref As %String, ByRef id As %String, new As %Boolean, orderids As %Library.String = "", ColRecType As %Library.String = "", LabEpisodeIDs As %Library.String = "", ComputerName As %Library.String = "") As %Boolean
{
}

/// Invoked before websysSave - can be used to cancel the save.<br>
ClassMethod websysBeforeSave(compref As %String, ByRef id As %String) As %Boolean
{
}

ClassMethod websysDeleteLabCollect(id As %Library.String, labepisodeno As %Library.String = "")
{
}

ClassMethod websysSaveCollectionStatus(compref As %Library.String = "", id As %Library.String = "", Location As %Library.String = "", ArrivalDate As %Library.String, OERowIDs As %Library.String)
{
}

ClassMethod websysSaveLabCollect(compref As %Library.String, id As %Library.String)
{
}

ClassMethod websysSaveLabOrderReceive(compref As %Library.String, labepisodeno As %Library.String)
{
}

ClassMethod websysSaveLabCollectDetails()
{
}

Query FindClinicalPathwayProblems(mradm As %String) As %Library.SQLQuery(CONTAINID = 1, ROWSPEC = "ID:%String,EPDesc:%String,DAYSDesc:%String,IDDate:%Date,CPWDesc:%String")
{
SELECT CPW_RowId, CPW_Pathways_DR->DAYS_ParRef->EP_Desc, CPW_Pathways_DR->DAYS_Desc, CPW_IDDate, CPW_Pathways_DR->DAYS_ParRef->EP_ParRef->CPW_Desc
FROM SQLUser.MR_ClinicalPathWays
WHERE CPW_ParRef=:mradm
}

/// Author - John Hart
/// Purpose - To get unexecuted lab ordes
/// Log 59281 - AI - 23-05-2006 : Add the Order Start Date and Time.
Query FindLabOrderCollection(LabEpisodeID As %String, loc As %String, ID As %String, StartDate As %Library.String, EndDate As %Library.String) As %Library.Query(CONTAINID = 1, ROWSPEC = "ID,OrderDesc:%String,OrderList:%String,Notes:%String,Specimen:%String,Received:%String,QA:%String,LabEpisNo:%String,TotalContainers:%String,ContainerType:%String,ContainerNumber:%String,VolumeCollected:%String,VolumeCurrent:%String,OrderingCP:%String,ResponsibleCP:%String,TestSetCodes:%String,SpecBuffer:%String,position:%String,orderids:%String,orderstatus:%String,orderitemdr:%String,errormsg:%String,OrderUser:%String,SpecSite:%String,SpecIDs,OrdStartDate,OrdStartTime")
{
}

/// Author - John Hart
/// Purpose - To get collected lab ordes
Query FindLabOrderReceive(LabEpisodeID As %String, loc As %String) As %Library.Query(CONTAINID = 1, ROWSPEC = "ID,OrderLink:%String,OrderList:%String,Specimen:%String,Received:%String,LabEpisNo:%String,TotalContainers:%String,ContainerType:%String,ContainerNumber:%String,VolumeCollected:%String,VolumeCurrent:%String,TestSetCodes:%String,SpecBuffer:%String,position:%String,orderids:%String,SpecIDs")
{
}

/// Basic query returning description from a partial description, ordered by description.
/// Compiled will attempt to derive the 'description' property from available properties unless it is explicity
/// set in the SQLDESCRIPTION parameter.
/// SQLROWID may be used to specify the field name to be used as rowid.
Query LookUpSpecimen(Order As %String, ARCIM As %String, EpID As %String, ResultProfile As %String = "", recloc As %String = "") As %Library.Query(CONTAINID = 2, ROWSPEC = "code:%String,desc:%String,defstatus:%String")
{
}

Query LookUpAddSpec(specdesc As %String, Order As %String) As %Library.Query(CONTAINID = 2, ROWSPEC = "code:%String,desc:%String")
{
}

}
