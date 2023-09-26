Class User.DHCAppArcNote Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = AC_RowID, SqlTableName = DHC_AppArcNote, StorageStrategy = SQLStorage ]
{

/// 医嘱项id  AC_Arc_Dr
Property ACArcDr As User.ARCItmMast [ SqlColumnNumber = 2, SqlFieldName = AC_Arc_Dr ];

/// 注意事项id  AC_Temp_Dr
Property ACTempDr As User.DHCAppItemTemp [ SqlColumnNumber = 3, SqlFieldName = AC_Temp_Dr ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^DHCAPARCNO)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="AC_Arc_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="AC_Temp_Dr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCAPARCNO</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>AC_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{AC_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexArc">
<Global>^DHCAPARCNO</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>AC_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ARC"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{AC_Arc_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{AC_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexTemp">
<Global>^DHCAPARCNO</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>AC_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"TEMP"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{AC_Temp_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{AC_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCAppArcNoteS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
