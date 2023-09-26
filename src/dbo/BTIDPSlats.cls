/// 板条组合
Class dbo.BTIDPSlats Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BTIDP_Slats ]
{

Index IndexCode On Code [ SqlName = Index_Code, Type = index, Unique ];

Index IndexSequence On Sequence [ SqlName = Index_Sequence, Type = index ];

/// Foreign Key FKBTIDPSlatsDefIDPMachDR created via DDL
ForeignKey FKBTIDPSlatsDefIDPMachDR(DefIDPMachDR) References dbo.BTIDPMach(PKBTIDPMACH) [ SqlName = FK_BTIDPSlatsDefIDPMachDR ];

/// DDL Primary Key Specification
Index PKBTIDPSLATS On RowID [ PrimaryKey, SqlName = PK_BTIDP_SLATS, Type = index, Unique ];

/// 主键
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 代码
Property Code As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ Required, SqlColumnNumber = 3 ];

/// 板条名称
Property SlatsCName As %Library.String(COLLATION = "Exact", MAXLEN = 50) [ SqlColumnNumber = 4 ];

/// 组合名称
Property CombCName As %Library.String(COLLATION = "Exact", MAXLEN = 50) [ SqlColumnNumber = 5 ];

/// 板条默认批号
Property SlatsDefLotNo As %Library.String(COLLATION = "Exact", MAXLEN = 50) [ SqlColumnNumber = 6 ];

/// 默认仪器
Property DefIDPMachDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 7 ];

/// 录入码
Property EntryCode As %Library.String(COLLATION = "Exact", MAXLEN = 50) [ SqlColumnNumber = 8 ];

/// 序号
Property Sequence As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 9 ];

Storage Default
{
<Data name="BTIDPSlatsDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Code</Value>
</Value>
<Value name="3">
<Value>SlatsCName</Value>
</Value>
<Value name="4">
<Value>CombCName</Value>
</Value>
<Value name="5">
<Value>SlatsDefLotNo</Value>
</Value>
<Value name="6">
<Value>DefIDPMachDR</Value>
</Value>
<Value name="7">
<Value>EntryCode</Value>
</Value>
<Value name="8">
<Value>Sequence</Value>
</Value>
</Data>
<DataLocation>^dbo.BTIDPSlatsD</DataLocation>
<DefaultData>BTIDPSlatsDefaultData</DefaultData>
<IdLocation>^dbo.BTIDPSlatsD</IdLocation>
<IndexLocation>^dbo.BTIDPSlatsI</IndexLocation>
<StreamLocation>^dbo.BTIDPSlatsS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
