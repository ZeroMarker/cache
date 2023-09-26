Class User.PMPProduct Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PPD_Rowid, SqlTableName = PMP_Product, StorageStrategy = SQLStorage ]
{

/// PPD_Code
Property PPDCode As %String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = PPD_Code ];

/// DTY_Desc
Property PPDDesc As %String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = PPD_Desc ];

/// PPD_Supplier_DR
Property PPDSupplierDR As PMPCompany [ SqlColumnNumber = 4, SqlFieldName = PPD_Supplier_DR ];

/// PPD_Type
Property PPDType As PMPDictionary3 [ SqlColumnNumber = 5, SqlFieldName = PPD_Type ];

/// PPD_Versions
Property PPDVersions As %String(COLLATION = "Exact", MAXLEN = 128, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = PPD_Versions ];

/// PPD_Producer_DR
Property PPDProducerDR As PMPCompany [ SqlColumnNumber = 7, SqlFieldName = PPD_Producer_DR ];

/// PPD_Count
Property PPDCount As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = PPD_Count ];

/// PPD_Unit
Property PPDUnit As PMPDictionary3 [ SqlColumnNumber = 9, SqlFieldName = PPD_Unit ];

/// PPD_Price
Property PPDPrice As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = PPD_Price ];

/// PPD_TotalPrice
Property PPDTotalPrice As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = PPD_TotalPrice ];

/// PPD_Standard
Property PPDStandard As %String(COLLATION = "Exact", MAXLEN = 128, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = PPD_Standard ];

/// PPD_PurchaseData
Property PPDPurchaseData As %Date [ SqlColumnNumber = 13, SqlFieldName = PPD_PurchaseData ];

/// PPD_PurchaseTime
Property PPDPurchaseTime As %Time [ SqlColumnNumber = 14, SqlFieldName = PPD_PurchaseTime ];

/// PPD_PurchaseUser
Property PPDPurchaseUser As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 15, SqlFieldName = PPD_PurchaseUser ];

/// PPD_GoodsData
Property PPDGoodsData As %Date [ SqlColumnNumber = 16, SqlFieldName = PPD_GoodsData ];

/// PPD_GoodsTime
Property PPDGoodsTime As %Time [ SqlColumnNumber = 17, SqlFieldName = PPD_GoodsTime ];

/// PPD_GoodsUser
Property PPDGoodsUser As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 18, SqlFieldName = PPD_GoodsUser ];

/// PPD_Date
Property PPDDate As %Date [ SqlColumnNumber = 19, SqlFieldName = PPD_Date ];

/// PPD_Time
Property PPDTime As %Time [ SqlColumnNumber = 20, SqlFieldName = PPD_Time ];

/// PPDUser
Property PPDUser As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 21, SqlFieldName = PPD_User ];

/// PPD_UpdateDate
Property PPDUpdateDate As %Date [ SqlColumnNumber = 22, SqlFieldName = PPD_UpdateDate ];

/// PPD_UpdateTime
Property PPDUpdateTime As %Time [ SqlColumnNumber = 23, SqlFieldName = PPD_UpdateTime ];

/// PPD_UpdateUser
Property PPDUpdateUser As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 24, SqlFieldName = PPD_UpdateUser ];

/// PPD_Remark
Property PPDRemark As %String(COLLATION = "Exact", MAXLEN = 1024, TRUNCATE = 0) [ SqlColumnNumber = 25, SqlFieldName = PPD_Remark ];

/// PPD_Standby1
Property PPDStandby1 As %String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 26, SqlFieldName = PPD_Standby1 ];

/// PPD_Standby2
Property PPDStandby2 As %String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 27, SqlFieldName = PPD_Standby2 ];

/// PPD_Standby3
Property PPDStandby3 As %String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 28, SqlFieldName = PPD_Standby3 ];

/// PPD_Standby4
Property PPDStandby4 As %String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 29, SqlFieldName = PPD_Standby4 ];

/// PPD_Standby5
Property PPDStandby5 As %String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 30, SqlFieldName = PPD_Standby5 ];

/// PPD_Standby6
Property PPDStandby6 As %String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 31, SqlFieldName = PPD_Standby6 ];

/// PPD_Standby7
Property PPDStandby7 As %String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 32, SqlFieldName = PPD_Standby7 ];

/// PPD_Standby8
Property PPDStandby8 As %String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 33, SqlFieldName = PPD_Standby8 ];

/// PPD_Standby9
Property PPDStandby9 As %String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 34, SqlFieldName = PPD_Standby9 ];

/// PPD_Standby10
Property PPDStandby10 As %String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 35, SqlFieldName = PPD_Standby10 ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^User.PMPProduct("0"))</SqlIdExpression>
<SQLMap name="DataMasterMap">
<Data name="PPD_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PPD_Count">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="PPD_Date">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="PPD_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PPD_GoodsData">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="PPD_GoodsTime">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="PPD_GoodsUser">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="PPD_Price">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="PPD_Producer_DR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PPD_PurchaseData">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="PPD_PurchaseTime">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="PPD_PurchaseUser">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="PPD_Remark">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="PPD_Standard">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="PPD_Standby1">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="PPD_Standby10">
<Delimiter>"^"</Delimiter>
<Piece>34</Piece>
</Data>
<Data name="PPD_Standby2">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="PPD_Standby3">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Data name="PPD_Standby4">
<Delimiter>"^"</Delimiter>
<Piece>28</Piece>
</Data>
<Data name="PPD_Standby5">
<Delimiter>"^"</Delimiter>
<Piece>29</Piece>
</Data>
<Data name="PPD_Standby6">
<Delimiter>"^"</Delimiter>
<Piece>30</Piece>
</Data>
<Data name="PPD_Standby7">
<Delimiter>"^"</Delimiter>
<Piece>31</Piece>
</Data>
<Data name="PPD_Standby8">
<Delimiter>"^"</Delimiter>
<Piece>32</Piece>
</Data>
<Data name="PPD_Standby9">
<Delimiter>"^"</Delimiter>
<Piece>33</Piece>
</Data>
<Data name="PPD_Supplier_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PPD_Time">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="PPD_TotalPrice">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="PPD_Type">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PPD_Unit">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="PPD_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="PPD_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="PPD_UpdateUser">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="PPD_User">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="PPD_Versions">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^PMPProduct</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PPD_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{PPD_Rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexofCode">
<Global>^PMPProducti</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>"PPD_Code"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PPD_Code}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PPD_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexofDate">
<Global>^PMPProducti</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>"PPD_Date"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PPD_Date}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PPD_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexofDesc">
<Global>^PMPProducti</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>"PPD_Desc"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PPD_Desc}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PPD_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexofProductr">
<Global>^PMPProducti</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>"PPD_Productr"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PPD_Producer_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PPD_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexofSupplier">
<Global>^PMPProducti</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>"SupplierDR"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PPD_Supplier_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PPD_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexofType">
<Global>^PMPProducti</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>"PPD_Type"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PPD_Type}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PPD_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexofUser">
<Global>^PMPProducti</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>"PPD_User"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PPD_User}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PPD_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.PMPProductS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
