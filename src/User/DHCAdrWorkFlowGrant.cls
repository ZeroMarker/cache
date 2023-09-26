Class User.DHCAdrWorkFlowGrant Extends %Persistent [ Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = ADRWFG_RowID, SqlTableName = DHC_AdrWorkFlowGrant, StorageStrategy = NewStorage1 ]
{

Property ADRWFGParRefDr As %String [ SqlColumnNumber = 2, SqlFieldName = ADRWFG_ParRef_Dr ];

Property ADRWFGItmDr As %String [ SqlColumnNumber = 3, SqlFieldName = ADRWFG_Itm_Dr ];

Property ADRWFGType As %String [ SqlColumnNumber = 4, SqlFieldName = ADRWFG_Type ];

Property ADRWFGPointer As %String [ SqlColumnNumber = 5, SqlFieldName = ADRWFG_Pointer ];

/// 多院区改造 2021-04-12 cy
Property ADRWFGHospDr As User.CTHospital [ SqlColumnNumber = 6, SqlFieldName = ADRWFG_HospDr ];

Storage NewStorage1
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^DHCADREVTWFGR)</SqlIdExpression>
<SQLMap name="IndexHospTypePointer">
<Global>^DHCADREVTWFGR</Global>
<RowIdSpec name="1">
<Expression>{L8}</Expression>
<Field>ADRWFG_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"HospTypePointer"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ADRWFG_HospDr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ADRWFG_Type}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{ADRWFG_Pointer}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{ADRWFG_ParRef_Dr}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{ADRWFG_Itm_Dr}</Expression>
</Subscript>
<Subscript name="8">
<Expression>{ADRWFG_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexItmDr">
<Global>^DHCADREVTWFGR</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>ADRWFG_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ItmDr"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ADRWFG_Itm_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ADRWFG_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexTypePointer">
<Global>^DHCADREVTWFGR</Global>
<RowIdSpec name="1">
<Expression>{L7}</Expression>
<Field>ADRWFG_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"TypePointer"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ADRWFG_Type}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ADRWFG_Pointer}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{ADRWFG_ParRef_Dr}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{ADRWFG_Itm_Dr}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{ADRWFG_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterData">
<Data name="ADRWFG_HospDr">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="ADRWFG_Itm_Dr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="ADRWFG_ParRef_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ADRWFG_Pointer">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="ADRWFG_Type">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCADREVTWFGR</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>ADRWFG_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{ADRWFG_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCAdrWorkFlowGrantS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
