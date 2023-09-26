/// 描述:业务域
/// 创建人：基础数据平台 陈莹
/// 创建日期：2022-11-09
Class CT.BDP.CT.HOSBusiDomain Extends (%Persistent, User.Abstract) [ SqlTableName = HOS_Busi_Domain ]
{

/// 业务域代码
Property DomainCode As %String(MAXLEN = 200, TRUNCATE = 1) [ Required, SqlColumnNumber = 2, SqlFieldName = Domain_Code ];

/// 业务域名称
Property DomainDesc As %String(MAXLEN = 200, TRUNCATE = 1) [ Required, SqlColumnNumber = 3, SqlFieldName = Domain_Desc ];

/// 父级业务域代码-外键
Property DomainParentCode As CT.BDP.CT.HOSBusiDomain [ SqlColumnNumber = 4, SqlFieldName = Domain_Parent_Code ];

/// 业务域层级
Property DomainLevel As %String(MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = Domain_Level ];

/// 是否有效(Y/N)
Property DomainActivity As %String [ InitialExpression = "Y", SqlColumnNumber = 6, SqlFieldName = Domain_Activity ];

/// 开始日期
Property DomainStartDate As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 7, SqlFieldName = Domain_StartDate ];

/// 结束日期
Property DomainEndDate As %Date [ SqlColumnNumber = 8, SqlFieldName = Domain_EndDate ];

/// 系统创建日期
Property DomainCreateDate As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 9, SqlFieldName = Domain_CreateDate ];

/// 系统创建时间
Property DomainCreateTime As %Time [ InitialExpression = {$p($h,",",2)}, SqlColumnNumber = 10, SqlFieldName = Domain_CreateTime ];

/// 系统创建人
Property DomainCreateUser As User.SSUser [ SqlColumnNumber = 11, SqlFieldName = Domain_CreateUser ];

/// 系统排序号
Property DomainSeqNo As %Float [ SqlColumnNumber = 12, SqlFieldName = Domain_SeqNo ];

/// 系统最后更新日期
Property DomainLastUpdateDate As %Date [ SqlColumnNumber = 13, SqlFieldName = Domain_LastUpdateDate ];

/// 系统最后更新时间
Property DomainLastUpdateTime As %Time [ SqlColumnNumber = 14, SqlFieldName = Domain_LastUpdateTime ];

/// 系统最新更新人
Property DomainLastUpdateUser As User.SSUser [ SqlColumnNumber = 15, SqlFieldName = Domain_LastUpdateUser ];

/// 拼音码
Property DomainPYCode As %String(MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 16, SqlFieldName = Domain_PYCode ];

/// 五笔码
Property DomainWBCode As %String(MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 17, SqlFieldName = Domain_WBCode ];

/// 备注
Property DomainMark As %String(MAXLEN = 500, TRUNCATE = 1) [ SqlColumnNumber = 18, SqlFieldName = Domain_Mark ];

/// 索引-代码
Index IndexCode On DomainCode [ Unique ];

/// 索引-名称
Index IndexDesc On DomainDesc;

/// 索引-系统排序号
Index IndexSeqNo On DomainSeqNo;

/// 索引-父级业务域代码-外键
Index IndexParentCode On DomainParentCode;

/// 索引-父级、代码
Index IndexParCode On (DomainParentCode, DomainCode As Exact);

/// 索引-父级、描述
Index IndexParDesc On (DomainParentCode, DomainCode As Exact);

Storage Default
{
<Data name="HOSBusiDomainDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DomainCode</Value>
</Value>
<Value name="3">
<Value>DomainDesc</Value>
</Value>
<Value name="4">
<Value>DomainParentCode</Value>
</Value>
<Value name="5">
<Value>DomainLevel</Value>
</Value>
<Value name="6">
<Value>DomainActivity</Value>
</Value>
<Value name="7">
<Value>DomainStartDate</Value>
</Value>
<Value name="8">
<Value>DomainEndDate</Value>
</Value>
<Value name="9">
<Value>DomainCreateDate</Value>
</Value>
<Value name="10">
<Value>DomainCreateTime</Value>
</Value>
<Value name="11">
<Value>DomainCreateUser</Value>
</Value>
<Value name="12">
<Value>DomainSeqNo</Value>
</Value>
<Value name="13">
<Value>DomainLastUpdateDate</Value>
</Value>
<Value name="14">
<Value>DomainLastUpdateTime</Value>
</Value>
<Value name="15">
<Value>DomainLastUpdateUser</Value>
</Value>
<Value name="16">
<Value>DomainPYCode</Value>
</Value>
<Value name="17">
<Value>DomainWBCode</Value>
</Value>
<Value name="18">
<Value>DomainMark</Value>
</Value>
</Data>
<DataLocation>^CT.BDP.CT.HOSBusiDomainD</DataLocation>
<DefaultData>HOSBusiDomainDefaultData</DefaultData>
<IdLocation>^CT.BDP.CT.HOSBusiDomainD</IdLocation>
<IndexLocation>^CT.BDP.CT.HOSBusiDomainI</IndexLocation>
<StreamLocation>^CT.BDP.CT.HOSBusiDomainS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
