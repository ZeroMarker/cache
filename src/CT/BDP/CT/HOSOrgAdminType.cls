/// 描述:组织机构行政属性字典
/// 创建人：基础数据平台 陈莹
/// 创建日期：2022-09-22
Class CT.BDP.CT.HOSOrgAdminType Extends (%Persistent, User.Abstract) [ SqlTableName = HOS_OrgAdminType ]
{

/// 组织机构行政属性代码
Property ORGACCode As %String(MAXLEN = 200, TRUNCATE = 1) [ Required, SqlColumnNumber = 2, SqlFieldName = ORGAC_Code ];

/// 组织机构行政属性名称
Property ORGACDesc As %String(MAXLEN = 200, TRUNCATE = 1) [ Required, SqlColumnNumber = 3, SqlFieldName = ORGAC_Desc ];

/// 是否有效(Y/N)
Property ORGACActivity As %String [ InitialExpression = "Y", SqlColumnNumber = 4, SqlFieldName = ORGAC_Activity ];

/// 开始日期
Property ORGACStartDate As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 5, SqlFieldName = ORGAC_StartDate ];

/// 结束日期
Property ORGACEndDate As %Date [ SqlColumnNumber = 6, SqlFieldName = ORGAC_EndDate ];

/// 系统创建日期
Property ORGACCreateDate As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 7, SqlFieldName = ORGAC_CreateDate ];

/// 系统创建时间
Property ORGACCreateTime As %Time [ InitialExpression = {$p($h,",",2)}, SqlColumnNumber = 8, SqlFieldName = ORGAC_CreateTime ];

/// 系统创建人
Property ORGACCreateUser As User.SSUser [ SqlColumnNumber = 9, SqlFieldName = ORGAC_CreateUser ];

/// 系统排序号
Property ORGACSeqNo As %Float [ SqlColumnNumber = 10, SqlFieldName = ORGAC_SeqNo ];

/// 系统最后更新日期
Property ORGACLastUpdateDate As %Date [ SqlColumnNumber = 11, SqlFieldName = ORGAC_LastUpdateDate ];

/// 系统最后更新时间
Property ORGACLastUpdateTime As %Time [ SqlColumnNumber = 12, SqlFieldName = ORGAC_LastUpdateTime ];

/// 系统最新更新人
Property ORGACLastUpdateUser As User.SSUser [ SqlColumnNumber = 13, SqlFieldName = ORGAC_LastUpdateUser ];

/// 拼音码
Property ORGACPYCode As %String(MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 14, SqlFieldName = ORGAC_PYCode ];

/// 五笔码
Property ORGACWBCode As %String(MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 15, SqlFieldName = ORGAC_WBCode ];

/// 备注
Property ORGACMark As %String(MAXLEN = 500, TRUNCATE = 1) [ SqlColumnNumber = 16, SqlFieldName = ORGAC_Mark ];

/// 索引-代码
Index IndexCode On ORGACCode [ Unique ];

/// 索引-名称
Index IndexDesc On ORGACDesc [ Unique ];

/// 索引-系统排序号
Index IndexSeqNo On ORGACSeqNo;

Storage Default
{
<Data name="HOSOrgAdminTypeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ORGACCode</Value>
</Value>
<Value name="3">
<Value>ORGACDesc</Value>
</Value>
<Value name="4">
<Value>ORGACActivity</Value>
</Value>
<Value name="5">
<Value>ORGACStartDate</Value>
</Value>
<Value name="6">
<Value>ORGACEndDate</Value>
</Value>
<Value name="7">
<Value>ORGACCreateDate</Value>
</Value>
<Value name="8">
<Value>ORGACCreateTime</Value>
</Value>
<Value name="9">
<Value>ORGACCreateUser</Value>
</Value>
<Value name="10">
<Value>ORGACSeqNo</Value>
</Value>
<Value name="11">
<Value>ORGACLastUpdateDate</Value>
</Value>
<Value name="12">
<Value>ORGACLastUpdateTime</Value>
</Value>
<Value name="13">
<Value>ORGACLastUpdateUser</Value>
</Value>
<Value name="14">
<Value>ORGACPYCode</Value>
</Value>
<Value name="15">
<Value>ORGACWBCode</Value>
</Value>
<Value name="16">
<Value>ORGACMark</Value>
</Value>
</Data>
<DataLocation>^CT.BDP.CT.HOSOrgAdminTypeD</DataLocation>
<DefaultData>HOSOrgAdminTypeDefaultData</DefaultData>
<IdLocation>^CT.BDP.CT.HOSOrgAdminTypeD</IdLocation>
<IndexLocation>^CT.BDP.CT.HOSOrgAdminTypeI</IndexLocation>
<StreamLocation>^CT.BDP.CT.HOSOrgAdminTypeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
