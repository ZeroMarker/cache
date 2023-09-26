Import sqluser

Class web.CSSDHUI.Stat.TransStat Extends (%RegisteredObject, web.CSSDHUI.CSSDType) [ Not ProcedureBlock ]
{

/// 消毒包追踪查询, 全生命周期数据
/// d ##class(%ResultSet).RunQuery("web.CSSDHUI.Stat.TransStat","QueryTrans",^tempyj("Params"))
/// d ##class(%ResultSet).RunQuery("web.CSSDHUI.Stat.TransStat","QueryTrans","{""Label"":""00022022102000001""}")
Query QueryTrans(Params As %Text) As web.CSSDHUI.Query(ROWSPEC = "TransId,BindLocDesc,PkgDesc,Label,CodeDict,Status,StatusDesc,AttributeDesc,ClassDesc,PreCBId,PreCBNo,PreCBLocDesc,PreCBUserId,PreCBUserName,PreCBAckUserName,PreCBDateTime,PreCBAckDateTime,PreCBFromLocDesc,PreCBFromUserName,CleanItmId,CleanUserName,CleanTypeName,CleanDateTime,CleanMachineNo,CleanNo,CleanChkUserName,CleanChkDateTime,CleanUserId,CleanChkUserId,PackId,PackLocDesc,PackUserId,PackUserName,PackDateTime,PackAckUserId,PackAckUserName,PackToLocDesc,PrintTime,PackMaterialDesc,PackAckDate,SterItmId,SterUserId,SterUserName,SterDateTime,ExpDate,SterMachineNo,SterNo,SterChkUserId,SterChkUserName,SterChkDateTime,RecallFlag,RecallDateTime,RecallUserName,RecallReasonId,DispItmId,DispNo,DispLocDesc,DispUserId,DispUserName,DispDateTime,ToUserId,ToUserName,ToLocDesc,ToLocId,ReceiveDateTime,PatientId,PatientName,OprDoctorName,InstNurseName,CircNurseName,OprDateTime,OprRoomDesc,OprRoomNo,AdmLocDesc,InfectDesc,CBId,CBNo,CBLocDesc,CBUserId,CBUserName,CBAckUserName,CBDateTime,CBAckDateTime,CBFromLocDesc,CBFromUserName") [ SqlProc ]
{
}

ClassMethod QueryTransExecute(ByRef qHandle As %Binary, Params As %Text) As %Status
{
	n (qHandle,Params)
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind=1
	
	s PJObj=##class(web.CSSDHUI.Common.FromJson).%New()
	d PJObj.%FromJSON(Params)
	s PStartDate=PJObj.%Get("StartDate")
	s PEndDate=PJObj.%Get("EndDate")
	s PStartTime=PJObj.%Get("StartTime")
	s PEndTime=PJObj.%Get("EndTime")
	s PPsnType=PJObj.%Get("PsnType")
	s PUserId=PJObj.%Get("User")
	s PPkgId=PJObj.%Get("PkgId")
	s PLabel=PJObj.%Get("Label")
	s POnlyLabel=PJObj.%Get("OnlyLabel")
	s PCodeDict=PJObj.%Get("CodeDict")
	s PStatus=PJObj.%Get("PackageStatus")
	s PSterTypeId=PJObj.%Get("SterType")
	s PSterNo=PJObj.%Get("SterNo")
	;s PPatientType=PJObj.%Get("PatientType")
	s PHospId=PJObj.%Get("BDPHospital")
	s gHospId=PJObj.%Get("gHospId")
	s gLocId=PJObj.%Get("gLocId")
	s PToLoc=PJObj.%Get("ToLoc")
	s PPreCallBackNo=PJObj.%Get("PreCallBackNo")
	
	s PHospId=##class(web.CSSDHUI.HospMap).GetBDPHospId(PHospId,gHospId)
	s:PStartTime'="" PStartTime=..TH2L(PStartTime)
	s:PEndTime'="" PEndTime=..TH2L(PEndTime)
	s:PStartTime="86399" PStartTime=""
	s:PEndTime="86399" PEndTime=""
	s PStartDate=..DH2L(PStartDate)
	s PEndDate=..DH2L(PEndDate)
	i (PLabel'="")&&$d(^User.CSSDTransI("CSSDTLabel",PLabel)) s POnlyLabel="Y"	;若标签严格对应,强匹配; 否则支持模糊查询
	q:(POnlyLabel'="Y")&&((PStartDate="")||(PEndDate="")) $$$OK
	
	i (POnlyLabel="Y") d
	.q:PLabel=""
	.s Data=..GetTransDetailInfo(PLabel)
	.d OutputRowTrans
	q:(POnlyLabel="Y")&&(PLabel'="") $$$OK
	
	s SqlStr="select CSSDT_Rowid,cssdt_package_dr as PkgDr,CSSDT_Date,CSSDT_Time,CSSDT_Label,CSSDT_Pack_DR->CSSDPP_Loc_DR PackLocId,CSSDT_Disp_DR as DispItmId,CSSDT_PreCallBackDetail_DR as PreCBItmId "
		_" from cssd_trans where CSSDT_Date between "_PStartDate_" and "_PEndDate
	i PPkgId'="" d
	.s SqlStr=SqlStr_" and cssdt_package_dr='"_PPkgId_"'"
	i PCodeDict'="" d
	.s SqlStr=SqlStr_" and CSSDT_Label %STARTSWITH '"_PCodeDict_"'"
	i PStatus'="" d
	.s SqlStr=SqlStr_" and CSSDT_Status='"_PStatus_"'"
	s result=##class(%Library.ResultSet).%New()
	d result.RuntimeModeSet(0)
	d result.Prepare(SqlStr)
	d result.Execute()
	While(result.Next())
	{
		s TransId=result.Data("CSSDT_Rowid")
		s TrTime=result.Data("CSSDT_Time")
		s TrDate=result.Data("CSSDT_Date")
		s PkgDr=result.Data("PkgDr")
		s Label=result.Data("CSSDT_Label")
		s PackLocId=result.Data("PackLocId")
		s DispItmId=result.Data("DispItmId")
		s PreCBItmId=result.Data("PreCBItmId")
		
		continue:PackLocId'=gLocId
		continue:(PStartTime'="")&&(TrTime<PStartTime)&&(TrDate=PStartDate)
		continue:(PEndTime'="")&&(TrTime>=PEndTime)&&(TrDate=PEndDate)
		
		;s HospitalDr=$lg(^User.CSSDPackageD(PkgDr),20)
		s SterTypeId=$lg(^User.CSSDPackageD(PkgDr),21)
		
		s ShowDataFlag=##class(web.CSSDHUI.HospMap).GetShowDataFlag("CSSD_Package",PkgDr,PHospId)
		continue:ShowDataFlag="N"
		continue:((PSterTypeId'="")&&(PSterTypeId'=SterTypeId))
		
		s TransObj=##Class(User.CSSDTrans).%OpenId(TransId)
		s Label=TransObj.CSSDTLabel
		s TransStatus=TransObj.CSSDTStatus
		s SterNo=$s(TransObj.CSSDTSterilize'="":TransObj.CSSDTSterilize.CSSDPSParref.CSSDSRNo,1:"")
		continue:(PLabel'="")&&(Label'[PLabel)
		continue:(PSterNo'="")&&(SterNo'=PSterNo)		;灭菌批号
		
		s PreCBNo="",PreCBUserId=""
		i PreCBItmId'="" d
		.s PreCBId=$lg(^User.CSSDCallbackDetailNewD(PreCBItmId),2)
		.s PreCBMainObj=##class(User.CSSDPackageCallback).%OpenId(PreCBId)
		.q:'$IsObject(PreCBMainObj)
		.s PreCBNo=PreCBMainObj.CSSDPCSerialNo
		.s PreCBUserId=PreCBMainObj.CSSDPCAckUserDrGetObjectId()
		continue:(PPreCallBackNo'="")&&(PreCBNo'[PPreCallBackNo)
		
		s UserCheckFlag="Y"		;Y-用户对比通过, N-用户对比不通过
		; PPsnType: 1-清洗人, 2-配包人, 3-审核人, 4-灭菌人, 5-回收人
		i (PUserId'="") d
		.
		.s CleanUserId=$s(TransObj.CSSDTClean'="":TransObj.CSSDTClean.CSSDCDPCleanMain.CSSDCCleanerGetObjectId(),1:"")
		.s PackUserId=$s(TransObj.CSSDTPack'="":TransObj.CSSDTPack.CSSDPPAckUserDrGetObjectId(),1:"")
		.s PackChkUserId=$s(TransObj.CSSDTPack'="":TransObj.CSSDTPack.CSSDPPUserDrGetObjectId(),1:"")
		.s SterUserId=$s(TransObj.CSSDTSterilize'="":TransObj.CSSDTSterilize.CSSDPSParref.CSSDSRUserDrGetObjectId(),1:"")
		.s CBUserId=$s(TransObj.CSSDTCallBack'="":TransObj.CSSDTCallBack.CSSDPCAckUserDrGetObjectId(),1:"")
		.
		.i (PPsnType=0)&&(PUserId'=PreCBUserId) s UserCheckFlag="N" q
		.i (PPsnType=1)&&(PUserId'=CleanUserId) s UserCheckFlag="N" q
		.i (PPsnType=2)&&(PUserId'=PackUserId) s UserCheckFlag="N" q
		.i (PPsnType=3)&&(PUserId'=PackChkUserId) s UserCheckFlag="N" q
		.i (PPsnType=4)&&(PUserId'=SterUserId) s UserCheckFlag="N" q
		.i (PPsnType=5)&&(PUserId'=CBUserId) s UserCheckFlag="N" q
		.
		.;若未选择人员类型,则任何一个人员满足,即认为符合条件
		.i (PPsnType="")&&((PUserId'=CleanUserId)&&(PUserId'=PackUserId)&&(PUserId'=PackChkUserId)&&(PUserId'=SterUserId)&&(PUserId'=CBUserId)) s UserCheckFlag="N" q
		continue:UserCheckFlag="N"
		s ToLocId=""
		i DispItmId'="" d
		.s DispMainId=$lg(^User.CSSDPackageDispD(DispItmId),26)
		.s:DispMainId'="" ToLocId=$lg(^User.CSSDPackageDispMainD(DispMainId),7)
		continue:(PToLoc'="")&&(ToLocId'=PToLoc)
		
		s Data=..GetTransDetailInfo(Label)
		continue:Data=""
		d OutputRowTrans
	}
	d result.Close()
	q $$$OK
OutputRowTrans
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// 获得消毒包追踪的详细信息
/// 清洗, 配包，打包，灭菌，发放，(使用),回收 的详情
/// zw ##Class(web.CSSDHUI.Stat.TransStat).GetTransDetailInfo("104002001000001")
ClassMethod GetTransDetailInfo(Label As %String) As %List
{
	n (Label)
	q:Label="" ""
	
	s (BindLocDesc,Status,ClassDesc)=""
	s TransId=$o(^User.CSSDTransI("CSSDTLabel",Label,""),-1)
	q:TransId="" ""
	s TransObj=##class(User.CSSDTrans).%OpenId(TransId)
	q:'$IsObject(TransObj) ""
	
	s CleanItmObj=TransObj.CSSDTClean
	s PackId=TransObj.CSSDTPackGetObjectId()
	s SterItmId=TransObj.CSSDTSterilizeGetObjectId()
	s DispItmId=TransObj.CSSDTDispGetObjectId()
	s CBId=TransObj.CSSDTCallBackGetObjectId()
	s PreCBItmId=TransObj.CSSDTPreCallBackDetailDRGetObjectId()
	s Status=TransObj.CSSDTStatus
	s PkgId=TransObj.CSSDTPackage.%Id()
	s ExpDate=TransObj.CSSDTExpDate
	
	s ExpDate=..DL2H(ExpDate)
	s StatusDesc=##Class(web.CSSDHUI.Common.PackageInfoCommon).GetStatusChinese(Status)
	s CodeDict=##class(web.CSSDHUI.Common.PackageInfoCommon).GetFixedLabel(Label)
	
	s PackageObj=##class(User.CSSDPackage).%OpenId(PkgId)
	s PkgDesc=PackageObj.CSSDPDesc
	s ClassId=PackageObj.CSSDPPackClassGetObjectId()
	s AttributeCode=PackageObj.CSSDPPackTypeDetail
	i ClassId'="" d
	.s ClassDesc=PackageObj.CSSDPPackClass.CSSDPCPackCalssName
	
	s AttributeDesc=##class(web.CSSDHUI.Common.PackageInfoCommon).GetPackageDetailDesc(AttributeCode)
	i AttributeCode=1 d
	.s PkgDesc=##Class(web.CSSDHUI.Common.PackageInfoCommon).GetCodeDictName(Label)
	.s BindLocDesc=##Class(web.CSSDHUI.Common.PackageInfoCommon).GetCodeDictBindLocName(Label)
	e  d
	.s BindLocDesc=##Class(web.CSSDHUI.Common.PackageInfoCommon).GetPackageBindLocName(PkgId)
	
	;清洗前回收
	s (PreCBLocDesc,PreCBUserId,PreCBUserName,PreCBAckUserName,PreCBDateTime,PreCBAckDateTime,PreCBFromUserName,PreCBFromLocDesc)=""
	i PreCBItmId'="" d
	.s PreCBId=$lg(^User.CSSDCallbackDetailNewD(PreCBItmId),2)
	.q:PreCBId=""
	.s PreCBInfo=$g(^User.CSSDPackageCallbackD(PreCBId))
	.s PreCBDate=$lg(PreCBInfo,2)
	.s PreCBFromLocId=$lg(PreCBInfo,3)
	.s PreCBFromUserId=$lg(PreCBInfo,4)
	.s PreCBNo=$lg(PreCBInfo,8)
	.s PreCBTime=$lg(PreCBInfo,9)
	.s PreCBLocId=$lg(PreCBInfo,10)
	.s PreCBUserId=$lg(PreCBInfo,11)
	.s PreCBAckDate=$lg(PreCBInfo,12)
	.s PreCBAckUserId=$lg(PreCBInfo,13)
	.s PreCBAckTime=$lg(PreCBInfo,21)
	.
	.s:PreCBLocId'="" PreCBLocDesc=$p(^CTLOC(PreCBLocId),"^",2)
	.s:PreCBUserId'="" PreCBUserName=$p(^SSU("SSUSR",PreCBUserId),"^",2)
	.s:PreCBAckUserId'="" PreCBAckUserName=$p(^SSU("SSUSR",PreCBUserId),"^",2)
	.s:PreCBFromLocId'="" PreCBFromLocDesc=$p(^CTLOC(PreCBFromLocId),"^",2)
	.s:PreCBFromUserId'="" PreCBFromUserName=$p(^SSU("SSUSR",PreCBFromUserId),"^",2)
	.s PreCBDate=..DL2H(PreCBDate)
	.s PreCBTime=..TL2H(PreCBTime)
	.s PreCBDateTime=PreCBDate_" "_PreCBTime
	.s PreCBAckDate=..DL2H(PreCBAckDate)
	.s PreCBAckTime=..TL2H(PreCBAckTime)
	.s PreCBAckDateTime=PreCBAckDate_" "_PreCBAckTime
	
	;清洗详情
	s (CleanItmId,CleanUserName,CleanTypeName,CleanDateTime,CleanMachineNo,CleanNo,CleanChkUserName,CleanChkDateTime,CleanUserId,CleanChkUserId)=""
	i $IsObject(CleanItmObj) d
	.s CleanItmId=CleanItmObj.%Id()
	.s CleanMain=CleanItmObj.CSSDCDPCleanMain
	.q:CleanMain=""
	.
	.i CleanMain.CSSDCMachine'="" d
	..s CleanMachineNo=CleanMain.CSSDCMachine.CSSDMCAlias
	.;s CleanMachineNo=CleanMain.CSSDCMachineNo
	.s CleanNo=CleanMain.CSSDCNo
	.s CleanTypeObj=CleanMain.CSSDCCleanMethod
	.s CleanUserId=CleanMain.CSSDCCleanerGetObjectId()
	.s CleanChkUserId=CleanMain.CSSDCChkerGetObjectId()
	.s CleanDate=CleanMain.CSSDCDate
	.s CleanChkDate=CleanMain.CSSDCChkDate
	.s CleanTime=CleanMain.CSSDCTime
	.s CleanChkTime=CleanMain.CSSDCChkTime
	.
	.s:CleanMachineNo="" CleanMachineNo="手工"
	.i $IsObject(CleanTypeObj) d
	..s CleanTypeId=CleanTypeObj.%Id()
	..s CleanTypeName=CleanTypeObj.CSSDCTCleanMode		;清洗方式
	.
	.s CleanUserName=$s(CleanUserId'="":$p(^SSU("SSUSR",CleanUserId),"^",2),1:"")
	.s CleanChkUserName=$s(CleanChkUserId'="":$p(^SSU("SSUSR",CleanChkUserId),"^",2),1:"")
	.
	.s CleanDate=..DL2H(CleanDate)
	.s CleanChkDate=..DL2H(CleanChkDate)
	.s CleanTime=..TL2H(CleanTime)
	.s CleanDateTime=CleanDate_" "_CleanTime
	.s CleanChkTime=..TL2H(CleanChkTime)
	.s CleanChkDateTime=CleanChkDate_" "_CleanChkTime
	
	;配包打包
	s (PackLocDesc,PackUserId,PackUserName,PackDateTime,PackAckUserId,PackAckUserName,PackToLocDesc,PrintTime,PackMaterialDesc)=""
	i PackId'="" d
	.s PackInfo=$g(^User.CSSDPackagePackD(PackId))
	.s PackDate=$lg(PackInfo,2)
	.s PackLocId=$lg(PackInfo,4)
	.s PackTime=$lg(PackInfo,8)
	.s PackUserId=$lg(PackInfo,9)
	.s PackAckUserId=$lg(PackInfo,11)
	.s PackAckDate=$lg(PackInfo,12)
	.s PackToLocId=$lg(PackInfo,19)			;CSSDPP_PackLocDR
	.s PackMaterialId=$lg(PackInfo,24)
	.s PrintTime=$lg(PackInfo,30)
	.
	.s:PackMaterialId'="" PackMaterialDesc=$lg(^User.CSSDMaterialD(PackMaterialId),3)
	.s PackLocDesc=$p(^CTLOC(PackLocId),"^",2)
	.s:PackToLocId'="" PackToLocDesc=$p(^CTLOC(PackToLocId),"^",2)
	.s:PackUserId'="" PackUserName=$p(^SSU("SSUSR",PackUserId),"^",2)
	.s:PackAckUserId'="" PackAckUserName=$p(^SSU("SSUSR",PackAckUserId),"^",2)
	.s PackDate=..DL2H(PackDate)
	.s PackTime=..TL2H(PackTime)
	.s PackDateTime=PackDate_" "_PackTime
	.s PackAckDate=..DL2H(PackAckDate)
	
	;灭菌
	s (SterUserName,SterDateTime,SterMachineNo,SterNo,SterChkUserName,SterChkDateTime,RecallFlag,RecallDateTime,RecallUserName,RecallReasonId)=""
	i SterItmId'="" d
	.s SterItmInfo=$g(^User.CSSDPackageSterilizeD(SterItmId))
	.q:SterItmInfo=""
	.s RecallDate=$lg(SterItmInfo,4)
	.s RecallTime=$lg(SterItmInfo,5)
	.s SterMainId=$lg(SterItmInfo,13)
	.s RecallFlag=$lg(SterItmInfo,14)			;召回标志
	.s RecallReasonId=$lg(SterItmInfo,15)
	.s RecallUserId=$lg(SterItmInfo,16)
	.
	.s SterMainInfo=$g(^User.CSSDSterilizeRecordD(SterMainId))
	.q:SterMainInfo=""
	.
	.s SterDate=$lg(SterMainInfo,2)
	.s SterNo=$lg(SterMainInfo,4)				;灭菌批号
	.s SterTime=$lg(SterMainInfo,8)
	.s SterUserId=$lg(SterMainInfo,9)
	.s SterMachineNo=$lg(SterMainInfo,18)		;灭菌器号
	.s SterChkUserId=$lg(SterMainInfo,25)
	.s SterChkTime=$lg(SterMainInfo,26)
	.s SterMachineId=$lg(SterMainInfo,35)		;灭菌器Id
	.s SterChkDate=$lg(SterMainInfo,46)
	.
	.i RecallFlag="Y" d
	..s RecallUserName=$p(^SSU("SSUSR",RecallUserId),"^",2)
	..s RecallReason=$lg(^User.CSSDRecallReasonD(RecallReasonId),3)
	..s RecallDateTime=..DL2H(RecallDate)_" "_..TL2H(RecallTime)
	.
	.i SterMachineId'="" d
	..s SterMachineNo=$lg(^User.CSSDMachineConfigD(SterMachineId),10)
	.s:SterUserId'="" SterUserName=$p(^SSU("SSUSR",SterUserId),"^",2)
	.s:SterChkUserId'="" SterChkUserName=$p(^SSU("SSUSR",SterChkUserId),"^",2)
	.s SterDate=..DL2H(SterDate)
	.s SterTime=..TL2H(SterTime)
	.s SterDateTime=SterDate_" "_SterTime
	.s SterChkDate=..DL2H(SterChkDate)
	.s SterChkTime=..TL2H(SterChkTime)
	.s SterChkDateTime=SterChkDate_" "_SterChkTime
	
	;发放
	s (DispNo,DispLocDesc,DispUserName,DispDateTime,ToUserName,ReceiveDateTime,ToLocId,ToLocDesc)=""
	i DispItmId'="" d
	.s DispInfo=$g(^User.CSSDPackageDispD(DispItmId))
	.s DispMainId=$lg(DispInfo,26)
	.
	.s DispMainInfo=$g(^User.CSSDPackageDispMainD(DispMainId))
	.q:DispMainInfo=""
	.s DispLocId=$lg(DispMainInfo,2)
	.s DispUserId=$lg(DispMainInfo,3)
	.s DispNo=$lg(DispMainInfo,4)
	.s ToLocId=$lg(DispMainInfo,7)
	.s ToUserId=$lg(DispMainInfo,8)
	.s DispDate=$lg(DispMainInfo,18)
	.s DispTime=$lg(DispMainInfo,19)
	.s ReceiveDate=$lg(DispMainInfo,20)
	.s ReceiveTime=$lg(DispMainInfo,21)
	.
	.s:DispLocId'="" DispLocDesc=$p(^CTLOC(DispLocId),"^",2)
	.s:DispUserId'="" DispUserName=$p(^SSU("SSUSR",DispUserId),"^",2)
	.s:ToLocId'="" ToLocDesc=$p(^CTLOC(ToLocId),"^",2)
	.s:ToUserId'="" ToUserName=$p(^SSU("SSUSR",ToUserId),"^",2)
	.s DispDate=..DL2H(DispDate)
	.s DispTime=..TL2H(DispTime)
	.s DispDateTime=DispDate_" "_DispTime
	.s ReceiveDate=..DL2H(ReceiveDate)
	.s ReceiveTime=..TL2H(ReceiveTime)
	.s ReceiveDateTime=ReceiveDate_" "_ReceiveTime
	.
	.;按接收科室更新 标签打包接收科室 的取值
	.s PackToLocDesc=ToLocDesc
	
	;发放后回收
	s (CBLocDesc,CBUserId,CBUserName,CBAckUserName,CBDateTime,CBAckDateTime,CBFromUserName,CBFromLocDesc)=""
	i CBId'="" d
	.s CBInfo=$g(^User.CSSDPackageCallbackD(CBId))
	.s CBDate=$lg(CBInfo,2)
	.s CBFromLocId=$lg(CBInfo,3)
	.s CBFromUserId=$lg(CBInfo,4)
	.s CBNo=$lg(CBInfo,8)
	.s CBTime=$lg(CBInfo,9)
	.s CBLocId=$lg(CBInfo,10)
	.s CBUserId=$lg(CBInfo,11)
	.s CBAckDate=$lg(CBInfo,12)
	.s CBAckUserId=$lg(CBInfo,13)
	.s CBAckTime=$lg(CBInfo,21)
	.
	.s:CBLocId'="" CBLocDesc=$p(^CTLOC(CBLocId),"^",2)
	.s:CBUserId'="" CBUserName=$p(^SSU("SSUSR",CBUserId),"^",2)
	.s:CBAckUserId'="" CBAckUserName=$p(^SSU("SSUSR",CBUserId),"^",2)
	.s:CBFromLocId'="" CBFromLocDesc=$p(^CTLOC(CBFromLocId),"^",2)
	.s:CBFromUserId'="" CBFromUserName=$p(^SSU("SSUSR",CBFromUserId),"^",2)
	.s CBDate=..DL2H(CBDate)
	.s CBTime=..TL2H(CBTime)
	.s CBDateTime=CBDate_" "_CBTime
	.s CBAckDate=..DL2H(CBAckDate)
	.s CBAckTime=..TL2H(CBAckTime)
	.s CBAckDateTime=CBAckDate_" "_CBAckTime
	
	;手术室使用信息
	s (PatientId,PatientName,OprDoctorName,InstNurseName,CircNurseName,OprDateTime,OprRoomDesc,OprRoomNo,AdmLocDesc,InfectDesc)=""
	s UseInfo=..GetPkgUseInfo(Label)
	i UseInfo'="" d
	.s PatientId=$p(UseInfo,"|",1)
	.s PatientName=$p(UseInfo,"|",2)
	.s OprDoctorName=$p(UseInfo,"|",3)
	.s InstNurseName=$p(UseInfo,"|",4)		;器械护士
	.s CircNurseName=$p(UseInfo,"|",5)		;巡回护士
	.s OprDate=$p(UseInfo,"|",6)
	.s OprRoomDesc=$p(UseInfo,"|",7)
	.s OprRoomNo=$p(UseInfo,"|",8)
	.s AdmLocDesc=$p(UseInfo,"|",9)
	.s InfectDesc=$p(UseInfo,"|",10)
	.s OprTime=$p(UseInfo,"|",11)
	.
	.s OprDate=..DL2H(OprDate)
	.s OprTime=..TL2H(OprTime)
	.s OprDateTime=OprDate_" "_OprTime
	
	s List=$lb(
		;标签信息
		TransId,BindLocDesc,PkgDesc,Label,CodeDict,Status,StatusDesc,AttributeDesc,ClassDesc,
		;发放前回收
		PreCBId,PreCBNo,PreCBLocDesc,PreCBUserId,PreCBUserName,PreCBAckUserName,PreCBDateTime,PreCBAckDateTime,PreCBFromLocDesc,PreCBFromUserName,
		;清洗
		CleanItmId,CleanUserName,CleanTypeName,CleanDateTime,CleanMachineNo,CleanNo,CleanChkUserName,CleanChkDateTime,
		CleanUserId,CleanChkUserId,
		;打包
		PackId,PackLocDesc,PackUserId,PackUserName,PackDateTime,PackAckUserId,PackAckUserName,PackToLocDesc,PrintTime,PackMaterialDesc,
		PackAckDate,
		;灭菌信息
		SterItmId,SterUserId,SterUserName,SterDateTime,ExpDate,SterMachineNo,SterNo,SterChkUserId,SterChkUserName,SterChkDateTime,
		RecallFlag,RecallDateTime,RecallUserName,RecallReasonId,
		;发放
		DispItmId,DispNo,DispLocDesc,DispUserId,DispUserName,DispDateTime,ToUserId,ToUserName,ToLocDesc,ToLocId,ReceiveDateTime,
		;手术使用
		PatientId,PatientName,OprDoctorName,InstNurseName,CircNurseName,OprDateTime,OprRoomDesc,
		OprRoomNo,AdmLocDesc,InfectDesc,
		;发放后回收
		CBId,CBNo,CBLocDesc,CBUserId,CBUserName,CBAckUserName,CBDateTime,CBAckDateTime,CBFromLocDesc,CBFromUserName,
	)
	
	q List
}

/// w ##class(web.CSSDHUI.Stat.TransStat).GetPkgUseInfo("00022021072100002")
ClassMethod GetPkgUseInfo(Label As %String) As %String
{
	n (Label)
	q:Label="" ""
	s OPId=$o(^User.CSSDTransOPI("CSSDTOPLabelIndex",Label,""))
	q:OPId="" ""

	s TransOPObj=##Class(User.CSSDTransOP).%OpenId(OPId)
	s PatientId=TransOPObj.CSSDTOPPationtDRGetObjectId()
	s OprDoctorObj=TransOPObj.CSSDTOPOPDoctor
	s InstNurseObj=TransOPObj.CSSDTOPCountNurseDR		;器械护士
	s CircNurseObj=TransOPObj.CSSDOPCircNurse			;巡回护士
	s OprRoomNo=TransOPObj.CSSDTOPOPRoom				;手术房间号
	s OPArrObj=TransOPObj.CSSDTOPANOPID
	s InfectDesc=TransOPObj.CSSDTOPInfectName
	s OPCountDate=TransOPObj.CSSDOPCountDate
	s OPCountTime=TransOPObj.CSSDOPCountTime
	
	s AdmLocId=$p($g(^PAADM(PatientId)),"^",4) ;患者所在的科室
	s AdmLocDesc=##Class(web.CSSDHUI.Common.PackageInfoCommon).GetLocName(AdmLocId)
	s PatientInfo=##class(web.CSSDHUI.PackageRegister.PkgRegister).ByAdmGetPatInfo(PatientId)
	s PatientId=$p(PatientInfo,"^",1)
	s PatientName=$p(PatientInfo,"^",2)
	s (OprDoctorName,InstNurseName,CircNurseName,OprRoomDesc)=""
	i $IsObject(OprDoctorObj) d
	.s OprDoctorName=OprDoctorObj.CTPCPDesc
	i $IsObject(InstNurseObj) d
	.s InstNurseName=InstNurseObj.CTPCPDesc
	i $IsObject(CircNurseObj) d
	.s CircNurseName=CircNurseObj.CTPCPDesc
	i $IsObject(OPArrObj) d
	.s OpaId=OPArrObj.%Id()
	.;s deptDr=OPArrObj.OPAPatDeptDr
	.
	.s AnaId=$P(^DHCANOPArrange(OpaId),"^",2)		;OR_AnaestOperation
	.s AdmId=$P(AnaId,"||",1)
	.s AnaCh=$P(AnaId,"||",2)
	.s AnaSub=$o(^OR(AdmId,"ANA",AnaCh,"OP",0))
	.q:AnaSub=""
	.;;手术室
	.s OperLocId=$P(^OR(AdmId,"ANA",AnaCh,"OP",AnaSub),"^",10)
	.s OprRoomDesc=##Class(web.CSSDHUI.Common.PackageInfoCommon).GetLocName(OperLocId)
	
	;使用患者ID号;患者姓名;手术医生;器械护士;巡回护士;手术时间;手术室;手术房间号;使用科室;感染名称 
	s Ret=PatientId_"|"_PatientName_"|"_OprDoctorName_"|"_InstNurseName_"|"_CircNurseName
		_"|"_OPCountDate_"|"_OprRoomDesc_"|"_OprRoomNo_"|"_AdmLocDesc_"|"_InfectDesc
		_"|"_OPCountTime
	q Ret
}

}
