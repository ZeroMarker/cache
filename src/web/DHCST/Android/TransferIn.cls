Import sqluser

Class web.DHCST.Android.TransferIn Extends (%RegisteredObject, %XML.Adaptor) [ Not ProcedureBlock ]
{

/// Descript:查询待转移接收单据列表
/// w ##class(web.DHCST.Android.TransferIn).jsQueryTransferIn("2016-09-26","2016-09-26","","102")
ClassMethod jsQueryTransferIn(startDate As %String, endDate As %String, fromLocID As %String, toLocID As %String) As %GlobalCharacterStream
{
 	n (startDate, endDate, fromLocID, toLocID)
 	s:startDate'="" startDate=$zdh(startDate,3)
 	s:endDate'="" endDate=$zdh(endDate,3)
 	s count = 0
 	s ListStream=##class(%GlobalCharacterStream).%New()
 	s ListTitle="Init^TrNo^LocDesc^User"
 	f dd=startDate:1:endDate d
 	.s init = ""
 	.f  s init=$o(^DHCINIT(0,"AckDate",dd,init)) q:init=""  d
 	..s state=$p(^DHCINIT(init),"^",14)
 	..q:state'="21"
 	..s trNo=$p(^DHCINIT(init),"^",1)
 	..s fLocID=$p(^DHCINIT(init),"^",5)
 	..q:fLocID=""
 	..q:(fromLocID'="")&(fromLocID'=fLocID)
 	..s fLocDesc=$p($p(^CTLOC(fLocID),"^",2),"-",2)
 	..s tLocID=$p(^DHCINIT(init),"^",6)
 	..q:tLocID=""
 	..q:(toLocID'=tLocID)
 	..s userID=$p(^DHCINIT(init),"^",8)
 	..q:userID=""
 	..s userName=$p(^SSU("SSUSR",userID),"^",2)
 	..
 	..s ListData=init_"^"_trNo_"^"_fLocDesc_"^"_userName
 	..s outputjson=##class(web.DHCSTPHCMCOMMON).getJsonData(ListTitle,ListData)
	..s count = count+1       
	..I count=1 d
	...S tmpdel=""""
	...s tmpTitle="{"_tmpdel_"ErrCode"_tmpdel_":"_0_","_tmpdel_"rows"_tmpdel_":["
	...d ListStream.Write(tmpTitle)
	...d ListStream.Write(outputjson)
	..e  d
	...d ListStream.Write(",")
	...d ListStream.Write(outputjson)
	s EmptyJson="{ErrCode:0,rows:[]}"
 	i count>0 d ListStream.Write(##class(web.DHCSTPHCMCOMMON).getJsonEndSign())
 	e  d ListStream.Write(EmptyJson)
 	q ListStream
}

/// Descript:查询待转移接收单据明细列表
/// w ##class(web.DHCST.Android.TransferIn).jsQueryTransferInDet(4,"31")
ClassMethod jsQueryTransferInDet(init As %String, flag As %String) As %GlobalCharacterStream
{
 	n (init,flag)
 	//s ^yunhaibao("jsQueryTransferInDet")=init_","_flag
 	s ListStream=##class(%GlobalCharacterStream).%New()
 	s count = 0
 	s ListTitle="Initi^TrInciCode^TrInciDesc^TrQty^TrUom^TrReqQty"
 	s ch = ""
 	f  s ch=$o(^DHCINIT(init,"ITI",ch)) q:ch=""  d
 	.q:ch=0
 	.s status=$p(^DHCINIT(init,"ITI",ch),"^",23)
 	.q:flag'=status
 	.s trqty=$p(^DHCINIT(init,"ITI",ch),"^",1)
 	.s inrqi=$p(^DHCINIT(init,"ITI",ch),"^",2)
	.s inclb=$p(^DHCINIT(init,"ITI",ch),"^",3)
	.s inci=+inclb
	.s incicode=$p(^INCI(inci,1),"^",1)
	.s incidesc=$p(^INCI(inci,1),"^",2)
	.s truom=$p(^DHCINIT(init,"ITI",ch),"^",7)
	.q:truom=""
	.s truomdesc=$p(^CT("UOM",truom),"^",2)
	.s BUomId=$p(^INCI(inci,1),"^",10)
	.s reqQty=0
    .i inrqi'=""  d
    ..s reqQty=$p(^INRQ(+inrqi,"RQI",$p(inrqi,"||",2)),"^",3)
    ..s reqUom=$p(^INRQ(+inrqi,"RQI",$p(inrqi,"||",2)),"^",5)
    ..s fac1=##class(web.DHCST.Common.UtilCommon).UOMFac(reqUom,BUomId)
    ..s fac2=##class(web.DHCST.Common.UtilCommon).UOMFac(truom,BUomId)
    ..s reqQty=reqQty*fac1/fac2
 	.s ListData=init_"^"_incicode_"^"_incidesc_"^"_trqty_"^"_truomdesc_"^"_reqQty     
 	.s outputjson=##class(web.DHCSTPHCMCOMMON).getJsonData(ListTitle,ListData)
	.s count = count+1       
	.I count=1 d
	..S tmpdel=""""
	..s tmpTitle="{"_tmpdel_"ErrCode"_tmpdel_":"_0_","_tmpdel_"rows"_tmpdel_":["
	..d ListStream.Write(tmpTitle)
	..d ListStream.Write(outputjson)
	.e  d
	..d ListStream.Write(",")
	..d ListStream.Write(outputjson)
	s EmptyJson="{ErrCode:0,rows:[]}"
 	i count>0 d ListStream.Write(##class(web.DHCSTPHCMCOMMON).getJsonEndSign())
 	e  d ListStream.Write(EmptyJson)
 	q ListStream
}

/// Descript:根据条码获取转移单中的单个药品明细数据
ClassMethod jsQueryTranferByBarCode(Ininit As %String, barcode As %String) As %String
{
	n (Ininit, barcode)
	s inbpid=$o(^DHCINBP(0,"BarCode",barcode,""))
	q:inbpid="" "{ErrCode:-1,rows:[]}"
	s initi=$p(^DHCINBP(inbpid),"^",9) //转移ID
	s init=+initi
	s ch=$p(initi,"||",2)
	q:init'=Ininit "{ErrCode:-2,rows:[]}"
	q:'$d(^DHCINIT(init,"ITI",ch)) "{ErrCode:-2,rows:[]}"
	s status=$p(^DHCINIT(init,"ITI",ch),"^",23)
	q:status>"21" "{ErrCode:-3,rows:[]}"
	q:status<"21" "{ErrCode:-4,rows:[]}"
	s trqty=$p(^DHCINIT(init,"ITI",ch),"^",1)
	s inclb=$p(^DHCINIT(init,"ITI",ch),"^",3)
	q:inclb="" "{ErrCode:-5,rows:[]}"
	s incib=$p(^INCI(+inclb,"IL",$p(inclb,"||",2),"LB",$p(inclb,"||",3)),"^",1) 
	q:incib="" "{ErrCode:-6,rows:[]}"
	s inci=+inclb
	s incicode=$p(^INCI(inci,1),"^",1)
	s incidesc=$p(^INCI(inci,1),"^",2)
	s trbatno=$p(^INCI(inci,"IB",$p(incib,"||",2)),"^",1)   //批号
	s trexpdate=$p(^INCI(inci,"IB",$p(incib,"||",2)),"^",2) //效期
	s:trexpdate'="" trexpdate=$zd(trexpdate,3)
	s inci=+inclb
	s incicode=$p(^INCI(inci,1),"^",1)
	s incidesc=$p(^INCI(inci,1),"^",2)
	s truom=$p(^DHCINIT(init,"ITI",ch),"^",7)
	q:truom="" "{ErrCode:-7,rows:[]}"
	s truomdesc=$p(^CT("UOM",truom),"^",2)
	s returnstring= "{ErrCode:0,rows:["
	s ListTitle="trIniti^trInciCode^trInciDesc^trQty^trUom^trBatNo^trExpDate"
	s ListData=initi_"^"_incicode_"^"_incidesc_"^"_trqty_"^"_truomdesc_"^"_trbatno_"^"_trexpdate
	s returnstring=returnstring_ ##class(web.DHCSTPHCMCOMMON).getJsonData(ListTitle,ListData)
	s returnstring=returnstring_"]}"
 	q returnstring
}

/// Descript:库存转移接收
ClassMethod TransInAuditPart(initi As %String, UserId As %String) As %String
{
	n (initi,UserId)
	s inti=+initi
	s qutiflag=0
	s ret=##class(web.DHCST.DHCINIsTrf).TransInAuditYesPart(inti,UserId,initi)
	q:ret'=0 "{ErrCode:"_ret_",rows:[]}"
	s ret=..ModInTransPackLocID(initi)
	q:ret'=0 "{ErrCode:"_ret_",rows:[]}"
	q "{ErrCode:0,rows:[]}"
}

/// Descript:修改批次条码表科室ID
ClassMethod ModInTransPackLocID(initi As %String) As %String
{
	n (initi)
	s inbpid=$o(^DHCINBP(0,"INTI",initi,""))
	q:inbpid="" ""
	s LocID=$p(^DHCINIT(+initi),"^",6)
	&sql(update DHC_IncBatPack set INBP_Loc_Dr=:LocID where INBP_RowID=:inbpid)
	q SQLCODE
}

}
