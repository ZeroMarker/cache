Class User.DHCEQMoveOut Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = MO_RowID, SqlTableName = DHC_EQMoveOut, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// MO_EquipDR
Property MOEquipDR As User.DHCEQEquip [ SqlColumnNumber = 2, SqlFieldName = MO_EquipDR ];

/// MO_GroupDR
Property MOGroupDR As User.DHCEQGroup [ SqlColumnNumber = 3, SqlFieldName = MO_GroupDR ];

/// MO_FromLoc
Property MOFromLoc As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = MO_FromLoc ];

/// MO_ToDeptDR
Property MOToDeptDR As User.DHCEQCFromToDept [ SqlColumnNumber = 5, SqlFieldName = MO_ToDeptDR ];

/// MO_OutFee
Property MOOutFee As %Library.Float [ SqlColumnNumber = 6, SqlFieldName = MO_OutFee ];

/// MO_PayModeDR
Property MOPayModeDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = MO_PayModeDR ];

/// MO_ChangeReason
Property MOChangeReason As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = MO_ChangeReason ];

/// MO_ChangeDate
Property MOChangeDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 9, SqlFieldName = MO_ChangeDate ];

/// MO_Remark
Property MORemark As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = MO_Remark ];

/// MO_Status
Property MOStatus As %Library.String(DISPLAYLIST = ",新增,提交,审核,作废", MAXLEN = 2, SELECTIVITY = "20.0000%", TRUNCATE = 1, VALUELIST = ",0,1,2,3") [ SqlColumnNumber = 11, SqlFieldName = MO_Status ];

/// MO_AddUserDR
Property MOAddUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = MO_AddUserDR ];

/// MO_AddDate
Property MOAddDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 13, SqlFieldName = MO_AddDate ];

/// MO_AddTime
Property MOAddTime As %Library.Time [ SqlColumnNumber = 14, SqlFieldName = MO_AddTime ];

/// MO_UpdateUserDR
Property MOUpdateUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 15, SqlFieldName = MO_UpdateUserDR ];

/// MO_UpdateDate
Property MOUpdateDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 16, SqlFieldName = MO_UpdateDate ];

/// MO_UpdateTime
Property MOUpdateTime As %Library.Time [ SqlColumnNumber = 17, SqlFieldName = MO_UpdateTime ];

/// MO_AuditUserDR
Property MOAuditUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 18, SqlFieldName = MO_AuditUserDR ];

/// MO_AuditDate
Property MOAuditDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 19, SqlFieldName = MO_AuditDate ];

/// MO_AuditTime
Property MOAuditTime As %Library.Time [ SqlColumnNumber = 20, SqlFieldName = MO_AuditTime ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQMoveOut("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="MO_AddDate">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="MO_AddTime">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="MO_AddUserDR">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="MO_AuditDate">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="MO_AuditTime">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="MO_AuditUserDR">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="MO_ChangeDate">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="MO_ChangeReason">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="MO_EquipDR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="MO_FromLoc">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="MO_GroupDR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="MO_OutFee">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="MO_PayModeDR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="MO_Remark">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="MO_Status">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="MO_ToDeptDR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="MO_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="MO_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="MO_UpdateUserDR">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Global>^DHCEQMoveOut</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>MO_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{MO_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexEquip">
<Global>^DHCEQMoveOut</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>MO_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Equip"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{MO_EquipDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{MO_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQMoveOutS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
