/// 住院证状态流水表，记录住院证状态变更流水
Class User.DHCMedIPBKStates Extends %Persistent [ ClassType = persistent, Not ProcedureBlock, SqlTableName = DHC_MedIPBKStates, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 10000000;

/// 住院证ID 指向DHC_MedIPBooking
Property BookID As DHCMedIPBooking [ SqlColumnNumber = 2, SqlFieldName = BookID ];

/// 当前状态ID 指向DHC_MedDictory
Property StateID As DHCMedDictory [ SqlColumnNumber = 3, SqlFieldName = StateID ];

/// 操作员ID 指向SS_User
Property ChangeUserID As SSUser [ SqlColumnNumber = 4, SqlFieldName = ChangeUserID ];

/// 操作日期
Property ChangeDate As %Date [ SqlColumnNumber = 5, SqlFieldName = ChangeDate ];

/// 操作时间
Property ChangeTime As %Time [ SqlColumnNumber = 6, SqlFieldName = ChangeTime ];

/// 操作原因ID 指向DHC_MedDictory
Property ReasonID As DHCMedDictory [ SqlColumnNumber = 7, SqlFieldName = ReasonID ];

/// 备注
Property ResumeText As %String(COLLATION = "EXACT", MAXLEN = 100, TRUNCATE = 1) [ SqlColumnNumber = 8, SqlFieldName = ResumeText ];

/// SQL存储结构
Storage SQLStorage
{
<Description>
<![CDATA[SQL存储结构]]></Description>
<ExtentSize>10000000</ExtentSize>
<SqlIdExpression>$i(^DHCMedIPBKS(0))</SqlIdExpression>
<SQLMap name="DataMasterMap">
<ConditionalWithHostVars></ConditionalWithHostVars>
<Data name="BookID">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ChangeDate">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="ChangeTime">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="ChangeUserID">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="ReasonID">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="ResumeText">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="StateID">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCMedIPBKS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>RowID</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexBookID">
<ConditionalWithHostVars></ConditionalWithHostVars>
<Global>^DHCMedIPBKS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>RowID</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"BookID"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{BookID}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexChangeDateTimeState">
<ConditionalWithHostVars></ConditionalWithHostVars>
<Global>^DHCMedIPBKS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>RowID</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"ChangeDateTimeState"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{ChangeDate}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{ChangeTime}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>Sub</AccessType>
<Expression>{StateID}</Expression>
</Subscript>
<Subscript name="6">
<AccessType>Sub</AccessType>
<Expression>{RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>RowID</SqlRowIdName>
<StreamLocation>^User.DHCMedIPBKStatesS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
