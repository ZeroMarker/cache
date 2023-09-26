/// Logs 54115 and 54116 YC
/// New EPDiet class for Diet Worklist, Diet Item Summary and Diet Order Set Summary.
Class epr.EPDiet Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Property dummy As %Library.String(TRUNCATE = 1);

/// Worklist and Summaries use the same search fields
/// Gets Search Fields
ClassMethod GetSearchParams()
{
}

/// Check search fields against current data
ClassMethod CheckParams(ord, itm, ent, DietType, Hospital, MealType, PatRegNo, Specialty, Ward) As %Library.Boolean
{
}

ClassMethod DietWorklistExecute(ByRef QHandle As %Library.Binary, TSRTITM As %Library.String = "", TSRTORD As %Library.String = "") As %Library.Status
{
}

ClassMethod DietWorklistFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = DietWorklistExecute ]
{
}

ClassMethod DietWorklistClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = DietWorklistFetch ]
{
}

/// Gets each row for DietWorklist
ClassMethod GetDietRow(ord, itm, ent, date, time)
{
}

ClassMethod DietOrderSetSummaryExecute(ByRef QHandle As %Library.Binary, TSRTITM As %Library.String = "", TSRTORD As %Library.String = "") As %Library.Status
{
}

ClassMethod DietOrderSetSummaryFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = DietOrderSetSummaryExecute ]
{
}

ClassMethod DietOrderSetSummaryClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = DietOrderSetSummaryFetch ]
{
}

ClassMethod DietOrderItemSummaryExecute(ByRef QHandle As %Library.Binary, TSRTITM As %Library.String = "", TSRTORD As %Library.String = "") As %Library.Status
{
}

ClassMethod DietOrderItemSummaryFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = DietOrderItemSummaryExecute ]
{
}

ClassMethod DietOrderItemSummaryClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = DietOrderItemSummaryFetch ]
{
}

ClassMethod OrderSetEntItemsExecute(ByRef QHandle As %Library.Binary, ent As %Library.String, StartDate As %Library.String, StartTime As %Library.String) As %Library.Status
{
}

ClassMethod OrderSetEntItemsFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = OrderSetEntItemsExecute ]
{
}

ClassMethod OrderSetEntItemsClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = OrderSetEntItemsFetch ]
{
}

Query DietWorklist(TSRTITM, TSRTORD) As %Library.Query(ROWSPEC = "OrderID,EpisodeID,ent,OSDesc,PatientID,StartDate,StartTime,subcatd,OrderType,DietType,MealType,MealTime,mradmdr,PatRegNo,MRN,PAPMIName,PAPMIName2,PAPMIName3,PAPMIName4,PAPMIName5,PAPMIName6,PAPMIName7,PAPMIName8,PAPMIDOB,PAADMUnit,PAADMRoom,PAADMWard,PAADMBed,PAADMHospital,PAADMSpecialty,PAADMClinic,EpisodeType,MealTypeDR,OrderSetDR,AmendedItems,VIPStatus")
{
}

Query DietOrderSetSummary(TSRTITM, TSRTORD) As %Library.Query(ROWSPEC = "OrderSetData,arcosdr,StartDate,MealType,DietType,Quantity")
{
}

Query DietOrderItemSummary(TSRTITM, TSRTORD) As %Library.Query(ROWSPEC = "arcim,Date,OrderItem,Quantity")
{
}

Query OrderSetEntItems(ent, StartDate, StartTime) As %Library.Query(ROWSPEC = "arcim,orderid,itemdesc,quantity")
{
}

}
