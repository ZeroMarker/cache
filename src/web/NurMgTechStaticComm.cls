/// Creator:gzj
/// Date:2019-04-16
/// Descrption:20项护理技术统计
Class web.NurMgTechStaticComm Extends %RegisteredObject
{

/// Writter:gzj
/// Date:2019-04-16
/// Description:保存护理技术项目
/// Table:
/// Input:
/// Output:
/// Return:
/// Other:
ClassMethod SaveTechItem(parr As %String) As %String
{
	s ^TMP("SaveTechItem")=parr
	//TechItem|俯卧位通气技术^TechCode|俯卧位通气技术^RowID|
	s tmp=""
	s aa=##class(web.NurMgVueComm).SplitStr(parr,"^","|",.tmp)
	s id=$g(tmp("RowID"))
	s flag=..IsTechExist(parr)
	q:flag=1 "此代码已经存在"
	i id'="" s obj=##class(DHCNMG.Work.MgNurTechItem).%OpenId(id)
	e  s obj=##class(DHCNMG.Work.MgNurTechItem).%New()
	s obj.TechCode=$zcvt($tr($g(tmp("TechCode"))," ",""),"U")
	s obj.TechItem=$zcvt($tr($g(tmp("TechItem"))," ",""),"U")
	s obj.TechState="Y"
	s sc=obj.%Save()
	q $$$ISOK(sc)
}

/// Writter:gzj
/// Date:2019-04-16
/// Description:判断记录是否存在
/// Table
/// Other:w ##class(web.NurMgTechStaticComm).IsTechExist("TechItem|俯卧位通气技术^TechCode|俯卧位通气技术^RowID|")
ClassMethod IsTechExist(parr As %String) As %String
{
	s tmp=""
	s flag=0
	s aa=##class(web.NurMgVueComm).SplitStr(parr,"^","|",.tmp)
	s id=$g(tmp("RowID"))
	s code=$zcvt($tr($g(tmp("TechCode"))," ",""),"U")
	s rw=$o(^DHCNMG.Work.MgNurTechItemI("flag"," Y"," "_code,""))
	i rw'="" d
	.i ((id'="")&&(id'=rw)) s flag=1
	.e  i (id="") s flag=1
	q flag
}

/// Creator:gzj
/// Description:获取护理技术项目列表
/// Date:2019-04-16
/// Table: 
/// Input:
/// Output：
/// Return:
/// Others: d ##class(%ResultSet).RunQuery("web.NurMgTechStaticComm","FindTechItemList","")
Query FindTechItemList(parr As %String) As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindTechItemListExecute(ByRef qHandle As %Binary, parr As %String) As %Status
{
	s ^TMP("FindTechItemList")=parr
	s repid=$I(^CacheTemp)
	s ind=1
	s desc=$zcvt($tr($p(parr,"^",1)," ",""),"U")
	s flag=$p(parr,"^",2)
	s ret=""
	s state="" f  s state=$o(^DHCNMG.Work.MgNurTechItemI("flag",state)) q:state=""  d
	.q:((flag'="")&&($tr(state," ","")'=flag))
	.s code="" f  s code=$o(^DHCNMG.Work.MgNurTechItemI("flag",state,code)) q:code=""  d
	..s RowID="" f  s RowID=$o(^DHCNMG.Work.MgNurTechItemI("flag",state,code,RowID)) q:RowID=""  d
	...s obj=##class(DHCNMG.Work.MgNurTechItem).%OpenId(RowID)
	...q:'$IsObject(obj)
	...s TechCode=obj.TechCode
	...s TechDesc=obj.TechItem
	...q:((desc'="")&&(TechDesc[desc))
	...s TechState=""
	...i obj.TechState="Y" s TechState="有效"
	...e  i obj.TechState="N" s TechState="作废"
	...s ret="TechCode|"_TechCode_"^TechDesc|"_TechDesc_"^RowID|"_RowID_"^TechState|"_TechState_"^StateCode|"_obj.TechState
	...do OutputTechItem
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputTechItem
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindTechItemListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindTechItemListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else  {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindTechItemListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindTechItemListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

}
