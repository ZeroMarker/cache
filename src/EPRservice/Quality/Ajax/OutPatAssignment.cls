/// 门诊病历分配
Class EPRservice.Quality.Ajax.OutPatAssignment Extends %CSP.Page
{

ClassMethod OnPage() As %Status
{
	// 分配人ID
	s userID = $Get(%request.Data("UserID",1),"")
	s EpisodeIDS=$Get(%request.Data("EpisodeIDS",1),"")
	s StartDate = $Get(%request.Data("startDate",1),"")
	s EndDate = $Get(%request.Data("endDate",1),"")
	s DateGap= $Get(%request.Data("dateGap",1),"")
	s action= $Get(%request.Data("action",1),"")
	//分配
	if action="Assign"
	{
		w ..OutPatAssign(userID,DateGap)
		Quit $$$OK
	}
	
	if action="updateMedDoc"
	{
		w ##Class(EPRservice.Quality.DataAccess.BOQualityCheckPatInfo).UpdateMedDoc(userID,EpisodeIDS)
		Quit $$$OK
	}
}

/// Desc: 门诊病历分配
/// 2020-09-28
/// input userID登录的医生Id DateGap 分配日期段
/// Debug:	w ##Class(EPRservice.Quality.Ajax.OutPatAssignment).OutPatAssign("2","2019-02-01---2019-02-02")
ClassMethod OutPatAssign(userID As %String, DateGap As %String) As %String
{
	
	s result = ""
	
	
	// 向抽查表中。开始添加数据
	s addInfo = ##Class(EPRservice.Quality.DataAccess.BOQualityCheckPatInfo).addOutPatInfo(userID,DateGap)  //平均分配门诊病历给医生	
	
	s result=addInfo
	
	if (result="添加成功")
	{
		for i=1:1:$l(DateGap,"/")
		{
			s date=$p(DateGap,"/",i)
			s sd=$p(date,"至",1)
			s ed=$p(date,"至",2)
			s insertDate=##class(EPRservice.Quality.DataAccess.BOQualityCheckDateInfo).InsertSpotCheckDateInfo(sd,ed)	
		}
	}
	
	q result
}

}
