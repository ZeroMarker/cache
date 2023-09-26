Class User.DHCEQQFunction Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = F_RowID, SqlTableName = DHC_EQQFunction, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// F_Desc
Property FDesc As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = F_Desc ];

/// F_InvaildFlag
Property FInvaildFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 3, SqlFieldName = F_InvaildFlag ];

/// F_ModuleDR
Property FModuleDR As User.DHCEQQModule [ SqlColumnNumber = 4, SqlFieldName = F_ModuleDR ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQQ("DHCEQQFunction",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="F_Desc">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="F_InvaildFlag">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="F_ModuleDR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCEQQ</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>F_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"DHCEQQFunction"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{F_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCEQQFunctionS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
