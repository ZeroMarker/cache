/// 名称: CT.IPMR.BT.Menus
/// 描述: 菜单
/// 创建者：liyi
/// 创建日期: 2019-12-11
Class CT.IPMR.BT.Menus Extends (%Persistent, MA.IPMR.Abstract, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

Relationship ChildOper As CT.IPMR.BT.MenuOper [ Cardinality = children, Inverse = Parref ];

/// 菜单代码
Property BMCode As %String(TRUNCATE = 1) [ Required ];

/// 菜单名称
Property BMDesc As %String(TRUNCATE = 1) [ Required ];

/// 目标地址
Property BMLinkUrl As %String(TRUNCATE = 1);

/// 表达式
Property BMExpression As %String(MAXLEN = 100, TRUNCATE = 1);

/// 显示顺序
Property BMShowOrder As %Integer;

/// 图标样式
Property BMIconClass As %String(TRUNCATE = 1);

/// 父菜单指针
Property BMParentMenuID As %Integer;

Index IndexCode On BMCode [ Unique ];

Index IndexShowOrder On (BMParentMenuID, BMShowOrder);

/// Creator：     liyi
/// CreatDate：   2020-01-06
/// Description:  获取菜单的目标链接
/// Table：       CT.IPMR.BT.Menus
/// Input：       aid：  菜单项Id
/// Return：      返回菜单的目标链接
/// w ##class(CT.IPMR.BT.Menus).GetLinkUrl(1)
ClassMethod GetLinkUrl(aid As %String) As %String
{
	new (aid)
	set LinkUrl=""
	set obj=..GetObjById(+aid)
	if $IsObject(obj){
		set Desc=obj.BMDesc
		set LinkUrl=obj.BMLinkUrl		
		set Expression=obj.BMExpression
	}
	if (LinkUrl'=""){ 
		set LinkUrl=LinkUrl_"?1=1"_Expression
	}
	quit LinkUrl
}

/// Creator：     liyi
/// CreatDate：   2020-01-06
/// Description:  根据ID取菜单
/// Table：       CT.IPMR.BT.Menus
/// Input：       ID:    CT.IPMR.BT.Menus.ID
/// Return：      返回obj
/// w ##class(CT.IPMR.BT.Menus).GetObjById(1)
ClassMethod GetObjById(aId As %String) As CT.IPMR.BT.Menus
{
	new (aId)
	quit:'##class(CT.IPMR.BT.Menus).%ExistsId(aId) ""
	set obj=##Class(CT.IPMR.BT.Menus).%OpenId(aId)
	do:obj'="" obj.%Close()
	quit obj
}

/// Creator：     liyi
/// CreatDate：   2020-01-06
/// Description:  更新菜单
/// Table：       CT.IPMR.BT.Menus
/// Input：       InputStr ：菜单数据
///               Separate : 分隔符
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(CT.IPMR.BT.Menus).Update("25^ma.ipmr.ss.vollendqry^借阅查询^ma.ipmr.ss.vollendqry.csp^&MrClass=I^10^^","^")
ClassMethod Update(aInputStr As %String, aSeparate As %String) As %String
{
	New (aInputStr,aSeparate)
	Set return=0
	Quit:(aInputStr="")||(aSeparate="") return
	
	Set ID				= $p(aInputStr,aSeparate,1)
	Set Code			= $p(aInputStr,aSeparate,2)
	Set Desc 			= $p(aInputStr,aSeparate,3)
	Set LinkUrl 		= $p(aInputStr,aSeparate,4)
	Set Expression		= $p(aInputStr,aSeparate,5)
	Set ShowOrder		= +$p(aInputStr,aSeparate,6)
	Set IconClass		= $p(aInputStr,aSeparate,7)
	Set ParentMenuID	= +$p(aInputStr,aSeparate,8)
	Quit:(Code="")||(Desc="") return
	
	if ID="" {
		Set tID = $o(^CT.IPMR.BT.MenusI("IndexCode"," "_$ZCVT(Code,"U"),0))
		Set ID=tID
	}
	
	if ID="" {
		Set obj=##class(CT.IPMR.BT.Menus).%New()
	}else {
		Set obj=##class(CT.IPMR.BT.Menus).%OpenId(ID)
	}
	set obj.BMCode			= Code
	set obj.BMDesc			= Desc
	set obj.BMLinkUrl		= LinkUrl
	set obj.BMExpression	= Expression
	set obj.BMShowOrder		= ShowOrder	
	set obj.BMIconClass		= IconClass
	set obj.BMParentMenuID	= ParentMenuID
	Set sc=obj.%Save()
	If $system.Status.IsError(sc) {        //检查Save是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	}Else{
		Set return=obj.%Id()
	}
	Do obj.%Close()
	quit return
}

/// Creator：     liyi
/// CreatDate：   2020-01-06
/// Description:  删除Menu
/// Table：       CT.IPMR.BT.Menus
/// Input：       MenuId
/// Return：      成功：返回0，失败：返回<0的代码
ClassMethod DeleteById(aId)
{
	new (aId)
	set return=0
	quit:aId="" return
	set sc = ##class(CT.IPMR.BT.Menus).%DeleteId(+aId)
	if $system.Status.IsError(sc) {  //检查删除是否成功
   		d $system.OBJ.DisplayError(sc) 
   		set return=-1
	}else{
		set return=1
	}
	quit return
}

Storage Default
{
<Data name="DefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BMCode</Value>
</Value>
<Value name="3">
<Value>BMDesc</Value>
</Value>
<Value name="4">
<Value>BMLinkUrl</Value>
</Value>
<Value name="5">
<Value>BMExpression</Value>
</Value>
<Value name="6">
<Value>BMShowOrder</Value>
</Value>
<Value name="7">
<Value>BMIconClass</Value>
</Value>
<Value name="8">
<Value>BMParentMenuID</Value>
</Value>
</Data>
<DataLocation>^CT.IPMR.BT.MenusD</DataLocation>
<DefaultData>DefaultData</DefaultData>
<IdLocation>^CT.IPMR.BT.MenusD</IdLocation>
<IndexLocation>^CT.IPMR.BT.MenusI</IndexLocation>
<StreamLocation>^CT.IPMR.BT.MenusS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
