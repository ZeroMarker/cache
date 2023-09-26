/// 科室分类组
Class User.DHCLocClaGrp Extends (%Persistent, User.Abstract) [ SqlRowIdName = LCG_Rowid, SqlTableName = DHC_LocClaGrp, StorageStrategy = SQLStorage ]
{

Relationship ChildDHCLocClaGrpInci As User.DHCLocClaGrpInci [ Cardinality = children, Inverse = LCGIParref ];

Property LCGCTLOCDR As User.CTLoc [ Required, SqlColumnNumber = 2, SqlFieldName = LCG_CTLOC_DR ];

Property LCGCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = LCG_Code ];

Property LCGDesc As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = LCG_Desc ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCLCG)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="LCG_CTLOC_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="LCG_Code">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="LCG_Desc">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCLCG</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>LCG_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{LCG_Rowid}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexLoc">
<Global>^DHCLCG</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>LCG_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"LOC"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{LCG_CTLOC_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{LCG_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>LCG_Rowid</SqlRowIdName>
<StreamLocation>^User.DHCLocClaGrpS</StreamLocation>
<Type>%Storage.SQL</Type>
}

/// 编译时判断是否需要重生计数器
ClassMethod SetSqlIdExpression() [ CodeMode = objectgenerator ]
{
	s newI = +$g(^DHCLCG)
	s oldI = +$g(^mdata("DHCLOCCLAGRP"))
	s maxI = $s(newI > oldI : newI, 1 : oldI)
	s ^DHCLCG = maxI
	s ^mdata("DHCLOCCLAGRP") = maxI
}

Parameter EXTENTSIZE = 250;

}
