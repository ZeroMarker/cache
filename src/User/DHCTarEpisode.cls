/// Standard Price for Episode Type
Class User.DHCTarEpisode Extends (%Library.Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = TEP_RowId, SqlTableName = DHC_TarEpisode, StorageStrategy = SQLStorage ]
{

/// Episode SubCategory
Property TEPESTDR As User.PACEpisodeSubType [ SqlColumnNumber = 2, SqlFieldName = TEP_EST_DR ];

/// Standard Price of DHC_TarItem
Property TEPPriceList As %Library.String(DISPLAYLIST = ",Price,AlterPrice1,AlterPrice2", MAXLEN = 11, SELECTIVITY = "25.0000%", VALUELIST = ",P0,P1,P2") [ SqlColumnNumber = 3, SqlFieldName = TEP_PriceList ];

/// Start Date
Property TEPStartDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 4, SqlFieldName = TEP_StartDate ];

/// End Date
Property TEPEndDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 5, SqlFieldName = TEP_EndDate ];

/// TEP_Hosp_DR
Property TEPHospDR As User.CTHospital [ SqlColumnNumber = 6, SqlFieldName = TEP_Hosp_DR ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^DHCTAREP)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="TEP_EST_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="TEP_EndDate">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="TEP_Hosp_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="TEP_PriceList">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="TEP_StartDate">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCTAREP</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>TEP_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{TEP_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexEP">
<Global>^DHCTAREP</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>TEP_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"EP"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{TEP_EST_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{TEP_StartDate}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{TEP_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexEPHosp">
<Global>^DHCTAREP</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>TEP_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"EPHOSP"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{TEP_EST_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{TEP_Hosp_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{TEP_StartDate}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{TEP_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCTarEpisodeS</StreamLocation>
<Type>%Storage.SQL</Type>
}

Parameter EXTENTSIZE = 250;

}
