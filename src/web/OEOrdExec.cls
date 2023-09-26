Include webimport

IncludeGenerator webimport

Class web.OEOrdExec Extends (%Library.RegisteredObject, websys.Abstract) [ Not Abstract, ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 1278;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

ClassMethod CrossOutForAppt(AppointmentID As %String = "")
{
}

Parameter SQLCODE = "OEORE_RowId";

Parameter SQLDESCRIPTION = "OEORE_Desc";

Parameter SQLROWID = "OEORE_RowId";

Property dummy As %String(TRUNCATE = 1);

ClassMethod ExecuteTimesShow(OEOrdItemID As %Library.String, datefr As %Library.Date, daystoview As %Library.String, ByRef statusColourLIST As %Library.String, lnk As %Library.String = "", ShowNew As %Library.String = "", startdate As %Library.Date = "", starttime As %Library.String = "", durat As %Library.String = "", ordstatus As %Library.String = "", ordstatusdesc As %Library.String = "", linkedorder As %Library.String = "", OEORIClinPathwaysDR As %Library.String = "", Disch As %Library.String = "")
{
}

ClassMethod ShowPRN(ExecId As %Library.String) As %Library.String
{
}

// Do not show execution times after discharge (unless they are actioned)

ClassMethod ShowDisch(ExecId As %Library.String, Disch As %Library.String) As %Library.String
{
}

/// Default implementation of LookUp Query.
ClassMethod FindLinkedOrdersClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindLinkedOrdersFetch ]
{
}

/// Given a OEOrdItem rowid (and it's sequence),
/// lists it's linked order items and displays the first non-administered execution time
ClassMethod FindLinkedOrdersExecute(ByRef QHandle As %Library.Binary, PARREF As %String, seqno As %Library.String = "") As %Library.Status [ PlaceAfter = GetIdFromCodeOrDescription ]
{
}

/// given an OEOrdItem rowid and it's seqno
ClassMethod FindLinkedOrdersFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = FindLinkedOrdersExecute ]
{
}

ClassMethod GetAnsweredQuestionnaire(oeordexecid As %Library.String, questionnaireid As %Library.String) As %Library.String
{
}

ClassMethod GetDisDateFromOID(OID As %Library.String) As %Library.String
{
}

ClassMethod GetExecID(PARREF As %Library.String, DateExec As %Library.String, TimeExec As %Library.String) As %Library.String
{
}

ClassMethod IsExecuted(PARREF As %Library.String) As %Library.String
{
}

ClassMethod ValidateTimeExe(Id, MultiFlag As %String = "", ExeTime As %Library.Time = "") As %Boolean
{
}

ClassMethod GetIVType(OEOrdRowID As %String) As %Library.String
{
}

ClassMethod GetIVContCompleteID() As %Library.String
{
}

ClassMethod IVContPrevComplete(OEOrdExec As %String) As %Library.String
{
}

ClassMethod IVContIsFirstBag(OEOrdExec As %String) As %Library.String
{
}

ClassMethod SaveAndCheckIfExecuted(compref As %String, id As %String, OrderRowId As %String, MultiFlag As %String = "", ExeTime As %Library.Time = "") As %Boolean
{
}

ClassMethod CheckOverseerReq(id As %String) As %Boolean
{
}

/// Invoked before websysSave - can be used to cancel the save.<br>
ClassMethod websysBeforeSave(compref As %String, ByRef id As %String, override As %String) As %Boolean
{
}

/// Default save method used for updating the database for Components of type Edit.<br>
/// <br>
/// The compref is the  component reference which is the string from which we can deduce the instance of<BR>
/// websysComponent<BR>
/// websysComponentItem<BR>
/// id is the id for the instance of class we wish to update.
ClassMethod websysSave(compref As %String, id As %String, override As %String) [ CodeMode = generator ]
{
}

ClassMethod websysSaveLinkedOrders()
{
}

/// Log 60114 BoC
ClassMethod MultiExecutionSave(compref As %String, MultiFlag As %String) As %Boolean
{
}

Query Find(ID As %String) As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID,OEOREDesc:%String,ARCIMDesc:%String,STATDR:%String,CTPCPDesc:%String,OEOREQtyAdmin:%String,CTUOMDesc:%String,OEOREDateExecuted:%Date,OEORETimeExecuted:%Time")
{
SELECT OEORE_RowID, OEORE_Desc, OEORE_OEORI_ParRef->OEORI_ItmMast_DR->ARCIM_Desc, OEORE_Order_Status_DR->STAT_Desc, OEORE_CTPCP_DR->CTPCP_Desc, OEORE_QtyAdmin, OEORE_CTUOM_DR->CTUOM_Desc, OEORE_DateExecuted, OEORE_TimeExecuted
FROM OE_OrdExec
WHERE (OEORE_Rowid = :ID)
}

