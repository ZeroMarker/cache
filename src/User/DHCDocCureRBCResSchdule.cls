Class User.DHCDocCureRBCResSchdule Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DDCRS_RowID, SqlTableName = DHC_DocCureRBCResSchdule, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// DDCRS_ResPlan_DR  排班资源计划ID
Property DDCRSResPlanDR As User.DHCRBCResPlan [ SqlColumnNumber = 2, SqlFieldName = DDCRS_ResPlan_DR ];

/// DDCRS_Loc_DR   排班科室ID
Property DDCRSLocDR As User.CTLoc [ SqlColumnNumber = 3, SqlFieldName = DDCRS_Loc_DR ];

/// DDCRS_ResSource_DR   排班资源ID
Property DDCRSResSourceDR As User.RBResource [ SqlColumnNumber = 4, SqlFieldName = DDCRS_ResSource_DR ];

/// DDCRS_Date  排程日期
Property DDCRSDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 5, SqlFieldName = DDCRS_Date ];

/// DDCRS_TimeRange_DR  排程出诊时段
Property DDCRSTimeRangeDR As User.DHCDocCureRBCTimePeriodSet [ SqlColumnNumber = 6, SqlFieldName = DDCRS_TimeRange_DR ];

/// DDCRS_StartTime   开始时间
Property DDCRSStartTime As %Library.Time [ SqlColumnNumber = 7, SqlFieldName = DDCRS_StartTime ];

/// DDCRS_EndTime   结束时间
Property DDCRSEndTime As %Library.Time [ SqlColumnNumber = 8, SqlFieldName = DDCRS_EndTime ];

/// DDCRS_ServiceGroup_DR  服务组ID  用于和治疗项目绑定
Property DDCRSServiceGroupDR As User.DHCDocCureRBCServiceGroupSet [ SqlColumnNumber = 9, SqlFieldName = DDCRS_ServiceGroup_DR ];

/// DDCRS_Status  排程记录状态
Property DDCRSStatus As %Library.String(DISPLAYLIST = ",Normal,Stop", MAXLEN = 16, TRUNCATE = 1, VALUELIST = ",N,S") [ SqlColumnNumber = 10, SqlFieldName = DDCRS_Status ];

/// DDCRS_MaxNumber   最大预约数
Property DDCRSMaxNumber As %Library.Float [ SqlColumnNumber = 11, SqlFieldName = DDCRS_MaxNumber ];

/// DDCRS_AutoNumber  自动预约数
Property DDCRSAutoNumber As %Library.Float [ SqlColumnNumber = 12, SqlFieldName = DDCRS_AutoNumber ];

/// DDCRS_ChargeTime  截止缴费时间
Property DDCRSChargeTime As %Library.Time [ SqlColumnNumber = 13, SqlFieldName = DDCRS_ChargeTime ];

/// DDCRS_AvailPatType  允许预约的病人类型
Property DDCRSAvailPatType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = DDCRS_AvailPatType ];

/// DDCRS_AutoAvtiveFlag  自动预约启用开关
Property DDCRSAutoAvtiveFlag As %Library.Float [ SqlColumnNumber = 15, SqlFieldName = DDCRS_AutoAvtiveFlag ];

/// DDCRS_CreateUser_DR  创建人
Property DDCRSCreateUserDR As User.SSUser [ SqlColumnNumber = 16, SqlFieldName = DDCRS_CreateUser_DR ];

/// DDCRS_CreateDate  创建日期
Property DDCRSCreateDate As %Library.Date [ SqlColumnNumber = 17, SqlFieldName = DDCRS_CreateDate ];

/// DDCRS_CreateTime  创建时间
Property DDCRSCreateTime As %Library.Time [ SqlColumnNumber = 18, SqlFieldName = DDCRS_CreateTime ];

/// DDCRS_LastUpdateUser_DR  更新人
Property DDCRSLastUpdateUserDR As User.SSUser [ SqlColumnNumber = 19, SqlFieldName = DDCRS_LastUpdateUser_DR ];

/// DDCRS_LastUpdateDate  更新日期
Property DDCRSLastUpdateDate As %Library.Date [ SqlColumnNumber = 20, SqlFieldName = DDCRS_LastUpdateDate ];

/// DDCRS_LastUpdateTime  更新时间
Property DDCRSLastUpdateTime As %Library.Time [ SqlColumnNumber = 21, SqlFieldName = DDCRS_LastUpdateTime ];

/// DDCRSSeqNoStr 
Property DDCRSSeqNoStr As %Library.String(COLLATION = "Exact", MAXLEN = 99999, TRUNCATE = 0) [ SqlColumnNumber = 22, SqlFieldName = DDCRS_SeqNoStr ];

