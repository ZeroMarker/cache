/// 名称: 医院维护
/// 描述: 实体类
/// 编写者：基础数据平台组-陈莹
/// 编写日期: 2012-9-6
Class web.Entity.CT.CTHospital Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.CT.CTHospital";

Property HOSPRowId As %String;

Property HOSPCode As %String;

Property HOSPDesc As %String;

Property HOSPDateFrom As %String;

Property HOSPDateTo As %String;

Property HOSPMandatoryRefHospital As %String;

Property HOSPShortDesc1 As %String;

Property HOSPShortDesc2 As %String;

/// 默认医院 20200429
Property HOSPDefaultHospitalDR As %String;

/// 医疗机构 2020-12-10
Property HOSPClinDR As %String;

/// 定点医疗机构代码
Property HOSPNationalCode As %String;

/// 详细地址
Property HOSPAddress As %String;

/// 定点医疗机构名称 2022-07-04
Property HOSPNationalDesc As %String;

}
