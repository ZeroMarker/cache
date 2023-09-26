Import sqluser

/// creator:	 yunhaibao
/// createdate:  2018-04-12
/// description: 配液中心配伍审核统计
Class web.DHCSTPIVAS.Report.OeAuditStat Extends %RegisteredObject
{

/// description: 配伍审核统计-拒绝明细
/// input:		
/// w ##class(%ResultSet).RunQuery("web.DHCSTPIVAS.Report.OeAuditStat","OeAuditStatDetail","3","2019-10-15","2022-01-15","89")
/// output:		
Query OeAuditStatDetail(cacuType, startDate, endDate, pivaLoc) As websys.Query(ROWSPEC = "wardDesc,docLocDesc,doctorDesc,patNo,patName,reasonStr,userName,ordDate,incDesc,prescNo,gycgFlag,amt,phaOrdDate,dosage,freq,instruct,oeori,phaOrd") [ SqlProc ]
{
}

ClassMethod OeAuditStatDetailExecute(ByRef qHandle As %Binary, cacuType, startDate, endDate, pivaLoc) As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
	q:cacuType="" $$$OK
	q:(startDate="")||(endDate="")||(pivaLoc="") $$$OK
	s startDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(startDate)
	s endDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(endDate)
	k OeAuditStatDetailArr // 排序用,组数,袋数
	k OeAuditStatDetailExist
	s cacuDate=""
	// 统计医嘱审核
	s count=0
	s cacuDate=""
	f cacuDate=endDate:-1:startDate d
    .s phaOrd=""
    .f  s phaOrd=$o(^DHCPHORDM(0,"DateLoc",cacuDate,pivaLoc,phaOrd)) q:phaOrd=""  d
    ..s appType=$p(^DHCPHORDM(phaOrd),"^",9)
    ..q:appType'="PIVAS"
    ..q:$p(^DHCPHORDM(phaOrd),"^",2)="D"
    ..s phaOrdItm=$o(^DHCPHORDM(phaOrd,"I",""))
    ..q:phaOrdItm=""
    ..s phaOrdResultStr=##class(web.DHCSTPIVAS.Common).GetPhaOrdResult(phaOrd)
    ..s phaOrdResult=$p(phaOrdResultStr,"^",1)
    ..q:phaOrdResult'="SHJJ"
    ..s mOeori=$p(^DHCPHORDM(phaOrd,"I",phaOrdItm),"^",2)
    ..q:$d(OeAuditStatDetailExist("mOeori",mOeori))
    ..s OeAuditStatDetailExist("mOeori",mOeori)=""
    ..s userDr=$p(^DHCPHORDM(phaOrd),"^",1)
	..s mDsp=$o(^DHCOEDISQTY(0,"OEORI",mOeori,""))
	..q:mDsp=""
	..s mOrd=+mOeori
	..s mOrdItm=$p(mOeori,"||",2)
	..s reasonStr=##class(web.DHCSTPIVAS.Common).GetOrdPassReason(phaOrd,$c(13,10))
	..s wardLocId=$p(^DHCOEDISQTY(mDsp),"^",22)
	..s wardDesc=$p(^CTLOC(wardLocId),"^",2)
	..s docLocId=$p(^OEORD(mOrd,"I",mOrdItm,7),"^",2)
	..s docLocDesc=$s(docLocId'="":$p(^CTLOC(docLocId),"^",2),1:"未知")
	..s doctorDesc=$p(##class(web.DHCSTPIVAS.Common).OeoriDoctor(mOeori),"^",2)
	..s ordDate=$p(^OEORD(mOrd,"I",mOrdItm,1),"^",9)
	..s ordDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(ordDate)
	..s admId=$p(^OEORD(mOrd),"^",1)
	..s patId=$p(^PAADM(admId),"^",1)
	..s patName=$p(^PAPER(patId,"ALL"),"^",1)
	..s patNo=$p(^PAPER(patId,"PAT",1),"^",1)
	..s userName=$p($g(^SSU("SSUSR",userDr)),"^",2)
	..s ordEndDate=$p(^OEORD(mOrd,"I",mOrdItm,3),"^",34)
	..s prescNo=$p(^OEORD(mOrd,"I",mOrdItm,1),"^",14)
	..s gycgFlag=""
	..i (ordEndDate'="")&&((cacuDate+1)>=ordEndDate) s gycgFlag="是"
	..e  s gycgFlag="否"
	..i $p(^DHCPHORDM(phaOrd),"^",8)="Y" s gycgFlag="是"	
	..s amt="" //##class(web.DHCSTPIVA).GetOrdSpAmt(mOeori)
	..s incDesc=$p(##class(web.DHCSTPIVAS.Common).GetIncItmByOeori(mOeori,""),"^",3)
	..s dosage=##class(web.DHCSTPIVAS.Common).OeoriDosage(mOeori)
	..s freq=$p(##class(web.DHCSTPIVAS.Common).OeoriFreq(mOeori),"^",2)
	..s instruct=$p(##class(web.DHCSTPIVAS.Common).OeoriInstruc(mOeori),"^",2)
	..s oeori=mOeori
	..d MakeDetail
 	..s ordItm=""
 	..f  s ordItm=$O(^OEORDi(0,"OEORI",mOrd,mOeori,ordItm)) Q:(ordItm="")  d
 	...s oeori=mOrd_"||"_ordItm
 	...s arcItm=$p(^OEORD(mOrd,"I",ordItm,1),"^",2)
 	...s arcCat=$p($g(^ARCIM(+arcItm,+$p(arcItm,"||",2),1)),"^",10)
 	...q:$p($g(^ARC("IC",+arcCat)),"^",7)'="R" // 非药品
	...s incDesc=$p(##class(web.DHCSTPIVAS.Common).GetIncItmByOeori(oeori,""),"^",3)
	...s dosage=##class(web.DHCSTPIVAS.Common).OeoriDosage(oeori)
 	...d MakeDetail
	s outputI=""
	f  s outputI=$o(OeAuditStatDetailArr(outputI)) q:outputI=""  d
	.s outputJ=""
	.f  s outputJ=$o(OeAuditStatDetailArr(outputI,outputJ)) q:outputJ=""  d
	..s outputData=OeAuditStatDetailArr(outputI,outputJ)
	..d outputRow
	Quit $$$OK
MakeDetail   
	s detailData1=wardDesc_"^"_docLocDesc_"^"_doctorDesc_"^"_patNo_"^"_patName
	s detailData2=reasonStr_"^"_userName_"^"_ordDate_"^"_incDesc_"^"_prescNo
	s detailData3=gycgFlag_"^"_amt_"^"_$zd(cacuDate,3)_"^"_dosage_"^"_freq
	s detailData4=instruct_"^"_oeori_"^"_phaOrd
	s detailData=detailData1_"^"_detailData2_"^"_detailData3_"^"_detailData4
	s sortIndex=wardDesc_"||"_docLocDesc_"||"_doctorDesc_"||"_ordDate_"^"_phaOrd
	s count=count+1
	s OeAuditStatDetailArr(sortIndex,count)=detailData	
	q
outputRow  
	s Data=$lfs(outputData,"^")
	s ^CacheTemp(repid,ind)=Data    
	s ind=ind+1
	q
}

/// description: 不合理医嘱统计-按病区
/// raq:		 DHCST_PIVAS_不合理医嘱统计_按病区.raq
/// w ##class(%ResultSet).RunQuery("web.DHCSTPIVAS.Report.OeAuditStat","RefusePassWard","89^2019-01-01^2022-04-19")
Query RefusePassWard(inputStr As %Text) As websys.Query(ROWSPEC = "wardDesc,ordCnt") [ SqlProc ]
{
}

ClassMethod RefusePassWardExecute(ByRef qHandle As %Binary, inputStr As %Text) As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
	s pid=..CollOeAuditStat(inputStr,"RefusePassWard")
	d ..QueryOutput(repid,ind,pid,"RefusePassWard")
	q $$$OK
}

/// description: 不合理医嘱统计-按医生科室
/// raq:		 DHCST_PIVAS_不合理医嘱统计_按医生科室.raq
/// w ##class(%ResultSet).RunQuery("web.DHCSTPIVAS.Report.OeAuditStat","RefusePassDocLoc","89^2021-05-31^2021-09-29^^^^^^^^^A")
Query RefusePassDocLoc(inputStr As %Text) As websys.Query(ROWSPEC = "docLocDesc,ordCnt") [ SqlProc ]
{
}

ClassMethod RefusePassDocLocExecute(ByRef qHandle As %Binary, inputStr As %Text) As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
	s pid=..CollOeAuditStat(inputStr,"RefusePassDocLoc")
	d ..QueryOutput(repid,ind,pid,"RefusePassDocLoc")
	q $$$OK
}

/// description: 不合理医嘱统计-按原因
/// raq:		 DHCST_PIVAS_不合理医嘱统计_按原因.raq
/// w ##class(%ResultSet).RunQuery("web.DHCSTPIVAS.Report.OeAuditStat","RefusePassReason","248^2019-01-01^2020-04-19")
Query RefusePassReason(inputStr As %Text) As websys.Query(ROWSPEC = "reasonDesc,ordCnt") [ SqlProc ]
{
}

ClassMethod RefusePassReasonExecute(ByRef qHandle As %Binary, inputStr As %Text) As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
	s pid=..CollOeAuditStat(inputStr,"RefusePassReason")
	d ..QueryOutput(repid,ind,pid,"RefusePassReason")
	q $$$OK
}

/// description: 不合理医嘱统计-按明细
/// raq:		 DHCST_PIVAS_不合理医嘱统计_按明细.raq
/// w ##class(%ResultSet).RunQuery("web.DHCSTPIVAS.Report.OeAuditStat","RefusePassDetail","248^2019-01-01^2020-04-19")
Query RefusePassDetail(inputStr As %Text) As websys.Query(ROWSPEC = "wardDesc,docLocDesc,oeoriDate,patNo,patName,reasonDesc,auditUser,incDesc,freqDesc,instruDesc,dosage,phaOrd,oeori") [ SqlProc ]
{
}

ClassMethod RefusePassDetailExecute(ByRef qHandle As %Binary, inputStr As %Text) As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
	s pid=..CollOeAuditStat(inputStr,"RefusePassDetail")
	d ..QueryOutput(repid,ind,pid,"RefusePassDetail")
	q $$$OK
}

/// description: 干预医嘱统计-按病区
/// raq:		 DHCST_PIVAS_不合理医嘱统计_按明细.raq
/// w ##class(%ResultSet).RunQuery("web.DHCSTPIVAS.Report.OeAuditStat","InterveneWard","89^2019-01-01^2022-04-19")
Query InterveneWard(inputStr As %Text) As websys.Query(ROWSPEC = "calcuGrpDesc,shCnt:%Double,shjjCnt:%Double,gycgCnt:%Double") [ SqlProc ]
{
}

ClassMethod InterveneWardExecute(ByRef qHandle As %Binary, inputStr As %Text) As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
	s pid=..CollOeAuditStat(inputStr,"InterveneWard")
	d ..QueryOutput(repid,ind,pid,"InterveneWard")
	q $$$OK
}

/// description: 准备审核统计的数据
ClassMethod CollOeAuditStat(inputStr, queryType)
{
#;	s ^TMPDHCSTPARAMS("web.DHCSTPIVAS.Report.OeAuditStat","CollOeAuditStat")=$lb(inputStr, queryType)
	q:(inputStr="")||(queryType="") ""
    s PivaLocId=$p(inputStr,"^",1) 		 	// 配液中心		
    s AuditStDate =$p(inputStr,"^",2) 		// 审核开始日期
    s AuditEdDate =$p(inputStr,"^",3)   	// 审核结束日期
    s AuditStTime =$p(inputStr,"^",4)  		// 审核开始时间
    s AuditEdTime =$p(inputStr,"^",5)  		// 审核结束时间
    s DocLocId =$p(inputStr,"^",6)   		// 开单科室
    s WardId =$p(inputStr,"^",7)  			// 病区
    s LocGrpId = $p(inputStr,"^",8)  		// 科室组
    s AuditUser =$p(inputStr,"^",9)   		// 审核人
    s IncId = $p(inputStr,"^",10)  			// 药品
    s PatNo =$p(inputStr,"^",11) 			// 登记号
    s SysType=$p(inputStr,"^",12) 			// 类型 I(住院),O(门诊),A(全部)
	s AuditStDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(AuditStDate)
	s AuditEdDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(AuditEdDate)
	s AuditStTime=##class(web.DHCSTInterfaceFromElse).TimeHtmlToLogical(AuditStTime)
	s AuditEdTime=##class(web.DHCSTInterfaceFromElse).TimeHtmlToLogical(AuditEdTime)
    q:(AuditStTime'="")&&(AuditEdTime'="")&&(AuditStDate=AuditEdDate)&&(AuditStTime>AuditEdTime) ""
    q:(PivaLocId="")||(AuditStDate="")||(AuditEdDate="") ""
    s pid=..NewPid()
	s calcuDate=""
	f calcuDate=AuditEdDate:-1:AuditStDate d
    .s phaOrd=""
    .f  s phaOrd=$o(^DHCPHORDM(0,"DateLoc",calcuDate,PivaLocId,phaOrd)) q:phaOrd=""  d
    ..s quitFlag=""
    ..q:$p(^DHCPHORDM(phaOrd),"^",2)="D"
    ..s appType=$p(^DHCPHORDM(phaOrd),"^",9)
    ..q:appType'="PIVAS"
    ..s phaOrdItm=$o(^DHCPHORDM(phaOrd,"I",0))
    ..q:phaOrdItm=""
    ..s phaOrdResultStr=##class(web.DHCSTPIVAS.Common).GetPhaOrdResult(phaOrd)
    ..s phaOrdResult=$p(phaOrdResultStr,"^",1)
    ..q:phaOrdResult=""
	..s mOeori=$p(^DHCPHORDM(phaOrd,"I",phaOrdItm),"^",2)
	..s lastPhaOrd=$o(^DHCPHORDM(0,"OrdItem",mOeori,""),-1)
	..// 一条医嘱有效次数仅为一次
	..q:phaOrd'=lastPhaOrd
	..// 过滤-审核非拒绝
	..q:(queryType'="InterveneWard")&&(phaOrdResult'="SHJJ")
	..// 过滤-按病区仅汇总住院
	..s mOrd=+mOeori
	..s mOrdItm=$p(mOeori,"||",2)
	..s admId=$p(^OEORD(mOrd),"^",1)
	..s admType=$p(^PAADM(admId),"^",2)
	..q:(SysType="I")&&(admType'="I")
	..q:(SysType="O")&&(admType="I")
	..q:("InterveneWard,RefusePassWard"[queryType)&&(admType'="I")
	..s mDsp=$o(^DHCOEDISQTY(0,"OEORI",mOeori,""))
	..q:mDsp=""
	..s wardLocId=$p(^DHCOEDISQTY(mDsp),"^",22)
	..i admType'="I" s wardId="",wardLocId=""
	..e  s wardId=$o(^PAWARD(0,"WARD_LocationDR",wardLocId,""))
	..// 过滤条件-病区
	..q:(WardId'="")&&(WardId'=wardId)
	..// 过滤条件-科室组
	..i LocGrpId'="" d
	...i $d(CollOeAuditStatData("LocGrp",LocGrpId,wardId)) s chkLocGrp=$g(CollOeAuditStatData("LocGrp",LocGrpId,wardId))
	...e  d
	....s chkLocGrp=##class(web.DHCSTPIVAS.Common).CheckLocGrp(LocGrpId,wardId)
	....s CollOeAuditStatData("LocGrp",LocGrpId,wardId)=chkLocGrp
	...i chkLocGrp'=1 s quitFlag=1
	..q:quitFlag'=""
	..s wardDesc=$s(wardLocId'="":$p(^CTLOC(wardLocId),"^",2),1:"")
	..s docLocId=$p(^OEORD(mOrd,"I",mOrdItm,7),"^",2)
	..// 过滤条件-医生科室
	..q:(DocLocId'="")&&(DocLocId'=docLocId)
	..s docLocDesc=$p($g(^CTLOC(+docLocId)),"^",2)
	..s admId=$p(^OEORD(mOrd),"^",1)
	..s patId=$p(^PAADM(admId),"^",1)
	..s patName=$p(^PAPER(patId,"ALL"),"^",1)
	..s patNo=$p(^PAPER(patId,"PAT",1),"^",1)
	..// 过滤条件-登记号
	..q:(PatNo'="")&&(PatNo'=patNo)
	..s auditUserId=$p(^DHCPHORDM(phaOrd),"^",1)
	..// 过滤条件-审核人
	..q:(AuditUser'="")&&(auditUserId'=AuditUser)
	..s auditUser=$p($g(^SSU("SSUSR",auditUserId)),"^",2)
	..// 过滤条件-药品
    ..i (IncId'="")&&(quitFlag="") d		
    ...i $d(CollOeAuditStatData("mOeoriIncExist",mOeori)) s incExist=$g(CollOeAuditStatData("mOeoriIncExist",mOeori))
    ...e  d
    ....s incExist=##class(web.DHCSTPIVAS.Common).CheckOeoriIncExist(mOeori,IncId)
    ....s CollOeAuditStatData("mOeoriIncExist",mOeori)=incExist
    ...i incExist'=1 s quitFlag=1
    ..q:quitFlag'=""
	../// 汇总数据
	..i queryType="RefusePassWard" d		// 不合理医嘱统计-按病区
	...s sortIndex=1,sortId=wardId,calcuGrpDesc=wardDesc
	...q:(sortId="")
	...d SetRefusePassData
	..e  i queryType="RefusePassDocLoc" d	// 不合理医嘱统计-按医生科室
	...s sortIndex=1,sortId=docLocId,calcuGrpDesc=docLocDesc
	...d SetRefusePassData
	..e  i queryType="RefusePassReason" d	// 不合理医嘱统计-按原因
	...s reasonStr=##class(web.DHCSTPIVAS.Common).GetOrdPassReason(phaOrd,$c(10,13))
	...q:reasonStr=""
	...f reasonI=1:1:$l(reasonStr,$c(10,13)) d
	....s reasonDesc=$p(reasonStr,$c(10,13),reasonI)
	....i reasonDesc["." s reasonDesc=$p(reasonDesc,".",2,*)
	....q:reasonDesc=""
	....s sortIndex=1,sortId=reasonDesc,calcuGrpDesc=reasonDesc
	....d SetRefusePassData
	..e  i queryType="RefusePassDetail" d	// 不合理医嘱统计-按明细
	...d SetRefuseDetailData
	..e  i queryType="InterveneWard" 	d	// 干预医嘱统计-按病区
	...s sortIndex=1,sortId=wardId,calcuGrpDesc=wardDesc
	...d SetInterveneWard
	q pid
 // 不合理医嘱,按病区\按科室\按原因
SetRefusePassData
	i '$d(^||TMP("DHCST",$ClassName(),queryType,pid,sortIndex,sortId)) d
	.s ^||TMP("DHCST",$ClassName(),queryType,pid,sortIndex,sortId)=calcuGrpDesc_"^"_1
	e  d
	.s $p(^||TMP("DHCST",$ClassName(),queryType,pid,sortIndex,sortId),"^",2)=1+$p(^||TMP("DHCST",$ClassName(),queryType,pid,sortIndex,sortId),"^",2)
	q
 // 不合理医嘱,按明细
SetRefuseDetailData
	s doctorDesc=""
	s freqDesc=$p(##class(web.DHCSTPIVAS.Common).OeoriFreq(mOeori),"^",2)
	s instruDesc=$p(##class(web.DHCSTPIVAS.Common).OeoriInstruc(mOeori),"^",2)
	s oeoriDate=$p(^OEORD(mOrd,"I",mOrdItm,1),"^",9)
	s oeoriDateHtml=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(oeoriDate)
	s reasonDesc=##class(web.DHCSTPIVAS.Common).GetOrdPassReason(phaOrd,$c(10,13))
	s oeori=mOeori
	s gycgFlag=""
	s prescNo=""
	d MakeRefuseDetailData
 	s ordItm=""
 	f  s ordItm=$O(^OEORDi(0,"OEORI",mOrd,mOeori,ordItm)) Q:(ordItm="")  d
 	.s oeori=mOrd_"||"_ordItm
 	.s arcItm=$p(^OEORD(mOrd,"I",ordItm,1),"^",2)
 	.s arcCat=$p($g(^ARCIM(+arcItm,+$p(arcItm,"||",2),1)),"^",10)
 	.q:$p($g(^ARC("IC",+arcCat)),"^",7)'="R" // 非药品
 	.d MakeRefuseDetailData
 	q
MakeRefuseDetailData  
	s incDesc=$p(##class(web.DHCSTPIVAS.Common).GetIncItmByOeori(oeori),"^",3)
	s dosage=##class(web.DHCSTPIVAS.Common).OeoriDosage(oeori) 
	s detailData1=wardDesc_"^"_docLocDesc_"^"_oeoriDateHtml_"^"_patNo_"^"_patName
	s detailData2=reasonDesc_"^"_auditUser_"^"_incDesc_"^"_freqDesc_"^"_instruDesc
	s detailData3=dosage_"^"_phaOrd_"^"_oeori
	s detailData=detailData1_"^"_detailData2_"^"_detailData3
	s sortIndex=wardDesc_"||"_docLocDesc_"||"_doctorDesc_"||"_oeoriDate_"^"_phaOrd
	s sortId=oeori
	s ^||TMP("DHCST",$ClassName(),queryType,pid,sortIndex,sortId)=detailData
	q
 // 干预医嘱统计-按病区
SetInterveneWard
	s gySucc="" // 是否干预成功
	i $p(^DHCPHORDM(phaOrd),"^",8)="Y" s gySucc=1
	s gySuccNum=0,shjjNum=0
	i phaOrdResult="SHJJ" s shjjNum=1	// 审核不合理数量
	i gySucc=1 s gySuccNum=1						// 干预成功数量
	s shNum=1										// 审核数量
	q:(sortId = "")||(sortIndex = "")
	i '$d(^||TMP("DHCST",$ClassName(),queryType,pid,sortIndex,sortId)) d
	.s ^||TMP("DHCST",$ClassName(),queryType,pid,sortIndex,sortId)=calcuGrpDesc_"^"_shNum_"^"_shjjNum_"^"_gySuccNum
	e  d
	.s $p(^||TMP("DHCST",$ClassName(),queryType,pid,sortIndex,sortId),"^",2)=shNum+$p(^||TMP("DHCST",$ClassName(),queryType,pid,sortIndex,sortId),"^",2)
	.s $p(^||TMP("DHCST",$ClassName(),queryType,pid,sortIndex,sortId),"^",3)=shjjNum+$p(^||TMP("DHCST",$ClassName(),queryType,pid,sortIndex,sortId),"^",3)
	.s $p(^||TMP("DHCST",$ClassName(),queryType,pid,sortIndex,sortId),"^",4)=gySuccNum+$p(^||TMP("DHCST",$ClassName(),queryType,pid,sortIndex,sortId),"^",4)
	q
}

/// deccription: 输出数据,此类统一格式
ClassMethod QueryOutput(repid, ind, pid, queryType)
{
	q:pid="" ""
	s sortIndex=""
	f  s sortIndex=$o(^||TMP("DHCST",$ClassName(),queryType,pid,sortIndex)) q:sortIndex=""  d
	.s sortId=""
	.f  s sortId=$o(^||TMP("DHCST",$ClassName(),queryType,pid,sortIndex,sortId)) q:sortId=""  d
	..s outputData=^||TMP("DHCST",$ClassName(),queryType,pid,sortIndex,sortId)
	..s Data=$lfs(outputData,"^")
	..s ^CacheTemp(repid,ind)=Data    
	..s ind=ind+1
	k ^||TMP("DHCST",$ClassName(),queryType,pid)
	q 0
}

/// w ##class(web.DHCSTPIVAS.Report.OeAuditStat).NewPid()
ClassMethod NewPid()
{
	q ##class(web.DHCSTKUTIL).NewPid($this,"PIVA")
}

}
