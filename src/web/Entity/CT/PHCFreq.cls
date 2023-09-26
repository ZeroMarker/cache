/// 名称:药学-频次实体类
/// 编写者:基础数据平台组 - 陈莹
/// 编写日期: 2012-8-30
Class web.Entity.CT.PHCFreq Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.CT.PHCFreq";

// RowId

Property PHCFRRowId As %String;

// 代码

Property PHCFRCode As %String;

// 系数

Property PHCFRFactor As %String;

// 英文描述

Property PHCFRDesc1 As %String;

// 中文描述

Property PHCFRDesc2 As %String;

// 间隔天数

Property PHCFRDays As %String;

// 是否激活

Property PHCFRActiveFlag As %String;

// 就诊类型

Property PHCFRClinicType As %String;

// 就诊类型 门诊

Property PHCFRClinicTypeO As %String;

// 就诊类型 急诊

Property PHCFRClinicTypeE As %String;

// 就诊类型 住院

Property PHCFRClinicTypeI As %String;

// 就诊类型 体检

Property PHCFRClinicTypeH As %String;

// 就诊类型 新生儿

Property PHCFRClinicTypeN As %String;

// 别名（导入用）--20170220

Property DataAlias As %String;

// 门诊默认按分发次数全执行

Property PHCFRNoDelayExecute As %String;

// 周频次

Property PHCFRWeekFlag As %String;

// 住院默认按分发次数全执行

Property PHCFRNoDelayExecute2 As %String;

// 周频次系数 2019-05-08

Property PHCFRWeekFactor As %String;

// 间隔时间（单位：小时）--不用了

Property PHCFRIntervalTime As %String;

// 不规则分发时间标志  chenying add@2020-11-04 

Property PHCFRIrregularDistributTimeFlag As %String;

// 间隔单位 2021-12-23

Property PHCFRIntervalUom As %String;

/// 星期  
Property PHCFRWeek As %String;

/// 星期一  
Property PHCFRWeek1 As %String;

/// 星期二  
Property PHCFRWeek2 As %String;

/// 星期三  
Property PHCFRWeek3 As %String;

/// 星期四  
Property PHCFRWeek4 As %String;

/// 星期五  
Property PHCFRWeek5 As %String;

/// 星期六  
Property PHCFRWeek6 As %String;

/// 星期日  
Property PHCFRWeek7 As %String;

}
