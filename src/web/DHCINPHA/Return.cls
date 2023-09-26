Import sqluser

/// creator:yunhaibao
/// createdate:20160516
/// descirpiton:住院药房申请单退药
Class web.DHCINPHA.Return Extends %RegisteredObject [ ProcedureBlock ]
{

ClassMethod NewPid()
{
	q $i(^DHCSTPHARMACY("web.DHCINPHA.Disp"))
}

/// creator:yunhaibao
/// createdate:20160506
/// descirpiton:获取住院药房申请单退药的退药申请列表
/// w ##class(web.DHCINPHA.Return).jsQueryReqListForReturn("1","50","2021-06-28^2021-07-13^224^^^^P^","jqGrid")
ClassMethod jsQueryReqListForReturn(page, rows, params, style = "")
{
	q:params="" ##class(web.DHCSTJQUERYCOMMON).getJsonEmptySign(0) 
	s endpage=page*rows  //结束行
	s stpage=((page-1)*rows)+1 //开始行
	s startdate=$p(params,"^",1)
	s startdate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(startdate)
	s enddate=$p(params,"^",2)
	s enddate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(enddate)
	s phaloc=$p(params,"^",3)
	q:phaloc="" ##class(web.DHCSTJQUERYCOMMON).getJsonEmptySign(0) 
	s wardloc=$p(params,"^",4)
	s patno=$p(params,"^",5)
	s docflag=$p(params,"^",6)
	i docflag="1" s docflag="on"
	e  s docflag=""
	s reqstatus=$p(params,"^",7)
	s advrefundflag=$p(params,"^",8)
	s refuseFlag=$p(params,"^",9)
	s otherStr = $p(params, "^", 10)
	s newpid=..NewPid() 	
    s $zt="ErrorjsQueryReqListForReturn"
    s result=##class(%Library.ResultSet).%New("web.DHCSTPHARETURN2:GetRetReqsToRet")
	s sc=result.Execute(phaloc,wardloc,startdate,enddate,reqstatus,patno,docflag,advrefundflag,refuseFlag,otherStr)
	i $$$ISERR(sc) q ##class(web.DHCSTJQUERYCOMMON).getJsonEmptySign(0) 
	s colNum=result.GetColumnCount()
	s colNameStr=""
	f i=1:1:colNum d
	.s colName=result.GetColumnName(i)
	.i colNameStr="" s colNameStr=colName
	.e  s colNameStr=colNameStr_"^"_colName
	s countrecords=0
	While(result.Next())
	{ 
		s retdata=""
		f i=1:1:colNum d
		.s ret=result.%GetData(i)
		.i retdata="" d
		..s retdata=ret
		.e  d
		..s retdata=retdata_"^"_ret
		s countrecords=countrecords+1  //可做索引用
		s reqDate=result.%GetData(2)
		s ward=result.%GetData(3)
		s bedNo=result.%GetData(5)
		s patNo=result.%GetData(6)
		s index=ward_"^"_bedNo_"^"_patNo_"^"_reqDate_"^"_countrecords
		s ^TMP("DHCST","web.DHCINPHA.Return","jsQueryReqListForReturn",newpid,index)=retdata
	}
	q:countrecords="0" ##class(web.DHCSTJQUERYCOMMON).getJsonEmptySign(0)
	i endpage>countrecords s endpage=countrecords
	s count=0
	s outputi=""
	f  s outputi=$o(^TMP("DHCST","web.DHCINPHA.Return","jsQueryReqListForReturn",newpid,outputi)) q:outputi=""  d
	.s outputdata=^TMP("DHCST","web.DHCINPHA.Return","jsQueryReqListForReturn",newpid,outputi)
	.s count=count+1
	.q:count<stpage
    .q:count>endpage
	.I count=stpage d
	..i style="jqGrid" w ##class(web.DHCSTJQUERYCOMMON).getJsonStartStringJqGrid(countrecords,rows)
	..e  w ##class(web.DHCSTJQUERYCOMMON).GetJsonStartString(countrecords)
	..W ##class(web.DHCSTJQUERYCOMMON).getJsonData(colNameStr,outputdata,"^")
	.e  d
	..W ","_##class(web.DHCSTJQUERYCOMMON).getJsonData(colNameStr,outputdata,"^")
	.i count=endpage w ##class(web.DHCSTJQUERYCOMMON).getJsonEndSign()
	k ^TMP("DHCST","web.DHCINPHA.Return","jsQueryReqListForReturn",newpid)
	q ""
ErrorjsQueryReqListForReturn
	k ^TMP("DHCST","web.DHCINPHA.Return","jsQueryReqListForReturn",newpid)
	s Error=$$Error^DHCSTERROR()
	q Error
}

/// creator:yunhaibao
/// createdate:20160506
/// descirpiton:获取住院药房申请单退药的退药申请列表
/// w ##class(web.DHCINPHA.Return).jsQueryReqDetail(1,300,"DHSZHYYZYRETREQ20210628001|@|Refuse")
ClassMethod jsQueryReqDetail(page, rows, params)
{
	q:params="" ##class(web.DHCSTJQUERYCOMMON).getJsonEmptySign(0) 
	s endpage=page*rows  //结束行
	s stpage=((page-1)*rows)+1 //开始行
	s newpid=..NewPid() 	
    s $zt="ErrorjsQueryReqDetail"
    s pReqNoStr = $p(params, "|@|", 1)
    s pStatus = $p(params, "|@|", 2)
    s result=##class(%Library.ResultSet).%New("web.DHCSTPHARETURN2:RetReqDetailToRet")
	s sc=result.Execute(pReqNoStr,pStatus)
	i $$$ISERR(sc) q ##class(web.DHCSTJQUERYCOMMON).getJsonEmptySign(0) 
	s colNum=result.GetColumnCount()
	s TSurQtyCol=""
	s colNameStr=""
	f i=1:1:colNum d
	.s colName=result.GetColumnName(i)
	.i colNameStr="" s colNameStr=colName
	.e  s colNameStr=colNameStr_"^"_colName
	.i colName="TSurqty" s TSurQtyCol=i
	s colNameStr=colNameStr_"^"_"TRetQty"_"^"_"TSelect"
	s countrecords=0
	While(result.Next())
	{ 
		s retdata=""
		f i=1:1:colNum d
		.s ret=result.%GetData(i)
		.i retdata="" d
		..s retdata=ret
		.e  d
		..s retdata=retdata_"^"_ret
		s retdata=retdata_"^"_result.%GetData(TSurQtyCol)_"^"_"Y"
		s countrecords=countrecords+1  //可做索引用
		s ^TMP("DHCST","web.DHCINPHA.Return","jsQueryReqDetail",newpid,countrecords)=retdata
	}
	q:countrecords="0" ##class(web.DHCSTJQUERYCOMMON).getJsonEmptySign(0)
	i endpage>countrecords s endpage=countrecords
	s count=0
	s outputi=""
	f  s outputi=$o(^TMP("DHCST","web.DHCINPHA.Return","jsQueryReqDetail",newpid,outputi)) q:outputi=""  d
	.s outputdata=^TMP("DHCST","web.DHCINPHA.Return","jsQueryReqDetail",newpid,outputi)
	.s count=count+1
	.q:count<stpage
    .q:count>endpage
	.I count=stpage d
	..w ##class(web.DHCSTJQUERYCOMMON).GetJsonStartString(countrecords)
	..W ##class(web.DHCSTJQUERYCOMMON).getJsonData(colNameStr,outputdata,"^")
	.e  d
	..W ","_##class(web.DHCSTJQUERYCOMMON).getJsonData(colNameStr,outputdata,"^")
	.i count=endpage w ##class(web.DHCSTJQUERYCOMMON).getJsonEndSign()
	k ^TMP("DHCST","web.DHCINPHA.Return","jsQueryReqDetail",newpid)
	q ""
ErrorjsQueryReqDetail
	k ^TMP("DHCST","web.DHCINPHA.Return","jsQueryReqDetail",newpid)
	s Error=$$Error^DHCSTERROR()
	q Error
}

/// creator:yunhaibao
/// createdate:20160506
/// descirpiton:获取住院药房申请单退药的退药申请列表
/// w ##class(web.DHCINPHA.Return).jsQueryReqTotal(1,300,"3175254")
ClassMethod jsQueryReqTotal(page, rows, params)
{
	q:params="" ##class(web.DHCSTJQUERYCOMMON).getJsonEmptySign(0) 
	s endpage=page*rows  //结束行
	s stpage=((page-1)*rows)+1 //开始行
	s newpid=..NewPid() 	
    s $zt="ErrorjsQueryReqTotal"
    s result=##class(%Library.ResultSet).%New("web.DHCSTPHARETURN2:GetRetReqTotalByNo")
	s sc=result.Execute(params)
	i $$$ISERR(sc) q ##class(web.DHCSTJQUERYCOMMON).getJsonEmptySign(0) 
	s colNum=result.GetColumnCount()
	s colNameStr=""
	f i=1:1:colNum d
	.s colName=result.GetColumnName(i)
	.i colNameStr="" s colNameStr=colName
	.e  s colNameStr=colNameStr_"^"_colName
	s countrecords=0
	While(result.Next())
	{ 
		s retdata=""
		f i=1:1:colNum d
		.s ret=result.%GetData(i)
		.i retdata="" d
		..s retdata=ret
		.e  d
		..s retdata=retdata_"^"_ret
		s countrecords=countrecords+1  //可做索引用
		s ^TMP("DHCST","web.DHCINPHA.Return","jsQueryReqTotal",newpid,countrecords)=retdata
	}
	q:countrecords="0" ##class(web.DHCSTJQUERYCOMMON).getJsonEmptySign(0)
	i endpage>countrecords s endpage=countrecords
	s count=0
	s outputi=""
	f  s outputi=$o(^TMP("DHCST","web.DHCINPHA.Return","jsQueryReqTotal",newpid,outputi)) q:outputi=""  d
	.s outputdata=^TMP("DHCST","web.DHCINPHA.Return","jsQueryReqTotal",newpid,outputi)
	.s count=count+1
	.q:count<stpage
    .q:count>endpage
	.I count=stpage d
	..w ##class(web.DHCSTJQUERYCOMMON).GetJsonStartString(countrecords)
	..W ##class(web.DHCSTJQUERYCOMMON).getJsonData(colNameStr,outputdata,"^")
	.e  d
	..W ","_##class(web.DHCSTJQUERYCOMMON).getJsonData(colNameStr,outputdata,"^")
	.i count=endpage w ##class(web.DHCSTJQUERYCOMMON).getJsonEndSign()
	k ^TMP("DHCST","web.DHCINPHA.Return","jsQueryReqTotal",newpid)
	q ""
ErrorjsQueryReqTotal
	k ^TMP("DHCST","web.DHCINPHA.Return","jsQueryReqTotal",newpid)
	s Error=$$Error^DHCSTERROR()
	q Error
}

/// creator:yunhaibao
/// createdate:20160506
/// descirpiton:获取住院药房申请单退药的退药申请列表
/// w ##class(web.DHCINPHA.Return).jsQueryNeedReturn("1","50","2018-10-01^2018-10-25^0000000056^316","jqGrid")
ClassMethod jsQueryNeedReturn(page, rows, params, style = "")
{
	//s ^hlh($h)=$lb(page, rows, params, style)
	s page=1,rows=999
	q:params="" ##class(web.DHCSTJQUERYCOMMON).getJsonEmptySign(0) 
	s endpage=page*rows  //结束行
	s stpage=((page-1)*rows)+1 //开始行
	s startdate=$p(params,"^",1)
	s startdate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(startdate)
	s enddate=$p(params,"^",2)
	s enddate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(enddate)
	s patNo=$p(params,"^",3)
	s phaLoc=$p(params,"^",4)
	q:(patNo="")||(phaLoc="") ##class(web.DHCSTJQUERYCOMMON).getJsonEmptySign(0) 
	s newpid=..NewPid() 	
    s $zt="ErrorjsQueryNeedReturn"
    s result=##class(%Library.ResultSet).%New("web.DHCSTPHARETURN:GetDispQuery")
	s sc=result.Execute(startdate,enddate,patNo,phaLoc)
	i $$$ISERR(sc) q ##class(web.DHCSTJQUERYCOMMON).getJsonEmptySign(0) 
	s colNum=result.GetColumnCount()
	s colNameStr=""
	f i=1:1:colNum d
	.s colName=result.GetColumnName(i)
	.i colNameStr="" s colNameStr=colName
	.e  s colNameStr=colNameStr_"^"_colName
	s countrecords=0
	While(result.Next())
	{ 
		s retdata=""
		f i=1:1:colNum d
		.s ret=result.%GetData(i)
		.i retdata="" d
		..s retdata=ret
		.e  d
		..s retdata=retdata_"^"_ret
		s countrecords=countrecords+1  //可做索引用
		s ^TMP("DHCST","web.DHCINPHA.Return","jsQueryNeedReturn",newpid,countrecords)=retdata
	}
	q:countrecords="0" ##class(web.DHCSTJQUERYCOMMON).getJsonEmptySign(0)
	i endpage>countrecords s endpage=countrecords
	s count=0
	s outputi=""
	f  s outputi=$o(^TMP("DHCST","web.DHCINPHA.Return","jsQueryNeedReturn",newpid,outputi)) q:outputi=""  d
	.s outputdata=^TMP("DHCST","web.DHCINPHA.Return","jsQueryNeedReturn",newpid,outputi)
	.s count=count+1
	.q:count<stpage
    .q:count>endpage
	.I count=stpage d
	..w ##class(web.DHCSTJQUERYCOMMON).GetJsonStartString(countrecords)
	..W ##class(web.DHCSTJQUERYCOMMON).getJsonData(colNameStr,outputdata,"^")
	.e  d
	..W ","_##class(web.DHCSTJQUERYCOMMON).getJsonData(colNameStr,outputdata,"^")
	.i count=endpage w ##class(web.DHCSTJQUERYCOMMON).getJsonEndSign()
	k ^TMP("DHCST","web.DHCINPHA.Return","jsQueryNeedReturn",newpid)
	q ""
ErrorjsQueryNeedReturn
	k ^TMP("DHCST","web.DHCINPHA.Return","jsQueryNeedReturn",newpid)
	s Error=$$Error^DHCSTERROR()
	q Error
}

}
