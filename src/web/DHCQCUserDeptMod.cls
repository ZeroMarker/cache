Class web.DHCQCUserDeptMod Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

/// Creator：      DaiYi
/// CreatDate：    20130615
/// Description:： 模块维护
/// Table：        DHCQC_Module
/// Input：        ModCode:模板代码，ModName:模块名称,ModSeq:序号
/// Output：       SQLCODE
/// Return：       0
/// Others：
/// d ##class(web.DHCQCUserDeptMod).InsertModule("FrmQCModule","系统模块维护",2)
ClassMethod InsertModule(ModCode As %String, ModName As %String, ModSeq As %String) As %String
{
	Set ModCode=$Get(ModCode),ModName=$Get(ModName),ModSeq=$Get(ModSeq)
	Set Ret=100
	If $Data(^DHCQCMDi(ModCode)) Do
	.Set ModName1="" Set ModName1=$Order(^DHCQCMDi(ModCode,ModName1)) Quit:ModName1=""  Do
	..Set RowId="" Set RowId=$Order(^DHCQCMDi(ModCode,ModName1,RowId)) Quit:RowId=""  Do
	...Set Ret=..UpdateModule(RowId,ModCode,ModName,ModSeq)
	Else  Do
	.//------保存---------------
	.Set PLIST(2)=ModCode
	.Set PLIST(3)=ModName
	.Set PLIST(4)=""
	.Set PLIST(5)=""
	.Set PLIST(6)=ModSeq
	.Set PLIST(7)=""
	.Set PLIST(8)=""
	.Set PLIST(9)=""
	.Set PLIST(10)=""
	.Set PLIST(11)=""
	.Set PLIST(12)=""
	.//-------------------------
	.&SQL(Insert Into lab.DHCQC_Module Values :PLIST())
	.Set Ret=SQLCODE
	Quit Ret
}

/// Creator：      DaiYi
/// CreatDate：    20130615
/// Description:： 模块维护
/// Table：        DHCQC_Module
/// Input：        RowId:唯一码,ModCode:模板代码，ModName:模块名称,ModSeq:序号
/// Output：       SQLCODE
/// Return：       0
/// Others：
/// d ##class(web.DHCQCUserDeptMod).UpdateModule("")
ClassMethod UpdateModule(RowId As %String, ModCode As %String, ModName As %String, ModSeq As %String) As %String
{
	Set RowId=$Get(RowId),ModCode=$Get(ModCode),ModName=$Get(ModName),ModSeq=$Get(ModSeq)
	&SQL(Update lab.DHCQC_Module Set DQMD_ModCode=:ModCode,DQMD_ModDesc=:ModName,DQMD_ModSeqNum=:ModSeq Where DQMD_RowId=:RowId) 
	Quit SQLCODE
}

/// Creator：      DaiYi
/// CreatDate：    20130615
/// Description:： 保存用户访问模板权限。
/// Table：        DHCQC_Module,DHCQC_UserDeptRole
/// Input：        UserId:用户代码,DeptCode科室代码,ModCode:模板代码，ModFlag:是否可以访问
/// Output：       SQLCODE
/// Return：       0
/// Others：
/// d ##class(web.DHCQCUserDeptMod).InsertUserModule("demo","A","FrmQCReceiveData","true")
ClassMethod InsertUserModule(UserId As %String, DeptCode As %String, ModCode As %String, ModFlag As %String) As %String
{
	Set UserId=$Get(UserId),DeptCode=$Get(DeptCode),ModCode=$Get(ModCode),ModFlag=$Get(ModFlag)
	Set Ret=100
	If $Data(^DHCQCUDRi(UserId,DeptCode,ModCode)) Do
	.Set RowId="" Set RowId=$Order(^DHCQCUDRi(UserId,DeptCode,ModCode,RowId)) Quit:RowId=""  Do
	..Set Ret=..UpdateUserModule(RowId,ModFlag)
	Else  Do
	.//------保存---------------
	.Set PLIST(2)=UserId
	.Set PLIST(3)=DeptCode
	.Set PLIST(4)=ModCode
	.Set PLIST(5)=ModFlag
	.Set PLIST(6)=""
	.Set PLIST(7)=""
	.Set PLIST(8)=""
	.Set PLIST(9)=""
	.Set PLIST(10)=""
	.Set PLIST(11)=""
	.Set PLIST(12)=""
	.//-------------------------
	.&SQL(Insert Into lab.DHCQC_UserDeptRole Values :PLIST())
	.Set Ret=SQLCODE
	Quit Ret
}

