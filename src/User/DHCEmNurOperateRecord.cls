Class User.DHCEmNurOperateRecord Extends %Persistent [ SqlRowIdName = NOR_RowID, SqlTableName = DHC_EmNurOperateRecord, StorageStrategy = SQLStorage ]
{

/// 医嘱id  NOR_Oeori_Dr
Property NOROeoriDr As User.OEOrdExec [ SqlColumnNumber = 2, SqlFieldName = NOR_Oeori_Dr ];

/// 操作类型 NOR_OperateType
Property NOROperateType As %String(DISPLAYLIST = ",E,F,P,T", MAXLEN = 3, SELECTIVITY = "20%", VALUELIST = ",E,F,P,T") [ SqlColumnNumber = 3, SqlFieldName = NOR_OperateType ];

/// 操作日期 NOR_OperateDate
Property NOROperateDate As %Date [ SqlColumnNumber = 4, SqlFieldName = NOR_OperateDate ];

/// 操作时间 NOR_OperateTime
Property NOROperateTime As %Time [ SqlColumnNumber = 5, SqlFieldName = NOR_OperateTime ];

/// 操作人 NOR_OperateUser_Dr
Property NOROperateUserDr As User.SSUser [ SqlColumnNumber = 6, SqlFieldName = NOR_OperateUser_Dr ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCEMNOR)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="NOR_Oeori_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="NOR_OperateDate">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="NOR_OperateTime">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="NOR_OperateType">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="NOR_OperateUser_Dr">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^DHCEMNOR</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>NOR_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{NOR_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexOeori">
<Global>^DHCEMNOR</Global>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>NOR_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Oeori"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{NOR_Oeori_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{NOR_OperateDate}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{NOR_OperateTime}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{NOR_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEmNurOperateRecordS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
