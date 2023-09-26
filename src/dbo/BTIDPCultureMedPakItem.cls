/// 培养基项
Class dbo.BTIDPCultureMedPakItem Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BTIDP_CultureMedPakItem ]
{

Index IndexMaster On (IDPCultureMedPakDR, Sequence, IDPCultureMediumDR) [ SqlName = Index_Master, Type = index ];

/// Foreign Key FKBTIDPCultureMedPakItemIDPCultureMedPakDR created via DDL
ForeignKey FKBTIDPCultureMedPakItemIDPCultureMedPakDR(IDPCultureMedPakDR) References dbo.BTIDPCultureMedPak(PKBTIDPCULTUREMEDPAK) [ SqlName = FK_BTIDPCultureMedPakItemIDPCultureMedPakDR ];

/// Foreign Key FKBTIDPCultureMedPakItemIDPCultureMediumDR created via DDL
ForeignKey FKBTIDPCultureMedPakItemIDPCultureMediumDR(IDPCultureMediumDR) References dbo.BTIDPCultureMedium(PKBTIDPCULTUREMEDIUM) [ SqlName = FK_BTIDPCultureMedPakItemIDPCultureMediumDR ];

/// DDL Primary Key Specification
Index PKBTIDPCULTUREMEDPAKITEM On RowID [ PrimaryKey, SqlName = PK_BTIDP_CULTUREMEDPAKITEM, Type = index, Unique ];

/// 主键
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 培养基组
Property IDPCultureMedPakDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

/// 培养基
Property IDPCultureMediumDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

/// 序号
Property Sequence As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 5 ];

/// 初鉴默认结果
Property DefRes As %Library.Boolean [ SqlColumnNumber = 6 ];

/// 默认分纯培养基
Property IDPPureMediumDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 7 ];

Storage Default
{
<Data name="BTIDPCultureMedPakItemDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>IDPCultureMedPakDR</Value>
</Value>
<Value name="3">
<Value>IDPCultureMediumDR</Value>
</Value>
<Value name="4">
<Value>Sequence</Value>
</Value>
<Value name="5">
<Value>DefRes</Value>
</Value>
<Value name="6">
<Value>IDPPureMediumDR</Value>
</Value>
</Data>
<DataLocation>^dbo.BTIDPCultureMedPakItemD</DataLocation>
<DefaultData>BTIDPCultureMedPakItemDefaultData</DefaultData>
<IdLocation>^dbo.BTIDPCultureMedPakItemD</IdLocation>
<IndexLocation>^dbo.BTIDPCultureMedPakItemI</IndexLocation>
<StreamLocation>^dbo.BTIDPCultureMedPakItemS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
