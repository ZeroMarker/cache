Class User.DHCRBCResPlan Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DRP_RowID, SqlTableName = DHCRBC_ResPlan, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// DRP_LOCID
Property DRPLocID As User.CTLoc [ SqlColumnNumber = 2, SqlFieldName = DRP_LocID ];

/// DRP_RESOURCEID
Property DRPResourceID As User.RBResource [ SqlColumnNumber = 3, SqlFieldName = DRP_ResourceID ];

/// DRP_WEEK
Property DRPWeek As %Library.String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = DRP_Week ];

/// DRP_ServiceGroupID
Property DRPServiceGroupID As User.RBCServiceGroup [ SqlColumnNumber = 5, SqlFieldName = DRP_ServiceGroupID ];

/// DRP_Desc
Property DRPDesc As %Library.String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = DRP_Desc ];

/// DRP_STARTTIME
Property DRPStartTime As %Library.Time [ SqlColumnNumber = 7, SqlFieldName = DRP_StartTime ];

/// DRP_EndTime
Property DRPEndTime As %Library.Time [ SqlColumnNumber = 8, SqlFieldName = DRP_EndTime ];

/// DRP_Max
Property DRPMax As %Library.Float [ SqlColumnNumber = 9, SqlFieldName = DRP_Max ];

/// DRP_ExternalBookNumber
Property DRPAutoNumber As %Library.Float [ SqlColumnNumber = 10, SqlFieldName = DRP_AutoNumber ];

/// DRP_ChargeTime
Property DRPChargeTime As %Library.Time [ SqlColumnNumber = 11, SqlFieldName = DRP_ChargeTime ];

/// DRP_UseLock
Property DRPUseLock As %Library.String(COLLATION = "Exact", MAXLEN = 20, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = DRP_UseLock ];

/// DRP_AvailTime
Property DRPAvailTime As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = DRP_AvailTime ];

/// DRP_NotAllowIPBooked
Property DRPNotAllowIPBooked As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = DRP_NotAllowIPBooked ];

/// DRP_AvailPatType
Property DRPAvailPatType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 15, SqlFieldName = DRP_AvailPatType ];

/// DRP_NotAvailable
Property DRPNotAvailable As %Library.String(COLLATION = "Exact", MAXLEN = 5, TRUNCATE = 0) [ SqlColumnNumber = 16, SqlFieldName = DRP_NotAvailable ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCRBCResourcePlan)</SqlIdExpression>
<SQLMap name="IndexLoc">
<Global>^DHCRBCResourcePlani</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DRP_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"LocId"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DRP_LocID}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DRP_ResourceID}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DRP_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexWeekLocResource">
<Global>^DHCRBCResPlani</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>DRP_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"Week-Resource"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DRP_Week}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DRP_LocID}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DRP_ResourceID}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DRP_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterMap">
<Data name="DRP_AutoNumber">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="DRP_AvailPatType">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="DRP_AvailTime">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="DRP_ChargeTime">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="DRP_Desc">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="DRP_EndTime">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="DRP_LocID">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DRP_Max">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="DRP_NotAllowIPBooked">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="DRP_NotAvailable">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="DRP_ResourceID">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DRP_ServiceGroupID">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DRP_StartTime">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="DRP_UseLock">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="DRP_Week">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Global>^DHCRBCResourcePlan</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DRP_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{DRP_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="indexloctime">
<Global>^DHCRBCResPlani</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>DRP_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"LocSTime"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DRP_LocID}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DRP_ResourceID}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DRP_Week}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DRP_StartTime}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{DRP_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCRBCResPlanS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