Query FindAllTimesForDate(orditemid As %String, date As %Date) As %Library.SQLQuery(CONTAINID = 1, ROWSPEC = "ID,STATDR:%String,STATDesc:%String,OEOREDateExecuted:%Date,OEORETimeExecuted:%Time,OEOREExStDate:%Date,OEOREExStTime:%Time")
{
SELECT OEORE_RowID, OEORE_Order_Status_DR, OEORE_Order_Status_DR->STAT_Desc, OEORE_DateExecuted, OEORE_TimeExecuted, OEORE_ExStDate, OEORE_ExStTime
FROM OE_OrdExec
WHERE (OEORE_OEORI_ParRef = :orditemid) AND ((OEORE_ExStDate = :date) OR ((OEORE_ExStDate IS NULL)AND(OEORE_DateExecuted = :date)))
AND ((OEORE_OEORI_ParRef->OEORI_ItemStat_DR->OSTAT_Code NOT= 'D') OR (OEORE_DateExecuted NOT=''))
}

Query FindAllxTmsForOrdItem(orditemid As %String, datefrom As %Date) As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID,STATDR:%String,CTPCPDesc:%String,OEOREQtyAdmin:%String,CTUOMDesc:%String,OEOREDateExecuted:%Date,OEORETimeExecuted:%Time,OEOREExStDate:%Date,OEOREExStTime:%Time,STATDesc:%String")
{
SELECT OEORE_RowID, OEORE_Order_Status_DR, OEORE_CTPCP_DR->CTPCP_Desc, OEORE_QtyAdmin, OEORE_CTUOM_DR->CTUOM_Desc, OEORE_DateExecuted, OEORE_TimeExecuted,OEORE_ExStDate,OEORE_ExStTime, OEORE_Order_Status_DR->STAT_Desc
FROM OE_OrdExec
WHERE (OEORE_OEORI_ParRef = :orditemid) AND (OEORE_ExStDate = :datefrom)
}

Query FindExec(orditem As %String) As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID,OEOREOrderStatusDR:%String,OEOREDateExecuted:%Date,OEORETimeExecuted:%Time,OEOREQtyAdmin:%Float,CTUOMDesc:%String,OEORECTPCPDR:%String")
{
SELECT OEORE_RowID, OEORE_Order_Status_DR, OEORE_DateExecuted, OEORE_TimeExecuted, OEORE_QtyAdmin, OEORE_CTUOM_DR->CTUOM_Desc, OEORE_CTPCP_DR
FROM OE_OrdExec
WHERE (OEORE_OEORI_ParRef = :orditem) AND (OEORE_TimeExecuted <> '')
}

Query FindLinkedOrders(PARREF As %Library.String) As %Library.Query(CONTAINID = 1, ROWSPEC = "ID,orditemid,ARCIMDesc,OEOREExStDate:%Date,OEOREExStTime:%Time,OEOREQtyAdmin:%Float,OEORECTUOMDR")
{
}

Query FindAllLinkedOrders(PARREF As %Library.String) As %Library.Query(CONTAINID = 1, ROWSPEC = "ID,orditemid,ARCIMDesc,OEOREExStDate:%Date,OEOREExStTime:%Time,OEOREQtyAdmin:%Float,OEORECTUOMDR")
{
}

Query LookUpBatchNo(INCItmLocID As %String, OEItemID As %String, OEOREAltRecLocDR As %String, AltRecLoc As %String, OEOREStockBatches As %String) As %Query(CONTAINID = 0, ROWSPEC = "BatchNo:%String,Hidden:%String,Hidden:%String")
{
}

Query findAppoints(OEORIROWID As %Library.String) As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "OEORERowId:%String,ExDate:%String,ExTime:%String,ApptDR:%String,ApDate:%String,ApTime:%String")
{
SELECT OEORE_RowId,OEORE_ExStDate,OEORE_ExStTime,OEORE_Appt_DR,OEORE_Appt_DR->APPT_AS_ParRef->AS_Date,OEORE_Appt_DR->APPT_AS_ParRef->AS_SessStartTime
FROM SQLUser.OE_OrdExec
WHERE OEORE_OEORI_ParRef=:OEORIROWID
AND	OEORE_Appt_DR->APPT_Status <> 'X'
}

