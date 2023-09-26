/// 描述:人员状态字典
/// 创建人：基础数据平台 陈莹
/// 创建日期：2022-11-07
Class CT.BDP.CT.HOSPersonStatusDict Extends (%Persistent, User.Abstract) [ SqlTableName = HOS_PersonStatusDict ]
{

/// 人员状态代码
Property PSDCode As %String(MAXLEN = 200, TRUNCATE = 1) [ Required, SqlColumnNumber = 2, SqlFieldName = PSD_Code ];

/// 人员状态名称
Property PSDDesc As %String(MAXLEN = 200, TRUNCATE = 1) [ Required, SqlColumnNumber = 3, SqlFieldName = PSD_Desc ];

/// 是否有效(Y/N)
Property PSDActivity As %String [ InitialExpression = "Y", SqlColumnNumber = 4, SqlFieldName = PSD_Activity ];

/// 开始日期
Property PSDStartDate As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 5, SqlFieldName = PSD_StartDate ];

/// 结束日期
Property PSDEndDate As %Date [ SqlColumnNumber = 6, SqlFieldName = PSD_EndDate ];

/// 系统创建日期
Property PSDCreateDate As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 7, SqlFieldName = PSD_CreateDate ];

/// 系统创建时间
Property PSDCreateTime As %Time [ InitialExpression = {$p($h,",",2)}, SqlColumnNumber = 8, SqlFieldName = PSD_CreateTime ];

/// 系统创建人
Property PSDCreateUser As User.SSUser [ SqlColumnNumber = 9, SqlFieldName = PSD_CreateUser ];

/// 系统排序号
Property PSDSeqNo As %Float [ SqlColumnNumber = 10, SqlFieldName = PSD_SeqNo ];

/// 系统最后更新日期
Property PSDLastUpdateDate As %Date [ SqlColumnNumber = 11, SqlFieldName = PSD_LastUpdateDate ];

/// 系统最后更新时间
Property PSDLastUpdateTime As %Time [ SqlColumnNumber = 12, SqlFieldName = PSD_LastUpdateTime ];

/// 系统最新更新人
Property PSDLastUpdateUser As User.SSUser [ SqlColumnNumber = 13, SqlFieldName = PSD_LastUpdateUser ];

/// 拼音码
Property PSDPYCode As %String(MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 14, SqlFieldName = PSD_PYCode ];

/// 五笔码
Property PSDWBCode As %String(MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 15, SqlFieldName = PSD_WBCode ];

/// 备注
Property PSDMark As %String(MAXLEN = 500, TRUNCATE = 1) [ SqlColumnNumber = 16, SqlFieldName = PSD_Mark ];

/// 索引-代码
Index IndexCode On PSDCode [ Unique ];

/// 索引-名称
Index IndexDesc On PSDDesc [ Unique ];

/// 索引-系统排序号
Index IndexSeqNo On PSDSeqNo;

Storage Default
{
<Data name="HOSPersonStatusDictDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>PSDCode</Value>
</Value>
<Value name="3">
<Value>PSDDesc</Value>
</Value>
<Value name="4">
<Value>PSDActivity</Value>
</Value>
<Value name="5">
<Value>PSDStartDate</Value>
</Value>
<Value name="6">
<Value>PSDEndDate</Value>
</Value>
<Value name="7">
<Value>PSDCreateDate</Value>
</Value>
<Value name="8">
<Value>PSDCreateTime</Value>
</Value>
<Value name="9">
<Value>PSDCreateUser</Value>
</Value>
<Value name="10">
<Value>PSDSeqNo</Value>
</Value>
<Value name="11">
<Value>PSDLastUpdateDate</Value>
</Value>
<Value name="12">
<Value>PSDLastUpdateTime</Value>
</Value>
<Value name="13">
<Value>PSDLastUpdateUser</Value>
</Value>
<Value name="14">
<Value>PSDPYCode</Value>
</Value>
<Value name="15">
<Value>PSDWBCode</Value>
</Value>
<Value name="16">
<Value>PSDMark</Value>
</Value>
</Data>
<DataLocation>^CT.BDP.CT.HOSPersonStatusDictD</DataLocation>
<DefaultData>HOSPersonStatusDictDefaultData</DefaultData>
<IdLocation>^CT.BDP.CT.HOSPersonStatusDictD</IdLocation>
<IndexLocation>^CT.BDP.CT.HOSPersonStatusDictI</IndexLocation>
<StreamLocation>^CT.BDP.CT.HOSPersonStatusDictS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
