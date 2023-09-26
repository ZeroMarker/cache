/// Creator:谷雪萍
/// CreatDate:2018-05-05
/// Description：评分表（评分型）注册表
/// Table：CT.WDT.CDSS.AssBase
Class CT.WDT.CDSS.AssBase Extends (%Persistent, User.Abstract) [ SqlTableName = AssBase ]
{

Relationship ChildField As CT.WDT.CDSS.AssBaseField [ Cardinality = children, Inverse = MKBABFParRef ];

Relationship ChildRules As CT.WDT.CDSS.AssScoringRules [ Cardinality = children, Inverse = MKBASRParRef ];

/// 代码
Property MKBABCode As %String(MAXLEN = "") [ SqlColumnNumber = 2, SqlFieldName = MKBAB_Code ];

/// 标题
Property MKBABDesc As %String(MAXLEN = "") [ SqlColumnNumber = 3, SqlFieldName = MKBAB_Desc ];

/// 备注
Property MKBABNote As %String(MAXLEN = "") [ SqlColumnNumber = 4, SqlFieldName = MKBAB_Note ];

/// 版本
Property MKBABVersion As %String [ SqlColumnNumber = 5, SqlFieldName = MKBAB_Version ];

/// 状态
Property MKBABState As %String [ SqlColumnNumber = 6, SqlFieldName = MKBAB_State ];

/// 编辑人
Property MKBABUpdateUser As %String [ SqlColumnNumber = 7, SqlFieldName = MKBAB_UpdateUser ];

/// 编辑时间
Property MKBABUpdateDate As %TimeStamp [ SqlColumnNumber = 8, SqlFieldName = MKBAB_UpdateDate ];

/// 审核人
Property MKBABAuditUser As %String [ SqlColumnNumber = 9, SqlFieldName = MKBAB_AuditUser ];

/// 审核时间
Property MKBABAuditDate As %TimeStamp [ SqlColumnNumber = 10, SqlFieldName = MKBAB_AuditDate ];

/// 类型（评估量表、医学计算器）
Property MKBABType As %String [ SqlColumnNumber = 11, SqlFieldName = MKBAB_Type ];

/// 代码索引
Index CodeIndex On MKBABCode [ Unique ];

/// 标题索引
Index DescIndex On MKBABDesc;

/// 版本索引
Index DescVersionIndex On (MKBABDesc, MKBABVersion);

Storage Default
{
<Data name="AssBaseDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>MKBABCode</Value>
</Value>
<Value name="3">
<Value>MKBABDesc</Value>
</Value>
<Value name="4">
<Value>MKBABNote</Value>
</Value>
<Value name="5">
<Value>MKBABVersion</Value>
</Value>
<Value name="6">
<Value>MKBABState</Value>
</Value>
<Value name="7">
<Value>MKBABUpdateUser</Value>
</Value>
<Value name="8">
<Value>MKBABUpdateDate</Value>
</Value>
<Value name="9">
<Value>MKBABAuditUser</Value>
</Value>
<Value name="10">
<Value>MKBABAuditDate</Value>
</Value>
<Value name="11">
<Value>MKBABType</Value>
</Value>
</Data>
<DataLocation>^CT.WDT.CDSS.AssBaseD</DataLocation>
<DefaultData>AssBaseDefaultData</DefaultData>
<IdLocation>^CT.WDT.CDSS.AssBaseD</IdLocation>
<IndexLocation>^CT.WDT.CDSS.AssBaseI</IndexLocation>
<StreamLocation>^CT.WDT.CDSS.AssBaseS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
