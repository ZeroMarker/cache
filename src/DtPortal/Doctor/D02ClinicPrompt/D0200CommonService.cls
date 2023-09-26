/// creator:        shp
/// date:           2014.7.11
/// description:    临床提示服务定义
Class DtPortal.Doctor.D02ClinicPrompt.D0200CommonService Extends %RegisteredObject
{

/// creator    :  bmz
/// date       :  20181104
/// description:  临床提示整体服务定义
///  危急值：CriticalValue、View_CriticalValue 体温异常
/// output     :  根据设计原型定义输出顺序
///              
/// debug       :  d ##class(%ResultSet).RunQuery("DtPortal.Doctor.D02ClinicPrompt.D0200CommonService","D020000GetClinicPrompt","P","601","false","","UndoConsultation")
Query D020000GetClinicPrompt(QueryType As %String, UserCode As %String, IfUsePushData As %String = "false", NotPermissionStr As %String = "", findType As %String = "") As DtPortal.Query(ROWSPEC = "CriticalValue:%String,TemperatureAnomalies:%String,UnreadReport:%String,UndoConsultation:%String,UndoAntibiotics:%String,UndoEpidemic:%String,UndoInfection:%String,EMRCountersign:%String,MedicareUnReturn:%String,UnSubmitNum:%String,RecordQuality:%String")
{
}

ClassMethod D020000GetClinicPromptExecute(ByRef qHandle As %Binary, QueryType As %String, UserCode As %String, IfUsePushData As %String = "false", NotPermissionStr As %String = "", findType As %String = "") As %Status
{
	Set repid=$I(^||CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	set UserId=##class(DtPortal.Common.PublicService).GetUserID(UserCode)
	//危急值-CriticalValue、View_CriticalValue 体温异常-TemperatureAnomalies、View_TemperatureAnomalies 未读报告-UnreadReport、View_UnreadReport
	//被邀会诊-UndoConsultation、View_UndoConsultation 待审核医嘱-UndoDoctorAdvice、View_UndoDoctorAdvice 待审核抗菌药-UndoAntibiotics、View_UndoAntibiotics
	//传染病提示-UndoEpidemic、View_UndoEpidemic 院感提示-UndoInfection、View_UndoInfection 待签病历-EMRCountersign、View_EMRCountersign
	//未提交病历-MedicareUnReturn、View_UnArchivedMedicalRecords 未提交病案首页-UnSubmitNum、View_NotSubmittedMedicalRecord  病例指控提示-RecordQuality、View_MedicalRecordsControl
	s (CriticalValue,TemperatureAnomalies,UnreadReport,UndoConsultation,UndoDoctorAdvice,UndoAntibiotics,UndoEpidemic,UndoInfection,EMRCountersign,MedicareUnReturn,UnSubmitNum,RecordQuality)=0
	i UserId="" Quit $$$OK
	set DocId=##class(DtPortal.Common.PublicService).GetDocIDByUserCode(UserCode)
	s time1=$p($now(),",",2)
	
	if (findType="CriticalValue"){
		s CriticalValue=##class(DtPortal.Doctor.D02ClinicPrompt.D0200CommonService).GetCVNum(UserCode,QueryType)
		d output
		Set qHandle=$lb(0,repid,0)
		quit $$$OK
	}elseif(findType="TemperatureAnomalies"){
		s TemperatureAnomalies=##class(DtPortal.Common.PublicService).GetCommonMethodNum("Query","DtPortal.Doctor.D02ClinicPrompt.D0202TempAnom","D020201TempAnomQuery",QueryType_$c(9813)_UserCode)
		d output
		Set qHandle=$lb(0,repid,0)
		quit $$$OK
	}elseif(findType="UnreadReport"){
		s UnreadReport=##class(DtPortal.Common.PublicService).GetCommonMethodNum("Query","DtPortal.Doctor.D02ClinicPrompt.D0203UnReadReportService","D020301UnReadReportList",QueryType_$c(9813)_UserCode_$c(9813)_"N")
		d output
		Set qHandle=$lb(0,repid,0)
		quit $$$OK
	}elseif(findType="UndoConsultation"){
		s UndoConsultation=##class(DtPortal.Common.PublicService).GetCommonMethodNum("Query","DtPortal.Doctor.D02ClinicPrompt.D0204UndoConsultation","D020401ConsultList",QueryType_$c(9813)_UserCode_$c(9813)_IfUsePushData)
		d output
		Set qHandle=$lb(0,repid,0)
		quit $$$OK
	}elseif(findType="UndoAntibiotics"){
		s UndoAntibiotics=##class(DtPortal.Common.PublicService).GetCommonMethodNum("Query","DtPortal.Doctor.D02ClinicPrompt.D0206UndoAntService","D020601AntAppList",UserCode_$c(9813)_IfUsePushData)
		d output
		Set qHandle=$lb(0,repid,0)
		quit $$$OK
	}elseif(findType="UndoEpidemic"){
		s UndoEpidemic=##class(DtPortal.Common.PublicService).GetCommonMethodNum("Query","DtPortal.Doctor.D02ClinicPrompt.D0207UndoEpidemicService","D020701EPIReportList",QueryType_$c(9813)_UserCode)
		d output
		Set qHandle=$lb(0,repid,0)
		quit $$$OK
	}elseif(findType="UndoInfection"){
		s UndoInfection=##class(DtPortal.Common.PublicService).GetCommonMethodNum("Query","DtPortal.Doctor.D02ClinicPrompt.D0208UndoInfectionService","D020801QryList",QueryType_$c(9813)_UserCode)
		d output
		Set qHandle=$lb(0,repid,0)
		quit $$$OK
	}elseif(findType="EMRCountersign"){
		s EMRCountersign=##class(DtPortal.Common.PublicService).GetCommonMethodNum("ClassMethod","EMRservice.InterfaceService.WaitSign",
			"GetEMRWaitSignCount",UserId)
		d output
		Set qHandle=$lb(0,repid,0)
		quit $$$OK
	}elseif(findType="UnSubmitNum"){
		s UnSubmitNum=##class(DtPortal.Common.PublicService).GetCommonMethodNum("Query","DtPortal.Doctor.D02ClinicPrompt.D0211UnSubmitMedical","D021101UnSubmitList",QueryType_$c(9813)_UserCode_$c(9813)_$c(9813)_"2")
		d output
		Set qHandle=$lb(0,repid,0)
		quit $$$OK
	}elseif(findType="RecordQuality"){
		s RecordQuality=##class(DtPortal.Common.PublicService).GetCommonMethodNum("Query","DtPortal.Doctor.D02ClinicPrompt.D0212RecordQuality","D021201",QueryType_$c(9813)_UserCode)
		d output
		Set qHandle=$lb(0,repid,0)
		quit $$$OK
	}
	
	
	set PushData=""
	if (IfUsePushData="true"){
		/*
		//推送目前剩这四种类型
		Set rset = ##class(%ResultSet).%New("websys.DHCMessageDetailsMgr:FindCountAndBizIds")
		
		if (rset'=""){
			 Do rset.Execute(UserId,"1064^1008^1000^1046^1060^1014^1052","N")
		    set messageResult=""
		    While (rset.Next()) {
				 set code=rset.Data("code")
				 set count=rset.Data("count")
				// set bizObjId=rset.Data("bizObjId")
				 //set bizAdmId=rset.Data("bizAdmId")
				 //set msgContentId=rset.Data("msgContentId")
				 //set execType=rset.Data("execType")
				 //set messageResult=messageResult_code_"#"_count_$C(9813)
				 if (code="1000"){   //危机值
				 	 set CriticalValue=count
				 } elseif (code="1046"){   //待审核抗菌药物
				 	 set UndoDoctorAdvice=count
				 } elseif (code="1014"){   //会诊申请
				 	 set UndoConsultation=count
				 } elseif (code="1052"){   //待签病历
				 	 set EMRCountersign=count
				 }
			 
			}
		}else{
			set PushData="false"
		}*/
	}
	
	
	if ((IfUsePushData'="true")||(PushData="false")){
		//危急值数量
		if (NotPermissionStr'["^View_CriticalValue^") {
			s CriticalValue=##class(DtPortal.Doctor.D02ClinicPrompt.D0200CommonService).GetCVNum(UserCode,QueryType)
		}
	 	
		//待处理会诊--直接调用query
		if (NotPermissionStr'["^View_UndoConsultation^") {
			s UndoConsultation=##class(DtPortal.Common.PublicService).GetCommonMethodNum("Query","DtPortal.Doctor.D02ClinicPrompt.D0204UndoConsultation","D020401ConsultList",QueryType_$c(9813)_UserCode_$c(9813)_IfUsePushData)
		}
		
		
		//待审核抗生素--直接调用query,过滤逻辑较多，不适合拆分
		if (NotPermissionStr'["^View_UndoAntibiotics^") {
			//s UndoDoctorAdvice=##class(DtPortal.Doctor.ClinicPrompt.UndoAntBioticsService).GetUndoAntBioNum(UserCode)
			s UndoAntibiotics=##class(DtPortal.Common.PublicService).GetCommonMethodNum("Query","DtPortal.Doctor.D02ClinicPrompt.D0206UndoAntService","D020601AntAppList",UserCode_$c(9813)_IfUsePushData)
		}
		
		//待签病历-这个逻辑是独立的
		if (NotPermissionStr'["^View_EMRCountersign^") {
			s EMRCountersign=##class(DtPortal.Common.PublicService).GetCommonMethodNum("ClassMethod","EMRservice.InterfaceService.WaitSign",
			"GetEMRWaitSignCount",UserId)
			
		}
		
	}
	
	
	
	
	s admPatList=##Class(DtPortal.Common.PaadmService).GetIPPaadmList(QueryType,UserId,"")
	//quit:admPatList="" $$$OK   //代签病历没有患者时，有数据
	for admIndex=1:1:$L(admPatList,"^")
	{
		set PAAdm=$p(admPatList,"^",admIndex)
		continue:PAAdm=""
		//体温异常数量  
		if (NotPermissionStr'["^View_TemperatureAnomalies^") {
			s TempData=##class(DtPortal.Doctor.D02ClinicPrompt.D0202TempAnom).GetTemperatureTableData(PAAdm)
			if (TempData'=""){
				s TempAnomaliesFlag=$p(TempData,"#",6)
				if (TempAnomaliesFlag'=0){
					set TemperatureAnomalies=TemperatureAnomalies+1
				}
				
			}			
		}
		
		
		
		//传染病提示  
		if (NotPermissionStr'["^View_UndoEpidemic^") {
			set EPIID=$o(^DHCMed.EPDi("EPD",0,"EpisodeID",PAAdm,""))
			if (EPIID'=""){
				s EPIInfo=##class(DtPortal.Doctor.D02ClinicPrompt.D0207UndoEpidemicService).GetEPIInfo(EPIID)
				s flag=$p(EPIInfo,"^",1)
				if (flag=1) s UndoEpidemic=UndoEpidemic+1
				
			}
			
		}
		
		
		//病例指控提示 1
		//w !,"b1="_($p($now(),",",2)-time1)
		if (NotPermissionStr'["^View_MedicalRecordsControl^") {
			//s RecordQuality=##class(DtPortal.Common.PublicService).GetCommonMethodNum("Query","DtPortal.Doctor.D02ClinicPrompt.D0212RecordQuality","D021201",QueryType_$c(9813)_UserCode)
			Set rset = ##class(%ResultSet).%New("EPRservice.Quality.Interface.EMRQualityForPortal:GetPromptListForPortal")
			Do rset.Execute(PAAdm)
			
			s RecordNum=0
			While (rset.Next()) {
				s RecordNum=rset.%ROWCOUNT
			}
			if (RecordNum'=0) s RecordQuality=RecordQuality+1
		}
		
	}
	
	
	
	//未读报告数量-这个逻辑是独立的
	if (NotPermissionStr'["^View_UnreadReport^") {
		//默认查询N
		s UnreadReport=##class(DtPortal.Common.PublicService).GetCommonMethodNum("Query","DtPortal.Doctor.D02ClinicPrompt.D0203UnReadReportService","D020301UnReadReportList",QueryType_$c(9813)_UserCode_$c(9813)_"N")
	}
	
	
	
	
	
	//医院感染提示 -医政组类封装的接口，需要产品组协助优化，暂时不优化数量
	if (NotPermissionStr'["^View_UndoInfection^") {
		s UndoInfection=##class(DtPortal.Common.PublicService).GetCommonMethodNum("Query","DHCHAI.IO.ToDtPortal04",
		"QryUnreadMsgList2",QueryType_$c(9813)_UserCode)
	}
	
	

    //未提交病历天数
	s UNSUBMITDAYS=##Class(DtPortal.Common.PublicService).getValueByCode("UNSUBMITDAYS")
	
	s startdate=(+$h)-UNSUBMITDAYS
	s enddate=+$h
	s MUDocIDs=DocId
	if QueryType="PG" SET MUDocIDs=##Class(DtPortal.Common.PublicService).GetMUDocList(DocId)
    //未提交病历
	if (NotPermissionStr'["^View_NotSubmittedMedicalRecord^") {

		//未提交病历数量
		for date=startdate:1:enddate {
			s PAAdm=""
			for {
				s PAAdm=$o(^PAADMi("EstDisch",date,PAAdm))
				q:PAAdm=""
				s admDocDR=$P($g(^PAADM(PAAdm)),"^",9)
				continue:admDocDR=""
				continue:'$LF($LISTFROMSTRING(MUDocIDs,"^"),admDocDR)
				s FistPageFlag=##Class(EMRservice.BL.BLAdmRecordStatus).GetAdmRecordStatus(PAAdm)
				continue:FistPageFlag="1"   //判断病案首页数据是否提交
				s UnSubmitNum=UnSubmitNum+1
			}     
	
		}
	}
	
	d output
	
	
	Set qHandle=$lb(0,repid,0)
	quit $$$OK
	
output	

	Set ^||CacheTemp(repid,ind)=$lb(CriticalValue,TemperatureAnomalies,UnreadReport,UndoConsultation,UndoAntibiotics,UndoEpidemic,UndoInfection,EMRCountersign,MedicareUnReturn,UnSubmitNum,RecordQuality)
	Set ind=ind+1
	Quit
}

/// creator    :  zhaoli
/// date       :  20170609
/// description:  获取消息平台指定类型的消息数据
/// debug      :  w ##class(DtPortal.Doctor.D02ClinicPrompt.D0200CommonService).GetMessageData("4829","1046")
ClassMethod GetMessageData(UserCode As %String, ActionCodes As %String) As %String
{
 
	set obj=##class(dhcservice.DHCMessageInterface).%New()
	set rtn=obj.GetCountAndBizIds(UserCode,ActionCodes)
	Set ret = ##class(DtPortal.OutPut).%New()
	set ret.status=1
	set ret.data=rtn
	q ret
}

/// 获取指定消息类型的数据
/// 入参：userId 用户id actionType 消息编号
/// /// debug      :  w ##class(DtPortal.Doctor.D02ClinicPrompt.D0200CommonService).GetMessageDataByType("34","1046")
ClassMethod GetMessageDataByType(UserId As %String, actionType As %String) As DtPortal.Common.JsonObject
{
 set jsonObj = ##class(DtPortal.Common.JsonObject).%New()
 set code="",count="",bizObjId="",bizAdmId="",msgContentId="",execType=""
 //判断这个query是否存在
 set qdf=##class(%Dictionary.QueryDefinition).%OpenId("web.DHCAPPPisInterface||QryPatExaReqPortal")
 if $IsObject(qdf) {
 	 Set rset = ##class(%ResultSet).%New("websys.DHCMessageDetailsMgr:FindCountAndBizIds")
	 Do rset.Execute(UserId,actionType,"N")
	 set code="",count="",bizObjId="",bizAdmId="",msgContentId="",execType=""
	 While (rset.Next()) {
		 set code=rset.Data("code")
		 set count=rset.Data("count")
		 set bizObjId=rset.Data("bizObjId")
		 set bizAdmId=rset.Data("bizAdmId")
		 set msgContentId=rset.Data("msgContentId")
		 set execType=rset.Data("execType")
	 }
 
 }
 
 d jsonObj.Put("code",code)	
 d jsonObj.Put("count",count)	
 d jsonObj.Put("bizObjId",bizObjId)	
 d jsonObj.Put("bizAdmId",bizAdmId)	
 d jsonObj.Put("msgContentId",msgContentId)	
 d jsonObj.Put("execType",execType)
 quit jsonObj
}

/// creator    :  bmz
/// date       :  20200306
/// description:  获取危急值数量
/// debug      :  w ##class(DtPortal.Doctor.D02ClinicPrompt.D0200CommonService).GetCVNum("4829","P")
ClassMethod GetCVNum(UserCode As %String, QueryType As %String) As %String
{
 
	//1-危急值
	s CriticalValue=0
	s days=##Class(DtPortal.Common.PublicService).getValueByCode("CRITICALVALUEQUERYDAYS")
	s stdate=$zd(((+$h)-days),3)
	s edate=$zd(+$h,3) 
  	if UserCode="" Set qHandle=$lb(0,repid,0) q $$$OK
	Set LocStr=##class(DtPortal.Doctor.D00CommonService).GetLocByUserCode(UserCode)
	if LocStr=""  Set qHandle=$lb(0,repid,0) q $$$OK
	
	s docId=##class(DtPortal.Common.PublicService).GetDocIDByUserCode(UserCode)
	
	set MUDocIDs=""
	if QueryType="PG" SET MUDocIDs=##Class(DtPortal.Common.PublicService).GetMUDocList(docId)
	else  set MUDocIDs="^"_docId_"^"
	for i=1:1:$length(LocStr,"^") d
	.s locid=$p(LocStr,"^",i)
	.f reporttype=1:1:6  d
	..set obj=##class(%ResultSet).%New("DtPortal.Common.Interface.CriticalValue:GetPanicReport")
	..d obj.Execute(stdate,edate,locid,"C","I",reporttype)
	..f  Quit:'obj.Next()  d
	...s EpisodeID=obj.Data("adm")
	...s admDocDr=$p(^PAADM(EpisodeID),"^",9)  //主治医生
	...;q:cpId'=admDocDr
	...q:+admDocDr=0
	...q:MUDocIDs'[("^"_admDocDr_"^")
	...s CriticalValue=CriticalValue+1
	q CriticalValue
}

/// Creator：     chengpeng
/// CreatDate：   2014-07-25
/// Description:  根据医生工号和病人就诊号获取医生登录科室
/// Input：       aMsgInput   : 1 医生工号 ，2 病人就诊号
/// Return：      return>0:成功  return<1:失败
/// w ##class(DtPortal.Doctor.D02ClinicPrompt.D0200CommonService).GetDocIDLocID("337","IP0000000013")
ClassMethod GetDocIDLocID(aUserCode As %String, EpisodeID As %String) As DtPortal.OutPut
{
	Q:(aUserCode="")||(EpisodeID="")
	set DocLocID=""
	
	set docID=##class(DtPortal.Common.PublicService).GetUserID(aUserCode)
	set LocAll=##class(DtPortal.Doctor.D00CommonService).GetLocByUserCode(aUserCode)
	q:LocAll=""
	for i=1:1:$l(LocAll,"^") d
	.s LocID=$p(LocAll,"^",i)
	.s IPPaadmList=##Class(DtPortal.Common.PaadmService).GetIPPaadmList(3,docID,LocID)
	.for j=1:1:$l(IPPaadmList,"^") d
	..s epdID=$p(IPPaadmList,"^",j)
	..i epdID=EpisodeID s DocLocID=LocID
	q DocLocID
}

}
