Class User.DHCEQRunPlan Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = RP_RowID, SqlTableName = DHC_EQRunPlan, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// RP_EquipDR
Property RPEquipDR As User.DHCEQEquip [ SqlColumnNumber = 2, SqlFieldName = RP_EquipDR ];

/// RP_CycleNum
Property RPCycleNum As %Library.Float [ SqlColumnNumber = 3, SqlFieldName = RP_CycleNum ];

/// RP_CycleUnitDR
Property RPCycleUnitDR As User.DHCEQCCycleUnit [ SqlColumnNumber = 4, SqlFieldName = RP_CycleUnitDR ];

/// RP_StartTime
Property RPStartTime As %Library.Time [ SqlColumnNumber = 5, SqlFieldName = RP_StartTime ];

/// RP_EndTime
Property RPEndTime As %Library.Time [ SqlColumnNumber = 6, SqlFieldName = RP_EndTime ];

/// RP_StopTime
Property RPStopTime As %Library.Time [ SqlColumnNumber = 7, SqlFieldName = RP_StopTime ];

/// RP_PreRunDate
Property RPPreRunDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 8, SqlFieldName = RP_PreRunDate ];

/// RP_ManageLocDR
Property RPManageLocDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = RP_ManageLocDR ];

/// RP_ManageUserDR
Property RPManageUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = RP_ManageUserDR ];

/// RP_UseLocDR
Property RPUseLocDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = RP_UseLocDR ];

/// RP_Remark
Property RPRemark As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = RP_Remark ];

/// RP_AddUserDR
Property RPAddUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = RP_AddUserDR ];

/// RP_AddDate
Property RPAddDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 14, SqlFieldName = RP_AddDate ];

/// RP_AddTime
Property RPAddTime As %Library.Time [ SqlColumnNumber = 15, SqlFieldName = RP_AddTime ];

/// RP_UpdateUserDR
Property RPUpdateUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 16, SqlFieldName = RP_UpdateUserDR ];

/// RP_UpdateDate
Property RPUpdateDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 17, SqlFieldName = RP_UpdateDate ];

/// RP_UpdateTime
Property RPUpdateTime As %Library.Time [ SqlColumnNumber = 18, SqlFieldName = RP_UpdateTime ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQRunPlan("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="RP_AddDate">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="RP_AddTime">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="RP_AddUserDR">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="RP_CycleNum">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="RP_CycleUnitDR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="RP_EndTime">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="RP_EquipDR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="RP_ManageLocDR">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="RP_ManageUserDR">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="RP_PreRunDate">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="RP_Remark">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="RP_StartTime">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="RP_StopTime">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="RP_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="RP_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="RP_UpdateUserDR">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="RP_UseLocDR">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Global>^DHCEQRunPlan</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>RP_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{RP_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexEquip">
<Global>^DHCEQRunPlan</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>RP_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Equip"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{RP_EquipDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{RP_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQRunPlanS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
