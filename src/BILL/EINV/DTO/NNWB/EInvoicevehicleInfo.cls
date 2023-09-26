/// 机动车销售明细参数
Class BILL.EINV.DTO.NNWB.EInvoicevehicleInfo Extends %RegisteredObject
{

Property vehicleType As %String(CAPTION = " 车辆类型");

Property brandModel As %String(CAPTION = " 厂牌型号");

Property productOrigin As %String(CAPTION = " 原产地");

Property certificate As %String(CAPTION = " 合格证号");

Property importCerNum As %String(CAPTION = " 进出口证明书号");

Property insOddNum As %String(CAPTION = " 商检单号");

Property engineNum As %String(CAPTION = " 发动机号码");

Property vehicleCode As %String(CAPTION = " 车辆识别号码");

Property intactCerNum As %String(CAPTION = " 完税证明号码");

Property tonnage As %String(CAPTION = " 吨位");

Property maxCapacity As %String(CAPTION = " 限乘人数");

Property idNumOrgCode As %String(CAPTION = " 身份证号或者组织机构代码");

Property manufactureName As %String(CAPTION = " 生产厂家");

}
