Class ES.LIS.DHCSyncCheckedSampleInfo Extends %RegisteredObject
{

/// Creator：    zhangli
/// CreatDate：  2021-08-01
/// Description: 查询中间表中待同步数据
/// Table：      dbo.RI_LabTestSet,dbo.RI_LabRequest
/// Input：      WorkGroupMachineDR:工作小组DR,TransmitDate:传输日期，LabNo:检验号
/// Output：     无
/// Return： 
/// Others：     其它说明
/// d ##Class(%ResultSet).RunQuery("ES.LIS.DHCSyncCheckedSampleInfo","QryLabInfo","2","2021-09-29","","","","","","","","","","","","","113^7^0^12^1")
Query QryLabInfo(WorkGroupMachineDR, TransmitDate, LabNo, P3, P4, P5, P6, P7, P8, P9, P10, P11, P12, P13, Sessions, Output RowCount As %String) As %Query(ROWSPEC = "RITestSetDR,TestSetCode,TestSetDesc,TestSetFee,Labno,SpecimenDesc,LocationDesc,WGMachineDR,WGMachineDesc,TransDate,AssayNo,RegNo,SurName,SpeciesName,Age,AgeUnit,AcceptDate,AcceptTime,AcceptUser,AcceptUserDR,ReportID,IsChanged,UpdateDate,UpdateTime,AddDate,AddTime,EpisodeNo")
{
}

ClassMethod QryLabInfoExecute(ByRef qHandle As %Binary, WorkGroupMachineDR, TransmitDate, LabNo, P3, P4, P5, P6, P7, P8, P9, P10, P11, P12, P13, Sessions, Output RowCount As %String) As %Status
{
	
	s ^TMPLIS("QryLabInfoExecute")=$lb(WorkGroupMachineDR, TransmitDate, LabNo, P3, P4, P5, P6, P7, P8, P9, P10, P11, P12, P13, Sessions)
	s WorkGroupMachineDR=$g(WorkGroupMachineDR), TransmitDate=$g(TransmitDate), LabNo=$g(LabNo),Sessions=$g(Sessions)
	s UserID=$p(Sessions,"^",1),WorkGroupDR=$p(Sessions,"^",2),HospitalDR=$p(Sessions,"^",5),LocationDR=$p(Sessions,"^",3)

	Set repid=$i(^CacheTemp)
 	Set ind=1
	s RowCount=0
	s TransmitDate=$tr(TransmitDate,"-")
	k ^TMPLIS($zn,repid,$j)
    
    i $l(LabNo) d
    .s indexLabNo = LabNo //##Class(LIS.Util.Common).IndexData(LabNo)
    .s fRITestSetDR="" f  s fRITestSetDR=$o(^dbo.RILabTestSetI("BarCode",indexLabNo,fRITestSetDR)) q:fRITestSetDR=""  d
    ..d GetInfo
    e  i $l(WorkGroupMachineDR),$l(TransmitDate) d
    .s fAssayNo=""  f  s fAssayNo=$o(^dbo.RILabTestSetI("IndexTransmitDate",WorkGroupMachineDR,TransmitDate,fAssayNo)) q:fAssayNo=""  d
    ..s fRITestSetDR=""  f  s fRITestSetDR=$o(^dbo.RILabTestSetI("IndexTransmitDate",WorkGroupMachineDR,TransmitDate,fAssayNo,fRITestSetDR)) q:fRITestSetDR=""  d
    ...d GetInfo
   
    //结果输出
    s fReportID="" f  s fReportID=$o(^TMPLIS($zn,repid,$j,"RITestSet",fReportID)) q:fReportID=""  d
    .s comRITestSetDR="",comTestSetDesc="",comTestSetCode="",comTestSetFee=""
    .s fRITestSetDR="" f  s fRITestSetDR=$o(^TMPLIS($zn,repid,$j,"RITestSet",fReportID,fRITestSetDR)) q:fRITestSetDR=""  d
    ..i $l(comRITestSetDR) s comRITestSetDR=comRITestSetDR_"^"_fRITestSetDR
    ..e  s comRITestSetDR=fRITestSetDR
    ..s tmpData=$g(^TMPLIS($zn,repid,$j,"RITestSet",fReportID,fRITestSetDR))
    ..s TestSetCode=$lg(tmpData,2)
    ..s TestSetDesc=$lg(tmpData,3)
    ..s TestSetFee=$lg(tmpData,4)
    ..i $l(comTestSetCode) s comTestSetCode=comTestSetCode_"+"_TestSetCode,comTestSetDesc=comTestSetDesc_"+"_TestSetDesc,comTestSetFee=comTestSetFee_"@I@"_TestSetFee
    ..e  s comTestSetCode=TestSetCode,comTestSetDesc=TestSetDesc,comTestSetFee=TestSetFee
    .s $li(tmpData,1)=comRITestSetDR
    .s $li(tmpData,2)=comTestSetCode
    .s $li(tmpData,3)=comTestSetDesc
    .s $li(tmpData,4)=comTestSetFee
    .s Data=tmpData
    .d OutPut
    
	k ^TMPLIS($zn,repid,$j)
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
GetInfo
    //医嘱信息
    s RITestSetDR =fRITestSetDR
	s RITestSetData=$g(^dbo.RILabTestSetD(RITestSetDR))
	s ReportID=$lg(RITestSetData,68)
	i '$l(ReportID) q //只同步已经核收的,只接收的走应急库普通的核收操作完成入组
	s IsChanged=$lg(RITestSetData,69)
	i IsChanged'=1 q  //为1表示需要同步
	s TestSetCode = $lg(RITestSetData,2)
    s TestSetDesc = $lg(RITestSetData,3)
    s TestSetDR=""
    i $d(^dbo.BTTestSetI("IndexCode",HospitalDR,##Class(LIS.Util.Common).IndexData(TestSetCode))) d
	.s TestSetDR=$o(^dbo.BTTestSetI("IndexCode",HospitalDR,##Class(LIS.Util.Common).IndexData(TestSetCode),""))
    s HISOrderID=$lg(RITestSetData,4) 
    s Labno = $lg(RITestSetData,6)
    s quitfalg=0
    s indexLabNo =##Class(LIS.Util.Common).IndexData(Labno)
    s VisitNumberDR= $o(^dbo.RPVisitNumberI("IndexVisitNumber",indexLabNo,"")) 
    i $l(VisitNumberDR),$l(TestSetDR) d 
    .s VNTestSetDR=$o(^dbo.RPVisitNumberTestSetI("IndexMaster",VisitNumberDR,TestSetDR,""))
    .s VNTSReportDR=$lg($g(^dbo.RPVisitNumberTestSetD(VNTestSetDR)),11)
    .i $l(VNTSReportDR) s quitfalg=1
    i quitfalg=1 q     //过滤掉已经同步过的报告
    s TestSetFee= $lg(RITestSetData,43)
    s SpecimenDesc =$lg(RITestSetData,11)
    s LocationDesc = $lg(RITestSetData,16)
    s WGMachineDR = $lg(RITestSetData,62),WGMachineDesc=""
    i $l(WGMachineDR) d
    .s WorkGroupMachineData =$g(^dbo.BTWorkGroupMachineD(WGMachineDR))
 	.s WGMachineDesc=$lg(WorkGroupMachineData,3) 
	s TransDate = $lg(RITestSetData,63)
	//AssayNo,AcceptDate,AcceptTime,AcceptUser,AcceptUserDR,ReportID,IsChanged,UpdateDate,UpdateTime,AddDate,AddTime
	s AssayNo = $lg(RITestSetData,64)
	s AcceptDate=$lg(RITestSetData,65)
    s AcceptTime=$lg(RITestSetData,66)
    s AcceptUserDR=$lg(RITestSetData,67),AcceptUser=""
	i $l(AcceptUserDR) d
	.s AcceptUser=$lg($g(^dbo.SYSUserD(AcceptUserDR)),3)
    s UpdateDate =$lg(RITestSetData,70)
    s UpdateTime =$lg(RITestSetData,71)
    s AddDate=$lg(RITestSetData,72)
    s AddTime=$lg(RITestSetData,73)
    s EpisodeNo = $lg(RITestSetData,74)
    //基本信息
	s RILabRequestDR =$lg(RITestSetData,1)
	s RILabRequestData=$g(^dbo.RILabRequestD(RILabRequestDR))
	s RegNo = $lg(RILabRequestData,3)
	s SurName = $lg(RILabRequestData,13)
	s SpeciesName = $lg(RILabRequestData,16)
	s Age = $lg(RILabRequestData,19)
	s AgeUnit = $lg(RILabRequestData,20)        
 	
 	Set Data=$lb(RITestSetDR,TestSetCode,TestSetDesc,TestSetFee,Labno,SpecimenDesc,LocationDesc,WGMachineDR,WGMachineDesc,TransDate,AssayNo,RegNo,SurName,SpeciesName,Age,AgeUnit,AcceptDate,AcceptTime,AcceptUser,AcceptUserDR,ReportID,IsChanged,UpdateDate,UpdateTime,AddDate,AddTime,EpisodeNo)
 	i '$d(^TMPLIS($zn,repid,$j,"RITestSet",ReportID)) s RowCount=RowCount+1
 	s ^TMPLIS($zn,repid,$j,"RITestSet",ReportID,RITestSetDR)=Data
 	q
 	
OutPut	
 	Set ColFields="RITestSetDR,TestSetCode,TestSetDesc,TestSetFee,Labno,SpecimenDesc,LocationDesc,WGMachineDR,WGMachineDesc,TransDate,AssayNo,RegNo,SurName,SpeciesName,Age,AgeUnit,AcceptDate,AcceptTime,AcceptUser,AcceptUserDR,ReportID,IsChanged,UpdateDate,UpdateTime,AddDate,AddTime,EpisodeNo"
 	Set ^CacheTemp(repid,ind)=##Class(LIS.Util.Common).TransListNull(Data,ColFields)
 	Set ind=ind+1
	Quit
}

ClassMethod QryLabInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryLabInfoExecute ]
{
	Set repid=$li(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryLabInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryLabInfoExecute ]
{
	Set AtEnd=$li(qHandle,1)
 	Set repid=$li(qHandle,2)
 	Set ind=$li(qHandle,3)
 	
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				
 		Set AtEnd=1
 		Set Row=""
 	}
 	else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	Set qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：    zhangli
/// CreatDate：  2021-08-01
/// Description: 应急库中间表同步至应急库业务表
/// Table：      dbo.RI_LabTestSet,dbo.RI_LabRequest,dbo.RP_VisitNumber,dbo.RP_VisitNumberReport,dbo.RP_VisitNumberTestSet,dbo.RP_VisitNumberReportResult
/// Input：      RITestSetDRs:表dbo.RILabTestSet的RowID
/// Output：     无
/// Return：     1:成功，其他:失败
/// Others：     其它说明
/// w ##class(ES.LIS.DHCSyncCheckedSampleInfo).SyncReportInfoMTHD("488^489^490^491^492^493","","","","","","","","","","","","","","113^3^0^12^1")
ClassMethod SyncReportInfoMTHD(RITestSetDRs As %String(MAXLEN=32767), P1, P2, P3, P4, P5, P6, P7, P8, P9, P10, P11, P12, P13, Sessions, Output RowCount As %String) As %String
{
	s RITestSetDRs=$g(RITestSetDRs)
	q ##Class(LIS.WS.DHCLISServiceBase).DeclarativeTrans("ES.LIS.DHCSyncCheckedSampleInfo","SyncReportInfoDo",RITestSetDRs, "", "", "", "", "", "", "", "", "", "", "", "", "", Sessions,.RowCount)
}

/// Creator：    zhangli
/// CreatDate：  2021-08-01
/// Description: 应急库中间表同步至应急库业务表
/// Table：      dbo.RI_LabTestSet,dbo.RI_LabRequest,dbo.RP_VisitNumber,dbo.RP_VisitNumberReport,dbo.RP_VisitNumberTestSet,dbo.RP_VisitNumberReportResult
/// Input：      RITestSetDRs:表dbo.RILabTestSet的RowID，Sessions：
/// Output：     无
/// Return：     1:成功，其他:失败
/// Others：     其它说明
ClassMethod SyncReportInfoDo(RITestSetDRs As %String(MAXLEN=32767), P1, P2, P3, P4, P5, P6, P7, P8, P9, P10, P11, P12, P13, Sessions, Output RowCount As %String) As %String
{
	s ^MTMPLIS("SyncReportInfo")=$lb(RITestSetDRs, P1, P2, P3, P4, P5, P6, P7, P8, P9, P10, P11, P12, P13, Sessions)
	s RetValue=1
	s RITestSetDRs=$g(RITestSetDRs),Sessions=$g(Sessions)
	s UserID=$p(Sessions,"^",1),WorkGroupDR=$p(Sessions,"^",2),HospitalDR=$p(Sessions,"^",5)
    
	//遍历同步中间医嘱
	f i=1:1:$l(RITestSetDRs,"^") d
	.s fRITestSetDR=$p(RITestSetDRs,"^",i)
	.q:'$l(fRITestSetDR)
	.d SyncReport
    q RetValue
     
SyncReport
    s RILabTestSetData = $g(^dbo.RILabTestSetD(fRITestSetDR))
    i '$l(RILabTestSetData) q
	s RILabRequestDR=$lg(RILabTestSetData,1) 
	s RILabRequestData=$g(^dbo.RILabRequestD(RILabRequestDR))  
	s TestSetCode=$lg(RILabTestSetData,2),TestSetDR=""
	s IndexTestSetCode=##Class(LIS.Util.Common).IndexData(TestSetCode)
	i $d(^dbo.BTTestSetI("IndexCode",HospitalDR,IndexTestSetCode)) d
	.s TestSetDR=$o(^dbo.BTTestSetI("IndexCode",HospitalDR,IndexTestSetCode,""))
    i '$l(TestSetDR) q   //没有找到对应的医嘱 直接过滤掉（上面的查询QryLabInfo，没有过滤掉，这样老师在执行完同步计划后，有问题的数据会一直显示在页面。方便老师核对问题）
    s RITestSetReportID=$lg(RILabTestSetData,68) 
	i '$l(RITestSetReportID) q  //只同步已经核收的,只接收的走应急库普通的核收操作完成入组
	s IsChanged=$lg(RILabTestSetData,69)
	i IsChanged'=1 q  //为1表示需要同步
    s AdmissionTypeCode=$lg(RILabRequestData,2),AdmissionTypeDR=""
    i $l(AdmissionTypeCode) s AdmissionTypeDR=##Class(LIS.Util.BaseDataCommon).GetAdmissionTypeDR(AdmissionTypeCode)
    s RegNo=$lg(RILabRequestData,3)
    s AdmNo=$lg(RILabRequestData,4)
    s MedicalRecordNo=$lg(RILabRequestData,5)
    s AdmDate=$lg(RILabRequestData,6)
    s AdmDate=$tr(AdmDate,"-")
    s AdmTime=$lg(RILabRequestData,7)
    i AdmTime[":" s AdmTime=$zth(AdmTime,1)
    s IDNumber=$lg(RILabRequestData,10)
    s PatName=$lg(RILabRequestData,13)
    s GivenName=$lg(RILabRequestData,14)
    s SpeciesCode=$lg(RILabRequestData,15),SpeciesDR=""
    i $l(SpeciesCode) s SpeciesDR=##Class(LIS.Util.BaseDataCommon).GetSpeciesDR(SpeciesCode)
    s BirthDate=$lg(RILabRequestData,17)
    s BirthDate= $tr(BirthDate,"-")
    s BirthTime=$lg(RILabRequestData,18)
    s Age=$lg(RILabRequestData,19)
    s AgeUnitCode=$lg(RILabRequestData,20),AgeUnitDR="",AgeUnitDesc=""
    i $l(AgeUnitCode) s AgeUnitDR=##Class(LIS.Util.BaseDataCommon).GetAgeUnitDR(AgeUnitCode)
    i $l(AgeUnitDR) s AgeUnitDesc=$lg($g(^dbo.BTAgeUnitD(AgeUnitDR)),3)
    s HospitalCode=$lg(RILabRequestData,22)
    s Symptom=$lg(RILabRequestData,25)
    s MobileNo=$lg(RILabRequestData,26)
    s PhoneNo=$lg(RILabRequestData,27)
    s EMail=$lg(RILabRequestData,28)
    s Height=$lg(RILabRequestData,29)
    s Weight=$lg(RILabRequestData,30)
    s BloodPressure=$lg(RILabRequestData,31)
    s Pregnant=$lg(RILabRequestData,33)
    s PregnantWeeks=$lg(RILabRequestData,34)
    s Address=$lg(RILabRequestData,37)
    s PostCode=$lg(RILabRequestData,38)
    s InfectFlag=$lg(RILabRequestData,39)
    s InfectAlert=$lg(RILabRequestData,40)
    s PregnantNum=$lg(RILabRequestData,41)
    s ChildbirthNum=$lg(RILabRequestData,42)
    s LabNo=$lg(RILabTestSetData,6)
    s SpecimenCode=$lg(RILabTestSetData,10),SpecimenDR="" 
    s SpecimenName=$lg(RILabTestSetData,11)
    i $l(SpecimenCode) s SpecimenDR=##Class(LIS.Util.BaseDataCommon).GetSpecimenDR(SpecimenCode,SpecimenName,HospitalDR)
    s ContainerCode=$lg(RILabTestSetData,12),ContainerDR=""
    s ContainerName=$lg(RILabTestSetData,13)
    i $l(ContainerCode) s ContainerDR=##Class(LIS.Util.BaseDataCommon).GetContainerDR(ContainerCode,ContainerName,HospitalDR)
    s CollectNotes=$lg(RILabTestSetData,14)
    s LocationCode=$lg(RILabTestSetData,15),LocationDR=""  
    s LocationName=$lg(RILabTestSetData,16) 
    i $l(LocationCode) s LocationDR=##Class(LIS.Util.BaseDataCommon).GetLocationDR("",LocationCode,LocationName,HospitalDR)
    s WardCode=$lg(RILabTestSetData,17),WardDR=""
    s WardDesc=$lg(RILabTestSetData,18)   
    i $l(WardCode) s WardDR=##Class(LIS.Util.BaseDataCommon).GetWardDR("",WardCode,WardDesc,LocationDR)  
    s BedNo=$lg(RILabTestSetData,19)      
    s DoctorCode=$lg(RILabTestSetData,20),DoctorDR=""  
    s IndexDoctorCode=##Class(LIS.Util.Common).IndexData(DoctorCode)
    i $l(DoctorCode),$d(^dbo.BTDoctorI("IndexCode",IndexDoctorCode)) d
	.s DoctorDR=$o(^dbo.BTDoctorI("IndexCode",IndexDoctorCode,""))
    s RequestDate= $lg(RILabTestSetData,22) 
    s RequestDate= $tr(RequestDate,"-")
    s RequestTime=$lg(RILabTestSetData,23)    
    i RequestTime[":" s RequestTime=$zth(RequestTime,1)
    s ColDate=$lg(RILabTestSetData,29) 
    s ColDate= $tr(ColDate,"-")
    s ColTime=$lg(RILabTestSetData,30)  
    i ColTime[":" s ColTime=$zth(ColTime,1)
    s CollectUserCode=$lg(RILabTestSetData,31),CollectUserDR=""  
    s IndexColUCode=##Class(LIS.Util.Common).IndexData(CollectUserCode)
    i $l(CollectUserCode),$d(^dbo.SYSUserI("IndexCode",IndexColUCode)) d
	.s CollectUserDR=$o(^dbo.SYSUserI("IndexCode",IndexColUCode,""))
	s CarryDate=$lg(RILabTestSetData,35)
	s CarryDate= $tr(CarryDate,"-")
	s CarryTime=$lg(RILabTestSetData,36)
	i CarryTime[":" s CarryTime=$zth(CarryTime,1)
	s CarryUserCode=$lg(RILabTestSetData,37),CarryUserDR=""
	s IndexCarUCode=##Class(LIS.Util.Common).IndexData(CarryUserCode)
	i $l(CarryUserCode),$d(^dbo.SYSUserI("IndexCode",IndexCarUCode)) d
	.s CarryUserDR=$o(^dbo.SYSUserI("IndexCode",IndexCarUCode,""))
    s ReceiveDate=$lg(RILabTestSetData,39)  
    s ReceiveDate= $tr(ReceiveDate,"-")
    s ReceiveTime=$lg(RILabTestSetData,40) 
    i ReceiveTime[":" s ReceiveTime=$zth(ReceiveTime,1)
    s ReceiveUserCode =$lg(RILabTestSetData,41),ReceiveUserDR="" 
    s IndexRecUCode=##Class(LIS.Util.Common).IndexData(ReceiveUserCode)
	i $l(ReceiveUserCode),$d(^dbo.SYSUserI("IndexCode",IndexRecUCode)) d
	.s ReceiveUserDR=$o(^dbo.SYSUserI("IndexCode",IndexRecUCode,""))
    s ReqNotes=$lg(RILabTestSetData,45)
    s Urgent=$lg(RILabTestSetData,47)
    s H24UVolume=$lg(RILabTestSetData,48)
    s H24UTimePeriod=$lg(RILabTestSetData,49)
    s BodyTemp=$lg(RILabTestSetData,50)
    s Confidential=$lg(RILabTestSetData,52)
    s ReceiveNotes=$lg(RILabTestSetData,55)
    s ReceiveHospitalCode=$lg(RILabTestSetData,54),ReceiveHospitalDR=""
    s IndexRecHosCode=##Class(LIS.Util.Common).IndexData(ReceiveHospitalCode)
    i $l(ReceiveHospitalCode),$d(^dbo.BTHospitalI("IndexCode",IndexRecHosCode)) d
	.s ReceiveHospitalDR=$o(^dbo.BTHospitalI("IndexCode",IndexRecHosCode,""))
    s AddUserDR=ReceiveUserDR
    s AddType=""
    s AgeDesc=Age_AgeUnitDesc
    //标本表数据插入或更新
    s indexLabNo =##Class(LIS.Util.Common).IndexData(LabNo)
    s VisitNumberDR= $o(^dbo.RPVisitNumberI("IndexVisitNumber",indexLabNo,"")) 
    i $l(VisitNumberDR) d 
    .s objVisitNumber=##class(dbo.RPVisitNumber).%OpenId(VisitNumberDR)
    e  d
    .s objVisitNumber=##class(dbo.RPVisitNumber).%New()
    s objVisitNumber.VisitNumber=LabNo
	s objVisitNumber.RegNo=RegNo
	s objVisitNumber.AdmissionTypeDR=AdmissionTypeDR
	s objVisitNumber.AdmNo=AdmNo
	s objVisitNumber.MedicalRecordNo=MedicalRecordNo
	s objVisitNumber.AdmDate=AdmDate
	s objVisitNumber.AdmTime=AdmTime
	//s objVisitNumber.CertTypeDR=""
	//s objVisitNumber.CertNo=""
	s objVisitNumber.IDNumber=IDNumber
	s objVisitNumber.PaymentTypeDR=""
	s objVisitNumber.SurName=PatName
	s objVisitNumber.GivenName=GivenName
	s objVisitNumber.SpeciesDR=SpeciesDR
	s objVisitNumber.BirthDate=BirthDate
	s objVisitNumber.BirthTime=BirthTime
	s objVisitNumber.Age=Age
	s objVisitNumber.AgeUnitDR=AgeUnitDR
	s objVisitNumber.EthnicityDR=""
	s objVisitNumber.HospitalDR=HospitalDR
	s objVisitNumber.LocationDR=LocationDR
	s objVisitNumber.DoctorDR=DoctorDR
	s objVisitNumber.RequestDate=RequestDate
	s objVisitNumber.RequestTime=RequestTime
	s objVisitNumber.WardDR=WardDR
	s objVisitNumber.BedNo=BedNo
	s objVisitNumber.Symptom=Symptom
	s objVisitNumber.MobileNo=MobileNo
	s objVisitNumber.PhoneNo=PhoneNo
	s objVisitNumber.EMail=EMail
	s objVisitNumber.Height=Height
	s objVisitNumber.Weight=Weight
	s objVisitNumber.BloodPressure=BloodPressure
	s objVisitNumber.Pregnant=Pregnant
	s objVisitNumber.PregnantWeeks=PregnantWeeks
	s objVisitNumber.Address=Address
	s objVisitNumber.PostCode=PostCode
	s objVisitNumber.InfectFlag=InfectFlag
	s objVisitNumber.InfectAlert=InfectAlert
	s objVisitNumber.PregnantNum=PregnantNum
	s objVisitNumber.ChildbirthNum=ChildbirthNum
	s objVisitNumber.ReqNotes=ReqNotes
	s objVisitNumber.Urgent=Urgent
	s objVisitNumber.CollectDate=ColDate
	s objVisitNumber.CollectTime=ColTime
	s objVisitNumber.CollectUserDR=CollectUserDR
	s objVisitNumber.SpecimenDR=SpecimenDR
	s objVisitNumber.ContainerDR=ContainerDR
	s objVisitNumber.CollectNotes=CollectNotes
	s objVisitNumber.H24UVolume=H24UVolume
	s objVisitNumber.H24UTimePeriod=H24UTimePeriod
	s objVisitNumber.BodyTemp=BodyTemp
	s objVisitNumber.Confidential=Confidential
	s objVisitNumber.CarryDate=CarryDate
	s objVisitNumber.CarryTime=CarryTime
	s objVisitNumber.CarryUserDR=CarryUserDR
	s objVisitNumber.ReceiveDate=ReceiveDate
	s objVisitNumber.ReceiveTime=ReceiveTime
	s objVisitNumber.ReceiveUserDR=ReceiveUserDR
	s objVisitNumber.ReceiveNotes=ReceiveNotes
	s objVisitNumber.ReceiveHospitalDR=ReceiveHospitalDR
	s objVisitNumber.AddUserDR=AddUserDR
	s objVisitNumber.AddType=AddType
	s objVisitNumber.AgeDesc=AgeDesc
	s sc=objVisitNumber.%Save()
	i '($SYSTEM.Status.IsOK(sc)) throw ##class(%Exception.SystemException).%New("事务委托","D",,"标本保存失败:"_$SYSTEM.Status.GetErrorText(sc))
	s VisitNumberDR=objVisitNumber.RowID
	//获取报告表待插入值
	s WorkGroupMachineDR=$lg(RILabTestSetData,62) 
	s TransmitDate=$lg(RILabTestSetData,63)  
	s AssayNo=$lg(RILabTestSetData,64)  
	s AcceptDate=$lg(RILabTestSetData,65)  
	s AcceptDate= $tr(AcceptDate,"-")
	s AcceptTime=$lg(RILabTestSetData,66)  
	i AcceptTime[":" s AcceptTime=$zth(AcceptTime,1)	
	s AcceptUserDR=$lg(RILabTestSetData,67) 
	s EpisodeNo=$lg(RILabTestSetData,74) 
	//i $d(^dbo.RPVisitNumberReportI("IndexReportID",VisitNumberDR,WorkGroupMachineDR)),(i=1) throw ##class(%Exception.SystemException).%New("事务委托","D",,"-1^该标本已经产生对应报告,无法再次同步！")	
	s ExistReportID=$g(RepeatReportList("RepeatReport",RITestSetReportID))
    //报告表数据更新---根据中间表中的报告id不同来生成指定个数的报告
    s OrderNo=$o(^dbo.RPVisitNumberReportI("IndexReportID",VisitNumberDR,WorkGroupMachineDR,""),-1)+1
	i $l(ExistReportID) d 
    .s objReport=##class(dbo.RPVisitNumberReport).%OpenId(ExistReportID)
    e  d
    .s objReport=##class(dbo.RPVisitNumberReport).%New()
	s objReport.VisitNumberDR=VisitNumberDR
	s objReport.TransmitDate=TransmitDate
	s objReport.WorkGroupMachineDR=WorkGroupMachineDR
	i '$l(objReport.OrderNo) s objReport.OrderNo=OrderNo
	s objReport.AssayNo=AssayNo
	s objReport.AccessionNo=""
	s objReport.EpisodeNo=EpisodeNo //流水号数据同步在计划任务同步中间表的时候已完成
	s objReport.AcceptDate=AcceptDate
	s objReport.AcceptTime=AcceptTime
	s objReport.AcceptUserDR=AcceptUserDR
	s objReport.Status=1
	s sc=objReport.%Save()
	i '($SYSTEM.Status.IsOK(sc)) throw ##class(%Exception.SystemException).%New("事务委托","D",,"标本信息保存失败:"_$SYSTEM.Status.GetErrorText(sc))
	s RepeatReportList("RepeatReport",RITestSetReportID)=objReport.RowID
	s VisitNumberReportDR=objReport.RowID
    //获取标本医嘱表待插入值
    s HISOrderID=$lg(RILabTestSetData,4)
    s TestSetFee=$lg(RILabTestSetData,43)  
	s WorkGroupMachineDR=$lg(RILabTestSetData,62)  
	s TransmitDate=$lg(RILabTestSetData,63)  
    //标本医嘱表数据插入
	s RPVNTestSetDR=$o(^dbo.RPVisitNumberTestSetI("IndexMaster",VisitNumberDR,TestSetDR,""))
	i $l(RPVNTestSetDR) d 
    .s objTestSets=##class(dbo.RPVisitNumberTestSet).%OpenId(RPVNTestSetDR)
    e  d
    .s objTestSets=##class(dbo.RPVisitNumberTestSet).%New()
	s objTestSets.VisitNumberDR=VisitNumberDR
	s objTestSets.TestSetDR=TestSetDR
	s objTestSets.Recieved="1"
	s objTestSets.WorkGroupMachineDR=WorkGroupMachineDR
	s objTestSets.TransmitDate=TransmitDate
	s objTestSets.AssayNo=AssayNo
	s objTestSets.TestSetFee=TestSetFee 
	s objTestSets.HISOrderID=HISOrderID
	s objTestSets.VisitNumberReportDR=VisitNumberReportDR
	s objTestSets.ReceivableFee=""
	s sc=objTestSets.%Save()
    i '($SYSTEM.Status.IsOK(sc)) throw ##class(%Exception.SystemException).%New("事务委托","D",,"标本医嘱保存失败:"_$SYSTEM.Status.GetErrorText(sc))
	//报告结果表数据更新
	s retVal=##Class(LISSP.DHCRPVisitNumberReport).SaveReportTestCode(VisitNumberReportDR,TestSetDR)
	i retVal'="1" throw ##class(%Exception.SystemException).%New("事务委托","D",,"报告结果保存失败:"_retVal)
	q
}

}
