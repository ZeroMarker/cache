Class web.DHCEMDocGuarantee Extends (%RegisteredObject, %XML.Adaptor) [ Not ProcedureBlock ]
{

/// Creator：      zhouxin
/// CreatDate：    2018-07-06
/// Description:： 保存或者新增急诊担保原因
/// Table：        DHC_EmGuaReason
/// Return：       {code:0,msg:msg}
ClassMethod saveOrUpdate(str)
{
 
 n (str)	
 s ID=$p(str,"^",1)
 s Code=$p(str,"^",2)
 s Name=$p(str,"^",3)
 s ActiveFlag=$p(str,"^",4)
 s HospDr=$p(str,"^",5)
 i ($a(HospDr)>57)||($a(HospDr)<48) d
 .s HospDr=$o(^CT("HOSP",0,"Desc",$$ALPHAUP^SSUTIL4(HospDr),""))
 i +ID=0 d
 .s obj=##class(User.DHCEmGuaReason).%New()
 e  d
 .s obj=##class(User.DHCEmGuaReason).%OpenId(ID)
 .d obj.%Reload()
 s obj.GREActiveFlag=ActiveFlag
 s obj.GRECode=Code
 s obj.GREDesc=Name
 d obj.GREHospDrSetObjectId(HospDr)

 s sc=obj.%Save()
 s code=0
 i $SYSTEM.Status.IsError(sc) d
 .s code=$SYSTEM.Status.GetErrorCodes(sc)
 .s msg=$SYSTEM.Status.GetErrorText(sc)
 .s:code="5808" msg="代码或描述不唯一"
 .d ..R(code,msg)
 q code
}

/// Creator：      zhouxin
/// CreatDate：    2018-07-06
/// Description:： 批量保存或者修改急诊担保原因
/// Table：        DHC_EmGuaReason
/// Return：       {code:0,msg:msg}
ClassMethod save(params)
{
    n (params)
  	s $Zt="Err"
  	TStart
  	s ret=0
  	s len=$l(params,"$$")
  	for i=1:1:len d
  	.q:ret'=0
  	.s str=$p(params,"$$",i)
  	.s ret=..saveOrUpdate(str)
	i ret'=0 TRollback
	q:ret'=0 ""
	TCOMMIT
	d ..R(0,0)
	q ""
Err
	TRollback
	d ..R(999,$ze)
	q ""
}

/// Creator：      zhouxin
/// CreatDate：    2018-07-06
/// Description:： 急诊担保原因
/// Table：        DHC_EmGuaReason 
/// Others：       w ##class(web.DHCEMDocGuarantee).ListGuaReason("10","1","^呵呵")
ClassMethod ListGuaReason(rows As %String, page As %String, code As %String = "", desc As %String = "", hospDrID As %String = "") As %String
{
	n (rows,page,code,desc,hospDrID)

	s end=page*rows
	s start=(page-1)*rows+1
	s titlestr="ID^GRECode^GREDesc^GREActiveFlag^GREHospDr"
	s count=0
	w "{""rows"":["
	s id=""
	f  s id=$o(^User.DHCEmGuaReasonD(id)) q:id=""  d
	.  
	.s reasoncode=$LISTGET(^User.DHCEmGuaReasonD(id),2)
	.s reasondesc=$LISTGET(^User.DHCEmGuaReasonD(id),3)
	.s activeFlag=$LISTGET(^User.DHCEmGuaReasonD(id),4)
	.s hospDr=+$LISTGET(^User.DHCEmGuaReasonD(id),5)
	.s hospDesc=""
	.s:hospDr'=0 hospDesc=$p(^CT("HOSP",hospDr),"^",2)
	.q:(code'="")&(reasoncode'[code)
	.q:(desc'="")&(reasondesc'[desc)
    .q:(hospDrID'="")&(hospDrID'=hospDr) //hxy 2019-07-18
	.s count = count+1
	.q:(count<start)||(count>end)
	.w $case(count,start:"",:",")
	.s tempstr=id_"^"_reasoncode_"^"_reasondesc_"^"_activeFlag_"^"_hospDesc_"^"_hospDr
	.w ##class(web.DHCAPPJsonCommon).getJsonData(titlestr,tempstr)
    w "],""total"":"_count_"}"
	q ""
}

/// Creator：      zhouxin
/// CreatDate：    2018-07-06
/// Description:： 删除急诊担保原因
/// Table：        DHC_EmGuaReason
/// Return：       {code:0,msg:msg}
ClassMethod remove(ID) As %String
{
 
 n (ID)
 s code=0,msg="success"
 d:+ID=0 ..R(code,msg)
 q:+ID=0 ""
 s sc=##class(User.DHCEmGuaReason).%DeleteId(ID)
 i $SYSTEM.Status.IsError(sc) d
 .s code=$SYSTEM.Status.GetErrorCodes(sc)
 .s msg=$SYSTEM.Status.GetErrorText(sc)
 d ..R(code,msg)
 q ""
}

/// d ##class(web.DHCEMDocGuarantee).R(0,1)
ClassMethod R(code, msg) As %String
{
	n (code,msg)
	s rObj = ##class(web.DHCAPPJsonObject).%New()
	d rObj.Put("code",code).Put("msg",msg)
	w rObj.Json()
	q ""
}

/// 输出担保原因combox
ClassMethod reasonCombox(hosp) As %String
{
	n (hosp,%session)
	s hosp=##Class(web.DHCEMCommonUtil).GetDefHospIdByTableName("DHC_EmGuaReason",hosp) //hxy 2020-05-27 产品配置-私有
	w "["
	s id="",count=0
	f  s id=$o(^User.DHCEmGuaReasonD(id)) q:id=""  d
	.s reasondesc=$LISTGET(^User.DHCEmGuaReasonD(id),3)
	.s activeFlag=$LISTGET(^User.DHCEmGuaReasonD(id),4)
	.s hospDr=+$LISTGET(^User.DHCEmGuaReasonD(id),5)
	.q:+hosp'=hospDr
	.q:activeFlag="N"
	.S reasondesc=##class(web.DHCEMCommonUtil).GetTransDesc("User.DHCEmGuaReason","GREDesc","",reasondesc)
	.s count=count+1
	.w $case(count,1:"",:",")
	.w ##class(web.DHCAPPJsonCommon).getJsonData("id^text",id_"^"_reasondesc)
	w "]"
	q ""
}

/// 输出担保状态combox
ClassMethod statusCombox() As %String
{
	s alltext=##class(web.DHCEMCommonUtil).GetTrans("dhcem.gua.guarantee.csp","全部")
	s reqtext=##class(web.DHCEMCommonUtil).GetTrans("dhcem.gua.guarantee.csp","申请")
	s yestext=##class(web.DHCEMCommonUtil).GetTrans("dhcem.gua.guarantee.csp","审批通过")
	s notext=##class(web.DHCEMCommonUtil).GetTrans("dhcem.gua.guarantee.csp","审批拒绝")
	s canceltext=##class(web.DHCEMCommonUtil).GetTrans("dhcem.gua.guarantee.csp","取消申请")
	
	w "["
	w ##class(web.DHCAPPJsonCommon).getJsonData("id^text","A^"_alltext)
	w ","_##class(web.DHCAPPJsonCommon).getJsonData("id^text","R^"_reqtext)
	w ","_##class(web.DHCAPPJsonCommon).getJsonData("id^text","Y^"_yestext)
	w ","_##class(web.DHCAPPJsonCommon).getJsonData("id^text","N^"_notext)
	w ","_##class(web.DHCAPPJsonCommon).getJsonData("id^text","C^"_canceltext)
	w "]"
	q ""
}

/// Creator：      zhouxin
/// CreatDate：    2018-07-09
/// Description:： 保存或者修改担保申请记录
/// Table：        DHC_EmDocGuarantee
/// Return：       {code:0,msg:msg}
ClassMethod saveGuarantee(guaReason, guaranteeAmt, startDate = "", endDate = "", mortgages, guaranteeId, guaUser, adm, lgUser, refuseReason = "")
{
    n (guaReason, guaranteeAmt, startDate, endDate, mortgages, guaranteeId,guaUser,adm,lgUser,refuseReason)


  	i +guaranteeId=0 d
  	.s obj=##class(User.DHCEmDocGuarantee).%New()
  	.s obj.DGUAdm=adm
  	.d obj.DGUCreatorSetObjectId(lgUser)
  	.s obj.DGUCreateDate=+$h
  	.s obj.DGUCreateTime=$p($h,",",2)
  	e  d
  	.s obj=##class(User.DHCEmDocGuarantee).%OpenId(guaranteeId)
  	
  	s startDate=##class(web.DHCEMCommonUtil).DateHtmlToLogical(startDate)
  	s endDate=##class(web.DHCEMCommonUtil).DateHtmlToLogical(endDate)
  	
  	s tmpGreen=+$o(^User.DHCEmDocGuaranteeI("DGUAdmIndex"," "_adm,""),-1)
  	i (tmpGreen'=0)&&(+guaranteeId=0)&&($LISTGET(^User.DHCEmDocGuaranteeD(tmpGreen),10)="R") d
  	.d ..R("-3","就诊记录已有待审核申请,请先审核!")
  	q:(tmpGreen'=0)&&(+guaranteeId=0)&&($LISTGET(^User.DHCEmDocGuaranteeD(tmpGreen),10)="R") ""
  	
  	i (obj.DGUStatus'="R")&&(obj.DGUStatus'="") d
  	.d ..R("-1","不是申请状态不能修改!")
  	q:(obj.DGUStatus'="R")&&(obj.DGUStatus'="") ""
  	
  	i lgUser'=obj.DGUCreator.%Id() d
  	.d ..R("-2","非本人申请不能修改!")
  	q:lgUser'=obj.DGUCreator.%Id() ""
  	
  	i ((endDate'="")&&(endDate<startDate)) d
  	.d ..R("-4","担保结束日期不能早于担保开始日期!")
  	q:((endDate'="")&&(endDate<startDate)) ""
  	
  	d obj.DGUGuaReasonSetObjectId(guaReason)
  	d obj.DGUMoneySetObjectId(guaranteeAmt)
  	s obj.DGUStartDate=startDate
  	s obj.DGUEndTime=endDate
  	s obj.DGUGuarantee=mortgages
  	s obj.DGUUser=guaUser
  	s obj.DGUStatus="R"
  	s obj.DGURefuseReason=refuseReason
  	s sc=obj.%Save()
  	i $SYSTEM.Status.IsError(sc) d
 	.s code=$SYSTEM.Status.GetErrorCodes(sc)
 	.s msg=$SYSTEM.Status.GetErrorText(sc)
 	.d ..R(code,msg)
 	q:$SYSTEM.Status.IsError(sc) ""
 	
	d ..R(0,0)
	q ""
}

/// Creator：      zhouxin
/// CreatDate：    2018-07-10
/// Description:： 查询急诊担保申请
/// Table：        DHC_EmDocGuarantee 
/// Others：       w ##class(web.DHCEMDocGuarantee).ListGuarantee("10","1","^呵呵")
ClassMethod ListGuarantee(rows As %String, page As %String, startDate As %String = "", endDate As %String = "", status As %String = "", no As %String = "", grossClass = "", lgUser = "", parAdm = "", guaUser = "", lgHosp = "") As %String
{
	n (rows,page,no,status,startDate,endDate,grossClass,lgUser,parAdm,guaUser,lgHosp,%session)

	s end=page*rows
	s start=(page-1)*rows+1
	s titlestr="ID^regno^name^sex^age^amt^reqUser^reqDate^admLoc^auditState^auditUser^adm^refuseReason"
	s count=0
	w "{""rows"":["
	
	s startDate=##class(web.DHCEMCommonUtil).DateHtmlToLogical(startDate)
	s endDate=##class(web.DHCEMCommonUtil).DateHtmlToLogical(endDate)
	f date=startDate:1:endDate d
	.s id=""
	.f  s id=$o(^User.DHCEmDocGuaranteeI("DGUCreateDateIndex",date,id)) q:id=""  d
	..s adm=+$LISTGET(^User.DHCEmDocGuaranteeD(id),2)
	..q:(parAdm'="")&&(parAdm'=adm)
	..s reqUser=$LISTGET(^User.DHCEmDocGuaranteeD(id),3) //申请人
	..q:(guaUser'="")&&(guaUser'=reqUser)
	..s reqDate=$LISTGET(^User.DHCEmDocGuaranteeD(id),4)  //申请日期
	..s reqTime=$LISTGET(^User.DHCEmDocGuaranteeD(id),15)  //申请时间
	..s guarantee=$LISTGET(^User.DHCEmDocGuaranteeD(id),5) //抵押物
	..s guaAmt=+$LISTGET(^User.DHCEmDocGuaranteeD(id),6) //抵押金额
	..s guaReason=+$LISTGET(^User.DHCEmDocGuaranteeD(id),7) //抵押原因
	..s guaStatus=$LISTGET(^User.DHCEmDocGuaranteeD(id),10) //抵押状态
	..s auditUser=$LISTGET(^User.DHCEmDocGuaranteeD(id),11) //审批人
	..s auditDate=+$LISTGET(^User.DHCEmDocGuaranteeD(id),12) //审批时间
	..s refuseReason=$LISTGET(^User.DHCEmDocGuaranteeD(id),16) //拒绝原因
	..//只能看到自己的申请
   	..//q:(grossClass'=1)&&(lgUser'=reqUser)
	..s reqUser=$p($g(^SSU("SSUSR",reqUser)),"^",2)
	..s:guaAmt'=0 guaAmt=$LISTGET($g(^User.DHCEmGuaLevelD(guaAmt)),2)
	..s:reqTime'="" reqTime=$zt(reqTime)
	..s reqDate=##class(web.DHCEMCommonUtil).DateLogicalToHtml(reqDate)_" "_reqTime
	..s:auditUser'="" auditUser=$p($g(^SSU("SSUSR",auditUser)),"^",2)
	..q:(status'="A")&&(status'="")&&(status'=guaStatus)
	..s guaStatus=$case(guaStatus,"Y":"审批通过","N":"审批拒绝","C":"取消申请",:"申请")
	..s regno="",admLoc="",name="",age="",sex="",CurHospID=""
	..i adm'=0 d
	...q:'$d(^PAADM(adm))
	...s papmiId=+^PAADM(adm)
	...s name=$p($g(^PAPER(papmiId,"ALL")),"^",1)
	...s regno=$p($g(^PAPER(papmiId,"PAT",1)),"^",1)
	...s age=##class(web.DHCEMCommonUtil).GetPapmiAgeByAdmID(adm)
	...s ctlocId=+$p(^PAADM(adm),"^",4)
	...s:ctlocId'=0 admLoc=$p(^CTLOC(+ctlocId),"^",2)
	...s sexdr=$p(^PAPER(papmiId,"ALL"),"^",7)
   	...s sex=$p(^CT("SEX",sexdr),"^",2)
   	...s CurHospID=$p($g(^CTLOC(+ctlocId)),"^",22) //hxy 2020-06-12 st
   	..q:(lgHosp'="")&(lgHosp'=CurHospID) //ed
   	..q:($g(no)'="")&&(regno'=no)
	..s count = count+1
	..q:(count<start)||(count>end)
	..s sex=##class(web.DHCEMCommonUtil).GetTransDesc("User.CTSex","CTSEXDesc","",sex)
	..s reqUser=##class(web.DHCEMCommonUtil).GetTransDesc("User.SSUser","SSUSRName","",reqUser)
	..s auditUser=##class(web.DHCEMCommonUtil).GetTransDesc("User.SSUser","SSUSRName","",auditUser)
	..s admLoc=##class(web.DHCEMCommonUtil).GetTransDesc("User.CTLoc","CTLOCDesc","",admLoc)
	..s guaStatus=##class(web.DHCEMCommonUtil).GetTrans("dhcem.gua.guarantee.csp",guaStatus)
	
	..w $case(count,start:"",:",")
	..s json={}
	..s json.ID=id
	..s json.regno=$g(regno)
	..s json.name=$g(name)
	..s json.sex=$g(sex)
	..s json.age=$g(age)
	..s json.amt=$g(guaAmt)
	..s json.reqUser=reqUser
	..s json.reqDate=reqDate
	..s json.admLoc=$g(admLoc)
	..s json.auditState=guaStatus
	..s json.auditUser=auditUser
	..s json.adm=adm
	..s json.refuseReason=refuseReason
	..w json.%ToJSON()
	..//s tempstr=id_"^"_$g(regno)_"^"_$g(name)_"^"_$g(sex)_"^"_$g(age)_"^"_guaAmt_"^"_reqUser_"^"_reqDate_"^"_$g(admLoc)_"^"_guaStatus_"^"_auditUser_"^"_adm_"^"_refuseReason
	..//w ##class(web.DHCAPPJsonCommon).getJsonData(titlestr,tempstr)
    w "],""total"":"_count_"}"
	q ""
}

/// Creator：      zhouxin
/// CreatDate：    2018-07-10
/// Description:： 查询急诊病人基本信息
ClassMethod getInfoBYAdm(adm As %String = "", hosp As %String) As %String
{
	n (adm,hosp,%session)
	s titlestr="name^sex^age^level^threenon^admtime^admway^diagnosis^mortgages^admType^admCat^inHospDate",tempstr=""
	i +adm'=0 d
	.s diagnosis=##class(web.DHCDocInPatientList).GetMRAdmDiagnosis(adm)
	.s papmiId=+^PAADM(adm)
	.s admType=$p(^PAADM(adm),"^",20)
	.s admCat=$p(^PAADM(adm),"^",2)
	.s name=$p($g(^PAPER(papmiId,"ALL")),"^",1)
	.s age=##class(web.DHCEMCommonUtil).GetPapmiAgeByAdmID(adm)
	.s sexdr=$p(^PAPER(papmiId,"ALL"),"^",7)
   	.s sex=$p(^CT("SEX",sexdr),"^",2)
   	
   	.//s level=##Class(web.DHCEMPatCheckLevCom).GetPatLevByAdm(adm)
   	.s level=##class(web.DHCEMPatCheckLevCom).GetPatPriority(adm, "Y") /// 获取病人当前分级描述 bianshuai 2020-03-16
   	.s levId=+##Class(web.DHCEMPatCheckLevCom).GetPatLevIdByAdm(adm,papmiId,hosp)
   	.i levId'=0 d
   	..s admway=$p(^DHCEMPCL(levId),"^",16)
   	..s:admway'="" admway=$p(^DHCEMPADW(admway),"^",2)
   	..s admtime=##class(web.DHCEMCommonUtil).DateLogicalToHtml($p(^DHCEMPCL(levId),"^",4))
   	..s patType=+$p(^DHCEMPCL(levId),"^",40)
   	..i patType'=0 d
   	...s threenon=$p(^DHCEMPT(patType),"^",2)
   	.s inHospDate=""
   	.i admCat="I" d
   	..s inHospDateInfo=##class(DHCMed.NINFService.BC.CommonSrv).GetInHospDateTime(adm)
   	..s inHospDate=##class(web.DHCEMCommonUtil).DateLogicalToHtml(+inHospDateInfo)
	.s sex=##class(web.DHCEMCommonUtil).GetTransDesc("User.CTSex","CTSEXDesc","",sex)
	.S threenon=##class(web.DHCEMCommonUtil).GetTransDesc("User.DHCEmPatType","PTDesc","",$g(threenon))
	.S admway=##class(web.DHCEMCommonUtil).GetTransDesc("User.DHCEmPatAdmWay","PAWDesc","",$g(admway))
   	.s tempstr=name_"^"_sex_"^"_age_"^"_$g(level)_"^"_$g(threenon)_"^"_$g(admtime)_"^"_$g(admway)_"^"_$g(diagnosis)_"^"_$g(mortgages)
   	.s tempstr=tempstr_"^"_$G(admType)_"^"_admCat_"^"_inHospDate
   	w ##class(web.DHCAPPJsonCommon).getJsonData(titlestr,tempstr)
   	q ""
}

/// Creator：      zhouxin
/// CreatDate：    2018-07-10
/// Description:： 查询急诊担保申请信息
/// Table：        DHC_EmDocGuarantee 
ClassMethod getInfoBYGua(gua As %String = "") As %String
{
	n (gua,%session)
	s titlestr="mortgages^guaranteeAmt^guaStartDate^guaEndDate^guaReason^guaUser",tempstr=""
	i +gua'=0 d
	.s mortgages=$LISTGET(^User.DHCEmDocGuaranteeD(gua),5)
	.s guaranteeAmt=$LISTGET(^User.DHCEmDocGuaranteeD(gua),6)
	.s guaStartDate=##class(web.DHCEMCommonUtil).DateLogicalToHtml($LISTGET(^User.DHCEmDocGuaranteeD(gua),8))
	.s guaEndDate=##class(web.DHCEMCommonUtil).DateLogicalToHtml($LISTGET(^User.DHCEmDocGuaranteeD(gua),9))
	.s guaReason=$LISTGET(^User.DHCEmDocGuaranteeD(gua),7)
	.s guaUser=$LISTGET(^User.DHCEmDocGuaranteeD(gua),14)
	.s guaUser=##class(web.DHCEMCommonUtil).GetTransDesc("User.SSUser","SSUSRName","",guaUser)
   	.s tempstr=mortgages_"^"_guaranteeAmt_"^"_guaStartDate_"^"_guaEndDate_"^"_guaReason_"^"_guaUser
   	w ##class(web.DHCAPPJsonCommon).getJsonData(titlestr,tempstr)
   	q ""
}

/// Creator：      zhouxin
/// CreatDate：    2018-07-10
/// Description:： 审核担保
/// Table：        DHC_EmDocGuarantee 
ClassMethod auditGua(gua As %String = "", state As %String = "", lgUser As %String = "", guaReason = "") As %String
{
	n (gua,state,lgUser,guaReason)
	s $zt="Err"
	i $l(guaReason)>200 d
	.d ..R(2,"拒绝原因长度不能超过200")
	q:$l(guaReason)>200 ""
	tstart
	s obj=##class(User.DHCEmDocGuarantee).%OpenId(gua)
	i obj.DGUStatus'="R" d
	.d ..R(2,"已审核")
	.trollback
	q:obj.DGUStatus'="R" ""
	
	i (lgUser'=obj.DGUCreator.%Id())&&(state="C") d
  	.d ..R(3,"非本人申请不能取消!")
  	.trollback
  	q:(lgUser'=obj.DGUCreator.%Id())&&(state="C") ""
  	
  	s guaEndTime=obj.DGUEndTime
  	i (guaEndTime'="")&&(guaEndTime<+$h)&&(state="Y") d
  	.d ..R(4,"担保结束日期已经超过当前日期!")
  	.trollback
  	q:(guaEndTime'="")&&(guaEndTime<+$h)&&(state="Y") ""
  	
   	s obj.DGUStatus=state
   	s obj.DGUAuditDate=+$h
   	s obj.DGUAuditTime=$p($h,",",2)
   	s:guaReason'="" obj.DGURefuseReason=guaReason
   	d obj.DGUAuditorSetObjectId(lgUser)
   	s sc=obj.%Save()
   	i $SYSTEM.Status.IsError(sc) d
 	.s code=$SYSTEM.Status.GetErrorCodes(sc)
 	.s msg=$SYSTEM.Status.GetErrorText(sc)
 	.trollback
 	.d ..R(code,msg)
   	q:$SYSTEM.Status.IsError(sc) ""
   	s admId=obj.DGUAdm
   	s admType=$p(^PAADM(admId),"^",2)
   	s:admType'="I" admType="E"	;门急诊/住院
   	
   	s startDate=obj.DGUStartDate
   	s endDate=obj.DGUEndTime
   	s reason=+obj.DGUGuaReason.%Id()
   	s guaAmt=+obj.DGUMoney.%Id()
   	s:startDate'="" startDate=##class(web.DHCEMCommonUtil).DateLogicalToHtml(startDate)
   	s:endDate'="" endDate=##class(web.DHCEMCommonUtil).DateLogicalToHtml(endDate)
   	s:guaAmt'=0 guaAmt=$LISTGET(^User.DHCEmGuaLevelD(guaAmt),2)
   	;s:reason'=0 reason=$LISTGET(^User.DHCEmGuaReasonD(reason),3) //抵押原因
   	s admHisoID=##class(web.DHCEMCommonUtil).GetHospitalByAdm(admId)
   	s userid=""  // 将担保人描述转换为User表ID 2021-01-27 bianshuai
   	i obj.DGUUser'="" s userid=$o(^SSU("SSUSR",0,"SSUSR_Name",$$ALPHAUP^SSUTIL4(obj.DGUUser),""))
   	///     担保RowId_"&"_就诊RowId_"&"_开始日期_"&"_结束日期_"&"_担保人_"&"_担保金额_"&"_担保状态(有效:"Y"; 无效:"N")
	///     _"&"_"备注"_"&"_操作员RowId_"&"_患者类型(门急诊:"E"; 住院:"I")_"&"_申请RowId_"&"_担保物_"&"_医院ID_"&"_担保原因Id
   	//调用计费组保存急诊担保信息
	s warrInfo="&"_obj.DGUAdm_"&"_startDate_"&"_endDate
	s warrInfo=warrInfo_"&"_userid_"&"_guaAmt_"&"_state
	s warrInfo=warrInfo_"&"_""_"&"_lgUser_"&"_admType  // 无备注所以传空
	s warrInfo=warrInfo_"&"_obj.%Id()_"&"_obj.DGUGuarantee
	s warrInfo=warrInfo_"&"_admHisoID_"&"_reason  // 最后一个参数为担保原因id

	//s ss=$i(^ZXZX(warrInfo))
	//23&658&2018-07-16&2018-07-18&医生01&1000&Y&急诊患者&4634&E&23&手机
	//w ##class(web.DHCBillInterface).ISaveWarrant("23&658&2018-07-16&2018-07-18&医生01&1000&Y&急诊患者&4634&E&23&手机")
	s ret=0
	i state="Y" d
	.s ret=##class(web.DHCBillInterface).ISaveWarrant(warrInfo)
	.i $p(ret,"^",1)'=0 d
	..trollback
	d ..R($p(ret,"^",1),$p(ret,"^",2))
	q:+ret'=0 ""
   	tcommit
   	q ""
}

/// Creator：      zhouxin
/// CreatDate：    2018-07-11
/// Description:： 根据adm获取gua
ClassMethod getGuaByAdm(adm As %String = "") As %String
{
	n (adm)
	s gua=+$o(^User.DHCEmDocGuaranteeI("DGUAdmIndex"," "_adm,""))
	q ""
}

/// Creator：      zhouxin
/// CreatDate：    2018-07-11
/// Description:： 根据PatientID获取病人登记号
ClassMethod getRegNoByPatientID(PatientID As %String = "") As %String
{
	n (PatientID)
	w $p($g(^PAPER(PatientID,"PAT",1)),"^",1)
	q ""
}

/// Creator：      zhouxin
/// CreatDate：    2018-07-12
/// Description:： 获取打印信息
ClassMethod getPrintInfo(gua As %String = "") As %String
{
	n (gua)
	s guaranteeID=$LISTGET(^User.DHCEmDocGuaranteeD(gua),5)
	s guarantee=""
	s:guaranteeID'="" guarantee=$p(^PAC("CARD",guaranteeID),"^",2)
	;s guarantee=##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("User.DHCCredType","CRTDesc","",guarantee)	
	s status=$LISTGET(^User.DHCEmDocGuaranteeD(gua),10) /// 申请状态
	s guaranteeAmt=+$LISTGET(^User.DHCEmDocGuaranteeD(gua),6)
	s:guaranteeAmt'=0 guaranteeAmt=$LISTGET(^User.DHCEmGuaLevelD(guaranteeAmt),2)
	s:+guaranteeAmt<1 guaranteeAmt="0."_$p(guaranteeAmt,".",2)
	s guaStartDate=$LISTGET(^User.DHCEmDocGuaranteeD(gua),8)
	s:guaStartDate'="" guaStartDate=##class(web.DHCEMCommonUtil).DateLogicalToHtml(guaStartDate)
	s guaEndDate=$LISTGET(^User.DHCEmDocGuaranteeD(gua),9)
	s:guaEndDate'="" guaEndDate=##class(web.DHCEMCommonUtil).DateLogicalToHtml(guaEndDate)

	s adm=+$LISTGET(^User.DHCEmDocGuaranteeD(gua),2)
	i adm>0 d
	.s papmiId=+^PAADM(adm)
	.s Name=$p($g(^PAPER(papmiId,"ALL")),"^",1)
	.s regno=$p($g(^PAPER(papmiId,"PAT",1)),"^",1)
	.s Company=$p($g(^PAPER(papmiId,"PER",4)),"^",18)
	.s Phone=$p(^PAPER(papmiId,"PER",1),"^",11)
	.s diagnosis=##class(web.DHCDocInPatientList).GetMRAdmDiagnosis(adm)
	.s address=$g(^PAPER(papmiId,"PER","ADD",1))
	.s ctlocId=+$p(^PAADM(adm),"^",4)
	.s hopName=$p(^CTLOC(ctlocId),"^",22)
	.s hopName=$p(^CT("HOSP",hopName),"^",2)
   	w guarantee_"^"_guaranteeAmt_"^"_$g(Name)_"^"_$g(Company)_"^"_$g(Phone)_"^"_$g(diagnosis)_"^"_$g(address)_"^"_$g(hopName)_"^"_$g(status)_"^"_regno_"^"_guaStartDate_"^"_guaEndDate
   	q ""
}

/// Creator：      yangyongtao
/// CreatDate：    2019-05-08
/// Description:： 获取担保人员
/// w ##class(web.DHCEMDocGuarantee).getGuaUser("")
ClassMethod getGuaUser(LgHospID, q) As %String
{
	n (LgHospID,q,%session)
	s input=$ZCVT(q,"U")
	s count=0
	w "["
	s ID=0
	f  s ID=$o(^SSU("SSUSR",ID)) q:ID=""  d
	.q:##class(web.DHCEMCommonUtil).GetHospShowDataFlag("SS_User",ID,LgHospID)'="Y" //hxy 2020-06-15
	.s Code=$P(^SSU("SSUSR",ID),"^",1)
	.s Name=$P(^SSU("SSUSR",ID),"^",2)
	.s EMailName=$p(^SSU("SSUSR",ID),"^",11)
	.s AllName = Name_EMailName
	.q:(q'="")&($ZCVT(AllName,"U")'[q)
	.s UserActive=$p(^SSU("SSUSR",ID),"^",19)
	.q:(UserActive'="")&&(UserActive="N")
	.s UserDateFrom=$p(^SSU("SSUSR",ID),"^",96) ;生效日期
	.s UserDateTo=$p(^SSU("SSUSR",ID),"^",97) ;截止日期
	.q:(UserDateFrom'="")&&(UserDateFrom>+$h)
	.q:(UserDateTo'="")&&(UserDateTo<+$h)
	.s Name=##class(web.DHCEMCommonUtil).GetTransDesc("User.SSUser","SSUSRName","",Name)
	.s tmp=ID_"^"_Name
	.s count = count+1
	.I count=1 d
	..W ##class(web.DHCAPPJsonCommon).getJsonData("value^text",tmp)
	.e  d
	..W ","_##class(web.DHCAPPJsonCommon).getJsonData("value^text",tmp)
	w "]"
	q ""
}

/// Creator：      yangyongtao
/// CreatDate：    2019-05-08
/// Description:： 获取担保人员
/// w ##class(web.DHCEMDocGuarantee).getGuaUser("ys01")
ClassMethod getGuaUserBAK(q As %String = "") As %String
{
	 n (q)
	 k TmpGuaUserArr
	 s input=$ZCVT(input,"U")
	 s count=0
     w "["
	 s id=""
	 f  s id=$o(^User.DHCEmDocGuaranteeD(id)) q:id=""  d
	 .s UserID=$LISTGET(^User.DHCEmDocGuaranteeD(id),3) //申请人
	 .q:'$d(^SSU("SSUSR",UserID))
	 .
	 .s TmpGuaUserArr(id,UserID)=UserID
	 S index=""
	 f  s index=$o(TmpGuaUserArr(index)) Q:index=""  D
	 .s id=""
	 .f  s id=$o(TmpGuaUserArr(index,id)) Q:id=""  D
	 ..s Name=$P(^SSU("SSUSR",id),"^",2)
	 ..S EMailName=$p(^SSU("SSUSR",id),"^",11)
	 ..q:(q'="")&(EMailName'[q)
	 ..s tmp=UserID_"^"_Name
	 ..s count = count+1
	 ..I count=1 d
	 ...W ##class(web.DHCAPPJsonCommon).getJsonData("value^text",tmp)
	 ..e  d
	 ...W ","_##class(web.DHCAPPJsonCommon).getJsonData("value^text",tmp)
	 w "]"
	 q ""
}

}
