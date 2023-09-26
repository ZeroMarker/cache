/// 业务执行表
Class User.TKBBusExecute Extends %Persistent [ SqlRowIdName = TKBBET_RowId, SqlTableName = TKB_BusExecute, StorageStrategy = SQLStorage ]
{

//^TKBBUSEXE

Property TKBBETCode As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = TKBBET_Code ];

Property TKBBETBusExe As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = TKBBET_BusExe ];

Property TKBBETBusScene As %String [ SqlColumnNumber = 4, SqlFieldName = TKBBET_BusScene ];

Property TKBBETLastLevel As User.TKBBusExecute [ SqlColumnNumber = 5, SqlFieldName = TKBBET_LastLevel ];

Property TKBBETLevel As %String [ SqlColumnNumber = 6, SqlFieldName = TKBBET_Level ];

Property TKBBETActive As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 7, SqlFieldName = TKBBET_Active ];

Property TKBBETInterfDr As User.TKBInterfaceManage [ SqlColumnNumber = 8, SqlFieldName = TKBBET_Interf_Dr ];

Storage SQLStorage
{
<SqlIdExpression>$i(^TKBBUSEXE(0))</SqlIdExpression>
<SQLMap name="IndexCode">
<Global>^TKBBUSEXE</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>TKBBET_RowIdl</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$UPPER({TKBBET_Code})</Expression>
</Subscript>
<Subscript name="4">
<Expression>{TKBBET_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterData">
<Data name="TKBBET_Active">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="TKBBET_BusExe">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="TKBBET_BusScene">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="TKBBET_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="TKBBET_Interf_Dr">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="TKBBET_LastLevel">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="TKBBET_Level">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^TKBBUSEXE</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>TKBBET_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{TKBBET_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="ParIdx">
<Global>^TKBBUSEXE</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>TKBBET_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ParIdx"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{TKBBET_LastLevel}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{TKBBET_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="ParSeqIdx">
<Global>^TKBBUSEXE</Global>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>TKBBET_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ParSeqIdx"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{TKBBET_LastLevel}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{TKBBET_Level}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{TKBBET_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.TKBBusExecuteS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
