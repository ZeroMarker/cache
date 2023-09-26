Import sqluser

Class web.CSSDHUI.PackageDisp.DispItm Extends (%RegisteredObject, web.CSSDHUI.CSSDType) [ Not ProcedureBlock ]
{

/// CreatDate:2023-02-23
/// Description:获取发放明细-该方法"按单据发放/消毒包发放/消毒包调拨/消毒包接收"四个页面调用(修改需留意)
/// Table:CSSD_PackageDisp,CSSD_PackageDispDetail
/// Input:MainId:发放主表id，Flag：按单据发放页面传Y，其它页面传空
/// d ##class(%ResultSet).RunQuery("web.CSSDHUI.PackageDisp.DispItm","SelectByF","26","Y")
Query SelectByF(MainId As %String, Flag As %String = "") As web.CSSDHUI.Query(ROWSPEC = "RowId:%Integer,PackageDR,PackageName,Qty:%Integer,Label,ToUserDesc,Price:%Float,PackMaterial,PackMaterialName,TotalPrice:%Float,LevelFlag,DispDetailId,CallBackDetailDr,UnDispQty,DispQty,CBUnDispQty,ExpDate,CSSDTDate,RecDate") [ SqlProc ]
{
}

ClassMethod SelectByFExecute(ByRef qHandle As %Binary, MainId As %String, Flag As %String = "") As %Status
{
	n (qHandle,MainId,Flag,%session)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	q:MainId="" $$$OK
	s MainObj=##class(User.CSSDPackageDispMain).%OpenId(MainId)
	q:'$IsObject(MainObj) $$$OK
	
	s ItemRowId=""
	f  s ItemRowId=$o(^User.CSSDPackageDispI("CSSDPDCParrefDr",MainId,ItemRowId)) q:ItemRowId=""  d
	.s ItemObj=##Class(User.CSSDPackageDisp).%OpenId(ItemRowId)
	.d ItemObj.%Reload()
	.q:'$IsObject(ItemObj)
	.s PackageObj=ItemObj.CSSDPDPackage
	.s PackMaterialObj=ItemObj.CSSDPDPackMaterial
	.s Qty=ItemObj.CSSDPDQty
	.s LevelFlag=ItemObj.CSSDPDLevelFlag
	.s CBItmId=ItemObj.CSSDPDPackageCallBackDetailGetObjectId()
	.s UnDispQty=ItemObj.CSSDPDUnDispQty
	.s DispQty=ItemObj.CSSDPDDispQty
	.s RecDate=ItemObj.CSSDPDReceiveDate
	.
	.s CBUnDispQty=0
	.i CBItmId'="" d
	..s CBItmObj=##Class(User.CSSDCallbackDetailNew).%OpenId(CBItmId)
	..d CBItmObj.%Reload()
	..s CBQty=CBItmObj.CSSDCDQty
	..s CBDispQty=CBItmObj.CSSDCDDispQty
	..s CBUnDispQty=CBQty-CBDispQty
	.
	.q:'$IsObject(PackageObj)
	.s PkgId=PackageObj.%Id()
	.s PackageName=PackageObj.CSSDPDesc
	.s PackageName=..%FieldTranslate("User.CSSDPackage","CSSDPDesc",PackageName)
	.
	.i $IsObject(PackMaterialObj) d
	..s PackMaterial=PackMaterialObj.%Id()
	..s PackMaterialDesc=PackMaterialObj.CSSDMDesc
	.e  d ;取消毒包的默认包装材料
	..s PackMaterial=##Class(web.CSSDHUI.Common.PackageInfoCommon).GetDefaultMaterial(PkgId)
	..s PkgDefMObj=##class(User.CSSDMaterial).%OpenId(PackMaterial)
	..s PackMaterialDesc=$s($ISOBJECT(PkgDefMObj):PkgDefMObj.CSSDMDesc,1:"")
	.s PackMaterialDesc=..%FieldTranslate("User.CSSDMaterial","CSSDMDesc",PackMaterialDesc)
	.
	.s TotalPrice=0,Price=0
	.s MatInfo=##Class(web.CSSDHUI.Common.PackageInfoCommon).GetMaterialExpireLength(PackMaterial,PkgId)
	.s:MatInfo'="" Price=$p(MatInfo,"^",2)
	.s TotalPrice = Qty*Price
	.
	.s count=0
	.i Flag'="Y" d			// 按单据发放模式
	..s DetailRowId = ""
	..f  s DetailRowId=$o(^User.CSSDPackageDispDetailI("CSSDPDDParref",ItemRowId,DetailRowId)) q:(DetailRowId="")  d
	...s DetailObj=##Class(User.CSSDPackageDispDetail).%OpenId(DetailRowId)
	...d DetailObj.%Reload()
	...q:'$IsObject(DetailObj)
	...s ToUserDesc=""
	...s RowId=DetailRowId
	...s Label=DetailObj.CSSDPDDLabel
	...s DetailUserObj=DetailObj.CSSDPDRecUser
	...i $IsObject(DetailUserObj) s ToUserDesc=DetailUserObj.SSUSRName
	...s ToUserDesc=..%FieldTranslate("User.SSUser","SSUSRName",ToUserDesc)
	...s DispDetailId=DetailRowId
	...s Qty=1
	...s count=count+1
	...d OutPutItemRow
	.
	.i count=0 d
	..s DispDetailId=""
	..s RowId=ItemRowId
	..s Label=ItemObj.CSSDPDLabel
	..s ToUserObj=ItemObj.CSSDPDToUserDr
	..s ToUserDesc=""
	..i $IsObject(ToUserObj) s ToUserDesc=ToUserObj.SSUSRName
	..s ToUserDesc=..%FieldTranslate("User.SSUser","SSUSRName",ToUserDesc)
	..d OutPutItemRow

	Quit $$$OK

OutPutItemRow
	s ExpDate="",CSSDTDate=""
	i Label'="" d
	.s TransId=$o(^User.CSSDTransI("CSSDTLabel",Label,0))
	.s TransObj=##class(User.CSSDTrans).%OpenId(TransId)
	.q:'$IsObject(TransObj)
	.s CSSDTDate=TransObj.CSSDTDate
	.s ExpDate=TransObj.CSSDTExpDate
	.s CSSDTDate=..DL2H(CSSDTDate)
	.s ExpDate=..DL2H(ExpDate)
	s Data=$lb(RowId,PkgId,PackageName,Qty,Label,ToUserDesc,Price,PackMaterial,PackMaterialDesc,TotalPrice,LevelFlag,DispDetailId,CBItmId,UnDispQty,DispQty,CBUnDispQty,ExpDate,CSSDTDate,RecDate)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// 获取发放单的消毒包汇总数据
/// d ##class(%ResultSet).RunQuery("web.CSSDHUI.PackageDisp.DispItm","DispItmSum",56)
Query DispItmSum(DispId As %String) As web.CSSDHUI.Query(ROWSPEC = "PackageId,PackageCode,PackageName,Qty:%Float") [ SqlProc ]
{
}

ClassMethod DispItmSumExecute(ByRef qHandle As %Binary, DispId As %String) As %Status
{
	n (qHandle,DispId,%session)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	q:DispId="" $$$OK
	
	s SqlStr="SELECT CSSDPD_Package_DR as PackageId, CSSDPD_Package_DR->CSSDP_Code PackageCode, CSSDPD_Package_DR->CSSDP_Desc PackageName, sum(CSSDPD_Qty) as Qty"
		_" FROM CSSD_PackageDisp"
		_" WHERE CSSDPD_Parref_DR ="_DispId
		_" GROUP BY CSSDPD_Package_DR ORDER BY CSSDPD_Package_DR->CSSDP_Desc"
	s Result=##class(%Library.ResultSet).%New()
	d Result.RuntimeModeSet(0)
	d Result.Prepare(SqlStr)
	d Result.Execute()
	While(Result.Next())
	{
		s PackageId=Result.Data("PackageId")
		s PackageCode=Result.Data("PackageCode")
		s PackageName=Result.Data("PackageName")
		s Qty=Result.Data("Qty")
		d OutPutItmSum
	}
	Quit $$$OK

OutPutItmSum
	s Data=$lb(PackageId,PackageCode,PackageName,Qty)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// CreatDate:2023-02-22
/// Description:删除发放明细-该方法"按单据发放/消毒包发放/消毒包调拨"三个页面调用(修改需留意)
/// Table:CSSD_PackageDisp
/// d ##class(web.CSSDHUI.PackageDisp.DispItm).jsDelete("71","95")
ClassMethod jsDelete(Params As %String) As %Library.String
{
	n (Params)
	s $ZT=..sssError()
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	ts
	s PJObj=##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	q:Sc'=0 RtnObj.Err(-1,"",..%Translate($CLASSNAME(),"入参解析失败!")).Json()

	while(RtnObj.success=0){
		s Obj=PJObj.%Pop()
		q:Obj=""
		s DispId=Obj.%Get("RowId")
		continue:DispId=""
		s RtnObj=..Delete(DispId)
		q:RtnObj.success'=0
	}
	i RtnObj.success<0 tro  q RtnObj.Json()
	tc
	q RtnObj.Json()
}

ClassMethod Delete(DispId As %String) As web.CSSDHUI.RtnObj
{
	n (DispId)
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	i DispId="" d RtnObj.Err(-1,"","入参不能为空!")
	q:RtnObj.success'=0 RtnObj

	s MainId=""
	&sql(SELECT CSSDPD_Parref_DR INTO:MainId FROM CSSD_PackageDisp WHERE CSSDPD_Rowid=:DispId)
	i SQLCODE'=0 d RtnObj.Err(-1,"","明细对应的单据不存在!")
	q:RtnObj.success'=0 RtnObj
	s ComplateFlag=$lg(^User.CSSDPackageDispMainD(MainId),9)
	i ComplateFlag="Y" q RtnObj.Err(-1,"","单据已提交不允许删除!")
	q:RtnObj.success'=0 RtnObj

	s DispObj=##class(User.CSSDPackageDisp).%OpenId(DispId)
	i '$IsObject(DispObj) d RtnObj.Err(-2,"",..%Translate($CLASSNAME(),"未获取到发放信息！"))
	q:RtnObj.success'=0 RtnObj
	d DispObj.%Reload()
	s PackageObj=DispObj.CSSDPDPackage
	s Label=DispObj.CSSDPDLabel
	s DocType=DispObj.CSSDPDParrefDr.CSSDPDMDocType
	s Type=DispObj.CSSDPDParrefDr.CSSDPDMType

	i Type="Y" d
	.&sql(delete from CSSD_PackageDisp WHERE %Id=:DispId)
	.i SQLCODE'=0  d
	..d RtnObj.Err(-3,"",$ClassName()_"Delete:"_..%Translate($CLASSNAME(),"此明细删除失败!"))
	.q:RtnObj.success'=0
	.i DocType=1 d	// 调拨单
	..s Status="R"
	..s RtnObj=..UpdateWLStatus(Label,Status)
	..q:RtnObj.success'=0
	..&sql(update cssd_trans set CSSDT_Trf_DR=null,cssdt_status=:Status where cssdt_label=:Label )
	..i SQLCODE'=0 d RtnObj.Err(-4,"",$ClassName()_"Delete:"_..%Translate($CLASSNAME(),"删除修改条码状态失败!"))
	.e  d			// 新建单据发放
	..s Status="S"
	..s RtnObj=..UpdateWLStatus(Label,Status)
	..q:RtnObj.success'=0
	..s:PackageObj.CSSDPSterType.CSSDSTIsSter'="Y" Status="P"	;针对只清洗不灭菌的情况
	..&sql(update cssd_trans set cssdt_disp_dr=null,cssdt_status=:Status where cssdt_label=:Label )
	..i SQLCODE'=0 d RtnObj.Err(-4,"",$ClassName()_"Delete:"_..%Translate($CLASSNAME(),"删除修改条码状态失败!"))
	e  d				// 按单据发放
	.s detailId=$o(^User.CSSDPackageDispDetailI("CSSDPDDParref",DispId,""))
	.s DispDetailId=""
	.i detailId>0 d
	..f  s DispDetailId=$o(^User.CSSDPackageDispDetailI("CSSDPDDParref",DispId,DispDetailId)) q:(DispDetailId="")||(RtnObj.success'=0)  d
	...q:'$d(^User.CSSDPackageDispDetailD(DispDetailId))
	...s RtnObj=##class(web.CSSDHUI.PackageDisp.DispDetail).Delete(DispDetailId)
	...q:RtnObj.success'=0
	.s PkgDispDetailObj=##Class(User.CSSDPackageDisp).%OpenId(DispId)
	.d PkgDispDetailObj.%Reload()
	.s DispQty=PkgDispDetailObj.CSSDPDQty
	.s CBItmId=PkgDispDetailObj.CSSDPDPackageCallBackDetailGetObjectId()
	.i CBItmId'="" d
	..s CBItmObj=##Class(User.CSSDCallbackDetailNew).%OpenId(CBItmId)
	..d CBItmObj.%Reload()
	..s backQty=CBItmObj.CSSDCDDispQty
	..s ApplyItmId=CBItmObj.CSSDCDPackageApplyDetailDRGetObjectId()
	..s Qty=backQty-DispQty
	..&sql(Delete From CSSD_PackageDisp WHERE CSSDPD_Rowid=:DispId)
	..&sql(Update CSSD_CallBackDetailNew set CSSDCD_DispQty=:Qty where CSSDCD_Rowid=:CBItmId)
	..i ApplyItmId'="" d		// 删除更新请领明细
	...&sql(Update CSSD_PackageApplyDetail set CSSDPAD_OutQty=:Qty where ID=:ApplyItmId)
	.e  d
	..&sql(Delete From CSSD_PackageDisp WHERE CSSDPD_Rowid=:DispId)
	.i SQLCODE'=0  d
	..d RtnObj.Err(-3,rowId,$ClassName()_".Delete:SQLCODE"_SQLCODE_":"_$g(%msg))
	q:RtnObj.success'=0 RtnObj

	q RtnObj
}

/// Creator:ban
/// CreatDate:2022-3-10
/// Description:保存回收单明细	前端调用
/// Table:CSSD_PackageDisp CSSD_CallBackDetailNew CSSD_PackageApplyDetail
/// d ##class(web.CSSDHUI.PackageDisp.DispItm).jsSave()
ClassMethod jsSave(Params As %String, ParamsTB As %String) As %Library.String
{
	n (%session,Params,ParamsTB)
	s $ZT=..sssError()
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	ts
	s RtnObj=..SaveDisp(Params,ParamsTB)
	i RtnObj.success<0 tro  q RtnObj.Json()
	tc
	q RtnObj.Json()
}

/// Creator:why
/// CreatDate:2019-11-5
/// Description:保存回收单明细	前端调用
/// Table:CSSD_PackageDisp	CSSD_CallBackDetailNew	CSSD_PackageApplyDetail
/// d ##class(web.CSSDHUI.PackageDisp.DispItm).Save("33607","[{""PackageName"":""20cm弯钳"",""PackageDR"":""26"",""UnDispQty"":""2""}]")
ClassMethod SaveDisp(Params, ParamsTB) As web.CSSDHUI.RtnObj
{
	n (%session,Params,ParamsTB)
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	i ((ParamsTB="")||(Params="")) d RtnObj.Err(-1,"","入参不能为空!")
	q:RtnObj.success'=0 RtnObj

	s PJObj=##class(web.CSSDHUI.Common.FromJson).%New()
	s TBObj=##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	s TBSc=TBObj.%FromJSON(ParamsTB)
	i ((Sc'=0)||(TBSc'=0)) d
	.s Sc=RtnObj.Err(-2,"","入参解析失败!")
	q:RtnObj.success'=0 RtnObj
	s MainId=TBObj.%Get("MainId")
	s gLocId=TBObj.%Get("gLocId")
	s gUserId=TBObj.%Get("gUserId")
	s gGroupId=TBObj.%Get("gGroupId")
	s gHospId=TBObj.%Get("gHospId")
	i MainId="" q RtnObj.Err(-1,"","参数有误")
	s ToLocId=$lg(^User.CSSDPackageDispMainD(MainId),7)
	
	s Param=gGroupId_"^"_gLocId_"^"_gUserId_"^"_gHospId
	s BarcodeParams=""
	while(RtnObj.success=0){
		s Obj=PJObj.%Pop()
		q:Obj=""
		s BarCode=""
		s RowId=Obj.%Get("RowId")
		s PkgId=Obj.%Get("PackageDR")
		s MaterialId=Obj.%Get("PackMaterial")
		s Qty=Obj.%Get("Qty")							// 要发放数量
		s UnDispQty=Obj.%Get("UnDispQty")				// 未扫码数量
		s DispQty=Obj.%Get("DispQty")					// 已扫码数量
		s CallBackItmId=Obj.%Get("CallBackDetailDr")
		s LevelFlag=Obj.%Get("LevelFlag")
		s PackageObj=##class(User.CSSDPackage).%OpenId(PkgId)
		d PackageObj.%Reload()
		s PkgDesc=PackageObj.CSSDPDesc

		i MaterialId="" d
		.s MaterialId=##class(web.CSSDHUI.Common.PackageInfoCommon).GetDefaultMaterial(PkgId)
		.i MaterialId="" d RtnObj.Err(-1,"",PkgDesc_"未维护默认包装材料!")
		q:RtnObj.success'=0

		s Price=0
		s MatInfo=##class(web.CSSDHUI.Common.PackageInfoCommon).GetMaterialExpireLength(MaterialId,PkgId)
		s:MatInfo'="" Price=$P(MatInfo,"^",2)

		i Qty<DispQty  d RtnObj.Err(-10,"","修改发放数小于已扫码数！请核对重新输入！")
		q:RtnObj.success'=0
		s IfMoreDispQty=##class(web.CSSDHUI.Common.AppCommon).GetParamValue("CSSDDISP","IfMoreDispQty",Param)
		i CallBackItmId'="" d
		.s CallBackItmObj=##class(User.CSSDCallbackDetailNew).%OpenId(CallBackItmId)
		.s CodeDict=CallBackItmObj.CSSDPCDictLabel
		.s CallBackQty=CallBackItmObj.CSSDCDQty							// 回收数量
		.s ApplyDetailId=CallBackItmObj.CSSDCDPackageApplyDetailDRGetObjectId()
		.s CallBackDispQty=..GetCallBackDispQty(CallBackItmId,RowId)	// 已生成发放数量
		.s PreDispQty=CallBackQty-CallBackDispQty						// 可以发放的数量
		.i IfMoreDispQty="N" d
		..i (Qty>PreDispQty) d RtnObj.Err(-10,"","发放数不能超过单据未发数!")
		.q:RtnObj.success'=0
		.i DispQty="" s DispQty=0
		.s UnDispQty=Qty-DispQty
		.
		.// 标牌追溯包判断标牌
		.i CodeDict'="" d
		..s CleanItmId=$o(^User.CSSDCleanDetailPacksI("IndexCallBackDetailDr",CallBackItmId,""))
		..i CleanItmId="" d RtnObj.Err(-6,"",CodeDict_"标牌未清洗") q
		..&sql(select CSSDPP_Label into :BarCode from CSSD_PackagePack where CSSDPP_CleanDetail_DR=:CleanItmId)
		..i BarCode="" d RtnObj.Err(-6,"",CodeDict_"标牌未打包")
		.q:RtnObj.success'=0
		.
		.// 更新回收申请表数量
		.s CBDispQty=CallBackDispQty+Qty
		.&sql(Update CSSD_CallBackDetailNew set CSSDCD_DispQty=:CBDispQty where CSSDCD_Rowid=:CallBackItmId)
		.i SQLCODE'=0 d RtnObj.Err(-2,"","更新回收单发放数量失败！")
		.q:RtnObj.success'=0
		.i ApplyDetailId'="" d
		..&sql(Update CSSD_PackageApplyDetail set CSSDPAD_OutQty=:CBDispQty where ID=:ApplyDetailId)
		..i SQLCODE'=0 d RtnObj.Err(-3,"","更新请领单发放数量失败！")
		q:RtnObj.success'=0

		s itmobj=""
		i RowId="" d
		.s itmobj=##class(User.CSSDPackageDisp).%New()
		.d itmobj.CSSDPDParrefDrSetObjectId(MainId)
		e  d
		.s itmobj=##class(User.CSSDPackageDisp).%OpenId(RowId)
		.d itmobj.%Reload()
		s itmobj.CSSDPDDispQty=DispQty
		s itmobj.CSSDPDUnDispQty=UnDispQty
		s itmobj.CSSDPDQty=Qty
		s itmobj.CSSDPDPackage=PackageObj
		s itmobj.CSSDPDPackMaterial=##class(User.CSSDMaterial).%OpenId(MaterialId)
		s itmobj.CSSDPDDispPrice=Price
		s itmobj.CSSDPDLevelFlag=LevelFlag
		d itmobj.CSSDPDPackageCallBackDetailSetObjectId(CallBackItmId)
		d itmobj.CSSDPDToLocDrSetObjectId(ToLocId)
		s Sc=itmobj.%Save()
		i $$$ISERR(Sc) d RtnObj.Err(-5,"",$ClassName()_":jsSave:保存失败!")
		q:RtnObj.success'=0
		s DispId=itmobj.%Id()

		i BarCode'="" d
		.s BarcodeStr="{""DispId"":"""_DispId_""",""Label"":"""_BarCode_""",""gHospId"":"""_gHospId_""",""gGroupId"":"""_gGroupId_""",""gLocId"":"""_gLocId_""",""gUserId"":"""_gUserId_"""}"
		.i BarcodeParams="" d
		..s BarcodeParams=BarcodeStr
		.e  d
		..s BarcodeParams=BarcodeParams_","_BarcodeStr
	}

	// 标牌追溯包直接插入条码明细
	i BarcodeParams'="" d
	.s MainData=MainId_"^"_gUserId_"^"_gGroupId_"^"_gLocId_"^"_gHospId
	.s MainTitle="MainId^gUserId^gGroupId^gLocId^gHospId"
	.s MainParams=##class(web.CSSDHUI.Common.UtilCommon).GetJsonStr(MainData,MainTitle)
	.
	.s BarcodeParams="["_BarcodeParams_"]"
	.s RtnObj=##class(web.CSSDHUI.PackageDisp.DispDetail).SaveDetail(MainParams,BarcodeParams)
	q:RtnObj.success'=0 RtnObj

	q RtnObj
}

/// Decription:依据回收明细id获取已发放数量
/// Creator：lxt
/// CreateDate：20220622
ClassMethod GetCallBackDispQty(CallBackDetailDr, RowId = "")
{
	n (%session,CallBackDetailDr,RowId)
	s CallBackDetailObj=##class(User.CSSDCallbackDetailNew).%OpenId(CallBackDetailDr)
	q:'$IsObject(CallBackDetailObj) 0

	s SumDispQty=0
	s DispId=0
	f  s DispId=$o(^User.CSSDPackageDispI("CSSDPDCallBackDetailIndex",CallBackDetailDr,DispId)) q:DispId=""  d
	.s DispObj=##class(User.CSSDPackageDisp).%OpenId(DispId)
	.q:'$IsObject(DispObj)
	.q:(RowId'="")&&(RowId=DispId)
	.s DispQty=DispObj.CSSDPDQty
	.s SumDispQty=SumDispQty+DispQty

	q SumDispQty
}

/// Creator:why
/// CreatDate:2020-12-10
/// Description:扫码发放-根据外来器械拆包标签判断是否所有关联包全部发放或接收
/// Table:CSSD_PackagePack
/// w ##class(web.CSSDHUI.PackageDisp.DispItm).UpdateWLStatus("100019005000001")
ClassMethod UpdateWLStatus(barcode, State) As web.CSSDHUI.RtnObj
{
	n (barcode,State)
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	s packId=$o(^User.CSSDPackagePackI("CSSDPPLabelIndex",barcode,""))
	i packId="" q RtnObj.Err(-3,"",..%Translate($CLASSNAME(),"未找到该条码信息!"),"",0)
	s PackObj=##Class(User.CSSDPackagePack).%OpenId(packId)
	d PackObj.%Reload()
	s PackageObj=PackObj.CSSDPPPackage
	s packageClass=PackageObj.CSSDPPackClass.%Id()
	s PkgId=PackageObj.%Id()
	s IsExt=##Class(web.CSSDHUI.Common.PackageInfoCommon).GetExtFlag(PkgId)
	q:IsExt'="Y" RtnObj
	s Flag="N",PackId=""
	s FixedLabel=##class(web.CSSDHUI.Common.PackageInfoCommon).GetFixedLabel(barcode)
	s CodeLength=$l(FixedLabel)
	s NewLabel=$E(barcode,1,CodeLength+6)

	f  s PackId=$o(^User.CSSDPackagePackI("CSSDPPNewLabelIndex",NewLabel,PackId)) q:((PackId="")||(Flag="Y"))  d
	.s PackObj=##class(User.CSSDPackagePack).%OpenId(PackId)
	.s Label=PackObj.CSSDPPLabel
	.s transId=$o(^User.CSSDTransI("CSSDTLabel",Label,""))
	.s TransObj=##class(User.CSSDTrans).%OpenId(transId)
	.d TransObj.%Reload()
	.s Status=TransObj.CSSDTStatus
	.i Status'=State s Flag="Y"
	i Flag="N" d
	.&sql(Update CSSD_ExtDevBind set CSSDExt_Status=:State where CSSDExt_Label=:NewLabel)
	.i SQLCODE'=0 d
	..d RtnObj.Err(-5,"",$ClassName()_"UpdateWLStatus:"_..%Translate($CLASSNAME(),"更新外来器械登记表状态失败!"))
	q:RtnObj.success'=0 RtnObj
	q RtnObj
}

}
