/// 名称: DHCMed.SS.SecurityPortlets
/// 描述: 医政管理页签权限表
/// 编写者：wuqk
/// 编写日期: 2010-03-24
Class DHCMed.SS.SecurityPortlets Extends (%Persistent, DHCMed.Abstract, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 安全组指针
Property SSGroupDr As %Integer [ Required ];

/// 自定义页签指针
Property PortletsDr As %Integer [ Required ];

/// 权限
Property Authority As %Boolean;

Index IndexOfPor On (SSGroupDr, PortletsDr) [ Unique ];

/// Creator：     maxp
/// CreatDate：   2012-11-08
/// Description:  将对象格式化为字符串
/// Table：       DHCMed.SS.SecurityPortlets
/// Input：       separete:指定的分隔符
/// Return：      返回各属性值，按照separete分隔
/// 1:Rowid 2:SSGroupDr 3:PortletsDr  5:Authority
Method ToString(separete As %String) As %String
{
	if $g(separete)=""{
		set separete=..#SEPARATE
		} 
	set return=..%Id()_separete
	set return=return_..SSGroupDr_separete
	set return=return_..PortletsDr_separete
	set return=return_..Authority
	quit return
}

/// Creator：     maxp
/// CreatDate：   2012-11-08
/// Description:  根据ID取权限信息
/// Table：       DHCMed.SS.SecurityPortlets
/// Input：       ID:    DHCMed.SS.SecurityPortlets.ID
///               separete: 指定的分隔符
/// Return：      返回obj
/// w ##class(DHCMed.SS.SecurityPortlets).GetObjById(1)
ClassMethod GetObjById(id As %String) As DHCMed.SS.Security
{
	new (id)
	set return=""
	quit:id="" return
	quit:'##class(DHCMed.SS.SecurityPortlets).%ExistsId(+id) return
	set obj=##Class(DHCMed.SS.SecurityPortlets).%OpenId(+id)
	set return=obj
	do obj.%Close()
	quit return
}

/// Creator：     maxp
/// CreatDate：   2012-11-08
/// Description:  根据ID取权限信息
/// Table：       DHCMed.SS.SecurityPortlets
/// Input：       ID:    DHCMed.SS.SecurityPortlets.ID
///               separete: 指定的分隔符
/// Return：      返回obj.ToString()
/// w ##class(DHCMed.SS.SecurityPortlets).GetStringById(1)
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

/// Creator：     maxp
/// CreatDate：   2012-11-08
/// Description:  更新页签权限
/// Table：       DHCMed.SS.SecurityPortlets
/// Input：       groupId    安全组id
///               portletId     页签Id
///               authority  是否有权限访问 1：有权限，0：无权限
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCMed.SS.SecurityPortlets).Update("12","3","1")
ClassMethod Update(groupId, portletId, authority) As %String
{
	new (groupId, portletId, authority)
	set id=""
	if $d(^DHCMed.SS.SecurityPortletsI("IndexOfPor",groupId,portletId)) {
		set id = $o(^DHCMed.SS.SecurityPortletsI("IndexOfPor",groupId, portletId,""))
		set obj = ##class(DHCMed.SS.SecurityPortlets).%OpenId(id)
		}
	else{
		set obj = ##class(DHCMed.SS.SecurityPortlets).%New()
	}
	set obj.SSGroupDr=+groupId
	set obj.PortletsDr=+portletId
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

/// Creator：     maxp
/// CreatDate：   2012-11-08
/// Description:  检查安全组对指定页签是否有权限访问
/// Table：       DHCMed.SS.SecurityPortlets
/// Input：       groupId  安全组Id
///               portletId   页签Id
/// Return：      1：有权限，0：无权限
/// w ##class(DHCMed.SS.SecurityPortlets).CheckAuthority("12","22")
ClassMethod CheckAuthority(groupId As %String, portletId As %String)
{
	new (groupId, portletId)
	set authority=0
	if $d(^DHCMed.SS.SecurityPortletsI("IndexOfPor",groupId,portletId)){
		set securityId=$o(^DHCMed.SS.SecurityPortletsI("IndexOfPor",groupId,portletId,""))
		set obj=##class(DHCMed.SS.SecurityPortlets).%OpenId(securityId)
		set authority=obj.Authority
		do obj.%Close()
	}
	quit +authority
}

Storage Default
{
<Data name="SecurityPortletsDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Authority</Value>
</Value>
<Value name="3">
<Value>PortletsDr</Value>
</Value>
<Value name="4">
<Value>SSGroupDr</Value>
</Value>
</Data>
<DataLocation>^DHCMed.SS.SecurityPortletsD</DataLocation>
<DefaultData>SecurityPortletsDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMed.SS.SecurityPortletsD</IdLocation>
<IndexLocation>^DHCMed.SS.SecurityPortletsI</IndexLocation>
<StreamLocation>^DHCMed.SS.SecurityPortletsS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
