Class User.DHCPHCNTSTABOOLIST Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PCT_RowID, SqlTableName = DHC_PHCNTSTABOOLIST, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// PCT_OrdItem_Dr
Property PCTOrdItemDr As User.OEOrdItem [ SqlColumnNumber = 2, SqlFieldName = PCT_OrdItem_Dr ];

/// PCT_CLog_Dr
Property PCTCLogDr As User.DHCPHCOMMENTSLOG [ SqlColumnNumber = 3, SqlFieldName = PCT_CLog_Dr ];

/// PCT_MainOrdItem_Dr
Property PCTMainOrdItemDr As User.OEOrdItem [ SqlColumnNumber = 4, SqlFieldName = PCT_MainOrdItem_Dr ];

/// PCT_Doctor_Dr
Property PCTDoctorDr As User.SSUser [ SqlColumnNumber = 5, SqlFieldName = PCT_Doctor_Dr ];

/// PCT_DocLoc_Dr
Property PCTDocLocDr As User.CTLoc [ SqlColumnNumber = 6, SqlFieldName = PCT_DocLoc_Dr ];

/// PCT_Date
Property PCTDate As %Library.Date [ SqlColumnNumber = 7, SqlFieldName = PCT_Date ];

/// 审核标志
Property PCTAuditFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, VALUELIST = ",Y,N") [ SqlColumnNumber = 8, SqlFieldName = PCT_AuditFlag ];

/// 审核人
Property PCTAuditorDr As User.SSUser [ SqlColumnNumber = 9, SqlFieldName = PCT_Auditor_Dr ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCPCTABL)</SqlIdExpression>
<SQLMap name="IndexDoctor">
<Global>^DHCPCTABL</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Doctor"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PCT_Doctor_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PCT_Date}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PCT_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexLOG">
<Global>^DHCPCTABL</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PCT_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"LOG"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{PCT_CLog_Dr}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{PCT_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexOrdItm">
<Global>^DHCPCTABL</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"OrdItm"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{PCT_OrdItem_Dr}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{PCT_CLog_Dr}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>Sub</AccessType>
<Expression>{PCT_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterData">
<Data name="PCT_AuditFlag">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="PCT_Auditor_Dr">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="PCT_CLog_Dr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PCT_Date">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PCT_DocLoc_Dr">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PCT_Doctor_Dr">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PCT_MainOrdItem_Dr">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PCT_OrdItem_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCPCTABL</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PCT_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{PCT_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCPHCNTSTABOOLISTS</StreamLocation>
<Type>%Storage.SQL</Type>
}

/// 编译时判断是否需要重生计数器
ClassMethod SetSqlIdExpression() [ CodeMode = objectgenerator ]
{
	s newI = +$g(^DHCPCTABL)
	s oldI = +$g(^mdata("DHCPHCNTSTABOOLIST"))
	s maxI = $s(newI > oldI : newI, 1 : oldI)
	s ^DHCPCTABL = maxI
	s ^mdata("DHCPHCNTSTABOOLIST") = maxI
}

}
