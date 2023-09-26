Class User.DHCEQDocMove Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DM_RowID, SqlTableName = DHC_EQDocMove, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// DM_EquipDR
Property DMEquipDR As User.DHCEQEquip [ SqlColumnNumber = 2, SqlFieldName = DM_EquipDR ];

/// DM_HanderDR
Property DMHanderDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = DM_HanderDR ];

/// DM_HanderLocDR
Property DMHanderLocDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = DM_HanderLocDR ];

/// DM_Receiver
Property DMReceiver As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = DM_Receiver ];

/// DM_ReceiveLocDR
Property DMReceiveLocDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = DM_ReceiveLocDR ];

/// DM_HandOverDate
Property DMHandOverDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 7, SqlFieldName = DM_HandOverDate ];

/// DM_Status
Property DMStatus As %Library.String(DISPLAYLIST = ",新增,提交,审核", MAXLEN = 2, SELECTIVITY = "25.0000%", TRUNCATE = 1, VALUELIST = ",0,1,2") [ SqlColumnNumber = 8, SqlFieldName = DM_Status ];

/// DM_Remark
Property DMRemark As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = DM_Remark ];

/// DM_AddUserDR
Property DMAddUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = DM_AddUserDR ];

/// DM_AddDate
Property DMAddDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 11, SqlFieldName = DM_AddDate ];

/// DM_AddTime
Property DMAddTime As %Library.Time [ SqlColumnNumber = 12, SqlFieldName = DM_AddTime ];

/// DM_UpdateUserDR
Property DMUpdateUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = DM_UpdateUserDR ];

/// DM_UpdateDate
Property DMUpdateDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 14, SqlFieldName = DM_UpdateDate ];

/// DM_UpdateTime
Property DMUpdateTime As %Library.Time [ SqlColumnNumber = 15, SqlFieldName = DM_UpdateTime ];

/// DM_AuditUserDR
Property DMAuditUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 16, SqlFieldName = DM_AuditUserDR ];

/// DM_AuditDate
Property DMAuditDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 17, SqlFieldName = DM_AuditDate ];

/// DM_AuditTime
Property DMAuditTime As %Library.Time [ SqlColumnNumber = 18, SqlFieldName = DM_AuditTime ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQDocMove("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="DM_AddDate">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="DM_AddTime">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="DM_AddUserDR">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="DM_AuditDate">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="DM_AuditTime">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="DM_AuditUserDR">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="DM_EquipDR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DM_HandOverDate">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="DM_HanderDR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DM_HanderLocDR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DM_ReceiveLocDR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="DM_Receiver">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="DM_Remark">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="DM_Status">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="DM_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="DM_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="DM_UpdateUserDR">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Global>^DHCEQDocMove</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DM_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{DM_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCEQDocMoveS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
