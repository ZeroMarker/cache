Class User.DHCEQMoveAffix Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = MA_RowID, SqlTableName = DHC_EQMoveAffix, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// MA_MoveDR
Property MAMoveDR As User.DHCEQMove [ SqlColumnNumber = 2, SqlFieldName = MA_MoveDR ];

/// MA_AffixDR
Property MAAffixDR As User.DHCEQCAffix [ SqlColumnNumber = 3, SqlFieldName = MA_AffixDR ];

/// MA_Model
Property MAModel As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = MA_Model ];

/// MA_Quantity
Property MAQuantity As %Library.Float [ SqlColumnNumber = 5, SqlFieldName = MA_Quantity ];

/// MA_Status
Property MAStatus As %Library.String(DISPLAYLIST = ",完好,故障,丢失,其他", MAXLEN = 5, SELECTIVITY = "20.0000%", TRUNCATE = 1, VALUELIST = ",0,1,2,3") [ SqlColumnNumber = 6, SqlFieldName = MA_Status ];

/// MA_Remark
Property MARemark As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = MA_Remark ];

/// MA_LeaveFactoryNo
Property MALeaveFactoryNo As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = MA_LeaveFactoryNo ];

/// MA_Hold1
Property MAHold1 As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = MA_Hold1 ];

/// MA_Hold2
Property MAHold2 As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = MA_Hold2 ];

/// MA_Hold3
Property MAHold3 As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = MA_Hold3 ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQMoveAffix("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="MA_AffixDR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="MA_Hold1">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="MA_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="MA_Hold3">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="MA_LeaveFactoryNo">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="MA_Model">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="MA_MoveDR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="MA_Quantity">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="MA_Remark">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="MA_Status">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^DHCEQMoveAffix</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>MA_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{MA_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexAffix">
<Global>^DHCEQMoveAffix</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>MA_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Affix"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{MA_AffixDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{MA_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexMove">
<Global>^DHCEQMoveAffix</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>MA_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Move"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{MA_MoveDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{MA_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQMoveAffixS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
