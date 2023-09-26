Class EMRservice.BOExportQueue Extends %SOAP.WebService [ ClassType = "", ProcedureBlock ]
{

/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/emr/metaservice";

/// Name of the WebService.
Parameter SERVICENAME = "TaskExportQueue";

/// 获取待生成列表
ClassMethod GetWaitTaskQueueList(AStartDate As %String, AEndDate As %String, outType As %String) As EMRservice.dataset.EExportQueue [ WebMethod ]
{
	s dataset = ##class(EMRservice.dataset.EExportQueue).%New()
	d dataset.SetArgs(AStartDate,AEndDate,outType)
	q dataset
}

/// 获取执行列表
ClassMethod GetExeTaskQueueList(AStartDate As %String, AEndDate As %String, outType As %String) As EMRservice.dataset.EExportExeQueue [ WebMethod ]
{
	s dataset = ##class(EMRservice.dataset.EExportExeQueue).%New()
	d dataset.SetArgs(AStartDate,AEndDate,outType)
	q dataset
}

/// 获取成功列表
ClassMethod GetSuccedTaskQueueList(AStartDate As %String, AEndDate As %String, outType As %String) As EMRservice.dataset.EExportSuccedQueue [ WebMethod ]
{
	s dataset = ##class(EMRservice.dataset.EExportSuccedQueue).%New()
	d dataset.SetArgs(AStartDate,AEndDate,outType)
	q dataset
}

/// 获取失败列表
ClassMethod GetFailureTaskQueueList(AStartDate As %String, AEndDate As %String, outType As %String) As EMRservice.dataset.EExportFailure [ WebMethod ]
{
	s dataset = ##class(EMRservice.dataset.EExportFailure).%New()
	d dataset.SetArgs(AStartDate,AEndDate,outType)
	q dataset
}

/// 等待队列移动到执行队列
ClassMethod WaitMoveToExe(ID As %String, OutType As %String) As %String [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLExportQueue).WaitMoveToExe(ID,OutType)
}

/// 执行队列移动到完成队列
ClassMethod ExeMoveToSucced(ID As %String, OutType As %String) As %String [ WebMethod ]
{
	s res = ##Class(EMRservice.BL.BLExportQueue).ExeMoveToSucced(ID,OutType)
	//提供健康乐图片实时上传接口
	if ((res'=0)&&(OutType = "IMAGE"))
	{
		q:(##class(%Dictionary.CompiledClass).%ExistsId("web.DHCENS.BLL.Empi.Method.SendInfoToJKL") = "0") res
		q:(##class(%Dictionary.CompiledMethod).%ExistsId("web.DHCENS.BLL.Empi.Method.SendInfoToJKL||GetAdmInfo") = "0") res
		s objSucced = ##Class(EMRinstance.Export.Succeed).%OpenId(res)
		s EpisodeID = objSucced.EpisodeID
		d ##class(web.DHCENS.BLL.Empi.Method.SendInfoToJKL).GetAdmInfo(EpisodeID)
	}
	q res
}

/// 更新完成队列信息
ClassMethod UpdateSucced(ID As %String, Obj As EMRservice.entity.EQueue) As %String [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLExportQueue).UpdateSucced(ID,Obj)
}

/// 获取队列信息
ClassMethod GetQueueByID(ID As %String, Type As %String) As EMRservice.entity.EQueue [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLExportQueue).GetQueueByID(ID,Type)
}

/// 获取实例ID根据队列ID
/// debug w ##class(EMRservice.BOExportQueue).GetExeInstanceID("Wait","ALL","HTML")
ClassMethod GetExeInstanceID(Type As %String, ListLocID As %String, OutType As %String, AdmType As %String = "") As %String [ WebMethod ]
{
	s strRes = ""
	s waitid = ##Class(EMRservice.BOExportQueue).GetMaxQueueByType(Type,ListLocID,OutType,AdmType)
	q:(waitid ="") strRes
	s isDel= ##Class(EMRservice.BOExportQueue).CheckInstanceIDIsDelete(waitid,Type)
	if (isDel'=1)
	{
		s exeID= ""
		if (Type="Wait")
		{	
			s exeID= ##Class(EMRservice.BOExportQueue).WaitMoveToExe(waitid,OutType) 
		}
		elseif(Type="Failure")
		{
			s exeID= ##Class(EMRservice.BOExportQueue).FailureMoveToExe(waitid,OutType) 
		}
		if (exeID>0)
		{
			s objQueue = ##Class(EMRservice.BOExportQueue).GetQueueByID(exeID,"Exe") 
			if (objQueue="")||(objQueue.InstanceID="")
			{
				d ##Class(EMRservice.BOExportQueue).DeleteExeByID(exeID) 
				q strRes
			}
			s strRes =objQueue.InstanceID
		}
	}
	w strRes
	q strRes
}

/// 获取队列信息ID
ClassMethod GetMaxQueue(Type As %String, ListLocID As %String) As %String [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLExportQueue).GetMaxQueue(Type,ListLocID)
}

/// 获取队列信息ID通过Type
ClassMethod GetMaxQueueByType(Type As %String, ListLocID As %String, OutType As %String, AdmType As %String = "") As %String [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLExportQueue).GetMaxQueueByType(Type,ListLocID,OutType,AdmType)
}

/// 获取队列信息ID
ClassMethod GetMaxTypeQueue(Type As %String, ListLocID As %String, docType As %String) As %String [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLExportQueue).GetMaxTypeQueue(Type,ListLocID,docType)
}

