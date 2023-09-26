/// 描述:组织部门表
/// 创建人：基础数据平台 zrf
/// 创建日期：2023-2-2
Class CT.BDP.CT.HOSDepartment Extends (%Persistent, User.Abstract) [ SqlTableName = HOS_Department ]
{

/// 部门代码
Property DEPTCode As %String(MAXLEN = 200, TRUNCATE = 1) [ Required, SqlColumnNumber = 2, SqlFieldName = DEPT_Code ];

/// 部门名称
Property DEPTDesc As %String(MAXLEN = 200, TRUNCATE = 1) [ Required, SqlColumnNumber = 3, SqlFieldName = DEPT_Desc ];

/// 部门简称
Property DEPTAbbrev As %String(MAXLEN = 500, TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = DEPT_Abbrev ];

/// 部门简介
Property DEPTIntro As %String(MAXLEN = 500, TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = DEPT_Intro ];

/// 上级部门
Property DEPTDeptCode As CT.BDP.CT.HOSDepartment [ SqlColumnNumber = 6, SqlFieldName = DEPT_DeptCode ];

/// 所属机构
Property DEPTORGCode As CT.BDP.CT.HOSOrganization [ SqlColumnNumber = 7, SqlFieldName = DEPT_ORGCode ];

/// 行政类型
Property DEPTORGACCode As CT.BDP.CT.HOSOrgAdminType [ SqlColumnNumber = 8, SqlFieldName = DEPT_ORGACCode ];

/// 部门地址（位置）
Property DEPTAddress As %String(MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 9, SqlFieldName = DEPT_Address ];

/// 联系电话	
Property DEPTTel As %String(MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 10, SqlFieldName = DEPT_Tel ];

/// 传真
Property DEPTFax As %String(MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 11, SqlFieldName = DEPT_Fax ];

/// 邮件
Property DEPTEmail As %String(MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 12, SqlFieldName = DEPT_Email ];

/// 建立日期
Property DEPTFoundDate As %String(MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 13, SqlFieldName = DEPT_FoundDate ];

/// 注销日期
Property DEPTCancelDate As %String(MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 14, SqlFieldName = DEPT_CancelDate ];

/// 是否有效(Y/N)
Property DEPTActivity As %String [ InitialExpression = "Y", SqlColumnNumber = 15, SqlFieldName = DEPT_Activity ];

/// 开始日期
Property DEPTStartDate As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 16, SqlFieldName = DEPT_StartDate ];

/// 结束日期
Property DEPTEndDate As %Date [ SqlColumnNumber = 17, SqlFieldName = DEPT_EndDate ];

/// 系统创建日期
Property DEPTCreateDate As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 18, SqlFieldName = DEPT_CreateDate ];

/// 系统创建时间
Property DEPTCreateTime As %Time [ InitialExpression = {$p($h,",",2)}, SqlColumnNumber = 19, SqlFieldName = DEPT_CreateTime ];

/// 系统创建人
Property DEPTCreateUser As User.SSUser [ SqlColumnNumber = 20, SqlFieldName = DEPT_CreateUser ];

/// 系统排序号
Property DEPTSeqNo As %Float [ SqlColumnNumber = 21, SqlFieldName = DEPT_SeqNo ];

/// 系统最后更新日期
Property DEPTLastUpdateDate As %Date [ SqlColumnNumber = 22, SqlFieldName = DEPT_LastUpdateDate ];

/// 系统最后更新时间
Property DEPTLastUpdateTime As %Time [ SqlColumnNumber = 23, SqlFieldName = DEPT_LastUpdateTime ];

/// 系统最新更新人
Property DEPTLastUpdateUser As User.SSUser [ SqlColumnNumber = 24, SqlFieldName = DEPT_LastUpdateUser ];

/// 拼音码
Property DEPTPYCode As %String(MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 25, SqlFieldName = DEPT_PYCode ];

/// 五笔码
Property DEPTWBCode As %String(MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 26, SqlFieldName = DEPT_WBCode ];

/// 备注
Property DEPTMark As %String(MAXLEN = 500, TRUNCATE = 1) [ SqlColumnNumber = 27, SqlFieldName = DEPT_Mark ];

/// 索引-代码
Index IndexCode On DEPTCode;

/// 索引-名称
Index IndexDesc On DEPTDesc;

/// 索引-系统排序号
Index IndexSeqNo On DEPTSeqNo;

/// 索引-上级部门-外键
Index IndexDeptCode On DEPTDeptCode As Exact;

/// 索引-所属机构
Index IndexORGCode On DEPTORGCode;

/// 索引-行政类型
Index IndexORGACCode On DEPTORGACCode;

/// 索引-上级部门、代码
Index IndexLevelCode On (DEPTDeptCode, DEPTCode As Exact);

/// 索引-上级部门、描述
Index IndexLevelDesc On (DEPTDeptCode, DEPTDesc As Exact);

Storage Default
{
<Data name="HOSDepartmentDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DEPTCode</Value>
</Value>
<Value name="3">
<Value>DEPTDesc</Value>
</Value>
<Value name="4">
<Value>DEPTAbbrev</Value>
</Value>
<Value name="5">
<Value>DEPTIntro</Value>
</Value>
<Value name="6">
<Value>DEPTDeptCode</Value>
</Value>
<Value name="7">
<Value>DEPTORGCode</Value>
</Value>
<Value name="8">
<Value>DEPTORGACCode</Value>
</Value>
<Value name="9">
<Value>DEPTAddress</Value>
</Value>
<Value name="10">
<Value>DEPTTel</Value>
</Value>
<Value name="11">
<Value>DEPTFax</Value>
</Value>
<Value name="12">
<Value>DEPTEmail</Value>
</Value>
<Value name="13">
<Value>DEPTFoundDate</Value>
</Value>
<Value name="14">
<Value>DEPTCancelDate</Value>
</Value>
<Value name="15">
<Value>DEPTActivity</Value>
</Value>
<Value name="16">
<Value>DEPTStartDate</Value>
</Value>
<Value name="17">
<Value>DEPTEndDate</Value>
</Value>
<Value name="18">
<Value>DEPTCreateDate</Value>
</Value>
<Value name="19">
<Value>DEPTCreateTime</Value>
</Value>
<Value name="20">
<Value>DEPTCreateUser</Value>
</Value>
<Value name="21">
<Value>DEPTSeqNo</Value>
</Value>
<Value name="22">
<Value>DEPTLastUpdateDate</Value>
</Value>
<Value name="23">
<Value>DEPTLastUpdateTime</Value>
</Value>
<Value name="24">
<Value>DEPTLastUpdateUser</Value>
</Value>
<Value name="25">
<Value>DEPTPYCode</Value>
</Value>
<Value name="26">
<Value>DEPTWBCode</Value>
</Value>
<Value name="27">
<Value>DEPTMark</Value>
</Value>
</Data>
<DataLocation>^CT.BDP.CT.HOSDepartmentD</DataLocation>
<DefaultData>HOSDepartmentDefaultData</DefaultData>
<IdLocation>^CT.BDP.CT.HOSDepartmentD</IdLocation>
<IndexLocation>^CT.BDP.CT.HOSDepartmentI</IndexLocation>
<StreamLocation>^CT.BDP.CT.HOSDepartmentS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
