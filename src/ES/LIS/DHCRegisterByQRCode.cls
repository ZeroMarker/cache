Class ES.LIS.DHCRegisterByQRCode Extends %RegisteredObject
{

/// zhangli 20210726
/// 把二维码信息登记进入中间表(RI_LabRequest,RI_LabTestSet)
/// w ##class(ES.LIS.DHCRegisterByQRCode).RegToMidLISByQRCodeMTHD("E000000014$@$0000000007$@$A0112103290001$@$张三$@$610125199188888888$@$M$@$55$@$岁$@$18666666666$@$SP003$@$A0121032900013   ^A0121032900014$@$L0013^L0014$@$$@$1^2$@$^$@$5667||1^5667||1$@$1^1$@$4^4$@$ZYZY025$@$2526$@$20210621$@$2021-06-21$@$17:33:00$@$$@$$@$$@$$@$$@$1966-01-12$@$O","","","","","","","","","","","","","","113^3^0^2^1")
ClassMethod RegToMidLISByQRCodeMTHD(SaveStr As %String(MAXLEN=32767), P1, P2, P3, P4, P5, P6, P7, P8, P9, P10, P11, P12, P13, Sessions, Output RowCount As %String) As %String
{
	s SaveStr=$g(SaveStr)
	q ##Class(LIS.WS.DHCLISServiceBase).DeclarativeTrans("ES.LIS.DHCRegisterByQRCode","RegToMidLISByQRCodeDo",SaveStr, "", "", "", "", "", "", "", "", "", "", "", "", "", Sessions,.RowCount)
}

/// zhangli 20210726
/// 把二维码信息登记到系统,登记进入中间表(RI_LabRequest,RI_LabTestSet)
/// w ##class(ES.LIS.DHCRegisterByQRCode).RegToMidLISByQRCodeDo("HJL2111170004$@$0000000002$@$HJL2111170011$@$1346$@$$@$2$@$30$@$岁$@$15596587423$@$SP001$@$HJL2111170052$@$L0198$@$$@$1$@$$@$JYL0001$@$1$@$07$@$ZYMZ001$@$YS01$@$20211117$@$2021-11-17$@$1:11:32$@$$@$$@$$@$$@$$@$1991-03-01$@$O","","","","","","","","","","","","","","113^3^0^2^1")
ClassMethod RegToMidLISByQRCodeDo(SaveStr As %String(MAXLEN=32767), P1, P2, P3, P4, P5, P6, P7, P8, P9, P10, P11, P12, P13, Sessions, Output RowCount As %String) As %String
{
	
	s ^MTMPLIS("RegToMidLISByQRCodeDo")=$lb(SaveStr, P1, P2, P3, P4, P5, P6, P7, P8, P9, P10, P11, P12, P13, Sessions)
	s RetValue=1
	//检验号(Labno) 登记号(RegNo) 就诊号(AdmLNo)  姓名(SurName) 身份证号(IDCardNo) 性别(PatSex) 年龄(PatAge) 年龄单位(PatAgeUnit) 手机号(MobileNo) 标本类型(SpecimenCode) 单机版医嘱流水号(OrdLocalNo) 医嘱(ExtTSCodes)  医嘱费用(ExtTSFees) 医嘱序号(SeqNos)     主医嘱顺序(MasterSeqNos)       医嘱项编码(ArcimRowIDs)      数量，数字(PackQtys)   费别 PAC_AdmReason->REA_Code(BillTypes) 科室(LocationCode) 医生(DoctorCode) 就诊日期(AdmDate) 申请日期(RequestDate) 申请时间（RequestTime） 采集用户(CollectUser) 采集日期(CollectDate) 采集时间(CollectTime)  病区(Ward) 床号(BedNo) 出生日期(BirthDate) 就诊类型(AdmissionTypeCode) 
	s SaveStr=$g(SaveStr)
	s Sessions=$g(Sessions)
	s HospitalDR=$p(Sessions,"^",5)
	s UserDR=$p(Sessions,"^",1)
	s CurDate=$zd(+$h,8)
	s CurDate=$tr(CurDate,"-")
	s CurTime=$p($h,",",2)
	s Labno=$p(SaveStr,"$@$",1)
	s RegNo=$p(SaveStr,"$@$",2)
	s AdmNo=$p(SaveStr,"$@$",3)
	s SurName=$p(SaveStr,"$@$",4)
	s IDCardNo=$p(SaveStr,"$@$",5)
	s PatSex=$p(SaveStr,"$@$",6)
	s PatAge=$p(SaveStr,"$@$",7)
	s PatAgeUnit=$p(SaveStr,"$@$",8)
	s MobileNo=$p(SaveStr,"$@$",9)
	s SpecimenCode=$p(SaveStr,"$@$",10)
	s OrdLocalNos=$p(SaveStr,"$@$",11)
	s ExtTSCodes=$p(SaveStr,"$@$",12)
	s ExtTSFees=$p(SaveStr,"$@$",13)
	s ExtTSSeqNos=$p(SaveStr,"$@$",14)
	s MasterSeqNos=$p(SaveStr,"$@$",15)
	s ArcimRowIDs=$p(SaveStr,"$@$",16)
	s PackQtys=$p(SaveStr,"$@$",17)
	s BillTypes=$p(SaveStr,"$@$",18)
	s LocationCode=$p(SaveStr,"$@$",19)
	s DoctorCode=$p(SaveStr,"$@$",20)
	s AdmDate=$p(SaveStr,"$@$",21)
	s RequestDate=$p(SaveStr,"$@$",22)
	s RequestTime=$p(SaveStr,"$@$",23)	
	s CollectUser=$p(SaveStr,"$@$",24)
	s CollectDate=$p(SaveStr,"$@$",25)
	s CollectTime=$p(SaveStr,"$@$",26)
	s Ward=$p(SaveStr,"$@$",27)
	s BedNo=$p(SaveStr,"$@$",28)
	s BirthDate=$p(SaveStr,"$@$",29)
	s AdmissionTypeCode=$p(SaveStr,"$@$",30)
	i '$l(AdmissionTypeCode) s AdmissionTypeCode="O"
	
	//必填项校验
	i '$l(RegNo)  throw ##class(%Exception.SystemException).%New("事务委托","D",,"-1^必填项登记号为空！")
	i '$l(AdmNo)  throw ##class(%Exception.SystemException).%New("事务委托","D",,"-1^必填项就诊号为空！")
	i '$l(SurName)  throw ##class(%Exception.SystemException).%New("事务委托","D",,"-1^必填项姓名为空！")
	i '$l(PatSex)  throw ##class(%Exception.SystemException).%New("事务委托","D",,"-1^必填项性别代码为空！")
	i '$l(AdmissionTypeCode)  throw ##class(%Exception.SystemException).%New("事务委托","D",,"-1^必填项就诊类型代码为空！")

	s VisitNumberFrom =##Class(LIS.Common.DHCVisitNumber).GetLabNoType(Labno) 	
	s HospitalCode="",HospitalName=""
	i $l(HospitalDR) d
	.s HospitalCode=$lg($g(^dbo.BTHospitalD(HospitalDR)),2)
	.s HospitalName=$lg($g(^dbo.BTHospitalD(HospitalDR)),3)

	//是否已接收校验--->已接收，直接返回成功，未接收，进行接收
	s RITestSetDR=$o(^dbo.RILabTestSetI("BarCode",Labno,""))
    i $l(RITestSetDR) 
    {
	   s RetValue=2 
	   q RetValue 
	}	
    //性别转换
	s SpeciesDR="",SpeciesCode="",SpeciesDesc=""
	i $l(PatSex),$d(^dbo.BTSpeciesI("IndexHISCode",##Class(LIS.Util.Common).IndexData(PatSex))) d
	.s SpeciesDR=$o(^dbo.BTSpeciesI("IndexHISCode",##Class(LIS.Util.Common).IndexData(PatSex),""))
	.i $l(SpeciesDR) d
	..s SpeciesDesc=$lg($g(^dbo.BTSpeciesD(SpeciesDR)),3)
	..s SpeciesCode=$lg($g(^dbo.BTSpeciesD(SpeciesDR)),2)
	i '$l(SpeciesDesc) throw ##class(%Exception.SystemException).%New("事务委托","D",,"-1^没有找到性别HISCode("_PatSex_")对应的维护信息！")
	//年龄转换
	s Age=PatAge
	s AgeUnit=""
	i PatAgeUnit="岁" s AgeUnit="Y"	
	e  i PatAgeUnit="月" s AgeUnit="M"	
	e  i PatAgeUnit="天" s AgeUnit="D"	
	e  i PatAgeUnit="小时" s AgeUnit="H"
	//标本类型转换	
	s SpecimenDR="",SpecimenDesc=""
	i $l(SpecimenCode),$d(^dbo.BTSpecimenI("IndexCode",HospitalDR,##Class(LIS.Util.Common).IndexData(SpecimenCode))) d
	.s SpecimenDR=$o(^dbo.BTSpecimenI("IndexCode",HospitalDR,##Class(LIS.Util.Common).IndexData(SpecimenCode),""))
	.i $l(SpecimenDR) d
	..s SpecimenDesc=$lg($g(^dbo.BTSpecimenD(SpecimenDR)),3)
	i '$l(SpecimenDesc) throw ##class(%Exception.SystemException).%New("事务委托","D",,"-1^没有找到标本类型Code("_SpecimenCode_")对应的维护信息！")
	//科室主键--->非必填项,传值的话再校验
	s LocationDR="",LocationDesc=""
	i $l(LocationCode),$d(^dbo.BTLocationI("IndexCode",HospitalDR,##Class(LIS.Util.Common).IndexData(LocationCode))) d
	.s LocationDR=$o(^dbo.BTLocationI("IndexCode",HospitalDR,##Class(LIS.Util.Common).IndexData(LocationCode),""))
	.i $l(LocationDR) d
	..s LocationDesc=$lg($g(^dbo.BTLocationD(LocationDR)),3)
	i ('$l(LocationDesc)),$l(LocationCode) throw ##class(%Exception.SystemException).%New("事务委托","D",,"-1^没有找到科室Code("_LocationCode_")对应的维护信息！")
	//医生主键--->非必填项,传值的话再校验
	s DoctorDR="",DoctorDesc=""
	i $l(DoctorCode),$d(^dbo.BTDoctorI("IndexCode",HospitalDR,##Class(LIS.Util.Common).IndexData(DoctorCode))) d
	.s DoctorDR=$o(^dbo.BTDoctorI("IndexCode",HospitalDR,##Class(LIS.Util.Common).IndexData(DoctorCode),""))
	.i $l(DoctorDR) d
	..s DoctorDesc=$lg($g(^dbo.BTDoctorD(DoctorDR)),3)
    i ('$l(DoctorDesc)),$l(DoctorCode) throw ##class(%Exception.SystemException).%New("事务委托","D",,"-1^没有找到医生Code("_DoctorCode_")对应的维护信息！")
    //已经存在的记录 ---> 更新患者信息即可
	s RILabRequestDR=$o(^dbo.RILabRequestI("PKRIRequest",VisitNumberFrom,AdmissionTypeCode,AdmNo,""))
    i $l(RILabRequestDR) d
	.s objLabRequest=##class(dbo.RILabRequest).%OpenId(RILabRequestDR)
    e  d
	.s objLabRequest=##class(dbo.RILabRequest).%New()
    s objLabRequest.VisitNumberFrom=VisitNumberFrom  
    s objLabRequest.AdmissionType=AdmissionTypeCode 
    s objLabRequest.RegNo=RegNo
    s objLabRequest.AdmNo=AdmNo
    s objLabRequest.MedicalRecordNo=""
    s objLabRequest.AdmDate=AdmDate
    s objLabRequest.AdmTime=""
    s objLabRequest.CertType=""
    s objLabRequest.CertNo=""
    s objLabRequest.IDNumber=IDCardNo
    s objLabRequest.PaymentType=""
    s objLabRequest.PaymentName=""
    s objLabRequest.SurName=SurName
    s objLabRequest.GivenName=SurName
    s objLabRequest.SpeciesID=SpeciesCode
    s objLabRequest.SpeciesName=SpeciesDesc
    s objLabRequest.BirthDate=BirthDate
    s objLabRequest.BirthTime=""
    s objLabRequest.Age=Age
    s objLabRequest.AgeUnit=AgeUnit
    s objLabRequest.Ethnicity=""
    s objLabRequest.HospitaID=""
    s objLabRequest.HospitaName=""
    s objLabRequest.SymptomID=""
    s objLabRequest.Symptom=""
    s objLabRequest.MobileNo=MobileNo
    s objLabRequest.PhoneNo=""
    s objLabRequest.email=""
    s objLabRequest.Height=""
    s objLabRequest.Weight=""
    s objLabRequest.BloodPressure=""
    s objLabRequest.ClinicalConditions=""
    s objLabRequest.Pregnant=""
    s objLabRequest.PregnantWeeks=""
    s objLabRequest.ABO=""
    s objLabRequest.RH=""
    s objLabRequest.Address=""
    s objLabRequest.PostCode=""
    s objLabRequest.InfectFlag=""
    s objLabRequest.InfectAlert=""
    s objLabRequest.PregnantNum=""
    s objLabRequest.ChildbirthNum=""
    s retvis=objLabRequest.%Save()
	If '($SYSTEM.Status.IsOK(retvis)) throw ##class(%Exception.SystemException).%New("事务委托","D",,"标本申请信息保存失败:"_$SYSTEM.Status.GetErrorText(retvis))
    s RILabRequestDR=objLabRequest.RowID
          
	s TestSetDRS="",TSCount=0,RepTestSetRowID=""
	f i=1:1:$l(ExtTSCodes,"^") d
	.s OneTestSetCode=$p(ExtTSCodes,"^",i)
	.i '$l(OneTestSetCode) q
	.s OneTestSetDesc=""
	.i $d(^dbo.BTTestSetI("IndexCode",HospitalDR,##Class(LIS.Util.Common).IndexData(OneTestSetCode))) d
	..s OneTestSetDR=$o(^dbo.BTTestSetI("IndexCode",HospitalDR,##Class(LIS.Util.Common).IndexData(OneTestSetCode),""))
    ..s OneTestSetDesc=$lg($g(^dbo.BTTestSetD(OneTestSetDR)),3)
    ..//重复的医嘱ID(HISOrderID或者自定义)不让再次接收
    .s TestSetRowID=$p(OrdLocalNos,"^",i)
    .s RepeatFlag=..IsRepeatTS(RILabRequestDR, TestSetRowID)
    .i RepeatFlag=1 s RepTestSetRowID=RepTestSetRowID_","_TestSetRowID q  //重复的医嘱不让接收
    .//医嘱中间表
    .i '$l(OneTestSetDesc) throw ##class(%Exception.SystemException).%New("事务委托","D",,"没有找到医嘱Code为("_OneTestSetCode_")的医嘱")
    .s objLabTestSet=##class(dbo.RILabTestSet).%New()
    .s objLabTestSet.VisitNumberDR=RILabRequestDR 
    .s objLabTestSet.TestSetCode=OneTestSetCode
    .s objLabTestSet.TestSetName=OneTestSetDesc
    .s objLabTestSet.TestSetRowID=$p(OrdLocalNos,"^",i)  
    .s objLabTestSet.Sequence=$p(ExtTSSeqNos,"^",i)  
    .s objLabTestSet.BarCode=Labno
    .s objLabTestSet.ArticleBarCode=""
    .s objLabTestSet.TestSetState="1"   //1：登记，2：打印条码，3：采集，4：标本运送，5：标本接收，6：停止，7：作废，8.拒收,10:打包，11：送达,13:护士执行（条码生成）
    .s objLabTestSet.VisitNumberTestSetCode=""
    .s objLabTestSet.SpecimenCode=SpecimenCode
    .s objLabTestSet.SpecimenName=SpecimenDesc    
    .s objLabTestSet.ContainerCode=""
    .s objLabTestSet.ContainerName=""
    .s objLabTestSet.CollectNotes=""
    .s objLabTestSet.LocationCode=LocationCode
    .s objLabTestSet.LocationName=LocationDesc    
    .s objLabTestSet.WardCode=Ward
    .s objLabTestSet.WardName=Ward
    .s objLabTestSet.BedNo=BedNo
    .s objLabTestSet.DotorID=DoctorCode
    .s objLabTestSet.DotorName=DoctorDesc        
    .s objLabTestSet.RequestDate=RequestDate
    .s objLabTestSet.RequestTime=RequestTime
    .s objLabTestSet.PrinterID=""
    .s objLabTestSet.PrinterName=""
    .s objLabTestSet.PrintDate=""
    .s objLabTestSet.PrintTime=""
    .s objLabTestSet.PrintStatus=""
    .s objLabTestSet.CollectDate=CollectDate
    .s objLabTestSet.CollectTime=CollectTime
    .s objLabTestSet.CollectUserID=""
    .s objLabTestSet.CollectUserName=""
    .s objLabTestSet.AnatomicalSite=""
    .s objLabTestSet.CollectPositon=""
    .s objLabTestSet.CarryDate=""
    .s objLabTestSet.CarryTime=""
    .s objLabTestSet.CarryUserID=""
    .s objLabTestSet.CarryUserName=""
    .s objLabTestSet.ReceiveDate=""
    .s objLabTestSet.ReceiveTime=""
    .s objLabTestSet.ReceiveUserID=""
    .s objLabTestSet.ReceiveUserName=""
    .s objLabTestSet.TestSetFee=$p(ExtTSFees,"^",i)  
    .s objLabTestSet.TestSetFeeFlag="2"
    .s objLabTestSet.ReqNotes=""
    .s objLabTestSet.RequestNo=""
    .s objLabTestSet.Urgent=""
    .s objLabTestSet.H24UVolume=""
    .s objLabTestSet.H24UTimePeriod=""
    .s objLabTestSet.BodyTemp=""
    .s objLabTestSet.BloodPressure=""
    .s objLabTestSet.Confidential=""
    .s objLabTestSet.SpecimenQuality=""
    .s objLabTestSet.ReceiveHospitalID=""
    .s objLabTestSet.ReceiveNotes=""
    .s objLabTestSet.SpecialFlag=""
    .s objLabTestSet.SpecialRowId=""
    .s objLabTestSet.OrdDeptID=""
    .s objLabTestSet.OrdDeptName=""
    .s objLabTestSet.HospitalCode=HospitalCode
    .s objLabTestSet.HospitalName=HospitalName
    .s objLabTestSet.WorkGroupMachineDR=2
    .s objLabTestSet.TransmitDate="" //20210929
    .s objLabTestSet.AssayNo="" //Labno //"A012103290003"
    .s objLabTestSet.AcceptDate="" //20210929
    .s objLabTestSet.AcceptTime="" //67192
    .s objLabTestSet.AcceptUserDR="" //113
    .s objLabTestSet.ReportID="" //"123457"
    .s objLabTestSet.IsChanged="1"
    .s objLabTestSet.UpdateDate=""
    .s objLabTestSet.UpdateTime=""
    .i '$l(objLabTestSet.AddDate) s objLabTestSet.AddDate=CurDate
    .i '$l(objLabTestSet.AddTime) s objLabTestSet.AddTime=CurTime    
    .s retvis=objLabTestSet.%Save()
	.If '($SYSTEM.Status.IsOK(retvis)) throw ##class(%Exception.SystemException).%New("事务委托","D",,"医嘱信息保存失败:"_$SYSTEM.Status.GetErrorText(retvis))
    .s TSCount=TSCount+1
    i TSCount<=0 throw ##class(%Exception.SystemException).%New("事务委托","D",,"没有可登记新医嘱,医嘱ID("_RepTestSetRowID_")已存在")
    
    //RI_LabOPRecord中间表修改的记录
    s objLabOPRecord=##class(dbo.RILabOPRecord).%New()
    s objLabOPRecord.BarCode=Labno
    s objLabOPRecord.OperateDate=CurDate
    s objLabOPRecord.OperateTime=CurTime
    s objLabOPRecord.OperateUserDR=UserDR
    s OperateTypeCode="4" //接收
    s OperateTypeDR=$o(^dbo.BTOperatorTypeI("IndexCode",##Class(LIS.Util.Common).IndexData(OperateTypeCode),""))
    s objLabOPRecord.OperateTypeDR=OperateTypeDR  
    s objLabOPRecord.OperateNotes=""
    s objLabOPRecord.OperateIP=""
    s objLabOPRecord.OperateAddress=""
    s retvis=objLabOPRecord.%Save()
    If '($SYSTEM.Status.IsOK(retvis)) throw ##class(%Exception.SystemException).%New("事务委托","D",,"3)标本接收前操作记录保存失败:"_$SYSTEM.Status.GetErrorText(retvis))	
	q RetValue
}

/// w ##Class(ES.LIS.DHCRegisterByQRCode).IsRepeatTS(Labno) 
/// 医嘱重复性校验
ClassMethod IsRepeatTS(VisitNumberDR, TestSetRowID) As %String
{
	s VisitNumberDR=$g(VisitNumberDR),TestSetRowID=$g(TestSetRowID)
	s IndexTestSetRowID=TestSetRowID //##Class(LIS.Util.Common).IndexData(TestSetRowID)
    s IsRepeatFlag=0
    s Sequence="" f Sequence="" s Sequence=$o(^dbo.RILabTestSetI("PKRITestSet",VisitNumberDR,IndexTestSetRowID,Sequence)) q:Sequence=""  d
    .s RITestSetDR=$o(^dbo.RILabTestSetI("PKRITestSet",VisitNumberDR,IndexTestSetRowID,Sequence,""))
    .s IsRepeatFlag=1
    q IsRepeatFlag
}

/// zhangli 20210801
/// 根据检验号删除中间表数据(RI_LabRequest,RI_LabTestSet)，已经和检验相关标本表发生关联的不删除
/// w ##class(ES.LIS.DHCRegisterByQRCode).DeleteLabInfoMTHD("A012103290002","0000000007","A0112103290001","","","","","","","","","","","","113^7^0^12^1")
ClassMethod DeleteLabInfoMTHD(LabNo As %String(MAXLEN=32767), RegNo, AdmNo, AdmissionType, P4, P5, P6, P7, P8, P9, P10, P11, P12, P13, Sessions, Output RowCount As %String) As %String
{
	s LabNo=$g(LabNo),RegNo=$g(RegNo),AdmNo=$g(AdmNo),AdmissionType=$g(AdmissionType)
	q ##Class(LIS.WS.DHCLISServiceBase).DeclarativeTrans("ES.LIS.DHCRegisterByQRCode","DeleteLabInfoDo",LabNo, RegNo, AdmNo, AdmissionType, "", "", "", "", "", "", "", "", "", "", Sessions,.RowCount)
}

/// zhangli 20210801
/// 根据检验号删除中间表数据(RI_LabRequest,RI_TestSet)，已经和检验相关标本表发生关联的不删除
/// w ##class(ES.LIS.DHCRegisterByQRCode).DeleteLabInfoDo("A012103290001","0000000007","A0112103290001","","","","","","","","","","","","113^7^0^12^1")
ClassMethod DeleteLabInfoDo(LabNo As %String(MAXLEN=32767), RegNo, AdmNo, AdmissionType, P4, P5, P6, P7, P8, P9, P10, P11, P12, P13, Sessions, Output RowCount As %String) As %String
{
	s LabNo=$g(LabNo),RegNo=$g(RegNo),AdmNo=$g(AdmNo),AdmissionType=$g(AdmissionType)
	s ^MTMPLIS("DeleteLabInfoDo")=$lb(LabNo, RegNo, AdmNo, AdmissionType, P4, P5, P6, P7, P8, P9, P10, P11, P12, P13, Sessions)

    s RetValue=1
    s LinkFkag=0
    s RPVisitNumberDR = $o(^dbo.RPVisitNumberI("IndexVisitNumber",##Class(LIS.Util.Common).IndexData(LabNo),""))
    i $l(RPVisitNumberDR) d
    .s fTestSetDR="" f  s fTestSetDR=$o(^dbo.RPVisitNumberTestSetI("IndexMaster",RPVisitNumberDR,fTestSetDR)) q:fTestSetDR=""  d
    ..//标本类型
    ..s VisNumTSDR=$o(^dbo.RPVisitNumberTestSetI("IndexMaster",RPVisitNumberDR,fTestSetDR,""))
    ..s Recieved=$lg($g(^dbo.RPVisitNumberTestSetD(VisNumTSDR)),4)
    ..i Recieved=1  s LinkFkag=1
    i LinkFkag=1 throw ##class(%Exception.SystemException).%New("事务委托","D",,"-1^条码"_LabNo_"已经在系统里发生关联业务(接收...)，不能删除！")   
	s fRITestSetDR="" f  s fRITestSetDR=$o(^dbo.RILabTestSetI("BarCode",LabNo,"")) q:fRITestSetDR=""  d
	.s ret=##class(dbo.RILabTestSet).%DeleteId(fRITestSetDR)
	.i '($SYSTEM.Status.IsOK(ret)) throw ##class(%Exception.SystemException).%New("事务委托","D",,"删除对应医嘱中间表失败:"_$SYSTEM.Status.GetErrorText(ret))
    q RetValue
}

/// zhangli 20210726
/// 给中间表数据插入数据(RI_LabRequest,RI_LabTestSet)，如果是给应急库插入的(IsUseBD=2),还需要同步更新应急库的业务表
/// w ##class(ES.LIS.DHCRegisterByQRCode).SyncRILabRequestTSMTHD("<Request><LabRequestMsg><VisitNumberFrom>YG</VisitNumberFrom><AdmissionType>O</AdmissionType><RegNo>0000000007</RegNo><AdmNo>A0112103290001</AdmNo><MedicalRecordNo></MedicalRecordNo><AdmDate>20210621</AdmDate><AdmTime></AdmTime><CertType></CertType><CertNo></CertNo><IDNumber>610125199188888888</IDNumber><PaymentType></PaymentType><PaymentName></PaymentName><SurName>张三</SurName><GivenName>张三</GivenName><SpeciesID>M</SpeciesID><SpeciesName>男</SpeciesName><BirthDate>19660112</BirthDate><BirthTime></BirthTime><Age>55</Age><AgeUnit>岁</AgeUnit><Ethnicity></Ethnicity><HospitaID>DHSZHYYZY</HospitaID><HospitaName>标准版数字化医院[总院]</HospitaName><SymptomID></SymptomID><Symptom></Symptom><MobileNo>18666666666</MobileNo><PhoneNo></PhoneNo><email></email><Height></Height><Weight></Weight><BloodPressure></BloodPressure><ClinicalConditions></ClinicalConditions><Pregnant></Pregnant><PregnantWeeks></PregnantWeeks><ABO></ABO><RH></RH><Address></Address><PostCode></PostCode><InfectFlag></InfectFlag><InfectAlert></InfectAlert><PregnantNum></PregnantNum><ChildbirthNum></ChildbirthNum><LabTestSetMsgs><LabTestSetMsg><VisitNumberDR>1</VisitNumberDR><TestSetCode>L0013</TestSetCode><TestSetName>脑脊液常规</TestSetName><TestSetRowID>A0121032900017</TestSetRowID><Sequence>1</Sequence><BarCode>E000000016</BarCode><ArticleBarCode></ArticleBarCode><TestSetState>7</TestSetState><VisitNumberTestSetCode>L0013</VisitNumberTestSetCode><SpecimenCode></SpecimenCode><SpecimenName></SpecimenName><ContainerCode></ContainerCode><ContainerName></ContainerName><CollectNotes></CollectNotes><LocationCode>ZYZY025</LocationCode><LocationName>泌尿外科</LocationName><WardCode></WardCode><WardName></WardName><BedNo>张启林</BedNo><DotorID>2021-06-21</DotorID><DotorName>17:33:00</DotorName><RequestDate></RequestDate><RequestTime></RequestTime><PrinterID></PrinterID><PrinterName></PrinterName><PrintDate></PrintDate><PrintTime></PrintTime><PrintStatus></PrintStatus><CollectDate></CollectDate><CollectTime></CollectTime><CollectUserID></CollectUserID><CollectUserName></CollectUserName><AnatomicalSite></AnatomicalSite><CollectPositon></CollectPositon><CarryDate></CarryDate><CarryTime></CarryTime><CarryUserID></CarryUserID><CarryUserName></CarryUserName><ReceiveDate></ReceiveDate><ReceiveTime></ReceiveTime><ReceiveUserID></ReceiveUserID><ReceiveUserName>dhcc</ReceiveUserName><TestSetFee></TestSetFee><TestSetFeeFlag>2</TestSetFeeFlag><ReqNotes></ReqNotes><RequestNo></RequestNo><Urgent></Urgent><H24UVolume></H24UVolume><H24UTimePeriod></H24UTimePeriod><BodyTemp></BodyTemp><BloodPressure></BloodPressure><Confidential></Confidential><SpecimenQuality></SpecimenQuality><ReceiveHospitalID>DHSZHYYZY</ReceiveHospitalID><ReceiveNotes></ReceiveNotes><SpecialFlag></SpecialFlag><SpecialRowId></SpecialRowId><OrdDeptID></OrdDeptID><OrdDeptName></OrdDeptName><HospitalCode>DHSZHYYZY</HospitalCode><HospitalName>标准版数字化医院[总院]</HospitalName><WorkGroupMachineDR></WorkGroupMachineDR><TransmitDate></TransmitDate><AssayNo></AssayNo><AcceptDate></AcceptDate><AcceptTime></AcceptTime><AcceptUserDR>113</AcceptUserDR><ReportID>183</ReportID><IsChanged>1</IsChanged><UpdateDate></UpdateDate><UpdateTime></UpdateTime><AddDate>20211101</AddDate><AddTime>41843</AddTime></LabTestSetMsg></LabTestSetMsgs></LabRequestMsg></Request>","2",$c(0),$c(0),$c(0),$c(0),$c(0),$c(0),$c(0),$c(0),$c(0),$c(0),$c(0),$c(0),"113^7^0^12^1^^JSON")
ClassMethod SyncRILabRequestTSMTHD(Input As %String(MAXLEN=32767), IsUseBD, P2, P3, P4, P5, P6, P7, P8, P9, P10, P11, P12, P13, Sessions, Output RowCount As %String) As %String
{
	s Input=$g(Input)
	s IsUseBD=$g(IsUseBD)
	//q ##Class(ES.LIS.DHCRegisterByQRCode).SyncRILabRequestTSDo(Input, IsUseBD, P2, P3, P4, P5, P6, P7, P8, P9, P10, P11, P12, P13, Sessions,.RowCount)
	q ##Class(LIS.WS.DHCLISServiceBase).DeclarativeTrans("ES.LIS.DHCRegisterByQRCode","SyncRILabRequestTSDo",Input, IsUseBD, P2, P3, P4, P5, P6, P7, P8, P9, P10, P11, P12, P13, Sessions,.RowCount)
}

/// zhangli 20210726
/// 给中间表数据插入数据(RI_LabRequest,RI_LabTestSet)，如果是给应急库插入的(IsUseBD=2),还需要同步更新应急库的业务表
/// w ##class(ES.LIS.DHCRegisterByQRCode).SyncRILabRequestTSDo("A012103290001$@$0000000007$@$$@$张三$@$610125199188888888$@$1$@$$@$18666666666$@$SP003$@$A012103290001^A012103290002$@$L0011^L0012$@$$@$ZYZY025$@$2526$@$20210621$@$2021-06 21:17:33$@$$@$$@$$@$$@$19660112$@$","","","","","","","","","","","","","","113^7^0^12^1")
/// w ##class(ES.LIS.DHCRegisterByQRCode).SyncRILabRequestTSDo("","","","","","","","","","","","","","","113^7^0^12^1")
ClassMethod SyncRILabRequestTSDo(Input As %String(MAXLEN=32767), IsUseBD, P2, P3, P4, P5, P6, P7, P8, P9, P10, P11, P12, P13, Sessions, Output RowCount As %String) As %String
{
    s Input=$g(Input)
	s IsUseBD=$g(IsUseBD)	
	//s ^MTMPLIS("SyncRILabRequestTSDo")=$lb(Input, IsUseBD, P2, P3, P4, P5, P6, P7, P8, P9, P10, P11, P12, P13, Sessions)
	//q "1"
    //s Input=$lg(^MTMPLIS("SyncRILabRequestTSDo"),1)
    //s IsUseBD=$lg(^MTMPLIS("SyncRILabRequestTSDo"),2)
	s RetValue=1
	b //1.0
	s RetXMLData= ##class(LIS.Util.COM.XML).FromXML(Input)
	s num=0
	while RetXMLData.Next() 
	{
	    s objRequestMsg=RetXMLData.Get(num)
		i '$l(objRequestMsg) continue
		s num=num+1
		
		s VisitNumberFrom=objRequestMsg.VisitNumberFrom
		s AdmissionTypeCode=objRequestMsg.AdmissionType
		s AdmNo=objRequestMsg.AdmNo
		s RILabRequestDR=$o(^dbo.RILabRequestI("PKRIRequest",VisitNumberFrom,AdmissionTypeCode,AdmNo,""))
		i $l(RILabRequestDR) d
		.s objLabRequest=##class(dbo.RILabRequest).%OpenId(RILabRequestDR)
		e  d
		.s objLabRequest=##class(dbo.RILabRequest).%New()
		s objLabRequest.VisitNumberFrom=objRequestMsg.VisitNumberFrom
		s objLabRequest.AdmissionType=objRequestMsg.AdmissionType 
		s objLabRequest.RegNo=objRequestMsg.RegNo
		s objLabRequest.AdmNo=objRequestMsg.AdmNo
		s objLabRequest.MedicalRecordNo=objRequestMsg.MedicalRecordNo
		s objLabRequest.AdmDate=objRequestMsg.AdmDate
		s objLabRequest.AdmTime=objRequestMsg.AdmTime
		s objLabRequest.CertType=objRequestMsg.CertType
		s objLabRequest.CertNo=objRequestMsg.CertNo
		s objLabRequest.IDNumber=objRequestMsg.IDNumber
		s objLabRequest.PaymentType=objRequestMsg.PaymentType
		s objLabRequest.PaymentName=objRequestMsg.PaymentName
		s objLabRequest.SurName=objRequestMsg.SurName
		s objLabRequest.GivenName=objRequestMsg.GivenName
		s objLabRequest.SpeciesID=objRequestMsg.SpeciesID
		s objLabRequest.SpeciesName=objRequestMsg.SpeciesName
		s objLabRequest.BirthDate=objRequestMsg.BirthDate
		s objLabRequest.BirthTime=objRequestMsg.BirthTime
		s objLabRequest.Age=objRequestMsg.Age
		s objLabRequest.AgeUnit=objRequestMsg.AgeUnit
		s objLabRequest.Ethnicity=objRequestMsg.Ethnicity
		s objLabRequest.HospitaID=objRequestMsg.HospitaID
		s objLabRequest.HospitaName=objRequestMsg.HospitaName
		s objLabRequest.SymptomID=objRequestMsg.SymptomID
		s objLabRequest.Symptom=objRequestMsg.Symptom
		s objLabRequest.MobileNo=objRequestMsg.MobileNo
		s objLabRequest.PhoneNo=objRequestMsg.PhoneNo
		s objLabRequest.email=objRequestMsg.email
		s objLabRequest.Height=objRequestMsg.Height
		s objLabRequest.Weight=objRequestMsg.Weight
		s objLabRequest.BloodPressure=objRequestMsg.BloodPressure
		s objLabRequest.ClinicalConditions=objRequestMsg.ClinicalConditions
		s objLabRequest.Pregnant=objRequestMsg.Pregnant
		s objLabRequest.PregnantWeeks=objRequestMsg.PregnantWeeks
		s objLabRequest.ABO=objRequestMsg.ABO
		s objLabRequest.RH=objRequestMsg.RH
		s objLabRequest.Address=objRequestMsg.Address
		s objLabRequest.PostCode=objRequestMsg.PostCode
		s objLabRequest.InfectFlag=objRequestMsg.InfectFlag
		s objLabRequest.InfectAlert=objRequestMsg.InfectAlert
		s objLabRequest.PregnantNum=objRequestMsg.PregnantNum
		s objLabRequest.ChildbirthNum=objRequestMsg.ChildbirthNum
		s retvis=objLabRequest.%Save()
		If '($SYSTEM.Status.IsOK(retvis)) throw ##class(%Exception.SystemException).%New("事务委托","D",,"标本申请信息保存失败:"_$SYSTEM.Status.GetErrorText(retvis))
		s RILabRequestDR=objLabRequest.RowID		
		s TestSetMsgsLen=objRequestMsg.LabTestSetMsgs.Length()
		f j=0:1:(TestSetMsgsLen-1)
		{
			s objTestSetMsg=objRequestMsg.LabTestSetMsgs.Get(j)
			i '$l(objTestSetMsg) continue
			//Index IndexMaster On (VisitNumberDR, TestSetRowID, Sequence) [ SqlName = Index_Master, Type = index, Unique ];
			s VisitNumberDR=RILabRequestDR //objTestSetMsg.VisitNumberDR 					
		    s TestSetRowID=objTestSetMsg.TestSetRowID
		    s Sequence=objTestSetMsg.Sequence
            s LabTestSetDR=$o(^dbo.RILabTestSetI("IndexMaster",RILabRequestDR,TestSetRowID,Sequence,""))
		    i $l(LabTestSetDR) d  
		    .s objLabTestSet=##class(dbo.RILabTestSet).%OpenId(LabTestSetDR)
		    e  d
		    .s objLabTestSet=##class(dbo.RILabTestSet).%New()
            s objLabTestSet.VisitNumberDR=RILabRequestDR
			s objLabTestSet.TestSetCode=objTestSetMsg.TestSetCode 
			s objLabTestSet.TestSetName=objTestSetMsg.TestSetName 
			s objLabTestSet.TestSetRowID=objTestSetMsg.TestSetRowID 
			s objLabTestSet.Sequence=objTestSetMsg.Sequence 
			s objLabTestSet.BarCode=objTestSetMsg.BarCode 
			s objLabTestSet.ArticleBarCode=objTestSetMsg.ArticleBarCode 
			s objLabTestSet.TestSetState=objTestSetMsg.TestSetState    //1：登记，2：打印条码，3：采集，4：标本运送，5：标本接收，6：停止，7：作废，8.拒收,10:打包，11：送达,13:护士执行（条码生成）
			s objLabTestSet.VisitNumberTestSetCode=objTestSetMsg.VisitNumberTestSetCode 
			s objLabTestSet.SpecimenCode=objTestSetMsg.SpecimenCode 
			s objLabTestSet.SpecimenName=objTestSetMsg.SpecimenName     
			s objLabTestSet.ContainerCode=objTestSetMsg.ContainerCode 
			s objLabTestSet.ContainerName=objTestSetMsg.ContainerName 
			s objLabTestSet.CollectNotes=objTestSetMsg.CollectNotes 
			s objLabTestSet.LocationCode=objTestSetMsg.LocationCode 
			s objLabTestSet.LocationName=objTestSetMsg.LocationName     
			s objLabTestSet.WardCode=objTestSetMsg.WardCode 
			s objLabTestSet.WardName=objTestSetMsg.WardName 
			s objLabTestSet.BedNo=objTestSetMsg.BedNo 
			s objLabTestSet.DotorID=objTestSetMsg.DotorID 
			s objLabTestSet.DotorName=objTestSetMsg.DotorName         
			s objLabTestSet.RequestDate=objTestSetMsg.RequestDate 
			s objLabTestSet.RequestTime=objTestSetMsg.RequestTime 
			s objLabTestSet.PrinterID=objTestSetMsg.PrinterID 
			s objLabTestSet.PrinterName=objTestSetMsg.PrinterName 
			s objLabTestSet.PrintDate=objTestSetMsg.PrintDate 
			s objLabTestSet.PrintTime=objTestSetMsg.PrintTime 
			s objLabTestSet.PrintStatus=objTestSetMsg.PrintStatus 
			s objLabTestSet.CollectDate=objTestSetMsg.CollectDate 
			s objLabTestSet.CollectTime=objTestSetMsg.CollectTime 
			s objLabTestSet.CollectUserID=objTestSetMsg.CollectUserID 
			s objLabTestSet.CollectUserName=objTestSetMsg.CollectUserName 
			s objLabTestSet.AnatomicalSite=objTestSetMsg.AnatomicalSite 
			s objLabTestSet.CollectPositon=objTestSetMsg.CollectPositon 
			s objLabTestSet.CarryDate=objTestSetMsg.CarryDate 
			s objLabTestSet.CarryTime=objTestSetMsg.CarryTime 
			s objLabTestSet.CarryUserID=objTestSetMsg.CarryUserID 
			s objLabTestSet.CarryUserName=objTestSetMsg.CarryUserName 
			s objLabTestSet.ReceiveDate=objTestSetMsg.ReceiveDate 
			s objLabTestSet.ReceiveTime=objTestSetMsg.ReceiveTime 
			s objLabTestSet.ReceiveUserID=objTestSetMsg.ReceiveUserID 
			s objLabTestSet.ReceiveUserName=objTestSetMsg.ReceiveUserName 
			s objLabTestSet.TestSetFee=objTestSetMsg.TestSetFee  
			s objLabTestSet.TestSetFeeFlag=objTestSetMsg.TestSetFeeFlag 
			s objLabTestSet.ReqNotes=objTestSetMsg.ReqNotes 
			s objLabTestSet.RequestNo=objTestSetMsg.RequestNo 
			s objLabTestSet.Urgent=objTestSetMsg.Urgent 
			s objLabTestSet.H24UVolume=objTestSetMsg.H24UVolume 
			s objLabTestSet.H24UTimePeriod=objTestSetMsg.H24UTimePeriod 
			s objLabTestSet.BodyTemp=objTestSetMsg.BodyTemp 
			s objLabTestSet.BloodPressure=objTestSetMsg.BloodPressure 
			s objLabTestSet.Confidential=objTestSetMsg.Confidential 
			s objLabTestSet.SpecimenQuality=objTestSetMsg.SpecimenQuality 
			s objLabTestSet.ReceiveHospitalID=objTestSetMsg.ReceiveHospitalID 
			s objLabTestSet.ReceiveNotes=objTestSetMsg.ReceiveNotes 
			s objLabTestSet.SpecialFlag=objTestSetMsg.SpecialFlag 
			s objLabTestSet.SpecialRowId=objTestSetMsg.SpecialRowId 
			s objLabTestSet.OrdDeptID=objTestSetMsg.OrdDeptID 
			s objLabTestSet.OrdDeptName=objTestSetMsg.OrdDeptName 
			s objLabTestSet.HospitalCode=objTestSetMsg.HospitalCode 
			s objLabTestSet.HospitalName=objTestSetMsg.HospitalName 
			s objLabTestSet.WorkGroupMachineDR=objTestSetMsg.WorkGroupMachineDR 
			s objLabTestSet.TransmitDate=objTestSetMsg.TransmitDate 
			s objLabTestSet.AssayNo=objTestSetMsg.AssayNo 
			s objLabTestSet.AcceptDate=objTestSetMsg.AcceptDate 
			s objLabTestSet.AcceptTime=objTestSetMsg.AcceptTime 
			s objLabTestSet.AcceptUserDR=objTestSetMsg.AcceptUserDR 
			s objLabTestSet.ReportID=objTestSetMsg.ReportID 
			s objLabTestSet.IsChanged=objTestSetMsg.IsChanged 
			s objLabTestSet.UpdateDate=objTestSetMsg.UpdateDate 
			s objLabTestSet.UpdateTime=objTestSetMsg.UpdateTime 
            s objLabTestSet.AddDate=objTestSetMsg.AddDate 
            s objLabTestSet.AddTime=objTestSetMsg.AddTime    
			s retvis=objLabTestSet.%Save()
			If '($SYSTEM.Status.IsOK(retvis)) throw ##class(%Exception.SystemException).%New("事务委托","D",,"医嘱信息保存失败:"_$SYSTEM.Status.GetErrorText(retvis))		        
            /*走消息表同步正式库数据模式后底下的分支废弃了*************************************************************************************************************************/

                 
            //对比应急库业务表状态"大于"中间表的时候,执行逆流程操作   
            //s BackFlag = "0"
            //s VNDR=$o(^dbo.RPVisitNumberI("IndexVisitNumber",##Class(LIS.Util.Common).IndexData(objTestSetMsg.BarCode),""))
	        //i '$l(VNDR) s BackFlag="0" 
	           
            //根据中间表字段状态把应急库的业务表更新到指定字段
		    i 1=2 //(objTestSetMsg.IsChanged=1) 
            {	
                //计划任务固定Sessions
                s Sessions="113^7^0^12^1"  //用户(dhcc):113,工作组(临床基础检验室):7,医院ID：1    
                s VNDR=$o(^dbo.RPVisitNumberI("IndexVisitNumber",##Class(LIS.Util.Common).IndexData(objTestSetMsg.BarCode),""))
	            i '$l(VNDR)  q //throw ##class(%Exception.SystemException).%New("事务委托","D",,"未找到对应的检验号"_objTestSetMsg.BarCode)	
	            s fTestSetDR="",TargetRepDR="",TargetWGMDR="",TargetRecieved="",TargetLabno="",TargetTSDRlist=""
		        for  
		        {		 
			        s fTestSetDR=$o(^dbo.RPVisitNumberTestSetI("IndexMaster",VNDR,fTestSetDR)) 
			        q:fTestSetDR=""
			        s VNTSDR=$o(^dbo.RPVisitNumberTestSetI("IndexMaster",VNDR,fTestSetDR,"")) 
			        s VNTSData=$g(^dbo.RPVisitNumberTestSetD(VNTSDR))
			        s HISOrderID=$lg(VNTSData,10)
			        i objTestSetMsg.TestSetRowID'=HISOrderID  continue 
			        s tmpTestSetDR=$lg(VNTSData,2)
			        s tmpTestSetDR=$lg(VNTSData,3) 
			        i '$l(TargetTSDRlist) s TargetTSDRlist=tmpTestSetDR
			        e  s TargetTSDRlist=TargetTSDRlist_"^"_tmpTestSetDR
			        s TargetRecieved=$lg(VNTSData,4)
			        s TargetWGMDR=$lg(VNTSData,5)
			        s TargetRepDR=$lg(VNTSData,11)
			        s TargetLabno=objTestSetMsg.BarCode
			        
			    }
	            
	            //应急库存业务表存在数据的话做同步修改	            
	            i $l(objTestSetMsg.AcceptDate) //中间表核收状态
	            {		             
			          //应急库发生业务
			          i $l(TargetRepDR)
			          {
				         s TargetRepData=$g(^dbo.RPVisitNumberReportD(TargetRepDR))
				         s WorkGroupMachineDR=$lg(TargetRepData,4)
				         s Status=$lg(TargetRepData,22)
				         //审核状态调用取审方法
				         i Status="3"
				         {
					         s ret= ##class(ES.LIS.DHCTransferEmergentData).ReportUndoMTHD(TargetRepDR,WorkGroupMachineDR,"","","","","","","","","","","","",Sessions)
					         i $p(ret,"^",1)'=1  throw ##class(%Exception.SystemException).%New("事务委托","D",,"取审应急库报告失败:"_ret)	
					     }
				      }			          		            		              		              
		        }
		        elseif $l(objTestSetMsg.ReceiveDate) //中间表接收状态
		        {		        
			       	  //应急库发生业务
			          i $l(TargetRepDR)
			          {
				         s TargetRepData=$g(^dbo.RPVisitNumberReportD(TargetRepDR))
				         s WorkGroupMachineDR=$lg(TargetRepData,4)
				         s Status=$lg(TargetRepData,22)
				         
				         //审核状态调用取审方法
				         //报告状态(1登记，2初审，3审核，4复查，5取消审核，6作废，O其他)
				         i Status="3"
				         {
					         //取审
					         s ret = ##class(ES.LIS.DHCTransferEmergentData).ReportUndoMTHD(TargetRepDR,WorkGroupMachineDR,"","","","","","","","","","","","",Sessions)
					         i $p(ret,"^",1)'=1  throw ##class(%Exception.SystemException).%New("事务委托","D",,"应急库取审报告失败:"_ret)
					         
					         //返回登记
					         s ret = ##class(ES.LIS.DHCTransferEmergentData).ReportToRegMTHD(TargetRepDR,"","","","","","","","","","","","","",Sessions)
					         i $p(ret,"^",1)'=1  throw ##class(%Exception.SystemException).%New("事务委托","D",,"应急库返回登记报告失败:"_ret)
					         	
					         //清除结果
					         s ret = ##class(ES.LIS.DHCTransferEmergentData).ClearResultMTHD(TargetRepDR,"","","","","","","","","","","","","",Sessions)
					         i $p(ret,"^",1)'=1  throw ##class(%Exception.SystemException).%New("事务委托","D",,"应急库清除结果失败:"_ret)
				
					     }
					     elseif ((Status="2")||(Status="4")||(Status="5"))
					     {
						     //返回登记
					         s ret = ##class(ES.LIS.DHCTransferEmergentData).ReportToRegMTHD(TargetRepDR,"","","","","","","","","","","","","",Sessions)
					         i $p(ret,"^",1)'=1  throw ##class(%Exception.SystemException).%New("事务委托","D",,"应急库返回登记报告失败:"_ret)
					         	
					         //清除结果
					         s ret = ##class(ES.LIS.DHCTransferEmergentData).ClearResultMTHD(TargetRepDR,"","","","","","","","","","","","","",Sessions)
					         i $p(ret,"^",1)'=1  throw ##class(%Exception.SystemException).%New("事务委托","D",,"应急库清除结果失败:"_ret)
					         
						 }
						 elseif Status="1"   
						 {
					     	 //清除结果
					         s ret = ##class(ES.LIS.DHCTransferEmergentData).ClearResultMTHD(TargetRepDR,"","","","","","","","","","","","","",Sessions)
					         i $p(ret,"^",1)'=1  throw ##class(%Exception.SystemException).%New("事务委托","D",,"应急库清除结果失败:"_ret)
					         
					     }
						 //取消核收
					     s ret = ##class(ES.LIS.DHCTransferEmergentData).DiscardReportMTHD(TargetRepDR,"","","","","","","","","","","","","",Sessions)
					     i $p(ret,"^",1)'=1  throw ##class(%Exception.SystemException).%New("事务委托","D",,"应急库取消核收失败:"_ret)
				      }		
			        
			    }
			    elseif '$l(objTestSetMsg.ReceiveDate) //中间表拒收状态
			    {
				      //应急库发生业务
			          i $l(TargetRepDR)
			          {
				         s TargetRepData=$g(^dbo.RPVisitNumberReportD(TargetRepDR))
				         s WorkGroupMachineDR=$lg(TargetRepData,4)
				         s Status=$lg(TargetRepData,22)
				         //审核状态调用取审方法
				         //报告状态(1登记，2初审，3审核，4复查，5取消审核，6作废，O其他)
				         i Status="3"
				         {
					         //取审
					         s ret = ##class(ES.LIS.DHCTransferEmergentData).ReportUndoMTHD(TargetRepDR,WorkGroupMachineDR,"","","","","","","","","","","",Sessions)
					         i $p(ret,"^",1)'=1  throw ##class(%Exception.SystemException).%New("事务委托","D",,"应急库取审报告失败:"_ret)
					         
					         //返回登记
					         s ret = ##class(ES.LIS.DHCTransferEmergentData).ReportToRegMTHD(TargetRepDR,"","","","","","","","","","","","",Sessions)
					         i $p(ret,"^",1)'=1  throw ##class(%Exception.SystemException).%New("事务委托","D",,"应急库返回登记报告失败:"_ret)
					         	
					         //清除结果
					         s ret = ##class(ES.LIS.DHCTransferEmergentData).ClearResultMTHD(TargetRepDR,"","","","","","","","","","","","",Sessions)
					         i $p(ret,"^",1)'=1  throw ##class(%Exception.SystemException).%New("事务委托","D",,"应急库清除结果失败:"_ret)
					         
					     
					     }
					     elseif ((Status="2")||(Status="4")||(Status="5"))
					     {
						     //返回登记
					         s ret = ##class(ES.LIS.DHCTransferEmergentData).ReportToRegMTHD(TargetRepDR,"","","","","","","","","","","","",Sessions)
					         i $p(ret,"^",1)'=1  throw ##class(%Exception.SystemException).%New("事务委托","D",,"应急库返回登记报告失败:"_ret)
					         	
					         //清除结果
					         s ret = ##class(ES.LIS.DHCTransferEmergentData).ClearResultMTHD(TargetRepDR,"","","","","","","","","","","","",Sessions)
					         i $p(ret,"^",1)'=1  throw ##class(%Exception.SystemException).%New("事务委托","D",,"应急库清除结果失败:"_ret)
					         
						     
						 }
						 elseif Status="1"   
						 {
					     	 //清除结果
					         s ret = ##class(ES.LIS.DHCTransferEmergentData).ClearResultMTHD(TargetRepDR,"","","","","","","","","","","","",Sessions)
					         i $p(ret,"^",1)'=1  throw ##class(%Exception.SystemException).%New("事务委托","D",,"应急库清除结果失败:"_ret)
					         
					     }
						
				      }	
				      //拒收
					  s ret = ##class(ES.LIS.DHCTransferEmergentData).RejectVisitNumberMTHD(TargetLabno, TargetTSDRlist, "","","","","","","","","","","",Sessions)
					  i $p(ret,"^",1)'=1  throw ##class(%Exception.SystemException).%New("事务委托","D",,"应急库标本拒收失败:"_ret)
				}
	        }
		}		
	}
	q RetValue
}

/// zhangli 20210726
/// 把标本业务表中的信息登记进入中间表(RI_LabRequest,RI_TestSet)
/// w ##class(ES.LIS.DHCRegisterByQRCode).SaveRILabInfoMTHD("0000002680","","","","","","","","","","","","","","113^7^0^12^1")
ClassMethod SaveRILabInfoMTHD(LabNo As %String(MAXLEN=32767), P1, P2, P3, P4, P5, P6, P7, P8, P9, P10, P11, P12, P13, Sessions, Output RowCount As %String) As %String
{
	s ret=1
	s LabNo=$g(LabNo)
	s VisitNumberDR=$o(^dbo.RPVisitNumberI("IndexVisitNumber",##Class(LIS.Util.Common).IndexData(LabNo),""))
	i '$l(VisitNumberDR) q
    
    s gVisitNumberData=$g(^dbo.RPVisitNumberD(VisitNumberDR))	
    s VisitNumber=$lg(gVisitNumberData,2)
	s RegNo=$lg(gVisitNumberData,3)
	s AdmissionTypeDR=$lg(gVisitNumberData,4)
	s AdmissionType=$lg($g(^dbo.BTAdmissionTypeD(AdmissionTypeDR)),2)
	s AdmNo=$lg(gVisitNumberData,5)
	s MedicalRecordNo=$lg(gVisitNumberData,6)
	s AdmDate=$lg(gVisitNumberData,7)
	s AdmTime=$lg(gVisitNumberData,8)
	i $l(AdmTime) s AdmTime=$zt(AdmTime)
	s CertTypeDR=$lg(gVisitNumberData,9),CertType=""
	i $l(CertTypeDR) s CertType=$lg($g(^dbo.BTCertTypeD(CertTypeDR)),2) 
	s CertNo=$lg(gVisitNumberData,10)
	s IDNumber=$lg(gVisitNumberData,11)
    s PaymentType="" //$lg(gVisitNumberData,12)
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
  	s CollectDate=$lg(gVisitNumberData,51)   ;采集信息
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
    s CarryDate=$lg(gVisitNumberData,63)   ;运送信息
    s CarryTime=$lg(gVisitNumberData,64)   
    i $l(CarryTime) s CarryTime=$zt(CarryTime)  
    s CarryUserDR=$lg(gVisitNumberData,65),CarryUserID="",CarryUserName=""
    i $l(CarryUserDR) d
    .s CarryUserID=$lg($g(^dbo.SYSUserD(CarryUserDR)),2)
    .s CarryUserName=$lg($g(^dbo.SYSUserD(CarryUserDR)),3)
  	s ReceiveDate=$lg(gVisitNumberData,66)   ;接收日期
    s ReceiveTime=$lg(gVisitNumberData,67)   ;接收时间
    i $l(ReceiveTime) s ReceiveTime=$zt(ReceiveTime)  
    s ReceiveUserDR=$lg(gVisitNumberData,68),ReceiveUserID="",ReceiveUserName=""
    i $l(ReceiveUserDR) d
    .s ReceiveUserID=$lg($g(^dbo.SYSUserD(ReceiveUserDR)),2)
    .s ReceiveUserName=$lg($g(^dbo.SYSUserD(ReceiveUserDR)),3)
    s SpecimenQualityDR=$lg(gVisitNumberData,69),SpecimenQuality=""
    i $l(SpecimenQualityDR) s SpecimenQuality=$lg($g(^dbo.BTSpecimenQualityD(ReceiveUserDR)),3)
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
    
    s TransferFlag=0
	s RetXML=##class(LIS.Util.COM.XML).New("Request")
	s objLabRequest=##class(LIS.Util.COM.XML).New("LabRequestMsg")
    s objLabRequest.VisitNumberFrom=##class(LIS.Common.DHCVisitNumber).GetLabNoType(VisitNumber)
	s objLabRequest.AdmissionType=AdmissionType 
	s objLabRequest.RegNo=RegNo
	s objLabRequest.AdmNo=AdmNo
	s objLabRequest.MedicalRecordNo=MedicalRecordNo
	s objLabRequest.AdmDate=AdmDate
	s objLabRequest.AdmTime=AdmTime
	s objLabRequest.CertType=CertType
	s objLabRequest.CertNo=CertNo
	s objLabRequest.IDNumber=IDNumber
	s objLabRequest.PaymentType=PaymentType
	s objLabRequest.PaymentName=PaymentName
	s objLabRequest.SurName=SurName
	s objLabRequest.GivenName=GivenName
	s objLabRequest.SpeciesID=SpeciesID
	s objLabRequest.SpeciesName=SpeciesName
	s objLabRequest.BirthDate=BirthDate
	s objLabRequest.BirthTime=BirthTime
	s objLabRequest.Age=Age
	s objLabRequest.AgeUnit=AgeUnit
	s objLabRequest.Ethnicity=Ethnicity
	s objLabRequest.HospitaID=HospitaID
	s objLabRequest.HospitaName=HospitaName
	s objLabRequest.SymptomID=SymptomID
	s objLabRequest.Symptom=Symptom
	s objLabRequest.MobileNo=MobileNo
	s objLabRequest.PhoneNo=PhoneNo
	s objLabRequest.email=email
	s objLabRequest.Height=Height
	s objLabRequest.Weight=Weight
	s objLabRequest.BloodPressure=BloodPressure
	s objLabRequest.ClinicalConditions=ClinicalConditions
	s objLabRequest.Pregnant=Pregnant
	s objLabRequest.PregnantWeeks=PregnantWeeks
	s objLabRequest.ABO=ABO
	s objLabRequest.RH=RH
	s objLabRequest.Address=Address
	s objLabRequest.PostCode=PostCode
	s objLabRequest.InfectFlag=InfectFlag
	s objLabRequest.InfectAlert=InfectAlert
	s objLabRequest.PregnantNum=PregnantNum
	s objLabRequest.ChildbirthNum=ChildbirthNum
   
    s objLabTestSetMsgs=##class(LIS.Util.COM.XML).New("LabTestSetMsgs")
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
	.s BarCode=LabNo
	.s ArticleBarCode=""
	.s TestSetState=""
	.s VisitNumberTestSetCode=TestSetCode
	.s WorkGroupMachineDR=""
	.s TransmitDate=""
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
	..s TransmitDate=$lg(gReportData,3)  
	..s AssayNo=$lg(gReportData,6)  
	..s AcceptDate=$lg(gReportData,9)  
	..s AcceptTime=$lg(gReportData,10)  
	..//i $l(AcceptTime) s AcceptTime=$zt(AcceptTime) 
	..s AcceptUserDR=$lg(gReportData,11)  
	..s ReportID=VisitNumberReportDR 
	.s IsChanged="1" 
	.s UpdateDate="" 
	.s UpdateTime="" 
	.s AddDate=$zd($p($h,",",1),8)
	.s AddTime=$p($h,",",2) //$zt($p($h,",",2))        
	.s objLabTestSet=##class(LIS.Util.COM.XML).New("LabTestSetMsg")
    .s objLabTestSet.VisitNumberDR=VisitNumberDR 
	.s objLabTestSet.TestSetCode=TestSetCode 
	.s objLabTestSet.TestSetName=TestSetName 
	.s objLabTestSet.TestSetRowID=TestSetRowID 
	.s objLabTestSet.Sequence=Sequence 
	.s objLabTestSet.BarCode=BarCode 
	.s objLabTestSet.ArticleBarCode=ArticleBarCode 
	.s objLabTestSet.TestSetState=TestSetState    //1：登记，2：打印条码，3：采集，4：标本运送，5：标本接收，6：停止，7：作废，8.拒收,10:打包，11：送达,13:护士执行（条码生成）
	.s objLabTestSet.VisitNumberTestSetCode=VisitNumberTestSetCode 
	.s objLabTestSet.SpecimenCode=SpecimenCode 
	.s objLabTestSet.SpecimenName=SpecimenName     
	.s objLabTestSet.ContainerCode=ContainerCode 
	.s objLabTestSet.ContainerName=ContainerName 
	.s objLabTestSet.CollectNotes=CollectNotes 
	.s objLabTestSet.LocationCode=LocationCode 
	.s objLabTestSet.LocationName=LocationName     
	.s objLabTestSet.WardCode=WardCode 
	.s objLabTestSet.WardName=WardName 
	.s objLabTestSet.BedNo=BedNo 
	.s objLabTestSet.DotorID=DotorID 
	.s objLabTestSet.DotorName=DotorName         
	.s objLabTestSet.RequestDate=RequestDate 
	.s objLabTestSet.RequestTime=RequestTime 
	.s objLabTestSet.PrinterID="" //PrinterID 
	.s objLabTestSet.PrinterName="" //PrinterName 
	.s objLabTestSet.PrintDate="" //PrintDate 
	.s objLabTestSet.PrintTime="" //PrintTime 
	.s objLabTestSet.PrintStatus="" //PrintStatus 
	.s objLabTestSet.CollectDate=CollectDate 
	.s objLabTestSet.CollectTime=CollectTime 
	.s objLabTestSet.CollectUserID=CollectUserID 
	.s objLabTestSet.CollectUserName=CollectUserName 
	.s objLabTestSet.AnatomicalSite=AnatomicalSite 
	.s objLabTestSet.CollectPositon=CollectPositon 
	.s objLabTestSet.CarryDate=CarryDate 
	.s objLabTestSet.CarryTime=CarryTime 
	.s objLabTestSet.CarryUserID=CarryUserID 
	.s objLabTestSet.CarryUserName=CarryUserName 
	.s objLabTestSet.ReceiveDate=ReceiveDate 
	.s objLabTestSet.ReceiveTime=ReceiveTime 
	.s objLabTestSet.ReceiveUserID=ReceiveUserID 
	.s objLabTestSet.ReceiveUserName=ReceiveUserName 
	.s objLabTestSet.TestSetFee=TestSetFee  
	.s objLabTestSet.TestSetFeeFlag=2 //默认已计费 TestSetFeeFlag 
	.s objLabTestSet.ReqNotes=ReqNotes 
	.s objLabTestSet.RequestNo=RequestNo 
	.s objLabTestSet.Urgent=Urgent 
	.s objLabTestSet.H24UVolume=H24UVolume 
	.s objLabTestSet.H24UTimePeriod=H24UTimePeriod 
	.s objLabTestSet.BodyTemp=BodyTemp 
	.s objLabTestSet.BloodPressure=BloodPressure 
	.s objLabTestSet.Confidential=Confidential 
	.s objLabTestSet.SpecimenQuality=SpecimenQuality 
	.s objLabTestSet.ReceiveHospitalID=ReceiveHospitalID 
	.s objLabTestSet.ReceiveNotes=ReceiveNotes 
	.s objLabTestSet.SpecialFlag=SpecialFlag 
	.s objLabTestSet.SpecialRowId="" //SpecialRowId 
	.s objLabTestSet.OrdDeptID="" //OrdDeptID 
	.s objLabTestSet.OrdDeptName="" //OrdDeptName 
	.s objLabTestSet.HospitalCode=HospitaID 
	.s objLabTestSet.HospitalName=HospitaName 
	.s objLabTestSet.WorkGroupMachineDR=WorkGroupMachineDR 
	.s objLabTestSet.TransmitDate=TransmitDate 
	.s objLabTestSet.AssayNo=AssayNo 
	.s objLabTestSet.AcceptDate=AcceptDate 
	.s objLabTestSet.AcceptTime=AcceptTime 
	.s objLabTestSet.AcceptUserDR=AcceptUserDR 
	.s objLabTestSet.ReportID=ReportID 
	.s objLabTestSet.IsChanged=IsChanged 
	.s objLabTestSet.UpdateDate=UpdateDate 
	.s objLabTestSet.UpdateTime=UpdateTime 
	.s objLabTestSet.AddDate=AddDate 
	.s objLabTestSet.AddTime=AddTime        
	.d objLabTestSetMsgs.Insert(objLabTestSet)
	d objLabRequest.Insert(objLabTestSetMsgs) 
	d RetXML.Insert(objLabRequest)
    s Input=RetXML.ToXMLStream()
    s strInput=Input.Read()
    s ret = ##class(ES.LIS.DHCRegisterByQRCode).SyncRILabRequestTSMTHD(strInput,"","","","","","","","","","","","","","113^7^0^12^1")
    q ret
}

}
