/// CTOR: QP
/// DATE: 2020-06-11
/// DESC: 化疗组项目
Class DHCDoc.Chemo.CFG.Item Extends DHCDoc.Util.RegisteredObject [ ProcedureBlock ]
{

/// CTOR: QP
/// DATE: 2020-04-28
/// DESC: 保存模板化疗组项目
/// IN  : 
/// OUT : 
/// EXEC: w ##class(DHCDoc.Chemo.CFG.Item).SaveTPLGroupItem(^TEMP("hh",22),^TEMP("hh",11))
ClassMethod SaveTPLGroupItem(TPGID As %String, mList As %String, importObj As DHCDoc.Chemo.Model.ImportTPL = "")
{
	i importObj="" {
		s id=$p(mList,"^",1)
		s arcim=$p(mList,"^",2)
		s dosage=$p(mList,"^",3)
		s dosageUom=$p(mList,"^",4)
		s freq=$p(mList,"^",5)
		s instruc=$p(mList,"^",6)
		s dura=$p(mList,"^",7)
		s qty=$p(mList,"^",8)
		s uom=$p(mList,"^",9)
		s linkitem=$p(mList,"^",10)
		s note=$p(mList,"^",11)
		s prior=$p(mList,"^",12)
		s simple=$p(mList,"^",13)
		s remark=$p(mList,"^",14)
		s recloc=$p(mList,"^",15)
		s stage=$p(mList,"^",16)
		s flowrate=$p(mList,"^",17)
		s flowrateDR=$p(mList,"^",18)
		s skinTest=$p(mList,"^",19)
		s skinAction=$p(mList,"^",20)
		s mainDrug=$p(mList,"^",21)
		s formula=$p(mList,"^",22)
		s bsaUnitSTD=$p(mList,"^",23)
		s bsaUnit=$p(mList,"^",24)
		s MainDrugNote=$p(mList,"^",25)
		s ShowDate=$p(mList,"^",26)
	} else {
		s id=""
		s arcim=importObj.TIArcim
		s dosage=importObj.TIDose
		s dosageUom=importObj.TIDoseUom
		s freq=importObj.TIFreq
		s instruc=importObj.TIInstruc
		s dura=importObj.TIDura
		s qty=importObj.TIQty
		s uom=importObj.TIUom
		s linkitem=importObj.TILink
		s note=importObj.TINote
		s prior=importObj.TIPrior
		s simple=""
		s remark=""
		s recloc=importObj.TIRecLoc
		s stage=""
		s flowrate=importObj.TISpeed
		s flowrateDR=importObj.TISpeedUom
		s skinTest=""
		s skinAction=""
		s mainDrug=importObj.TIMainDrug
		s formula=importObj.TIFormula
		s bsaUnitSTD=importObj.TISTValue
		s bsaUnit=importObj.TIInput
		s MainDrugNote=""
		s ShowDate=importObj.TIShowDate
		/*
		w "TPGID: "_TPGID,!
		w "arcim："_arcim,!
		w "dosage："_dosage,!
		w "dosageUom："_dosageUom,!
		w "freq："_freq,!
		w "instruc："_instruc,!
		w "dura："_dura,!
		w "qty："_qty,!
		w "uom："_uom,!
		w "note："_note,!
		w "prior："_prior,!
		*/
	}
	
	s cDate=+$h
	s cTime=$p($h,",",2)
	//s hasFlag=..HasConfig(TPID,mList)
	//q:hasFlag'=0 hasFlag
	i id="" {
		s a=##class(User.ChemoTemplateItem).%New(TPGID)
	} else {
		s a=##class(User.ChemoTemplateItem).%OpenId(id)
	}
	d a.TPGIParrefSetObjectId(TPGID)
	d a.TPGIArcimDRSetObjectId(arcim)
	s a.TPGIDosage=dosage
	d a.TPGIDosageUomDRSetObjectId(dosageUom)
	d a.TPGIFreqDRSetObjectId(freq)
	d a.TPGIInstrucDRSetObjectId(instruc)
	d a.TPGIDuratDRSetObjectId(dura)
	s a.TPGIQty=qty
	d a.TPGIUomDRSetObjectId(uom)
	s a.TPGILinkItem=linkitem
	s a.TPGINote=note
	d a.TPGIPriorDRSetObjectId(prior)
	s a.TPGISimpleDR=simple
	s a.TPGIRemark=remark
	d a.TPGIRecLocSetObjectId(recloc)
	s a.TPGIStage=stage
	s a.TPGIFlowRate=flowrate
	d a.TPGIFlowRateDRSetObjectId(flowrateDR)
	s a.TPGISkinTest=skinTest
	d a.TPGISkinActionSetObjectId(skinAction)
	s a.TPGIMainDrug=mainDrug
	s a.TPGIFormula=formula
	s a.TPGIBSAUnitSTD=bsaUnitSTD
	s a.TPGIBSAUnit=bsaUnit
	s a.TPGIMainDrugNote=MainDrugNote
	s a.TPGIShowDate=ShowDate
	s sc=a.%Save()
	If $$$ISERR(sc) {
		d $system.OBJ.DisplayError(sc) 
		Quit "-106"
	}
	
	Q 0
}

/// CTOR: QP
/// DATE: 2020-04-28
/// DESC: 删除化疗项目
/// IN  : 
/// OUT : 
/// EXEC: w ##class(DHCDoc.Chemo.CFG.Item).DeleteTPLGroupItem("")
ClassMethod DeleteTPLGroupItem(TPGIID As %String)
{
	Q:TPGIID="" 0
	&SQL(DELETE FROM SQLUser.Chemo_TemplateItem WHERE TPGI_ID=:TPGIID)
	Q:SQLCODE'=0 "-107"
	
	Q 0
}

/// CTOR: QP
/// DATE: 2020-04-28
/// DESC: 是否存在
/// IN  : 
/// OUT : 
/// EXEC: w ##class(DHCDoc.THPY.CFG.TplGroup).HasConfig(3,"^1^t+1^1^第1组^t+1,t+3^Y^1^111")
ClassMethod HasConfig(TPID As %String, mList As %String)
{
	s mRtn=0
	
	Q mRtn
}

/// CTOR: QP
/// DATE: 2020-04-28
/// DESC: 查询模板化疗组项目
/// IN  : 
/// OUT :    
/// EXEC: d ##class(%ResultSet).RunQuery("DHCDoc.Chemo.CFG.Item","QryTPLGroupItem","5||1||1")
Query QryTPLGroupItem(TPGID = "") As %Query(ROWSPEC = "id,TPGIID,PGIID,arcim,arcimDesc,dosage,dosageUomDR,dosageUomDesc,freqDR,freqDesc,instrucDR,instrucDesc,duratDR,duratDesc,qty,uomDR,uomDesc,linkItem,note,priorDR,priorDesc,simpleDR,remark,remarkDr,recLoc,recLocDesc,stage,stageCode,flowRate,flowRateDR,flowRateID,skinTest,skinAction,skinActionId,mainDrug,formula,HDID,HospDose,BSAUnit,ManuFactor,BSAUnitSTD,LinkSymbol,MainDrugNote,ShowDate,Seqno,simpleDesc")
{
}

ClassMethod QryTPLGroupItemExecute(ByRef qHandle As %Binary, TPGID = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	Set ind=1
 	if (TPGID="") {
	 	Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	s TPID=$p(TPGID,"||",1)
	s TSID=$p(TPGID,"||",2)
	s Sub=$p(TPGID,"||",3)
	k PLIST,HLIST
	s HospID=$p(^CF.DOC.Chemo.TemplateD(TPID),"^",17)
	s HNum=0,PNum=0
	s id=0
 	f  s id=$o(^CF.DOC.Chemo.TemplateD(TPID,TSID,Sub,id)) q:id=""  d
 	.s TPGIID=TPGID_"||"_id
 	.s PGIID=""
 	.s arcim=$p(^CF.DOC.Chemo.TemplateD(TPID,TSID,Sub,id),"^",1)
 	.s HDID=""
 	.S HospDose=""
 	.s arc=+arcim,ver=$p(arcim,"||",2)
 	.s arcimDesc=$p(^ARCIM(arc,ver,1),"^",2)
 	.s dosage=$p(^CF.DOC.Chemo.TemplateD(TPID,TSID,Sub,id),"^",2)
 	.s dosage=##class(DHCDoc.Chemo.COM.Func2).ComDealToNum(dosage)
 	.s dosageUomDR=$p(^CF.DOC.Chemo.TemplateD(TPID,TSID,Sub,id),"^",3)
 	.s (dosageUomDesc,freqDesc,instrucDesc,duratDesc,uomDesc,priorDesc,recLocDesc)=""
 	.i dosageUomDR'="" s dosageUomDesc=$p(^CT("UOM",dosageUomDR),"^",2)
 	.s freqDR=$p(^CF.DOC.Chemo.TemplateD(TPID,TSID,Sub,id),"^",4)
 	.i freqDR'="" s freqDesc=$p(^PHCFR(freqDR),"^",3)
 	.s instrucDR=$p(^CF.DOC.Chemo.TemplateD(TPID,TSID,Sub,id),"^",5)
 	.i instrucDR'="" s instrucDesc=$p(^PHCIN(instrucDR),"^",2)
 	.s duratDR=$p(^CF.DOC.Chemo.TemplateD(TPID,TSID,Sub,id),"^",6)
 	.i duratDR'="" s duratDesc=$p(^PHCDU(duratDR),"^",3)
 	.s qty=$p(^CF.DOC.Chemo.TemplateD(TPID,TSID,Sub,id),"^",7)
 	.s qty=##class(DHCDoc.Chemo.COM.Func2).ComDealToNum(qty)
 	.s uomDR=$p(^CF.DOC.Chemo.TemplateD(TPID,TSID,Sub,id),"^",8)
 	.i uomDR'="" s uomDesc=$p(^CT("UOM",uomDR),"^",2)
 	.s linkItem=$p(^CF.DOC.Chemo.TemplateD(TPID,TSID,Sub,id),"^",9)
 	.s note=$p(^CF.DOC.Chemo.TemplateD(TPID,TSID,Sub,id),"^",10)
 	.s priorDR=$p(^CF.DOC.Chemo.TemplateD(TPID,TSID,Sub,id),"^",11)
 	.i priorDR'="" s priorDesc=$p(^OECPR(priorDR),"^",2)
 	.s simpleDR=$p(^CF.DOC.Chemo.TemplateD(TPID,TSID,Sub,id),"^",12)
 	.s simpleDesc=##class(DHCDoc.Chemo.COM.CallMethod).GetSampleDesc(simpleDR,HospID)
 	.s remarkDr=$p(^CF.DOC.Chemo.TemplateD(TPID,TSID,Sub,id),"^",13)
 	.s remark=##class(DHCDoc.Chemo.COM.Func).GetOrderPriorRemarks(remarkDr)
 	.s recLoc=$p(^CF.DOC.Chemo.TemplateD(TPID,TSID,Sub,id),"^",14)
 	.i recLoc'="" s recLocDesc=$p(^CTLOC(recLoc),"^",2)
 	.s stageCode=$p(^CF.DOC.Chemo.TemplateD(TPID,TSID,Sub,id),"^",15)
 	.s stage=##class(DHCDoc.Chemo.COM.Func).GetOrderStage(stageCode)
 	.s flowRate=$p(^CF.DOC.Chemo.TemplateD(TPID,TSID,Sub,id),"^",16)
 	.s flowRateID=$p(^CF.DOC.Chemo.TemplateD(TPID,TSID,Sub,id),"^",17)
 	.s flowRateDR=""
 	.i flowRateID'="" s flowRateDR=$p(^OEC("SFR",flowRateID),"^",2)
 	.s skinTest=$p(^CF.DOC.Chemo.TemplateD(TPID,TSID,Sub,id),"^",18)
 	.s skinActionId=$p(^CF.DOC.Chemo.TemplateD(TPID,TSID,Sub,id),"^",19)
 	.s skinAction=""
 	.i skinActionId'="" s skinAction=$p(^OEC("ACT",skinActionId),"^",2)
 	.s mainDrug=$p(^CF.DOC.Chemo.TemplateD(TPID,TSID,Sub,id),"^",20)
 	.s formula=$p(^CF.DOC.Chemo.TemplateD(TPID,TSID,Sub,id),"^",21)
 	.s BSAUnit=$p(^CF.DOC.Chemo.TemplateD(TPID,TSID,Sub,id),"^",23)
 	.s BSAUnitSTD=$p(^CF.DOC.Chemo.TemplateD(TPID,TSID,Sub,id),"^",22)
 	.s MainDrugNote=$p(^CF.DOC.Chemo.TemplateD(TPID,TSID,Sub,id),"^",24)
 	.s ShowDate=$p(^CF.DOC.Chemo.TemplateD(TPID,TSID,Sub,id),"^",25)
 	.s Seqno=$p(^CF.DOC.Chemo.TemplateD(TPID,TSID,Sub,id),"^",26)
 	.s ManuFactor=##class(DHCDoc.Chemo.COM.CallMethod).GetManuFactor(arcim)
 	.s LinkSymbol=""
 	.s Data=$lb(id,TPGIID,PGIID,arcim,arcimDesc,dosage,dosageUomDR,dosageUomDesc,freqDR,freqDesc,instrucDR,instrucDesc,duratDR,duratDesc,qty,uomDR,uomDesc,linkItem,note,priorDR,priorDesc,simpleDR,remark,remarkDr,recLoc,recLocDesc,stage,stageCode,flowRate,flowRateDR,flowRateID,skinTest,skinAction,skinActionId,mainDrug,formula,HDID,HospDose,BSAUnit,ManuFactor,BSAUnitSTD,LinkSymbol,MainDrugNote,ShowDate,Seqno,simpleDesc)
 	.i Seqno'="" d
 	..s PNum=PNum+1
 	..s PLIST(Seqno)=Data
 	.e  d
 	..s HNum=HNum+1
 	..s HLIST(HNum)=Data
 	
 	//整合HLIST到PLIST中
 	f i=1:1:HNum d
 	.s NewSeqno=PNum+i 
 	.s $list(HLIST(i),45)=NewSeqno
 	.s PLIST(NewSeqno)=HLIST(i)
	.;更新序号
	.s id=$lg(HLIST(i),2)
	.d ..ChgSeqno(id,NewSeqno)
 	
 	//顺序输出
 	s seqno=""
 	f  s seqno=$o(PLIST(seqno)) q:seqno=""  d
 	.s outData=PLIST(seqno)
 	.d output1
 	
 	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
output1
	//Set Data=$lb(id,TPGIID,PGIID,arcim,arcimDesc,dosage,dosageUomDR,dosageUomDesc,freqDR,freqDesc,instrucDR,instrucDesc,duratDR,duratDesc,qty,uomDR,uomDesc,linkItem,note,priorDR,priorDesc,simpleDR,remark,remarkDr,recLoc,recLocDesc,stage,stageCode,flowRate,flowRateDR,flowRateID,skinTest,skinAction,skinActionId,mainDrug,formula,HDID,HospDose,BSAUnit,ManuFactor,BSAUnitSTD,LinkSymbol,MainDrugNote,ShowDate,Seqno)
	Set Data=outData
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Quit $$$OK
}

ClassMethod QryTPLGroupItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryTPLGroupItemExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryTPLGroupItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryTPLGroupItemExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// CTOR: QP
/// DATE: 2020-10-14
/// DESC: 查询所有化疗项目
/// IN  : 
/// OUT :    
/// EXEC: d ##class(%ResultSet).RunQuery("DHCDoc.Chemo.CFG.Item","QryAllItem","4||1","","157","280","12175^29^113^2^^20")
/// 
/// d ##class(%ResultSet).RunQuery("DHCDoc.Chemo.CFG.Item","QryAllItem","193||1","","34","1527","12213^28^4^2^undefined^20")
Query QryAllItem(PSID = "", SelectDate = "", PatientID = "", EpisodeID = "", SessionStr = "") As %Query(ROWSPEC = "id,TPGIID,PGIID,arcim,arcimDesc,dosage,dosageUomDR,dosageUomDesc,freqDR,freqDesc,instrucDR,instrucDesc,duratDR,duratDesc,qty,uomDR,uomDesc,linkItem,note,priorDR,priorDesc,simpleDR,remark,remarkDr,recLoc,recLocDesc,stage,stageCode,flowRate,flowRateDR,flowRateID,skinTest,skinAction,skinActionId,mainDrug,formula,HDID,HospDose,BSAUnit,ManuFactor,BSAUnitSTD,LinkSymbol,MainDrugNote,ShowDate,GroupType,GroupTypeId,OeoriDR,initdosage,OrderDoseQtyNurese")
{
}

ClassMethod QryAllItemExecute(ByRef qHandle As %Binary, PSID = "", SelectDate = "", PatientID = "", EpisodeID = "", SessionStr = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	Set ind=1
 	if (PSID="") {
	 	Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	s TPID=$p(PSID,"||",1)
	s TSID=$p(PSID,"||",2)
	s ^QP("hh")=$lb(PSID , SelectDate , PatientID, EpisodeID , SessionStr )
	s langid=..%LanguageID()
	//序号要么全有，要么全都没有
	s HasSeqno=0
	k PLIST
	s Sub=0
 	f  s Sub=$o(^CF.DOC.Chemo.TemplateD(TPID,TSID,Sub)) q:Sub=""  d
 	.s TPGID=PSID_"||"_Sub
 	.s GroupTypeId=$p(^CF.DOC.Chemo.TemplateD(TPID,TSID,Sub),"^",2)
	.s df=$p(GroupTypeId,"||",1),ch=$p(GroupTypeId,"||",2)
	.s GroupType=$p(^DHCDocCT("DefineData",df,"D",ch),"^",2)
	.s GroupType=##class(User.ChemoTemplateGroup).GetTranByDesc("TPGDesc",GroupType,langid)
 	.s id=0
 	.f  s id=$o(^CF.DOC.Chemo.TemplateD(TPID,TSID,Sub,id)) q:id=""  d
 	..s TPGIID=TPGID_"||"_id
	..s PGIID=""
 	..s arcim=$p(^CF.DOC.Chemo.TemplateD(TPID,TSID,Sub,id),"^",1)
 	..s HDID=""
 	..S HospDose=""
 	..s arc=+arcim,ver=$p(arcim,"||",2)
 	..s arcimDesc=$p(^ARCIM(arc,ver,1),"^",2)
 	..s arcimDesc= ##class(User.ARCItmMast).GetTranByDesc("ARCIMDesc",arcimDesc,langid)
 	..s dosage=$p(^CF.DOC.Chemo.TemplateD(TPID,TSID,Sub,id),"^",2)
 	..s dosage=##class(DHCDoc.Chemo.COM.Func2).ComDealToNum(dosage)
 	..s OrderDoseQtyNurese=""
 	..s dosageUomDR=$p(^CF.DOC.Chemo.TemplateD(TPID,TSID,Sub,id),"^",3)
 	..s (dosageUomDesc,freqDesc,instrucDesc,duratDesc,uomDesc,priorDesc,recLocDesc)=""
 	..i dosageUomDR'="" s dosageUomDesc=$p(^CT("UOM",dosageUomDR),"^",2)
 	..s dosageUomDesc= ##class(User.CTUOM).GetTranByDesc("CTUOMDesc",dosageUomDesc,langid)
 	..s freqDR=$p(^CF.DOC.Chemo.TemplateD(TPID,TSID,Sub,id),"^",4)
 	..i freqDR'="" s freqDesc=$p(^PHCFR(freqDR),"^",3)
 	..s freqDesc= ##class(User.PHCFreq).GetTranByDesc("PHCFRDesc1",freqDesc,langid)
 	..s instrucDR=$p(^CF.DOC.Chemo.TemplateD(TPID,TSID,Sub,id),"^",5)
 	..s instrucDesc=""
 	..i instrucDR'="" d
 	...q:'$d(^PHCIN(instrucDR))
 	...s instrucDesc=$p($g(^PHCIN(instrucDR)),"^",2)
 	...s instrucDesc= ##class(User.PHCInstruc).GetTranByDesc("PHCINDesc1",instrucDesc,langid)
 	..s duratDR=$p(^CF.DOC.Chemo.TemplateD(TPID,TSID,Sub,id),"^",6)
 	..i duratDR'="" s duratDesc=$p(^PHCDU(duratDR),"^",3)
 	..s duratDesc= ##class(User.PHCDuration).GetTranByDesc("PHCDUDesc1",duratDesc,langid)
 	..s qty=$p(^CF.DOC.Chemo.TemplateD(TPID,TSID,Sub,id),"^",7)
 	..s qty=##class(DHCDoc.Chemo.COM.Func2).ComDealToNum(qty)
 	..s uomDR=$p(^CF.DOC.Chemo.TemplateD(TPID,TSID,Sub,id),"^",8)
 	..i uomDR'="" s uomDesc=$p(^CT("UOM",uomDR),"^",2)
 	..s uomDesc= ##class(User.CTUOM).GetTranByDesc("CTUOMDesc",uomDesc,langid)
 	..s linkItem=$p(^CF.DOC.Chemo.TemplateD(TPID,TSID,Sub,id),"^",9)
 	..s note=$p(^CF.DOC.Chemo.TemplateD(TPID,TSID,Sub,id),"^",10)
 	..s priorDR=$p(^CF.DOC.Chemo.TemplateD(TPID,TSID,Sub,id),"^",11)
 	..i priorDR'="" s priorDesc=$p(^OECPR(priorDR),"^",2)
 	..s priorDesc= ##class(User.OECPriority).GetTranByDesc("OECPRDesc",priorDesc,langid)
 	..s simpleDR=$p(^CF.DOC.Chemo.TemplateD(TPID,TSID,Sub,id),"^",12)
 	..s remarkDr=$p(^CF.DOC.Chemo.TemplateD(TPID,TSID,Sub,id),"^",13)
 	..s remark=##class(DHCDoc.Chemo.COM.Func).GetOrderPriorRemarks(remarkDr)
 	..s recLoc=$p(^CF.DOC.Chemo.TemplateD(TPID,TSID,Sub,id),"^",14)
 	..i recLoc'="" s recLocDesc=$p(^CTLOC(recLoc),"^",2)
 	..s recLocDesc= ##class(User.CTLoc).GetTranByDesc("CTLOCDesc",recLocDesc,langid)
 	..s stageCode=$p(^CF.DOC.Chemo.TemplateD(TPID,TSID,Sub,id),"^",15)
 	..s stage=##class(DHCDoc.Chemo.COM.Func).GetOrderStage(stageCode)
 	..s flowRate=$p(^CF.DOC.Chemo.TemplateD(TPID,TSID,Sub,id),"^",16)
 	..s flowRateID=$p(^CF.DOC.Chemo.TemplateD(TPID,TSID,Sub,id),"^",17)
 	..s flowRateDR=""
 	..i flowRateID'="" s flowRateDR=$p(^OEC("SFR",flowRateID),"^",2)
 	..s flowRateDR= ##class(User.OECSpeedFlowRate).GetTranByDesc("SFRDesc",flowRateDR,langid)
 	..s skinTest=$p(^CF.DOC.Chemo.TemplateD(TPID,TSID,Sub,id),"^",18)
 	..s skinActionId=$p(^CF.DOC.Chemo.TemplateD(TPID,TSID,Sub,id),"^",19)
 	..s skinAction=""
 	..i skinActionId'="" s skinAction=$p(^OEC("ACT",skinActionId),"^",2)
 	..s mainDrug=$p(^CF.DOC.Chemo.TemplateD(TPID,TSID,Sub,id),"^",20)
 	..s formula=$p(^CF.DOC.Chemo.TemplateD(TPID,TSID,Sub,id),"^",21)
 	..s BSAUnit=$p(^CF.DOC.Chemo.TemplateD(TPID,TSID,Sub,id),"^",23)
 	..s BSAUnitSTD=$p(^CF.DOC.Chemo.TemplateD(TPID,TSID,Sub,id),"^",22)
 	..s MainDrugNote=$p(^CF.DOC.Chemo.TemplateD(TPID,TSID,Sub,id),"^",24)
 	..s ShowDate=$p(^CF.DOC.Chemo.TemplateD(TPID,TSID,Sub,id),"^",25)
 	..s Seqno=$p(^CF.DOC.Chemo.TemplateD(TPID,TSID,Sub,id),"^",26)
 	..s ManuFactor=##class(DHCDoc.Chemo.COM.CallMethod).GetManuFactor(arcim)
 	..s LinkSymbol=""
 	..s initdosage=""
 	..s OeoriDR=""
 	..i (dosage="")&&(BSAUnit'="")&&(formula'="")&&(EpisodeID'="") d
 	...s dosage=##class(DHCDoc.Chemo.COM.Func2).CaclDoseByFormula(PatientID, EpisodeID, formula, BSAUnit)
 	..i (qty="")&&(SessionStr'="") d
 	...s qty=##class(DHCDoc.Chemo.COM.Func2).CalcPackQty(EpisodeID, TPGIID, "TPL", SessionStr,dosage)
 	..s Data=$lb(id,TPGIID,PGIID,arcim,arcimDesc,dosage,dosageUomDR,dosageUomDesc,freqDR,freqDesc,instrucDR,instrucDesc,duratDR,duratDesc,qty,uomDR,uomDesc,linkItem,note,priorDR,priorDesc,simpleDR,remark,remarkDr,recLoc,recLocDesc,stage,stageCode,flowRate,flowRateDR,flowRateID,skinTest,skinAction,skinActionId,mainDrug,formula,HDID,HospDose,BSAUnit,ManuFactor,BSAUnitSTD,LinkSymbol,MainDrugNote,ShowDate,GroupType,GroupTypeId,OeoriDR,initdosage,OrderDoseQtyNurese)
 	..S outData=Data
 	..i Seqno'="" d
 	...s HasSeqno=1
 	...s PLIST(TPGIID,Seqno)=Data
 	..e  d
 	...d output2
	
	s TPGIID=""
	f  s TPGIID=$O(PLIST(TPGIID)) q:TPGIID=""  d
	.s Seqno=""
	.f  s Seqno=$o(PLIST(TPGIID,Seqno)) q:Seqno=""  d
	..s outData=PLIST(TPGIID,Seqno)
	..d output2
	
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
output2
	//Set Data=$lb(id,TPGIID,PGIID,arcim,arcimDesc,dosage,dosageUomDR,dosageUomDesc,freqDR,freqDesc,instrucDR,instrucDesc,duratDR,duratDesc,qty,uomDR,uomDesc,linkItem,note,priorDR,priorDesc,simpleDR,remark,remarkDr,recLoc,recLocDesc,stage,stageCode,flowRate,flowRateDR,flowRateID,skinTest,skinAction,skinActionId,mainDrug,formula,HDID,HospDose,BSAUnit,ManuFactor,BSAUnitSTD,LinkSymbol,MainDrugNote,ShowDate,GroupType,GroupTypeId,OeoriDR)
	Set Data=outData
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Quit $$$OK
}

ClassMethod QryAllItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryAllItemExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryAllItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryAllItemExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// CTOR: QP
/// DATE: 2020-04-28
/// DESC: 变更显示顺序
/// IN  : 
/// OUT : 
/// EXEC: w ##class(DHCDoc.Chemo.CFG.Item).DeleteTPLGroupItem("")
ClassMethod ChgSeqno(TPGIID As %String, seqno As %String)
{
	Q:(TPGIID="")||(seqno="") 0
	&SQL(UPDATE SQLUser.Chemo_TemplateItem SET TPGI_Seqno=:seqno WHERE TPGI_ID=:TPGIID)
	
	Q SQLCODE
}

/// CTOR: QP
/// DATE: 2020-12-15
/// DESC: 上调/下调
/// IN  : 
/// OUT : 
/// EXEC: w ##class(DHCDoc.Chemo.CFG.Stage).Delete("")
ClassMethod UpItem(oldID, oldSeqno, preID, preSeqno)
{
	Q:(oldID="")||(oldSeqno="")||(preID="")||(preSeqno="") 0
	&SQL(UPDATE SQLUser.Chemo_TemplateItem SET TPGI_Seqno=:preSeqno WHERE TPGI_ID=:oldID)
	Q:SQLCODE'=0 "-157"
	&SQL(UPDATE SQLUser.Chemo_TemplateItem SET TPGI_Seqno=:oldSeqno WHERE TPGI_ID=:preID)
	Q:SQLCODE'=0 "-157"
	
	Q 0
}

}
