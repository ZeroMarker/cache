Class web.DHCIFExec Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 254;

ClassMethod GetOrdExecute(ByRef qHandle As %Binary, RegNo As %String, DefVarTyp As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	Set qHandle=$lb(0,repid,0)
 	if RegNo="" 	Quit $$$OK
 	s papmiId=$O(^PAPERi("PAPMI_PatNo",$$ALPHAUP^SSUTIL4(RegNo),"")) 
 	q:papmiId=""
 	s Adm="" f  s Adm=$O(^PAPERdr(papmiId,"ADM","O",Adm),-1) q:Adm=""  d
    .s Oew=$O(^OEORD(0,"Adm",Adm,""))
    .s Color="107,248,0" 
    .s OrdSub=""  f  s OrdSub=$O(^OEORD(Oew,"I",OrdSub)) q:OrdSub=""  d
    ..s ExceChl="" f  s ExceChl=$O(^OEORD(Oew,"I",OrdSub,"X",ExceChl)) q:ExceChl=""  d
    ...s OrdExecDate=$P(^OEORD(Oew,"I",OrdSub,"X",ExceChl),"^",1) //要求执行日期
    ...q:(OrdExecDate<($h-2))||(OrdExecDate>+$h) //要求执行时间在三天内所有医嘱 
    ...q:$P(^OEORD(Oew,"I",OrdSub,11),"^",39)'=""  //子医嘱退出
    ...s PriorDR=$P($G(^OEORD(Oew,"I",OrdSub,1)),"^",8) 
    ...q:PriorDR="" 
    ...s PriorDes=$P(^OECPR(PriorDR),"^",2)
    ...q:PriorDes="取药医嘱"
    ...s MethDr=$p(^OEORD(Oew,"I",OrdSub,2),"^",7)
    ...s MethId="^"_^DHCCLNurseExec("VarDef",0,DefVarTyp,"PhcIn")_"^"
    ...q:MethId'[("^"_MethDr_"^")
    ...s Meth=$P(^PHCIN(MethDr),"^",2)
    ...s ordStatCode=##Class(web.DHCIFComm).GetOrdStatCode(Oew_"||"_OrdSub)
    ...q:ordStatCode="D" //跳过停止医嘱
    ...s ArcimDR=$P(^OEORD(Oew,"I",OrdSub,1),"^",2)
    ...s ARCIMRowid=$P(ArcimDR,"||",1)
	...s ARCIMSub=$P(ArcimDR,"||",2)
	...s ItemCatDR=$P($G(^ARCIM(ARCIMRowid,ARCIMSub,1)),"^",10)
    ...s OrdTyp=$P(^ARC("IC",ItemCatDR),"^",7)
    ...q:OrdTyp'="R" //非药品医嘱
	...s ArcimDes=$P(^ARCIM(ARCIMRowid,ARCIMSub,1),"^",2)
    ...s SeqNo=$P(^OEORD(Oew,"I",OrdSub,3),"^",4)
    ...i Color="107,248,0" s Color="255,255,255"
    ...e  s Color="107,248,0" 
    ...s DoseQty=$P($G(^OEORD(Oew,"I",OrdSub,2)),"^",1)
    ...s UomDr=$P(^OEORD(Oew,"I",OrdSub,2),"^",3)
    ...i UomDr'="" s Uom=$P(^CT("UOM",UomDr),"^",2)
    ...i DoseQty'="" s Dose=DoseQty_" "_Uom
    ...e  s Dose="0"_Uom
    ...s PHFreqDr=$P(^OEORD(Oew,"I",OrdSub,2),"^",4)
    ...q:PHFreqDr=""
    ...s PHFreq=$P(^PHCFR(PHFreqDr),"^",3)
    ...s PriorityDr=$P(^OEORD(Oew,"I",OrdSub,1),"^",8) 
    ...q:PriorityDr=""
    ...s Priority=$P(^OECPR(PriorityDr),"^",2)
    ...s ExecUserDr=$P(^OEORD(Oew,"I",OrdSub,"X",ExceChl),"^",15)
    ...s ExecDate=$P(^OEORD(Oew,"I",OrdSub,"X",ExceChl),"^",19)
    ...s ExecTime=$P(^OEORD(Oew,"I",OrdSub,"X",ExceChl),"^",20)
    ...q:(ExecDate'=+$h)&&(ExecDate'="")   //不是当天执行的退出
    ...s ExecUser="",ExecDatTim=""
    ...i ExecUserDr'="" d
    ....s ExecUser=$P(^CTPCP(ExecUserDr,1),"^",2)
    ....s ExecDatTim=$ZD(ExecDate,3)_" "_$ZT(ExecTime)
    ....i ExecUser'="" s Color="192,192,255"
    ...s Oeore=Oew_"||"_OrdSub_"||"_ExceChl
    ...d Out
    ...s curOeoriId="" f  s curOeoriId=$O(^OEORDi(0,"OEORI",Oew,Oew_"||"_OrdSub,curOeoriId)) q:curOeoriId=""  d
    ....s curExceChl=""  f  s curExceChl=$O(^OEORD(Oew,"I",curOeoriId,"X",curExceChl)) q:curExceChl=""  d
    .....q:ExceChl'=curExceChl
    .....s OrdExecDate=$P(^OEORD(Oew,"I",OrdSub,"X",curExceChl),"^",1) //要求执行日期
    .....q:(OrdExecDate<($h-2))||(OrdExecDate>+$h) 
    .....s ArcimDR=$P(^OEORD(Oew,"I",curOeoriId,1),"^",2)
    .....s ARCIMRowid=$P(ArcimDR,"||",1)
	.....s ARCIMSub=$P(ArcimDR,"||",2) 
	.....s ArcimDes=$P(^ARCIM(ARCIMRowid,ARCIMSub,1),"^",2)
	.....s ArcimDes="___"_ArcimDes
	.....s SeqNo=$P(^OEORD(Oew,"I",curOeoriId,3),"^",4)
	.....s DoseQty=$P($G(^OEORD(Oew,"I",curOeoriId,2)),"^",1)
    .....s UomDr=$P(^OEORD(Oew,"I",curOeoriId,2),"^",3)
    .....i UomDr'="" s Uom=$P(^CT("UOM",UomDr),"^",2)
    .....i DoseQty'="" s Dose=DoseQty_" "_Uom
    .....e  s Dose="0"_Uom
    .....s PHFreqDr=$P(^OEORD(Oew,"I",curOeoriId,2),"^",4)
    .....q:PHFreqDr=""
    .....s PHFreq=$P(^PHCFR(PHFreqDr),"^",3)
    .....s PriorityDr=$P(^OEORD(Oew,"I",curOeoriId,1),"^",8) 
    .....q:PriorityDr=""
    .....s Priority=$P(^OECPR(PriorityDr),"^",2)
    .....s ExecUserDr=$P(^OEORD(Oew,"I",curOeoriId,"X",curExceChl),"^",15)
    .....s ExecDate=$P(^OEORD(Oew,"I",curOeoriId,"X",curExceChl),"^",19)
    .....s ExecTime=$P(^OEORD(Oew,"I",curOeoriId,"X",curExceChl),"^",20) 
    .....q:(ExecDate'=+$h)&&(ExecDate'="")
    .....s ExecUser="",ExecDatTim=""
    .....i ExecUserDr'="" d
    ......s ExecUser=$P(^CTPCP(ExecUserDr,1),"^",2)
    ......s ExecDatTim=$ZD(ExecDate,3)_" "_$ZT(ExecTime)
    .....s Oeore=Oew_"||"_curOeoriId_"||"_curExceChl
    .....d Out
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
Out
    Set Data=$LB($G(Select),$G(ArcimDes),$G(SeqNo),$G(Dose),$G(Meth),$G(ExecDatTim),$G(ExecUser),$G(PHFreq),$G(Priority),$G(Oeore),$G(Color))   
    Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetOrdFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetOrdExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetOrdClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetOrdExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

Query GetOrd(RegNo As %String, DefVarTyp As %String) As %Query(ROWSPEC = "Select,ArcimDes,SeqNo,Dose,Meth,ExecUser,ExecDatTim,PHFreq,Priority,Oeore,Color")
{
}

ClassMethod GetRelationOrd(RowId, No) As %String
{
  //关联医嘱
  s ArcRet=""
  q:(RowId'["||")||(RowId="")||(No="") "No"
  s oeordId=+RowId
  s Episodeid=$P(^OEORD(oeordId),"^",1) 
  s PapmiId=+^PAADM(Episodeid)
  s RegNo=$P(^PAPER(PapmiId,"PAT",1),"^",2)  
  q:'$D(^OEORD(oeordId,"I",$P(RowId,"||",2),"X",No)) "No"
  s oeordId=+RowId
  s chl=$P(RowId,"||",2)
  //按时间确定要执行的医嘱
  s mainStdate=$P($G(^OEORD(oeordId,"I",$P(RowId,"||",2),1)),"^",9)
  s ArcRet=..GetOrdDetail(+RowId,$P(RowId,"||",2),No)
  if ArcRet'="" s ArcRet=ArcRet_"^"
  s curOriSub="" f  s curOriSub=$o(^OEORDi(0,"OEORI",oeordId,RowId,curOriSub)) q:(curOriSub="")  d
  .s stdate=$P($G(^OEORD(oeordId,"I",curOriSub,1)),"^",9)
  .s ArcimDR=$P($G(^OEORD(oeordId,"I",curOriSub,1)),"^",2)  ///华西下医嘱关联费用，非药品医嘱退出
  .s ARCIMRowid=$P(ArcimDR,"||",1)
  .s ARCIMSub=$P(ArcimDR,"||",2)
  .s ItemCatDR=$P($G(^ARCIM(ARCIMRowid,ARCIMSub,1)),"^",10)
  .s OrdTyp=$P(^ARC("IC",ItemCatDR),"^",7)
  .q:OrdTyp'="R" //非药品医嘱
  .q:stdate'=mainStdate
  .s ordStatCode=##Class(web.DHCCLCom).GetOrdStatCode(oeordId_"||"_curOriSub) //ypz 070204
  .q:ordStatCode="D" //ypz 070204 跳过停止的 070310 rem
  .s ret=..GetOrdDetail(oeordId,curOriSub,No)
  .if ret'="" s ArcRet=ArcRet_ret_"^" 
  if ArcRet="" q "No" 
  s ArcRet=ArcRet_"&"_RegNo
  q ArcRet
}

ClassMethod GetOrdDetail(oew, chl, No) As %String
{
    //n (oew,chl,typ)
     s arcimdr=$p($g(^OEORD(oew,"I",chl,1)),"^",2)
     s glno=$p($g(^OEORD(oew,"I",chl,11)),"^",39)  //关联  OEORI_OEORI_DR
	 s scrip=$P(arcimdr,"||")
	 s ver=$P(arcimdr,"||",2)
	 s arcimdes=$P(^ARCIM(scrip,ver,1),"^",2)
	 s packUomId=$P(^ARCIM(scrip,ver,8),"^",14)	
	 //途径
	 s phcinId=$p($g(^OEORD(oew,"I",chl,2)),"^",7) ;OEORI_Instr_DR
     i phcinId'="" s phcinDesc=$p($g(^PHCIN(phcinId)),"^",2)  ////,phcinCode=$p($g(^PHCIN(phcinId)),"^",1)
     //频次
     s phcfrId=$p($g(^OEORD(oew,"I",chl,2)),"^",4)
     if phcfrId'="" s phcfrCode=$p($g(^PHCFR(phcfrId)),"^",3)
     //要素PHC_FREQ
     //if $G(phcfrCode)'="" s val("sttDateTime")=..FreqTime(phcfrCode)
     if phcfrId'="" s phfactor=$p($g(^PHCFR(phcfrId)),"^",2)
	 s doseQty=$p($g(^OEORD(oew,"I",chl,2)),"^",1)
     i doseQty'="" s unitUomId=$p($g(^OEORD(oew,"I",chl,2)),"^",3)
    // W !,doseQty,",",$G(unitUomId),",",chl
	 f rnum=1:1:$G(^OEORD(oew,"I",chl,"DEP",0))  d
	 .s val("notes")=$G(val("notes"))_$G(^OEORD(oew,"I",chl,"DEP",rnum))
     i $G(unitUomId)'="" s unitDesc=$p($g(^CT("UOM",unitUomId)),"^",2)
     s dose=$G(doseQty)_" "_$g(unitDesc)
     s val("doseQtyUnit")=$G(doseQty)_" "_$g(unitDesc)
     s phOrdQty=$p($g(^OEORD(oew,"I",chl,1)),"^",12)
     //i (phOrdQty'="")&(phOrdQty<1) s phOrdQty="0"_phOrdQty
     //if $G(phcinDesc)'="" s dosequnit=..getphbasnum(unitUomId,doseQty,scrip,ver)
    //i (phOrdQty'="")&(unitDesc'="") s val("phOrdQtyUnit")=phOrdQty_" "_unitDesc
    i (phOrdQty'="") s PackNum=phOrdQty_" "_$G(unitDesc)
     s packUomQty=$p($g(^OEORD(oew,"I",chl,9)),"^",4)
     s packUomId=+packUomId
     i (packUomId'=0)&(packUomQty'="") d 
     .s packUomDesc=$p(^CT("UOM",packUomId),"^",2)
     if packUomQty'="" s PackNum=$G(packUomQty)_" "_$G(packUomDesc)
     s val("phOrdQtyUnit")=PackNum
     s val("labNo")=$p($g(^OEORD(oew,"I",chl,3)),"^",20)
     s reclocId=$p($g(^OEORD(oew,"I",chl,3)),"^",6)
     i reclocId'="" s val("reclocDesc")=$P($p($g(^CTLOC(reclocId)),"^",2),"-",2)
     e   s val("reclocDesc")=""
     s oecprId=$p($g(^OEORD(oew,"I",chl,1)),"^",8)
     i oecprId'="" s oecprDesc=$p($g(^OECPR(oecprId)),"^",2)
     i oecprId'="" s PriorCode="^"_$p($g(^OECPR(oecprId)),"^",1)_"^"
     s OrdDate=$P($G(^OEORD(oew,"I",chl,1)),"^",9)  //stdat
     //i ("^S^OMST^"[PriorCode)&(dose'="") s OrdDate=OrdDate+1
     //打印执行单时长期药物开始时间加1 因为是提前摆药
     s OrdDate=$ZD(OrdDate,3) 
     s PrnDate=$ZD(+$H,3)_" "_$Zt($P($H,",",2))
     s SeqNo=$p($g(^OEORD(oew,"I",chl,3)),"^",4) //qshe add 05-08-22
     i SeqNo["." s arcimdes="___"_arcimdes
     //i (SeqNo'="")&(+SeqNo'=0) d  //ypz 060925 error data protect
    // .s tmpSeqNo=$P(SeqNo,"||",2)
     //e  s tmpSeqNo=chl    //未打
    // s SeqNo=oew_tmpSeqNo 
     //if $G(dosequnit)'="" s val("doseQtyUnit")=dosequnit
     s PriorityDr=$P(^OEORD(oew,"I",chl,1),"^",8) 
     i PriorityDr'="" s Priority=$P(^OECPR(PriorityDr),"^",2)
	 s ExecUserDr=$P(^OEORD(oew,"I",chl,"X",No),"^",15)
     s ExecDate=$P(^OEORD(oew,"I",chl,"X",No),"^",19)
     s ExecTime=$P(^OEORD(oew,"I",chl,"X",No),"^",20) 
     s Color="255,255,255"
     s ExecUser="",ExecDatTim=""
     i ExecUserDr'="" d
     .s ExecUser=$P(^CTPCP(ExecUserDr,1),"^",2)
     .s ExecDatTim=$ZD(ExecDate,3)_" "_$ZT(ExecTime)
     s Oeore=oew_"-"_chl_"-"_No
     s ret=$G(Select)_"|"_$G(arcimdes)_"|"_$G(SeqNo)_"|"_$G(val("doseQtyUnit"))_"|"_$G(phcinDesc)_"|"_$G(ExecUser)_"|"_$G(ExecDatTim)_"|"_$G(phcfrCode)_"|"_$G(Priority)_"|"_$G(Oeore)_"|"_$G(Color)
     q ret
}

ClassMethod ScanExec(RowId, No, User, CTLocId, Item, FailureNum) As %String
{
    //扫描条码执行医嘱
  	s oeordId=+RowId
  	if '$D(^OEORD(oeordId,"I",$P(RowId,"||",2),"X",No))  q "No"
    s ordStatCode=##Class(web.DHCIFComm).GetOrdStatCode(RowId) 
    q:ordStatCode="D" //跳过停止医嘱
    s mainStdate=$P($G(^OEORD(oeordId,"I",$P(RowId,"||",2),1)),"^",9)
    s DosageExecStatus=##class(web.DHCIFDosAge).ExecStatus(RowId_"||"_No,"Exec")  //更新配液医嘱执行状态
  	q:DosageExecStatus="UnDosAge" DosageExecStatus
    s arcimStr=##class(web.DHCIFComm).getarcimDetail(oeordId,$P(RowId,"||",2))
    s dose=$p(arcimStr,"^",2)
  	//s parr="Y^^^"_User_"^"_RowId_"||"_No_"^^"
  	//s para="Y^"_dose_"^"_statDesc_"^"_userId_"^"_oeoreId_"^^"_seatNo_"^"_userDeptId_"^"_queryTypeCode
  	s parr="Y^"_dose_"^"_"完成"_"^"_User_"^"_RowId_"||"_No_"^^^^"
  	s ret=##class(web.DHCNurCom).UpdateExecStat("","",parr,"")
  	if ret=0 d 
  	.d ..InfusionStart(RowId_"||"_No,CTLocId,User) //输液开始计时
  	.s rw="" f  s rw=$O(^User.DHCIFWorkItemD(rw)) q:rw=""  d   //插入工作量
	..s typCode=$list(^User.DHCIFWorkItemD(rw),2)
	..q:typCode'=Item
	..s retWork=##class(web.DHCIFWorkLoad).InsertWork(RowId_"||"_No,rw,User,CTLocId,FailureNum)
  	s curOriSub="" f  s curOriSub=$o(^OEORDi(0,"OEORI",oeordId,RowId,curOriSub)) q:(curOriSub="")  d
		.s stdate=$P($G(^OEORD(oeordId,"I",curOriSub,1)),"^",9)
		.s ArcimDR=$P($G(^OEORD(oeordId,"I",curOriSub,1)),"^",2)  ///华西下医嘱关联费用，非药品医嘱退出
        .s ARCIMRowid=$P(ArcimDR,"||",1)
        .s ARCIMSub=$P(ArcimDR,"||",2)
        .s ItemCatDR=$P($G(^ARCIM(ARCIMRowid,ARCIMSub,1)),"^",10)
        .s OrdTyp=$P(^ARC("IC",ItemCatDR),"^",7)
        .q:OrdTyp'="R" //非药品医嘱
		.q:stdate'=mainStdate //关联医嘱和主医嘱要求执行时间一致
		.//s parr="Y^^^"_User_"^"_oeordId_"||"_curOriSub_"||"_No_"^^"
		.s curarcimStr=##class(web.DHCIFComm).getarcimDetail(oeordId,curOriSub)
        .s curdose=$p(arcimStr,"^",2)
		.s parr="Y^"_curdose_"^"_"完成"_"^"_User_"^"_oeordId_"||"_curOriSub_"||"_No_"^^^^"
		.s ret=##class(web.DHCNurCom).UpdateExecStat("","",parr,"")
    q $G(retWork)
}

ClassMethod UnExec(RowId, UserId) As %String
{
    s Oew=$P(RowId,"||",1)
    s Sub=$P(RowId,"||",2)
    s No=$P(RowId,"||",3)
    s oeoreId=Oew_"||"_Sub
    s OeorichlDr=$P(^OEORD(Oew,"I",Sub,11),"^",39)
    q:OeorichlDr'="" "-1"  
    s DosageExecStatus=##class(web.DHCIFDosAge).ExecStatus(RowId,"UnExec")  //更新配液医嘱执行状态 
    q:DosageExecStatus'=0 "-2"
    s ret=##class(web.DHCNurCom).UndoUpdateExecStat(RowId,"","",UserId) 
   	if ret=0 d  
   	.d ..InfusionCancel(RowId) //输液计时取消
  	.s rw="" f  s rw=$O(^User.DHCIFWorkItemD(rw)) q:rw=""  d //删除工作量
	..s typCode=$list(^User.DHCIFWorkItemD(rw),2)
	..q:typCode="Dosage" 
	..s retStr=##class(web.DHCIFWorkLoad).DeleteWork(RowId,rw)
	s curOriSub="" f  s curOriSub=$O(^OEORDi(0,"OEORI",Oew,oeoreId,curOriSub)) q:curOriSub=""  d
	.s ret=##class(web.DHCNurCom).UndoUpdateExecStat(Oew_"||"_curOriSub_"||"_No,"","",UserId)
	q ret
}

ClassMethod InfusionPrefinalDT(DistantTime As %String, OeoreId As %String) As %String
{
	q:DistantTime="" "-1"
	s rw="" f  s rw=$O(^User.DHCIFTimeI("Oeore"," "_OeoreId,rw)) q:rw=""  d //更新输液预结束时间
	.s a=##class(User.DHCIFTime).%OpenId(rw)
	.s StTime=a.InfuStTime
	.s PrefinalDate=$P($h,",",1)
	.s PrefinalTime=StTime+(DistantTime*60)
	.i (PrefinalTime>=86400) d   //输液时间跨天
	..s DistantDay=PrefinalTime\86400
	..s PrefinalTime=PrefinalTime-(86400*DistantDay)
	..s PrefinalDate=PrefinalDate+DistantDay
	.s a.InfuPrefinalDate=PrefinalDate
	.s a.InfuPrefinalTime=PrefinalTime
	.s a.InfuWithTime=DistantTime*60
	.d a.%Save()
	.d a.%Close()
	q:PrefinalDate="" "-1"
	s ret=$ZD(PrefinalDate,3)_" "_$ZT(PrefinalTime)
	q ret
}

ClassMethod InfusionStart(OeoreId As %String, CTLocId As %String, UserId As %String) As %String
{
	//计时开始
	s EpisodeId=$P($G(^OEORD(+OeoreId)),"^",1)
	s PapmiId=+^PAADM(EpisodeId)
	s RegNo=$P(^PAPER(PapmiId,"PAT",1),"^",2) 
	s StDate=$P($h,",",1)
	s StTime=$P($h,",",2)
	s parr="^"_OeoreId_"^"_EpisodeId_"^"_RegNo_"^"_"N"_"^"_StDate_"^"_StTime_"^"_CTLocId_"^"_UserId
	s ret=##class(User.DHCIFTime).Save(parr)
	q ret
}

ClassMethod InfusionStop(OeoreId As %String) As %String
{
	//计时停止
	s rw="" f  s rw=$O(^User.DHCIFTimeI("Oeore"," "_OeoreId,rw)) q:rw=""  d
	.s a=##class(User.DHCIFTime).%OpenId(rw)
	.s a.InfuPrefinalDate=""
	.s a.InfuPrefinalTime=""
	.s a.InfuWithTime=""
	.d a.%Save()
	.d a.%Close()
	q 0
}

ClassMethod InfusionCancel(OeoreId As %String) As %String
{
	//计时取消
	s rw="" f  s rw=$O(^User.DHCIFTimeI("Oeore"," "_OeoreId,rw)) q:rw=""  d
	.d ##class(User.DHCIFTime).%DeleteId(rw)
	q 0
}

ClassMethod InfusionStatus(RegNo As %String) As %String
{
	//输液状态
	s ret="-1"
	s rw="" f  s rw=$O(^User.DHCIFTimeI("RegNo"," "_RegNo,rw)) q:rw=""  d
	.s Status=$list(^User.DHCIFTimeD(rw),13)
	.i Status="N" s ret=$list(^User.DHCIFTimeD(rw),6)
	q ret
}

ClassMethod InfusionFinish(OeoreId As %String, CTLocId As %String, UserId As %String) As %String
{
	//输液完成
	s EndDate=$P($h,",",1)
	s EndTime=$P($h,",",2)
	s rw="" f  s rw=$O(^User.DHCIFTimeI("Oeore"," "_OeoreId,rw)) q:rw=""  d
	.s a=##class(User.DHCIFTime).%OpenId(rw)
	.s a.InfuStatus="Y"
	.s a.InfuActualEndDate=EndDate
	.s a.InfuActualEndTime=EndTime
	.s a.InfufinishUser=UserId
	.i EndDate>=a.InfuStDate s a.InfuWithTime=$P($h,",",2)+((EndDate-a.InfuStDate)*86400-a.InfuStTime)
	.d a.%Save()
	.d a.%Close()
	d ..ReleaseSeat(OeoreId,CTLocId,UserId) //输液全部完成释放病人座位
	q 0
}

ClassMethod InfusionAwoke(CTLocId As %String, DefVarTyp As %String) As %String
{
	//输液时间低于15分钟提醒
	//w ##class(web.DHCIFExec).InfusionAwoke("1182","SYDO")
	q:CTLocId="" "-1"
	s msg=""
	s Seatid="" f  s Seatid=$O(^User.DHCNurSySeatI("loc"," "_CTLocId,Seatid)) q:Seatid=""  d
 	.s flag=$list(^User.DHCNurSySeatD(Seatid),7)
 	.q:flag="N"
 	.s SeatNo=$list(^User.DHCNurSySeatD(Seatid),3)
 	.s id="" f  s id=$O(^User.DHCNurSyPatRecI("seat"," "_CTLocId," "_Seatid," Y",id)) q:id=""  d
    ..s EpisodeID=$list(^User.DHCNurSyPatRecD(id),3)
    ..s RegNo=$list(^User.DHCNurSyPatRecD(id),4)
    ..s LeaveTime=..LeaveTime(RegNo)
    ..q:LeaveTime=""
    ..s PatOrdNum=##class(web.DHCIFPatManage).GetOrdNum(RegNo,DefVarTyp)
    ..s OddNum=$P(PatOrdNum,"^",1)-$P(PatOrdNum,"^",2)
    ..if ($ZTH(LeaveTime)<900)&&($ZTH(LeaveTime)>=0) d
    ...s Papmidr=$P($g(^PAADM(EpisodeID)),"^",1)
 	...s Name=$P(^PAPER(Papmidr,"ALL"),"^",1)
 	...s msg=msg_" "_SeatNo_"座"_" "_Name_" "_"未执行医嘱数:"_OddNum_" "_"当前输液剩余时间:"_LeaveTime
 	q msg
}

ClassMethod LeaveTime(RegNo As %String) As %String
{
	s time="",DistantDay=0,ret=""
	s rw="" f  s rw=$O(^User.DHCIFTimeI("RegNo"," "_RegNo,rw)) q:rw=""  d
	.s Status=$list(^User.DHCIFTimeD(rw),13)
	.q:Status="Y" 
	.s PrefinalDate=$list(^User.DHCIFTimeD(rw),7)
	.s PrefinalTime=$list(^User.DHCIFTimeD(rw),8)
	.s WithTime=$list(^User.DHCIFTimeD(rw),14)
	.s NowDate=$P($h,",",1)
	.s NowTime=$P($h,",",2)
	.i PrefinalDate>NowDate d
	..i WithTime>86400 d
	..s DistantDay=PrefinalDate-NowDate
	..s time=PrefinalTime
	..e  s time=86400-NowTime+PrefinalTime
	.i PrefinalDate=NowDate d
	..i PrefinalTime>NowTime s time=PrefinalTime-NowTime
	..e  s time=0
	.i PrefinalDate< NowDate s time=0
	i time'="" s ret=$ZT(time)
	i DistantDay>0 s ret=$ZT("86399")
	q ret
}

ClassMethod GetOrdData(RegNo As %String, DefVarTyp As %String) As %String
{
   n (RegNo,DefVarTyp)
   s QueryName="web.DHCIFExec:GetOrd"
   Set rset = ##class(%ResultSet).%New(QueryName)
   Set columns = rset.GetColumnCount()
 // Execute the query
    s sc = rset.Execute(RegNo,DefVarTyp)
   s QueryName=$TR(QueryName,":","&")
   s ret=$P(QueryName,"&",2)_"&"
  s i=0
  While (rset.Next()) {
       i (i=0){
        For col = 1:1:columns {
            s ret=ret_rset.GetColumnName(col)_"&"
        }
       }
       s coldata=""
       For col = 1:1:columns {
            s coldata=coldata_rset.GetData(col)_"^"
        }

      if (i=0){
	      s ret=ret_">"_coldata_"&"
	      }else{
		    s ret=ret_coldata_"&"

		      }
      s i=i+1
      if i>150  q
      
 }
 Do rset.Close()
 s qu=$P(QueryName,"&",2)_"&"
 if ret=qu  s ret="-1"
 b
 q ret
}

ClassMethod PatInfuDetails(CTLocId As %String, StDate As %String, funname As %String) As %String
{
	;w ##class(web.DHCIFExec).PatInfuDetails("1182","2010-07-27","add")
	q:CTLocId="" ""
	s ^liulei=StDate
	s date=+$h
	s id="" f  s id=$O(^User.DHCIFTimeI("CTLoc"," "_CTLocId,date,id)) q:id=""  d
	.s FinishUser=""
	.s Adm=$list(^User.DHCIFTimeD(id),4)
	.s RegNo=$list(^User.DHCIFTimeD(id),9)
	.s PapmiDr=$P(^PAADM(Adm),"^",1)
	.s PatName=$p($g(^PAPER(PapmiDr,"ALL")),"^",1)
	.s OeoreId=$list(^User.DHCIFTimeD(id),6)
	.s ArcDesc=##class(web.DHCIFWorkLoad).GetArcDesc(OeoreId)
	.s DosageRowId=$O(^User.DHCIFDosAgeI("Oeore"," "_OeoreId,""))
	.if (DosageRowId'="") d
	..s DosAgeDate=$list(^User.DHCIFDosAgeD(DosageRowId),3)
	..s DosAgeTime=$list(^User.DHCIFDosAgeD(DosageRowId),7)
	..s DosAgeUserDr=$list(^User.DHCIFDosAgeD(DosageRowId),8)
	..i DosAgeUserDr'="" s DosAgeUser=$P(^SSU("SSUSR",DosAgeUserDr),"^",2)
	.s ExecUserDr=$list(^User.DHCIFTimeD(id),12)
	.i ExecUserDr'="" s ExecUser=$P(^SSU("SSUSR",ExecUserDr),"^",2)
	.s ExecDate=$list(^User.DHCIFTimeD(id),10)
	.s ExecTime=$list(^User.DHCIFTimeD(id),11)
	.s FinishUserDr=$list(^User.DHCIFTimeD(id),15)
	.i FinishUserDr'="" s FinishUser=$P(^SSU("SSUSR",FinishUserDr),"^",2)
	.s FinishDate=$list(^User.DHCIFTimeD(id),2)
	.s FinishTime=$list(^User.DHCIFTimeD(id),3)
	.s OrdStatus=$list(^User.DHCIFTimeD(id),13)
	.s WithTime=$list(^User.DHCIFTimeD(id),14)
	.i OrdStatus="Y" s LeaveTime=0
	.e  s LeaveTime=..LeaveTime(RegNo)
	.s PatInfuDetails(RegNo,OeoreId)=$G(RegNo)_"^"_$G(PatName)_"^"_$G(ArcDesc)_"^"_$G(LeaveTime)_"^"_$G(DosAgeDate)_"^"_$G(DosAgeTime)_"^"_$G(DosAgeUser)_"^"_$G(ExecDate)_"^"_$G(ExecTime)_"^"_$G(ExecUser)_"^"_$G(FinishDate)_"^"_$G(FinishTime)_"^"_$G(FinishUser)_"^"_$G(WithTime)
	s id1="" f  s id1=$O(PatInfuDetails(id1)) q:id1=""  d
	.s id2="" f  s id2=$O(PatInfuDetails(id1,id2)) q:id2=""  d
	..s FinishDT=""
	..s RegNo=$P(PatInfuDetails(id1,id2),"^",1)
	..s PatName=$P(PatInfuDetails(id1,id2),"^",2)
	..s ArcDesc=$P(PatInfuDetails(id1,id2),"^",3)
	..s LeaveTime=$P(PatInfuDetails(id1,id2),"^",4)
	..s DosAgeDate=$P(PatInfuDetails(id1,id2),"^",5)
	..s DosAgeTime=$P(PatInfuDetails(id1,id2),"^",6)
	..i (DosAgeDate'="")&&(DosAgeTime'="") s DosAgeDT=$ZD(DosAgeDate,3)_" "_$ZT(DosAgeTime,2)
	..s DosAgeUser=$P(PatInfuDetails(id1,id2),"^",7)
	..s ExecDate=$P(PatInfuDetails(id1,id2),"^",8)
	..s ExecTime=$P(PatInfuDetails(id1,id2),"^",9)
	..i (ExecDate'="")&&(ExecTime'="") s ExecDT=$ZD(ExecDate,3)_" "_$ZT(ExecTime,2)
	..s ExecUser=$P(PatInfuDetails(id1,id2),"^",10)
	..s FinishDate=$P(PatInfuDetails(id1,id2),"^",11)
	..s FinishTime=$P(PatInfuDetails(id1,id2),"^",12)
	..i (FinishDate'="")&&(FinishTime'="") s FinishDT=$ZD(FinishDate,3)_" "_$ZT(FinishTime,2)
	..s FinishUser=$P(PatInfuDetails(id1,id2),"^",13)
	..i LeaveTime'="" d
	...s WithTime=$P(PatInfuDetails(id1,id2),"^",14)
	...s LeaveTime=$ZTH(LeaveTime)
	...s coefficient=WithTime/100
	...q:coefficient=0
	...i WithTime'=0 s Growth=100-(LeaveTime\coefficient) 
	...e  s Growth=100
	..s rtnval=funname_"('"_$ZCVT($G(RegNo),"O","JS")_"','"_$ZCVT($G(PatName),"O","JS")_"','"_$ZCVT($G(ArcDesc),"O","JS")_"','"_$ZCVT($G(Growth),"O","JS")_"','"_$ZCVT($G(DosAgeDT),"O","JS")_"','"_$ZCVT($G(DosAgeUser),"O","JS")_"','"_$ZCVT($G(ExecDT),"O","JS")_"','"_$ZCVT($G(ExecUser),"O","JS")_"','"_$ZCVT($G(FinishDT),"O","JS")_"','"_$ZCVT($G(FinishUser),"O","JS")_"');"
	..&javascript<#(rtnval)#>
	q 0
}

ClassMethod ReleaseSeat(OeoreId As %String, CTLocId As %String, UserId As %String) As %String
{
	s EpisodeID=$P(^OEORD(+OeoreId),"^",1)
	s PapmiId=+^PAADM(EpisodeID)
	s RegNo=$P(^PAPER(PapmiId,"PAT",1),"^",2) 
	s Status=##class(web.DHCIFDosAge).IfPatUnExecOrd(RegNo)  //病人是否还有已配制未执行输液
	i Status="Y" d
	.d ##class(web.DHCNurSyComm).ClearPatSeat(RegNo,CTLocId,UserId)
	q 0
}

}
