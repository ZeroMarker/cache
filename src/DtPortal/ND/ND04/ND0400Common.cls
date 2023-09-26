/// 类名: DtPortal.ND.ND04.ND0400Common
/// Creator： 程鹏
/// CreatDate： 2018-12-14
/// Description: 查询护理部人力资源公共服务
Class DtPortal.ND.ND04.ND0400Common Extends %RegisteredObject
{

/// Creator：     chengpeng
/// CreatDate：   2015-1-21
/// Description:  获取人力资源echar图数据和表头
/// Input：       无
/// Return：      ListObject
/// 服务编码：ND04.00.01
/// set obj= ##class(DtPortal.ND.ND04.ND0400Common).GetTabChar()
ClassMethod GetTabChar() As DtPortal.OutPut
{
	
	#Dim return As DtPortal.OutPut
	Set return=##class(DtPortal.OutPut).%New()
	Set $zt="GetTabChar"
	
	set typeStr="NurseRole^NurseWorkYear^NurseAge^NurseEducationFirst^NurseEducationFinal^NurseLevel"
	set typeDesc="护士职务^工作年限^护士年龄^初始学历^最终学历^护士层级"
	
	d ..GetNurseData()
	
	set Obj = ##class(DtPortal.Common.JsonObject).%New()
	

		
	for typeIndex=1:1:$l(typeStr,"^")
	{
		set typeCode=$p(typeStr,"^",typeIndex)
		
		set JsonData="["
		
		set subCodeID="",subIndex=1
		
		for
		{
			set subCodeID=$o(^||TMPPortalND0400Common(typeCode,subCodeID))
			quit:subCodeID=""
			
			set subDesc=$g(^||TMPPortalND0400Common(typeCode,subCodeID))
			
			set num=0
			set WardID=""
			for
			{
				set WardID=$o(^||TMPPortalND0400Common(typeCode,subCodeID,WardID))
				quit:WardID=""
				
				set locNum=$g(^||TMPPortalND0400Common(typeCode,subCodeID,WardID))
				set num=num+locNum
			}
			
			set code="value"_subIndex
			set:subCodeID="100" code="valueNull"
			set:typeCode="NurseEducationFinal" subIndexF=subIndex+15,code="value"_subIndexF
			set:((typeCode="NurseEducationFirst")&&(subCodeID="100")) code="valueNull1"
			set:((typeCode="NurseEducationFinal")&&(subCodeID="100")) code="valueNull2"
			set jsonObj = ##class(DtPortal.Common.JsonObject).%New()
			d jsonObj.Put("code",code)
			d jsonObj.Put("name",subDesc)
			d jsonObj.Put("value",num)
			set:JsonData'="[" JsonData=JsonData_","_jsonObj.Json()
			set:JsonData="[" JsonData=JsonData_jsonObj.Json()
			set subIndex=subIndex+1
		}
		
		set JsonData=JsonData_"]"
			
		d Obj.Put(typeCode,JsonData)
			
		set JsonRetStr=Obj.Json()
		set JsonRetStr=$tr(JsonRetStr,"\","")
	}
	k ^||TMPPortalND0400Common
	Set return.status=1
	Set return.errMSG=""
	Set return.data=JsonRetStr
	Quit return
	
GetTabChar
	Set return.status=-1
	Set return.errMSG=$ZE
	Set return.data=""
	Quit return
}

/// Creator：     chengpeng
/// CreatDate：   2015-1-21
/// Description:  护士职务，学历，层级，表头，highchar数据获取
/// Input：       无
/// Return：      ListObject
/// 服务编码：ND04.00.01
/// d ##class(DtPortal.ND.ND04.ND0400Common).GetNurseData()
ClassMethod GetNurseData() As %String
{
	
	
	Set $zt="GetNurseData"
	
	//取护理版本号,可在数据规则配置中配置  2 ext版护理版本  3 新版护理管理
	set NURMIS=##Class(DtPortal.Common.PublicService).getValueByCode("NURMIS")
	
	set NurseEducationType="",NurseEducationDesc=""
	k ^||TMPPortalND0400Common
	
	if NURMIS=2
	{
		set ord=""
	 	for
	 	{
		 	set ord=$O(^DHCMGNUR.MgNurPerWardI("WardOrd",ord))
		 	quit:ord=""
		 	
		 	set ordID=""
		 	for
		 	{
			 	set ordID=$O(^DHCMGNUR.MgNurPerWardI("WardOrd",ord,ordID))
			 	quit:ordID=""
			 	
			 	set objNurWard=##class(DHCMGNUR.MgNurPerWard).%OpenId(ordID)
			 	continue:'$IsObject(objNurWard)
			 	
	 			set WardLoc=objNurWard.WardLoc
	 			
	 			continue:+WardLoc>9000				//离职区不统计
	 			set WardID=$o(^PAWARD(0,"WARD_LocationDR",WardLoc,""))
	 			continue:WardID=""
	 			set nurID=""
	 			for
	 			{
		 			set nurID=$O(^DHCMGNUR.MgPersonsI("Dep"," "_WardLoc,nurID))
		 			quit:nurID=""
		 			
		 			set objNur=##class(DHCMGNUR.MgPersons).%OpenId(nurID)
		 			continue:'$IsObject(objNur)
		 			
		 			set PersonID=objNur.PersonID 								//护士号
		 			set NurseRoleDesc=objNur.PersonheadshipDR.CodeDesc		//护士职务
		 			set PersonBirthDay=objNur.PersonBirthDay					//护士生日
		 			set NurseLevelDesc=objNur.PersonBattery.CodeDesc				//护士层级
		 			set PersonWorkDateTime=objNur.PersonWorkDateTime			//工作时间
		 			set NurseEducationFirstDesc=objNur.PersonSchoolAgeDr.CodeDesc			//初始学历
		 			
		 			set NurseRoleID="",NurseEducationFirstID="",NurseEducationFinalID="",NurseLevelID=""
		 			set:NurseRoleDesc'="" NurseRoleID=$p(objNur.PersonheadshipDR.%Id(),"||",2)				//护士职务ID
		 			set:NurseEducationFirstDesc'="" NurseEducationFirstID=$p(objNur.PersonSchoolAgeDr.%Id(),"||",2)		//护士初始学历ID
		 			set:NurseLevelDesc'="" NurseLevelID=$p(objNur.PersonBattery.%Id(),"||",2)						//护士层级ID
		 			
		 			//保存初始学历类型
		 			if NurseEducationFirstID'=""
		 			{
			 			set aID="^"_NurseEducationFirstID_"^",aNurseEducationType="^"_NurseEducationType_"^"
			 			if aNurseEducationType'[aID
			 			{
				 			set:NurseEducationType'="" NurseEducationType=NurseEducationType_"^"_NurseEducationFirstID,NurseEducationDesc=NurseEducationDesc_"^"_NurseEducationFirstDesc
			 				set:NurseEducationType="" NurseEducationType=NurseEducationFirstID,NurseEducationDesc=NurseEducationFirstDesc
				 		}
			 		}
		 		
		 			//最终学历
		 			set NurseEducationFinalDesc="" 
		 			set leaExpStDate=""
					for
					{
						set leaExpStDate=$O(^DHCMGNUR.MgNurLeaExpI("DataSort"," "_PersonID,leaExpStDate))
						quit:leaExpStDate=""
							
						set leaExpPar=""
						for
						{
							set leaExpPar=$O(^DHCMGNUR.MgNurLeaExpI("DataSort"," "_PersonID,leaExpStDate,leaExpPar))
							quit:leaExpPar=""
							
							set leaExpRw=""
							set leaExpRw=$O(^DHCMGNUR.MgNurLeaExpI("DataSort"," "_PersonID,leaExpStDate,leaExpPar,leaExpRw))
							quit:leaExpRw=""
							
							set LeaExpObj=##class(DHCMGNUR.MgNurLeaExp).%OpenId(leaExpPar_"||"_leaExpRw)
							continue:'$IsObject(LeaExpObj)
							
							set NurseEducationFinalDesc=LeaExpObj.PerSchoolAgeDr.CodeDesc
							continue:NurseEducationFinalDesc=""
							
							set:NurseEducationFinalDesc'="" NurseEducationFinalID=$p(LeaExpObj.PerSchoolAgeDr.%Id(),"||",2)		//护士最终学历ID
						
				 			set aID="^"_NurseEducationFinalID_"^",aNurseEducationType="^"_NurseEducationType_"^"
				 			if aNurseEducationType'[aID
				 			{
					 			set:NurseEducationType'="" NurseEducationType=NurseEducationType_"^"_NurseEducationFinalID,NurseEducationDesc=NurseEducationDesc_"^"_NurseEducationFinalDesc
				 				set:NurseEducationType="" NurseEducationType=NurseEducationFinalID,NurseEducationDesc=NurseEducationFinalDesc
					 		}
						}
						
					}
					d saveND04Data
		 		}
			}
		}
	}else
	{
		set ord=""
		for
		{
			set ord=$O(^DHCNMG.DB.MgWardD(ord))
			quit:ord=""
			
			set tWardObj=##class(DHCNMG.DB.MgWard).%OpenId(ord)
			continue:'$IsObject(tWardObj)
			
			set WardLoc=tWardObj.CTLocDR.%Id()
			continue:+WardLoc>9000				//离职区不统计
 			set WardID=$o(^PAWARD(0,"WARD_LocationDR",WardLoc,""))
 			continue:WardID=""
 			
 			set nurID=""
 			for
 			{
	 			set nurID=$O(^DHCNMG.HR.MgPersonsI("DepID"," "_ord,nurID))
	 			quit:nurID=""
	 			
	 			set obj=##class(DHCNMG.HR.MgPersons).%OpenId(nurID)
	 			continue:'$IsObject(obj)
	 			
	 			continue:obj.PerTypeDR'="N"
				continue:obj.PerStatus'="17||1"
				
				set NurseName=obj.PerName 													//姓名
				set PerSexDR=##class(web.NurMgPersonComm).GetCommCode(obj.PerSexDR) 		//性别
				set PersonBirthDay=obj.PerBirthday											//生日
				set PersonWorkDateTime=obj.PerWorkDate										//工作日期
				
				//获取层级信息
				set NurseLevelDesc="",PerLevelDate="",NurseLevelID=""
				set LeaveId="" 
				for  
				{
					set LeaveId=$O(^DHCNMG.HR.MgLevelI("ssid",nurID,LeaveId)) 
					quit:LeaveId=""
					
					set LeaveObj=##class(DHCNMG.HR.MgLevel).%OpenId(LeaveId)
					continue:'$IsObject(LeaveObj)
					
					continue:LeaveObj.LevelStatus'="A"
					continue:LeaveObj.LevelDate<PerLevelDate
					continue:LeaveObj.LevelDate>+$H
					if LeaveObj.NurLevel'=""
					{
						set NurseLevelDesc=##class(web.NurMgPersonComm).GetCommCode(LeaveObj.NurLevel)
						set NurseLevelID=$p(LeaveObj.NurLevel,"||",2)
					}
					set PerLevelDate=LeaveObj.LevelDate
					
				}
				
				//获取职务信息
				set NurseRoleDesc="",NurseRoleID="",PostDate=""
				set PostRowID=""
				for
				{
					set PostRowID=$O(^DHCNMG.HR.MgPostDutyI("ssid",nurID,PostRowID)) 
					quit:PostRowID=""
					
					set PostObj=##class(DHCNMG.HR.MgPostDuty).%OpenId(PostRowID)
					continue:'$IsObject(PostObj)
				
					continue:PostObj.PostStatus'="A"
					continue:PostObj.PostStDate<PostDate
					continue:PostObj.PostStDate>+$H
					
					if PostObj.PostDuty'=""
					{
						set NurseRoleDesc=##class(web.NurMgPersonComm).GetCommCode(PostObj.PostDuty)
						set NurseRoleID=$p(PostObj.PostDuty,"||",2)
					}
					set PostDate=PostObj.PostStDate
				}
				
				//学历
				set NurseEducationFirstDesc="",NurseEducationFinalDesc="",NurseEducationFirstID="",NurseEducationFinalID="",PerEducateStDate="",PerEducateEndDate=""
				set EduRowID=""
				for
				{
					set EduRowID=$O(^DHCNMG.HR.MgEducateI("ssid",nurID,EduRowID)) 
					quit:EduRowID=""
					
					set EduObj=##class(DHCNMG.HR.MgEducate).%OpenId(EduRowID)
					continue:'$IsObject(EduObj)
					continue:EduObj.EduStatus'="A"
					
					//初始学历
					if ((NurseEducationFirstDesc="")||(EduObj.EduEndDate<PerEducateStDate))&&(EduObj.EduRadio="25||1")
					{
						set NurseEducationFirstDesc=##class(web.NurMgPersonComm).GetCommCode(EduObj.EduAcademic)
						set NurseEducationFirstID=$p(EduObj.EduAcademic,"||",2)
						set EPerEducateStDate=EduObj.EduEndDate
					}
					
					set aID="^"_NurseEducationFirstID_"^",aNurseEducationType="^"_NurseEducationType_"^"
		 			if aNurseEducationType'[aID
		 			{
			 			set:NurseEducationType'="" NurseEducationType=NurseEducationType_"^"_NurseEducationFirstID,NurseEducationDesc=NurseEducationDesc_"^"_NurseEducationFirstDesc
		 				set:NurseEducationType="" NurseEducationType=NurseEducationFirstID,NurseEducationDesc=NurseEducationFirstDesc
			 		}
					
					//最终学历
					if (NurseEducationFinalDesc="")||(EduObj.EduEndDate>PerEducateEndDate) 
					{
						set NurseEducationFinalDesc=##class(web.NurMgPersonComm).GetCommCode(EduObj.EduAcademic)
						set NurseEducationFinalID=$p(EduObj.EduAcademic,"||",2)
						set PerEducateEndDate=EduObj.EduEndDate
					}
					
					set aID="^"_NurseEducationFinalID_"^",aNurseEducationType="^"_NurseEducationType_"^"
		 			if aNurseEducationType'[aID
		 			{
			 			set:NurseEducationType'="" NurseEducationType=NurseEducationType_"^"_NurseEducationFinalID,NurseEducationDesc=NurseEducationDesc_"^"_NurseEducationFinalDesc
		 				set:NurseEducationType="" NurseEducationType=NurseEducationFinalID,NurseEducationDesc=NurseEducationFinalDesc
			 		}

					
				}	
				
				d saveND04Data
	 		}  
		}
	}
	
	
	//统一初始学历和最终学历,使数据列数保持一致
	for index=1:1:$l(NurseEducationType,"^")
	{
		set ID=$p(NurseEducationType,"^",index)
		continue:ID=""
		set Desc=$p(NurseEducationDesc,"^",index)
		
		set ^||TMPPortalND0400Common("NurseEducationFinal",ID)=Desc
		set ^||TMPPortalND0400Common("NurseEducationFirst",ID)=Desc
	}
	
saveND04Data
	q:((+WardID)*(+nurID))=0
	set:NurseRoleDesc="" NurseRoleDesc="未填写",NurseRoleID=100
	set:NurseEducationFirstDesc="" NurseEducationFirstDesc="无",NurseEducationFirstID=100
	set:NurseLevelDesc="" NurseLevelDesc="未填写",NurseLevelID=100
	set:NurseEducationFinalDesc="" NurseEducationFinalDesc="无",NurseEducationFinalID=100
	set:PersonBirthDay="" ageDesc="未填写",NurseAgeID=100
	set:PersonWorkDateTime="" workYearDesc="未填写",NurseWorkYearID=100
	
	//存护士层级
	set ^||TMPPortalND0400Common("NurseLevel",NurseLevelID)=NurseLevelDesc
	set ^||TMPPortalND0400Common("NurseLevel",NurseLevelID,WardID,nurID)=""
	set ^||TMPPortalND0400Common("NurseLevel",NurseLevelID,WardID)=+$g(^||TMPPortalND0400Common("NurseLevel",NurseLevelID,WardID))+1
	
	//存护士职务
	set ^||TMPPortalND0400Common("NurseRole",NurseRoleID)=NurseRoleDesc
	set ^||TMPPortalND0400Common("NurseRole",NurseRoleID,WardID,nurID)=""
	set ^||TMPPortalND0400Common("NurseRole",NurseRoleID,WardID)=+$g(^||TMPPortalND0400Common("NurseRole",NurseRoleID,WardID))+1

	//存护士初始学历
	set ^||TMPPortalND0400Common("NurseEducationFirst",NurseEducationFirstID)=NurseEducationFirstDesc
	set ^||TMPPortalND0400Common("NurseEducationFirst",NurseEducationFirstID,WardID,nurID)=""
	set ^||TMPPortalND0400Common("NurseEducationFirst",NurseEducationFirstID,WardID)=+$g(^||TMPPortalND0400Common("NurseEducationFirst",NurseEducationFirstID,WardID))+1
	
	//存护士最终学历
	set ^||TMPPortalND0400Common("NurseEducationFinal",NurseEducationFinalID)=NurseEducationFinalDesc
	set ^||TMPPortalND0400Common("NurseEducationFinal",NurseEducationFinalID,WardID,nurID)=""
	set ^||TMPPortalND0400Common("NurseEducationFinal",NurseEducationFinalID,WardID)=+$g(^||TMPPortalND0400Common("NurseEducationFinal",NurseEducationFinalID,WardID))+1
	//存护士年龄
	if PersonBirthDay'=""
	{
		set ageStr="",NurseAgeID=0
		set:PersonBirthDay'="无" ageStr=..getAge(PersonBirthDay,+$h)
		set age=$p(ageStr,"Y",1)
		set ageDesc=""
		set:age<20 ageDesc="20岁以下",NurseAgeID=1
		set:((age>=20)&&(age<30)) ageDesc="20至29",NurseAgeID=2
		set:((age>=30)&&(age<40)) ageDesc="30至39",NurseAgeID=3
		set:((age>=40)&&(age<50)) ageDesc="40至49",NurseAgeID=4
		set:age>=50 ageDesc="50及以上",NurseAgeID=5
	}
	set ^||TMPPortalND0400Common("NurseAge",NurseAgeID)=ageDesc
	set ^||TMPPortalND0400Common("NurseAge",NurseAgeID,WardID,nurID)=""
	set ^||TMPPortalND0400Common("NurseAge",NurseAgeID,WardID)=+$g(^||TMPPortalND0400Common("NurseAge",NurseAgeID,WardID))+1
	
	//存护士工作年限
	if PersonWorkDateTime'="" 
	{
		set workYearStr="",NurseWorkYearID=0
		set workYearStr=..getAge(PersonWorkDateTime,+$h)

		set workYear=$p(workYearStr,"Y",1)
		set workYearDesc=""
		set:workYear<=1 workYearDesc="一年以内",NurseWorkYearID=1
		set:workYear=2 workYearDesc="两年",NurseWorkYearID=2
		set:workYear=3 workYearDesc="三年",NurseWorkYearID=3
		set:workYear=4 workYearDesc="四年",NurseWorkYearID=4
		set:workYear=5 workYearDesc="五年",NurseWorkYearID=5
		set:workYear=6 workYearDesc="六年",NurseWorkYearID=6
		set:workYear=7 workYearDesc="七年",NurseWorkYearID=7
		set:workYear=8 workYearDesc="八年",NurseWorkYearID=8
		set:workYear=9 workYearDesc="九年",NurseWorkYearID=9
		set:workYear>=10 workYearDesc="十年及以上",ID=10	
	}
	set ^||TMPPortalND0400Common("NurseWorkYear",NurseWorkYearID)=workYearDesc
	set ^||TMPPortalND0400Common("NurseWorkYear",NurseWorkYearID,WardID,nurID)=""
	set ^||TMPPortalND0400Common("NurseWorkYear",NurseWorkYearID,WardID)=+$g(^||TMPPortalND0400Common("NurseWorkYear",NurseWorkYearID,WardID))+1
	
	q ""
	
GetNurseData
	
	Quit ""
}

// 获取年龄

/// w ##class(DtPortal.ND.ND04.ND0400Common).getAge(12345,12456)
ClassMethod getAge(IBirth As %String, IToday As %String)
{

    s IBirth=$g(IBirth),IToday=$g(IToday)
    i IBirth>2980000 s IBirth=""
    i IBirth<0 s IBirth=""
    q:'$G(IBirth) ""
    s XBirth=$ZD(IBirth)
    s XToday=$ZD(IToday)
    s AgeMth=XToday-XBirth
    s AgeDay=$p(XToday,"/",2)-$p(XBirth,"/",2)
    s CurrYear=$p(XToday,"/",3) s:CurrYear<100 CurrYear=CurrYear+1900
    s BirthYear=$p(XBirth,"/",3) s:BirthYear<100 BirthYear=BirthYear+1900
    s AgeYear=CurrYear-BirthYear
    i AgeDay<0 d
        . s AgeMth=AgeMth-1
	    . s AgeDay=AgeDay+$p("31,31,28,31,30,31,30,31,31,30,31,30,31",",",+XToday)
	    . q:XToday'=2
	    . s:((CurrYear#4)=0)&(((CurrYear#100)'=0)!((CurrYear#400)=0)) AgeDay=AgeDay+1
	i AgeMth<0 s AgeMth=AgeMth+12,AgeYear=AgeYear-1
	s $P(AgeYr,"|",12)=AgeYear
	s reage=$p(AgeYr,"|",12)_"Y "_AgeMth_"M "_AgeDay_"D"
	q reage
}

}
