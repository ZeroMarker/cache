Class User.DHCStkAuditTrans Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = STATR_RowId, SqlTableName = DHC_StkAuditTrans, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// STATR_Type
Property STATRType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = STATR_Type ];

/// STATR_Pointer
Property STATRPointer As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = STATR_Pointer ];

/// STATR_Operator
Property STATROperator As User.SSUser [ SqlColumnNumber = 4, SqlFieldName = STATR_Operator ];

/// STATR_OperDate
Property STATROperDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 5, SqlFieldName = STATR_OperDate ];

/// STATR_OperTime
Property STATROperTime As %Library.Time [ SqlColumnNumber = 6, SqlFieldName = STATR_OperTime ];

/// STATR_OperResult
Property STATROperResult As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 7, SqlFieldName = STATR_OperResult ];

/// STATR_OperRemark
Property STATROperRemark As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = STATR_OperRemark ];

/// STATR_StkGrp
Property STATRStkGrp As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = STATR_StkGrp ];

/// STATR_NewFlag
Property STATRNewFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 10, SqlFieldName = STATR_NewFlag ];

/// STATR_CurrLevel
Property STATRCurrLevel As %Library.String(COLLATION = "Exact", MAXLEN = 30, SELECTIVITY = "33.3333%", TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = STATR_CurrLevel ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCSTATR)</SqlIdExpression>
<SQLMap name="IndexDate">
<Global>^DHCSTATR</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>STATR_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"Date"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{STATR_OperDate}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{STATR_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexNewFlag">
<Global>^DHCSTATR</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>STATR_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"NewFlag"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{STATR_NewFlag}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{STATR_Type}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{STATR_StkGrp}</Expression>
</Subscript>
<Subscript name="6">
<AccessType>sub</AccessType>
<Expression>{STATR_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPointer">
<Global>^DHCSTATR</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>STATR_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"Pointer"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{STATR_Pointer}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{STATR_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexType">
<Global>^DHCSTATR</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>STATR_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"Type"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{STATR_Type}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{STATR_StkGrp}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{STATR_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexTypePointer">
<Global>^DHCSTATR</Global>
<RowIdSpec name="1">
<Expression>{5}</Expression>
<Field>STATR_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"TypePointer"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{STATR_Type}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{STATR_Pointer}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{STATR_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterData">
<Data name="STATR_CurrLevel">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="STATR_NewFlag">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="STATR_OperDate">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="STATR_OperRemark">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="STATR_OperResult">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="STATR_OperTime">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="STATR_Operator">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="STATR_Pointer">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="STATR_StkGrp">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="STATR_Type">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCSTATR</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>STATR_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{STATR_RowId}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCStkAuditTransS</StreamLocation>
<Type>%Storage.SQL</Type>
}

/// 编译时判断是否需要重生计数器
ClassMethod SetSqlIdExpression() [ CodeMode = objectgenerator ]
{
	s newI = +$g(^DHCSTATR)
	s oldI = +$g(^mdata("DHCSTKAUDITTRANS"))
	s maxI = $s(newI > oldI : newI, 1 : oldI)
	s ^DHCSTATR = maxI
	s ^mdata("DHCSTKAUDITTRANS") = maxI
}

}
