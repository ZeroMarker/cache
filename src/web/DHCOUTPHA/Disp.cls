Import sqluser

/// creator:yunhaibao
/// createdate:20160501
/// descirpiton:门诊药房配药发药,直接发药查询
Class web.DHCOUTPHA.Disp Extends %RegisteredObject [ ProcedureBlock ]
{

/// creator:yunhaibao
/// createdate:20160425
/// descirpiton:获取门诊药房配药列表
/// w ##class(web.DHCOUTPHA.Disp).jsQueryPYList(1,30,"2016-08-01^2016-08-31^2^5^0000000222^^3^^^on^^^")
ClassMethod jsQueryPYList(page, rows, params, style = "")
{
	q:params="" ##class(web.DHCSTJQUERYCOMMON).getJsonEmptySign(0) 
	s endpage=page*rows  //结束行
	s stpage=((page-1)*rows)+1 //开始行
	s CDateSt=$p(params,"^",1)
	s CDateEnd=$p(params,"^",2)
	s CDateSt=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(CDateSt)
	s CDateEnd=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(CDateEnd)
	s GPhl=$p(params,"^",3)
	s GPhw=$p(params,"^",4) 
	s CPmiNo=$p(params,"^",5) 
	s CPatName=$p(params,"^",6) 
	s GPydr=$p(params,"^",7) 
	s GFydr=$p(params,"^",8) 
	s GPhwPos=$p(params,"^",9) 
	s CPrint=$p(params,"^",10) 
	i CPrint="on" s CPrint=1
	e  s CPrint=0
	s CPyUser=$p(params,"^",11) 
	s stopcon=$p(params,"^",12) 
	s SpecialID=$p(params,"^",13) 
	s pid=..NewPid() 	
    s $zt="ErrorjsQueryPYList"
    s result=##class(%Library.ResultSet).%New("web.DHCOutPhTQDisp:QueryLocPatPY")
	s sc=result.Execute(CDateSt,CDateEnd,GPhl,GPhw,CPmiNo,CPatName,GPydr,GFydr,GPhwPos,CPrint,CPyUser,stopcon,SpecialID)
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
		s ^TMP("DHCST","web.DHCOUTPHA.Disp","jsQueryPYList",pid,countrecords)=ret
	}
	q:countrecords="0" ##class(web.DHCSTJQUERYCOMMON).getJsonEmptySign(0)
	i endpage>countrecords s endpage=countrecords
	s count=0
	s outputi=""
	f  s outputi=$o(^TMP("DHCST","web.DHCOUTPHA.Disp","jsQueryPYList",pid,outputi)) q:outputi=""  d
	.s outputdata=^TMP("DHCST","web.DHCOUTPHA.Disp","jsQueryPYList",pid,outputi)
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
	k ^TMP("DHCST","web.DHCOUTPHA.Disp","jsQueryPYList",pid)
	q ""
ErrorjsQueryPYList
	k ^TMP("DHCST","web.DHCOUTPHA.Disp","jsQueryPYList",pid)
	s Error=$$Error^DHCSTERROR()
	q Error
}

/// creator:yunhaibao
/// createdate:20160425
/// descirpiton:获取门诊药房发药明细列表,配药发药通用
/// w ##class(web.DHCOUTPHA.Disp).jsQueryDispListDetail("1","200","11^^H181114000011^","jqGrid")
ClassMethod jsQueryDispListDetail(page, rows, params, style = "")
{
	s ^TMPDHCSTPARAMS("web.DHCOUTPHA.Disp","jsQueryDispListDetail")=$lb(page, rows, params, style)
	s page=1
	s rows=100
	s endpage=page*rows  //结束行
	s stpage=((page-1)*rows)+1 //开始行
	s rPHL=$p(params,"^",1) 
	s rPRT=$p(params,"^",2)
	s rPrescNo=$p(params,"^",3)
	s rPhdrow=$p(params,"^",4)
	s fyflag=$p(params,"^",5)   //已发药
	s pid=..NewPid() 	
    s $zt="ErrorjsQueryDispListDetail"
    s result=##class(%Library.ResultSet).%New("web.DHCOutPhDisp:QueryLocOutPatItm")
	s sc=result.Execute(rPHL,rPRT,rPrescNo,rPhdrow,fyflag)
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
		s ^TMP("DHCST","web.DHCOUTPHA.Disp","jsQueryDispListDetail",pid,countrecords)=ret
	}
	q:countrecords="0" ##class(web.DHCSTJQUERYCOMMON).getJsonEmptySign(0)
	i endpage>countrecords s endpage=countrecords
	s count=0
	s outputi=""
	f  s outputi=$o(^TMP("DHCST","web.DHCOUTPHA.Disp","jsQueryDispListDetail",pid,outputi)) q:outputi=""  d
	.s outputdata=^TMP("DHCST","web.DHCOUTPHA.Disp","jsQueryDispListDetail",pid,outputi)
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
	k ^TMP("DHCST","web.DHCOUTPHA.Disp","jsQueryDispListDetail",pid)
	q ""
