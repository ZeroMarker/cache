/// 名称:药学-生产厂家实体类
/// 编写者:基础平台组 - 陈莹
/// 编写日期: 2012-8-30
Class web.Entity.CT.PHManufacturer Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.CT.PHManufacturer";

//RowId

Property PHMNFRowId As %String;

//代码

Property PHMNFCode As %String;

//名称

Property PHMNFName As %String;

//地址

Property PHMNFAddress As %String;

//电话

Property PHMNFTel As %String;

}
