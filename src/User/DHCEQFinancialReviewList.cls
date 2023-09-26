Class User.DHCEQFinancialReviewList Extends %Persistent [ ClassType = persistent, Not ProcedureBlock, SqlTableName = DHC_EQFinancialReviewList, StorageStrategy = SQLStorage ]
{

/// FRL_FinancialReviewDR
Property FRLFinancialReviewDR As DHCEQFinancialReview [ SqlColumnNumber = 2, SqlFieldName = FRL_FinancialReviewDR ];

/// FRL_SourceID
Property FRLSourceID As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = FRL_SourceID ];

/// FRL_EquipTypeDR
Property FRLEquipTypeDR As DHCEQCEquipType [ SqlColumnNumber = 4, SqlFieldName = FRL_EquipTypeDR ];

/// FRL_StatCatDR
Property FRLStatCatDR As DHCEQCStatCat [ SqlColumnNumber = 5, SqlFieldName = FRL_StatCatDR ];

/// FRL_LocDR
Property FRLLocDR As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = FRL_LocDR ];

/// FRL_OriginDR
Property FRLOriginDR As DHCEQCOrigin [ SqlColumnNumber = 7, SqlFieldName = FRL_OriginDR ];

/// FRL_EquipName
Property FRLEquipName As %String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = FRL_EquipName ];

/// FRL_QuantityNum
Property FRLQuantityNum As %Float [ SqlColumnNumber = 9, SqlFieldName = FRL_QuantityNum ];

/// FRL_Price
Property FRLPrice As %Float [ SqlColumnNumber = 10, SqlFieldName = FRL_Price ];

/// FRL_Amount
Property FRLAmount As %Float [ SqlColumnNumber = 11, SqlFieldName = FRL_Amount ];

/// FRL_FundsInfo
Property FRLFundsInfo As %String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = FRL_FundsInfo ];

/// FRL_OtherInfo
Property FRLOtherInfo As %String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = FRL_OtherInfo ];

/// FRL_Remark
Property FRLRemark As %String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = FRL_Remark ];

/// FRL_Hold1
Property FRLHold1 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 34, SqlFieldName = FRL_Hold1 ];

/// FRL_Hold2
Property FRLHold2 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 35, SqlFieldName = FRL_Hold2 ];

/// FRL_Hold3
Property FRLHold3 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 36, SqlFieldName = FRL_Hold3 ];

/// FRL_Hold4
Property FRLHold4 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 37, SqlFieldName = FRL_Hold4 ];

/// FRL_Hold5
Property FRLHold5 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 38, SqlFieldName = FRL_Hold5 ];

/// FRL_AccountFlag
Property FRLAccountFlag As %String(DISPLAYLIST = ",未传输,未做账,已做账", MAXLEN = 2, VALUELIST = ",0,1,2") [ SqlColumnNumber = 25, SqlFieldName = FRL_AccountFlag ];

/// FRL_AccountDate
Property FRLAccountDate As %Date [ SqlColumnNumber = 26, SqlFieldName = FRL_AccountDate ];

/// FRL_AccountTime
Property FRLAccountTime As %Time [ SqlColumnNumber = 27, SqlFieldName = FRL_AccountTime ];

/// FRL_Voucher
Property FRLVoucher As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 28, SqlFieldName = FRL_Voucher ];

/// FRL_EquipCatDR
Property FRLEquipCatDR As DHCEQCEquipeCat [ SqlColumnNumber = 15, SqlFieldName = FRL_EquipCatDR ];

/// FRL_UnitDR
Property FRLUnitDR As DHCEQCUOM [ SqlColumnNumber = 16, SqlFieldName = FRL_UnitDR ];

/// FRL_VendorDR
Property FRLVendorDR As DHCEQCVendor [ SqlColumnNumber = 17, SqlFieldName = FRL_VendorDR ];

/// FRL_ModelDR
Property FRLModelDR As DHCEQCModel [ SqlColumnNumber = 18, SqlFieldName = FRL_ModelDR ];

/// FRL_ManuFactoryDR
Property FRLManuFactoryDR As DHCEQCManufacturer [ SqlColumnNumber = 19, SqlFieldName = FRL_ManuFactoryDR ];

