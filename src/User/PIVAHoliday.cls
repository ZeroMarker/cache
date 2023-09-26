/// 排班管理-寒暑假字典
Class User.PIVAHoliday Extends (%Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, SqlTableName = PIVA_Holiday, StorageStrategy = CacheSQLStorage ]
{

/// 寒暑假类型
Property PHDesc As %Library.String [ SqlColumnNumber = 2, SqlFieldName = PH_Desc ];

/// 年份
Property PHYear As %Library.Integer [ SqlColumnNumber = 3, SqlFieldName = PH_Year ];

/// 开始日期
Property PHStartDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 4, SqlFieldName = PH_StartDate ];

/// 结束日期
Property PHEndDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 5, SqlFieldName = PH_EndDate ];

Storage CacheSQLStorage
{
<SqlIdExpression>$i(^Code.PIVA.Holiday(0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="PH_Desc">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PH_EndDate">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PH_StartDate">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PH_Year">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^Code.PIVA.Holiday</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PH_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{PH_RowId}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>PH_RowId</SqlRowIdName>
<StreamLocation>^Code.PIVA.HolidayS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
