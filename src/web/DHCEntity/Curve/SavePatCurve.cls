Class web.DHCEntity.Curve.SavePatCurve Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

/// 病人就诊号
Property Episode As %String(TRUNCATE = 1);

/// 病人产次
Property Pregnancy As %String(TRUNCATE = 1);

/// 宫缩开始时间 
Property ContraDateTime As %String(TRUNCATE = 1);

/// 录入者
Property UserID As %String(TRUNCATE = 1);

/// 娩出时间 
Property BirthDateTime As %String(TRUNCATE = 1);

/// 产次
Property BirthCount As %String(TRUNCATE = 1);

/// 预产日期 
Property PredictPreg As %String(TRUNCATE = 1);

/// 胎盘娩出时间 
Property PlacentaOut As %String(TRUNCATE = 1);

}
