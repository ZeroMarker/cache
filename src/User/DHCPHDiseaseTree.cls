/// 名称：诊断逻辑推导目录表
/// 编写者：基础数据平台组-谷雪萍
/// 编写日期: 2017-4-12
Class User.DHCPHDiseaseTree Extends (%Persistent, User.Abstract) [ ClassType = persistent, SqlRowIdName = PDT_RowId, SqlTableName = DHC_PHDiseaseTree, StorageStrategy = SQLStorage ]
{

// ^DHCPHDISTR ^DHCPHDISTRi

Property PDTCode As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = PDT_Code ];

Property PDTDesc As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = PDT_Desc ];

Property PDTLastRowid As User.DHCPHDiseaseTree [ SqlColumnNumber = 4, SqlFieldName = PDT_LastRowid ];

Property PDTLevel As %String [ SqlColumnNumber = 5, SqlFieldName = PDT_Level ];

Property PDTActiveFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 6, SqlFieldName = PDT_ActiveFlag ];

Property PDTSysFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 7, SqlFieldName = PDT_SysFlag ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCPHDISTR(0))</SqlIdExpression>
<SQLMap name="CodeIndex">
<Global>^DHCPHDISTRi</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PDT_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$UPPER({PDT_Code})</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PDT_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="DescIndex">
<Global>^DHCPHDISTRi</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PDT_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$UPPER({PDT_Desc})</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PDT_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="LevelIndex">
<Global>^DHCPHDISTRi</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PDT_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Level"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PDT_Level}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PDT_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterData">
<Data name="PDT_ActiveFlag">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PDT_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PDT_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PDT_LastRowid">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PDT_Level">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PDT_SysFlag">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Global>^DHCPHDISTR</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PDT_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{PDT_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="ParIdx">
<Global>^DHCPHDISTRi</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PDT_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ParIdx"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PDT_LastRowid}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PDT_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>PDT_RowId</SqlRowIdName>
<StreamLocation>^User.DHCPHDiseaseTreeS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
