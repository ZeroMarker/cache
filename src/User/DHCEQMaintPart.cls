Class User.DHCEQMaintPart Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = MTP_RowID, SqlTableName = DHC_EQMaintPart, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// MTP_MaintDR
Property MTPMaintDR As User.DHCEQMaint [ SqlColumnNumber = 2, SqlFieldName = MTP_MaintDR ];

/// MTP_FittingsDR
Property MTPFittingsDR As User.DHCEQCFittings [ SqlColumnNumber = 3, SqlFieldName = MTP_FittingsDR ];

/// MTP_QuantityNum
Property MTPQuantityNum As %Library.Float [ SqlColumnNumber = 4, SqlFieldName = MTP_QuantityNum ];

/// MTP_PriceFee
Property MTPPriceFee As %Library.Float [ SqlColumnNumber = 5, SqlFieldName = MTP_PriceFee ];

/// MTP_TotalFee
Property MTPTotalFee As %Library.Float [ SqlColumnNumber = 6, SqlFieldName = MTP_TotalFee ];

/// MTP_Remark
Property MTPRemark As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = MTP_Remark ];

/// MTP_StoreRoomDR
Property MTPStoreRoomDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = MTP_StoreRoomDR ];

/// MTP_FeeFlag
Property MTPFeeFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 9, SqlFieldName = MTP_FeeFlag ];

/// MTP_Hold1
Property MTPHold1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = MTP_Hold1 ];

/// MTP_Hold2
Property MTPHold2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = MTP_Hold2 ];

/// MTP_Hold3
Property MTPHold3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = MTP_Hold3 ];

/// MTP_Hold4
Property MTPHold4 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = MTP_Hold4 ];

/// MTP_Hold5
Property MTPHold5 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = MTP_Hold5 ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQMaintPart("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="MTP_FeeFlag">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="MTP_FittingsDR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="MTP_Hold1">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="MTP_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="MTP_Hold3">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="MTP_Hold4">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="MTP_Hold5">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="MTP_MaintDR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="MTP_PriceFee">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="MTP_QuantityNum">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="MTP_Remark">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="MTP_StoreRoomDR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="MTP_TotalFee">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^DHCEQMaintPart</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>MTP_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{MTP_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCEQMaintPartS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
