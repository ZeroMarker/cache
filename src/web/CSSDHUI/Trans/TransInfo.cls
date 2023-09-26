Import sqluser

Class web.CSSDHUI.Trans.TransInfo Extends (%RegisteredObject, web.CSSDHUI.CSSDType) [ Not ProcedureBlock ]
{

/// Descript:	消毒包跟踪
/// Creator:	wfg
/// CreateDate:	2019-7-11
/// Table:		cssd_trans
/// Input:		排序，查询条件
/// Return：	消毒包跟踪信息
/// w ##class(web.CSSDHUI.Trans.TransInfo).QueryInfo("{""Label"":""100006001000001"",""gUserId"":""11889"",""gLocId"":""166"",""gGroupId"":""102"",""gHospId"":""2""}")
ClassMethod QueryInfo(Params)
{
	n (qHandle,Params)
	s PJObj=##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	q:Sc'=0 "[]"
	s Label=PJObj.%Get("Label")
	
	s QueryParam="{""Label"":"""_Label_""",""OnlyLabel"":""Y""}"
	s ResultSet=##class(%Library.ResultSet).%New("web.CSSDHUI.Stat.TransStat:QueryTrans")
	s Sc=ResultSet.Execute(QueryParam)
	i $$$ISERR(Sc)||('ResultSet.Next()) q "[]"
	
	;消毒包
	s TransId=ResultSet.%Get("TransId"),Status=ResultSet.%Get("Status"),StatusDesc=ResultSet.%Get("StatusDesc")
	s CodeDict=ResultSet.%Get("CodeDict"),PkgDesc=ResultSet.%Get("PkgDesc"),ExpDate=ResultSet.%Get("ExpDate")
	s AttributeDesc=ResultSet.%Get("AttributeDesc")
	;回收
	s CBId=ResultSet.%Get("CBId"),CBNo=ResultSet.%Get("CBNo"),CBLocDesc=ResultSet.%Get("CBLocDesc")
	s CBDateTime=ResultSet.Data("CBDateTime"),CBUserName=ResultSet.%Get("CBUserName")
	s CBAckUserName=ResultSet.%Get("CBAckUserName"),CBAckDateTime=ResultSet.%Get("CBAckDateTime")
	s CBFromLocDesc=ResultSet.%Get("CBFromLocDesc")
	s CBDateTime=$e(CBDateTime,1,*-3)
	s CBAckDateTime=$e(CBAckDateTime,1,*-3)
	;打包
	s PackId=ResultSet.%Get("PackId"),PackToLocDesc=ResultSet.%Get("PackToLocDesc")
	s PackMaterialDesc=ResultSet.%Get("PackMaterialDesc"),PackUserName=ResultSet.%Get("PackUserName"),PackDateTime=ResultSet.%Get("PackDateTime")
	s PackAckDate=ResultSet.%Get("PackAckDate"),PackAckUserName=ResultSet.%Get("PackAckUserName"),PackLocDesc=ResultSet.%Get("PackLocDesc")
	s PackDateTime=$e(PackDateTime,1,*-3)
	;发放
	s DispItmId=ResultSet.%Get("DispItmId"),DispNo=ResultSet.%Get("DispNo"),DispLocDesc=ResultSet.%Get("DispLocDesc")
	s DispUserName=ResultSet.%Get("DispUserName"),DispDateTime=ResultSet.%Get("DispDateTime")
	s ToLocDesc=ResultSet.%Get("ToLocDesc"),ToUserName=ResultSet.%Get("ToUserName"),ReceiveDateTime=ResultSet.%Get("ReceiveDateTime")
	s DispDateTime=$e(DispDateTime,1,*-3),ReceiveDateTime=$e(ReceiveDateTime,1,*-3)
	
	;使用
	s PatientId=ResultSet.%Get("PatientId"),PatientName=ResultSet.%Get("PatientName"),OprDoctorName=ResultSet.%Get("OprDoctorName")
	s InstNurseName=ResultSet.%Get("InstNurseName"),CircNurseName=ResultSet.%Get("CircNurseName"),OprDateTime=ResultSet.%Get("OprDateTime")
	s OprRoomDesc=ResultSet.%Get("OprRoomDesc"),OprRoomNo=ResultSet.%Get("OprRoomNo"),AdmLocDesc=ResultSet.%Get("AdmLocDesc")
	s InfectDesc=ResultSet.%Get("InfectDesc")
	s OprDateTime=$e(OprDateTime,1,*-3)
	
	q:TransId="" "[]"
	
	s Pid=..NewPid()
	k ^TMPCSSD(Pid)
	
	s StepInfo=""
	s Title="title^context"
	
	s TransObj=##Class(User.CSSDTrans).%OpenId(TransId)
	s CallMainObj=TransObj.CSSDTCallBack
	s CleanDetailObj=TransObj.CSSDTClean
	s PackObj=TransObj.CSSDTPack
	s SterDetailObj=TransObj.CSSDTSterilize
	s AllSterilize=TransObj.CSSDTAllSterilize
	s DispObj=TransObj.CSSDTDisp
	
	;消毒包信息
	s ContextStr=
		"<div style='margin-left:30px;'>"
			_"<div style='font-weight:normal;margin-top:0px;'>"
				_"<p style='font-size:14px;margin-right:50px;width:200px;'>包名称："_PkgDesc_"</p>"
				_"<p style='font-size:14px;margin-right:50px;width:200px;'>标签："_Label_"</p>"
				_"<p style='font-size:14px;margin-right:50px;width:200px;'>当前状态："_StatusDesc_"</p>"
				_"<p style='font-size:14px;margin-right:50px;width:200px;'>包属性："_AttributeDesc_"</p>"
			_"</div>"
			_"<div style='font-weight:normal;margin-top:0px;'>"
				_"<p style='font-size:14px;margin-right:50px;width:200px;'>失效日期："_ExpDate_"</p>"
				_"<p style='font-size:14px;margin-right:50px;width:200px;'>标牌："_CodeDict_"</p>"
			_"</div>"
		_"</div>"
	s Data="标签信息^"_ContextStr
	s StepStr=##class(web.CSSDHUI.Common.UtilCommon).GetJsonStr(Data,Title)
	i StepInfo="" s StepInfo=StepStr
	e  s StepInfo=StepInfo_","_StepStr
	
	;清洗详情
	i $IsObject(CleanDetailObj) d
	.s CleanDetailId=CleanDetailObj.%Id()
	.d ..GetCleanInfo(Pid,CleanDetailId)
	.
	.s num=0
	.s DetailId=0
	.f  s DetailId=$o(^TMPCSSD(Pid,"CleanDetail",DetailId)) q:DetailId=""  d
	..s num=num+1
	..s CleanStr=^TMPCSSD(Pid,"CleanDetail",DetailId)
	..
	..i num=1 s title="清洗信息"
	..e  s title=num_"次清洗"
	..
	..s Data=title_"^"_CleanStr
	..s StepStr=##class(web.CSSDHUI.Common.UtilCommon).GetJsonStr(Data,Title)
	..i StepInfo="" s StepInfo=StepStr
	..e  s StepInfo=StepInfo_","_StepStr
	
	;配包
	i PackId'="" d
	.s PackStr="<div style='margin-left:30px;'>"
	.s PackStr=PackStr_"<div style='font-weight:normal;margin-top:0px;'>"
	.s PackStr=PackStr_"<p style='font-size:14px;margin-right:50px;width:200px;'>配包时间："_PackDateTime_"</p>"
	.s PackStr=PackStr_"<p style='font-size:14px;margin-right:50px;width:200px;'>包装材料："_PackMaterialDesc_"</p>"
	.s PackStr=PackStr_"<p style='font-size:14px;margin-right:50px;width:200px;'>配包人："_PackUserName_"</p>"
	.s PackStr=PackStr_"<p style='font-size:14px;margin-right:50px;width:200px;'>审核人："_PackAckUserName_"</p>"
	.s PackStr=PackStr_"</div>"
	.s PackStr=PackStr_"<div style='font-weight:normal;margin-top:0px;'>"
	.s PackStr=PackStr_"<p style='font-size:14px;margin-right:50px;width:200px;'>审核日期："_PackAckDate_"</p>"
	.s PackStr=PackStr_"<p style='font-size:14px;margin-right:50px;width:200px;'>接收科室："_PackToLocDesc_"</p>"
	.s PackStr=PackStr_"</div>"
	.s PackStr=PackStr_"</div>"
	.
	.s Data="配包信息^"_PackStr
	.s StepStr=##class(web.CSSDHUI.Common.UtilCommon).GetJsonStr(Data,Title)
	.i StepInfo="" s StepInfo=StepStr
	.e  s StepInfo=StepInfo_","_StepStr

	;灭菌
	i $IsObject(SterDetailObj) d
	.s SterDetailId=SterDetailObj.%Id()
	.;灭菌不合格
	.i AllSterilize'="" d
	..s Len=$L(AllSterilize,"#") 
	..f j=1:1:Len  d
	...s SterFailDetailId=$p(AllSterilize,"#",j)
	...i j=1 d
	....s SterFailStr=..SetSterInfo(SterFailDetailId)	;第一次灭菌不合格，流程信息为灭菌
	....s Data="灭菌信息^"_SterFailStr
	....s StepStr=##class(web.CSSDHUI.Common.UtilCommon).GetJsonStr(Data,Title)
	....i StepInfo="" s StepInfo=StepStr
	....e  s StepInfo=StepInfo_","_StepStr
	...e  d 
	....s SterStr=..SetSterInfo(SterFailDetailId)	;否则流程都是重新灭菌
	....s Data=j_"次灭菌^"_SterStr
	....s StepStr=##class(web.CSSDHUI.Common.UtilCommon).GetJsonStr(Data,Title)
	....i StepInfo="" s StepInfo=StepStr
	....e  s StepInfo=StepInfo_","_StepStr
	
	;发放
	i DispItmId'="" d
	.s DispStr="<div style='margin-left:30px;'>"
	.s DispStr=DispStr_"<div style='font-weight:normal;margin-top:0px;'>"
	.s DispStr=DispStr_"<p style='font-size:14px;margin-right:50px;width:200px;'>发放时间："_DispDateTime_"</p>"
	.s DispStr=DispStr_"<p style='font-size:14px;margin-right:50px;width:200px;'>发放单："_DispNo_"</p>"
	.s DispStr=DispStr_"<p style='font-size:14px;margin-right:50px;width:200px;'>发放科室："_DispLocDesc_"</p>"
	.s DispStr=DispStr_"<p style='font-size:14px;margin-right:50px;width:200px;'>发放人："_DispUserName_"</p>"
	.s DispStr=DispStr_"</div>"
	.
	.s DispStr=DispStr_"<div style='font-weight:normal;margin-top:0px;'>"
	.s DispStr=DispStr_"<p style='font-size:14px;margin-right:50px;width:200px;'>接收时间："_ReceiveDateTime_"</p>"
	.s DispStr=DispStr_"<p style='font-size:14px;margin-right:50px;width:200px;'>接收科室："_ToLocDesc_"</p>"
	.s DispStr=DispStr_"<p style='font-size:14px;margin-right:50px;width:200px;'>接收人："_ToUserName_"</p>"
	.s DispStr=DispStr_"</div>"
	.s DispStr=DispStr_"</div>"
	.
	.s Data="发放信息^"_DispStr
	.s StepStr=##class(web.CSSDHUI.Common.UtilCommon).GetJsonStr(Data,Title)
	.i StepInfo="" s StepInfo=StepStr
	.e  s StepInfo=StepInfo_","_StepStr
	
	;使用信息
	i PatientId'="" d
	.s PatientStr="<div style='margin-left:30px;'>"
	.s PatientStr=PatientStr_"<div style='font-weight:normal;margin-top:0px;'>"
	.s PatientStr=PatientStr_"<p style='font-size:14px;margin-right:50px;width:200px;'>患者ID："_PatientId_"</p>"
	.s PatientStr=PatientStr_"<p style='font-size:14px;margin-right:50px;width:200px;'>患者姓名："_PatientName_"</p>"
	.s PatientStr=PatientStr_"<p style='font-size:14px;margin-right:50px;width:200px;'>手术医生："_OprDoctorName_"</p>"
	.s PatientStr=PatientStr_"<p style='font-size:14px;margin-right:50px;width:200px;'>器械护士："_InstNurseName_"</p>"
	.s PatientStr=PatientStr_"</div>"
	.s PatientStr=PatientStr_"<div style='font-weight:normal;margin-top:0px;'>"
	.s PatientStr=PatientStr_"<p style='font-size:14px;margin-right:50px;width:200px;'>巡回护士："_CircNurseName_"</p>"
	.s PatientStr=PatientStr_"<p style='font-size:14px;margin-right:50px;width:200px;'>手术日期："_OprDateTime_"</p>"
	.s PatientStr=PatientStr_"<p style='font-size:14px;margin-right:50px;width:200px;'>手术间："_OprRoomDesc_"</p>"
	.s PatientStr=PatientStr_"<p style='font-size:14px;margin-right:50px;width:200px;'>手术间号："_OprRoomNo_"</p>"
	.s PatientStr=PatientStr_"</div>"
	.s PatientStr=PatientStr_"<div style='font-weight:normal;margin-top:0px;'>"
	.s PatientStr=PatientStr_"<p style='font-size:14px;margin-right:50px;width:200px;'>使用科室："_AdmLocDesc_"</p>"
	.s PatientStr=PatientStr_"<p style='font-size:14px;margin-right:50px;width:200px;'>感染名称："_InfectDesc_"</p>"
	.s PatientStr=PatientStr_"</div>"
	.s PatientStr=PatientStr_"</div>"
	.
	.s Data="患者信息^"_PatientStr
	.s StepStr=##class(web.CSSDHUI.Common.UtilCommon).GetJsonStr(Data,Title)
	.i StepInfo="" s StepInfo=StepStr
	.e  s StepInfo=StepInfo_","_StepStr
	
	;回收
	i CBId'="" d
	.s CallBackStr="<div style='margin-left:30px;'>"
	.s CallBackStr=CallBackStr_"<div style='font-weight:normal;margin-top:0px;'>"
	.s CallBackStr=CallBackStr_"<p style='font-size:14px;margin-right:50px;width:200px;'>回收时间："_CBDateTime_"</p>"
	.s CallBackStr=CallBackStr_"<p style='font-size:14px;margin-right:50px;width:200px;'>回收单："_CBNo_"</p>"
	.s CallBackStr=CallBackStr_"<p style='font-size:14px;margin-right:50px;width:200px;'>回收科室："_CBLocDesc_"</p>"
	.s CallBackStr=CallBackStr_"<p style='font-size:14px;margin-right:50px;width:200px;'>回收人："_CBUserName_"</p>"
	.s CallBackStr=CallBackStr_"</div>"
	.s CallBackStr=CallBackStr_"<div style='font-weight:normal;margin-top:0px;'>"
	.s CallBackStr=CallBackStr_"<p style='font-size:14px;margin-right:50px;width:200px;'>提交时间："_CBAckDateTime_"</p>"
	.s CallBackStr=CallBackStr_"<p style='font-size:14px;margin-right:50px;width:200px;'>提交人："_CBAckUserName_"</p>"
	.s CallBackStr=CallBackStr_"<p style='font-size:14px;margin-right:50px;width:200px;'>申请科室："_CBFromLocDesc_"</p>"
	.s CallBackStr=CallBackStr_"</div>"
	.s CallBackStr=CallBackStr_"</div>"
	.
	.s Data="回收信息^"_CallBackStr
	.s StepStr=##class(web.CSSDHUI.Common.UtilCommon).GetJsonStr(Data,Title)
	.i StepInfo="" s StepInfo=StepStr
	.e  s StepInfo=StepInfo_","_StepStr
	
	s StepInfo="["_StepInfo_"]"
	k ^TMPCSSD(Pid)
	q StepInfo
}

/// Creator:ban
/// CreatDate:2022-3-15
/// Description:根据灭菌明细Id获取灭菌追踪信息
/// Table:CSSD_PackageSterilize
/// w ##class(web.CSSDHUI.Trans.TransInfo).SetSterInfo()
ClassMethod SetSterInfo(SterDetailId As %String) As %Library.String
{
	n (SterDetailId)
	q:SterDetailId="" ""
	s SterDetailObj=##class(User.CSSDPackageSterilize).%OpenId(SterDetailId)
	q:SterDetailObj="" ""
	d SterDetailObj.%Reload()
	q:'$IsObject(SterDetailObj) ""
	;召回标志
	s RecallFlag=SterDetailObj.CSSDPSRecallFlag
	s SterStatus=SterDetailObj.CSSDPSStates
	s SterMainObj=SterDetailObj.CSSDPSParref
	q:'$IsObject(SterMainObj) ""
	
	s (SterUserName,SterCheckerName,SterProgressName,MachineName,SterWayName)=""
	
	s BatchNo=SterMainObj.CSSDSRNo					;灭菌批号
	s MachineNo=SterMainObj.CSSDSRMachineNo			;灭菌器号
	s MachineObj=SterMainObj.CSSDSRMachineNoDR
	s SterUserObj=SterMainObj.CSSDSRUserDr
	s SterDate=SterMainObj.CSSDSRDate
	s SterTime=SterMainObj.CSSDSRTime
	s SterCheckerObj=SterMainObj.CSSDSRCHKUserDR
	s SterCheckDate=SterMainObj.CSSDSRCheckDate
	s SterCheckTime=SterMainObj.CSSDSRCHKTime
	s SterCheckResult=SterDetailObj.CSSDPSStates
	s SterProgressObj=SterMainObj.CSSDSRProgressDR
	s SterPhyResult=SterMainObj.CSSDSRPhyResult
	s SterBioResult=SterMainObj.CSSDSRBatLabel
	s SterCheResult=SterMainObj.CSSDSRCheResult
	s SterIsPhy=SterMainObj.CSSDSRIsPhy
	s SterIsChe=SterMainObj.CSSDSRIsChe
	s SterIsBio=SterMainObj.CSSDSRIsBio
	
	i $IsObject(MachineObj) d
	.s MachineName=MachineObj.CSSDMCAlias
	.s SterWay=MachineObj.CSSDMCTempType
	.i SterWay'="" d
	..s SterWayObj=##class(User.CSSDSterType).%OpenId(SterWay)
	..i $IsObject(SterWayObj) s SterWayName =SterWayObj.CSSDSTSterName
	
	i $IsObject(SterUserObj) d
	.s SterUserDr=SterUserObj.%Id()
	.s SterUserName=$p($g(^SSU("SSUSR",SterUserDr)),"^",2)
	i $IsObject(SterCheckerObj) d
	.s SterCheckerDr=SterCheckerObj.%Id()
	.s SterCheckerName=$p($g(^SSU("SSUSR",SterCheckerDr)),"^",2)
	
	s:SterDate'="" SterDate=..DL2H(SterDate)
	s:SterTime'="" SterTime=..TL2H(SterTime)
	s SterDateTime=SterDate_" "_SterTime
	s SterDateTime=$e(SterDateTime,1,*-3)
	s:SterCheckDate'="" SterCheckDate=..DL2H(SterCheckDate)
	s:SterCheckTime'="" SterCheckTime=..TL2H(SterCheckTime)
	s SterCheckDateTime=SterCheckDate_" "_SterCheckTime
	s SterCheckDateTime=$e(SterCheckDateTime,1,*-3)
	
	i SterCheckResult="Y" s SterCheckResult="合格"
	e  i SterCheckResult="N" s SterCheckResult="验收不合格"
	e  s SterCheckResult="未验收"
	
	i $IsObject(SterProgressObj) d
	.s SterProgressName = SterProgressObj.CSSDDCName
	
	i SterIsPhy="Y" d
	.i SterPhyResult="1" s SterPhyResult="物理监测合格"
	.e  i SterPhyResult="2" s SterPhyResult="物理监测不合格"
	.e  s SterPhyResult=""
	i SterIsChe="Y" d
	.i SterCheResult="1" s SterCheResult="化学监测合格"
	.e  i SterCheResult="2" s SterCheResult="化学监测不合格"
	.e  s SterCheResult=""
	i SterIsBio="Y" d
	.i SterBioResult="1" s SterBioResult="生物监测合格"
	.e  i SterBioResult="2" s SterBioResult="生物监测不合格"
	.e  s SterBioResult=""
	
	s SterStr=
		"<div style='margin-left:30px;'>"
			_"<div style='font-weight:normal;margin-top:0px;'>"
				_"<p style='font-size:14px;margin-right:50px;width:200px;'>灭菌时间："_SterDateTime_"</p>"
				_"<p style='font-size:14px;margin-right:50px;width:200px;'>灭菌器："_MachineName_"</p>"
				_"<p style='font-size:14px;margin-right:50px;width:200px;'>灭菌方式："_SterWayName_"</p>"
				_"<p style='font-size:14px;margin-right:50px;width:200px;'>灭菌程序："_SterProgressName_"</p>"
			_"</div>"
			_"<div style='font-weight:normal;margin-top:0px;'>"
				_"<p style='font-size:14px;margin-right:50px;width:200px;'>灭菌批号："_BatchNo_"</p>"
				_"<p style='font-size:14px;margin-right:50px;width:200px;'>灭菌人："_SterUserName_"</p>"
				_"<p style='font-size:14px;margin-right:50px;width:200px;'>验收人："_SterCheckerName_"</p>"
				_"<p style='font-size:14px;margin-right:50px;width:200px;'>物理监测："_SterPhyResult_"</p>"
			_"</div>"
			_"<div style='font-weight:normal;margin-top:0px;'>"
				_"<p style='font-size:14px;margin-right:50px;width:200px;'>验收时间："_SterCheckDateTime_"</p>"
				_"<p style='font-size:14px;margin-right:50px;width:200px;'>验收结果："_SterCheckResult_"</p>"
				_"<p style='font-size:14px;margin-right:50px;width:200px;'>化学监测："_SterCheResult_"</p>"
				_"<p style='font-size:14px;margin-right:50px;width:200px;'>生物监测："_SterBioResult_"</p>"
			_"</div>"
		_"</div>"
	q SterStr
}

/// Creator:ban
/// CreatDate:2022-3-15
/// Description:根据清洗明细Id获取清洗追踪信息
/// Table:CSSD_Clean
/// w ##class(web.CSSDHUI.Trans.TransInfo).SetCleanInfo()
ClassMethod SetCleanInfo(CleanDetailId As %String) As %Library.String
{
	n (CleanDetailId)
	s CleanDetailObj=##class(User.CSSDCleanDetailPacks).%OpenId(CleanDetailId)
	d CleanDetailObj.%Reload()
	s (CleanUserName,CleanCheckUserName,CleanMethodName,CleanProName,CleanMachineName)=""
	;清洗详情
	q:'$IsObject(CleanDetailObj) ""
	s CleanCheckResult=CleanDetailObj.CSSDCDPStates
	s CleanMainObj=CleanDetailObj.CSSDCDPCleanMain
	q:'$IsObject(CleanMainObj) ""
	
	s CleanMachineObj=CleanMainObj.CSSDCMachine
	s CleanNo=CleanMainObj.CSSDCNo
	s CleanUserObj=CleanMainObj.CSSDCCleaner
	s CleanDate=CleanMainObj.CSSDCDate
	s CleanTime=CleanMainObj.CSSDCTime
	s CleanCheckDate=CleanMainObj.CSSDCChkDate
	s CleanCheckTime=CleanMainObj.CSSDCChkTime
	s CleanMethodObj=CleanMainObj.CSSDCCleanMethod
	s CleanProId=CleanMainObj.CSSDCCleanProgress
	s CleanCheckUserObj=CleanMainObj.CSSDCChker
	
	i $IsObject(CleanMachineObj) d
	.s CleanMachineName = CleanMachineObj.CSSDMCAlias
	i $IsObject(CleanUserObj) d
	.s CleanUserName=CleanUserObj.SSUSRName
	i $IsObject(CleanCheckUserObj) d
	.s CleanCheckUserName=CleanCheckUserObj.SSUSRName
	
	s CleanDate=..DL2H(CleanDate)
	s CleanTime=..TL2H(CleanTime)
	s CleanDateTime=CleanDate_" "_CleanTime
	s CleanDateTime=$e(CleanDateTime,1,*-3)
	s CleanCheckDate=..DL2H(CleanCheckDate)
	s CleanCheckTime=..TL2H(CleanCheckTime)
	s CleanCheckDateTime=CleanCheckDate_" "_CleanCheckTime
	s CleanCheckDateTime=$e(CleanCheckDateTime,1,*-3)
	
	i CleanCheckResult="Y" s CleanCheckResult="合格"
	e  i CleanCheckResult="N" s CleanCheckResult="不合格"
	e  s CleanCheckResult="未验收"
	
	i $IsObject(CleanMethodObj) d
	.s CleanMethodName = CleanMethodObj.CSSDCTCleanMode
	
	i CleanProId'="" d
	.s CleanProObj=##class(User.CSSDBaseCode).%OpenId(CleanProId)
	.i $IsObject(CleanProObj) s CleanProName=CleanProObj.CSSDDCName
	
	s CleanStr=
		"<div style='margin-left:30px;'>"
			_"<div style='font-weight:normal;margin-top:0px;'>"
				_"<p style='font-size:14px;margin-right:50px;width:200px;'>清洗时间："_CleanDateTime_"</p>"
				_"<p style='font-size:14px;margin-right:50px;width:200px;'>清洗机："_CleanMachineName_"</p>"
				_"<p style='font-size:14px;margin-right:50px;width:200px;'>清洗方式："_CleanMethodName_"</p>"
				_"<p style='font-size:14px;margin-right:50px;width:200px;'>清洗程序："_CleanProName_"</p>"
			_"</div>"
			_"<div style='font-weight:normal;margin-top:0px;'>"
				_"<p style='font-size:14px;margin-right:50px;width:200px;'>清洗批号："_CleanNo_"</p>"
				_"<p style='font-size:14px;margin-right:50px;width:200px;'>清洗人："_CleanUserName_"</p>"
			_"</div>"
			_"<div style='font-weight:normal;margin-top:0px;'>"
				_"<p style='font-size:14px;margin-right:50px;width:200px;'>验收时间："_CleanCheckDateTime_"</p>"
				_"<p style='font-size:14px;margin-right:50px;width:200px;'>验收人："_CleanCheckUserName_"</p>"
				_"<p style='font-size:14px;margin-right:50px;width:200px;'>验收结果："_CleanCheckResult_"</p>"
			_"</div>"
		_"</div>"
	q CleanStr
}

/// Creator:ban
/// CreatDate:2022-3-15
/// Description:获取所有的清洗过程
/// Table:CSSD_Clean
/// w ##class(web.CSSDHUI.Trans.TransInfo).GetCleanInfo("1211",185)
ClassMethod GetCleanInfo(Pid As %String, CleanDetailId As %String) As %Library.String
{
	n (Pid,CleanDetailId)
	k ^TMPCSSD(Pid,"CleanDetail")
	s ^TMPCSSD(Pid,"CleanDetail",CleanDetailId)=..SetCleanInfo(CleanDetailId)
	while(CleanDetailId'=""){
		s CleanDetailObj=##class(User.CSSDCleanDetailPacks).%OpenId(CleanDetailId)
		q:'$IsObject(CleanDetailObj)
		s CleanDetailId=CleanDetailObj.CSSDCDPBindCleanDetailId
		q:CleanDetailId=""
		s ^TMPCSSD(Pid,"CleanDetail",CleanDetailId)=..SetCleanInfo(CleanDetailId)
	}
	q 0
}

}
