Class User.DHCFactCpatconstract Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = FatCP_Rowid, SqlTableName = DHC_FactC_patconstract, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// PatCP_Card1
Property FatCPCard1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = FatCP_Card1 ];

/// PatCP_Card2
Property FatCPCard2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = FatCP_Card2 ];

/// PatCP_Card3
Property FatCPCard3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = FatCP_Card3 ];

/// FatCP_CityNo
Property FatCPCityNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = FatCP_CityNo ];

/// FatCP_FactNO
Property FatCPFactNO As %Library.String(COLLATION = "Exact", MAXLEN = 20, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = FatCP_FactNO ];

/// FatCP_PAPAI_DR
Property FatCPPAPMIDR As User.PAPatMas [ SqlColumnNumber = 2, SqlFieldName = FatCP_PAPMI_DR ];

/// FatCP_PCSCardNo
Property FatCPPCSCardNo As %Library.String(COLLATION = "Exact", MAXLEN = 20, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = FatCP_PCSCardNo ];

/// FatCP_PatNo
Property FatCPPatNo As %Library.String(COLLATION = "Exact", MAXLEN = 20, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = FatCP_PatNo ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCFactPat)</SqlIdExpression>
<SQLMap name="IndexFactNO">
<Global>^DHCFactPat</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>FatCP_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"FactNO"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{FatCP_FactNO}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{FatCP_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPAPMIDR">
<Global>^DHCFactPat</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>FatCP_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"PATMAS"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{FatCP_PAPMI_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{FatCP_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPCSCardNo">
<Global>^DHCFactPat</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>FatCP_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"PCSCardNo"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{FatCP_PCSCardNo}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{FatCP_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPatNo">
<Global>^DHCFactPat</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>FatCP_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"PatNo"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{FatCP_PatNo}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{FatCP_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="factpat">
<Data name="FatCP_Card1">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="FatCP_Card2">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="FatCP_Card3">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="FatCP_CityNo">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="FatCP_FactNO">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="FatCP_PAPMI_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="FatCP_PCSCardNo">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="FatCP_PatNo">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCFactPat</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>FatCP_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{FatCP_Rowid}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCFactCpatconstractS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
