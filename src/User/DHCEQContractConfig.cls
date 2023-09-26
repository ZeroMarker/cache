Class User.DHCEQContractConfig Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = CC_RowID, SqlTableName = DHC_EQContractConfig, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// CC_ContractListDR
Property CCContractListDR As User.DHCEQContractList [ SqlColumnNumber = 2, SqlFieldName = CC_ContractListDR ];

/// CC_Type
Property CCType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = CC_Type ];

/// CC_ItemDR
Property CCItemDR As %Library.String [ SqlColumnNumber = 4, SqlFieldName = CC_ItemDR ];

/// CC_Item
Property CCItem As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = CC_Item ];

/// CC_Price
Property CCPrice As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = CC_Price ];

/// CC_QuantityNum
Property CCQuantityNum As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = CC_QuantityNum ];

/// CC_UnitDR
Property CCUnitDR As User.DHCEQCUOM [ SqlColumnNumber = 8, SqlFieldName = CC_UnitDR ];

/// CC_BrandDR
Property CCBrandDR As User.DHCEQCBrand [ SqlColumnNumber = 9, SqlFieldName = CC_BrandDR ];

/// CC_VendorDR
Property CCVendorDR As User.DHCEQCVendor [ SqlColumnNumber = 10, SqlFieldName = CC_VendorDR ];

/// CC_ManuFactoryDR
Property CCManuFactoryDR As User.DHCEQCVendor [ SqlColumnNumber = 11, SqlFieldName = CC_ManuFactoryDR ];

/// CC_Spec
Property CCSpec As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = CC_Spec ];

/// CC_Model
Property CCModel As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = CC_Model ];

/// CC_Parameters
Property CCParameters As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = CC_Parameters ];

/// CC_CountryDR
Property CCCountryDR As User.CTCountry [ SqlColumnNumber = 15, SqlFieldName = CC_CountryDR ];

/// CC_GuaranteePeriodNum
Property CCGuaranteePeriodNum As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 16, SqlFieldName = CC_GuaranteePeriodNum ];

/// CC_Remark
Property CCRemark As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 17, SqlFieldName = CC_Remark ];

/// CC_UpdateUserDR
Property CCUpdateUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 18, SqlFieldName = CC_UpdateUserDR ];

/// CC_UpdateDate
Property CCUpdateDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 19, SqlFieldName = CC_UpdateDate ];

/// CC_UpdateTime
Property CCUpdateTime As %Library.Time [ SqlColumnNumber = 20, SqlFieldName = CC_UpdateTime ];

/// CC_LeaveFacNo
Property CCLeaveFacNo As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 21, SqlFieldName = CC_LeaveFacNo ];

/// CC_LeaveDate
Property CCLeaveDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 22, SqlFieldName = CC_LeaveDate ];

/// CC_ReceiverDR
Property CCReceiverDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 23, SqlFieldName = CC_ReceiverDR ];

/// CC_RegistrationNo
Property CCRegistrationNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 24, SqlFieldName = CC_RegistrationNo ];

/// CC_InvoiceNo
Property CCInvoiceNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 25, SqlFieldName = CC_InvoiceNo ];

/// CC_GuaranteeStartDate
Property CCGuaranteeStartDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 26, SqlFieldName = CC_GuaranteeStartDate ];

/// CC_GuaranteeEndDate
Property CCGuaranteeEndDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 27, SqlFieldName = CC_GuaranteeEndDate ];

/// CC_InvalidFlag
Property CCInvalidFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 28, SqlFieldName = CC_InvalidFlag ];

/// CC_Hold1
Property CCHold1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 29, SqlFieldName = CC_Hold1 ];

/// CC_Hold2
Property CCHold2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 30, SqlFieldName = CC_Hold2 ];

/// CC_Hold3
Property CCHold3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 31, SqlFieldName = CC_Hold3 ];

/// CC_Hold4
Property CCHold4 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 32, SqlFieldName = CC_Hold4 ];

/// CC_Hold5
Property CCHold5 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 33, SqlFieldName = CC_Hold5 ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQContractConfig("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="CC_BrandDR">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="CC_ContractListDR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="CC_CountryDR">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="CC_GuaranteeEndDate">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="CC_GuaranteePeriodNum">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="CC_GuaranteeStartDate">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="CC_Hold1">
<Delimiter>"^"</Delimiter>
<Piece>28</Piece>
</Data>
<Data name="CC_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>29</Piece>
</Data>
<Data name="CC_Hold3">
<Delimiter>"^"</Delimiter>
<Piece>30</Piece>
</Data>
<Data name="CC_Hold4">
<Delimiter>"^"</Delimiter>
<Piece>31</Piece>
</Data>
<Data name="CC_Hold5">
<Delimiter>"^"</Delimiter>
<Piece>32</Piece>
</Data>
<Data name="CC_InvalidFlag">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Data name="CC_InvoiceNo">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="CC_Item">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="CC_ItemDR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="CC_LeaveDate">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="CC_LeaveFacNo">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="CC_ManuFactoryDR">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="CC_Model">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="CC_Parameters">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="CC_Price">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="CC_QuantityNum">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="CC_ReceiverDR">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="CC_RegistrationNo">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="CC_Remark">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="CC_Spec">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="CC_Type">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="CC_UnitDR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="CC_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="CC_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="CC_UpdateUserDR">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="CC_VendorDR">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Global>^DHCEQContractConfig</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>CC_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{CC_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexContractList">
<Global>^DHCEQContractConfig</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>CC_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ContractList"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{CC_ContractListDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{CC_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQContractConfigS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
