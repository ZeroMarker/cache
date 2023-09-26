Class web.DHCEkg.WJ.EKGQueryInfo Extends %RegisteredObject
{

/// Creator：      yangyali
/// CreatDate：    2018-12-6
/// Description:   获取心电系统检查过的医嘱号
/// Input：        开始日期，结束日期
/// Output：       医嘱号，多条以^分隔
/// w ##class(web.DHCEkg.WJ.EKGQueryInfo).GetOrdIds("2018-1-1","2018-12-30")
ClassMethod GetOrdIds(StartDate As %String, EndDate As %String) As %String
{
	s rtnOrdIds=""
	s (sdate,edate)=""
	//1.如果SD or ED 为空，那么取today，前段最好控制不为空
	//2.对日期格式需要进行处理
	//3.UserID为空则查全部的，否则查用户
	i StartDate["-" s StartDate=$zdh(StartDate,3)
	i EndDate["-" s EndDate=$zdh(EndDate,3)
	
	i StartDate["/" d
	.s StartDate=$translate(StartDate,"/","-") ;$translate("2015/02/05","/","-")
	.s StartDate=$zdh(StartDate,3)
	
	i EndDate["/" d
	.s EndDate=$translate(EndDate,"/","-")
	.s EndDate=$zdh(EndDate,3)
	
	i (StartDate="") && (EndDate="")  d
	.s sdate=$p($h,",",1)-15,edate=$p($h,",",1)+2
	e  d
	.s sdate=StartDate,edate=EndDate
	
	new $namespace
	s CurrSpace=$ZNSPACE
	d ##class(web.DHCEkgSystemParam).SetEKGNameSpace()
	s examId=""
	f  s examId=$o(^dbo.tblExaminationD(examId)) q:examId=""  d
	.s examInfo=$g(^dbo.tblExaminationD(examId))
	.q:(examInfo="")
	.s oprTime=$listget(examInfo,13,"")
	.q:oprTime=""
	.s operateDate=$zdh($p(oprTime,$c(32),1),3)
	.;b ; w operateDate
	.q:((operateDate>edate)!(operateDate<sdate))
	.s statuscode=$listget(examInfo,20,"")
	.;b ;w statuscode
	.q:(statuscode="")!(statuscode="2") ;无效状态或空状态
	.s reqId=$listget(examInfo,19,"")
	.q:(reqId="")
	.s reqInfo=$g(^dbo.tblRequestD(reqId))
	.q:(reqInfo="")
	.s patId=$listget(reqInfo,16,"")
	.;b ; w patId
	.q:(patId="")
	.s patInfo=$g(^dbo.tblPatientD(patId))
	.q:(patInfo="")
	.s patCode=$listget(patInfo,20,"")
	.q:(patCode="") ;登记号为空，非his病人
	.s ordId=$listget(reqInfo,6,"")
	.q:(ordId="")
	.;b ; w ordId
	.i (rtnOrdIds'="") s rtnOrdIds=rtnOrdIds_"^"_ordId
	.e  s rtnOrdIds=ordId
	
	zn CurrSpace
	q rtnOrdIds
}

/// 函数： 	QueryWJDJOrdInfo
/// 望京岱嘉，获取心电系统检查过的医嘱号
/// Input：	开始日期，结束日期
/// 作者： 	yangyali
/// 日期： 	2018-12-7
/// d ##class(%ResultSet).RunQuery("web.DHCEkg.WJ.EKGQueryInfo","QueryWJDJOrdInfo","2018-1-1","2018-12-30")
Query QueryWJDJOrdInfo(StartDate As %String, EndDate As %String) As %Query(ROWSPEC = "OrdId,AdmNo")
{
}

ClassMethod QueryWJDJOrdInfoExecute(ByRef qHandle As %Binary, StartDate As %String, EndDate As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	//医嘱号，就诊号
	s (OrdId,AdmNo)=""
	s (sdate,edate)=""
	//1.如果SD or ED 为空，那么取today，前段最好控制不为空
	//2.对日期格式需要进行处理
	//3.UserID为空则查全部的，否则查用户
	i StartDate["-" s StartDate=$zdh(StartDate,3)
	i EndDate["-" s EndDate=$zdh(EndDate,3)
	
	i StartDate["/" d
	.s StartDate=$translate(StartDate,"/","-") ;$translate("2015/02/05","/","-")
	.s StartDate=$zdh(StartDate,3)
	
	i EndDate["/" d
	.s EndDate=$translate(EndDate,"/","-")
	.s EndDate=$zdh(EndDate,3)
	
	i (StartDate="") && (EndDate="")  d
	.s sdate=$p($h,",",1)-15,edate=$p($h,",",1)+2
	e  d
	.s sdate=StartDate,edate=EndDate
	
	new $namespace
	d ##class(web.DHCEkgSystemParam).SetEKGNameSpace()
	
	s examId="" 
	
	s examId=""
	f  s examId=$o(^dbo.tblExaminationD(examId)) q:examId=""  d
	.s examInfo=$g(^dbo.tblExaminationD(examId))
	.q:(examInfo="")
	.s oprTime=$listget(examInfo,13,"")
	.q:oprTime=""
	.s operateDate=$zdh($p(oprTime,$c(32),1),3)
	.;b ; w operateDate
	.q:((operateDate>edate)!(operateDate<sdate))
	.s statuscode=$listget(examInfo,20,"")
	.;b ;w statuscode
	.q:(statuscode="")!(statuscode="2") ;无效状态或空状态
	.s reqId=$listget(examInfo,19,"")
	.q:(reqId="")
	.s reqInfo=$g(^dbo.tblRequestD(reqId))
	.q:(reqInfo="")
	.s patId=$listget(reqInfo,16,"")
	.;b ; w patId
	.q:(patId="")
	.s patInfo=$g(^dbo.tblPatientD(patId))
	.q:(patInfo="")
	.s patCode=$listget(patInfo,20,"")
	.q:(patCode="") ;登记号为空，非his病人
	.s OrdId=$listget(reqInfo,6,"")
	.q:(OrdId="")
	.d OutWJDJOrdInfoRow
	zn "dhc-app"
 	s qHandle=$lb(0,repid,0)
	q $$$OK
 	
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK

OutWJDJOrdInfoRow
	new $namespace
	zn "dhc-app"
	s OrderRowid=$p(OrdId,"||",1)
	s itemsub=$p(OrdId,"||",2)
	q:(itemsub="")
	q:$g(^OEORD(OrderRowid,"I",itemsub,1))="" ;非his医嘱
	s AdmNo=$P($G(^OEORD(OrderRowid)),"^",1)
	q:(AdmNo="")
	s Data=$lb(OrdId,AdmNo)
 	S ^CacheTemp(repid,ind)=Data 	
 	S ind=ind+1
	q
}

ClassMethod QueryWJDJOrdInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryWJDJReportInfoExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod QueryWJDJOrdInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryWJDJReportInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// 函数： QueryWJDJReportInfo
/// 望京岱嘉报告平台
/// 作者： yangyali
/// 日期： 2018-11-13
/// d ##class(%ResultSet).RunQuery("web.DHCEkg.WJ.EKGQueryInfo","QueryWJDJReportInfo","41||85^1094||48")
Query QueryWJDJReportInfo(StudyNoList As %String) As %Query(ROWSPEC = "DocName,DocumentDomainId,DocumentUniqueId,Accessionnum,AuthorName,BodyPart,DicomStudyTime,EffectiveTime,Modality,StudyUid,PdfPathDir,PdfPath,PatientNo,PatientName,PatientSexName,PatientAge,StudyDepartmen,ReportConclusion,HeartRate,AtrialRate,VentricularRate,PDuration,RV5SV1,PRInterval,PRT,QRSDuration,QTQTc,RV5SV1SUM,EGCDiagnosis,DiagnosisPhysician,AuditPhysician,UploadOn,ReportOn,StudyRoom,StudyBedroom,ApplicationPhysician,QRSAxis,Feature,PatientName,PatientSex,PatientSexName,PatientBirthTime,PatientId,PatientDomainId,VisitFlowId,VisitFlowDomainId,HisType,HisTypeName,hisId,HisDomainId,HisVisitFlowId,HisVisitFlowDomainId,HospitalDomainId,HospitalDomainName,OrderTime,ItemName,Frequ,Doctor,DoctorId,ProofTime,ProofNurse,ProofNurseId")
{
}

ClassMethod QueryWJDJReportInfoExecute(ByRef qHandle As %Binary, StudyNoList As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	// 报告名称,文档对应的机构域,文档的唯一ID号,影像检查AccNumber,报告医生,检查部位,影像检查日期格式:yyyyMMddHHmmss
	s (DocName,DocumentDomainId,DocumentUniqueId,Accessionnum,AuthorName,BodyPart,DicomStudyTime)=""
	// 报告生效时间,检查设备,StudyUid,报告内容PDF文件目录,报告内容PDF文件路径
	s (EffectiveTime,Modality,StudyUid,PdfPathDir,PdfPath)=""
	// 病案号,患者姓名,患者性别,患者年龄,科室,临床诊断
	s (PatientNo,PatientName,PatientSexCode,PatientSexName,PatientAge,StudyDepartmen,ReportConclusion)=""
	// 心率,房率,室率,P波时限,RV5/SV1,P-R间期,P/R/T,QRS时限,QT/QTc,RV5+SV1,QRS电轴
	s (HeartRate,AtrialRate,VentricularRate,PDuration,RV5SV1,PRInterval,PRT,QRSDuration,QTQTc,RV5SV1SUM,QRSAxis)=""
	// 诊断,诊断医师,审核医师,上传时间,报告时间,病区,床号,申请医师,特征
	s (EGCDiagnosis,DiagnosisPhysician,AuditPhysician,UploadOn,ReportOn,StudyRoom,StudyBedroom,ApplicationPhysician,Feature)=""
	// 患者姓名,患者性别,患者性别名称:男、女,患者出生日期,格式:yyyyMMdd,机构内患者
	s (PatientName,PatientSex,PatientSexName,PatientBirthTime,PatientId)=""
	// 患者机构域,患者流水号,流水机构域ID,患者类型,患者类型名称,患者住院号门诊号
	s (PatientDomainId,VisitFlowId,VisitFlowDomainId,HisType,HisTypeName,hisId)=""
	// 患者住院号门诊号机构域ID,患者住院流水号门诊流水号,患者住院流水号门诊流水号机构域ID,医院机构域ID,医院机构医院名称
	s (HisDomainId,HisVisitFlowId,HisVisitFlowDomainId,HospitalDomainId,HospitalDomainName)=""
	// 下嘱时间(格式:yyyyMMddHHmmss),项目,频次,医师,医师工号,校对时间,校对护士
	s (OrderTime,ItemName,Frequ,Doctor,DoctorId,ProofTime,ProofNurse,ProofNurseId)=""
	
	for i=1:1:$l(StudyNoList,"^") d
	.s rptInfo=..GetRptInfo($p(StudyNoList,"^",i))
	.s DocumentUniqueId=$p(rptInfo,"^",1)
	.s Accessionnum=$p(rptInfo,"^",2)
	.s AuthorName=$p(rptInfo,"^",3)
	.s DicomStudyTime=$p(rptInfo,"^",4)
	.s Modality=$p(rptInfo,"^",5)
	.s PdfPathDir=$p(rptInfo,"^",6)
	.s PdfPath=$p(rptInfo,"^",7)
	.s PatientNo=$p(rptInfo,"^",8)
	.s PatientName=$p(rptInfo,"^",9)
	.s PatientSexName=$p(rptInfo,"^",10)
	.s PatientAge=$p(rptInfo,"^",11)
	.s StudyDepartmen=$p(rptInfo,"^",12)
	.s ReportConclusion=$p(rptInfo,"^",13)
	.s HeartRate=$p(rptInfo,"^",14)
	.s AtrialRate=$p(rptInfo,"^",15)
	.s VentricularRate=$p(rptInfo,"^",16)
	.s PDuration=$p(rptInfo,"^",17)
	.s RV5SV1=$p(rptInfo,"^",18)
	.s PRInterval=$p(rptInfo,"^",19)
	.s PRT=$p(rptInfo,"^",20)
	.s QRSDuration=$p(rptInfo,"^",21)
	.s QTQTc=$p(rptInfo,"^",22)
	.s RV5SV1SUM=$p(rptInfo,"^",23)
	.s QRSAxis=$p(rptInfo,"^",24)
	.s EGCDiagnosis=$p(rptInfo,"^",25)
	.s DiagnosisPhysician=$p(rptInfo,"^",26)
	.s AuditPhysician=$p(rptInfo,"^",27)
	.s UploadOn=$p(rptInfo,"^",28)
	.s ReportOn=$p(rptInfo,"^",29)
	.s EffectiveTime=$p(rptInfo,"^",29)
	.s StudyRoom=$p(rptInfo,"^",30)
	.s StudyBedroom=$p(rptInfo,"^",31)
	.s ApplicationPhysician=$p(rptInfo,"^",32)
	.s Feature=$p(rptInfo,"^",33)
	.s PatientName=$p(rptInfo,"^",34)
	.s PatientSex=$p(rptInfo,"^",35)
	.s PatientSexName=$p(rptInfo,"^",36)
	.s PatientBirthTime=$p(rptInfo,"^",37)
	.s PatientId=$p(rptInfo,"^",38)
	.s HisType=$p(rptInfo,"^",39)
	.i (HisType="0") d ;门急诊
	..s HisDomainId="2.16.840.1.113883.4.487.5.8.4.1"
	..s HisVisitFlowDomainId="2.16.840.1.113883.4.487.5.8.4.2"
	.e  d ;住院
	..s HisDomainId="2.16.840.1.113883.4.487.5.8.4.3"
	..s HisVisitFlowDomainId="2.16.840.1.113883.4.487.5.8.4.4"
	.s HisTypeName=$p(rptInfo,"^",40)
	.s HospitalDomainName=$p(rptInfo,"^",41)
	.s OrderTime=$p(rptInfo,"^",42)
	.s ItemName=$p(rptInfo,"^",43)
	.s BodyPart=ItemName
	.s hisId=$p(rptInfo,"^",44)
	.s OrdId=$p(StudyNoList,"^",i)
	.s OrderRowid=$p(OrdId,"||",1)
	.s AdmNo=$P($G(^OEORD(OrderRowid)),"^",1)
	.s VisitFlowId=AdmNo
	.s HisVisitFlowId=AdmNo
	.d OutWJDJInfoRow
 	
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK

OutWJDJInfoRow
	set Data=$lb(DocName,DocumentDomainId,DocumentUniqueId,Accessionnum,AuthorName,BodyPart,DicomStudyTime,EffectiveTime,Modality,StudyUid,PdfPathDir,PdfPath,PatientNo,PatientName,PatientSexName,PatientAge,StudyDepartmen,ReportConclusion,HeartRate,AtrialRate,VentricularRate,PDuration,RV5SV1,PRInterval,PRT,QRSDuration,QTQTc,RV5SV1SUM,EGCDiagnosis,DiagnosisPhysician,AuditPhysician,UploadOn,ReportOn,StudyRoom,StudyBedroom,ApplicationPhysician,QRSAxis,Feature,PatientName,PatientSex,PatientSexName,PatientBirthTime,PatientId,PatientDomainId,VisitFlowId,VisitFlowDomainId,HisType,HisTypeName,hisId,HisDomainId,HisVisitFlowId,HisVisitFlowDomainId,HospitalDomainId,HospitalDomainName,OrderTime,ItemName,Frequ,Doctor,DoctorId,ProofTime,ProofNurse,ProofNurseId)
 	Set ^CacheTemp(repid,ind)=Data
 	//s ^TMPINV(ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod QueryWJDJReportInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryWJDJReportInfoExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod QueryWJDJReportInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryWJDJReportInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// 入参：		医嘱号
/// 返回值：	文档的唯一ID号^影像检查AccNumber^报告医生^影像检查日期格式:yyyyMMddHHmmss^
/// 				检查设备^报告内容PDF文件目录^报告内容PDF文件路径^病案号^患者姓名^患者性别^
/// 				患者年龄^科室^临床诊断^心率^房率^室率^P波时限^RV5/SV1^P-R间期^P/R/T^QRS时限^
/// 				QT/QTc^RV5+SV1^QRS电轴^诊断^诊断医师^审核医师^上传时间^报告时间^病区^床号^
/// 				申请医师^特征^患者姓名^患者性别^患者性别名称:男、女^患者出生日期^格式:yyyyMMdd^
/// 				机构内患者ID^患者类型^患者类型名称^医院机构医院名称^下嘱时间(格式:yyyyMMddHHmmss)^项目
/// w ##class(web.DHCEkg.WJ.EKGQueryInfo).GetRptInfo("41||85")
ClassMethod GetRptInfo(OrdId) As %String
{
	new $namespace
	s CurrSpace=$ZNSPACE
	s (DocumentUniqueId,Accessionnum,AuthorName,DicomStudyTime,Modality,PdfPathDir,PdfPath,PatientNo,PatientName,PatientSexName,PatientAge,StudyDepartmen,ReportConclusion,HeartRate,AtrialRate,VentricularRate,PDuration,RV5SV1,PRInterval,PRT,QRSDuration,QTQTc,RV5SV1SUM,QRSAxis,EGCDiagnosis,DiagnosisPhysician,AuditPhysician,UploadOn,ReportOn,StudyRoom,StudyBedroom,ApplicationPhysician,Feature,PatientName,PatientSex,PatientSexName,PatientBirthTime,PatientId,HisType,HisTypeName,HospitalDomainName,OrderTime,ItemName,hisId)=""
	d ##class(web.DHCEkgSystemParam).SetEKGNameSpace()	
	s (reqId,examId,patId,fileId,volId,paramId,reqInfo,examInfo,patInfo,fileInfo,volInfo,paramInfo)=""
	s reqId=$o(^dbo.tblRequestI("indexBarcode"," "_OrdId,reqId))
	q:(reqId="") ""
	s examId=$o(^dbo.tblExaminationI("idxRequestID",reqId,examId))
	q:(examId="") ""
	s reqInfo=$g(^dbo.tblRequestD(reqId))
	q:(reqInfo="") "" 
	s patId=$listget(reqInfo,16,"")
	q:(patId="") ""
	s patInfo=$g(^dbo.tblPatientD(patId))
	q:(patInfo="") ""
	s examInfo=$g(^dbo.tblExaminationD(examId))
	s DocumentUniqueId=examId
	s Accessionnum=examId
	s arbiterId=$listget(examInfo,7,"")
	i (arbiterId'="")&&(arbiterId'="0") d
	.s userInfo=$g(^dbo.tblUserD(arbiterId))
	.q:(userInfo="")
	.s AuthorName=$listget(userInfo,11,"")
	s operateTime=$listget(examInfo,13,"")
	s DicomStudyTime=$replace($replace($replace($replace(operateTime,"-","")," ",""),":",""),"/","")
	s deviceId=$listget(examInfo,10,"")
	i (deviceId'="") d
	.s devInfo=$g(^dbo.tblDeviceD(deviceId))
	.q:(devInfo="")
	.s Modality=$listget(devInfo,6,"")
	s PatientNo=$listget(patInfo,11,"")
	s PatientCode=$listget(patInfo,20,"")
	s PatientName=$listget(patInfo,16,"")
	s sex=$listget(patInfo,8,"")
	i (sex="m")	s PatientSexName="男"
	i (sex="f")	s PatientSexName="女"
	s PatientAge=$listget(examInfo,5,"")
	s deptCode=$listget(reqInfo,9,"")
	i (deptCode'="") d
	.s deptCode=$ZCVT(deptCode,"U")
	.s deptId=$o(^dbo.tblDictDeptI("idxDeptCode"," "_deptCode,""))
	.q:(deptId="")
	.s deptInfo=$g(^dbo.tblDictDeptD(deptId))
	.q:(deptInfo="")
	.s StudyDepartmen=$listget(deptInfo,4,"")
	s ReportConclusion=$listget(reqInfo,8,"")
	
	s Diagnose=$listget(examInfo,11,"")
	if Diagnose'[$c(10) set Diagnose=Diagnose_$c(10) ;2015-08-13
	set D=""
	for i=1:1:$l(Diagnose,$c(10)) do
	.set tmpD=$p(Diagnose,$c(10),i)
	.if (tmpD'="") do
	..if (D="") set D=tmpD
	..else  set D=D_","_tmpD
	s EGCDiagnosis=D
	s DiagnosisPhysician=AuthorName
	s AuditPhysician=AuthorName
	s UploadOn=DicomStudyTime
	s arbiterTime=$listget(examInfo,6,"")
	s ReportOn=$replace($replace($replace($replace(arbiterTime,"-","")," ",""),":",""),"/","")
	s StudyRoom=$listget(reqInfo,22,"")
	s StudyBedroom=$listget(reqInfo,7,"")
	s ApplicationPhysician=$listget(reqInfo,12,"")
	
	s PatientSex=$listget(patInfo,8,"")
	s PatientSex=$ZCONVERT(PatientSex,"U")
	s PatientBirthTime=$listget(patInfo,3,"")
	s PatientBirthTime=$replace($p($replace(PatientBirthTime,"-","")," ",1),"/","")
	s PatientId=$listget(patInfo,20,"")
	s patSource=$listget(examInfo,15,"")
	i patSource="2" d
	.s HisType="1"
	.s HisTypeName="住院"
	.s hisId=PatientNo
	i patSource="3" d
	.s HisType="0"
	.s HisTypeName="门诊"
	.s hisId=PatientCode
	i patSource="4" d
	.s HisType="0"
	.s HisTypeName="门诊"
	.s hisId=PatientCode
	s cfgHospId=$o(^dbo.tblConfigureI("idxKey"," HOSPITALNAME",""))
	i (cfgHospId'="") d
	.s hosInfo=$g(^dbo.tblConfigureD(cfgHospId))
	.q:(hosInfo="")
	.s HospitalDomainName=$listget(hosInfo,6,"")
	/*s cfgUrlId=$o(^dbo.tblConfigureI("idxKey"," FTPHTTPURL",""))
	i (cfgUrlId'="") d
	.s cfgUrlInfo=$g(^dbo.tblConfigureD(cfgUrlId))
	.q:(cfgUrlInfo="")
	.s PdfPathDir=$listget(cfgUrlInfo,6,"")
	*/
	
	s OrderTime=$listget(reqInfo,18,"")
	s OrderTime=$replace($replace($replace($replace(OrderTime,"-","")," ",""),":",""),"/","")
	s itemCode=$listget(reqInfo,11,"")
	s itemCode=$ZCVT(itemCode,"U")
	;b ; w itemCode
	s examItemId=$o(^dbo.tblDictExamItemI("idxExamItemCode"," "_itemCode,""))
	i (examItemId'="") d
	.s examItemInfo=$g(^dbo.tblDictExamItemD(examItemId))
	.q:(examItemInfo="")
	.s ItemName=$listget(examItemInfo,6,"")
	
	s paramId=$o(^dbo.tblParamRestI("idxExaminationId",examId,paramId))
	i (paramId'="") d
	.s paramInfo=$g(^dbo.tblParamRestD(paramId))
	.i (paramInfo'="") d
	..s HeartRate=$listget(paramInfo,2,"")
	..s AtrialRate=$listget(paramInfo,2,"")
	..s VentricularRate=$listget(paramInfo,17,"")
	..s PDuration=$listget(paramInfo,6,"")
	..s rv5=$listget(paramInfo,12,"")
	..s sv1=$listget(paramInfo,14,"")
	..s RV5SV1=rv5_"/"_sv1
	..s PRInterval=$listget(paramInfo,7,"")
	..s PRT=$listget(paramInfo,8,"")_"/"_$listget(paramInfo,13,"")_"/"_$listget(paramInfo,16,"")
	..s QRSDuration=$listget(paramInfo,9,"")
	..s QTQTc=$listget(paramInfo,10,"")_"/"_$listget(paramInfo,11,"")
	..s RV5SV1SUM=rv5+sv1
	..s QRSAxis=$listget(paramInfo,13,"")
	
	s fileId=$o(^dbo.tblFilePathI("idxExaminationID",examId,fileId))
	i (fileId'="") d
	.s fileInfo=$g(^dbo.tblFilePathD(fileId))
	.q:(fileInfo="")
	.s volCode=$listget(fileInfo,7,"")
	.q:(volCode="")
	.s volId=$o(^dbo.tblDictVolumnI("idxCode"," "_volCode,""))
	.q:(volId="")
	.s volInfo=$g(^dbo.tblDictVolumnD(volId))
	.s PdfPathDir=$listget(volInfo,5,"")
	.q:(PdfPathDir="")
	.s PdfPath=$listget(fileInfo,6,"")
	.i (PdfPath'="") s PdfPath=PdfPathDir_PdfPath
	
	zn CurrSpace
	s rtnRptInfo=DocumentUniqueId_"^"_Accessionnum_"^"_AuthorName_"^"_DicomStudyTime_"^"_Modality_"^"_PdfPathDir_"^"_PdfPath_"^"_PatientNo_"^"_PatientName_"^"_PatientSexName_"^"_PatientAge_"^"_StudyDepartmen_"^"_ReportConclusion_"^"_HeartRate_"^"_AtrialRate_"^"_VentricularRate_"^"_PDuration_"^"_RV5SV1_"^"_PRInterval_"^"_PRT_"^"_QRSDuration_"^"_QTQTc_"^"_RV5SV1SUM_"^"_QRSAxis_"^"_EGCDiagnosis_"^"_DiagnosisPhysician_"^"_AuditPhysician_"^"_UploadOn_"^"_ReportOn_"^"_StudyRoom_"^"_StudyBedroom_"^"_ApplicationPhysician_"^"_Feature_"^"_PatientName_"^"_PatientSex_"^"_PatientSexName_"^"_PatientBirthTime_"^"_PatientId_"^"_HisType_"^"_HisTypeName_"^"_HospitalDomainName_"^"_OrderTime_"^"_ItemName_"^"_hisId
	q rtnRptInfo
}

}
