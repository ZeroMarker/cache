/// 描述:组织级次字典
/// 创建人：基础数据平台 陈莹
/// 创建日期：2022-09-22
Class CT.BDP.CT.HOSORGHierarchy Extends (%Persistent, User.Abstract) [ SqlTableName = HOS_ORGHierarchy ]
{

/// 组织层级代码
Property ORGHCode As %String(MAXLEN = 200, TRUNCATE = 1) [ Required, SqlColumnNumber = 2, SqlFieldName = ORGH_Code ];

/// 组织层级名称
Property ORGHDesc As %String(MAXLEN = 200, TRUNCATE = 1) [ Required, SqlColumnNumber = 3, SqlFieldName = ORGH_Desc ];

/// 组织层级数值
Property ORGHHierarchyValue As %String(MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = ORGH_HierarchyValue ];

/// 是否有效(Y/N)
Property ORGHActivity As %String [ InitialExpression = "Y", SqlColumnNumber = 5, SqlFieldName = ORGH_Activity ];

/// 开始日期
Property ORGHStartDate As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 6, SqlFieldName = ORGH_StartDate ];

/// 结束日期
Property ORGHEndDate As %Date [ SqlColumnNumber = 7, SqlFieldName = ORGH_EndDate ];

/// 系统创建日期
Property ORGHCreateDate As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 8, SqlFieldName = ORGH_CreateDate ];

/// 系统创建时间
Property ORGHCreateTime As %Time [ InitialExpression = {$p($h,",",2)}, SqlColumnNumber = 9, SqlFieldName = ORGH_CreateTime ];

/// 系统创建人
Property ORGHCreateUser As User.SSUser [ SqlColumnNumber = 10, SqlFieldName = ORGH_CreateUser ];

/// 系统排序号
Property ORGHSeqNo As %Float [ SqlColumnNumber = 11, SqlFieldName = ORGH_SeqNo ];

/// 系统最后更新日期
Property ORGHLastUpdateDate As %Date [ SqlColumnNumber = 12, SqlFieldName = ORGH_LastUpdateDate ];

/// 系统最后更新时间
Property ORGHLastUpdateTime As %Time [ SqlColumnNumber = 13, SqlFieldName = ORGH_LastUpdateTime ];

/// 系统最新更新人
Property ORGHLastUpdateUser As User.SSUser [ SqlColumnNumber = 14, SqlFieldName = ORGH_LastUpdateUser ];

/// 拼音码
Property ORGHPYCode As %String(MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 15, SqlFieldName = ORGH_PYCode ];

/// 五笔码
Property ORGHWBCode As %String(MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 16, SqlFieldName = ORGH_WBCode ];

/// 备注
Property ORGHMark As %String(MAXLEN = 500, TRUNCATE = 1) [ SqlColumnNumber = 17, SqlFieldName = ORGH_Mark ];

/// 索引-代码
Index IndexCode On ORGHCode [ Unique ];

/// 索引-名称
Index IndexDesc On ORGHDesc [ Unique ];

/// 索引-系统排序号
Index IndexSeqNo On ORGHSeqNo;

Storage Default
{
<Data name="HOSORGHierarchyDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ORGHCode</Value>
</Value>
<Value name="3">
<Value>ORGHDesc</Value>
</Value>
<Value name="4">
<Value>ORGHHierarchyValue</Value>
</Value>
<Value name="5">
<Value>ORGHActivity</Value>
</Value>
<Value name="6">
<Value>ORGHStartDate</Value>
</Value>
<Value name="7">
<Value>ORGHEndDate</Value>
</Value>
<Value name="8">
<Value>ORGHCreateDate</Value>
</Value>
<Value name="9">
<Value>ORGHCreateTime</Value>
</Value>
<Value name="10">
<Value>ORGHCreateUser</Value>
</Value>
<Value name="11">
<Value>ORGHSeqNo</Value>
</Value>
<Value name="12">
<Value>ORGHLastUpdateDate</Value>
</Value>
<Value name="13">
<Value>ORGHLastUpdateTime</Value>
</Value>
<Value name="14">
<Value>ORGHLastUpdateUser</Value>
</Value>
<Value name="15">
<Value>ORGHPYCode</Value>
</Value>
<Value name="16">
<Value>ORGHWBCode</Value>
</Value>
<Value name="17">
<Value>ORGHMark</Value>
</Value>
</Data>
<DataLocation>^CT.BDP.CT.HOSORGHierarchyD</DataLocation>
<DefaultData>HOSORGHierarchyDefaultData</DefaultData>
<IdLocation>^CT.BDP.CT.HOSORGHierarchyD</IdLocation>
<IndexLocation>^CT.BDP.CT.HOSORGHierarchyI</IndexLocation>
<StreamLocation>^CT.BDP.CT.HOSORGHierarchyS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
