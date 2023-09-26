/// 手术医生资质接口
Class CIS.AN.SRV.SurgenOperService Extends %RegisteredObject
{

ClassMethod SaveSurgenOper(Input As %Stream.GlobalCharacter) As %String
{
	set tSC=##class(%XML.XPATH.Document).CreateFromStream(Input, .tDoc)
	TS
	set tSC=tDoc.EvaluateExpression("/Request/Body/SynUserOperRt","UserCode",.tRes)
	set Count=tRes.Count()
	for num=1:1:Count
	{
		set tResult=tRes.GetAt(num)
		set result="",errMsg=""
		set UserCode="",OperCode="",Flag="",HospitalId=""
		set tSC=tDoc.EvaluateExpression("/Request/Body/SynUserOperRt/UserCode","text()",.tResult)
		if ($$$ISOK(tSC))
		{
			set UserCode=tResult.GetAt(num).Value  //医师工号
			if (UserCode=""){
				set result="<Response><Header><SourceSystem></SourceSystem><MessageID></MessageID></Header><Body><ResultCode>-1</ResultCode><ResultContent>医生工号不能为空</ResultContent></Body></Response>"
				quit
			}
			set surgenId="",surgeonDeptId=""
			&sql(select CTPCP_RowId1 into :surgenId from SQLUser.CT_CareProv where CTPCP_Code=:UserCode)
			if (surgenId=""){
				set result="<Response><Header><SourceSystem></SourceSystem><MessageID></MessageID></Header><Body><ResultCode>-1</ResultCode><ResultContent>医生工号不存在</ResultContent></Body></Response>"
				quit
			}
		}
		set tSC=tDoc.EvaluateExpression("/Request/Body/SynUserOperRt/OperCode","text()",.tResult)
		if ($$$ISOK(tSC))
		{
			set OperCode=tResult.GetAt(num).Value  //手术编码
			if (OperCode=""){
				set result="<Response><Header><SourceSystem></SourceSystem><MessageID></MessageID></Header><Body><ResultCode>-1</ResultCode><ResultContent>手术代码不能为空</ResultContent></Body></Response>"
				quit
			}
			set OperId=""
			&sql(select OPER_RowId into :OperId from SQLUser.ORC_Operation where OPER_Code=:OperCode)
			if (OperId=""){
				set result="<Response><Header><SourceSystem></SourceSystem><MessageID></MessageID></Header><Body><ResultCode>-1</ResultCode><ResultContent>手术Id不存在</ResultContent></Body></Response>"
				quit
			}
		}
		set tSC=tDoc.EvaluateExpression("/Request/Body/SynUserOperRt/DeptRowId","text()",.tResult)
		if ($$$ISOK(tSC))
		{
			set surgeonDeptId=tResult.GetAt(num).Value  //科室Id
			if (surgeonDeptId=""){
				set result="<Response><Header><SourceSystem></SourceSystem><MessageID></MessageID></Header><Body><ResultCode>-1</ResultCode><ResultContent>科室代码不能为空</ResultContent></Body></Response>"
				quit
			}
		}
		set tSC=tDoc.EvaluateExpression("/Request/Body/SynUserOperRt/Flag","text()",.tResult)
		if ($$$ISOK(tSC))
		{
			set Flag=tResult.GetAt(num).Value      //授权/删除
		}
		set tSC=tDoc.EvaluateExpression("/Request/Body/SynUserOperRt/HospitalId","text()",.tResult)
		if ($$$ISOK(tSC))
		{
			set HospitalId=tResult.GetAt(num).Value  //院区Id
		}
		
		set rowId=$o(^CF.AN.SurgeonOperationI("ISurgeonOperation"," "_surgenId," "_OperId,""))
		set obj=##class(CF.AN.SurgeonOperation).%New()
		if (##class(CF.AN.SurgeonOperation).%ExistsId(rowId))
		{
			set obj=##class(CF.AN.SurgeonOperation).%OpenId(rowId)
		}
		set obj.Surgeon=surgenId
		set obj.Operation=OperId
		if (obj.ActiveDate="") set obj.ActiveDate=+$h
		if (Flag="N") set obj.ExpireDate=+$h
		else  set obj.ExpireDate=""
		set obj.SurgeonDept=surgeonDeptId
		set obj.HospitalId=HospitalId
		set status=obj.%Save()
	
		set result=""
		if ($System.Status.IsOK(status))
		{
			set result="<Response><Header><SourceSystem></SourceSystem><MessageID></MessageID></Header><Body><ResultCode>0</ResultCode><ResultContent>成功</ResultContent></Body></Response>"
		}
		else
		{
			set errMsg=$System.Status.GetErrorText(status)	
			set result="<Response><Header><SourceSystem></SourceSystem><MessageID></MessageID></Header><Body><ResultCode>-1</ResultCode><ResultContent>失败:"_errMsg_"</ResultContent></Body></Response>"
			quit
		}
	}
	if +errMsg'=0 TRO
	quit:+errMsg'=0 result
	TC
 	quit result
}

/// Creator：YuanLin
/// CreatDate：2022—11-22
/// Description:同步手术记录
/// w ##class(CIS.AN.SRV.SurgenOperService).SendOperSchedule("2022-11-12","2022-11-24").Read()
ClassMethod SendOperSchedule(Input As %Stream.GlobalCharacter) As %Stream.GlobalCharacter [ WebMethod ]
{
	set xml=##class(%GlobalCharacterStream).%New()
	do xml.Rewind()
	do xml.CopyFrom(Input)
	set sourceSystem=""
	set messageID=""
	set startDateH=+$h,endDateH=+$h

	Set tSC=##class(%XML.XPATH.Document).CreateFromStream(xml, .tDoc)
	Set tSC=tDoc.EvaluateExpression("/Request/Body/OperRecordDateFrom","text()",.tRes)
	if ($$$ISOK(tSC))
	{
		set OperRecordDateFrom=tRes.GetAt(1).Value
		set startDateH=+##class(CIS.AN.COM.DateTime).ConvertToDateH(OperRecordDateFrom,"")
	}
	Set tSC=tDoc.EvaluateExpression("/Request/Body/OperRecordDateTo","text()",.tRes)
	if ($$$ISOK(tSC))
	{
		set OperRecordDateTo=tRes.GetAt(1).Value
		set endDateH=+##class(CIS.AN.COM.DateTime).ConvertToDateH(OperRecordDateTo,"")
	}
	
	set Result=##class(%GlobalCharacterStream).%New()
	do Result.Rewind()
	do Result.Write("<Response><Header><SourceSystem>"_sourceSystem_"</SourceSystem><MessageID>"_messageID_"</MessageID></Header>")
	do Result.Write("<Body>")
	
    set job=$j
    set indexNode="OPDate"
    kill ^TMPOPS(job)
    for date=startDateH:1:endDateH
    {
        set opsId=0
        for
        {
            set opsId=$order(^CIS.AN.OperScheduleI(indexNode,date,opsId))
            quit:(opsId="")
            set operSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)
            set curOperRoomDesc=""
            set:(operSchedule.OperRoom'="") curOperRoomDesc=operSchedule.OperRoom.Description
            set roomNode=curOperRoomDesc
            set:(roomNode="") roomNode="0"
            set operSeqNode=+operSchedule.OperSeq
            set:(operSeqNode=0) operSeqNode=99
            set ^TMPOPS(job,operSchedule.OperDate,roomNode,operSeqNode,+opsId)=""
        }
    }
    // 排序：按手术日期、手术间、手术台次升序排序
    set operDate=0
    for
    {
		set operDate=$o(^TMPOPS(job,operDate))
        quit:(operDate="")
        set operRoom=""
        for
        {
            set operRoom=$o(^TMPOPS(job,operDate,operRoom))
            quit:(operRoom="")  
            set operSeq=0
            for
            {
                set operSeq=$o(^TMPOPS(job,operDate,operRoom,operSeq))
                quit:(operSeq="")
                set opsId=0
                for
                {
                    set opsId=$o(^TMPOPS(job,operDate,operRoom,operSeq,opsId))
                    quit:(opsId="")
					set operRecord=##class(CIS.AN.OperSchedule).%OpenId(opsId)
        			set UserName=##class(CIS.AN.COM.String).GetDescByID("User.CTCareProv","CTPCPDesc",operRecord.AppCareProvID)
    				set UserCode=##class(CIS.AN.COM.String).GetDescByID("User.CTCareProv","CTPCPCode",operRecord.AppCareProvID)
    				
    				set EpisodeID=operRecord.EpisodeID
    				set targetQuery="CIS.AN.BL.Admission:FindPatient"
    				if ##class(CIS.AN.BL.Admission).ExistsInstance(EpisodeID) set targetQuery="CIS.AN.BL.Admission:FindPatientNew"
    				set patInfoObj=##class(CIS.AN.COM.Query).ToObject(targetQuery,EpisodeID)
    				set PatientName=patInfoObj.GetValue("PatName")
    				set InhosNum=##class(CIS.AN.BL.Admission).GetMedicareNo("",EpisodeID)
    				
    				set operData=##class(CIS.AN.BL.OperScheduleList).GetOperList(opsId,.operData)                 // 实施手术
    				set OperName=operData(1,"OperationDesc")
    				set:(OperName="") OperName=operData(1,"Operation")
    				set OperNote=operData(1,"OperNote")
    				set:(OperName="") OperName=OperNote
    				set operInfo=##class(CIS.AN.COM.Query).ToObjects("CIS.AN.BL.OperationList:FindOperationList",opsId)
    				set OperLevel=""
    				for i=1:1:operInfo.Size
    				{
        				set operObj=operInfo.GetAt(i)
        				set OperLevel=operObj.GetValue("OperClassDesc")
    				}
    	
 		            &SQL(Select Assistant into :Assistant from CIS_AN.OperList where OperSchedule=:opsId)
 		            set AsstDesc=operData(1,"AssistantDesc")
    				Set AssistName=$p(AsstDesc,",",1)
    				set SedassistName=$p(AsstDesc,",",2)
        			Set FirstAsst=+$p(Assistant,",",1)
        			set SecAsst=+$p(Assistant,",",2)
    				set AsstCode=##class(CIS.AN.COM.String).GetDescByID("User.CTCareProv","CTPCPCode",FirstAsst)
    				set SedassistCode=##class(CIS.AN.COM.String).GetDescByID("User.CTCareProv","CTPCPCode",SecAsst)
    				
    				set anaestObj=##class(CIS.AN.COM.Query).ToObject("CIS.AN.BL.Anaesthesia:FindAnaesthesia",opsId)
    				set Anesthesiologist=anaestObj.GetValue("Anesthesiologist")
    				set AnesthName=anaestObj.GetValue("AnesthesiologistDesc")
    				set AnesthCode=##class(CIS.AN.COM.String).GetDescByID("User.CTCareProv","CTPCPCode",Anesthesiologist)
    				
    				set HospitalId=operSchedule.HospitalId
					set OperFinishDT=anaestObj.GetValue("OperFinishDT")
                    quit:(OperFinishDT="")
					set OperFinishDT=##class(CIS.AN.BL.RealTimeMonitor).modifyDateTime(OperFinishDT)
					
                    do Result.Write("<SynOperRecordRt>")
    				do Result.Write("<UserName>"_UserName_"</UserName>")
    				do Result.Write("<UserCode>"_UserCode_"</UserCode>")
    				do Result.Write("<PatientName>"_PatientName_"</PatientName>")
    				do Result.Write("<inpatientNo>"_InhosNum_"</inpatientNo>")
    				do Result.Write("<OperCode>"_opsId_"</OperCode>")
    				do Result.Write("<OperName>"_OperName_"</OperName>")
    				do Result.Write("<OperLevel>"_OperLevel_"</OperLevel>")
    				do Result.Write("<OperDate>"_OperFinishDT_"</OperDate>")
    				do Result.Write("<AssistName>"_AssistName_"</AssistName>")
    				do Result.Write("<AssistCode>"_AsstCode_"</AssistCode>")
    				do Result.Write("<SedassistName>"_SedassistName_"</SedassistName>")
    				do Result.Write("<SedassistCode>"_SedassistCode_"</SedassistCode>")
    				do Result.Write("<AnesthName>"_AnesthName_"</AnesthName>")
    				do Result.Write("<AnesthCode>"_AnesthCode_"</AnesthCode>")
    				do Result.Write("<HospitalId>"_HospitalId_"</HospitalId>")
        			do Result.Write("</SynOperRecordRt>")
                }
            }
        }    	
    }
	do Result.Write("</Body></Response>")
	quit Result
}

/// w ##class(CIS.AN.SRV.SurgenOperService).Test()
ClassMethod Test() As %String
{
	set jsonStream = ##class(%Stream.GlobalCharacter).%New()
	do jsonStream.Write("<Request><Header><SourceSystem/><MessageID/></Header><Body><SynUserOperRt><UserCode>2411</UserCode><OperCode>00.0100</OperCode><DeptRowId>384</DeptRowId><Flag>N</Flag><HospitalId>2</HospitalId></SynUserOperRt></Body></Request>")
	set responseStream=..SaveSurgenOper(jsonStream)
	quit responseStream
	quit ""
}

}
