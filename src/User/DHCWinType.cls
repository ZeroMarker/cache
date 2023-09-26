Class User.DHCWinType Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = WinType_Rowid, SqlTableName = DHC_WinType, StorageStrategy = SQLStorage ]
{

/// 中标类型
Parameter EXTENTSIZE = 250;

/// WinType_Code
Property WinTypeCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = WinType_Code ];

/// WinType_Desc
Property WinTypeDesc As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = WinType_Desc ];

/// WinType_Active
Property WinTypeActive As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = WinType_Active ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCWinType)</SqlIdExpression>
<SQLMap name="DataMasterMap">
<Data name="WinType_Active">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="WinType_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="WinType_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCWinType</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>WinType_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{WinType_Rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCWinTypeS</StreamLocation>
<Type>%Storage.SQL</Type>
}

/// 编译时判断是否需要重生计数器
ClassMethod SetSqlIdExpression() [ CodeMode = objectgenerator ]
{
	s newI = +$g(^DHCWinType)
	s oldI = +$g(^mdata("DHCWinType"))
	s maxI = $s(newI > oldI : newI, 1 : oldI)
	s ^DHCWinType = maxI
	s ^mdata("DHCWinType") = maxI
}

}
