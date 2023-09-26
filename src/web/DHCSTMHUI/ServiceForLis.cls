Import sqluser

/// Descript:	同东华Lis之间的接口程序
/// Creator:	wangjiabin
/// CreateDate:	2018-04-23
Class web.DHCSTMHUI.ServiceForLis Extends (%RegisteredObject, StkTypeM) [ ProcedureBlock ]
{

Parameter AppName [ Final ] = "DHCSTMSERFORLISM";

/// 同步库存项信息
/// w ##class(web.DHCSTMHUI.ServiceForLis).SynInciInfo
ClassMethod SynInciInfo(Inci, HospId)
{
	s Ret=0
	s ClassMethodStr="web.DHCSTMService.Lis.ServiceForLis||SynInciInfo"
	s CompiledObj=##class(%Dictionary.CompiledMethod).%OpenId(ClassMethodStr,0)
	i $IsObject(CompiledObj) d
	.s Ret=##class(web.DHCSTMService.Lis.ServiceForLis).SynInciInfo(Inci,HospId)
	q Ret
}

/// 同步供应商信息
/// w ##class(web.DHCSTMHUI.ServiceForLis).SynVendorInfo(1,2)
ClassMethod SynVendorInfo(VendorId, HospId)
{
	s Ret=0
	s ClassMethodStr="web.DHCSTMService.Lis.ServiceForLis||SynVendorInfo"
	s CompiledObj=##class(%Dictionary.CompiledMethod).%OpenId(ClassMethodStr,0)
	i $IsObject(CompiledObj) d
	.s Ret=##class(web.DHCSTMService.Lis.ServiceForLis).SynVendorInfo(VendorId,HospId)
	q Ret
}

/// Description:物资出库接收时,为lis方面升成条码
/// CreatDate:	2018-04-23
/// Input:		出库单rowid
/// OutPut:		0:成功, <0:失败
/// w ##class(web.DHCSTMHUI.ServiceForLis).CreateLisBarCode(189)
ClassMethod CreateLisBarCode(Init As %String, HospId)
{
	s Ret=0
	s ClassMethodStr="web.DHCSTMService.Lis.ServiceForLis||CreateLisBarCode"
	s CompiledObj=##class(%Dictionary.CompiledMethod).%OpenId(ClassMethodStr,0)
	i $IsObject(CompiledObj) d
	.s Ret=##class(web.DHCSTMService.Lis.ServiceForLis).CreateLisBarCode(Init,HospId)
	q Ret
}

/// Description:获取条码相关json信息
/// CreatDate:	2018-04-24
/// Input:		出库单rowid
/// OutPut:		json
/// w ##class(web.DHCSTMHUI.ServiceForLis).GetInitiBarCodeDetail(189)
ClassMethod GetInitiBarCodeDetail(Init As %String) As %String
{
	q:Init="" ""
	
	s json=##class(web.DHCSTMHUI.Common.JsonObj).%New()
	s TitleStr="Initi^InciCode^InciDesc^Spec^BarCode"
		_"^BatchNo^ExpDate^BUomDesc^Rp^ManfDesc"
	
	s Count=0
	s Ch=0
	f  s Ch=$o(^DHCINIT(Init,"ITI",Ch)) q:(Ch="")  d
	.s Initi=Init_"||"_Ch
	.s InitiInfo=^DHCINIT(Init,"ITI",Ch)
	.s Inclb=$p(InitiInfo,"^",3)
	.s Rp=$p(InitiInfo,"^",15)
	.s Inci=$p(Inclb,"||",1)
	.
	.s InciCode=$p(^INCI(Inci,1),"^",1)
	.s InciDesc=$p(^INCI(Inci,1),"^",2)
	.s BUomId=$p(^INCI(Inci,1),"^",10)
	.s BUomDesc=$s(BUomId'="":$p(^CT("UOM",BUomId),"^",2),1:"")
	.s Spec=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetSpec("",Inci)
	.s BatExp=##class(web.DHCSTMHUI.Common.DrugStkCommon).Bat(Inclb)
	.s BatchNo=$p(BatExp,"^",1)
	.s ExpDate=$p(BatExp,"^",2)
	.s ManfInfo=##class(web.DHCSTMHUI.Common.DrugStkCommon).GetManfInfoByInclb(Inclb)
	.s ManfDesc=$p(ManfInfo,"^",2)
	.
	.s INITB=0
	.f  s INITB=$o(^DHCINITB(0,"INITI",Initi,INITB)) q:INITB=""  d
	..s BarCode=$p(^DHCINITB(INITB),"^",2)
	..s DataStr1=Initi_"^"_InciCode_"^"_InciDesc_"^"_Spec_"^"_BarCode
	..s DataStr2=BatchNo_"^"_ExpDate_"^"_BUomDesc_"^"_Rp_"^"_ManfDesc
	..s DataStr=DataStr1_"^"_DataStr2
	..s Count=Count+1
	..d json.InsertRowData(DataStr)
	
	d json.getJsonData(TitleStr,Count)
	q ""
}

/// Description:接收采购订单信息
/// CreatDate:	2019-08-24
/// w ##class(web.DHCSTMHUI.ServiceForLis).AcceptInPoInfo()
ClassMethod AcceptInPoInfo(xml, HospId)
{
	s Ret=0
	s ClassMethodStr="web.DHCSTMService.Lis.ServiceForLis||AcceptInPoInfo"
	s CompiledObj=##class(%Dictionary.CompiledMethod).%OpenId(ClassMethodStr,0)
	i $IsObject(CompiledObj) d
	.s Ret=##class(web.DHCSTMService.Lis.ServiceForLis).AcceptInPoInfo(xml,HospId)
	q Ret
}

/// Description:撤销采购订单信息
/// CreatDate:	2019-08-24
/// w ##class(web.DHCSTMHUI.ServiceForLis).CancleLisInPo() 
ClassMethod CancleLisInPo(OrderListNo, HospId)
{
	s Ret=0
	s ClassMethodStr="web.DHCSTMService.Lis.ServiceForLis||CancleLisInPo"
	s CompiledObj=##class(%Dictionary.CompiledMethod).%OpenId(ClassMethodStr,0)
	i $IsObject(CompiledObj) d
	.s Ret=##class(web.DHCSTMService.Lis.ServiceForLis).CancleLisInPo(OrderListNo,HospId)
	q Ret
}

}
