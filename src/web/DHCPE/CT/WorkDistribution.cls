/// 名称: 医生工作量分配
/// 编写者：wangguoying
/// 编写日期: 2021-08-11
Class web.DHCPE.CT.WorkDistribution Extends %RegisteredObject
{

/// Description:输出总检医生关键字列表
/// Input: 
/// Return:
/// Creater:	wangguoying
/// CreateDate:	2021-01-28
/// Debug: d ##class(web.DHCPE.WorkDistribution).OutAuditDocKeywords()
ClassMethod OutAuditDocKeywords()
{
	s html="<div id='DocKeys'  class='hisui-keywords' data-options='{"
	s html=html_"labelCls:""blue"","
	s html=html_ "items:["
	s no=0,userStr="^"
	s locId=304  ;%session.Get("LOGON.CTLOCID")
	s userId=""
	f  s userId=$O(^DHCPEDataEx("ChartAssign",userId)) q:userId=""  d
	.q:userStr[("^"_userId_"^")
	.s groupId=""
	.f  s groupId=$O(^DHCPEDataEx("ChartAssign",userId,locId,groupId))  q:groupId=""  d
	..i ($D(^DHCPEDataEx("ChartAssign",userId,locId,groupId,"Write","NULL")))&&(^DHCPEDataEx("ChartAssign",userId,locId,groupId,"Write","NULL")="Y") d
	...q:userStr[("^"_userId_"^")
	...s userStr=userStr_userId_"^"
	...s no=no+1
	...s userCode=$p(^SSU("SSUSR",userId),"^",1)
	...s userName=$p(^SSU("SSUSR",userId),"^",2)
	...s item="{text:"""_userName_"  ("_userCode_")"",id:"""_userId_"""}"
	...i no=1 s html=html_item
	...e  s html=html_","_item
	s html=html_"],"
   	s html=html_"onSelect:function(v){select_doc(v);}"
   	s html=html_",onUnselect:function(v){unselect_doc(v);}"		
	s html=html_ " }'>" 
	s html=html_"</div>"
	w html,!
}

/// Description: 查询医生总检工作量分配情况
/// Input:
/// 						DoctorID：	医生ID   为空时查询需分配未分配人员，不为空时查询分配给该医生的人员信息
/// 						Type：		AR：总检
/// Return:
/// Creater:	wangguoying
/// CreateDate:	2021-01-29
/// Debug：d ##class(%ResultSet).RunQuery("web.DHCPE.WorkDistribution","QueryWorkDistribution","","RR","","2021-01-01","2021-12-10","335","335||1") 
Query QueryWorkDistribution(DoctorID As %Library.String = "", Type As %Library.String = "AR", RegNo As %Library.String = "", BeginDate As %String, EndDate As %Library.String = "", GroupDR As %Library.String = "", GTeamDR As %Library.String = "", VIPLevel As %Library.String = "") As websys.Query(ROWSPEC = "TPAADM:%String, TRegNo:%String,TPatName:%String,TSex:%String,TAge:%String,TVIPLevel:%String,TCheckDate:%String,TStatus:%String,TReportStatus:%String") [ SqlProc ]
{
}

ClassMethod QueryWorkDistributionExecute(ByRef qHandle As %Binary, DoctorID As %Library.String = "", Type As %Library.String = "AR", RegNo As %Library.String = "", BeginDate As %String, EndDate As %Library.String = "", GroupDR As %Library.String = "", GTeamDR As %Library.String = "", VIPLevel As %Library.String = "") As %Status
{
 	s ^tmpwgy("QueryWorkDistribution")=$lb(DoctorID , Type , RegNo , BeginDate, EndDate , GroupDR , GTeamDR , VIPLevel )
	Set repid=$I(^CacheTemp)
 	s ind=1
 	i ((BeginDate="")&(EndDate=""))
 	{
	 	Set qHandle=$lb(0,repid,0)
		Quit $$$OK
 	}
 	s Type="AR"
 	//时间段必须有
 	i BeginDate'="" s BeginDate=##class(websys.Conversions).DateHtmlToLogical(BeginDate) 
	i EndDate'=""  s EndDate=##class(websys.Conversions).DateHtmlToLogical(EndDate) 
	i BeginDate="" s BeginDate=+$H-60
	i EndDate="" s EndDate=+$H
	s date=BeginDate-1
	f  s date=$O(^DHCPEIADM(0,"AdmDateTime",date))  q:(date="")||(date>EndDate)  d
	.s time=""
	.f  s time=$O(^DHCPEIADM(0,"AdmDateTime",date,time))  q:time=""  d
	..s iadm=""
	..f  s iadm=$O(^DHCPEIADM(0,"AdmDateTime",date,time,iadm))  q:iadm=""  d
	...s status=$p(^DHCPEIADM(iadm),"^",8)
	...q:status'="ARRIVED"		//到达状态
	...s status=##Class(web.DHCPE.PreCommon).TransStatus(status)
	...s paadm=$p(^DHCPEIADM(iadm),"^",1)
	...q:(DoctorID="")&&($D(^User.DHCPEWorkDistributionI("TypePAADMIndex",Type,paadm)))
	...q:(DoctorID'="")&&('$D(^User.DHCPEWorkDistributionI("TypePAADMIndex",Type,paadm,DoctorID)))
	...s reportStat=##class(web.DHCPE.NetReport.Main).IsAuditReport(paadm)
	...q:(DoctorID="")&&(Type="AR")&&(reportStat'=1)
	...q:(DoctorID="")&&(Type="MAR")&&(reportStat=0)
	...s piadm=$p(^DHCPEIADM(iadm),"^",4)
	...s gadm=$P(^DHCPEPreIADM(piadm),"^",2)
	...q:(GroupDR'="")&&(gadm'=GroupDR)
	...s team=$P(^DHCPEPreIADM(piadm),"^",3)
	...b ;1
	...q:(GTeamDR'="")&&(team'=GTeamDR)
	...s vip=##class(web.DHCPE.PreCommon).GetVIPLevel("Pre", piadm)
	...q:(VIPLevel'="")&&(+vip'=VIPLevel)
	...s vipDesc=$P(vip,"^",2)
	...s pibi=$P(^DHCPEPreIADM(piadm),"^",1)
	...s regNo=$P(^DHCPEPreIBI(pibi),"^",1)
	...q:(RegNo'="")&&(regNo'=RegNo)
	...s patName=$P(^DHCPEPreIBI(pibi),"^",2)
	...s age=$p($g(^DHCPEPreIBI(pibi)),"^",4)
	...i age'="" s age=##class(web.DHCDocCommon).GetAgeDescNew($zd(age,3),"")
	...s sex=$p($g(^DHCPEPreIBI(pibi)),"^",3)
	...i sex'="" s sex=$P(^CT("SEX",sex),"^",2)	
	...s rptStatDesc="未审核"
	...s rptId=$O(^DHCPERPT(0,"IADM",iadm,""))
	...i rptId="" d
	....s rptStst=$P(^DHCPERPT(rptId),"^",2)
	....s rptStatDesc=##class(web.DHCPE.Report).GetStatusDesc(rptStst)
	...d OutputRowData
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK

OutputRowData
   	set Data=$lb(paadm, regNo,patName,sex,age,vipDesc,$ZD(date,3),status,rptStatDesc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

/// Description:保存任务
/// Input:   
/// 				EpisodeID: 	就诊ID
/// 				Type： 		业务类型
/// 				DoctorID：	任务执行人
/// 				UserID： 	分配人
/// Return:	空：成功   非空：失败原因
/// Creater:	wangguoying
/// CreateDate:	2020-10-11
/// Debug: w ##class(web.DHCPE.WorkDistribution).SaveTask("924^10221","5121^5140^5142","AR","11849")
ClassMethod SaveTask(EpisodeID, Type, DoctorID, UserID As %String = "")
{
	s properties="WDPAAdmDR^WDType^WDReceiverDR^WDUpdateUserDR^WDUpdateDate^WDUpdateTime"
	s vals=EpisodeID_"^"_Type_"^"_DoctorID_"^"_UserID_"^"_+$H_"^"_$p($H,",",2)
	s save=##class(User.DHCPEWorkDistribution).SaveData("",vals,properties)
	q:+save<=0 $p(save,"^",2)
	q ""
}

/// Description:分配工作量
/// Input:   
/// 				DocIds: 	分配医生ID集合
/// 				AdmIds： 	就诊ID集合
/// 				Type：	 	AR：总检，MAR：复检
/// 				UserID： 	分配人
/// Return:	空：成功   非空：失败原因
/// Creater:	wangguoying
/// CreateDate:	2020-10-11
/// Debug: w ##class(web.DHCPE.WorkDistribution).Distribute("924^10221","5121^5140^5142","AR","11849")
ClassMethod Distribute(DocIds, AdmIds, Type As %String = "AR", UserID = "")
{
	s ^tmpwgy("Distribute")=$lb(DocIds, AdmIds, Type , UserID)
	i UserID'=""
	{
		s:$D(%session) UserID=%session.Get("LOGON.USERID")
		s:UserID="" UserID=1
	}
		
	s docNum=$l(DocIds,"^")	//医生数量
	s admNum=$l(AdmIds,"^")	//就诊数量
	s info=..DistributeNum(docNum,admNum)
	TS
	s ret=""
	s hadCount=0  ;已分配的数量
	f i=1:1:docNum
	{
		s docId=$p(DocIds,"^",i)
		s shouldNum=$P(info,",",i)  ;当前医生应分配的数量
		continue:shouldNum=0
		s shouldAdmIds=$P(AdmIds,"^",hadCount+1,hadCount+shouldNum)
		b ;1
		f n=1:1:shouldNum  q:ret'=""  d
		.s admId=$P(shouldAdmIds,"^",n) 
		.s properties="WDPAAdmDR^WDType^WDReceiverDR^WDUpdateUserDR^WDUpdateDate^WDUpdateTime"
		.s vals=admId_"^"_Type_"^"_docId_"^"_UserID_"^"_+$H_"^"_$p($H,",",2)
		.s save=##class(User.DHCPEWorkDistribution).SaveData("",vals,properties)
		.i +save<=0 s ret=$p(save,"^",2) tro  q 
		s hadCount=hadCount+shouldNum
	}
	i ret="" TC
	q ret
}

/// Description: 分配限额
/// Input:   
/// 				Copies：	需要分配的份数
/// 				TotalNum：	总名额
/// Return:
/// Creater:	wangguoying
/// CreateDate:	2020-09-14
/// Debug: w ##class(web.DHCPE.WorkDistribution).DistributeNum(1,2)
ClassMethod DistributeNum(Copies, TotalNum)
{
	k CopyList
	While(TotalNum>0)
	{
		f i=1:1:Copies
		{
			s CopyList(i)=$G(CopyList(i))+1
			s TotalNum=TotalNum-1
			quit:TotalNum=0
		}
	}
	s ret=""
	f i=1:1:Copies
	{
		s:$G(CopyList(i))="" CopyList(i)=0
		i ret=""  d
		.s ret=CopyList(i)
		e  d
		.s ret=ret_","_CopyList(i)
	}
	q ret
}

/// Description: 移动分配任务
/// Input:   
/// 				AdmID:	就诊ID
/// 				SourceDoc：	原医生ID
/// 				TargetDoc：	目标医生ID
/// 				Type：	 	AR：总检，MAR：复检
/// 				UserID： 	分配人
/// Return:	空：成功   非空：失败原因
/// Creater:	wangguoying
/// CreateDate:	2020-09-14
/// Debug: w ##class(web.DHCPE.WorkDistribution).Move(1,2)
ClassMethod Move(AdmID, SourceDoc, TargetDoc, Type = "AR", UserID = "")
{
	s wkDR=$O(^User.DHCPEWorkDistributionI("TypePAADMIndex",Type,AdmID,SourceDoc,""))
	i wkDR=""  q "原医生不存在该任务"
	i UserID'=""
	{
		s:$D(%session) UserID=%session.Get("LOGON.USERID")
		s:UserID="" UserID=1
	}
	TS
	s delete=##class(User.DHCPEWorkDistribution).Delete(wkDR)
	i +delete'=0  tro  q "删除原任务失败："_$P(delete,"^",2)
	s properties="WDPAAdmDR^WDType^WDReceiverDR^WDUpdateUserDR^WDUpdateDate^WDUpdateTime"
	s vals=AdmID_"^"_Type_"^"_TargetDoc_"^"_UserID_"^"_+$H_"^"_$p($H,",",2)
	s save=##class(User.DHCPEWorkDistribution).SaveData("",vals,properties)
	i +save<=0  tro  q "分配新任务失败："_$p(save,"^",2) 
	TC
	q ""
}

/// Description: 删除任务
/// Input:   
/// 				AdmID:	就诊ID
/// 				SourceDoc：	原医生ID
/// 				Type：	 	AR：总检，MAR：复检
/// Return:	空：成功   非空：失败原因
/// Creater:	wangguoying
/// CreateDate:	2020-09-14
/// Debug: w ##class(web.DHCPE.WorkDistribution).Move(1,2)
ClassMethod DeleteAdmDoc(AdmID, SourceDoc, Type = "AR")
{
	s wkDR=$O(^User.DHCPEWorkDistributionI("TypePAADMIndex",Type,AdmID,SourceDoc,""))
	i wkDR=""  q "原医生不存在该任务"
	s finish=$lg(^User.DHCPEWorkDistributionD(wkDR),5)
	q:finish=1 "任务已完成，不允许删除"
	s delete=##class(User.DHCPEWorkDistribution).Delete(wkDR)
	i +delete'=0   q "删除原任务失败："_$P(delete,"^",2)
	q ""
}

/// Description: 删除任务
/// Input:  
/// 				SourceDoc：	原医生ID
/// 				BeginDate:	开始日期
/// 				EndDate:	结束日期
/// 				Type：	 	AR：总检，MAR：复检
/// Return:	空：成功   非空：失败原因
/// Creater:	wangguoying
/// CreateDate:	2020-09-14
/// Debug: w ##class(web.DHCPE.WorkDistribution).Move(1,2)
ClassMethod DeleteByDocDate(SourceDoc, BeginDate, EndDate, Type = "AR")
{
	s BeginDate=##class(websys.Conversions).DateHtmlToLogical(BeginDate) 
	s EndDate=##class(websys.Conversions).DateHtmlToLogical(EndDate)
	s adm="",ret=""
	TS
	f  s adm=$O(^User.DHCPEWorkDistributionI("TypeReceiverDRIndex",Type,SourceDoc,adm))  q:(adm="")||(ret'="")  d
	.s admDate=$P(^PAADM(adm),"^",6)
	.q:(admDate<BeginDate)||(admDate>EndDate)
	.s workDR=""
	.f  s workDR=$O(^User.DHCPEWorkDistributionI("TypeReceiverDRIndex",Type,SourceDoc,adm,workDR))  q:(workDR="")||(ret'="")  d
	..s finish=$lg(^User.DHCPEWorkDistributionD(workDR),5)
	..q:finish=1
	..s delete=##class(User.DHCPEWorkDistribution).Delete(workDR)
	..i +delete'=0  s ret="删除原任务失败："_$P(delete,"^",2)  q
	i ret'="" tro q ret
	tc 
	q ret
}

/// Description: 删除任务
/// Input:  
/// 				BeginDate:	开始日期
/// 				EndDate:	结束日期
/// 				Type：	 	AR：总检，MAR：复检
/// Return:	空：成功   非空：失败原因
/// Creater:	wangguoying
/// CreateDate:	2020-09-14
/// Debug: w ##class(web.DHCPE.WorkDistribution).Move(1,2)
ClassMethod DeleteByDate(BeginDate, EndDate, Type = "AR")
{
	s BeginDate=##class(websys.Conversions).DateHtmlToLogical(BeginDate) 
	s EndDate=##class(websys.Conversions).DateHtmlToLogical(EndDate)
	s docId="",ret=""
	TS
	f  s docId=$O(^User.DHCPEWorkDistributionI("TypeReceiverDRIndex",Type,docId))  q:(docId="")||(ret'="")  d
	.s adm=""
	.f  s adm=$O(^User.DHCPEWorkDistributionI("TypeReceiverDRIndex",Type,docId,adm))  q:(adm="")||(ret'="")  d
	..s admDate=$P(^PAADM(adm),"^",6)
	..q:(admDate<BeginDate)||(admDate>EndDate)
	..s workDR=""
	..f  s workDR=$O(^User.DHCPEWorkDistributionI("TypeReceiverDRIndex",Type,docId,adm,workDR))  q:(workDR="")||(ret'="")  d
	...s finish=$lg(^User.DHCPEWorkDistributionD(workDR),5)
	...q:finish=1
	...s delete=##class(User.DHCPEWorkDistribution).Delete(workDR)
	...i +delete'=0  s ret="删除原任务失败："_$P(delete,"^",2)  q
	i ret'="" tro q ret
	tc 
	q ret
}

/// Description:查询启用的分配类型
/// Input:   			
/// Return:	Code^Code
/// Creater:	wangguoying
/// CreateDate:	2021-02-03
/// Debug: w ##class(web.DHCPE.WorkDistribution).GetActiveType()
ClassMethod GetActiveType(LocID)
{
	s sort="",ret=""
	f  s sort=$O(^User.DHCPEWorkDistributeTypeI("SortIndex",sort))  q:sort=""  d
	.s id=""
	.f  s id=$O(^User.DHCPEWorkDistributeTypeI("SortIndex",sort,id))  q:id=""  d
	..s active = ##class(User.DHCPEWorkDistributeType).GetLocShowDataFlag(id,LocID)
	..q:active'="Y"
	..s active = $lg(^User.DHCPEWorkDistributeTypeD(id),5)
	..q:active'="Y"
	..s code=$lg(^User.DHCPEWorkDistributeTypeD(id),2)
	..i ret'=""  s ret=ret_"^"_code
	..e  s ret=code
	q ret
}

/// Description:保存激活标记
/// Input:   
/// 				Code：业务代码
/// 				Active：激活标记			
/// Return:	
/// Creater:	wangguoying
/// CreateDate:	2021-02-03O
/// Debug: w ##class(web.DHCPE.WorkDistribution).UpdateByCode()
ClassMethod UpdateTypeByCode(Code, Active, LocID, UserID = "")
{
	i UserID = ""
	{
		s:$D(%session) UserID = %session.Get("LOGON.USERID")
		s:UserID="" UserID=1
	}
	s id=$O(^User.DHCPEWorkDistributeTypeI("CodeIndex",$$ALPHAUP^SSUTIL4(Code),""))
	q:id="" "代码无效"
	s $ZT="PowerCtrlErr"
	TS
	s save=##class(User.DHCPEWorkDistributeType).SaveData(id,Active,"WDTActive")
	i +save<=0 tro  q $P(save,"^",2)
	s ret = ##class(User.DHCPEWorkDistributeType).SaveDataToPowerControl(id, LocID , UserID, "", LocID_","_Active)
	i +ret<0  tro  q ret
	TC
	q ""
PowerCtrlErr
	s $zt=""
	Tro
	q $ZE
}

/// Description:分配类型对应医生JSON
/// Input:   
/// 			Code：分配类型代码				
/// Return:
/// Creater:	wangguoying
/// CreateDate:	2021-02-03
/// Debug: w ##class(web.DHCPE.WorkDistribution).GetDocJSONByType("AR")
ClassMethod GetDocJSONByType(Code, hospId As %String = "")
{
	s rootObj=##class(web.DHCPE.ThirdParty.Entity.TreeNode).%New()
	s rootObj.id="ALL"
	s rootObj.text="全部"
	s typeDr=$O(^User.DHCPEWorkDistributeTypeI("CodeIndex",$$ALPHAUP^SSUTIL4(Code),""))
	i typeDr'=""
	{
		S docId=""
		f  s docId=$O(^User.DHCPEWorkDoctorI("ParRefDocGpLocIndex",typeDr,docId))  q:docId=""  d
		.s docObj=##class(web.DHCPE.ThirdParty.Entity.TreeNode).%New()
		.s docObj.id="DOC_"_docId
		.s docObj.text=$P(^SSU("SSUSR",docId),"^",2)
		.s docObj.iconCls="icon-doctor"
		.s groupId=""
		.f  s groupId=$O(^User.DHCPEWorkDoctorI("ParRefDocGpLocIndex",typeDr,docId,groupId))  q:groupId=""  d
		..s groupDesc=$P(^SSU("SSGRP",groupId),"^",1)
		..s locId=""
		..f  s locId=$O(^User.DHCPEWorkDoctorI("ParRefDocGpLocIndex",typeDr,docId,groupId,locId))  q:locId=""  d
		...s HOSPshowFlag=##class(web.DHCPE.HISUICommon).GetHospShowDataFlag("CT_Loc",locId,hospId)
		...q:(HOSPshowFlag="N")
		...s locDesc=$P(^CTLOC(locId),"^",2)
		...s gLocObj=##class(web.DHCPE.ThirdParty.Entity.TreeNode).%New()
		...s gLocObj.id="GL_"_docId_"_"_groupId_"_"_locId
		...s gLocObj.text="安全组：【"_groupDesc_"】 科室：【"_locDesc_"】"
		...s gLocObj.iconCls="icon-location"
		...d docObj.children.Insert(gLocObj)
		.d rootObj.children.Insert(docObj)
	}
	s json=##class(ext.util.JsonObject).ObjToJson(rootObj)
	q "["_json_"]"
}

/// Description:保存医生集合
/// Input:   
/// 				Code：业务代码
/// 				InString：医生ID^安全组ID^科室ID			
/// Return:	""：成功 非空：失败
/// Creater:	wangguoying
/// CreateDate:	2021-02-03
/// Debug: w ##class(web.DHCPE.WorkDistribution).SaveDoctors()
ClassMethod SaveDoctors(Code, InString)
{
	s parRef=$O(^User.DHCPEWorkDistributeTypeI("CodeIndex",$$ALPHAUP^SSUTIL4(Code),""))
	q:parRef="" "代码无效"
	s docId=$p(InString,"^",1)
	s groupId=$p(InString,"^",2)
	s locId=$p(InString,"^",3)
	q:$D(^User.DHCPEWorkDoctorI("ParRefDocGpLocIndex",parRef,docId,groupId,locId)) "记录已存在"
	s properties="WDParRef^WDDoctorDR^WDGroupDR^WDLocDR"
	s save=##class(User.DHCPEWorkDoctor).SaveData("",parRef_"^"_InString,properties)
	q:+save<=0 $P(save,"^",2)
	q ""
}

/// Description:删除医生集合
/// Input:   
/// 				Code：业务代码
/// 				InString：医生ID^安全组ID^科室ID			
/// Return:	""：成功 非空：失败
/// Creater:	wangguoying
/// CreateDate:	2021-02-03
/// Debug: w ##class(web.DHCPE.WorkDistribution).DeleteDoctors()
ClassMethod DeleteDoctors(Code, InString)
{
	s parRef=$O(^User.DHCPEWorkDistributeTypeI("CodeIndex",$$ALPHAUP^SSUTIL4(Code),""))
	q:parRef="" "代码无效"
	s docId=$p(InString,"^",1)
	s groupId=$p(InString,"^",2)
	s locId=$p(InString,"^",3)
	q:docId="" "医生不能为空"
	i (groupId'="")&&(locId'="")
	{
		s sub = $O(^User.DHCPEWorkDoctorI("ParRefDocGpLocIndex",parRef,docId,groupId,locId,""))
		s delete= ##class(User.DHCPEWorkDoctor).Delete(parRef_"||"_sub)
		i +delete'=0  q $P(delete,"^",2)
		q ""
	}
	s ret=""
	Ts
	s gid=""
	f  s gid=$O(^User.DHCPEWorkDoctorI("ParRefDocGpLocIndex",parRef,docId,gid)) q:(gid="")||(ret'="")  d
	.q:(groupId'="")&&(gid'=groupId)
	.s lid=""
	.f  s lid=$O(^User.DHCPEWorkDoctorI("ParRefDocGpLocIndex",parRef,docId,gid,lid)) q:(lid="")||(ret'="")  d
	..q:(locId'="")&&(lid'=locId)
	..s sub = $O(^User.DHCPEWorkDoctorI("ParRefDocGpLocIndex",parRef,docId,gid,lid,""))
	..s delete= ##class(User.DHCPEWorkDoctor).Delete(parRef_"||"_sub)
	..i +delete'=0  s ret=$P(delete,"^",2)  q
	i ret'="" tro  q ret
	TC
	q ""
}

/// Description: 查询工作分配类型
/// Input:
/// 						Code：	业务代码
/// 						Desc：	业务描述
/// 						Active:	启用
/// Return:
/// Creater:	wangguoying
/// CreateDate:	2021-02-03
/// Debug：d ##class(%ResultSet).RunQuery("web.DHCPE.WorkDistribution","QueryWorkType","","","Y") 
Query QueryWorkType(Code As %Library.String = "", Desc As %Library.String = "", Active As %Library.String = "", LocID As %Library.String = "") As websys.Query(ROWSPEC = "TCode:%String, TDesc:%String,TSort:%String,TActive:%String") [ SqlProc ]
{
}

ClassMethod QueryWorkTypeExecute(ByRef qHandle As %Binary, Code As %Library.String = "", Desc As %Library.String = "", Active As %Library.String = "", LocID As %Library.String = "") As %Status
{
 
	Set repid=$I(^CacheTemp)
 	s ind=1
 	s sort=""
 	f  s sort=$O(^User.DHCPEWorkDistributeTypeI("SortIndex",sort))  q:sort=""  d
 	.s id=""
 	.f  s id=$O(^User.DHCPEWorkDistributeTypeI("SortIndex",sort,id))  q:id=""  d
 	..s code=$lg(^User.DHCPEWorkDistributeTypeD(id),2)
 	..q:(Code'="")&&(code'=Code)
 	..s desc=$lg(^User.DHCPEWorkDistributeTypeD(id),3)
 	..q:(Desc'="")&&(desc'[Desc)
 	..s active=$lg(^User.DHCPEWorkDistributeTypeD(id),5)
 	..q:(Active'="")&&(active'=Active)
 	..s locAct = "Y"
 	..i LocID'="" s locAct = ##class(User.DHCPEWorkDistributeType).GetLocShowDataFlag(id,LocID)
	..q:locAct'="Y"
	..d OutputRowData
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK

OutputRowData
   	set Data=$lb(code, desc,sort,locAct)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

/// Description:分配类型对应医生关键字JSON
/// Input:   
/// 			Code：分配类型代码				
/// Return:
/// Creater:	wangguoying
/// CreateDate:	2021-02-04
/// Debug: w ##class(web.DHCPE.WorkDistribution).GetDocKeysByType("AR")
ClassMethod GetDocKeysByType(Code, LocID As %String = "")
{
	i LocID=""
	{
		s:$D(%session) LocID=%session.Get("LOGON.CTLOCID")
		s:LocID="" LocID=304
	}
	
	s jsonArr=[]
	q:Code="" jsonArr.%ToJSON()
	s typeDr=$O(^User.DHCPEWorkDistributeTypeI("CodeIndex",$$ALPHAUP^SSUTIL4(Code),""))
	i typeDr'=""
	{
		S docId=""
		f  s docId=$O(^User.DHCPEWorkDoctorI("ParRefDocGpLocIndex",typeDr,docId))  q:docId=""  d
		.s flag=0  ;指定科室下是否存在记录
		.s groupId=""
		.f  s groupId=$O(^User.DHCPEWorkDoctorI("ParRefDocGpLocIndex",typeDr,docId,groupId))  q:(groupId="")||(flag=1)  d
		..s locId=""
		..f  s locId=$O(^User.DHCPEWorkDoctorI("ParRefDocGpLocIndex",typeDr,docId,groupId,locId))  q:(locId="")||(flag=1)  d
		...q:locId'=LocID
		...s flag=1
		
		.i flag=1  d
		..s userCode=$p(^SSU("SSUSR",docId),"^",1)
		..s userName=$p(^SSU("SSUSR",docId),"^",2)
		..s item={}
		..s item.id=docId
		..s item.text=userName_"  ("_userCode_")"
		..d jsonArr.%Push(item)
	}
	q jsonArr.%ToJSON()
}

/// Description:当前就诊所处状态
/// 				主要考虑结果录入、粘贴核对、报告审核、报告打印四个状态  用于判断是否可分配
/// Input:   
/// 			PAADM				
/// Return:	-1:不可分配状态？先不考虑 0：未结果录入  RR：结果录入  CC：粘贴核对 AR：报告审核 MAR:报告复审 PR：报告打印  
/// Creater:	wangguoying
/// CreateDate:	2021-02-04
/// Debug: w ##class(web.DHCPE.WorkDistribution).GetAdmStatus(672)
ClassMethod GetAdmStatus(PAADM)
{
	s iadm=$O(^DHCPEIADM(0,"PAADM",PAADM,""))
	q:iadm="" "-1"
	s status=$p(^DHCPEIADM(iadm),"^",8)
	q:status'="ARRIVED" "-1"
	s ret = 0	//未结果录入
	i $D(^User.DHCPEWorkDistributeType("CodeIndex","RR"))  //结果录入启用分配
	{
		s docId=$O(^User.DHCPEWorkDistributionI("TypePAADMIndex","RR",PAADM,""))
		i docId'="" d
		.s wkDr=$O(^User.DHCPEWorkDistributionI("TypePAADMIndex","RR",PAADM,docId,""))
		.s finish=$lg(^User.DHCPEWorkDistributionD(wkDr),5)
		.s:finish=1 ret="RR"  ;结果录入完成
	}
	s:$D(^User.DHCPESendAuditI("AdmIndex",PAADM)) ret="CC" //已粘贴核对
	s reportStatus=##class(web.DHCPE.NetReport.Main).IsAuditReport(PAADM)
	s:reportStatus'=1 ret="AR" //已初审
	s:$D(^DHCPEDataEx("DHCPEGeneralSummarize","MainDoctor",PAADM)) ret="MAR"  //复审
	s rptDr=$O(^DHCPERPT(0,"IADM",iadm,""))
	i rptDr'=""
	{
		s printUser=$P(^DHCPERPT(rptDr),"^",6)
		s:printUser'="" ret="PR"
	}
	q ret
}

/// Description:获取指定状态的前一启用的状态
/// Input:   	
/// 					Code：当前状态代码
/// 					Index：1：前一状态  -1：后一状态			
/// Return:	  		RR：结果录入  CC：粘贴核对 AR：报告审核  PR：报告打印  
/// Creater:	wangguoying
/// CreateDate:	2021-02-04
/// Debug: w ##class(web.DHCPE.WorkDistribution).GetPreActiveFlow("RR")
ClassMethod GetPreActiveFlow(Code, Index = 1)
{
	s typeDr=$O(^User.DHCPEWorkDistributeTypeI("CodeIndex",$$ALPHAUP^SSUTIL4(Code),""))
	s sort=$lg(^User.DHCPEWorkDistributeTypeD(typeDr),4)
	s flag=1,ret=""
	do{
		s sort=$O(^User.DHCPEWorkDistributeTypeI("SortIndex",sort),-1*Index)
		q:sort=""
		s id=$O(^User.DHCPEWorkDistributeTypeI("SortIndex",sort,""))
		s active=$lg(^User.DHCPEWorkDistributeTypeD(id),5)
		i active="Y"  d
		.s ret=$lg(^User.DHCPEWorkDistributeTypeD(id),2)
		.s flag=0
	}while (flag=1)
	q ret
}

/// Description:当前记录 在指定状态下是否可分配
/// Input:   
/// 				PAADM：	就诊ID
/// 				Code：	RR：结果录入  CC：粘贴核对 AR：报告审核  PR：报告打印  			
/// Return:	  0：不可分配 1：可分配
/// Creater:	wangguoying
/// CreateDate:	2021-02-04
/// Debug: w ##class(web.DHCPE.WorkDistribution).IsCanDistribute("RR")
ClassMethod IsCanDistribute(PAADM, Code)
{
	s ret = 0
	s curFlow = ..GetAdmStatus(PAADM)
	q:curFlow="-1" 0
	q:..HadIntoAfterStatus(PAADM,Code)=1 0
	s preFlow = ..GetPreActiveFlow(Code)
	i preFlow = ""{  //当前为第一个启用的分配类型
		i Code = "RR" {
			s:curFlow="0" ret = 1  
		}elseif Code =" CC"{
			s:((curFlow="0")||(curFlow="RR")) ret = 1
		}elseif Code ="AR"{
			s:((curFlow="0")||(curFlow="RR")||(curFlow="CC")) ret = 1
		}elseif Code ="MAR"{
			s:(curFlow="AR") ret = 1
		}elseif Code="PR"{
			s:((curFlow="AR") || (curFlow="MAR")) ret = 1  //报告审核后才可以分配打印
		}else{
			s:curFlow="0" ret = 1  
		}
	}
	q:preFlow="" ret
	
	s docId=$O(^User.DHCPEWorkDistributionI("TypePAADMIndex",preFlow,PAADM,""))  //前一流程分配医生
	i docId'="" d
	.s wkDr=$O(^User.DHCPEWorkDistributionI("TypePAADMIndex",preFlow,PAADM,docId,""))
	.s finish=$lg(^User.DHCPEWorkDistributionD(wkDr),5)
	.s:finish=1 ret=1  ;前一流程已完成
	q ret
}

/// Description:判断当前就诊是否已进入后面的状态
/// Input:   
/// 				PAADM：	就诊ID
/// 				Code：	RR：结果录入  CC：粘贴核对 AR：报告审核  PR：报告打印  			
/// Return:	  0：否  1：是
/// Creater:	wangguoying
/// CreateDate:	2021-08-03
/// Debug: w ##class(web.DHCPE.WorkDistribution).HadIntoAfterStatus("RR")
ClassMethod HadIntoAfterStatus(PAADM, Code)
{
	s ret = 0
	s curFlow = ..GetAdmStatus(PAADM)
	s nextFlow = ..GetPreActiveFlow(Code,-1)
	while (nextFlow'="") && (ret =0){
		i curFlow = nextFlow  s ret =1 q
		s docId=$O(^User.DHCPEWorkDistributionI("TypePAADMIndex",nextFlow,PAADM,""))  //后一流程分配医生
		i docId'="" d
		.s wkDr=$O(^User.DHCPEWorkDistributionI("TypePAADMIndex",nextFlow,PAADM,docId,""))
		.s finish=$lg(^User.DHCPEWorkDistributionD(wkDr),5)
		.s:finish=1 ret=1  
		s nextFlow = ..GetPreActiveFlow(nextFlow,-1)
	}
	q ret
}

/// Description: 查询医生工作量分配情况
/// Input:
/// 						DoctorID：	医生ID   为空时查询需分配未分配人员，不为空时查询分配给该医生的人员信息
/// 						Type：		RR：结果录入  CC：粘贴核对 AR：报告审核  PR：报告打印  	
/// Return:
/// Creater:	wangguoying
/// CreateDate:	2021-02-04
/// Debug：d ##class(%ResultSet).RunQuery("web.DHCPE.WorkDistribution","QueryDistribution","11849","PR","","2020-01-01","2021-12-10","","") 
Query QueryDistribution(DoctorID As %Library.String = "", Type As %Library.String = "AR", RegNo As %Library.String = "", BeginDate As %String, EndDate As %Library.String = "", GroupDR As %Library.String = "", GTeamDR As %Library.String = "", VIPLevel As %Library.String = "") As websys.Query(ROWSPEC = "TPAADM:%String, TRegNo:%String,TPatName:%String,TSex:%String,TAge:%String,TVIPLevel:%String,TCheckDate:%String,TStatus:%String,TReportStatus:%String,TFinishStatus:%String") [ SqlProc ]
{
}

ClassMethod QueryDistributionExecute(ByRef qHandle As %Binary, DoctorID As %Library.String = "", Type As %Library.String = "AR", RegNo As %Library.String = "", BeginDate As %String, EndDate As %Library.String = "", GroupDR As %Library.String = "", GTeamDR As %Library.String = "", VIPLevel As %Library.String = "") As %Status
{
 
	Set repid=$I(^CacheTemp)
 	s ind=1
 	i ((BeginDate="")&(EndDate=""))
 	{
	 	Set qHandle=$lb(0,repid,0)
		Quit $$$OK
 	}
 	//时间段必须有
 	i BeginDate'="" s BeginDate=##class(websys.Conversions).DateHtmlToLogical(BeginDate) 
	i EndDate'=""  s EndDate=##class(websys.Conversions).DateHtmlToLogical(EndDate) 
	i BeginDate="" s BeginDate=+$H-60
	i EndDate="" s EndDate=+$H
	s date=BeginDate-1
	f  s date=$O(^DHCPEIADM(0,"AdmDateTime",date))  q:(date="")||(date>EndDate)  d
	.s time=""
	.f  s time=$O(^DHCPEIADM(0,"AdmDateTime",date,time))  q:time=""  d
	..s iadm=""
	..f  s iadm=$O(^DHCPEIADM(0,"AdmDateTime",date,time,iadm))  q:iadm=""  d
	...s LocFlag=##class(web.DHCPE.PreCommon).GetLocFlag("PEADM",iadm) //Add by 090702
  	...q:LocFlag=1 
	...s status=$p(^DHCPEIADM(iadm),"^",8)
	...q:status'="ARRIVED"		//到达状态
	...s status=##Class(web.DHCPE.PreCommon).TransStatus(status)
	...s paadm=$p(^DHCPEIADM(iadm),"^",1)
	...q:(DoctorID="")&&($D(^User.DHCPEWorkDistributionI("TypePAADMIndex",Type,paadm)))
	...q:(DoctorID'="")&&('$D(^User.DHCPEWorkDistributionI("TypePAADMIndex",Type,paadm,DoctorID)))
	...s canDistribute=..IsCanDistribute(paadm,Type)
	...q:(DoctorID="")&&(canDistribute=0)
	...s piadm=$p(^DHCPEIADM(iadm),"^",4)
	...s gadm=$P(^DHCPEPreIADM(piadm),"^",2)
	...q:(GroupDR'="")&&(gadm'=GroupDR)
	...s team=$P(^DHCPEPreIADM(piadm),"^",3)
	...q:(GTeamDR'="")&&(team'=GTeamDR)
	...s vip=##class(web.DHCPE.PreCommon).GetVIPLevel("Pre", piadm)
	...q:(VIPLevel'="")&&(+vip'=VIPLevel)
	...s vipDesc=$P(vip,"^",2)
	...s pibi=$P(^DHCPEPreIADM(piadm),"^",1)
	...s regNo=$P(^DHCPEPreIBI(pibi),"^",1)
	...q:(RegNo'="")&&(regNo'=RegNo)
	...s patName=$P(^DHCPEPreIBI(pibi),"^",2)
	...s age=$p($g(^DHCPEPreIBI(pibi)),"^",4)
	...i age'="" s age=##class(web.DHCDocCommon).GetAgeDescNew($zd(age,3),"")
	...s sex=$p($g(^DHCPEPreIBI(pibi)),"^",3)
	...i sex'="" s sex=$P(^CT("SEX",sex),"^",2)	
	...s rptStatDesc="未审核"
	...s rptId=$O(^DHCPERPT(0,"IADM",iadm,""))
	...i rptId'="" d
	....s rptStst=$P(^DHCPERPT(rptId),"^",2)
	....s rptStatDesc=##class(web.DHCPE.Report).GetStatusDesc(rptStst,paadm)
	...s finishStatus="未完成"
	...i DoctorID'=""  d //只有分配状态的 才存在完成的情况
	....s wkDr=$O(^User.DHCPEWorkDistributionI("TypePAADMIndex",Type,paadm,DoctorID,""))
	....s finishFlag=$lg(^User.DHCPEWorkDistributionD(wkDr),5)
	....s:finishFlag=1 finishStatus="已完成"
	...d OutputRowData1
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK

OutputRowData1
   	set Data=$lb(paadm, regNo,patName,sex,age,vipDesc,$ZD(date,3),status,rptStatDesc,finishStatus)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

/// Description:查询待办列表
/// Input:   	
/// Return:	 
/// Creater:	wangguoying
/// CreateDate:	2021-02-04
/// Debug: w ##class(web.DHCPE.WorkDistribution).GetTasks(11849,164,304)
ClassMethod GetTasks(UserID, GroupID, LocID, FlowCode = "")
{
	s ret=[]
	s sort=""
	f   s sort=$O(^User.DHCPEWorkDistributeTypeI("SortIndex",sort))  q:sort=""  d
	.s flow=""
	.f  s flow=$O(^User.DHCPEWorkDistributeTypeI("SortIndex",sort,flow))  q:flow=""  d
	..s active=$lg(^User.DHCPEWorkDistributeTypeD(flow),5)
	..q:active'="Y"
	..q:'$D(^User.DHCPEWorkDoctorI("ParRefDocGpLocIndex",flow,UserID,GroupID,LocID))
	..s flowObj={}
	..s flowObj.code=$lg(^User.DHCPEWorkDistributeTypeD(flow),2)
	..q:(FlowCode'="")&&(flowObj.code'=FlowCode)
	..s flowObj.desc=$lg(^User.DHCPEWorkDistributeTypeD(flow),3)
	..s flowObj.csp=$lg(^User.DHCPEWorkDistributeTypeD(flow),6)
	..s rowNum=0
	..s rowsArr=[]
	..s paadm=""
	..f  s paadm=$O(^User.DHCPEWorkDistributionI("TypeReceiverDRIndex",flowObj.code,UserID,paadm))  q:paadm=""  d
	...s locFlag = ##class(web.DHCPE.PreCommon).GetLocFlag("PreADM",piadm,LocID)
	...q:locFlag=1
	...s wkDr=$O(^User.DHCPEWorkDistributionI("TypeReceiverDRIndex",flowObj.code,UserID,paadm,""))
	...s finish=$lg(^User.DHCPEWorkDistributionD(wkDr),5)
	...q:finish=1
	...s rowNum=rowNum+1
	...s rowObj={}
	...d SetRowObj
	...d rowsArr.%Push(rowObj)
	
	..s flowObj.total=rowNum
	..s flowObj.rows=rowsArr
	..d ret.%Push(flowObj)
	
	q ret.%ToJSON()
SetRowObj
	s rowObj.paadm=paadm
	s iadm=$O(^DHCPEIADM(0,"PAADM",paadm,""))
	s piadm=$P(^DHCPEIADM(iadm),"^",4)
	s curLoc = $P(^DHCPEPreIADM(piadm),"^",26)
	
	s checkDate=$P(^DHCPEIADM(iadm),"^",5)
	s pibi=$P(^DHCPEPreIADM(piadm),"^",1)
	s regNo=$p(^DHCPEPreIBI(pibi),"^",1)
	s patName=$P(^DHCPEPreIBI(pibi),"^",2)
	s age=$p($g(^DHCPEPreIBI(pibi)),"^",4)
	i age'="" s age=##class(web.DHCDocCommon).GetAgeDescNew($zd(age,3),"")
	s sex=$p($g(^DHCPEPreIBI(pibi)),"^",3)
	i sex'="" s sex=$P(^CT("SEX",sex),"^",2)	
	s vip=##class(web.DHCPE.PreCommon).GetVIPLevel("Pre", piadm)
	s vipDesc=$P(vip,"^",2)
	s rptStatDesc="未审核"
	s rptId=$O(^DHCPERPT(0,"IADM",iadm,""))
	i rptId="" d
	.s rptStst=$P(^DHCPERPT(rptId),"^",2)
	.s rptStatDesc=##class(web.DHCPE.Report).GetStatusDesc(rptStst)
	s rowObj.regNo=regNo
	s rowObj.patName=patName
	s rowObj.age=age
	s rowObj.sex=sex
	s rowObj.vipLevel=vip
	s rowObj.vipDesc=vipDesc
	s rowObj.checkDate=$ZD(checkDate,3)
	s rowObj.rptStat=rptStatDesc
	//s rowObj.flowCode=flowObj.code
	q
}

/// Description:完成任务
/// Input:   
/// 				PAADM：	就诊ID
/// 				Code：	RR：结果录入  CC：粘贴核对 AR：报告审核  PR：报告打印  
/// 					UserID: 完成人	
/// Return:	 ""：成功 非空：失败
/// Creater:	wangguoying
/// CreateDate:	2021-02-05
/// Debug: w ##class(web.DHCPE.WorkDistribution).FinishTask(11849,164,304)
ClassMethod FinishTask(PAADM, Code, UserID = "")
{
	i UserID'=""
	{
		s:$D(%session) UserID=%session.Get("LOGON.USERID")
		s:UserID="" UserID=1
	}
	s wkDr=$O(^User.DHCPEWorkDistributionI("TypeReceiverDRIndex",Code,UserID,PAADM,""))
	q:wkDr="" "不存在该任务"
	s finish=$lg(^User.DHCPEWorkDistributionD(wkDr),5)
	q:finish=1 "任务已经完成"
	s properties="WDFinish^WDFinishDate^WDFinishTime"
	s vals="1^"_+$H_"^"_$P($H,",",2)
	s save=##class(User.DHCPEWorkDistribution).SaveData(wkDr,vals,properties)
	q:+save<=0 $P(save,"^",2)
	q ""
}

/// Description:查询分配类型 步骤JSON
/// Input:   	
/// Return:	 
/// Creater:	wangguoying
/// CreateDate:	2021-02-07
/// Debug: w ##class(web.DHCPE.WorkDistribution).GetFlowSetpJSON()
ClassMethod GetFlowSetpJSON(LocID As %String = "")
{
	s relate=[]  //对照数据
	s itemArr=[]  //节点数组
	s ind=1
	s begin={"ind":(ind),"code":"","desc":"开始"}
	d relate.%Push(begin)
	d itemArr.%Push({"context":"开始"})
	
	s rs=##class(%ResultSet).%New("web.DHCPE.CT.WorkDistribution:QueryWorkType") 
	d rs.Execute("","","",LocID)
	while(rs.Next())
	{
		s ind=ind+1
		s obj={"ind":(ind),"code":(rs.Get("TCode")),"desc":(rs.Get("TDesc"))}
		d relate.%Push(obj)
		d itemArr.%Push({"context":(rs.Get("TDesc"))})
	}
	
	s ind=ind+1
	s end={"ind":(ind),"code":"","desc":"结束"}
	d relate.%Push(end)
	d itemArr.%Push({"context":"结束"})
	
	s ret={"_FlowRelate":(relate),"items":(itemArr)}
	q ret.%ToJSON()
}

/// Description:新增业务类型
/// Input:   
/// 				CurCode：当前业务代码	
/// 				Flag： 1：在前方插入，2：在后方插入
/// 				Instring：代码^描述	
/// Return:	""：成功 非空：失败
/// Creater:	wangguoying
/// CreateDate:	2021-02-03
/// Debug: w ##class(web.DHCPE.WorkDistribution).InsertFlowType()
ClassMethod InsertFlowType(CurCode, Flag, Instring)
{
	s curId=$O(^User.DHCPEWorkDistributeTypeI("CodeIndex",$$ALPHAUP^SSUTIL4(CurCode),""))
	q:curId="" "当前节点无效"
	s curSort=$lg(^User.DHCPEWorkDistributeTypeD(curId),4)
	s preSort=+$O(^User.DHCPEWorkDistributeTypeI("SortIndex",curSort),-1)
	s sufSort=+$O(^User.DHCPEWorkDistributeTypeI("SortIndex",curSort))
	s:sufSort=0 sufSort=10000  ;设置大一些    
	s sort=0   ;新插入节点的顺序号  取前后两个节点的中位数   系统默认节点差距为100  就是为了新插节点时有足够多的顺序号可使用
	i Flag=1
	{
		s sort=preSort+((curSort-preSort)/2)
	}else{
		s sort=curSort+((sufSort-curSort)/2)
	}
	s code=$p(Instring,"^",1)
	q:$D(^User.DHCPEWorkDistributeTypeI("CodeIndex",$$ALPHAUP^SSUTIL4(code))) "代码已存在"
	s properties="WDTCode^WDTDesc^WDTSort"
	s vals=code_"^"_$p(Instring,"^",2)_"^"_sort
	s save=##class(User.DHCPEWorkDistributeType).SaveData("",vals,properties)
	q:+save<=0 $P(save,"^",2)
	q ""
}

/// Description:删除业务类型
/// Input:   
/// 				Code：业务代码		
/// Return:	""：成功 非空：失败
/// Creater:	wangguoying
/// CreateDate:	2021-02-03
/// Debug: w ##class(web.DHCPE.WorkDistribution).DeleteFlowType()
ClassMethod DeleteFlowType(Code)
{
	s id=$O(^User.DHCPEWorkDistributeTypeI("CodeIndex",$$ALPHAUP^SSUTIL4(Code),""))
	q:id="" "代码无效"
	s sys=$lg(^User.DHCPEWorkDistributeTypeD(id),6)
	q:sys="Y" "系统节点不允许删除"
	s delete=##class(User.DHCPEWorkDistributeType).Delete(id)
	q:+delete'="" $P(delete,"^",2)
	q ""
}

/// Description: 查询工作类型CSP
/// Input:
/// 						Code：	业务代码
/// Return:
/// Creater:	wangguoying
/// CreateDate:	2021-02-07
/// Debug：d ##class(%ResultSet).RunQuery("web.DHCPE.WorkDistribution","QueryWorkLinkUrl","RR") 
Query QueryWorkLinkUrl(Code As %Library.String = "") As websys.Query(ROWSPEC = "TID:%String, TTitle:%String,TSort:%String,TUrl:%String") [ SqlProc ]
{
}

ClassMethod QueryWorkLinkUrlExecute(ByRef qHandle As %Binary, Code As %Library.String = "") As %Status
{
 
	Set repid=$I(^CacheTemp)
 	s ind=1
 	s parRef=$O(^User.DHCPEWorkDistributeTypeI("CodeIndex",$$ALPHAUP^SSUTIL4(Code),""))
 	i parRef=""
 	{
	 	Set qHandle=$lb(0,repid,0)
		Quit $$$OK
 	}
 	s sort=""
 	f  s sort=$O(^User.DHCPEWorkLinkUrlI("ParSortIndex",parRef,sort))  q:sort=""  d
 	.s sub=""
 	.f  s sub=$O(^User.DHCPEWorkLinkUrlI("ParSortIndex",parRef,sort,sub))  q:sub=""  d
 	..s id=parRef_"||"_sub
 	..s title=$lg(^User.DHCPEWorkDistributeTypeD(parRef,"WDTWUrl",sub),2)
 	..s url=$lg(^User.DHCPEWorkDistributeTypeD(parRef,"WDTWUrl",sub),3) 	
	..d OutputRowData
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK

OutputRowData
   	set Data=$lb(id, title,sort,url)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

/// Description:新增链接CSP
/// Input:   
/// 				Code：业务代码	
/// 				Instring：标题^CSP^序号
/// Return:	""：成功 非空：失败
/// Creater:	wangguoying
/// CreateDate:	2021-02-07
/// Debug: w ##class(web.DHCPE.WorkDistribution).InsertLinkUrl("RR","站点^dhcpe.123.csp^1")
ClassMethod InsertLinkUrl(Code, Instring)
{
	s parRef=$O(^User.DHCPEWorkDistributeTypeI("CodeIndex",$$ALPHAUP^SSUTIL4(Code),""))
	q:parRef="" "当前节点无效"
	s sort = $P(Instring,"^",3)
	q:$D(^User.DHCPEWorkLinkUrlI("ParSortIndex",parRef,sort)) "顺序号已存在"
	s properties="WLUParRef^WLUTitle^WLULink^WLUSort"
	s vals=parRef_"^"_Instring
	s save=##class(User.DHCPEWorkLinkUrl).SaveData("",vals,properties)
	q:+save<=0 $P(save,"^",2)
	q ""
}

/// Description:根据类型获取CSP地址
/// Input:   
/// 				Code：业务代码	
/// Return:	标题$C(1)_地址$C(0)标题$C(1)_地址$C(2)默认选中（Y）
/// Creater:	wangguoying
/// CreateDate:	2021-02-07
/// Debug: w ##class(web.DHCPE.WorkDistribution).GetLinkUrl("RR")
ClassMethod GetLinkUrl(Code, PAADM)
{
	s parRef=$O(^User.DHCPEWorkDistributeTypeI("CodeIndex",$$ALPHAUP^SSUTIL4(Code),""))
	q:parRef="" ""
	s ret=""
	i Code="RR" ;结果录入
	{
		s sort=$O(^User.DHCPEWorkLinkUrlI("ParSortIndex",parRef,""))  ;只取第一个地址
		s sub=$O(^User.DHCPEWorkLinkUrlI("ParSortIndex",parRef,sort,""))
		s url=$lg(^User.DHCPEWorkDistributeTypeD(parRef,"WDTWUrl",sub),3) 
			
		s default=##class(web.DHCPE.DocPatientFind).GetDefaultStation()
		s stationInfo=##class(web.DHCPE.DocPatientFind).GetStationList(PAADM)
		f i=1:1:$l(stationInfo,",")
		{
			s item=$p(stationInfo,",",i)
			s stationId=$p(item,"^",1)
			s stationDesc=$p(item,"^",2)
			s curUrl=$Replace(url,"${EpisodeID}",PAADM)
			s curUrl=$Replace(curUrl,"${StationID}",stationId)
			s:default=stationId curUrl=curUrl_$C(2)_"Y"
			i ret'=""  s ret=ret_$C(0)_stationDesc_$C(1)_curUrl
 			e  s ret=stationDesc_$C(1)_curUrl
		}
		q ret
	}
	
	
	s sort=""
 	f  s sort=$O(^User.DHCPEWorkLinkUrlI("ParSortIndex",parRef,sort))  q:sort=""  d
 	.s sub=""
 	.f  s sub=$O(^User.DHCPEWorkLinkUrlI("ParSortIndex",parRef,sort,sub))  q:sub=""  d
 	..s title=$lg(^User.DHCPEWorkDistributeTypeD(parRef,"WDTWUrl",sub),2)
 	..s url=$lg(^User.DHCPEWorkDistributeTypeD(parRef,"WDTWUrl",sub),3) 
 	..s url=$Replace(url,"${EpisodeID}",PAADM)
 	..i ret'=""  s ret=ret_$C(0)_title_$C(1)_url
 	..e  s ret=title_$C(1)_url
 	q ret
}

/// Description:报告初审时  输出复审人选择框
/// Input:   
/// 				UserID：初审提交医生	
/// Return:	
/// Creater:	wangguoying
/// CreateDate:	2021-02-07
/// Debug: d ##class(web.DHCPE.WorkDistribution).OutMainDoctor(11849)
ClassMethod OutMainDoctor(AuditUser)
{
	s flowId=$O(^User.DHCPEWorkDistributeTypeI("CodeIndex","MAR",""))  ;复审流程id
	s active=$lg(^User.DHCPEWorkDistributeTypeD(flowId),5)
	q:active'="Y"	;未启用分配
	s doctors=..GetDocKeysByType("MAR")
	q:doctors="[]" ;未分配复审医生

	w "<td class='r-label'><label>指定复审医生</label></td>"
	w "<td style='width:128px;'>"
	w "<select id='AppointMUser' class='hisui-combogrid'  style='width:120px;'> </select>"
	w "</td>"
	q
}

ClassMethod GetLastAppointMUser(AuditUser)
{
	s lastAppointUser=$G(^DHCPEDataEx("AppointMUser",AuditUser))	;上一次指定的人
	s:lastAppointUser'="" lastAppointUser=$p(lastAppointUser,"^",1)
	q lastAppointUser
}

}
