Class dbo.BBStateProductVsProduct Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BB_StateProductVsProduct ]
{

/// Foreign Key FKBBBPorductBComponets created via DDL
ForeignKey FKBBBloodProductDR(BloodProductDR) References dbo.BBBloodProduct(PKBBBLOODPRODUCT) [ SqlName = FK_BloodProduct_BPorduct ];

/// Foreign Key FKBBBPorductHospital created via DDL
ForeignKey FKStateBloodProductDR(StateBloodProductDR) References dbo.BBStateBloodProduct(PKBBStateBLOODPRODUCT) [ SqlName = FK_StateBloodProduct_BPorduct ];

Index IndexMaster On (BloodProductDR, StateBloodProductDR) [ SqlName = Index_Master, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property StateBloodProductDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

Property BloodProductDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

Storage Default
{
<Data name="BBStateProductVsProductDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>StateBloodProductDR</Value>
</Value>
<Value name="3">
<Value>BloodProductDR</Value>
</Value>
</Data>
<DataLocation>^dbo.BBStateProductVsProductD</DataLocation>
<DefaultData>BBStateProductVsProductDefaultData</DefaultData>
<IdLocation>^dbo.BBStateProductVsProductD</IdLocation>
<IndexLocation>^dbo.BBStateProductVsProductI</IndexLocation>
<StreamLocation>^dbo.BBStateProductVsProductS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
