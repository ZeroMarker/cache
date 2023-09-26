Class User.DHCRBCTimePtSet Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DHCRBC_TimePtSet, SqlTableName = DHCRBC_TimePtSet, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// DTS_Code
Property DTSCode As %Library.String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = DTS_Code ];

/// DTS_Desc
Property DTSDesc As %Library.String(COLLATION = "Exact", MAXLEN = 20, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = DTS_Desc ];

/// DTS_Time
Property DTSTime As %Library.Time [ SqlColumnNumber = 4, SqlFieldName = DTS_Time ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCRBCTimePtSeti)</SqlIdExpression>
<SQLMap name="MasterMap">
<Data name="DTS_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DTS_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DTS_Time">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCRBCTimePtSeti</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHCRBC_TimePtSet</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{DHCRBC_TimePtSet}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCRBCTimePtSetS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
