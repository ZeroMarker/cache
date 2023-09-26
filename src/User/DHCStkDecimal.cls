Class User.DHCStkDecimal Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = SD_RowID, SqlTableName = DHC_StkDecimal, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Relationship ChildDHCStkDecimalItm As User.DHCStkDecimalItm [ Cardinality = children, Inverse = SDISDParref ];

/// SD_Name
Property SDName As %Library.String(COLLATION = "AlphaUp", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = SD_Name ];

/// SD_Desc
Property SDDesc As %Library.String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = SD_Desc ];

/// SD_UseFlag
Property SDUseFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = SD_UseFlag ];

/// SD_Type
Property SDType As %Library.String(DISPLAYLIST = ",Drug,Material,Others", MAXLEN = 8, SELECTIVITY = "25.0000%", VALUELIST = ",G,M,O") [ SqlColumnNumber = 5, SqlFieldName = SD_Type ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCSD)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="SD_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="SD_Name">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="SD_Type">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="SD_UseFlag">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCSD</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>SD_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{SD_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexName">
<Global>^DHCSD</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>SD_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"NAME"</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$ALPHAUP({SD_Name})</Expression>
</Subscript>
<Subscript name="4">
<Expression>{SD_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexUseFlag">
<Global>^DHCSD</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>SD_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"USEFLAG"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{SD_UseFlag}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{SD_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCStkDecimalS</StreamLocation>
<Type>%Storage.SQL</Type>
}

/// 编译时判断是否需要重生计数器
ClassMethod SetSqlIdExpression() [ CodeMode = objectgenerator ]
{
	s newI = +$g(^DHCSD)
	s oldI = +$g(^mdata("DHCSTKDECIMAL"))
	s maxI = $s(newI > oldI : newI, 1 : oldI)
	s ^DHCSD = maxI
	s ^mdata("DHCSTKDECIMAL") = maxI
}

}
