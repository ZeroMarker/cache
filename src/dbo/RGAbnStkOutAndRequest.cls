/// 特殊出库请求与出库单对应关系
Class dbo.RGAbnStkOutAndRequest Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = RG_AbnStkOutAndRequest, StorageStrategy = Default ]
{

Index IndexMasterReq On (StkOutRequestDR, StkOutDR) [ SqlName = Index_MasterReq, Type = index ];

Index IndexMasterStk On (StkOutDR, StkOutRequestDR) [ SqlName = Index_MasterStk, Type = index ];

/// DDL Primary Key Specification
Index PKRGAbnStkOutAndRequest On RowID [ PrimaryKey, SqlName = PK_RG_AbnStkOutAndRequest, Type = index, Unique ];

ForeignKey FKRGAbnStkOutAndRequestAbnStkOutRequest(StkOutRequestDR) References dbo.RGAbnStkOutRequest(PKRGAbnStkOutRequest) [ SqlName = FK_RG_AbnStkOutAndRequest_AbnStkOutRequest ];

ForeignKey FKRGAbnStkOutAndRequestStkOut(StkOutDR) References dbo.RGStkOut(PKRGSTKOUT) [ SqlName = FK_RG_AbnStkOutAndRequest_StkOut ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property StkOutRequestDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

Property StkOutDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

Storage Default
{
<Data name="RGAbnStkOutAndRequesDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>StkOutRequestDR</Value>
</Value>
<Value name="3">
<Value>StkOutDR</Value>
</Value>
</Data>
<DataLocation>^dbo.RGAbnStkOutAndRequesD</DataLocation>
<DefaultData>RGAbnStkOutAndRequesDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.RGAbnStkOutAndRequesD</IdLocation>
<IndexLocation>^dbo.RGAbnStkOutAndRequesI</IndexLocation>
<StreamLocation>^dbo.RGAbnStkOutAndRequesS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
