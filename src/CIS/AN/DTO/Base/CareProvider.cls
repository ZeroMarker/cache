Class CIS.AN.DTO.Base.CareProvider Extends (CIS.AN.DTO.Abstract.Model, %XML.Adaptor) [ Inheritance = right ]
{

Parameter XMLNAME = "CareProvider";

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

/// ID
Property RowId As %String(TRUNCATE = 1);

/// 姓名
Property Name As %String(TRUNCATE = 1);

/// 简拼
Property Alias As %String(TRUNCATE = 1);

/// 科室Id
Property DepartmentID As %String(TRUNCATE = 1);

/// 科室
Property Department As %String(TRUNCATE = 1);

}
