/// 描述:HOS学位代码
/// 创建人：基础数据平台 高姗姗
/// 创建日期：2023-02-07
Class CT.BDP.CT.HOSDegree Extends (%Persistent, User.Abstract) [ SqlTableName = HOS_Degree ]
{

/// 学位代码
Property DEGCode As %String(MAXLEN = 200, TRUNCATE = 1) [ Required, SqlColumnNumber = 2, SqlFieldName = DEG_Code ];

/// 学位名称
Property DEGDesc As %String(MAXLEN = 200, TRUNCATE = 1) [ Required, SqlColumnNumber = 3, SqlFieldName = DEG_Desc ];

/// 是否有效(Y/N)
Property DEGActivity As %String [ InitialExpression = "Y", SqlColumnNumber = 4, SqlFieldName = DEG_Activity ];

/// 开始日期
Property DEGStartDate As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 5, SqlFieldName = DEG_StartDate ];

/// 结束日期
Property DEGEndDate As %Date [ SqlColumnNumber = 6, SqlFieldName = DEG_EndDate ];

/// 系统创建日期
Property DEGCreateDate As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 7, SqlFieldName = DEG_CreateDate ];

/// 系统创建时间
Property DEGCreateTime As %Time [ InitialExpression = {$p($h,",",2)}, SqlColumnNumber = 8, SqlFieldName = DEG_CreateTime ];

/// 系统创建人
Property DEGCreateUser As User.SSUser [ SqlColumnNumber = 9, SqlFieldName = DEG_CreateUser ];

/// 系统排序号
Property DEGSeqNo As %Float [ SqlColumnNumber = 10, SqlFieldName = DEG_SeqNo ];

/// 系统最后更新日期
Property DEGLastUpdateDate As %Date [ SqlColumnNumber = 11, SqlFieldName = DEG_LastUpdateDate ];

/// 系统最后更新时间
Property DEGLastUpdateTime As %Time [ SqlColumnNumber = 12, SqlFieldName = DEG_LastUpdateTime ];

/// 系统最新更新人
Property DEGLastUpdateUser As User.SSUser [ SqlColumnNumber = 13, SqlFieldName = DEG_LastUpdateUser ];

/// 拼音码
Property DEGPYCode As %String(MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 14, SqlFieldName = DEG_PYCode ];

/// 五笔码
Property DEGWBCode As %String(MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 15, SqlFieldName = DEG_WBCode ];

/// 备注
Property DEGMark As %String(MAXLEN = 500, TRUNCATE = 1) [ SqlColumnNumber = 16, SqlFieldName = DEG_Mark ];

/// 索引-代码
Index IndexCode On DEGCode [ Unique ];

/// 索引-名称
Index IndexDesc On DEGDesc [ Unique ];

/// 索引-系统排序号
Index IndexSeqNo On DEGSeqNo;

Storage Default
{
<Data name="HOSDegreeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DEGCode</Value>
</Value>
<Value name="3">
<Value>DEGDesc</Value>
</Value>
<Value name="4">
<Value>DEGActivity</Value>
</Value>
<Value name="5">
<Value>DEGStartDate</Value>
</Value>
<Value name="6">
<Value>DEGEndDate</Value>
</Value>
<Value name="7">
<Value>DEGCreateDate</Value>
</Value>
<Value name="8">
<Value>DEGCreateTime</Value>
</Value>
<Value name="9">
<Value>DEGCreateUser</Value>
</Value>
<Value name="10">
<Value>DEGSeqNo</Value>
</Value>
<Value name="11">
<Value>DEGLastUpdateDate</Value>
</Value>
<Value name="12">
<Value>DEGLastUpdateTime</Value>
</Value>
<Value name="13">
<Value>DEGLastUpdateUser</Value>
</Value>
<Value name="14">
<Value>DEGPYCode</Value>
</Value>
<Value name="15">
<Value>DEGWBCode</Value>
</Value>
<Value name="16">
<Value>DEGMark</Value>
</Value>
</Data>
<DataLocation>^CT.BDP.CT.HOSDegreeD</DataLocation>
<DefaultData>HOSDegreeDefaultData</DefaultData>
<IdLocation>^CT.BDP.CT.HOSDegreeD</IdLocation>
<IndexLocation>^CT.BDP.CT.HOSDegreeI</IndexLocation>
<StreamLocation>^CT.BDP.CT.HOSDegreeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
