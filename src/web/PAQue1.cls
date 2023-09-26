Include webimport

IncludeGenerator webimport

Class web.PAQue1 Extends (%Library.RegisteredObject, websys.Abstract) [ Not Abstract, ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 2785;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLDESCRIPTION = "QUE1_RowID";

Parameter SQLROWID = "QUE1_RowID";

Parameter SQLCODE = "QUE1_RowID";

/// 63555
ClassMethod GetMonoLink(ItemMast As %Library.String = "")
{
}

ClassMethod NumToString(Num As %String) As %String
{
}

ClassMethod CalcBMI(EpisodeID, height As %String = "", weight As %String = "") As %String
{
}

ClassMethod CalcBSA(EpisodeID, formula, height As %String = "", weight As %String = "") As %String
{
}

ClassMethod DisplayTabHeaders()
{
}

ClassMethod DisplayChartingTimes(ExeID As %String = "")
{
}

ClassMethod LookupAdminBatchesExecute(ByRef QHandle As %Library.Binary, ExeID As %String) As %Library.Status
{
}

ClassMethod LookupAdminBatchesFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Library.Status [ PlaceAfter = LookupAdminBatchesExecute ]
{
}

ClassMethod LookupAdminBatchesClose(ByRef QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = LookupAdminBatchesFetch ]
{
}

ClassMethod GetHiddenPharmacySelectBatch(OEOrdExec As %String)
{
}

ClassMethod FindAdminDispensingExecute(ByRef QHandle As %Library.Binary, OEOrdExec As %String) As %Library.Status
{
}

ClassMethod FindAdminDispensingFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Library.Status [ PlaceAfter = FindAdminDispensingExecute ]
{
}

ClassMethod FindAdminDispensingClose(ByRef QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindAdminDispensingFetch ]
{
}

ClassMethod SaveAdminBatches(compref As %String, OEOrdExec As %String)
{
}

ClassMethod GetTabs(ByRef tabs As %String)
{
}

ClassMethod PrescHasAlerts(PrescNos As %String)
{
}

ClassMethod OrderHasAlerts(Order As %String)
{
}

ClassMethod ItemHasDoseAlert(OEORIRowId As %String, FirstOnly As %String = 0, ByRef ints)
{
}

// crappy method to return format same as $$drugint^MVBOEORD

ClassMethod drugint(EpisodeID As %String, ordstring As %String) As %String
{
}

ClassMethod ItemHasInteraction(OEORIRowId As %String, FirstOnly As %String = 0, ByRef ints, epid, ordstring, ByRef dups)
{
}

ClassMethod GetONEInt(df, df1, GenRtFm, GenRtFm1, stat1, arcim1, LIST, ints, highPRIO, MySeverities, OEORIRowID)
{
}

ClassMethod GetInt(df, df1, GenRtFm, GenRtFm1, stat1, arcim1, LIST, ints, highPRIO, MySeverities, OEORIRowID, Manuf, Manuf1)
{
}

ClassMethod GetIntOLD(df, df1, GenRtFm, GenRtFm1, stat1, arcim1, LIST, ints, highPRIO, MySeverities, OEORIRowID)
{
}

ClassMethod GetGenRtFm(drgfrm)
{
}

ClassMethod GetDaysAftMedInt(arcim)
{
}

// crappy method to return format same as $$allergy^COEOrdItem1

ClassMethod Allergy(EpisodeID As %String, ArcimDR As %String, ByRef ArcimText)
{
}

ClassMethod GetItemAllergy(OEORIRowId, ByRef ItemDets, ArcimDR As %String = "")
{
}

ClassMethod GetAllerGrps(generic As %Library.String = "", drugmast As %Library.String = "", ByRef Grps As %String)
{
}

ClassMethod ItemHasAllergy(PatientID As %String, OEORIRowId As %String, FirstOnly As %String = 0, ByRef found, DescOnly As %String = 0, arcim As %String = "")
{
}

ClassMethod ConvXSensIDToAllgGrpID(XGrp)
{
}

ClassMethod MatchAllergyWithItem(AllergyID As %String, OEORIRowId As %String, FirstOnly As %String = 0, ByRef found, DescOnly As %String = 0, arcim As %String = "")
{
}

ClassMethod PrescAlertExecute(ByRef QHandle As %Library.Binary, TSRTITM As %Library.String = "", TSRTORD As %Library.String = "", PrescNo As %String = "", OrdID As %String = "", OEOrdExecID As %String = "") As %Library.Status
{
}

ClassMethod PrescAlertFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Library.Status [ PlaceAfter = PrescAlertExecute ]
{
}

ClassMethod PrescAlertClose(ByRef QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = PrescAlertFetch ]
{
}

ClassMethod AllowNeg(ArcimDR As %String) As %Library.String
{
}

ClassMethod DisplayInstrICON(o As %String, i As %String) As %Library.String
{
}

ClassMethod PrescItemsExecute(ByRef QHandle As %Library.Binary, TSRTITM As %Library.String = "", TSRTORD As %Library.String = "", PrescNo As %String = "", ADMINDateFrom, ADMINDateTo, ADMINTimeFrom, ADMINTimeTo) As %Library.Status
{
}

ClassMethod EndDate(oeitm, sttdate, enddate, duration, rmduration)
{
}

/// no longer used? JD 15/11/2006
ClassMethod AutoPickBatchToExe(OEORI, INCItmLcBt, avail)
{
}

ClassMethod PrescItemsFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Library.Status [ PlaceAfter = PrescItemsExecute ]
{
}

ClassMethod PrescItemsClose(ByRef QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = PrescItemsFetch ]
{
}

/// 60045
ClassMethod EndPharmacySession(SystemSession As %Library.String = "")
{
}

ClassMethod FindBatchesByLocClose(ByRef QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindBatchesByLocFetch ]
{
}

ClassMethod FindBatchesByLocFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Library.Status [ PlaceAfter = FindBatchesByLocExecute ]
{
}

ClassMethod FindBatchesByLocExecute(ByRef QHandle As %Library.Binary, ArcimDR As %String, Loc As %String, OrdID As %String) As %Library.Status
{
}

ClassMethod FindDispensedClose(ByRef QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindDispensedFetch ]
{
}

ClassMethod FindDispensedFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Library.Status [ PlaceAfter = FindDispensedExecute ]
{
}

ClassMethod FindDispensedExecute(ByRef QHandle As %Library.Binary, OrderIDs As %String) As %Library.Status
{
}

Query FindDispensed(OrderIDs As %String) As %Library.Query(CONTAINID = 1, ROWSPEC = "OEORIDisp,orditm,prescno,drugname,BatchID,BatchNumber,expdt,PackedQty,arcim")
{
}

ClassMethod SubstItemExecute(ByRef QHandle As %Library.Binary, TSRTITM As %Library.String = "", TSRTORD As %Library.String = "", OrdItem As %String = "") As %Library.Status
{
}

ClassMethod SubstItemFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Library.Status [ PlaceAfter = SubstItemExecute ]
{
}

ClassMethod SubstItemClose(ByRef QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = SubstItemFetch ]
{
}

ClassMethod PharmacyListExecute(ByRef QHandle As %Library.Binary, TSRTITM As %Library.String = "", TSRTORD As %Library.String = "", Loc As %String = "", QueueStatus As %String = "", RegistrationNo As %String = "", PrescNo As %String = "") As %Library.Status
{
}

ClassMethod PharmacyListFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Library.Status [ PlaceAfter = PharmacyListExecute ]
{
}

ClassMethod PharmacyListClose(ByRef QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = PharmacyListFetch ]
{
}

ClassMethod FindBatchesPickedClose(ByRef QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindBatchesPickedFetch ]
{
}

ClassMethod FindBatchesPickedFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Library.Status [ PlaceAfter = FindBatchesPickedExecute ]
{
}

ClassMethod FindBatchesPickedExecute(ByRef QHandle As %Library.Binary, OrderID As %String) As %Library.Status
{
}

ClassMethod websysDeleteBatch() As %Library.Status
{
}

ClassMethod websysSaveBatch() As %Library.Status
{
}

ClassMethod websysRefundAll(compref As %String, OrderID As %String = "") As %Library.Status
{
}

ClassMethod websysRefundBatch(compref As %String) As %Library.Status
{
}

ClassMethod OnBarCode(itmjs As %Library.String, itmjsex As %Library.String = "", ArcimDR, barcode) As %Library.Boolean
{
}

ClassMethod UpdateQuantityBroker(itmjs As %Library.String, itmjsex As %Library.String = "", SessionId, OrderID, RowID, Quantity) As %Library.Boolean
{
}

/// 48864 YC - If on the enquire screen, display last collection details
/// May be used in the future for other fields on the Pharmacy.Presc.Edit page
ClassMethod GetDispDetails(PrescNo, Action)
{
}

ClassMethod websysBeforeSave(compref As %String, t, SaveType As %String = "") As %Boolean
{
}

ClassMethod websysSave(compref As %String, SaveType As %String, PrescNo As %String)
{
}

ClassMethod IsBottle(ex)
{
}

/// Invoked after websysSave - can be used to provide extra websysSave functionality while keeping the default websysSave behaviour.
ClassMethod websysAfterSave(compref As %String, ByRef id As %String, new As %Boolean, NewStatus As %String = "", OrderIDs As %String = "") As %Boolean
{
}

ClassMethod GetAutoPack(OrdId, arrPresc)
{
}

ClassMethod CheckRefillOK(OrdID As %String, Override As %String = "")
{
}

ClassMethod GetCurrentRepeatNumber(OrdID As %String)
{
}

ClassMethod SaveRefillPresc(compref As %String, TYPE As %String = "")
{
}

Query PharmacyList(TSRTITM, TSRTORD, Loc As %String, Status As %String, RegistrationNo As %String, PrescNo As %String) As %Library.Query(CONTAINID = 1, ROWSPEC = "RowID,EpisodeID,PatientID,PrNo,PAPMIName,PAPMIName2,PAPMIDOB,PAPMISex,PAPMIAge,rego,MRN,PAADMEpisType,PAADMDEpisDate,PAADMUnit,PAADMWard,PAADMBed,PAADMRoom,PAADMCProv,Accept,Reject,UndoRej,Collect,UndoAccept,Pack,Enquire,Status,Drugs,NONFormulary,OEORIExec,PrescDate,PrescTime,HighPRIO,prioCOL,PAPMIName3,PAPMIName4,PAPMIName5,PAPMIName6,PAPMIName7,PAPMIName8,CollByUserDR,CollByPatRep,VIPStatus,diaglist,ReFill,CanDo,pSDate,pEDate,Check")
{
}

Query PrescAlert(TSRTITM, TSRTORD, PrescNo As %String, OrdID As %String, OEOrdExecID As %String) As %Library.Query(CONTAINID = 1, ROWSPEC = "RowId,OVERREAS,rego,PAPMIName,PAPMIName2,PAPMIDOB,pno,drugname,ordname,altype,typ,sevdesc,allcatdesc,desc,sevPRIO,sevCOL,sevOVRIDE,SevMonoDR,VIPStatus,oeorirowid,interactArcimDR,PatientID,EpisodeID,MRAdm")
{
}

Query PrescItems(TSRTITM, TSRTORD, PrescNo As %String, ADMINDateFrom As %String, ADMINDateTo As %String, ADMINTimeFrom As %String, ADMINTimeTo As %String) As %Library.Query(CONTAINID = 1, ROWSPEC = "RowID,rego,PAPMIName,PAPMIName2,PAPMIDOB,PrescNo,OEORIEpisodeID,MRAdm,drugname,NONFormulary,ordername,ArcimDR,ProcNotes,Remarks,inci,batchid,batchtaken,batchPACK,batchPICK,seq,quan,frm,frmDESC,instr,instrDESC,TotDose,Dosage,freq,freqDESC,prio,prioDESC,prioLEVEL,prioCOL,dur,durDESC,Status,StatusDESC,uom,uomDESC,OEORIExec,qtypack,qtycoll,PrescStat,PrescStatDESC,ActionOK,CanChgItem,CanChgBatch,refundqty,refundreas,returntostock,CollByUserDR,CollByPatRep,InstrICON,Refill,checkPack,VIPStatus,LastUpdateUserDR,LastUpdateDate,LastUpdateTime,DoseBaseUOM,DoseBaseUOMDESC,Repeat,unitcost,manufID,ManufactureLink,epout,PackOverReas")
{
}

Query SubstItem(TSRTITM, TSRTORD, OrdItem As %String = "") As %Library.Query(CONTAINID = 1, ROWSPEC = "HIDDEN,ItemName")
{
}

Query FindBatchesByLoc(ArcimDR, Loc As %String, OrdID As %String) As %Library.Query(CONTAINID = 1, ROWSPEC = "HIDDEN,Batch,Exp,Avail,HIDDEN")
{
}

Query FindBatchesPicked(OrderID As %String) As %Library.Query(CONTAINID = 1, ROWSPEC = "RowID,batch,batchnum,taken,avail,negOK")
{
}

Query LookupAdminBatches(ExeID As %String) As %Library.Query(CONTAINID = 1, ROWSPEC = "BatchID,BatchName,Avail")
{
}

Query FindAdminDispensing(OEOrdExec As %String) As %Library.Query(CONTAINID = 1, ROWSPEC = "ExpDate,BatchID,BatchName,Avail,DispID,Taken")
{
}

Query FindPrescByEpis(PatientID As %String, EpisodeID As %String) As %Library.Query(CONTAINID = 1, ROWSPEC = "PrescNo,ordername,frmDESC,quan,uomDESC,prioDESC,PrescStatDESC,ProcNotes,RowID,Refill,drugname,RepeatNum,MaxRepeat,StartDate,EndDate,Duration,ArcimDR,OEORIEpisodeID,MRAdm")
{
}

ClassMethod FindPrescByEpisClose(ByRef QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindPrescByEpisFetch ]
{
}

ClassMethod FindPrescByEpisExecute(ByRef QHandle As %Library.Binary, PatientID As %String, EpisodeID As %String) As %Library.Status
{
}

ClassMethod FindPrescByEpisFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Library.Status [ PlaceAfter = FindPrescByEpisExecute ]
{
}

/// 60447
ClassMethod ListDrugs(OrderIDs As %String = "")
{
}

Query LookUpQueues(type, val) As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "Description,Code,HIDDEN")
{
SELECT Description, Code, StoredValue
FROM websys.StandardTypeItem
WHERE ParRef=:type 
AND Description %STARTSWITH :val
AND StoredValue<>'T'
}

