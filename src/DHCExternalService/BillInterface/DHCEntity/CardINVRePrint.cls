/// 专门针对卡发票重新打印功能
Class DHCExternalService.BillInterface.DHCEntity.CardINVRePrint Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

/// 卡发票RowID
Property CardINVRowID As %String(TRUNCATE = 1);

Property PAPMIRowID As %String(TRUNCATE = 1);

Property CardFareCost As %String(TRUNCATE = 1);

Property CardNo As %String(TRUNCATE = 1);

Property CardRowID As %String(TRUNCATE = 1);

Property CardTypeDefine As %String(TRUNCATE = 1);

Property Name As %String(TRUNCATE = 1);

Property PAPMINo As %String(TRUNCATE = 1);

Property PayMode As %String(TRUNCATE = 1);

Property Sex As %String(TRUNCATE = 1);

}
