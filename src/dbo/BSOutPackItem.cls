/// 出库类型血袋明细
Class dbo.BSOutPackItem Extends (%Persistent, %XML.Adaptor) [ Owner = {UnknownUser}, SqlTableName = BS_OutPackItem ]
{

/// Foreign Key created via DDL
ForeignKey FKTAT(BSBSOutPackDR) References dbo.BSOutPack(PKBSOutPackId) [ SqlName = FK_BS_DepWorkLoadItemDR ];

Index IndexMaster On (BSBSOutPackDR, PackDR) [ SqlName = Index_Master, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property BSBSOutPackDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 3 ];

///  操作类型业务Id
Property PackDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 4 ];

Storage Default
{
<Data name="BSOutPackItemDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BSBSOutPackDR</Value>
</Value>
<Value name="3">
<Value>PackDR</Value>
</Value>
</Data>
<DataLocation>^dbo.BSOutPackItemD</DataLocation>
<DefaultData>BSOutPackItemDefaultData</DefaultData>
<IdLocation>^dbo.BSOutPackItemD</IdLocation>
<IndexLocation>^dbo.BSOutPackItemI</IndexLocation>
<StreamLocation>^dbo.BSOutPackItemS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
