Class User.DHCTimeRange Extends (%Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = TR_RowId, SqlTableName = DHC_TimeRange, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// TR_CancelTime   退号时间点
Property TRCancelTime As %Library.Time [ SqlColumnNumber = 7, SqlFieldName = TR_CancelTime ];

/// TR_Code
Property TRCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = TR_Code ];

/// TR_Desc
Property TRDesc As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = TR_Desc ];

/// TR_EndTime
Property TREndTime As %Library.Time [ SqlColumnNumber = 5, SqlFieldName = TR_EndTime ];

/// TR_AppReturnTime   预约号回归时间点
Property TRReturnTime As %Library.Time [ SqlColumnNumber = 6, SqlFieldName = TR_AppReturnTime ];

/// TR_StartTime
Property TRStartTime As %Library.Time [ SqlColumnNumber = 4, SqlFieldName = TR_StartTime ];

/// TR_ValidEndDate    //有效截止日期
Property TRValidEndDate As %Library.Date [ SqlColumnNumber = 9, SqlFieldName = TR_ValidEndDate ];

/// TR_ValidStartDate  //有效开始日期
Property TRValidStartDate As %Library.Date [ SqlColumnNumber = 8, SqlFieldName = TR_ValidStartDate ];

/// TR_RegSTTime    //挂号开时间
Property TRRegSTTime As %Library.Time [ SqlColumnNumber = 10, SqlFieldName = TR_RegSTTime ];

/// TR_RegEndTime  //挂号结束时间
Property TRRegEndTime As %Library.Time [ SqlColumnNumber = 11, SqlFieldName = TR_RegEndTime ];

/// TR_AllowSpaceReturnDay  //允许就诊日后退号天数
Property TRAllowSpaceReturnDay As %Library.Float [ SqlColumnNumber = 12, SqlFieldName = TR_AllowSpaceReturnDay ];

/// TR_Checkin //需要报到
Property TRCheckin As %Library.String [ SqlColumnNumber = 13, SqlFieldName = TR_Checkin ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCTimeRange)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="TR_AllowSpaceReturnDay">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="TR_AppReturnTime">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="TR_CancelTime">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="TR_Checkin">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="TR_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="TR_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="TR_EndTime">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="TR_RegEndTime">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="TR_RegSTTime">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="TR_StartTime">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="TR_ValidEndDate">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="TR_ValidStartDate">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Global>^DHCTimeRange</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>TR_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{TR_Rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>TR_RowId</SqlRowIdName>
<StreamLocation>^User.DHCTimeRangeS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
