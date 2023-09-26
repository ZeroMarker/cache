Class User.DHCMatDispRet Extends (%Persistent, User.Abstract) [ SqlRowIdName = Ret_RowId, SqlTableName = DHC_MatDispRet, StorageStrategy = SqlStorage ]
{

Relationship ChildDHCMatDispRetItm As User.DHCMatDispRetItm [ Cardinality = children, Inverse = RETIParRef ];

Property RETNo As %Library.String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = RET_No ];

Property RETDate As %Library.Date [ SqlColumnNumber = 3, SqlFieldName = RET_Date ];

Property RETTime As %Library.Time [ SqlColumnNumber = 4, SqlFieldName = RET_Time ];

Property RETSSUSRDR As User.SSUser [ SqlColumnNumber = 5, SqlFieldName = RET_SSUSR_DR ];

Property RETCTLOCDR As User.CTLoc [ SqlColumnNumber = 6, SqlFieldName = RET_CTLOC_DR ];

Storage SqlStorage
{
<SqlIdExpression>$i(^DHCMATDISPRET(0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="RET_CTLOC_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="RET_Date">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="RET_No">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="RET_SSUSR_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="RET_Time">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCMATDISRET</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>Ret_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{Ret_RowId}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>Ret_RowId</SqlRowIdName>
<StreamLocation>^User.DHCMatDispRetS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
