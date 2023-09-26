Import SQLUser

Class web.DrugAuditNew Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// /转病区不转科,修改滚出来执行记录打包表发药科室和发药病区
/// /修改 表：DHC_OEDispensing  字段：DSP_AdmLoc_DR,DSP_Dept_DR
/// /creator: lwd  2016-04-16
/// /input: 就诊号，转科科室，转移病区
ClassMethod TranDispAdmLocAndDept(AdmDr, Tranloc, TranwardDesc)
{
	//w ##class(web.DrugAuditNew).TranDispAdmLocAndDept(44974,16,"48")

	q:AdmDr="" "就诊号为空"
	q:Tranloc="" "转移科室为空"
	q:TranwardDesc="" "转移病区为空"    ////转移界面取病区明细
	s Tranpacward=##class(web.PACWard).GetIdFromCodeOrDescription(TranwardDesc)
	s Tranward=$P(^PAWARD(Tranpacward),"^",5) //..getwardloc(Tranpacward)
	q:Tranward="" "转移病区为空1"
	s curpatloc=$p(^PAADM(AdmDr),"^",4)
	q:(curpatloc'=Tranloc)||(curpatloc="") ""   ////转科室不修改发药科室和病区
	s DateFrom=(+$h)
	s DateTo=(+$h+3)
	s StopFlag="0"
	ts
	s LocId=0 f  s LocId=$o(^DHCOEDISQTY(0,"ADM",LocId)) q:(LocId="")||(StopFlag="1")  d
	.f Date=DateFrom:1:DateTo  d
 	..s DspId=0
 	..f  s DspId=$o(^DHCOEDISQTY(0,"ADM",LocId,Date,"TC",AdmDr,DspId)) q:(DspId="")||(StopFlag="1")  d
 	...s dspAdmLoc=$p(^DHCOEDISQTY(DspId),"^",23)
 	...s dspDept=$p(^DHCOEDISQTY(DspId),"^",24)
 	...q:(dspAdmLoc=Tranloc)&&(dspDept=Tranward)
	...s tmpoeoriId=$p(^DHCOEDISQTY(DspId),"^",3)
	...s tmpoeori=$p(^DHCOEDISQTY(DspId),"^",1)
	...q:(tmpoeoriId="")||(tmpoeori="")
	...s Ord=+tmpoeoriId
	...s OrdSub=$p(tmpoeoriId,"||",2)
	...s OrdExecSub=$p(tmpoeoriId,"||",3)
	...s execStatusCode=""
	...s execStatusId=$p($g(^OEORD(Ord,"I",OrdSub,"X",OrdExecSub)),"^",16) //执行状态
    ...i execStatusId'="" s execStatusCode=$p($g(^OEC("STAT",execStatusId)),"^",1)   
    ...q:(execStatusCode="F")!(execStatusCode="D") //"过滤已经执行或者停止执行的打包表"
	...s ordStatId=$p($g(^OEORD(Ord,"I",OrdSub,1)),"^",13)
    ...q:ordStatId=""
    ...s ordStatDesc=$p($g(^OEC("OSTAT",ordStatId)),"^",1)
    ...q:(ordStatDesc="U")
    ...s ArcRow=$P(^OEORD(Ord,"I",OrdSub,1),"^",2)
    ...s ItemCatDR=$P($G(^ARCIM($P(ArcRow,"||",1),$P(ArcRow,"||",2),1)),"^",10)
    ...s Cat="^"_ItemCatDR_"^"
    ...//q:^DHCNURSEITEMCAT("FaYao")'[Cat   ///领药审核配置,如果修改所有执行记录的打包表去掉过滤条件
    ...//&sql(update DHC_OEDispensing set DSP_AdmLoc_DR=:Tranloc,DSP_Dept_DR=:Tranward where DSP_RowId=:DspId)
	...&sql(update DHC_OEDispensing set DSP_AdmLoc_DR=:Tranward,DSP_Dept_DR=:Tranloc where DSP_RowId=:DspId)
	...i SQLCODE'=0 s StopFlag="1"
	...i SQLCODE'=0 tro  q
	tc
	if StopFlag="1" q "更新药房打包表失败,事务回滚！！！"
    q ""
}

Query GetFaYao(userId = "", locId = "", StDate = "", StartTime = "", EDate = "", EndTime = "", Arcim = "", RecLoc = "", theFlags = "", auditBatchId = "", RollFl = "", regNo = "") As %Query(ROWSPEC = "LocDes,Arcim,Qty,Uom,ArRow,Process,recLocId,errcode,Stock,AaUnD,pogFlag")
{
}

ClassMethod GetFaYaoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetFaYaoExecute ]
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

// typ 发药    Audittyp 已审 UnPayFlage 欠费

