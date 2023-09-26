Class User.DHCVISBuilding Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = VIS_BuildId, SqlTableName = DHC_VIS_Building, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// 楼名称代码
Property VISBuildCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = VIS_BuildCode ];

/// 楼名称
Property VISBuildName As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = VIS_BuildName ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCVISBuild)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="VIS_BuildCode">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="VIS_BuildName">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCVISBuild</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>VIS_BuildId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{VIS_BuildId}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexFloorName">
<Global>^DHCVISBuildi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>VIS_BuildId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"BuildName"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{VIS_BuildName}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{VIS_BuildId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCVISBuildingS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