/// Creator：      DaiYi
/// CreatDate：    20130615
/// Description:： 更新用户访问模板权限。
/// Table：        DHCQC_Module,DHCQC_UserDeptRole
/// Input：        RowId:唯一码,ModCode:模板代码，ModName:模块名称,ModSeq:序号
/// Output：       SQLCODE
/// Return：       0
/// Others：
/// d ##class(web.DHCQCUserDeptMod).UpdateModule("")
ClassMethod UpdateUserModule(RowId As %String, ModFlag As %String) As %String
{
	Set RowId=$Get(RowId),ModFlag=$Get(ModFlag)
	&SQL(Update lab.DHCQC_UserDeptRole Set DQUD_ModFlag=:ModFlag Where DHCQC_RowId=:RowId) 
	Quit SQLCODE
}

/// Creator：      DaiYi
/// CreatDate：    20130615
/// Description:： 删除模块
/// Table：        DHCQC_Module
/// Input：        RowId:唯一码,ModCode:模板代码，ModName:模块名称,ModSeq:序号
/// Output：       SQLCODE
/// Return：       0
/// Others：
/// d ##class(web.DHCQCUserDeptMod).UpdateModule("")
ClassMethod DeleteModule(RowId As %String) As %String
{
	Set RowId=$Get(RowId)
	&SQL(Delete From lab.DHCQC_Module  Where DQMD_RowId=:RowId) 
	Quit SQLCODE
}

/// Creator：      DaiYi
/// CreatDate：    20130615
/// Description:： 查询是否分配权限
/// Table：        DHCQC_Module
/// Input：        UserId:用户代码
/// Output：       UserFlag
/// Return：       0
/// Others：
/// d ##class(web.DHCQCUserDeptMod).CheckUserRole("demo")
ClassMethod CheckUserRole(UserId As %String) As %String
{
	Set UserId=$Get(UserId)
	Set Ret=100
	If $Data(^DHCQCUDRi(UserId)) Do
	.Set Ret=0
	If UserId="demo" Set Ret=0
	If UserId="trak" Set Ret=0
	If UserId="dhcc" Set Ret=0
	Quit Ret
}

/// Creator：      DaiYi
/// CreatDate：    20130615
/// Description:： 拷贝权限
/// Table：        DHCQC_Module
/// Input：        UserForm:用户代码,UserTo:需要拷贝的代码
/// Output：       Ret
/// Return：       0
/// Others：
/// d ##class(web.DHCQCUserDeptMod).CopyUserRole("demo",301265")
ClassMethod CopyUserRole(UserForm As %String, UserTo As %String) As %String
{
	Set UserForm=$Get(UserForm),UserTo=$Get(UserTo)
	Set Ret=100
	If '$Length(UserForm) Quit Ret
	If '$Length(UserTo) Quit Ret
	If $Data(^DHCQCUDRi(UserForm)) Do
	.Set DeptCode="" For  Set DeptCode=$Order(^DHCQCUDRi(UserForm,DeptCode)) Quit:DeptCode=""  Do
	..Set ModCode="" For  Set ModCode=$Order(^DHCQCUDRi(UserForm,DeptCode,ModCode)) Quit:ModCode=""  Do
	...Set RowId="" For  Set RowId=$Order(^DHCQCUDRi(UserForm,DeptCode,ModCode,RowId)) Quit:RowId=""  Do
	....Set StrData=$Get(^DHCQCUDR(RowId))
	....Set UserFlag=$Piece(StrData,"^",4)
	....Set Ret=..InsertUserModule(UserTo,DeptCode,ModCode,UserFlag)
	Quit Ret
}

