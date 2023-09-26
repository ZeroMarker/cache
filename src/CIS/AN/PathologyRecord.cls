/// 病理申请记录
Class CIS.AN.PathologyRecord Extends %Persistent [ Final, Owner = {_SYSTEM}, SqlRowIdName = RowId, SqlTableName = PathologyRecord ]
{

/// 手术申请
Property OperSchedule As CIS.AN.OperSchedule [ SqlColumnNumber = 2 ];

/// 病理申请单号
Property FlowID As %String [ Required, SqlColumnNumber = 3 ];

/// 是否冰冻
Property Frost As %String [ SqlColumnNumber = 4 ];

/// 病理申请日期
Property AppDate As %Date [ SqlColumnNumber = 5 ];

/// 病理申请时间
Property AppTime As %Time [ SqlColumnNumber = 6 ];

/// 病理申请医生
Property AppDoc As %String [ SqlColumnNumber = 7 ];

/// 病理检查状态代码
Property RptStatusCode As %String [ SqlColumnNumber = 8 ];

/// 病理检查状态名称
Property RptStatusDesc As %String [ SqlColumnNumber = 9 ];

/// 病理诊断结果
Property DiagRes As %String [ SqlColumnNumber = 10 ];

/// 病理科接收日期
Property RecvDate As %Date [ SqlColumnNumber = 11 ];

/// 病理科接收时间
Property RecvTime As %Time [ SqlColumnNumber = 12 ];

/// 病理科接收人
Property RecvDoc As %String [ SqlColumnNumber = 13 ];

/// 患者就诊ID
Property EpisodeID As %String [ SqlColumnNumber = 14 ];

/// 病理医嘱名称
Property OrderDesc As %String(MAXLEN = 500) [ SqlColumnNumber = 15 ];

/// 病理医嘱ID
Property OrderID As %String [ SqlColumnNumber = 16 ];

/// 临床病历
Property EMRRecord As %String(MAXLEN = 500) [ SqlColumnNumber = 17 ];

/// 手术所见
Property SurgicalRecord As %String(MAXLEN = 500) [ SqlColumnNumber = 18 ];

/// 临床诊断
Property AdmDiagnosis As %String(MAXLEN = 500) [ SqlColumnNumber = 19 ];

/// 感染信息（HIV、HCV、梅毒等)
Property Infection As %String [ SqlColumnNumber = 20 ];

/// 分子学检测
Property Molecules As %String [ SqlColumnNumber = 21 ];

/// 申请科室
Property AppDept As %String [ SqlColumnNumber = 22 ];

/// 接收科室
Property RecvDept As %String [ SqlColumnNumber = 23 ];

/// 是否加急
Property Urgent As %String [ SqlColumnNumber = 24 ];

/// 标本离体日期
Property OutDate As %Date [ SqlColumnNumber = 25 ];

/// 标本离体时间
Property OutTime As %Time [ SqlColumnNumber = 26 ];

/// 标本固定日期
Property FixedDate As %Date [ SqlColumnNumber = 27 ];

/// 标本固定时间
Property FixedTime As %Time [ SqlColumnNumber = 28 ];

/// 取材科室
Property QCDept As %String [ SqlColumnNumber = 29 ];

/// 取材医护人员
Property QCCareProv As %String [ SqlColumnNumber = 30 ];

/// 加急标志
Property EmgFlag As %String [ SqlColumnNumber = 31 ];

/// 普通标志
Property CommonFlag As %String [ SqlColumnNumber = 32 ];

/// 外部系统ID
Property ExternalID As %String [ SqlColumnNumber = 33 ];

/// 手术申请索引
Index IOPS On OperSchedule;

/// 外部系统ID索引
Index IExt On ExternalID;

/// 病理申请流水号索引
Index IFlow On FlowID [ Unique ];

/// 就诊ID索引
Index IAdm On EpisodeID;

/// 病理申请医嘱索引
Index IOrder On OrderID;

Storage Default
{
<Data name="PathologyRecordDefaultData">
<Value name="1">
<Value>OperSchedule</Value>
</Value>
<Value name="2">
<Value>FlowID</Value>
</Value>
<Value name="3">
<Value>Frost</Value>
</Value>
<Value name="4">
<Value>AppDate</Value>
</Value>
<Value name="5">
<Value>AppTime</Value>
</Value>
<Value name="6">
<Value>AppDoc</Value>
</Value>
<Value name="7">
<Value>RptStatusCode</Value>
</Value>
<Value name="8">
<Value>RptStatusDesc</Value>
</Value>
<Value name="9">
<Value>DiagRes</Value>
</Value>
<Value name="10">
<Value>RecvDate</Value>
</Value>
<Value name="11">
<Value>RecvTime</Value>
</Value>
<Value name="12">
<Value>RecvDoc</Value>
</Value>
<Value name="13">
<Value>EpisodeID</Value>
</Value>
<Value name="14">
<Value>OrderDesc</Value>
</Value>
<Value name="15">
<Value>OrderID</Value>
</Value>
<Value name="16">
<Value>EMRRecord</Value>
</Value>
<Value name="17">
<Value>SurgicalRecord</Value>
</Value>
<Value name="18">
<Value>AdmDiagnosis</Value>
</Value>
<Value name="19">
<Value>Infection</Value>
</Value>
<Value name="20">
<Value>Molecules</Value>
</Value>
<Value name="21">
<Value>AppDept</Value>
</Value>
<Value name="22">
<Value>RecvDept</Value>
</Value>
<Value name="23">
<Value>Urgent</Value>
</Value>
<Value name="24">
<Value>OutDate</Value>
</Value>
<Value name="25">
<Value>OutTime</Value>
</Value>
<Value name="26">
<Value>FixedDate</Value>
</Value>
<Value name="27">
<Value>FixedTime</Value>
</Value>
<Value name="28">
<Value>QCDept</Value>
</Value>
<Value name="29">
<Value>QCCareProv</Value>
</Value>
<Value name="30">
<Value>EmgFlag</Value>
</Value>
<Value name="31">
<Value>CommonFlag</Value>
</Value>
<Value name="32">
<Value>ExternalID</Value>
</Value>
</Data>
<DataLocation>^CIS.AN.PathologyRecordD</DataLocation>
<DefaultData>PathologyRecordDefaultData</DefaultData>
<IdLocation>^CIS.AN.PathologyRecordD</IdLocation>
<IndexLocation>^CIS.AN.PathologyRecordI</IndexLocation>
<StreamLocation>^CIS.AN.PathologyRecordS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
