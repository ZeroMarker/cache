/// 描述:组织职位
/// 创建人：基础数据平台 陈莹
/// 创建日期：2022-09-22
Class CT.BDP.CT.HOSPosition Extends (%Persistent, User.Abstract) [ SqlTableName = HOS_Position ]
{

/// 组织职位代码
Property POSCode As %String(MAXLEN = 200, TRUNCATE = 1) [ Required, SqlColumnNumber = 2, SqlFieldName = POS_Code ];

/// 组织职位名称
Property POSDesc As %String(MAXLEN = 200, TRUNCATE = 1) [ Required, SqlColumnNumber = 3, SqlFieldName = POS_Desc ];

/// 所属部门-外键
Property POSDeptCode As CT.BDP.CT.HOSDepartment [ Required, SqlColumnNumber = 4, SqlFieldName = POS_DeptCode ];

/// 职位字典代码-外键
Property POSPOSCCode As CT.BDP.CT.HOSPositionDict [ Required, SqlColumnNumber = 5, SqlFieldName = POS_POSC_Code ];

/// 额定人数
Property POSLimitedNum As %Float [ SqlColumnNumber = 6, SqlFieldName = POS_LimitedNum ];

/// 是否有效(Y/N)
Property POSActivity As %String [ InitialExpression = "Y", SqlColumnNumber = 7, SqlFieldName = POS_Activity ];

/// 开始日期
Property POSStartDate As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 8, SqlFieldName = POS_StartDate ];

/// 结束日期
Property POSEndDate As %Date [ SqlColumnNumber = 9, SqlFieldName = POS_EndDate ];

/// 系统创建日期
Property POSCreateDate As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 10, SqlFieldName = POS_CreateDate ];

/// 系统创建时间
Property POSCreateTime As %Time [ InitialExpression = {$p($h,",",2)}, SqlColumnNumber = 11, SqlFieldName = POS_CreateTime ];

/// 系统创建人
Property POSCreateUser As User.SSUser [ SqlColumnNumber = 12, SqlFieldName = POS_CreateUser ];

/// 系统排序号
Property POSSeqNo As %Float [ SqlColumnNumber = 13, SqlFieldName = POS_SeqNo ];

/// 系统最后更新日期
Property POSLastUpdateDate As %Date [ SqlColumnNumber = 14, SqlFieldName = POS_LastUpdateDate ];

/// 系统最后更新时间
Property POSLastUpdateTime As %Time [ SqlColumnNumber = 15, SqlFieldName = POS_LastUpdateTime ];

/// 系统最新更新人
Property POSLastUpdateUser As User.SSUser [ SqlColumnNumber = 16, SqlFieldName = POS_LastUpdateUser ];

/// 拼音码
Property POSPYCode As %String(MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 17, SqlFieldName = POS_PYCode ];

/// 五笔码
Property POSWBCode As %String(MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 18, SqlFieldName = POS_WBCode ];

/// 备注
Property POSMark As %String(MAXLEN = 500, TRUNCATE = 1) [ SqlColumnNumber = 19, SqlFieldName = POS_Mark ];

/// 索引-组织职位代码
Index IndexCode On POSCode [ Unique ];

/// 索引-组织职位名称
Index IndexDesc On POSDesc [ Unique ];

/// 索引-系统排序号
Index IndexSeqNo On POSSeqNo;

/// 索引-职位字典-外键
Index IndexPOSCCode On POSPOSCCode;

/// 索引-所属部门-外键
Index IndexDeptCode On POSDeptCode;

Storage Default
{
<Data name="HOSPositionDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>POSCode</Value>
</Value>
<Value name="3">
<Value>POSDesc</Value>
</Value>
<Value name="4">
<Value>POSDeptCode</Value>
</Value>
<Value name="5">
<Value>POSPOSCCode</Value>
</Value>
<Value name="6">
<Value>POSLimitedNum</Value>
</Value>
<Value name="7">
<Value>POSActivity</Value>
</Value>
<Value name="8">
<Value>POSStartDate</Value>
</Value>
<Value name="9">
<Value>POSEndDate</Value>
</Value>
<Value name="10">
<Value>POSCreateDate</Value>
</Value>
<Value name="11">
<Value>POSCreateTime</Value>
</Value>
<Value name="12">
<Value>POSCreateUser</Value>
</Value>
<Value name="13">
<Value>POSSeqNo</Value>
</Value>
<Value name="14">
<Value>POSLastUpdateDate</Value>
</Value>
<Value name="15">
<Value>POSLastUpdateTime</Value>
</Value>
<Value name="16">
<Value>POSLastUpdateUser</Value>
</Value>
<Value name="17">
<Value>POSPYCode</Value>
</Value>
<Value name="18">
<Value>POSWBCode</Value>
</Value>
<Value name="19">
<Value>POSMark</Value>
</Value>
</Data>
<DataLocation>^CT.BDP.CT.HOSPositionD</DataLocation>
<DefaultData>HOSPositionDefaultData</DefaultData>
<IdLocation>^CT.BDP.CT.HOSPositionD</IdLocation>
<IndexLocation>^CT.BDP.CT.HOSPositionI</IndexLocation>
<StreamLocation>^CT.BDP.CT.HOSPositionS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
