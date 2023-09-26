Import sqluser

/// Descript:打包收费
/// Creator: XuChao
/// CreateDate: 2015-08-01
Class web.DHCSTMHUI.DHCPackChargeLink Extends (%RegisteredObject, StkTypeM) [ Not ProcedureBlock ]
{

/// 插入
/// 返回 总数^成功^重复
ClassMethod Insert(Pack As %String, ListData As %String) As %Library.String
{
	n (Pack,ListData)
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
		s pclid=ItmObj.%Get("PCL")
		s incitm=ItmObj.%Get("Inci")
		&sql(select * from DHC_PackChargeLink where PCL_Pack_DR=:Pack and PCL_INCI_DR=:incitm)
		i SQLCODE'=0 d
		.i pclid'="" d
		..&sql(update DHC_PackChargeLink set PCL_INCI_DR=:incitm where PCL_rowid=:pclid)
		..i SQLCODE'=0 d
		...s sc=RtnObj.Err(-1,"","保存失败!") q
		.e  d
		..s packid=""
		..&sql(select PCL_RowId into :packid from DHC_PackChargeLink where PCL_Pack_DR=:Pack and isnull(PCL_INCI_DR,'')='')
		..i packid="" d
		...&sql(insert into DHC_PackChargeLink values(:Pack,:incitm))
		...i SQLCODE'=0 d
		....s sc=RtnObj.Err(-1,"","保存失败!") q
		..e  d
		...&sql(update DHC_PackChargeLink set PCL_INCI_DR=:incitm where %ID=:packid)
		...i SQLCODE'=0 d
		....s sc=RtnObj.Err(-1,"","保存失败!") q
		q:RtnObj.success'=0
	}
	i RtnObj.success'=0 tro  q RtnObj.Json()
	tc
	s RtnObj.rowid=0
	s RtnObj.msg="保存成功！"
	q RtnObj.Json()
}

/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.DHCPackChargeLink","GetPack","{""VendorId"":"""",""gUserId"":""4642"",""gLocId"":""392"",""gGroupId"":""264"",""gHospId"":""2"",""RowId"":""""}")
Query GetPack(Params As %String) As Query(ROWSPEC = "PackRowId,PackDesc,InciCode,VendorId,VendorDesc")
{
}

ClassMethod GetPackExecute(ByRef qHandle As %Binary, Params As %String) As %Status
{
	n (qHandle,Params)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)

	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 q $$$OK

	s PVendorId=PJObj.%Get("VendorId")
	s PackRowId=""
	f  s PackRowId=$o(^DHCPCL(0,"PACK",PackRowId),-1) q:PackRowId=""  d
	.s VendorInfo=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetPbVendor(PackRowId)
	.s VendorId=$p(VendorInfo,"^",1)
	.s VendorDesc=$p(VendorInfo,"^",2)
	.q:(PVendorId'="")&&(VendorId'=PVendorId)
	.s InciCode=$p(^INCI(PackRowId,1),"^",1)	;物资代码
	.s PackDesc=$p(^INCI(PackRowId,1),"^",2)	;物资名称
	.d OutPutRow
	Quit $$$OK

OutPutRow
	s Data=$lb(PackRowId,PackDesc,InciCode,VendorId,VendorDesc)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// Descript:	查询所包明细
/// Creator:	徐超
/// CreateDate: 2015-8-1
/// Table:	  DHC_PackChargeLink
/// Input:	  
/// Output:	 
/// Return：w ##class(web.DHCSTMHUI.DHCPackChargeLink).GetDetail(2)
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.DHCPackChargeLink","GetDetail",2)
Query GetDetail(Pack As %String) As Query(ROWSPEC = "PCL,Inci,InciDesc,Spec,InciCode,PbRp:%Float")
{
}

ClassMethod GetDetailExecute(ByRef qHandle As %Binary, Pack As %String) As %Status
{
	n (qHandle,Pack)
	
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	i Pack="" q $$$OK
	s PCL=""
	f  s PCL=$o(^DHCPCL(0,"PACK",Pack,PCL),-1) q:PCL=""  d
	.s Inci=$p(^DHCPCL(PCL),"^",2)
	.q:Inci=""
	.s InciCode=$p(^INCI(Inci,1),"^",1) ;物资名称
	.s InciDesc=$p(^INCI(Inci,1),"^",2) ;物资名称
	.s Spec=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetSpec("",Inci)
	.s PuomDr=$P(^INCI(Inci,3),"^",6) 
	.s PbRp=##class(web.DHCSTMHUI.Common.PriceCommon).GetPbRp(Inci,PuomDr)
	.d OutPutRowdd
	
	Quit $$$OK

OutPutRowdd
	s Data=$lb(PCL,Inci,InciDesc,Spec,InciCode,PbRp)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

ClassMethod DeleteLink(ListData) As %String
{
	n (ListData)
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
		s pclid=ItmObj.%Get("PCL")
		continue:pclid=""
		&sql(delete from DHC_PackChargeLink where %id=:pclid)
		i SQLCODE'=0 d
		.s sc=RtnObj.Err(-1,"","删除失败!") q
	}
	i RtnObj.success'=0 tro  q RtnObj.Json()
	tc
	s RtnObj.rowid=0
	s RtnObj.msg="删除成功！"
	q RtnObj.Json()
}

ClassMethod DeletePack(ListData) As %String
{
	n (ListData)
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
		s Inci=ItmObj.%Get("PackRowId")
		continue:Inci=""
		&sql(select %ID into :rowid from DHC_PackChargeLink where PCL_Pack_DR=:Inci)
		i rowid="" d
		.s ret=1
		e  d
		.&sql(delete from DHC_PackChargeLink where PCL_Pack_DR=:Inci)
		.i SQLCODE=0 d
		..s ret=0
		.e  d
		..s sc=RtnObj.Err(-1,"","删除失败!") q
	}
	i RtnObj.success'=0 tro  q RtnObj.Json()
	tc
	s RtnObj.rowid=0
	s RtnObj.msg="删除成功！"
	q RtnObj.Json()
}

}
