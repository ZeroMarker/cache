Class CIS.AN.DTO.Event.OnOperRegister Extends (CIS.AN.DTO.Abstract.Model, CIS.AN.DTO.Abstract.Event, %XML.Adaptor) [ Inheritance = right ]
{

Parameter XMLNAME = "OnOperRegister";

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLIGNORENULL = 1;

/// 动作时间（yyyy-MM-dd HH:mm:ss）
Property ActDateTime As %String;

/// 动作人ID
Property ActUserID As %String;

/// 动作人
Property ActUser As %String;

/// 数据
Property Models As list Of CIS.AN.DTO.OP.Registration;

}
