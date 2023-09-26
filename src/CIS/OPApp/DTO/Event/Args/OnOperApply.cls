Class CIS.OPApp.DTO.Event.Args.OnOperApply Extends (CIS.OPApp.DTO.Abstract.Model, CIS.OPApp.DTO.Abstract.EventArgs, %XML.Adaptor) [ Inheritance = right ]
{

Parameter XMLNAME = "Args.OnOperApply";

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLIGNORENULL = 1;

/// 手术申请日期
Property Date As %String;

/// 手术申请ID（内部标准ID）
Property RowId As %String;

/// 手术申请ID（外部标准ID）
Property ApplicationID As %String;

}
