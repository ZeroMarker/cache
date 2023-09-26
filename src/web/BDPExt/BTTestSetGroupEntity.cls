/// 名称:标准版检验-合管组合套分组及关联（导入用）
/// 编写者:基础数据平台组 - 钟荣枫
/// 编写日期: 2020-1-21
Class web.BDPExt.BTTestSetGroupEntity Extends (web.Entity.LAB.BTTestSetGroup, web.Entity.LAB.BTTestSetGroupLinks)
{

Parameter PersistentClassName = "web.BDPExt.BTTestSetGroupEntity";

// 医院

Property HospitalDesc As %String;

// 项目组合套

Property TestSetDesc As %String;

}
