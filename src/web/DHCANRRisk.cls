Import SQLUSER

Class web.DHCANRRisk Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// DHC_ANR_Risk
/// w ##class(web.DHCANRRisk).SaveANRRisk("3881756","3879","40","2","一级","1","B","I","")
ClassMethod SaveANRRisk(EpisodeID, UserId, CtlocId, OperDr, OpDifCode, ASACode, OpType, AnrStatus, anrrID) As %String
{
	q:EpisodeID="" "-1"
	s anrrDr=""	
	/*i anrrID="" d
	.s anrrRowId=$o(^DHCANRRisk(0,"Adm",EpisodeID,""),-1)
	.i anrrRowId'="" d
	..s opaDr=$li(^DHCANRRisk(anrrRowId),2)
	..s ctlocDr=$li(^DHCANRRisk(anrrRowId),3)
	..i (opaDr="")&(ctlocDr=CtlocId) s anrrDr=anrrRowId*/
	i anrrID'="" s anrrDr=anrrID
	s PatInfo=##class(web.DHCANOPCom).PatInfo("^"_EpisodeID,"")
	s Age=$p(PatInfo,"^",8)
	s OperDiffcultyDr=##class(web.DHCANRRisk).GetCategIdByCode(OpDifCode)
	s ASAId=##class(web.DHCANRRisk).GetASAIdByCode(ASACode)
	;s ^Liyinuo("ASAId")=ASAId ;===test===
	s AnrcrcDr=##class(web.DHCANRRisk).GetAnrcrcId(ASAId,OperDiffcultyDr,CtlocId)
	;s ^Liyinuo("AnrcrcDr")=AnrcrcDr ;===test===
    ;w AnrcrcDr_"$"_OpType_"$"_CtlocId_"$"_+Age
	s AnrcmcDr=##class(web.DHCANRRisk).GetAnrcmcId(AnrcrcDr,OpType,CtlocId,+Age)
	;s ^Liyinuo("AnrcmcDr")=AnrcmcDr
	;w AnrcmcDr_"$"
	;s obj=##class(User.DHCANRRisk).%New()
	i ##class(User.DHCANRRisk).%ExistsId(anrrDr) d
	.s obj=##class(User.DHCANRRisk).%OpenId(anrrDr)
	e  s obj=##class(User.DHCANRRisk).%New()
	
	s obj.ANRRAdmDr=EpisodeID
	s obj.ANRRAnrcrcDr=##class(User.DHCANRCRiskClass).%OpenId(AnrcrcDr)
	s obj.ANRRAnrcmcDr=##class(User.DHCANRCManageClass).%OpenId(AnrcmcDr)
	s obj.ANRRAsaDr=ASAId
	s obj.ANRROpType=OpType
	//s obj.ANRRAuditCtcpDr=""
	//s obj.ANRRAuditDate=""
	//s obj.ANRRAuditTime=""
	//s obj.ANRRCheckCtcpDr=""
	//s obj.ANRRCheckDate=""
	//s obj.ANRRCheckTime=""
	s obj.ANRRCreateCtcpDr=UserId
	s obj.ANRRCreateDate=+$h
	s obj.ANRRCreateTime=$p($h,",",2)
	s obj.ANRRCtlocDr=CtlocId
	s obj.ANRRDate=+$h
	//s obj.ANRROpaDr=""
	s obj.ANRROperationDr=OperDr
	s obj.ANRROperDiffcultyDr=OperDiffcultyDr
	s obj.ANRRStatus=AnrStatus
	s obj.ANRRTime=$p($h,",",2)
	//s obj.ChildDHCANRCheck=""
	//s obj.ChildDHCANROperComplication=""
	
	s SaveStatus=obj.%Save()
	q:(+SaveStatus=0) "-1^数据添加失败！"
	s ID=obj.%Id()
	d obj.%Close()
	q ID_"^"_AnrcmcDr_"^"_$li(^DHCANRC("ManageClass",AnrcmcDr),1)
}

