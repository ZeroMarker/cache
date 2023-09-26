Class User.DHCDocCureRBCResPlan Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DDCRP_RowID, SqlTableName = DHC_DocCureRBCResPlan, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// DDCRP_Loc_DR 排班科室ID
Property DDCRPLocDR As User.CTLoc [ SqlColumnNumber = 2, SqlFieldName = DDCRP_Loc_DR ];

/// DDCRP_ResSource_DR 排班资源ID
Property DDCRPResSourceDR As User.RBResource [ SqlColumnNumber = 3, SqlFieldName = DDCRP_ResSource_DR ];

/// DDCRP_Week  星期
Property DDCRPWeek As %Library.String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = DDCRP_Week ];

/// DDCRP_TimeRange_DR 排程出诊时段
Property DDCRPTimeRangeDR As User.DHCDocCureRBCTimePeriodSet [ SqlColumnNumber = 5, SqlFieldName = DDCRP_TimeRange_DR ];

/// DDCRP_StartTime  开始时间
Property DDCRPStartTime As %Library.Time [ SqlColumnNumber = 6, SqlFieldName = DDCRP_StartTime ];

/// DDCRP_EndTime  结束时间
Property DDCRPEndTime As %Library.Time [ SqlColumnNumber = 7, SqlFieldName = DDCRP_EndTime ];

/// DDCRP_ServiceGroup_DR  服务组ID
Property DDCRPServiceGroupDR As User.DHCDocCureRBCServiceGroupSet [ SqlColumnNumber = 8, SqlFieldName = DDCRP_ServiceGroup_DR ];

/// DDCRP_MaxNumber  最大预约数
Property DDCRPMaxNumber As %Library.Float [ SqlColumnNumber = 9, SqlFieldName = DDCRP_MaxNumber ];

/// DDCRP_AutoNumber  自动预约数
Property DDCRPAutoNumber As %Library.Float [ SqlColumnNumber = 10, SqlFieldName = DDCRP_AutoNumber ];

/// DDCRP_ChargeTime  截止缴费时间
Property DDCRPChargeTime As %Library.Time [ SqlColumnNumber = 11, SqlFieldName = DDCRP_ChargeTime ];

/// DDCRP_AvailPatType  允许预约的病人类型
Property DDCRPAvailPatType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = DDCRP_AvailPatType ];

/// DDCRP_AutoAvtiveFlag  自动预约启用开关
Property DDCRPAutoAvtiveFlag As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = DDCRP_AutoAvtiveFlag ];

/// DDCRP_AvtiveFlag  是否激活
Property DDCRPAvtiveFlag As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = DDCRP_AvtiveFlag ];

/// DDCRP_EndAppointTime  截止预约时间
Property DDCRPEndAppointTime As %Library.Time [ SqlColumnNumber = 15, SqlFieldName = DDCRP_EndAppointTime ];

/// DDCRP_TimeRangeFlag  是否分时段
Property DDCRPTimeRangeFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 16, SqlFieldName = DDCRP_TimeRangeFlag ];

/// DDCRP_TRLength  分时段间隔分钟
Property DDCRPTRLength As %Library.Float [ SqlColumnNumber = 17, SqlFieldName = DDCRP_TRLength ];

/// DDCRP_TRReservedNum  分时段预留号
Property DDCRPTRReservedNum As %Library.Float [ SqlColumnNumber = 18, SqlFieldName = DDCRP_TRReservedNum ];

/// DDCRP_TRRegNumStr
Property DDCRPTRRegNumStr As %Library.String(COLLATION = "Exact", MAXLEN = 99999, TRUNCATE = 0) [ SqlColumnNumber = 19, SqlFieldName = DDCRP_TRRegNumStr ];

/// DDCRP_TRRegInfoStr
Property DDCRPTRRegInfoStr As %Library.String(COLLATION = "Exact", MAXLEN = 99999, TRUNCATE = 0) [ SqlColumnNumber = 20, SqlFieldName = DDCRP_TRRegInfoStr ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCDocCureRBCResPlan)</SqlIdExpression>
<SQLMap name="IndexLoc">
<Global>^DHCDocCureRBCResPlan</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DDCRP_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"LocId"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DDCRP_Loc_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DDCRP_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexLocResSource">
<Global>^DHCDocCureRBCResPlan</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>DDCRP_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"LRS"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DDCRP_Loc_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DDCRP_ResSource_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DDCRP_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexResSource">
<Global>^DHCDocCureRBCResPlan</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DDCRP_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"RS"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DDCRP_ResSource_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DDCRP_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexWeekLocResource">
<Global>^DHCDocCureRBCResPlan</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>DDCRP_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Week-Resource"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DDCRP_Week}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DDCRP_Loc_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DDCRP_ResSource_DR}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{DDCRP_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterMap">
<Data name="DDCRP_AutoAvtiveFlag">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="DDCRP_AutoNumber">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="DDCRP_AvailPatType">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="DDCRP_AvtiveFlag">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="DDCRP_ChargeTime">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="DDCRP_EndAppointTime">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="DDCRP_EndTime">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="DDCRP_Loc_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DDCRP_MaxNumber">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="DDCRP_ResSource_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DDCRP_ServiceGroup_DR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="DDCRP_StartTime">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="DDCRP_TRLength">
<Delimiter>"^"</Delimiter>
<Node>"TR"</Node>
<Piece>2</Piece>
</Data>
<Data name="DDCRP_TRRegInfoStr">
<Delimiter>"^"</Delimiter>
<Node>"TR"</Node>
<Piece>5</Piece>
</Data>
<Data name="DDCRP_TRRegNumStr">
<Delimiter>"^"</Delimiter>
<Node>"TR"</Node>
<Piece>4</Piece>
</Data>
<Data name="DDCRP_TRReservedNum">
<Delimiter>"^"</Delimiter>
<Node>"TR"</Node>
<Piece>3</Piece>
</Data>
<Data name="DDCRP_TimeRangeFlag">
<Delimiter>"^"</Delimiter>
<Node>"TR"</Node>
<Piece>1</Piece>
</Data>
<Data name="DDCRP_TimeRange_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="DDCRP_Week">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCDocCureRBCResPlan</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DDCRP_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{DDCRP_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCRBCResPlanS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
