/// ************************************************************
/// * ClassName:	EPRservice.Quality.DataGather.AdmInfo
/// * Description:	患者就诊相关信息类
/// * Author:		Zuoxiang Xie
/// * Create Date:	2010-05-10
/// ************************************************************/
Class EPRservice.Quality.DataGather.AdmInfo Extends %Library.RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// Desc:	获取患者在院时间(单位:小时);
/// Input:	ARegTimeVal为患者入院日期时间;
/// 		ADischTimeVal为患者出院日期时间,如果在院,则取当前日期时间;
/// 		AIsGetCurTime是否采用当前日期时间;否则返回-1作为未出院标识;
/// Debug:	w ##Class(EPRservice.Quality.DataGather.AdmInfo).GetRegHour("2010-07-05 8:36:34","")
ClassMethod GetRegHour(ARegTimeVal As %String, ADischTimeVal As %String, AIsGetCurTime As %String = "Y") As %String
{
	s ret = -1
	q:($d(ARegTimeVal) = 0)||(ARegTimeVal = "") ret
	
	s RegDateTime = $g(ARegTimeVal)
	s RegDate = $p(RegDateTime," ",1), RegTime = $p(RegDateTime," ",2)
	q:(RegDate = "")||(RegTime = "") ret
	s RegDate = $zdh(RegDate,3), RegTime = $zth(RegTime,2)
	
	s DischDateTime = $g(ADischTimeVal)
	s DisDate = $p(DischDateTime," ",1), DisTime = $p(DischDateTime," ",2)
	if (DisDate = "")||(DisTime = "")
	{
		if ($g(AIsGetCurTime) = "Y")
		{
			s CurrDate = +$h, CurrTime = $p($h,",",2)
		}
		else
		{
			q ret
		}
	}
	else
	{
		s CurrDate = $zdh(DisDate,3), CurrTime = $zth(DisTime,2)
	}

	s cDay = 0, cHour = 0
	s cDay = CurrDate - RegDate
	s cHour = $j((CurrTime - RegTime)/3600,2,1)
	s ret = cDay*24 + cHour
	q ret
}

