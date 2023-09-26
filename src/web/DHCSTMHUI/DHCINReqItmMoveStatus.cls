Import sqluser

/// 请求单明细状态相关类
/// 2015-05-15
/// 徐超
/// ##class(web.DHCSTMHUI.DHCINReqItmMoveStatus)
Class web.DHCSTMHUI.DHCINReqItmMoveStatus Extends (%RegisteredObject, StkTypeM) [ Not ProcedureBlock ]
{

/// Descript:   完成时候改变状态
/// Creater:    徐超
/// CreateDate: 2015-05-15
/// Table:DHC_INReqItm_MoveStatus
/// Input:		相应(主表)Pointer,状态,操作人,类型(RQ:请求单,PP:采购单,PO:订单,G:入库,T:出库)
/// Output:     
/// Return：rowid
ClassMethod Complete(MPointer As %String, MoveStatus As %String, User As %String, Type As %String) As %Library.String
{
	n (MPointer,MoveStatus,User,Type)
	q:MPointer="" ""
	i Type="T" d
	.s ch=0
	.f  s ch=$o(^DHCINIT(MPointer,"ITI",ch)) q:ch=""  d
	..s ret=..Insert(MPointer_"||"_ch,MoveStatus,User,Type)

	i Type="G" d
	.s ch=0
	.f  s ch=$o(^DHCINGR(MPointer,"GRI",ch)) q:ch=""  d
	..s ret=..Insert(MPointer_"||"_ch,MoveStatus,User,Type)

	i Type="PO" d
	.s ch=0
	.f  s ch=$o(^INPO(MPointer,"POI",ch)) q:ch=""  d
	..s ret=..Insert(MPointer_"||"_ch,MoveStatus,User,Type)

	i Type="PP" d
	.s ch=0
	.f  s ch=$o(^INPP(MPointer,"PPI",ch)) q:ch=""  d
	..s ret=..Insert(MPointer_"||"_ch,MoveStatus,User,Type)

	i Type="RQ" d
	.s ch=0
	.f  s ch=$o(^INRQ(MPointer,"RQI",ch)) q:ch=""  d
	..s ret=..Insert(MPointer_"||"_ch,MoveStatus,User,Type)

	q
}

/// Descript:   取消完成时候改变状态
/// Creater:    徐超
/// CreateDate: 2015-05-15
/// Table:DHC_INReqItm_MoveStatus
/// Input:相应Pointer,状态,操作人,类型
/// Output:     
/// Return：rowid
ClassMethod UnComplete(MPointer As %String, MoveStatus As %String, Type As %String) As %Library.String
{
	n (MPointer,MoveStatus,Type)
	q:MPointer="" ""
	i Type="T" d
	.s ch=0
	.f  s ch=$o(^DHCINIT(MPointer,"ITI",ch)) q:ch=""  d
	..s ret=..Delete(MPointer_"||"_ch,MoveStatus)

	i Type="G" d
	.s ch=0
	.f  s ch=$o(^DHCINGR(MPointer,"GRI",ch)) q:ch=""  d
	..s ret=..Delete(MPointer_"||"_ch,MoveStatus)

	i Type="PO" d
	.s ch=0
	.f  s ch=$o(^INPO(MPointer,"POI",ch)) q:ch=""  d
	..s ret=..Delete(MPointer_"||"_ch,MoveStatus)

	i Type="PP" d
	.s ch=0
	.f  s ch=$o(^INPP(MPointer,"PPI",ch)) q:ch=""  d
	..s ret=..Delete(MPointer_"||"_ch,MoveStatus)

	i Type="RQ" d
	.s ch=0
	.f  s ch=$o(^INRQ(MPointer,"RQI",ch)) q:ch=""  d
	..s ret=..Delete(MPointer_"||"_ch,MoveStatus)
	q 0
}

/// Descript:   增加请求单明细状态
/// Creater:    徐超
/// CreateDate: 2015-05-15
/// Table:DHC_INReqItm_MoveStatus
/// Input:相应Pointer,状态,操作人,类型
/// Output:     
/// Return：rowid
ClassMethod Insert(Pointer As %String, MoveStatus As %String, User As %String, Type As %String, Remark As %String = "") As %Library.String
{
	n (Pointer,MoveStatus,User,Type,Remark)
	q:Pointer="" ""
	s d=+$h
	s t=$P($h,",",2)
	s InrqiStr=..GetInrqiStr(Pointer,Type)
	q:InrqiStr="" 0
	s len=$l(InrqiStr,"^")
	f i=1:1:len d
	.s Inrqi=$p(InrqiStr,"^",i)
	.s Inrq=+Inrqi,InrqiCh=$p(Inrqi,"||",2)
	.q:(Inrq="")||(InrqiCh="")
	.q:'$d(^INRQ(Inrq,"RQI",InrqiCh))
	.&sql(Insert into DHC_INReqItm_MoveStatus(IM_INRQI_DR,IM_MoveStatus,IM_SSUSR_DR,IM_Date,IM_Time,IM_Type,IM_Pointer,IM_Remark)
		values(:Inrqi,:MoveStatus,:User,:d,:t,:Type,:Pointer,:Remark))
	q 0
}

/// Descript:   删除请求单明细状态
/// Creater:    xuchao
/// CreateDate: 2015-05-15
/// Table:DHC_INReqItm_MoveStatus
/// Input:Pointer
/// Output:     
/// Return:0
ClassMethod Delete(Pointer As %String, MoveStatus As %String) As %Library.String
{
	n (Pointer,MoveStatus)
	q:Pointer="" ""
	q:MoveStatus="" ""
	&sql(select * from DHC_INReqItm_MoveStatus where IM_Pointer=:Pointer and IM_MoveStatus=:MoveStatus)
	q:SQLCODE 0
	&sql(Delete from DHC_INReqItm_MoveStatus where IM_Pointer=:Pointer and IM_MoveStatus=:MoveStatus)
	q 0
}

/// Descript:   查询增加请求单明细状态
/// Creater:    徐超
/// CreateDate: 2015-05-15
/// Table:DHC_INReqItm_MoveStatus
/// Input:
/// Output:     
/// Return：请求单明细状态
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.DHCINReqItmMoveStatus","QueryReqDetail","13,23")
Query QueryReqDetail(Req As %String) As Query(ROWSPEC = "RowId,Inci,InciCode,InciDesc,Spec,Qty:%Float,UomDesc,RefuseFlag,RD,RA,EA,PD,PA,POD,POA,IMD,IMA,ID,IO,IIR,II,HanleType,SpecDesc,Manf,initinfo")
{
}

ClassMethod QueryReqDetailExecute(ByRef qHandle As %Binary, Req As %String) As %Status
{
	n (qHandle,Req)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	
	s len=$l(Req,",")
	f i=1:1:len  d
	.s ReqId=$p(Req,",",i)
	.s ReqNo=$p(^INRQ(ReqId),"^",1)
	.s ToLocId=$p(^INRQ(ReqId),"^",6)
	.s ToLocDesc=$p(^CTLOC(ToLocId),"^",2)
	.s FrLocId=$p(^INRQ(ReqId),"^",5)
	.s FrLocDesc=$p(^CTLOC(FrLocId),"^",2)
	.s Chl=""
	.f  s Chl=$o(^INRQ(ReqId,"RQI",Chl)) q:Chl=""  d
	..s RowId=ReqId_"||"_Chl
	..s Inci=$p(^INRQ(ReqId,"RQI",Chl),"^",4)
	..s InciCode=$p($G(^INCI(Inci,1)),"^",1)
	..s InciDesc=$p($G(^INCI(Inci,1)),"^",2)
	..s Qty=$p(^INRQ(ReqId,"RQI",Chl),"^",3)
	..s Uom=$p(^INRQ(ReqId,"RQI",Chl),"^",5)
	..s UomDesc=$p(^CT("UOM",Uom),"^",2)
	..s RefuseFlag=$p(^INRQ(ReqId,"RQI",Chl),"^",6)
	..s:RefuseFlag'="Y" RefuseFlag="N"
	..s Spec=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetSpec("",Inci)
	..s Manf=$p(##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetManf(Inci),"^",3)
	..s Rp=##class(web.DHCSTMHUI.Common.PriceCommon).GetInciLRp(Inci,Uom,"")
	..s RpAmt=Rp*Qty
	..s HanleType=""
	..s dhcinrqi=$o(^DHCINRQI(0,"INRQI",RowId,""))
	..s HanleType=$p(^DHCINRQI(dhcinrqi),"^",7)
	..s Canceled=$p(^DHCINRQI(dhcinrqi),"^",8)
	..s Remark=$p(^DHCINRQI(dhcinrqi),"^",2)
	..s QtyApproved=$p(^DHCINRQI(dhcinrqi),"^",3)
	..s SpecDesc=$p(^DHCINRQI(dhcinrqi),"^",6)
	..s initinfo=##class(web.DHCSTMHUI.INReqItm).GetTrfInfoByReqi(RowId)
	..s:HanleType=1 HanleType="采购"
	..s:HanleType=0 HanleType="出库"
	..s statusstr=..GetInrqiStatus(RowId)
	..s RD=$p(statusstr,"^",1)
	..s RA=$p(statusstr,"^",2)
	..s EA=$p(statusstr,"^",3)
	..s PD=$p(statusstr,"^",4)
	..s PA=$p(statusstr,"^",5)
	..s POD=$p(statusstr,"^",6)
	..s POA=$p(statusstr,"^",7)
	..s IMD=$p(statusstr,"^",8)
	..s IMA=$p(statusstr,"^",9)
	..s ID=$p(statusstr,"^",10)
	..s IO=$p(statusstr,"^",11)
	..s IIR=$p(statusstr,"^",12)
	..s II=$p(statusstr,"^",13)
	..d OutPutRow
	
	Quit $$$OK
 
OutPutRow
	s Data=$lb(RowId,Inci,InciCode,InciDesc,Spec,Qty,UomDesc,RefuseFlag,RD,RA,EA,PD,PA,POD,POA,IMD,IMA,ID,IO,IIR,II,HanleType,SpecDesc,Manf,initinfo)   
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// 状态表
/// Req Done,Audited By RecLoc,Audited By ExecuteLoc,Init Done,Init Out,Init In Refused,Init In,PurPlan Done,PurPlan Audit,IMP Done,IMP Audit ,PO Done, PO Audit
/// RD,     RA,                EA,                   ID,       IO,      IIR,            II,     PD,          PA,           IMD,     IMA		POD    POA
///               RQ					   	T					PP			G		PO
/// w ##class(web.DHCSTMHUI.DHCINReqItmMoveStatus).GetInrqi("4||1","T")
ClassMethod GetInrqi(Pointer As %String, Type As %String) As %Library.String
{
	n (Pointer,Type)
	s ret=0
	q:Pointer="" ""
	q:Type="" ""
	
	s RowId=$p(Pointer,"||",1)
	s ch=$p(Pointer,"||",2)

	i Type="T" d
	.s:'$d(^DHCINIT(RowId,"ITI",ch)) ret=-2
	.q:ret<0
	.s ingri=$p(^DHCINIT(RowId,"ITI",ch),"^",26)
	.i ingri'="" d
	..s Type="G"
	..s RowId=+ingri
	..s ch=$p(ingri,"||",2)
	..s Pointer=ingri
	.e  d
	..s ret=-2
	q:ret<0 ret
	i Type="G" d
	.s:'$d(^DHCINGR(RowId,"GRI",ch)) ret=-2
	.q:ret<0
	.s poi=$p(^DHCINGR(RowId,"GRI",ch),"^",17)
	.i poi'="" d
	..s Type="PO"
	..s Pointer=poi
	.e  d
	..s ret=-2
	q:ret<0 ret
	
	i Type="PO" d
	.s Pur=$o(^INPP(0,"INPOI",Pointer,0))
	.s:+Pur=0 ret=-2
	.q:ret<0
	.s Purchl=$o(^INPP(0,"INPOI",Pointer,Pur,0))
	.s:+Purchl=0 ret=-2
	.q:ret<0
	.s ppi=Pur_"||"_Purchl
	.i ppi'="" d
	..s Type="PP"
	..s RowId=Pur
	..s ch=Purchl
	..s Pointer=ppi
	.e  d
	..s ret=-2
	q:ret<0 ret

	i Type="PP" d
	.s sub=$o(^INPP(RowId,"PPI",ch,"RQI",0))
	.s:sub="" ret=-2
	.q:ret<0
	.s reqi=$p(^INPP(RowId,"PPI",ch,"RQI",sub),"^",1)
	.i reqi'="" d
	..s Type="RQ"
	..s Pointer=reqi
	.e  d
	..s ret=-2
	q:ret<0 ret
	
	i Type="RQ" d
	.s reqi=Pointer

	q reqi
}

/// Descript:	获取inrqi串(^隔开)
/// Creator:	wangjiabin
/// CreateDate:	2016-11-21
/// w ##class(web.DHCSTMHUI.DHCINReqItmMoveStatus).GetInrqiStr("4||1","T")
ClassMethod GetInrqiStr(Pointer As %String, Type As %String) As %Library.String
{
	n (Pointer,Type)
	s ret=0
	q:Pointer="" ""
	q:Type="" ""
	
	s RowId=$p(Pointer,"||",1),ch=$p(Pointer,"||",2)
	q:(RowId="")||(ch="") ""
	
	s InrqiStr=""
	;考虑采购计划一对多的情况, 其他获取上一类型,从dhc_inreqitm_movestatus里取值
	i Type="T" d
	.s ingri="",inrqi=""
	.q:'$d(^DHCINIT(RowId,"ITI",ch))
	.s ingri=$p(^DHCINIT(RowId,"ITI",ch),"^",26)
	.s inrqi=$p(^DHCINIT(RowId,"ITI",ch),"^",2)
	.i ingri'="" d
	..;根据入库单出库的情况
	..s InrqiStr=$$GetInrqiStrByPointer("G",ingri)
	.e  i inrqi'="" d
	..;根据请求单出库的情况
	..s InrqiStr=inrqi
	.
	e  i Type="G" d
	.q:'$d(^DHCINGR(RowId,"GRI",ch))
	.s Pointer=$p(^DHCINGR(RowId,"GRI",ch),"^",17)
	.s InrqiStr=$$GetInrqiStrByPointer("PO",Pointer)
	.
	e  i Type="PO" d
	.s Pur=$o(^INPP(0,"INPOI",Pointer,0))
	.q:+Pur=0
	.s Purchl=$o(^INPP(0,"INPOI",Pointer,Pur,0))
	.q:+Purchl=0
	.s Pointer=Pur_"||"_Purchl
	.s InrqiStr=$$GetInrqiStrByPointer("PP",Pointer)
	.
	e  i Type="PP" d
	.s sub=0
	.f  s sub=$o(^INPP(RowId,"PPI",ch,"RQI",sub)) q:sub=""  d
	..s inrqi=$p(^INPP(RowId,"PPI",ch,"RQI",sub),"^",1)
	..s InrqiStr=$$InrqiStrAdd(InrqiStr,inrqi)
	.
	e  i Type="RQ" d
	.s InrqiStr=Pointer

	q InrqiStr


InrqiStrAdd(InrqiStr,inrqi)
	n (InrqiStr,inrqi)
	i InrqiStr="" d
	.s InrqiStr=inrqi
	e  d
	.s InrqiStr=InrqiStr_"^"_inrqi
	q InrqiStr

GetInrqiStrByPointer(Type,Pointer)
	n (Type,Pointer)
	q:Type="" ""
	q:Pointer="" ""
	s InrqiStr=""
	s rowid=0
	f  s rowid=$o(^DHCINRQIMOVE(0,"TypePointer",Type,Pointer,rowid)) q:rowid=""  d
	.s inrqi=$p(^DHCINRQIMOVE(rowid),"^",1)
	.q:("^"_InrqiStr_"^")[("^"_inrqi_"^")
	.i InrqiStr="" d
	..s InrqiStr=inrqi
	.e  d
	..s InrqiStr=InrqiStr_"^"_inrqi
	q InrqiStr
}

/// 状态表
/// Req Done,Audited By RecLoc,Audited By ExecuteLoc,Init Done,Init Out,Init In Refused,Init In,PurPlan Done,PurPlan Audit,IMP Done,IMP Audit ,PO Done, PO Audit
/// RD,     RA,                EA,                   ID,       IO,      IIR,            II,     PD,          PA,           IMD,     IMA		POD    POA
///               RQ					   	T					PP			G		PO
/// w ##class(web.DHCSTMHUI.DHCINReqItmMoveStatus).GetInrqiStatus("23||1")
ClassMethod GetInrqiStatus(reqi As %String) As %Library.String
{
	n (reqi)
	s ret=""
	q:reqi="" ret
	s str="RD,RA,EA,PD,PA,POD,POA,IMD,IMA,ID,IO,IIR,II"
	s len=$l(str,",")
	f i=1:1:len  d
	.s MoveStatus=$p(str,",",i)
	.s RowId=$o(^DHCINRQIMOVE(0,"INRQIMS",reqi,MoveStatus,""),-1)
	.i RowId'="" d
	..i ret="" d
	...s ret="Y"
	..e  d
	...s ret=ret_"^Y"
	.e  d
	..i ret="" d
	...s ret="N"
	..e  d
	...s ret=ret_"^N"

	q ret
}

}
