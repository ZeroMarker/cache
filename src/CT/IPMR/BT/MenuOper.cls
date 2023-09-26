/// 名称: CT.IPMR.BT.MenuOper
/// 描述: 菜单操作权限
/// 创建者：liyi
/// 创建日期: 2019-12-11
Class CT.IPMR.BT.MenuOper Extends (%Persistent, MA.IPMR.Abstract, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

Relationship Parref As CT.IPMR.BT.Menus [ Cardinality = parent, Inverse = ChildOper ];

/// 操作代码
Property BMOperaCode As %String(TRUNCATE = 1) [ Required ];

/// 操作名称
Property BMOperaName As %String(TRUNCATE = 1) [ Required ];

Index IndexOperaCode On BMOperaCode [ Unique ];

/// Creator：     liyi
/// CreatDate：   2020-01-06
/// Description:  根据ID取菜单操作表
/// Table：       CT.IPMR.BT.MenuOper
/// Input：       ID:    CT.IPMR.BT.MenuOper.ID
/// Return：      返回obj
/// w ##class(CT.IPMR.BT.MenuOper).GetObjById(1)
ClassMethod GetObjById(aId As %String) As CT.IPMR.BT.MenuOper
{
	new (aId)
	quit:'##class(CT.IPMR.BT.MenuOper).%ExistsId(aId) ""
	set obj=##Class(CT.IPMR.BT.MenuOper).%OpenId(aId)
	do:obj'="" obj.%Close()
	quit obj
}

/// Creator：     liyi
/// CreatDate：   2020-01-06
/// Description:  更新菜单操作表
/// Table：       CT.IPMR.BT.MenuOper
/// Input：       InputStr ：菜单操作数据
///               Separate : 分隔符
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(CT.IPMR.BT.MenuOper).Update()
ClassMethod Update(aInputStr As %String, aSeparate As %String) As %String
{
	New (aInputStr,aSeparate)
	Set return=0
	Quit:(aInputStr="")||(aSeparate="") return
	
	Set ID			= $p(aInputStr,aSeparate,1)
	Set Parref		= $p(aInputStr,aSeparate,2)
	Set OperaCode 	= $p(aInputStr,aSeparate,3)
	Set OperaName 	= $p(aInputStr,aSeparate,4)
	Quit:(Parref="")||(OperaCode="")||(OperaName="") return
	Set objParref = ##class(CT.IPMR.BT.Menus).GetObjById(Parref)
	Quit:'$isobject(objParref) return
	
	Set tID = $o(^CT.IPMR.BT.MenusI("MenuOper","IndexOperaCode"," "_$ZCVT(OperaCode,"U"),Parref,0))
	Quit:tID'=ID -100
	
	if ID="" {
		Set obj=##class(CT.IPMR.BT.MenuOper).%New()
	}else {
		Set obj=##class(CT.IPMR.BT.MenuOper).%OpenId(ID)
	}
	set obj.Parref			= objParref
	set obj.BMOperaCode		= OperaCode
	set obj.BMOperaName		= OperaName
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
/// Description:  删除菜单操作表
/// Table：       CT.IPMR.BT.MenuOper
/// Input：       MenuId
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(CT.IPMR.BT.MenuOper).DeleteById("2||1")
ClassMethod DeleteById(aId)
{
	new (aId)
	set return=0
	quit:aId="" return
	set sc = ##class(CT.IPMR.BT.MenuOper).%DeleteId(aId)
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
<Value>BMOperaCode</Value>
</Value>
<Value name="3">
<Value>BMOperaName</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("MenuOper")</DataLocation>
<DefaultData>DefaultData</DefaultData>
<IdLocation>{%%PARENT}("MenuOper")</IdLocation>
<IndexLocation>^CT.IPMR.BT.MenusI("MenuOper")</IndexLocation>
<StreamLocation>^CT.IPMR.BT.MenuOperS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
