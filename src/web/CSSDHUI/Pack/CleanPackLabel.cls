Import SQLuser

Class web.CSSDHUI.Pack.CleanPackLabel Extends (%RegisteredObject, web.CSSDHUI.CSSDType) [ Not ProcedureBlock ]
{

Parameter AppName [ Final ] = "CSSDPACK";

/// Creator:why
/// CreatDate:2019.5.7
/// Description:消毒包标签打印查询已经验收的
/// Table:CSSD_Clean
/// Input:Params
/// Output:
/// Return:清洗信息
/// others:d ##class(%ResultSet).RunQuery("web.CSSDHUI.Pack.CleanPackLabel","SelectAllCheck",^templxt("check"))
Query SelectAllCheck(Params As %String) As web.CSSDHUI.Query(ROWSPEC = "ID:%Integer,CleanNo,CleanMachineDesc,CleanDate,CleanTime,VehicleLabel,CleanUserName,CleanChkUserName,CleanType,IsCmtEnterMachine,IsFinished,LevelFlag") [ SqlProc ]
{
}

ClassMethod SelectAllCheckExecute(ByRef qHandle As %Binary, Params As %String = "") As %Status
{
	n (qHandle,Params)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	s PJObj = ##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 q $$$OK

	s LocId = PJObj.%Get("gLocId")
	s PPkgId=PJObj.%Get("Pkg")
	s PLabel = PJObj.%Get("Label")
	s PCleanMachineId=PJObj.%Get("CleanMachine")
	s PCleanStartDate = PJObj.%Get("CleanStartDate")
	s PCleanEndDate = PJObj.%Get("CleanEndDate")
	s PSterTypeId = PJObj.%Get("SterTypeId")
	s PAttributeCode = PJObj.%Get("AttributeCode")
	s PIsExt=PJObj.%Get("ExtFlag")
	s CleanStartDate=..DH2L(PCleanStartDate)
	s CleanEndDate=..DH2L(PCleanEndDate)
	q:(CleanStartDate="")&&(CleanEndDate="") $$$OK
	
	s Result=##class(%Library.ResultSet).%New()
	s SqlStr="select ID ,cssdc_no as CleanNo,cssdc_date as CleanDate,"
			_" cssdc_time as  CleanTime,cssdc_cleanVehicleLbl as VehicleLabel,"
			_" cssdc_cleanerdr->ssusr_name as CleanUserName ,cssdc_chkerdr->ssusr_name as CleanChkUserName,"
			_" cssdc_iscreatelbl as iscreatelbl,CSSDC_CleanProgress as pro,"
			_" cssdc_cleanmethod->CSSDCT_CleanMode as CleanType,CSSDC_IsCmtEnterMachine as IsCmtEnterMachine,"
			_" CSSDC_IsCreateLbl as IsCreateLbl,CSSDC_MachineConfigDr->CSSDMC_Alias as CleanMachineDesc "
			_" from cssd_clean "
			_" where cssdc_date>='"_CleanStartDate_"' and cssdc_date<='"_CleanEndDate_"' "
			_" and CSSDC_ChkTime is not null and CSSDC_Result = 1 "
	s:LocId'="" SqlStr=SqlStr_" and cssdc_loc_Dr='"_LocId_"'"
	s:PCleanMachineId'="" SqlStr=SqlStr_" and CSSDC_MachineConfigDr='"_PCleanMachineId_"'"
	
	d Result.RuntimeModeSet(0)
	d Result.Prepare(SqlStr)
	d Result.Execute()
	While(Result.Next())
	{
		s ID = Result.Data("ID")
		s CleanNo = Result.Data("CleanNo")
		s CleanMachineDesc = Result.Data("CleanMachineDesc")
		s CleanDate = Result.Data("CleanDate")
		s CleanDate=..DL2H(CleanDate)
		s CleanTime = Result.Data("CleanTime")
		s CleanTime=..TL2H(CleanTime)
		s VehicleLabel = Result.Data("VehicleLabel")
		s CleanUserName = Result.Data("CleanUserName")
		s CleanChkUserName = Result.Data("CleanChkUserName")
		s CleanType = Result.Data("CleanType")
		s IsCmtEnterMachine = Result.Data("IsCmtEnterMachine")
		s IsFinished = +Result.Data("IsCreateLbl")
		s Flag=##class(web.CSSDHUI.Clean.CleanInfo).IFLabelByCLeanDetail(ID,PLabel)
		continue:(PLabel'="")&&(Flag="N")
		
		s (CleanItmId,LevelFlag)="",ExistFlag="N"
		f  s CleanItmId=$o(^User.CSSDCleanDetailPacksI("IndexMainDr",ID,CleanItmId)) q:(CleanItmId="")||(ExistFlag="Y")  d
		.s CleanItmObj=##Class(User.CSSDCleanDetailPacks).%OpenId(CleanItmId)
		.s states=CleanItmObj.CSSDCDPStates
		.s PkgObj=CleanItmObj.CSSDPRPackage
		.s ItmLevelFlag=CleanItmObj.CSSDCDPLevelFlag
		.i ItmLevelFlag=1 s LevelFlag=1
		.s PkgId=PkgObj.%Id()
		.s AttributeCode=PkgObj.CSSDPPackTypeDetail
		.s SterTypeId=PkgObj.CSSDPSterTypeGetObjectId()
		.s ExtObj=CleanItmObj.CSSDCDPExtDR
		.s Flag=CleanItmObj.CSSDCDPFlag
		.s IsExt=##class(web.CSSDHUI.Common.PackageInfoCommon).GetExtFlag(PkgId)
		.q:states="N"
		.q:Flag="SS"	//过滤二次消毒
		.s TransFlag="N"
		.i $IsObject(ExtObj) d
		..s TransFlag=ExtObj.CSSDExtIsTransfer
		.q:TransFlag="Y"
		.q:(PAttributeCode'="")&&(PAttributeCode'=AttributeCode)
		.q:(PIsExt'="")&&(PIsExt'=IsExt)
		.q:(PPkgId'="")&&(PPkgId'=PkgId)
		.q:(PSterTypeId'="")&&(PSterTypeId'=SterTypeId)
		.s ExistFlag="Y"
		continue:ExistFlag="N"
		
		d OutPutRow
	}
	d Result.Close()
	q $$$OK
OutPutRow
	s Data=$lb(ID,CleanNo,CleanMachineDesc,CleanDate,CleanTime,VehicleLabel,CleanUserName,CleanChkUserName,CleanType,IsCmtEnterMachine,IsFinished,LevelFlag)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// 查询标签数据
/// d ##class(%ResultSet).RunQuery("web.CSSDHUI.Pack.CleanPackLabel","SelectAllLabel",^templxt("AllLabel"))
Query SelectAllLabel(Params As %String) As web.CSSDHUI.Query(ROWSPEC = "CleanItmId:%Integer,CodeDict,LocDesc,PkgId,PkgDesc,Qty,CreatedQty,unCreatedQty,IsPrint,ComposeFlag,ComposePkgDr,ComposePkgName,IsSter,SterTypeDesc,SterTypeId,MaterialId,LevelFlag,IsLowerSter,AttributeCode,IsExt,AttributeDesc,OprLabel") [ SqlProc ]
{
}

ClassMethod SelectAllLabelExecute(ByRef qHandle As %Binary, Params As %String) As %Status
{
	n (qHandle,Params)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	s PJObj = ##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	q:Sc'=0 $$$OK

	s PCleanID=PJObj.%Get("CleanID")
	s PPkgId=PJObj.%Get("PkgId")
	s PSterTypeId=PJObj.%Get("SterTypeId")
	s PAttributeCode=PJObj.%Get("AttributeCode")
	s PLabel=PJObj.%Get("Label")
	s PIsExt=PJObj.%Get("ExtFlag")
	q:PCleanID="" $$$OK
	s Result=##class(%Library.ResultSet).%New()

	s SqlStr="select a.ID as CleanItmId, cssdcdp_label as CodeDict ,CSSDCDP_Qty as Qty, CSSDCDP_CleanMainDR as maindr,"
		_"CSSDPR_Package_DR->CSSDP_Desc as PkgDesc, CSSDPR_Package_DR->CSSDP_PackTypeDetail as packtype ,CSSDPR_Package_DR  as PkgId,"
		_"cssdcdp_IsCrtLbl as IsCrtLbl,CSSDCDP_MaterialDR as MaterialId, CSSDCDP_CreatedQty as CreatedQty,(CSSDCDP_Qty-CSSDCDP_CreatedQty) as unCreatedQty,"
		_"b.CSSDCD_Parref_DR->CSSDPC_FromLoc_DR->CTLOC_Desc AS LocDesc,CSSDCDP_Flag as Flag,CSSDCDP_ExtDR as ExtDR "
		_" from CSSD_CleanDetailPacks a LEFT JOIN CSSD_CallBackDetailNew b on a.CSSDCDP_CallBackDetailDr=b.CSSDCD_Rowid"
		_" where CSSDCDP_CleanMainDR in ("_PCleanID_")"
		_" and a.CSSDCDP_States='Y' "
	d Result.RuntimeModeSet(0)
	d Result.Prepare(SqlStr)
	d Result.Execute()
	While(Result.Next())
	{
		s CleanItmId = Result.Data("CleanItmId")
		s LocDesc = Result.Data("LocDesc")
		s PkgId = Result.Data("PkgId")
		s PkgDesc = Result.Data("PkgDesc")
		s Qty = Result.Data("Qty")
		s CreatedQty = +Result.Data("CreatedQty")
		s PkgDesc = Result.Data("PkgDesc")
		s Flag=Result.Data("Flag")
		s ExtDR=Result.Data("ExtDR")
		s AttributeCode=$lg(^User.CSSDPackageD(PkgId),15)
		s SterTypeId=$lg(^User.CSSDPackageD(PkgId),21)
		s IsExt=$lg(^User.CSSDPackageD(PkgId),2)
		s unCreatedQty=Qty-CreatedQty
		s AttributeDesc=##class(web.CSSDHUI.Common.PackageInfoCommon).GetPackageDetailDesc(AttributeCode)
		continue:Flag="SS"	//过滤二次消毒
		s TransFlag="N"
		i (ExtDR'="") d
		.s ExtObj=##class(User.CSSDExtDevBind).%OpenId(ExtDR)
		.d ExtObj.%Reload()
		.s TransFlag=ExtObj.CSSDExtIsTransfer
		continue:TransFlag="Y"
		continue:(PAttributeCode'="")&&(PAttributeCode'=AttributeCode)
		continue:(PIsExt'="")&&(PIsExt'=IsExt)
		continue:(PPkgId'="")&&(PPkgId'=PkgId)
		continue:(PSterTypeId'="")&&(PSterTypeId'=SterTypeId)
		
		s num=0
		i PLabel'="" d
		.&sql(select count(*) into:num FROM CSSD_Trans WHERE CSSDT_Clean_DR=:CleanItmId AND CSSDT_Label=:PLabel)
		continue:((PLabel'="")&&(num=0))
		
		s SterTypeObj=##class(User.CSSDSterType).%OpenId(SterTypeId)
		s (SterTypeDesc,IsSter,IsLowerSter)=""
		i $IsObject(SterTypeObj) d
		.s SterTypeDesc=SterTypeObj.CSSDSTSterName
		.s IsSter=SterTypeObj.CSSDSTIsSter
		.s IsLowerSter=SterTypeObj.CSSDSTIsLowerTemp
		
		s CleanItmObj = ##class(User.CSSDCleanDetailPacks).%OpenId(CleanItmId)
		continue:'$IsObject(CleanItmObj)
		s (ComposePkgDr)=""
		s PackFlag = CleanItmObj.CSSDCDPPackFlag
		s ComposeFlag = CleanItmObj.CSSDCDPComposeFlag
		s ComposePkgObj = CleanItmObj.CSSDCDPComposePkg
		s LevelFlag = CleanItmObj.CSSDCDPLevelFlag
		s ComposePkgName = CleanItmObj.CSSDCDPComposePkgName
		s CodeDict=CleanItmObj.CSSDCDPLabel
		i $IsObject(ComposePkgObj) s ComposePkgDr = ComposePkgObj.CSSDPDesc		//???
		
		s sumPackQty=0,sumComposeQty=0
		i PackFlag="Y" d
		.&sql(SELECT sum(CSSDCDPN_PackQty) into :sumPackQty FROM CSSD_CleanDetailPacksNumber where CSSDCDPN_CleanDetailDR=:CleanItmId)
		.s unCreatedQty =sumPackQty
		i ComposeFlag="Y" d
		.&sql(SELECT sum(CSSDCDPC_Qty) into :sumComposeQty FROM CSSD_CleanPackCompose where CSSDCDPC_CleanDetailDR=:CleanItmId)
		.s unCreatedQty =sumComposeQty
		
		
		s IsPrint=0,ExistNoPrint="N",count=0,OprLabel=""
		s CleanId=$lg(^User.CSSDCleanDetailPacksD(CleanItmId),3)
		s PackId=""
		f  s PackId=$o(^User.CSSDPackagePackI("CSSDPPCleanDrPackageDrIndex",CleanId,CleanItmId,PkgId,PackId)) q:PackId=""  d
		.s count=count+1
		.s PrintNum=+$lg(^User.CSSDPackagePackD(PackId),30)
		.i AttributeCode="1" s OprLabel=$lg(^User.CSSDPackagePackD(PackId),3)
		.s:PrintNum=0 ExistNoPrint="Y"
		s:((count>0)&(ExistNoPrint="N")) IsPrint=1
		
		d OutPutRowAllLabel
	}
	d Result.Close()
	q $$$OK
OutPutRowAllLabel
	s Data=$lb(CleanItmId,CodeDict,LocDesc,PkgId,PkgDesc,Qty,CreatedQty,unCreatedQty,IsPrint,ComposeFlag,
		ComposePkgDr,ComposePkgName,IsSter,SterTypeDesc,SterTypeId,MaterialId,LevelFlag,IsLowerSter,AttributeCode,IsExt,
		AttributeDesc,OprLabel)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// Creator:why
/// CreatDate:2019.08.12
/// Description:生成普通循环包的标签
/// Table:LocId 消毒供应室的id ,CSSD_PackagePack,CSSD_PackageApplyDetail
/// Input:Main,detailIDs 明细表的id组成的字符串,配包人id,打包人的id,num:生成数量
/// Output:
/// Return:
/// Others：w ##Class(web.CSSDHUI.Pack.CleanPackLabel).jsGenLabel(^templxt("gen",1),^templxt("gen",2))
ClassMethod jsGenLabel(Main, Detail) As %String
{
	n (Main,Detail)
	s $ZT=..sssError()
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	ts
	s RtnObj=..GenLabel(Main,Detail)
	i RtnObj.success<0 tro  q RtnObj.Json()
	tc
	q RtnObj.Json()
}

/// Creator:why
/// CreatDate:2019.08.12
/// Description:生成普通循环包的标签
/// Table:LocId 消毒供应室的id ,CSSD_PackagePack,CSSD_PackageApplyDetail
/// Input:Main,detailIDs 明细表的id组成的字符串,配包人id,打包人的id,num:生成数量
/// Output:
/// Return:
/// Others：w ##Class(web.CSSDHUI.Pack.CleanPackLabel).GenOrdLabel("{""PackChkUser"":""6423"",""gUserId"":""6423"",""gLocId"":""166"",""gGroupId"":""103"",""gHospId"":""2"",""PackUser"":""13034"",""Packer"":""12204"",""MaterialId"":"""",""ToLoc"":"""",""PotNoValue"":"""",""SterTypeId"":"""",""isPackUserValue"":"""",""PotNoSterType"":"""",""Label"":"""",""SterDate"":"""",""HeatNo"":""""}","[{""CleanItmId"":""96"",""LocDesc"":"""",""PkgId"":""41"",""PkgDesc"":""肛管包"",""Qty"":""1"",""CreatedQty"":""0"",""unCreatedQty"":""1"",""IsPrint"":""N"",""ComposeFlag"":"""",""ComposePkgDr"":"""",""ComposePkgName"":"""",""IsSter"":""Y"",""SterTypeDesc"":""高温灭菌"",""SterTypeId"":""1"",""MaterialId"":""1"",""LevelFlag"":""""}]","")
ClassMethod GenLabel(Main, Detail) As %String
{
	n (Main,Detail)
	s MethodName=$ClassName()_".GenLabel"
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	q:((Main="")||(Detail="")) RtnObj.Err(-1,"","入参不能为空!")

	s PJObjMain=##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=PJObjMain.%FromJSON(Main)
	q:Sc'=0 RtnObj.Err(-1,"","入参解析失败!","",0)

	s PJObjDetail=##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=PJObjDetail.%FromJSON(Detail)
	q:Sc'=0 RtnObj.Err(-1,"","入参解析失败!","",0)

	s gLocId=PJObjMain.%Get("gLocId")
	s gUserId=PJObjMain.%Get("gUserId")
	s gGroupId=PJObjMain.%Get("gGroupId")
	s gHospId=PJObjMain.%Get("gHospId")
	s PPackChkUserId=PJObjMain.%Get("PackChkUser")
	s PPackUserId=PJObjMain.%Get("PackUser")
	s PPackerId=PJObjMain.%Get("Packer")
	s PSterDate=PJObjMain.%Get("SterDate")
	s PMaterialId=PJObjMain.%Get("MaterialId")
	s PToLocId=PJObjMain.%Get("ToLoc")
	s PSterMachineId=PJObjMain.%Get("SterMachine")
	s PHeatNo=PJObjMain.%Get("HeatNo")
	s PSterUserId=PJObjMain.%Get("SterUser")
	s PNum=+PJObjMain.%Get("LabelQty")
	s PPackNum=+PJObjMain.%Get("packNum")
	s PRemark=PJObjMain.%Get("Remark")
	s PSterDate=..DH2L(PSterDate)
	s Param=gGroupId_"^"_gLocId_"^"_gUserId_"^"_gHospId
	s AppName=..%GetParameter("AppName")
	s IsExpDateInCurDay=##class(web.CSSDHUI.Common.AppCommon).GetParamValue(AppName,"IsExpDateInCurDay",Param)
	s isPackUserValue=##class(web.CSSDHUI.Common.AppCommon).GetParamValue(AppName,"IsPackUser",Param)
	q:PPackChkUserId="" RtnObj.Err(-1,"","审核人为空","",0)
	q:PPackUserId="" RtnObj.Err(-1,"","包装人为空","",0)
	q:((isPackUserValue="Y") && (PPackerId="")) RtnObj.Err(-1,"","配包人为空","",0)

	s SterDate=+$h,SterTime=$p($h,",",2)
	i (PSterDate'="")&&(PSterDate'=+$h) s SterDate=PSterDate,SterTime=0
	
	ts
	s Ret=..sssLock(AppName)
	i Ret'=0 tro  q RtnObj.Err(-99,"","加锁失败")

	while(RtnObj.success=0){
		s Obj=PJObjDetail.%Pop()
		q:Obj=""

		s (NumFlag,GenNum)=0
		s (CBItmId,CBLocId)=""
		
		s CleanItmId=Obj.%Get("CleanItmId")
		s MaterialId=Obj.%Get("MaterialId")
		s LevelFlag=Obj.%Get("LevelFlag")
		
		s CleanItmObj=##class(User.CSSDCleanDetailPacks).%OpenId(CleanItmId)
		d CleanItmObj.%Reload()
		s States=CleanItmObj.CSSDCDPStates
		s IsGen=CleanItmObj.CSSDCDPIsCrtLbl
		s CodeDict=CleanItmObj.CSSDCDPLabel	;固定标签
		s CBItmObj=CleanItmObj.CSSDCDPCallBackDetailDr
		s CSSDCDPQty=CleanItmObj.CSSDCDPQty
		s CSSDCDPCreatedQty=CleanItmObj.CSSDCDPCreatedQty
		s CodeDict=CleanItmObj.CSSDCDPLabel
		s CleanObj=CleanItmObj.CSSDCDPCleanMain
		s CleanId=CleanObj.%Id()
		s CleanDate=CleanObj.CSSDCDate
		s PkgObj=CleanItmObj.CSSDPRPackage
		s ExtDr = CleanItmObj.CSSDCDPExtDRGetObjectId()
		s PkgId=PkgObj.%Id()
		s PkgCode=PkgObj.CSSDPCode
		s AttributeCode=PkgObj.CSSDPPackTypeDetail
		s WorkTimes=PkgObj.CSSDPWorkTimes	//消毒包设置的最大使用次数
		s RecLocId=PkgObj.CSSDPLOCDRGetObjectId()
		s IsExt=##class(web.CSSDHUI.Common.PackageInfoCommon).GetExtFlag(PkgId)
		i $IsObject(CBItmObj) d
		.s CBItmId=CBItmObj.%Id()
		.s CBLocId=..GetLocID(CBItmId)
		.s RecLocId=CBLocId
		s:PToLocId'="" RecLocId=PToLocId
		continue:IsGen=1
		i States'="Y" d RtnObj.Err(-5,"","该消毒包未验收合格!","",0)
		continue:RtnObj.success'=0
		
		;是否已生成标签
		s minusNum=CSSDCDPQty-CSSDCDPCreatedQty
		s GenNum=$s(PNum=0:minusNum,PNum>minusNum:minusNum,1:PNum)
		i GenNum=minusNum s NumFlag=1
		i GenNum=0 d RtnObj.Err(-1,"","待生成数量为0","",0)
		continue:RtnObj.success<0
		
		s SerialNo=##class(web.CSSDHUI.Common.AppCommon).CreatePackSerialNo()
		s:(PMaterialId'="") MaterialId=PMaterialId
		s:(MaterialId="") MaterialId=##Class(web.CSSDHUI.Common.PackageInfoCommon).GetDefaultMaterial(PkgId)
		i MaterialId="" d RtnObj.Err(-1,"","未获取到消毒包清洗绑定的包装材料！","",0)
		continue:RtnObj.success'=0

		s MaterialInfo=##class(web.CSSDHUI.Common.PackageInfoCommon).GetMaterialExpireLength(MaterialId,PkgId)
		i MaterialInfo="" d RtnObj.Err(-2,"","消毒包和包装材料未做绑定！","",0)
		continue:RtnObj.success'=0

		s length=$p(MaterialInfo,"^",1)
		s price=$p(MaterialInfo,"^",2)
		i length=0 d RtnObj.Err(-3,"","消毒包有效期为空","",0)
		continue:RtnObj.success'=0
		i IsExpDateInCurDay="Y" s ExpDate=SterDate+length
		e  s ExpDate=SterDate+length+1
		
		//标牌追溯包单独判断条件
		s (CodeDictId)=""
		i (AttributeCode=1) d
		.s CodeDictId =$o(^User.CSSDCodeDictI("CSSDCDCodeIndex",CodeDict,""))
		.i CodeDictId="" d RtnObj.Err(-4,"","标牌信息不存在！","",0) q
		.s CodeDictObj=##Class(User.CSSDCodeDict).%OpenId(CodeDictId)
		.i '$IsObject(CodeDictObj) d RtnObj.Err(-5,"","标牌信息不存在！","",0) q
		.s CycleCount=CodeDictObj.CSSDCDCycleCount	//循环数
		.i ((+WorkTimes'=0)&&(WorkTimes<CycleCount)) d RtnObj.Err(-1,"","该标牌已达到所设置的最大使用次数，不能生成标签！","",0) q
		continue:RtnObj.success'=0
		
		s Labels="",BindLabel=""
		i IsExt="Y" d
		.s BindLabel=..GetExtBindLabel(CodeDict,CSSDCDPCreatedQty)
		.i BindLabel="" d RtnObj.Err(-1,"","生成绑定的固定标签为空 检查包属性","",0) q
		.s Labels=..GetExtLabels(BindLabel,GenNum)
		e  i AttributeCode=2 d
		.s Labels=..GetOrdLabels(PkgCode,GenNum)
		e  i (AttributeCode=1) d
		.s Labels=..GetOprLabel(CodeDict)
		
		i Labels="" d RtnObj.Err(-6,"","条码生成失败！","",0)
		continue:RtnObj.success'=0
		
		s IsExtCount=0
		s lblLenth=$L(Labels,"^")
		f j=1:1:lblLenth q:RtnObj.success<0  d
		.s Label=$p(Labels,"^",j)
		.//插入打包表
		.s PackObj=##class(User.CSSDPackagePack).%New()
		.s PackObj.CSSDPPLabel=Label
		.d PackObj.CSSDPPPackageSetObjectId(PkgId)
		.d PackObj.CSSDPPLocDrSetObjectId(gLocId)
		.s PackObj.CSSDPPDate=SterDate
		.s PackObj.CSSDPPTime=SterTime
		.s PackObj.CSSDPPQty=1
		.d PackObj.CSSDPPUserDrSetObjectId(PPackUserId)
		.d PackObj.CSSDPPAckUserDrSetObjectId(PPackChkUserId)
		.s PackObj.CSSDPPAckDate=SterDate
		.s PackObj.CSSDPPSerialNo=SerialNo
		.d PackObj.CSSDPPPackLocDrSetObjectId(RecLocId)
		.d PackObj.CSSDPPPackUserDrSetObjectId(PPackerId)
		.d PackObj.CSSDPPMaterialDrSetObjectId(MaterialId)
		.s PackObj.CSSDPPIsLoadSteCar=0
		.s PackObj.CSSDPPLevelFlag=LevelFlag
		.d PackObj.CSSDPPFixedLabelSetObjectId(CodeDictId)
		.s PackObj.CSSDPPPrtTimes=0
		.d PackObj.CSSDPPCleanDRSetObjectId(CleanId)
		.d PackObj.CSSDPPCleanDetailDRSetObjectId(CleanItmId)
		.d PackObj.CSSDPPSterUserDrSetObjectId(PSterUserId)
		.d PackObj.CSSDPPCallDetailDrSetObjectId(CBItmId)
		.d PackObj.CSSDPPApplyLocSetObjectId(CBLocId)
		.s PackObj.CSSDPPHeatNo=PHeatNo
		.d PackObj.CSSDPPMachineDRSetObjectId(PSterMachineId)
		.s PackObj.CSSDPPPackNum=PPackNum
		.s PackObj.CSSDPPNewLabel=BindLabel
		.s PackObj.CSSDPPRemark=PRemark
		.s Sc=PackObj.%Save()
		.i $$$ISERR(Sc) d RtnObj.Err(-10,"","插入数据失败:"_MethodName)
		.q:RtnObj.success'=0
		.s PackId=PackObj.%Id()
		.//插入trans表
		.s TransObj=##class(User.CSSDTrans).%New()
		.s TransObj.CSSDTLabel=Label
		.d TransObj.CSSDTPackSetObjectId(PackId)
		.d TransObj.CSSDTPackageSetObjectId(PkgId)
		.d TransObj.CSSDTCleanSetObjectId(CleanItmId)
		.s TransObj.CSSDTDate=SterDate
		.s TransObj.CSSDTTime=SterTime
		.s TransObj.CSSDTExpDate=ExpDate
		.s TransObj.CSSDTStatus="P"
		.d TransObj.CSSDTCodeDictDRSetObjectId(CodeDictId)
		.s TransObj.CSSDTCodeDict=CodeDict
		.d TransObj.CSSDTPreCallBackDetailDRSetObjectId(CBItmId)
		.d TransObj.CSSDTCurrLocDRSetObjectId(gLocId)
		.s Sc=TransObj.%Save()
		.i $$$ISERR(Sc) d RtnObj.Err(-11,"","插入数据失败:"_MethodName)
		.q:RtnObj.success'=0
		.s TransId=TransObj.%Id()
		.//更新标牌使用次数
		.s CycleCount=1		//标牌增加循环次数
		.i IsExt="Y" d
		..s labelNo=$E(Label,$l(Label)-1,$l(Label))
		..s ExtDetailDr=$o(^User.CSSDExtDevBindDetailI("CSSDParrefDrPkgNumIndex",ExtDr,labelNo,0))
		..i ExtDetailDr'="" d
		...&sql(UPDATE CSSD_ExtDevBindDetail SET CSSDEBD_Label =:Label WHERE CSSDEBD_Parref_DR=:ExtDr and CSSDEBD_PkgNum=:labelNo)
		...i SQLCODE'=0 d RtnObj.Err(-3,"","更新外来器械明细数据失败") q
		..q:RtnObj.success<0
		..i IsExtCount=0 d
		...&sql(Update CSSD_ExtDevBind set CSSDExt_Label=:BindLabel,CSSDExt_Status='P' where CSSDExt_Rowid=:ExtDr)
		...i SQLCODE'=0 d RtnObj.Err(-12,"","更新数据失败,未获取到外来器械登记信息！")
		..e  d
		...s CycleCount=0	//外来器械同一明细非第一次生成，不增加标牌循环次数
		..q:RtnObj.success<0
		..s IsExtCount=IsExtCount+1
		.i (AttributeCode=1) d
		..s CodeDictObj=##class(User.CSSDCodeDict).%OpenId(CodeDictId)
		..d CodeDictObj.%Reload()
		..s CodeDictObj.CSSDCDTableRowID=TransId
		..s CodeDictObj.CSSDCDCycleCount=CodeDictObj.CSSDCDCycleCount+CycleCount
		..s Sc=CodeDictObj.%Save()
		..i $$$ISERR(Sc) d RtnObj.Err(-12,"","更新数据失败:"_MethodName)
		..q:RtnObj.success'=0
		.q:RtnObj.success'=0
		continue:RtnObj.success<0

		&sql(Update CSSD_CleanDetailPacks set cssdcdp_CreatedQty=cssdcdp_CreatedQty+:GenNum,CSSDCDP_IsCrtLbl=:NumFlag where %id=:CleanItmId)
		i SQLCODE'=0 d RtnObj.Err(-21,"","更新数据失败:"_MethodName_":SQLCODE"_SQLCODE_":"_$g(%msg))
		continue:RtnObj.success<0

		s RtnObj=..UpdateCleanIsCreateLbl(CleanId)
		continue:RtnObj.success'=0
	}
	i RtnObj.success'=0 tro  d ..sssUnLock(AppName) q RtnObj

	d ..sssUnLock(AppName)
	tc
	q RtnObj
}

/// 获取标签信息,包装人,审核人,配包人
/// Return 标签^审核人^包装人^配包人^包装材料^备注^打印次数
/// w ##Class(web.CSSDHUI.Pack.CleanPackLabel).GetLabelPackChkInfo("2","50","102049001",2)
ClassMethod GetLabelPackChkInfo(CleanId As %String, PkgId As %String, CodeDict As %String, CleanItmId As %String)
{
	n (CleanId,PkgId,CodeDict,CleanItmId)
	s (PackId,Result)=""
	s flag=0
	f  s PackId= $o(^User.CSSDPackagePackI("CSSDPPCleanDrPackageDrIndex",CleanId,CleanItmId,PkgId,PackId)) q:((PackId="")!(flag=1))  d
	.s PackObj=""
	.s PackObj= ##Class(User.CSSDPackagePack).%OpenId(PackId)
	.d PackObj.%Reload()
	.s Label=PackObj.CSSDPPLabel
	.i CodeDict=##class(web.CSSDHUI.Common.PackageInfoCommon).GetFixedLabel(Label) d
	..s flag=1
	..s Result=..GetPackChkInfo(Label)
	q Result
}

/// 获取标签信息,包装人,审核人,配包人
/// Return 标签^审核人^包装人^配包人^包装材料^备注^打印次数
/// w ##Class(web.CSSDHUI.Pack.CleanPackLabel).GetPackChkInfo("001043002000001")
ClassMethod GetPackChkInfo(Label As %String) As %String
{
	 n (Label)
	 s Ret=""
	 s PackId= $o(^User.CSSDPackagePackI("CSSDPPLabelIndex",Label,""))
	 q:PackId="" Ret

	s PackObj=""
	s PackObj=##Class(User.CSSDPackagePack).%OpenId(PackId)
	q:'$IsObject(PackObj)

	s (PackUserName,PackChkUserName,PackerName,SterUserName)=""
	/// 包装人
	s PackUserObj=PackObj.CSSDPPUserDr
	s:$IsObject(PackUserObj) PackUserName=..sssUserName(PackUserObj.%Id())
	/// 审核人
	s ChkObj=PackObj.CSSDPPAckUserDr
	s:$IsObject(ChkObj) PackChkUserName=..sssUserName(ChkObj.%Id())
	/// 配包人
	s PackerObj=PackObj.CSSDPPPackUserDr
	s:$IsObject(PackerObj) PackerName=..sssUserName(PackerObj.%Id())
	/// 包装材料
	s MaterialDesc=""
	s MaterialObj=PackObj.CSSDPPMaterialDr
	s Remark=PackObj.CSSDPPRemark
	s:$IsObject(MaterialObj) MaterialDesc=MaterialObj.CSSDMDesc
	s PrintNum=PackObj.CSSDPPPrtTimes
	/// 灭菌人
	s SterUserObj=PackObj.CSSDPPSterUserDr
	s:$IsObject(SterUserObj) SterUserName=..sssUserName(SterUserObj.%Id())

	s Ret=Label_"^"_PackChkUserName_"^"_PackUserName_"^"_PackerName_"^"_MaterialDesc_"^"_Remark_"^"_PrintNum_"^"_SterUserName
	q Ret
}

/// Creator:why
/// CreatDate:2012.5.7
/// Description:生成标牌追溯包标签
/// Table:LocId 消毒供应室的id ,CSSD_PackagePack ,CSSD_PackageApplyDetail
/// Input:Main:Detail
/// Output:
/// Return:w ##Class(web.CSSDHUI.Pack.CleanPackLabel).GenOprLabel("{""PackChkUser"":""11889"",""gUserId"":""13922"",""gLocId"":""166"",""gGroupId"":""294"",""gHospId"":""2"",""PackUser"":""11889"",""Packer"":""11889"",""SterDate"":""2023-01-10"",""MaterialId"":""1"",""ToLoc"":""1"",""SterMachine"":""1"",""HeatNo"":""2""}","[{""CleanItmId"":""15"",""CodeDict"":""102053001"",""PkgDesc"":""标牌追溯包测试001"",""Label"":""102053001000001"",""PkgId"":""54"",""PackChkUser     Name"":""xd01"",""PackUserName"":""xd01"",""SterTypeId"":""1"",""SterTypeDesc"":""高温灭菌"",""IsLowerSter"":""N"",""IsPrint"":""Y"",""PackerName"":""xd01"",""M    aterialId"":"""",""LevelFlag"":""0"",""LocDesc"":"""",""MaterialDesc"":""包装材料测试1"",""Remark"":"""",""SterItmId"":""""}]")
ClassMethod GenOprLabel(Main, Detail) As %String
{
	n (Main,Detail)
	s MethodName=$ClassName()_".GenOprLabel"
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	q:((Main="")||(Detail="")) RtnObj.Err(-1,"","入参不能为空!")

	s PJObjMain=##class(web.CSSDHUI.Common.FromJson).%New()
	s ScMain=PJObjMain.%FromJSON(Main)
	s PJObjDetail=##class(web.CSSDHUI.Common.FromJson).%New()
	s ScDetail=PJObjDetail.%FromJSON(Detail)

	s LocId=PJObjMain.%Get("gLocId")
	s gGroupId=PJObjMain.%Get("gGroupId")
	s gUserId=PJObjMain.%Get("gUserId")
	s gHospId=PJObjMain.%Get("gHospId")
	s PPackChkUserId=PJObjMain.%Get("PackChkUser")
	s PPackUserId=PJObjMain.%Get("PackUser")
	s PPackerId=PJObjMain.%Get("Packer")
	s PSterDate=PJObjMain.%Get("SterDate")
	s PMaterialId=PJObjMain.%Get("MaterialId")
	s ToLoc=PJObjMain.%Get("ToLoc")
	s PSterUserId=PJObjMain.%Get("SterUser")
	s Param=gGroupId_"^"_LocId_"^"_gUserId_"^"_gHospId
	s AppName=..%GetParameter("AppName")
	s IsExpDateInCurDay=##class(web.CSSDHUI.Common.AppCommon).GetParamValue(AppName,"IsExpDateInCurDay",Param)
	q:((ScMain'=0)||(ScDetail'=0)) RtnObj.Err(-1,"","入参解析失败:"_MethodName).Json()
	q:PPackChkUserId="" RtnObj.Err(-1,"","审核人为空！","",0)
	q:PPackUserId="" RtnObj.Err(-1,"","包装人为空！","",0)

	s SterDate=+$h
	s SterTime=$p($h,",",2)
	i ((PSterDate'=SterDate)&&(PSterDate'="")) d
	.s SterDate=..DH2L(PSterDate)
	.s SterTime=0
	ts
	s Ret=..sssLock(AppName)
	i Ret'=0 tro  q RtnObj.Err(-99,"","加锁失败")

	while(RtnObj.success=0){
		s Obj=PJObjDetail.%Pop()
		q:Obj=""

		s CleanItmId=Obj.%Get("CleanItmId")
		s MaterialId=Obj.%Get("MaterialId")
		s LevelFlag=Obj.%Get("LevelFlag")
		s CleanItmObj=""
		s CleanItmObj=##class(User.CSSDCleanDetailPacks).%OpenId(CleanItmId)
		d CleanItmObj.%Reload()
		s CleanObj=CleanItmObj.CSSDCDPCleanMain
		s CleanId=CleanObj.%Id()
		s CleanDate=CleanObj.CSSDCDate
		s CodeDict=CleanItmObj.CSSDCDPLabel	;固定标签
		s PkgObj=CleanItmObj.CSSDPRPackage
		s CBItmId=CleanItmObj.CSSDCDPCallBackDetailDrGetObjectId()
		s PkgId=PkgObj.%Id()
		s WorkTimes=PkgObj.CSSDPWorkTimes	//消毒包设置的最大使用次数
		s SerialNo=##class(web.CSSDHUI.Common.AppCommon).CreatePackSerialNo()
		s CodeDictId =$o(^User.CSSDCodeDictI("CSSDCDCodeIndex",CodeDict,""))
		i CodeDictId="" d RtnObj.Err(-4,"","标牌信息不存在！","",0)
		continue:RtnObj.success'=0

		s CodeDictObj=##Class(User.CSSDCodeDict).%OpenId(CodeDictId)
		i '$IsObject(CodeDictObj) d RtnObj.Err(-5,"","标牌信息不存在！","",0)
		continue:RtnObj.success'=0

		s CycleCount=CodeDictObj.CSSDCDCycleCount	//循环数
		i ((+WorkTimes'=0)&&(WorkTimes<CycleCount)) d RtnObj.Err(-1,"","该标牌已达到所设置的最大使用次数，不能生成标签！","",0)
		continue:RtnObj.success'=0

		s Label=..GetOprLabel(CodeDict)
		i Label="" d RtnObj.Err(-6,"","条码生成失败！","",0)
		continue:RtnObj.success'=0

		;获取包装材料对应的有效期、价格
		s TempMaterialId=PMaterialId
		s:TempMaterialId="" TempMaterialId =MaterialId
		s:TempMaterialId="" TempMaterialId=##Class(web.CSSDHUI.Common.PackageInfoCommon).GetDefaultMaterial(PkgId)
		i TempMaterialId="" d RtnObj.Err(-1,"","未获取到消毒包清洗绑定的包装材料！","",0)
		continue:RtnObj.success'=0

		s MaterialInfo=##class(web.CSSDHUI.Common.PackageInfoCommon).GetMaterialExpireLength(TempMaterialId,PkgId)
		i MaterialInfo="" d RtnObj.Err(-2,"","消毒包和包装材料未做绑定！","",0)
		continue:RtnObj.success'=0

		s length=$p(MaterialInfo,"^",1)
		s price=$p(MaterialInfo,"^",2)
		i length=0 d RtnObj.Err(-3,"","消毒包有效期为空","",0)
		continue:RtnObj.success'=0

		i IsExpDateInCurDay="Y"	d
		.s ExpDate=SterDate+length
		e  d
		.s ExpDate=SterDate+length+1
		s PackLocId=""
		s PackLoc=PkgObj.CSSDPLOCDR
		s:$IsObject(PackLoc) PackLocId=PackLoc.%Id()
		s:ToLoc'="" PackLocId=ToLoc
		;是否生成标签
		s IsGen=CleanItmObj.CSSDCDPIsCrtLbl
		i IsGen=0 d
		.s PackObj=##class(User.CSSDPackagePack).%New()
		.s PackObj.CSSDPPLabel=Label
		.d PackObj.CSSDPPPackageSetObjectId(PkgId)
		.d PackObj.CSSDPPLocDrSetObjectId(LocId)
		.s PackObj.CSSDPPDate=SterDate
		.s PackObj.CSSDPPTime=SterTime
		.s PackObj.CSSDPPQty=1
		.d PackObj.CSSDPPUserDrSetObjectId(PPackUserId)
		.d PackObj.CSSDPPAckUserDrSetObjectId(PPackChkUserId)
		.s PackObj.CSSDPPAckDate=SterDate
		.s PackObj.CSSDPPSerialNo=SerialNo
		.d PackObj.CSSDPPPackLocDrSetObjectId(PackLocId)
		.d PackObj.CSSDPPPackUserDrSetObjectId(PPackerId)
		.d PackObj.CSSDPPMaterialDrSetObjectId(TempMaterialId)
		.s PackObj.CSSDPPIsLoadSteCar=0
		.s PackObj.CSSDPPLevelFlag=LevelFlag
		.d PackObj.CSSDPPFixedLabelSetObjectId(CodeDictId)
		.s PackObj.CSSDPPPrtTimes=0
		.d PackObj.CSSDPPCleanDRSetObjectId(CleanId)
		.d PackObj.CSSDPPCleanDetailDRSetObjectId(CleanItmId)
		.d PackObj.CSSDPPSterUserDrSetObjectId(PSterUserId)
		.d PackObj.CSSDPPCallDetailDrSetObjectId(CBItmId)
		.s Sc=PackObj.%Save()
		.i $$$ISERR(Sc) d RtnObj.Err(-10,"","插入数据失败:"_MethodName)
		.continue:RtnObj.success'=0
		.
		.s PackId=PackObj.%Id()
		.s TransObj=##class(User.CSSDTrans).%New()
		.s TransObj.CSSDTLabel=Label
		.d TransObj.CSSDTPackSetObjectId(PackId)
		.d TransObj.CSSDTPackageSetObjectId(PkgId)
		.d TransObj.CSSDTCleanSetObjectId(CleanItmId)
		.s TransObj.CSSDTDate=SterDate
		.s TransObj.CSSDTTime=SterTime
		.s TransObj.CSSDTExpDate=ExpDate
		.s TransObj.CSSDTStatus="P"
		.d TransObj.CSSDTCodeDictDRSetObjectId(CodeDictId)
		.s TransObj.CSSDTCodeDict=CodeDict
		.d TransObj.CSSDTPreCallBackDetailDRSetObjectId(CBItmId)
		.d TransObj.CSSDTCurrLocDRSetObjectId(LocId)
		.s Sc=TransObj.%Save()
		.i $$$ISERR(Sc) d RtnObj.Err(-11,"","插入数据失败:"_MethodName)
		.continue:RtnObj.success'=0
		.
		.s TransId=TransObj.%Id()
		.;更改器械包的循环次数，TableRowID指向transId
		.s CodeDictObj=##class(User.CSSDCodeDict).%OpenId(CodeDictId)
		.d CodeDictObj.%Reload()
		.s CodeDictObj.CSSDCDTableRowID=TransId
		.s CodeDictObj.CSSDCDCycleCount=CodeDictObj.CSSDCDCycleCount+1
		.s Sc=CodeDictObj.%Save()
		.i $$$ISERR(Sc) d RtnObj.Err(-12,"","更新数据失败:"_MethodName)
		.continue:RtnObj.success'=0
		.
		.;更新清洗明细表中，已经生成标签
		.s CleanItmObj=##class(User.CSSDCleanDetailPacks).%OpenId(CleanItmId)
		.d CleanItmObj.%Reload()
		.s CleanItmObj.CSSDCDPIsCrtLbl=1
		.s CleanItmObj.CSSDCDPCreatedQty=CleanItmObj.CSSDCDPCreatedQty+1
		.s Sc=CleanItmObj.%Save()
		.i $$$ISERR(Sc) d RtnObj.Err(-13,"","更新数据失败:"_MethodName)
		.continue:RtnObj.success'=0
		e  d
		.s Label=""
		.s result=..GetLabelPackChkInfo(CleanId,PkgId,CodeDict,CleanItmId)
		.s Label=$p(result,"^",1)
		.s PackId=$o(^User.CSSDPackagePackI("CSSDPPLabelIndex",Label,""))
		.s PackObj=##class(User.CSSDPackagePack).%OpenId(PackId)
		.d PackObj.%Reload()
		.d PackObj.CSSDPPUserDrSetObjectId(PPackUserId)
		.d PackObj.CSSDPPAckUserDrSetObjectId(PPackChkUserId)
		.d PackObj.CSSDPPPackUserDrSetObjectId(PPackerId)
		.s PackObj.CSSDPPDate=SterDate
		.s PackObj.CSSDPPTime=SterTime
		.s PackObj.CSSDPPAckDate=SterDate
		.d PackObj.CSSDPPPackLocDrSetObjectId(PackLocId)
		.d PackObj.CSSDPPSterUserDrSetObjectId(PSterUserId)
		.s Sc=PackObj.%Save()
		.i $$$ISERR(Sc) d RtnObj.Err(-22,"","更新数据失败:"_MethodName)
		.continue:RtnObj.success'=0
		.
		.s TransId=$o(^User.CSSDTransI("CSSDTLabel",Label,""))
		.s TransObj=##class(User.CSSDTrans).%OpenId(TransId)
		.d TransObj.%Reload()
		.s TransObj.CSSDTExpDate=ExpDate
		.s Sc=TransObj.%Save()
		.i $$$ISERR(Sc) d RtnObj.Err(-23,"","更新数据失败:"_MethodName)
		continue:RtnObj.success'=0
	}

	i RtnObj.success<0 tro  d ..sssUnLock(AppName) q RtnObj

	s RtnObj=..UpdateCleanIsCreateLbl(CleanId)
	i RtnObj.success<0 tro  d ..sssUnLock(AppName) q RtnObj

	d ..sssUnLock(AppName)
	tc
	q RtnObj
}

/// 生成标牌追溯包标签方法
/// w ##Class(web.CSSDHUI.Pack.CleanPackLabel).GetOprLabel("100006004")
ClassMethod GetOprLabel(Code As %String) As %String
{
	n (Code)
	s MaxNo=""
	&sql(Select Max(CSSDPP_Label) into :MaxNo From CSSD_PackagePack
		WHERE CSSDPP_Label %STARTSWITH :Code)
	s SerialNo=+$e(MaxNo,*-5,*)		;取后6位
	s NewSerialNo=SerialNo+1
	s Label=Code_$tr($j(NewSerialNo,6)," ","0")
	q Label
}

/// Creator:why
/// CreatDate:2019.08.12
/// Description:生成普通循环包的标签
/// Table:LocId 消毒供应室的id ,CSSD_PackagePack,CSSD_PackageApplyDetail
/// Input:Main,detailIDs 明细表的id组成的字符串,配包人id,打包人的id,num:生成数量
/// Output:
/// Return:
/// Others：w ##Class(web.CSSDHUI.Pack.CleanPackLabel).GenOrdLabel("{""PackChkUser"":""6423"",""gUserId"":""6423"",""gLocId"":""166"",""gGroupId"":""103"",""gHospId"":""2"",""PackUser"":""13034"",""Packer"":""12204"",""MaterialId"":"""",""ToLoc"":"""",""PotNoValue"":"""",""SterTypeId"":"""",""isPackUserValue"":"""",""PotNoSterType"":"""",""Label"":"""",""SterDate"":"""",""HeatNo"":""""}","[{""CleanItmId"":""96"",""LocDesc"":"""",""PkgId"":""41"",""PkgDesc"":""肛管包"",""Qty"":""1"",""CreatedQty"":""0"",""unCreatedQty"":""1"",""IsPrint"":""N"",""ComposeFlag"":"""",""ComposePkgDr"":"""",""ComposePkgName"":"""",""IsSter"":""Y"",""SterTypeDesc"":""高温灭菌"",""SterTypeId"":""1"",""MaterialId"":""1"",""LevelFlag"":""""}]","")
ClassMethod GenOrdLabel(Main, Detail) As %String
{
	n (Main,Detail)
	s MethodName=$ClassName()_".GenOrdLabel"
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	q:((Main="")||(Detail="")) RtnObj.Err(-1,"","入参不能为空!")

	s PJObjMain=##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=PJObjMain.%FromJSON(Main)
	q:Sc'=0 RtnObj.Err(-1,"","入参解析失败!","",0)

	s PJObjDetail=##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=PJObjDetail.%FromJSON(Detail)
	q:Sc'=0 RtnObj.Err(-1,"","入参解析失败!","",0)

	s LocId=PJObjMain.%Get("gLocId")
	s gUserId=PJObjMain.%Get("gUserId")
	s gGroupId=PJObjMain.%Get("gGroupId")
	s gHospId=PJObjMain.%Get("gHospId")
	s PPackChkUserId=PJObjMain.%Get("PackChkUser")
	s PPackUserId=PJObjMain.%Get("PackUser")
	s PPackerId=PJObjMain.%Get("Packer")
	s PSterDate=PJObjMain.%Get("SterDate")
	s PMaterialId=PJObjMain.%Get("MaterialId")
	s PToLocId=PJObjMain.%Get("ToLoc")
	s PNum=PJObjMain.%Get("num")
	s PSterMachine=PJObjMain.%Get("SterMachine")
	s PHeatNo=PJObjMain.%Get("HeatNo")
	s PSterUserId=PJObjMain.%Get("SterUser")
	s Param=gGroupId_"^"_LocId_"^"_gUserId_"^"_gHospId
	s AppName=..%GetParameter("AppName")
	s IsExpDateInCurDay=##class(web.CSSDHUI.Common.AppCommon).GetParamValue(AppName,"IsExpDateInCurDay",Param)
	s isPackUserValue=##class(web.CSSDHUI.Common.AppCommon).GetParamValue(AppName,"IsPackUser",Param)
	q:PPackChkUserId="" RtnObj.Err(-1,"","审核人为空","",0)
	q:PPackUserId="" RtnObj.Err(-1,"","包装人为空","",0)
	q:((isPackUserValue="Y") && (PPackerId="")) RtnObj.Err(-1,"","配包人为空","",0)

	i PNum="" s PNum=0
	s SterDate=+$h
	s SterTime=$p($h,",",2)
	i ((PSterDate'=SterDate)&&(PSterDate'="")) d
	.s SterDate=..DH2L(PSterDate)
	.s SterTime=0

	ts
	s Ret=..sssLock(AppName)
	i Ret'=0 tro  q RtnObj.Err(-99,"","加锁失败")

	while(RtnObj.success=0){
		s Obj=PJObjDetail.%Pop()
		q:Obj=""

		s (NumFlag,GenNum)=0
		s (CBItmId,CBLocId)=""
		s CleanItmId=Obj.%Get("CleanItmId")
		s MaterialId=Obj.%Get("MaterialId")
		s LevelFlag=Obj.%Get("LevelFlag")
		s CleanItmObj=##class(User.CSSDCleanDetailPacks).%OpenId(CleanItmId)
		d CleanItmObj.%Reload()
		;是否已生成标签
		s IsGen=CleanItmObj.CSSDCDPIsCrtLbl
		i IsGen'=1 d
		.s minusNum=CleanItmObj.CSSDCDPQty-CleanItmObj.CSSDCDPCreatedQty
		.s GenNum=$s(PNum=0:minusNum,PNum>minusNum:minusNum,1:PNum)
		.i GenNum=minusNum s NumFlag=1
		i GenNum=0 d RtnObj.Err(-1,"","待生成数量为0","",0)
		continue:RtnObj.success<0

		s CleanObj=CleanItmObj.CSSDCDPCleanMain
		s CleanId=CleanObj.%Id()
		s CleanDate=CleanObj.CSSDCDate
		s States=CleanItmObj.CSSDCDPStates
		i States'="Y" d RtnObj.Err(-5,"","该消毒包未验收合格!","",0)
		continue:RtnObj.success'=0

		s CodeDict=CleanItmObj.CSSDCDPLabel	;固定标签
		s CBItmObj=CleanItmObj.CSSDCDPCallBackDetailDr
		i $IsObject(CBItmObj) d
		.s CBItmId=CBItmObj.%Id()
		.s CBLocId=..GetLocID(CBItmId)
		s PkgId=CleanItmObj.CSSDPRPackage.%Id()
		s PkgCode=CleanItmObj.CSSDPRPackage.CSSDPCode
		s AttributeCode=CleanItmObj.CSSDPRPackage.CSSDPPackTypeDetail
		s SerialNo=##class(web.CSSDHUI.Common.AppCommon).CreatePackSerialNo()
		s TempMaterialId=PMaterialId
		s:TempMaterialId="" TempMaterialId=MaterialId
		s:TempMaterialId="" TempMaterialId=##Class(web.CSSDHUI.Common.PackageInfoCommon).GetDefaultMaterial(PkgId)
		i TempMaterialId="" d RtnObj.Err(-1,"","未获取到消毒包清洗绑定的包装材料！","",0)
		continue:RtnObj.success'=0

		s MaterialInfo=##class(web.CSSDHUI.Common.PackageInfoCommon).GetMaterialExpireLength(TempMaterialId,PkgId)
		i MaterialInfo="" d RtnObj.Err(-2,"","消毒包和包装材料未做绑定！","",0)
		continue:RtnObj.success'=0

		s length=$p(MaterialInfo,"^",1)
		s price=$p(MaterialInfo,"^",2)
		i length=0 d RtnObj.Err(-3,"","消毒包有效期为空","",0)
		q:RtnObj.success'=0
		i IsExpDateInCurDay="Y"	d
		.s ExpDate=SterDate+length
		e  d
		.s ExpDate=SterDate+length+1
		s Labels=..GetOrdLabels(PkgCode,GenNum)
		s lblLenth=$L(Labels,"^")
		f j=1:1:lblLenth  q:RtnObj.success<0  d
		.s Label=$p(Labels,"^",j)
		.&sql(Insert into CSSD_PackagePack
			(CSSDPP_Label,CSSDPP_Package_DR,CSSDPP_Loc_DR,CSSDPP_Date,CSSDPP_Time,
			CSSDPP_Qty,CSSDPP_User_DR,CSSDPP_AckUser_DR,CSSDPP_AckDate,CSSDPP_SerialNo,
			CSSDPP_IsLoadSteCar,CSSDPP_ApplyLoc,CSSDPP_CallBackDetailDr,CSSDPP_PackUser_DR,CSSDPP_Material_DR,
			CSSDPP_LevelFlag,CSSDPP_PackLocDr,CSSDPP_PrtTimes,CSSDPP_Clean_DR,CSSDPP_CleanDetail_DR,
			CSSDPP_Machine_Dr,CSSDPP_HeatNo,CSSDPP_SterUser_DR)
			Values
			(:Label,:PkgId,:LocId,:SterDate,:SterTime,
			1,:PPackUserId,:PPackChkUserId,:SterDate,:SerialNo,
			0,:CBLocId,:CBItmId,:PPackerId,:TempMaterialId,
			:LevelFlag,:PToLocId,0,:CleanId,:CleanItmId,
			:PSterMachine,:PHeatNo,:PSterUserId))
		.i SQLCODE'=0 d
		..d RtnObj.Err(-10,"","插入数据失败:"_MethodName_":SQLCODE"_SQLCODE_":"_$g(%msg))
		.continue:RtnObj.success<0
		.s PackId=%ROWID
		.&sql(Insert into CSSD_Trans(CSSDT_Label,CSSDT_Pack_DR,CSSDT_Package_DR,CSSDT_Clean_DR,
			CSSDT_Date,CSSDT_Time,CSSDT_ExpDate,cssdt_Status,CSSDT_PreCallBackDetail_DR,
			CSSDT_CurrLoc_DR)
			Values
			(:Label,:PackId,:PkgId,:CleanItmId,
			:SterDate,:SterTime,:ExpDate,'P',:CBItmId,
			:LocId))
		.i SQLCODE'=0  d
		..d RtnObj.Err(-11,"","插入数据失败:"_MethodName_":SQLCODE"_SQLCODE_":"_$g(%msg))
		.continue:RtnObj.success<0
		continue:RtnObj.success<0

		&sql(Update CSSD_CleanDetailPacks set cssdcdp_CreatedQty=cssdcdp_CreatedQty+:GenNum  where %id=:CleanItmId)
		i SQLCODE'=0  d
		.d RtnObj.Err(-21,"","更新数据失败:"_MethodName_":SQLCODE"_SQLCODE_":"_$g(%msg))
		continue:RtnObj.success<0

		i NumFlag=1 d
		.&sql(Update CSSD_CleanDetailPacks set CSSDCDP_IsCrtLbl=1  where %id=:CleanItmId)
		i SQLCODE'=0  d
		.d RtnObj.Err(-22,"","更新数据失败:"_MethodName_":SQLCODE"_SQLCODE_":"_$g(%msg))
		continue:RtnObj.success<0

		s RtnObj=..UpdateCleanIsCreateLbl(CleanId)
		continue:RtnObj.success'=0
	}
	i RtnObj.success'=0 tro  d ..sssUnLock(AppName) q RtnObj

	d ..sssUnLock(AppName)
	tc
	q RtnObj
}

/// 获取普通循环包标签,PkgCode 为cssd_package 中的代码
/// w ##Class(web.CSSDHUI.Pack.CleanPackLabel).GetOrdLabels(1,7)
ClassMethod GetOrdLabels(PkgCode As %String, Num As %String) As %String
{
	n (PkgCode,Num)
	s PkgCode =$tr($j(PkgCode,4)," ","0")
	s date=$zd(+$h,8)
	s pre=PkgCode_date
	s maxNo=""
	&sql(Select Max(CSSDPP_Label) into :maxNo From CSSD_PackagePack
		WHERE CSSDPP_Label %STARTSWITH :pre)
	s cur= +$e(maxNo,$l(maxNo)-4,$l(maxNo))	;取后五位
	s Labels=""
	f i=1:1:Num d
	.s cur=cur+1
	.s Label= pre_$tr($j(cur,5)," ","0")
	.i Labels="" d
	..s Labels=Label
	.e  d
	..s Labels=Labels_"^"_Label
	q Labels
}

/// 根据回收明细Id取科室生成标签的时候插入
/// w ##Class(web.CSSDHUI.Pack.CleanPackLabel).GetLocID("001001003")
ClassMethod GetLocID(CBItmId As %String) As %String
{
	n (CBItmId)
	s LocID=""
	s CBItmObj=##class(User.CSSDCallbackDetailNew).%OpenId(CBItmId)
	i CBItmObj'="" d
	.i $IsObject(CBItmObj.CSSDCDParref) d
	..s CBObj=CBItmObj.CSSDCDParref.%Id()
	..s LocID=$lg(^User.CSSDPackageCallbackD(CBObj),3)
	q LocID
}

/// 根据 清洗明细表的detailId
/// 查询普通循环包 配包人，审核人信息
/// d ##class(%ResultSet).RunQuery("web.CSSDHUI.Pack.CleanPackLabel","GetOrdPackInfo","151")
Query GetOrdPackInfo(detailIds As %String) As web.CSSDHUI.Query(ROWSPEC = "CleanItmId:%Integer,Label,PkgDesc,PackId,ExpDate,PackUserId,PackUserName,PackChkUserId,PackChkUserName,PackerId,PackerName,IsPrint,MaterialId,MaterialDesc,Remark,SterItmId,HeatNo,MachineDesc,SterUserId,SterUserName,IsExt,IsLowerSter,IsSter,Status") [ SqlProc ]
{
}

ClassMethod GetOrdPackInfoExecute(ByRef qHandle As %Binary, detailIds As %String) As %Status
{
	n (qHandle,detailIds)
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
	q:detailIds="" $$$OK

	s lenth=$l(detailIds,"^")
	f i=1:1:lenth d
	.s CleanItmId=$p(detailIds,"^",i)
	.s CleanItmObj=""
	.s CleanItmObj=##Class(User.CSSDCleanDetailPacks).%OpenId(CleanItmId)
	.s CleanObj=CleanItmObj.CSSDCDPCleanMain
	.s CodeDict=CleanItmObj.CSSDCDPLabel  ;固定标签
	.s CleanId=CleanObj.%Id()
	.s PkgId=CleanItmObj.CSSDPRPackage.%Id()
	.s IsExt=##class(web.CSSDHUI.Common.PackageInfoCommon).GetExtFlag(PkgId)
	.s PkgDesc=CleanItmObj.CSSDPRPackage.CSSDPDesc
	.s SterTypeObj=CleanItmObj.CSSDPRPackage.CSSDPSterType
	.s (IsLowerSter,IsSter)=""
	.i $IsObject(SterTypeObj) d
	..s IsLowerSter=SterTypeObj.CSSDSTIsLowerTemp
	..s IsSter=SterTypeObj.CSSDSTIsSter
	.s PackId=""
	.f  s PackId=$o(^User.CSSDPackagePackI("CSSDPPCleanDrPackageDrIndex",CleanId,CleanItmId,PkgId,PackId)) q:PackId=""  d
	..s PackObj=""
	..s PackObj=##Class(User.CSSDPackagePack).%OpenId(PackId)
	..s Label=PackObj.CSSDPPLabel
	..s PrintNum=PackObj.CSSDPPPrtTimes
	..s IsPrint="N"
	..s:PrintNum>0 IsPrint="Y"
	..s TransId=$o(^User.CSSDTransI("CSSDTLabel",Label,""))
	..s PackTrans=""
	..s PackTrans=##Class(User.CSSDTrans).%OpenId(TransId)
	..s ExpDate=PackTrans.CSSDTExpDate
	..s ExpDate=..DL2H(ExpDate)
	..;包装人
	..s PackUser=PackObj.CSSDPPUserDr
	..s PackUserId=PackUser.%Id()
	..s PackUserName=PackUser.SSUSRName
	..;审核人
	..s PackChkUser=PackObj.CSSDPPAckUserDr
	..s PackChkUserId=PackChkUser.%Id()
	..s PackChkUserName=PackChkUser.SSUSRName
	..;配包人
	..s Packer=PackObj.CSSDPPPackUserDr
	..s (PackerId,PackerName)=""
	..i $IsObject(Packer) d
	...s PackerId=Packer.%Id()
	...s PackerName=Packer.SSUSRName
	..;灭菌人
	..s SterUserObj=PackObj.CSSDPPSterUserDr
	..s (SterUserId,SterUserName)=""
	..i $IsObject(SterUserObj) d
	...s SterUserId=SterUserObj.%Id()
	...s SterUserName=SterUserObj.SSUSRName
	..;包装材料
	..s MaterialObj=PackObj.CSSDPPMaterialDr
	..s (MaterialId,MaterialDesc)=""
	..i $IsObject(MaterialObj) d
	...s MaterialId=MaterialObj.%Id()
	...s MaterialDesc=MaterialObj.CSSDMDesc
	..s Remark=PackObj.CSSDPPRemark
	..s HeatNo=PackObj.CSSDPPHeatNo
	..s MachineDesc=PackObj.CSSDPPMachineDR.CSSDMCAlias
	..s SterItmId=$o(^User.CSSDPackageSterilizeI("IndexCSSDPSLabel",Label,""))
	..s Status=""
	..s:TransId'="" Status=$lg(^User.CSSDTransD(TransId),8)
	..d OutputRowDetail
	q $$$OK
OutputRowDetail
	s Data=$lb(CleanItmId,Label,PkgDesc,PackId,ExpDate,PackUserId,PackUserName,PackChkUserId,
		PackChkUserName,PackerId,PackerName,IsPrint,MaterialId,MaterialDesc,Remark,SterItmId,
		HeatNo,MachineDesc,SterUserId,SterUserName,IsExt,IsLowerSter,IsSter,Status)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// 根据固定标签查询当前日期的清洗主表id和清洗明细id组成的
/// w ##Class(web.CSSDHUI.Pack.CleanPackLabel).GetCleanInfoByCodeDict("2212")
ClassMethod GetCleanInfoByCodeDict(CodeDict As %String)
{
	n (CodeDict)
	s CleanItmId="",CleanId="",CodeDictId=""
	&sql(SELECT ID into:CodeDictId FROM CSSD_CodeDict WHERE CSSDCD_Code=:CodeDict)
	q:CodeDictId="" ""
	&sql(SELECT ID,CSSDCDP_CleanMainDR into:CleanItmId,:CleanId FROM CSSD_CleanDetailPacks
		WHERE CSSDCDP_Label=:CodeDict AND CSSDCDP_CleanMainDR->cssdc_chkerdr is not null order by ID desc )
	q CleanId_"^"_CleanItmId
}

/// 消毒包label拼Json串
/// w ##class(web.CSSDHUI.Pack.CleanPackLabel).GetPackageLabels("119")
ClassMethod GetPackageLabels(details As %String) As %String
{
	n (details)
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr="SELECT CSSDT_Rowid,CSSDT_Label,CSSDT_Package_DR,CSSDT_Clean_DR FROM CSSD_Trans WHERE CSSDT_Clean_DR IN ("_details_")"
	d result.RuntimeModeSet(0)
	d result.Prepare(sqlStr)
	d result.Execute()

	s ResultStr=""
	While(result.Next())
	{
		s RowId=result.Data("CSSDT_Rowid")
		s Label=result.Data("CSSDT_Label")
		s PkgId=result.Data("CSSDT_Package_DR")
		s (IsLowerSter,IsSter,ComposeFlag,IsExt)=""
		i PkgId'="" d
		.s PkgObj = ##class(User.CSSDPackage).%OpenId(PkgId)
		.continue:'$IsObject(PkgObj)
		.s SterTypeObj = PkgObj.CSSDPSterType
		.continue:'$IsObject(SterTypeObj)
		.s IsExt=##class(web.CSSDHUI.Common.PackageInfoCommon).GetExtFlag(PkgId)
		.
		.s IsLowerSter=SterTypeObj.CSSDSTIsLowerTemp
		.s IsSter=SterTypeObj.CSSDSTIsSter
		s CleanItmId=result.Data("CSSDT_Clean_DR")
		i CleanItmId'="" d
		.s CleanItmObj = ##class(User.CSSDCleanDetailPacks).%OpenId(CleanItmId)
		.s ComposeFlag= CleanItmObj.CSSDCDPComposeFlag
		s:(ResultStr'="") ResultStr=ResultStr_","
		s ResultStr=ResultStr_"{"
		s ResultStr=ResultStr_"""id"":"""_""_RowId_""",""label"":"""_Label_""",""IsLowerSter"":"""_IsLowerSter_""",""ComposeFlag"":"""_ComposeFlag_""",""IsSter"":"""_IsSter_""",""IsExt"":"""_IsExt_""""
		s ResultStr=ResultStr_"}"
	}
	s ResultStr="["_ResultStr_"]"
	d result.Close()
	q ResultStr
}

/// CreatDate:2022.4.24
/// Description:删除标签
/// Input:Params
/// Return:RtnObj
/// w ##Class(web.CSSDHUI.Pack.CleanPackLabel).jsDelete(^templxt("jsDelete"))
ClassMethod jsDelete(Params) As %String
{
	n (Params)
	s $ZT=..sssError()
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	ts
	s PJObj=##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	q:Sc'=0 RtnObj.Err(-1,"","入参解析失败!").Json()

	while(RtnObj.success=0){
		s Obj=PJObj.%Pop()
		q:Obj=""

		s RowId=Obj.%Get("RowId")
		s Label=Obj.%Get("Label")
		s CleanItmId=Obj.%Get("CleanItmId")
		s CodeDict=Obj.%Get("CodeDict")
		continue:((RowId="")&&(Label=""))

		i Label="" d
		.s PackObj=##class(User.CSSDPackagePack).%OpenId(RowId)
		.q:'$IsObject(PackObj)
		.s Label=PackObj.CSSDPPLabel
		continue:Label=""

		i CleanItmId="" d
		.s CleanItmId=PackObj.CSSDPPCleanDetailDR
		.s CleanItmObj=##class(User.CSSDCleanDetailPacks).%OpenId(CleanItmId)
		.i $IsObject(CleanItmObj) d
		..s CodeDict=CleanItmObj.CSSDCDPLabel
		continue:CleanItmId=""

		s RtnObj=..Delete(Label,CleanItmId,CodeDict)
		continue:RtnObj.success'=0
	}

	i RtnObj.success<0 tro  q RtnObj.Json()
	tc
	q RtnObj.Json()
}

/// Description:删除标签
ClassMethod Delete(Label, CleanItmId, CodeDict = "") As web.CSSDHUI.RtnObj
{
	n (Label,CleanItmId,CodeDict)
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()

	s SterItmId=$o(^User.CSSDPackageSterilizeI("IndexCSSDPSLabel",Label,""))
	q:SterItmId'="" RtnObj.Err("-2","",Label_"该标签已灭菌,不允许删除")

	&sql(delete from CSSD_PackagePack where CSSDPP_Label=:Label)					;删除打包主表
	q:SQLCODE'=0 RtnObj.Err(-2,"","删除CSSD_PackagePack失败!")

	&sql(delete from CSSD_Trans where CSSDT_Label=:Label)							;删除消毒包追踪表
	q:SQLCODE'=0 RtnObj.Err(-3,"","删除CSSD_Trans失败!")

	&sql(UPDATE CSSD_CleanDetailPacks SET CSSDCDP_CreatedQty=CSSDCDP_CreatedQty-1,CSSDCDP_IsCrtLbl=0 WHERE %id=:CleanItmId)
	q:SQLCODE'=0 RtnObj.Err(-4,"","更新CSSD_CleanDetailPacks失败!")				;更新清洗子表生成数量

	s CleanItmObj = ##class(User.CSSDCleanDetailPacks).%OpenId(CleanItmId)
	s CleanId=CleanItmObj.CSSDCDPCleanMain.%Id()
	s CBItmId=CleanItmObj.CSSDCDPCallBackDetailDrGetObjectId()
	&sql(update CSSD_Clean set cssdc_iscreatelbl=0 where id=:CleanId)
	q:SQLCODE'=0 RtnObj.Err(-5,"","更新CSSD_Clean失败!")

	s Cycle=0,CreateQty=0
	&sql(select CSSDCDP_CreatedQty into :CreateQty from CSSD_CleanDetailPacks WHERE %id=:CleanItmId )
	i ((CodeDict'="")&&(+CreateQty=0)) d
	.s CodeDictId=$o(^User.CSSDCodeDictI("CSSDCDCodeIndex",CodeDict,""))
	.&sql(UPDATE CSSD_CodeDict SET CSSDCD_TableRowID=NULL,CSSDCD_CycleCount=CSSDCD_CycleCount-1 WHERE ID=:CodeDictId)
	.i SQLCODE'=0 d RtnObj.Err(-3,"","更新CSSD_CodeDict失败!")						;标牌追溯包更新标牌编码表循环次数及跟踪表id置空
	q:RtnObj.success'=0 RtnObj

	s PkgId=CleanItmObj.CSSDPRPackageGetObjectId()
	s PkgClassId=CleanItmObj.CSSDPRPackage.CSSDPPackClassGetObjectId()
	s IsExt=##Class(web.CSSDHUI.Common.PackageInfoCommon).GetExtFlag(PkgId)
	i IsExt="Y" d
	.s ExtDr = CleanItmObj.CSSDCDPExtDRGetObjectId()
	.s labelNo=$E(Label,$l(Label)-1,$l(Label))
	.s ExtDetailDr=$o(^User.CSSDExtDevBindDetailI("CSSDParrefDrPkgNumIndex",ExtDr,labelNo,""))
	.i ExtDetailDr'="" d
	..&sql(UPDATE CSSD_ExtDevBindDetail SET CSSDEBD_Label ='' WHERE CSSDEBD_Parref_DR=:ExtDr and CSSDEBD_PkgNum=:labelNo)
	..i SQLCODE'=0 d RtnObj.Err(-3,"","更新外来器械明细数据失败")
	.q:RtnObj.success'=0
	.
	.i CreateQty=0 d
	..i CBItmId="" s ExtStatus="W"
	..e  s ExtStatus="SW"
	..&sql(Update CSSD_ExtDevBind set CSSDExt_Label='',CSSDExt_Status=:ExtStatus where CSSDExt_Rowid=:ExtDr)
	..i SQLCODE'=0 d RtnObj.Err(-3,"","更新外来器械明细数据失败")
	q:RtnObj.success'=0 RtnObj

	q RtnObj
}

/// Description:已清洗消毒包信息汇总
/// Creator:lxt
/// CreatDate:20220705
/// Table:CSSD_Clean
/// Input:Params
/// Output:
/// Return:清洗信息
/// others:d ##class(%ResultSet).RunQuery("web.CSSDHUI.Pack.CleanPackLabel","SelectColCheck",^templxt("col"))
Query SelectColCheck(Params As %String) As web.CSSDHUI.Query(ROWSPEC = "PkgNum,PkgId,PkgDesc,ToLocId,ToLocDesc,CleanQty,CreateQty,PrintCount,UnCreateQty,PkgClassId,PkgClassDesc,AttributeCode,AttributeDesc,CodeDict,IsAllCrLbl,IsLowerSter,IsSter,IsExt,CleanItmStr") [ SqlProc ]
{
}

ClassMethod SelectColCheckExecute(ByRef qHandle As %Binary, Params As %String) As %Status
{
	n (qHandle,Params)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)

	s PJObj = ##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	q:Sc'=0 $$$OK

	s PCleanLocId = PJObj.%Get("CleanLoc")
	s PToLocId = PJObj.%Get("ToLoc")
	s PStartDate = PJObj.%Get("StartDate")
	s StartDate=..DH2L(PStartDate)
	s PEndDate=PJObj.%Get("EndDate")
	s EndDate=..DH2L(PEndDate)
	s PAttributeCode=PJObj.%Get("AttributeCode")
	s PPkgClassId=PJObj.%Get("PkgClass")
	s PPkgId=PJObj.%Get("Pkg")
	s PCodeDict=PJObj.%Get("CodeDict")
	s PCompFlag=PJObj.%Get("CompFlag")
	q:((StartDate="")||(EndDate="")) $$$OK

	f Date=StartDate:1:EndDate d
	.s CleanId=0
	.f  s CleanId=$o(^User.CSSDCleanI("IndexCSSDCDate",Date,CleanId)) q:CleanId=""  d
	../// 清洗主单信息
	..s CleanObj=##class(User.CSSDClean).%OpenId(CleanId)
	..q:'$IsObject(CleanObj)
	..s CleanLocId=CleanObj.CSSDCLocDrGetObjectId()
	..s CleanResult=CleanObj.CSSDCResult
	..q:CleanResult'=1 /// 验收不合格
	..q:((PCleanLocId'="")&&(CleanLocId'="")&&(PCleanLocId'=CleanLocId))
	..
	..s CleanItmId=0
	..f  s CleanItmId=$o(^User.CSSDCleanDetailPacksI("IndexMainDr",CleanId,CleanItmId)) q:CleanItmId=""  d
	...//清洗明细信息
	...s CleanItmObj=##Class(User.CSSDCleanDetailPacks).%OpenId(CleanItmId)
	...q:'$IsObject(CleanItmObj)
	...s States=CleanItmObj.CSSDCDPStates
	...q:States="N"
	...
	...s PkgId=CleanItmObj.CSSDPRPackageGetObjectId()
	...s PkgClassId=CleanItmObj.CSSDPRPackage.CSSDPPackClassGetObjectId()
	...s AttributeCode=CleanItmObj.CSSDPRPackage.CSSDPPackTypeDetail
	...s CodeDict=CleanItmObj.CSSDCDPLabel
	...s LevelFlag=CleanItmObj.CSSDCDPLevelFlag
	...s IsCrtLbl=CleanItmObj.CSSDCDPIsCrtLbl
	...s CleanQty=CleanItmObj.CSSDCDPQty
	...s PackFlag=CleanItmObj.CSSDCDPPackFlag
	...s Flag=CleanItmObj.CSSDCDPFlag
	...s ExtObj=CleanItmObj.CSSDCDPExtDR
	...s ToLocId=..GetToLocByCleanD(CleanItmId)
	...s IsExt=##Class(web.CSSDHUI.Common.PackageInfoCommon).GetExtFlag(PkgId)
	...s TransFlag="N"
	...i (IsExt="Y")&&($IsObject(ExtObj)) d
	....s TransFlag=ExtObj.CSSDExtIsTransfer
	...q:TransFlag="Y"
	...q:Flag="SS"	//过滤二次消毒
	...q:((AttributeCode'=1)&&(AttributeCode'=2)&&(AttributeCode'=10))
	...q:((PPkgClassId'="")&&(PPkgClassId'=PkgClassId))
	...q:((PAttributeCode'="")&&(PAttributeCode'=AttributeCode))
	...q:((PCodeDict'="")&&(CodeDict'=PCodeDict))
	...q:((PPkgId'="")&&(PPkgId'=PkgId))
	...q:((PToLocId'="")&&(PToLocId'=ToLocId))
	...
	...s:ToLocId="" ToLocId="无"
	...s TmpNum=$o(ColPackInfo("AllCheckPkg",PkgId,ToLocId,""),-1)
	...i (((AttributeCode'=2)&&(AttributeCode'=10))||(TmpNum="")) s TmpNum=+TmpNum+1	//普通循环包专科器械包数量合并
	...s PackageStr=PkgClassId_","_AttributeCode_","_ToLocId_","_CodeDict_","_IsExt
	...s $p(ColPackInfo("AllCheckPkg",PkgId,ToLocId,TmpNum),"^",1)=PackageStr
	...s CleanItmStr=$p(ColPackInfo("AllCheckPkg",PkgId,ToLocId,TmpNum),"^",3)
	...i CleanItmStr'="" s CleanItmStr=CleanItmStr_","_CleanItmId
	...e  s CleanItmStr=CleanItmId
	...s $p(ColPackInfo("AllCheckPkg",PkgId,ToLocId,TmpNum),"^",3)=CleanItmStr
	...
	...s (PrintCount,CreateQty,PackId)=0
	...f  s PackId=$o(^User.CSSDPackagePackI("CSSDPPCleanDrPackageDrIndex",CleanId,CleanItmId,PkgId,PackId)) q:PackId=""  d
	....//标签生成信息
	....s PackObj=##class(User.CSSDPackagePack).%OpenId(PackId)
	....q:'$IsObject(PackObj)
	....s PrtTime=PackObj.CSSDPPPrtTimes
	....s CreateQty=CreateQty+1
	....s:(+PrtTime>0) PrintCount=PrintCount+1
	...
	...//组织主数据Qty
	...s (TotalCleanQty,TotoalCreateQty,TotoalPrintCount)=0
	...s QtyStr=$p(ColPackInfo("AllCheckPkg",PkgId,ToLocId,TmpNum),"^",2)
	...i QtyStr="" d
	....s TotalCleanQty=CleanQty
	....s TotoalCreateQty=CreateQty
	....s TotoalPrintCount=PrintCount
	...e  d
	....s TotalCleanQty=+$p(QtyStr,",",1)+CleanQty
	....s TotoalCreateQty=+$p(QtyStr,",",2)+CreateQty
	....s TotoalPrintCount=+$p(QtyStr,",",3)+PrintCount
	...s QtyStr=TotalCleanQty_","_TotoalCreateQty_","_TotoalPrintCount
	...s $p(ColPackInfo("AllCheckPkg",PkgId,ToLocId,TmpNum),"^",2)=QtyStr
	q:'$d(ColPackInfo("AllCheckPkg")) $$$OK
	
	s PkgId=0
	f  s PkgId=$o(ColPackInfo("AllCheckPkg",PkgId)) q:PkgId=""  d
	.s PkgObj=##class(User.CSSDPackage).%OpenId(PkgId)
	.d PkgObj.%Reload()
	.s PkgDesc=PkgObj.CSSDPDesc
	.s SterTypeObj = PkgObj.CSSDPSterType
	.s (IsLowerSter,IsSter)=""
	.i $IsObject(SterTypeObj) d
	..s IsLowerSter=SterTypeObj.CSSDSTIsLowerTemp
	..s IsSter=SterTypeObj.CSSDSTIsSter
	.s ToLocId=0
	.f  s ToLocId=$o(ColPackInfo("AllCheckPkg",PkgId,ToLocId)) q:ToLocId=""  d
	..s ToLocDesc=""
	..i ToLocId="无" s ToLocDesc=""
	..e  s ToLocDesc=..sssLocDesc(ToLocId)
	..s PkgNum=0
	..f  s PkgNum=$o(ColPackInfo("AllCheckPkg",PkgId,ToLocId,PkgNum)) q:PkgNum=""  d
	...s PkgStr=$p(ColPackInfo("AllCheckPkg",PkgId,ToLocId,PkgNum),"^",1)
	...s QtyStr=$p(ColPackInfo("AllCheckPkg",PkgId,ToLocId,PkgNum),"^",2)
	...s CleanItmStr=$p(ColPackInfo("AllCheckPkg",PkgId,ToLocId,PkgNum),"^",3)
	...s PkgClassId=$p(PkgStr,",",1)
	...s AttributeCode=$p(PkgStr,",",2)
	...s CodeDict=$p(PkgStr,",",4)
	...s IsExt=$p(PkgStr,",",5)
	...
	...s CleanQty=$p(QtyStr,",",1)
	...s CreateQty=$p(QtyStr,",",2)
	...s PrintCount=$p(QtyStr,",",3)
	...s IsAllCrLbl="N"
	...i CleanQty=CreateQty s IsAllCrLbl="Y"
	...q:(PCompFlag'="")&&(PCompFlag'=IsAllCrLbl)
	...s (PkgClassDesc,AttributeDesc)=""
	...s:PkgClassId'="" PkgClassDesc=$lg(^User.CSSDPackageClassD(PkgClassId),2)
	...s:AttributeCode'="" AttributeDesc=##class(web.CSSDHUI.Common.PackageInfoCommon).GetPackageDetailDesc(AttributeCode)
	...s UnCreateQty=CleanQty-CreateQty
	...d OutPutRowCol

	q $$$OK

OutPutRowCol
	s Data=$lb(PkgNum,PkgId,PkgDesc,ToLocId,ToLocDesc,CleanQty,CreateQty,
		PrintCount,UnCreateQty,PkgClassId,PkgClassDesc,AttributeCode,AttributeDesc,
		CodeDict,IsAllCrLbl,IsLowerSter,IsSter,IsExt,CleanItmStr)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// Description:按汇总展示标签信息
/// Creator:lxt
/// CreatDate:20220705
/// Table:CSSD_PackagePack
/// Input:Params
/// Output:
/// Return:标签信息
/// others:d ##class(%ResultSet).RunQuery("web.CSSDHUI.Pack.CleanPackLabel","SelectColPackItm",^templxt("SelectColPackItm"))
Query SelectColPackItm(Params As %String) As web.CSSDHUI.Query(ROWSPEC = "RowId:%Integer,Label,CleanItmId,PackLocId,PackLocDesc,PackUserId,PackUserName,PackChkUserId,PackChkUserName,PackerId,PackerName,Remark,MaterialId,MaterialDesc,IsPrint,LevelFlag,SterUserName") [ SqlProc ]
{
}

ClassMethod SelectColPackItmExecute(ByRef qHandle As %Binary, Params As %String) As %Status
{
	n (qHandle,Params)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)

	s PJObj = ##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 q $$$OK

	s PPkgId=PJObj.%Get("PkgId")
	s PPkgNum=PJObj.%Get("PkgNum")
	s PToLocId=PJObj.%Get("ToLocId")
	s PCleanItmStr=PJObj.%Get("CleanItmStr")
	q:((PPkgId="")||(PPkgNum="")||(PToLocId="")||(PCleanItmStr="")) $$$OK


	s len=$l(PCleanItmStr,",")
	for i=1:1:len d
	.s CleanItmId=$p(PCleanItmStr,",",i)
	.s CleanItmObj=##Class(User.CSSDCleanDetailPacks).%OpenId(CleanItmId)
	.q:'$IsObject(CleanItmObj)
	.s States=CleanItmObj.CSSDCDPStates
	.q:States="N"
	.
	.s CleanId=CleanItmObj.CSSDCDPCleanMainGetObjectId()
	.s PkgId=CleanItmObj.CSSDPRPackageGetObjectId()
	.s PkgClassId=CleanItmObj.CSSDPRPackage.CSSDPPackClassGetObjectId()
	.s AttributeCode=CleanItmObj.CSSDPRPackage.CSSDPPackTypeDetail
	.s CodeDict=CleanItmObj.CSSDCDPLabel
	.s LevelFlag=CleanItmObj.CSSDCDPLevelFlag
	.s IsCrtLbl=CleanItmObj.CSSDCDPIsCrtLbl
	.s CleanQty=CleanItmObj.CSSDCDPQty
	.s ToLocId=..GetToLocByCleanD(CleanItmId)
	.s IsExt=##Class(web.CSSDHUI.Common.PackageInfoCommon).GetExtFlag(PkgId)
	.
	.s:ToLocId="" ToLocId="无"
	.s TmpNum=$o(ColPackInfo("AllCheckPkg",PkgId,ToLocId,""),-1)
	.i (((AttributeCode'=2)&&(AttributeCode'=10))||(TmpNum="")) s TmpNum=+TmpNum+1	//普通循环包专科器械包数量合并
	.s ColPackInfo("AllCheckPkg",PkgId,ToLocId,TmpNum)=""
	.
	.s (CreateQty,PackId)=0
	.f  s PackId=$o(^User.CSSDPackagePackI("CSSDPPCleanDrPackageDrIndex",CleanId,CleanItmId,PkgId,PackId)) q:PackId=""  d
	..//标签生成信息
	..s PackObj=##class(User.CSSDPackagePack).%OpenId(PackId)
	..q:'$IsObject(PackObj)
	..s Label=PackObj.CSSDPPLabel
	..s PrtTime=PackObj.CSSDPPPrtTimes
	..s CreateQty=CreateQty+1
	..s IsPrint="N"
	..s:(+PrtTime>0) IsPrint="Y"
	..//组织明细信息（生成标签）
	..s ColPackInfo("AllCheckPkg",PkgId,ToLocId,TmpNum,"Y",PackId)=Label_"^"_IsPrint_"^"_CleanItmId_"^"_ToLocId_"^"_LevelFlag_"^"_CodeDict_"^"_IsExt
	.//组织明细信息（未生成标签）
	.i CleanQty>CreateQty d
	..s ColPackInfo("AllCheckPkg",PkgId,ToLocId,TmpNum,"N",CleanItmId)="^^"_CleanItmId_"^"_ToLocId_"^"_LevelFlag_"^"_CodeDict_"^"_IsExt

	s RowId=0
	f  s RowId=$o(ColPackInfo("AllCheckPkg",PPkgId,PToLocId,PPkgNum,"Y",RowId)) q:RowId=""  d
	.s Info=ColPackInfo("AllCheckPkg",PPkgId,PToLocId,PPkgNum,"Y",RowId)
	.s Label=$p(Info,"^",1)
	.s IsPrint=$p(Info,"^",2)
	.s CleanItmId=$p(Info,"^",3)
	.s LevelFlag=$p(Info,"^",5)
	.s CodeDict=$p(Info,"^",6)
	.s IsExt=$p(Info,"^",7)
	.s PackObj=##class(User.CSSDPackagePack).%OpenId(RowId)
	.q:'$IsObject(PackObj)
	.s PackUserId=PackObj.CSSDPPUserDrGetObjectId()
	.s PackChkUserId=PackObj.CSSDPPAckUserDrGetObjectId()
	.s PackerId=PackObj.CSSDPPPackUserDrGetObjectId()
	.s MaterialObj=PackObj.CSSDPPMaterialDr
	.s PackLocId=PackObj.CSSDPPPackLocDrGetObjectId()
	.s Remark=PackObj.CSSDPPRemark
	.s SterUserId=PackObj.CSSDPPSterUserDrGetObjectId()
	.s (ToLocDesc,PackUserName,PackChkUserName,PackerName,MaterialId,MaterialDesc,SterUserName)=""
	.s:PackLocId'="" PackLocDesc=..sssLocDesc(PackLocId)
	.s PackUserName=..sssUserName(PackUserId)
	.s PackChkUserName=..sssUserName(PackChkUserId)
	.s PackerName=..sssUserName(PackerId)
	.s SterUserName=..sssUserName(SterUserId)
	.i $IsObject(MaterialObj) d
	..s MaterialId=MaterialObj.%Id()
	..s MaterialDesc=MaterialObj.CSSDMDesc
	.d OutPutRowColPackItm

	q $$$OK
OutPutRowColPackItm
	s Data=$lb(RowId,Label,CleanItmId,PackLocId,PackLocDesc,PackUserId,PackUserName,PackChkUserId,PackChkUserName,
		PackerId,PackerName,Remark,MaterialId,MaterialDesc,IsPrint,LevelFlag,SterUserName)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// Description:按汇总信息生成条码
/// Creator:lxt
/// CreatDate:20220705
/// Table:CSSD_PackagePack
/// Input:Params
/// Output:
/// Return:标签信息
/// Others：w ##Class(web.CSSDHUI.Pack.CleanPackLabel).jsCreateColPack(^templxt("col",1),^templxt("col",2))
ClassMethod jsCreateColPack(Main, Detail) As %String
{
	n (Main,Detail)
	s $ZT=..sssError()
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	ts
	s RtnObj=..CreateColPack(Main,Detail)
	i RtnObj.success<0 tro  q RtnObj.Json()
	tc
	q RtnObj.Json()
}

/// Others：w ##Class(web.CSSDHUI.Pack.CleanPackLabel).CreateColPack(^tempyj("Main"),^tempyj("Detail"))
ClassMethod CreateColPack(Main, Detail) As web.CSSDHUI.RtnObj
{
	n (Main,Detail)
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	i ((Main="")||(Detail="")) q RtnObj.Err(-1,"","入参不能为空!")

	s MPJObj=##class(web.CSSDHUI.Common.FromJson).%New()
	s MSc=MPJObj.%FromJSON(Main)
	i MSc'=0 q RtnObj.Err(-1,"","入参解析失败!","",0)

	s DPJObj=##class(web.CSSDHUI.Common.FromJson).%New()
	s DSc=DPJObj.%FromJSON(Detail)
	i DSc'=0 q ScDetail=RtnObj.Err(-1,"","入参解析失败!","",0)

	s gLocId=MPJObj.%Get("gLocId")
	s gUserId=MPJObj.%Get("gUserId")
	s gGroupId=MPJObj.%Get("gGroupId")
	s gHospId=MPJObj.%Get("gHospId")

	s PPackUserChkId=MPJObj.%Get("PackChkUser")
	s PPackUserId=MPJObj.%Get("PackUser")
	s PPackerUserId=MPJObj.%Get("Packer")
	s PSterDate=MPJObj.%Get("SterDate")
	s SterDate=..DH2L(PSterDate)
	s PMaterialId=MPJObj.%Get("MaterialId")
	s PPackLocId=MPJObj.%Get("PackLoc")
	s PSterMachineId=MPJObj.%Get("SterMachine")
	s PHeatNo=MPJObj.%Get("HeatNo")
	s PPackNum=MPJObj.%Get("PackNum")
	s PLabelQty=+MPJObj.%Get("LabelQty")
	s PCleanItmStr=MPJObj.%Get("CleanItmStr")
	s PSterUserId=MPJObj.%Get("SterUser")
	s PackDate=+$h
	s PackTime=$p($h,",",2)
	i SterDate'="" d
	.s PackDate=SterDate
	.s PackTime=0

	i PPackUserChkId="" d RtnObj.Err(-1,"","审核人为空","",0)
	q:RtnObj.success'=0 RtnObj
	i PPackUserId="" d RtnObj.Err(-1,"","包装人为空","",0)
	q:RtnObj.success'=0 RtnObj

	s Param=gGroupId_"^"_gLocId_"^"_gUserId_"^"_gHospId
	s AppName=..%GetParameter("AppName")
	s IsExpDateInCurDay=##class(web.CSSDHUI.Common.AppCommon).GetParamValue(AppName,"IsExpDateInCurDay",Param)
	s isPackUserValue=##class(web.CSSDHUI.Common.AppCommon).GetParamValue(AppName,"IsPackUser",Param)
	i (isPackUserValue="Y" && PPackerUserId="") d RtnObj.Err(-1,"","配包人为空","",0)
	q:RtnObj.success'=0 RtnObj

	s Ret=..sssLock(AppName)
	i Ret'=0 q RtnObj.Err(-99,"","加锁失败")
	
	/// 汇总标签信息
	s len=$l(PCleanItmStr,",")
	for i=1:1:len d
	.s CleanItmId=$p(PCleanItmStr,",",i)
	.s CleanItmObj=##Class(User.CSSDCleanDetailPacks).%OpenId(CleanItmId)
	.q:'$IsObject(CleanItmObj)
	.s States=CleanItmObj.CSSDCDPStates
	.q:States="N"
	.
	.s CleanId=CleanItmObj.CSSDCDPCleanMainGetObjectId()
	.s PkgId=CleanItmObj.CSSDPRPackageGetObjectId()
	.s PkgClassId=CleanItmObj.CSSDPRPackage.CSSDPPackClassGetObjectId()
	.s AttributeCode=CleanItmObj.CSSDPRPackage.CSSDPPackTypeDetail
	.s CodeDict=CleanItmObj.CSSDCDPLabel
	.s LevelFlag=CleanItmObj.CSSDCDPLevelFlag
	.s IsCrtLbl=CleanItmObj.CSSDCDPIsCrtLbl
	.s CleanQty=CleanItmObj.CSSDCDPQty
	.s ToLocId=..GetToLocByCleanD(CleanItmId)
	.s IsExt=##Class(web.CSSDHUI.Common.PackageInfoCommon).GetExtFlag(PkgId)
	.
	.s:ToLocId="" ToLocId="无"
	.s TmpNum=$o(ColPackInfo("AllCheckPkg",PkgId,ToLocId,""),-1)
	.i (((AttributeCode'=2)&&(AttributeCode'=10))||(TmpNum="")) s TmpNum=+TmpNum+1	//普通循环包专科器械包数量合并
	.s ColPackInfo("AllCheckPkg",PkgId,ToLocId,TmpNum)=""
	.s PrintCount=0,CreateQty=0
	.
	.s PackId=0
	.f  s PackId=$o(^User.CSSDPackagePackI("CSSDPPCleanDrPackageDrIndex",CleanId,CleanItmId,PkgId,PackId)) q:PackId=""  d
	..//标签生成信息
	..s PackObj=##class(User.CSSDPackagePack).%OpenId(PackId)
	..q:'$IsObject(PackObj)
	..s Label=PackObj.CSSDPPLabel
	..s PrtTime=PackObj.CSSDPPPrtTimes
	..s CreateQty=CreateQty+1
	..s IsPrint="N"
	..s:(+PrtTime>0) IsPrint="Y",PrintCount=PrintCount+1
	..//组织明细信息（生成标签）
	..s ColPackInfo("AllCheckPkg",PkgId,ToLocId,TmpNum,"Y",PackId)=Label_"^"_IsPrint_"^"_CleanItmId_"^"_ToLocId_"^"_LevelFlag_"^"_CodeDict_"^"_IsExt
	.//组织明细信息（未生成标签）
	.i CleanQty>CreateQty d
	..s ColPackInfo("AllCheckPkg",PkgId,ToLocId,TmpNum,"N",CleanItmId)="^^"_CleanItmId_"^"_ToLocId_"^"_LevelFlag_"^"_CodeDict_"^"_IsExt
	
	while(RtnObj.success=0){
		s Obj=DPJObj.%Pop()
		q:Obj=""

		s PkgNum=Obj.%Get("PkgNum")
		s PkgId=Obj.%Get("PkgId")
		s ToLocId=Obj.%Get("ToLocId")
		s CodeDict=Obj.%Get("CodeDict")
		s LastQty=Obj.%Get("UnCreateQty")	//可生成数量

		i LastQty=0 d RtnObj.Err(-4,"","标签生成完成","",0)
		continue:RtnObj.success'=0

		s:((PLabelQty>0)&&(LastQty>PLabelQty)) LastQty=PLabelQty
		s PkgObj=##class(User.CSSDPackage).%OpenId(PkgId)
		continue:'$IsObject(PkgObj)

		s AttributeCode=PkgObj.CSSDPPackTypeDetail
		s PkgCode=PkgObj.CSSDPCode
		s WorkTimes=PkgObj.CSSDPWorkTimes
		s CodeDictId=""
		i CodeDict'="" d
		.s CodeDictId =$o(^User.CSSDCodeDictI("CSSDCDCodeIndex",CodeDict,""))
		.i CodeDictId="" d RtnObj.Err(-4,"","标牌信息不存在！","",0) q
		.s CodeDictObj=##Class(User.CSSDCodeDict).%OpenId(CodeDictId)
		.i '$IsObject(CodeDictObj) d RtnObj.Err(-5,"","标牌信息不存在！","",0) q
		.s CycleCount=CodeDictObj.CSSDCDCycleCount	//循环数
		.i ((+WorkTimes'=0)&&(WorkTimes<CycleCount)) d RtnObj.Err(-1,"","该标牌已达到所设置的最大使用次数，不能生成标签！","",0) q
		continue:RtnObj.success'=0

		i PMaterialId="" d
		.s PMaterialId=##Class(web.CSSDHUI.Common.PackageInfoCommon).GetDefaultMaterial(PkgId)
		i PMaterialId="" d RtnObj.Err(-1,"","未获取到包装材料","",0)
		continue:RtnObj.success'=0

		s MaterialInfo=##class(web.CSSDHUI.Common.PackageInfoCommon).GetMaterialExpireLength(PMaterialId,PkgId)
		i MaterialInfo="" d RtnObj.Err(-2,"","消毒包和包装材料未做绑定！","",0)
		continue:RtnObj.success'=0

		s Length=$p(MaterialInfo,"^",1)
		s Price=$p(MaterialInfo,"^",2)
		i Length=0 d RtnObj.Err(-3,"","消毒包有效期为空","",0)
		continue:RtnObj.success'=0

		i IsExpDateInCurDay="Y"	d
		.s ExpDate=PackDate+Length
		e  d
		.s ExpDate=PackDate+Length+1

		s CleanItmId=0
		f  s CleanItmId=$o(ColPackInfo("AllCheckPkg",PkgId,ToLocId,PkgNum,"N",CleanItmId)) q:(CleanItmId="")||(LastQty'>0)||(RtnObj.success'=0)  d
		.s DetailInfo=ColPackInfo("AllCheckPkg",PkgId,ToLocId,PkgNum,"N",CleanItmId)
		.s CleanItmId=$p(DetailInfo,"^",3)
		.s PackageToLocId=$p(DetailInfo,"^",4)
		.s LevelFlag=$p(DetailInfo,"^",5)
		.//s CodeDict=$p(DetailInfo,"^",6)
		.s IsExt=$p(DetailInfo,"^",7)
		.s CleanItmObj=##class(User.CSSDCleanDetailPacks).%OpenId(CleanItmId)
		.d CleanItmObj.%Reload()
		.s CleanId=CleanItmObj.CSSDCDPCleanMainGetObjectId()
		.s CallBackDetailId=CleanItmObj.CSSDCDPCallBackDetailDrGetObjectId()
		.s IsGen=CleanItmObj.CSSDCDPIsCrtLbl
		.s ExtDr = CleanItmObj.CSSDCDPExtDRGetObjectId()
		.q:IsGen=1	//过滤已完全生成标签数
		.
		.s CleanQty=CleanItmObj.CSSDCDPQty	//清洗数量
		.s AlreadyCreateQty=CleanItmObj.CSSDCDPCreatedQty	//已生成数量
		.s UnCreateQty=CleanQty-AlreadyCreateQty	//未生成数量
		.s IsCrlFlag=""	//清洗明细全生成标志
		.i LastQty>=UnCreateQty s CreateQty=UnCreateQty,IsCrlFlag="1"	//此清洗明细可生成数量
		.e  s CreateQty=LastQty
		.s:(PPackLocId="")&&(ToLocId'="无") PPackLocId=ToLocId	//默认界面上选择接收科室
		.s SerialNo=##class(web.CSSDHUI.Common.AppCommon).CreatePackSerialNo()
		.s BindLabel=""
		.i IsExt="Y" d
		..s BindLabel=..GetExtBindLabel(CodeDict,AlreadyCreateQty)
		..i BindLabel="" d RtnObj.Err(-1,"","生成绑定的固定标签为空 检查包属性","",0) q
		..s Labels=..GetExtLabels(BindLabel,CreateQty)
		.e  i CodeDict="" d
		..s Labels=..GetOrdLabels(PkgCode,CreateQty)
		.e  d
		..s Labels=..GetOprLabel(CodeDict)
		.i Labels="" d RtnObj.Err(-3,"","生成标签失败","",0)
		.q:RtnObj.success'=0
		.
		.s lblLenth=$L(Labels,"^")
		.f j=1:1:lblLenth  q:RtnObj.success<0  d
		..s Label=$p(Labels,"^",j)
		..//插入标签信息
		..&sql(Insert into CSSD_PackagePack(CSSDPP_Label,CSSDPP_Package_DR,CSSDPP_Loc_DR,
			CSSDPP_Date,CSSDPP_Time,CSSDPP_Qty,CSSDPP_User_DR,CSSDPP_AckUser_DR,
			CSSDPP_AckDate,CSSDPP_SerialNo,CSSDPP_IsLoadSteCar,
			CSSDPP_CallBackDetailDr,CSSDPP_PackUser_DR,CSSDPP_Material_DR,CSSDPP_LevelFlag,
			CSSDPP_PackLocDr,CSSDPP_FixedLabel,CSSDPP_Machine_DR,CSSDPP_HeatNo,
			CSSDPP_PackNum,CSSDPP_NewLabel,CSSDPP_PrtTimes,CSSDPP_Clean_DR,CSSDPP_CleanDetail_DR,
			CSSDPP_SterUser_DR)
			Values
			(:Label,:PkgId,:gLocId,:PackDate,:PackTime,1,:PPackUserId,:PPackUserChkId,
			:PackDate,:SerialNo,0,:CallBackDetailId,:PPackerUserId,:PMaterialId,
			:LevelFlag,:PPackLocId,:CodeDictId,:PSterMachineId,:PHeatNo,:PPackNum,:BindLabel,0,:CleanId,:CleanItmId,
			:PSterUserId))
		..i SQLCODE'=0 d RtnObj.Err(-10,"","插入标签包装数据失败")
		..q:RtnObj.success<0
		..
		..s PackId=%ROWID
		..//插入追踪信息
		..&sql(Insert into CSSD_Trans(CSSDT_Label,CSSDT_Pack_DR,CSSDT_Package_DR,
			CSSDT_Clean_DR,CSSDT_Date,CSSDT_Time,CSSDT_ExpDate,cssdt_Status,
			CSSDT_CodeDict_DR,CSSDT_CodeDict,CSSDT_PreCallBackDetail_DR,CSSDT_CurrLoc_DR)
			Values
			(:Label,:PackId,:PkgId,
			:CleanItmId,:PackDate,:PackTime,:ExpDate,'P',
			:CodeDictId,:CodeDict,:CallBackDetailId,:gLocId))
		..i SQLCODE'=0 d RtnObj.Err(-11,"","插入标签追踪数据失败")
		..q:RtnObj.success<0
		..
		..s TransId=%ROWID
		..//更新外来器械信息
		..s CycleCount=1	//标牌增加循环次数
		..i IsExt="Y" d
		...s labelNo=$E(Label,$l(Label)-1,$l(Label))
		...s ExtDetailDr=$o(^User.CSSDExtDevBindDetailI("CSSDParrefDrPkgNumIndex",ExtDr,labelNo,""))
		...i ExtDetailDr'="" d
		....&sql(UPDATE CSSD_ExtDevBindDetail SET CSSDEBD_Label =:Label WHERE CSSDEBD_Parref_DR=:ExtDr and CSSDEBD_PkgNum=:labelNo)
		....i SQLCODE'=0 d RtnObj.Err(-3,"","更新外来器械明细数据失败") q
		...q:RtnObj.success<0
		...i AlreadyCreateQty=0 d
		....&sql(Update CSSD_ExtDevBind set CSSDExt_Label=:BindLabel,CSSDExt_Status='P' where CSSDExt_Rowid=:ExtDr)
		....i SQLCODE'=0 d RtnObj.Err(-12,"","更新数据失败,未获取到外来器械登记信息！") q
		...e  d
		....s CycleCount=0	//外来器械同一明细非第一次生成，不增加标牌循环次数
		..q:RtnObj.success<0
		..
		..//更新标牌信息
		..i CodeDict'="" d
		...&sql(Update CSSD_CodeDict set CSSDCD_TableRowID=:TransId,CSSDCD_CycleCount=CSSDCD_CycleCount+:CycleCount where CSSDCD_Code=:CodeDict)
		...i SQLCODE'=0 d RtnObj.Err(-21,"","更新标牌使用次数失败")
		..q:RtnObj.success<0
		.//更新清洗明细标签数量及标签全生成标志
		.&sql(Update CSSD_CleanDetailPacks set cssdcdp_CreatedQty=cssdcdp_CreatedQty+:CreateQty,CSSDCDP_IsCrtLbl=:IsCrlFlag where %id=:CleanItmId)
		.i SQLCODE'=0 d RtnObj.Err(-21,"","更新清洗明细标签信息失败")
		.q:RtnObj.success<0
		.
		.//更新清洗主单标签全生成标志
		.s flag="",tmpCleanItmId=0
		.f  s tmpCleanItmId=$o(^User.CSSDCleanDetailPacksI("IndexMainDrIsCrtLbl",CleanId,"0",tmpCleanItmId)) q:(tmpCleanItmId="")||(flag'="")  d
		..s States=$lg(^User.CSSDCleanDetailPacksD(tmpCleanItmId),14)
		..q:States="N"
		..s flag=tmpCleanItmId
		.i flag="" d
		..&sql(update CSSD_Clean set cssdc_iscreatelbl=1 where id=:CleanId)
		..i SQLCODE<0 d RtnObj.Err(-32,"","更新清洗主单标签完成标志失败")
		.q:RtnObj.success'=0
		.
		.//更新剩余可生成标签数量
		.s LastQty=LastQty-CreateQty	//更新标签剩余生成数量
		q:RtnObj.success'=0
	}
	d ..sssUnLock(AppName)
	q RtnObj
}

ClassMethod GetToLocByCleanD(CleanItmId) As %String
{
	n (CleanItmId)
	s ToLocId=""

	//1.依据清洗单取接收科室
	s CleanItmObj=##class(User.CSSDCleanDetailPacks).%OpenId(CleanItmId)
	i $IsObject(CleanItmObj) d
	.s CallBackDetailObj=CleanItmObj.CSSDCDPCallBackDetailDr
	.i $IsObject(CallBackDetailObj) d
	..s ToLocId=CallBackDetailObj.CSSDCDParref.CSSDPCFromLocDrGetObjectId()
	q:ToLocId'="" ToLocId

	//2.按消毒包取接收科室
	s PkgObj=CleanItmObj.CSSDPRPackage
	i $IsObject(PkgObj) d
	.s ToLocId=PkgObj.CSSDPLOCDRGetObjectId()
	q:ToLocId'="" ToLocId

	q ToLocId
}

/// Creator:lxt
/// CreatDate:20230413
/// Description:修改标签信息
/// Table:CSSD_PackagePack
/// Input:Params
/// Output:
/// Return:RtnObj
/// others:
/// w ##Class(web.CSSDHUI.Pack.CleanPackLabel).jsUpdateLabelInfo("{""EditChkUser"":""11889"",""gUserId"":""11889"",""gLocId"":""166"",""gGroupId"":""102"",""gHospId"":""2"",""EditPackUser"":""11889"",""EditPacker"":""11889"",""EditSterDate"":""2023-04-15"",""EditMaterial"":"""",""EditMachine"":""1"",""EditSterUser"":""11889"",""EditChkUserFlag"":""Y"",""EditPackUserFlag"":""Y"",""EditPackerFlag"":""Y"",""EditSterDateFlag"":""Y"",""EditMaterialFlag"":"""",""EditMachineFlag"":""Y"",""EditHeatNoFlag"":""Y"",""EditSterUserFlag"":""Y"",""EditRemarkFlag"":""Y"",""EditHeatNo"":""111"",""EditRemark"":""111""}","216")
ClassMethod jsUpdateLabelInfo(Main As %String, PackIdStr As %String) As %Library.String
{
	n (Main,PackIdStr)
	s $ZT=..sssError()
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	ts
	s RtnObj=..UpdateLabelInfo(Main,PackIdStr)
	i RtnObj.success'=0 tro  q RtnObj.Json()
	tc
	q RtnObj.Json()
}

/// Creator:lxt
/// CreatDate:20230413
/// Description:修改标签信息
/// Table:CSSD_PackagePack
/// Input:Params
/// Output:
/// Return:RtnObj
ClassMethod UpdateLabelInfo(Main, PackIdStr) As web.CSSDHUI.RtnObj
{
	n (Main,PackIdStr)
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	i ((Main="")||(PackIdStr="")) q RtnObj.Err(-1,"","入参不能为空!","",0)

	s PJObj=##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Main)
	q:(Sc'=0) RtnObj.Err(-1,"","入参解析失败","",0)

	s PEditChkUserFlag=PJObj.%Get("EditChkUserFlag")
	s PEditChkUserId=PJObj.%Get("EditChkUser")
	
	s PEditPackUserFlag=PJObj.%Get("EditPackUserFlag")
	s PEditPackUserId=PJObj.%Get("EditPackUser")
	
	s PEditPackerFlag=PJObj.%Get("EditPackerFlag")
	s PEditPackerId=PJObj.%Get("EditPacker")
	
	s PEditToLocFlag=PJObj.%Get("EditToLocFlag")
	s PEditToLocId=PJObj.%Get("EditToLoc")
	
	s PEditSterDateFlag=PJObj.%Get("EditSterDateFlag")
	s PEditSterDate=PJObj.%Get("EditSterDate")
	s:PEditSterDate'="" PEditSterDate=..DH2L(PEditSterDate)
	
	s PEditMaterialFlag=PJObj.%Get("EditMaterialFlag")
	s PEditMaterialId=PJObj.%Get("EditMaterial")
	
	s PEditMachineFlag=PJObj.%Get("EditMachineFlag")
	s PEditMachineId=PJObj.%Get("EditMachine")
	
	s PEditHeatNoFlag=PJObj.%Get("EditHeatNoFlag")
	s PEditHeatNo=PJObj.%Get("EditHeatNo")
	
	s PEditSterUserFlag=PJObj.%Get("EditSterUserFlag")
	s PEditSterUserId=PJObj.%Get("EditSterUser")
	
	s PEditRemarkFlag=PJObj.%Get("EditRemarkFlag")
	s PEditRemark=PJObj.%Get("EditRemark")
	
	q:(PEditChkUserFlag'="Y")&&(PEditPackUserFlag'="Y")&&(PEditPackerFlag'="Y")&&(PEditToLocFlag'="Y")&&(PEditSterDateFlag'="Y")&&(PEditMaterialFlag'="Y")&&(PEditMachineFlag'="Y")&&(PEditHeatNoFlag'="Y")&&(PEditSterUserFlag'="Y")&&(PEditRemarkFlag'="Y") RtnObj.Err(-1,"","没有需要保存的信息","",0)
	q:(PEditChkUserFlag="Y")&&(PEditChkUserId="") RtnObj.Err(-1,"","审核人为空","",0)
	q:(PEditPackUserFlag="Y")&&(PEditPackUserId="") RtnObj.Err(-1,"","包装人为空","",0)
	q:(PEditPackerFlag="Y")&&(PEditPackerId="") RtnObj.Err(-1,"","配包人为空","",0)
	q:(PEditMaterialFlag="Y")&&(PEditMaterialId="") RtnObj.Err(-1,"","包装材料为空","",0)

	s Len=$l(PackIdStr,",")
	f i=1:1:Len q:(RtnObj.success'=0)  d
	.s PackId=$p(PackIdStr,",",i)
	.s PackObj=##class(User.CSSDPackagePack).%OpenId(PackId)
	.d PackObj.%Reload()
	.s Label=PackObj.CSSDPPLabel
	.s PkgId=PackObj.CSSDPPPackageGetObjectId()
	.s SterItmId=$o(^User.CSSDPackageSterilizeI("IndexCSSDPSLabel",Label,""))
	.i SterItmId'="" d RtnObj.Err("-2","",Label_"该标签已灭菌,不允许修改")
	.q:RtnObj.success'=0
	.s Length=0
	.i PEditChkUserFlag="Y" d
	..d PackObj.CSSDPPAckUserDrSetObjectId(PEditChkUserId)
	.i PEditPackUserFlag="Y" d
	..d PackObj.CSSDPPUserDrSetObjectId(PEditPackUserId)
	.i PEditPackerFlag="Y" d
	..d PackObj.CSSDPPPackUserDrSetObjectId(PEditPackerId)
	.i PEditToLocFlag="Y" d
	..d PackObj.CSSDPPPackLocDrSetObjectId(PEditToLocId)
	.i PEditSterDateFlag="Y" d
	..s PackObj.CSSDPPAckDate=PEditSterDate
	.i PEditMaterialFlag="Y" d
	..d PackObj.CSSDPPMaterialDrSetObjectId(PEditMaterialId)
	..s MaterialInfo=##class(web.CSSDHUI.Common.PackageInfoCommon).GetMaterialExpireLength(PEditMaterialId,PkgId)
	..i MaterialInfo="" d RtnObj.Err(-3,"","消毒包和包装材料未做绑定！","",0) q
	..s Length=$p(MaterialInfo,"^",1)
	..i Length="0" d RtnObj.Err(-3,"","包装材料效期为0","",0) q
	.q:RtnObj.success'=0
	.i PEditMachineFlag="Y" d
	..d PackObj.CSSDPPMachineDRSetObjectId(PEditMachineId)
	.i PEditHeatNoFlag="Y" d
	..s PackObj.CSSDPPHeatNo=PEditHeatNo
	.i PEditSterUserFlag="Y" d
	..d PackObj.CSSDPPSterUserDrSetObjectId(PEditSterUserId)
	.i PEditRemarkFlag="Y" d
	..s PackObj.CSSDPPRemark=PEditRemark
	.s Sc=PackObj.%Save()
	.i $$$ISERR(Sc) d RtnObj.Err(-5,"","包装信息保存失败")
	.q:RtnObj.success'=0
	.
	.i Length>0 d
	..s TransId=$o(^User.CSSDTransI("CSSDTLabel",Label,0))
	..s TransObj=##class(User.CSSDTrans).%OpenId(TransId)
	..d TransObj.%Reload()
	..s TransObj.CSSDTExpDate=TransObj.CSSDTDate+Length
	..s Sc=TransObj.%Save()
	..i $$$ISERR(Sc) d RtnObj.Err(-5,"","追踪信息保存失败") q
	.q:RtnObj.success'=0
	
	q RtnObj
}

/// Creator:lxt
/// CreateDate:20230418
/// Description:更新清洗主单完全打包标志
/// w ##class(web.CSSDHUI.Pack.CleanPackLabel).UpdateCleanIsCreateLbl(17).Json()
ClassMethod UpdateCleanIsCreateLbl(CleanId) As web.CSSDHUI.RtnObj
{
	n (CleanId)
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	s IsCrtLbl=1
	
	s CleanItmId=0
	f  s CleanItmId=$o(^User.CSSDCleanDetailPacksI("IndexMainDr",CleanId,CleanItmId)) q:(CleanItmId="")||(IsCrtLbl=0)  d
	.s CleanItmObj=##class(User.CSSDCleanDetailPacks).%OpenId(CleanItmId)
	.d CleanItmObj.%Reload()
	.s ItmIsCrtLbl=CleanItmObj.CSSDCDPIsCrtLbl
	.s ItmStates=CleanItmObj.CSSDCDPStates
	.q:ItmStates="N"
	.q:ItmIsCrtLbl=1
	.s ExtId=CleanItmObj.CSSDCDPExtDRGetObjectId()
	.i ExtId="" d
	..s IsCrtLbl=0
	.e  d
	..s IsTransfer=CleanItmObj.CSSDCDPExtDR.CSSDExtIsTransfer
	..i IsTransfer'="Y" s IsCrtLbl=0
	.q:IsCrtLbl=0
	
	i IsCrtLbl=1 d
	.&sql(update CSSD_Clean set CSSDC_IsCreateLbl=1 where ID=:CleanId)
	.i SQLCODE'=0 d RtnObj.Err(-2,"","更新清洗单失败！")
	
	q RtnObj
}

/// Creator:ban
/// CreatDate:2020.12.03
/// Description:根据绑定的标签去循环生成对应数量的具体外来标签
/// Table:
/// Input:BindLabel 外来器械绑定的标签,Num:生成数量
/// Output:
/// Return:
/// w ##Class(web.CSSDHUI.Pack.CleanPackLabel).GetExtLabels("004020004000001",2)
ClassMethod GetExtLabels(BindLabel As %String, Num As %String) As %String
{
	n (BindLabel,Num,%session)
	s Labels="",cur=0
	s maxNo=""
	&sql(Select Max(CSSDPP_Label) into :maxNo From CSSD_PackagePack
		WHERE CSSDPP_Label %STARTSWITH :BindLabel)
	s cur= +$e(maxNo,$l(maxNo)-1,$l(maxNo))	;取后五位
	f i=1:1:Num d
	.s cur=cur+1 
	.s Label= BindLabel_$tr($j(cur,2)," ","0")
	.i Labels="" d
	..s Labels=Label
	.e  d
	..s Labels=Labels_"^"_Label
	q Labels
}

/// 生成标牌追溯包标签方法
/// w ##Class(web.CSSDHUI.Pack.CleanPackLabel).GetExtBindLabel("004020004","2")
ClassMethod GetExtBindLabel(Code As %String, CreatedQty As %String) As %String
{
	n (Code,CreatedQty,%session)
	s PackageInfo=##class(web.CSSDHUI.Common.PackageInfoCommon).GetPkgInfoByCodeDict(Code)
	q:PackageInfo="" ""
	s CodeDictId=$p(PackageInfo,"^",4)

	s CycleCount=+$Lg(^User.CSSDCodeDictD(CodeDictId),3)
	i CycleCount=0 d	//初次使用标牌 +1
	.s CycleCount=1
	e  i CreatedQty=0 d	//当前清洗明细初次生成标签
	.s CycleCount=CycleCount+1
	s Label=$tr($j(CycleCount,6)," ",0)
	s Label=Code_Label
	q Label
}

/// Creator:zx
/// CreatDate:2023.4.20
/// Description:停用标签
/// Table:cssd_trans
/// Input:Params
/// Output:
/// Return:RtnObj
/// others:
/// w ##Class(web.CSSDHUI.Pack.CleanPackLabel).jsSetNotAvailable
ClassMethod jsSetNotAvailable(Detail) As %String
{
	n (Detail)
	s $ZT=..sssError()
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	ts
	s RtnObj=..SetNotAvailable(Detail)
	i RtnObj.success<0 tro  q RtnObj.Json()
	tc
	q RtnObj.Json()
}

/// Creator:zx
/// CreatDate:2023.4.20
/// Description:停用标签
/// Table:cssd_trans
/// Input:Params
/// Output:
/// Return:RtnObj
/// others:
/// w ##Class(web.CSSDHUI.Pack.CleanPackLabel).SetNotAvailable()
ClassMethod SetNotAvailable(Detail) As %String
{
	n (Detail)
	s MethodName=$ClassName()_".SetNotAvailable"
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	q:(Detail="") RtnObj.Err(-1,"","入参不能为空!","",0)

	s PJObjDetail=##class(web.CSSDHUI.Common.FromJson).%New()
	s ScDetail=PJObjDetail.%FromJSON(Detail)
	q:(ScDetail'=0) RtnObj.Err(-1,"","入参解析失败:"_MethodName)


	ts
	while(RtnObj.success=0){
		s Obj=PJObjDetail.%Pop()
		q:Obj=""

		s PackId=Obj.%Get("PackId")
		s PkgLabel=Obj.%Get("Label")
		s TransId= $o(^User.CSSDTransI("CSSDTLabel",PkgLabel,""))
		i TransId="" d RtnObj.Err(-2,"","标签不存在不能停用！","",0)
		continue:RtnObj.success'=0
		s IsLoad=##class(User.CSSDPackagePack).%OpenId(PackId).CSSDPPIsLoadSteCar
		i IsLoad=1  d RtnObj.Err(-3,"","已经灭菌不能修改")
		continue:RtnObj.success'=0
		
		s TransObj=##class(User.CSSDTrans).%OpenId(TransId)
		d TransObj.%Reload()
		s Status=TransObj.CSSDTStatus
		i Status="PA" d RtnObj.Err(-4,"","标签是停用状态不能重复停用！","",0)
		continue:RtnObj.success'=0
		i Status'="P" d RtnObj.Err(-5,"","标签不是包装状态不能停用！","",0)
		continue:RtnObj.success'=0
		
		s TmpStatus="PA"
		&sql(update cssd_trans set CSSDT_Status=:TmpStatus where cssdt_pack_dr=:PackId)
		i SQLCODE'=0 d RtnObj.Err(-6,"","更新数据失败:"_MethodName_"SQLCODE"_SQLCODE_":"_$g(%msg))
		continue:RtnObj.success'=0
	}
	i RtnObj.success<0 tro  q RtnObj
	tc
	q RtnObj
}

/// Creator:zx
/// CreatDate:2023.4.20
/// Description:标签复用
/// Table:cssd_trans
/// Input:Params
/// Output:
/// Return:RtnObj
/// others:
/// w ##Class(web.CSSDHUI.Pack.CleanPackLabel).jsSetAvailable
ClassMethod jsSetAvailable(Detail) As %String
{
	n (Detail)
	s $ZT=..sssError()
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	ts
	s RtnObj=..SetAvailable(Detail)
	i RtnObj.success<0 tro  q RtnObj.Json()
	tc
	q RtnObj.Json()
}

/// Creator:zx
/// CreatDate:2023.4.20
/// Description:标签复用
/// Table:cssd_trans
/// Input:Params
/// Output:
/// Return:RtnObj
/// others:
/// w ##Class(web.CSSDHUI.Pack.CleanPackLabel).SetAvailable
ClassMethod SetAvailable(Detail) As %String
{
	n (Detail)
	s MethodName=$ClassName()_".SetAvailable"
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	q:(Detail="") RtnObj.Err(-1,"","入参不能为空!","",0)

	s PJObjDetail=##class(web.CSSDHUI.Common.FromJson).%New()
	s ScDetail=PJObjDetail.%FromJSON(Detail)
	q:(ScDetail'=0) RtnObj.Err(-1,"","入参解析失败:"_MethodName)


	ts
	while(RtnObj.success=0){
		s Obj=PJObjDetail.%Pop()
		q:Obj=""

		s PackId=Obj.%Get("PackId")
		s PkgLabel=Obj.%Get("Label")
		s TransId= $o(^User.CSSDTransI("CSSDTLabel",PkgLabel,""))
		i TransId="" d RtnObj.Err(-2,"","标签不存在不能复用！","",0)
		continue:RtnObj.success'=0
		s TransObj=##class(User.CSSDTrans).%OpenId(TransId)
		d TransObj.%Reload()
		s Status=TransObj.CSSDTStatus
		i Status'="PA" d RtnObj.Err(-3,"","标签不是停用状态不能复用！","",0)
		continue:RtnObj.success'=0
		
		s TmpStatus="P"
		&sql(update cssd_trans set CSSDT_Status=:TmpStatus where cssdt_pack_dr=:PackId)
		i SQLCODE'=0 d RtnObj.Err(-4,"","更新数据失败:"_MethodName_"SQLCODE"_SQLCODE_":"_$g(%msg))
		continue:RtnObj.success'=0
	}
	i RtnObj.success<0 tro  q RtnObj
	tc
	q RtnObj
}

}
