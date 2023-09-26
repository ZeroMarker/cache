/// 描述:职务字典代码
/// 创建人：鲁俊文
/// 创建日期：2023-2-2
Class CT.BDP.CT.HOSProfTitleDict Extends (%Persistent, User.Abstract) [ SqlTableName = HOS_ProfTitleDict ]
{

/// 职务代码
Property PROFTCCode As %String [ Required, SqlColumnNumber = 2, SqlFieldName = PROFTC_Code ];

/// 职务名称
Property PROFTCDesc As %String [ Required, SqlColumnNumber = 3, SqlFieldName = PROFTC_Desc ];

/// 职务分类 
Property PROFTCType As User.CTOccupation [ SqlColumnNumber = 4, SqlFieldName = PROFTC_Type ];

/// 职务等级
Property PROFTCPROFRCode As CT.BDP.CT.HOSProfRank [ SqlColumnNumber = 5, SqlFieldName = PROFTC_PROFRCode ];

/// 职级范围
Property PROFTCRankRange As %String [ SqlColumnNumber = 6, SqlFieldName = PROFTC_RankRange ];

/// 是否有效(Y/N)
Property PROFTCActivity As %String [ InitialExpression = "Y", SqlColumnNumber = 7, SqlFieldName = PROFTC_Activity ];

/// 开始日期
Property PROFTCStartDate As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 8, SqlFieldName = PROFTC_StartDate ];

/// 结束日期
Property PROFTCEndDate As %Date [ SqlColumnNumber = 9, SqlFieldName = PROFTC_EndDate ];

/// 系统创建日期
Property PROFTCCreateDate As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 10, SqlFieldName = PROFTC_CreateDate ];

/// 系统创建时间
Property PROFTCCreateTime As %Time [ InitialExpression = {$p($h,",",2)}, SqlColumnNumber = 11, SqlFieldName = PROFTC_CreateTime ];

/// 系统创建人
Property PROFTCCreateUser As User.SSUser [ SqlColumnNumber = 12, SqlFieldName = PROFTC_CreateUser ];

/// 系统排序号
Property PROFTCSeqNo As %Float [ SqlColumnNumber = 13, SqlFieldName = PROFTC_SeqNo ];

/// 系统最后更新日期
Property PROFTCLastUpdateDate As %Date [ SqlColumnNumber = 14, SqlFieldName = PROFTC_LastUpdateDate ];

/// 系统最后更新时间
Property PROFTCLastUpdateTime As %Time [ SqlColumnNumber = 15, SqlFieldName = PROFTC_LastUpdateTime ];

/// 系统最新更新人
Property PROFTCLastUpdateUser As User.SSUser [ SqlColumnNumber = 16, SqlFieldName = PROFTC_LastUpdateUser ];

/// 拼音码
Property PROFTCPYCode As %String(MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 17, SqlFieldName = PROFTC_PYCode ];

/// 五笔码
Property PROFTCWBCode As %String(MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 18, SqlFieldName = PROFTC_WBCode ];

/// 备注
Property PROFTCMark As %String(MAXLEN = 500, TRUNCATE = 1) [ SqlColumnNumber = 19, SqlFieldName = PROFTC_Mark ];

/// 索引-岗位类型代码
Index IndexPROFTCCode On PROFTCCode;

/// 索引-岗位类型名称
Index IndexPROFTCDesc On PROFTCDesc;

/// 职务分类-外键-索引
Index IndexPROFTCType On PROFTCType;

/// 职务等级-外键-索引
Index IndexPROFRCode On PROFTCPROFRCode;

Storage Default
{
<Data name="HOSProfTitleDictDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>PROFTCCode</Value>
</Value>
<Value name="3">
<Value>PROFTCDesc</Value>
</Value>
<Value name="4">
<Value>PROFTCType</Value>
</Value>
<Value name="5">
<Value>PROFTCPROFRCode</Value>
</Value>
<Value name="6">
<Value>PROFTCRankRange</Value>
</Value>
<Value name="7">
<Value>PROFTCActivity</Value>
</Value>
<Value name="8">
<Value>PROFTCStartDate</Value>
</Value>
<Value name="9">
<Value>PROFTCEndDate</Value>
</Value>
<Value name="10">
<Value>PROFTCCreateDate</Value>
</Value>
<Value name="11">
<Value>PROFTCCreateTime</Value>
</Value>
<Value name="12">
<Value>PROFTCCreateUser</Value>
</Value>
<Value name="13">
<Value>PROFTCSeqNo</Value>
</Value>
<Value name="14">
<Value>PROFTCLastUpdateDate</Value>
</Value>
<Value name="15">
<Value>PROFTCLastUpdateTime</Value>
</Value>
<Value name="16">
<Value>PROFTCLastUpdateUser</Value>
</Value>
<Value name="17">
<Value>PROFTCPYCode</Value>
</Value>
<Value name="18">
<Value>PROFTCWBCode</Value>
</Value>
<Value name="19">
<Value>PROFTCMark</Value>
</Value>
</Data>
<DataLocation>^CT.BDP.CT.HOSProfTitleDictD</DataLocation>
<DefaultData>HOSProfTitleDictDefaultData</DefaultData>
<IdLocation>^CT.BDP.CT.HOSProfTitleDictD</IdLocation>
<IndexLocation>^CT.BDP.CT.HOSProfTitleDictI</IndexLocation>
<StreamLocation>^CT.BDP.CT.HOSProfTitleDictS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
