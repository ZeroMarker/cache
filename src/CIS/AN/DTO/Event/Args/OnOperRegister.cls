Class CIS.AN.DTO.Event.Args.OnOperRegister Extends (CIS.AN.DTO.Abstract.Model, CIS.AN.DTO.Abstract.EventArgs, %XML.Adaptor) [ Inheritance = right ]
{

Parameter XMLNAME = "Args.OnOperRegister";

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLIGNORENULL = 1;

/// 手术日期
Property Date As %String;

/// 手术申请ID（内部标准ID）
Property RowId As %String;

/// 手术申请ID（外部标准ID）
Property ApplicationID As %String;

}
