Import sqluser

/// Descript:高值跟踪明细
/// Creator:    wangjiabin
/// CreateDate: 2013-10-17
Class web.DHCSTMHUI.DHCItmTrackDetail Extends (%RegisteredObject, StkTypeM) [ Not ProcedureBlock ]
{

/// Descript:	保存高值跟踪明细信息
/// Table:		dhc_itmtrackdetail
/// Input:		dhcit,业务类型,业务子表rowid,user
/// Output:		RtnObj
ClassMethod Save(dhcit As %String, type As %String, pointer As %String, user As %String) As RtnObj
{
	n (dhcit,type,pointer,user)
	s RtnObj=##class(RtnObj).%New()
	s MethodName=$CLASSNAME()_".Save"
	i dhcit="" q RtnObj.Err(-1,"",MethodName_":参数错误")

	s obj=##class(User.DHCItmTrackDetail).%New(dhcit)
	s ch=+$o(^DHCITD(dhcit,"I",""),-1)+1
	s d=+$h,t=$p($h,",",2)
	d obj.DHCITDParrefSetObjectId(dhcit)
	s obj.DHCITDChildSub=ch
	s obj.DHCITDType=type
	s obj.DHCITDPointer=pointer
	s obj.DHCITDDate=d
	s obj.DHCITDTime=t
	d obj.DHCITDSSUSRDRSetObjectId(user)
	s sc=obj.%Save()
	i $$$ISERR(sc) q RtnObj.Err(-2,rowid,MethodName_":跟踪明细记录错误")
	q RtnObj
}

/// Descript:   根据业务类型和业务子表rowid删除高值跟踪明细信息
/// Creator:    wangjiabin
/// CreateDate: 2013-10-17
/// Table:dhc_itmtrackdetail
/// Input:		业务类型,子表rowid
/// Output:     
/// Return：0：成功，
ClassMethod DelByPointer(Type As %String, Pointer As %String) As RtnObj
{
	n (Type,Pointer)
	s MethodName=$CLASSNAME()_".DelByPointer"
	s RtnObj=##class(RtnObj).%New()
	
	s dhcit=$o(^DHCITD(0,"Type",Type,"Pointer",Pointer,0))
	q:dhcit="" RtnObj
	
	s ch=$o(^DHCITD(0,"Type",Type,"Pointer",Pointer,dhcit,0))
	q:ch="" RtnObj
	
	s dhcitd=dhcit_"||"_ch
	s RtnObj=..Delete(dhcitd)
	q:RtnObj.success<0 RtnObj
	
	s OldStatus=$p(^DHCIT(dhcit),"^",5)
	s OriginalStatus=$p(^DHCIT(dhcit),"^",35)
	s lastType=""
	s lastch=$o(^DHCITD(dhcit,"I",""),-1)
	i lastch'="" d
	.s lastType=$p(^DHCITD(dhcit,"I",lastch),"^",2)	
	i ((Type="G")&&(OldStatus="Enable")&&($o(^DHCITD(dhcit,"I",""),-1)="")) d
	.;条码可用时,删除入库记录且没有其他明细的,状态至于空
	.s newStatus=""
	else  if (Type="L")&&(OldStatus="Enable") d
	.s newStatus="InDisp"
	else  if (Type="A")&&(lastType="A")&&(OriginalStatus'="NotUnique") d
	.s newStatus="InAdj"
	else  if (Type="A")&&(lastType="D")&&(OriginalStatus'="NotUnique") d
	.s newStatus="InScrap"
	e  d
	.s newStatus="Enable"	
	&sql(update DHC_ItmTrack set DHCIT_Status=:newStatus where %id=:dhcit)
	i SQLCODE d
	.d RtnObj.Err(-1,"",MethodName_".DelByPointer:SQLCODE"_SQLCODE_":"_$g(%msg))
	q:RtnObj.success<0 RtnObj
	
	q RtnObj
}

/// Descript:   删除高值跟踪明细信息
/// Creator:    wangjiabin
/// CreateDate: 2013-10-17
/// Table:dhc_itmtrackdetail
/// Input:		子表rowid
/// Output:     
/// Return:		0：成功
ClassMethod Delete(dhcitd As %String) As RtnObj
{
	n (dhcitd)
	s MethodName=$CLASSNAME()_".Delete"
	s RtnObj=##class(RtnObj).%New()
	q:dhcitd="" RtnObj
	&sql(delete from DHC_ItmTrackDetail where %id=:dhcitd)
	i SQLCODE<0 d RtnObj.Err(SQLCODE,dhcitd,MethodName_":SQLCODE"_SQLCODE_":"_$g(%msg))

	q RtnObj
}

}
