/// 描述:人员职务表
/// 创建人：基础数据平台 陈莹
/// 创建日期：2022-09-23
Class CT.BDP.CT.HOSEmpProfTitle Extends (%Persistent, User.Abstract) [ SqlTableName = HOS_EmpProfTitle ]
{

/// 人员唯一标识码
Property EMPPROFPAPersonID As CT.BDP.CT.HOSPerson [ Required, SqlColumnNumber = 2, SqlFieldName = EMPPROF_PAPersonID ];

/// 组织部门代码
Property EMPPROFDeptCode As CT.BDP.CT.HOSDepartment [ Required, SqlColumnNumber = 3, SqlFieldName = EMPPROF_DeptCode ];

/// 部门职务代码
Property EMPPROFPROFTCode As CT.BDP.CT.HOSProfTitle [ Required, SqlColumnNumber = 4, SqlFieldName = EMPPROF_PROFTCode ];

/// 聘用日期
Property EMPPROFEngageDate As %Date [ SqlColumnNumber = 5, SqlFieldName = EMPPROF_EngageDate ];

/// 解聘日期
Property EMPPROFRemoveDate As %Date [ SqlColumnNumber = 6, SqlFieldName = EMPPROF_RemoveDate ];

/// 任职状态 是否在职
Property EMPPROFStatus As %String [ InitialExpression = "Y", SqlColumnNumber = 7, SqlFieldName = EMPPROF_Status ];

/// 是否有效(Y/N)
Property EMPPROFActivity As %String [ InitialExpression = "Y", SqlColumnNumber = 8, SqlFieldName = EMPPROF_Activity ];

/// 开始日期
Property EMPPROFStartDate As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 9, SqlFieldName = EMPPROF_StartDate ];

/// 结束日期
Property EMPPROFEndDate As %Date [ SqlColumnNumber = 10, SqlFieldName = EMPPROF_EndDate ];

/// 系统创建日期
Property EMPPROFCreateDate As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 11, SqlFieldName = EMPPROF_CreateDate ];

/// 系统创建时间
Property EMPPROFCreateTime As %Time [ InitialExpression = {$p($h,",",2)}, SqlColumnNumber = 12, SqlFieldName = EMPPROF_CreateTime ];

/// 系统创建人
Property EMPPROFCreateUser As User.SSUser [ SqlColumnNumber = 13, SqlFieldName = EMPPROF_CreateUser ];

/// 系统排序号
Property EMPPROFSeqNo As %Float [ SqlColumnNumber = 14, SqlFieldName = EMPPROF_SeqNo ];

/// 系统最后更新日期
Property EMPPROFLastUpdateDate As %Date [ SqlColumnNumber = 15, SqlFieldName = EMPPROF_LastUpdateDate ];

/// 系统最后更新时间
Property EMPPROFLastUpdateTime As %Time [ SqlColumnNumber = 16, SqlFieldName = EMPPROF_LastUpdateTime ];

/// 系统最新更新人
Property EMPPROFLastUpdateUser As User.SSUser [ SqlColumnNumber = 17, SqlFieldName = EMPPROF_LastUpdateUser ];

/// 拼音码
Property EMPPROFPYCode As %String(MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 18, SqlFieldName = EMPPROF_PYCode ];

/// 五笔码
Property EMPPROFWBCode As %String(MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 19, SqlFieldName = EMPPROF_WBCode ];

/// 备注
Property EMPPROFMark As %String(MAXLEN = 500, TRUNCATE = 1) [ SqlColumnNumber = 20, SqlFieldName = EMPPROF_Mark ];

/// 索引-人员唯一标识码+组织部门代码+职位代码
Index IndexCode On (EMPPROFPAPersonID, EMPPROFDeptCode, EMPPROFPROFTCode) [ Unique ];

/// 索引-人员唯一标识码
Index IndexPAPersonID On EMPPROFPAPersonID;

/// 索引-组织部门代码
Index IndexDeptCode On EMPPROFDeptCode;

/// 索引-部门职务代码
Index IndexPOSCode On EMPPROFPROFTCode;

/// 索引-系统排序号
Index IndexSeqNo On EMPPROFSeqNo;

Storage Default
{
<Data name="HOSEmpProfTitleDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>EMPPROFPAPersonID</Value>
</Value>
<Value name="3">
<Value>EMPPROFDeptCode</Value>
</Value>
<Value name="4">
<Value>EMPPROFPROFTCode</Value>
</Value>
<Value name="5">
<Value>EMPPROFEngageDate</Value>
</Value>
<Value name="6">
<Value>EMPPROFRemoveDate</Value>
</Value>
<Value name="7">
<Value>EMPPROFStatus</Value>
</Value>
<Value name="8">
<Value>EMPPROFActivity</Value>
</Value>
<Value name="9">
<Value>EMPPROFStartDate</Value>
</Value>
<Value name="10">
<Value>EMPPROFEndDate</Value>
</Value>
<Value name="11">
<Value>EMPPROFCreateDate</Value>
</Value>
<Value name="12">
<Value>EMPPROFCreateTime</Value>
</Value>
<Value name="13">
<Value>EMPPROFCreateUser</Value>
</Value>
<Value name="14">
<Value>EMPPROFSeqNo</Value>
</Value>
<Value name="15">
<Value>EMPPROFLastUpdateDate</Value>
</Value>
<Value name="16">
<Value>EMPPROFLastUpdateTime</Value>
</Value>
<Value name="17">
<Value>EMPPROFLastUpdateUser</Value>
</Value>
<Value name="18">
<Value>EMPPROFPYCode</Value>
</Value>
<Value name="19">
<Value>EMPPROFWBCode</Value>
</Value>
<Value name="20">
<Value>EMPPROFMark</Value>
</Value>
</Data>
<DataLocation>^CT.BDP.CT.HOSEmpProfTitleD</DataLocation>
<DefaultData>HOSEmpProfTitleDefaultData</DefaultData>
<IdLocation>^CT.BDP.CT.HOSEmpProfTitleD</IdLocation>
<IndexLocation>^CT.BDP.CT.HOSEmpProfTitleI</IndexLocation>
<StreamLocation>^CT.BDP.CT.HOSEmpProfTitleS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
