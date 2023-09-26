/// 名称:实施综合管理平台-医院字典表
/// 描述:实体类
/// 编写者:基础平台组 - 钟荣枫
/// 编写日期:2020-5-30
Class web.CDSSEntity.IMP.CustomerHosp Extends (%RegisteredObject, web.DHCEntity.ELAbstract)
{

Parameter PersistentClassName = "web.CDSSEntity.IMP.CustomerHosp";

// rowid

Property ID As %String;

// 医院编码

Property HospitalCode As %String;

// 医院名称

Property HospitalName As %String;

// 创建时间

Property CreateDate As %String;

// 创建人员维护人员

Property Creator As %String;

// 备注

Property Remarks As %String;

}
