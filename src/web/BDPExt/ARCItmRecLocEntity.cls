/// 名称: 医嘱项接收科室导入用类
/// 描述: 用于医嘱项接收科室导入
/// 编写者：基础数据平台组-钟荣枫
/// 编写日期: 2020-04-03
Class web.BDPExt.ARCItmRecLocEntity Extends web.Entity.CT.ARCItmRecLoc [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.BDPExt.ARCItmRecLocEntity";

Property ARCIMCode As %String;

Property ARCIMDesc As %String;

/// 接收科室所属医院 2020-06-24
Property ARCRLRecLocHospDR As %String;

}
