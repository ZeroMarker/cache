/// 名称: DHCHAI.IR.CRuleDefExt
/// 描述: 医院感染诊断定义
/// 编写者：chenjb
/// 编写日期: 2017-01-17
Class DHCHAI.IR.CRuleDefExt Extends (%Persistent, DHCHAI.Abstract, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

Relationship Parref As DHCHAI.IR.CRuleDef [ Cardinality = parent, Inverse = ChildItem ];

/// 诊断定义
Property BTTitle As %String(MAXLEN = 500, TRUNCATE = 1);

/// 诊断解读
Property BTNote As %String(MAXLEN = 1000, TRUNCATE = 1);

/// 诊断类型
Property BTTypeDr As DHCHAI.BT.Dictionary;

/// 排序码	BT_IndNo
Property BTIndNo As %String(TRUNCATE = 1);

/// 是否有效
Property BTIsActive As %Boolean;

/// Creator：     chenjb
/// CreatDate：   2017-01-17
/// Description:  根据ID取医院感染诊断条目信息
/// Table：       DHCHAI.IR.CRuleDefExt
/// Input：       aId : DHCHAI.IR.CRuleDefExt.ID
/// Return：      返回obj
/// w ##class(DHCHAI.IR.CRuleDefExt).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCHAI.IR.CRuleDefExt
{
	New (aId)
	Quit:'##class(DHCHAI.IR.CRuleDefExt).%ExistsId(aId) ""
	Set obj=##Class(DHCHAI.IR.CRuleDefExt).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     chenjb
/// CreatDate：   2017-01-17
/// Description:  更新医院感染诊断条目信息
/// Table：       DHCHAI.IR.CRuleDefExt
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCHAI.IR.CRuleDefExt).Update("^1^1^2017-01-16^1^2017-01-17^11:33:00","")
ClassMethod Update(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=0
	Quit:aInputStr="" return
	
	Set:$g(aSeparete)="" aSeparete=..#SEPARATE
	Set Parref   = $p(aInputStr,aSeparete,1)
	Set ChildSub = $p(aInputStr,aSeparete,2)
	Set Title    = $p(aInputStr,aSeparete,3)
	Set Note     = $p(aInputStr,aSeparete,4)
	Set TypeDr   = $p(aInputStr,aSeparete,5)
	Set IndNo    = $p(aInputStr,aSeparete,6)
	Set IsActive = +$p(aInputStr,aSeparete,7)
	Quit:(Parref="")||(Title="") return
	
	Set objParref=##class(DHCHAI.IR.CRuleDef).GetObjById(Parref)
	Quit:'$IsObject(objParref) return
	Set objType=##class(DHCHAI.BT.Dictionary).GetObjById(TypeDr)
	Quit:'$IsObject(objType) return
	
	If ChildSub="" {
		Set obj=##class(DHCHAI.IR.CRuleDefExt).%New()
	}Else{
		Set obj=##class(DHCHAI.IR.CRuleDefExt).%OpenId(Parref_"||"_ChildSub)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.Parref     = objParref
	Set obj.BTTitle    = Title
	Set obj.BTNote     = Note
	Set obj.BTTypeDr   = objType
	Set obj.BTIndNo    = IndNo
	Set obj.BTIsActive = IsActive
	
	Set sc=obj.%Save()
	If $system.Status.IsError(sc) {        //检查Save是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	}Else{
		Set return=obj.%Id()
	}
	Do obj.%Close()
	
	Quit return
}

/// Creator：     chenjb
/// CreatDate：   2017-01-17
/// Description:  删除医院感染诊断条目信息
/// Table：       DHCHAI.IR.CRuleDefExt
/// Input：       aId : DHCHAI.IR.CRuleDefExt.ID
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(DHCHAI.IR.CRuleDefExt).DeleteById(1)
ClassMethod DeleteById(aId As %String) As %String
{
	New (aId)
	Set sc = ##class(DHCHAI.IR.CRuleDefExt).%DeleteId(aId)
	If $system.Status.IsError(sc) {            //检查删除是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	} Else {
		Set return=0
	}
	Quit return
}

Storage Default
{
<Data name="CCRuleDefItemDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BTTitle</Value>
</Value>
<Value name="3">
<Value>BTNote</Value>
</Value>
<Value name="4">
<Value>BTTypeDr</Value>
</Value>
<Value name="5">
<Value>BTIndNo</Value>
</Value>
<Value name="6">
<Value>BTIsActive</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("ITM")</DataLocation>
<DefaultData>CCRuleDefItemDefaultData</DefaultData>
<IdLocation>{%%PARENT}("ITM")</IdLocation>
<IndexLocation>^DHCHAI.IR.CRuleDefI("ITM")</IndexLocation>
<StreamLocation>^DHCHAI.IR.CRuleDefExtS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
