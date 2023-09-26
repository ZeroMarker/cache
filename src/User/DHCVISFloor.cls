Class User.DHCVISFloor Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = VIS_FloorId, SqlTableName = DHC_VIS_Floor, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// 楼层代码
Property VISFloorCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = VIS_FloorCode ];

/// 楼层描述
Property VISFloorName As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = VIS_FloorName ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCVISFloor)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="VIS_FloorCode">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="VIS_FloorName">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCVISFloor</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>VIS_FloorId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{VIS_FloorId}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexFloorName">
<Global>^DHCVISFloori</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>VIS_FloorId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"FloorName"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{VIS_FloorName}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{VIS_FloorId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCVISFloorS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
