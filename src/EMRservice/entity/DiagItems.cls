/// 名称:EMRservice.entity.EDiagnosInfo
/// 描述:共享文档门急诊病历-诊断信息明细实体类
/// 编写者：Guozongtao
/// 编写日期: 2016-12-0
Class EMRservice.entity.DiagItems Extends %RegisteredObject
{

/*
	<text>1.1型糖尿病伴昏迷,2.1型糖尿病伴昏迷,3.1型糖尿病伴昏迷</text>
	<E01 desc="诊断名称"/>
	<E02 desc="诊断代码"/>
	<E07 desc="医生填写的诊断"/>
	<E09 desc="诊断序号"/>
	*/
Property Text As %String;

Property E01 As %String;

Property E02 As %String;

Property E07 As %String;

Property E09 As %String;

}
