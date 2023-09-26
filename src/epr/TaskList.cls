Class epr.TaskList Extends (%Library.Persistent, websys.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 372;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "ID";

Parameter SQLDESCRIPTION = "ID";

Parameter SQLROWID = "ID";

Property TaskItemDR As epr.Task;

Property AssignedToDetails As %Library.String(MAXLEN = 99999, TRUNCATE = 1);

Property PatientDetails As %Library.String(MAXLEN = 99999, TRUNCATE = 1);

Property Comments As %String(MAXLEN = 99999, TRUNCATE = 1);

Property PriorityDR As User.OECPriority;

Property WardDetails As %Library.String(MAXLEN = 99999, TRUNCATE = 1);

Property ScheduledDate As %Library.Date;

Property ScheduledTime As %Library.Time;

Property DurationDR As User.PHCDuration;

Property FrequencyDR As User.PHCFreq;

Property EscalateAfter As %String(TRUNCATE = 1);

Property EscalateTimeUnit As %String(TRUNCATE = 1);

Property Reminder As %String(TRUNCATE = 1);

Property ReminderTimeUnit As %String(TRUNCATE = 1);

Property UserDR As User.SSUser;

Property ExecutionDate As %Library.Date;

Property ExecutionTime As %Library.Time;

Property ExecutedBy As User.CTCareProv;

Property AdminStatus As %String(TRUNCATE = 1);

Property ExecNotes As %String(MAXLEN = 99999, TRUNCATE = 1);

Property ReasonNotComplete As User.MRCVarianceReason;

Property AssignedDate As %Library.Date;

Property AssignedTime As %Library.Time;

Index Status On (AssignedToDetails, AdminStatus, ScheduledDate, ScheduledTime);

Index ASSINGINGUSER On (UserDR, AdminStatus, ScheduledDate, ScheduledTime);

/// used by component to get long text area field 
ClassMethod GetlongTextField(txt As %Library.String = "", delimiter As %Library.String = "", DisplayOnly As %Library.String = "", FieldName As %Library.String = "") As %Library.String
{
}

ClassMethod CheckOverdue(CareProviderDR As %Library.String, TaskStatus As %Library.String) As %Library.String
{
}

ClassMethod websysSaveTaskExec(compref As %String, ByRef id As %String = "")
{
}

ClassMethod websysSaveTask(compref As %String, ByRef id As %String = "", UserID As %String = "")
{
}

ClassMethod ListTasksClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = ListTasksFetch ]
{
}

ClassMethod ListTasksExecute(ByRef QHandle As %Library.Binary, DateFrom As %Library.String = "", DateTo As %Library.String = "", TimeFrom As %Library.String = "", TimeTo As %Library.String = "", CareProviderDR As %Library.String = "", TaskStatus As %Library.String = "", OECPRDesc As %Library.String = "") As %Library.Status
{
}

ClassMethod ListTasksFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = ListTasksExecute ]
{
}

ClassMethod ListSessionTasksClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = ListSessionTasksFetch ]
{
}

ClassMethod ListSessionTasksExecute(ByRef QHandle As %Library.Binary, DateFrom As %Library.String = "", DateTo As %Library.String = "", TimeFrom As %Library.String = "", TimeTo As %Library.String = "", CareProvider As %Library.String = "", TaskStatus As %Library.String = "", Priority As %Library.String = "") As %Library.Status
{
}

ClassMethod ListSessionTasksFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = ListSessionTasksExecute ]
{
}

ClassMethod TaskUserLookupBroker(itmjs As %String = "", itmjsex As %String = "", val As %String = "", ID As %Library.String = "")
{
}

ClassMethod TaskUserLookupClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = TaskUserLookupFetch ]
{
}

ClassMethod TaskUserLookupExecute(ByRef QHandle As %Library.Binary, val As %Library.String = "", ID As %Library.String = "") As %Library.Status
{
}

ClassMethod TaskUserLookupFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = TaskUserLookupExecute ]
{
}

ClassMethod ListOverdueTasksClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = ListOverdueTasksFetch ]
{
}

ClassMethod ListOverdueTasksExecute(ByRef QHandle As %Library.Binary, CareProviderDR As %Library.String = "") As %Library.Status
{
}

