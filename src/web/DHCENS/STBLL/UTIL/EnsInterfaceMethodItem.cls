Class web.DHCENS.STBLL.UTIL.EnsInterfaceMethodItem Extends (%RegisteredObject, %XML.Adaptor)
{

/// Creator：WuXianPu
/// CreatDate：2015—01-07
/// Description：方法列表信息查询
/// Table：User.EnsInterfaceMethod
/// Input：id,code,desc,productionName,status,hisVersion
/// Output：返回符合条件的方法列表
/// Return：
/// Others：d ##class(%ResultSet).RunQuery("web.DHCENS.Method.EnsInterfaceMethodItem","GetEnsInterfaceMethodItem","19")
Query GetEnsInterfaceMethodItem(Input As %String) As %Query(ROWSPEC = "id:%String,code:%String,type:%String")
{
}

ClassMethod GetEnsInterfaceMethodItemExecute(ByRef QHandle As %Binary, Input As %String) As %Status
{
	set repid=$I(^CacheTemp)
	set ind=1
	set rowId=$p(Input,"^",1)
	set QHandle=$lb(0,repid,0)
	set subId=""  for  set subId=$o(^User.EnsInterfaceMethodD(subId)) q:subId=""  d
	.Quit:rowId=subId
	.set code=$lg(^User.EnsInterfaceMethodD(subId),2)
	.if $d(^User.EnsInterfaceMethodItemI("MethodCode",rowId,subId))="0"  d
	..set type="left"
	..set ^CacheTemp(repid,ind)=$lb(subId,code,type)
	.else  d
	..set type="right"
	..set ^CacheTemp(repid,ind)=$lb(subId,code,type)
	.set ind=ind+1
	Quit $$$OK
}

ClassMethod GetEnsInterfaceMethodItemClose(ByRef QHandle As %Binary) As %Status [ PlaceAfter = GetEnsInterfaceDataExecute ]
{
	Set repid=$LIST(QHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod GetEnsInterfaceMethodItemFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetEnsInterfaceDataExecute ]
{
	Set AtEnd=$LIST(QHandle,1)
 	Set repid=$LIST(QHandle,2)
 	Set ind=$LIST(QHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	Set QHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// w ##class(web.DHCENS.Method.EnsInterfaceMethodItem).SaveEnsInMethodItem("19#20^25")
ClassMethod SaveEnsInMethodItem(Input As %String) As %String
{
	set $zt="Exception"
	set parentId=$p(Input,"@",1)
	set childId=$p(Input,"@",2)
	set length=$l(childId,"^")
	set id="" for  set id=$o(^User.EnsInterfaceMethodItemD(parentId,id)) q:id=""  d
	.set sc=##class(User.EnsInterfaceMethodItem).%DeleteId(parentId_"||"_id)
	for i=1:1:length {
		set id=$p(childId,"^",i)
		if $d(^User.EnsInterfaceMethodItemI("MethodCode",parentId,id))="0" {
			set parentObj=##class(User.EnsInterfaceMethod).%OpenId(parentId)
			set childObj=##class(User.EnsInterfaceMethod).%OpenId(id)
			set obj=##class(User.EnsInterfaceMethodItem).%New()
			set obj.EnsMethdItemRef=parentObj
			set obj.childMethodDr=childObj
			set sc=obj.%Save()
		}
		else {
			set sc=1
		}
	}
	Quit sc
Exception
	Quit "-1^"_$ze
}

}
