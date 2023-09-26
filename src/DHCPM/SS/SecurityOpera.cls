/// 名称: DHCPM.SS.SecurityOpera
/// 描述: 医政管理菜单操作权限表
/// 编写者：dongzt
/// 编写日期: 2015-01-12
Class DHCPM.SS.SecurityOpera Extends (%Persistent, DHCPM.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock ]
{

/// 安全组指针
Property SSGroupDr As %Integer [ Required ];

/// 菜单操作指针  DHCPM.SS.MenuOperation
Property MenuOperaDr As %Integer [ Required ];

/// 权限
Property Authority As %Boolean;

Index IndexOfGOpera On (SSGroupDr, MenuOperaDr) [ Unique ];

/// Creator：     dongzt
/// CreatDate：   2014-01-12
/// Description:  将对象格式化为字符串
/// Table：       DHCPM.SS.SecurityOpera
/// Input：       separete:指定的分隔符
/// Return：      返回各属性值，按照separete分隔
/// 1:Rowid 2:SSGroupDr 3:MenuOperaDr 4:Authority
Method ToString(separete As %String) As %String
{
	if $g(separete)=""{
		set separete=..#SEPARATE
		} 
	set return=..%Id()_separete
	set return=return_..SSGroupDr_separete
	set return=return_..MenuOperaDr_separete
	set return=return_..Authority
	quit return
}

/// Creator：     dongzt
/// CreatDate：   2015-01-12
/// Description:  根据ID取操作权限信息
/// Table：       DHCPM.SS.SecurityOpera
/// Input：       ID:    DHCPM.SS.SecurityOpera.ID
///               separete: 指定的分隔符
/// Return：      返回obj.ToString()
/// w ##class(DHCPM.SS.SecurityOpera).GetObjById(1)
ClassMethod GetObjById(id As %String) As DHCPM.SS.SecurityOpera
{
	new (id)
	set return=""
	quit:id="" return
	quit:'##class(DHCPM.SS.SecurityOpera).%ExistsId(+id) return
	set obj=##Class(DHCPM.SS.SecurityOpera).%OpenId(+id)
	set return=obj
	do obj.%Close()
	quit return
}

/// Creator：     dongzt
/// CreatDate：   2015-01-12
/// Description:  根据ID取操作权限信息
/// Table：       DHCPM.SS.SecurityOpera
/// Input：       ID:    DHCPM.SS.SecurityOpera.ID
///               separete: 指定的分隔符
/// Return：      返回obj.ToString()
/// w ##class(DHCPM.SS.SecurityOpera).GetStringById(1)
ClassMethod GetStringById(id As %String, separete As %String) As %String
{
	new (id,separete)
	set return=""
	set obj=..GetObjById(id)
	if $IsObject(obj){
		set return=obj.ToString($g(separete))
	}	
	quit return
}

/// Creator：     dongzt
/// CreatDate：   2015-01-12
/// Description:  更新SecurityOpera
/// Table：       DHCPM.SS.SecurityOpera
/// Input：       groupId     安全组id
///               menuOperaId 操作Id
///               authority  是否有权限访问 1：有权限，0：无权限
/// Return：      成功：返回id，失败：返回<0的代码
ClassMethod Update(groupId, menuOperaId, authority) As %String
{
	new (groupId, menuOperaId, authority)
	set id=""
	if $d(^DHCPM.SS.SecurityOperaI("IndexOfGOpera",groupId, menuOperaId)) {
		set id = $o(^DHCPM.SS.SecurityOperaI("IndexOfGOpera",groupId, menuOperaId,""))
		set obj = ##class(DHCPM.SS.SecurityOpera).%OpenId(id)
		}
	else{
		set obj = ##class(DHCPM.SS.SecurityOpera).%New()
	}
	set obj.SSGroupDr=+groupId
	set obj.MenuOperaDr=+menuOperaId
	set obj.Authority=$s(+authority=0:0,1:1)
	set sc=obj.%Save()
	if $system.Status.IsError(sc) {                               //检查Save是否成功
   		d $system.OBJ.DisplayError(sc) 
   		set id=-1
	}
	else{
		set id=obj.%Id()
		}
	do obj.%Close()
	quit id
}

/// Creator：     dongzt
/// CreatDate：   2015-01-12
/// Description:  删除SecurityOpera
/// Table：       DHCPM.SS.SecurityOpera
/// Input：       SecurityOperaId
/// Return：      成功：返回0，失败：返回<0的代码
ClassMethod DeleteById(Id)
{
	new (Id)
	set sc = ##class(DHCPM.SS.SecurityOpera).%DeleteId(+Id)
	if $system.Status.IsError(sc) {            //检查删除是否成功
   		d $system.OBJ.DisplayError(sc) 
   		set ret=-1
	}
	else{
		set ret=0
		}
	quit ret
}

/// Creator：     dongzt
/// CreatDate：   2015-01-12
/// Description:  检查安全组对指定菜单操作是否有权限访问
/// Table：       DHCPM.SS.Security
/// Input：       groupId  安全组Id
///               menuOperaId   菜单操作Id
/// Return：      1：有权限，0：无权限
ClassMethod CheckAuthority(groupId As %String, menuOperaId As %String)
{
	new (groupId, menuOperaId)
	set authority=0
	if $d(^DHCPM.SS.SecurityOperaI("IndexOfGOpera",groupId,menuOperaId)){
		set securityId=$o(^DHCPM.SS.SecurityOperaI("IndexOfGOpera",groupId,menuOperaId,""))
		set obj=##class(DHCPM.SS.SecurityOpera).%OpenId(securityId)
		set authority=obj.Authority
		do obj.%Close()
	}
	quit +authority
}

/// Creator：     dongzt
/// CreatDate：   2015-01-12
/// Description:  检查用户对某个菜单项目是否有权限
/// Table：       DHCPM.SS.MenuOperation、DHCPM.SS.SecurityOpera
/// Input：       MenuCode：菜单代码，OperationCode：操作代码，GroupID：用户组ID
/// Return：      1：--有权限  0：--无权限  -1：--没有这个菜单项目  -2：没有这个菜单操作
/// w ##class(DHCPM.SS.SecurityOpera).HasPower("EpdReport", "EditAtCheck",12)
ClassMethod HasPower(MenuCode As %String, OperationCode As %String, GroupID As %String) As %String
{
	n (MenuCode,OperationCode,GroupID)
	Set MenuCode=" "_$$ALPHAUP^SSUTIL4(MenuCode)
	Set OperationCode=" "_$$ALPHAUP^SSUTIL4(OperationCode)
	Set MenuID=$o(^DHCPM.SS.MenusI("MenuCodeIndex",MenuCode,""))
	Quit:MenuID="" -1 //没有该菜单
	Set OperationID=$o(^DHCPM.SS.MenuOperationI("IndexOfMenuOpera",MenuID,OperationCode,""))
	Quit:OperationID="" -2 //没有该菜单操作
	Set ret=##class(DHCPM.SS.SecurityOpera).CheckAuthority(GroupID, OperationID)
	Quit ret
}

Storage Default
{
<Data name="SecurityOperaDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>SSGroupDr</Value>
</Value>
<Value name="3">
<Value>MenuOperaDr</Value>
</Value>
<Value name="4">
<Value>Authority</Value>
</Value>
</Data>
<DataLocation>^DHCPM.SS.SecurityOperaD</DataLocation>
<DefaultData>SecurityOperaDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCPM.SS.SecurityOperaD</IdLocation>
<IndexLocation>^DHCPM.SS.SecurityOperaI</IndexLocation>
<StreamLocation>^DHCPM.SS.SecurityOperaS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
