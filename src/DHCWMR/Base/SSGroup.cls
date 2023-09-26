/// 名称: DHCWMR.Base.SSGroup
/// 描述: 安全组表（SS_Group）的业务封装，定义常用属性和方法
/// 编写者：wuqk
/// 编写日期: 2010-03-31
Class DHCWMR.Base.SSGroup Extends (%Persistent, DHCWMR.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

/// 安全组Id  SSGRP_RowID
Property Rowid As %Integer;

/// 安全组描述 SSGRP_Desc
Property Descs As %String(TRUNCATE = 1);

/// Creator：     wuqk
/// CreatDate：   2010-03-31
/// Description:  将对象格式化为字符串
/// Table：       
/// Input：       separete:指定的分隔符
/// Return：      返回各属性值，按照separete分隔
///               1:Rowid 2:Desc
Method ToString(separete As %String) As %String
{
	if $g(separete)=""{
		set separete=..#SEPARATE
		} 
	set return=..Rowid_separete_..Descs
	quit return
}

/// Creator：     wuqk
/// CreatDate：   2010-03-31
/// Description:  根据SS_Group.SSGRP_RowID取安全组
/// Table：       SS_Group
/// Input：       groupId:    SS_Group.SSGRP_RowID
/// Return：      返回obj
/// Others：       
ClassMethod GetObjById(groupId As %String) As %String
{
	new (groupId)
	set return=""
	quit:groupId="" return
	quit:'$d(^SSU("SSGRP",+groupId)) return
	set obj=##Class(DHCWMR.Base.SSGroup).%New()
	set obj.Rowid=+groupId
	set obj.Descs=$p($g(^SSU("SSGRP",+groupId)),"^",1)   // 安全组描述 SSGRP_Desc
	set return=obj
	do obj.%Close()
	quit return
}

/// Creator：     wuqk
/// CreatDate：   2010-03-31
/// Description:  根据SS_Group.SSGRP_RowID取安全组
/// Table：       SS_Group
/// Input：       groupId:    SS_Group.SSGRP_RowID
///               separete: 指定的分隔符
/// Return：      返回obj.ToString()
/// w ##class(DHCWMR.Base.SSGroup).GetStringById(1)
ClassMethod GetStringById(groupId As %String, separete As %String) As %String
{
	new (groupId,separete)
	set return=""
	set obj=..GetObjById(groupId)
	if $IsObject(obj){
		set return=obj.ToString($g(separete))
	}	
	quit return
}

/// Creator：     wuqk
/// CreatDate：   2010-03-31
/// Description:  查询所有安全组
/// Table：       SS_Group
/// Input：       
/// Return：      tree需要的ResultSet
/// do ##class(%ResultSet).RunQuery("DHCWMR.Base.SSGroup","QueryAllForTree")
Query QueryAllForTree() As %Query(ROWSPEC = "id:%String,text:%String,leaf:%String,checked:%String")
{
}

ClassMethod QueryAllForTreeExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	Set groupId=$o(^SSU("SSGRP",0))
	while groupId'="" {
		set obj=..GetObjById(+groupId)
		//set data=$lb("'"_groupId_"'","'"_obj.Descs_"'","true","null")  //by wuqk 2011-07-20
		set data=$lb(groupId,obj.Descs,"true","null")
		set ^CacheTemp(repid,ind)=data
		do obj.%Close()
		set ind=ind+1
		Set groupId=$o(^SSU("SSGRP",groupId))
	}
	kill obj
	Quit $$$OK
}

ClassMethod QueryAllForTreeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryAllForTreeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QueryAllForTreeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryAllForTreeExecute ]
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
