Class User.DHCLocItemGrp Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = LIG_RowID, SqlTableName = DHC_LocItemGrp, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// LIG_Code
Property LIGCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = LIG_Code ];

/// LIG_Desc
Property LIGDesc As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = LIG_Desc ];

/// LIG_Flag
Property LIGFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = LIG_Flag ];

/// LIG_ReMark
Property LIGReMark As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = LIG_ReMark ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCLIG)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="LIG_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="LIG_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="LIG_Flag">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="LIG_ReMark">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^DHCLIG</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>LIG_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{LIG_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCLocItemGrpS</StreamLocation>
<Type>%Storage.SQL</Type>
}

/// 编译时判断是否需要重生计数器
ClassMethod SetSqlIdExpression() [ CodeMode = objectgenerator ]
{
	s newI = +$g(^DHCLIG)
	s oldI = +$g(^mdata("DHCLOCITEMGRP"))
	s maxI = $s(newI > oldI : newI, 1 : oldI)
	s ^DHCLIG = maxI
	s ^mdata("DHCLOCITEMGRP") = maxI
}

}
