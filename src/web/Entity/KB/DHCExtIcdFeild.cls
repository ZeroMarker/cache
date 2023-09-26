/// 名称: 诊断字典
/// 描述: 实体类
/// 编写者：基础数据平台组-谷雪萍
/// 编写日期: 2014-11-5
Class web.Entity.KB.DHCExtIcdFeild Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.KB.DHCExtIcdFeild";

Property ICDRowId As %String;

Property ICDCode As %String;

Property ICDDesc As %String;

Property ICDType As %String;

Property ICDAcitveFlag As %String;

Property ICDSysFlag As %String;

//操作状态

Property ICDOpStatus As %String;

//备注

Property ICDRemark As %String;

}
