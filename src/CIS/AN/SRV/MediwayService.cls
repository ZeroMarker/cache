Class CIS.AN.SRV.MediwayService Extends %RegisteredObject
{

ClassMethod GetOperAppOrderItemId(opaId As %String) As %String
{
    Set operArrange=##class(User.DHCANOPArrange).%OpenId(opaId)
    Set ORAnaestID=operArrange.OPAAnaestDr
    Set ordId=$ORDER(^OEORDi(0,"Ana",ORAnaestID,""))
	Set ordSubId=$ORDER(^OEORDi(0,"Ana",ORAnaestID,ordId,""))
    Quit ordId_"||"_ordSubId
}

ClassMethod PushStatusMessageOld(opsId As %String, params As %String) As %String
{
    Set $ZTRAP="Error"
    Set jsonStr=""
    Set operArrange=##class(User.DHCANOPArrange).%OpenId(opsId)
    Set ORAnaestID=operArrange.OPAAnaestDr
    Set ORAnaesthesia=##class(User.ORAnaesthesia).%OpenId(ORAnaestID)
    Set appOrderItemId=..GetOperAppOrderItemId(opsId)
    Set appOrderItemId="",actionDate="",actionTime=""
    Set statusCode=$PIECE(params,"&&&",1)
    Set userId=$PIECE(params,"&&&",2)
    Set userName=$PIECE(params,"&&&",3)
    If (statusCode="RI")
    {
        // 入手术间时间
        Set:(ORAnaesthesia.ANATheatreInDate>0) actionDate=$ZDATE(ORAnaesthesia.ANATheatreInDate,3)
        Set:(ORAnaesthesia.ANATheatreInTime>0) actionTime=$ZTIME(ORAnaesthesia.ANATheatreInTime,1)
    }
    ElseIf (statusCode="RO")
    {
        // 离手术间时间
        Set:(ORAnaesthesia.ANATheatreOutDate>0) actionDate=$ZDATE(ORAnaesthesia.ANATheatreOutDate,3)
        Set:(ORAnaesthesia.ANATheatreOutTime>0) actionTime=$ZTIME(ORAnaesthesia.ANATheatreOutTime,1)
    }
    ElseIf (statusCode="ANS")
    {
        // 麻醉开始时间
        Set:(ORAnaesthesia.ANADate>0) actionDate=$ZDATE(ORAnaesthesia.ANADate,3)
        Set:(ORAnaesthesia.ANAAnaStartTime>0) actionTime=$ZTIME(ORAnaesthesia.ANAAnaStartTime,1)
    }
    ElseIf (statusCode="OPS")
    {
        // 手术开始时间
        Set:(operArrange.OPAStartDate>0) actionDate=$ZDATE(operArrange.OPAStartDate,3)
        Set:(operArrange.OPAStartTime>0) actionTime=$ZTIME(operArrange.OPAStartTime,1)
    }
    ElseIf (statusCode="OPF")
    {
        // 手术结束时间
        Set:(operArrange.OPAEndDate>0) actionDate=$ZDATE(operArrange.OPAEndDate,3)
        Set:(operArrange.OPAEndTime>0) actionTime=$ZTIME(operArrange.OPAEndTime,1)
    }
    ElseIf (statusCode="PI")
    {
        // 麻醉开始时间
        Set:(ORAnaesthesia.ANAPACUStartDate>0) actionDate=$ZDATE(ORAnaesthesia.ANAPACUStartDate,3)
        Set:(ORAnaesthesia.ANAPACUStartTime>0) actionTime=$ZTIME(ORAnaesthesia.ANAPACUStartTime,1)
    }
    ElseIf (statusCode="PO")
    {
        // 麻醉开始时间
        Set:(ORAnaesthesia.ANAPACUFinishDate>0) actionDate=$ZDATE(ORAnaesthesia.ANAPACUFinishDate,3)
        Set:(ORAnaesthesia.ANAPACUFinishTime>0) actionTime=$ZTIME(ORAnaesthesia.ANAPACUFinishTime,1)
    }
    Set actionDateTime=""
    Set:(actionDate'="")&(actionTime'="") actionDateTime=actionDate_" "_actionTime
    Set jsonStr="[{""OEOrdItemID"":"""_appOrderItemId_""",""Position"":"""",""ExamID"":"""_opsId_""",""Status"":"""_statusCode_""","
    Set jsonStr=jsonStr_"""UserID"":"""_userId_""",""UserName"":"""_userName_""",""UpDateTime"":"""_actionDateTime_""",""SourceSystem"":""AN"",""Notes"":""""}]"
    Set result=##class(web.DHCENS.EnsHISService).DHCHisInterface("UpdateSystemStatus",jsonStr)
    Quit jsonStr_$CHAR(0)_result
Error
    Quit jsonStr_$CHAR(0)_$ZERROR
}

ClassMethod PushStatusMessage(opsId As %String) As %String
{
}

ClassMethod SyncOperationInfoToJKL(opsId As %String, params As %String, messageId As %String, methodId As %String) As %String
{
    Set $ZTRAP="Error"
    Set interfaceMessage=##class(CIS.AN.SRV.InterfaceMessage).%OpenId(messageId)
    &sql(declare operListCursor cursor for select 
        RowId,
        OperSchedule->EpisodeID,
        OperSchedule->OperDate,
        Operation,
        CIS_AN_COM.String_GetDescByID('User.ORCOperation','OPERDesc',Operation)
        into :RowId,:EpisodeID,:OperDateH,:OperationId,:OperationName
        from CIS_AN.OperList where OperSchedule=:opsId)
    &sql(open operListCursor)
    For 
    {
        &sql(fetch operListCursor)
        Quit:(SQLCODE'=0)
        Set OperDate=$ZDATE(OperDateH,3)
        // 发送前写日志
        Set originalText="{""EpisodeID"":"""_EpisodeID_""",""OperationId"":"""_OperationId_""",""OperationName"":"""_OperationName_""",""OperationDate"":"""_OperDate_"""}"
        Do ##class(CIS.AN.SRV.MessageLog).NewLog(messageId,methodId,interfaceMessage.CreateUser,originalText,"")
        // 发送消息
        Set response=##Class(MHC.BI.FollowUpService).SyncOperationInfoToJKL(EpisodeID, OperationId, OperationName, OperDate)
        // 发送后写日志
        Do ##class(CIS.AN.SRV.MessageLog).NewLog(messageId,methodId,interfaceMessage.CreateUser,originalText,response)
    }
    &sql(close operListCursor)
    Quit "S^"
Error 
    Quit "E^"_$ZERROR
}

}
