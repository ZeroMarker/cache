Import sqluser

/// Descript:	内网程序调用ECS云平台接口统一通道
/// Creator:	wangjiabin
/// CreateDate:	2020-05-30
Class web.DHCSTMHUI.ServiceForECS Extends (%RegisteredObject, StkTypeM) [ ProcedureBlock ]
{

/// 1.同步供应商信息
/// w ##class(web.DHCSTMHUI.ServiceForECS).saveSupDict()
ClassMethod saveSupDict(VendorIdStr, HospId)
{
	s Ret=0
	s ClassMethodStr="web.DHCSTMService.ECS.ECS2STMClient||saveSupDict"
	s CompiledObj=##class(%Dictionary.CompiledMethod).%OpenId(ClassMethodStr,0)
	i $IsObject(CompiledObj) d
	.s Ret=##class(web.DHCSTMService.ECS.ECS2STMClient).saveSupDict(VendorIdStr,HospId)
	q 0
}

/// 3.上传生产厂家
/// w ##class(web.DHCSTMHUI.ServiceForECS).postFactories()
ClassMethod postFactories(ManfIdStr As %String = "", HospId)
{
	s Ret=""
	s ClassMethodStr="web.DHCSTMService.ECS.ECS2STMClient||postFactories"
	s CompiledObj=##class(%Dictionary.CompiledMethod).%OpenId(ClassMethodStr,0)
	i $IsObject(CompiledObj) d
	.s Ret=##class(web.DHCSTMService.ECS.ECS2STMClient).postFactories(ManfIdStr,HospId)
	q Ret
}

/// 5.上传库存分类
/// w ##class(web.DHCSTMHUI.ServiceForECS).updateHosCat()
ClassMethod updateHosCat(IncscIdStr As %String = "", HospId)
{
	s Ret=""
	s ClassMethodStr="web.DHCSTMService.ECS.ECS2STMClient||updateHosCat"
	s CompiledObj=##class(%Dictionary.CompiledMethod).%OpenId(ClassMethodStr,0)
	i $IsObject(CompiledObj) d
	.s Ret=##class(web.DHCSTMService.ECS.ECS2STMClient).updateHosCat(IncscIdStr,HospId)
	q Ret
}

/// 7.同步商品字典信息
/// w ##class(web.DHCSTMHUI.ServiceForECS).updateHosInv(1,3)
ClassMethod updateHosInv(InciIdStr, HospId)
{
	s Ret=""
	s ClassMethodStr="web.DHCSTMService.ECS.ECS2STMClient||postSpecifications"
	s CompiledObj=##class(%Dictionary.CompiledMethod).%OpenId(ClassMethodStr,0)
	i $IsObject(CompiledObj) d
	.s Ret=##class(web.DHCSTMService.ECS.ECS2STMClient).postSpecifications(InciIdStr,HospId)
	q +Ret
}

/// 8.下载商品字典
ClassMethod getSpecifications(InciStr, StartDate, EndDate, HospId)
{
	s Ret=""
	s ClassMethodStr="web.DHCSTMService.ECS.ECS2STMClient||getSpecifications"
	s CompiledObj=##class(%Dictionary.CompiledMethod).%OpenId(ClassMethodStr,0)
	i $IsObject(CompiledObj) d
	.s Ret=##class(web.DHCSTMService.ECS.ECS2STMClient).getSpecifications(InciStr, StartDate, EndDate, HospId)
	q +Ret
}

/// 10.推送订单到平台
/// w ##class(web.DHCSTMHUI.ServiceForECS).saveSupOrder()
ClassMethod saveSupOrder(PoIdStr, EMFlag, HospId)
{
	s Ret=""
	s ClassMethodStr="web.DHCSTMService.ECS.ECS2STMClient||saveSupOrder"
	s CompiledObj=##class(%Dictionary.CompiledMethod).%OpenId(ClassMethodStr,0)
	i $IsObject(CompiledObj) d
	.s Ret=##class(web.DHCSTMService.ECS.ECS2STMClient).saveSupOrder(PoIdStr, EMFlag,HospId)
	q Ret
}

/// 11.1催单
/// w ##class(web.DHCSTMHUI.ServiceForECS).remindOrder()
ClassMethod remindOrder(InpoiStr As %String = "", HospId)
{
	s Ret=""
	s ClassMethodStr="web.DHCSTMService.ECS.ECS2STMClient||postOrdersState"
	s CompiledObj=##class(%Dictionary.CompiledMethod).%OpenId(ClassMethodStr,0)
	i $IsObject(CompiledObj) d
	.s state="quick"
	.s Ret=##class(web.DHCSTMService.ECS.ECS2STMClient).postOrdersState(InpoiStr,state,HospId)
	q Ret
}

/// 11.2撤单
/// w ##class(web.DHCSTMHUI.ServiceForECS).cancelOrder()
ClassMethod cancelOrder(InpoiStr As %String = "", HospId)
{
	s Ret=""
	s ClassMethodStr="web.DHCSTMService.ECS.ECS2STMClient||postOrdersState"
	s CompiledObj=##class(%Dictionary.CompiledMethod).%OpenId(ClassMethodStr,0)
	i $IsObject(CompiledObj) d
	.s state="cancel"
	.s Ret=##class(web.DHCSTMService.ECS.ECS2STMClient).postOrdersState(InpoiStr,state,HospId)
	q Ret
}

/// 11.3 同步订单状态
/// Input:		订单Id或日期范围,至少二选一
/// w ##class(web.DHCSTMHUI.ServiceForECS).getOrdersState()
ClassMethod getOrdersState(InpoIdStr, StartDate, EndDate, HospId)
{
	s Ret=""
	s ClassMethodStr="web.DHCSTMService.ECS.ECS2STMClient||getOrdersState"
	s CompiledObj=##class(%Dictionary.CompiledMethod).%OpenId(ClassMethodStr,0)
	i $IsObject(CompiledObj) d
	.s Ret=##class(web.DHCSTMService.ECS.ECS2STMClient).getOrdersState(InpoIdStr,StartDate,EndDate,HospId)
	q Ret
}

/// 13.下载配送单信息
/// d ##class(web.DHCSTMHUI.ServiceForECS).getOrderDetail("202007010007","Y")
ClassMethod getOrderDetail(SxNo As %String, HVFlag As %String = "", HospId)
{
	s Ret=""
	s ClassMethodStr="web.DHCSTMService.ECS.ECS2STMClient||getOrderDetail"
	s CompiledObj=##class(%Dictionary.CompiledMethod).%OpenId(ClassMethodStr,0)
	i $IsObject(CompiledObj) d
	.s Ret=##class(web.DHCSTMService.ECS.ECS2STMClient).getOrderDetail(SxNo,HVFlag,"",HospId)
	q Ret
}

/// 14.下载配送单信息
/// Description:直接根据ECS订单生成入库单--前端直接调用
/// Input:		ECS配送单号, 科室Id, UserId
/// Output:		
/// Return:		RtnObj.Json()--供前端直接调用	
/// w ##class(web.DHCSTMHUI.ServiceForECS).CreateIngrBySciInPo("202012110001",326,1)
ClassMethod CreateIngrBySxNo(BarCode, LocId, UserId, HospId)
{
	s RtnObj=##class(RtnObj).%New()
	s ClassMethodStr="web.DHCSTMService.ECS.ECS2STMClient||CreateIngrBySxNo"
	s CompiledObj=##class(%Dictionary.CompiledMethod).%OpenId(ClassMethodStr,0)
	i $IsObject(CompiledObj) d
	.s RtnObj=##class(web.DHCSTMService.ECS.ECS2STMClient).CreateIngrBySxNo(BarCode,LocId,UserId,HospId)
	
	i '$IsObject(RtnObj) q RtnObj.Err(-100,"","后台处理错误!").Json()
	q RtnObj.Json()
}

/// 16.入库单保存时调用
/// w ##class(web.DHCSTMHUI.ServiceForECS).SaveIngr()
ClassMethod SaveIngr(IngrId, HospId)
{
	s Ret=""
	s ClassMethodStr="web.DHCSTMService.ECS.ECS2STMClient||SaveIngr"
	s CompiledObj=##class(%Dictionary.CompiledMethod).%OpenId(ClassMethodStr,0)
	i $IsObject(CompiledObj) d
	.s Ret=##class(web.DHCSTMService.ECS.ECS2STMClient).SaveIngr(IngrId,HospId)
	q Ret
}

/// 17.删除入库明细
/// w ##class(web.DHCSTMHUI.ServiceForECS).DeleteIngrItm()
ClassMethod DeleteIngrItm(IngriStr, HospId)
{
	s Ret=""
	s ClassMethodStr="web.DHCSTMService.ECS.ECS2STMClient||DeleteIngrItm"
	s CompiledObj=##class(%Dictionary.CompiledMethod).%OpenId(ClassMethodStr,0)
	i $IsObject(CompiledObj) d
	.s Ret=##class(web.DHCSTMService.ECS.ECS2STMClient).DeleteIngrItm(IngriStr,HospId)
	q Ret
}

/// 18.删除入库单
/// w ##class(web.DHCSTMHUI.ServiceForECS).DeleteIngr()
ClassMethod DeleteIngr(IngrId, HospId)
{
	s Ret=""
	s ClassMethodStr="web.DHCSTMService.ECS.ECS2STMClient||DeleteIngr"
	s CompiledObj=##class(%Dictionary.CompiledMethod).%OpenId(ClassMethodStr,0)
	i $IsObject(CompiledObj) d
	.s Ret=##class(web.DHCSTMService.ECS.ECS2STMClient).DeleteIngr(IngrId,HospId)
	q Ret
}

/// 21.上传退货信息
/// w ##class(web.DHCSTMHUI.ServiceForECS).saveSupRet()
ClassMethod saveSupRet(IngrtIdStr, HospId)
{
	s Ret=""
	s ClassMethodStr="web.DHCSTMService.ECS.ECS2STMClient||saveSupRet"
	s CompiledObj=##class(%Dictionary.CompiledMethod).%OpenId(ClassMethodStr,0)
	i $IsObject(CompiledObj) d
	.s Ret=##class(web.DHCSTMService.ECS.ECS2STMClient).saveSupRet(IngrtIdStr,HospId)
	q Ret
}

/// 22.取消退货单上传
/// w ##class(web.DHCSTMHUI.ServiceForECS).cancelSupRet()
ClassMethod cancelSupRet(IngrtIdStr, HospId)
{
	s Ret=""
	s ClassMethodStr="web.DHCSTMService.ECS.ECS2STMClient||cancelSupRet"
	s CompiledObj=##class(%Dictionary.CompiledMethod).%OpenId(ClassMethodStr,0)
	i $IsObject(CompiledObj) d
	.s Ret=##class(web.DHCSTMService.ECS.ECS2STMClient).cancelSupRet(IngrtIdStr,HospId)
	q Ret
}

/// 23.下载退货状态
/// w ##class(web.DHCSTMHUI.ServiceForECS).getRetrunsState()
ClassMethod getRetrunsState(IngrtIdStr, HospId)
{
	s Ret=""
	s ClassMethodStr="web.DHCSTMService.ECS.ECS2STMClient||getRetrunsState"
	s CompiledObj=##class(%Dictionary.CompiledMethod).%OpenId(ClassMethodStr,0)
	i $IsObject(CompiledObj) d
	.s Ret=##class(web.DHCSTMService.ECS.ECS2STMClient).getRetrunsState(IngrtIdStr,HospId)
	q Ret
}

/// 24.物流系统发票确认
/// w ##class(web.DHCSTMHUI.ServiceForECS).updateInvState()
ClassMethod updateInvState(InvId As %String = "", HospId)
{
	s Ret=""
	s ClassMethodStr="web.DHCSTMService.ECS.ECS2STMClient||updateInvState"
	s CompiledObj=##class(%Dictionary.CompiledMethod).%OpenId(ClassMethodStr,0)
	i $IsObject(CompiledObj) d
	.s Ret=##class(web.DHCSTMService.ECS.ECS2STMClient).updateInvState(InvId,HospId)
	q Ret
}

/// <<<<<<<<不使用>>>>>>>
/// 推送注册证信息到平台
/// w ##class(web.DHCSTMHUI.ServiceForECS).updateHosInvCert()
ClassMethod updateHosInvCert(CertidStr, HospId)
{
	s Ret=""
	s ClassMethodStr="web.DHCSTMService.ECS.ECS2STMClient||updateHosInvCert"
	s CompiledObj=##class(%Dictionary.CompiledMethod).%OpenId(ClassMethodStr,0)
	i $IsObject(CompiledObj) d
	.s Ret=##class(web.DHCSTMService.ECS.ECS2STMClient).updateHosInvCert(CertidStr,HospId)
	q Ret
}

/// 院端根据平台导入的字典信息,创建库存项后,推送ID等信息到平台
/// ps: 此方法,同updateHosInv合并, 不再使用
/// w ##class(web.DHCSTMHUI.ServiceForECS).supProSpecAudit()
ClassMethod supProSpecAudit(InciId As %String = "", HospId)
{
	s Ret=""
	s ClassMethodStr="web.DHCSTMService.ECS.ECS2STMClient||supProSpecAudit"
	s CompiledObj=##class(%Dictionary.CompiledMethod).%OpenId(ClassMethodStr,0)
	i $IsObject(CompiledObj) d
	.s Ret=##class(web.DHCSTMService.ECS.ECS2STMClient).supProSpecAudit(InciId,HospId)
	q Ret
}

/// 保存高值条码
/// w ##class(web.DHCSTMHUI.ServiceForECS).SaveHVBarCode()
ClassMethod SaveHVBarCode(BarcodeStr, HospId)
{
	s Ret=""
	s ClassMethodStr="web.DHCSTMService.ECS.ECS2STMClient||SaveHVBarCode"
	s CompiledObj=##class(%Dictionary.CompiledMethod).%OpenId(ClassMethodStr,0)
	i $IsObject(CompiledObj) d
	.s Ret=##class(web.DHCSTMService.ECS.ECS2STMClient).SaveHVBarCode(BarcodeStr,HospId)
	q Ret
}

/// 删除高值条码
/// w ##class(web.DHCSTMHUI.ServiceForECS).DeleteHVBarCode()
ClassMethod DeleteHVBarCode(BarcodeStr, HospId)
{
	s Ret=""
	s ClassMethodStr="web.DHCSTMService.ECS.ECS2STMClient||DeleteHVBarCode"
	s CompiledObj=##class(%Dictionary.CompiledMethod).%OpenId(ClassMethodStr,0)
	i $IsObject(CompiledObj) d
	.s Ret=##class(web.DHCSTMService.ECS.ECS2STMClient).DeleteHVBarCode(BarcodeStr,HospId)
	q Ret
}

/// <<<<<<<<不再使用>>>>>>>

}
