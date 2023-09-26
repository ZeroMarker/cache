/// CTOR: QP
/// DATE: 2020-06-17
/// DESC: 化疗单项目
Class DHCDoc.Chemo.BS.Item Extends DHCDoc.Util.RegisteredObject [ ProcedureBlock ]
{

/// CTOR: QP
/// DATE: 2020-05-13
/// DESC: 查询化疗组项目
/// IN  : 
/// OUT :    
/// EXEC: d ##class(%ResultSet).RunQuery("DHCDoc.Chemo.BS.Item","QryGroupItem","83||1||6")
Query QryGroupItem(TPGID = "") As %Query(ROWSPEC = "id,TPGIID,PGIID,arcim,arcimDesc,dosage,dosageUomDR,dosageUomDesc,freqDR,freqDesc,instrucDR,instrucDesc,duratDR,duratDesc,qty,uomDR,uomDesc,linkItem,note,priorDR,priorDesc,simpleDR,remark,remarkDr,recLoc,recLocDesc,stage,stageCode,flowRate,flowRateDR,flowRateID,skinTest,skinAction,skinActionId,BSAUnit,BSA,formula,HDID,HospDose,ManuFactor,BSAUnitSTD,LinkSymbol")
{
}

ClassMethod QryGroupItemExecute(ByRef qHandle As %Binary, TPGID = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	Set ind=1
 	if (TPGID="") {
	 	Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	s ^TEMP("HH",1)=TPGID
	k ^BS.DOC.Chemo.TEMPData
	s TPID=$p(TPGID,"||",1)
	s SID=$p(TPGID,"||",2)
	s Sub=$p(TPGID,"||",3)
	S PatientID=$P(^BS.DOC.Chemo.PlanD(TPID),"^",1)
	s id=0
 	f  s id=$o(^BS.DOC.Chemo.PlanD(TPID,SID,Sub,id)) q:id=""  d
 	.s PGIID=TPGID_"||"_id
 	.s arcim=$p(^BS.DOC.Chemo.PlanD(TPID,SID,Sub,id),"^",1)
 	.s HDID=##class(DHCDoc.Chemo.BS.HospDose).FindRecord(PatientID,arcim)
 	.s HospDose=""
 	.i HDID'="" s HospDose=$p(^BS.DOC.Chemo.HospDoseD(HDID),"^",4)
 	.s arc=+arcim,ver=$p(arcim,"||",2)
 	.s arcimDesc=$p(^ARCIM(arc,ver,1),"^",2)
 	.s dosage=$p(^BS.DOC.Chemo.PlanD(TPID,SID,Sub,id),"^",2)
 	.s dosage=##class(DHCDoc.Chemo.COM.Func2).ComDealToNum(dosage)
 	.s dosageUomDR=$p(^BS.DOC.Chemo.PlanD(TPID,SID,Sub,id),"^",3)
 	.s (dosageUomDesc,freqDesc,instrucDesc,duratDesc,uomDesc,priorDesc,recLocDesc)=""
 	.i dosageUomDR'="" s dosageUomDesc=$p(^CT("UOM",dosageUomDR),"^",2)
 	.s freqDR=$p(^BS.DOC.Chemo.PlanD(TPID,SID,Sub,id),"^",4)
 	.i freqDR'="" s freqDesc=$p(^PHCFR(freqDR),"^",3)
 	.s instrucDR=$p(^BS.DOC.Chemo.PlanD(TPID,SID,Sub,id),"^",5)
 	.i instrucDR'="" s instrucDesc=$p(^PHCIN(instrucDR),"^",2)
 	.s duratDR=$p(^BS.DOC.Chemo.PlanD(TPID,SID,Sub,id),"^",6)
 	.i duratDR'="" s duratDesc=$p(^PHCDU(duratDR),"^",3)
 	.s qty=$p(^BS.DOC.Chemo.PlanD(TPID,SID,Sub,id),"^",7)
 	.s uomDR=$p(^BS.DOC.Chemo.PlanD(TPID,SID,Sub,id),"^",8)
 	.i uomDR'="" s uomDesc=$p(^CT("UOM",uomDR),"^",2)
 	.s linkItem=$p(^BS.DOC.Chemo.PlanD(TPID,SID,Sub,id),"^",9)
 	.s note=$p(^BS.DOC.Chemo.PlanD(TPID,SID,Sub,id),"^",10)
 	.s priorDR=$p(^BS.DOC.Chemo.PlanD(TPID,SID,Sub,id),"^",11)
 	.i priorDR'="" s priorDesc=$p(^OECPR(priorDR),"^",2)
 	.s simpleDR=$p(^BS.DOC.Chemo.PlanD(TPID,SID,Sub,id),"^",12)
 	.s remarkDr=$p(^BS.DOC.Chemo.PlanD(TPID,SID,Sub,id),"^",13)
 	.s remark=##class(DHCDoc.Chemo.COM.Func).GetOrderPriorRemarks(remarkDr)
 	.s recLoc=$p(^BS.DOC.Chemo.PlanD(TPID,SID,Sub,id),"^",14)
 	.i recLoc'="" s recLocDesc=$p(^CTLOC(recLoc),"^",2)
 	.s stageCode=$p(^BS.DOC.Chemo.PlanD(TPID,SID,Sub,id),"^",15)
 	.s stage=##class(DHCDoc.Chemo.COM.Func).GetOrderStage(stageCode)
 	.s flowRate=$p(^BS.DOC.Chemo.PlanD(TPID,SID,Sub,id),"^",16)
 	.s flowRateID=$p(^BS.DOC.Chemo.PlanD(TPID,SID,Sub,id),"^",17)
 	.s flowRateDR=""
 	.i flowRateID'="" s flowRateDR=$p(^OEC("SFR",flowRateID),"^",2)
 	.s skinTest=$p(^BS.DOC.Chemo.PlanD(TPID,SID,Sub,id),"^",18)
 	.s skinActionId=$p(^BS.DOC.Chemo.PlanD(TPID,SID,Sub,id),"^",19)
 	.s skinAction=""
 	.i skinActionId'="" s skinAction=$p(^OEC("ACT",skinActionId),"^",2)
 	.s TPGIID=$p(^BS.DOC.Chemo.PlanD(TPID,SID,Sub,id),"^",20)
 	.s BSAUnit=$p(^BS.DOC.Chemo.PlanD(TPID,SID,Sub,id),"^",21)
 	.s BSA=$p(^BS.DOC.Chemo.PlanD(TPID,SID,Sub,id),"^",22)
 	.s formula=$p(^BS.DOC.Chemo.PlanD(TPID,SID,Sub,id),"^",24)
 	.s ManuFactor=##class(DHCDoc.Chemo.COM.CallMethod).GetManuFactor(arcim)
 	.s BSAUnitSTD=$p(^BS.DOC.Chemo.PlanD(TPID,SID,Sub,id),"^",26)
 	.s Seqno=$p(^BS.DOC.Chemo.PlanD(TPID,SID,Sub,id),"^",27)
 	.i Seqno="" s Seqno="999"
 	.s LinkSymbol=##class(DHCDoc.Chemo.COM.Func2).GetLinkSymbol(PGIID,"CUR")
 	.s Data=$lb(id,TPGIID,PGIID,arcim,arcimDesc,dosage,dosageUomDR,dosageUomDesc,freqDR,freqDesc,instrucDR,instrucDesc,duratDR,duratDesc,qty,uomDR,uomDesc,linkItem,note,priorDR,priorDesc,simpleDR,remark,remarkDr,recLoc,recLocDesc,stage,stageCode,flowRate,flowRateDR,flowRateID,skinTest,skinAction,skinActionId,BSAUnit,BSA,formula,HDID,HospDose,ManuFactor,BSAUnitSTD,LinkSymbol)
 	.s ^BS.DOC.Chemo.TEMPData(TPID,SID,Sub,Seqno,id)=Data
	
	s Seqno=""
	f  s Seqno=$o(^BS.DOC.Chemo.TEMPData(TPID,SID,Sub,Seqno)) q:Seqno=""  d
	.s id=""
	.f  s id=$o(^BS.DOC.Chemo.TEMPData(TPID,SID,Sub,Seqno,id)) q:id=""  d
	..s Data=^BS.DOC.Chemo.TEMPData(TPID,SID,Sub,Seqno,id)
 	..d output1
 	
 	k ^BS.DOC.Chemo.TEMPData
 	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
output1
	//Set Data=$lb(id,TPGIID,PGIID,arcim,arcimDesc,dosage,dosageUomDR,dosageUomDesc,freqDR,freqDesc,instrucDR,instrucDesc,duratDR,duratDesc,qty,uomDR,uomDesc,linkItem,note,priorDR,priorDesc,simpleDR,remark,remarkDr,recLoc,recLocDesc,stage,stageCode,flowRate,flowRateDR,flowRateID,skinTest,skinAction,skinActionId,BSAUnit,BSA,formula,HDID,HospDose,ManuFactor,BSAUnitSTD)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Quit $$$OK
}

ClassMethod QryGroupItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryGroupItemExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryGroupItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryGroupItemExecute ]
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
/// DATE: 2020-05-19
/// DESC: 删除化疗项目
/// IN  : 
/// OUT : 
/// EXEC: w ##class(DHCDoc.Chemo.BS.Item).DeleteGroupItem("")
ClassMethod DeleteGroupItem(PGIID As %String)
{
	Q:PGIID="" 0
	&SQL(DELETE FROM SQLUser.Chemo_PlanItem WHERE PGI_ID=:PGIID)
	Q:SQLCODE'=0 "-117"
	//后续还要进行停医嘱操作
	//todo...
	
	Q 0
}

/// CTOR: QP
/// DATE: 2020-05-19
/// DESC: 更新化疗项目医嘱
/// IN  : 
/// OUT : 
/// EXEC: w ##class(DHCDoc.Chemo.BS.Item).UpdateTHPYOeori("")
ClassMethod UpdateTHPYOeori(PGIID As %String, Oeori As %String)
{
	Q:(PGIID="")||(Oeori="") 0
	//&SQL(UPDATE SQLUser.Chemo_PlanItem SET PGI_Oeori=:Oeori WHERE PGI_ID=:PGIID)
	//Q:SQLCODE'=0 "-117"
	
	Q 0
}

/// CTOR: QP
/// DATE: 2020-10-13
/// DESC: 查询周期所有项目
/// IN  : 
/// OUT :    
/// EXEC: d ##class(%ResultSet).RunQuery("DHCDoc.Chemo.BS.Item","QryAllItem","982||1","2021-04-12","4","13","12230^30^104^3^undefined^20")
/// d ##class(%ResultSet).RunQuery("DHCDoc.Chemo.BS.Item","QryAllItem","911||1","","352","1509","12213^28^4^2^undefined^20")
Query QryAllItem(PSID = "", SelectDate = "", PatientID = "", EpisodeID = "", SessionStr = "") As %Query(ROWSPEC = "id,TPGIID,PGIID,arcim,arcimDesc,dosage,dosageUomDR,dosageUomDesc,freqDR,freqDesc,instrucDR,instrucDesc,duratDR,duratDesc,qty,uomDR,uomDesc,linkItem,note,priorDR,priorDesc,simpleDR,remark,remarkDr,recLoc,recLocDesc,stage,stageCode,flowRate,flowRateDR,flowRateID,skinTest,skinAction,skinActionId,BSAUnit,BSA,formula,HDID,HospDose,ManuFactor,BSAUnitSTD,LinkSymbol,GroupType,GroupTypeId,mainDrug,ShowDate,OeoriDR,initdosage,OrderDoseQtyNurese")
{
}

ClassMethod QryAllItemExecute(ByRef qHandle As %Binary, PSID = "", SelectDate = "", PatientID = "", EpisodeID = "", SessionStr = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	Set ind=1
 	S ^QP("QryAllItem")=$LB(PSID , SelectDate , PatientID , EpisodeID , SessionStr )
 	if (PSID="") {
	 	Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	s TempArr("PRE")=1
 	s TempArr("CHEMO")=2
 	s TempArr("POST")=3
 	s TempArr("PRNS")=4
 	s TempArr("PRNGM")=5
 	s TempArr("PRNCOM")=6
 	s TempArr("OTHER")=7
 	s TempArr("OUT")=8
 	s langid=..%LanguageID()
	s TPID=+PSID
	s SID=$p(PSID,"||",2)
	S PatientID=$P(^BS.DOC.Chemo.PlanD(TPID),"^",1)
	s EpisodeID=$P(^BS.DOC.Chemo.PlanD(TPID),"^",6)
	s PDID=##class(DHCDoc.Chemo.BS.Date).GetPDIDByDate(SelectDate,PSID)
	s PDAID=##class(DHCDoc.Chemo.BS.DateApply).GetPDAID(PDID)
	//s CDate=##class(websys.Conversions).DateLogicalToHtml(+$h)
	k ^BS.DOC.Chemo.TEMPData
	s Sub=""
	f  s Sub=$o(^BS.DOC.Chemo.PlanD(TPID,SID,Sub)) q:Sub=""  d
	.s TPGID=PSID_"||"_Sub
	.s GroupTypeId=$p(^BS.DOC.Chemo.PlanD(TPID,SID,Sub),"^",2)
	.s df=$p(GroupTypeId,"||",1),ch=$p(GroupTypeId,"||",2)
	.s GroupType=$p(^DHCDocCT("DefineData",df,"D",ch),"^",2)
	.s GroupType=##class(User.ChemoTemplateGroup).GetTranByDesc("TPGDesc",GroupType,langid)
	.S GroupTypeCode=$p(^DHCDocCT("DefineData",df,"D",ch),"^",1)
	.s ^BS.DOC.Chemo.TEMPData("G",TempArr(GroupTypeCode))=TPGID
	.s id=0
 	.f  s id=$o(^BS.DOC.Chemo.PlanD(TPID,SID,Sub,id)) q:id=""  d
 	..s PGIID=TPGID_"||"_id
 	..s ShowDate=$p(^BS.DOC.Chemo.PlanD(TPID,SID,Sub,id),"^",28)
 	..q:ShowDate=""
 	..q:(SelectDate'="")&&(ShowDate'[SelectDate)
 	..s ShowDate=##class(DHCDoc.Chemo.COM.Func2).ParseToDayNum(PSID,ShowDate)
 	..s arcim=$p(^BS.DOC.Chemo.PlanD(TPID,SID,Sub,id),"^",1)
 	..s HDID=##class(DHCDoc.Chemo.BS.HospDose).FindRecord(PatientID,arcim)
 	..s HospDose=""
 	..i HDID'="" s HospDose=$p(^BS.DOC.Chemo.HospDoseD(HDID),"^",4)
 	..s arc=+arcim,ver=$p(arcim,"||",2)
 	..s arcimDesc=$p(^ARCIM(arc,ver,1),"^",2)
 	..s arcimDesc= ##class(User.ARCItmMast).GetTranByDesc("ARCIMDesc",arcimDesc,langid)
 	..s dosage=$p(^BS.DOC.Chemo.PlanD(TPID,SID,Sub,id),"^",2)
 	..s initdosage=$p(^BS.DOC.Chemo.PlanD(TPID,SID,Sub,id),"^",29)
 	..s initdosage=##class(DHCDoc.Chemo.COM.Func2).ComDealToNum(initdosage)
 	..s dosage=##class(DHCDoc.Chemo.COM.Func2).ComDealToNum(dosage)
 	..s dosageUomDR=$p(^BS.DOC.Chemo.PlanD(TPID,SID,Sub,id),"^",3)
 	..s (dosageUomDesc,freqDesc,instrucDesc,duratDesc,uomDesc,priorDesc,recLocDesc)=""
 	..i dosageUomDR'="" s dosageUomDesc=$p(^CT("UOM",dosageUomDR),"^",2)
 	..s dosageUomDesc= ##class(User.CTUOM).GetTranByDesc("CTUOMDesc",dosageUomDesc,langid)
 	..s freqDR=$p(^BS.DOC.Chemo.PlanD(TPID,SID,Sub,id),"^",4)
 	..i freqDR'="" s freqDesc=$p(^PHCFR(freqDR),"^",3)
 	..s freqDesc= ##class(User.PHCFreq).GetTranByDesc("PHCFRDesc1",freqDesc,langid)
 	..s instrucDR=$p(^BS.DOC.Chemo.PlanD(TPID,SID,Sub,id),"^",5)
 	..i instrucDR'="" s instrucDesc=$p(^PHCIN(instrucDR),"^",2)
 	..s instrucDesc= ##class(User.PHCInstruc).GetTranByDesc("PHCINDesc1",instrucDesc,langid)
 	..s duratDR=$p(^BS.DOC.Chemo.PlanD(TPID,SID,Sub,id),"^",6)
 	..i duratDR'="" s duratDesc=$p(^PHCDU(duratDR),"^",3)
 	..s duratDesc= ##class(User.PHCDuration).GetTranByDesc("PHCDUDesc1",duratDesc,langid)
 	..s qty=$p(^BS.DOC.Chemo.PlanD(TPID,SID,Sub,id),"^",7)
 	..s qty=##class(DHCDoc.Chemo.COM.Func2).ComDealToNum(qty)
 	..s uomDR=$p(^BS.DOC.Chemo.PlanD(TPID,SID,Sub,id),"^",8)
 	..i uomDR'="" s uomDesc=$p(^CT("UOM",uomDR),"^",2)
 	..s uomDesc= ##class(User.CTUOM).GetTranByDesc("CTUOMDesc",uomDesc,langid)
 	..s linkItem=$p(^BS.DOC.Chemo.PlanD(TPID,SID,Sub,id),"^",9)
 	..s note=$p(^BS.DOC.Chemo.PlanD(TPID,SID,Sub,id),"^",10)
 	..s priorDR=$p(^BS.DOC.Chemo.PlanD(TPID,SID,Sub,id),"^",11)
 	..i priorDR'="" s priorDesc=$p(^OECPR(priorDR),"^",2)
 	..s priorDesc= ##class(User.OECPriority).GetTranByDesc("OECPRDesc",priorDesc,langid)
 	..s simpleDR=$p(^BS.DOC.Chemo.PlanD(TPID,SID,Sub,id),"^",12)
 	..s remarkDr=$p(^BS.DOC.Chemo.PlanD(TPID,SID,Sub,id),"^",13)
 	..s remark=##class(DHCDoc.Chemo.COM.Func).GetOrderPriorRemarks(remarkDr)
 	..s recLoc=$p(^BS.DOC.Chemo.PlanD(TPID,SID,Sub,id),"^",14)
 	..i recLoc'="" s recLocDesc=$p(^CTLOC(recLoc),"^",2)
 	..s recLocDesc= ##class(User.CTLoc).GetTranByDesc("CTLOCDesc",recLocDesc,langid)
 	..s stageCode=$p(^BS.DOC.Chemo.PlanD(TPID,SID,Sub,id),"^",15)
 	..s stage=##class(DHCDoc.Chemo.COM.Func).GetOrderStage(stageCode)
 	..s flowRate=$p(^BS.DOC.Chemo.PlanD(TPID,SID,Sub,id),"^",16)
 	..s flowRateID=$p(^BS.DOC.Chemo.PlanD(TPID,SID,Sub,id),"^",17)
 	..s flowRateDR=""
 	..i flowRateID'="" s flowRateDR=$p(^OEC("SFR",flowRateID),"^",2)
 	..s flowRateDR= ##class(User.OECSpeedFlowRate).GetTranByDesc("SFRDesc",flowRateDR,langid)
 	..s skinTest=$p(^BS.DOC.Chemo.PlanD(TPID,SID,Sub,id),"^",18)
 	..s skinActionId=$p(^BS.DOC.Chemo.PlanD(TPID,SID,Sub,id),"^",19)
 	..s skinAction=""
 	..i skinActionId'="" s skinAction=$p(^OEC("ACT",skinActionId),"^",2)
 	..s TPGIID=$p(^BS.DOC.Chemo.PlanD(TPID,SID,Sub,id),"^",20)
 	..s BSAUnit=$p(^BS.DOC.Chemo.PlanD(TPID,SID,Sub,id),"^",21)
 	..s BSA=$p(^BS.DOC.Chemo.PlanD(TPID,SID,Sub,id),"^",22)
 	..s formula=$p(^BS.DOC.Chemo.PlanD(TPID,SID,Sub,id),"^",24)
 	..s ManuFactor=##class(DHCDoc.Chemo.COM.CallMethod).GetManuFactor(arcim)
 	..s BSAUnitSTD=$p(^BS.DOC.Chemo.PlanD(TPID,SID,Sub,id),"^",26)
 	..s mainDrug=$p(^BS.DOC.Chemo.PlanD(TPID,SID,Sub,id),"^",23)
 	..s Seqno=##class(DHCDoc.Chemo.BS.Ext.PlanItemSort).GetSeqno(SelectDate,PGIID)
 	..i Seqno="" s Seqno=$p(^BS.DOC.Chemo.PlanD(TPID,SID,Sub,id),"^",27)
 	..s OeoriDR=##class(DHCDoc.Chemo.BS.Ext.Process).GetOeoriByDay(PGIID,PDAID)
 	..i (dosage="")&&(BSAUnit'="")&&(formula'="") d
 	...s dosage=##class(DHCDoc.Chemo.COM.Func2).CaclDoseByFormula(PatientID, EpisodeID, formula, BSAUnit)
 	..i (qty="")&&(SessionStr'="") d
 	...s qty=##class(DHCDoc.Chemo.COM.Func2).CalcPackQty(EpisodeID, PGIID, "CUR",SessionStr,dosage)
 	..//w qty,!
 	..i Seqno="" s Seqno="999"
 	..s LinkSymbol=##class(DHCDoc.Chemo.COM.Func2).GetLinkSymbol(PGIID,"CUR")
 	..s OrderDoseQtyNurese=dosage
 	..s Data=$lb(id,TPGIID,PGIID,arcim,arcimDesc,dosage,dosageUomDR,dosageUomDesc,freqDR,freqDesc,instrucDR,instrucDesc,duratDR,duratDesc,qty,uomDR,uomDesc,linkItem,note,priorDR,priorDesc,simpleDR,remark,remarkDr,recLoc,recLocDesc,stage,stageCode,flowRate,flowRateDR,flowRateID,skinTest,skinAction,skinActionId,BSAUnit,BSA,formula,HDID,HospDose,ManuFactor,BSAUnitSTD,LinkSymbol,GroupType,GroupTypeId,mainDrug,ShowDate,OeoriDR,initdosage,OrderDoseQtyNurese)
 	..s ^BS.DOC.Chemo.TEMPData("D",TempArr(GroupTypeCode),TPID,SID,Sub,Seqno,id)=Data
	//B ;001
	s gcode=""
	f  s gcode=$o(^BS.DOC.Chemo.TEMPData("G",gcode)) q:gcode=""  d
	.s Seqno=""
	.s TPGID=$G(^BS.DOC.Chemo.TEMPData("G",gcode))
	.S TPID=$P(TPGID,"||",1),SID=$P(TPGID,"||",2),Sub=$P(TPGID,"||",3)
	.f  s Seqno=$o(^BS.DOC.Chemo.TEMPData("D",gcode,TPID,SID,Sub,Seqno)) q:Seqno=""  d
	..s id=""
	..f  s id=$o(^BS.DOC.Chemo.TEMPData("D",gcode,TPID,SID,Sub,Seqno,id)) q:id=""  d
	...s Data=^BS.DOC.Chemo.TEMPData("D",gcode,TPID,SID,Sub,Seqno,id)
 	...d output3
	
	k ^BS.DOC.Chemo.TEMPData
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
output3
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

}
