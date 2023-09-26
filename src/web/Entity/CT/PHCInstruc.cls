/// 名称:药学-药品用法实体类
/// 编写者:基础数据平台组 - 陈莹
/// 编写日期: 2012-8-30
Class web.Entity.CT.PHCInstruc Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.CT.PHCInstruc";

//药品用法RowId

Property PHCINRowId As %String;

//药品用法代码

Property PHCINCode As %String;

//药品用法描述1

Property PHCINDesc1 As %String;

//药品用法描述2

Property PHCINDesc2 As %String;

// 别名（导入用）--20170220

Property DataAlias As %String;

// 2017-06-14  是否激活

Property PHCINActiveFlag As %String;

// 2017-06-14  就诊类型

Property PHCINClinicType As %String;

// 就诊类型 门诊

Property PHCINClinicTypeO As %String;

// 就诊类型 急诊

Property PHCINClinicTypeE As %String;

// 就诊类型 住院

Property PHCINClinicTypeI As %String;

// 就诊类型 体检

Property PHCINClinicTypeH As %String;

// 就诊类型 新生儿

Property PHCINClinicTypeN As %String;

//  20170612  江西南大二附院  是否需要执行科室  

///   Property PHCINExecuteLocFlag As %String;

}
