Class User.DHCEventLog Extends %Persistent [ SqlRowIdName = Log_RowId, SqlTableName = DHC_EventLog, StorageStrategy = NewStorage1 ]
{

Relationship ChildDHCEventLogDet As User.DHCEventLogDetails [ Cardinality = children, Inverse = DetLogParRef ];

Property LogTimes As %Numeric [ SqlFieldName = Log_Times ];

Property LogModelDr As User.DHCEventModel [ SqlFieldName = Log_Model_Dr ];

Property LogUserDr As User.SSUser [ SqlFieldName = Log_User_Dr ];

/// 操作成功与否, 如登录成功
Property LogSuccess As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ InitialExpression = "N", SqlFieldName = Log_Success ];

Property LogAuditDr As User.DHCEventLogAudit [ SqlFieldName = Log_Audit_Dr ];

/// 是否审计标志
Property LogAuditFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ InitialExpression = "N", SqlFieldName = Log_AuditFlag ];

Property LogStDate As %Date [ SqlFieldName = Log_StDate ];

Property LogStTime As %Time [ SqlFieldName = Log_StTime ];

Property LogEndDate As %Date [ SqlFieldName = Log_EndDate ];

Property LogEndTime As %Time [ SqlFieldName = Log_EndTime ];

Index AuditDR On LogAuditDr;

Storage NewStorage1
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^DHCEVENTLOG)</SqlIdExpression>
<SQLMap name="AuditDRIndex">
<Global>^DHCEVENTLOGI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>Log_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"AuditDR"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{Log_Audit_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{Log_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="DataMap">
<Data name="Log_AuditFlag">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="Log_Audit_Dr">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="Log_EndDate">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="Log_EndTime">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="Log_Model_Dr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="Log_StDate">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="Log_StTime">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="Log_Success">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="Log_Times">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="Log_User_Dr">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCEVENTLOG</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>Log_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{Log_RowId}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="DateAuditTimes">
<Global>^DHCEVENTLOGI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>Log_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"StDate"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{Log_StDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"AuditFlag"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{Log_AuditFlag}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{Log_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="UserLogin">
<Global>^DHCEVENTLOGI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>Log_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"UserLogin"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{Log_User_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"Model"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{Log_Model_Dr}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{Log_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEventLogS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
