Class User.DHCEQPLATCProduct Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = P_RowID, SqlTableName = DHC_EQPLATCProduct, StorageStrategy = SQLStorage ]
{

/// P_Code
Property PCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = P_Code ];

/// P_Desc
Property PDesc As %Library.String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = P_Desc ];

/// P_AssetItemDR
Property PAssetItemDR As User.DHCEQPLATCAssetItem [ SqlColumnNumber = 4, SqlFieldName = P_AssetItemDR ];

/// P_BrandDR
Property PBrandDR As User.DHCEQCBrand [ SqlColumnNumber = 5, SqlFieldName = P_BrandDR ];

/// P_Models
Property PModels As %Library.String(COLLATION = "Exact", MAXLEN = 120, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = P_Models ];

/// P_Specs
Property PSpecs As %Library.String(COLLATION = "Exact", MAXLEN = 120, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = P_Specs ];

/// P_ManufactoryDR
Property PManufactoryDR As User.DHCEQCVendor [ SqlColumnNumber = 8, SqlFieldName = P_ManufactoryDR ];

/// P_CountryDR
Property PCountryDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = P_CountryDR ];

/// P_Area
Property PArea As %Library.String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = P_Area ];

/// P_EnglishName
Property PEnglishName As %Library.String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = P_EnglishName ];

/// P_TradeName
Property PTradeName As %Library.String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = P_TradeName ];

/// P_IntoMarketDate
Property PIntoMarketDate As %Library.Date [ SqlColumnNumber = 13, SqlFieldName = P_IntoMarketDate ];

/// P_EquipCatDR
Property PEquipCatDR As User.DHCEQCEquipeCat [ SqlColumnNumber = 14, SqlFieldName = P_EquipCatDR ];

/// P_MedicalCatDR
Property PMedicalCatDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 15, SqlFieldName = P_MedicalCatDR ];

/// P_ClassAB
Property PClassAB As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 16, SqlFieldName = P_ClassAB ];

/// P_StatCatDR
Property PStatCatDR As User.DHCEQCStatCat [ SqlColumnNumber = 17, SqlFieldName = P_StatCatDR ];

/// P_TechnologyLevel
Property PTechnologyLevel As %Library.String(COLLATION = "Exact", MAXLEN = 1, TRUNCATE = 0) [ SqlColumnNumber = 18, SqlFieldName = P_TechnologyLevel ];

/// P_WorkLoadNum
Property PWorkLoadNum As %Library.Float [ SqlColumnNumber = 19, SqlFieldName = P_WorkLoadNum ];

/// P_WorkLoadUnitDR
Property PWorkLoadUnitDR As User.DHCEQCUOM [ SqlColumnNumber = 20, SqlFieldName = P_WorkLoadUnitDR ];

/// P_CustomServiceTel
Property PCustomServiceTel As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 21, SqlFieldName = P_CustomServiceTel ];

/// P_QuotePrice
Property PQuotePrice As %Library.Float [ SqlColumnNumber = 22, SqlFieldName = P_QuotePrice ];

/// P_ReserveFlag
Property PReserveFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, VALUELIST = ",Y,N") [ SqlColumnNumber = 23, SqlFieldName = P_ReserveFlag ];

/// P_RegistrationNo
Property PRegistrationNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 24, SqlFieldName = P_RegistrationNo ];

/// P_Remark
Property PRemark As %Library.String(COLLATION = "Exact", MAXLEN = 120, TRUNCATE = 0) [ SqlColumnNumber = 25, SqlFieldName = P_Remark ];

/// P_DateFrom
Property PDateFrom As %Library.Date [ SqlColumnNumber = 26, SqlFieldName = P_DateFrom ];

/// P_DateTo
Property PDateTo As %Library.Date [ SqlColumnNumber = 27, SqlFieldName = P_DateTo ];

/// P_InvalidFlag
Property PInvalidFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 28, SqlFieldName = P_InvalidFlag ];

/// P_AllowFlag
Property PAllowFlag As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 29, SqlFieldName = P_AllowFlag ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQCTPLAT("Product",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="P_AllowFlag">
<Delimiter>"^"</Delimiter>
<Piece>28</Piece>
</Data>
<Data name="P_Area">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="P_AssetItemDR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="P_BrandDR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="P_ClassAB">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="P_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="P_CountryDR">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="P_CustomServiceTel">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="P_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="P_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="P_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="P_EnglishName">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="P_EquipCatDR">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="P_IntoMarketDate">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="P_InvalidFlag">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Data name="P_ManufactoryDR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="P_MedicalCatDR">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="P_Models">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="P_QuotePrice">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="P_RegistrationNo">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="P_Remark">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="P_ReserveFlag">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="P_Specs">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="P_StatCatDR">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="P_TechnologyLevel">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="P_TradeName">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="P_WorkLoadNum">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="P_WorkLoadUnitDR">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Global>^DHCEQCTPLAT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>P_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"Product"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{P_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexUnique">
<Global>^DHCEQCTPLAT</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>"Product"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Unique"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{P_Desc}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{P_ManufactoryDR}</Expression>
</Subscript>
<Subscript name="6">
<Expression>+{P_Models}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{P_InvalidFlag}</Expression>
</Subscript>
<Subscript name="8">
<Expression>{P_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQPLATCProductS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
