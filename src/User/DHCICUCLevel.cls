/// DHC_ICUC_Level
Class User.DHCICUCLevel Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = ICUCL_RowId, SqlTableName = DHC_ICUC_Level, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// ICUCL_Code
Property ICUCLCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = ICUCL_Code ];

/// ICUCL_Desc
Property ICUCLDesc As %Library.String(COLLATION = "Exact", MAXLEN = 80, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = ICUCL_Desc ];

Index ICUCLCodeUnqIdx1 On ICUCLCode [ Unique ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCICUC("Level",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="ICUCL_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ICUCL_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCICUC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>ICUCL_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"Level"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{ICUCL_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCICUCLevelS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
