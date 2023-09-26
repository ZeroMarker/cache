/// Description:请领单查询相关
/// Creator:    hulihua
/// CreateDate: 2018-09-11
/// Table:      DHC_InPhReq、DHC_InPhReqItm、DHC_PHDraw、DHC_PHDrawInc、DHC_PHDrawOrder
Class web.DHCINPHA.MTInPhReq.InPhReqQuery Extends (%RegisteredObject, websys.Abstract) [ ClassType = "" ]
{

/// Description:查询一段时间内的请领单主信息
/// Creator:	hulihua
/// CreateDate:	2018-09-11
/// Table:      DHC_InPhReq、DHC_InPhReqItm
/// Input:		页数、行数、检索条件
/// Output:		
/// Return：
/// Others:    
/// Debug:		w ##class(web.DHCINPHA.MTInPhReq.InPhReqQuery).jsQuaryInphreqInfo("0","30","2018-08-13^2018-09-11^102^^^10^^^")
ClassMethod jsQuaryInphreqInfo(page, rows, params) As %String
{
	//s ^hlh($h)=$lb(page, rows, params)
	q:params="" ##class(web.DHCINPHA.MTCommon.JQueryCommon).GetNoJson()
	i $g(page)="" s page=1
	i $g(rows)="" s rows=50
	s End = page*rows
	s Start=(page-1)*rows+1
	s startDate=$p(params,"^",1)
	s stdate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(startDate)
	s endDate=$p(params,"^",2)
	s endate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(endDate)
	s phaLocDr=$p(params,"^",3)
	s wardID=$p(params,"^",4)
	s inphreqtype=$p(params,"^",5)
	s inphreqstatue=$p(params,"^",6)
	s drawNoStr=$p(params,"^",7)
	s phaNoStr=$p(params,"^",8)
	s inphrequser=$p(params,"^",9)
	s boxStatusFlag=$p(params,"^",10)
	s inphreqno=$p(params,"^",11)
	s inputinci=$p(params,"^",12)
	s patno=$p(params,"^",13)
	S pid=##class(web.DHCINPHA.MTCommon.CommonUtil).NewPid($this)
	d ##class(web.DHCINPHA.MTCommon.CommonUtil).ClearTmp($this,"jsQuaryInphreqInfo",pid,"INPHREQ")
	s n = 0
	f date=stdate:1:endate d
	.s PHRStatus=""
	.f  s PHRStatus=$o(^DHCINPHREQi("DispLocDate",phaLocDr,date,PHRStatus))  q:PHRStatus=""  d
	..s PHRWardLocDr="" 
	..f  s PHRWardLocDr=$o(^DHCINPHREQi("DispLocDate",phaLocDr,date,PHRStatus,PHRWardLocDr))  q:PHRWardLocDr=""  d
	...s PHRRowID=""
	...f  s PHRRowID=$o(^DHCINPHREQi("DispLocDate",phaLocDr,date,PHRStatus,PHRWardLocDr,PHRRowID))  q:PHRRowID=""  d
	....q:'$d(^DHCINPHREQ(PHRRowID))
	....s checkflag=1
	....s:(inputinci'="")||(patno'="") checkflag=..CheckPatNoAndInci(PHRRowID,patno,inputinci)
	....q:checkflag'=1
	....s phrNo=$p(^DHCINPHREQ(PHRRowID),"^",1)
	....q:(inphreqno'="")&&(phrNo'[inphreqno)
	....s wardLocDr=$p(^DHCINPHREQ(PHRRowID),"^",2)
	....q:(wardID'="")&&(wardID'=wardLocDr)
	....s wardLocDesc=$p(##class(web.DHCINPHA.MTCommon.PublicCallMethod).GetLocInfoById(wardLocDr),"^",2)
	....s dispLocDr=$p(^DHCINPHREQ(PHRRowID),"^",3)
	....s dispLocDesc=$p(##class(web.DHCINPHA.MTCommon.PublicCallMethod).GetLocInfoById(dispLocDr),"^",2)
	....s reqUserDr=$p(^DHCINPHREQ(PHRRowID),"^",4)		
	....q:(inphrequser'="")&&(inphrequser'=reqUserDr)
	....s reqUserDesc=$p(##class(web.DHCINPHA.MTCommon.PublicCallMethod).GetUserInfoById(reqUserDr),"^",2)
	....s reqDate=$p(^DHCINPHREQ(PHRRowID),"^",5)
	....s reqDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(reqDate)
	....s reqTime=$p(^DHCINPHREQ(PHRRowID),"^",6)
	....s reqTime=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(reqTime)
	....s reqDateTime=reqDate_" "_reqTime
	....s reqType=$p(^DHCINPHREQ(PHRRowID),"^",7)
	....q:(inphreqtype'="")&&(reqType'=inphreqtype)
	....s reqTypeDesc=$s(reqType="1":"送药",reqType="2":"取药",reqType="3":"毒性",reqType="4":"麻醉",reqType="5":"精一",reqType="6":"精二",1:"")
	....s phrStatus=$p(^DHCINPHREQ(PHRRowID),"^",8)
	....q:(inphreqstatue'="")&&(inphreqstatue'=phrStatus)
	....s phrStatusDesc=$select(phrStatus="":"",phrStatus="05":"撤销申请",phrStatus="10":"病区申请",phrStatus="20":"药房备药中",phrStatus="30":"药房备药完成",phrStatus="40":"药房核对中",phrStatus="50":"核对装箱完成",phrStatus="60":"物流交接完成",phrStatus="70":"病区接收",phrStatus="80":"病区核对")
	....s drawDr=$p(^DHCINPHREQ(PHRRowID),"^",9)
	....s drawNo=$s(drawDr'="":$p(^DHCPHDRAW(drawDr),"^",1),1:"")				//备药单号
	....q:(drawNoStr'="")&&(drawNo'[drawNoStr)
	....s boxdr=$s(drawDr'="":$p(^DHCPHDRAW(drawDr),"^",15),1:"")
	....s boxstatus=$s(boxdr'="":$p(^DHCPHBOX(boxdr),"^",13),1:"")
	....q:(boxStatusFlag'="")&&(boxStatusFlag'=boxstatus)
	....s BoxStatusDesc=$s(boxstatus="10":"封箱完成打印装箱贴",boxstatus="60":"物流交接完成",boxstatus="70":"病区接收",1:"")
	....s cancelUserDr=$p(^DHCINPHREQ(PHRRowID),"^",10)
	....s cancelUserDesc=$p(##class(web.DHCINPHA.MTCommon.PublicCallMethod).GetUserInfoById(cancelUserDr),"^",2)	
	....s cancelDate=$p(^DHCINPHREQ(PHRRowID),"^",11)
	....s cancelDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(cancelDate)
	....s cancelTime=$p(^DHCINPHREQ(PHRRowID),"^",12)
	....s cancelTime=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(cancelTime)
	....s cancelDateTime=cancelDate_" "_cancelTime
	....s connectNo=$p(^DHCINPHREQ(PHRRowID),"^",13)
	....q:(phaNoStr'="")&&(connectNo'[phaNoStr)
	....s AlertDrawDate=$p(^DHCINPHREQ(PHRRowID),"^",15)
	....s AlertDrawDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(AlertDrawDate)
	....s AlertDrawTime=$p(^DHCINPHREQ(PHRRowID),"^",16)
	....s AlertDrawTime=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(AlertDrawTime)
	....s AlertDrawDateTime=AlertDrawDate_" "_AlertDrawTime
	....s AlertDarwUserDr=$p(^DHCINPHREQ(PHRRowID),"^",17)
	....s AlertDarwUserDesc=$p(##class(web.DHCINPHA.MTCommon.PublicCallMethod).GetUserInfoById(AlertDarwUserDr),"^",2)		
    ....s mdata1=phrNo_"^"_wardLocDesc_"^"_dispLocDesc_"^"_reqUserDesc_"^"_reqDateTime
    ....s mdata2=reqTypeDesc_"^"_phrStatusDesc_"^"_$g(drawNo)_"^"_$g(cancelUserDesc)_"^"_cancelDateTime
    ....s mdata3=connectNo_"^"_PHRRowID_"^"_$g(AlertDrawDateTime)_"^"_$g(AlertDarwUserDesc)_"^"_$g(BoxStatusDesc)
    ....s n=n+1
    ....s Index=PHRRowID
    ....s ^TMP("DHCINPHA",$this,"jsQuaryInphreqInfo",pid,"INPHREQ",Index)=mdata1_"^"_mdata2_"^"_mdata3
    ...
    ..
    .
 	q:n=0 ##class(web.DHCINPHA.MTCommon.JQueryCommon).getJsonEmptySign(n) //输出空的json串
 	i End>n s End=n
	w ##class(web.DHCINPHA.MTCommon.JQueryCommon).getJsonStartStringJqGrid(n,rows) //输出json前缀串
	s Title1="TInphrNo^TWardLocDesc^TDispLocDesc^TReqUserDesc^TReqDateTime"
	s Title2="TReqTypeDesc^TPhrStatusDesc^TPhDrawNo^TCancelUserDesc^TCancelDateTime"
	s Title3="TConnectNo^TPHRRowID^TAlertDrawDateTime^TAlertDarwUserDesc^TBoxStatus"
	s Title=Title1_"^"_Title2_"^"_Title3
	s count=0
	s index=""
	f  s index=$o(^TMP("DHCINPHA",$this,"jsQuaryInphreqInfo",pid,"INPHREQ",index)) q:index=""  d
	.s mdata=^TMP("DHCINPHA",$this,"jsQuaryInphreqInfo",pid,"INPHREQ",index)
	.s count = count+1
	.q:(count<Start)||(count>End)
	.I count=Start d
	..w ##class(web.DHCINPHA.MTCommon.JQueryCommon).getJsonData(Title,mdata)
	.e  d
	..w ","_##class(web.DHCINPHA.MTCommon.JQueryCommon).getJsonData(Title,mdata)
	.
	w ##class(web.DHCINPHA.MTCommon.JQueryCommon).getJsonEndSign() //输出json结尾符
	d ##class(web.DHCINPHA.MTCommon.CommonUtil).ClearTmp($this,"jsQuaryInphreqInfo",pid,"INPHREQ")
	q ""
}

/// Description:查询选中的请领单信息
/// Creator:	hulihua
/// CreateDate:	2018-09-11
/// Table:      DHC_InPhReqItm
/// Input:		页数、行数、检索条件
/// Output:		
/// Return：
/// Others:    
/// Debug:		w ##class(web.DHCINPHA.MTInPhReq.InPhReqQuery).jsQuaryInphreqItmInfo("0","30","5078")
ClassMethod jsQuaryInphreqItmInfo(page, rows, params) As %String
{
	//s ^hlh($h)=$lb(page, rows, params)
	q:params="" ##class(web.DHCINPHA.MTCommon.JQueryCommon).GetNoJson()
	s inphreqID=$p(params,"^",1)
	i $g(page)="" s page=1
	i $g(rows)="" s rows=50
	s End = page*rows
	s Start=(page-1)*rows+1
	s Title="TItmstatusDesc^TCancelUserDesc^TCancelDateTime^TInciCode^TInciDesc^TQty^TUomDesc^TDspBatchId^TInphreqSubID"
	s count = 0
	s PHRIChildSub="0"
	f  s PHRIChildSub=$o(^DHCINPHREQ(inphreqID,"I",PHRIChildSub))  q:PHRIChildSub=""  d
	.s dspId=$p(^DHCINPHREQ(inphreqID,"I",PHRIChildSub),"^",1)
	.s Itmstatus=$p(^DHCINPHREQ(inphreqID,"I",PHRIChildSub),"^",2)
	.s ItmstatusDesc=$select(Itmstatus="":"",Itmstatus="05":"撤销申请",Itmstatus="10":"病区申请",Itmstatus="30":"药房备药完成",Itmstatus="50":"核对装箱完成",Itmstatus="60":"物流交接完成",Itmstatus="70":"病区接收",Itmstatus="80":"病区核对")
	.s cancelUserDr=$p(^DHCINPHREQ(inphreqID,"I",PHRIChildSub),"^",3)
	.s cancelUserDesc=$p(##class(web.DHCINPHA.MTCommon.PublicCallMethod).GetUserInfoById(cancelUserDr),"^",2)	
	.s cancelDate=$p(^DHCINPHREQ(inphreqID,"I",PHRIChildSub),"^",4)
	.s cancelDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(cancelDate)
	.s cancelTime=$p(^DHCINPHREQ(inphreqID,"I",PHRIChildSub),"^",5)
	.s cancelTime=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(cancelTime)
	.s cancelDateTime=cancelDate_" "_cancelTime
	.s dspSubId=0
 	.f  s dspSubId=$o(^DHCOEDISQTY(dspId,"I",dspSubId)) q:dspSubId=""  d
 	..s dspbatch=dspId_"||"_dspSubId
 	..s inci=$p(^DHCOEDISQTY(dspId,"I",dspSubId),"^",5)
 	..s inclb=$p(^DHCOEDISQTY(dspId,"I",dspSubId),"^",1)
 	..s inci=$S(inci="":+inclb,1:inci)
 	..s dspQty=$p(^DHCOEDISQTY(dspId,"I",dspSubId),"^",2)
 	..s inciCode=$p(^INCI(inci,1),"^",1)										//药品代码
	..s inciDesc=$p(^INCI(inci,1),"^",2)										//药品描述
	..s uomDr=$p(^INCI(inci,1),"^",10)
	..s uomDesc=$p(^CT("UOM",uomDr),"^","2")	
	..s inphreqSubID=inphreqID_"||"_PHRIChildSub			
    ..s mdata=$g(ItmstatusDesc)_"^"_$g(cancelUserDesc)_"^"_cancelDateTime_"^"_inciCode_"^"_inciDesc_"^"_dspQty_"^"_uomDesc_"^"_dspbatch_"^"_inphreqSubID
	..s count = count+1
	..q:(count<Start)||(count>End)
	..I count=Start d
	...w ##class(web.DHCSTJQUERYCOMMON).GetJsonStartString(count)
	...w ##class(web.DHCINPHA.MTCommon.JQueryCommon).getJsonData(Title,mdata)
	..e  d
	...w ","_##class(web.DHCINPHA.MTCommon.JQueryCommon).getJsonData(Title,mdata)
	..
	.
	w ##class(web.DHCINPHA.MTCommon.JQueryCommon).getJsonEndSign() //输出json结尾符
	q ""
}

/// Description:检查该请领单是否包含某患者或者某药品
/// Creator:	hulihua
/// CreateDate:	2018-09-12
/// Table:      DHC_OEDispensing-新医嘱打包表、DHC_OEDispBatch-打包子表
/// Input:		inphreqID-请领ID, PatNo-登记号, InputInci-输入药品ID
/// Output:		0-不存在，1-存在
/// Return：
/// Others:    
/// Debug:		w ##class(web.DHCINPHA.MTInPhReq.InPhReqQuery).CheckPatNoAndInci("")
ClassMethod CheckPatNoAndInci(inphreqID, PatNo = "", InputInci = "") As %String
{
	s checkflag=0
	s PHRIChildSub="0"
	f  s PHRIChildSub=$o(^DHCINPHREQ(inphreqID,"I",PHRIChildSub))  q:(PHRIChildSub="")||(checkflag'=0)  d
	.s dspId=$p(^DHCINPHREQ(inphreqID,"I",PHRIChildSub),"^",1)
	.i PatNo'="" d
	..s ord=+$p(^DHCOEDISQTY(dspId),"^",1)
	..s adm=$p(^OEORD(ord),"^",1)
	..q:adm=""
	..s papmidr=$p($g(^PAADM(adm)),"^",1)
	..q:papmidr=""
	..s papmino=$p(^PAPER(papmidr,"PAT",1),"^",2)
	..s:(PatNo'="")&&(papmino=PatNo) checkflag=1
	.q:checkflag'=0
	.s dspSubId=0
 	.f  s dspSubId=$o(^DHCOEDISQTY(dspId,"I",dspSubId)) q:(dspSubId="")||(checkflag'=0)  d
 	..s dspbatch=dspId_"||"_dspSubId
 	..s inci=$p(^DHCOEDISQTY(dspId,"I",dspSubId),"^",5)
 	..s inclb=$p(^DHCOEDISQTY(dspId,"I",dspSubId),"^",1)
 	..s inci=$S(inci="":+inclb,1:inci)
 	..s:(InputInci'="")&&(InputInci=inci) checkflag=1
 	.
 	q checkflag
}

Storage Default
{
<Data name="InPhReqQueryDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCINPHAD502.InPhReqQueryD</DataLocation>
<DefaultData>InPhReqQueryDefaultData</DefaultData>
<IdLocation>^web.DHCINPHAD502.InPhReqQueryD</IdLocation>
<IndexLocation>^web.DHCINPHAD502.InPhReqQueryI</IndexLocation>
<StreamLocation>^web.DHCINPHAD502.InPhReqQueryS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
