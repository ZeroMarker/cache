/// 	指标系统标准接口：导入导出接口
Class DHCWL.Interface.IOStream Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Creator:		JEFF
/// CreatDate:		2014-01-21
/// Description:	导出对象列表中的对象结构到XML文件中
/// Table:			
/// Input:			objectList:一个包含对象引用的List，每一个对象代表要导出到xml中的数据，在导出时，如果该对象有对象类型的数据，会遍历该对象依次导出，因此objectList中只包括对象的入口便可；
/// 				service:对OutputInterface接口的实现，该接口可以决定对象在导出时如何安排xml文档节点算是存储在结构区还是引用区；
/// 				savePath:要导出xml文件的保存路径；
/// 				fileStream:导出后的文件二进制数据流。
/// Output:			传入savePath时，输出XML文件；传入fileStream时，输出文件二进制数据流。
/// Return:			导出成功返回1；否则返回0；出错时，返回错误提示信息。
/// HowToUse:		
/// Other:			savePath和fileStream只传入一个即可。
ClassMethod ExportCustom(ByRef objectList As %ListOfObjects, ByRef service As DHCWL.MKPIIO.util.OutputInterface = "", savePath = "", ByRef fileStream As %Library.FileBinaryStream = "") As %Status
{
	n (objectList,service,savePath,fileStream)
	q:(""=objectList) 0
	q:(""=savePath)&&(""=fileStream) 0
	q ##class(DHCWL.MKPIIO.util.Write).WriteXML(objectList,service,savePath,fileStream)
}

/// Creator:		JEFF
/// CreatDate:		2014-01-21
/// Description:	导出指标，指标维度，区间，维度属性，任务，指标分类等指标相关定义。不会导出包括和业务管理相关的模块，报表等数据。
/// Table:			
/// Input:			kpiList:指标的Code或者Id列表，多个指标间用英文逗号隔开；
/// 				savePath:要导出xml文件的保存路径，其中不用指定文件名；
/// 				fileStream:导出的文件二进制数据流。
/// Output:			传入savePath时，输出XML文件；传入fileStream时，输出文件二进制数据流。
/// Return:			导出成功返回1；否则返回0；出错时，返回错误提示信息。
/// HowToUse:		w ##class(DHCWL.Interface.Interface).ExportDefKpi("RegLocSexAge,RegLocOpNumsRT,EPRMRDepOpNums,RegLocOpNums","C:\")
/// 				w ##class(DHCWL.Interface.Interface).ExportDefKpi("RegLocSexAge,RegLocOpNumsRT,EPRMRDepOpNums,RegLocOpNums",,.data)
/// Other:			savePath和fileStream只传入一个即可。
ClassMethod ExportDefKpi(kpiList As %String, savePath = "", ByRef fileStream As %Library.FileBinaryStream = "") As %Status
{
	n (kpiList,savePath,fileStream)
	q:(""=kpiList) 0
	s kpiList=##class(DHCWL.Interface.Interface).ToKpiCode(kpiList,",")
	q:(""'=savePath) ##class(DHCWL.MKPIIO.OutputToXML).Output(kpiList,savePath)
	d ##class(DHCWL.MKPIIO.OutputToXML).OutputOfStream(kpiList,.fileStream)
	q 1
}

/// Creator:		JEFF
/// CreatDate:		2014-01-21
/// Description:	导入。导入时，不区分导入的对象是指标定义，维度，还是整个指标系统，都是用该方法导入。
/// Table:			
/// Input:			filePath:一个字符串表示xml文件存放的磁盘位置；
/// 				fileStream:文件二进制数据流；
/// 				service:InputInterface接口的一个实现，该接口规定了xml文档中一个节点对象导入时的行为（导入行为包括：00、01、10、11其中
/// 						第一位表示指标库中是否已经存在，第二位表示是否导入）。
/// Output:			传入filePath时，从XML文件导入；传入fileStream时，从文件二进制数据流读入。
/// Return:			导入成功返回1；否则返回0；出错时，返回错误提示信息。
/// HowToUse:		w ##class(DHCWL.Interface.Interface).ExportDefKpi("D:\test.xml")
/// Other:			filePath和fileStream参数二选一，用来确定要导入的xml文件源。
ClassMethod Import(filePath = "", ByRef service As DHCWL.MKPIIO.util.InputInterface = "", ByRef fileStream As %Library.FileBinaryStream = "") As %Status
{
	n (filePath,service,fileStream)
	q:(""=filePath)&&(""=fileStream) "参数path和stream不能同时为空"
	q ##class(DHCWL.MKPIIO.util.Read).ReadStructNode(filePath, fileStream, service)
}

}
