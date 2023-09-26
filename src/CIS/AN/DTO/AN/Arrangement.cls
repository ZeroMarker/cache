Class CIS.AN.DTO.AN.Arrangement Extends (CIS.AN.DTO.Abstract.Model, %XML.Adaptor) [ Inheritance = right ]
{

Parameter XMLNAME = "Arrangement";

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLIGNORENULL = 1;

/// 外部ID
Property ExternalID As %String;

/// 内部ID
Property RowId As %String;

/// 申请表ID
Property ApplicationID As %String;

/// 麻醉方法ID（拟施麻醉-麻醉科排班确认）
Property AnaMethodID As %String(TRUNCATE = 1);

/// 麻醉方法（拟施麻醉-麻醉科排班确认）
Property AnaMethod As %String(TRUNCATE = 1);

/// 麻醉方法国家标准码（拟施麻醉-麻醉科排班确认）
Property AnaMethodStandardCode As %String(TRUNCATE = 1);

/// 麻醉医生
Property Anaesthetist As CIS.AN.DTO.Base.CareProvider;

/// 麻醉指导
Property AnaDirector As CIS.AN.DTO.Base.CareProvider;

/// 麻醉助手
Property AnaAssistants As list Of CIS.AN.DTO.Base.CareProvider;

/// 提交时间
Property SubmitDateTime As %String(TRUNCATE = 1);

/// 提交用户ID
Property SubmitUserID As %String(TRUNCATE = 1);

/// 提交用户
Property SubmitUser As %String(TRUNCATE = 1);

}
