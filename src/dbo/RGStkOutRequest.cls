///     
Class dbo.RGStkOutRequest Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = RG_StkOutRequest, StorageStrategy = Default ]
{

Index IndexMaster On (StkOutDR, RequestTaskDR) [ SqlName = Index_Master, Type = index, Unique ];

Index IndexRequest On RequestTaskDR [ SqlName = Index_Request, Type = index ];

Index IndexStkOut On StkOutDR [ SqlName = Index_StkOut, Type = index ];

/// DDL Primary Key Specification
Index PKRGSTKOUTREQUEST On RowID [ PrimaryKey, SqlName = PK_RG_STKOUTREQUEST, Type = index, Unique ];

/// Foreign Key FKRGStkOutReaquestRequest created via DDL
ForeignKey FKRGStkOutReaquestRequest(RequestTaskDR) References dbo.RGRequestTask(PKRGREQUESTTASK) [ SqlName = FK_RG_StkOutReaquest_Request ];

/// Foreign Key FKRGStkOutRequestStkOut created via DDL
ForeignKey FKRGStkOutRequestStkOut(StkOutDR) References dbo.RGStkOut(PKRGSTKOUT) [ SqlName = FK_RG_StkOutRequest_StkOut ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property StkOutDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

Property RequestTaskDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

Storage Default
{
<Data name="RGStkOutRequestDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>StkOutDR</Value>
</Value>
<Value name="3">
<Value>RequestTaskDR</Value>
</Value>
</Data>
<DataLocation>^dbo.RGStkOutRequestD</DataLocation>
<DefaultData>RGStkOutRequestDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.RGStkOutRequestD</IdLocation>
<IndexLocation>^dbo.RGStkOutRequestI</IndexLocation>
<StreamLocation>^dbo.RGStkOutRequestS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
