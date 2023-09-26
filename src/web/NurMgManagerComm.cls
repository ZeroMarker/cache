/// Creator:
/// Descriptions:管理员维护
/// Date:2018-01-10
/// 
Class web.NurMgManagerComm Extends %RegisteredObject
{

/// Creator:
/// Description:保存管理员信息
/// Date:2018-01-10
/// Table:
/// input:
/// output:
/// other:
ClassMethod SaveManageData(parr As %String) As %String
{
	;s ^TMP("savemanagedata")=parr
	//PerID|gly001^PerName|管理员^RowID|
	s tmp=""
	s aa=##class(web.NurMgVueComm).SplitStr(parr,"^","|",.tmp)
	s id=$g(tmp("RowID"))
	s ssno=$g(tmp("PerID"))
	s flag=..IsExistNo(ssno,id)
	q:flag=1 "此工号已经存在"
	;q:((id'="")&&(flag=1))
	
	i id="" s obj=##class(DHCNMG.HR.MgPersons).%New()
	e  s obj=##class(DHCNMG.HR.MgPersons).%OpenId(id)
	s obj.PerID=$zcvt($tr($g(tmp("PerID"))," ",""),"U")
	s obj.PerName=$tr($g(tmp("PerName"))," ","")
	s obj.PerTypeDR="M"
	s obj.RecUser=$g(tmp("RecUser"))
	i tmp("RowID")="" s obj.PerPassword=##class(web.SSUser).Encrypt("1")
	s sc=obj.%Save()
	
	q $$$ISOK(sc)
}

/// Creator:
/// Description:判断工号是否存在
/// Date:2018-01-10
/// Table:
/// input:
/// output:
/// other:
ClassMethod IsExistNo(ssno As %String, id As %String) As %String
{
	s flag=0
	s rowid=$O(^DHCNMG.HR.MgPersonsI("PerID"," "_$zcvt($tr(ssno," ",""),"U"),""))
	b ;01
	i ((rowid'="")&&(rowid'=id)) s flag=1
	e  i ((rowid'="")&&(rowid=id)) s flag=-1
	q flag
}

/// Creator:guozj
/// Description:查询管理员信息
/// Date:2018-01-10
/// Table:
/// Input:
/// Output：
/// Return:
/// Others: w ##class(%ResultSet).RunQuery("web.NurMgManagerComm","FindManageList","M")
Query FindManageList(Type As %String = "") As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindManageListExecute(ByRef qHandle As %Binary, Type As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ret=""
	s type="" f  s type=$O(^DHCNMG.HR.MgPersonsI("type",type)) q:type=""  d
	.q:((Type'="")&&($tr(type," ","")'=Type))
	.s rowid="" f  s rowid=$O(^DHCNMG.HR.MgPersonsI("type",type,rowid)) q:rowid=""  d
	..s obj=##class(DHCNMG.HR.MgPersons).%OpenId(rowid)
	..s PerID=obj.PerID
	..s PerName=obj.PerName
	..s ret="PerID|"_PerID_"^PerName|"_PerName_"^RowID|"_rowid
	..do OutputManagelist
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputManagelist
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindManageListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindManageListExecute ]
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

ClassMethod FindManageListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindManageListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetManageData(id As %String) As %String
{
	s ret=""
	q:id="" ""
	s obj=##class(DHCNMG.HR.MgPersons).%OpenId(id)
	s PerName=obj.PerName
	s PerID=obj.PerID
	s ret="PerName|"_PerName_"^PerID|"_PerID_"^RowID|"_id
	q ret
}

}
