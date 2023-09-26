Class CIS.OPApp.DTO.OP.Infection Extends (CIS.OPApp.DTO.Abstract.Model, %XML.Adaptor) [ Inheritance = right ]
{

Parameter XMLNAME = "Infection";

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

/// 乙肝
Property HBsAg As %String(TRUNCATE = 1);

/// 丙肝
Property HCVAb As %String(TRUNCATE = 1);

/// HIV
Property HivAb As %String(TRUNCATE = 1);

/// 梅毒
Property TPAb As %String(TRUNCATE = 1);

/// 多重耐药
Property MDROS As %String(TRUNCATE = 1);

}