/// d ##class(%ResultSet).RunQuery("web.DrugAuditNew","GetFaYao","5390","237","26/06/2018","0:00","27/06/2018","22:00","","","typ|^Audittyp|^longOrdFlag|on^tempOrdFlag|on^JSFlag|^DMFlag|^UnPayFlage|^CYDYFlag|","","","0000000876")
ClassMethod GetFaYaoExecute(ByRef qHandle As %Binary, userId = "", locId = "", StDate = "", StartTime = "", EDate = "", EndTime = "", Arcim = "", RecLoc = "", theFlags = "", auditBatchId = "", RollFl = "", regNo = "") As %Status
{
    Set repid=$I(^CacheTemp)
 	s ind=1
 	s qHandle=$lb(0,repid,0)
 	i (userId="")!(locId="") Q $$$OK
 	;s ^EH("da","gfye")=userId_","_locId_","_StDate_","_StartTime_","_EDate_","_EndTime_","_Arcim_","_RecLoc_","_theFlags_","_auditBatchId_","_RollFl_","_regNo
 	k flags
 	s flags("AllFlage")="on" // 选中欠费只查欠费, 否则包括欠费
 	s len1=$l(theFlags,"^")
 	i (theFlags="") s len1=0
 	f ind1=1:1:len1 d
 	.s sub1=$p(theFlags,"^",ind1)
 	.s sub11=$p(sub1,"|",1)
 	.s sub12=$p(sub1,"|",2)
 	.i (sub11="") q
 	.s flags(sub11)=sub12
 	s RecLocId=$p(RecLoc,"|",1)
 	s ArcimID=$p(Arcim,"|",1)_"||"_$p(Arcim,"|",3)
 	i ($p(RecLoc,"|",2)="") s RecLocId=""
 	i ($p(Arcim,"|",4,$l(Arcim,"|"))="") s ArcimID=""
 	s wardStr=..GetUserWardId(userId,locId)
 	i wardStr="" Q $$$OK
 	s ward=$p($p(wardStr,"|"),"^",2)
 	s ctcpId=$P(^SSU("SSUSR",userId),"^",14)
    i ctcpId'="" s ctcptId=$P(^CTPCP(ctcpId,1),"^",4)  ;CTPCP_CarPrvTp_DR
	i $G(ctcptId)'="" s ctcpType=$P(^CT("CPT",ctcptId),"^",4)  ;CT_CarPrvTp
    i ($G(ctcpType)'="NURSE")  Q $$$OK
    s dep=""
    s hospitaldr=$p(^CTLOC(locId),"^",22)
    s anStr="^"_$g(^DHCANOPSET(hospitaldr,"anloc"))
    i anStr[("^"_locId_"|") s dep=locId
	s opStr=$g(^DHCANOPSET(hospitaldr,"oploc"))
	i opStr[("^"_locId_"|") s dep=locId
 	//清除临时数据
 	s process=$j
 	
 	
 	k ^TMP("NurDrug",userId,process) // 使用统1形式临时global
 	
 	s ^TMP("NurDrugNew",userId,process,$h)=""
 	;i auditBatchId'="" d
 	.;s fromTime=$P($G(^DHCNurDisAud(auditBatchId)),"^",2)
 	.;s toTime=$P($G(^DHCNurDisAud(auditBatchId)),"^",3)
 	.;i fromTime>toTime s fromTime="",toTime=""
 	s stdate=##class(Nur.Utility).getDateValue(StDate)
 	s edate=##class(Nur.Utility).getDateValue(EDate)
 	i (stdate="") s stdate=+$h
 	i (edate="") s edate=+$h
 	s StartTime=##class(Nur.Utility).getTimeValue(StartTime)
 	s EndTime=##class(Nur.Utility).getTimeValue(EndTime)
 	i (EndTime="") s EndTime=43201
 	i $g(flags("typ"))="on" s flags("typ")="C"
 	e  s flags("typ")="TC"
 	//i (flags("typ")="C") s flags("Audittyp")="on" //xuqy 070124
 	i (flags("typ")="C") s flags("Audittyp")=" " //未审已发药也查出来
 	s ATyp=""
	// + wxl 090331
	// EH 2013-12-27 CILIN 多个病人
	s regNos=regNo
	s regNol=$l(regNos,"^")
	f regNon=1:1:regNol d
	.s regNo=$p(regNos,"^",regNon)
	.i regNo'="" d
	..s papmiId=0 f  s papmiId=$o(^PAPERi("PAPMI_PatNo",$$ALPHAUP^SSUTIL4(regNo),papmiId)) q:papmiId=""  d 
	...s admId=0 f  s admId=$o(^PAPERdr(papmiId,"ADM","I",admId)) q:admId=""  d
	....s feeRetStr=##Class(web.UDHCJFARREARSMANAGE).CheckArrears(admId, "","NE")   //080103 S
	....s NurFeeCon=$p(feeRetStr,"^",5)
	....q:(flags("AllFlage")="")&($g(flags("UnPayFlage"))="")&(NurFeeCon="C")
	....q:($g(flags("UnPayFlage"))="on")&(NurFeeCon'="C") //080103 S
	....//s pavisit=$p($g(^PAADM(admId)),"^",20)
	....//i pavisit'="A" q
	....d ##CLASS(web.DHCTEMPOERPRINT).GetPatLoc(admId)
	....d ..GetFaYaoList(process,userId,locId,admId,stdate,edate,flags("typ"),dep,$g(flags("tempOrdFlag")),$g(flags("Audittyp")),RollFl,$g(flags("longOrdFlag")),RecLocId,ArcimID,auditBatchId,$g(flags("JSFlag")),$g(flags("DMFlag")),$g(flags("CYDYFlag")),StartTime,EndTime)
	// + wxl 090331

    s i=0   
    s loc=""  f  s loc=$O(^TMP("NurDrug",userId,process,"RecLoc",loc)) q:loc=""  d
    .s LocDes=$P(^CTLOC(loc),"^",2)
    .i LocDes["-" s LocDes=$P(LocDes,"-",2)
    .s recLocId=loc
    .s Arc="" f  s Arc=$O(^TMP("NurDrug",userId,process,"RecLoc",loc,Arc)) q:Arc=""  d
    ..s Arcim=$P(^ARCIM($P(Arc,"||",1),$P(Arc,"||",2),1),"^",2)
    ..s Qty=^TMP("NurDrug",userId,process,"RecLoc",loc,Arc,"Qty") 
    ..s Uom=^TMP("NurDrug",userId,process,"RecLoc",loc,Arc,"Uom")
    ..s Err=$g(^TMP("NurDrug",userId,process,"RecLoc",loc,Arc,"Err"))
    ..s drugErrorS=..getDrugErrorS2(Arc)
    ..s Err=Err_drugErrorS
    ..s drugErrorL=..getDrugErrorL2(Arc,loc)
    ..s Err=Err_drugErrorL
    ..s Inc=$O(^INCI(0,"ARCIM_DR",$p(Arc,"||",1),""))
    ..s pogFlag=^TMP("NurDrug",userId,process,"RecLoc",loc,Arc,"pogFlag")
    ..s Stock=..IL(Inc,loc,$H)
    ..s AaUnD=..GetAaUnDQuantity(loc,Inc,"1")
    ..s i=i+1
    ..d OutPutArc
    //清除临时数据
    k ^TMP("NurDrug",userId,process,"RecLoc")
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutPutArc  
	set Data=$lb(LocDes,Arcim,Qty,Uom,Arc,process,recLocId,Err,Stock,AaUnD,pogFlag)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetFaYaoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetFaYaoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

Query GetFaYaoDet(userId As %String, process As %String, ArRow As %String, recLocId As %String) As %Query(ROWSPEC = "Doctor,OrdDate,PatName,BedCode,Arcim,Qty,Uom,Orw,Prior,Audit,PackNum,dhcDspId,dspStat,doseQtyUnit,phcfrCode,batchTime,DispDateTime,AuditFlag,pogFlag,errcode,EncryptLevel,PatLevel,OrdLoc")
{
}

/// d ##class(%ResultSet).RunQuery("web.DrugAuditNew","GetFaYaoDet","4636","5944","1797||1","311")
ClassMethod GetFaYaoDetExecute(ByRef qHandle As %Binary, userId As %String, process As %String, ArRow As %String, recLocId As %String) As %Status
{
	;s ^tempsc("fyd")=$lb(userId , process , ArRow , recLocId )
   Set repid=$I(^CacheTemp)
 	s ind=1
 	s qHandle=$lb(0,repid,0)
 	i (userId="")!(process="")!(ArRow="") Q $$$OK
 	s Ord=""  f  s Ord=$O(^TMP("NurDrug",userId,process,"Audit",ArRow,Ord)) q:Ord=""  d
 	.s OrdSub=""  f  s OrdSub=$O(^TMP("NurDrug",userId,process,"Audit",ArRow,Ord,OrdSub)) q:OrdSub=""  d
 	..s OreSub=""  f  s OreSub=$O(^TMP("NurDrug",userId,process,"Audit",ArRow,Ord,OrdSub,OreSub)) q:OreSub=""  d
    ...s oeordStateDr=$p($g(^OEORD(Ord,"I",OrdSub,"X",OreSub)),"^",16)
    ...i oeordStateDr'="" s oeordStateCode=$p(^OEC("STAT",oeordStateDr),"^",1)
    ...q:$G(oeordStateCode)="D"
    ...s LocId=$P(^OEORD(Ord,"I",OrdSub,3),"^",6)
    ...;q:(recLocId'=LocId)
    ...s dhcDspId=""
    ...f  s dhcDspId=$O(^TMP("NurDrug",userId,process,"Audit",ArRow,Ord,OrdSub,OreSub,dhcDspId))  q:dhcDspId=""  d
    ....s dhcDspStat=$P(^DHCOEDISQTY(dhcDspId),"^",7)
    ....q:dhcDspStat="R"
    ....s dispDate=$P(^DHCOEDISQTY(dhcDspId),"^",8)
    ....s dispTime=$P(^DHCOEDISQTY(dhcDspId),"^",9) 
    ....s dispUserID=$P(^DHCOEDISQTY(dhcDspId),"^",10)
    ....s dispRecLocId=$P(^DHCOEDISQTY(dhcDspId),"^",24)
    ....q:(recLocId'=dispRecLocId)
    ....s dispUser=""
    ....i $g(dispUserID) '="" d  s dispUser=$P(^SSU("SSUSR",dispUserID),"^",2)
    ....s DispDateTime=""
    ....i ($g(dispDate)'="")&&($g(dispTime)'="") d  s DispDateTime=dispUser_"|"_##class(websys.Conversions).DateLogicalToHtml(dispDate)_" "_$ZT(dispTime) ;$ZD(dispDate,3)
    ....s dspStat=""
    ....i dhcDspStat="C" s dspStat="已发"
    ....i dhcDspStat="TC" s dspStat="未发"
    ....s user=$P($G(^OEORD(Ord,"I",OrdSub,7)),"^",1)
    ....q:user=""
    ....s DoctorDr=$P(^SSU("SSUSR",user),"^",14)
    ....i DoctorDr'=""  s Doctor=$P(^CTPCP(DoctorDr,1),"^",2) 
 	....s OrdDate=$P($G(^OEORD(Ord,"I",OrdSub,"X",OreSub)),"^",1)  ;取得医嘱表医嘱日期时间?加入基础数据表
	....s OrdTime=$P($G(^OEORD(Ord,"I",OrdSub,"X",OreSub)),"^",2)
    ....s Patinfo=##class(web.DHCCLCom).PatInfo(Ord_"||"_OrdSub)
    ....s RegNo=$P(Patinfo,"^",1)
    ....s PatName=$P(Patinfo,"^",5)
    ....s BedCode=$P(Patinfo,"^",7)
    ....s Arcim=$P(^ARCIM($P(ArRow,"||",1),$P(ArRow,"||",2),1),"^",2)
    ....s StrQty=..GetQty(Ord,OrdSub)
    ....s Qty=$P(StrQty,"^"),Uom=$P(StrQty,"^",2)
    ....s PriorDR=$P($G(^OEORD(Ord,"I",OrdSub,1)),"^",8)     ;OEC_Priority                OEORI_Priority_DR
	....s Prior=$P(^OECPR(PriorDR),"^",2) 
    ....s drugAuditStr=..GetAuditDrug(""_"^"_dhcDspId)
    ....i ($p(drugAuditStr,"^")'="") d
    .....s auditDr=$P(drugAuditStr,"^",1)
    .....s AuditUsr=$P(^SSU("SSUSR",auditDr),"^",2)
    .....s AuditDate=##class(websys.Conversions).DateLogicalToHtml($P(drugAuditStr,"^",2)) ;$ZD($P(drugAuditStr,"^",2),3) //$ZD($P($P(str,"|",1),",",1),3)
    .....s AuditTime=$ZT($P(drugAuditStr,"^",3)) //$ZT($P($P(str,"|",1),",",2))
    .....s AuditFlag=$P(drugAuditStr,"^",4)
    ....e  d
    .....s AuditUsr="", AuditDate="",AuditTime="",AuditFlag=""
    ....s PackNum=..GetPackQty(Ord,OrdSub)	
    ....s TStopDate = $p(^OEORD(Ord,"I",OrdSub,3),"^",34)		;XDate
	....s:$d(^OEORD(Ord,"I",OrdSub,2)) TStopTime = $p(^OEORD(Ord,"I",OrdSub,2),"^",15)		;XTime
	....s TExEndDate = $p(^OEORD(Ord,"I",OrdSub,9),"^",9)		;OEORI_EndDate	
	....s TExEndTime = $p(^OEORD(Ord,"I",OrdSub,9),"^",10) 	;OEORI_EndTime
	....s TStopDate = $s(TStopDate="":TExEndDate, 1:TStopDate)			;没停止日期时,取预停日期	
	....s TStopTime = $s(TStopTime="":TExEndTime, 1:TStopTime)
	....;s ^tempsc(8184)=TExEndDate_"^"_TExEndTime_"^"_TStopDate_"^"_TStopTime_"^"_OrdDate_"^"_OrdTime
	....q:(TStopDate'="")&&((OrdDate>TStopDate)!((OrdDate=TStopDate)&&(OrdTime>TStopTime)))  //170817 过滤预停时间之后的领药
    ....s DateTime=##class(websys.Conversions).DateLogicalToHtml(OrdDate)_" "_$ZT(OrdTime)  ;$ZD(OrdDate,3)
    ....s Audit=$G(AuditUsr)_"|"_$G(AuditDate)_" "_$G(AuditTime)
    ....s:Audit="| " Audit=""
    ....s ORow=Ord_"||"_OrdSub_"||"_OreSub
    ....s doseQty=$p($g(^OEORD(Ord,"I",OrdSub,2)),"^",1)
    ....s unitUomId=""
    ....i doseQty'="" s unitUomId=$p($g(^OEORD(Ord,"I",OrdSub,2)),"^",3)
    ....s unitDesc=""
    ....i unitUomId'="" s unitDesc=$p($g(^CT("UOM",unitUomId)),"^",2)
    ....i (doseQty'="")&($p(doseQty,".")="") s doseQty="0"_doseQty
    ....i (doseQty'="")&(unitDesc'="") s doseQtyUnit=doseQty_" "_unitDesc
    ....s phcfrId=$p($g(^OEORD(Ord,"I",OrdSub,2)),"^",4)
    ....i phcfrId'="" s phcfrCode=$p($g(^PHCFR(phcfrId)),"^",3) 
    ....s dhcDspTime=$P(^DHCOEDISQTY(dhcDspId),"^",20)
    ....i dhcDspTime'="" s batchTime=$ZT(dhcDspTime)
    ....e  s batchTime=""
    ....s pogFlag=$P(^DHCOEDISQTY(dhcDspId),"^",28) // EH
    ....s errcode=..getDrugError(ORow)
    ....s EpisodeID=$p(^OEORD(Ord),"^",1)
	....Set PatEncryptLevel=##class(web.DHCCLCom).GetPatEncryptLevel("",EpisodeID) //获取密级
    ....Set EncryptLevel=$p(PatEncryptLevel,"^",1)
    ....Set PatLevel=$p(PatEncryptLevel,"^",2) 
    ....s OrdLoc=""
	....s OrdLocID=$p(^OEORD(Ord,"I",OrdSub,1),"^",3)  
	....;i dispRecLocId'="" s OrdLoc=$p(^CTLOC(dispRecLocId),"^",2)
	....i OrdLocID'=""  s OrdLoc=$p(^CTLOC(OrdLocID),"^",2)
    ....d OutPutArc1
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutPutArc1
	set Data=$lb(Doctor,DateTime,PatName,BedCode,Arcim,Qty,Uom,ORow,Prior,Audit,PackNum,dhcDspId,dspStat,doseQtyUnit,phcfrCode,batchTime,DispDateTime,AuditFlag,pogFlag,errcode,EncryptLevel,PatLevel,OrdLoc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetPackQty(oew, chl)
{
     s arcimdr=$p($g(^OEORD(oew,"I",chl,1)),"^",2)
	 s scrip=$P(arcimdr,"||")
	 s ver=$P(arcimdr,"||",2)
	 s packUomId=$P(^ARCIM(scrip,ver,8),"^",14)
	 q:packUomId="" ""
	 s packUomDesc=$p(^CT("UOM",packUomId),"^",2)
     s packUomQty=$p($g(^OEORD(oew,"I",chl,9)),"^",4)
     if packUomQty'="" s res=packUomQty_"|"_packUomDesc    
     else  s res=""
     q res
}

ClassMethod GetQty(Ord, OrdSub)
{
    //ypz 080411 begin
	s Qty="",PackUom=""
	s oeoriId=Ord_"||"_OrdSub
	s dhcDspId=0  
    f  s dhcDspId=$O(^DHCOEDISQTY(0,"OEORI",oeoriId,dhcDspId))  q:dhcDspId=""  d
    .s dhcDspStat=$P(^DHCOEDISQTY(dhcDspId),"^",7)
    .q:dhcDspStat="R"
    .s Qty=$P(^DHCOEDISQTY(dhcDspId),"^",5)
    .s uomId=$P(^DHCOEDISQTY(dhcDspId),"^",6)
    .s PackUom=$p(^CT("UOM",uomId),"^",2) 
    q Qty_"^"_PackUom

    //ypz 080411 end
	s Qty="",PackUom=""
	s OrdEx=0  f  s OrdEx=$O(^OEORD(Ord,"I",OrdSub,"X",OrdEx))  q:OrdEx=""  d
    .s OrdDsp=0  f  s OrdDsp=$O(^OEORD(Ord,"I",OrdSub,"X",OrdEx,"D",OrdDsp)) q:OrdDsp=""  d
    ..s Dsp=^OEORD(Ord,"I",OrdSub,"X",OrdEx,"D",OrdDsp) 
    ..s IncLb=$P(Dsp,"^",2)
    ..s Stat=$P(Dsp,"^",6)  
    ..s Qty=$P(Dsp,"^",1)
    ..s ItmBat=$P(^INCI($P(IncLb,"||",1),"IL",$P(IncLb,"||",2),"LB", $P(IncLb,"||",3)),"^",1)
    ..s Inci=$P(ItmBat,"||",1)
    ..s BatNo=$P(^INCI(Inci,"IB",$P(ItmBat,"||",2)),"^",1)
    ..s PackUom=$p(^CT("UOM",$p(^INCI(Inci,1),"^",10)),"^",2) 
    q Qty_"^"_PackUom
}

ClassMethod GetFaYaoDetFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetFaYaoDetExecute ]
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

ClassMethod GetFaYaoDetClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetFaYaoDetExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod AuditDrug(oeoreId, userId, auditBatchId As %String = "", pogFlag = "", selFlag = "")
{
	//oeoriId   oeoriId^dhcDspId
	//oeoriId   oeoriId^dhcDspId
	q:oeoreId="" ""
	q:userId="" ""
	s ret=""
	i (pogFlag="on") s pogFlag="Y"
	i (selFlag="") s selFlag="Y" // EH 2014-02-14
    s dhcDspId=$P(oeoreId,"^",2)
    s oeoreId=$P(oeoreId,"^")
    s curDate=+$h,curTime=$p($h,",",2)
    i auditBatchId'="" s auditBatchTime=$P($G(^DHCNurDisAud(auditBatchId)),"^",4)
    e  s auditBatchTime=""
    i dhcDspId="" d
	.&sql(update DHC_OEDispensing set DSP_ConfirmUser=:userId,DSP_DateConfirm=:curDate,DSP_TimeConfirm=:curTime,DSP_ConfirmFlag=:selFlag,DSP_PogFlag=:pogFlag where DSP_OEORE_DR=:oeoreId)
	.s ret=SQLCODE
	e  d
	.i auditBatchTime'="" d
	..&sql(update DHC_OEDispensing set DSP_ConfirmUser=:userId,DSP_DateConfirm=:curDate,DSP_TimeConfirm=:curTime,DSP_ConfirmFlag=:selFlag,DSP_TimeDosing=:auditBatchTime,DSP_PogFlag=:pogFlag where DSP_RowId=:dhcDspId)
	.e  d
	..&sql(update DHC_OEDispensing set DSP_ConfirmUser=:userId,DSP_DateConfirm=:curDate,DSP_TimeConfirm=:curTime,DSP_ConfirmFlag=:selFlag,DSP_PogFlag=:pogFlag where DSP_RowId=:dhcDspId)
	.s ret=SQLCODE
	i ('SQLCODE) d ..SetAaUnDRecord(dhcDspId) // 因为都有传ord和dsp的大丈夫
	q ret
}

/// EH 2013-12-05
ClassMethod findDrugDHCDSPId2(oeoreId, userId, process)
{
	s Ord=$p(oeoreId,"||",1),OrdSub=$p(oeoreId,"||",2),OeoreSub=$p(oeoreId,"||",3)
	q:(Ord="")!(OrdSub="")!(OeoreSub="")!(userId="")!(process="") ""
	s ArcRow=$p(^OEORD(Ord,"I",OrdSub,1),"^",2)
	q:('$d(^TMP("NurDrug",userId,process,"UnAudit",ArcRow,Ord,OrdSub,OeoreSub))) ""
	s dhcDspId=$o(^TMP("NurDrug",userId,process,"Audit",ArcRow,Ord,OrdSub,OeoreSub,""))
	q:(dhcDspId="") ""
	d ..decreaseAudit(userId,process,ArcRow,Ord,OrdSub,OeoreSub,dhcDspId)
	q dhcDspId
}

/// EH 2013-12-05
ClassMethod increaseAudit(userId, process, ArcRow, Ord, OrdSub, OeoreSub, dhcDspId)
{
	s ^TMP("NurDrug",userId,process,"Audit",ArcRow,Ord,OrdSub,OeoreSub,dhcDspId)="1"
	s ^TMP("NurDrug",userId,process,"UnAudit",ArcRow,Ord,OrdSub,OeoreSub)=""
	q "1"
}

/// EH 2013-12-05
ClassMethod decreaseAudit(userId, process, ArcRow, Ord, OrdSub, OeoreSub, dhcDspId)
{
	k ^TMP("NurDrug",userId,process,"UnAudit",ArcRow,Ord,OrdSub,OeoreSub)
	q ""
}

/// EH 2013-12-05
ClassMethod resetDrugAudit2(oeoreId, userId, process)
{
	q ""
}

/// EH 2015-03-12
ClassMethod isDrugUnAuditable(dhcDspId, userId) As %String
{
	s isda=""
	s collect=$p($G(^DHCOEDISQTY(dhcDspId)),"^",7)
	i (collect="C") s isda="已发药不能撤销"
	s auditUserId=$p($G(^DHCOEDISQTY(dhcDspId)),"^",12)
	;i (auditUserId'=userId) s isda="非本人不能撤销"
	i (isda'="") d
	.s oeoreId=$p($g(^DHCOEDISQTY(dhcDspId)),"^",3)
	.s arcim=$p($g(^OEORD(+oeoreId,"I",+$p(oeoreId,"||",2),1)),"^",2)
	.s isda="2^"_$p($g(^ARCIM(+arcim,+$p(arcim,"||",2),1)),"^",2)_$c(10,13)_isda
	e  s isda="0"
	q isda
}

/// EH 2013-12-06 ZONGYUAN
ClassMethod UnAuditSingle(oeoreId, userId, process)
{
	s retcode=0
	s dhcDspId=..findDrugDHCDSPId2(oeoreId,userId,process)
	i (dhcDspId="") s retcode=retcode+0 q retcode // EH 12-10
	s curcode=..isDrugUnAuditable(dhcDspId,userId)
	i (+curcode'=0) {
		d ..resetDrugAudit2(oeoreId,userId,process)
		s retcode=curcode
		q retcode
	}
	&sql(update DHC_OEDispensing set DSP_ConfirmUser=NULL,DSP_DateConfirm=NULL,DSP_TimeConfirm=NULL,DSP_ConfirmFlag='N',DSP_PogFlag=NULL  where DSP_RowId=:dhcDspId)
	//&sql(update DHC_OEDispensing set DSP_ConfirmUser=NULL,DSP_DateConfirm=NULL,DSP_TimeConfirm=NULL,DSP_ConfirmFlag='N',DSP_PogFlag=NULL where DSP_RowId=:dhcDspId)
	i ('SQLCODE) d ..SetAaUnDRecord(dhcDspId)
	s retcode=retcode+SQLCODE
	i (retcode'=0) d ..resetDrugAudit2(oeoreId,userId,process)
	s Ord=$p(oeoreId,"||",1),OrdSub=$p(oeoreId,"||",2),OeoreSub=$p(oeoreId,"||",3)
	q:(Ord="")!(OrdSub="")!(OeoreSub="")!(userId="")!(process="") ""
	s ArcRow=$p(^OEORD(Ord,"I",OrdSub,1),"^",2)
	k ^TMP("NurDrug",userId,process,"Audit",ArcRow,Ord,OrdSub,OeoreSub,dhcDspId)
	q retcode
}

/// EH 2013-12-06 ZONGYUAN 成组撤销
ClassMethod UnAuditGroup(dhcDspId, userId, process)
{
	q:(dhcDspId="") 100
	//s ^EH("da","uag")=dhcDspId_"^"_userId_"^"_process
	s oeoreId=$p($g(^DHCOEDISQTY(dhcDspId)),"^",3)
	s retcode=0
	s groupflag=##class(web.NurseSetNew).findsimple("durgauditnew","other","0") // 成组审核
	s groupflag=$p(groupflag,"^",4)
	i (groupflag'="Y"){
		ts
		s curcode=..UnAuditSingle(oeoreId,userId,process)
		i (+curcode'=0) s retcode=curcode
		i (+retcode'=0) tro  q retcode
		tc
		q retcode
	}
	ts
	s curcode=..UnAuditSingle(oeoreId,userId,process)
	i (+curcode'=0) s retcode=curcode
	i (+retcode'=0) tro  q retcode
	s Ord=$p(oeoreId,"||",1),OrdSub=$p(oeoreId,"||",2),oeoreSub=$p(oeoreId,"||",3)
	s mainOeoriId=$p($g(^OEORD(Ord,"I",OrdSub,11)),"^",39)
	i (mainOeoriId="") s mainOeoriId=Ord_"||"_OrdSub
	s curOeoreId=mainOeoriId_"||"_oeoreSub
	i (curOeoreId'=oeoreId) d
	.s curcode=..UnAuditSingle(curOeoreId,userId,process)
	.i (+curcode'=0) s retcode=curcode
	i (+retcode'=0) tro  q retcode
	s curOrdSub="" f  s curOrdSub=$o(^OEORDi(0,"OEORI",Ord,mainOeoriId,curOrdSub)) q:(curOrdSub="")!(+retcode'=0)  d
	.s curOeoreId=Ord_"||"_curOrdSub_"||"_oeoreSub
	.q:(curOeoreId=oeoreId)
	.s curcode=..UnAuditSingle(curOeoreId,userId,process)
	.i (+curcode'=0) s retcode=curcode
	i (+retcode'=0) tro  q retcode
	tc
	q retcode
}

ClassMethod UndoAuditDrug(dhcDspId)
{
	q:dhcDspId="" ""
	s userId="",curDate="",curTime=""
	&sql(update DHC_OEDispensing set DSP_ConfirmUser=:userId,DSP_DateConfirm=:curDate,DSP_TimeConfirm=:curTime,DSP_ConfirmFlag='N' where DSP_RowId=:dhcDspId)
	q SQLCODE
}

ClassMethod GetAuditDrug(oeoriDspId)
{
	q:oeoriDspId="" ""
	s flagenum=0
	s num=0
	s dhcDspId=$P(oeoriDspId,"^",2)
	s oeoriId=$P(oeoriDspId,"^")
	i dhcDspId'="" d
    .s auditUserId=$p($G(^DHCOEDISQTY(dhcDspId)),"^",12)
    .s auditDate=$p($G(^DHCOEDISQTY(dhcDspId)),"^",18)
    .s auditTime=$p($G(^DHCOEDISQTY(dhcDspId)),"^",19)
    .s auditFlag=$p($G(^DHCOEDISQTY(dhcDspId)),"^",17)
    s auditStr=$G(auditUserId)_"^"_$G(auditDate)_"^"_$G(auditTime)_"^"_$G(auditFlag)
	q:(dhcDspId'="") auditStr
	i oeoriId'="" d
	.s dhcDspId=""
	.f  s dhcDspId=$O(^DHCOEDISQTY(0,"OEORI",oeoriId,dhcDspId))  q:dhcDspId=""  d
    ..s dhcDspStat=$P(^DHCOEDISQTY(dhcDspId),"^",7)
    ..q:dhcDspStat="R"
    ..s auditUserId=$p($G(^DHCOEDISQTY(dhcDspId)),"^",12)
    ..i auditUserId'="" s flagenum=flagenum+1
    ..s num=num+1
    ..s auditDate=$p($G(^DHCOEDISQTY(dhcDspId)),"^",18)
    ..s auditTime=$p($G(^DHCOEDISQTY(dhcDspId)),"^",19)
    i (flagenum'=0)&(flagenum=num) s auditStr=$G(auditUserId)_"^"_$G(auditDate)_"^"_$G(auditTime)
    i flagenum=0 s auditStr=""
    q:(oeoriId'="") auditStr
    q ""
}

ClassMethod GetUserWardId(usid, loc)
{
 ///获得用户病区dup??
  //n (usid,loc)
  //s loc=$P(^SSU("SSUSR",usid),"^",4)
  s warddes=$P(^CTLOC(loc),"^",2)
  s loctyp=$P(^CTLOC(loc),"^",13)
  q:loctyp'="W" ""  //ward
  s wardid=$O(^PAWARD(0,"WARD_LocationDR",loc,""),-1)
  s ctcpt=$P(^SSU("SSUSR",usid),"^",14)
  i $G(ctcpt)'="" s typid=$P(^CTPCP(ctcpt,1),"^",4)
  i $G(typid)'="" s typdes=$P(^CT("CPT",typid),"^",4)
  i ($G(typdes)="NURSE") s res=warddes_"^"_wardid
  s paroom=0 f  s paroom=$o(^PAADMi("CurrWard",wardid,paroom)) q:(paroom="")!($G(ctloc)'="")  d
  .s admId=0 f  s admId=$o(^PAADMi("CurrWard",wardid,paroom,admId)) q:(admId="")!($G(ctloc)'="")  d
  ..s ctlocdr=$P(^PAADM(admId),"^",4)
  ..q:ctlocdr=loc
  ..i ctlocdr'="" s ctloc=$P(^CTLOC(ctlocdr),"^",2)
  i $G(res)'="" s res=res_"|"_$G(ctloc)_"^"_$G(ctlocdr) 
  q $G(res)
}

ClassMethod Getdocloc(admId, Oew, OrdSub)
{
	//dup??
         //n (admId,Oew,OrdSub)
         s res="Y"
   	     s user=$P($G(^OEORD(Oew,"I",OrdSub,7)),"^",1)
         q:user="" "N"
	     s DoctorDr=$P(^SSU("SSUSR",user),"^",14)
         if DoctorDr'="" s CpTypDR=$P(^CTPCP(DoctorDr,1),"^",4)  ;CTPCP_CarPrvTp_DR
	     e  q "N"
		        
	     if '$D(^CT("CPT",CpTypDR))
	     {
		  //w !, DoctorDr
		  q "N"
		 }
	     i $G(CpTypDR)'="" s CpTyp=$P(^CT("CPT",CpTypDR),"^",4)  ;CT_CarPrvTp
	     q:($G(CpTyp)'="DOCTOR") "N"  //////////////2005-12-3 qse add
	     s truedoc=0
	     s DocLoc="" //2005-12-3 qse add///////////////////////////////////////
	     f  s DocLoc=$O(^RB("RES",0,"CTPCP",DoctorDr,DocLoc)) q:DocLoc=""  d
	     .if $D(^TMP($J,"loc",admId,DocLoc))  s truedoc=1
         i truedoc'=1 s res="N" 
 q res
}

ClassMethod getDep(Dep, Oew, OrdSub) As %String
{
    //dup??
    //n (Dep,Oew,OrdSub)
	s user=$P($G(^OEORD(Oew,"I",OrdSub,7)),"^",1)
	q:user="" "N"
	q:'$D(^SSU("SSUSR",user)) "N"
	s DoctorDr=$P(^SSU("SSUSR",user),"^",14)
	q:DoctorDr="" "N"  
	s truedoc=0
	s Loc="" 
	f  s Loc=$O(^RB("RES",0,"CTPCP",DoctorDr,Loc)) q:Loc=""  d
	.if Dep=Loc  s truedoc=1
	q:truedoc=0 "N"
	q:truedoc=1 "Y"
}

ClassMethod GetDispCatCode(oeori As %String) As %String
{
	//dup??
 //n (oeori)
 s ord=$p(oeori,"||",1),itm=$p(oeori,"||",2)
 q:ord="" "" q:itm="" "" q:'$d(^OEORD(ord,"I",itm,1)) ""
 s arcim=$p(^OEORD(ord,"I",itm,1),"^",2) q:arcim="" ""
 s sub=$p(arcim,"||",1),ver=$p(arcim,"||",2)
 q:sub="" "" q:ver="" "" q:'$d(^ARCIM(sub,ver,1))
 s arcic=$p(^ARCIM(sub,ver,1),"^",10) q:arcic="" ""
 //s ^ypzTmp(101)=$g(^ypzTmp(101))_"/"_oeori_"/"_sub_"/"_arcic
 &sql(select sdgi_sdg_parref->sdg_code into :sdgcode 
	 From DHCStkDrugGrpitm where sdgi_ordercat_dr=:arcic)
 //s ^ypzTmp(101)=$g(^ypzTmp(101))_"/"_$g(sdgcode)
 q $g(sdgcode)
}

ClassMethod SendMsg(WardId, Ward, userId, Process) As %String
{
	s Date=$P($H,",")
	s Time=$P($H,",",2)
	s loc=""  f  s loc=$O(^TMP(WardId,Process,"RecLocMed",loc))  q:loc=""  d
    .s cat=""  f  s cat=$O(^TMP(WardId,Process,"RecLocMed",loc,cat)) q:cat=""  d
    ..s ^DHCCLNurseExec("SendMedic",loc,$P($H,","),WardId,cat)=Ward_"^"_userId_"^"_Date_"^"_Time
	q 0
}

ClassMethod sendMessage()
{
}

/// EH 2015-03-13 按照Arc / Dsp汇总库存 / 03-17 汇总费用
ClassMethod GetAanArcStock(userId, process, ArRow, dhcDspIdStr, RecLoc) As %String
{
	//s ^EH("da","gaas")=userId_","_process_","_ArRow_","_dhcDspIdStr
	k ^TMP("NurDrug",userId,process,"AanArc")
	k ^TMP("NurDrug",userId,process,"AanArr")
	s config=##class(web.NurseSetNew).findsimple("durgauditnew","other","1")
	s f3=$p(config,"^",4) // 库存提示
	s f4=$p(config,"^",5) // 库存控制
	s f5=$p(config,"^",6) // 审发提示
	s f6=$p(config,"^",7) // 审发控制
	s checkloc=##Class(web.UDHCJFARREARSMANAGE).CheckLoc($g(%session.Data("LOGON.CTLOCID")))
	i (f3'="Y")&(checkloc'="0") q ""
	i (dhcDspIdStr'="") d
	.s length1=$l(dhcDspIdStr,"^")
	.f index1=1:1:length1 d
	..s dhcDspId=$p(dhcDspIdStr,"^",index1)
	..q:(+dhcDspId'=dhcDspId)
	..s oeoreId=$p($g(^DHCOEDISQTY(dhcDspId)),"^",3)
	..s Ord=+oeoreId,OrdSub=$p(oeoreId,"||",2),OreSub=$p(oeoreId,"||",3)
	..i (ArRow="") s ArRow=$p(^OEORD(Ord,"I",OrdSub,1),"^",2)
	..d buildAanArc1
	e  d
	.s Ord="" f  s Ord=$O(^TMP("NurDrug",userId,process,"AuditRecLoc",ArRow,RecLoc,Ord)) q:Ord=""  d
 	..s OrdSub="" f  s OrdSub=$O(^TMP("NurDrug",userId,process,"AuditRecLoc",ArRow,RecLoc,Ord,OrdSub)) q:OrdSub=""  d
    ...s OreSub="" f  s OreSub=$O(^TMP("NurDrug",userId,process,"AuditRecLoc",ArRow,RecLoc,Ord,OrdSub,OreSub)) q:OreSub=""  d
	....s dhcDspId=$o(^TMP("NurDrug",userId,process,"AuditRecLoc",ArRow,RecLoc,Ord,OrdSub,OreSub,""))
	....d buildAanArc1
	i (f3="Y") d // 提示是前提
	.s arc="" f  s arc=$o(^TMP("NurDrug",userId,process,"AanArc",arc)) q:(arc="")  d
	..q:(arc=0)
	..s loc="" f  s loc=$o(^TMP("NurDrug",userId,process,"AanArc",arc,loc)) q:(loc="")  d
	...s qty=^TMP("NurDrug",userId,process,"AanArc",arc,loc)
	...s IncItm=$O(^INCI(0,"ARCIM_DR",+$p(arc,"||",1),""))
	...s isSE="Y"
	...s isSE2="Y"
	...s arcdes=""
	...s aaundn="0"
	...s stockQty=..IL($G(IncItm),loc,+$h)
	...i (f5="Y") s aaundn=..GetAaUnDQuantity(loc,IncItm) // EH
	...s qty2=qty+aaundn
	...i qty>stockQty s isSE="N"
	...i qty2>stockQty s isSE2="N"
	...i (isSE="N")!(isSE2="N") s arcdes=$p(^ARCIM(+$p(arc,"||",1),+$p(arc,"||",2),1),"^",2)_$c(10,13)_"审核数量超过"_$s((isSE="N"):"实际库存",1:"剩余库存")
	...s isSE=f4_"^"_f6_"^"_isSE_"^"_isSE2_"^"_arcdes
	...s ^TMP("NurDrug",userId,process,"AanArc",arc,loc)=isSE
	i (checkloc="0") d
	.s Ord="" f  s Ord=$o(^TMP("NurDrug",userId,process,"AanArr",Ord)) q:(Ord="")  d
	..s pre2=""
	..s OrdSub="" f  s OrdSub=$o(^TMP("NurDrug",userId,process,"AanArr",Ord,OrdSub)) q:(OrdSub="")  d
	...i (pre2'="") s pre2=pre2_"^"
	...s pre2=pre2_Ord_"||"_OrdSub_$c(2)_^TMP("NurDrug",userId,process,"AanArr",Ord,OrdSub)
	..s checkarr=##Class(web.UDHCJFARREARSMANAGE).CheckArrears(+^OEORD(Ord),pre2,"NE")
	..q:($p(checkarr,"^",5)'="C")
	..s papmii=$p($g(^PAADM(+^OEORD(Ord))),"^",1)
	..s name=$p($g(^PAPER(+papmii,"ALL")),"^",1)
	..s bed=$p($g(^PAADM(+^OEORD(Ord))),"^",73)
	..s bed=$p($g(^PAWARD(+$p(bed,"||",1),"BED",+$p(bed,"||",2))),"^",1)
	..i ($p(checkarr,"^",9)="N") d
	...i bed'["床" s:bed'="" bed=bed_"床" 
	...s ^TMP("NurDrug",userId,process,"AanArr",Ord,0)="N"_"#"_name_" "_bed_$c(10,13)_"费用不足!"
	q ""
buildAanArc1
	q:($d(^TMP("NurDrug",userId,process,"AanArc",0,dhcDspId)))
	s ^TMP("NurDrug",userId,process,"AanArc",0,dhcDspId)=""
	s loc=$P(^DHCOEDISQTY(dhcDspId),"^",24) 
	//s loc=$p(^OEORD(Ord,"I",OrdSub,3),"^",6)
	s Qty=$P(^DHCOEDISQTY(dhcDspId),"^",5)
	s pre1=$g(^TMP("NurDrug",userId,process,"AanArc",ArRow,loc))
	s ^TMP("NurDrug",userId,process,"AanArc",ArRow,loc)=pre1+Qty
	s pre2=$g(^TMP("NurDrug",userId,process,"AanArr",Ord,OrdSub))
	s ^TMP("NurDrug",userId,process,"AanArr",Ord,OrdSub)=pre2+Qty
	//s ^pjfapp("NurDrug",Ord,OrdSub)=^TMP("NurDrug",userId,process,"AanArr",Ord,OrdSub)
	s mainOeoriId=$p($g(^OEORD(Ord,"I",OrdSub,11)),"^",39)
	i (mainOeoriId="") s mainOeoriId=Ord_"||"_OrdSub
	s curOrdSub=$p(mainOeoriId,"||",2)
	i (curOrdSub'=OrdSub) d
	.s curArRow=$p(^OEORD(Ord,"I",curOrdSub,1),"^",2)
	.s curDhcDspId=$o(^TMP("NurDrug",userId,process,"Audit",curArRow,Ord,curOrdSub,OreSub,""))
	.q:(curDhcDspId="")
	.q:($d(^TMP("NurDrug",userId,process,"AanArc",0,curDhcDspId)))
	.s ^TMP("NurDrug",userId,process,"AanArc",0,curDhcDspId)=""
	.;s loc=$p(^OEORD(Ord,"I",curOrdSub,3),"^",6)
	.s loc=$P(^DHCOEDISQTY(curDhcDspId),"^",24) 
	.s Qty=$P(^DHCOEDISQTY(curDhcDspId),"^",5)
	.s pre1=$g(^TMP("NurDrug",userId,process,"AanArc",curArRow,loc))
	.s ^TMP("NurDrug",userId,process,"AanArc",curArRow,loc)=pre1+Qty
	.s pre2=$g(^TMP("NurDrug",userId,process,"AanArr",Ord,curOrdSub))
	.s ^TMP("NurDrug",userId,process,"AanArr",Ord,curOrdSub)=pre2+Qty
	s curOrdSub="" f  s curOrdSub=$o(^OEORDi(0,"OEORI",Ord,mainOeoriId,curOrdSub)) q:(curOrdSub="")  d
	.s curArRow=$p(^OEORD(Ord,"I",curOrdSub,1),"^",2)
	.s curDhcDspId=$o(^TMP("NurDrug",userId,process,"Audit",curArRow,Ord,curOrdSub,OreSub,""))
	.q:(curDhcDspId="")
	.q:($d(^TMP("NurDrug",userId,process,"AanArc",0,curDhcDspId)))
	.s ^TMP("NurDrug",userId,process,"AanArc",0,curDhcDspId)=""
	.s Qty=$P(^DHCOEDISQTY(curDhcDspId),"^",5)
	.s pre1=$g(^TMP("NurDrug",userId,process,"AanArc",curArRow,loc))
	.s ^TMP("NurDrug",userId,process,"AanArc",curArRow,loc)=pre1+Qty
	.s pre2=$g(^TMP("NurDrug",userId,process,"AanArr",Ord,curOrdSub))
	.s ^TMP("NurDrug",userId,process,"AanArr",Ord,curOrdSub)=pre2+Qty
	q
}

ClassMethod AuditMed(userId As %String, process As %String, ArRowStr As %String, recLocIdStr As %String, pogFlagall = "") As %String
{
	i (userId="")!(process="") q 100
	//s ^EH("da","am")=userId_","_process_","_ArRowStr
	s ret=0,sum=0,suc=0
 	s ArRow="" f  s ArRow=$O(^TMP("NurDrug",userId,process,"AuditRecLoc",ArRow)) q:ArRow=""  d
 	.q:(ArRowStr'="")&(("^"_ArRowStr_"^")'[("^"_ArRow_"^")) // + wxl 090331
 	.s RecLoc="" f  s RecLoc=$O(^TMP("NurDrug",userId,process,"AuditRecLoc",ArRow,RecLoc)) q:RecLoc=""  d
 	..q:(recLocIdStr'="")&(("^"_recLocIdStr_"^")'[("^"_RecLoc_"^"))
 	..d ..GetAanArcStock(userId,process,ArRow,"",RecLoc)
 	..s Ord=""  f  s Ord=$O(^TMP("NurDrug",userId,process,"AuditRecLoc",ArRow,RecLoc,Ord)) q:Ord=""  d
 	...s OrdSub=""  f  s OrdSub=$O(^TMP("NurDrug",userId,process,"AuditRecLoc",ArRow,RecLoc,Ord,OrdSub)) q:OrdSub=""  d
    ....s OreSub="" f  s OreSub=$O(^TMP("NurDrug",userId,process,"AuditRecLoc",ArRow,RecLoc,Ord,OrdSub,OreSub)) q:OreSub=""  d
	.....s dhcDspId=$o(^TMP("NurDrug",userId,process,"AuditRecLoc",ArRow,RecLoc,Ord,OrdSub,OreSub,""))
	.....s curret=..AuditGroup(dhcDspId,userId,process,"","","","","AuditMed",pogFlagall)
	.....s $p(ret,"#",1)=$i(sum) // 总数
	.....i (+curret=0) s $p(ret,"#",2)=$i(suc) // 成功数量
	.....i (curret'=0)&($p(ret,"#",3)="") s $p(ret,"#",3)=curret // 仅作第1个提示
	//s a=..SendMsg(ward,ward,userId,Process)  //发送消息  //ypz 070129
	q ..getResText(ret)
}

/// EH 2013-12-05
ClassMethod resetDrugAudit(oeoreId, userId, process)
{
	q ""
}

/// EH 2013-12-05
ClassMethod findDrugDHCDSPId(oeoreId, userId, process)
{
	s Ord=$p(oeoreId,"||",1),OrdSub=$p(oeoreId,"||",2),OeoreSub=$p(oeoreId,"||",3)
	q:(Ord="")!(OrdSub="")!(OeoreSub="")!(userId="")!(process="") ""
	s ArcRow=$p(^OEORD(Ord,"I",OrdSub,1),"^",2)
	q:($d(^TMP("NurDrug",userId,process,"UnAudit",ArcRow,Ord,OrdSub,OeoreSub))) ""
	s dhcDspId=$o(^TMP("NurDrug",userId,process,"Audit",ArcRow,Ord,OrdSub,OeoreSub,""))
	q:(dhcDspId="") ""
	q:(+^TMP("NurDrug",userId,process,"Audit",ArcRow,Ord,OrdSub,OeoreSub,dhcDspId)'=0) ""
	d ..increaseAudit(userId,process,ArcRow,Ord,OrdSub,OeoreSub,dhcDspId)
	q dhcDspId
}

/// EH 2014-12-04 / 0: 成功, 2: 失败 
ClassMethod getResText(ret = "") As %String
{
	i (ret="") q ret
	s sum=$p(ret,"#",1)
	s suc=$p(ret,"#",2)
	s err=$p(ret,"#",3)
	i (err'="") {
		i (sum>suc)&(suc>0) s $p(err,"^",1)="0" // 只要有审核通过的, 就刷新页面
		q err
	}
	i (sum=suc)&(suc>0) q "0"
	q ret
}

ClassMethod PhAudit(dhcDspIdStr, userId, ArcRow = "", locId = "", auditBatchId = "", process = "", pogFlag = "") As %String
{
 //药品审核
 // s ^pjf(1)=dhcDspIdStr_","_userId_","_ArcRow_","_locId_","_auditBatchId_","_process _","_pogFlag = ""
  s dhcDspIdLen=$L(dhcDspIdStr,"^")
  s ret=0,sum=0,suc=0
  d ..GetAanArcStock(userId,process,ArcRow,dhcDspIdStr,locId)
  if (dhcDspIdStr'="")
  {
    f i=1:1:dhcDspIdLen
    {
	  q:($p(ret,"#",3)'="")
	  s dhcDspId=$P(dhcDspIdStr,"^",i)
	  s curret=..AuditGroup(dhcDspId,userId,process,"","","",auditBatchId,"PhAudit",pogFlag)
	  s $p(ret,"#",1)=$i(sum) // 总数
	  i (+curret=0) s $p(ret,"#",2)=$i(suc) // 成功数量
	  i (curret'=0) s $p(ret,"#",3)=curret // 仅作第1个提示
	  //s oeoriId=$p($G(^DHCOEDISQTY(dhcDspId)),"^",1)
	  //s oew=$P(oeoriId,"||")
	  //s chl=$P(oeoriId,"||",2)
	  //s RecLoc=$P(^OEORD(oew,"I",chl,3),"^",6)
	  //s MedTyp=..GetDispCatCode(oeoriId)
	  //s wardId=$O(^PAWARD(0,"WARD_LocationDR",locId,""),-1)  //ypz 070430
	  //s ^DHCCLNurseExec("SendMedic",RecLoc,$P($H,","),wardId,MedTyp)=wardId_"^"_userId_"^"_$P($H,",")_"^"_$P($H,",",2)
    }
  }
  q ..getResText(ret)
}

ClassMethod UnAudit(dhcDspIdStr, userId, process) As %String
{
 //撤消药品审核
  s dhcDspIdLen=$L(dhcDspIdStr,"^")
  s ret=0,sum=0,suc=0
  f i=1:1:dhcDspIdLen
  {
	  q:(($p(ret,"#",3)'=""))
	  s dhcDspId=$P(dhcDspIdStr,"^",i)
	  s curret=..UnAuditGroup(dhcDspId,userId,process)
	  s $p(ret,"#",1)=$i(sum) // 总数
	  i (+curret=0) s $p(ret,"#",2)=$i(suc) // 成功数量
	  i (curret'=0) s $p(ret,"#",3)=curret // 仅作第1个提示
  }
  q ..getResText(ret)
}

ClassMethod IL(inci, loc, dd) As %String
{
 //查询库存
 //n (inci, loc, dd)
 ;ret value :
 ; <0 - error occurs
 q:inci="" 0
 q:loc="" 0
 q:dd="" 0
 s nextdate=dd+1
 s rr=$o(^DHCLOCTOT(0,"LOCITMDATE",loc,inci,nextdate),-1)
 i rr="" q 0
 s rr=$o(^DHCLOCTOT(0,"LOCITMDATE",loc,inci,rr,""),-1)
 i rr="" q 0
 s qty=+$P(^DHCLOCTOT(rr),"^",4)
 q qty
}

ClassMethod GetUnPackExecute(ByRef qHandle As %Binary, userId As %String, locId As %String, std As %String, edd As %String, ArRow As %String, typ = "", dep As %String = "") As %Status
{
   Set repid=$I(^CacheTemp)
 	s ind=1
 	s qHandle=$lb(0,repid,0)

 	i (userId="")!(locId="") Q $$$OK
 	s wardStr=..GetUserWardId(userId,locId)
 	i wardStr="" Q $$$OK
 	s ward=$p($p(wardStr,"|"),"^",2)
 	s ctcpId=$P(^SSU("SSUSR",userId),"^",14)
    i ctcpId'="" s ctcptId=$P(^CTPCP(ctcpId,1),"^",4)  ;CTPCP_CarPrvTp_DR
	i $G(ctcptId)'="" s ctcpType=$P(^CT("CPT",ctcptId),"^",4)  ;CT_CarPrvTp
    i ($G(ctcpType)'="NURSE")  Q $$$OK
    s dep=""
    s hospitaldr=$p(^CTLOC(locId),"^",22)
    s anStr="^"_$G(^DHCANOPSET(hospitaldr,"anloc"))
    i anStr[("^"_locId_"|") s dep=locId
	s opStr=$G(^DHCANOPSET(hospitaldr,"oploc"))
	i opStr[("^"_locId_"|") s dep=locId
 	
 	
 	if (ward="")&(std="")&(edd="")&(ArRow="") Set qHandle=$lb(0,repid,0) Quit $$$OK
 	s std=$ZDH(std,4),edd=$ZDH(edd,4)
 	s ATyp=""
	s Room=""  f  s Room=$O(^PAADMi("CurrWard",ward,Room)) q:Room=""  d
    .s Adm=""  f  s Adm=$O(^PAADMi("CurrWard",ward,Room,Adm)) q:Adm=""  d
    ..s DischgDate=$P(^PAADM(Adm),"^",17)
    ..q:DischgDate'=""
    ..s Patinfo=##class(web.DHCCLCom).PatInfo("^"_Adm)
    ..d ##CLASS(web.DHCTEMPOERPRINT).GetPatLoc(Adm)
    ..s RegNo=$P(Patinfo,"^",1)
    ..s PatName=$P(Patinfo,"^",5)
    ..s BedCode=$P(Patinfo,"^",7)
    ..s Ord="" f  s Ord=$O(^OEORD(0,"Adm",Adm,Ord)) q:Ord=""  d
    ...s OrdSub=0  f  s OrdSub=$O(^OEORD(Ord,"I",OrdSub)) q:OrdSub=""  d
    ....s PriorDR=$P($G(^OEORD(Ord,"I",OrdSub,1)),"^",8)     ;OEC_Priority OEORI_Priority_DR
	....i PriorDR'="" s PriorDes=$P(^OECPR(PriorDR),"^",2) 
	....s Prior="^"_PriorDR_"^" 
	....q:"^6^7^"[Prior
    ....s OrdStat=$P($G(^OEORD(Ord,"I",OrdSub,1)),"^",13)
    ....q:(OrdStat=11)
    ....q:(OrdStat=4)
 	....s OrdDate=$P($G(^OEORD(Ord,"I",OrdSub,3)),"^",7)  ;取得医嘱表医嘱日期时间?加入基础数据表
	....s OrdDate=+OrdDate
	....q:((OrdDate<std)!(OrdDate>edd))&((std'="")&(edd'=""))
	....s OrdTime=$P($G(^OEORD(Ord,"I",OrdSub,1)),"^",17)
	....s DateTime=$ZD(OrdDate,3)_" "_$ZT(OrdTime)
    ....s RecLoc=$P(^OEORD(Ord,"I",OrdSub,3),"^",6)
    ....s ArcRow=$P(^OEORD(Ord,"I",OrdSub,1),"^",2)
    ....s PresNo=$P(^OEORD(Ord,"I",OrdSub,1),"^",14)  //处方号
    ....q:'$D(^ARCIM($P(ArcRow,"||",1),$P(ArcRow,"||",2),1))
    ....s Arcim=$P(^ARCIM($P(ArcRow,"||",1),$P(ArcRow,"||",2),1),"^",2)
    ....s unitUomId=$p($g(^OEORD(Ord,"I",OrdSub,2)),"^",3)
    ....i unitUomId'="" s unitDesc=$p($g(^CT("UOM",unitUomId)),"^",2)
    ....s PacUnit=$P($G(^ARCIM($P(ArcRow,"||",1),$P(ArcRow,"||",2),8)),"^",14)
    ....if PacUnit'="" s packUomDesc=$P(^CT("UOM",PacUnit),"^",2) 
    ....s packUomQty=$p($g(^OEORD(Ord,"I",OrdSub,9)),"^",4)
    ....s phOrdQty=$p($g(^OEORD(Ord,"I",OrdSub,1)),"^",12)
    ....i (phOrdQty'="") s phOrdQtyUnit=phOrdQty_" "_$G(unitDesc)
    ....i packUomQty'=""  s phOrdQtyUnit=packUomQty_" "_packUomDesc 
    ....s res="Y"
    ....s res=..Getdocloc(Adm,Ord,OrdSub)  //只要本科室
	....q:(res="N")&(dep="")
	....s user=$P($G(^OEORD(Ord,"I",OrdSub,7)),"^",1)
    ....q:user=""
	....s DoctorDr=$P(^SSU("SSUSR",user),"^",14)
    ....i DoctorDr'=""  s Doctor=$P(^CTPCP(DoctorDr,1),"^",2) 
    ....s ret="N"
    ....if dep'=""  s ret=..getDep(dep,Ord,OrdSub)
    ....q:(dep'="")&($G(ret)="N")  //手术室审核
    ....s ItemCatDR=$P($G(^ARCIM($P(ArcRow,"||",1),$P(ArcRow,"||",2),1)),"^",10)
    ....s Cat="^"_ItemCatDR_"^"
    ....s PHStat=""
    ....s PHStat=##class(web.DHCCLCom).GetDispensingStat(Ord_"||"_OrdSub)
    ....q:($G(^DHCNURSEITEMCAT("FaYao"))'[Cat)
    ....q:(PHStat'="")
    ....s IncItm=$O(^INCI(0,"ARCIM_DR",$p(ArcRow,"||",1),""))
    ....s StockQty=..IL($G(IncItm),RecLoc,$H)
    ....if StockQty=0 s Reason="没库存"
    ....if StockQty'=0 s Reason="库存不足"
    ....q:IncItm=""
    ....s UomDr=$P(^INCI(IncItm,1),"^",10)
    ....s Uom=$P(^CT("UOM",UomDr),"^",2)
    ....if StockQty'=0  s StockQtyUnit=StockQty_" "_Uom
    ....s PhBasQty=..PhItmBasQty(ArcRow)
    ....if PhBasQty=0 s Reason="药学项基本数量为0"
    ....s Audit=Reason
    ....s ORow=Ord_"|"_OrdSub 
    ....s reclocDesc=""
    ....if RecLoc'="" s reclocDesc=$P(^CTLOC(RecLoc),"^",2)
    ....d OutPutArc1

    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutPutArc1
	set Data=$lb(Doctor,DateTime,PatName,BedCode,Arcim,$G(Qty),$G(Uom),ORow,PriorDes,Audit,PresNo,$G(phOrdQtyUnit),$G(StockQtyUnit),reclocDesc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod PhItmBasQty(Arc) As %String
{
 //求药学项基本数量
	//n (Arc)
	s PHItm=$P(^ARCIM($P(Arc,"||",1),$P(Arc,"||",2),1),"^",12)
	q:PHItm="" ""
	s PHBaseQty=$P(^PHCD($P(PHItm,"||",1),"DF",$P(PHItm,"||",2),2),"^",5)
    q $G(PHBaseQty)
}

ClassMethod GetUnPackFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetUnPackExecute ]
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

Query GetUnPack(userId As %String, locId As %String, std As %String, edd As %String, ArRow As %String, typ = "", dep As %String = "") As %Query(ROWSPEC = "Doctor,OrdDate,PatName,BedCode,Arcim,Qty,Uom,Orw,Prior,Audit,PresNo,phOrdQtyUnit,StockQtyUnit")
{
}

ClassMethod GetUnPackClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetUnPackExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod pack(PresNo)
{
 //药品打包
  	Set Config=##Class(websys.Configuration).%OpenId(1)
	Set MEDDATA=Config.DataNamespace
	Set CurrentNS=$ZNSPACE
	ZN MEDDATA	
    s res= $$PackPresc^DHCPackPresc(PresNo)
    zn CurrentNS
  q res
}

Query Findpat(wardId As %String, unPayFlage As %String) As %Query(ROWSPEC = "regNo,patName,bedNo")
{
}

ClassMethod FindpatExecute(ByRef qHandle As %Binary, wardId As %String, unPayFlage As %String = "false") As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	i wardId="" Set qHandle=$lb(0,repid,0) Quit $$$OK
    s wardId=+wardId
    s roomId=""
    f  s roomId=$O(^PAADMi("CurrWard",wardId,roomId)) q:roomId=""  d
    .s admId=""
    .f  s admId=$O(^PAADMi("CurrWard",wardId,roomId,admId)) q:admId=""  d
    ..s regNo="",patName="",bedNo=""
    ..q:'$d(^PAADM(admId))
	..s feeRetStr=##Class(web.UDHCJFARREARSMANAGE).CheckArrears(admId,"","NE")   //是否允许发药
	..s flag=$p(feeRetStr,"^",9)
	..q:(flag'="Y")&&(unPayFlage="true")
    ..s visitStatus=$p(^PAADM(admId),"^",20)
    ..q:(visitStatus="")||(visitStatus="C")
    ..s regNo=$p(^PAPER(+^PAADM(admId),"PAT",1),"^",1)
    ..s patName=$p(^PAPER(+^PAADM(admId),"ALL"),"^",1)
    ..s bedRowId=$p(^PAADM(admId),"^",73)
    ..q:bedRowId=""
    ..i bedRowId'=""  d  
    ...s wardId=$p(bedRowId,"||",1),bedId=$p(bedRowId,"||",2)
    ...s bedNo=$p(^PAWARD(wardId,"BED",bedId),"^",1)
	..s BedOrder(bedNo)=regNo_"^"_patName
	
	s bedNo=""
	f  s bedNo=$O(BedOrder(bedNo)) q:bedNo=""  d
	.s regNo=$P(BedOrder(bedNo),"^",1)
	.s patName=$P(BedOrder(bedNo),"^",2)
	.Do OutputRowpat
     
     Set qHandle=$lb(0,repid,0)
	 Quit $$$OK
OutputRowpat
	set Data=$lb(regNo,patName,bedNo)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindpatFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindpatExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindpatClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindpatExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetLocLinkDoc(Ord, OrdSub, locId)
{
	s retStr=0
	;q:(Ord="")!(OrdSub="") retStr
	q:(Ord="")!(OrdSub="")!(locId="") retStr
	;s admId=$p($g(^OEORD(Ord)),"^",1)
	;q:admId="" retStr
	;s admLocId=$p(^PAADM(admId),"^",4)
	;q:admLocId="" retStr
	s locIdStr=##Class(web.DHCCLCom).GetLinkLocId(locId)
    s userId=$P($G(^OEORD(Ord,"I",OrdSub,7)),"^",1)
    q:userId="" retStr
    s dep=$P($G(^OEORD(Ord,"I",OrdSub,7)),"^",2)
    i ($p(^CTLOC(dep),"^",2))["麻醉" q retStr
    s doctorDr=$P(^SSU("SSUSR",userId),"^",14)
    q:doctorDr="" retStr
    s docLocId=""
    f  s docLocId=$o(^RB("RES",0,"CTPCP",doctorDr,docLocId)) q:docLocId=""  d
    .;i docLocId=admLocId s retStr=1
    .i ("^"_locIdStr_"^")[("^"_docLocId_"^") s retStr=1
    .;i locIdStr[docLocId s retStr=1
    q retStr
}

/// 护士审核时间
Query GetAuditTime() As %SQLQuery(ROWSPEC = "RowID,FromTime,EndTime,Batch,AuditTime")
{
    select * from DHC_NurDispensingTime
}

/// 护士审核时间维护
/// / w ##class(web.DHCNurDrugAudit).InsertDispAudit(4,"09:00","09:00","09:00")
ClassMethod InsertDispAudit(batch As %String = "", fromTime As %String = "", endTime As %String = "", auditTime As %String = "")
{
	s ^zhou("dd") =batch_","_fromTime_","_endTime_","_auditTime
	q:(batch="")!(fromTime="")!(endTime="")!(auditTime="") "数据不全!"
	s fromTime=$ZTH(fromTime),endTime=$ZTH(endTime),auditTime=$ZTH(auditTime)
	//q:(fromTime=0)!(endTime=0)!(auditTime=0) "时间格式不对!"
	&SQL(Insert into DHC_NurDispensingTime (Batch,FromTime,EndTime,AuditTime) Values (:batch,:fromTime,:endTime,:auditTime))
	b
	i SQLCODE=0 s ret="插入成功!"
	e  s ret="插入失败!"
	q ret
}

ClassMethod UpdateDispAudit(rowID As %String = "", batch As %String = "", fromTime As %String = "", endTime As %String = "", auditTime As %String = "")
{
	q:(rowID="")!(batch="")!(fromTime="")!(endTime="")!(auditTime="") "数据不全!"
	s rowID=+rowID,fromTime=$ZTH(fromTime),endTime=$ZTH(endTime),auditTime=$ZTH(auditTime)
	q:(rowID=0) "RowID不存在!"
	&SQL(Update DHC_NurDispensingTime set Batch=:batch,FromTime=:fromTime,EndTime=:endTime,AuditTime=:auditTime where RowID=:rowID)
	i SQLCODE=0 s ret="更新成功!"
	e  s ret="更新失败!"
	q ret
}

ClassMethod DeleteDispAudit(rowID As %String = "")
{
	s rowID=+rowID
	q:(rowID=0) "RowID不存在!"
	&SQL(Delete From DHC_NurDispensingTime where RowID=:rowID)
	i SQLCODE=0 s ret="删除成功!"
	e  s ret="删除失败!"
	q ret
}

/// w ##Class(web.DHCNurDrugAudit).GetAuditTimeList()
ClassMethod GetAuditTimeList() As %String
{
	///List 加载审核批次
	s retStr=""
    s rowId="" f  s rowId=$O(^DHCNurDisAud(rowId)) q:rowId=""  d
    .s batch=$P(^DHCNurDisAud(rowId),"^",1)
    .i retStr="" s retStr=rowId_"^"_batch
    .e  s retStr=retStr_"|"_rowId_"^"_batch
    q retStr
}

/// ##class(web.DrugAuditNew).GetFaYaoList("6576","4636","197","2",64734,64735,"C","",""," ","","on","","","","","","",0,82800)
ClassMethod GetFaYaoList(process, userId, locId, admId, stdate, edate, typ = "", dep = "", tempOrdFlag = "", Audittyp = "", RollFl = "", longOrdFlag = "", RecLocId = "", ArcimID = "", auditBatchId = "", JSflag = "", DMFlag = "", CYDYFlag = "", StartTime, EndTime) As %String
{
	s ^TEMP("da","gfyl")=$LB(process, userId, locId, admId, stdate, edate, typ , dep , tempOrdFlag , Audittyp , RollFl , longOrdFlag , RecLocId , ArcimID , auditBatchId , JSflag , DMFlag , CYDYFlag , StartTime, EndTime)
	q:(process="")!(userId="")!(locId="")!(admId="")
    i auditBatchId'="" d
 	.s fromTime=$P($G(^DHCNurDisAud(auditBatchId)),"^",2)
 	.s toTime=$P($G(^DHCNurDisAud(auditBatchId)),"^",3)
 	.i fromTime>toTime s fromTime="",toTime=""
 	i (StartTime="") s StartTime=0
 	i (EndTime="") s EndTime=100000
 	s sttDatTim=stdate*100000+StartTime
    s EndDatTim=edate*100000+EndTime
    s Ord="" f  s Ord=$O(^OEORD(0,"Adm",admId,Ord)) q:Ord=""  d
    .f ordSttDate=stdate:1:edate d
    ..s ordSttTime="" f  s ordSttTime=$o(^OEORDi(0,"Date",Ord,ordSttDate,ordSttTime)) q:ordSttTime=""  d
    ...s OrdSub=0 f  s OrdSub=$o(^OEORDi(0,"Date",Ord,ordSttDate,ordSttTime,OrdSub)) q:OrdSub=""  d
    ....s ordComparDateTime=ordSttDate*100000+ordSttTime
    ....q:(ordComparDateTime<sttDatTim)!(ordComparDateTime>EndDatTim)
    ....s ordStatId=$p($g(^OEORD(Ord,"I",OrdSub,1)),"^",13)
    ....q:ordStatId=""
    ....s ordStatDesc=$p($g(^OEC("OSTAT",ordStatId)),"^",1)
    ....q:(ordStatDesc="U")!(ordStatDesc="C")!(ordStatDesc="I")
    ....s locLinkDoc=..GetLocLinkDoc(Ord,OrdSub,locId)
    ....q:locLinkDoc=0                 //过滤非本科室医生开的医嘱
    ....s oeoriId=Ord_"||"_OrdSub
   
    ....s PriorDR=$P($G(^OEORD(Ord,"I",OrdSub,1)),"^",8)     ;OEC_Priority                OEORI_Priority_DR
    ....q:PriorDR=""  //ypz 061001
    ....s PriorDes=$P(^OECPR(PriorDR),"^",2) 
    ....s Prior="^"_PriorDR_"^" 
    ....s oecprCode=##Class(web.DHCCLCom).GetOecprCode(oeoriId)
    ....s ifTempOrder=##class(appcom.OEOrdItem).ISShortOrderPrior(PriorDR,"")
    ....q:(tempOrdFlag="on")&&(longOrdFlag'="on")&&(ifTempOrder'=1)
    ....q:(tempOrdFlag'="on")&&(longOrdFlag="on")&&(ifTempOrder=1)
    ....q:(oecprCode="OM")!(oecprCode="OMST")!(oecprCode="OMCQZT")!(oecprCode="OMLSZT")
    ....i ((tempOrdFlag="")&((oecprCode="NORM")!(oecprCode="STAT"))) q
    ....i ((longOrdFlag="")&(oecprCode="S")) q
    ....;s FillerNo=$P($G(^OEORD(Ord,"I",OrdSub,9)),"^",12) 
    ....;if FillerNo'="" d
    .....;s drugAuditF=..GetAuditDrug(oeoriId)
    ....s res=..Getdocloc(admId,Ord,OrdSub)  //转科科室
    ....s ret="N"
    ....s OrdDate=$P($G(^OEORD(Ord,"I",OrdSub,1)),"^",9)
	....s OrdTime=$P($G(^OEORD(Ord,"I",OrdSub,1)),"^",10)
    ....i dep'=""  s ret=..getDep(dep,Ord,OrdSub)
    ....q:(dep'="")&($G(ret)="N")  //手术科室审核
    ....;s RecLoc=$P(^OEORD(Ord,"I",OrdSub,3),"^",6)
    ....s ArcRow=$P(^OEORD(Ord,"I",OrdSub,1),"^",2)
    ....q:(ArcRow'=ArcimID)&(ArcimID'="")
    ....s ItemCatDR=$P($G(^ARCIM($P(ArcRow,"||",1),$P(ArcRow,"||",2),1)),"^",10)
    ....s Cat="^"_ItemCatDR_"^"
    ....q:$g(^DHCNURSEITEMCAT("FaYao"))'[Cat
    ....s MedTyp=..GetDispCatCode(oeoriId) //发药类型
    ....s IsDM="0",IsJS="0",oecprCode="0"
	....i (DMFlag="on") s IsDM=##class(web.DHCSTINTERFACE).GetPoisonByOrd(oeoriId)
    ....i (JSflag="on") s IsJS=##class(web.DHCSTINTERFACE).GetPoisonByOrdJS(oeoriId)
    ....i (CYDYFlag="on") s oecprCode=##Class(web.DHCCLCom).GetOecprCode(oeoriId)
    ....s ifFilter=..ifFiltering(DMFlag,JSflag,CYDYFlag,IsDM,IsJS,oecprCode)
    ....q:ifFilter'=1
    ....s OeoreSub=0 f  s OeoreSub=$o(^OEORDi(0,"Date",Ord,ordSttDate,ordSttTime,OrdSub,OeoreSub)) q:OeoreSub=""  d
    .....s OrdStat=$p($g(^OEORD(Ord,"I",OrdSub,"X",OeoreSub,"BILL")),"^",1)
    .....s execStatusId=$p($g(^OEORD(Ord,"I",OrdSub,"X",OeoreSub)),"^",16)
    .....i execStatusId'="" s execStat=$p($g(^OEC("STAT",execStatusId)),"^",1)
    .....e  s execStat=""
    .....q:$g(execStat)="D"
    .....;q:(OrdStat=11)
 	.....;q:(OrdStat=10)
    .....;q:(OrdStat=4)&(typ'="C")
    .....s oeoreId=Ord_"||"_OrdSub_"||"_OeoreSub
    .....s sttDate=$p($g(^OEORD(Ord,"I",OrdSub,OeoreSub)),"^",1)
    .....s dhcDspId=0 
    .....s TStopDate="",TStopTime=""
    .....s TStopDate = $p(^OEORD(Ord,"I",OrdSub,3),"^",34)		;XDate
	.....s:$d(^OEORD(Ord,"I",OrdSub,2)) TStopTime = $p(^OEORD(Ord,"I",OrdSub,2),"^",15)		;XTime
	.....s TExEndDate = $p(^OEORD(Ord,"I",OrdSub,9),"^",9)		;OEORI_EndDate	
	.....s TExEndTime = $p(^OEORD(Ord,"I",OrdSub,9),"^",10) 	;OEORI_EndTime
	.....s TStopDate = $s(TStopDate="":TExEndDate, 1:TStopDate)			;没停止日期时,取预停日期	
	.....s TStopTime = $s(TStopTime="":TExEndTime, 1:TStopTime)
	.....s OrdXDate=$P($G(^OEORD(Ord,"I",OrdSub,"X",OeoreSub)),"^",1)  ;取得医嘱表医嘱日期时间?加入基础数据表
	.....s OrdXTime=$P($G(^OEORD(Ord,"I",OrdSub,"X",OeoreSub)),"^",2)
	.....q:((OrdXDate>TStopDate)!((OrdXDate=TStopDate)&&(OrdXTime>TStopTime)))&(TStopDate'="")&(TStopTime'="")  //170817 过滤预停时间之后的领药
    .....f  s dhcDspId=$O(^DHCOEDISQTY(0,"OEORE",oeoreId,dhcDspId))  q:dhcDspId=""  d
    ......;s dhcNewDspId=$O(^DHCOEDISQTY(0,"OEORE",oeoreId,""))
    ......s dhcDspStat=..getLastDspStat(oeoreId) ;$P(^DHCOEDISQTY(dhcDspId),"^",7)
    ......q:dhcDspStat="R"
    ......q:($g(execStat)="D")&(dhcDspStat="R")
    ......q:(OrdStat=11)&(dhcDspStat="R")
 	......q:(OrdStat=10)&(dhcDspStat="R")
    ......q:(OrdStat=4)&(typ'="C")&(dhcDspStat="R")
    ......;q:(OrdStat=4)&(typ="C")&(dhcDspStat="C")
    ......s recLocIdDsp=$P(^DHCOEDISQTY(dhcDspId),"^",24) 
    ......s reclocDsp=$P(^CTLOC(recLocIdDsp),"^",1)  
    ......q:(recLocIdDsp'=RecLocId)&(RecLocId'="") //药房
    ......q:dhcDspStat'=typ
    ......s drugAuditStr=..GetAuditDrug(""_"^"_dhcDspId)
    ......q:(Audittyp="on")&($p(drugAuditStr,"^")="")
    ......q:(Audittyp="")&($p(drugAuditStr,"^")'="")
    ......s dosTime=$P(^DHCOEDISQTY(dhcDspId),"^",20)
    ......//q:(sttDate=edate)&(EndTime'="")&(dosTime>EndTime) //pan  
    ......//q:(sttDate=stdate)&(StartTime'="")&(dosTime<StartTime)
    ......//s OrdDate=ordSttDate // ore sttdate
    ......//s dosDatTim=OrdDate*100000+dosTime
    ......//q:(dosDatTim<sttDatTim)!(dosDatTim>EndDatTim)
    ......//q:($G(fromTime)'="")&($G(toTime)'="")&&((dosTime<fromTime)!(dosTime>toTime))
    ......s Qty=$P(^DHCOEDISQTY(dhcDspId),"^",5)
    ......s uomId=$P(^DHCOEDISQTY(dhcDspId),"^",6)
    ......s PackUom=$p(^CT("UOM",uomId),"^",2) 
    ......s pogFlag=$P(^DHCOEDISQTY(dhcDspId),"^",28)
    ......i ($p(drugAuditStr,"^")'="") s ^TMP("NurDrug",userId,process,"UnAudit",ArcRow,Ord,OrdSub,OeoreSub)="" // EH
    ......///合计数据
    ......s ^TMP("NurDrug",userId,process,"RecLoc",recLocIdDsp,ArcRow,"Qty")=$G(^TMP("NurDrug",userId,process,"RecLoc",recLocIdDsp,ArcRow,"Qty"))+Qty
    ......s ^TMP("NurDrug",userId,process,"RecLoc",recLocIdDsp,ArcRow,"Uom")=PackUom
    ......s ^TMP("NurDrug",userId,process,"RecLoc",recLocIdDsp,ArcRow,"pogFlag")=pogFlag
    ......s pec=$g(^TMP("NurDrug",userId,process,"RecLoc",recLocIdDsp,ArcRow,"Err"))
    ......s errcode=..getIfDrugError(oeoreId,pec)
    ......i (errcode'="") s ^TMP("NurDrug",userId,process,"RecLoc",recLocIdDsp,ArcRow,"Err")=pec_errcode
    ......///明细数据
   	......s ^TMP("NurDrug",userId,process,"Audit",ArcRow,Ord,OrdSub,OeoreSub,dhcDspId)=""
   	......s ^TMP("NurDrug",userId,process,"AuditRecLoc",ArcRow,recLocIdDsp,Ord,OrdSub,OeoreSub,dhcDspId)=""
}

/// Creator: wangxinlei
/// CreatDate: 2009-10-10
/// Description: 对于药品明细审核,点"部分审核"时未打勾的医嘱只填入审核人不置审核标志为"Y"
/// Table：DHC_OEDispensing
/// Input：dhcDspIdStr: 医嘱ID^发药ID(oeoriId^dhcDspId), userId: 操作用户, ArcRow: 药品医嘱ID, locId: 登陆科室ID
/// Return：审核成功返回0,失败返回非0
ClassMethod PartAudit(dhcDspIdStr, userId, ArcRow = "", locId = "", process = "", pogFlag = "") As %String
{
  s dhcDspIdLen=$L(dhcDspIdStr,"^")
  s curDate=+$h,curTime=$p($h,",",2)
  s ret=0,sum=0,suc=0
  d ..GetAanArcStock(userId,process,ArcRow,dhcDspIdStr,locId)
  if (dhcDspIdStr'="")
  {
    f i=1:1:dhcDspIdLen d
	  .q:($p(ret,"#",3)'="")
	  .s tmpDspIdStr=$P(dhcDspIdStr,"^",i)
	  .s selFlag=$P(tmpDspIdStr,"!",1)
	  .s dhcDspId=$P(tmpDspIdStr,"!",2)
	  .q:dhcDspId=""
	  .s curret=..AuditGroup(dhcDspId,userId,process,curDate,curTime,selFlag,"","PartAudit",pogFlag)
	  .s $p(ret,"#",1)=$i(sum) // 总数
	  .i (+curret=0) s $p(ret,"#",2)=$i(suc) // 成功数量
	  .i (curret'=0) s $p(ret,"#",3)=curret // 仅作第1个提示
  }
  q ..getResText(ret)
}

Query FindMasterItem(ARCIMDesc As %String) As %Query(ROWSPEC = "ArcimDesc:%String,ArcimDR:%String")
{
}

ClassMethod FindMasterItemExecute(ByRef qHandle As %Binary, ARCIMDesc As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
    i (ARCIMDesc'="") s ARCIMDesc=$$ALPHAUP^SSUTIL4(ARCIMDesc)
 	s ArcimID=0 
 	f  s ArcimID=$o(^ARCIM(ArcimID)) q:ArcimID=""  d
	.s ArcimSubID=0 f  s ArcimSubID=$o(^ARCIM(ArcimID,ArcimSubID)) q:ArcimSubID=""  d
	..s ArcimDR=ArcimID_"||"_ArcimSubID
	..s AlisDR=$O(^ARC("ALIAS",0,"ARCIM",ArcimDR,""))
	..q:AlisDR=""
	..s AlisDesc=$$ALPHAUP^SSUTIL4($p(^ARC("ALIAS",AlisDR),"^",6))
	..s ArcimDesc=$p(^ARCIM(ArcimID,ArcimSubID,1),"^",2)
	..s ArcimDesc=AlisDesc_"-"_ArcimDesc
	..s arcicId=$p($g(^ARCIM(ArcimID,ArcimSubID,1)),"^",10)
    ..q:arcicId=""
 	..q:'$d(^ARC("IC",arcicId))
 	..s arcicOrderType=$p(^ARC("IC",arcicId),"^",7)
    ..q:arcicOrderType'="R"
	..q:ArcimDesc'[ARCIMDesc
	..//q:$p(ArcimDesc,ARCIMDesc,1)'=""
	..Do OutputRow5
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow5
	set Data=$lb($p(ArcimDesc,"-",2),ArcimDR)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindMasterItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindMasterItemExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else {		
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindMasterItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindMasterItemExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod GetPogLocStr()
{
	s ret="$c(1)"_"1"_"$c(2)"_"中心药房"_"$c(1)"_"1"_"$c(2)"_"中心药房"
	q ret
}

ClassMethod getDrugErrorA(oeoreId) As %String
{
	s skintest=$p($g(^OEORD(+$p(oeoreId,"||",1),"I",+$p(oeoreId,"||",2),5)),"^",2)
	s abnorm=$p($g(^OEORD(+$p(oeoreId,"||",1),"I",+$p(oeoreId,"||",2),11)),"^",3)
	s act=$p($g(^OEORD(+$p(oeoreId,"||",1),"I",+$p(oeoreId,"||",2),11)),"^",21)
	i (act'="") s act=$p($g(^OEC("ACT",act)),"^",1)
	i ('$d(^DHCCLSet("STB","code"))) s ^DHCCLSet("STB","code")="^YY^PSY^DZ^"
	i (skintest="Y")&(abnorm'="N")&(act="") q "A"
	q ""
}

ClassMethod getDrugErrorD(oeoreId) As %String
{
	s arcimId=$p($g(^OEORD(+$p(oeoreId,"||",1),"I",+$p(oeoreId,"||",2),1)),"^",2)
	s arcimEffDateTo=$p(^ARCIM(+$p(arcimId,"||",1),+$p(arcimId,"||",2),7),"^",1)
	s sttDate=$p($g(^OEORD(+$p(oeoreId,"||",1),"I",+$p(oeoreId,"||",2),"X",+$p(oeoreId,"||",3))),"^",1)
	i (arcimEffDateTo<sttDate)&(arcimEffDateTo'="") q "D"
	q ""
}

ClassMethod getDrugErrorS(oeoreId) As %String
{
	s arcimId=$p($g(^OEORD(+$p(oeoreId,"||",1),"I",+$p(oeoreId,"||",2),1)),"^",2)
	s arcimOnItsOwn=$p(^ARCIM(+$p(arcimId,"||",1),+$p(arcimId,"||",2),7),"^",13)
	i (arcimOnItsOwn'="Y") q "S"
	q ""
}

ClassMethod getDrugErrorS2(arcimId) As %String
{
	s arcimOnItsOwn=$p(^ARCIM(+$p(arcimId,"||",1),+$p(arcimId,"||",2),7),"^",13)
	i (arcimOnItsOwn'="Y") q "S"
	q ""
}

ClassMethod getDrugErrorL(oeoreId) As %String
{
	//s locId=$p(^OEORD(+$p(oeoreId,"||",1),"I",+$p(oeoreId,"||",2),3),"^",6)
	s dspId=$O(^DHCOEDISQTY(0,"OEORE",oeoreId,""))
    s locId=$P(^DHCOEDISQTY(dspId),"^",24) 
	s arcimId=$p(^OEORD(+$p(oeoreId,"||",1),"I",+$p(oeoreId,"||",2),1),"^",2)
	q ..getDrugErrorL2(arcimId,locId)
}

ClassMethod getDrugErrorL2(arcimId, locId) As %String
{
	s inci=$o(^INCI(0,"ARCIM_DR",+$p(arcimId,"||",1),"")) 
	q:(inci="") ""
	s ch=$o(^INCI("IL_LOC",+locId,inci,""))
	s dhcincil=$o(^DHCINCIL(0,"INCIL",inci_"||"_ch,""))
	q:(dhcincil="") ""
	s LockFlag=$p(^DHCINCIL(dhcincil),"^",1)
	i (LockFlag="Y") q "L"
	q ""
}

ClassMethod getIfDrugError(oeoreId, previous) As %String
{
	i (previous'["A") {
		s gdea=..getDrugErrorA(oeoreId)
		i (gdea'="") q gdea
	}
	i (previous'["D") {
		s gded=..getDrugErrorD(oeoreId)
		i (gded'="") q gded
	}
	q ""
}

/// ##class(web.DrugAuditNew).getDrugError("139||165||22")
ClassMethod getDrugError(oeoreId) As %String
{
	s ret=""
	s dspId=$O(^DHCOEDISQTY(0,"OEORE",oeoreId,""))
	q:dspId="" "" //非药品
	s ret=ret_..getDrugErrorA(oeoreId) // 皮试非阴性
	s ret=ret_..getDrugErrorD(oeoreId) // 医嘱项截止
	s ret=ret_..getDrugErrorS(oeoreId) // 非独立医嘱
	s ret=ret_..getDrugErrorL(oeoreId) // 药库加锁
	q ret
}

/// EH 2014-07-24 CILIN 审核控制
/// ##class(web.DrugAuditNew).isDrugAuditable("1040||51||1")
ClassMethod isDrugAuditable(oeoreId, ByRef errmsg) As %String
{
	s isda="0"
	d ##class(web.NurseSetNew).getvalues("durgauditnew","error","field1^field4",.errcfg)
	s gde=..getDrugError(oeoreId)
	q:gde="" isda
	s errInfo=""
	s rw="" f  s rw=$o(errcfg(rw)) q:(rw="")  d
	.i (gde[rw)&($p(errcfg(rw),"^",2)="Y") d
	..s isda=$p(errcfg(rw),"^",1)
	..s errInfo=isda_";"_errInfo
	i (isda'="") d
	.s arcim=$p($g(^OEORD(+oeoreId,"I",+$p(oeoreId,"||",2),1)),"^",2)
	.s isda="2^"_$p($g(^ARCIM(+arcim,+$p(arcim,"||",2),1)),"^",2)_$c(10,13)_errInfo
	e  s isda="0"
	q isda
}

/// EH 2013-12-06 ZONGYUAN
ClassMethod AuditSingle(oeoreId, userId, process, curDate, curTime, selFlag, auditBatchId, method, pogFlag)
{
	s retcode=0
	s dhcDspId=..findDrugDHCDSPId(oeoreId,userId,process)
	//i (dhcDspId="") s retcode=retcode+100 q retcode
	i (dhcDspId="") s retcode=retcode+0 	q retcode // EH 12-10
	s curcode=..isDrugAuditable(oeoreId) // EH 2014-07-24
	i (+curcode'=0) s retcode=curcode q retcode	
	s retcode2=..isStockEnough3(oeoreId,userId,process)
	i (+retcode2'=0) {
		d ..resetDrugAudit(oeoreId,userId,process)
		s retcode=retcode2
		q retcode // 库存不足控制
	}
	i (method="PartAudit") d
	.s curcode=..AuditDrug(oeoreId_"^"_dhcDspId,userId,"",pogFlag,selFlag)
	.s retcode=retcode+curcode
	e  i (method="PhAudit") d
	.s curcode=..AuditDrug(""_"^"_dhcDspId,userId,auditBatchId,pogFlag)
	.s retcode=retcode+curcode
	e  i (method="AuditMed") d
	.s curcode=..AuditDrug(oeoreId_"^"_dhcDspId,userId,"",pogFlag)
	.s retcode=retcode+curcode
	e  s retcode=retcode+101
	i (retcode'=0) d ..resetDrugAudit(oeoreId,userId,process)
	i (retcode=0)&(+retcode2=0) s retcode=retcode2 q retcode // 库存不足提示
	q retcode
}

/// EH 2013-12-06 ZONGYUAN 成组审核
ClassMethod AuditGroup(dhcDspId, userId, process, curDate, curTime, selFlag = "", auditBatchId = "", method = "", pogFlag = "")
{
	q:(dhcDspId="") 100
	//s ^EH("da","ag")=dhcDspId_","_userId_","_process_","_curDate_","_curTime_","_selFlag_","_auditBatchId_","_method
	s oeoreId=$p($g(^DHCOEDISQTY(dhcDspId)),"^",3)
	s retcode=0,retcode2=0
	s groupflag=##class(web.NurseSetNew).findsimple("durgauditnew","other","0") // 成组审核
	s groupflag=$p(groupflag,"^",4)
	i (groupflag'="Y") {
		ts
		s retcode=..AuditSingle(oeoreId,userId,process,curDate,curTime,selFlag,auditBatchId,method,pogFlag)
		i (retcode'=0) s retcode2=retcode
		i (+retcode'=0) tro  q retcode
		tc
		q retcode
	}
	ts
	s retcode=..AuditSingle(oeoreId,userId,process,curDate,curTime,selFlag,auditBatchId,method,pogFlag)
	i (retcode'=0) s retcode2=retcode
	i (+retcode'=0) tro  q retcode
	s Ord=$p(oeoreId,"||",1),OrdSub=$p(oeoreId,"||",2),oeoreSub=$p(oeoreId,"||",3)
	s mainOeoriId=$p($g(^OEORD(Ord,"I",OrdSub,11)),"^",39)
	i (mainOeoriId="") s mainOeoriId=Ord_"||"_OrdSub
	s curOeoreId=mainOeoriId_"||"_oeoreSub
	i (curOeoreId'=oeoreId) d
	.s retcode=..AuditSingle(curOeoreId,userId,process,curDate,curTime,selFlag,auditBatchId,method,pogFlag)
	.i (retcode'=0) s retcode2=retcode
	i (+retcode'=0) tro  q retcode
	s curOrdSub="" f  s curOrdSub=$o(^OEORDi(0,"OEORI",Ord,mainOeoriId,curOrdSub)) q:(curOrdSub="")!(+retcode'=0)  d
	.s curOeoreId=Ord_"||"_curOrdSub_"||"_oeoreSub
	.q:(curOeoreId=oeoreId)
	.s retcode=..AuditSingle(curOeoreId,userId,process,curDate,curTime,selFlag,auditBatchId,method,pogFlag)
	.i (retcode'=0) s retcode2=retcode
	i (+retcode'=0) tro  q retcode
	tc
	s retcode=retcode2
	q retcode
}

/// EH 2014-08-07
ClassMethod GetPharmacySimple(code, funname As %String) As %String
{
	s rset=##class(%ResultSet).%New("web.DrugAuditNew:GetPharmacy")
	d rset.Execute("")
	while (rset.Next()) {
		s item=rset.GetData(1)
		s name=rset.GetData(2)
		s rtnval=funname_"('"_$zcvt(item,"O","JS")_"','"_$zcvt(name,"O","JS")_"');"
 		&javascript<#(rtnval)#>
	}
 	q "0"
}

ClassMethod GetPharmacyClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPharmacyExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod GetPharmacyExecute(ByRef qHandle As %Binary, code As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	s loc="" f  s loc=$o(^CTLOC(0,"LocType","D",loc)) q:(loc="")  d
	.s locDateTo=$p(^CTLOC(loc),"^",25)
	.q:(locDateTo'="")&(locDateTo<+$h)
	.s desc=$P(^CTLOC(loc),"^",2)
 	.q:((desc'[code)&(code'=""))
	.s sub=loc
   	.Do OutwardRow
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutwardRow
	set Data=$lb(desc,sub)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetPharmacyFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPharmacyExecute ]
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

Query GetPharmacy(code As %String) As %Query(ROWSPEC = "desc:%String,rw:%String")
{
}

ClassMethod GetMedicineClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetMedicineExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod GetMedicineExecute(ByRef qHandle As %Binary, code As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
    i (code'="") s code=$$ALPHAUP^SSUTIL4(code)
 	s ArcimID=0 
 	f  s ArcimID=$o(^ARCIM(ArcimID)) q:ArcimID=""  d
	.s ArcimSubID=0 f  s ArcimSubID=$o(^ARCIM(ArcimID,ArcimSubID)) q:ArcimSubID=""  d
	..s ArcimDR=ArcimID_"||"_ArcimSubID
	..s AlisDR=$O(^ARC("ALIAS",0,"ARCIM",ArcimDR,""))
	..q:AlisDR=""
	..s AlisDesc=$$ALPHAUP^SSUTIL4($p(^ARC("ALIAS",AlisDR),"^",6))
	..s ArcimDesc=$p(^ARCIM(ArcimID,ArcimSubID,1),"^",2)
	..s ArcimDesc=AlisDesc_"-"_ArcimDesc
	..s arcicId=$p($g(^ARCIM(ArcimID,ArcimSubID,1)),"^",10)
    ..q:arcicId=""
 	..q:'$d(^ARC("IC",arcicId))
 	..s arcicOrderType=$p(^ARC("IC",arcicId),"^",7)
    ..q:arcicOrderType'="R"
	..q:ArcimDesc'[code
	..Do OutputRow5
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow5
	set Data=$lb($p(ArcimDesc,"-",2),ArcimDR)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetMedicineFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetMedicineExecute ]
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

Query GetMedicine(code As %String) As %Query(ROWSPEC = "desc:%String,rw:%String")
{
}

/// EH 2015-03-13 根据汇总判断库存 / 03-17 判断费用
ClassMethod isStockEnough3(oeoreId, userId, process) As %String
{
	s arc=$p(^OEORD(+oeoreId,"I",$p(oeoreId,"||",2),1),"^",2)
	s isFC=$g(^TMP("NurDrug",userId,process,"AanArr",+oeoreId,0))
	s isFC1=$p(isFC,"#",1)
	s isFC2=$p(isFC,"#",2)
	s isFC3=$p(isFC,"#",3)
	i (isFC1="N") q "2^"_isFC2
	s dhcDspId=$O(^DHCOEDISQTY(0,"OEORE",oeoreId,""))
    s loc=$P(^DHCOEDISQTY(dhcDspId),"^",24) 
	//s loc=$p(^OEORD(+oeoreId,"I",$p(oeoreId,"||",2),3),"^",6)
	s isSE=$g(^TMP("NurDrug",userId,process,"AanArc",arc,loc))
	s isSE1=$p(isSE,"^",1)
	s isSE2=$p(isSE,"^",2)
	s isSE3=$p(isSE,"^",3)
	s isSE4=$p(isSE,"^",4)
	s isSE5=$p(isSE,"^",5)
	i (isSE1="Y")&(isSE3="N") q "2^"_isSE5
	i (isSE2="Y")&(isSE4="N") q "2^"_isSE5
	i (isSE3="N")!(isSE4="N") q "0^"_isSE5
	q "0"
}

/// EH 2014-08-15 设置临时存储 / 08-18 recloc
ClassMethod SetAaUnDRecord(dsp) As %String
{
	i (dsp="") q "-100"
	s oeoreId=$p($g(^DHCOEDISQTY(dsp)),"^",3)
	s arc=$p($g(^OEORD(+oeoreId,"I",+$p(oeoreId,"||",2),1)),"^",2)
	s inc=$o(^INCI(0,"ARCIM_DR",+$p(arc,"||",1),""))
	s recloc=$p($g(^DHCOEDISQTY(dsp)),"^",24)
	//s recloc=$p($g(^OEORD(+oeoreId,"I",+$p(oeoreId,"||",2),3)),"^",6)
	i (inc="")!(recloc="") q "-100"
	s auditFlag=$p($g(^DHCOEDISQTY(dsp)),"^",17)
	i (auditFlag="Y") {
		i (##class(Nur.NurseTempNew).data("AaUnDN",recloc,inc,dsp)) q "-101"
		d ##class(Nur.NurseTempNew).save("AaUnDN",recloc,inc,dsp,+$h)
		q "0"
	}
	i ('##class(Nur.NurseTempNew).data("AaUnDN",recloc,inc,dsp)) q "-101"
	d ##class(Nur.NurseTempNew).delete("AaUnDN",recloc,inc,dsp)
	q "0"
}

/// EH 2014-08-15 HUAYING 审核而未发药数量 / 08-18 loc
ClassMethod GetAaUnDQuantity(loc, inc, deleteflag = "") As %String
{
	s tkaudsp=""
	s aaundn="0"
	s aaundn2="0"
	i (loc="")!(inc="") q aaundn
	s dsp="0" f  s dsp=##class(Nur.NurseTempNew).order("AaUnDN",loc,inc,dsp,"",4) q:(dsp="")  d
	.s oeoreId=$p($g(^DHCOEDISQTY(dsp)),"^",3)
	.q:(oeoreId="")!((+oeoreId)=0)
	.s quitflag=..discountin(oeoreId) // 如同出院，不计算不清除
	.q:(quitflag'="0")
	.s quitflag="0"
	.s auditFlag=$p($g(^DHCOEDISQTY(dsp)),"^",17)
	.i (auditFlag'="Y") s quitflag="1" // 不是审核状态
	.s dhcDspStat=$p($g(^DHCOEDISQTY(dsp)),"^",7)
	.i (dhcDspStat'="TC") s quitflag="1" // 只计算未发药
	.s execStatus=+$p($g(^OEORD(+oeoreId,"I",+$p(oeoreId,"||",2),"X",+$p(oeoreId,"||",3))),"^",16)
	.s execStatus=$p($g(^OEC("STAT",execStatus)),"^",1)
	.i (execStatus="D") s quitflag="1" // 停止执行不计算在内
	.i (quitflag="1") s tkaudsp=$s((tkaudsp=""):dsp,1:(tkaudsp_"^"_dsp)) q
	.s aaundn2=aaundn2+$p($g(^DHCOEDISQTY(dsp)),"^",5)
	.s aaundn=$i(aaundn)
	i (deleteflag) d // 清楚否则的记录
	.s length2=$l(tkaudsp,"^")
	.f index2=1:1:length2 d
	..s dsp=$p(tkaudsp,"^",index2)
	..i (dsp="") q
	..d ##class(Nur.NurseTempNew).delete("AaUnDN",loc,inc,dsp)
	q aaundn2
}

ClassMethod discountin(oeoreId) As %String
{
	s discount="0"
	q:oeoreId="" discount
	s adm=$p($g(^OEORD(+oeoreId)),"^",1)
	s visitus=$p($g(^PAADM(adm)),"^",20)
	i (visitus="D") s discount="1" // 已出院不计算
	s id="" f  s id=$o(^DHCNURABNORMALIGN(0,"OEOREID",oeoreId,id)) q:(id="")!(discount="1")  d
	.s abnormalStatID=$p($g(^DHCNURABNORMALIGN(id)),"^",6)
	.q:(abnormalStatID="")
	.s abnormalStat=$p($g(^DHCDishChargeSet("Disch","AbnormalStat",abnormalStatID)),"^",1)
	.q:(abnormalStat'="未领药")
	.s discount="1"
	q discount
}

/// /过滤  毒麻,精神，出院带药
/// Output：1：不过滤，0：过滤
/// w ##class(web.DrugAuditNew).ifFiltering("on","on","on","1","1","OUT")
ClassMethod ifFiltering(DMFlag, JSflag, CYDYFlag, IsDM, IsJS, oecprCode)
{
	if (DMFlag="on")&&(JSflag="on")&&(CYDYFlag="on")
	{
		if (IsDM'=1)&&(IsJS'=1)&&(oecprCode'="OUT") q 0
		e  q 1
		
		}
	if (DMFlag="on")&&(JSflag="on")
	{
		if (IsDM'=1)&&(IsJS'=1) q 0
		e  q 1
		}
	if (DMFlag="on")&&(CYDYFlag="on")
	{
		if (IsDM'=1)&&(oecprCode'="OUT") q 0
		e  q 1
		}
	if (JSflag="on")&&(CYDYFlag="on")
	{
		if (IsJS'=1)&&(oecprCode'="OUT") q 0
		e  q 1
		}
	if (DMFlag="on")
	{
		if (IsDM'=1) q 0
		e  q 1
		}
	if (JSflag="on")
	{
		if (IsJS'=1) q 0
		e  q 1
		}
	if (CYDYFlag="on")
	{
		if (oecprCode'="OUT") q 0
		e  q 1
		}
	q 1
}

ClassMethod GetFYTimeSet(LocId, pharmacyDr = "")
{
	s:LocId="" LocId=%session.Data("LOGON.CTLOCID")
	s rtnStr=""
	q:(LocId="") rtnStr
	s hospId=$p(^CTLOC(LocId),"^",22)
	k tempFYTimeList
	s rw=""
	for {
		s rw=$o(^User.DHCNurFaYaoTimeSetI("HospID"," "_hospId,rw)) q:rw=""
		s data=^User.DHCNurFaYaoTimeSetD(rw)
		s ward=$lg(data,5)
		continue:(LocId'=ward)&&(ward'="")
	    s pharmacyId=$lg(data,9)
	    continue:(pharmacyDr'="")&&(pharmacyDr'=pharmacyId)&&(pharmacyId'="")
	    continue:(pharmacyDr="")&&(pharmacyId'="")
	    if (pharmacyDr=""){
		    s tempFYTimeList(1)=rw
		}else{
			if (ward'="")&&(pharmacyId'=""){
				s tempFYTimeList(1)=rw
			}elseif(ward="")&&(pharmacyId'=""){
				s tempFYTimeList(2)=rw
			}else{
				s tempFYTimeList(3)=rw
			}
		}
	}
	s index=$o(tempFYTimeList(0))
	q:index="" rtnStr
	s rw=$g(tempFYTimeList(index))
	q:rw="" rtnStr
	s data=^User.DHCNurFaYaoTimeSetD(rw)
	s EDate=$lg(data,2)
	s ETime=$lg(data,3)
	s SDate=$lg(data,7)
    s STime=$lg(data,8)
	s rtnStr=SDate_"^"_EDate_"^"_$zt(STime,2)_"^"_$zt(ETime,2)
    q rtnStr
}

ClassMethod CancelAuditMed(userId As %String, process As %String, ArRowStr As %String, RecLocStr) As %String
{
	i (userId="")!(process="") q 100
	//s ^EH("da","am")=userId_","_process_","_ArRowStr
	s ret=0,sum=0,suc=0
 	s ArRow="" f  s ArRow=$O(^TMP("NurDrug",userId,process,"AuditRecLoc",ArRow)) q:ArRow=""  d
 	.q:(ArRowStr'="")&(("^"_ArRowStr_"^")'[("^"_ArRow_"^")) // + wxl 090331
 	.s RecLoc="" f  s RecLoc=$O(^TMP("NurDrug",userId,process,"AuditRecLoc",ArRow,RecLoc)) q:RecLoc=""  d
 	..q:(RecLocStr'="")&(("^"_RecLocStr_"^")'[("^"_RecLoc_"^")) // + wxl 090331
 	..d ..GetAanArcStock(userId,process,ArRow,"",RecLoc)
 	..s Ord=""  f  s Ord=$O(^TMP("NurDrug",userId,process,"AuditRecLoc",ArRow,RecLoc,Ord)) q:Ord=""  d
 	...s OrdSub=""  f  s OrdSub=$O(^TMP("NurDrug",userId,process,"AuditRecLoc",ArRow,RecLoc,Ord,OrdSub)) q:OrdSub=""  d
    ....s OreSub="" f  s OreSub=$O(^TMP("NurDrug",userId,process,"AuditRecLoc",ArRow,RecLoc,Ord,OrdSub,OreSub)) q:OreSub=""  d
	.....s dhcDspId=$o(^TMP("NurDrug",userId,process,"AuditRecLoc",ArRow,RecLoc,Ord,OrdSub,OreSub,""))
	.....s curret=..UnAuditGroup(dhcDspId,userId,process)  //..AuditGroup(dhcDspId,userId,process,"","","","","AuditMed")
	.....s $p(ret,"#",1)=$i(sum) // 总数
	.....i (+curret=0) s $p(ret,"#",2)=$i(suc) // 成功数量
	.....i (curret'=0) s $p(ret,"#",3)=curret // 仅作第1个提示
	//s a=..SendMsg(ward,ward,userId,Process)  //发送消息  //ypz 070129
	q ..getResText(ret)
}

ClassMethod SendMeg(ArRowStr, userId, process)
{
   //s ^JYW("SendMsg")=$LB(ArRowStr,userId,process)
	s ArRow="" f  s ArRow=$O(^TMP("NurDrug",userId,process,"Audit",ArRow)) q:ArRow=""  d
 	.q:(ArRowStr'="")&(("^"_ArRowStr_"^")'[("^"_ArRow_"^")) // + wxl 090331
 	.s Ord=""  f  s Ord=$O(^TMP("NurDrug",userId,process,"Audit",ArRow,Ord)) q:Ord=""  d
 	..s OrdSub=""  f  s OrdSub=$O(^TMP("NurDrug",userId,process,"Audit",ArRow,Ord,OrdSub)) q:OrdSub=""  d
 	...s AdmID=$P(^OEORD(+Ord),"^")
 	...s papmiId=+$g(^PAADM(+AdmID))
    ...s Arcim=$P(^ARCIM($P(ArRow,"||",1),$P(ArRow,"||",2),1),"^",2)
 	...s MsgContent=Arcim_",暂停配液"
 	...s OreSub="" f  s OreSub=$O(^TMP("NurDrug",userId,process,"Audit",ArRow,Ord,OrdSub,OreSub)) q:OreSub=""  d
	....s dhcDspId=$o(^TMP("NurDrug",userId,process,"Audit",ArRow,Ord,OrdSub,OreSub,""))
	....s curret=..SetPogflaggroup(dhcDspId,userId,process)	
    q 0
}

ClassMethod SetPogflaggroup(dhcDspId, userId, process)
{
	q:(dhcDspId="") 100
	//s ^JYW("SetPogflaggroup",dhcDspId)=$LB(dhcDspId, userId, process)
	s oeoreId=$p($g(^DHCOEDISQTY(dhcDspId)),"^",3)
	s retcode=0,retcode2=0
	s groupflag=##class(web.NurseSetNew).findsimple("durgauditnew","other","0") // 成组审核
	s groupflag=$p(groupflag,"^",4)
	 
	i (groupflag'="Y") {
		ts
		s retcode=..SetPogflagSingle(oeoreId,userId,process)
		i (retcode'=0) s retcode2=retcode
		i (+retcode'=0) tro  q retcode
		tc
		q retcode
	}
	ts
 
	s retcode=..SetPogflagSingle(oeoreId,userId,process)
 
	i (retcode'=0) s retcode2=retcode
	i (+retcode'=0) tro  q retcode
 
	s Ord=$p(oeoreId,"||",1),OrdSub=$p(oeoreId,"||",2),oeoreSub=$p(oeoreId,"||",3)
	s mainOeoriId=$p($g(^OEORD(Ord,"I",OrdSub,11)),"^",39)
	i (mainOeoriId="") s mainOeoriId=Ord_"||"_OrdSub
	s curOeoreId=mainOeoriId_"||"_oeoreSub
	i (curOeoreId'=oeoreId) d
	.s retcode=..SetPogflagSingle(curOeoreId,userId,process)
	.i (retcode'=0) s retcode2=retcode
	i (+retcode'=0) tro  q retcode
 
	s curOrdSub="" f  s curOrdSub=$o(^OEORDi(0,"OEORI",Ord,mainOeoriId,curOrdSub)) q:(curOrdSub="")!(+retcode'=0)  d
	.s curOeoreId=Ord_"||"_curOrdSub_"||"_oeoreSub
	.q:(curOeoreId=oeoreId)
	.s retcode=..SetPogflagSingle(curOeoreId,userId,process)
	.i (retcode'=0) s retcode2=retcode
	i (+retcode'=0) tro  q retcode
	tc
	s retcode=retcode2
	q retcode
}

ClassMethod SetPogflagSingle(oeoreId, userId, process)
{
	s retcode=0
	s dhcDspId=..findDrugDHCDSPIdNew(oeoreId,userId,process)
	 
	i (dhcDspId="") s retcode=retcode+0 	q retcode // EH 12-10
 	s curcode=..SetPogflag(oeoreId_"^"_dhcDspId,userId)
	s retcode=retcode+curcode
 
	
	q retcode
}

ClassMethod SetPogflag(oeoreId, userId)
{
	q:oeoreId="" ""
	q:userId="" ""
	s ret=""
	s pogFlag="E"
    s dhcDspId=$P(oeoreId,"^",2)
    s oeoreId=$P(oeoreId,"^")
    s curDate =+$H
    s curTime=$P($H,",",2)
    i dhcDspId="" d
	.&sql(update DHC_OEDispensing set DSP_PogFlag=:pogFlag where DSP_OEORE_DR=:oeoreId)
	.s ret=SQLCODE
	e  d
	.;&sql(update DHC_OEDispensing set DSP_ConfirmUser=:userId,DSP_DateConfirm=:curDate,DSP_TimeConfirm=:curTime,DSP_PogFlag=:pogFlag where DSP_RowId=:dhcDspId)
	.&sql(update DHC_OEDispensing set DSP_PogFlag=:pogFlag where DSP_RowId=:dhcDspId)

	.s ret=SQLCODE
	i ('SQLCODE) d ..SetAaUnDRecord(dhcDspId) // 因为都有传ord和dsp的大丈夫
	q ret
}

///  
ClassMethod findDrugDHCDSPIdNew(oeoreId, userId, process)
{
	s Ord=$p(oeoreId,"||",1),OrdSub=$p(oeoreId,"||",2),OeoreSub=$p(oeoreId,"||",3)
	q:(Ord="")!(OrdSub="")!(OeoreSub="")!(userId="")!(process="") ""
	s ArcRow=$p(^OEORD(Ord,"I",OrdSub,1),"^",2)
   s dhcDspId=$o(^TMP("NurDrug",userId,process,"Audit",ArcRow,Ord,OrdSub,OeoreSub,""))
	q:(dhcDspId="") ""
	q:(+^TMP("NurDrug",userId,process,"Audit",ArcRow,Ord,OrdSub,OeoreSub,dhcDspId)'=0) ""
	d ..increaseAudit(userId,process,ArcRow,Ord,OrdSub,OeoreSub,dhcDspId)
	q dhcDspId
}

/// w ##class(web.DrugAuditNew).SetpogflagDetail()
ClassMethod SetpogflagDetail(dhcDspIdStr, userId, process = "") As %String
{
	
	;SetPogflaggroup(dhcDspId, userId, process)
 //药品审核
 //s ^TMP("SetpogflagDetail")=$LB(dhcDspIdStr, userId, process )
  s dhcDspIdLen=$L(dhcDspIdStr,"^")
  s ret=0,sum=0,suc=0
  if (dhcDspIdStr'="")
  {
    f i=1:1:dhcDspIdLen
    {
	  q:($p(ret,"#",3)'="")
	  s dhcDspId=$P(dhcDspIdStr,"^",i)
	  s curret=..SetPogflaggroup(dhcDspId,userId,process)
	  s $p(ret,"#",1)=$i(sum) // 总数
	  i (+curret=0) s $p(ret,"#",2)=$i(suc) // 成功数量
	  i (curret'=0) s $p(ret,"#",3)=curret // 仅作第1个提示
    }
  }
  q ..getResText(ret)
}

/// GXB 2014-09-22
/// 成组判断是否打包（静配）
/// OutPut:"Y":是，"":否
/// w ##class(web.DrugAuditNew).IfGroupPivaPog("1405||80||1")
ClassMethod IfGroupPivaPog(oeoreId)
{
	 Set ret=""
	 ;入参医嘱
	 Set pivapogCur=##class(web.DHCSTPIVA).GetPivaPack(oeoreId) //判断是否是静配，如果是直接打包
     If pivapogCur="Y" 
     {
	    Set ret="Y"
	    Quit ret 
	 }
	 ;主医嘱
	 Set Ord=$p(oeoreId,"||",1),OrdSub=$p(oeoreId,"||",2),oeoreSub=$p(oeoreId,"||",3) 
	 Set mainOeoriId=$p($g(^OEORD(Ord,"I",OrdSub,11)),"^",39)
	 If mainOeoriId="" 
	 {
	    Set mainOeoriId=Ord_"||"_OrdSub 
     }
	 Set curOeoreId=mainOeoriId_"||"_oeoreSub
	 If (curOeoreId'=oeoreId)
	 {
		 Set pivapogCur=##class(web.DHCSTPIVA).GetPivaPack(curOeoreId) //判断是否是静配，如果是直接打包
         If pivapogCur="Y" 
         {
	        Set ret="Y" 
	        Quit ret
	     }
	 }
	 ;子医嘱
	 Set curOrdSub=""
	 Set pivapogCur=""
	 for
	 {
		 Set curOrdSub=$o(^OEORDi(0,"OEORI",Ord,mainOeoriId,curOrdSub))
		 Quit:(curOrdSub="")||(pivapogCur="Y")
		 Set curOeoreId=Ord_"||"_curOrdSub_"||"_oeoreSub
		 Set pivapogCur=##class(web.DHCSTPIVA).GetPivaPack(curOeoreId)
	 }    
	 If pivapogCur="Y" 
     {
	     Set ret="Y"
	     Quit ret
	 }
	 Else
	 {
		 Quit ret
	 }
}

/// 取预停时间
ClassMethod GetOeoriEndDateTime(oeordId, oeoriSub)
{
	 s oeoriEndDate=$p($g(^OEORD(oeordId,"I",oeoriSub,9)),"^",9)
	 s oeoriEndTime=$p($g(^OEORD(oeordId,"I",oeoriSub,9)),"^",10)
	 s oeoriEndDateTime=""
     i (oeoriEndDate'="")&&(oeoriEndTime'="")
     {
	     s oeoriEndDateTime=oeoriEndDate*100000+oeoriEndTime  //预停
	 }
	 Q oeoriEndDateTime
}

/// 取执行记录最新的发药状态
/// ##class(web.DrugAuditNew).getLastDspStat("4||62||4")
ClassMethod getLastDspStat(oeoreId)
{
	s dhcDspId=$O(^DHCOEDISQTY(0,"OEORE",oeoreId,""),-1) 
	s dhcDspStat=$P(^DHCOEDISQTY(dhcDspId),"^",7)
    q $g(dhcDspStat)
}

}
