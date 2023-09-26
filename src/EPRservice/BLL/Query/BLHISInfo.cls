/// 描述：HIS信息查询业务对象
/// 创建者：houjian
/// 创建日期：2011-06-03
Class EPRservice.BLL.Query.BLHISInfo Extends %RegisteredObject [ LegacyInstanceContext, ProcedureBlock ]
{

Property PatientID As %String(TRUNCATE = 1) [ Private ];

Property EpisodeID As %String(TRUNCATE = 1);

/// Desc:	实例化业务逻辑对象
/// Debug:	w ##Class(EPRservice.BLL.Query.BLHISInfo).CreateInstance()
ClassMethod CreateInstance(AEpisodeID As %String) As EPRservice.BLL.Query.BLHISInfo
{
	s objBLHISInfo = ##Class(EPRservice.BLL.Query.BLHISInfo).%New()
	d objBLHISInfo.SetEpisodeID(AEpisodeID)
	q objBLHISInfo
}

/// Desc:	更新业务逻辑对象对应的就诊指针
Method SetEpisodeID(AEpisodeID As %String) As %Status
{
	s %this.EpisodeID = AEpisodeID
	s %this.PatientID = ##Class(EPRservice.HISInterface.DAEpisodeInfo).GetPapmiDR(i%EpisodeID)
	q $$$OK
}

/// Desc:	就诊指针
Method EpisodeID() As %String
{
	q %this.EpisodeID
}

/// Desc:	就诊号
Method EpisodeNo() As %String
{
	q ##Class(EPRservice.HISInterface.DAEpisodeInfo).GetAdmNo(%this.EpisodeID)
}

/// Desc:	登记号
Method RegNo() As %String
{
	q ##Class(EPRservice.HISInterface.DAPatientInfo).GetPapmiNo(%this.PatientID)
}

/// Desc:	病案号
/// add by YHY 病案号新接口
Method RecordNo() As %String
{
	//q ##Class(EPRservice.HISInterface.DAPatientInfo).GetIPRecordNo(%this.PatientID)
	//q ##class(web.DHCWMRService).IGetMrNoByEpisodeID(%this.EpisodeID)
	q ##Class(EPRservice.HISInterface.DAPatientInfo).GetIPRecordNo2(%this.PatientID, %this.EpisodeID)
}

/// Desc:	姓名
Method Name() As %String
{
	q ##Class(EPRservice.HISInterface.DAPatientInfo).GetName(%this.PatientID)
}

/// Desc:	性别
Method Gender() As %String
{
	s gender = ##Class(EPRservice.HISInterface.DAPatientInfo).GetGender(%this.PatientID)
	q $P(gender, "^", 3)
}

/// Desc:	出生日期
Method BirthDate() As %String
{
	s date = ##Class(EPRservice.HISInterface.DAPatientInfo).GetBirthDate(%this.PatientID)
	q:(date = "") date
	
	//q $zd(date,3)
	s HISFormatDate = ##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Date",date)
	
	q HISFormatDate
}

/// Desc:	就诊类型
Method AdmType() As %String
{
	q ##Class(EPRservice.HISInterface.DAEpisodeInfo).GetAdmType(%this.EpisodeID)
}

/// Desc:	入院日期
Method AdmDate() As %String
{
	s date = ##Class(EPRservice.HISInterface.DAEpisodeInfo).GetAdmDateTime(%this.EpisodeID)
	s date = $P(date, ",", 1)
	q:(date = "") date
	//q $zd(date,3)
	s HISFormatDate = ##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Date",date)
	
	q HISFormatDate
}

/// Desc:	入院时间
Method AdmTime() As %String
{
	s time = ##Class(EPRservice.HISInterface.DAEpisodeInfo).GetAdmDateTime(%this.EpisodeID)
	s time = $P(time, ",", 2)
	q:(time = "") time
	//q $zt(time,1)
	
	s HISFormatTime = ##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Time",time)
	
	q HISFormatTime
}

/// Desc:	入院科室
Method AdmDept() As %String
{
    s PAAdmType = $p($g(^PAADM(%this.EpisodeID)),"^",2)
    if (PAAdmType = "I")
    {
        s dept = ##Class(EPRservice.HISInterface.DAEpisodeInfo).GetAdmDept(%this.EpisodeID)
    }
    else
    {
        s dept = ##Class(EPRservice.HISInterface.DAEpisodeInfo).GetCurrentDept(%this.EpisodeID)
    }
	q $P(dept, "^", 3)
}

/// Desc:	入院病区
Method AdmWard() As %String
{
	s ward = ##Class(EPRservice.HISInterface.DAEpisodeInfo).GetAdmWard(%this.EpisodeID)
	q $P(ward, "^", 3)
}

/// Desc:	出院日期
Method DischDate() As %String
{
	s date = ##Class(EPRservice.HISInterface.DAEpisodeInfo).GetDisDateTime(%this.EpisodeID)
	s date = $P(date, ",", 1)
	q:(date = "") date
	//q $zd(date,3)
	
	s HISFormatDate = ##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Date",date)
	
	q HISFormatDate
}

/// Desc:	出院时间
Method DischTime() As %String
{
	s time = ##Class(EPRservice.HISInterface.DAEpisodeInfo).GetDisDateTime(%this.EpisodeID)
	s time = $P(time, ",", 2)
	q:(time = "") time
	//q $zt(time,1)
	
	s HISFormatTime = ##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Time",time)
	
	q HISFormatTime
}

/// Desc:	出院科室
Method DischDept() As %String
{
	s date = ##Class(EPRservice.HISInterface.DAEpisodeInfo).GetDisDateTime(%this.EpisodeID)
	s date = $P(date, ",", 1)
	q:(date = "") ""
	s dept = ##Class(EPRservice.HISInterface.DAEpisodeInfo).GetCurrentDept(%this.EpisodeID)
	q $P(dept, "^", 3)
}

/// Desc:	门诊病人的就诊科室（门诊病人有时不存在入院或者出院的说法，只有就诊科室，但是结果和住院病人的出院科室、当前科室是一致的）
/// add by niucaicai 2014-9-22
Method AdmDeptForOP() As %String
{
	s AdmDeptForOP = ##Class(EPRservice.HISInterface.DAEpisodeInfo).GetCurrentDept(%this.EpisodeID)
	q $P(AdmDeptForOP, "^", 3)
}

/// Desc:	出院病区
Method DischWard() As %String
{
	s date = ##Class(EPRservice.HISInterface.DAEpisodeInfo).GetDisDateTime(%this.EpisodeID)
	s date = $P(date, ",", 1)
	q:(date = "") ""
	s ward = ##Class(EPRservice.HISInterface.DAEpisodeInfo).GetCurrentWard(%this.EpisodeID)
	q $P(ward, "^", 3)
}

/// Desc:	主管医生
Method MainDoc() As %String
{
	s doc = ##Class(EPRservice.HISInterface.DAEpisodeInfo).GetMainDoc(%this.EpisodeID)
	q $P(doc, "^", 3)
}

/// Desc:	当前病室
/// modify: YHY 2014-01-03
Method CurRoom() As %String
{
	s room = ##Class(EPRservice.HISInterface.DAEpisodeInfo).GetCurrentRoom(%this.EpisodeID)
	q room
}

/// modify: YHY 2014-01-03
/// Desc:	床位号
Method CurBed() As %String
{
	//s bed = ##class(EPRservice.HISInterface.PatientInfoAssist).AdmBed(%this.EpisodeID)
	//此处取的是患者当前床位号，不是入院床号，转科的患者会有区别 modify by 牛才才 2017-2-22
	s bed = ##Class(EPRservice.HISInterface.DAEpisodeInfo).GetCurrentBed(%this.EpisodeID)
	q $P(bed, "^", 3)
}

/// Desc:	HIS诊断
Method Diagnos() As %String
{
	s Diagnos = ##Class(EPRservice.HISInterface.DAEpisodeInfo).GetDiagnos(%this.EpisodeID)
	q $P(Diagnos, "^", 3)
}

/// Desc:	所有诊断
Method AllDiagnos() As %String
{
	s strDiagnos =""

	if (%this.EpisodeID ="28")||(%this.EpisodeID ="40")
	{
		s strlll= ""
	}
	
	s inters = ##Class(EMRservice.BL.BLSysOption).GetOptionValueByName("QueryAllDiagnos")	
	q:(inters="") strDiagnos
	s strTid =$p(inters,"||",1)
	s inters =$p(inters,"||",2)
	s count = $L(inters,"^")
	for i=1:1:count 
	{
		s strInter = $p(inters,"^",i)
		s strInstancID = ##Class(EMRservice.BL.BLScatterData).GetInstanceByEpisodeTemID(%this.EpisodeID,strTid)
		continue:(strInstancID="")
		s strValue =##Class(EMRservice.BL.BLScatterData).GetDataByGlossary(%this.EpisodeID,strInter,strInstancID)
		if (i =1)
		{
			s strDiagnos = strValue
		}
		else
		{
			s strDiagnos = strDiagnos _"^"_strValue
		}
	}
	q strDiagnos
}

/// Desc:	初诊复诊标志
Method Visitagien() As %String
{
	s Visitagien = ##Class(EPRservice.HISInterface.DAEpisodeInfo).GetVisitagien(%this.EpisodeID)
	q Visitagien
}

/// Desc:	联系电话
Method TelephoneNo() As %String
{
	s TelephoneNo = ##Class(EPRservice.HISInterface.DAPatientInfo).GetTelephoneNo(%this.PatientID)
	q TelephoneNo
}

/// Desc:	年龄
Method Age() As %String
{
	q ##Class(EPRservice.HISInterface.DAPatientInfo).GetAge(%this.PatientID,%this.EpisodeID)
}

/// Desc:	现住址
Method CurAddress() As %String
{
	q ##Class(EPRservice.HISInterface.DAPatientInfo).GetCurAddress(%this.PatientID)
}

/// Desc:	身份证号
Method IDCardNo() As %String
{
	s IDCardNo = ##Class(EPRservice.HISInterface.DAPatientInfo).GetIDCardNo(%this.PatientID)
	q IDCardNo
}

/// Desc:	职业
Method Profession() As %String
{
	s Profession = ##Class(EPRservice.HISInterface.DAPatientInfo).GetProfession(%this.PatientID)
	q Profession
}

/// Desc:	是否下过传染病诊断 
Method IsDiagnosToEpd() As %String
{
	s IsDiagnosToEpd = ##Class(EPRservice.HISInterface.DAEpisodeInfo).IsDiagnosToEpd(%this.EpisodeID)
	q IsDiagnosToEpd
}

/// Desc:	编目后门(急)诊诊断描述
/// add by niucaicai 2013-02-03
Method OpDiagnoseDesc() As %String
{
	s OpDiagnose = ##Class(EPRservice.HISInterface.DAEpisodeInfo).GetOpDiagnose(%this.EpisodeID)
	q $P(OpDiagnose,"^",1)
}

/// Desc:	编目后门(急)诊诊断ICD
/// add by niucaicai 2013-02-03
Method OpDiagnoseICD() As %String
{
	s OpDiagnose = ##Class(EPRservice.HISInterface.DAEpisodeInfo).GetOpDiagnose(%this.EpisodeID)
	q $P(OpDiagnose,"^",2)
}

/// Desc:	编目后入院诊断描述
/// add by niucaicai 2013-02-03
Method IpDiagnoseDesc() As %String
{
	s IpDiagnose = ##Class(EPRservice.HISInterface.DAEpisodeInfo).GetIpDiagnose(%this.EpisodeID)
	q $P(IpDiagnose,"^",1)
}

/// Desc:	编目后入院诊断ICD
/// add by niucaicai 2013-02-03
Method IpDiagnoseICD() As %String
{
	s IpDiagnose = ##Class(EPRservice.HISInterface.DAEpisodeInfo).GetIpDiagnose(%this.EpisodeID)
	q $P(IpDiagnose,"^",2)
}

/// Desc:	编目后病理诊断描述
/// add by niucaicai 2013-02-04
Method PathologyDiagnoseDesc() As %String
{
	s PathologyDiagnose = ##Class(EPRservice.HISInterface.DAEpisodeInfo).GetPathologyDiagnose(%this.EpisodeID)
	q $P(PathologyDiagnose,"^",1)
}

/// Desc:	编目后病理诊断ICD
/// add by niucaicai 2013-02-04
Method PathologyDiagnoseICD() As %String
{
	s PathologyDiagnose = ##Class(EPRservice.HISInterface.DAEpisodeInfo).GetPathologyDiagnose(%this.EpisodeID)
	q $P(PathologyDiagnose,"^",2)
}

/// Desc:	编目后“损伤、中毒的外部因素诊断”描述
/// add by niucaicai 2013-02-04
Method DamAndPoisonDiagnoseDesc() As %String
{
	s DamAndPoisonDiagnose = ##Class(EPRservice.HISInterface.DAEpisodeInfo).GetDamAndPoisonDiagnose(%this.EpisodeID)
	q $P(DamAndPoisonDiagnose,"^",1)
}

/// Desc:	编目后“损伤、中毒的外部因素诊断”ICD
/// add by niucaicai 2013-02-04
Method DamAndPoisonDiagnoseICD() As %String
{
	s DamAndPoisonDiagnose = ##Class(EPRservice.HISInterface.DAEpisodeInfo).GetDamAndPoisonDiagnose(%this.EpisodeID)
	q $P(DamAndPoisonDiagnose,"^",2)
}

/// Desc:	编目后医院感染诊断描述
/// add by niucaicai 2013-02-04
Method InfectDiagnoseDesc() As %String
{
	s InfectDiagnose = ##Class(EPRservice.HISInterface.DAEpisodeInfo).GetInfectDiagnose(%this.EpisodeID)
	q $P(InfectDiagnose,"^",1)
}

/// Desc:	编目后医院感染诊断ICD
/// add by niucaicai 2013-02-04
Method InfectDiagnoseICD() As %String
{
	s InfectDiagnose = ##Class(EPRservice.HISInterface.DAEpisodeInfo).GetInfectDiagnose(%this.EpisodeID)
	q $P(InfectDiagnose,"^",2)
}

/// Desc:	编目后主要诊断描述
/// add by niucaicai 2013-02-03
Method MainDiagnoseDesc() As %String
{
	s MainDiagnose = ##Class(EPRservice.HISInterface.DAEpisodeInfo).GetMainDiagnose(%this.EpisodeID)
	q $P(MainDiagnose,"^",1)
}

/// Desc:	编目后主要诊断ICD
/// add by niucaicai 2013-02-03
Method MainDiagnoseICD() As %String
{
	s MainDiagnose = ##Class(EPRservice.HISInterface.DAEpisodeInfo).GetMainDiagnose(%this.EpisodeID)
	q $P(MainDiagnose,"^",2)
}

/// Desc:	编目后其他诊断 1 描述
/// add by niucaicai 2013-02-04
Method OtherDiagnoseDesc1() As %String
{
	s OtherDiagnoseDescStr = ##Class(EPRservice.HISInterface.DAEpisodeInfo).GetOtherDiagnoseDesc(%this.EpisodeID)
	q $P(OtherDiagnoseDescStr,"^",1)
}

/// Desc:	编目后其他诊断 1 ICD
/// add by niucaicai 2013-02-04
Method OtherDiagnoseICD1() As %String
{
	s OtherDiagnoseICDStr = ##Class(EPRservice.HISInterface.DAEpisodeInfo).GetOtherDiagnoseICD(%this.EpisodeID)
	q $P(OtherDiagnoseICDStr,"^",1)
}

/// Desc:	编目后其他诊断 2 描述
/// add by niucaicai 2013-02-04
Method OtherDiagnoseDesc2() As %String
{
	s OtherDiagnoseDescStr = ##Class(EPRservice.HISInterface.DAEpisodeInfo).GetOtherDiagnoseDesc(%this.EpisodeID)
	q $P(OtherDiagnoseDescStr,"^",2)
}

/// Desc:	编目后其他诊断 2 ICD
/// add by niucaicai 2013-02-04
Method OtherDiagnoseICD2() As %String
{
	s OtherDiagnoseICDStr = ##Class(EPRservice.HISInterface.DAEpisodeInfo).GetOtherDiagnoseICD(%this.EpisodeID)
	q $P(OtherDiagnoseICDStr,"^",2)
}

/// Desc:	编目后其他诊断 3 描述
/// add by niucaicai 2013-02-04
Method OtherDiagnoseDesc3() As %String
{
	s OtherDiagnoseDescStr = ##Class(EPRservice.HISInterface.DAEpisodeInfo).GetOtherDiagnoseDesc(%this.EpisodeID)
	q $P(OtherDiagnoseDescStr,"^",3)
}

/// Desc:	编目后其他诊断 3 ICD
/// add by niucaicai 2013-02-04
Method OtherDiagnoseICD3() As %String
{
	s OtherDiagnoseICDStr = ##Class(EPRservice.HISInterface.DAEpisodeInfo).GetOtherDiagnoseICD(%this.EpisodeID)
	q $P(OtherDiagnoseICDStr,"^",3)
}

/// Desc:	编目后其他诊断 4 描述
/// add by niucaicai 2013-02-04
Method OtherDiagnoseDesc4() As %String
{
	s OtherDiagnoseDescStr = ##Class(EPRservice.HISInterface.DAEpisodeInfo).GetOtherDiagnoseDesc(%this.EpisodeID)
	q $P(OtherDiagnoseDescStr,"^",4)
}

/// Desc:	编目后其他诊断 4 ICD
/// add by niucaicai 2013-02-04
Method OtherDiagnoseICD4() As %String
{
	s OtherDiagnoseICDStr = ##Class(EPRservice.HISInterface.DAEpisodeInfo).GetOtherDiagnoseICD(%this.EpisodeID)
	q $P(OtherDiagnoseICDStr,"^",4)
}

/// Desc:	编目后其他诊断 5 描述
/// add by niucaicai 2013-02-04
Method OtherDiagnoseDesc5() As %String
{
	s OtherDiagnoseDescStr = ##Class(EPRservice.HISInterface.DAEpisodeInfo).GetOtherDiagnoseDesc(%this.EpisodeID)
	q $P(OtherDiagnoseDescStr,"^",5)
}

/// Desc:	编目后其他诊断 5 ICD
/// add by niucaicai 2013-02-04
Method OtherDiagnoseICD5() As %String
{
	s OtherDiagnoseICDStr = ##Class(EPRservice.HISInterface.DAEpisodeInfo).GetOtherDiagnoseICD(%this.EpisodeID)
	q $P(OtherDiagnoseICDStr,"^",5)
}

/// Desc:	编目后其他诊断 6 描述
/// add by niucaicai 2013-02-04
Method OtherDiagnoseDesc6() As %String
{
	s OtherDiagnoseDescStr = ##Class(EPRservice.HISInterface.DAEpisodeInfo).GetOtherDiagnoseDesc(%this.EpisodeID)
	q $P(OtherDiagnoseDescStr,"^",6)
}

/// Desc:	编目后其他诊断 6 ICD
/// add by niucaicai 2013-02-04
Method OtherDiagnoseICD6() As %String
{
	s OtherDiagnoseICDStr = ##Class(EPRservice.HISInterface.DAEpisodeInfo).GetOtherDiagnoseICD(%this.EpisodeID)
	q $P(OtherDiagnoseICDStr,"^",6)
}

/// Desc:	编目后其他诊断 7 描述
/// add by niucaicai 2013-02-04
Method OtherDiagnoseDesc7() As %String
{
	s OtherDiagnoseDescStr = ##Class(EPRservice.HISInterface.DAEpisodeInfo).GetOtherDiagnoseDesc(%this.EpisodeID)
	q $P(OtherDiagnoseDescStr,"^",7)
}

/// Desc:	编目后其他诊断 7 ICD
/// add by niucaicai 2013-02-04
Method OtherDiagnoseICD7() As %String
{
	s OtherDiagnoseICDStr = ##Class(EPRservice.HISInterface.DAEpisodeInfo).GetOtherDiagnoseICD(%this.EpisodeID)
	q $P(OtherDiagnoseICDStr,"^",7)
}

/// Desc:	编目后其他诊断 8 描述
/// add by niucaicai 2013-02-04
Method OtherDiagnoseDesc8() As %String
{
	s OtherDiagnoseDescStr = ##Class(EPRservice.HISInterface.DAEpisodeInfo).GetOtherDiagnoseDesc(%this.EpisodeID)
	q $P(OtherDiagnoseDescStr,"^",8)
}

/// Desc:	编目后其他诊断 8 ICD
/// add by niucaicai 2013-02-04
Method OtherDiagnoseICD8() As %String
{
	s OtherDiagnoseICDStr = ##Class(EPRservice.HISInterface.DAEpisodeInfo).GetOtherDiagnoseICD(%this.EpisodeID)
	q $P(OtherDiagnoseICDStr,"^",8)
}

/// Desc:	编目后其他诊断 9 描述
/// add by niucaicai 2013-02-04
Method OtherDiagnoseDesc9() As %String
{
	s OtherDiagnoseDescStr = ##Class(EPRservice.HISInterface.DAEpisodeInfo).GetOtherDiagnoseDesc(%this.EpisodeID)
	q $P(OtherDiagnoseDescStr,"^",9)
}

/// Desc:	编目后其他诊断 9 ICD
/// add by niucaicai 2013-02-04
Method OtherDiagnoseICD9() As %String
{
	s OtherDiagnoseICDStr = ##Class(EPRservice.HISInterface.DAEpisodeInfo).GetOtherDiagnoseICD(%this.EpisodeID)
	q $P(OtherDiagnoseICDStr,"^",9)
}

/// Desc:	编目后其他诊断 10 描述
/// add by niucaicai 2013-02-04
Method OtherDiagnoseDesc10() As %String
{
	s OtherDiagnoseDescStr = ##Class(EPRservice.HISInterface.DAEpisodeInfo).GetOtherDiagnoseDesc(%this.EpisodeID)
	q $P(OtherDiagnoseDescStr,"^",10)
}

/// Desc:	编目后其他诊断 10 ICD
/// add by niucaicai 2013-02-04
Method OtherDiagnoseICD10() As %String
{
	s OtherDiagnoseICDStr = ##Class(EPRservice.HISInterface.DAEpisodeInfo).GetOtherDiagnoseICD(%this.EpisodeID)
	q $P(OtherDiagnoseICDStr,"^",10)
}

// 添加其他诊断11至21

/// Desc:	编目后其他诊断 11 描述
/// add by niucaicai 2013-03-01
Method OtherDiagnoseDesc11() As %String
{
	s OtherDiagnoseDescStr = ##Class(EPRservice.HISInterface.DAEpisodeInfo).GetOtherDiagnoseDesc(%this.EpisodeID)
	q $P(OtherDiagnoseDescStr,"^",11)
}

/// Desc:	编目后其他诊断 11 ICD
/// add by niucaicai 2013-03-01
Method OtherDiagnoseICD11() As %String
{
	s OtherDiagnoseICDStr = ##Class(EPRservice.HISInterface.DAEpisodeInfo).GetOtherDiagnoseICD(%this.EpisodeID)
	q $P(OtherDiagnoseICDStr,"^",11)
}

/// Desc:	编目后其他诊断 12 描述
/// add by niucaicai 2013-03-01
Method OtherDiagnoseDesc12() As %String
{
	s OtherDiagnoseDescStr = ##Class(EPRservice.HISInterface.DAEpisodeInfo).GetOtherDiagnoseDesc(%this.EpisodeID)
	q $P(OtherDiagnoseDescStr,"^",12)
}

/// Desc:	编目后其他诊断 12 ICD
/// add by niucaicai 2013-03-01
Method OtherDiagnoseICD12() As %String
{
	s OtherDiagnoseICDStr = ##Class(EPRservice.HISInterface.DAEpisodeInfo).GetOtherDiagnoseICD(%this.EpisodeID)
	q $P(OtherDiagnoseICDStr,"^",12)
}

/// Desc:	编目后其他诊断 13 描述
/// add by niucaicai 2013-03-01
Method OtherDiagnoseDesc13() As %String
{
	s OtherDiagnoseDescStr = ##Class(EPRservice.HISInterface.DAEpisodeInfo).GetOtherDiagnoseDesc(%this.EpisodeID)
	q $P(OtherDiagnoseDescStr,"^",13)
}

/// Desc:	编目后其他诊断 13 ICD
/// add by niucaicai 2013-03-01
Method OtherDiagnoseICD13() As %String
{
	s OtherDiagnoseICDStr = ##Class(EPRservice.HISInterface.DAEpisodeInfo).GetOtherDiagnoseICD(%this.EpisodeID)
	q $P(OtherDiagnoseICDStr,"^",13)
}

/// Desc:	编目后其他诊断 14 描述
/// add by niucaicai 2013-03-01
Method OtherDiagnoseDesc14() As %String
{
	s OtherDiagnoseDescStr = ##Class(EPRservice.HISInterface.DAEpisodeInfo).GetOtherDiagnoseDesc(%this.EpisodeID)
	q $P(OtherDiagnoseDescStr,"^",14)
}

/// Desc:	编目后其他诊断 14 ICD
/// add by niucaicai 2013-03-01
Method OtherDiagnoseICD14() As %String
{
	s OtherDiagnoseICDStr = ##Class(EPRservice.HISInterface.DAEpisodeInfo).GetOtherDiagnoseICD(%this.EpisodeID)
	q $P(OtherDiagnoseICDStr,"^",14)
}

/// Desc:	编目后其他诊断 15 描述
/// add by niucaicai 2013-03-01
Method OtherDiagnoseDesc15() As %String
{
	s OtherDiagnoseDescStr = ##Class(EPRservice.HISInterface.DAEpisodeInfo).GetOtherDiagnoseDesc(%this.EpisodeID)
	q $P(OtherDiagnoseDescStr,"^",15)
}

/// Desc:	编目后其他诊断 15 ICD
/// add by niucaicai 2013-03-01
Method OtherDiagnoseICD15() As %String
{
	s OtherDiagnoseICDStr = ##Class(EPRservice.HISInterface.DAEpisodeInfo).GetOtherDiagnoseICD(%this.EpisodeID)
	q $P(OtherDiagnoseICDStr,"^",15)
}

/// Desc:	编目后其他诊断 16 描述
/// add by niucaicai 2013-03-01
Method OtherDiagnoseDesc16() As %String
{
	s OtherDiagnoseDescStr = ##Class(EPRservice.HISInterface.DAEpisodeInfo).GetOtherDiagnoseDesc(%this.EpisodeID)
	q $P(OtherDiagnoseDescStr,"^",16)
}

/// Desc:	编目后其他诊断 16 ICD
/// add by niucaicai 2013-03-01
Method OtherDiagnoseICD16() As %String
{
	s OtherDiagnoseICDStr = ##Class(EPRservice.HISInterface.DAEpisodeInfo).GetOtherDiagnoseICD(%this.EpisodeID)
	q $P(OtherDiagnoseICDStr,"^",16)
}

/// Desc:	编目后其他诊断 17 描述
/// add by niucaicai 2013-03-01
Method OtherDiagnoseDesc17() As %String
{
	s OtherDiagnoseDescStr = ##Class(EPRservice.HISInterface.DAEpisodeInfo).GetOtherDiagnoseDesc(%this.EpisodeID)
	q $P(OtherDiagnoseDescStr,"^",17)
}

/// Desc:	编目后其他诊断 17 ICD
/// add by niucaicai 2013-03-01
Method OtherDiagnoseICD17() As %String
{
	s OtherDiagnoseICDStr = ##Class(EPRservice.HISInterface.DAEpisodeInfo).GetOtherDiagnoseICD(%this.EpisodeID)
	q $P(OtherDiagnoseICDStr,"^",17)
}

/// Desc:	编目后其他诊断 18 描述
/// add by niucaicai 2013-03-01
Method OtherDiagnoseDesc18() As %String
{
	s OtherDiagnoseDescStr = ##Class(EPRservice.HISInterface.DAEpisodeInfo).GetOtherDiagnoseDesc(%this.EpisodeID)
	q $P(OtherDiagnoseDescStr,"^",18)
}

/// Desc:	编目后其他诊断 18 ICD
/// add by niucaicai 2013-03-01
Method OtherDiagnoseICD18() As %String
{
	s OtherDiagnoseICDStr = ##Class(EPRservice.HISInterface.DAEpisodeInfo).GetOtherDiagnoseICD(%this.EpisodeID)
	q $P(OtherDiagnoseICDStr,"^",18)
}

/// Desc:	编目后其他诊断 19 描述
/// add by niucaicai 2013-03-01
Method OtherDiagnoseDesc19() As %String
{
	s OtherDiagnoseDescStr = ##Class(EPRservice.HISInterface.DAEpisodeInfo).GetOtherDiagnoseDesc(%this.EpisodeID)
	q $P(OtherDiagnoseDescStr,"^",19)
}

/// Desc:	编目后其他诊断 19 ICD
/// add by niucaicai 2013-03-01
Method OtherDiagnoseICD19() As %String
{
	s OtherDiagnoseICDStr = ##Class(EPRservice.HISInterface.DAEpisodeInfo).GetOtherDiagnoseICD(%this.EpisodeID)
	q $P(OtherDiagnoseICDStr,"^",19)
}

/// Desc:	编目后其他诊断 20 描述
/// add by niucaicai 2013-03-01
Method OtherDiagnoseDesc20() As %String
{
	s OtherDiagnoseDescStr = ##Class(EPRservice.HISInterface.DAEpisodeInfo).GetOtherDiagnoseDesc(%this.EpisodeID)
	q $P(OtherDiagnoseDescStr,"^",20)
}

/// Desc:	编目后其他诊断 20 ICD
/// add by niucaicai 2013-03-01
Method OtherDiagnoseICD20() As %String
{
	s OtherDiagnoseICDStr = ##Class(EPRservice.HISInterface.DAEpisodeInfo).GetOtherDiagnoseICD(%this.EpisodeID)
	q $P(OtherDiagnoseICDStr,"^",20)
}

/// Desc:	编目后其他诊断 21 描述
/// add by niucaicai 2013-03-01
Method OtherDiagnoseDesc21() As %String
{
	s OtherDiagnoseDescStr = ##Class(EPRservice.HISInterface.DAEpisodeInfo).GetOtherDiagnoseDesc(%this.EpisodeID)
	q $P(OtherDiagnoseDescStr,"^",21)
}

/// Desc:	编目后其他诊断 21 ICD
/// add by niucaicai 2013-03-01
Method OtherDiagnoseICD21() As %String
{
	s OtherDiagnoseICDStr = ##Class(EPRservice.HISInterface.DAEpisodeInfo).GetOtherDiagnoseICD(%this.EpisodeID)
	q $P(OtherDiagnoseICDStr,"^",21)
}

/// Desc:	编目后手术1 描述
/// add by niucaicai 2017-07-12
Method OperationDesc1() As %String
{
	s OperationDescStr = ##Class(EPRservice.HISInterface.DAEpisodeInfo).GetOperationDesc(%this.EpisodeID)
	q $P(OperationDescStr,"^",1)
}

/// Desc:	编目后手术1 ICD
/// add by niucaicai 2017-07-12
Method OperationICD1() As %String
{
	s OperationICDStr = ##Class(EPRservice.HISInterface.DAEpisodeInfo).GetOperationICD(%this.EpisodeID)
	q $P(OperationICDStr,"^",1)
}

/// Desc:	编目后手术2 描述
/// add by niucaicai 2017-07-12
Method OperationDesc2() As %String
{
	s OperationDescStr = ##Class(EPRservice.HISInterface.DAEpisodeInfo).GetOperationDesc(%this.EpisodeID)
	q $P(OperationDescStr,"^",2)
}

/// Desc:	编目后手术2 ICD
/// add by niucaicai 2017-07-12
Method OperationICD2() As %String
{
	s OperationICDStr = ##Class(EPRservice.HISInterface.DAEpisodeInfo).GetOperationICD(%this.EpisodeID)
	q $P(OperationICDStr,"^",2)
}

/// Desc:	编目后手术3 描述
/// add by niucaicai 2017-07-12
Method OperationDesc3() As %String
{
	s OperationDescStr = ##Class(EPRservice.HISInterface.DAEpisodeInfo).GetOperationDesc(%this.EpisodeID)
	q $P(OperationDescStr,"^",3)
}

/// Desc:	编目后手术3 ICD
/// add by niucaicai 2017-07-12
Method OperationICD3() As %String
{
	s OperationICDStr = ##Class(EPRservice.HISInterface.DAEpisodeInfo).GetOperationICD(%this.EpisodeID)
	q $P(OperationICDStr,"^",3)
}

/// Desc:	编目后手术4 描述
/// add by niucaicai 2017-07-12
Method OperationDesc4() As %String
{
	s OperationDescStr = ##Class(EPRservice.HISInterface.DAEpisodeInfo).GetOperationDesc(%this.EpisodeID)
	q $P(OperationDescStr,"^",4)
}

/// Desc:	编目后手术4 ICD
/// add by niucaicai 2017-07-12
Method OperationICD4() As %String
{
	s OperationICDStr = ##Class(EPRservice.HISInterface.DAEpisodeInfo).GetOperationICD(%this.EpisodeID)
	q $P(OperationICDStr,"^",4)
}

/// Desc:	编目后手术5 描述
/// add by niucaicai 2017-07-12
Method OperationDesc5() As %String
{
	s OperationDescStr = ##Class(EPRservice.HISInterface.DAEpisodeInfo).GetOperationDesc(%this.EpisodeID)
	q $P(OperationDescStr,"^",5)
}

/// Desc:	编目后手术5 ICD
/// add by niucaicai 2017-07-12
Method OperationICD5() As %String
{
	s OperationICDStr = ##Class(EPRservice.HISInterface.DAEpisodeInfo).GetOperationICD(%this.EpisodeID)
	q $P(OperationICDStr,"^",5)
}

/// Desc:	编目后操作6 描述
/// add by niucaicai 2017-07-12
Method OperationDesc6() As %String
{
	s OperationDescStr = ##Class(EPRservice.HISInterface.DAEpisodeInfo).GetOperationDesc(%this.EpisodeID)
	q $P(OperationDescStr,"^",6)
}

/// Desc:	编目后操作6 ICD
/// add by niucaicai 2017-07-12
Method OperationICD6() As %String
{
	s OperationICDStr = ##Class(EPRservice.HISInterface.DAEpisodeInfo).GetOperationICD(%this.EpisodeID)
	q $P(OperationICDStr,"^",6)
}

/// Desc:	编目后操作7 描述
/// add by niucaicai 2017-07-12
Method OperationDesc7() As %String
{
	s OperationDescStr = ##Class(EPRservice.HISInterface.DAEpisodeInfo).GetOperationDesc(%this.EpisodeID)
	q $P(OperationDescStr,"^",7)
}

/// Desc:	编目后操作7 ICD
/// add by niucaicai 2017-07-12
Method OperationICD7() As %String
{
	s OperationICDStr = ##Class(EPRservice.HISInterface.DAEpisodeInfo).GetOperationICD(%this.EpisodeID)
	q $P(OperationICDStr,"^",7)
}

/// Desc:	编目后操作8 描述
/// add by niucaicai 2017-07-12
Method OperationDesc8() As %String
{
	s OperationDescStr = ##Class(EPRservice.HISInterface.DAEpisodeInfo).GetOperationDesc(%this.EpisodeID)
	q $P(OperationDescStr,"^",8)
}

/// Desc:	编目后操作8 ICD
/// add by niucaicai 2017-07-12
Method OperationICD8() As %String
{
	s OperationICDStr = ##Class(EPRservice.HISInterface.DAEpisodeInfo).GetOperationICD(%this.EpisodeID)
	q $P(OperationICDStr,"^",8)
}

/// Desc:	编目后操作9 描述
/// add by niucaicai 2017-07-12
Method OperationDesc9() As %String
{
	s OperationDescStr = ##Class(EPRservice.HISInterface.DAEpisodeInfo).GetOperationDesc(%this.EpisodeID)
	q $P(OperationDescStr,"^",9)
}

/// Desc:	编目后操作9 ICD
/// add by niucaicai 2017-07-12
Method OperationICD9() As %String
{
	s OperationICDStr = ##Class(EPRservice.HISInterface.DAEpisodeInfo).GetOperationICD(%this.EpisodeID)
	q $P(OperationICDStr,"^",9)
}

/// Desc:	编目后操作10 描述
/// add by niucaicai 2017-07-12
Method OperationDesc10() As %String
{
	s OperationDescStr = ##Class(EPRservice.HISInterface.DAEpisodeInfo).GetOperationDesc(%this.EpisodeID)
	q $P(OperationDescStr,"^",10)
}

/// Desc:	编目后操作10 ICD
/// add by niucaicai 2017-07-12
Method OperationICD10() As %String
{
	s OperationICDStr = ##Class(EPRservice.HISInterface.DAEpisodeInfo).GetOperationICD(%this.EpisodeID)
	q $P(OperationICDStr,"^",10)
}

/// Desc:	总费用
Method TMCTotal() As %String
{
	s TMCTotal = ##Class(EPRservice.HISInterface.DAEpisodeInfo).GetTMCTotal(%this.EpisodeID)
	q TMCTotal
}

/// Desc:	出院条件
Method ConditAtDischDR() As %String
{
	s ConditAtDischDR = ##Class(EPRservice.HISInterface.DAEpisodeInfo).GetConditAtDischDR(%this.EpisodeID)
	q ConditAtDischDR
}

/// Desc:	病案子类费用合计
Method MCTotal() As %String
{
	s MCTotal = ##Class(EPRservice.HISInterface.DAEpisodeInfo).GetMCTotal(%this.EpisodeID)
	q MCTotal
}

/// Desc:	一般医疗服务费
Method MCYBYLFWF() As %String
{
	s MCYBYLFWF = ##Class(EPRservice.HISInterface.DAEpisodeInfo).GetMCYBYLFWF(%this.EpisodeID)
	q MCYBYLFWF
}

/// Desc:	一般治疗操作费
Method MCYBZLCZF() As %String
{
	s MCYBZLCZF = ##Class(EPRservice.HISInterface.DAEpisodeInfo).GetMCYBZLCZF(%this.EpisodeID)
	q MCYBZLCZF
}

/// Desc:	护理费
Method MCHLF() As %String
{
	s MCHLF = ##Class(EPRservice.HISInterface.DAEpisodeInfo).GetMCHLF(%this.EpisodeID)
	q MCHLF
}

/// Desc:	其他费用
Method MCQTFY() As %String
{
	s MCQTFY = ##Class(EPRservice.HISInterface.DAEpisodeInfo).GetMCQTFY(%this.EpisodeID)
	q MCQTFY
}

/// Desc:	病理诊断费
Method MCBLZDF() As %String
{
	s MCBLZDF = ##Class(EPRservice.HISInterface.DAEpisodeInfo).GetMCBLZDF(%this.EpisodeID)
	q MCBLZDF
}

/// Desc:	实验室诊断费
Method MCSYSZDF() As %String
{
	s MCSYSZDF = ##Class(EPRservice.HISInterface.DAEpisodeInfo).GetMCSYSZDF(%this.EpisodeID)
	q MCSYSZDF
}

/// Desc:	影像学诊断费
Method MCYXXZDF() As %String
{
	s MCYXXZDF = ##Class(EPRservice.HISInterface.DAEpisodeInfo).GetMCYXXZDF(%this.EpisodeID)
	q MCYXXZDF
}

/// Desc:	临床诊断项目费
Method MCLCZDXMF() As %String
{
	s MCLCZDXMF = ##Class(EPRservice.HISInterface.DAEpisodeInfo).GetMCLCZDXMF(%this.EpisodeID)
	q MCLCZDXMF
}

/// Desc:	临床物理治疗费
Method MCLCWLZLF() As %String
{
	s MCLCWLZLF = ##Class(EPRservice.HISInterface.DAEpisodeInfo).GetMCLCWLZLF(%this.EpisodeID)
	q MCLCWLZLF
}

/// Desc:	麻醉费
Method MCMZF() As %String
{
	s MCMZF = ##Class(EPRservice.HISInterface.DAEpisodeInfo).GetMCMZF(%this.EpisodeID)
	q MCMZF
}

/// Desc:	手术费
Method MCSSF() As %String
{
	s MCSSF = ##Class(EPRservice.HISInterface.DAEpisodeInfo).GetMCSSF(%this.EpisodeID)
	q MCSSF
}

/// Desc:	康复费
Method MCKFF() As %String
{
	s MCKFF = ##Class(EPRservice.HISInterface.DAEpisodeInfo).GetMCKFF(%this.EpisodeID)
	q MCKFF
}

/// Desc:	中医诊断
Method MCZYZD() As %String
{
	s MCZYZD = ##Class(EPRservice.HISInterface.DAEpisodeInfo).GetMCZYZD(%this.EpisodeID)
	q MCZYZD
}

/// Desc:	中医外治
Method MCZYWZ() As %String
{
	s MCZYWZ = ##Class(EPRservice.HISInterface.DAEpisodeInfo).GetMCZYWZ(%this.EpisodeID)
	q MCZYWZ
}

/// Desc:	针刺与灸法
Method MCZCYJF() As %String
{
	s MCZCYJF = ##Class(EPRservice.HISInterface.DAEpisodeInfo).GetMCZCYJF(%this.EpisodeID)
	q MCZCYJF
}

/// Desc:	中医推拿治疗
Method MCZYTNZL() As %String
{
	s MCZYTNZL = ##Class(EPRservice.HISInterface.DAEpisodeInfo).GetMCZYTNZL(%this.EpisodeID)
	q MCZYTNZL
}

/// Desc:	中医肛肠治疗
Method MCZYGCZL() As %String
{
	s MCZYGCZL = ##Class(EPRservice.HISInterface.DAEpisodeInfo).GetMCZYGCZL(%this.EpisodeID)
	q MCZYGCZL
}

/// Desc:	中医特殊治疗
Method MCZYTSZL() As %String
{
	s MCZYTSZL = ##Class(EPRservice.HISInterface.DAEpisodeInfo).GetMCZYTSZL(%this.EpisodeID)
	q MCZYTSZL
}

/// Desc:	中医特殊调配加工
Method MCZYTSTPJG() As %String
{
	s MCZYTSTPJG = ##Class(EPRservice.HISInterface.DAEpisodeInfo).GetMCZYTSTPJG(%this.EpisodeID)
	q MCZYTSTPJG
}

/// Desc:	辩证施膳
Method MCBZSS() As %String
{
	s MCBZSS = ##Class(EPRservice.HISInterface.DAEpisodeInfo).GetMCBZSS(%this.EpisodeID)
	q MCBZSS
}

/// Desc:	西药费
Method MCXYF() As %String
{
	s MCXYF = ##Class(EPRservice.HISInterface.DAEpisodeInfo).GetMCXYF(%this.EpisodeID)
	q MCXYF
}

/// Desc:	西药制剂费
Method MCXYZJF() As %String
{
	s MCXYZJF = ##Class(EPRservice.HISInterface.DAEpisodeInfo).GetMCXYZJF(%this.EpisodeID)
	q MCXYZJF
}

/// Desc:	抗菌药物费用
Method MCKJYWFY() As %String
{
	s MCKJYWFY = ##Class(EPRservice.HISInterface.DAEpisodeInfo).GetMCKJYWFY(%this.EpisodeID)
	q MCKJYWFY
}

/// Desc:	中成药费
Method MCZCYF() As %String
{
	s MCZCYF = ##Class(EPRservice.HISInterface.DAEpisodeInfo).GetMCZCYF(%this.EpisodeID)
	q MCZCYF
}

/// Desc:	中药制剂费
Method MCZYZJF() As %String
{
	s MCZYZJF = ##Class(EPRservice.HISInterface.DAEpisodeInfo).GetMCZYZJF(%this.EpisodeID)
	q MCZYZJF
}

/// Desc:	中草药费
Method MCZCaoYF() As %String
{
	s MCZCaoYF = ##Class(EPRservice.HISInterface.DAEpisodeInfo).GetMCZCaoYF(%this.EpisodeID)
	q MCZCaoYF
}

/// Desc:	血费
Method MCXF() As %String
{
	s MCXF = ##Class(EPRservice.HISInterface.DAEpisodeInfo).GetMCXF(%this.EpisodeID)
	q MCXF
}

/// Desc:	白蛋白类制品费
Method MCBDBLZPF() As %String
{
	s MCBDBLZPF = ##Class(EPRservice.HISInterface.DAEpisodeInfo).GetMCBDBLZPF(%this.EpisodeID)
	q MCBDBLZPF
}

/// Desc:	球蛋白类制品费
Method MCQDBLZPF() As %String
{
	s MCQDBLZPF = ##Class(EPRservice.HISInterface.DAEpisodeInfo).GetMCQDBLZPF(%this.EpisodeID)
	q MCQDBLZPF
}

/// Desc:	凝血因子类制品费
Method MCNXYZLZPF() As %String
{
	s MCNXYZLZPF = ##Class(EPRservice.HISInterface.DAEpisodeInfo).GetMCNXYZLZPF(%this.EpisodeID)
	q MCNXYZLZPF
}

/// Desc:	细胞因子类制品费
Method MCXBYZLZPF() As %String
{
	s MCXBYZLZPF = ##Class(EPRservice.HISInterface.DAEpisodeInfo).GetMCXBYZLZPF(%this.EpisodeID)
	q MCXBYZLZPF
}

/// Desc:	检查用一次性医用材料费
Method MCJCYYCXYYCLF() As %String
{
	s MCJCYYCXYYCLF = ##Class(EPRservice.HISInterface.DAEpisodeInfo).GetMCJCYYCXYYCLF(%this.EpisodeID)
	q MCJCYYCXYYCLF
}

/// Desc:	治疗用一次性医用材料费
Method MCZLYYCXYYCLF() As %String
{
	s MCZLYYCXYYCLF = ##Class(EPRservice.HISInterface.DAEpisodeInfo).GetMCZLYYCXYYCLF(%this.EpisodeID)
	q MCZLYYCXYYCLF
}

/// Desc:	手术用一次性医用材料费
Method MCSSYYCXYYCLF() As %String
{
	s MCSSYYCXYYCLF = ##Class(EPRservice.HISInterface.DAEpisodeInfo).GetMCSSYYCXYYCLF(%this.EpisodeID)
	q MCSSYYCXYYCLF
}

/// Desc:	其他费
Method MCQTF() As %String
{
	s MCQTF = ##Class(EPRservice.HISInterface.DAEpisodeInfo).GetMCQTF(%this.EpisodeID)
	q MCQTF
}

/// Desc:	中医骨伤
Method MCZYGS() As %String
{
	s MCZYGS = ##Class(EPRservice.HISInterface.DAEpisodeInfo).GetMCZYGS(%this.EpisodeID)
	q MCZYGS
}

/// Desc:	中医辨证论治费
Method MCZYBZLZF() As %String
{
	s MCZYBZLZF = ##Class(EPRservice.HISInterface.DAEpisodeInfo).GetMCZYBZLZF(%this.EpisodeID)
	q MCZYBZLZF
}

/// Desc:	中医辨证论治会诊费
Method MCZYBZLZHZF() As %String
{
	s MCZYBZLZHZF = ##Class(EPRservice.HISInterface.DAEpisodeInfo).GetMCZYBZLZHZF(%this.EpisodeID)
	q MCZYBZLZHZF
}

/// Desc:	一般费用总和
Method MCYBFYZH() As %String
{
	s MCYBFYZH = ##Class(EPRservice.HISInterface.DAEpisodeInfo).GetMCYBFYZH(%this.EpisodeID)
	q MCYBFYZH
}

/// Desc:	中医治疗
Method MCZYZL() As %String
{
	s MCZYZL = ##Class(EPRservice.HISInterface.DAEpisodeInfo).GetMCZYZL(%this.EpisodeID)
	q MCZYZL
}

/// Desc:	中医其他
Method MCZYQT() As %String
{
	s MCZYQT = ##Class(EPRservice.HISInterface.DAEpisodeInfo).GetMCZYQT(%this.EpisodeID)
	q MCZYQT
}

/// Desc:	西药费总和
Method MCXYFZH() As %String
{
	s MCXYFZH = ##Class(EPRservice.HISInterface.DAEpisodeInfo).GetMCXYFZH(%this.EpisodeID)
	q MCXYFZH
}

/// Desc:	手术治疗费
Method MCSSZLF() As %String
{
	s MCSSZLF = ##Class(EPRservice.HISInterface.DAEpisodeInfo).GetMCSSZLF(%this.EpisodeID)
	q MCSSZLF
}

/// Desc:	中成药费总和
Method MCZCYFZH() As %String
{
	s MCZCYFZH = ##Class(EPRservice.HISInterface.DAEpisodeInfo).GetMCZCYFZH(%this.EpisodeID)
	q MCZCYFZH
}

/// Debug: 	d ##Class(EPRservice.BLL.Query.BLHISInfo).Test("201869")
ClassMethod Test(AEpisodeID As %String)
{
	s obj = ##Class(EPRservice.BLL.Query.BLHISInfo).CreateInstance(AEpisodeID)
	w !, "EpisodeID:"_obj.EpisodeID()
	w !, "EpisodeNo:"_obj.EpisodeNo()
	w !, "RegNo:"_obj.RegNo()
	w !, "RecordNo:"_obj.RecordNo()
	w !, "Name:"_obj.Name()
	w !, "Gender:"_obj.Gender()
	w !, "BirthDate:"_obj.BirthDate()
	w !, "AdmType:"_obj.AdmType()
	w !, "AdmDate:"_obj.AdmDate()
	w !, "AdmTime:"_obj.AdmTime()
	w !, "AdmDept:"_obj.AdmDept()
	w !, "AdmWard:"_obj.AdmWard()
	w !, "DischDate:"_obj.DischDate()
	w !, "DischTime:"_obj.DischTime()
	w !, "DischDept:"_obj.DischDept()
	w !, "DischWard:"_obj.DischWard()
	w !, "MainDoc:"_obj.MainDoc()
	w !, "CurRoom:"_obj.CurRoom()
	w !, "CurBed:"_obj.CurBed()
}

}