/// Default implementation of LookUp Query.
ClassMethod FindAllLinkedOrdersClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindAllLinkedOrdersFetch ]
{
}

/// Given a OEOrdItem rowid (and it's sequence),
/// lists it's linked order items and displays the first non-administered execution time
ClassMethod FindAllLinkedOrdersExecute(ByRef QHandle As %Library.Binary, PARREF As %String) As %Library.Status [ PlaceAfter = GetIdFromCodeOrDescription ]
{
}

/// given an OEOrdItem rowid and it's seqno
ClassMethod FindAllLinkedOrdersFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = FindAllLinkedOrdersExecute ]
{
}

ClassMethod LookUpBatchNoExecute(ByRef QHandle As %Library.Binary, INCItmLocID As %String = "", OEItemID As %String = "", OEOREAltRecLocDR As %String = "", AltRecLoc As %String = "", OEOREStockBatches As %String = "") As %Library.Status
{
}

ClassMethod LookUpBatchNoFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = LookUpBatchNoExecute ]
{
}

ClassMethod LookUpBatchNoClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = LookUpBatchNoFetch ]
{
}

ClassMethod LookUpBatchNoBroker(itmjs As %Library.String = "", itmjsex As %Library.String = "", INCItmLocID As %String = "", OEItemID As %String = "", OEOREAltRecLocDR As %String = "", AltRecLoc As %String = "", OEOREStockBatches As %String = "") As %Library.Boolean
{
}

ClassMethod Stock(PARREF As %Library.String) As %Library.String
{
}

ClassMethod GetBatchNo(INCItmLcBtID As %Library.String) As %Library.String
{
}

ClassMethod CheckPRNQtyUponAdmin(ExecID As %Library.String, AdminDate As %Library.String, AdminTime As %Library.String, AdminQty As %Library.String, AdminUOM As %Library.String, AdminStatus) As %Library.String
{
}

ClassMethod CalBaseQty(OEExecID As %Library.String, QTY As %Library.String) As %Library.String
{
}

ClassMethod GetFirstExec(OrdItemID As %Library.String) As %Library.String
{
}

ClassMethod UpdTLPAdmStat(EpisodeID As %String, compref As %String) As %Boolean
{
}

ClassMethod UpdFnDtIndOnAdmin(OrdExecRowID As %String) As %Boolean
{
}

ClassMethod CopyGateLeave(OEOrdID As %String, execs As %String, qty As %String, sttdat As %String, stttim As %String, dur As %String, pri As %String, loc As %String, adm As %String)
{
}

// Query - JD Log 58436

ClassMethod FindLeaveAdmsClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindLeaveAdmsFetch ]
{
}

ClassMethod FindLeaveAdmsExecute(ByRef QHandle As %Library.Binary, EpisodeID As %Library.String = "", LeaveDTFrom As %Library.String = "", LeaveTIFrom As %Library.String = "", LeaveDTTo As %Library.String = "", LeaveTITo As %Library.String = "") As %Library.Status
{
}

ClassMethod FindLeaveAdmsFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = FindLeaveAdmsExecute ]
{
}

Query FindLeaveAdms(EpisodeID As %Library.String = "", LeaveDTFrom As %Library.String = "", LeaveTIFrom As %Library.String = "", LeaveDTTo As %Library.String = "", LeaveTITo As %Library.String = "") As %Library.Query(CONTAINID = 1, ROWSPEC = "ID,OEITMDesc,PrescNo,SttDate,SttTime,Dosage,Unit,Duration,Frequency,RecLoc,EpisodeID,arcim,DISpri,Hidden")
{
}

ClassMethod DeductStockBottle(OEOrdExec As %Library.String) As %Library.String
{
}

/// Log 59279
Query xfindLinkedAppoints(OEORIROWID As %Library.String) As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "OEORERowId:%String,ExDate:%String,ExTime:%String,ApptDR:%String,ApDate:%String,ApTime:%String")
{
SELECT OEORE_RowId,OEORE_ExStDate,OEORE_ExStTime,OEORE_Appt_DR,OEORE_Appt_DR->APPT_AS_ParRef->AS_Date,OEORE_Appt_DR->APPT_AS_ParRef->AS_SessStartTime
FROM SQLUser.OE_OrdExec
WHERE OEORE_OEORI_ParRef->OEORI_LinkToOrder=:OEORIROWID
AND	OEORE_Appt_DR->APPT_Status <> 'X'
}

