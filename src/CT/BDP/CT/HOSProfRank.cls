/// 描述:职务等级代码
/// 创建人：基础数据平台 陈莹
/// 创建日期：2022-09-23
Class CT.BDP.CT.HOSProfRank Extends (%Persistent, User.Abstract) [ SqlTableName = HOS_ProfRank ]
{

/// 职务等级代码
Property PROFRCode As %String(MAXLEN = 200, TRUNCATE = 1) [ Required, SqlColumnNumber = 2, SqlFieldName = PROFR_Code ];

/// 职务等级名称
Property PROFRDesc As %String(MAXLEN = 200, TRUNCATE = 1) [ Required, SqlColumnNumber = 3, SqlFieldName = PROFR_Desc ];

/// 职务等级
Property PROFRRankValue As %String(MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = PROFR_RankValue ];

/// 是否有效(Y/N)
Property PROFRActivity As %String [ InitialExpression = "Y", SqlColumnNumber = 5, SqlFieldName = PROFR_Activity ];

/// 开始日期
Property PROFRStartDate As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 6, SqlFieldName = PROFR_StartDate ];

/// 结束日期
Property PROFREndDate As %Date [ SqlColumnNumber = 7, SqlFieldName = PROFR_EndDate ];

/// 系统创建日期
Property PROFRCreateDate As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 8, SqlFieldName = PROFR_CreateDate ];

/// 系统创建时间
Property PROFRCreateTime As %Time [ InitialExpression = {$p($h,",",2)}, SqlColumnNumber = 9, SqlFieldName = PROFR_CreateTime ];

/// 系统创建人
Property PROFRCreateUser As User.SSUser [ SqlColumnNumber = 10, SqlFieldName = PROFR_CreateUser ];

/// 系统排序号
Property PROFRSeqNo As %Float [ SqlColumnNumber = 11, SqlFieldName = PROFR_SeqNo ];

/// 系统最后更新日期
Property PROFRLastUpdateDate As %Date [ SqlColumnNumber = 12, SqlFieldName = PROFR_LastUpdateDate ];

/// 系统最后更新时间
Property PROFRLastUpdateTime As %Time [ SqlColumnNumber = 13, SqlFieldName = PROFR_LastUpdateTime ];

/// 系统最新更新人
Property PROFRLastUpdateUser As User.SSUser [ SqlColumnNumber = 14, SqlFieldName = PROFR_LastUpdateUser ];

/// 拼音码
Property PROFRPYCode As %String(MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 15, SqlFieldName = PROFR_PYCode ];

/// 五笔码
Property PROFRWBCode As %String(MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 16, SqlFieldName = PROFR_WBCode ];

/// 备注
Property PROFRMark As %String(MAXLEN = 500, TRUNCATE = 1) [ SqlColumnNumber = 17, SqlFieldName = PROFR_Mark ];

/// 索引-代码
Index IndexCode On PROFRCode;

/// 索引-名称
Index IndexDesc On PROFRDesc;

/// 索引-系统排序号
Index IndexSeqNo On PROFRSeqNo;

Storage Default
{
<Data name="HOSProfRankDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>PROFRCode</Value>
</Value>
<Value name="3">
<Value>PROFRDesc</Value>
</Value>
<Value name="4">
<Value>PROFRRankValue</Value>
</Value>
<Value name="5">
<Value>PROFRActivity</Value>
</Value>
<Value name="6">
<Value>PROFRStartDate</Value>
</Value>
<Value name="7">
<Value>PROFREndDate</Value>
</Value>
<Value name="8">
<Value>PROFRCreateDate</Value>
</Value>
<Value name="9">
<Value>PROFRCreateTime</Value>
</Value>
<Value name="10">
<Value>PROFRCreateUser</Value>
</Value>
<Value name="11">
<Value>PROFRSeqNo</Value>
</Value>
<Value name="12">
<Value>PROFRLastUpdateDate</Value>
</Value>
<Value name="13">
<Value>PROFRLastUpdateTime</Value>
</Value>
<Value name="14">
<Value>PROFRLastUpdateUser</Value>
</Value>
<Value name="15">
<Value>PROFRPYCode</Value>
</Value>
<Value name="16">
<Value>PROFRWBCode</Value>
</Value>
<Value name="17">
<Value>PROFRMark</Value>
</Value>
</Data>
<DataLocation>^CT.BDP.CT.HOSProfRankD</DataLocation>
<DefaultData>HOSProfRankDefaultData</DefaultData>
<IdLocation>^CT.BDP.CT.HOSProfRankD</IdLocation>
<IndexLocation>^CT.BDP.CT.HOSProfRankI</IndexLocation>
<StreamLocation>^CT.BDP.CT.HOSProfRankS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
