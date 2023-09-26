Class web.ARPatBillBestPlan Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 382;

ClassMethod FindQuoteHeadersExecute(ByRef QHandle As %Library.Binary, EpisodeID As %Library.String = "", Sort As %Library.String = "A", QuoteID As %Library.String = "") As %Library.Status
{
}

ClassMethod FindQuoteHeadersFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = FindQuoteHeadersExecute ]
{
}

Query FindQuoteHeaders(EpisodeID As %String, Sort As %String, QuoteID As %String) As %Library.Query(CONTAINID = 0, ROWSPEC = "RankStr,ItmPayorKey,ItmRowID,Expand,CaseDesc,Rank1,Rank2,Rank3,Rank4,Rank5,Rank6,Rank7,Rank8,Rank9,Rank10,PatientShare,Total,PrintedDate,PrintedTime")
{
}

ClassMethod FindQuoteHeadersClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindQuoteHeadersFetch ]
{
}

ClassMethod FindQuoteItemsExecute(ByRef QHandle As %Library.Binary, ItmPayorKey As %Library.String = "") As %Library.Status
{
}

ClassMethod FindQuoteItemsFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = FindQuoteItemsExecute ]
{
}

Query FindQuoteItems(ItmPayorKey As %String) As %Library.Query(CONTAINID = 0, ROWSPEC = "OrdItemID,PayorID,PlanID,Payor,Plan,OrderDesc,Qty,Price,PayorTotal,PatientTotal,OrdItemCode,OrdCategory,BillGroup,PriceB4Disc,ServTax")
{
}

ClassMethod FindQuoteItemsClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindQuoteItemsFetch ]
{
}

ClassMethod FindSelOrdersExecute(ByRef QHandle As %Library.Binary, QuoteID As %String = "", EpisodeID As %String = "") As %Library.Status
{
}

ClassMethod FindSelOrdersFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = FindSelOrdersExecute ]
{
}

Query FindSelOrders(QuoteID As %String, EpisodeID As %String) As %Library.Query(CONTAINID = 0, ROWSPEC = "OrdItemID,OrdDesc,Qty,Price,OrdItemCode,OrdCategory,QuoteItemRowID")
{
}

ClassMethod FindSelOrdersClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindSelOrdersFetch ]
{
}

ClassMethod GenerateQuotes(QuoteID As %String, PatientID As %String = "", Surname As %String = "", FirstName As %String = "", DOB As %String = "", PayorPlan As %String = "", ExpAdmDate As %String = "", ExpLenStay As %String = "", RoomTypeDR As %String = "", HospitalDR As %String = "", UserCode As %String = "", PIN As %String = "") As %Library.String
{
}

ClassMethod AddOrders(QuoteID As %String, OEOrdID As %String, OrderQty As %String, PatientID As %String = "", Surname As %String = "", FirstName As %String = "", DOB As %String = "", PayorPlan As %String = "", ExpAdmDate As %String = "", ExpLenStay As %String = "") As %Library.String
{
}

ClassMethod BillSelectedQuote(EpisodeID As %String, PatientID As %String, RankingParam As %String) As %Library.String
{
}

ClassMethod DeleteOrder(QuoteItemID As %String)
{
}

ClassMethod DeleteQuote(QuoteID As %String, UserCode As %String, PIN As %String) As %String
{
}

ClassMethod GetARQuoteData(QuoteID As %String)
{
}

ClassMethod GetEpisodeData(EpisodeID As %String)
{
}

ClassMethod GetPatientData(PatientID As %String)
{
}

Query FindQuotes(DateFrom As %Date, DateTo As %Date, QuoteNo As %String, Surname As %String, FirstName As %String, BirthDate As %Date, EpisodeID As %String) As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "QuoteID,QuoteDate,QuoteUser,QuoteNo,Surname,FirstName,DOB")
{
 	SELECT QT_RowId,QT_Date,QT_User_DR->SSUSR_Name,QT_Number,QT_Surname,QT_GivenName,QT_Dob
	FROM SQLUser.AR_Quote
	WHERE ((%UPPER QT_Number %STARTSWITH %UPPER :QuoteNo) OR (:QuoteNo IS NULL))
	AND ((%UPPER QT_Surname %STARTSWITH %UPPER :Surname) OR (:Surname IS NULL))
	AND ((%UPPER QT_GivenName %STARTSWITH %UPPER :FirstName) OR (:FirstName IS NULL))	
	AND ((QT_Date >= :DateFrom OR :DateFrom IS NULL) AND (QT_Date <= :DateTo OR :DateTo IS NULL))
	AND ((QT_Dob = :BirthDate) OR (:BirthDate IS NULL))
}

}
