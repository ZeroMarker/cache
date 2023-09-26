/// Creater:wangpf
/// Descriptions:病例讨论
/// Date:2020-07-04
Class DHCINM.HB.MgCaseDiscuss Extends %Persistent
{

/// 查房类型 1:疑难病例 2:危重病例 3:抢救病例 4:死亡病例
Property DiscussType As %Integer [ SqlColumnNumber = 2, SqlFieldName = Discuss_Type ];

/// 主持人
Property DiscussHost As CF.DHCINM.HR.Persons [ SqlColumnNumber = 3, SqlFieldName = Discuss_Host ];

/// 讨论日期
Property DiscussDate As %Date [ SqlColumnNumber = 4, SqlFieldName = Discuss_Date ];

/// 参与人
Property DiscussParticipant As list Of %String [ SqlColumnNumber = 5, SqlFieldName = Discuss_Participant ];

/// 患者主表
Property DiscussPAPatMas As User.PAPatMas [ SqlColumnNumber = 6, SqlFieldName = Discuss_PAPatMas ];

/// 登记号
Property DiscussRegNo As %String [ SqlColumnNumber = 7, SqlFieldName = Discuss_RegNo ];

/// 患者姓名
Property DiscussPatientName As %String [ SqlColumnNumber = 8, SqlFieldName = Discuss_PatientName ];

/// 患者性别
Property DiscussPatientSex As %String [ SqlColumnNumber = 9, SqlFieldName = Discuss_PatientSex ];

/// 患者年龄
Property DiscussPatientAge As %String [ SqlColumnNumber = 10, SqlFieldName = Discuss_PatientAge ];

/// 所属科室
Property DiscussCTLoc As User.CTLoc [ SqlColumnNumber = 11, SqlFieldName = Discuss_CTLoc ];

/// 所属科室描述
Property DiscussCTLocDesc As %String [ SqlColumnNumber = 12, SqlFieldName = Discuss_CTLocDesc ];

/// 诊断
Property DiscussSituation As %String(MAXLEN = 100) [ SqlColumnNumber = 13, SqlFieldName = Discuss_Situation ];

/// 记录
Property DiscussRecord As %String(MAXLEN = 10000) [ SqlColumnNumber = 14, SqlFieldName = Discuss_Record ];

/// 状态 N:保存 Y:提交
Property DiscussStatus As %String(DISPLAYLIST = ",保存,提交", MAXLEN = 1, TRUNCATE = 1, VALUELIST = ",N,Y") [ SqlColumnNumber = 15, SqlFieldName = Discuss_Status ];

/// 创建人
Property Creator As %String [ SqlColumnNumber = 16, SqlFieldName = Creator ];

/// 创建日期
Property CreateDate As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 17, SqlFieldName = Create_Date ];

/// 创建时间
Property CreateTime As %Time [ InitialExpression = {$p($h,",",2)}, SqlColumnNumber = 18, SqlFieldName = Create_Time ];

/// 记录
Property DiscussRecordExt As %Stream.GlobalCharacter [ SqlColumnNumber = 19, SqlFieldName = Discuss_RecordExt ];

Index CTLoc On DiscussCTLoc;

Storage Default
{
<Data name="MgCaseDiscussDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DiscussType</Value>
</Value>
<Value name="3">
<Value>DiscussHost</Value>
</Value>
<Value name="4">
<Value>DiscussDate</Value>
</Value>
<Value name="5">
<Value>DiscussParticipant</Value>
</Value>
<Value name="6">
<Value>DiscussPAPatMas</Value>
</Value>
<Value name="7">
<Value>DiscussRegNo</Value>
</Value>
<Value name="8">
<Value>DiscussPatientName</Value>
</Value>
<Value name="9">
<Value>DiscussPatientSex</Value>
</Value>
<Value name="10">
<Value>DiscussPatientAge</Value>
</Value>
<Value name="11">
<Value>DiscussCTLoc</Value>
</Value>
<Value name="12">
<Value>DiscussCTLocDesc</Value>
</Value>
<Value name="13">
<Value>DiscussSituation</Value>
</Value>
<Value name="14">
<Value>DiscussRecord</Value>
</Value>
<Value name="15">
<Value>DiscussStatus</Value>
</Value>
<Value name="16">
<Value>Creator</Value>
</Value>
<Value name="17">
<Value>CreateDate</Value>
</Value>
<Value name="18">
<Value>CreateTime</Value>
</Value>
<Value name="19">
<Value>DiscussRecordExt</Value>
</Value>
</Data>
<DataLocation>^DHCINM.HB.MgCaseDiscussD</DataLocation>
<DefaultData>MgCaseDiscussDefaultData</DefaultData>
<IdLocation>^DHCINM.HB.MgCaseDiscussD</IdLocation>
<IndexLocation>^DHCINM.HB.MgCaseDiscussI</IndexLocation>
<StreamLocation>^DHCINM.HB.MgCaseDiscussS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
