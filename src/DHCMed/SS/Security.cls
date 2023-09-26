/// 名称: DHCMed.SS.Security
/// 描述: 医政管理菜单权限表
/// 编写者：wuqk
/// 编写日期: 2010-03-24
Class DHCMed.SS.Security Extends (%Persistent, DHCMed.Abstract, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock ]
{

/// 安全组指针
Property SSGroupDr As %Integer [ Required ];

/// 产品指针
Property ProductDr As %Integer [ Required ];

/// 菜单指针
Property MenuDr As %Integer [ Required ];

/// 权限
Property Authority As %Boolean;

Index IndexOfGPM On (SSGroupDr, ProductDr, MenuDr);

Index IndexOfMenu On (SSGroupDr, MenuDr) [ Unique ];

/// Creator：     wuqk
/// CreatDate：   2010-03-24
/// Description:  将对象格式化为字符串
/// Table：       DHCMed.SS.Security
/// Input：       separete:指定的分隔符
/// Return：      返回各属性值，按照separete分隔
/// 1:Rowid 2:SSGroupDr 3:ProductDr 4:MenuDr 5:Authority
Method ToString(separete As %String) As %String
{
	if $g(separete)=""{
		set separete=..#SEPARATE
		} 
	set return=..%Id()_separete
	set return=return_..SSGroupDr_separete
	set return=return_..ProductDr_separete
	set return=return_..MenuDr_separete
	set return=return_..Authority
	quit return
}

/// Creator：     wuqk
/// CreatDate：   2010-04-06
/// Description:  根据ID取权限信息
/// Table：       DHCMed.SS.Security
/// Input：       ID:    DHCMed.SS.Security.ID
///               separete: 指定的分隔符
/// Return：      返回obj.ToString()
/// w ##class(DHCMed.SS.Security).GetObjById(1)
ClassMethod GetObjById(id As %String) As DHCMed.SS.Security
{
	new (id)
	set return=""
	quit:id="" return
	quit:'##class(DHCMed.SS.Security).%ExistsId(+id) return
	set obj=##Class(DHCMed.SS.Security).%OpenId(+id)
	set return=obj
	do obj.%Close()
	quit return
}

/// Creator：     wuqk
/// CreatDate：   2010-04-06
/// Description:  根据ID取权限信息
/// Table：       DHCMed.SS.Security
/// Input：       ID:    DHCMed.SS.Security.ID
///               separete: 指定的分隔符
/// Return：      返回obj.ToString()
/// w ##class(DHCMed.SS.Security).GetStringById(1)
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
/// Description:  更新Security
/// Table：       DHCMed.SS.Security
/// Input：       groupId    安全组id
///               productId  产品Id
///               menuId     菜单Id
///               authority  是否有权限访问 1：有权限，0：无权限
/// Return：      成功：返回id，失败：返回<0的代码
ClassMethod Update(groupId, productId, menuId, authority) As %String
{
	new (groupId, productId, menuId, authority)
	set id=""
	quit:(groupId="")||(menuId="") return
	
	if $d(^DHCMed.SS.SecurityI("IndexOfMenu",+groupId,+menuId)) {
		set id=$o(^DHCMed.SS.SecurityI("IndexOfMenu",+groupId,+menuId,""))
	} else {
		if $d(^DHCMed.SS.SecurityI("IndexOfGPM",+groupId,+productId,+menuId)) {
			set id=$o(^DHCMed.SS.SecurityI("IndexOfGPM",+groupId,+productId,+menuId,""))
		}
	}
	
	if id'="" {
		set obj = ##class(DHCMed.SS.Security).%OpenId(id)
	}else{
		set obj = ##class(DHCMed.SS.Security).%New()
	}
	set obj.SSGroupDr=+groupId
	set obj.ProductDr=+productId
	set obj.MenuDr=+menuId
	set obj.Authority=$s(+authority=0:0,1:1)
	set sc=obj.%Save()
	if $system.Status.IsError(sc) {                               //检查Save是否成功
   		d $system.OBJ.DisplayError(sc) 
   		set id=-1
	}else{
		set id=obj.%Id()
	}
	do obj.%Close()
	quit id
}

/// Creator：     wuqk
/// CreatDate：   2010-03-24
/// Description:  删除Security
/// Table：       DHCMed.SS.Security
/// Input：       SecurityId
/// Return：      成功：返回0，失败：返回<0的代码
ClassMethod DeleteById(Id)
{
	new (Id)
	set sc = ##class(DHCMed.SS.Security).%DeleteId(+Id)
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
/// Description:  检查安全组对指定菜单是否有权限访问
/// Table：       DHCMed.SS.Security
/// Input：       groupId  安全组Id
///               menuId   菜单Id
/// Return：      1：有权限，0：无权限
ClassMethod CheckAuthority(groupId As %String, menuId As %String)
{
	new (groupId, menuId)
	set authority=0
	//w !,"groupId="_groupId_" "
	if $d(^DHCMed.SS.SecurityI("IndexOfMenu",groupId,menuId)){
		set securityId=$o(^DHCMed.SS.SecurityI("IndexOfMenu",groupId,menuId,""))
		//w " securityId="_securityId
		set obj=##class(DHCMed.SS.Security).%OpenId(securityId)
		set authority=obj.Authority
		do obj.%Close()
	}
	quit +authority
}

Storage Default
{
<Data name="SecurityDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>MenuDr</Value>
</Value>
<Value name="3">
<Value>ProductDr</Value>
</Value>
<Value name="4">
<Value>SSGroupDr</Value>
</Value>
<Value name="5">
<Value>Authority</Value>
</Value>
</Data>
<DataLocation>^DHCMed.SS.SecurityD</DataLocation>
<DefaultData>SecurityDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMed.SS.SecurityD</IdLocation>
<IndexLocation>^DHCMed.SS.SecurityI</IndexLocation>
<StreamLocation>^DHCMed.SS.SecurityS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
