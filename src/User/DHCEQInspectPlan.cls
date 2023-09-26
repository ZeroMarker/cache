Class User.DHCEQInspectPlan Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = IP_RowID, SqlTableName = DHC_EQInspectPlan, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// IP_Name
Property IPName As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = IP_Name ];

/// IP_EquipDR
Property IPEquipDR As User.DHCEQEquip [ SqlColumnNumber = 3, SqlFieldName = IP_EquipDR ];

/// IP_CycleNum
Property IPCycleNum As %Library.Float [ SqlColumnNumber = 4, SqlFieldName = IP_CycleNum ];

/// IP_CycleUnitDR
Property IPCycleUnitDR As User.DHCEQCCycleUnit [ SqlColumnNumber = 5, SqlFieldName = IP_CycleUnitDR ];

/// IP_InspectTypeDR
Property IPInspectTypeDR As User.DHCEQCInspectType [ SqlColumnNumber = 6, SqlFieldName = IP_InspectTypeDR ];

/// IP_PreInspectDate
Property IPPreInspectDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 7, SqlFieldName = IP_PreInspectDate ];

/// IP_NextMaintDate
Property IPNextMaintDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 8, SqlFieldName = IP_NextMaintDate ];

/// IP_PreWarnDaysNum
Property IPPreWarnDaysNum As %Library.Float [ SqlColumnNumber = 9, SqlFieldName = IP_PreWarnDaysNum ];

/// IP_ManageLocDR
Property IPManageLocDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = IP_ManageLocDR ];

/// IP_ManageUserDR
Property IPManageUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = IP_ManageUserDR ];

/// IP_OutInspectFlag
Property IPOutInspectFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 12, SqlFieldName = IP_OutInspectFlag ];

/// IP_MeasureDeptDR
Property IPMeasureDeptDR As User.DHCEQCMeasureDept [ SqlColumnNumber = 13, SqlFieldName = IP_MeasureDeptDR ];

/// IP_IsForcedFlag
Property IPIsForcedFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 14, SqlFieldName = IP_IsForcedFlag ];

/// IP_InspectFee
Property IPInspectFee As %Library.Float [ SqlColumnNumber = 15, SqlFieldName = IP_InspectFee ];

/// IP_Status
Property IPStatus As %Library.String(DISPLAYLIST = ",新增,提交", MAXLEN = 2, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",0,1") [ SqlColumnNumber = 16, SqlFieldName = IP_Status ];

/// IP_Remark
Property IPRemark As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 17, SqlFieldName = IP_Remark ];

/// IP_AddUserDR
Property IPAddUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 18, SqlFieldName = IP_AddUserDR ];

/// IP_AddDate
Property IPAddDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 19, SqlFieldName = IP_AddDate ];

/// IP_AddTime
Property IPAddTime As %Library.Time [ SqlColumnNumber = 20, SqlFieldName = IP_AddTime ];

/// IP_UpdateUserDR
Property IPUpdateUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 21, SqlFieldName = IP_UpdateUserDR ];

/// IP_UpdateDate
Property IPUpdateDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 22, SqlFieldName = IP_UpdateDate ];

/// IP_UpdateTime
Property IPUpdateTime As %Library.Time [ SqlColumnNumber = 23, SqlFieldName = IP_UpdateTime ];

/// IP_Hold1
Property IPHold1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 24, SqlFieldName = IP_Hold1 ];

/// IP_Hold2
Property IPHold2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 25, SqlFieldName = IP_Hold2 ];

/// IP_Hold3
Property IPHold3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 26, SqlFieldName = IP_Hold3 ];

/// IP_Hold4
Property IPHold4 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 27, SqlFieldName = IP_Hold4 ];

/// IP_Hold5
Property IPHold5 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 28, SqlFieldName = IP_Hold5 ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQInspectPlan("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="IP_AddDate">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="IP_AddTime">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="IP_AddUserDR">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="IP_CycleNum">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="IP_CycleUnitDR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="IP_EquipDR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="IP_Hold1">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="IP_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="IP_Hold3">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="IP_Hold4">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="IP_Hold5">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Data name="IP_InspectFee">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="IP_InspectTypeDR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="IP_IsForcedFlag">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="IP_ManageLocDR">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="IP_ManageUserDR">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="IP_MeasureDeptDR">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="IP_Name">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="IP_NextMaintDate">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="IP_OutInspectFlag">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="IP_PreInspectDate">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="IP_PreWarnDaysNum">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="IP_Remark">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="IP_Status">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="IP_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="IP_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="IP_UpdateUserDR">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Global>^DHCEQInspectPlan</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>IP_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{IP_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexEquip">
<Global>^DHCEQInspectPlan</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>IP_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Equip"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{IP_EquipDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{IP_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQInspectPlanS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
