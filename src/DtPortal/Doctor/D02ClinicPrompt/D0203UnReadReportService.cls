/// creator    : shp
/// date       : 20140714
/// description: 未读报告相关服务
Class DtPortal.Doctor.D02ClinicPrompt.D0203UnReadReportService Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// 查询当前医生主管全部类型病人，各种查看状态的报告记录
/// RptStatus: "A"-所有报告，"Y"-已读报告，"N"-未读报告
/// D02.03.01 
/// d ##class(%ResultSet).RunQuery("DtPortal.Doctor.D02ClinicPrompt.D0203UnReadReportService","D020301UnReadReportList","P","ys01","N")
Query D020301UnReadReportList(QueryType As %String, UserCode As %String, RptStatus As %String, StartDate As %String = "", EndDate As %String = "") As DtPortal.Query(ROWSPEC = "StudyType:%String,PatientID:%String,Name:%String,Sex:%String,Birthday:%String,ItemDR:%String,StudyNo:%String,ReportDate:%String,ReportTime:%String,ReportDocCode:%String,ReportURL:%String,IsChecked:%String,ItemDesc:%String,ReportDocName:%String,OrdRowid:%String,StudyTypeDr:%String,EpisodeID:%String,bedNo:%String,MedNo:%String,AdmDocID:%String,labNo:%String,param1,param2,param3,param4")
{
}

