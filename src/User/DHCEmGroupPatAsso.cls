Class User.DHCEmGroupPatAsso Extends %Persistent [ Owner = {_SYSTEM}, SqlRowIdName = GPS_RowID, SqlTableName = DHC_EmGroupPatAsso, StorageStrategy = NewStorage ]
{

/// 事件创建日期 GHU_CreateDate
Property GPSCreateDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 2, SqlFieldName = GPS_CreateDate ];

/// 事件创建时间 GHU_CreateTime
Property GPSCreateTime As %Library.Time [ SqlColumnNumber = 3, SqlFieldName = GPS_CreateTime ];

/// 病人id GPS_PAPMI_Dr
Property GPSPAPMIDr As User.PAPatMas [ SqlColumnNumber = 4, SqlFieldName = GPS_PAPMI_Dr ];

/// 群伤维护字典id GPS_PAPMI_Dr
Property GPSGHUDr As User.DHCEmGroupHurt [ SqlColumnNumber = 5, SqlFieldName = GPS_GHU_Dr ];

/// 群伤事件发生地点
Property GPSSite As %Library.String [ SqlColumnNumber = 6, SqlFieldName = GPS_Site ];

/// 群伤事件发生描述
Property GPSDesc As %Library.String [ SqlColumnNumber = 7, SqlFieldName = GPS_Desc ];

/// 群伤事件发生日期 GPS_StDate
Property GPSStDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 8, SqlFieldName = GPS_StDate ];

/// 群伤事件发生时间 GPS_StTime
Property GPSStTime As %Library.Time [ SqlColumnNumber = 9, SqlFieldName = GPS_StTime ];

/// 群伤伤情级别 GPS_InjuryLev
Property GPSInjuryLev As %Library.String [ SqlColumnNumber = 10, SqlFieldName = GPS_InjuryLev ];

/// 群伤转归 GPS_Outcome
Property GPSOutcome As %Library.String [ SqlColumnNumber = 11, SqlFieldName = GPS_Outcome ];

/// 群伤备注 GPS_Remarks
Property GPSRemarks As %Library.String [ SqlColumnNumber = 12, SqlFieldName = GPS_Remarks ];

/// 群伤上报医院 GPS_Hosp_Dr
Property GPSHospDr As User.CTHospital [ SqlColumnNumber = 13, SqlFieldName = GPS_Hosp_Dr ];

Storage NewStorage
{
<SqlIdExpression>$i(^DHCEMGPS)</SqlIdExpression>
<SQLMap name="IndexDate">
<Global>^DHCEMGPS</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>GPS_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Date"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{GPS_CreateDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{GPS_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="Master">
<Data name="GPS_CreateDate">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="GPS_CreateTime">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="GPS_Desc">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="GPS_GHU_Dr">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="GPS_Hosp_Dr">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="GPS_InjuryLev">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="GPS_Outcome">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="GPS_PAPMI_Dr">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="GPS_Remarks">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="GPS_Site">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="GPS_StDate">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="GPS_StTime">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Global>^DHCEMGPS</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>GPS_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{GPS_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="indexPAPMI">
<Global>^DHCEMGPS</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>GPS_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"PAPMI"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{GPS_PAPMI_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{GPS_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEmGroupPatAssoS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