/// zhaocz 2011-06-17 add
ClassMethod LookUpQueuesBroker(itmjs As %Library.String, itmjsex As %Library.String = "", type As %Library.String = "", val As %Library.String = "") As %Library.Boolean
{
	n id,code,desc
	;
	s (id,code,desc)=""
	;
	; Try and find a matching code
	
	&sql(SELECT Description, Code, StoredValue
		 INTO :desc,:code ,:id
		FROM websys.StandardTypeItem
		WHERE ParRef=:type AND Description = :val AND StoredValue<>'T'
	)
	;
	; Try and find a matching description
	i '$l($g(id)) {
		&sql(SELECT Description ,Code,StoredValue INTO :desc,:code, :id 
			FROM websys.StandardTypeItem 
			WHERE ParRef=:type AND Code = :val AND StoredValue<>'T'
		)
	}
	;
	i ('SQLCODE){
		s retval=itmjs_"('"_$ZCVT(desc,"O","JS")_"');"
		i itmjsex'="""" s retval=retval_itmjsex_"('"_$ZCVT(desc,"O","JS")_"^"_$ZCVT(code,"O","JS")_"^"_id_"');"
		&javascript<#(retval)#>
	}
	
	i SQLCODE q 0
	
	q 1
}

/// / Broker for handling picking by barcode scan.
ClassMethod ScanPickBroker(string As %Library.String = "") As %Library.Boolean
{
}

ClassMethod EndDate1(oeitm)
{
}

}
