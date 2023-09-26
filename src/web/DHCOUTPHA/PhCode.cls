Class web.DHCOUTPHA.PhCode Extends %RegisteredObject
{

/// creator:yunhaibao
/// createdate:20160707
/// description:门诊药房科室维护列表
/// w ##class(web.DHCOUTPHA.PhCode).jsQueryPhLocCode()
ClassMethod jsQueryPhLocCode(HospId = "")
{
	s page=1
	s rows=9999
	s stpage=((page-1)*rows)+1 //开始行
	s endpage=page*rows  //结束行
	s pid=..NewPid()
    s $zt="ErrorjsQueryPhLocCode"
    s result=##class(%Library.ResultSet).%New("web.DHCOutPhCode:UFindPhLoc")
	s sc=result.Execute(HospId)
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
		.s retvalue=result.%GetData(i)
		.i ret="" s ret=retvalue
		.e   s ret=ret_"^"_retvalue
		s countrecords=countrecords+1  //可做索引用
		s ^TMP("DHCST","web.DHCOUTPHA.PhCode","jsQueryPhLocCode",pid,countrecords)=ret
	}
	q:countrecords="0" ##class(web.DHCSTJQUERYCOMMON).getJsonEmptySign(0)
	i endpage>countrecords s endpage=countrecords
	s count=0
	s outputi=""
	f  s outputi=$o(^TMP("DHCST","web.DHCOUTPHA.PhCode","jsQueryPhLocCode",pid,outputi)) q:outputi=""  d
	.s outputdata=^TMP("DHCST","web.DHCOUTPHA.PhCode","jsQueryPhLocCode",pid,outputi)
	.s count=count+1
	.q:count<stpage
    .q:count>endpage
	.I count=stpage d
	..w ##class(web.DHCSTJQUERYCOMMON).GetJsonStartString(countrecords)
	..W ##class(web.DHCSTJQUERYCOMMON).getJsonData(colNameStr,outputdata)
	.e  d
	..W ","_##class(web.DHCSTJQUERYCOMMON).getJsonData(colNameStr,outputdata)
	.i count=endpage w ##class(web.DHCSTJQUERYCOMMON).getJsonEndSign()
	k ^TMP("DHCST","web.DHCOUTPHA.PhCode","jsQueryPhLocCode",pid)
	q ""
ErrorjsQueryPhLocCode
	k ^TMP("DHCST","web.DHCOUTPHA.PhCode","jsQueryPhLocCode",pid)
	s Error=$$Error^DHCSTERROR()
	q Error
}

/// creator:yunhaibao
/// createdate:20160707
/// description:门诊药房科室维护保存
/// w ##class(web.DHCOUTPHA.PhCode).SavePhLocCode("2^100^1^1^1^1^0^578^0^0^0^0^0^ew^0^0^N^Y")
ClassMethod SavePhLocCode(params)
{
	q:params="" -11
	s phLocRowId=$p(params,"^",1)
	s locRowId=$p(params,"^",2)
	q:locRowId="" -12
	s chkpy=$p(params,"^",3)
	s chkfy=$p(params,"^",4)
	s dispmath=$p(params,"^",5)
	s chktq=$p(params,"^",6)
	s chkzcy=$p(params,"^",7)
	s gUserId=$p(params,"^",8)
	s chksend=$p(params,"^",9)
	s chkprint=$p(params,"^",10)
	s chkwintype=$p(params,"^",11)
	s chkmachine=$p(params,"^",12)
	s chkscreen=$p(params,"^",13)
	s screenpath=$p(params,"^",14)
	s chksure=$p(params,"^",15)
	s chkautopy=$p(params,"^",16)
	s chkaudit=$p(params,"^",17)
	s chkotherlocret=$p(params,"^",18)
	s ret=0
	i phLocRowId="" d //插入
	.s ret=##class(web.DHCOutPhCode).insertPhLoc(locRowId,chkpy,chkfy,dispmath,chktq,chkzcy,chksend,chkprint,chkwintype,chkmachine,chkscreen,screenpath,chksure,chkautopy,chkaudit,chkotherlocret)
	e  d //更新
	.s ret=##class(web.DHCOutPhCode).UpdatePhLoc(phLocRowId,chkpy,chkfy,dispmath,chktq,chkzcy,gUserId,chksend,chkprint,chkwintype,chkmachine,chkscreen,screenpath,chksure,chkautopy,chkaudit,chkotherlocret	)
	q ret
}

ClassMethod NewPid()
{
	q $i(^DHCOUTPHA("web.DHCOUTPHA.PhCode"))
}

}
