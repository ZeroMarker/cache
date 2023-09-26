Class User.DHCEQRun Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = RUN_RowID, SqlTableName = DHC_EQRun, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// RUN_EquipDR
Property RUNEquipDR As User.DHCEQEquip [ SqlColumnNumber = 2, SqlFieldName = RUN_EquipDR ];

/// RUN_StartTime
Property RUNStartTime As %Library.Time [ SqlColumnNumber = 3, SqlFieldName = RUN_StartTime ];

/// RUN_EndTime
Property RUNEndTime As %Library.Time [ SqlColumnNumber = 4, SqlFieldName = RUN_EndTime ];

/// RUN_RunDate
Property RUNRunDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 5, SqlFieldName = RUN_RunDate ];

/// RUN_StopTime
Property RUNStopTime As %Library.Time [ SqlColumnNumber = 6, SqlFieldName = RUN_StopTime ];

/// RUN_ManageLocDR
Property RUNManageLocDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = RUN_ManageLocDR ];

/// RUN_ManageUserDR
Property RUNManageUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = RUN_ManageUserDR ];

/// RUN_UseLocDR
Property RUNUseLocDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = RUN_UseLocDR ];

/// RUN_Remark
Property RUNRemark As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = RUN_Remark ];

/// RUN_AddUserDR
Property RUNAddUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = RUN_AddUserDR ];

/// RUN_AddDate
Property RUNAddDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 12, SqlFieldName = RUN_AddDate ];

/// RUN_AddTime
Property RUNAddTime As %Library.Time [ SqlColumnNumber = 13, SqlFieldName = RUN_AddTime ];

/// RUN_UpdateUserDR
Property RUNUpdateUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = RUN_UpdateUserDR ];

/// RUN_UpdateDate
Property RUNUpdateDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 15, SqlFieldName = RUN_UpdateDate ];

/// RUN_UpdateTime
Property RUNUpdateTime As %Library.Time [ SqlColumnNumber = 16, SqlFieldName = RUN_UpdateTime ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQRun("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="RUN_AddDate">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="RUN_AddTime">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="RUN_AddUserDR">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="RUN_EndTime">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="RUN_EquipDR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="RUN_ManageLocDR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="RUN_ManageUserDR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="RUN_Remark">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="RUN_RunDate">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="RUN_StartTime">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="RUN_StopTime">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="RUN_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="RUN_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="RUN_UpdateUserDR">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="RUN_UseLocDR">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Global>^DHCEQRun</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>RUN_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{RUN_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexEquip">
<Global>^DHCEQRun</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>RUN_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Equip"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{RUN_EquipDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{RUN_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQRunS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
