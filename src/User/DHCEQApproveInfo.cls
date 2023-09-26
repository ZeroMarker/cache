Class User.DHCEQApproveInfo Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = AI_RowID, SqlTableName = DHC_EQApproveInfo, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// AI_ApproveRoleDR
Property AIApproveRoleDR As User.DHCEQCApproveRole [ SqlColumnNumber = 8, SqlFieldName = AI_ApproveRoleDR ];

/// AI_ApproveSetDR
Property AIApproveSetDR As User.DHCEQCApproveSet [ SqlColumnNumber = 4, SqlFieldName = AI_ApproveSetDR ];

/// AI_ApproveStatus
Property AIApproveStatus As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = AI_ApproveStatus ];

/// AI_ApproveTypeDR
Property AIApproveTypeDR As User.DHCEQCApproveType [ SqlColumnNumber = 2, SqlFieldName = AI_ApproveTypeDR ];

/// AI_NextFlowStep
Property AINextFlowStep As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = AI_NextFlowStep ];

/// AI_NextRoleDR
Property AINextRoleDR As User.DHCEQCApproveRole [ SqlColumnNumber = 5, SqlFieldName = AI_NextRoleDR ];

/// AI_SourceID
Property AISourceID As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = AI_SourceID ];

/// AI_Status
Property AIStatus As %Library.String(DISPLAYLIST = ",更新,提交,审核,作废", MAXLEN = 2, SELECTIVITY = "20.0000%", TRUNCATE = 1, VALUELIST = ",0,1,2,3") [ SqlColumnNumber = 9, SqlFieldName = AI_Status ];

/// AI_LocDR
Property AILocDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = AI_LocDR ];

/// AI_EquipTypeDR
Property AIEquipTypeDR As User.DHCEQCEquipType [ SqlColumnNumber = 11, SqlFieldName = AI_EquipTypeDR ];

/// AI_StatCatDR
Property AIStatCatDR As User.DHCEQCStatCat [ SqlColumnNumber = 12, SqlFieldName = AI_StatCatDR ];

/// AI_EquipCatDR
Property AIEquipCatDR As User.DHCEQCEquipeCat [ SqlColumnNumber = 13, SqlFieldName = AI_EquipCatDR ];

/// AI_ItemDR
Property AIItemDR As User.DHCEQCMasterItem [ SqlColumnNumber = 14, SqlFieldName = AI_ItemDR ];

/// AI_EquipDR
Property AIEquipDR As User.DHCEQEquip [ SqlColumnNumber = 15, SqlFieldName = AI_EquipDR ];

/// AI_AccessoryTypeDR
Property AIAccessoryTypeDR As User.DHCEQCAccessoryType [ SqlColumnNumber = 16, SqlFieldName = AI_AccessoryTypeDR ];

/// AI_ToLocDR
Property AIToLocDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 17, SqlFieldName = AI_ToLocDR ];

/// AI_SubType
Property AISubType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 18, SqlFieldName = AI_SubType ];

/// AI_BussInvalidFlag
Property AIBussInvalidFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 19, SqlFieldName = AI_BussInvalidFlag ];

/// AI_UserDR
Property AIUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 20, SqlFieldName = AI_UserDR ];

/// AI_Hold1
Property AIHold1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 21, SqlFieldName = AI_Hold1 ];

/// AI_Hold2
Property AIHold2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 22, SqlFieldName = AI_Hold2 ];

/// AI_Hold3
Property AIHold3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 23, SqlFieldName = AI_Hold3 ];

/// AI_Hold4
Property AIHold4 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 24, SqlFieldName = AI_Hold4 ];

/// AI_Hold5
Property AIHold5 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 25, SqlFieldName = AI_Hold5 ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQApproveInfo("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="AI_AccessoryTypeDR">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="AI_ApproveRoleDR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="AI_ApproveSetDR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="AI_ApproveStatus">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="AI_ApproveTypeDR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="AI_BussInvalidFlag">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="AI_EquipCatDR">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="AI_EquipDR">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="AI_EquipTypeDR">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="AI_Hold1">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="AI_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="AI_Hold3">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="AI_Hold4">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="AI_Hold5">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="AI_ItemDR">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="AI_LocDR">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="AI_NextFlowStep">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="AI_NextRoleDR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="AI_SourceID">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="AI_StatCatDR">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="AI_Status">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="AI_SubType">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="AI_ToLocDR">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="AI_UserDR">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Global>^DHCEQApproveInfo</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>AI_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{AI_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexApproveRole">
<Global>^DHCEQApproveInfo</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>AI_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Status"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{AI_Status}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{AI_NextRoleDR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{AI_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexApproveSet">
<Global>^DHCEQApproveInfo</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>AI_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ApproveSet"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{AI_Status}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{AI_ApproveSetDR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{AI_NextFlowStep}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{AI_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexSourceID">
<Global>^DHCEQApproveInfo</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>AI_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"SourceID"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{AI_ApproveTypeDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{AI_SourceID}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{AI_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexStatus">
<Global>^DHCEQApproveInfo</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>AI_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Status"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{AI_ApproveStatus}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{AI_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexStatusType">
<Global>^DHCEQApproveInfo</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>AI_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"StatusType"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{AI_Status}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{AI_ApproveTypeDR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{AI_SourceID}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{AI_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQApproveInfoS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
