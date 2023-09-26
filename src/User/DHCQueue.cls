Class User.DHCQueue Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, LegacyInstanceContext, Not ProcedureBlock, SqlTableName = DHCQueue ]
{

Index QueComDate On (QueDate, QueExabDr, QueMarkDr, QueStateDr);

Index QueCompDrIndex On QueCompDr;

Index QueDateDeptIndex On (QueDate, QueDepDr);

Index QueDateIndex On QueDate;

Index QueDepDrIndex On QueDepDr;

Index QueDocDrIndex On QueDocDr;

Index QueMarkDrIndex On (QueDate, QueMarkDr);

Index QuePaadmDrIndex On QuePaadmDr;

Index QuePersonIdIndex On QuePersonId;

Index QueRoomDrIndex On QueRoomDr;

/// 最后操作人
Property Operuserid As User.SSUser [ SqlColumnNumber = 2, SqlFieldName = Operuserid ];

Property QueCalled As %String(TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = QueCalled ];

Property QueCompDr As %String(TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = QueCompDr ];

Property QueDate As %Date [ SqlColumnNumber = 5, SqlFieldName = QueDate ];

Property QueDepDr As User.CTLoc [ SqlColumnNumber = 6, SqlFieldName = QueDepDr ];

Property QueDocDr As User.CTCareProv [ SqlColumnNumber = 7, SqlFieldName = QueDocDr ];

Property QueExabDr As DHCExaBorough [ SqlColumnNumber = 8, SqlFieldName = QueExabDr ];

Property QueFirstDr As DHCFirstCode [ SqlColumnNumber = 9, SqlFieldName = QueFirstDr ];

Property QueMarkDr As User.CTCareProv [ SqlColumnNumber = 10, SqlFieldName = QueMarkDr ];

Property QueName As %String(TRUNCATE = 1) [ SqlColumnNumber = 11, SqlFieldName = QueName ];

Property QueNo As %String(TRUNCATE = 1) [ SqlColumnNumber = 12, SqlFieldName = QueNo ];

Property QuePaadmDr As PAAdm [ SqlColumnNumber = 13, SqlFieldName = QuePaadmDr ];

Property QuePersonId As %String(TRUNCATE = 1) [ SqlColumnNumber = 14, SqlFieldName = QuePersonId ];

Property QueRoomDr As User.CTLoc [ SqlColumnNumber = 15, SqlFieldName = QueRoomDr ];

Property QueStateDr As DHCPerState [ SqlColumnNumber = 16, SqlFieldName = QueStateDr ];

/// 最后状态改变时间
Property QueStateTime As %Time [ SqlColumnNumber = 17, SqlFieldName = QueStateTime ];

/// 门诊会诊标识
Property QueConsultFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 18, SqlFieldName = QueConsultFlag ];

/// 最后状态改变日期
Property QueStateDate As %Date [ SqlColumnNumber = 19, SqlFieldName = QueStateDate ];

/// 创建时间
Property QueTime As %Time [ SqlColumnNumber = 20, SqlFieldName = QueTime ];

/// 二次分诊
Property ChangeDepDr As %String(TRUNCATE = 1) [ SqlColumnNumber = 21, SqlFieldName = ChangeDepDr ];

Property Comm1 As %String(TRUNCATE = 1) [ SqlColumnNumber = 22, SqlFieldName = Comm1 ];

Property Comm2 As %String(TRUNCATE = 1) [ SqlColumnNumber = 23, SqlFieldName = Comm2 ];

/// 是否采血(IVF流程)
Property QueIsBloodColl As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 24, SqlFieldName = QueIsBloodColl ];

/// 采血叫号状态(IVF流程叫号)
Property QueBloodCollCalled As %String(TRUNCATE = 1) [ SqlColumnNumber = 25, SqlFieldName = QueBloodCollCalled ];

/// B超叫号状态(IVF流程叫号)
Property QueBCCalled As %String(TRUNCATE = 1) [ SqlColumnNumber = 26, SqlFieldName = QueBCCalled ];

