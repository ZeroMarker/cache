/// 手术过程业务类
Class CIS.AN.BL.SurgicalProcedure Extends %RegisteredObject
{

ClassMethod SaveProcedure(opsId As %String, procedureCode As %String, userId As %String, actionDate As %Date, actionTime As %Time, way As %String = "SI") As %String
{
	set procedureId=""
	&sql(select RowId into :procedureId from CIS_AN.SurgicalProcedure where OperSchedule=:opsId and ProcedureCode=:procedureCode)
	set procedure=""
	if (##class(CIS.AN.SurgicalProcedure).%ExistsId(procedureId))
	{
		set procedure=##class(CIS.AN.SurgicalProcedure).%OpenId(procedureId)	
	}	
	else
	{
		set procedure=##class(CIS.AN.SurgicalProcedure).%New() 	
		set procedure.OperSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)
		set procedure.ProcedureCode=procedureCode
	}
	set procedure.ActionUser=userId
	set procedure.ActionDate=actionDate
	set procedure.ActionTime=actionTime
	set procedure.UpdateDate=+$h
	set procedure.UpdateTime=$p($h,",",2)
	set procedure.ActionWay=way
	set sc=procedure.%Save()
	quit:($System.Status.IsError(sc)) "E^"_$System.Status.GetErrorText(sc)
	quit "S^"_procedure.%Id()
}

ClassMethod SaveProcedureByDT(opsId As %String, procedureCode As %String, userId As %String, actionDT As %String, way As %String = "SI") As %String
{
	set actionDate=##class(CIS.AN.COM.DateTime).ConvertToDateH($p(actionDT," ",1))
	set actionTime=##class(CIS.AN.COM.DateTime).ConvertToTimeH($p(actionDT," ",2))
	set ret=..SaveProcedure(opsId,procedureCode,userId,actionDate,actionTime,way)
	quit ret
}

ClassMethod SaveProcedureByPara(dataPara As %String) As %String
{
	set actionDT=dataPara("ActionDT")
	set opsId=dataPara("OPSID")
	set procedureCode=dataPara("ProcedureCode")
	set userId=dataPara("ActionUser")
	set way="SI"
	set ret=..SaveProcedureByDT(opsId,procedureCode,userId,actionDT,way)
	quit ret
}

ClassMethod SaveProcedureForKeyEvent(opsId As %String, dataPara As %String) As %String
{
	k ^TMPCCQ("KeyEventProcedure")
	m ^TMPCCQ("KeyEventProcedure")=dataPara
	set actionInfo=$g(dataPara("OperStartDT"))
	set actionDT=$p(actionInfo,"^",1)
	set actionUser=$p(actionInfo,"^",2)	
	set way="SI"
	set ret=..SaveProcedureByDT(opsId,"OPS",actionUser,actionDT,way)
	quit:($p(ret,"^",1)'="S") ret
	set actionInfo=$g(dataPara("OperFinishDT"))
	set actionDT=$p(actionInfo,"^",1)
	set actionUser=$p(actionInfo,"^",2)	
	set way="SI"
	set ret=..SaveProcedureByDT(opsId,"OPF",actionUser,actionDT,way)
	quit:($p(ret,"^",1)'="S") ret
	set actionInfo=$g(dataPara("AnaStartDT"))
	set actionDT=$p(actionInfo,"^",1)
	set actionUser=$p(actionInfo,"^",2)	
	set way="SI"
	set ret=..SaveProcedureByDT(opsId,"ANS",actionUser,actionDT,way)
	quit:($p(ret,"^",1)'="S") ret
	set actionInfo=$g(dataPara("AnaFinishDT"))
	set actionDT=$p(actionInfo,"^",1)
	set actionUser=$p(actionInfo,"^",2)	
	set way="SI"
	set ret=..SaveProcedureByDT(opsId,"ANF",actionUser,actionDT,way)
	
	quit ret
}

ClassMethod SaveProcedureForPatTrans(opsId As %String) As %String
{
	set operData=##class(CIS.AN.BL.OperData).GetOperDataObjectByCode(opsId,"AN_OPS_002","PreANTransDT")
	set actionDT=operData.KeyValuePairs.GetValue("ExecDT")
	set actionUser=operData.KeyValuePairs.GetValue("UpdateUserID")
	quit:(actionDT="")!(actionUser="") "E^操作事件或操作用户为空"
	set way="SI"
	set ret=..SaveProcedureByDT(opsId,"WO",actionUser,actionDT,way)
	quit ret
}

ClassMethod SaveProcedureArea(opsId As %String, actionUserId As %String) As %String
{
	set areaInDT="",areaOutDT="",ret="S^"
	&sql(select AreaInDT,AreaOutDT into :areaInDT,:areaOutDT from CIS_AN.Anaesthesia where OperSchedule=:opsId)
	//quit:(areaInDT="")!(areaOutDT="") "E^入手术室时间为空或离手术室时间为空"
	set way="SI"
	if (areaInDT'="")
	{
		set actionDT=areaInDT
		set ret=..SaveProcedureByDT(opsId,"AI",actionUserId,actionDT,way)
		quit:($p(ret,"^",1)'="S") ret
	}
	if (areaOutDT'="")
	{
		set actionDT=areaOutDT
		set ret=..SaveProcedureByDT(opsId,"AO",actionUserId,actionDT,way)
	}
	
	
	quit ret
}

/// w ##class(CIS.AN.BL.SurgicalProcedure).SaveWardOutProcedure(66)
ClassMethod SaveWardOutProcedure(opsId As %String) As %String
{
	set ret="S^"
	set dataItem="PreANTransDT",moduleCode=##class(CIS.AN.BL.Constant).#PatTransRecord
	set operDataId=##class(CIS.AN.BL.OperData).GetOperDataIDByCode(opsId,moduleCode,dataItem)
	if (##class(CIS.AN.OperData).%ExistsId(operDataId))
	{
		set operData=##class(CIS.AN.OperData).%OpenId(operDataId)
		set ret=..SaveProcedureByDT(opsId,"WO",operData.UpdateUserID,operData.DataValue,"SI")
	}
	
	quit ret
}

ClassMethod GetProcedureIdByCode(opsId As %String, procedureCode As %String) As %String
{
	set procedureId=""
	&sql(select RowId into :procedureId from CIS_AN.SurgicalProcedure where OperSchedule=:opsId and ProcedureCode=:procedureCode)
	quit procedureId
}

ClassMethod SaveProcedureAfterStop(opsId As %String, procedureCode As %String, actionUserId As %String, actionDT As %String) As %String
{
	/// 写入手术操作过程 CCQ 20200225
	set saveResult=##class(CIS.AN.BL.SurgicalProcedure).SaveProcedureByDT(opsId,procedureCode,actionUserId,actionDT)
	if ($piece(saveResult,"^",1)'="S")
	{
		quit saveResult		
	}
	
	// 如果结束监护同时完成手术，那么写入手术完成操作过程 CCQ20200403
	set opsObj=##class(CIS.AN.OperSchedule).%OpenId(opsId)
	set statusCode=opsObj.Status.Code
	if (statusCode=##class(CIS.AN.BL.Constant).#Finish)
	{
		set saveResult=##class(CIS.AN.BL.SurgicalProcedure).SaveProcedureByDT(opsId,"FNH",actionUserId,actionDT)
	}
	quit saveResult
}

}
