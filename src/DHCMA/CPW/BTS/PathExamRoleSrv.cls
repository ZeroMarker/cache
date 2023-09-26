/// 名称: 		DHCMA.CPW.BTS.PathExamRoleSrv
/// 描述: 		表单发布审核角色服务类
/// 编写者：	yankai
/// 编写日期: 	2021-11-04
Class DHCMA.CPW.BTS.PathExamRoleSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     yankai
/// CreatDate：   2021-11-04
/// Description:  查询路径审核角色
/// Table：       DHCMA.CPW.BT.PathExamRole
/// Input：       
/// D ##class(%ResultSet).RunQuery("DHCMA.CPW.BTS.PathExamRoleSrv","QryPathExamRole")
Query QryPathExamRole(aIsActive As %String = "", aHospID As %String = "") As %Query(ROWSPEC = "xID:%String,Code:%String,Desc:%String,Value:%String,ValueDesc:%String,TypeCode:%String,TypeDesc:%String,Priority:%String,IsActive:%String")
{
}

ClassMethod QryPathExamRoleExecute(ByRef qHandle As %Binary, aIsActive As %String = "", aHospID As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	Set xID=""
 	For {
	 	Set xID=$o(^DHCMA.CPW.BT.PathExamRoleD(xID))
	 	Quit:xID=""
	 	
	 	Set obj=##class(DHCMA.CPW.BT.PathExamRole).GetObjById(xID)
	 	Continue:'$IsObject(obj)
	 	
	 	Set Code         = obj.BTCode
	 	Set Desc         = obj.BTDesc
	 	Set Value		 = obj.BTValue
	 	Set HospID		 = obj.BTHospID
	 	Continue:(aHospID'="")&&(aHospID'=HospID)
	 	Set TypeCode	 = obj.BTType
	 	Set TypeDesc 	 = $Case(TypeCode,"U":"用户","G":"安全组","L":"科室",:"")
	 	Set Priority 	 = obj.BTPriority
	 	Set IsActive     = $s(obj.BTIsActive=1:"是",1:"否")
	 	Set ValueDesc=""
	 
	 	If TypeCode="U"{
			Set objUser=##class(DHCMA.Util.EPx.SSUser).GetObjByOID(Value) 
			Set:$IsObject(objUser) ValueDesc=objUser.BTDesc		
		}
	 	If TypeCode="G"{
			Set objGrp=##class(DHCMA.Util.EPx.SSGroup).GetObjByOID(Value) 
			Set ValueDesc=objGrp.BTDesc	
		}
	 	If TypeCode="L"{
			Set objLoc=##class(DHCMA.Util.EPx.Location).GetObjByOID(Value) 
			Set ValueDesc=objLoc.BTDesc	
		}
	 	
		Set Data=$lb(xID,Code,Desc,Value,ValueDesc,TypeCode,TypeDesc,Priority,IsActive)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
 	}	
	Quit $$$OK
}

ClassMethod QryPathExamRoleClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryPathExamRoleExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryPathExamRoleFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryPathExamRoleExecute ]
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

/// Creator：		yankai
/// CreatDate:		2022-05-31
/// Description:	查看某用户在发布审核流程中所属的审核角色（按登录信息获取）
/// Table:			DHCMA_CPW_BT.PathExamRole
/// Input:			session用户ID,SESSION科室ID,SESSION安全组ID
/// Output:			角色ID^角色描述_$c(1)_角色ID^角色描述；0：无对应角色；<0：报错
/// w ##class(DHCMA.CPW.BTS.PathExamRoleSrv).GetPubExamRole("9!!1","114!!1","2!!1")
ClassMethod GetPubExamRole(aUserID As %String, aLocID As %String, aHospID As %String, aGroupID As %String = "") As %String
{
	New (aUserID,aLocID,aHospID,aGroupID)
	Set return=0
	Quit:(aUserID="")||(aLocID="") return
	
	Set:aUserID'["!!" aUserID=aUserID_"!!1"
	Set:aLocID'["!!" aLocID=aLocID_"!!1"
	Set:aHospID'["!!" aHospID=aHospID_"!!1"
	Set $ZT="GetPubExamRoleError"
	Set retRole=""	
	//用户角色
	Set xRoleID=""
	For {
		Set xRoleID = $o(^DHCMA.CPW.BT.PathExamRoleI("IdxofType",1,aHospID,"U",xRoleID))
		Quit:xRoleID=""
		
		Set objRole=##class(DHCMA.CPW.BT.PathExamRole).GetObjById(xRoleID)
		Continue:'$IsObject(objRole)
		Continue:+objRole.BTValue'=+aUserID
		Set retRole=retRole_$c(1)_xRoleID_"^"_objRole.BTDesc	
	}
	
	//科室角色
	Set xRoleID=""
	For {
		Set xRoleID = $o(^DHCMA.CPW.BT.PathExamRoleI("IdxofType",1,aHospID,"L",xRoleID))
		Quit:xRoleID=""
		
		Set objRole=##class(DHCMA.CPW.BT.PathExamRole).GetObjById(xRoleID)
		Continue:'$IsObject(objRole)
		Continue:+objRole.BTValue'=+aLocID
		Set retRole=retRole_$c(1)_xRoleID_"^"_objRole.BTDesc	
	}
	
	Set:retRole'="" retRole=$e(retRole,2,$l(retRole))
	Quit retRole
	
GetPubExamRoleError
	Quit -999
}

}
