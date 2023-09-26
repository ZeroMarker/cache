Class User.MKBGloAlias Extends %Persistent [ SqlRowIdName = MKBGA_RowId, SqlTableName = MKB_GloAlias ]
{

Relationship ParRef As User.MKBGlobal [ Cardinality = parent, Inverse = ChildGloAlias ];

/// 别名描述
Property MKBGADesc As %String(MAXLEN = "") [ SqlColumnNumber = 3, SqlFieldName = MKBGA_Desc ];

/// 拼音码
Property MKBGAPYCode As %String(MAXLEN = "") [ SqlColumnNumber = 4, SqlFieldName = MKBGA_PYCode ];

/// 备注
Property MKBGANote As %String(MAXLEN = "") [ SqlColumnNumber = 5, SqlFieldName = MKBGA_Note ];

/// 中英文标识
Property MKBGACEFlag As %String(DISPLAYLIST = ",中文别名,英文别名", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",C,E") [ SqlColumnNumber = 6, SqlFieldName = MKBGA_CEFlag ];

/// 状态
Property MKBGAState As %String(MAXLEN = "") [ SqlColumnNumber = 7, SqlFieldName = MKBGA_State ];

/// 顺序
Property MKBGASequence As %String(MAXLEN = "") [ SqlColumnNumber = 8, SqlFieldName = MKBGA_Sequence ];

/// 状态标记 中心词 展示名 别名
Property MKBGAMark As %String(MAXLEN = "") [ SqlColumnNumber = 9, SqlFieldName = MKBGA_Mark ];

Property IsDisplayName As %String(MAXLEN = "") [ SqlColumnNumber = 10 ];

Index DescIndex On (ParRef As Exact, MKBGADesc);

Index NameIndex On MKBGADesc;

Index PYCodeIndex On (ParRef As Exact, MKBGAPYCode);

Index SeqIndex On (ParRef, MKBGASequence As Exact, MKBGADesc);

Index MarkIndex On (ParRef As Exact, MKBGAMark);

Index DisplayName On (ParRef As Exact, IsDisplayName);

Storage Default
{
<Data name="MKBGloAliasDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>MKBGADesc</Value>
</Value>
<Value name="3">
<Value>MKBGAPYCode</Value>
</Value>
<Value name="4">
<Value>MKBGANote</Value>
</Value>
<Value name="5">
<Value>MKBGACEFlag</Value>
</Value>
<Value name="6">
<Value>MKBGAState</Value>
</Value>
<Value name="7">
<Value>MKBGASequence</Value>
</Value>
<Value name="8">
<Value>MKBGAMark</Value>
</Value>
<Value name="9">
<Value>IsDisplayName</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("ChildGloAlias")</DataLocation>
<DefaultData>MKBGloAliasDefaultData</DefaultData>
<IdLocation>^User.MKBGlobalC("ChildGloAlias")</IdLocation>
<IndexLocation>^User.MKBGloAliasI</IndexLocation>
<StreamLocation>^User.MKBGloAliasS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
