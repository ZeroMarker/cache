Class User.DHCRBCResSchdule Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DRPS_RowID, SqlTableName = DHCRBC_ResSchdule, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// DRPS_Date
Property DRPSDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 2, SqlFieldName = DRPS_Date ];

/// DRPS_ServiceGroupID
Property DRPSServiceGroupID As User.RBCServiceGroup [ SqlColumnNumber = 3, SqlFieldName = DRPS_ServiceGroupID ];

/// DRPS_Desc
Property DRPSDesc As %Library.String(COLLATION = "Exact", MAXLEN = 18, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = DRPS_Desc ];

/// DRPS_StartTime
Property DRPSStartTime As %Library.Time [ SqlColumnNumber = 5, SqlFieldName = DRPS_StartTime ];

/// DRPS_EndTime
Property DRPSEndTime As %Library.Time [ SqlColumnNumber = 6, SqlFieldName = DRPS_EndTime ];

/// DRPS_MaxNumber
Property DRPSMaxNumber As %Library.Float [ SqlColumnNumber = 7, SqlFieldName = DRPS_MaxNumber ];

/// DRPS_ExternalBookNumber
Property DRPSAutoNumber As %Library.Float [ SqlColumnNumber = 8, SqlFieldName = DRPS_AutoNumber ];

/// DRPS_UseNumber
Property DRPSUseNumber As %Library.Float [ SqlColumnNumber = 9, SqlFieldName = DRPS_UseNumber ];

/// DRPS_RemainNumber
Property DRPSRemainNumber As %Library.Float [ SqlColumnNumber = 10, SqlFieldName = DRPS_RemainNumber ];

/// DRPS_RessourceID
Property DRPSRessourceID As User.RBResource [ SqlColumnNumber = 11, SqlFieldName = DRPS_RessourceID ];

/// DRPS_LocID
Property DRPSLocID As User.CTLoc [ SqlColumnNumber = 12, SqlFieldName = DRPS_LocID ];

/// DRPS_ResPlan_ID
Property DRPSResPlanID As User.DHCRBCResPlan [ SqlColumnNumber = 13, SqlFieldName = DRPS_ResPlan_ID ];

/// DRPS_AutoUseNumber
Property DRPSAutoUseNumber As %Library.Float [ SqlColumnNumber = 14, SqlFieldName = DRPS_AutoUseNumber ];

/// DRPS_ChargeTime
Property DRPSChargeTime As %Library.Time [ SqlColumnNumber = 15, SqlFieldName = DRPS_ChargeTime ];

/// DRPS_LockBookNumber
Property DRPSLockBookNumber As %Library.Float [ SqlColumnNumber = 16, SqlFieldName = DRPS_LockBookNumber ];

/// DRPS_RemainUnLockBookNumber
Property DRPSRemainUnLockBookNumber As %Library.Float [ SqlColumnNumber = 17, SqlFieldName = DRPS_RemainUnLockBookNumber ];

/// DRPS_NextStartTime
Property DRPSNextStartTime As %Library.Time [ SqlColumnNumber = 18, SqlFieldName = DRPS_NextStartTime ];

/// DRPS_RemainTime
Property DRPSRemainTime As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 19, SqlFieldName = DRPS_RemainTime ];

/// DRPS_AvailPatType
Property DRPSAvailPatType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 20, SqlFieldName = DRPS_AvailPatType ];

/// DRPS_RangeOfQueueNumber
Property DRPSRangeOfQueueNumber As %Library.String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 0) [ SqlColumnNumber = 21, SqlFieldName = DRPS_RangeOfQueueNumber ];

/// DRPS_UseQueueNumber
Property DRPSUseQueueNumber As %Library.String(COLLATION = "Exact", MAXLEN = 500, TRUNCATE = 0) [ SqlColumnNumber = 22, SqlFieldName = DRPS_UseQueueNumber ];

/// DRPS_OccupyTimeOfOneExam
Property DRPSOccupyTimeOfOneExam As %Library.String(COLLATION = "Exact", MAXLEN = 500, TRUNCATE = 0) [ SqlColumnNumber = 23, SqlFieldName = DRPS_OccupyTimeOfOneExam ];

/// DRPS_NotAvailable
Property DRPSNotAvailable As %Library.String(COLLATION = "Exact", MAXLEN = 5, TRUNCATE = 0) [ SqlColumnNumber = 24, SqlFieldName = DRPS_NotAvailable ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCRBCResourceSchdule)</SqlIdExpression>
<SQLMap name="IndexDate">
<Global>^DHCRBCResourceSchdulei</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>DRPS_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"LocId-Res-Date"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DRPS_LocID}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DRPS_RessourceID}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DRPS_Date}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DRPS_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexGroupResource">
<Global>^DHCRBCResSchdulei</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>DRPS_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"ServiceGroup-Res"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DRPS_ServiceGroupID}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DRPS_RessourceID}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DRPS_Date}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DRPS_StartTime}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{DRPS_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexLocDateRes">
<Global>^DHCRBCResourceSchdulei</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>DRPS_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"Loc-Date-Res"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DRPS_LocID}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DRPS_Date}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DRPS_RessourceID}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DRPS_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexResDateTime">
<Global>^DHCRBCResourceSchdulei</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>DRPS_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"Res-Date-Time"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DRPS_LocID}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DRPS_RessourceID}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DRPS_Date}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DRPS_StartTime}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{DRPS_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexResPlan">
<Global>^DHCRBCResSchdulei</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>DRPS_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"ResPlan"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DRPS_ResPlan_ID}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DRPS_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexResourceDatePlan">
<Global>^DHCRBCResSchdulei</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>DRPS_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"Resource-Date"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DRPS_LocID}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DRPS_RessourceID}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DRPS_Date}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DRPS_ResPlan_ID}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{DRPS_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexServcieGroupDate">
<Global>^DHCRBCResSchdulei</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DRPS_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"SericeGroup"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DRPS_ServiceGroupID}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DRPS_Date}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DRPS_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexserviceGroupTime">
<Global>^DHCRBCResSchdulei</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>DRPS_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"Service-Time"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DRPS_ServiceGroupID}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DRPS_Date}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DRPS_StartTime}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DRPS_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterMap">
<Data name="DRPS_AutoNumber">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="DRPS_AutoUseNumber">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="DRPS_AvailPatType">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="DRPS_ChargeTime">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="DRPS_Date">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DRPS_Desc">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DRPS_EndTime">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="DRPS_LocID">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="DRPS_LockBookNumber">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="DRPS_MaxNumber">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="DRPS_NextStartTime">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="DRPS_NotAvailable">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="DRPS_OccupyTimeOfOneExam">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="DRPS_RangeOfQueueNumber">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="DRPS_RemainNumber">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="DRPS_RemainTime">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="DRPS_RemainUnLockBookNumber">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="DRPS_ResPlan_ID">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="DRPS_RessourceID">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DRPS_ServiceGroupID">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="DRPS_StartTime">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="DRPS_UseNumber">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="DRPS_UseQueueNumber">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Global>^DHCRBCResourceSchdule</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DRPS_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{DRPS_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="indexDateTime">
<Global>^DHCRBCResSchdulei</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>DRPS_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"Date-Time-ServiceRes"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DRPS_Date}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DRPS_StartTime}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DRPS_ServiceGroupID}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DRPS_RessourceID}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{DRPS_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="locdatetime">
<Global>^DHCRBCResourceSchdulei</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>DRPS_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"Date-Time-Res"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DRPS_LocID}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DRPS_Date}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DRPS_ServiceGroupID}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DRPS_Desc}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{DRPS_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCRBCResSchduleS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