ClassMethod D020301UnReadReportListExecute(ByRef qHandle As %Binary, QueryType As %String, UserCode As %String, RptStatus As %String, StartDate As %String = "", EndDate As %String = "") As %Status
{
	n (qHandle,QueryType,UserCode,RptStatus,StartDate,EndDate)
	Set repidPortal=$I(^||CacheTemp)
    If $g(indPortal)="" Set indPortal=1
    //未读报告天数取配置
    set days=##Class(DtPortal.Common.PublicService).getValueByCode("UNREADREPORTQUERYDAYS")
    
    
    i RptStatus="N" set StartDate=$zd(+$h-days,"3"),EndDate=$zd($h,"3")
    
    set UserID=##class(DtPortal.Common.PublicService).GetUserID(UserCode)
    set DocId=##class(DtPortal.Common.PublicService).GetDocIDByUserCode(UserCode)
    set defaultDept=$p($g(^SSU("SSUSR",UserID)),"^",4)
    set MUDocIDs=""
    if QueryType="PG" SET MUDocIDs=##Class(DtPortal.Common.PublicService).GetMUDocList(DocId)
    else  s MUDocIDs=DocId
    set DocNum=$l(MUDocIDs,"^")  
    for i=1:1:DocNum {
	    set DocTemp=$p(MUDocIDs,"^",i) 
		if DocTemp="" continue
		set DocCode=$p($g(^CTPCP(DocTemp,1)),"^",1)
		if DocCode="" continue
		//判断这个query是否存在
		set qdf=##class(%Dictionary.QueryDefinition).%OpenId("web.DHCAPPPisInterface||QryPatExaReqPortal")
		if $IsObject(qdf) {
			set rsPortal=##class(%ResultSet).%New("web.DHCAPPPisInterface:QryPatExaReqPortal")

		    //W startDate,endDate,DocCode,RptStatus,!
			d rsPortal.Execute(StartDate,EndDate,DocCode,RptStatus)
		    f  Quit:'rsPortal.Next()  d
			.s (StudyType,PatientID,Name,Sex,Age,ItemDR,StudyNo,ReportDate,ReportTime,ReportDocCode,ReportURL,IsChecked,ItemDesc,ReportDocName,OrdRowid,StudyTypeDr,EpisodeID,bedNo,MedNo)=""
			.s StudyType=rsPortal.Data("StudyType")
			.s PatientID=rsPortal.Data("PatientID")
			.s Name=rsPortal.Data("PatName")
			.s Sex=rsPortal.Data("PatSex")
			.s EpisodeID=rsPortal.Data("EpisodeID")
			.s Age=##class(web.DHCBillInterface).GetPapmiAge(PatientID,EpisodeID) //统一调用计费组的年龄接口 
			.s ItemDR=rsPortal.Data("Oeori")
			.s StudyNo=rsPortal.Data("StudyNo")
			.s ReportDate=rsPortal.Data("AuthDate")
			.s ReportTime=rsPortal.Data("AuthTime")
			.s ReportURL=rsPortal.Data("LinkUrl")
			.s ItemDesc=rsPortal.Data("ItemLabel")
			.s ReportDocName=rsPortal.Data("AuthUser")
			.s labNo="" //检验号
			.s StudyTypeDr=StudyType
			.i StudyTypeDr="检验" d
			..s StudyTypeDr="LIS"  //对应于前端对检验链接的特殊处理
			..i ItemDR'="" s labNo=$p($g(^OEORD($p(ItemDR,"||",1),"I",$p(ItemDR,"||",2),3)),"^",20)   //检验号
			.s bedNo=rsPortal.Data("PatBed")
			.set AdmDocID=""
			.Set AdmObj=##class(DHCMed.Base.PatientAdm).GetObjById(EpisodeID)
			.quit:'$IsObject(AdmObj)
						
			.set CPDocID=AdmObj.DoctorID
			.set:CPDocID'="" AdmDocID=$O(^SSU("SSUSR",0,"CTPCP",CPDocID,""),-1)
			.//医嘱ID、检查（检验等）号、科室ID、用户ID
			.s param1=ItemDR,param2=StudyNo,param3=defaultDept,param4=UserID
			.s MedNo=##class(DtPortal.Common.PaadmService).getMedicareNo(EpisodeID)   //调用公共方法获取病案号
	   		.Do OutInfoRow
		}else{
			set obj=##class(%ResultSet).%New("DtPortal.Doctor.D02ClinicPrompt.D0203UnReadReportService:QueryPortalRPTInfo")
			d obj.Execute(RptStatus,DocCode,StartDate,EndDate)
		    f  Quit:'obj.Next()  d
			.s (StudyType,PatientID,Name,Sex,Age,ItemDR,StudyNo,ReportDate,ReportTime,ReportDocCode,ReportURL,IsChecked,ItemDesc,ReportDocName,OrdRowid,StudyTypeDr,EpisodeID,bedNo,MedNo)=""
			.s StudyType=obj.Data("StudyType")
			.s PatientID=obj.Data("PatientID")
			.s Name=obj.Data("Name")
			.s Sex=obj.Data("Sex")
			.;s Age=obj.Data("Birthday")
			.s EpisodeID=obj.Data("EpisodeID")
			.s Age=##class(web.DHCBillInterface).GetPapmiAge(PatientID,EpisodeID) //统一调用计费组的年龄接口 
			.s ItemDR=obj.Data("ItemDR")
			.s StudyNo=obj.Data("StudyNo")
			.;set:StudyNo'="" StudyNo=$p(StudyNo,"||",1)    //update by chengpeng
			.s ReportDate=obj.Data("ReportDate")
			.s ReportTime=obj.Data("ReportTime")
			.s ReportDocCode=obj.Data("ReportDocCode")
			.s ReportURL=obj.Data("ReportURL")
			.s IsChecked=obj.Data("IsChecked")
			.s ItemDesc=obj.Data("ItemDesc")
			.s ReportDocName=obj.Data("ReportDocName")
			.s OrdRowid=obj.Data("OrdRowid")
			.s StudyTypeDr=obj.Data("StudyTypeDr")
			
			.s bedNo=obj.Data("bedNo")		
			.set AdmDocID=""
			.Set AdmObj=##class(DHCMed.Base.PatientAdm).GetObjById(EpisodeID)
			.quit:'$IsObject(AdmObj)
						
			.set CPDocID=AdmObj.DoctorID
			.set:CPDocID'="" AdmDocID=$O(^SSU("SSUSR",0,"CTPCP",CPDocID,""),-1)
			.s param1=StudyType,param2=StudyNo,param3=UserCode,param4="Y"
			.s MedNo=##class(DtPortal.Common.PaadmService).getMedicareNo(EpisodeID)   //调用公共方法获取病案号
	   		.Do OutInfoRow
		
		}   
	}
	Set qHandle=$lb(0,repidPortal,0)
	b ;012
	Quit $$$OK

OutInfoRow
	set Data=$lb(StudyType,PatientID,Name,Sex,Age,ItemDR,StudyNo,ReportDate,ReportTime,ReportDocCode,ReportURL,IsChecked,ItemDesc,ReportDocName,OrdRowid,StudyTypeDr,EpisodeID,bedNo,MedNo,AdmDocID,labNo,param1,param2,param3,param4)
 	Set ^||CacheTemp(repidPortal,indPortal)=Data
 	Set indPortal=indPortal+1
	quit
}

