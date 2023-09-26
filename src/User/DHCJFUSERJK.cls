Class User.DHCJFUSERJK Extends (%Library.Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = JK_RowId, SqlTableName = DHC_JFUSERJK, StorageStrategy = SQLStorage ]
{

/// JK_Date
Property JKDate As %Library.Date(FORMAT = 1) [ InitialExpression = {+$h}, SqlColumnNumber = 2, SqlFieldName = JK_Date ];

/// JK_Time
Property JKTime As %Library.Time [ InitialExpression = {$p($h,",",2)}, SqlColumnNumber = 3, SqlFieldName = JK_Time ];

/// JK_StDate
Property JKStDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 4, SqlFieldName = JK_StDate ];

/// JK_EndDate
Property JKEndDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 5, SqlFieldName = JK_EndDate ];

/// JK_User
Property JKUser As User.SSUser [ SqlColumnNumber = 6, SqlFieldName = JK_User ];

/// JK_inceptflag
Property JKinceptflag As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = JK_inceptflag ];

/// JK_inceptdate
Property JKinceptdate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 8, SqlFieldName = JK_inceptdate ];

/// JK_incepttime
Property JKincepttime As %Library.Time [ SqlColumnNumber = 9, SqlFieldName = JK_incepttime ];

/// JK_inceptuser
Property JKinceptuser As User.SSUser [ SqlColumnNumber = 10, SqlFieldName = JK_inceptuser ];

/// JK_Flag
Property JKFlag As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = JK_Flag ];

/// JK_StTime
Property JKStTime As %Library.Time [ SqlColumnNumber = 12, SqlFieldName = JK_StTime ];

/// JK_EndTime
Property JKEndTime As %Library.Time [ SqlColumnNumber = 13, SqlFieldName = JK_EndTime ];

/// Normal Deposit NO Segment
Property JKNormalDepNO As %Library.String(COLLATION = "Exact", MAXLEN = 500000, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = JK_NormalDepNO ];

/// Strike Deposit NO Segment
Property JKStrikeDepNO As %Library.String(COLLATION = "Exact", MAXLEN = 500000, TRUNCATE = 0) [ SqlColumnNumber = 15, SqlFieldName = JK_StrikeDepNO ];

/// Abort Deposit NO Segment
Property JKAbortDepNO As %Library.String(COLLATION = "Exact", MAXLEN = 500000, TRUNCATE = 0) [ SqlColumnNumber = 16, SqlFieldName = JK_AbortDepNO ];

/// Normal Deposit Number
Property JKNormalDepNum As %Library.Float [ SqlColumnNumber = 17, SqlFieldName = JK_NormalDepNum ];

/// Strike Deposit Number
Property JKStrikeDepNum As %Library.Float [ SqlColumnNumber = 18, SqlFieldName = JK_StrikeDepNum ];

/// Abort Deposit Number
Property JKAbortDepNum As %Library.Float [ SqlColumnNumber = 19, SqlFieldName = JK_AbortDepNum ];

/// Normal Invoice NO Segment
Property JKNormalInvNO As %Library.String(COLLATION = "Exact", MAXLEN = 500000, TRUNCATE = 0) [ SqlColumnNumber = 20, SqlFieldName = JK_NormalInvNO ];

/// Strike Invoice NO Segment
Property JKStrikeInvNO As %Library.String(COLLATION = "Exact", MAXLEN = 500000, TRUNCATE = 0) [ SqlColumnNumber = 21, SqlFieldName = JK_StrikeInvNO ];

/// Abort Invoice NO Segment
Property JKAbortInvNO As %Library.String(COLLATION = "Exact", MAXLEN = 500000, TRUNCATE = 0) [ SqlColumnNumber = 22, SqlFieldName = JK_AbortInvNO ];

/// Normal Invoice Number
Property JKNormalInvNum As %Library.Float [ SqlColumnNumber = 23, SqlFieldName = JK_NormalInvNum ];

/// Strike Invoice Number
Property JKStrikeInvNum As %Library.Float [ SqlColumnNumber = 24, SqlFieldName = JK_StrikeInvNum ];

/// Abort Invoice Number
Property JKAbortInvNum As %Library.Float [ SqlColumnNumber = 25, SqlFieldName = JK_AbortInvNum ];

