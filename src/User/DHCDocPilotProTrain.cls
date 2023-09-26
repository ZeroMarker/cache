Class User.DHCDocPilotProTrain Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PPTRA_RowId, SqlTableName = DHC_DocPilotProTrain, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// 培训主题
Property TRADesc As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = PPTRA_Desc ];

/// 培训类别
Property TRAType As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = PPTRA_Type ];

/// 培训地点
Property TRAAddress As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = PPTRA_Address ];

/// 授课人
Property TRAUser As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = PPTRA_User ];

/// 参加人数
Property TRAPersonNum As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = PPTRA_PersonNum ];

/// 培训开始时间
Property TRASttTime As %Date [ SqlColumnNumber = 7, SqlFieldName = PPTRA_SttTime ];

/// 培训结束时间
Property TRAEndTime As %Date [ SqlColumnNumber = 8, SqlFieldName = PPTRA_EndTime ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCDocPPTRA)</SqlIdExpression>
<SQLMap name="DataMasterMap">
<Data name="PPTRA_Address">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PPTRA_Desc">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PPTRA_EndTime">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="PPTRA_PersonNum">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PPTRA_SttTime">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PPTRA_Type">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PPTRA_User">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^DHCDocPPTRA</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PPTRA_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{PPTRA_RowId}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCDocPilotProTrainS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
