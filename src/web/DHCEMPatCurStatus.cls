Import sqluser

Class web.DHCEMPatCurStatus Extends (%RegisteredObject, %XML.Adaptor, ) [ Not ProcedureBlock ]
{

/// CreatDate: 2016.8.30
/// Creator: lvpeng
/// Description:病人当前状态
/// input: 就诊ID
/// output: 状态信息
/// w ##class(web.DHCEMPatCurStatus).GetPatCurStat("429")
ClassMethod GetPatCurStat(EpisodeID = "") As %String
{
	i EpisodeID="" q ""
	s avsId=$o(^DHCADMVisitStatus(0,"PAADM",EpisodeID,""),-1)
	q:avsId="" ""
	s pvsId=$P(^DHCADMVisitStatus(avsId),"^",2)
   	q $P(^DHCPACVisitStatus(pvsId),"^",1,2)
}

/// Description:病人状态所有
/// table:DHC_PACVisitStatus
/// w ##class(web.DHCEMPatCurStatus).ListPsa()
ClassMethod ListPsa()
{
	s PVSRowId=""
	f  s PVSRowId=$o(^DHCPACVisitStatus(PVSRowId)) q:PVSRowId=""  d
	.q:PVSRowId=0
	.s desc=$p(^DHCPACVisitStatus(PVSRowId),"^",2)
	.w desc_"^"	
	q ""
}

/// CreatDate: 2016.8.30
/// Creator: lvpeng
/// Description:返回病人状态明细信息
/// input: 就诊ID
/// output: 病人来诊时间，分诊时间，下诊断时间，开医嘱时间
/// w ##class(web.DHCEMPatCurStatus).GetPatNewsTotal("458")
ClassMethod GetPatNewsTotal(EpisodeID = "") As %String
{
	b ;EpisodeID
	s Tempstr="",PclCreateDate="",PclCreateTime=""
	i EpisodeID="" q "" 
	s AdmDate=$p(^PAADM(EpisodeID),"^",6)	//来诊日期
	s AdmDate=##class(web.DHCEMCommonUtil).DateLogicalToHtml(AdmDate) //hxy $zd(AdmDate,3)
	s AdmTime=$p(^PAADM(EpisodeID),"^",7)	//来诊时间
	s AdmTime=$zt(AdmTime,1)
	;s PCLRowID=""
	;f  s PCLRowID=$o(^DHCEMPCL(PCLRowID)) q:PCLRowID=""  d
 	;.q:+PCLRowID=0
 	;.s AdmID=$p(^DHCEMPCL(PCLRowID),"^",37)
 	;&sql(select PCL_CreateDate,PCL_CreateTime into PLIST() from DHC_EmPatCheckLev where PCL_Adm_Dr=:EpisodeID)
 	b ;AdmDate
 	s PcaChkid=0
 	f  s PcaChkid=$o(^DHCEMPCA(0,"AdmChkLev",EpisodeID,PcaChkid)) q:PcaChkid=""  d
 	.b ;PcaChkid
 	.i PcaChkid'=""  d
 	..s PclCreateDate=$p(^DHCEMPCL(PcaChkid),"^",4) //分诊日期
 	..s PclCreateDate=##class(web.DHCEMCommonUtil).DateLogicalToHtml(PclCreateDate) //hxy $zd(PclCreateDate,3)
 	..s PclCreateTime=$p(^DHCEMPCL(PcaChkid),"^",5) //分诊时间
 	..s PclCreateTime=$zt(PclCreateTime,1)
 	
 	s MRAMRsub=$o(^MR(EpisodeID,"DIA",""),-1) 
 	s MRdiaDate=$p(^MR(EpisodeID,"DIA",MRAMRsub),"^",7) //下诊断日期
 	s MRdiaDate=##class(web.DHCEMCommonUtil).DateLogicalToHtml(MRdiaDate) //hxy $zd(MRdiaDate,3)
 	s MRdiaTime=$p(^MR(EpisodeID,"DIA",MRAMRsub),"^",8) //下诊断时间
 	s MRdiaTime=$zt(MRdiaTime,1)
 	s OEordId=$o(^OEORD(0,"Adm",EpisodeID,""),-1)
 	s OEordDate=$p(^OEORD(OEordId),"^",2) //开医嘱日期
 	s OEordDate=##class(web.DHCEMCommonUtil).DateLogicalToHtml(OEordDate) //hxy $zd(OEordDate,3)
 	s OEordTime=$p(^OEORD(OEordId),"^",3) //开医嘱时间
 	s OEordTime=$zt(OEordTime,1)
 	
 	s count=1
 	w "["
 	w $case(count,1:"",:",")
 	s jsonObj=##class(web.DHCAPPJsonObject).%New()
 	d jsonObj.Put("AdmDate",AdmDate)
 	d jsonObj.Put("AdmTime",AdmTime)
 	d jsonObj.Put("AdmDesc","病人来医院就诊!")
 	d jsonObj.Put("PclCreateDate",PclCreateDate)
 	d jsonObj.Put("PclCreateTime",PclCreateTime)
 	d jsonObj.Put("PclDesc","病人进行分诊!")
 	d jsonObj.Put("MRdiaDate",MRdiaDate)
 	d jsonObj.Put("MRdiaTime",MRdiaTime)
 	d jsonObj.Put("MRdiaDesc","病人下诊断!")
 	d jsonObj.Put("OEordDate",OEordDate)
 	d jsonObj.Put("OEordTime",OEordTime)
 	d jsonObj.Put("OEordDesc","病人开医嘱!")
 	w jsonObj.Json()
 	s count=count+1
 	w "]"
 	;s Tempstr=AdmDate_"^"_AdmTime_"^"_PclCreateDate_"^"_PclCreateTime_"^"_MRdiaDate_"^"_MRdiaTime_"^"_OEordDate_"^"_OEordTime
	q ""
}

/// CreatDate: 2016.8.30
/// Creator: lvpeng
/// Description:返回病人状态明细信息
/// input: 就诊ID
/// output: 病人各状态变更时间
/// w ##class(web.DHCEMPatCurStatus).FindAdmVisitStat("429")
ClassMethod FindAdmVisitStat(EpisodeID As %String = "") As %String
{
	n (EpisodeID)
	s count=0
	Q:EpisodeID="" "" 
	W "["
	
	i EpisodeID'="" d
	.s Tempstr=""
    .s avsId="-1"
    .f  s avsId=$o(^DHCADMVisitStatus(0,"PAADM",EpisodeID,avsId)) q:avsId=""  d
    ..s patVisitStat=$p(^DHCPACVisitStatus($p($g(^DHCADMVisitStatus(avsId)),"^",2)),"^",2) //病人状态
    ..q:patVisitStat=""	//病人状态
    ..s EpisodeID=$p(^DHCADMVisitStatus(avsId),"^",1)
    ..q:EpisodeID=""
    ..s statDate=##class(web.DHCEMCommonUtil).DateLogicalToHtml($p(^DHCADMVisitStatus(avsId),"^",5)) //hxy $zd($p(^DHCADMVisitStatus(avsId),"^",5),3) //变更状态日期
    ..s statTime=$zt($p(^DHCADMVisitStatus(avsId),"^",6),1) //变更状态时间
    ..s userDesc=$p(^SSU("SSUSR",$p(^DHCADMVisitStatus(avsId),"^",4)),"^",2) //执行人
    ..s Tempstr=patVisitStat_"^"_statDate_"^"_statTime_"^"_userDesc
    ..S count=count+1

	..W $case(count,1:"",:",") 
	..W ##class(web.DHCAPPJsonCommon).getJsonData("patVisitStat^statDate^statTime^userDesc",Tempstr)
    
  	 W "]"
	Q ""
}

/// w ##class(web.DHCEMPatCurStatus).FindAdmstatusTotal("5")
ClassMethod FindAdmstatusTotal(EpisodeID As %String = "") As %String
{

	s Tempstr="",PclCreateDate="",PclCreateTime="",MRdiaDate="",MRdiaTime="",OEordDate="",OEordTime=""
	i EpisodeID="" q "" 
	
	s pid=##Class(web.DHCEMPatCheckLevCom).NewPid()
 	d ..killTmpGlobal(pid) //k掉临时global
 	s i=0
	&SQL(SELECT ID into :RegFree FROM SQLUser.DHCRegistrationFee Where RegfeeAdmDr=:EpisodeID)
	s CreatUser="",AdmDate="",AdmTime=""
	s:RegFree'="" CreatUser=$lg(^User.DHCRegistrationFeeD(RegFree),17)
	s:CreatUser'="" CreatUser = $p(^SSU("SSUSR",CreatUser),"^",2)
	s:RegFree'="" AdmDate=$LIST(^User.DHCRegistrationFeeD(RegFree),15)
 	s:RegFree'="" AdmTime=$LIST(^User.DHCRegistrationFeeD(RegFree),16)
 	;s AdmDate=$LIST(^User.DHCRegistrationFeeD(RegFree),15)
 	;s AdmTime=$LIST(^User.DHCRegistrationFeeD(RegFree),16)

	S CreatUser=##class(web.DHCEMCommonUtil).GetTransDesc("User.SSUser","SSUSRName","",CreatUser)
	S RegText=##class(web.DHCEMCommonUtil).GetTrans("","挂号")
	S PatRegText=##class(web.DHCEMCommonUtil).GetTrans("dhcem.patoverviews.csp","病人挂号")
	i AdmDate'="" d
	.s i = i+1
	.s ^TMP("DHCEM","web.DHCEMPatCurStatus","FindAdmstatusTotal",pid,AdmDate,AdmTime,i)=RegText_"^"_PatRegText_"^"_CreatUser
 	
 	s PclCreateUser="",MRDoc="" //hxy 2022-12-16
 	s PcaChkid=0
 	f  s PcaChkid=$o(^DHCEMPCA(0,"AdmChkLev",EpisodeID,PcaChkid)) q:PcaChkid=""  d
 	.i PcaChkid'=""  d
 	..s PclCreateDate=$p(^DHCEMPCL(PcaChkid),"^",4) //分诊日期 (挂号的病人,保存就诊id)
 	..s PclCreateTime=$p($g(^DHCEMPCL(PcaChkid)),"^",5) //分诊时间
 	..s PclCreateUser=$p($g(^DHCEMPCL(PcaChkid)),"^",3)
 	..s:PclCreateUser'="" PclCreateUser=$p(^SSU("SSUSR",PclCreateUser),"^",2)
	S PclCreateUser=##class(web.DHCEMCommonUtil).GetTransDesc("User.SSUser","SSUSRName","",PclCreateUser)
	S PclText=##class(web.DHCEMCommonUtil).GetTrans("","分诊")
	S PatPclText=##class(web.DHCEMCommonUtil).GetTrans("dhcem.patoverviews.csp","护士分诊")
 	i PclCreateDate'=""  d
 	.s i = i+1
 	.s ^TMP("DHCEM","web.DHCEMPatCurStatus","FindAdmstatusTotal",pid,PclCreateDate,PclCreateTime,i)=PclText_"^"_PatPclText_"^"_PclCreateUser
 	
 	s MRAMRsub=$o(^MR(EpisodeID,"DIA",0))
 	i MRAMRsub'="" d 
 	.s MRdiaDate=$p(^MR(EpisodeID,"DIA",MRAMRsub),"^",7) //下诊断日期
 	.s MRdiaTime=$p($g(^MR(EpisodeID,"DIA",MRAMRsub)),"^",8) //下诊断时间
 	.s MRDoc=$p($g(^MR(EpisodeID,"DIA",MRAMRsub)),"^",4)
 	.s:MRDoc'="" MRDoc=$p(^CTPCP(MRDoc,1),"^",2)
	S MRDoc=##class(web.DHCEMCommonUtil).GetTransDesc("User.CTCareProv","CTPCPDesc","",MRDoc)
	S MRText=##class(web.DHCEMCommonUtil).GetTrans("dhcem.patoverviews.csp","下诊断")
	S DocMRText=##class(web.DHCEMCommonUtil).GetTrans("dhcem.patoverviews.csp","医生下诊断")
 	i MRdiaDate'="" d
 	.s i = i+1
 	.s ^TMP("DHCEM","web.DHCEMPatCurStatus","FindAdmstatusTotal",pid,MRdiaDate,MRdiaTime,i)=MRText_"^"_DocMRText_"^"_MRDoc
 	
 	s OEordId=$o(^OEORD(0,"Adm",EpisodeID,""),-1)   //一次就诊对应一个OEORDER的记录
 	i OEordId'="" d  
 	.s OEordSub="0",TmpLabOrd="",TmpAppOrd="",TmpOrd="",TmpMatOrd=""							//QQA 2017-01-22
 	.f  s OEordSub =$o(^OEORD(OEordId,"I",OEordSub)) q:OEordSub=""  d
 	..Q:(TmpLabOrd="L")&(TmpAppOrd="X")&(TmpMatOrd="M")&(TmpOrd="N")
 	..s OeFlag=##class(web.DHCEMInComUseMethod).GetOeoriStat(OEordId_"||"_OEordSub)
 	..q:(OeFlag="D")||(OeFlag="C")
 	..s arcimdesc = ##class(web.DHCEMOrdInfoVO).getArcimDesc(OEordId,OEordSub)
 	..q:arcimdesc["诊查费"   //统称为诊查费  qqa 
 	..q:arcimdesc["诊疗费"
 	..q:arcimdesc["挂号费"
 	..q:arcimdesc["病历本"   //过滤掉挂号时插入的病历本费
 	..q:arcimdesc["医事服务费"
 	..q:arcimdesc["床位费"
 	..q:'$d(^OEORD(OEordId,"I",OEordSub,1))
 	..s OEordDate=$p(^OEORD(OEordId,"I",OEordSub,3),"^",7)      //开医嘱日期
 	..s OEordTime=$p($g(^OEORD(OEordId,"I",OEordSub,1)),"^",17) //开医嘱时间
 	..s OrdType=..GetOrdType(OEordId_"||"_OEordSub)             /// 获取医嘱分类
 	..s AddUser = $p($g(^OEORD(OEordId,"I",OEordSub,7)),"^",1)
 	..s:AddUser'="" AddUser = $p(^SSU("SSUSR",AddUser),"^",2)
 	..q:$p(^OEORD(OEordId,"I",OEordSub,11),"^",39)
	..S AddUser=##class(web.DHCEMCommonUtil).GetTransDesc("User.SSUser","SSUSRName","",AddUser)
	..S LText=##class(web.DHCEMCommonUtil).GetTrans("dhcem.patoverviews.csp","检验")
	..S OrdLText=##class(web.DHCEMCommonUtil).GetTrans("dhcem.patoverviews.csp","检验医嘱")
	..S XText=##class(web.DHCEMCommonUtil).GetTrans("dhcem.patoverviews.csp","检查")
	..S OrdXText=##class(web.DHCEMCommonUtil).GetTrans("dhcem.patoverviews.csp","检查医嘱")
	..S MText=##class(web.DHCEMCommonUtil).GetTrans("dhcem.patoverviews.csp","材料")
	..S OrdMText=##class(web.DHCEMCommonUtil).GetTrans("dhcem.patoverviews.csp","材料医嘱")
	..S NText=##class(web.DHCEMCommonUtil).GetTrans("dhcem.patoverviews.csp","开医嘱")
	..S OrdNText=##class(web.DHCEMCommonUtil).GetTrans("dhcem.patoverviews.csp","医生开医嘱")
 	..s i = i+1
 	..i (OrdType="L")&(TmpLabOrd="") D
 	...s TmpLabOrd="L"
 	...s ^TMP("DHCEM","web.DHCEMPatCurStatus","FindAdmstatusTotal",pid,OEordDate,OEordTime,i)=LText_"^"_OrdLText_"^"_AddUser
 	..i (OrdType="X")&(TmpAppOrd="") D
 	...s TmpAppOrd="X"
 	...s ^TMP("DHCEM","web.DHCEMPatCurStatus","FindAdmstatusTotal",pid,OEordDate,OEordTime,i)=XText_"^"_OrdXText_"^"_AddUser
 	..i (OrdType="M")&(TmpMatOrd="") D
 	...s TmpMatOrd="M"
 	...s ^TMP("DHCEM","web.DHCEMPatCurStatus","FindAdmstatusTotal",pid,OEordDate,OEordTime,i)=MText_"^"_OrdMText_"^"_AddUser
 	..i (OrdType'="X")&(OrdType'="L")&(OrdType'="M")&(TmpOrd="") d
 	...s TmpOrd="N"
 	...s ^TMP("DHCEM","web.DHCEMPatCurStatus","FindAdmstatusTotal",pid,OEordDate,OEordTime,i)=NText_"^"_OrdNText_"^"_AddUser
 	
 	s ID=""
    f  s ID=$o(^CIS.AN.OperScheduleI("Adm"," "_EpisodeID,ID)) q:ID=""  d
    .s AppDate=$lg(^CIS.AN.OperScheduleD(ID),12)
    .s AppTime=$lg(^CIS.AN.OperScheduleD(ID),13)
 	.s AppCareID=$lg(^CIS.AN.OperScheduleD(ID),17)
 	.s StatusID=$lg(^CIS.AN.OperScheduleD(ID),9)
 	.q:StatusID=9			//取消
 	.s AppUserDesc=""
 	.s:AppCareID'="" AppUserDesc=$p($g(^CTPCP(AppCareID,1)),"^",2)
	.S AppUserDesc=##class(web.DHCEMCommonUtil).GetTransDesc("User.CTCareProv","CTPCPDesc","",AppUserDesc)
	.S AppText=##class(web.DHCEMCommonUtil).GetTrans("","手术")
	.S AppRepText=##class(web.DHCEMCommonUtil).GetTrans("","手术申请")
	.s i = i+1
    .s ^TMP("DHCEM","web.DHCEMPatCurStatus","FindAdmstatusTotal",pid,AppDate,AppTime,i)=AppText_"^"_AppRepText_"^"_AppUserDesc
 	
	s Tempstr=""
    s avsId="-1"
    f  s avsId=$o(^DHCADMVisitStatus(0,"PAADM",EpisodeID,avsId)) q:avsId=""  d
    .s patVisitStat=$p(^DHCPACVisitStatus($p($g(^DHCADMVisitStatus(avsId)),"^",2)),"^",2) //病人状态
    .q:patVisitStat=""	//病人状态
    .s EpisodeID=$p(^DHCADMVisitStatus(avsId),"^",1)
    .q:EpisodeID=""
    .;s statDate=##class(web.DHCEMCommonUtil).DateLogicalToHtml($p(^DHCADMVisitStatus(avsId),"^",5)) //hxy $zd($p(^DHCADMVisitStatus(avsId),"^",5),3) //变更状态日期
    .s statDate = $p(^DHCADMVisitStatus(avsId),"^",8)
    .s statTime=$p($g(^DHCADMVisitStatus(avsId)),"^",9)
    .s notes=$p($g(^DHCADMVisitStatus(avsId)),"^",11)
    .;s statTime=$zt($p(^DHCADMVisitStatus(avsId),"^",6),1) //变更状态时间
    .s userDesc=$p(^SSU("SSUSR",$p(^DHCADMVisitStatus(avsId),"^",4)),"^",2) //执行人
    .;s Tempstr=patVisitStat_"^"_statDate_"^"_statTime_"^"_userDesc
	.S userDesc=##class(web.DHCEMCommonUtil).GetTransDesc("User.SSUser","SSUSRName","",userDesc)
	.S patVisitStat=##class(web.DHCEMCommonUtil).GetTransDesc("User.DHCPACVisitStatus","PVSDesc","",patVisitStat)
    .s patVisitStatDesc=patVisitStat
    .s Text=##class(web.DHCEMCommonUtil).GetTrans("dhcem.patoverviews.csp","召回")
    .s:notes="离院召回" patVisitStatDesc=Text
    .s i = i+1
    .s ^TMP("DHCEM","web.DHCEMPatCurStatus","FindAdmstatusTotal",pid,statDate,statTime,i)=patVisitStat_"^"_patVisitStatDesc_"^"_userDesc
 	
 	b ;data
 	s statDate = "",dataStr=""
 	f  s statDate = $o(^TMP("DHCEM","web.DHCEMPatCurStatus","FindAdmstatusTotal",pid,statDate))  q:statDate=""  d
 	.s detailTime = ""
 	.f  s detailTime = $o(^TMP("DHCEM","web.DHCEMPatCurStatus","FindAdmstatusTotal",pid,statDate,detailTime))  q:detailTime=""  d
 	..s i=0 
 	..f  s i = $o(^TMP("DHCEM","web.DHCEMPatCurStatus","FindAdmstatusTotal",pid,statDate,detailTime,i))  q:i=""  d
 	...s tmpDate=##class(web.DHCEMCommonUtil).DateLogicalToHtml(statDate)
 	...s dataStr = dataStr_tmpDate_"^"_$zt(detailTime,1)_"^"_^TMP("DHCEM","web.DHCEMPatCurStatus","FindAdmstatusTotal",pid,statDate,detailTime,i)_"$$"
 	d ..killTmpGlobal(pid) //k掉临时global
 	Q dataStr
}

/// Descript:  获取医嘱对应分类
ClassMethod GetOrdType(Oeori As %String) As %String
{
	n (Oeori)
	Q:Oeori="" ""
	s OrdType=""
	s OrdName = ##class(web.DHCEMInComUseMethod).GetOECCatByOEORDItmDr(Oeori) //医嘱大类
	s:OrdName["检验" OrdType="L"
	s:OrdName["检查" OrdType="X"
	q OrdType
	
	s ord=$P(Oeori,"||",1), itm=$p(Oeori,"||",2)
	s arcimid =$p($g(^OEORD(ord,"I",itm,1)),"^",2)
	Q ..GetOrdCatType(arcimid)
}

/// Descript:  获取医嘱大类
/// OutPut:    L-检验,X-检查
ClassMethod GetOrdCatType(arcimid As %String) As %String
{
	n (arcimid)
	s itmmastid=$P(arcimid,"||",1), itmmastver=$p(arcimid,"||",2)
	Q:'$d(^ARCIM(itmmastid,itmmastver,1)) ""
	s itemCatDr=$P(^ARCIM(itmmastid,itmmastver,1),"^",10)  //ARC_ItemCat
	s OrderType=$P(^ARC("IC",itemCatDr),"^",7) 
	s serverMaterial=$P($g(^ARCIM(itmmastid,itmmastver,7)),"^",6)	
	i serverMaterial="S" s OrderType="X"
	Q OrderType
}

/// Descript:  取病人检验数量
ClassMethod GetPatLab(EpisodeID As %String) As %String
{
	n (EpisodeID)
	/*
	检验数量
	*/
	s labrset=##Class(LabService.TSResult).GetSomeQtyInfoByAdmNo(EpisodeID)
	Q labrset
	/*
	d SetJsonValue("Lab_1",$P(labrset,"^",1))
	d SetJsonValue("Lab_2",$P(labrset,"^",2))
	d SetJsonValue("Lab_3",$P(labrset,"^",3))
	d SetJsonValue("LabCount",$P(labrset,"^",1)+$P(labrset,"^",2)+$P(labrset,"^",3))
	*/
}

/// Descript:  取病人检查医嘱
/// w ##class(web.DHCEMPatCurStatus).QueryExaReqDetList("7033")
ClassMethod QueryExaReqDetListOLD(EpisodeID As %String) As %String
{
	n (EpisodeID)

    s pid=##Class(web.DHCEMPatCheckLevCom).NewPid()
    d ..killTmpGlobal(pid) //k掉临时global

	s ID="",Num=1,count=0,TmpParentID=""
	f  s ID=$o(^DHCAPREP(0,"ADM",EpisodeID,ID)) Q:ID=""  D
	.s ItemNo=$p(^DHCAPREP(ID),"^",1)           /// 单号
	.s ItemDoc=""
	.s UserID=$p(^DHCAPREP(ID),"^",4)           /// 申请人
	.s ItemLoc=""
    .s itemLocID=$p(^DHCAPREP(ID),"^",5)              /// 接收科室ID
    .i itemLocID'="" s ItemLoc=$p(^CTLOC(itemLocID),"^",2)
    .i ItemLoc["-" s ItemLoc=$p(itemLoc,"-",2)
	.s:UserID'="" ItemDoc=$p(^SSU("SSUSR",UserID),"^",2)
	.s arReqData=$p(^DHCAPREP(ID),"^",2)         /// 报告日期
	.s:arReqData'="" arReqData=##class(web.DHCAPPCommonUtil).DateLogicalToHtml(arReqData) //$zd(arReqData,3)
	.s arReqTime=$p(^DHCAPREP(ID),"^",3)         /// 报告时间
	.s:arReqTime'="" arReqTime=$zt(arReqTime,1)
	.s ItemTime=arReqData_" "_arReqTime
	.s CH=""
	.f  s CH=$o(^DHCAPREP(ID,"AR",CH)) Q:CH=""  D
	..s Oeori=$p(^DHCAPREP(ID,"AR",CH),"^",3)          /// 医嘱ID
	..q:##class(web.DHCEMInComUseMethod).GetOECCatByOEORDItmDr(Oeori)'["检查"
 	..s ItemLabel=##Class(web.DHCEMInterface).GetExaReqItemDesc(Oeori)
 	..s ItemStat=##Class(web.DHCAPPExaReportQuery).GetOeoriStat(Oeori)
	..Q:(ItemStat="D")||(ItemStat="C")   /// 临嘱 住院为撤销、门诊为停止
 	..s StudyNo=""
	..s RegRowid = ##class(web.DHCRisResApptSchudleSystem).getRegRowid(Oeori_"^"_"")
	..s:RegRowid'="" StudyNo=$p(^DHCPACRegInfo(RegRowid),"^",2)         //检查号
	..s ParentID=$s(StudyNo'="":"CR",ItemStat="E":"RE",1:"MA")
	..s TmpParentID=$s(TmpParentID="":ParentID,1:TmpParentID_"^"_ParentID)
	..s Status=""
	..i ParentID["MA" s Status = "申请"
	..i ParentID["RE" s Status = "登记"
	..i ParentID["CR" s Status = "报告"
	..s ListData=ID_"AR"_CH_"^"_Oeori_"^"_Status_"^"_ItemLabel_"^"_ItemLoc_"^"_ItemTime_"^"_ItemDoc_"^"_ItemNo_"^"_ParentID
	..s Num=Num+1
	..s:'$d(^TMP("DHCST","web.DHCEMPatCurStatus","QueryExaReqDetList",pid,ParentID)) ^TMP("DHCST","web.DHCEMPatCurStatus","QueryExaReqDetList",pid,ParentID)="MA^^申请^^^^^^^"
	..s ^TMP("DHCST","web.DHCEMPatCurStatus","QueryExaReqDetList",pid,ParentID,Num)=ListData
	
	;i TmpParentID["MA" s ^TMP("DHCST","web.DHCEMPatCurStatus","QueryExaReqDetList",pid,1)="MA^^申请^^^^^^^"
	;i TmpParentID["RE" s ^TMP("DHCST","web.DHCEMPatCurStatus","QueryExaReqDetList",pid,2)="RE^^登记^^^^^^^"
    ;i TmpParentID["CR" s ^TMP("DHCST","web.DHCEMPatCurStatus","QueryExaReqDetList",pid,3)="CR^^报告^^^^^^^"
    
	i Num=0 w ##class(web.DHCAPPJsonCommon).getJsonEmptySign(Num) //输出json结尾符
	Q:Num=0 ""
	
	///转换数据为Json格式
	S ListTitle="^^^^^^^^_parentId"
	;w ##class(web.DHCAPPJsonCommon).getJsonStartSign(Num) //输出json前缀串
	s DymArrForRs = []
	b ;data
	s ParentID=""
	f  s ParentID=$o(^TMP("DHCST","web.DHCEMPatCurStatus","QueryExaReqDetList",pid,ParentID)) q:ParentID=""  d
	.s DymObj={},DymArr=[],DymArrAcc=0
	.s DataString = ^TMP("DHCST","web.DHCEMPatCurStatus","QueryExaReqDetList",pid,ParentID)
	.s DymObj.Index = $p(DataString,"^",1)
	.s DymObj.Oeori = $p(DataString,"^",2)
	.s DymObj.Title = $p(DataString,"^",3)
	.s DymObj.ItemLabel = $p(DataString,"^",4)
	.s DymObj.ItemLoc = $p(DataString,"^",5)
	.s DymObj.ItemTime = $p(DataString,"^",6)
	.s DymObj.ItemDoc = $p(DataString,"^",7)
	.s DymObj.ItemNo = $p(DataString,"^",8)
	.s index=0
	.f  s index=$o(^TMP("DHCST","web.DHCEMPatCurStatus","QueryExaReqDetList",pid,ParentID,index)) q:index=""  d
	..s DymChildObj={}
	..s DataString = ^TMP("DHCST","web.DHCEMPatCurStatus","QueryExaReqDetList",pid,ParentID,index)
	..s DymChildObj.Index = $p(DataString,"^",1)
	..s DymChildObj.Oeori = $p(DataString,"^",2)
	..s DymChildObj.Title = $p(DataString,"^",3)
	..s DymChildObj.ItemLabel = $p(DataString,"^",4)
	..s DymChildObj.ItemLoc = $p(DataString,"^",5)
	..s DymChildObj.ItemTime = $p(DataString,"^",6)
	..s DymChildObj.ItemDoc = $p(DataString,"^",7)
	..s DymChildObj.ItemNo = $p(DataString,"^",8)
	..d DymArr.%Set($i(DymArrAcc)-1,DymChildObj)
	.s DymObj.children=DymArr
	.d DymArrForRs.%Set($i(DymArrForRsAcc)-1,DymObj)
	w DymArrForRs.%ToJSON()
	d ..killTmpGlobal(pid) //k掉临时global
	q ""
}

/// Descript:  取病人检查医嘱
/// w ##class(web.DHCEMPatCurStatus).QueryExaReqDetList("7033")
ClassMethod QueryExaReqDetList(EpisodeID As %String, LgUserCode As %String = "") As %String
{
	n (EpisodeID, LgUserCode,%session)

	k TmpPatExaArr
    s pid=##Class(web.DHCEMPatCheckLevCom).NewPid()
    d ..killTmpGlobal(pid) //k掉临时global
    
    /// 检查申请列表
	d ##Class(web.DHCAPPPisInterface).GetExaReqHis(EpisodeID, LgUserCode, .TmpPatExaArr)
	
	/// 病理申请列表
	d ##Class(web.DHCAPPPisInterface).GetPisReqHis(EpisodeID, LgUserCode, .TmpPatExaArr)
	
    s index="",Num=0
	F  s index=$o(TmpPatExaArr(index))  Q:index=""  D
	.s ListData=$g(TmpPatExaArr(index))
	.Q:ListData=""
	.s ParentID=$p(ListData,"^",1)   /// 状态值
	.s $p(ListData,"^",1)=""
	.s Num=Num+1
	.i '$d(^TMP("DHCST","web.DHCEMPatCurStatus","QueryExaReqDetList",pid,ParentID)) D
	..s ^TMP("DHCST","web.DHCEMPatCurStatus","QueryExaReqDetList",pid,ParentID)=ParentID
	.s ^TMP("DHCST","web.DHCEMPatCurStatus","QueryExaReqDetList",pid,ParentID,Num)=ListData
	.

	///转换数据为Json格式
	s DymArrForRs = []
	b ;data
	s ParentID=""
	f  s ParentID=$o(^TMP("DHCST","web.DHCEMPatCurStatus","QueryExaReqDetList",pid,ParentID)) q:ParentID=""  d
	.s DymObj={},DymArr=[],DymArrAcc=0
	.s DataString = ^TMP("DHCST","web.DHCEMPatCurStatus","QueryExaReqDetList",pid,ParentID)
	.s DymOeori=$p(DataString,"^",2)
	.s DymObj.Oeori = DymOeori
	.s DymTitle=$p(DataString,"^",1)
	.s DymTitle=##class(web.DHCEMCommonUtil).GetTrans("",DymTitle)
	.s DymObj.Title = DymTitle
	.s DymItemLabel = $p(DataString,"^",3)
	.s DymItemLabel=##class(web.DHCEMCommonUtil).GetTransDesc("User.ARCItmMast","ARCIMDesc","",DymItemLabel)
	.s DymObj.ItemLabel = DymItemLabel  ;itmArcDesc
	.;s DymItemSpec = $p(DataString,"^",4)
	.s DymItem=##Class(web.DHCAPPInterface).GetExaReqItemDesc(DymOeori)  ;ItemLabel
	.s DymItemSpec=$p(DymItem,DymItemLabel,2)
	.s DymObj.ItemSpec = DymItemSpec
	.s DymObj.ItemTime = $p(DataString,"^",5)
	.s DymObj.Index = ParentID
	.s DymItemLoc = $p(DataString,"^",12)
	.s DymItemLoc=##class(web.DHCEMCommonUtil).GetTransDesc("User.CTLoc","CTLOCDesc","",DymItemLoc)
	.s DymObj.ItemLoc =DymItemLoc
	.s index=0
	.f  s index=$o(^TMP("DHCST","web.DHCEMPatCurStatus","QueryExaReqDetList",pid,ParentID,index)) q:index=""  d
	..s DymChildObj={}
	..s DataString = ^TMP("DHCST","web.DHCEMPatCurStatus","QueryExaReqDetList",pid,ParentID,index)
	..s DymChildOeori=$p(DataString,"^",2)
	..s DymChildObj.Oeori = DymChildOeori
	..s DymChildTitle=$p(DataString,"^",1)
	..s DymChildTitle=##class(web.DHCEMCommonUtil).GetTrans("",DymChildTitle)
	..s DymChildObj.Title = DymChildTitle
	..s DymChildItemLabel = $p(DataString,"^",3)
	..s DymChildItemLabel=##class(web.DHCEMCommonUtil).GetTransDesc("User.ARCItmMast","ARCIMDesc","",DymChildItemLabel)
	..s DymChildObj.ItemLabel =DymChildItemLabel  ;itmArcDesc
	..;s DymChildItemSpec=$p(DataString,"^",4)
	..s DymChildItem=##Class(web.DHCAPPInterface).GetExaReqItemDesc(DymChildOeori)  ;ItemLabel
	..s DymChildItemSpec=$p(DymChildItem,DymChildItemLabel,2)
	..s DymChildObj.ItemSpec = DymChildItemSpec
	..s DymChildObj.ItemTime = $p(DataString,"^",5)
	..s DymChildObj.Index = index
	..s DymChildItemLoc = $p(DataString,"^",12)
	..s DymChildItemLoc=##class(web.DHCEMCommonUtil).GetTransDesc("User.CTLoc","CTLOCDesc","",DymChildItemLoc)
	..s DymChildObj.ItemLoc = DymChildItemLoc
	..d DymArr.%Set($i(DymArrAcc)-1,DymChildObj)
	.s DymObj.children=DymArr
	.d DymArrForRs.%Set($i(DymArrForRsAcc)-1,DymObj)
	w DymArrForRs.%ToJSON()
	d ..killTmpGlobal(pid) //k掉临时global
	Q ""
}

/// Descript:  取病人检查医嘱
/// w ##class(web.DHCEMPatCurStatus).QueryExaReqDetListNum("355","jzys01")
ClassMethod QueryExaReqDetListNum(EpisodeID As %String, LgUserCode As %String = "") As %String
{
	n (EpisodeID, LgUserCode)

	k TmpPatExaArr
    s pid=##Class(web.DHCEMPatCheckLevCom).NewPid()
    d ..killTmpGlobal(pid) //k掉临时global
    
    /// 检查申请列表
	d ##Class(web.DHCAPPPisInterface).GetExaReqHis(EpisodeID, LgUserCode, .TmpPatExaArr)
	
	/// 病理申请列表
	d ##Class(web.DHCAPPPisInterface).GetPisReqHis(EpisodeID, LgUserCode, .TmpPatExaArr)
	
    s index="",Num=0
	F  s index=$o(TmpPatExaArr(index))  Q:index=""  D
	.s ListData=$g(TmpPatExaArr(index))
	.Q:ListData=""
	.s ParentID=$p(ListData,"^",1)   /// 状态值
	.s $p(ListData,"^",1)=""
	.s Num=Num+1
	.i '$d(^TMP("DHCST","web.DHCEMPatCurStatus","QueryExaReqDetList",pid,ParentID)) D
	..s ^TMP("DHCST","web.DHCEMPatCurStatus","QueryExaReqDetList",pid,ParentID)=ParentID
	.s ^TMP("DHCST","web.DHCEMPatCurStatus","QueryExaReqDetList",pid,ParentID,Num)=ListData
	.
	
	s ItmNum1=0,ItmNum2=0,ItmNum3=0
	s ParentID=""
	f  s ParentID=$o(^TMP("DHCST","web.DHCEMPatCurStatus","QueryExaReqDetList",pid,ParentID)) q:ParentID=""  d
	.s DataString = ^TMP("DHCST","web.DHCEMPatCurStatus","QueryExaReqDetList",pid,ParentID)
	.s Title = $p(DataString,"^",1)
	.s index=0
	.f  s index=$o(^TMP("DHCST","web.DHCEMPatCurStatus","QueryExaReqDetList",pid,ParentID,index)) q:index=""  d
	..s:Title="申请" ItmNum1=ItmNum1+1
	..s:Title="登记" ItmNum2=ItmNum2+1
	..s:Title="报告" ItmNum3=ItmNum3+1
	
	d ..killTmpGlobal(pid) //k掉临时global
	q ItmNum1_"^"_ItmNum2_"^"_ItmNum3
}

/// Descript:	取检查医嘱分类个数
/// w ##class(web.DHCEMPatCurStatus).GetExaReqOeStatNum("162")
ClassMethod GetExaReqOeStatNum(EpisodeID) As %String
{
	n (EpisodeID)

	/// 检查申请
	s ID="",ItmNum1=0,ItmNum2=0,ItmNum3=0
	f  s ID=$o(^DHCAPREP(0,"ADM",EpisodeID,ID)) Q:ID=""  D
	.s CH=""
	.f  s CH=$o(^DHCAPREP(ID,"AR",CH)) Q:CH=""  D
	..Q:$p(^DHCAPREP(ID,"AR",CH),"^",7)'=""
	..s Oeori=$p(^DHCAPREP(ID,"AR",CH),"^",3)          /// 医嘱ID
	..q:Oeori=""
	..s OrdBigCat = ##class(web.DHCEMInComUseMethod).GetOECCatByOEORDItmDr(Oeori)
	..q:OrdBigCat["检验"
	..s ItemStat=##Class(web.DHCAPPExaReportQuery).GetOeoriStat(Oeori)
	..Q:(ItemStat="D")||(ItemStat="C")   /// 临嘱 住院为撤销、门诊为停止
	..s StudyNo=""
	..s RetFlag=##Class(web.DHCEMInterface).GetOeoriRetFlag(ID,CH)
	..s:RetFlag="IM" ItmNum3=ItmNum3+1
	..Q:RetFlag="IM"
	..i ItemStat="E" s ItmNum2=ItmNum2+1
	..E  s ItmNum1=ItmNum1+1
	.
	
	/// 病理申请
	s PisID=""
    F  s PisID=$o(^DHCAPPPM(0,"Adm",EpisodeID,PisID)) Q:PisID=""  D
	.s PisStatus=$p(^DHCAPPPM(PisID),"^",9)	   /// 申请状态
	.Q:PisStatus'="Y"
	.s ID=+$p(^DHCAPPPM(PisID),"^",21)         /// 结果状态ID
	.s ResStats=$p($g(^DHCAPPTST(+ID)),"^",1)  /// 状态代码
	.i ResStats="REG" s ItmNum2=ItmNum2+1
	.i ResStats="RP" s ItmNum3=ItmNum3+1
	.Q:ID'=0
	.i PisStatus="Y" s ItmNum1=ItmNum1+1

	Q ItmNum1_"^"_ItmNum2_"^"_ItmNum3
}

/// Descript:k掉临时global
ClassMethod killTmpGlobal(pid) As %String
{
	N (pid)
	K ^TMP("DHCEM","web.DHCEMPatCurStatus","FindAdmstatusTotal",pid)
	k ^TMP("DHCST","web.DHCEMPatCurStatus","QueryExaReqDetList",pid)
}

}
