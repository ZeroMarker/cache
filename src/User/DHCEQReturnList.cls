Class User.DHCEQReturnList Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = RL_RowID, SqlTableName = DHC_EQReturnList, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// RL_BatchFlag
Property RLBatchFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 3, SqlFieldName = RL_BatchFlag ];

/// RL_DealFee
Property RLDealFee As %Library.Float [ SqlColumnNumber = 11, SqlFieldName = RL_DealFee ];

/// RL_EquipDR
Property RLEquipDR As User.DHCEQEquip [ SqlColumnNumber = 5, SqlFieldName = RL_EquipDR ];

/// RL_Hold1
Property RLHold1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = RL_Hold1 ];

/// RL_Hold2
Property RLHold2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = RL_Hold2 ];

/// RL_Hold3
Property RLHold3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = RL_Hold3 ];

/// RL_InStockListDR
Property RLInStockListDR As User.DHCEQInStockList [ SqlColumnNumber = 4, SqlFieldName = RL_InStockListDR ];

/// RL_InvoiceNo
Property RLInvoiceNo As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = RL_InvoiceNo ];

/// RL_Remark
Property RLRemark As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = RL_Remark ];

/// RL_ReturnDR
Property RLReturnDR As User.DHCEQReturn [ SqlColumnNumber = 2, SqlFieldName = RL_ReturnDR ];

/// RL_ReturnFee
Property RLReturnFee As %Library.Float [ SqlColumnNumber = 7, SqlFieldName = RL_ReturnFee ];

/// RL_ReturnQtyNum
Property RLReturnQtyNum As %Library.Float [ SqlColumnNumber = 6, SqlFieldName = RL_ReturnQtyNum ];

/// RL_ReturnReasonDR
Property RLReturnReasonDR As %Library.String(COLLATION = "Exact", MAXLEN = 19, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = RL_ReturnReasonDR ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQReturnList("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="RL_BatchFlag">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="RL_DealFee">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="RL_EquipDR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="RL_Hold1">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="RL_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="RL_Hold3">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="RL_InStockListDR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="RL_InvoiceNo">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="RL_Remark">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="RL_ReturnDR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="RL_ReturnFee">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="RL_ReturnQtyNum">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="RL_ReturnReasonDR">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Global>^DHCEQReturnList</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>RL_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{RL_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexEquip">
<Global>^DHCEQReturnList</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>RL_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Equip"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{RL_EquipDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{RL_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexInStockList">
<Global>^DHCEQReturnList</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>RL_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"InStockList"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{RL_InStockListDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{RL_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexInvoiceNo">
<Global>^DHCEQReturnList</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>RL_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"InvoiceNo"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{RL_InvoiceNo}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{RL_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexReturn">
<Global>^DHCEQReturnList</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>RL_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Return"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{RL_ReturnDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{RL_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQReturnListS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
