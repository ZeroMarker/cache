/// BDP-caihaozhe 2015-11-12
/// Function: 地址
Class User.CTAddress Extends (%Persistent, User.Abstract) [ ClassType = persistent, Not ProcedureBlock, SqlTableName = CT_Address, StorageStrategy = SQLStorage ]
{

/// CTADD Code
Property CTADDCode As %String(COLLATION = "AlphaUp", MAXLEN = 150, TRUNCATE = 1) [ Required, SqlColumnNumber = 2, SqlFieldName = CTADD_Code ];

/// CTADD Description
Property CTADDDesc As %String(COLLATION = "AlphaUp", MAXLEN = 220, TRUNCATE = 1) [ Required, SqlColumnNumber = 3, SqlFieldName = CTADD_Desc ];

/// Des Ref Province 省
Property CTADDProvinceDR As CTProvince [ SqlColumnNumber = 4, SqlFieldName = CTADD_Province_DR ];

/// Des Ref City 市
Property CTADDCityDR As CTCity [ SqlColumnNumber = 5, SqlFieldName = CTADD_City_DR ];

/// Des Ref CityArea 区/县
Property CTADDCityAreaDR As CTCityArea [ SqlColumnNumber = 6, SqlFieldName = CTADD_CityArea_DR ];

/// Des Ref LocalityType->Street 街道
Property CTADDStreetDR As CTLocalityType [ SqlColumnNumber = 7, SqlFieldName = CTADD_Street_DR ];

/// Des Ref LocalityType->Community 社区
Property CTADDCommunityDR As User.CTCommunity [ SqlColumnNumber = 8, SqlFieldName = CTADD_Community_DR ];

/// Search code 拼音检索码
Property CTADDSearchCode As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 9, SqlFieldName = CTADD_SearchCode ];

/// Date From
Property CTADDDateFrom As %Date [ SqlColumnNumber = 10, SqlFieldName = CTADD_DateFrom ];

/// Date To
Property CTADDDateTo As %Date [ SqlColumnNumber = 11, SqlFieldName = CTADD_DateTo ];

Parameter EXTENTSIZE = 0;

Storage SQLStorage
{
<ExtentSize>0</ExtentSize>
<Property name="APCVCCoCodeDR"/>
<Property name="CTADDCoCodeDR"/>
<SqlIdExpression>$i(^CT("ADD",0))</SqlIdExpression>
<SQLMap name="DATAMasterMap">
<Data name="CTADD_CityArea_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="CTADD_City_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="CTADD_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="CTADD_Community_DR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="CTADD_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="CTADD_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="CTADD_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="CTADD_Province_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="CTADD_SearchCode">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="CTADD_Street_DR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Global>^CT</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>CTADD_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>"ADD"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{CTADD_RowId}</Expression>
<StartValue>1</StartValue>
<StopValue>999999999</StopValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCTADDCode">
<Global>^CT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>CTADD_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"ADD"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>$$ALPHAUP({CTADD_Code})</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{CTADD_RowId}</Expression>
<StartValue>1</StartValue>
<StopValue>999999999</StopValue>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexCTADDDesc">
<Global>^CT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>CTADD_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"ADD"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({CTADD_Desc})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{CTADD_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexCTADDSearchCode">
<Global>^CT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>CTADD_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"ADD"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"SearchCode"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({CTADD_SearchCode})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{CTADD_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexCityAreaDR">
<Global>^CT</Global>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>CTADD_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"ADD"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"CityArea"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{CTADD_CityArea_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{CTADD_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexCityDR">
<Global>^CT</Global>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>CTADD_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"ADD"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"City"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{CTADD_City_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{CTADD_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexComDR">
<Global>^CT</Global>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>CTADD_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"ADD"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Community"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{CTADD_Community_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{CTADD_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexProDR">
<Global>^CT</Global>
<RowIdSpec name="1">
<Field>CTADD_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"ADD"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Province"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{CTADD_Province_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{CTADD_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexStreetDR">
<Global>^CT</Global>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>CTADD_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"ADD"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Street"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{CTADD_Street_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{CTADD_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>CTADD_RowId</SqlRowIdName>
<StreamLocation>^User.CTAddressS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
