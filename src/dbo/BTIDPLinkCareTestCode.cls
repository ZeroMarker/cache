Class dbo.BTIDPLinkCareTestCode Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BTIDP_LinkCareTestCode ]
{

Index IndexMaster On (IDPLinkDR, TestCodeDR, SpecimenDR) [ SqlName = Index_Master, Type = index, Unique ];

/// Foreign Key FKBTIDPLinkCareTestCodeIDPLinkDR created via DDL
ForeignKey FKBTIDPLinkCareTestCodeIDPLinkDR(IDPLinkDR) References dbo.BTIDPLink(PKBTIDPLINK) [ SqlName = FK_BTIDPLinkCareTestCodeIDPLinkDR ];

/// Foreign Key FKBTIDPLinkCareTestCodeComments created via DDL
ForeignKey FKBTIDPLinkCareTestCodeComments(TestCodeDR) References dbo.BTTestCode(PKBTTESTCODE) [ SqlName = FK_BTIDPLinkCareTestCodeComments ];

/// Foreign Key FKBTIDPLinkCareTestCodeSpecimen created via DDL
ForeignKey FKBTIDPLinkCareTestCodeSpecimen(SpecimenDR) References dbo.BTSpecimen(PKBTSPECIMEN) [ SqlName = FK_BTIDPLinkCareTestCodeSpecimen ];

/// DDL Primary Key Specification
Index PKBTIDPLINKCARETESTCODE On RowID [ PrimaryKey, SqlName = PK_BTIDP_LINKCARETESTCODE, Type = index, Unique ];

/// 主键
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 关联
Property IDPLinkDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

/// 检验项目
Property TestCodeDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

/// 标本类型
Property SpecimenDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 5 ];

/// 天数
Property Days As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 6 ];

/// 序号
Property Sequence As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 7 ];

/// 激活
Property Active As %Library.Boolean [ SqlColumnNumber = 8 ];

Storage Default
{
<Data name="BTIDPLinkCareTestCodeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>IDPLinkDR</Value>
</Value>
<Value name="3">
<Value>TestCodeDR</Value>
</Value>
<Value name="4">
<Value>SpecimenDR</Value>
</Value>
<Value name="5">
<Value>Days</Value>
</Value>
<Value name="6">
<Value>Sequence</Value>
</Value>
<Value name="7">
<Value>Active</Value>
</Value>
</Data>
<DataLocation>^dbo.BTIDPLinkCareTestCodeD</DataLocation>
<DefaultData>BTIDPLinkCareTestCodeDefaultData</DefaultData>
<IdLocation>^dbo.BTIDPLinkCareTestCodeD</IdLocation>
<IndexLocation>^dbo.BTIDPLinkCareTestCodeI</IndexLocation>
<StreamLocation>^dbo.BTIDPLinkCareTestCodeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
