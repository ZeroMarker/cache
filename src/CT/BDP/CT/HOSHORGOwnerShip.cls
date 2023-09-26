/// 描述:医疗机构的所有制形式
/// 创建人：基础数据平台 陈莹
/// 创建日期：2022-09-23
Class CT.BDP.CT.HOSHORGOwnerShip Extends (%Persistent, User.Abstract) [ SqlTableName = HOS_HORGOwnerShip ]
{

/// 所有制形式代码
Property HORGOSCode As %String(MAXLEN = 200, TRUNCATE = 1) [ Required, SqlColumnNumber = 2, SqlFieldName = HORGOS_Code ];

/// 所有制形式名称
Property HORGOSDesc As %String(MAXLEN = 200, TRUNCATE = 1) [ Required, SqlColumnNumber = 3, SqlFieldName = HORGOS_Desc ];

/// 分类来源
Property HORGOSSource As %String(MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = HORGOS_Source ];

/// 是否有效(Y/N)
Property HORGOSActivity As %String [ InitialExpression = "Y", SqlColumnNumber = 5, SqlFieldName = HORGOS_Activity ];

/// 开始日期
Property HORGOSStartDate As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 6, SqlFieldName = HORGOS_StartDate ];

/// 结束日期
Property HORGOSEndDate As %Date [ SqlColumnNumber = 7, SqlFieldName = HORGOS_EndDate ];

/// 系统创建日期
Property HORGOSCreateDate As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 8, SqlFieldName = HORGOS_CreateDate ];

/// 系统创建时间
Property HORGOSCreateTime As %Time [ InitialExpression = {$p($h,",",2)}, SqlColumnNumber = 9, SqlFieldName = HORGOS_CreateTime ];

/// 系统创建人
Property HORGOSCreateUser As User.SSUser [ SqlColumnNumber = 10, SqlFieldName = HORGOS_CreateUser ];

/// 系统排序号
Property HORGOSSeqNo As %Float [ SqlColumnNumber = 11, SqlFieldName = HORGOS_SeqNo ];

/// 系统最后更新日期
Property HORGOSLastUpdateDate As %Date [ SqlColumnNumber = 12, SqlFieldName = HORGOS_LastUpdateDate ];

/// 系统最后更新时间
Property HORGOSLastUpdateTime As %Time [ SqlColumnNumber = 13, SqlFieldName = HORGOS_LastUpdateTime ];

/// 系统最新更新人
Property HORGOSLastUpdateUser As User.SSUser [ SqlColumnNumber = 14, SqlFieldName = HORGOS_LastUpdateUser ];

/// 拼音码
Property HORGOSPYCode As %String(MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 15, SqlFieldName = HORGOS_PYCode ];

/// 五笔码
Property HORGOSWBCode As %String(MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 16, SqlFieldName = HORGOS_WBCode ];

/// 备注
Property HORGOSMark As %String(MAXLEN = 500, TRUNCATE = 1) [ SqlColumnNumber = 17, SqlFieldName = HORGOS_Mark ];

/// 索引-代码
Index IndexCode On HORGOSCode [ Unique ];

/// 索引-名称
Index IndexDesc On HORGOSDesc [ Unique ];

/// 索引-系统排序号
Index IndexSeqNo On HORGOSSeqNo;

Storage Default
{
<Data name="HOSHORGOwnerShipDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>HORGOSCode</Value>
</Value>
<Value name="3">
<Value>HORGOSDesc</Value>
</Value>
<Value name="4">
<Value>HORGOSSource</Value>
</Value>
<Value name="5">
<Value>HORGOSActivity</Value>
</Value>
<Value name="6">
<Value>HORGOSStartDate</Value>
</Value>
<Value name="7">
<Value>HORGOSEndDate</Value>
</Value>
<Value name="8">
<Value>HORGOSCreateDate</Value>
</Value>
<Value name="9">
<Value>HORGOSCreateTime</Value>
</Value>
<Value name="10">
<Value>HORGOSCreateUser</Value>
</Value>
<Value name="11">
<Value>HORGOSSeqNo</Value>
</Value>
<Value name="12">
<Value>HORGOSLastUpdateDate</Value>
</Value>
<Value name="13">
<Value>HORGOSLastUpdateTime</Value>
</Value>
<Value name="14">
<Value>HORGOSLastUpdateUser</Value>
</Value>
<Value name="15">
<Value>HORGOSPYCode</Value>
</Value>
<Value name="16">
<Value>HORGOSWBCode</Value>
</Value>
<Value name="17">
<Value>HORGOSMark</Value>
</Value>
</Data>
<DataLocation>^CT.BDP.CT.HOSHORGOwnerShipD</DataLocation>
<DefaultData>HOSHORGOwnerShipDefaultData</DefaultData>
<IdLocation>^CT.BDP.CT.HOSHORGOwnerShipD</IdLocation>
<IndexLocation>^CT.BDP.CT.HOSHORGOwnerShipI</IndexLocation>
<StreamLocation>^CT.BDP.CT.HOSHORGOwnerShipS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
