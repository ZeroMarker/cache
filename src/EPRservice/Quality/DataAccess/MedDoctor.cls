Class EPRservice.Quality.DataAccess.MedDoctor Extends %RegisteredObject
{

/// 获取质控医师
/// d ##Class(%ResultSet).RunQuery("EPRservice.Quality.DataAccess.MedDoctor","GetMedDoctorInfo","","","","") 
Query GetMedDoctorInfo(UserId = "", Range = "", StartDate = "", EndDate = "", filter = "0", LocInfo = "") As %Query(ROWSPEC = "UserId,Range,UserName,StartDate,EndDate,LocDesc,CTPCPID,Grade")
{
}

ClassMethod GetMedDoctorInfoExecute(ByRef qHandle As %Binary, UserId = "", Range = "", StartDate = "", EndDate = "", filter = "0", LocInfo = "") As %Status
{
	s repid = $i(^CacheTemp)
	s ind = 1
	s qHandle = $lb(0,repid,0)
	//s CheckRange=""
	s:(UserId'="") UserId=" "_UserId
	
	if UserId'=""
	{
		s RowId=$o(^DHCEPRQ.MedDoctorI("IdxUserID",UserId,""))	
		q:(RowId="") $$$OK
		s objMedDoctor=##class(EPRinstance.Quality.MedDoctor).%OpenId(RowId)
		s Id=objMedDoctor.UserID
		s LocID=objMedDoctor.LocID
		s range=objMedDoctor.Range
		
		s userInfo = $g(^SSU("SSUSR",+Id))
				
		;s CTPCPID = $p(userInfo,"^",4)
		s Name=$p(userInfo,"^",2)
		s objCtLoc = $g(^CTLOC(+LocID))
		
		s LocDesc=$p(objCtLoc,"^",2)
		
		q:(Range'="")&&(range'[Range) $$$OK
		
		s admRange=$replace(range,"AO","门诊病历")
		s admRange=$replace(admRange,"IA","环节病历")
		s admRange=$replace(admRange,"CQC","终末病历")
		
		s Grade=objMedDoctor.Grade
		
		s STDate=##class(EMRservice.Tools.Tool).GetHISStandardDateTimeFormat("ChangeToFormat","Date",objMedDoctor.EffectiveStartDate)
		s EDDate=##class(EMRservice.Tools.Tool).GetHISStandardDateTimeFormat("ChangeToFormat","Date",objMedDoctor.EffectiveEndDate)
		q:($zdh(objMedDoctor.EffectiveStartDate,3)>$p($h,",",1))&&(filter=1)
		q:($zdh(objMedDoctor.EffectiveEndDate,3)<$p($h,",",1))&&(filter=1)
		s Data=$lb(Id,admRange,Name,STDate,EDDate,LocDesc,LocID,Grade)
		s ^CacheTemp(repid,ind) = Data
	}else
	{
		for
		{
			s UserId=$o(^DHCEPRQ.MedDoctorI("IdxUserID",UserId))
			
			q:(UserId="")
			s RowId=""
			for
			{
				s RowId=$o(^DHCEPRQ.MedDoctorI("IdxUserID",UserId,RowId))
				
				q:(RowId="")
				s objMedDoctor=##class(EPRinstance.Quality.MedDoctor).%OpenId(RowId)
				s Id=objMedDoctor.UserID
				
				s userInfo = $g(^SSU("SSUSR",+Id))
				s LocID=objMedDoctor.LocID
				;s CTPCPID = $p(userInfo,"^",4)
				
				s objCtLoc = $g(^CTLOC(+LocID))
				
				s LocDesc=$p(objCtLoc,"^",2)
				
				continue:(LocInfo'="")&&('##class(EPRservice.Quality.GetAdmList).CheckLoc(LocInfo,LocID))
				
				s Name=$p(userInfo,"^",2)
				s range=objMedDoctor.Range
				s Grade=objMedDoctor.Grade
				continue:(Range'="")&&(range'[Range)
				
				s admRange=$replace(range,"AO","门诊病历")
				s admRange=$replace(admRange,"IA","环节病历")
				s admRange=$replace(admRange,"CQC","终末病历")
				
				s STDate=##class(EMRservice.Tools.Tool).GetHISStandardDateTimeFormat("ChangeToFormat","Date",objMedDoctor.EffectiveStartDate)
				s EDDate=##class(EMRservice.Tools.Tool).GetHISStandardDateTimeFormat("ChangeToFormat","Date",objMedDoctor.EffectiveEndDate)
				
				continue:($zdh(objMedDoctor.EffectiveStartDate,3)>$p($h,",",1))&&(filter=1)
				
				continue:($zdh(objMedDoctor.EffectiveEndDate,3)<$p($h,",",1))&&(filter=1)
				
				s Data=$lb(Id,admRange,Name,STDate,EDDate,LocDesc,LocID,Grade)
				s ^CacheTemp(repid,ind) = Data
	    		s ind = ind+1 
			}
		}
	}
	
	
	Quit $$$OK
}

ClassMethod GetMedDoctorInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetMedDoctorInfoExecute ]
{
	s repid=$list(qHandle,2)
 	k ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetMedDoctorInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetMedDoctorInfoExecute ]
{
	s AtEnd=$list(qHandle,1)
 	s repid=$list(qHandle,2)
 	s ind=$list(qHandle,3)
 	s ind=$o(^CacheTemp(repid,ind))
 	if (ind="") 
 	{
 		s AtEnd=1
 		s Row=""
 		k ^CacheTemp(repid)
 	}
 	else 
 	{
 		s Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// 新增质控医师信息
ClassMethod AddMedDoctor(UserId, LocID, Range, Grade, STDate, EDDate) As %String
{
	s result="添加失败！"
	;s ^temp("wei")=UserId_":"_UserName_":"_Range_":"_STDate_":"_EDDate
	q:(UserId="")||(LocID="")||(Range="")||(Grade="")||(STDate="")||(EDDate="") result
	
	s objMedDoctor=##class(EPRinstance.Quality.MedDoctor).%New()
	s objMedDoctor.UserID=UserId
	s objMedDoctor.LocID=LocID
	s objMedDoctor.Range=Range
	s objMedDoctor.Grade=Grade
	s objMedDoctor.EffectiveStartDate=STDate
	s objMedDoctor.EffectiveEndDate=EDDate
	
	s sc=objMedDoctor.%Save()
	if ($$$ISERR(sc))
	{
		s Error = $system.OBJ.DisplayError(sc)
		s result = result_"^"_Error
	}
	else
	{
		s StRowId = objMedDoctor.%Id()
		s result = "提交成功"
	}
	
	q result
}

/// 修改质控医师数据
/// debug:w ##class(EPRservice.Quality.DataAccess.MedDoctor).UpDateMedDoctorInfo("10293","丁增飞","O","2021-02-01","2021-02-02")
ClassMethod UpDateMedDoctorInfo(OldUserId, STDate, EDDate, Grade, Range) As %String
{
	s result="修改失败",RowId=""
	q:(OldUserId="")||(STDate="")||(EDDate="")||(Range="") result
	
	s RowId=$o(^DHCEPRQ.MedDoctorI("IdxUserID"," "_OldUserId,RowId))
	q:(RowId="") result
	s objMedDoctor=##class(EPRinstance.Quality.MedDoctor).%OpenId(RowId)
	
	s objMedDoctor.EffectiveStartDate=STDate
	s objMedDoctor.EffectiveEndDate=EDDate
	s objMedDoctor.Grade=Grade
	s objMedDoctor.Range=Range
	s sc=objMedDoctor.%Save()
	if ($$$ISERR(sc))
	{
		s Error = $system.OBJ.DisplayError(sc)
		s result = result_"^"_Error
	}
	else
	{
		s StRowId = objMedDoctor.%Id()
		s result = "修改成功"
	}
	
	q result
}

/// 检查用户是否维护过，1已维护，0未维护
/// debug:w ##class(EPRservice.Quality.DataAccess.MedDoctor).CheckUser(10403)
ClassMethod CheckUser(userId) As %String
{
	s result=0
	q:(userId="") result
	
	s rowId=$o(^DHCEPRQ.MedDoctorI("IdxUserID"," "_userId,""))
	s:(rowId'="") result=1
	
	q result
}

/// 检查用户的病历质控范围
/// input UserId 
/// output Range
/// debug:w ##class(EPRservice.Quality.DataAccess.MedDoctor).GetUserRange(10403)
ClassMethod GetUserRange(userId) As %String
{
	s result=0
	q:(userId="") result
	
	s rowId=$o(^DHCEPRQ.MedDoctorI("IdxUserID"," "_userId,""))
	q:(rowId="") result="非质控医师!"
	
	s result=##class(EPRinstance.Quality.MedDoctor).%OpenId(rowId).Range
	
	q result
}

ClassMethod GetUserConfigLocID(UserID)
{
	s result=0
	q:(UserID="") result
	
	s rowId=$o(^DHCEPRQ.MedDoctorI("IdxUserID"," "_UserID,""))
	q:(rowId="") result="非质控医师!"
	
	s result=##class(EPRinstance.Quality.MedDoctor).%OpenId(rowId).LocID
	
	q result
}

/// Desc:删除用户
/// Input:UserId
/// Output:删除成功,删除失败
/// Creator:wzl 2023年3月21日
/// Debug:w ##class(EPRservice.Quality.DataAccess.MedDoctor).DeleteMedDoctorInfo(9)
ClassMethod DeleteMedDoctorInfo(UserId)
{
	s result="删除失败"
	
	q:(UserId="") result
	
	s rowId=$o(^DHCEPRQ.MedDoctorI("IdxUserID"," "_UserId,""))
	
	q:(rowId="") result
	
	s objMed=##class(EPRinstance.Quality.MedDoctor).%OpenId(rowId)
	
	q:(objMed="") result
	
	d objMed.%DeleteId(rowId)
	
	q "删除成功"
}

}
