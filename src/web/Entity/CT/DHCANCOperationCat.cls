/// 名称:手术和过程-手术分类
/// 编写者:基础数据平台组 - ybq
/// 编写日期:2019-1-31
Class web.Entity.CT.DHCANCOperationCat Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.CT.DHCANCOperationCat";

Property ANCOCRowId As %String;

// 代码

Property ANCOCCode As %String;

// 描述

Property ANCOCDesc As %String;

// 类别

Property ANCOCType As %String;

}
