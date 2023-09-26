Class User.DHCEQMMaintPart Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = MTP_RowID, SqlTableName = DHC_EQMMaintPart, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// MTP_AccessoryDR
Property MTPAccessoryDR As User.DHCEQCAccessory [ SqlColumnNumber = 3, SqlFieldName = MTP_AccessoryDR ];

/// MTP_AccessryTypeDR
Property MTPAccessryTypeDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = MTP_AccessryTypeDR ];

/// MTP_AISListDR
Property MTPAISListDR As User.DHCEQAInStockList [ SqlColumnNumber = 19, SqlFieldName = MTP_AISListDR ];

/// MTP_AMSListDR
Property MTPAMSListDR As User.DHCEQAMoveStockList [ SqlColumnNumber = 12, SqlFieldName = MTP_AMSListDR ];

/// MTP_Desc
Property MTPDesc As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 20, SqlFieldName = MTP_Desc ];

/// MTP_FeeFlag
Property MTPFeeFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 9, SqlFieldName = MTP_FeeFlag ];

/// MTP_OfferPrice
Property MTPOfferPrice As %Library.Float [ SqlColumnNumber = 22, SqlFieldName = MTP_OfferPrice ];

/// MTP_AccessoryOriginalDR
Property MTPAccessoryOriginalDR As User.DHCEQCAccessoryOriginal [ SqlColumnNumber = 23, SqlFieldName = MTP_AccessoryOriginalDR ];

/// MTP_Hold3
Property MTPHold3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 24, SqlFieldName = MTP_Hold3 ];

/// MTP_Hold4
Property MTPHold4 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 25, SqlFieldName = MTP_Hold4 ];

/// MTP_Hold5
Property MTPHold5 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 26, SqlFieldName = MTP_Hold5 ];

/// MTP_Hold6
Property MTPHold6 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 27, SqlFieldName = MTP_Hold6 ];

/// MTP_Hold7
Property MTPHold7 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 28, SqlFieldName = MTP_Hold7 ];

/// MTP_Hold8
Property MTPHold8 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 29, SqlFieldName = MTP_Hold8 ];

/// MTP_InvoiceNos
Property MTPInvoiceNos As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 21, SqlFieldName = MTP_InvoiceNos ];

/// MTP_MaintDR
Property MTPMaintDR As User.DHCEQMMaint [ SqlColumnNumber = 2, SqlFieldName = MTP_MaintDR ];

/// MTP_MaintItemDR
Property MTPMaintItemDR As User.DHCEQMMaintItem [ SqlColumnNumber = 18, SqlFieldName = MTP_MaintItemDR ];

/// MTP_MaintRequestDR
Property MTPMaintRequestDR As User.DHCEQMMaintRequest [ SqlColumnNumber = 10, SqlFieldName = MTP_MaintRequestDR ];

/// MTP_ManufacturerDR
Property MTPManufacturerDR As User.DHCEQCManufacturer [ SqlColumnNumber = 16, SqlFieldName = MTP_ManufacturerDR ];

/// MTP_Model
Property MTPModel As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 15, SqlFieldName = MTP_Model ];

/// MTP_PriceFee
Property MTPPriceFee As %Library.Float [ SqlColumnNumber = 5, SqlFieldName = MTP_PriceFee ];

/// MTP_ProviderDR
Property MTPProviderDR As User.DHCEQCVendor [ SqlColumnNumber = 17, SqlFieldName = MTP_ProviderDR ];

/// MTP_PurchaseFlag
Property MTPPurchaseFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 13, SqlFieldName = MTP_PurchaseFlag ];

/// MTP_QuantityNum
Property MTPQuantityNum As %Library.Float [ SqlColumnNumber = 4, SqlFieldName = MTP_QuantityNum ];

/// MTP_Remark
Property MTPRemark As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = MTP_Remark ];

/// MTP_StockDetailDR
Property MTPStockDetailDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = MTP_StockDetailDR ];

/// MTP_StoreRoomDR
Property MTPStoreRoomDR As User.CTLoc [ SqlColumnNumber = 8, SqlFieldName = MTP_StoreRoomDR ];

/// MTP_TotalFee
Property MTPTotalFee As %Library.Float [ SqlColumnNumber = 6, SqlFieldName = MTP_TotalFee ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQMMaintPart("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="MTP_AISListDR">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="MTP_AMSListDR">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="MTP_AccessoryDR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="MTP_AccessoryOriginalDR">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="MTP_AccessryTypeDR">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="MTP_Desc">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="MTP_FeeFlag">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="MTP_Hold3">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="MTP_Hold4">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="MTP_Hold5">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="MTP_Hold6">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="MTP_Hold7">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Data name="MTP_Hold8">
<Delimiter>"^"</Delimiter>
<Piece>28</Piece>
</Data>
<Data name="MTP_InvoiceNos">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="MTP_MaintDR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="MTP_MaintItemDR">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="MTP_MaintRequestDR">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="MTP_ManufacturerDR">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="MTP_Model">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="MTP_OfferPrice">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="MTP_PriceFee">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="MTP_ProviderDR">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="MTP_PurchaseFlag">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="MTP_QuantityNum">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="MTP_Remark">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="MTP_StockDetailDR">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="MTP_StoreRoomDR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="MTP_TotalFee">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^DHCEQMMaintPart</Global>
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
<SQLMap name="IndexAInStockList">
<Global>^DHCEQMMaintPart</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>MTP_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"AInStockList"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{MTP_AISListDR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{MTP_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexAMoveStockList">
<Global>^DHCEQMMaintPart</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>MTP_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"AMoveStockList"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{MTP_AMSListDR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{MTP_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexAStockDetail">
<Global>^DHCEQMMaintPart</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>MTP_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"AStockDetail"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{MTP_MaintRequestDR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>+{MTP_StockDetailDR}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{MTP_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexAccessory">
<Global>^DHCEQMMaintPart</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>MTP_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"Accessory"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{MTP_AccessoryDR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{MTP_StoreRoomDR}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{MTP_ProviderDR}</Expression>
</Subscript>
<Subscript name="6">
<AccessType>sub</AccessType>
<Expression>{MTP_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexInvoiceNos">
<Global>^DHCEQMMaintPart</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>MTP_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"InvoiceNos"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{MTP_MaintRequestDR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>+{MTP_InvoiceNos}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{MTP_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexMaintRequest">
<Global>^DHCEQMMaintPart</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>MTP_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"MaintRequest"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{MTP_MaintRequestDR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{MTP_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPurchaseFlag">
<Global>^DHCEQMMaintPart</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>MTP_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"PurchaseFlag"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{MTP_PurchaseFlag}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{MTP_MaintRequestDR}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{MTP_AccessoryDR}</Expression>
</Subscript>
<Subscript name="6">
<AccessType>sub</AccessType>
<Expression>{MTP_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQMMaintPartS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
