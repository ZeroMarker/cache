Class DHCExternalService.RegInterface.Entity.SelfReg.List.PatBillType Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLIGNOREINVALIDTAG = 1;

/// 费别ID
Property BillTypeID As %String(TRUNCATE = 1);

/// 费别描述
Property BillTypeDesc As %String(TRUNCATE = 1);

/// 医保结算
Property InsuBillFlag As %String(TRUNCATE = 1);

}
