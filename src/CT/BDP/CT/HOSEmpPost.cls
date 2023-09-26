/// 描述:人员岗位表
/// 创建人：基础数据平台 陈莹
/// 创建日期：2022-09-23
Class CT.BDP.CT.HOSEmpPost Extends (%Persistent, User.Abstract) [ SqlTableName = HOS_EmpPost ]
{

/// 人员唯一标识码
Property EMPPOSTPAPersonID As CT.BDP.CT.HOSPerson [ Required, SqlColumnNumber = 2, SqlFieldName = EMPPOST_PAPersonID ];

/// 组织部门代码
Property EMPPOSTDeptCode As CT.BDP.CT.HOSDepartment [ Required, SqlColumnNumber = 3, SqlFieldName = EMPPOST_DeptCode ];

/// 岗位代码
Property EMPPOSTPOSTCode As CT.BDP.CT.HOSPost [ Required, SqlColumnNumber = 4, SqlFieldName = EMPPOST_POSTCode ];

/// 上岗日期
Property EMPPOSTBeginDate As %Date [ SqlColumnNumber = 5, SqlFieldName = EMPPOST_BeginDate ];

/// 下岗日期
Property EMPPOSTRemoveDate As %Date [ SqlColumnNumber = 6, SqlFieldName = EMPPOST_RemoveDate ];

/// 状态 是否在岗
Property EMPPOSTStatus As %String [ InitialExpression = "Y", SqlColumnNumber = 7, SqlFieldName = EMPPOST_Status ];

/// 是否默认岗位
Property EMPPOSTDefaultFlag As %String [ InitialExpression = "Y", SqlColumnNumber = 8, SqlFieldName = EMPPOST_DefaultFlag ];

/// 是否有效(Y/N)
Property EMPPOSTActivity As %String [ InitialExpression = "Y", SqlColumnNumber = 9, SqlFieldName = EMPPOST_Activity ];

/// 开始日期
Property EMPPOSTStartDate As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 10, SqlFieldName = EMPPOST_StartDate ];

/// 结束日期
Property EMPPOSTEndDate As %Date [ SqlColumnNumber = 11, SqlFieldName = EMPPOST_EndDate ];

/// 系统创建日期
Property EMPPOSTCreateDate As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 12, SqlFieldName = EMPPOST_CreateDate ];

/// 系统创建时间
Property EMPPOSTCreateTime As %Time [ InitialExpression = {$p($h,",",2)}, SqlColumnNumber = 13, SqlFieldName = EMPPOST_CreateTime ];

/// 系统创建人
Property EMPPOSTCreateUser As User.SSUser [ SqlColumnNumber = 14, SqlFieldName = EMPPOST_CreateUser ];

/// 系统排序号
Property EMPPOSTSeqNo As %Float [ SqlColumnNumber = 15, SqlFieldName = EMPPOST_SeqNo ];

/// 系统最后更新日期
Property EMPPOSTLastUpdateDate As %Date [ SqlColumnNumber = 16, SqlFieldName = EMPPOST_LastUpdateDate ];

/// 系统最后更新时间
Property EMPPOSTLastUpdateTime As %Time [ SqlColumnNumber = 17, SqlFieldName = EMPPOST_LastUpdateTime ];

/// 系统最新更新人
Property EMPPOSTLastUpdateUser As User.SSUser [ SqlColumnNumber = 18, SqlFieldName = EMPPOST_LastUpdateUser ];

/// 拼音码
Property EMPPOSTPYCode As %String(MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 19, SqlFieldName = EMPPOST_PYCode ];

/// 五笔码
Property EMPPOSTWBCode As %String(MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 20, SqlFieldName = EMPPOST_WBCode ];

/// 备注
Property EMPPOSTMark As %String(MAXLEN = 500, TRUNCATE = 1) [ SqlColumnNumber = 21, SqlFieldName = EMPPOST_Mark ];

/// 索引-人员唯一标识码+组织部门代码+职位代码
Index IndexCode On (EMPPOSTPAPersonID, EMPPOSTDeptCode, EMPPOSTPOSTCode) [ Unique ];

/// 索引-人员唯一标识码
Index IndexPAPersonID On EMPPOSTPAPersonID;

/// 索引-组织部门代码
Index IndexDeptCode On EMPPOSTDeptCode;

/// 索引-岗位代码
Index IndexPOSCode On EMPPOSTPOSTCode;

/// 索引-系统排序号
Index IndexSeqNo On EMPPOSTSeqNo;

Storage Default
{
<Data name="HOSEmpPostDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>EMPPOSTPAPersonID</Value>
</Value>
<Value name="3">
<Value>EMPPOSTDeptCode</Value>
</Value>
<Value name="4">
<Value>EMPPOSTPOSTCode</Value>
</Value>
<Value name="5">
<Value>EMPPOSTBeginDate</Value>
</Value>
<Value name="6">
<Value>EMPPOSTRemoveDate</Value>
</Value>
<Value name="7">
<Value>EMPPOSTStatus</Value>
</Value>
<Value name="8">
<Value>EMPPOSTDefaultFlag</Value>
</Value>
<Value name="9">
<Value>EMPPOSTActivity</Value>
</Value>
<Value name="10">
<Value>EMPPOSTStartDate</Value>
</Value>
<Value name="11">
<Value>EMPPOSTEndDate</Value>
</Value>
<Value name="12">
<Value>EMPPOSTCreateDate</Value>
</Value>
<Value name="13">
<Value>EMPPOSTCreateTime</Value>
</Value>
<Value name="14">
<Value>EMPPOSTCreateUser</Value>
</Value>
<Value name="15">
<Value>EMPPOSTSeqNo</Value>
</Value>
<Value name="16">
<Value>EMPPOSTLastUpdateDate</Value>
</Value>
<Value name="17">
<Value>EMPPOSTLastUpdateTime</Value>
</Value>
<Value name="18">
<Value>EMPPOSTLastUpdateUser</Value>
</Value>
<Value name="19">
<Value>EMPPOSTPYCode</Value>
</Value>
<Value name="20">
<Value>EMPPOSTWBCode</Value>
</Value>
<Value name="21">
<Value>EMPPOSTMark</Value>
</Value>
</Data>
<DataLocation>^CT.BDP.CT.HOSEmpPostD</DataLocation>
<DefaultData>HOSEmpPostDefaultData</DefaultData>
<IdLocation>^CT.BDP.CT.HOSEmpPostD</IdLocation>
<IndexLocation>^CT.BDP.CT.HOSEmpPostI</IndexLocation>
<StreamLocation>^CT.BDP.CT.HOSEmpPostS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
