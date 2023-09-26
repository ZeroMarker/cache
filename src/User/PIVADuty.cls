/// 排班管理-岗位
Class User.PIVADuty Extends (%Persistent, User.Abstract) [ Owner = {_SYSTEM}, SqlTableName = PIVA_Duty, StorageStrategy = CacheSQLStorage ]
{

/// 配液中心
Property PDLocDr As User.CTLoc [ SqlColumnNumber = 2, SqlFieldName = PD_Loc_Dr ];

/// 岗位代码
Property PDCode As %Library.String [ SqlColumnNumber = 3, SqlFieldName = PD_Code ];

/// 岗位名称
Property PDDesc As %Library.String [ SqlColumnNumber = 4, SqlFieldName = PD_Desc ];

/// 岗位简称
Property PDShortDesc As %Library.String [ SqlColumnNumber = 5, SqlFieldName = PD_ShortDesc ];

/// 常规可休假天数最小值
Property PDMinDays As %Library.Float [ SqlColumnNumber = 6, SqlFieldName = PD_MinDays ];

/// 常规可休假天数最大值
Property PDMaxDays As %Library.Float [ SqlColumnNumber = 7, SqlFieldName = PD_MaxDays ];

/// 必修双休日
Property PDWeekEndFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 8, SqlFieldName = PD_WeekEndFlag ];

/// 必修节假日
Property PDFestivalFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 9, SqlFieldName = PD_FestivalFlag ];

/// 倒休节假日
Property PDFestExFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 10, SqlFieldName = PD_FestExFlag ];

/// 可休寒暑假
Property PDHolidayFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 11, SqlFieldName = PD_HolidayFlag ];

/// 自由岗
Property PDFreeFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 12, SqlFieldName = PD_FreeFlag ];

Storage CacheSQLStorage
{
<SqlIdExpression>$i(^Code.PIVA.Duty(0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="PD_Code">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PD_Desc">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PD_FestExFlag">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="PD_FestivalFlag">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="PD_FreeFlag">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="PD_HolidayFlag">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="PD_Loc_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PD_MaxDays">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PD_MinDays">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PD_ShortDesc">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PD_WeekEndFlag">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Global>^Code.PIVA.Duty</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PD_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{PD_RowId}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexLoc">
<Global>^Code.PIVA.Duty</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PD_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Loc"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PD_Loc_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PD_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>PD_RowId</SqlRowIdName>
<StreamLocation>^Code.PIVA.DutyS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