/// FRL_BrandDR
Property FRLBrandDR As DHCEQCBrand [ SqlColumnNumber = 20, SqlFieldName = FRL_BrandDR ];

/// FRL_CountryDR
Property FRLCountryDR As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 21, SqlFieldName = FRL_CountryDR ];

/// FRL_ToLoc
Property FRLToLoc As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 22, SqlFieldName = FRL_ToLoc ];

/// FRL_ChangeDepreTotal
Property FRLChangeDepreTotal As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 23, SqlFieldName = FRL_ChangeDepreTotal ];

/// FRL_ToDept
Property FRLToDept As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 24, SqlFieldName = FRL_ToDept ];

/// FRL_BussUserDR
Property FRLBussUserDR As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 29, SqlFieldName = FRL_BussUserDR ];

/// FRL_BussDate
Property FRLBussDate As %Date [ SqlColumnNumber = 30, SqlFieldName = FRL_BussDate ];

/// FRL_BudgetNo
Property FRLBudgetNo As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 31, SqlFieldName = FRL_BudgetNo ];

/// FRL_DepreBussType
Property FRLDepreBussType As %String(DISPLAYLIST = ",正常折旧,退货回冲,处置回冲", MAXLEN = 2, VALUELIST = ",0,1,2") [ SqlColumnNumber = 32, SqlFieldName = FRL_DepreBussType ];

/// FRL_BussNo
Property FRLBussNo As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 33, SqlFieldName = FRL_BussNo ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCEQFinancialReviewList("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="FRL_AccountDate">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="FRL_AccountFlag">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="FRL_AccountTime">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="FRL_Amount">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="FRL_BrandDR">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="FRL_BudgetNo">
<Delimiter>"^"</Delimiter>
<Piece>30</Piece>
</Data>
<Data name="FRL_BussDate">
<Delimiter>"^"</Delimiter>
<Piece>29</Piece>
</Data>
<Data name="FRL_BussNo">
<Delimiter>"^"</Delimiter>
<Piece>32</Piece>
</Data>
<Data name="FRL_BussUserDR">
<Delimiter>"^"</Delimiter>
<Piece>28</Piece>
</Data>
<Data name="FRL_ChangeDepreTotal">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="FRL_CountryDR">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="FRL_DepreBussType">
<Delimiter>"^"</Delimiter>
<Piece>31</Piece>
</Data>
<Data name="FRL_EquipCatDR">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="FRL_EquipName">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="FRL_EquipTypeDR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="FRL_FinancialReviewDR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="FRL_FundsInfo">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="FRL_Hold1">
<Delimiter>"^"</Delimiter>
<Piece>33</Piece>
</Data>
<Data name="FRL_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>34</Piece>
</Data>
<Data name="FRL_Hold3">
<Delimiter>"^"</Delimiter>
<Piece>35</Piece>
</Data>
<Data name="FRL_Hold4">
<Delimiter>"^"</Delimiter>
<Piece>36</Piece>
</Data>
<Data name="FRL_Hold5">
<Delimiter>"^"</Delimiter>
<Piece>37</Piece>
</Data>
<Data name="FRL_LocDR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="FRL_ManuFactoryDR">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="FRL_ModelDR">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="FRL_OriginDR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="FRL_OtherInfo">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="FRL_Price">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="FRL_QuantityNum">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="FRL_Remark">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="FRL_SourceID">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="FRL_StatCatDR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="FRL_ToDept">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="FRL_ToLoc">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="FRL_UnitDR">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="FRL_VendorDR">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="FRL_Voucher">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Global>^DHCEQFinancialReviewList</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>FRL_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{FRL_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexAccountFlag">
<Global>^DHCEQFinancialReviewList</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>FRL_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"AccountFlag"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{FRL_FinancialReviewDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{FRL_AccountFlag}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{FRL_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexFREquipType">
<Global>^DHCEQFinancialReviewList</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>FRL_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"EquipType"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{FRL_FinancialReviewDR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{FRL_EquipTypeDR}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{FRL_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexFinancialReview">
<Global>^DHCEQFinancialReviewList</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>FRL_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"FinancialReview"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{FRL_FinancialReviewDR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{FRL_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>FRL_RowID</SqlRowIdName>
<StreamLocation>^User.DHCEQFinancialReviewListS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
