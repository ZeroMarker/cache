Import sqluser

/// Description:在途明细相关处理
/// CreateDate:	2021-08-06
Class web.DHCSTMHUI.MATReservedDetail Extends (%RegisteredObject, StkTypeM) [ Not ProcedureBlock ]
{

/// Descript:	设置在途数(加/减)
/// CreateDate:	2021-08-06
/// Table:		DHC_intrans
/// Input:		统一价: {Type:"Oeori",Pointer:Oeori/Oeore,Incil:Incil,Qty:Qty}
/// 			批次价: {Type:"DspBatch",Pointer:DspBatId,Incil:Incil,Qty:Qty}
/// Return:		库存调整统计
ClassMethod SetReservedDetail(Params As %String) As RtnObj
{
	n (Params)
	s RtnObj=##class(RtnObj).%New()
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	d PJObj.%FromJSON(Params)
	
	; "DspBat"-DHC_OEDispBatch, "Oeori"-医嘱id或执行记录id, "Inrqi"-请求单明细id
	s Type=PJObj.%Get("Type")
	s Pointer=PJObj.%Get("Pointer")
	s Incil=PJObj.%Get("Incil")
	s Inclb=PJObj.%Get("Inclb")
	s Qty=PJObj.%Get("Qty")
	i (Type="")||(Pointer="")||(+Qty=0)||((Inclb="")&&(Incil="")) q RtnObj.Err(-1,"","设置在途参数错误")
	
	ts
	
	;处理在途数
	i Inclb'="" d
	.;批次价, Inclb级别
	.s ResRet=##class(web.DHCSTMHUI.Common.StockHandle).UpdInclbResQty(Inclb,Qty)
	.i ResRet<0 d RtnObj.Err(-1,"","Inclb在途设置错误") q
	e  d
	.;统一价, Incil级别
	.s ResRet=##class(web.DHCSTMHUI.Common.StockHandle).UpdateResQty(Incil,Qty)
	.i ResRet<0 d RtnObj.Err(-2,"","Incil在途设置错误") q
	i RtnObj.success<0 tro 1 q RtnObj
	
	;记录在途信息
	i Qty>0 d
	.s RtnObj=..Save(Params)
	e  d
	.s RtnObj=..ClearResByPointer(Params)
	i RtnObj.success<0 tro 1 q RtnObj
	
	tc
	q RtnObj
}

/// 保存在途明细信息
ClassMethod Save(Params As %String) As RtnObj
{
	n (Params)
	s RtnObj=##class(RtnObj).%New()
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	d PJObj.%FromJSON(Params)
	
	s Type=PJObj.%Get("Type")
	s Pointer=PJObj.%Get("Pointer")
	s Incil=PJObj.%Get("Incil")
	s Inclb=PJObj.%Get("Inclb")
	s Qty=PJObj.%Get("Qty")
	
	i Type="Oeori" d
	.s Ord=$p(Pointer,"||",1),OrdCh=$p(Pointer,"||",2)
	.s Priority=$p(^OEORD(Ord,"I",OrdCh,1),"^",8)
	.q:Priority=""
	.s PriorityCode=$p(^OECPR(Priority),"^",1)
	.;非长期医嘱的,按Oeori记录
	.s:PriorityCode'="S" Pointer=$p(Pointer,"||",1,2)
	
	i (Incil="")&&(Inclb'="") s Incil=$p(Inclb,"||",1,2)
	s Inci=$p(Incil,"||",1),IL=$p(Incil,"||",2)
	s LocId=$p(^INCI(Inci,"IL",IL),"^",1)
	s Date=$p($h,",",1),Time=$p($h,",",2)
	
	;请求单存在重复提交的问题
	s RowId=$o(^User.MATReservedDetailI("TypePointer",Type,Pointer,""),-1)
	;2022-07-19 暂不做此控制,项目如果清数据不到位,会引起回滚
	;i ((Type="DspBatch")||(Type="Oeori"))&&(RowId'="") q RtnObj.Err(-2,"","重复处理在途错误 Type:"_Type_",Pointer:"_Pointer)
	
	i RowId="" d
	.s Obj=##class(User.MATReservedDetail).%New()
	.s Obj.MATRDType=Type
	.s Obj.MATRDPointer=Pointer
	.s Obj.MATRDQty=Qty
	.s Obj.MATRDInitialQty=Qty			;新建时记录初始值
	e  d
	.s Obj=##class(User.MATReservedDetail).%OpenId(RowId)
	.;修改数据时,仅在已经清空在途的情况下重置"初始值"(这个字段,在请求在途处理上很麻烦)
	.i Obj.MATRDClearFlag="Y" s Obj.MATRDInitialQty=Qty
	.i ((Type="DspBatch")||(Type="Oeori")) d
	..s Obj.MATRDQty=Qty
	.e  d
	..s Obj.MATRDQty=Qty+Obj.MATRDQty

	d Obj.MATRDINCILDRSetObjectId(Incil)
	d Obj.MATRDINCLBDRSetObjectId(Inclb)
	d Obj.MATRDCTLOCDRSetObjectId(LocId)
	s Obj.MATRDDate=Date
	s Obj.MATRDTime=Time
	s Obj.MATRDClearFlag="N"
	s Sc=Obj.%Save()
	i $$$ISERR(Sc) q RtnObj.Err(-1,"","在途明细记录错误,Type:"_Type_",Pointer:"_Pointer)
	s RtnObj.rowid=Obj.%Id()
	q RtnObj
}

/// Description:按Pointer清除在途
ClassMethod ClearResByPointer(Params As %String) As RtnObj
{
	n (Params)
	s RtnObj=##class(RtnObj).%New()
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	d PJObj.%FromJSON(Params)
	
	s Type=PJObj.%Get("Type")
	s Pointer=PJObj.%Get("Pointer")
	s Incil=PJObj.%Get("Incil")
	s Inclb=PJObj.%Get("Inclb")
	s Qty=PJObj.%Get("Qty")
	i (Type="")||(Pointer="") q RtnObj.Err(-1,"","在途数清除入参有误")
	
	i Type="Oeori" d
	.s Ord=$p(Pointer,"||",1),OrdCh=$p(Pointer,"||",2)
	.s Priority=$p(^OEORD(Ord,"I",OrdCh,1),"^",8)
	.q:Priority=""
	.s PriorityCode=$p(^OECPR(Priority),"^",1)
	.;非长期医嘱的,按Oeori记录
	.s:PriorityCode'="S" Pointer=$p(Pointer,"||",1,2)
	
	s RowId=$o(^User.MATReservedDetailI("TypePointer",Type,Pointer,""),-1)
	q:RowId="" RtnObj		;未记录得不予处理(也考虑项目更新后要兼容原有医嘱)
	
	
	s Obj=##class(User.MATReservedDetail).%OpenId(RowId)
	d Obj.%Reload()
	s NewQty=Obj.MATRDQty+Qty
	s NewQty=$s(NewQty>=0:NewQty,1:0)
	s Obj.MATRDQty=NewQty
	i NewQty<=0 s Obj.MATRDClearFlag="Y"
	s Sc=Obj.%Save()
	i $$$ISERR(Sc) q RtnObj.Err(-2,"","清在途处理错误")
	
	q RtnObj
}

/// Descript:	根据库存项信息和科室id清除在途明细
/// Creater:	sunbixiang
/// CreateDate:	2022-10-17
/// Input:		Incil,Inclb,LocId
/// Return:		RtnObj
ClassMethod ClearReservedDetailByInc(Incil As %String, Inclb As %String, LocId As %String) As RtnObj
{
	n (Incil,Inclb,LocId)
	s RtnObj=##class(RtnObj).%New()
	s incId=Incil
	s index="Incil"
	s:incId="" incId=Inclb,index="Inclb"
	s RowId=""
	f  s RowId=$o(^User.MATReservedDetailI(index_"",incId,"N",RowId)) q:RowId=""  d
	.q:($lg(^User.MATReservedDetailD(RowId),7))'=LocId
	.s Obj=##class(User.MATReservedDetail).%OpenId(RowId)
	.d Obj.%Reload()
	.s Obj.MATRDQty=0
	.s Obj.MATRDClearFlag="Y"
	.s Sc=Obj.%Save()
	.i $$$ISERR(Sc) d RtnObj.Err(-3,"","清除在途处理错误")
	q RtnObj
}

ClassMethod Clear()
{
	; 清在途方法中, 要过滤库存请求单; 
	; 门诊发放,住院发放; 要不要清???
}

}
