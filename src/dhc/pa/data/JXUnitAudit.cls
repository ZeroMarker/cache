/// JXUnitAudit
Class dhc.pa.data.JXUnitAudit Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = JXUnitAudit_rowid, SqlTableName = JXUnitAudit, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// JXUnitAudit_jxUnitDr
Property JXUnitAuditjxUnitDr As %Library.Float [ SqlColumnNumber = 2, SqlFieldName = JXUnitAudit_jxUnitDr ];

/// JXUnitAudit_userDr
Property JXUnitAudituserDr As %Library.Float [ SqlColumnNumber = 3, SqlFieldName = JXUnitAudit_userDr ];

/// JXUnitAudit_isRead
Property JXUnitAuditisRead As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = JXUnitAudit_isRead ];

/// JXUnitAudit_isWrite
Property JXUnitAuditisWrite As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 5, SqlFieldName = JXUnitAudit_isWrite ];

/// JXUnitAudit_isUpdate
Property JXUnitAuditisUpdate As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 6, SqlFieldName = JXUnitAudit_isUpdate ];

/// JXUnitAudit_isDel
Property JXUnitAuditisDel As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 7, SqlFieldName = JXUnitAudit_isDel ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCCJXPAJXUNITAUDIT(0))</SqlIdExpression>
<SQLMap name="DataMast">
<Data name="JXUnitAudit_isDel">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="JXUnitAudit_isRead">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="JXUnitAudit_isUpdate">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="JXUnitAudit_isWrite">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="JXUnitAudit_jxUnitDr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="JXUnitAudit_userDr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCCJXPAJXUNITAUDIT</Global>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{JXUnitAudit_rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexJXUnit">
<Global>^DHCCJXPAJXUNITAUDIT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>JXUnitAudit_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"JXUnit"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{JXUnitAudit_jxUnitDr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{JXUnitAudit_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexJXUnitUser">
<Global>^DHCCJXPAJXUNITAUDIT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>JXUnitAudit_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"JXUnitUser"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{JXUnitAudit_jxUnitDr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{JXUnitAudit_userDr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{JXUnitAudit_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexUser">
<Global>^DHCCJXPAJXUNITAUDIT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>JXUnitAudit_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"User"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{JXUnitAudit_userDr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{JXUnitAudit_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^dhc.pa.data.JXUnitAuditS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
