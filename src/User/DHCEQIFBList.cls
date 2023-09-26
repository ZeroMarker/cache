Class User.DHCEQIFBList Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = IFBL_RowID, SqlTableName = DHC_EQIFBList, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// IFBL_SourceType
Property IFBLSourceType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = IFBL_SourceType ];

/// IFBL_SourceID
Property IFBLSourceID As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = IFBL_SourceID ];

/// IFBL_Vendor
Property IFBLVendor As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = IFBL_Vendor ];

/// IFBL_VendorDR
Property IFBLVendorDR As User.DHCEQCVendor [ SqlColumnNumber = 5, SqlFieldName = IFBL_VendorDR ];

/// IFBL_ManuFactory
Property IFBLManuFactory As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = IFBL_ManuFactory ];

/// IFBL_ManuFactoryDR
Property IFBLManuFactoryDR As User.DHCEQCVendor [ SqlColumnNumber = 7, SqlFieldName = IFBL_ManuFactoryDR ];

/// IFBL_Model
Property IFBLModel As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = IFBL_Model ];

/// IFBL_ModelDR
Property IFBLModelDR As User.DHCEQCModel [ SqlColumnNumber = 9, SqlFieldName = IFBL_ModelDR ];

/// IFBL_Brand
Property IFBLBrand As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = IFBL_Brand ];

/// IFBL_BrandDR
Property IFBLBrandDR As User.DHCEQCBrand [ SqlColumnNumber = 11, SqlFieldName = IFBL_BrandDR ];

/// IFBL_Arg
Property IFBLArg As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = IFBL_Arg ];

/// IFBL_Price
Property IFBLPrice As %Library.Float [ SqlColumnNumber = 13, SqlFieldName = IFBL_Price ];

/// IFBL_Amount
Property IFBLAmount As %Library.Float [ SqlColumnNumber = 14, SqlFieldName = IFBL_Amount ];

/// IFBL_WinFlag
Property IFBLWinFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 15, SqlFieldName = IFBL_WinFlag ];

/// IFBL_WinQty
Property IFBLWinQty As %Library.Float [ SqlColumnNumber = 16, SqlFieldName = IFBL_WinQty ];

/// IFBL_Candidacy
Property IFBLCandidacy As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 17, SqlFieldName = IFBL_Candidacy ];

/// IFBL_CandidacySeq
Property IFBLCandidacySeq As %Library.Integer [ SqlColumnNumber = 18, SqlFieldName = IFBL_CandidacySeq ];

/// IFBL_Score
Property IFBLScore As %Library.Float [ SqlColumnNumber = 19, SqlFieldName = IFBL_Score ];

/// IFBL_Remark
Property IFBLRemark As %Library.String(COLLATION = "Exact", MAXLEN = 160, TRUNCATE = 0) [ SqlColumnNumber = 20, SqlFieldName = IFBL_Remark ];

/// IFBL_ProviderHandler
Property IFBLProviderHandler As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 21, SqlFieldName = IFBL_ProviderHandler ];

/// IFBL_ProviderTel
Property IFBLProviderTel As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 22, SqlFieldName = IFBL_ProviderTel ];

/// IFBL_Configure
Property IFBLConfigure As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 23, SqlFieldName = IFBL_Configure ];

/// IFBL_Features
Property IFBLFeatures As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 24, SqlFieldName = IFBL_Features ];

/// IFBL_DealPrice
Property IFBLDealPrice As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 25, SqlFieldName = IFBL_DealPrice ];

/// IFBL_MaterialAndPrice
Property IFBLMaterialAndPrice As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 26, SqlFieldName = IFBL_MaterialAndPrice ];

/// IFBL_Quanlity
Property IFBLQuanlity As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 27, SqlFieldName = IFBL_Quanlity ];

/// IFBL_GuaranteePeriodNum
Property IFBLGuaranteePeriodNum As %Library.Float [ SqlColumnNumber = 28, SqlFieldName = IFBL_GuaranteePeriodNum ];

/// IFBL_ArriveNum
Property IFBLArriveNum As %Library.Float [ SqlColumnNumber = 29, SqlFieldName = IFBL_ArriveNum ];

/// IFBL_Hold1
Property IFBLHold1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 30, SqlFieldName = IFBL_Hold1 ];

/// IFBL_Hold2
Property IFBLHold2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 31, SqlFieldName = IFBL_Hold2 ];

/// IFBL_Hold3
Property IFBLHold3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 32, SqlFieldName = IFBL_Hold3 ];

/// IFBL_Hold4
Property IFBLHold4 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 33, SqlFieldName = IFBL_Hold4 ];

/// IFBL_Hold5
Property IFBLHold5 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 34, SqlFieldName = IFBL_Hold5 ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQIFBList("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="IFBL_Amount">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="IFBL_Arg">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="IFBL_ArriveNum">
<Delimiter>"^"</Delimiter>
<Piece>28</Piece>
</Data>
<Data name="IFBL_Brand">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="IFBL_BrandDR">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="IFBL_Candidacy">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="IFBL_CandidacySeq">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="IFBL_Configure">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="IFBL_DealPrice">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="IFBL_Features">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="IFBL_GuaranteePeriodNum">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Data name="IFBL_Hold1">
<Delimiter>"^"</Delimiter>
<Piece>29</Piece>
</Data>
<Data name="IFBL_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>30</Piece>
</Data>
<Data name="IFBL_Hold3">
<Delimiter>"^"</Delimiter>
<Piece>31</Piece>
</Data>
<Data name="IFBL_Hold4">
<Delimiter>"^"</Delimiter>
<Piece>32</Piece>
</Data>
<Data name="IFBL_Hold5">
<Delimiter>"^"</Delimiter>
<Piece>33</Piece>
</Data>
<Data name="IFBL_ManuFactory">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="IFBL_ManuFactoryDR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="IFBL_MaterialAndPrice">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="IFBL_Model">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="IFBL_ModelDR">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="IFBL_Price">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="IFBL_ProviderHandler">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="IFBL_ProviderTel">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="IFBL_Quanlity">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="IFBL_Remark">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="IFBL_Score">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="IFBL_SourceID">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="IFBL_SourceType">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="IFBL_Vendor">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="IFBL_VendorDR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="IFBL_WinFlag">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="IFBL_WinQty">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Global>^DHCEQIFBList</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>IFBL_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{IFBL_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="indexPlanList">
<Global>^DHCEQIFBList</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>IFBL_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Source"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{IFBL_SourceType}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{IFBL_SourceID}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{IFBL_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQIFBListS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
