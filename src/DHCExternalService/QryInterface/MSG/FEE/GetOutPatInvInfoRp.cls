Class DHCExternalService.QryInterface.MSG.FEE.GetOutPatInvInfoRp Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLIGNORENULL = 1;

Property ResultCode As %String(TRUNCATE = 1);

Property ErrorMsg As %String(MAXLEN = 256, TRUNCATE = 1);

Property InvInfoS As list Of DHCExternalService.QryInterface.MSG.FEE.OPInvInfo;

}