/// 判断实例病历ID是否删除了
ClassMethod CheckInstanceIDIsDelete(ID As %String, Type As %String) As %String [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLExportQueue).CheckInstanceIDIsDelete(ID,Type)
}

/// 删除执行队列中一条数据
ClassMethod DeleteExeByID(ID As %String) As %String [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLExportQueue).DeleteExeByID(ID)
}

/// ///////////根据就诊号生成图片
/// 根据就诊号获取保存的实例ID
ClassMethod GetAllInstanceIDByEpisodeID(AEpisodeId As %String) As %String [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLExportQueue).GetAllInstanceIDByEpisodeID(AEpisodeId)
}

/// 根据病历实例ID获取相关信息
ClassMethod GetQueueByInstanceID(InstanceID As %String, OutType As %String) As EMRservice.entity.EQueue [ WebMethod ]
{
 
    q ##class(EMRservice.BL.BLExportQueue).GetQueueByInstanceID(InstanceID,OutType)
}

/// 向成功队列中插入信息
ClassMethod InsertSucced(obj As EMRservice.entity.EQueue) As %String [ WebMethod ]
{
	q ##class(EMRservice.BL.BLExportQueue).InsertSucced(obj)
}

/// /////////////////////////根据日期获取保存的实例ID
/// 根据日期获取保存的实例ID
ClassMethod GetAllInstanceIDByDate(AStartDate As %String, AEndDate As %String) As %String [ WebMethod ]
{
	q ##class(EMRservice.BL.BLExportQueue).GetAllInstanceIDByDate(AStartDate,AEndDate)
}

/// 查询AEpisodeId获取病历实例ID
ClassMethod GetAllInstanceIDQueryByEpisodeID(AEpisodeId As %String, aType As %String = "IMAGE") As %XML.DataSet [ WebMethod ]
{
	s result=##Class(%XML.DataSet).%New("EMRservice.BL.BLExportQueue:GetAllInstanceIDQueryByEpisodeID")
	d result.SetArgs(AEpisodeId,aType)
	q result
}

/// 查询时间段获取病历实例ID
ClassMethod GetAllInstanceIDQueryByDate(AStartDate As %String, AEndDate As %String, AInstanceID As %String) As %XML.DataSet [ WebMethod ]
{
	s result=##Class(%XML.DataSet).%New("EMRservice.BL.BLExportQueue:GetAllInstanceIDQueryByDate")
	d result.SetArgs(AStartDate,AEndDate,AInstanceID)
	q result
}

/// 入院时间段获取病历实例ID
ClassMethod GetAllInstanceIDByAdmitDate(AStartDate As %String, AEndDate As %String) As %XML.DataSet [ WebMethod ]
{
	s result=##Class(%XML.DataSet).%New("EMRservice.BL.BLExportQueue:GetAllInstanceIDByAdmitDate")
	d result.SetArgs(AStartDate,AEndDate)
	q result
}

/// 执行队列移动到失败队列
ClassMethod ExeMoveToFailure(ID As %String, OutType As %String) As %String [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLExportQueue).ExeMoveToFailure(ID,OutType)
}

/// 根据Locid从等待队列中取一条数据,判断是否存在
ClassMethod CheckInstanceIDIsExit(APatientID As %String, AEpisodeID As %String, AInstanceID As %String, Type As %String, OutType As %String = "") As %String [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLExportQueue).CheckInstanceIDIsExit(APatientID,AEpisodeID,AInstanceID,Type,OutType)
}

/// 失败队列移动到执行队列
ClassMethod FailureMoveToExe(ID As %String, OutType As %String) As %String [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLExportQueue).FailureMoveToExe(ID,OutType)
}

/// 上传CdaXml数据
ClassMethod UploadCDAXmlFileList(aEQueue As EMRservice.entity.EQueue) As %String [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLExportQueue).UploadCDAXmlFileList(aEQueue)
}

/// 根据ID获取文档特性
ClassMethod GetCharacteristicByID(aInstanceID As %String) As %String [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLExportQueue).GetCharacteristicByID(aInstanceID)
}

/// 入院时间段获取病历实例ID
ClassMethod GetRepairInstanceIDs(AStartDate As %String, AEndDate As %String) As %XML.DataSet [ WebMethod ]
{
	s result=##Class(%XML.DataSet).%New("EMRservice.BL.BLExportQueue:GetRepairInstanceIDs")
	d result.SetArgs(AStartDate,AEndDate)
	q result
}

/// Desc:       将正在执行的超时数据批量迁移到失败队列中
/// Creator:    yejian	
/// CreateDate: 2020-6-10	
/// Input:      ATimeOutInterval 超时时间（毫秒） 20分钟 20*60*1000=1200000
/// 				OutType 类型：图片：IMAGE cdaxml:XML
/// Output:     moveCount:科室模板代码,
/// debug w ##Class(EMRservice.BOExportQueue).MoveExeErrorDataTaskExec("1200000","IMAGE")
ClassMethod MoveExeErrorDataTaskExec(ATimeOutInterval As %String, OutType As %String) As %String [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLExportQueue).MoveExeErrorDataTaskExec(ATimeOutInterval,OutType)
}

}
