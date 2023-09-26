Class EMRservice.Ajax.SetDataToPortal Extends %CSP.Page
{

ClassMethod OnPage() As %Status
{
	s episodeID = $Get(%request.Data("EpisodeID",1),"")
	s signUserID = $Get(%request.Data("signUserID",1),"")
	s InstanceId = $Get(%request.Data("InstanceId",1),"")
	s categoryId = $Get(%request.Data("categoryId",1),"")
	s templateId = $Get(%request.Data("templateId",1),"")
	s emrDocId = $Get(%request.Data("emrDocId",1),"")
	s chartItemType = $Get(%request.Data("chartItemType",1),"")  //Single  or  Multiple
	s TitleCode = $Get(%request.Data("TitleCode",1),"")
	s TitleDesc = $Get(%request.Data("TitleDesc",1),"")
	s curStatus = $Get(%request.Data("curStatus",1),"")
	s curStatusDesc = $Get(%request.Data("curStatusDesc",1),"")
	s signStatus = $Get(%request.Data("signStatus",1),"")
	s canAttendingCheck = $Get(%request.Data("canAttendingCheck",1),"")
	s canChiefCheck = $Get(%request.Data("canChiefCheck",1),"")
	
	d ..setDataToPortal(episodeID,InstanceId,signUserID,chartItemType,templateId,TitleCode)
	
	Quit $$$OK
}

/// d ##Class(EMRservice.Ajax.SetDataToPortal).setDataToPortal("53","15||1","359","Single","16","2")
/// d ##Class(EMRservice.Ajax.SetDataToPortal).setDataToPortal("53","15||1","600","Single","16","2")
ClassMethod setDataToPortal(AepisodeID As %String, AInstanceId As %String, AsignUserID As %String, AchartItemType As %String, AtemplateId As %String, ATitleCode As %String)
{
	if (AsignUserID = "") 
	{
		s ^TempEMRToPortalError("Error") = "电子病历给Portal系统推送消息时,signUserID为空"
		q
	}
	
	s signDoctorDR = $p($g(^SSU("SSUSR",AsignUserID)),"^",14)
	s MUCPRowID = ..getMUCPRowIDByDoctorDR(signDoctorDR)
	if (MUCPRowID = "-1") 
	{
		s ^TempEMRToPortalError("Error") = "医生所在的医疗小组的起止日期/医生在医疗小组的起止日期，不在有效范围内"
		q
	}
	s CTLocID = $p(MUCPRowID,"||",1)
	s MURowID = $p(MUCPRowID,"||",1)_"||"_$p(MUCPRowID,"||",2)
	
	//带组医生信息
	s MUCPLeaderInfo = ..getMUCPLeaderInfoByDoctorDR(signDoctorDR)
	s MUCPLeaderDr = $p(MUCPLeaderInfo,"^",2)
	s MUCPLeaderCode = $p(MUCPLeaderInfo,"^",4)
	//科主任信息   需要进一步测试
	s CTLocObj = ##Class(User.CTLoc).%OpenId(CTLocID)
	
	s DepartmentHeadDoctorDR = ""
	s DepartmentHeadDoctorCode = ""
	s DepartmentHeadUserID = CTLocObj.CTLOCDepartmentHeadUserDR
	if (DepartmentHeadUserID '= "")
	{
		s DepartmentHeadDoctorDR = $p($g(^SSU("SSUSR",DepartmentHeadUserID)),"^",14)
		s DepartmentHeadDoctorCode = $p($g(^SSU("SSUSR",DepartmentHeadUserID)),"^",1)
	}
	//获取该模板需要的签名级别
	s TempSignlevelInfo = ..getSignlevelInfo(AchartItemType,AtemplateId,ATitleCode)
	s TempSignlLevelCode = $p(TempSignlevelInfo,"^",1)
	s TempSignlLevelDesc = $p(TempSignlevelInfo,"^",2)
	
	//R：住院医师;  M：医疗小组组长;  C：科主任
	s signDoctor = ""
	//签名医生不是小组组长，也不是科主任
	if (signDoctorDR '= MUCPLeaderDr)&&(signDoctorDR '= DepartmentHeadDoctorDR)
	{
		s signDoctor = "R"
		if (TempSignlLevelCode = "RM")||(TempSignlLevelCode = "RMC")
		{
			//推送消息给"医疗小组组长"，状态：1——增加，即Portal系统中该"医疗小组组长"待签病历数+1
			d ##class(web.DHCENS.EnsHISService).DHCHisInterface("S00000025",AInstanceId,AepisodeID,MUCPLeaderCode,"1")
		}
		elseif (TempSignlLevelCode = "RC")
		{
			//推送消息给"科主任"，状态：1——增加，即Portal系统该"科主任"中待签病历数+1
			d ##class(web.DHCENS.EnsHISService).DHCHisInterface("S00000025",AInstanceId,AepisodeID,DepartmentHeadDoctorCode,"1")
		}
	}
	//签名医生是小组组长，也是科主任
	elseif (signDoctorDR = MUCPLeaderDr)&&(signDoctorDR = DepartmentHeadDoctorDR)
	{
		if (TempSignlLevelCode = "RM")||(TempSignlLevelCode = "RMC")||(TempSignlLevelCode = "RC")
		{
			//推送消息给"医疗小组组长"，状态：2——审核，即Portal系统中该"医疗小组组长"待签病历数-1
			d ##class(web.DHCENS.EnsHISService).DHCHisInterface("S00000025",AInstanceId,AepisodeID,MUCPLeaderCode,"2")
		}
	}
	//签名医生是小组组长，但不是科主任
	elseif (signDoctorDR = MUCPLeaderDr)&&(signDoctorDR '= DepartmentHeadDoctorDR)
	{
		s signDoctor = "M"
		if (TempSignlLevelCode = "RM")
		{
			//推送消息给"医疗小组组长"，状态：2——审核，即Portal系统中该"医疗小组组长"待签病历数-1
			d ##class(web.DHCENS.EnsHISService).DHCHisInterface("S00000025",AInstanceId,AepisodeID,MUCPLeaderCode,"2")
		}
		elseif (TempSignlLevelCode = "RMC")
		{
			//推送消息给"医疗小组组长"，状态：2——审核，即Portal系统中该"医疗小组组长"待签病历数-1
			d ##class(web.DHCENS.EnsHISService).DHCHisInterface("S00000025",AInstanceId,AepisodeID,MUCPLeaderCode,"2")
			
			//推送消息给"科主任"，状态：1——增加，即Portal系统该"科主任"中待签病历数+1
			d ##class(web.DHCENS.EnsHISService).DHCHisInterface("S00000025",AInstanceId,AepisodeID,DepartmentHeadDoctorCode,"1")
		}
		elseif (TempSignlLevelCode = "MC")
		{
			//推送消息给"科主任"，状态：1——增加，即Portal系统该"科主任"中待签病历数+1
			d ##class(web.DHCENS.EnsHISService).DHCHisInterface("S00000025",AInstanceId,AepisodeID,DepartmentHeadDoctorCode,"1")
		}
	}
	//签名医生不是小组组长，只是科主任
	elseif (signDoctorDR '= MUCPLeaderDr)&&(signDoctorDR = DepartmentHeadDoctorDR)
	{
		s signDoctor = "C"
		if (TempSignlLevelCode = "RMC")||(TempSignlLevelCode = "MC")||(TempSignlLevelCode = "RC")
		{
			//推送消息给"科主任"，状态：2——审核，即Portal系统该"科主任"中待签病历数-1
			d ##class(web.DHCENS.EnsHISService).DHCHisInterface("S00000025",AInstanceId,AepisodeID,DepartmentHeadDoctorCode,"2")
		}
	}
}

/// 描述：根据DoctorDR获取该医生所在的有效的医疗小组中的组长信息
/// 返回值：1、MUCPRowID
/// 			2、"-1":医疗小组的有效日期/医生在医疗小组的有效日期,已失效
/// w ##Class(EMRservice.Ajax.SetDataToPortal).getSignlevelInfo("Single","15","NULL")
ClassMethod getSignlevelInfo(AchartItemType As %String, AtemplateId As %String, ATitleCode As %String)
{
	s SignlevelTempInfoStr = ##class(EMRservice.BL.BLSysOption).GetOptionValueByName("SignlevelTempInfo")
	
	s SignlevelTempInfoStream = ##class(%FileCharacterStream).%New()
	d SignlevelTempInfoStream.Write(SignlevelTempInfoStr)
	
	s listSignlevelObj = ##Class(%ListOfObjects).%New()
	s SignlevelList = ##Class(EMRservice.Obj.SignlevelInfo).%New()
	
	S SignlevelReader = ##class(%XML.Reader).%New()
	S Signlevelsc=SignlevelReader.OpenStream(SignlevelTempInfoStream)
	If $$$ISERR(Signlevelsc) Do $system.OBJ.DisplayError(Signlevelsc) Quit  
	Do SignlevelReader.Correlate("Signlevel","EMRservice.Obj.SignlevelInfo")
	
	s TempStr = ""
	While SignlevelReader.Next(.SignlevelList,.Signlevelsc) {
		continue:(SignlevelList.SignTemp.ID '= AtemplateId)
		
		if (AchartItemType = "Multiple")
		{
			continue:(SignlevelList.SignTemp.TitleCode '= ATitleCode)
		}
		
	    s TempStr = SignlevelList.LevelCode_"^"_SignlevelList.LevelDesc
	}
	q TempStr
}

/// 描述：根据DoctorDR获取该医生所在的有效的医疗小组中的组长信息
/// 返回值：1、MUCPRowID
/// 			2、"-1":医疗小组的有效日期/医生在医疗小组的有效日期,已失效
/// d ##Class(EMRservice.Ajax.SetDataToPortal).getMUCPRowIDByDoctorDR("180")
ClassMethod getMUCPRowIDByDoctorDR(AsignDoctorDR As %String)
{
	s ret = "-1"
	q:(AsignDoctorDR = "") ret
	
	s signDoctorDR = AsignDoctorDR
	s CTLocID = ""
	for
	{
		s CTLocID = $O(^CTLOC(0,"CTPCP",signDoctorDR,CTLocID))
		q:(CTLocID = "")
		
		s CTMUChildsub = ""
		for
		{
			s CTMUChildsub = $O(^CTLOC(0,"CTPCP",signDoctorDR,CTLocID,"MU",CTMUChildsub))
			q:(CTMUChildsub = "")
			
			s MURowID = CTLocID_"||"_CTMUChildsub
			s MUObj = ##Class(User.DHCCTLocMedUnit).%OpenId(MURowID)
			s CTMUDateFrom = MUObj.CTMUDateFrom
			s CTMUDateTo = MUObj.CTMUDateTo
			//判断该医疗单元(小组)是否激活
			continue:(MUObj.CTMUActiveFlag = "N")
			//判断该医疗单元(小组)是否在有效期内
			s CTMUIsValid = ..IsValidByDate(CTMUDateFrom,CTMUDateTo)
			continue:('CTMUIsValid)
			
			s MUCPChildsub = ""
			for
			{
				s MUCPChildsub = $O(^CTLOC(0,"CTPCP",signDoctorDR,CTLocID,"MU",CTMUChildsub,"CP",MUCPChildsub))
				q:(MUCPChildsub = "")
				
				s MUCPRowID = CTLocID_"||"_CTMUChildsub_"||"_MUCPChildsub
				s MUCPObj = ##Class(User.DHCCTLocMedUnitCareProv).%OpenId(MUCPRowID)
				
				s MUCPDateFrom = MUCPObj.MUCPDateFrom
				s MUCPDateTo = MUCPObj.MUCPDateTo
				//判断该医生隶属于该小组是否在有效期内
				s MUCPIsValid = ..IsValidByDate(MUCPDateFrom,MUCPDateTo)
				continue:('MUCPIsValid)
				
				s ret = MUCPRowID
			}
		}
	}
	q ret
}

/// d ##Class(EMRservice.Ajax.SetDataToPortal).IsValidByDate()
ClassMethod IsValidByDate(DateFrom, DateTo)
{
	s ret = 0
	q:(DateFrom = "")
	
	//取当前系统时间
	s date = $p($h,",",1)
	s time = $p($h,",",2)
	
	if (DateTo = "")&&(DateFrom <= date)
	{
		s ret = 1
	}
	elseif (DateFrom <= date)&&(date <= DateTo)
	{
		s ret = 1
	}
	
	q ret
}

/// 描述：根据DoctorDR获取该医生所在的有效的医疗小组中的组长信息
/// 入参：DoctorDR
/// 返回值：1、输入医生是组长："Y^MUCPLeaderDoctorID^MUCPLeaderDoctorCode^MUCPLeaderDoctorName"
/// 			2、输入医生不是组长："N^MUCPLeaderDoctorID^MUCPLeaderDoctorCode^MUCPLeaderDoctorName"
///         3、"-1":医疗小组的有效日期/医生在医疗小组的有效日期,已失效
/// w ##Class(EMRservice.Ajax.SetDataToPortal).getMUCPLeaderInfoByDoctorDR("180")
ClassMethod getMUCPLeaderInfoByDoctorDR(AsignDoctorDR As %String)
{
	s ret = "-1"
	q:(AsignDoctorDR = "") ret
	
	s signDoctorDR = AsignDoctorDR
	s MUCPRowID = ..getMUCPRowIDByDoctorDR(signDoctorDR)
	q:(MUCPRowID = "-1") ret
	
	s MUCPObj = ##Class(User.DHCCTLocMedUnitCareProv).%OpenId(MUCPRowID)
	s MUCPLeaderFlag = MUCPObj.MUCPLeaderFlag
	
	if (MUCPLeaderFlag = "Y")
	{
		s MUCPLeaderDoctorDr = MUCPObj.MUCPDoctorDR.CTPCPRowId
		s MUCPLeaderDoctorCode = MUCPObj.MUCPDoctorDR.CTPCPCode
		s MUCPLeaderDoctorName = MUCPObj.MUCPDoctorDR.CTPCPDesc
		s ret = "Y"_"^"_MUCPLeaderDoctorDr_"^"_MUCPLeaderDoctorName_"^"_MUCPLeaderDoctorCode
	}
	else
	{
		d MUCPObj.%Close()
		s CTLocID = $p(MUCPRowID,"||",1)
		s CTMUChildsub = $p(MUCPRowID,"||",2)
		s MUCPChildsub = "0"
		for
		{
			s MUCPChildsub = $O(^CTLOC(CTLocID,"MU",CTMUChildsub,"CP",MUCPChildsub))
			q:(MUCPChildsub = "")
			
			s curMUCPRowID = CTLocID_"||"_CTMUChildsub_"||"_MUCPChildsub
			s curMUCPObj = ##Class(User.DHCCTLocMedUnitCareProv).%OpenId(curMUCPRowID)
			
			continue:(curMUCPObj.MUCPLeaderFlag '= "Y")
			
			s MUCPLeaderDoctorDr = curMUCPObj.MUCPDoctorDR.CTPCPRowId
			s MUCPLeaderDoctorCode = curMUCPObj.MUCPDoctorDR.CTPCPCode
			s MUCPLeaderDoctorName = curMUCPObj.MUCPDoctorDR.CTPCPDesc
			
			s ret = "N"_"^"_MUCPLeaderDoctorDr_"^"_MUCPLeaderDoctorName_"^"_MUCPLeaderDoctorCode
		}
	}
	q ret
}

}