/// 是否被呼叫过，若科室扩展设置启用【不呼叫禁止医生接诊】需用到该字段
Property QueEverCalled As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 27, SqlFieldName = QueEverCalled ];

/// 等候呼叫时间
Property QueWaitCallDate As %Date [ SqlColumnNumber = 28, SqlFieldName = QueWaitCallDate ];

/// 等候呼叫时间
Property QueWaitCallTime As %Time [ SqlColumnNumber = 29, SqlFieldName = QueWaitCallTime ];

/// 优先原因
Property QueFirstReason As %String(TRUNCATE = 1) [ SqlColumnNumber = 30, SqlFieldName = QueFirstReason ];

/// 呼叫时间
Property QueCallDate As %Date [ SqlColumnNumber = 31, SqlFieldName = QueCallDate ];

/// 呼叫时间
Property QueCallTime As %Time [ SqlColumnNumber = 32, SqlFieldName = QueCallTime ];

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(web.DHCQueueStatus).OnTrigger($g(%d(1)),"TAfterIns")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(web.DHCQueueStatus).OnTrigger($g(%d(1)),"TAfterUpd")
}

Method %OnAfterSave(insert As %Boolean) As %Status [ Private, ServerOnly = 1 ]
{
    i insert {
	    s sc=##Class(web.DHCQueueStatus).OnTrigger(%this.%Id(),"TAfterIns")
    }else{
	    s sc=##Class(web.DHCQueueStatus).OnTrigger(%this.%Id(),"TAfterUpd")
    }
    
    Q sc
}

Storage Default
{
<Data name="DHCQueueDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>QueCompDr</Value>
</Value>
<Value name="3">
<Value>QueDate</Value>
</Value>
<Value name="4">
<Value>QueDepDr</Value>
</Value>
<Value name="5">
<Value>QueDocDr</Value>
</Value>
<Value name="6">
<Value>QueExabDr</Value>
</Value>
<Value name="7">
<Value>QueFirstDr</Value>
</Value>
<Value name="8">
<Value>QueMarkDr</Value>
</Value>
<Value name="9">
<Value>QueName</Value>
</Value>
<Value name="10">
<Value>QueNo</Value>
</Value>
<Value name="11">
<Value>QuePaadmDr</Value>
</Value>
<Value name="12">
<Value>QuePersonId</Value>
</Value>
<Value name="13">
<Value>QueRoomDr</Value>
</Value>
<Value name="14">
<Value>QueStateDr</Value>
</Value>
<Value name="15">
<Value>Operuserid</Value>
</Value>
<Value name="16">
<Value>QueCalled</Value>
</Value>
<Value name="17">
<Value>QueStateTime</Value>
</Value>
<Value name="18">
<Value>QueConsultFlag</Value>
</Value>
<Value name="19">
<Value>QueStateDate</Value>
</Value>
<Value name="20">
<Value>QueTime</Value>
</Value>
<Value name="21">
<Value>QueStatusDate</Value>
</Value>
<Value name="22">
<Value>QueStatusTime</Value>
</Value>
<Value name="23">
<Value>ChangeDepDr</Value>
</Value>
<Value name="24">
<Value>Comm1</Value>
</Value>
<Value name="25">
<Value>Comm2</Value>
</Value>
<Value name="26">
<Value>QueIsBloodColl</Value>
</Value>
<Value name="27">
<Value>QueBloodCollCalled</Value>
</Value>
<Value name="28">
<Value>QueBCCalled</Value>
</Value>
<Value name="29">
<Value>QueEverCalled</Value>
</Value>
<Value name="30">
<Value>QueWaitCallDate</Value>
</Value>
<Value name="31">
<Value>QueWaitCallTime</Value>
</Value>
<Value name="32">
<Value>QueFirstReason</Value>
</Value>
<Value name="33">
<Value>QueCallDate</Value>
</Value>
<Value name="34">
<Value>QueCallTime</Value>
</Value>
</Data>
<DataLocation>^User.DHCQueueD</DataLocation>
<DefaultData>DHCQueueDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCQueueD</IdLocation>
<IndexLocation>^User.DHCQueueI</IndexLocation>
<StreamLocation>^User.DHCQueueS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
