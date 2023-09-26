Class EPRservice.Quality.MonthRepot Extends %CSP.Page [ ClassType = "", ProcedureBlock ]
{

ClassMethod OnPage() As %Status
{
	
	s action=$g(%request.Data("action",1), "")
	s data  =$g(%request.Data("data",1  ), "")
	if action="save"
	{
		w ..save(data)
	}
	if action="search"
	{
		s date=$p(data,"^",1)
		s locID=$p(data,"^",2)
		s UsrID=$p(data,"^",3)
		s ^tempyhy("month")=date_","_locID_","_UsrID
		w ..search(date,locID,UsrID)
	}
	if action="getDoctor"
	{
		s docJson=..doctorJson()
		while (docJson.AtEnd=0)
		{
			w $ZSTRIP(docJson.Read(32000),"*c",,$c(1)_$c(2))
		} 
	}
	if action="getLoc"
	{
		w ..locJson()
	}
	q $$$OK
}

/// w ##Class(EPRservice.Quality.MonthRepot).save("1^12^1^1^吧报告的更好的^21421^133133^2018-09^68^9")
ClassMethod save(strings)
{
	
	s AllcountValue=$p(strings,"^",1)
	s GradeAPercentValue=$p(strings,"^",4)
	s GradeCValue=$p(strings,"^",3)
	s OpinionValue=$p(strings,"^",7)
	s GradeBValue=$p(strings,"^",2)
	s MedicalRecordValue=$p(strings,"^",5)
	s DailyRecordValue=$p(strings,"^",6)
	s RecordDateValue=$p(strings,"^",8)
	s RecordLocValue=$p(strings,"^",9)
	s doctorValue=$p(strings,"^",10)
	s Date=+$h
	s Time=$p($h,",",2)
	k SQLCODE
	s ID=""
	s ID=$o(^DHCEPRQ.MonthRportI("IdxCTLocIDDateUserID"," "_RecordDateValue," "_RecordLocValue," "_doctorValue,""))
	if ID=""
	{
	&sql(INSERT INTO EPRinstance_Quality.MonthRport
	(RecoedDate,CTLocID,UserID,Allcount,GradeB,GradeC,GradeAPercent,MedicalRecord,DailyRecord,Opinion,SaveDate,SaveTime) 
	VALUES
	(:RecordDateValue,:RecordLocValue,:doctorValue,:AllcountValue,:GradeBValue,:GradeCValue,:GradeAPercentValue,:MedicalRecordValue,:DailyRecordValue,:OpinionValue,:Date,:Time))
	}
	else
	{
	&sql(update EPRinstance_Quality.MonthRport set 
	RecoedDate=:RecordDateValue,CTLocID=:RecordLocValue,UserID=:doctorValue,Allcount=:AllcountValue,GradeB=:GradeBValue,GradeC=:GradeCValue,
	GradeAPercent=:GradeAPercentValue,MedicalRecord=:MedicalRecordValue,DailyRecord=:DailyRecordValue,Opinion=:OpinionValue,UpdateDate=:Date,UpdateTime=:Time
	where ID=:ID)
	}
	q SQLCODE
}

/// w ##Class(EPRservice.Quality.MonthRepot).search("2018-09",67,"9")
ClassMethod search(Date, LocID, UserID)
{
	s ID=""
	s ID=$o(^DHCEPRQ.MonthRportI("IdxCTLocIDDateUserID"," "_Date," "_LocID," "_UserID,""))
	//q:(ID="") ""
	s (Allcount,GradeB,GradeC,GradeAPercent,MedicalRecord,DailyRecord,Opinion)=""
	if (ID="") {
		
		s month = $p(Date,"-",2)
		s date = 30
		s:(month=1)||(month=3)||(month=5)||(month=7)||(month=8)||(month=10)||(month=12) date=31
		s stardate = Date_"-01", enddate = Date_"-"_date
		s stardate = $p(##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(stardate)," ",1)
		s enddate = $p(##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(enddate)," ",1)
		s BlankEpisodeID = ""
		s Allcount = 0,GradeB=0,GradeC=0,GradeAPercent=0,GradeA=0
		
		for {
			s BlankEpisodeID = $o(^DHCEPRQ.QualityResultI("IdxRuleEpisodeID"," "_1,BlankEpisodeID))
			q:(BlankEpisodeID = "")
			s EpisodeID = $tr(BlankEpisodeID," ","")
			s ResultID = ""
			for {
				s ResultID = $o(^DHCEPRQ.QualityResultI("IdxRuleEpisodeID"," "_1,BlankEpisodeID,ResultID))
				q:(ResultID = "")
				s objResult = ##Class(EPRinstance.Quality.QualityResult).%OpenId(ResultID) 
				s Action = objResult.Action
				//continue:Action'="D"
				s ExamineDate = objResult.ExamineDate
				continue:(ExamineDate = "")
				s ExamineDate = $p(##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(ExamineDate)," ",1)
				continue:(stardate '= "")&&(ExamineDate < stardate)
				continue:(enddate '= "")&&(ExamineDate > enddate)
				s Allcount = Allcount+1
				s score = ##Class(EPRservice.Quality.BOManualCheck).GetScoreByEpisodeID(EpisodeID,"100","2","D")
				s:score<=79 GradeC = GradeC+1
				s:(80<score)&&(score<90) GradeB = GradeB+1
				s:score>=90 GradeA = GradeA+1
				s:Allcount'=0 GradeAPercent = $s(GradeA*100#Allcount=0:GradeA*100/Allcount,1:$j(GradeA*100/Allcount,2,2))
			}
		}
	}
	else {
		s obj=##class(EPRinstance.Quality.MonthRport).%OpenId(ID)
		s Allcount=obj.Allcount
		s DailyRecord=obj.DailyRecord
		s GradeAPercent=obj.GradeAPercent
		s GradeB=obj.GradeB
		s GradeC=obj.GradeC
		s MedicalRecord=obj.MedicalRecord
		s Opinion=obj.Opinion
	}
	q Allcount_"^"_DailyRecord_"^"_GradeAPercent_"^"_GradeB_"^"_GradeC_"^"_MedicalRecord_"^"_Opinion
}

/// 科室
/// w ##Class(EPRservice.Quality.MonthRepot).locJson()
ClassMethod locJson()
{
	//数量
	s count=0
	//加不加逗号标志
	s isFirstRecord = 1
	s LocID="",json=""
	for
	{
		s LocID=$o(^CTLOC(LocID))
		q:(LocID="")
		s LocType=$p(^CTLOC(LocID),"^",19)
		continue:(LocType'=3)
		s Loc=$p(^CTLOC(LocID),"^",2)
		s Loc=$p(Loc,"-",2)
		if (isFirstRecord = 0) { s json = json_"," }
		s json = json_"{LocID:'"_LocID_"',"
		s json = json_"Loc:'"_Loc_"'}"
		s count=count+1
		s isFirstRecord = 0
	}
	s ret=""
	s ret="{totalCount:"_count_",data:["_json_"]}"
	s ret=$tr(ret,$c(0),"")
	q ret
}

/// 医生
/// w ##Class(EPRservice.Quality.MonthRepot).doctorJson()
ClassMethod doctorJson()
{
	//数量
	s count=0
	//加不加逗号标志
	s isFirstRecord = 1
	s UserID=0
	s json=##Class(%GlobalCharacterStream).%New()
	d json.Write("{totalCount:1,data:[")
	for
	{
		s UserID=$o(^SSU("SSUSR",UserID))
		q:(UserID="")
		s UserCode=$p(^SSU("SSUSR",UserID),"^",1)
		s UserDesc=$p(^SSU("SSUSR",UserID),"^",2)
		s UserDesc=UserCode_"^"_UserDesc
		s DateTo=$p(^SSU("SSUSR",UserID),"^",97)
		s CurDate=+$h
		continue:((DateTo'="")&&(DateTo<CurDate))
		if (isFirstRecord = 0) 
		{
			d json.Write(",")
		}
		d json.Write("{UserID:'"_UserID_"',")
		d json.Write("UserDesc:'"_UserDesc_"'}")
		s count=count+1
		s isFirstRecord = 0
	}
	d json.Write("]}")
	q json
}

}
