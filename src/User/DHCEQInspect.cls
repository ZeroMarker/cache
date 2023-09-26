Class User.DHCEQInspect Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = IS_RowID, SqlTableName = DHC_EQInspect, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// IS_EquipDR
Property ISEquipDR As User.DHCEQEquip [ SqlColumnNumber = 2, SqlFieldName = IS_EquipDR ];

/// IS_InspectPlanDR
Property ISInspectPlanDR As User.DHCEQInspectPlan [ SqlColumnNumber = 3, SqlFieldName = IS_InspectPlanDR ];

/// IS_InspectTypeDR
Property ISInspectTypeDR As User.DHCEQCInspectType [ SqlColumnNumber = 4, SqlFieldName = IS_InspectTypeDR ];

/// IS_InspectDate
Property ISInspectDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 5, SqlFieldName = IS_InspectDate ];

/// IS_ManageLocDR
Property ISManageLocDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = IS_ManageLocDR ];

/// IS_ManageUserDR
Property ISManageUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = IS_ManageUserDR ];

/// IS_UseLocDR
Property ISUseLocDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = IS_UseLocDR ];

/// IS_MeasureDeptDR
Property ISMeasureDeptDR As User.DHCEQCMeasureDept [ SqlColumnNumber = 9, SqlFieldName = IS_MeasureDeptDR ];

/// IS_InspectUsers
Property ISInspectUsers As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = IS_InspectUsers ];

/// IS_InspectFee
Property ISInspectFee As %Library.Float [ SqlColumnNumber = 11, SqlFieldName = IS_InspectFee ];

/// IS_ResultDR
Property ISResultDR As User.DHCEQCInspectResult [ SqlColumnNumber = 12, SqlFieldName = IS_ResultDR ];

/// IS_IsForcedFlag
Property ISIsForcedFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 13, SqlFieldName = IS_IsForcedFlag ];

/// IS_Status
Property ISStatus As %Library.String(DISPLAYLIST = ",新增,提交", MAXLEN = 2, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",0,1") [ SqlColumnNumber = 14, SqlFieldName = IS_Status ];

/// IS_Remark
Property ISRemark As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 15, SqlFieldName = IS_Remark ];

/// IS_AddUserDR
Property ISAddUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 16, SqlFieldName = IS_AddUserDR ];

/// IS_AddDate
Property ISAddDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 17, SqlFieldName = IS_AddDate ];

/// IS_AddTime
Property ISAddTime As %Library.Time [ SqlColumnNumber = 18, SqlFieldName = IS_AddTime ];

/// IS_UpdateUserDR
Property ISUpdateUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 19, SqlFieldName = IS_UpdateUserDR ];

/// IS_UpdateDate
Property ISUpdateDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 20, SqlFieldName = IS_UpdateDate ];

/// IS_UpdateTime
Property ISUpdateTime As %Library.Time [ SqlColumnNumber = 21, SqlFieldName = IS_UpdateTime ];

/// IS_OutInspectFlag
Property ISOutInspectFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 22, SqlFieldName = IS_OutInspectFlag ];

/// IS_Hold1
Property ISHold1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 23, SqlFieldName = IS_Hold1 ];

/// IS_Hold2
Property ISHold2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 24, SqlFieldName = IS_Hold2 ];

/// IS_Hold3
Property ISHold3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 25, SqlFieldName = IS_Hold3 ];

/// IS_Hold4
Property ISHold4 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 26, SqlFieldName = IS_Hold4 ];

/// IS_Hold5
Property ISHold5 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 27, SqlFieldName = IS_Hold5 ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQInspect("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="IS_AddDate">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="IS_AddTime">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="IS_AddUserDR">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="IS_EquipDR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="IS_Hold1">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="IS_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="IS_Hold3">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="IS_Hold4">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="IS_Hold5">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="IS_InspectDate">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="IS_InspectFee">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="IS_InspectPlanDR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="IS_InspectTypeDR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="IS_InspectUsers">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="IS_IsForcedFlag">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="IS_ManageLocDR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="IS_ManageUserDR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="IS_MeasureDeptDR">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="IS_OutInspectFlag">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="IS_Remark">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="IS_ResultDR">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="IS_Status">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="IS_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="IS_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="IS_UpdateUserDR">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="IS_UseLocDR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Global>^DHCEQInspect</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>IS_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{IS_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexEquip">
<Global>^DHCEQInspect</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>IS_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Equip"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{IS_EquipDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{IS_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexEquipDate">
<Global>^DHCEQInspect</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>IS_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"EquipDate"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{IS_EquipDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{IS_InspectDate}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{IS_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQInspectS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
