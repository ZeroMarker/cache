Class CIS.AN.DTO.AN.Anaesthesia Extends (CIS.AN.DTO.Abstract.Model, %XML.Adaptor) [ Inheritance = right ]
{

Parameter XMLNAME = "Anaesthesia";

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLIGNORENULL = 1;

/// 就诊号
Property EpisodeID As %String;

/// 旧表（ORAnaesthesia）ID
Property OldID As %String;

/// 手术申请ID
Property ApplicationID As %String;

/// 麻醉方法ID
Property AnaMethodID As %String(TRUNCATE = 1);

/// 麻醉方法
Property AnaMethod As %String(TRUNCATE = 1);

/// 麻醉方法国家标准码
Property AnaMethodStandardCode As %String(TRUNCATE = 1);

}
