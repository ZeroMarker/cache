Class CT.DHCINM.DB.MgQualItem Extends %Persistent
{

Relationship ChildSub As CT.DHCINM.DB.MgQualItemSub [ Cardinality = children, Inverse = Parref ];

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

/// 评分类型 1:是否模式 2:符合模式 3:得分模式 4:扣分模式 5:选项模式 6:扣分原因模式
/// 按比例时默认是否模式,按分值时默认得分模式,兼容3.0标版
Property QualScoreTypeSub As %String [ SqlColumnNumber = 8, SqlFieldName = Qual_ScoreTypeSub ];

/// 评价模式 按分值选项模式有效 1:统一 2:自定义
Property QualStandardMode As %String [ SqlColumnNumber = 9, SqlFieldName = Qual_StandardMode ];

/// 评价标准 按比例或按分值选项模式统一选项时有效
Property QualStandardList As %String(MAXLEN = 500) [ SqlColumnNumber = 10, SqlFieldName = Qual_StandardList ];

/// 插入列 1:患者 2:护士 3:自定义
Property QualInsert As %String [ SqlColumnNumber = 11, SqlFieldName = Qual_Insert ];

/// 插入列默认列数
Property QualInsertCount As %String [ InitialExpression = 1, SqlColumnNumber = 12, SqlFieldName = Qual_InsertCount ];

/// 达标线
Property QualPass As %String [ SqlColumnNumber = 13, SqlFieldName = Qual_Pass ];

/// 启用日期
Property QualStDate As %Date [ SqlColumnNumber = 14, SqlFieldName = Qual_StDate ];

/// 停用日期
Property QualEndDate As %Date [ SqlColumnNumber = 15, SqlFieldName = Qual_EndDate ];

/// 符合模式是否使用分数
Property QualScoreFlag As %String [ SqlColumnNumber = 16, SqlFieldName = Qual_ScoreFlag ];

/// 质控种类
Property QualClassDR As %String [ SqlColumnNumber = 17, SqlFieldName = Qual_ClassDR ];

Index year On (QualYear, QualCode, QualType);

Index Type On (QualYear, QualType);

Index Code On QualCode;

Storage Default
{
<Data name="MgQualItemDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>QualYear</Value>
</Value>
<Value name="3">
<Value>QualCode</Value>
</Value>
<Value name="4">
<Value>QualDesc</Value>
</Value>
<Value name="5">
<Value>QualType</Value>
</Value>
<Value name="6">
<Value>QualScore</Value>
</Value>
<Value name="7">
<Value>QualScoreType</Value>
</Value>
<Value name="8">
<Value>QualScoreTypeSub</Value>
</Value>
<Value name="9">
<Value>QualStandardMode</Value>
</Value>
<Value name="10">
<Value>QualStandardList</Value>
</Value>
<Value name="11">
<Value>QualInsert</Value>
</Value>
<Value name="12">
<Value>QualInsertCount</Value>
</Value>
<Value name="13">
<Value>QualPass</Value>
</Value>
<Value name="14">
<Value>QualStDate</Value>
</Value>
<Value name="15">
<Value>QualEndDate</Value>
</Value>
<Value name="16">
<Value>QualScoreScoreFlag</Value>
</Value>
<Value name="17">
<Value>QualScoreFlag</Value>
</Value>
<Value name="18">
<Value>QualClassDR</Value>
</Value>
</Data>
<DataLocation>^CT.DHCINM.DB.MgQualItemD</DataLocation>
<DefaultData>MgQualItemDefaultData</DefaultData>
<IdLocation>^CT.DHCINM.DB.MgQualItemD</IdLocation>
<IndexLocation>^CT.DHCINM.DB.MgQualItemI</IndexLocation>
<StreamLocation>^CT.DHCINM.DB.MgQualItemS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
