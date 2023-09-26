/// creator    :  程鹏
/// date       :  2018-12-21
/// description:  危急值相应超时服务
/// debug      :  DtPortal.MD.MD09CriticalValue
Class DtPortal.MD.MD09CriticalValue Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// creator     :程鹏
/// description :获取全院各个科室响应超时的危急值数量(包括已相应和未响应)
/// 服务号 :MD09.01.01
/// input:  	StarDate		开始时间 (格式:2018-01-01)
/// 			EndDate			结束时间 (格式:2018-01-31)
/// 			HospitalId		院区 ID
/// d ##class(%ResultSet).RunQuery("DtPortal.MD.MD09CriticalValue","MD090101","2018-01-01","2018-12-23","")
/// 
Query MD090101(StarDate As %String, EndDate As %String, HospitalId As %String = "", cvReportStatus As %String = "", admTypeParam As %String = "") As DtPortal.Query(ROWSPEC = "ind,admType,locID,locDesc,num")
{
}

ClassMethod MD090101Execute(ByRef qHandle As %Binary, StarDate As %String, EndDate As %String, HospitalId As %String = "", cvReportStatus As %String = "", admTypeParam As %String = "") As %Status
{
	Set repid=$I(^||CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind=1
	
	k ^||TMPPortalMD090101
	
	//取配置,取危急值相应超时时间
	set Undotime=##Class(DtPortal.Common.PublicService).getValueByCode("UNDOCVTIME")
	
	if ((StarDate="")||(EndDate="")){
		s StarDate=+$h
		s EndDate=+$h
	}else{
		s StarDate=$zdh(StarDate,3)
		s EndDate=$zdh(EndDate,3)
	}
	
	if cvReportStatus="all" set cvReportStatus=""  //接口是空查询全部
	
	f reporttype=1:1:6
	{
		set obj=##class(%ResultSet).%New("DtPortal.Common.Interface.CriticalValue:GetPanicReport")
		d obj.Execute(StarDate,EndDate,"",cvReportStatus,"",reporttype)
		
		While (obj.Next()) {
			set AmdLoc=obj.Data("AmdLoc")
			continue:AmdLoc=""
			set hospID=$p($g(^CTLOC(AmdLoc)),"^",22)
			i HospitalId'=""  continue:hospID'=HospitalId
			
			set adm=obj.Data("adm")
			continue:adm=""
			set admType=$p(^PAADM(adm),"^",2)
			continue:admType=""
			continue:admType="H"
			continue:(admTypeParam'="all")&(admTypeParam'=admType)
			set ReportDate=obj.Data("ReportDate")		//危急值报告日期
			set ReportTime=obj.Data("ReportTime")		//危急值报告时间
			set ReportStatus=obj.Data("ReportStatus")	//危急值报告状态
			set TransDate=obj.Data("TransDate")			//危急值处理日期
			set TransTime=obj.Data("TransTime")			//危急值处理时间
			
			set ReportStatusDesc=""
			
	
			
			if ReportStatus="C"
			{
				if ReportDate=+$h continue:(+$p($h,",",2)-ReportTime)<(Undotime*60)
				set ReportStatusDesc="未响应"
			}else
			{	
				//响应时间小于配置时间退出 (逻辑,上报日期与相应日期同一天,处理时间-报告时间小于配置时间
				set Rdate=(ReportDate*86400)+ReportTime
				set Tdate=(TransDate*86400)+TransTime
				
				continue:((Tdate-Rdate)<(Undotime*60))
				
				set ReportStatusDesc="已响应"
			}
			
			set ^||TMPPortalMD090101(admType,AmdLoc)=+$g(^||TMPPortalMD090101(admType,AmdLoc))+1
		}
	}
	
	set admType=""
	for
	{
		set admType=$o(^||TMPPortalMD090101(admType))
		quit:admType=""
		
		set locID=""
		for
		{
			set locID=$o(^||TMPPortalMD090101(admType,locID))
			quit:locID=""
			
			set num=+$g(^||TMPPortalMD090101(admType,locID))
			set locDesc=$p(^CTLOC(locID),"^",2)
			set:locDesc["-" locDesc=$p(locDesc,"-",2)
			
			Set ^||CacheTemp(repid,ind)=$lb(ind,admType,locID,locDesc,num)
			Set ind=ind+1
		}
	}
	
	k ^||TMPPortalMD090101
	Quit $$$OK
}

/// creator     :程鹏
/// description :获取科室响应超时危急值报告详情
/// 服务号 :MD09.01.02
/// input:  StarDate		开始时间 (格式:2018-01-01)
/// 			EndDate			结束时间 (格式:2018-01-31)
/// 			LocID			科室 ID(CT_LOC)
/// d ##class(%ResultSet).RunQuery("DtPortal.MD.MD09CriticalValue","MD090102","2019-02-01","2019-02-28","95","","I")
/// 
Query MD090102(StarDate As %String = "", EndDate As %String = "", LocID As %String = "", cvReportStatus As %String = "all", admTypeParam As %String = "all") As DtPortal.Query(ROWSPEC = "ind,EpisodeId,PatientID,DocID,InstanceID,UserID,UserLocID,bedCode,name,sex,age,medicareNo,admReason,regNo,nurseDesc,docDesc,locDesc,wardDesc,diagnoseDesc,inDay,inDateTime,TSName,ReportDate,ReportTime,TransDate,TransTime,TransUser,ReportStatusDesc,Summary,applyDate")
{
}

ClassMethod MD090102Execute(ByRef qHandle As %Binary, StarDate As %String = "", EndDate As %String = "", LocID As %String = "", cvReportStatus As %String = "all", admTypeParam As %String = "all") As %Status
{
	Set repid=$I(^||CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind=1
	
	//取配置,取危急值相应超时时间
	set Undotime=##Class(DtPortal.Common.PublicService).getValueByCode("UNDOCVTIME")
	if ((StarDate="")||(EndDate="")){
		s StarDate=+$h
		s EndDate=+$h
	}else{
		s StarDate=$zdh(StarDate,3)
		s EndDate=$zdh(EndDate,3)
	}
	
	if cvReportStatus="all" set cvReportStatus=""  //接口是空查询全部
	f reporttype=1:1:6
	{
		set obj=##class(%ResultSet).%New("DtPortal.Common.Interface.CriticalValue:GetPanicReport")
		d obj.Execute(StarDate,EndDate,LocID,cvReportStatus,"",reporttype)
		
		While (obj.Next()) {
			set AmdLoc=obj.Data("AmdLoc")
			continue:AmdLoc=""
			//continue:((LocID'="")&&(LocID'=AmdLoc))
		
			set EpisodeId=obj.Data("adm")
			continue:EpisodeId=""
			
			//获取打开电子病历的参数
			Set AdmObj=##class(DHCMed.Base.PatientAdm).GetObjById(EpisodeId)
			continue:'$IsObject(AdmObj)
			set PatientID=AdmObj.PatientID
			set EMRinfo=##class(DtPortal.Common.PaadmService).GetEMRParameter(EpisodeId)
			set DocID=$p(EMRinfo,"^",1)
			set instanceID=$p(EMRinfo,"^",2)
			
				
			Set CPDocID=$p($g(^PAADM(EpisodeId)),"^",9)     //主管医生
			set UserID=""
			
			set UserLocID=$p($g(^PAADM(EpisodeId)),"^",4)
			
			if CPDocID'="" {
				set UserID=$O(^SSU("SSUSR",0,"CTPCP",CPDocID,""),-1)
			}
			set OEOrdItemID=obj.Data("OEOrdItemID")
			Set applyDateStr=##class(DtPortal.Common.PublicService).GetOrdItemDate(OEOrdItemID)    //危急值申请时间
			set applyDate=$zd($p(applyDateStr,"^",1),3)_"&nbsp;"_$zt($p(applyDateStr,"^",2),2)
			
			set admType=$p(^PAADM(EpisodeId),"^",2)
			continue:admType=""
			continue:admType="H"
			continue:(admTypeParam'="all")&(admTypeParam'=admType)
			
			set TSName=obj.Data("TSName")				//危急值检查项目
			set ReportDate=obj.Data("ReportDate")		 //危急值报告日期
			;w 111,!
			set ReportTime=obj.Data("ReportTime")		//危急值报告时间
			set ReportStatus=obj.Data("ReportStatus")	//危急值报告状态
			set TransDate=obj.Data("TransDate")			 //危急值处理日期
			set TransTime=obj.Data("TransTime")			//危急值处理时间
			set TransUser=obj.Data("TransUser")			//危急值处理医生
			set Summary=obj.Data("DPRPResult")			//危急值报告信息
		
			;w ReportDate_"&nbsp;"_TransDate_"&nbsp;"_applyDate,!
			set ReportStatusDesc=""
			if ReportStatus="C"
			{
				if ReportDate=+$h continue:(+$p($h,",",2)-ReportTime)<(Undotime*60)
				set ReportStatusDesc="未响应"
				
				
			}else
			{	
				//相应时间小于配置时间退出 (逻辑,上报日期与相应日期同一天,处理时间-报告时间小于配置时间)
				set Rdate=(ReportDate*86400)+ReportTime
				set Tdate=(TransDate*86400)+TransTime
				
				continue:((Tdate-Rdate)<(Undotime*60))
				set ReportStatusDesc="已响应"
				
				
			}
			
			//存在处理时间就显示出来
			if (TransTime'=""){
				set TransDate=$zd(TransDate,3)
				set TransTime=$zt(TransTime,2)
				set TransDate=TransDate_"&nbsp;"_TransTime
			}
			
			set ReportDate=$zd(ReportDate,3)
			set ReportTime=$zt(ReportTime,2)
			
			set patInfoStr=##class(DtPortal.Common.PaadmService).GetPatInfo(EpisodeId)
		 	set bedCode=$p(patInfoStr,"^",1)
		 	set name=$p(patInfoStr,"^",2)
		 	set sex=$p(patInfoStr,"^",3)
		 	set age=$p(patInfoStr,"^",4)
		 	set medicareNo=$p(patInfoStr,"^",5)   															//病案号
		 	set admReason=$p(patInfoStr,"^",6)    															//费用类型
		 	set regNo=$p(patInfoStr,"^",7)   																//登记号
		 	set nurseDesc=$p(patInfoStr,"^",12)																//主管护士
		 	set docDesc=$p(patInfoStr,"^",11)																//主管医生
			set locDesc=$p(patInfoStr,"^",9)																//科室描述
			set wardDesc=$p(patInfoStr,"^",10)																//病区描述
			set diagnoseDesc=##class(DtPortal.Common.PaadmService).GetMainDiagnosis(EpisodeId)				//诊断
			set inDay=##class(DtPortal.Common.PaadmService).getInDayByInPat(EpisodeId)						//在院天数
		    set inTimeStr=##class(DtPortal.Common.PaadmService).GetAdminDateTime(EpisodeId)					//就诊日期
		    
		    set inDate=$p(inTimeStr,"^",1)
		    if inDate'=""   set inDate=$zd(inDate,3)
		    set inTime=$p(inTimeStr,"^",2)
		    if inTime'=""  set inTime=$zt(inTime,2)
		   
		    set inDateTime=inDate_"&nbsp;"_inTime
		    if inDate=""  set inDateTime=""
		    set ReportDate = ReportDate_"&nbsp;"_ReportTime
		    
		    
		    Set ^||CacheTemp(repid,ind)=$lb(ind,EpisodeId,PatientID,DocID,InstanceID,UserID,UserLocID,bedCode,name,sex,age,medicareNo,admReason,regNo,nurseDesc,docDesc,locDesc,wardDesc,diagnoseDesc,inDay,inDateTime,TSName,ReportDate,ReportTime,TransDate,TransTime,TransUser,ReportStatusDesc,Summary,applyDate)
			Set ind=ind+1
		}
	}
	

	Quit $$$OK
}

}