/// Creator：      DaiYi
/// CreatDate：    20130615
/// Description:： 查询工作操作权限.
/// Table：        DHCQC_Module
/// Input：        UserId:用户代码,DeptCode:科室信息,ModCode:需要拷贝的代码
/// Output：       Ret
/// Return：       0
/// Others：
/// d ##class(web.DHCQCUserDeptMod).QueryUserRole("demo","A","FrmQCReceiveData")
ClassMethod QueryUserRole(UserId As %String, DeptCode As %String, ModCode As %String) As %String
{
	Set UserForm=$Get(UserForm),UserTo=$Get(UserTo)
	Set Ret=100
	If '$Length(UserId) Quit Ret
	If $Data(^DHCQCUDRi(UserId)) Do
	.Set CurDeptCode="" For  Set CurDeptCode=$Order(^DHCQCUDRi(UserId,CurDeptCode)) Quit:CurDeptCode=""  Do
	..If $Length(DeptCode),CurDeptCode'=DeptCode Quit
	..Set CurModCode="" For  Set CurModCode=$Order(^DHCQCUDRi(UserId,CurDeptCode,CurModCode)) Quit:CurModCode=""  Do
	...If $Length(ModCode),ModCode'=CurModCode Quit
	...Set RowId="" For  Set RowId=$Order(^DHCQCUDRi(UserId,CurDeptCode,CurModCode,RowId)) Quit:RowId=""  Do
	....Set StrData=$Get(^DHCQCUDR(RowId))
	....Set UserFlag=$Piece(StrData,"^",4)
	....If UserFlag="True" Set Ret=0
	If UserId="demo" Set Ret=0
	If UserId="trak" Set Ret=0
	If UserId="dhcc" Set Ret=0
	Quit Ret
}

