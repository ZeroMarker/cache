///  名称：		EMRservice.BL.BLEMRTemplateCLog
///  描述：		病历展现操作日志表BL层
///  编写者：	yejian
///  编写时间：	2021-4-12
Class EMRservice.BL.BLEMRTemplateCLog Extends (%RegisteredObject, %XML.Adaptor)
{

/// Creator：      yejian
/// CreatDate：    2021-4-12
/// Description:   增加日志
/// Input：        EMRservice.entity.EEMRTemplateCLog
/// Output         对输出参数的说明
/// Return：       函数返回值的说明
/// Others：       其它说明
/// Debug:         w ##Class(EMRservice.BL.BLEMRTemplateCLog).AddLog()
ClassMethod AddLog(argDTO As EMRservice.entity.EEMRTemplateCLog) As %String
{
	s strRes = "-1"
	s objlog = ##class(EMRmeta.EMRTemplateCLog).%New()
	q:(argDTO="")||(argDTO.EmrType ="")||(argDTO.Action ="")||(argDTO.DataID ="") strRes
	
	s argDTO.Status = ""
	s objlog.OperateDate = $ZDATEH($ZDATE($h))
 	s objlog.OperateTime =$ZTIMEH($ZTIME($PIECE($h,",",2),1))
 	//操作DOCID时状态控制
	if (argDTO.EmrType="TEMPCATE")
	{
		//获取该数据最新日志
		s dtoMLog =..GetMaxLog(argDTO.EmrType ,argDTO.DataID)
		if (dtoMLog'="")
		{
			//同步起始和停止时间
			s objlog.StartDate = $case(dtoMLog.StartDate,$c(0):$c(0),:dtoMLog.StartDate)
	 		s objlog.StartTime =$case(dtoMLog.StartTime,$c(0):$c(0),:dtoMLog.StartTime)
	 		s objlog.StopDate = $case(dtoMLog.StopDate,$c(0):$c(0),:dtoMLog.StopDate)
	 		s objlog.StopTime =$case(dtoMLog.StopTime,$c(0):$c(0),:dtoMLog.StopTime)
		}
		//获取DOCID在模板组关联的次数
		s strGIDCount = 0
		s DocID = argDTO.DataID
		&sql(SELECT count(d.ID) into:strGIDCount FROM EMRmeta_EMRDocRestriction.DocsInGroup d WHERE d.DocID=:DocID)
		
		if (argDTO.Action = "ADD")
		{
			S argDTO.Status = "NOSTART"
		}
		elseif (argDTO.Action = "UP")
		{
			S argDTO.Status = dtoMLog.Status
		}
		elseif (argDTO.Action = "ADDGROUP")
		{
			//模板组次数为1，刚添加设置起始时间，并设置状态为START
			if (strGIDCount=1)
			{
				s objlog.StartDate = objlog.OperateDate
 				s objlog.StartTime =objlog.OperateTime
 				s objlog.StopDate =""
 				s objlog.StopTime =""
			}
			s argDTO.Status = "START"
		}
		elseif (argDTO.Action = "REMOVEGROUP")
		{
			//模板组次数为0，刚添加设置停止时间，并设置状态为STOP
			if (strGIDCount=0)
			{
				s objlog.StopDate =objlog.OperateDate
 				s objlog.StopTime =objlog.OperateTime
			}
			s argDTO.Status = $case(strGIDCount,0:"STOP",:"START")
		}
		elseif (argDTO.Action = "DELETE")
		{
			S argDTO.Status = "DELETE"
		}
		
	}
	s objlog.EmrType = argDTO.EmrType
	s objlog.Action = argDTO.Action
	s objlog.DataID = argDTO.DataID
	s objlog.Status = argDTO.Status
	s objlog.UserID = argDTO.UserID
	s UserName =argDTO.UserID
	s SSUSRRowId = $o(^SSU("SSUSR",0,"SSUSR_Initials",argDTO.UserID,""))
	if (SSUSRRowId'="") 
	{
		s UserName = $p($g(^SSU("SSUSR",SSUSRRowId)),"^",2) //书写医生姓名
	}
	s objlog.UserName = UserName
	
	s objlog.MachineIP = argDTO.MachineIP	
	s objlog.Remark = argDTO.Remark		
	
	s sc = objlog.%Save()
	if ($$$ISOK(sc))
	{
		s strRes =objlog.%Id()
		q strRes
	}
	else
	{
		 quit strRes
	}
}

/// Creator：      yejian
/// CreatDate：    2021-1-11
/// Description:   获取最新日志
/// Table：        CF_EMR_DOC.TemplateStatusMLog
/// Input：        aTemplateVersionID 文档版本ID
/// Output         对输出参数的说明
/// Return：       函数返回值的说明
/// Others：       其它说明
/// Debug:         w ##Class(EMRservice.BL.BLEMRTemplateCLog).GetMaxLog(1)
ClassMethod GetMaxLog(aEmrType As %String, aDataID As %String) As EMRservice.entity.EEMRTemplateCLog
{
	s dtoMlog = ##class(EMRservice.entity.EEMRTemplateCLog).%New()
	s strMaxMLogID = $o(^DHCEMRM.EMRTemplateCLogI("IdxTypeDataID"," "_aEmrType," "_aDataID,""),-1)
	q:(strMaxMLogID ="") dtoMlog
	s objMLog = ##class(EMRmeta.EMRTemplateCLog).%OpenId(strMaxMLogID)
	s dtoMlog.EmrType = objMLog.EmrType
	s dtoMlog.Action = objMLog.Action
	s dtoMlog.DataID = objMLog.DataID
	s dtoMlog.Status = objMLog.Status
	s dtoMlog.UserID = objMLog.UserID
	s dtoMlog.UserName = objMLog.UserName
	s dtoMlog.OperateDate = objMLog.OperateDate
 	s dtoMlog.OperateTime  = objMLog.OperateTime
 	s dtoMlog.StartDate = objMLog.StartDate
 	s dtoMlog.StartTime  = objMLog.StartTime
 	s dtoMlog.StopDate = objMLog.StopDate
 	s dtoMlog.StopTime  = objMLog.StopTime
	s dtoMlog.MachineIP = objMLog.MachineIP	
	s dtoMlog.Remark = objMLog.Remark		
	q dtoMlog
}

/// w ##Class(EMRservice.BL.BLEMRTemplateCLog).Test()
ClassMethod Test() As %String
{
	s ReturnValue = ""
	
	s objDTO  = ##class(EMRmeta.EMRTemplateCLog).%New()
	s objDTO.EmrType = "TEMPCATE"
	s objDTO.Action="ADDGROUP"
	s objDTO.DataID = "328"
	s objDTO.UserID = "demo"
	s objDTO.MachineIP = "127.0.0.1"
	s ReturnValue =  ..AddLog(objDTO)
	
	q ReturnValue
}

}
