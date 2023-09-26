Class ES.LIS.DHCTransferEmergentData Extends %RegisteredObject
{

///  查询中间表中对应的医嘱
/// d ##Class(%ResultSet).RunQuery("ES.LIS.DHCTransferEmergentData","QryLabInfo","3","","2022-07-14","","","","","","","","","","","","8280^3^0^2^1")
Query QryLabInfo(WorkGroupDR, LabNo, TransmitDate, P3, P4, P5, P6, P7, P8, P9, P10, P11, P12, P13, Sessions, Output RowCount As %String) As %Query(ROWSPEC = "RITestSetDR,TestSetCode,TestSetDesc,TestSetFee,Status,StatusDesc,ReceiveDate,ReceiveTime,ReceiveUser,WGMachineDesc,AssayNo,AuthDate,AuthTime,AuthUser,Labno,PatName,RegNo,SpeciesName,AgeDesc,SpecimenDesc,LocationDesc,DoctorName,RequestDate,RequestTime,CollectUser,CollectDate,CollectTime,WardDesc,BedNo,EpisodeNo")
{
}

ClassMethod QryLabInfoExecute(ByRef qHandle As %Binary, WorkGroupDR, LabNo, TransmitDate, P3, P4, P5, P6, P7, P8, P9, P10, P11, P12, P13, Sessions, Output RowCount As %String) As %Status
{
	s ^MTMPLIS("QryLabInfoExecute")=$lb(WorkGroupDR, LabNo, TransmitDate, P3, P4, P5, P6, P7, P8, P9, P10, P11, P12, P13, Sessions)
	s WorkGroupDR=$g(WorkGroupDR),LabNo=$g(LabNo),TransmitDate=$g(TransmitDate),Sessions=$g(Sessions)
	s UserID=$p(Sessions,"^",1),HospitalDR=$p(Sessions,"^",5),LocationDR=$p(Sessions,"^",3)
    s TransmitDate=$tr(TransmitDate,"-")
    
	Set repid=$i(^CacheTemp)
 	Set ind=1
	s RowCount=0
	k ^TMPLIS($zn,repid,$j)
    
    i $l(LabNo) d
    .s indexLabNo = LabNo
    .s fRITestSetDR="" f  s fRITestSetDR=$o(^dbo.RILabTestSetI("BarCode",indexLabNo,fRITestSetDR)) q:fRITestSetDR=""  d
    ..d GetInfo
    e  i $l(WorkGroupDR) d
    .//查询已核收后的标本
    .s fCode="" f  s fCode=$o(^dbo.BTWorkGroupMachineI("IndexCode",WorkGroupDR,fCode)) q:fCode=""  d
    ..s fWorkGroupMachineDR=$o(^dbo.BTWorkGroupMachineI("IndexCode",WorkGroupDR,fCode,"")) 
    ..i $l(fWorkGroupMachineDR) d
    ...s fAssayNo=""  f  s fAssayNo=$o(^dbo.RILabTestSetI("IndexTransmitDate",fWorkGroupMachineDR,TransmitDate,fAssayNo)) q:fAssayNo=""  d
    ....s fRITestSetDR=""  f  s fRITestSetDR=$o(^dbo.RILabTestSetI("IndexTransmitDate",fWorkGroupMachineDR,TransmitDate,fAssayNo,fRITestSetDR)) q:fRITestSetDR=""  d
    .....d GetInfo
    .//查询接收状态的标本  //Index ReceiveDate On (ReceiveDate, HospitalCode)
    .s fHospitalCode="" f  s fHospitalCode=$o(^dbo.RILabTestSetI("ReceiveDate",TransmitDate,fHospitalCode)) q:fHospitalCode=""  d 
    ..s fRITestSetDR="" f  s fRITestSetDR=$o(^dbo.RILabTestSetI("ReceiveDate",TransmitDate,fHospitalCode,fRITestSetDR)) q:fRITestSetDR=""  d 
    ...d GetInfo
    
    //结果输出
    ;s ^TMPLIS($zn,repid,$j,"RITestSet",Labno,ReportID,RITestSetDR)=Data
    s fLabno="" f  s fLabno=$o(^TMPLIS($zn,repid,$j,"RITestSet",fLabno)) q:fLabno=""  d
    .s fReportID="" f  s fReportID=$o(^TMPLIS($zn,repid,$j,"RITestSet",fLabno,fReportID)) q:fReportID=""  d
    ..s comRITestSetDR="",comTestSetDesc="",comTestSetCode="",comTestSetFee=""
    ..s fRITestSetDR="" f  s fRITestSetDR=$o(^TMPLIS($zn,repid,$j,"RITestSet",fLabno,fReportID,fRITestSetDR)) q:fRITestSetDR=""  d
    ...i $l(comRITestSetDR) s comRITestSetDR=comRITestSetDR_"^"_fRITestSetDR
    ...e  s comRITestSetDR=fRITestSetDR
    ...s tmpData=$g(^TMPLIS($zn,repid,$j,"RITestSet",fLabno,fReportID,fRITestSetDR))
    ...s TestSetCode=$lg(tmpData,2)
    ...s TestSetDesc=$lg(tmpData,3)
    ...s TestSetFee=$lg(tmpData,4)
    ...i $l(comTestSetCode) s comTestSetCode=comTestSetCode_"+"_TestSetCode,comTestSetDesc=comTestSetDesc_"+"_TestSetDesc,comTestSetFee=comTestSetFee_"@I@"_TestSetFee
    ...e  s comTestSetCode=TestSetCode,comTestSetDesc=TestSetDesc,comTestSetFee=TestSetFee
    ..s $li(tmpData,1)=comRITestSetDR
    ..s $li(tmpData,2)=comTestSetCode
    ..s $li(tmpData,3)=comTestSetDesc
    ..s $li(tmpData,4)=comTestSetFee
    ..s Data=tmpData
    ..d OutPut
    
	k ^TMPLIS($zn,repid,$j)
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
GetInfo
    b //医嘱信息
    s RITestSetDR =fRITestSetDR
	s RITestSetData=$g(^dbo.RILabTestSetD(RITestSetDR))
	s IsChanged=$lg(RITestSetData,69)
	i IsChanged'=1 q //过滤不需要同步的
    s BarCode=$lg(RITestSetData,6)	
	s indexBarCode=##Class(LIS.Util.Common).IndexData(BarCode)
	s RPVisitNumberDR=$o(^dbo.RPVisitNumberI("IndexVisitNumber",indexBarCode,""))
	i '$l(RPVisitNumberDR) q  //找到对应标本(应急中间表还未同步应急业务表)	
	s TestSetRowID=$lg(RITestSetData,4)
	s indexTestSetRowID=##Class(LIS.Util.Common).IndexData(TestSetRowID)
	s VisitNumberReportDR=$o(^dbo.RPVisitNumberTestSetI("IndexHISOrderID",indexTestSetRowID,""))
	//i VisitNumberReportDR<0 q //没有核收的直接退出（应急库上没有核收的，正式库肯定也是接收状态，没有必要同步）
	s TestSetCode=$lg(RITestSetData,2)
	s TestSetDesc=$lg(RITestSetData,3)

	b //输出报告信息
    //Status,ReceiveDT,ReceiveName,WGMachineDesc,AssayNo,AuthDT,AuthName,Labno,PatName,RegNo,SpeciesName,Age,SpecimenDesc,TestSetDesc,LocationDesc,DoctorName,RequestDT,CollectName,CollectDT,WardDesc,BedNo
 	s RPVisitNumberReportData="",fWorkGroupDR=""
 	i VisitNumberReportDR>0 d
 	.s RPVisitNumberReportData =$g(^dbo.RPVisitNumberReportD(VisitNumberReportDR))
 	.s WGMachineDR=$lg(RPVisitNumberReportData,4)
 	.i $l(WGMachineDR) s fWorkGroupDR=$lg($g(^dbo.BTWorkGroupMachineD(WGMachineDR)),4)
 	i $l(WorkGroupDR),$l(fWorkGroupDR),(fWorkGroupDR'=WorkGroupDR) q //非本工作组的不同步
 	s RPVisitNumberData=$g(^dbo.RPVisitNumberD(RPVisitNumberDR))
 	s Labno=$lg(RPVisitNumberData,2)
 	s RegNo=$lg(RPVisitNumberData,3)
 	s SurName=$lg(RPVisitNumberData,13)
 	s GivenName=$lg(RPVisitNumberData,14)
	i SurName=GivenName s PatName=SurName
	e  s PatName=SurName_GivenName
 	s SpeciesDR=$lg(RPVisitNumberData,15),SpeciesName=""
 	i $l(SpeciesDR) s SpeciesName=$lg($g(^dbo.BTSpeciesD(SpeciesDR)),3)
 	s Age=$lg(RPVisitNumberData,18)
 	s AgeUnitDR=$lg(RPVisitNumberData,19),AgeUnit=""
	i $l(AgeUnitDR) s AgeUnit=$lg($g(^dbo.BTAgeUnitD(AgeUnitDR)),3)
 	s AgeDesc=$lg(RPVisitNumberData,84)
    i '$l(AgeDesc) s AgeDesc=Age_AgeUnit
 	s LocationDR=$lg(RPVisitNumberData,22),LocationDesc=""
 	i $l(LocationDR) s LocationDesc=$lg($g(^dbo.BTLocationD(LocationDR)),3)
 	s DoctorDR=$lg(RPVisitNumberData,23),DoctorName=""
 	i $l(DoctorDR) s DoctorName=$lg($g(^dbo.BTDoctorD(DoctorDR)),3)
 	s RequestDate=$lg(RPVisitNumberData,24)
 	s RequestTime=$lg(RPVisitNumberData,25)
 	s WardDR=$lg(RPVisitNumberData,26),WardDesc=""
 	i $l(WardDR) s WardDesc=$lg($g(^dbo.BTWardD(WardDR)),3)
 	s BedNo=$lg(RPVisitNumberData,27)
    s CollectDate=$lg(RPVisitNumberData,51)
 	s CollectTime=$lg(RPVisitNumberData,52)
 	s CollectUserDR=$lg(RPVisitNumberData,53),CollectUser=""
 	i $l(CollectUserDR) s CollectUser=$lg($g(^dbo.SYSUserD(CollectUserDR)),3)
 	s SpecimenDR=$lg(RPVisitNumberData,56),SpecimenDesc=""
 	i $l(SpecimenDR) s SpecimenDesc=$lg($g(^dbo.BTSpecimenD(SpecimenDR)),3)
 	s ReceiveDate=$lg(RPVisitNumberData,66)
 	s ReceiveTime=$lg(RPVisitNumberData,67) 
 	s ReceiveUserDR=$lg(RPVisitNumberData,68) 
 	i $l(ReceiveUserDR) s ReceiveUser=$lg($g(^dbo.SYSUserD(ReceiveUserDR)),3)
 	//s RPVisitNumberReportData
 	s Status="",StatusDesc="",WGMachineDR="",WGMachineDesc="",AssayNo="",AuthDate="",AuthTime="",AuthUserDR="",AuthUser="",EpisodeNo=""
 	i $l(RPVisitNumberReportData) d
 	.s Status=$lg(RPVisitNumberReportData,22)
 	.s StatusDesc=$s(Status="1":"登记",Status="2":"初审",Status="3":"审核",Status="4":"复查",Status="5":"取消",Status="6":"作废",Status="O":"其他",Status="10":"培养中",Status="11":"鉴定中",Status="12":"药敏中")
 	.s WGMachineDR=$lg(RPVisitNumberReportData,4),WGMachineDesc=""
 	.s WGMachineDesc=$lg($g(^dbo.BTWorkGroupMachineD(WGMachineDR)),3)
 	.s AssayNo =$lg(RPVisitNumberReportData,6)
 	.b //1.0
 	.s EpisodeNo =$lg(RPVisitNumberReportData,8)
 	.s AuthDate=$lg(RPVisitNumberReportData,19)
 	.s AuthTime=$lg(RPVisitNumberReportData,20)
 	.s AuthUserDR=$lg(RPVisitNumberReportData,21),AuthUser=""
 	.i $l(AuthUserDR) s AuthUser=$lg($g(^dbo.SYSUserD(AuthUserDR)),3)
 	s Data=$lb(RITestSetDR,TestSetCode,TestSetDesc,TestSetFee,Status,StatusDesc,ReceiveDate,ReceiveTime,ReceiveUser,WGMachineDesc,AssayNo,AuthDate,AuthTime,AuthUser,Labno,PatName,RegNo,SpeciesName,AgeDesc,SpecimenDesc,LocationDesc,DoctorName,RequestDate,RequestTime,CollectUser,CollectDate,CollectTime,WardDesc,BedNo,EpisodeNo)
 	i '$l(VisitNumberReportDR) s VisitNumberReportDR="0"
 	i '$d(^TMPLIS($zn,repid,$j,"RITestSet",Labno,VisitNumberReportDR)) s RowCount=RowCount+1
 	s ^TMPLIS($zn,repid,$j,"RITestSet",Labno,VisitNumberReportDR,RITestSetDR)=Data
 	q
 	
OutPut	
 	Set ColFields="RITestSetDR,TestSetCodes,TestSetDescs,TestSetFee,Status,StatusDesc,ReceiveDate,ReceiveTime,ReceiveUser,WGMachineDesc,AssayNo,AuthDate,AuthTime,AuthUser,Labno,PatName,RegNo,SpeciesName,AgeDesc,SpecimenDesc,LocationDesc,DoctorName,RequestDate,RequestTime,CollectUser,CollectDate,CollectTime,WardDesc,BedNo,EpisodeNo"
 	Set ^CacheTemp(repid,ind)=##Class(LIS.Util.Common).TransListNull(Data,ColFields)
 	Set ind=ind+1
	Quit
}

ClassMethod QryLabInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryWorkListExecute ]
{
	Set repid=$li(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryLabInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryWorkListExecute ]
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

/// zhangli 20210801
/// 同步应急库报告信息到正式库
/// w ##class(ES.LIS.DHCTransferEmergentData).TransferEmergentDataMTHD("3","","2022-07-18","","","","","","","","","","","","8280^3^0^2^1")
ClassMethod TransferEmergentDataMTHD(WorkGroupDR, LabNo, TransmitDate, P3, P4, P5, P6, P7, P8, P9, P10, P11, P12, P13, Sessions, Output RowCount As %String) As %String
{
	s WorkGroupDR=$g(WorkGroupDR),LabNo=$g(LabNo),TransmitDate=$g(TransmitDate),Sessions=$g(Sessions)
	q ##Class(LIS.WS.DHCLISServiceBase).DeclarativeTrans("ES.LIS.DHCTransferEmergentData","TransferEmergentDataDo",WorkGroupDR, LabNo, TransmitDate, "", "", "", "", "", "", "", "", "", "", "", Sessions,.RowCount)
}

/// zhangli 20210801
/// 同步应急库报告信息到正式库
/// w ##class(ES.LIS.DHCTransferEmergentData).TransferEmergentDataMTHD("3","","2022-06-20","","","","","","","","","","","","8280^3^0^2^1")
ClassMethod TransferEmergentDataDo(WorkGroupDR, LabNo, TransmitDate, P3, P4, P5, P6, P7, P8, P9, P10, P11, P12, P13, Sessions, Output RowCount As %String) As %String
{
	s ^MTMPLIS("TransferEmergentDataDo")=$lb(WorkGroupDR, LabNo, TransmitDate, P3, P4, P5, P6, P7, P8, P9, P10, P11, P12, P13, Sessions)
	s WorkGroupDR=$g(WorkGroupDR),LabNo=$g(LabNo),TransmitDate=$g(TransmitDate),Sessions=$g(Sessions)
	s UserID=$p(Sessions,"^",1),WorkGroupDR=$p(Sessions,"^",2),HospitalDR=$p(Sessions,"^",5)
	s TransmitDate=$tr(TransmitDate,"-")
	s HospitalCode=""
	
	s RetValue=1
    Set repid=$i(^CacheTemp)
 	Set ind=1
	s RowCount=0
	k ^TMPLIS($zn,repid,$j)
	 
	s Address=""
    s paramDR = $o(^dbo.SYSParameterI("IndexCode"," PROSYNCADDRESS", " SYS"," DHCC",""))
	i $l(paramDR) s Address = $lg(^dbo.SYSParameterD(paramDR),6)
    i '$l(Address)  throw ##class(%Exception.SystemException).%New("事务委托","D",,"系统参数表未维护待同步库的WebService地址")
    //s Address="http://114.251.235.30:57772/imedicallis/csp/LIS.WS.DHCLISService.cls?wsdl=1&amp;CacheUserName=_system&amp;CachePassword=SYS"
	 
    i $l(LabNo) d
    .s indexLabNo = LabNo
    .s fRITestSetDR="" f  s fRITestSetDR=$o(^dbo.RILabTestSetI("BarCode",indexLabNo,fRITestSetDR)) q:fRITestSetDR=""  d
    ..d GetInfo
    e  i $l(WorkGroupDR) d
    .//同步已核收后的标本
    .s fCode="" f  s fCode=$o(^dbo.BTWorkGroupMachineI("IndexCode",WorkGroupDR,fCode)) q:fCode=""  d
    ..s fWorkGroupMachineDR=$o(^dbo.BTWorkGroupMachineI("IndexCode",WorkGroupDR,fCode,"")) 
    ..i $l(fWorkGroupMachineDR) d
    ...s fAssayNo=""  f  s fAssayNo=$o(^dbo.RILabTestSetI("IndexTransmitDate",fWorkGroupMachineDR,TransmitDate,fAssayNo)) q:fAssayNo=""  d
    ....s fRITestSetDR=""  f  s fRITestSetDR=$o(^dbo.RILabTestSetI("IndexTransmitDate",fWorkGroupMachineDR,TransmitDate,fAssayNo,fRITestSetDR)) q:fRITestSetDR=""  d
    .....d GetInfo
    .//同步接收状态的标本  //Index ReceiveDate On (ReceiveDate, HospitalCode)
    .s fHospitalCode="" f  s fHospitalCode=$o(^dbo.RILabTestSetI("ReceiveDate",TransmitDate,fHospitalCode)) q:fHospitalCode=""  d 
    ..s fRITestSetDR="" f  s fRITestSetDR=$o(^dbo.RILabTestSetI("ReceiveDate",TransmitDate,fHospitalCode,fRITestSetDR)) q:fRITestSetDR=""  d 
    ...d GetInfo
    
    b //按报告或标本逐个同步
    s fLabno="" f  s fLabno=$o(^TMPLIS($zn,repid,$j,"RITestSet",fLabno)) q:fLabno=""  d
    .s fReportID="" f  s fReportID=$o(^TMPLIS($zn,repid,$j,"RITestSet",fLabno,fReportID)) q:fReportID=""  d
    ..d TransferEme
    
    //同步应急流水号到正式库
    s WorkGroupCode=$lg($g(^dbo.BTWorkGroupD(WorkGroupDR)),2)
	d ##class(ES.LIS.DHCTransferEmergentData).EpisNoSyncTaskMTHD("1",WorkGroupCode,"","","","","","","","","","","","","")
    
    k ^TMPLIS($zn,repid,$j)
    q RetValue


GetInfo
    //医嘱信息
    s RITestSetDR =fRITestSetDR
	s RITestSetData=$g(^dbo.RILabTestSetD(RITestSetDR))
	s IsChanged=$lg(RITestSetData,69)
	i IsChanged'=1 q //过滤不需要同步的
    //找到对应的报告
    s BarCode=$lg(RITestSetData,6)	
	s indexBarCode=##Class(LIS.Util.Common).IndexData(BarCode)
	s RPVisitNumberDR=$o(^dbo.RPVisitNumberI("IndexVisitNumber",indexBarCode,""))	
	i '$l(RPVisitNumberDR) q
	
	s VisitNumberReportDR="",RPVNTestSetDR=""	
	s TestSetRowID=$lg(RITestSetData,4)
	s fTestSetDR="" f  s fTestSetDR=$o(^dbo.RPVisitNumberTestSetI("IndexMaster",RPVisitNumberDR,fTestSetDR)) q:fTestSetDR=""  d    //Index IndexMaster On (VisitNumberDR, TestSetDR) 
	.s fVNTestSetDR=$o(^dbo.RPVisitNumberTestSetI("IndexMaster",RPVisitNumberDR,fTestSetDR,""))
	.s VNTestSetData=$g(^dbo.RPVisitNumberTestSetD(fVNTestSetDR))
	.s VNHISOrderID=$lg(VNTestSetData,10)
	.s Received=$lg(VNTestSetData,4)
	.i Received'=1 q  //未接收退出
	.i VNHISOrderID=TestSetRowID d
	..s VisitNumberReportDR=$lg(VNTestSetData,11)
	..s RPVNTestSetDR=fVNTestSetDR		
	//没有找到对应记录的直接退出
	i '$l(RPVNTestSetDR) q
    s TestSetDR=$lg($g(^dbo.RPVisitNumberTestSetD(RPVNTestSetDR)),3)
    s TestSetData=$g(^dbo.BTTestSetD(TestSetDR))
    s TestSetCode=$lg(TestSetData,2)
    s TestSetDesc=$lg(TestSetData,3)
    s TestSetFee=""

	//输出报告信息
    //Status,ReceiveDT,ReceiveName,WGMachineDesc,AssayNo,AuthDT,AuthName,Labno,PatName,RegNo,SpeciesName,Age,SpecimenDesc,TestSetDesc,LocationDesc,DoctorName,RequestDT,CollectName,CollectDT,WardDesc,BedNo
 	
 	s quiltflag=0,RPVisitNumberReportData=""
 	i $l(VisitNumberReportDR) d
 	.s RPVisitNumberReportData =$g(^dbo.RPVisitNumberReportD(VisitNumberReportDR))
 	i $l(RPVisitNumberReportData) d
 	.//已核收
 	.s RPVisitNumberDR=$lg(RPVisitNumberReportData,2)
 	.s WGMachineDR=$lg(RPVisitNumberReportData,4)
 	.s fWorkGroupDR=$lg($g(^dbo.BTWorkGroupMachineD(WGMachineDR)),4)
 	.i $l(WorkGroupDR),(fWorkGroupDR'=WorkGroupDR) s quiltflag=1
 	e  d
 	.//接收的
 	.s canRecWG = ##Class(HIS.DHCReceiveCommon).CheckRecWG(TestSetDR,WorkGroupDR)
 	.i canRecWG'=1 s quiltflag=1
 	i quiltflag=1 q
 	
 	s RPVisitNumberData=$g(^dbo.RPVisitNumberD(RPVisitNumberDR))
 	s Labno=$lg(RPVisitNumberData,2)
 	i '$l(VisitNumberReportDR) s VisitNumberReportDR="NoReport"
 	s ^TMPLIS($zn,repid,$j,"RITestSet",Labno,VisitNumberReportDR,RITestSetDR)=TestSetDR
 	q  
    
TransferEme
 	//1.0接收状态的同步应急库中间表数据到正式库中间表
 	i fReportID="NoReport"  d
 	.s fRITestSetDR="" f  s fRITestSetDR=$o(^TMPLIS($zn,repid,$j,"RITestSet",fLabno,fReportID,fRITestSetDR)) q:fRITestSetDR=""  d
    ..d InsertOneTS
    ;i (fLabno'="E123456789195"),(fReportID="NoReport") q
    
    //2.0同步应急库业务表数据到正式库
    i fReportID="NoReport"  d
    .s indexFLabno=##Class(LIS.Util.Common).IndexData(fLabno)
	.s RPVisitNumberDR=$o(^dbo.RPVisitNumberI("IndexVisitNumber",indexFLabno,""))  
	.s objOldVisitNumber=##class(dbo.RPVisitNumber).%OpenId(RPVisitNumberDR)
    e  d
    .s RPVisitNumberReportData =$g(^dbo.RPVisitNumberReportD(fReportID))
    .s Status=$lg(RPVisitNumberReportData,22)
    .s RPVisitNumberDR=$lg(RPVisitNumberReportData,2)
    .s objOldVisitNumber=##class(dbo.RPVisitNumber).%OpenId(RPVisitNumberDR)
    .s objOldReport=##class(dbo.RPVisitNumberReport).%OpenId(fReportID)
    
    s RetXML=##class(LIS.Util.COM.XML).New("Request")
    s objVisitNumber=##class(LIS.Util.COM.XML).New("ReportMsg")
    //组织标本信息
    s objVisitNumber.AboDR="" //objOldVisitNumber.AboDR
	s objVisitNumber.AddDate=objOldVisitNumber.AddDate
	s objVisitNumber.Address=objOldVisitNumber.Address
	s objVisitNumber.AddTime=objOldVisitNumber.AddTime
	s objVisitNumber.AddType=objOldVisitNumber.AddType
	//s objVisitNumber.AddUserDR=objOldVisitNumber.AddUserDR
	s AddUserCode=""
	i $l(objOldVisitNumber.AddUserDR) d
	.s UserData=$g(^dbo.SYSUserD(objOldVisitNumber.AddUserDR))
	.s AddUserCode=$lg(UserData,2)
	s objVisitNumber.AddUserCode=AddUserCode
	s objVisitNumber.AdmDate=objOldVisitNumber.AdmDate
	//s objVisitNumber.AdmissionTypeDR=objOldVisitNumber.AdmissionTypeDR
	s AdmissionTypeCode=""
	i $l(objOldVisitNumber.AdmissionTypeDR) d
	.s AdmissionTypeData=$g(^dbo.BTAdmissionTypeD(objOldVisitNumber.AdmissionTypeDR))
	.s AdmissionTypeCode=$lg(AdmissionTypeData,2)
	s objVisitNumber.AdmissionTypeCode=AdmissionTypeCode
	s objVisitNumber.AdmNo=objOldVisitNumber.AdmNo
	s objVisitNumber.AdmTime=objOldVisitNumber.AdmTime
	s objVisitNumber.Age=objOldVisitNumber.Age
	s objVisitNumber.AgeDesc=objOldVisitNumber.AgeDesc
	//s objVisitNumber.AgeUnitDR=objOldVisitNumber.AgeUnitDR
	s AgeUnitCode=""
	i $l(objOldVisitNumber.AgeUnitDR) d
	.s AgeUnitData=$g(^dbo.BTAgeUnitD(objOldVisitNumber.AgeUnitDR))
	.s AgeUnitCode=$lg(AgeUnitData,2)
	s objVisitNumber.AgeUnitCode=AgeUnitCode
	s objVisitNumber.AnatomicalSiteDR="" //objOldVisitNumber.AnatomicalSiteDR
	s objVisitNumber.ArriveDate=objOldVisitNumber.ArriveDate
	s objVisitNumber.ArriveTime=objOldVisitNumber.ArriveTime
	//s objVisitNumber.ArriveUserDR=objOldVisitNumber.ArriveUserDR
	s ArriveUserCode=""
	i $l(objOldVisitNumber.ArriveUserDR) d
	.s ArriveUserData=$g(^dbo.SYSUserD(objOldVisitNumber.ArriveUserDR))
	.s ArriveUserCode=$lg(ArriveUserData,2)
	s objVisitNumber.ArriveUserCode=ArriveUserCode
	s objVisitNumber.ArriveWorkGroupDR="" //objOldVisitNumber.ArriveWorkGroupDR
	s objVisitNumber.BedNo=objOldVisitNumber.BedNo
	s objVisitNumber.BirthDate=objOldVisitNumber.BirthDate
	s objVisitNumber.BirthTime=objOldVisitNumber.BirthTime
	s objVisitNumber.BloodPressure=objOldVisitNumber.BloodPressure
	s objVisitNumber.BodyTemp=objOldVisitNumber.BodyTemp
	s objVisitNumber.CarryDate=objOldVisitNumber.CarryDate
	s objVisitNumber.CarryTime=objOldVisitNumber.CarryTime
	//s objVisitNumber.CarryUserDR=objOldVisitNumber.CarryUserDR
	s CarryUserCode=""
	i $l(objOldVisitNumber.CarryUserDR) d
	.s CarryUserData=$g(^dbo.SYSUserD(objOldVisitNumber.CarryUserDR))
	.s CarryUserCode=$lg(CarryUserData,2)
	s objVisitNumber.CarryUserCode=CarryUserCode
	s objVisitNumber.CertNo=objOldVisitNumber.CertNo
	//s objVisitNumber.CertTypeDR=objOldVisitNumber.CertTypeDR
	s CertTypeCode=""
	i $l(objOldVisitNumber.CertTypeDR) d
	.s CertTypeData=$g(^dbo.BTCertTypeD(objOldVisitNumber.CertTypeDR))
	.s CertTypeCode=$lg(CertTypeData,2)
	s objVisitNumber.CertTypeCode=CertTypeCode
	s objVisitNumber.ChildbirthNum=objOldVisitNumber.ChildbirthNum
	//s objVisitNumber.ClinicalConditionsDR=objOldVisitNumber.ClinicalConditionsDR
	s ClinicalConditionsCode=""
	i $l(objOldVisitNumber.ClinicalConditionsDR) d
	.s ClinicalConditionsData=$g(^dbo.BTClinicalConditionsD(objOldVisitNumber.ClinicalConditionsDR))
	.s ClinicalConditionsCode=$lg(ClinicalConditionsData,2)
	s objVisitNumber.ClinicalConditionsCode=ClinicalConditionsCode
	s objVisitNumber.CollectDate=objOldVisitNumber.CollectDate
	s objVisitNumber.CollectNotes=objOldVisitNumber.CollectNotes
	s objVisitNumber.CollectPositon=objOldVisitNumber.CollectPositon
	s objVisitNumber.CollectTime=objOldVisitNumber.CollectTime
	//s objVisitNumber.CollectUserDR=objOldVisitNumber.CollectUserDR
	s CollectUserCode=""
	i $l(objOldVisitNumber.CollectUserDR) d
	.s CollectUserData=$g(^dbo.SYSUserD(objOldVisitNumber.CollectUserDR))
	.s CollectUserCode=$lg(CollectUserData,2)
	s objVisitNumber.CollectUserCode=CollectUserCode
	s objVisitNumber.Confidential=objOldVisitNumber.Confidential
	s objVisitNumber.ConcessionFlag=objOldVisitNumber.ConcessionFlag
	//s objVisitNumber.ContainerDR=objOldVisitNumber.ContainerDR
	s ContainerCode=""
	i $l(objOldVisitNumber.ContainerDR) d
	.s ContainerData=$g(^dbo.BTContainerD(objOldVisitNumber.ContainerDR))
	.s ContainerCode=$lg(ContainerData,2)
	s objVisitNumber.ContainerCode=ContainerCode
	//s objVisitNumber.CountryDR=objOldVisitNumber.CountryDR
	s CountryCode=""
	i $l(objOldVisitNumber.CountryDR) d
	.s CountryData=$g(^dbo.BTCountryD(objOldVisitNumber.CountryDR))
	.s CountryCode=$lg(CountryData,2)
	s objVisitNumber.CountryCode=CountryCode
	//s objVisitNumber.DoctorDR=objOldVisitNumber.DoctorDR   
	s DoctorCode=""
	i $l(objOldVisitNumber.DoctorDR) d
	.s DoctorData=$g(^dbo.BTDoctorD(objOldVisitNumber.DoctorDR))
	.s DoctorCode=$lg(DoctorData,2)
	s objVisitNumber.DoctorCode=DoctorCode
	s objVisitNumber.EMail=objOldVisitNumber.EMail
	s objVisitNumber.ExtLabNo=objOldVisitNumber.ExtLabNo
	s objVisitNumber.EthnicityDR="" //objOldVisitNumber.EthnicityDR
	s objVisitNumber.FeeSum=objOldVisitNumber.FeeSum
	s objVisitNumber.GivenName=objOldVisitNumber.GivenName
	s objVisitNumber.H24UTimePeriod=objOldVisitNumber.H24UTimePeriod
	s objVisitNumber.H24UVolume=objOldVisitNumber.H24UVolume
	s objVisitNumber.Height=objOldVisitNumber.Height
	//s objVisitNumber.HospitalDR=objOldVisitNumber.HospitalDR
	s HospitalCode=""
	i $l(objOldVisitNumber.HospitalDR) d
	.s HospitalData=$g(^dbo.BTHospitalD(objOldVisitNumber.HospitalDR))
	.s HospitalCode=$lg(HospitalData,2)
	s objVisitNumber.HospitalCode=HospitalCode
	s objVisitNumber.ICDs=objOldVisitNumber.ICDs
	s objVisitNumber.IDNumber=objOldVisitNumber.IDNumber
	s objVisitNumber.InfectAlert=objOldVisitNumber.InfectAlert
	s objVisitNumber.InfectFlag=objOldVisitNumber.InfectFlag
	s objVisitNumber.InStorageDate=objOldVisitNumber.InStorageDate
	s objVisitNumber.InStorageTime=objOldVisitNumber.InStorageTime
	s objVisitNumber.InStorageUserDR=objOldVisitNumber.InStorageUserDR
	s objVisitNumber.IsPrintBar=objOldVisitNumber.IsPrintBar
	s objVisitNumber.LinkLabNo=objOldVisitNumber.LinkLabNo
	s objVisitNumber.LMPDate=objOldVisitNumber.LMPDate
	//s objVisitNumber.LocationDR=objOldVisitNumber.LocationDR
	s LocationCode=""
	i $l(objOldVisitNumber.LocationDR) d
	.s LocationData=$g(^dbo.BTLocationD(objOldVisitNumber.LocationDR))
	.s LocationCode=$lg(LocationData,2)
	s objVisitNumber.LocationCode=LocationCode
	s objVisitNumber.MedicalRecordNo=objOldVisitNumber.MedicalRecordNo
	s objVisitNumber.MixLabNo=objOldVisitNumber.MixLabNo
	s objVisitNumber.MobileNo=objOldVisitNumber.MobileNo
	s objVisitNumber.OutStorageDate=objOldVisitNumber.OutStorageDate
	s objVisitNumber.OutStorageTime=objOldVisitNumber.OutStorageTime
	s objVisitNumber.OutStorageType=objOldVisitNumber.OutStorageType
	s objVisitNumber.OutStorageUserDR="" //objOldVisitNumber.OutStorageUserDR
	s objVisitNumber.PaymentTypeDR="" //objOldVisitNumber.PaymentTypeDR
	s objVisitNumber.PhoneNo=objOldVisitNumber.PhoneNo
	s objVisitNumber.PostCode=objOldVisitNumber.PostCode
	s objVisitNumber.Pregnant=objOldVisitNumber.Pregnant
	s objVisitNumber.PregnantNum=objOldVisitNumber.PregnantNum
	s objVisitNumber.PregnantWeeks=objOldVisitNumber.PregnantWeeks
	s objVisitNumber.ReceiveDate=objOldVisitNumber.ReceiveDate
	//s objVisitNumber.ReceiveHospitalDR=objOldVisitNumber.ReceiveHospitalDR
	s ReceiveHospitalCode=""
	i $l(objOldVisitNumber.ReceiveHospitalDR) d
	.s ReceiveHospitalData=$g(^dbo.BTHospitalD(objOldVisitNumber.ReceiveHospitalDR))
	.s ReceiveHospitalCode=$lg(ReceiveHospitalData,2)
	s objVisitNumber.ReceiveHospitalCode=ReceiveHospitalCode
	s objVisitNumber.ReceiveNotes=objOldVisitNumber.ReceiveNotes
	s objVisitNumber.ReceiveTime=objOldVisitNumber.ReceiveTime
	//s objVisitNumber.ReceiveUserDR=objOldVisitNumber.ReceiveUserDR
	s ReceiveUserCode=""
	i $l(objOldVisitNumber.ReceiveUserDR) d
	.s ReceiveUserData=$g(^dbo.SYSUserD(objOldVisitNumber.ReceiveUserDR))
	.s ReceiveUserCode=$lg(ReceiveUserData,2)
	s objVisitNumber.ReceiveUserCode=ReceiveUserCode
	s objVisitNumber.RegNo=objOldVisitNumber.RegNo
	s objVisitNumber.ReqNotes=objOldVisitNumber.ReqNotes
	s objVisitNumber.RequestDate=objOldVisitNumber.RequestDate
	s objVisitNumber.RequestNo=objOldVisitNumber.RequestNo
	s objVisitNumber.RequestTime=objOldVisitNumber.RequestTime
	s objVisitNumber.RhDR="" //objOldVisitNumber.RhDR
	s objVisitNumber.RUDiseaseDR="" //objOldVisitNumber.RUDiseaseDR
	s objVisitNumber.SpecialFlag=objOldVisitNumber.SpecialFlag
	//s objVisitNumber.SpeciesDR=objOldVisitNumber.SpeciesDR
	s SpeciesCode=""
	i $l(objOldVisitNumber.SpeciesDR) d
	.s SpeciesData=$g(^dbo.BTSpeciesD(objOldVisitNumber.SpeciesDR))
	.s SpeciesCode=$lg(SpeciesData,2)
	s objVisitNumber.SpeciesCode=SpeciesCode
	//s objVisitNumber.SpecimenDR=objOldVisitNumber.SpecimenDR
	s SpecimenCode=""
	i $l(objOldVisitNumber.SpecimenDR) d
	.s SpecimenData=$g(^dbo.BTSpecimenD(objOldVisitNumber.SpecimenDR))
	.s SpecimenCode=$lg(SpecimenData,2)
	s objVisitNumber.SpecimenCode=SpecimenCode
	//s objVisitNumber.SpecimenQualityDR=objOldVisitNumber.SpecimenQualityDR
	s SpecimenQualityCode=""
	i $l(objOldVisitNumber.SpecimenQualityDR) d
	.s SpecimenQualityData=$g(^dbo.BTSpecimenQualityD(objOldVisitNumber.SpecimenQualityDR))
	.s SpecimenQualityCode=$lg(SpecimenQualityData,2)
	s objVisitNumber.SpecimenQualityCode=SpecimenQualityCode
	s objVisitNumber.SurName=objOldVisitNumber.SurName
	s objVisitNumber.Symptom=objOldVisitNumber.Symptom
	s objVisitNumber.Urgent=objOldVisitNumber.Urgent
	s objVisitNumber.VisitNumber=objOldVisitNumber.VisitNumber
	s objVisitNumber.WardDR=objOldVisitNumber.WardDR
	s objVisitNumber.Weight=objOldVisitNumber.Weight 
    //组织报告信息
    i fReportID'="NoReport" d
    .s objVisitNumber.AssayNo=objOldReport.AssayNo
	.s objVisitNumber.AccessionNo=objOldReport.AccessionNo
	.s objVisitNumber.AcceptDate=objOldReport.AcceptDate
	.s objVisitNumber.AcceptTime=objOldReport.AcceptTime
	.//s objVisitNumber.AcceptUserDR=objOldReport.AcceptUserDR
	.s AcceptUserCode=""
	.i $l(objOldReport.AcceptUserDR) d
	..s AcceptUserData=$g(^dbo.SYSUserD(objOldReport.AcceptUserDR))
	..s AcceptUserCode=$lg(AcceptUserData,2)
	.s objVisitNumber.AcceptUserCode=AcceptUserCode
	.s objVisitNumber.AssayDate=objOldReport.AssayDate
	.s objVisitNumber.AssayTime=objOldReport.AssayTime
	.s objVisitNumber.AutoAuth=objOldReport.AutoAuth
	.s objVisitNumber.AuthDate=objOldReport.AuthDate
	.s objVisitNumber.AuthTime=objOldReport.AuthTime
	.//s objVisitNumber.AuthUserDR=objOldReport.AuthUserDR
	.s AuthUserCode=""
	.i $l(objOldReport.AuthUserDR) d
	..s AuthUserData=$g(^dbo.SYSUserD(objOldReport.AuthUserDR))
	..s AuthUserCode=$lg(AuthUserData,2)
	.s objVisitNumber.AuthUserCode=AuthUserCode
	.s objVisitNumber.AddType=objOldReport.AddType
	.s objVisitNumber.DigitSign=objOldReport.DigitSign
	.s objVisitNumber.DigitSignString=objOldReport.DigitSignString
	.s objVisitNumber.DigitSignTime=objOldReport.DigitSignTime
	.s objVisitNumber.DiscardDate=objOldReport.DiscardDate
	.s objVisitNumber.DiscardTime=objOldReport.DiscardTime
	.s objVisitNumber.DiscardUserDR="" //objOldReport.DiscardUserDR
	.s objVisitNumber.DisCardNotes=objOldReport.DisCardNotes
	.s objVisitNumber.EpisodeNo=objOldReport.EpisodeNo
	.s objVisitNumber.EntryDate=objOldReport.EntryDate
	.s objVisitNumber.EntryTime=objOldReport.EntryTime
	.//s objVisitNumber.EntryUserDR=objOldReport.EntryUserDR
	.s EntryUserCode=""
	.i $l(objOldReport.EntryUserDR) d
	..s EntryUserData=$g(^dbo.SYSUserD(objOldReport.EntryUserDR))
	..s EntryUserCode=$lg(EntryUserData,2)
	.s objVisitNumber.EntryUserCode=EntryUserCode
	.s objVisitNumber.ExtraFinished=objOldReport.ExtraFinished
	.s objVisitNumber.FirstReadDate=objOldReport.FirstReadDate
	.s objVisitNumber.FirstReadTime=objOldReport.FirstReadTime
	.//s objVisitNumber.FirstReadDoctorDR=objOldReport.FirstReadDoctorDR
	.s FirstReadDoctorCode=""
	.i $l(objOldReport.FirstReadDoctorDR) d
	..s FirstReadDoctorData=$g(^dbo.SYSUserD(objOldReport.FirstReadDoctorDR))
	..s FirstReadDoctorCode=$lg(FirstReadDoctorData,2)
	.s objVisitNumber.FirstReadDoctorCode=FirstReadDoctorCode	
	.s objVisitNumber.IsPositive=objOldReport.IsPositive
	.s objVisitNumber.LastMachineLName=objOldReport.LastMachineLName
	.s objVisitNumber.MajorConclusion=objOldReport.MajorConclusion
	.s objVisitNumber.MinorConclusion=objOldReport.MinorConclusion
	.s objVisitNumber.OperateFlag=objOldReport.OperateFlag
	.s objVisitNumber.OrderNo=objOldReport.OrderNo
	.s objVisitNumber.Printed=objOldReport.Printed
	.s objVisitNumber.ReAuthDate=objOldReport.ReAuthDate
	.s objVisitNumber.ReAuthTime=objOldReport.ReAuthTime
	.//s objVisitNumber.ReAuthUserDR=objOldReport.ReAuthUserDR
	.s ReAuthUserCode=""
	.i $l(objOldReport.ReAuthUserDR) d
	..s ReAuthUserData=$g(^dbo.SYSUserD(objOldReport.ReAuthUserDR))
	..s ReAuthUserCode=$lg(ReAuthUserData,2)
	.s objVisitNumber.ReAuthUserCode=ReAuthUserCode
	.s objVisitNumber.Readed=objOldReport.Readed
	.s objVisitNumber.ReportClass=objOldReport.ReportClass
	.s objVisitNumber.ReAssayNumber=objOldReport.ReAssayNumber
	.s objVisitNumber.ReportType=objOldReport.ReportType
	.s objVisitNumber.ReportRemark=objOldReport.ReportRemark
	.s objVisitNumber.ResultWarned=objOldReport.ResultWarned
	.s objVisitNumber.RackNo=objOldReport.RackNo
	.s objVisitNumber.Status=objOldReport.Status
	.s objVisitNumber.SplitStatus=objOldReport.SplitStatus
	.s objVisitNumber.TransmitDate=objOldReport.TransmitDate
	.s objVisitNumber.UploadDate=objOldReport.UploadDate
	.s objVisitNumber.UploadTime=objOldReport.UploadTime
	.s objVisitNumber.VisitNumberDR=RPVisitNumberDR
	.//s objVisitNumber.WorkGroupMachineDR=objOldReport.WorkGroupMachineDR 
	.s WorkGroupMachineCode="",tmpWorkGroupDR="",tmpWorkGroupCode="",tmpDepartmentDR="",tmpDepartmentCode=""
	.i $l(objOldReport.WorkGroupMachineDR) d
	..s WorkGroupMachineData=$g(^dbo.BTWorkGroupMachineD(objOldReport.WorkGroupMachineDR))
	..s WorkGroupMachineCode=$lg(WorkGroupMachineData,2)
	..s tmpWorkGroupDR=$lg(WorkGroupMachineData,4)
	.s objVisitNumber.WorkGroupMachineCode=WorkGroupMachineCode
	.i $l(tmpWorkGroupDR) d
	..s tmpWorkGroupData=$g(^dbo.BTWorkGroupD(tmpWorkGroupDR))
	..s tmpWorkGroupCode=$lg(tmpWorkGroupData,2)
	..s tmpDepartmentDR=$lg(tmpWorkGroupData,4)
	.s objVisitNumber.WorkGroupCode=tmpWorkGroupCode
	.i $l(tmpDepartmentDR) d
	..s tmpDepartmentData=$g(^dbo.BTDepartmentD(tmpDepartmentDR))
	..s tmpDepartmentCode=$lg(tmpDepartmentData,2)
    .s objVisitNumber.DepartmentCode=tmpDepartmentCode

    //组织医嘱信息
    s objTestSets=##class(LIS.Util.COM.XML).New("TestSetMsgs")
    s fRITestSetDR="" f  s fRITestSetDR=$o(^TMPLIS($zn,repid,$j,"RITestSet",fLabno,fReportID,fRITestSetDR)) q:fRITestSetDR=""  d
    .s fTestSetDR=$g(^TMPLIS($zn,repid,$j,"RITestSet",fLabno,fReportID,fRITestSetDR))
    .s RPVisitNumberTestSetDR=$o(^dbo.RPVisitNumberTestSetI("IndexMaster",RPVisitNumberDR,fTestSetDR,""))
    .s objOldVNTestSet=##class(dbo.RPVisitNumberTestSet).%OpenId(RPVisitNumberTestSetDR)
    .s objTestSet=##class(LIS.Util.COM.XML).New("TestSetMsg")
    .s objTestSet.AssayNo=objOldVNTestSet.AssayNo
    .s objTestSet.HISOrderID=objOldVNTestSet.HISOrderID
    .s objTestSet.Recieved=objOldVNTestSet.Recieved
    .s objTestSet.ReceivableFee=objOldVNTestSet.ReceivableFee
    .//s objTestSet.TestSetDR=objOldVNTestSet.TestSetDR
    .s TestSetCode=""
	.i $l(objOldVNTestSet.TestSetDR) d
	..s TestSetData=$g(^dbo.BTTestSetD(objOldVNTestSet.TestSetDR))
	..s TestSetCode=$lg(TestSetData,2)
	.s objTestSet.TestSetCode=TestSetCode
    .s objTestSet.TestSetFee=objOldVNTestSet.TestSetFee
    .s objTestSet.TransmitDate=objOldVNTestSet.TransmitDate
    .s objTestSet.Sequence=objOldVNTestSet.Sequence
    .s objTestSet.VisitNumberDR=objOldVNTestSet.VisitNumberDR
    .s WorkGroupMachineCode="",tmpWorkGroupDR="",tmpWorkGroupCode="",tmpDepartmentDR="",tmpDepartmentCode=""
	.i $l(objOldVNTestSet.WorkGroupMachineDR) d
	..s WorkGroupMachineData=$g(^dbo.BTWorkGroupMachineD(objOldVNTestSet.WorkGroupMachineDR))
	..s WorkGroupMachineCode=$lg(WorkGroupMachineData,2)
	..s tmpWorkGroupDR=$lg(WorkGroupMachineData,4)
	.s objTestSet.WorkGroupMachineCode=WorkGroupMachineCode
	.i $l(tmpWorkGroupDR) d
	..s tmpWorkGroupData=$g(^dbo.BTWorkGroupD(tmpWorkGroupDR))
	..s tmpWorkGroupCode=$lg(tmpWorkGroupData,2)
	..s tmpDepartmentDR=$lg(tmpWorkGroupData,4)
	.s objTestSet.WorkGroupCode=tmpWorkGroupCode
	.i $l(tmpDepartmentDR) d
	..s tmpDepartmentData=$g(^dbo.BTDepartmentD(tmpDepartmentDR))
	..s tmpDepartmentCode=$lg(tmpDepartmentData,2)
    .s objTestSet.DepartmentCode=tmpDepartmentCode
    .d objTestSets.Insert(objTestSet)    
    //插入医嘱信息
    d objVisitNumber.Insert(objTestSets)
        
    //组织结果信息
    s objResultMsgs=##class(LIS.Util.COM.XML).New("ResultMsgs")
    i fReportID'="NoReport" d
    .s fTestCodeDR="" f  s fTestCodeDR=$o(^dbo.RPVisitNumberReportResultI("IndexReportItem",fReportID,fTestCodeDR)) q:fTestCodeDR=""  d
    ..s fReportResultDR=$o(^dbo.RPVisitNumberReportResultI("IndexReportItem",fReportID,fTestCodeDR,"")) 
    ..s objOldTCResult=##class(dbo.RPVisitNumberReportResult).%OpenId(fReportResultDR)
    ..s objResultMsg=##class(LIS.Util.COM.XML).New("ResultMsg")
    ..//s objResultMsg.TestCodeDR=objOldTCResult.TestCodeDR
    ..s TestCode=""
	..i $l(objOldTCResult.TestCodeDR) d
	...s TestCodeData=$g(^dbo.BTTestCodeD(objOldTCResult.TestCodeDR))
	...s TestCode=$lg(TestCodeData,2)
	..s objResultMsg.TestCode=TestCode
    ..s objResultMsg.VisitNumberReportDR=VisitNumberReportDR //objOldTCResult.VisitnumberReportDR
	..s objResultMsg.Result=objOldTCResult.Result
	..s objResultMsg.TextRes=objOldTCResult.TextRes
	..s objResultMsg.ExtraRes=objOldTCResult.ExtraRes
	..s objResultMsg.OtherRes=objOldTCResult.OtherRes
	..s objResultMsg.ResNoes=objOldTCResult.ResNoes
	..s objResultMsg.AbFlag=objOldTCResult.AbFlag
	..s objResultMsg.ResClass=objOldTCResult.ResClass
	..s objResultMsg.Unit=objOldTCResult.Unit
	..s objResultMsg.RefRanges=objOldTCResult.RefRanges
	..//s objResultMsg.MethodDR=objOldTCResult.MethodDR
	..s MethodCode=""
	..i $l(objOldTCResult.MethodDR) d
	...s MethodData=$g(^dbo.BTTestMethodD(objOldTCResult.MethodDR))
	...s MethodCode=$lg(MethodData,2)
	..s objResultMsg.MethodCode=MethodCode
	..//s objResultMsg.MachineParameterDR=objOldTCResult.MachineParameterDR
	..s MachineParameterCode=""
	..i $l(objOldTCResult.MachineParameterDR) d
	...s MachineParameterData=$g(^dbo.BTMIMachineParameterD(objOldTCResult.MachineParameterDR))
	...s MachineParameterCode=$lg(MachineParameterData,2)
	..s objResultMsg.MachineParameterCode=MachineParameterCode
	..//s objResultMsg.OperateUserDR=objOldTCResult.OperateUserDR
	..s OperateUserCode=""
	..i $l(objOldTCResult.OperateUserDR) d
	...s OperateUserData=$g(^dbo.SYSUserD(objOldTCResult.OperateUserDR))
	...s OperateUserCode=$lg(OperateUserData,2)
	..s objResultMsg.OperateUserCode=OperateUserCode
	..s objResultMsg.AssayDate=objOldTCResult.AssayDate
	..s objResultMsg.AssayTime=objOldTCResult.AssayTime
	..s objResultMsg.Sequence=objOldTCResult.Sequence		    
	..s objResultMsg.AssayStatus=objOldTCResult.AssayStatus
	..s objResultMsg.ReAssayNum=objOldTCResult.ReAssayNum
    ..s objResultMsg.ExpertRule=objOldTCResult.ExpertRule
	..s objResultMsg.RegNo=objOldTCResult.RegNo
    ..s objResultMsg.AdmNo=objOldTCResult.AdmNo
    ..s objResultMsg.AuthDate=objOldTCResult.AuthDate
    ..s objResultMsg.AuthTime=objOldTCResult.AuthTime
    ..s objResultMsg.ReAssayNumber=objOldTCResult.ReAssayNumber
    ..s objResultMsg.MultipleResistant=objOldTCResult.MultipleResistant
    ..//s objResultMsg.TestSetDR=objOldTCResult.TestSetDR
    ..s TestSetCode=""
	..i $l(objOldTCResult.TestSetDR) d
	...s TestSetData=$g(^dbo.BTTTestSetD(objOldTCResult.TestSetDR))
	...s TestSetCode=$lg(TestSetData,2)
	..s objResultMsg.TestSetCode=TestSetCode
    ..s objResultMsg.IsNotReport=objOldTCResult.IsNotReport
    ..s objResultMsg.IsMandatory=objOldTCResult.IsMandatory
    ..//s objResultMsg.RPVisitNumberTestSetDR=objOldTCResult.RPVisitNumberTestSetDR
    ..s objResultMsg.OperateType=objOldTCResult.OperateType
    ..s objResultMsg.MultipleResChild=objOldTCResult.MultipleResChild
    ..s objResultMsg.IsNotAllowPrint=objOldTCResult.IsNotAllowPrint
    ..s objResultMsg.PrintSeq=objOldTCResult.PrintSeq
    ..s objResultMsg.OthTestSetIDs=objOldTCResult.OthTestSetIDs
	..s objResultMsg.DilCode=objOldTCResult.DilCode   
    ..d objResultMsgs.Insert(objResultMsg)
    //插入结果信息 
    d objVisitNumber.Insert(objResultMsgs)
    d RetXML.Insert(objVisitNumber)
    s Input=RetXML.ToXMLStream()
    s strInput=Input.Read(80000)
   
    s ret=##class(LIS.WS.DHCLISServiceBase).RemoteGetData(Address,"ES.LIS.DHCTransferEmergentData","SaveLISExternalResultMTHD",strInput,HospitalCode) 
    //s ret=##Class(ES.LIS.DHCTransferEmergentData).SaveLISExternalResultMTHD(Input,HospitalCode)
    If ret'=0 throw ##class(%Exception.SystemException).%New("事务委托","D",,"同步标本失败:"_ret)
    b //2
  
    //同步成功后,置中间表状态
    s fRITestSetDR="" f  s fRITestSetDR=$o(^TMPLIS($zn,repid,$j,"RITestSet",fLabno,fReportID,fRITestSetDR)) q:fRITestSetDR=""  d
    .s objRILabTestSet=##class(dbo.RILabTestSet).%OpenId(fRITestSetDR)
    .s objRILabTestSet.IsChanged=0
    .s sc=objRILabTestSet.%Save()
	.i '($SYSTEM.Status.IsOK(sc)) throw ##class(%Exception.SystemException).%New("事务委托","D",,"置中间表(RILabTestSet)状态失败:"_$SYSTEM.Status.GetErrorText(sc))
    q

InsertOneTS
	//同步应急库中间表数据到正式库中间表
    s RITestSetData=$g(^dbo.RILabTestSetD(fRITestSetDR))
    s LabRequestDR=$lg(RITestSetData,1)
    s LabRequestData=$g(^dbo.RILabRequestD(LabRequestDR))
    s TransferFlag=0
	s RetXML=##class(LIS.Util.COM.XML).New("Request")
	s objLabRequest=##class(LIS.Util.COM.XML).New("LabRequestMsg")
    s objLabRequest.VisitNumberFrom=$lg(LabRequestData,1)
	s objLabRequest.AdmissionType=$lg(LabRequestData,2) 
	s objLabRequest.RegNo=$lg(LabRequestData,3) 
	s objLabRequest.AdmNo=$lg(LabRequestData,4) 
	s objLabRequest.MedicalRecordNo=$lg(LabRequestData,5) 
	s objLabRequest.AdmDate=$lg(LabRequestData,6) 
	s objLabRequest.AdmTime=$lg(LabRequestData,7) 
	s objLabRequest.CertType=$lg(LabRequestData,8) 
	s objLabRequest.CertNo=$lg(LabRequestData,9) 
	s objLabRequest.IDNumber=$lg(LabRequestData,10) 
	s objLabRequest.PaymentType=$lg(LabRequestData,11) 
	s objLabRequest.PaymentName=$lg(LabRequestData,12) 
	s objLabRequest.SurName=$lg(LabRequestData,13) 
	s objLabRequest.GivenName=$lg(LabRequestData,14) 
	s objLabRequest.SpeciesID=$lg(LabRequestData,15) 
	s objLabRequest.SpeciesName=$lg(LabRequestData,16) 
	s objLabRequest.BirthDate=$lg(LabRequestData,17) 
	s objLabRequest.BirthTime=$lg(LabRequestData,18) 
	s objLabRequest.Age=$lg(LabRequestData,19) 
	s objLabRequest.AgeUnit=$lg(LabRequestData,20) 
	s objLabRequest.Ethnicity=$lg(LabRequestData,21) 
	s objLabRequest.HospitaID=$lg(LabRequestData,22) 
	s objLabRequest.HospitaName=$lg(LabRequestData,23) 
	s objLabRequest.SymptomID=$lg(LabRequestData,24) 
	s objLabRequest.Symptom=$lg(LabRequestData,25) 
	s objLabRequest.MobileNo=$lg(LabRequestData,26) 
	s objLabRequest.PhoneNo=$lg(LabRequestData,27) 
	s objLabRequest.email=$lg(LabRequestData,28) 
	s objLabRequest.Height=$lg(LabRequestData,29) 
	s objLabRequest.Weight=$lg(LabRequestData,30) 
	s objLabRequest.BloodPressure=$lg(LabRequestData,31) 
	s objLabRequest.ClinicalConditions=$lg(LabRequestData,32) 
	s objLabRequest.Pregnant=$lg(LabRequestData,33) 
	s objLabRequest.PregnantWeeks=$lg(LabRequestData,34) 
	s objLabRequest.ABO=$lg(LabRequestData,35) 
	s objLabRequest.RH=$lg(LabRequestData,36) 
	s objLabRequest.Address=$lg(LabRequestData,37) 
	s objLabRequest.PostCode=$lg(LabRequestData,38) 
	s objLabRequest.InfectFlag=$lg(LabRequestData,39) 
	s objLabRequest.InfectAlert=$lg(LabRequestData,40) 
	s objLabRequest.PregnantNum=$lg(LabRequestData,41) 
	s objLabRequest.ChildbirthNum=$lg(LabRequestData,42) 
   
    s objLabTestSetMsgs=##class(LIS.Util.COM.XML).New("LabTestSetMsgs")
	s objLabTestSet=##class(LIS.Util.COM.XML).New("LabTestSetMsg")
    s objLabTestSet.VisitNumberDR=$lg(RITestSetData,1) 
	s objLabTestSet.TestSetCode=$lg(RITestSetData,2)  
	s objLabTestSet.TestSetName=$lg(RITestSetData,3)  
	s objLabTestSet.TestSetRowID=$lg(RITestSetData,4)  
	s objLabTestSet.Sequence=$lg(RITestSetData,5)  
	s objLabTestSet.BarCode=$lg(RITestSetData,6)  
	s objLabTestSet.ArticleBarCode=$lg(RITestSetData,7)  
	s objLabTestSet.TestSetState=$lg(RITestSetData,8)     //1：登记，2：打印条码，3：采集，4：标本运送，5：标本接收，6：停止，7：作废，8.拒收,10:打包，11：送达,13:护士执行（条码生成）
	s objLabTestSet.VisitNumberTestSetCode=$lg(RITestSetData,9)  
	s objLabTestSet.SpecimenCode=$lg(RITestSetData,10)  
	s objLabTestSet.SpecimenName=$lg(RITestSetData,11)      
	s objLabTestSet.ContainerCode=$lg(RITestSetData,12)  
	s objLabTestSet.ContainerName=$lg(RITestSetData,13)  
	s objLabTestSet.CollectNotes=$lg(RITestSetData,14)  
	s objLabTestSet.LocationCode=$lg(RITestSetData,15)  
	s objLabTestSet.LocationName=$lg(RITestSetData,16)      
	s objLabTestSet.WardCode=$lg(RITestSetData,17)  
	s objLabTestSet.WardName=$lg(RITestSetData,18)  
	s objLabTestSet.BedNo=$lg(RITestSetData,19)  
	s objLabTestSet.DotorID=$lg(RITestSetData,20)  
	s objLabTestSet.DotorName=$lg(RITestSetData,21)          
	s objLabTestSet.RequestDate=$lg(RITestSetData,22)  
	s objLabTestSet.RequestTime=$lg(RITestSetData,23)  
	s objLabTestSet.PrinterID=$lg(RITestSetData,24) 
	s objLabTestSet.PrinterName=$lg(RITestSetData,25) 
	s objLabTestSet.PrintDate=$lg(RITestSetData,26) 
	s objLabTestSet.PrintTime=$lg(RITestSetData,27) 
	s objLabTestSet.PrintStatus=$lg(RITestSetData,28) 
	s objLabTestSet.CollectDate=$lg(RITestSetData,29)  
	s objLabTestSet.CollectTime=$lg(RITestSetData,30)  
	s objLabTestSet.CollectUserID=$lg(RITestSetData,31)  
	s objLabTestSet.CollectUserName=$lg(RITestSetData,32)  
	s objLabTestSet.AnatomicalSite=$lg(RITestSetData,33)  
	s objLabTestSet.CollectPositon=$lg(RITestSetData,34)  
	s objLabTestSet.CarryDate=$lg(RITestSetData,35)  
	s objLabTestSet.CarryTime=$lg(RITestSetData,36)  
	s objLabTestSet.CarryUserID=$lg(RITestSetData,37)  
	s objLabTestSet.CarryUserName=$lg(RITestSetData,38)  
	s objLabTestSet.ReceiveDate=$lg(RITestSetData,39)  
	s objLabTestSet.ReceiveTime=$lg(RITestSetData,40)  
	s objLabTestSet.ReceiveUserID=$lg(RITestSetData,41)  
	s objLabTestSet.ReceiveUserName=$lg(RITestSetData,42)  
	s objLabTestSet.TestSetFee=$lg(RITestSetData,43)   
	s objLabTestSet.TestSetFeeFlag=$lg(RITestSetData,44)  //默认已计费 TestSetFeeFlag 
	s objLabTestSet.ReqNotes=$lg(RITestSetData,45)  
	s objLabTestSet.RequestNo=$lg(RITestSetData,46)  
	s objLabTestSet.Urgent=$lg(RITestSetData,47)  
	s objLabTestSet.H24UVolume=$lg(RITestSetData,48)  
	s objLabTestSet.H24UTimePeriod=$lg(RITestSetData,49)  
	s objLabTestSet.BodyTemp=$lg(RITestSetData,50)  
	s objLabTestSet.BloodPressure=$lg(RITestSetData,51)  
	s objLabTestSet.Confidential=$lg(RITestSetData,52)  
	s objLabTestSet.SpecimenQuality=$lg(RITestSetData,53)  
	s objLabTestSet.ReceiveHospitalID=$lg(RITestSetData,54)  
	s objLabTestSet.ReceiveNotes=$lg(RITestSetData,55)  
	s objLabTestSet.SpecialFlag=$lg(RITestSetData,56)  
	s objLabTestSet.SpecialRowId=$lg(RITestSetData,57) 
	s objLabTestSet.OrdDeptID=$lg(RITestSetData,58) 
	s objLabTestSet.OrdDeptName=$lg(RITestSetData,59)  
	s objLabTestSet.HospitalCode=$lg(RITestSetData,60)  
	s objLabTestSet.HospitalName=$lg(RITestSetData,61)  
	s objLabTestSet.WorkGroupMachineDR=$lg(RITestSetData,62)  
	s objLabTestSet.TransmitDate=$lg(RITestSetData,63)  
	s objLabTestSet.AssayNo=$lg(RITestSetData,64)  
	s objLabTestSet.AcceptDate=$lg(RITestSetData,65)  
	s objLabTestSet.AcceptTime=$lg(RITestSetData,66)  
	s objLabTestSet.AcceptUserDR=$lg(RITestSetData,67)  
	s objLabTestSet.ReportID=$lg(RITestSetData,68)  
	//报告在正式库如果是审核状态，置应急库对应的IsChanged为0(即应急库不需要给正式库同步了)
	s objLabTestSet.IsChanged=$lg(RITestSetData,69)
	s objLabTestSet.UpdateDate=$lg(RITestSetData,70)  
	s objLabTestSet.UpdateTime=$lg(RITestSetData,71)  
	s objLabTestSet.AddDate=$lg(RITestSetData,72)  
	s objLabTestSet.AddTime=$lg(RITestSetData,73)         
	d objLabTestSetMsgs.Insert(objLabTestSet)
	d objLabRequest.Insert(objLabTestSetMsgs) 
	d RetXML.Insert(objLabRequest)
    s Input=RetXML.ToXMLStream()
    s strInput=Input.Read()
    
    s ret=##class(LIS.WS.DHCLISServiceBase).RemoteGetData(Address,"ES.LIS.DHCRegisterByQRCode","SyncRILabRequestTSMTHD",strInput,"", "", "", "", "", "", "", "", "", "", "", "", "", Sessions,"")
    //同步成功后置中间表状态
     
    i ret=1 d
    .s objLabTestSet=##class(dbo.RILabTestSet).%OpenId(fRITestSetDR)
    .s objLabTestSet.IsChanged=0
    .s retTS=objLabTestSet.%Save()
	.If '($SYSTEM.Status.IsOK(retTS)) s ret="-1^医嘱信息保存失败:"_$SYSTEM.Status.GetErrorText(retTS)	
    q
}

/// Creator:刘志飞
/// CreatDate:2017-09-09
/// Description:外部结果报告(微生物报告)导入  不需要HIS信息,直接导入结果
/// Input: 检验平台接口XML 
/// 检验结果样式串 //Input As %GlobalCharacterStream,
/// <Request><ReportMsg><OrdID></OrdID><TestSetID>L0001</TestSetID><RecUserCode>1451</RecUserCode><RecUser>陈秀娟</RecUser><RecDate>2016-11-13</RecDate><RecTime>15:12:34</RecTime><EntryUserCode></EntryUserCode><EntryUser>郑泽强</EntryUser><EntryDate>2016-11-14</EntryDate><EntryTime>12:53:51</EntryTime><AuthUserCode>1475</AuthUserCode><AuthUser>周莲</AuthUser><AuthDate>2016-11-14</AuthDate><AuthTime>12:53:51</AuthTime><Notes></Notes><ImageFile></ImageFile><MainWarnDesc></MainWarnDesc><ResultMsgs><ResultMsg><LabNo>7000027229</LabNo><TestCode>4081</TestCode><TestName>弓形虫抗体</TestName><TestEngName>TO-lgM(ELISA)</TestEngName><Result>阴性(-)</Result><Units></Units><Notes></Notes><ResultFlag>N</ResultFlag><Ranges>阴性（-）</Ranges><Sequence>280</Sequence><MICFlag>N</MICFlag><MICName>弓形虫抗体</MICName><WarnDesc></WarnDesc><OrgResultMsgs></OrgResultMsgs></ResultMsg><ResultMsg><LabNo>7000027229</LabNo><TestCode>4072</TestCode><TestName>风疹病毒抗体</TestName><TestEngName>R-lgM(ELISA)</TestEngName><Result>阴性(-)</Result><Units></Units><Notes></Notes><ResultFlag>N</ResultFlag><Ranges>阴性（-）</Ranges><Sequence>290</Sequence><MICFlag>N</MICFlag><MICName>风疹病毒抗体</MICName><WarnDesc></WarnDesc><OrgResultMsgs></OrgResultMsgs></ResultMsg><ResultMsg><LabNo>7000027229</LabNo><TestCode>4016</TestCode><TestName>巨细胞病毒抗体</TestName><TestEngName>C -lgM(ELISA)</TestEngName><Result>阴性(-)</Result><Units></Units><Notes></Notes><ResultFlag>N</ResultFlag><Ranges>阴性（-）</Ranges><Sequence>300</Sequence><MICFlag>N</MICFlag><MICName>巨细胞病毒抗体</MICName><WarnDesc></WarnDesc><OrgResultMsgs></OrgResultMsgs></ResultMsg><ResultMsg><LabNo>7000027229</LabNo><TestCode>4053</TestCode><TestName>单纯疱疹病毒抗体Ⅰ型M</TestName><TestEngName>HSV-ⅠlgM(ELISA)</TestEngName><Result>阴性(-)</Result><Units></Units><Notes></Notes><ResultFlag>N</ResultFlag><Ranges>阴性（-）</Ranges><Sequence>310</Sequence><MICFlag>N</MICFlag><MICName>单纯疱疹病毒抗体Ⅰ型M</MICName><WarnDesc></WarnDesc><OrgResultMsgs></OrgResultMsgs></ResultMsg><ResultMsg><LabNo>7000027229</LabNo><TestCode>4055</TestCode><TestName>单纯疱疹病毒抗体Ⅱ型M</TestName><TestEngName>HSV-ⅡlgM(ELISA)</TestEngName><Result>阴性(-)</Result><Units></Units><Notes></Notes><ResultFlag>N</ResultFlag><Ranges>阴性（-）</Ranges><Sequence>320</Sequence><MICFlag>N</MICFlag><MICName>单纯疱疹病毒抗体Ⅱ型M</MICName><WarnDesc></WarnDesc><OrgResultMsgs></OrgResultMsgs></ResultMsg></ResultMsgs></ReportMsg></Request>
/// 微生物结果样式串
/// <Request><ReportMsg><OrdID>1090||58</OrdID><TestSetID>医嘱代码</TestSetID><RecUserCode>1450</RecUserCode><RecUser>王婧婧</RecUser><RecDate>2016-11-13</RecDate><RecTime>16:23:44</RecTime><EntryUserCode>1450</EntryUserCode><EntryUser>王婧婧</EntryUser><EntryDate>2016-11-17</EntryDate><EntryTime>09:43:29</EntryTime><AuthUserCode>1469</AuthUserCode><AuthUser>吴吉芳</AuthUser><AuthDate>2016-11-17</AuthDate><AuthTime>09:43:29</AuthTime><Notes></Notes><ImageFile></ImageFile><MainWarnDesc></MainWarnDesc><ResultMsgs><ResultMsg><LabNo>17051000011</LabNo><TestCode>2298</TestCode><TestName>一般细菌培养及鉴定1</TestName><TestEngName></TestEngName><Result>SAU</Result><Units></Units><Notes></Notes><ResultFlag></ResultFlag><Ranges></Ranges><Sequence>480</Sequence><MICFlag>Y</MICFlag><MICName>金黄色葡萄球菌</MICName><WarnDesc></WarnDesc><OrgResultMsgs><OrgResultMsg><BugsCode>SAU</BugsCode><AntiCode>AMC</AntiCode><AntiName>阿莫西林/棒酸</AntiName><AntiEngName>AMC</AntiEngName><MICRes>≤0.5/0.25</MICRes><KBRes></KBRes><Result>敏感</Result><MICRanges></MICRanges><KBRanges></KBRanges><Order>1</Order></OrgResultMsg><OrgResultMsg><BugsCode>SAU</BugsCode><AntiCode>AN</AntiCode><AntiName>阿米卡星</AntiName><AntiEngName>AN</AntiEngName><MICRes>≤4</MICRes><KBRes></KBRes><Result>敏感</Result><MICRanges></MICRanges><KBRanges></KBRanges><Order>2</Order></OrgResultMsg><OrgResultMsg><BugsCode>SAU</BugsCode><AntiCode>AZT</AntiCode><AntiName>阿奇霉素</AntiName><AntiEngName>AZT</AntiEngName><MICRes>≥8</MICRes><KBRes></KBRes><Result>耐药</Result><MICRanges></MICRanges><KBRanges></KBRanges><Order>3</Order></OrgResultMsg><OrgResultMsg><BugsCode>SAU</BugsCode><AntiCode>CE</AntiCode><AntiName>克林霉素/红霉素</AntiName><AntiEngName>CE</AntiEngName><MICRes>＞0.5/4</MICRes><KBRes></KBRes><Result>耐药</Result><MICRanges></MICRanges><KBRanges></KBRanges><Order>4</Order></OrgResultMsg><OrgResultMsg><BugsCode>SAU</BugsCode><AntiCode>CZO</AntiCode><AntiName>头孢唑啉</AntiName><AntiEngName>CZO</AntiEngName><MICRes>≤1</MICRes><KBRes></KBRes><Result>敏感</Result><MICRanges></MICRanges><KBRanges></KBRanges><Order>5</Order></OrgResultMsg></OrgResultMsgs></ResultMsg><ResultMsg><LabNo>17051000011</LabNo><TestCode>2299</TestCode><TestName>一般细菌培养及鉴定2</TestName><TestEngName></TestEngName><Result>ABA</Result><Units></Units><Notes></Notes><ResultFlag></ResultFlag><Ranges></Ranges><Sequence>480</Sequence><MICFlag>Y</MICFlag><MICName>鲍曼不动杆菌</MICName><WarnDesc></WarnDesc><OrgResultMsgs><OrgResultMsg><BugsCode>ABA</BugsCode><AntiCode>AMC</AntiCode><AntiName>阿莫西林/棒酸</AntiName><AntiEngName>AMC</AntiEngName><MICRes>≤0.5/0.25</MICRes><KBRes></KBRes><Result>敏感</Result><MICRanges></MICRanges><KBRanges></KBRanges><Order>1</Order></OrgResultMsg><OrgResultMsg><BugsCode>ABA</BugsCode><AntiCode>FOX</AntiCode><AntiName>头孢西丁</AntiName><AntiEngName>FOX</AntiEngName><MICRes>≤2</MICRes><KBRes></KBRes><Result>敏感</Result><MICRanges></MICRanges><KBRanges></KBRanges><Order>2</Order></OrgResultMsg><OrgResultMsg><BugsCode>ABA</BugsCode><AntiCode>gm</AntiCode><AntiName>庆大霉素</AntiName><AntiEngName>gm</AntiEngName><MICRes>≤1</MICRes><KBRes></KBRes><Result>敏感</Result><MICRanges></MICRanges><KBRanges></KBRanges><Order>3</Order></OrgResultMsg><OrgResultMsg><BugsCode>ABA</BugsCode><AntiCode>IMI</AntiCode><AntiName>亚胺培南</AntiName><AntiEngName>IMI</AntiEngName><MICRes>≤0.06</MICRes><KBRes></KBRes><Result>敏感</Result><MICRanges></MICRanges><KBRanges></KBRanges><Order>4</Order></OrgResultMsg></OrgResultMsgs></ResultMsg></ResultMsgs></ReportMsg></Request>
/// w ##Class(ES.LIS.DHCTransferEmergentData).SaveLISExternalResultMTHD("<Request><ReportMsg><OrdID></OrdID><LabNo>7000027229</LabNo><RegNo>7000027229</RegNo><AdmNo>7000027229</AdmNo><MedicalRecordNo></MedicalRecordNo><AdmissionType></AdmissionType><AdmDate></AdmDate><AdmTime></AdmTime><IDNumber></IDNumber><PatientName></PatientName><SexCode></SexCode><BirthDate></BirthDate><TestSetID>S0005</TestSetID><SpecimenID>S0005</SpecimenID><ContainerID>S0005</ContainerID><RecUserCode>1451</RecUserCode><RecUser>陈秀娟</RecUser><RecDate>2016-11-13</RecDate><RecTime>15:12:34</RecTime><EpisodeNo>15:12:34</EpisodeNo><EntryUserCode></EntryUserCode><EntryUser>郑泽强</EntryUser><EntryDate>2016-11-14</EntryDate><EntryTime>12:53:51</EntryTime><AuthUserCode>1475</AuthUserCode><AuthUser>周莲</AuthUser><AuthDate>2016-11-14</AuthDate><AuthTime>12:53:51</AuthTime><Notes></Notes><ImageFile></ImageFile><MainWarnDesc></MainWarnDesc><ResultMsgs><ResultMsg><LabNo>7000027229</LabNo><TestCode>4081</TestCode><TestName>弓形虫抗体</TestName><TestEngName>TO-lgM(ELISA)</TestEngName><Result>阴性(-)</Result><Units></Units><Notes></Notes><ResultFlag>N</ResultFlag><Ranges>阴性（-）</Ranges><Sequence>280</Sequence><MICFlag>N</MICFlag><MICName>弓形虫抗体</MICName><WarnDesc></WarnDesc><OrgResultMsgs></OrgResultMsgs></ResultMsg><ResultMsg><LabNo>7000027229</LabNo><TestCode>4072</TestCode><TestName>风疹病毒抗体</TestName><TestEngName>R-lgM(ELISA)</TestEngName><Result>阴性(-)</Result><Units></Units><Notes></Notes><ResultFlag>N</ResultFlag><Ranges>阴性（-）</Ranges><Sequence>290</Sequence><MICFlag>N</MICFlag><MICName>风疹病毒抗体</MICName><WarnDesc></WarnDesc><OrgResultMsgs></OrgResultMsgs></ResultMsg><ResultMsg><LabNo>7000027229</LabNo><TestCode>4016</TestCode><TestName>巨细胞病毒抗体</TestName><TestEngName>C -lgM(ELISA)</TestEngName><Result>阴性(-)</Result><Units></Units><Notes></Notes><ResultFlag>N</ResultFlag><Ranges>阴性（-）</Ranges><Sequence>300</Sequence><MICFlag>N</MICFlag><MICName>巨细胞病毒抗体</MICName><WarnDesc></WarnDesc><OrgResultMsgs></OrgResultMsgs></ResultMsg><ResultMsg><LabNo>7000027229</LabNo><TestCode>4053</TestCode><TestName>单纯疱疹病毒抗体Ⅰ型M</TestName><TestEngName>HSV-ⅠlgM(ELISA)</TestEngName><Result>阴性(-)</Result><Units></Units><Notes></Notes><ResultFlag>N</ResultFlag><Ranges>阴性（-）</Ranges><Sequence>310</Sequence><MICFlag>N</MICFlag><MICName>单纯疱疹病毒抗体Ⅰ型M</MICName><WarnDesc></WarnDesc><OrgResultMsgs></OrgResultMsgs></ResultMsg><ResultMsg><LabNo>7000027229</LabNo><TestCode>4055</TestCode><TestName>单纯疱疹病毒抗体Ⅱ型M</TestName><TestEngName>HSV-ⅡlgM(ELISA)</TestEngName><Result>阴性(-)</Result><Units></Units><Notes></Notes><ResultFlag>N</ResultFlag><Ranges>阴性（-）</Ranges><Sequence>320</Sequence><MICFlag>N</MICFlag><MICName>单纯疱疹病毒抗体Ⅱ型M</MICName><WarnDesc></WarnDesc><OrgResultMsgs></OrgResultMsgs></ResultMsg></ResultMsgs></ReportMsg></Request>","DHSZHYYZY")
/// w ##Class(ES.LIS.DHCTransferEmergentData).SaveLISExternalResultMTHD("","DHSZHYYZY",$c(0),$c(0),$c(0),$c(0),$c(0),$c(0),$c(0),$c(0),$c(0),$c(0),$c(0),$c(0),"^^^^^^JSON")
ClassMethod SaveLISExternalResultMTHD(Input As %GlobalCharacterStream, HospitalCode As %String, P2, P3, P4, P5, P6, P7, P8, P9, P10, P11, P12, P13, Sessions, Output RowCount As %String) As %String
{

	//测试
	//s Input="<Request><ReportMsg><OrdID></OrdID><LabNo>7000027229</LabNo><TestSetID>S0005</TestSetID><RecUserCode>1451</RecUserCode><RecUser>陈秀娟</RecUser><RecDate>2016-11-13</RecDate><RecTime>15:12:34</RecTime><EntryUserCode></EntryUserCode><EntryUser>郑泽强</EntryUser><EntryDate>2016-11-14</EntryDate><EntryTime>12:53:51</EntryTime><AuthUserCode>1475</AuthUserCode><AuthUser>周莲</AuthUser><AuthDate>2016-11-14</AuthDate><AuthTime>12:53:51</AuthTime><Notes></Notes><ImageFile></ImageFile><MainWarnDesc></MainWarnDesc><ResultMsgs><ResultMsg><LabNo>7000027229</LabNo><TestCode>4081</TestCode><TestName>弓形虫抗体</TestName><TestEngName>TO-lgM(ELISA)</TestEngName><Result>阴性(-)</Result><Units></Units><Notes></Notes><ResultFlag>N</ResultFlag><Ranges>阴性（-）</Ranges><Sequence>280</Sequence><MICFlag>N</MICFlag><MICName>弓形虫抗体</MICName><WarnDesc></WarnDesc><OrgResultMsgs></OrgResultMsgs></ResultMsg><ResultMsg><LabNo>7000027229</LabNo><TestCode>4072</TestCode><TestName>风疹病毒抗体</TestName><TestEngName>R-lgM(ELISA)</TestEngName><Result>阴性(-)</Result><Units></Units><Notes></Notes><ResultFlag>N</ResultFlag><Ranges>阴性（-）</Ranges><Sequence>290</Sequence><MICFlag>N</MICFlag><MICName>风疹病毒抗体</MICName><WarnDesc></WarnDesc><OrgResultMsgs></OrgResultMsgs></ResultMsg><ResultMsg><LabNo>7000027229</LabNo><TestCode>4016</TestCode><TestName>巨细胞病毒抗体</TestName><TestEngName>C -lgM(ELISA)</TestEngName><Result>阴性(-)</Result><Units></Units><Notes></Notes><ResultFlag>N</ResultFlag><Ranges>阴性（-）</Ranges><Sequence>300</Sequence><MICFlag>N</MICFlag><MICName>巨细胞病毒抗体</MICName><WarnDesc></WarnDesc><OrgResultMsgs></OrgResultMsgs></ResultMsg><ResultMsg><LabNo>7000027229</LabNo><TestCode>4053</TestCode><TestName>单纯疱疹病毒抗体Ⅰ型M</TestName><TestEngName>HSV-ⅠlgM(ELISA)</TestEngName><Result>阴性(-)</Result><Units></Units><Notes></Notes><ResultFlag>N</ResultFlag><Ranges>阴性（-）</Ranges><Sequence>310</Sequence><MICFlag>N</MICFlag><MICName>单纯疱疹病毒抗体Ⅰ型M</MICName><WarnDesc></WarnDesc><OrgResultMsgs></OrgResultMsgs></ResultMsg><ResultMsg><LabNo>7000027229</LabNo><TestCode>4055</TestCode><TestName>单纯疱疹病毒抗体Ⅱ型M</TestName><TestEngName>HSV-ⅡlgM(ELISA)</TestEngName><Result>阴性(-)</Result><Units></Units><Notes></Notes><ResultFlag>N</ResultFlag><Ranges>阴性（-）</Ranges><Sequence>320</Sequence><MICFlag>N</MICFlag><MICName>单纯疱疹病毒抗体Ⅱ型M</MICName><WarnDesc></WarnDesc><OrgResultMsgs></OrgResultMsgs></ResultMsg></ResultMsgs></ReportMsg></Request>"
	//s ^MMP("SaveLISExternalResultMTHD",$h)=Input //$lb(Input, HospitalCode, P2, P3, P4, P5, P6, P7, P8, P9, P10, P11, P12, P13, Sessions)
	Set $ZTrap = "ErrorHandle"
	;TSTART 去掉事务是因为调用前已经事务托管了,该方法只针对于应急使用
	s Input=$g(Input)
	s HospitalCode=$g(HospitalCode)
	s HospitalDR=$o(^dbo.BTHospitalI("IndexCode",##Class(LIS.Util.Common).IndexData(HospitalCode),""))
	i '$l(HospitalDR) q "-1^未找到对应医院！" 
	s WebNamespace=##Class(OTH.SYSParameter).GetWebNamespace()
	//走xml解析
    //s Input="<Request><ReportMsg><OrdID></OrdID><LabNo>7000027229</LabNo><RegNo>7000027229</RegNo><AdmNo>7000027229</AdmNo><MedicalRecordNo></MedicalRecordNo><AdmissionType></AdmissionType><AdmDate></AdmDate><AdmTime></AdmTime><IDNumber></IDNumber><PatientName></PatientName><SexCode></SexCode><BirthDate></BirthDate><TestSetID>S0005</TestSetID><SpecimenID>S0005</SpecimenID><ContainerID>S0005</ContainerID><RecUserCode>1451</RecUserCode><RecUser>陈秀娟</RecUser><RecDate>2016-11-13</RecDate><RecTime>15:12:34</RecTime><EpisodeNo>15:12:34</EpisodeNo><EntryUserCode></EntryUserCode><EntryUser>郑泽强</EntryUser><EntryDate>2016-11-14</EntryDate><EntryTime>12:53:51</EntryTime><AuthUserCode>1475</AuthUserCode><AuthUser>周莲</AuthUser><AuthDate>2016-11-14</AuthDate><AuthTime>12:53:51</AuthTime><Notes></Notes><ImageFile></ImageFile><MainWarnDesc></MainWarnDesc><ResultMsgs><ResultMsg><LabNo>7000027229</LabNo><TestCode>4081</TestCode><TestName>弓形虫抗体</TestName><TestEngName>TO-lgM(ELISA)</TestEngName><Result>阴性(-)</Result><Units></Units><Notes></Notes><ResultFlag>N</ResultFlag><Ranges>阴性（-）</Ranges><Sequence>280</Sequence><MICFlag>N</MICFlag><MICName>弓形虫抗体</MICName><WarnDesc></WarnDesc><OrgResultMsgs></OrgResultMsgs></ResultMsg><ResultMsg><LabNo>7000027229</LabNo><TestCode>4072</TestCode><TestName>风疹病毒抗体</TestName><TestEngName>R-lgM(ELISA)</TestEngName><Result>阴性(-)</Result><Units></Units><Notes></Notes><ResultFlag>N</ResultFlag><Ranges>阴性（-）</Ranges><Sequence>290</Sequence><MICFlag>N</MICFlag><MICName>风疹病毒抗体</MICName><WarnDesc></WarnDesc><OrgResultMsgs></OrgResultMsgs></ResultMsg><ResultMsg><LabNo>7000027229</LabNo><TestCode>4016</TestCode><TestName>巨细胞病毒抗体</TestName><TestEngName>C -lgM(ELISA)</TestEngName><Result>阴性(-)</Result><Units></Units><Notes></Notes><ResultFlag>N</ResultFlag><Ranges>阴性（-）</Ranges><Sequence>300</Sequence><MICFlag>N</MICFlag><MICName>巨细胞病毒抗体</MICName><WarnDesc></WarnDesc><OrgResultMsgs></OrgResultMsgs></ResultMsg><ResultMsg><LabNo>7000027229</LabNo><TestCode>4053</TestCode><TestName>单纯疱疹病毒抗体Ⅰ型M</TestName><TestEngName>HSV-ⅠlgM(ELISA)</TestEngName><Result>阴性(-)</Result><Units></Units><Notes></Notes><ResultFlag>N</ResultFlag><Ranges>阴性（-）</Ranges><Sequence>310</Sequence><MICFlag>N</MICFlag><MICName>单纯疱疹病毒抗体Ⅰ型M</MICName><WarnDesc></WarnDesc><OrgResultMsgs></OrgResultMsgs></ResultMsg><ResultMsg><LabNo>7000027229</LabNo><TestCode>4055</TestCode><TestName>单纯疱疹病毒抗体Ⅱ型M</TestName><TestEngName>HSV-ⅡlgM(ELISA)</TestEngName><Result>阴性(-)</Result><Units></Units><Notes></Notes><ResultFlag>N</ResultFlag><Ranges>阴性（-）</Ranges><Sequence>320</Sequence><MICFlag>N</MICFlag><MICName>单纯疱疹病毒抗体Ⅱ型M</MICName><WarnDesc></WarnDesc><OrgResultMsgs></OrgResultMsgs></ResultMsg></ResultMsgs></ReportMsg></Request>"
    s RetXMLData= ##class(LIS.Util.COM.XML).FromXML(Input)
	s err="",RetVal=100,num=0
	while RetXMLData.Next() 
	{
		s objReportMsg=RetXMLData.Get(num)
		i '$l(objReportMsg) continue
		s num=num+1
	
		//标本信息
		s AddDate=objReportMsg.AddDate
		s Address=objReportMsg.Address
		s AddTime=objReportMsg.AddTime
		s AddType=objReportMsg.AddType
		//s AddUserDR=objReportMsg.AddUserDR  
		s AddUserCode=objReportMsg.AddUserCode
		s AddUserDR=""
		i $l(AddUserCode) d
		.s AddUserDR=##Class(HIS.DHCReceiveProcess).GetUserDR(AddUserCode,"",HospitalDR)
		s AdmDate=objReportMsg.AdmDate
		s AdmTime=objReportMsg.AdmTime
		s AdmissionType=objReportMsg.AdmissionType   ///I住院;O门诊;E急诊;P体检  入参代码
		s AdmissionTypeDR=""
		i $l(AdmissionType) s AdmissionTypeDR=##Class(HIS.DHCReceiveProcess).GetAdmissionTypeDR(AdmissionType)
		s AdmNo=objReportMsg.AdmNo
	    //转换年龄
		s Age=objReportMsg.Age
		s AgeUnitDR="",AgeCode="",AgeDesc=""
		i '$l(AgeCode),(Age["岁") s AgeCode="Y",AgeDesc=Age
		i '$l(AgeCode),(Age["月") s AgeCode="M",AgeDesc=Age
		i '$l(AgeCode),(Age["天") s AgeCode="D",AgeDesc=Age
		i '$l(AgeCode),(Age["时") s AgeCode="H",AgeDesc=Age
		i '$l(AgeCode),(Age["分") s AgeCode="H" s Age=1      //不满一小时处理成一小时
		s Age=+Age
		i Age=0 s Age=""
		i $l(AgeCode) s AgeUnitDR=##Class(HIS.DHCReceiveProcess).GetAgeUnitDR(AgeCode)
		s AgeDesc=objReportMsg.AgeDesc
		s ArriveDate=objReportMsg.ArriveDate
        s ArriveTime=objReportMsg.ArriveTime
		//s ArriveUserDR=objReportMsg.ArriveUserDR 
		s ArriveUserCode=objReportMsg.ArriveUserCode 
		s ArriveUserDR=""
		i $l(ArriveUserCode) d
		.s ArriveUserDR=##Class(HIS.DHCReceiveProcess).GetUserDR(ArriveUserCode,"",HospitalDR)
		s ArriveWorkGroupDR="" //objReportMsg.ArriveWorkGroupDR  
		s BedNo=objReportMsg.BedNo
		s BirthDate=objReportMsg.BirthDate
		i $l(BirthDate) s BirthDate=$tr(BirthDate,"-")
		s BirthDate=##Class(LIS.Service.ENS.SaveReport).TransDate(BirthDate)	
		s BirthTime=objReportMsg.BirthTime
		s BloodPressure=objReportMsg.BloodPressure
		s BodyTemp=objReportMsg.BodyTemp
		s CarryDate=objReportMsg.CarryDate
		s CarryTime=objReportMsg.CarryTime
		//s CarryUserDR=objReportMsg.CarryUserDR  
		s CarryUserCode=objReportMsg.CarryUserCode
		s CarryUserDR=""
		i $l(CarryUserCode) d
		.s CarryUserDR=##Class(HIS.DHCReceiveProcess).GetUserDR(CarryUserCode,"",HospitalDR)
		s CertNo=objReportMsg.CertNo
		s CertTypeDR="" //objReportMsg.CertTypeDR  
		s ChildbirthNum=objReportMsg.ChildbirthNum
		s ClinicalConditionsDR=objReportMsg.ClinicalConditionsDR
		s CollectDate=objReportMsg.CollectDate
		s CollectTime=objReportMsg.CollectTime
		s CollectUserCode=objReportMsg.CollectUserCode
		s CollectUserDR=""
		i $l(CollectUserCode) s CollectUserDR=##Class(HIS.DHCReceiveProcess).GetUserDR(CollectUserCode,CollectUser,HospitalDR)
		s CollectNotes=objReportMsg.CollectNotes
		s CollectPositon=objReportMsg.CollectPositon
		s Confidential=objReportMsg.Confidential
		s ConcessionFlag=objReportMsg.ConcessionFlag
		//标本容器
		s ContainerID=objReportMsg.ContainerID
		s (ContainerDR)=""
		i $l(ContainerID) s ContainerDR=$o(^dbo.BTContainerI("IndexCode",HospitalDR,##Class(LIS.Util.Common).IndexData(ContainerID),""))
		s CountryDR="" //objReportMsg.CountryDR 
		//转换医生DR
		s DoctorDR=""
		s drcode=objReportMsg.DoctorCode
		i $l(drcode) s DoctorDR=##Class(HIS.DHCReceiveProcess).GetDoctorDR(drcode,"",HospitalDR)
		s EMail=objReportMsg.EMail
		s ExtLabNo=objReportMsg.ExtLabNo
		s EthnicityDR="" //objReportMsg.EthnicityDR  
		s FeeSum=objReportMsg.FeeSum  
		s GivenName=objReportMsg.GivenName
		s H24UTimePeriod=objReportMsg.H24UTimePeriod
		s H24UVolume=objReportMsg.H24UVolume
		s Height=objReportMsg.Height
		s HospitalDR=HospitalDR 
		s ICDs=objReportMsg.ICDs
		s IDNumber=objReportMsg.IDNumber
		s InfectAlert=objReportMsg.InfectAlert
		s InfectFlag=objReportMsg.InfectFlag
		s InStorageDate=objReportMsg.InStorageDate
		s InStorageTime=objReportMsg.InStorageTime
		s InStorageUserDR=objReportMsg.InStorageUserDR
		s IsPrintBar=objReportMsg.IsPrintBar
		s LinkLabNo=objReportMsg.LinkLabNo
		s LMPDate=objReportMsg.LMPDate
	    //转换病人科室DR
		s LocationDR="",LocCode=objReportMsg.LocationCode,LocDesc=objReportMsg.LocationName
		i $l(LocCode) s LocationDR=##Class(HIS.DHCReceiveProcess).GetLocationDR(LocCode,LocCode,LocDesc,HospitalDR)
		s MedicalRecordNo=objReportMsg.MedicalRecordNo
		s MixLabNo=objReportMsg.MixLabNo
		s MobileNo=objReportMsg.MobileNo
		s OutStorageDate=objReportMsg.OutStorageDate
		s OutStorageTime=objReportMsg.OutStorageTime
		s OutStorageType=objReportMsg.OutStorageType
		//s OutStorageUserDR=objReportMsg.OutStorageUserDR 
		s OutStorageUserCode=objReportMsg.OutStorageUserCode
		s OutStorageUserDR=""
		i $l(OutStorageUserCode) d
		.s OutStorageUserDR=##Class(HIS.DHCReceiveProcess).GetUserDR(OutStorageUserCode,"",HospitalDR)
		s PaymentTypeDR="" //objReportMsg.PaymentTypeDR  
		s PhoneNo=objReportMsg.PhoneNo
		s PostCode=objReportMsg.PostCode
		s Pregnant=objReportMsg.Pregnant
		s PregnantNum=objReportMsg.PregnantNum
		s PregnantWeeks=objReportMsg.PregnantWeeks
		s ReceiveDate=objReportMsg.ReceiveDate
		//s ReceiveHospitalDR=objReportMsg.ReceiveHospitalDR  
		s ReceiveHospitalCode=objReportMsg.ReceiveHospitalCode
		s ReceiveHospitalDR=$o(^dbo.BTHospitalI("IndexCode",##Class(LIS.Util.Common).IndexData(ReceiveHospitalCode),""))
		s ReceiveNotes=objReportMsg.ReceiveNotes
		s ReceiveTime=objReportMsg.ReceiveTime
		//s ReceiveUserDR=objReportMsg.ReceiveUserDR 
		s ReceiveUserCode=objReportMsg.ReceiveUserCode
		s ReceiveUserDR=""
		i $l(ReceiveUserCode) d
		.s ReceiveUserDR=##Class(HIS.DHCReceiveProcess).GetUserDR(ReceiveUserCode,"",HospitalDR)
		s RegNo=objReportMsg.RegNo
		s ReqNotes=objReportMsg.ReqNotes
		s RequestDate=objReportMsg.RequestDate
		s RequestNo=objReportMsg.RequestNo
		s RequestTime=objReportMsg.RequestTime
		s RhDR="" //objReportMsg.RhDR  
		s RUDiseaseDR="" //objReportMsg.RUDiseaseDR  
		s SpecialFlag=objReportMsg.SpecialFlag
		s SexCode=objReportMsg.SexCode
		i SexCode[ "男" s SexCode="M"
		i SexCode[ "女" s SexCode="F"
	 	s SpeciesDR=""
		i $l(SexCode) s SpeciesDR=##Class(HIS.DHCReceiveProcess).GetSpeciesDR(SexCode)
		s SpecimenID=objReportMsg.SpecimenID,SpecimenDR=""
		i $l(SpecimenID) s SpecimenDR=$o(^dbo.BTSpecimenI("IndexCode",HospitalDR,##Class(LIS.Util.Common).IndexData(SpecimenID),""))
		//s SpecimenQualityDR=objReportMsg.SpecimenQualityDR  
		s SpecimenQualityCode=objReportMsg.SpecimenQualityCode
		s SpecimenQualityDR=""
		i $l(SpecimenQualityCode) s SpecimenQualityDR=$o(^dbo.BTSpecimenQualityI("IndexCode",##Class(LIS.Util.Common).IndexData(SpecimenQualityCode),""))
		s SurName=objReportMsg.SurName
		s Symptom=objReportMsg.Symptom
		s Urgent=objReportMsg.Urgent
		s VisitNumber=objReportMsg.VisitNumber
	    //转换病区DR
		s WardDR="",WardCode=objReportMsg.WardCode,WardName=objReportMsg.WardName
		i $l(WardCode) s WardDR=##Class(HIS.DHCReceiveProcess).GetWardDR(WardCode,WardCode,WardName,LocationDR)
		s Weight=objReportMsg.Weight
	   
	    //标本医嘱表信息
        s HISOrderID=objReportMsg.HISOrderID
        s Recieved=objReportMsg.Recieved
        s ReceivableFee=objReportMsg.ReceivableFee
		//外部代码   
		s TestSetCode=objReportMsg.TestSetID
		s TestSetDR=$o(^dbo.BTTestSetI("IndexCode",HospitalDR,##Class(LIS.Util.Common).IndexData(TestSetCode),"")) 
		i '$l(TestSetDR) s TestSetDR=$o(^dbo.BTTestSetI("IndexHISCode",HospitalDR,##Class(LIS.Util.Common).IndexData(TestSetCode),""))  //HIS对照码

		i '$l(TestSetDR) S err=TestSetCode_":未找到医嘱对照码！" q
		s TestSetFee=objReportMsg.TestSetFee
		s TSTransmitDate=objReportMsg.TSTransmitDate
		s TSAssayNo=objReportMsg.TSAssayNo
		s TSSequence=objReportMsg.TSSequence
		s DepartmentCode=objReportMsg.DepartmentCode
		s DepartmentDR=$o(^dbo.BTDepartmentI("IndexCode",HospitalDR,##Class(LIS.Util.Common).IndexData(DepartmentCode),"")) //Index IndexCode On (HospitalDR, Code) dbo.BTDepartment
		s WorkGroupCode=objReportMsg.WorkGroupCode  
		s WorkGroupMachineDR=""
		s WorkGroupMachineCode=objReportMsg.WorkGroupMachineCode 
		i $l(WorkGroupMachineCode) d
		.s WorkGroupDR=$o(^dbo.BTWorkGroupI("IndexCode",DepartmentDR,##Class(LIS.Util.Common).IndexData(WorkGroupCode),""))  //Index IndexCode On (DepartmentDR, Code)
		.s WorkGroupMachineDR=$o(^dbo.BTWorkGroupMachineI("IndexCode",WorkGroupDR,##Class(LIS.Util.Common).IndexData(WorkGroupMachineCode),"")) //  Index IndexCode On (WorkGroupDR, Code)
		
		//报告信息
		s AssayNo=objReportMsg.AssayNo
		s AccessionNo=objReportMsg.AccessionNo
		s AcceptDate=objReportMsg.AcceptDate
		s AcceptTime=objReportMsg.AcceptTime
		s AcceptUserCode=objReportMsg.AcceptUserCode
		s AcceptUserDR=""
		i $l(AcceptUserCode) s AcceptUserDR=##Class(HIS.DHCReceiveProcess).GetUserDR(AcceptUserCode,"",HospitalDR)
		s AssayDate=objReportMsg.AssayDate
		s AssayTime=objReportMsg.AssayTime
		s AutoAuth=objReportMsg.AutoAuth
		s AuthDate=objReportMsg.AuthDate
		s AuthTime=objReportMsg.AuthTime
		s AuthUserCode=objReportMsg.AuthUserCode
		s AuthUser=objReportMsg.AuthUser
		s AuthUserDR=""
		i $l(AuthUserCode) s AuthUserDR=##Class(HIS.DHCReceiveProcess).GetUserDR(AuthUserCode,AuthUser,HospitalDR)
		s AddType=objReportMsg.AddType
		s DigitSign=objReportMsg.DigitSign
		s DigitSignString=objReportMsg.DigitSignString
		s DigitSignTime=objReportMsg.DigitSignTime
		s DiscardDate=objReportMsg.DiscardDate
		s DiscardTime=objReportMsg.DiscardTime
		s DiscardUserCode=objReportMsg.DiscardUserCode  
		s DiscardUserDR=""
		i $l(DiscardUserCode) s DiscardUserDR=##Class(HIS.DHCReceiveProcess).GetUserDR(DiscardUserCode,"",HospitalDR)
		s DisCardNotes=objReportMsg.DisCardNotes
		s EpisodeNo=objReportMsg.EpisodeNo
		s EntryDate=objReportMsg.EntryDate
		s EntryTime=objReportMsg.EntryTime
		s EntryUserCode=objReportMsg.EntryUserCode
		s EntryUserDR=""
		i $l(EntryUserCode) s EntryUserDR=##Class(HIS.DHCReceiveProcess).GetUserDR(EntryUserCode,"",HospitalDR)
		s ExtraFinished=objReportMsg.ExtraFinished
		s FirstReadDate=objReportMsg.FirstReadDate
		s FirstReadTime=objReportMsg.FirstReadTime
		s FirstReadDoctorCode=objReportMsg.FirstReadDoctorCode 
		s FirstReadDoctorDR=""
		i $l(FirstReadDoctorCode) s FirstReadDoctorDR=##Class(HIS.DHCReceiveProcess).GetDoctorDR(FirstReadDoctorCode,"",HospitalDR)
		s IsPositive=objReportMsg.IsPositive
		s LastMachineLName=objReportMsg.LastMachineLName
		s MajorConclusion=objReportMsg.MajorConclusion
		s MinorConclusion=objReportMsg.MinorConclusion
		s OperateFlag=objReportMsg.OperateFlag
		s OrderNo=objReportMsg.OrderNo
		s Printed=objReportMsg.Printed
		s ReAuthDate=objReportMsg.ReAuthDate
		s ReAuthTime=objReportMsg.ReAuthTime
		s ReAuthUserCode=objReportMsg.ReAuthUserCode  
		s ReAuthUserDR=""
		i $l(ReAuthUserCode) s ReAuthUserDR=##Class(HIS.DHCReceiveProcess).GetUserDR(ReAuthUserCode,"",HospitalDR)
		s Readed=objReportMsg.Readed
		s ReportClass=objReportMsg.ReportClass
		s ReAssayNumber=objReportMsg.ReAssayNumber
		s ReportType=objReportMsg.ReportType
		s ReportRemark=objReportMsg.ReportRemark
		s ResultWarned=objReportMsg.ResultWarned
		s RackNo=objReportMsg.RackNo
		s Status=objReportMsg.Status
		s SplitStatus=objReportMsg.SplitStatus
		s TransmitDate=objReportMsg.TransmitDate
		s UploadDate=objReportMsg.UploadDate
		s UploadTime=objReportMsg.UploadTime
		s WorkGroupMachineDR=WorkGroupMachineDR		
		
		///保存标本信息
		s VisitNumberDR=""
		i $d(^dbo.RPVisitNumberI("IndexVisitNumber",##Class(LIS.Util.Common).IndexData(VisitNumber))) d
		.s VisitNumberDR=$o(^dbo.RPVisitNumberI("IndexVisitNumber",##Class(LIS.Util.Common).IndexData(VisitNumber),""))
		.s objVisitNumber=##class(dbo.RPVisitNumber).%OpenId(VisitNumberDR)
		e  d
		.s objVisitNumber=##class(dbo.RPVisitNumber).%New()
		s objVisitNumber.AboDR="" //AboDR
		s objVisitNumber.AddDate=AddDate
		s objVisitNumber.Address=Address
		s objVisitNumber.AddTime=AddTime
		s objVisitNumber.AddType=AddType
		s objVisitNumber.AddUserDR=AddUserDR
		s objVisitNumber.AdmDate=AdmDate
		s objVisitNumber.AdmissionTypeDR=AdmissionTypeDR
		s objVisitNumber.AdmNo=AdmNo
		s objVisitNumber.AdmTime=AdmTime
		s objVisitNumber.Age=Age
		s objVisitNumber.AgeDesc=AgeDesc
		s objVisitNumber.AgeUnitDR=AgeUnitDR
		s objVisitNumber.AnatomicalSiteDR="" //AnatomicalSiteDR
		s objVisitNumber.ArriveDate=ArriveDate
		s objVisitNumber.ArriveTime=ArriveTime
		s objVisitNumber.ArriveUserDR=ArriveUserDR
		s objVisitNumber.ArriveWorkGroupDR=ArriveWorkGroupDR
		s objVisitNumber.BedNo=BedNo
		s objVisitNumber.BirthDate=BirthDate
		s objVisitNumber.BirthTime=BirthTime
		s objVisitNumber.BloodPressure=BloodPressure
		s objVisitNumber.BodyTemp=BodyTemp
		s objVisitNumber.CarryDate=CarryDate
		s objVisitNumber.CarryTime=CarryTime
		s objVisitNumber.CarryUserDR=CarryUserDR
		s objVisitNumber.CertNo=CertNo
		s objVisitNumber.CertTypeDR=CertTypeDR
		s objVisitNumber.ChildbirthNum=ChildbirthNum
		s objVisitNumber.ClinicalConditionsDR=ClinicalConditionsDR
		s objVisitNumber.CollectDate=CollectDate
		s objVisitNumber.CollectNotes=CollectNotes
		s objVisitNumber.CollectPositon=CollectPositon
		s objVisitNumber.CollectTime=CollectTime
		s objVisitNumber.CollectUserDR=CollectUserDR
		s objVisitNumber.Confidential=Confidential
		s objVisitNumber.ConcessionFlag=ConcessionFlag
		s objVisitNumber.ContainerDR=ContainerDR
		s objVisitNumber.CountryDR=CountryDR
		s objVisitNumber.DoctorDR=DoctorDR
		s objVisitNumber.EMail=EMail
		s objVisitNumber.ExtLabNo=ExtLabNo
		s objVisitNumber.EthnicityDR=EthnicityDR
		s objVisitNumber.FeeSum=FeeSum
		s objVisitNumber.GivenName=GivenName
		s objVisitNumber.H24UTimePeriod=H24UTimePeriod
		s objVisitNumber.H24UVolume=H24UVolume
		s objVisitNumber.Height=Height
		s objVisitNumber.HospitalDR=HospitalDR
		s objVisitNumber.ICDs=ICDs
		s objVisitNumber.IDNumber=IDNumber
		s objVisitNumber.InfectAlert=InfectAlert
		s objVisitNumber.InfectFlag=InfectFlag
		s objVisitNumber.InStorageDate=InStorageDate
		s objVisitNumber.InStorageTime=InStorageTime
		s objVisitNumber.InStorageUserDR=InStorageUserDR
		s objVisitNumber.IsPrintBar=IsPrintBar
		s objVisitNumber.LinkLabNo=LinkLabNo
		s objVisitNumber.LMPDate=LMPDate
		s objVisitNumber.LocationDR=LocationDR
		s objVisitNumber.MedicalRecordNo=MedicalRecordNo
		s objVisitNumber.MixLabNo=MixLabNo
		s objVisitNumber.MobileNo=MobileNo
		s objVisitNumber.OutStorageDate=OutStorageDate
		s objVisitNumber.OutStorageTime=OutStorageTime
		s objVisitNumber.OutStorageType=OutStorageType
		s objVisitNumber.OutStorageUserDR=OutStorageUserDR
		s objVisitNumber.PaymentTypeDR=PaymentTypeDR
		s objVisitNumber.PhoneNo=PhoneNo
		s objVisitNumber.PostCode=PostCode
		s objVisitNumber.Pregnant=Pregnant
		s objVisitNumber.PregnantNum=PregnantNum
		s objVisitNumber.PregnantWeeks=PregnantWeeks
		s objVisitNumber.ReceiveDate=ReceiveDate
		s objVisitNumber.ReceiveHospitalDR=ReceiveHospitalDR
		s objVisitNumber.ReceiveNotes=ReceiveNotes
		s objVisitNumber.ReceiveTime=ReceiveTime
		s objVisitNumber.ReceiveUserDR=ReceiveUserDR
		s objVisitNumber.RegNo=RegNo
		s objVisitNumber.ReqNotes=ReqNotes
		s objVisitNumber.RequestDate=RequestDate
		s objVisitNumber.RequestNo=RequestNo
		s objVisitNumber.RequestTime=RequestTime
		s objVisitNumber.RhDR=RhDR
		s objVisitNumber.RUDiseaseDR=RUDiseaseDR
		s objVisitNumber.SpecialFlag=SpecialFlag
		s objVisitNumber.SpeciesDR=SpeciesDR
		s objVisitNumber.SpecimenDR=SpecimenDR
		s objVisitNumber.SpecimenQualityDR=SpecimenQualityDR
		s objVisitNumber.SurName=SurName
		s objVisitNumber.Symptom=Symptom
		s objVisitNumber.Urgent=Urgent
		s objVisitNumber.VisitNumber=VisitNumber
		s objVisitNumber.WardDR=WardDR
		s objVisitNumber.Weight=Weight
	    s sc=objVisitNumber.%Save()
		If ($SYSTEM.Status.IsOK(sc)) {
			s RetValue=1
			s VisitNumberDR=objVisitNumber.RowID
		}
		Else {
			s err="-1^标本信息保存失败:"_$SYSTEM.Status.GetErrorText(sc)  q
		}
			
		//保存医嘱
		s VisitNumberTestSetDRs=""
	    s TestSetMsgsLen=objReportMsg.TestSetMsgs.Length()
		f j=0:1:(TestSetMsgsLen-1)
		{
			s objTestSetMsg=objReportMsg.TestSetMsgs.Get(j)
			i '$l(objTestSetMsg) continue
			s TSAssayNo=objTestSetMsg.AssayNo 
			s TSHISOrderID=objTestSetMsg.HISOrderID 
			s TSRecieved=objTestSetMsg.Recieved 
			s TSReceivableFee=objTestSetMsg.ReceivableFee 
			s TSTestSetCode=objTestSetMsg.TestSetCode 
			s TSTestSetDR=$o(^dbo.BTTestSetI("IndexCode",HospitalDR,##Class(LIS.Util.Common).IndexData(TSTestSetCode),"")) 
			i '$l(TSTestSetDR) continue
			s TSTestSetFee=objTestSetMsg.TestSetFee 
			s TSTransmitDate=objTestSetMsg.TransmitDate 
			//s TSVisitNumberDR=objTestSetMsg.VisitNumberDR
			//s TSWorkGroupMachineCode=objTestSetMsg.WorkGroupMachineCode 
			s DepartmentCode=objTestSetMsg.DepartmentCode
			s DepartmentDR=$o(^dbo.BTDepartmentI("IndexCode",HospitalDR,##Class(LIS.Util.Common).IndexData(DepartmentCode),"")) //Index IndexCode On (HospitalDR, Code) dbo.BTDepartment
			s WorkGroupCode=objTestSetMsg.WorkGroupCode  
			s WorkGroupMachineCode=objTestSetMsg.WorkGroupMachineCode 
			s TSWorkGroupMachineDR=""
			i $l(WorkGroupMachineCode) d
			.s WorkGroupDR=$o(^dbo.BTWorkGroupI("IndexCode",DepartmentDR,##Class(LIS.Util.Common).IndexData(WorkGroupCode),""))  //Index IndexCode On (DepartmentDR, Code)		
			.s TSWorkGroupMachineDR=$o(^dbo.BTWorkGroupMachineI("IndexCode",WorkGroupDR,##Class(LIS.Util.Common).IndexData(WorkGroupMachineCode),"")) //  Index IndexCode On (WorkGroupDR, Code)	
	        s TSSequence=objTestSetMsg.Sequence 
	        s VisitNumberTestSetDR=""
			s RowID=$o(^dbo.RPVisitNumberTestSetI("IndexMaster",VisitNumberDR,TSTestSetDR,""))
			i $l(RowID) d
			.s objTestSets=##class(dbo.RPVisitNumberTestSet).%OpenId(RowID)
			e  d
    		.s objTestSets=##class(dbo.RPVisitNumberTestSet).%New()
    		s objTestSets.AssayNo=TSAssayNo
    		s objTestSets.HISOrderID=TSHISOrderID
    		s objTestSets.Recieved=TSRecieved
    		s objTestSets.ReceivableFee=TSReceivableFee
    		s objTestSets.TestSetDR=TSTestSetDR
    		s objTestSets.TestSetFee=TSTestSetFee
    		s objTestSets.TransmitDate=TSTransmitDate
    		s objTestSets.Sequence=TSSequence
    		s objTestSets.VisitNumberDR=VisitNumberDR
    		s objTestSets.WorkGroupMachineDR=TSWorkGroupMachineDR
			s scTS=objTestSets.%Save()
			i ($SYSTEM.Status.IsOK(scTS)) d
			.//医嘱执行
			.i $l(VisitNumberTestSetDRs) s VisitNumberTestSetDRs=VisitNumberTestSetDRs_","_objTestSets.RowID
			.e  s VisitNumberTestSetDRs=objTestSets.RowID
			e  d 
			.s err=$SYSTEM.Status.GetErrorText(scTS) Quit 
			i $l(err) q 
	    }
	    
	    i '$l(WorkGroupMachineDR) q  //没有核收的直接退出
	   
		//保存报告信息
		i $d(^dbo.RPVisitNumberReportI("IndexReportID",VisitNumberDR,WorkGroupMachineDR)) d
    	.s fOrderNo=$O(^dbo.RPVisitNumberReportI("IndexReportID",VisitNumberDR,WorkGroupMachineDR,""),-1) 
    	.s VisitNumberReportDR=$O(^dbo.RPVisitNumberReportI("IndexReportID",VisitNumberDR,WorkGroupMachineDR,fOrderNo,""))
		.s objVisitNumberReport=##class(dbo.RPVisitNumberReport).%OpenId(VisitNumberReportDR)
		e  d
		.s objVisitNumberReport=##class(dbo.RPVisitNumberReport).%New()
		s objVisitNumberReport.AssayNo=AssayNo
		s objVisitNumberReport.AccessionNo=AccessionNo
		s objVisitNumberReport.AcceptDate=AcceptDate
		s objVisitNumberReport.AcceptTime=AcceptTime
		s objVisitNumberReport.AcceptUserDR=AcceptUserDR 
		s objVisitNumberReport.AssayDate=AssayDate
		s objVisitNumberReport.AssayTime=AssayTime
		s objVisitNumberReport.AutoAuth=AutoAuth
		s objVisitNumberReport.AuthDate=AuthDate
		s objVisitNumberReport.AuthTime=AuthTime
		s objVisitNumberReport.AuthUserDR=AuthUserDR
		s objVisitNumberReport.AddType=AddType
		s objVisitNumberReport.DigitSign=DigitSign
		s objVisitNumberReport.DigitSignString=DigitSignString
		s objVisitNumberReport.DigitSignTime=DigitSignTime
		s objVisitNumberReport.DiscardDate=DiscardDate
		s objVisitNumberReport.DiscardTime=DiscardTime
		s objVisitNumberReport.DiscardUserDR=DiscardUserDR  
		s objVisitNumberReport.DisCardNotes=DisCardNotes
		s objVisitNumberReport.EpisodeNo=EpisodeNo
		s objVisitNumberReport.EntryDate=EntryDate
		s objVisitNumberReport.EntryTime=EntryTime
		s objVisitNumberReport.EntryUserDR=EntryUserDR
		s objVisitNumberReport.ExtraFinished=ExtraFinished
		s objVisitNumberReport.FirstReadDate=FirstReadDate
		s objVisitNumberReport.FirstReadTime=FirstReadTime
		s objVisitNumberReport.FirstReadDoctorDR=FirstReadDoctorDR  
		s objVisitNumberReport.IsPositive=IsPositive
		s objVisitNumberReport.LastMachineLName=LastMachineLName
		s objVisitNumberReport.MajorConclusion=MajorConclusion
		s objVisitNumberReport.MinorConclusion=MinorConclusion
		s objVisitNumberReport.OperateFlag=OperateFlag
		s objVisitNumberReport.OrderNo=OrderNo
		s objVisitNumberReport.Printed=Printed
		s objVisitNumberReport.ReAuthDate=ReAuthDate
		s objVisitNumberReport.ReAuthTime=ReAuthTime
		s objVisitNumberReport.ReAuthUserDR=ReAuthUserDR  
		s objVisitNumberReport.Readed=Readed
		s objVisitNumberReport.ReportClass=ReportClass
		s objVisitNumberReport.ReAssayNumber=ReAssayNumber
		s objVisitNumberReport.ReportType=ReportType
		s objVisitNumberReport.ReportRemark=ReportRemark
		s objVisitNumberReport.ResultWarned=ResultWarned
		s objVisitNumberReport.RackNo=RackNo
		s objVisitNumberReport.Status=Status
		s objVisitNumberReport.SplitStatus=SplitStatus
		s objVisitNumberReport.TransmitDate=TransmitDate
		s objVisitNumberReport.UploadDate=UploadDate
		s objVisitNumberReport.UploadTime=UploadTime
		s objVisitNumberReport.VisitNumberDR=VisitNumberDR
		s objVisitNumberReport.WorkGroupMachineDR=WorkGroupMachineDR
		s ret=objVisitNumberReport.%Save()
		s err=""
		If ($SYSTEM.Status.IsOK(ret)) d
		.s VisitNumberReportDR=objVisitNumberReport.RowID
		.s RetValue=1
		Else  d
		.s err="标本信息核收失败:"_$SYSTEM.Status.GetErrorText(ret) Quit
	
		i $l(err) q 
        
        //修改标本医嘱表报告主键
        s len=$l(VisitNumberTestSetDRs,",")
   		f j=1:1:len d 
  	    .s VisitNumberTestSetDR=$p(VisitNumberTestSetDRs,",",j)
   		.s objVNTestSet=##class(dbo.RPVisitNumberTestSet).%OpenId(VisitNumberTestSetDR)
        .s objVNTestSet.VisitNumberReportDR=VisitNumberReportDR
        .s scTS=objVNTestSet.%Save()
        .If ('$SYSTEM.Status.IsOK(scTS)) s err="标本医嘱关联报告主键失败:"_$SYSTEM.Status.GetErrorText(scTS) Quit
           	    
		///保存普通结果信息
		s dlt1="^^",dlt2="@@"
		s ReportResultList="",OrgResultMsg=""
	    i $l(objReportMsg.ResultMsgs)  s ResultMsgsLen=objReportMsg.ResultMsgs.Length()
	    e  s ResultMsgsLen=0 
		f j=0:1:(ResultMsgsLen-1)
		{
			s objResultMsg=objReportMsg.ResultMsgs.Get(j)
			i '$l(objResultMsg) continue
			s LISCode=objResultMsg.TestCode 
			i '$l(LISCode) Set err="-1^LISCode:OT"_LISCode_"没对照码" Quit
			s TestCodeDR=$o(^dbo.BTTestCodeI("IndexCode",HospitalDR,##Class(LIS.Util.Common).IndexData(LISCode),""))   //默认取检验已经存在的代码
			i '$l(TestCodeDR) continue
			s Result=objResultMsg.Result
			s TextRes=objResultMsg.TextRes
   			s TCUnit=objResultMsg.Units
    		s ResNoes=objResultMsg.Notes
    		s AbFlag=objResultMsg.ResultFlag
			s RefRanges=objResultMsg.Ranges
			s Sequence=objResultMsg.Sequence
			///细菌结果处理
			s MICFlag=objResultMsg.MICFlag
			s MICName=objResultMsg.MICName
			i (MICFlag="Y"),$l(Result),$l(MICName)
			{
				s BugCode=Result
				s OrganismDR=$o(^dbo.BTOrganismI("IndexCode",##Class(LIS.Util.Common).IndexData(BugCode),""))
                i '$l(OrganismDR) continue
				///细菌结果转换				
				s Result=OrganismDR
				s TextRes=MICName
				///抗生素结果
				s OrgResultMsgsLen=objResultMsg.OrgResultMsgs.Length()
				f k=1:1:OrgResultMsgsLen
				{
					s objOrgResultMsgs=objResultMsg.OrgResultMsgs.Get(k)
					s OrgResultMsg=OrgResultMsg_$c(28)_TestCodeDR_$c(2)_objOrgResultMsgs.AntiCode
					s OrgResultMsg=OrgResultMsg_$c(2)_objOrgResultMsgs.AntiName_$c(2)_objOrgResultMsgs.AntiEngName
					s OrgResultMsg=OrgResultMsg_$c(2)_objOrgResultMsgs.MICRes_$c(2)_objOrgResultMsgs.KBRes
					s OrgResultMsg=OrgResultMsg_$c(2)_objOrgResultMsgs.Result_$c(2)_objOrgResultMsgs.MICRanges
					s OrgResultMsg=OrgResultMsg_$c(2)_objOrgResultMsgs.KBRanges_$c(2)_objOrgResultMsgs.Order
				}
			}			
			
			s ReportResultList=ReportResultList_TestCodeDR_dlt1  //1
			s ReportResultList=ReportResultList_Result_dlt1		//2
			s ReportResultList=ReportResultList_TextRes_dlt1		//3
			s ReportResultList=ReportResultList_dlt1		//4 ExtraRes
			s ReportResultList=ReportResultList_dlt1		//5 OtherRes
			s ReportResultList=ReportResultList_ResNoes_dlt1 //6 ResNoes
			s ReportResultList=ReportResultList_AbFlag_dlt1 //7 AbFlag
			s ReportResultList=ReportResultList_dlt1		//8 ResClass
			s ReportResultList=ReportResultList_TCUnit_dlt1		//9 Unit
			s ReportResultList=ReportResultList_RefRanges_dlt1  //10 RefRanges
			s ReportResultList=ReportResultList_dlt1		//11 MethodDR
			s ReportResultList=ReportResultList_dlt1		//12 MachineParameterDR
			s ReportResultList=ReportResultList_dlt1		//13 OperateUserDR
			s ReportResultList=ReportResultList_dlt1		//14 AssayDate
			s ReportResultList=ReportResultList_dlt1		//15 AssayTime
			s ReportResultList=ReportResultList_Sequence_dlt1 //16 Sequence
			s ReportResultList=ReportResultList_dlt1		//17 AssayStatus
			s ReportResultList=ReportResultList_dlt1		//18 ReAssayNum
			s ReportResultList=ReportResultList_dlt1		//19 ExpertRule
			s ReportResultList=ReportResultList_RegNo_dlt1		//20 RegNo
			s ReportResultList=ReportResultList_AdmNo_dlt1		//21 AdmNo
			s ReportResultList=ReportResultList_AuthDate_dlt1		//22 AuthDate
			s ReportResultList=ReportResultList_AuthTime_dlt1		//23 AuthTime
			s ReportResultList=ReportResultList_dlt1		//24 ReAssayNumber
			s ReportResultList=ReportResultList_VisitNumberReportDR_dlt1 //25 VisitNumberReportDR
			s ReportResultList=ReportResultList_dlt2
		}
	}
	i $l(err) q err	
	i '$l(WorkGroupMachineDR) q 0     //没有核收的直接退出
	//i '$l(ReportResultList) Set RetVal="-1^结果信息为空" Quit RetVal
	
	///保存报告信息
	//s Sessions=AuthUserDR
	//s RetValue=##Class(LISSP.BLL.DHCRPVisitNumberReportResult).SaveVisitNumberReport(VisitNumberReportDR,ReportList,Sessions,"U")
    //i RetValue'=1 TROLLBACK  Quit RetValue_"^SaveVisitNumberReport"
	///保存结果信息
	s UserID=AuthUserDR
	i $l(ReportResultList) s RetValue=##Class(LISSP.BLL.DHCRPVisitNumberReportResult).SaveResult(VisitNumberReportDR,ReportResultList,UserID,"U")
    ;i RetValue'=1 TROLLBACK  Quit RetValue_"^SaveResult"
    i RetValue'=1  Quit RetValue_"^SaveResult"
    ///保存微生物结果
    i $l(OrgResultMsg) s RetValue=..SaveAntResult(VisitNumberReportDR,OrgResultMsg)
    ;i RetValue'=1 TROLLBACK  Quit RetValue_"^dbo.RPVisitNumberReportResSen"
    i RetValue'=1  Quit RetValue_"^dbo.RPVisitNumberReportResSen"
    
	;TCOMMIT
	//保存LIS结果成功
	q 0
	
ErrorHandle
	;TROLLBACK
	s RetValue="-1^错误"_$tr($ZERROR,"^","--")_".错误代码:"_$ECODE
    Quit RetValue
}

/// 保存微生物结果
/// 药敏结果OrgResultMsg:序号,TestCodeDR,抗生素代码,抗生素名称,抗生素缩写,MIC结果,KB结果,药敏结果 
ClassMethod SaveAntResult(VisitNumberReportDR As %String, OrgResultMsg As %String) As %String
{
	s VisitNumberReportDR=$g(VisitNumberReportDR),OrgResultMsg=$g(OrgResultMsg)
	s err=""
	f ik=1:1:$l(OrgResultMsg,$c(28)) 
	{
		s AntList=$p(OrgResultMsg,$c(28),ik)
		i $l(AntList)
		{
			s TestCodeDR=$p(AntList,$c(2),1)
			s VisitNumberReportResultDR=$o(^dbo.RPVisitNumberReportResultI("IndexReportItem",VisitNumberReportDR, TestCodeDR,""))
			i '$l(VisitNumberReportResultDR) s err="-1^医嘱项目查询失败" q
			
			s AntiCode=$p(AntList,$c(2),2)
			s AntiName=$p(AntList,$c(2),3)
			s AntiEngName=$p(AntList,$c(2),4)
			s MICRes=$p(AntList,$c(2),5)
			s KBRes=$p(AntList,$c(2),6)
			s Result=$p(AntList,$c(2),7)
			s MICRanges=$p(AntList,$c(2),8)
			s KBRanges=$p(AntList,$c(2),9)
			s Order=+$p(AntList,$c(2),10)
			i Order=0 s Order=999+ik
			///抗生素
			;s AntiCode=$ZCVT(AntiCode,"U")
			s AntibioticsDR=$o(^dbo.BTAntibioticsI("IndexCode",##Class(LIS.Util.Common).IndexData(AntiCode),""))
			i '$l(AntibioticsDR)
			{
				s objAnt=##Class(dbo.BTAntibiotics).%New()
				s objAnt.Code=AntiCode
				s objAnt.CName=AntiName
				s objAnt.EName=AntiEngName
				s objAnt.SName=AntiCode
				s objAnt.WCode=AntiCode
				s objAnt.Active=1
				s objAnt.Sequence=9999
				s sc2=objAnt.%Save()
				If '($SYSTEM.Status.IsOK(sc2)) s err="-1"_AntiCode_"插入失败:"_$SYSTEM.Status.GetErrorText(sc2) Quit
				s AntibioticsDR=objAnt.RowID
			}
			///药敏结果
			s SenRes=""
			i Result["中介" s SenRes="I"
			i Result["敏感" s SenRes="S"
			i Result["耐药" s SenRes="R"
			i Result["SDD" s SenRes="SDD"
			i Result="I" s SenRes="I"
			i Result="S" s SenRes="S"
			i Result="R" s SenRes="R"
			i Result="SDD" s SenRes="SDD"
			s SenDR=$o(^dbo.BTSensitivityI("IndexCode",##Class(LIS.Util.Common).IndexData(SenRes),""))
			s VisRepResSenDR=$o(^dbo.RPVisitNumberReportResSenI("IndexAntibiocs",VisitNumberReportResultDR, AntibioticsDR,""))
			i $l(VisRepResSenDR)
			{
				s objAntRes=##class(dbo.RPVisitNumberReportResSen).%OpenId(VisRepResSenDR)
			}
			else
			{
				s objAntRes=##class(dbo.RPVisitNumberReportResSen).%New()
			}
			s objAntRes.VisitNumberReportResultDR=VisitNumberReportResultDR
			s objAntRes.AntibioticsDR=AntibioticsDR
			i $l(KBRes) {
				s objAntRes.SenMethod=1
				s objAntRes.SenValue=KBRes
			}
			i $l(MICRes) {
				s objAntRes.SenMethod=2
				s objAntRes.SenValue=MICRes
			}
			s objAntRes.SensitivityDR=SenDR
			s objAntRes.IRanges=KBRanges
			s objAntRes.SRanges=MICRanges
			s objAntRes.RRanges=""
			s objAntRes.Sequence=Order
			;s objAntRes.AntibioticsClassDR=""
			s sc2=objAntRes.%Save()
			If '($SYSTEM.Status.IsOK(sc2)) s err="-1^dbo.RPVisitNumberReportResSen微生物结果保存失败:"_$SYSTEM.Status.GetErrorText(sc2) Quit
		}
	}
	i $l(err) q err
	q 1
}

/// 流水号同步
/// w ##class(ES.LIS.DHCTransferEmergentData).EpisNoSyncTaskMTHD("","","","","","","","","","","","","","","113^7^0^12^1")
ClassMethod EpisNoSyncTaskMTHD(DirectionFlag, WorkGroupCode, HospitalCode, P3, P4, P5, P6, P7, P8, P9, P10, P11, P12, P13, Sessions, Output RowCount As %String) As %String
{
	s ret=0
	s DirectionFlag=$g(DirectionFlag),WorkGroupCode=$g(WorkGroupCode),HospitalCode=$g(HospitalCode)
	s AddDate= $zd($h,8)
	s fWorkGroupDR="" f  s fWorkGroupDR=$o(^dbo.BTWorkGroupI("PKBTWORKGROUP",fWorkGroupDR)) q:fWorkGroupDR=""  d
	.s fWorkGroupCode=$lg($g(^dbo.BTWorkGroupD(fWorkGroupDR)),2)
	.q:((","_WorkGroupCode_",")'[(","_fWorkGroupCode_","))
	.s ret=##class(ES.LIS.DHCTransferEmergentData).EpisNoSyncMTHD(DirectionFlag,fWorkGroupDR,AddDate,"","","","","","","","","","","","")
    q ret
}

/// 流水号同步
/// w ##class(ES.LIS.DHCTransferEmergentData).EpisNoSyncMTHD("2","3","20220713","","","","","","","","","","","","113^7^0^12^1")
ClassMethod EpisNoSyncMTHD(DirectionFlag, WorkGroupDR, AddDate, P3, P4, P5, P6, P7, P8, P9, P10, P11, P12, P13, Sessions, Output RowCount As %String) As %String
{
	s ^MMP("EpisNoSyncMTHD")=$lb(DirectionFlag, WorkGroupDR, AddDate, P3, P4, P5, P6, P7, P8, P9, P10, P11, P12, P13, Sessions)
	s DirectionFlag=$g(DirectionFlag)  //1：表示应急库到正式库 2；表示正式库到应急库
	s AddDate=$g(AddDate)
	s WorkGroupDR=$g(WorkGroupDR)
	s Sessions=$g(Sessions)
	i $l(AddDate) s AddDate=$tr(AddDate,"-")
    s ret=0
    
    s Address=""
    i DirectionFlag="1" d
    .s paramDR = $o(^dbo.SYSParameterI("IndexCode"," PROSYNCADDRESS", " SYS"," DHCC",""))
	.i $l(paramDR) s Address = $lg(^dbo.SYSParameterD(paramDR),6)
	e  i DirectionFlag="2" d
	.s paramDR = $o(^dbo.SYSParameterI("IndexCode"," EMESYNCADDRESS", " SYS"," DHCC",""))
	.i $l(paramDR) s Address = $lg(^dbo.SYSParameterD(paramDR),6)
	
    i '$l(Address)  q "-1^系统参数表未维护待同步库的WebService地址"
    //Index IndexMaster On (WorkGroupMachineDR, AddDate)  dbo.RPWorkGroupMachineEpis
    s TransferFlag=0
    s RetXML=##class(LIS.Util.COM.XML).New("Request")
	s objWGMEpiss=##class(LIS.Util.COM.XML).New("WGMEpiss")
	s fWorkGroupMachineCode=""
	f  s fWorkGroupMachineCode=$o(^dbo.BTWorkGroupMachineI("IndexCode",WorkGroupDR,fWorkGroupMachineCode)) q:fWorkGroupMachineCode=""  d
	.s fWorkGroupMachineDR=$o(^dbo.BTWorkGroupMachineI("IndexCode",WorkGroupDR,fWorkGroupMachineCode,""))
	.s fWGMEpisDR="" f  s fWGMEpisDR=$o(^dbo.RPWorkGroupMachineEpisI("IndexMaster",fWorkGroupMachineDR,AddDate,fWGMEpisDR)) q:fWGMEpisDR=""  d
	..s WGMEpisData=$g(^dbo.RPWorkGroupMachineEpisD(fWGMEpisDR))
    ..s objWGMEpis=##class(LIS.Util.COM.XML).New("WGMEpis")
    ..//s objWGMEpis.WGMaDR=$lg(WGMEpisData,2)
    ..s WGMDR=$lg(WGMEpisData,2)
    ..s WGMData=$g(^dbo.BTWorkGroupMachineD(WGMDR))
    ..s WGMCode=$lg(WGMData,2)
    ..s WGData=$g(^dbo.BTWorkGroupD(WorkGroupDR))
    ..s WGCode=$lg(WGData,2)
    ..s DeptDR=$lg(WGData,4)
    ..s DeptData=$g(^dbo.BTDepartmentD(DeptDR))
    ..s DeptCode=$lg(DeptData,2)
    ..s HospDR=$lg(DeptData,4)
    ..s HospData=$g(^dbo.BTHospitalD(HospDR))
    ..s HospCode=$lg(HospData,2)
    ..s objWGMEpis.HospCode=HospCode
    ..s objWGMEpis.DeptCode=DeptCode
    ..s objWGMEpis.WGCode=WGCode
    ..s objWGMEpis.WGMCode=WGMCode
    ..s objWGMEpis.AddDate=$lg(WGMEpisData,3)
    ..s objWGMEpis.EpisNo=$lg(WGMEpisData,4)
    ..d objWGMEpiss.Insert(objWGMEpis) 
    ..s TransferFlag=1
    d RetXML.Insert(objWGMEpiss)
    s Input=RetXML.ToXMLStream()
    s strInput=Input.Read()
    i TransferFlag=1 d
    .s ret=##class(LIS.WS.DHCLISServiceBase).RemoteGetData(Address,"ES.LIS.DHCTransferEmergentData","TransferWGMEpisMTHD",strInput,"", "", "", "", "", "", "", "", "", "", "", "", "", Sessions,"")
	//s ret=##Class(ES.LIS.DHCTransferEmergentData).TransferWGMEpisData(strInput)
	
	//Index IndexMaster On (NumType, NumNode)  dbo.SYSRecordNumber
	s TransferFlag=0
	s RetXML=##class(LIS.Util.COM.XML).New("Request")
	s objRecordNums=##class(LIS.Util.COM.XML).New("RecordNums")
	s fWorkGroupMachineCode=""
	f  s fWorkGroupMachineCode=$o(^dbo.BTWorkGroupMachineI("IndexCode",WorkGroupDR,fWorkGroupMachineCode)) q:fWorkGroupMachineCode=""  d
	.s fWorkGroupMachineDR=$o(^dbo.BTWorkGroupMachineI("IndexCode",WorkGroupDR,fWorkGroupMachineCode,""))
	.s WGMCode=$lg($g(^dbo.BTWorkGroupMachineD(fWorkGroupMachineDR)),2)
    .s WGMCode=##Class(OTH.SYSParameter).UPPER(WGMCode)
    .s WGMCode=$tr(WGMCode," ")
    .s RecordNumberDR=$O(^dbo.SYSRecordNumberI("IndexMaster",##Class(LIS.Util.Common).IndexData("MIC"),##Class(LIS.Util.Common).IndexData(WGMCode),""))
    .i '$l(RecordNumberDR) q
    .s RecordNumberData=$g(^dbo.SYSRecordNumberD(RecordNumberDR)) 
    .s objRecordNum=##class(LIS.Util.COM.XML).New("RecordNum")
    .s objRecordNum.NumType=$lg(RecordNumberData,2)
    .s objRecordNum.NumNode=$lg(RecordNumberData,3)
    .s objRecordNum.MaxNum=$lg(RecordNumberData,6)
    .d objRecordNums.Insert(objRecordNum) 
    .s TransferFlag=1
    d RetXML.Insert(objRecordNums)
    s Input=RetXML.ToXMLStream()
    s strInput=Input.Read()
    i TransferFlag=1 d
    .s ret=##class(LIS.WS.DHCLISServiceBase).RemoteGetData(Address,"ES.LIS.DHCTransferEmergentData","TransferRecordNumMTHD",strInput,"", "", "", "", "", "", "", "", "", "", "", "", "", Sessions,"")
	.//s ret=##Class(ES.LIS.DHCTransferEmergentData).TransferRecordNumData(Input)
	
	//.s RecordNumberDR=$O(^dbo.SYSRecordNumberI("IndexMaster",##Class(LIS.Util.Common).IndexData("SYS"),##Class(LIS.Util.Common).IndexData(WGMCode),""))
	//Index IndexMaster On (NumType, NumNode)  dbo.SYSRecordNumber
	s TransferFlag=0
	s RetXML=##class(LIS.Util.COM.XML).New("Request")
	s objRuleNoBases=##class(LIS.Util.COM.XML).New("RuleNoBases")
	s fWorkGroupMachineCode=""
	f  s fWorkGroupMachineCode=$o(^dbo.BTWorkGroupMachineI("IndexCode",WorkGroupDR,fWorkGroupMachineCode)) q:fWorkGroupMachineCode=""  d
	.s fWorkGroupMachineDR=$o(^dbo.BTWorkGroupMachineI("IndexCode",WorkGroupDR,fWorkGroupMachineCode,""))
	.s WGMCode=$lg($g(^dbo.BTWorkGroupMachineD(fWorkGroupMachineDR)),2)
    .s WGMCode=##Class(OTH.SYSParameter).UPPER(WGMCode)
    .s WGMCode=$tr(WGMCode," ")
    .s fRecordNumberDR=$O(^dbo.SYSRecordNumberI("IndexMaster",##Class(LIS.Util.Common).IndexData("SYS"),##Class(LIS.Util.Common).IndexData(WGMCode),""))
    .i '$l(fRecordNumberDR) q
    .s RecordNumberData=$g(^dbo.SYSRecordNumberD(fRecordNumberDR)) 
    .//关联基础规则
    .s SYSRuleNoBaseDR=$lg(RecordNumberData,12)
    .i '$l(SYSRuleNoBaseDR) q
    .s SYSRuleNoBaseData=$g(^dbo.SYSRuleNoBaseD(SYSRuleNoBaseDR))
	.s objRuleNoBase=##class(LIS.Util.COM.XML).New("RuleNoBase")
	.s objRuleNoBase.NumNode=$lg(SYSRuleNoBaseData,2)
    .s objRuleNoBase.CurNo=$lg(SYSRuleNoBaseData,5)
	.//Index IndexNo On (SYSRuleNoBaseDR, AddDate, CurNo) [ SqlName = Index_No, Type = index, Unique ];  dbo.SYSRuleNoBaseLog
	.s objBaseLogs=##class(LIS.Util.COM.XML).New("BaseLogs")
	.s fCurNo="" f  s fCurNo=$o(^dbo.SYSRuleNoBaseLogI("IndexNo",SYSRuleNoBaseDR,AddDate,fCurNo)) q:fCurNo=""  d
	..s SYSRuleNoBaseLogDR=$o(^dbo.SYSRuleNoBaseLogI("IndexNo",SYSRuleNoBaseDR,AddDate,fCurNo,""))
	..s SYSRuleNoBaseLogData=$g(^dbo.SYSRuleNoBaseLogD(SYSRuleNoBaseLogDR))
	..s objBaseLog=##class(LIS.Util.COM.XML).New("BaseLog")
	..s objBaseLog.AddDate=$lg(SYSRuleNoBaseLogData,3)
    ..s objBaseLog.AddTime=$lg(SYSRuleNoBaseLogData,4)
    ..s objBaseLog.CurNo=$lg(SYSRuleNoBaseLogData,5)
    ..s objBaseLog.IsUse=$lg(SYSRuleNoBaseLogData,6)
    ..d objBaseLogs.Insert(objBaseLog)
	.d objRuleNoBase.Insert(objBaseLogs) 
	.d objRuleNoBases.Insert(objRuleNoBase) 
	.s TransferFlag=1
	d RetXML.Insert(objRuleNoBases)
    s Input=RetXML.ToXMLStream()
    s strInput=Input.Read()
    i TransferFlag=1 d
    .s ret=##class(LIS.WS.DHCLISServiceBase).RemoteGetData(Address,"ES.LIS.DHCTransferEmergentData","TransferRuleNoBaseMTHD",strInput,"", "", "", "", "", "", "", "", "", "", "", "", "", Sessions,"")
	.//s ret=##Class(ES.LIS.DHCTransferEmergentData).TransferRuleNoBaseMTHD(strInput)
	
	q ret
}

/// Creator：      zhangli
/// CreatDate：    20210918
/// Description：  dbo.RPWorkGroupMachineEpis表结果推送
/// Input：        数据流
/// Output： 
/// w ##Class(ES.LIS.DHCTransferEmergentData).TransferWGMEpisMTHD("<Request><WGMEpiss><WGMEpis><HospCode>DHSZHYYZY</HospCode><DeptCode>J</DeptCode><WGCode>L</WGCode><WGMCode>LJF</WGMCode><AddDate>20211013</AddDate><EpisNo>10</EpisNo></WGMEpis></WGMEpiss></Request>","", "", "", "", "", "", "", "", "", "", "", "", "", "")
ClassMethod TransferWGMEpisMTHD(Input, P1, P2, P3, P4, P5, P6, P7, P8, P9, P10, P11, P12, P13, Sessions, Output RetValue As %String(MAXLEN=32767)) As %String [ SqlProc ]
{
	s ^MTMPLIS("TransferWGMEpisData")=$lb(Input)
	s Input=$g(Input)
	
	s ret=""
	//s objStream=Input.Read() 
	s objStream=Input
	s RetXMLData= ##class(LIS.Util.COM.XML).FromXML(objStream)
	s err="",RetVal=100,num=0
	while RetXMLData.Next() 
	{
		s objWGMEpiss=RetXMLData.Get(num)
		i '$l(objWGMEpiss) continue
		s num=num+1
		
		s WGMEpissLen=objWGMEpiss.Length()
		f j=0:1:(WGMEpissLen-1)
		{
			s objWGMEpis=objWGMEpiss.Get(j)
			i '$l(objWGMEpis) continue    
    	    s HospCode=objWGMEpis.HospCode 
			s DeptCode=objWGMEpis.DeptCode
			s WGCode=objWGMEpis.WGCode
			s WGMCode=objWGMEpis.WGMCode 
			s AddDate=objWGMEpis.AddDate
			s EpisNo=objWGMEpis.EpisNo
			s HospDR= $o(^dbo.BTHospitalI("IndexCode",##Class(LIS.Util.Common).IndexData(HospCode),""))
			s DeptDR=$o(^dbo.BTDepartmentI("IndexCode",HospDR,##Class(LIS.Util.Common).IndexData(DeptCode),""))
			s WGDR=$o(^dbo.BTWorkGroupI("IndexCode",DeptDR,##Class(LIS.Util.Common).IndexData(WGCode),""))
			s WGMDR=$o(^dbo.BTWorkGroupMachineI("IndexCode",WGDR,##Class(LIS.Util.Common).IndexData(WGMCode),""))
			s WGMEpisDR=$o(^dbo.RPWorkGroupMachineEpisI("IndexMaster",WGMDR,AddDate,""))
			i $l(WGMEpisDR) d
			.s objRPWGMachineEpis=##class(dbo.RPWorkGroupMachineEpis).%OpenId(WGMEpisDR)
			e  d
			.s objRPWGMachineEpis=##class(dbo.RPWorkGroupMachineEpis).%New()
			s objRPWGMachineEpis.WorkGroupMachineDR=WGMDR
			s objRPWGMachineEpis.AddDate=AddDate
			s objRPWGMachineEpis.EpisNo=EpisNo
			s sc=objRPWGMachineEpis.%Save()
	        i ($SYSTEM.Status.IsOK(sc)) d
   			.s ret=1
			e  d
			.s ret="-1^表dbo.RPWorkGroupMachineEpis结果保存失败:"_$SYSTEM.Status.GetErrorText(sc) 	
		}	
	}	
    q ret
}

/// Creator：      zhangli
/// CreatDate：    20210918
/// Description：  dbo.SYSRecordNumber表结果推送
/// Input：        数据流
/// Output： 
/// w ##Class(ES.LIS.DHCTransferEmergentData).TransferRecordNumData("8","", "", "", "", "", "", "", "", "", "", "", "", "", "")
ClassMethod TransferRecordNumMTHD(Input, P1, P2, P3, P4, P5, P6, P7, P8, P9, P10, P11, P12, P13, Sessions, Output RetValue As %String(MAXLEN=32767)) As %String [ SqlProc ]
{
	
	s ^TMPLIS("TransferWGMEpisData")=$lb(Input)
	s Input=$g(Input)
	
	s ret=""

	//s objStream=Input.Read() 
	s objStream=Input
	s RetXMLData= ##class(LIS.Util.COM.XML).FromXML(objStream)
	s err="",RetVal=100,num=0
	while RetXMLData.Next() 
	{
		s objRecordNums=RetXMLData.Get(num)
		i '$l(objRecordNums) continue
		s num=num+1
		
		s RecordNumsLen=objRecordNums.Length()
		f j=0:1:(RecordNumsLen-1)
		{
			s objRecordNum=objRecordNums.Get(j)
			i '$l(objRecordNum) continue
			s NumType="MIC" //objRecordNum.NumType 
			s NumNode=objRecordNum.NumNode 
			s MaxNum=objRecordNum.MaxNum 
            
            s RecordNumberDR=$O(^dbo.SYSRecordNumberI("IndexMaster",##Class(LIS.Util.Common).IndexData("MIC"),##Class(LIS.Util.Common).IndexData(NumNode),""))
            i '$l(RecordNumberDR) continue

			s objRecordNumber=##class(dbo.SYSRecordNumber).%OpenId(RecordNumberDR)
			s objRecordNumber.MaxNum=MaxNum
			s sc=objRecordNumber.%Save()
			i ($SYSTEM.Status.IsOK(sc)) d
   			.s ret=1
			e  d
			.s ret="-1^表dbo.SYSRecordNumber结果保存失败:"_$SYSTEM.Status.GetErrorText(sc)
					
		}	
	}	
    q ret
}

/// Creator：      zhangli
/// CreatDate：    20210918
/// Description：  dbo.SYSRuleNoBase,dbo.SYSRuleNoBaseLog表结果推送
/// Input：        数据流
/// Output： 
/// w ##Class(ES.LIS.DHCTransferEmergentData).TransferRuleNoBaseMTHD("<Request><RuleNoBases><RuleNoBase><NumNode>MIC01</NumNode><CurNo>0720073</CurNo><BaseLogs><BaseLog><AddDate>20211013</AddDate><AddTime>36447</AddTime><CurNo>70112501</CurNo><IsUse>1</IsUse></BaseLog><BaseLog><AddDate>20211013</AddDate><AddTime>36447</AddTime><CurNo>70112502</CurNo><IsUse>1</IsUse></BaseLog><BaseLog><AddDate>20211013</AddDate><AddTime>36447</AddTime><CurNo>70112503</CurNo><IsUse>1</IsUse></BaseLog><BaseLog><AddDate>20211013</AddDate><AddTime>36447</AddTime><CurNo>70112504</CurNo><IsUse>1</IsUse></BaseLog></BaseLogs></RuleNoBase></RuleNoBases></Request>","", "", "", "", "", "", "", "", "", "", "", "", "", "")
ClassMethod TransferRuleNoBaseMTHD(Input, P1, P2, P3, P4, P5, P6, P7, P8, P9, P10, P11, P12, P13, Sessions, Output RetValue As %String(MAXLEN=32767)) As %String [ SqlProc ]
{
	s ^MTMPLIS("TransferWGMEpisData")=$lb(Input)
	s Input=$g(Input)
	s ret=""
	//s objStream=Input.Read() 
	s objStream=Input
	s RetXMLData= ##class(LIS.Util.COM.XML).FromXML(objStream)
	s err="",RetVal=100,num=0
	while RetXMLData.Next() 
	{
		s objRuleNoBases=RetXMLData.Get(num)
		i '$l(objRuleNoBases) continue
		s num=num+1
		s RuleNoBasesLen=objRuleNoBases.Length()
		f j=0:1:(RuleNoBasesLen-1)
		{
			s objRuleNoBase=objRuleNoBases.Get(j)
			i '$l(objRuleNoBase) continue
			s RuleNoBaseCode=objRuleNoBase.NumNode 
			s CurNo=objRuleNoBase.CurNo 
			
			s SYSRuleNoBaseDR=$O(^dbo.SYSRuleNoBaseI("IndexCode",##Class(LIS.Util.Common).IndexData(RuleNoBaseCode),""))
            i '$l(SYSRuleNoBaseDR) continue
			s objSYSRuleNoBase=##class(dbo.SYSRuleNoBase).%OpenId(SYSRuleNoBaseDR)
			s objSYSRuleNoBase.CurNo=CurNo
			s sc=objSYSRuleNoBase.%Save()
			i ($SYSTEM.Status.IsOK(sc)) d
   			.s ret=1
			e  d
			.s ret="-1^表dbo.SYSRuleNoBase结果保存失败:"_$SYSTEM.Status.GetErrorText(sc)

			i '$l(objRuleNoBase.BaseLogs) q
	        s BaseLogsLen=objRuleNoBase.BaseLogs.Length()
		    f k=0:1:(BaseLogsLen-1)
		    { 
				s objBaseLog=objRuleNoBase.BaseLogs.Get(k)
			 	i '$l(objBaseLog) continue
				s AddDate=objBaseLog.AddDate 
				s AddTime=objBaseLog.AddTime 
				s CurNo=objBaseLog.CurNo 
				s IsUse=objBaseLog.IsUse 
											      
		        s RuleNoBaseLogDR=$o(^dbo.SYSRuleNoBaseLogI("IndexNo",SYSRuleNoBaseDR,AddDate,##Class(LIS.Util.Common).IndexData(CurNo),""))
    			i $l(RuleNoBaseLogDR) d
				.s objRuleNoBaseLog=##class(dbo.SYSRuleNoBaseLog).%OpenId(RuleNoBaseLogDR)
   			    e  d
   				.s objRuleNoBaseLog=##class(dbo.SYSRuleNoBaseLog).%New()
				s objRuleNoBaseLog.SYSRuleNoBaseDR=SYSRuleNoBaseDR
				s objRuleNoBaseLog.AddDate=AddDate //AddDate
				s objRuleNoBaseLog.AddTime=AddTime
				s objRuleNoBaseLog.CurNo=CurNo
				s objRuleNoBaseLog.IsUse=IsUse
				s sc=objRuleNoBaseLog.%Save()
                i ($SYSTEM.Status.IsOK(sc)) d
   			    .s ret=1
			    e  d
			    .s ret="-1^表dbo.SYSRuleNoBase结果保存失败:"_$SYSTEM.Status.GetErrorText(sc)  
		    }
					
		}	
	}	
    q ret
}

/// zhangli 20210726
/// 计划任务把正式库的待同步中间表数据“插入”应急库中间表中(RI_LabRequest,RI_TestSet)
/// w ##class(ES.LIS.DHCTransferEmergentData).ProductTSToEmergentMTHD("","","","","","","","","","","","","","","")
ClassMethod ProductTSToEmergentMTHD(P0, P1, P2, P3, P4, P5, P6, P7, P8, P9, P10, P11, P12, P13, Sessions, Output RowCount As %String) As %String
{
	
	s ret=0
	s Address=""
    s paramDR = $o(^dbo.SYSParameterI("IndexCode"," EMESYNCADDRESS", " SYS"," DHCC",""))
	i $l(paramDR) s Address = $lg(^dbo.SYSParameterD(paramDR),6)
    i '$l(Address)  q "-1^系统参数表未维护待同步库的WebService地址"
	s fAddDate="" f  s fAddDate=$o(^dbo.RILabTestSetI("IndexIsChanged",1,fAddDate)) q:fAddDate=""  d 
    .s fRITestSetDR="" f  s fRITestSetDR=$o(^dbo.RILabTestSetI("IndexIsChanged",1,fAddDate,fRITestSetDR)) q:fRITestSetDR=""  d 
    ..d InsertOneTS
    q ret
    
InsertOneTS
    s RITestSetData=$g(^dbo.RILabTestSetD(fRITestSetDR))
    s LabRequestDR=$lg(RITestSetData,1)
    s LabRequestData=$g(^dbo.RILabRequestD(LabRequestDR))
    s TransferFlag=0
	s RetXML=##class(LIS.Util.COM.XML).New("Request")
	s objLabRequest=##class(LIS.Util.COM.XML).New("LabRequestMsg")
    s objLabRequest.VisitNumberFrom=$lg(LabRequestData,1)
	s objLabRequest.AdmissionType=$lg(LabRequestData,2) 
	s objLabRequest.RegNo=$lg(LabRequestData,3) 
	s objLabRequest.AdmNo=$lg(LabRequestData,4) 
	s objLabRequest.MedicalRecordNo=$lg(LabRequestData,5) 
	s objLabRequest.AdmDate=$lg(LabRequestData,6) 
	s objLabRequest.AdmTime=$lg(LabRequestData,7) 
	s objLabRequest.CertType=$lg(LabRequestData,8) 
	s objLabRequest.CertNo=$lg(LabRequestData,9) 
	s objLabRequest.IDNumber=$lg(LabRequestData,10) 
	s objLabRequest.PaymentType=$lg(LabRequestData,11) 
	s objLabRequest.PaymentName=$lg(LabRequestData,12) 
	s objLabRequest.SurName=$lg(LabRequestData,13) 
	s objLabRequest.GivenName=$lg(LabRequestData,14) 
	s objLabRequest.SpeciesID=$lg(LabRequestData,15) 
	s objLabRequest.SpeciesName=$lg(LabRequestData,16) 
	s objLabRequest.BirthDate=$lg(LabRequestData,17) 
	s objLabRequest.BirthTime=$lg(LabRequestData,18) 
	s objLabRequest.Age=$lg(LabRequestData,19) 
	s objLabRequest.AgeUnit=$lg(LabRequestData,20) 
	s objLabRequest.Ethnicity=$lg(LabRequestData,21) 
	s objLabRequest.HospitaID=$lg(LabRequestData,22) 
	s objLabRequest.HospitaName=$lg(LabRequestData,23) 
	s objLabRequest.SymptomID=$lg(LabRequestData,24) 
	s objLabRequest.Symptom=$lg(LabRequestData,25) 
	s objLabRequest.MobileNo=$lg(LabRequestData,26) 
	s objLabRequest.PhoneNo=$lg(LabRequestData,27) 
	s objLabRequest.email=$lg(LabRequestData,28) 
	s objLabRequest.Height=$lg(LabRequestData,29) 
	s objLabRequest.Weight=$lg(LabRequestData,30) 
	s objLabRequest.BloodPressure=$lg(LabRequestData,31) 
	s objLabRequest.ClinicalConditions=$lg(LabRequestData,32) 
	s objLabRequest.Pregnant=$lg(LabRequestData,33) 
	s objLabRequest.PregnantWeeks=$lg(LabRequestData,34) 
	s objLabRequest.ABO=$lg(LabRequestData,35) 
	s objLabRequest.RH=$lg(LabRequestData,36) 
	s objLabRequest.Address=$lg(LabRequestData,37) 
	s objLabRequest.PostCode=$lg(LabRequestData,38) 
	s objLabRequest.InfectFlag=$lg(LabRequestData,39) 
	s objLabRequest.InfectAlert=$lg(LabRequestData,40) 
	s objLabRequest.PregnantNum=$lg(LabRequestData,41) 
	s objLabRequest.ChildbirthNum=$lg(LabRequestData,42) 
   
    s objLabTestSetMsgs=##class(LIS.Util.COM.XML).New("LabTestSetMsgs")
	s objLabTestSet=##class(LIS.Util.COM.XML).New("LabTestSetMsg")
    s objLabTestSet.VisitNumberDR=$lg(RITestSetData,1) 
	s objLabTestSet.TestSetCode=$lg(RITestSetData,2)  
	s objLabTestSet.TestSetName=$lg(RITestSetData,3)  
	s objLabTestSet.TestSetRowID=$lg(RITestSetData,4)  
	s objLabTestSet.Sequence=$lg(RITestSetData,5)  
	s objLabTestSet.BarCode=$lg(RITestSetData,6)  
	s objLabTestSet.ArticleBarCode=$lg(RITestSetData,7)  
	s objLabTestSet.TestSetState=$lg(RITestSetData,8)     //1：登记，2：打印条码，3：采集，4：标本运送，5：标本接收，6：停止，7：作废，8.拒收,10:打包，11：送达,13:护士执行（条码生成）
	s objLabTestSet.VisitNumberTestSetCode=$lg(RITestSetData,9)  
	s objLabTestSet.SpecimenCode=$lg(RITestSetData,10)  
	s objLabTestSet.SpecimenName=$lg(RITestSetData,11)      
	s objLabTestSet.ContainerCode=$lg(RITestSetData,12)  
	s objLabTestSet.ContainerName=$lg(RITestSetData,13)  
	s objLabTestSet.CollectNotes=$lg(RITestSetData,14)  
	s objLabTestSet.LocationCode=$lg(RITestSetData,15)  
	s objLabTestSet.LocationName=$lg(RITestSetData,16)      
	s objLabTestSet.WardCode=$lg(RITestSetData,17)  
	s objLabTestSet.WardName=$lg(RITestSetData,18)  
	s objLabTestSet.BedNo=$lg(RITestSetData,19)  
	s objLabTestSet.DotorID=$lg(RITestSetData,20)  
	s objLabTestSet.DotorName=$lg(RITestSetData,21)          
	s objLabTestSet.RequestDate=$lg(RITestSetData,22)  
	s objLabTestSet.RequestTime=$lg(RITestSetData,23)  
	s objLabTestSet.PrinterID=$lg(RITestSetData,24) 
	s objLabTestSet.PrinterName=$lg(RITestSetData,25) 
	s objLabTestSet.PrintDate=$lg(RITestSetData,26) 
	s objLabTestSet.PrintTime=$lg(RITestSetData,27) 
	s objLabTestSet.PrintStatus=$lg(RITestSetData,28) 
	s objLabTestSet.CollectDate=$lg(RITestSetData,29)  
	s objLabTestSet.CollectTime=$lg(RITestSetData,30)  
	s objLabTestSet.CollectUserID=$lg(RITestSetData,31)  
	s objLabTestSet.CollectUserName=$lg(RITestSetData,32)  
	s objLabTestSet.AnatomicalSite=$lg(RITestSetData,33)  
	s objLabTestSet.CollectPositon=$lg(RITestSetData,34)  
	s objLabTestSet.CarryDate=$lg(RITestSetData,35)  
	s objLabTestSet.CarryTime=$lg(RITestSetData,36)  
	s objLabTestSet.CarryUserID=$lg(RITestSetData,37)  
	s objLabTestSet.CarryUserName=$lg(RITestSetData,38)  
	s objLabTestSet.ReceiveDate=$lg(RITestSetData,39)  
	s objLabTestSet.ReceiveTime=$lg(RITestSetData,40)  
	s objLabTestSet.ReceiveUserID=$lg(RITestSetData,41)  
	s objLabTestSet.ReceiveUserName=$lg(RITestSetData,42)  
	s objLabTestSet.TestSetFee=$lg(RITestSetData,43)   
	s objLabTestSet.TestSetFeeFlag=$lg(RITestSetData,44)  //默认已计费 TestSetFeeFlag 
	s objLabTestSet.ReqNotes=$lg(RITestSetData,45)  
	s objLabTestSet.RequestNo=$lg(RITestSetData,46)  
	s objLabTestSet.Urgent=$lg(RITestSetData,47)  
	s objLabTestSet.H24UVolume=$lg(RITestSetData,48)  
	s objLabTestSet.H24UTimePeriod=$lg(RITestSetData,49)  
	s objLabTestSet.BodyTemp=$lg(RITestSetData,50)  
	s objLabTestSet.BloodPressure=$lg(RITestSetData,51)  
	s objLabTestSet.Confidential=$lg(RITestSetData,52)  
	s objLabTestSet.SpecimenQuality=$lg(RITestSetData,53)  
	s objLabTestSet.ReceiveHospitalID=$lg(RITestSetData,54)  
	s objLabTestSet.ReceiveNotes=$lg(RITestSetData,55)  
	s objLabTestSet.SpecialFlag=$lg(RITestSetData,56)  
	s objLabTestSet.SpecialRowId=$lg(RITestSetData,57) 
	s objLabTestSet.OrdDeptID=$lg(RITestSetData,58) 
	s objLabTestSet.OrdDeptName=$lg(RITestSetData,59)  
	s objLabTestSet.HospitalCode=$lg(RITestSetData,60)  
	s objLabTestSet.HospitalName=$lg(RITestSetData,61)  
	s objLabTestSet.WorkGroupMachineDR=$lg(RITestSetData,62)  
	s objLabTestSet.TransmitDate=$lg(RITestSetData,63)  
	s objLabTestSet.AssayNo=$lg(RITestSetData,64)  
	s objLabTestSet.AcceptDate=$lg(RITestSetData,65)  
	s objLabTestSet.AcceptTime=$lg(RITestSetData,66)  
	s objLabTestSet.AcceptUserDR=$lg(RITestSetData,67)  
	s objLabTestSet.ReportID=$lg(RITestSetData,68)  
	//报告在正式库如果是审核状态，置应急库对应的IsChanged为0(即应急库不需要给正式库同步了)
	s IsChanged=$lg(RITestSetData,69)
	s Status=""
	i $l(objLabTestSet.ReportID) d
	.s RPReportData =$g(^dbo.RPVisitNumberReportD(objLabTestSet.ReportID)) 
	.s Status=$lg(RPReportData,22)
	i Status="3" s IsChanged=0
	s objLabTestSet.IsChanged=IsChanged 
	s objLabTestSet.UpdateDate=$lg(RITestSetData,70)  
	s objLabTestSet.UpdateTime=$lg(RITestSetData,71)  
	s objLabTestSet.AddDate=$lg(RITestSetData,72)  
	s objLabTestSet.AddTime=$lg(RITestSetData,73)         
	d objLabTestSetMsgs.Insert(objLabTestSet)
	d objLabRequest.Insert(objLabTestSetMsgs) 
	d RetXML.Insert(objLabRequest)
    s Input=RetXML.ToXMLStream()
    s strInput=Input.Read()
    
    s ret=##class(LIS.WS.DHCLISServiceBase).RemoteGetData(Address,"ES.LIS.DHCRegisterByQRCode","SyncRILabRequestTSMTHD",strInput,"", "", "", "", "", "", "", "", "", "", "", "", "", Sessions,"")
    b //s ret = ##class(ES.LIS.DHCRegisterByQRCode).SyncRILabRequestTSMTHD(strInput,"","","","","","","","","","","","","","113^7^0^12^1")
    //同步成功后置中间表状态
     
    i ret=1 d
    .s objLabTestSet=##class(dbo.RILabTestSet).%OpenId(fRITestSetDR)
    .s objLabTestSet.IsChanged=0
    .s retTS=objLabTestSet.%Save()
	.If '($SYSTEM.Status.IsOK(retTS)) s ret="-1^医嘱信息保存失败:"_$SYSTEM.Status.GetErrorText(retTS)	
    q
}

/// zhangli 20211028 取消审核
/// w ##class(ES.LIS.DHCTransferEmergentData).ReportUndoMTHD("","","","","","","","","","","","","","","113^7^0^12^1")
ClassMethod ReportUndoMTHD(VisitNumberReportDR, WorkGroupMachineDR, P2, P3, P4, P5, P6, P7, P8, P9, P10, P11, P12, P13, Sessions, Output RowCount As %String) As %String
{
	s VisitNumberReportDR=$g(VisitNumberReportDR),WorkGroupMachineDR=$g(WorkGroupMachineDR),Sessions=$g(Sessions)
	q ##class(LISSP.DHCRPVisitNumberReport).ReportUndo(VisitNumberReportDR,"<Data><P3></P3><P12></P12><P4></P4><P0>"_WorkGroupMachineDR_"</P0><P8></P8><P10></P10><P5></P5><P1>应急任务取消</P1><P13></P13><P9></P9><P14></P14><P6></P6><P2></P2><P11></P11><P7></P7></Data>",Sessions)
}

/// zhangli 20211028 返回登记
/// w ##class(ES.LIS.DHCTransferEmergentData)ReportToRegMTHD("","","","","","","","","","","","","","","113^7^0^12^1")
ClassMethod ReportToRegMTHD(VisitNumberReportDR, P1, P2, P3, P4, P5, P6, P7, P8, P9, P10, P11, P12, P13, Sessions, Output RowCount As %String) As %String
{
	s VisitNumberReportDR=$g(VisitNumberReportDR),Sessions=$g(Sessions)
	i '$l(VisitNumberReportDR) q "-1^报告id不能为空"
	s RetValue=1
	//清空报告表审核信息
	s ReportObj=##class(dbo.RPVisitNumberReport).%OpenId(VisitNumberReportDR)
	s ReportObj.Status=1
	s ReportObj.EntryUserDR=""
	s ReportObj.EntryDate=""
	s ReportObj.EntryTime=""  
    s sc=ReportObj.%Save()
    If ('$SYSTEM.Status.IsOK(sc)) 
    {
	   s RetValue="-1^"_$SYSTEM.Status.GetErrorText(sc) Quit
	}
	q RetValue
	//w ##class(LISSP.DHCRPVisitNumberReport).ReportToRegMTHD(VisitNumberReportDR,"<Data><P3></P3><P12></P12><P4></P4><P0>"_WorkGroupMachineDR_"</P0><P8></P8><P10></P10><P5></P5><P1>应急任务取消</P1><P13></P13><P9></P9><P14></P14><P6></P6><P2></P2><P11></P11><P7></P7></Data>",Sessions)
}

/// zhangli 20211028 清除结果
/// w ##class(ES.LIS.DHCTransferEmergentData).ClearResultMTHD("","","","","","","","","","","","","","","113^7^0^12^1")
ClassMethod ClearResultMTHD(VisitNumberReportDR, P1, P2, P3, P4, P5, P6, P7, P8, P9, P10, P11, P12, P13, Sessions, Output RowCount As %String) As %String
{
	s VisitNumberReportDR=$g(VisitNumberReportDR),Sessions=$g(Sessions)
	q ##class(LISSP.DHCRPVisitNumberReport).ClearResult(VisitNumberReportDR,"<Data><P3></P3><P12></P12><P4></P4><P0></P0><P8></P8><P10></P10><P5></P5><P1>应急任务取消</P1><P13></P13><P9></P9><P14></P14><P6></P6><P2></P2><P11></P11><P7></P7></Data>",Sessions)
    //q ##class(LISSP.DHCRPVisitNumberReport).ClearResult(VisitNumberReportDR,"","","","","","","","","","","","","",Sessions)
}

/// zhangli 20211028 取消核收
/// w ##class(ES.LIS.DHCTransferEmergentData).ReportUndoMTHD("","","","","","","","","","","","","","","113^7^0^12^1")
ClassMethod DiscardReportMTHD(VisitNumberReportDR, P1, P2, P3, P4, P5, P6, P7, P8, P9, P10, P11, P12, P13, Sessions, Output RowCount As %String) As %String
{
	s VisitNumberReportDR=$g(VisitNumberReportDR),Sessions=$g(Sessions)
	q ##Class(LISSP.DHCRPVisitNumberReport).DiscardReport(VisitNumberReportDR,"<Data><P6></P6><P9></P9><P8></P8><P0>应急任务取消</P0><P12></P12><P13></P13><P10></P10><P11></P11><P4></P4><P14></P14><P7></P7><P1></P1><P3></P3><P2></P2><P5></P5></Data>",Sessions)
}

/// zhangli 20211028 拒收
/// w ##class(ES.LIS.DHCTransferEmergentData).ReportUndoMTHD("","","","","","","","","","","","","","","113^7^0^12^1")
ClassMethod RejectVisitNumberMTHD(Labno, TestSetDRlist, RejectTypeDR, P3, P4, P5, P6, P7, P8, P9, P10, P11, P12, P13, Sessions, Output RowCount As %String) As %String
{
	s Labno=$g(Labno),TestSetDRlist=$g(TestSetDRlist),RejectTypeDR=$g(RejectTypeDR),Sessions=$g(Sessions)
	s RejectTypeDR=19   //指定一个具体的拒收原因
	q ##Class(LISSP.DHCRPVisitNumber).RejectVisitNumber(Labno,"<Data><P3></P3><P12></P12><P4></P4><P0>"_RejectTypeDR_"</P0><P8></P8><P10></P10><P5></P5><P1>应急任务取消</P1><P13></P13><P9></P9><P14></P14><P6></P6><P2>"_TestSetDRlist_"</P2><P11></P11><P7></P7></Data>","113^7^0^12^1")
}

}
