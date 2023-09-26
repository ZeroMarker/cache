Class EMRservice.BL.BLDischargedWaitingToSubmit Extends (%RegisteredObject, %XML.Adaptor)
{

///  Creator:    Donglulu
///  CreateDate: 2020-08-25
///  Desc:       添加患者出院待送病案室表数据
///  Input:      AEpisodeID:就诊号
///  		     ANurseDate:护士结算日期
///  		     ANurseTime:护士结算时间
///  		     AOrderDate:医生下出院医嘱日期
///  		     AOrderTime:医生下出院医嘱时间
///  return:     result 1：成功  0：失败
///  Debug:      w ##Class(EMRservice.BL.BLDischargedWaitingToSubmit).AddData("230","","","","")
ClassMethod AddData(AEpisodeID As %String, ANurseDate As %Date, ANurseTime As %Time, AOrderDate As %Date, AOrderTime As %Time) As %String
{
	s result = "0"
	q:(AEpisodeID = "")||((ANurseDate = "")||(ANurseTime = "")||(AOrderDate = "")||(AOrderTime = "")) result
	s dischargeID = $o(^DHCEMRI.DisWaitToSubmitI("IdxEpisodeID",AEpisodeID,""))	
    if (dischargeID = "")
    {
	    //插入新数据
	    s objDischarge = ##Class(EMRinstance.DischargedWaitingToSubmit).%New()
		d objDischarge.EpisodeIDSetObjectId(AEpisodeID)
    }
    else
    {
	    s objDischarge = ##Class(EMRinstance.DischargedWaitingToSubmit).%OpenId(dischargeID)
	    q:(objDischarge = "") result
    }
    
    s objDischarge.DischargeOrderDate = AOrderDate
    s objDischarge.DischargeOrderTime = AOrderTime
    s objDischarge.NurseSettlementDate = ANurseDate
    s objDischarge.NurseSettlementTime = ANurseTime
    
    s sc = objDischarge.%Save()
    if ($$$ISOK(sc))
	{
		s result = "1"
	}
    q result
}

///  Creator:    Donglulu
///  CreateDate: 2020-08-25
///  Desc:       删除患者出院待送病案室表数据
///  Input:      AEpisodeID:就诊号
///  return:     result 1：成功  0：失败
///  Debug:      w ##Class(EMRservice.BL.BLDischargedWaitingToSubmit).DeleteData("230")
ClassMethod DeleteData(AEpisodeID As %String) As %String
{
	s result = "0"
	q:(AEpisodeID = "") result
	s dischargeID = $o(^DHCEMRI.DisWaitToSubmitI("IdxEpisodeID",AEpisodeID,""))	
    q:(dischargeID = "") result
    s sc = ##class(EMRinstance.DischargedWaitingToSubmit).%DeleteId(dischargeID)
    if ($$$ISOK(sc))
	{
		s result = "1"
	}
    q result
}

///  Creator:    Donglulu
///  CreateDate: 2020-08-25
///  Desc:       根据出院时间计算超过多长时间(系统参数AutoConfirmTime)，自动送病案室，删除患者出院待送病案室表数据
///  Input:      
///  return:     
///  Debug:      d ##Class(EMRservice.BL.BLDischargedWaitingToSubmit).AutomaticTaskConirm()
ClassMethod AutomaticTaskConirm()
{
	s autoConfirmInfo = ##class(EMRservice.BL.BLSysOption).GetOptionValueByName2("AutoConfirmInfo","{""Type"":""NurseSettlement"",""Time"":""72""}")
	s objJson = ##Class(EMRservice.Parser.Json).%New()  
	s confirmInfo = ##Class(%GlobalCharacterStream).%New()
	d confirmInfo.Write(autoConfirmInfo)
	s array = objJson.Deserialize(confirmInfo)
	s autoConfirmType = array.GetAt("Type")
	s autoConfirmHour = array.GetAt("Time")	
	s autoConfirmTime = autoConfirmHour * 3600

	s curDate = $p($h,",",1)
	s curTime = $p($h,",",2)
	//获取应该提交的日期和时间（出院后过了配置的时间间隔的时间）
	s confirmDateTime = ##class(EMRservice.BL.BLDischargedWaitingToSubmit).GetStartDateTime(curDate,curTime,autoConfirmTime)
	s confirmDate = $p(confirmDateTime,",",1)
	s confirmTime = $p(confirmDateTime,",",2)
	q:(confirmDate = "")||(confirmTime = "")
	s tmpDate = confirmDate + 1
	if (autoConfirmType = "DischargeOrder")
	{
		//以下医嘱时间作为出院时间
		s indexName = "IdxOrderDateTime"
	}
	else
	{
		//以护士结算作为出院时间
		s indexName = "IdxSettleDateTime"
	}
		
	for
	{
		s tmpDate = $o(^DHCEMRI.DisWaitToSubmitI(indexName,tmpDate),-1)
		q:(tmpDate = "")
		s tmpTime = ""
		for
		{
			s tmpTime = $o(^DHCEMRI.DisWaitToSubmitI(indexName,tmpDate,tmpTime))
			q:(tmpTime = "")
			continue:((tmpDate = confirmDate)&&(tmpTime > confirmTime))
			s rowid = ""
			for
			{
				s rowid = $o(^DHCEMRI.DisWaitToSubmitI(indexName,tmpDate,tmpTime,rowid))
				q:(rowid = "")
				s objDischarge = ##Class(EMRinstance.DischargedWaitingToSubmit).%OpenId(rowid)
				q:(objDischarge = "")
				s confirmResult = ##Class(EMRservice.BL.BLAdmRecordStatus).ConfirmRecordFinished(objDischarge.RealEpisodeID,"Auto","","Auto","")
			    s deleteResult = ##class(EMRinstance.DischargedWaitingToSubmit).%DeleteId(rowid)
			}
		}
		
	}
}

/// Creator:Donglulu
/// CreatDate:2020-08-26
/// Description:根据截止日期、截止时间、时间间隔(以秒为单位)计算起始日期、起始时间
/// Input:endDate-截止日期,endTime-截止时间,timeSpan-时间间隔
/// Output:
/// Return:起始日期和起始时间,格式为:起始日期,起始时间
/// Others:
/// Debug: w ##class(EMRservice.BL.BLDischargedWaitingToSubmit).GetStartDateTime($P($H,",",1),$P($H,",",2),36000)
ClassMethod GetStartDateTime(endDate As %Date, endTime As %Time, timeSpan As %Integer) As %String
{
	
	s result = ""
	q:(endDate = "")||(endTime = "")||(timeSpan = "") result
	
	s curDate = timeSpan\86400
	s value = endTime - (timeSpan - (curDate*86400)) 
	if (value < 0)
	{
		s startDate = endDate-curDate-1
		s startTime = 86400-(timeSpan - (curDate*86400) - endTime)
	}
	else
	{
		s startDate = endDate-curDate
		s startTime = endTime - (timeSpan - (curDate*86400))
	}
	
	s result = startDate_","_startTime
	q result
}

///  Creator:    Donglulu
///  CreateDate: 2020-08-25
///  Desc:       根据出院时间计算超过多长时间(系统参数AutoConfirmTime)，自动送病案室（无需出院时其他组调接口）
///  Input:      
///  return:     
///  Debug:      d ##Class(EMRservice.BL.BLDischargedWaitingToSubmit).AutomaticTaskSubmit()
ClassMethod AutomaticTaskSubmit()
{
	s autoConfirmInfo = ##class(EMRservice.BL.BLSysOption).GetOptionValueByName2("AutoConfirmInfo","{""Type"":""NurseSettlement"",""Time"":""72""}")
	s objJson = ##Class(EMRservice.Parser.Json).%New()  
	s confirmInfo = ##Class(%GlobalCharacterStream).%New()
	d confirmInfo.Write(autoConfirmInfo)
	s array = objJson.Deserialize(confirmInfo)
	s autoConfirmType = array.GetAt("Type")
	s autoConfirmHour = array.GetAt("Time")	
	s autoConfirmTime = autoConfirmHour * 3600
	
	s day = autoConfirmHour\24 + 1

	s curDate = $p($h,",",1)
	s curTime = $p($h,",",2)
	//获取应该提交的日期和时间（出院后过了配置的时间间隔的时间）
	s confirmDateTime = ##class(EMRservice.BL.BLDischargedWaitingToSubmit).GetStartDateTime(curDate,curTime,autoConfirmTime)
	s confirmDate = $p(confirmDateTime,",",1)
	s confirmTime = $p(confirmDateTime,",",2)
	q:(confirmDate = "")||(confirmTime = "")
	s endDate = confirmDate - day
	
	s tmpDate = confirmDate + 1
	for
	{
		s tmpDate = $o(^PAADMi("DischDate",tmpDate),-1)
		q:(tmpDate = "")
		q:(tmpDate < endDate)
		s PAADMRowID = ""
		for
		{
			s PAADMRowID = $O(^PAADMi("DischDate",tmpDate,PAADMRowID))
			q:(PAADMRowID = "")
			
			s status = ##Class(EMRservice.InterfaceService.AdmRecordStatus).GetAdmRecordStatus(PAADMRowID)
			continue:(status = "1")
			s confirmResult = ##Class(EMRservice.BL.BLAdmRecordStatus).ConfirmRecordFinished(PAADMRowID,"Auto","","Auto","")
		}
		
	}
}

}
