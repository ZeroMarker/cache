///  名称：		EMRservice.BL.EMRNavigationLog
///  描述：		病历导航操作日志BL层
///  编写者：	yejian
///  编写时间：	2023-2-2
Class EMRservice.BL.EMRNavigationLog Extends (%RegisteredObject, %XML.Adaptor)
{

/// Creator：      yejian
/// CreatDate：    2023-2-2
/// Description:   增加日志
/// Input：        EMRservice.entity.EEMRNavigationLog
/// Output         对输出参数的说明
/// Return：       函数返回值的说明
/// Others：       其它说明
/// Debug:         w ##Class(EMRservice.BL.EMRNavigationLog).AddLog()
ClassMethod AddLog(argDTO As EMRservice.entity.EEMRNavigationLog) As %String
{
	s strRes = "-1"
	s objlog = ##class(EMRmeta.EMRNavigationLog).%New()
	q:(argDTO="")||(argDTO.EmrType ="")||(argDTO.Action ="")||(argDTO.DataID ="") strRes
	
	s objlog.OperateDate = $ZDATEH($ZDATE($h))
 	s objlog.OperateTime =$ZTIMEH($ZTIME($PIECE($h,",",2),1))
	s objlog.EmrType = argDTO.EmrType
	s objlog.Action = argDTO.Action
	s objlog.DataID = argDTO.DataID
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
		 q strRes
	}
}

}
