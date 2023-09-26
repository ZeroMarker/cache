Import sqluser

/// Descript:	内网程序调用平台接口统一通道
/// Creator:	wangjiabin
/// CreateDate:	20190320
Class web.DHCSTMHUI.ServiceForSCI Extends (%RegisteredObject, StkTypeM) [ ProcedureBlock ]
{

/// <<<<<<<<<< 同步信息到平台 - 类型的接口 start >>>>>>>>>>
/// 
/// Description:同步科室信息到平台
/// Creator:	wangjiabin
/// CreateDate:	2019-05-20
/// Table:		平台: T_SYS_CTLOC
/// Input:		科室RowId(如多个科室,用^隔开; 传空按所有处理)
/// Output:		
/// Return:		
/// w ##class(web.DHCSTMHUI.ServiceForSCI).getHopLoc()
ClassMethod getHopLoc(LocIdStr As %String = "")
{
	s Ret=""
	s ClassMethodStr="web.DHCSTMService.Sci.SciClient||getHopLoc"
	s CompiledObj=##class(%Dictionary.CompiledMethod).%OpenId(ClassMethodStr,0)
	i $IsObject(CompiledObj) d
	.s Ret=##class(web.DHCSTMService.Sci.SciClient).getHopLoc(LocIdStr)
	q +Ret
}

/// Description:同步供应商信息到平台
/// Creator:	wangjiabin
/// CreateDate:	2019-05-20
/// Table:		平台: T_SYS_CTLOC
/// Input:		科室RowId(如多个科室,用^隔开; 传空按所有处理)
/// Output:		
/// Return:		
ClassMethod getHopVendor(VenIdStr As %String = "")
{
	s Ret=""
	s ClassMethodStr="web.DHCSTMService.Sci.SciClient||getHopVendor"
	s CompiledObj=##class(%Dictionary.CompiledMethod).%OpenId(ClassMethodStr,0)
	i $IsObject(CompiledObj) d
	.s Ret=##class(web.DHCSTMService.Sci.SciClient).getHopVendor(VenIdStr)
	q +Ret
}

/// Description:同步物资信息到平台
/// Creator:	wangjiabin
/// CreateDate:	2019-05-20
/// Table:		平台: t_hop_vendor, t_ven_inc, T_VEN_HOP_INC
/// Input:		库存项RowId(如多个,用^隔开; 传空按所有处理)
/// Output:		
/// Return:		"":成功; 非空:有错误信息
/// w ##class(web.DHCSTMHUI.ServiceForSCI).getHopInc(2769)
ClassMethod getHopInc(InciStr As %String = "")
{
	s Ret=""
	s ClassMethodStr="web.DHCSTMService.Sci.SciClient||getHopInc"
	s CompiledObj=##class(%Dictionary.CompiledMethod).%OpenId(ClassMethodStr,0)
	i $IsObject(CompiledObj) d
	.s Ret=##class(web.DHCSTMService.Sci.SciClient).getHopInc(InciStr)
	q +Ret
}

/// Description:同步新品立项信息
/// CreateDate:	2019-06-29
/// Table:		DHC_NewItm
/// Input:		Param(LocId^UserId)
ClassMethod getSciHopInc(Param As %String) As %String
{
	s Ret=0
	s ClassMethodStr="web.DHCSTMService.Sci.SciClient||getSciHopInc"
	s CompiledObj=##class(%Dictionary.CompiledMethod).%OpenId(ClassMethodStr,0)
	i $IsObject(CompiledObj) d
	.s Ret=##class(web.DHCSTMService.Sci.SciClient).getSciHopInc(Param)
	q Ret
}

/// Description:同步科室库存(包括上下限等信息)到平台
/// Creator:	wangjiabin
/// CreateDate:	2019-05-21
/// Table:		平台: t_hop_inc_loc
/// Input:		科室RowId
/// Output:		
/// Return:		"":成功; 非空:有错误信息
/// w ##class(web.DHCSTMHUI.ServiceForSCI).getHopLocIncQty(392)
ClassMethod getHopLocIncQty(Locid As %String = "")
{
	s Ret=0
	s ClassMethodStr="web.DHCSTMService.Sci.SciClient||getHopLocIncQty"
	s CompiledObj=##class(%Dictionary.CompiledMethod).%OpenId(ClassMethodStr,0)
	i $IsObject(CompiledObj) d
	.s Ret=##class(web.DHCSTMService.Sci.SciClient).getHopLocIncQty(Locid)
	q Ret
}

/// Description:同步进价信息到平台
/// Creator:	wangjiabin
/// CreateDate:	2019-05-21
/// Table:		平台: T_HOP_INC
/// Input:		库存项RowId
/// Output:		
/// Return:		
/// W ##class(web.DHCSTMHUI.ServiceForSCI).adjRp(2679)
ClassMethod adjRp(Inci)
{
	s Ret=0
	s ClassMethodStr="web.DHCSTMService.Sci.SciClient||adjRp"
	s CompiledObj=##class(%Dictionary.CompiledMethod).%OpenId(ClassMethodStr,0)
	i $IsObject(CompiledObj) d
	.s Ret=##class(web.DHCSTMService.Sci.SciClient).adjRp(Inci)
	q Ret
}

/// <<<<<<<<<< 同步信息到平台 - 类型的接口 - end >>>>>>>>>>
/// 
/// 
/// <<<<<<<<<< 订单业务类型接口 start >>>>>>>>>>
/// 
/// Description:同步订单信息到平台
/// Creator:	wangjiabin
/// CreateDate:	2019-05-22
/// Table:		平台: T_ORD_ORDERDETAIL
/// Input:		库存项RowId
/// Output:		
/// Return:		
/// W ##class(web.DHCSTMHUI.ServiceForSCI).getHopOrder(2679)
ClassMethod getHopOrder(PoId, emflag)
{
	s Ret=""
	s ClassMethodStr="web.DHCSTMService.Sci.SciClient||getHopOrder"
	s CompiledObj=##class(%Dictionary.CompiledMethod).%OpenId(ClassMethodStr,0)
	i $IsObject(CompiledObj) d
	.s Ret=##class(web.DHCSTMService.Sci.SciClient).getHopOrder(PoId,emflag)
	q Ret
}

/// Description:同步订单信息到平台
/// Creator:	wangjiabin
/// CreateDate:	2019-05-24
/// Table:		平台: T_ORD_ORDERDETAIL
/// Input:		SxNo:随行单号barcode, HVFlag:高值标记("":所有,Y:仅高值,N:仅低值)
/// Output:		
/// Return:		{Main:{表单对象信息},Detail:{表格明细信息}}
/// W ##class(web.DHCSTMHUI.ServiceForSCI).getOrderDetail("123","N")
ClassMethod getOrderDetail(SxNo, HVFlag)
{
	s ClassMethodStr="web.DHCSTMService.Sci.SciClient||getOrderDetail"
	s CompiledObj=##class(%Dictionary.CompiledMethod).%OpenId(ClassMethodStr,0)
	i $IsObject(CompiledObj) d
	.d ##class(web.DHCSTMService.Sci.SciClient).getOrderDetail(SxNo,HVFlag)
	q:'$IsObject(CompiledObj) "{}"
	q ""
}

/// Description:订单状态确认,入库制单,高值条码生成环节,都有调用
/// Input:		平台订单明细Id传(用^隔开)
/// Output:		
/// Return:		
/// w ##class(web.DHCSTMHUI.ServiceForSCI).cmpOrder("8a819ec16ae29800016ae33d31cd0000")
ClassMethod cmpOrder(OrderDetailSubIdStr)
{
	s Ret=""
	s ClassMethodStr="web.DHCSTMService.Sci.SciClient||cmpOrder"
	s CompiledObj=##class(%Dictionary.CompiledMethod).%OpenId(ClassMethodStr,0)
	i $IsObject(CompiledObj) d
	.s Ret=##class(web.DHCSTMService.Sci.SciClient).cmpOrder(OrderDetailSubIdStr)
	q Ret
}

/// Description:催单/撤单
/// Input:		Type(1:催单,2:撤销), InpoiStr(订单明细id串,用^隔开)
/// Output:		
/// Return:		
ClassMethod updateOrder(Type, InpoiStr)
{
	s Ret=""
	s ClassMethodStr="web.DHCSTMService.Sci.SciClient||updateOrder"
	s CompiledObj=##class(%Dictionary.CompiledMethod).%OpenId(ClassMethodStr,0)
	i $IsObject(CompiledObj) d
	.s Ret=##class(web.DHCSTMService.Sci.SciClient).updateOrder(Type,InpoiStr)
	q Ret
}

/// Description:高值订单 完成 取消完成
/// Input:		Type(D:发货   T:扫码入库), Barcodes(条码,用^隔开)
/// Output:		
/// Return:		
ClassMethod updateHvOrder(Type, BarcodeStr)
{
	s Ret=""
	s ClassMethodStr="web.DHCSTMService.Sci.SciClient||updateHvOrder"
	s CompiledObj=##class(%Dictionary.CompiledMethod).%OpenId(ClassMethodStr,0)
	i $IsObject(CompiledObj) d
	.s Ret=##class(web.DHCSTMService.Sci.SciClient).updateHvOrder(Type,BarcodeStr)
	q Ret
}

/// Description:删除入库单时,平台订单状态处理
/// Input:		入库单rowid
/// Output:		
/// Return:		
ClassMethod deleteOrder(Ingr)
{
	s Ret=""
	s ClassMethodStr="web.DHCSTMService.Sci.SciClient||deleteOrder"
	s CompiledObj=##class(%Dictionary.CompiledMethod).%OpenId(ClassMethodStr,0)
	i $IsObject(CompiledObj) d
	.s Ret=##class(web.DHCSTMService.Sci.SciClient).deleteOrder(Ingr)
	q Ret
}

/// Description:删除入库单明细时,平台订单状态处理
/// Input:		入库子表rowid
/// Output:		
/// Return:		
ClassMethod deleteOrderitm(Ingri)
{
	s Ret=""
	s ClassMethodStr="web.DHCSTMService.Sci.SciClient||deleteOrderitm"
	s CompiledObj=##class(%Dictionary.CompiledMethod).%OpenId(ClassMethodStr,0)
	i $IsObject(CompiledObj) d
	.s Ret=##class(web.DHCSTMService.Sci.SciClient).deleteOrderitm(Ingri)
	q Ret
}

/// Description:发送退货单信息到平台
/// Input:		退货rowid
/// Output:		
/// Return:		
ClassMethod getRetOrder(Ingrt)
{
	s Ret=""
	s ClassMethodStr="web.DHCSTMService.Sci.SciClient||getRetOrder"
	s CompiledObj=##class(%Dictionary.CompiledMethod).%OpenId(ClassMethodStr,0)
	i $IsObject(CompiledObj) d
	.s Ret=##class(web.DHCSTMService.Sci.SciClient).getRetOrder(Ingrt)
	q Ret
}

/// Description:直接根据SCI订单生成入库单--前段直接调用
/// Input:		SCI订单号, 科室Id, UserId
/// Output:		
/// Return:		RtnObj.Json()--供前端直接调用	
/// w ##class(web.DHCSTMHUI.ServiceForSCI).CreateIngrBySciInPo("ORD382019072500007",392,4642)
ClassMethod CreateIngrBySciInPo(BarCode, LocId, UserId)
{
	s RtnObj=##class(RtnObj).%New()
	s ClassMethodStr="web.DHCSTMService.Sci.SciClient||CreateIngrBySciInPo"
	s CompiledObj=##class(%Dictionary.CompiledMethod).%OpenId(ClassMethodStr,0)
	i $IsObject(CompiledObj) d
	.s RtnObj=##class(web.DHCSTMService.Sci.SciClient).CreateIngrBySciInPo(BarCode,LocId,UserId)
	
	i '$IsObject(RtnObj) q RtnObj.Err(-100,"","后台处理错误!").Json()
	q RtnObj.Json()
}

/// 保存入库信息
ClassMethod SaveIngr(IngrId)
{
	s Ret=""
	s ClassMethodStr="web.DHCSTMService.Sci.SciClient||SaveIngr"
	s CompiledObj=##class(%Dictionary.CompiledMethod).%OpenId(ClassMethodStr,0)
	i $IsObject(CompiledObj) d
	.s Ret=##class(web.DHCSTMService.Sci.SciClient).SaveIngr(IngrId)
	q Ret
}

/// <<<<<<<<<< 订单业务类型接口 end >>>>>>>>>>

}
