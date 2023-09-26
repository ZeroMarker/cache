Class User.DHCPHWinDevice Extends (%Library.Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PHWD_RowID, SqlTableName = DHC_PHWinDevice, StorageStrategy = SQLStorage ]
{

/// 发药窗口
Property PHWDPHWDR As User.DHCPHWINDOW [ Required, SqlColumnNumber = 2, SqlFieldName = PHWD_PHW_DR ];

/// 设备唯一号
Property PHWDDeviceID As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = PHWD_DeviceID ];

/// 登录人
Property PHWDUserDR As User.SSUser [ SqlColumnNumber = 4, SqlFieldName = PHWD_User_DR ];

/// 当前是否有效
Property PHWDUseFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ InitialExpression = "N", SqlColumnNumber = 5, SqlFieldName = PHWD_UseFlag ];

/// 登录日期
Property PHWDLogInDate As %Date [ SqlColumnNumber = 6, SqlFieldName = PHWD_LogInDate ];

/// 登录时间
Property PHWDLogInTime As %Time [ SqlColumnNumber = 7, SqlFieldName = PHWD_LogInTime ];

/// 登出日期
Property PHWDLogOutDate As %Date [ SqlColumnNumber = 8, SqlFieldName = PHWD_LogOutDate ];

/// 登出时间
Property PHWDLogOutTime As %Time [ SqlColumnNumber = 9, SqlFieldName = PHWD_LogOutTime ];

/// 当天登录次数
Property PHWDLogTimes As %Library.Float [ SqlColumnNumber = 10, SqlFieldName = PHWD_LogTimes ];

/// 当天分配的处方数
Property PHWDTotalNum As %Library.Float [ SqlColumnNumber = 11, SqlFieldName = PHWD_TotalNum ];

/// 当天配药完成的处方数
Property PHWDCompNum As %Library.Float [ SqlColumnNumber = 12, SqlFieldName = PHWD_CompNum ];

/// 当天登录次数
Property PHWDCancelNum As %Library.Float [ SqlColumnNumber = 13, SqlFieldName = PHWD_CancelNum ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCPHWD)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="PHWD_CancelNum">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="PHWD_CompNum">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="PHWD_DeviceID">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PHWD_LogInDate">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PHWD_LogInTime">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PHWD_LogOutDate">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="PHWD_LogOutTime">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="PHWD_LogTimes">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="PHWD_PHW_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PHWD_TotalNum">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="PHWD_UseFlag">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PHWD_User_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCPHWD</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PHWD_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{PHWD_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexDev">
<Global>^DHCPHWDi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PHWD_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>"Dev"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>{PHWD_PHW_DR}</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{PHWD_DeviceID}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{PHWD_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexUseDev">
<Global>^DHCPHWDi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>PHWD_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"UseDev"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PHWD_PHW_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PHWD_UseFlag}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PHWD_DeviceID}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PHWD_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexUserDev">
<Global>^DHCPHWDi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>PHWD_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"UserDev"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PHWD_User_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PHWD_UseFlag}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PHWD_PHW_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PHWD_DeviceID}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{PHWD_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexUserWinDev">
<Global>^DHCPHWDi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>PHWD_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"UserWinDev"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PHWD_User_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PHWD_PHW_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PHWD_DeviceID}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PHWD_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>User.DHCPHWinDeviceS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
