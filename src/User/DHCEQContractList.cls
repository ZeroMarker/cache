Class User.DHCEQContractList Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = CTL_RowID, SqlTableName = DHC_EQContractList, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// CTL_ContractDR
Property CTLContractDR As User.DHCEQContract [ SqlColumnNumber = 2, SqlFieldName = CTL_ContractDR ];

/// CTL_Name
Property CTLName As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = CTL_Name ];

/// CTL_ModelDR
Property CTLModelDR As User.DHCEQCModel [ SqlColumnNumber = 4, SqlFieldName = CTL_ModelDR ];

/// CTL_ManuFactoryDR
Property CTLManuFactoryDR As User.DHCEQCVendor [ SqlColumnNumber = 5, SqlFieldName = CTL_ManuFactoryDR ];

/// CTL_SourceType
Property CTLSourceType As %Library.String(COLLATION = "Exact", MAXLEN = 30, SELECTIVITY = "33.3333%", TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = CTL_SourceType ];

/// CTL_PriceFee
Property CTLPriceFee As %Library.Float [ SqlColumnNumber = 7, SqlFieldName = CTL_PriceFee ];

/// CTL_QuantityNum
Property CTLQuantityNum As %Library.Float [ SqlColumnNumber = 8, SqlFieldName = CTL_QuantityNum ];

/// CTL_TotalFee
Property CTLTotalFee As %Library.Float [ SqlColumnNumber = 9, SqlFieldName = CTL_TotalFee ];

/// CTL_Remark
Property CTLRemark As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = CTL_Remark ];

/// CTL_ContractArriveDate
Property CTLContractArriveDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 11, SqlFieldName = CTL_ContractArriveDate ];

/// CTL_ArriveDate
Property CTLArriveDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 12, SqlFieldName = CTL_ArriveDate ];

/// CTL_ArriveQuantityNum
Property CTLArriveQuantityNum As %Library.Float [ SqlColumnNumber = 13, SqlFieldName = CTL_ArriveQuantityNum ];

/// CTL_UpdateUserDR
Property CTLUpdateUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = CTL_UpdateUserDR ];

/// CTL_UpdateDate
Property CTLUpdateDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 15, SqlFieldName = CTL_UpdateDate ];

/// CTL_UpdateTime
Property CTLUpdateTime As %Library.Time [ SqlColumnNumber = 16, SqlFieldName = CTL_UpdateTime ];

/// CTL_Hold6-->CTL_GuaranteePeriodNum
Property CTLGuaranteePeriodNum As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 17, SqlFieldName = CTL_GuaranteePeriodNum ];

/// CTL_SourceID
Property CTLSourceID As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 18, SqlFieldName = CTL_SourceID ];

/// CTL_ItemDR
Property CTLItemDR As User.DHCEQCMasterItem [ SqlColumnNumber = 19, SqlFieldName = CTL_ItemDR ];

/// CTL_Hold1->CTL_BrandDR
Property CTLBrandDR As User.DHCEQCBrand [ SqlColumnNumber = 20, SqlFieldName = CTL_BrandDR ];

/// CTL_Hold2->CTL_ImportFlag
Property CTLImportFlag As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 21, SqlFieldName = CTL_ImportFlag ];

/// CTL_Hold3->CTL_GuaranteeContent
Property CTLGuaranteeContent As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 22, SqlFieldName = CTL_GuaranteeContent ];

/// CTL_Hold4->CTL_MaintCountType
Property CTLMaintCountType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 23, SqlFieldName = CTL_MaintCountType ];

/// CTL_Hold5->CTL_MaintTimes
Property CTLMaintTimes As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 24, SqlFieldName = CTL_MaintTimes ];

/// CTL_Hold1
Property CTLHold1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 25, SqlFieldName = CTL_Hold1 ];

/// CTL_Hold2
Property CTLHold2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 26, SqlFieldName = CTL_Hold2 ];

/// CTL_Hold3
Property CTLHold3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 27, SqlFieldName = CTL_Hold3 ];

/// CTL_Hold4 单位ID
Property CTLHold4 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 28, SqlFieldName = CTL_Hold4 ];

/// CTL_Hold5 规格型号
Property CTLHold5 As %Library.String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 0) [ SqlColumnNumber = 29, SqlFieldName = CTL_Hold5 ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQContractList("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="CTL_ArriveDate">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="CTL_ArriveQuantityNum">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="CTL_BrandDR">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="CTL_ContractArriveDate">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="CTL_ContractDR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="CTL_GuaranteeContent">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="CTL_GuaranteePeriodNum">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="CTL_Hold1">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="CTL_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="CTL_Hold3">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="CTL_Hold4">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Data name="CTL_Hold5">
<Delimiter>"^"</Delimiter>
<Piece>28</Piece>
</Data>
<Data name="CTL_ImportFlag">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="CTL_ItemDR">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="CTL_MaintCountType">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="CTL_MaintTimes">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="CTL_ManuFactoryDR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="CTL_ModelDR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="CTL_Name">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="CTL_PriceFee">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="CTL_QuantityNum">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="CTL_Remark">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="CTL_SourceID">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="CTL_SourceType">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="CTL_TotalFee">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="CTL_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="CTL_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="CTL_UpdateUserDR">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Global>^DHCEQContractList</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>CTL_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{CTL_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexContract">
<Global>^DHCEQContractList</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>CTL_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Contract"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{CTL_ContractDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{CTL_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexSourceID">
<Global>^DHCEQContractList</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>CTL_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"SourceID"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{CTL_SourceType}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{CTL_SourceID}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{CTL_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQContractListS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
