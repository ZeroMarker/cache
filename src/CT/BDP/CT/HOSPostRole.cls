/// 描述:岗位角色字典=岗位关联角色
/// 创建人：基础数据平台 陈莹
/// 创建日期：2022-09-22
Class CT.BDP.CT.HOSPostRole Extends (%Persistent, User.Abstract) [ SqlTableName = HOS_PostRole ]
{

/// 岗位代码-外键
Property POROPOSTCode As CT.BDP.CT.HOSPost [ Required, SqlColumnNumber = 2, SqlFieldName = PORO_POSTCode ];

/// 角色代码-外键=安全组
Property POROROLECode As User.SSGroup [ Required, SqlColumnNumber = 3, SqlFieldName = PORO_ROLECode ];

/// 是否有效(Y/N)
Property POROActivity As %String [ InitialExpression = "Y", SqlColumnNumber = 4, SqlFieldName = PORO_Activity ];

/// 开始日期
Property POROStartDate As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 5, SqlFieldName = PORO_StartDate ];

/// 结束日期
Property POROEndDate As %Date [ SqlColumnNumber = 6, SqlFieldName = PORO_EndDate ];

/// 系统创建日期
Property POROCreateDate As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 7, SqlFieldName = PORO_CreateDate ];

/// 系统创建时间
Property POROCreateTime As %Time [ InitialExpression = {$p($h,",",2)}, SqlColumnNumber = 8, SqlFieldName = PORO_CreateTime ];

/// 系统创建人
Property POROCreateUser As User.SSUser [ SqlColumnNumber = 9, SqlFieldName = PORO_CreateUser ];

/// 系统排序号
Property POROSeqNo As %Float [ SqlColumnNumber = 10, SqlFieldName = PORO_SeqNo ];

/// 系统最后更新日期
Property POROLastUpdateDate As %Date [ SqlColumnNumber = 11, SqlFieldName = PORO_LastUpdateDate ];

/// 系统最后更新时间
Property POROLastUpdateTime As %Time [ SqlColumnNumber = 12, SqlFieldName = PORO_LastUpdateTime ];

/// 系统最新更新人
Property POROLastUpdateUser As User.SSUser [ SqlColumnNumber = 13, SqlFieldName = PORO_LastUpdateUser ];

/// 拼音码
Property POROPYCode As %String(MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 14, SqlFieldName = PORO_PYCode ];

/// 五笔码
Property POROWBCode As %String(MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 15, SqlFieldName = PORO_WBCode ];

/// 备注
Property POROMark As %String(MAXLEN = 500, TRUNCATE = 1) [ SqlColumnNumber = 16, SqlFieldName = PORO_Mark ];

/// 索引-岗位代码 +角色代码
Index IndexPOSTROLE On (POROPOSTCode, POROROLECode) [ Unique ];

/// 索引-岗位代码
Index IndexPOSTCode On POROPOSTCode;

/// 索引-角色代码
Index IndexROLECode On POROROLECode;

/// 索引-系统排序号
Index IndexSeqNo On POROSeqNo;

Storage Default
{
<Data name="HOSPostRoleDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>POROPOSTCode</Value>
</Value>
<Value name="3">
<Value>POROROLECode</Value>
</Value>
<Value name="4">
<Value>POROActivity</Value>
</Value>
<Value name="5">
<Value>POROStartDate</Value>
</Value>
<Value name="6">
<Value>POROEndDate</Value>
</Value>
<Value name="7">
<Value>POROCreateDate</Value>
</Value>
<Value name="8">
<Value>POROCreateTime</Value>
</Value>
<Value name="9">
<Value>POROCreateUser</Value>
</Value>
<Value name="10">
<Value>POROSeqNo</Value>
</Value>
<Value name="11">
<Value>POROLastUpdateDate</Value>
</Value>
<Value name="12">
<Value>POROLastUpdateTime</Value>
</Value>
<Value name="13">
<Value>POROLastUpdateUser</Value>
</Value>
<Value name="14">
<Value>POROPYCode</Value>
</Value>
<Value name="15">
<Value>POROWBCode</Value>
</Value>
<Value name="16">
<Value>POROMark</Value>
</Value>
</Data>
<DataLocation>^CT.BDP.CT.HOSPostRoleD</DataLocation>
<DefaultData>HOSPostRoleDefaultData</DefaultData>
<IdLocation>^CT.BDP.CT.HOSPostRoleD</IdLocation>
<IndexLocation>^CT.BDP.CT.HOSPostRoleI</IndexLocation>
<StreamLocation>^CT.BDP.CT.HOSPostRoleS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
