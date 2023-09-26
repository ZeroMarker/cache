Import SQLUser

Class web.DHCOUTPHA.MZYPTJ Extends (%RegisteredObject, websys.Abstract) [ ClassType = "", Not ProcedureBlock ]
{

//麻醉药品处方统计列表

//d ##class(web.DHCOUTPHA.MZYPTJ).jsGetMZYPTJList(1,10,"2016-07-01^2016-07-01^100^^")

ClassMethod jsGetMZYPTJList(page, rows, params)
{
	q:params="" ##class(web.DHCSTJQUERYCOMMON).getJsonEmptySign(0) 
	s stpage=((page-1)*rows)+1 //开始行
	s endpage=page*rows  //结束行
	s CDateSt=$p(params,"^",1) 
	i CDateSt["-" s CDateSt=$zdh(CDateSt,3)
	s CDateEnd=$p(params,"^",2) 
	i CDateEnd["-" s CDateEnd=$zdh(CDateEnd,3)
	s ctloc=$p(params,"^",3) 
	s CIncCatID=$p(params,"^",4) 
	s PoisonRowid=$p(params,"^",5) 
	s pid=..NewPid()
    s $zt="ErrorjsGetMZYPTJList"
    s result=##class(%Library.ResultSet).%New("web.DHCOutPhRetrieve:QueryMZYP")
	s sc=result.Execute(CDateSt, CDateEnd, ctloc, CIncCatID, PoisonRowid)
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
		s ^TMP("DHCST","web.DHCOUTPHA.MZYPTJ","jsGetMZYPTJList",pid,countrecords)=ret
	}
	q:countrecords="0" ##class(web.DHCSTJQUERYCOMMON).getJsonEmptySign(0)
	i endpage>countrecords s endpage=countrecords
	s count=0
	s outputi=""
	f  s outputi=$o(^TMP("DHCST","web.DHCOUTPHA.MZYPTJ","jsGetMZYPTJList",pid,outputi)) q:outputi=""  d
	.s outputdata=^TMP("DHCST","web.DHCOUTPHA.MZYPTJ","jsGetMZYPTJList",pid,outputi)
	.s count=count+1
	.q:count<stpage
    .q:count>endpage
	.I count=stpage d
	..w ##class(web.DHCSTJQUERYCOMMON).GetJsonStartString(countrecords)
	..W ##class(web.DHCSTJQUERYCOMMON).getJsonData(colNameStr,outputdata)
	.e  d
	..W ","_##class(web.DHCSTJQUERYCOMMON).getJsonData(colNameStr,outputdata)
	.i count=endpage w ##class(web.DHCSTJQUERYCOMMON).getJsonEndSign()
	k ^TMP("DHCST","web.DHCOUTPHA.MZYPTJ","jsGetMZYPTJList",pid)
	q ""
ErrorjsGetMZYPTJList
	k ^TMP("DHCST","web.DHCOUTPHA.MZYPTJ","jsGetMZYPTJList",pid)
	s Error=$$Error^DHCSTERROR()
	q Error
}

ClassMethod NewPid()
{
	q $i(^DHCOUTPHA("web.DHCOUTPHA.MZYPTJ"))
}

}
