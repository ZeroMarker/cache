Import sqluser

/// Descript:	授权书关联库存项信息
Class web.DHCSTMHUI.SupplyChainItm Extends (%RegisteredObject, StkTypeM) [ Not ProcedureBlock ]
{

/// Descript:	查询授权书关联库存项信息
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.SupplyChainItm","QueryChainItm",^tmpbin(22))
Query QueryChainItm(Params As %String) As Query(ROWSPEC = "RowId,InciCode,InciDesc,Spec,PUomDesc") [ SqlProc ]
{
}

ClassMethod QueryChainItmExecute(ByRef qHandle As %Binary, Params As %String) As %Status
{
	n (qHandle,%session,Params)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 q $$$OK
	
	s Parref=PJObj.%Get("Parref")
	q:Parref="" $$$OK
	
	s SqlStr="SELECT ID, SCI_INCI_DR FROM CT_hrp_mat.supplychainItm"
		_" where SCI_ParRef ="_Parref
	s Result=##class(%Library.ResultSet).%New()
	d Result.RuntimeModeSet(0)
	d Result.Prepare(SqlStr)
	s sc=Result.Execute()
	i $$$ISERR(sc) q $$$OK
	while (Result.Next())
	{
		s RowId=Result.Data("ID")
		s InciId=Result.Data("SCI_INCI_DR")
		
		s InciCode=$p(^INCI(InciId,1),"^",1)
		s InciDesc=$p(^INCI(InciId,1),"^",2)
		s PUomId=$p(^INCI(InciId,3),"^",6)
		continue:PUomId=""
		s PUomDesc=$p(^CT("UOM",PUomId),"^",2)
		s Spec=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetSpec("",InciId)
		d OutPutRow
	}
	d Result.Close()
	Quit $$$OK
OutPutRow
	s Data=$lb(RowId,InciCode,InciDesc,Spec,PUomDesc)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// Description:查询未关联授权书的库存项信息
/// CreateDate:	2022-05-13
/// Input:		{Inci:**,InciDesc:**,Manf:**,Vendor:**}
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.SupplyChainItm","QueryUnLinkInci",^tmpbin(66))
Query QueryUnLinkInci(Params As %String) As Query(ROWSPEC = "InciId:%Integer,InciCode,InciDesc,Spec,PUomDesc,PRp:%Float,ChainId,ChainCode,ManfId") [ SqlProc ]
{
}

ClassMethod QueryUnLinkInciExecute(ByRef qHandle As %Binary, Params As %String) As %Status
{
	n (qHandle,%session,Params)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 q $$$OK
	
	s PChainId=PJObj.%Get("ChainId")
	s PInciId=PJObj.%Get("Inci")
	s PInciDesc=PJObj.%Get("InciDesc")
	s PManfId=PJObj.%Get("Manf")
	s PVendorId=PJObj.%Get("Vendor")

	s InciId=0
	f  s InciId=$o(^INCI(InciId)) q:InciId=""  d
	.q:+InciId'>0
	.s InciDesc=$p(^INCI(InciId,1),"^",2)
	.q:(PInciId'="")&&(InciId'=PInciId)
	.q:(PInciId="")&&(PInciDesc'="")&&(InciDesc'[PInciDesc)
	.
	.s NotUseFlag=$p(^INCI(InciId,2),"^",9)
	.q:NotUseFlag="Y"
	.
	.s InfoId=$o(^DHCITMINFO(0,"INCI",InciId,0))
	.q:InfoId=""
	.s VendorId=$p(^DHCITMINFO(InfoId),"^",24)
	.s Spec=$p(^DHCITMINFO(InfoId),"^",27)
	.s ManfId=""
	.s RegCertDR=$p($g(^DHCITMINFO(InfoId,1)),"^",18)
	.s:RegCertDR'="" ManfId=$p($g(^DHCMRCT(RegCertDR)),"^",2)
	.s:ManfId="" ManfId=$p($G(^DHCITMINFO(InfoId)),"^",25)
	.q:(PVendorId'="")&&(VendorId'=PVendorId)
	.q:(PManfId'="")&&(ManfId'=PManfId)
	.
	.s TmpGrpInfo=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncStkCatGrp(InciId)
	.s TmpGrpType=$p(TmpGrpInfo,"^",3)
	.q:TmpGrpType'="M"
	.
	.s InciCode=$p(^INCI(InciId,1),"^",1)
	.s InciDesc=$p(^INCI(InciId,1),"^",2)
	.s PUomId=$p(^INCI(InciId,3),"^",6)
	.q:PUomId=""
	.s PUomDesc=$p(^CT("UOM",PUomId),"^",2)
	.s PRp=##class(web.DHCSTMHUI.Common.PriceCommon).GetInciBasicRp(InciId,+$h,PUomId)
	.
	.;授权书
	.s ChainId=""
	.i (PChainId'="")&&$d(^CT.HRP.MAT.SupplyChainItmI("INCI",InciId,PChainId)) s ChainId=PChainId
	.e  s ChainId=$o(^CT.HRP.MAT.SupplyChainItmI("INCI",InciId,""),-1)
	.s ChainCode=$s(ChainId'="":$lg(^CT.HRP.MAT.SupplyChainD(ChainId),2),1:"")
	.
	.d OutPutUnLinkRow
	Quit $$$OK
OutPutUnLinkRow
	s Data=$lb(InciId,InciCode,InciDesc,Spec,PUomDesc,
		PRp,ChainId,ChainCode,ManfId)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

ClassMethod jsSave(Parref, ListData) As %String
{
	s $ZT=..sssError()
	s RtnObj=##class(RtnObj).%New()
	s RtnObj=..Save(Parref,ListData)
	q RtnObj.Json()
}

ClassMethod Save(Parref, ListData) As RtnObj
{
	n (Parref,ListData)
	s RtnObj=##class(RtnObj).%New()
	s MethodName=$CLASSNAME()_".Save"
	
	i Parref="" q RtnObj.Err(-1,"",MethodName_":参数错误")
	i ListData="" s RtnObj.rowid=Parref q RtnObj
	
	ts
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(ListData)
	i Sc'=0 q RtnObj.Err(-5,Parref,MethodName_":参数解析错误")
	while(RtnObj.success=0){
		s Obj=PJObj.%Pop()
		q:Obj=""
		
		s InciId=Obj.%Get("InciId")
		s ItmObj=##class(CT.HRP.MAT.SupplyChainItm).%New()
		d ItmObj.SCIParRefSetObjectId(Parref)
		d ItmObj.SCIINCIDRSetObjectId(InciId)
		s Sc=ItmObj.%Save()
		i $$$ISERR(Sc) d RtnObj.Err(-1,"",MethodName_"保存关联信息失败")
		continue:RtnObj.success<0
	}
	i RtnObj.success<0 tro  q RtnObj
	
	tc
	q RtnObj
}

/// w ##class(web.DHCSTMHUI.SupplyChainItm).jsCancel(^tmpbin(168))
ClassMethod jsCancel(ListData) As %String
{
	s $ZT=..sssError()
	s RtnObj=##class(RtnObj).%New()
	s RtnObj=..Cancel(ListData)
	q RtnObj.Json()
}

ClassMethod Cancel(ListData) As RtnObj
{
	n (ListData)
	s RtnObj=##class(RtnObj).%New()
	s MethodName=$CLASSNAME()_".Save"
	
	i ListData="" q RtnObj.Err(-1,"",MethodName_":参数错误!")
	
	ts
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(ListData)
	i Sc'=0 q RtnObj.Err(-5,"",MethodName_":参数解析错误!")
	while(RtnObj.success=0){
		s Obj=PJObj.%Pop()
		q:Obj=""
		
		s RowId=Obj.%Get("RowId")
		s ItmObj=##class(CT.HRP.MAT.SupplyChainItm).%New()
		s Sc=ItmObj.%DeleteId(RowId)
		i $$$ISERR(Sc) d RtnObj.Err(-1,"",MethodName_"取消关联信息失败!")
		continue:RtnObj.success<0
	}
	i RtnObj.success<0 tro  q RtnObj
	
	tc
	q RtnObj
}

/// w ##class(web.DHCSTMHUI.SupplyChainItm).GetChainIdByInci(^tmpbin(168))
ClassMethod GetChainIdByInci(Inic) As %String
{
	n (Inic)
	q:Inic="" ""
	s ChainId=$o(^CT.HRP.MAT.SupplyChainItmI("INCI",Inic,""))
	q ChainId
}

}
