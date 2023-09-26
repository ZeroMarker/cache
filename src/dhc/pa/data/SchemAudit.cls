Class dhc.pa.data.SchemAudit Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = SAudit_rowid, SqlTableName = SchemAudit, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

//Property SAuditSchemDr As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = SAudit_SchemDr ];

/// SAudit_SchemDr
Property SAuditSchemDr As dhc.pa.data.Schem [ SqlColumnNumber = 2, SqlFieldName = SAudit_SchemDr ];

/// SAudit_userDr
Property SAudituserDr As User.SSUser [ SqlColumnNumber = 3, SqlFieldName = SAudit_userDr ];

/// SAudit_isRead
Property SAuditisRead As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = SAudit_isRead ];

/// SAudit_isWrite
Property SAuditisWrite As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 5, SqlFieldName = SAudit_isWrite ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCCJXPASCHEMAUDIT)</SqlIdExpression>
<SQLMap name="INDEXSCHEMUSER">
<Global>^DHCCJXPASCHEMAUDIT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>SAudit_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"SchemUser"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{SAudit_SchemDr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{SAudit_userDr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{SAudit_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="Master">
<Data name="SAudit_SchemDr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="SAudit_isRead">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="SAudit_isWrite">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="SAudit_userDr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCCJXPASCHEMAUDIT</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>SAudit_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{SAudit_rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^dhc.pa.data.SchemAuditS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
