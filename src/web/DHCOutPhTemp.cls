Class web.DHCOutPhTemp Extends %RegisteredObject [ Not Abstract, ClassType = "", Not ProcedureBlock ]
{

/// Descripton:查找门诊退药申请单
/// Created by :zhwh
/// Create Date :2011-0508
/// Arguments:
///     loc - 药房
///     StartDate  -起始日期
///     EndDate -截止日期
///     OperUser - 操作人
///     thePrt - 发票
///     PrescNo - 处方号
///     PaNo -登记号
///     ctloc - 门诊科室
///     onlyAdmDoc - 仅当前操作人标志
///     
Query OutPhReqList(displocRowid As %String, StartDate As %String, EndDate As %String, OperUser As %String, thePrt As %String, PrescNo As %String, PaNo As %String, ctloc As %String, onlyAdmDoc As %String) As %Query(ROWSPEC = "req:%String,reqYear:%String,reqCode:%String,phd:%String,reqDate:%String,reqTime:%String,papmi:%String,reason:%String,prescNo:%String,retFlag:%String,prt:%String,userName:%String,pano:%String,paname:%String,age:%String,pasex:%String,invNo:%String,dispLoc:%String,ordDeptLoc:%String")
{
}

/// d ##class(%ResultSet).RunQuery("web.DHCOutPhTemp","OutPhReqList","","2018-11-09","2018-11-09","4634","","","","266","")
ClassMethod OutPhReqListExecute(ByRef QHandle As %Binary, displocRowid As %String, StartDate As %String, EndDate As %String, OperUser As %String, thePrt As %String, PrescNo As %String, PaNo As %String, ctloc As %String, onlyAdmDoc As %String) As %Status
{
 Set repid=$I(^CacheTemp)
 Set QHandle=$lb(0,repid,0)
 Set ind=1
 
 i StartDate="" q $$$OK
 i EndDate="" q $$$OK
 s StartDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(StartDate)
 s EndDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(EndDate)
 s reqRowid=""
 f  s reqRowid=$o(^DHCPHREQ(reqRowid)) q:reqRowid=""  d
 .q:'$d(^DHCPHREQ(reqRowid))
 .//过滤-退费申请生成的
 .s reqItm=$o(^DHCPHREQ(reqRowid,"I",""))
 .s refundReqMark=$p(^DHCPHREQ(reqRowid,"I",reqItm),"^",7)
 .q:refundReqMark'=""			
 .s reqYear=$p(^DHCPHREQ(reqRowid),"^",18)
 .s reqDate=$p(^DHCPHREQ(reqRowid),"^",4)
 .q:(reqDate>EndDate)||(reqDate<StartDate)
 .s reqDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(reqDate)
 .s reqTime=$p(^DHCPHREQ(reqRowid),"^",16)
 .s reqTime=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(reqTime)
 .s reqCode=$p(^DHCPHREQ(reqRowid),"^",2)
 .s papmi=$p(^DHCPHREQ(reqRowid),"^",6)
 .s age=##class(web.DHCSTKUTIL).GetAge(papmi)  //年龄
 .s pmino=$p(^PAPER(papmi,"PAT",1),"^",1)
 .i PaNo'="" q:pmino'=PaNo //病人
 .s patname=$p(^PAPER(papmi,"ALL"),"^",1)
 .s patsex=$p(^PAPER(papmi,"ALL"),"^",7)
 .s patsex=$P($g(^CT("SEX",patsex)),"^",2)
 .s phd=$p(^DHCPHREQ(reqRowid),"^",7)
 .s reasonDr=$p(^DHCPHREQ(reqRowid),"^",13)
 .s reason=$p(^DHCINVOPREFR(reasonDr),"^",2)
 .s prescno=$p(^DHCPHREQ(reqRowid),"^",8)
 .i PrescNo'="" q:prescno'=PrescNo  //处方号
 .s retFlag=$p(^DHCPHREQ(reqRowid),"^",11)
 .s prt=$p(^DHCPHREQ(reqRowid),"^",9)
 .i thePrt'="" q:thePrt'=prt   //发票
 .s Str=##class(web.DHCOutPhCommon).GetHandTime(prescno)    //发票的信息
 .s invNo=$p(Str,"^",5)
 .//s invNo=""
 .//s:invNo'="" invNo=$p(^DHCINVPRT(prt),"^",14)
 .s user=$p(^DHCPHREQ(reqRowid),"^",17)
 .s userName=$P($g(^SSU("SSUSR",user)),"^",2)
 .i onlyAdmDoc="on" q:OperUser'=user //仅当前操作人
 .s loc=$p(^DHCPHREQ(reqRowid),"^",3)
 .i displocRowid'="" q:displocRowid'=loc  //药房
 .s dispLoc=$p(^CTLOC(loc),"^",2)
 .i dispLoc["-" s dispLoc=$p(dispLoc,"-",2)
 .s ordRowId=""
 .f  s ordRowId=$o(^OEORD(0,"PrescNo",prescno,ordRowId)) q:ordRowId=""  d
 ..s ordsub=""
 ..f  s ordsub=$o(^OEORD(0,"PrescNo",prescno,ordRowId,ordsub)) q:ordsub=""  d
 ...s ordDeptLoc=$p(^OEORD(ordRowId,"I",ordsub,1),"^",3)
 ...s ordDeptLocDesc=$p(^CTLOC(ordDeptLoc),"^",2)
 ...i ordDeptLocDesc["-" s ordDeptLocDesc=$p(ordDeptLocDesc,"-",2)
 ...s admDoc=$p(^OEORD(ordRowId,"I",ordsub,7),"^",1)
 ...q:ordDeptLoc'=ctloc  //控制请求的科室
 .set Data=$lb(reqRowid,reqYear,reqCode,phd,reqDate,reqTime,papmi,reason,prescno,retFlag,prt,userName,pmino,patname,age,patsex,invNo,dispLoc,ordDeptLocDesc)
 .Set ^CacheTemp(repid,ind)=Data	
 .Set ind=ind+1
 Set QHandle=$lb(0,repid,0)
 Quit $$$OK
}

ClassMethod OutPhReqListFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = OutPhReqListExecute ]
{
	Set AtEnd=$LIST(QHandle,1)
	Set repid=$LIST(QHandle,2)
	Set ind=$LIST(QHandle,3)
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {				// if there are no more rows, finish fetching
		Set AtEnd=1
		Set Row=""
	}
	Else {			
			Set Row=^CacheTemp(repid,ind)
	}
	s QHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod OutPhReqListClose(ByRef QHandle As %Binary) As %Status [ PlaceAfter = OutPhReqListExecute ]
{
 Set repid=$li(QHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

/// w ##class(web.DHCOutPhTemp).OutPhReqItem()
Query OutPhReqItem(req As %String) As %Query(ROWSPEC = "reqi:%String,phdi:%String,oeori:%String,prt:%String,arcimDesc:%String,uom:%String,dispQty:%String,reqQty:%String,retQty:%String,dispAmt:%String,sp:%String,invNo:%String,prescno:%String,reqAmt:%String,cyFlag:%String")
{
}

/// d ##class(%ResultSet).RunQuery("web.DHCOutPhTemp","OutPhReqItem","11")
ClassMethod OutPhReqItemExecute(ByRef QHandle As %Binary, req As %String) As %Status
{
 Set repid=$I(^CacheTemp)
 Set QHandle=$lb(0,repid,0)
 s ind=1
 q:req="" $$$OK
 q:'$d(^DHCPHREQ(req)) $$$OK
 s reqloc=$p(^DHCPHREQ(req),"^",3)
 s CustStr=##Class(web.DHCSTCOMMO).GetLocCust(reqloc)
 s HospID=$p(CustStr,"^",5)
 s CustID=$p(CustStr,"^",1)
 s Perv="^^^"_""_"^"_CustID_"^DHC"
 s (prt,invNo)="" // 没用
 s reqItm=0
 f  s reqItm=$o(^DHCPHREQ(req,"I",reqItm)) q:reqItm=""  d
 .s reqItmData=^DHCPHREQ(req,"I",reqItm)
 .s reqItmId=req_"||"_reqItm
 .s reqQty=$p(reqItmData,"^",4)
 .s phdItmLbId=$p(reqItmData,"^",10)
 .s retQty=$p(reqItmData,"^",5)
 .s phdId=+phdItmLbId
 .s phdItm=+$p(phdItmLbId,"||",2)
 .s phdItmLb=+$p(phdItmLbId,"||",3)
 .s phdItmLbData=$g(^DHCPHDI(phdId,"PHDI",phdItm,"INCLB",phdItmLb))
 .s oeori=$p($g(^DHCPHDI(phdId,"PHDI",phdItm)),"^",5)
 .q:oeori=""
 .s ordId=+oeori
 .s ordItm=+$p(oeori,"||",2)
 .s dispQty=$p(phdItmLbData,"^",1)
 .s sp=$p(phdItmLbData,"^",7) // 基本单位售价
 .s inclb=$p(phdItmLbData,"^",3) 
 .s inci=+inclb
 .s spdate=+$h 
 .s getSpInc=$s(inclb'="":inclb,1:inci)
 .s:sp=0 sp=##class(web.DHCSTPRICE).GetSp(getSpInc,+spdate,"",HospID,"","")	//没发票的需要按最新进价
 .s reqSpAmt=reqQty*sp
 .s prescNo=$p($g(^OEORD(ordId,"I",ordItm,1)),"^",14)
 .s queId=##class(web.DHCPHACOM.ComPubClass.HMPrescMethod).PrescCYQueId(prescNo)
 .s cyFlag=$s(queId'="":"Y",1:"")
 .s dispSpAmt=$p(phdItmLbData,"^",8)
 .s incDesc=$p(^INCI(+inclb,1),"^",2)
 .s reqSpAmt=##Class(web.DHCSTCOMMPARA).GetNumbDec(reqSpAmt,Perv,"FmtSA",1)
 .s dispUomId=$p($g(^OEORD(ordId,"I",ordItm,"DHC")),"^",13) 
 .i dispUomId'="" d
 ..s fmtReqQtyUomStr=##class(web.DHCSTCOMMONSRV).BQtyToPhaUomQty(+inclb,reqQty,dispUomId)
 .e  d
 ..s fmtReqQtyUomStr=##class(web.DHCSTCOMMONSRV).BQtyToOutUomQty(+inclb,reqQty)
 .s reqQty=$p(fmtReqQtyUomStr,"^",1)
 .
 .s uomId=$p(fmtReqQtyUomStr,"^",2)
 .s fac=$p(fmtReqQtyUomStr,"^",3)
 .s uomDesc=$p($g(^CT("UOM",uomId)),"^",2)
 .s sp=sp*fac
 .s dispQty=dispQty/fac
 .s retQty=retQty/fac
 .i (sp<1)&&($p(sp,".",1)="") s sp=0_sp
 .i (reqSpAmt<1)&&($p(reqSpAmt,".",1)="") s reqSpAmt=0_reqSpAmt
 .i (reqQty<1)&&($p(reqQty,".",1)="") s reqQty=0_reqQty
 .i (retQty<1)&&($p(retQty,".",1)="") s retQty=0_retQty
 .i (dispSpAmt<1)&&($p(dispSpAmt,".",1)="") s dispSpAmt=0_dispSpAmt
 .i (dispQty<1)&&($p(dispQty,".",1)="") s dispQty=0_dispQty
 .d OutPutItm
 Set QHandle=$lb(0,repid,0)
 Quit $$$OK
OutPutItm
 set Data=$lb(reqItmId,phdItmLbId,oeori,prt,incDesc,uomDesc,dispQty,reqQty,retQty,dispSpAmt,sp,invNo,prescNo,reqSpAmt,cyFlag)
 Set ^CacheTemp(repid,ind)=Data	
 Set ind=ind+1
 q
}

ClassMethod OutPhReqItemFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = OutPhReqItemExecute ]
{
 Set AtEnd=$li(QHandle,1)
 Set repid=$li(QHandle,2)
 Set ind=$li(QHandle,3)

 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {	 
	 Set AtEnd=1
	 Set Row=""
 }
 Else      {	 
	 Set Row=^CacheTemp(repid,ind)
 }
 s QHandle=$lb(AtEnd,repid,ind)
 Quit $$$OK
}

ClassMethod OutPhReqItemClose(ByRef QHandle As %Binary) As %Status [ PlaceAfter = OutPhReqItemExecute ]
{
 
 Set repid=$li(QHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

/// description: 删除明细
/// w ##class(web.DHCOutPhTemp).DeleteItms("3||1")
ClassMethod DeleteItms(reqItmIds)
{
	q:reqItmIds="" "-1^明细Id为空"
	s errInfo=""
	s len=$l(reqItmIds,"^")
	s i=""
	f i=1:1:len d
	.s errCode=""
	.s reqItmId=$p(reqItmIds,"^",i)
	.q:reqItmId=""
	.s reqId=+reqItmId
	.s reqItm=+$p(reqItmId,"||",2)
	.s refundFlag=$p($g(^DHCPHREQ(+reqId)),"^",11)
	.i refundFlag=1 d
	..s errCode=-1
	..i errInfo="" s errInfo="已退药，不能删除"
	..e  s errInfo=errInfo_"</br>已退药"
	.q:errCode'=""
	.s retedQty=$p($g(^DHCPHREQ(+reqId,"I",reqItm)),"^",5)
	.i retedQty>0 d
	..s errCode=-1
	..i errInfo="" s errInfo="已退药，不能删除"
	..e  s errInfo=errInfo_"</br>已退药"
	.q:errCode'=""
	.&SQL(delete from SQLUser.dhc_phreqitem where PHReqi_Rowid=:reqItmId)
	.&SQL(SELECT count(*) into :itmCnt FROM SQLUser.dhc_phreqitem WHERE PHReqi_PHReq_parref=:reqId AND PHReqi_Child>0 )
	.i +itmCnt=0 d
	..&sql(delete from SQLUser.dhc_phrequest where PHReq_Rowid=:reqId)
	q:errInfo'="" "-1^"_errInfo
	q 0
}

}