/// Desc:获取患者手术单申请结束时间
/// Input:	AEpisodeID:患者就诊号
/// Output:	手术单申请结束时间(多个时间以"\"隔开)
/// Debug: w ##class(EPRQuality.Quality.DataGather.AdmInfo).GetOperDateTime(EpisodeID)
ClassMethod GetOperDateTime(AEpisodeID As %String) As %String
{
	s ret = ""
	q:($d(AEpisodeID) = 0)||(AEpisodeID = "") ret
	
	s OPArrangesDateTimes=##Class(EPRservice.Quality.DataGather.AdmInfo).GetOPArranges(AEpisodeID)
	q:(OPArrangesDateTimes="") ret
	
	s OPArrangesEndstr=""
	for I=1:1:$l(OPArrangesDateTimes,"\")
	{
		s OPArrangesDateTime=$p(OPArrangesDateTimes,"\",I)
		s OPArrangesEnd=$p(OPArrangesDateTime," ",3)_" "_$p(OPArrangesDateTime," ",4)
		s:(OPArrangesEndstr'="") OPArrangesEndstr=OPArrangesEndstr_"\"_OPArrangesEnd
		s:(OPArrangesEndstr="") OPArrangesEndstr=OPArrangesEnd
	}
	s ret=OPArrangesEndstr
	q ret
}

/// Desc:根据就诊号判断患者是否有使用抗生素
/// Input:	Adm:患者就诊号
/// Output:	1 有  0 否
/// Debug: w ##class(EPRService.Quality.DataGather.AdmInfo).GetAdmKSSSY(Adm)
ClassMethod GetAdmKSSSY(Adm As %String) As %String
{
	s ret=0 ,arcItmMast=""
	s OrdRowId=""
	f  s OrdRowId=$o(^OEORD(0,"Adm",Adm,OrdRowId)) q:(OrdRowId="")||(ret=1)  d
	.s OrdSubId=0
	.f  s OrdSubId=$o(^OEORD(OrdRowId,"I",OrdSubId)) q:(OrdSubId="")||(ret=1)  d
	..s statu=$p($g(^OEORD(OrdRowId,"I",OrdSubId,1)),"^",13)
	..q:(statu="2")||(statu="12")
	..s arcItmMast=$p($g(^OEORD(OrdRowId,"I",OrdSubId,1)),"^",2) //医嘱项ID 
	..q:arcItmMast=""
	..s Subscript=$p(arcItmMast,"||",1)
	..s Version=$p(arcItmMast,"||",2)
	..s RCIMDesc=$p($g(^ARCIM(Subscript,Version,1)),"^",12)  //ARCIM_PHCDF_DR
	..q:RCIMDesc=""
    ..s PHCDRowId=$p(RCIMDesc,"||",1)
	..s PHCDPHCPODR=$p(^PHCD(PHCDRowId,1),"^",4) //管制分类
	..q:PHCDPHCPODR=""
	..s PHCPOCode=$p(^PHCPO(PHCDPHCPODR),"^",1) //取管制分类描述
	..i PHCPOCode["KSS" s ret=1
    Q ret
}

/// Desc:获取患者手术信息
/// Input:	admId:患者就诊号;stdate开始日期;endate:结束日期
/// Output:	手术信息
/// Debug: w ##class(EPRservice.Quality.DataGather.AdmInfo).GetOperInfoForBLZK(EpisodeID,"","")
ClassMethod GetOperInfoForBLZK(admId As %String, stdate As %String, endate As %String) As %String
{
	if stdate="" set stdate=""
 	else  set stdate=##class(web.DHCClinicCom).ConvertToDateH(stdate)	
 	if endate="" set endate=""
 	else  set endate=##class(web.DHCClinicCom).ConvertToDateH(endate)
 	set resultString="",opstdatetime="",opendatetime="",opdesc=""	
 	set ret=##class(web.DHCANAdaptor).GetANOperation(stdate,endate,admId,"","F","","")
 	Set reader = ##class(%XML.Reader).%New()
 	Do reader.OpenStream(ret)
 	Do reader.Correlate("PatInfo","web.DHCANInterface")	
 	While (reader.Next(.object,.sc)) {
 	 	set opstdatetime=object.OPAStartDateTime 	;
     	set opendatetime=object.OPAEndDateTime	;
     	set opdesc=object.OpName	;
     	set opLevelDesc=object.opLevelDesc
     	set ANASourceTypeDesc=object.ANASourceTypeDesc
     	//set NeedAnaesthetist=object.NeedAnaesthetist
     	s NeedAnaesthetist=""
     	set SingleString=opstdatetime_"^"_opendatetime_"^"_opdesc_"^"_opLevelDesc_"^"_ANASourceTypeDesc_"^"_NeedAnaesthetist
 	 	if resultString="" set resultString=SingleString
 	 	else  set resultString=resultString_"!"_SingleString
 	}
 	If $system.Status.IsError(sc) do $system.OBJ.DisplayError(sc)
 	q resultString
}

/// Desc:获取患者三级手术日期时间
/// Input:	AEpisodeID:患者就诊号
/// Output:	手术单申请结束时间(多个时间以"\"隔开)
/// Debug: w ##class(EPRservice.Quality.DataGather.AdmInfo).OPDateTime01(EpisodeID)
ClassMethod OPDateTime01(AEpisodeID As %String) As %String
{
	q:($d(argAdmId)=0)||(argAdmId="") ""
	
	s PatOPInfo=""
	s OperInfos=..GetOperInfoForBLZK(argAdmId,"","")
	for I=1:1:$l(OperInfos,"!")
	{
		s OperInfo=$p(OperInfos,"!",I)
		s OpDateTime=$p(OperInfo,"^",2)
		s OpLevel=$p(OperInfo,"^",4)
		continue:(OpLevel'="三级")
		s OpType=$p(OperInfo,"^",5)
		continue:(OpType="急诊")
		s:(PatOPInfo'="") PatOPInfo=PatOPInfo_"\"_OpDateTime
		s:(PatOPInfo="") PatOPInfo=OpDateTime
	}
 	q PatOPInfo
}

/// Desc:获取患者四级手术日期时间
/// Input:	AEpisodeID:患者就诊号
/// Output:	手术单申请结束时间(多个时间以"\"隔开)
/// Debug: w ##class(EPRservice.Quality.DataGather.AdmInfo).OPDateTime02(EpisodeID)
ClassMethod OPDateTime02(AEpisodeID As %String) As %String
{
	q:($d(argAdmId)=0)||(argAdmId="") ""
	
	s PatOPInfo=""
	s OperInfos=##class(web.DHCANAdaptor).GetOperInfoForBLZK(argAdmId,"","")
	for I=1:1:$l(OperInfos,"!")
	{
		s OperInfo=$p(OperInfos,"!",I)
		s OpDateTime=$p(OperInfo,"^",2)
		s OpLevel=$p(OperInfo,"^",4)
		continue:(OpLevel'="四级")
		s OpType=$p(OperInfo,"^",5)
		continue:(OpType="急诊")
		s:(PatOPInfo'="") PatOPInfo=PatOPInfo_"\"_OpDateTime
		s:(PatOPInfo="") PatOPInfo=OpDateTime
	}
 	q PatOPInfo
}

/// Desc:获取患者会诊时间
/// Input:	AdmId:患者就诊号;EmFlag:Y急会诊	N平会诊	
/// Output:	会诊时间(多个时间以"\"隔开)
/// Debug: w ##class(EPRservice.Quality.DataGather.AdmInfo).GetEmDataByAdm(EpisodeID)
ClassMethod GetEmDataByAdm(AdmId As %String, EmFlag As %String) As %String
{
	q:AdmId="" EmFlag=""
	s ECRowID=0,str=""
	f  s ECRowID=$o(^DHCEMCON(0,"ADM",AdmId,ECRowID)) q:ECRowID=""  d
	.s Status=$p(^DHCEMCON(ECRowID),"^",18)
	.s ECType=$p(^DHCEMCON(ECRowID),"^",19)
	.s Flag=$p(^DHCEMCON(ECRowID),"^",23)
	.i (Status'=1)&&(Status'=2)&&(Flag=EmFlag) d
	..i (str="") d
	...s str=$zd($p(^DHCEMCON(ECRowID),"^",3),3)_" "_$zt($p(^DHCEMCON(ECRowID),"^",4))
	..e  d 
	...s str=str_"\"_$zd($p(^DHCEMCON(ECRowID),"^",3),3)_" "_$zt($p(^DHCEMCON(ECRowID),"^",4))
	q str
}

/// Desc:获取患者转科时间
/// Input:	argAdmId:患者就诊号
/// Output:	转科时间(多个时间以"\"隔开)
/// Debug: w ##class(EPRservice.Quality.DataGather.AdmInfo).TransDeptDateTime(EpisodeID)
ClassMethod TransDeptDateTime(argAdmId As %String) As %String
{
	q:($d(argAdmId)=0)||(argAdmId="") ""
	
	s ret=""
	s resultInfo=##Class(EMRservice.HISInterface.PatientInfoAssist).TransDeptDetail(argAdmId,"")
	for I=2:1:$l(resultInfo,"->")
	{
		s Data=$p(resultInfo,"->",I)
		q:(Data="")
		
		s DateTime=$zdh($p(Data,"^",3),3)_" "_$zth($p(Data,"^",4))
		s:(ret'="") ret=ret_"\"_DateTime
		s:(ret="") ret=DateTime
	}
  q ret
}

/// Desc:获取患者输血时间
/// Input:	AEpisodeID:患者就诊号
/// Output:	输血时间(多个时间以"\"隔开)
/// Debug: w ##class(EPRservice.Quality.DataGather.AdmInfo).GetBloodTime(EpisodeID)
ClassMethod GetBloodTime(AEpisodeID As %String) As %String
{
	
	s ret=""
	q:EpisodeID="" ret
	
	s BloodInfos=""
	s BloodInfos=##CLASS(DHCLIS.DHCBloodInterface).GetPackIssueByAdm(EpisodeID)
	q:(BloodInfos="") ret
	
	s BloodTime=""
	for I=1:1:$l(BloodInfos,"$$")
	{
		s BloodInfo=$p(BloodInfos,"$$",I)
		s BloodDT=$p(BloodInfo,"^",5)
		s:(BloodTime'="") BloodTime=BloodTime_"\"_BloodDT
		s:(BloodTime="") BloodTime=BloodDT
	}
	s:(BloodTime'="") ret=BloodTime
	
	q ret
}

/// Desc:获取患者危急值时间
/// Input:	AEpisodeID:患者就诊号
/// Output:	危急值时间(多个时间以"\"隔开)
/// Debug: w ##class(EPRservice.Quality.DataGather.AdmInfo).GetCVDateTimeList(EpisodeID)
ClassMethod GetCVDateTimeList(AEpisodeID As %String) As %String
{
	
	s ret=""
	s ds = ##Class(%Library.ResultSet).%New("web.DHCCVCommon:CVReportFromAdm")
	d ds.Execute(AEpisodeID,"")

	while(ds.Next())
	{
		s Applydt = ds.Data("ApplyDT")
		s:(ret'="")&&(Applydt'="") ret=ret_"\"_Applydt
		s:(ret="")&&(Applydt'="") ret=Applydt
	}
	q ret
}

/// Desc：  判断用户是否属于某科室
/// w ##Class(EPRservice.Quality.DataGather.AdmInfo).IsCurrLoc("320","18881")
ClassMethod IsCurrLoc(ctLoc, userId)
{
	Q:(ctLoc="")||(userId="") 0
	i ctLoc'=""  d		
	.s resRowId=""  s flag=0  
	.f  s resRowId=$o(^RB("RES",0,"CTLOC",ctLoc,resRowId))  q:resRowId=""  d
	..s ctpcpId=$p($g(^RB("RES",resRowId)),"^",2)
	..i $g(userId)'=""  d
	...i ctpcpId=$p($g(^SSU("SSUSR",userId)),"^",14)  d 
	....s flag=1
	q flag
}

ClassMethod IsCurrLocByEmployeeID(ALocID As %String, AEmployeeID As %String)
{
	s ret = 0
	q:(ALocID="")||(AEmployeeID="") ret
	s UserID = $O(^SSU("SSUSR",0,"CTPCP",AEmployeeID,""))
	q:UserID="" ret
	s ret = ..IsCurrLoc(ALocID,UserID)
	q ret
}

/// Desc:	取护士第一次安床日期时间(格式: "2009-12-18 10:10:00");
/// Input:	AEpisodeID为患者就诊号;
/// Debug:	w ##Class(EPRservice.Quality.DataGather.AdmInfo).GetRegTime1(201764)
ClassMethod GetRegTime1(AEpisodeID As %String) As %String
{
	s ret = ""
	q:($d(AEpisodeID) = 0)||(AEpisodeID = "") ret
	
	// ^PAADM({PA_Adm.PAADM_RowID},"TRANS",{TRANS_Childsub})
	s DateFlag = 0
	s TransCount = $g(^PAADM(AEpisodeID,"TRANS",0))
	for i = 1:1:TransCount
	{
		//表PA_AdmTransaction的主Global
		s Info = $g(^PAADM(AEpisodeID,"TRANS",i))
		continue:(Info = "")
		
		//第八个字段为TRANS_Bed_DR
		continue:($p(Info,"^",8) = "")
		
		s pDate = $p(Info,"^",1)
		s pTime = $p(Info,"^",2)
		if (pDate '= "")&&(pTime '= "") 
		{
			s DateFlag = 1
			q
		}	
	}
	
	s:(DateFlag = 0) pDate = $p($g(^PAADM(+AEpisodeID)),"^",6)
	s:(DateFlag = 0) pTime = $p($g(^PAADM(+AEpisodeID)),"^",7)
	q:(pDate = "")||(pTime = "") ret
	
	s ret = pDate_" "_pTime
	
	s ret = ##Class(EPRservice.Quality.CommonHelper).ChangeDateTime(ret)
	q ret
}

/// Desc:	取住院登记日期时间(格式: "2009-12-18 10:10:00")
/// Input:	AEpisodeID为患者就诊号;
/// Debug:	w ##Class(EPRservice.Quality.DataGather.AdmInfo).GetRegTime2(201764)
ClassMethod GetRegTime2(AEpisodeID As %String) As %String
{
	s ret = ""
	q:($d(AEpisodeID) = 0)||(AEpisodeID = "") ret
	
	s pDate = $p($g(^PAADM(+AEpisodeID)),"^",6)
	s pTime = $p($g(^PAADM(+AEpisodeID)),"^",7)
	q:(pDate = "")||(pTime = "") ret
	
	s ret = pDate_" "_pTime
	s ret = ##Class(EPRservice.Quality.CommonHelper).ChangeDateTime(ret)
	q ret
}

/// Desc: 	安床时间加一天,用于处理历次病程记录自动任务不能根据检查条件"入院24小后的在院病从"作检查，
/// 		天数加一后自动任务从安床的第二天开始检查历次病程记录。
/// Author:	XueFengLing
/// Input:	AEpisodeID为患者就诊号;
/// Debug:  w ##Class(EPRservice.Quality.DataGather.AdmInfo).GetRegTime3(201764)
ClassMethod GetRegTime3(AEpisodeID As %String) As %String
{
 	s ret = ""
 	q:($d(AEpisodeID) = 0)||(AEpisodeID = "") ret
 
 	//^PAADM({PA_Adm.PAADM_RowID},"TRANS",{TRANS_Childsub})
 	s DateFlag = 0
	s TransCount = $o(^PAADM(AEpisodeID,"TRANS",0))
	for i = 1:1:TransCount
	{
		//表PA_AdmTransaction的主Global
		s Info = $g(^PAADM(AEpisodeID,"TRANS",i))
		continue:(Info = "")
		
		//第八个字段为TRANS_Bed_DR
		continue:($p(Info,"^",8) = "")
		
		s pDate = $p(Info,"^",1)
		s pTime = $p(Info,"^",2)
		if (pDate '= "")&&(pTime '= "") 
		{
			s DateFlag = 1
			q
		}	
	}
 
 	s:(DateFlag = 0) pDate = $p($g(^PAADM(+AEpisodeID)),"^",6)
 	s:(DateFlag = 0) pTime = $p($g(^PAADM(+AEpisodeID)),"^",7)
 	q:(pDate = "")||(pTime = "") ret
 	
 	//入院日期加1天
 	s pDate = pDate + 1  
 	s ret = pDate_" "_pTime

 	s ret = ##Class(EPRservice.Quality.CommonHelper).ChangeDateTime(ret)
 	q ret
}

/// Desc:	取病人出院时间(单位:小时),计算的是出院时间到当前时间的差值;
/// Input:	ADischTimeVal为患者出院日期时间;
/// Debug:	w ##Class(EPRservice.Quality.DataGather.AdmInfo).GetDischHour("2011-03-23 10:00:00")
ClassMethod GetDischHour(ADischTimeVal As %String) As %String
{
	s ret = -1
	s DischDateTime = $g(ADischTimeVal)
	q:(DischDateTime = "") ret
	
	s DisDate = $p(DischDateTime," ",1),DisTime = $p(DischDateTime," ",2)
	q:(DisDate = "")||(DisTime = "") ret
	
	s DisDate = $zdh(DisDate,3),DisTime = $zth(DisTime,2)
	s CurrDate = +$h,CurrTime = $p($h,",",2)
	
	s cDay = 0,cHour = 0
	s cDay = CurrDate - DisDate
	s cHour = $j((CurrTime - DisTime)\3600,2,1)
	s ret = cDay * 24 + cHour
	q ret
}

/// Desc:	取医疗结算日期时间(格式: "2009-12-18 10:10:00")
/// Input:	AEpisodeID为患者就诊号;
/// Debug:	w ##Class(EPRservice.Quality.DataGather.AdmInfo).GetDischTime1(201764)
ClassMethod GetDischTime1(AEpisodeID As %String) As %String
{
	s ret = ""
	q:($d(AEpisodeID) = 0)||(AEpisodeID = "") ret
	
	s disDate = $p($g(^PAADM(+AEpisodeID)),"^",59)
	s disTime = $p($g(^PAADM(+AEpisodeID)),"^",60)
	q:(disDate = "")||(disTime = "") ret
	
	s ret = disDate_" "_disTime
	s ret = ##Class(EPRservice.Quality.CommonHelper).ChangeDateTime(ret)
	q ret
}

/// Desc:	取最终结算日期时间(格式: "2009-12-18 10:10:00");
/// Input:	AEpisodeID为患者就诊号;
/// Debug:	w ##Class(EPRservice.Quality.DataGather.AdmInfo).GetDischTime2(201764)
ClassMethod GetDischTime2(AEpisodeID As %String) As %String
{
	s ret = ""
	q:($d(AEpisodeID) = 0)||(AEpisodeID = "") ret
	
	s disDate = $p($g(^PAADM(+AEpisodeID)),"^",17)
	s disTime = $p($g(^PAADM(+AEpisodeID)),"^",18)
	q:(disDate = "")||(disTime = "") ret
	
	s ret = disDate_" "_disTime
	s ret = ##Class(EPRservice.Quality.CommonHelper).ChangeDateTime(ret)
	q ret
}

/// Desc:	取护士结算日期时间(格式: "2009-12-18 10:10:00");
/// Input:	AEpisodeID为患者就诊号;
/// Debug:	w ##Class(EPRservice.Quality.DataGather.AdmInfo).GetDischTime4(201764)
ClassMethod GetDischTime4(AEpisodeID As %String) As %String
{
	s ret = ""
	q:($d(AEpisodeID) = 0)||(AEpisodeID = "") ret
	
	s disDate = $p($g(^PAADM(+AEpisodeID)),"^",59)
	s disTime = $p($g(^PAADM(+AEpisodeID)),"^",60)
	q:(disDate = "")||(disTime = "") ret
	
	s ret = disDate_" "_disTime
	s ret = ##Class(EPRservice.Quality.CommonHelper).ChangeDateTime(ret)
	q ret
}

/// Desc:	取最终结算日期时间前一天(格式: "2009-12-18 10:10:00");
/// Input:	AEpisodeID为患者就诊号;
/// Debug:	w ##Class(EPRservice.Quality.DataGather.AdmInfo).GetDischTime3(201764)
ClassMethod GetDischTime3(AEpisodeID As %String) As %String
{
	s ret = ""
	q:($d(AEpisodeID) = 0)||(AEpisodeID = "") ret
	
	s disDate = $p($g(^PAADM(+AEpisodeID)),"^",17)
	s disTime = $p($g(^PAADM(+AEpisodeID)),"^",18)
	q:(disDate = "")||(disTime = "") ret
	
	s disDate = disDate - 1
	s ret = disDate_" "_disTime
	s ret = ##Class(EPRservice.Quality.CommonHelper).ChangeDateTime(ret)
	q ret
}

/// Desc:	取医疗结算日期(格式: "2009-12-18");
/// Input:	AEpisodeID为患者就诊号;
/// Debug:	w ##Class(EPRservice.Quality.DataGather.AdmInfo).GetDischDate1(201869)
ClassMethod GetDischDate1(AEpisodeID As %String) As %String
{
	s ret = ""
	q:($d(AEpisodeID) = 0)||(AEpisodeID = "") ret
	
	s dischTime1 = ..GetDischTime1(AEpisodeID)
	s ret = $p(dischTime1," ",1)
	
	q ret
}

/// Desc:	取最终结算日期(格式: "2009-12-18");
/// Input:	AEpisodeID为患者就诊号;
/// Debug:	w ##Class(EPRservice.Quality.DataGather.AdmInfo).GetDischDate2(201871)
ClassMethod GetDischDate2(AEpisodeID As %String) As %String
{
	s ret = ""
	q:($d(AEpisodeID) = 0)||(AEpisodeID = "") ret
	
	s dischTime2 = ..GetDischTime2(AEpisodeID)
	s ret = $p(dischTime2," ",1)
	
	q ret
}

/// Desc:	获取医疗结算时填写的出院状态（一般为C01^正常出院、C02^自动出院、C03^死亡）
///  	   	特殊说明：宁夏项目"自动退院"表示退院,就诊状态为"Dsich"，不为"Cancel"
/// Input:	AEpisodeID为患者就诊号;
/// Return:	ret="PAC_DischCondit"表的Desc值;
/// Debug:	w ##Class(EPRservice.Quality.DataGather.AdmInfo).GetDischCondit(201871)
ClassMethod GetDischCondit(AEpisodeID)
{
	s ret = ""
	q:($d(AEpisodeID) = 0)||(AEpisodeID = "") ret
	
	s MRADM = $p($g(^PAADM(AEpisodeID)),"^",61)
	q:(MRADM = "") ret
	
	s tmpMRADM = $g(^MR(+MRADM,"PRO",1))   //MR_ADM
	s DischConditID = $p(tmpMRADM,"^",10)
	s:(DischConditID '= "") ret = $p($g(^PAC("DISCON",+DischConditID)),"^",2)
	
	q ret
}

/// Desc:	取体温单死亡时间,华西医院取体温单死亡时间作为病人的死亡时间;
/// Input:	AEpisodeID为患者就诊号;
/// Output:	死亡时间,格式:"2009-12-18 10:10"
/// Debug:	w ##Class(EPRservice.Quality.DataGather.AdmInfo).GetDeathTime1(201871)
ClassMethod GetDeathTime1(AEpisodeID As %String) As %String
{
	s ret = ""
	q:($d(AEpisodeID) = 0)||(AEpisodeID = "") ret
	
	s Ind = ""
	for {
		s Ind = $o(^DHCADMQTREC("adm",AEpisodeID,Ind))
		q:(Ind = "")||(ret '= "")
		
		s ADate = $p($g(^DHCADMQTREC("QTREC",Ind)),"^",2)
		s:(ADate '= "") ADate = $zd(ADate,3)
		
		s ATime = $p($g(^DHCADMQTREC("QTREC",Ind)),"^",3)
		s:(ATime '= "") ATime = $zt(ATime,2)
		
		s Type = ""
		s TypeDr = $p($g(^DHCADMQTREC("QTREC",Ind)),"^",4)
		s:(TypeDr '= "") Type = $p($g(^DHCQTRECTYP("typ",TypeDr)),"^",2)
		continue:(Type '= "死亡")
		continue:(ADate = "")||(ATime = "")
		
		s ret = ADate_" "_ATime	
	}

	s ret = ##Class(EPRservice.Quality.CommonHelper).ChangeDateTime(ret)
	q ret
}

/// Desc:	取病人基本信息表(Pa_Patmas)死亡时间;
/// Input:	AEpisodeID为就诊号;
/// Return:	死亡时间,格式:"2009-12-18 10:10"
/// Debug:	w ##Class(EPRservice.Quality.DataGather.AdmInfo).GetDeathTime2(201871)
ClassMethod GetDeathTime2(AEpisodeID As %String) As %String
{
	s ret = ""
	q:($d(AEpisodeID) = 0)||(AEpisodeID = "") ret
	
	s patientID = $p($g(^PAADM(+AEpisodeID)),"^",1)
	s deathFlag = $p($g(^PAPER(+patientID,"ALL")),"^",12)
	
	if ($zcvt(deathFlag,"U") = "Y")
	{
		//判断当前就诊是否是患者在本院的最后一次住院就诊
		s lastEpisodeID = $o(^PAPERdr(patientID,"ADM","I",AEpisodeID))
		if (lastEpisodeID '= "")
		{
			//不是最后一次就诊,意味着当前就诊时患者还未死亡
			s ret = ""	
		}
		else
		{
			//患者在当前就诊中死亡, 可以去患者基本信息表中的死亡日期时间
			s deathDate = $p($g(^PAPER(+patientID,"ALL")),"^",13)
			s deathTime = $p($g(^PAPER(+patientID,"ALL")),"^",8)
			s ret = deathDate_" "_deathTime	
			s ret = ##Class(EPRservice.Quality.CommonHelper).ChangeDateTime(ret)
		}
	}
	
	q ret
}

/// Desc:取呼吸心路停止医嘱时间
/// Creator:Candyxu
/// CreateDate:2013-01-25
/// Input:AOrdItemTime 呼吸心路停止医嘱时间(公共函数)
/// Output:"2008-12-05 09:01:05"格式的时间或""
/// Debuge:w ##Class(EPRservice.Quality.DataGather.AdmInfo).GetDeathTime3("61338 57600")
ClassMethod GetDeathTime3(AOrdItemTime As %String) As %String
{
	s ret = ""
	q:((AOrdItemTime = "")|| $F(AOrdItemTime,"\")) ret
	s ret = ##Class(EPRservice.Quality.CommonHelper).ChangeDateTime(AOrdItemTime)
	q ret
}

/// Function:	判断是否传染病患者
/// Input:		AEpisodeID为就诊号
/// Output:		ret = Y|N
/// Debug:		w ##Class(EPRservice.Quality.DataGather.AdmInfo).IsReportEpidemic(49)
ClassMethod IsReportEpidemic(AEpisodeID)
{
	s ret = "N"
	q:($d(AEpisodeID) = 0)||(AEpisodeID = "") ret
	
	//^DHCMEPD("0","PAADM",{MEPD_Text1},{MEPD_Rowid})
	s RowID = $o(^DHCMEPD("0","PAADM",AEpisodeID,0))
	While(RowID '= "")
	{
		s tmp = $g(^DHCMEPD(RowID))
		//15字段--传染病报告状态
		//除了删除和被订的报告，其他都是有效的报告
		s:($p(tmp,"^",15)'["0") ret = "Y"
		s RowID = $o(^DHCMEPD("0","PAADM",AEpisodeID,RowID))
	}
	q ret
}

/// Desc:	判断是否院感患者;
/// Input:	AEpisodeID为患者就诊号;
/// Output:	ret = Y|N
/// Debug:	w ##Class(EPRservice.Quality.DataGather.AdmInfo).IsInHospInf(201871)
ClassMethod IsInHospInf(AEpisodeID)
{
	s ret = "N"
	q:($d(AEpisodeID) = 0)||(AEpisodeID = "") ret
	
	//^DHCMedIR(0,"PAADM",{MIR_Paadm_DR},{MIR_Rowid})
	s RowID = $o(^DHCMedIR(0,"PAADM",AEpisodeID,0))
	While(RowID '= "")
	{
		s tmp = $g(^DHCMedIR(RowID))
		//16字段--院内感然/社区感染
		//除了删除和被订的报告，其他都是有效的报告
		s:($p(tmp,"^",11)'["0") ret = "Y"
		s RowID = $o(^DHCMedIR(0,"PAADM",AEpisodeID,RowID))
	}
	q ret
}

/// Desc:	判断就诊号是否最后一次就诊;
/// Input:	AEpisodeID为患者就诊号;
/// 		AVisitType为就诊类型;
/// Return:	1:是;-1:否;0:参数错误;
/// Debug:	w ##Class(EPRservice.Quality.DataGather.AdmInfo).IsLastAdm(201871,"I")
ClassMethod IsLastAdm(AEpisodeID, AVisitType)
{
	s ret = 0
	q:($d(AEpisodeID) = 0)||(AEpisodeID = "") ret
	
	s Papmi = $p($g(^PAADM(+AEpisodeID)),"^",1)
	if (AVisitType = "")
	{
		s LastAdm = +$o(^PAPERdr(Papmi,"ADM","I",""),-1)
		s LastAdm2 = +$o(^PAPERdr(Papmi,"ADM","O",""),-1)
		s LastAdm3 = +$o(^PAPERdr(Papmi,"ADM","E",""),-1)
		s:(LastAdm < LastAdm2) LastAdm = LastAdm2
		s:(LastAdm < LastAdm3) LastAdm = LastAdm3
	}
	else
	{
		s LastAdm = +$o(^PAPERdr(Papmi,"ADM",AVisitType,""),-1)
	}
	
	if (AEpisodeID = LastAdm)
	{
		s ret = 1	
	}
	else
	{
		s ret = -1	
	}
	q ret
}

/// Desc:	取检验血型 东华LIS系统;
/// 		CTBB_BLOODGROUP\DEB_DEBTOR.DEB_BLOODGROUP_DR
/// Input:	AEpisodeID为患者就诊号;  
/// Debug:	w ##Class(EPRservice.Quality.DataGather.AdmInfo).GetDHBloodGroup(201871)
ClassMethod GetDHBloodGroup(AEpisodeID)
{
	s ret = ""
	q:($d(AEpisodeID) = 0)||(AEpisodeID = "") ret
	
	s Papmi = $p($g(^PAADM(AEpisodeID)),"^",1)
	q:(Papmi = "") ret
	s RegNo = $p($g(^PAPER(Papmi,"PAT",1)),"^",1)
	q:(RegNo = "") ret
	s Config = ##Class(websys.Configuration).%OpenId(1)
    s MEDDATA = Config.DataNamespace
    s LABDATA = Config.LabDataNamespace
    s CurrentNS = $ZNSPACE
    d Config.%Close()
    zn LABDATA
    s BloodGroupID = $p($g(^TDEB(RegNo)),"\",4)
	s:(BloodGroupID = "") BloodGroupID = $p($g(^TDEB(RegNo)),"\",10)
	s:(BloodGroupID '= "") ret = $p($g(^TTAB("BB-BG",BloodGroupID)),"\",2)
	zn CurrentNS
	
	s:(ret '= "") ret = $$ALPHAUP^SSUTIL4(ret)
	if (ret [ "AB") s ret = "AB"
	else  if (ret [ "A") s ret = "A"
	else  if (ret [ "B") s ret = "B"
	else  if (ret [ "O") s ret = "O"
	else  s ret = ""
	
	q ret
}

/// Desc:	取患者转科次数
/// Input:	AEpisodeID为患者就诊号;  
/// Debug:	w ##Class(EPRservice.Quality.DataGather.AdmInfo).GetTransLocCount(201871)
ClassMethod GetTransLocCount(AEpisodeID)
{
	s ret = 0
	q:($d(AEpisodeID) = 0)||(AEpisodeID = "") ret
	q:('$d(^PAADM(AEpisodeID))) ret
	
	s CurrLoc = "",Count = 0
	//^PAADM({PA_Adm.PAADM_RowID},"TRANS",{TRANS_Childsub})
	s ChildSub = $o(^PAADM(AEpisodeID,"TRANS",""))
	While(ChildSub '= "")
	{
		s tmpLoc = $p($g(^PAADM(AEpisodeID,"TRANS",ChildSub)),"^",6)
		if (tmpLoc '= "")
		{
			s:(CurrLoc '= tmpLoc) Count = Count + 1
			s CurrLoc = tmpLoc
		}
		s ChildSub = $o(^PAADM(AEpisodeID,"TRANS",ChildSub))
	}
	s ret = Count - 1 
	s:(ret < 0) ret = 0
	q ret
}

/// Desc:	获取患者婚姻状态,返回代码描述; 
/// Input:	AEpisodeID为患者就诊号;  
/// Return:	ret=已婚|未婚|单身|丧偶|离弃...
/// Debug:	w ##Class(EPRservice.Quality.DataGather.AdmInfo).GetMaritalStatus("65")
ClassMethod GetMaritalStatus(AEpisodeID As %String) As %String
{
	s ret = ""
	q:($d(AEpisodeID) = 0)||(AEpisodeID = "") ret
	
	s Papmi = $p($g(^PAADM(AEpisodeID)),"^",1)
	q:(($d(Papmi) = 0)||(Papmi = "")) ret
	q:(($d(^PAPER(Papmi,"PER",2)) '= 1)&&($d(^PAPER(Papmi,"PER",2)) '= 11)) ret
	
	s Marital = ""
	s MaritalDR = $p($g(^PAPER(Papmi,"PER",2)),"^",3)
	s:(MaritalDR '= "") Marital = $p($g(^CT("MAR",MaritalDR)),"^",2)
	s ret = Marital
	q ret
}

/// Desc:	获取患者性别,返回代码描述;
/// Input:	AEpisodeID为患者就诊号;  
/// Return:	ret=男|女|不确定...
/// Debug:	w ##Class(EPRservice.Quality.DataGather.AdmInfo).GetSex(65)
ClassMethod GetSex(AEpisodeID As %String) As %String
{
	s ret = ""
	q:($d(AEpisodeID) = 0)||(AEpisodeID = "") ret
	
	s Papmi = $p($g(^PAADM(AEpisodeID)),"^",1)
	q:(Papmi = "") ret
	q:('$d(^PAPER(Papmi,"ALL"))) ret
	s Sex = $p($g(^PAPER(Papmi,"ALL")),"^",7)
	s:(Sex '= "") Sex = $p($g(^CT("SEX",Sex)),"^",2)
	s ret = Sex
	q ret
}

/// Desc:	获取患者出生日期;
/// Input:	AEpisodeID为患者就诊号;
/// Debug:	w ##Class(EPRservice.Quality.DataGather.AdmInfo).GetBirthday(201871)
ClassMethod GetBirthday(AEpisodeID As %String) As %String
{
	s ret = ""
	q:($d(AEpisodeID) = 0)||(AEpisodeID = "") ret
	
	s Papmi = $p($g(^PAADM(AEpisodeID)),"^",1)
	q:(Papmi = "") ret
	q:('$d(^PAPER(Papmi,"ALL"))) ret
	
	s Birthday = +$p($g(^PAPER(Papmi,"ALL")),"^",6)
	q:(Birthday = 0) ret
	s ret = $zd(Birthday,3)
	q ret
}

/// Create: YHY
/// Input: argPapmiDr: Pa_PatMas.Papmi_RowId
/// argAdmId: Pa_Adm.PAADM_RowId
/// argAdmDate: Pa_Adm.PAADM_AdmDate
/// argAdmTime: Pa_Adm.PAADM_AdmTime
/// Output: 年龄显示字符串
/// Desc: 根据病人ID和就诊ID获取病人年龄
/// Debug: w ##Class(EPRservice.Quality.DataGather.AdmInfo).Age(201871)
ClassMethod Age(argPapmiDr As %String, argAdmId As %String, argAdmDate As %String, argAdmTime As %String) As %String
{
	s ReturnValue=""

	//调用年龄统一接口
	s ReturnValue = ##class(web.DHCBillInterface).GetPapmiAge(argPapmiDr,argAdmId,argAdmDate,argAdmTime)
	q ReturnValue
}

/// Desc:	获取患者年龄(单位:岁),"-1"表示年龄为空
/// Input:	AEpisodeID为患者就诊号;
/// Debug:	w ##Class(EPRservice.Quality.DataGather.AdmInfo).GetAge(201871)
ClassMethod GetAge(AEpisodeID As %String) As %String
{
	s ret = "-1"
	q:($d(AEpisodeID) = 0)||(AEpisodeID = "") ret

	s Birthday = ..GetBirthday(AEpisodeID)
	q:(Birthday = "") ret
	s ret = ((+$H)-$ZDH(Birthday,3))\360
	q ret
}

/// Desc:		取手术申请单开始时间和结束时间
/// Table:		DHC_AN_OPArrange:OPA_StartDate14,OPA_StartTime15,OPA_EndDate16,OPA_EndTime17,OPA_Status27="Finish"
/// 特殊说明：	宁夏项目做了多少手术以手术申请单上登记时间（开始时间+结束时间）为准
/// Debug:		w ##Class(EPRservice.Quality.DataGather.AdmInfo).GetOPArranges(EpisodeID)
ClassMethod GetOPArranges(AEpisodeID As %String) As %String
{
	s ret = ""
	q:($d(AEpisodeID) = 0)||(AEpisodeID = "") ret
	
	//IndexPaAdm ^DHCANOPArrange(0,"Adm",{OPA_Adm_Dr},{OPA_Rowid})
	s RowID = 0
	for {
		s RowID = $o(^DHCANOPArrange(0,"Adm",AEpisodeID,RowID))
		q:(RowID = "")
	
		s tmp = $g(^DHCANOPArrange(RowID))
		continue:(tmp = "")
		
		s status = $p(tmp,"^",27)
		//Apply,Decline,Receive,InRoom,Operate,LeaveRoom,Finish,NotApp
		//A,D,R,I,O,L,F,N
		continue:(status '= "F")
		
		s startDate = $p(tmp,"^",14)
		s startTime = $p(tmp,"^",15)
		s endDate = $p(tmp,"^",16)
		s endTime = $p(tmp,"^",17)
		continue:(startDate = "")||(endDate = "")
		
		s ret = ret_$lb(startDate_" "_startTime_" "_endDate_" "_endTime)
	}
	
	s:(ret '= "") ret = ##Class(EPRservice.Quality.CommonHelper).GetListToString(ret,"\")
	q ret
}

/// Desc:	获取患者入院科室【返回: RowId^Code^Desc】
/// Input:	AEpisodeID为患者就诊号;	
/// Return:	RowId^Code^Desc
/// Debug:	w ##Class(EPRservice.Quality.DataGather.AdmInfo).AdmDept(201871)
ClassMethod AdmDept(AEpisodeID As %String) As %String
{
	s ret = ""
	q:(($d(AEpisodeID) = 0)||(AEpisodeID = "")) ret
	
	s (TRANSChildsub,LocDR,TmpLocDR,Bed,AdmDept,DeptDesc,DeptCode) = ""
	
	// 遍历转科记录,取入院科室
	for {
		s TRANSChildsub = $o(^PAADM(AEpisodeID,"TRANS",TRANSChildsub)) 
		q:(TRANSChildsub = "")||(Bed '= "")  
		
		s Bed = $p($g(^PAADM(AEpisodeID,"TRANS",TRANSChildsub)),"^",8)
		s TmplocDR = $p($g(^PAADM(AEpisodeID,"TRANS",TRANSChildsub)),"^",6)
		s:(TmplocDR '= "") LocDR = TmplocDR
	}

	if (LocDR '= "") 
	{	
		s DeptCode = $p($g(^CTLOC(LocDR)),"^",1)
		s DeptDesc = $p($g(^CTLOC(LocDR)),"^",2)
		s:(DeptDesc [ "-") DeptDesc = $p($g(DeptDesc),"-",2)
		s AdmDept = LocDR_"^"_DeptCode_"^"_DeptDesc		
	}
	
	q AdmDept
}

/// Desc:	获取患者所在科室(在院患者为当前就诊科室;出院患者为出院科室);
/// Input:	AEpisodeID为患者就诊号;
/// Debug:	w ##Class(EPRservice.Quality.DataGather.AdmInfo).GetAdmLoc("201871")
ClassMethod GetAdmLoc(AEpisodeID As %String) As %String
{
	s ret = ""
	q:($d(AEpisodeID) = 0)||(AEpisodeID = "") ret
	s ret = +$p($g(^PAADM(AEpisodeID)),"^",4)
	q ret
}

/// Desc:	根据住院号获取就诊号;
/// Input:	AIPNo为患者住院号;
/// Debug:	w ##Class(EPRservice.Quality.DataGather.AdmInfo).GetPaadmByIPNo("IP000045")
ClassMethod GetPaadmByIPNo(AIPNo As %String) As %String
{
	s ret = ""
	s AIPNo = $$ALPHAUP^SSUTIL4(AIPNo)
	q:(AIPNo = "") ret
	// ^PAADMi("No",$$ALPHAUP({PAADM_ADMNo}),{PAADM_RowID})
	s ret = $o(^PAADMi("No",AIPNo,0))
	q ret
}

/// Desc:	根据就诊号获取患者住院号;
/// Input:	AEpisodeID为患者就诊号;
/// Debug:	w ##Class(EPRservice.Quality.DataGather.AdmInfo).GetIPNoByPaadm(65)
ClassMethod GetIPNoByPaadm(AEpisodeID As %String) As %String
{
	s ret=""
	q:($d(AEpisodeID)=0)||(AEpisodeID="") ret
	s ret=$p($g(^PAADM(+AEpisodeID)),"^",81)
	q ret
}

/// Desc:	入院诊断
/// Input:	argAdmId: 就诊rowid， argAdmDiagTypeId：入院诊断类型id
/// Output:	RowId^诊断代码^诊断描述!RowId^诊断代码^诊断描述
/// Debug:	w ##Class(EPRservice.Quality.DataGather.AdmInfo).AdmDiagnos(201871)
ClassMethod AdmDiagnos(argAdmId As %String) As %String
{
	q:($d(argAdmId)=0)||(argAdmId="") ""
	s retValue = ""
	
	//取表 MRC_DiagnosType 中入院诊断对应的RowId 
	s admDiagTypeId = ""
	s admDiagTypeId = $O(^MRC("DTYP",0,"Code","PRE",""))
	q:(admDiagTypeId = "") ""
	
	
	s mainmradmdr = $p($g(^PAADM(argAdmId)),"^",61)
	q:(mainmradmdr = "") ""
	q:($d(^MR(mainmradmdr)) = 0) ""
	
	
	s themrdiachildsub = ""
	s mrdiachildsub = ""
	for {
		s mrdiachildsub=$o(^MR(mainmradmdr,"DIA",mrdiachildsub))
		q:(mrdiachildsub="")
		
		s mrdiagtype = ""
		for {
			q:($d(^MR(mainmradmdr,"DIA",mrdiachildsub,"TYP"))=0)
			s mrdiagtype=$o(^MR(mainmradmdr,"DIA",mrdiachildsub,"TYP",mrdiagtype))
			q:(mrdiagtype="")
			
			s typmrcdiagtyp = $p($g(^MR(mainmradmdr,"DIA",mrdiachildsub,"TYP",mrdiagtype)),"^",1)
			if (typmrcdiagtyp = admDiagTypeId)	//此处判断是否为入院诊断
			{
				s themrdiachildsub = mrdiachildsub
				
				s mricdid = $p($g(^MR(mainmradmdr,"DIA",themrdiachildsub)),"^",1)
				q:(mricdid = "") 
	
				s mricdCode = $p($g(^MRC("ID",mricdid)),"^",4)
				s mricdDesc = $p($g(^MRC("ID",mricdid)),"^",2)
				
				if (retValue = "")
				{	s retValue = mricdid_"^"_mricdCode_"^"_mricdDesc}
				else
				{	s retValue = retValue_"!"_mricdid_"^"_mricdCode_"^"_mricdDesc}
			}
		}
	}
	
	q retValue
}

/// Desc:	主要诊断
/// Input:	argAdmId: 就诊rowid， argAdmDiagTypeId：主要诊断类型id
/// Output:	RowId^诊断代码^诊断描述
/// Debug:	w ##Class(EPRservice.Quality.DataGather.AdmInfo).MainDiagnos(201871)
ClassMethod MainDiagnos(argAdmId As %String) As %String
{
	q:($d(argAdmId)=0)||(argAdmId="") ""
	s retValue = ""
	
	//取表 MRC_DiagnosType 中入院诊断对应的RowId 
	s mainDiagTypeId = ""
	s mainDiagTypeId = $O(^MRC("DTYP",0,"Code","M",""))
	q:(mainDiagTypeId = "") ""
	
	
	s mainmradmdr = $p($g(^PAADM(argAdmId)),"^",61)
	q:(mainmradmdr = "") ""
	q:($d(^MR(mainmradmdr)) = 0) ""
	
	
	s themrdiachildsub = ""
	s mrdiachildsub = ""
	for {
		s mrdiachildsub=$o(^MR(mainmradmdr,"DIA",mrdiachildsub))
		q:(mrdiachildsub="")
		
		s mrdiagtype = ""
		for {
			q:($d(^MR(mainmradmdr,"DIA",mrdiachildsub,"TYP"))=0)
			s mrdiagtype=$o(^MR(mainmradmdr,"DIA",mrdiachildsub,"TYP",mrdiagtype))
			q:(mrdiagtype="")
			
			s typmrcdiagtyp = $p($g(^MR(mainmradmdr,"DIA",mrdiachildsub,"TYP",mrdiagtype)),"^",1)
			if (typmrcdiagtyp = mainDiagTypeId)	//此处判断是否为主要诊断
			{
				s themrdiachildsub = mrdiachildsub
				
				s mricdid = $p($g(^MR(mainmradmdr,"DIA",themrdiachildsub)),"^",1)
				q:(mricdid = "") 
	
				s mricdCode = $p($g(^MRC("ID",mricdid)),"^",4)
				s mricdDesc = $p($g(^MRC("ID",mricdid)),"^",2)
				
				if (retValue = "")
				{	s retValue = mricdid_"^"_mricdCode_"^"_mricdDesc}
				else
				{	s retValue = retValue_"!"_mricdid_"^"_mricdCode_"^"_mricdDesc}
			}
		}
	}
	
	q retValue
}

/// Desc:	出院诊断
/// Input:	argAdmId: 就诊rowid
/// Output:	RowId^诊断代码^诊断描述!RowId^诊断代码^诊断描述
/// Debug:	w ##Class(EPRservice.Quality.DataGather.AdmInfo).OutDiagnos(201871)
ClassMethod OutDiagnos(argAdmId As %String) As %String
{
	q:($d(argAdmId)=0)||(argAdmId="") ""
	s retValue = ""
	
	//取表 MRC_DiagnosType 中出院诊断对应的RowId 
	s admDiagTypeId = ""
	s admDiagTypeId = $O(^MRC("DTYP",0,"Code","DIS",""))  
	q:(admDiagTypeId = "") ""
	
	
	s mainmradmdr = $p($g(^PAADM(argAdmId)),"^",61)
	q:(mainmradmdr = "") ""
	q:($d(^MR(mainmradmdr)) = 0) ""
	
	
	s themrdiachildsub = ""
	s mrdiachildsub = ""
	for {
		s mrdiachildsub=$o(^MR(mainmradmdr,"DIA",mrdiachildsub))
		q:(mrdiachildsub="")
		
		s mrdiagtype = 0
		for {
			q:($d(^MR(mainmradmdr,"DIA",mrdiachildsub,"TYP"))=0)
			s mrdiagtype=$o(^MR(mainmradmdr,"DIA",mrdiachildsub,"TYP",mrdiagtype))
			q:(mrdiagtype="")
			
			s typmrcdiagtyp = $p($g(^MR(mainmradmdr,"DIA",mrdiachildsub,"TYP",mrdiagtype)),"^",1)
			if (typmrcdiagtyp = admDiagTypeId)	//此处判断是否为出院诊断
			{
				s themrdiachildsub = mrdiachildsub
				
				s mricdid = $p($g(^MR(mainmradmdr,"DIA",themrdiachildsub)),"^",1)
				q:(mricdid = "") 
	
				s mricdCode = $p($g(^MRC("ID",mricdid)),"^",4)
				s mricdDesc = $p($g(^MRC("ID",mricdid)),"^",2)
				
				if (retValue = "")
				{	s retValue = mricdid_"^"_mricdCode_"^"_mricdDesc}
				else
				{	s retValue = retValue_"!"_mricdid_"^"_mricdCode_"^"_mricdDesc}
			}
		}
	}
	
	q retValue
}

/// Desc: 	诊断信息，诊断的优先原则为：出院诊断>主要诊断>入院诊断
/// Input: 	AEpisodeID为患者就诊号;
/// Return: RowId^诊断代码^诊断描述
/// Debug:	w ##Class(EPRservice.Quality.DataGather.AdmInfo).GetDiagnosInfo(201871)
ClassMethod GetDiagnosInfo(AEpisodeID As %String) As %String
{
	s ret = ""
	q:(AEpisodeID = "") ret
	
	s diagnos = ..OutDiagnos(AEpisodeID)
	q:(diagnos '= "") $P(diagnos,"!",1)
	
	s diagnos = ..MainDiagnos(AEpisodeID)
	q:(diagnos '= "") $P(diagnos,"!",1)
	
	s diagnos = ..AdmDiagnos(AEpisodeID)
	q:(diagnos '= "") $P(diagnos,"!",1) 
	
	q ret
}

/// Desc:	查询患者某次就诊信息
/// Input:	AEpisodeID为患者就诊号;
/// Debug:	d ##Class(%ResultSet).RunQuery("EPRservice.Quality.DataGather.AdmInfo","GetAdmInfoByEpisodeID","201871")
Query GetAdmInfoByEpisodeID(AEpisodeID As %String) As %Query(ROWSPEC = "EpisodeID,Name,Sex,Age,Doctor,CTLocDesc,AdmitDate,DischDate")
{
}

ClassMethod GetAdmInfoByEpisodeIDExecute(ByRef qHandle As %Binary, AEpisodeID As %String) As %Status
{
	s repid = $I(^CacheTemp)
	s ind = 1
	s qHandle = $lb(0,repid,0)
	
	q:($d(AEpisodeID) = 0)||(AEpisodeID = "") $$$OK
	
	s objAdm = $g(^PAADM(+AEpisodeID))
	q:(objAdm = "") $$$OK
	
	s (Name,Sex,Age,Doctor,AdmitDept,DischDept,AdmitDate,DischDate) = $C(0)
	
	s Papmi = +$p(objAdm,"^",1)
	s Name = $p($g(^PAPER(Papmi,"ALL")),"^",1)
	s Sex = $p($g(^CT("SEX",$p($g(^PAPER(Papmi,"ALL")),"^",7))),"^",2)
	s Birthday = $p($g(^PAPER(Papmi,"ALL")),"^",6)
	s:(Birthday '= "") Birthday = $zd(Birthday,3)
	s:(Birthday '= "") Age = ((+$h)-$zdh(Birthday,3))\365
	s DoctorID = +$p(objAdm,"^",9)
	s:(DoctorID '= 0) Doctor = $p($g(^CTPCP((DoctorID),1)),"^",2)
	s CTLocID = +$p(objAdm,"^",4)
	s:(CTLocID '= 0) CTLocDesc = $p($p($g(^CTLOC(CTLocID)),"^",2),"-",2)
	s AdmDate = $zd($p(objAdm,"^",6),3), AdmTime = $zt($p(objAdm,"^",7))
    s AdmitDate = AdmDate_" "_AdmTime
    s:($p(objAdm,"^",17) '= "") DisDate = $zd($p(objAdm,"^",17),3), DisTime = $zt($p(objAdm,"^",18)), DischDate = DisDate_" "_DisTime
	
	s Data = $lb(AEpisodeID,Name,Sex,Age,Doctor,CTLocDesc,AdmitDate,DischDate)
	s ^CacheTemp(repid,ind) = Data
	s ind = ind+1
	
	q $$$OK
}

ClassMethod GetAdmInfoByEpisodeIDFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAdmInfoByEpisodeIDExecute ]
{
	s AtEnd = $list(qHandle,1)
 	s repid = $list(qHandle,2)
 	s ind = $list(qHandle,3)
 	
 	s ind = $o(^CacheTemp(repid,ind))
 	if (ind = "") 
 	{				
 		s AtEnd = 1
 		s Row = ""
 		k ^CacheTemp(repid)
 	} 
 	else 
 	{			
 		s Row = ^CacheTemp(repid,ind)
 	}
 	s qHandle = $lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod GetAdmInfoByEpisodeIDClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAdmInfoByEpisodeIDExecute ]
{
	s repid = $list(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

/// Debug:	d ##Class(%ResultSet).RunQuery("EPRservice.Quality.DataGather.AdmInfo","GetPatientList","","","","","","","61989","61990")
Query GetPatientList(ALocID As %String, ALocDesc As %String, AWardID As %String, AWardDesc As %String, ARegNo As %String, APatientName As %String, AStartDate As %String, AEndDate As %String) As %Query(ROWSPEC = "PatientID,EpisodeID,RegNo,PatientName,Sex,Birthday,LocDesc,WardDesc,DoctorDesc,AdmitDateTime,DischDateTime")
{
}

ClassMethod GetPatientListExecute(ByRef qHandle As %Binary, ALocID As %String, ALocDesc As %String, AWardID As %String, AWardDesc As %String, ARegNo As %String, APatientName As %String, AStartDate As %String, AEndDate As %String) As %Status
{
	s repid = $i(^CacheTemp)
	s ind = 1
	s qHandle = $lb(0,repid,0)
	
	/* if you want some debug infomation, just open this closure notes
	s ^CacheTemp("EPRQuality","GetPatientList","ALocID||ALocDesc") = ALocID_"||"_ALocDesc
	s ^CacheTemp("EPRQuality","GetPatientList","AWardID||AWardDesc") = AWardID_"||"_AWardDesc
	s ^CacheTemp("EPRQuality","GetPatientList","ARegNo") = ARegNo
	s ^CacheTemp("EPRQuality","GetPatientList","APatientName") = APatientName
	s ^CacheTemp("EPRQuality","GetPatientList","AStartDate") = AStartDate
	s ^CacheTemp("EPRQuality","GetPatientList","AEndDate") = AEndDate
	*/
	
	s StartDate	= $g(AStartDate)
	s EndDate	= $g(AEndDate)
	s:(StartDate '= "") StartDate = $p(##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(StartDate)," ",1)
	s:(EndDate '= "") EndDate = $p(##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(EndDate)," ",1)
	s:(StartDate = "") StartDate = $p($h,",",1) - 7
	s:(EndDate = "") EndDate = $p($h,",",1)
		
	k ^CacheTemp("EPRQuality","PatientList",repid)
	
	if (ARegNo '= "")
	{
		// Table:	PA_PatMas
		// Global:	^PAPERi("PAPMI_PatNo",$$ALPHAUP({PAPMI_No}),{PAPMI_RowId})
		s PatientID = $o(^PAPERi("PAPMI_PatNo",ARegNo,""))
		q:(PatientID = "") $$$OK
		
		// Table:	PA_Adm
		// Global:	^PAPERdr({PAADM_PAPMI_DR},"ADM",{PAADM_Type},{PAADM_RowID})
		s EpisodeID = ""
		for {
			s EpisodeID = $o(^PAPERdr(PatientID,"ADM","I",EpisodeID))
			q:(EpisodeID = "")
			
			// BuildPatientList(LocID,WardID,EpisodeID,UniqueKey)
			s flag = ..BuildPatientList("","",EpisodeID,repid)
			continue:(flag < 0)	
		}	
	}
	elseif (APatientName '= "")
	{
		// Table: 	PA_PatMas
		// Global:	^PAPERi("PAPER_PatName",$$ALPHAUP({PAPMI_Name}),{PAPMI_RowId})
		s PatientID = ""
		for {
			s PatientID = $o(^PAPERi("PAPER_PatName",APatientName,PatientID))
			q:(PatientID = "")
			
			// Table:	PA_Adm
			// Global:	^PAPERdr({PAADM_PAPMI_DR},"ADM",{PAADM_Type},{PAADM_RowID})
			s EpisodeID = ""
			for {
				s EpisodeID = $o(^PAPERdr(PatientID,"ADM","I",EpisodeID))
				q:(EpisodeID = "")
				
				// BuildPatientList(LocID,WardID,EpisodeID,UniqueKey)
				s flag = ..BuildPatientList("","",EpisodeID,repid)
				continue:(flag < 0)	
			}
		}		
	}
	else
	{
		s WardID = $g(AWardID)
		s:(WardID '= "") WardID = $o(^PAWARD(0,"WARD_LocationDR",WardID,""))
		q:(ALocID = "")&&(WardID = "") $$$OK
				 
		for DischDate = StartDate:1:EndDate {
			s EpisodeID = ""
			for {
				s EpisodeID = $o(^PAADMi("DischDate",DischDate,EpisodeID))
				q:(EpisodeID = "")
							
				s flag = ..BuildPatientList(ALocID,WardID,EpisodeID,repid)
				continue:(flag < 0)
			}
		}
	}
	
	s PaAdmID = ""
	for {
		s PaAdmID = $o(^CacheTemp("EPRQuality","PatientList",repid,PaAdmID))
		q:(PaAdmID = "")
		
		s Data = $g(^CacheTemp("EPRQuality","PatientList",repid,PaAdmID))
		s ^CacheTemp(repid,ind) = Data
		s ind = ind + 1	
	}
	
	k ^CacheTemp("EPRQuality","PatientList",repid)
	
	q $$$OK
}

ClassMethod BuildPatientList(ALocID As %String, AWardID As %String, AEpisodeID As %String, AUniqueKey As %String) As %String
{
	s ret = -1
		
	s objAdm = $g(^PAADM(+AEpisodeID))
	q:(objAdm = "") ret
	
	s AdmitType = $p(objAdm,"^",2)
	q:(AdmitType '= "I") ret

	s VisitStatus =  $p(objAdm,"^",20)
	q:(VisitStatus '= "D") ret
	
	s AdmLocID = $p(objAdm,"^",4)
	q:(ALocID '= "")&&(AdmLocID '= ALocID) ret 
		
	s DischWardID = $p(objAdm,"^",70)
	q:(AWardID '= "")&&(DischWardID '= AWardID) ret
					
	s Papmi = $p(objAdm,"^",1)

	s Name = $p($g(^PAPER(+Papmi,"ALL")),"^",1)
	//q:(APatientName '= "")&&($$ALPHAUP^SSUTIL4(Name)'[APatientName) ret
	
	s RegNo = $p($g(^PAPER(+Papmi,"PAT",1)),"^",1)
	//q:(ARegNo '= "")&&(RegNo '= ARegNo) ret
	
	s Sex = $p($g(^CT("SEX",$p($g(^PAPER(+Papmi,"ALL")),"^",7))),"^",2)
	s Birthday = $p($g(^PAPER(+Papmi,"ALL")),"^",6)
	s:(Birthday '= "") Birthday = $zd(Birthday,3)
	
	s AdmitDate = $p(objAdm,"^",6)
	s AdmitTime = $p(objAdm,"^",7)
	s:(AdmitDate '= "") AdmitDate = $zd(AdmitDate,3)
	s:(AdmitTime '= "") AdmitTime = $zt(AdmitTime,1)
	s AdmitDateTime = AdmitDate_" "_AdmitTime

	s DischDate = $p(objAdm,"^",17)
	s DischTime = $p(objAdm,"^",18)
	s:(DischDate '= "") DischDate = $zd(DischDate,3)
	s:(DischTime '= "") DischTime = $zt(DischDate,1)
	s DischDateTime = DischDate_" "_DischTime
	
	s LocDesc = $p($g(^CTLOC(+AdmLocID)),"^",2)
	s:(LocDesc [ "-") LocDesc = $p(LocDesc,"-",2)
	
	s WardDesc = $p($g(^PAWARD(+DischWardID)),"^",2)
	s WLocID = $p($g(^PAWARD(+DischWardID)),"^",5)
	s:(WLocID '= "") WardDesc = $p($g(^CTLOC(+WLocID)),"^",2)
	s:(WardDesc [ "-") WardDesc = $p(WardDesc,"-",2)
	
	s AdmDocID = $p(objAdm,"^",9)
	s DoctorDesc = $p($g(^CTPCP((+AdmDocID),1)),"^",2)
	
	s ^CacheTemp("EPRQuality","PatientList",AUniqueKey,AEpisodeID) = $lb(Papmi, AEpisodeID, RegNo, Name, Sex, Birthday, LocDesc, WardDesc, DoctorDesc, AdmitDateTime, DischDateTime)
	
	s ret = 1
	q ret
}

ClassMethod GetPatientListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPatientListExecute ]
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
	q $$$OK
}

ClassMethod GetPatientListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPatientListExecute ]
{
	s repid=$list(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

/// Desc:	查询患者列表(手工评分用)
/// Input:	ALocID为科室RowID;
/// 		AWardID为病区RowID;
/// 		ARegNo为患者登记号;
/// 		APatientName为患者姓名;
/// 		AStartDate为入院起始日期;
/// 		AEndDate为入院截止日期;
/// 		AStatus为患者状态(死亡:3;出院:2;在院:1)
/// 		ASetFlag为已设置手工评价患者标识(Y:已设置;N:未设置)
/// Debug:	d ##Class(%ResultSet).RunQuery("EPRservice.Quality.DataGather.AdmInfo","QryPatientList","","","","","","","","")
Query QryPatientList(ALocID As %String, AWardID As %String, ADoctorID As %String, ARegNo As %String, APatientName As %String, AStartDate As %String, AEndDate As %String, AStatus As %String, ASetFlag As %String, AMedicareNo As %String) As %Query(ROWSPEC = "PatientID,EpisodeID,RegNo,PatientName,Sex,Birthday,LocDesc,WardDesc,DoctorDesc,MainDiagnosis,AdmitDate,DischDate,Status,ManualFlag,MedicareNo")
{
}

ClassMethod QryPatientListExecute(ByRef qHandle As %Binary, ALocID As %String, AWardID As %String, ADoctorID As %String, ARegNo As %String, APatientName As %String, AStartDate As %String, AEndDate As %String, AStatus As %String, ASetFlag As %String, AMedicareNo As %String) As %Status
{
	s repid = $i(^CacheTemp)
	s ind = 1
	s qHandle = $lb(0,repid,0)
	
	/* if you want some debug infomation, just open this closure notes
	s ^CacheTempXZX("EPRQuality","QryPatientList","ALocID") = ALocID
	s ^CacheTempXZX("EPRQuality","QryPatientList","AWardID") = AWardID
	s ^CacheTempXZX("EPRQuality","QryPatientList","ARegNo") = ARegNo
	s ^CacheTempXZX("EPRQuality","QryPatientList","APatientName") = APatientName
	s ^CacheTempXZX("EPRQuality","QryPatientList","AStartDate") = AStartDate
	s ^CacheTempXZX("EPRQuality","QryPatientList","AEndDate") = AEndDate
	s ^CacheTempXZX("EPRQuality","QryPatientList","AStatus") = AStatus
	s ^CacheTempXZX("EPRQuality","QryPatientList","ASetFlag") = ASetFlag
	*/

	s StartDate	= $g(AStartDate)
	s EndDate	= $g(AEndDate)
	s:(StartDate '= "") StartDate = $p(##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(StartDate)," ",1)
	s:(EndDate '= "") EndDate = $p(##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(EndDate)," ",1)
	s:(StartDate = "") StartDate = $p($h,",",1) - 7
	s:(EndDate = "") EndDate = $p($h,",",1)
	
	s SetFlag = $g(ASetFlag)
		
	k ^CacheTemp("EPRQuality","QryPatientList",repid)
	
	if (ARegNo '= "")
	{
		// Table:	PA_PatMas
		// Global:	^PAPERi("PAPMI_PatNo",$$ALPHAUP({PAPMI_No}),{PAPMI_RowId})
		s PatientID = $o(^PAPERi("PAPMI_PatNo",ARegNo,""))
		q:(PatientID = "") $$$OK
		
		// Table:	PA_Adm
		// Global:	^PAPERdr({PAADM_PAPMI_DR},"ADM",{PAADM_Type},{PAADM_RowID})
		s EpisodeID = ""
		for {
			s EpisodeID = $o(^PAPERdr(PatientID,"ADM","I",EpisodeID))
			q:(EpisodeID = "")
			
			// BuildQualityPatientList(LocID,WardID,Status,SetFlag,StartDate,EndDate,EpisodeID,UniqueKey)
			s flag = ..BuildQualityPatientList("","",ADoctorID,AStatus,SetFlag,"","",EpisodeID,repid)
			continue:(flag < 0)	
		}	
	}
	elseif (AMedicareNo '= "")
	{
		// Table:	PA_PatMas
		// Global:	^PAPERi("PAPMI_PatNo",$$ALPHAUP({PAPMI_No}),{PAPMI_RowId})
		s PatientID = $o(^PAPERi("Medicare1",AMedicareNo,""))
		q:(PatientID = "") $$$OK
		
		// Table:	PA_Adm
		// Global:	^PAPERdr({PAADM_PAPMI_DR},"ADM",{PAADM_Type},{PAADM_RowID})
		s EpisodeID = ""
		for {
			s EpisodeID = $o(^PAPERdr(PatientID,"ADM","I",EpisodeID))
			q:(EpisodeID = "")
			
			// BuildQualityPatientList(LocID,WardID,Status,SetFlag,StartDate,EndDate,EpisodeID,UniqueKey)
			s flag = ..BuildQualityPatientList("","",ADoctorID,AStatus,SetFlag,"","",EpisodeID,repid)
			continue:(flag < 0)	
		}	
	}
	elseif (APatientName '= "")
	{
		// Table: 	PA_PatMas
		// Global:	^PAPERi("PAPER_PatName",$$ALPHAUP({PAPMI_Name}),{PAPMI_RowId})
		s PatientID = ""
		for {
			s PatientID = $o(^PAPERi("PAPER_PatName",APatientName,PatientID))
			q:(PatientID = "")
			
			// Table:	PA_Adm
			// Global:	^PAPERdr({PAADM_PAPMI_DR},"ADM",{PAADM_Type},{PAADM_RowID})
			s EpisodeID = ""
			for {
				s EpisodeID = $o(^PAPERdr(PatientID,"ADM","I",EpisodeID))
				q:(EpisodeID = "")
				
				// BuildQualityPatientList(LocID,WardID,Status,SetFlag,EpisodeID,UniqueKey)
				s flag = ..BuildQualityPatientList("","",ADoctorID,AStatus,SetFlag,"","",EpisodeID,repid)
				continue:(flag < 0)	
			}
		}		
	}
	else
	{
		s WardID = $g(AWardID)
		s:(WardID '= "") WardID = $o(^PAWARD(0,"WARD_LocationDR",WardID,""))
		q:(ALocID = "")&&(WardID = "") $$$OK
		
		if (AStatus = 0)
		{
			// 所有
			for AdmitDate = StartDate:1:EndDate
			{
				s EpisodeID = ""
				for {
					s EpisodeID = $o(^PAADMi("PAADM_AdmDate",AdmitDate,EpisodeID))
					q:(EpisodeID = "")
								
					s flag = ..BuildQualityPatientList(ALocID,WardID,ADoctorID,AStatus,SetFlag,"","",EpisodeID,repid)
					continue:(flag < 0)
				}
			}
		}
		elseif (AStatus = 1)
		{
			// 在院
			s EpisodeID = ""
			for {
				s EpisodeID = $o(^PAADMi("AdmTypeCurr","I",EpisodeID))
				q:(EpisodeID = "")
				
				s flag = ..BuildQualityPatientList(ALocID,WardID,ADoctorID,AStatus,SetFlag,StartDate,EndDate,EpisodeID,repid)
				continue:(flag < 0)
			}
		}
		else	
		{
			// 出院和死亡
			for DischDate = StartDate:1:EndDate 
			{
				s EpisodeID = ""
				for {
					s EpisodeID = $o(^PAADMi("DischDate",DischDate,EpisodeID))
					q:(EpisodeID = "")
								
					s flag = ..BuildQualityPatientList(ALocID,WardID,ADoctorID,AStatus,SetFlag,"","",EpisodeID,repid)
					continue:(flag < 0)
				}
			}	
		}
	}
	
	//m ^CacheTempXZX = ^CacheTemp("EPRQuality","QryPatientList",repid)
	
	s TmpWard = ""
	for {
		s TmpWard = $o(^CacheTemp("EPRQuality","QryPatientList",repid,TmpWard))
		q:(TmpWard = "")
		
		s TmpDoctor = ""
		for {
			s TmpDoctor = $o(^CacheTemp("EPRQuality","QryPatientList",repid,TmpWard,TmpDoctor))
			q:(TmpDoctor = "")
			
			s PaAdmID = ""
			for {
				s PaAdmID = $o(^CacheTemp("EPRQuality","QryPatientList",repid,TmpWard,TmpDoctor,PaAdmID))
				q:(PaAdmID = "")
				
				s Data = $g(^CacheTemp("EPRQuality","QryPatientList",repid,TmpWard,TmpDoctor,PaAdmID))
				s ^CacheTemp(repid,ind) = Data
				s ind = ind + 1	
			}
		}	
	}
	
	k ^CacheTemp("EPRQuality","QryPatientList",repid)
	
	q $$$OK
}

ClassMethod BuildQualityPatientList(ALocID As %String, AWardID As %String, ADoctorID As %String, AStatus As %String, ASetFlag As %String, AStartDate As %String, AEndDate As %String, AEpisodeID As %String, AUniqueKey As %String) As %String
{
	s ret = -1
		
	s objAdm = $g(^PAADM(+AEpisodeID))
	q:(objAdm = "") ret
	
	// 就诊类别
	s AdmitType = $p(objAdm,"^",2)
	q:(AdmitType '= "I") ret
	
	// 婴儿不建档案
	q:($p(objAdm,"^",75) '= "") ret			
	
	s AdmLocID = $p(objAdm,"^",4)
	q:(ALocID '= "")&&(AdmLocID '= ALocID) ret 
		
	s DischWardID = $p(objAdm,"^",70)
	q:(AWardID '= "")&&(DischWardID '= AWardID) ret
					
	s Papmi = $p(objAdm,"^",1)
	
	s DeathDate = $p(^PAPER(+Papmi,"ALL"),"^",13)
	q:(AStatus = 3)&&(DeathDate = "") ret	//死亡患者
	q:(AStatus = 2)&&(DeathDate '= "") ret	//正常出院患者

	s Name = $p($g(^PAPER(+Papmi,"ALL")),"^",1)
	s RegNo = $p($g(^PAPER(+Papmi,"PAT",1)),"^",1)
	s MedicareNo = $p($g(^PAPER(+Papmi,"PAT",1)),"^",22)
	s Sex = $p($g(^CT("SEX",$p($g(^PAPER(+Papmi,"ALL")),"^",7))),"^",2)
	s Birthday = $p($g(^PAPER(+Papmi,"ALL")),"^",6)
	s:(Birthday '= "") Birthday = $zd(Birthday,3)
	s AdmitDate = $p(objAdm,"^",6)
	q:(AStartDate '= "")&&(AdmitDate < AStartDate) ret
	q:(AEndDate '= "")&&(AdmitDate > AEndDate) ret
	s:(AdmitDate '= "") AdmitDate = $zd(AdmitDate,3)
	s DischDate = $p(objAdm,"^",17)
	s:(DischDate '= "") DischDate = $zd(DischDate,3)
	// 手工设置标志
	s ManualFlag = ##Class(EPRservice.Quality.DataAccess.BOQualitySpotCheck).GetEpisodeManualFlag(AEpisodeID)		
	q:(ASetFlag = "Y")&&(ManualFlag '= "Y") ret
	s LocDesc = $p($g(^CTLOC(+AdmLocID)),"^",2)
	s:(LocDesc [ "-") LocDesc = $p(LocDesc,"-",2)
	s WardDesc = $p($g(^PAWARD(+DischWardID)),"^",2)
	s WLocID = $p($g(^PAWARD(+DischWardID)),"^",5)
	s:(WLocID '= "") WardDesc = $p($g(^CTLOC(+WLocID)),"^",2)
	s:(WardDesc [ "-") WardDesc = $p(WardDesc,"-",2)
	s AdmDocID = $p(objAdm,"^",9)
	q:(ADoctorID '= "")&&(AdmDocID '= ADoctorID) ret 
	s DoctorDesc = $s(AdmDocID '= "" :$p($g(^CTPCP((+AdmDocID),1)),"^",2),1:"未指定")
	
	if (DeathDate '= "")
	{
		s Status = 3	
	}
	else
	{
		if (DischDate '= "")
		{
			s Status = 2	
		}
		else
		{
			s Status = 1	
		}	
	}
	
	s MainDiagnosis = ..GetDiagnosInfo(AEpisodeID)
	s:(MainDiagnosis '= "") MainDiagnosis = $p(MainDiagnosis,"^",3)
	
	s ^CacheTemp("EPRQuality","QryPatientList",AUniqueKey,WardDesc,DoctorDesc,AEpisodeID) = $lb(Papmi, AEpisodeID, RegNo, Name, Sex, Birthday, LocDesc, WardDesc, DoctorDesc, MainDiagnosis, AdmitDate, DischDate, Status, ManualFlag, MedicareNo)
	
	s ret = 1
	q ret
}

ClassMethod QryPatientListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryPatientListExecute ]
{
	s AtEnd = $list(qHandle,1)
 	s repid = $list(qHandle,2)
 	s ind = $list(qHandle,3)
 	s ind = $o(^CacheTemp(repid,ind))
 	if (ind = "") 
 	{	
 		s AtEnd = 1
 		s Row = ""
 		k ^CacheTemp(repid)
 	} 
 	else 
 	{	
 		s Row = ^CacheTemp(repid,ind)
 	}
 	s qHandle = $lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod QryPatientListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryPatientListExecute ]
{
	s repid = $list(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

/// Desc:	获取病案大类费用   
/// Return:	返回代码描述
/// Debug:	w ##Class(EPRservice.Quality.DataGather.AdmInfo).GetTMCFee(201871)
ClassMethod GetTMCFee(AEpisodeID As %String) As %String
{
	s ret=""
	s (InPatFee,CheckTotal,CheckFee,CheckFeeTag,ResultFee,ResultFee2,FeeNum) = ""
	
	s InPatFee = ##Class(EPRservice.HISInterface.PatientInfoAssist).InPatCostTrakCare(AEpisodeID)
	s FeeNum = $l(InPatFee,"!")
	s FeeList = "", tmpFee = ""
	for i = 1:1:FeeNum
	{
		s tmpFee = $p(InPatFee,"!",i)
		if (tmpFee '= "") 
		{
			continue:($p($p(InPatFee,"!",i),"^",2) = "挂号费")||($p($p(InPatFee,"!",i),"^",2) = "无费用") 
			s ResultFee = ResultFee_"\"_$p($p(InPatFee,"!",i),"^",3)
			s ResultFee2 = ResultFee2_"\"_$p($p(InPatFee,"!",i),"^",2)
		}
		
		if (i = 1) {s CheckTotal = $p($p(InPatFee,"!",i),"^",3)} 
		if (i > 1) {s CheckFee = CheckFee + $p($p(InPatFee,"!",i),"^",3)}
	}
	
	s ResultFee = $e(ResultFee,2,$l(ResultFee))
	s ResultFee2 = $e(ResultFee2,2,$l(ResultFee2))
 
	// 费用合计与费用子项审核
	if ($fn(CheckTotal,"",2) '= $fn(CheckFee,"",2))
	{ 
		s CheckFeeTag = "0"
	} 
	else 
	{
		s CheckFeeTag = "1" 
	}
	
	s ResultFee = CheckFeeTag_"^"_ResultFee
	s ret = "1^"_ResultFee_"^"_ResultFee2
	q ret
}

/// Desc: 	获取当前护理级别
/// Input: 	argItmMastDRStr 格式为 ^ItmMastDR1^ItmMastDR2^ItmMastDR3^...^
/// Debug: 	w ##Class(EPRservice.Quality.DataGather.AdmInfo).GetCareClass(201871)
ClassMethod GetCareClass(argAdmId As %String, argItmMastDRStr As %String, argHospital As %String = "") As %String
{
	//&sql(select top 1 * from OE_OrdItem where oeori_oeord_parref ='50594' and OEORI_ItmMast_DR -> arcim_itemcat_dr = '217' and OEORI_ItemStat_DR <>'4' )
	//select * from ARC_ItemCat where arcic_ordcat_dr =''
	//OE_OrdItem	^OEORD({OE_Order.OEORD_RowId},"I",{OEORI_Childsub}) 
	//OE_Order		^OEORD(0,"Adm",{OEORD_Adm_DR},{OEORD_RowId})
	//[ARC_ItmMast]OEORIItmMastDR->[ARC_ItemCat]ARCIM_ItemCat_DR				
	//[ARCIM_ItemCat_DR	1	10]^ARCIM({ARCIM_Subscript},{ARCIM_Version}) 
	//[ARCIM_Desc	1	2]^ARCIM({ARCIM_Subscript},{ARCIM_Version}) 
	//[OEORI_ItemStat_DR	1	13]^OEORD({OE_Order.OEORD_RowId},"I",{OEORI_Childsub})  
	
	s ret = ""
	q:($d(argAdmId) = 0)||(argAdmId = "") ret
	q:($d(argItmMastDRStr)=0)||(argItmMastDRStr="") ret

	s CareClass = ""
	s (OEORDRowId,OEORIChdsub,OEORIItmMastDR,OEORIItmMastDRsub,ARCIMItemCatDR,OEORIItemStatDR,ARCIMDesc) = ""
	
    f  s OEORDRowId = $o(^OEORD(0,"Adm",argAdmId,OEORDRowId)) q:((OEORDRowId = "")||(CareClass '= ""))  d
    . //Get Max OEORIChdsub Add 1
    . s OEORIChdsub = $g(^OEORD(OEORDRowId,"I",0))+1
	. f  s OEORIChdsub = $o(^OEORD(OEORDRowId,"I",OEORIChdsub),-1) q:((OEORIChdsub = "")||(CareClass '= ""))  d  
	  .. //Get OE_OrdItem.OEORI_ItemStat_DR[OEC_OrderStatus]
	  .. s OEORIItemStatDR = $p($g(^OEORD(OEORDRowId,"I",OEORIChdsub,1)),"^",13)
	  .. q:(OEORIItemStatDR = 4)
	  .. //Get OE_OrdItem.OEORI_ItmMast_DR[ARC_ItmMast]
	  .. s OEORIItmMastDR= $p($g(^OEORD(OEORDRowId,"I",OEORIChdsub,1)),"^",2)
	  .. q:(OEORIItmMastDR = "")
	  .. //Check OE_OrdItem.OEORI_ItmMast_DR[ARC_ItmMast] 
	  .. q:($f(argItmMastDRStr,"^"_OEORIItmMastDR_"^") = 0)
	  .. s OEORIItmMastDRsub = $p(OEORIItmMastDR,"||",1)
	  .. s ARCIMDesc = $p($g(^ARCIM(OEORIItmMastDRsub,1,1)),"^",2)
	  .. s CareClass = ARCIMDesc
	  
	q CareClass
}

/// Desc:取转科患者最后一次转科的转入时间
/// Creator:Candyxu
/// Createdate:2013-03-18
/// Input:AEpisodeID 就诊号
/// Output:ret 转入时间
/// Debug: w ##Class(EPRservice.Quality.DataGather.AdmInfo).GetTransLocFirstTime(3)
ClassMethod GetTransLocFirstTime(AEpisodeID As %String) As %String
{
	s ret = ""
	s LocID = $o(^PAADMi("TransLoc",AEpisodeID,""),-1)
	q:(LocID = "") ret
	s RowID = $o(^PAADMi("TransLoc",AEpisodeID,LocID,0))
	if (RowID '= "")
	{
	  s TempDate = $p(^PAADM(AEpisodeID,"TRANS",RowID),"^",1)
	  s TempTime = $p(^PAADM(AEpisodeID,"TRANS",RowID),"^",2) 
	  s ret = ##Class(EPRservice.Quality.CommonHelper).ChangeDateTime(TempDate_" "_TempTime)
	}
	q ret
}

/// creator:YHY
/// createdate:2013-12-11
/// 获取病人就诊类型
ClassMethod GetAdmType(AEpisodeID As %String) As %String
{
	q $p($g(^PAADM(AEpisodeID)),"^",2)
}

/// Desc:       患者所在医院
/// Creator:    Candy
/// CreateDate: 2015-10-29
ClassMethod GetHospital(AEpisodeID As %String) As %String
{
	s result = ""
	q:(AEpisodeID ="") result
	s locId = $P($g(^PAADM(AEpisodeID)),"^",4)
	q:(locId = "") result
	s result = $p(^CTLOC(locId),"^",22)
	q result
}

/// creator:YHY
/// Desc:	出院床位号
ClassMethod DisBed(argAdmId As %String) As %String
{
	q:($d(argAdmId)=0)||(argAdmId="") ""
	s bedwordrowid="",bedchildsub=""
	s bedDR="",dischgbedno=""

    q:(($d(^PAADM(argAdmId))'=1)&&($d(^PAADM(argAdmId))'=11)) ""
    
	s bedDR=$p($g(^PAADM(argAdmId)),"^",73)
	
	q:($d(bedDR)=0)||(bedDR="")||($l(bedDR,"||")<2) ""
	s bedwordrowid = $p(bedDR,"||",1)
	s bedchildsub = $p(bedDR,"||",2)
	
    q:($d(^PAWARD(bedwordrowid,"BED"))'=10) ""
    
	s dischgbedno = $p($g(^PAWARD(bedwordrowid,"BED",bedchildsub)),"^",1)

 	q dischgbedno
}

/// add:    yhy
/// Desc:	住院天数
/// Input:	argAdmId: 病人就诊RowID，argHospital:医院标识
/// Output:	天数
/// Others:	not different from hospitals
/// Debug:  w ##Class(EPRservice.Quality.DataGather.AdmInfo).ResidentDaysAdm()
ClassMethod ResidentDaysAdm(argAdmId As %String, argHospital As %String = "") As %String
{
	q:($d(argAdmId)=0)||(argAdmId="") ""
	//q:($d(argHospital)=0)||(argHospital="") ""
	
	s papmidr="",DeathDateTime="",AdmDateTime="",DisDateTimeMR="",DisDateTime=""
	s admdate="",admtime="",dischgdate="",dischgtime=""
	s residentdays=""

	//取PapmiDR
	q:(($d(^PAADM(argAdmId))'=1)&&($d(^PAADM(argAdmId))'=11)) ""
	s papmidr = ##class(EMRservice.DAL.GetPaAdmDetail).GetPapmiDR(argAdmId)
	
	
	//取入院日期(护士分床)
	s AdmDateTimeInBed=##class(EMRservice.DAL.GetPaAdmDetail).AdmDateTimeInBed(argAdmId)
	if AdmDateTimeInBed'="" 
	{
		s admdate=$p($g(AdmDateTimeInBed),",",1)
	}
	
	//出院日期取值判断  死亡日期->出院日期(统计组)->出院日期(护士结算)
	

	//取死亡日期
	s DeathDateTime=##class(EMRservice.DAL.GetPaAdmDetail).DeathDateTime(papmidr)
	if DeathDateTime'=""
	{
		s dischgdate=$p($g(DeathDateTime),",",1)
	}
		
	if dischgdate=""
	{
		//取出院日期(统计组)
		s DisDateTimeMR=##class(EMRservice.DAL.GetPaAdmDetail).DisDateTimeMR(argAdmId)
		if DisDateTimeMR'="" 
		{
			s dischgdate=$p($g(DisDateTimeMR),",",1)
		}
		
		if dischgdate=""
		{
			//取出院日期(护士结算)
			s DisDateTime=##class(EMRservice.DAL.GetPaAdmDetail).DisDateTime(argAdmId)
			if DisDateTime'="" 
			{
				s dischgdate=$p($g(DisDateTime),",",1)
			}
		}
	}
	
	q:(admdate="") ""
	
	//出院时间为空，默认计算截止当前系统日期的住院天数
	if (dischgdate = "")
	{
		s Systemdatetime = $HOROLOG
		s dischgdate = $p(Systemdatetime,",",1)
	}
	
	//计算住院天数
	s residentdays = ##class(EMRservice.DAL.GetPaAdmDetail).ResidentDays(admdate,dischgdate)

	q residentdays
}

/// Debug:  w ##Class(EPRservice.Quality.DataGather.AdmInfo).GetCurrentLoc()
ClassMethod GetCurrentLoc(AEpisodeID As %String) As %String
{
	s ret=""
	q:(AEpisodeID="") ret
	s objPaAdm = $g(^PAADM(+AEpisodeID))
	q:(objPaAdm = "") ret
	s AdmLocID = $p(objPaAdm,"^",4)
	q:(AdmLocID = "") ret
	s LocDesc = $p($g(^CTLOC(+AdmLocID)),"^",2)
	s:(LocDesc [ "-") LocDesc = $p(LocDesc,"-",2)
	s ret=LocDesc
	q ret
}

/// Debug:  w ##Class(EPRservice.Quality.DataGather.AdmInfo).GetCurrentDoctor()
ClassMethod GetCurrentDoctor(AEpisodeID As %String) As %String
{
	s ret=""
	q:(AEpisodeID="") ret
	s objPaAdm = $g(^PAADM(+AEpisodeID))
	q:(objPaAdm = "") ret
	s AdmDocID = $p(objPaAdm,"^",9)
	s:(AdmDocID = "") AdmDocID = "-1"
	s DoctorDesc = $s(AdmDocID '= -1:$p($g(^CTPCP((+AdmDocID),1)),"^",2),1:"未指定")
	s ret=DoctorDesc
	q ret
}

/// Description:	根据就诊号查询是否有未处理的质控消息
/// Return:         0:无消息  -1:有未处理的消息_"^"_消息内容  1:消息全部处理
/// w ##Class(EPRservice.Quality.DataGather.AdmInfo).GetMessageFlagByEpisodeID(2642374)
ClassMethod GetMessageFlagByEpisodeID(AEpisodeID As %String) As %String
{
	s ret = "0^"
	
	s RowID = "",count=0,result = "",MessageInfo=""
	for 
	{
		s RowID = $o(^DHCEPRQ.EPRSingleMessageI("IdxEpisodeID"," "_AEpisodeID,RowID),-1)
		q:RowID=""
		
		s msgObj = ##class(EPRinstance.EPRSingleMessage).%OpenId(RowID)	
		
		s result = 1
		s MsgStatus = msgObj.ExecuteFlag 
		continue:(MsgStatus="E")
		
		s count = count + 1
		s:(MessageInfo'="") MessageInfo=MessageInfo_$C(10,13)_"("_count_")"_msgObj.Message
		s:(MessageInfo="") MessageInfo="("_count_")"_msgObj.Message
	}
	
	s:((result=1)&&(count>0)) ret = -1_"^"_MessageInfo
	s:((result=1)&&(count=0)) ret = "1^"
	
	q ret
}

/// Creator:	Guanyu
/// CreatDate:	2022-5-27
/// Description:获取患者入院登记证件类型
/// Table:		[SQLUSER.PA_PatMas]PAPMI_CardType_DR -> [SQLUSER.PAC_CardType]CARD_Desc
/// Test: ##Class(EPRservice.Quality.DataGather.AdmInfo).GetPatCardType(2642374)
ClassMethod GetPatCardType(AEpisodeID As %String) As %String
{
	q:($d(AEpisodeID)=0)||(AEpisodeID="") ""
	
	s objPaAdm = $g(^PAADM(+AEpisodeID))
	s PapmiDR = $p(objPaAdm,"^",1)
	q:(($d(^PAPER(PapmiDR,"ALL"))'=1)&&($d(^PAPER(PapmiDR,"ALL"))'=11)) ""
	
	s CardTypeDR="",CardType=""
	s CardTypeDR=$P($g(^PAPER(PapmiDR,"ALL",3)),"^",7)
	q:(CardTypeDR="") ""
	
	s CardType = $p($g(^PAC("CARD",CardTypeDR)),"^",2)
	
	q CardType
}

/// Desc:患者信息过滤、过滤日期、退号、状态、类型
/// Input:EpisodeID 就诊号 StartDate 开始日期 EndDate 结束日期[日期为系统格式] State 状态 AdmType 类型
/// Output:ret=0 参数缺失 ret=1 符合条件 ret=-1 不符合条件
/// Creator:WZL 2022年6月30日
/// Debug:w ##class(EPRservice.Quality.DataGather.AdmInfo).AdmFitter("1935861","2022-06-01","2022-06-10","A","O")
ClassMethod AdmFitter(EpisodeID, LocID, StartDate, EndDate, State, AdmType)
{
	s ret=0
	
	q:(EpisodeID="")||(StartDate="")||(EndDate="")||(State="")||(AdmType="") ret
	
	s ret=-1
	
	//获取患者信息
	s AdmInfo=$g(^PAADM(EpisodeID))
	
	//1.类型过滤
	s Type=$p(AdmInfo,"^",2)
	s:(Type="E") Type="O"  //增加急诊质控统计
	q:(Type'=AdmType) ret
	
	//2.退号患者过滤
	s VisitStatus=$p(AdmInfo,"^",20)
	q:(VisitStatus="C") ret
	
	//3.状态过滤
	q:(State'=VisitStatus) ret
	
	//4.时间过滤
	
	//4.1根据State 判断日期类型，State=A 即判断就诊日期\入院日期 当State=D 即判断出院日期
	s RYDate=$p(AdmInfo,"^",6)  //就诊、入院日期
	s CYDate=$p(AdmInfo,"^",17) //出院日期
	
	q:(State="A")&&((RYDate<StartDate)||(RYDate>EndDate)) ret
	
	q:(State="D")&&((CYDate<StartDate)||(CYDate>EndDate)) ret
	
	//5.科室过滤
	s DeptCode=$p(AdmInfo,"^",4)
	q:(LocID'="")&&(..CheckLoc(LocID,DeptCode)=0) ret
	
	s ret=1
	
	q ret
}

/// Desc:多科室判断，判断locIds 中是否包含locId
/// Input:locIds 多科室ID 以逗号分隔,locId 科室ID
/// Output:ret=0 不包含 ret=1 包含
/// Creator:WZL 2022年6月30日
/// Debug:w ##class(EPRservice.Quality.DataGather.AdmInfo).CheckLoc("65307,263728,3","3")
ClassMethod CheckLoc(locIds, locId)
{
	s ret=0
	
	for i=1:1:$l(locIds,",")
	{
		s locID=$p(locIds,",",i)
		s:(locID=locId) ret=1
		q:(ret=1)
	}
	
	q ret
}

/// Desc:获取一个包含患者基础信息的List
/// Input:PAADMRowID 就诊号
/// Output:ret=$lb(姓名、性别、科室ID、科室名、病案号、登记号、接诊医师ID、接诊医师名、接诊时间、出院时间)
/// Creator:WZL 2022年6月30日
/// Debug:w ##class(EPRservice.Quality.DataGather.AdmInfo).GetAdmBaseInfo(65307)
ClassMethod GetAdmBaseInfo(PAADMRowID)
{
	s ret=$lb()
	
	q:(PAADMRowID="") ret
	
	//患者信息
        s AdmInfo=$g(^PAADM(PAADMRowID))
        
        s Papmi = $p(AdmInfo,"^",1)
		q:(Papmi="") ret
		
        //姓名
        s Name = $p($g(^PAPER(+Papmi,"ALL")),"^",1) 
        
        s PAPMISexDR = $P($g(^PAPER(Papmi,"ALL")),"^",7)
		s Gender = $p($g(^CT("SEX",PAPMISexDR)),"^",2)
        
        //科室
        s LocID=$p(AdmInfo,"^",4)
        
        s LocDesc = $p($g(^CTLOC(LocID)),"^",2)
        //病案号
        s MedicalNo=##Class(DHCWMR.IO.OutService).IGetMrNoByPatientID(Papmi,"I","",.ErrMsg)
        //登记号
        s RegNo = $p($g(^PAPER(+Papmi,"PAT",1)),"^",1)	
        //经治医师
        s DoctorID=$p(AdmInfo,"^",9)
        s DoctorDesc = $s(DoctorID '= -1:$p($g(^CTPCP((+DoctorID),1)),"^",2),1:"未指定")
        //入院日期
        s AdmDate = $p($g(AdmInfo),"^",6) 
		if (AdmDate '= "")
		{
			s AdmDate = $zd(AdmDate,3)
			s AdmDate = ##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Date",AdmDate)
		}

        //出院日期
        s DischDate=$P($g(AdmInfo),"^",17)
		if (DischDate '= "")
		{
			s DischDate = $zd(DischDate,3)
			s DischDate = ##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Date",DischDate)
		}
		
		s ret=$lb(PAADMRowID,Name,Gender,LocID,LocDesc,MedicalNo,RegNo,DoctorID,DoctorDesc,AdmDate,DischDate)
		
		q ret
}

/// 获取患者年龄(岁)
/// Debug:w ##class(EPRservice.Quality.DataGather.AdmInfo).GetPatAge(65307)
ClassMethod GetPatAge(AEpisodeID As %String) As %String
{
	s ret=""
	q:(AEpisodeID="") ret
	s AdmDateTime=##class(EMRservice.HISInterface.PatientInfoAssist).AdmDateTime(AEpisodeID,"")
	if AdmDateTime'="" 
	{
	   // 入院日期内部格式
	   s AdmDate = $P($G(AdmDateTime),",",1)
	   // 入院时间内部格式 
	   s AdmTime = $P($G(AdmDateTime),",",2)
	}
	 
	s PapmiDR = ##Class(EMRservice.HISInterface.PatientInfoAssist).GetPapmiDR(AEpisodeID)
   	//调用年龄统一接口 [Age]
   	s Age=##class(EMRservice.HISInterface.PatientInfoAssist).Age(PapmiDR,AEpisodeID,AdmDate,AdmTime)
   	s:(Age'["岁") Age=0
   	s:(Age'["岁") Age=+Age
	s ret=Age
	q ret
}

/// 济宁第一中心 w ##class(EPRservice.Quality.DataGather.AdmInfo).GetMRDiagnosDesc("1","1")
ClassMethod GetMRDiagnosDesc(Adm As %String, Type As %String = "1") As %String
{
	q:Adm="" ""
	s MRAdm=$p(^PAADM(Adm),"^",61)
	s MRDIAChildsub="",Rtn=""
	f  s MRDIAChildsub=$o(^MR(MRAdm,"DIA",MRDIAChildsub)) q:MRDIAChildsub=""  d                    ;循环就诊诊断表MR_Diagnos的主索引得到ChildSub
	.s MRDIARowid=MRAdm_"||"_MRDIAChildsub
	.s TYPChildsub="0" 
	.f  s TYPChildsub=$o(^MR(MRAdm,"DIA",MRDIAChildsub,"TYP",TYPChildsub)) q:TYPChildsub=""  d     ;再循环MR_DiagType的索引得出ChildSub
	..s MRDiagnosTypeRowId=""
	..s MRDiagnosTypeRowId=$p($g(^MR(MRAdm,"DIA",MRDIAChildsub,"TYP",TYPChildsub)),"^",1)          ;表MRC_DiagnosType的指向
	..q:MRDiagnosTypeRowId=""
	..s MRCDiagnosCode=$p($g(^MRC("DTYP",MRDiagnosTypeRowId)),"^",1)
	..q:MRCDiagnosCode'="PRE"
	..;诊断描述
	..s DiagnosDesc=$g(^MR(MRAdm,"DIA",MRDIAChildsub,"DES",1))
	
	..s DiagnosDesc=##class(web.DHCDocUtil).EvalJSON(DiagnosDesc)
	
	..i Type=1 d
	...i Rtn="" s Rtn=DiagnosDesc
	...e  s Rtn=Rtn_"\"_DiagnosDesc
	..i Type=2 d
	...s MRICDDR=$p(^MR(MRAdm,"DIA",MRDIAChildsub),"^",1)
	...s ICDCode=$p(^MRC("ID",MRICDDR),"^",4)
	...i Rtn="" s Rtn=ICDCode
	...e  s Rtn=Rtn_"\"_ICDCode
	..i Type=3 d
	...s DiagDR=$p(^MR(MRAdm,"DIA",MRDIAChildsub),"^",9)
	...i Rtn="" s Rtn=DiagDR
	...e  s Rtn=Rtn_"\"_DiagDR																			;2  疑诊、  3  确诊		1 待诊
	Quit Rtn
}

/// CreateDate: 	20230112
/// Desction:  		获取危急值列表
/// Input : 		AEpisodeID	就诊号
/// Return:w ##class(EPRservice.Quality.DataGather.AdmInfo).GetCVInfoByEpisodeID(285)
ClassMethod GetCVInfoByEpisodeID(AEpisodeID As %String)
{
	s ret="",info=""
	q:(AEpisodeID="") ret
	s ds=##class(%ResultSet).%New("web.DHCAntService:QryCVByAdm")
	d ds.Execute(AEpisodeID)
	while (ds.Next())
	{
		s repResult=ds.Data("repResult")
		s repDate=ds.Data("repDate")
		s repTime=ds.Data("repTime")
		s:(info'="") info=info_"\\\"_repResult_"^^^"_repDate_" "_repTime
		s:(info="") info=repResult_"^^^"_repDate_" "_repTime
	}
	d ds.Close()
	s ret=info
	q ret
}

/// CreateDate: 	20230112
/// Desction:  		获取会诊列表
/// Input : 		AEpisodeID	就诊号
/// Return:w ##class(EPRservice.Quality.DataGather.AdmInfo).GetPatConsInfoByEpisodeID(285)
ClassMethod GetPatConsInfoByEpisodeID(AEpisodeID As %String)
{
	s ret="",info=""
	q:(AEpisodeID="") ret
	s ds=##class(%ResultSet).%New("web.DHCEMConsInterface:QryPatConsList")
	d ds.Execute(AEpisodeID)
	while (ds.Next())
	{
		s CsLocDesc=ds.Data("CsLocDesc")
		s Opinion=ds.Data("Opinion")
		s CstNDate=ds.Data("CstNDate")
		s CstNTime=ds.Data("CstNTime")
		s:(info'="") info=info_"\"_CstNDate_" "_CstNTime_"^"_Opinion_"^"_CsLocDesc
		s:(info="") info=CstNDate_" "_CstNTime_"^"_Opinion_"^"_CsLocDesc
	}
	d ds.Close()
	s ret=info
	q ret
}

/// CreateDate: 	20230112
/// Desction:  		获取MDT会诊列表
/// Input : 		AEpisodeID	就诊号
/// Return:w ##class(EPRservice.Quality.DataGather.AdmInfo).GetPatMDTConsInfoByEpisodeID(285)
ClassMethod GetPatMDTConsInfoByEpisodeID(AEpisodeID As %String)
{
	s ret="",info=""
	q:(AEpisodeID="") ret
	s ds=##class(%ResultSet).%New("web.DHCMDTInterface:QryPatMDTConsList")
	d ds.Execute(AEpisodeID)
	while (ds.Next())
	{
		s DisGroup=ds.Data("DisGroup")
		s CstNDate=ds.Data("CstNDate")
		s CstNTime=ds.Data("CstNTime")
		s:(info'="") info=info_"\"_CstNDate_" "_CstNTime_"^"_DisGroup
		s:(info="") info=CstNDate_" "_CstNTime_"^"_DisGroup
	}
	d ds.Close()
	s ret=info
	q ret
}

/// CreateDate: 	20230112
/// Desction:  		获取检验结果明细
/// Input : 		AEpisodeID	就诊号
/// Return:w ##class(EPRservice.Quality.DataGather.AdmInfo).GetLisInfoByEpisodeID(285)
ClassMethod GetLisInfoByEpisodeID(AEpisodeID As %String)
{
	s ret="",info=""
	q:(AEpisodeID="") ret
	s ds=##class(%ResultSet).%New("web.DHCENS.STBLL.Method.PostReportInfo:SelectLISItemListByDate")
	d ds.Execute(AEpisodeID,"","")
	while (ds.Next())
	{
		s OEordItemRowID=ds.Data("OEordItemRowID")
		
		s ds1=##class(%ResultSet).%New("web.DHCENS.STBLL.Method.PostReportInfo:SelectLISReportByOeordID")
		d ds1.Execute(OEordItemRowID)
		while (ds1.Next())
		{
			s ItemDesc=	ds1.Data("ItemDesc")
			s ItemResult=ds1.Data("ItemResult")
			s:(info'="") info=info_"\"_ItemDesc_"^"_ItemResult
			s:(info="") info=ItemDesc_"^"_ItemResult
		}
		d ds1.Close()
		
	}
	d ds.Close()
	s ret=info
	q ret
}

/// CreateDate: 	20230112
/// Desction:  		获取检验报告结果
/// Input : 		AEpisodeID	就诊号
/// 				AType		N数字,X文本,S列表,A血型ABO,R血型RH,M微生物
/// Return:w ##class(EPRservice.Quality.DataGather.AdmInfo).GetTSInfoByEpisodeID(285)
ClassMethod GetTSInfoByEpisodeID(AEpisodeID As %String, AType As %String = "")
{
	s ret="",info=""
	q:(AEpisodeID="") ret
	s ds=##class(%ResultSet).%New("web.DHCENS.STBLL.Method.PostReportInfo:SelectLISItemListByDate")
	d ds.Execute(AEpisodeID,"","")
	while (ds.Next())
	{
		s VisitNumberReportDR=ds.Data("VisitNumberReportDR")
		s OEordItemDesc=ds.Data("OEordItemDesc")
		s ds1=##class(%ResultSet).%New("web.DHCENS.STBLL.Method.PostReportInfo:QryTSInfo")
		d ds1.Execute(VisitNumberReportDR)
		while (ds1.Next())
		{
			s ResultFormat=ds1.Data("ResultFormat")
			continue:(AType'="")&&(AType'=ResultFormat)
			s TestCodeName=ds1.Data("TestCodeName")
			s AuthDate=$zd(ds1.Data("AuthDate"),3)
			s AuthTime=$zt(ds1.Data("AuthTime"),1)
			s:(info'="") info=info_"\"_OEordItemDesc_"^"_AuthDate_" "_AuthTime
			s:(info="") info=OEordItemDesc_"^"_AuthDate_" "_AuthTime
			
		}
		d ds1.Close()
	}
	d ds.Close()
	s ret=info
	q ret
}

/// CreateDate: 	20230116
/// Desction:  		获取检查医嘱列表
/// Input : 		AEpisodeID	就诊号
/// 					AType		EKG:心电，US:超声，PACS:放射，ES:内镜，PIS:病理
/// Return:w ##class(EPRservice.Quality.DataGather.AdmInfo).GetPACSInfoByEpisodeID(285)
ClassMethod GetPACSInfoByEpisodeID(AEpisodeID As %String, AType As %String = "")
{
	s ret="",info=""
	q:(AEpisodeID="") ret
	s ds=##class(%ResultSet).%New("web.DHCENS.STBLL.Method.PostReportInfo:SelectPACSItemListByDate")
	d ds.Execute(AEpisodeID,"","")
	while (ds.Next())
	{
		s RISRSysCode=ds.Data("RISRSysCode")
		continue:(AType'="")&&(AType'=RISRSysCode)
		s RrtDate=ds.Data("RrtDate")
		s RrtTime=ds.Data("RrtTime")
		s ItemName=ds.Data("ItemName")
		s:(info'="") info=info_"\"_ItemName_"^"_RrtDate_" "_RrtTime
		s:(info="") info=ItemName_"^"_RrtDate_" "_RrtTime
	}
	s ret=info
	q ret
}

/// CreateDate: 	20230117
/// Desction:  		根据医嘱子类code获取检查报告信息
/// Input : 		AEpisodeID	就诊号
/// 				ARCCode		医嘱子类code
/// Return:w ##class(EPRservice.Quality.DataGather.AdmInfo).GetLisInfoByARCCodeEpisodeID(1708,"检查CT\检查MRI")
ClassMethod GetLisInfoByARCCodeEpisodeID(AEpisodeID As %String, ARCCode As %String)
{
	s ret="",info=""
    q:(AEpisodeID="")||(ARCCode="") ret
    s lstARCCode = ##Class(EPRservice.Quality.CommonHelper).GetListFromString(ARCCode,"\")
    s ds=##class(%ResultSet).%New("web.DHCENS.STBLL.Method.PostReportInfo:SelectPACSItemListByDate")
    d ds.Execute(AEpisodeID,"","")
    while (ds.Next())
    {
        s OEordItemRowID=ds.Data("OEOrdItemDR")
        s ord=$p(OEordItemRowID,"||",1)
        s sub=$p(OEordItemRowID,"||",2)
        s Arcim=$p($g(^OEORD(ord,"I",sub,1)),"^",2)
        continue:Arcim=""
        s ItemCatDR=$p($g(^ARCIM(+Arcim,$p(Arcim,"||",2),1)),"^",10)
        s OrderCatCode=$P(^ARC("IC",ItemCatDR),"^",1)
        continue:($listlength(lstARCCode) > 0)&&($listfind(lstARCCode,OrderCatCode) = 0)
        s OEordItemDesc=ds.Data("ItemName")
        s AuthorisationDate=ds.Data("RrtDate")
        s AuthorisationTime=ds.Data("RrtTime")
        s:(info'="") info=info_"\"_OEordItemDesc_"^"_AuthorisationDate_" "_AuthorisationTime
		s:(info="") info=OEordItemDesc_"^"_AuthorisationDate_" "_AuthorisationTime
    }
    d ds.Close()
    s ret=info
    q ret
}

/// CreateDate: 	20230201
/// Desction:  		获取检查报告诊断意见信息
/// Input : 		AEpisodeID	就诊号
/// Return:w ##class(EPRservice.Quality.DataGather.AdmInfo).GetLisDocDescByEpisodeID(285)
ClassMethod GetLisDocDescByEpisodeID(AEpisodeID As %String)
{
	s ret="",info=""
	q:(AEpisodeID="") ret
	s ds=##class(%ResultSet).%New("web.DHCENS.STBLL.Method.PostReportInfo:SelectPACSItemListByDate")
	d ds.Execute(AEpisodeID,"","")
	while (ds.Next())
	{
		s OEOrdItemDR=ds.Data("OEOrdItemDR")		
		s ds1=##class(%ResultSet).%New("web.DHCENS.STBLL.Method.PostReportInfo:SelectReportByOeordID")
		d ds1.Execute(OEOrdItemDR)
		while (ds1.Next())
		{
			s strResult=ds1.Data("strResult")			
			s:(info'="") info=info_"\"_strResult
			s:(info="") info=strResult
			
		}
		d ds1.Close()
	}
	d ds.Close()
	s ret=info
	q ret
}

/// CTOR: QP
/// SENO: F0015
/// DATE: 2023-02-15
/// DESC: 获取抗菌药物名称、抗菌药物开立时间【病历内涵质控】
/// IN  : 就诊ID
/// OUT : 抗菌药物1^2022-01-01 00:00:00\抗菌药物2^2022-02-01 00:00:00
/// EXEC: w ##class(DHCAnt.Serve.ComOut).GetAntUseTimeByAdm("195")
ClassMethod GetAntUseTimeByAdm(admId)
{
	Q:admId="" ""
	s oeori=""
	s mRtn=""
	for {
		s oeori=$o(^DAUP("ADM",admId,oeori))
		q:oeori=""
		continue:##class(DHCAnt.KSS.Common.Method).FilterOrdStatus(oeori)=1
		s OEORISttDat=$p(^OEORD(+oeori,"I",$p(oeori,"||",2),1),"^",9)
		s OEORISttTim=$p(^OEORD(+oeori,"I",$p(oeori,"||",2),1),"^",10)
		s arcimDr=$p(^OEORD(+oeori,"I",$p(oeori,"||",2),1),"^",2)
		s arcimDesc=$p(^ARCIM(+arcimDr,$p(arcimDr,"||",2),1),"^",2)
		s OEORISttDat=##class(websys.Conversions).DateLogicalToHtml(OEORISttDat)
		s OEORISttTim=$zt(OEORISttTim,1)
		s row=arcimDesc_"^"_OEORISttDat_" "_OEORISttTim
		i mRtn="" s mRtn=row
		e  s mRtn=mRtn_"\"_row
	}
	Q mRtn
}

Storage Default
{
<Data name="AdmInfoDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^EPRservice.QualityAF2.AdmInfoD</DataLocation>
<DefaultData>AdmInfoDefaultData</DefaultData>
<IdLocation>^EPRservice.QualityAF2.AdmInfoD</IdLocation>
<IndexLocation>^EPRservice.QualityAF2.AdmInfoI</IndexLocation>
<StreamLocation>^EPRservice.QualityAF2.AdmInfoS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
