/// 描述:组织职务
/// 创建人：基础数据平台 陈莹
/// 创建日期：2022-09-23
Class CT.BDP.CT.HOSProfTitle Extends (%Persistent, User.Abstract) [ SqlTableName = HOS_ProfTitle ]
{

/// 职务代码
Property PROFTCode As %String(MAXLEN = 200, TRUNCATE = 1) [ Required, SqlColumnNumber = 2, SqlFieldName = PROFT_Code ];

/// 职务名称
Property PROFTDesc As %String(MAXLEN = 200, TRUNCATE = 1) [ Required, SqlColumnNumber = 3, SqlFieldName = PROFT_Desc ];

/// 所属部门
Property PROFTDeptCode As CT.BDP.CT.HOSDepartment [ Required, SqlColumnNumber = 4, SqlFieldName = PROFT_DeptCode ];

/// 职务字典编码
Property PROFTPROFTCCode As CT.BDP.CT.HOSProfTitleDict [ Required, SqlColumnNumber = 5, SqlFieldName = PROFT_PROFTC_Code ];

/// 额定人数
Property PROFTLimitedNum As %String [ SqlColumnNumber = 6, SqlFieldName = PROFT_LimitedNum ];

/// 是否有效(Y/N)
Property PROFTActivity As %String [ InitialExpression = "Y", SqlColumnNumber = 7, SqlFieldName = PROFT_Activity ];

/// 开始日期
Property PROFTStartDate As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 8, SqlFieldName = PROFT_StartDate ];

/// 结束日期
Property PROFTEndDate As %Date [ SqlColumnNumber = 9, SqlFieldName = PROFT_EndDate ];

/// 系统创建日期
Property PROFTCreateDate As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 10, SqlFieldName = PROFT_CreateDate ];

/// 系统创建时间
Property PROFTCreateTime As %Time [ InitialExpression = {$p($h,",",2)}, SqlColumnNumber = 11, SqlFieldName = PROFT_CreateTime ];

/// 系统创建人
Property PROFTCreateUser As User.SSUser [ SqlColumnNumber = 12, SqlFieldName = PROFT_CreateUser ];

/// 系统排序号
Property PROFTSeqNo As %Float [ SqlColumnNumber = 13, SqlFieldName = PROFT_SeqNo ];

/// 系统最后更新日期
Property PROFTLastUpdateDate As %Date [ SqlColumnNumber = 14, SqlFieldName = PROFT_LastUpdateDate ];

/// 系统最后更新时间
Property PROFTLastUpdateTime As %Time [ SqlColumnNumber = 15, SqlFieldName = PROFT_LastUpdateTime ];

/// 系统最新更新人
Property PROFTLastUpdateUser As User.SSUser [ SqlColumnNumber = 16, SqlFieldName = PROFT_LastUpdateUser ];

/// 拼音码
Property PROFTPYCode As %String(MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 17, SqlFieldName = PROFT_PYCode ];

/// 五笔码
Property PROFTWBCode As %String(MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 18, SqlFieldName = PROFT_WBCode ];

/// 备注
Property PROFTMark As %String(MAXLEN = 500, TRUNCATE = 1) [ SqlColumnNumber = 19, SqlFieldName = PROFT_Mark ];

/// 索引-代码
Index IndexCode On PROFTCode [ Unique ];

/// 索引-名称
Index IndexDesc On PROFTDesc [ Unique ];

/// 索引-系统排序号
Index IndexSeqNo On PROFTSeqNo;

/// 索引-所属部门
Index IndexDeptCode On PROFTDeptCode;

/// 索引-职务字典
Index IndexPROFTCCode On PROFTPROFTCCode;

Storage Default
{
<Data name="HOSProfTitleDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>PROFTCode</Value>
</Value>
<Value name="3">
<Value>PROFTDesc</Value>
</Value>
<Value name="4">
<Value>PROFTDeptCode</Value>
</Value>
<Value name="5">
<Value>PROFTPROFTCCode</Value>
</Value>
<Value name="6">
<Value>PROFTLimitedNum</Value>
</Value>
<Value name="7">
<Value>PROFTActivity</Value>
</Value>
<Value name="8">
<Value>PROFTStartDate</Value>
</Value>
<Value name="9">
<Value>PROFTEndDate</Value>
</Value>
<Value name="10">
<Value>PROFTCreateDate</Value>
</Value>
<Value name="11">
<Value>PROFTCreateTime</Value>
</Value>
<Value name="12">
<Value>PROFTCreateUser</Value>
</Value>
<Value name="13">
<Value>PROFTSeqNo</Value>
</Value>
<Value name="14">
<Value>PROFTLastUpdateDate</Value>
</Value>
<Value name="15">
<Value>PROFTLastUpdateTime</Value>
</Value>
<Value name="16">
<Value>PROFTLastUpdateUser</Value>
</Value>
<Value name="17">
<Value>PROFTPYCode</Value>
</Value>
<Value name="18">
<Value>PROFTWBCode</Value>
</Value>
<Value name="19">
<Value>PROFTMark</Value>
</Value>
</Data>
<DataLocation>^CT.BDP.CT.HOSProfTitleD</DataLocation>
<DefaultData>HOSProfTitleDefaultData</DefaultData>
<IdLocation>^CT.BDP.CT.HOSProfTitleD</IdLocation>
<IndexLocation>^CT.BDP.CT.HOSProfTitleI</IndexLocation>
<StreamLocation>^CT.BDP.CT.HOSProfTitleS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
