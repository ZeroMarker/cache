Class web.DHCIPBillInvDepCollect Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：      Lid
/// CreatDate：    2009-04-25
/// Description:： 
/// Table：        dhc_sfprintdetails,
/// Input：        stDate:开始日期，endDate:结束日期,user:收款员ID
/// Output：        
/// Return：        
/// Others：       
ClassMethod FindInvDepNoExecute(ByRef qHandle As %Binary, stDate, endDate, skuserid) As %Status
{
	;w ##class(%ResultSet).RunQuery("web.DHCIPBillInvDepCollect","FindInvDepNo","61501","61501","5575")
	S repid=$I(^CacheTemp)
 	s ind=1
    k ^TMP("IPBIL","InvDepNOPrt",$j)
    k ^TMP("IPBILL","UserID",$j)
    i skuserid="" s flag="0"
    e  s flag="1"
    s stDate=stDate-1
    b
    f  s stDate=$o(^DHCJFUSERJK(0,"date",stDate)) q:(stDate="")!(stDate>endDate)  d
    .s jkDr=""
    .f  s jkDr=$o(^DHCJFUSERJK(0,"date",stDate,jkDr)) q:jkDr=""  d
    ..q:'$d(^DHCJFUSERJK(0,"date",stDate,jkDr))
    ..s str=^DHCJFUSERJK(jkDr)
    ..s userid=$p(str,"^",5)
    ..q:(flag=1)&(userid'=skuserid)   ;按收款员查找
    ..s userName=$p(^SSU("SSUSR",userid),"^",2)
    ..s jkdate=$p(str,"^",1)
	..s jktime=$p(str,"^",2)
    ..s DepNOInfo=$p(str,"^",13)
    ..s StrikeDepNO=$p(str,"^",14)
    ..s AbortDepNO=$p(str,"^",15)
    ..s DepNum=$p(str,"^",16)
    ..s StrikeDepNum=$p(str,"^",17)
    ..s AbortDepNum=$p(str,"^",18)
    ..s InvNOInfo=$p(str,"^",19)
    ..s StrikeInvNO=$p(str,"^",20)
    ..s AbortInvNO=$p(str,"^",21)
    ..s InvNum=$p(str,"^",22)
    ..s StrikeInvNum=$p(str,"^",23)
    ..s AbortInvNum=$p(str,"^",24)
    ..D OutPut
    S qHandle=$lb(0,repid,0)
    Q $$$OK
OutPut() 
	s num=1
	i '$d(^TMP("IPBIL","InvDepNOPrt",$j,userid))  d
	.s ^TMP("IPBIL","InvDepNOPrt",$j,userid,num)=$zd(jkdate,3)_" "_$zt(jktime,4)_"^"_userName_"^"_DepNOInfo_"^"_DepNum_"^"_StrikeDepNO_"^"_StrikeDepNum_"^"_AbortDepNO_"^"_AbortDepNum_"^"_InvNOInfo_"^"_InvNum_"^"_StrikeInvNO_"^"_StrikeInvNum_"^"_AbortInvNO_"^"_AbortInvNum
    e  d
    .s num=$o(^TMP("IPBIL","InvDepNOPrt",$j,userid,""),-1)+1
    .s ^TMP("IPBIL","InvDepNOPrt",$j,userid,num)=$zd(jkdate,3)_" "_$zt(jktime,4)_"^"_userName_"^"_DepNOInfo_"^"_DepNum_"^"_StrikeDepNO_"^"_StrikeDepNum_"^"_AbortDepNO_"^"_AbortDepNum_"^"_InvNOInfo_"^"_InvNum_"^"_StrikeInvNO_"^"_StrikeInvNum_"^"_AbortInvNO_"^"_AbortInvNum
    
    s Data=$lb($zd(jkdate,3)_" "_$zt(jktime,4),userName,DepNOInfo,DepNum,StrikeDepNO,StrikeDepNum,AbortDepNO,AbortDepNum,InvNOInfo,InvNum,StrikeInvNO,StrikeInvNum,AbortInvNO,AbortInvNum,$j)
 	S ^CacheTemp(repid,ind)=Data
 	S ind=ind+1
	q
}

ClassMethod FindInvDepNoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindInvDepNoExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindInvDepNoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindInvDepNoExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

Query FindInvDepNo(stDate, endDate, skuserid) As %Query(ROWSPEC = "Tjkdatetime,TuserName,TDepNOInfo,TDepNum,TStrikeDepNO,TStrikeDepNum,TAbortDepNO,TAbortDepNum,TInvNOInfo,TInvNum,TStrikeInvNO,TStrikeInvNum,TAbortInvNO,TAbortInvNum,Tjob")
{
}

/// Lid
/// 2009-05-21
/// 获取打印信息记录数
/// job:进程号，userid:收款人Rowid
ClassMethod GetPrtNum(job, userid)
{
	;w ##class(web.DHCIPBillInvDepCollect).GetPrtNum("","5575")
	s num=0
	s num=$o(^TMP("IPBIL","InvDepNOPrt",job,userid,""),-1)
	q num
}

/// Lid
/// 2009-05-21
/// 获取打印记录
/// Input: job,进程号,userid:收款人Rowid,num:计数器
ClassMethod GetPrtInfo(job, userid, num)
{
	;w ##class(web.DHCIPBillInvDepCollect).GetPrtInfo("4280","5575","2")
	q:(job="")!(userid="")!(num="") ""
	s rtn=""
	i $d(^TMP("IPBIL","InvDepNOPrt",job,userid,num)) d
	.s rtn=^TMP("IPBIL","InvDepNOPrt",job,userid,num)
	q rtn
}

/// Lid 
/// 2009-05-21
/// 获取所有收费员Rowid
/// Input: job:进程号
ClassMethod GetUserID(job)
{
    ;w ##class(web.DHCIPBillInvDepCollect).GetUserID("5448")
    k ^TMP("IPBILL","Userid",job)
    s userid=""
    f  s userid=$o(^TMP("IPBIL","InvDepNOPrt",job,userid)) q:userid=""  d
    .s ^TMP("IPBILL","Userid",job,userid)=userid
    s userid="",useridStr=""
    f  s userid=$o(^TMP("IPBILL","Userid",job,userid)) q:userid=""  d
    .i useridStr="" s useridStr=^TMP("IPBILL","Userid",job,userid)
    .e  s useridStr=useridStr_"^"_^TMP("IPBILL","Userid",job,userid)

    q useridStr
}

}
