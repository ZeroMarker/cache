Import sqluser

/// 字典公共类  wfg  2019-04-01
Class web.CSSDHUI.Common.Dicts Extends (%RegisteredObject, web.CSSDHUI.CSSDType) [ Not ProcedureBlock ]
{

/// Creator:wfg
/// Date:2018-4-18
/// Description: 消毒包分类
/// Input:  StkGrpId
/// d ##class(%ResultSet).RunQuery("web.CSSDHUI.Common.Dicts","GetPackageClass")
Query GetPackageClass(Params As %String = "") As web.CSSDHUI.Query(ROWSPEC = "RowId:%Integer,Description") [ SqlProc ]
{
}

ClassMethod GetPackageClassExecute(ByRef qHandle As %Binary, Params As %String = "") As %Status
{
	n (qHandle,Params,%session)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	s PJObj = ##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 q $$$OK
	s pHospId=PJObj.%Get("BDPHospital")
	s gHospId=PJObj.%Get("gHospId")
	s pHospId=##class(web.CSSDHUI.HospMap).GetBDPHospId(pHospId,gHospId)
	s Result=##class(%Library.ResultSet).%New()
	s SqlStr = "SELECT ID, CSSDPC_PackClassName , CSSDPC_PackClassCode, CSSDPC_BusinessProcess FROM CSSD_PackageClass where CSSDPC_NotUseFlag='Y' order by ID"
	d Result.RuntimeModeSet(0)
	d Result.Prepare(SqlStr)
	d Result.Execute()
	While(Result.Next())
	{
		s RowId = Result.Data("ID")
		s result =##class(web.CSSDHUI.HospMap).GetShowDataFlag("CSSD_PackageClass",RowId,pHospId)
		continue:result="N"
		s Description = Result.Data("CSSDPC_PackClassName")
		s Description = ..%FieldTranslate("User.CSSDPackageClass","CSSDPCPackClassName",Description)
		d OutPutPackageClass
	}
	d Result.Close()
	Quit $$$OK
	
OutPutPackageClass
	s Data=$lb(RowId,Description)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// Creator:ban
/// Date:2020-4-18
/// Description: 灭菌方式公用字典
/// Input:  
/// w ##class(%ResultSet).RunQuery("web.CSSDHUI.Common.Dicts","GetSterType","")
Query GetSterType(isSter As %String, Params As %String = "") As web.CSSDHUI.Query(ROWSPEC = "RowId:%Integer,Description") [ SqlProc ]
{
}

ClassMethod GetSterTypeExecute(ByRef qHandle As %Binary, isSter As %String, Params As %String = "") As %Status
{
	n (qHandle,isSter,Params,%session)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	
	s PJObj = ##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 q $$$OK
	s pHospId=PJObj.%Get("BDPHospital")
	s gHospId=PJObj.%Get("gHospId")
	s pHospId=##class(web.CSSDHUI.HospMap).GetBDPHospId(pHospId,gHospId)
	s Result=##class(%Library.ResultSet).%New()
	s SqlStr = "SELECT ID,CSSDST_SterName FROM CSSD_SterType where CSSDST_NotUseFlag='Y' "
	i isSter'="" s SqlStr=SqlStr_" and CSSDST_IsSter= '"_isSter_"'"
	d Result.RuntimeModeSet(0)
	d Result.Prepare(SqlStr)
	d Result.Execute()
	While(Result.Next())
	{
		s RowId = Result.Data("ID")
		s result =##class(web.CSSDHUI.HospMap).GetShowDataFlag("CSSD_SterType",RowId,pHospId)
		continue:result="N"
		s Description = Result.Data("CSSDST_SterName")
		d OutPutSterType
	}
	d Result.Close()
	Quit $$$OK
	
OutPutSterType
	s Data=$lb(RowId,Description)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// Creator:ban
/// Date:2020-3-25
/// Description: 获取所有灭菌架及清洗架信息
/// Input:  CSSD_CodeDict
/// w ##class(%ResultSet).RunQuery("web.CSSDHUI.Common.Dicts","GetAllSterCar","4")
Query GetAllSterCar(Params As %String = "", PackTypeDetail As %String = "") As web.CSSDHUI.Query(ROWSPEC = "RowId:%Integer,Code,Description,SterType,SterName,NotUseFlag") [ SqlProc ]
{
}

ClassMethod GetAllSterCarExecute(ByRef qHandle As %Binary, Params As %String = "", PackTypeDetail As %String = "") As %Status
{
	n (qHandle,Params,PackTypeDetail,%session)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	s PJObj = ##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 q $$$OK
	s pHospId=PJObj.%Get("BDPHospital")
	s gHospId=PJObj.%Get("gHospId")
	s SterWay=PJObj.%Get("SterWay")
	s pHospId=##class(web.CSSDHUI.HospMap).GetBDPHospId(pHospId,gHospId)
	s Result=##class(%Library.ResultSet).%New()
	s SqlStr = "SELECT ID,CSSDCD_Code,CSSDCD_PackName,CSSDCD_PackDR->CSSDP_SterType as SterType,"
			_" CSSDCD_PackDR->CSSDP_SterType->CSSDST_SterName as SterName,"
			_" CSSDCD_PackDR->CSSDP_NotUseFlag as NotUseFlag FROM CSSD_CodeDict WHERE CSSDCD_PackDR->CSSDP_NotUseFlag='Y' "
	i PackTypeDetail'="" s SqlStr=SqlStr_" and CSSDCD_PackDR->CSSDP_PackTypeDetail='"_PackTypeDetail_"' "
	e  s SqlStr=SqlStr_" and CSSDCD_PackDR->CSSDP_PackTypeDetail in ('3','6') "
	s SqlStr=SqlStr_" ORDER BY CSSDCD_PackDR->CSSDP_PackTypeDetail desc "
	d Result.RuntimeModeSet(0)
	d Result.Prepare(SqlStr)
	d Result.Execute()
	While(Result.Next())
	{
		s RowId = Result.Data("ID")
		s result =##class(web.CSSDHUI.HospMap).GetShowDataFlag("CSSD_CodeDict",RowId,pHospId)
		continue:result="N"
		s Code = Result.Data("CSSDCD_Code")
		s Description = Result.Data("CSSDCD_PackName")
		s CarSterWay = Result.Data("SterType")
		continue:((SterWay'="")&&(SterWay'=CarSterWay))
		s CarSterName = Result.Data("SterName")
		s NotUseFlag = Result.Data("NotUseFlag")
		d OutPutAllSterCar
	}
	d Result.Close()
	Quit $$$OK
	
OutPutAllSterCar
	s Data=$lb(RowId,Code,Description,CarSterWay,CarSterName,NotUseFlag)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// Creator:ban
/// Date:2020-3-25
/// Description: 获取外来器械厂商信息
/// Input:  SQLUser.CSSD_Ven
/// d ##class(%ResultSet).RunQuery("web.CSSDHUI.Common.Dicts","GetFirm")
Query GetFirm(Params As %String = "") As web.CSSDHUI.Query(ROWSPEC = "RowId:%Integer,Description") [ SqlProc ]
{
}

ClassMethod GetFirmExecute(ByRef qHandle As %Binary, Params As %String = "") As %Status
{
	n (qHandle,Params,%session)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	s PJObj = ##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 q $$$OK
	s pHospId=PJObj.%Get("BDPHospital")
	s gHospId=PJObj.%Get("gHospId")
	s PMachineType=PJObj.%Get("MachineType")
	s Result=##class(%Library.ResultSet).%New()
	s pHospId=##class(web.CSSDHUI.HospMap).GetBDPHospId(pHospId,gHospId)
	s SqlStr = "SELECT CSSDVen_Rowid, CSSDVen_Name, CSSDVen_Type FROM CSSD_Ven where CSSDVen_IsStop='Y' "
	s SqlStr=SqlStr_" order by CSSDVen_Rowid"
	d Result.RuntimeModeSet(0)
	d Result.Prepare(SqlStr)
	d Result.Execute()
	While(Result.Next())
	{
		s RowId = Result.Data("CSSDVen_Rowid")
		s result =##class(web.CSSDHUI.HospMap).GetShowDataFlag("CSSD_Ven",RowId,pHospId)
		continue:result="N"
		s Description = Result.Data("CSSDVen_Name")
		s MachineType = Result.Data("CSSDVen_Type")
		continue:(PMachineType'="")&&(MachineType'="")&&(PMachineType'=MachineType)
		d OutPutFirm
	}
	d Result.Close()
	Quit $$$OK
	
OutPutFirm
	s Data=$lb(RowId,Description)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

ClassMethod GetFirmInfo(Rowid As %String)
{
	n (Rowid)
	q:Rowid="" ""
	s FirmInfoObj=##class(User.CSSDVen).%OpenId(Rowid)
	q:'$IsObject(FirmInfoObj) ""
	q FirmInfoObj.CSSDVenSaleManName_"^"_FirmInfoObj.CSSDVenTelephone
}

/// Description:获取消毒包
/// Creator:lxt
/// Date:20221117
/// Input:Params
/// Output:消毒包信息
/// d ##class(%ResultSet).RunQuery("web.CSSDHUI.Common.Dicts","GetPkg","{""BDPHospital"":""2"",""TypeDetail"":""1,2,7,10"",""gUserId"":""11889"",""gLocId"":""166"",""gGroupId"":""102"",""gHospId"":""2"",""LocId"":""166""}")
Query GetPkg(Params As %String = "") As web.CSSDHUI.Query(ROWSPEC = "RowId:%Integer,Description,MaterialId,MaterialDesc,FirmId,FirmName") [ SqlProc ]
{
}

ClassMethod GetPkgExecute(ByRef qHandle As %Binary, Params As %String = "") As %Status
{
	n (qHandle,Params,%session)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	
	s PJObj = ##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 q $$$OK
	
	s pTypeDetail=PJObj.%Get("TypeDetail")
	s pLocId=PJObj.%Get("LocId")
	s pPkgClassId=PJObj.%Get("PkgClassId")
	s pExtFlag=PJObj.%Get("ExtFlag")
	s pCreateLocId=PJObj.%Get("CreateLocId")
	s pHospId=PJObj.%Get("BDPHospital")
	s gHospId=PJObj.%Get("gHospId")
	s gLocId=PJObj.%Get("gLocId")
	i pLocId="" s pLocId=gLocId
	s DeptCenterId=$o(^User.CSSDDeptCenterI("CSSDDLocIndex",pLocId,""))
	s pHospId=##class(web.CSSDHUI.HospMap).GetBDPHospId(pHospId,gHospId)
	
	s SqlStr = "SELECT CSSDP_Rowid, CSSDP_Desc,CSSDP_ZCompany as FirmId,CSSDP_ZCompany->CSSDVen_Name as FirmName FROM CSSD_Package where CSSDP_NotUseFlag='Y'"
	i pTypeDetail'="" s SqlStr=SqlStr_" and CSSDP_PackTypeDetail in ("_pTypeDetail_")"
	i ((pLocId'="")&&(DeptCenterId="")) s SqlStr=SqlStr_" and (CSSDP_LOCDR="_pLocId_" or CSSDP_LOCDR IS NULL)"
	i pExtFlag="Y" s SqlStr=SqlStr_" and CSSDP_IsExt='Y'"
	e  i pExtFlag="N" s SqlStr=SqlStr_" and CSSDP_IsExt<>'Y'"
	i pPkgClassId'="" s SqlStr=SqlStr_" and CSSDP_PackClassdr="_pPkgClassId
	i pCreateLocId'="" s SqlStr=SqlStr_" and CSSDP_CreateLocDr="_pCreateLocId
	
	s Result=##class(%Library.ResultSet).%New()
	d Result.RuntimeModeSet(0)
	d Result.Prepare(SqlStr)
	d Result.Execute()
	While(Result.Next())
	{
		s RowId = Result.Data("CSSDP_Rowid")
		s Description = Result.Data("CSSDP_Desc")
		s FirmId = Result.Data("FirmId")
		s FirmName = Result.Data("FirmName")
		s Description=..%FieldTranslate("User.CSSDPackage","CSSDPDesc",Description)
		s result = ##class(web.CSSDHUI.HospMap).GetShowDataFlag("CSSD_Package",RowId,pHospId)
		continue:result="N"
		s MaterialId=##class(web.CSSDHUI.Common.PackageInfoCommon).GetDefaultMaterial(RowId)
		s MaterialDesc=$s(MaterialId'="":$lg(^User.CSSDMaterialD(MaterialId),3),1:"")
		d OutPutPkg
	}
	d Result.Close()
	Quit $$$OK
	
OutPutPkg
	s Data=$lb(RowId,Description,MaterialId,MaterialDesc,FirmId,FirmName)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// Descript:	灭菌不合格原因
/// Creater:	wfg
/// CreateDate:	2018-05-28
/// d ##class(%ResultSet).RunQuery("web.CSSDHUI.Common.Dicts","GetRetReason","{""BDPHospital"":""2"",""gUserId"":""11889"",""gLocId"":""166"",""gGroupId"":""102"",""gHospId"":""2""}")
Query GetRetReason(Params As %String) As web.CSSDHUI.Query(ROWSPEC = "RowId:%Integer,Description") [ SqlProc ]
{
}

ClassMethod GetRetReasonExecute(ByRef qHandle As %Binary, Params As %String) As %Status
{
	n (qHandle,Params)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	s PJObj=##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 q $$$OK
	s pHospId=PJObj.%Get("BDPHospital")
	s gHospId=PJObj.%Get("gHospId")
	s pHospId=##class(web.CSSDHUI.HospMap).GetBDPHospId(pHospId,gHospId)
	s NotUseFlag="Y"
	s Result=##class(%Library.ResultSet).%New()
	s SqlStr = "SELECT ID, CSSD_SteFailCode, CSSD_SteFailDesc FROM CSSD_SteCheckReason WHERE CSSDS_NotUseFlag='Y' "
	d Result.RuntimeModeSet(0)
	d Result.Prepare(SqlStr)
	d Result.Execute()
	While(Result.Next())
	{
		s RowId = Result.Data("ID")
		s ret =##class(web.CSSDHUI.HospMap).GetShowDataFlag("CSSD_SteCheckReason",RowId,pHospId)
		continue:ret="N"
		s Description = Result.Data("CSSD_SteFailDesc")
		d OutPutRetReasonRow
	}
	d Result.Close()
	Quit $$$OK
OutPutRetReasonRow
	s Data=$lb(RowId,Description)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// Descript:	清洗不合格原因
/// Creater:	wn
/// CreateDate:	2019-08-06
Query GetCleanReason(Params As %String) As web.CSSDHUI.Query(ROWSPEC = "RowId:%Integer,Description") [ SqlProc ]
{
}

ClassMethod GetCleanReasonExecute(ByRef qHandle As %Binary, Params As %String) As %Status
{
	n (qHandle,Params,%session)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	s PJObj=##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 q $$$OK
	s pHospId=PJObj.%Get("BDPHospital")
	s gHospId=PJObj.%Get("gHospId")
	s pHospId=##class(web.CSSDHUI.HospMap).GetBDPHospId(pHospId,gHospId)  
	s Result=##class(%Library.ResultSet).%New()
	s SqlStr = "SELECT ID, CSSD_RejectCode, CSSD_RejectDesc FROM CSSD_CleanItmReason where CSSDC_NotUseFlag='Y'"
	d Result.RuntimeModeSet(0)
	d Result.Prepare(SqlStr)
	d Result.Execute()
	While(Result.Next())
	{
		s RowId = Result.Data("ID")
		s result =##class(web.CSSDHUI.HospMap).GetShowDataFlag("CSSD_CleanItmReason",RowId,pHospId)
		continue:result="N"
		s Description = Result.Data("CSSD_RejectDesc")
		d OutPutCleanReasonRow
	}
	d Result.Close()
	Quit $$$OK
OutPutCleanReasonRow
	s Data=$lb(RowId,Description)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// Descript:	器械缺失原因
/// Creater:	wb
/// CreateDate:	2019-12-06
/// d ##class(%ResultSet).RunQuery("web.CSSDHUI.Common.Dicts","GetConsumeReason","{""BDPHospital"":""2"",""gUserId"":""11889"",""gLocId"":""166"",""gGroupId"":""102"",""gHospId"":""2""}")
Query GetConsumeReason(Params As %String) As web.CSSDHUI.Query(ROWSPEC = "RowId:%Integer,Description") [ SqlProc ]
{
}

ClassMethod GetConsumeReasonExecute(ByRef qHandle As %Binary, Params As %String) As %Status
{
	n (qHandle,Params,%session)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	s PJObj=##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 q $$$OK
	s pHospId=PJObj.%Get("BDPHospital")
	s gHospId=PJObj.%Get("gHospId")
	s pHospId=##class(web.CSSDHUI.HospMap).GetBDPHospId(pHospId,gHospId)  
	s NotUseFlag="Y" 
	s Result=##class(%Library.ResultSet).%New()
	s SqlStr = "SELECT CSSDMConsume_Rowid,CSSD_MConsumeCode,CSSD_MConsumeDesc FROM CSSD_MachineConsumeReason WHERE CSSDC_NotUseFlag=:NotUseFlag"
	d Result.RuntimeModeSet(0)
	d Result.Prepare(SqlStr)
	d Result.Execute()
	While(Result.Next())
	{
		s RowId = Result.Data("CSSDMConsume_Rowid")
		s result =##class(web.CSSDHUI.HospMap).GetShowDataFlag("CSSD_MachineConsumeReason",RowId,pHospId)
		continue:result="N"
		s Description = Result.Data("CSSD_MConsumeDesc")
		d OutPutConsumeReasonRow
	}
	d Result.Close()
	Quit $$$OK
OutPutConsumeReasonRow
	s Data=$lb(RowId,Description)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// ===========================================扫码形式获取数据start===========================
/// 获取机器信息 type: 清洗机  washer 灭菌器 sterilizer
/// w ##class(web.CSSDHUI.Common.Dicts).GetMachineNo("sterilizer","9","{""BDPHospital"":""2"",""gUserId"":""11889"",""gLocId"":""166"",""gGroupId"":""102"",""gHospId"":""2""}")
/// w ##class(web.CSSDHUI.Common.Dicts).GetMachineNo("washer","1","{""BDPHospital"":""2"",""gUserId"":""11889"",""gLocId"":""166"",""gGroupId"":""102"",""gHospId"":""2""}")
ClassMethod GetMachineNo(Type As %String, MachineNo As %String, Params As %String = "")
{
	n (Type,MachineNo,Params,%session)
	q:((Type="")||(MachineNo="")) "{}"
	
	s PJObj = ##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	q:Sc'=0 "{}"
	
	s pTempType=PJObj.%Get("TempType")
	s pHospId=PJObj.%Get("BDPHospital")
	s gHospId=PJObj.%Get("gHospId")
	s gLocId=PJObj.%Get("gLocId")
	s pSupLocId=PJObj.%Get("SupLocId")
	s:pSupLocId="" pSupLocId=gLocId
	s pHospId=##class(web.CSSDHUI.HospMap).GetBDPHospId(pHospId,gHospId)
	
	s Msg=""		;获取失败的提示信息
	s (Ret,ID,Name,NotUseFlag,TempType,SterCarDr,CarName,TempTypeDesc,CleanTypeDesc,MachineNum)=""
	s Rowid=""
	f  s Rowid=$o(^User.CSSDMachineConfigI("IndexCSSDMCNumType",MachineNo,Type,Rowid)) q:(+Rowid=0)||(Ret="Y")  d
	.s result=##class(web.CSSDHUI.HospMap).GetShowDataFlag("CSSD_MachineConfig",Rowid,pHospId)
	.q:result="N"
	.s MachineObj=##class(User.CSSDMachineConfig).%OpenId(Rowid)
	.q:'$IsObject(MachineObj)
	.s ID=Rowid
	.s Name=MachineObj.CSSDMCAlias
	.s UseFlag=MachineObj.CSSDMCNotUseFlag
	.s TempType=MachineObj.CSSDMCTempType
	.s SterCarDr=MachineObj.CSSDMCSterCarGetObjectId()
	.s MachineNum=MachineObj.CSSDMCNum
	.s SupLocId=MachineObj.CSSDMCSupLocDRGetObjectId()
	.q:(pSupLocId'="")&&(SupLocId'="")&&(pSupLocId'=SupLocId)
	.s CarName=""
	.i SterCarDr'="" d
	..s CarName=MachineObj.CSSDMCSterCar.CSSDCDPackName
	.
	.i UseFlag'="Y" s Msg=..%Translate($CLASSNAME(),"机器停用!") q
	.i (Type="washer")&&(pTempType'="")&&(TempType'="")&&(pTempType'=TempType) s Msg=..%Translate($CLASSNAME(),"清洗方式不符!") q
	.i (Type="sterilizer")&&(pTempType'="")&&(TempType'="")&&(pTempType'=TempType) s Msg=..%Translate($CLASSNAME(),"灭菌方式不符!") q
	.
	.i (Type="washer")&&(TempType'="") d
	..s TempTypeObj=##class(User.CSSDCleanType).%OpenId(TempType)
	..s TempTypeDesc=TempTypeObj.CSSDCTCleanMode
	.e  i (Type="sterilizer")&&(TempType'="") d
	..s TempTypeObj=##class(User.CSSDSterType).%OpenId(TempType)
	..s TempTypeDesc=TempTypeObj.CSSDSTSterName
	.
	.s Ret="Y"
	
	;s MachineData=Ret_"^"_ID_"^"_Name_"^"_NotUseFlag_"^"_TempType_"^"_TempTypeDesc_"^"_SterCarDr_"^"_CarName_"^"_CleanTypeDesc_"^"_MachineNum
	;s MachineTitleStr="Ret^ID^Name^NotUseFlag^TempType^TempTypeDesc^SterCarDr^CarName^CleanTypeDesc^MachineNum"

	i Ret'="Y" d
	.s:Msg="" Msg=..%Translate($CLASSNAME(),"此机器不存在!")
	.s Data=Msg
	.s Title="Msg"
	e  d
	.s Data=ID_"^"_MachineNum_"^"_Name_"^"_TempType_"^"_SterCarDr_"^"_CarName
	.s Title="ID^MachineNum^Name^TempType^SterCarDr^CarName"
	
	s MachineStr=##class(web.CSSDHUI.Common.UtilCommon).GetJsonStr(Data,Title)
	q MachineStr
}

/// Description:获取灭机器数据
/// Creator:	wangjiabin
/// CreatDate:	2022-03-10
/// Table:		CSSD_MachineConfig
/// Input:		
/// Output:
/// w ##class(web.CSSDHUI.Common.Dicts).GetSterMachineInfo("1","{""BDPHospital"":""2"",""gUserId"":""11889"",""gLocId"":""166"",""gGroupId"":""102"",""gHospId"":""2""}")
ClassMethod GetSterMachineInfo(MachineNo As %String, Params As %String)
{
	n (%session,MachineNo,Params)
	q:(MachineNo="") "{}"
	
	s PJObj = ##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	q:Sc'=0 "{}"
	
	s pTempType=PJObj.%Get("TempType")
	s pHospId=PJObj.%Get("BDPHospital")
	s gHospId=PJObj.%Get("gHospId")
	s pSupLocId=PJObj.%Get("SupLocId")
	s gLocId=PJObj.%Get("gLocId")
	s:pSupLocId="" pSupLocId=gLocId
	s pHospId=##class(web.CSSDHUI.HospMap).GetBDPHospId(pHospId,gHospId)
	
	s Msg=""		;获取失败的提示信息
	s (Ret,ID,Name,NotUseFlag,TempType,SterCarDr,CarName,TempTypeDesc,CleanTypeDesc,MachineNum)=""
	s Rowid=""
	f  s Rowid=$o(^User.CSSDMachineConfigI("IndexCSSDMCNumType",MachineNo,"sterilizer",Rowid)) q:(+Rowid=0)||(Ret="Y")  d
	.s result=##class(web.CSSDHUI.HospMap).GetShowDataFlag("CSSD_MachineConfig",Rowid,pHospId)
	.q:result="N"
	.s MachineObj=##class(User.CSSDMachineConfig).%OpenId(Rowid)
	.q:'$IsObject(MachineObj)
	.s ID=Rowid
	.s Name=MachineObj.CSSDMCAlias
	.s UseFlag=MachineObj.CSSDMCNotUseFlag
	.s TempType=MachineObj.CSSDMCTempType
	.s SterCarDr=MachineObj.CSSDMCSterCarGetObjectId()
	.s MachineNum=MachineObj.CSSDMCNum
	.s SupLocId=MachineObj.CSSDMCSupLocDRGetObjectId()
	.q:(pSupLocId'="")&&(SupLocId'="")&&(pSupLocId'=SupLocId)
	.s CarName=""
	.i SterCarDr'="" d
	..s CarName=MachineObj.CSSDMCSterCar.CSSDCDPackName
	.
	.i UseFlag'="Y" s Msg=..%Translate($CLASSNAME(),"机器停用!") q
	.i TempType="" s Msg=..%Translate($CLASSNAME(),"灭菌方式为空!") q
	.i (pTempType'="")&&(TempType'="")&&(pTempType'=TempType) s Msg=..%Translate($CLASSNAME(),"灭菌方式不符!") q
	.
	.i (TempType'="") d
	..s TempTypeObj=##class(User.CSSDSterType).%OpenId(TempType)
	..s TempTypeDesc=TempTypeObj.CSSDSTSterName
	.
	.s Ret="Y"
	
	i Ret'="Y" d
	.s:Msg="" Msg=..%Translate($CLASSNAME(),"此机器不存在!")
	.s Data=Msg
	.s Title="Msg"
	e  d
	.s Data=ID_"^"_MachineNum_"^"_Name_"^"_TempType_"^"_SterCarDr_"^"_CarName
	.s Title="ID^MachineNum^Name^TempType^SterCarDr^CarName"
	
	s MachineStr=##class(web.CSSDHUI.Common.UtilCommon).GetJsonStr(Data,Title)
	q MachineStr
}

/// Descript:	获取科室
/// Creater:	wb
/// CreateDate:	2020-1-13
ClassMethod GetLocId(ReqLoc As %String)
{
	n (ReqLoc)
	q:ReqLoc="" ""
	s ReqLocID="",Name="",Ret="N"
	&sql(SELECT CTLOC_RowID, CTLOC_Desc into :ReqLocID, :Name FROM CT_Loc WHERE CTLOC_RowID=:ReqLoc)
	s:SQLCODE=0 Ret="Y"
	q Ret_"^"_ReqLocID_"^"_Name
}

/// 获取灭菌程序
/// 灭菌程序2001  清洗程序1001
/// w ##class(web.CSSDHUI.Common.Dicts).GetSterPro("2001","1001","{""BDPHospital"":""2"",""gUserId"":""11889"",""gLocId"":""166"",""gGroupId"":""102"",""gHospId"":""2""}")
ClassMethod GetSterPro(type As %String, SterPro As %String, Params As %String)
{
	n (type,SterPro,Params,%session)
	q:((type="")||(SterPro="")) "{}"
	s (SterProID,SterName,NotUseFlag,SterWay,SterWayDesc,SterCode)="",Ret="N"
	s PJObj = ##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 q "{}"
	s pHospId=PJObj.%Get("BDPHospital")
	s gHospId=PJObj.%Get("gHospId")
	s pHospId=##class(web.CSSDHUI.HospMap).GetBDPHospId(pHospId,gHospId)
	s Rowid=""
	f  s Rowid=$o(^User.CSSDBaseCodeI("IndexCSSDDCCodeType",SterPro,type,Rowid)) q:+Rowid=0  d
	.s result =##class(web.CSSDHUI.HospMap).GetShowDataFlag("CSSD_BaseCode",Rowid,pHospId)
	.q:result="N"
	.&sql(select ID, CSSDDC_Code,CSSDDC_Name, CSSDDC_NotUseFlag,CSSDDC_SterWay,CSSDDC_SterWay->CSSDST_SterName as SterName into :SterProID, :SterCode, :SterName, :NotUseFlag,:SterWay,:SterWayDesc from CSSD_BaseCode where %ID=:Rowid and CSSDDC_NotUseFlag="Y" )
	.s:SQLCODE=0 Ret="Y"
	s SterProInfo = Ret_"^"_SterProID_"^"_SterName_"^"_NotUseFlag_"^"_SterWay_"^"_SterWayDesc_"^"_SterCode
	s SterProTitleStr="Ret^SterProID^SterName^NotUseFlag^SterWay^SterWayDesc^SterCode"
	s SterProStr=##class(web.CSSDHUI.Common.UtilCommon).GetJsonStr(SterProInfo,SterProTitleStr)
	q SterProStr
}

/// 获取灭菌架-6/清洗架-3
/// w ##class(web.CSSDHUI.Common.Dicts).GetSterCar("3","300001002","{""BDPHospital"":""2"",""gUserId"":""11889"",""gLocId"":""166"",""gGroupId"":""102"",""gHospId"":""2""}")
ClassMethod GetSterCar(type As %String, SterCar As %String, Params As %String = "")
{
	n (type,SterCar,Params,%session)
	q:((type="")||(SterCar="")) "{}"

	s (Code,Name,SterType,UseFlag,SterTypeDesc,DictId,SterCarInfo)=""
	s Ret="N"
	s PJObj = ##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	q:Sc'=0 "{}"

	s PHospId=PJObj.%Get("BDPHospital")
	s gHospId=PJObj.%Get("gHospId")
	s PHospId=##class(web.CSSDHUI.HospMap).GetBDPHospId(PHospId,gHospId)

	s PackageInfo=##class(web.CSSDHUI.Common.PackageInfoCommon).GetPkgInfoByCodeDict(SterCar)
	q:PackageInfo="" "{}"
	s DictId=$p(PackageInfo,"^",4)
	s AttributeId=$p(PackageInfo,"^",2)
	q:((AttributeId'=3)&&(AttributeId'=6))

	q:AttributeId'=type "{}"
	s result =##class(web.CSSDHUI.HospMap).GetShowDataFlag("CSSD_CodeDict",DictId,PHospId)
	q:result="N" "{}"

	s CodeDictObj=##class(User.CSSDCodeDict).%OpenId(DictId)
	i $IsObject(CodeDictObj) d
	.s UseFlag=CodeDictObj.CSSDCDPackDR.CSSDPNotUseFlag
	.s Code=CodeDictObj.CSSDCDCode
	.s Name=CodeDictObj.CSSDCDPackName
	.s SterType=CodeDictObj.CSSDCDPackDR.CSSDPSterTypeGetObjectId()
	.s SterTypeDesc=CodeDictObj.CSSDCDPackDR.CSSDPSterType.CSSDSTSterName
	.s Ret="Y"

	s SterCarInfo = Ret_"^"_Code_"^"_Name_"^"_UseFlag_"^"_SterType_"^"_SterTypeDesc_"^"_DictId
	s SterCarTitleStr="Ret^Code^Name^UseFlag^SterType^SterTypeDesc^DictId"
	s SterCarStr=##class(web.CSSDHUI.Common.UtilCommon).GetJsonStr(SterCarInfo,SterCarTitleStr)
	q SterCarStr
}

/// 获取人员信息所有科室
/// d ##class(web.CSSDHUI.Common.Dicts).GetPersonInfo("demo")
ClassMethod GetPersonInfo(UserCode As %String)
{
	n (UserCode)
	q:UserCode="" ""
	S rowId="",Name="",res="N"
	&sql(SELECT SSUSR_RowId, SSUSR_Name into :rowId , :Name FROM SS_User WHERE SSUSR_Initials=:UserCode)
	s:SQLCODE=0 res="Y"
	q res_"^"_rowId_"^"_Name
}

/// d ##class(%ResultSet).RunQuery("web.CSSDHUI.Common.Dicts","GetMachineNoComBo","washer","{""BDPHospital"":""3"",""TempType"":"""",""SupLocId"":""396"",""gUserId"":""13922"",""gLocId"":""396"",""gGroupId"":""102"",""gHospId"":""3""}")
Query GetMachineNoComBo(type As %String, Params As %String = "") As web.CSSDHUI.Query(ROWSPEC = "RowId:%Integer,Description,MachineNo,TempType") [ SqlProc ]
{
}

ClassMethod GetMachineNoComBoExecute(ByRef qHandle As %Binary, type As %String, Params As %String = "") As %Status
{
	n (qHandle,type,Params,%session)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	s PJObj = ##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 q $$$OK
	
	s pTempType=PJObj.%Get("TempType")
	s pHospId=PJObj.%Get("BDPHospital")
	s gHospId=PJObj.%Get("gHospId")
	s gLocId=PJObj.%Get("gLocId")
	s pSupLocId=PJObj.%Get("SupLocId")
	s pInManualFlag=PJObj.%Get("InManualFlag")
	s:pSupLocId="" pSupLocId=gLocId
	s pHospId=##class(web.CSSDHUI.HospMap).GetBDPHospId(pHospId,gHospId)
	
	i pInManualFlag="Y" d
	.s RowId="0"
	.s Description="手工"
	.s (MachineNo,TempType)=""
	.d OutPutGetMachineNoComBo
	
	s Result=##class(%Library.ResultSet).%New()
	s SqlStr = "SELECT ID,CSSDMC_Alias,CSSDMC_Num,CSSDMC_NotUseFlag,CSSDMC_TempType,CSSDMC_SupLoc_DR "
		_" FROM CSSD_MachineConfig WHERE CSSDMC_NotUseFlag='Y' and CSSDMC_MachineType='"_type_"'"
	d Result.RuntimeModeSet(0)
	d Result.Prepare(SqlStr)
	d Result.Execute()
	
	While(Result.Next())
	{
		s RowId = Result.Data("ID")
		s Description = Result.Data("CSSDMC_Alias")
		s MachineNo = Result.Data("CSSDMC_Num")
		s UseFlag = Result.Data("CSSDMC_NotUseFlag")
		s TempType=Result.Data("CSSDMC_TempType")		;清洗方式/灭菌方式
		s SupLocId = Result.Data("CSSDMC_SupLoc_DR")
		continue:SupLocId=""
		continue:(pSupLocId'="")&&(pSupLocId'=SupLocId)
		continue:UseFlag'="Y"
		continue:(type="sterilizer")&&(TempType="")		;灭菌器,灭菌方式是必须的
		continue:(pTempType'="")&&(TempType'="")&&(pTempType'=TempType)
		s result=##class(web.CSSDHUI.HospMap).GetShowDataFlag("CSSD_MachineConfig",RowId,pHospId)
		continue:result="N"
		d OutPutGetMachineNoComBo
	}
	d Result.Close()
	Quit $$$OK
	
OutPutGetMachineNoComBo
	s Data=$lb(RowId,Description,MachineNo,TempType)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// Description:获取灭菌器数据
/// Creator:	wangjiabin
/// CreatDate:	2022-03-10
/// Table:		CSSD_MachineConfig
/// Input:		
/// Output:		
/// d ##class(%ResultSet).RunQuery("web.CSSDHUI.Common.Dicts","GetSterMachine",
Query GetSterMachine(Params As %String) As web.CSSDHUI.Query(ROWSPEC = "RowId:%Integer,Description,MachineNo,SterWay,SterCarDr,SterCarName") [ SqlProc ]
{
}

ClassMethod GetSterMachineExecute(ByRef qHandle As %Binary, Params As %String) As %Status
{
	n (%session,qHandle,Params)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	
	s PJObj = ##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 q $$$OK
	
	s pTempType=PJObj.%Get("TempType")
	s pHospId=PJObj.%Get("BDPHospital")
	s gHospId=PJObj.%Get("gHospId")
	s pSupLocId=PJObj.%Get("SupLocId")
	s gLocId=PJObj.%Get("gLocId")
	s:pSupLocId="" pSupLocId=gLocId
	s pHospId=##class(web.CSSDHUI.HospMap).GetBDPHospId(pHospId,gHospId)
	s Result=##class(%Library.ResultSet).%New()
	s SqlStr = "SELECT ID,CSSDMC_Alias,CSSDMC_Num,CSSDMC_NotUseFlag,CSSDMC_TempType,CSSDMC_SterCar,CSSDMC_SupLoc_DR "
		_" FROM CSSD_MachineConfig WHERE CSSDMC_MachineType='sterilizer'"
	d Result.RuntimeModeSet(0)
	d Result.Prepare(SqlStr)
	d Result.Execute()
	While(Result.Next())
	{
		s RowId=Result.Data("ID")
		s Description=Result.Data("CSSDMC_Alias")
		s MachineNo=Result.Data("CSSDMC_Num")
		s UseFlag=Result.Data("CSSDMC_NotUseFlag")
		s SterWay=Result.Data("CSSDMC_TempType")		;灭菌方式
		s SterCarDr=Result.Data("CSSDMC_SterCar")
		s SupLocId=Result.Data("CSSDMC_SupLoc_DR")
		continue:SupLocId=""
		continue:(pSupLocId'="")&&(pSupLocId'=SupLocId)
		continue:UseFlag'="Y"
		continue:(SterWay="")			;灭菌器,灭菌方式是必须的
		continue:(pTempType'="")&&(pTempType'=SterWay)
		s result=##class(web.CSSDHUI.HospMap).GetShowDataFlag("CSSD_MachineConfig",RowId,pHospId)
		continue:result="N"
		s SterCarName=$s(SterCarDr'="":$lg(^User.CSSDCodeDictD(SterCarDr),6),1:"")
		d OutPutSterMachine
	}
	d Result.Close()
	Quit $$$OK
	
OutPutSterMachine
	s Data=$lb(RowId,Description,MachineNo,SterWay,SterCarDr,
		SterCarName)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// d ##class(%ResultSet).RunQuery("web.CSSDHUI.Common.Dicts","GetCTUom","{""BDPHospital"":""2"",""gUserId"":""11889"",""gLocId"":""166"",""gGroupId"":""102"",""gHospId"":""2""}")
Query GetCTUom(Params As %String) As web.CSSDHUI.Query(ROWSPEC = "RowId:%Integer,Description") [ SqlProc ]
{
}

ClassMethod GetCTUomExecute(ByRef qHandle As %Binary, Params As %String) As %Status
{
	n (qHandle,Params)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	s PJObj = ##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 q $$$OK
	s pHospId=PJObj.%Get("BDPHospital")
	s gHospId=PJObj.%Get("gHospId")
	s pHospId=##class(web.CSSDHUI.HospMap).GetBDPHospId(pHospId,gHospId)
	s Result=##class(%Library.ResultSet).%New()
	s Param="^^^"_gHospId
	s InitUom=##Class(web.CSSDHUI.Common.AppCommon).GetParamValue("CSSDPACKAGE","Uom",Param)
	s SqlStr = "select CTUOM_RowID AS RowId, CTUOM_DESC AS Description from CT_UOM order by CTUOM_RowID"
	d Result.RuntimeModeSet(0)
	d Result.Prepare(SqlStr)
	d Result.Execute()
	While(Result.Next())
	{
		s RowId = Result.Data("RowId")
		s result =##class(web.CSSDHUI.HospMap).GetShowDataFlag("CT_UOM",RowId,pHospId)
		continue:result="N"
		s Description = Result.Data("Description")
		continue:(InitUom'[Description)
		d OutPutUomRow
	}
	d Result.Close()
	Quit $$$OK
OutPutUomRow
	s Data=$lb(RowId,Description)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// 获取消毒包未关联的器械明细数据
/// d ##class(%ResultSet).RunQuery("web.CSSDHUI.Common.Dicts","GetPackageItem","","",)
Query GetPackageItem(ItemName As %String = "", CreateLocDr As %String = "", Others As %String) As web.CSSDHUI.Query(ROWSPEC = "RowId:%Integer,ItemDescription,ItemSpec") [ SqlProc ]
{
}

ClassMethod GetPackageItemExecute(ByRef qHandle As %Binary, ItemName As %String = "", CreateLocDr As %String = "", Others As %String) As %Status
{
	n (qHandle,ItemName,CreateLocDr,Others,%session)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	
	s PAlias=$$ALPHAUP^SSUTIL4(ItemName)
	s PJObj = ##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Others)
	i Sc'=0 q $$$OK
	s pHospId=PJObj.%Get("BDPHospital")
	s gHospId=PJObj.%Get("gHospId")
	s pHospId=##class(web.CSSDHUI.HospMap).GetBDPHospId(pHospId,gHospId)
	s Result=##class(%Library.ResultSet).%New()
	s SqlStr = "SELECT ID, CSSDI_Desc,CSSDI_Spec, CSSDI_Alias FROM CSSD_Item WHERE CSSDI_UseFlag='Y'"
	i CreateLocDr'="" s SqlStr=SqlStr_" and CSSDI_CreateLocDr="_CreateLocDr_""
	s SqlStr=SqlStr_" order by CSSDI_Desc"
	d Result.RuntimeModeSet(0)
	d Result.Prepare(SqlStr)
	d Result.Execute()
	While(Result.Next())
	{
		s RowId = Result.Data("ID")
		s result =##class(web.CSSDHUI.HospMap).GetShowDataFlag("CSSD_Item",RowId,pHospId)
		continue:result="N"
		s ItemSpec = Result.Data("CSSDI_Spec")
		s ItemDescription = Result.Data("CSSDI_Desc")
		s Alias=Result.Data("CSSDI_Alias")
		continue:(ItemName'="")&&((ItemDescription'[ItemName)&&(Alias'[PAlias))
		d OutPutPackageItemRow
	}
	d Result.Close()
	Quit $$$OK
OutPutPackageItemRow
	s Data=$lb(RowId,ItemDescription,ItemSpec)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// 获取清洗方式
/// d ##class(%ResultSet).RunQuery("web.CSSDHUI.Common.Dicts","GetCleanType")
Query GetCleanType(Params As %String = "") As web.CSSDHUI.Query(ROWSPEC = "RowId:%Integer,Description,Code,UseFlag,IsManualTemp") [ SqlProc ]
{
}

ClassMethod GetCleanTypeExecute(ByRef qHandle As %Binary, Params As %String = "") As %Status
{
	n (qHandle,Params,%session)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)

	s PJObj = ##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 q $$$OK
	s pHospId=PJObj.%Get("BDPHospital")
	s gHospId=PJObj.%Get("gHospId")
	s PIsManualFlag=PJObj.%Get("IsManual")	;机器设置页面 清洗机下拉框传入,过滤掉手工清洗的清洗方式
	s pHospId=##class(web.CSSDHUI.HospMap).GetBDPHospId(pHospId,gHospId)
	s Result=##class(%Library.ResultSet).%New()
	s SqlStr = "SELECT ID, CSSDCT_CleanMode,CSSDCT_CleanCode,CSSDCT_NotUseFlag,CSSDCT_IsManualTemp FROM CSSD_CleanType WHERE CSSDCT_NotUseFlag='Y'"
	d Result.RuntimeModeSet(0)
	d Result.Prepare(SqlStr)
	d Result.Execute()
	While(Result.Next())
	{
		s RowId = Result.Data("ID")
		s result =##class(web.CSSDHUI.HospMap).GetShowDataFlag("CSSD_CleanType",RowId,pHospId)
		continue:result="N"
		s Description = Result.Data("CSSDCT_CleanMode")
		s Code = Result.Data("CSSDCT_CleanCode")
		s UseFlag = Result.Data("CSSDCT_NotUseFlag")
		continue:UseFlag'="Y"
		s IsManualTemp = Result.Data("CSSDCT_IsManualTemp")
		continue:((PIsManualFlag'="")&&(PIsManualFlag=IsManualTemp))
		d OutPutCleanTypeRow
	}
	d Result.Close()
	Quit $$$OK
OutPutCleanTypeRow
	s Data=$lb(RowId,Description,Code,UseFlag,IsManualTemp)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// Descript:	科室
/// Creator:wxj
/// Date:2019-4-26
/// d ##class(%ResultSet).RunQuery("web.CSSDHUI.Common.Dicts","GetCTLoc",^templxt("Params"))
Query GetCTLoc(Params As %String) As web.CSSDHUI.Query(ROWSPEC = "RowId:%Integer,Description,ContactName,DefaultFlag") [ SqlProc ]
{
}

ClassMethod GetCTLocExecute(ByRef qHandle As %Binary, Params As %String) As %Status
{
	n (qHandle,Params,%session)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	s PJObj=##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 q $$$OK
	s gGroupId=PJObj.%Get("gGroupId")
	s gLocId=PJObj.%Get("gLocId")
	s gHospId=PJObj.%Get("gHospId") ;登陆医院ID
	s pHospId=PJObj.%Get("BDPHospital")
	s pHospId=##class(web.CSSDHUI.HospMap).GetBDPHospId(pHospId,gHospId)
	s pType=PJObj.%Get("Type")
	s pDesc=PJObj.%Get("Desc")
	s pLocId=PJObj.%Get("LocId")
	s gUserId=PJObj.%Get("gUserId")
	s gLocDesc=$s(gLocId'="":$p(^CTLOC(gLocId),"^",2),1:"")
	s pSupLocId=PJObj.%Get("SupLocId")	//科室类型绑定依据供应中心过滤
	s HospFlag=PJObj.%Get("HospFlag")	//""按参数配置,1取全部院区,2按pHospId
	
	s HospSr=pHospId
	s AppParam=gGroupId_"^"_gLocId_"^"_gUserId_"^"_pHospId
	s ShowAllHospital=##class(web.CSSDHUI.Common.AppCommon).GetParamValue("CSSDCOMMON","ShowAllHospital",AppParam)
	s IsSupLoc=##class(web.CSSDHUI.Common.AppCommon).GetParamValue("CSSDCOMMON","IsSupLoc",AppParam)
	
	i HospFlag="" d
	.i ShowAllHospital=1 d
	..s HospSr=##class(web.CSSDHUI.HospMap).GetGroupHospStr("CT_Loc",pHospId)
	.e  i ShowAllHospital=2 d
	..s HospSr=##class(web.CSSDHUI.HospMap).GetAllHospStr()
	e  i HospFlag=1 d
	.s HospSr=##class(web.CSSDHUI.HospMap).GetAllHospStr()
	e  i HospFlag=2 d
	.s HospSr=pHospId
	
	s:(pType="Login")&&(IsSupLoc="Y") pType="SupLoginLoc"
	s:pType="" pType="All"
	s pDesc=$$ALPHAUP^SSUTIL4(pDesc)
	s Date=+$h
	s pid=..NewPid()
	k ^TMPCSSD(pid)
	
	i pType="SupLoc" d			//供应中心
	.d GetSupLoc
	e  i pType="Login" d		//登录科室
	.d GetLoginLoc
	e  i pType="SupLoginLoc" d		//登录科室与供应中心交集
	.d GetSupLoginLoc
	e  i pType="RecLoc" d		//接收科室
	.d GetRecLoc
	e  i pType="All" d			//全部科室
	.d GetAllLoc
	
	i '$d(^TMPCSSD(pid))&&(pType="RecLoc") d	//接收科室为空时，取全部
	.d GetAllLoc
	
	s RowId=""
	f  s RowId=$o(^TMPCSSD(pid,RowId)) q:(RowId="")  d
	.s DefaultFlag=$p(^TMPCSSD(pid,RowId),"^",3)
	.s LocHospId=..sssHospId(RowId)
	.//s ShowDataFlag=##class(web.CSSDHUI.HospMap).GetShowDataFlag("CT_Loc",RowId,pHospId)
	.//continue:ShowDataFlag="N"
	.q:(pType'="SupLoc")&&(pType'="GetSupLoginLoc")&&(HospSr'="")&&((","_HospSr_",")'[(","_LocHospId_","))
	.s Description=$p(^CTLOC(RowId),"^",2)
	.s Description=..%FieldTranslate("User.CTLoc","CTLOCDesc",Description)
	.s FromDate=$p(^CTLOC(RowId),"^",24)
	.s ToDate=$p(^CTLOC(RowId),"^",25)
	.q:(ToDate'="")&&(Date>ToDate)
	.q:(FromDate'="")&&(Date<FromDate)
	.s ContactName=$p(^CTLOC(RowId),"^",43)
	.q:((pDesc'="")&&($$ALPHAUP^SSUTIL4(Description)'[pDesc)&&($$ALPHAUP^SSUTIL4(ContactName)'[pDesc))
	.d OutPutLocRow
	
	k ^TMPCSSD(pid)
	Quit $$$OK
OutPutLocRow
	s Data=$lb(RowId,Description,ContactName,DefaultFlag)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
	
GetSupLoc
	&sql(declare SupLocCursor cursor for
		select CSSDD_Loc_DR As RowId, CSSDD_Loc_DR->CTLOC_DESC As Description, CSSDD_Hosp_DR
		FROM CSSD_DeptCenter)
	&sql(open SupLocCursor)
	f  &sql(fetch SupLocCursor into :RowId,:Description,:Hosp) q:SQLCODE  d
	.q:gHospId'=Hosp
	.s DefaultFlag="N"
	.s ^TMPCSSD(pid,RowId)=RowId_"^"_Description_"^"_DefaultFlag
	&sql(close SupLocCursor)
	q
GetLoginLoc
	&sql(declare LoginCursor cursor for
		select SSUSR_DefaultDept_DR RowId,SSUSR_DefaultDept_DR->CTLoc_Desc Description 
		from SS_User where %id=:gUserId and SSUSR_Group=:gGroupId 
		union 
		select OTHLL_CTLOC_DR RowId,OTHLL_CTLOC_DR->CTLoc_Desc Description 
		from SS_UserOtherLogonLoc where OTHLL_ParRef=:gUserId and OTHLL_UserGroup_DR=:gGroupId 
		)
	&sql(open LoginCursor)
	f  &sql(fetch LoginCursor into :RowId,:Description) q:SQLCODE  d
	.s DefaultFlag="N"
	.s ^TMPCSSD(pid,RowId)=RowId_"^"_Description_"^"_DefaultFlag
	&sql(close LoginCursor)
	q
GetSupLoginLoc
	&sql(declare SupLoginCursor cursor for
		select SSUSR_DefaultDept_DR RowId,SSUSR_DefaultDept_DR->CTLoc_Desc Description 
		from SS_User where %id=:gUserId and SSUSR_Group=:gGroupId 
		union 
		select OTHLL_CTLOC_DR RowId,OTHLL_CTLOC_DR->CTLoc_Desc Description 
		from SS_UserOtherLogonLoc where OTHLL_ParRef=:gUserId and OTHLL_UserGroup_DR=:gGroupId 
		)
	&sql(open SupLoginCursor)
	f  &sql(fetch SupLoginCursor into :RowId,:Description) q:SQLCODE  d
	.s DefaultFlag="N"
	.s DeptCenterId=$o(^User.CSSDDeptCenterI("HospDept",gHospId,RowId,0))
	.q:DeptCenterId=""
	.s ^TMPCSSD(pid,RowId)=RowId_"^"_Description_"^"_DefaultFlag
	&sql(close SupLoginCursor)
	q
GetRecLoc
	&sql(declare RecLocCursor cursor for
		SELECT CSSDBL_LocDr RowId,CSSDBL_LocDr->CTLOC_Desc Description,isnull(CSSDBL_DefaultFlag,'N') DefaultFlag,CSSDBL_DeptCenterDr CenterLocId 
		FROM CSSD_BindLoc where CSSDBL_TypeCode=:pType and CSSDBL_UseFlag='Y')
	&sql(open RecLocCursor)
	f  &sql(fetch RecLocCursor into :RowId,:Description,:DefaultFlag,:CenterLocId) q:SQLCODE  d
	.q:(pSupLocId'="")&&(CenterLocId'="")&&(pSupLocId'=CenterLocId)
	.s ^TMPCSSD(pid,RowId)=RowId_"^"_Description_"^"_DefaultFlag
	&sql(close RecLocCursor)
	q
GetAllLoc
	s DefaultFlag="N"
	&sql(declare AllCursor cursor for
		SELECT CTLOC_ROWID RowId,CTLOC_DESC Description FROM CT_Loc)
	&sql(open AllCursor)
	f  &sql(fetch AllCursor into :RowId,:Description) q:SQLCODE  d
	.s ^TMPCSSD(pid,RowId)=RowId_"^"_Description_"^"_DefaultFlag
	&sql(close AllCursor)
	q
}

/// Descript:	人员
/// Creater:	wxj
/// CreateDate:	2019-04-26
/// d ##class(%ResultSet).RunQuery("web.CSSDHUI.Common.Dicts","GetUser")
Query GetUser(Params As %String) As web.CSSDHUI.Query(ROWSPEC = "RowId:%Integer,Description") [ SqlProc ]
{
}

ClassMethod GetUserExecute(ByRef qHandle As %Binary, Params As %String) As %Status
{
	n (qHandle,Params,%session)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	s PJObj=##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 q $$$OK
	s gHospId=PJObj.%Get("gHospId") ;登陆医院ID
	s pHospId=PJObj.%Get("BDPHospital") ;选择的医院ID
	s pShowAllHospFlag=PJObj.%Get("ShowAllHospFlag") ;范围取所有医院
	s pHospId=##class(web.CSSDHUI.HospMap).GetBDPHospId(pHospId,gHospId)
	s Date=+$h
	s Result=##class(%Library.ResultSet).%New()
	s SqlStr="SELECT SSUSR_RowId AS RowId, SSUSR_Name AS Description  FROM SS_User"
	d Result.RuntimeModeSet(0)
	d Result.Prepare(SqlStr)
	d Result.Execute()
	While(Result.Next())
	{
		s RowId = Result.Data("RowId")
		s ShowDataFlag=##class(web.CSSDHUI.HospMap).GetShowDataFlag("SS_User",RowId,pHospId,"","",pShowAllHospFlag)
		continue:ShowDataFlag="N"
		s Description = Result.Data("Description")
		s Initial=$p(^SSU("SSUSR",RowId),"^",1)
		s Description=Description_"["_Initial_"]"
		;s active = $p(^SSU("SSUSR",RowId),"^",19)
		;continue:active'="Y"
		s dateFrom = $p(^SSU("SSUSR",RowId),"^",96)
		s dateTo = $p(^SSU("SSUSR",RowId),"^",97)
		s date = +$h
		continue:((dateFrom'="")&&(date<dateFrom))
		continue:((dateTo'="")&&(date>dateTo))
		d OutPutUserRow
	}
	d Result.Close()
	Quit $$$OK
OutPutUserRow
	s Data=$lb(RowId,Description)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// Descript:	科室下人员
/// Creater:	wxj
/// CreateDate:	2019-04-26
/// input:  科室id
/// output: RowId,Description
/// d ##class(%ResultSet).RunQuery("web.CSSDHUI.Common.Dicts","GetLocUser",^tmpli("GetLocUser"))
Query GetDeptUser(Params As %String) As web.CSSDHUI.Query(ROWSPEC = "RowId:%Integer,Description") [ SqlProc ]
{
}

ClassMethod GetDeptUserExecute(ByRef qHandle As %Binary, Params As %String) As %Status
{
	n (qHandle,Params)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	s PJObj=##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 q $$$OK
	s pLocId=PJObj.%Get("LocDr")
	s gHospId=PJObj.%Get("gHospId") ;登陆医院ID
	s pHospId=PJObj.%Get("BDPHospital") ;选择的医院ID
	i pLocId="" d
	.s pLocId=PJObj.%Get("gLocId")
	s Filter=""
	s pHospId=##class(web.CSSDHUI.HospMap).GetBDPHospId(pHospId,gHospId)
	s Result=##class(%Library.ResultSet).%New()
	s SqlStr = "SELECT SSUSR_RowId AS RowId, SSUSR_Name AS Name FROM SS_User where SSUSR_DefaultDept_DR="_pLocId_"  and SSUSR_Name like '%"_Filter_"%'"
	s SqlStr1 = "select othll_parref as RowId,othll_parref->ssusr_name as Name From SS_UserOtherLogonLoc  where othll_ctloc_dr="_pLocId_" and othll_parref->ssusr_name like '%"_Filter_"%'"
	s SqlStr =SqlStr_" union "_SqlStr1 
	d Result.RuntimeModeSet(0)
	d Result.Prepare(SqlStr)
	d Result.Execute()
	While(Result.Next())
	{
		s RowId = Result.Data("RowId")
		s result =##class(web.CSSDHUI.HospMap).GetShowDataFlag("SS_User",RowId,pHospId)
		continue:result="N"
		s Description = Result.Data("Name")
		s Initial=$p(^SSU("SSUSR",RowId),"^",1)
		s dateFrom = $p(^SSU("SSUSR",RowId),"^",96)
		s dateTo = $p(^SSU("SSUSR",RowId),"^",97)
		s date = +$h
		continue:((dateFrom'="")&&(date<dateFrom))
		continue:((dateTo'="")&&(date>dateTo))
		d OutPutLocUserRow
	}
	d Result.Close()
	Quit $$$OK
OutPutLocUserRow
	s Data=$lb(RowId,Description)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// Creator:why
/// Date:2019-08-20
/// Description: codedict
/// Input:  StkGrpId
/// d ##class(%ResultSet).RunQuery("web.CSSDHUI.Common.Dicts","GetCodeDict","46")
Query GetCodeDict(PkgDr As %String) As web.CSSDHUI.Query(ROWSPEC = "RowId:%Integer,Description") [ SqlProc ]
{
}

ClassMethod GetCodeDictExecute(ByRef qHandle As %Binary, PkgDr As %String) As %Status
{
	n (qHandle,PkgDr,%session)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	s Result=##class(%Library.ResultSet).%New()
	s pHospId=##class(web.CSSDHUI.HospMap).GetBDPHospId("","")
	s SqlStr = "SELECT ID,CSSDCD_Code,CSSDCD_PackName FROM CSSD_CodeDict WHERE 1=1"
	i PkgDr'="" s SqlStr=SqlStr_" and CSSDCD_PackDR='"_PkgDr_"'"
	d Result.RuntimeModeSet(0)
	d Result.Prepare(SqlStr)
	d Result.Execute()
	While(Result.Next())
	{
		s ID = Result.Data("ID")
		s Code = Result.Data("CSSDCD_Code")
		s result =##class(web.CSSDHUI.HospMap).GetShowDataFlag("CSSD_CodeDict",ID,pHospId)
		continue:result="N"
		s Description = Result.Data("CSSDCD_PackName")
		d OutPutCodeDict
	}
	d Result.Close()
	Quit $$$OK
	
OutPutCodeDict
	s Data=$lb(Code,Code_" & "_Description)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// Creator:wb
/// Date:2020-4-21
/// Description: 获取楼号
/// LocId ：下收下送对应的供应室科室ID
/// d ##class(%ResultSet).RunQuery("web.CSSDHUI.Common.Dicts","GetFloorCode","")
Query GetFloorCode(LocId As %String = "") As web.CSSDHUI.Query(ROWSPEC = "RowId:%Integer,Description") [ SqlProc ]
{
}

ClassMethod GetFloorCodeExecute(ByRef qHandle As %Binary, LocId As %String = "") As %Status
{
	n (qHandle,LocId,%session)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	s Result=##class(%Library.ResultSet).%New()
	s pHospId=##class(web.CSSDHUI.HospMap).GetBDPHospId("","")
	s SqlStr = "SELECT ID,CSSDSRLM_FloorCode,CSSDSRLM_StockLOCDR FROM CSSD_SendRoadLineMain"
	d Result.RuntimeModeSet(0)
	d Result.Prepare(SqlStr)
	d Result.Execute()
	s Flag=""
	While(Result.Next())
	{
		s RowId = Result.Data("ID")
		s result =##class(web.CSSDHUI.HospMap).GetShowDataFlag("CSSD_SendRoadLineMain",RowId,pHospId)
		continue:result="N"
		s Description = Result.Data("CSSDSRLM_FloorCode")
		continue:(Flag=1)&&(Description=TmpFloorCode)
		s TmpFloorCode=Description,Flag=1
		s StockLocId = Result.Data("CSSDSRLM_StockLOCDR")
		continue:((LocId'="")&&(StockLocId'=LocId))
		d OutPutFloorCode
	}
	d Result.Close()
	Quit $$$OK
	
OutPutFloorCode
	s Data=$lb(RowId,Description)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// Description: 获取线路号
/// d ##class(%ResultSet).RunQuery("web.CSSDHUI.Common.Dicts","GetLine","{""SupLocId"":166}")
Query GetLine(Params As %String) As web.CSSDHUI.Query(ROWSPEC = "RowId:%Integer,Description") [ SqlProc ]
{
}

ClassMethod GetLineExecute(ByRef qHandle As %Binary, Params As %String) As %Status
{
	n (qHandle,Params,%session)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	
	s PJObj=##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 q $$$OK
	s SupLocId=PJObj.%Get("SupLocId")
	s gHospId=PJObj.%Get("gHospId")
	s pHospId=PJObj.%Get("BDPHospital") ;选择的医院ID
	s pHospId=##class(web.CSSDHUI.HospMap).GetBDPHospId(pHospId,gHospId)
	
	s Result=##class(%Library.ResultSet).%New()
	s SqlStr = "SELECT ID,CSSDSRLM_LineCode,CSSDSRLM_LineDesc FROM CSSD_SendRoadLineMain where 1=1 "
	i SupLocId'="" d
	.s SqlStr=SqlStr_" and CSSDSRLM_StockLOCDR='"_SupLocId_"'"
	d Result.RuntimeModeSet(0)
	d Result.Prepare(SqlStr)
	d Result.Execute()
	While(Result.Next())
	{
		s RowId = Result.Data("ID")
		s Description = Result.Data("CSSDSRLM_LineCode")
		s result=##class(web.CSSDHUI.HospMap).GetShowDataFlag("CSSD_SendRoadLineMain",RowId,pHospId)
		continue:result="N"
		d OutPutLineCode
	}
	d Result.Close()
	Quit $$$OK
	
OutPutLineCode
	s Data=$lb(RowId,Description)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// Descript:	召回原因维护
/// Creater:	why
/// CreateDate:	2020-07-09
/// d ##class(%ResultSet).RunQuery("web.CSSDHUI.Common.Dicts","GetRecallReason","")
Query GetRecallReason(Params As %String = "") As web.CSSDHUI.Query(ROWSPEC = "RowId:%Integer,Description") [ SqlProc ]
{
}

ClassMethod GetRecallReasonExecute(ByRef qHandle As %Binary, Params As %String = "") As %Status
{
	n (qHandle,Params,%session)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	s PJObj=##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 q $$$OK
	s gHospId=PJObj.%Get("gHospId") ;登陆医院ID
	s pHospId=PJObj.%Get("BDPHospital") ;选择的医院ID
	s NotUseFlag="Y"
	s Result=##class(%Library.ResultSet).%New()
	s pHospId=##class(web.CSSDHUI.HospMap).GetBDPHospId(pHospId,gHospId)
	s SqlStr = "SELECT CSSDRR_RecallRowid, CSSD_RecallCode, CSSD_RecallDesc, CSSD_RecallUseFlag "
			_"	FROM CSSD_RecallReason where CSSD_RecallUseFlag=:NotUseFlag"
	d Result.RuntimeModeSet(0)
	d Result.Prepare(SqlStr)
	d Result.Execute()
	While(Result.Next())
	{
		s RowId = Result.Data("CSSDRR_RecallRowid")
		s result =##class(web.CSSDHUI.HospMap).GetShowDataFlag("CSSD_RecallReason",RowId,pHospId)
		continue:result="N"
		s Description = Result.Data("CSSD_RecallDesc")
		d OutRecallReasonRow
	}
	d Result.Close()
	Quit $$$OK
OutRecallReasonRow
	s Data=$lb(RowId,Description)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// Creator:ban
/// CreatDate:2020.1.9
/// Description:获取供应中心
/// Table:CSSD_DeptCenter
/// Input:
/// Output:
/// Return:
/// w ##Class(web.CSSDHUI.Common.Dicts).GetDeptCenter("{""Type"":""Login"",""gUserId"":""11889"",""gLocId"":""144"",""gGroupId"":""102"",""gHospId"":""2""}")
ClassMethod GetDeptCenter(Params As %String)
{
	n (Params)
	s PJObj=##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	q:Sc'=0 "{}"
	
	s DeptCenterFlag="N"
	s gLocId=PJObj.%Get("gLocId")
	s DeptCenterId=$o(^User.CSSDDeptCenterI("CSSDDLocIndex",gLocId,""))
	s:DeptCenterId'="" DeptCenterFlag="Y"
	
	s DeptCenterData = DeptCenterFlag
	s DeptCenterTitleStr="DeptCenterFlag"
	s DeptCenterStr=##class(web.CSSDHUI.Common.UtilCommon).GetJsonStr(DeptCenterData,DeptCenterTitleStr)
	q DeptCenterStr
}

/// Descript:	消毒人员获取
/// Creater:	ban
/// CreateDate:	2021-03-03
/// d ##class(%ResultSet).RunQuery("web.CSSDHUI.Common.Dicts","GetAllUser")
Query GetAllUser(Params As %String) As web.CSSDHUI.Query(ROWSPEC = "RowId:%Integer,Code,Description") [ SqlProc ]
{
}

ClassMethod GetAllUserExecute(ByRef qHandle As %Binary, Params As %String) As %Status
{
	n (qHandle,Params,%session)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	s PJObj=##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 q $$$OK
	s gHospId=PJObj.%Get("gHospId") ;登陆医院ID
	s pHospId=PJObj.%Get("BDPHospital") ;选择的医院ID
	s gLocId=PJObj.%Get("gLocId")
	s LocId=PJObj.%Get("LocId")
	s pHospId=##class(web.CSSDHUI.HospMap).GetBDPHospId(pHospId,gHospId)
	s:LocId'="" gLocId=LocId
	s Result=##class(%Library.ResultSet).%New()
	s SqlStr = "SELECT SSUSR_RowId as RowId,SSUSR_Name as Name FROM SS_User WHERE SSUSR_DefaultDept_DR="_gLocId
	s SqlStr1 = "select othll_parref as RowId,othll_parref->ssusr_name as Name From SS_UserOtherLogonLoc  where othll_ctloc_dr="_gLocId
	s SqlStr =SqlStr_" union "_SqlStr1
	d Result.RuntimeModeSet(0)
	d Result.Prepare(SqlStr)
	d Result.Execute()
	While(Result.Next())
	{
		s RowId = Result.Data("RowId")
		s Active= $p(^SSU("SSUSR",RowId),"^",19)
		continue:Active'="Y"
		s result =##class(web.CSSDHUI.HospMap).GetShowDataFlag("SS_User",RowId,pHospId)
		continue:result="N"
		s Code = $p(^SSU("SSUSR",RowId),"^",1)
		s Description = Result.Data("Name")
		s Description = ..%FieldTranslate("User.SSUser","SSUSRName",Description)
		d OutUserRow
	}
	d Result.Close()
	Quit $$$OK
OutUserRow
	s Data=$lb(RowId,Code,Description)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// Creator:ban
/// CreatDate:2021.3.9
/// Description:按照人员工号，获取人员信息
/// Table:SS_User
/// Input: cleanCode:页面输入的清洗人号
/// Output:
/// Return:
/// w ##Class(web.CSSDHUI.Common.Dicts).GetCleanUser("demo")
ClassMethod GetUserByCode(userCode As %String, gLocId As %String)
{
	n (userCode,gLocId)
	s ret=""
	&sql(SELECT SSUSR_RowId||'^'||SSUSR_Name into:ret FROM SS_User WHERE SSUSR_Initials=:userCode and SSUSR_DefaultDept_DR=:gLocId)
	q ret
}

/// Creator:why
/// CreatDate:2021.8.26
/// Description:按照人员工号，获取人员信息
/// Table:SS_User
/// Input: cleanCode:页面输入的清洗人号
/// Output:
/// Return:
/// w ##Class(web.CSSDHUI.Common.Dicts).GetUserByCodeJson("demo","{""Type"":""All"",""gUserId"":""13922"",""gLocId"":""166"",""gGroupId"":""294"",""gHospId"":""2""}")
ClassMethod GetUserByCodeJson(userCode As %String, Params As %String)
{
	n (userCode,Params)
	s PJObj = ##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 q ""
	s pHospId=PJObj.%Get("BDPHospital")
	s gHospId=PJObj.%Get("gHospId")
	s gLocId=PJObj.%Get("gLocId")
	s Type=PJObj.%Get("Type")
	s pShowAllHospFlag=PJObj.%Get("ShowAllHospFlag") ;范围取所有医院
	s pHospId=##class(web.CSSDHUI.HospMap).GetBDPHospId(pHospId,gHospId)
	s Result=##class(%Library.ResultSet).%New()
	d Result.RuntimeModeSet(0)
	i Type="ALL" d
	.s SqlStr="SELECT SSUSR_RowId AS RowId, SSUSR_Name AS Description  FROM SS_User where SSUSR_Initials=:userCode"
	e  d
	.s SqlStr="SELECT SSUSR_RowId AS RowId, SSUSR_Name AS Description  FROM SS_User where SSUSR_Initials=:userCode and SSUSR_DefaultDept_DR=:gLocId"
	.s SqlStr1 = "select othll_parref as RowId,othll_parref->ssusr_name as Description From SS_UserOtherLogonLoc  where othll_parref->SSUSR_Initials= '"_userCode_"' and othll_ctloc_dr="_gLocId
	.s SqlStr =SqlStr_" union "_SqlStr1
	d Result.Prepare(SqlStr)
	d Result.Execute()
	s (RowId,Description)=""
	While(Result.Next())
	{
		s RowId = Result.Data("RowId")
		s ShowDataFlag=##class(web.CSSDHUI.HospMap).GetShowDataFlag("SS_User",RowId,pHospId,"","",pShowAllHospFlag)
		continue:ShowDataFlag'="Y"
		s Description = Result.Data("Description")
	}
	d Result.Close()
	s ret = RowId_"^"_Description
	s CleanUserTitleStr="RowId^Description"
	s CleanUserStr=##class(web.CSSDHUI.Common.UtilCommon).GetJsonStr(ret,CleanUserTitleStr)
	q CleanUserStr
}

/// Descript:	获取全部包装材料字典
/// Creater:	ban
/// CreateDate:	2021-03-11
/// d ##class(%ResultSet).RunQuery("web.CSSDHUI.Common.Dicts","GetMaterials")
Query GetMaterials(Params As %String = "") As web.CSSDHUI.Query(ROWSPEC = "RowId:%Integer,Description,Length") [ SqlProc ]
{
}

ClassMethod GetMaterialsExecute(ByRef qHandle As %Binary, Params As %String = "") As %Status
{
	n (qHandle,Params,%session)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	
	s PJObj = ##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 q $$$OK
	s pHospId=PJObj.%Get("BDPHospital")
	s gHospId=PJObj.%Get("gHospId")
	s pHospId=##class(web.CSSDHUI.HospMap).GetBDPHospId(pHospId,gHospId)
	s IsUsed="Y"
	s Result=##class(%Library.ResultSet).%New()
	s SqlStr = "SELECT ID, CSSDM_Desc, CSSDM_IsUsed,CSSDM_ExpLength FROM CSSD_Material where CSSDM_IsUsed=:IsUsed "
	d Result.RuntimeModeSet(0)
	d Result.Prepare(SqlStr)
	d Result.Execute()
	While(Result.Next())
	{
		s RowId = Result.Data("ID")
		s result =##class(web.CSSDHUI.HospMap).GetShowDataFlag("CSSD_Material",RowId,pHospId)
		continue:result="N"
		s Description = Result.Data("CSSDM_Desc")
		s Length = Result.Data("CSSDM_ExpLength")
		d OutMaterialRow
	}
	d Result.Close()
	Quit $$$OK
OutMaterialRow
	s Data=$lb(RowId,Description,Length)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// Descript:	获取消毒包已绑定的包装材料字典
/// Creater:	ban
/// CreateDate:	2021-03-11
/// d ##class(%ResultSet).RunQuery("web.CSSDHUI.Common.Dicts","GetBindMaterials","")
Query GetBindMaterials(packageDr As %String = "") As web.CSSDHUI.Query(ROWSPEC = "RowId:%Integer,Description") [ SqlProc ]
{
}

ClassMethod GetBindMaterialsExecute(ByRef qHandle As %Binary, packageDr As %String = "") As %Status
{
	n (qHandle,packageDr,%session)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	
	q:packageDr="" $$$OK
	s pHospId=##class(web.CSSDHUI.HospMap).GetBDPHospId("","")
	s Result=##class(%Library.ResultSet).%New()
	s SqlStr = "SELECT CSSDEX_Material_DR, CSSDEX_Material_DR->CSSDM_Desc as MaterialDesc FROM CSSD_Expire WHERE 1=1 "
	i packageDr'="" s SqlStr=SqlStr_" and CSSDEX_Package_DR='"_packageDr_"'"
	d Result.RuntimeModeSet(0)
	d Result.Prepare(SqlStr)
	d Result.Execute()
	While(Result.Next())
	{
		s RowId=Result.Data("CSSDEX_Material_DR")
		s Description=Result.Data("MaterialDesc")
		s result=##class(web.CSSDHUI.HospMap).GetShowDataFlag("CSSD_Material",RowId,pHospId)
		continue:result="N"
		s Description=..%FieldTranslate("User.CSSDMaterial","CSSDMDesc",Description)
		d OutBindMaterialRow
	}
	d Result.Close()
	Quit $$$OK
OutBindMaterialRow
	s Data=$lb(RowId,Description)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// d ##class(%ResultSet).RunQuery("web.CSSDHUI.Common.Dicts","GetSterCleanType","{""BDPHospital"":""2"",""gUserId"":""6461"",""gLocId"":""382"",""gGroupId"":""274"",""gHospId"":""2""}")
Query GetSterCleanType(Params As %String = "", ModeType As %String = "") As web.CSSDHUI.Query(ROWSPEC = "RowId:%Integer,Description") [ SqlProc ]
{
}

ClassMethod GetSterCleanTypeExecute(ByRef qHandle As %Binary, Params As %String = "", ModeType As %String = "") As %Status
{
	n (qHandle,Params,ModeType,%session)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	s PJObj = ##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 q $$$OK
	s pHospId=PJObj.%Get("BDPHospital")
	s gHospId=PJObj.%Get("gHospId")
	s pHospId=##class(web.CSSDHUI.HospMap).GetBDPHospId(pHospId,gHospId)
	s Result=##class(%Library.ResultSet).%New()
	s SqlStr = "SELECT ID AS RowId, CSSDST_SterName AS Name ,'CSSD_SterType' AS Type FROM CSSD_SterType WHERE CSSDST_NotUseFlag='Y' AND CSSDST_IsSter='Y' UNION SELECT ID AS RowId, CSSDCT_CleanMode AS Name,'CSSD_CleanType' AS Type FROM CSSD_CleanType  WHERE CSSDCT_NotUseFlag='Y' "
	d Result.RuntimeModeSet(0)
	d Result.Prepare(SqlStr)
	d Result.Execute()
	While(Result.Next())
	{
		s RowId = Result.Data("RowId")
		s Type = Result.Data("Type")
		continue:(ModeType'="")&&(ModeType'=Type)
		s result =##class(web.CSSDHUI.HospMap).GetShowDataFlag(Type,RowId,pHospId)
		continue:result="N"
		s Description = Result.Data("Name")
		i Type="CSSD_SterType" s RowId=RowId_"^S"
		e  d  s RowId=RowId_"^C"
		d OutPutSterCleanType
	}
	d Result.Close()
	Quit $$$OK
	
OutPutSterCleanType
	s Data=$lb(RowId,Description)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// Creator:ban
/// Date:2021-12-01
/// Description: 消毒包规格
/// Input: 
/// d ##class(%ResultSet).RunQuery("web.CSSDHUI.Common.Dicts","GetPackageSpec")
Query GetPackageSpec(Params As %String = "") As web.CSSDHUI.Query(ROWSPEC = "RowId:%Integer,Description") [ SqlProc ]
{
}

ClassMethod GetPackageSpecExecute(ByRef qHandle As %Binary, Params As %String = "") As %Status
{
	n (qHandle,Params,%session)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	s PJObj = ##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 q $$$OK
	s pHospId=PJObj.%Get("BDPHospital")
	s gHospId=PJObj.%Get("gHospId")
	s pHospId=##class(web.CSSDHUI.HospMap).GetBDPHospId(pHospId,gHospId)
	s Result=##class(%Library.ResultSet).%New()
	s SqlStr = "SELECT ID,PS_SpecDesc FROM CT_STER_CSSD.PackageSpec where PS_SpecUseFlag='Y' order by ID"
	d Result.RuntimeModeSet(0)
	d Result.Prepare(SqlStr)
	d Result.Execute()
	While(Result.Next())
	{
		s RowId = Result.Data("ID")
		s result =##class(web.CSSDHUI.HospMap).GetShowDataFlag("CT_STER_CSSD.PackageSpec",RowId,pHospId)
		continue:result="N"
		s Description = Result.Data("PS_SpecDesc")
		d OutPutPackageSpec
	}
	d Result.Close()
	Quit $$$OK
	
OutPutPackageSpec
	s Data=$lb(RowId,Description)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// Creator:ban
/// Date:2020-4-18
/// Description: 清洗程序、灭菌程序公用字典
/// Input:  
/// w ##class(%ResultSet).RunQuery("web.CSSDHUI.Common.Dicts","GetProCom","2001")
Query GetProCom(type As %String, Params As %String = "") As web.CSSDHUI.Query(ROWSPEC = "RowId:%Integer,Code,Description,SterWay,SterName,NotUseFlag") [ SqlProc ]
{
}

ClassMethod GetProComExecute(ByRef qHandle As %Binary, type As %String, Params As %String = "") As %Status
{
	n (qHandle,type,Params)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	s PJObj = ##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 q $$$OK
	s pHospId=PJObj.%Get("BDPHospital")
	s gHospId=PJObj.%Get("gHospId")
	s SterWay=PJObj.%Get("SterWay")
	s pHospId=##class(web.CSSDHUI.HospMap).GetBDPHospId(pHospId,gHospId)
	s Result=##class(%Library.ResultSet).%New()
	d Result.RuntimeModeSet(0)
	s SqlStr = "select ID,CSSDDC_Code,CSSDDC_Name,CSSDDC_NotUseFlag,CSSDDC_SterWay,CSSDDC_SterWay->CSSDST_SterName as SterName from CSSD_BaseCode where CSSDDC_CodeType='"_type_"' and CSSDDC_NotUseFlag='Y' "
	d Result.Prepare(SqlStr)
	d Result.Execute()
	While(Result.Next())
	{
		s RowId = Result.Data("ID")
		s result =##class(web.CSSDHUI.HospMap).GetShowDataFlag("CSSD_BaseCode",RowId,pHospId)
		continue:result="N"
		s Code = Result.Data("CSSDDC_Code")
		s Description = Result.Data("CSSDDC_Name")
		s ProSterWay = Result.Data("CSSDDC_SterWay")
		continue:((SterWay'="")&&(SterWay'=ProSterWay))
		s ProSterName = Result.Data("SterName")
		s NotUseFlag = Result.Data("CSSDDC_NotUseFlag")
		d OutPutProCom
	}
	d Result.Close()
	Quit $$$OK
	
OutPutProCom
	s Data=$lb(RowId,Code,Description,ProSterWay,ProSterName,NotUseFlag)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// Descript:	安全组
/// Creater:	litongxun
/// CreateDate:	2022-03-02
/// d ##class(%ResultSet).RunQuery("web.CSSDHUI.Common.Dicts","GetGroup",""{""ShowAllHospFlag"":""Y"",""gUserId"":""6423"",""gLocId"":""326"",""gGroupId"":""277"",""gHospId"":""2""}"")
Query GetGroup(Params = "") As web.CSSDHUI.Query(ROWSPEC = "RowId:%Integer,Description") [ SqlProc ]
{
}

ClassMethod GetGroupExecute(ByRef qHandle As %Binary, Params = "") As %Status
{
	n (qHandle,Params,%session)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	
	s PJobj=##class(web.CSSDHUI.Common.FromJson).%New()
	d PJobj.%FromJSON(Params)
	s gHospId=PJobj.%Get("gHospId") ;登陆医院ID
	s pHospId=PJobj.%Get("BDPHospital") ;选择的医院ID
	s pShowAllHospFlag=PJobj.%Get("ShowAllHospFlag") ;范围取所有医院
	s pHospId=##class(web.CSSDHUI.HospMap).GetBDPHospId(pHospId,gHospId)
	s Result=##class(%Library.ResultSet).%New()
	d Result.RuntimeModeSet(0)
	s SqlStr = "SELECT SSGRP_RowId AS RowId, SSGRP_Desc AS Description FROM SS_Group"
	d Result.Prepare(SqlStr)
	d Result.Execute()
	While(Result.Next())
	{
		s RowId = Result.Data("RowId")
		s ShowDataFlag=##class(web.CSSDHUI.HospMap).GetShowDataFlag("SS_Group",RowId,pHospId,"","",pShowAllHospFlag)
		continue:ShowDataFlag'="Y"
		s Description = Result.Data("Description")
		d OutPutRowGroup
	}
	d Result.Close()
	Quit $$$OK
OutPutRowGroup
	s Data=$lb(RowId,Description)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// Descript:	医院
/// Creater:	litongxun
/// CreateDate:	2022-03-02
Query GetHosp() As web.CSSDHUI.Query(ROWSPEC = "RowId:%Integer,Description") [ SqlProc ]
{
}

ClassMethod GetHospExecute(ByRef qHandle As %Binary) As %Status
{
	n (qHandle)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	s Result=##class(%Library.ResultSet).%New()
	d Result.RuntimeModeSet(0)
	s SqlStr = "select HOSP_RowId as RowId, HOSP_Desc as Description ,HOSP_DateTo , HOSP_DateFrom from CT_Hospital"
	d Result.Prepare(SqlStr)
	d Result.Execute()
	While(Result.Next())
	{
		s RowId = Result.Data("RowId")
		s Description = Result.Data("Description")
		s dateFrom = Result.Data("HOSP_DateFrom")
		s dateTo = Result.Data("HOSP_DateTo")
		s date =+$h
		continue:(dateFrom'="")&&(date<dateFrom)
		continue:(dateTo'="")&&(date>dateTo)
		d OutPutHospRow
	}
	d Result.Close()
	Quit $$$OK
OutPutHospRow
	s Data=$lb(RowId,Description)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// Descript:	打印规则
/// CreateDate:	2022-3-7
/// d ##class(%ResultSet).RunQuery("web.CSSDHUI.Common.Dicts","GetPrintRules")
Query GetPrintRules() As web.CSSDHUI.Query(ROWSPEC = "RowId:%Integer,Code,Description") [ SqlProc ]
{
}

ClassMethod GetPrintRulesExecute(ByRef qHandle As %Binary) As %Status
{
	n (qHandle)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	 
	s Result=##class(%Library.ResultSet).%New()
	d Result.RuntimeModeSet(0)
	s SqlStr = "select ID, PR_Code AS Code, PR_Desc AS Description from CT_STER_CSSD.PrintRules"
	d Result.Prepare(SqlStr)
	d Result.Execute()
	While(Result.Next())
	{
		s RowId = Result.Data("ID")
		s Code = Result.Data("Code")
		s Description = Result.Data("Description")
		d OutPutPrintRulesRow
	}
	d Result.Close()
	Quit $$$OK
OutPutPrintRulesRow
	s Data=$lb(RowId,Code,Description)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

}
