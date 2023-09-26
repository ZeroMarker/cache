Class User.DHCPhaLocConfig Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PLC_ROWID, SqlTableName = DHC_PhaLocConfig, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// PLC_Loc_DR
Property PLCLocDR As User.CTLoc [ SqlColumnNumber = 2, SqlFieldName = PLC_Loc_DR ];

/// PLC_Desc
Property PLCDesc As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = PLC_Desc ];

/// PLC_MAC
Property PLCMAC As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = PLC_MAC ];

/// PLC_DispCat_Dr
Property PLCDispCatDr As User.DHCStkDrugGroup [ SqlColumnNumber = 5, SqlFieldName = PLC_DispCat_Dr ];

/// PLC_Priority
Property PLCPriority As User.OECPriority [ SqlColumnNumber = 6, SqlFieldName = PLC_Priority ];

/// PLC_SSUSR_DR
Property PLCSSUSRDR As User.SSUser [ SqlColumnNumber = 7, SqlFieldName = PLC_SSUSR_DR ];

/// PLC_IsAutoRefresh
Property PLCIsAutoRefresh As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ InitialExpression = "N", SqlColumnNumber = 8, SqlFieldName = PLC_IsAutoRefresh ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCPHLC)</SqlIdExpression>
<SQLMap name="DHCPHLCIndex">
<Global>^DHCPHLC</Global>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>PLC_ROWID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"LocUser"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PLC_Loc_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PLC_SSUSR_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PLC_ROWID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="DHCPHLCMaster">
<Data name="PLC_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PLC_DispCat_Dr">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PLC_IsAutoRefresh">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="PLC_Loc_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PLC_MAC">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PLC_Priority">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PLC_SSUSR_DR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Global>^DHCPHLC</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PLC_ROWID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{PLC_ROWID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCPhaLocConfigS</StreamLocation>
<Type>%Storage.SQL</Type>
}

/// 编译时判断是否需要重生计数器
ClassMethod SetSqlIdExpression() [ CodeMode = objectgenerator ]
{
	s newI = +$g(^DHCPHLC)
	s oldI = +$g(^mdata("DHCPHALOCCONFIG"))
	s maxI = $s(newI > oldI : newI, 1 : oldI)
	s ^DHCPHLC = maxI
	s ^mdata("DHCPHALOCCONFIG") = maxI
}

}