/// JK_IPReceive_DR
Property JKIPReceiveDR As User.DHCIPBillReceive [ SqlColumnNumber = 26, SqlFieldName = JK_IPReceive_DR ];

/// JK_ReceiveFlag
Property JKReceiveFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ InitialExpression = "N", SqlColumnNumber = 27, SqlFieldName = JK_ReceiveFlag ];

/// JK_Hospital_DR
Property JKHospitalDR As User.CTHospital [ Required, SqlColumnNumber = 28, SqlFieldName = JK_Hospital_DR ];

/// JK_VerifyDate 核销日期 Add XiaoShuai 2022-07-05
Property JKVerifyDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 29, SqlFieldName = JK_VerifyDate ];

/// JK_VerifyTime 核销时间 Add XiaoShuai 2022-07-05
Property JKVerifyTime As %Library.Time [ SqlColumnNumber = 30, SqlFieldName = JK_VerifyTime ];

/// JK_VerifyUser 核销人 Add XiaoShuai 2022-07-05
Property JKVerifyUser As User.SSUser [ SqlColumnNumber = 31, SqlFieldName = JK_VerifyUser ];

/// JK_VerifyStatus 核销状态 Add XiaoShuai 2022-07-05
Property JKVerifyStatus As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 32, SqlFieldName = JK_VerifyStatus ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCJFUSERJK)</SqlIdExpression>
<SQLMap name="IndexDate">
<Global>^DHCJFUSERJK</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>JK_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"date"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{JK_Date}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{JK_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexReceiveDR">
<Global>^DHCJFUSERJK</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>JK_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"RECEIVEDR"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{JK_IPReceive_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{JK_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexReceiveFlag">
<Global>^DHCJFUSERJK</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>JK_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"RECEIVEFLAG"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{JK_ReceiveFlag}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{JK_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexUSER">
<Global>^DHCJFUSERJK</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>JK_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"user"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{JK_User}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{JK_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexVerifyDate">
<Global>^DHCJFUSERJK</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>JK_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<Expression>"VerifyDate"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{JK_VerifyDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{JK_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexVerifyUser">
<Global>^DHCJFUSERJK</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>JK_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<Expression>"VerifyUser"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{JK_VerifyUser}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{JK_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterDHCJFUSERJK">
<Data name="JK_AbortDepNO">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="JK_AbortDepNum">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="JK_AbortInvNO">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="JK_AbortInvNum">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="JK_Date">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="JK_EndDate">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="JK_EndTime">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="JK_Flag">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="JK_Hospital_DR">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Data name="JK_IPReceive_DR">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="JK_NormalDepNO">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="JK_NormalDepNum">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="JK_NormalInvNO">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="JK_NormalInvNum">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="JK_ReceiveFlag">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="JK_StDate">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="JK_StTime">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="JK_StrikeDepNO">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="JK_StrikeDepNum">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="JK_StrikeInvNO">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="JK_StrikeInvNum">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="JK_Time">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="JK_User">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="JK_VerifyDate">
<Delimiter>"^"</Delimiter>
<Piece>28</Piece>
</Data>
<Data name="JK_VerifyStatus">
<Delimiter>"^"</Delimiter>
<Piece>31</Piece>
</Data>
<Data name="JK_VerifyTime">
<Delimiter>"^"</Delimiter>
<Piece>29</Piece>
</Data>
<Data name="JK_VerifyUser">
<Delimiter>"^"</Delimiter>
<Piece>30</Piece>
</Data>
<Data name="JK_inceptdate">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="JK_inceptflag">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="JK_incepttime">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="JK_inceptuser">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Global>^DHCJFUSERJK</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>JK_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{JK_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="indexinceptflag">
<Global>^DHCJFUSERJK</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>JK_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"inceptflag"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{JK_inceptflag}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{JK_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexinceptuser">
<Global>^DHCJFUSERJK</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>JK_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"inceptuser"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{JK_inceptuser}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{JK_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexjinceptdate">
<Global>^DHCJFUSERJK</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>JK_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"inceptdate"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{JK_inceptdate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{JK_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexjkflag">
<Global>^DHCJFUSERJK</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>JK_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"jkflag"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{JK_Flag}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{JK_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCJFUSERJKS</StreamLocation>
<Type>%Storage.SQL</Type>
}

Parameter EXTENTSIZE = 250;

}
