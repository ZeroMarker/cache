/// 描述：获取需要再次编目病案首页的患者信息列表
/// 创建者：牛才才
Class EPRservice.DAL.DGetPatInfoForCataloging Extends %RegisteredObject
{

/// 查询特定时间段内，做过“提交”、“主治医师审核”、“主任医师审核”的病案首页病历，并且修改日期大于编目日期，并且在此时间段内有授权，且授权时间大于编目日期；
/// d ##class(%ResultSet).RunQuery("EPRservice.DAL.DGetPatInfoForCataloging","GetPatInfoList","2016-01-30","2016-01-30")
Query GetPatInfoList(AStartDate As %String, AEndDate As %String) As %Query(ROWSPEC = "PAPMIName:%String,MedicareNo:%String,disDeptDesc:%String,PAAdmDischgeDate:%String,PAAdmDischgeTime:%String,AmendData:%String,ModifyDate:%String,ModifyTime:%String,VolId:%String,Text:%String") [ SqlProc ]
{
}

ClassMethod GetPatInfoListExecute(ByRef qHandle As %Binary, AStartDate As %String, AEndDate As %String) As %Status
{
	set repid=$I(^CacheTemp)
	set ind = 1
	set qHandle = $lb(0,repid,0)
	//手动维护病案首页的模板ID串
	s HomepageTemplateIDStr = "22"
	s printTemplateDocID = "534"
	s HomepageCateCharpterID = "118"
	
	s StartDate = $zdh(AStartDate,3)
	s EndDate = $zdh(AEndDate,3)
	
	//s Systemdatetime = $HOROLOG
	//s Systemdateint = $p(Systemdatetime,",",1)
	//s Systemtimeint = $p(Systemdatetime,",",2)
	//s EndDate = Systemdateint
	
	for date=StartDate:1:EndDate
	{
		s ECRecordID = ""
		for
		{
			s ECRecordID = $O(^DHCEPRI.InstanceDataI("IdxModifyDate",date,ECRecordID))
			q:(ECRecordID = "")
			
			s SubID = ""
			for
			{
				s SubID = $O(^DHCEPRI.InstanceDataI("IdxModifyDate",date,ECRecordID,SubID))
				q:(SubID = "")
				
				s InstanceDataID = ECRecordID_"||"_SubID
				s InstanceObj = ##Class(EPRinstance.InstanceData).%OpenId(InstanceDataID)
				//过滤掉非 病案首页 的数据
				s Flag = 0
				for j=1:1:$L(HomepageTemplateIDStr,"^")
				{
					if (InstanceObj.TemplateID = $p(HomepageTemplateIDStr,"^",j))
					{
						s Flag = 1
					}
				}
				continue:(Flag = 0)
				
				//取病历的当前状态
				s ECRecordObj = ##Class(EPRinstance.ECRecord).%OpenId(ECRecordID)
				s EpisodeID = ECRecordObj.EpisodeID
				s EPRLogsID = $O(^DHCEPRI.EPRLogsI("IdxMain"," "_EpisodeID," "_printTemplateDocID,"1",""))
				continue:(EPRLogsID = "")
				s EPRLogsObj = ##Class(EPRinstance.EPRLogs).%OpenId(EPRLogsID)
				//过滤出已经提交的 病案首页 数据
				continue:(EPRLogsObj.EPRStatus = "unfinished")||(EPRLogsObj.EPRStatus = "finished")||(EPRLogsObj.EPRStatus = "archieved")
				
				s ModifyDate = InstanceObj.ModifyDate
				s ModifyTime = InstanceObj.ModifyTime
				
				//过滤掉没有编目过的
				s CodingDateTime = ##class(web.DHCWMRService).GetCodingTime(EpisodeID)
				continue:(CodingDateTime = "")  
				
				//编目过的病案首页，判断是修改前编目的还是修改后编目的
				s CodingDate = $LIST(CodingDateTime,1)
				s CodingTime = $LIST(CodingDateTime,2)
				continue:(ModifyDate < CodingDate)  //过滤掉修改后编目的
				if (ModifyDate = CodingDate)
				{
					continue:(ModifyTime < CodingTime) //过滤掉修改后编目的
				}
				
				
				//查看该EpisodeID是否在编目后进行了授权操作
				s AmendData = ""
				s AppointFlag = "0"
				s AppointID = ""
				for
				{
					s AppointID = $O(^DHCEPRI.EPRActionAppointI("IdxEpisode"," "_EpisodeID,AppointID))
					q:(AppointID = "")
					
					s AppointObj = ##class(EPRinstance.EPRActionAppoint).%OpenId(AppointID)
					continue:(AppointObj.AppointStatus '= "F")
					continue:(AppointObj.EPRAction '= "save")
					
					s AppointDate = AppointObj.AppointDate
					continue:(AppointDate < CodingDate)  //过滤掉授权后编目的
				
					if (AppointDate = CodingDate)
					{
						continue:(AppointObj.AppointTime < CodingTime) //过滤掉授权后编目的
					}
					
					s AppointCateCharpterStr = AppointObj.AppointCateCharpter
					s count = $L(AppointCateCharpterStr,"^")
					for i=1:1:count
					{
						s AppointCateCharpter = $p(AppointCateCharpterStr,"^",i)
						continue:(AppointCateCharpter '= HomepageCateCharpterID)
						if (AmendData '= "")
						{
							s AmendData = AmendData_"||"
						}
						s AmendData = AmendData_""""_AppointObj.BeforeRequestContent_""""_"->"_""""_AppointObj.AfterRequestContent_""""
						s AppointFlag = "1"
					}
				}
				continue:(AppointFlag = "0")
				d outputrow
			}
		}
	}
	/*
	for i=1:1:6
	{
		s EpisodeID = i
		if (i=1)
		{
			s aaa = "unfinished"
		}
		elseif(i=2)
		{
			s aaa = "finished"
		}
		elseif(i=3)
		{
			s aaa = "commited"
		}
		elseif(i=4)
		{
			s aaa = "attendingChecked"
		}
		elseif(i=5)
		{
			s aaa = "chiefChecked"
		}
		elseif(i=6)
		{
			s aaa = "archieved"
		}
		continue:(aaa = "unfinished")||(aaa = "finished")||(aaa = "archieved")
		d outputrow
	}
	*/
	Quit $$$OK
outputrow
	s PAADMRowID = EpisodeID
	s PatientID=$P(^PAADM(PAADMRowID),"^",1)
	s mradm=$P(^PAADM(PAADMRowID),"^",61)
	
	s PAPMINO=$P(^PAPER(PatientID,"PAT",1),"^",1)
	s PAPMIName=$P(^PAPER(PatientID,"ALL"),"^",1)
	//患者病案号
	s MedicareNo = $P($g(^PAPER(PatientID,"PAT",1)),"^",22)
	if (MedicareNo = "")
	{
		s MedicareNo = ##Class(web.DHCWMRService).IGetMrNoByPatientID(PatientID)
	}
	
	//出院科室
	s disDeptDesc = ""
	s disDeptDR=$P($g(^PAADM(PAADMRowID)),"^",4)
	if (disDeptDR '= "")
	{
		s disDeptCode = $p($g(^CTLOC(disDeptDR)),"^",1)
		s disDeptDesc = $p($g(^CTLOC(disDeptDR)),"^",2)
		if $l(disDeptDesc,"-")>1 
		{
			s disDeptDesc = $p($g(disDeptDesc),"-",2)
		}
	}
	
	//出院日期
	s PAAdmDischgeDateSys=$P($g(^PAADM(PAADMRowID)),"^",17)
	if (PAAdmDischgeDateSys '= "")
	{
		s PAAdmDischgeDate = $zd(PAAdmDischgeDateSys,3)
	}
	//出院时间
	s PAAdmDischgeTimeSys=$P($g(^PAADM(PAADMRowID)),"^",18)
	if (PAAdmDischgeTimeSys '= "")
	{
		s PAAdmDischgeTime = $zt(PAAdmDischgeTimeSys,3)
	}
	
	s ModifyDate = $zd(ModifyDate,3)
	s ModifyTime = $zt(ModifyTime,3)
	s VolId = ##class(web.DHCWMRService).GetVolueIDByPaadm(PAADMRowID)
	
	//以下为测试数据
	//s ModifyDate = $zd("62106",3)
	//s ModifyTime = $zt("62106",3)
	//s AmendData = """"_"testsdfeqwefasdfasfdqweqwefwaf"_""""_"->"_""""_"teswefqwfasfdqweqfqwfet1"_""""
	//s VolId = "20"
	
	s Text = "再次编目"
	
	set ^CacheTemp(repid,ind) = $LB(PAPMIName,MedicareNo,disDeptDesc,PAAdmDischgeDate,PAAdmDischgeTime,AmendData,ModifyDate,ModifyTime,VolId,Text)
	set ind = ind + 1
	Quit
}

ClassMethod GetPatInfoListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPatInfoListExecute ]
{
	Set repid = $LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetPatInfoListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPatInfoListExecute ]
{
	Set AtEnd = $LIST(qHandle,1)
 	Set repid = $LIST(qHandle,2)
 	Set ind = $LIST(qHandle,3)
 	Set ind = $o(^CacheTemp(repid,ind))
 	If ind = "" {				// if there are no more rows, finish fetching
 		Set AtEnd = 1
 		Set Row = ""
 	}
 	Else      {				// fetch row
 		Set Row = ^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle = $lb(AtEnd,repid,ind)
	Quit $$$OK
}

}
