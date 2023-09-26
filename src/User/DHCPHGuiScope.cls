Class User.DHCPHGuiScope Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, SqlRowIdName = PHGS_RowId, SqlTableName = DHC_PHGuiScope, StorageStrategy = SQLStorage ]
{

/// 分类代码  PHGS_Code
Property PHGSCode As %Text(MAXLEN = 30) [ SqlColumnNumber = 2, SqlFieldName = PHGS_Code ];

/// 分类描述  PHGS_Desc
Property PHGSDesc As %Text(MAXLEN = 300) [ SqlColumnNumber = 3, SqlFieldName = PHGS_Desc ];

/// 分类描述  PHGS_ModType
Property PHGSModType As %String(DISPLAYLIST = ",EDU,WAR,CLI", SELECTIVITY = "33.3333%", VALUELIST = ",EDU,WAR,CLI") [ SqlColumnNumber = 4, SqlFieldName = PHGS_ModType ];

/// 分类描述  PHGS_SubModType
Property PHGSSubModType As %String(DISPLAYLIST = ",N,I,O", SELECTIVITY = "33.3333%", VALUELIST = ",N,I,O") [ SqlColumnNumber = 5, SqlFieldName = PHGS_SubModType ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCPHGS)</SqlIdExpression>
<SQLMap name="CodeIndex">
<Global>^DHCPHGS</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PHGS_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PHGS_Code}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PHGS_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="DataMaster">
<Data name="PHGS_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PHGS_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PHGS_ModType">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PHGS_SubModType">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^DHCPHGS</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PHGS_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{PHGS_RowId}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="Index">
<Global>^DHCPHGS</Global>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>PHGS_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ModType"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PHGS_ModType}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PHGS_SubModType}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PHGS_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCPHGuiScopeS</StreamLocation>
<Type>%Storage.SQL</Type>
}

/// 编译时判断是否需要重生计数器
ClassMethod SetSqlIdExpression() [ CodeMode = objectgenerator ]
{
	s newI = +$g(^DHCPHGS)
	s oldI = +$g(^mdata("^DHCPHGS"))
	s maxI = $s(newI > oldI : newI, 1 : oldI)
	s ^DHCPHGS = maxI
	s ^mdata("^DHCPHGS") = maxI
}

}
