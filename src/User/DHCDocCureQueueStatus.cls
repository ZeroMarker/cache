Class User.DHCDocCureQueueStatus Extends %Persistent [ Owner = {_SYSTEM}, SqlTableName = DHC_DocCure_QueueStatus, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 1000000;

Index RowIDBasedIDKeyIndex On (QSParRef, QSChildSub) [ IdKey, PrimaryKey, Unique ];

/// QS_ParRef
Property QSParRef As User.DHCDocCureQueue [ Required, SqlColumnNumber = 2, SqlFieldName = QS_ParRef ];

/// QS_ChildSub
Property QSChildSub As %Float(MINVAL = 1) [ InitialExpression = {$i(^DHCDocCureQueueStatus(+$s($d(initvalue):initvalue,1:%d(2))))}, Required, SqlColumnNumber = 3, SqlFieldName = QS_ChildSub ];

/// QS_Date 状态更新日期
Property QSDate As %Library.Date [ SqlColumnNumber = 4, SqlFieldName = QS_Date ];

/// QS_Time 状态更新时间
Property QSTime As %Time [ SqlColumnNumber = 5, SqlFieldName = QS_Time ];

Property QSDocDr As User.CTCareProv [ SqlColumnNumber = 6, SqlFieldName = QS_DocDr ];

/// QS_Status 更新后状态
Property QSStatusDR As User.DHCDocCurePerState [ Required, SqlColumnNumber = 7, SqlFieldName = QS_Status_DR ];

/// QS_UpUserID 状态更新用户
Property QSUpUserID As User.SSUser [ SqlColumnNumber = 8, SqlFieldName = QS_UpUserID ];

Storage SQLStorage
{
<ExtentSize>1000000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="QS_ChildSub">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="QS_Date">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="QS_DocDr">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="QS_ParRef">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="QS_Status_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="QS_Time">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="QS_UpUserID">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^DHCDocCureQueueStatus</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>QS_ParRef</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L2}</Expression>
<Field>QS_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{QS_ParRef}</Expression>
</Subscript>
<Subscript name="2">
<Expression>{QS_ChildSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexQSDate">
<Global>^DHCDocCureQueueStatusi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>QS_ParRef</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>QS_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"Date"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{QS_Date}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{QS_ParRef}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{QS_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexStatus">
<Global>^DHCDocCureQueueStatusi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>QS_ParRef</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>QS_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"Status"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{QS_Date}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{QS_Status_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{QS_ParRef}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{QS_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="InsexUpUserID">
<Global>^DHCDocCureQueueStatusi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>QS_ParRef</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>QS_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"UPUser"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{QS_Date}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{QS_UpUserID}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{QS_ParRef}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{QS_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>QS_RowId</SqlRowIdName>
<StreamLocation>^DHCDocCureQueueStatusS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
