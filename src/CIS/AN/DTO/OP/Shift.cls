Class CIS.AN.DTO.OP.Shift Extends (CIS.AN.DTO.Abstract.Model, %XML.Adaptor) [ Inheritance = right ]
{

Parameter XMLNAME = "Shift";

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLIGNORENULL = 1;

/// 手术申请ID
Property ApplicationID As %String;

/// 交班医护人员
Property HandOverCareProv As CIS.AN.DTO.Base.CareProvider;

/// 接班医护人员
Property TakeOverCareProv As CIS.AN.DTO.Base.CareProvider;

/// 交接班类型代码
Property Type As %String;

/// 交接班类型
Property TypeDesc As %String;

/// 交接班说明
Property Note As %String(MAXLEN = 500);

/// 交接班日期
Property Date As %String;

/// 交接班时间
Property Time As %String;

/// 交接班医护人员科室ID
Property CareProvDeptID As %String;

/// 交接班医护人员科室
Property CareProvDept As %String;

}
