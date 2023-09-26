Class User.DHCCRMFUPlan Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = FUP_RowId, SqlTableName = DHC_CRM_FUPlan, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// FUP_PAADM_DR
Property FUPPAADMDR As User.PAAdm [ SqlColumnNumber = 2, SqlFieldName = FUP_PAADM_DR ];

/// FUP_Subject_DR
Property FUPSubjectDR As User.DHCCRMFUSubject [ SqlColumnNumber = 3, SqlFieldName = FUP_Subject_DR ];

/// FUP_FUDate 随访日期
Property FUPFUDate As %Library.Date(FORMAT = 4) [ SqlColumnNumber = 4, SqlFieldName = FUP_FUDate ];

/// FUP_FUTime 随访时间
Property FUPFUTime As %Library.Time [ SqlColumnNumber = 5, SqlFieldName = FUP_FUTime ];

/// FUP_FUUser_DR his调查人
Property FUPFUUserDR As User.SSUser [ SqlColumnNumber = 6, SqlFieldName = FUP_FUUser_DR ];

/// FUP_Demo 备注
Property FUPDemo As %Library.String(COLLATION = "Exact", MAXLEN = 500, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = FUP_Demo ];

/// 联系次数
Property FUPContactNum As %Library.Integer [ SqlColumnNumber = 8, SqlFieldName = FUP_ContactNum ];

/// 联系内容
Property FUPContactDesc As %Library.String(COLLATION = "Exact", MAXLEN = 500, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = FUP_ContactDesc ];

/// 死亡情况
Property FUPDeadFlag As %Library.String [ SqlColumnNumber = 10, SqlFieldName = FUP_DeadFlag ];

/// 录音文件
Property FUPRadioFile As %Library.String [ SqlColumnNumber = 11, SqlFieldName = FUP_RadioFile ];

/// 病人类型
Property FUPPatientType As %Library.String [ SqlColumnNumber = 12, SqlFieldName = FUP_PatientType ];

/// 结束时间
Property FUPEndDate As %Library.Date(FORMAT = 4) [ SqlColumnNumber = 13, SqlFieldName = FUP_EndDate ];

/// 调查人
Property FUPUser As %Library.String [ SqlColumnNumber = 14, SqlFieldName = FUP_User ];

/// 联系情况 Z 暂时联系不上 L 联系不上
Property FUPContactInfo As %Library.String [ SqlColumnNumber = 15, SqlFieldName = FUP_ContactInfo ];

/// FUP_FURadioStartTime 录音开始时间
Property FUPFURadioStartTime As %Library.Time [ SqlColumnNumber = 16, SqlFieldName = FUP_FURadioStartTime ];

/// FUP_FURadioEndTime 录音结束时间
Property FUPFURadioEndTime As %Library.Time [ SqlColumnNumber = 17, SqlFieldName = FUP_FURadioEndTime ];

/// FUP_UpdateUser_DR 生成计划人
Property FUPUpdateUserDR As User.SSUser [ SqlColumnNumber = 18, SqlFieldName = FUP_UpdateUser_DR ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCCRMFUP)</SqlIdExpression>
<SQLMap name="DataMasterDHCCRMFUP">
<Data name="FUP_ContactDesc">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="FUP_ContactInfo">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="FUP_ContactNum">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="FUP_DeadFlag">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="FUP_Demo">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="FUP_EndDate">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="FUP_FUDate">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="FUP_FURadioEndTime">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="FUP_FURadioStartTime">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="FUP_FUTime">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="FUP_FUUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="FUP_PAADM_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="FUP_PatientType">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="FUP_RadioFile">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="FUP_Subject_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="FUP_UpdateUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="FUP_User">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Global>^DHCCRMFUP</Global>
<RowIdSpec name="1">
<Field>FUP_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{FUP_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexFUDate">
<Global>^DHCCRMFUP</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>FUP_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"FUP_FUDate"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{FUP_FUDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{FUP_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexFUUser">
<Global>^DHCCRMFUP</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>FUP_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"FUP_FUUser_DR"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{FUP_FUUser_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{FUP_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPAADM">
<Data name="FUP_Demo">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="FUP_FUDate">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="FUP_FUTime">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="FUP_FUUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="FUP_PAADM_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="FUP_Subject_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCCRMFUP</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>FUP_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"FUP_PAADM"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{FUP_PAADM_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{FUP_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPAADMSubject">
<Global>^DHCCRMFUP</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>FUP_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"FUP_PAADMSubject_DR"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{FUP_PAADM_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{FUP_Subject_DR}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>Sub</AccessType>
<Expression>{FUP_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPAADMSubjectDate">
<Global>^DHCCRMFUP</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>FUP_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"FUP_PAADM_Subject_Date"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{FUP_PAADM_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{FUP_Subject_DR}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>Sub</AccessType>
<Expression>{FUP_FUDate}</Expression>
</Subscript>
<Subscript name="6">
<AccessType>Sub</AccessType>
<Expression>{FUP_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexSubject">
<Global>^DHCCRMFUP</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>FUP_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"FUP_Subject_DR"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{FUP_Subject_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{FUP_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCCRMFUPlanS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
