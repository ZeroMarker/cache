Class CIS.OPApp.DTO.Base.Hospital Extends (CIS.OPApp.DTO.Abstract.Model, %XML.Adaptor) [ Inheritance = right ]
{

Parameter XMLNAME = "Hospital";

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

/// 医院ID
Property RowId As %String(TRUNCATE = 1);

/// 描述
Property Description As %String(TRUNCATE = 1);

}