ErrorjsQueryDispListDetail
	k ^TMP("DHCST","web.DHCOUTPHA.Disp","jsQueryDispListDetail",pid)
	s Error=$$Error^DHCSTERROR()
	q Error
}

/// creator:yunhaibao
/// createdate:20160427
/// descirpiton:获取门诊药房直接发药列表
/// w ##class(web.DHCOUTPHA.Disp).jsQueryDispList(1,50,"2018-11-09^2018-11-12^12^36^^^^^^on^^")
ClassMethod jsQueryDispList(page, rows, params)
{
	q:params="" ##class(web.DHCSTJQUERYCOMMON).getJsonEmptySign(0) 
	s endpage=page*rows  //结束行
	s stpage=((page-1)*rows)+1 //开始行
	s CDateSt=$p(params,"^",1)
	s CDateEnd=$p(params,"^",2)
	s CDateSt=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(CDateSt)
	s CDateEnd=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(CDateEnd)
	s GPhl=$p(params,"^",3)
	s GPhw=$p(params,"^",4)
	s CPmiNo=$p(params,"^",5)
	s CPatName=$p(params,"^",6)
 	s GPydr=$p(params,"^",7)
 	s GFydr=$p(params,"^",8) 
 	s GPhwPos=$p(params,"^",9) 
 	s Fin=$p(params,"^",10) 
 	s specString=$p(params,"^",11,12)
	i Fin="on" s Fin="1"
	e  s Fin=""
	s pid=..NewPid() 	
    s $zt="ErrorjsQueryDispList"
    s result=##class(%Library.ResultSet).%New("web.DHCOutPhDisp:QueryLocOutPat")
	s sc=result.Execute(CDateSt , CDateEnd , GPhl , GPhw , CPmiNo , CPatName , GPydr , GFydr , GPhwPos , Fin , specString)
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
		s ^TMP("DHCST","web.DHCOUTPHA.Disp","jsQueryDispList",pid,countrecords)=ret
	}
	q:countrecords="0" ##class(web.DHCSTJQUERYCOMMON).getJsonEmptySign(0)
	i endpage>countrecords s endpage=countrecords
	s count=0
	s outputi=""
	f  s outputi=$o(^TMP("DHCST","web.DHCOUTPHA.Disp","jsQueryDispList",pid,outputi)) q:outputi=""  d
	.s outputdata=^TMP("DHCST","web.DHCOUTPHA.Disp","jsQueryDispList",pid,outputi)
	.s count=count+1
	.q:count<stpage
    .q:count>endpage
	.I count=stpage d
	..w ##class(web.DHCSTJQUERYCOMMON).getJsonStartStringJqGrid(countrecords,rows)
	..W ##class(web.DHCSTJQUERYCOMMON).getJsonData(colNameStr,outputdata)
	.e  d
	..W ","_##class(web.DHCSTJQUERYCOMMON).getJsonData(colNameStr,outputdata)
	.i count=endpage w ##class(web.DHCSTJQUERYCOMMON).getJsonEndSign()
	k ^TMP("DHCST","web.DHCOUTPHA.Disp","jsQueryDispList",pid)
	q ""
ErrorjsQueryDispList
	k ^TMP("DHCST","web.DHCOUTPHA.Disp","jsQueryDispList",pid)
	s Error=$$Error^DHCSTERROR()
	q Error
}

