Import sqluser

/// 云平台配送单
Class web.DHCSTMHUI.MatDeliver Extends (%RegisteredObject, StkTypeM) [ Not ProcedureBlock ]
{

/// Description:清除请求单设置的在途数(清除**小时之前的,默认为12)
/// Creator:    wangjiabin
/// CreateDate: 2020-08-26
/// Input:		Main(json), Detail(json) --来自获取配送单信息时的方法
/// Output:     
/// Return:		
/// w ##class(web.DHCSTMHUI.MatDeliver).Save()
ClassMethod Save(Main, Detail) As RtnObj
{
	n (Main,Detail)
	s MethodName=$CLASSNAME()_".Save"
	s RtnObj=##class(RtnObj).%New()

	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Main)
	i Sc'=0 q RtnObj.Err(-1,"",MethodName_"入参解析失败!")
	s DeliverNo=PJObj.%Get("SCINo")
	s PoId=PJObj.%Get("PoId")
	s DeliverId=PJObj.%Get("DeliverId")
	s VendorId=PJObj.%Get("SCIPoVendor").%Get("RowId")
	s LocId=PJObj.%Get("PoLoc")
	s HospId=$p(^CTLOC(LocId),"^",22)
	
	q:DeliverId="" RtnObj.Err(-1,"","参数错误")
	i $d(^User.MATDeliverI("DeliverId",DeliverId)) q RtnObj.Err(0,"",DeliverNo_"重复处理","",0)
	
	s ItmPJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=ItmPJObj.%FromJSON(Detail)
	i Sc'=0 q RtnObj.Err(-2,"",MethodName_"入参解析失败!")
	
	ts
	s Obj=##class(User.MATDeliver).%New()
	
	s Obj.MATDNo=DeliverNo
	d Obj.MATDINPODRSetObjectId(PoId)
	s Obj.MATDDeliverId=DeliverId
	d Obj.MATDAPCVMDRSetObjectId(VendorId)
	d Obj.MATDCTLOCDRSetObjectId(LocId)
	s Sc=Obj.%Save()
	i $$$ISERR(Sc) tro 1 q RtnObj.Err(-10,"",MethodName_"配送单保存失败")
	s MasterRowId=Obj.%Id()
	while(RtnObj.success=0){
		s ItmObj=ItmPJObj.%Get("rows").%Pop()
		q:ItmObj=""
		
		s Inpoi=ItmObj.%Get("PoItmId")
		s Inci=ItmObj.%Get("IncId")
		s DetailSubId=ItmObj.%Get("OrderDetailSubId")
		s AvaQty=ItmObj.%Get("AvaQty")
		s BatchNo=ItmObj.%Get("BatchNo")
		s ExpDate=ItmObj.%Get("ExpDate")
		s ProduceDate=ItmObj.%Get("ProduceDate")
		s BUomId=ItmObj.%Get("BUomId")
		s Rp=ItmObj.%Get("Rp")
		s Sp=ItmObj.%Get("Sp")
		s AvaQty=ItmObj.%Get("AvaQty")
		s DeliverQty=ItmObj.%Get("DeliverQty")		;原始发货数量
		s BarCode=ItmObj.%Get("BarCode")
		s OriginalCode=ItmObj.%Get("OriginalCode")
		
		s:ExpDate'="" ExpDate=$zdh(ExpDate,3)
		s:ProduceDate'="" ProduceDate=$zdh(ProduceDate,3)
		s RpAmt=Rp*AvaQty,SpAmt=Sp*AvaQty
		s RpAmt=##class(web.DHCSTMHUI.Common.AppCommon).FormatRpAmt(RpAmt,HospId)
		s SpAmt=##class(web.DHCSTMHUI.Common.AppCommon).FormatSpAmt(SpAmt,HospId)
		
		s IObj=##class(User.MATDeliverItm).%New()
		d IObj.MATDIParRefSetObjectId(MasterRowId)
		d IObj.MATDIINPOIDRSetObjectId(Inpoi)
		s IObj.MATDIDetailSubId=DetailSubId
		d IObj.MATDIINCIDRSetObjectId(Inci)
		s IObj.MATDIQty=AvaQty
		s IObj.MATDIRp=Rp
		s IObj.MATDIRpAmt=RpAmt
		d IObj.MATDICTUOMDRSetObjectId(BUomId)			;这个地方,用哪个单位???
		s IObj.MATDIBatchNo=BatchNo
		s IObj.MATDIExpDate=ExpDate
		s IObj.MATDIProduceDate=ProduceDate
		s IObj.MATDIDeliverQty=DeliverQty
		s IObj.MATDIBarCode=BarCode
		s IObj.MATDIOriginalCode=OriginalCode
		;s IObj.MATDISerialNo=
		s IObj.MATDISp=Sp
		s IObj.MATDISpAmt=SpAmt
		;s IObj.MATDIInvNo=
		;s IObj.MATDIInvCode=
		;s IObj.MATDIInvDate=
		;s IObj.MATDIInvAmt=
		;s IObj.MATDIRemarks=
		s Sc=IObj.%Save()
		i $$$ISERR(Sc) d RtnObj.Err(-11,"",MethodName_"保存明细失败")
	}
	i RtnObj.success<0 tro 1  q RtnObj
	
	tc
	q RtnObj
}

}
