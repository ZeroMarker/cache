/// Creator:guozj
/// Descriptions:质控项目维护
/// Date:2017-09-07
/// 
Class DHCNMG.DB.MgQualItem Extends %Persistent
{

Relationship ChildSub As DHCNMG.DB.MgQualItemSub [ Cardinality = children, Inverse = Parref ];

/// 年份
Property QualYear As %Integer [ SqlColumnNumber = 2, SqlFieldName = Qual_Year ];

/// 项目代码
Property QualCode As %String [ SqlColumnNumber = 3, SqlFieldName = Qual_Code ];

/// 项目名称
Property QualDesc As %String [ SqlColumnNumber = 4, SqlFieldName = Qual_Desc ];

/// 质控类型
Property QualType As %String(MAXLEN = 500) [ SqlColumnNumber = 5, SqlFieldName = Qual_Type ];

/// 分值
Property QualScore As %String [ SqlColumnNumber = 6, SqlFieldName = Qual_Score ];

/// 评分类型1：按比例。2：按分值；空为按比例
Property QualScoreType As %String [ SqlColumnNumber = 7, SqlFieldName = Qual_ScoreType ];

Index year On (QualYear, QualCode, QualType);

Index Type On (QualYear, QualType);

Storage Default
{
<Data name="MgQualItemDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>QualCode</Value>
</Value>
<Value name="3">
<Value>QualYear</Value>
</Value>
<Value name="4">
<Value>QualDesc</Value>
</Value>
<Value name="5">
<Value>QualType</Value>
</Value>
<Value name="6">
<Value>QualStDate</Value>
</Value>
<Value name="7">
<Value>QualEndDate</Value>
</Value>
<Value name="8">
<Value>QualScore</Value>
</Value>
<Value name="9">
<Value>QualScoreType</Value>
</Value>
</Data>
<DataLocation>^DHCNMG.DB.MgQualItemD</DataLocation>
<DefaultData>MgQualItemDefaultData</DefaultData>
<IdLocation>^DHCNMG.DB.MgQualItemD</IdLocation>
<IndexLocation>^DHCNMG.DB.MgQualItemI</IndexLocation>
<StreamLocation>^DHCNMG.DB.MgQualItemS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
