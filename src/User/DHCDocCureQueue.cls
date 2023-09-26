Class User.DHCDocCureQueue Extends (%Persistent, User.Abstract) [ ClassType = persistent, LegacyInstanceContext, Not ProcedureBlock, SqlTableName = DHC_DocCure_Queue ]
{

/// DDCQ_RBAS_Dr 预约排班
Property DDCQRBASDr As User.DHCDocCureRBCResSchdule [ SqlColumnNumber = 2, SqlFieldName = DDCQ_RBAS_Dr ];

/// DDCQ_QueName患者姓名
Property DDCQQueName As %String [ SqlColumnNumber = 3, SqlFieldName = DDCQ_QueName ];

/// DDCQ_QueNo 队列排队序号
Property DDCQQueNo As %String [ SqlColumnNumber = 4, SqlFieldName = DDCQ_QueNo ];

/// DDCQ_QueDate 预约治疗日期
Property DDCQQueDate As %Date [ SqlColumnNumber = 5, SqlFieldName = DDCQ_QueDate ];

/// DDCQ_QueTime 预约治疗时间，暂为队列生成时间，无实用
Property DDCQQueTime As %Time [ SqlColumnNumber = 6, SqlFieldName = DDCQ_QueTime ];

/// DDCQ_OperUser_Dr 队列新增用户
Property DDCQOperUserDr As User.SSUser [ SqlColumnNumber = 7, SqlFieldName = DDCQ_OperUser_Dr ];

/// DDCQ_QueDept_Dr 治疗科室
Property DDCQQueDeptDr As User.CTLoc [ SqlColumnNumber = 8, SqlFieldName = DDCQ_QueDept_Dr ];

/// DDCQ_Status_Dr 队列状态
Property DDCQStatusDr As User.DHCDocCurePerState [ SqlColumnNumber = 9, SqlFieldName = DDCQ_Status_Dr ];

/// DDCQ_StatusDate 队列状态最后变更日期
Property DDCQStatusDate As %Date [ SqlColumnNumber = 10, SqlFieldName = DDCQ_StatusDate ];

/// DDCQ_StatusTime 队列状态最后变更时间
Property DDCQStatusTime As %Time [ SqlColumnNumber = 11, SqlFieldName = DDCQ_StatusTime ];

/// DDCQ_StatusUser_Dr 队列状态最后变更用户
Property DDCQStatusUserDr As User.SSUser [ SqlColumnNumber = 12, SqlFieldName = DDCQ_StatusUser_Dr ];

/// DDCQ_PAPMI_Dr 队列患者ID
Property DDCQPAPMIDr As User.PAPatMas [ SqlColumnNumber = 13, SqlFieldName = DDCQ_PAPMI_Dr ];

/// DDCQ_QueDoc_Dr 暂未使用
Property DDCQQueDocDr As User.CTCareProv [ SqlColumnNumber = 14, SqlFieldName = DDCQ_QueDoc_Dr ];

/// DDCQ_InsertDate 队列新增日期
Property DDCQInsertDate As %Date [ SqlColumnNumber = 15, SqlFieldName = DDCQ_InsertDate ];

/// DDCQ_InsertTime 队列新增时间
Property DDCQInsertTime As %Time [ SqlColumnNumber = 16, SqlFieldName = DDCQ_InsertTime ];

/// DDCQ_DCApply_Dr 关联申请
Property DDCQDCApplyDr As User.DHCDocCureApp [ SqlColumnNumber = 17, SqlFieldName = DDCQ_DCApply_Dr ];

/// DDCQ_ReportNo 排队序号
Property DDCQReportNo As %String [ SqlColumnNumber = 18, SqlFieldName = DDCQ_ReportNo ];

/// DDCQ_CallStatus 呼叫状态
Property DDCQCallStatus As %String [ SqlColumnNumber = 19, SqlFieldName = DDCQ_CallStatus ];

/// DDCQ_CallUser_Dr 呼叫用户
Property DDCQCallUserDr As User.SSUser [ SqlColumnNumber = 20, SqlFieldName = DDCQ_CallUser_Dr ];

Index IndexDateDep On (DDCQQueDate, DDCQQueDeptDr);

Index IndexPAPMI On DDCQPAPMIDr;

Index IndexRBAS On DDCQRBASDr;

Index IndexRBASQue On (DDCQRBASDr, DDCQQueNo);

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
	d ##class(DHCDoc.DHCDocCure.Alloc).OnTrigger($g(%d(1)),"TAfterIns")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
	d ##class(DHCDoc.DHCDocCure.Alloc).OnTrigger($g(%d(1)),"TAfterUpd")
}

Method %OnAfterSave(insert As %Boolean) As %Status [ Private, ServerOnly = 1 ]
{
    i insert {
	    s sc=##class(DHCDoc.DHCDocCure.Alloc).OnTrigger(%this.%Id(),"TAfterIns")
    }else{
	    s sc=##class(DHCDoc.DHCDocCure.Alloc).OnTrigger(%this.%Id(),"TAfterUpd")
    }
    Q sc
}

Storage Default
{
<Data name="DHCDocCureQueueDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DDCQRBASDr</Value>
</Value>
<Value name="3">
<Value>DDCQQueName</Value>
</Value>
<Value name="4">
<Value>DDCQQueNo</Value>
</Value>
<Value name="5">
<Value>DDCQQueDate</Value>
</Value>
<Value name="6">
<Value>DDCQQueTime</Value>
</Value>
<Value name="7">
<Value>DDCQOperUserDr</Value>
</Value>
<Value name="8">
<Value>DDCQQueDeptDr</Value>
</Value>
<Value name="9">
<Value>DDCQStatusDr</Value>
</Value>
<Value name="10">
<Value>DDCQStatusDate</Value>
</Value>
<Value name="11">
<Value>DDCQStatusTime</Value>
</Value>
<Value name="12">
<Value>DDCQStatusUserDr</Value>
</Value>
<Value name="13">
<Value>DDCQPAPMIDr</Value>
</Value>
<Value name="14">
<Value>DDCQQueDocDr</Value>
</Value>
<Value name="15">
<Value>DDCQInsertDate</Value>
</Value>
<Value name="16">
<Value>DDCQInsertTime</Value>
</Value>
<Value name="17">
<Value>DDCQDCApplyDr</Value>
</Value>
<Value name="18">
<Value>DDCQReportNo</Value>
</Value>
<Value name="19">
<Value>DDCQCallStatus</Value>
</Value>
<Value name="20">
<Value>DDCQCallUserDr</Value>
</Value>
</Data>
<DataLocation>^User.DHCDocCureQueueD</DataLocation>
<DefaultData>DHCDocCureQueueDefaultData</DefaultData>
<IdLocation>^User.DHCDocCureQueueD</IdLocation>
<IndexLocation>^User.DHCDocCureQueueI</IndexLocation>
<StreamLocation>^User.DHCDocCureQueueS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
