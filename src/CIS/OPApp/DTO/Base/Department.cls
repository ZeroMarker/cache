Class CIS.OPApp.DTO.Base.Department Extends (CIS.OPApp.DTO.Abstract.Model, %XML.Adaptor) [ Inheritance = right ]
{

Parameter XMLNAME = "Department";

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

/// ID
Property RowId As %String(TRUNCATE = 1);

/// 描述
Property Description As %String(TRUNCATE = 1);

/// 医院ID
Property HospitalID As %String(TRUNCATE = 1);

}
