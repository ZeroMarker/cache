/// 培养基形态描述
Class dbo.BTIDPCultureDesk Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BTIDP_CultureDesk ]
{

Index IndexMaster On (IDPCultureMediumDR, Sequence) [ SqlName = Index_Master, Type = index ];

/// Foreign Key FKBTIDPCultureDeskIDPCultureMediumDR created via DDL
ForeignKey FKBTIDPCultureDeskIDPCultureMediumDR(IDPCultureMediumDR) References dbo.BTIDPCultureMedium(PKBTIDPCULTUREMEDIUM) [ SqlName = FK_BTIDPCultureDeskIDPCultureMediumDR ];

/// DDL Primary Key Specification
Index PKBTIDPCULTUREDESK On RowID [ PrimaryKey, SqlName = PK_BTIDP_CULTUREDESK, Type = index, Unique ];

/// 主键
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 培养基
Property IDPCultureMediumDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

/// 描述
Property Remark As %Library.String(COLLATION = "Exact", MAXLEN = 300) [ SqlColumnNumber = 4 ];

/// 是否默认
Property IsDefault As %Library.Boolean [ SqlColumnNumber = 5 ];

/// 是否危急值
Property IsPanic As %Library.Boolean [ SqlColumnNumber = 6 ];

/// 是否阳性
Property IsPositive As %Library.Boolean [ SqlColumnNumber = 7 ];

/// 序号
Property Sequence As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 8 ];

/// 上机仪器
Property IDPMachDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 9 ];

Storage Default
{
<Data name="BTIDPCultureDeskDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>IDPCultureMediumDR</Value>
</Value>
<Value name="3">
<Value>Remark</Value>
</Value>
<Value name="4">
<Value>IsDefault</Value>
</Value>
<Value name="5">
<Value>IsPanic</Value>
</Value>
<Value name="6">
<Value>IsPositive</Value>
</Value>
<Value name="7">
<Value>Sequence</Value>
</Value>
<Value name="8">
<Value>IDPMachDR</Value>
</Value>
</Data>
<DataLocation>^dbo.BTIDPCultureDeskD</DataLocation>
<DefaultData>BTIDPCultureDeskDefaultData</DefaultData>
<IdLocation>^dbo.BTIDPCultureDeskD</IdLocation>
<IndexLocation>^dbo.BTIDPCultureDeskI</IndexLocation>
<StreamLocation>^dbo.BTIDPCultureDeskS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
