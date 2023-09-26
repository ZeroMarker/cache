Import SQLUser

Class web.DHCOUTPHA.DispQuery Extends (%RegisteredObject, websys.Abstract) [ ClassType = "", Not ProcedureBlock ]
{

//发药查询列表

/// w ##class(web.DHCOUTPHA.DispQuery).jsQueryDisp(1,100,"2016-04-27^2016-04-27^100^^^^^^^1^0^^^^")
ClassMethod jsQueryDisp(page, rows, params)
{
	//s ^yunhaibao("jsquerydisp")=params
    q:params="" ##class(web.DHCSTJQUERYCOMMON).getJsonEmptySign(0) 
	s stpage=((page-1)*rows)+1 //开始行
	s endpage=page*rows  //结束行
	s CDateSt=$p(params,"^",1)
	s CDateEnd=$p(params,"^",2)
	i CDateSt["-" s CDateSt=$zdh(CDateSt,3)
	i CDateEnd["-" s CDateEnd=$zdh(CDateEnd,3)
	s ctloc=$p(params,"^",3)
	s CPmiNo=$p(params,"^",4)
	s CPerName=$p(params,"^",5)
	s CPrtInv=$p(params,"^",6)
	s inci=$p(params,"^",7)
	s CPydr=$p(params,"^",8)
	s CFydr=$p(params,"^",9)
	s FyFlag=$p(params,"^",10)
	s sttime=$p(params,"^",11)
	s endtime=$p(params,"^",12)
	i sttime'="" s sttime=$zth(sttime,2)
	i endtime'="" s endtime=$zth(endtime,2)
	s glflag=$p(params,"^",13)
	s CDepCode=$p(params,"^",14)
	s CDoctor=$p(params,"^",15)
	s pid=..NewPid()
    s $zt="ErrorjsQueryDisp"
    s result=##class(%Library.ResultSet).%New("web.DHCOutPhRetrieve:QueryLocPatienCX")
	s sc=result.Execute(CDateSt,CDateEnd,ctloc,CPmiNo,CPerName,CPrtInv,inci,CPydr,CFydr,FyFlag,sttime,endtime,glflag,CDepCode,CDoctor)
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
		s ^TMP("DHCST","web.DHCOUTPHA.FYQUERYDisp","jsQueryDisp",pid,countrecords)=ret
	}
	q:countrecords="0" ##class(web.DHCSTJQUERYCOMMON).getJsonEmptySign(0)
	i endpage>countrecords s endpage=countrecords
	s count=0
	s outputi=""
	f  s outputi=$o(^TMP("DHCST","web.DHCOUTPHA.FYQUERYDisp","jsQueryDisp",pid,outputi)) q:outputi=""  d
	.s outputdata=^TMP("DHCST","web.DHCOUTPHA.FYQUERYDisp","jsQueryDisp",pid,outputi)
	.s count=count+1
	.q:count<stpage
    .q:count>endpage
	.I count=stpage d
	..w ##class(web.DHCSTJQUERYCOMMON).GetJsonStartString(countrecords)
	..W ##class(web.DHCSTJQUERYCOMMON).getJsonData(colNameStr,outputdata)
	.e  d
	..W ","_##class(web.DHCSTJQUERYCOMMON).getJsonData(colNameStr,outputdata)
	.i count=endpage w ##class(web.DHCSTJQUERYCOMMON).getJsonEndSign()
	k ^TMP("DHCST","web.DHCOUTPHA.FYQUERYDisp","jsQueryDisp",pid)
	q ""
ErrorjsQueryDisp
	k ^TMP("DHCST","web.DHCOUTPHA.FYQUERYDisp","jsQueryDisp",pid)
	s Error=$$Error^DHCSTERROR()
	q Error
}

//发药明细列表

/// w ##class(web.DHCOUTPHA.DispQuery).jsQueryDispDetail(1,100,"789^1^100^O16042600003")
ClassMethod jsQueryDispDetail(page, rows, params)
{
	//s ^yunhaibao("jsQueryDispDetail")=params
    q:params="" ##class(web.DHCSTJQUERYCOMMON).getJsonEmptySign(0) 
	s stpage=((page-1)*rows)+1 //开始行
	s endpage=page*rows  //结束行
	s rPhd=$p(params,"^",1)
	s FyFlag=$p(params,"^",2)
	s rCtloc=$p(params,"^",3)
	s rPrescNo=$p(params,"^",4)
	s pid=..NewPid()
    s $zt="ErrorjsQueryDispDetail"
    s result=##class(%Library.ResultSet).%New("web.DHCOutPhRetrieve:QueryGPersonOrd")
	s sc=result.Execute(rPhd,FyFlag,rCtloc,rPrescNo)
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
		s ^TMP("DHCST","web.DHCOUTPHA.FYQUERYDisp","jsQueryDispDetail",pid,countrecords)=ret
	}
	q:countrecords="0" ##class(web.DHCSTJQUERYCOMMON).getJsonEmptySign(0)
	i endpage>countrecords s endpage=countrecords
	s count=0
	s outputi=""
	f  s outputi=$o(^TMP("DHCST","web.DHCOUTPHA.FYQUERYDisp","jsQueryDispDetail",pid,outputi)) q:outputi=""  d
	.s outputdata=^TMP("DHCST","web.DHCOUTPHA.FYQUERYDisp","jsQueryDispDetail",pid,outputi)
	.s count=count+1
	.q:count<stpage
    .q:count>endpage
	.I count=stpage d
	..w ##class(web.DHCSTJQUERYCOMMON).GetJsonStartString(countrecords)
	..W ##class(web.DHCSTJQUERYCOMMON).getJsonData(colNameStr,outputdata)
	.e  d
	..W ","_##class(web.DHCSTJQUERYCOMMON).getJsonData(colNameStr,outputdata)
	.i count=endpage w ##class(web.DHCSTJQUERYCOMMON).getJsonEndSign()
	k ^TMP("DHCST","web.DHCOUTPHA.FYQUERYDisp","jsQueryDispDetail",pid)
	q ""
ErrorjsQueryDispDetail
	k ^TMP("DHCST","web.DHCOUTPHA.FYQUERYDisp","jsQueryDispDetail",pid)
	s Error=$$Error^DHCSTERROR()
	q Error
}

ClassMethod NewPid()
{
	q $i(^DHCOUTPHA("web.DHCOUTPHA.FYQUERYDisp"))
}

}
