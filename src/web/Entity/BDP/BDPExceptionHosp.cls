/// Function: 表结构登记子表-例外医院实体类
/// Creator: 基础数据平台-李可凡
/// CreateDate：2020年4月29日
Class web.Entity.BDP.BDPExceptionHosp Extends (%RegisteredObject, web.DHCEntity.ELAbstract)
{

Parameter PersistentClassName = "web.Entity.BDP.BDPExceptionHosp";

/// ParRef
Property ExceptionHospParRef As %String;

/// rowid
Property ID As %String;

/// 医院DR
Property HospitalDR As %String;

/// 是否启用
Property ActiveFlag As %String;

/// 开始日期
Property ActiveFrom As %String;

/// 结束日期
Property ActiveTo As %String;

}
