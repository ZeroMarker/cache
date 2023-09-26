/// CTOR: QP
/// DATE: 2016-08-14
/// DESC: 抗菌药物流程日志记录表
Class DHCAnt.Base.MainLog Extends %Persistent [ StorageStrategy = CacheSQLStorage ]
{

/// MLOG_Type 日志类型
Property MLOGType As %Library.String [ SqlColumnNumber = 2, SqlFieldName = MLOG_Type ];

/// MLOG_Desc 日志描述
Property MLOGDesc As %Library.String [ SqlColumnNumber = 3, SqlFieldName = MLOG_Desc ];

/// MLOG_Code 日志代码
Property MLOGCode As %Library.String [ SqlColumnNumber = 4, SqlFieldName = MLOG_Code ];

/// MLOG_ParentCode 日志父类代码
Property MLOGParentCode As %Library.String [ SqlColumnNumber = 5, SqlFieldName = MLOG_ParentCode ];

/// MLOG_QuoteDR 引用指针，一般存放相关表ID
Property MLOGQuoteDR As %Library.String [ SqlColumnNumber = 6, SqlFieldName = MLOG_QuoteDR ];

/// MLOG_User 操作人(SS_USER)
Property MLOGUser As %Library.String [ SqlColumnNumber = 7, SqlFieldName = MLOG_User ];

/// MLOG_UpdateDate 操作日期
Property MLOGUpdateDate As %Library.Date [ SqlColumnNumber = 8, SqlFieldName = MLOG_UpdateDate ];

/// MLOG_UpdateTime 操作时间
Property MLOGUpdateTime As %Library.Time [ SqlColumnNumber = 9, SqlFieldName = MLOG_UpdateTime ];

/// MLOG_Status 操作状态
Property MLOGStatus As %Library.String [ SqlColumnNumber = 10, SqlFieldName = MLOG_Status ];

/// MLOG_Action 操作动作
Property MLOGAction As %Library.String [ SqlColumnNumber = 11, SqlFieldName = MLOG_Action ];

/// MLOG_Value 操作值
Property MLOGValue As %Library.String [ SqlColumnNumber = 12, SqlFieldName = MLOG_Value ];

/// MLOG_NoteA 备用1 
Property MLOGNoteA As %Library.String [ SqlColumnNumber = 13, SqlFieldName = MLOG_NoteA ];

/// MLOG_NoteB 备用2
Property MLOGNoteB As %Library.String [ SqlColumnNumber = 14, SqlFieldName = MLOG_NoteB ];

/// MLOG_NoteC 备用3
Property MLOGNoteC As %Library.String [ SqlColumnNumber = 15, SqlFieldName = MLOG_NoteC ];

/// MLOG_NoteD 备用4
Property MLOGNoteD As %Library.String [ SqlColumnNumber = 16, SqlFieldName = MLOG_NoteD ];

Storage CacheSQLStorage
{
<SqlIdExpression>$i(^DHCAntBaseMainLogD(0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="MLOG_Action">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="MLOG_Code">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="MLOG_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="MLOG_NoteA">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="MLOG_NoteB">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="MLOG_NoteC">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="MLOG_NoteD">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="MLOG_ParentCode">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="MLOG_QuoteDR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="MLOG_Status">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="MLOG_Type">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="MLOG_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="MLOG_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="MLOG_User">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="MLOG_Value">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Global>^DHCAntBaseMainLogD</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>MLOG_ID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{MLOG_ID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexMLOGParentCode">
<Global>^DHCAntBaseMainLogI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>MLOG_ID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"MLOGParentCode"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{MLOG_ParentCode}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{MLOG_ID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexMLOGType">
<Global>^DHCAntBaseMainLogI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>MLOG_ID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"MLOGType"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{MLOG_Type}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{MLOG_ID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexMLOGTypeCode">
<Global>^DHCAntBaseMainLogI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>MLOG_ID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"MLOGTypeCode"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{MLOG_Type}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{MLOG_Code}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{MLOG_ID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexMLOGTypeCodeQuote">
<Global>^DHCAntBaseMainLogI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>MLOG_ID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"MLOGTypeCodeQuote"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{MLOG_Type}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{MLOG_Code}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{MLOG_QuoteDR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{MLOG_ID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexMLOGUpdateDate">
<Global>^DHCAntBaseMainLogI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>MLOG_ID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"MLOGUpdateDate"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{MLOG_UpdateDate}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{MLOG_ID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>MLOG_ID</SqlRowIdName>
<StreamLocation>^DHCAnt.Base.MainLogS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
