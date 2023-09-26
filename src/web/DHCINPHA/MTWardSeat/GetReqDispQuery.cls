/// Description:获取病区请领单相关类
/// Creator:    hulihua
/// CreateDate: 2017-03-15
/// Table: 		DHC_InPhReq病区请领发药主表、DHC_InPhReqItm护士请领发药子表
Class web.DHCINPHA.MTWardSeat.GetReqDispQuery Extends (%RegisteredObject, websys.Abstract) [ ClassType = "", Not ProcedureBlock ]
{

/// Description:查询某病区各个类别的请领单张数
/// Creator:	hulihua
/// CreateDate:	2017-03-10
/// Table:      DHC_InPhReq-病区请领发药主表
/// Input:		phloc-接收科室ID、wardloc-病区科室ID、phrstatus-状态值、startdate-起始日期、enddtte-截至日期
/// Output:
/// Return：    送药请领单张数、取药请领单张数、毒麻请领单张数、精神请领单张数
/// Others:
/// w ##class(web.DHCINPHA.MTWardSeat.GetReqDispQuery).GetReqTypeNum("0","85","")
ClassMethod GetReqTypeNum(startdate As %String, enddate As %String, phloc As %String, wardloc As %String, phrstatus As %String) As %Library.String
{
	n (startdate, enddate, phloc, wardloc, phrstatus)
	s startdate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(startdate)
	s enddate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(enddate)
	s senddrugnum=0,takedrugnum=0,toxanesnum=0,psychodrugnum=0
	f date=startdate:1:enddate d
	.s phrid=""
	.f  s phrid=$o(^DHCINPHREQi("DispLocDate",phloc,date,phrstatus,wardloc,phrid))  q:phrid=""  d
	..s reqstatue=$p(^DHCINPHREQ(phrid),"^",8)
	..q:reqstatue<10
	..s reqtype=$p(^DHCINPHREQ(phrid),"^",7)
	..s:reqtype="1" senddrugnum=senddrugnum+1
	..s:reqtype="2" takedrugnum=takedrugnum+1
	..s:(reqtype="3")||(reqtype="4") toxanesnum=toxanesnum+1
	..s:(reqtype="5")||(reqtype="6") psychodrugnum=psychodrugnum+1
	.
	s strnum=senddrugnum_"^"_takedrugnum_"^"_toxanesnum_"^"_psychodrugnum
	q strnum
}

/// Description:按照病区和接收科室查询一段时间内的请领单单号
/// Creator:	hulihua
/// CreateDate:	2017-03-15
/// Table:      DHC_PHDraw
/// Input:		每页行数、页数、开始日期^结束日期^药房科室ID^病区科室ID^请领单类型
/// Output:		送药请领单ID、送药请领单、取药请领单ID、取药请领单、毒麻请领单ID、毒麻请领单、精神请领单ID、精神请领单
/// Return：    
/// w ##class(web.DHCINPHA.MTWardSeat.GetReqDispQuery).GetInPhReqNoList("50","1","19/02/2017^00:00^22/03/2017^23:59^94^114^4")
ClassMethod GetInPhReqNoList(rows, page, params) As %Library.String
{
	n (rows, page,params)
	//s ^hlh($h)=$lb(rows, page,params)
	q:params="" ##class(web.DHCINPHA.MTCommon.JQueryCommon).GetNoJson()
	i $g(page)="" s page=1
	i $g(rows)="" s rows=50
	s End = page*rows
	s Start=(page-1)*rows+1
	;
	s PhLoc=$p(params,"^",3)
	s PhaFlagStr=##class(web.DHCSTPHALOC).GetPhaflag(PhLoc)
	s StartDate=$p(params,"^",1)
	s:StartDate'="" StartDate=$zdh(StartDate,3)
	i StartDate="" d
	.s StartDate=$p(PhaFlagStr,"^",3)
	.s StartDate=##class(web.DHCSTKUTIL).GetDate("","",StartDate)
	.s StartDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(StartDate)
	s EndDate=$p(params,"^",2)
	s:EndDate'="" EndDate=$zdh(EndDate,3)
	i EndDate="" d
	.s EndDate=$p(PhaFlagStr,"^",4)
	.s EndDate=##class(web.DHCSTKUTIL).GetDate("","",EndDate)
	.s EndDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(EndDate)
	s WardLoc=$p(params,"^",4)
	s ReqType=$p(params,"^",5)
	S pid=##class(web.DHCINPHA.MTCommon.CommonUtil).NewPid("web.DHCINPHA.MTWardSeat.GetReqDispQuery")
	d ##class(web.DHCINPHA.MTCommon.CommonUtil).ClearTmp("web.DHCINPHA.MTWardSeat.GetReqDispQuery","GetInPhReqNoList",pid)
	s n=0
	f Date=StartDate:1:EndDate d
	.s phrid=""
	.f  s phrid=$o(^DHCINPHREQi("DispLocDate",PhLoc,Date,"10",WardLoc,phrid))  q:phrid=""  d
	..s reqstatue=$p(^DHCINPHREQ(phrid),"^",8)
	..q:reqstatue<10
	..s inphreqno=$p(^DHCINPHREQ(phrid),"^",1)
	..s inphreqtype=$p(^DHCINPHREQ(phrid),"^",7)
	..q:((ReqType=1)||(ReqType=2))&&(ReqType'=inphreqtype)
	..q:(ReqType=3)&&(inphreqtype'=3)&&(inphreqtype'=4)
	..q:(ReqType=4)&&(inphreqtype'=5)&&(inphreqtype'=6)
	..s inphreqtype=$s(inphreqtype=1:"送药",inphreqtype=2:"取药",inphreqtype=3:"毒性",inphreqtype=4:"麻醉",inphreqtype=5:"精一",inphreqtype=6:"精二")
	..s n=n+1
	..s data=$g(phrid)_"^"_$g(inphreqno)_"^"_$g(inphreqtype)
	..s ^TMP("DHCINPHA","web.DHCINPHA.MTWardSeat.GetReqDispQuery","GetInPhReqNoList",pid,n)=data
	q:n=0 ##class(web.DHCINPHA.MTCommon.JQueryCommon).getJsonEmptySign(n) //输出空的json串
	w ##class(web.DHCINPHA.MTCommon.JQueryCommon).getJsonStartSign(n) //输出json前缀串
	s maxrow=n
	s count=0
	s h=""
	f  s h=$o(^TMP("DHCINPHA","web.DHCINPHA.MTWardSeat.GetReqDispQuery","GetInPhReqNoList",pid,h)) q:h=""  d
	.s mdata=^TMP("DHCINPHA","web.DHCINPHA.MTWardSeat.GetReqDispQuery","GetInPhReqNoList",pid,h)
	.s count = count+1
	.s Title="TPhRid^TInphReqNo^TInphReqType"
	.q:(count<Start)||(count>End)
	.I count=Start d
	..w ##class(web.DHCINPHA.MTCommon.JQueryCommon).getJsonData(Title,mdata)
	.e  d
	..w ","_##class(web.DHCINPHA.MTCommon.JQueryCommon).getJsonData(Title,mdata)

	w ##class(web.DHCINPHA.MTCommon.JQueryCommon).getJsonEndSign() //输出json结尾符
	d ##class(web.DHCINPHA.MTCommon.CommonUtil).ClearTmp("web.DHCINPHA.MTWardSeat.GetReqDispQuery","GetInPhReqNoList",pid)
	q ""
}

/// Description:根据选择的请领单类型固化请领单
/// Creator:	hulihua
/// CreateDate:	2017-03-21
/// Table:      DHC_InPhReq-病区请领发药主表
/// Input:		
/// Output:
/// Return：    
/// Others:
/// w ##class(web.DHCINPHA.MTWardSeat.GetReqDispQuery).SaveInPhReqTmpConNo("9^11^12")
ClassMethod SaveInPhReqTmpConNo(params As %String) As %Library.String
{
	n (params)
	//s ^hlh($h)=$lb(params)
	q:params="" -1
	s len=$l(params,"#")
	s $ZT="Error^DHCSTERROR" 
  	s ret=0,InPhReqConNoStr=""
  	f i=1:1:len d
  	.s InPhReqIdStr=$p(params,"#",i)
  	.q:InPhReqIdStr=""
  	.s ret=##class(web.DHCINPHA.MTWardSeat.SqlDbInPhReq).UpdateInPhReqConNo(InPhReqIdStr)
  	.q:ret<0
  	.s InPhReqConNoStr=$s(InPhReqConNoStr="":ret,1:InPhReqConNoStr_"$$"_ret)
	q InPhReqConNoStr
}

/// Description:通过固化关联单号和病区科室ID获取标签的打印信息
/// Creator:	hulihua
/// CreateDate:	2017-03-21
/// Table:      DHC_InPhReq-病区请领发药主表
/// Input:		InPhReqConNo-固化关联单号, WardLoc-病区科室ID		
/// Output:
/// Return：	固化请领单类型、病区科室名称、固化日期、发药科室    
/// Others:
/// w ##class(web.DHCINPHA.MTWardSeat.GetReqDispQuery).GetPrintLabelInfo("ZXYFPHREQCON20170321012","94")
ClassMethod GetPrintLabelInfo(InPhReqConNo, DispLocId) As %Library.String
{
	n (InPhReqConNo, DispLocId)
	q:(InPhReqConNo="")!(DispLocId="") ""
	s phreqid=$o(^DHCINPHREQi(0,"DispLocConnectNo",DispLocId,InPhReqConNo,""),-1)  
	s phreqtype=$p(^DHCINPHREQ(phreqid),"^",7)
	s phreqtype=$s(phreqtype=1:"送药",1:"取药")
	s wardlocid=$p(^DHCINPHREQ(phreqid),"^",2)
	s wardloc=$s(wardlocid'="":$p(^CTLOC(wardlocid),"^",51),1:"")
	s:wardloc="" wardloc=$p(^CTLOC(wardlocid),"^",2)
	s phreqcondate=$zd(+$h,3)
	s disploc=$p(^CTLOC(DispLocId),"^",2)
	s data=$g(phreqtype)_"^"_$g(wardloc)_"^"_$g(phreqcondate)_"^"_$g(disploc)
	q data
}

/// Description:通过请领单ID获取该请领单的明细信息
/// Creator:	hulihua
/// CreateDate:	2018-02-28
/// Table:      DHC_InPhReq、DHC_InPhReqItm
/// Input:		每页行数、页数、请领单ID
/// Output:		病区ID、病区名称
/// Return：    
/// Others:
/// Debug:		w ##class(web.DHCINPHA.MTWardSeat.GetReqDispQuery).GetInPhReqItemById("1","500","100")
ClassMethod GetInPhReqItemById(page, rows, params) As %Library.String
{
	n (page, rows, params)
	//s ^hlh($h)=$lb(page, rows, params)
	q:params="" ##class(web.DHCINPHA.MTCommon.JQueryCommon).GetNoJson()
	i $g(page)="" s page=1
	i $g(rows)="" s rows=50
	s End = page*rows
	s Start=(page-1)*rows+1
	s InphReqId=params
	q:InphReqId="" ##class(web.DHCINPHA.MTCommon.JQueryCommon).GetNoJson()
	s InPhReqCh=0,count=0
	f  s InPhReqCh=$o(^DHCINPHREQ(InphReqId,"I",InPhReqCh)) q:InPhReqCh=""  d
	.q:'$d(^DHCINPHREQ(InphReqId,"I",InPhReqCh))
	.s DspId=$p(^DHCINPHREQ(InphReqId,"I",InPhReqCh),"^",1)
	.s Oeori=$p(^DHCOEDISQTY(DspId),"^",1) 
	.s Ord=+Oeori
	.s Chl=$p(Oeori,"||",2)
	.q:Ord=""
	.q:Chl=""
	.q:'$d(^OEORD(Ord))
	.q:'$d(^OEORD(Ord,"I",Chl))
	.s ArcimId=$p(^OEORD(Ord,"I",Chl,1),"^",2)                                   
 	.q:ArcimId=""
 	.s ArcimDesc=$p(^ARCIM($p(ArcimId,"||",1),$p(ArcimId,"||",2),1),"^",2)
 	.s Inci=$o(^INCI(0,"ARCIM_DR",$p(ArcimId,"||",1),"") ) 
 	.s BUomId=$p(^INCI(Inci,1),"^",10)
 	.s DspUom =$p(^CT("UOM",BUomId),"^",2)
 	.s admDr=$p(^DHCOEDISQTY(DspId),"^",26)
 	.q:admDr=""
 	.s patInfo=##class(web.DHCPHACOM.ComPubClass.OrderAndPatInfo).GetPatInfo(admDr)
 	.s PatNo=$p(patInfo,"^",1)
 	.s PatName=$p(patInfo,"^",3)
 	.s BedId=$p(^PAADM(admDr),"^",73)	
 	.s BedNo=$s(BedId'="":$p($g(^PAWARD($p(BedId,"||",1),"BED",$p(BedId,"||",2))),"^",1),1:"")
 	.s Prescno=$p(^OEORD(Ord,"I",Chl,1),"^",14)
 	.s TimeDosing=$p(^DHCOEDISQTY(DspId),"^",20)
 	.s TimeDosing=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(TimeDosing,"IP")
 	.s Date=$p(^DHCOEDISQTY(DspId),"^",21)
 	.s Date=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(Date,"IP")   
    .s:Date'="" Date=Date_" "_TimeDosing
    .s DspQty=$p(^DHCOEDISQTY(DspId),"^",11)   					      
	.s mdata1=ArcimDesc_"^"_DspQty_"^"_DspUom_"^"_Prescno_"^"_PatNo
	.s mdata2=PatName_"^"_BedNo_"^"_Date
	.s mdata=mdata1_"^"_mdata2
	.s count = count+1
	.s Title1="TArcimDesc^TDspQty^TDspUom^TPrescno^TPatNo"
	.s Title2="TPatName^TBedNo^TDspDate"
	.s Title=Title1_"^"_Title2
	.q:(count<Start)||(count>End)
	.I count=Start d
	..w ##class(web.DHCINPHA.MTCommon.JQueryCommon).getJsonRowSign()
	..w ##class(web.DHCINPHA.MTCommon.JQueryCommon).getJsonData(Title,mdata)
	.e  d
	..w ","_##class(web.DHCINPHA.MTCommon.JQueryCommon).getJsonData(Title,mdata)
	.
	i count>0 d
	.w ##class(web.DHCINPHA.MTCommon.JQueryCommon).getJsonEndStringJqGrid(count,rows)
	e  w ##class(web.DHCINPHA.MTCommon.JQueryCommon).getJsonEmptySign(0)
	q ""
}

Storage Default
{
<Data name="GetReqDispQueryDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCINPD931.GetReqDispQECC8D</DataLocation>
<DefaultData>GetReqDispQueryDefaultData</DefaultData>
<IdLocation>^web.DHCINPD931.GetReqDispQECC8D</IdLocation>
<IndexLocation>^web.DHCINPD931.GetReqDispQECC8I</IndexLocation>
<StreamLocation>^web.DHCINPD931.GetReqDispQECC8S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
