/// Writter:gzj
/// Date:2019-041-6
/// Description:护理技术项目z子表（目前为20项技术）
Class DHCNMG.Work.MgNurTechItemSub Extends %Persistent
{

Relationship Parref As DHCNMG.Work.MgNurTechItem [ Cardinality = parent, Inverse = ChildSub ];

/// 医嘱ID
Property OrderID As %String [ SqlColumnNumber = 2, SqlFieldName = OrderID ];

/// 护嘱ID 
Property NurOrder As %String [ SqlColumnNumber = 3, SqlFieldName = NurOrder ];

/// 状态 Y有效 N 无效
Property State As %String [ SqlColumnNumber = 4, SqlFieldName = State ];

/// 作废人
Property Operater As %String [ SqlColumnNumber = 5, SqlFieldName = Operater ];

/// 作废日期
Property OperateDate As %Date [ SqlColumnNumber = 6, SqlFieldName = OperateDate ];

Storage Default
{
<Data name="MgNurTechItemSubDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>OrderID</Value>
</Value>
<Value name="3">
<Value>NurOrder</Value>
</Value>
<Value name="4">
<Value>State</Value>
</Value>
<Value name="5">
<Value>Operater</Value>
</Value>
<Value name="6">
<Value>OperateDate</Value>
</Value>
</Data>
<DataLocation>^DHCNMG.Work.MgNurTechItemSubD</DataLocation>
<DefaultData>MgNurTechItemSubDefaultData</DefaultData>
<IdLocation>{%%PARENT}("ChildSub")</IdLocation>
<IndexLocation>^DHCNMG.Work.MgNurTechItemSubI</IndexLocation>
<StreamLocation>^DHCNMG.Work.MgNurTechItemSubS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
