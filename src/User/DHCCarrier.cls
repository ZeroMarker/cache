Class User.DHCCarrier Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = CA_Rowid, SqlTableName = DHC_Carrier, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// CA_Code
Property CACode As %Library.String(COLLATION = "Exact", MAXLEN = 120, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = CA_Code ];

/// CA_Desc
Property CADesc As %Library.String(COLLATION = "Exact", MAXLEN = 120, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = CA_Desc ];

/// CA_Type
Property CAType As %Library.String(DISPLAYLIST = ",Drug,Material,Others", MAXLEN = 8, SELECTIVITY = "25.0000%", VALUELIST = ",G,M,O") [ SqlColumnNumber = 4, SqlFieldName = CA_Type ];

/// CA_Mobile
Property CAMobile As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = CA_Mobile ];

/// 组织机构代码
Property CAOrgCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = CA_OrgCode ];

/// 组织机构代码有效期
Property CAOrgCodeDate As %Library.Date(FORMAT = 3) [ SqlColumnNumber = 7, SqlFieldName = CA_OrgCodeDate ];

/// CA_Hospital_DR
Property CAHospitalDR As User.CTHospital [ SqlColumnNumber = 8, SqlFieldName = CA_Hospital_DR ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCCARR)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="CA_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="CA_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="CA_Hospital_DR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="CA_Mobile">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="CA_OrgCode">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="CA_OrgCodeDate">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="CA_Type">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCCARR</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>CA_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{CA_Rowid}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^DHCCARR</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>CA_Rowid</Field>
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
<Expression>$$ALPHAUP({CA_Code})</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{CA_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^DHCCARR</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>CA_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>$$ALPHAUP({CA_Desc})</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{CA_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexOrgCode">
<Global>^DHCCARR</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>CA_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"OrgCode"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{CA_OrgCode}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{CA_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCCarrierS</StreamLocation>
<Type>%Storage.SQL</Type>
}

Index IndexOrgCode On CAOrgCode;

/// 编译时判断是否需要重生计数器
ClassMethod SetSqlIdExpression() [ CodeMode = objectgenerator ]
{
	s newI = +$g(^DHCCARR)
	s oldI = +$g(^mdata("DHCCARRIER"))
	s maxI = $s(newI > oldI : newI, 1 : oldI)
	s ^DHCCARR = maxI
	s ^mdata("DHCCARRIER") = maxI
}

}
