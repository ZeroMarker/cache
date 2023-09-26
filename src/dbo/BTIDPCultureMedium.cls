/// 培养基
Class dbo.BTIDPCultureMedium Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BTIDP_CultureMedium ]
{

Index IndexCode On Code [ SqlName = Index_Code, Type = index, Unique ];

Index IndexSequence On Sequence [ SqlName = Index_Sequence, Type = index ];

/// Foreign Key FKBTIDPCultureMediumBindTestCodeDR created via DDL
ForeignKey FKBTIDPCultureMediumBindTestCodeDR(BindTestCodeDR) References dbo.BTTestCode(PKBTTESTCODE) [ SqlName = FK_BTIDPCultureMediumBindTestCodeDR ];

/// DDL Primary Key Specification
Index PKBTIDPCULTUREMEDIUM On RowID [ PrimaryKey, SqlName = PK_BTIDP_CULTUREMEDIUM, Type = index, Unique ];

/// 主键
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 代码
Property Code As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ Required, SqlColumnNumber = 3 ];

/// 名称
Property CName As %Library.String(COLLATION = "Exact", MAXLEN = 128) [ SqlColumnNumber = 4 ];

/// 培养条件
Property Condition As %Library.String(COLLATION = "Exact", MAXLEN = 200) [ SqlColumnNumber = 5 ];

/// 培养周期
Property Cycle As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ SqlColumnNumber = 6 ];

/// 观察间隔
Property CultureInterval As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ SqlColumnNumber = 7 ];

/// 绑定项目
Property BindTestCodeDR As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 8 ];

/// 备注
Property Remark As %Library.String(COLLATION = "Exact", MAXLEN = 500) [ SqlColumnNumber = 9 ];

/// 录入码
Property EntryCode As %Library.String(COLLATION = "Exact", MAXLEN = 50) [ SqlColumnNumber = 10 ];

/// 序号
Property Sequence As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 11 ];

/// 默认批号
Property DefBatchNo As %Library.String(COLLATION = "Exact", MAXLEN = 50) [ SqlColumnNumber = 12 ];

/// 默认效期
Property DefValidityDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 13 ];

/// 培养瓶重量
Property Weight As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ SqlColumnNumber = 14 ];

/// 最小采集量
Property MinCollection As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ SqlColumnNumber = 15 ];

Storage Default
{
<Data name="BTIDPCultureMediumDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Code</Value>
</Value>
<Value name="3">
<Value>CName</Value>
</Value>
<Value name="4">
<Value>Condition</Value>
</Value>
<Value name="5">
<Value>Cycle</Value>
</Value>
<Value name="6">
<Value>CultureInterval</Value>
</Value>
<Value name="7">
<Value>BindTestCodeDR</Value>
</Value>
<Value name="8">
<Value>Remark</Value>
</Value>
<Value name="9">
<Value>EntryCode</Value>
</Value>
<Value name="10">
<Value>Sequence</Value>
</Value>
<Value name="11">
<Value>DefBatchNo</Value>
</Value>
<Value name="12">
<Value>DefValidityDate</Value>
</Value>
<Value name="13">
<Value>Weight</Value>
</Value>
<Value name="14">
<Value>MinCollection</Value>
</Value>
</Data>
<DataLocation>^dbo.BTIDPCultureMediumD</DataLocation>
<DefaultData>BTIDPCultureMediumDefaultData</DefaultData>
<IdLocation>^dbo.BTIDPCultureMediumD</IdLocation>
<IndexLocation>^dbo.BTIDPCultureMediumI</IndexLocation>
<StreamLocation>^dbo.BTIDPCultureMediumS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
