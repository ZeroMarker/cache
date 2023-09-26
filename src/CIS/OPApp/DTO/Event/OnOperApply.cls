Class CIS.OPApp.DTO.Event.OnOperApply Extends (CIS.OPApp.DTO.Abstract.Model, CIS.OPApp.DTO.Abstract.Event, %XML.Adaptor) [ Inheritance = right ]
{

Parameter XMLTYPE = "Model";

Parameter XMLNAME = "OnOperApply";

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLIGNORENULL = 1;

/// 动作时间（yyyy-MM-dd HH:mm:ss）
Property ActDateTime As %String;

/// 动作人ID
Property ActUserID As %String;

/// 动作人
Property ActUser As %String;

/// 数据
Property Models As list Of CIS.OPApp.DTO.OP.Appointment;

}