ClassMethod LoadANRRisk(EpisodeID, CtlocId, OpaId, anrrID) As %String
{
	q:EpisodeID="" "-1"
	q:CtlocId="" "-2"
	s anrrDr=""
	i OpaId'="" d  //已开手术申请
	.s anrrRowId="" f  s anrrRowId=$o(^DHCANRRisk(0,"Adm",EpisodeID,anrrRowId)) q:anrrRowId=""  d
	..q:$li(^DHCANRRisk(anrrRowId),3)'=CtlocId
	..q:OpaId'=$li(^DHCANRRisk(anrrRowId),2)
	..s anrrDr=anrrRowId
	e  i anrrID'="" d
	.s anrrDr=anrrID
	e  d  //新建评估时,打开此病人本次住院最后一次填写记录作为参考
	.s anrrRowId=$o(^DHCANRRisk(0,"Adm",EpisodeID,""),-1)
	.q:anrrRowId=""
	.q:$li(^DHCANRRisk(anrrRowId),3)'=CtlocId
	.s anrrDr=anrrRowId
	
	q:anrrDr="" ""
	
	;s ANRStat=$li(^DHCANRRisk(anrrDr),6)
	s LocId=$li(^DHCANRRisk(anrrDr),3)
	i LocId'="" s Locdes=$p($P($g(^CTLOC(LocId)),"^",2),"-",2)
	e  s Locdes=""
	s ANCdate=$li(^DHCANRRisk(anrrDr),13)
	i ANCdate'="" s ANCdate=$zd(ANCdate,3)
    s ANCtime=$li(^DHCANRRisk(anrrDr),14)
    i ANCtime'="" s ANCtime=$zt(ANCtime,2)
	s Operation=$li(^DHCANRRisk(anrrDr),7)
	i Operation'="" s OperationDr=$p(Operation,"|",1)
	e  s OperationDr=""
	i OperationDr=""  s OperationDesc=$p(Operation,"|",2)
	e  s OperationDesc=$p($g(^ORC("OPER",OperationDr)),"^",2)	
	s OperDiffDr=$li(^DHCANRRisk(anrrDr),8)
	i OperDiffDr'="" s OperDiffDesc=$p($g(^ORC("CATEG",OperDiffDr)),"^",2)
	e  s OperDiffDesc=""
	s AsaDr=$li(^DHCANRRisk(anrrDr),9)
	i AsaDr'="" s AsaDesc=$p($g(^ORC("ASA",AsaDr)),"^",2)
	e  s AsaDesc=""
	s AnrcrcDr=$li(^DHCANRRisk(anrrDr),10)	
	i AnrcrcDr'="" s AnrcrcDesc=$li(^DHCANRC("RiskClass",AnrcrcDr),2)
	e  s AnrcrcDesc=""
	s AnrcmcDr=$li(^DHCANRRisk(anrrDr),11)
	i AnrcmcDr'="" s AnrmcDesc=$li(^DHCANRC("ManageClass",AnrcmcDr),2)
	e  s AnrmcDesc=""
	s CrtDocDr=$li(^DHCANRRisk(anrrDr),12)
	s ctcpId=$p($g(^SSU("SSUSR",CrtDocDr)),"^",14)
	i CrtDocDr'="" s CrtDocDrDesc=##class(web.DHCANOPCom).GetNameById(ctcpId)
	e  s CrtDocDrDesc=""
	s OpType=$li(^DHCANRRisk(anrrDr),21)
	i OpType="B" s OpTypeDesc="择期"
	i OpType="R" s OpTypeDesc="限期"
	i OpType="E" s OpTypeDesc="急诊"
	s AnrStatus=$li(^DHCANRRisk(anrrDr),6)
	q anrrDr_$c(1)_OperationDr_"^"_OperationDesc_$c(1)_OperDiffDr_"^"_OperDiffDesc_$c(1)_AsaDr_"^"_AsaDesc_$c(1)_AnrcrcDr_"^"_AnrcrcDesc_$c(1)_AnrcmcDr_"^"_AnrmcDesc_$c(1)_OpType_"^"_OpTypeDesc_$c(1)_AnrStatus_$c(1)_ANCdate_"^"_ANCtime_$c(1)_LocId_"^"_Locdes_$c(1)_CrtDocDr_"^"_CrtDocDrDesc
}

/// w ##class(web.DHCANRRisk).GetAnrcrcId("1",5,6)
ClassMethod GetAnrcrcId(ASAId, OperDiffcultyDr, CtlocId) As %String
{
	q:ASAId="" "-1"
	q:OperDiffcultyDr="" "-2"
	q:CtlocId="" "-3"
	s AnrcrcId=""
	&sql(select ANRCRA_Anrcrc_Dr into :AnrcrcId from DHC_ANRC_RiskAssess where ANRCRA_OperDiffculty_Dr=:OperDiffcultyDr and ANRCRA_ASA_Dr=:ASAId and ANRCRA_Ctloc_Dr=:CtlocId)
	i AnrcrcId="" d //没有维护分级模板，默认血管外科
	.&sql(select ANRCRA_Anrcrc_Dr into :AnrcrcId from DHC_ANRC_RiskAssess where ANRCRA_OperDiffculty_Dr=:OperDiffcultyDr and ANRCRA_ASA_Dr=:ASAId and ANRCRA_Ctloc_Dr="40")
	q AnrcrcId
}

/// w ##class(web.DHCANRRisk).GetAnrcmcId("4","B",40,60)
/// 年龄不同AnrcmcId不同
ClassMethod GetAnrcmcId(AnrcrcId, OpType, CtlocId, Age) As %String
{
	q:AnrcrcId="" "-1"
	q:OpType="" "-2"
	q:CtlocId="" "-3"
	q:Age="" "-4"
	s retId="",AnrcmcDr="",MaxAge=""
	&sql(select ANRCMA_Anrcmc_Dr,ANRCMA_MaxAge_Dr into :AnrcmcDr,:MaxAge from DHC_ANRC_ManageAssess where ANRCMA_Anrcrc_Dr=:AnrcrcId and ANRCMA_SourceType=:OpType and ANRCMA_Ctloc_Dr=:CtlocId)
	i AnrcmcDr="" d  ////没有维护分级模板，默认血管外科
	.s CtlocId="40"
	.&sql(select ANRCMA_Anrcmc_Dr,ANRCMA_MaxAge_Dr into :AnrcmcDr,:MaxAge from DHC_ANRC_ManageAssess where ANRCMA_Anrcrc_Dr=:AnrcrcId and ANRCMA_SourceType=:OpType and ANRCMA_Ctloc_Dr=:CtlocId)
	s AnrmcCode=$li(^DHCANRC("ManageClass",AnrcmcDr),1)
	i Age<=MaxAge s retId=AnrcmcDr
	i Age>MaxAge d
	.i AnrmcCode="A" s AnrmcCode="B"
	.e  i AnrmcCode="B" s AnrmcCode="C"
	.;e  i AnrmcCode="C" s AnrmcCode="D"
	.;e  i AnrmcCode="D" s AnrmcCode="E"
	.;e  i AnrmcCode="JA" s AnrmcCode="JB"
	.;e  i AnrmcCode="JB" s AnrmcCode="JC"
	s AnrcmcId=""
	f  s AnrcmcId=$o(^DHCANRC("ManageClass",0,"Ctloc",CtlocId,AnrcmcId)) q:AnrcmcId=""  d
	.q:AnrmcCode'=$li(^DHCANRC("ManageClass",AnrcmcId),1)
	.s retId=AnrcmcId
	q retId
}

