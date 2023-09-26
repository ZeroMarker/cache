Import sqluser

/// Descript:库存项-院区零库存标志
/// Creater:lxt
/// CreateDate:2016-09-18
Class web.DHCSTMHUI.DHCIncHosp Extends (%RegisteredObject, StkTypeM) [ Not ProcedureBlock ]
{

/// Descript:	查询库存项院区零库存标志
/// Creater:	lxt
/// CreateDate:	2016-09-18
/// Table:      INC_Zero
/// Input:      库存项id
/// Output:
/// Return：    院区,零库存标志
/// w ##class(web.DHCSTMHUI.DHCIncHosp).Select(13)
Query Select(Inci As %String) As Query(ROWSPEC = "RowId,HospId,HospCode,HospDesc,Zero") [ SqlProc ]
{
}

ClassMethod SelectExecute(ByRef qHandle As %Binary, Inci As %String) As %Status
{
	n (qHandle,Inci)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	q:Inci="" $$$OK
	s HospId=0
	f  s HospId=$o(^CT("HOSP",HospId))  q:HospId=""  d
	.s HospCode=$p(^CT("HOSP",HospId),"^",1)
	.s HospDesc=$p(^CT("HOSP",HospId),"^",2)
	.s Zero="",RowId=""
	.&sql(select IncHosp_ROWID,IncHosp_Zero into :RowId,:Zero from DHC_INCHosp where IncHosp_INCI_DR=:Inci and IncHosp_HOSP_DR=:HospId)
	.d OutPutRow
	
	Quit $$$OK
OutPutRow
	s Data=$lb(RowId,HospId,HospCode,HospDesc,Zero)   
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// Descript:	保存库存项院区零库存标志
/// Creater:	lxt
/// CreateDate:	2016-09-18
/// Table:      INC_Zero
/// Input:      库存项id^零库存ID^院区ID^零库存标志
/// Output:
/// Return：0,成功; -1：库存项为空,-2:不存在该库存项，错误数据串：保存失败
/// w ##class(web.DHCSTMHUI.DHCIncHosp).Save(13,"^2^N^Y")
ClassMethod Save(Inci, ListData) As %Library.String
{
 	n (Inci,ListData)
	s $ZT=..sssError()
	s paramStr=..sssParamStr()
   	s RtnObj=##class(RtnObj).%New()
	i Inci="" d RtnObj.Err(-1,"","库存项不能为空!","",0)
	s ItmCode=$p(^INCI(Inci,1),"^",1)
	s ItmDesc=$p(^INCI(Inci,1),"^",2)
	q:RtnObj.success'=0 RtnObj.Json() 
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(ListData)
	i Sc'=0 d
	.s Sc=RtnObj.Err(-1,"","入参解析失败!")
	q:RtnObj.success'=0 RtnObj.Json()
	ts
	while(RtnObj.success=0){
		s Obj=PJObj.%Pop()
		q:Obj=""
		s Rowid=Obj.%Get("RowId")
		s Zero=Obj.%Get("Zero")
		s HospId=Obj.%Get("HospId")
	    i Rowid'=""  d
	    .&sql(Update DHC_INCHOSP Set IncHosp_Zero=:Zero Where IncHosp_ROWID=:Rowid)
	    .i SQLCODE'=0  d
		..d RtnObj.Err(-1,"","更新失败!")
		e  d
		.&sql(INSERT INTO DHC_INCHosp (IncHosp_INCI_DR,IncHosp_HOSP_DR,IncHosp_Zero) VALUES (:Inci,:HospId,:Zero))
		.i SQLCODE'=0  d
	 	..d RtnObj.Err(-1,"","插入失败",$ClassName()_".Save:SQLCODE"_SQLCODE_":"_$g(%msg))
	}
	i RtnObj.success=0 d
	.tc 
	else  d
	.tro
	q RtnObj.Json()
}

/// Descript:	查询库存项院区零库存标志串
/// Creater:	lxt
/// CreateDate:	2016-09-20
/// Table:INC_Zero
/// Input:库存项id
/// Output:院区标志1/院区标志2
/// w ##class(web.DHCSTMHUI.DHCIncHosp).GetHospZeroStr(13)
ClassMethod GetHospZeroStr(InciId) As %Library.String
{
	n (InciId)
	q:InciId="" ""
	s HospZeroStr=""
	s IncHospRowid=0
	f  s IncHospRowid=$o(^DHCINCHOSP(0,"INCI",InciId,IncHospRowid))  q:IncHospRowid=""  d
	.s Hospid=$p(^DHCINCHOSP(IncHospRowid),"^",2)
	.q:Hospid=""
	.s HospDesc=$p(^CT("HOSP",Hospid),"^",2)
	.s ZeroType=$p(^DHCINCHOSP(IncHospRowid),"^",3)
	.i ZeroType'=""  d
	..s HospZero=HospDesc_"-"_ZeroType
	..i HospZeroStr=""  d
	...s HospZeroStr=HospZero
	..e  d
	...s HospZeroStr=HospZeroStr_"/"_HospZero
	q HospZeroStr
}

}
