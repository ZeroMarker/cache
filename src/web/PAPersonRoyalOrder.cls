Class web.PAPersonRoyalOrder Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 290;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "ROYAL_RowId";

Parameter SQLDESCRIPTION = "ROYAL_RowId";

Parameter SQLROWID = "ROYAL_RowId";

Property dummy As %String(TRUNCATE = 1);

/// ab 12.11.04 - 47327
ClassMethod FindRoyalOrdersExecute(ByRef QHandle As %Library.Binary, PatientID As %String = "", DateFrom As %Library.String = "", DateTo As %Library.String = "", RoyalOrderNo As %String = "", OfficeNo As %String = "", Payor As %String = "", Plan As %String = "", Status As %String = "", Name1 As %String = "", Name2 As %String = "", Name3 As %String = "", Name4 As %String = "", RegitNo As %String = "") As %Library.Status
{
}

ClassMethod FindRoyalOrdersFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = FindRoyalOrdersExecute ]
{
}

ClassMethod FindRoyalOrdersClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindRoyalOrdersFetch ]
{
}

Query FindRoyalOrders(PatientID, DateFrom, DateTo, RoyalOrderNo, OfficeNo, Payor, Plan, Status, Name1, Name2, Name3, Name4, RegitNo) As %Library.Query(CONTAINID = 0, ROWSPEC = "ID,ROYALDateValidFrom,ROYALDateValidTo,ROYALNumber,ROYALOfficeNo,INSTDesc,ROYALPaysUntil,AUXITDesc,RCHDesc,ROOMTDesc,ROYALStatus,ROYALParRef,PAPERName,PAPERName2,PAPERName3,PAPERName4,ROYALAmtRemain,ROYALPeriod,ROYALInpDateValidTo,ROYALInpPeriod,PAPERName5,PAPERName6,PAPERName7,PAPERName8,RegiNumber,VIPStatus,ROYALInpDateValidFrom")
{
}

Query FindRoyalOrders2(PatientID As %String = "") As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID,ROYALDateValidFrom,ROYALDateValidTo,ROYALNumber,ROYALOfficeNo,INSTDesc,ROYALPaysUntil,AUXITDesc,RCHDesc,ROOMTDesc,ROYALStatus,ROYALParRef,PAPERName,PAPERName2,PAPERName3,PAPERName4,ROYALAmtRemain,ROYALValidPeriod,PAPERName5,PAPERName6,PAPERName7,PAPERName8")
{
SELECT ROYAL_RowId,ROYAL_DateValidFrom,ROYAL_DateValidTo,ROYAL_Number,ROYAL_OfficeNo,ROYAL_Payor_DR->INST_Desc,
ROYAL_PaysUntil,ROYAL_Plan_DR->AUXIT_Desc,ROYAL_ReasonChange_DR->RCH_Desc,ROYAL_RoomType_DR->ROOMT_Desc,ROYAL_Status,
ROYAL_ParRef,ROYAL_ParRef->PAPER_Name,ROYAL_ParRef->PAPER_Name2,ROYAL_ParRef->PAPER_Name3,ROYAL_ParRef->PAPER_Name4,
ROYAL_AmtRemain,ROYAL_ValidPeriod,ROYAL_ParRef->PAPER_Name5,ROYAL_ParRef->PAPER_Name6,ROYAL_ParRef->PAPER_Name7,ROYAL_ParRef->PAPER_Name8
FROM SQLUser.PA_PersonRoyalOrder
WHERE ((ROYAL_ParRef->PAPER_RowId = :PatientID) OR (:PatientID IS NULL))
ORDER BY ROYAL_DateValidFrom DESC
}

ClassMethod GetStatus(RoyalOrder As %String = "") As %String
{
}

ClassMethod FindIfLinksDataRoyalOrder(RoyalOrder As %String = "") As %String
{
}

/// Invoked after websysSave - can be used to provide extra websysSave functionality while keeping the default websysSave behaviour.
ClassMethod websysAfterSave(compref As %String, ByRef id As %String, new As %Boolean) As %Boolean
{
}

ClassMethod UpdateDateToFromPeriodFUTURE(RoyalOrder As %String = "", EpAdmType As %String = "")
{
}

ClassMethod UpdateDateToFromPeriod(RoyalOrder As %String = "", EpAdmType As %String = "")
{
}

/// update Date To to the Date From + period
/// md same with 2nd parameter
ClassMethod UpdateDateToFromPeriodOLD(RoyalOrder As %String = "", EpAdmType As %String = "")
{
}

ClassMethod InsertAdmInsurance(EpisodeID As %String = "", RoyalOrder As %String = "")
{
}

ClassMethod HasRoyalOrderInsurance(EpisodeID As %String = "", RoyalOrder As %String = "") As %String
{
}

/// Invoked before websysSave - can be used to cancel the save.<br>
ClassMethod websysBeforeSave(compref As %String, ByRef id As %String) As %Boolean
{
}

//md 20/06/2006 To Figure out correct status based on id and type

//in this moment  type is not accounted 

ClassMethod GetROCmlStatus(RoyalOrder As %String = "", EpAdmType As %String = "")
{
}

/// MD lOG 51711 IN COORDINATION WITH 51709 If Billing already done and RO changed will need to redo Billing
/// Note Billing part needs to be modified as per 51705 and 51708
ClassMethod RedoROBills(RoyalOrderID As %String = "")
{
}

}
