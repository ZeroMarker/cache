/// 鉴定过程关联
Class dbo.BTIDPLink Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BTIDP_Link ]
{

/// Foreign Key FKBTIDPLinkTestSetDR created via DDL
ForeignKey FKBTIDPLinkTestSetDR(TestSetDR) References dbo.BTTestSet(PKBTTESTSET) [ SqlName = FK_BTIDPLinkTestSetDR ];

/// Foreign Key FKBTIDPLinkSpecimenDR created via DDL
ForeignKey FKBTIDPLinkSpecimenDR(SpecimenDR) References dbo.BTSpecimen(PKBTSPECIMEN) [ SqlName = FK_BTIDPLinkSpecimenDR ];

/// Foreign Key FKBTIDPLinkIDPPakDR created via DDL
ForeignKey FKBTIDPLinkIDPPakDR(IDPPakDR) References dbo.BTIDPPak(PKBTIDPPAK) [ SqlName = FK_BTIDPLinkIDPPakDR ];

/// DDL Primary Key Specification
Index PKBTIDPLINK On RowID [ PrimaryKey, SqlName = PK_BTIDP_LINK, Type = index, Unique ];

Index IndexTestSetDR On (TestSetDR, SpecimenDR) [ SqlName = Index_TestSetDR, Type = index, Unique ];

/// 主键
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 医嘱
Property TestSetDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

/// 标本类型
Property SpecimenDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 4 ];

/// 关联包
Property IDPPakDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 5 ];

/// 培养基组
Property IDPCultureMedPakDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 6 ];

Storage Default
{
<Data name="BTIDPLinkDefaultData">
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
<Value>IDPPakDR</Value>
</Value>
<Value name="5">
<Value>IDPCultureMedPakDR</Value>
</Value>
</Data>
<DataLocation>^dbo.BTIDPLinkD</DataLocation>
<DefaultData>BTIDPLinkDefaultData</DefaultData>
<IdLocation>^dbo.BTIDPLinkD</IdLocation>
<IndexLocation>^dbo.BTIDPLinkI</IndexLocation>
<StreamLocation>^dbo.BTIDPLinkS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