/// DDCRS_EndAppointTime  截止预约时间
Property DDCRSEndAppointTime As %Library.Time [ SqlColumnNumber = 23, SqlFieldName = DDCRS_EndAppointTime ];

/// DDCRP_TimeRangeFlag  是否分时段
Property DDCRSTimeRangeFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 24, SqlFieldName = DDCRS_TimeRangeFlag ];

/// DDCRP_TRLength  分时段间隔分钟
Property DDCRSTRLength As %Library.Float [ SqlColumnNumber = 25, SqlFieldName = DDCRS_TRLength ];

/// DDCRP_TRReservedNum  分时段预留号
Property DDCRSTRReservedNum As %Library.Float [ SqlColumnNumber = 26, SqlFieldName = DDCRS_TRReservedNum ];

/// DDCRP_TRRegNumStr
Property DDCRSTRRegNumStr As %Library.String(COLLATION = "Exact", MAXLEN = 99999, TRUNCATE = 0) [ SqlColumnNumber = 27, SqlFieldName = DDCRS_TRRegNumStr ];

/// DDCRP_TRRegInfoStr
Property DDCRSTRRegInfoStr As %Library.String(COLLATION = "Exact", MAXLEN = 99999, TRUNCATE = 0) [ SqlColumnNumber = 28, SqlFieldName = DDCRS_TRRegInfoStr ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCDocCureRBCResSchdule)</SqlIdExpression>
<SQLMap name="IndexDate">
<Global>^DHCDocCureRBCResSchdule</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>DDCRS_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"LocId-Res-Date"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DDCRS_Loc_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DDCRS_ResSource_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DDCRS_Date}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{DDCRS_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexGroupResource">
<Global>^DHCDocCureRBCResSchdule</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L7}</Expression>
<Field>DDCRS_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ServiceGroup-Res"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DDCRS_ServiceGroup_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DDCRS_ResSource_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DDCRS_Date}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{DDCRS_StartTime}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{DDCRS_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexLocDateRes">
<Global>^DHCDocCureRBCResSchdule</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>DDCRS_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Loc-Date-Res"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DDCRS_Loc_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DDCRS_Date}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DDCRS_ResSource_DR}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{DDCRS_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexResPlan">
<Global>^DHCDocCureRBCResSchdule</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DDCRS_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ResPlan"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DDCRS_ResPlan_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DDCRS_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexServcieGroupDate">
<Global>^DHCDocCureRBCResSchdule</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>DDCRS_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"SericeGroup"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DDCRS_ServiceGroup_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DDCRS_Date}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DDCRS_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexserviceGroupTime">
<Global>^DHCDocCureRBCResSchdule</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>DDCRS_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Service-Time"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DDCRS_ServiceGroup_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DDCRS_Date}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DDCRS_StartTime}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{DDCRS_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterMap">
<Data name="DDCRS_AutoAvtiveFlag">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="DDCRS_AutoNumber">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="DDCRS_AvailPatType">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="DDCRS_ChargeTime">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="DDCRS_CreateDate">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="DDCRS_CreateTime">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="DDCRS_CreateUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="DDCRS_Date">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="DDCRS_EndAppointTime">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="DDCRS_EndTime">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="DDCRS_LastUpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="DDCRS_LastUpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="DDCRS_LastUpdateUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="DDCRS_Loc_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DDCRS_MaxNumber">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="DDCRS_ResPlan_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DDCRS_ResSource_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DDCRS_SeqNoStr">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="DDCRS_ServiceGroup_DR">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="DDCRS_StartTime">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="DDCRS_Status">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="DDCRS_TRLength">
<Delimiter>"^"</Delimiter>
<Node>"TR"</Node>
<Piece>2</Piece>
</Data>
<Data name="DDCRS_TRRegInfoStr">
<Delimiter>"^"</Delimiter>
<Node>"TR"</Node>
<Piece>5</Piece>
</Data>
<Data name="DDCRS_TRRegNumStr">
<Delimiter>"^"</Delimiter>
<Node>"TR"</Node>
<Piece>4</Piece>
</Data>
<Data name="DDCRS_TRReservedNum">
<Delimiter>"^"</Delimiter>
<Node>"TR"</Node>
<Piece>3</Piece>
</Data>
<Data name="DDCRS_TimeRangeFlag">
<Delimiter>"^"</Delimiter>
<Node>"TR"</Node>
<Piece>1</Piece>
</Data>
<Data name="DDCRS_TimeRange_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^DHCDocCureRBCResSchdule</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DDCRS_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{DDCRS_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="locdatetime">
<Global>^DHCDocCureRBCResSchdule</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L7}</Expression>
<Field>DDCRS_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Date-Time-Res"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DDCRS_Loc_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DDCRS_Date}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DDCRS_ServiceGroup_DR}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{DDCRS_TimeRange_DR}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{DDCRS_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCRBCResSchduleS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
