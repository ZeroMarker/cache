/// 创建日期：2011-12-17
/// 功能：存储负责科室
/// 创建者：李阳
Class DHCMed.IMP.ChargeDepartment Extends (%Persistent, DHCMed.Abstract) [ Inheritance = right, Not ProcedureBlock ]
{

/// 用户ID
Property UserID As %Integer;

/// 管理科室ID
Property DepartmentID As %Integer;

/// 用户索引
Index IndexUser On (UserID, DepartmentID);

ClassMethod GetObjById(ID As %String) As DHCMed.IMP.ChargeDepartment
{
	New (ID)
	Set obj=##Class(DHCMed.IMP.ChargeDepartment).%OpenId(ID)
	Quit obj
}

ClassMethod Update(arg As %String, Delimiter As %String = "^") As %Integer
{
	New (arg,Delimiter)
	Set return=0
	
	Quit:$d(^DHCMed.IMP.ChargeDepartmentI("IndexUser",$p(arg,Delimiter,2),$p(arg,Delimiter,3)))'=0 -1
	
	
	Set:$g(Delimiter)="" Delimiter=$c(1)
	Set ID=$p(arg,Delimiter,1)
	If ID="" {
		Set obj=##class(DHCMed.IMP.ChargeDepartment).%New()
	} Else {
		Set obj=##class(DHCMed.IMP.ChargeDepartment).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	Set obj.UserID=$p(arg,Delimiter,2)
	Set obj.DepartmentID=$p(arg,Delimiter,3)
	Set sc=obj.%Save()
	If $System.Status.IsError(sc) {      //检查Save是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	} Else {
		Set return=obj.%Id()
	}
	If obj'="" Do obj.%Close()
	
	Quit return
}

ClassMethod DeleteById(ID As %String)
{
	n (ID)
	Quit ##class(DHCMed.IMP.ChargeDepartment).%DeleteId(ID)
}

/// 功能：查询已经分配管理科室的用户
/// 创建日期：2011-12-17
/// 创建者：李阳
/// d ##class(%Library.ResultSet).RunQuery("DHCMed.IMP.ChargeDepartment","QryUser")
Query QryUser() As %Query(ROWSPEC = "UserID:%String,UserCode:%String:用户工号,UserName:%String:用户名")
{
}

ClassMethod QryUserExecute(ByRef qHandle As %Binary) As %Status
{
   Set repid=$I(^CacheTemp)
   Set ind=1
   Set qHandle=$lb(0,repid,0)
   Set UserID=""
   For {
	   Set UserID=$o(^DHCMed.IMP.ChargeDepartmentI("IndexUser",UserID))
	   Quit:UserID=""
	   Set objUser=##class(DHCMed.Base.SSUser).GetObjById(UserID)
	   Quit:$IsObject(objUser)=0
	   Do objUser.%Close()
	   Set data=$lb("")
	   Set $li(data,1)=objUser.Rowid
	   Set $li(data,2)=objUser.Code
	   Set $li(data,3)=objUser.Name
	   Set ^CacheTemp(repid,ind)=data
	   Set ind=ind+1
	   Kill objUser
   }
   Quit $$$OK
}

ClassMethod QryUserClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryUserExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryUserFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryUserExecute ]
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

/// 通过用户查询其所管辖科室
/// d ##class(%Library.ResultSet).RunQuery("DHCMed.IMP.ChargeDepartment","QryChargeDepByUser",1)
Query QryChargeDepByUser(UserID As %String) As %Query(ROWSPEC = "RowID:%String,UserID:%String,DepartmentID:%String,DepartmentName:%String:科室")
{
}

ClassMethod QryChargeDepByUserExecute(ByRef qHandle As %Binary, UserID As %String) As %Status
{
   Set repid=$I(^CacheTemp)
   Set ind=1
   Set qHandle=$lb(0,repid,0)
   Set DepartmentID=""
   For {
	   Set DepartmentID=$o(^DHCMed.IMP.ChargeDepartmentI("IndexUser",UserID,DepartmentID))
	   Quit:DepartmentID=""
	   Set objDep=##class(DHCMed.Base.Ctloc).GetObjById(DepartmentID)
	   Quit:$IsObject(objDep)=0
	   Do objDep.%Close()
	   Set RowID=""
	   For {
		   Set RowID=$o(^DHCMed.IMP.ChargeDepartmentI("IndexUser",UserID,DepartmentID,RowID))
		   Quit:RowID=""
		   Set obj=##class(DHCMed.IMP.ChargeDepartment).GetObjById(RowID)
		   Set $li(data,1)=obj.%Id()
		   Set $li(data,2)=UserID
		   Set $li(data,3)=DepartmentID
		   Set $li(data,4)=objDep.Descs
		   Set ^CacheTemp(repid,ind)=data
		   Set ind=ind+1	   
	   }
	   Set data=$lb("")
	   Kill objDep
   }   	
   Quit $$$OK
}

ClassMethod QryChargeDepByUserClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryChargeDepByUserExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryChargeDepByUserFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryChargeDepByUserExecute ]
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

Storage Default
{
<Data name="ChargeDepartmentDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DepartmentID</Value>
</Value>
<Value name="3">
<Value>UserID</Value>
</Value>
</Data>
<DataLocation>^DHCMed.IMP.ChargeDepartmentD</DataLocation>
<DefaultData>ChargeDepartmentDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMed.IMP.ChargeDepartmentD</IdLocation>
<IndexLocation>^DHCMed.IMP.ChargeDepartmentI</IndexLocation>
<StreamLocation>^DHCMed.IMP.ChargeDepartmentS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
