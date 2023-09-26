/// 名称:		DHCMA.CPW.LOG.LogTableExt
/// 描述：		日志实体子类
/// 创建者：	yankai
/// 创建日期：	2022-07-13
Class DHCMA.CPW.LOG.LogTableExt Extends (%Persistent, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

Relationship Parref As DHCMA.CPW.LOG.LogTable [ Cardinality = parent, Inverse = ChildExt ];

/// 字段名称
Property ProperName As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 修改前值
Property OldValue As %String(MAXLEN = 500, TRUNCATE = 1);

/// 修改后值
Property NewValue As %String(MAXLEN = 500, TRUNCATE = 1);

/// Creator：     yankai
/// CreatDate：   2022-07-15
/// Description:  更新记录
/// Table：       DHCMA.CPW.LOG.LogTableExt
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCMA.CPW.LOG.LogTableExt).Update("")
ClassMethod Update(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=0
	Quit:aInputStr="" return
	
	Set:$g(aSeparete)="" aSeparete="^"
	Set Parref		    = $p(aInputStr,aSeparete,1)
	Set ChilID       	= $p(aInputStr,aSeparete,2)
	Set ProperName      = $p(aInputStr,aSeparete,3)
	Set OldValue      	= $p(aInputStr,aSeparete,4)
	Set NewValue		= $p(aInputStr,aSeparete,5)
	
	Set objParref=##class(DHCMA.CPW.LOG.LogTable).GetObjById(Parref)
	Quit:'$IsObject(objParref) -2
		
	If ChilID="" {
		Set obj=##class(DHCMA.CPW.LOG.LogTableExt).%New()
	}Else{
		Set obj=##class(DHCMA.CPW.LOG.LogTableExt).%OpenId(Parref_"||"_ChilID)
	}
	Quit:'$IsObject(obj) return
		
	Set obj.Parref   	= objParref  
	Set obj.ProperName	= ProperName  
	Set obj.OldValue   	= OldValue
	Set obj.NewValue   	= NewValue

	Set sc=obj.%Save()
	if $system.Status.IsError(sc) {        //检查Save是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	}else{
		Set return=obj.%Id()
	}
	Do obj.%Close()
	
	Quit return
}

Storage Default
{
<Data name="LogTableExtDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ProperName</Value>
</Value>
<Value name="3">
<Value>OldValue</Value>
</Value>
<Value name="4">
<Value>NewValue</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("EXT")</DataLocation>
<DefaultData>LogTableExtDefaultData</DefaultData>
<IdLocation>{%%PARENT}("EXT")</IdLocation>
<IndexLocation>^DHCMA.CPW.LOG.LogTableI("EXT")</IndexLocation>
<StreamLocation>^DHCMA.CPW.LOG.LogTableExtS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
