/// Function: 医生站业务数据修改申请记录
Class User.DHCDocDataChangeApply Extends (%Persistent, %XML.Adaptor) [ SqlTableName = DHC_DocDataChangeApply, StorageStrategy = NewStorage1 ]
{

/// 申请修改数据表名称，写入的是BDP_DataChangeLog 
Property ApplyTableName As %String(MAXLEN = "") [ Required ];

/// 申请修改数据表说明
Property ApplyTableNameDesc As %String(MAXLEN = "") [ Required ];

/// 申请修改数据对象的RowID或者表的RowID
Property ApplyObjectReference As %String(MAXLEN = "") [ Required ];

/// 申请人
Property ApplyUserDr As User.SSUser [ Required ];

/// 申请日期
Property ApplyDate As %Date [ InitialExpression = {+$h}, Required ];

/// 申请时间
Property ApplyTime As %Time [ InitialExpression = {+$p($h,",",2)}, Required ];

/// 申请前json数据
Property ApplyOldValue As %String(MAXLEN = "");

/// 申请修改后json数据
Property ApplyNewValue As %String(MAXLEN = "");

/// 状态 申请(Apply) 审核(Pass) 拒绝(Refuse) 撤销申请(Cancel)
Property ApplyStatus As %String(DISPLAYLIST = ",Apply,Pass,Refuse,Cancel", VALUELIST = ",A,P,R,C") [ Required ];

/// 审核/拒绝/撤销申请日期
Property UpdateDate As %Date [ InitialExpression = {+$h}, Required ];

/// 审核/拒绝/撤销申请时间
Property UpdateTime As %Time [ InitialExpression = {+$p($h,",",2)}, Required ];

/// 审核/拒绝/撤销申请时间
Property UpdateUserDr As User.SSUser;

/// 拒绝原因
Property RefuseReason As %String(MAXLEN = "");

Index TableNameIndex On ApplyTableName;

/// 申请日期索引
Index ApplyDateIndex On ApplyDate;

/// 修正日期的索引
Index UpdateDateIndex On UpdateDate;

/// 状态索引
Index ApplyStatusIndex On ApplyStatus;

/// 操作对应的索引
Index ApplyObjectReferenceIndex On ApplyObjectReference;

/// 申请日期数据表索引
Index ApplyDateTableNameIndex On (ApplyDate, ApplyTableName);

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(web.DHCDocDataChangeApplyLog).OnTrigger($g(%d(1)),"TAfterIns")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(web.DHCDocDataChangeApplyLog).OnTrigger($g(%d(1)),"TAfterUpd")
}

Storage NewStorage1
{
<Data name="DHCDocDataChangeApplyDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ApplyTableName</Value>
</Value>
<Value name="3">
<Value>ApplyTableNameDesc</Value>
</Value>
<Value name="4">
<Value>ApplyObjectReference</Value>
</Value>
<Value name="5">
<Value>ApplyUserDr</Value>
</Value>
<Value name="6">
<Value>ApplyDate</Value>
</Value>
<Value name="7">
<Value>ApplyTime</Value>
</Value>
<Value name="8">
<Value>ApplyOldValue</Value>
</Value>
<Value name="9">
<Value>ApplyNewValue</Value>
</Value>
<Value name="10">
<Value>ApplyStatus</Value>
</Value>
<Value name="11">
<Value>UpdateDate</Value>
</Value>
<Value name="12">
<Value>UpdateTime</Value>
</Value>
<Value name="13">
<Value>RefuseReason</Value>
</Value>
<Value name="14">
<Value>UpdateUserDr</Value>
</Value>
</Data>
<DataLocation>^User.DHCDocDataChangeApplyD</DataLocation>
<DefaultData>DHCDocDataChangeApplyDefaultData</DefaultData>
<IdLocation>^User.DHCDocDataChangeApplyD</IdLocation>
<IndexLocation>^User.DHCDocDataChangeApplyI</IndexLocation>
<StreamLocation>^User.DHCDocDataChangeApplyS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
