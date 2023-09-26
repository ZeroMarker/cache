Class User.DHCEQMultipleApproveInfo Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = MA_RowID, SqlTableName = DHC_EQMultipleApproveInfo, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// MA_ApproveTypeDR
Property MAApproveTypeDR As User.DHCEQCApproveType [ SqlColumnNumber = 2, SqlFieldName = MA_ApproveTypeDR ];

/// MA_BusID
Property MABusID As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = MA_BusID ];

/// MA_MultiDefineDR
Property MAMultiDefineDR As User.DHCEQCMultipleDefine [ SqlColumnNumber = 4, SqlFieldName = MA_MultiDefineDR ];

/// MA_SourceID
Property MASourceID As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = MA_SourceID ];

/// MA_ActionDR
Property MAActionDR As User.DHCEQCAction [ SqlColumnNumber = 6, SqlFieldName = MA_ActionDR ];

/// MA_ApproveListDR
Property MAApproveListDR As User.DHCEQApproveList [ SqlColumnNumber = 7, SqlFieldName = MA_ApproveListDR ];

/// MA_InvalidFlag
Property MAInvalidFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 8, SqlFieldName = MA_InvalidFlag ];

/// MA_Hold1
Property MAHold1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = MA_Hold1 ];

/// MA_Hold2
Property MAHold2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = MA_Hold2 ];

/// MA_Hold3
Property MAHold3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = MA_Hold3 ];

/// MA_Hold4
Property MAHold4 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = MA_Hold4 ];

/// MA_Hold5
Property MAHold5 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = MA_Hold5 ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQMultipleApproveInfo("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="MA_ActionDR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="MA_ApproveListDR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="MA_ApproveTypeDR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="MA_BusID">
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
<Data name="MA_Hold4">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="MA_Hold5">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="MA_InvalidFlag">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="MA_MultiDefineDR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="MA_SourceID">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^DHCEQMultipleApproveInfo</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>MA_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{MA_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexSourceID">
<Global>^DHCEQMultipleApproveInfo</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>MA_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"SourceID"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{MA_ApproveTypeDR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{MA_BusID}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{MA_SourceID}</Expression>
</Subscript>
<Subscript name="6">
<AccessType>sub</AccessType>
<Expression>{MA_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQMultipleApproveInfoS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
