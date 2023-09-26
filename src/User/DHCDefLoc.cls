Class User.DHCDefLoc Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DLOC_ROWID, SqlTableName = DHC_DefLoc, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// DLLOC_Lead_DR
Property DLOCLeadDR As User.CTLoc [ SqlColumnNumber = 2, SqlFieldName = DLOC_Lead_DR ];

/// DLLOC_Sub_DR
Property DLOCSubDR As User.CTLoc [ SqlColumnNumber = 3, SqlFieldName = DLOC_Sub_DR ];

/// DLLOC_UseFlag
Property DLOCUseFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = DLOC_UseFlag ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCDLOC)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="DLOC_Lead_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DLOC_Sub_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DLOC_UseFlag">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCDLOC</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DLOC_ROWID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{DLOC_ROWID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexLeadLoc">
<Global>^DHCDLOC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DLOC_ROWID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"LEAD"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{DLOC_Lead_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{DLOC_ROWID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexLeadSubLoc">
<Global>^DHCDLOC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>DLOC_ROWID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"LEADSUB"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DLOC_Lead_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DLOC_Sub_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DLOC_ROWID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCDefLocS</StreamLocation>
<Type>%Storage.SQL</Type>
}

/// 编译时判断是否需要重生计数器
ClassMethod SetSqlIdExpression() [ CodeMode = objectgenerator ]
{
	s newI = +$g(^DHCDLOC)
	s oldI = +$g(^mdata("DHCDEFLOC"))
	s maxI = $s(newI > oldI : newI, 1 : oldI)
	s ^DHCDLOC = maxI
	s ^mdata("DHCDEFLOC") = maxI
}

}
