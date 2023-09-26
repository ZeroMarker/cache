Class web.DHCENS.STBLL.BOOKREG.MODEL.DoctorInfo Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLNAME = "DoctorInfo";

/// 医生ID
Property DoctorId As %String;

/// 医生代码
Property DoctorCode As %String;

/// 医生名称
Property DoctorName As %String;

/// 科室ID
Property DeptId As %String;

/// 科室代码
Property DeptCode As %String;

/// 科室名称
Property DeptName As %String;

/// 医生职称
Property Title As %String;

}