/// 设置报告已读状态
/// 设置临床医生查看报告状态
/// return ret.data=0 成功
/// 新版方法：医嘱ID、检验号、
/// w ##class(DtPortal.Doctor.D02ClinicPrompt.D0203UnReadReportService).D020302("RIS","ris0002","661","Y")
ClassMethod D020302(param1 As %String, param2 As %String, param3 As %String, param4 As %String) As %String
{
	
	#Dim ret As DtPortal.OutPut
	Set ret = ##class(DtPortal.OutPut).%New()
	Set $ZT = "ErrMessage5"
	//新版检查号的获取
	
	
	
	//判断这个query是否存在
	set qdf=##class(%Dictionary.QueryDefinition).%OpenId("web.DHCAPPPisInterface||QryPatExaReqPortal")
	if $IsObject(qdf) {
		s oeordID=param1  
		s StudyNo=param2
		s locID=param3
		s userID=param4
		
		//兼容性判断，新接口存在使用新接口，不存在使用旧的---bmz20200227
		s mdf=##class(%Dictionary.CompiledMethod).%OpenId("web.DHCAPPInterface||ClinicRecordSet",0)
		if $IsObject(mdf) {
			s rtn=##class(web.DHCAPPInterface).ClinicRecordSet("R",oeordID_"^"_StudyNo_"^"_locID_"^"_userID)
		}else{
			s rtn=##class(web.DHCEMInterface).ClinicRecordSet("R",oeordID_"^"_StudyNo_"^"_locID_"^"_userID)
		}
		
		Set ret.status = "-1"
		Set ret.errMSG =""
		// 可以是简单类型
		Set ret.data = ""
		if (rtn=0){
			Set ret.status = "1"
			Set ret.data = rtn
		}
		
		
	}else{
		s studyType=param1,studyNo=param2,docCode=param3,checkStatus=param4
		s rtn=##class(RISService.ReadReportInfo).SetPortalRPTChecked(studyType,studyNo,docCode,checkStatus)
		Set ret.status = $p(rtn,"^",1)
		Set ret.errMSG = $p(rtn,"^",2)
		// 可以是简单类型
		Set ret.data = $p(rtn,"^",3)
	}	
	Quit ret
	
ErrMessage5
	
	TRollBack
	Set ret.status = -1
	Set ret.errMSG = $ZE
	Set ret.data = ""
	Quit ret
}

/// RISService.ReadReportInfo这个类移植过来，增加时间传参
/// 查询当前医生主管全部类型病人，各种查看状态的报告记录
/// rptStatus: "A"-所有报告，"Y"-已读报告，"N"-未读报告
/// d ##class(%ResultSet).RunQuery("DtPortal.Doctor.D02ClinicPrompt.D0203UnReadReportService","QueryPortalRPTInfo","N","601","2015-03-20","2015-05-20")
Query QueryPortalRPTInfo(rptStatus As %String, docCode As %String, StartDate As %String = "", EndDate As %String = "") As DtPortal.Query(ROWSPEC = "StudyType:%String,PatientID:%String,Name:%String,Sex:%String,Birthday:%String,ItemDR:%String,StudyNo:%String,ReportDate:%String,ReportTime:%String,ReportDocCode:%String,ReportURL:%String,IsChecked:%String,ItemDesc:%String,ReportDocName:%String,OrdRowid:%String,StudyTypeDr:%String,EpisodeID:%String,bedNo:%String,MedNo:%String")
{
}

