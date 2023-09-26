/// 描述:人员职位表
/// 创建人：基础数据平台 陈莹
/// 创建日期：2022-09-23
Class CT.BDP.CT.HOSEmpPostion Extends (%Persistent, User.Abstract) [ SqlTableName = HOS_EmpPostion ]
{

/// 人员唯一标识码
Property EMPPOSPAPersonID As CT.BDP.CT.HOSPerson [ Required, SqlColumnNumber = 2, SqlFieldName = EMPPOS_PAPersonID ];

/// 组织部门代码
Property EMPPOSDeptCode As CT.BDP.CT.HOSDepartment [ Required, SqlColumnNumber = 3, SqlFieldName = EMPPOS_DeptCode ];

/// 职位代码
Property EMPPOSPOSCode As CT.BDP.CT.HOSPosition [ Required, SqlColumnNumber = 4, SqlFieldName = EMPPOS_POSCode ];

/// 任职日期
Property EMPPOSAppointDate As %Date [ SqlColumnNumber = 5, SqlFieldName = EMPPOS_AppointDate ];

/// 免职日期
Property EMPPOSRemoveDate As %Date [ SqlColumnNumber = 6, SqlFieldName = EMPPOS_RemoveDate ];

/// 任职状态 是否在职
Property EMPPOSStatus As %String [ InitialExpression = "Y", SqlColumnNumber = 7, SqlFieldName = EMPPOS_Status ];

/// 是否行政归属部门
Property EMPPOSAdminFlag As %String [ SqlColumnNumber = 8, SqlFieldName = EMPPOS_AdminFlag ];

/// 是否有效(Y/N)
Property EMPPOSActivity As %String [ InitialExpression = "Y", SqlColumnNumber = 9, SqlFieldName = EMPPOS_Activity ];

/// 开始日期
Property EMPPOSStartDate As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 10, SqlFieldName = EMPPOS_StartDate ];

/// 结束日期
Property EMPPOSEndDate As %Date [ SqlColumnNumber = 11, SqlFieldName = EMPPOS_EndDate ];

/// 系统创建日期
Property EMPPOSCreateDate As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 12, SqlFieldName = EMPPOS_CreateDate ];

/// 系统创建时间
Property EMPPOSCreateTime As %Time [ InitialExpression = {$p($h,",",2)}, SqlColumnNumber = 13, SqlFieldName = EMPPOS_CreateTime ];

/// 系统创建人
Property EMPPOSCreateUser As User.SSUser [ SqlColumnNumber = 14, SqlFieldName = EMPPOS_CreateUser ];

/// 系统排序号
Property EMPPOSSeqNo As %Float [ SqlColumnNumber = 15, SqlFieldName = EMPPOS_SeqNo ];

/// 系统最后更新日期
Property EMPPOSLastUpdateDate As %Date [ SqlColumnNumber = 16, SqlFieldName = EMPPOS_LastUpdateDate ];

/// 系统最后更新时间
Property EMPPOSLastUpdateTime As %Time [ SqlColumnNumber = 17, SqlFieldName = EMPPOS_LastUpdateTime ];

/// 系统最新更新人
Property EMPPOSLastUpdateUser As User.SSUser [ SqlColumnNumber = 18, SqlFieldName = EMPPOS_LastUpdateUser ];

/// 拼音码
Property EMPPOSPYCode As %String(MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 19, SqlFieldName = EMPPOS_PYCode ];

/// 五笔码
Property EMPPOSWBCode As %String(MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 20, SqlFieldName = EMPPOS_WBCode ];

/// 备注
Property EMPPOSMark As %String(MAXLEN = 500, TRUNCATE = 1) [ SqlColumnNumber = 21, SqlFieldName = EMPPOS_Mark ];

/// 索引-人员唯一标识码+组织部门代码+职位代码
Index IndexCode On (EMPPOSPAPersonID, EMPPOSDeptCode, EMPPOSPOSCode) [ Unique ];

/// 索引-人员唯一标识码
Index IndexPAPersonID On EMPPOSPAPersonID;

/// 索引-组织部门代码
Index IndexDeptCode On EMPPOSDeptCode;

/// 索引-职位代码
Index IndexPOSCode On EMPPOSPOSCode;

/// 索引-系统排序号
Index IndexSeqNo On EMPPOSSeqNo;

Storage Default
{
<Data name="HOSEmpPostionDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>EMPPOSPAPersonID</Value>
</Value>
<Value name="3">
<Value>EMPPOSDeptCode</Value>
</Value>
<Value name="4">
<Value>EMPPOSPOSCode</Value>
</Value>
<Value name="5">
<Value>EMPPOSAppointDate</Value>
</Value>
<Value name="6">
<Value>EMPPOSRemoveDate</Value>
</Value>
<Value name="7">
<Value>EMPPOSStatus</Value>
</Value>
<Value name="8">
<Value>EMPPOSAdminFlag</Value>
</Value>
<Value name="9">
<Value>EMPPOSActivity</Value>
</Value>
<Value name="10">
<Value>EMPPOSStartDate</Value>
</Value>
<Value name="11">
<Value>EMPPOSEndDate</Value>
</Value>
<Value name="12">
<Value>EMPPOSCreateDate</Value>
</Value>
<Value name="13">
<Value>EMPPOSCreateTime</Value>
</Value>
<Value name="14">
<Value>EMPPOSCreateUser</Value>
</Value>
<Value name="15">
<Value>EMPPOSSeqNo</Value>
</Value>
<Value name="16">
<Value>EMPPOSLastUpdateDate</Value>
</Value>
<Value name="17">
<Value>EMPPOSLastUpdateTime</Value>
</Value>
<Value name="18">
<Value>EMPPOSLastUpdateUser</Value>
</Value>
<Value name="19">
<Value>EMPPOSPYCode</Value>
</Value>
<Value name="20">
<Value>EMPPOSWBCode</Value>
</Value>
<Value name="21">
<Value>EMPPOSMark</Value>
</Value>
</Data>
<DataLocation>^CT.BDP.CT.HOSEmpPostionD</DataLocation>
<DefaultData>HOSEmpPostionDefaultData</DefaultData>
<IdLocation>^CT.BDP.CT.HOSEmpPostionD</IdLocation>
<IndexLocation>^CT.BDP.CT.HOSEmpPostionI</IndexLocation>
<StreamLocation>^CT.BDP.CT.HOSEmpPostionS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
