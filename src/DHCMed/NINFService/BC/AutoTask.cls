/// 名称:DHCMed.NINFService.BC.AutoTask
/// 描述: 疑似病例筛查 自动任务
/// 编写者：zhufei
/// 编写日期: 2013-12-03
Class DHCMed.NINFService.BC.AutoTask Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Not ProcedureBlock ]
{

/// 生成疑似病例筛查的自动任务
/// w ##Class(DHCMed.NINFService.BC.AutoTask).CasesXTask("2013-11-01","2013-11-01","INTCCS")
ClassMethod CasesXTask(aDateFrom As %String, aDateTo As %String, aConfigCode As %String) As %String
{
	new (aDateFrom,aDateTo,aConfigCode)
	set return=0
	quit:(aConfigCode="") return
	quit:(aDateFrom="")||(aDateTo="") return
	
	set:aDateFrom["-" aDateFrom=$zdh(aDateFrom,3)
	set:aDateTo["-" aDateTo=$zdh(aDateTo,3)
	
	set return=-1
	set objConfig=##class(DHCMed.CC.SubjectConfig).GetObjByCode(aConfigCode)
	quit:'$IsObject(objConfig) return
	set ConfigID=objConfig.%Id()
	set SubjectCode=objConfig.SubjectCode
	quit:SubjectCode="" return
	
	set return=-2
	set objSubject=##class(DHCMed.CC.Subject).GetObjByCode(SubjectCode)
	quit:'$IsObject(objSubject) return
	set SubjectID=objSubject.%Id()
	quit:SubjectID="" return
	
	set xDate=aDateFrom-1
	for {
		set xDate=$o(^DHCMed.CC.CtlResultI("Detail","IndexSubjectEpisodeActDate",xDate))
		quit:xDate=""
		quit:xDate>aDateTo
		
		set xEpisodeID=0
		for {
			set xEpisodeID=$o(^DHCMed.CC.CtlResultI("Detail","IndexSubjectEpisodeActDate",xDate,xEpisodeID))
			quit:xEpisodeID=""
			
			set AdmType=$p($g(^PAADM(xEpisodeID)),"^",2)
			continue:(AdmType'="I")&&(AdmType'="E")  //疑似病例筛查只检查住院患者和急诊出院患者
			
			//取入院时间
			//set tmpDateTime=##class(DHCMed.NINFService.BC.CommonSrv).GetInHospDateTime(xEpisodeID)
			//set AdmDate=$p(tmpDateTime,",",1)
			//set AdmTime=$p(tmpDateTime,",",2)
			//upadte by pylian 2016-02-18 修改入院时间取值方式
    		Set AdmDateTime=##Class(DHCMed.SSIO.FromAdmSrv).GetAdmDateTime(xEpisodeID)
			Set AdmDate=$p(AdmDateTime,"^",1)
			Set AdmTime=$p(AdmDateTime,"^",2)
			continue:(AdmDate="")||(AdmTime="")
			
			set AdmLoc=$p($g(^PAADM(xEpisodeID)),"^",4)
			set LogonHospID=##class(DHCMed.SSService.HospitalSrv).GetCTHospID(AdmLoc)
			set SSHospCode=##class(DHCMed.SSService.HospitalSrv).GetSSHospCode(LogonHospID,"NINF")
			
			kill arrItem
			kill ItemCatList
			set ItemCatList=""
			set ScreenGrade=0  //筛查等级
			set TempOutFlag=0
			set xResultID=0
			for {
				set xResultID=$o(^DHCMed.CC.CtlResultI("Detail","IndexSubjectEpisodeActDate",xDate,xEpisodeID,SubjectID,xResultID))
				quit:xResultID=""
				
				set objResult=##class(DHCMed.CC.CtlResult).GetObjById(xResultID)
				continue:'$IsObject(objResult)
				
				//入院48小时内的监测项目不在筛查范围内
				set OccurDate=objResult.OccurDate
				set OccurTime=objResult.OccurTime
				set IPHour=((OccurDate-AdmDate)*24)+((OccurTime-AdmTime)\3600)
				continue:IPHour<48
				
				set ItemID=objResult.ItemId
				continue:$d(arrItem(ItemID))
				
				set objItem=##class(DHCMed.CC.SubjectItm).GetObjById(ItemID)
				continue:'$IsObject(objItem)
				
				set ItemDicDr=objItem.ItemDic
				set objItemDic=##class(DHCMed.CC.ItemDic).GetObjById(ItemDicDr)
				continue:'$IsObject(objItemDic)
				set SubCatDr=objItemDic.IDSubCatDr
				Continue:SubCatDr=""
				Continue:'$d(^DHCMed.CC.MapSubjectSubCatI("IndexConfigCat",ConfigID,SubCatDr))
				Set objSubCat=##class(DHCMed.CC.ItemSubCat).GetObjById(SubCatDr)
				Continue:'$IsObject(objSubCat)
				Set ISCCatDr=objSubCat.ISCCatDr
				Set ISCKeywordID=objSubCat.ISCKeywordID
				Set ISCKeywordCode=""
				If ISCKeywordID'="" {
					Set objKeyword=##class(DHCMed.CC.KeyWord).GetObjById(+ISCKeywordID)
					Set:$IsObject(objKeyword) ISCKeywordCode=objKeyword.Code
				}
				
				set Score=objItem.Score  //借用Score字段作为项目等级字段
				continue:Score<1
				set:(Score>0)&&(Score<=50) ItemGroup=1
				set:(Score>50)&&(Score<=100) ItemGroup=2
				set:Score>100 ItemGroup=3
				
				set arrItem(ItemID)=ItemGroup
				set:ItemGroup>ScreenGrade ScreenGrade=ItemGroup
				
				//郑五附院 两类几以上二级项目设置为三级
				if SSHospCode="41-ZZDXWF" {
					if ItemGroup=2 {
						if ($listfind(ItemCatList,ISCCatDr)<1){
							set ItemCatList=ItemCatList_$lb(ISCCatDr)
						}
						set:$listlength(ItemCatList)>1 ScreenGrade=3
					}
				}
				
				//北京协和 体温与其他项目并列时才在筛查范围
				if SSHospCode="11-XH" {
					set:ISCKeywordCode="OutOfTemperature" TempOutFlag=1
					if ($listfind(ItemCatList,ISCCatDr)<1){
						set ItemCatList=ItemCatList_$lb(ISCCatDr)
					}
				}
			}
			
			//北京协和 体温与其他项目并列时才在筛查范围
			if SSHospCode="11-XH" {
				if (ItemGroup<3)&&((TempOutFlag=0)||($listlength(ItemCatList)<2)) {
					set ScreenGrade=0
				}
			}
			
			//没有达到筛查等级的过滤掉
			continue:ScreenGrade<1
			
			//保存病例筛查日志信息
			set inputStr=""  //ID
			set inputStr=inputStr_"^"_aConfigCode
			set inputStr=inputStr_"^"_xEpisodeID
			set inputStr=inputStr_"^"_xDate
			set inputStr=inputStr_"^"_ScreenGrade
			set inputStr=inputStr_"^"_+$h
			set inputStr=inputStr_"^"_$p($h,",",2)
			set inputStr=inputStr_"^"_1
			set inputStr=inputStr_"^"_""
			set flg=##class(DHCMed.NINF.BC.CasesX).Update(inputStr,"^")
			if flg>0 {
				set CasesXID=flg
			}
		}
	}
	
	set return=1
	quit return
}

/// w ##Class(DHCMed.NINFService.BC.AutoTask).WarningTask("2014-04-09","2017-04-10","INFWARN")
ClassMethod WarningTask(aDateFrom As %String, aDateTo As %String, aConfigCode As %String) As %String
{
	new (aDateFrom,aDateTo,aConfigCode)
	set return=0
	quit:(aConfigCode="") return
	quit:(aDateFrom="")||(aDateTo="") return
	
	set:aDateFrom["-" aDateFrom=$zdh(aDateFrom,3)
	set:aDateTo["-" aDateTo=$zdh(aDateTo,3)
	
	set return=-1
	set objConfig=##class(DHCMed.CC.SubjectConfig).GetObjByCode(aConfigCode)
	quit:'$IsObject(objConfig) return
	set ConfigID=objConfig.%Id()
	set SubjectCode=objConfig.SubjectCode
	quit:SubjectCode="" return
	
	set return=-2
	set objSubject=##class(DHCMed.CC.Subject).GetObjByCode(SubjectCode)
	quit:'$IsObject(objSubject) return
	set SubjectID=objSubject.%Id()
	quit:SubjectID="" return
	
	set xDate=aDateFrom-1
	for {
		set xDate=$o(^DHCMed.CC.CtlResultI("Detail","IndexSubjectEpisodeActDate",xDate))
		quit:xDate=""
		quit:xDate>aDateTo
		
		set xEpisodeID=0
		for {
			set xEpisodeID=$o(^DHCMed.CC.CtlResultI("Detail","IndexSubjectEpisodeActDate",xDate,xEpisodeID))
			quit:xEpisodeID=""
			
			set AdmType=$p($g(^PAADM(xEpisodeID)),"^",2)
			continue:(AdmType'="I")&&(AdmType'="E")  //感染爆发预警筛查只检查住院患者和急诊出院患者
			
			//取入院时间
			//set tmpDateTime=##class(DHCMed.NINFService.BC.CommonSrv).GetInHospDateTime(xEpisodeID)
			//set AdmDate=$p(tmpDateTime,",",1)
			//set AdmTime=$p(tmpDateTime,",",2)
			//upadte by pylian 2016-02-18 修改入院时间取值方式
    		Set AdmDateTime=##Class(DHCMed.SSIO.FromAdmSrv).GetAdmDateTime(xEpisodeID)
			Set AdmDate=$p(AdmDateTime,"^",1)
			Set AdmTime=$p(AdmDateTime,"^",2)
			continue:(AdmDate="")||(AdmTime="")
			
			set xResultID=0
			for {
				set xResultID=$o(^DHCMed.CC.CtlResultI("Detail","IndexSubjectEpisodeActDate",xDate,xEpisodeID,SubjectID,xResultID))
				quit:xResultID=""
				
				set objResult=##class(DHCMed.CC.CtlResult).GetObjById(xResultID)
				continue:'$IsObject(objResult)
				set ActDate=objResult.ActDate
				set ActTime=objResult.ActTime
				set OccurDate=objResult.OccurDate
				set OccurTime=objResult.OccurTime
				
				//暴发预警不做入院48小时过滤
				//入院48小时内的监测项目不在筛查范围内
				//set IPHour=((OccurDate-AdmDate)*24)+((OccurTime-AdmTime)\3600)
				//continue:IPHour<48
				
				set ItemID=objResult.ItemId
				set objItem=##class(DHCMed.CC.SubjectItm).GetObjById(ItemID)
				continue:'$IsObject(objItem)
				
				set ItemDicDr=objItem.ItemDic
				set objItemDic=##class(DHCMed.CC.ItemDic).GetObjById(ItemDicDr)
				continue:'$IsObject(objItemDic)
				set SubCatDr=objItemDic.IDSubCatDr
				continue:SubCatDr=""
				
				//检查是否主题配置中项目
				Continue:'$d(^DHCMed.CC.MapSubjectSubCatI("IndexConfigCat",ConfigID,SubCatDr))
				
				set objSubCat= ##class(DHCMed.CC.ItemSubCat).GetObjById(SubCatDr)
				continue:'$IsObject(objSubCat)
				set SCKeyWordDr=objSubCat.ISCKeywordID
				set objSCKeyWord=##class(DHCMed.CC.KeyWord).GetObjById(SCKeyWordDr)
				if $IsObject(objSCKeyWord){
					set SCKeyWord=objSCKeyWord.Code
				} else {
					set SCKeyWord=""
				}
				
				set ItemDesc=objItemDic.IDDesc
				set DataValue=objResult.DataValue
				set DataValue=$tr(DataValue,"^","`")
				set DataSummary=objResult.Summary
				set DataSummary=$tr(DataSummary,"^","`")
				
				Set WAKeyWord=..CheckWAKeyWord(SCKeyWord)
				
				set tmpLocWard=##class(DHCMed.NINFService.BC.CommonSrv).GetAdmitLocWard(xEpisodeID,OccurDate,OccurTime)
				set ActLoc=$p(tmpLocWard,",",1)
				set ActWard=$p(tmpLocWard,",",3)
				
				set ID=$o(^DHCMed.NINF.BC.WarningI("IndexResultID",xResultID,0))
				
				//保存病例筛查日志信息
				set inputStr=ID
				set inputStr=inputStr_"^"_aConfigCode
				set inputStr=inputStr_"^"_xEpisodeID
				set inputStr=inputStr_"^"_ActDate
				set inputStr=inputStr_"^"_ActTime
				set inputStr=inputStr_"^"_ItemID
				set inputStr=inputStr_"^"_ItemDesc
				set inputStr=inputStr_"^"_DataValue
				set inputStr=inputStr_"^"_WAKeyWord
        		set inputStr=inputStr_"^"_DataSummary
				set inputStr=inputStr_"^"_ActLoc
				set inputStr=inputStr_"^"_ActWard
				set inputStr=inputStr_"^"_1
				set inputStr=inputStr_"^"_""
				set inputStr=inputStr_"^"_xResultID
				set flg=##class(DHCMed.NINF.BC.Warning).Update(inputStr,"^")
				if flg>0 {
					set WarningID=flg
				}
			}
		}
	}
	
	set return=1
	quit return
}

ClassMethod CheckWAKeyWord(aSCKeyWord As %String) As %String
{
	New (aSCKeyWord)
	Set return=""
	Quit:aSCKeyWord="" return
	
	If aSCKeyWord="OutOfTemperature" {
		Set return="体温异常"	            //体温异常
	} ElseIf aSCKeyWord="TemperatureAnomaly" {
		Set return="体温持续异常"	        //体温持续异常
	} ElseIf aSCKeyWord="StoolFrequency" {
		Set return="大便异常"	            //大便异常
	} ElseIf aSCKeyWord="Bacteria" {
		Set return="同种同源菌"	            //检出微生物
	} ElseIf aSCKeyWord="PathogenicBacteria" {
		Set return="同种同源菌"	            //检出致病菌
	} ElseIf aSCKeyWord="Fungus" {
		Set return="同种同源菌"	            //检出真菌
	} ElseIf aSCKeyWord="ResistantBacteria" {
		Set return="同种同源菌"	            //检出耐药菌
	} ElseIf aSCKeyWord="MRB" {
		Set return="多重耐药菌"	            //检出多重耐药菌
	} Else {
		Set return="其他"
	}
	
	Quit return
}

}
