/// ClassName:    DtPortal.DD.DD14InfectiousDiseases
/// Description:  临床科主任传染病分布服务
/// Creator：     chengpeng
/// CreatDate:    2015-12-09
Class DtPortal.DD.DD14InfectiousDiseases Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// Creator：     chengpeng
/// CreatDate：   2015-12-09
/// Description:  查询一段时间门诊或住院传染病报卡ID集合
/// Table：       DHCMed.EPD.Epidemic
/// Input：       startDate   :  开始时间
/// Input：       EndDate     :  结束时间
/// Input：       PaadmType   :  就诊类型
/// Input：       DocLocID 	  :  科主任科室ID
/// Return：      EpiID^      :  DHCMed.EPD.Epidemic.ID集合，以"^"分割
/// w ##class(DtPortal.DD.DD14InfectiousDiseases).FindEPDPatList("2019-01-10","2019-08-15","I","93")
ClassMethod FindEPDPatList(startDate As %String, EndDate As %String, PaadmType As %String, DocLocID As %String) As %String
{
	set return=""
	set:startDate["-" startDate=$zdh(startDate,3)
	set:EndDate["-" EndDate=$zdh(EndDate,3)
	For aDate=startDate:1:EndDate
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
			
			set EpisodeID=$p(EpiStr,"^",29)
			set PatLoc=$p($g(^PAADM(EpisodeID)),"^",4)
			continue:PatLoc'=DocLocID
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
/// CreatDate：   2015-12-09
/// Description:  DD14.01.01 按月查询科室内门诊/住院传染病数量
/// Table：       DHCMed.EPD.Epidemic
/// Input：       UserCode    :  用户工号
/// Input：       Year        :  查询时间
/// Input：       PaadmType   :  就诊类型 O门诊 I 住院
/// Return：      传染病数量
/// /修改者 赵丽，修改入参 日期参数改为开始日期和结束日期
/// do ##class(%Library.ResultSet).RunQuery("DtPortal.DD.DD14InfectiousDiseases","DD140101New","administrator","2019-01-01","2019-08-01","I","93")
Query DD140101(UserCode As %String, startDate As %String = "", endDate As %String = "", PaadmType As %String, locGroupId As %String) As DtPortal.Query(ROWSPEC = "yearMonth:%String,num:%String,monthStr:%String")
{
}

ClassMethod DD140101Execute(ByRef qHandle As %Binary, UserCode As %String, startDate As %String = "", endDate As %String = "", PaadmType As %String, locGroupId As %String) As %Status
{
	Set repid=$I(^||CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind=1
	
	;set:PaadmType="1" PaadmType="O"			//门诊
	;set:PaadmType="2" PaadmType="I"			//住院
	set DocLoc=##class(DtPortal.DD.DD00PublicService).getDDloc(locGroupId,PaadmType)
	if DocLoc=""{
		set DocLoc=##class(DtPortal.Common.PaadmService).getDDLocIDByUserCode(UserCode)
		Quit:DocLoc="" $$$OK
	}
	;w DocLoc,!
	///根据开始日期和结束日期 生成按月的日期段
	set dateObj=##class(%ResultSet).%New("DtPortal.Common.PublicService:getItemDateDetail")
	d dateObj.Execute("month",startDate,endDate)
	f  Quit:'dateObj.Next()  d
	.set dateStr= dateObj.Data("dateStr")
	.set date= dateObj.Data("date")
	.set startDateItem= dateObj.Data("startDateItem")
	.set endDateItem= dateObj.Data("endDateItem")
	.set num=0
	.for index=1:1:$l(DocLoc,"^") d
	..set loc=$p(DocLoc,"^",index)
	..set EpiStr=..FindEPDPatList(startDateItem,endDateItem,PaadmType,loc)
	..set:EpiStr'="" num=num+$l(EpiStr,"^")
	.Set Data=$lb(date,num,dateStr)
	.Set ^||CacheTemp(repid,ind)=Data
	.Set ind=ind+1
		
	Quit $$$OK
}

/// Creator：     chengpeng
/// CreatDate：   2015-12-09
/// Description:  DD14.01.02 按月查询科室门诊/住院传染病种类的数量
/// Table：       DHCMed.EPD.Epidemic
/// Input：       UserCode    :  用户工号
/// Input：       yearMonth   :  查询时间
/// Input：       PaadmType   :  就诊类型 O 门诊 I住院
/// Return：      传染病数量
/// ///// /修改者 赵丽，修改入参 日期参数改为开始日期和结束日期
/// do ##class(%Library.ResultSet).RunQuery("DtPortal.DD.DD14InfectiousDiseases","DD140102New","1772","2019-02-01","2019-02-28","I",93)
Query DD140102(UserCode As %String, startDate As %String = "", endDate As %String = "", PaadmType As %String, locGroupId As %String) As DtPortal.Query(ROWSPEC = "InfectionID:%String,infectiouType:%String,num:%String")
{
}

ClassMethod DD140102Execute(ByRef qHandle As %Binary, UserCode As %String, startDate As %String = "", endDate As %String = "", PaadmType As %String, locGroupId As %String) As %Status
{
	Set repid=$I(^||CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind=1
	
	k ^||ChengInfectionID
	k ^||ChengInfectionNub
	
	;set:PaadmType="1" PaadmType="O"			//门诊
	;set:PaadmType="2" PaadmType="I"			//住院
	set DocLoc=##class(DtPortal.DD.DD00PublicService).getDDloc(locGroupId,PaadmType)
	if DocLoc=""{
	set DocLoc=##class(DtPortal.Common.PaadmService).getDDLocIDByUserCode(UserCode)
	Quit:DocLoc="" $$$OK
	}
	
	for i=1:1:$l(DocLoc,"^")
	{
	 set loc=$p(DocLoc,"^",i)
	 set EpiStr=..FindEPDPatList(startDate,endDate,PaadmType,loc)
	 continue:EpiStr="" 
	 set num=$l(EpiStr,"^")
	
	For L=1:1:num
	{
		set EpidemicID=$p(EpiStr,"^",L)
		set InfeID=$p($g(^DHCMed.EPD("EPD",EpidemicID)),"^",5)
		set EPDKindID=$p(^DHCMed.EPDC("IF",InfeID),"^",3)
		if $d(^||ChengInfectionID($j,EPDKindID))
		{
			set ^||ChengInfectionID($j,EPDKindID)=$g(^||ChengInfectionID($j,EPDKindID))+1
		}else
		{
			set ^||ChengInfectionID($j,EPDKindID)=1
		}
		
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
	set num=""
	For
	{
		set num=$o(^||ChengInfectionNub($j,num),-1)
		Q:num=""
		set InfectionID=""
		For
		{
			set InfectionID=$o(^||ChengInfectionNub($j,num,InfectionID),-1)
			Q:InfectionID=""
			set infectiouType=$g(^||ChengInfectionNub($j,num,InfectionID))
			
			Set Data=$lb(InfectionID,infectiouType,num)
			Set ^||CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
	}
	k ^||ChengInfectionID
	k ^||ChengInfectionNub
	
	Quit $$$OK
}

/// Creator：     chengpeng
/// CreatDate：   2015-12-09
/// Description:  DD14.01.03 按月查询科室门诊/住院传染病的患者信息
/// Table：       DHCMed.EPD.Epidemic
/// Input：       UserCode    :  用户工号
/// Input：       yearMonth   :  查询时间
/// Input：       PaadmType   :  就诊类型
/// Return：      传染病患者信息
/// /修改者 赵丽，修改入参 日期参数改为开始日期和结束日期 20190815
/// do ##class(%Library.ResultSet).RunQuery("DtPortal.DD.DD14InfectiousDiseases","DD140103New","1772","2019-02-01","2019-02-01","I",93)
Query DD140103(UserCode As %String, startDate As %String = "", endDate As %String = "", PaadmType As %String, locGroupId As %String) As DtPortal.Query(ROWSPEC = "bedNum:%String,name:%String,sex:%String,age:%String,medicareNo:%String,doctor:%String,infectiouType:%String,reportDate:%String,wardLocName:%String")
{
}

ClassMethod DD140103Execute(ByRef qHandle As %Binary, UserCode As %String, startDate As %String, endDate As %String = "", PaadmType As %String, locGroupId As %String) As %Status
{
	Set repid=$I(^||CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind=1
	
	;set:PaadmType="1" PaadmType="O"			//门诊
	;set:PaadmType="2" PaadmType="I"			//住院

	set DocLoc=##class(DtPortal.DD.DD00PublicService).getDDloc(locGroupId,PaadmType)
	if DocLoc=""{
		set DocLoc=##class(DtPortal.Common.PaadmService).getDDLocIDByUserCode(UserCode)
		Quit:DocLoc="" $$$OK
	}
	
	for i=1:1:$l(DocLoc,"^"){
		
		set loc=$P(DocLoc,"^",i)
		set EpiStr=..FindEPDPatList(startDate,endDate,PaadmType,loc)
		continue:EpiStr="" 
		set num=$l(EpiStr,"^")
	
	For L=1:1:num
	{
		set EpidemicID=$p(EpiStr,"^",L)
		set EpiPatStr=$g(^DHCMed.EPD("EPD",+EpidemicID))			
		set InfeID=$p($g(^DHCMed.EPD("EPD",EpidemicID)),"^",5)			
		set EPDKindID=$p(^DHCMed.EPDC("IF",InfeID),"^",3)				//
		
		set DictionaryID=$o(^DHCMed.SS.DictionaryI("IndexTypeCode"," EPDEMICTYPE"," "_EPDKindID,""))
		set DictionObj=##class(DHCMed.SS.Dictionary).GetObjById(DictionaryID)
		Continue:'$IsObject(DictionObj)
		set InfeKindDesc=DictionObj.Description							//传染病类型
		
		set EpisodeID=$p(EpiPatStr,"^",29)								//
		set PaadmStrs=$g(^PAADM(+EpisodeID))
		set AdmDocCodeDR=$p(PaadmStrs,"^",9)
		set AdmDocName=""
		set:AdmDocCodeDR'="" AdmDocName=$p($g(^CTPCP(AdmDocCodeDR,1)),"^",2)				//就诊医生姓名
		set AdmDate=$zd($p(PaadmStrs,"^",6),3)							//就诊日期
		
		Set AdmObj=##class(DHCMed.Base.PatientAdm).GetObjById(EpisodeID)
		Continue:'$IsObject(AdmObj)
		Set DoctorName=AdmObj.DoctorName								//主管医生
		
		set wardID=$p(PaadmStrs,"^",70)	
		set wardName=""							
		set:wardID'="" wardName=$p(^PAWARD(wardID),"^",2)
		set:wardName["-" wardName=$p(wardName,"-",2)						//病区名称
		
		set locID=$p(PaadmStrs,"^",4)	
		set LocName=""							
		set:locID'="" LocName=$p(^CTLOC(locID),"^",2)
		set:LocName["-" LocName=$p(LocName,"-",2)							//科室名称
		
		set objEpi=##class(DHCMed.EPD.Epidemic).GetObjById(EpidemicID)
		Continue:'$IsObject(objEpi)
		set reportDate=$zd(objEpi.MEPDRepDate,3)									//上报日期
		
		set PatInfo=##class(DtPortal.Common.PaadmService).GetPatInfo(EpisodeID)
		Continue:PatInfo=""
		set name=$p(PatInfo,"^",2)											//姓名
		set sex=$p(PatInfo,"^",3)											//性别
		set age=$p(PatInfo,"^",4)											//年龄
		set medicareNo=$p(PatInfo,"^",5)									//病案号
		set admReason=$p(PatInfo,"^",6)										//费用类别
		set bedNum=$p(PatInfo,"^",1)											//床号
		
		set infectiouType=InfeKindDesc
		set wardLocName=""
		set doctor=""
		set:PaadmType="O" doctor=AdmDocName,wardLocName=LocName
		set:PaadmType="I" doctor=DoctorName,wardLocName=wardName
		
		Set Data=$lb(bedNum,name,sex,age,medicareNo,doctor,infectiouType,reportDate,wardLocName)
		Set ^||CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	}
	
	
	Quit $$$OK
}

}
