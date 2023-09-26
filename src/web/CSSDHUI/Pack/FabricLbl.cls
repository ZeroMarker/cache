Import SQLUser

Class web.CSSDHUI.Pack.FabricLbl Extends (%RegisteredObject, web.CSSDHUI.CSSDType) [ Not ProcedureBlock ]
{

Parameter AppName [ Final ] = "CSSDPACK";

///  Creator:why
///  CreatDate:2019.08.12
///  Description:加载非循环包列表
///  Table:CSSD_PackagePack,CSSD_Trans
///  Input:CSSD_PackagePack表的id组成的字符串
///  Output:
///  Return:
/// d ##Class(%ResultSet).RunQuery("web.CSSDHUI.Pack.FabricLbl","QueryFabricPkgs",^tmpbin(20))
Query QueryFabricPkgs(Params As %String) As web.CSSDHUI.Query(ROWSPEC = "Label,PkgDesc,PackId,PackUserId,PackUserName,PackChkUserId,PackChkUserName,ExpDate,SterDate,ToLocId,ToLocDesc,PackerId,PackerName,MaterialId,MaterialDesc,SterMachineDesc,HeatNo,PkgId,Remark,SterUserName,Status,StatusDesc") [ SqlProc ]
{
}

ClassMethod QueryFabricPkgsExecute(ByRef qHandle As %Binary, Params As %String) As %Status
{
	n (qHandle,Params)
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1

	s PJObj=##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	q:Sc'=0 $$$OK

	s PRowIdStr=PJObj.%Get("RowIdStr")
	s gLocId=PJObj.%Get("gLocId")
	s PPkgId=PJObj.%Get("Pkg")
	s PStartDate=PJObj.%Get("StartDate")
	s PEndDate=PJObj.%Get("EndDate")
	s PToLocId=PJObj.%Get("ToLoc")
	s PPackChkUserId=PJObj.%Get("PackChkUser")
	s PPackUserId=PJObj.%Get("PackUserId")
	s PPacker=PJObj.%Get("Packer")
	q:((PStartDate="")||(PEndDate=""))&&(PRowIdStr="") $$$OK

	s StartDate=..DH2L(PStartDate)
	s EndDate=..DH2L(PEndDate)
	
	s sql="select CSSDT_Pack_DR AS PackId,CSSDT_Pack_DR->CSSDPP_Package_DR as PkgId,CSSDT_Pack_DR->CSSDPP_Package_DR->cssdp_desc as PkgDesc, "
		_" CSSDT_Pack_DR->CSSDPP_Label AS Label,CSSDT_Pack_DR->CSSDPP_AckUser_DR AS PackChkUserId, CSSDT_Pack_DR->CSSDPP_User_DR AS PackUserId,CSSDT_ExpDate AS ExpDate, "
		_" CSSDT_Pack_DR->CSSDPP_PackLocDr as ToLocId,CSSDT_Pack_DR->cssdpp_ackdate as SterDate,CSSDT_Pack_DR->CSSDPP_PackUser_DR AS PackerId,"
		_" CSSDT_Pack_DR->CSSDPP_Material_DR as MaterialId, CSSDT_Pack_DR->CSSDPP_Material_DR->CSSDM_Desc as MaterialDesc,"
		_" CSSDT_Pack_DR->CSSDPP_Machine_DR->CSSDMC_Alias as SterMachineDesc, CSSDT_Pack_DR->CSSDPP_HeatNo as HeatNo,CSSDT_Pack_DR->CSSDPP_Remark as Remark, "
		_" CSSDT_Pack_DR->CSSDPP_SterUser_DR as SterUserId,CSSDT_Status as Status "
		_" from cssd_trans "
	i PRowIdStr'="" d
	.s sql=sql_" where CSSDT_Pack_DR in ("_PRowIdStr_")"
	e  d
	.s sql=sql_" where CSSDT_Pack_DR->cssdpp_ackdate>='"_StartDate_"' and CSSDT_Pack_DR->cssdpp_ackdate<='"_EndDate_"' and CSSDT_Pack_DR->CSSDPP_Package_DR->cssdp_packtypedetail=7 and CSSDT_Pack_DR->CSSDPP_Loc_DR='"_gLocId_"' and CSSDT_Pack_DR->CSSDPP_CallBackDetailDr IS NULL"
	.i PPkgId'="" s sql=sql_" and CSSDT_Pack_DR->CSSDPP_Package_DR="_PPkgId
	.i PToLocId'="" s sql=sql_" and CSSDT_Pack_DR->CSSDPP_PackLocDr="_PToLocId
	s result=##class(%Library.ResultSet).%New()
	d result.RuntimeModeSet(0)
	d result.Prepare(sql)
	d result.Execute()
	While(result.Next())
	{
		s PackId=result.Data("PackId")
		s PkgDesc=result.Data("PkgDesc")
		s Label=result.Data("Label")
		s PkgId=result.Data("PkgId")
		s PackChkUserId=result.Data("PackChkUserId")
		s PackUserId=result.Data("PackUserId")
		s PackerId=result.Data("PackerId")
		s SterDate=result.Data("SterDate")
		s ExpDate=result.Data("ExpDate")
		s ToLocId=result.Data("ToLocId")
		s MaterialId=result.Data("MaterialId")
		s MaterialDesc=result.Data("MaterialDesc")
		s SterMachineDesc=result.Data("SterMachineDesc")
		s HeatNo=result.Data("HeatNo")
		s Remark=result.Data("Remark")
		s SterUserId=result.Data("SterUserId")
		s Status=result.Data("Status")
		s StatusDesc=##Class(web.CSSDHUI.Common.PackageInfoCommon).GetStatusChinese(Status)
		continue:(PRowIdStr="")&&(PPackChkUserId'="")&(PPackChkUserId'=PackChkUserId)
		continue:(PRowIdStr="")&&(PPackUserId'="")&(PPackUserId'=PackUserId)

		s PackUserName=..sssUserName(PackUserId)
		s PackChkUserName=..sssUserName(PackChkUserId)
		s PackerName=..sssUserName(PackerId)
		s SterUserName=..sssUserName(SterUserId)
		s SterDate=..DL2H(SterDate)
		s ExpDate=..DL2H(ExpDate)
		s ToLocDesc=..sssLocDesc(ToLocId)

		d OutputRowFabric
	}
	d result.Close()
	q $$$OK
OutputRowFabric
	s Data=$lb(Label,PkgDesc,PackId,PackUserId,PackUserName,
		PackChkUserId,PackChkUserName,ExpDate,SterDate,ToLocId,
		ToLocDesc,PackerId,PackerName,MaterialId,MaterialDesc,
		SterMachineDesc,HeatNo,PkgId,Remark,SterUserName,Status,StatusDesc)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// 获取普通循环包标签,PkgCode 为cssd_package 中的代码
/// w ##Class(web.CSSDHUI.Pack.FabricLbl).GetFabricLabels(5172,7)
/// CreateQty 值要
ClassMethod GetFabricLabels(PkgCode As %String, CreateQty As %String) As %String
{
	n (PkgCode,CreateQty)
	s PkgCode =$tr($j(PkgCode,4)," ","0")
	s Date=$zd(+$h,8)
	s pre=PkgCode_Date
	s maxNo=""
	&sql(Select Max(CSSDPP_Label) into :maxNo From CSSD_PackagePack
	WHERE CSSDPP_Label %STARTSWITH :pre)
	s prtTimes= +$e(maxNo,$l(maxNo)-4,$l(maxNo))	;取后五位
	s labels=""
	f i=1:1:CreateQty d
	.s prtTimes=prtTimes+1
	.s label= pre_$tr($j(prtTimes,5)," ","0")
	.i labels="" d
	..s labels=label
	.e  d
	..s labels=labels_"^"_label
	q labels
}

///  Creator:why
///  CreatDate:2019.08.12
///  Description:生成非循环包
///  Table:CSSD_PackagePack,CSSD_Trans
///  Input:表格json
///  Output:
///  Return:
/// w ##Class(web.CSSDHUI.Pack.FabricLbl).jsGenFabricPkgs
ClassMethod jsGenFabricPkgs(Params As %String) As %String
{
	n (Params)
	s $ZT=..sssError()
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	ts
	s RtnObj=..GenFabricPkgs(Params)
	i RtnObj.success<0 tro  q RtnObj.Json()
	tc
	q RtnObj.Json()
}

///  Creator:why
///  CreatDate:2019.08.12
///  Description:生成非循环包
///  Table:CSSD_PackagePack,CSSD_Trans
///  Input:表格json
///  Output:
///  Return:
/// w ##Class(web.CSSDHUI.Pack.FabricLbl).GenFabricPkgs("{""Pkg"":""1"",""gUserId"":""11354"",""gLocId"":""316"",""gGroupId"":""103"",""gHospId"":""2"",""Material"":"""",""ToLoc"":""1"",""PackChkUser"":""李丽"",""PackUserId"":""沙桐"",""Packer"":""李丽"",""CreateQty"":""2"",""PackChkUser"":""10867"",""PackUser"":""11354"",""cleanStrov"":"""",""Iscmt"":"""",""Packer"":""10867"",""isPackUserValue"":"""",""StartDate"":""2021-03-16""}")
ClassMethod GenFabricPkgs(Params As %String) As %String
{
	n (Params)
	s MethodName=$ClassName()_".GenFabricPkgs"
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	s PJObj=##class(web.CSSDHUI.Common.FromJson).%New()
	q:(Params="") RtnObj.Err(-1,"","入参不能为空!","",0)

	s Sc=PJObj.%FromJSON(Params)
	q:(Sc'=0) RtnObj.Err(-1,"","入参解析失败:"_MethodName,"",0)

	s gUserId=PJObj.%Get("gUserId")
	s gHospId=PJObj.%Get("gHospId")
	s gGroupId=PJObj.%Get("gGroupId")
	s gLocId=PJObj.%Get("gLocId")
	s PPkgId=PJObj.%Get("Pkg")
	s PPackUserId=PJObj.%Get("PackUser")
	s PPackChkUserId=PJObj.%Get("PackChkUser")
	s PPackerId=PJObj.%Get("Packer")
	s PSterDate=PJObj.%Get("SterDate")
	s:PSterDate'="" PSterDate=..DH2L(PSterDate)
	s:PSterDate="" PSterDate=+$H
	s PCreateQty=PJObj.%Get("CreateQty")
	s PToLocId=PJObj.%Get("ToLoc")
	s PMaterialId=PJObj.%Get("Material")
	s PSterMachineId=PJObj.%Get("SterMachine")
	s PHeatNo=PJObj.%Get("HeatNo")
	s PSterUserId=PJObj.%Get("SterUser")

	s Param=gGroupId_"^"_gLocId_"^"_gUserId_"^"_gHospId
	s AppName=..%GetParameter("AppName")
	s IsExpDateInCurDay=##class(web.CSSDHUI.Common.AppCommon).GetParamValue(AppName,"IsExpDateInCurDay",Param)
	i PMaterialId="" d
	.s PMaterialId=##class(web.CSSDHUI.Common.PackageInfoCommon).GetDefaultMaterial(PPkgId)
	q:PMaterialId="" RtnObj.Err(-1,"","该消毒包未设置默认包装材料","",0)

	s MaterialInfo=##class(web.CSSDHUI.Common.PackageInfoCommon).GetMaterialExpireLength(PMaterialId,PPkgId)
	q:MaterialInfo="" RtnObj.Err(-2,"","消毒包和包装材料未做绑定！","",0)

	s length=$p(MaterialInfo,"^",1)
	s price=$p(MaterialInfo,"^",2)
	q:length=0 RtnObj.Err(-3,"","消毒包有效期为空","",0)
	
	s Ret=..sssLock(AppName)
	i Ret'=0 q RtnObj.Err(-99,"","加锁失败")
	
	s PkgObj=##Class(User.CSSDPackage).%OpenId(PPkgId)
	s PkgCode=PkgObj.CSSDPCode
	s pdate=+$h
	s ptime=$p($h,",",2)
	i PSterDate'=pdate d
	.s pdate=PSterDate
	.s ptime=0

	s SerialNo=##class(web.CSSDHUI.Common.AppCommon).CreatePackSerialNo()
	s labels=..GetFabricLabels(PkgCode,PCreateQty)
	s lblLenth=$L(labels,"^")
	s PackRowIds=""
	f j=1:1:lblLenth q:RtnObj.success<0  d
	.s Label=$p(labels,"^",j)
	.&sql(Insert into CSSD_PackagePack
		(CSSDPP_Label,CSSDPP_Package_DR,CSSDPP_Loc_DR,CSSDPP_Date,CSSDPP_Time,
		CSSDPP_Qty,CSSDPP_User_DR,CSSDPP_AckUser_DR,CSSDPP_AckDate,CSSDPP_SerialNo,
		CSSDPP_PackLocDr,CSSDPP_PackUser_DR,CSSDPP_Material_DR,CSSDPP_IsLoadSteCar,CSSDPP_Machine_DR,
		CSSDPP_HeatNo,CSSDPP_PrtTimes,CSSDPP_SterUser_DR)
		Values
		(:Label,:PPkgId,:gLocId,:pdate,:ptime,
		1,:PPackUserId,:PPackChkUserId,:pdate,:SerialNo,
		:PToLocId,:PPackerId,:PMaterialId,0,:PSterMachineId,
		:PHeatNo,0,:PSterUserId))
	.i SQLCODE'=0 d RtnObj.Err(-10,"","插入数据失败:"_MethodName_":SQLCODE"_SQLCODE_":"_$g(%msg)) q
	.
	.s PackId=%ROWID
	.i PackRowIds="" s PackRowIds=PackId
	.e  s PackRowIds=PackRowIds_","_PackId
	.i IsExpDateInCurDay="Y"	d
	..s expireDate=pdate+length
	.e  d
	..s expireDate=pdate+length+1
	.&sql(Insert into CSSD_Trans(CSSDT_Label,CSSDT_Pack_DR,CSSDT_Package_DR,CSSDT_Date,CSSDT_Time,
		CSSDT_ExpDate,cssdt_Status,CSSDT_CurrLoc_DR)
		Values(:Label,:PackId,:PPkgId,:pdate,:ptime,:expireDate,'P',:gLocId))
	.i SQLCODE'=0 d RtnObj.Err(-12,"","插入数据失败:"_MethodName_":SQLCODE"_SQLCODE_":"_$g(%msg)) q
	i RtnObj.success'=0 d ..sssUnLock(AppName) q RtnObj
	
	d ..sssUnLock(AppName)
	s RtnObj.rowid=PackRowIds
	q RtnObj
}

///  Creator:why
///  CreatDate:2021.3.30
///  Description:删除生成的标签
///  Table:CSSD_Trans,CSSD_PackagePack
///  Input:Params
///  Output:
///  Return:RtnObj
///  others:
ClassMethod jsDeleteLabel(Params) As %String [ SqlProc ]
{
	n (Params)
	s $ZT=..sssError()
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	q:(Params="") RtnObj.Err(-1,"","入参不能为空!").Json()
	s PJObjDetail=##class(web.CSSDHUI.Common.FromJson).%New()
	s ScDetail=PJObjDetail.%FromJSON(Params)
	q:((ScDetail'=0)) RtnObj.Err(-1,"","入参解析失败:").Json()
	ts
	while(RtnObj.success=0){
		s Obj=PJObjDetail.%Pop()
		q:Obj=""

		s PackId=Obj.%Get("RowId")
		s Label=Obj.%Get("Label")
		s RtnObj=..Delete(Label)
		q:RtnObj.success'=0
	}
	i RtnObj.success<0 tro  q RtnObj.Json()
	tc
	q RtnObj.Json()
}

///  Creator:
///  CreatDate:2021-3-30
///  Description: 删除标签
///  Table:CSSD_Trans,CSSD_PackagePack
///  Input:rowId:主表id
///  Output:
///  Return:日志信息
/// d ##class(web.CSSDHUI.Pack.FabricLbl).Delete(3)
ClassMethod Delete(Label As %String) As web.CSSDHUI.RtnObj
{
	n (Label)
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	q:Label="" RtnObj.Err(-1,"","入参不能为空!")

	s PackId= $o(^User.CSSDPackagePackI("CSSDPPLabelIndex",Label,""))
	s IsLoad=##class(User.CSSDPackagePack).%OpenId(PackId).CSSDPPIsLoadSteCar
	q:IsLoad=1 RtnObj.Err(-2,"","已经灭菌不能删除")

	&sql(DELETE FROM CSSD_PackagePack WHERE CSSDPP_Label=:Label)
	i SQLCODE'=0 d
	.d RtnObj.Err(-3,"","此明细删除失败!:"_$ClassName()_".Delete:SQLCODE"_SQLCODE_":"_$g(%msg))
	q:RtnObj.success<0 RtnObj

	&sql(DELETE FROM CSSD_Trans WHERE CSSDT_Label=:Label)
	i SQLCODE'=0 d
	.d RtnObj.Err(-3,"","此明细删除失败!:"_$ClassName()_".Delete:SQLCODE"_SQLCODE_":"_$g(%msg))
	q RtnObj
}

/// 查询非循环包标签
/// w ##Class(web.CSSDHUI.Pack.FabricLbl).GetLabels("133,134")
ClassMethod GetFabricLbl(RowId As %String) As %String
{
	n (RowId)
	q:RowId="" ""	
	s Label=$lg(^User.CSSDPackagePackD(RowId),3)
	q Label
}

}
