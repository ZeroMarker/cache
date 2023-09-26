/// Description： 深圳术语对照表
/// Creator：基础数据平台-石萧伟
/// Date： 2018-07-03
Class User.MKBSZTermContrast Extends (%Persistent, User.Abstract) [ SqlRowIdName = MKBSZ_RowId, SqlTableName = MKB_SZTermContrast ]
{

/// 深圳术语
Property MKBSZTermDr As User.MKBTerm [ SqlColumnNumber = 2, SqlFieldName = MKB_SZTerm_Dr ];

/// 国家术语
Property MKBGJTermDr As User.MKBTerm [ SqlColumnNumber = 3, SqlFieldName = MKB_GJTerm_Dr ];

Index TermIndex On (MKBSZTermDr As Exact, MKBGJTermDr As Exact);

Storage Default
{
<Data name="MKBSZTermContrastDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>MKBSZTermDr</Value>
</Value>
<Value name="3">
<Value>MKBGJTermDr</Value>
</Value>
</Data>
<DataLocation>^User.MKBSZTermContrastD</DataLocation>
<DefaultData>MKBSZTermContrastDefaultData</DefaultData>
<IdLocation>^User.MKBSZTermContrastD</IdLocation>
<IndexLocation>^User.MKBSZTermContrastI</IndexLocation>
<StreamLocation>^User.MKBSZTermContrastS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
