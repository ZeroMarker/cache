Import SQLUser

Class web.DHCOUTPHA.WorkLoadDisp Extends (%RegisteredObject, websys.Abstract) [ ClassType = "", Not ProcedureBlock ]
{

//药房工作量统计列表

//w ##class(web.DHCOUTPHA.WorkLoadDisp).jsGetWorkLoadList(1,100,"","","100^2015-05-29^2016-06-12^^")

ClassMethod jsGetWorkLoadList(page, rows, sort, order, params)
{
	s page=1
    s rows=9999
    q:params="" ##class(web.DHCSTJQUERYCOMMON).getJsonEmptySign(0) 
	s stpage=((page-1)*rows)+1 //开始行
	s endpage=page*rows  //结束行
	s ctloc=$p(params,"^",1)
	s CDateSt=$p(params,"^",2)
	s CDateEnd=$p(params,"^",3)
	i CDateSt["-" s CDateSt=$zdh(CDateSt,3)
	i CDateEnd["-" s CDateEnd=$zdh(CDateEnd,3)
	s CStTime=$p(params,"^",4)
	s CEndTime=$p(params,"^",5)
	i CStTime[":" s CStTime=$zth(CStTime,2)
	i CEndTime[":" s CEndTime=$zth(CEndTime,2)
	s pid=..NewPid()
    s $zt="ErrorjsGetWorkLoadList"
    s result=##class(%Library.ResultSet).%New("web.DHCOutPhRetrieve:QueryGZLNew")
	s sc=result.Execute(ctloc , CDateSt , CDateEnd , CStTime , CEndTime)
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
		s ^TMP("DHCST","web.DHCOUTPHA.WorkLoadDisp","jsGetWorkLoadList",pid,index,countrecords)=ret
	}
	q:countrecords="0" ##class(web.DHCSTJQUERYCOMMON).getJsonEmptySign(0)
	i endpage>countrecords s endpage=countrecords
	s count=0
	i order="desc" s orderflag="-1"
	e  s orderflag="1"
	s outputi=""
	f  s outputi=$o(^TMP("DHCST","web.DHCOUTPHA.WorkLoadDisp","jsGetWorkLoadList",pid,outputi),orderflag) q:outputi=""  d
	.s outputj=""
	.f  s outputj=$o(^TMP("DHCST","web.DHCOUTPHA.WorkLoadDisp","jsGetWorkLoadList",pid,outputi,outputj),orderflag) q:outputj=""  d
	..s outputdata=^TMP("DHCST","web.DHCOUTPHA.WorkLoadDisp","jsGetWorkLoadList",pid,outputi,outputj)
	..s count=count+1
	..q:count<stpage
    ..q:count>endpage
	..I count=stpage d
	...w ##class(web.DHCSTJQUERYCOMMON).GetJsonStartString(countrecords)
	...W ##class(web.DHCSTJQUERYCOMMON).getJsonData(colNameStr,outputdata)
	..e  d
	...W ","_##class(web.DHCSTJQUERYCOMMON).getJsonData(colNameStr,outputdata)
	..i count=endpage w ##class(web.DHCSTJQUERYCOMMON).getJsonEndSign()
	k ^TMP("DHCST","web.DHCOUTPHA.WorkLoadDisp","jsGetWorkLoadList",pid)
	q ""
ErrorjsGetWorkLoadList
	k ^TMP("DHCST","web.DHCOUTPHA.WorkLoadDisp","jsGetWorkLoadList",pid)
	s Error=$$Error^DHCSTERROR()
	q Error
}

ClassMethod NewPid()
{
	q $i(^DHCOUTPHA("web.DHCOUTPHA.WorkLoadDisp"))
}

}
