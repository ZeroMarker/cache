/// Creator:guozj
/// Descriptions:质控重组模板
/// Date:2017-09-14
/// 
Class DHCNMG.DB.MgQualModel Extends %Persistent
{

Relationship ChildSub As DHCNMG.DB.MgQualModelSub [ Cardinality = children, Inverse = Parref ];

/// 年份
Property RestructYear As %Integer [ SqlColumnNumber = 2, SqlFieldName = Restruct_Year ];

/// 代码
Property RestructCode As %String [ SqlColumnNumber = 3, SqlFieldName = Restruct_Code ];

/// 描述
Property RestructDesc As %String [ SqlColumnNumber = 4, SqlFieldName = Restruct_Desc ];

/// 分值
Property RestructScore As %String [ SqlColumnNumber = 5, SqlFieldName = Restruct_Score ];

/// 质控类型
Property RestructType As %String [ SqlColumnNumber = 6, SqlFieldName = Restruct_Type ];

/// 检查小组
Property RestructGroup As DHCNMG.DB.MgQualGroup [ SqlColumnNumber = 7, SqlFieldName = Restruct_Group ];

/// 评分类型。1：按比例。2：按分值；空为按比例
Property RestructScoreType As %String [ SqlColumnNumber = 8, SqlFieldName = Restruct_ScoreType ];

/// 质控分层：H:护理部。L:大科。W:病区
Property RestructLevel As %String [ SqlColumnNumber = 9, SqlFieldName = Restruct_Level ];

/// 质控分层大科或病区id。和维护人有关
Property RestructLevelId As %String [ SqlColumnNumber = 10, SqlFieldName = Restruct_LevelId ];

/// 创建/修改人
Property RestructPerDR As DHCNMG.HR.MgPersons [ SqlColumnNumber = 11, SqlFieldName = Restruct_PerDR ];

Index Flag On (RestructYear, RestructCode, RestructType);

Storage Default
{
<Data name="MgQualModelDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>RestructYear</Value>
</Value>
<Value name="3">
<Value>RestructCode</Value>
</Value>
<Value name="4">
<Value>RestructDesc</Value>
</Value>
<Value name="5">
<Value>RestructScore</Value>
</Value>
<Value name="6">
<Value>RestructType</Value>
</Value>
<Value name="7">
<Value>RestructScoreType</Value>
</Value>
<Value name="8">
<Value>RestructGroup</Value>
</Value>
<Value name="9">
<Value>RestructLevel</Value>
</Value>
<Value name="10">
<Value>RestructLevelId</Value>
</Value>
<Value name="11">
<Value>RestructPerDR</Value>
</Value>
</Data>
<DataLocation>^DHCNMG.DB.MgQualModelD</DataLocation>
<DefaultData>MgQualModelDefaultData</DefaultData>
<IdLocation>^DHCNMG.DB.MgQualModelD</IdLocation>
<IndexLocation>^DHCNMG.DB.MgQualModelI</IndexLocation>
<StreamLocation>^DHCNMG.DB.MgQualModelS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
