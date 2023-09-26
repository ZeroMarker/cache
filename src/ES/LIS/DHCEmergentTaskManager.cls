Class ES.LIS.DHCEmergentTaskManager Extends %RegisteredObject
{

/// Creator：      zhangli
/// CreatDate：    20210918
/// Description：  遍历正式库消息表，往应急库表的中间表中插数据
/// Input：        WorkGroupCodes：工作组Code，多个用，分割
/// Output： 
/// w ##Class(ES.LIS.DHCEmergentTaskManager).ProductToEmergentRILabMTHD("A","DHSZHYYZY")
ClassMethod ProductToEmergentRILabMTHD(WorkGroupCodes, HospitalCode) As %String
{
	s ret="1"
	s WorkGroupCodes=$g(WorkGroupCodes),HospitalCode=$g(HospitalCode)
    
    i '$l(HospitalCode) q "-1^入参HospitalCode不能为空"
	//s Address="http://114.251.235.30:57772/imedicallis/csp/LIS.WS.DHCLISService.cls?wsdl=1&amp;CacheUserName=_system&amp;CachePassword=SYS"
    s Address=""
    s paramDR = $o(^dbo.SYSParameterI("IndexCode"," PROSYNCADDRESS", " SYS"," DHCC",""))
	i $l(paramDR) s Address = $lg(^dbo.SYSParameterD(paramDR),6)
    i '$l(Address)  q "-1^系统参数表未维护待同步库的WebService地址"
    ;b //1.0
    i '$l(WorkGroupCodes) s WorkGroupCodes="ALL"
	//按工作组Code同步数据
	s WGCodesLength=$l(WorkGroupCodes,",")
	f j=1:1:WGCodesLength
	{
		 s WorkGroupCode=$p(WorkGroupCodes,",",j)
		 i WorkGroupCode="ALL" s WorkGroupCode=""
	     f k=1:1:1000 //每次任务遍历1000次
	     {
		    //最近一次遍历到的消息表RowID
		    s OTMsgStockDR=$g(^LISProductLastOTMsgDR("LastOTMsgDR",HospitalCode,WorkGroupCode))
		    s retValue=##class(LIS.WS.DHCLISServiceBase).RemoteGetData(Address,"ES.LIS.DHCEmergentTaskManager","GetRILabList",OTMsgStockDR,WorkGroupCode,HospitalCode,"","","","","","","","","","","","","XML")
			s retStr=retValue //.Read()
			//异常报错，记录日志
			i retStr'["</s:schema>"	s ^LISProductLastOTMsgDR("Error",HospitalCode,WorkGroupCode,$h)="标本申请信息保存失败:"_retStr,^LISProductLastOTMsgDR("LastOTMsgDR",HospitalCode,WorkGroupCode)=$g(^LISProductLastOTMsgDR("LastOTMsgDR",HospitalCode,WorkGroupCode))+1 continue
			s retStr=$p(retStr,"</s:schema>",2) 
			s retStr="<Response><GetRILabListResult>"_retStr   
			//s retStr="<Response><GetRILabListResult><GetRILabList><AdmissionType>O</AdmissionType><RegNo>0000000016</RegNo><AdmNo>17</AdmNo><MedicalRecordNo></MedicalRecordNo><AdmDate>20200318</AdmDate><AdmTime>10:13:29</AdmTime><CertType></CertType><CertNo></CertNo><IDNumber>23332222</IDNumber><PaymentType></PaymentType><PaymentName></PaymentName><SurName>tyu01</SurName><GivenName>tyu01</GivenName><SpeciesID>F</SpeciesID><SpeciesName>女</SpeciesName><BirthDate>19750318</BirthDate><BirthTime></BirthTime><Age>45</Age><AgeUnit>Y</AgeUnit><Ethnicity></Ethnicity><HospitaID>DHSZHYYZY</HospitaID><HospitaName>标准版数字化医院[总院]</HospitaName><SymptomID></SymptomID><Symptom>感染性发热</Symptom><MobileNo>13001345678</MobileNo><PhoneNo></PhoneNo><email></email><Height></Height><Weight></Weight><BloodPressure></BloodPressure><ClinicalConditions></ClinicalConditions><Pregnant></Pregnant><PregnantWeeks></PregnantWeeks><ABO></ABO><RH></RH><Address></Address><PostCode></PostCode><InfectFlag></InfectFlag><InfectAlert></InfectAlert><PregnantNum></PregnantNum><ChildbirthNum></ChildbirthNum><VisitNumberDR>1</VisitNumberDR><TestSetCode>L0198</TestSetCode><TestSetName>血常规1</TestSetName><TestSetRowID>5||3</TestSetRowID><Sequence>1</Sequence><BarCode>00000001</BarCode><ArticleBarCode></ArticleBarCode><TestSetState></TestSetState><VisitNumberTestSetCode>L0198</VisitNumberTestSetCode><SpecimenCode>SP001</SpecimenCode><SpecimenName>全血</SpecimenName><ContainerCode>CO3</ContainerCode><ContainerName>紫色管</ContainerName><CollectNotes></CollectNotes><LocationCode>ZYMZ006</LocationCode><LocationName>内分泌科门诊</LocationName><WardCode></WardCode><WardName></WardName><BedNo></BedNo><DotorID>YS01</DotorID><DotorName>医生01</DotorName><RequestDate>20200318</RequestDate><RequestTime>10:14:16</RequestTime><PrinterID></PrinterID><PrinterName></PrinterName><PrintDate></PrintDate><PrintTime></PrintTime><PrintStatus></PrintStatus><CollectDate></CollectDate><CollectTime></CollectTime><CollectUserID></CollectUserID><CollectUserName></CollectUserName><AnatomicalSite></AnatomicalSite><CollectPositon></CollectPositon><CarryDate></CarryDate><CarryTime></CarryTime><CarryUserID></CarryUserID><CarryUserName></CarryUserName><ReceiveDate></ReceiveDate><ReceiveTime></ReceiveTime><ReceiveUserID></ReceiveUserID><ReceiveUserName></ReceiveUserName><TestSetFee>12</TestSetFee><TestSetFeeFlag></TestSetFeeFlag><ReqNotes></ReqNotes><RequestNo></RequestNo><Urgent>0</Urgent><H24UVolume></H24UVolume><H24UTimePeriod></H24UTimePeriod><BodyTemp></BodyTemp><BloodPressure></BloodPressure><Confidential></Confidential><SpecimenQuality>质量合格</SpecimenQuality><ReceiveHospitalID>DHSZHYYZY</ReceiveHospitalID><ReceiveNotes></ReceiveNotes><SpecialFlag></SpecialFlag><SpecialRowId></SpecialRowId><OrdDeptID></OrdDeptID><OrdDeptName></OrdDeptName><HospitalCode></HospitalCode><HospitalName></HospitalName><WorkGroupMachineDR></WorkGroupMachineDR><TransmitDate></TransmitDate><AssayNo></AssayNo><AcceptDate></AcceptDate><AcceptTime></AcceptTime><AcceptUserDR></AcceptUserDR><ReportID></ReportID><IsChanged>1</IsChanged><UpdateDate></UpdateDate><UpdateTime></UpdateTime><AddDate>20220616</AddDate><AddTime>36975</AddTime></GetRILabList></GetRILabListResult><RetVal>0</RetVal><Error></Error><Node>GetRILabList</Node><RowCount>0</RowCount><ResType>0</ResType><RetSession></RetSession></Response>" 
			s RetXMLData= ##class(LIS.Util.COM.XML).FromXML(retStr)	
			//返回为空，直接退出
			i RetXMLData.GetRILabListResult="" q //s ^LISProductLastOTMsgDR("LastOTMsgDR",HospitalCode,WorkGroupCode)=$g(^LISProductLastOTMsgDR("LastOTMsgDR",HospitalCode,WorkGroupCode))+1  q
			s RetRILabLen=RetXMLData.GetRILabListResult.Length()
			//返回为空，直接退出
			i RetRILabLen=0 q //s ^LISProductLastOTMsgDR("LastOTMsgDR",HospitalCode,WorkGroupCode)=$g(^LISProductLastOTMsgDR("LastOTMsgDR",HospitalCode,WorkGroupCode))+1  q //长度为0 退出这1000次循环
			;b //1.21
			f m=0:1:(RetRILabLen-1)
			{
				//循环解析每一条医嘱中间表数据
				s objRILab=RetXMLData.GetRILabListResult.Get(m)
				i '$l(objRILab) continue
				s VisitNumberFrom=objRILab.VisitNumberFrom
				s AdmissionTypeCode=objRILab.AdmissionTypeCode
				s AdmNo=objRILab.AdmNo
				
				//没有新增,存在更新
				s RILabRequestDR=""
				i '$l(AdmNo) s ^LISProductLastOTMsgDR("LastOTMsgDR",HospitalCode,WorkGroupCode)=$g(^LISProductLastOTMsgDR("LastOTMsgDR",HospitalCode,WorkGroupCode))+1  q //没有就诊号的，认为是手工登记的,不同步
				
				i $l(AdmNo) s RILabRequestDR=$o(^dbo.RILabRequestI("PKRIRequest",VisitNumberFrom,AdmissionTypeCode,AdmNo,""))
				i $l(RILabRequestDR){
					s objLabRequest=##class(dbo.RILabRequest).%OpenId(RILabRequestDR)	
				}
				else
				{
					s objLabRequest=##class(dbo.RILabRequest).%New()	
				}
				s objLabRequest.VisitNumberFrom=objRILab.VisitNumberFrom
				s objLabRequest.AdmissionType=objRILab.AdmissionTypeCode 
				s objLabRequest.RegNo=objRILab.RegNo
				s objLabRequest.AdmNo=objRILab.AdmNo
				s objLabRequest.MedicalRecordNo=objRILab.MedicalRecordNo
				s objLabRequest.AdmDate=objRILab.AdmDate
				s objLabRequest.AdmTime=objRILab.AdmTime
				s objLabRequest.CertType=objRILab.CertType
				s objLabRequest.CertNo=objRILab.CertNo
				s objLabRequest.IDNumber=objRILab.IDNumber
				s objLabRequest.PaymentType=objRILab.PaymentType
				s objLabRequest.PaymentName=objRILab.PaymentName
				s objLabRequest.SurName=objRILab.SurName
				s objLabRequest.GivenName=objRILab.GivenName
				s objLabRequest.SpeciesID=objRILab.SpeciesID  //姓名代码
				s objLabRequest.SpeciesName=objRILab.SpeciesName
				s objLabRequest.BirthDate=objRILab.BirthDate
				s objLabRequest.BirthTime=objRILab.BirthTime
				s objLabRequest.Age=objRILab.Age
				s objLabRequest.AgeUnit=objRILab.AgeUnit
				s objLabRequest.Ethnicity=objRILab.Ethnicity
				s objLabRequest.HospitaID=objRILab.HospitaID
				s objLabRequest.HospitaName=objRILab.HospitaName
				s objLabRequest.SymptomID=objRILab.SymptomID
				s objLabRequest.Symptom=objRILab.Symptom
				s objLabRequest.MobileNo=objRILab.MobileNo
				s objLabRequest.PhoneNo=objRILab.PhoneNo
				s objLabRequest.email=objRILab.email
				s objLabRequest.Height=objRILab.Height
				s objLabRequest.Weight=objRILab.Weight
				s objLabRequest.BloodPressure=objRILab.BloodPressure
				s objLabRequest.ClinicalConditions=objRILab.ClinicalConditions
				s objLabRequest.Pregnant=objRILab.Pregnant
				s objLabRequest.PregnantWeeks=objRILab.PregnantWeeks
				s objLabRequest.ABO=objRILab.ABO
				s objLabRequest.RH=objRILab.RH
				s objLabRequest.Address=objRILab.Address
				s objLabRequest.PostCode=objRILab.PostCode
				s objLabRequest.InfectFlag=objRILab.InfectFlag
				s objLabRequest.InfectAlert=objRILab.InfectAlert
				s objLabRequest.PregnantNum=objRILab.PregnantNum
				s objLabRequest.ChildbirthNum=objRILab.ChildbirthNum
				s retvis=objLabRequest.%Save()
				//If '($SYSTEM.Status.IsOK(retvis)) throw ##class(%Exception.SystemException).%New("事务委托","D",,"标本申请信息保存失败:"_$SYSTEM.Status.GetErrorText(retvis))
			    If '($SYSTEM.Status.IsOK(retvis))	s ^LISProductLastOTMsgDR("Error",HospitalCode,WorkGroupCode,AdmNo)="标本申请信息保存失败:"_$SYSTEM.Status.GetErrorText(retvis),^LISProductLastOTMsgDR("LastOTMsgDR",HospitalCode,WorkGroupCode)=$g(^LISProductLastOTMsgDR("LastOTMsgDR",HospitalCode,WorkGroupCode))+1 continue
				s RILabRequestDR=objLabRequest.RowID		
				
				
				s TestSetRowID=objRILab.TestSetRowID
				s Sequence=objRILab.Sequence
				//医嘱id不能为空
				i '$l(TestSetRowID) s ^LISProductLastOTMsgDR("Error",HospitalCode,WorkGroupCode,AdmNo)="医嘱id为空",^LISProductLastOTMsgDR("LastOTMsgDR",HospitalCode,WorkGroupCode)=$g(^LISProductLastOTMsgDR("LastOTMsgDR",HospitalCode,WorkGroupCode))+1  continue //没有就诊号的，认为是手工登记的,不同步
				b //1.23
				i $l(TestSetRowID) s LabTestSetDR=$o(^dbo.RILabTestSetI("IndexMaster",RILabRequestDR,TestSetRowID,Sequence,""))
				i $l(LabTestSetDR){
					s objLabTestSet=##class(dbo.RILabTestSet).%OpenId(LabTestSetDR) 
				}
				else
				{
					s objLabTestSet=##class(dbo.RILabTestSet).%New()
				}
				s objLabTestSet.VisitNumberDR=RILabRequestDR
				s objLabTestSet.TestSetCode=objRILab.TestSetCode 
				s objLabTestSet.TestSetName=objRILab.TestSetName 
				s objLabTestSet.TestSetRowID=objRILab.TestSetRowID 
				s objLabTestSet.Sequence=objRILab.Sequence 
				s objLabTestSet.BarCode=objRILab.BarCode 
				i objRILab.BarCode ="0000002865" b //1.231
				s objLabTestSet.ArticleBarCode=objRILab.ArticleBarCode 
				s objLabTestSet.TestSetState=objRILab.TestSetState    //1：登记，2：打印条码，3：采集，4：标本运送，5：标本接收，6：停止，7：作废，8.拒收,10:打包，11：送达,13:护士执行（条码生成）
				s objLabTestSet.VisitNumberTestSetCode=objRILab.VisitNumberTestSetCode 
				s objLabTestSet.SpecimenCode=objRILab.SpecimenCode 
				s objLabTestSet.SpecimenName=objRILab.SpecimenName     
				s objLabTestSet.ContainerCode=objRILab.ContainerCode 
				s objLabTestSet.ContainerName=objRILab.ContainerName 
				s objLabTestSet.CollectNotes=objRILab.CollectNotes 
				s objLabTestSet.LocationCode=objRILab.LocationCode 
				s objLabTestSet.LocationName=objRILab.LocationName     
				s objLabTestSet.WardCode=objRILab.WardCode 
				s objLabTestSet.WardName=objRILab.WardName 
				s objLabTestSet.BedNo=objRILab.BedNo 
				s objLabTestSet.DotorID=objRILab.DotorID 
				s objLabTestSet.DotorName=objRILab.DotorName         
				s objLabTestSet.RequestDate=objRILab.RequestDate 
				s objLabTestSet.RequestTime=objRILab.RequestTime 
				s objLabTestSet.PrinterID=objRILab.PrinterID 
				s objLabTestSet.PrinterName=objRILab.PrinterName 
				s objLabTestSet.PrintDate=objRILab.PrintDate 
				s objLabTestSet.PrintTime=objRILab.PrintTime 
				s objLabTestSet.PrintStatus=objRILab.PrintStatus 
				s objLabTestSet.CollectDate=objRILab.CollectDate 
				s objLabTestSet.CollectTime=objRILab.CollectTime 
				s objLabTestSet.CollectUserID=objRILab.CollectUserID 
				s objLabTestSet.CollectUserName=objRILab.CollectUserName 
				s objLabTestSet.AnatomicalSite=objRILab.AnatomicalSite 
				s objLabTestSet.CollectPositon=objRILab.CollectPositon 
				s objLabTestSet.CarryDate=objRILab.CarryDate 
				s objLabTestSet.CarryTime=objRILab.CarryTime 
				s objLabTestSet.CarryUserID=objRILab.CarryUserID 
				s objLabTestSet.CarryUserName=objRILab.CarryUserName 
				s objLabTestSet.ReceiveDate=objRILab.ReceiveDate 
				s objLabTestSet.ReceiveTime=objRILab.ReceiveTime 
				s objLabTestSet.ReceiveUserID=objRILab.ReceiveUserID 
				s objLabTestSet.ReceiveUserName=objRILab.ReceiveUserName 
				s objLabTestSet.TestSetFee=objRILab.TestSetFee  
				s objLabTestSet.TestSetFeeFlag=2 //已经计费 //objRILab.TestSetFeeFlag 
				s objLabTestSet.ReqNotes=objRILab.ReqNotes 
				s objLabTestSet.RequestNo=objRILab.RequestNo 
				s objLabTestSet.Urgent=objRILab.Urgent 
				s objLabTestSet.H24UVolume=objRILab.H24UVolume 
				s objLabTestSet.H24UTimePeriod=objRILab.H24UTimePeriod 
				s objLabTestSet.BodyTemp=objRILab.BodyTemp 
				s objLabTestSet.BloodPressure=objRILab.BloodPressure 
				s objLabTestSet.Confidential=objRILab.Confidential 
				s objLabTestSet.SpecimenQuality=objRILab.SpecimenQuality 
				s objLabTestSet.ReceiveHospitalID=objRILab.ReceiveHospitalID 
				s objLabTestSet.ReceiveNotes=objRILab.ReceiveNotes 
				s objLabTestSet.SpecialFlag=objRILab.SpecialFlag 
				s objLabTestSet.SpecialRowId=objRILab.SpecialRowId 
				s objLabTestSet.OrdDeptID=objRILab.OrdDeptID 
				s objLabTestSet.OrdDeptName=objRILab.OrdDeptName 
				s objLabTestSet.HospitalCode=objRILab.HospitalCode 
				s objLabTestSet.HospitalName=objRILab.HospitalName 
				s objLabTestSet.WorkGroupMachineDR=objRILab.WorkGroupMachineDR 
				s objLabTestSet.TransmitDate=objRILab.TransmitDate 
				s objLabTestSet.AssayNo=objRILab.AssayNo 
				s objLabTestSet.AcceptDate=objRILab.AcceptDate 
				s objLabTestSet.AcceptTime=objRILab.AcceptTime 
				s objLabTestSet.AcceptUserDR=objRILab.AcceptUserDR 
				s objLabTestSet.ReportID=objRILab.ReportID 
				s objLabTestSet.IsChanged=objRILab.IsChanged 
				s objLabTestSet.UpdateDate=objRILab.UpdateDate 
				s objLabTestSet.UpdateTime=objRILab.UpdateTime 
				s objLabTestSet.AddDate=objRILab.AddDate 
				s objLabTestSet.AddTime=objRILab.AddTime
				s objLabTestSet.EpisodeNo=objRILab.EpisodeNo  
				s retvis=objLabTestSet.%Save()
				//If '($SYSTEM.Status.IsOK(retvis)) throw ##class(%Exception.SystemException).%New("事务委托","D",,"医嘱信息保存失败:"_$SYSTEM.Status.GetErrorText(retvis))	
			    b //1.24
			    If '($SYSTEM.Status.IsOK(retvis)) s ^LISProductLastOTMsgDR("Error",HospitalCode,WorkGroupCode,TestSetRowID)="医嘱信息保存失败:"_$SYSTEM.Status.GetErrorText(retvis),^LISProductLastOTMsgDR("LastOTMsgDR",HospitalCode,WorkGroupCode)=$g(^LISProductLastOTMsgDR("LastOTMsgDR",HospitalCode,WorkGroupCode))+1 continue
				
				
				//成功后,记录该工作组最后遍历的消息表ID
				s ^LISProductLastOTMsgDR("LastOTMsgDR",HospitalCode,WorkGroupCode)=objRILab.OTMsgStockDR 				
			}
		 }
	}
    q ret
}

/// Creator：      zhangli
/// CreatDate：    20210620
/// Description：  通过消息表 遍历得到中间表格式的业务数据
/// Table：        
/// Input：        
/// Output：       中间表格式的业务数据
/// Return：       
/// Others：       
Query GetRILabList(OTMsgStockDR, WorkGroupCode, HospitalCode, P3, P4, P5, P6, P7, P8, P9, P10, P11, P12, P13, Sessions, Output RowCount As %String) As %Query(ROWSPEC = "OTMsgStockDR,VisitNumberFrom,AdmissionTypeCode,RegNo,AdmNo,MedicalRecordNo,AdmDate,AdmTime,CertType,CertNo,IDNumber,PaymentType,PaymentName,SurName,GivenName,SpeciesID,SpeciesName,BirthDate,BirthTime,Age,AgeUnit,Ethnicity,HospitaID,HospitaName,SymptomID,Symptom,MobileNo,PhoneNo,email,Height,Weight,BloodPressure,ClinicalConditions,Pregnant,PregnantWeeks,ABO,RH,Address,PostCode,InfectFlag,InfectAlert,PregnantNum,ChildbirthNum,VisitNumberDR,TestSetCode,TestSetName,TestSetRowID,Sequence,BarCode,ArticleBarCode,TestSetState,VisitNumberTestSetCode,SpecimenCode,SpecimenName,ContainerCode,ContainerName,CollectNotes,LocationCode,LocationName,WardCode,WardName,BedNo,DotorID,DotorName,RequestDate,RequestTime,PrinterID,PrinterName,PrintDate,PrintTime,PrintStatus,CollectDate,CollectTime,CollectUserID,CollectUserName,AnatomicalSite,CollectPositon,CarryDate,CarryTime,CarryUserID,CarryUserName,ReceiveDate,ReceiveTime,ReceiveUserID,ReceiveUserName,TestSetFee,TestSetFeeFlag,ReqNotes,RequestNo,Urgent,H24UVolume,H24UTimePeriod,BodyTemp,BloodPressure,Confidential,SpecimenQuality,ReceiveHospitalID,ReceiveNotes,SpecialFlag,SpecialRowId,OrdDeptID,OrdDeptName,HospitalCode,HospitalName,WorkGroupMachineDR,TransmitDate,AssayNo,AcceptDate,AcceptTime,AcceptUserDR,ReportID,IsChanged,UpdateDate,UpdateTime,AddDate,AddTime,EpisodeNo,MsgType")
{
}

/// Query的执行方法
/// d ##class(%ResultSet).RunQuery("ES.LIS.DHCEmergentTaskManager","GetRILabList","2336","A","DHSZHYYZY","","","","","","","","","","","","")
ClassMethod GetRILabListExecute(ByRef qHandle As %Binary, OTMsgStockDR, WorkGroupCode, HospitalCode, P3, P4, P5, P6, P7, P8, P9, P10, P11, P12, P13, Sessions, Output RowCount As %String) As %Status
{
	S ^MMP("GetRILabList")=$lb(OTMsgStockDR, WorkGroupCode, HospitalCode, P3, P4, P5, P6, P7, P8, P9, P10, P11, P12, P13, Sessions)
	s OTMsgStockDR=$g(OTMsgStockDR),WorkGroupCode=$g(WorkGroupCode),HospitalCode=$g(HospitalCode)
 	Set repid=$i(^CacheTemp)
 	Set ind=1
	
	i '$l(HospitalCode)
	{
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK	
	}
	s HospitalDR=$o(^dbo.BTHospitalI("IndexCode",HospitalCode,""))
    
    s OutputFlag="0"
    s fOTMsgStockDR=OTMsgStockDR
	f  s fOTMsgStockDR=$o(^dbo.OTMsgStockI("PKOTMSGSTOCK",fOTMsgStockDR)) q:((fOTMsgStockDR="")||(OutputFlag="1"))  d  //q:((fOTMsgStockDR="")||(OutputFlag="1"))
	.s OTMsgStockData=$g(^dbo.OTMsgStockD(fOTMsgStockDR))
	.s MsgType=$lg(OTMsgStockData,9)
	.i (MsgType="Receive") || (MsgType="CACCEPT") d
	..//b //接收
	..s VisitNumberDR=$lg(OTMsgStockData,17)
	..d ReceiveEmergent
	.e  i (MsgType="HISReject")  d
	..//b //拒收
	..s RejectSpecDR=$lg(OTMsgStockData,17)
	..i $l(RejectSpecDR) d
	...s VisitNumberDR=$lg($g(^dbo.RPVisitNumberRejectSpecD(RejectSpecDR)),2)
	...d ReceiveEmergent
	.e  i (MsgType="Accept") || (MsgType="HISAuthorise") || (MsgType="HISReportUndo")   d
	..//b //核收，审核，取消审核
	..s VisitNumberReportDR=$lg(OTMsgStockData,17)
	..s VisitNumberDR=$lg($g(^dbo.RPVisitNumberReportD(VisitNumberReportDR)),2)
	..d ReceiveEmergent
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
    
    
ReceiveEmergent
    i '$l(VisitNumberDR)	q  //没找到标本直接退出
 	s gVisitNumberData=$g(^dbo.RPVisitNumberD(VisitNumberDR))
 	i '$l(gVisitNumberData)	q  //没找到标本直接退出
    s ReceiveWorkGroupDR=$lg(gVisitNumberData,100),ReceiveWorkGroupCode=""
    i $l(ReceiveWorkGroupDR) s ReceiveWorkGroupCode=$lg($g(^dbo.BTWorkGroupD(ReceiveWorkGroupDR)),2)
    //取消接收拒收工作组限制,后期有医院要求的话放开
    //i (($l(WorkGroupCode))&&(MsgType="Receive")&&(WorkGroupCode'=ReceiveWorkGroupCode)) q
    //i (($l(WorkGroupCode))&&(MsgType="HISReject")&&(WorkGroupCode'=ReceiveWorkGroupCode)) q
    s VisitNumber=$lg(gVisitNumberData,2)
	s RegNo=$lg(gVisitNumberData,3)
	s AdmissionTypeDR=$lg(gVisitNumberData,4)
	i '$l(AdmissionTypeDR) q //没有就诊类型退出
	s AdmissionTypeCode=$lg($g(^dbo.BTAdmissionTypeD(AdmissionTypeDR)),2)
	s AdmNo=$lg(gVisitNumberData,5)
	s MedicalRecordNo=$lg(gVisitNumberData,6)
	s AdmDate=$lg(gVisitNumberData,7)
	s AdmTime=$lg(gVisitNumberData,8)
	i $l(AdmTime) s AdmTime=$zt(AdmTime)
	s CertTypeDR=$lg(gVisitNumberData,9),CertType=""
	i $l(CertTypeDR) s CertType=$lg($g(^dbo.BTCertTypeD(CertTypeDR)),2) 
	s CertNo=$lg(gVisitNumberData,10)
	s IDNumber=$lg(gVisitNumberData,11)
    s PaymentType=""
    s PaymentName=""
	s SurName=$lg(gVisitNumberData,13)
	s GivenName=$lg(gVisitNumberData,14)
	s SpeciesDR=$lg(gVisitNumberData,15),SpeciesID="",SpeciesName=""
  	i $l(SpeciesDR) s SpeciesID=$lg($g(^dbo.BTSpeciesD(SpeciesDR)),2),SpeciesName=$lg($g(^dbo.BTSpeciesD(SpeciesDR)),3)
  	s BirthDate=$lg(gVisitNumberData,16)
  	s BirthTime=$lg(gVisitNumberData,17)
  	i $l(BirthTime) s BirthTime=$zt(BirthTime)
	s Age=$lg(gVisitNumberData,18)
  	s AgeUnitDR=$lg(gVisitNumberData,19),AgeUnit=""
  	i $l(AgeUnitDR) s AgeUnit=$lg($g(^dbo.BTAgeUnitD(AgeUnitDR)),2)
  	s EthnicityDR=$lg(gVisitNumberData,20),Ethnicity=""
  	i $l(EthnicityDR) s Ethnicity=$lg($g(^dbo.BTEthnicityD(EthnicityDR)),2)
  	s HospitalDR=$lg(gVisitNumberData,21),HospitaID="",HospitaName=""
  	i $l(HospitalDR) s HospitaID=$lg($g(^dbo.BTHospitalD(HospitalDR)),2),HospitaName=$lg($g(^dbo.BTHospitalD(HospitalDR)),3)
  	i HospitalCode'=HospitaID q
  	s LocationDR=$lg(gVisitNumberData,22),LocationCode="",LocationName=""
  	i $l(LocationDR) s LocationCode=$lg($g(^dbo.BTLocationD(LocationDR)),2),LocationName=$lg($g(^dbo.BTLocationD(LocationDR)),3)  	
  	s DoctorDR=$lg(gVisitNumberData,23),DotorID="",DotorName=""
  	i $l(DoctorDR) s DotorID=$lg($g(^dbo.BTDoctorD(DoctorDR)),2),DotorName=$lg($g(^dbo.BTDoctorD(DoctorDR)),3)
  	s RequestDate=$lg(gVisitNumberData,24)
  	s RequestTime=$lg(gVisitNumberData,25)
  	i $l(RequestTime) s RequestTime=$zt(RequestTime)
  	s WardDR=$lg(gVisitNumberData,26),WardCode="",WardName=""
    i $l(WardDR) s WardCode=$lg($g(^dbo.BTWardD(WardDR)),2),WardName=$lg($g(^dbo.BTWardD(WardDR)),3)
	s BedNo=$lg(gVisitNumberData,27)
  	s Symptom=$lg(gVisitNumberData,28)
  	s MobileNo=$lg(gVisitNumberData,29)
  	s PhoneNo=$lg(gVisitNumberData,30)
  	s email=$lg(gVisitNumberData,31)
  	s Height=$lg(gVisitNumberData,32)
  	s Weight=$lg(gVisitNumberData,33)
  	s BloodPressure=$lg(gVisitNumberData,34)
  	s ClinicalConditionsDR=$lg(gVisitNumberData,35),ClinicalConditions=""
  	i $l(ClinicalConditionsDR) s ClinicalConditions=$lg($g(^dbo.BTClinicalConditionsD(ClinicalConditionsDR)),2)
  	s Pregnant=$lg(gVisitNumberData,37)
  	s PregnantWeeks=$lg(gVisitNumberData,38)
    s ABODR=$lg(gVisitNumberData,39),ABO=""
    i $l(ABODR) s ABO=$lg($g(^dbo.BTABOBGD(ABODR)),2)
  	s RHDR=$lg(gVisitNumberData,40),RH=""
  	i $l(RHDR) s RH=$lg($g(^dbo.BTRHBGD(RHDR)),2)  	
  	s Address=$lg(gVisitNumberData,41)
  	s PostCode=$lg(gVisitNumberData,42)
  	s InfectFlag=$lg(gVisitNumberData,43)
  	s InfectAlert=$lg(gVisitNumberData,44)
  	s SpecialFlag=$lg(gVisitNumberData,45)
  	s PregnantNum=$lg(gVisitNumberData,46)
  	s ChildbirthNum=$lg(gVisitNumberData,47)
  	s ReqNotes=$lg(gVisitNumberData,48)
  	s RequestNo=$lg(gVisitNumberData,49)
  	s Urgent=$lg(gVisitNumberData,50)
  	s CollectDate=$lg(gVisitNumberData,51)  
    s CollectTime=$lg(gVisitNumberData,52) 
    i $l(CollectTime) s CollectTime=$zt(CollectTime)  
    s CollectUserDR=$lg(gVisitNumberData,53),CollectUserID="",CollectUserName=""
    i $l(CollectUserDR) d
    .s CollectUserID=$lg($g(^dbo.SYSUserD(CollectUserDR)),2)
    .s CollectUserName=$lg($g(^dbo.SYSUserD(CollectUserDR)),3)
    s AnatomicalSiteDR=$lg(gVisitNumberData,54),AnatomicalSite=""
    i $l(AnatomicalSiteDR) s AnatomicalSite=$lg($lg(^dbo.BTAnatomicalSiteD(AnatomicalSiteDR)),2)
    s CollectPositon=$lg(gVisitNumberData,55)
    s SpecimenDR=$lg(gVisitNumberData,56),SpecimenCode="",SpecimenName=""
    i $l(SpecimenDR) s SpecimenCode= $lg($g(^dbo.BTSpecimenD(SpecimenDR)),2),SpecimenName= $lg($g(^dbo.BTSpecimenD(SpecimenDR)),3)    
    s ContainerDR=$lg(gVisitNumberData,57),ContainerCode="",ContainerName=""
    i $l(ContainerDR) s ContainerCode= $lg($g(^dbo.BTContainerD(ContainerDR)),2),ContainerName= $lg($g(^dbo.BTContainerD(ContainerDR)),3)    
    s CollectNotes=$lg(gVisitNumberData,58)
    s H24UVolume=$lg(gVisitNumberData,59)
    s H24UTimePeriod=$lg(gVisitNumberData,60)
    s BodyTemp=$lg(gVisitNumberData,61)
    s Confidential=$lg(gVisitNumberData,62)
    s CarryDate=$lg(gVisitNumberData,63)  
    s CarryTime=$lg(gVisitNumberData,64)   
    i $l(CarryTime) s CarryTime=$zt(CarryTime)  
    s CarryUserDR=$lg(gVisitNumberData,65),CarryUserID="",CarryUserName=""
    i $l(CarryUserDR) d
    .s CarryUserID=$lg($g(^dbo.SYSUserD(CarryUserDR)),2)
    .s CarryUserName=$lg($g(^dbo.SYSUserD(CarryUserDR)),3)
  	s ReceiveDate=$lg(gVisitNumberData,66)   
    s ReceiveTime=$lg(gVisitNumberData,67)   
    i $l(ReceiveTime) s ReceiveTime=$zt(ReceiveTime)  
    s ReceiveUserDR=$lg(gVisitNumberData,68),ReceiveUserID="",ReceiveUserName=""
    i $l(ReceiveUserDR) d
    .s ReceiveUserID=$lg($g(^dbo.SYSUserD(ReceiveUserDR)),2)
    .s ReceiveUserName=$lg($g(^dbo.SYSUserD(ReceiveUserDR)),3)
    s SpecimenQualityDR=$lg(gVisitNumberData,69),SpecimenQuality=""
    i $l(SpecimenQualityDR) s SpecimenQuality=$lg($g(^dbo.BTSpecimenQualityD(SpecimenQualityDR)),3)
    s ReceiveNotes=$lg(gVisitNumberData,70)
    s HospitalDR=$lg(gVisitNumberData,78),ReceiveHospitalID=""
	i $l(HospitalDR) s ReceiveHospitalID=$lg($g(^dbo.BTHospitalD(HospitalDR)),2)
  	s AddDate=$lg(gVisitNumberData,79)   ;创建信息
    s AddTime=$lg(gVisitNumberData,80) 
    i $l(AddTime) s AddTime=$zt(AddTime) 
    s AddUserDR=$lg(gVisitNumberData,81)
    i $l(AddUserDR) d
    .s AddUserCode=$lg($g(^dbo.SYSUserD(AddUserDR)),2)
    .s AddUserDesc=$lg($g(^dbo.SYSUserD(AddUserDR)),3)
  	 s ArriveDate=$lg(gVisitNumberData,85)   ;送达信息
    s ArriveTime=$lg(gVisitNumberData,86)
    i $l(ArriveTime) s ArriveTime=$zt(ArriveTime)  
    s ArriveUserDR=$lg(gVisitNumberData,87)
    i $l(ArriveUserDR) d
    .s ArriveUserCode=$lg($g(^dbo.SYSUserD(ArriveUserDR)),2)
    .s ArriveUserDesc=$lg($g(^dbo.SYSUserD(ArriveUserDR)),3)
    s SymptomID=$lg(gVisitNumberData,91)
    
    B //s objLabTestSetMsgs=##class(LIS.Util.COM.XML).New("LabTestSetMsgs")
    s fTestSetDR="" f  s fTestSetDR=$o(^dbo.RPVisitNumberTestSetI("IndexMaster",VisitNumberDR,fTestSetDR)) q:fTestSetDR=""  d
	.s VisNumTSDR=$o(^dbo.RPVisitNumberTestSetI("IndexMaster",VisitNumberDR,fTestSetDR,""))
	.i '$l(VisNumTSDR) q
	.s TestSetDR=fTestSetDR
	.s VisNumTSData=$g(^dbo.RPVisitNumberTestSetD(VisNumTSDR))
	.s TestSetCode=$lg(^dbo.BTTestSetD(TestSetDR),2)
	.s TestSetName=$lg(^dbo.BTTestSetD(TestSetDR),3)
	.s WorkGroupMachineDR=$lg(VisNumTSData,5)
	.s TestSetFee=$lg(VisNumTSData,8)
	.s TestSetRowID=$lg(VisNumTSData,10)
	.s VisitNumberReportDR=$lg(VisNumTSData,11)
	.s Sequence=1
	.s BarCode=VisitNumber
	.s ArticleBarCode=""
	.s TestSetState=""
	.s VisitNumberTestSetCode=""
	.s WorkGroupMachineDR=""
	.s TransmitDate=""
	.s EpisodeNo=""
	.s AssayNo=""  
	.s AcceptDate=""  
	.s AcceptTime="" 
	.s AcceptUserDR=""
	.s gReportData="" 
	.s ReportID=""
	.i $l(VisitNumberReportDR) d
	..s gReportData=$g(^dbo.RPVisitNumberReportD(VisitNumberReportDR))
	..s ReportID=VisitNumberReportDR 
	.i $l(gReportData) d
	..s WorkGroupMachineDR=$lg(gReportData,4)
	..s oneWorkGroupDR=$lg($g(^dbo.BTWorkGroupMachineD(WorkGroupMachineDR)),4),oneWorkGroupCode=""
	..i $l(oneWorkGroupDR) s oneWorkGroupCode=$lg($g(^dbo.BTWorkGroupD(oneWorkGroupDR)),2)
	..i (($l(WorkGroupCode))&&((MsgType="Accept")||(MsgType="HISAuthorise"))&&(WorkGroupCode'=oneWorkGroupCode)) q
	..s TransmitDate=$lg(gReportData,3)  
	..s AssayNo=$lg(gReportData,6)  
	..s EpisodeNo=$lg(gReportData,8) 
	..s AcceptDate=$lg(gReportData,9)  
	..s AcceptTime=$lg(gReportData,10)  
	..s AcceptUserDR=$lg(gReportData,11)  
	..s ReportID=VisitNumberReportDR 
	.s IsChanged="1" 
	.//如果是审核状态,IsChanged置为0表示后应急库不需要再做任何操作了
	.s Status=$lg(gReportData,22)
	.i Status="3" s IsChanged="0" 
	.s UpdateDate="" 
	.s UpdateTime="" 
	.s AddDate=$zd($p($h,",",1),8)
	.s AddTime=$p($h,",",2) 
	.s VisitNumberFrom ="HIS1"
	.s OutputFlag="1"     
	.d Output
	.//实时同步应急和正式库的流水号
	.d ##class(ES.LIS.DHCTransferEmergentData).EpisNoSyncTaskMTHD("2",WorkGroupCode,"","","","","","","","","","","","","")	
    q
    
Output
	s Data=$lb(fOTMsgStockDR,VisitNumberFrom,AdmissionTypeCode,RegNo,AdmNo,MedicalRecordNo,AdmDate,AdmTime,CertType,CertNo,IDNumber,PaymentType,PaymentName,SurName,GivenName,SpeciesID,SpeciesName,BirthDate,BirthTime,Age,AgeUnit,Ethnicity,HospitaID,HospitaName,SymptomID,Symptom,MobileNo,PhoneNo,email,Height,Weight,BloodPressure,ClinicalConditions,Pregnant,PregnantWeeks,ABO,RH,Address,PostCode,InfectFlag,InfectAlert,PregnantNum,ChildbirthNum,VisitNumberDR,TestSetCode,TestSetName,TestSetRowID,Sequence,BarCode,ArticleBarCode,TestSetState,VisitNumberTestSetCode,SpecimenCode,SpecimenName,ContainerCode,ContainerName,CollectNotes,LocationCode,LocationName,WardCode,WardName,BedNo,DotorID,DotorName,RequestDate,RequestTime,PrinterID,PrinterName,PrintDate,PrintTime,PrintStatus,CollectDate,CollectTime,CollectUserID,CollectUserName,AnatomicalSite,CollectPositon,CarryDate,CarryTime,CarryUserID,CarryUserName,ReceiveDate,ReceiveTime,ReceiveUserID,ReceiveUserName,TestSetFee,TestSetFeeFlag,ReqNotes,RequestNo,Urgent,H24UVolume,H24UTimePeriod,BodyTemp,BloodPressure,Confidential,SpecimenQuality,ReceiveHospitalID,ReceiveNotes,SpecialFlag,SpecialRowId,OrdDeptID,OrdDeptName,HospitalCode,HospitalName,WorkGroupMachineDR,TransmitDate,AssayNo,AcceptDate,AcceptTime,AcceptUserDR,ReportID,IsChanged,UpdateDate,UpdateTime,AddDate,AddTime,EpisodeNo,MsgType)
    Set ColFields="Code,Name,HospitalCode"
 	Set ^CacheTemp(repid,ind)=##Class(LIS.Util.Common).TransListNull(Data,ColFields)
 	Set ind=ind+1
	quit
}

ClassMethod GetRILabListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetRILabListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetRILabListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetRILabListExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {	
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

}
