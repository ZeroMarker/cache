/// 描述:工作状态字典
/// 创建人：基础数据平台 鲁俊文
/// 创建日期：2023-2-07
Class CT.BDP.CT.HOSEmpStatusDict Extends (%Persistent, User.Abstract) [ SqlTableName = HOS_EmpStatusDict ]
{

/// 人员工作状态代码
Property ESDCode As %String(MAXLEN = 200, TRUNCATE = 1) [ Required, SqlColumnNumber = 2, SqlFieldName = ESD_Code ];

/// 人员工作状态描述
Property ESDDesc As %String(MAXLEN = 200, TRUNCATE = 1) [ Required, SqlColumnNumber = 3, SqlFieldName = ESD_Desc ];

/// 是否有效(Y/N)
Property ESDActivity As %String [ InitialExpression = "Y", SqlColumnNumber = 4, SqlFieldName = ESD_Activity ];

/// 开始日期
Property ESDStartDate As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 5, SqlFieldName = ESD_StartDate ];

/// 结束日期
Property ESDEndDate As %Date [ SqlColumnNumber = 6, SqlFieldName = ESD_EndDate ];

/// 系统创建日期
Property ESDCreateDate As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 7, SqlFieldName = ESD_CreateDate ];

/// 系统创建时间
Property ESDCreateTime As %Time [ InitialExpression = {$p($h,",",2)}, SqlColumnNumber = 8, SqlFieldName = ESD_CreateTime ];

/// 系统创建人
Property ESDCreateUser As User.SSUser [ SqlColumnNumber = 9, SqlFieldName = ESD_CreateUser ];

/// 系统排序号
Property ESDSeqNo As %Float [ SqlColumnNumber = 10, SqlFieldName = ESD_SeqNo ];

/// 系统最后更新日期
Property ESDLastUpdateDate As %Date [ SqlColumnNumber = 11, SqlFieldName = ESD_LastUpdateDate ];

/// 系统最后更新时间
Property ESDLastUpdateTime As %Time [ SqlColumnNumber = 12, SqlFieldName = ESD_LastUpdateTime ];

/// 系统最新更新人
Property ESDLastUpdateUser As User.SSUser [ SqlColumnNumber = 13, SqlFieldName = ESD_LastUpdateUser ];

/// 拼音码
Property ESDPYCode As %String(MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 14, SqlFieldName = ESD_PYCode ];

/// 五笔码
Property ESDWBCode As %String(MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 15, SqlFieldName = ESD_WBCode ];

/// 备注
Property ESDMark As %String(MAXLEN = 500, TRUNCATE = 1) [ SqlColumnNumber = 16, SqlFieldName = ESD_Mark ];

/// 索引-代码
Index IndexCode On ESDCode [ Unique ];

/// 索引-名称
Index IndexDesc On ESDDesc [ Unique ];

/// 索引-系统排序号
Index IndexSeqNo On ESDSeqNo;

Storage Default
{
<Data name="HOSEmpStatusDictDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ESDCode</Value>
</Value>
<Value name="3">
<Value>ESDDesc</Value>
</Value>
<Value name="4">
<Value>ESDActivity</Value>
</Value>
<Value name="5">
<Value>ESDStartDate</Value>
</Value>
<Value name="6">
<Value>ESDEndDate</Value>
</Value>
<Value name="7">
<Value>ESDCreateDate</Value>
</Value>
<Value name="8">
<Value>ESDCreateTime</Value>
</Value>
<Value name="9">
<Value>ESDCreateUser</Value>
</Value>
<Value name="10">
<Value>ESDSeqNo</Value>
</Value>
<Value name="11">
<Value>ESDLastUpdateDate</Value>
</Value>
<Value name="12">
<Value>ESDLastUpdateTime</Value>
</Value>
<Value name="13">
<Value>ESDLastUpdateUser</Value>
</Value>
<Value name="14">
<Value>ESDPYCode</Value>
</Value>
<Value name="15">
<Value>ESDWBCode</Value>
</Value>
<Value name="16">
<Value>ESDMark</Value>
</Value>
</Data>
<DataLocation>^CT.BDP.CT.HOSEmpStatusDictD</DataLocation>
<DefaultData>HOSEmpStatusDictDefaultData</DefaultData>
<IdLocation>^CT.BDP.CT.HOSEmpStatusDictD</IdLocation>
<IndexLocation>^CT.BDP.CT.HOSEmpStatusDictI</IndexLocation>
<StreamLocation>^CT.BDP.CT.HOSEmpStatusDictS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
