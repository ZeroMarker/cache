/// 检验科室查询
Class web.DHCQCDepartment Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Parameter EXTENTSIZE = 250;

ClassMethod GetAllClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAllExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Query的执行方法
/// d ##class(%ResultSet).RunQuery("web.类名","query名称","参数1","参数2",参数……
/// d ##class(%ResultSet).RunQuery("web.DHCQCDepartment","GetAll","","","")
ClassMethod GetAllExecute(ByRef qHandle As %Binary, DepCode As %String, DepName As %String, UserId As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	If $Get(ind)="" Set ind=1
	Set code="" For  Set code=$Order(^TTAB("DEP",code)) Quit:code=""  Do
	.Set name=$Piece(^TTAB("DEP",code),"\",1)
	.If $Length(UserId),'$Data(^TTAB("UA",UserId)) Quit
	.If $Length(UserId),'$Data(^TTAB("UA",UserId,4,code)) Quit
	.//If $Piece(^TTAB("DEP",code),"\",13)=60 Quit
	.If $Length(DepName),DepName'[name Quit
	.If $Length(DepCode),DepCode'=code Quit
	.//增加权限维护控制
	.If code'="trak",'$Data(^DHCQCUDRi(UserId,code)) Quit
	.Do OutputRow
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
OutputRow
	set Data=$lb(code,name)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod GetAllFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAllExecute ]
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

/// Creator：      DaiYi
/// CreatDate：    20101026
/// Description:： 检验科室查询
/// Table：        
/// Input：        DepCode:科室代码，DepName：科室名称,UserId:用户代码
/// Output：       
/// Return：       0:无,1:有
/// Others：
Query GetAll(DepCode As %String, DepName As %String, UserId As %String) As %Query(ROWSPEC = "Code:%String,Name:%String") [ SqlProc ]
{
}

/// Creator：      DaiYi
/// CreatDate：    20111108
/// Description:： 登录用户检验科室查询
/// Table：         ss_user，SS_User_DepartmentAccess
/// Input：         UserId:用户登录代码。
/// Output：        
/// Return：       0:无,1:有
/// Others：
Query QueryUserDep(UserId As %String) As %Query(ROWSPEC = "Code:%String,Name:%String,UseFlag:%String,IsDefault:%String") [ SqlProc ]
{
}

ClassMethod QueryUserDepClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryUserDepExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Query的执行方法
/// d ##class(%ResultSet).RunQuery("web.类名","query名称","参数1","参数2",参数……
/// d ##class(%ResultSet).RunQuery("web.DHCQCDepartment","QueryUserDep","demo")
ClassMethod QueryUserDepExecute(ByRef qHandle As %Binary, UserId As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	If $Get(ind)="" Set ind=1
	If $Data(^TTAB("UA",UserId)) Do
	.Set DepCode=""
	.For  Set DepCode=$Order(^TTAB("UA",UserId,4,DepCode)) Quit:DepCode=""  Do
	..//微生物科室的排除
	..Set DepName=""
	..//增加权限维护控制
	..s isFlag=0
	..If (UserId'="demo") s isFlag=1   //||(UserId'="trak")||'$Data(^DHCQCUDRi(UserId,DepCode)) Quit
	..If (UserId'="trak") s isFlag=1 
	..//i $Data(^DHCQCUDRi(UserId,DepCode)) s isFlag=1 
	..If $Length(UserId),$Data(^DHCQCUDRi(UserId,DepCode)) d
	...s isFlag=0
	...s DeptMod="" f  s DeptMod=$o(^DHCQCUDRi(UserId,DepCode,DeptMod)) q:DeptMod=""  d
	....s RowId="" f  s RowId=$o(^DHCQCUDRi(UserId,DepCode,DeptMod,RowId)) q:RowId=""  d
	.....i $p($g(^DHCQCUDR(RowId)),"^",4)="True" s isFlag=1
	..i isFlag=0 q
	..//If $Piece(^TTAB("DEP",DepCode),"\",13)=60 Quit
	..Set UseFlag="Y",IsDefault="Y"
	..Set DepName=$Piece(^TTAB("DEP",DepCode),"\",1)
	..Do OutputDep
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
OutputDep
	set Data=$lb(DepCode,DepName,UseFlag,IsDefault)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod QueryUserDepFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryUserDepExecute ]
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

ClassMethod QueryUserDeptClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryUserDeptExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Query的执行方法
/// d ##class(%ResultSet).RunQuery("web.类名","query名称","参数1","参数2",参数……
/// d ##class(%ResultSet).RunQuery("web.DHCQCDepartment","QueryUserDept","","","demo")
ClassMethod QueryUserDeptExecute(ByRef qHandle As %Binary, DepCode As %String, DepName As %String, UserId As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	If $Get(ind)="" Set ind=1
	Set (code,name,UseFlag,IsDefault)=""
	Set Num=1
	Set code="" For  Set code=$Order(^TTAB("DEP",code)) Quit:code=""  Do
	.Set name=$Piece(^TTAB("DEP",code),"\",1)
	.If $Length(UserId),'$Data(^TTAB("UA",UserId)) Quit
	.If $Length(UserId),'$Data(^TTAB("UA",UserId,4,code)) Quit
	.//If $Piece(^TTAB("DEP",code),"\",13)=60 Quit
	.If $Length(DepName),DepName'[name Quit
	.If $Length(DepCode),DepCode'=code Quit
	.Set UseFlag="Y"
	.Set IsDefault="Y"
	.Do OutputRow1
	.Set Num=Num+1
	If Num<2 Do
	.Do OutputRow1
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
OutputRow1
	set Data=$lb(code,name,UseFlag,IsDefault)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod QueryUserDeptFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryUserDeptExecute ]
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

/// Creator：      DaiYi
/// CreatDate：    20101026
/// Description:： 检验科室查询
/// Table：        
/// Input：        DepCode:科室代码，DepName：科室名称,UserId:用户代码
/// Output：       
/// Return：       0:无,1:有
/// Others：
Query QueryUserDept(DepCode As %String, DepName As %String, UserId As %String) As %Query(ROWSPEC = "Code:%String,Name:%String,UseFlag:%String,IsDefault:%String") [ SqlProc ]
{
}

Storage Default
{
<Data name="DHCQCDepartmentDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCQCDepartmentD</DataLocation>
<DefaultData>DHCQCDepartmentDefaultData</DefaultData>
<IdLocation>^web.DHCQCDepartmentD</IdLocation>
<IndexLocation>^web.DHCQCDepartmentI</IndexLocation>
<StreamLocation>^web.DHCQCDepartmentS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
