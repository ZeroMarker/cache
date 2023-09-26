/// Desc: 导出病历数据
Class EPRservice.tool.DataExportMgr Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// Debug: w ##class(EPRservice.tool.DataExportMgr).ExportDataToFile("2007-07-25","2007-07-27","988")
ClassMethod ExportDataToFile(argStDate As %String, argEndDate As %String, argDeptId As %String) As %String
{
	//b "s"
	
	//检验入参
	s isInputOK = ..CheckInput(argStDate,argEndDate,argDeptId)
	q:('isInputOK) "数据导出已终止!"
	w "数据导出开始......",!
	
	//转换日期时间
	s stDate = $zdh(argStDate,3)
	s endDate = $zdh(argEndDate,3)
	
	//遍历满足日期和科室条件的就诊病人
	s date = stDate
	for {
		q:(date="") 
		q:(date>endDate)	//满足日期条件
		
		s admId =""
		for {
			//b "s"
			s admId = $O(^PAADMi("DischDate",date,admId))
			q:(admId="") 
			if (argDeptId '= $P($g(^PAADM(admId)),"^",4)) continue	//满足科室条件
			
			//导出病人数据
			s fileName = ..GetFileName(argStDate,argEndDate,argDeptId)
			d ..ExportPatData(admId,fileName) 			
		}
		
		s date = $O(^PAADMi("DischDate",date))
	}
	
	w !,!,"数据导出完成......",!
	w "导出文件为: "_fileName,!
}

ClassMethod CheckInput(stDate As %String, endDate As %String, deptId As %String) As %String
{
	w "要导出的病历信息如下:",!
	w "起始日期: "_stDate,!
	w "结束日期: "_endDate,!
	w "所属科室:"_$p($g(^CTLOC(deptId)),"^",2),!,!
	
	Read "确认请输入:y, 取消请输入:n    ", input
	w !
	if ($zcvt(input,"U")="Y")
	{	q "1"}
	else
	{
		w "选择了取消，将停止导出!",!	
		q "0"
	}
}

/// Debug: w ##class(EPRservice.tool.DataExportMgr).GetFileName("2009-09-10","2009-09-20","988")
ClassMethod GetFileName(argStDate, argEndDate, argDeptId) As %String
{
	s fileName = "dhcepr_"_argStDate_"_"_argEndDate_"_"_argDeptId_".txt"
	s filePath = ..GetFilePath()
	s allFileName = filePath_fileName	
	q allFileName
}

ClassMethod GetFilePath() As %String
{
	//检查临时目录是否存在
	s filePath=$ZUTIL(12,"")_"Temp"
	if '##Class(%Library.File).DirectoryExists(filePath)
	{
		s isOK = ##Class(%Library.File).CreateDirectoryChain(filePath)
		if $$$ISERR(isOK)
		{
			w "创建目录:"_filePath_" 失败!"	
			q ""
		}
	}
	
	//根据操作系统信息生成文件全名称
	s osString = ##class(%SYSTEM.Version).GetOS()
 	s windowsFlag =$Find(osString,"Windows") 
 	s unixFlag =$Find(osString,"UNIX") 
	if (windowsFlag>0) 
	{	s filePath = filePath_"\"}
	elseif (unixFlag>0) 
	{	s filePath = filePath_"/"}
	
	q filePath
}

/// Debug: w ##class(EPRservice.tool.DataExportMgr).ExportPatData("63","d:\trakcarelive\db\trak\websrc\Temp\dhcepr_1.txt")
ClassMethod ExportPatData(admId As %String, fileName As %String) As %String
{
	s papmiDR = ##class(EPRservice.HISInterface.PatientInfoAssist).GetPapmiDR(admId)
	s papmiNo = ##class(EPRservice.HISInterface.PatientInfoAssist).GetPapmiNo(papmiDR)
	s name = ##class(EPRservice.HISInterface.PatientInfoAssist).Name(papmiDR)
	s sex = ##class(EPRservice.HISInterface.PatientInfoAssist).Gender(papmiDR)
	s sex = $P(sex,"^",3)
	
	w "==============================",!
	w "病人:"_name_" ,性别:"_sex_" ,登记号:"_papmiNo_" ,EpisodeID:"_admId,!
	w "开始导出该病人信息...",!
	 
	//b "s"
	//打开文件
	S stream=##class(%FileCharacterStream).%New()
	S stream.Filename = fileName
	//d stream.TranslateTableSet("UTF8")
	
	//由CategoryId获取对应ECRecord
	s mountCategoryId = ""
	for {
		//b "s"
		s mountCategoryId = $O(^DHCEPRM.ExportCategoryItem(mountCategoryId))
		q:(mountCategoryId="")
		
		s ecRecordId = ##class(EPRinstance.ECRecord).GetIDByEpisodeAndCategoryID(admId, mountCategoryId)
		if (ecRecordId="") continue
		
		s objECRecord = ##class(EPRinstance.ECRecord).%OpenId(ecRecordId)
		s type = objECRecord.ChartItemType
	
		s childSub = ""
		for {
			//b "s"
			s childSub = $O(^DHCEPRI.InstanceDataI("IdxECRecord",ecRecordId,childSub))
			q:(childSub="")
		
			s instanceId = ecRecordId_"||"_childSub
			d ..ExportInstanceData(admId,instanceId,type,.stream)
		}
	}
	
	d stream.SaveStream()
	d stream.%Close()
	
	w "该病人导出结束...",!
}

ClassMethod ExportInstanceData(episodeId As %String, instanceId As %String, type As %String, ByRef stream As %FileCharacterStream)
{
	s objInstance = ##class(EPRinstance.InstanceData).%OpenId(instanceId)
	q:(objInstance="") 
	q:(objInstance.Status="UnSave")
	
	s templateId = objInstance.TemplateID
	q:(templateId="")
	
	s papmiDR = ##class(EPRservice.HISInterface.PatientInfoAssist).GetPapmiDR(episodeId)
	s item = $g(^DHCEPRM.ExportTemplateItem(templateId))
	q:(item="")
	s count = $L(item,"^")
	for i = 1:1:count
	{
		s value = ""
		s subItem = $P(item,"^",i)
		if subItem="$HappenDate$"
		{
			s date = objInstance.HappenDate
			s:(date'="") value = $zd(date,3)
		}
		elseif subItem="$HappenTime$"
		{
			s time = objInstance.HappenTime
			s:(time'="") value = $zd(time,1)
		}
		elseif subItem="$Name$"
		{
			s value = ##class(EPRservice.HISInterface.PatientInfoAssist).Name(papmiDR)
		}
		elseif subItem="$PapmiNo$"
		{
			s value = ##class(EPRservice.HISInterface.PatientInfoAssist).GetPapmiNo(papmiDR)
		}
		elseif $E(subItem,1,1)="$"
		{
			s itemCode = $e(subItem,2,$L(subItem)-1)
			if type="Single"
			{	s value = ##class(EPRservice.BOScatterData).GetEPRData(episodeId,itemCode)}
			else
			{	s value = ##class(EPRservice.BOScatterData).GetEPRMultipleData(episodeId,itemCode,instanceId)}
		}
		else
		{
			s value = subItem
		}
		
		d stream.Write(value)	
	}
}

/// Debug:	w ##class(EPRservice.tool.DataExportMgr).ExportInstanceDataToFile("7||1")
ClassMethod ExportInstanceDataToFile(AInstanceDataID As %String) As %String
{
	s filePath = ..GetFilePath()
	s fileName = filePath_"dhcepr-export-"_AInstanceDataID_".xml"
	
	s objInstance = ##Class(EPRinstance.InstanceData).%OpenId(AInstanceDataID)
	q:(objInstance = "") "数据不存在"
	
	//导出数据到文件
	S stream=##class(%FileCharacterStream).%New()
	S stream.Filename = fileName
	while (objInstance.InstanceData.AtEnd = 0)
	{
		d stream.Write(objInstance.InstanceData.Read(12000))
	}
	d stream.SaveStream()
	d stream.%Close()
	
	w !,"数据导出成功!"
	w !,"导出文件为:"_fileName
}

}
