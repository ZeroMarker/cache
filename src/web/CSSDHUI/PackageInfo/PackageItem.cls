Import sqluser

/// wfg
Class web.CSSDHUI.PackageInfo.PackageItem Extends (%RegisteredObject, web.CSSDHUI.CSSDType) [ Not ProcedureBlock ]
{

/// Creator:ban
/// CreatDate:2020-3-2
/// Description:判断是否存在与消毒包关联，存在对应的消毒包是否已停用 只有全部停用的消毒包才能停用器械
/// Table:CSSD_PackageItem
/// 判断器械是否能够停用
/// w ##class(web.CSSDHUI.PackageInfo.PackageItem).IsItemStop(4)
ClassMethod IsItemStop(ItmId As %String) As %Library.String
{
	n (ItmId)
	s UseFlag="N"
	s PkgItmId=""
	f  s PkgItmId=$o(^User.CSSDPackageItemI("CSSDPIItmDRIndex",ItmId,PkgItmId)) q:((PkgItmId="")||(UseFlag="Y"))  d
	.i PkgItmId'="" d
	..s PkgId = $list(^User.CSSDPackageItemD(PkgItmId),8)
	..s PkgObj=##class(User.CSSDPackage).%OpenId(PkgId)
	..d PkgObj.%Reload()
	..s UseFlag=PkgObj.CSSDPNotUseFlag
	q UseFlag
}

/// Creator:ban
/// CreatDate:2020-3-2
/// Description:保存/更新器械信息
/// Table:CSSD_Item
/// 保存器械信息
/// w ##class(web.CSSDHUI.PackageInfo.PackageItem).jsSavePkg()
ClassMethod jsSave(Params, Others) As %Library.String
{
	n (Params,Others)
	s $ZT=..sssError()
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	ts
	s RtnObj=..Save(Params,Others)
	i RtnObj.success'=0 tro  q RtnObj.Json()
	tc
	q RtnObj.Json()
}

/// Creator:ban
/// CreatDate:2020-3-2
/// Description:保存/更新器械信息
/// Table:CSSD_Item
/// 保存器械信息
/// w ##class(web.CSSDHUI.PackageInfo.PackageItem).Save("[{""RowId"":""4339"",""Description"":""测试"",""Spec"":""测试"",""Price"":""0"",""UseFlag"":""Y"",""Remarks"":"""",""Alias"":""CS""}]","{""BDPHospital"":""2"",""gUserId"":""11889"",""gLocId"":""166"",""gGroupId"":""102"",""gHospId"":""2""}")
ClassMethod Save(Params, Others) As %Library.String
{
	n (Params,Others)
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	s PJObj=##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	s OthersObj=##class(web.CSSDHUI.Common.FromJson).%New()
	s OthersSc=OthersObj.%FromJSON(Others)
	i ((Sc'=0)||(OthersSc'=0)) d RtnObj.Err(-1,"","入参解析失败！") q
	
	s pHospId=OthersObj.%Get("BDPHospital")
	s gLocId=OthersObj.%Get("gLocId")
	s gHospId=OthersObj.%Get("gHospId")
	s pHospId=##class(web.CSSDHUI.HospMap).GetBDPHospId(pHospId,gHospId)
	while(RtnObj.success=0){
		s Obj=PJObj.%Pop()
		q:Obj=""
		
		s RowId=Obj.%Get("RowId")
		s ItmDesc=Obj.%Get("ItmDesc")
		s ItmAlias=Obj.%Get("ItmAlias")
		s ItmSpec=Obj.%Get("ItmSpec")
		s ItmPrice=Obj.%Get("ItmPrice")
		s UseFlag=Obj.%Get("UseFlag")
		s OneOffFlag=Obj.%Get("OneOffFlag")	;器械一次性使用标志
		s ImplantsFlag=Obj.%Get("ImplantsFlag")
		s Remarks=Obj.%Get("Remarks")
		
		s:ItmAlias="" ItmAlias=##class(web.CSSDHUI.Common.UtilCommon).GetCNCODE(ItmDesc,4)
		i ItmPrice<0 d RtnObj.Err(-1,"","价格输入有误，请重新输入！")
		continue:RtnObj.success'=0
		
		s ItemId=##class(web.CSSDHUI.HospMap).CodeDescIfRepeat("Desc",ItmDesc,"CSSD_Item",pHospId,"",ItmSpec,gLocId)
		i ((ItemId'="")&&(ItemId'=RowId)) d RtnObj.Err(-3,"","名称:"_ItmDesc_" 规格:"_ItmSpec_"出现重复！")
		continue:RtnObj.success'=0
		
		s ItmObj=""
		i RowId="" d
		.s ItmObj=##class(User.CSSDItem).%New()
		e  d
		.s ItmObj=##class(User.CSSDItem).%OpenId(RowId)
		.d ItmObj.%Reload()
		.i UseFlag="N" d
		..s Flag=..IsItemStop(RowId)
		..i Flag="Y" d RtnObj.Err(-2,"","该器械和消毒包存在绑定，不能停用！")
		continue:RtnObj.success'=0
		
		i ItmPrice="" s ItmPrice=0
		s ItmObj.CSSDIDesc=ItmDesc
		s ItmObj.CSSDISpec=ItmSpec
		s ItmObj.CSSDIPrice=ItmPrice
		s ItmObj.CSSDIUseFlag=UseFlag
		s ItmObj.CSSDIRemarks=Remarks
		s ItmObj.CSSDICreateLocDr=##class(User.CTLoc).%OpenId(gLocId)
		s ItmObj.CSSDIAlias=ItmAlias
		s ItmObj.CSSDIOneOffFlag=OneOffFlag
		s ItmObj.CSSDIImplantsFlag=ImplantsFlag
		s Sc=ItmObj.%Save()
		i $$$ISERR(Sc) d RtnObj.Err(-5,"",MethodName_":保存失败！")
		continue:RtnObj.success'=0
		
		s:RowId="" RowId=ItmObj.%Id()
		s Ret = ##class(web.CSSDHUI.HospMap).SaveHOSP("CSSD_Item",RowId,pHospId)
		i Ret'=0 d RtnObj.Err(-6,"","关联院区失败！")
		continue:RtnObj.success'=0
	}
	q RtnObj
}

/// Creator:ban
/// Date:2019-12-20
/// Table:CSSD_Item
/// Description：查询所有器械信息
/// Input:Params
/// Output:RtnObj.Json()
/// d ##class(%ResultSet).RunQuery("web.CSSDHUI.PackageInfo.PackageItem","SelectAll","{""Description"":""ks"",""gUserId"":""11889"",""gLocId"":""166"",""gGroupId"":""102"",""gHospId"":""2""}","{""BDPHospital"":""2"",""gUserId"":""11889"",""gLocId"":""166"",""gGroupId"":""102"",""gHospId"":""2""}")
Query SelectAll(Params As %String, Others As %String) As web.CSSDHUI.Query(ROWSPEC = "RowId:%Integer,ItmDesc,ItmAlias,ItmSpec,ItmPrice:%Float,UseFlag,Remarks,OneOffFlag,ImplantsFlag") [ SqlProc ]
{
}

ClassMethod SelectAllExecute(ByRef qHandle As %Binary, Params As %String, Others As %String) As %Status
{
	n (qHandle,Params,Others)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	
	s PJObj = ##class(web.CSSDHUI.Common.FromJson).%New()
	s OthersObj = ##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	s OtherSc=OthersObj.%FromJSON(Others)
	i ((Sc'=0)||(OtherSc'=0)) q $$$OK
	s PItmDesc = PJObj.%Get("Description")
	s gLocId = PJObj.%Get("gLocId")
	s pHospId=OthersObj.%Get("BDPHospital")
	s gHospId=OthersObj.%Get("gHospId")
	s PItmDesc=$$ALPHAUP^SSUTIL4(PItmDesc)
	s pHospId=##class(web.CSSDHUI.HospMap).GetBDPHospId(pHospId,gHospId)
	s Result=##class(%Library.ResultSet).%New()
	s SqlStr="SELECT ID AS RowId ,CSSDI_Desc as Description, CSSDI_Spec, CSSDI_Price, CSSDI_UseFlag,"
			_" CSSDI_Remarks,CSSDI_CreateLocDr,CSSDI_Alias,CSSDI_OneOffFlag,CSSDI_ImplantsFlag FROM CSSD_Item "
			_" where (CSSDI_Desc like '%"_PItmDesc_"%' OR CSSDI_Alias like '%"_PItmDesc_"%' ) "
	d Result.RuntimeModeSet(0)
	d Result.Prepare(SqlStr)
	d Result.Execute()
	While(Result.Next())
	{
		s RowId = Result.Data("RowId")
		s ItmDesc = Result.Data("Description")
		s ItmAlias = Result.Data("CSSDI_Alias")
		s ItmSpec = Result.Data("CSSDI_Spec")
		s ItmPrice = Result.Data("CSSDI_Price")
		s UseFlag = Result.Data("CSSDI_UseFlag")
		s Remarks=Result.Data("CSSDI_Remarks")
		s CreateLocDr = Result.Data("CSSDI_CreateLocDr")
		s OneOffFlag=Result.Data("CSSDI_OneOffFlag")
		s ImplantsFlag=Result.Data("CSSDI_ImplantsFlag")
		s ShowDataFlag =##class(web.CSSDHUI.HospMap).GetShowDataFlag("CSSD_Item",RowId,pHospId)
		continue:ShowDataFlag="N"
		continue:((gLocId'="")&(gLocId'=CreateLocDr))
		d OutPutRow
	}
	d Result.Close()
	Quit $$$OK
OutPutRow
	s Data=$lb(RowId,ItmDesc,ItmAlias,ItmSpec,ItmPrice,UseFlag,Remarks,OneOffFlag,ImplantsFlag)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// Creator:ban
/// Date:2019-12-20
/// Table:CSSD_Item
/// Description：删除器械信息
/// Input:Params
/// Output:RtnObj.Json()
/// d ##class(web.CSSDHUI.PackageInfo.PackageItem).jsDeleteItm("[{""RowId"":""1"",""ItmDesc"":""克氏针"",""ItmAlias"":""KSZ"",""ItmSpec"":""（大、中、小）各2"",""ItmPrice"":""0"",""UseFlag"":""Y"",""Remarks"":"""",""OneOffFlag"":""N""}]")
ClassMethod jsDeleteItm(Params As %String) As %Library.String
{
	n (Params)
	s $ZT=..sssError()
	ts
	s RtnObj=..DeleteItm(Params)
	i RtnObj.success<0 tro  q RtnObj.Json()
	tc
	q RtnObj.Json()
}

/// Creator:ban
/// Date:2019-12-20
/// Table:CSSD_Item
/// Description:删除器械信息
/// Input:Params
/// Output:RtnObj
/// w ##class(web.CSSDHUI.PackageInfo.PackageItem).DeleteItem("[{""RowId"":""4341"",""Description"":""空心杯"",""Spec"":""测试"",""Price"":""0"",""UseFlag"":""N"",""Remarks"":"""",""Alias"":""KXB""}]")
ClassMethod DeleteItm(Params As %String) As %Library.String
{
	n (Params)
	s MethodName=$ClassName()_".DeleteItm"
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	s PJObj=##class(web.CSSDHUI.Common.FromJson).%New()
	s sc=PJObj.%FromJSON(Params)
	i sc'=0 d RtnObj.Err(-1,"","入参解析失败!")
	q:RtnObj.success<0 RtnObj
	
	s Obj=PJObj.%Pop()
	s ItmId=Obj.%Get("RowId")
	s PkgItmId=$o(^User.CSSDPackageItemI("CSSDPIItmDRIndex",ItmId,""))
	i PkgItmId'="" d RtnObj.Err(-2,"","该器械和消毒包存在绑定，不能删除!")
	q:RtnObj.success<0 RtnObj

	&sql(Delete from CSSD_Item where ID=:ItmId)
	i SQLCODE'=0  d RtnObj.Err(-3,"",$ClassName()_".DeleteItem:SQLCODE"_SQLCODE_":"_$g(%msg))
	q:RtnObj.success<0 RtnObj
	
	s Ret=##class(web.CSSDHUI.HospMap).DeleteHospitals("CSSD_Item",ItmId)
	i Ret'=0 d RtnObj.Err(-4,ItmId,MethodName_":删除医院关联数据失败！,SQLOCDE:"_SQLCODE)
	q:RtnObj.success<0 RtnObj
	
	q RtnObj
}

/// Creator:wfg
/// Date:2019-5-20
/// Table:CSSD_Item
/// Description:根据消毒包获取明细信息
/// Input:Params
/// Output:RtnObj
/// d ##class(%ResultSet).RunQuery("web.CSSDHUI.PackageInfo.PackageItem","SelectByF",)
Query SelectByF(PkgId As %String, CleanDRowId As %String = "") As web.CSSDHUI.Query(ROWSPEC = "RowId:%Integer,ItmId,ItmDesc,ItmSpec,Qty,SerialNo,UseFlag,UseFlagDesc,OneOffFlag,ItmRemark,OneOffColor") [ SqlProc ]
{
}

ClassMethod SelectByFExecute(ByRef qHandle As %Binary, PkgId As %String, CleanDRowId As %String = "") As %Status
{
	n (qHandle,PkgId,CleanDRowId)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	q:(PkgId="")&&(CleanDRowId="") $$$OK
	s Result=##class(%Library.ResultSet).%New()
	s IsExt=##class(web.CSSDHUI.Common.PackageInfoCommon).GetExtFlag(PkgId)
	s SqlStr=""
	i (IsExt="Y")&&(CleanDRowId'="") d
	.s CleanDetailObj=##class(User.CSSDCleanDetailPacks).%OpenId(CleanDRowId)
	.s Extdr=CleanDetailObj.CSSDCDPExtDR.%Id()
	.s SqlStr = "SELECT CSSDEBD_Rowid As RowId,CSSDEBD_Itm_DR As ItmRowId,CSSDEBD_Qty As Qty "
	.s SqlStr = SqlStr_" FROM CSSD_ExtDevBindDetail WHERE CSSDEBD_Parref_DR="_Extdr_" and CSSDEBD_Package_DR="_PkgId
	e  d
	.s SqlStr = "SELECT ID As RowId ,CSSDPI_Itm_DR As ItmRowId,CSSDPI_Qty As Qty,CSSDPI_SORT From CSSD_PackageItem"
	.s SqlStr =SqlStr_" where CSSDPI_Package_DR in ("_PkgId_") Order By CSSDPI_SORT"
	d Result.RuntimeModeSet(0)
	d Result.Prepare(SqlStr)
	d Result.Execute()
	s count=0
	While(Result.Next())
	{
		s count=count+1
		s RowId = Result.Data("RowId")
		s ItmId = Result.Data("ItmRowId")
		s Qty = Result.Data("Qty")
		s SerialNo = count
		s ItmDesc=$lg(^User.CSSDItemD(ItmId),2)
		s ItmSpec=$lg(^User.CSSDItemD(ItmId),3)
		s UseFlag=$lg(^User.CSSDItemD(ItmId),5)
		s ItmRemark=$lg(^User.CSSDItemD(ItmId),6)
		s OneOffFlag=$lg(^User.CSSDItemD(ItmId),9)
		s OneOffColor="#ffffff"
		i OneOffFlag="Y" s OneOffColor="#d9b8f1"
		s UseFlagDesc="否"
		i UseFlag="Y" s UseFlagDesc="是"
		d OutPutPkgItmRow
	}
	d Result.Close()
	Quit $$$OK
OutPutPkgItmRow
	s Data=$lb(RowId,ItmId,ItmDesc,ItmSpec,Qty,SerialNo,UseFlag,UseFlagDesc,OneOffFlag,ItmRemark,OneOffColor)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// Creator:wfg
/// Date:2019-5-20
/// Table:CSSD_PackageItem
/// Description: 删除消毒包中的明细
/// Input:Params
/// Output:RtnObj.Json()
/// d ##class(web.CSSDHUI.PackageInfo.PackageItem).jsDelete(3)
ClassMethod jsDelete(Params) As %Library.String
{
	n (Params)
	s $ZT=..sssError()
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	s PJObj=##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	q:Sc'=0 RtnObj.Err(-1,"","入参解析失败!").Json()
	
	ts
	while(RtnObj.success=0){
		s Obj=PJObj.%Pop()
		q:Obj=""
		
		s RowId=Obj.%Get("RowId")
		continue:RowId=""
		s RtnObj=..Delete(RowId)
		continue:RtnObj.success'=0
	}
	i RtnObj.success<0 tro  q RtnObj.Json()
	tc
	q RtnObj.Json()
}

/// Creator:wfg
/// Date:2019-5-20
/// Table:CSSD_PackageItem
/// Description: 删除消毒包中的明细
/// Input:Params
/// Output:RtnObj
/// d ##class(web.CSSDHUI.PackageInfo.PackageItem).Delete(3)
ClassMethod Delete(RowId As %String) As web.CSSDHUI.RtnObj
{
	n (RowId)
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	s PkgItmObj=##class(User.CSSDPackageItem).%OpenId(RowId)
	i '$IsObject(PkgItmObj) d RtnObj.Err(-1,"","该明细已被删除，请核对!")
	q:RtnObj.success<0 RtnObj
	
	s PkgId=PkgItmObj.CSSDPIPackageGetObjectId()
	&sql(Delete From CSSD_PackageItem WHERE %id=:RowId)
	i SQLCODE'=0 D
	.d RtnObj.Err(-2,"",$ClassName()_".jsDelete:SQLCODE"_SQLCODE_":"_$g(%msg))
	q:RtnObj.success<0 RtnObj
	
	s RtnObj=..sortItmNo(PkgId)
	q:RtnObj.success<0 RtnObj
	
	q RtnObj
}

/// Creator:ban
/// CreatDate:20221130
/// Description:消毒包保存 关联消毒包明细
/// Table:CSSD_PackageItem
/// Input: Params\PkgId
/// w ##class(web.CSSDHUI.PackageInfo.Package).jsAddPkgItm(^templxt("jsSaveMain"))
ClassMethod jsAddPkgItm(PkgId As %String, Params As %String) As %Library.String
{
	n (PkgId,Params)
	s $ZT=..sssError()
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	ts
	s RtnObj=..AddPkgItm(PkgId,Params)
	i RtnObj.success'=0 tro  q RtnObj.Json()
	tc
	q RtnObj.Json()
}

/// Creator:ban
/// CreatDate:20221130
/// Description:消毒包保存 关联消毒包明细
/// Table:CSSD_PackageItem
/// Input: Params\PkgId
/// w ##class(web.CSSDHUI.PackageInfo.PackageItem).AddPkgItm("1019","[{""RowId"":""848"",""itmDr"":""113"",""Desc"":""LYQ-卵圆钳"",""Spec"":""25cm弯有齿"",""Qty"":""3"",""SerialNo"":""1"",""UseFlag"":""Y""}]")
ClassMethod AddPkgItm(PkgId As %String, Params As %String) As %Library.String
{
	n (PkgId,Params)
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	i PkgId="" d RtnObj.Err(-1,"","入参不能为空!")
	q:RtnObj.success'=0 RtnObj
	
	s PJObj=##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 d RtnObj.Err(-2,"","参数解析错误")
	q:RtnObj.success'=0 RtnObj
	
	while(RtnObj.success=0){
		s Obj=PJObj.%Pop()
		q:Obj=""
		
		s ItmId=Obj.%Get("ItmId")
		s RowId=Obj.%Get("RowId")
		s Qty=Obj.%Get("Qty")
		s SerialNo=Obj.%Get("SerialNo")
		
		i ItmId="" d RtnObj.Err(-1,RowId,"明细项目不可为空!")
		continue:RtnObj.success'=0
		
		s ItmDesc=$lg(^User.CSSDItemD(ItmId),2)
		s RepeatId=$o(^User.CSSDPackageItemI("CSSDPIPackageItmIndex",PkgId,ItmId,""))
		i ((RepeatId'="")&&(RepeatId'=RowId)) d RtnObj.Err(-1,RowId,"存在重复的明细项目:"_ItmDesc)
		continue:RtnObj.success'=0
		
		s maxSerialNo = 0
		&sql(SELECT max(CSSDPI_SORT) into :maxSerialNo FROM CSSD_PackageItem WHERE CSSDPI_Package_DR = :PkgId)
		i SerialNo <= maxSerialNo d		;新增明细时,默认序号为最大,修改已存在明细时不修改序号
		.s SerialNo = maxSerialNo+1
		s PkgItmId=PkgId_"||"_ItmId
		i (RowId="") d
		.&sql(Insert into CSSD_PackageItem(CSSDPI_Itm_Dr,CSSDPI_Rowid,CSSDPI_Package_Dr,CSSDPI_Qty,CSSDPI_SORT) values(:ItmId,:PkgItmId,:PkgId,:Qty,:SerialNo))
		.i SQLCODE'=0 D
		..d RtnObj.Err(-2,PkgItmId,$ClassName()_".jsAddPkgItm:SQLCODE"_SQLCODE_":"_$g(%msg))
		e  d
		.&sql(update CSSD_PackageItem set CSSDPI_Itm_Dr=:ItmId,CSSDPI_Rowid=:PkgItmId,CSSDPI_Package_Dr=:PkgId,CSSDPI_Qty=:Qty where ID=:RowId)
		.i SQLCODE'=0 D
		..d RtnObj.Err(-3,RowId,$ClassName()_".jsAddPkgItm:SQLCODE"_SQLCODE_":"_$g(%msg))
		continue:RtnObj.success'=0
		s RtnObj=..sortItmNo(PkgId)
		continue:RtnObj.success'=0
	}
	q RtnObj
}

ClassMethod sortItmNo(PkgId As %String) As web.CSSDHUI.RtnObj
{
	n (PkgId)
	s RtnObj=##Class(web.CSSDHUI.RtnObj).%New()
	i PkgId="" q RtnObj.Err(-1,"","参数错误!")
	s pid=..NewPid()
	k ^TMPCSSD(pid)
	s PkgItmId=""
	f  s PkgItmId=$o(^User.CSSDPackageItemI("CSSDPIPackageIndex",PkgId,PkgItmId)) q:PkgItmId=""  d
	.s PkgItmObj=""
	.s PkgItmObj=##class(User.CSSDPackageItem).%OpenId(PkgItmId)
	.d PkgItmObj.%Reload()
	.q:PkgItmObj=""
	.s ItmId=PkgItmObj.CSSDPIItmDRGetObjectId()
	.s sort=PkgItmObj.CSSDPISORT
	.q:ItmId=""
	.i sort="" s sort=$g(lastSort)+0.01
	.s lastSort=sort
	.s ^TMPCSSD(pid,"PackageItem",sort)=PkgItmId
	
	s (Sort,TmpId)=0
	f  s TmpId=$o(^TMPCSSD(pid,"PackageItem",TmpId)) q:(TmpId="")||(RtnObj.success<0)  d
	.s PkgItmId=^TMPCSSD(pid,"PackageItem",TmpId)
	.s Sort=Sort+1
	.&sql(update CSSD_PackageItem set CSSDPI_SORT=:Sort where ID=:PkgItmId)
	.i SQLCODE<0 d RtnObj.Err(-1,"","修改排序失败:"_SQLCODE) q
	k ^TMPCSSD(pid)
	q RtnObj
}

ClassMethod UpItem(ItemId As %Integer, sort As %Integer)
{
	n (ItemId,sort)
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	s PackageDr=""
	&sql(SELECT CSSDPI_Package_DR INTO :PackageDr From CSSD_PackageItem WHERE ID=:ItemId)
	s MinSort=""
	&sql(SELECT Min(CSSDPI_SORT)INTO :MinSort From CSSD_PackageItem WHERE CSSDPI_Package_DR=:PackageDr)
	i (sort=MinSort) d
	.d RtnObj.Err(-1,"","该明细无法向上移动")
	q:RtnObj.success'=0 RtnObj.Json()
	&sql(UPDATE CSSD_PackageItem SET CSSDPI_SORT=CSSDPI_SORT+1 WHERE CSSDPI_Package_DR=:PackageDr AND CSSDPI_SORT=:sort-1)
	&sql(UPDATE CSSD_PackageItem SET CSSDPI_SORT=CSSDPI_SORT-1 WHERE ID=:ItemId )
	q RtnObj.Json()
}

ClassMethod DownItem(ItemId As %Integer, sort As %Integer)
{
	n (ItemId,sort)
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	s PackageDr=""
	&sql(SELECT CSSDPI_Package_DR INTO :PackageDr From CSSD_PackageItem WHERE ID=:ItemId)
	s MaxSort=""
	&sql(SELECT Max(CSSDPI_SORT) INTO :MaxSort From CSSD_PackageItem WHERE CSSDPI_Package_DR=:PackageDr)
	i (sort=MaxSort) d
	.d RtnObj.Err(-1,"","该明细无法向下移动")
	q:RtnObj.success'=0 RtnObj.Json()
	&sql(UPDATE CSSD_PackageItem SET CSSDPI_SORT=CSSDPI_SORT-1 WHERE CSSDPI_Package_DR=:PackageDr AND CSSDPI_SORT=:sort+1)
	&sql(UPDATE CSSD_PackageItem SET CSSDPI_SORT=CSSDPI_SORT+1 WHERE ID=:ItemId)
	q RtnObj.Json()
}

/// Return:		RtnObj.Json()
/// Description:删除包明细
/// Creator:	ban
/// Date:		2019-12-23
/// Table:		CSSD_PackageItem
/// Input:		Params
/// Output:		RtnObj
/// d ##class(web.CSSDHUI.PackageInfo.PackageItem).DeleteDetail("{""Rowid"":""9"",""LocCode"":""ZYMZ006"",""LocId"":""6"",""LocDesc"":""肝病门诊""}")
ClassMethod DeleteDetail(Params As %String) As web.CSSDHUI.RtnObj
{
	n (Params)
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	s PJObj=##class(web.CSSDHUI.Common.FromJson).%New()
	s sc=PJObj.%FromJSON(Params)
	i sc'=0 d
	.s sc=RtnObj.Err(-1,"","入参解析失败!")
	q:RtnObj.success'=0 RtnObj
	s Obj=PJObj.%Pop()
	s Rowid=Obj.%Get("RowId")
	&sql(Delete from CSSD_PackageItem where ID=:Rowid)
	i SQLCODE'=0  d
	.s Sc=RtnObj.Err(-11,"",$ClassName()_".Delete:SQLCODE"_SQLCODE_":"_$g(%msg))
	q:RtnObj.success'=0 RtnObj
	q RtnObj
}

ClassMethod jsDeleteDetail(Params As %String) As %Library.String
{
	n (Params)
	s $ZT=..sssError()
	ts
	s RtnObj=..DeleteDetail(Params)
	i RtnObj.success=0 d
	.tc
	e  d
	.tro
	q RtnObj.Json()
}

}
