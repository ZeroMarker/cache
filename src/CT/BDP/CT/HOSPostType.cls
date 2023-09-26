/// 描述:岗位类型
/// 创建人：鲁俊文
/// 创建日期：2023-2-2
Class CT.BDP.CT.HOSPostType Extends (%Persistent, User.Abstract) [ SqlTableName = HOS_PostType ]
{

/// 岗位类型代码
Property PTCode As %String [ Required, SqlColumnNumber = 2, SqlFieldName = PT_Code ];

/// 岗位类型名称
Property PTDesc As %String [ Required, SqlColumnNumber = 3, SqlFieldName = PT_Desc ];

/// 是否有效(Y/N)
Property PTActivity As %String [ InitialExpression = "Y", SqlColumnNumber = 4, SqlFieldName = PT_Activity ];

/// 开始日期
Property PTStartDate As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 5, SqlFieldName = PT_StartDate ];

/// 结束日期
Property PTEndDate As %Date [ SqlColumnNumber = 6, SqlFieldName = PT_EndDate ];

/// 系统创建日期
Property PTCreateDate As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 7, SqlFieldName = PT_CreateDate ];

/// 系统创建时间
Property PTCreateTime As %Time [ InitialExpression = {$p($h,",",2)}, SqlColumnNumber = 8, SqlFieldName = PT_CreateTime ];

/// 系统创建人
Property PTCreateUser As User.SSUser [ SqlColumnNumber = 9, SqlFieldName = PT_CreateUser ];

/// 系统排序号
Property PTSeqNo As %Float [ SqlColumnNumber = 10, SqlFieldName = PT_SeqNo ];

/// 系统最后更新日期
Property PTLastUpdateDate As %Date [ SqlColumnNumber = 11, SqlFieldName = PT_LastUpdateDate ];

/// 系统最后更新时间
Property PTLastUpdateTime As %Time [ SqlColumnNumber = 12, SqlFieldName = PT_LastUpdateTime ];

/// 系统最新更新人
Property PTLastUpdateUser As User.SSUser [ SqlColumnNumber = 13, SqlFieldName = PT_LastUpdateUser ];

/// 拼音码
Property PTPYCode As %String(MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 14, SqlFieldName = PT_PYCode ];

/// 五笔码
Property PTWBCode As %String(MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 15, SqlFieldName = PT_WBCode ];

/// 备注
Property PTMark As %String(MAXLEN = 500, TRUNCATE = 1) [ SqlColumnNumber = 16, SqlFieldName = PT_Mark ];

/// 索引-岗位类型代码
Index IndexPTCode On PTCode;

/// 索引-岗位类型名称
Index IndexPTDesc On PTDesc;

Storage Default
{
<Data name="HOSPostTypeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>PTCode</Value>
</Value>
<Value name="3">
<Value>PTDesc</Value>
</Value>
<Value name="4">
<Value>PTActivity</Value>
</Value>
<Value name="5">
<Value>PTStartDate</Value>
</Value>
<Value name="6">
<Value>PTEndDate</Value>
</Value>
<Value name="7">
<Value>PTCreateDate</Value>
</Value>
<Value name="8">
<Value>PTCreateTime</Value>
</Value>
<Value name="9">
<Value>PTCreateUser</Value>
</Value>
<Value name="10">
<Value>PTSeqNo</Value>
</Value>
<Value name="11">
<Value>PTLastUpdateDate</Value>
</Value>
<Value name="12">
<Value>PTLastUpdateTime</Value>
</Value>
<Value name="13">
<Value>PTLastUpdateUser</Value>
</Value>
<Value name="14">
<Value>PTPYCode</Value>
</Value>
<Value name="15">
<Value>PTWBCode</Value>
</Value>
<Value name="16">
<Value>PTMark</Value>
</Value>
</Data>
<DataLocation>^CT.BDP.CT.HOSPostTypeD</DataLocation>
<DefaultData>HOSPostTypeDefaultData</DefaultData>
<IdLocation>^CT.BDP.CT.HOSPostTypeD</IdLocation>
<IndexLocation>^CT.BDP.CT.HOSPostTypeI</IndexLocation>
<StreamLocation>^CT.BDP.CT.HOSPostTypeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
