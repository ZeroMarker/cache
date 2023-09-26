Import sqluser

/// Description:物资管理系统-接口对接单据信息记录
Class web.DHCSTMHUI.DHCServiceBill Extends (%RegisteredObject, StkTypeM) [ Not ProcedureBlock ]
{

ClassMethod Save(Params As %String) As RtnObj
{
	n (Params)
	s RtnObj=##class(RtnObj).%New()
	s MethodName=$ClassName()_".Save"
	
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 q RtnObj.Err(-1,"",MethodName_"入参解析失败!")
	
	s ThirdCode=PJObj.%Get("ThirdCode")
	s Type=PJObj.%Get("Type")
	s Pointer=PJObj.%Get("Pointer")
	s ThirdId=PJObj.%Get("ThirdId")
	i ThirdId="" q RtnObj		;没有第三方id的,不做处理
	i (ThirdCode="")||(Type="")||(Pointer="") q RtnObj.Err(-1,"",MethodName_"入参错误")
	
	s BillId=$o(^User.DHCServiceBillI("TypePointer",ThirdCode,Type,Pointer,0))
	i BillId="" d
	.s Obj=##class(User.DHCServiceBill).%New()
	.s Obj.BILLServiceCode=ThirdCode
	.s Obj.BILLType=Type
	.s Obj.BILLPointer=Pointer
	e  d
	.s Obj=##class(User.DHCServiceBill).%OpenId(BillId)
	s Obj.BILLThirdId=ThirdId
	s Obj.BILLDate=+$h
	s Obj.BILLTime=$p($h,",",2)
	s Sc=Obj.%Save()
	i $$$ISERR(Sc) q RtnObj.Err(-1,"",MethodName_"保存错误")
	s BillId=Obj.%Id()
	
	s RtnObj.rowid=BillId
	q RtnObj
}

/// 根据第三方rowid, 获取DHC单据明细Id
ClassMethod GetPointer(ServiceCode, Type, ThirdId) As %String
{
	n (ServiceCode,Type,ThirdId)
	q:(ServiceCode="")||(Type="")||(ThirdId="") ""
	s BillId=$o(^User.DHCServiceBillI("ThirdId",ServiceCode,ThirdId,Type,0))
	q:BillId="" ""
	s Pointer=$lg(^User.DHCServiceBillD(BillId),4)
	q Pointer
}

/// 获取第三方rowid
ClassMethod GetThirdId(ServiceCode, Type, Pointer) As %String
{
	n (ServiceCode,Type,Pointer)
	q:(ServiceCode="")||(Type="")||(Pointer="") ""
	s BillId=$o(^User.DHCServiceBillI("TypePointer",ServiceCode,Type,Pointer,0))
	q:BillId="" ""
	s ThirdId=$lg(^User.DHCServiceBillD(BillId),6)
	q ThirdId
}

}
