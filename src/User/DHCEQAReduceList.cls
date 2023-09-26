Class User.DHCEQAReduceList Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = ARL_RowID, SqlTableName = DHC_EQAReduceList, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// ARL_ReduceDR
Property ARLReduceDR As User.DHCEQAReduce [ SqlColumnNumber = 2, SqlFieldName = ARL_ReduceDR ];

/// ARL_ItemDR
Property ARLItemDR As User.DHCEQCAccessory [ SqlColumnNumber = 3, SqlFieldName = ARL_ItemDR ];

/// ARL_Model
Property ARLModel As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = ARL_Model ];

/// ARL_BaseUOMDR
Property ARLBaseUOMDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = ARL_BaseUOMDR ];

/// ARL_StockDetailDR_
Property ARLStockDetailDR As User.DHCEQAStockDetail [ SqlColumnNumber = 6, SqlFieldName = ARL_StockDetailDR ];

/// ARL_ManuFactoryDR
Property ARLManuFactoryDR As User.DHCEQCVendor [ SqlColumnNumber = 7, SqlFieldName = ARL_ManuFactoryDR ];

/// ARL_BatchFlag
Property ARLBatchFlag As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = ARL_BatchFlag ];

/// ARL_SerialFlag
Property ARLSerialFlag As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = ARL_SerialFlag ];

/// ARL_Price
Property ARLPrice As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = ARL_Price ];

/// ARL_QuantityNum
Property ARLQuantityNum As %Library.Float [ SqlColumnNumber = 11, SqlFieldName = ARL_QuantityNum ];

/// ARL_Amount
Property ARLAmount As %Library.Float [ SqlColumnNumber = 12, SqlFieldName = ARL_Amount ];

/// ARL_Remark
Property ARLRemark As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = ARL_Remark ];

/// ARL_Hold1
Property ARLHold1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = ARL_Hold1 ];

/// ARL_Hold2
Property ARLHold2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 15, SqlFieldName = ARL_Hold2 ];

/// ARL_Hold3
Property ARLHold3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 16, SqlFieldName = ARL_Hold3 ];

/// ARL_Hold4
Property ARLHold4 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 17, SqlFieldName = ARL_Hold4 ];

/// ARL_Hold5
Property ARLHold5 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 18, SqlFieldName = ARL_Hold5 ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQAReduceList("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="ARL_Amount">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="ARL_BaseUOMDR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="ARL_BatchFlag">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="ARL_Hold1">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="ARL_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="ARL_Hold3">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="ARL_Hold4">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="ARL_Hold5">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="ARL_ItemDR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="ARL_ManuFactoryDR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="ARL_Model">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="ARL_Price">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="ARL_QuantityNum">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="ARL_ReduceDR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ARL_Remark">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="ARL_SerialFlag">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="ARL_StockDetailDR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^DHCEQAReduceList</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>ARL_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{ARL_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexReduce">
<Global>^DHCEQAReduceList</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>ARL_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Reduce"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ARL_ReduceDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ARL_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQAReduceListS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