ClassMethod QueryModuleClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryModuleExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Query的执行方法
/// d ##class(%ResultSet).RunQuery("web.DHCQCUserDeptMod","QueryModule","")
ClassMethod QueryModuleExecute(ByRef qHandle As %Binary, QueryModeName As %String, ModeCode, ModeSeq) As %Status
{
	Set ModeName=$Get(ModeName)
	Set repid=$I(^CacheTemp)
	If $Get(ind)="" Set ind=1
	Set ModNum=1
	Set RowId="" For  Set RowId=$Order(^DHCQCMD(RowId)) Quit:RowId=""  Do
    .Set StrData=$Get(^DHCQCMD(RowId)) 
    .Set ModCode=$Piece(StrData,"^",1)
    .i $l(ModeCode),ModCode'[ModeCode q
    .Set ModName=$Piece(StrData,"^",2)
    .i $l(QueryModeName),ModName'[QueryModeName q
    .Set ModSeq=$Piece(StrData,"^",5)
    .i $l(ModeSeq),ModeSeq'=ModSeq q
    .Set ModRowId=RowId
	.Do Output
	.Set ModNum=ModNum+1
	If ModNum<2 Do
	.Set (ModNum,ModCode,ModName,ModSeq,ModRowId)=""
	.Do Output
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK	
	
Output
	set Data=$lb(ModNum,ModCode,ModName,ModSeq,ModRowId)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod QueryModuleFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryModuleExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" 
 	{				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      
 	{	// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：      DaiYi
/// CreatDate：    20130615
/// Description:： 查询模板列表
/// Table：        DHCQC_Module
/// Input：        QueryModeName:模块名字
/// Output：       仪器集合
/// Return：       0:无,1:有
/// Others：
Query QueryModule(QueryModeName As %String, ModeCode, ModeSeq) As %Query(ROWSPEC = "ModNum:%String,ModCode:%String,ModName:%String,ModSeq:%String,ModRowId:%String") [ SqlProc ]
{
}

//--------------------------------

ClassMethod QueryUserRoleClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryUserRoleExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Query的执行方法
/// d ##class(%ResultSet).RunQuery("web.DHCQCUserDeptMod","QueryUserRole","2011","A")
ClassMethod QueryUserRoleExecute(ByRef qHandle As %Binary, UserId As %String, DeptCode As %String) As %Status
{
	Set UserId=$Get(UserId),DeptCode=$Get(DeptCode)
	Set repid=$I(^CacheTemp)
	If $Get(ind)="" Set ind=1
	Set ModNum=1
	Set RowId="" For  Set RowId=$Order(^DHCQCMD(RowId)) Quit:RowId=""  Do
    .Set StrData=$Get(^DHCQCMD(RowId)) 
    .Set Code=$Piece(StrData,"^",1)
    .Set Name=$Piece(StrData,"^",2)
    .Set UseFlag="false"
    .If $Length(UserId),$Length(DeptCode),$Data(^DHCQCUDRi(UserId,DeptCode,Code)) Do
    ..Set RowId1=$Order(^DHCQCUDRi(UserId,DeptCode,Code,""))
    ..Set UseFlag=$Piece(^DHCQCUDR(RowId1),"^",4)
	.Do Output
	.Set ModNum=ModNum+1
	If ModNum<2 Do
	.Set (Code,Name,UseFlag)=""
	.Set UseFlag="false"
	.Do Output
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK	
	
Output
	set Data=$lb(Code,Name,UseFlag)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod QueryUserRoleFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryUserRoleExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" 
 	{				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      
 	{	// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：      DaiYi
/// CreatDate：    20130615
/// Description:： 查询操作者权限
/// Table：        DHCQC_Module,DHCQC_UserDeptRole
/// Input：        QueryModeName:模块名字
/// Output：       仪器集合
/// Return：       0:无,1:有
/// Others：
Query QueryUserRole(UserId As %String, DeptCode As %String) As %Query(ROWSPEC = "Code:%String,Name:%String,UseFlag:%String") [ SqlProc ]
{
}

ClassMethod GetAllClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAllExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Query的执行方法
/// d ##class(%ResultSet).RunQuery("web.类名","query名称","参数1","参数2",参数……
/// d ##class(%ResultSet).RunQuery("web.DHCQCUserDeptMod","GetAll","","","155")
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
	.Set UseFlag="false"
	.//If $Length(UserId),$Data(^DHCQCUDRi(UserId,code)) Set UseFlag="true"
	.If $Length(UserId),$Data(^DHCQCUDRi(UserId,code)) d
	..s DeptMod="" f  s DeptMod=$o(^DHCQCUDRi(UserId,code,DeptMod)) q:DeptMod=""  d
	...s RowId="" f  s RowId=$o(^DHCQCUDRi(UserId,code,DeptMod,RowId)) q:RowId=""  d
	....i $p($g(^DHCQCUDR(RowId)),"^",4)="True" d 
	.....s UseFlag="true"
	.Do OutputRow
    .s UseFlag="false"
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
OutputRow
	set Data=$lb(code,name,UseFlag)
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
/// Description:： 按照用户查询科室
/// Table：        Ct_DeptCode,DHCQC_UserDeptRole
/// Input：        DepCode:科室代码，DepName：科室名称,UserId:用户代码
/// Output：       
/// Return：       0:无,1:有
/// Others：
Query GetAll(DepCode As %String, DepName As %String, UserId As %String) As %Query(ROWSPEC = "Code:%String,Name:%String,UseFlag:%String") [ SqlProc ]
{
}

Storage Default
{
<Data name="DHCQCUserDeptModDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCQCUserDeptModD</DataLocation>
<DefaultData>DHCQCUserDeptModDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^web.DHCQCUserDeptModD</IdLocation>
<IndexLocation>^web.DHCQCUserDeptModI</IndexLocation>
<StreamLocation>^web.DHCQCUserDeptModS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
