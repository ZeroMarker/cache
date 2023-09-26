Import sqluser

/// 将老系统的部分数据导入到新系统
/// 2021-09-12
Class web.CSSDHUI.Tools.ImportOldData Extends (%RegisteredObject, web.CSSDHUI.CSSDType) [ Not ProcedureBlock ]
{

/// Init方法中,有部分变量是写的固定值,要注意修改
/// w ##class(web.CSSDHUI.Tools.ImportOldData).InitAll()
ClassMethod InitAll()
{
	new
	k ^TMP("CSSDOLBCODE")
#;	s ^TMP("CSSDOLBCODE","儿科病区",1)=$LB("05512021053100001","","2021-11-27","儿科病区")
#;	s ^TMP("CSSDOLBCODE","儿科病区",2)=$LB("05592021053100001","","2021-11-27","儿科病区")
#;	s ^TMP("CSSDOLBCODE","妇产科病区",3)=$LB("00162021090300001","","2022-3-2","妇产科病区")
#;	s ^TMP("CSSDOLBCODE","妇产科病区",4)=$LB("02372021090900001","","2022-3-8","妇产科病区")

	
	ts
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	s ToLocDesc=""
	f  s ToLocDesc=$o(^TMP("CSSDOLBCODE",ToLocDesc)) q:(ToLocDesc="")||(RtnObj.success<0)  d
	.s RtnObj=..Init(ToLocDesc)
	i RtnObj.success<0 tro  q RtnObj.Json()
	
	b	;before tc
	tc
	q RtnObj.Json()
}

/// 按科室导入
ClassMethod Init(ToLocDesc) As web.CSSDHUI.RtnObj
{
	n (ToLocDesc)
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	i ToLocDesc="" q RtnObj.Err(-1,"","科室为空")
	
	
	s LocId="37"
	s HospId="2"
	s ToLocId=""
	&sql(select %id into :ToLocId from ct_loc where ctloc_desc=:ToLocDesc)
	s UserInitial="03007"
	s UserId=""
	&sql(SELECT %id into :UserId FROM ss_user WHERE SSUSR_Initials=:UserInitial)
	i ToLocId="" q RtnObj.Err(-1,"","科室为空")
	i UserId="" q RtnObj.Err(-1,"","人员为空")
	
	s CleanMode="手工清洗"					;清洗方式
	s CleanProcess="1003"					;清洗程序编号
	s CleanMachineNo="1"					;清洗机编号
	s SterMachineNo="2"						;灭菌器编号
	s SterProcess="1001"					;灭菌程序编号
	s SterCarCode="600704002"				;灭菌架Code
	
	s CleanModeId=""
	&sql(SELECT %id into :CleanModeId FROM CSSD_CleanType WHERE CSSDCT_CleanMode=:CleanMode)
	s CleanProcessId=""
	&sql(SELECT %id into :CleanProcessId FROM CSSD_BaseCode WHERE CSSDDC_CodeType='1001' AND CSSDDC_Code=:CleanProcess)
	s CleanMachineId=""
	&sql(SELECT %id into :CleanMachineId FROM CSSD_MachineConfig WHERE CSSDMC_MachineType='washer' AND CSSDMC_Num=:CleanMachineNo)
	s SterMachineId="",SterType=""
	&sql(SELECT %id,CSSDMC_TempType into :SterMachineId,:SterType FROM CSSD_MachineConfig WHERE CSSDMC_MachineType='sterilizer' AND CSSDMC_Num=:SterMachineNo)
	s SterProcessId=""
	&sql(SELECT %id into :SterProcessId FROM CSSD_BaseCode WHERE CSSDDC_CodeType='2001' AND CSSDDC_Code=:SterProcess)
	
	i (CleanModeId="") q RtnObj.Err("-1","","清洗方式有误")
	i (CleanProcessId="") q RtnObj.Err("-1","","清洗程序有误")
	i (CleanMachineId="") q RtnObj.Err("-1","","清洗机有误")
	i SterMachineId="" q RtnObj.Err("-1","","灭菌器有误")
	i SterProcessId="" q RtnObj.Err("-1","","灭菌程序有误")
	
	s PJObj=##class(web.CSSDHUI.Common.FromJson).%New()
	s Sub=$o(^TMP("CSSDOLBCODE",ToLocDesc,0))
	s PackLabel=$lg(^TMP("CSSDOLBCODE",ToLocDesc,Sub),1)
	;标牌追溯包和普通循环包分开处理
	s OprFlag=$s($l(PackLabel)=15:"Y",1:"N")
	
	ts
	;清洗制单
	s CleanObj={}
	d CleanObj.%Set("cleantypev",CleanModeId)
	d CleanObj.%Set("cleanStrov",CleanProcess)
	d CleanObj.%Set("cleanCodev","")
	d CleanObj.%Set("MachineNoValue",CleanMachineId)	;Machineconfig里面ID
	d CleanObj.%Set("isManualValue","N")				;是否"手工清洗"
	d CleanObj.%Set("gUserId",UserId)
	d CleanObj.%Set("gLocId",LocId)
	s CleanStr=CleanObj.%ToJSON()
	s CleanRet=##Class(web.CSSDHUI.Clean.CleanInfo).jsSaveClean(CleanStr)
	d PJObj.%FromJSON(CleanRet)
	s Success=PJObj.%Get("success")
	s CleanId=PJObj.%Get("rowid")
	i Success<0 tro  q RtnObj.Err(-1,"","清洗单保存错误!")
	
	;保存清洗明细
	s i=""
	f  s i=$o(^TMP("CSSDOLBCODE",ToLocDesc,i)) q:(i="")||(RtnObj.success<0)  d
	.s DataList=^TMP("CSSDOLBCODE",ToLocDesc,i)
	.s PackLabel=$lg(DataList,1)
	.s ExpDate=$lg(DataList,3)
	.
	.i OprFlag="Y" s PackageCode=+$e(PackLabel,1,6)
	.e  s PackageCode=+$e(PackLabel,1,4)
	.s PackageId=$o(^User.CSSDPackageI("CSSDPackageCodeIndex",PackageCode,""))
	.i PackageId="" d RtnObj.Err(-1,"",PackageCode_"消毒包不存在") q
	.s OprFlag=$s($l(PackLabel)=15:"Y",1:"N")
	.
	.i OprFlag="Y" d
	..;标牌追溯包
	..s DictLabel=$e(PackLabel,1,9)
	..s CleanItmObj={}
	..d CleanItmObj.%Set("BarCode",DictLabel)
	..d CleanItmObj.%Set("gHospId",HospId)
	..d CleanItmObj.%Set("gLocId",LocId)
	..s CleanItmStr=CleanItmObj.%ToJSON()
	..s RtnObj=##Class(web.CSSDHUI.Clean.CleanInfo).SaveCleanDetail(CleanId,CleanItmStr)
	.e  d
	..s Qty=1		;数量写固定值
	..s RtnObj=##Class(web.CSSDHUI.Clean.CleanInfo).SaveCommonPackage(CleanId,PackageId,Qty)
	.q:RtnObj.success<0
	.;特殊写法,将老标签临时记录到CSSDCDP_ComposePkgName
	.s SpecialStr=PackLabel_"!"_ExpDate
	.s CleanItmId=$o(^User.CSSDCleanDetailPacksI("IndexMainDr",CleanId,""),-1)
	.&sql(update CSSD_CleanDetailPacks set CSSDCDP_ComposePkgName=:SpecialStr where %id=:CleanItmId)
	.i SQLCODE'=0 d RtnObj.Err(-1,"","更新清洗明细信息失败")
	i RtnObj.success<0 tro  q RtnObj
	
	;清洗动作
	s NowDate=+$h,NowTime=$p($h,",",2)
	&sql(update cssd_clean
		set CSSDC_IsCmtEnterMachine='1',cssdc_date=:NowDate,cssdc_time=:NowTime
		where ID=:CleanId
	)
	
	;清洗验收标记
	;验收标记
	s CheckDate=+$h,CheckTime=$p($h,",",2)
	&sql(update cssd_clean
		set CSSDC_Result='1',CSSDC_ChkDate=:CheckDate,cssdc_chktime=:CheckTime,cssdc_ChkerDR=:UserId
		where ID=:CleanId
	)
	
	;打包
	s CleanItmId=""
	f  s CleanItmId=$o(^User.CSSDCleanDetailPacksI("IndexMainDr",CleanId,CleanItmId)) q:(CleanItmId="")||(RtnObj.success<0)  d
	.s PackageId=$lg(^User.CSSDCleanDetailPacksD(CleanItmId),5)
	.s PackLabelExpDate=$lg(^User.CSSDCleanDetailPacksD(CleanItmId),25)			;此字段特殊处理
	.s PackLabel=$p(PackLabelExpDate,"!",1)
	.s ExpDate=$p(PackLabelExpDate,"!",2)
	.s:ExpDate'="" ExpDate=$zdh(ExpDate,3)
	.s OprFlag=$s($l(PackLabel)=15:"Y",1:"N")
	.
	.s MainObj={}
	.d MainObj.%Set("gLocId",LocId)
	.d MainObj.%Set("gHospId",HospId)
	.d MainObj.%Set("txtChkerv",UserId)		;审核人rowid
	.d MainObj.%Set("txtActorv",UserId)		;包装人rowid
	.d MainObj.%Set("txtPackerv",UserId)	;配包人
	.;d MainObj.%Set("stedate",)
	.;d MainObj.%Set("PackType")
	.s Main=MainObj.%ToJSON()
	.
	.s MaterialId=##Class(web.CSSDHUI.Common.PackageInfoCommon).GetDefaultMaterial(PackageId)
	.s DetailArray=[]
	.s DetailObj={}
	.d DetailObj.%Set("detailID",CleanItmId)
	.d DetailObj.%Set("MaterialDR",MaterialId)
	.d DetailObj.%Set("LevelFlag","")
	.d DetailArray.%Push(DetailObj)
	.s Detail=DetailArray.%ToJSON()
	.
	.i OprFlag="Y" d
	..s DetailArray=[]
	..s DetailObj={}
	..d DetailObj.%Set("DetailID",CleanItmId)		;参数不一致...晕不晕...
	..d DetailObj.%Set("MaterialDR",MaterialId)
	..d DetailObj.%Set("LevelFlag","")
	..d DetailArray.%Push(DetailObj)
	..s Detail=DetailArray.%ToJSON()
	..s Ret=##Class(web.CSSDHUI.Pack.CleanPackLabel).GenOprLabel(Main,Detail,ToLocId)
	.e  d
	..s Ret=##Class(web.CSSDHUI.Pack.CleanPackLabel).GenOrdLabel(Main,Detail,"")
	.
	.d PJObj.%FromJSON(Ret)
	.i PJObj.%Get("success")<0 d RtnObj.Err(-2,"","打包失败"_PackLabel) q
	.
	.s TransId="",PackId="",ReplacePackLabel=""
	.&sql(SELECT %id,CSSDT_Pack_DR,CSSDT_Label into :TransId,:PackId,:ReplacePackLabel FROM CSSD_Trans WHERE CSSDT_Clean_DR=:CleanItmId)
	.i (TransId="")||(PackId="")||(ReplacePackLabel="") d RtnObj.Err(-1,"","标签获取失败") q
	.
	.&sql(update CSSD_Trans set CSSDT_Label=:PackLabel,CSSDT_ExpDate=:ExpDate where %id=:TransId)
	.i SQLCODE'=0 d RtnObj.Err(-11,"","标签设置失败") q
	.&sql(update cssd_packagepack set CSSDPP_Label=:PackLabel WHERE %id=:PackId)
	.i SQLCODE'=0 d RtnObj.Err(-12,"","标签设置失败") q
	i RtnObj.success<0 tro  q RtnObj
	
	;灭菌主表
	s SterObj={}
	d SterObj.%Set("SterUserValue",UserId)
	d SterObj.%Set("gLocId",LocId)
	d SterObj.%Set("SterCarValue",SterCarCode)
	d SterObj.%Set("SterProValue",SterProcessId)		;灭菌程序
	d SterObj.%Set("MachineNo",SterMachineNo)			;灭菌器编号
	d SterObj.%Set("MachineNoValue",SterMachineId)		;灭菌器rowid
	s SterStr=SterObj.%ToJSON()
	s SterRet=##class(web.CSSDHUI.PackageSterilize.Sterilize).jsSave(SterStr)
	d PJObj.%FromJSON(SterRet)
	i PJObj.%Get("success")<0 tro  q RtnObj.Err(-5,"","灭菌单生成失败")
	s SterId=PJObj.%Get("rowid")			;灭菌主表rowid
	
	;灭菌明细
	s CleanItmId=""
	f  s CleanItmId=$o(^User.CSSDCleanDetailPacksI("IndexMainDr",CleanId,CleanItmId)) q:(CleanItmId="")||(RtnObj.success<0)  d
	.s TransId=""
	.&sql(SELECT %id into :TransId FROM cssd_trans WHERE CSSDT_Clean_DR=:CleanItmId)	;这里仅有一条
	.q:TransId=""
	.s PackLabel=$lg(^User.CSSDTransD(TransId),5)
	.s Data=SterId_"^"_LocId_"^"_UserId_"^"_HospId_"^"_""
	.s Title="SterMainId^gLocId^gUserId^gHospId^gGroupId"
	.s Params=##class(web.CSSDHUI.Common.UtilCommon).GetJsonStr(Data,Title)
	.s RtnObj=##class(web.CSSDHUI.PackageSterilize.SterilizeItem).SaveSterDetail(Params,PackLabel)
	.i RtnObj.success<0 q
	i RtnObj.success<0 tro  q RtnObj

	;灭菌操作
	s NowDate=+$h,NowTime=$p($h,",",2)
	&sql(update cssd_sterilizerecord
		set CSSDSR_ComplateFlag='Y',CSSDSR_Date=:NowDate,CSSDSR_Time=:NowTime
		where CSSDSR_Rowid=:SterId
	)
	
	;灭菌验收状态
	s Time=..TL2H($p($h,",",2))
	s SterCheckObj={}
	d SterCheckObj.%Set("gUserId",UserId)
	d SterCheckObj.%Set("CheckTime",Time)
	d SterCheckObj.%Set("CheckUserValue",UserId)
	d SterCheckObj.%Set("gHospId",HospId)
	d SterCheckObj.%Set("SterMainId",SterId)
	d SterCheckObj.%Set("IsSterFinish","N")
	s ParamStr=SterCheckObj.%ToJSON()
	s SterCheckRet=##class(web.CSSDHUI.PackageSterilize.Sterilize).jsOK(ParamStr)
	d PJObj.%FromJSON(SterCheckRet)
	i PJObj.%Get("success")<0 tro  q RtnObj.Err(-5,"","灭菌验收失败")
	
	;发放
	s DispObj={}
	d DispObj.%Set("RowId","")
	d DispObj.%Set("fromLocDr",LocId)
	d DispObj.%Set("toLocDr",ToLocId)
	d DispObj.%Set("fromUserDr",UserId)
	d DispObj.%Set("isOPRFlag",OprFlag)
	s DispStr=DispObj.%ToJSON()
	s RtnObj=##class(web.CSSDHUI.PackageDisp.DispScan).Save(DispStr)
	i RtnObj.success<0 tro  q RtnObj
	s DispId=RtnObj.rowid
	
	;发放单明细
	s SterItmId=""
	f  s SterItmId=$o(^User.CSSDPackageSterilizeI("IndexCSSDPSParref",SterId,SterItmId)) q:(SterItmId="")||(RtnObj.success<0)  d
	.s PackLabel=$lg(^User.CSSDPackageSterilizeD(SterItmId),3)
	.s MainParamObj={}
	.d MainParamObj.%Set("gHospId",HospId)
	.d MainParamObj.%Set("gUserId",gUserId)
	.d MainParamObj.%Set("gGroupId",gGroupId)
	.d MainParamObj.%Set("gLocId",gLocId)
	.d MainParamObj.%Set("MainId",DispId)
	.s MainParams=MainParamObj.%ToJSON()
	.s ParamObj={}
	.d ParamObj.%Set("Label",PackLabel)
	.s Params=ParamObj.%ToJSON()
	.s RtnObj=##class(web.CSSDHUI.PackageDisp.DispDetail).SaveDetail(MainParams,Params)
	i RtnObj.success<0 tro  q RtnObj
	
	;发放单提交
	s RtnObj=##class(web.CSSDHUI.PackageDisp.DispScan).SubmitOrder(DispId,UserId)
	i RtnObj.success<0 tro  q RtnObj
	
	i OprFlag="Y" d
	.s OprRecRet=##class(web.CSSDHUI.PackageDisp.DispScan).jsReceOrder(DispId,UserId)
	.d PJObj.%FromJSON(OprRecRet)
	.i PJObj.%Get("success")<0 d RtnObj.Err(-7,"","标牌追溯包接收失败")
	i RtnObj.success<0 tro  q RtnObj
	
	tc
	q RtnObj
}

/// 老系统非循环包批量导入
/// 换个思路, 批量生成标签(按老系统), 然后借助灭菌/发放环节的批量处理来实现
///  w ##Class(web.CSSDHUI.Tools.ImportOldData).InputFaricLabel("1018")
ClassMethod InputFaricLabel(RowObj, ParamObj) As web.CSSDHUI.RtnObj
{
	n (RowObj,ParamObj)
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	s PJObj=##class(web.CSSDHUI.Common.FromJson).%New()
	
	s LocId=ParamObj.%Get("gLocId")
	s UserId=ParamObj.%Get("gUserId")
	s ChkUserId=UserId,AckUserId=UserId,PackUserId=UserId
	
	s PackageCode=RowObj.%Get("消毒包代码")
	s PackageDesc=RowObj.%Get("消毒包名称")
	s PackLabel=RowObj.%Get("非循环包标签")
	s ExpDateStr=RowObj.%Get("有效期")
	s UseLocDesc=RowObj.%Get("接收科室")
	
	s ExpDate=..DH2L(ExpDateStr)
	i ExpDate="" q RtnObj.Err(-1,"","模板中有效期为空")
	s PackageId=""
	&sql(select %id into :PackageId from CSSD_Package where CSSDP_Code=:PackageCode)
	i PackageId="" q RtnObj.Err(-1,"",PackageCode_"消毒包不存在")
	s UseLocId=""
	&sql(select %id into :UseLocId from ct_loc where ctloc_desc=:UseLocDesc)
	i UseLocId="" q RtnObj.Err(-1,"",UseLocDesc_"接收科室不存在")
	
	s packtype=##class(web.CSSDHUI.Common.PackageInfoCommon).GetDefaultMaterial(PackageId)
	i packtype="" q RtnObj.Err(-1,"",PackageCode_"消毒包未设置默认包装材料","",0)
	
	s package=##Class(User.CSSDPackage).%OpenId(PackageId)
	d package.%Reload()
	s pkgCode=package.CSSDPCode

	s pdate=+$h
	s ptime=$p($h,",",2)
	s serialNo=##class(web.CSSDHUI.Common.AppCommon).CreatePackSerialNo()
	
	ts
	
	&sql(Insert into CSSD_PackagePack
		(CSSDPP_Label,CSSDPP_Package_DR,CSSDPP_Loc_DR,CSSDPP_Date,CSSDPP_Time,
		CSSDPP_Qty,CSSDPP_User_DR,CSSDPP_AckUser_DR,CSSDPP_AckDate,CSSDPP_SerialNo,
		CSSDPP_ApplyLoc,CSSDPP_PackUser_DR,CSSDPP_Material_DR,CSSDPP_IsLoadSteCar,CSSDPP_PrtTimes)
		Values
		(:PackLabel,:PackageId,:LocId,:pdate,:ptime,
		1,:ChkUserId,:AckUserId,:pdate,:serialNo,
		:UseLocId,:PackUserId,:packtype,0,0)
	)
	i SQLCODE'=0 tro  q RtnObj.Err(-10,"","插入数据失败SQLCODE:"_SQLCODE_","_$g(%msg))
	s PackId=%ROWID
	
	&sql(Insert into CSSD_Trans
		(CSSDT_Label,CSSDT_Pack_DR,CSSDT_Package_DR,CSSDT_Date,CSSDT_Time,
		CSSDT_ExpDate,cssdt_Status)
		Values
		(:PackLabel,:PackId,:PackageId,:pdate,:ptime,
		:ExpDate,'P')
	)
	i SQLCODE'=0 tro  q RtnObj.Err(-12,"","插入数据失败SQLCODE:"_SQLCODE_","_$g(%msg))

	tc
	s RtnObj.rowid=PackId
	q RtnObj
}

}
