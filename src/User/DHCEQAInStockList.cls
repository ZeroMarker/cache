Class User.DHCEQAInStockList Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = AISL_RowID, SqlTableName = DHC_EQAInStockList, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// AISL_AInStockDR
Property AISLAInStockDR As User.DHCEQAInStock [ SqlColumnNumber = 2, SqlFieldName = AISL_AInStockDR ];

/// AISL_Amount
Property AISLAmount As %Library.Float [ SqlColumnNumber = 11, SqlFieldName = AISL_Amount ];

/// AISL_BaseUOMDR
Property AISLBaseUOMDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = AISL_BaseUOMDR ];

/// AISL_BatchFlag
Property AISLBatchFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 17, SqlFieldName = AISL_BatchFlag ];

/// AISL_BatchNo
Property AISLBatchNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = AISL_BatchNo ];

/// AISL_Code
Property AISLCode As %Library.String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = AISL_Code ];

/// AISL_Desc
Property AISLDesc As %Library.String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = AISL_Desc ];

/// AISL_EstimateFlag
Property AISLEstimateFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 15, SqlFieldName = AISL_EstimateFlag ];

/// AISL_ExpiryDate
Property AISLExpiryDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 19, SqlFieldName = AISL_ExpiryDate ];

/// AISL_Hold1
Property AISLHold1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 22, SqlFieldName = AISL_Hold1 ];

/// AISL_Hold2
Property AISLHold2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 23, SqlFieldName = AISL_Hold2 ];

/// AISL_Hold3
Property AISLHold3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 24, SqlFieldName = AISL_Hold3 ];

/// AISL_Hold4
Property AISLHold4 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 25, SqlFieldName = AISL_Hold4 ];

/// AISL_Hold5
Property AISLHold5 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 26, SqlFieldName = AISL_Hold5 ];

/// AISL_InvoiceNos
Property AISLInvoiceNos As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 20, SqlFieldName = AISL_InvoiceNos ];

/// AISL_ItemDR
Property AISLItemDR As User.DHCEQCAccessory [ SqlColumnNumber = 3, SqlFieldName = AISL_ItemDR ];

/// AISL_ManuFactoryDR
Property AISLManuFactoryDR As User.DHCEQCVendor [ SqlColumnNumber = 8, SqlFieldName = AISL_ManuFactoryDR ];

/// AISL_Model
Property AISLModel As %Library.String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = AISL_Model ];

/// AISL_Price
Property AISLPrice As %Library.Float [ SqlColumnNumber = 9, SqlFieldName = AISL_Price ];

/// AISL_ProDate
Property AISLProDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 18, SqlFieldName = AISL_ProDate ];

/// AISL_PZDate
Property AISLPZDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 27, SqlFieldName = AISL_PZDate ];

/// AISL_PZID
Property AISLPZID As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = AISL_PZID ];

/// AISL_PZRemark
Property AISLPZRemark As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 28, SqlFieldName = AISL_PZRemark ];

/// AISL_PZType
Property AISLPZType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = AISL_PZType ];

/// AISL_QuantityNum
Property AISLQuantityNum As %Library.Float [ SqlColumnNumber = 10, SqlFieldName = AISL_QuantityNum ];

/// AISL_Remark
Property AISLRemark As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 21, SqlFieldName = AISL_Remark ];

/// AISL_SerialFlag
Property AISLSerialFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 16, SqlFieldName = AISL_SerialFlag ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQAInStockList("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="AISL_AInStockDR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="AISL_Amount">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="AISL_BaseUOMDR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="AISL_BatchFlag">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="AISL_BatchNo">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="AISL_Code">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="AISL_Desc">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="AISL_EstimateFlag">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="AISL_ExpiryDate">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="AISL_Hold1">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="AISL_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="AISL_Hold3">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="AISL_Hold4">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="AISL_Hold5">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="AISL_InvoiceNos">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="AISL_ItemDR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="AISL_ManuFactoryDR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="AISL_Model">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="AISL_PZDate">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="AISL_PZID">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="AISL_PZRemark">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Data name="AISL_PZType">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="AISL_Price">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="AISL_ProDate">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="AISL_QuantityNum">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="AISL_Remark">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="AISL_SerialFlag">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Global>^DHCEQAInStockList</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>AISL_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{AISL_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexAInStock">
<Global>^DHCEQAInStockList</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>AISL_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"AInStock"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{AISL_AInStockDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{AISL_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexAccessory">
<Global>^DHCEQAInStockList</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>AISL_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Accessory"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{AISL_ItemDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{AISL_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexBatchNo">
<Global>^DHCEQAInStockList</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>AISL_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"BatchNo"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{AISL_BatchNo}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{AISL_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexSourceID">
<Global>^DHCEQAInStockList</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>AISL_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Source"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{AISL_PZType}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{AISL_PZID}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{AISL_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQAInStockListS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
