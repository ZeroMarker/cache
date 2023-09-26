Class web.DHCOUTPHA.RXB Extends %RegisteredObject
{

//creator:yunhaibao

//createdate:20160628

//description:药房日消耗统计列表

//w ##class(web.DHCOUTPHA.RXB).jsQueryGYFRXB(1,100,"","","100^2015-05-29^2016-06-12^^")

ClassMethod jsQueryGYFRXB(page, rows, sort, order, params)
{
    q:params="" ##class(web.DHCSTJQUERYCOMMON).getJsonEmptySign(0) 
	s stpage=((page-1)*rows)+1 //开始行
	s endpage=page*rows  //结束行
	s ctloc=$p(params,"^",1)
	s CDateSt=$p(params,"^",2)
	i CDateSt["-" s CDateSt=$zdh(CDateSt,3)
	s CDateEnd=$p(params,"^",3) 
	i CDateEnd["-" s CDateEnd=$zdh(CDateEnd,3)
	s fydr=$p(params,"^",4)
	s inci=$p(params,"^",5)
	s CIncCatID=$p(params,"^",6)
	s CIncPrice=$p(params,"^",7) 
	s CPhCatID=$p(params,"^",8)
	s ChManFlag=$p(params,"^",9)
	s CManGroupID=$p(params,"^",10)
	s userid=$p(params,"^",11)
	s CWinPosCode=$p(params,"^",12)
	s CStTime=$p(params,"^",13)
	i CStTime[":" s CStTime=$zth(CStTime,2)
	s CEndTime=$p(params,"^",14)
	i CEndTime[":" s CEndTime=$zth(CEndTime,2)
	s pid=..NewPid()
    s $zt="ErrorjsQueryGYFRXB"
    s result=##class(%Library.ResultSet).%New("web.DHCOutPhRetrieve:QueryGYFRXB")
	s sc=result.Execute(ctloc, CDateSt, CDateEnd, fydr, inci, CIncCatID, CIncPrice, "", ChManFlag, CManGroupID, userid, CWinPosCode, CStTime, CEndTime,CPhCatID)
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
		s ^TMP("DHCST","web.DHCOUTPHA.RXB","jsQueryGYFRXB",pid,index,countrecords)=ret
	}
	q:countrecords="0" ##class(web.DHCSTJQUERYCOMMON).getJsonEmptySign(0)
	i endpage>countrecords s endpage=countrecords
	s count=0
	i order="desc" s orderflag="-1"
	e  s orderflag="1"
	s outputi=""
	f  s outputi=$o(^TMP("DHCST","web.DHCOUTPHA.RXB","jsQueryGYFRXB",pid,outputi),orderflag) q:outputi=""  d
	.s outputj=""
	.f  s outputj=$o(^TMP("DHCST","web.DHCOUTPHA.RXB","jsQueryGYFRXB",pid,outputi,outputj),orderflag) q:outputj=""  d
	..s outputdata=^TMP("DHCST","web.DHCOUTPHA.RXB","jsQueryGYFRXB",pid,outputi,outputj)
	..s count=count+1
	..q:count<stpage
    ..q:count>endpage
	..I count=stpage d
	...w ##class(web.DHCSTJQUERYCOMMON).GetJsonStartString(countrecords)
	...W ##class(web.DHCSTJQUERYCOMMON).getJsonData(colNameStr,outputdata)
	..e  d
	...W ","_##class(web.DHCSTJQUERYCOMMON).getJsonData(colNameStr,outputdata)
	..i count=endpage w ##class(web.DHCSTJQUERYCOMMON).getJsonEndSign()
	k ^TMP("DHCST","web.DHCOUTPHA.RXB","jsQueryGYFRXB",pid)
	q ""
ErrorjsQueryGYFRXB
	k ^TMP("DHCST","web.DHCOUTPHA.RXB","jsQueryGYFRXB",pid)
	s Error=$$Error^DHCSTERROR()
	q Error
}

ClassMethod NewPid()
{
	q $i(^DHCOUTPHA("web.DHCOUTPHA.RXB"))
}

}
