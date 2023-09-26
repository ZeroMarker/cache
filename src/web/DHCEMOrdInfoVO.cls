Import SQLUSER

Class web.DHCEMOrdInfoVO Extends (%RegisteredObject, %XML.Adaptor) [ Not ProcedureBlock ]
{

// 医嘱ID

Property oeoriId As %String;

// 打印标记

Property prtFlag As %String;

// 登记号

Property regNo As %String;

// 床位号

Property bedCode As %String;

// 病人姓名

Property patName As %String;

// 病人身份

Property patIdentity As %String;

// 年龄

Property age As %String;

// 医嘱大类

Property orcatDesc As %String;

// 序号

Property seqNo As %String;

// 医嘱名称

Property arcimDesc As %String;

// 优先级

Property oecprDesc As %String;

// 医嘱状态

Property ordStatDesc As %String;

// 标本号

Property labNo As %String;

// 剂量

Property doseQtyUnit As %String;

// 频率

Property phcfrCode As %String;

// 总量

Property phOrdQtyUnit As %String;

// 用药途径

Property phcinDesc As %String;

// 备注

Property notes As %String;

// 执行状态

Property execStat As %String;

// 执行时间

Property execDateTime As %String;

// 执行人

Property execCtcpDesc As %String;

// 医生

Property ctcpDesc As %String;

// 处置状态

Property disposeStatDesc As %String;

// 处置状态daima

Property disposeStatCode As %String;

// 接收科室

Property reclocDesc As %String;

// 开医嘱时间

Property createDateTime As %String;

// 要求执行时间

Property sttDateTime As %String;

// 停医嘱时间

Property xDateTime As %String;

// 停医嘱人

Property xCtcpDesc As %String;

// 处理停医嘱时间

Property execXDateTime As %String;

// 处理停医嘱人

Property execXUserDesc As %String;

// 处方号

Property prescNo As %String;

// 单价

Property price As %String;

// 总价

Property totalAmount As %String;

// 疗程

Property Durat As %String;

// 条码号

Property placerNo As %String;

// 皮试时间

Property skinTestDateTime As %String;

// 发药状态

Property DspStat As %String;

// 预停时间

Property PreDisDateTime As %String;

// 采血时间

Property specCollDateTime As %String;

// 标本名称

Property specDesc As %String;

// PDA执行次数

Property pdaNurExec As %String;

// 住院号

Property medCareNo As %String;

// 检查预约日期

Property reseDate As %String;

// 检查预约时间

Property reseTime As %String;

// 滴速

Property flowSpeed As %String;

// 就诊科室

Property admLoc As %String;

// 撤销原因

Property cancelReason As %String;

// 处理医嘱人

Property seeOrderUserName As %String;

// 处理时间

Property seeOrderUserDateTime As %String;

// 皮试批号

Property skinTestNumber As %String;

// 开医嘱科室

Property ordDep As %String;

// 加急标志

Property notifyClinician As %String;

// 皮试信息

Property skinTestInfo As %String;

// 管子代码

Property tubeColor As %String;

// 管颜色

Property tubeColorDesc As %String;

// 序号

Property no As %String;

// 病人密级

Property EncryptLevel As %String;

// 病人级别

Property PatLevel As %String;

// 1：是字医嘱 0 :不是

Property subOrder As %String;

// 医嘱执行id

Property oeoreId As %String;

// 主医嘱执行记录id

Property mainOeoreId As %String;

Property adm As %String;

Property skinTestFlag As %String;

Property placerCode As %String;

/// 获取发票
ClassMethod GetPrtId(oeoriId) As %String
{
 	//取医嘱的门诊发票指针 w ##Class(web.DHCCLCom).GetPrtId("71||1")
    s retPrtId=""
	q:oeoriId="" ""
	s oeordId=$p(oeoriId,"||",1)
	s oeoriSub=$p(oeoriId,"||",2)
	
	s sttDate=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",9) // + 0计费医嘱不取发票指针 wxl 090301
	s arcimId=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",2)    
	s oeoriPrice=$p($g(^OEORD(oeordId,"I",oeoriSub,3)),"^",25)
    s ordPrice=+##CLASS(UDHCJFPRICE).GetOrderPrice("","",arcimId,sttDate,"","","",oeoriPrice)
    q:ordPrice=0 0
	s pbId=0
	f  s pbId=$o(^DHCPBi(0,"OEORI",oeoriId,pbId)) q:pbId=""  d
	    .q:$p(^DHCPB(pbId),"^",16)'="P"
	    .s dhcbciId=$o(^DHCBCI(0,"Bill",pbId,""))
	    .q:dhcbciId=""
	    .s prtId=+^DHCBCI(dhcbciId)
	    .s prtFlag=$p(^DHCINVPRT(prtId),"^",8)  //Prt_Flag
	    .q:prtFlag'="N"
	    .;s $p(prtIdStr,"^",1+(prtFlag'="N"))=prtId
	    .s retPrtId=prtId
	;s papmiId=+^PAADM(+^OEORD(oeordId))
	q retPrtId
}

/// 医嘱优先级
ClassMethod GetOecprCode(oeoriId) As %String
{
	
	q:(oeoriId="") ""
	s oeordId=+oeoriId,oeoriSub=$p(oeoriId,"||",2)
   	q:oeoriSub="" ""

	s oecprId=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",8)
    q:oecprId="" ""
    s oecprCode=$p($g(^OECPR(oecprId)),"^")
	q:oecprCode="" ""
	q oecprCode
}

/// 取病人医嘱名称
/// w ##class(web.DHCEMOrdInfoVO).getArcimDesc()
ClassMethod getArcimDesc(ord As %String, itm As %String) As %String
{
	n (ord,itm,%session)
	s arcimDesc=""
	s arcimID =$p($g(^OEORD(ord,"I",itm,1)),"^",2)
	i arcimID'="" s arcimDesc= $P($G(^ARCIM(+arcimID,$p(arcimID,"||",2),1)),"^",2)
	s arcimDesc=##class(web.DHCEMCommonUtil).GetTransDesc("User.ARCItmMast","ARCIMDesc","",arcimDesc) //hxy 2022-12-16
	e  q ""
	s oecprCode=##Class(web.DHCEMOrdInfoVO).GetOecprCode(ord_"||"_itm)
    s skintest=$p($g(^OEORD(ord,"I",itm,5)),"^",2)
    s abnorm=$p($g(^OEORD(ord,"I",itm,11)),"^",3)
    s actId=$p($g(^OEORD(ord,"I",itm,11)),"^",21)
    s actCode="",actDesc=""
    i actId'="" s actCode=$p(^OEC("ACT",actId),"^",1),actDesc=$p(^OEC("ACT",actId),"^",2)
    i actDesc'="" s arcimDesc=arcimDesc_"("_##class(web.DHCEMCommonUtil).GetTrans("dhcem.showordnum.csp","皮试")_":"_actDesc_")" //hxy 2022-12-13
    s PriorityDesc=""
    s PriorityDr = $p($g(^OEORD(ord,"I",itm,1)),"^",8)
    s:+PriorityDr'=0 PriorityDesc = $p(^OECPR(PriorityDr),"^",2) 
    i PriorityDesc["自备药" s arcimDesc=arcimDesc_"("_##class(web.DHCEMCommonUtil).GetTrans("dhcem.showordnum.csp","自备药")_")" //"(自备药)" //hxy 2022-12-13
    i PriorityDesc["嘱托" s arcimDesc=arcimDesc_"("_##class(web.DHCEMCommonUtil).GetTrans("dhcem.showordnum.csp","嘱托")_")" //"(嘱托)" //hxy 2022-12-13
	q arcimDesc
}

/// 取病人医嘱名称/按分组
/// w ##class(web.DHCEMOrdInfoVO).getGrpArcimDesc(29,45,1)
ClassMethod getGrpArcimDesc(ord As %String, itm As %String, arcimDesc As %String) As %String
{
	n (ord,itm,arcimDesc)
	  
	s ret=+$o(^OEORDi(0,"OEORI",ord,ord_"||"_itm,"")) 
	Q:ret=0 arcimDesc

	s child=""
	f  s child=$o(^OEORDi(0,"OEORI",ord,ord_"||"_itm,child)) q:child=""  d
	.s skinResultUser=##class(web.DHCEMOrdInfoVO).GetSkinResultUser(ord_"||"_child)
	.s arcimDesc=arcimDesc_"<br>"_##class(web.DHCEMOrdInfoVO).getArcimDesc(ord,child)_skinResultUser
	
	q arcimDesc
}

/// 获取病人密级
/// W ##class(web.DHCEMOrdInfoVO).GetPatEncryptLevel()
ClassMethod GetPatEncryptLevel(ord, itm)
{
	s EpisodeID=$p(^OEORD(ord),"^",1)
	q ##class(web.DHCCLCom).GetPatEncryptLevel("",EpisodeID)
}

/// 取医嘱医生
ClassMethod getCtcpDesc(oeordId, oeoriSub)
{
	
	n (oeordId,oeoriSub,%session)
  	s user=$p($g(^OEORD(oeordId,"I",oeoriSub,7)),"^",1)
    q:user="" ""
    s ctcpId=$p(^SSU("SSUSR",user),"^",14)
    q:ctcpId="" ""
    q ##class(web.DHCEMCommonUtil).GetTransDesc("User.CTCareProv","CTPCPDesc","",$p($g(^CTPCP(ctcpId,1)),"^",2))
}

/// 取病人姓名
/// w ##class(web.DHCEMOrdInfoVO).getPatName()
ClassMethod getPatName(ord As %String, itm As %String) As %String
{
	n (ord,itm)
	 s episodeID =$p($g(^OEORD(ord)),"^",1)
	 s papmiId=+^PAADM(episodeID)
	 q $p($g(^PAPER(papmiId,"ALL")),"^",1)
}

/// 取病人年龄
/// w ##class(web.DHCEMOrdInfoVO).getPatAge()
ClassMethod getPatAge(ord As %String) As %String
{
	n (ord,%session)
	 s episodeID =$p($g(^OEORD(ord)),"^",1)
	 s papmiId=+^PAADM(episodeID)
	 q ##class(web.DHCEMCommonUtil).GetPapmiAgeByAdmID(episodeID)
	 s birth=$p($g(^PAPER(papmiId,"ALL")),"^",6)
	 s age=##class(web.DHCMGNurComm).CalAge(birth,+$h)
	 if $p(age,"Y",1)'=0  
     {
	    set age=$p(age,"Y",1)_"岁"
     }
     else
     {
	    if $p($p(age," ",2),"M",1)'=0
	    {
		    set age=$p($p(age," ",2),"M",1)_"个月"
	    }
	    else
	    {
		    set age=$p($p(age," ",3),"D",1)_"天"
	    }
     }
     q age
}

/// 取病人床号
/// w ##class(web.DHCEMOrdInfoVO).getPaBedCode()
ClassMethod getPaBedCode(ord As %String) As %String
{
	n (ord)
	s episodeID =$p($g(^OEORD(ord)),"^",1)
	s bedSub=$p($p($g(^PAADM(episodeID)),"^",73),"||",2)
    s curWardId=$p($g(^PAADM(episodeID)),"^",70)
    i (bedSub'="")&(curWardId'="") q $p($g(^PAWARD(curWardId,"BED",bedSub)),"^",1)
    e  q ""
}

/// 取病人就诊科室
/// w ##class(web.DHCEMOrdInfoVO).getAdmLoc()
ClassMethod getAdmLoc(ord As %String) As %String
{
	n (ord)
	 s episodeID =$p($g(^OEORD(ord)),"^",1)
	 s ctlocId=$p(^PAADM(episodeID),"^",4)
	  i ctlocId'="" q $p(^CTLOC(+ctlocId),"^",2)	
	e  q ""
}

/// 取病人登记号
/// w ##class(web.DHCEMOrdInfoVO).getPatRegNo()
ClassMethod getPatRegNo(ord As %String) As %String
{
	n (ord)
	 s episodeID =$p($g(^OEORD(ord)),"^",1)
	 s papmiId=+^PAADM(episodeID)
	 s regNo=$p($g(^PAPER(papmiId,"PAT",1)),"^",1)
	 q regNo_" "
}

/// 取病人住院号
/// w ##class(web.DHCEMOrdInfoVO).getMedCareNo()
ClassMethod getMedCareNo(ord As %String) As %String
{
	 n (ord)
	 s episodeID =$p($g(^OEORD(ord)),"^",1)
	 q ##Class(web.DHCEMCommonUtil).GetMrNo(episodeID) /// 病案号
}

/// 取处理医嘱人
/// w ##class(web.DHCEMOrdInfoVO).getSeeOrderUserName()
ClassMethod getSeeOrderUserName(ord As %String, itm As %String) As %String
{
	n (ord,itm)
	s seeOrderUserdr=$p($g(^OEORD(ord,"I",itm,"NUR")),"^",4)
	q:seeOrderUserdr="" ""
	s seeOrderUser=$p($g(^SSU("SSUSR",seeOrderUserdr)),"^",2)
	q seeOrderUser
}

/// 取处理医嘱时间
/// w ##class(web.DHCEMOrdInfoVO).getSeeOrderUserDateTime()
ClassMethod getSeeOrderUserDateTime(ord As %String, itm As %String) As %String
{
	n (ord,itm)
	s seeOrderDate=$p($g(^OEORD(ord,"I",itm,"NUR")),"^",5)
	s seeOrderTime=$p($g(^OEORD(ord,"I",itm,"NUR")),"^",6)
	i (seeOrderDate'="")&(seeOrderTime'="") q ##class(web.DHCEMCommonUtil).DateLogicalToHtml(seeOrderDate)_" "_$zt(seeOrderTime)
	e  q ""
}

/// 取处理医嘱时间
/// w ##class(web.DHCEMOrdInfoVO).getOrdDep()
ClassMethod getOrdDep(ord As %String, itm As %String) As %String
{
	n (ord,itm)
	q:'$d(^OEORD(ord,"I",itm,7)) ""
	s ordDep=$p(^OEORD(ord,"I",itm,7),"^",2)
	  
	i ordDep'=""  q $p(^CTLOC(ordDep),"^",1)
	e  q ""
}

/// 获取医嘱的剂量
/// w ##class(web.DHCEMOrdInfoVO).GetdoseQtyUnit()
ClassMethod GetdoseQtyUnit(ord, itm, sub)
{
	n (ord,itm ,sub,%session)
	s doseQty=$p($g(^OEORD(ord,"I",itm,"X",sub)),"^",4)
	s:doseQty="" doseQty=$p($g(^OEORD(ord,"I",itm,2)),"^",1)
	s unitUomId="",unitDesc=""
    i doseQty'="" s unitUomId=$p($g(^OEORD(ord,"I",itm,2)),"^",3)
    ;s doseQty=##class(web.DHCEMCommonUtil).GetOrdDoseQty(ord_"||"_itm)
    i $g(unitUomId)'="" s unitDesc=$p($g(^CT("UOM",unitUomId)),"^",2)
    s unitDesc=##class(web.DHCEMCommonUtil).GetTransDesc("User.CTUOM","CTUOMDesc","",unitDesc)
    i (doseQty'="")&($p(doseQty,".")="") s doseQty="0"_doseQty
    i (doseQty'="")&($g(unitDesc)'="") s doseQtyUnit=doseQty_" "_unitDesc
    e  s doseQtyUnit=""
    q doseQtyUnit
}

/// 取病人身份
/// w ##class(web.DHCEMOrdInfoVO).getPatIdentity()
ClassMethod getPatIdentity(ord As %String) As %String
{
	n (ord,%session)
	s EpisodeID =$p($g(^OEORD(ord)),"^",1)
	s admreasondr=$p($g(^PAADM(EpisodeID,1)),"^",7)
    i admreasondr'="" q ##class(web.DHCEMCommonUtil).GetTransDesc("User.PACAdmReason","READesc","",$P($g(^PAC("ADMREA",admreasondr)),"^",2))
    e  q ""
}

/// 取医嘱大类
/// w ##class(web.DHCEMOrdInfoVO).getOrcatDesc()
ClassMethod getOrcatDesc(ord As %String, itm As %String) As %String
{
	n (ord,itm,%session)
	s arcimId=$p($g(^OEORD(ord,"I",itm,1)),"^",2) 
	s arcicId =$P($G(^ARCIM(+arcimId,$P(arcimId,"||",2),1)),"^",10) 
	i arcicId'=""  	s orcatId=$p($g(^ARC("IC",arcicId)),"^",8)
	i $g(orcatId)'=""  q ##class(web.DHCEMCommonUtil).GetTransDesc("User.OECOrderCategory","ORCATDesc","",$p($g(^OEC("ORCAT",orcatId)),"^",2))
	e  q ""
}

/// 取医嘱优先级
ClassMethod getOecprDesc(ord As %String, itm As %String) As %String
{
	n (ord,itm,%session)
	s oecprId=$p($g(^OEORD(ord,"I",itm,1)),"^",8)
	q ##class(web.DHCEMCommonUtil).GetTransDesc("User.OECPriority","OECPRDesc","",$p(^OECPR(oecprId),"^",2))
}

/// 取频次
/// w ##class(web.DHCEMOrdInfoVO).getPhcfrCode(233,12)
ClassMethod getPhcfrCode(ord As %String, itm As %String) As %String
{
	n (ord,itm)
	
	s OrdFreqInfo=##class(DHCDoc.Interface.Inside.ServiceOrd).GetOrdFreqInfo(ord_"||"_itm,"^")
	s PHFreq=$List(OrdFreqInfo,2)
	s PHFreq=$REPLACE(PHFreq,"^","-")
	q PHFreq
	
	s OrderFreq=""
	s freqDr=$P($G(^OEORD(ord,"I",itm,2)),"^",4) 
	i freqDr'="" d
	. s OrderFreq=$P(^PHCFR(freqDr),"^",1)
	. s WeekFlag=$P(^PHCFR(freqDr),"^",9)
	. i WeekFlag="Y" d
	..s OrderFreqWeek=$p($g(^OEORD(+ord,"I",itm,"DHC")),"^",55)
	..s:OrderFreqWeek="undefined" OrderFreqWeek=""
	..s OrderFreq=OrderFreq_" "_$TR(OrderFreqWeek,"|","")

    
    q OrderFreq
}

/// 取总量
/// w ##class(web.DHCEMOrdInfoVO).getPhOrdQtyUnit() 
ClassMethod getPhOrdQtyUnit(ord As %String, itm As %String) As %String
{
	n (ord,itm,%session)
	/// 总量取值调用医生站公共方法 bianshuai 2021-02-04
	s rets=##Class(web.DHCDocQryOEOrder).GetOrdPackQtyInfo(ord_"||"_itm)
	s qty=$p(rets,"^")
	s qtyUnit=$p(rets,"^",2)
	s ret=""
	s:+qtyUnit'=0 ret=qty_"("_qtyUnit_")"
	s:+qtyUnit=0 ret=qty_qtyUnit
	q ret
	
#;	s packUomQty=$p($g(^OEORD(ord,"I",itm,9)),"^",4)
#;	s ArcimId=$p($g(^OEORD(ord,"I",itm,1)),"^",2)
#;	q:ArcimId="" ""
#;
#;	
#;	s PackUOMDesc=""
#;	s BillingUOMDR=$p(^ARCIM(+ArcimId,$p(ArcimId,"||",2),8),"^",14)
#;	if BillingUOMDR'="" s PackUOMDesc=$p(^CT("UOM",BillingUOMDR),"^",2)
#;	;协议单位
#;	s ProtocolPackUOMDR=$p($g(^OEORD(ord,"I",itm,"DHC")),"^",13)
#;	i ProtocolPackUOMDR'="" {
#;		s PackUOMDesc=$p($g(^CT("UOM",ProtocolPackUOMDR)),"^",2)
#;	}
#;	s CheckCHNFlag=##class(web.DHCSTINTERFACE).GetStruModeFlag(ArcimId)
#;	if (CheckCHNFlag="Y") {
#;		S Phcdf=$P($g(^ARCIM(+ArcimId,$P(ArcimId,"||",2),1)),"^",12)
#;		if (Phcdf'=""){
#;			s BillingUOMDR=$p(^PHCD(+Phcdf,"DF",$p(Phcdf,"||",2),2),"^",4)
#;			s PackUOMDesc=$p($g(^CT("UOM",BillingUOMDR)),"^",2)
#;		}
#;	}
#;	
#;	s doseQty=$p($g(^OEORD(ord,"I",itm,2)),"^",1)
#;    i doseQty'="" s unitUomId=$p($g(^OEORD(ord,"I",itm,2)),"^",3)
#;    i $g(unitUomId)'="" s unitDesc=$p($g(^CT("UOM",unitUomId)),"^",2)
#;    b ;2
#;    s phOrdQty=$p($g(^OEORD(ord,"I",itm,1)),"^",12)
#;    i (phOrdQty'="")&(phOrdQty<1) s phOrdQty="0"_phOrdQty
#;    i (phOrdQty'="") s phOrdQtyUnit=phOrdQty_" "_$G(unitDesc)
#;    
#;	s:($g(PackUOMDesc)="")&&($g(unitUomId)'="") PackUOMDesc=$p($g(^CT("UOM",unitUomId)),"^",2)
#;	
#;    i packUomQty'=""  s phOrdQtyUnit=$G(packUomQty)_" "_$G(PackUOMDesc)
#;    s:$p(phOrdQtyUnit,".",1)="" phOrdQtyUnit="0"_phOrdQtyUnit
#;    
#;   	q $g(phOrdQtyUnit)
}

/// 取用法
/// w ##class(web.DHCEMOrdInfoVO).getPhcinDesc()
ClassMethod getPhcinDesc(ord As %String, itm As %String) As %String
{
	n (ord,itm,%session)
	s methDr=$P($G(^OEORD(ord,"I",itm,2)),"^",7)
    i methDr'="" q ##class(web.DHCEMCommonUtil).GetTransDesc("User.PHCInstruc","PHCINDesc1","",$p(^PHCIN(methDr),"^",2))
    e  q ""
}

/// 取疗程 
ClassMethod getDurat(oeordId As %String, oeoriSub As %String) As %String
{
	n (oeordId,oeoriSub)
	i $d(^OEORD(oeordId,"I",oeoriSub,2)) s duratdr=$p(^OEORD(oeordId,"I",oeoriSub,2),"^",6)
    i $g(duratdr)'="" q ##class(web.DHCEMCommonUtil).GetTransDesc("User.PHCDuration","PHCDUDesc1","",$p(^PHCDU(duratdr),"^",3))
    e  q ""
}

/// 备注
ClassMethod getNote(ord, itm) As %String
{
	n (ord,itm)
	s notes=""
	f rnum=1:1:$G(^OEORD(ord,"I",itm,"DEP",0))  d
	.s notes=notes_$G(^OEORD(ord,"I",itm,"DEP",rnum))
	s:$d(^OEORD(ord,"I",itm,2)) notes=notes_""_$p(^OEORD(ord,"I",itm,2),"^",8)
	q $G(notes)
}

/// 取处理停医嘱时间
ClassMethod getExecXDateTime(oeordId As %String, oeoriSub As %String) As %String
{
	n (oeordId,oeoriSub)
  	s DisconDate=$p($g(^OEORD(oeordId,"I",oeoriSub,"NUR")),"^",2)
	s DisconTime=$p($g(^OEORD(oeordId,"I",oeoriSub,"NUR")),"^",3)
	i (DisconDate="")!(DisconTime="") q ""
	e  q ##class(web.DHCEMCommonUtil).DateLogicalToHtml(DisconDate)_" "_$zt(DisconTime)
}

/// 取处理停医嘱人
ClassMethod getExecXUserDesc(oeordId As %String, oeoriSub As %String) As %String
{
	n (oeordId,oeoriSub,%session)
	s xOrderNurseDR=$p($g(^OEORD(oeordId,"I",oeoriSub,"NUR")),"^",1)
   	i xOrderNurseDR'="" q ##class(web.DHCEMCommonUtil).GetTransDesc("User.SSUser","SSUSRName","",$p($g(^SSU("SSUSR",xOrderNurseDR)),"^",2))
   	e  q ""
}

/// 取单价
ClassMethod getPrice(oeordId As %String, oeoriSub As %String, hop As %String) As %String
{
	n (oeordId,oeoriSub,hop)
	s price=0
	s oeoriDr = oeordId_"||"_oeoriSub
	s AdmId=$p(^OEORD(oeordId),"^",1)
	s EpissubtypeId=$P($g(^PAADM(AdmId,1)),"^",6)
	s AdmReasonId=$P($g(^PAADM(AdmId,1)),"^",7)
	s PAADMRegConDisDR=$P($G(^PAADM(AdmId,"DHC")),"^",25)
	
	s reclocId=$p($g(^OEORD(oeordId,"I",oeoriSub,3)),"^",6)
	
	s ExtStr=PAADMRegConDisDR_"^"_oeordId_"||"_oeoriSub_"^"_""_"^"_AdmId_"^"_reclocId
	
	s arcimId=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",2)
	s sttDate=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",9)
	s oeoriPrice=$p($g(^OEORD(oeordId,"I",oeoriSub,3)),"^",25)
	
	i reclocId'="" s hop=$p($g(^CTLOC(reclocId)),"^",22)
	s arciType=##class(web.DHCEMPatThisOrd).GetOrderTypeByOeoriId(oeoriDr)
	s:arciType["检查" price = +##Class(web.DHCAPPInterface).GetExaReqPartCost(oeoriDr,"","")
	s:(+price=0)&(arciType["检查") price=+##CLASS(web.UDHCJFPRICE).GetOrderPrice(EpissubtypeId,AdmReasonId,arcimId,sttDate,"","","",oeoriPrice,hop,"")
    s:arciType'["检查" price=+##CLASS(web.UDHCJFPRICE).GetOrderPrice(EpissubtypeId,AdmReasonId,arcimId,+$h,"","","","","",ExtStr)
    
    s price=$fn(price,"",4)
    q price
}

/// 取总价 
ClassMethod getTotalAmount(oeordId As %String, oeoriSub As %String, hosp As %String) As %String
{
	n (oeordId,oeoriSub,hosp)
    s orderBaseQty=..GetOrderBaseQty(oeordId_"||"_oeoriSub)
	s retQty=..GetOrderRetBaseQty(oeordId_"||"_oeoriSub)
    s orderBaseQty=orderBaseQty-retQty
	
    s price =..getPrice(oeordId,oeoriSub,hosp)
	s ordStatusId=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",13)  
    q:($p($g(^OEC("OSTAT",ordStatusId)),"^",1)'="V")&&($p($g(^OEC("OSTAT",ordStatusId)),"^",1)'="E") 0
    q $fn(orderBaseQty*price,"",2)
}

/// w ##class(web.DHCEMOrdInfoVO).getTotalAmountNew(2399,100)
ClassMethod getTotalAmountNew(Ord, Itm)
{
	n (Ord,Itm)
	s OEItemID = Ord_"||"_Itm
	s PriorityDR = $p($g(^OEORD(Ord,"I",Itm,1)),"^",8)
	s ISLongOrderPrior=##class(appcom.OEOrdItem).ISLongOrderPrior(PriorityDR)
	s BillingUOMDR=##Class(web.DHCDocOrderCommon).GetOrdPackUOMDR(OEItemID)
	s ArcPrice=##class(web.DHCDocOrderCommon).GetOEORIPrice(OEItemID)
	s ArcPrice=$fn($p(ArcPrice,"^",1),"",4)
	s ArcimId=$p($g(^OEORD(Ord,"I",Itm,1)),"^",2)
	
	s ProtocolPackUOMDR=$p($g(^OEORD(Ord,"I",Itm,"DHC")),"^",13)
	i ProtocolPackUOMDR'="" {
		s BillingUOMDR=ProtocolPackUOMDR
	}
	s OrderSum=""
	//计价单位与基本单位的换算
	s ConvFac=##class(appcom.OEDispensing).convFac(ArcimId,BillingUOMDR)
	s OrdPackQtyInfo=##class(web.DHCDocQryOEOrder).GetOrdPackQtyInfo(OEItemID)
	s ActiveQty=$p(OrdPackQtyInfo,"^",4)
	if (ISLongOrderPrior=1){
		s OrderSum=""
	}elseif (+ActiveQty=0){
		s BaseQty=$p(OrdPackQtyInfo,"^",4) //换算成基本单位后的数量
		s OrderSum=(BaseQty/ConvFac)*ArcPrice
		s OrderSum=$j(OrderSum,"",2)
	}else{
		s OrderSum=(ActiveQty/ConvFac)*ArcPrice
		s OrderSum=$j(OrderSum,"",2)
	}	
	q OrderSum
}

/// w ##class(web.DHCEMOrdInfoVO).GetOrderRetBaseQty("1091||19")
ClassMethod GetOrderRetBaseQty(oeoriId) As %String
{
	s dsp="",retQty=0
	f  s dsp=$o(^DHCOEDISQTY(0,"OEORI",oeoriId,dsp)) q:dsp=""  d
	.s status=$p(^DHCOEDISQTY(dsp),"^",7)
	.q:status'="R"
	.s retQty=retQty+$p(^DHCOEDISQTY(dsp),"^",5)
	q retQty
}

/// 取标本名称 
ClassMethod getSpecDesc(oeordId As %String, oeoriSub As %String) As %String
{
	n (oeordId,oeoriSub,%session)
	 s arcimId=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",2) 
	s arcicId =$P($G(^ARCIM(+arcimId,$P(arcimId,"||",2),1)),"^",10) 
   //标本号    标本名称
    s labNo=$p($g(^OEORD(oeordId,"I",oeoriSub,3)),"^",20)
    s specDesc=""
    s specCode=$p($g(^OEORD(oeordId,"I",oeoriSub,"SPEC",1)),"^")
    i specCode'="" s specDesc=$p(##Class(DHCLIS.DHCCommon).GetSpecimen(specCode,""),$c(2),2)
    q specDesc
}

/// 取标本名称 
/// w ##class(web.DHCEMOrdInfoVO).getSpecDescName(102)
ClassMethod getSpecDescName(blLabNo) As %String
{
	n (blLabNo)
	s specDesc=""
	s specDesc=##class(web.DHCPisApplicationSheet).GetSpecimensinfo(blLabNo)
    s specName=""
    s len = $l(specDesc,";")
    for i=1:1:len d
    .s:specName'="" specName=specName_"与"_$p($p(specDesc,";",i),"^",2)
    .s:specName="" specName=$p($p(specDesc,";",i),"^",2)
    q specName
}

/// 取采血时间 
ClassMethod getSpecCollDateTime(oeordId As %String, oeoriSub As %String, oeoreSub As %String = 1) As %String
{
	n (oeordId,oeoriSub,oeoreSub)
    s specCollDate=$p($g(^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub,"NUR")),"^",11)
    s specCollTime=$p($g(^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub,"NUR")),"^",12)
    i (specCollDate'="")&(specCollTime'="") q ##class(web.DHCEMCommonUtil).DateLogicalToHtml(specCollDate)_" "_$zt(specCollTime)
    e  q ""
}

/// 取滴速
ClassMethod getFlowSpeed(oeordId As %String, oeoriSub As %String) As %String
{
	n (oeordId,oeoriSub)
	S flowSpeedRate=$P($G(^OEORD(oeordId,"I",oeoriSub,3)),"^",17)
	s flowSpeedUnitDr=$P($G(^OEORD(oeordId,"I",oeoriSub,6)),"^",8)
	i flowSpeedUnitDr'="" s flowSpeedUnit=$p($g(^OEC("SFR",flowSpeedUnitDr)),"^",2)
	i flowSpeedRate'="",flowSpeedUnitDr'="" q $g(flowSpeedRate)_" "_$g(flowSpeedUnit)
	e  q ""
}

/// 取接受科室
ClassMethod getReclocDesc(oeordId As %String, oeoriSub As %String) As %String
{
	n (oeordId,oeoriSub)
	s reclocDr=$p($g(^OEORD(oeordId,"I",oeoriSub,3)),"^",6)
	i reclocDr'="" q $p($g(^CTLOC(reclocDr)),"^",1)
	e  q ""
}

ClassMethod GetDispensingStat(oeoreId, omitOM = "Y")
{
    n (oeoreId,omitOM,%session)
    q:oeoreId="" ""
    s TraY=##class(web.DHCEMCommonUtil).GetTrans("dhcem.nur.exec.hisui.csp","已发")
    s TraN=##class(web.DHCEMCommonUtil).GetTrans("dhcem.nur.exec.hisui.csp","未发")
    s TraPart=##class(web.DHCEMCommonUtil).GetTrans("dhcem.nur.exec.hisui.csp","部分发")
    s TraAll=##class(web.DHCEMCommonUtil).GetTrans("dhcem.nur.exec.hisui.csp","全退")
    s TraPartBa=##class(web.DHCEMCommonUtil).GetTrans("dhcem.nur.exec.hisui.csp","部分退")
    
    s oeordId=+oeoreId,oeoriSub=$p(oeoreId,"||",2),oeoreSub=$p(oeoreId,"||",3)
    s ordType=""
    s ordType = ##class(web.DHCEMInComUseMethod).GetOECCatByOEORDItmDr(oeordId_"||"_oeoriSub)
    q:ordType["材料" ""
    q:oeoreSub="" ""
    s oecprId=$p(^OEORD(oeordId,"I",oeoriSub,1),"^",8)
    q:oecprId="" ""
    s oecprCode=$p($g(^OECPR(oecprId)),"^",1)
    q:(omitOM="Y")&((oecprCode="OMST")!(oecprCode="OM")) TraY  //"C" //自备药视为已发         //WKZ071019 S
    q:(omitOM'="Y")&((oecprCode="OMST")!(oecprCode="OM")) TraN   //"TC" //自备药视为未发
	s admId=$p(^OEORD(oeordId),"^",1)
	s admType=$p(^PAADM(admId),"^",2)
	s DSPRowId=""
	i admType="I" d
    . s DSPRowId=$O(^DHCOEDISQTY(0,"OEORE",oeordId_"||"_oeoriSub_"||"_oeoreSub,DSPRowId),-1)
    e  d
    .s DSPRowId=$O(^DHCOEDISQTY(0,"OEORI",oeordId_"||"_oeoriSub,DSPRowId),-1)
    q:DSPRowId="" ""
    s dspStat=$P($G(^DHCOEDISQTY(DSPRowId)),"^",7)
    s dspQty=$p(^DHCOEDISQTY(DSPRowId),"^",5) 
	i dspStat="R" {
		; q:'+dspQty "退药"
		; q:+dspQty "部分退"
		// 2022-07-26 cy 调用药房接口 ""-数据有误，TC-未发，C-全发，PC-部分发，R-全退，PR-部分退
		s StatCode=##class(PHA.FACE.OUT.Com).GetDispensingStat(oeordId_"||"_oeoriSub)
		q:StatCode="R" TraAll
		q:StatCode="PR" TraPartBa

	}
  	i dspStat="TC" q TraN
    i dspStat="C" q TraY
    i dspStat="PC" q TraPart
}

ClassMethod GetOrdStatCode(oeoreId) As %String
{
	n (oeoreId)
	q:oeoreId="" ""
	s oeordId=+oeoreId,oeoriSub=$p(oeoreId,"||",2),oeoreSub=$p(oeoreId,"||",3)
	i oeoreSub="" d
	.s xDate=$p($g(^OEORD(oeordId,"I",oeoriSub,3)),"^",34)
	.s xTime=$p($g(^OEORD(oeordId,"I",oeoriSub,2)),"^",15)
	.s ordStatId=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",13)
	e  d
	.s xDate=$p($g(^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub)),"^",12)
	.s xTime=$p($g(^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub)),"^",14)
	.s ordStatId=$p($g(^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub,"BILL")),"^",1)

	s ordStatCode=$p($g(^OEC("OSTAT",+ordStatId)),"^",1)
	q ordStatCode
}

/// 医嘱执行状态code
ClassMethod getExecStatCode(ord, itm, sub) As %String
{
	n (ord,itm,sub)
	q:+ord=0 ""
	q:+itm=0 ""
	q:+sub=0 ""
	s execStatusId=$p($g(^OEORD(ord,"I",itm,"X",sub)),"^",16) //执行状态
	q:execStatusId="" ""
    q $p($g(^OEC("STAT",execStatusId)),"^",1)
}

/// 医嘱执行状态
ClassMethod getExecStat(ord, itm, sub) As %String
{
	n (ord,itm,sub)
	q:ord="" ""
	q:itm="" ""
	q:sub="" ""
	s execStatusId=$p($g(^OEORD(ord,"I",itm,"X",sub)),"^",16) //执行状态
	q:execStatusId="" ""
    q $p($g(^OEC("STAT",execStatusId)),"^",2)
}

/// 医嘱状态
ClassMethod getOrdStatDesc(ord, itm) As %String
{
	n (ord,itm,%session)
	q:ord="" ""
	q:itm="" ""
   	s ordStatusId=$p($g(^OEORD(ord,"I",itm,1)),"^",13)  
    q ##class(web.DHCEMCommonUtil).GetTransDesc("User.OECOrderStatus","OSTATDesc","",$p($g(^OEC("OSTAT",ordStatusId)),"^",2))
}

ClassMethod GetOrdSubCatType(oeoriId) As %String
{
 	n (oeoriId)
	q:oeoriId="" ""
	s oeordId=+oeoriId
    s oeoriSub=$p(oeoriId,"||",2)
	q:'$d(^OEORD(oeordId,"I",oeoriSub,1)) ""
 	s arcimId=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",2)
 	q:arcimId="" ""
 	s arcimVersion=$p(arcimId,"||",2)
 	q:'$d(^ARCIM(+arcimId,arcimVersion,1)) ""
 	s arcicId=$p(^ARCIM(+arcimId,arcimVersion,1),"^",10)
 	q:arcicId="" ""
 	q:'$d(^ARC("IC",arcicId)) ""
 	s arcicOrderType=$p(^ARC("IC",arcicId),"^",7)
	q arcicOrderType
}

/// 取管子代码
/// w ##class(Nur.OrderStaticInfo).getTubeColor()
ClassMethod getTubeColor(oeordId As %String, oeoriSub As %String) As %String
{
	n (oeordId,oeoriSub)
	s placerCode=""
	s tubeColor=""
	s placerStr=##Class(web.DHCNurCom).GetSpecContainerCode(oeordId_"||"_oeoriSub)
    q $p(placerStr,"^",5)
#;    i $p(placerStr,"^",1)'="" s placerCode=$p(placerStr,"^",1)
#;    i placerCode'="" d
#;    .i placerCode="A" s tubeColor="Purple"
#;	.i placerCode="C" s tubeColor="Gray"
#;	.i placerCode="R" s tubeColor="Red"
#;	.i placerCode="P" s tubeColor="Fuchsia"
#;	.i placerCode="Y" s tubeColor="Yellow"
#;	.i placerCode="G" s tubeColor="Green"
#;	.i placerCode="H" s tubeColor="Black"
#;	.i placerCode="B" s tubeColor="deepskyblue;"
#;	.i placerCode="W" s tubeColor="White"
#;	.i placerCode="O" s tubeColor="Brown"
#;	.i placerCode="Q" s tubeColor="Orange"
#;    q tubeColor
}

/// 取管颜色
/// w ##class(Nur.OrderStaticInfo).getTubeColorDesc()
ClassMethod getTubeColorDesc(oeordId As %String, oeoriSub As %String) As %String
{
	n (oeordId,oeoriSub)
	s placerCode=""
	s TubeColorDesc=""
	s placerStr=##Class(web.DHCNurCom).GetSpecContainerCode(oeordId_"||"_oeoriSub)
    i $p(placerStr,"^",1)'="" s placerCode=$p(placerStr,"^",1)
    i placerCode'="" d
    .i placerCode="A" s TubeColorDesc="紫管"
	.i placerCode="C" s TubeColorDesc="灰管"
	.i placerCode="R" s TubeColorDesc="红管"
	.i placerCode="P" s TubeColorDesc="粉管"
	.i placerCode="Y" s TubeColorDesc="黄管"
	.i placerCode="G" s TubeColorDesc="绿管"
	.i placerCode="H" s TubeColorDesc="黑管"
	.i placerCode="B" s TubeColorDesc="蓝管"
	.i placerCode="W" s TubeColorDesc="白管"
	.i placerCode="O" s TubeColorDesc="褐管"
	.i placerCode="Q" s TubeColorDesc="橙管"
    q TubeColorDesc
}

// 查找检验瓶号

ClassMethod GetPlacerNo(oeordId, oeoriSub) As %String
{
	n (oeordId,oeoriSub)
	q $p($g(^OEORD(oeordId,"I",oeoriSub,3)),"^",36)
}

ClassMethod CanExecSkinTestOrd(oeoriId)
{
	q:(oeoriId="") ""
	s oeordId=+oeoriId,oeoriSub=$p(oeoriId,"||",2)
   	q:oeoriSub="" ""

    s resStr=0
    s curOriSub="" f  s curOriSub=$o(^OEORDi(0,"OEORI",oeordId,oeoriId,curOriSub)) q:(curOriSub="")  d
		.s skinTestFlag=$p($g(^OEORD(oeordId,"I",curOriSub,5)),"^",2)
		.s abnorm=$p($g(^OEORD(oeordId,"I",curOriSub,11)),"^",3)
		.i (skinTestFlag="Y")&(abnorm="Y") s resStr="皮试阳性!"
		.i (skinTestFlag="Y")&(abnorm="") s resStr="请先置皮试结果!"
	q resStr
}

ClassMethod GetOrderBaseQty(oeoriId) As %String
{
	

	//取医嘱计价数量
	q:oeoriId="" 0
	s oeordId=$p(oeoriId,"||",1),oeoriSub=$p(oeoriId,"||",2)
    s arcimId=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",2)
    q:arcimId="" 0
    
	s phOrdQty=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",12)
	s dispensingID = ""
	f  s dispensingID=$o(^DHCOEDISQTY(0,"OEORI",oeoriId,dispensingID)) q:dispensingID=""  d
	.s phOrdQty = $p($G(^DHCOEDISQTY(dispensingID)),"^",5)
	s arcicOrderType=..GetOrdSubCatType(oeoriId)
	//b ;-1
	q:arcicOrderType'="R" phOrdQty
	
	s doseQty=$p($g(^OEORD(oeordId,"I",oeoriSub,2)),"^",1)
    i doseQty="" q phOrdQty
    s phcfrFactor=1
    s phcfrId=$p($g(^OEORD(oeordId,"I",oeoriSub,2)),"^",4)
    i phcfrId="" q phOrdQty
    s phcfrFactor=$p(^PHCFR(phcfrId),"^",2)

	//s unitUomId=934
    s phcdfId=$p($g(^ARCIM(+arcimId,$p(arcimId,"||",2),1)),"^",12)
    //b ;0
    q:phcdfId="" phOrdQty
    s phcdId=+phcdfId,phcdfSub=$p(phcdfId,"||",2)
    s baseUomId=$p($g(^PHCD(phcdId,"DF",phcdfSub,2)),"^",4)
    
    s qtyPackUom=$p($g(^OEORD(oeordId,"I",oeoriSub,9)),"^",4)
    s packUomId=$p($g(^ARCIM(+arcimId,$p(arcimId,"||",2),8)),"^",14)
    i $g(^OEORD(oeordId,"I",oeoriSub,"DHC"))'="" s packUomId=$p($g(^OEORD(oeordId,"I",oeoriSub,"DHC")),"^",13)
    //w packUomId_","_qtyPackUom_"/",!
    s packDoseQty=0
    i +qtyPackUom'=0,packUomId'="" d
        .s factor=1
        .i baseUomId'=packUomId d
            ..s ctcfId=$o(^CT("CTCF",0,"UOM",packUomId,baseUomId,""))
		    ..i ctcfId'="" s factor=$p(^CT("CTCF",ctcfId),"^",3)
		.//w "factor="_factor,!
	    .q:+factor=0
		.s packDoseQty=qtyPackUom*factor ;;dQty/factor  ;包装单位转换
		.i $p(packDoseQty,".",2)>0 s packDoseQty=$p(packDoseQty,".",1)+1
		//b ;1
	i packDoseQty'=0 q packDoseQty
    
	s phcduId=$p($g(^OEORD(oeordId,"I",oeoriSub,2)),"^",6)
	s phcduFactor=1
	i phcduId'="" s phcduFactor=$p(^PHCDU(phcduId),"^",2)
	//b ;2
	i +phcduFactor=0 q phOrdQty
    s unitUomId=$p($g(^OEORD(oeordId,"I",oeoriSub,2)),"^",3)
    //w oeoriSub_"||"_unitUomId_"/"_baseUomId_"/"_packUomId_"/"
    //b ;3
    q:unitUomId="" phOrdQty
    s eqQty=1
    i baseUomId'=unitUomId d
        .s eqId=0,eqQty=0
        .f  s eqId=$o(^PHCD(phcdId,"DF",phcdfSub,"EQ",eqId)) q:eqId=""  d
            ..s eqUomId=+^PHCD(phcdId,"DF",phcdfSub,"EQ",eqId)
            ..i eqUomId=unitUomId s eqQty=$p(^PHCD(phcdId,"DF",phcdfSub,"EQ",eqId),"^",2)
            //b ;4
    i eqQty=0 q phOrdQty
    s dQty=doseQty/eqQty
    i $p(dQty,".",2)>0 s dQty=$p(dQty,".",1)+1
    //s qty=dQty*phcfrFactor*phcduFactor
    s qty=dQty*phcduFactor
   	q qty
}

ClassMethod UpdatePatAllergy(oeoriId, userId, allergyFlag) As %String
{
   //无当前药品则插入
    n (oeoriId,userId,allergyFlag)
    q:(allergyFlag'="Y")&(allergyFlag'="N") 0
    
    s oeordId=$p(oeoriId,"||",1),oeoriSub=$p(oeoriId,"||",2)
    s dhcoriId=$o(^DHCORDItem(0,oeoriId,""))
    q:dhcoriId="" "置皮试信息失败!"
    s curDate=+$h,curTime=$p($h,",",2)
    
    s algId=$p(^DHCORDItem(dhcoriId),"^",5)
    s papmiId=+algId,algSub=+$p(algId,"||",2)
    i allergyFlag="N" d
        .i (algId'="") d
            ..s $p(^PAPER(papmiId,"ALG",algSub),"^",19)="Y"
            ..s $p(^PAPER(papmiId,"ALG",algSub),"^",8)="I"
            ..s $p(^PAPER(papmiId,"ALG",algSub),"^",16)=userId
            ..s $p(^PAPER(papmiId,"ALG",algSub),"^",23)=curDate
            ..s $p(^PAPER(papmiId,"ALG",algSub),"^",24)=curTime
            ..s $p(^DHCORDItem(dhcoriId),"^",5)=""
    i allergyFlag="N" q 0
    i (allergyFlag="Y")&(algId'="")&($p($g(^PAPER(papmiId,"ALG",algSub)),"^",19)="N") q 0
    
    s arcimId=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",2)
    s phcdfId=$p(^ARCIM(+arcimId,$p(arcimId,"||",2),1),"^",12) //ARCIM_PHCDF_DR
    q:phcdfId="" "无药品指针!"
    k PLIST
    s PLIST(0)=+^PAADM(+^OEORD(oeordId)) //ALG_PAPMI_ParRef
    s PLIST(3)=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",11) //ALG_CTPCP_DR暂用下医嘱医生
    s PLIST(8)="" //ALG_Type_DR 取不到
    s PLIST(11)="A" //ALG_Status
    s PLIST(12)=curDate //ALG_Date
    s PLIST(13)=curDate //ALG_OnsetDate
    s PLIST(18)=curTime //ALG_Time
    s PLIST(19)=userId //ALG_UpdateUser_DR
    s PLIST(22)="N" //ALG_InActive
    s PLIST(23)=1 //ALG_LastUpdateHospital_DR
    s PLIST(24)="" //ALG_Severity_DR
    s PLIST(26)=curDate //ALG_LastUpdateDate
    s PLIST(27)=curTime //ALG_LastUpdateTime
    s PLIST(31)=+phcdfId //ALG_PHCDM_DR
    s PLIST(33)=$o(^MRC("AT",0,"MRCAA_Desc","药物","")) //ALG_MRCAllType_DR
    s PLIST(34)=arcimId
    //w !,PLIST(0)_","_PLIST(3)_","_PLIST(8)_","_PLIST(11)_","_PLIST(12)_","_PLIST(13)_","_PLIST(18)_","_PLIST(19)_","_PLIST(22)_","_PLIST(23)_","_PLIST(26)_","_PLIST(27)_","_PLIST(31)_","_PLIST(33)
    &sql(Insert into PA_Allergy Values PLIST())
    i SQLCODE q "过敏记录插入有误!"
    ;s $p(^PAPER(PLIST(0),"ALG",$p(%ROWID,"||",2)),"^",30)=PLIST(0)_"ALG"_$p(%ROWID,"||",2)
    s $p(^DHCORDItem(dhcoriId),"^",5)=%ROWID
    s $P(^PAPER(PLIST(0),"ALG",$p(%ROWID,"||",2),"DHC"),"^",3)=allergyFlag
    q 0
}

ClassMethod DeletePatAllergy(oeoriId, userId, skinTestDate, skinTestTime)
{
    //按药品和皮试走
    n (oeoriId, userId, skinTestDate, skinTestTime)
	s arcimId=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",2)
    s phcdfId=$p(^ARCIM(+arcimId,$p(arcimId,"||",2),1),"^",12) //ARCIM_PHCDF_DR
    q:phcdfId="" "未找到药物!"
    s papmiId=+^PAADM(+^OEORD(oeordId))
	//////s skinTestDate=PLIST(46)
	//////s skinTestTime=PLIST(47)
	s algSub=0
	f  s algSub=$o(^PAPER(papmiId,"ALG",algSub)) q:algSub=""  d
	    .s algStr=^PAPER(papmiId,"ALG",algSub) //注意,过敏按类别走时要更新
	    .i ($p(algStr,"^",10)=skinTestDate)&($p(algStr,"^",15)=skinTestTime)&($p(algStr,"^",27)=+phcdfId) d
	        ..s algId=papmiId_"||"_algSub
	        ..&sql(delete from PA_Allergy where ALG_RowId=:algId)
	        ..////s setRet=..SetSkinTestResult(oeordId_"||"_oeoriSub,"")
	q 0
}

///  1  关联   0 不关联
ClassMethod CheckLink(oeori As %String) As %String
{
	n (oeori)
	s ord=+oeori
	s itm=$p(oeori,"||",2)
	s moeori=$p(^OEORD(ord,"I",itm,11),"^",39)  // 主医嘱ID
	Q:moeori'="" 1  ///存在关联医嘱
	s ret=$o(^OEORDi(0,"OEORI",ord,ord_"||"_itm,"")) 
	Q:+ret'=0 1  ///存在关联医嘱
	Q 0
}

///  1  关联   0 不关联
ClassMethod getMainOrdItmID(ord, itm) As %String
{
	n (ord,itm)
	s moeori=$p(^OEORD(ord,"I",itm,11),"^",39)  // 主医嘱ID
	q:moeori'="" moeori
	q ord_"||"_itm
}

/// 检验医嘱条码号
ClassMethod getLisOrdLabNo(ord, itm)
{
	n (ord, itm)
	s labNo="",specDesc=""
	s labNo=$p($g(^OEORD(ord,"I",itm,3)),"^",20)
    s blLabNo = ##Class(web.DHCAPPPisInterface).GetRepRowIdByOeordID(ord_"||"_itm)
    i blLabNo'="" d
    .s labNo=blLabNo
    .s specDesc=##Class(web.DHCAPPPisInterface).GetSpeNameByRepID(blLabNo)     ///获取标本名称
    .s count=$l(specDesc,";")
	.f i=1:1:count d
	..s blInfo=$p(specDesc,";",i)
	..i labNo="" s labNo=$p(blInfo,"!",5)
	..e  s labNo=labNo_";"_$p(blInfo,"!",5)
	q labNo_"^"_specDesc
}

///  皮试时间
/// 
/// w ##class(web.DHCEMOrdInfoVO).GetSkinTestDate("585||8||1")
ClassMethod GetSkinTestDate(oeoriId As %String) As %String
{
	n (oeoriId)
    s ret=""
    s dhcoriId=$o(^DHCORDItem(0,oeoriId,""))
    i dhcoriId'="" d
    .s skinTestDate=$p(^DHCORDItem(dhcoriId),"^",3)
    .s skinTestTime=$p(^DHCORDItem(dhcoriId),"^",4)
    .q:+skinTestDate=0
    .s ret=##class(web.DHCEMCommonUtil).DateLogicalToHtml(skinTestDate)_" "_$zt(skinTestTime)
    q ret
}

///  皮试结果和皮试医生
/// 
/// w ##class(web.DHCEMOrdInfoVO).GetSkinResultUser("585||8||1")
ClassMethod GetSkinResultUser(oeoriId As %String) As %String
{
	n (oeoriId)
    s skinTestCtcpDesc="",skinTestCtAuditcpDesc=""
    s abnorm=$p($g(^OEORD(+oeoriId,"I",$p(oeoriId,"||",2),11)),"^",3)
    s dhcoriId=$o(^DHCORDItem(0,oeoriId,""))
    i dhcoriId'="" d
    .s skinTestCtcpId=$p(^DHCORDItem(dhcoriId),"^",2)
    .i skinTestCtcpId="" q
    .s skinTestCtcpDesc=$p($g(^CTPCP(skinTestCtcpId,1)),"^",2)
    .s skinTestCtAuditcpId=$p(^DHCORDItem(dhcoriId),"^",13) //hxy 2022-09-09 st 复核人
    .s skinTestCtAuditcpDesc=$p($g(^CTPCP(+skinTestCtAuditcpId,1)),"^",2)
    .s:skinTestCtAuditcpDesc'="" skinTestCtAuditcpDesc=" "_skinTestCtAuditcpDesc //ed
    s skin=$s(abnorm="N":" (-)",abnorm="Y":" (+)",abnorm="":"")
    q:skin="" ""
    q:skin'="" skin_" "_skinTestCtcpDesc_skinTestCtAuditcpDesc
}

ClassMethod getSkinResult(oeoriId)
{
	n (oeoriId)
    s skinTestCtcpDesc=""
    s abnorm=$p($g(^OEORD(+oeoriId,"I",$p(oeoriId,"||",2),11)),"^",3)
    s dhcoriId=$o(^DHCORDItem(0,oeoriId,""))
    i dhcoriId'="" d
    .s skinTestCtcpId=$p(^DHCORDItem(dhcoriId),"^",2)
    .i skinTestCtcpId="" q
    .s skinTestCtcpDesc=$p($g(^CTPCP(skinTestCtcpId,1)),"^",2)
    s skin=$s(abnorm="":"",abnorm'="":abnorm)
    q skin
}

/// 获取停医嘱时间
ClassMethod GetxDateTime(ord, itm) As %String
{
	n (ord,itm)
    s ret=""
    s xDate=$p($g(^OEORD(ord,"I",itm,3)),"^",34)
    i xDate'="" s xDate=##class(web.DHCEMCommonUtil).DateLogicalToHtml(xDate)
    s xTime=$p($g(^OEORD(ord,"I",itm,2)),"^",15)
    i xTime'="" s xTime=$zt(+xTime)
	q xDate_" "_xTime
}

/// 获取停医嘱人
ClassMethod GetxCtcpDesc(ord, itm) As %String
{
	n (ord,itm,%session)
	s ret=""
    s xCtcpId=$p($g(^OEORD(ord,"I",itm,3)),"^",29)
    s xDate=$p($g(^OEORD(ord,"I",itm,3)),"^",34)
    i +xCtcpId=0 d
    .i xDate'="" d
    ..s ordStatSub=^OEORD(ord,"I",itm,"ST",0)
    ..s ordStatStr=^OEORD(ord,"I",itm,"ST",ordStatSub)
    ..i $p(^OEC("OSTAT",$p(ordStatStr,"^",3)),"^",1)="D" d
    ...s xUserId=$p(ordStatStr,"^",4) //??
    ...s xCtcpId=$p(^SSU("SSUSR",+xUserId),"^",14)
  	...i xCtcpId'="" s ret=##class(web.DHCEMCommonUtil).GetTransDesc("User.CTCareProv","CTPCPDesc","",$p($g(^CTPCP(xCtcpId,1)),"^",2)) 
    e  d
    .s ret=##class(web.DHCEMCommonUtil).GetTransDesc("User.CTCareProv","CTPCPDesc","",$p($g(^CTPCP(xCtcpId,1)),"^",2)) 
    q ret
}

/// 医嘱要求执行时间
ClassMethod GetSttDateTime(ord, itm, sub) As %String
{
	n (ord,itm,sub)
	s sttDate=$p($g(^OEORD(ord,"I",itm,1)),"^",9)  
    s sttTime=$p($g(^OEORD(ord,"I",itm,1)),"^",10)  
	i +sub'=0 d
	.s sttDate=$p($g(^OEORD(ord,"I",itm,"X",sub)),"^",1)
	.s sttTime=$p($g(^OEORD(ord,"I",itm,"X",sub)),"^",2)
	s:sttDate'="" sttDate=##class(web.DHCEMCommonUtil).DateLogicalToHtml(sttDate) //hxy 2017-03-07 $zd(sttDate,3)
	s:sttTime'="" sttTime=$zt(sttTime,2)
	q sttDate_" "_sttTime
}

/// 是否需要判断收费
/// 0 不判断收费
/// 1 判断收费
ClassMethod checkFeeFlag(ord, itm) As %String
{
	n (ord,itm)
	
	// 留观病人 (1:是,其他：否)
	s stayFlag=$p($g(^OEORD(ord,"I",itm,"DHC")),"^",17)
	//（0：走普通收费模式，1：走押金模式）
    s payMode=##class(web.DHCEMCommonUtil).IGetStayPayModeByOrdItm(ord_"||"_itm)
    q:stayFlag'=1 1
    q:((payMode'=1)&(stayFlag=1)) 1
    q 0
}

/// 是否急诊留观科室
/// 0 不是
/// 1 是
/// w ##class(web.DHCEMOrdInfoVO).checkStayFlag()
ClassMethod checkStayFlag(grp, userid) As %String
{
	n (grp,userid)
	q:$d(^DHCEMPSA(0,"TYPE","U",+userid))=10 1
	q:$d(^DHCEMPSA(0,"TYPE","G",+grp))=10 1
    q 0
}

/// 是否治疗服务端或客户端
/// 0 不是
/// 1 服务端
/// 2 客户端
/// w ##class(web.DHCEMOrdInfoVO).checkStayFlag()
ClassMethod checkTreate(coputerName) As %String
{
	n (coputerName,%session)
	s LocId=$G(%session.Data("LOGON.CTLOCID"))
	s IP=$G(%session.Data("REMOTE_ADDR"))
	
	s serverId=$O(^DHCVISServeri(0,"ServerIP",coputerName,""))
	q:+serverId'=0 1
	s serverId=$O(^DHCVISServeri(0,"ServerIP",IP,""))
	q:+serverId'=0 1
	s serverId=$O(^DHCVISServeri(0,"LinkLoc",LocId,""))
	q:+serverId'=0 1
	
	s clientId=$O(^DHCVISClienti(0,"ClientIP",coputerName,""))
	q:+clientId'=0 2
	s clientId=$O(^DHCVISClienti(0,"ClientIP",IP,""))
	q:+clientId'=0 2
	q 0
}

/// 取病人就诊科
ClassMethod getAdm(ord As %String) As %String
{
	n (ord)
	q $p($g(^OEORD(+ord)),"^",1)
}

/// 判断医嘱收费状态
/// Test:w ##class(web.DHCEMOrdInfoVO).IsUnPaid("1155||3")
ClassMethod IsUnPaid(oeoriId)
{
	s disposeStatCode=""
	s oeordId=$P($G(oeoriId),"||",1)
	s oeoriSub=$P($G(oeoriId),"||",2)
    s stayFlag=$p($g(^OEORD(oeordId,"I",oeoriSub,"DHC")),"^",17)
    s payMode=##class(web.DHCBillInterface).IStayPayModeByEpisodeID()
    
    s ordStatId=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",13) ;OEORI_ItemStat_DR
	s ordStatCode=$p($g(^OEC("OSTAT",+ordStatId)),"^")

    s oecprId=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",8)
	s oecprCode=$p($g(^OECPR(oecprId)),"^")
	s oeoriBilled=$p($g(^OEORD(oeordId,"I",oeoriSub,3)),"^",5)
	i ((stayFlag'=1)!(payMode=0))&(ordStatCode'="D")&(oecprCode'="OM")&(oecprCode'="OMCQZT")&(oecprCode'="OMLSZT")&(oecprCode'="OMST")&((oeoriBilled="B")!(oeoriBilled="TB")) d
	.s disposeStatCode="UnPaid"
	q disposeStatCode
}

/// 获取皮试结果
/// Test:w ##Class(web.DHCEMOrdInfoVO).SkinTestResult("1155||4")
ClassMethod SkinTestResult(oeoriId)
{
	q:oeoriId="" ""
	s oeordId=$P($G(oeoriId),"||",1)
	s oeoriSub=$P($G(oeoriId),"||",2)
	s preFlag=$p(^OEORD(oeordId,"I",oeoriSub,11),"^",3)
	q preFlag
}

/// 是否治疗用药(1:是,0:不是)
/// Test:w ##Class(web.DHCEMOrdInfoVO).SkinTestResult("1155||4")
ClassMethod GetIsCureSKinOrd(OrdItmID)
{
	n (OrdItmID)
	s Ord =+OrdItmID
	s Itm =$p(OrdItmID,"||",2)
	s Ret=0
    s skinUseMethod = ##class(DHCDoc.Interface.Inside.Service).CheckOrdIsSkinInstr(Ord_"||"_Itm)
    s ActId=$p($g(^OEORD(Ord,"I",Itm,11)),"^",21)
    s ActCode=""
    i ActId'="" s ActCode=$p(^OEC("ACT",ActId),"^",1)
    s SkinTestFlag=$p($g(^OEORD(Ord,"I",Itm,5)),"^",2)
    s:(SkinTestFlag="Y")&&(skinUseMethod'=1)&&(ActCode'="YY") Ret=1
    q Ret
}

/// 获取医嘱的剂量（按照医嘱查所有）
/// w ##class(web.DHCEMOrdInfoVO).GetOrdItmQtyUnit("3107","3")
ClassMethod GetOrdItmQtyUnit(ord, itm)
{
	n (ord,itm)
	s ret=""
	s doseQty=$p($g(^OEORD(ord,"I",itm,2)),"^",1)
    s unitUomId=$p($g(^OEORD(ord,"I",itm,2)),"^",3)
   	s unitDesc=""
	s unitDesc=$p($g(^CT("UOM",+unitUomId)),"^",2)
	q:(doseQty'="")&&(unitDesc'="") doseQty_unitDesc   ///还是在医嘱表的
	
	q ##class(DHCDoc.Interface.Inside.Service).GetOrdDoseQty(ord_"||"_itm)_unitDesc
}

ClassMethod IsSkinOrd(Ord, Itm)
{
	n (Ord, Itm)
	s InciId=$p($g(^OEORD(Ord,"I",Itm,1)),"^",2)
	q ##class(PHA.FACE.OUT.Com).GetInciSkinTest(InciId)
}

ClassMethod GetOrdLockStatus(Ord, Itm)
{
	s InciId=$p($g(^OEORD(Ord,"I",Itm,1)),"^",2)
	s ReclocDr=$p($g(^OEORD(Ord,"I",Itm,3)),"^",6)
	q ##class(PHA.FACE.OUT.Com).GetIncilLockFlag(InciId,ReclocDr)
}

/// w ##class(web.DHCEMOrdInfoVO).GetOverTimeReqExecDateHours("399||574||1")
ClassMethod GetOverTimeReqExecDateHours(OrdExecID)
{
	s Ord = $p(OrdExecID,"||",1)
	s Itm = $p(OrdExecID,"||",2)
	s Sub = $p(OrdExecID,"||",3)
	s SttDate=$p($g(^OEORD(Ord,"I",Itm,1)),"^",9)  
    s SttTime=$p($g(^OEORD(Ord,"I",Itm,1)),"^",10)  
	i +Sub'=0 d
	.s SttDate=$p($g(^OEORD(Ord,"I",Itm,"X",Sub)),"^",1)
	.s SttTime=$p($g(^OEORD(Ord,"I",Itm,"X",Sub)),"^",2)
	
	s ExecStatusId=$p($g(^OEORD(Ord,"I",Itm,"X",+Sub)),"^",16) //执行状态
	s ExecStatusCode=$p($g(^OEC("STAT",+ExecStatusId)),"^",1) 
	q:ExecStatusCode="F" ""
	
	s NowDate=+$H,NowTime=$p($H,",",2)
	s Hours=(NowDate-SttDate*24)+(NowTime-SttTime\3600)
	q Hours
}

ClassMethod GetExecNotes(OrdExecID)
{
	s Ord = $p(OrdExecID,"||",1)
	s Itm = $p(OrdExecID,"||",2)
	s Sub = $p(OrdExecID,"||",3)

	q $p($g(^OEORD(+Ord,"I",+Itm,"X",+Sub)),"^",44)
}

/// w ##class(web.DHCEMOrdInfoVO).GetAllgryFlag("32")
ClassMethod GetAllgryFlag(Ord)
{
	s AdmId=+^OEORD(Ord)
	s Allgryparref = +^PAADM(AdmId)
	s Allgrysub="",Allgryflag="" 
	i Allgryparref'="" d
	.s Allgrysub=""
	.f  s Allgrysub=$o(^PAPER(Allgryparref,"ALG",Allgrysub)) q:Allgrysub=""  d ;2016-10-25 congyue
	..s AllStatus=$p(^PAPER(Allgryparref,"ALG",Allgrysub),"^",8)
	..q:AllStatus'="A"
	..s Allgryflag=1
	q Allgryflag
}

/// w ##class(web.DHCEMOrdInfoVO).emOrdCat("995340||6")
ClassMethod emOrdCat(OrdItmID)
{
	s Ret=##class(web.DHCEMCommonUtil).GetTrans("dhcem.nur.exec.hisui.csp","临时")
	s TraLong=##class(web.DHCEMCommonUtil).GetTrans("dhcem.nur.exec.hisui.csp","长期")
	s Ord = $p(OrdItmID,"||",1)
	s Itm = $p(OrdItmID,"||",2)
	s FillerNo=$p($g(^OEORD(Ord,"I",Itm,9)),"^",12)
	s:FillerNo'="" Ret=TraLong
	s VirtualtLong=$p($g(^OEORD(Ord,"I",Itm,"DHC")),"^",57)
	s:VirtualtLong="Y" Ret=TraLong
	q Ret
}

/// w ##class(web.DHCEMOrdInfoVO).GetEndData("998370","10")
ClassMethod GetEndData(ord, itm)
{
	s emOrdCat = ##class(web.DHCEMOrdInfoVO).emOrdCat(ord_"||"_itm)
	s stopDate = ""
	s stopTime = ""
	s stopUser=""
	if (emOrdCat="长期") {
		s stopDataInfo = ##class(web.DHCDocLocal).GetEndMesage(ord_"||"_itm)
		s stopDate = $p(stopDataInfo,"^",1)
		s stopTime = $p(stopDataInfo,"^",2)
		s stopUserId = $p(stopDataInfo,"^",3)
		s:+stopUserId'=0 stopUser = $p($g(^SSU("SSUSR",+stopUserId)),"^",1)
	} else {
		s stopDate=$p(^OEORD(ord,"I",itm,3),"^",34)		
		s stopTime=$p($g(^OEORD(ord,"I",itm,2)),"^",15)
		s stopUser = ##class(web.DHCEMOrdInfoVO).GetxCtcpDesc(ord,itm)
		;没停止日期时,取预停日期
		;s:stopDate="" stopDate=$p(^OEORD(ord,"I",itm,9),"^",9)	
		;s:stopTime="" stopTime=$p(^OEORD(ord,"I",itm,9),"^",10)
	}
	q stopDate_"^"_stopTime_"^"_stopUser
}

/// 执行人
ClassMethod GetXOrdInfo(oeordId, oeoriSub)
{
	n (oeordId, oeoriSub)
	s xUserDr=$p($g(^OEORD(oeordId,"I",oeoriSub,"NUR")),"^",1)		//停止医嘱处理护士
	s xDate=$p($g(^OEORD(oeordId,"I",oeoriSub,"NUR")),"^",2)		//停止医嘱处理日期
	s xTime=$p($g(^OEORD(oeordId,"I",oeoriSub,"NUR")),"^",3)		//停止医嘱处理时间
	q $G(xUserDr)_"^"_$G(xDate)_"^"_$G(xTime)
}

/// 处理人
ClassMethod GetSeeOrdInfo(oeordId, oeoriSub)
{
	n (oeordId, oeoriSub)
	s xUserDr=$p($g(^OEORD(oeordId,"I",oeoriSub,"NUR")),"^",4)  	//医嘱处理护士
	s xDate=$p($g(^OEORD(oeordId,"I",oeoriSub,"NUR")),"^",5)		//医嘱处理日期
	s xTime=$p($g(^OEORD(oeordId,"I",oeoriSub,"NUR")),"^",6)		//医嘱处理时间	
	q $G(xUserDr)_"^"_$G(xDate)_"^"_$G(xTime)
}

/// w ##class(web.DHCEMOrdInfoVO).getOrdbm(998418,34)
ClassMethod getOrdbm(ord As %String, itm As %String) As %String
{
	n (ord,itm)
	s arcimId=$p($g(^OEORD(ord,"I",itm,1)),"^",2)
	Q:arcimId="" ""
	s allstextdr=$o(^ARC("ALIAS",0,"ARCIM",arcimId,""))
	s ALIASText=$p($g(^ARC("ALIAS",allstextdr)),"^",6)
	q ALIASText
}

/// w ##class(web.DHCEMOrdInfoVO).getOrdbmORD(998418,34)
ClassMethod getOrdbmORD(ord As %String, itm As %String) As %String
{
    n (ord,itm)
  	s user=$p($g(^OEORD(ord,"I",itm,7)),"^",1)
    q:user="" ""
    s ctcpId=$p(^SSU("SSUSR",user),"^",14)
    q:ctcpId="" ""
   
	s PrvTpID="",ThisProvType=""
	s PrvTpID=$p($g(^CTPCP(+ctcpId,1)),"^",4)      /// 职称
	I PrvTpID'="" s ThisProvType = $p(^CT("CPT",PrvTpID),"^",4)
	Q ThisProvType
}

/// 是否治疗申请医嘱(1:是,0:不是)
/// Test:w ##Class(web.DHCEMOrdInfoVO).GetIStreatOrd("1155||4")
ClassMethod GetIsTreatOrd(OrdItmID)
{
	n (OrdItmID)
	s Ord =+OrdItmID
	s Itm =$p(OrdItmID,"||",2)
	s Ret=0
	s TreatOrdId=##class(web.DHCDocInterfaceMethod).DHCDocHisInterface("doc.doccure.GetCureApplyByOrd",Ord_"||"_Itm)
	s:TreatOrdId'="" Ret=1
    q Ret
}

}
