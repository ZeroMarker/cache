/// 基础数据平台-临床知识库-药品成分明细表
Class User.DHCPHExtGenIngr Extends (%Persistent, User.Abstract) [ ClassType = persistent, SqlRowIdName = PHEGI_RowId, SqlTableName = DHC_PHExtGenIngr, StorageStrategy = SQLStorage ]
{

// ^DHCPHEGENIN

Property PHEGIPHEGDr As User.DHCPHExtGeneric [ SqlColumnNumber = 2, SqlFieldName = PHEGI_PHEG_Dr ];

Property PHEGIIngrDr As User.DHCPHExtIngr [ SqlColumnNumber = 3, SqlFieldName = PHEGI_Ingr_Dr ];

Property PHEGILevel As %Numeric(DISPLAYLIST = ",一级,二级,三级", VALUELIST = ",1,2,3") [ SqlColumnNumber = 4, SqlFieldName = PHEGI_Level ];

Property PHEGISysFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 5, SqlFieldName = PHEGI_SysFlag ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^DHCPHEGENIN(0))</SqlIdExpression>
<SQLMap name="IndexGen">
<Global>^DHCPHEGENINi</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PHEGI_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"GEN"</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$UPPER({PHEGI_PHEG_Dr})</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PHEGI_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexGenIngr">
<Global>^DHCPHEGENINi</Global>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>PHEGI_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"GenIngr"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PHEGI_PHEG_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PHEGI_Ingr_Dr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PHEGI_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexIngr">
<Global>^DHCPHEGENINi</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PHEGI_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Ingr"</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$UPPER({PHEGI_Ingr_Dr})</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PHEGI_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterData">
<Data name="PHEGI_Ingr_Dr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PHEGI_Level">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PHEGI_PHEG_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PHEGI_SysFlag">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^DHCPHEGENIN</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PHEGI_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{PHEGI_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>PHEGI_RowId</SqlRowIdName>
<StreamLocation>^User.DHCPHExtGenIngrS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
