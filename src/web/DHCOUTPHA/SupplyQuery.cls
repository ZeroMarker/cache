Import SQLUser

Class web.DHCOUTPHA.SupplyQuery Extends (%RegisteredObject, websys.Abstract) [ ClassType = "", Not ProcedureBlock ]
{

//基数药补货单查询列表

//d ##class(web.DHCOUTPHA.SupplyQuery).jsGetSupplyQueryList(1,10,"2016-07-05#2016-07-05#100######1^0")

ClassMethod jsGetSupplyQueryList(page, rows, params)
{
	q:params="" ##class(web.DHCSTJQUERYCOMMON).getJsonEmptySign(0) 
	s stpage=((page-1)*rows)+1 //开始行
	s endpage=page*rows  //结束行
	s CDateSt=$p(params,"#",1) 
	i CDateSt["-" s CDateSt=$zdh(CDateSt,3)
	s CDateEnd=$p(params,"#",2) 
	i CDateEnd["-" s CDateEnd=$zdh(CDateEnd,3)
	s displocrowid=$p(params,"#",3) 
	s wardrowid=$p(params,"#",4) 
	s StartTime=$p(params,"#",5)
	i StartTime[":" s StartTime=$zth(StartTime,2) 
	s EndTime=$p(params,"#",6)
	i EndTime[":" s EndTime=$zth(EndTime,2)
	s DoctorLocRowid=$p(params,"#",7)
	s DispNo=$p(params,"#",8)
	s PamStr=$p(params,"#",9)
	s pid=..NewPid()
    s $zt="ErrorjsGetSupplyQueryList"
    s result=##class(%Library.ResultSet).%New("web.DHCSTPHSUPPLY:SupplyList")
	s sc=result.Execute(CDateSt, CDateEnd, displocrowid, wardrowid, StartTime, EndTime, DoctorLocRowid, DispNo, PamStr)
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
		s ^TMP("DHCST","web.DHCOUTPHA.SupplyQuery","jsGetSupplyQueryList",pid,countrecords)=ret
	}
	q:countrecords="0" ##class(web.DHCSTJQUERYCOMMON).getJsonEmptySign(0)
	i endpage>countrecords s endpage=countrecords
	s count=0
	s outputi=""
	f  s outputi=$o(^TMP("DHCST","web.DHCOUTPHA.SupplyQuery","jsGetSupplyQueryList",pid,outputi)) q:outputi=""  d
	.s outputdata=^TMP("DHCST","web.DHCOUTPHA.SupplyQuery","jsGetSupplyQueryList",pid,outputi)
	.s count=count+1
	.q:count<stpage
    .q:count>endpage
	.I count=stpage d
	..w ##class(web.DHCSTJQUERYCOMMON).GetJsonStartString(countrecords)
	..W ##class(web.DHCSTJQUERYCOMMON).getJsonData(colNameStr,outputdata)
	.e  d
	..W ","_##class(web.DHCSTJQUERYCOMMON).getJsonData(colNameStr,outputdata)
	.i count=endpage w ##class(web.DHCSTJQUERYCOMMON).getJsonEndSign()
	k ^TMP("DHCST","web.DHCOUTPHA.SupplyQuery","jsGetSupplyQueryList",pid)
	q ""
ErrorjsGetSupplyQueryList
	k ^TMP("DHCST","web.DHCOUTPHA.SupplyQuery","jsGetSupplyQueryList",pid)
	s Error=$$Error^DHCSTERROR()
	q Error
}

//基数药补货单查询汇总列表

//d ##class(web.DHCOUTPHA.SupplyQuery).jsGetSupplyQueryTotalList(1,10,"304711^84")

ClassMethod jsGetSupplyQueryTotalList(page, rows, params)
{
	q:params="" ##class(web.DHCSTJQUERYCOMMON).getJsonEmptySign(0) 
	s stpage=((page-1)*rows)+1 //开始行
	s endpage=page*rows  //结束行
	s tpid=$p(params,"^",1)
	s supp=$p(params,"^",2)
	s pid=..NewPid()
    s $zt="ErrorjsGetSupplyQueryTotalList"
    s result=##class(%Library.ResultSet).%New("web.DHCSTPHSUPPLY:SupplyTotal")
	s sc=result.Execute(tpid,supp)
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
		s ^TMP("DHCST","web.DHCOUTPHA.SupplyQuery","jsGetSupplyQueryTotalList",pid,countrecords)=ret
	}
	q:countrecords="0" ##class(web.DHCSTJQUERYCOMMON).getJsonEmptySign(0)
	i endpage>countrecords s endpage=countrecords
	s count=0
	s outputi=""
	f  s outputi=$o(^TMP("DHCST","web.DHCOUTPHA.SupplyQuery","jsGetSupplyQueryTotalList",pid,outputi)) q:outputi=""  d
	.s outputdata=^TMP("DHCST","web.DHCOUTPHA.SupplyQuery","jsGetSupplyQueryTotalList",pid,outputi)
	.s count=count+1
	.q:count<stpage
    .q:count>endpage
	.I count=stpage d
	..w ##class(web.DHCSTJQUERYCOMMON).GetJsonStartString(countrecords)
	..W ##class(web.DHCSTJQUERYCOMMON).getJsonData(colNameStr,outputdata)
	.e  d
	..W ","_##class(web.DHCSTJQUERYCOMMON).getJsonData(colNameStr,outputdata)
	.i count=endpage w ##class(web.DHCSTJQUERYCOMMON).getJsonEndSign()
	k ^TMP("DHCST","web.DHCOUTPHA.SupplyQuery","jsGetSupplyQueryTotalList",pid)
	q ""
ErrorjsGetSupplyQueryTotalList
	k ^TMP("DHCST","web.DHCOUTPHA.SupplyQuery","jsGetSupplyQueryTotalList",pid)
	s Error=$$Error^DHCSTERROR()
	q Error
}

ClassMethod NewPid()
{
	q $i(^DHCOUTPHA("web.DHCOUTPHA.SupplyQuery"))
}

}
