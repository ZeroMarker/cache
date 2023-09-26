Import SQLUser

Class web.DHCWMRWorkDetailCtl Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 42;

ClassMethod Update(InString)
{
	//***************************************
	//功能说明：添加或修改突发项目明细字典项(添加数据时WMRRowid设空值)
	//入参：WMRRowid^Code^Description^DateType^IsActive^Resume
	//出参：WMRRowid
	//调试：w ##class(web.DHCWMRWorkDetailCtl).Update("WMRRowid^Code^Description^DateType^IsActive^Resume")
	//****************************************
	
	n (InString)
    s WMRRowid=$p(InString,"^",1)
    s PLIST(2)=$p(InString,"^",2)      ;代码
    q:PLIST(2)="" -1
    s PLIST(3)=$p(InString,"^",3)      ;描述
    q:PLIST(3)="" -1
    s PLIST(4)=$p(InString,"^",4)      ;数据类型?如?时间?数字?
    s PLIST(5)=$s($p(InString,"^",5)["Y":"Y",1:"N") ;是否有效
    s PLIST(6)=$p(InString,"^",6)      ;备注
    s PLIST(7)=$p(InString,"^",7)      ;字典代码
    q:($d(^DHCWMRWDTL(0,"Code",PLIST(2))))&(WMRRowid="") -100
    i WMRRowid="" d
    .&sql(Insert into DHC_WMR_WorkDetail values :PLIST())
    e  d
    .&sql(Update DHC_WMR_WorkDetail values :PLIST() where Rowid=:WMRRowid)
    q:SQLCODE SQLCODE
    s ret=$p(%ROWID,$c(1))
    q ret
}

ClassMethod GetDataById(WMRRowid)
{
	//***************************************
	//功能说明：根据WMRRowid获取突发项目明细字典记录
	//入参：WMRRowid
	//出参：WMRRowid^Code^Description^DateType^IsActive^Resume
	//调试：w ##class(web.DHCWMRWorkDetailCtl).GetDataById("WMRRowid")
	//****************************************
	
	n (WMRRowid)
    q:'$d(^DHCWMRWDTL(WMRRowid)) ""
    s s=$g(^DHCWMRWDTL(WMRRowid))
    s s=WMRRowid_"^"_s
    q s
}

ClassMethod QueryDataByActiveClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryDataByActiveExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
 	Quit $$$OK
}

ClassMethod QueryDataByActiveExecute(ByRef qHandle As %Binary, Flag As %String) As %Status
{
	//***************************************
	//功能说明：根据IsActive获取突发项目明细字典记录集
	//入参：IsActive
	//出参：WMRRowid^Code^Description^DateType^IsActive^Resume
	//调试：d ##class(%ResultSet).RunQuery("web.DHCWMRWorkDetailCtl","QueryDataByActive","IsActive")
	//*****************************************
	Set repid=$I(^CacheTemp)
	s ind=1
	Set qHandle=$lb(0,repid,0)
	
	Set Config=##Class(websys.Configuration).%OpenId(1)
    Set MEDDATA=Config.DataNamespace
    Set LABDATA=Config.LabDataNamespace
    Set CurrentNS=$ZNSPACE
    d Config.%Close()
    zn MEDDATA
    s iCount=..QueryDataByActiveM(Flag) //$$QueryDataByActive^DHCWMRWorkDetail(Flag)
    s JIndex=$p(iCount,"^",2),iCount=+iCount
    zn CurrentNS
	q:iCount<0 $$$OK
	f i=0:1:iCount d
	.zn MEDDATA
	.s s=$g(^CacheTemp("WDQueryDataByActive",JIndex,i))
	.zn CurrentNS
	.d BuildData

	Quit $$$OK
BuildData
	set Data=$lb("")
 	f iBuild=1:1:$l(s,"^") d
 	.s $li(Data,iBuild)=$p(s,"^",iBuild)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod QueryDataByActiveM(Active)
{
    n (Active)
    k ^CacheTemp("WDQueryDataByActive",$j)
    
    s:Active'="" Active=$s(Active["Y":"Y",1:"N")
    s n=0
    s WMRRowid=0
    f  s WMRRowid=$o(^DHCWMRWDTL(WMRRowid)) q:WMRRowid=""  d
    .q:'$d(^DHCWMRWDTL(WMRRowid))
    .q:((Active'="")&&(Active'=$p(^DHCWMRWDTL(WMRRowid),"^",4)))
    .s ^CacheTemp("WDQueryDataByActive",$j,n)=..GetDataById(WMRRowid)
    .s n=n+1
    q n-1_"^"_$j
}

ClassMethod QueryDataByActiveFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryDataByActiveExecute ]
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

Query QueryDataByActive(Flag As %String) As %Query(ROWSPEC = "Rowid:%String,Code:%String,Description:%String,DataType:%String,IsActive:%String,Resume:%String,DicCode:%String")
{
}

ClassMethod QueryDataByActiveLIST(Flag)
{
	//***************************************
	//功能说明：根据IsActive获取突发项目明细字典记录集字串
	//          $c(1)分割记录，“^”分割字段
	//入参：IsActive
	//出参：WMRRowid^Code^Description^DateType^IsActive^Resume
	//调试：w ##class(web.DHCWMRWorkDetailCtl).QueryDataByActiveLIST("IsActive")
	//****************************************
	n (Flag)
	
    s iCount=..QueryDataByActiveM(Flag)
    s JIndex=$p(iCount,"^",2),iCount=+iCount
	q:iCount<0 $$$OK
	f i=0:1:iCount d
	.s j=i+1
	.s $p(s,$c(1),j)=$g(^CacheTemp("WDQueryDataByActive",JIndex,i))
	q s
}

ClassMethod QuerySimplyClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QuerySimplyExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
 	Quit $$$OK
}

ClassMethod QuerySimplyExecute(ByRef qHandle As %Binary, Active As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	Set qHandle=$lb(0,repid,0)
	
	s rowid="0"
	f  s rowid=$o(^DHCWMRWDTL(rowid)) q:rowid=""  d
	.s s=$g(^DHCWMRWDTL(rowid))
	.q:$p(s,"^",4)'=Active
	.s desc=$p(s,"^",2)
	.s Data=$lb(+rowid,desc)
 	.s ^CacheTemp(repid,ind)=Data
 	.s ind=ind+1
	
	Quit $$$OK
}

ClassMethod QuerySimplyFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QuerySimplyExecute ]
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

/// 按照有效标志查询 rowid与描述
/// by wuqk 2007－05－15
Query QuerySimply(Active As %String) As %Query(ROWSPEC = "Rowid:%String,Desc:%String")
{
}

}
