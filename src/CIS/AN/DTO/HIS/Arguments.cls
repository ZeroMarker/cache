Class CIS.AN.DTO.HIS.Arguments Extends (CIS.AN.DTO.Abstract.Model, CIS.AN.DTO.Abstract.Arguments, %XML.Adaptor)
{

Parameter XMLNAME = "Arguments";

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

/// 开始日期（手术日期）
Property StartDate As %String;

/// 结束日期（手术日期）
Property EndDate As %String;

/// 手术申请ID
Property ApplicationID As %String;

/// 就诊号
Property EpisodeID As %String;

/// 登记号
Property RegNo As %String;

/// 住院号
Property MedcareNo As %String;

}
