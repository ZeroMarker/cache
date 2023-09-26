/// ClassName:    DtPortal.MD.MD13Infectious
/// Description:  传染病分布服务
/// Creator：     chengpeng
/// CreatDate:    2014-09-29
Class DtPortal.MD.MD13Infectious Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// Creator：     chengpeng
/// CreatDate：   2014-09-29
/// Description:  查询一段时间门诊或住院传染病报卡ID集合
/// Table：       DHCMed.EPD.Epidemic
/// Input：       StartDate   :  开始时间
/// Input：       EndDate     :  结束时间
/// Input：       PaadmType   :  就诊类型
/// Return：      EpiID^      :  DHCMed.EPD.Epidemic.ID集合，以"^"分割
/// w ##class(DtPortal.MD.MD13Infectious).FindEPDPatList("2018-01-01","2018-12-31","I","2")
ClassMethod FindEPDPatList(StartDate As %String, EndDate As %String, PaadmType As %String, HospitalId As %String = "") As %String
{
	set return=""
	set:StartDate["-" StartDate=$zdh(StartDate,3)
	set:EndDate["-" EndDate=$zdh(EndDate,3)

	For aDate=StartDate:1:EndDate
	{
		set EpiID=""
		For
		{
			set EpiID=$o(^DHCMed.EPDi("EPD","0","RepDate",aDate,EpiID))
			Q:EpiID=""
			set EpiStr=$g(^DHCMed.EPD("EPD",+EpiID))
			set EpdStatus=$p(EpiStr,"^",15)
			continue:PaadmType'=$p(EpiStr,"^",14)
			continue:EpdStatus=5
			continue:EpdStatus=6
			continue:EpdStatus=7
			continue:EpdStatus=8
			
			set PatType=$p(^DHCMed.EPD("EPD",EpiID),"^",14)
			set EpisodeID=$p(^DHCMed.EPD("EPD",EpiID),"^",29)
			continue:EpisodeID=""
			
			set ICD=$p(^DHCMed.EPD("EPD",EpiID),"^",5)		
			continue:+ICD=0	
			set WardID=$p(^PAADM(EpisodeID),"^",4)
			continue:WardID=""
			set hospID=$p($g(^CTLOC(WardID)),"^",22)
			i HospitalId'=""  continue:hospID'=HospitalId
			
			if (return="")
			{
				set return=EpiID
			}else
			{
				set return=return_"^"_EpiID
			}
		}
	}
	q return
}

/// Creator：     chengpeng
/// CreatDate：   2014-09-29
/// Description:  查询一段时期内传染病数量(门诊,住院共用一个服务)
/// 备注:		  首页柱状图
/// Table：       DHCMed.EPD.Epidemic
/// Input：       DateType    :  时间类型
/// Input：       StartDate   :  开始时间
/// Input：       EndDate     :  结束时间
/// Input：       PaadmType   :  就诊类型
/// Return：      传染病数量
/// 服务号:		  MD13.00.01
/// do ##class(%Library.ResultSet).RunQuery("DtPortal.MD.MD13Infectious","MD130001","1","2018-01-01","2018-01-07","I")
/// do ##class(%Library.ResultSet).RunQuery("DtPortal.MD.MD13Infectious","MD130001","2","2019-02-01","2019-02-28","I")
/// do ##class(%Library.ResultSet).RunQuery("DtPortal.MD.MD13Infectious","MD130001","3","2014","-","I")
Query MD130001(DateType As %String, StartDate As %String, EndDate As %String = "", PaadmType As %String, HospitalId As %String = "") As DtPortal.Query(ROWSPEC = "SubTitle:%String,WithDate:%String,BriefDate:%String,EpiNub:%String")
{
}

ClassMethod MD130001Execute(ByRef qHandle As %Binary, DateType As %String, StartDate As %String, EndDate As %String, PaadmType As %String, HospitalId As %String = "") As %Status
{
	Set repid=$I(^||CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind=1
	
	Q:(DateType="")!(StartDate="")!(EndDate="")!(PaadmType="")
	if (DateType="1")!(DateType="2")
	{
		set:StartDate["-" StartDate=$zdh(StartDate,3)
		set:EndDate["-" EndDate=$zdh(EndDate,3)
		set:EndDate>$p($h,",",1) EndDate=$p($h,",",1)
		For aDate=StartDate:1:EndDate
		{
			set EpiIDs=..FindEPDPatList(aDate,aDate,PaadmType,HospitalId)
			set nub=$l(EpiIDs,"^")
			set:EpiIDs="" nub=0 
			set dateShow=$zd(aDate,3)
			
			if (DateType="1")
			{
				set SubTitle=$p($zd(StartDate,3),"-",1)_"年"_$p($zd(StartDate,3),"-",2)_"月"_$p($zd(StartDate,3),"-",3)_"日"_"~"
				set SubTitle=SubTitle_$p($zd(EndDate,3),"-",1)_"年"_$p($zd(EndDate,3),"-",2)_"月"_$p($zd(EndDate,3),"-",3)_"日"
				set WithDate=$p(dateShow,"-",1)_"-"_$p(dateShow,"-",2)_"-"_$p(dateShow,"-",3)
				set BriefDate=$p(dateShow,"-",1)_"年"_$p(dateShow,"-",2)_"月"_$p(dateShow,"-",3)_"日"
				Set Data=$lb(SubTitle,WithDate,BriefDate,nub)
				Set ^||CacheTemp(repid,ind)=Data
				Set ind=ind+1
			}
			if (DateType="2")
			{
				set SubTitle=$p(dateShow,"-",1)_"年"_$p(dateShow,"-",2)_"月"
				set WithDate=$p(dateShow,"-",1)_"-"_$p(dateShow,"-",2)_"-"_$p(dateShow,"-",3)
				set BriefDate=$p(dateShow,"-",1)_"年"_$p(dateShow,"-",2)_"月"_$p(dateShow,"-",3)_"日"
				Set Data=$lb(SubTitle,WithDate,BriefDate,nub)
				Set ^||CacheTemp(repid,ind)=Data
				Set ind=ind+1
			}
			
		}
	}elseif (DateType="3")
	{

		set MouthIndex=12
		set year=$p(StartDate,"-",1)
		For i=1:1:MouthIndex
		{
			set sDate=##Class(DtPortal.Common.PublicService).getFirstDayOfMonth(year_"-"_i,2)
			set eDate=##Class(DtPortal.Common.PublicService).getLastDayOfMonth(year_"-"_i,2)
			
			set EpiIDs=..FindEPDPatList(sDate,eDate,PaadmType,HospitalId)
			set nub=$l(EpiIDs,"^")
			set:EpiIDs="" nub=0
			set month=i
			if (month<10) set month="0"_month
			set WithDate=year_"-"_month
			
			set BriefDate=year_"年"_month_"月"
			
			Set Data=$lb(year_"年",WithDate,BriefDate,nub)
			Set ^||CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
	}
	Quit $$$OK
}

/// Creator：     chengpeng
/// CreatDate：   2014-09-30
/// Description:  查询指定时间点传染病种类的数量(门诊,住院共用一个服务)
/// 备注:		  首页饼状图
/// Table：       DHCMed.EPD.Epidemic
/// Input：       StartDate   :  开始时间
/// Input：       EndDate     :  结束时间
/// Input：       PaadmType   :  就诊类型
/// 服务号:		  MD13.00.02
/// Return：      传染病种类数量列表
/// do ##class(%Library.ResultSet).RunQuery("DtPortal.MD.MD13Infectious","MD130002","2018-11-01","2018-11-30","I","2")
Query MD130002(StartDate As %String, EndDate As %String, PaadmType As %String, HospitalId As %String = "") As DtPortal.Query(ROWSPEC = "InfectionID:%String,Desc:%String,InfectionNub:%String")
{
}

ClassMethod MD130002Execute(ByRef qHandle As %Binary, StartDate As %String, EndDate As %String, PaadmType As %String, HospitalId As %String = "") As %Status
{
	Set repid=$I(^||CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind=1
	
	Q:(StartDate="")!(EndDate="")!(PaadmType="")
	k ^||ChengInfectionID
	k ^||ChengInfectionNub
	set EpiIDs=..FindEPDPatList(StartDate,EndDate,PaadmType,HospitalId)
	set Length=$l(EpiIDs,"^")
	set:EpiIDs="" Length=0
	
	For L=1:1:Length
	{
		set EpidemicID=$p(EpiIDs,"^",L)
		set InfeID=$p($g(^DHCMed.EPD("EPD",EpidemicID)),"^",5)
		continue:+InfeID=0
		set EPDKindID=$p(^DHCMed.EPDC("IF",InfeID),"^",3)
		continue:+EPDKindID=0
		if $d(^||ChengInfectionID($j,EPDKindID))
		{
			set ^||ChengInfectionID($j,EPDKindID)=$g(^||ChengInfectionID($j,EPDKindID))+1
		}else
		{
			set ^||ChengInfectionID($j,EPDKindID)=1
		}
		
	}
	set InfeKindID=""
	For
	{
		set InfeKindID=$o(^||ChengInfectionID($j,InfeKindID))
		Q:InfeKindID=""
		set InfeKindNub=$g(^||ChengInfectionID($j,InfeKindID))
		set DictionaryID=$o(^DHCMed.SS.DictionaryI("IndexTypeCode"," EPDEMICTYPE"," "_InfeKindID,""))
		set DictionObj=##class(DHCMed.SS.Dictionary).GetObjById(DictionaryID)
		Continue:'$IsObject(DictionObj)
		set InfeKindDesc=DictionObj.Description
		set ^||ChengInfectionNub($j,InfeKindNub,InfeKindID)=InfeKindDesc
	}
	set nInfectionNub=""
	For
	{
		set nInfectionNub=$o(^||ChengInfectionNub($j,nInfectionNub),-1)
		Q:nInfectionNub=""
		set nInfectionID=""
		For
		{
			set nInfectionID=$o(^||ChengInfectionNub($j,nInfectionNub,nInfectionID),-1)
			Q:nInfectionID=""
			set nDesc=$g(^||ChengInfectionNub($j,nInfectionNub,nInfectionID))
			
			Set Data=$lb(nInfectionID,nDesc,nInfectionNub)
			Set ^||CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
	}
	k ^||ChengInfectionID
	k ^||ChengInfectionNub
	
	Quit $$$OK
}

/// Creator：     chengpeng
/// CreatDate：   2014-09-29
/// Description:  查询指定时间点门诊某类传染病的患者明细列表		
/// Table：       DHCMed.EPD.Epidemic,User.Paadm
/// Input：       StartDate     :  开始时间
/// Input：       EndDate       :  结束时间
/// Input：       aInfeKindIDs :  传染病病种ID集合 以"^"分割，如"^1^32^22"
/// Return：      患者明细列表
/// 服务号:		  MD13.01.01
/// do ##class(%Library.ResultSet).RunQuery("DtPortal.MD.MD13Infectious","MD130101","2018-03-01","2018-03-30","2")
Query MD130101(StartDate As %String, EndDate As %String, HospitalId As %String = "") As DtPortal.Query(ROWSPEC = "PatName:%String,PatSex:%String,PatAge:%String,EpisodeID:%String,InfectionID:%String,InfectionDesc:%String,PAPMINo:%String,AdmDate:%String,AdmDocName:%String,DepCode:%String,RegFeelDesc:%String")
{
}

ClassMethod MD130101Execute(ByRef qHandle As %Binary, StartDate As %String, EndDate As %String, HospitalId As %String = "") As %Status
{
	Set repid=$I(^||CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind=1
	
	Q:(StartDate="")!(EndDate="")

	set EpiIDs=..FindEPDPatList(StartDate,EndDate,"O",HospitalId)
	set Length=$l(EpiIDs,"^")
	set:EpiIDs="" Length=0
	For L=1:1:Length
	{
		set EpidemicID=$p(EpiIDs,"^",L)
		set InfeID=$p($g(^DHCMed.EPD("EPD",EpidemicID)),"^",5)
		continue:+InfeID=0
		set EPDKindID=$p(^DHCMed.EPDC("IF",InfeID),"^",3)

		set EpisodeID=$p($g(^DHCMed.EPD("EPD",EpidemicID)),"^",29)      //就诊号
		set InfectionDesc=$p(^DHCMed.EPDC("IF",InfeID),"^",2)		//传染病描述		
		set PaadmStrs=$g(^PAADM(+EpisodeID))
		
		set DepCode=$p($g(^CTLOC($p(PaadmStrs,"^",4))),"^",2)     							//就诊科室
		set AdmDocCodeDR=$p(PaadmStrs,"^",9)
		set AdmDocName=""
		set:AdmDocCodeDR'="" AdmDocName=$p($g(^CTPCP(AdmDocCodeDR,1)),"^",2)				//就诊医生姓名
		set AdmDate=$zd($p(PaadmStrs,"^",6),3)							//就诊日期
		set RepDate=$p($g(^DHCMed.EPD("EPD",EpidemicID)),"^",17)
		set RepDate=$zd(RepDate,3)
		set PatmasID=$p(PaadmStrs,"^",1)
		set PatmasStr=$g(^PAPER(+PatmasID,"ALL"))
		set PatName=$p(PatmasStr,"^",1)									//患者姓名
		set PatSex=$p($g(^CT("SEX",$p(PatmasStr,"^",7))),"^",2)			//患者性别
		set PatDOB=$p(PatmasStr,"^",6)	
		
		set PatientID=$P($g(^PAADM(EpisodeID)),"^",1)
		set PatAge=##class(web.DHCBillInterface).GetPapmiAge(PatientID,EpisodeID) //统一调用计费组的年龄接口
		
		set PAPMINo=$p($g(^PAPER(+PatmasID,"PAT",1)),"^",1)				//登记号
		set RegFeelID=$o(^User.DHCRegistrationFeeI("ADM"," "_EpisodeID,""))	
		Set objRegFeel=##Class(User.DHCRegistrationFee).%OpenId(RegFeelID)
		set RegFeelID=""
		set RegFeelDesc=""
		set RegfeeRBASDr=""
		set:$IsObject(objRegFeel) RegfeeRBASDr=objRegFeel.RegfeeRBASDr
		
		set:RegfeeRBASDr'="" RegFeelID=$p(RegfeeRBASDr,"||",1)	
		set:RegFeelID'="" RegFeelDesc=$p($g(^RB("RES",RegFeelID)),"^",17)	//就诊号别

		
		Set Data=$lb(PatName,PatSex,PatAge,EpisodeID,InfeID,InfectionDesc,PAPMINo,RepDate,AdmDocName,DepCode,RegFeelDesc)
		Set ^||CacheTemp(repid,ind)=Data
		Set ind=ind+1
		
	}
	
	Quit $$$OK
}

/// Creator：     chengpeng
/// CreatDate：   2014-10-11
/// Description:  查询指定时间点住院某类传染病各病区分布
/// Table：       DHCMed.EPD.Epidemic
/// Input：       aInfeKindIDs   :  传染病病种ID
/// Input：       StartDate   :  开始时间
/// Input：       EndDate     :  结束时间
/// 服务号:		  MD13.02.01
/// Return：      某类传染病科室数量
/// do ##class(%Library.ResultSet).RunQuery("DtPortal.MD.MD13Infectious","MD130201","2018-12-1","2018-12-31")
Query MD130201(StartDate As %String, EndDate As %String, HospitalId As %String = "") As DtPortal.Query(ROWSPEC = "rWardID:%String,rWardDesc:%String,rEPDNub:%String")
{
}

ClassMethod MD130201Execute(ByRef qHandle As %Binary, StartDate As %String, EndDate As %String, HospitalId As %String = "") As %Status
{
	Set repid=$I(^||CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind=1
	
	k ^||ChengInfectionLocID
	
	Q:(StartDate="")!(EndDate="")
	set:StartDate["-" StartDate=$zdh(StartDate,3)
	set:EndDate["-" EndDate=$zdh(EndDate,3)
	
		
	For aData=StartDate:1:EndDate
	{
		set EpidemicID=""
		For
		{
			set EpidemicID=$o(^DHCMed.EPDi("EPD",0,"RepDate",aData,EpidemicID))
			q:EpidemicID=""
			set EpdStatus=$p($g(^DHCMed.EPD("EPD",+EpidemicID)),"^",15)
			continue:EpdStatus=5
			continue:EpdStatus=6
			continue:EpdStatus=7
			continue:EpdStatus=8
			set PatType=$p(^DHCMed.EPD("EPD",EpidemicID),"^",14)
			Continue:PatType'="I"		
			set EpisodeID=$p(^DHCMed.EPD("EPD",EpidemicID),"^",29)
			
			set ICD=$p(^DHCMed.EPD("EPD",EpidemicID),"^",5)
			continue:+ICD=0
			set EPDKindID=$p(^DHCMed.EPDC("IF",ICD),"^",3)
			set WardID=$p(^PAADM(EpisodeID),"^",70)
			
			set WardLoc=$p(^PAWARD(WardID),"^",5)
			set hospID=$p($g(^CTLOC(WardLoc)),"^",22)
			i HospitalId'=""  continue:hospID'=HospitalId
			
			set DictionaryID=$o(^DHCMed.SS.DictionaryI("IndexTypeCode"," EPDEMICTYPE"," "_EPDKindID,""))
			set DictionObj=##class(DHCMed.SS.Dictionary).GetObjById(DictionaryID)
			Continue:'$IsObject(DictionObj)
			set InfeKindDesc=DictionObj.Description
			
			if $d(^||ChengInfectionLocID($j,WardID))
			{
				
				set aNub=+$g(^||ChengInfectionLocID($j,WardID))+1
				set ^||ChengInfectionLocID($j,WardID)=aNub
			}else
			{
				
				set ^||ChengInfectionLocID($j,WardID)=1
			}
		}
	}
	set rWardID=""
	For
	{
		set rWardID=$o(^||ChengInfectionLocID($j,rWardID))
		Q:rWardID=""
		set rEPDNub=$g(^||ChengInfectionLocID($j,rWardID))
		
		set rWardDesc=$p(^PAWARD(rWardID),"^",2)
		set:rWardDesc["-" rWardDesc=$p(rWardDesc,"-",2)
			
		Set Data=$lb(rWardID,rWardDesc,rEPDNub)
		Set ^||CacheTemp(repid,ind)=Data
		Set ind=ind+1
		
	}
	k ^||ChengInfectionLocID
	
	Quit $$$OK
}

/// Creator：     chengpeng
/// CreatDate：   2014-10-11
/// Description:  查询指定时间点住院某类传染病某科室的患者明细列表		
/// Table：       DHCMed.EPD.Epidemic
/// Input：       StartDate   :  开始时间
/// Input：       EndDate     :  结束时间
/// Input：       aInfeKindIDs:  传染病病种ID
/// Input:        LWardID     :  病区ID
/// Return：      某类传染病科室数量
/// do ##class(%Library.ResultSet).RunQuery("DtPortal.MD.MD13Infectious","MD130202","2018-12-01","2018-12-31","1")
Query MD130202(StartDate As %String, EndDate As %String, WardID As %String) As DtPortal.Query(ROWSPEC = "PatName:%String,PatSex:%String,Age:%String,MedicareNo:%String,BedNo:%String,EpisodeId:%String,PAPMINo:%String,WardID:%String,WardDesc:%String,ICDDesc:%String,ICD:%String,InfectionDesc:%String,RepData:%String,RepTime:%String,ManagerDoc:%String")
{
}

ClassMethod MD130202Execute(ByRef qHandle As %Binary, StartDate As %String, EndDate As %String, WardID As %String) As %Status
{
	Set repid=$I(^||CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind=1
	
	Q:(StartDate="")!(EndDate="")!(WardID="")
	set:StartDate["-" StartDate=$zdh(StartDate,3)
	set:EndDate["-" EndDate=$zdh(EndDate,3)

	For aData=StartDate:1:EndDate
	{
		set EpidemicID=""
		For
		{
			set EpidemicID=$o(^DHCMed.EPDi("EPD",0,"RepDate",aData,EpidemicID))
			q:EpidemicID=""
			set EpdStatus=$p($g(^DHCMed.EPD("EPD",+EpidemicID)),"^",15)
			
			continue:EpdStatus=5
			continue:EpdStatus=6
			continue:EpdStatus=7
			continue:EpdStatus=8
			
			set PatType=$p(^DHCMed.EPD("EPD",EpidemicID),"^",14)					
			Continue:PatType'="I"	
				
			set EpisodeId=$p(^DHCMed.EPD("EPD",EpidemicID),"^",29)					//就诊号
			set ICD=$p(^DHCMed.EPD("EPD",EpidemicID),"^",5)		
			continue:+ICD=0	
							
			set EPDKindID=$p(^DHCMed.EPDC("IF",ICD),"^",3)						//传染病病种ID
			set wardId=$p(^PAADM(EpisodeId),"^",70)									//病区ID
			continue:wardId'=WardID
			set InfectionDesc=$p(^DHCMed.EPDC("IF",ICD),"^",2)				//传染病描述
			set WardDesc=$p(^PAWARD(wardId),"^",2)	
			set:WardDesc["-" WardDesc=$p(WardDesc,"-",2)							//病区描述
			set RepData=$zd(aData,3)												//报告日期
			set RepTime=$zt($p(^DHCMed.EPD("EPD",EpidemicID),"^",18),1)				//报告时间
			set PapmiID=$p(^DHCMed.EPD("EPD",EpidemicID),"^",1)
								
			Set AdmObj=##class(DHCMed.Base.PatientAdm).GetObjById(EpisodeId)
			Continue:'$IsObject(AdmObj)
			Set DoctorName=AdmObj.DoctorName									//主管医生				
			set PAPMINo=$p($g(^PAPER(+PapmiID,"PAT",1)),"^",1) 				//登记号
			set MedicareNo=##class(DtPortal.Common.PaadmService).getMedicareNo(EpisodeId) //病案号
			Set PatName=$P(^PAPER(PapmiID,"ALL"),"^",1)						//姓名
			Set PatSex=$P(^PAPER(PapmiID,"ALL"),"^",7)							
			if PatSex'="" Set PatSex=$P($g(^CT("SEX",PatSex)),"^",2)					//性别
			
			set PatientID=$P($g(^PAADM(EpisodeId)),"^",1)
			set Age=##class(web.DHCBillInterface).GetPapmiAge(PatientID,EpisodeId) //统一调用计费组的年龄接口
			
			set ICDDesc=##class(DtPortal.Common.PaadmService).GetMainDiagnosis(EpisodeId) //诊断
			set BedNo=""
			Set Bed=$P($g(^PAADM(EpisodeId)),"^",73)
			if Bed'="" s BedNo=$P($g(^PAWARD(+Bed,"BED",$P(Bed,"||",2))),"^",1)		//床号
			
			Set Data=$lb(PatName,PatSex,Age,MedicareNo,BedNo,EpisodeId,PAPMINo,WardID,WardDesc,ICDDesc,ICD,InfectionDesc,RepData,RepTime,DoctorName)
			Set ^||CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
		
	}
	
	Quit $$$OK
}

}
