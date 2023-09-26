/// 创建者：李阳
/// 创建日期：2011-04-21
/// 功能：临床路径入径提示日志记录
Class User.DHCMRClinicalPathWayInPathLog Extends %Persistent [ ClassType = persistent, ProcedureBlock, SqlRowIdName = RowId, SqlTableName = DHC_MR_ClinicalPathWayInPathLog ]
{

/// 就诊号
Property Paadm As %Integer [ SqlColumnNumber = 2, SqlFieldName = Paadm ];

/// 临床诊断（指向MR_Diagnos表）
Property MRCICDRowid As %String [ SqlColumnNumber = 3, SqlFieldName = MRCICDRowid ];

/// 临床诊断ICD10
Property MRCICD10 As %String [ SqlColumnNumber = 4, SqlFieldName = MRCICD10 ];

/// 临床诊断描述
Property MRCICDDesc As %String [ SqlColumnNumber = 5, SqlFieldName = MRCICDDesc ];

/// 提示路径版本（指向User.DHCMRClinicalPathWay表）
Property NoticePathWayVerID As %Integer [ SqlColumnNumber = 6, SqlFieldName = NoticePathWayVerID ];

/// 提示日期
Property NoticeDate As %Date [ SqlColumnNumber = 7, SqlFieldName = NoticeDate ];

/// 提示时间
Property NoticeTime As %Time [ SqlColumnNumber = 8, SqlFieldName = NoticeTime ];

/// 操作员ID（指向SS_User表）
Property DoctorID As %String [ SqlColumnNumber = 9, SqlFieldName = DoctorID ];

/// 出入径记录（指向User.DHCMRClinicalPathWay）
Property PathWayID As %Integer [ SqlColumnNumber = 10, SqlFieldName = PathWayID ];

/// 不入径原因
Property NotInCPWReason As %String [ SqlColumnNumber = 11, SqlFieldName = NotInCPWReason ];

/// 不入径备注
Property NotInCPWResume As %String [ SqlColumnNumber = 12, SqlFieldName = NotInCPWResume ];

/// 就诊索引
Index PaadmIndex On Paadm;

/// 出入径记录索引
Index PathWayIDIndex On PathWayID;

/// 提示日期+时间索引
Index NoticeDateTimeIndex On (NoticeDate, NoticeTime);

Storage Default
{
<Data name="DataMaster">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DoctorID</Value>
</Value>
<Value name="3">
<Value>NoticeDate</Value>
</Value>
<Value name="4">
<Value>NoticeTime</Value>
</Value>
<Value name="5">
<Value>PathWayID</Value>
</Value>
<Value name="6">
<Value>MRCICDRowid</Value>
</Value>
<Value name="7">
<Value>Paadm</Value>
</Value>
<Value name="8">
<Value>NoticePathWayVerID</Value>
</Value>
<Value name="9">
<Value>NotInCPWReason</Value>
</Value>
<Value name="10">
<Value>NotInCPWResume</Value>
</Value>
<Value name="11">
<Value>MRCICD10</Value>
</Value>
<Value name="12">
<Value>MRCICDDesc</Value>
</Value>
</Data>
<DataLocation>^DHCMR("LOG")</DataLocation>
<DefaultData>DataMaster</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMR("LOG")</IdLocation>
<IndexLocation>^DHCMRi("LOG",0)</IndexLocation>
<StreamLocation>^User.DHCMRClinicaAB1S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
