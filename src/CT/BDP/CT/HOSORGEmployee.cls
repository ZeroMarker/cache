/// 描述:组织人员表-组织和人员的关联表
/// 创建人：基础数据平台 陈莹
/// 创建日期：2022-09-22
Class CT.BDP.CT.HOSORGEmployee Extends (%Persistent, User.Abstract) [ SqlTableName = HOS_ORGEmployee ]
{

/// 组织代码
Property EMPORGCode As CT.BDP.CT.HOSOrganization [ Required, SqlColumnNumber = 2, SqlFieldName = EMP_ORGCode ];

/// 人员唯一标识码
Property EMPPAPersonID As CT.BDP.CT.HOSPerson [ Required, SqlColumnNumber = 3, SqlFieldName = EMP_PAPersonID ];

/// 工号
Property EMPPAPersonNo As %String(MAXLEN = 200, TRUNCATE = 1) [ Required, SqlColumnNumber = 4, SqlFieldName = EMP_PAPersonNo ];

/// 入职日期
Property EMPJoinDate As %Date [ SqlColumnNumber = 5, SqlFieldName = EMP_JoinDate ];

/// 工作状态-外键？？
Property EMPStatus As CT.BDP.CT.HOSEmpStatusDict [ SqlColumnNumber = 6, SqlFieldName = EMP_Status ];

/// 离职日期
Property EMPSeparationDate As %Date [ SqlColumnNumber = 7, SqlFieldName = EMP_SeparationDate ];

/// 是否有效(Y/N)
Property EMPActivity As %String [ InitialExpression = "Y", SqlColumnNumber = 8, SqlFieldName = EMP_Activity ];

/// 开始日期
Property EMPStartDate As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 9, SqlFieldName = EMP_StartDate ];

/// 结束日期
Property EMPEndDate As %Date [ SqlColumnNumber = 10, SqlFieldName = EMP_EndDate ];

/// 系统创建日期
Property EMPCreateDate As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 11, SqlFieldName = EMP_CreateDate ];

/// 系统创建时间
Property EMPCreateTime As %Time [ InitialExpression = {$p($h,",",2)}, SqlColumnNumber = 12, SqlFieldName = EMP_CreateTime ];

/// 系统创建人
Property EMPCreateUser As User.SSUser [ SqlColumnNumber = 13, SqlFieldName = EMP_CreateUser ];

/// 系统排序号
Property EMPSeqNo As %Float [ SqlColumnNumber = 14, SqlFieldName = EMP_SeqNo ];

/// 系统最后更新日期
Property EMPLastUpdateDate As %Date [ SqlColumnNumber = 15, SqlFieldName = EMP_LastUpdateDate ];

/// 系统最后更新时间
Property EMPLastUpdateTime As %Time [ SqlColumnNumber = 16, SqlFieldName = EMP_LastUpdateTime ];

/// 系统最新更新人
Property EMPLastUpdateUser As User.SSUser [ SqlColumnNumber = 17, SqlFieldName = EMP_LastUpdateUser ];

/// 拼音码
Property EMPPYCode As %String(MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 18, SqlFieldName = EMP_PYCode ];

/// 五笔码
Property EMPWBCode As %String(MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 19, SqlFieldName = EMP_WBCode ];

/// 备注
Property EMPMark As %String(MAXLEN = 500, TRUNCATE = 1) [ SqlColumnNumber = 20, SqlFieldName = EMP_Mark ];

/// 索引-组织代码
Index IndexORGCode On EMPORGCode;

/// 索引-人员唯一标识码
Index IndexPAPersonID On EMPPAPersonID;

/// 索引-组织代码+人员唯一标识码
Index IndexMain On (EMPORGCode, EMPPAPersonID) [ Unique ];

/// 索引-工作状态
Index IndexStatus On EMPStatus;

/// 索引-系统排序号
Index IndexSeqNo On EMPSeqNo;

Storage Default
{
<Data name="HOSORGEmployeeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>EMPORGCode</Value>
</Value>
<Value name="3">
<Value>EMPPAPersonID</Value>
</Value>
<Value name="4">
<Value>EMPPAPersonNo</Value>
</Value>
<Value name="5">
<Value>EMPJoinDate</Value>
</Value>
<Value name="6">
<Value>EMPStatus</Value>
</Value>
<Value name="7">
<Value>EMPSeparationDate</Value>
</Value>
<Value name="8">
<Value>EMPActivity</Value>
</Value>
<Value name="9">
<Value>EMPStartDate</Value>
</Value>
<Value name="10">
<Value>EMPEndDate</Value>
</Value>
<Value name="11">
<Value>EMPCreateDate</Value>
</Value>
<Value name="12">
<Value>EMPCreateTime</Value>
</Value>
<Value name="13">
<Value>EMPCreateUser</Value>
</Value>
<Value name="14">
<Value>EMPSeqNo</Value>
</Value>
<Value name="15">
<Value>EMPLastUpdateDate</Value>
</Value>
<Value name="16">
<Value>EMPLastUpdateTime</Value>
</Value>
<Value name="17">
<Value>EMPLastUpdateUser</Value>
</Value>
<Value name="18">
<Value>EMPPYCode</Value>
</Value>
<Value name="19">
<Value>EMPWBCode</Value>
</Value>
<Value name="20">
<Value>EMPMark</Value>
</Value>
</Data>
<DataLocation>^CT.BDP.CT.HOSORGEmployeeD</DataLocation>
<DefaultData>HOSORGEmployeeDefaultData</DefaultData>
<IdLocation>^CT.BDP.CT.HOSORGEmployeeD</IdLocation>
<IndexLocation>^CT.BDP.CT.HOSORGEmployeeI</IndexLocation>
<StreamLocation>^CT.BDP.CT.HOSORGEmployeeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
