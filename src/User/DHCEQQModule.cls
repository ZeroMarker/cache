Class User.DHCEQQModule Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = M_RowID, SqlTableName = DHC_EQQModule, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// M_Desc
Property MDesc As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = M_Desc ];

/// M_InvaildFlag
Property MInvaildFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 3, SqlFieldName = M_InvaildFlag ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQQ("DHCEQQModule",0))</SqlIdExpression>
<SQLMap name="DataMmaster">
<Data name="M_Desc">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="M_InvaildFlag">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCEQQ</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>M_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"DHCEQQModule"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{M_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCEQQModuleS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