Query findLinkedAppoints(OEORIROWID As %Library.String) As %Library.Query(CONTAINID = 1, ROWSPEC = "OEORERowId:%String,ExDate:%String,ExTime:%String,ApptDR:%String,ApDate:%String,ApTime:%String")
{
}

ClassMethod findLinkedAppointsClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = findLinkedAppointsFetch ]
{
}

ClassMethod findLinkedAppointsExecute(ByRef QHandle As %Library.Binary, OEORIROWID As %String) As %Library.Status [ PlaceAfter = GetIdFromCodeOrDescription ]
{
}

ClassMethod findLinkedAppointsFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = findLinkedAppointsExecute ]
{
}

/// Log 60114 BoC
Query ListMultipleOEOrdExec(OEORIRowIds As %Library.String, OEOrdExecIDs As %Library.String) As %Library.Query(CONTAINID = 0, ROWSPEC = "OEORIRowId:%Library.String,OEOrdExecID:%Library.String,OrderItem:%Library.String,PlannedAdminDate:%Library.String,PlannedAdminTime:%Library.String,QuantityToAdminister:%Library.String,AdminUnitOfMeasure:%Library.String,GenericRouteForm:%Library.String,OrderNotes:%Library.String,ProcessingNotes:%Library.String,PhQtyOrd:%Library.String")
{
}

ClassMethod ListMultipleOEOrdExecClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = ListMultipleOEOrdExecFetch ]
{
}

ClassMethod ListMultipleOEOrdExecExecute(ByRef QHandle As %Library.Binary, OEORIRowIds As %Library.String = "", OEOrdExecIDs As %Library.String = "") As %Library.Status
{
}

ClassMethod ListMultipleOEOrdExecFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = ListMultipleOEOrdExecExecute ]
{
}

/// end of Log 60114 BoC
Query RecipeList(ID As %String) As %SQLQuery(CONTAINID = 1, ROWSPEC = "ItemDesc,Quantity,UOM,INCID,INCIDR,DoseQty,UOMID,ARCIMID,LocID")
{
 SELECT INCI_INCI_DR-> INCI_Desc,
 INCI_Qty,
 INCI_INCI_DR->INCI_OriginalARCIM_DR->ARCIM_PHCDF_DR->PHCDF_CTUOM_DR->CTUOM_Desc,
 INCI_RowId,
 INCI_INCI_DR,
 INCI_DoseQty,
 INCI_DoseUOM_DR,
 OEORE_OEORI_ParRef->OEORI_ItmMast_DR,
 OEORE_OEORI_ParRef->OEORI_RecDep_DR
 FROM IN_Manufacture_OrderINCI,OE_OrdExec
 WHERE INCI_ParRef  = OEORE_OEORI_ParRef->OEORI_ManufacturerOrder_DR
 AND OEORE_RowId=:ID
}

ClassMethod GetQTYBaseUOM(INCIDR As %Library.String, DoseQty As %Library.String, Quantity As %Library.String, UOMID As %Library.String) As %Library.String
{
}

ClassMethod GetDefBatchForMixture(INCI As %String, OEOrdItemID As %String, DoseQty As %String, UOMID As %String) As %Library.String
{
}

Query FindBatchesByINCILoc(INCI As %String, OEORI As %String, QTYBaseUOM As %String, Batch As %String, Loc As %String, LocID As %String) As %Library.Query(CONTAINID = 1, ROWSPEC = "HIDDEN,Batch,Exp,Avail,HIDDEN")
{
}

ClassMethod FindBatchesByINCILocClose(ByRef QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindBatchesByINCILocFetch ]
{
	Quit $$$OK
}

ClassMethod FindBatchesByINCILocFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Library.Status [ PlaceAfter = FindBatchesByINCILocExecute ]
{
	Quit $$$OK
}

ClassMethod FindBatchesByINCILocExecute(ByRef QHandle As %Library.Binary, INCI As %String, OEORI As %String, QTYBaseUOM As %String, Batch As %String, Loc As %String, LocID As %String) As %Library.Status
{
	Quit $$$OK
}

ClassMethod FindBatchesByINCILocBroker(itmjs As %Library.String, itmjsex As %Library.String, INCIDR As %Library.String = "", OEOrdItemID As %Library.String = "", QTYBaseUOM As %Library.String = "", Batch As %Library.String = "", Loc As %String, LocID As %String) As %Library.Boolean
{
	Quit $$$OK
}

}
