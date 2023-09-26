Import SQLUser

Class web.DHCOUTPHA.PrescnoTJ Extends (%RegisteredObject, websys.Abstract) [ ClassType = "", Not ProcedureBlock ]
{

//药房处方统计列表

//d ##class(web.DHCOUTPHA.PrescnoTJ).jsGetPrescnoTJList(1,10,"2016-07-01^2016-07-01^^^100^^^^")

ClassMethod jsGetPrescnoTJList(page, rows, params)
{
	s ^yunhaibao("jsGetPrescnoTJList")=page_","_rows_","_params
	q:params="" ##class(web.DHCSTJQUERYCOMMON).getJsonEmptySign(0) 
	s stpage=((page-1)*rows)+1 //开始行
	s endpage=page*rows  //结束行
	s CDateSt=$p(params,"^",1) 
	i CDateSt["-" s CDateSt=$zdh(CDateSt,3)
	s CDateEnd=$p(params,"^",2) 
	i CDateEnd["-" s CDateEnd=$zdh(CDateEnd,3)
	s sttime=$p(params,"^",3) 
	i sttime[":" s sttime=$zth(sttime,2)
	s endtime=$p(params,"^",4) 
	i endtime[":" s endtime=$zth(endtime,2)
	s ctloc=$p(params,"^",5) 
	s CPrescTypeID=$p(params,"^",6) 
	s CPrescPhNum=$p(params,"^",7) 
	s CIncCatID=$p(params,"^",8) 
	s CPhCatID=$p(params,"^",9) 
	s COutPresc=$p(params,"^",10) 
	s CEmPresc=$p(params,"^",11) 
	s pid=..NewPid()
    s $zt="ErrorjsGetPrescnoTJList"
    s result=##class(%Library.ResultSet).%New("web.DHCOutPhAdd:GLocPresc")
	s sc=result.Execute(CDateSt, CDateEnd, sttime, endtime, ctloc, CPrescTypeID, CPrescPhNum, CIncCatID, CPhCatID, COutPresc, CEmPresc)
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
		.i i=5 s retvalue=""
		.i ret="" s ret=retvalue
		.e   s ret=ret_"^"_retvalue
		s countrecords=countrecords+1  //可做索引用
		s ^TMP("DHCST","web.DHCOUTPHA.PrescnoTJ","jsGetPrescnoTJList",pid,countrecords)=ret
	}
	q:countrecords="0" ##class(web.DHCSTJQUERYCOMMON).getJsonEmptySign(0)
	i endpage>countrecords s endpage=countrecords
	s count=0
	s outputi=""
	f  s outputi=$o(^TMP("DHCST","web.DHCOUTPHA.PrescnoTJ","jsGetPrescnoTJList",pid,outputi)) q:outputi=""  d
	.s outputdata=^TMP("DHCST","web.DHCOUTPHA.PrescnoTJ","jsGetPrescnoTJList",pid,outputi)
	.s count=count+1
	.q:count<stpage
    .q:count>endpage
	.I count=stpage d
	..w ##class(web.DHCSTJQUERYCOMMON).GetJsonStartString(countrecords)
	..W ##class(web.DHCSTJQUERYCOMMON).getJsonData(colNameStr,outputdata)
	.e  d
	..W ","_##class(web.DHCSTJQUERYCOMMON).getJsonData(colNameStr,outputdata)
	.i count=endpage w ##class(web.DHCSTJQUERYCOMMON).getJsonEndSign()
	k ^TMP("DHCST","web.DHCOUTPHA.PrescnoTJ","jsGetPrescnoTJList",pid)
	q ""
ErrorjsGetPrescnoTJList
	k ^TMP("DHCST","web.DHCOUTPHA.PrescnoTJ","jsGetPrescnoTJList",pid)
	s Error=$$Error^DHCSTERROR()
	q Error
}

ClassMethod NewPid()
{
	q $i(^DHCOUTPHA("web.DHCOUTPHA.PrescnoTJ"))
}

}
