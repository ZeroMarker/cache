Class User.PMPDepartAudit Extends %Persistent [ ClassType = persistent, Not ProcedureBlock, SqlTableName = PMP_DepartAudit, StorageStrategy = SQLStorage ]
{

/// Audit_LocDr
/// 审核科室
Property AuditLocDr As CTLoc [ SqlColumnNumber = 2, SqlFieldName = Audit_LocDr ];

/// Audit_UserDr
/// 审核人
Property AuditUserDr As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = Audit_UserDr ];

/// Audit_Effect
/// 有效Y,无效N
Property AuditEffect As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = Audit_Effect ];

/// Audit_Spare
/// 备用
Property AuditSpare As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = Audit_Spare ];

/// Audit_Spare1
Property AuditSpare1 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = Audit_Spare1 ];

/// Audit_Spare2
Property AuditSpare2 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = Audit_Spare2 ];

/// Audit_Spare3
Property AuditSpare3 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = Audit_Spare3 ];

/// Audit_Spare4
Property AuditSpare4 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = Audit_Spare4 ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^DepartAudit("0"))</SqlIdExpression>
<SQLMap name="DateMasterMap">
<Data name="Audit_Effect">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="Audit_LocDr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="Audit_Spare">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="Audit_Spare1">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="Audit_Spare2">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="Audit_Spare3">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="Audit_Spare4">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="Audit_UserDr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DepartAudit</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>Audit_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{Audit_Rowid}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="INDEXDepart">
<Global>^DepartAuditloc</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>Audit_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"Departloc"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{Audit_LocDr}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{Audit_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="INDEXUser">
<Global>^DepartAuditUser</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>Audit_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"DepartUser"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{Audit_UserDr}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{Audit_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>Audit_Rowid</SqlRowIdName>
<StreamLocation>^User.PMPDepartAuditS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
