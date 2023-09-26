Import SQLUser

/// Creator:why
/// CreatDate:2020-4-14
/// Description:非循环包申请打印
/// Table:CSSD_PackageCallback
Class web.CSSDHUI.Pack.FabricApplyPackLabel Extends (%RegisteredObject, web.CSSDHUI.CSSDType) [ Not ProcedureBlock ]
{

Parameter AppName [ Final ] = "CSSDPACK";

/// d ##class(%ResultSet).RunQuery("web.CSSDHUI.Pack.FabricApplyPackLabel","SelectFlApply","{""StartDate"":""2022-12-21"",""gUserId"":""11889"",""gLocId"":""166"",""gGroupId"":""102"",""gHospId"":""2"",""EndDate"":""2022-12-22"",""ReqLoc"":"""",""ToLoc"":""166"",""LineCode"":""5""}")
Query SelectFlApply(Params As %String = "") As web.CSSDHUI.Query(ROWSPEC = "RowId:%Integer,ApplyNo,ReqLocDesc,SubmitDate,PkgId,PkgDesc,Qty,IsGen,LevelFlag") [ SqlProc ]
{
}

ClassMethod SelectFlApplyExecute(ByRef qHandle As %Binary, Params As %String) As %Status
{
	n (qHandle,Params)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	s PJObj=##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	q:Sc'=0 $$$OK

	s PReqLocId=PJObj.%Get("ReqLoc")
	s PToLocId=PJObj.%Get("ToLoc")
	s PStartDate=PJObj.%Get("StartDate")
	s PEndDate=PJObj.%Get("EndDate")
	s StartDate=..DH2L(PStartDate)
	s EndDate=..DH2L(PEndDate)
	s PLineId=PJObj.%Get("LineCode")
	s gHospId=PJObj.%Get("gHospId")
	s LineLocStr=##class(web.CSSDHUI.Common.PackageInfoCommon).GetLocByLine(PLineId)
	s Result=##class(%Library.ResultSet).%New()
	s SqlStr="select CSSDCD_Rowid as RowId,CSSDCD_Parref_DR->CSSDPC_PackageApplyDR->CSSDPA_No as ApplyNo,"
		_" CSSDCD_Parref_DR->CSSDPC_FromLoc_DR as ReqLocId,CSSDCD_Parref_DR->CSSDPC_ToLoc_DR as ToLocId,"
		_" CSSDCD_Parref_DR->CSSDPC_PackageApplyDR->CSSDPA_SubmitDate as SubmitDate,CSSDCD_Package_DR as PkgId,"
		_" CSSDCD_Parref_DR->CSSDPC_PackageApplyDR->CSSDPA_SubmitTime as SubmitTime,CSSDCD_Qty as Qty,"
		_" CSSDCD_Package_DR->CSSDP_Desc as PkgDesc,CSSDCD_IsClean as IsClean,"
		_" CSSDCD_Parref_DR->CSSDPC_PackageApplyDR->CSSDPA_Flag as Flag,CSSDCD_Parref_DR->CSSDPC_ReqLevel as LevelFlag"
		_" from CSSD_CallBackDetailNew where CSSDCD_Parref_DR->CSSDPC_ComplateFlag='W' "
		_" and CSSDCD_Parref_DR->CSSDPC_ISOPRFlag='N' and CSSDCD_Parref_DR->CSSDPC_ApplyType=2 "
		_" and CSSDCD_Parref_DR->CSSDPC_PackageApplyDR->CSSDPA_SubmitDate between "_StartDate_" AND "_EndDate_" "
	d Result.RuntimeModeSet(0)
	d Result.Prepare(SqlStr)
	d Result.Execute()

	While(Result.Next())
	{
		s RowId = Result.Data("RowId")
		s ApplyNo = Result.Data("ApplyNo")
		s Flag = Result.Data("Flag")
		s ToLocId=Result.Data("ToLocId")
		s ReqLocId=Result.Data("ReqLocId")
		s ShowDataFlag=##class(web.CSSDHUI.HospMap).GetShowDataFlag("CT_Loc",ToLocId,gHospId)
		s ReqLocDesc=..sssLocDesc(ReqLocId)
		s SubmitDate= Result.Data("SubmitDate")  ;提交日期 未提交的为空
		s SubmitTime= Result.Data("SubmitTime")
		s SubmitDate=..DL2H(SubmitDate)_" "_..TL2H(SubmitTime)
		s PkgId=Result.Data("PkgId")
		s PkgDesc=Result.Data("PkgDesc")
		s Qty=Result.Data("Qty")
		s IsGen=Result.Data("IsClean")
		s LevelFlag=Result.Data("LevelFlag")

		;提交,拒绝状态的非循环包申请单不显示
		continue:((Flag="8")||(Flag="1"))
		continue:((PToLocId'="")&&(ToLocId'=PToLocId))
		continue:((PReqLocId'="")&(PReqLocId'=ReqLocId))
		continue:ShowDataFlag="N"
		continue:(LineLocStr'="")&&(LineLocStr'[("^"_ReqLocId_"^"))
		d OutPutRow
	}
	d Result.Close()
	Quit $$$OK
OutPutRow
	s Data=$lb(RowId,ApplyNo,ReqLocDesc,SubmitDate,PkgId,PkgDesc,Qty,IsGen,LevelFlag)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// Creator:why
/// CreatDate:2022.02.11
/// Description:非循环包申请单标签生成
/// Table:gLocId 消毒供应室的id ,CSSD_PackagePack,CSSD_PackageApplyDetail
/// Input:Main,detailIDs 明细表的id组成的字符串,配包人id,打包人的id,num:生成数量
/// Output:
/// Return:
/// d ##class(web.CSSDHUI.Pack.FabricApplyPackLabel).jsGenFlLabel(^tmpmy("Main"),^tmpmy("De"))
ClassMethod jsGenFlLabel(Main, Detail) As %Library.String
{
	n (Main, Detail)
	s $ZT=..sssError()
	ts
	s RtnObj=..GenFlLabel(Main, Detail)
	i RtnObj.success<0 tro  q RtnObj.Json()
	tc
	q RtnObj.Json()
}

/// Creator:why
/// CreatDate:2020.04.15
/// Description:非循环包申请单标签生成
/// Table:gLocId 消毒供应室的id ,CSSD_PackagePack,CSSD_PackageApplyDetail
/// Input:Main,detailIDs 明细表的id组成的字符串,配包人id,打包人的id,num:生成数量
/// Output:
/// Return:
/// Others：w ##Class(web.CSSDHUI.Pack.FabricApplyPackLabel).GenFlLabel()
ClassMethod GenFlLabel(Main, Detail) As %String
{
	n (Main,Detail)
	s MethodName=$ClassName()_".GenFlLabel"
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	q:((Main="")||(Detail="")) RtnObj.Err(-1,"","入参不能为空!","",0)

	s PJObjMain=##class(web.CSSDHUI.Common.FromJson).%New()
	s ScMain=PJObjMain.%FromJSON(Main)
	s PJObjDetail=##class(web.CSSDHUI.Common.FromJson).%New()
	s ScDetail=PJObjDetail.%FromJSON(Detail)
	q:((ScMain'=0)||( ScDetail'=0)) RtnObj.Err(-1,"","入参解析失败!","",0)

	s gUserId=PJObjMain.%Get("gUserId")
	s gHospId=PJObjMain.%Get("gHospId")
	s gGroupId=PJObjMain.%Get("gGroupId")
	s gLocId=PJObjMain.%Get("gLocId")
	s PPackChkUserId=PJObjMain.%Get("PackChkUser")
	s PPackUserId=PJObjMain.%Get("PackUser")
	s PPackerId=PJObjMain.%Get("Packer")
	s PSterDate=PJObjMain.%Get("SterDate")
	s PMaterialId=PJObjMain.%Get("Material")
	s PSterUserId=PJObjMain.%Get("SterUser")
	s PMachineId=PJObjMain.%Get("SterMachine")
	s PHeatNo=PJObjMain.%Get("HeatNo")
	s PRemark=PJObjMain.%Get("Remark")
	
	q:PPackChkUserId="" RtnObj.Err(-1,"","审核人为空","",0)
	q:PPackUserId="" RtnObj.Err(-1,"","包装人为空","",0)

	s Param=gGroupId_"^"_gLocId_"^"_gUserId_"^"_gHospId
	s AppName=..%GetParameter("AppName")
	s IsExpDateInCurDay=##class(web.CSSDHUI.Common.AppCommon).GetParamValue(AppName,"IsExpDateInCurDay",Param)
	s pdate=+$h
	s ptime=$p($h,",",2)
	i ((PSterDate'=pdate)&&(PSterDate'=""))  d
	.s SterDate=..DH2L(PSterDate)
	.s pdate=SterDate
	.s ptime=0
	s (CBItmIds)=""

	s Ret=..sssLock(AppName)
	i Ret'=0 q RtnObj.Err(-99,"","加锁失败")

	while(RtnObj.success=0){
		s Obj=PJObjDetail.%Pop()
		q:Obj=""

		s CBItmId=Obj.%Get("RowId")
		s LevelFlag=Obj.%Get("LevelFlag")
		s PackId="",Qty=0
		f  s PackId=$o(^User.CSSDPackagePackI("CallBackDetail",CBItmId,PackId)) q:PackId=""  d
		.s Qty=Qty+1
		s CBItemObj=##class(User.CSSDCallbackDetailNew).%OpenId(CBItmId)
		d CBItemObj.%Reload()

		s PkgId=CBItemObj.CSSDCDPackageDr.%Id()
		s PkgCode=CBItemObj.CSSDCDPackageDr.CSSDPCode
		s CBItmQty=CBItemObj.CSSDCDQty
		;是否已生成标签
		s IsGen=CBItemObj.CSSDCDIsClean
		continue:IsGen="Y"

		s serialNo=##class(web.CSSDHUI.Common.AppCommon).CreatePackSerialNo()
		s CBLocId=##Class(web.CSSDHUI.Pack.CleanPackLabel).GetLocID(CBItmId)
		s MaterialId =##class(web.CSSDHUI.Common.PackageInfoCommon).GetDefaultMaterial(PkgId)
		i PMaterialId'="" s MaterialId=PMaterialId
		i MaterialId="" d RtnObj.Err(-1,"","该消毒包未设置默认包装材料","",0)
		continue:RtnObj.success'=0

		s MaterialInfo=##class(web.CSSDHUI.Common.PackageInfoCommon).GetMaterialExpireLength(MaterialId,PkgId)
		i MaterialInfo="" d RtnObj.Err(-2,"","消毒包和包装材料未做绑定！","",0)
		continue:RtnObj.success'=0

		s length=$p(MaterialInfo,"^",1)
		s price=$p(MaterialInfo,"^",2)
		i length=0 d RtnObj.Err(-3,"","消毒包有效期为空","",0)
		continue:RtnObj.success'=0

		i IsExpDateInCurDay="Y"	d
		.s expireDate=pdate+length
		e  d
		.s expireDate=pdate+length+1

		s num=CBItmQty-Qty
		s labels=##Class(web.CSSDHUI.Pack.CleanPackLabel).GetOrdLabels(PkgCode,num)
		s lblLenth=$L(labels,"^")
		f j=1:1:lblLenth  q:RtnObj.success<0  d
		.s Label=$p(labels,"^",j)
		.&sql(Insert into CSSD_PackagePack(CSSDPP_Label,CSSDPP_Package_DR,CSSDPP_Loc_DR,
			CSSDPP_Date,CSSDPP_Time,CSSDPP_Qty,CSSDPP_User_DR,CSSDPP_AckUser_DR,
			CSSDPP_AckDate,CSSDPP_SerialNo,CSSDPP_IsLoadSteCar,CSSDPP_ApplyLoc,
			CSSDPP_CallBackDetailDr,CSSDPP_Material_DR,CSSDPP_PackUser_DR,
			CSSDPP_LevelFlag,CSSDPP_Clean_DR,CSSDPP_PrtTimes,CSSDPP_BasketCode,
			CSSDPP_SterUser_DR,CSSDPP_Machine_DR,CSSDPP_HeatNo,CSSDPP_Remark)
			Values
			(:Label,:PkgId,:gLocId,
			:pdate,:ptime,1,:PPackUserId,:PPackChkUserId,
			:pdate,:serialNo,0,:CBLocId,
			:CBItmId,:MaterialId,:PPackerId,
			:LevelFlag,null,0,null,
			:PSterUserId,:PMachineId,:PHeatNo,:PRemark))
		.i SQLCODE'=0  d
		..d RtnObj.Err(-10,"","插入数据失败:"_MethodName_":SQLCODE"_SQLCODE_":"_$g(%msg))
		.q:RtnObj.success<0
		.
		.s PackId=%ROWID
		.&sql(Insert into CSSD_Trans(CSSDT_Label,CSSDT_Pack_DR,CSSDT_Package_DR,
			CSSDT_Clean_DR,CSSDT_Date,CSSDT_Time,CSSDT_ExpDate,cssdt_Status,
			CSSDT_PreCallBackDetail_DR,CSSDT_CurrLoc_DR)
			Values
			(:Label,:PackId,:PkgId,null,:pdate,:ptime,:expireDate,'P',
			:CBItmId,:gLocId))
		.i SQLCODE'=0 d RtnObj.Err(-11,"","插入数据失败:"_MethodName_":SQLCODE"_SQLCODE_":"_$g(%msg))
		.q:RtnObj.success<0
		.
		.&sql(UPDATE CSSD_CallBackDetailNew SET CSSDCD_IsClean='Y' WHERE CSSDCD_Rowid=:CBItmId)
		.i SQLCODE'=0  d
		..d RtnObj.Err(-11,"","更新数据失败:"_MethodName_":SQLCODE"_SQLCODE_":"_$g(%msg))
		.q:RtnObj.success<0
		continue:RtnObj.success<0

		i CBItmIds="" d
		.s CBItmIds=CBItmId
		e  d
		.s CBItmIds=CBItmIds_","_CBItmId
	}
	i RtnObj.success<0 d ..sssUnLock(AppName) q RtnObj

	d ..sssUnLock(AppName)
	s RtnObj.rowid=CBItmIds
	q RtnObj
}

/// Creator:why
/// CreatDate:2020.04.15
/// Description:根据回收明细表id获取标签明细
/// Table:CSSD_PackagePack,CSSD_Trans
/// Input:CSSD_CallBackDetailNew表的id组成的字符串
/// Output:
/// Return:
/// Others：d ##Class(%ResultSet).RunQuery("web.CSSDHUI.Pack.FabricApplyPackLabel","QueryFabricPkgsByCallBackId","42,43")
Query QueryFabricPkgsByCallBackId(Params As %String) As web.CSSDHUI.Query(ROWSPEC = "RowId:%Integer,Label,PkgId,PkgDesc,PackChkUserId,PackChkUserName,PackUserId,PackUserName,ExpDate,SterDate,ReqLocId,ReqLocDesc,LevelFlag,MaterialDesc,Remark,PackerName,SterUserName,MachineDesc,HeatNo,Status,StatusDesc") [ SqlProc ]
{
}

ClassMethod QueryFabricPkgsByCallBackIdExecute(ByRef qHandle As %Binary, Params As %String) As %Status
{

	n (qHandle,Params)
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind=1
	s PJObj = ##class(web.CSSDHUI.Common.FromJson).%New()
	q:Params="" $$$OK

	s sql="select CSSDPP_Rowid AS PackId,CSSDPP_Package_DR as PkgId,CSSDPP_Package_DR->cssdp_desc as PkgDesc, "
		_" CSSDPP_Label AS Label,CSSDPP_AckUser_DR  AS PackChkUserId, CSSDPP_User_DR AS PackUserId,CSSDPP_PackUser_DR AS PackerId,"
		_" CSSDPP_ApplyLoc as ReqLocId ,cssdpp_ackdate as SterDate,CSSDPP_LevelFlag,CSSDPP_Material_DR->CSSDM_Desc as MaterialDesc,CSSDPP_Remark, "
		_" CSSDPP_SterUser_DR as SterUserId,CSSDPP_Machine_DR->CSSDMC_Alias As MachineDesc,CSSDPP_HeatNo As HeatNo "
		_" from CSSD_PackagePack where CSSDPP_CallBackDetailDr in ("_Params_") "
	s result=##class(%Library.ResultSet).%New()
	d result.RuntimeModeSet(0)
	d result.Prepare(sql)
	d result.Execute()

	While(result.Next())
	{
		s PackId = result.Data("PackId")
		s PkgDesc=result.Data("PkgDesc")
		s Label = result.Data("Label")
		s TransId= $o(^User.CSSDTransI("CSSDTLabel",Label,""))
		s TransObj=##class(User.CSSDTrans).%OpenId(TransId)
		s ExpDate=TransObj.CSSDTExpDate
		s PkgId=result.Data("PkgId")

		s PackChkUserId = result.Data("PackChkUserId")
		s PackChkUserName=..sssUserName(PackChkUserId)
		s PackUserId = result.Data("PackUserId")
		s PackUserName=..sssUserName(PackUserId)
		s PackerId = result.Data("PackerId")
		s PackerName=..sssUserName(PackerId)
		s ExpDate=..DL2H(ExpDate)
		s SterDate=result.Data("SterDate")
		s SterDate=..DL2H(SterDate)
		s ReqLocId=result.Data("ReqLocId")
		s ReqLocDesc=..sssLocDesc(ReqLocId)
		s LevelFlag=result.Data("CSSDPP_LevelFlag")
		s MaterialDesc=result.Data("MaterialDesc")
		s Remark=result.Data("CSSDPP_Remark")
		s SterUserId=result.Data("SterUserId")
		s SterUserName=..sssUserName(SterUserId)
		s MachineDesc=result.Data("MachineDesc")
		s HeatNo=result.Data("HeatNo")
		
		s TransId=$o(^User.CSSDTransI("CSSDTLabel",Label,0))
		continue:TransId=""
		s TransObj=##class(User.CSSDTrans).%OpenId(TransId)
		d TransObj.%Reload()
		s Status=TransObj.CSSDTStatus
		s StatusDesc=##Class(web.CSSDHUI.Common.PackageInfoCommon).GetStatusChinese(Status)

		d OutputRowFL
	}
	d result.Close()
	q $$$OK
OutputRowFL
	set Data=$lb(PackId,Label,PkgId,PkgDesc,PackChkUserId,PackChkUserName,PackUserId,PackUserName,ExpDate,SterDate,ReqLocId,ReqLocDesc,LevelFlag,MaterialDesc,Remark,PackerName,SterUserName,MachineDesc,HeatNo,Status,StatusDesc)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// Creator:why
/// CreatDate:2020.04.16
/// Description:根据回收明细表id获取标签明细
/// Table:CSSD_PackagePack,CSSD_Trans
/// Input:CSSD_CallBackDetailNew表的id组成的字符串
/// Output:
/// Return:
/// Others：w ##Class(web.CSSDHUI.Pack.FabricApplyPackLabel).GetPackageLabels("55")
ClassMethod GetPackageLabels(CBItmIds As %String) As %String
{
	n (CBItmIds)
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr="SELECT CSSDPP_Rowid,CSSDPP_Label FROM CSSD_PackagePack WHERE CSSDPP_CallBackDetailDr IN ("_CBItmIds_")"
	d result.RuntimeModeSet(0)
	d result.Prepare(sqlStr)
	d result.Execute()

	s ResultStr=""
	While(result.Next())
	{
		s RowId=result.Data("CSSDPP_Rowid")
		s Label=result.Data("CSSDPP_Label")
		s:(ResultStr'="") ResultStr=ResultStr_","
		s ResultStr=ResultStr_"{"
		s ResultStr=ResultStr_"""id"":"""_""_RowId_""",""label"":"""_Label_""""
		s ResultStr=ResultStr_"}"
	}
	s ResultStr="["_ResultStr_"]"
	q ResultStr
}

/// Creator:why
/// CreatDate:2020.11.18
/// Description:非循环包申请单修改数量
/// Table:CSSD_CodeDict
/// Input: Params:所要修改的明细行
/// Output:
/// Return:
/// d ##class(web.CSSDHUI.Pack.FabricApplyPackLabel).jsUpdateQty("[{""RowId"":""267"",""PackageDR"":""748"",""PkgDesc"":""EHB-二号包"",""Qty"":""2"",""Remark"":"""",""RemarkInfo"":""123""}]")
ClassMethod jsUpdateQty(Params) As %Library.String
{
	n (Params)
	s $ZT=..sssError()
	ts
	s RtnObj=..UpdateQty(Params)
	i RtnObj.success'=0 tro  q RtnObj.Json()
	tc
	q RtnObj.Json()
}

ClassMethod UpdateQty(Params) As web.CSSDHUI.RtnObj
{
	n (Params)
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	s PJObj=##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	q:Sc'=0 RtnObj.Err(-1,"","入参解析失败!","",0)

	while(RtnObj.success=0){
		s Obj=PJObj.%Pop()
		q:Obj=""

		s RowId=Obj.%Get("RowId")
		s ApplyItmId=$lg(^User.CSSDCallbackDetailNewD(RowId),7)
		s Qty=Obj.%Get("Qty")
		s PackId="",CompleteQty=0
		f  s PackId=$o(^User.CSSDPackagePackI("CallBackDetail",RowId,PackId)) q:PackId=""  d
		.s CompleteQty=CompleteQty+1
		i CompleteQty>Qty d RtnObj.Err(-2,"","修改数量不能小于已生成标签数!")
		continue:RtnObj.success'=0

		s IsGen=Obj.%Get("IsGen")
		i IsGen="Y" d RtnObj.Err(-2,"","已经完成无法修改数量")
		continue:RtnObj.success'=0

		&sql(UPDATE CSSD_CallBackDetailNew SET CSSDCD_Qty=:Qty WHERE CSSDCD_RowId=:RowId)
		i SQLCODE'=0 d RtnObj.Err(-2,"",$ClassName()_"Update:保存失败!")
		continue:RtnObj.success'=0

		&sql(UPDATE CSSD_PackageApplyDetail SET CSSDPAD_ReqQty=:Qty WHERE ID=:ApplyItmId)
		i SQLCODE'=0 d RtnObj.Err(-2,"",$ClassName()_"Update:保存失败!")
		continue:RtnObj.success'=0
	}
	q RtnObj
}

/// Creator:ban
/// CreatDate:2020.12.03
/// Description:获取外来器械生成的具体标签
/// Table:
/// Input:detailIds 清洗明细表的detailId
/// Output:
/// Return:
/// 查询外来器械包 配包人，审核人信息
/// d ##class(%ResultSet).RunQuery("web.CSSDHUI.Pack.FabricApplyPackLabel","GetFlPackInfo","116")
Query GetFlPackInfo(PackId As %String) As web.CSSDHUI.Query(ROWSPEC = "Label,PkgDesc,PackId:%Integer,PackChkUserId,PackChkUserName,PackUserId,PackUserName,ExpDate,BindLabel,PackerId,PackerName,MaterialId,MaterialDesc") [ SqlProc ]
{
}

ClassMethod GetFlPackInfoExecute(ByRef qHandle As %Binary, PackId As %String) As %Status
{
	n (qHandle,PackId)
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind=1
	q:PackId="" $$$OK
	s curdate=+$h

	s PackObj=##Class(User.CSSDPackagePack).%OpenId(PackId)
	s Label=$lg(^User.CSSDPackagePackD(PackId),3) ;标签
	s PkgId=$lg(^User.CSSDPackagePackD(PackId),13) ;消毒包id
	s PkgDesc=""
	s:PkgId'="" PkgDesc=$lg(^User.CSSDPackageD(PkgId),5)
	s TransId=$o(^User.CSSDTransI("CSSDTLabel",Label,""))
	s TransObj=##Class(User.CSSDTrans).%OpenId(TransId)
	s ExpDate=TransObj.CSSDTExpDate
	s ExpDate=..DL2H(ExpDate)
	;审核人
	s PackChkUser=PackObj.CSSDPPAckUserDr
	s PackChkUserId=PackChkUser.%Id()
	s PackChkUserName=PackChkUser.SSUSRName
	;包装人
	s PackUser=PackObj.CSSDPPUserDr
	s PackUserId=PackUser.%Id()
	s PackUserName=PackUser.SSUSRName
	;配包人
	s (PackerId,PackerName)=""
	s Packer=PackObj.CSSDPPPackUserDr
	i $IsObject(Packer) d
	.s PackerId=Packer.%Id()
	.s PackerName=..sssUserName(Packer.%Id())
	;包装材料
	s Material=PackObj.CSSDPPMaterialDr
	s (MaterialId,MaterialDesc)=""
	i $IsObject(Material) d
	.s MaterialId=Material.%Id()
	.s MaterialDesc=Material.CSSDMDesc
	s BindLabel = PackObj.CSSDPPNewLabel
	d OutputRowDetail
	q $$$OK
OutputRowDetail
	s Data=$lb(Label,PkgDesc,PackId,PackChkUserId,PackChkUserName,PackUserId,PackUserName,ExpDate,BindLabel,PackerId,PackerName,MaterialId,MaterialDesc)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// CreatDate:2022.4.25
/// Description:删除非循环包单标签
/// Input:Params
/// Return:RtnObj
/// w ##Class(web.CSSDHUI.Pack.FabricApplyPackLabel).jsDelete("[{""cleanDetailId"":""34"",""Label"":""20072022042400001"",""PkgDesc"":""人工授精包"",""PackId"":""59"",""PackChkUserId"":""12204"",""PackChkUserName"":""高雪云"",""PackUserId"":""11889"",""PackUserName"":""xd01"",""ExpDate"":""2022-05-01"",""PackUserId"":"""",""PackUserName"":"""",""IsPrint"":""N"",""MaterialId"":""1"",""MaterialDesc"":""棉纺物品""}]")
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

		s PackId=Obj.%Get("RowId")
		continue:PackId=""

		s RtnObj=..Delete(PackId)
		continue:RtnObj.success'=0
	}
	i RtnObj.success<0 tro  q RtnObj.Json()
	tc
	q RtnObj.Json()
}

ClassMethod Delete(PackId) As web.CSSDHUI.RtnObj
{
	n (PackId)
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()

	s Label=$lg(^User.CSSDPackagePackD(PackId),3)
	s CBItmId=$lg(^User.CSSDPackagePackD(PackId),18)
	q:CBItmId="" RtnObj.Err(-2,"",Label_"该标签对应的回收明细已被删除")


	s SteritmId=$o(^User.CSSDPackageSterilizeI("IndexCSSDPSLabel",Label,""))
	q:SteritmId'="" RtnObj.Err(-1,"",Label_"该标签已灭菌,不允许删除")


	;删除打包主表
	&sql(delete from CSSD_PackagePack where CSSDPP_Rowid=:PackId)
	q:SQLCODE'=0 RtnObj.Err(-3,"","删除CSSD_PackagePack失败!")

	;删除消毒包追踪表
	&sql(delete from CSSD_Trans where CSSDT_Pack_DR=:PackId)
	q:SQLCODE'=0 RtnObj.Err(-4,"","删除CSSD_Trans失败!")

	&sql(UPDATE CSSD_CallBackDetailNew SET CSSDCD_IsClean="" WHERE CSSDCD_Rowid=:CBItmId)
	q:SQLCODE'=0 RtnObj.Err(-5,"","更新CSSD_CallBackDetailNew失败!")

	q RtnObj
}

}
