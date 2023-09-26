Import sqluser

/// creator:yunhaibao
/// createdate:201608-23
/// descirpiton:门诊药房配药确认
Class web.DHCOUTPHA.DispConfirm Extends %RegisteredObject
{

/// w ##class(web.DHCOUTPHA.DispConfirm).jsQueryDispConfirmList("21^100")
ClassMethod jsQueryDispConfirmList(params)
{
	q:params="" ##class(web.DHCSTJQUERYCOMMON).getJsonEmptySign(0) 
	s page=1,rows=100
	s endpage=page*rows  //结束行
	s stpage=((page-1)*rows)+1 //开始行
	s rPhd=$p(params,"^",1)
	s rCtloc=$p(params,"^",2)
	s pid=..NewPid()
    s $zt="ErrorGetDispConfirmList"
    s result=##class(%Library.ResultSet).%New("web.DHCOutPhNewAddCommit:QueryGPersonOrd")
	s sc=result.Execute(rPhd,rCtloc)
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
		s ^TMP("DHCST","web.DHCSTCNTSOUTMONITOR","jsQueryDispConfirmList",pid,countrecords)=ret
	}
	q:countrecords="0" ##class(web.DHCSTJQUERYCOMMON).getJsonEmptySign(0)
	i endpage>countrecords s endpage=countrecords
	s count=0
	s outputi=""
	f  s outputi=$o(^TMP("DHCST","web.DHCSTCNTSOUTMONITOR","jsQueryDispConfirmList",pid,outputi)) q:outputi=""  d
	.s outputdata=^TMP("DHCST","web.DHCSTCNTSOUTMONITOR","jsQueryDispConfirmList",pid,outputi)
	.s count=count+1
	.q:count<stpage
    .q:count>endpage
	.I count=stpage d
	..w ##class(web.DHCSTJQUERYCOMMON).GetJsonStartString(countrecords)
	..W ##class(web.DHCSTJQUERYCOMMON).getJsonData(colNameStr,outputdata)
	.e  d
	..W ","_##class(web.DHCSTJQUERYCOMMON).getJsonData(colNameStr,outputdata)
	.i count=endpage w ##class(web.DHCSTJQUERYCOMMON).getJsonEndSign()
	k ^TMP("DHCST","web.DHCSTCNTSOUTMONITOR","jsQueryDispConfirmList",pid)
	q ""
ErrorGetDispConfirmList
	k ^TMP("DHCST","web.DHCSTCNTSOUTMONITOR","jsQueryDispConfirmList",pid)
	s Error=$$Error^DHCSTERROR()
	q Error
}

/// creator:yunhaibao
/// createdate:20160823
/// description:统计当天某药房配药人的配药数,按配药日期
/// w ##class(web.DHCOUTPHA.DispConfirm).RankOfDispConfirm("308^4")
ClassMethod RankOfDispConfirm(params)
{
	s rankcount=10
	s ctloc=$p(params,"^",1)
	s guser=$p(params,"^",2)
	s phl=$o(^DHCPHLOCi("LOC",ctloc,""))
	q:(ctloc="")||(guser="")||(phl="") ##class(web.DHCSTJQUERYCOMMON).getJsonEmptySign(0) 
	s pid=..NewPid()
	s pydate=+$h //今天啊
	s phdrow=""
	f  s phdrow=$o(^DHCPHDISPi(pydate,phl,phdrow)) q:phdrow=""  d 
	.s pyperson=+$p(^DHCPHDISP(phdrow,1),"^",3)
	.q:pyperson=0
	.s pyuser=+$p(^DHCPHPER(pyperson),"^",5)
	.i $d(^TMP("DHCST","web.DHCOUTPHA.DispConfirm","RankOfDispConfirm",pid,pyuser)) d
	..s $p(^TMP("DHCST","web.DHCOUTPHA.DispConfirm","RankOfDispConfirm",pid,pyuser),"^",1)=$p(^TMP("DHCST","web.DHCOUTPHA.DispConfirm","RankOfDispConfirm",pid,pyuser),"^",1)+1
	.e  d
	..s ^TMP("DHCST","web.DHCOUTPHA.DispConfirm","RankOfDispConfirm",pid,pyuser)=1
	s pyuser=""
	f  s pyuser=$o(^TMP("DHCST","web.DHCOUTPHA.DispConfirm","RankOfDispConfirm",pid,pyuser)) q:pyuser=""  d
	.s count=+^TMP("DHCST","web.DHCOUTPHA.DispConfirm","RankOfDispConfirm",pid,pyuser)
	.q:+count=0
	.s ^TMP("DHCST","web.DHCOUTPHA.DispConfirm","RankUserOfDispConfirm",pid,count,pyuser)="" //存在并列
	s includeme=""
	s Title="id^name^count"
	s countrecords=0
	s outputi=""
	f  s outputi=$o(^TMP("DHCST","web.DHCOUTPHA.DispConfirm","RankUserOfDispConfirm",pid,outputi),-1) q:(outputi="")||(countrecords>10)  d
	.s outputj=""
	.f  s outputj=$o(^TMP("DHCST","web.DHCOUTPHA.DispConfirm","RankUserOfDispConfirm",pid,outputi,outputj),-1) q:(outputj="")||(countrecords>10)  d
	..s countrecords=countrecords+1 
	..q:countrecords>rankcount
	..s pyuser=+outputj
	..s count=+outputi
	..i $d(^SSU("SSUSR",pyuser))  s pyusername=$p($g(^SSU("SSUSR",pyuser)),"^",2)
	..e  s pyusername="未知"
	..//i pyusername["DHC" s pyusername="东华测试用"
	..s data=pyuser_"^"_pyusername_"^"_count
	..i countrecords=1 d
	...w ##class(web.DHCSTJQUERYCOMMON).GetJsonStartString(rankcount)
	...W ##class(web.DHCSTJQUERYCOMMON).getJsonData(Title,data)
	..e  d
	...W ","_##class(web.DHCSTJQUERYCOMMON).getJsonData(Title,data)
	..i pyuser=guser s includeme=1 
	//登录人计数
	i includeme="" d
	.s mecount=+$g(^TMP("DHCST","web.DHCOUTPHA.DispConfirm","RankOfDispConfirm",pid,guser))
	.s mename=$p($g(^SSU("SSUSR",guser)),"^",2)
	.s data=guser_"^"_mename_"^"_mecount
	.i countrecords>0 d
	..W ","_##class(web.DHCSTJQUERYCOMMON).getJsonData(Title,data)
	.e  d
	..w ##class(web.DHCSTJQUERYCOMMON).GetJsonStartString(rankcount)
	..W ##class(web.DHCSTJQUERYCOMMON).getJsonData(Title,data)
	w ##class(web.DHCSTJQUERYCOMMON).getJsonEndSign()
	k ^TMP("DHCST","web.DHCOUTPHA.DispConfirm","RankOfDispConfirm",pid)
	k ^TMP("DHCST","web.DHCOUTPHA.DispConfirm","RankUserOfDispConfirm",pid)
	q ""
}

ClassMethod NewPid()
{
	q $i(^DHCOUTPHA("web.DHCOUTPHA.DispConfirm"))
}

}