ClassMethod GetCategIdByCode(CategCode) As %String
{
	q:CategCode="" ""
    &sql(select CATEG_RowId into :CategId from ORC_OperationCategory where CATEG_Code=:CategCode)
    q CategId
}

ClassMethod GetASAIdByCode(ASACode) As %String
{
	q:ASACode="" ""
	&sql(select %ID into:ASAId from ORC_ASA_ClassPhActiv where ORASA_Code=:ASACode)
	q ASAId
}

/// w ##class(web.DHCANRRisk).CheckApproval("365",2)
ClassMethod CheckApproval(userId, AnrmcId) As %String
{
	q:userId="" "-1"
	q:AnrmcId="" "-2"
	s retStr=-1
	s ctpcpDr=$p(^SSU("SSUSR",userId),"^",14)
	s carPrvTpDR=$p(^CTPCP(ctpcpDr,1),"^",4)
	
	s AuditCarPrvTpDrStr=$li(^DHCANRC("ManageClass",AnrmcId,1),1)
	i ("^"_AuditCarPrvTpDrStr_"^")[("^"_carPrvTpDR_"^") s retStr=0
	e  s retStr=-1
	q retStr
}

/// w ##class(web.DHCANRRisk).SaveANRCheck("3","Blood","0","0","")
ClassMethod SaveANRCheck(Parref, ItemCode, Checked, Result, Note) As %String
{
	q:Parref="" "-1"
	q:ItemCode="" "-2"
	;s ^tempmfc(ItemCode)=Parref_"^"_ItemCode_"^"_ Checked_"^"_ Result_"^"_ Note
	s ItemRowId=""
	s RowId=0
	f  s RowId=$o(^DHCANRC("CheckItem",RowId)) q:RowId=""  d
	.s Code=$li(^DHCANRC("CheckItem",RowId),1)
	.q:Code'=ItemCode
	.s ItemRowId=RowId
	q:ItemRowId="" "-3"	
	i Checked=0 s Checked="N"
	e  s Checked="Y"	
	//^DHCANRRisk(,"C",)
	s anrId=""
	&sql(select ANR_RowId into anrId from DHC_ANR_Check where ANRC_Anrcci_Dr=:ItemRowId and ANRC_Parref=:Parref)
	i ##class(User.DHCANRCheck).%ExistsId(anrId) d
	.s obj=##class(User.DHCANRCheck).%OpenId(anrId)
	e  s obj=##class(User.DHCANRCheck).%New()
	
	s obj.ANRCParref=##class(User.DHCANRRisk).%OpenId(Parref)
	s obj.ANRCAnrcciDr=##class(User.DHCANRCCheckItem).%OpenId(ItemRowId)
	s obj.ANRCChecked=Checked
	s obj.ANRCResult=Result
	s obj.ANRCNote=Note
	s SaveStatus=obj.%Save()
	q:(+SaveStatus=0) "-1||数据添加失败！"
	s ID=obj.%Id()
	d obj.%Close()
	q ID
}

/// w ##class(web.DHCANRRisk).LoadANRCheck("B^C","40")
/// 说明：获取界面模板显示功能
ClassMethod LoadANRCheck(ANRCAnrcLevel, Loc) As %String
{
	s retstr=""
	k ^TMPANRRisk("CheckItem",$j) 
	s RowId=0
	f  s RowId=$o(^DHCANRC("CheckItem",RowId)) q:RowId=""  d
	.;q:'($g(^DHCANRC("CheckItem",RowId)))
	.s DefAnrcmcDesc="",DefAnrcmcDr=""
	.s Code=$li(^DHCANRC("CheckItem",RowId),1)
	.s Desc=$li(^DHCANRC("CheckItem",RowId),2)
	.s anrcmcDr=$li(^DHCANRC("CheckItem",RowId),3)	
	.;q:(ANRCAnrcLevel'="")&&(("^"_ANRCAnrcLevel_"^")'[("^"_DefAnrcmcDesc_"^"))
	.;q:(ANRCAnrcLevel'="")&&(DefAnrcmcDesc'=ANRCAnrcLevel)
	.s judge=0
	.s anrclcRowId=0  f  s anrclcRowId=$o(^DHCANRC("LocCheck",anrclcRowId)) q:anrclcRowId=""  d	
	..s anrcciDr=$li(^DHCANRC("LocCheck",anrclcRowId),2)
	..q:RowId'=anrcciDr		
	..s ctlocDr=$li(^DHCANRC("LocCheck",anrclcRowId),3)
	..q:(Loc'=ctlocDr)
	..s DefAnrcmcDr=$li(^DHCANRC("LocCheck",anrclcRowId),1)
	..i DefAnrcmcDr'="" s AnrcmcDesc=$li(^DHCANRC("ManageClass",DefAnrcmcDr),2)
	..e  s AnrcmcDesc=""
	..q:(ANRCAnrcLevel'="")&&(("^"_ANRCAnrcLevel_"^")'[("^"_AnrcmcDesc_"^"))
	..s DefAnrcmcDesc=AnrcmcDesc
	..;s theSame="31"  //"40^46"  //包含科室调用血管外科显示模板
	..;i ("^"_theSame_"^")'[("^"_Loc_"^") s Loc=40
	..;i (DefAnrcmcDr=anrcmcDr)&&(Loc'=ctlocDr)&&(RowId=anrcciDr) s judge=1
	..;i (Loc=ctlocDr)&&(RowId=anrcciDr) s judge=0
	.q:DefAnrcmcDesc=""
	.s ClcmsDr=$li(^DHCANRC("CheckItem",RowId),4)
	.;q:ClcmsDr=""
	.i ClcmsDr'="" s ClcmsDesc=$li(^DHCCLC("MedicalSpecialty",ClcmsDr),2)
	.e  s ClcmsDesc=""
	.s Type=$li(^DHCANRC("CheckItem",RowId),5)
	.s TestCode=$li(^DHCANRC("CheckItem",RowId),6)
	.s ExamCode=$li(^DHCANRC("CheckItem",RowId),7)
	.s ConsultationCode=$li(^DHCANRC("CheckItem",RowId),8)
	.s ANRCCIDisplayProject=$li(^DHCANRC("CheckItem",RowId),9) //显示方式(多)
	.;b //123
	.s ANRCCIDisplayDecide=$li(^DHCANRC("CheckItem",RowId),10) //是否显示
	.q:ANRCCIDisplayDecide="N"
	.s ANRCCIDisplayRowNumb=$li(^DHCANRC("CheckItem",RowId),11) //显示行号
	.s RowNumb=$p(ANRCCIDisplayRowNumb,"|",1)
	.s ColNumb=$p(ANRCCIDisplayRowNumb,"|",3)
	.s ^TMPANRRisk("CheckItem",$j,RowNumb,ColNumb,RowId)=RowId_"^"_Code_"^"_Desc_"^"_DefAnrcmcDr_"^"_DefAnrcmcDesc_"^"_ClcmsDr_"^"_ClcmsDesc_"^"_Type_"^"_TestCode_"^"_ExamCode_"^"_ConsultationCode_"^"_ANRCCIDisplayProject_"^"_ANRCCIDisplayDecide_"^"_ANRCCIDisplayRowNumb
	
	s RowNumb="" f  s RowNumb=$o(^TMPANRRisk("CheckItem",$j,RowNumb)) q:RowNumb=""  d
	 .s ColNumb="" f  s ColNumb=$o(^TMPANRRisk("CheckItem",$j,RowNumb,ColNumb)) q:ColNumb=""  d                                                                                        
		..s RowId="" f  s RowId=$o(^TMPANRRisk("CheckItem",$j,RowNumb,ColNumb,RowId)) q:RowId=""  d			
		...i retstr="" s retstr=^TMPANRRisk("CheckItem",$j,RowNumb,ColNumb,RowId)
		...e  s retstr=retstr_$c(1)_^TMPANRRisk("CheckItem",$j,RowNumb,ColNumb,RowId)
	k ^TMPANRRisk("CheckItem",$j)
	q retstr
}

ClassMethod LoadRiskItem(Parref) As %String
{
	q:Parref="" "-1"
	s retStr=""
	s chl="" f  s chl=$o(^DHCANRRisk(Parref,"C",chl)) q:chl=""  d
	.s anrRowId=Parref_"||"_chl
	.s AnrcciDr=$li(^DHCANRRisk(Parref,"C",chl),1)
	.s AnrcciCode=$li(^DHCANRC("CheckItem",AnrcciDr),1)
	.s Checked=$li(^DHCANRRisk(Parref,"C",chl),2)
	.s Result=$li(^DHCANRRisk(Parref,"C",chl),3)
	.s Note=$li(^DHCANRRisk(Parref,"C",chl),4)
	.i retStr="" s retStr=AnrcciCode_"^"_Checked_"^"_Result_"^"_Note
	.e  s retStr=retStr_$c(1)_AnrcciCode_"^"_Checked_"^"_Result_"^"_Note
	q retStr
}

/// w ##class(web.DHCANRRisk).SetANRRStatus("6","A")
ClassMethod SetANRRStatus(anrrId, stat) As %String
{
	q:anrrId="" "-1"
	q:stat="" "-2"
	s $li(^DHCANRRisk(anrrId),6)=stat
	q 0
}

ClassMethod GetANRRStatus(anrrId) As %String
{
	q:anrrId="" "-1"
	q $li(^DHCANRRisk(anrrId),6)
}

/// d ##class(%ResultSet).RunQuery("web.DHCANRRisk","GetANRRisk","2015-01-01","2015-01-30","","","4",,,,,,,,"N^N")
/// CR：mafucheng
/// 功能：通过此query获取手术风险分级管理数据列表
/// 入参：stdate申请时间，enddate结束时间，RiskStat状态，RiskSort手术类型，AppLoc申请科室
///      OpDiffculty手术难度，ASA麻醉分级，Anrcrc风险级别，UserNo登记号，ManageClass风险管理级别，InDateType查询日期类型(申请、出病区)
/// 返回：获取手术风险管理列表相关数据，基本与入参条件相对应
Query GetANRRisk(stdate As %String, enddate As %String, RiskStat As %String = "", RiskSort As %String = "", AppLoc As %String = "", OpDiffculty As %String = "", ASA As %String = "", Anrcrc As %String = "", UserNo As %String = "", ManageClass As %String = "", comPatWard As %String = "", anrrId As %String = "", InDateType As %String = "") As %Query(ROWSPEC = "ANRdateStr,anrrDr,patname,age,sex,admId,medCareNo,locid,Locdes,OperationDr,OperationDesc,OperDiffDr,OperDiffDesc,AsaDr,AsaDesc,AnrcrcDr,AnrcrcDesc,AnrcmcDr,AnrmcDesc,OpTypeDesc,OpType,AnrStatus,AnrStatusDesc,CrtDocDrDesc")
{
}

ClassMethod GetANRRiskExecute(ByRef qHandle As %Binary, stdate As %String, enddate As %String, RiskStat As %String = "", RiskSort As %String = "", AppLoc As %String = "", OpDiffculty As %String = "", ASA As %String = "", Anrcrc As %String = "", UserNo As %String = "", ManageClass As %String = "", comPatWard As %String = "", anrrId As %String = "", InDateType As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1
    k ^TMPANANR("ANR")
    ;s ^tempmfc("2014")=stdate_"^"_enddate_"^"_RiskStat_"^"_RiskSort_"^"_AppLoc_"^"_OpDiffculty_"^"_ASA_"^"_Anrcrc_"^"_UserNo_"^"_ManageClass_"^"_comPatWard_"^"_InDateType
    s sdate=##Class(web.DHCANOPCom).ConvertToDateH(stdate)
    s edate=##Class(web.DHCANOPCom).ConvertToDateH(enddate)   
    //s ANRdate=""  
    s AppDateType=$p(InDateType,"^",1)
    s OutDateType=$p(InDateType,"^",2)
    i ((AppDateType="N")&&(OutDateType="N")) s AppDateType="Y"
    //w InDateType,! 
    i (AppDateType="Y") d
    .do Apply
    e  i OutDateType="Y" d
    .do OutDept    
    s ANRdateStr="" f  s ANRdateStr=$o(^TMPANANR("ANR",$j,ANRdateStr)) q:ANRdateStr=""  d                                                                                         
		.s AnrStatusDesc="" f  s AnrStatusDesc=$o(^TMPANANR("ANR",$j,ANRdateStr,AnrStatusDesc)) q:AnrStatusDesc=""  d
			..s OpTypeDesc="" f  s OpTypeDesc=$o(^TMPANANR("ANR",$j,ANRdateStr,AnrStatusDesc,OpTypeDesc)) q:OpTypeDesc=""  d
				...s AnrmcDesc="" f  s AnrmcDesc=$o(^TMPANANR("ANR",$j,ANRdateStr,AnrStatusDesc,OpTypeDesc,AnrmcDesc)) q:AnrmcDesc=""  d
				....s anrrDr="" f  s anrrDr=$o(^TMPANANR("ANR",$j,ANRdateStr,AnrStatusDesc,OpTypeDesc,AnrmcDesc,anrrDr)) q:anrrDr=""  d
				 .....do OutRow2
	;k ^TMPANANR("ANR",$j)
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK	
Apply
	f date=sdate:1:edate
  	{
	s anrrDr=""
    f  s anrrDr=$O(^DHCANRRisk(0,"Date",date,anrrDr)) q:anrrDr=""  d
    .q:anrrDr=""
    .do Find(anrrDr)
    }
	Set ind=ind+1
 	quit
OutDept
	s anrrDr=1,outDate=""
    f  s anrrDr=$O(^DHCANRRisk(anrrDr)) q:anrrDr=""  d
    .q:$d(^DHCANRRisk(anrrDr))=0   
    .s admId=$li(^DHCANRRisk(anrrDr),1)
    .s outDateTime2=##class(web.DHCICUCom).GetWardOutDateTime(admId,"","","","^","D")
    .s outDate=$p(outDateTime2,"^",1)
    .q:outDate=""   
    .i (outDate>=sdate)&&(outDate<=edate) d
    ..s date=$li(^DHCANRRisk(anrrDr),4)   
    ..do Find(anrrDr)
Find(anrrDr)
	q:(anrrId'="")&&(anrrId'=anrrDr)    
    s ANRdate=$li(^DHCANRRisk(anrrDr),4)
    s ANRtime=$li(^DHCANRRisk(anrrDr),5)
   	;q:(date'="")&&(date'=ANRdate)
    i ANRtime'=""  s ANRtimeStr=$ZT(ANRtime,2)
	i ANRdate'="" s ANRdateStr=$ZD(ANRdate,3)_" "_ANRtimeStr
    s admId=$li(^DHCANRRisk(anrrDr),1)
    s papmiId=$p($g(^PAADM(admId)),"^",1)
    ;s regno=$p($g(^PAPER(papmiId,"PAT",1)),"^",1)
    ;q:(UserNo'="")&&(UserNo'=regno)
    //s medCareNo=$p($g(^PAPER(papmiId,"PAT",1)),"^",22)
	s paadmtype=$p($g(^PAADM(admId)),"^",2)
	s medCareNo=##Class(DHCWMR.IO.OutService).IGetMrNoByEpisodeID(admId,paadmtype,.ErrMsg)
    q:(UserNo'="")&&(UserNo'=medCareNo)
    s patname=$p($g(^PAPER(papmiId,"ALL")),"^",1)
    s birth=$p($g(^PAPER(papmiId,"ALL")),"^",6)
	s age=##Class(web.UDHCANOPArrange).CalAge(birth,date)
	s sex=$p($g(^CT("SEX",$p($g(^PAPER(papmiId,"ALL")),"^",7))),"^",2)
    s locid=$li(^DHCANRRisk(anrrDr),3)
    q:(AppLoc'="")&&(AppLoc'=locid)
    s Locdes=$P($g(^CTLOC(locid)),"^",2)
    s paadmtype=$p($g(^PAADM(admId)),"^",2)
	i $l(Locdes,"-")>1 s Locdes=$p(Locdes,"-",2)
	i paadmtype="O" s Locdes=Locdes_"(门)"
	e  s Locdes=Locdes
    s Operation=$li(^DHCANRRisk(anrrDr),7)
    i Operation'="" s OperationDr=$p(Operation,"|",1)
    e  s OperationDr=""
	i OperationDr=""  s OperationDesc=$p(Operation,"|",2)
	e  s OperationDesc=$p($g(^ORC("OPER",OperationDr)),"^",2)
	s OperDiffDr=$li(^DHCANRRisk(anrrDr),8)
	q:(OpDiffculty'="")&&(OpDiffculty'=OperDiffDr)
	s OperDiffDesc=$p($g(^ORC("CATEG",OperDiffDr)),"^",2)
	s AsaDr=$li(^DHCANRRisk(anrrDr),9)	
	q:(ASA'="")&&(ASA'=AsaDr)
	s AsaDesc=$p($g(^ORC("ASA",AsaDr)),"^",2)
	s AnrcrcDr=$li(^DHCANRRisk(anrrDr),10)	
	q:(Anrcrc'="")&&(Anrcrc'=AnrcrcDr)	
	i AnrcrcDr'="" s AnrcrcDesc=$li(^DHCANRC("RiskClass",AnrcrcDr),2)
	s AnrcmcDr=$li(^DHCANRRisk(anrrDr),11)	
	q:(ManageClass'="")&&(ManageClass'=AnrcmcDr)
	s AnrmcDesc=""
	i AnrcmcDr'="" s AnrmcDesc=$li(^DHCANRC("ManageClass",AnrcmcDr),2)
	s OpType=$li(^DHCANRRisk(anrrDr),21)
	q:(RiskSort'="")&&(RiskSort'=OpType)
	i OpType="B" s OpTypeDesc="择期"
	i OpType="R" s OpTypeDesc="限期"
	i OpType="E" s OpTypeDesc="急诊"
	s AnrStatus=$li(^DHCANRRisk(anrrDr),6)
	q:(RiskStat'="")&&(RiskStat'=AnrStatus)
	i AnrStatus="I" s AnrStatusDesc="申请"
	i AnrStatus="A" s AnrStatusDesc="审核"
	i AnrStatus="U" s AnrStatusDesc="撤销审核"
	s CrtDocDr=$li(^DHCANRRisk(anrrDr),12)
	s ctcpId=$p($g(^SSU("SSUSR",CrtDocDr)),"^",14)
	i CrtDocDr'="" s CrtDocDrDesc=##class(web.DHCANOPCom).GetNameById(ctcpId)
	e  s CrtDocDrDesc=""
	i (AnrmcDesc'="")&&(ANRdateStr'="")&&(AnrStatusDesc'="")&&(OpTypeDesc'="")&&(anrrDr'="") d
    .s ^TMPANANR("ANR",$j,ANRdateStr,AnrStatusDesc,OpTypeDesc,AnrmcDesc,anrrDr)=$lb(ANRdateStr,anrrDr,patname,age,sex,admId,medCareNo,locid,Locdes,OperationDr,OperationDesc,OperDiffDr,OperDiffDesc,AsaDr,AsaDesc,AnrcrcDr,AnrcrcDesc,AnrcmcDr,AnrmcDesc,OpTypeDesc,OpType,AnrStatus,AnrStatusDesc,CrtDocDrDesc)
  	Set ind=ind+1
 	quit
OutRow2
 ;//set Data=$lb(RHId,RHDesc)
 Set ^CacheTemp(repid,ind)=^TMPANANR("ANR",$j,ANRdateStr,AnrStatusDesc,OpTypeDesc,AnrmcDesc,anrrDr)
 Set ind=ind+1
 quit
}

ClassMethod GetANRRiskFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetANRRiskExecute ]
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

ClassMethod GetANRRiskClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetANRRiskExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod GetLocDesc(locId) As %String
{
	q:locId="" ""
	  s locdes=$P(^CTLOC(locId),"^",2)
	  ;s:locdes["-" locdes=$p(locdes,"-",2)
	q locdes_"^"_locId
}

/// 暂时不使用
/// w ##class(web.DHCANRRisk).GetConsult("5061486^2014-03-01^2014-03-28^内分泌科")
/// CR：mafucheng
/// 功能：获取会诊科室会诊意见
/// 入参：parr通过"^"分割，就诊号^会诊申请日期^结束日期^会诊科室别名^所在科室^会诊类型^是否在院^会诊状态
///      
/// 返回：获取会诊科室会诊意见相关数据，基本与入参条件相对应
ClassMethod GetConsult(parr) As %String
{
	s retstr=""
	s adm=$p(parr,"^",1)
    s stdate=$p(parr,"^",2)
    s edate=$p(parr,"^",3) 
    s conLoc=$p(parr,"^",4)
    s logonLoc=$p(parr,"^",5)
    s consultType=$P(parr,"^",6)
    s consultInOut=$P(parr,"^",7)
    s consultStatu=$P(parr,"^",8)
	i adm'="" {
       s loc=$P($g(^PAADM(adm)),"^",4)
    }
    else {
       i logonLoc="" q
       s logonLocType=$p(^CTLOC(logonLoc),"^",13)
       i logonLocType'="E" {
       s linkSub=0  f  s linkSub=$o(^CTLOC(logonLoc,"LINK",linkSub)) q:linkSub=""  d
       .s loc=$G(^CTLOC(logonLoc,"LINK",linkSub))
       }
       else {
          s loc=logonLoc
       }
    }
    i $g(loc)="" q
    i stdate'="" s stdate=$ZDH(stdate,3)
    e  s stdate=+$h
    i edate'="" s edate=$ZDH(edate,3)
    e  s edate=+$h
    f date=stdate:1:edate
    {
	    s id="" f  s id=$O(^User.DHCConsultationI("AppDep",date," "_loc,id)) q:id=""  d
          .s a=^User.DHCConsultationD(id)
     	  .s Adm=$listget(a,2)
     	  .q:(adm'="")&(adm'=Adm)
     	  .s condep=$listget(a,11)
    	  .s condepID=condep
    	  .i condep'=""  s condep=$P($G(^CTLOC(condep)),"^",2)
    	  .i $L(condep,"-")>1 s condep=$P(condep,"-",1)
    	  .q:(conLoc'="")&(conLoc'=condep)         
          .s appdate=$ZD(date,3)
          .s curInOut=$listget(a,14)
          .q:(consultInOut'="")&(curInOut'=consultInOut)
		  .i curInOut="I" s InOut="院内"
          .i InOut="O" s InOut="院外"
    	  .s status=$listget(a,16)
    	  .q:(consultStatu'="")&(consultStatu'=status)
          .i status="V" s status="申请"
    	  .i status="E" s status="执行"
    	  .i status="C" s status="撤销"
    	  .s type=$listget(a,9)
    	  .q:(consultType'="")&(type'=consultType)
          .s attitude=$listget(a,7)
          .s retstr=attitude
          
    }
    q retstr
}

/// w ##class(web.DHCANRRisk).GetConsultInfo("5061486^^^内分泌科")
/// CR：mafucheng
/// 功能：获取会诊科室会诊意见
/// 入参：parr通过"^"分割，就诊号^会诊申请日期^结束日期^会诊科室别名^所在科室^会诊类型^是否在院^会诊状态
///      
/// 返回：获取会诊科室会诊意见相关数据，基本与入参条件相对应
ClassMethod GetConsultInfo(parr) As %String
{
	s retstr=""
	s adm=$p(parr,"^",1)
    s stdate=$p(parr,"^",2)
    s edate=$p(parr,"^",3) 
    s conLoc=$p(parr,"^",4)
    s logonLoc=$p(parr,"^",5)
    s consultType=$P(parr,"^",6)
    s consultInOut=$P(parr,"^",7)
    s consultStatu=$P(parr,"^",8)
	i adm'="" {
       s loc=$P($g(^PAADM(adm)),"^",4)
    }
    else {
       i logonLoc="" q
       s logonLocType=$p(^CTLOC(logonLoc),"^",13)
       i logonLocType'="E" {
       s linkSub=0  f  s linkSub=$o(^CTLOC(logonLoc,"LINK",linkSub)) q:linkSub=""  d
       .s loc=$G(^CTLOC(logonLoc,"LINK",linkSub))
       }
       else {
          s loc=logonLoc
       }
    }
    i $g(adm)="" q
    s id="" f  s id=$O(^User.DHCConsultationI("Adm"," "_adm,id)) q:id=""  d        
          .s a=^User.DHCConsultationD(id)
     	  .s Adm=$listget(a,2)
     	  .q:(adm'="")&(adm'=Adm)
     	  .s condep=$listget(a,11)
    	  .s condepID=condep
    	  .i condep'=""  s condep=$P($G(^CTLOC(condep)),"^",2)
    	  .i $L(condep,"-")>1 s condep=$P(condep,"-",2)
    	  .q:(conLoc'="")&(conLoc'=condep)         
          .s appdate=$listget(a,4)
          .s curInOut=$listget(a,14)
          .q:(consultInOut'="")&(curInOut'=consultInOut)
		  .i curInOut="I" s InOut="院内"
          .i InOut="O" s InOut="院外"
    	  .s status=$listget(a,16)
    	  .q:(consultStatu'="")&(consultStatu'=status)
          .i status="V" s status="申请"
    	  .i status="E" s status="执行"
    	  .i status="C" s status="撤销"
    	  .s type=$listget(a,9)
    	  .q:(consultType'="")&(type'=consultType)
          .s attitude=$listget(a,7)
          .s retstr=attitude
    q retstr
}

/// w ##class(web.DHCANRRisk).GetRptContent("5061486")
/// CR：mafucheng
/// 功能：获取检查记录文本结果
/// 入参：StudyNo检查号
///      
/// 返回：ExamDesc检查结果文本描述
ClassMethod GetRptContent(StudyNo As %String) As %String [ WebMethod ]
{
    s ret=""
    s Rptrowid=$o(^DHCRBStudyi("Report","StudyNo",StudyNo,""),-1)
    s ExamDesc=""
    s ResultDesc=""
    i Rptrowid'="" d
    .s ExamDesc=^DHCRBStudy("Report",Rptrowid,"ExamDescEx")
    .;s ResultDesc=^DHCRBStudy("Report",Rptrowid,"ResultDescEx")
    ;s result=ExamDesc_"^"_ResultDesc
    q ExamDesc
}

ClassMethod GetLocbyId(locId As %String) As %String
{
  	q:locId="" ""
  	s locdes=""
  	s locdes=$P($g(^CTLOC(locId)),"^",2)
  	q locdes
}

/// 获取手术风险管理级别
ClassMethod GetAnrmcDescbyId(AnrcmcDr As %String) As %String
{
	q:AnrcmcDr="" ""
	s AnrmcDesc=""
	s AnrmcDesc=$li(^DHCANRC("ManageClass",AnrcmcDr),2)
	q AnrmcDesc
}

/// 获取手术风险级别
ClassMethod GetAnrcrcDescbyId(AnrcrcDr As %String) As %String
{
	q:AnrcrcDr="" ""
	s AnrcrcDesc=""
	s AnrcrcDesc=$li(^DHCANRC("RiskClass",AnrcrcDr),2)
	q AnrcrcDesc
}

/// 设置显示级别、权限（科室）
/// 入参：FromRowId权限开始索引,ToRowId权限结束索引,AnrcmcDr风险管理级别
/// ,FormCheckItemRowID显示项目开始索引,ToCheckItemRowID显示项目结束索引
/// w ##class(web.DHCANRRisk).SetDHCANRCLocCheck(108,,4,119,151,31)
ClassMethod SetDHCANRCLocCheck(FromRowId, ToRowId, AnrcmcDr, FormCheckItemRowID, ToCheckItemRowID, LocID) As %String
{
	q:FromRowId="" ""
	;q:ToRowId="" ""
	q:AnrcmcDr="" ""
	q:FromRowId="" ""
	q:FormCheckItemRowID="" ""
	q:ToCheckItemRowID="" ""
	q:LocID="" ""
	s retstr=0
	f RowId=FormCheckItemRowID:1:ToCheckItemRowID
	{
		s ^DHCANRC("LocCheck",0,"Ctloc",LocID,FromRowId) = "" 		
		s ^DHCANRC("LocCheck",FromRowId) = $lb(AnrcmcDr,RowId,LocID)
		s FromRowId=FromRowId+1		
	}
	q retstr
}

ClassMethod GetPath()
{
	&sql(select pathtoreports into :reportPath from websys.configuration)
	q reportPath
}

ClassMethod GetHospital()
{
	&sql(select hosp_desc into :hospitalName from ct_hospital)
	q $g(hospitalName)
}

ClassMethod GetHosNameByLoc(locId As %String)
{
	q:locId="" ""
	s hospitalDr=$P($g(^CTLOC(locId)),"^",22)
	i hospitalDr'="" s hospitalName=$p(^CT("HOSP",hospitalDr),"^",2)
	q $g(hospitalName)
}

/// 获取风险评估并发症等信息
/// Parref:风险管理ID，loc:科室，AnrciCode:并发症代码
/// AnrciCode为空返回所以并发症,否则返回具体并发症
ClassMethod GetRiskItemList(Parref, loc, AnrciCode As %String = "") As %String
{
	q:Parref=""||loc="" "-1"
	s retStr=""
	s chl="" f  s chl=$o(^DHCANRRisk(Parref,"C",chl)) q:chl=""  d
	.s anrRowId=Parref_"||"_chl
	.s AnrcciDr=$li(^DHCANRRisk(Parref,"C",chl),1)
	.s AnrcciCode=$li(^DHCANRC("CheckItem",AnrcciDr),1)
	.q:(AnrciCode'="")&&(("^"_AnrciCode_"^")'[("^"_AnrcciCode_"^"))
	.s AnrcDesc=$li(^DHCANRC("CheckItem",AnrcciDr),2)
	.;s colnum=$li(^DHCANRC("CheckItem",AnrcciDr),11)
	.;i colnum'="" s colnum=$p(colnum,"|",3)
	.;q:(colNumb'="")&&(colnum'=colNumb)
	.s Checked=$li(^DHCANRRisk(Parref,"C",chl),2)
	.s Result=$li(^DHCANRRisk(Parref,"C",chl),3)
	.s Note=$li(^DHCANRRisk(Parref,"C",chl),4)
	.s anrclcRowId=0  f  s anrclcRowId=$o(^DHCANRC("LocCheck",anrclcRowId)) q:anrclcRowId=""  d	
	..s ctlocDr=$li(^DHCANRC("LocCheck",anrclcRowId),3)
	..q:(loc'=ctlocDr)
	..q:(AnrcciDr'=$li(^DHCANRC("LocCheck",anrclcRowId),2))
	..i AnrciCode="other3" d
	...i Note'="" d
	....i retStr="" s retStr=Note
	....e  s retStr=retStr_"$"_Note
	...e  d
	....i retStr="" s retStr="0"
	....e  s retStr=retStr_"$"_"0"
	..e  d
	...i Checked="Y" d
	....i retStr="" s retStr="1"
	....e  s retStr=retStr_"$"_"1"
	...e  d
	....i retStr="" s retStr="0"
	....e  s retStr=retStr_"$"_"0"
	..;i retStr="" s retStr=AnrcDesc_"^"_Checked_"^"_Result_"^"_Note
	..;e  s retStr=retStr_"$"_AnrcDesc_"^"_Checked_"^"_Result_"^"_Note	
	q retStr
}

}
