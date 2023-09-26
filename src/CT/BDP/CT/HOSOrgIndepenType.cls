/// 描述:组织机构自主属性字典
/// 创建人：基础数据平台 陈莹
/// 创建日期：2022-09-22
Class CT.BDP.CT.HOSOrgIndepenType Extends (%Persistent, User.Abstract) [ SqlTableName = HOS_OrgIndepenType ]
{

/// 组织机构自主属性代码
Property ORGITCode As %String(MAXLEN = 200, TRUNCATE = 1) [ Required, SqlColumnNumber = 2, SqlFieldName = ORGIT_Code ];

/// 组织机构自主属性名称
Property ORGITDesc As %String(MAXLEN = 200, TRUNCATE = 1) [ Required, SqlColumnNumber = 3, SqlFieldName = ORGIT_Desc ];

/// 是否有效(Y/N)
Property ORGITActivity As %String [ InitialExpression = "Y", SqlColumnNumber = 4, SqlFieldName = ORGIT_Activity ];

/// 开始日期
Property ORGITStartDate As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 5, SqlFieldName = ORGIT_StartDate ];

/// 结束日期
Property ORGITEndDate As %Date [ SqlColumnNumber = 6, SqlFieldName = ORGIT_EndDate ];

/// 系统创建日期
Property ORGITCreateDate As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 7, SqlFieldName = ORGIT_CreateDate ];

/// 系统创建时间
Property ORGITCreateTime As %Time [ InitialExpression = {$p($h,",",2)}, SqlColumnNumber = 8, SqlFieldName = ORGIT_CreateTime ];

/// 系统创建人
Property ORGITCreateUser As User.SSUser [ SqlColumnNumber = 9, SqlFieldName = ORGIT_CreateUser ];

/// 系统排序号
Property ORGITSeqNo As %Float [ SqlColumnNumber = 10, SqlFieldName = ORGIT_SeqNo ];

/// 系统最后更新日期
Property ORGITLastUpdateDate As %Date [ SqlColumnNumber = 11, SqlFieldName = ORGIT_LastUpdateDate ];

/// 系统最后更新时间
Property ORGITLastUpdateTime As %Time [ SqlColumnNumber = 12, SqlFieldName = ORGIT_LastUpdateTime ];

/// 系统最新更新人
Property ORGITLastUpdateUser As User.SSUser [ SqlColumnNumber = 13, SqlFieldName = ORGIT_LastUpdateUser ];

/// 拼音码
Property ORGITPYCode As %String(MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 14, SqlFieldName = ORGIT_PYCode ];

/// 五笔码
Property ORGITWBCode As %String(MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 15, SqlFieldName = ORGIT_WBCode ];

/// 备注
Property ORGITMark As %String(MAXLEN = 500, TRUNCATE = 1) [ SqlColumnNumber = 16, SqlFieldName = ORGIT_Mark ];

/// 索引-代码
Index IndexCode On ORGITCode [ Unique ];

/// 索引-名称
Index IndexDesc On ORGITDesc [ Unique ];

/// 索引-系统排序号
Index IndexSeqNo On ORGITSeqNo;

Storage Default
{
<Data name="HOSOrgIndepenTypeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ORGITCode</Value>
</Value>
<Value name="3">
<Value>ORGITDesc</Value>
</Value>
<Value name="4">
<Value>ORGITActivity</Value>
</Value>
<Value name="5">
<Value>ORGITStartDate</Value>
</Value>
<Value name="6">
<Value>ORGITEndDate</Value>
</Value>
<Value name="7">
<Value>ORGITCreateDate</Value>
</Value>
<Value name="8">
<Value>ORGITCreateTime</Value>
</Value>
<Value name="9">
<Value>ORGITCreateUser</Value>
</Value>
<Value name="10">
<Value>ORGITSeqNo</Value>
</Value>
<Value name="11">
<Value>ORGITLastUpdateDate</Value>
</Value>
<Value name="12">
<Value>ORGITLastUpdateTime</Value>
</Value>
<Value name="13">
<Value>ORGITLastUpdateUser</Value>
</Value>
<Value name="14">
<Value>ORGITPYCode</Value>
</Value>
<Value name="15">
<Value>ORGITWBCode</Value>
</Value>
<Value name="16">
<Value>ORGITMark</Value>
</Value>
</Data>
<DataLocation>^CT.BDP.CT.HOSOrgIndepenTypeD</DataLocation>
<DefaultData>HOSOrgIndepenTypeDefaultData</DefaultData>
<IdLocation>^CT.BDP.CT.HOSOrgIndepenTypeD</IdLocation>
<IndexLocation>^CT.BDP.CT.HOSOrgIndepenTypeI</IndexLocation>
<StreamLocation>^CT.BDP.CT.HOSOrgIndepenTypeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
