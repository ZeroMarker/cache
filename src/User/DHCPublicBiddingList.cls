Class User.DHCPublicBiddingList Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DHCPBL_Rowid, SqlTableName = DHC_PublicBiddingList, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Relationship ChildDHCPubBidItm As User.DHCPubBidItm [ Cardinality = children, Inverse = DHCPBIPBParref ];

/// DHCPB_Code
Property DHCPBLCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = DHCPBL_Code ];

/// DHCPB_Desc
Property DHCPBLDesc As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = DHCPBL_Desc ];

/// DHCPB_Tenderee
Property DHCPBLTenderee As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = DHCPBL_Tenderee ];

/// DHCPB_Date
Property DHCPBLDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 5, SqlFieldName = DHCPBL_Date ];

/// DHCPB_EfficDateFrom
Property DHCPBLEfficDateFrom As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 6, SqlFieldName = DHCPBL_EfficDateFrom ];

/// DHCPB_EfficDateTo
Property DHCPBLEfficDateTo As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 7, SqlFieldName = DHCPBL_EfficDateTo ];

/// DHCPB_Type
Property DHCPBLType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = DHCPBL_Type ];

/// DHCPB_Remark
Property DHCPBLRemark As %Library.String(COLLATION = "Exact", MAXLEN = 80, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = DHCPBL_Remark ];

/// DHCPBL_ActiveFlag
Property DHCPBLActiveFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 10, SqlFieldName = DHCPBL_ActiveFlag ];

/// DHCPBL_Level
Property DHCPBLLevel As User.DHCItmPBLevel [ SqlColumnNumber = 11, SqlFieldName = DHCPBL_Level ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCPBLIST)</SqlIdExpression>
<SQLMap name="DataMMasterPublicBidding">
<Data name="DHCPBL_ActiveFlag">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="DHCPBL_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DHCPBL_Date">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DHCPBL_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DHCPBL_EfficDateFrom">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="DHCPBL_EfficDateTo">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="DHCPBL_Level">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="DHCPBL_Remark">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="DHCPBL_Tenderee">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="DHCPBL_Type">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Global>^DHCPBLIST</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHCPBL_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{DHCPBL_Rowid}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexType">
<Global>^DHCPBLIST</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHCPBL_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"TYPE"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{DHCPBL_Type}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{DHCPBL_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCPublicBiddingListS</StreamLocation>
<Type>%Storage.SQL</Type>
}

/// 编译时判断是否需要重生计数器
ClassMethod SetSqlIdExpression() [ CodeMode = objectgenerator ]
{
	s newI = +$g(^DHCPBLIST)
	s oldI = +$g(^mdata("DHCPUBLICBIDDING"))
	s maxI = $s(newI > oldI : newI, 1 : oldI)
	s ^DHCPBLIST = maxI
	s ^mdata("DHCPUBLICBIDDING") = maxI
}

}
