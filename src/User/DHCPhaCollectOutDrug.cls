Class User.DHCPhaCollectOutDrug Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PCOD_Rowid, SqlTableName = DHC_PhaCollectOutDrug, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Relationship ChildDHCPhaCollectOutDrugDet As User.DHCPhaCollectOutDrugDet [ Cardinality = children, Inverse = PCODLPCODParref ];

/// PCOD_Ward_Dr
Property PCODWardDr As User.PACWard [ SqlColumnNumber = 2, SqlFieldName = PCOD_Ward_Dr ];

/// PCOD_Adm_DR
Property PCODAdmDR As User.PAAdm [ SqlColumnNumber = 3, SqlFieldName = PCOD_Adm_DR ];

/// PCOD_Date
Property PCODDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 4, SqlFieldName = PCOD_Date ];

/// PCOD_Time
Property PCODTime As %Library.Time [ SqlColumnNumber = 5, SqlFieldName = PCOD_Time ];

/// PCOD_SSUSR_DR
Property PCODSSUSRDR As User.SSUser [ SqlColumnNumber = 6, SqlFieldName = PCOD_SSUSR_DR ];

/// PCOD_PhaLoc_DR
Property PCODPhaLocDR As User.CTLoc [ SqlColumnNumber = 7, SqlFieldName = PCOD_PhaLoc_DR ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCPCOD)</SqlIdExpression>
<SQLMap name="DataMasterPCOD">
<Data name="PCOD_Adm_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PCOD_Date">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PCOD_PhaLoc_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PCOD_SSUSR_DR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PCOD_Time">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PCOD_Ward_Dr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCPCOD</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PCOD_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{PCOD_Rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexLocAdm">
<Global>^DHCPCOD</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>PCOD_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"ADM"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{PCOD_PhaLoc_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{PCOD_Adm_DR}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{PCOD_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexWarddate">
<Global>^DHCPCOD</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>PCOD_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"LOCDATE"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{PCOD_PhaLoc_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{PCOD_Date}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{PCOD_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCPhaCollectOutDrugS</StreamLocation>
<Type>%Storage.SQL</Type>
}

/// 编译时判断是否需要重生计数器
ClassMethod SetSqlIdExpression() [ CodeMode = objectgenerator ]
{
	s newI = +$g(^DHCPCOD)
	s oldI = +$g(^mdata("DHCPHACOLLECTOUTDRUG"))
	s maxI = $s(newI > oldI : newI, 1 : oldI)
	s ^DHCPCOD = maxI
	s ^mdata("DHCPHACOLLECTOUTDRUG") = maxI
}

}
