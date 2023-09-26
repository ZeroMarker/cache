Class User.DHCEQAMoveStockList Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = AMSL_RowID, SqlTableName = DHC_EQAMoveStockList, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// AMSL_AISListDR
Property AMSLAISListDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 16, SqlFieldName = AMSL_AISListDR ];

/// AMSL_Amount
Property AMSLAmount As %Library.Float [ SqlColumnNumber = 13, SqlFieldName = AMSL_Amount ];

/// AMSL_BaseUOMDR
Property AMSLBaseUOMDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = AMSL_BaseUOMDR ];

/// AMSL_BatchFlag
Property AMSLBatchFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 9, SqlFieldName = AMSL_BatchFlag ];

/// AMSL_Code
Property AMSLCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = AMSL_Code ];

/// AMSL_Desc
Property AMSLDesc As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = AMSL_Desc ];

/// AMSL_EquipDR
Property AMSLEquipDR As User.DHCEQEquip [ SqlColumnNumber = 17, SqlFieldName = AMSL_EquipDR ];

/// AMSL_Hold1
Property AMSLHold1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 19, SqlFieldName = AMSL_Hold1 ];

/// AMSL_Hold2
Property AMSLHold2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 20, SqlFieldName = AMSL_Hold2 ];

/// AMSL_Hold3
Property AMSLHold3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 21, SqlFieldName = AMSL_Hold3 ];

/// AMSL_Hold4
Property AMSLHold4 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 22, SqlFieldName = AMSL_Hold4 ];

/// AMSL_Hold5
Property AMSLHold5 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 23, SqlFieldName = AMSL_Hold5 ];

/// AMSL_ItemDR
Property AMSLItemDR As User.DHCEQCAccessory [ SqlColumnNumber = 3, SqlFieldName = AMSL_ItemDR ];

/// AMSL_MaintPartDR
Property AMSLMaintPartDR As User.DHCEQMMaintPart [ SqlColumnNumber = 18, SqlFieldName = AMSL_MaintPartDR ];

/// AMSL_ManuFactoryDR
Property AMSLManuFactoryDR As User.DHCEQCVendor [ SqlColumnNumber = 8, SqlFieldName = AMSL_ManuFactoryDR ];

/// AMSL_Model
Property AMSLModel As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = AMSL_Model ];

/// AMSL_MoveStockDR
Property AMSLMoveStockDR As User.DHCEQAMoveStock [ SqlColumnNumber = 2, SqlFieldName = AMSL_MoveStockDR ];

/// AMSL_Price
Property AMSLPrice As %Library.Float [ SqlColumnNumber = 11, SqlFieldName = AMSL_Price ];

/// AMSL_QuantityNum
Property AMSLQuantityNum As %Library.Float [ SqlColumnNumber = 12, SqlFieldName = AMSL_QuantityNum ];

/// AMSL_Remark
Property AMSLRemark As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = AMSL_Remark ];

/// AMSL_SerialFlag
Property AMSLSerialFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 10, SqlFieldName = AMSL_SerialFlag ];

/// AMSL_StockDetailDR
Property AMSLStockDetailDR As User.DHCEQAStockDetail [ SqlColumnNumber = 15, SqlFieldName = AMSL_StockDetailDR ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQAMoveStockList("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="AMSL_AISListDR">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="AMSL_Amount">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="AMSL_BaseUOMDR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="AMSL_BatchFlag">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="AMSL_Code">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="AMSL_Desc">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="AMSL_EquipDR">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="AMSL_Hold1">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="AMSL_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="AMSL_Hold3">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="AMSL_Hold4">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="AMSL_Hold5">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="AMSL_ItemDR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="AMSL_MaintPartDR">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="AMSL_ManuFactoryDR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="AMSL_Model">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="AMSL_MoveStockDR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="AMSL_Price">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="AMSL_QuantityNum">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="AMSL_Remark">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="AMSL_SerialFlag">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="AMSL_StockDetailDR">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Global>^DHCEQAMoveStockList</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>AMSL_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{AMSL_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexAccessory">
<Global>^DHCEQAMoveStockList</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>AMSL_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Accessory"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{AMSL_ItemDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{AMSL_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexInStockList">
<Global>^DHCEQAMoveStockList</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>AMSL_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"InStockList"</Expression>
</Subscript>
<Subscript name="3">
<Expression>+{AMSL_AISListDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{AMSL_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexMoveStock">
<Global>^DHCEQAMoveStockList</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>AMSL_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"MoveStock"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{AMSL_MoveStockDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{AMSL_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQAMoveStockListS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
