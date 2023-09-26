Class User.DHCHHImport Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DHI_RowID, SqlTableName = DHC_HHImport, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Relationship ChildDHCHHYTImportItm As User.DHCHHYTImportItm [ Cardinality = children, Inverse = DHIIParref ];

/// import date
Property DHIDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 2, SqlFieldName = DHI_Date ];

/// import filename
Property DHIfile As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = DHI_file ];

/// import user
Property DHIUserDR As User.SSUser [ SqlColumnNumber = 4, SqlFieldName = DHI_User_DR ];

/// complete flag
Property DHIflag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 5, SqlFieldName = DHI_flag ];

/// 供应商ID
Property DHIVendDR As User.APCVendor [ Required, SqlColumnNumber = 6, SqlFieldName = DHI_Vend_DR ];

/// 请求科室ID
Property DHIReqLocDR As User.CTLoc [ Required, SqlColumnNumber = 7, SqlFieldName = DHI_ReqLoc_DR ];

/// 入库科室ID
Property DHIRecLocDR As User.CTLoc [ SqlColumnNumber = 8, SqlFieldName = DHI_RecLoc_DR ];

/// 采购订单ID
Property DHIPoDr As User.INPO [ SqlColumnNumber = 9, SqlFieldName = DHI_Po_Dr ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCHI)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="DHI_Date">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DHI_Po_Dr">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="DHI_RecLoc_DR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="DHI_ReqLoc_DR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="DHI_User_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DHI_Vend_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="DHI_file">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DHI_flag">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^DHCHI</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHI_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{DHI_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexDate">
<Global>^DHCHI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHI_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"Date"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{DHI_Date}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{DHI_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexFile">
<Global>^DHCHI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>DHI_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"File"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DHI_file}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DHI_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCHHImportS</StreamLocation>
<Type>%Storage.SQL</Type>
}

/// 编译时判断是否需要重生计数器
ClassMethod SetSqlIdExpression() [ CodeMode = objectgenerator ]
{
	s newI = +$g(^DHCHI)
	s oldI = +$g(^mdata("DHCHHIMPORT"))
	s maxI = $s(newI > oldI : newI, 1 : oldI)
	s ^DHCHI = maxI
	s ^mdata("DHCHHIMPORT") = maxI
}

}
