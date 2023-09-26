/// Creator: guozj
/// Createdate: 2017-12-19
/// Description：患者满意度调查【南方医院版】
Class DHCNMG.Survey.MgNurPatSatis Extends %Persistent
{

/// 病人登记号
Property PatPMINo As %String [ SqlColumnNumber = 2, SqlFieldName = PatPMINo ];

/// 所在病区【出院时】(ctloc表id)
Property PatWard As %String [ SqlColumnNumber = 3, SqlFieldName = Pat_Ward ];

/// 满意类型【P:操作满意 S:服务满意】
Property SatiType As %String [ SqlColumnNumber = 4, SqlFieldName = Sati_Type ];

/// 发送日期
Property SendDate As %Date [ SqlColumnNumber = 5, SqlFieldName = Send_Date ];

/// 发送时间
Property SendTime As %Time [ SqlColumnNumber = 6, SqlFieldName = Send_Time ];

/// 接收信息手机号
Property SendPhone As %String [ SqlColumnNumber = 7, SqlFieldName = Send_Phone ];

/// 出院日期
Property OutDate As %Date [ SqlColumnNumber = 8, SqlFieldName = Out_Date ];

/// 回复内容【1:满意 2:不满意  其他 】
Property ReplyType As %String [ SqlColumnNumber = 9, SqlFieldName = Reply_Type ];

/// 回复日期
Property ReplyDate As %Date [ SqlColumnNumber = 10, SqlFieldName = Reply_Date ];

/// 回复时间
Property ReplyTime As %Time [ SqlColumnNumber = 11, SqlFieldName = Reply_Time ];

/// 回访记录
Property ReplyRecord As %String(MAXLEN = 1000) [ SqlColumnNumber = 12, SqlFieldName = Reply_Record ];

/// 回访人员
Property ReplyUser As %String [ SqlColumnNumber = 13, SqlFieldName = Reply_User ];

/// 回访标识
Property ReplyFlag As %String [ SqlColumnNumber = 14, SqlFieldName = Reply_Flag ];

/// 创建人
Property CreateUser As %String [ SqlColumnNumber = 15, SqlFieldName = Create_User ];

/// 审核
Property AuditFlag As %String [ SqlColumnNumber = 16, SqlFieldName = Audit_Flag ];

/// Ext扩展码
Property Ext As %String [ SqlColumnNumber = 17, SqlFieldName = Ext ];

/// 回访日期
Property VisitDate As %Date [ SqlColumnNumber = 18, SqlFieldName = Visit_Date ];

/// 申请回访标识(N:申请 Y:通过)
Property ApplicateFlag As %String [ SqlColumnNumber = 19, SqlFieldName = Applicate_Flag ];

/// 转为满意或不满意时 患者的 回复内容
Property ConvertReply As %String [ SqlColumnNumber = 20, SqlFieldName = Convert_Reply ];

/// 转为满意或不满意的日期
Property ConvertDate As %Date [ SqlColumnNumber = 21, SqlFieldName = Convert_Date ];

/// 转为满意或不满意的操作人
Property ConvertUser As %String [ SqlColumnNumber = 22, SqlFieldName = Convert_User ];

/// 申请回访人
Property ApplicateUser As %String [ SqlColumnNumber = 23, SqlFieldName = Applicate_User ];

/// 申请回访 日期
Property ApplicateDate As %Date [ SqlColumnNumber = 24, SqlFieldName = Applicate_Date ];

/// 审批人（申请回访）HIS user表id
Property AcceptUser As %String [ SqlColumnNumber = 25, SqlFieldName = Accept_User ];

/// 审批日期
Property AcceptDate As %Date [ SqlColumnNumber = 26, SqlFieldName = Accept_Date ];

/// 入院日期
Property AdmInDate As %Date [ SqlColumnNumber = 27, SqlFieldName = Adm_InDate ];

Index Date On (OutDate, PatPMINo, SatiType);

Index Type On (Ext, SendPhone, SendDate);

Index SType On (OutDate, PatWard, SatiType);

Index stdate On OutDate;

Index send On SendDate;

Index loc On (PatWard, OutDate);

Storage Default
{
<Data name="MgNurPatSatisDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>PatName</Value>
</Value>
<Value name="3">
<Value>PatWard</Value>
</Value>
<Value name="4">
<Value>SatiType</Value>
</Value>
<Value name="5">
<Value>SendDate</Value>
</Value>
<Value name="6">
<Value>SendTime</Value>
</Value>
<Value name="7">
<Value>SendPhone</Value>
</Value>
<Value name="8">
<Value>ReplyType</Value>
</Value>
<Value name="9">
<Value>ReplyDate</Value>
</Value>
<Value name="10">
<Value>ReplyTime</Value>
</Value>
<Value name="11">
<Value>ReplyRecord</Value>
</Value>
<Value name="12">
<Value>ReplyUser</Value>
</Value>
<Value name="13">
<Value>PatPMINo</Value>
</Value>
<Value name="14">
<Value>ReplyFlag</Value>
</Value>
<Value name="15">
<Value>CreateUser</Value>
</Value>
<Value name="16">
<Value>AuditFlag</Value>
</Value>
<Value name="17">
<Value>OutDate</Value>
</Value>
<Value name="18">
<Value>Ext</Value>
</Value>
<Value name="19">
<Value>VisitDate</Value>
</Value>
<Value name="20">
<Value>ApplicateFlag</Value>
</Value>
<Value name="21">
<Value>ConvertReply</Value>
</Value>
<Value name="22">
<Value>ConvertDate</Value>
</Value>
<Value name="23">
<Value>ConvertUser</Value>
</Value>
<Value name="24">
<Value>ApplicateUser</Value>
</Value>
<Value name="25">
<Value>ApplicateDate</Value>
</Value>
<Value name="26">
<Value>AcceptUser</Value>
</Value>
<Value name="27">
<Value>AcceptDate</Value>
</Value>
<Value name="28">
<Value>AdmInDate</Value>
</Value>
</Data>
<DataLocation>^DHCNMG.Survey.MgNurPatSatisD</DataLocation>
<DefaultData>MgNurPatSatisDefaultData</DefaultData>
<IdLocation>^DHCNMG.Survey.MgNurPatSatisD</IdLocation>
<IndexLocation>^DHCNMG.Survey.MgNurPatSatisI</IndexLocation>
<StreamLocation>^DHCNMG.Survey.MgNurPatSatisS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
