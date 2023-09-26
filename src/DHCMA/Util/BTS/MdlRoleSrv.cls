/// 名称: DHCMA.Util.BTS.MdlRoleSrv
/// 描述: 模块角色定义 服务类
/// 编写者：liuzhenhe
/// 编写日期: 2018-11-28
/// 编写目的:查询DHCMA.Util.BT.MdlRole(模块角色表)
Class DHCMA.Util.BTS.MdlRoleSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     liuzhenhe
/// CreatDate：   2018-11-28
/// Description:  根据父表Id查询模块角色定义
/// Table：       DHCMA.Util.BT.MdlRole
/// Input：       aParRef
/// Output:		  SubID < ExtID
/// D ##class(%ResultSet).RunQuery("DHCMA.Util.BTS.MdlRoleSrv","QryMdlRole","2")
Query QryMdlRole(aParRef As %String) As %Query(ROWSPEC = "SubID:%String,ExtID:%String,BTCode:%String,BTDesc:%String")
{
}

ClassMethod QryMdlRoleExecute(ByRef qHandle As %Binary, aParRef As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	Quit:aParRef="" $$$OK
 	
	Set xBTCode=""
 	For {
	 	Set xBTCode=$o(^DHCMA.Util.BT.MdlDefI("R","IdxofCode",xBTCode))
	 	Quit:xBTCode=""
	 	
		Set xSub=""
	 	For {	
	 		Set xSub=$o(^DHCMA.Util.BT.MdlDefI("R","IdxofCode",xBTCode,aParRef,xSub))
	 		Quit:xSub=""
	 		
	 		Set ID=aParRef_"||"_xSub
	 		Set obj=##class(DHCMA.Util.BT.MdlRole).GetObjById(ID)
	 		Continue:'$IsObject(obj)
	 		
	 		Set BTCode      = obj.BTCode
	 		Set BTDesc      = obj.BTDesc
	 		
			Set Data=$lb(xSub,ID,BTCode,BTDesc)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
	 	}
 	}	
	Quit $$$OK
}

ClassMethod QryMdlRoleClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryMdlRoleExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryMdlRoleFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryMdlRoleExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

}
