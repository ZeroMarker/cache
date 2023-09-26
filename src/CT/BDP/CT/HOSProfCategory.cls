/// 描述:职务大类代码
/// 创建人：基础数据平台 陈莹
/// 创建日期：2022-09-23
Class CT.BDP.CT.HOSProfCategory Extends (%Persistent, User.Abstract) [ SqlTableName = HOS_ProfCategory ]
{

///  职务子类代码（子表）
Relationship ChildSubCate As CT.BDP.CT.HOSProfSubCate [ Cardinality = children, Inverse = CategoryParRef ];

/// 职务大类代码
Property PROFCCode As %String(MAXLEN = 200, TRUNCATE = 1) [ Required, SqlColumnNumber = 2, SqlFieldName = PROFC_Code ];

/// 职务大类名称
Property PROFCDesc As %String(MAXLEN = 200, TRUNCATE = 1) [ Required, SqlColumnNumber = 3, SqlFieldName = PROFC_Desc ];

/// 职务分类来源
Property PROFCSource As %String(MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = PROFC_Source ];

/// 是否有效(Y/N)
Property PROFCActivity As %String [ InitialExpression = "Y", SqlColumnNumber = 5, SqlFieldName = PROFC_Activity ];

/// 开始日期
Property PROFCStartDate As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 6, SqlFieldName = PROFC_StartDate ];

/// 结束日期
Property PROFCEndDate As %Date [ SqlColumnNumber = 7, SqlFieldName = PROFC_EndDate ];

/// 系统创建日期
Property PROFCCreateDate As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 8, SqlFieldName = PROFC_CreateDate ];

/// 系统创建时间
Property PROFCCreateTime As %Time [ InitialExpression = {$p($h,",",2)}, SqlColumnNumber = 9, SqlFieldName = PROFC_CreateTime ];

/// 系统创建人
Property PROFCCreateUser As User.SSUser [ SqlColumnNumber = 10, SqlFieldName = PROFC_CreateUser ];

/// 系统排序号
Property PROFCSeqNo As %Float [ SqlColumnNumber = 11, SqlFieldName = PROFC_SeqNo ];

/// 系统最后更新日期
Property PROFCLastUpdateDate As %Date [ SqlColumnNumber = 12, SqlFieldName = PROFC_LastUpdateDate ];

/// 系统最后更新时间
Property PROFCLastUpdateTime As %Time [ SqlColumnNumber = 13, SqlFieldName = PROFC_LastUpdateTime ];

/// 系统最新更新人
Property PROFCLastUpdateUser As User.SSUser [ SqlColumnNumber = 14, SqlFieldName = PROFC_LastUpdateUser ];

/// 拼音码
Property PROFCPYCode As %String(MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 15, SqlFieldName = PROFC_PYCode ];

/// 五笔码
Property PROFCWBCode As %String(MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 16, SqlFieldName = PROFC_WBCode ];

/// 备注
Property PROFCMark As %String(MAXLEN = 500, TRUNCATE = 1) [ SqlColumnNumber = 17, SqlFieldName = PROFC_Mark ];

/// 索引-代码
Index IndexCode On PROFCCode;

/// 索引-名称
Index IndexDesc On PROFCDesc;

/// 索引-系统排序号
Index IndexSeqNo On PROFCSeqNo;

Storage Default
{
<Data name="HOSProfCategoryDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>PROFCCode</Value>
</Value>
<Value name="3">
<Value>PROFCDesc</Value>
</Value>
<Value name="4">
<Value>PROFCSource</Value>
</Value>
<Value name="5">
<Value>PROFCActivity</Value>
</Value>
<Value name="6">
<Value>PROFCStartDate</Value>
</Value>
<Value name="7">
<Value>PROFCEndDate</Value>
</Value>
<Value name="8">
<Value>PROFCCreateDate</Value>
</Value>
<Value name="9">
<Value>PROFCCreateTime</Value>
</Value>
<Value name="10">
<Value>PROFCCreateUser</Value>
</Value>
<Value name="11">
<Value>PROFCSeqNo</Value>
</Value>
<Value name="12">
<Value>PROFCLastUpdateDate</Value>
</Value>
<Value name="13">
<Value>PROFCLastUpdateTime</Value>
</Value>
<Value name="14">
<Value>PROFCLastUpdateUser</Value>
</Value>
<Value name="15">
<Value>PROFCPYCode</Value>
</Value>
<Value name="16">
<Value>PROFCWBCode</Value>
</Value>
<Value name="17">
<Value>PROFCMark</Value>
</Value>
</Data>
<DataLocation>^CT.BDP.CT.HOSProfCategoryD</DataLocation>
<DefaultData>HOSProfCategoryDefaultData</DefaultData>
<IdLocation>^CT.BDP.CT.HOSProfCategoryD</IdLocation>
<IndexLocation>^CT.BDP.CT.HOSProfCategoryI</IndexLocation>
<StreamLocation>^CT.BDP.CT.HOSProfCategoryS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
