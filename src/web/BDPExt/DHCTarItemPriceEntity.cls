/// 名称: 收费项目价格导入
/// 描述: 实体类
/// 编写者：基础数据平台组-陈莹
/// 编写日期: 2018-1-2
Class web.BDPExt.DHCTarItemPriceEntity Extends web.Entity.CT.DHCTarItemPrice
{

Parameter PersistentClassName = "web.BDPExt.DHCTarItemPriceEntity";

/// 收费项代码
Property TARICode As %String;

/// 收费项描述
Property TARIDesc As %String;

/// 收费项单位
Property TARIUOM As %String;

}
