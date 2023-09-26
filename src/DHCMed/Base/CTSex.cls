/// 名称: DHCMed.Base.CTSex
/// 描述: 性别表（CT_Sex）的业务封装，定义常用属性和方法
/// 编写者：zhufei
/// 编写日期: 2013-12-18
Class DHCMed.Base.CTSex Extends (%Persistent, DHCMed.Abstract) [ ClassType = "", Not ProcedureBlock ]
{

/// CT_Sex.ID
Property CTSexID As %Integer;

/// 代码
Property CTSexCode As %String(TRUNCATE = 1);

/// 描述
Property CTSexDesc As %String(TRUNCATE = 1);

/// Creator：     zhufei
/// CreatDate：   2013-12-18
/// Description:  根据ID取性别信息
/// Table：       CT_Sex
/// Input：       id : CT_Sex.ID
/// Return：      返回obj
/// Others：   
/// w ##class(DHCMed.Base.CTSex).GetObjById(1)
ClassMethod GetObjById(Id As %String) As DHCMed.Base.CTSex
{
	new (Id)
	set return=""
	quit:Id="" return
	
	quit:'$d(^CT("SEX",Id)) return
	
	set obj=##Class(DHCMed.Base.CTSex).%New()
	set obj.CTSexID=+Id
	set obj.CTSexCode=$p($g(^CT("SEX",Id)),"^",1)
	set obj.CTSexDesc=$p($g(^CT("SEX",Id)),"^",2)
	set return=obj
	do obj.%Close()
	
	quit return
}

/// 查询性别字典
/// d ##Class(%ResultSet).RunQuery("DHCMed.Base.CTSex","QryCTSex")
Query QryCTSex() As %Query(ROWSPEC = "CTSexID:%String,CTSexCode:%String,CTSexDesc:%String")
{
}

ClassMethod QryCTSexExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Set xID=0
	For {
		Set xID=$o(^CT("SEX",xID))
		Quit:xID=""
		Set obj=..GetObjById(xID)
		Continue:'$IsObject(obj)
		Set Code=obj.CTSexCode
		Set Desc=obj.CTSexDesc
		Set Data=$lb(xID,Code,Desc)
		Set ^CacheTemp(repid,ind)=Data
    	Set ind=ind+1
	}
	
    Quit $$$OK
}

ClassMethod QryCTSexFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryCTSexExecute ]
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

ClassMethod QryCTSexClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryCTSexExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

}
