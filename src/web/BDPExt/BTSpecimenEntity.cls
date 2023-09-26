/// 名称:标准版检验-标本类型（导入用）
/// 编写者:基础数据平台组 - 钟荣枫
/// 编写日期: 2020-1-21
Class web.BDPExt.BTSpecimenEntity Extends web.Entity.LAB.BTSpecimen
{

Parameter PersistentClassName = "web.BDPExt.BTSpecimenEntity";

// 医院

Property HospitalDesc As %String;

// 标本组

Property SpecimenGroupDesc As %String;

}
