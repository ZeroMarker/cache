/// 名称：检验医嘱字典表 
/// 描述：实体类
/// 编写者：基础数据平台组_Xuwenhu
/// 编写日期：2021-07-20
Class web.CDSSEntity.CMKB.LabOrdersDict Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.CDSSEntity.CMKB.LabOrdersDict";

Property ID As %String;

/// 检验医嘱代码
Property LabOrdersCode As %String;

/// 检验医嘱描述
Property LabOrdersDesc As %String;

/// 别名
Property Alias As %String;

/// 使用标志（0编辑中,1已删除,2已审核）
Property UseFlag As %Integer;

/// 操作人员
Property UpdateUser As %String;

/// 操作时间
Property UpdateDate As %TimeStamp;

/// 备注
Property Remarks As %String(MAXLEN = "");

}
