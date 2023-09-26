/// 名称:EMRservice.entity.EOrderInfo
/// 描述:共享文档门急诊病历-医嘱信息实体类
/// 编写者：Guozongtao
/// 编写日期: 2016-12-08
Class EMRservice.entity.EOrderInfo Extends %RegisteredObject
{

Property Text As %String;

/*
	<E01 desc="医嘱开始日期"></E01>
	<E02 desc="医嘱开始时间"></E02>
	<E03 desc="医嘱代码"></E03>
	<E04 desc="医嘱名称"></E04>
	<E06 desc="医嘱频次名称"></E06>
	<E07 desc="医嘱单次剂量"></E07>
	<E09 desc="医嘱单次剂量单位描述"></E09>
	<E11 desc="医嘱用法描述"></E11>
	<E12 desc="医嘱开立医师代码"></E12>
	<E13 desc="医嘱开立医师姓名"></E13>
	<E14 desc="医嘱审核日期"></E14>
	<E15 desc="医嘱审核时间"></E15>
	<E25 desc="药品规格"></E25>
	<E26 desc="药品总量"></E26>
	<E28 desc="药品总量单位描述"></E28>
	<E29 desc="医嘱大类代码"></E29>
	<E30 desc="医嘱大类描述"></E30>
	<E31 desc="处方号"></E31>
	<E32 desc="中草药服用方式"></E32>
	<E33 desc="本处方内的排序"></E33>
	<E34 desc="本处方医嘱总量"></E34>
	*/
Property E01 As %String;

Property E02 As %String;

Property E03 As %String;

Property E04 As %String;

Property E06 As %String;

Property E07 As %String;

Property E09 As %String;

Property E11 As %String;

Property E12 As %String;

Property E13 As %String;

Property E14 As %String;

Property E15 As %String;

Property E25 As %String;

Property E26 As %String;

Property E28 As %String;

Property E29 As %String;

Property E30 As %String;

Property E31 As %String;

Property E32 As %String;

Property E33 As %String;

Property E34 As %String;

}
