/// 描述:医院等级字典
/// 创建人：基础数据平台 陈莹
/// 创建日期：2022-09-23
Class CT.BDP.CT.HOSHORGGrade Extends (%Persistent, User.Abstract) [ SqlTableName = HOS_HORGGrade ]
{

/// 医院等级代码
Property HORGGCCode As %String(MAXLEN = 200, TRUNCATE = 1) [ Required, SqlColumnNumber = 2, SqlFieldName = HORGGC_Code ];

/// 医院等级名称
Property HORGGCDesc As %String(MAXLEN = 200, TRUNCATE = 1) [ Required, SqlColumnNumber = 3, SqlFieldName = HORGGC_Desc ];

/// 医院级别代码
Property HORGGCGrade As %String(MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = HORGGC_Grade ];

/// 医院子级代码 
Property HORGGCGradeClass As %String(MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = HORGGC_GradeClass ];

/// 分类来源
Property HORGGCSource As %String(MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = HORGGC_Source ];

/// 是否有效(Y/N)
Property HORGGCActivity As %String [ InitialExpression = "Y", SqlColumnNumber = 7, SqlFieldName = HORGGC_Activity ];

/// 开始日期
Property HORGGCStartDate As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 8, SqlFieldName = HORGGC_StartDate ];

/// 结束日期
Property HORGGCEndDate As %Date [ SqlColumnNumber = 9, SqlFieldName = HORGGC_EndDate ];

/// 系统创建日期
Property HORGGCCreateDate As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 10, SqlFieldName = HORGGC_CreateDate ];

/// 系统创建时间
Property HORGGCCreateTime As %Time [ InitialExpression = {$p($h,",",2)}, SqlColumnNumber = 11, SqlFieldName = HORGGC_CreateTime ];

/// 系统创建人
Property HORGGCCreateUser As User.SSUser [ SqlColumnNumber = 12, SqlFieldName = HORGGC_CreateUser ];

/// 系统排序号
Property HORGGCSeqNo As %Float [ SqlColumnNumber = 13, SqlFieldName = HORGGC_SeqNo ];

/// 系统最后更新日期
Property HORGGCLastUpdateDate As %Date [ SqlColumnNumber = 14, SqlFieldName = HORGGC_LastUpdateDate ];

/// 系统最后更新时间
Property HORGGCLastUpdateTime As %Time [ SqlColumnNumber = 15, SqlFieldName = HORGGC_LastUpdateTime ];

/// 系统最新更新人
Property HORGGCLastUpdateUser As User.SSUser [ SqlColumnNumber = 16, SqlFieldName = HORGGC_LastUpdateUser ];

/// 拼音码
Property HORGGCPYCode As %String(MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 17, SqlFieldName = HORGGC_PYCode ];

/// 五笔码
Property HORGGCWBCode As %String(MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 18, SqlFieldName = HORGGC_WBCode ];

/// 备注
Property HORGGCMark As %String(MAXLEN = 500, TRUNCATE = 1) [ SqlColumnNumber = 19, SqlFieldName = HORGGC_Mark ];

/// 索引-代码
Index IndexCode On HORGGCCode [ Unique ];

/// 索引-名称
Index IndexDesc On HORGGCDesc [ Unique ];

/// 索引-系统排序号
Index IndexSeqNo On HORGGCSeqNo;

Storage Default
{
<Data name="HOSHORGGradeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>HORGGCCode</Value>
</Value>
<Value name="3">
<Value>HORGGCDesc</Value>
</Value>
<Value name="4">
<Value>HORGGCGrade</Value>
</Value>
<Value name="5">
<Value>HORGGCGradeClass</Value>
</Value>
<Value name="6">
<Value>HORGGCSource</Value>
</Value>
<Value name="7">
<Value>HORGGCActivity</Value>
</Value>
<Value name="8">
<Value>HORGGCStartDate</Value>
</Value>
<Value name="9">
<Value>HORGGCEndDate</Value>
</Value>
<Value name="10">
<Value>HORGGCCreateDate</Value>
</Value>
<Value name="11">
<Value>HORGGCCreateTime</Value>
</Value>
<Value name="12">
<Value>HORGGCCreateUser</Value>
</Value>
<Value name="13">
<Value>HORGGCSeqNo</Value>
</Value>
<Value name="14">
<Value>HORGGCLastUpdateDate</Value>
</Value>
<Value name="15">
<Value>HORGGCLastUpdateTime</Value>
</Value>
<Value name="16">
<Value>HORGGCLastUpdateUser</Value>
</Value>
<Value name="17">
<Value>HORGGCPYCode</Value>
</Value>
<Value name="18">
<Value>HORGGCWBCode</Value>
</Value>
<Value name="19">
<Value>HORGGCMark</Value>
</Value>
</Data>
<DataLocation>^CT.BDP.CT.HOSHORGGradeD</DataLocation>
<DefaultData>HOSHORGGradeDefaultData</DefaultData>
<IdLocation>^CT.BDP.CT.HOSHORGGradeD</IdLocation>
<IndexLocation>^CT.BDP.CT.HOSHORGGradeI</IndexLocation>
<StreamLocation>^CT.BDP.CT.HOSHORGGradeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
