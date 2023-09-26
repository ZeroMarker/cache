/// 名称: 与前台交付,设置病历科室相关操作的类
/// 描述: 
/// 编写者：chenwenjun
/// 编写日期: 09/08/11
Class web.eprajax.appointdeptmanager Extends %CSP.Page [ ProcedureBlock ]
{

ClassMethod OnPage() As %Status
{
	s episodeID  = $Get(%request.Data("EpisodeID",1),"-1")
	s appType = $Get(%request.Data("AppType",1),"null")		//操作类型 List--获取该病人本次就诊所住过的科室  Appoint--主管医生指定该病人的病历所在科室
	q:(appType = "null") $$$OK
	q:(episodeID = -1) $$$OK

	if (appType = "List")
	{
		//List--获取该病人本次就诊所住过的科室
		d ..GetPatientDeptList(episodeID)
	}
	elseif (appType = "Status")
	{
		//Status--获取当前的转移
		d ..GetStatusList(episodeID)
	}
	elseif (appType = "Withdraw")
	{
		//Withdraw--收回病历
		d ..Withdraw(episodeID)	
	}
	elseif (appType = "Appoint")
	{
		//Appoint--主管医生指定该病人的病历所在科室
		s result = ..AppointDept(episodeID)
		if (result = "Y")
		{
			w "{success:true}"
		}
		else
		{
			w "{success:false}"	
		}
	}
	
	Quit $$$OK
}

/// 名称: 返回病人转科科室的json
/// 描述: 
/// 编写者：chenwenjun
/// 编写日期: 09/08/11
ClassMethod GetPatientDeptList(episodeID As %String) As %String
{
	s transDept = ##class(EPRservice.HISInterface.PatientInfoAssist).TransDeptIDDetail(episodeID, "null")
	
	s transDeptCount = $l(transDept, "->")
	
	w "{root:["
	s i = 1
	s isFirstDept = "Y"
	WHILE (i <= transDeptCount) 
	{
		s curDept = $p(transDept, "->", i)
		
		if ((curDept '= "") && (curDept '= "无"))
		{
			if (isFirstDept = "N"){w ","}
			w "{deptID:'"_$p(curDept,"^",1)_"', deptName: '"_$p(curDept,"^",2)_"', TransStartDate: '"_$p(curDept,"^",3)_"', TransStartTime: '"_$p(curDept,"^",4)_"'}"
			s isFirstDept = "N"
		}
		
		s i = i + 1
	}
	
	w "]}"
	Quit "Y"
}

/// 名称: 保存指定的病历科室的信息
/// 描述: 
/// 编写者：chenwenjun
/// 编写日期: 09/08/11
ClassMethod AppointDept(episodeID As %String) As %String
{
	s eprDept  = $Get(%request.Data("EPRDept",1),"-1")
	s hours = $Get(%request.Data("Times",1),"-1")	
	
	q:(eprDept = "-1") "N"
	q:(hours = "-1") "N"
	
	s startDate = $p($h, ",", 1)
	s startTime = $p($h, ",", 2)
	
	//计算截止日期与时间
	s activityDates = ((+hours)) \ 24	//有效期的天数
	s activityHours = (+hours) - (activityDates * 24)
	
	s endDate = (+startDate) + activityDates
	s endTime = (+startTime) + (activityHours * 60 * 60)
	if (endTime > 86399)
	{
		s endDate = endDate + 1
		s endTime = endTime - 86399
	}
	//
	
	//修改病历科室表
	s userID = %session.Get("LOGON.USERID")
	s curObjAppointDept = ""
	s curAppointDeptRowID = $o(^DHCEPRI.EPRDeptI("EpisodeIDIdx", " "_episodeID, 0))
	if (curAppointDeptRowID = "")
	{
		s curObjAppointDept = ##class(EPRinstance.EPRDept).%New()
	}
	else
	{
		s curObjAppointDept = ##class(EPRinstance.EPRDept).%OpenId(curAppointDeptRowID)
	}
	q:(curObjAppointDept = "") $$$OK
	
	s curObjAppointDept.EpisodeID = episodeID
	s curObjAppointDept.EPRDept = eprDept
	s curObjAppointDept.StartDate = startDate
	s curObjAppointDept.StartTime = startTime
	s curObjAppointDept.EndDate = endDate
	s curObjAppointDept.EndTime = endTime
	s curObjAppointDept.IsActivity = "Y"
	s curObjAppointDept.AppointUserID = userID
	d curObjAppointDept.%Save()
	d curObjAppointDept.%Close()
	s curObjAppointDept = ""
	//

	
	//返回
	q "Y"
}

/// 名称: 返回当前转出的转科科室的json
/// 编写者：杨丰华
/// 编写日期: 2012/05/10
ClassMethod GetStatusList(episodeID As %String) As %String
{
	s json = ""

	s rowID = ""
	for {
		s rowID=$o(^DHCEPRI.EPRDeptI("EpisodeIDIdx", " "_episodeID, rowID))
		q:rowID=""
		
		s obj = ##Class(EPRinstance.EPRDept).%OpenId(rowID)

		//科室名称
		s eprDeptID = obj.EPRDept
		if (eprDeptID '= "")
		{
			s eprDeptDesc = $p($g(^CTLOC(eprDeptID)),"^",2)
		}
		else
		{
			s eprDeptDesc = ""
		}
		s episodeID = obj.EpisodeID
			
		//转出到期时间
		s endDate = obj.EndDate
		s endTime = obj.EndTime
			
		//是否有效
		s isActivity = obj.IsActivity
		
		d obj.%Close()	
		//判断是否已到期，到期后IsActivity改为“N”
		d ..SetActivity(endDate,endTime,episodeID)
			
		//当前有效
		if (isActivity = "Y")
		{
			//业务要求同一时间只能有一份病历是有效的，即同一时间只能转出一份病历
			//if (json '= "")
			//{ 
			//	s json = json_","
			//}
			s json = json_"{eprDept:'"_eprDeptDesc_"', endDate: '"_$ZD(endDate,3)_"', endTime: '"_$ZT(endTime)_"'}"
		}
	}
	
	//返回json
	w "{data:["_json_"]}"
	
	q "Y"
}

/// 名称: 收回转出的病历
/// 编写者：杨丰华
/// 编写日期: 2012/05/10
ClassMethod Withdraw(episodeID As %String) As %String
{
	s curObjAppointDept = ""
	s curAppointDeptRowID = $o(^DHCEPRI.EPRDeptI("EpisodeIDIdx", " "_episodeID, 0))
	if (curAppointDeptRowID = "")
	{
		s curObjAppointDept = ##class(EPRinstance.EPRDept).%New()
	}
	else
	{
		s curObjAppointDept = ##class(EPRinstance.EPRDept).%OpenId(curAppointDeptRowID)
	}
	q:(curObjAppointDept = "") $$$OK
	
	//置为无效
	s curObjAppointDept.IsActivity = "N"
	
	//到期时间写为收回时的时间
	s curObjAppointDept.EndDate = $p($h,",",1)
	s curObjAppointDept.EndTime = $p($h,",",2)
	
	d curObjAppointDept.%Save()
	d curObjAppointDept.%Close()
	s curObjAppointDept = ""

	q "Y"
}

/// 名称: 判断是否有效，若当前时间大于到期时间，则置为无效
/// 编写者：杨丰华
/// 编写日期: 2012/05/10
ClassMethod SetActivity(EndDate As %Date, EndTime As %Date, episodeID As %String)
{
	if (EndDate < $p($h,",",1))
	{
		q 
	}
	elseif ((EndDate = $p($h,",",1)) && (EndTime > $p($h,",",2)))
	{
		q 	
	}	
	else
	{
		s curObjAppointDept = ""
		s curAppointDeptRowID = $o(^DHCEPRI.EPRDeptI("EpisodeIDIdx", " "_episodeID, 0))
		if (curAppointDeptRowID = "")
		{
			s curObjAppointDept = ##class(EPRinstance.EPRDept).%New()
		}
		else
		{
			s curObjAppointDept = ##class(EPRinstance.EPRDept).%OpenId(curAppointDeptRowID)
		}
		q:(curObjAppointDept = "") $$$OK
		
		s curObjAppointDept.IsActivity = "N"
		d curObjAppointDept.%Save()
		d curObjAppointDept.%Close()
		s curObjAppointDept = ""

		q 
	}
}

}
