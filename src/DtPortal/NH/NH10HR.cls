/// 名称:DtPortal.NH.NH10HR
/// 描述:查询护士长人力资源信息信息
/// 编写者：gm
/// 编写日期: 2014-12-10
Class DtPortal.NH.NH10HR Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// 名称:DtPortal.NH.NH10HR
/// CreatDate： 2014-12-10
/// Description: 查询病区护士信息明细列表
/// Input：  UserCode         
/// Return： 
/// 服务代码 NH10.01.01
/// d ##class(%ResultSet).RunQuery("DtPortal.NH.NH10HR","NH100101","059",5)
Query NH100101(UserCode As %String, WardId As %String) As DtPortal.Query(ROWSPEC = "name:%String,jobno:%String,sex:%String,birthday:%String,identity:%String,marriage:%String,regNo:%String,people:%String,polity:%String,dep:%String,transdate:%String,posttyp:%String")
{
}

ClassMethod NH100101Execute(ByRef qHandle As %Binary, UserCode As %String, WardId As %String) As %Status
{
	
	Set repid=$I(^||CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind=1

	Quit:WardId="" $$$OK
	
	d ##class(DtPortal.NH.NH10HR).GetNurseData(WardId)
	
	set nurID=""
	for
	{
		set nurID=$o(^||TMPPortalNH1000Common("NurseList",nurID))
		quit:nurID=""
		
		set nurData=##class(DtPortal.NH.NH10HR).GetNurInfo(nurID)
		
		set name=$p(nurData,"^",1)
		set jobno=$p(nurData,"^",2)
		set sex=$p(nurData,"^",3)
		set birthday=$p(nurData,"^",4)
		set marriage=$p(nurData,"^",5)
		set identity=$p(nurData,"^",6)
		set people=$p(nurData,"^",7)
		set polity=$p(nurData,"^",8)
		set transdate=$p(nurData,"^",9)
		
		set Data=$lb(name,jobno,sex,birthday,identity,marriage,regNo,people,polity,dep,transdate,posttyp)
	 	set ^||CacheTemp(repid,ind)=Data	
	 	set ind=ind+1
	}
	
	k ^||TMPPortalNH1000Common
  	q $$$OK
}

/// 查询护士职称
/// NH10.02.01
/// d ##class(%ResultSet).RunQuery("DtPortal.NH.NH10HR","NH100201","059",1)
Query NH100201(UserCode As %String, WardId As %String) As DtPortal.Query(ROWSPEC = "duty:%String,dutydesc:%String,num:%String")
{
}

ClassMethod NH100201Execute(ByRef qHandle As %Binary, UserCode As %String, WardId As %String) As %Status
{

	Set repid=$I(^||CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind=1
	
	Quit:WardId="" $$$OK
	
	d ##class(DtPortal.NH.NH10HR).GetNurseData(WardId)
	
	set RoleID=""
	for
	{
		set RoleID=$o(^||TMPPortalNH1000Common("NurseRole",RoleID))
		quit:RoleID=""
		
		set duty=RoleID
		set dutydesc=^||TMPPortalNH1000Common("NurseRole",RoleID,"Desc")
		set num=^||TMPPortalNH1000Common("NurseRole",RoleID)
		
		set Data=$lb(duty,dutydesc,num)
 		set ^||CacheTemp(repid,ind)=Data	
 		set ind=ind+1
	}
	
  	q $$$OK
}

/// 服务代码 NH10.02.02
/// 获取职称人员的详细信息
/// d ##class(%ResultSet).RunQuery("DtPortal.NH.NH10HR","NH100202","059","100",1)
Query NH100202(UserCode As %String, Id As %String, WardId As %String) As DtPortal.Query(ROWSPEC = "no:%String,name:%String")
{
}

ClassMethod NH100202Execute(ByRef qHandle As %Binary, UserCode As %String, Id As %String, WardId As %String) As %Status
{
	
	Set repid=$I(^||CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind=1
	
	Quit:WardId="" $$$OK
	
	d ##class(DtPortal.NH.NH10HR).GetNurseData(WardId)
	
	set NurID=""
	for
	{
		set NurID=$o(^||TMPPortalNH1000Common("NurseRole",Id,"Nur",NurID))
		quit:NurID=""
		
		set nurData=##class(DtPortal.NH.NH10HR).GetNurInfo(NurID)
		set no=$p(nurData,"^",2)
		set name=$p(nurData,"^",1)
		
		set Data=$lb(no,name)
 		set ^||CacheTemp(repid,ind)=Data	
 		set ind=ind+1
	}
 
  	q $$$OK
}

/// 获取年龄列表信息
/// 服务代码 NH10.03.01
/// d ##class(%ResultSet).RunQuery("DtPortal.NH.NH10HR","NH100301","411",5)
Query NH100301(UserCode As %String, WardId As %String) As DtPortal.Query(ROWSPEC = "num,desc,qty")
{
}

ClassMethod NH100301Execute(ByRef qHandle As %Binary, UserCode As %String, WardId As %String) As %Status
{
	
	Set repid=$I(^||CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind=1
	
	Quit:WardId="" $$$OK
	
	d ##class(DtPortal.NH.NH10HR).GetNurseData(WardId)
	
	set TypeID=""
	for
	{
		set TypeID=$o(^||TMPPortalNH1000Common("NurseAge",TypeID))
		quit:TypeID=""
		
		set qty=TypeID
		set desc=^||TMPPortalNH1000Common("NurseAge",TypeID,"Desc")
		set num=^||TMPPortalNH1000Common("NurseAge",TypeID)
		
		set Data=$lb(num,desc,qty)
 		set ^||CacheTemp(repid,ind)=Data	
 		set ind=ind+1
	}
	
 
  	q $$$OK
}

/// 服务代码 NH10.03.02
/// 查询病区护士某年龄阶段明细列表
/// d ##class(%ResultSet).RunQuery("DtPortal.NH.NH10HR","NH100302","059","1",1)
Query NH100302(UserCode As %String, Type As %String, WardId As %String) As DtPortal.Query(ROWSPEC = "no:%String,name:%String")
{
}

ClassMethod NH100302Execute(ByRef qHandle As %Binary, UserCode As %String, Type As %String, WardId As %String) As %Status
{
	
		Set repid=$I(^||CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind=1
	
	Quit:WardId="" $$$OK
	
	d ##class(DtPortal.NH.NH10HR).GetNurseData(WardId)
	
	set NurID=""
	for
	{
		set NurID=$o(^||TMPPortalNH1000Common("NurseAge",Type,"Nur",NurID))
		quit:NurID=""
		
		set nurData=##class(DtPortal.NH.NH10HR).GetNurInfo(NurID)
		set no=$p(nurData,"^",2)
		set name=$p(nurData,"^",1)
		
		set Data=$lb(no,name)
 		set ^||CacheTemp(repid,ind)=Data	
 		set ind=ind+1
	}
 
  	q $$$OK
}

ClassMethod CalAge(IBirth As %String, IToday As %String)
{
	//b ;1109
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

/// 服务代码 NH10.04.01
/// 查询病区护士学历详细信息
/// d ##class(%ResultSet).RunQuery("DtPortal.NH.NH10HR","NH100401","059",1)
Query NH100401(UserCode As %String, WardId As %String) As DtPortal.Query(ROWSPEC = "data")
{
}

ClassMethod NH100401Execute(ByRef qHandle As %Binary, UserCode As %String, WardId As %String) As %Status
{
	
	Set repid=$I(^||CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind=1
	
	k ^||TMPPortalNH100401
	
	Quit:WardId="" $$$OK
	
	d ##class(DtPortal.NH.NH10HR).GetNurseData(WardId)
	
	//初始学历
	set TypeID=""
	for
	{
		set TypeID=$o(^||TMPPortalNH1000Common("NurseEducationFirst",TypeID))
		quit:TypeID=""
		
		set nurID=""
		for
		{
			set nurID=$o(^||TMPPortalNH1000Common("NurseEducationFirst",TypeID,"Nur",nurID))
			quit:nurID=""
			
			set ^||TMPPortalNH100401(nurID,"First")=TypeID
		}
	}
	
	//最终学历
	set TypeID=""
	for
	{
		set TypeID=$o(^||TMPPortalNH1000Common("NurseEducationFinal",TypeID))
		quit:TypeID=""
		
		set nurID=""
		for
		{
			set nurID=$o(^||TMPPortalNH1000Common("NurseEducationFinal",TypeID,"Nur",nurID))
			quit:nurID=""
			
			set ^||TMPPortalNH100401(nurID,"Final")=TypeID
		}
	}
	
	set nurID=""
	for
	{
		set nurID=$o(^||TMPPortalNH100401(nurID))
		quit:nurID=""
		
		set First=$g(^||TMPPortalNH100401(nurID,"First"))
		set Final=$g(^||TMPPortalNH100401(nurID,"Final"))
		
		set nurData=##class(DtPortal.NH.NH10HR).GetNurInfo(nurID)
		
		set name=$p(nurData,"^",1)
		
		set FirstStr="",FinalStr=""
		set type=""
		for
		{
			set type=$o(^||TMPPortalNH1000Common("NurseEducationFirst",type))
			quit:type=""
			
	
			set typeID=type
			set:type["||" typeID=$p(type,"||",2)
			
			if type=First 
			{
				set a="First"_typeID_"*"_1
				
			}else
			{
				set a="First"_typeID_"*"_0
			}
			
			set:FirstStr'="" FirstStr=FirstStr_"^"_a
			set:FirstStr="" FirstStr=a
			
			if type=Final 
			{
				set b="Final"_typeID_"*"_1
			}else
			{
				set b="Final"_typeID_"*"_0
			}
			
			set:FinalStr'="" FinalStr=FinalStr_"^"_b
			set:FinalStr="" FinalStr=b
			
		}
		
		set data="name*"_name_"^"_FirstStr_"^"_FinalStr
		set Data=$lb(data)
		Set ^||CacheTemp(repid,ind)=Data
 		Set ind=ind+1
	}
	
	k ^||TMPPortalNH100401

	Quit $$$OK
}

/// 服务代码 NH10.04.02
/// 查询学历表头和总数
/// set obj=##class(DtPortal.NH.NH10HR).NH100402("411",1)
/// do $System.OBJ.Dump(obj)
ClassMethod NH100402(UserCode As %String, WardId As %String) As DtPortal.OutPut
{
	
	set $zt="NH100402Err"
	Set return=##Class(DtPortal.OutPut).%New()
	Set return.status = 1
	Set return.errMSG = ""
	Set return.data = "[]"
	if WardId="" 
	{
		Set return.errMSG = "病区为空！"
		quit return
	}
	d ##class(DtPortal.NH.NH10HR).GetNurseData(WardId)
	
	set retData="["
	//初始学历
	set TypeID=""
	for
	{
		set TypeID=$o(^||TMPPortalNH1000Common("NurseEducationFirst",TypeID))
		quit:TypeID=""
		
		set type=TypeID
		set:type["||" type=$p(TypeID,"||",2)
		
		set desc=^||TMPPortalNH1000Common("NurseEducationFirst",TypeID,"Desc")
		set num=+$g(^||TMPPortalNH1000Common("NurseEducationFirst",TypeID))
		set code="First"_type
		
		set jsonObj = ##class(DtPortal.Common.JsonObject).%New()
		d jsonObj.Put("Code",code)
		d jsonObj.Put("Desc",desc)
		d jsonObj.Put("Total",num)

		set JsonData=jsonObj.Json()	
		
		set:retData'="[" retData=retData_","_JsonData
		set:retData="[" retData=retData_JsonData
		
	}
	
	//最终学历
	set TypeID=""
	for
	{
		set TypeID=$o(^||TMPPortalNH1000Common("NurseEducationFinal",TypeID))
		quit:TypeID=""
		
		set type=TypeID
		set:type["||" type=$p(TypeID,"||",2)
		
		set desc=^||TMPPortalNH1000Common("NurseEducationFinal",TypeID,"Desc")
		set num=+$g(^||TMPPortalNH1000Common("NurseEducationFinal",TypeID))
		set code="Final"_type
		
		set jsonObj = ##class(DtPortal.Common.JsonObject).%New()
		d jsonObj.Put("Code",code)
		d jsonObj.Put("Desc",desc)
		d jsonObj.Put("Total",num)

		set JsonData=jsonObj.Json()	
		
		set:retData'="[" retData=retData_","_JsonData
		set:retData="[" retData=retData_JsonData
	}
	
	

	set retData=retData_"]"
		
	Set return.status = 1
	Set return.errMSG = ""
	Set return.data = retData
	quit return
	
NH100402Err
	Set return.status = -1
	Set return.errMSG = $zt
	Set return.data = ""
	quit return
}

/// 服务代码 NH10.05.01
/// 查询病区护士层级分布
/// d ##class(%ResultSet).RunQuery("DtPortal.NH.NH10HR","NH100501","059",1)
Query NH100501(UserCode As %String, WardId As %String) As DtPortal.Query(ROWSPEC = "duty,dutydesc,num")
{
}

ClassMethod NH100501Execute(ByRef qHandle As %Binary, UserCode As %String, WardId As %String) As %Status
{
	
	Set repid=$I(^||CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind=1
	
	Quit:WardId="" $$$OK
	
	d ##class(DtPortal.NH.NH10HR).GetNurseData(WardId)
	
	set TypeID=""
	for
	{
		set TypeID=$o(^||TMPPortalNH1000Common("NurseLevel",TypeID))
		quit:TypeID=""
		
		set duty=TypeID
		set dutydesc=^||TMPPortalNH1000Common("NurseLevel",TypeID,"Desc")
		set num=^||TMPPortalNH1000Common("NurseLevel",TypeID)
		
		set Data=$lb(duty,dutydesc,num)
 		set ^||CacheTemp(repid,ind)=Data	
 		set ind=ind+1
	}
	
 
  	q $$$OK
}

/// 服务代码 NH10.05.02
/// 获取层级人员的详细信息
/// d ##class(%ResultSet).RunQuery("DtPortal.NH.NH10HR","NH100502","059","100",1)
Query NH100502(UserCode As %String, Id As %String, WardId As %String) As DtPortal.Query(ROWSPEC = "no:%String,name:%String")
{
}

ClassMethod NH100502Execute(ByRef qHandle As %Binary, UserCode As %String, Id As %String, WardId As %String) As %Status
{
	
	Set repid=$I(^||CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind=1
	
	Quit:WardId="" $$$OK
	
	d ##class(DtPortal.NH.NH10HR).GetNurseData(WardId)
	
	set NurID=""
	for
	{
		set NurID=$o(^||TMPPortalNH1000Common("NurseLevel",Id,"Nur",NurID))
		quit:NurID=""
		
		set nurData=##class(DtPortal.NH.NH10HR).GetNurInfo(NurID)
		set no=$p(nurData,"^",2)
		set name=$p(nurData,"^",1)
		
		set Data=$lb(no,name)
 		set ^||CacheTemp(repid,ind)=Data	
 		set ind=ind+1
	}
 
  	q $$$OK
}

/// 服务代码 NH10.06.01
/// 查询病区护士工作年限分布
/// d ##class(%ResultSet).RunQuery("DtPortal.NH.NH10HR","NH100601","ys01",1)
Query NH100601(UserCode As %String, WardId As %String) As DtPortal.Query(ROWSPEC = "duty,dutydesc,num")
{
}

ClassMethod NH100601Execute(ByRef qHandle As %Binary, UserCode As %String, WardId As %String) As %Status
{
	
	Set repid=$I(^||CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind=1
	
	Quit:WardId="" $$$OK
	
	d ##class(DtPortal.NH.NH10HR).GetNurseData(WardId)
	
	set TypeID=""
	for
	{
		set TypeID=$o(^||TMPPortalNH1000Common("NurseWorkYear",TypeID))
		quit:TypeID=""
		
		set duty=TypeID
		set dutydesc=^||TMPPortalNH1000Common("NurseWorkYear",TypeID,"Desc")
		set num=^||TMPPortalNH1000Common("NurseWorkYear",TypeID)
		
		set Data=$lb(duty,dutydesc,num)
 		set ^||CacheTemp(repid,ind)=Data	
 		set ind=ind+1
	}
	
 
  	q $$$OK
}

/// 服务代码 NH10.06.02
/// 获取护士工作年限的详细信息
/// d ##class(%ResultSet).RunQuery("DtPortal.NH.NH10HR","NH100602","ys01","100",1)
Query NH100602(UserCode As %String, Id As %String, WardId As %String) As DtPortal.Query(ROWSPEC = "no:%String,name:%String")
{
}

ClassMethod NH100602Execute(ByRef qHandle As %Binary, UserCode As %String, Id As %String, WardId As %String) As %Status
{
	
	Set repid=$I(^||CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind=1
	
	Quit:WardId="" $$$OK
	
	d ##class(DtPortal.NH.NH10HR).GetNurseData(WardId)
	
	set NurID=""
	for
	{
		set NurID=$o(^||TMPPortalNH1000Common("NurseWorkYear",Id,"Nur",NurID))
		quit:NurID=""
		
		set nurData=##class(DtPortal.NH.NH10HR).GetNurInfo(NurID)
		set no=$p(nurData,"^",2)
		set name=$p(nurData,"^",1)
		
		set Data=$lb(no,name)
 		set ^||CacheTemp(repid,ind)=Data	
 		set ind=ind+1
	}
 
  	q $$$OK
}

/// Creator：     chengpeng
/// CreatDate：   2015-1-21
/// Description:  获取病区护士列表
/// Input：       无
/// Return：      ListObject
/// 服务编码：ND04.00.01
/// d ##class(DtPortal.NH.NH10HR).GetNurseData(5)
ClassMethod GetNurseData(WardId As %String) As %String
{
	
	
	Set $zt="GetNurseData"
	
	//取护理版本号,可在数据规则配置中配置  2 ext版护理版本  3 新版护理管理
	set NURMIS=##Class(DtPortal.Common.PublicService).getValueByCode("NURMIS")
	
	set NurseEducationType="",NurseEducationDesc=""
	k ^||TMPPortalNH1000Common
	
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
	 			continue:((WardID'="")&&(WardId'=WardID))
	 			
	 			set nurID=""
	 			for
	 			{
		 			set nurID=$O(^DHCMGNUR.MgPersonsI("Dep"," "_WardLoc,nurID))
		 			quit:nurID=""
		 			
		 			set objNur=##class(DHCMGNUR.MgPersons).%OpenId(nurID)
		 			continue:'$IsObject(objNur)
		 			
		 			set PersonID=objNur.PersonID 								//护士号
		 			set NurseRoleDesc=objNur.PersonAppDutyDR.CodeDesc		//护士职称
		 			
		 			set PersonBirthDay=objNur.PersonBirthDay					//护士生日
		 			set NurseLevelDesc=objNur.PersonBattery.CodeDesc				//护士层级
		 			set PersonWorkDateTime=objNur.PersonWorkDateTime			//工作年限
		 			set NurseEducationFirstDesc=objNur.PersonSchoolAgeDr.CodeDesc			//初始学历
		 			
		 			set NurseRoleID="",NurseEducationFirstID="",NurseEducationFinalID="",NurseLevelID=""
		 			set:NurseRoleDesc'="" NurseRoleID=objNur.PersonAppDutyDR.%Id()				//护士职称ID
		 			set:NurseEducationFirstDesc'="" NurseEducationFirstID=objNur.PersonSchoolAgeDr.%Id()		//护士初始学历ID
		 			set:NurseLevelDesc'="" NurseLevelID=objNur.PersonBattery.%Id()						//护士层级ID
		 			
		 			//保存初始学历类型
		 			if NurseEducationFirstID'=""
		 			{
			 			set aID="^"_NurseEducationFirstID_"^",aNurseEducationType="^"_NurseEducationType_"^"
			 			if aNurseEducationType'[aID
			 			{
				 			set:NurseEducationType'="" NurseEducationType=NurseEducationType_"^"_NurseEducationFirstID,NurseEducationDesc=NurseEducationDesc_"^"_NurseEducationFirstDesc
			 				set:NurseEducationType="" NurseEducationType=NurseEducationFirstID,NurseEducationDesc=NurseEducationFirstDesc
				 		}
			 		}else
			 		{
				 		set aID="^"_100_"^",aNurseEducationType="^"_NurseEducationType_"^"
			 			if aNurseEducationType'[aID
			 			{
				 			set:NurseEducationType'="" NurseEducationType=NurseEducationType_"^"_100,NurseEducationDesc=NurseEducationDesc_"^无"
			 				set:NurseEducationType="" NurseEducationType=100,NurseEducationDesc="无"
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
					if NurseEducationFinalDesc=""
		 			{
			 			set aID="^"_100_"^",aNurseEducationType="^"_NurseEducationType_"^"
			 			if aNurseEducationType'[aID
			 			{
				 			set:NurseEducationType'="" NurseEducationType=NurseEducationType_"^"_100,NurseEducationDesc=NurseEducationDesc_"^无"
			 				set:NurseEducationType="" NurseEducationType=100,NurseEducationDesc="无"
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
 			continue:((WardID'="")&&(WardId'=WardID))
 			
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
				set PersonWorkDateTime=obj.PerWorkDate										//工作年限
				
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
						set NurseLevelID=LeaveObj.NurLevel
					}
					set PerLevelDate=LeaveObj.LevelDate
					
				}
				
				//获取职称信息
				set NurseRoleDesc="",NurseRoleID="",PostDate=""
				set PostRowID=""
				for
				{
					set PostRowID=$O(^DHCNMG.HR.MgHireDutyI("ssid",nurID,PostRowID)) 
					quit:PostRowID=""
					
					set PostObj=##class(DHCNMG.HR.MgHireDuty).%OpenId(PostRowID)
					continue:'$IsObject(PostObj)
				
					continue:PostObj.HireStatus'="A"
					continue:PostObj.HireStDate<PostDate
					continue:PostObj.HireStDate>+$H
					
					if PostObj.HireDuty'=""
					{
						set NurseRoleDesc=##class(web.NurMgPersonComm).GetCommCode(PostObj.HireDuty)
						set NurseRoleID=PostObj.HireDuty
					}
					set PostDate=PostObj.HireStDate
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
						set NurseEducationFirstID=EduObj.EduAcademic
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
						set NurseEducationFinalID=EduObj.EduAcademic
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
		
		set ^||TMPPortalNH1000Common("NurseEducationFinal",ID,"Desc")=Desc
		set ^||TMPPortalNH1000Common("NurseEducationFirst",ID,"Desc")=Desc
	}
	
saveND04Data
	q:((+WardID)*(+nurID))=0
	set:NurseRoleDesc="" NurseRoleDesc="无",NurseRoleID=100
	set:NurseEducationFirstDesc="" NurseEducationFirstDesc="无",NurseEducationFirstID=100
	set:NurseLevelDesc="" NurseLevelDesc="无层级",NurseLevelID=100
	set:NurseEducationFinalDesc="" NurseEducationFinalDesc="无",NurseEducationFinalID=100
	set:PersonBirthDay="" ageDesc="未填写",NurseAgeID=100
	set:PersonWorkDateTime="" workYearDesc="未填写",NurseWorkYearID=100
	
	//存护士列表
	set ^||TMPPortalNH1000Common("NurseList",nurID)=""
	
	
	//存护士层级
	set ^||TMPPortalNH1000Common("NurseLevel",NurseLevelID,"Desc")=NurseLevelDesc
	set ^||TMPPortalNH1000Common("NurseLevel",NurseLevelID,"Nur",nurID)=""
	set ^||TMPPortalNH1000Common("NurseLevel",NurseLevelID)=+$g(^||TMPPortalNH1000Common("NurseLevel",NurseLevelID))+1
	
	//存护士职称
	set ^||TMPPortalNH1000Common("NurseRole",NurseRoleID,"Desc")=NurseRoleDesc
	set ^||TMPPortalNH1000Common("NurseRole",NurseRoleID,"Nur",nurID)=""
	set ^||TMPPortalNH1000Common("NurseRole",NurseRoleID)=+$g(^||TMPPortalNH1000Common("NurseRole",NurseRoleID))+1

	//存护士初始学历
	set ^||TMPPortalNH1000Common("NurseEducationFirst",NurseEducationFirstID,"Desc")=NurseEducationFirstDesc
	set ^||TMPPortalNH1000Common("NurseEducationFirst",NurseEducationFirstID,"Nur",nurID)=""
	set ^||TMPPortalNH1000Common("NurseEducationFirst",NurseEducationFirstID)=+$g(^||TMPPortalNH1000Common("NurseEducationFirst",NurseEducationFirstID))+1
	
	//存护士最终学历
	set ^||TMPPortalNH1000Common("NurseEducationFinal",NurseEducationFinalID,"Desc")=NurseEducationFinalDesc
	set ^||TMPPortalNH1000Common("NurseEducationFinal",NurseEducationFinalID,"Nur",nurID)=""
	set ^||TMPPortalNH1000Common("NurseEducationFinal",NurseEducationFinalID)=+$g(^||TMPPortalNH1000Common("NurseEducationFinal",NurseEducationFinalID))+1
	//存护士年龄
	
	set ageDesc=""
	if PersonBirthDay'=""
	{
		set ageStr="",NurseAgeID=0
		set:PersonBirthDay'="无" ageStr=..CalAge(PersonBirthDay,+$h)
		set age=$p(ageStr,"Y",1)
		set ageDesc=""
		set:age<20 ageDesc="20岁以下",NurseAgeID=1
		set:((age>=20)&&(age<30)) ageDesc="20至29",NurseAgeID=2
		set:((age>=30)&&(age<40)) ageDesc="30至39",NurseAgeID=3
		set:((age>=40)&&(age<50)) ageDesc="40至49",NurseAgeID=4
		set:age>=50 ageDesc="50及以上",NurseAgeID=5
	}

	set ^||TMPPortalNH1000Common("NurseAge",NurseAgeID,"Desc")=ageDesc
	set ^||TMPPortalNH1000Common("NurseAge",NurseAgeID,"Nur",nurID)=""
	set ^||TMPPortalNH1000Common("NurseAge",NurseAgeID)=+$g(^||TMPPortalNH1000Common("NurseAge",NurseAgeID))+1
	
	//存护士工作年限
	if PersonWorkDateTime'="" 
	{
		set workYearStr="",NurseWorkYearID=0
		set workYearStr=..CalAge(PersonWorkDateTime,+$h)

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
	set ^||TMPPortalNH1000Common("NurseWorkYear",NurseWorkYearID,"Desc")=workYearDesc
	set ^||TMPPortalNH1000Common("NurseWorkYear",NurseWorkYearID,"Nur",nurID)=""
	set ^||TMPPortalNH1000Common("NurseWorkYear",NurseWorkYearID)=+$g(^||TMPPortalNH1000Common("NurseWorkYear",NurseWorkYearID))+1
	
	q ""
	
GetNurseData
	
	Quit ""
}

/// 获取护士信息
/// d ##class(DtPortal.NH.NH10HR).GetNurInfo(1)
ClassMethod GetNurInfo(NurID) As %String
{
	s return=""
	
 	//取护理版本号,可在数据规则配置中配置  2 ext版护理版本  3 新版护理管理
	set NURMIS=##Class(DtPortal.Common.PublicService).getValueByCode("NURMIS")
	
	if NURMIS=2
	{
		set NurData=^DHCMGNUR.MgPersonsD(NurID)
		set name=$list(NurData,30)
	 	set jobno=$list(NurData,24)
	 	set sex=$list(NurData,49)
	 	if (sex'="")&(sex="1") s sex="女"
	 	if (sex'="")&(sex="2") s sex="男"
	 	if (sex'="")&(sex="3") s sex="未知"
	 	set birthday=$list(NurData,7)
	 	if birthday'="" s birthday=$zd(birthday,3)
	 	set identity=$list(NurData,26)
	 	set marriage=$list(NurData,61)
	 	if (marriage'="")&(marriage="1") s marriage="已婚"
	 	if (marriage'="")&(marriage="2") s marriage="未婚"
	 	if (marriage'="")&(marriage="3") s marriage="丧偶"
	 	if (marriage'="")&(marriage="4") s marriage="离婚"
	 	if (marriage'="")&(marriage="5") s marriage="其他"
	 	set regNo=$list(NurData,42)
	 	set people=$list(NurData,62)
	 	if people'="" s c=##class(DHCMGNUR.CommDictionarySub).%OpenId(people),people=c.CodeDesc
	 	set polity=$list(NurData,35)
	 	if polity'="" s b=##class(DHCMGNUR.CommDictionarySub).%OpenId(polity),polity=b.CodeDesc
	 	set dep=$list(NurData,12)
	 	set transdate=$list(NurData,64)
	 	if transdate'="" s transdate=$ZD(transdate,3)
	 	
	 	set return=name_"^"_jobno_"^"_sex_"^"_birthday_"^"_marriage_"^"_identity_"^"_people_"^"_polity_"^"_transdate
	}else
	{
		set obj=##class(DHCNMG.HR.MgPersons).%OpenId(NurID)
	 	quit:'$IsObject(obj) return
	 	
	 	set NurseName=obj.PerName 													//姓名
		set PerSexDR=##class(web.NurMgPersonComm).GetCommCode(obj.PerSexDR) 		//性别
		set PerID=obj.PerID															//工号
		set PersonBirthDay=obj.PerBirthday											//生日
		set PerMarriage=obj.PerMarriage												//婚姻
		set:PerMarriage'="" PerMarriage=##class(web.NurMgPersonComm).GetCommCode(PerMarriage)
		set PerRegNo=obj.PerRegNo													//证书号
		set PerNation=obj.PerNation													//民族
		set:PerNation'="" PerNation=##class(web.NurMgPersonComm).GetCommCode(PerNation)
		set PerPolitical=obj.PerPolitical											//政治面貌
		set:PerPolitical'="" PerPolitical=##class(web.NurMgPersonComm).GetCommCode(PerPolitical)
		set PerDepDate=obj.PerDepDate
		set:PerDepDate'="" PerDepDate=$ZD(PerDepDate,3)	
		set:PersonBirthDay'="" PersonBirthDay=$ZD(PersonBirthDay,3)	
		set return=NurseName_"^"_PerID_"^"_PerSexDR_"^"_PersonBirthDay_"^"_PerMarriage_"^"_PerRegNo_"^"_PerNation_"^"_PerPolitical_"^"_PerDepDate
	}
	
	q return
}

}
