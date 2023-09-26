/// 获取交叉质控患者（出院）
Class EPRservice.Quality.GetAdmList Extends %RegisteredObject
{

/// creater:  WZLang
/// Create Date:	20210324
/// Description:	患者病历抽查
/// Return:         患者基本信息  StartDate,EndDate,AdmStatus,selectPro,specialAdm
/// Debug:    d ##class(%ResultSet).RunQuery("EPRservice.Quality.GetAdmList","GetAdmList","2021-10-16","2021-11-16","I","1","","","D","")
Query GetAdmList(StartDate As %Date, EndDate As %Date, AdmType As %String, Proportion As %String, LocId As %String, extractNums As %String = "", AdmStatus As %String = "", SpecialAdm As %String = "", HOSPID = "") As %Query(ROWSPEC = "PAPMIDR,PAADMRowID,PAPMIName,PAPMISex,PAAdmDate,PAAdmTime,PAADMDocCode,AdmDateTime,MainDiagnos,AdmRecordStatus,Age,length,nums,LocName,ResidentDays,RegNo,MedicareNumber,DischDate,CheckType,AssignedFlag,SpecialInfo")
{
}

ClassMethod GetAdmListExecute(ByRef qHandle As %Binary, StartDate As %Date, EndDate As %Date, AdmType As %String, Proportion As %String, LocId As %String, extractNums As %String = "", AdmStatus As %String = "", SpecialAdm As %String = "", HOSPID = "") As %Status
{
		
	set repid=$I(^CacheTemp)
	set ind = 1
	set qHandle = $lb(0,repid,0)
	s MedicareNo = ""
	s PAADMRowID = ""
	s AdmDate = ""
	
	s:(LocId="") LocId="all"
	
	s LocNums=0  //科室抽查数量
	
	k ^CacheTemp("EPRQuality","PaAdmList")
	k ^tempquality  
	k ^tempSelect("PAADMRowID")
	
	if ((StartDate '= "")&&(EndDate'= ""))
	{
		// 所有的数据条数
		s numDate = 0
		//出院患者按日期查询
		s StDate = $p(##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(StartDate)," ",1)
	    s endDate = $p(##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(EndDate)," ",1)
		for i = StDate:1:endDate 
		{
			//出院患者按出院日期查询
			if (AdmStatus="D")
			{
				s PAADMRowID=""
				for
				{
					s PAADMRowID=$o(^PAADMi("DischDate",i,PAADMRowID))
					q:(PAADMRowID="")
					
					s filtter=..AdmFiltter(PAADMRowID, AdmType, LocId, AdmStatus,SpecialAdm,HOSPID)
					continue:(filtter=-1)
					s numDate = numDate + 1     // 总数
					
					d storeData
				}
				continue
			}
			
			s AdmTime = ""
			for {	
				s AdmTime = $o(^PAADMi("TypeDate",AdmType,i,AdmTime))
				
				q:(AdmTime="")
				
				s PAADMRowID=""
				
				for
				{
					s PAADMRowID=$o(^PAADMi("TypeDate",AdmType,i,AdmTime,PAADMRowID))
					
					q:(PAADMRowID="")
					
					s filtter=..AdmFiltter(PAADMRowID, AdmType, LocId, AdmStatus,SpecialAdm,HOSPID)
					
					continue:(filtter=-1)
					
					s numDate = numDate + 1     // 总数
					d storeData
				}
				
				
				
			}
			continue:(AdmType="I") //如果是门诊病历，则再查询急诊病历,住院病历则不再检查
			for {	
				s AdmTime = $o(^PAADMi("TypeDate","E",i,AdmTime))
				
				q:(AdmTime="")
				
				s PAADMRowID=""
				
				for
				{
					s PAADMRowID=$o(^PAADMi("TypeDate","E",i,AdmTime,PAADMRowID))
					
					q:(PAADMRowID="")
					
					s filtter=..AdmFiltter(PAADMRowID, AdmType, LocId, AdmStatus,SpecialAdm,HOSPID)
					continue:(filtter=-1)
					
					s numDate = numDate + 1     // 总数
					d storeData
				}
				
				
				
			}
			
		}			
	}
	
	/*if SpecialAdm'=""
	{
		//抽取重点患者，设置比例为100%
		s Proportion=1,extractNums=""
	}*/
	
	d AdmExtract
	
	
	s extractInfo=Proportion //抽取信息
	s:(Proportion="") extractInfo=extractNums
	
	s extractType=AdmType_AdmStatus
	
	s:(extractType="ID") extractType="CQC"
	
	s ^tempSelect("ExtractInfo")=extractType_"^"_StartDate_"^"_EndDate_"^"_LocId_"^"_extractInfo_"^"_LocNums_"^"_""
	
	// 按科室患者名称、医疗组名称
	s LocName = ""
    for {
		s LocName = $o(^CacheTemp("EPRQuality","PaAdmList",LocName))
		q:(LocName = "")
		s tmpAdmID= ""
		for {
			s tmpAdmID = $o(^CacheTemp("EPRQuality","PaAdmList",LocName,tmpAdmID))
			q:(tmpAdmID = "")
			q:(tmpAdmID="")
			//continue:(Data="")
			s Data=$g(^CacheTemp("EPRQuality","PaAdmList",LocName,tmpAdmID))
			s ^CacheTemp(repid,ind) = Data
			s ind = ind + 1		
		}
	}
	 
	k ^CacheTemp("EPRQuality","PaAdmList")
	Quit $$$OK
	
	
storeData()  //每个查询到的患者按着科室存储
	///此患者是否分配过
	s AssignedFlag=##class(EPRservice.Quality.DataAccess.AssignInfo).GetAssignState(PAADMRowID)
	q:(AssignedFlag="Y")  //分配过的不再抽取
	s mCurrRow = $g(^PAADM(PAADMRowID))
	//s mucpleader=##class(DHCCDYZone.DHCDoc.Method.DOCMethod).GetMUCPLeaderByAdm(PAADMRowID) //或取患者对应医疗组
	//就诊科室
	s PAADMDepCode=$p($g(mCurrRow),"^",4)
	
	q:(PAADMDepCode="")
	
	s PAAdmDepCodeDR = $p($g(^CTLOC(PAADMDepCode)),"^",2)
	s:(PAAdmDepCodeDR["-") PAAdmDepCodeDR = $p(PAAdmDepCodeDR,"-",2) //科室名称
	q:(PAAdmDepCodeDR="")
	
	s ^tempquality("quality",PAAdmDepCodeDR)=$g(^tempquality("quality",PAAdmDepCodeDR))_"^"_PAADMRowID
	
	Quit



    //******* 病历抽取 *********//
AdmExtract()
	// 随机抽取，并且把抽到的患者（不重复）放到临时 Global 并且在页面显示
	s NodeName = ""
	for{
		s NodeName = $o(^tempquality("quality",NodeName))
		q:NodeName=""
		s ^tempquality("quality",NodeName) = $e(^tempquality("quality",NodeName),2,$l(^tempquality("quality",NodeName)))
		s length = $l(^tempquality("quality",NodeName),"^")  //每个科室的患者数量
		
		continue:(length=0)
		
		// 存放抽取患者位置的临时global
		
		s LocNums=0,nums=0
		
		if (Proportion'="")&&(Proportion'=0)  //计算出比例对应的数量
		{
			s nums=$j(Proportion*length,1,0)
		
			s:(nums=0)&&(Proportion*length>0) nums=1
		
			s:(length<Proportion) nums=length
		
			s LocNums=nums	
		}else  //如果抽取数量确定，则使用具体的抽取数量
		{
			s nums=extractNums
			s:(length<extractNums) nums=length  //如果科室患者数小于抽取数，则使用科室患者数
		}
		
		
		
		s number2 = 0  //抽取数量
		for
		{
			q:(number2=nums)  //抽取指定数量后退出或者抽完本医疗组数量时退出
			
			s locaPAADMRowID = $r(length)+1  //随机数
			
			s PAADMRowID=$p(^tempquality("quality",NodeName),"^",locaPAADMRowID)
			
			if ($g(^tempquality("extract",NodeName,PAADMRowID))="")
			{
				s number2=number2+1
				
				s ^tempquality("extract",NodeName,PAADMRowID)=number2	
				
				s mCurrRow=$g(^PAADM(PAADMRowID))
				
				s PAADMDepCode=$p($g(mCurrRow),"^",4)
				
				if (PAADMDepCode'="")
				{
					s PAADMDepCodeDR=$p($g(^CTLOC(PAADMDepCode)),"^",2)
					s PAADMDepCodeDR=$p(PAADMDepCodeDR,"-",2)
				}else
				{
					s PAADMDepCodeDR="无"
				}
				
				
				d outputrow
			}
				
			
		}
		
		k ^tempquality("extract",NodeName)
		//s ^tempquality("extract",doctorCode) = $e(^tempquality("extract",doctorCode),2,$l(^tempquality("extract",doctorCode)))	
	}
	
	QUIT

	
	
	
outputrow


	s PAPMIDR = $p($g(mCurrRow),"^",1)   //登记号  患者基本信息表rowid
	s PAPMIName = $p($g(^PAPER(PAPMIDR,"ALL")),"^",1)
	
	s OBJPat=##class(User.PAPatMas).%OpenId(PAPMIDR)
	s RegNo=OBJPat.PAPMINo //登记号
	//s MedicareNumber=$P($g(^PAPER(PAPMIDR,"PAT",1)),"^",22) //住院号
	
	//改用从接口取病案号
	s MedicareNumber=##Class(MA.IPMR.IO.OutService).GetMrNoByEpisodeID(PAADMRowID,.ErrMsg)
	
	s LocName = $p($g(^CTLOC(PAADMDepCode)),"^",2) //科室
	
	
	s PAPMISexDR = $P($g(^PAPER(PAPMIDR,"ALL")),"^",7)
	s PAPMISex = $p($g(^CT("SEX",PAPMISexDR)),"^",2)  //性别
	
	
	//入院时间
	s PAAdmTime = $p($g(mCurrRow),"^",7)
	if (PAAdmTime '= "")
	{
		s PAAdmTime = $zt(PAAdmTime,3)
		s PAAdmTime = ##class(EMRservice.Tools.Tool).GetHISStandardDateTimeFormat("ChangeToFormat","Time",PAAdmTime)
	}
	s PAAdmDate = $p($g(mCurrRow),"^",6)
	if (PAAdmDate '= "")
	{
		s PAAdmDate = $zd(PAAdmDate,3)
		s PAAdmDate = ##class(EMRservice.Tools.Tool).GetHISStandardDateTimeFormat("ChangeToFormat","Date",PAAdmDate)
	}
	
	//出院时间
	s DischDate = $p($g(mCurrRow),"^",17)
	if (DischDate '= "")
	{
		s DischDate = $zd(DischDate,3)
		s DischDate = ##class(EMRservice.Tools.Tool).GetHISStandardDateTimeFormat("ChangeToFormat","Date",DischDate)
	}
	
	
	
	// 以下是获取经治医生
	s PAADMDocCode=$p($g(mCurrRow),"^",9)
	s:(PAADMDocCode'="") DocCode = $o(^SSU("SSUSR",0,"CTPCP",PAADMDocCode,""))
	//q:((ADocID'="")&&(DocCode '=ADocID))
	if (PAADMDocCode '= "")
	{
		s PAAdmDocCodeDR = $p($g(^CTPCP(PAADMDocCode,1)),"^",2)
	}
	else
	{
		s PAAdmDocCodeDR = "无"
	}
	s AdmDate=$P($g(^PAADM(PAADMRowID)),"^",6)
	s AdmTime=$P($g(^PAADM(PAADMRowID)),"^",7)
	s AdmDateTime=$zd(AdmDate,3)
	s AdmDateTime = ##class(EMRservice.Tools.Tool).GetHISStandardDateTimeFormat("ChangeToFormat","Date",AdmDateTime)
	
	
	
	//主要诊断
	s MainDiagnos = ##class(EMRservice.HISInterface.PatientInfoAssist).DiagnosInfo(PAADMRowID)
	if (MainDiagnos = "")
    {
        s MainDiagnos = ##class(EMRservice.Ajax.patientInfo).getOPdiagnosis(PAADMRowID)
        //s MainDiagnos = $P(MainDiagnos,"^",3)
    }
	if (MainDiagnos '= "")
	{	
		//s MainDiagnos = $P(MainDiagnos,"^",3)
		//s MainDiagnos = $tr(MainDiagnos,"'","\'")
		s Diagnoses=""
		//诊断拼接
		for diagIndex=1:1:$l(MainDiagnos,"$")
		{
			s tmpDiagnose=$p(MainDiagnos,"$",diagIndex)
			
			s diagnose=$p(tmpDiagnose,"^",3)
			
			s:(Diagnoses'="") Diagnoses=Diagnoses_","_diagnose
			s:(Diagnoses="") Diagnoses=diagnose
		}
		
		s MainDiagnos=Diagnoses
	}
	s AssignedFlag=##class(EPRservice.Quality.DataAccess.AssignInfo).CheckAdmIsAssigned(PAADMRowID) 
	
	s Age  = ##Class(EPRservice.Quality.DataGather.AdmInfo).Age(PAPMIDR,PAADMRowID,"","")
	
	s extractPro=Proportion
	s ResidentDays = ##Class(EPRservice.Quality.DataGather.AdmInfo).ResidentDaysAdm(PAADMRowID,"")
	//q:(ResidentDays>MaxResidentDays)&&(MaxResidentDays'="")
	s SpecialInfo=..CheckSpecialType(PAADMRowID,"","Y")
	s ^CacheTemp("EPRQuality","PaAdmList",LocName,PAADMRowID) = $LB(PAPMIDR,PAADMRowID,PAPMIName,PAPMISex,PAAdmDate,PAAdmTime,PAAdmDocCodeDR,AdmDateTime,MainDiagnos,AdmRecordStatus,Age,length,nums,LocName,ResidentDays,RegNo,MedicareNumber,DischDate,AdmType_AdmStatus,AssignedFlag,SpecialInfo)
	
	s ^tempSelect("PAADMRowID")=$g(^tempSelect("PAADMRowID"))_PAADMRowID_"^"
	
	Quit
}

ClassMethod GetAdmListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAdmListExecute ]
{
	Set repid = $LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetAdmListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAdmListExecute ]
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

/// Desc交叉质控抽查重点患者筛选方法，多种类型患者筛选为“或”的关系，即TypeA||TypeB
/// EpisodeID 就诊号 SpecialType 重点患者
/// ret 1 即通过 0 不通过
ClassMethod CheckSpecialType(EpisodeID, SpecialType, Info = "N")
{
	s ret=0,deathFLag=0,SpecialInfo=""
	q:(EpisodeID="")||((SpecialType="")&&(Info="")) ret
	
	s ResidentDays = ##Class(EPRservice.Quality.DataGather.AdmInfo).ResidentDaysAdm(EpisodeID,"")
	//住院超31天
	s flagSpecialAdm=0
	if (SpecialType["OverAdm"){
		s:(+ResidentDays>31) flagSpecialAdm=1
	}
	
	s TerminallyIll = ##Class(EPRservice.Quality.DataGather.OrderInfo).GetOrderIDsByTypeCode("TerminallyIll")
	s DiseaseSeve = ##Class(EPRservice.Quality.DataGather.OrderInfo).GetOrderIDsByTypeCode("DiseaseSeve")
	s BWYZ = ##Class(EPRservice.Quality.DataGather.OrderInfo).GetOrdItemTime(EpisodeID,TerminallyIll,"")
	s BZYZ = ##Class(EPRservice.Quality.DataGather.OrderInfo).GetOrdItemTime(EpisodeID,DiseaseSeve,"")
	
	if (SpecialType["TerminallyIll"){
		s:(BWYZ '="") flagSpecialAdm=1
	}
	if (SpecialType["DiseaseSeve"){
		s:(BZYZ '= "") flagSpecialAdm=1
	}
	s ReqFormCountNum = ##class(DHCLIS.DHCBloodInterface).GetReqFormCountNum(EpisodeID)
	if (SpecialType["SXHZ"){		
		s:(ReqFormCountNum'=0) flagSpecialAdm=1
	}
	s OPArrangesEnd=##Class(EPRservice.Quality.DataGather.OrderInfo).GetOrdItemTime(EpisodeID,"6916||1","")
	if (SpecialType["SSHZ"){		
		s:(OPArrangesEnd'="") flagSpecialAdm=1
	}
	s hzyz = ##Class(EPRservice.Quality.DataGather.OrderInfo).GetOrdItemTime(EpisodeID,"6917||1","")
	if (SpecialType["HZHZ"){		
		s:(hzyz'="") flagSpecialAdm=1
	}
	s:flagSpecialAdm=1 ret=1
	if (Info="Y")
	{
		s:(+ResidentDays>31) SpecialInfo=SpecialInfo_"住院超过31天 "
		s:(BWYZ '="") SpecialInfo=SpecialInfo_"病危 "
		s:(BZYZ '="") SpecialInfo=SpecialInfo_"病重 "
		s:(ReqFormCountNum'=0) SpecialInfo=SpecialInfo_"输血 "
		s:(OPArrangesEnd'="") SpecialInfo=SpecialInfo_"手术 "
		s:(hzyz'="") SpecialInfo=SpecialInfo_"会诊 "
		S ret=SpecialInfo
	}	
	q ret
}

/// Desc:根据条件过滤患者
/// Date:2020-03-15
/// Input:EpisodeID 就诊号 AdmType 病历类型 LocId 科室ID AdmStatus 住院状态 SpecialAdmFiltter 重点病历类型
/// Output 1 通过,0 不通过
ClassMethod AdmFiltter(EpisodeID As %String, AdmType As %String = "", LocId As %String = "", AdmStatus As %String = "", SpecialAdmFiltter As %String = "", HOSPID = "")
{
	s ret=-1
	q:(EpisodeID="") "参数错误"
	//过滤非住院患者
	s type=$p(^PAADM(EpisodeID),"^",2)
	q:(AdmType'=type)&&(AdmType'="") ret
	//科室
	s PAADMDepCode=$p(^PAADM(EpisodeID),"^",4)
	s objCtLoc=$g(^CTLOC(+PAADMDepCode))
	q:('..CheckLoc(LocId,PAADMDepCode))&&(LocId'="all")&&(LocId'="") ret
	s HspID = $P(objCtLoc,"^",22)
	q:(HspID'="")&&(HOSPID'="")&&(HOSPID'=HspID) ret
	s PAAdmStatus=$P($g(^PAADM(EpisodeID)),"^",20)  //就诊状态
	
	q:(AdmStatus'= PAAdmStatus)&&(AdmStatus'="") ret  //过滤非在院患者
	
	
	s xse = $P($g(^PAADM(EpisodeID)),"^",75)
	q:(xse'="") ret //过滤新生儿
	//重点患者
	s specialAdm=1
	s:(SpecialAdmFiltter'="") specialAdm=..CheckSpecialType(EpisodeID,SpecialAdmFiltter)
	
	q:(specialAdm'=1) ret
	
	s ret=1
	
	q ret
}

/// w ##class(EPRservice.Quality.GetAdmList).CheckLoc("3,6,7,8","36")
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

}
