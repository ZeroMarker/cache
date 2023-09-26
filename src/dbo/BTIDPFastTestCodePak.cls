/// 鉴定快速结果
Class dbo.BTIDPFastTestCodePak Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BTIDP_FastTestCodePak ]
{

/// Foreign Key FKBTIDPLinkTestSetDR created via DDL
ForeignKey FKBTIDPLinkTestSetDR(TestSetDR) References dbo.BTTestSet(PKBTTESTSET) [ SqlName = FK_BTIDPLinkTestSetDR ];

/// Foreign Key FKBTIDPLinkSpecimenDR created via DDL
ForeignKey FKBTIDPLinkSpecimenDR(SpecimenDR) References dbo.BTSpecimen(PKBTSPECIMEN) [ SqlName = FK_BTIDPLinkSpecimenDR ];

/// Foreign Key FKBTIDPFastTestCodePakItemIDPTestCodePakDR created via DDL
ForeignKey FKBTIDPFastTestCodePakIDPTestCodePakDR(IDPTestCodePakDR) References dbo.BTIDPTestCodePak(PKBTIDPTESTCODEPAK) [ SqlName = FK_BTIDPFastTestCodePakIDPTestCodePakDR ];

/// DDL Primary Key Specification
Index PKBTIDPFASTTESTCODEPAK On RowID [ PrimaryKey, SqlName = PK_BTIDP_FASTTESTCODEPAK, Type = index, Unique ];

Index IndexMaster On (TestSetDR, SpecimenDR, IDPTestCodePakDR) [ SqlName = Index_Master, Type = index, Unique ];

/// 主键
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 医嘱
Property TestSetDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

/// 标本类型
Property SpecimenDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 4 ];

/// 鉴定项目包
Property IDPTestCodePakDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 5 ];

Storage Default
{
<Data name="BTIDPFastTestCodePakDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>TestSetDR</Value>
</Value>
<Value name="3">
<Value>SpecimenDR</Value>
</Value>
<Value name="4">
<Value>IDPTestCodePakDR</Value>
</Value>
</Data>
<DataLocation>^dbo.BTIDPFastTestCodePakD</DataLocation>
<DefaultData>BTIDPFastTestCodePakDefaultData</DefaultData>
<IdLocation>^dbo.BTIDPFastTestCodePakD</IdLocation>
<IndexLocation>^dbo.BTIDPFastTestCodePakI</IndexLocation>
<StreamLocation>^dbo.BTIDPFastTestCodePakS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
