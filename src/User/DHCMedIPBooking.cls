/// 住院证表，记录住院证内容
Class User.DHCMedIPBooking Extends %Persistent [ ClassType = persistent, Not ProcedureBlock, SqlTableName = DHC_MedIPBooking, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 10000000;

/// PA_PatMas.RowID
Property PatientID As PAPatMas [ SqlColumnNumber = 2, SqlFieldName = PatientID ];

/// 门诊就诊PAADM  指向PA_ADM
Property EpisodeIDFrom As PAAdm [ SqlColumnNumber = 3, SqlFieldName = EpisodeIDFrom ];

/// 住院就诊PAADM  指向PA_ADM
Property EpisodeIDTo As PAAdm [ SqlColumnNumber = 4, SqlFieldName = EpisodeIDTo ];

/// 建住院证日期
Property CreateDate As %Date [ SqlColumnNumber = 5, SqlFieldName = CreateDate ];

/// 建住院证时间
Property CreateTime As %Time [ SqlColumnNumber = 6, SqlFieldName = CreateTime ];

/// 建住院证操作员ID 指向SS_User
Property CreateUserID As SSUser [ SqlColumnNumber = 7, SqlFieldName = CreateUserID ];

/// 建住院证医师ID 指向SS_User
Property CreateDocID As SSUser [ SqlColumnNumber = 8, SqlFieldName = CreateDocID ];

/// 当前状态ID 指向DHC_MedDictory
Property CurrentStateID As DHCMedDictory [ SqlColumnNumber = 9, SqlFieldName = CurrentStateID ];

/// 有效状态 Yes/No
Property IsActive As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 10, SqlFieldName = IsActive ];

/// 建住院证日期
Property BookingDate As %Date [ SqlColumnNumber = 11, SqlFieldName = BookingDate ];

/// 备用字段1
Property Text1 As %String(COLLATION = "EXACT", MAXLEN = 50, TRUNCATE = 1) [ SqlColumnNumber = 12, SqlFieldName = Text1 ];

/// 备用字段2
Property Text2 As %String(COLLATION = "EXACT", MAXLEN = 50, TRUNCATE = 1) [ SqlColumnNumber = 13, SqlFieldName = Text2 ];

/// 备用字段3
Property Text3 As %String(COLLATION = "EXACT", MAXLEN = 50, TRUNCATE = 1) [ SqlColumnNumber = 14, SqlFieldName = Text3 ];

/// 备用字段4
Property Text4 As %String(COLLATION = "EXACT", MAXLEN = 50, TRUNCATE = 1) [ SqlColumnNumber = 15, SqlFieldName = Text4 ];

/// 备注
Property ResumeText As %String(COLLATION = "EXACT", MAXLEN = 100, TRUNCATE = 1) [ SqlColumnNumber = 16, SqlFieldName = ResumeText ];

/// SQL存储结构
Storage SQLStorage
{
<Description>
<![CDATA[SQL存储结构]]></Description>
<ExtentSize>10000000</ExtentSize>
<SqlIdExpression>$i(^DHCMedIPBK(0))</SqlIdExpression>
<SQLMap name="DataMasterMap">
<ConditionalWithHostVars></ConditionalWithHostVars>
<Data name="BookingDate">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="CreateDate">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="CreateDocID">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="CreateTime">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="CreateUserID">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="CurrentStateID">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="EpisodeIDFrom">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="EpisodeIDTo">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="IsActive">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="PatientID">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ResumeText">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="Text1">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="Text2">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="Text3">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="Text4">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Global>^DHCMedIPBK</Global>
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
<SQLMap name="IndexBookingDate">
<ConditionalWithHostVars></ConditionalWithHostVars>
<Global>^DHCMedIPBK</Global>
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
<Expression>"BookingDate"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{BookingDate}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexCreatDateTimeState">
<ConditionalWithHostVars></ConditionalWithHostVars>
<Global>^DHCMedIPBK</Global>
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
<Expression>"CreateDateTimeState"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{CreateDate}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{CreateTime}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>Sub</AccessType>
<Expression>{CurrentStateID}</Expression>
</Subscript>
<Subscript name="6">
<AccessType>Sub</AccessType>
<Expression>{RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexEpisodeIDFrom">
<ConditionalWithHostVars></ConditionalWithHostVars>
<Global>^DHCMedIPBK</Global>
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
<Expression>"EpisodeIDFrom"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{EpisodeIDFrom}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexEpisodeIDTo">
<ConditionalWithHostVars></ConditionalWithHostVars>
<Global>^DHCMedIPBK</Global>
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
<Expression>"EpisodeIDTo"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{EpisodeIDTo}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPatientID">
<ConditionalWithHostVars></ConditionalWithHostVars>
<Global>^DHCMedIPBK</Global>
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
<Expression>"PatientID"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{PatientID}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>RowID</SqlRowIdName>
<StreamLocation>^User.DHCMedIPBookingS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