/// creator:yunhaibao
/// createdate:20160427
/// descirpiton:获取门诊药房发药列表
/// w ##class(web.DHCOUTPHA.Disp).jsQueryFYList(1,30,"2016-05-01^2016-05-03^2^3^0000000222^^^^^")
ClassMethod jsQueryFYList(page, rows, params, style = "")
{
	q:params="" ##class(web.DHCSTJQUERYCOMMON).getJsonEmptySign(0) 
	s endpage=page*rows  //结束行
	s stpage=((page-1)*rows)+1 //开始行
	s CDateSt=$p(params,"^",1)
	s CDateEnd=$p(params,"^",2)
	s CDateSt=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(CDateSt)
	s CDateEnd=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(CDateEnd)
	s GPhl=$p(params,"^",3)
	s GPhw=$p(params,"^",4)
	s CPmiNo=$p(params,"^",5)
	s CPatName=$p(params,"^",6)
	s cludeflag=$p(params,"^",7)
	s CPrescNo=$p(params,"^",8)
	s fyflag=$p(params,"^",9)
	i fyflag="on" s fyflag="1"
	e  s fyflag=""
	s SpecialID=$p(params,"^",10)
	s pid=..NewPid() 	
    s $zt="ErrorjsQueryFYList"
    s result=##class(%Library.ResultSet).%New("web.DHCOutPhTQDisp:QueryLocPatFY")
	s sc=result.Execute(CDateSt, CDateEnd, GPhl, GPhw, CPmiNo, CPatName, cludeflag, CPrescNo, fyflag, SpecialID)
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
		s ^TMP("DHCST","web.DHCOUTPHA.Disp","jsQueryFYList",pid,countrecords)=ret
	}
	q:countrecords="0" ##class(web.DHCSTJQUERYCOMMON).getJsonEmptySign(0)
	i endpage>countrecords s endpage=countrecords
	s count=0
	s outputi=""
	f  s outputi=$o(^TMP("DHCST","web.DHCOUTPHA.Disp","jsQueryFYList",pid,outputi)) q:outputi=""  d
	.s outputdata=^TMP("DHCST","web.DHCOUTPHA.Disp","jsQueryFYList",pid,outputi)
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
	k ^TMP("DHCST","web.DHCOUTPHA.Disp","jsQueryFYList",pid)
	q ""
ErrorjsQueryFYList
	k ^TMP("DHCST","web.DHCOUTPHA.Disp","jsQueryFYList",pid)
	s Error=$$Error^DHCSTERROR()
	q Error
}

/// creator:yunhaibao
/// createdate:20160425
/// descirpiton:获取门诊药房配药列表
/// w ##class(web.DHCOUTPHA.Disp).jsQueryNeedFYList(1,30,"2^3^1")
ClassMethod jsQueryNeedFYList(page, rows, params, style = "")
{
	q:params="" ##class(web.DHCSTJQUERYCOMMON).getJsonEmptySign(0) 
	s endpage=page*rows  //结束行
	s stpage=((page-1)*rows)+1 //开始行
    s phloc=$p(params,"^",1)
    s phw=$p(params,"^",2)
    s fytype=$p(params,"^",3)
	s pid=..NewPid() 	
    s $zt="ErrorjsQueryNeedFYList"
    s result=##class(%Library.ResultSet).%New("web.DHCOutPhTQDisp:GetFYWinList")
	s sc=result.Execute(phloc,phw,fytype)
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
		s ^TMP("DHCST","web.DHCOUTPHA.Disp","jsQueryNeedFYList",pid,countrecords)=ret
	}
	q:countrecords="0" ##class(web.DHCSTJQUERYCOMMON).getJsonEmptySign(0)
	i endpage>countrecords s endpage=countrecords
	s count=0
	s outputi=""
	f  s outputi=$o(^TMP("DHCST","web.DHCOUTPHA.Disp","jsQueryNeedFYList",pid,outputi)) q:outputi=""  d
	.s outputdata=^TMP("DHCST","web.DHCOUTPHA.Disp","jsQueryNeedFYList",pid,outputi)
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
	k ^TMP("DHCST","web.DHCOUTPHA.Disp","jsQueryNeedFYList",pid)
	q ""
ErrorjsQueryNeedFYList
	k ^TMP("DHCST","web.DHCOUTPHA.Disp","jsQueryNeedFYList",pid)
	s Error=$$Error^DHCSTERROR()
	q Error
}

ClassMethod NewPid()
{
	q $i(^DHCOUTPHA("web.DHCOUTPHA.Disp"))
}

}
