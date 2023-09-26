/// Creator:王聪聪
/// Descriptions:评估考核维度项目维护
/// Date:2019-09-06
Class DHCNMG.DB.MgAssessItem Extends %Persistent
{

Relationship ChildSub As DHCNMG.DB.MgAssessItemSub [ Cardinality = children, Inverse = Parref ];

/// 年份
Property AssessYear As %Integer [ SqlColumnNumber = 2, SqlFieldName = Assess_Year ];

/// 项目代码
Property AssessCode As %String [ SqlColumnNumber = 3, SqlFieldName = Assess_Code ];

/// 项目名称
Property AssessDesc As %String [ SqlColumnNumber = 4, SqlFieldName = Assess_Desc ];

/// 维度类型
Property AssessType As DHCNMG.Set.MgSysParamSub [ SqlColumnNumber = 5, SqlFieldName = Assess_Type ];

/// 分值
Property AssessScore As %String [ SqlColumnNumber = 6, SqlFieldName = Assess_Score ];

Index year On (AssessYear, AssessType);

Index desc On (AssessType, AssessDesc);

Index type On AssessType;

Storage Default
{
<Data name="MgAssessItemDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>UpdateDate</Value>
</Value>
<Value name="3">
<Value>AssessCode</Value>
</Value>
<Value name="4">
<Value>AssessDesc</Value>
</Value>
<Value name="5">
<Value>AssessType</Value>
</Value>
<Value name="6">
<Value>AssessScore</Value>
</Value>
<Value name="7">
<Value>AssessYear</Value>
</Value>
</Data>
<DataLocation>^DHCNMG.DB.MgAssessItemD</DataLocation>
<DefaultData>MgAssessItemDefaultData</DefaultData>
<IdLocation>^DHCNMG.DB.MgAssessItemD</IdLocation>
<IndexLocation>^DHCNMG.DB.MgAssessItemI</IndexLocation>
<StreamLocation>^DHCNMG.DB.MgAssessItemS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
