Class User.DHCDisScheduleType Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = SCHT_RowID, SqlTableName = DHC_DisScheduleType, StorageStrategy = SQLStorage ]
{

/// 代码  SCHT_Code
Property SCHTCode As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = SCHT_Code ];

/// 描述  SCHT_Desc
Property SCHTDesc As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = SCHT_Desc ];

/// 开始日期  SCHT_StartDate	
Property SCHTStartDate As %Date [ SqlColumnNumber = 4, SqlFieldName = SCHT_StartDate ];

/// 开始时间  SCHT_StartTime	
Property SCHTStartTime As %Library.String [ SqlColumnNumber = 5, SqlFieldName = SCHT_StartTime ];

/// 截止日期  SCHT_EndDate	
Property SCHTEndDate As %Date [ SqlColumnNumber = 6, SqlFieldName = SCHT_EndDate ];

/// 截止时间  SCHTEndTime	
Property SCHTEndTime As %Library.String [ SqlColumnNumber = 7, SqlFieldName = SCHT_EndTime ];

/// 上一级的rowid  SCHT_LastRowID
Property SCHTLastRowID As User.DHCDisScheduleType [ SqlColumnNumber = 8, SqlFieldName = SCHT_LastRowID ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCDISSCHT)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="SCHT_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="SCHT_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="SCHT_EndDate">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="SCHT_EndTime">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="SCHT_LastRowID">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="SCHT_StartDate">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="SCHT_StartTime">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Global>^DHCDISSCHT</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>SCHT_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{SCHT_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^DHCDISSCHT</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>SCHT_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$ALPHAUP({SCHT_Code})</Expression>
</Subscript>
<Subscript name="4">
<Expression>{SCHT_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^DHCDISSCHT</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>SCHT_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$ALPHAUP({SCHT_Desc})</Expression>
</Subscript>
<Subscript name="4">
<Expression>{SCHT_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexParref">
<Global>^DHCDISSCHT</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>SCHT_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Parref"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{SCHT_LastRowID}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{SCHT_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCDisScheduleTypeS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
