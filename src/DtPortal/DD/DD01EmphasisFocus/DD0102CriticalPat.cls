/// 危重患者明细服务
Class DtPortal.DD.DD01EmphasisFocus.DD0102CriticalPat Extends %RegisteredObject
{

/// Creator：     chengpeng
/// CreatDate：   2015-12-17
/// Description:  DD01.02.01 查询科室危重患者列表
/// Input：       UserCode    :  用户工号
/// Input：       DocID   	  :  按照主管医生筛选
/// Return：     危重患者信息
/// do ##class(%Library.ResultSet).RunQuery("DtPortal.DD.DD01EmphasisFocus.DD0102CriticalPat","D010201CriticalPatInfo","601","359")
Query D010201CriticalPatInfo(UserCode As %String, locGroupID As %String, DocID As %String = "", codes As %String = "") As DtPortal.Query(ROWSPEC = "BedNum:%String,Name:%String,Sex:%String,Age:%String,MedicareNo:%String,VitalSign:%String,CareLevel:%String,EpisodeID:%String,AdmDocID:%String,DocLoc:%String,ManagerDoc:%String,DiagnoseDesc:%String,TempValue,BreatheValue,PulseValue,BloodPressureValue,EMRDocID,EMRInstanceID,locID,EMREpisodeID,UserID,PatientID")
{
}

ClassMethod D010201CriticalPatInfoExecute(ByRef qHandle As %Binary, UserCode As %String, locGroupID As %String, DocID As %String = "", codes As %String = "") As %Status
{
	Set repid=$I(^||CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind=1
	set DocLocStr=##class(DtPortal.DD.DD00PublicService).getDDloc(locGroupID,"I")
	Quit:DocLocStr="" $$$OK
	//根据配置医嘱code取医嘱ID,全部护理
	set ArcIDsNur=##Class(DtPortal.Configure.arcim).getArcImID("NURSELEVEL",1)
	
	/*
	set ArcimCode=""
	
	if (codes=""){
		//取病危和病重医嘱
		set SeriouslyCode=""
		set SeriouslyCode=##Class(DtPortal.Configure.arcim).getArcImID("SERIOUSLY",2)	//获取code
		;set SeriouslyCode=##class(Nur.ImageSet).GetArcCode("SERIOUSLY")
		set CriticallyCode=""
		;set CriticallyCode=##class(Nur.ImageSet).GetArcCode("CRITICALLY")
		set CriticallyCode=##Class(DtPortal.Configure.arcim).getArcImID("CRITICALLY",2)	//获取code
		if (SeriouslyCode="")||(CriticallyCode="")  Quit $$$OK
		set ArcimCode=SeriouslyCode_"^"_CriticallyCode
	} else {
		set:codes="SERIOUSLYCRITICALLY" codes="SERIOUSLY^CRITICALLY"
		for codeIndex=1:1:$l(codes,"^")
		{
			set code=$p(codes,"^",codeIndex)
			continue:code=""
			set tempArcCode=##Class(DtPortal.Configure.arcim).getArcImID(code,2)
			if (ArcimCode=""){
				set ArcimCode=tempArcCode
			}else{
				set ArcimCode=ArcimCode_"^"_tempArcCode
			}
			
		}
	}
	*/
	
	if ((codes="")||(codes="SERIOUSLYCRITICALLY")){
		set codes="SERIOUSLY^CRITICALLY"
	}
	
	//1-病危 2-病重
	set arcimIDs=##class(DtPortal.Configure.arcim).getArcImID(codes,1)
	
	//b ;009
	for index=1:1:$l(DocLocStr,"^")
	{
		set DocLoc=$p(DocLocStr,"^",index)
		continue:DocLoc=""
		Set Date=""
		For  
		{	
			Set Date=$O(^PAADMi("AdmTypeCurrLoc","I",DocLoc,Date)) 
			
			Quit:(Date="")
			
			Set Time=""
			for
			{
				Set Time=$O(^PAADMi("AdmTypeCurrLoc","I",DocLoc,Date,Time)) 
				Quit:(Time="")
				
				set EpisodeID=0
				for
				{
					Set EpisodeID=$O(^PAADMi("AdmTypeCurrLoc","I",DocLoc,Date,Time,EpisodeID)) 
					Quit:(EpisodeID="")
					
					
					Set AdmObj=##class(DHCMed.Base.PatientAdm).GetObjById(EpisodeID)
					quit:'$IsObject(AdmObj)
					
					set PatientID=AdmObj.PatientID
					set CPDocID=AdmObj.DoctorID
					set AdmDocID=""
					set:CPDocID'="" AdmDocID=$O(^SSU("SSUSR",0,"CTPCP",CPDocID,""),-1)
					set ManagerDoc=AdmObj.DoctorName
					
					continue:(DocID'="")&&(AdmDocID'=DocID)		
					
					set UserID=AdmDocID
					
					set CareLevel=""
					set OrderRowid=$o(^OEORD(0,"Adm",+EpisodeID,""))
					continue:OrderRowid=""
					s OEORISttDate=""
					s CriticalFlag=0
		
					//s CriticalFlag=##class(web.DHCSETIMAGE).IfOrddailyExist(EpisodeID,ArcimCode)  //---医嘱项id
					//continue:CriticalFlag=0 //没有危重医嘱就退出
					
					s ArcNums=##class(DtPortal.Common.PaadmService).getArcNums(EpisodeID,arcimIDs)
					set criPatNum=0,seriousPatNum=0
					//病危
					s criPatNum=criPatNum+$p(ArcNums,"^",1)
					//病重
					s seriousPatNum=seriousPatNum+$p(ArcNums,"^",2)
					
					continue:(criPatNum+seriousPatNum)=0
					//生命体征
					set VitalSign=""
					Set VitalSignStr=##class(DtPortal.Common.PaadmService).GetVitalSignByAdm(EpisodeID)
					if VitalSignStr'="" s VitalSign="T:"_$p(VitalSignStr,"^",1)_"℃ ,"_"P:"_$p(VitalSignStr,"^",2)_"次/分 ,"_"R:"_$p(VitalSignStr,"^",3)_"次/分 ,"_"BP:"_$p(VitalSignStr,"^",4)_"/"_$p(VitalSignStr,"^",5)_"mmHg"
					//分开取生命体征
					s TempValue="T:"_$p(VitalSignStr,"^",1)_"℃"           //体温
					s BreatheValue="R:"_$p(VitalSignStr,"^",3)_"次/分"       //呼吸 
					s PulseValue="P:"_$p(VitalSignStr,"^",2)_"次/分"     //脉搏
					i $p(VitalSignStr,"^",4)'="" d
					.s BloodPressureValue="BP:"_$p(VitalSignStr,"^",4)_"/"_$p(VitalSignStr,"^",5)_"mmHg"
					e  s BloodPressureValue="BP:"
					
					
					//护理级别
					set CareLevel=##class(DtPortal.Common.PaadmService).IsHaveArc(EpisodeID,ArcIDsNur)
					//诊断
					set DiagnoseDesc=##class(DtPortal.Common.PaadmService).GetAdmDiagnosis(EpisodeID)
					
					set PatInfo=##class(DtPortal.Common.PaadmService).GetPatInfo(EpisodeID)
					Continue:PatInfo=""
					set name=$p(PatInfo,"^",2)											//姓名
					set sex=$p(PatInfo,"^",3)											//性别
					set age=$p(PatInfo,"^",4)											//年龄
					set medicareNo=$p(PatInfo,"^",5)									//病案号
					set admReason=$p(PatInfo,"^",6)										//费用类别
					set bedNum=$p(PatInfo,"^",1)										//床号
					
					//获取打开电子病历所需要的参数
					set EMRinfo=##class(DtPortal.Common.PaadmService).GetEMRParameter(EpisodeID)
					set EMRDocID=$p(EMRinfo,"^",1)
					set EMRInstanceID=$p(EMRinfo,"^",2)
					set locID=$p(EMRinfo,"^",3)
					set PatientID=$p(EMRinfo,"^",4)
					set EMREpisodeID=$p(EMRinfo,"^",5)
					
				 	Set Data=$lb(bedNum,name,sex,age,medicareNo,VitalSign,CareLevel,EpisodeID,AdmDocID,DocLoc,ManagerDoc,DiagnoseDesc,TempValue,BreatheValue,PulseValue,BloodPressureValue,EMRDocID,EMRInstanceID,locID,EMREpisodeID,UserID,PatientID)
					Set ^||CacheTemp(repid,ind)=Data
					Set ind=ind+1
				}
			}
		}
		
	}
	
	Quit $$$OK
}

/// /获取医生的集合  add by 赵丽
/// do ##class(%Library.ResultSet).RunQuery("DtPortal.DD.DD01EmphasisFocus.DD0102CriticalPat","D010202CriticalNum","601","359")
Query D010202CriticalNum(UserCode As %String, locGroupID As %String, DocID As %String = "", codes As %String = "") As DtPortal.Query(ROWSPEC = "DocID:%String,Name:%String,value:%String")
{
}

ClassMethod D010202CriticalNumExecute(ByRef qHandle As %Binary, UserCode As %String, locGroupID As %String, DocID As %String = "", codes As %String = "") As %Status
{
	Set repid=$I(^||CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind=1
	k ^TempPortalDD010202
	set DocLocStr=##class(DtPortal.DD.DD00PublicService).getDDloc(locGroupID,"I")
	Quit:DocLocStr="" $$$OK
	//根据配置医嘱code取医嘱ID,全部护理
	set ArcIDsNur=##Class(DtPortal.Configure.arcim).getArcImID("NURSELEVEL",1)
	
	if ((codes="")||(codes="SERIOUSLYCRITICALLY")){
		set codes="SERIOUSLY^CRITICALLY"
	}
	
	//1-病危 2-病重
	set arcimIDs=##class(DtPortal.Configure.arcim).getArcImID(codes,1)
	
	set all=0
	for index=1:1:$l(DocLocStr,"^")
	{
		set DocLoc=$p(DocLocStr,"^",index)
		continue:DocLoc=""
		Set Date=""
		For  
		{	
			Set Date=$O(^PAADMi("AdmTypeCurrLoc","I",DocLoc,Date)) 
			
			Quit:(Date="")
			
			Set Time=""
			for
			{
				Set Time=$O(^PAADMi("AdmTypeCurrLoc","I",DocLoc,Date,Time)) 
				Quit:(Time="")
				
				set EpisodeID=0
				for
				{
					Set EpisodeID=$O(^PAADMi("AdmTypeCurrLoc","I",DocLoc,Date,Time,EpisodeID)) 
					Quit:(EpisodeID="")
					
					Set AdmObj=##class(DHCMed.Base.PatientAdm).GetObjById(EpisodeID)
					quit:'$IsObject(AdmObj)
					
					set PatientID=AdmObj.PatientID
					set CPDocID=AdmObj.DoctorID
					set AdmDocID=""
					set:CPDocID'="" AdmDocID=$O(^SSU("SSUSR",0,"CTPCP",CPDocID,""),-1)
					set ManagerDoc=AdmObj.DoctorName
					continue:(DocID'="")&&(AdmDocID'=DocID)		
					
					set UserID=AdmDocID
					
					set CareLevel=""
					set OrderRowid=$o(^OEORD(0,"Adm",+EpisodeID,""))
					continue:OrderRowid=""
					s OEORISttDate=""
					s CriticalFlag=0
		
					s ArcNums=##class(DtPortal.Common.PaadmService).getArcNums(EpisodeID,arcimIDs)
					set criPatNum=0,seriousPatNum=0
					//病危
					s criPatNum=criPatNum+$p(ArcNums,"^",1)
					//病重
					s seriousPatNum=seriousPatNum+$p(ArcNums,"^",2)
					
					continue:(criPatNum+seriousPatNum)=0
								
					
					set PatInfo=##class(DtPortal.Common.PaadmService).GetPatInfo(EpisodeID)
					Continue:PatInfo=""
					set all=all+1
					set ^TempPortalDD010202(AdmDocID)=$g(^TempPortalDD010202(AdmDocID))+1
					set ^TempPortalDD010202(AdmDocID,"name")=ManagerDoc
				 	
				}
			}
		}
		
	}
	Set Data=$lb("","全部",all)
	Set ^||CacheTemp(repid,ind)=Data
	Set ind=ind+1	
		
	set CPDocID=""
	for{
		set CPDocID=$o(^TempPortalDD010202(CPDocID))	
		q:CPDocID=""
		
		set name=$g(^TempPortalDD010202(CPDocID,"name"))
		set value=+$g(^TempPortalDD010202(CPDocID))
		
		Set Data=$lb(CPDocID,name,value)
		Set ^||CacheTemp(repid,ind)=Data
		Set ind=ind+1	
	}
	
	
	
	Quit $$$OK
}

}
