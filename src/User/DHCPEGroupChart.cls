Class User.DHCPEGroupChart Extends (%Persistent, %XML.Adaptor, User.DHCHMAbstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = GC_RowId, SqlTableName = DHC_PE_GroupChart, StorageStrategy = SQLStorage ]
{

Parameter ClassName = "User.DHCPEGroupChart";

Parameter EXTENTSIZE = 250;

/// GC_Chart_DR
Property GCChartDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = GC_Chart_DR ];

/// GC_Read
Property GCRead As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = GC_Read ];

/// GC_SSGRP_DR
Property GCSSGRPDR As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = GC_SSGRP_DR ];

/// GC_Write
Property GCWrite As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 5, SqlFieldName = GC_Write ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCPEGC)</SqlIdExpression>
<SQLMap name="DataMasterDHCPEGC">
<Data name="GC_Chart_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="GC_Read">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="GC_SSGRP_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="GC_Write">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^DHCPEGC</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>GC_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{GC_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexSSGRP">
<Global>^DHCPEGC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>GC_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"SSGRP"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{GC_SSGRP_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{GC_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCPEGroupChartS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
