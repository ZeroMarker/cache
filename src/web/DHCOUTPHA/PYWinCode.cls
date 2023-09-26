Import SQLUser

Class web.DHCOUTPHA.PYWinCode Extends (%RegisteredObject, websys.Abstract) [ ClassType = "", Not ProcedureBlock ]
{

// 药房配药窗口维护列表

// d ##class(web.DHCOUTPHA.PYWinCode).jsGetPYWinCodeList(1,10,"")

ClassMethod jsGetPYWinCodeList(page, rows, params, HospId = "")
{
	//q:params="" ##class(web.DHCSTJQUERYCOMMON).getJsonEmptySign(0) 
	s locid=$p(params,"^",1)
	s stpage=((page-1)*rows)+1 //开始行
	s endpage=page*rows  //结束行
	s pid=..NewPid()
    s $zt="ErrorjsGetPYWinCodeList"
    s result=##class(%Library.ResultSet).%New("web.DHCOutPhCode:FindPhPYWin")
	s sc=result.Execute()
	i $$$ISERR(sc) q ##class(web.DHCSTJQUERYCOMMON).getJsonEmptySign(0) 
	s colNum=result.GetColumnCount()
	s TLocIdNum=0
	s colNameStr=""
	f i=1:1:colNum d
	.s colName=result.GetColumnName(i)
	.i colName="TLocId" s TLocIdNum=i
	.i colNameStr="" s colNameStr=colName
	.e  s colNameStr=colNameStr_"^"_colName
	s countrecords=0
	While(result.Next())
	{ 
		s ret="",quitflag=""
		f i=1:1:colNum d
		.s retvalue=result.%GetData(i)
		.i ret="" s ret=retvalue
		.e   s ret=ret_"^"_retvalue
		.i (i=TLocIdNum) d
		..i (locid'="")&&(locid'=retvalue)  s quitflag=1
		..i (HospId'=$p($g(^CTLOC(+retvalue)),"^",22)) s quitflag=1
		continue:quitflag'=""
		s countrecords=countrecords+1  //可做索引用
		s ^TMP("DHCST","web.DHCOUTPHA.PYWinCode","jsGetPYWinCodeList",pid,countrecords)=ret
	}
	q:countrecords="0" ##class(web.DHCSTJQUERYCOMMON).getJsonEmptySign(0)
	i endpage>countrecords s endpage=countrecords
	s count=0
	s outputi=""
	f  s outputi=$o(^TMP("DHCST","web.DHCOUTPHA.PYWinCode","jsGetPYWinCodeList",pid,outputi)) q:outputi=""  d
	.s outputdata=^TMP("DHCST","web.DHCOUTPHA.PYWinCode","jsGetPYWinCodeList",pid,outputi)
	.s count=count+1
	.q:count<stpage
    .q:count>endpage
	.I count=stpage d
	..w ##class(web.DHCSTJQUERYCOMMON).GetJsonStartString(countrecords)
	..W ##class(web.DHCSTJQUERYCOMMON).getJsonData(colNameStr,outputdata)
	.e  d
	..W ","_##class(web.DHCSTJQUERYCOMMON).getJsonData(colNameStr,outputdata)
	.i count=endpage w ##class(web.DHCSTJQUERYCOMMON).getJsonEndSign()
	k ^TMP("DHCST","web.DHCOUTPHA.PYWinCode","jsGetPYWinCodeList",pid)
	q ""
ErrorjsGetPYWinCodeList
	k ^TMP("DHCST","web.DHCOUTPHA.PYWinCode","jsGetPYWinCodeList",pid)
	s Error=$$Error^DHCSTERROR()
	q Error
}

ClassMethod NewPid()
{
	q $i(^DHCOUTPHA("web.DHCOUTPHA.PYWinCode"))
}

}
