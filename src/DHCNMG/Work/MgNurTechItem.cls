/// Creator:gzj
/// Date:2019-04-16
/// Description:护理技术项目（目前为20项技术）
Class DHCNMG.Work.MgNurTechItem Extends %Persistent
{

Relationship ChildSub As DHCNMG.Work.MgNurTechItemSub [ Cardinality = children, Inverse = Parref ];

/// 项目名称
Property TechItem As %String [ SqlColumnNumber = 2, SqlFieldName = Tech_Item ];

/// 项目代码
Property TechCode As %String [ SqlColumnNumber = 3, SqlFieldName = Tech_Code ];

/// Y 有效 N 作废
Property TechState As %String [ SqlColumnNumber = 4, SqlFieldName = Tech_State ];

/// 作废人
Property Invalid As %String [ SqlColumnNumber = 5, SqlFieldName = Invalid ];

/// 作废日期
Property InvalidDate As %String [ SqlColumnNumber = 6, SqlFieldName = Invalid_Date ];

Index code On TechCode;

Index flag On (TechState, TechCode);

Storage Default
{
<Data name="MgNurTechItemDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>TechItem</Value>
</Value>
<Value name="3">
<Value>TechCode</Value>
</Value>
<Value name="4">
<Value>TechState</Value>
</Value>
<Value name="5">
<Value>Invalid</Value>
</Value>
<Value name="6">
<Value>InvalidDate</Value>
</Value>
</Data>
<DataLocation>^DHCNMG.Work.MgNurTechItemD</DataLocation>
<DefaultData>MgNurTechItemDefaultData</DefaultData>
<IdLocation>^DHCNMG.Work.MgNurTechItemD</IdLocation>
<IndexLocation>^DHCNMG.Work.MgNurTechItemI</IndexLocation>
<StreamLocation>^DHCNMG.Work.MgNurTechItemS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
