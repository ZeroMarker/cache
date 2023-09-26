Class User.DHCEQAStockDetail Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = ASD_RowID, SqlTableName = DHC_EQAStockDetail, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// ASD_AInStockListDR
Property ASDAInStockListDR As User.DHCEQAInStockList [ SqlColumnNumber = 4, SqlFieldName = ASD_AInStockListDR ];

/// ASD_AccessoryTypeDR
Property ASDAccessoryTypeDR As User.DHCEQCAccessoryType [ SqlColumnNumber = 12, SqlFieldName = ASD_AccessoryTypeDR ];

/// ASD_BPrice
Property ASDBPrice As %Library.Float [ SqlColumnNumber = 9, SqlFieldName = ASD_BPrice ];

/// ASD_BaseUOMDR
Property ASDBaseUOMDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = ASD_BaseUOMDR ];

/// ASD_BatchNo
Property ASDBatchNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = ASD_BatchNo ];

/// ASD_BillPage
Property ASDBillPage As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 30, SqlFieldName = ASD_BillPage ];

/// ASD_Code
Property ASDCode As %Library.String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = ASD_Code ];

/// ASD_Desc
Property ASDDesc As %Library.String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = ASD_Desc ];

/// ASD_DisuseDate
Property ASDDisuseDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 21, SqlFieldName = ASD_DisuseDate ];

/// ASD_ExpiryDate
Property ASDExpiryDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 8, SqlFieldName = ASD_ExpiryDate ];

/// ASD_FreezeStock
Property ASDFreezeStock As %Library.Float [ SqlColumnNumber = 19, SqlFieldName = ASD_FreezeStock ];

/// ASD_HasStockFlag
Property ASDHasStockFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 27, SqlFieldName = ASD_HasStockFlag ];

/// ASD_Hold1
Property ASDHold1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 31, SqlFieldName = ASD_Hold1 ];

/// ASD_Hold2
Property ASDHold2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 32, SqlFieldName = ASD_Hold2 ];

/// ASD_Hold3
Property ASDHold3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 33, SqlFieldName = ASD_Hold3 ];

/// ASD_Hold4
Property ASDHold4 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 34, SqlFieldName = ASD_Hold4 ];

/// ASD_Hold5
Property ASDHold5 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 35, SqlFieldName = ASD_Hold5 ];

/// ASD_InSourceID
Property ASDInSourceID As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 24, SqlFieldName = ASD_InSourceID ];

/// ASD_InType
Property ASDInType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 23, SqlFieldName = ASD_InType ];

/// ASD_ItemDR
Property ASDItemDR As User.DHCEQCAccessory [ SqlColumnNumber = 3, SqlFieldName = ASD_ItemDR ];

/// ASD_LocDR
Property ASDLocDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = ASD_LocDR ];

/// ASD_Location
Property ASDLocation As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 29, SqlFieldName = ASD_Location ];

/// ASD_ManuFactoryDR
Property ASDManuFactoryDR As User.DHCEQCVendor [ SqlColumnNumber = 15, SqlFieldName = ASD_ManuFactoryDR ];

/// ASD_Model
Property ASDModel As %Library.String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 0) [ SqlColumnNumber = 16, SqlFieldName = ASD_Model ];

/// ASD_No
Property ASDNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = ASD_No ];

/// ASD_ProviderDR
Property ASDProviderDR As User.DHCEQCVendor [ SqlColumnNumber = 17, SqlFieldName = ASD_ProviderDR ];

/// ASD_Remark
Property ASDRemark As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 28, SqlFieldName = ASD_Remark ];

/// ASD_SerialNo
Property ASDSerialNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = ASD_SerialNo ];

/// ASD_StartDate
Property ASDStartDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 20, SqlFieldName = ASD_StartDate ];

/// ASD_Status
Property ASDStatus As %Library.String(DISPLAYLIST = ",在库,使用,消耗,退货", MAXLEN = 2, SELECTIVITY = "20.0000%", TRUNCATE = 1, VALUELIST = ",0,1,2,3") [ SqlColumnNumber = 13, SqlFieldName = ASD_Status ];

/// ASD_Stock
Property ASDStock As %Library.Float [ SqlColumnNumber = 18, SqlFieldName = ASD_Stock ];

/// ASD_StockDR
Property ASDStockDR As User.DHCEQAStock [ SqlColumnNumber = 22, SqlFieldName = ASD_StockDR ];

/// ASD_ToSourceID
Property ASDToSourceID As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 26, SqlFieldName = ASD_ToSourceID ];

/// ASD_ToType
Property ASDToType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 25, SqlFieldName = ASD_ToType ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQAStockDetail("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="ASD_AInStockListDR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="ASD_AccessoryTypeDR">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="ASD_BPrice">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="ASD_BaseUOMDR">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="ASD_BatchNo">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="ASD_BillPage">
<Delimiter>"^"</Delimiter>
<Piece>29</Piece>
</Data>
<Data name="ASD_Code">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="ASD_Desc">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="ASD_DisuseDate">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="ASD_ExpiryDate">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="ASD_FreezeStock">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="ASD_HasStockFlag">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="ASD_Hold1">
<Delimiter>"^"</Delimiter>
<Piece>30</Piece>
</Data>
<Data name="ASD_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>31</Piece>
</Data>
<Data name="ASD_Hold3">
<Delimiter>"^"</Delimiter>
<Piece>32</Piece>
</Data>
<Data name="ASD_Hold4">
<Delimiter>"^"</Delimiter>
<Piece>33</Piece>
</Data>
<Data name="ASD_Hold5">
<Delimiter>"^"</Delimiter>
<Piece>34</Piece>
</Data>
<Data name="ASD_InSourceID">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="ASD_InType">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="ASD_ItemDR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="ASD_LocDR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ASD_Location">
<Delimiter>"^"</Delimiter>
<Piece>28</Piece>
</Data>
<Data name="ASD_ManuFactoryDR">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="ASD_Model">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="ASD_No">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="ASD_ProviderDR">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="ASD_Remark">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Data name="ASD_SerialNo">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="ASD_StartDate">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="ASD_Status">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="ASD_Stock">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="ASD_StockDR">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="ASD_ToSourceID">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="ASD_ToType">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Global>^DHCEQAStockDetail</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>ASD_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{ASD_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexAInStockList">
<Global>^DHCEQAStockDetail</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>ASD_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"AInStockList"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ASD_AInStockListDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ASD_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexAStock">
<Global>^DHCEQAStockDetail</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>ASD_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"AStock"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ASD_StockDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ASD_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexAccessory">
<Global>^DHCEQAStockDetail</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>ASD_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Accessory"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ASD_ItemDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ASD_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexBatchNo">
<Global>^DHCEQAStockDetail</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>ASD_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"BatchNo"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ASD_BatchNo}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ASD_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQAStockDetailS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
