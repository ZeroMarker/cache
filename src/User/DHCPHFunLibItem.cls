Class User.DHCPHFunLibItem Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PHFLI_RowID, SqlTableName = DHC_PHFunLibItem, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Relationship ChildDHCPHFUNLIBITMART As User.DHCPHFunLibItmArt [ Cardinality = children, Inverse = PHPHFLIParref ];

/// PHFLI_Code
Property PHFLICode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = PHFLI_Code ];

/// PHFLI_Desc
Property PHFLIDesc As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = PHFLI_Desc ];

/// PHFLI_Funtions
Property PHFLIFuntions As User.DHCPHFunLibrary [ SqlColumnNumber = 4, SqlFieldName = PHFLI_Funtions ];

/// PHFLI_Remark
Property PHFLIRemark As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = PHFLI_Remark ];

/// PHFLI_ActiveFlag
Property PHFLIActiveFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 6, SqlFieldName = PHFLI_ActiveFlag ];

/// PHFLI_Arguments
Property PHFLIArguments As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = PHFLI_Arguments ];

/// PHFLI_ThemeItm_Dr
Property PHFLIThemeItmDr As User.DHCPHFunTheItem [ SqlColumnNumber = 8, SqlFieldName = PHFLI_ThemeItm_Dr ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCPHFULITM)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="PHFLI_ActiveFlag">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PHFLI_Arguments">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PHFLI_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PHFLI_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PHFLI_Funtions">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PHFLI_Remark">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PHFLI_ThemeItm_Dr">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Global>^DHCPHFULITM</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PHFLI_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{PHFLI_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^DHCPHFULITM</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PHFLI_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{PHFLI_Code}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{PHFLI_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexTheme">
<Global>^DHCPHFULITM</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PHFLI_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"Theme"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{PHFLI_ThemeItm_Dr}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{PHFLI_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCPHFunLibItemS</StreamLocation>
<Type>%Storage.SQL</Type>
}

/// 编译时判断是否需要重生计数器
ClassMethod SetSqlIdExpression() [ CodeMode = objectgenerator ]
{
	s newI = +$g(^DHCPHFULITM)
	s oldI = +$g(^mdata("DHCPHFUNLIBITEM"))
	s maxI = $s(newI > oldI : newI, 1 : oldI)
	s ^DHCPHFULITM = maxI
	s ^mdata("DHCPHFUNLIBITEM") = maxI
}

}