ClassMethod QueryPortalRPTInfoExecute(ByRef qHandle As %Binary, rptStatus As %String, docCode As %String, StartDate As %String = "", EndDate As %String = "") As %Status
{
	new (qHandle,rptStatus,docCode,StartDate,EndDate)
	Set repid=$I(^||CacheTemp)
    If $g(ind)="" Set ind=1
    if StartDate="" set StartDate=+$h
    else  set StartDate=$zdh(StartDate,3)
    if EndDate="" set EndDate=+$h
    else  set EndDate=$zdh(EndDate,3)
    
	s patientid="" f  s patientid=$o(^DHCRBCLINICCHECKRPTINFOi("APP-CODE",docCode,patientid)) q:(patientid="")  d
	.s Appdate="" f  s Appdate=$o(^DHCRBCLINICCHECKRPTINFOi("APP-CODE",docCode,patientid,Appdate)) q:(Appdate="")  d
	..q:(Appdate<StartDate)||(Appdate>EndDate)
   	..s Rowid=""  f  s Rowid=$o(^DHCRBCLINICCHECKRPTINFOi("APP-CODE",docCode,patientid,Appdate,Rowid)) q:(Rowid="")  d
   	...s info=^DHCRBCLINICCHECKRPTINFO(Rowid)
   	...s (StudyType,PatientID,Name,Sex,Birthday,ItemDR,StudyNo,ReportDate,ReportTime,ReportDocCode,ReportURL,IsChecked,ItemDesc,ReportDocName,OrdRowid,StudyTypeDr,EpisodeID,bedNo,MedNo)=""
   	...s StudyTypeDr=$p(info,"^",1)
   	...s StudyType=$S(StudyTypeDr=1:"检验",StudyTypeDr="LIS":"检验",StudyTypeDr=2:"病理",StudyTypeDr=3:"心电",StudyTypeDr=4:"超声",StudyTypeDr="RIS":"检验",StudyTypeDr=5:"内镜",StudyTypeDr=6:"放射")
   	...s PatientID=$p(info,"^",3)
   	...s Name=$p(^PAPER(PatientID,"ALL"),"^",1)
   	...s SexDR=$p(^PAPER(PatientID,"ALL"),"^",7)
   	...S Sex=$p(^CT("SEX",SexDR),"^",2)
   	...s Birthday=$p(^PAPER(PatientID,"ALL"),"^",6)
   	...s Age=##class(web.DHCDTHealthCommon).GetAgeDesc(Birthday,"")
   	...s Birthday=$zd(Birthday,3)
   	...s ItemDR=$p(info,"^",15)
   	...s ARCIMSubscript=$p(ItemDR,"||",1)
   	...s ARCIMVersion=$p(ItemDR,"||",2)
   	...s ItemDesc=$p(^ARCIM(ARCIMSubscript,ARCIMVersion,1),"^",2)
   	...s StudyNo=$p(info,"^",2)
   	...s ReportDate=$p(info,"^",18)
   	...s ReportDate=$zd(ReportDate,3)
   	...s ReportTime=$p(info,"^",19)
   	...s ReportTime=$zt(ReportTime,1)
   	...s ReportDocCode=$p(info,"^",20)
   	...s ReportDocRowid=""
   	...s ReportDocCode=$zcvt(ReportDocCode,"U")
   	...i ReportDocCode'=""  d
   	....s ReportDocRowid=$o(^SSU("SSUSR",0,"SSUSR_Initials",ReportDocCode,ReportDocRowid))
   	....i ReportDocRowid'="" s ReportDocName=$p(^SSU("SSUSR",ReportDocRowid),"^",2)
   	...s ReportURL=$p(info,"^",21)
   	...s IsChecked=$p(info,"^",12)
   	...s OrdRowid=$p(info,"^",22)
   	...i OrdRowid["||"  d
   	....s EpisodeID=$p(^OEORD(+OrdRowid),"^",1)
   	....Set Bed=$P($g(^PAADM(EpisodeID)),"^",73)
	....if Bed'="" s bedNo=$P($g(^PAWARD(+Bed,"BED",$P(Bed,"||",2))),"^",1)
   	....s MedNo=##class(DtPortal.Common.PaadmService).getMedicareNo(EpisodeID)
   	...i rptStatus="A" d
   	....Do QueryPortalRPTInfo
   	...i rptStatus=IsChecked d
   	....Do QueryPortalRPTInfo
   	
   	s patientid="" f  s patientid=$o(^DHCRBCLINICCHECKRPTINFOi("ATTENDING-CODE",docCode,patientid)) q:(patientid="")  d
	.s Appdate="" f  s Appdate=$o(^DHCRBCLINICCHECKRPTINFOi("ATTENDING-CODE",docCode,patientid,Appdate)) q:(Appdate="")  d
   	..q:(Appdate<StartDate)||(Appdate>EndDate)
   	..s Rowid=""  f  s Rowid=$o(^DHCRBCLINICCHECKRPTINFOi("ATTENDING-CODE",docCode,patientid,Appdate,Rowid)) q:(Rowid="")  d
   	...s info=^DHCRBCLINICCHECKRPTINFO(Rowid)
   	...s (StudyType,PatientID,Name,Sex,Birthday,ItemDR,StudyNo,ReportDate,ReportTime,ReportDocCode,ReportURL,IsChecked,ItemDesc,ReportDocName,OrdRowid,StudyTypeDr,EpisodeID,bedNo,MedNo)=""
   	...s appdoccode=$p(info,"^",11)
   	...i docCode'=appdoccode d    //统计作为主治医生数量（去掉既是申请又是主治的）
	....s StudyTypeDr=$p(info,"^",1)
	....s StudyType=$S(StudyTypeDr=1:"检验",StudyTypeDr="LIS":"检验",StudyTypeDr=2:"病理",StudyTypeDr=3:"心电",StudyTypeDr=4:"超声",StudyTypeDr="RIS":"检验",StudyTypeDr=5:"内镜",StudyTypeDr=6:"放射")
   	....s PatientID=$p(info,"^",3)
   	....;s Name=$p(info,"^",4)
   	....;s Sex=$p(info,"^",5)
   	....;s Birthday=$p(info,"^",6)
   	....s Name=$p(^PAPER(PatientID,"ALL"),"^",1)
   	....s SexDR=$p(^PAPER(PatientID,"ALL"),"^",7)
   	....S Sex=$p(^CT("SEX",SexDR),"^",2)
   	....s Birthday=$p(^PAPER(PatientID,"ALL"),"^",6)
   	....s Age=##class(web.DHCDTHealthCommon).GetAgeDesc(Birthday,"")
   	....s Birthday=$zd(Birthday,3)
   	....s ItemDR=$p(info,"^",15)
   	....s ARCIMSubscript=$p(ItemDR,"||",1)
   	....s ARCIMVersion=$p(ItemDR,"||",2)
   	....s ItemDesc=$p(^ARCIM(ARCIMSubscript,ARCIMVersion,1),"^",2)
   	....s StudyNo=$p(info,"^",2)
   	....s ReportDate=$p(info,"^",18)
   	....s ReportDate=$zd(ReportDate,3)
   	....s ReportTime=$p(info,"^",19)
   	....s ReportTime=$zt(ReportTime,1)
   	....s ReportDocCode=$p(info,"^",20)
   	....s ReportDocRowid=""
   	....s ReportDocCode=$zcvt(ReportDocCode,"U")
   	....i ReportDocCode'=""  d
   	.....s ReportDocRowid=$o(^SSU("SSUSR",0,"SSUSR_Initials",ReportDocCode,ReportDocRowid))
   	.....i ReportDocRowid'="" s ReportDocName=$p(^SSU("SSUSR",ReportDocRowid),"^",2)
   	....s ReportURL=$p(info,"^",21)
   	....s IsChecked=$p(info,"^",8)
   	....s OrdRowid=$p(info,"^",22)
   	....i OrdRowid["||"  d
   	.....s EpisodeID=$p(^OEORD(+OrdRowid),"^",1)
   	.....Set Bed=$P($g(^PAADM(EpisodeID)),"^",73)
	.....if Bed'="" s bedNo=$P($g(^PAWARD(+Bed,"BED",$P(Bed,"||",2))),"^",1)
   	.....s MedNo=##class(DtPortal.Common.PaadmService).getMedicareNo(EpisodeID)
	....i rptStatus="A" d
   	.....Do QueryPortalRPTInfo
   	....i rptStatus=IsChecked d
   	.....Do QueryPortalRPTInfo
	
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK

QueryPortalRPTInfo
	set Data=$lb(StudyType,PatientID,Name,Sex,Age,ItemDR,StudyNo,ReportDate,ReportTime,ReportDocCode,ReportURL,IsChecked,ItemDesc,ReportDocName,OrdRowid,StudyTypeDr,EpisodeID,bedNo,MedNo)
 	Set ^||CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

}
