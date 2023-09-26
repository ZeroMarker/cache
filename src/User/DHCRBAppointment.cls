Class User.DHCRBAppointment Extends %Persistent [ ClassType = persistent, ProcedureBlock, SqlRowIdName = APPT_RowId, SqlTableName = DHC_RBAppointment, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On (APPTASParRef, APPTASChildsub, APPTChildsub) [ IdKey, PrimaryKey, Unique ];

/// APPT_AS_Childsub
Property APPTASChildsub As %Library.Float(MINVAL = 1) [ Required, SqlColumnNumber = 3, SqlFieldName = APPT_AS_Childsub ];

/// APPT_RES_ParRef
Property APPTASParRef As User.RBResource [ SqlColumnNumber = 2, SqlFieldName = APPT_AS_ParRef ];

/// APPT_Childsub
Property APPTChildsub As %Library.Float(MINVAL = 1) [ Required, SqlColumnNumber = 4, SqlFieldName = APPT_Childsub ];

/// APPT_CredNo
Property APPTCredNo As %String(COLLATION = "Exact", MAXLEN = 18, TRUNCATE = 1) [ SqlColumnNumber = 12, SqlFieldName = APPT_CredNo ];

/// Des Ref DHC_CredType
Property APPTCredTypeDR As DHCCredType [ SqlColumnNumber = 11, SqlFieldName = APPT_CredType_DR ];

/// APPT_DOB
Property APPTDOB As %Date [ SqlColumnNumber = 6, SqlFieldName = APPT_DOB ];

/// APPT_MobilePhone
Property APPTMobilePhone As %String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 1) [ SqlColumnNumber = 9, SqlFieldName = APPT_MobilePhone ];

/// APPT_PatientName
Property APPTPatientName As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = APPT_PatientName ];

/// APPT_PinCode
Property APPTPinCode As %String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 1) [ SqlColumnNumber = 10, SqlFieldName = APPT_PinCode ];

/// APPT_Sex_DR
Property APPTSexDR As CTSex [ SqlColumnNumber = 7, SqlFieldName = APPT_Sex_DR ];

/// APPT_TelH
Property APPTTelH As %String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 1) [ SqlColumnNumber = 8, SqlFieldName = APPT_TelH ];

/// APPT_ArriveLaterFlag
Property APPTArriveLaterFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 13, SqlFieldName = APPT_ArriveLaterFlag ];

/// APPT_PatientAddress
Property APPTPatientAddress As %String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 1) [ SqlColumnNumber = 14, SqlFieldName = APPT_PatientAddress ];

/// APPT_VIPNo
Property APPTVIPNo As %String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 1) [ SqlColumnNumber = 15, SqlFieldName = APPT_VIPNo ];

/// APPT_VIPNo
Property APPTLockQueueNo As %String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 1) [ SqlColumnNumber = 16, SqlFieldName = APPT_LockQueueNo ];

/// APPT_CardNo 	;预约卡号,外部预约时记录预约卡号
Property APPTCardNo As %String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 1) [ SqlColumnNumber = 17, SqlFieldName = APPT_CardNo ];

/// APPT_TimeRange 	;预约时段串,eg:08:00-09:00
Property APPTTimeRange As %String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 1) [ SqlColumnNumber = 18, SqlFieldName = APPT_TimeRange ];

/// APPT_APPTPatType
Property APPTPatType As %String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 1) [ SqlColumnNumber = 19, SqlFieldName = APPT_PatType ];

/// 预约验证码\取号码
Property APPTVerifyCode As %String(COLLATION = "Exact", MAXLEN = 1000, TRUNCATE = 1) [ SqlColumnNumber = 20, SqlFieldName = APPT_VerifyCode ];

/// 替诊前的预约ID
Property APPTRBAppointmentDR As User.DHCRBAppointment [ SqlColumnNumber = 21, SqlFieldName = APPT_RBAppointmentDR ];

/// 亚专业
Property APPTClinicGroupDr As User.RBCClinicGroup [ SqlColumnNumber = 22, SqlFieldName = APPT_ClinicGroupDr ];

/// 联合门诊主号别预约记录关联
Property APPTUniteMainApptDR As User.DHCRBAppointment [ SqlColumnNumber = 23, SqlFieldName = APPT_UniteMainApptDR ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMaster">
<Data name="APPT_ArriveLaterFlag">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>9</Piece>
</Data>
<Data name="APPT_CardNo">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>13</Piece>
</Data>
<Data name="APPT_ClinicGroupDr">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>18</Piece>
</Data>
<Data name="APPT_CredNo">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>8</Piece>
</Data>
<Data name="APPT_CredType_DR">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>7</Piece>
</Data>
<Data name="APPT_DOB">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>2</Piece>
</Data>
<Data name="APPT_LockQueueNo">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>12</Piece>
</Data>
<Data name="APPT_MobilePhone">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>5</Piece>
</Data>
<Data name="APPT_PatType">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>15</Piece>
</Data>
<Data name="APPT_PatientAddress">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>10</Piece>
</Data>
<Data name="APPT_PatientName">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>1</Piece>
</Data>
<Data name="APPT_PinCode">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>6</Piece>
</Data>
<Data name="APPT_RBAppointmentDR">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>17</Piece>
</Data>
<Data name="APPT_Sex_DR">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>3</Piece>
</Data>
<Data name="APPT_TelH">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>4</Piece>
</Data>
<Data name="APPT_TimeRange">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>14</Piece>
</Data>
<Data name="APPT_UniteMainApptDR">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>19</Piece>
</Data>
<Data name="APPT_VIPNo">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>11</Piece>
</Data>
<Data name="APPT_VerifyCode">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>16</Piece>
</Data>
<Global>^RBAS</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>APPT_AS_ParRef</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L2}</Expression>
<Field>APPT_AS_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L4}</Expression>
<Field>APPT_Childsub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{APPT_AS_ParRef}</Expression>
</Subscript>
<Subscript name="2">
<Expression>{APPT_AS_Childsub}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"APPT"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{APPT_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCredNo">
<Global>^RBAS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>APPT_AS_ParRef</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>APPT_AS_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L6}</Expression>
<Field>APPT_Childsub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"CredNo"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{APPT_CredNo}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{APPT_AS_ParRef}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{APPT_AS_Childsub}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{APPT_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexMobilePhone">
<Global>^RBAS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>APPT_AS_ParRef</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>APPT_AS_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L6}</Expression>
<Field>APPT_Childsub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"MobilePhone"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{APPT_MobilePhone}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{APPT_AS_ParRef}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{APPT_AS_Childsub}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{APPT_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexTelH">
<Global>^RBAS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>APPT_AS_ParRef</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>APPT_AS_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L6}</Expression>
<Field>APPT_Childsub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"TelH"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{APPT_TelH}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{APPT_AS_ParRef}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{APPT_AS_Childsub}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{APPT_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexUniteMain">
<Global>^RBAS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>APPT_AS_ParRef</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>APPT_AS_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L6}</Expression>
<Field>APPT_Childsub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"UniteMain"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{APPT_UniteMainApptDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{APPT_AS_ParRef}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{APPT_AS_Childsub}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{APPT_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexVIPNo">
<Global>^RBAS</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>APPT_AS_ParRef</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>APPT_AS_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L6}</Expression>
<Field>APPT_Childsub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"VIPNo"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{APPT_VIPNo}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{APPT_AS_ParRef}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{APPT_AS_Childsub}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{APPT_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>APTT_RowId</SqlRowIdName>
<StreamLocation>^User.DHCRBAppointmentS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
