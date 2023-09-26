Class User.DHCDisLocUser Extends %Persistent [ Owner = {_SYSTEM}, SqlRowIdName = LU_RowId, SqlTableName = DHC_DisLocUser, StorageStrategy = SQLStorage ]
{

/// 科室id  LU_Loc_Dr
Property LULocDr As User.CTLoc [ SqlColumnNumber = 2, SqlFieldName = LU_Loc_Dr ];

/// 描述  LU_User_Dr
Property LUUserDr As User.SSUser [ SqlColumnNumber = 3, SqlFieldName = LU_User_Dr ];

/// 激活标志  LU_ActiveFlag
Property LUActiveFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 4, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = LU_ActiveFlag ];

/// 状态  LU_Status
Property LUStatus As %String(DISPLAYLIST = ",空闲,忙碌", MAXLEN = 4, SELECTIVITY = "33.3333%", VALUELIST = ",0,1") [ SqlColumnNumber = 5, SqlFieldName = LU_Status ];

/// 工作量  LU_Workload
Property LUWorkload As %String [ SqlColumnNumber = 6, SqlFieldName = LU_Workload ];

Relationship ChildDHCDISLOCUSER As DHCDisLocUserLinkItm [ Cardinality = children, Inverse = LUParRef ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCDISLU)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="LU_ActiveFlag">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="LU_Loc_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="LU_Status">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="LU_User_Dr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="LU_Workload">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^DHCDISLU</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>LU_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{LU_RowId}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="Index">
<Global>^DHCDISLU</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>LU_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Loc"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{LU_Loc_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{LU_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexUser">
<Global>^DHCDISLU</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>LU_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<Expression>"User"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{LU_User_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{LU_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexWorkload">
<Global>^DHCDISLU</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>LU_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Workload"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{LU_Workload}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{LU_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCDisLocUserS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
