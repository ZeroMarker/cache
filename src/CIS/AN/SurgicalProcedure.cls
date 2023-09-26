/// 手术过程
Class CIS.AN.SurgicalProcedure Extends %Persistent [ Final, Owner = {_SYSTEM}, SqlRowIdName = RowId, SqlTableName = SurgicalProcedure ]
{

/// 手术麻醉记录表单
Property OperSchedule As CIS.AN.OperSchedule [ Required, SqlColumnNumber = 2 ];

/// 过程代码
Property ProcedureCode As %String(DISPLAYLIST = ",手术暂存,手术申请,手术审核,手术取消,手术安排,排班撤回,麻醉安排,离开病区,入手术室,入手术间,麻醉开始,手术开始,手术结束,麻醉结束,离手术间,入PACU,离PACU,离手术室,手术完成,日间手术确认,手术登记,手术费用审核,麻醉费用审核,取消审核手术,手术拒绝,取消拒绝", VALUELIST = ",TMPS,APP,ADT,CCL,OPA,RA,ANA,WO,AI,RI,ANS,OPS,OPF,ANF,RO,PI,PO,AO,FNH,DAT,OPR,OPFEE,ANFEE,CADT,OPD,COPD") [ Required, SqlColumnNumber = 3 ];

/// 操作日期
Property ActionDate As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 4 ];

/// 操作时间
Property ActionTime As %Time [ InitialExpression = {$p($h,",",2)}, SqlColumnNumber = 5 ];

/// 操作人
Property ActionUser As %String [ SqlColumnNumber = 6 ];

/// 操作方式
Property ActionWay As %String(DISPLAYLIST = ",选择录入,扫码录入,PDA录入", VALUELIST = ",SI,CI,PI") [ SqlColumnNumber = 7 ];

/// 操作说明
Property ActionNote As %String(MAXLEN = 200) [ SqlColumnNumber = 8 ];

/// 操作顺序
Property ActionSeq As %String [ SqlColumnNumber = 9 ];

/// 更新日期
Property UpdateDate As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 10 ];

/// 更新时间
Property UpdateTime As %Time [ InitialExpression = {$p($h,",",2)}, SqlColumnNumber = 11 ];

Index IOPS On OperSchedule;

Index ICode On (OperSchedule, ProcedureCode) [ Unique ];

/// 手术申请外键约束
ForeignKey FKOperSchedule(OperSchedule) References CIS.AN.OperSchedule() [ OnDelete = cascade ];

Storage Default
{
<Data name="SurgicalProcedureDefaultData">
<Value name="1">
<Value>OperSchedule</Value>
</Value>
<Value name="2">
<Value>ProcedureCode</Value>
</Value>
<Value name="3">
<Value>ActionDate</Value>
</Value>
<Value name="4">
<Value>ActionTime</Value>
</Value>
<Value name="5">
<Value>ActionUser</Value>
</Value>
<Value name="6">
<Value>ActionWay</Value>
</Value>
<Value name="7">
<Value>ActionNote</Value>
</Value>
<Value name="8">
<Value>ActionSeq</Value>
</Value>
<Value name="9">
<Value>UpdateDate</Value>
</Value>
<Value name="10">
<Value>UpdateTime</Value>
</Value>
</Data>
<DataLocation>^CIS.AN.SurgicalProcedureD</DataLocation>
<DefaultData>SurgicalProcedureDefaultData</DefaultData>
<IdLocation>^CIS.AN.SurgicalProcedureD</IdLocation>
<IndexLocation>^CIS.AN.SurgicalProcedureI</IndexLocation>
<StreamLocation>^CIS.AN.SurgicalProcedureS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
