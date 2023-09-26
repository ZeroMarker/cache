Class EMRservice.BL.BLiBookLogs Extends %RegisteredObject
{

ClassMethod AddLog(AAction, AUserID, ALocID, AGroupID, AIPAdress, AiBookID) As %String
{
		s LogOBJ = ##class(EMRinstance.Repository.iBookLogs).%New()
		s LogOBJ.Action = AAction
		s LogOBJ.UserID = AUserID
		s LogOBJ.CTloCID = ALocID
		s LogOBJ.SSGroupID = AGroupID
		s LogOBJ.OperateMachineIP = AIPAdress
		s LogOBJ.iBookID = AiBookID
		s LogOBJ.OperateDate = $p($h,",",1)
		s LogOBJ.OperateTime = $p($h,",",2)
		s sc=LogOBJ.%Save()
		q:$$$ISERR(sc) 0
		q LogOBJ.%Id()
}

}
