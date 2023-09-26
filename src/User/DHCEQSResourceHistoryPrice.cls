Class User.DHCEQSResourceHistoryPrice Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = RHP_RowID, SqlTableName = DHC_EQSResourceHistoryPrice, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// RHP_ResourcePriceDR
Property RHPResourcePriceDR As User.DHCEQSResourcePrice [ SqlColumnNumber = 2, SqlFieldName = RHP_ResourcePriceDR ];

/// RHP_PriceTypeDR
Property RHPPriceTypeDR As User.DHCEQSCPriceType [ SqlColumnNumber = 3, SqlFieldName = RHP_PriceTypeDR ];

/// RHP_Mode
Property RHPMode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = RHP_Mode ];

/// RHP_UomQuantity
Property RHPUomQuantity As %Library.Float [ SqlColumnNumber = 5, SqlFieldName = RHP_UomQuantity ];

/// RHP_UOMDR
Property RHPUOMDR As User.DHCEQCUOM [ SqlColumnNumber = 6, SqlFieldName = RHP_UOMDR ];

/// RHP_Price
Property RHPPrice As %Library.Float [ SqlColumnNumber = 7, SqlFieldName = RHP_Price ];

/// RHP_FromDate
Property RHPFromDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 8, SqlFieldName = RHP_FromDate ];

/// RHP_ToDate
Property RHPToDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 9, SqlFieldName = RHP_ToDate ];

/// RHP_ActiveFlag
Property RHPActiveFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 10, SqlFieldName = RHP_ActiveFlag ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQSResourceHistoryPrice("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="RHP_ActiveFlag">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="RHP_FromDate">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="RHP_Mode">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="RHP_Price">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="RHP_PriceTypeDR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="RHP_ResourcePriceDR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="RHP_ToDate">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="RHP_UOMDR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="RHP_UomQuantity">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^DHCEQSResourceHistoryPrice</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>RHP_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{RHP_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexResourcePrice">
<Global>^DHCEQSResourceHistoryPrice</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>RHP_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"ResourcePrice"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{RHP_ResourcePriceDR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{RHP_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQSResourceHistoryPriceS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
