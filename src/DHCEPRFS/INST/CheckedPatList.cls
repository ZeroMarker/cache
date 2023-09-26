Class DHCEPRFS.INST.CheckedPatList Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

/// 病案号
Property MedRecordNo As %String(TRUNCATE = 1) [ SqlColumnNumber = 2 ];

/// 登记号
Property RegNo As %String(TRUNCATE = 1) [ SqlColumnNumber = 3 ];

/// 就诊号
Property EpisodeID As %String(TRUNCATE = 1) [ SqlColumnNumber = 4 ];

/// 姓名
Property Name As %String(TRUNCATE = 1) [ SqlColumnNumber = 5 ];

/// 就诊科室RowID
Property PAAdmDepID As %String(TRUNCATE = 1) [ SqlColumnNumber = 6 ];

/// 创建日期
Property CreateDate As %Date [ SqlColumnNumber = 7 ];

/// 创建时间
Property CreateTime As %Time [ SqlColumnNumber = 8 ];

/// 创建操作者ID
Property CreateUserID As %String(TRUNCATE = 1) [ SqlColumnNumber = 9 ];

/// 规则编码
Property RuleCode As %String(TRUNCATE = 1) [ SqlColumnNumber = 10 ];

/// 校验日期
Property CheckDate As %Date [ SqlColumnNumber = 11 ];

/// 校验时间
Property CheckTime As %Time [ SqlColumnNumber = 12 ];

/// 校验操作者ID
Property CheckUserID As %String(TRUNCATE = 1) [ SqlColumnNumber = 13 ];

/// 病案室复核状态
Property ReviewStatus As %String(TRUNCATE = 1) [ SqlColumnNumber = 14 ];

/// 病案室复核操作日期
Property ReviewDate As %Date [ SqlColumnNumber = 15 ];

/// 病案室复核操作时间
Property ReviewTime As %Time [ SqlColumnNumber = 16 ];

/// 病案室复核操作者ID
Property ReviewUserID As %String(TRUNCATE = 1) [ SqlColumnNumber = 17 ];

/// 科室复核状态
Property DeptReviewStatus As %String(TRUNCATE = 1) [ SqlColumnNumber = 18 ];

/// 科室复核操作日期
Property DeptReviewDate As %Date [ SqlColumnNumber = 19 ];

/// 科室复核操作时间
Property DeptReviewTime As %Time [ SqlColumnNumber = 20 ];

/// 科室复核操作者ID
Property DeptReviewUserID As %String(TRUNCATE = 1) [ SqlColumnNumber = 21 ];

/// 医疗单元ID
Property CTMedUnitID As %String(TRUNCATE = 1) [ SqlColumnNumber = 22 ];

/// 就诊类型
Property PAAdmType As %String(TRUNCATE = 1) [ SqlColumnNumber = 23 ];

/// 质控科复核状态
Property QCReviewStatus As %String(TRUNCATE = 1) [ SqlColumnNumber = 24 ];

/// 质控科复核操作日期
Property QCReviewDate As %Date [ SqlColumnNumber = 25 ];

/// 质控科复核操作时间
Property QCReviewTime As %Time [ SqlColumnNumber = 26 ];

/// 质控科复核操作者ID
Property QCReviewUserID As %String(TRUNCATE = 1) [ SqlColumnNumber = 27 ];

/// 医生提交备注
Property Remarks As %String(MAXLEN = 2000, TRUNCATE = 1) [ SqlColumnNumber = 28 ];

/// 病案室备注
Property MRRemarks As %String(MAXLEN = 2000, TRUNCATE = 1) [ SqlColumnNumber = 29 ];

/// 扫描状态   这个字段目前针对温岭的科室扫描，三个状态Y--已经扫描、N--未扫描、P(Postpone)--延迟扫描
Property ScanStatus As %String(MAXLEN = 2000, TRUNCATE = 1) [ SqlColumnNumber = 30 ];

Index IdxEpisode On EpisodeID;

Index IdxEpisodeID On (EpisodeID, CheckDate, CheckTime);

Index IdxPAAdmDepID On (PAAdmDepID, EpisodeID, CheckDate, CheckTime);

Index IdxMedRecordNo On (PAAdmType, MedRecordNo, PAAdmDepID);

Index IdxRegNo On (PAAdmType, RegNo, PAAdmDepID);

Index IdxName On (PAAdmType, Name, PAAdmDepID);

Index IdxMRReviewStatus On (PAAdmType, ReviewStatus, PAAdmDepID, CreateDate);

Index IdxQCReviewStatus On (PAAdmType, QCReviewStatus, PAAdmDepID, CreateDate);

Index IdxDeptReviewStatus On (PAAdmType, DeptReviewStatus, PAAdmDepID, CreateDate);

Index IdxDepIDCreateDate On (PAAdmType, PAAdmDepID, CreateDate);

Index IdxReviewTime On (ReviewStatus, ReviewDate, ReviewTime);

Storage Default
{
<Data name="CheckedPatListDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>MedRecordNo</Value>
</Value>
<Value name="3">
<Value>RegNo</Value>
</Value>
<Value name="4">
<Value>EpisodeID</Value>
</Value>
<Value name="5">
<Value>Name</Value>
</Value>
<Value name="6">
<Value>PAAdmDepID</Value>
</Value>
<Value name="7">
<Value>RuleCode</Value>
</Value>
<Value name="8">
<Value>CheckDate</Value>
</Value>
<Value name="9">
<Value>CheckTime</Value>
</Value>
<Value name="10">
<Value>CheckUserID</Value>
</Value>
<Value name="11">
<Value>ReviewStatus</Value>
</Value>
<Value name="12">
<Value>ReviewDate</Value>
</Value>
<Value name="13">
<Value>ReviewTime</Value>
</Value>
<Value name="14">
<Value>ReviewUserID</Value>
</Value>
<Value name="15">
<Value>DeptReviewStatus</Value>
</Value>
<Value name="16">
<Value>DeptReviewDate</Value>
</Value>
<Value name="17">
<Value>DeptReviewTime</Value>
</Value>
<Value name="18">
<Value>DeptReviewUserID</Value>
</Value>
<Value name="19">
<Value>CreateDate</Value>
</Value>
<Value name="20">
<Value>CreateTime</Value>
</Value>
<Value name="21">
<Value>CreateUserID</Value>
</Value>
<Value name="22">
<Value>CTMedUnitID</Value>
</Value>
<Value name="23">
<Value>PAAdmType</Value>
</Value>
<Value name="24">
<Value>QCReviewStatus</Value>
</Value>
<Value name="25">
<Value>QCReviewDate</Value>
</Value>
<Value name="26">
<Value>QCReviewTime</Value>
</Value>
<Value name="27">
<Value>QCReviewUserID</Value>
</Value>
<Value name="28">
<Value>Remarks</Value>
</Value>
<Value name="29">
<Value>MRRemarks</Value>
</Value>
<Value name="30">
<Value>ScanStatus</Value>
</Value>
</Data>
<DataLocation>^DHCEPRFS.INST.CheckedPatListD</DataLocation>
<DefaultData>CheckedPatListDefaultData</DefaultData>
<IdLocation>^DHCEPRFS.INST.CheckedPatListD</IdLocation>
<IndexLocation>^DHCEPRFS.INST.CheckedPatListI</IndexLocation>
<StreamLocation>^DHCEPRFS.INST.CheckedPatListS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
