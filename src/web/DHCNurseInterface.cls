Class web.DHCNurseInterface Extends %RegisteredObject
{

// w ##class(web.DHCNurseInterface).HasCQord(6412802)

// w ##class(web.DHCNurseInterface).HasLSord(6428569)

// w ##class(web.DHCNurseInterface).HasTemperature(6253695)

// w ##class(web.DHCNurseInterface).HasNurseCare(Episode)

ClassMethod ifLongTimeOrderExist(EpisodeId)
{
	// 8.5.3 新版本
	q ##class(Nur.NIS.Service.OrderSheet.Sheet).ifExistSheetOrder(EpisodeId,"L")
	/*
	s locs=##class(Nur.DoctorOrderSheet).getPatLocs(EpisodeId)
	s locsList=##class(%ListOfDataTypes).%New()
	s locsList=##class(Nur.JSON).Decode(locs)
	s num=locsList.Count()
	q:num=0 0
	s flag=0
	f i=1:1:num
	{
		s loc=##class(%ArrayOfDataTypes).%New()
		s loc=locsList.GetAt(i)
		s StartDate=loc.GetAt("StartDate")
		s StartTime=loc.GetAt("StartTime")
		s EndDate=loc.GetAt("EndDate")
		s EndTime=loc.GetAt("EndTime")
		s LocId=loc.GetAt("LocId")
		s rs = ##class(%ResultSet).%New("Nur.DoctorOrderSheet:FindLongOrder")
  		s sc = rs.Execute(EpisodeId, LocId, StartDate, StartTime, EndDate, EndTime, "")
  		i (rs.Next()) {
	  		s flag=1
	    }
 		d rs.Close()
 		q:flag=1 
	}
	q flag
	*/
}

ClassMethod ifTempTimeOrderExist(EpisodeId)
{
	//8.5.3版本
	q ##class(Nur.NIS.Service.OrderSheet.Sheet).ifExistSheetOrder(EpisodeId,"T")
	/*
	s locs=##class(Nur.DoctorOrderSheet).getPatLocs(EpisodeId)
	s locsList=##class(%ListOfDataTypes).%New()
	s locsList=##class(Nur.JSON).Decode(locs)
	s num=locsList.Count()
	q:num=0 0
	s flag=0
	f i=1:1:num
	{
		s loc=##class(%ArrayOfDataTypes).%New()
		s loc=locsList.GetAt(i)
		s StartDate=loc.GetAt("StartDate")
		s StartTime=loc.GetAt("StartTime")
		s EndDate=loc.GetAt("EndDate")
		s EndTime=loc.GetAt("EndTime")
		s LocId=loc.GetAt("LocId")
		s rs = ##class(%ResultSet).%New("Nur.DoctorOrderSheet:FindTempOrder")
  		s sc = rs.Execute(EpisodeId, LocId, StartDate, StartTime, EndDate, EndTime)
  		i (rs.Next()) {
	  		s flag=1
	    }
 		d rs.Close()
 		q:flag=1 
	}
	q flag
	*/
}

ClassMethod HasCQord(Episode) As %String
{
		s locStr=##CLASS(web.DHCLONGTIMEORD).GetTranLoc(Episode)
		s flag=0
		s locNum=$l(locStr,"|")
		for loci=1:1:locNum
		{
			s locItem=$p(locStr,"|",loci)
			continue:$G(locItem)=""
			s loc=$p(locItem,"^",4)
  			s flag=..HasCQordInner(Episode,loc)
  			q:flag=1
  
	}
 
		q flag
}

/// 	是否有临时医嘱单
ClassMethod HasLSord(Episode) As %String
{
	s locStr=##class(web.DHCLONGTIMEORD).GetTranLoc(Episode)
	s flag = 0
	s locNum = $l(locStr,"|")
	for loci=1:1:locNum
	{
		s locItem = $p(locStr,"|",loci)
		continue:($g(locItem)="")
		s loc=$p(locItem,"^",4)
		s flag = ..HasLSordInner(Episode,loc)
		q:(flag=1)
	}
	q flag
}

/// 是否有体温单
ClassMethod HasTemperature(Episode) As %String
{
 
	s flag=0
	//s MotherAdm=$p($g(^PAADM(Episode)),"^",75)
	//i MotherAdm'="" q 0
	//b 
	s Mradm=$P(^PAADM(Episode),"^",61)
	if Mradm'=""  d
      .s date=$O(^MR(Mradm,"OBS",0,"Date",""))
      .s:$G(date)'="" flag=1
	q flag
}

// w ##class(web.DHCNurseInterface).HasNurseCare(1432073)

/// 是否有护理病历
ClassMethod HasNurseCare(Episode) As %String
{
	s flag=0
	;s ret= ##class(User.DHCNURMoudelLink).GetPerModel(Episode)
	;i ret'="" s flag=1
	s table=..HasNurseTableInner(Episode)
	s assess=..HasNurseAssessmentInner(Episode)
	if (table=0)&&(assess=0) s flag=0
	else  s flag=1
	
	q flag
}

/// 是否有护理记录表格
ClassMethod HasNurseTableInner(Episode) As %String
{
 
 //w ##class(web.DHCNurseInterface).HasNurseTable(6402787)
	s flag=0
	s rw=""  
	f  s rw=$O(^Nur.DHCNurseRecParentI("Episode"," "_Episode,rw)) q:(rw="")||(flag=1)  d
	  .s parr=rw 
	  .s subrw=""
	  .f  s subrw=$o(^Nur.DHCNurseRecSubD(parr,subrw)) q:(subrw="")||(flag=1)  d
	     ..s a=##class(Nur.DHCNurseRecSub).%OpenId(parr_"||"_subrw)
	     ..s cancel=a.RecCancelDate
	     ..s:$g(cancel)="" flag=1
   
	q flag
}

/// 是否有护理评估单
ClassMethod HasNurseAssessmentInner(Episode) As %String
{
 
 //w ##class(web.DHCNurseInterface).HasNurseAssessment(6402787)
	s flag=0
	s code=""  
	f  s code=$O(^Nur.DHCMoudDataI("EmrCode",code)) q:(code="")||(flag=1)  d
	  .s rw=""
	  .f  s rw=$o(^Nur.DHCMoudDataI("EmrCode",code," "_Episode,rw)) q:(rw="")||(flag=1)  d
	     ..s flag=1
   
	q flag
}

ClassMethod HasCQordInner(Episode, loc) As %String
{
	//n (Episode,loc)
	//w ##class(web.DHCNurseInterface).HasLSord(6455467)
	s flag=0
	//Set rset = ##class(%ResultSet).%New("web.DHCLONGTIMEORD:GetLongOrd")
  
   //Set columns = rset.GetColumnCount()
  
   ;s sc = rset.Execute(adm,"1")
   //d ##class(%ResultSet).RunQuery("web.DHCLONGTIMEORD","GetLongOrd",6412802,"","","",1,3880,1,0,1,"N","","N","")
   //d ##class(%ResultSet).RunQuery("web.DHCLONGTIMEORD","GetLongOrd",6455467,"","","",1,3880,1,0,1,"N","","N","")
  
  //s sc = rset.Execute(Episode,"","","",1,3880,loc,0,1)
  
  Set rset = ##class(%ResultSet).%New("Nur.DoctorOrderSheet:FindLongOrder")
  Set columns = rset.GetColumnCount()
  s sc = rset.Execute(Episode, loc, "", "", "", "", "")
  if (rset.Next()) {
	  s flag=1
	

	      }
 Do rset.Close()
 q flag
}

ClassMethod HasLSordInner(Episode, loc) As %String
{
	//n (Episode,loc)
	s flag=0
	;Set rset = ##class(%ResultSet).%New("web.DHCTEMPOERPRINT:GetTempOrd")
   ;Set rset = ##class(%ResultSet).%New("web.DHCThreeNew:ListItem")
   ;Set columns = rset.GetColumnCount()
   
   ;s sc = rset.Execute(adm,"1")
  //s sc = rset.Execute( Episode, "", "", "", 0 , 834, loc, 0, 0, "N","","N","")
  //Modify by Liaowp 2014-10-27
  	;s sc = rset.Execute( Episode,"","","","","",1,834,loc,0,1,"","","","")
   ;s sc = rset.Execute(adm,"1")
   //d ##class(%ResultSet).RunQuery("web.DHCLONGTIMEORD","GetLongOrd",6412802,"","","",1,3880,1,0,1,"N","","N","")
   //d ##class(%ResultSet).RunQuery("web.DHCLONGTIMEORD","GetLongOrd",6455467,"","","",1,3880,1,0,1,"N","","N","")
  
 // s sc = rset.Execute(Episode,"","","",1,3880,loc,0,1,"N","","N","")
  
  Set rset = ##class(%ResultSet).%New("Nur.DoctorOrderSheet:FindTempOrder")
  s sc = rset.Execute(Episode,loc,"","","","")
  
  if (rset.Next()) {
	  s flag=1
	

	      }
 Do rset.Close()
 q flag
}

/// Desc:	超期会诊条数
/// Debug:	w ##Class(web.DHCNurseInterface).GetExpiredConsult("6575938",24*3600)
ClassMethod GetExpiredConsult(EpisodeID, timeSpan, type) As %String
{
	s adm=EpisodeID
	 q:adm="" ""
            s ret=0
            s curDT=(+$h)*86400+ $p($h,",",2)
			s id="" f  s id=$O(^User.DHCConsultationI("Adm"," "_adm,id)) q:(id="")  d
			.s a=^User.DHCConsultationD(id)
			.s appdate=$listget(a,3)
			.s apptime=$listget(a,6)
			.s startDT= appdate*86400+ apptime
			.s status=$listget(a,16)
			.q:type'=$listget(a,9)
			.;b //e
			.i status="V"  d
			..i (curDT-startDT)>timeSpan s ret=ret+1 
	
  q ret
}

/// 普通会诊  w ##Class(web.DHCNurseInterface).GetExpiredConsultCommon("6505935")
ClassMethod GetExpiredConsultCommon(EpisodeID) As %String
{
	s adm=EpisodeID
	 q:adm="" ""
     q ..GetExpiredConsult(EpisodeID,24*3600,"C")
}

/// 急会诊  w ##Class(web.DHCNurseInterface).GetExpiredConsultEmergency("6505935")
ClassMethod GetExpiredConsultEmergency(EpisodeID) As %String
{
	s adm=EpisodeID
	 q:adm="" ""
     q ..GetExpiredConsult(EpisodeID,0.5*3600,"E")
}

/// Creator:      SongChao
/// CreateDate:   2017.7.13
/// Description:  判断病人是否在床
/// Input:        episodeID:就诊号
/// Return:       Y:是;N:否;error
/// Other:  ##Class(web.DHCNurseInterface).ifPatInBed()
ClassMethod ifPatInBed(episodeID)
{
	q:episodeID="" "就诊号为空"
	s ret="N",admCurrBed=""
	s admCurrBed=$p($g(^PAADM(episodeID)),"^",73)
	i admCurrBed'="" s ret="Y"
	q ret
}

/// Creator:      SongChao
/// CreateDate:   2017.8.8
/// Description:  病人住院天数
/// Input:        episodeID:就诊号
/// Return:       ret:天数
/// Other:  ##Class(web.DHCNurseInterface).patInDays(318)
ClassMethod patInDays(episodeID)
{
	q:episodeID="" "就诊号为空"
	s ret=0
	s InBedDate=$p($g(^PAADM(episodeID,"DHC")),"^",31)
	s:InBedDate="" InBedDate=$p($g(^PAADM(episodeID)),"^",6)
	s OutDate=+$h
	i ^DHCDishChargeSet("Disch","ifGetDischgDateTimeByDoc")="Y" d
	.s OutDate=$p($g(^PAADM(episodeID)),"^",59) //医疗结算日期
	.i (OutDate'="")&(OutDate=+$h) s ret=1
	.i (OutDate="")!(OutDate>+$h) s OutDate=+$h
	i OutDate>InBedDate s ret=OutDate-InBedDate
	i (OutDate=InBedDate)&(ret'=1) s ret=0
	q ret
}

/// Creator：   SongChao
/// CreatDate： 2017.10.19
/// Description：判断医嘱是否属于医嘱单 
/// Table： 
/// Input：     orderId:医嘱rowId
/// Output：    Y:是; N:否
/// Others：  ##Class(web.DHCNurseInterface).IfInOrderSheet("818||72")
ClassMethod IfInOrderSheet(orderId)
{
	s ret = "N"
	s oeordId = +orderId
	s oeordSub = $p(orderId,"||",2)
	s episodId=$p(^OEORD(oeordId),"^",1)
	s locId=$p(^OEORD(oeordId,"I",oeordSub,1),"^",3)     //下医嘱科室 
	s AdminDateTime = ##class(web.DHCDischargeHistory).GetAdminDateTime(episodId)
	s startDate=$zd(+AdminDateTime,3)
	s startTime=$zt($p(AdminDateTime,"^",2))
	s tempRets = ##Class(%ResultSet).%New("Nur.DoctorOrderSheet:FindTempOrder")
	d tempRets.Execute(episodId,locId,startDate,startTime,"","")
	while(tempRets.Next())
 	{
	 	s tempOrderId = $g(tempRets.Data("OrderId"))
	 	q:tempOrderId=orderId  s ret="Y"
 	}
 	i ret="N" {
		s longRets = ##Class(%ResultSet).%New("Nur.DoctorOrderSheet:FindLongOrder")
 		d longRets.Execute(episodId,locId,startDate,startTime,"","")
 		while(longRets.Next())
 		{
	 		s longOrderId = $g(longRets.Data("OrderId"))
	 		q:longOrderId=orderId  s ret="Y"
 		}
 	}
 	q ret
}

/// Creator:      ouzilin
/// CreateDate:   20221209
/// Description:  产程图判断是否需要归档
/// Input:        episodeID:就诊号
/// Return:       1 or 0
/// Other:  ##Class(web.DHCNurseInterface).HasLaborData(318)
ClassMethod HasLaborData(episodeID)
{
	q ##class(Nur.NIS.Service.Labor.Handler).ifNeedPrintLabor(episodeID)
}

/// Creator:      ouzilin
/// CreateDate:   20221209
/// Description:  产时记录判断是否需要归档
/// Input:        episodeID:就诊号
/// Return:       1 or 0
/// Other:  ##Class(web.DHCNurseInterface).HasLaborRec(318)
ClassMethod HasLaborRec(episodeID)
{
	q ##class(Nur.NIS.Service.Labor.Handler).ifHaveRecord(episodeID)
}

}
