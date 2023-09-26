/// 名称: DHCHAI.IR.CRuleDef
/// 描述: 医院感染诊断标准
/// 编写者：chenjb
/// 编写日期: 2017-01-17
Class DHCHAI.IR.CRuleDef Extends (%Persistent, DHCHAI.Abstract, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 感染诊断条目
Relationship ChildItem As DHCHAI.IR.CRuleDefExt [ Cardinality = children, Inverse = Parref ];

/// 感染诊断（部位）
Property BTInfPosDr As DHCHAI.BT.InfPos;

/// 标准定义
Property BTTitle As %String(MAXLEN = 200, TRUNCATE = 1);

/// 标准解读
Property BTNote As %String(MAXLEN = 1000, TRUNCATE = 1);

/// 排序码
Property BTIndNo As %String(TRUNCATE = 1);

/// 是否有效
Property BTIsActive As %Boolean;

/// 年龄大于（岁）
Property BTMaxAge As %Integer;

/// 年龄小于（岁）
Property BTMinAge As %Integer;

/// 感染部位索引
Index IndexBTInfPosDr On BTInfPosDr;

/// Creator：     chenjb
/// CreatDate：   2017-01-17
/// Description:  根据ID取医院感染诊断标准信息
/// Table：       DHCHAI.IR.CRuleDef
/// Input：       aId : DHCHAI.IR.CRuleDef.ID
/// Return：      返回obj
/// w ##class(DHCHAI.IR.CRuleDef).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCHAI.IR.CRuleDef
{
	New (aId)
	Quit:'##class(DHCHAI.IR.CRuleDef).%ExistsId(aId) ""
	Set obj=##Class(DHCHAI.IR.CRuleDef).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     chenjb
/// CreatDate：   2017-01-17
/// Description:  更新医院感染诊断标准信息
/// Table：       DHCHAI.IR.CRuleDef
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCHAI.IR.CRuleDef).Update("^1^1^2017-01-16^1^2017-01-17^11:33:00","")
ClassMethod Update(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=0
	Quit:aInputStr="" return
	
	Set:$g(aSeparete)="" aSeparete=..#SEPARATE
	Set ID       = $p(aInputStr,aSeparete,1)
	Set InfPosDr = $p(aInputStr,aSeparete,2)
	Set Title    = $p(aInputStr,aSeparete,3)
	Set Note     = $p(aInputStr,aSeparete,4)
	Set IndNo    = $p(aInputStr,aSeparete,5)
	Set IsActive = +$p(aInputStr,aSeparete,6)
	Set MaxAge   = +$p(aInputStr,aSeparete,7)
	Set MinAge   = +$p(aInputStr,aSeparete,8)
	Quit:(InfPosDr="")||(Title="") return
	
	// 感染部位 唯一性
	Set tID =$o(^DHCHAI.IR.CRuleDefI("IndexBTInfPosDr",InfPosDr,"0")) 
	Quit:ID'=tID -100

	Set objInfPos=##class(DHCHAI.BT.InfPos).GetObjById(InfPosDr)
	Quit:'$IsObject(objInfPos) return
	
	//Set:MaxAge=0 MinAge=""
	//Set:MinAge=0 MinAge=""
	
	If ID="" {
		Set obj=##class(DHCHAI.IR.CRuleDef).%New()
	}Else{
		Set obj=##class(DHCHAI.IR.CRuleDef).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.BTInfPosDr = objInfPos
	Set obj.BTTitle    = Title
	Set obj.BTNote     = Note
	Set obj.BTIndNo    = IndNo
	Set obj.BTIsActive = IsActive
	Set obj.BTMaxAge   = MaxAge
	Set obj.BTMinAge   = MinAge
	
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
/// Description:  删除医院感染诊断标准信息
/// Table：       DHCHAI.IR.CRuleDef
/// Input：       aId : DHCHAI.IR.CRuleDef.ID
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(DHCHAI.IR.CRuleDef).DeleteById(1)
ClassMethod DeleteById(aId As %String) As %String
{
	New (aId)
	Set sc = ##class(DHCHAI.IR.CRuleDef).%DeleteId(aId)
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
<Data name="CCRuleDefDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BTInfPosDr</Value>
</Value>
<Value name="3">
<Value>BTTitle</Value>
</Value>
<Value name="4">
<Value>BTNote</Value>
</Value>
<Value name="5">
<Value>BTIndNo</Value>
</Value>
<Value name="6">
<Value>BTIsActive</Value>
</Value>
<Value name="7">
<Value>BTMaxAge</Value>
</Value>
<Value name="8">
<Value>BTMinAge</Value>
</Value>
</Data>
<DataLocation>^DHCHAI.IR.CRuleDefD</DataLocation>
<DefaultData>CCRuleDefDefaultData</DefaultData>
<IdLocation>^DHCHAI.IR.CRuleDefD</IdLocation>
<IndexLocation>^DHCHAI.IR.CRuleDefI</IndexLocation>
<StreamLocation>^DHCHAI.IR.CRuleDefS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
