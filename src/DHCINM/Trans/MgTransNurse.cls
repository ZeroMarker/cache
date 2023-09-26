/// Creater:wangcc
/// Descriptions:调配详情表
/// Date:2020-07-22
Class DHCINM.Trans.MgTransNurse Extends %Persistent
{

/// 计划性调配ID (仅计划性调配保存)
Property AppId As %String [ SqlColumnNumber = 2, SqlFieldName = Nurse_AppId ];

/// 护士ID
Property NurseId As %String [ SqlColumnNumber = 3, SqlFieldName = Nurse_NurseId ];

/// 转出病区
Property OutWard As %String [ SqlColumnNumber = 4, SqlFieldName = Nurse_OutWard ];

/// 转入病区
Property InWard As %String [ SqlColumnNumber = 5, SqlFieldName = Nurse_InWard ];

/// 调配类型(Plan :计划性调配  S:随机性调配)
Property TransType As %String [ SqlColumnNumber = 6, SqlFieldName = Nurse_TransType ];

/// 调配开始日期
Property TransStDate As %Date [ SqlColumnNumber = 7, SqlFieldName = Nurse_TransStDate ];

/// 调配结束日期
Property TransEndDate As %Date [ SqlColumnNumber = 8, SqlFieldName = Nurse_TransEndDate ];

/// 调配天数
Property TransDays As %String [ SqlColumnNumber = 9, SqlFieldName = Nurse_TransDays ];

/// 调配人
Property ActionPer As %String [ SqlColumnNumber = 10, SqlFieldName = Nurse_ActionPer ];

/// 调配原因 (仅随机性调配保存)
Property TransReason As %String [ SqlColumnNumber = 11, SqlFieldName = Nurse_TransReason ];

/// 创建日期
Property CreateDate As %Date [ InitialExpression = {+$p($h,",",1)}, SqlColumnNumber = 12, SqlFieldName = Nurse_CreateDate ];

/// 状态
Property NurseStatus As %String [ SqlColumnNumber = 13, SqlFieldName = Nurse_Status ];

Index app On AppId;

Index type On (TransType, AppId);

Index ssid On NurseId;

Storage Default
{
<Data name="MgTransNurseDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>AppId</Value>
</Value>
<Value name="3">
<Value>NurseId</Value>
</Value>
<Value name="4">
<Value>OutWard</Value>
</Value>
<Value name="5">
<Value>InWard</Value>
</Value>
<Value name="6">
<Value>TransType</Value>
</Value>
<Value name="7">
<Value>TransStDate</Value>
</Value>
<Value name="8">
<Value>TransEndDate</Value>
</Value>
<Value name="9">
<Value>TransDays</Value>
</Value>
<Value name="10">
<Value>ActionPer</Value>
</Value>
<Value name="11">
<Value>TransReason</Value>
</Value>
<Value name="12">
<Value>CreateDate</Value>
</Value>
<Value name="13">
<Value>NurseStatus</Value>
</Value>
</Data>
<DataLocation>^DHCINM.Trans.MgTransNurseD</DataLocation>
<DefaultData>MgTransNurseDefaultData</DefaultData>
<IdLocation>^DHCINM.Trans.MgTransNurseD</IdLocation>
<IndexLocation>^DHCINM.Trans.MgTransNurseI</IndexLocation>
<StreamLocation>^DHCINM.Trans.MgTransNurseS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
