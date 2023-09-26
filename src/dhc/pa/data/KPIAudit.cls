/// KPIAudit
Class dhc.pa.data.KPIAudit Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = KPIAudit_rowid, SqlTableName = KPIAudit, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// KPIAudit_KPIDr
Property KPIAuditKPIDr As dhc.pa.data.KPIIndex1 [ SqlColumnNumber = 2, SqlFieldName = KPIAudit_KPIDr ];

/// KPIAudit_userDr
Property KPIAudituserDr As User.SSUser [ SqlColumnNumber = 3, SqlFieldName = KPIAudit_userDr ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCCJXPAKPIAUDIT(0))</SqlIdExpression>
<SQLMap name="DataMast">
<Data name="KPIAudit_KPIDr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="KPIAudit_userDr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCCJXPAKPIAUDIT</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>KPIAudit_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{KPIAudit_rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexUser">
<Global>^DHCCJXPAKPIAUDIT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>KPIAudit_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"User"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{KPIAudit_userDr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{KPIAudit_KPIDr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{KPIAudit_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^dhc.pa.data.KPIAuditS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
