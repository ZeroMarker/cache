Import sqluser

/// Descript:	将现有库存和高值条码绑定
/// Creator:	wangjiabin
/// CreateDate: 2015-06-10
Class web.DHCSTMHUI.BindInclbBarcode Extends (%RegisteredObject, StkTypeM) [ Not ProcedureBlock ]
{

Parameter AppName [ Final ] = "DHCITMTRACKM";

/// Descript:	将inclb和高值条码进行绑定
/// Creator:	wangjiabin
/// CreateDate:	2014-06-11
/// Input:		inclb, dhcit^dhcit^...
/// Output:	 
/// Return：	"":保存正确, 非空:错误信息	
ClassMethod Save(Inclb As %String, ListData As %String, len As %String) As %String
{
	q:Inclb="" ""
	q:ListData="" ""
	s inci=+Inclb,il=$p(Inclb,"||",2),lb=$p(Inclb,"||",3)
	s newStatus="Enable"
	s incib=$p(^INCI(inci,"IL",il,"LB",lb),"^",1)
	s vendorInfo=##class(web.DHCSTMHUI.Common.DrugStkCommon).GetvendorInfoByInclb(Inclb,+$h)
	s vendor=$p(vendorInfo,"^",1)	;取最后入库供应商,可能不准确,仅供参考
	s InclbQty = ##class(web.DHCSTMHUI.Common.DrugStkCommon).QtyINCLBU(Inclb,+$h,"")
	s DirtyQty=##class(web.DHCSTMHUI.Common.DrugStkCommon).CurInclbResQty(Inclb,"")
	s AvaQty = InclbQty - DirtyQty
	s BindedEnableQty=..GetEnableBarcodeQty(Inclb)	;已绑定可用条码数量
	s BindQty=AvaQty-BindedEnableQty
	s RtnObj=##class(RtnObj).%New()
	i BindQty<len s Sc=RtnObj.Err(-3,"","可绑定批次数量少于条码数量!","",0) 
	q:RtnObj.success'=0 RtnObj.Json()
	
	
	s RtnObj=##class(RtnObj).%New()
	s DetailObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=DetailObj.%FromJSON(ListData)
	i Sc'=0 d
	.s Sc=RtnObj.Err(-1,"","明细参数解析失败!")
	q:RtnObj.success'=0 RtnObj.Json()
	ts
	While (RtnObj.success=0) {
		s ItmObj=DetailObj.%Pop()
		q:ItmObj=""
		s dhcit=ItmObj.%Get("dhcit")
		continue:'$d(^DHCIT(dhcit))
		s barcode=$p(^DHCIT(dhcit),"^",2)
		s status=$p(^DHCIT(dhcit),"^",5)
		i status'="" s Sc=RtnObj.Err(-1,"",""_barcode_"已经存在绑定!") q
		q:RtnObj.success'=0
		s obj=##class(User.DHCItmTrack).%OpenId(dhcit)
		s obj.DHCITStatus=newStatus
		d obj.DHCITINCIBDRSetObjectId(incib)
		d obj.DHCITINCLBDRSetObjectId(vendor)
		d obj.DHCITINCLBDRSetObjectId(Inclb)
		d obj.DHCITDHCITDRSetObjectId(dhcit)		;2017-09-30 绑定时,指向自身:用于补录时的过滤处理
		s sc=obj.%Save()
		i $$$ISERR(sc) s Sc=RtnObj.Err(-2,"",""_barcode_"绑定失败!") q
		q:RtnObj.success'=0
	
	}
	i RtnObj.success'=0 tro  q RtnObj.Json()
	tc
	s RtnObj.rowid=0
	s RtnObj.msg="绑定成功！"
	q RtnObj.Json()
}

/// CreateDate:	2014-06-11
/// Input:		inclb, dhcit^dhcit^...
/// Output:	 
/// Return：	"":保存正确, 非空:错误信息	
ClassMethod Cancel(Inclb As %String, ListData As %String, len As %String) As %String
{
	q:Inclb="" ""
	q:ListData="" ""
	s inci=+Inclb,il=$p(Inclb,"||",2),lb=$p(Inclb,"||",3)
	s newStatus="Enable"
	s RtnObj=##class(RtnObj).%New()
	q:RtnObj.success'=0 RtnObj.Json()
	
	s DetailObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=DetailObj.%FromJSON(ListData)
	i Sc'=0 d
	.s Sc=RtnObj.Err(-1,"","明细参数解析失败!")
	q:RtnObj.success'=0 RtnObj.Json()
	ts
	While (RtnObj.success=0) {
		s ItmObj=DetailObj.%Pop()
		q:ItmObj=""
		s dhcit=ItmObj.%Get("dhcit")
		continue:'$d(^DHCIT(dhcit))
		s barcode=$p(^DHCIT(dhcit),"^",2)
		s status=$p(^DHCIT(dhcit),"^",5)
		s obj=##class(User.DHCItmTrack).%OpenId(dhcit)
		s obj.DHCITStatus=""
		s InciB=""
		d obj.DHCITINCIBDRSetObjectId(InciB)
		
		d obj.DHCITINCLBDRSetObjectId(InciB)
		d obj.DHCITDHCITDRSetObjectId(dhcit)		;2017-09-30 绑定时,指向自身:用于补录时的过滤处理
		s sc=obj.%Save()
		i $$$ISERR(sc) s Sc=RtnObj.Err(-2,"",""_barcode_"绑定失败!") q
		q:RtnObj.success'=0
	
	}
	i RtnObj.success'=0 tro  q RtnObj.Json()
	tc
	s RtnObj.rowid=0
	s RtnObj.msg="解除绑定成功！"
	q RtnObj.Json()
}

Query GetInclbInfo(Params As %String) As Query(ROWSPEC = "Inclb,BatchNo,ExpDate,InclbQty:%Float,AvaQty:%Float,BindedEnableQty:%Float,BindQty:%Float") [ SqlProc ]
{
}

ClassMethod GetInclbInfoExecute(ByRef qHandle As %Binary, Params As %String) As %Status
{
	n (qHandle, Params)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	
	s PJobj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	d PJobj.%FromJSON(Params)
	
	s PhaLoc=PJobj.%Get("RecLocId")
	s Inci=PJobj.%Get("Inci")
	s ExcludeZero=PJobj.%Get("notzero")
	
	q:PhaLoc="" ""
	q:Inci="" ""
	s count = 0
	s json = ##class(web.DHCSTMHUI.Common.JsonObj).%New()
	s chl=0
	f  s chl=$o(^INCI("IL_LOC",PhaLoc,Inci,chl))  q:chl=""  d
	.s lb=0
	.f  s lb=$o(^INCI(Inci,"IL",chl,"LB",lb))  q:lb=""  d
	..s RowId =Inci_"||"_chl_"||"_lb
	..
	..s InclbQty = ##class(web.DHCSTMHUI.Common.DrugStkCommon).QtyINCLBU(RowId,+$h,"")
	..q:(ExcludeZero="Y")&&(InclbQty=0)
	..
	..s count=count+1
	..s IncibRowId =$p(^INCI(Inci,"IL",chl,"LB",lb),"^",1)
	..s IncilRowId =Inci_"||"_chl
	..s BatchNo=$p(^INCI(+IncibRowId,"IB",$p(IncibRowId,"||",2)),"^",1)
	..s ExpDate=$p(^INCI(+IncibRowId,"IB",$p(IncibRowId,"||",2)),"^",2)
	..s:ExpDate'="" ExpDate=..DL2H(ExpDate)
	..s Date=$p($h,",",1)
	..s HospID=$p(^CTLOC(PhaLoc),"^",22)
	..
	..s DirtyQty=##class(web.DHCSTMHUI.Common.DrugStkCommon).CurInclbResQty(RowId,"")
	..s AvaQty = InclbQty - DirtyQty
	..
	..s BindedEnableQty=..GetEnableBarcodeQty(RowId)	;已绑定可用条码数量
	..;s BindQty=AvaQty-BindedEnableQty
	..s BindQty=InclbQty-BindedEnableQty				;2016-03-18 改成 (逻辑库存 - 已绑定可用数量)
	..s:BindQty<0 BindQty=0								;不许<0
	..d OutPutRowItmTrack
	
	Quit $$$OK

OutPutRowItmTrack
	s Data=$lb(RowId,BatchNo,ExpDate,InclbQty,AvaQty,BindedEnableQty,BindQty)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// 获取批次已绑定可用条码数量
ClassMethod GetEnableBarcodeQty(inclb) As %Library.Integer
{
	n (inclb)
	q:inclb="" ""
	s count=0
	s dhcit=0
	s inci=+inclb
	f  s dhcit=$o(^DHCIT(0,"INCI",inci,dhcit)) q:dhcit=""  d
	.s status=$p(^DHCIT(dhcit),"^",5)
	.q:status'="Enable"
	.s Inclb=$p(^DHCIT(dhcit),"^",12)
	.q:(inclb'="")&&(Inclb'=inclb)
	.
	.s count=count+1

	q count
}

/// Descript:	获取注册状态的高值条码
/// Creator:	wangjiabin
/// CreateDate:	2014-06-10
/// Input:		库存项id(或inclb)^status为空与否标记(Y/N)
/// 	rem: 获取未绑定的条码使用inci, 获取已绑定的条码使用inclb
/// Output:	 
/// Return：	dhcit^高值条码
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.BindInclbBarcode","GetBarcodes","4^N")
Query GetBarcodes(inclb As %String, nullStatus As %String) As Query(ROWSPEC = "dhcit,HVBarcode,Status,") [ SqlProc ]
{
}

ClassMethod GetBarcodesExecute(ByRef qHandle As %Binary, inclb As %String, nullStatus As %String) As %Status
{
	n (qHandle,inclb,nullStatus)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	
	s inci=+inclb,il=$p(inclb,"||",2),lb=$p(inclb,"||",3)
	s INCLB=$s(lb'="":inclb,1:"")
	
	q:inci="" ""
	s count=0
	s dhcit=""
	f  s dhcit=$o(^DHCIT(0,"INCI",inci,dhcit),-1) q:dhcit=""  d
	.s Status=$p(^DHCIT(dhcit),"^",5)
	.q:(nullStatus="Y")&&(Status'="")
	.q:(nullStatus'="Y")&&(Status'="Enable")
	.s Inclb=$p(^DHCIT(dhcit),"^",12)
	.q:(INCLB'="")&&(Inclb'=INCLB)
	.s count=count+1
	.s HVBarcode=$p(^DHCIT(dhcit),"^",2)
	.d OutPutRowItmTrack2
	
	Quit $$$OK

OutPutRowItmTrack2
	s Data=$lb(dhcit,HVBarcode,Status)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

}
