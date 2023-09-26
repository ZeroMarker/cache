Import sqluser

/// creator:yunhaibao
/// createdate:20160629
/// descirpiton:住院药房发药统计
Class web.DHCINPHA.DispStat Extends %RegisteredObject [ ProcedureBlock ]
{

/// creator:yunhaibao
/// createdate:20160628
/// description:药房发药统计列表
/// w ##class(web.DHCINPHA.DispStat).jsQueryDispStat(1,100,"","","2016-05-29^2016-06-29^98^^^^^1^^^^")
ClassMethod jsQueryDispStat(page, rows, sort, order, params)
{
	n (%session)
    q:params="" ##class(web.DHCSTJQUERYCOMMON).getJsonEmptySign(0) 
	s stpage=((page-1)*rows)+1 //开始行
	s endpage=page*rows  //结束行
	s StartDate=$p(params,"^",1)
	i StartDate["-" s StartDate=$zdh(StartDate,3)
	s EndDate=$p(params,"^",2)
	i EndDate["-" s EndDate=$zdh(EndDate,3)
	s displocrowid=$p(params,"^",3)
	s dispcatval=$p(params,"^",4)
	s StartTime=$p(params,"^",5)
	i StartTime[":" s StartTime=$zth(StartTime,2)
	s EndTime=$p(params,"^",6)
	i EndTime[":" s EndTime=$zth(EndTime,2)
	s incirowid=$p(params,"^",7)
	s statflag=$p(params,"^",8)
	s tPhcCatRowid=$p(params,"^",9)
	s IncludeDispF=$p(params,"^",10)
	s tRegNo=$p(params,"^",11)
	s stkgrp=$p(params,"^",12)
	s pid=..NewPid()
    s $zt="ErrorjsQueryDispStat"
    s result=##class(%Library.ResultSet).%New("web.DHCSTPCHCOLLS:DispStat")
	s sc=result.Execute(StartDate, EndDate, displocrowid, dispcatval, StartTime, EndTime, incirowid, statflag, tPhcCatRowid, IncludeDispF, tRegNo, stkgrp)
	i $$$ISERR(sc) q ##class(web.DHCSTJQUERYCOMMON).getJsonEmptySign(0) 
	s colNum=result.GetColumnCount()
	s colNameStr="",sorti=""
	f i=1:1:colNum d
	.s colName=result.GetColumnName(i)
	.i colNameStr="" s colNameStr=colName
	.e  s colNameStr=colNameStr_"^"_colName
	.i ((sort'="")&&(sort=colName)) s sorti=i
	
	s countrecords=0
	While(result.Next())
	{ 
		s ret="",index=0
		f i=1:1:colNum d
		.s colvalue=result.%GetData(i)
		.i ret="" s ret=colvalue
		.e   s ret=ret_"^"_colvalue
		.i (sorti'="")&&(sorti=i) s index=colvalue
		i index="" s index=0
		s countrecords=countrecords+1  //可做索引用
		s ^TMP("DHCST","web.DHCINPHA.DispStat","jsQueryDispStat",pid,index,countrecords)=ret
	}
	q:countrecords="0" ##class(web.DHCSTJQUERYCOMMON).getJsonEmptySign(0)
	i endpage>countrecords s endpage=countrecords
	s count=0
	i order="desc" s orderflag="-1"
	e  s orderflag="1"
	s outputi=""
	f  s outputi=$o(^TMP("DHCST","web.DHCINPHA.DispStat","jsQueryDispStat",pid,outputi),orderflag) q:outputi=""  d
	.s outputj=""
	.f  s outputj=$o(^TMP("DHCST","web.DHCINPHA.DispStat","jsQueryDispStat",pid,outputi,outputj),orderflag) q:outputj=""  d
	..s outputdata=^TMP("DHCST","web.DHCINPHA.DispStat","jsQueryDispStat",pid,outputi,outputj)
	..s count=count+1
	..q:count<stpage
    ..q:count>endpage
	..I count=stpage d
	...w ##class(web.DHCSTJQUERYCOMMON).GetJsonStartString(countrecords)
	...W ##class(web.DHCSTJQUERYCOMMON).getJsonData(colNameStr,outputdata)
	..e  d
	...W ","_##class(web.DHCSTJQUERYCOMMON).getJsonData(colNameStr,outputdata)
	..i count=endpage w ##class(web.DHCSTJQUERYCOMMON).getJsonEndSign()
	k ^TMP("DHCST","web.DHCINPHA.DispStat","jsQueryDispStat",pid)
	q ""
ErrorjsQueryDispStat
	k ^TMP("DHCST","web.DHCINPHA.DispStat","jsQueryDispStat",pid)
	s Error=$$Error^DHCSTERROR()
	q Error
}

/// creator:yunhaibao
/// createdate:20160628
/// description:药房发药统计明细列表
/// w ##class(web.DHCINPHA.DispStat).jsQueryDispStatDetail(1,100,"","","657723,6^10")
ClassMethod jsQueryDispStatDetail(page, rows, sort, order, params)
{
	//s ^yunhaibao("jsQueryDispStatDetail")=params
    q:params="" ##class(web.DHCSTJQUERYCOMMON).getJsonEmptySign(0) 
	s stpage=((page-1)*rows)+1 //开始行
	s endpage=page*rows  //结束行
	s processid=$p(params,",",1)
	s admlocstr=$p(params,",",2)
	q:admlocstr="" ##class(web.DHCSTJQUERYCOMMON).getJsonEmptySign(0) 
	s pid=..NewPid()
    s $zt="ErrorjsQueryDispStatDetail"
    s result=##class(%Library.ResultSet).%New("web.DHCSTPCHCOLLS:DispStatItm")
	s sc=result.Execute(processid,admlocstr)
	i $$$ISERR(sc) q ##class(web.DHCSTJQUERYCOMMON).getJsonEmptySign(0) 
	s colNum=result.GetColumnCount()
	s colNameStr="",sorti=""
	f i=1:1:colNum d
	.s colName=result.GetColumnName(i)
	.i colNameStr="" s colNameStr=colName
	.e  s colNameStr=colNameStr_"##"_colName
	.i ((sort'="")&&(sort=colName)) s sorti=i
	
	s countrecords=0
	While(result.Next())
	{ 
		s ret="",index=0
		f i=1:1:colNum d
		.s colvalue=result.%GetData(i)
		.i ret="" s ret=colvalue
		.e   s ret=ret_"##"_colvalue
		.i (sorti'="")&&(sorti=i) s index=colvalue
		i index="" s index=0
		s countrecords=countrecords+1  //可做索引用
		s ^TMP("DHCST","web.DHCINPHA.DispStat","jsQueryDispStatDetail",pid,index,countrecords)=ret
	}
	q:countrecords="0" ##class(web.DHCSTJQUERYCOMMON).getJsonEmptySign(0)
	i endpage>countrecords s endpage=countrecords
	s count=0
	i order="desc" s orderflag="-1"
	e  s orderflag="1"
	s outputi=""
	f  s outputi=$o(^TMP("DHCST","web.DHCINPHA.DispStat","jsQueryDispStatDetail",pid,outputi),orderflag) q:outputi=""  d
	.s outputj=""
	.f  s outputj=$o(^TMP("DHCST","web.DHCINPHA.DispStat","jsQueryDispStatDetail",pid,outputi,outputj),orderflag) q:outputj=""  d
	..s outputdata=^TMP("DHCST","web.DHCINPHA.DispStat","jsQueryDispStatDetail",pid,outputi,outputj)
	..s count=count+1
	..q:count<stpage
    ..q:count>endpage
	..I count=stpage d
	...w ##class(web.DHCSTJQUERYCOMMON).GetJsonStartString(countrecords)
	...W ##class(web.DHCSTJQUERYCOMMON).getJsonData(colNameStr,outputdata,"##")
	..e  d
	...W ","_##class(web.DHCSTJQUERYCOMMON).getJsonData(colNameStr,outputdata,"##")
	..i count=endpage w ##class(web.DHCSTJQUERYCOMMON).getJsonEndSign()
	k ^TMP("DHCST","web.DHCINPHA.DispStat","jsQueryDispStatDetail",pid)
	q ""
ErrorjsQueryDispStatDetail
	k ^TMP("DHCST","web.DHCINPHA.DispStat","jsQueryDispStatDetail",pid)
	s Error=$$Error^DHCSTERROR()
	q Error
}

ClassMethod NewPid()
{
	q $i(^DHCOUTPHA("web.DHCINPHA.DispStat"))
}

}
