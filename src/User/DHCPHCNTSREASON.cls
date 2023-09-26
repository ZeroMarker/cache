Class User.DHCPHCNTSREASON Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PCR_RowID, SqlTableName = DHC_PHCNTSREASON, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// PCR_Code
Property PCRCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = PCR_Code ];

/// PCR_Desc
Property PCRDesc As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = PCR_Desc ];

/// PCR_Level
Property PCRLevel As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = PCR_Level ];

/// PCR_Way_Dr
Property PCRWayDr As User.DHCPHCNTSWAY [ SqlColumnNumber = 5, SqlFieldName = PCR_Way_Dr ];

/// 分值
Property PCRScore As %Float(MAXVAL = 999999999999, MINVAL = 0) [ SqlColumnNumber = 6, SqlFieldName = PCR_Score ];

Property PCRActiveFlag As %String(DISPLAYLIST = ",是,否", MAXLEN = 2, TRUNCATE = 1, VALUELIST = ",Y,N") [ InitialExpression = "Y", SqlColumnNumber = 7, SqlFieldName = PCR_ActiveFlag ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCPCREASON)</SqlIdExpression>
<SQLMap name="DataMasetr">
<Data name="PCR_ActiveFlag">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PCR_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PCR_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PCR_Level">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PCR_Score">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PCR_Way_Dr">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^DHCPCREASON</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PCR_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{PCR_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexLevel">
<Global>^DHCPCREASON</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>PCR_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"Level"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{PCR_Way_Dr}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{PCR_Level}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{PCR_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCPHCNTSREASONS</StreamLocation>
<Type>%Storage.SQL</Type>
}

/// 编译时判断是否需要重生计数器
ClassMethod SetSqlIdExpression() [ CodeMode = objectgenerator ]
{
	s newI = +$g(^DHCPCREASON)
	s oldI = +$g(^mdata("DHCPHCNTSREASON"))
	s maxI = $s(newI > oldI : newI, 1 : oldI)
	s ^DHCPCREASON = maxI
	s ^mdata("DHCPHCNTSREASON") = maxI
}

}
