Class User.DHCPHFunLibrary Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PHFL_RowID, SqlTableName = DHC_PHFunLibrary, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// PHFL_Code
Property PHFLCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = PHFL_Code ];

/// PHFL_Desc
Property PHFLDesc As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = PHFL_Desc ];

/// PHFL_Funtions
Property PHFLFuntions As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = PHFL_Funtions ];

/// PHFL_Retrun
Property PHFLRetrun As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = PHFL_Retrun ];

/// PHFL_Remark
Property PHFLRemark As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = PHFL_Remark ];

/// PHFL_ActiveFlag
Property PHFLActiveFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 7, SqlFieldName = PHFL_ActiveFlag ];

/// PHFL_ParentId
Property PHFLParentId As %Library.Float [ SqlColumnNumber = 8, SqlFieldName = PHFL_ParentId ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCPHFULIB)</SqlIdExpression>
<SQLMap name="DataIndex">
<Global>^DHCPHFULIB</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PHFL_RowID</Field>
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
<Expression>{PHFL_Code}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{PHFL_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="DataMaster">
<Data name="PHFL_ActiveFlag">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PHFL_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PHFL_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PHFL_Funtions">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PHFL_ParentId">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="PHFL_Remark">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PHFL_Retrun">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^DHCPHFULIB</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PHFL_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{PHFL_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCPHFunLibraryS</StreamLocation>
<Type>%Storage.SQL</Type>
}

/// 编译时判断是否需要重生计数器
ClassMethod SetSqlIdExpression() [ CodeMode = objectgenerator ]
{
	s newI = +$g(^DHCPHFULIB)
	s oldI = +$g(^mdata("DHCPHFUNLIBRARY"))
	s maxI = $s(newI > oldI : newI, 1 : oldI)
	s ^DHCPHFULIB = maxI
	s ^mdata("DHCPHFUNLIBRARY") = maxI
}

}