ClassMethod ListOverdueTasksFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = ListOverdueTasksExecute ]
{
}

Query ListOverdueTasks(CareProviderDR As %Library.String) As %Library.Query(CONTAINID = 0, ROWSPEC = "RowID:%Library.String,ExecutionDate:%Library.String,ExecutionTime:%Library.String,Task:%Library.String,AssignedTo:%Library.String,Patient:%Library.String,ShortComments:%Library.String,LongComments:%Library.String,Priority:%Library.String,Ward:%Library.String,Duration:%Library.String,Frequency:%Library.String,EscalateAfter:%Library.String")
{
}

Query TaskUserLookup(val As %Library.String, ID As %Library.String) As %Library.Query(CONTAINID = 0, ROWSPEC = "Desc:%Library.String,HIDDEN:%Library.String,Code:%Library.String")
{
}

Query ListTasks(DateFrom As %Library.String, DateTo As %Library.String, TimeFrom As %Library.String, TimeTo As %Library.String, CareProviderDR As %Library.String, TaskStatus As %Library.String, OECPRDesc As %Library.String) As %Library.Query(CONTAINID = 0, ROWSPEC = "RowID:%Library.String,ExecutionDate:%Library.String,ExecutionTime:%Library.String,Task:%Library.String,AssignedTo:%Library.String,Patient:%Library.String,ShortComments:%Library.String,LongComments:%Library.String,Priority:%Library.String,Ward:%Library.String,Duration:%Library.String,Frequency:%Library.String,EscalateAfter:%Library.String,AssignedBy:%Library.String,AssignedDate:%Library.String,AssignedTime:%Library.String,TaskStatusDesc:%Library.String")
{
}

Query ListSessionTasks() As %Library.Query(CONTAINID = 0, ROWSPEC = "RowID:%Library.String,ExecutionDate:%Library.String,ExecutionTime:%Library.String,Task:%Library.String,AssignedTo:%Library.String,Patient:%Library.String,Comments:%Library.String,Priority:%Library.String,Ward:%Library.String,EndDate:%Library.String,Duration:%Library.String,Frequency:%Library.String,EscalateAfter:%Library.String")
{
}

Storage Default
{
<Data name="TaskListDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>AssignedToDetails</Value>
</Value>
<Value name="3">
<Value>Comments</Value>
</Value>
<Value name="4">
<Value>DurationDR</Value>
</Value>
<Value name="5">
<Value>EndDate</Value>
</Value>
<Value name="6">
<Value>EscalateAfter</Value>
</Value>
<Value name="7">
<Value>EscalateTimeUnit</Value>
</Value>
<Value name="8">
<Value>FrequencyDR</Value>
</Value>
<Value name="9">
<Value>PatientDetails</Value>
</Value>
<Value name="10">
<Value>PriorityDR</Value>
</Value>
<Value name="11">
<Value>Reminder</Value>
</Value>
<Value name="12">
<Value>ReminderTimeUnit</Value>
</Value>
<Value name="13">
<Value>StartDate</Value>
</Value>
<Value name="14">
<Value>StartTime</Value>
</Value>
<Value name="15">
<Value>TaskItemDR</Value>
</Value>
<Value name="16">
<Value>UserDR</Value>
</Value>
<Value name="17">
<Value>WardDetails</Value>
</Value>
<Value name="18">
<Value>AdminStatus</Value>
</Value>
<Value name="19">
<Value>AssignedDate</Value>
</Value>
<Value name="20">
<Value>AssignedTime</Value>
</Value>
<Value name="21">
<Value>ExecNotes</Value>
</Value>
<Value name="22">
<Value>ExecutedBy</Value>
</Value>
<Value name="23">
<Value>ExecutionDate</Value>
</Value>
<Value name="24">
<Value>ExecutionTime</Value>
</Value>
<Value name="25">
<Value>ReasonNotComplete</Value>
</Value>
<Value name="26">
<Value>ScheduledDate</Value>
</Value>
<Value name="27">
<Value>ScheduledTime</Value>
</Value>
</Data>
<DataLocation>^epr.TaskListD</DataLocation>
<DefaultData>TaskListDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^epr.TaskListD</IdLocation>
<IndexLocation>^epr.TaskListI</IndexLocation>
<StreamLocation>^epr.TaskListS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
