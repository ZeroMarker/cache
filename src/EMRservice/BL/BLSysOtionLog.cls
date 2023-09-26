/// Desc:       系统参数操作日志BL层
/// Creator:    yejian
/// CreateDate: 2018-6-13
Class EMRservice.BL.BLSysOtionLog Extends (%RegisteredObject, %XML.Adaptor)
{

Query SelectALLLog() As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID:%Integer,OldDescription:%String,OldIsVisible:%String,OldIsEditor:%String,OldName:%String,OldOptionValue:%String,NewDescription:%String,NewIsVisible:%String,NewIsEditor:%String,NewName:%String,NewOptionValue:%String,Action:%String,OperateDate:%Date,OperateTime:%Time,OperateUserID:%String,OperateUserName:%String,OperateMachineIP:%String", SELECTMODE = "RUNTIME") [ SqlName = SP_EMR_SysOtionLog_SelectALLLog, SqlProc ]
{
	SELECT ID,OldDescription,OldIsVisible,OldIsEditor,OldName,OldOptionValue,NewDescription,NewIsVisible,NewIsEditor,NewName,NewOptionValue,Action,OperateDate,OperateTime,OperateUserID,OperateUserName,OperateMachineIP
	FROM EMRmeta.SysOptionLog
}

ClassMethod CreateLog(AobjLog As EMRservice.entity.ESysOptionLog) As %String [ WebMethod ]
{
	s ret = 0
	s objLog = ##class(EMRmeta.SysOptionLog).%New()
	q:(objLog ="") ret
	s objLog.Action = AobjLog.Action
	s objLog.NewDescription = AobjLog.NewDescription
	s objLog.NewIsEditor = AobjLog.NewIsEditor
	s objLog.NewIsVisible = AobjLog.NewIsVisible
	s objLog.NewName = AobjLog.NewName
	s objLog.NewOptionValue = AobjLog.NewOptionValue
	s objLog.OldDescription = AobjLog.OldDescription
	s objLog.OldIsEditor = AobjLog.OldIsEditor
	s objLog.OldIsVisible = AobjLog.OldIsVisible
	s objLog.OldName = AobjLog.OldName
	s objLog.OldOptionValue = AobjLog.OldOptionValue
	s objLog.OperateDate =  $ZDATEH($ZDATE($HOROLOG))
	s objLog.OperateMachineIP = AobjLog.OperateMachineIP
	s objLog.OperateTime =  $ZTIMEH($ZTIME($PIECE($HOROLOG,",",2),1))
	s objLog.OperateUserID = AobjLog.OperateUserID
	s objLog.OperateUserName = AobjLog.OperateUserName
	if (objLog.%Save())
	{
		s ret=objLog.%Id()
	}
	else
	{
		s ret=-1
	}
	q ret
}

}
