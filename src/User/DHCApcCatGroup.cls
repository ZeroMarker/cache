Class User.DHCApcCatGroup Extends (%Persistent, User.Abstract) [ SqlRowIdName = ACG_RowId, SqlTableName = DHC_ApcCatGroup, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Property ACGAPCVMDr As User.APCVendor [ SqlColumnNumber = 2, SqlFieldName = ACG_APCVM_Dr ];

Property ACGSCGDr As User.DHCStkCatGroup [ SqlColumnNumber = 3, SqlFieldName = ACG_SCG_Dr ];

Property ACGUseFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = ACG_UseFlag ];

Property ACGLocDR As User.CTLoc [ SqlColumnNumber = 5, SqlFieldName = ACG_Loc_DR ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCACG)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="ACG_APCVM_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ACG_Loc_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="ACG_SCG_Dr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="ACG_UseFlag">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCACG</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>ACG_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{ACG_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexAPCVM">
<Global>^DHCACG</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>ACG_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"APCVM"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{ACG_APCVM_Dr}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{ACG_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexLoc">
<Global>^DHCACG</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>ACG_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"Loc"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{ACG_Loc_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{ACG_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexSCG">
<Global>^DHCACG</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>ACG_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"SCG"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ACG_SCG_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ACG_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>ACG_RowId</SqlRowIdName>
<StreamLocation>^User.DHCApcCatGroupS</StreamLocation>
<Type>%Storage.SQL</Type>
}

/// 编译时判断是否需要重生计数器
ClassMethod SetSqlIdExpression() [ CodeMode = objectgenerator ]
{
	s newI = +$g(^DHCACG)
	s oldI = +$g(^mdata("DHCAPCCATGROUP"))
	s maxI = $s(newI > oldI : newI, 1 : oldI)
	s ^DHCACG = maxI
	s ^mdata("DHCAPCCATGROUP") = maxI
}

}
