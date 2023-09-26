/// CTOR: QP
/// DATE: 2020-09-18
/// DESC: 任务日志
Class User.GCPSWTaskLog Extends %Persistent [ SqlTableName = GCPSW_TaskLog, StorageStrategy = SQLStorage ]
{

/// 项目
Property LPrj As User.GCPSWPrj [ SqlColumnNumber = 2, SqlFieldName = L_Prj ];

/// 开始日期	
Property LStartDate As %Date [ SqlColumnNumber = 3, SqlFieldName = L_StartDate ];

/// 开始时间	
Property LStartTime As %Time [ SqlColumnNumber = 4, SqlFieldName = L_StartTime ];

/// 完成日期	
Property LEndDate As %Date [ SqlColumnNumber = 5, SqlFieldName = L_EndDate ];

/// 完成时间	
Property LEndTime As %Time [ SqlColumnNumber = 6, SqlFieldName = L_EndTime ];

/// 类型
Property LType As %String [ SqlColumnNumber = 7, SqlFieldName = L_Type ];

Storage SQLStorage
{
<SqlIdExpression>$i(^BS.DOC.GCPSW.TaskLog(0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="L_EndDate">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="L_EndTime">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="L_Prj">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="L_StartDate">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="L_StartTime">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="L_Type">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Global>^BS.DOC.GCPSW.TaskLogD</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>L_ID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{L_ID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IdxEndDate">
<Global>^BS.DOC.GCPSW.TaskLogI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>L_ID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"EndDate"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{L_EndDate}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{L_ID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IdxEndDatePrj">
<Global>^BS.DOC.GCPSW.TaskLogI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>L_ID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"EndDatePrj"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{L_EndDate}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{L_Prj}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{L_ID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IdxPrj">
<Global>^BS.DOC.GCPSW.TaskLogI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>L_ID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"Prj"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{L_Prj}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{L_ID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IdxStartDate">
<Global>^BS.DOC.GCPSW.TaskLogI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>L_ID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"StartDate"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{L_StartDate}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{L_ID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IdxStartDatePrj">
<Global>^BS.DOC.GCPSW.TaskLogI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>L_ID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"StartDatePrj"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{L_StartDate}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{L_Prj}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{L_ID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IdxType">
<Global>^BS.DOC.GCPSW.TaskLogI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>L_ID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"Type"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{L_Type}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{L_ID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>L_ID</SqlRowIdName>
<StreamLocation>^User.GCPSWTaskLogS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
