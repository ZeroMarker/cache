Class EPRservice.tool.BOInstanceData Extends %SOAP.WebService [ ClassType = "", ProcedureBlock ]
{

/// TODO: change this to actual network address.
/// URL for invoking the WebService.
/// TODO: change this to actual SOAP namespace.
/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/epr/metaservice";

/// Name of the WebService
Parameter SERVICENAME = "ToolInstanceDataInfo";

/// Desc:	刷新实例数据为对应模板的初始化数据
/// HowToUse:
/// 1. 查找病历ID
///   对于唯一病历：
///   1.1 在病历界面单击鼠标右键，选择查看源文件，找到病历对应的 EpisodeID 和 ProfileID(即ChartItemID)
///   1.2 使用下面的sql语句找到需要刷新的实例数据的ID，参数为 EpisodeID 和 ChartItemID
///       直接显示的病历：只有一个ID，即要刷新的ID
///       横排子项的病历：会有多个ID，从中选择对应的ID
///       select ID from EPRinstance.InstanceData where TheECRecord = (select ID from EPRinstance.ECRecord where EpisodeID = "56" and ChartItemID = "85")
///   对于历次病历：
///   在病历界面单击鼠标右键，选择查看源文件，直接找到要修改病历对应的ID即可。
/// 2. 在Terminal中执行下面语句
/// 	   w ##class(EPRservice.tool.BOInstanceData).RefreshInstanceData("38116||7")
/// 	   输出 "1", 表明刷新成功
ClassMethod RefreshInstanceData(argInstanceId As %String) As %String
{
	q:($d(argInstanceId)=0) "0"
	
 	//取原实例数据
	s objInstanceData= ##class(EPRinstance.InstanceData).%OpenId(argInstanceId)
 	q:(objInstanceData="") "0"
 	
 	s templateId = objInstanceData.TemplateID
 	s templateVersion= objInstanceData.TemplateVersion
 	q:((templateId="")||(templateVersion="")) "0"
 	
 	//刷新实例数据为对应模板的初始化数据
 	d objInstanceData.InstanceData.CopyFrom(##class(EPRmeta.TemplateVersion).GetInitialData(templateId,templateVersion))
 	if objInstanceData.%Save()
 	{	q "1"}
 	else
 	{	q "0"}
}

}
