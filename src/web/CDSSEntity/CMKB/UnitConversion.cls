/// 名称：单位转换字典表
/// 描述：实体类
/// 编写者：基础数据平台组_Xuwenhu
/// 编写日期：2021-07-16
Class web.CDSSEntity.CMKB.UnitConversion Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.CDSSEntity.CMKB.UnitConversion";

Property ID As %String;

/// 从单位
Property FromUnitDR As %String;

/// 到单位
Property ToUnitDR As %String;

/// 转换系数
Property ConversionFactor As %Float;

/// 状态（0编辑中，1已弃用，2已审核）
Property UseFlag As %String;

/// 操作人员
Property UpdateUser As %String;

/// 操作时间
Property UpdateDate As %TimeStamp;

/// 备注
Property Remarks As %String(MAXLEN = "");

}
