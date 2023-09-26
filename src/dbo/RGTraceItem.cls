///     
Class dbo.RGTraceItem Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = RG_TraceItem, StorageStrategy = Default ]
{

/// Foreign Key FKRGTraceItemRGLotBox created via DDL
ForeignKey FKRGTraceItemRGLotBox(LotBoxDR) References dbo.RGLotBox(PKRGLotBox) [ SqlName = FK_RG_TraceItem_RG_LotBox ];

/// Foreign Key FKRGTraceItemRGTrace created via DDL
ForeignKey FKRGTraceItemRGTrace(TraceDR) References dbo.RGTrace(PKRGTRACE) [ SqlName = FK_RG_TraceItem_RG_Trace ];

Index IndexMaster On (TraceDR, LotBoxDR) [ SqlName = Index_Master, Type = index, Unique ];

/// DDL Primary Key Specification
Index PKRGTraceItem On RowID [ PrimaryKey, SqlName = PK_RG_TraceItem, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, Required, SqlColumnNumber = 2 ];

Property TraceDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

Property LotBoxDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

Storage Default
{
<Data name="RGTraceItemDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>RowID</Value>
</Value>
<Value name="3">
<Value>TraceDR</Value>
</Value>
<Value name="4">
<Value>LotBoxDR</Value>
</Value>
</Data>
<DataLocation>^dbo.RGTraceItemD</DataLocation>
<DefaultData>RGTraceItemDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.RGTraceItemD</IdLocation>
<IndexLocation>^dbo.RGTraceItemI</IndexLocation>
<StreamLocation>^dbo.RGTraceItemS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
