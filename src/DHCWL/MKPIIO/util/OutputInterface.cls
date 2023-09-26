Class DHCWL.MKPIIO.util.OutputInterface Extends %RegisteredObject [ Not ProcedureBlock ]
{

/*
导出方法的服务接口，通过该方法判断导出这个对象时作为何种节点类型。
节点类型包括：Object：对象类型，该类型在导出时会将递归导出该对象的各个字段；
Ref：引用导出，在导出时只在该字段标示出对象的引用，没有该对象的各个字段，该对象的完整信息在引用缓存区保存。
Base：作为基本类型导出的字段，例如字符串，数值类型等。
该方法应该返回的信息包括：标示该对象唯一性的字段（或多个字段联合组成）名称，节点类型
Parameter：classFullName：类全名，primaryFieldValue标示对象唯一性的值（可选参数值，根据该值可以针对classFullName的某些对象决定如何导出）
			primaryField：被导出对象在唯一标示值的字段名称。refClassFullName：被导出对象所在类的类全名。refPrimayValue：被导出对象所在类的唯一标示值。
configArr：方法返回结果，其结构为：
configArr("Type")="Object/Ref/Base/Null"
configArr("PrimaryFieldValue")="标示该对象唯一性的字段（或多个字段联合组成）"
*/
Method JudgeNodeType(classFullName As %String, primaryFieldValue As %String = "", primaryField As %String = "", refClassFullName As %String = "", refPrimaryFieldValue As %String = "") As %String
{
	n (classFullName,primaryFieldValue,primaryField,refClassFullName,refPrimaryFieldValue)
	s config("DHCWL.MKPI.Section")="Ref",config("DHCWL.MKPI.MKPI")="Ref",config("DHCWL.MKPI.MKPIFL")="Ref"
	s config("DHCWL.MKPI.DimProperty")="Object",config("DHCWL.MKPI.ExecuteCode")="Ref",config("DHCWL.MKPI.MKPIDimensions")="Object"
	s config("DHCWL.MKPI.SectionProperty")="Object",config("DHCWL.MKPI.MKPIDimType")="Ref"
	s config("DHCWL.MKPI.CreatDataTask")="Object",config("DHCWL.MKPI.TaskGroupDetail")="Object",config("DHCWL.MKPI.ConfigTaskGroup")="Ref"
	s config("DHCWL.MKPI.MKPIMeasure")="Object",config("DHCWL.MeasureDimrole.Measure")="Ref"
	//s config("DHCWL.MKPI.ModeMagKpiCfg")="Object",config("DHCWL.MKPI.ModeMagModeCfg")="Object",config("DHCWL.MKPI.ModeMagRptCfg")="Object"
	if ((primaryFieldValue="")||(primaryFieldValue'="")){
		if ($d(config(classFullName))){
			q config(classFullName)
		}else {
			q "Base"
		}
	}
	q "Base"
}

}
