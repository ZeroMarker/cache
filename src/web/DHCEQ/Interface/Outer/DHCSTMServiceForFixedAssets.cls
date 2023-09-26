Import sqluser

/// Descript:	东华固定资产维修配件接口程序
/// 				注意 参数UseBudgFlag 控制
/// Creator:	wfg
/// CreateDate:	2019-7-1
Class web.DHCEQ.Interface.Outer.DHCSTMServiceForFixedAssets Extends (%RegisteredObject, web.DHCSTMHUI.StkTypeM) [ Not ProcedureBlock ]
{

Parameter UseBudgFlag = "Y";

/// 获取类组信息 根据登录科室或者请领科室获取已经授权的类组
/// d ##class(web.DHCEQ.Interface.Outer.DHCSTMServiceForFixedAssets).SelectAuthorScg("")
ClassMethod SelectAuthorScg(gLocId, StkDesc As %String)
{
    n (gLocId,StkDesc)
    s Type=..sssCode()
    s gUserId=""
    ;s CatGrpStr=##class(web.DHCSTM.Util.DrugUtil).GetUserCatGrpStr(gUserId,..sssCode(),gLocId,"") 
	s CatGrpStr=##class(web.DHCSTMHUI.Util.DrugUtil).GetUserCatGrpStr(gUserId,..sssCode(),gLocId,"") 	//czf 2021-01-30 1747240
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "SELECT SCG_ROWID as Rowid,SCG_CODE as Code,SCG_DESC as Description,SCG_SpReq as SpReq,SCG_Set as SCGSet FROM DHC_StkCatGroup WHERE SCG_Type ="_"'"_Type_"'"
	d result.Prepare(sqlStr)
	d result.Execute()
	s count = 0
	;s json = ##class(web.DHCSTM.Common.JsonObj).%New()	//czf 2021-01-30 1747240
	s json = ##class(web.DHCSTMHUI.Common.JsonObj).%New()
	While(result.Next())
	{
		s Rowid = result.Data("Rowid")
		continue:CatGrpStr'[Rowid
		s Code = result.Data("Code")
		s Description = result.Data("Description")
		continue:((StkDesc'="")&(Description'[StkDesc))
		s SpReq= result.Data("SpReq")
		s SCGSet= result.Data("SCGSet")
		s tmp=Rowid_"^"_Code_"^"_Description_"^"_SpReq_"^"_SCGSet
		s count = count+1
		d json.InsertRowData(tmp)
	}
	d result.Close()
	d json.getJsonData("RowId^Code^Desc^SpReq^SCGSet",count)
	k json
}

/// 获取库存项
/// d ##class(web.DHCEQ.Interface.Outer.DHCSTMServiceForFixedAssets).GetItmByDesc("541","","")
ClassMethod GetItmByDesc(gLocId, InciDesc As %String, StkCatGroupId As %String) As %Library.String
{
	n (gLocId,InciDesc,StkCatGroupId)
	
	s InciDesc=$$ALPHAUP^SSUTIL4(InciDesc)
	s gUserId="" ;暂时不考虑个人权限
	;s CatGrpStr=##class(web.DHCSTM.Util.DrugUtil).GetUserCatGrpStr(gUserId,..sssCode(),gLocId,"")	//czf 2021-01-30 1747240
	s CatGrpStr=##class(web.DHCSTMHUI.Util.DrugUtil).GetUserCatGrpStr(gUserId,..sssCode(),gLocId,"")
	;q:InciDesc="" ""
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "select INCI_RowId from INC_Itm where %ALPHAUP(INCI_DESC) like '%"_InciDesc_"%'"
	d result.Prepare(sqlStr)
	s sc=result.Execute()
	s err=$$$ISERR(sc) i err q ""
	s sHospID=""
	;s json = ##class(web.DHCSTM.Common.JsonObj).%New()	//czf 2021-01-30 1747240
	s json = ##class(web.DHCSTMHUI.Common.JsonObj).%New()
	s count = 0
	While(result.Next())
	{
		s InciId = result.Data("INCI_RowId")
		continue:'$d(^INCI(InciId,1))||'$d(^INCI(InciId,2))||'$d(^INCI(InciId,3))
		;b
		s Incsc=$p(^INCI(InciId,2),"^",2)
		continue:Incsc=""
		s StkType=$p($G(^INC("SC",Incsc)),"^",3)
		continue:StkType'=..sssCode()
		continue:'..IsInCatGrpStr(InciId,$G(CatGrpStr))	;类组权限过滤
		;s groupInfo=##class(web.DHCSTM.Common.DrugInfoCommon).GetIncStkCatGrp(InciId)	//czf 2021-01-30 1747240
		s groupInfo=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncStkCatGrp(InciId)
		s Type=$p(groupInfo,"^",2)
		s Name=$p(^INCI(InciId,1),"^",2)
		s InfoRowId=$o(^DHCITMINFO(0,"INCI",InciId,""))
		.i InfoRowId'=""   d
		..s InfoData=$G(^DHCITMINFO(InfoRowId))
		..s Model=$p(InfoData,"^",59)
		..s Brand=$p(InfoData,"^",58)
		
		s PurUomId=$p(^INCI(InciId,3),"^",6)
		s BUomId=$p(^INCI(InciId,1),"^",10)
		s:BUomId'="" BUomDesc=$p($g(^CT("UOM",BUomId)),"^",2)
		s:PurUomId'="" Unit=$p($g(^CT("UOM",PurUomId)),"^",2)
		s Price=##class(web.DHCSTMHUI.Common.PriceCommon).GetInciBasicRp(InciId,+$h,PurUomId,sHospID)
		s VendorStr=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetPbVendor(+InciId)
		s Vendor=$p(VendorStr,"^",2)
		s ManfInfo=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetPbManf(+InciId)
		s Manufacturer=$p(ManfInfo,"^",2)
		s Num=1
		s StoreLoc=""
		s count = count+1
		s DataStr=Type_"^"_Name_"^"_$g(Model)_"^"_Num_"^"_Price_"^"_$g(Unit)_"^"_Vendor_"^"_Manufacturer_"^"_$g(Brand)_"^"_StoreLoc
		d json.InsertRowData(DataStr)
		
	}
	
	s TitleStr="Type^Name^Model^Num^Price^Unit^Vendor^Manufacturer^Brand^StoreLoc"
	d json.getJsonData(TitleStr,count)
	k json
	q ""
}

/// 生成请领单
/// req  请领单rowid
/// reqInfo  格式:供应科室rowid^请求科室rowid^请求人rowid^类组rowid^
/// ListData 请领多个配件时明细数据,格式: 请求单明细ID^incirowid(库存项rowid)^单位rowid^数量^备注^类组^规格
/// 多条数据之间用$c(1)分隔
/// modified by czf 2021-01-30 1747240
/// reqInfo:json字符串,形如："{""RowId"":"""",""SupLoc"":""2"",""ReqLoc"":""10"",""gUserId"":""1132"",""ScgStk"":""1""}"
/// ListData:数组字符串，形如：[{"BUomId":"5","Ibci":"123","Qty":"2","Scg":"1"},{"BUomId":"2","Ibci":"111","Qty":"1","Scg":"2"}]
/// w ##class(web.DHCSTMService.FixedAssets.ServiceForFixedAssets).CreatReq(incsc)
ClassMethod CreatReq(req As %String, reqInfo As %String, ListData As %String) As %Library.String
{
	n (req,reqInfo,ListData)
	
	;s MainId=##class(web.DHCSTM.INRequest).Save(req,reqInfo,ListData)
	s MainId=##class(web.DHCSTMHUI.INRequest).Save(reqInfo,ListData)	//czf 2021-01-30 1747240
	
	q MainId
}

ClassMethod IsInCatGrpStr(inci As %String, CatGrpStr As %String) As %String
{
 n (inci,CatGrpStr)
 q:inci="" 0
 q:CatGrpStr="" 0
 s incsc=$p($G(^INCI(inci,2)),"^",2)
 q:incsc="" 0
#; s catgrp=$o(^DHCSCG("STKCAT",incsc,"")
 ;s catgrp=##class(web.DHCSTM.Common.DrugInfoCommon).GetParSCG(incsc)
 s catgrp=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetParSCG(incsc)	//czf 2021-01-30 1747240
 i ("^"_CatGrpStr_"^")[("^"_catgrp_"^") q 1
 q 0
}

/// Creator：2019-08-14 CZF0091
/// Description：物资配件接口
/// Input:
/// Command:d ##class(%ResultSet).RunQuery("web.DHCEQ.Interface.Outer.DHCSTMServiceForFixedAssets","GetAccessoryType","","")
Query GetAccessoryType(gLocId As %Library.String = "", AccessoryType As %Library.String = "") As %Query(ROWSPEC = "TName:%String,TRowID:%String,TCode:%String")
{
}

ClassMethod GetAccessoryTypeExecute(ByRef qHandle As %Binary, gLocId As %Library.String = "", AccessoryType As %Library.String = "") As %Status
{
 	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)

	s index=1
	;s StkType=##Class(web.DHCSTM.StkTypeM).sssCode()
	s StkType=##Class(web.DHCSTMHUI.StkTypeM).sssCode()		//czf 2021-01-30 1747240
    s gUserId=""
	s SCGID=0
	f  s SCGID=$o(^DHCSCG(SCGID)) q:SCGID=""  d
	.;s CatGrpStr=##class(web.DHCSTM.Util.DrugUtil).GetUserCatGrpStr(gUserId,StkType,gLocId,"")	;可访问类组	//czf 2021-01-30 1747240
	.s CatGrpStr=##class(web.DHCSTMHUI.Util.DrugUtil).GetUserCatGrpStr(gUserId,StkType,gLocId,"")	;可访问类组
	.q:(CatGrpStr'="")&&(CatGrpStr'[SCGID)
	.d ResetVariablesGetAccessoryTypeNew
	.s RowID=SCGID
	.s Code=$p($g(^DHCSCG(RowID)),"^",1)
	.s Desc=$p($g(^DHCSCG(RowID)),"^",2)
	.q:Desc=""
	.q:((AccessoryType'="")&(Desc'[AccessoryType))
	.s Type=$p($g(^DHCSCG(RowID)),"^",3)
	.q:Type'=StkType
	.s SCGSet=$p($g(^DHCSCG(RowID)),"^",5)
	.s SpReq=$p($g(^DHCSCG(RowID)),"^",6)
	.d OutputRowGetAccessoryTypeNew
	
	Quit $$$OK
OutputRowGetAccessoryTypeNew
	s Data=$lb(Desc,RowID,Code)
  	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetAccessoryTypeNew
	s (Desc,RowID,Code)=""
	quit
}

ClassMethod GetAccessoryTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAccessoryTypeExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 		}
 	Else      {
 		Set Row=^CacheTemp(repid,ind)
 		}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetAccessoryTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAccessoryTypeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Creator：2019-08-14 CZF0091
/// Description：物资库存项
/// Input:
/// Command:d ##class(%ResultSet).RunQuery("web.DHCEQ.Interface.Outer.DHCSTMServiceForFixedAssets","GetAccessoryList","","生物","","1")
Query GetAccessoryList(gLocId As %String = "", InciDesc As %String = "", StkCatGroupId As %String = "", AccesoryType As %String = "") As %Query(ROWSPEC = "TDesc:%String,TRowID:%String,TType:%String,TModel:%String,TNum:%String,TCurBPrice:%String,TBaseUOM:%String,TProvider:%String,TManuFactory:%String,TBrand:%String,TTypeDR:%String,TProviderDR:%String,TManuFactoryDR:%String")
{
}

ClassMethod GetAccessoryListExecute(ByRef qHandle As %Binary, gLocId As %String = "", InciDesc As %String = "", StkCatGroupId As %String = "", AccesoryType As %String = "") As %Status
{
 	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	i AccesoryType="" quit $$$OK

    s InciDesc=$$ALPHAUP^SSUTIL4(InciDesc)
	s gUserId="" ;暂时不考虑个人权限
	s sHospID=""	
	;s StkTypeM=##Class(web.DHCSTM.StkTypeM).sssCode()	//czf 20210-01-30 1747240
	;s CatGrpStr=##class(web.DHCSTM.Util.DrugUtil).GetUserCatGrpStr(gUserId,StkTypeM,gLocId,"")
	s StkTypeM=##Class(web.DHCSTMHUI.StkTypeM).sssCode()
	s CatGrpStr=##class(web.DHCSTMHUI.Util.DrugUtil).GetUserCatGrpStr(gUserId,StkTypeM,gLocId,"")
	
	s (Model,Brand,Unit)=""
    s StkCatDR=0
    f  s StkCatDR=$o(^INCI(0,"StkCat",StkCatDR)) q:StkCatDR=""  d
    .q:(StkCatGroupId'="")&&(StkCatGroupId'=StkCatDR)
    .s InciId=0	//INC_StkCat库存项类型
	.f  s InciId=$o(^INCI(0,"StkCat",StkCatDR,InciId)) q:InciId=""  d
	..d ResetVariablesGetAccessoryItem
	..q:'$d(^INCI(InciId,1))||'$d(^INCI(InciId,2))||'$d(^INCI(InciId,3))
	..s Incsc=$p(^INCI(InciId,2),"^",2)		;INC_Itm:INCI_INCSC_DR->INC_StkCat
	..q:Incsc=""
	..;s catgrp=##class(web.DHCSTM.Common.DrugInfoCommon).GetParSCG(Incsc)	//czf 2021-01-30 1747240
	..s catgrp=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetParSCG(Incsc)
 	..q:("^"_CatGrpStr_"^")[("^"_catgrp_"^")	;类组权限过滤
	..s StkType=$p($G(^INC("SC",Incsc)),"^",3)	;INC_StkCat:INCSC_sktType
	..q:StkType'=StkTypeM
	..;s groupInfo=##class(web.DHCSTM.Common.DrugInfoCommon).GetIncStkCatGrp(InciId)  ;库存项类组信息	czf 2021-01-30 1747240
	..s groupInfo=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncStkCatGrp(InciId)  ;库存项类组信息
	..s STMType=$p(groupInfo,"^",2)	;类组名称			//czf 2021-04-21 1879416 begin
	..s STMTypeDR=$p(groupInfo,"^",5)	;类组ID
	..q:(AccesoryType)'=""&&(AccesoryType'=STMTypeDR)		//20190929
	..s STMName=$p(^INCI(InciId,1),"^",2)	;库存项名称
	..q:(InciDesc'="")&&(STMName'[InciDesc)
	..s InfoRowId=$o(^DHCITMINFO(0,"INCI",InciId,""))
	..i InfoRowId'=""   d
	...s InfoData=$G(^DHCITMINFO(InfoRowId))
	...s STMModel=$p(InfoData,"^",59)
	...s STMBrand=$p(InfoData,"^",58)
	..s PurUomId=$p(^INCI(InciId,3),"^",6)
	..s BUomId=$p(^INCI(InciId,1),"^",10)
	..s:BUomId'="" BUomDesc=$p($g(^CT("UOM",BUomId)),"^",2)
	..s:PurUomId'="" STMUnit=$p($g(^CT("UOM",PurUomId)),"^",2)	;单位
	..;s Price=##class(web.DHCSTM.Common.PriceCommon).GetInciBasicRp(InciId,+$h,PurUomId,sHospID)	//czf 2021-01-30 1747240 begin
	..;s VendorStr=##class(web.DHCSTM.Common.DrugInfoCommon).GetPbVendor(+InciId)
	..s STMPrice=##class(web.DHCSTMHUI.Common.PriceCommon).GetInciBasicRp(InciId,+$h,PurUomId,sHospID)
	..s VendorStr=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetPbVendor(+InciId)
	..s STMVendor=$p(VendorStr,"^",2)
	..i STMVendor'="" s STMVendorID=##Class(web.DHCEQForTrak).UpdProvider("^"_STMVendor_"^^^2")
	..;s ManfInfo=##class(web.DHCSTM.Common.DrugInfoCommon).GetPbManf(+InciId)
	..s ManfInfo=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetPbManf(+InciId)	//czf 2021-01-30 1747240 end
	..s STMManufacturer=$p(ManfInfo,"^",2)
	..i STMManufacturer'="" s STMManufacturerID=##Class(web.DHCEQForTrak).UpdProvider("^"_STMManufacturer_"^^^3")
	..s STMNum=1
	..d OutputRowGetAccessoryItem
	Quit $$$OK
OutputRowGetAccessoryItem
	s Data=$lb(STMName,InciId,STMType,STMModel,STMNum,STMPrice,STMUnit,STMVendor,STMManufacturer,STMBrand,STMTypeDR,STMVendorID,STMManufacturerID)
  	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetAccessoryItem
	s (STMType,STMName,STMModel,STMNum,STMPrice,STMUnit,STMVendor,STMManufacturer,STMBrand,STMTypeDR,STMVendorID,STMManufacturerID)=""		//czf 2021-04-21 1879416 end
	quit
}

ClassMethod GetAccessoryListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAccessoryListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 		}
 	Else      {
 		Set Row=^CacheTemp(repid,ind)
 		}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetAccessoryListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAccessoryListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

}
