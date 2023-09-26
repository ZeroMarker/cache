/// 名称: DHCMed.SS.SecurityOpera
/// 描述: 医政管理菜单操作权限表
/// 编写者：wuqk
/// 编写日期: 2010-03-30
Class DHCMed.SS.SecurityOpera Extends (%Persistent, DHCMed.Abstract, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock ]
{

/// 安全组指针
Property SSGroupDr As %Integer [ Required ];

/// 菜单操作指针  DHCMed.SS.MenuOperation
Property MenuOperaDr As %Integer [ Required ];

/// 权限
Property Authority As %Boolean;

Index IndexOfGOpera On (SSGroupDr, MenuOperaDr) [ Unique ];

/// Creator：     wuqk
/// CreatDate：   2010-03-24
/// Description:  将对象格式化为字符串
/// Table：       DHCMed.SS.SecurityOpera
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

/// Creator：     wuqk
/// CreatDate：   2010-04-06
/// Description:  根据ID取操作权限信息
/// Table：       DHCMed.SS.SecurityOpera
/// Input：       ID:    DHCMed.SS.SecurityOpera.ID
///               separete: 指定的分隔符
/// Return：      返回obj.ToString()
/// w ##class(DHCMed.SS.SecurityOpera).GetObjById(1)
ClassMethod GetObjById(id As %String) As DHCMed.SS.SecurityOpera
{
	new (id)
	set return=""
	quit:id="" return
	quit:'##class(DHCMed.SS.SecurityOpera).%ExistsId(+id) return
	set obj=##Class(DHCMed.SS.SecurityOpera).%OpenId(+id)
	set return=obj
	do obj.%Close()
	quit return
}

/// Creator：     wuqk
/// CreatDate：   2010-04-06
/// Description:  根据ID取操作权限信息
/// Table：       DHCMed.SS.SecurityOpera
/// Input：       ID:    DHCMed.SS.SecurityOpera.ID
///               separete: 指定的分隔符
/// Return：      返回obj.ToString()
/// w ##class(DHCMed.SS.SecurityOpera).GetStringById(1)
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

/// Creator：     wuqk
/// CreatDate：   2010-03-24
/// Description:  更新SecurityOpera
/// Table：       DHCMed.SS.SecurityOpera
/// Input：       groupId     安全组id
///               menuOperaId 操作Id
///               authority  是否有权限访问 1：有权限，0：无权限
/// Return：      成功：返回id，失败：返回<0的代码
ClassMethod Update(groupId, menuOperaId, authority) As %String
{
	new (groupId, menuOperaId, authority)
	set id=""
	if $d(^DHCMed.SS.SecurityOperaI("IndexOfGOpera",groupId, menuOperaId)) {
		set id = $o(^DHCMed.SS.SecurityOperaI("IndexOfGOpera",groupId, menuOperaId,""))
		set obj = ##class(DHCMed.SS.SecurityOpera).%OpenId(id)
		}
	else{
		set obj = ##class(DHCMed.SS.SecurityOpera).%New()
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

/// Creator：     wuqk
/// CreatDate：   2010-03-24
/// Description:  删除SecurityOpera
/// Table：       DHCMed.SS.SecurityOpera
/// Input：       SecurityOperaId
/// Return：      成功：返回0，失败：返回<0的代码
ClassMethod DeleteById(Id)
{
	new (Id)
	set sc = ##class(DHCMed.SS.SecurityOpera).%DeleteId(+Id)
	if $system.Status.IsError(sc) {            //检查删除是否成功
   		d $system.OBJ.DisplayError(sc) 
   		set ret=-1
	}
	else{
		set ret=0
		}
	quit ret
}

/// Creator：     wuqk
/// CreatDate：   2010-03-24
/// Description:  检查安全组对指定菜单操作是否有权限访问
/// Table：       DHCMed.SS.Security
/// Input：       groupId  安全组Id
///               menuOperaId   菜单操作Id
/// Return：      1：有权限，0：无权限
ClassMethod CheckAuthority(groupId As %String, menuOperaId As %String)
{
	new (groupId, menuOperaId)
	set authority=0
	if $d(^DHCMed.SS.SecurityOperaI("IndexOfGOpera",groupId,menuOperaId)){
		set securityId=$o(^DHCMed.SS.SecurityOperaI("IndexOfGOpera",groupId,menuOperaId,""))
		set obj=##class(DHCMed.SS.SecurityOpera).%OpenId(securityId)
		set authority=obj.Authority
		do obj.%Close()
	}
	quit +authority
}

/// Creator：     LiYang
/// CreatDate：   2011-07-09
/// Description:  检查用户对某个菜单项目是否有权限
/// Table：       DHCMed.SS.MenuOperation、DHCMed.SS.SecurityOpera
/// Input：       MenuCode：菜单代码，OperationCode：操作代码，GroupID：用户组ID
/// Return：      1：--有权限  0：--无权限  -1：--没有这个菜单项目  -2：没有这个菜单操作
/// w ##class(DHCMed.SS.SecurityOpera).HasPower("EpdReport", "EditAtCheck",12)
ClassMethod HasPower(MenuCode As %String, OperationCode As %String, GroupID As %String) As %String
{
	n (MenuCode,OperationCode,GroupID)
	Set MenuCode=" "_$$ALPHAUP^SSUTIL4(MenuCode)
	Set OperationCode=" "_$$ALPHAUP^SSUTIL4(OperationCode)
	Set MenuID=$o(^DHCMed.SS.MenusI("MenuCodeIndex",MenuCode,""))
	Quit:MenuID="" -1 //没有该菜单
	Set OperationID=$o(^DHCMed.SS.MenuOperationI("IndexOfMenuOpera",MenuID,OperationCode,""))
	Quit:OperationID="" -2 //没有该菜单操作
	Set ret=##class(DHCMed.SS.SecurityOpera).CheckAuthority(GroupID, OperationID)
	Quit ret
}

Storage Default
{
<Data name="SecurityOperaDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Authority</Value>
</Value>
<Value name="3">
<Value>MenuOperaDr</Value>
</Value>
<Value name="4">
<Value>SSGroupDr</Value>
</Value>
</Data>
<DataLocation>^DHCMed.SS.SecurityOperaD</DataLocation>
<DefaultData>SecurityOperaDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMed.SS.SecurityOperaD</IdLocation>
<IndexLocation>^DHCMed.SS.SecurityOperaI</IndexLocation>
<StreamLocation>^DHCMed.SS.SecurityOperaS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
