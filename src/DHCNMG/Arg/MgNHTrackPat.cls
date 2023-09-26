Class DHCNMG.Arg.MgNHTrackPat Extends %Persistent
{

Relationship Parref As DHCNMG.Arg.MgNurHeadTrack [ Cardinality = parent, Inverse = PatChildSub ];

/// 记录日期
Property TrackDate As %String [ SqlColumnNumber = 5, SqlFieldName = Track_Date ];

/// 病区
Property TrackWardDR As DHCNMG.DB.MgWard [ SqlColumnNumber = 6, SqlFieldName = Track_WardDR ];

/// 就诊号
Property TrackAdmDR As User.PAAdm [ SqlColumnNumber = 7, SqlFieldName = Track_AdmDR ];

/// 住院号
Property TrackPatNo As %String [ SqlColumnNumber = 8, SqlFieldName = Track_PatNo ];

/// 床号
Property TrackBedCode As %String [ SqlColumnNumber = 9, SqlFieldName = Track_BedCode ];

/// 姓名
Property TrackPatName As %String [ SqlColumnNumber = 10, SqlFieldName = Track_PatName ];

/// 年龄
Property TrackPatAge As %String [ SqlColumnNumber = 11, SqlFieldName = Track_PatAge ];

/// 性别
Property TrackPatSex As %String [ SqlColumnNumber = 12, SqlFieldName = Track_PatSex ];

/// 护理等级
Property TrackCareLevel As %String [ SqlColumnNumber = 13, SqlFieldName = Track_CareLevel ];

/// 诊断
Property TrackDiagnosis As %String(MAXLEN = 1000) [ SqlColumnNumber = 14, SqlFieldName = Track_Diagnosis ];

/// 简要病史及主要治疗护理措施
Property TrackTreat As %String(MAXLEN = 1000) [ SqlColumnNumber = 15, SqlFieldName = Track_Treat ];

/// 访谈记录1.就医体验2.患者安全(跌倒、压疮、转科流程、管道护理、危急值报告及处理及其他高危环节)3.患者需求4.护理记录5.责任护士落实情况等
Property TrackTalk As %String(MAXLEN = 10000) [ SqlColumnNumber = 16, SqlFieldName = Track_Talk ];

/// 评审科室达到相关标准等级(根据三级综合医院评审标准实施细则)
Property TrackReview As %String(MAXLEN = 10000) [ SqlColumnNumber = 17, SqlFieldName = Track_Review ];

/// 护理质控检查1.药品与器材2.消毒隔离3.病区管理4.护理文书5.健康宣教6.基础护理及危重病人
Property TrackCheck As %String(MAXLEN = 10000) [ SqlColumnNumber = 18, SqlFieldName = Track_Check ];

/// 追踪落实情况
Property TrackFulfill As %String(MAXLEN = 10000) [ SqlColumnNumber = 19, SqlFieldName = Track_Fulfill ];

Index Date On TrackDate;

Index Adm On TrackAdmDR;

Index PatNo On TrackPatNo;

Storage Default
{
<Data name="MgNHTrackPatDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>TrackDate</Value>
</Value>
<Value name="3">
<Value>TrackWadDR</Value>
</Value>
<Value name="4">
<Value>TrackAdmDR</Value>
</Value>
<Value name="5">
<Value>TrackPatNo</Value>
</Value>
<Value name="6">
<Value>TrackBedCode</Value>
</Value>
<Value name="7">
<Value>TrackPatName</Value>
</Value>
<Value name="8">
<Value>TrackPatAge</Value>
</Value>
<Value name="9">
<Value>TrackPatSex</Value>
</Value>
<Value name="10">
<Value>TrackCareLevel</Value>
</Value>
<Value name="11">
<Value>TrackDiagnosis</Value>
</Value>
<Value name="12">
<Value>TrackTreat</Value>
</Value>
<Value name="13">
<Value>TrackTalk</Value>
</Value>
<Value name="14">
<Value>TrackReview</Value>
</Value>
<Value name="15">
<Value>TrackCheck</Value>
</Value>
<Value name="16">
<Value>TrackFulfill</Value>
</Value>
<Value name="17">
<Value>TrackWardDR</Value>
</Value>
</Data>
<DataLocation>^DHCNMG.Arg.MgNHTrackPatD</DataLocation>
<DefaultData>MgNHTrackPatDefaultData</DefaultData>
<IdLocation>{%%PARENT}("PatChildSub")</IdLocation>
<IndexLocation>^DHCNMG.Arg.MgNHTrackPatI</IndexLocation>
<StreamLocation>^DHCNMG.Arg.MgNHTrackPatS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
