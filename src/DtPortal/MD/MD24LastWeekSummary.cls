/// 名称: DHCWL.MKPIService.MKPIQuery
/// 描述: 指标区间数据的查询
/// 编写者：csq
/// 编写日期:2016-03-04
/// 总出院人数^全院平均住院日^床位使用率^病房死亡人数^急诊死亡人数^住院死亡率^二次手术人数^住院超过60天人数^手术例数^24小时重返人数
/// inpatientAmount^averagedInhospital^wardRate^deathsWard^DeathsEmergencyNum^HospitalMortalityNum^ReoperationNum^MoreThan60Num^OperationNum^ReturnIn24hNum
Class DtPortal.MD.MD24LastWeekSummary Extends %RegisteredObject [ Not ProcedureBlock ]
{

// MD24.01.01

// d ##class(%ResultSet).RunQuery("DtPortal.MD.MD24LastWeekSummary","MD240101","","2018-12-01","2018-12-31")

Query MD240101(hospitalId As %String = "", startDate As %String, endDate As %String) As DtPortal.Query(ROWSPEC = "inpatientAmount:%String,averagedInhospitalNum:%String,deathsWard:%String,deathsEmergency:%String,hospitalMortality:%String,twoOperationNum:%String,operationNum:%String,wardRateNum:%String") [ SqlProc ]
{
}

ClassMethod MD240101Execute(ByRef qHandle As %Binary, hospitalId As %String = "", startDate As %String, endDate As %String, dateType As %String = "", kpiRule As %Text, filterRule As %Text = "", mode = "R", contract = "") As %Status
{
	
	n (qHandle,hospitalId,startDate,endDate)
	Set repid1=$I(^||CacheTemp)
	Set ind1=1
	Set qHandle=$lb(0,repid1,0)
	set mode="H"
	set dateType="",filterRule="",contract=""
	
	s sDate=$zdh(startDate,3)
	s eDate=$zdh(endDate,3)
	//出院人数（SK0224:PatLoc）、出院患者占床总日(SK0144:PatLoc)、患者实际占床总日数（SK0142:PatLoc）、实际床位数（SK0143:PatLoc）
	//非计划二次手术
	set kpiRule="SK0224:PatLoc,SK0144:PatLoc,SK0142:PatLoc,SK0143:PatLoc,SK0163:PatLoc"
	i hospitalId'="" set filterRule="SK0224:({PatLoc.HospIdByLoc}="_hospitalId_"),"_"SK0144:({PatLoc.HospIdByLoc}="_hospitalId_"),"_"SK0142:({PatLoc.HospIdByLoc}="_hospitalId_"),"_"SK0143:({PatLoc.HospIdByLoc}="_hospitalId_"),"_"SK0163:({PatLoc.HospIdByLoc}="_hospitalId_")"
	
	set rs=##class(DHCWL.util.UniteQueryData).GetQueryDateRef("DHCWL.MKPIService.MKPIQuery:KpiQueryGrideShow",startDate,endDate,dateType,kpiRule,filterRule,mode,contract)
	
	set inpatientAmount=0,averagedInhospitalNum=0,wardRate="",reOperationNum=0,twoOperationNum=0,operationNum=0,cyBedDays=0
	set sjzyBedDays=0,sjkfBedDays=0
	While rs.Next(.sc) {
		If $$$ISERR(sc) Quit
		//出院人数
		s inpatientAmount=inpatientAmount+rs.Data("kpiValueCol1")
		//出院患者占床总日
		s cyBedDays=cyBedDays+rs.Data("kpiValueCol2")
		//现有人数
		s sjzyBedDays=sjzyBedDays+rs.Data("kpiValueCol3")
		//实有床位
		s sjkfBedDays=sjkfBedDays+rs.Data("kpiValueCol4")
		//手术量
		s operationNum=operationNum+rs.Data("kpiValueCol5")
		//二次手术
		//s twoOperationNum=twoOperationNum+rs.Data("kpiValueCol2")
	}
	
	//d ##class(%ResultSet).RunQuery("DtPortal.MD.MD17Deaths","MD170102","2018-03-01","2018-03-31","I","")
	
	s deathsWard=0,deathsEmergency=0,hospitalMortality=0
	try{
		i $zdh(startDate,3)=+$h  s startDate=$zd(+$h-1,3)
		i $zdh(endDate,3)=+$h  s endDate=$zd(+$h-1,3)
		set obj=##class(%ResultSet).%New("DtPortal.MD.MD17Deaths:MD170102")
		d obj.Execute(startDate,endDate,"",hospitalId)
		f  Quit:'obj.Next()  d
		.s admType=obj.Data("admType")
		.i admType="I" s deathsWard=deathsWard+1
		.e  i admType="E" s deathsEmergency=deathsEmergency+1
	}catch{
		w !,$ze
		b ;err
	}
	
	
	
	
	//b ;002
	
	if inpatientAmount>0
	{	
		//平均住院日=出院患者住院天数/出院人数
		set averagedInhospitalNum=$fn(cyBedDays/inpatientAmount,"",2)
		;b ;01
		//住院死亡率%= 死亡人数/出院人数
		set hospitalMortality=$fn(deathsWard*100/inpatientAmount,"",2)	
	}
	
	//床位使用率 %= 患者实际占床总日数/实际开放床日数
	set wardRateNum="0"
	if sjkfBedDays>0
	{
		set wardRateNum=$fn(sjzyBedDays*100/sjkfBedDays,"",2)		
	}
	//非计划二次手术[自己写指标]
	
	s ^||CacheTemp(repid1,ind1)=$lb(inpatientAmount,averagedInhospitalNum,deathsWard,deathsEmergency,hospitalMortality,twoOperationNum,operationNum,wardRateNum)
 	s ind1=ind1+1	
	Quit $$$OK
}

// d ##class(%ResultSet).RunQuery("DtPortal.MD.MD24LastWeekSummary","MD240201","","2017-09-06","2016-03-06","","","","R",)

/// 名称: DHCWL.MKPIService.MKPIQuery
/// 描述: 指标区间数据的查询
/// 编写者：csq
/// 编写日期:2016-03-05
/// 查询上周各个科室的出院人数
/// 服务序号:MD24.02.01
Query MD240201(hospitalId As %String = "", startDate As %String, endDate As %String, dateType As %String = "", kpiRule As %Text, filterRule As %Text = "", mode = "R", contract = "") As DtPortal.Query(ROWSPEC = "locDesc:%String,inpatientAmount:%Float") [ SqlProc ]
{
}

ClassMethod MD240201Execute(ByRef qHandle As %Binary, hospitalId As %String = "", startDate As %String, endDate As %String, dateType As %String = "", kpiRule As %Text, filterRule As %Text = "", mode = "R", contract = "") As %Status
{
	n (qHandle,hospitalId,startDate,endDate,dateType,kpiRule,filterRule,mode,contract)
	Set repid=$I(^||CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	k data
	;set mode="R"
	s kpiRule="SK0140:PatLoc"
	s filterRule=""
	i hospitalId'="" S filterRule="SK0140:({PatLoc.HospIdByLoc}="_hospitalId_")"
	s CTLOCNum=0
	s rs=##class(DHCWL.util.UniteQueryData).GetQueryDateRef("DHCWL.MKPIService.MKPIQuery:KpiQueryGrideShow",startDate,endDate,dateType,kpiRule,filterRule,mode,contract)
	While rs.Next(.sc) {
		If $$$ISERR(sc) Quit
		set locDr=(rs.Data("dimIdCol1"))	 //科室Id
		continue:(locDr="")||(+locDr=0)
		set locDischageNum=$g(rs.Data("kpiValueCol1")) //科室出院人数 
		//w locDr_"^"_locDischageNum,!
		set data("locDischNum",locDr)=$g(data("locDischNum",locDr))+$g(locDischageNum)
	    
	}
	
	set locId="",inpatientAmount=0
	for 
	{
		set locId=$o(data("locDischNum",locId))	
		quit:(locId="")
		set locDesc=$p($g(^CTLOC(locId)),"^",2)
		if locDesc["-"
		{
			set locDesc=$p(locDesc,"-",2)	
		}
		
		set inpatientAmount=$g(data("locDischNum",locId))
		continue:inpatientAmount=0
		//w locId_"^"_locDesc_"^"_inpatientAmount,!
		set ^||CacheTemp(repid,ind)=$lb(locDesc,inpatientAmount)
		set ind=ind+1 
	}
	k data
	Quit $$$OK
}

/// d ##class(%ResultSet).RunQuery("DtPortal.MD.MD24LastWeekSummary","MD240301","","2018-06-15","2018-12-31","I")
/// MD24.03.01查询指定时间内急诊、住院死亡患者明细,调用MD17明细借口
Query MD240301(hospitalId As %String = "", startDate As %String, endDate As %String, admType As %String = "") As DtPortal.Query(ROWSPEC = "bedCode,name,sex,age,medicareNo,admReason,regNo,nurseDesc,docDesc,locDesc,wardDesc,Diagnosis,DeathDate,AReason,admType,HomePage") [ SqlProc ]
{
}

ClassMethod MD240301Execute(ByRef qHandle As %Binary, hospitalId As %String = "", startDate As %String, endDate As %String, admType As %String = "") As %Status
{
	n (qHandle,hospitalId,startDate,endDate,admType)
	Set repid1=$I(^||CacheTemp)
	Set ind1=1
	Set qHandle=$lb(0,repid1,0)
	i $zdh(startDate,3)>(+$h-1) q $$$OK
	i $zdh(endDate,3)>(+$h-1) s endDate=$zd(+$h-1,3)
	
	s SDate=$zdh(startDate,3)
	s EDate=$zdh(endDate,3)
	
	set obj=##class(%ResultSet).%New("DtPortal.MD.MD17Deaths:MD170102")
	d obj.Execute(startDate,endDate,admType,hospitalId)
	s (bedCode,name,sex,age,medicareNo,admReason,regNo,nurseDesc,docDesc,locDesc,wardDesc,Diagnosis,DeathDate,AReason,admType)=""
	f  Quit:'obj.Next()  d
	.s bedCode=obj.Data("bedCode")
	.s name=obj.Data("name")
	.s sex=obj.Data("sex")
	.s age=obj.Data("age")
	.s medicareNo=obj.Data("medicareNo")
	.s admReason=obj.Data("admReason")
	.s regNo=obj.Data("regNo")
	.s nurseDesc=obj.Data("nurseDesc")
	.s docDesc=obj.Data("docDesc")
	.s locDesc=obj.Data("locDesc")
	.s wardDesc=obj.Data("wardDesc")
	.s Diagnosis=obj.Data("Diagnosis")
	.s DeathDate=obj.Data("DeathDate")
	.s AReason=obj.Data("AReason")
	.s admType=obj.Data("admType")
	.s admid=obj.Data("admid")
	.s HomePage=##Class(DtPortal.Common.PaadmService).getEMRIfFinish(admid)
	.set ^||CacheTemp(repid1,ind1)=$lb(bedCode,name,sex,age,medicareNo,admReason,regNo,nurseDesc,docDesc,locDesc,wardDesc,Diagnosis,DeathDate,AReason,admType,HomePage)
	.set ind1=ind1+1
	d obj.Close()
	
	
	Quit $$$OK
}

// 根据日期获取各个科室死亡患者和总患者人数

// 作者：DanPJ

// 日期：2016-03-22

// startDate:开始日期,endDate:结束日期

// 服务号：MD24.04.01

// d ##class(%ResultSet).RunQuery("DtPortal.MD.MD24LastWeekSummary","MD240401","","2018-03-07","2018-12-31")

Query MD240401(hospitalId As %String = "", startDate As %String, endDate As %String) As DtPortal.Query(ROWSPEC = "locId:%String,locDesc:%String,deathNum:%String,totalNum:%String,deadRate:%String") [ SqlProc ]
{
}

ClassMethod MD240401Execute(ByRef qHandle As %Binary, hospitalId As %String = "", startDate As %String, endDate As %String) As %Status
{
	n (qHandle,hospitalId,startDate,endDate)
	Set repid1=$I(^||CacheTemp)
	Set ind1=1
	Set qHandle=$lb(0,repid1,0)
	i $zdh(startDate,3)>(+$h-1) q $$$OK
	i $zdh(endDate,3)>(+$h-1) s endDate=$zd(+$h-1,3)
	
	k ^TEMPPortalMD240401($j)
	
	set obj=##class(%ResultSet).%New("DtPortal.MD.MD17Deaths:MD170102")
	d obj.Execute(startDate,endDate,"I",hospitalId)
	s (bedCode,name,sex,age,medicareNo,admReason,regNo,nurseDesc,docDesc,locDesc,wardDesc,Diagnosis,DeathDate,AReason,admType)=""
	f  Quit:'obj.Next()  d
	.s PAAdm=obj.Data("admid")
	.s locId=$P($g(^PAADM(PAAdm)),"^",4)
	.q:locId=""
	.s ^TEMPPortalMD240401($j,locId,"deadNum")=$g(^TEMPPortalMD240401($j,locId,"deadNum"))+1
	s dateType=""
	s kpiRule="SK0224:PatLoc"
	s filterRule=""
	s mode="H"
	i hospitalId'="" S filterRule="SK0224:({PatLoc.HospIdByLoc}="_hospitalId_")"
	s rs=##class(DHCWL.util.UniteQueryData).GetQueryDateRef("DHCWL.MKPIService.MKPIQuery:KpiQueryGrideShow",startDate,endDate,dateType,kpiRule,filterRule,mode,"")
	
	While rs.Next(.sc) {
		If $$$ISERR(sc) Quit
		set locId=rs.Data("dimIdCol1")
		if locId="" continue
		//if $g(^TEMPPortalMD240401($j,locId,"deadNum"))="" continue
		set ^TEMPPortalMD240401($j,locId,"outNum")=$g(^TEMPPortalMD240401($j,locId,"outNum"))+rs.Data("kpiValueCol1")

	}
	//取数组
	
	set locId="",locDesc="",deathNum=0,totalNum=0
	for
	{
		set locId=$o(^TEMPPortalMD240401($j,locId))
		quit:(locId="")||(+locId=0)
		//科室描述
		set locDesc=$p(^CTLOC(locId),"^",2)
		if locDesc["-"
		{
			set locDesc=$p(locDesc,"-",2)	
		}
		set totalNum=$g(^TEMPPortalMD240401($j,locId,"outNum"))	//总出院人数
		set deathNum=$g(^TEMPPortalMD240401($j,locId,"deadNum"))	//死亡人数
		
		set deadRate=0
		s:+totalNum'=0 deadRate=$fn((+deathNum)/(+totalNum)*100,"",2)
		
		set ^||CacheTemp(repid1,ind1)=$lb(locId,locDesc,+deathNum,+totalNum,deadRate)	
		set ind1=ind1+1
	}
	
	k ^TEMPPortalMD240401($j)
	
	Quit $$$OK
}

// 根据院区id查询所有的手术执行科室

// d ##class(%ResultSet).RunQuery("DtPortal.MD.MD24LastWeekSummary","MD240601","")

// 日期：2016-03-15

// 作者DanPJ

// 服务号：MD240601

/// d ##class(%ResultSet).RunQuery("DtPortal.MD.MD24LastWeekSummary","MD240601","2","2018-04-01","2018-04-30")
Query MD240601(hospitalId As %String = "", startDate As %String = "", endDate As %String = "") As DtPortal.Query(ROWSPEC = "opExecutiveDepDesc:%String,opExecutiveDepId:%String,totalOperationNum:%String") [ SqlProc ]
{
}

ClassMethod MD240601Execute(ByRef qHandle As %Binary, hospitalId As %String = "", startDate As %String = "", endDate As %String = "") As %Status
{
	n (qHandle,hospitalId,startDate,endDate)
	Set repid=$I(^||CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	
	
	
	s obj=##class(web.DHCANService).GetAllOperDept(hospitalId)
	Set readerMD240601 = ##class(%XML.Reader).%New()
	Do readerMD240601.OpenStream(obj)
	Do readerMD240601.Correlate("AllOperatingRoom","User.DHCANOPInterfaceForPortalOperDept")
	While (readerMD240601.Next(.object,.sc)) {
		
		s opExecutiveDepDesc=object.operRoomName
		
		s opExecutiveDepId=object.operRoomId
		s totalOperationNum=""
		
		if (startDate'="")&&(endDate'=""){
			s opInfo=##class(DtPortal.MD.MD24LastWeekSummary).getOperationNum(startDate,endDate,opExecutiveDepId)
			s totalOperationNum=opInfo   //$p(opInfo,"^")
		}
		
		s ^||CacheTemp(repid,ind)=$lb(opExecutiveDepDesc,opExecutiveDepId,totalOperationNum)
 		s ind=ind+1
	

	}
	
	
	
	Quit $$$OK
}

// 根据日期获取手术量信息

// 作者：DanPJ

// 日期：2016-03-14

// startDate:手术开始日期,endDate,status：手术状态

// w ##class(DtPortal.MD.MD24LastWeekSummary).getOperationNum("2018-04-01","2018-04-30")

ClassMethod getOperationNum(startDate, endDate, opLocId = "") As %String
{
	k ^DHCPOROPA($j)
	s count=0
	s resultString=""
	s status="F"	//F为完成状态
	//调用手麻组的接口
	//入参：按手术开始日期、结束日期、就诊号、申请手术科室、手术状态、手术室ID或描述、手术Id，起止日期和就诊号不能同时空
	//手术状态opaStatus："A"是申请，"D"是拒绝，"R"是安排，"I"是术中，"P"是恢复室，"L"是离室，"F"是完成。""是全部。可以用"ARF"这样的组合查询多个状态。
	;b ;startDate
	s ret=##class(web.DHCANAdaptor).GetANOperation(startDate,endDate,"","",status,"","")
	Set reader = ##class(%XML.Reader).%New()
	Do reader.OpenStream(ret)
	Do reader.Correlate("PatInfo","web.DHCANInterface")
	While (reader.Next(.object,.sc)) {
		s OPAOperLocDr=object.OPAOperLocDr   //手术科室id
		continue:(OPAOperLocDr="")||((opLocId'="")&&(opLocId'=OPAOperLocDr))
		
		;b ;11
		s episodeID=object.EpisodeID	//就诊号
		s opaId=object.OpaId			//手术Id
	 	s oproomdr=object.OPAOpRoomDr	//手术间id
	 	continue:oproomdr=""			//手术间id为空就退出
	 	s opaOpRoom=object.OPAOpRoom	//手术间描述
	 	i opaOpRoom="" continue
	 	s opordno=object.OPASeq			//手术台次
	 	s operationNum=0 				//手术例数
	 	s opaTime=""						//手术时间
	 	s surgeonStartDate=object.SurgeonStartDate	//手术医生开始手术日期
	 	s surgeonStartTime=object.SurgeonStartTime	//手术医生开始手术时间
	 	/*
	 	s surgeonStartDate=object.SurgeonStartDate	//手术医生开始手术日期
	 	s surgeonStartTime=object.SurgeonStartTime	//手术医生开始手术时间
	 	i surgeonStartDate["-" s opaStartTime=$zdh($g(surgeonStartDate),3)*24*60*60   ;+$zth(surgeonStartTime,3)	//手术医生开始手术时间转换成秒数
	 	e  s opaStartTime=$zdh($g(surgeonStartDate),4)*24*60*60
	 	//处理时间一会出现标准格式一会出现数字格式
	 	i +surgeonStartTime>0 s opaStartTime=opaStartTime+surgeonStartTime
	 	i (+surgeonStartTime=0)&&(surgeonStartTime'="") s opaStartTime=opaStartTime+$zth(surgeonStartTime)  
	 	;b ;01
	 	s surgeonEndDate=object.SurgeonEndDate		//手术医生结束手术日期
	 	s surgeonEndTime=object.SurgeonEndTime		//手术医生结束手术时间
	 	
	 	//手术开始结束时间
	 	
	 	*/
	 	
	 	
	 	;b ;surgeonEndDate
	 	
	 	/*
	 	if ((surgeonEndDate="") || (surgeonEndDate=0)|| (surgeonEndDate<0))
	 	{
		 	;b ; 0
			s opaTime=0		//当结束手术日期为0时,手术时间就返回一个0 	
		}else{
			;b ;000
			i surgeonEndDate["-" s opaEndTime=$zdh($g(surgeonEndDate),3)*24*60*60 //手术医生结束手术时间转换成秒数
			e  s opaEndTime=$zdh($g(surgeonEndDate),4)*24*60*60 //手术医生结束手术时间转换成秒数
			//处理时间一会出现标准格式一会出现数字格式
	 		i +surgeonEndTime>0 s opaEndTime=opaEndTime+surgeonEndTime
	 		e  i (+surgeonEndTime=0)&&(surgeonEndTime'="") s opaEndTime=opaEndTime+$zth(surgeonEndTime) 

	 		;b ;002
			s opaTime=opaEndTime-opaStartTime	
			
		} 
		*/
	   s opaTime=""
		
	   s startDate=$p(object.OPAStartDateTime," ",1)
	   s startDate=$zd(startDate,3)*24*60*60
	   s startTime=$p(object.OPAStartDateTime," ",2)
	   i startTime'="" s startTime=$zth(startTime,3)
	   s endDate=$p(object.OPAEndDateTime," ",1)
	   s endDate=$zd(endDate,3)*24*60*60
	   s endTime=$p(object.OPAEndDateTime," ",2)
	   i endTime'="" s endTime=$zth(endTime,3)
	   w !,object.OPAStartDateTime_"^"_object.OPAEndDateTime
	   if (+endDate=0)
	   {
		  s opaTime=0		//当结束手术日期为0时,手术时间就返回一个0 	
	   }else{
			;b ;000
			
			//处理时间一会出现标准格式一会出现数字格式
	 		i +endTime>0 s opaEndTime=endDate+endTime
	 		e  s opaEndTime=endDate
	 		
	 		i +startTime>0 s opaStartTime=endDate+startTime
	 		e  s opaStartTime=startDate
	 		
	 		

	 		;b ;002
			s opaTime=opaEndTime-opaStartTime	
			
		}
		s count=count+1
	 	;w opaTime_"^"_opaId_"^"_episodeID_"^"_oproomdr_"^"_opaOpRoom_"^"_opordno_"^"_surgeonStartDate_"^"_surgeonStartTime_"^"_surgeonEndDate_"^"_surgeonEndTime,! ;_"^"_opaEndTime_"^"_opaStartTime_"^"_opaTime
	 	
	 	s ^DHCPOROPA($j,"opaNum",opaOpRoom)=$g(^DHCPOROPA($j,"opaNum",opaOpRoom))+1					//手术间的手术量
	 	s ^DHCPOROPA($j,"opaTime",opaOpRoom)=$g(^DHCPOROPA($j,"opaTime",opaOpRoom))+$g(opaTime)		//手术间的手术时间
	 	s ^DHCPOROPA($j,"opaInfor",opaOpRoom)=$g(^DHCPOROPA($j,"opaNum",opaOpRoom))_"^"_$g(^DHCPOROPA($j,"opaTime",opaOpRoom))
	 }
	 
	//获取值
	 s opaOpRoom="",opaOpNum=0,opaOpTime=0
	 f  s opaOpRoom=$o(^DHCPOROPA($j,"opaInfor",opaOpRoom)) q:(opaOpRoom="")  d
	 .s opaOpNum=$p(^DHCPOROPA($j,"opaInfor",opaOpRoom),"^",1)
	 .s opaOpTime=$p(^DHCPOROPA($j,"opaInfor",opaOpRoom),"^",2)
	 .s hOpaTime=opaOpTime\3600
	 .s mOpaTime=(opaOpTime-(hOpaTime*3600))\60
	 .s sOpaTime=opaOpTime-(hOpaTime*3600)-(mOpaTime*60)
	 .s tempOpTime=""
	 .i hOpaTime>0 s tempOpTime=tempOpTime_hOpaTime_"h"
	 .i mOpaTime>0 s tempOpTime=tempOpTime_mOpaTime_"m"
	 .i sOpaTime>0 s tempOpTime=tempOpTime_sOpaTime_"s"
	 .i tempOpTime'="" s opaOpTime=tempOpTime
	 .e  s opaOpTime=0_"s"
	 .;w opaOpRoom_"^"_opaOpNum_"^"_opaOpTime,!
	 .i resultString="" s resultString=opaOpRoom_"|"_opaOpNum_"|"_opaOpTime
	 .e  s resultString=resultString_"^"_opaOpRoom_"|"_opaOpNum_"|"_opaOpTime
	 s resultString=count_"^"_resultString
	 ;w "count="_count,!
	 q resultString
}

/// 编写者：DanPJ
/// 编写日期:2016-03-10
/// 上周二次手术病人明细明细
/// 服务序号:MD24.07.01
/// d ##class(%ResultSet).RunQuery("DtPortal.MD.MD24LastWeekSummary","MD240701","","2017-02-26","2017-11-03","11")
Query MD240701(hospitalId As %String, startDate As %String, endDate As %String, homePageId As %String = "") As DtPortal.Query(ROWSPEC = "bedNo:%String,name:%String,sex:%String,age:%String,medicalRecordNo:%String,inDayNum:%String,careDoctor:%String,lastOperationTime:%String,currentOperationTime:%String,homePage:%String") [ SqlProc ]
{
}

ClassMethod MD240701Execute(ByRef qHandle As %Binary, hospitalId As %String, startDate As %String, endDate As %String, homePageId As %String = "") As %Status
{
	n (qHandle,hospitalId,startDate,endDate,homePageId)
	Set repid=$I(^||CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	k ^TEMPDHCWL($j)
	
	
	s SDate=$zdh(startDate,3)
	s EDate=$zdh(endDate,3)
	s paadmType="I"
	f DisDate=SDate:1:EDate  d
	.s AdmRowid=""
	.f  s AdmRowid=$o(^PAADMi("DisDateT",paadmType,DisDate,AdmRowid)) q:AdmRowid=""  d
	..s locId=$p(^PAADM(AdmRowid),"^",4)
	..q:(locId="")||(+locId=0)
	..set hospID=$p($g(^CTLOC(locId)),"^",22)
	..q:(hospitalId'="")&&(hospID'=hospitalId)
	..s WLRowid=0,num=0,WLRowid1="",WLRowid2=""
	..f  s WLRowid=$o(^DHCWLAnaesthesia(0,"paadm",AdmRowid,WLRowid)) q:WLRowid=""  d
	...q:num=2
	...s opid=$p(^DHCWLAnaesthesia(WLRowid),"^",42)   ;手术名称ID
	...;i $d(^ORC("OPER",opid)) s opcode=$p(^ORC("OPER",opid),"^",1),opna=$p(^ORC("OPER",opid),"^",2),opjb=$p(^ORC("OPER",opid),"^",7)
    ...;q:(($zcvt($E(opcode,1,3),"U")="NO")) 
    ...;q:(($zcvt($E(opcode,1,1),"U")'="O") && (opjb=""))   //注意：新编码启用时用到，非手术的排除
    ...s num=num+1
	...i num=1 s WLRowid1=WLRowid
	...i num=2 s WLRowid2=WLRowid
	...q:WLRowid2=""
	...s ^TEMPDHCWL($j,AdmRowid)=WLRowid1_"^"_WLRowid2
	
	s num=0
	s AdmRowid="" f  s AdmRowid=$o(^TEMPDHCWL($j,AdmRowid )) q:AdmRowid=""  d
	.s WLID1=$p($g(^TEMPDHCWL($j,AdmRowid)),"^",1)
	.s WLID2=$p($g(^TEMPDHCWL($j,AdmRowid)),"^",2)
	.s lastOperationTime=$zd($p(^DHCWLAnaesthesia(WLID1),"^",10),3)  ;1麻醉日期,上次手术时间
	.s currentOperationTime=$zd($p(^DHCWLAnaesthesia(WLID2),"^",10),3)  ;2麻醉日期,本次手术时间
	.s homePage="" 	//首页完成情况
	
	.;取患者信息
	.s patInfoStr=##class(DtPortal.Common.PaadmService).GetPatInfo(AdmRowid)
	.s bedNo=$p(patInfoStr,"^",1)
	.s medicalRecordNo=$p(patInfoStr,"^",5)
	.s name=$p(patInfoStr,"^",2)
	.s sex=$p(patInfoStr,"^",3)
	.s age=$p(patInfoStr,"^",4)
	.s careDoctor=""   //主管医生
	.s DocDr=$P($g(^PAADM(AdmRowid)),"^",9)
	.i DocDr'="" s careDoctor=$p(^CTPCP(DocDr,1),"^",2)
	.s AdmissonDate=$p(^PAADM(AdmRowid),"^",6)   //本次入院日期
	.s AdmissonTime=$p(^PAADM(AdmRowid),"^",7)   //本次入院时间
	.s DiscDate=$p($g(^PAADM(AdmRowid)),"^",17)      //出院日期
	.;i DiscDate="" d
	.;.s inDayNum=EDate-AdmissonDate
	.;e  s inDayNum=DiscDate-AdmissonDate      //在院天数
	.;i AdmissonDate=DiscDate s inDayNum=1
	.s inDayNum=##class(DtPortal.Common.PaadmService).getInDayByInPat(AdmRowid)  //取在院天数统一方法
	.s num=num+1
	.;w num,!
	.//病案首页---首页完成情况
	.s IfFinish=""
	.s rs=##class(%ResultSet).%New("DtPortal.Doctor.EMRInfoService:GetEMRHDSD0011")
	.d rs.Execute(AdmRowid,homePageId)
	.f  Quit:'rs.Next()  d
	..f i=1:1:rs.GetColumnCount() d
	...s IfFinish=rs.%GetData(i)
	.d rs.Close()
	.s homePage=""
	.i IfFinish'="" s homePage="完成"
	.e  s homePage="未完成"
	.s ^||CacheTemp(repid,ind)=$lb(bedNo,name,sex,age,medicalRecordNo,inDayNum,careDoctor,lastOperationTime,currentOperationTime,homePage)
 	.s ind=ind+1
	k ^TEMPDHCWL($j)
	Quit $$$OK
}

// 根据日期获取非计划再手术患者信息

// 作者：DanPJ

// 日期：2016-03-21

// startDate:手术开始日期,endDate：手术结束日期

// 服务号：MD24.09.01

// d ##class(%ResultSet).RunQuery("DtPortal.MD.MD24LastWeekSummary","getUnplanReoperationByDate","2016-03-07","2016-03-21")

Query getUnplanReoperationByDate(startDate As %String, endDate As %String) As DtPortal.Query(ROWSPEC = "bedNo:%String,name:%String,sex:%String,age:%String,medicalRecordNo:%String,inDayNum:%String,careDoctor:%String,lastOperationTime:%String,currentOperationTime:%String,homePage:%String") [ SqlProc ]
{
}

ClassMethod getUnplanReoperationByDateExecute(ByRef qHandle As %Binary, startDate As %String, endDate As %String) As %Status
{
	//n (qHandle,startDate,endDate)
	Set repid1=$I(^||CacheTemp)
	Set ind1=1
	Set qHandle=$lb(0,repid1,0)
	
	//调用医政组的非计划再手术患者信息接口
    ;Set startDate=$zdh(startDate,3),endDate=$zdh(endDate,3)
	Set object = ##class(%ResultSet).%New("DHCMed.CRService.Service:QryUnplannedReoperation")
	Do object.Execute(startDate,endDate)
	While (object.Next()) {
		set EpisodeID=object.EpisodeID	//就诊号
		continue:EpisodeID=""
		//判断是否是本院患者
		set hospitalFlag=##class(DtPortal.MD.MD23CommonService).ifTHosPat(AdmRowid)
		continue:(hospitalFlag="")||(hospitalFlag=1)
		
		//科室Id
		set locDr=$p(^PAADM(admId),"^",4)
		continue:(locDr="")||(+locDr=0)
			
		//过滤掉科室为"国际医疗部"的数量
		set res=##class(DtPortal.MD.MD24LastWeekSummary).compareLocId(locId)
		continue:res=1	//1为国际医疗部
		
		set WLRowid=0,num=0,WLRowid1="",WLRowid2="",lastOperationTime="",currentOperationTime=""
		for
		{
			set WLRowid=$o(^DHCWLAnaesthesia(0,"paadm",EpisodeID,WLRowid)) 
			quit:WLRowid=""
			quit:num=2
			set opid=$p(^DHCWLAnaesthesia(WLRowid),"^",42)   //手术名称ID
			set num=num+1
			if num=1
			{
				set WLRowid1=WLRowid
				//1麻醉日期,上次手术时间
				set lastOperationTime=$zd($p(^DHCWLAnaesthesia(WLRowid1),"^",10),3) 
			}
			if num=2
			{
				set WLRowid2=WLRowid
				//麻醉日期,本次手术时间
				s currentOperationTime=$zd($p(^DHCWLAnaesthesia(WLRowid2),"^",10),3) 
			}
		} 
		//取病人信息
		set patInfoStr=##class(DtPortal.Common.PaadmService).GetPatInfo(EpisodeID) 
		set bedNo=$p(patInfoStr,"^",1)		//床号
		set name=object.PatName				//姓名
		set sex=object.Sex					//性别
		set age=object.Age					//年龄
		set medicalRecordNo=object.MedicareNo	//病案号
		set DiscDate=$p($g(^PAADM(EpisodeID)),"^",17)      //出院日期
		set AdmissonDate=$p(^PAADM(EpisodeID),"^",6)   		//本次入院日期
		/*
		if DiscDate=""
		{
			set inDayNum=$zdh(endDate,3)-AdmissonDate+1
		}
		else
		{
			set inDayNum=DiscDate-AdmissonDate+1					//住院天数
		}*/
		s inDayNum=##class(DtPortal.Common.PaadmService).getInDayByInPat(EpisodeID)  //取在院天数统一方法
		set careDoctor=$P($g(^PAADM(EpisodeID)),"^",9)					//主管医生
		set homePage=""							//首页完成情况,需要调用电子病历接口
		;w EpisodeID_""_bedNo_"^"_name_"^"_sex_"^"_age_"^"_medicalRecordNo_"^"_inDayNum_"^"_careDoctor_"^"_lastOperationTime_"^"_currentOperationTime_"^"_homePage,!
		
		set ^||CacheTemp(repid1,ind1)=$lb(bedNo,name,sex,age,medicalRecordNo,inDayNum,careDoctor,lastOperationTime,currentOperationTime,homePage)
 		set ind1=ind1+1
	}
	Quit $$$OK
}

// 根据病区id来获取该病区对应的科室Id

// w ##class(DtPortal.MD.MD24LastWeekSummary).getLocStrByWardId("37")

ClassMethod getLocStrByWardId(wardId)
{
	n (wardId)
	//根据科室id获取对应的所有科室
	s locStr=""
	s wardDr=$p(^PAWARD(wardId),"^",5)
	s subLink=0 ;^CTLOC(WARDLocationDR,"LINK",subLink) //获取所有的科室
	f  s subLink=$o(^CTLOC(wardDr,"LINK",subLink)) q:(subLink="")||(subLink=0)  d
	.s locDrId=^CTLOC(wardDr,"LINK",subLink)
	.q:(locDrId="")||(locDrId=0)
	.i locStr="" s locStr=locDrId
	.e  s locStr=locStr_"^"_locDrId
}

}
