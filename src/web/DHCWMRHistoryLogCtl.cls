Import SQLUser

/// 病案历史修改日志
/// By LiYang 2009-11-30
Class web.DHCWMRHistoryLogCtl Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 67;

/// 
/// MainID: 
ClassMethod Update(MainID, new, newList, UserID)
{
	n (MainID,new,newList,UserID)
	q:new="" -1
	q:MainID="" -2
	s strMainData=$g(^DHCWMRMAIN(MainID))
	s content=""
	s old=$g(^DHCWMRHISTORY(+$p(strMainData,"^",4)))
	q:old="" -3
	s old=$p(strMainData,"^",4)_"^"_old
	s fieldList="^病人姓名^姓名拼音码^性别^生日^年龄^婚姻^职业^出生市^出生县^民族^国籍^身份证号^工作单位^工作单位电话^工作单位邮编^家庭住址^家庭电话^家庭邮编^与联系人关系^联系人^联系人电话^联系人地址^"
	f i=2:1:$l(fieldList,"^")  d
	.i $p(old,"^",i)'=$p(new,"^",i)  d
	..s:content="" content="病人基本信息部分："_$c(13)_$c(10)
	..s:i>2 content=content_";"  //modified By LiYang 2010-02-22 通过计数器添加分隔符
	..s content=content_$p(fieldList,"^",i)_":"
	..s content=content_"从'"_$p(old,"^",i)_"'修改为'"_$p(new,"^",i)_"'"_$c(13)_$c(10)
	
	s cnt=0
	s fieldList="^历史基本信息^就诊日期^就诊时间^就诊科室^就诊时状态^出院日期^出院时间^出院科室^诊断^是否有效^备注^"
	f row=1:1:$l(newList,$c(1))  d
	.s newRow=$p(newList,$c(1),row)
	.q:newRow=""
	.s oldVolID=$p(newRow,"^",1)
	.i oldVolID=""  d
	..;新数据，不需要每个字段进行匹配比较
	..s:cnt=0 content=content_"病人就诊信息部分："_$c(13)_$c(10)
	..s cnt=cnt+1
	..s content=content_"新数据行:"
	..f j=2:1:$l(newRow,"^")  d
	...s content=content_$p(fieldList,"^",j)_":"
	...s content=content_$p(newRow,"^",j)_";"_$c(13)_$c(10)
	..s content=content_$c(13)_$c(10)
	.e  d
	..s volData=$g(^DHCWMRVOL(oldVolID))
	..s oldRow="^"_$g(^DHCWMRHISADM(+$p(volData,"^",3)))
	..s:$p(oldRow,"^",3)'="" $p(oldRow,"^",3)=$zd($p(oldRow,"^",3),3) 
	..s:$p(oldRow,"^",7)'="" $p(oldRow,"^",7)=$zd($p(oldRow,"^",7),3) 
	..s ^CacheTemp("AAA",row)=newRow
	..f i=3:1:$l(fieldList,"^")  d
	...q:i=6
	...q:i=11
	...q:i=12
	...s newValue=$p(newRow,"^",i)
	...s oldValue=$p(oldRow,"^",i)
	...i newValue'=oldValue  d
	....s cnt=cnt+1
	....s:cnt=0 content=content_"病人就诊信息部分："_$c(13)_$c(10)
	....s content=content_$p(fieldList,"^",i)_":"
	....s content=content_"从'"_oldValue_"'修改为'"_newValue_"';"_$c(13)_$c(10)
	
	s data=""
	s $p(data,"^",1)=""
	s $p(data,"^",2)=MainID
	s $p(data,"^",3)=UserID
	s $p(data,"^",4)=+$h
	s $p(data,"^",5)=$p($h,",",2)
	s $p(data,"^",6)=$s(content="":"无修改",1:content)
	
	s ret=..UpdateM(data)
	q ret
}

ClassMethod UpdateM(Instring)
{
	n (Instring)
	s RowID=$p(Instring,"^",1)      ;MEPD_Rowid
    s PLIST(2)=$p(Instring,"^",2)      ;MRMainID
    s PLIST(3)=$p(Instring,"^",3)      ;ModifyUser
    s PLIST(4)=$p(Instring,"^",4)      ;ModifyDate
    s:PLIST(4)["-" PLIST(4)=$zd(PLIST(4),3)
    s PLIST(5)=$p(Instring,"^",5)      ;ModifyTime
    s:PLIST(5)[":" PLIST(5)=$zt(PLIST(5))
    s PLIST(6)=$p(Instring,"^",6)      ;ModifyContent
    
    i RowID="" d
    .&sql(insert into DHC_WMR_HistoryLog values :PLIST())
    e  d
    .&sql(update DHC_WMR_HistoryLog values :PLIST() where RowID=:RowID)
    q:SQLCODE SQLCODE
    s ret=$p(%ROWID,$c(1))
    q ret
}

Query LogQuery(MainID As %String) As %Query(ROWSPEC = "ModifyDate:%String:修改日期,ModifyTime:%String:修改时间,ModifyUser:%String:修改人,ModifyContent:%String:修改内容")
{
}

ClassMethod LogQueryExecute(ByRef qHandle As %Binary, MainID As %String) As %Status
{
    Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	q:MainID="" $$$OK
	s rowid="" f  s rowid=$o(^DHCWMRHistoryLog(0,"MrMainID",MainID,rowid)) q:rowid=""  d
	.s log=$g(^DHCWMRHistoryLog(rowid))
	.q:log=""
	.s data=$lb("")
	.s usr=$g(^SSU("SSUSR",+$p(log,"^",2)))
	.s usrData=$p(usr,"^",1)_"  "_$p(usr,"^",2)
	.s $li(data,1)=$zd($p(log,"^",3),3)
	.s $li(data,2)=$zt($p(log,"^",4),1)
	.s $li(data,3)=usrData
	.s $li(data,4)=$p(log,"^",5)
	.s ^CacheTemp(repid,ind)=data
	.s ind=ind+1
	
 	Quit $$$OK
}

ClassMethod LogQueryClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = LogQueryExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
 	Quit $$$OK
}

ClassMethod LogQueryFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = LogQueryExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

}
