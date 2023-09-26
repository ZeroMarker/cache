Class web.DHCEMInComUseMethod Extends %Persistent [ ClassType = "", Not ProcedureBlock ]
{

/// 通过医嘱子ID获取医嘱大类类别
/// w ##class(web.DHCEMInComUseMethod).GetOECCatByOEORDItmDr("410||5")
ClassMethod GetOECCatByOEORDItmDr(OEORIDr)
{
	n (OEORIDr,%session)
	s Ord = +OEORIDr
	s Itm = $p(OEORIDr,"||",2)
	s ArcimID =$p($g(^OEORD(Ord,"I",Itm,1)),"^",2)
	q:ArcimID="" ""
	s ARCICatDr = $p(^ARCIM(+ArcimID,$p(ArcimID,"||",2),1),"^",10)
	s OECCatDr = $p(^ARC("IC",ARCICatDr),"^",8)
	s OECCatDesc = $p(^OEC("ORCAT",OECCatDr),"^",2)
	s OECCatDesc=##class(web.DHCEMCommonUtil).GetTransDesc("User.OECOrderCategory","ORCATDesc","",OECCatDesc)
	q OECCatDesc
}

/// 通过医嘱子ID获取医嘱大类类别
/// w ##class(web.DHCEMInComUseMethod).GetArcTypeByOEORDItmDr("410||5")
ClassMethod GetArcTypeByOEORDItmDr(OEORIDr)
{
	n (OEORIDr)
	s ArcType=""
	s Ord = +OEORIDr
	s Itm = $p(OEORIDr,"||",2)
	s ArcimID =$p($g(^OEORD(Ord,"I",Itm,1)),"^",2)
	q:ArcimID="" ""
	s ARCICatDr = $p(^ARCIM(+ArcimID,$p(ArcimID,"||",2),1),"^",10)
	s ArcType = $p(^ARC("IC",ARCICatDr),"^",7)   ;ARC_ItemCat 表中的ARCIC_Ordertype ,="R"是药物
	q ArcType
}

/// 通过医嘱子ID获取医嘱大类类别
/// w ##class(web.DHCEMInComUseMethod).GetOrdArcPrice("10||1")
ClassMethod GetOrdArcPrice(OEORIDr)
{
	n (OEORIDr)
	s Ord = +OEORIDr
	s Itm = $p(OEORIDr,"||",2)
	s PaAdm = $p(^OEORD(Ord),"^",1)
	s EpissubtypeId = $P($g(^PAADM(PaAdm,1)),"^",6)
	s AdmReasonId=$P($g(^PAADM(PaAdm,1)),"^",7)  //费别ID 11-09
	s PAADMRegConDisDR=$P($G(^PAADM(PaAdm,"DHC")),"^",25)
	s ProtocolPackUOMDR=$p($g(^OEORD(Ord,"I",Itm,"DHC")),"^",13)
	s ArcimId=$p(^OEORD(Ord,"I",Itm,1),"^",2)
	s OEORIPrice=$p(^OEORD(Ord,"I",Itm,3),"^",25)
	s ReLocID=$p($g(^OEORD(Ord,"I",Itm,3)),"^",6)
	s ExpStr=PAADMRegConDisDR_"^"_Ord_"||"_Itm_"^^"_PaAdm_"^"_ReLocID	
	s ArcPrice=##class(web.UDHCJFPRICE).GetOrderPrice(EpissubtypeId,AdmReasonId,ArcimId , $H, "", "","", OEORIPrice,"",ExpStr)
	q $j($p(ArcPrice,"^",1),3,4)
}

/// 通过医嘱子ID获取计费状态
/// w ##class(web.DHCEMInComUseMethod).GetChargeStatus("10||1")
ClassMethod GetChargeStatus(OEORIDr)
{
	n (OEORIDr)
	s ChargeStatus=""
	s Ord = +OEORIDr
	s Itm = $p(OEORIDr,"||",2)
	s OrdBilled = $p(^OEORD(Ord,"I",Itm,3),"^",5)
	s ChargeStatus = $case(OrdBilled,"TB":"未计费","B":"已计费","P":"已结算","I":"已账单停医嘱","R":"未账单停医嘱",:"")
	q ChargeStatus
}

/// 通过医嘱子ID获取医嘱子类类别
/// w ##class(web.DHCEMInComUseMethod).GetARCICatByOEORDItmDr("6288||5")
ClassMethod GetARCICatByOEORDItmDr(OEORIDrStr)
{
	n (OEORIDrStr)
	s ret=""
	q:OEORIDrStr="" ret    //sufan 2018-03-08 医嘱ID为空时，返回空
	s Len = $l(OEORIDrStr,",")
	f i=1:1:Len d
	.s OEORIDr = $p(OEORIDrStr,",",i)
	.s Ord = +OEORIDr
	.s Itm = $p(OEORIDr,"||",2)
	.s ArcimID =$p($g(^OEORD(Ord,"I",Itm,1)),"^",2)
	.q:ArcimID="" 
	.s ARCICatDr = $p(^ARCIM(+ArcimID,$p(ArcimID,"||",2),1),"^",10)
	.s ARCICatDesc = $p(^ARC("IC",ARCICatDr),"^",2)
	.s:ret'="" ret=ret_"#"_ARCICatDr_"^"_ARCICatDesc
	.s:ret="" ret=ARCICatDr_"^"_ARCICatDesc
	q ret
}

/// 检验大类下所有子类
/// w ##class(web.DHCEMInComUseMethod).JsonListARCICatByOECCat(7)
ClassMethod JsonListARCICatByOECCat(OECCatID)
{
	n (OECCatID)
	s ret=""
	q:OECCatID="" ""
	s ARCICRowId=""
	f  s ARCICRowId = $o(^ARC("IC",0,"OrdCat",OECCatID,ARCICRowId)) q:ARCICRowId=""  d
	.s ArciCatDesc=  $p(^ARC("IC",ARCICRowId),"^",2)
	.s:ret'="" ret = ret_"^"_ARCICRowId
	.s:ret="" ret = ARCICRowId
	q ret
}

/// 通过医嘱子ID获取医嘱信息
/// w ##class(web.DHCEMInComUseMethod).GetOEORIInfoByOEORIDr("6288||5")
ClassMethod GetOEORIInfoByOEORIDr(OEORIDr)
{
	n (OEORIDr)
	s Ord=+OEORIDr
	s Itm = $p(OEORIDr,"||",2)
	s ARCIName = ..getArcimDesc(Ord,Itm)
	s OrdDateTime = ..GetStDateTime(Ord,Itm)
	q ARCIName_"^"_OrdDateTime
}

/// 根据就诊ID获取所挂号别 demo：蒋荣猛(副主任)^920^上午
/// w ##class(web.DHCEMInComUseMethod).GetRegMark(123)
ClassMethod GetRegMark(Adm) As %String
{
	n (Adm,%session)
	s MarkID=""
	s MarkDesc=""
	s TRDesc=""
	s hosp =""
	&SQL(SELECT ID into :RegfeeRowId FROM SQLUser.DHCRegistrationFee Where RegfeeAdmDr=:Adm)
	q:RegfeeRowId="" "^^"
	&SQL(SELECT RegfeeDocDr,RegfeeTimeRangeDr into :MarkID,:TRRowId 
	FROM SQLUser.DHCRegistrationFee Where ID=:RegfeeRowId)
	s:TRRowId'="" TRDesc=$P(^DHCTimeRange(TRRowId),"^",2) //ed
	s:MarkID'="" MarkDesc=$P($G(^CTPCP(MarkID,1)),"^",2)
	s MarkDesc=##class(web.DHCEMCommonUtil).GetTransDesc("User.CTCareProv","CTPCPDesc","",MarkDesc) //hxy 2022-12-20 st
	s TRDesc=##class(web.DHCEMCommonUtil).GetTransDesc("User.DHCTimeRange","TRDesc","",TRDesc) //ed
	Q MarkDesc_"^"_MarkID_"^"_TRDesc
}

ClassMethod GetStDateTime(ord As %String, itm As %String)
{
	n (ord,itm)
	s sttDate=$p($g(^OEORD(ord,"I",itm,1)),"^",9)  
    s sttTime=$p($g(^OEORD(ord,"I",itm,1)),"^",10) 	
    s sttDate=##class(web.DHCEMCommonUtil).DateLogicalToHtml(sttDate)
    s sttTime =$zt(sttTime,2)  
    q sttDate_" "_sttTime
}

/// 取接受科室
ClassMethod GetReclocDesc(oeordId As %String, oeoriSub As %String) As %String
{
	n (oeordId,oeoriSub)
	s reclocDr="",reclocDesc=""
	s reclocDr=$p($g(^OEORD(oeordId,"I",oeoriSub,3)),"^",6)
	s:reclocDr'="" reclocDesc=$p($g(^CTLOC(reclocDr)),"^",2)
	q reclocDr_"^"_reclocDesc
}

/// 取医嘱名称
/// w ##class(web.DHCEMInComUseMethod).getArcimDesc(1,1)
ClassMethod getArcimDesc(ord As %String, itm As %String) As %String
{
	n (ord,itm)
	s arcimID =$p($g(^OEORD(ord,"I",itm,1)),"^",2)
	i arcimID'="" s arcimDesc= $P($G(^ARCIM(+arcimID,$p(arcimID,"||",2),1)),"^",2)
	e  q ""
	s oecprCode=##Class(web.DHCEMOrdInfoVO).GetOecprCode(ord_"||"_itm)
    s skintest=$p($g(^OEORD(ord,"I",itm,5)),"^",2)
    s abnorm=$p($g(^OEORD(ord,"I",itm,11)),"^",3)
    s actId=$p($g(^OEORD(ord,"I",itm,11)),"^",21)
    s actCode="",actDesc=""
    i actId'="" s actCode=$p(^OEC("ACT",actId),"^",1),actDesc=$p(^OEC("ACT",actId),"^",2)
    i actDesc'="" s arcimDesc=arcimDesc_"(皮试:"_actDesc_")"
    s PriorityDesc=""
    s PriorityDr = $p($g(^OEORD(ord,"I",itm,1)),"^",8)
    s:+PriorityDr'=0 PriorityDesc = $p(^OECPR(PriorityDr),"^",2) 
    i PriorityDesc["自备药" s arcimDesc=arcimDesc_"(自备药)"
    i PriorityDesc["嘱托" s arcimDesc=arcimDesc_"(嘱托)"
	q arcimDesc
}

/// 	Descript:获取医嘱频次
/// w ##class(web.DHCEMInComUseMethod).GetPHFreq(946,2)
ClassMethod GetPHFreq(Ord, Itm)
{
	n (Ord,Itm)
	s PHFreq=""
	s PHFreqDR=$p($g(^OEORD(Ord,"I",Itm,2)),"^",4)
	s:PHFreqDR'="" PHFreq=$p(^PHCFR(PHFreqDR),"^",1)
	s OrderFreqWeek=$p($g(^OEORD(Ord,"I",Itm,"DHC")),"^",55)
	s WeekInfo=$TR(OrderFreqWeek,"|","")	
	s:WeekInfo'="" PHFreq=PHFreq_" "_WeekInfo	
	q PHFreq
}

/// 	Descript:获取皮试医嘱结果
/// w ##class(web.DHCEMInComUseMethod).GetAbnormRs(10,1)
ClassMethod GetAbnormRs(Ord, Itm)
{
	n (Ord,Itm)
	s OrdSkinTest=$p($g(^OEORD(Ord,"I",Itm,5)),"^",2)
	s Abnorm=$p($g(^OEORD(Ord,"I",Itm,11)),"^",3)
	s OrdSkinTestResult=""
	.i OrdSkinTest="Y" d
	..i Abnorm="Y" s OrdSkinTestResult="阳性"
	..i Abnorm="N" s OrdSkinTestResult="阴性"
	q OrdSkinTestResult
}

/// 根据医嘱ID获取部位
/// w ##class(web.DHCEMInComUseMethod).getArcimDesc('6288||5')
ClassMethod GetstrOrderName(orditem As %String) As %String
{
	s StrOrderBodyName=##Class(web.DHCRisWorkBenchDoEx).GetCheckReqItmDetByOrdItm(orditem)
	s StrOrderName=$p($g(StrOrderBodyName),"!",1)
	s BodyName=$p($g(StrOrderBodyName),"!",2)
	q BodyName
}

/// 获取时间段内病人就诊ID字符串
/// w ##class(web.DHCEMInComUseMethod).GetAdmStrByPatID(77,"","","")
ClassMethod GetAdmStrByPatID(PatID As %String, Type As %String, StartDate As %String, EndDate As %String)
{
	 n (PatID, Type ,StartDate,EndDate, DayNum)
	 q:PatID="" ""
	 i Type="" s Type="O^E^I^P^H"
     s AdmStr="",Num=1

     f i=1:1:$l(Type,"^") d
     .s Temptype=$p(Type,"^",i)
     .s EpisodeID=""
     .f  s EpisodeID=$o(^PAPERdr(PatID,"ADM",Temptype,EpisodeID),-1) q:EpisodeID=""  d  
     ..s Pavisit=$p($g(^PAADM(EpisodeID)),"^",20)
     ..s AdmDate=$p($g(^PAADM(EpisodeID)),"^",6)
     ..q:(StartDate'="")&(AdmDate<StartDate)
     ..q:(EndDate'="")&(AdmDate>EndDate)
     ..s $p(AdmStr,"^",Num)=EpisodeID
     ..s Num=Num+1
     q AdmStr
}

/// 获取病人就诊ID JSON-Combobox
/// w ##class(web.DHCEMInComUseMethod).JsonAdms(4,2)
ClassMethod JsonAdms(PatID, LgHospID = "", AdmType = "", AdmId = "")
{
	 n (PatID,LgHospID,AdmType,AdmId,%session)
	 
	s Pid=##Class(web.DHCEMInterfaceCom).NewPid()
	s:+AdmId'=0 PatID=$p(^PAADM(AdmId),"^",1)
	q:+PatID=0 ""
	
	s Temptype=""
	f  s Temptype=$o(^PAPERdr(PatID,"ADM",Temptype)) q:Temptype=""  d 
	.q:Temptype="I"
	.q:Temptype="P"
	.q:(AdmType'="")&&(AdmType'[Temptype)
	.s EpisodeID=""
	.f  s EpisodeID=$o(^PAPERdr(PatID,"ADM",Temptype,EpisodeID),-1) q:EpisodeID=""  d  
	..s Pavisit=$p($g(^PAADM(EpisodeID)),"^",20)
	..;q:Pavisit'="A"
	..q:(LgHospID'="")&(##class(web.DHCEMCommonUtil).GetHospitalByAdm(EpisodeID)'=LgHospID) //hxy 2020-06-18
	..s AdmDate=$p($g(^PAADM(EpisodeID)),"^",6)
	..s AdmDateDesc = ##class(web.DHCEMCommonUtil).DateLogicalToHtml(AdmDate)
	..s AdmLocDr = $p($g(^PAADM(EpisodeID)),"^",4)
	..s AdmLocDesc = $p(^CTLOC(AdmLocDr),"^",2)
	..s CTPCPDr = $p($g(^PAADM(EpisodeID)),"^",9)
	..s CareProv=""
	..S:CTPCPDr'="" CareProv = $p(^CTPCP(CTPCPDr,1),"^",2)
	..S CareProv=##class(web.DHCEMCommonUtil).GetTransDesc("User.CTCareProv","CTPCPDesc","",CareProv)
	..s AdmLocDesc=##class(web.DHCEMCommonUtil).GetTransDesc("User.CTLoc","CTLOCDesc","",AdmLocDesc)
	..s ListData = EpisodeID_"^"_AdmLocDesc_"("_CareProv_":"_AdmDateDesc_")"
	..s ^TMP("web.DHCEMInComUseMethod","JsonAdms",Pid,EpisodeID)=ListData
	w "["
	s Num=0
	s EpisodeID=""
	f  s EpisodeID=$o(^TMP("web.DHCEMInComUseMethod","JsonAdms",Pid,EpisodeID),-1) q:EpisodeID=""  d
	.s ListData = ^TMP("web.DHCEMInComUseMethod","JsonAdms",Pid,EpisodeID)
	.s Num=Num+1
	.W $case(Num,1:"",:",") 
	.W ##class(web.DHCAPPJsonCommon).getJsonData("value^text",ListData)
	w "]"
	
	k ^TMP("web.DHCEMInComUseMethod","JsonAdms",Pid)
	q ""
}

/// 获取时间段内病人就诊ID字符串
/// w ##class(web.DHCEMInComUseMethod).GetAdmStrByPatOrLocID(3761354,"","","64562","64662")
ClassMethod GetAdmStrByPatOrLocID(PatID As %String, AdmLoc As %String, Type As %String, StartDate As %String, EndDate As %String)
{
	 n (PatID,AdmLoc,Type ,StartDate,EndDate, DayNum)
	 q:(PatID="")&&(AdmLoc="") ""
	 q:(AdmLoc'="")&&((StartDate="")!(EndDate="")) "通过科室查询时间不能为空！"
	 i Type="" s Type="O^E^I^P"
     s papmiId=PatID
     s admStr="",num=1
	 i AdmLoc="" d
     .f i=1:1:$l(Type,"^") d
     ..s temptype=$p(Type,"^",i)
     ..s EpisodeID=""
     ..f  s EpisodeID=$o(^PAPERdr(papmiId,"ADM",temptype,EpisodeID),-1) q:EpisodeID=""  d  
     ...s pavisit=$p($g(^PAADM(EpisodeID)),"^",20)
     ...;q:(pavisit'="A")
     ...s admDate=$p($g(^PAADM(EpisodeID)),"^",6)
     ...q:(StartDate'="")&(admDate<StartDate)
     ...q:(EndDate'="")&(admDate>EndDate)
     ...s $p(admStr,"^",num)=EpisodeID
     ...s num=num+1
     
     i AdmLoc'="" d
     .f Date=StartDate:1:EndDate d
     ..s AdmDr ="" 
     ..f  s AdmDr = $o(^PAADMi("AdmDateCurr",Date,AdmDr)) q:AdmDr=""  d
     ...q:(AdmLoc'=$p(^PAADM(AdmDr),"^",4))
     ...q:(PatID'="")&&(PatID'=$p(^PAADM(AdmDr),"^",1))   //过滤人
     ...q:(Type'[$p(^PAADM(AdmDr),"^",2))          //过滤就诊类型
     ...s $p(admStr,"^",num)=AdmDr
     ...s num=num+1
     //^PAADMi("AdmDateCurr",{PAADM_AdmDate},{PAADM_RowID})
     
     q admStr
}

/// 检验获取reportID
/// w ##class(web.DHCEMInComUseMethod).GetLisReportID(50090336,179)
ClassMethod GetLisReportID(Ord, Itm)
{
	n (Ord,Itm)
	s OrdStr3 = $g(^OEORD(Ord,"I",Itm,3))
	s LabEpisode=$p(OrdStr3,"^",20)   //检验条码号
	s LabTestSetRow=$p(OrdStr3,"^",35)
	s LabTestSetRow=$tr(LabTestSetRow,$c(0))
	q:LabTestSetRow="" ""   		  //未出报告的
	s VisitnumberReportDR=$lg($g(^dbo.RPVisitNumberTestSetD(LabTestSetRow)),11)
	q VisitnumberReportDR
}

/// 检验获取reportID
/// w ##class(web.DHCEMInComUseMethod).GetLisReportIDs(50090336,179)
ClassMethod GetLisReportIDs(OrdItms)
{
	n (OrdItms)
	s Ret=""
	s Len = $l(OrdItms,",")
	f i=1:1:Len d
	.s OrdItm = $p(OrdItms,",",i)
	.s Ord = +OrdItm
	.s Itm = $p(OrdItm,"||",2)
	.s RepID = ##class(web.DHCEMInComUseMethod).GetLisReportID(Ord,Itm)
	.s:Ret'="" Ret=Ret_","_RepID
	.s:Ret="" Ret=RepID
	q Ret
}

/// 检验获取visitNumID
/// w ##class(web.DHCEMInComUseMethod).GetLisVisitNumID(582,47)
ClassMethod GetLisVisitNumID(Ord, Itm)
{
	n (Ord,Itm)
	s OrdStr3 = $g(^OEORD(Ord,"I",Itm,3))
	s LabEpisode=$p(OrdStr3,"^",20)   //检验条码号
	s VisitNumberDR=$o(^dbo.RPVisitNumberI("IndexVisitNumber",$c(32)_LabEpisode,""))   	
	q VisitNumberDR
}

/// 医嘱主医嘱获取
/// w ##class(web.DHCEMInComUseMethod).GetMainOrdItmID(582,47)
ClassMethod GetMainOrdItmID(OEORIId)
{
	n (OEORIId)
	s Ord = +OEORIId
	s Itm = $p(OEORIId,"||",2)
	q:(Ord="")||(Itm="") ""
	s MainOrdItmId = $p(^OEORD(Ord,"I",Itm,11),"^",39)
	s MainOrdItmId = $case(MainOrdItmId,"":OEORIId,:MainOrdItmId)
	q MainOrdItmId
}

/// 医嘱通过主医嘱获取医嘱名称描述（包含子医嘱）
/// w ##class(web.DHCEMInComUseMethod).GetAllOrdDesc("1720||6")
ClassMethod GetAllOrdDesc(OEORIId)
{
	n (OEORIId)
	s Ord = +OEORIId
	s Itm = $p(OEORIId,"||",2)
	q:(Ord="")||(Itm="") ""
	s Ret=""
	s MainOrdItmId = $p(^OEORD(Ord,"I",Itm,11),"^",39)
	s MainDesc=##class(web.DHCEMInComUseMethod).getArcimDesc(Ord,Itm)
	s ChilDesc=""
	;s Ret="主:"_##class(web.DHCEMInComUseMethod).getArcimDesc(Ord,Itm)
	;s Ret=Ret_" 子医嘱:"
	s Itm=0,Count=0
	f  s Itm = $o(^OEORDi(0,"OEORI",Ord,OEORIId,Itm)) q:Itm=""  d
	.s Count=Count+1
	.
	.s ChilDesc=ChilDesc_$case(Count,1:"",:",")_##class(web.DHCEMInComUseMethod).getArcimDesc(Ord,Itm)
	i ChilDesc="" d
	.s Ret=MainDesc
	e  d
	.s Ret="主:"_MainDesc_" 子医嘱:"_ChilDesc
	q Ret
}

/// 日期格式:"-"
/// 月：串串
/// w ##class(web.DHCEMInComUseMethod).GetDateStrByM("2016-01-01","2017-01-01",1)
ClassMethod GetDateStrByM(StDate, EndDate, Num)
{
	n (StDate,EndDate,Num)
	s:+Num=0 Num=1
	s Date = StDate
	s Year = $p(StDate,"-",1)
	s Month = $p(StDate,"-",2)
	s Day="01"
	s DateStr=""
	
	while($zdh(Date,3)<=$zdh(EndDate,3)){
		s Tmp = Year_"-"_Month
		s:DateStr'="" DateStr=DateStr_"^"_Tmp
		s:DateStr="" DateStr=Tmp
		s Month=Month+Num
		s Year =Year+(Month\13)
		s Month = $case(Month#12,0:12,:Month#12)
		s:$l(Month)=1 Month="0"_Month
		s Date = Year_"-"_Month_"-"_"01"
	}
	q DateStr
}

/// 日期格式:"-"
/// 年：串串
/// w ##class(web.DHCEMInComUseMethod).GetDateStrByY("2016-01-01","2017-01-01",1)
ClassMethod GetDateStrByY(StDate, EndDate, Num)
{
	n (StDate,EndDate,Num)
	s:+Num=0 Num=1
	s Ret=""
	s Year = $p(StDate,"-",1)
	s Date = Year
	while(+Date<=+EndDate){
		s:Ret'="" Ret=Ret_"^"_Date
		s:Ret="" Ret=Date
		s Year=Year+Num
		s Date = Year
		
	}
	q Ret
}

/// 日期格式:"-"
/// 天：串串
/// w ##class(web.DHCEMInComUseMethod).GetDateStrByD("2017-01-01","2017-02-01",1)
ClassMethod GetDateStrByD(StDate, EndDate, Num)
{
	n (StDate,EndDate,Num)
	s:+Num=0 Num=1
	s Ret=""
	s:StDate="" StDate=+$h
	s:EndDate="" EndDate=+$h
	s:StDate'="" StDate=$zdh(StDate,3)
	s:EndDate'="" EndDate=$zdh(EndDate,3)
	s Date = StDate

	while(Date<=EndDate){
		s:Ret'="" Ret=Ret_"^"_$zd(Date,3)
		s:Ret="" Ret=$zd(Date,3)
		s Date = Date+Num
		
	}
	q Ret
}

/// w ##class(web.DHCEMInComUseMethod).GetDateNextM("2017-01-01",3)
ClassMethod GetDateNextM(StDate, Num)
{
	n (StDate,Num)
	s Year = $p(StDate,"-",1)
	s Month = $p(StDate,"-",2)
	s Day=$p(StDate,"-",3)
	s Month = Month+Num
	s Year =Year+(Month\13)
	s Month = $case(Month#12,0:12,:Month#12)
	s:$l(Month)=1 Month="0"_Month
	q Year_"-"_Month_"-"_Day
}

/// 通过登记号查询病人ID
/// w ##class(web.DHCEMInComUseMethod).GetPatIDByRegNo("0000843111")
ClassMethod GetPatIDByRegNo(RegNo)
{
	n (RegNo)
	q:RegNo="" ""
	s patConfig=##class(web.DHCCLCom).GetPatConfig()  //系统配置，登记号长度
	s RegNoLong=$p(patConfig,"^")  
	q:$l(RegNo)>RegNoLong "-13"                        //登记号长度错误
	s nvar=""
	s ln=$L(RegNo)
	s le=RegNoLong+1-ln  							  //11-$L(RegNo)
	s $P(nvar,"0",le)=RegNo
	s nvar=$$ALPHAUP^SSUTIL4(nvar)
	s RegNo=nvar
	s PatID=""
	s PatID=$O(^PAPERi("PAPMI_PatNo",nvar,PatID),-1)
	q PatID
}

/// 获取病人信息
/// w ##class(web.DHCEMInComUseMethod).GetPatInfo("66")
ClassMethod GetPatInfo(EpisodeID)
{
	n (EpisodeID)
	q:+EpisodeID=0 ""
	s PatientID=$p(^PAADM(EpisodeID),"^",1)
	s CardNoID=$o(^DHCCARDi("CF",0,"PAPMIDR",PatientID,""),-1)
	s PatCardNo=""
	s CardNoID=$o(^DHCCARDi("CF",0,"PAPMIDR",PatientID,""),-1)
	i CardNoID'="" d
	.s PatCardNo=$p($g(^DHCCARD("CF",CardNoID)),"^",2) 		 		/// 卡号
	q EpisodeID_"^"_PatCardNo_"^"_PatientID
}

/// Description：获取时间前后时间
/// w ##class(web.DHCEMInComUseMethod).GetDateAfterMin($h,30)
ClassMethod GetDateAfterMin(DateInfo, Min)
{
	n (DateInfo,Min)
	
	q:+Min=0 DateInfo
	s Date = $p(DateInfo,",",1)
	s Time = $p(DateInfo,",",2)
	s IntNum = Min*60
	s Time = Time+IntNum
	s:Time>=86400 Date=Date+1
	s:Time>=86400 Time=Time-86400
	s:Time<0 Date=Date-1
	s:Time<0 Time=Time+86400
	q Date_","_Time
}

/// Description：获取号别队列表状态
/// w ##class(web.DHCEMInComUseMethod).GetAdmQueStatus(113)
ClassMethod GetAdmQueStatus(AdmRowid)
{
	n (AdmRowid)
	Set QueRowId=$o(^User.DHCQueueI("QuePaadmDrIndex",AdmRowid,0))
	Set SeqNo="",QueStatDesc=""
	if QueRowId'="" d
	.Set SeqNo=$lg(^User.DHCQueueD(QueRowId),10)
	.Set QueStatId=$lg(^User.DHCQueueD(QueRowId),14)
	.Set QueStatDesc=$lg(^User.DHCPerStateD(QueStatId),4)
	Quit QueStatDesc
}

/// Description：获取皮试医嘱是否收费
/// Return : 0 未收费   1 已经收费
/// w ##class(web.DHCEMInComUseMethod).GetSkinOrdPayStatus("2||1")
ClassMethod GetSkinOrdPayStatus(OeOrdItmID)
{
	n (OeOrdItmID)
	s PayStatus=0   
	s Ord = +OeOrdItmID
	s Itm = $p(OeOrdItmID,"||",2)
	s ActId=$p($g(^OEORD(Ord,"I",Itm,11)),"^",21)
    s ActCode=""
    i ActId'="" s ActCode=$p(^OEC("ACT",ActId),"^",1)
    s OrdBilled=$p($g(^OEORD(Ord,"I",Itm,3)),"^",5)
    s StayFlag=$p($g(^OEORD(Ord,"I",Itm,"DHC")),"^",17)
    s OecprCode="" 
    s OecprId=$p($g(^OEORD(Ord,"I",Itm,1)),"^",8)
    s:OecprId'="" OecprCode=$p($g(^OECPR(OecprId)),"^")
    s IsPayMoney=""
    s:OrdBilled="P" IsPayMoney=1
    s:(OecprCode="OM")!(OecprCode="OMST")!(OecprCode="OMLSZT")!(OecprCode="OMCQZT") IsPayMoney=1
    
    s PayMode=##class(web.DHCEMCommonUtil).IGetStayPayModeByOrdItm(Ord_"||"_Itm)
    s:(PayMode=1)&&(StayFlag=1) PayStatus = 1    //
    s:(IsPayMoney=1) PayStatus=1
    q PayStatus
}

/// Creator：      huaxiaoying
/// CreatDate：    2016-06-08
/// Description：  下拉列表显示
/// Table：        CT_Loc
/// Return
/// d ##class(web.DHCEMInComUseMethod).JsonLocList("")
ClassMethod JsonLocList(q)
{
	n (q)
	s Count=0
	w "["
	s LocID=0
	f  s LocID=$o(^CTLOC(LocID)) q:LocID=""  d
	.s LocCode = $P(^CTLOC(LocID),"^",1)
	.s LocDesc = $P(^CTLOC(LocID),"^",2)
	.s CTLOCHosDR=$P(^CTLOC(LocID),"^",22)
	.s LocAllDesc = LocCode_LocDesc
	.s Tmp=LocID_"^"_LocDesc
	.q:(q'="")&(LocAllDesc'[q)
	.s Count=Count+1
	.w $case(Count,1:"",:",") 
	.w ##class(web.DHCAPPJsonCommon).getJsonData("value^text",Tmp)
	w "]"
	q ""
}

/// Creator:qqa
/// CreatDate:2019-01-18
/// Descript:获取留观病人第一次临床时间
/// 
/// d ##class(web.DHCEMInComUseMethod).GetFirstInSeatDate("")
ClassMethod GetFirstInSeatDate(Adm)
{
	n (Adm)
	s ObsStDate="",ObsStTime=""
	s AdmTransSub=0 
	f  s AdmTransSub = $o(^PAADM(Adm,"TRANS",AdmTransSub)) q:(AdmTransSub="")!(ObsStDate'="")  d
	.q:$p(^PAADM(Adm,"TRANS",AdmTransSub),"^",8)=""
	.s ObsStDate=$p(^PAADM(Adm,"TRANS",AdmTransSub),"^",1)
	.s ObsStTime = $p(^PAADM(Adm,"TRANS",AdmTransSub),"^",2)
	q ObsStDate_"^"_ObsStTime
}

/// Descript:    当前病人是否留观
/// Creator:     bianshuai
/// CreateDate:  2018-06-20	
/// w ##class(web.DHCEMInComUseMethod).GetPatStayTimes(608)
ClassMethod GetPatStayTimes(EpisodeID As %String) As %String
{
	n (EpisodeID)
	Q:EpisodeID="" ""
	/// 留观日期时间
	s ID=0, StayDate="", StayTime=""
	F  s ID = $o(^DHCADMVisitStatus(0,"PAADM",EpisodeID,ID)) Q:(ID="")||(StayDate'="")  D  //首次留观时间
    .s StatusID=$p(^DHCADMVisitStatus(ID),"^",2) /// 状态ID
    .Q:(StatusID'="5")&(StatusID'="10")
    .s StayDate=$p(^DHCADMVisitStatus(ID),"^",5)  /// 留观/抢救日期
    .s StayTime=$p(^DHCADMVisitStatus(ID),"^",6)  /// 留观/抢救时间
    .
   	Q StayDate_"^"_StayTime
}

/// Descript:    留观时间
/// Creator:     bianshuai
/// CreateDate:  2018-06-20	
/// w ##class(web.DHCEMInComUseMethod).GetObserTime(608)
ClassMethod GetObserTime(EpisodeID As %String) As %String
{
	n (EpisodeID,%session)
	Q:EpisodeID="" ""
	s StayTimes=..GetPatStayTimes(EpisodeID)    /// 留观时间
	s StayDate=$p(StayTimes,"^",1), StayTime=$p(StayTimes,"^",2)
	Q:StayDate="" ""
   	
   	///离院日期时间
   	s dd=##class(web.DHCEMCommonUtil).GetTrans("","天")
	s hh=##class(web.DHCEMCommonUtil).GetTrans("","时")
	s mm=##class(web.DHCEMCommonUtil).GetTrans("","分")
	s LevDate="", LevTime=""
	s ID=$o(^DHCADMVisitStatus(0,"PAADM",EpisodeID,""),-1)
    s StatusID=$p(^DHCADMVisitStatus(ID),"^",2)
    i StatusID=6 D
    .s LevDate=$p(^DHCADMVisitStatus(ID),"^",5) /// 离院日期
    .s LevTime=$p(^DHCADMVisitStatus(ID),"^",6) /// 离院时间
    E  D
    .s LevDate=+$H, LevTime=$p($H,",",2)
    s Hours=((LevDate-StayDate)*24*60+((LevTime-StayTime)\60))
    i (Hours\60)>=24 s ObserTime=(LevDate-StayDate)_dd
    E  D
    .i Hours\60'=0 s ObserTime=Hours\60_hh_$p(Hours#60,".",1)_mm
    .E  s ObserTime=$p(Hours#60,".",1)_mm
    Q ObserTime
}

/// Creator:qqa
/// CreatDate:2019-01-18
/// Descript:获取病人当前留观的ADM
/// 
/// w ##class(web.DHCEMInComUseMethod).GetPatObsingAdm("43")
ClassMethod GetPatObsingAdm(PatientID)
{
	n (PatientID)
	s PatAdm="",ObsingAdm=""
	F  s PatAdm=$O(^PAPERdr(PatientID,"ADM","E",PatAdm),-1) Q:(PatAdm="")||(ObsingAdm'="")  D
	.s:$d(^PAWARDA(0,"RADM",PatAdm)) ObsingAdm=PatAdm
	.s:$d(^PAWARDA(0,"WADM",PatAdm)) ObsingAdm=PatAdm
	.s:$d(^PAWARDA(0,"ADM",PatAdm)) ObsingAdm=PatAdm
	q ObsingAdm
}

/// Descritp:	病区
/// w ##Class(web.DHCEMInComUseMethod).JsonWard(5)
ClassMethod JsonWard(LocID)
{
	n (LocID,%session) 
	s linkSub=0,WardDesc="",count=0
	q:LocID="" "[]"
	w "["
	f  s linkSub=$o(^CTLOC(LocID,"LINK",linkSub)) q:linkSub=""  d
	.s linkLocId=$p(^CTLOC(LocID,"LINK",linkSub),"^",1)
	.q:linkLocId=""
	.s WardDesc=$p(^CTLOC(linkLocId),"^",2)
	.s WardDesc=##class(web.DHCEMCommonUtil).GetTransDesc("User.CTLoc","CTLOCDesc","",WardDesc) //hxy 2022-12-13
	.s count = count+1
	.i count=1 d
	..w ##class(web.DHCAPPJsonCommon).getJsonData("value^text",linkLocId_"^"_WardDesc)
	.e  d
	..w ","_##class(web.DHCAPPJsonCommon).getJsonData("value^text",linkLocId_"^"_WardDesc)
	w "]"
	q ""
}

/// 获取公共时间配置
/// w ##class(web.DHCEMInComUseMethod).GetParams()
ClassMethod GetParams(Params)
{
	n (Params)
	s DateFormate = ##class(web.DHCEMCommonUtil).DateFormat()
	q DateFormate
}

/// Creator: 乔庆澳
/// CreatDate: 2009-05-21
/// Description: 判断用户密码是否正确
/// Table：SS_User,CT_CareProv,CT_CarPrvTp
/// Input：userCode: 用户登陆名 passWord: 用户密码
/// Return：成功返回 0^用户ID 失败返回 密码错误
/// Others:		 w ##class(web.DHCEMInComUseMethod).ConfirmPassWord("1","1")
ClassMethod ConfirmPassWord(userCode As %String, passWord As %String) As %String
{
	s retStr=0
	i userCode="" s userId=%session.Data("LOGON.USERID")
	e  s userId=$O(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(userCode),""))
	q:userId="" "用户有误!"
	s ctpcpId=$p($g(^SSU("SSUSR",userId)),"^",14)
	q:ctpcpId="" "该用户未关联医护人员!"
	
	s active=$p($g(^SSU("SSUSR",userId)),"^",19)
	q:active'="Y" "用户未激活!"
	
	s ctcptId=$P($g(^CTPCP(ctpcpId,1)),"^",4)  ;CTPCP_CarPrvTp_DR
	q:ctcptId="" "该医护人员未定义医护类型!"
    s ctcptInternalType=$P($g(^CT("CPT",ctcptId)),"^",4)  ;CT_CarPrvTp:CTCPT_InternalType
	q:ctcptInternalType="" "医护人员类型定义有误!"

	s oldnamespace=$ZNSPACE
	s datanamespace=$LIST(^websys.ConfigurationD(1),12)
	zn datanamespace
	s pin=$$ENCR^SSUTIL2(passWord)
	i pin="" s retStr="密码错误"
	e  d
	.i pin'=$p($G(^SSU("SSUSR",userId)),"^",3) s retStr="密码错误"
	zn oldnamespace
	i retStr=0 s retStr=0_"^"_userId
	q retStr
}

/// Descript:    急诊分级
/// Creator:     qqa
/// CreateDate:  2019-08-21	
/// w ##class(web.DHCEMInComUseMethod).GetEmPatLev(37)
ClassMethod GetEmPatLev(EpisodeID)
{
	n (EpisodeID)
	s EmPatLevel=""
	s Priority=+$P($g(^PAADM(EpisodeID)),"^",33)   /// 就诊表级别
	s:Priority'=0 EmPatLevel=+$p($g(^CT("ACU",Priority)),"^",1)
	s:EmPatLevel'="" EmPatLevel=EmPatLevel_"级"
	q EmPatLevel
}

/// 获取医嘱状态
ClassMethod GetOeoriStat(oeori As %String) As %String
{
	n (oeori)
	Q:oeori="" ""
	s ItemStatID=$p($g(^OEORD(+oeori,"I",$p(oeori,"||",2),1)),"^",13)
	Q:ItemStatID="" ""
	s ExeStatCode=$p(^OEC("OSTAT",ItemStatID),"^",1)
	Q ExeStatCode
}

/// w ##class(web.DHCEMInComUseMethod).JsonExecFormByGroup(175,71,2)
ClassMethod JsonExecFormByGroup(GroupID, CTLocID, LgHospID = "")
{
	n (GroupID,CTLocID,LgHospID)
	
	s ID=##class(web.DHCEMNurExe).GetExecFormAutID(LgHospID,CTLocID,GroupID)
	
	q:ID="" "[]"
	
	s Num=0
	w "["
	s Types=$p($g(^DHCEMEFSAA(ID)),"^",2)
	s Len=$L(Types,"#")
	for i=1:1:Len d  	
	.s ExecFormID=$p(Types,"#",i)
	.q:ExecFormID=""
	.s ExecFormCode = $p(^DHCEMEFS(ExecFormID),"^",1)
	.s ExecFormName = $p(^DHCEMEFS(ExecFormID),"^",2)	
	.s TmpData=ExecFormCode_"^"_ExecFormName_"^"_ExecFormID
	.s Num=Num+1
	.w $case(Num,1:"",:",") 
	.w ##class(web.DHCEMJsonCommon).getJsonData("value^text^ID",TmpData)
	w "]"
	q ""
}

/// Descript:获取病人基本就诊信息
/// W ##Class(web.DHCEMInComUseMethod).GetPatEssInfo("","2")
ClassMethod GetPatEssInfo(PatientID As %String, EpisodeID As %String) As %String
{
	n (PatientID, EpisodeID,%session)
	q:(PatientID="")&(EpisodeID="") "[]"
	s TrsBed=##class(web.DHCEMCommonUtil).GetTrans("dhcem.obsroomseatnew.csp","床") 
	i PatientID="" s PatientID=$p(^PAADM(EpisodeID),"^",1)
	
	s PatName=$p(^PAPER(PatientID,"ALL"),"^",1)  /// 姓名
	s PatNo=$p(^PAPER(PatientID,"PAT",1),"^",1)  /// 登记号
	s SexId=$p(^PAPER(PatientID,"ALL"),"^",7)    /// 姓别
	s PatSex=""
	i SexId'="" s PatSex=$p(^CT("SEX",SexId),"^",2)
	s ChPatSex=PatSex //hxy 2023-02-13
	s PatBDay=$p(^PAPER(PatientID,"ALL"),"^",6)  /// 出生日期
	i PatBDay'="" s PatBDay=##class(web.DHCAPPCommonUtil).DateLogicalToHtml(PatBDay) //hxy 2017-03-03 $zd(PatBDay,3)
	s PatAge=##class(web.DHCEMCommonUtil).GetPapmiAgeByAdmID(EpisodeID) //hxy 2022-10-14
	s PatDiagDesc=##class(web.DHCEMCommonUtil).GetMRDiagnosDesc(EpisodeID,"","","","Y") /// 诊断
	i $L(PatDiagDesc)>80 s PatDiagDesc=$E(PatDiagDesc,1,50)_"..."
	s PatType=$p(^PAADM(EpisodeID),"^",2) 	           /// 就诊类型
	s EncryptLevelInfo=##class(web.DHCBL.CARD.UCardPaPatMasInfo).GetPatEncryptLevel(PatientID,"")
 	s EncryptLevel=$p(EncryptLevelInfo,"^",1)
 	s PatLevel=$p(EncryptLevelInfo,"^",2)
 	s mradm=$p(^PAADM(EpisodeID),"^",61)          	  /// 就诊类型
	s PatBed=##class(Nur.Interface.OutSide.Patient).getPatientLastBedCode(EpisodeID) /// 床号
	s:(PatBed'[TrsBed)&&(PatBed'="") PatBed=PatBed_TrsBed //"床"
	s BillType=##class(web.DHCDoc.OP.AjaxInterface).GetAdmReason(EpisodeID)   /// 费别
	s AdmReason=""
	s PAADMAdmReasonDR=$p(^PAADM(EpisodeID,1),"^",7)
	s:PAADMAdmReasonDR'="" AdmReason=$p(^PAC("ADMREA",PAADMAdmReasonDR),"^",2)
	s MrNo=##Class(web.DHCEMConsultCom).GetMrNo(EpisodeID) //hxy 2021-06-23 病案号
	
	s PatSex=##class(web.DHCEMCommonUtil).GetTransDesc("User.CTSex","CTSEXDesc","",PatSex)
	s AdmReason=##class(web.DHCEMCommonUtil).GetTransDesc("User.PACAdmReason","READesc","",AdmReason)
	
	s ListData=PatientID_"^"_EpisodeID_"^"_PatNo_"^"_PatName_"^"_$g(PatSex)_"^"_PatAge_"^"_PatBDay_"^"_PatDiagDesc_"^"_PatType_"^"_EncryptLevel_"^"_PatLevel_"^"_mradm_"^"_PatBed_"^"_BillType
	s ListData=ListData_"^"_AdmReason_"^"_MrNo_"^"_ChPatSex
	s ListTitle="PatientID^EpisodeID^PatNo^PatName^PatSex^PatAge^PatBDay^PatDiagDesc^PatType^PatSLv^PatLv^mradm^PatBed^PatBill^AdmReason^MrNo^ChPatSex"
	q ##class(web.DHCEMJsonCommon).getJsonData(ListTitle,ListData)
}

}
