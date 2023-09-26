/// Description:送药科室维护查询相关
/// Creator:    hulihua
/// CreateDate: 2016-09-08
/// Table:      DHC_PHSendLoc
Class web.DHCINPHA.MTSendLoc.SendLocQuery Extends (%RegisteredObject, websys.Abstract) [ ClassType = "", Not ProcedureBlock ]
{

/// Description:保存送药科室信息
/// Creator:	hulihua
/// CreateDate:	2016-09-08
/// Table:      DHC_PHSendLoc
/// Input:
/// Output:
/// Return：    成功:rowid
/// -1,	药房科室为空
/// -2,	病区科室为空
/// -3,	已经存在送药关系
/// -4,	操作表失败
/// w ##class(web.DHCINPHA.MobileMTSendLoc.SendLocQuery).Save("","98^102")
ClassMethod Save(PhslId As %String, Input As %String) As %Library.String
{
	n (PhslId,Input)
    s PhLocId=$p(Input,"^",1)
    q:+PhLocId=0 -1
    s WardLocId=$p(Input,"^",2)
    q:+WardLocId=0 -2
    q:$d(^DHCPHSLi("PHLOC",PhLocId,WardLocId)) -3
 	i PhslId=""  d
 	.s ret=##class(web.DHCINPHA.MTSendLoc.SqlDbSendLoc).Insert(Input)
 	e  d
 	.s ret=##class(web.DHCINPHA.MTSendLoc.SqlDbSendLoc).Update(PhslId,Input)
 	.i ret=0  d
 	..s ret=PhslId
 	.
 	q:ret<0 -4
 	q ret
}

/// Description:更新送药标志
/// Creator:	hulihua
/// CreateDate:	2017-04-20
/// Table:      DHC_PHSendLoc
/// Input:
/// Output:
/// Return：    成功:0
/// -1,	病区无关联关系
/// -2,	未选择是否送药
/// -3,	操作表失败
/// w ##class(web.DHCINPHA.MTSendLoc.SendLocQuery).UpdateSendFlag("2","Y")
ClassMethod UpdateSendFlag(PhslId As %String, Input As %String) As %Library.String
{
	n (PhslId,Input)
	q:+PhslId=0 -1
    s SendFlag=Input
    q:SendFlag="" -2
 	s ret=##class(web.DHCINPHA.MTSendLoc.SqlDbSendLoc).UpdateSendFlag(PhslId,SendFlag)
 	q:ret<0 -3
 	q ret
}

/// Description:更新病区送药频率相关信息
/// Creator:	hulihua
/// CreateDate:	2017-08-30
/// Table:      DHC_PHSendLoc
/// Input:		送药科室关联ID,送药频次描述、频次系数
/// Output:
/// Return：    成功:0
/// -1,	病区无关联关系
/// -2,	送药频次信息为空
/// -3,	操作表失败
/// w ##class(web.DHCINPHA.MTSendLoc.SendLocQuery).UpdateSendFlag("2","Y")
ClassMethod UpdateSendFreqInfo(Input As %String) As %Library.String
{
	n (Input)
	s PhslId=$p(Input,"^",1)
	q:+PhslId=0 -1
    s SendFreqDesc=$p(Input,"^",2)
    s SendFreqFactor=$p(Input,"^",3)
    s SendFactor=$p(Input,"^",4)
    s WardQue=$p(Input,"^",5)
    q:(SendFreqDesc="")&&(SendFreqFactor="")&&(SendFactor="")&&(WardQue="") -2
 	s ret=##class(web.DHCINPHA.MTSendLoc.SqlDbSendLoc).UpdateSendFreq(Input)
 	q:ret<0 -3
 	q ret
}

/// Description:查询送药科室信息
/// Creator:	hulihua
/// CreateDate:	2016-09-12
/// Table:      DHC_PHSendLoc
/// Input:
/// Output:
/// Return：    
/// w ##class(web.DHCINPHA.MTSendLoc.SendLocQuery).GetSendLocList("","","94")
ClassMethod GetSendLocList(rows, page, params) As %Integer
{
	 n (rows, page,params)
     i $g(page)="" s page=1
     i $g(rows)="" s rows=50
     
	 s End = page*rows
	 s Start=(page-1)*rows+1
	 s phalocdr=$p(params,"^",1)
	 S pid=##class(web.DHCINPHA.MTCommon.CommonUtil).NewPid("web.DHCINPHA.MTSendLoc.SendLocQuery")
	 d ##class(web.DHCINPHA.MTCommon.CommonUtil).ClearTmp("web.DHCINPHA.MTSendLoc.SendLocQuery","GetSendLocList",pid)
	 s n=0
	 s wardlocdr="" 
	 f  s wardlocdr=$o(^DHCPHSLi("PHLOC",phalocdr,wardlocdr)) q:wardlocdr=""  d
	 .s rowid=$o(^DHCPHSLi("PHLOC",phalocdr,wardlocdr,""),-1)
	 .s wardloc=$p(^CTLOC(wardlocdr),"^",2)
	 .s sendflag=$p(^DHCPHSL(rowid),"^",3) 
	 .s sendfreqdesc=$p(^DHCPHSL(rowid),"^",4)
	 .s sendfreqfac=$p(^DHCPHSL(rowid),"^",5)
	 .s sendfactor=$p(^DHCPHSL(rowid),"^",6)
	 .s wardque=$p(^DHCPHSL(rowid),"^",7)  
	 .s n=n+1
	 .s data=$g(rowid)_"^"_$g(wardlocdr)_"^"_$g(wardloc)_"^"_$g(sendflag)_"^"_$g(sendfreqdesc)_"^"_$g(sendfreqfac)_"^"_$g(sendfactor)_"^"_$g(wardque)
	 .s ^TMP("DHCINPHA","web.DHCINPHA.MTSendLoc.SendLocQuery","GetSendLocList",pid,n)=data
     q:n=0 ##class(web.DHCINPHA.MTCommon.JQueryCommon).getJsonEmptySign(n) //输出空的json串
     w ##class(web.DHCINPHA.MTCommon.JQueryCommon).getJsonStartSign(n) //输出json前缀串

     s maxrow=n
     s count=0
     s Title="rowid^WardLocDr^WardLoc^Tselect^TSendFreqDesc^TSendFreqFactor^TSendFactor^TWardQue"
     s h=""
     f  s h=$o(^TMP("DHCINPHA","web.DHCINPHA.MTSendLoc.SendLocQuery","GetSendLocList",pid,h)) q:h=""  d
     .s mdata=^TMP("DHCINPHA","web.DHCINPHA.MTSendLoc.SendLocQuery","GetSendLocList",pid,h)
     .s count = count+1
	 .q:(count<Start)||(count>End)
	 .I count=Start d
	 ..w ##class(web.DHCINPHA.MTCommon.JQueryCommon).getJsonData(Title,mdata)
	 .e  d
	 ..w ","_##class(web.DHCINPHA.MTCommon.JQueryCommon).getJsonData(Title,mdata)
	
	 w ##class(web.DHCINPHA.MTCommon.JQueryCommon).getJsonEndSign() //输出json结尾符
	 d ##class(web.DHCINPHA.MTCommon.CommonUtil).ClearTmp("web.DHCINPHA.MTSendLoc.SendLocQuery","GetSendLocList",pid)
     q ""
}

}
