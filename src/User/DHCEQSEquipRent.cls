Class User.DHCEQSEquipRent Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = ER_RowID, SqlTableName = DHC_EQSEquipRent, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// ER_SourceType
Property ERSourceType As %Library.String(DISPLAYLIST = ",共享资源,设备项", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",1,2") [ SqlColumnNumber = 2, SqlFieldName = ER_SourceType ];

/// ER_SourceID
Property ERSourceID As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = ER_SourceID ];

/// ER_ModelDR
Property ERModelDR As User.DHCEQCModel [ SqlColumnNumber = 4, SqlFieldName = ER_ModelDR ];

/// ER_Mode
Property ERMode As %Library.String(DISPLAYLIST = ",租赁时长,工作量", MAXLEN = 4, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",1,2") [ SqlColumnNumber = 5, SqlFieldName = ER_Mode ];

/// ER_UOMDR
Property ERUOMDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = ER_UOMDR ];

/// ER_Price
Property ERPrice As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = ER_Price ];

/// ER_FromDate
Property ERFromDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 8, SqlFieldName = ER_FromDate ];

/// ER_ToDate
Property ERToDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 9, SqlFieldName = ER_ToDate ];

/// ER_InvalidFlag
Property ERInvalidFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 10, SqlFieldName = ER_InvalidFlag ];

/// ER_Hold1
Property ERHold1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = ER_Hold1 ];

/// ER_Hold2
Property ERHold2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = ER_Hold2 ];

/// ER_Hold3
Property ERHold3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = ER_Hold3 ];

/// ER_Hold4
Property ERHold4 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = ER_Hold4 ];

/// ER_Hold5
Property ERHold5 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 15, SqlFieldName = ER_Hold5 ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQSEquipRent("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="ER_FromDate">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="ER_Hold1">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="ER_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="ER_Hold3">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="ER_Hold4">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="ER_Hold5">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="ER_InvalidFlag">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="ER_Mode">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="ER_ModelDR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="ER_Price">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="ER_SourceID">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="ER_SourceType">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ER_ToDate">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="ER_UOMDR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^DHCEQSEquipRent</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>ER_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{ER_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexSourceID">
<Global>^DHCEQSEquipRent</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>ER_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"SourceID"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ER_SourceType}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ER_SourceID}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{ER_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQSEquipRentS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
