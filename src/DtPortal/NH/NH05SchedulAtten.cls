/// 名称:DtPortal.NH.NH05SchedulAtten
/// 描述:查询病区排班与考勤信息
/// 编写者：程鹏
/// 编写日期: 2018-11-28
Class DtPortal.NH.NH05SchedulAtten Extends %RegisteredObject [ ProcedureBlock ]
{

/// 查询病区病区班次信息
/// Input：  UserCode  		用户工号
/// 			 date 			日期 格式如 2018-11-28
/// 			 WardId     	病区 pac_ward表Id
/// 编写者：程鹏
/// 编写日期: 2018-11-28
/// NH05.01.01
/// d ##class(%ResultSet).RunQuery("DtPortal.NH.NH05SchedulAtten","NH050101","ys01","2018-11-30",1)
Query NH050101(UserCode As %String, date As %String, WardId As %String) As DtPortal.Query(ROWSPEC = "PostCode,name,PostType")
{
}

ClassMethod NH050101Execute(ByRef qHandle As %Binary, UserCode As %String, date As %String, WardId As %String) As %Status
{
	
	Set repid=$I(^||CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind=1
	Quit:date="" $$$OK
	Quit:WardId="" $$$OK
	
	set wardLocId=$p(^PAWARD(WardId),"^",5)
	Quit:wardLocId="" $$$OK
	
	//取护理版本号,可在数据规则配置中配置  2 ext版护理版本  3 新版护理管理
	set NURMIS=##Class(DtPortal.Common.PublicService).getValueByCode("NURMIS")

	
	if NURMIS=2
	{
		set date = $zdh(date,3)
		set AJRowId="" f  s AJRowId = $O(^DHCMGNUR.MgNurArrangeJobI("AJWardDateIdx"," "_wardLocId," "_date,AJRowId)) q:AJRowId=""  do
		.set AJObject = ##class(DHCMGNUR.MgNurArrangeJob).%OpenId(AJRowId)
		.q:'$IsObject(AJObject)
		.set AJNurse = AJObject.AJNurseDR
		.s AJTypes = AJObject.AJType
		.d AJObject.%Close()
		.set PersonRowId = $O(^DHCMGNUR.MgPersonsI("SSID"," "_AJNurse,"")) 
		.i PersonRowId'="" d
		..s a=^DHCMGNUR.MgPersonsD(PersonRowId)
		..s NurseName=$list(a,30)
		..set AJTypes = AJObject.AJType
		..set AJJobInterval=AJObject.AJJobInterval
		..for i=1:1:$L(AJTypes,",") do
		...set AJType = $P(AJTypes,",",i)
		...q:AJType'="Post"
		...set:($P(AJJobInterval,",",i)'="H") NurseName=NurseName_"("_$P(AJJobInterval,",",i)_")"
		...set AJCode = $P(AJObject.AJCodeDR,",",i)
		...set ^||TMPPortalNH050104(AJCode,NurseName)=""
		
		set AJCode=""
		for
		{
			set AJCode=$o(^||TMPPortalNH050104(AJCode))
			quit:AJCode=""
			
			set PostType=""
			set PostObj = ##class(DHCMGNUR.MgNurPost).%OpenId(AJCode)
			continue:'$IsObject(PostObj)
			set PostCode = PostObj.PostCode
			try 
			{
				set PostTypeID=PostObj.PostType  							 //班次名称
				s PostTypeObj=##class(DHCMGNUR.CommDictionarySub).%OpenId(PostTypeID)
				continue:'$IsObject(PostTypeObj)
				s PostType=PostTypeObj.CodeDesc
				d PostTypeObj.%Close()
			}catch exp
			{
				set PostType="白班"
				set PostIsNight=PostObj.PostIsNight
				set:PostIsNight="Y" PostType="夜班"
			}
			d PostObj.%Close()
		
			set name=""
			set NurseName=""
			for
			{
				set NurseName=$o(^||TMPPortalNH050104(AJCode,NurseName))
				quit:NurseName=""
				
				set:name'="" name=name_","_NurseName
				set:name="" name=NurseName
			}
			s Data=$lb(PostCode,name,PostType)
		 	s ^||CacheTemp(repid,ind)=Data	
		 	s ind=ind+1
		}
	}else
	{
		Set rset = ##class(%ResultSet).%New("web.NurMgOutInterface:FindWardDateArgList")
		Do rset.Execute(WardId,date)
	
		While (rset.Next()) {
			set NurName=rset.Data("NurName")			//护士姓名
			set ArgPost=rset.Data("ArgPost")			//班次类型  多个班次用 "「"分割
			set ArgTime=rset.Data("ArgTime")			//班次时间段 多班次用  "「",一班次多时间段用","分割
			set IsNight=rset.Data("IsNight")			//是否夜班  多班次用  "「"
			
			continue:NurName=""
			set length=$l(ArgPost,"「")
			for index=1:1:length
			{
				set Post=$p(ArgPost,"「",index)
				set IsN=$p(IsNight,"「",index)
				continue:Post=""
				
				set ^||TMPPortalNH050104(Post)=IsN
				set ^||TMPPortalNH050104(Post,NurName)=""
			}
		}
		
		set PostCode=""
		for
		{
			set PostCode=$o(^||TMPPortalNH050104(PostCode))
			quit:PostCode=""
			
			set name=""
			set NurseName=""
			for
			{
				set NurseName=$o(^||TMPPortalNH050104(PostCode,NurseName))
				quit:NurseName=""
				
				set:name'="" name=name_","_NurseName
				set:name="" name=NurseName
			}
			
			set IsNight=+$g(^||TMPPortalNH050104(PostCode))
			set PostType="白班"
			set:IsNight=1 PostType="夜班"
			
			s Data=$lb(PostCode,name,PostType)
		 	s ^||CacheTemp(repid,ind)=Data	
		 	s ind=ind+1
		}
	}
	
	k ^||TMPPortalNH050104
 
  	q $$$OK
}

/// Description: 查询病区某月考勤信息
/// Input：  UserCode  		用户工号
/// 		 YearMonth 			日期 格式如 2018-11
/// 		 WardId     	病区 pac_ward表Id      
/// Return： 
/// 编写者：程鹏
/// 编写日期: 2018-11-28
/// 服务代码 NH05.02.01
/// d ##class(%ResultSet).RunQuery("DtPortal.NH.NH05SchedulAtten","NH050201","hs01","2018-11",1)
Query NH050201(UserCode As %String, YearMonth As %String, WardId As %String) As DtPortal.Query(ROWSPEC = "NurseRowId:%String,NurseName:%String,retTotalNum:%String,retCountNight:%String,retCountDay:%String,retCountSick:%String,retCountBirth:%String,retCountOverTime:%String")
{
}

ClassMethod NH050201Execute(ByRef qHandle As %Binary, UserCode As %String, YearMonth As %String, WardId As %String) As %Status
{
	
	Set repid=$I(^||CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind=1
	Quit:YearMonth="" $$$OK
	Quit:WardId="" $$$OK
	
	//取护理版本号,可在数据规则配置中配置  2 ext版护理版本  3 新版护理管理
	set NURMIS=##Class(DtPortal.Common.PublicService).getValueByCode("NURMIS")
	
	set wardLocId=$p(^PAWARD(WardId),"^",5)
	Quit:wardLocId="" $$$OK
	
	if NURMIS=2
	{
		set startDate=##Class(DtPortal.Common.PublicService).getFirstDayOfMonth(YearMonth,2)
		set endDate=##Class(DtPortal.Common.PublicService).getLastDayOfMonth(YearMonth,2)
		
		set NurseRowId=""
		for
		{
			set NurseRowId=$O(^DHCMGNUR.MgPersonsI("Dep"," "_wardLocId,NurseRowId))
			quit:NurseRowId=""
			
			continue:'$d(^DHCMGNUR.MgPersonsD(NurseRowId))
			set PersonsObj=##class(DHCMGNUR.MgPersons).%OpenId(NurseRowId)
			continue:'$IsObject(PersonsObj)
			set PersonID=PersonsObj.PersonID
			set NurseName=PersonsObj.PersonName								//姓名
			set PersonTransDate=PersonsObj.PersonTransDate				//调入科室日期
			
			set personType=""
			try 
			{
				set PersonInternEndDate=PersonsObj.PersonInternEndDate 		//实习进修结束日期
				set personType =  PersonsObj.PersonType2					//人员类型 （正式[N]、进修[S]、实习[P]）
				
				continue:((personType'="N")&&(PersonInternEndDate<date))  	//人员类型为进行 实习时,结束日期比日期小,退出

			}catch exp
			{
			}
			d PersonsObj.%Close()
			
		    set retTotalNum=0,retCountNight=0,retCountDay=0,retCountSick=0,retCountBirth=0,retCountOverTime=0
		    
		    for date=startDate:1:endDate
		    {
			    set nurType=""
			    for
			    {
				    set nurType=$o(^DHCMGNUR.MgNurArrangeJobI("AJNurDateIndex"," "_wardLocId,nurType))
				    quit:nurType=""
				   
				    set NurJobID=""
				    for
				    {
					    set NurJobID=$o(^DHCMGNUR.MgNurArrangeJobI("AJNurDateIndex"," "_wardLocId,nurType," "_PersonID," "_date,NurJobID))
					    quit:NurJobID=""
				    	
					    set AJObject = ##class(DHCMGNUR.MgNurArrangeJob).%OpenId(NurJobID)
					    continue:'$IsObject(AJObject)
					    set AJTypes = AJObject.AJType						//排班类型
					    set AJCodeDR=AJObject.AJCodeDR						//排班代码
					    set AJJobInterval=AJObject.AJJobInterval			//班时段
					    d AJObject.%Close()
						for i=1:1:$L(AJTypes,",")
						{
							set AJType = $P(AJTypes,",",i)
							set AJCode=$P(AJCodeDR,",",i) 
							continue:AJCode=""
							//在岗
						
							if AJType="Post"
							{
								set Interval=$P(AJJobInterval,",",i) 
							
								set banNum=1
								set:Interval'="H" banNum=0.5							
							
								//取班次信息
								set PostObject = ##class(DHCMGNUR.MgNurPost).%OpenId(AJCode)
								continue:'$IsObject(AJObject)
								set PostCode = PostObject.PostCode						//班次code
								try 
								{
									set PostHour = PostObject.PostHours		//班次小时数
									set PostType=PostObject.PostType 
									if PostType'=""
									{
										set PostIsNightDesc=""
										//取班次类型描述
										set PostTypeObj=##class(DHCMGNUR.CommDictionarySub).%OpenId(PostType)
										set:$IsObject(PostTypeObj) PostIsNightDesc=PostTypeObj.CodeDesc
										d PostTypeObj.%Close()
										set:PostIsNightDesc["白" retCountDay=retCountDay+banNum
										set:PostIsNightDesc["夜" retCountNight=retCountNight+banNum
								
									}
								}catch exp
								{
									set PostHour = PostObject.PostHourNum
									set PostIsNight=PostObject.PostIsNight
									set:PostIsNight="Y" retCountDay=retCountDay+1
									set:PostIsNight'="Y" retCountNight=retCountNight+1
								}
								    					//班次类型
								d PostObject.%Close()
							
							
							
								
								set retTotalNum=retTotalNum+banNum
						
							}elseif ((AJType="Holiday")||(AJType="Rest"))				//休假
							{
								//去休假信息
								set HolidayCodeObj=##class(DHCMGNUR.MgNurHolidayCode).%OpenId(AJCode)
								continue:'$IsObject(HolidayCodeObj)
								set HolidayDesc=HolidayCodeObj.HolidayDesc					//休假描述
								d HolidayCodeObj.%Close()
							
								set:HolidayDesc="病假" retCountSick=retCountSick+1
								set:HolidayDesc="产假" retCountBirth=retCountBirth+1
							}elseif AJType="OverTime"										//加班
							{
								set retCountOverTime=retCountOverTime+1
							}
						
						}
					}
				}

			}
		    set Data=$lb(NurseRowId,NurseName,retTotalNum,retCountNight,retCountDay,retCountSick,retCountBirth,retCountOverTime)
	 		set ^||CacheTemp(repid,ind)=Data	
	 		set ind=ind+1
		    
		}
	}else
	{
		Set rset = ##class(%ResultSet).%New("web.NurMgOutInterface:FindWorkCountList")
		Do rset.Execute(WardId,YearMonth)
	
		While (rset.Next()) {
			set NurseName=rset.Data("NurName")					//护士姓名
			set retTotalNum=rset.Data("ArgCount")				//排班次数
			set retCountDay=rset.Data("DayCount")				//白班次数
			set retCountNight=rset.Data("NightCount")			//夜班次数
			set ArgHour=rset.Data("ArgHour")					//总小时数
			set DayHour=rset.Data("DayHour")					//白班小时数
			set NightHour=rset.Data("NightHour")				//夜班小时数
			set CasualLeave=rset.Data("CasualLeave")			//事假
			set retCountBirth=rset.Data("MaternityLeave")		//产假
			set retCountSick=rset.Data("SickLeave")				//病假
			set IsNight=rset.Data("FamilyLeave")				//探亲假
			set OtherLeave=rset.Data("OtherLeave")				//其他请假
			try 
			{
				set retCountOverTime=rset.Data("OvertimeCount")		//加班
			}catch exp
			{
				set retCountOverTime=0
			}
			set NurseRowId=""
			set Data=$lb(NurseRowId,NurseName,retTotalNum,retCountNight,retCountDay,retCountSick,retCountBirth,retCountOverTime)
	 		set ^||CacheTemp(repid,ind)=Data	
	 		set ind=ind+1
		}
	}
	
	
	
  	quit $$$OK
}

}
