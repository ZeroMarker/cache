Class DHCLIS.DHCReceiveProcess Extends %RegisteredObject
{

/// Creator:刘志飞
/// CreatDate:2014-10-13
/// Description:保存检验标本信息（用于采集，申请 前处理数据保存） 
/// Input: Labno检验号,Usercode用户代码,WorkGroupMachineDR接收科室代码,RecHospitalCode接收医院,RecFlag保存内容（2:采集）
/// Other: W ##Class(DHCLIS.DHCReceiveProcess).SaveVisitNumber("152022112210","4636","","","2")
ClassMethod SaveVisitNumber(Labno, Usercode, WorkGroupMachineDR, RecHospitalCode, RecFlag) As %String
{
	s ^TMPP("zl","0227")=$lb(Labno, Usercode, WorkGroupMachineDR, RecHospitalCode, RecFlag)
	s Labno=$g(Labno),Usercode=$g(Usercode),WorkGroupMachineDR=$g(WorkGroupMachineDR),RecHospitalCode=$g(RecHospitalCode)
	s RecFlag=$g(RecFlag)

	Set $ZTrap = "ErrorHandle"
	s msgErr=""
	s Input=##Class(LISService.BSService.Business.SampleInfo).GetSampleInfo(Labno, Usercode, WorkGroupMachineDR, RecHospitalCode, RecFlag, .msgErr)
	
	i $l(msgErr) q msgErr
	s RecLabNo=Labno
	s LinkLabNo=""
    i $d(^OEORDi(0,"PlacerNo",Labno)) s Labno=$o(^OEORDi(0,"PlacerNo",Labno,"")),LinkLabNo=Labno
    
	s RetValue=100,err=""
	//Set reader = ##class(%XML.Reader).%New()
    //Do reader.OpenStream(Input)
    //Do reader.Correlate("Data","LIS.Model.RPVisitNumber")
    s obj= ##class(LIS.Util.COM.XML).FromXML(Input)
    
    While (obj.Next()) {
	    s VisitNumber=obj.VisitNumber
	    If (VisitNumber) // check if this succeeded without errors
	    {	
			s CollectDate=$tr($tr(obj.CollectDate,$c(0)),"-")
			s CollectTime=$tr(obj.CollectTime,$c(0))
			//判断采集保存
			b ;112
			i (RecFlag="2"),(CollectDate="") s RetValue="-1^标本采集时间为空" quit   
			i (RecFlag="2"),(CollectTime="") s RetValue="-1^标本采集时间为空" quit
			   
			///保存标本信息
			i $d(^dbo.RPVisitNumberI("IndexVisitNumber",##Class(LIS.Util.Common).IndexData(RecLabNo))) 
			{
				s VisitNumberDR=$o(^dbo.RPVisitNumberI("IndexVisitNumber",##Class(LIS.Util.Common).IndexData(RecLabNo),""))
				s objVisitNumber=##class(dbo.RPVisitNumber).%OpenId(VisitNumberDR)
				i (objVisitNumber.AddType'="4")&&(objVisitNumber.AddType'="5") s RetValue="-1^标本已经接收" quit
			} 
			else
			{
				s objVisitNumber=##class(dbo.RPVisitNumber).%New()
			}
			s objVisitNumber.VisitNumber=RecLabNo
			s objVisitNumber.RegNo=$tr(obj.RegNo,$c(0))
			s AdmissionTypeDR=""
			s PatType=$tr(obj.AdmissionTypeDR,$c(0))
			i $l(PatType) s AdmissionTypeDR=##Class(DHCLIS.DHCReceiveProcess).GetAdmissionTypeDR(PatType)
			s objVisitNumber.AdmissionTypeDR=AdmissionTypeDR
			s objVisitNumber.AdmNo=$tr(obj.AdmNo,$c(0))
			s objVisitNumber.MedicalRecordNo=$tr(obj.MedicalRecordNo,$c(0))
			s objVisitNumber.AdmDate=$tr(obj.AdmDate,$c(0))
			s objVisitNumber.AdmTime=$tr(obj.AdmTime,$c(0))
			//s objVisitNumber.CertTypeDR=CertTypeDR  //证件类型 预留？
			//s objVisitNumber.CertNo=CertNo		  //证件号   预留？
			s objVisitNumber.IDNumber=$e($tr(obj.IDNumber,$c(0)),1,50)
			//s objVisitNumber.PaymentTypeDR=PaymentTypeDR  //支付类型 预留？
			s objVisitNumber.SurName=$tr(obj.SurName,$c(0))
			s objVisitNumber.GivenName=$tr(obj.GivenName,$c(0))
			s SpeciesDR=""
			s SexCode=$p($tr(obj.SpeciesDR,$c(0)),"@",1)
			i $l(SexCode) s SpeciesDR=##Class(DHCLIS.DHCReceiveProcess).GetSpeciesDR(SexCode)
			s objVisitNumber.SpeciesDR=SpeciesDR
			s objVisitNumber.BirthDate=$tr(obj.BirthDate,$c(0))
			//s objVisitNumber.BirthTime=BirthTime
			s objVisitNumber.Age=$tr(obj.Age,$c(0))
			s AgeUnitDR=""
			s AgeCode=$tr(obj.AgeUnitDR,$c(0))
			i $l(AgeCode) s AgeUnitDR=##Class(DHCLIS.DHCReceiveProcess).GetAgeUnitDR(AgeCode)
			s objVisitNumber.AgeUnitDR=AgeUnitDR
			//s objVisitNumber.EthnicityDR=EthnicityDR    //民族 预留？
			s HospCode=$p($tr(obj.HospitalDR,$c(0)),"@",1)
			s HospDesc=$p($tr(obj.HospitalDR,$c(0)),"@",2)   //病人医院
			s HospitalDR=""
			i $l(HospCode) s HospitalDR=##Class(DHCLIS.DHCReceiveProcess).GetHospitalDR(HospCode,HospDesc)
			s objVisitNumber.HospitalDR=HospitalDR
			s LocID=$p($tr(obj.LocationDR,$c(0)),"@",1)
			s LocDesc=$p($tr(obj.LocationDR,$c(0)),"@",2)
			s LocCode=$p($tr(obj.LocationDR,$c(0)),"@",3)
			s LocationDR=""
			i $l(LocCode) s LocationDR=##Class(DHCLIS.DHCReceiveProcess).GetLocationDR(LocID,LocCode,LocDesc,HospitalDR)
			s objVisitNumber.LocationDR=LocationDR
			s DoctorDR=""
			s DocCode=$p($tr(obj.DoctorDR,$c(0)),"@",1)
			s DocName=$p($tr(obj.DoctorDR,$c(0)),"@",2)
			i $l(DocCode) s DoctorDR=##Class(DHCLIS.DHCReceiveProcess).GetDoctorDR(DocCode,DocName,HospitalDR)
			s objVisitNumber.DoctorDR=DoctorDR
			s objVisitNumber.RequestDate=$tr(obj.RequestDate,$c(0))
			s objVisitNumber.RequestTime=$tr(obj.RequestTime,$c(0))
			s WardDR=""
			s WardID=$p($tr(obj.WardDR,$c(0)),"@",1)
			s WardDesc=$p($tr(obj.WardDR,$c(0)),"@",2)
			s WardCode=$p($tr(obj.WardDR,$c(0)),"@",3)
			i $l(WardCode) s WardDR=##Class(DHCLIS.DHCReceiveProcess).GetWardDR(WardID,WardCode,WardDesc,LocationDR)
			s objVisitNumber.WardDR=WardDR
			s objVisitNumber.BedNo=$tr(obj.BedNo,$c(0))
			s objVisitNumber.Symptom=$e($tr(obj.Symptom,$c(0)),1,500) //Symptom  诊断获取公共CLS ？？？
			s objVisitNumber.MobileNo=$e($tr(obj.MobileNo,$c(0)),1,50)
			s objVisitNumber.PhoneNo=$e($tr(obj.PhoneNo,$c(0)),1,50)
			s objVisitNumber.EMail=$tr(obj.EMail,$c(0))
			
			s objVisitNumber.Address=$tr(obj.Address,$c(0))
			s objVisitNumber.PostCode=$tr(obj.PostCode,$c(0))		
			
			s objVisitNumber.ReqNotes=$tr(obj.ReqNotes,$c(0))
			//s objVisitNumber.RequestNo=$tr(objRQRequest.RequestNo,$c(0))  ///申请单号
			s objVisitNumber.Urgent=$tr(obj.Urgent,$c(0))
			s objVisitNumber.CollectDate=CollectDate
			s objVisitNumber.CollectTime=CollectTime
			s CollectUserDR=""
			s ColUserCode=$p($tr(obj.CollectUserDR,$c(0)),"@",1)
			s ColUserName=$p($tr(obj.CollectUserDR,$c(0)),"@",2)
			i $l(ColUserCode) s CollectUserDR=##Class(DHCLIS.DHCReceiveProcess).GetUserDR(ColUserCode,ColUserName,HospitalDR,"NUR")
			s objVisitNumber.CollectUserDR=CollectUserDR
			//s objVisitNumber.AnatomicalSiteDR=$tr(AnatomicalSiteDR,$c(0)) ///采集部位
			//s objVisitNumber.CollectPositon=$tr(AnatomicalSiteDesc,$c(0)) ///采集部位描述
			s SpecimenDR=""
			s SpecimenCode=$p($tr(obj.SpecimenDR,$c(0)),"@",1)
			s SpecimenName=$p($tr(obj.SpecimenDR,$c(0)),"@",2)
			i $l(SpecimenCode) s SpecimenDR=##Class(LIS.Util.BaseDataCommon).GetSpecimenDR(SpecimenCode,SpecimenName,HospitalDR)
			s objVisitNumber.SpecimenDR=SpecimenDR
			s ContainerDR=""
			s ContainerCode=$p($tr(obj.ContainerDR,$c(0)),"@",1)
			s ContainerName=$p($tr(obj.ContainerDR,$c(0)),"@",2)
			i $l(ContainerCode) s ContainerDR=##Class(LIS.Util.BaseDataCommon).GetContainerDR(ContainerCode,ContainerName,HospitalDR)
			s objVisitNumber.ContainerDR=ContainerDR
			s objVisitNumber.CollectNotes=""
			s objVisitNumber.H24UVolume=""
			s objVisitNumber.H24UTimePeriod=""
			s objVisitNumber.BodyTemp=""
			s objVisitNumber.Confidential=""
			s objVisitNumber.LinkLabNo=LinkLabNo
			i RecFlag=2 s AddType="5"   
			s objVisitNumber.AddType=AddType       ///1条码,2手工,3第三方,4其它(拒收保存),5采集
    		s sc=objVisitNumber.%Save()
			b ;in
			If ($SYSTEM.Status.IsOK(sc)) {
				s RetValue=0
				s VisitNumberDR=objVisitNumber.RowID
			}
			Else {
				s RetValue="-1^标本信息保存失败:"_$SYSTEM.Status.GetErrorText(sc) quit
			}			
			i RetValue'=0 quit

			///插入标本核收操作记录
			s (OperateDate,OperateTime,OperateTypeCode,OperateNotes,RejectTypeDR)=""
			s OperateTypeCode=2  ///采集
			s ret=##Class(DHCLIS.DHCReceiveProcess).SaveRecord(VisitNumberDR,OperateDate, OperateTime, CollectUserDR, OperateNotes, OperateTypeCode, WorkGroupMachineDR, RejectTypeDR)
	    }
	}
	q RetValue
	
ErrorHandle
	s RetValue="-1^错误"_$tr($ZERROR,"^","--")_".错误代码:"_$ECODE
    Quit RetValue
}

/// Creator：      liuzf
/// CreatDate：    20131127
/// Description：  保存标本登记记录
/// Table：        dbo.RP_VisitNumberRecord
/// Input：        标本ID,操作时间,操作者,操作说明,操作类型,工作组,标本拒收类型
/// Output：       无
/// Return：       保存结果 
/// Others
ClassMethod SaveRecord(VisitNumberDR, OperateDate, OperateTime, UserID, OperateNotes, OperateTypeCode, WorkGroupMachineDR, RejectTypeDR) As %String
{
    s VisitNumberDR=$g(VisitNumberDR),UserID=$g(UserID),OperateDate=$g(OperateDate),OperateTime=$g(OperateTime),OperateNotes=$g(OperateNotes)
    s OperateTypeCode=$g(OperateTypeCode),WorkGroupMachineDR=$g(WorkGroupMachineDR),RejectTypeDR=$g(RejectTypeDR)
 	s OperateTypeDR=""
 	i $l(OperateTypeCode) s OperateTypeDR=$o(^dbo.BTOperatorTypeI("IndexCode",##Class(LIS.Util.Common).IndexData(OperateTypeCode),""))
    i '$l(OperateTypeDR) q "100^记录状态为空"
    
    i '$l(OperateDate) s OperateDate=$tr($zd(+$h,3),"-")
    i '$l(OperateTime) s OperateTime=$p($h,",",2)
    
	s objRecord=##class(dbo.RPVisitNumberRecord).%New()
	s objRecord.VisitNumberDR=VisitNumberDR
	s objRecord.OperateDate=OperateDate
	s objRecord.OperateTime=OperateTime
	s objRecord.OperateUserDR=UserID
	s objRecord.OperateNotes=OperateNotes
	s objRecord.OperateTypeDR=OperateTypeDR  ///操作类型
	s objRecord.WorkGroupMachineDR=WorkGroupMachineDR
	s objRecord.RejectTypeDR=RejectTypeDR
	s sc=objRecord.%Save()
 	If ($SYSTEM.Status.IsOK(sc)) {q 1}
 	else {q $SYSTEM.Status.GetErrorText(sc)}
}

/// 判断是否是医生
ClassMethod CheckDoctor(DoctorID) As %String
{
	Q ##class(LIS.Util.BaseDataCommon).CheckDoctor(DoctorID)
}

/// 获取用户DR
ClassMethod GetUserDR(Code, CName, HospitalDR, UserType) As %String
{
	s Code=$g(Code),CName=$g(CName),HospitalDR=$g(HospitalDR),UserType=$g(UserType)
	Q ##class(LIS.Util.BaseDataCommon).GetUserDR(Code, CName, HospitalDR, UserType)
}

/// 获取医生DR
ClassMethod GetDoctorDR(Code, CName, HospitalDR) As %String
{
	Q ##class(LIS.Util.BaseDataCommon).GetDoctorDR(Code, CName, HospitalDR)
}

/// 获取就诊医院DR
ClassMethod GetHospitalDR(Code, CName) As %String
{
	Q ##class(LIS.Util.BaseDataCommon).GetHospitalDR(Code)
}

/// 获取就诊科室DR
ClassMethod GetLocationDR(Code, HISCode, CName, HospitalDR) As %String
{
	Q ##class(LIS.Util.BaseDataCommon).GetLocationDR(Code, HISCode, CName, HospitalDR)
}

/// 获取病区DR
ClassMethod GetWardDR(Code, HISCode, CName, LocationDR) As %String
{
	Q ##class(LIS.Util.BaseDataCommon).GetWardDR(Code, HISCode, CName, LocationDR)
}

/// 获取就诊类型DR
ClassMethod GetAdmissionTypeDR(Code) As %String
{
	Q ##class(LIS.Util.BaseDataCommon).GetAdmissionTypeDR(Code)
}

/// 获取性别DR
ClassMethod GetSpeciesDR(Code) As %String
{
	Q ##class(LIS.Util.BaseDataCommon).GetSpeciesDR(Code)
}

/// 获取年龄单位DR
ClassMethod GetAgeUnitDR(Code) As %String
{
	Q ##class(LIS.Util.BaseDataCommon).GetAgeUnitDR(Code)
}

}
