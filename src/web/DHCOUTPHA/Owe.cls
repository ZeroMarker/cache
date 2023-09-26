Import sqluser

/// creator:yunhaibao
/// createdate:20160527
/// descirpiton:门诊药房欠药单管理
Class web.DHCOUTPHA.Owe Extends %RegisteredObject [ ProcedureBlock ]
{

/// creator:yunhaibao
/// createdate:20160527
/// descirpiton:获取门诊药房欠药列表
/// w ##class(web.DHCOUTPHA.Owe).jsQueryOweList(1,30,"01/03/2017^06/03/2017^100^^^0^0^0^^^")
ClassMethod jsQueryOweList(page, rows, params, style = "")
{
	q:params="" ##class(web.DHCSTJQUERYCOMMON).getJsonEmptySign(0) 
	s endpage=page*rows  //结束行
	s stpage=((page-1)*rows)+1 //开始行
	s CDateSt=$p(params,"^",1)
	s CDateEnd=$p(params,"^",2)
	s CDateSt=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(CDateSt)
	s CDateEnd=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(CDateEnd)
	s ctloc=$p(params,"^",3)
	s GPhw=$p(params,"^",4)
	s CPmiNo=$p(params,"^",5)
	s CPrint=$p(params,"^",6)
	s CDisped=$p(params,"^",7)
	s CRetruened=$p(params,"^",8)
	s CPrescNo=$p(params,"^",9)
	s CPatName=$p(params,"^",10)
	s inci=$p(params,"^",11)
	s pid=..NewPid() 	
    s $zt="ErrorjsQueryOweList"
    s result=##class(%Library.ResultSet).%New("web.DHCOutPhOweList:QueryLocPatPY")
	s sc=result.Execute(CDateSt, CDateEnd, ctloc, GPhw, CPmiNo, CPrint, CDisped, CRetruened, CPrescNo, CPatName, inci)
	i $$$ISERR(sc) q ##class(web.DHCSTJQUERYCOMMON).getJsonEmptySign(0) 
	s colNum=result.GetColumnCount()
	s colNameStr=""
	f i=1:1:colNum d
	.i colNameStr="" s colNameStr=result.GetColumnName(i)
	.e  s colNameStr=colNameStr_"^"_result.GetColumnName(i)
	s countrecords=0
	While(result.Next())
	{ 
		s ret=""
		f i=1:1:colNum d
		.i ret="" s ret=result.%GetData(i)
		.e   s ret=ret_"^"_result.%GetData(i)
		s countrecords=countrecords+1  //可做索引用
		s ^TMP("DHCST","web.DHCOUTPHA.Owe","jsQueryOweList",pid,countrecords)=ret
	}
	q:countrecords="0" ##class(web.DHCSTJQUERYCOMMON).getJsonEmptySign(0)
	i endpage>countrecords s endpage=countrecords
	s count=0
	s outputi=""
	f  s outputi=$o(^TMP("DHCST","web.DHCOUTPHA.Owe","jsQueryOweList",pid,outputi)) q:outputi=""  d
	.s outputdata=^TMP("DHCST","web.DHCOUTPHA.Owe","jsQueryOweList",pid,outputi)
	.s count=count+1
	.q:count<stpage
    .q:count>endpage
	.I count=stpage d
	..i style="jqGrid" w ##class(web.DHCSTJQUERYCOMMON).getJsonStartStringJqGrid(countrecords,rows)
	..e  w ##class(web.DHCSTJQUERYCOMMON).GetJsonStartString(countrecords)
	..W ##class(web.DHCSTJQUERYCOMMON).getJsonData(colNameStr,outputdata)
	.e  d
	..W ","_##class(web.DHCSTJQUERYCOMMON).getJsonData(colNameStr,outputdata)
	.i count=endpage w ##class(web.DHCSTJQUERYCOMMON).getJsonEndSign()
	k ^TMP("DHCST","web.DHCOUTPHA.Owe","jsQueryOweList",pid)
	q ""
ErrorjsQueryOweList
	k ^TMP("DHCST","web.DHCOUTPHA.Owe","jsQueryOweList",pid)
	s Error=$$Error^DHCSTERROR()
	q Error
}

/// creator:yunhaibao
/// createdate:20160527
/// descirpiton:获取门诊药房欠药明细列表
/// w ##class(web.DHCOUTPHA.Owe).jsQueryOweListDetail(1,30,"518")
ClassMethod jsQueryOweListDetail(page, rows, params)
{
	//s ^yunhaibao("jsQueryOweListDetail")=page_","_rows_","_params
	q:params="" ##class(web.DHCSTJQUERYCOMMON).getJsonEmptySign(0) 
	s endpage=page*rows  //结束行
	s stpage=((page-1)*rows)+1 //开始行
	s pho=$p(params,"^",1)
	s ctloc=$p(^DHCPHOW(pho),"^",2)
	q:'$d(^DHCPHLOCi("LOC",ctloc)) ##class(web.DHCSTJQUERYCOMMON).getJsonEmptySign(0) 
	s GPhl=$o(^DHCPHLOCi("LOC",ctloc,""))
	s pid=..NewPid() 	
    s $zt="ErrorjsQueryOweListDetail"
    s result=##class(%Library.ResultSet).%New("web.DHCOutPhOweList:QueryLocOutPatItm")
	s sc=result.Execute(GPhl,pho)
	i $$$ISERR(sc) q ##class(web.DHCSTJQUERYCOMMON).getJsonEmptySign(0) 
	s colNum=result.GetColumnCount()
	s colNameStr=""
	f i=1:1:colNum d
	.i colNameStr="" s colNameStr=result.GetColumnName(i)
	.e  s colNameStr=colNameStr_"^"_result.GetColumnName(i)
	s countrecords=0
	While(result.Next())
	{ 
		s ret=""
		f i=1:1:colNum d
		.i ret="" s ret=result.%GetData(i)
		.e   s ret=ret_"^"_result.%GetData(i)
		s countrecords=countrecords+1  //可做索引用
		s ^TMP("DHCST","web.DHCOUTPHA.Owe","jsQueryOweListDetail",pid,countrecords)=ret
	}
	q:countrecords="0" ##class(web.DHCSTJQUERYCOMMON).getJsonEmptySign(0)
	i endpage>countrecords s endpage=countrecords
	s count=0
	s outputi=""
	f  s outputi=$o(^TMP("DHCST","web.DHCOUTPHA.Owe","jsQueryOweListDetail",pid,outputi)) q:outputi=""  d
	.s outputdata=^TMP("DHCST","web.DHCOUTPHA.Owe","jsQueryOweListDetail",pid,outputi)
	.s count=count+1
	.q:count<stpage
    .q:count>endpage
	.I count=stpage d
	..w ##class(web.DHCSTJQUERYCOMMON).GetJsonStartString(countrecords)
	..W ##class(web.DHCSTJQUERYCOMMON).getJsonData(colNameStr,outputdata)
	.e  d
	..W ","_##class(web.DHCSTJQUERYCOMMON).getJsonData(colNameStr,outputdata)
	.i count=endpage w ##class(web.DHCSTJQUERYCOMMON).getJsonEndSign()
	k ^TMP("DHCST","web.DHCOUTPHA.Owe","jsQueryOweListDetail",pid)
	q ""
ErrorjsQueryOweListDetail
	k ^TMP("DHCST","web.DHCOUTPHA.Owe","jsQueryOweListDetail",pid)
	s Error=$$Error^DHCSTERROR()
	q Error
}

ClassMethod NewPid()
{
	q $i(^DHCOUTPHA("web.DHCOUTPHA.Owe"))
}

}
