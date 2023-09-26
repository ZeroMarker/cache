/// 描述:职务类型代码
/// 创建人：基础数据平台 陈莹
/// 创建日期：2022-09-23
Class CT.BDP.CT.HOSProfType Extends (%Persistent, User.Abstract) [ SqlTableName = HOS_ProfType ]
{

///  职务等级（子表）
Relationship ChildRank As CT.BDP.CT.HOSProfRank [ Cardinality = children, Inverse = TypeParRef ];

/// 职务类型代码
Property PROFTYCode As %String(MAXLEN = 200, TRUNCATE = 1) [ Required, SqlColumnNumber = 2, SqlFieldName = PROFTY_Code ];

/// 职务类型名称
Property PROFTYDesc As %String(MAXLEN = 200, TRUNCATE = 1) [ Required, SqlColumnNumber = 3, SqlFieldName = PROFTY_Desc ];

/// 是否有效(Y/N)
Property PROFTYActivity As %String [ InitialExpression = "Y", SqlColumnNumber = 4, SqlFieldName = PROFTY_Activity ];

/// 开始日期
Property PROFTYStartDate As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 5, SqlFieldName = PROFTY_StartDate ];

/// 结束日期
Property PROFTYEndDate As %Date [ SqlColumnNumber = 6, SqlFieldName = PROFTY_EndDate ];

/// 系统创建日期
Property PROFTYCreateDate As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 7, SqlFieldName = PROFTY_CreateDate ];

/// 系统创建时间
Property PROFTYCreateTime As %Time [ InitialExpression = {$p($h,",",2)}, SqlColumnNumber = 8, SqlFieldName = PROFTY_CreateTime ];

/// 系统创建人
Property PROFTYCreateUser As User.SSUser [ SqlColumnNumber = 9, SqlFieldName = PROFTY_CreateUser ];

/// 系统排序号
Property PROFTYSeqNo As %Float [ SqlColumnNumber = 10, SqlFieldName = PROFTY_SeqNo ];

/// 系统最后更新日期
Property PROFTYLastUpdateDate As %Date [ SqlColumnNumber = 11, SqlFieldName = PROFTY_LastUpdateDate ];

/// 系统最后更新时间
Property PROFTYLastUpdateTime As %Time [ SqlColumnNumber = 12, SqlFieldName = PROFTY_LastUpdateTime ];

/// 系统最新更新人
Property PROFTYLastUpdateUser As User.SSUser [ SqlColumnNumber = 13, SqlFieldName = PROFTY_LastUpdateUser ];

/// 拼音码
Property PROFTYPYCode As %String(MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 14, SqlFieldName = PROFTY_PYCode ];

/// 五笔码
Property PROFTYWBCode As %String(MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 15, SqlFieldName = PROFTY_WBCode ];

/// 备注
Property PROFTYMark As %String(MAXLEN = 500, TRUNCATE = 1) [ SqlColumnNumber = 16, SqlFieldName = PROFTY_Mark ];

/// 索引-代码
Index IndexCode On PROFTYCode [ Unique ];

/// 索引-名称
Index IndexDesc On PROFTYDesc [ Unique ];

/// 索引-系统排序号
Index IndexSeqNo On PROFTYSeqNo;

Storage Default
{
<Data name="HOSProfTypeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>PROFTYCode</Value>
</Value>
<Value name="3">
<Value>PROFTYDesc</Value>
</Value>
<Value name="4">
<Value>PROFTYActivity</Value>
</Value>
<Value name="5">
<Value>PROFTYStartDate</Value>
</Value>
<Value name="6">
<Value>PROFTYEndDate</Value>
</Value>
<Value name="7">
<Value>PROFTYCreateDate</Value>
</Value>
<Value name="8">
<Value>PROFTYCreateTime</Value>
</Value>
<Value name="9">
<Value>PROFTYCreateUser</Value>
</Value>
<Value name="10">
<Value>PROFTYSeqNo</Value>
</Value>
<Value name="11">
<Value>PROFTYLastUpdateDate</Value>
</Value>
<Value name="12">
<Value>PROFTYLastUpdateTime</Value>
</Value>
<Value name="13">
<Value>PROFTYLastUpdateUser</Value>
</Value>
<Value name="14">
<Value>PROFTYPYCode</Value>
</Value>
<Value name="15">
<Value>PROFTYWBCode</Value>
</Value>
<Value name="16">
<Value>PROFTYMark</Value>
</Value>
</Data>
<DataLocation>^CT.BDP.CT.HOSProfTypeD</DataLocation>
<DefaultData>HOSProfTypeDefaultData</DefaultData>
<IdLocation>^CT.BDP.CT.HOSProfTypeD</IdLocation>
<IndexLocation>^CT.BDP.CT.HOSProfTypeI</IndexLocation>
<StreamLocation>^CT.BDP.CT.HOSProfTypeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
