/// 描述:职位类型字典
/// 创建人：基础数据平台 陈莹
/// 创建日期：2022-09-22
Class CT.BDP.CT.HOSPOSType Extends (%Persistent, User.Abstract) [ SqlTableName = HOS_POSType ]
{

/// 职位类型代码
Property POSKCode As %String(MAXLEN = 200, TRUNCATE = 1) [ Required, SqlColumnNumber = 2, SqlFieldName = POSK_Code ];

/// 职位类型名称
Property POSKDesc As %String(MAXLEN = 200, TRUNCATE = 1) [ Required, SqlColumnNumber = 3, SqlFieldName = POSK_Desc ];

/// 是否有效(Y/N)
Property POSKActivity As %String [ InitialExpression = "Y", SqlColumnNumber = 4, SqlFieldName = POSK_Activity ];

/// 开始日期
Property POSKStartDate As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 5, SqlFieldName = POSK_StartDate ];

/// 结束日期
Property POSKEndDate As %Date [ SqlColumnNumber = 6, SqlFieldName = POSK_EndDate ];

/// 系统创建日期
Property POSKCreateDate As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 7, SqlFieldName = POSK_CreateDate ];

/// 系统创建时间
Property POSKCreateTime As %Time [ InitialExpression = {$p($h,",",2)}, SqlColumnNumber = 8, SqlFieldName = POSK_CreateTime ];

/// 系统创建人
Property POSKCreateUser As User.SSUser [ SqlColumnNumber = 9, SqlFieldName = POSK_CreateUser ];

/// 系统排序号
Property POSKSeqNo As %Float [ SqlColumnNumber = 10, SqlFieldName = POSK_SeqNo ];

/// 系统最后更新日期
Property POSKLastUpdateDate As %Date [ SqlColumnNumber = 11, SqlFieldName = POSK_LastUpdateDate ];

/// 系统最后更新时间
Property POSKLastUpdateTime As %Time [ SqlColumnNumber = 12, SqlFieldName = POSK_LastUpdateTime ];

/// 系统最新更新人
Property POSKLastUpdateUser As User.SSUser [ SqlColumnNumber = 13, SqlFieldName = POSK_LastUpdateUser ];

/// 拼音码
Property POSKPYCode As %String(MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 14, SqlFieldName = POSK_PYCode ];

/// 五笔码
Property POSKWBCode As %String(MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 15, SqlFieldName = POSK_WBCode ];

/// 备注
Property POSKMark As %String(MAXLEN = 500, TRUNCATE = 1) [ SqlColumnNumber = 16, SqlFieldName = POSK_Mark ];

/// 索引-代码
Index IndexCode On POSKCode [ Unique ];

/// 索引-名称
Index IndexDesc On POSKDesc [ Unique ];

/// 索引-系统排序号
Index IndexSeqNo On POSKSeqNo;

Storage Default
{
<Data name="HOSPOSTypeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>POSKCode</Value>
</Value>
<Value name="3">
<Value>POSKDesc</Value>
</Value>
<Value name="4">
<Value>POSKActivity</Value>
</Value>
<Value name="5">
<Value>POSKStartDate</Value>
</Value>
<Value name="6">
<Value>POSKEndDate</Value>
</Value>
<Value name="7">
<Value>POSKCreateDate</Value>
</Value>
<Value name="8">
<Value>POSKCreateTime</Value>
</Value>
<Value name="9">
<Value>POSKCreateUser</Value>
</Value>
<Value name="10">
<Value>POSKSeqNo</Value>
</Value>
<Value name="11">
<Value>POSKLastUpdateDate</Value>
</Value>
<Value name="12">
<Value>POSKLastUpdateTime</Value>
</Value>
<Value name="13">
<Value>POSKLastUpdateUser</Value>
</Value>
<Value name="14">
<Value>POSKPYCode</Value>
</Value>
<Value name="15">
<Value>POSKWBCode</Value>
</Value>
<Value name="16">
<Value>POSKMark</Value>
</Value>
</Data>
<DataLocation>^CT.BDP.CT.HOSPOSTypeD</DataLocation>
<DefaultData>HOSPOSTypeDefaultData</DefaultData>
<IdLocation>^CT.BDP.CT.HOSPOSTypeD</IdLocation>
<IndexLocation>^CT.BDP.CT.HOSPOSTypeI</IndexLocation>
<StreamLocation>^CT.BDP.CT.HOSPOSTypeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
