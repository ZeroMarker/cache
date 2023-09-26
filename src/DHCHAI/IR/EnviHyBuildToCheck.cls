/// 描述: 环境卫生学不正确原因具体
/// 编写日期: 2022-06-15
Class DHCHAI.IR.EnviHyBuildToCheck Extends %SerialObject
{

/// 不正确原因
Property Reason As %String;

/// 改进措施
Property Action As %String;

/// Creator：     liuzhenhe
/// CreatDate：   2022-06-28
/// Description:  取环境卫生学不合格处理方案措施
/// Return：      返回obj
/// w ##class(DHCHAI.IR.EnviHyBuildToCheck).GetObj()
ClassMethod GetObj(aInput As %String, aSeparate As %String = "^") As DHCHAI.IR.EnviHyBuildToCheck
{
    Set return=""
    
    Set obj=##Class(DHCHAI.IR.EnviHyBuildToCheck).%New()
    If obj'="" Do obj.%Close()
    
    Set obj.Reason=$p(aInput,aSeparate,1)
    Set obj.Action=$p(aInput,aSeparate,2)
    
    Set return=obj
    Quit return
}

Method ToString(aSeparate As %String = "^") As %String
{
    Set return=""
    Set return=..Reason_aSeparate_..Action
    Quit return
}

Storage Default
{
<Data name="EnviHyBuildToCheckState">
<Value name="1">
<Value>Reason</Value>
</Value>
<Value name="2">
<Value>Action</Value>
</Value>
</Data>
<State>EnviHyBuildToCheckState</State>
<StreamLocation>^DHCHAI.IR.EnviHyBuildToCheckS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
