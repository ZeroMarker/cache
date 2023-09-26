/// Desc:查询信息
/// Creator:Candy
Class DHCEPRFS.BL.BLQueryClassMethod Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

// 基本信息

/// Desc: 病人标识号
ClassMethod PatientID(MrEpisodeID As %String) As %List
{
	s result = $lb("")
	q:(MrEpisodeID = "") result
	s MrPatientID = $lg(^DHCEPRFS.INST.MREpisodeD(MrEpisodeID),2)
	q:(MrPatientID = "") result
	s result = $lg(^DHCEPRFS.INST.MRPatientD(MrPatientID),3)
	s result = $lb(result)
	q result
}

/// Desc: 医疗组织机构代码
ClassMethod CompanyCode(MrEpisodeID As %String) As %List
{
	s result = $lb("")
	q:(MrEpisodeID = "") result
	s MrPatientID = $lg(^DHCEPRFS.INST.MREpisodeD(MrEpisodeID),2)
	q:(MrPatientID = "") result
	s result = $lg(^DHCEPRFS.INST.MRPatientD(MrPatientID),4)
	s result = $lb(result)
	q result
}

/// Desc: 登记号
ClassMethod RegNo(MrEpisodeID As %String) As %List
{
	s result = $lb("")
	q:(MrEpisodeID = "") result
	s MrPatientID = $lg(^DHCEPRFS.INST.MREpisodeD(MrEpisodeID),2)
	q:(MrPatientID = "") result
	s result = $lg(^DHCEPRFS.INST.MRPatientD(MrPatientID),12)
	s result = $lb(result)
	q result
}

/// Desc:姓名 -查询条件及结果
ClassMethod Name(MrEpisodeID As %String) As %List
{
	s result = $lb("")
	q:(MrEpisodeID = "") result
	s MrPatientID = $lg(^DHCEPRFS.INST.MREpisodeD(MrEpisodeID),2)
	q:(MrPatientID = "") result
	s result = $lg(^DHCEPRFS.INST.MRPatientD(MrPatientID),13)
	s result = $lb(result)
	q result
}

/// Desc:性别 -查询条件及结果
ClassMethod Gender(MrEpisodeID As %String) As %List
{
	s result = $lb("")
	q:(MrEpisodeID = "") result
	s MrPatientID = $lg(^DHCEPRFS.INST.MREpisodeD(MrEpisodeID),2)
	q:(MrPatientID = "") result
	s result = $lg(^DHCEPRFS.INST.MRPatientD(MrPatientID),14)
	s result = $lb(result)
	q result
}

/// Desc: 生日
ClassMethod Birthday(MrEpisodeID As %String) As %List
{
	s result = $lb("")
	q:(MrEpisodeID = "") result
	s MrPatientID = $lg(^DHCEPRFS.INST.MREpisodeD(MrEpisodeID),2)
	q:(MrPatientID = "") result
	s Birthday = $lg(^DHCEPRFS.INST.MRPatientD(MrPatientID),15)
	q:(Birthday = "") result
	s Birthday = $zd(Birthday,3)
	s result = $lb(Birthday)
	q result
}

/// Desc: 年龄
ClassMethod Age(MrEpisodeID As %String) As %List
{
	s result = $lb("")
	q:(MrEpisodeID = "") result
	s MrPatientID = $lg(^DHCEPRFS.INST.MREpisodeD(MrEpisodeID),2)
	q:(MrPatientID = "") result
	s Age = $lg(^DHCEPRFS.INST.MRPatientD(MrPatientID),16)
	s:(Age = "") Age = ($p($h,",",1)-$lg(^DHCEPRFS.INST.MRPatientD(MrPatientID),15))\365
	s result = $lb(Age)
	q result
}

/// Desc: 婚姻状况 -查询条件及结果
ClassMethod Marriage(MrEpisodeID As %String) As %List
{
	s result = $lb("")
	q:(MrEpisodeID = "") result
	s MrPatientID = $lg(^DHCEPRFS.INST.MREpisodeD(MrEpisodeID),2)
	q:(MrPatientID = "") result
	s result = $lg(^DHCEPRFS.INST.MRPatientD(MrPatientID),17)
	s result = $lb(result)
	q result
}

/// Desc: 民族 -查询条件及结果
ClassMethod Nationality(MrEpisodeID As %String) As %List
{
 
	s result = $lb("")
	q:(MrEpisodeID = "") result
	s MrPatientID = $lg(^DHCEPRFS.INST.MREpisodeD(MrEpisodeID),2)
	q:(MrPatientID = "") result
	s result = $lg(^DHCEPRFS.INST.MRPatientD(MrPatientID),18)
	s result = $lb(result)
	q result
}

/// Desc: 身份证号 -查询条件及结果
ClassMethod IDCard(MrEpisodeID As %String) As %List
{
	s result = $lb("")
	q:(MrEpisodeID = "") result
	s MrPatientID = $lg(^DHCEPRFS.INST.MREpisodeD(MrEpisodeID),2)
	q:(MrPatientID = "") result
	s result = $lg(^DHCEPRFS.INST.MRPatientD(MrPatientID),19)
	s result = $lb(result)
	q result
}

/// Desc: 医保类型 -查询条件及结果
ClassMethod InsuType(MrEpisodeID As %String) As %List
{
	s result = $lb("")
	q:(MrEpisodeID = "") result
	s MrPatientID = $lg(^DHCEPRFS.INST.MREpisodeD(MrEpisodeID),2)
	q:(MrPatientID = "") result
	s result = $lg(^DHCEPRFS.INST.MRPatientD(MrPatientID),24)
	s result = $lb(result)
	q result
}

/// Desc: 医保号 -查询条件及结果
ClassMethod InsuNo(MrEpisodeID As %String) As %List
{
	s result = $lb("")
	q:(MrEpisodeID = "") result
	s MrPatientID = $lg(^DHCEPRFS.INST.MREpisodeD(MrEpisodeID),2)
	q:(MrPatientID = "") result
	s result = $lg(^DHCEPRFS.INST.MRPatientD(MrPatientID),25)
	s result = $lb(result)
	q result
}

/// Desc: 手机号 -查询条件及结果
ClassMethod PhoneNo(MrEpisodeID As %String) As %List
{
	s result = $lb("")
	q:(MrEpisodeID = "") result
	s MrPatientID = $lg(^DHCEPRFS.INST.MREpisodeD(MrEpisodeID),2)
	q:(MrPatientID = "") result
	s result = $lg(^DHCEPRFS.INST.MRPatientD(MrPatientID),26)
	s result = $lb(result)
	q result
}

/// Desc: 联系人姓名 -查询条件及结果
ClassMethod LinkName(MrEpisodeID As %String) As %List
{
	s result = $lb("")
	q:(MrEpisodeID = "") result
	s MrPatientID = $lg(^DHCEPRFS.INST.MREpisodeD(MrEpisodeID),2)
	q:(MrPatientID = "") result
	s result = $lg(^DHCEPRFS.INST.MRPatientD(MrPatientID),27)
	s result = $lb(result)
	q result
}

/// Desc: 联系人关系 -查询条件及结果
ClassMethod LinkRelation(MrEpisodeID As %String) As %List
{
	s result = $lb("")
	q:(MrEpisodeID = "") result
	s MrPatientID = $lg(^DHCEPRFS.INST.MREpisodeD(MrEpisodeID),2)
	q:(MrPatientID = "") result
	s result = $lg(^DHCEPRFS.INST.MRPatientD(MrPatientID),28)
	s result = $lb(result)
	q result
}

/// Desc: 联系人电话 -查询条件及结果
ClassMethod LinkPhone(MrEpisodeID As %String) As %List
{
	s result = $lb("")
	q:(MrEpisodeID = "") result
	s MrPatientID = $lg(^DHCEPRFS.INST.MREpisodeD(MrEpisodeID),2)
	q:(MrPatientID = "") result
	s result = $lg(^DHCEPRFS.INST.MRPatientD(MrPatientID),29)
	s result = $lb(result)
	q result
}

/// Desc: 职业 -查询条件及结果
ClassMethod Occupation(MrEpisodeID As %String) As %List
{
	s result = $lb("")
	q:(MrEpisodeID = "") result
	s MrPatientID = $lg(^DHCEPRFS.INST.MREpisodeD(MrEpisodeID),2)
	q:(MrPatientID = "") result
	s result = $lg(^DHCEPRFS.INST.MRPatientD(MrPatientID),30)
	s result = $lb(result)
	q result
}

/// Desc: 工作单位 -查询条件及结果
ClassMethod Company(MrEpisodeID As %String) As %List
{
	s result = $lb("")
	q:(MrEpisodeID = "") result
	s MrPatientID = $lg(^DHCEPRFS.INST.MREpisodeD(MrEpisodeID),2)
	q:(MrPatientID = "") result
	s result = $lg(^DHCEPRFS.INST.MRPatientD(MrPatientID),31)
	s result = $lb(result)
	q result
}

/// Desc: 工作电话 -查询条件及结果
ClassMethod Worktel(MrEpisodeID As %String) As %List
{
	s result = $lb("")
	q:(MrEpisodeID = "") result
	s MrPatientID = $lg(^DHCEPRFS.INST.MREpisodeD(MrEpisodeID),2)
	q:(MrPatientID = "") result
	s result = $lg(^DHCEPRFS.INST.MRPatientD(MrPatientID),32)
	s result = $lb(result)
	q result
}

/// Desc: 户口地址省 -查询条件及结果
ClassMethod HouseProvince(MrEpisodeID As %String) As %List
{
	s result = $lb("")
	q:(MrEpisodeID = "") result
	s MrPatientID = $lg(^DHCEPRFS.INST.MREpisodeD(MrEpisodeID),2)
	q:(MrPatientID = "") result
	s result = $lg(^DHCEPRFS.INST.MRPatientD(MrPatientID),33)
	s result = $lb(result)
	q result
}

/// Desc: 户口地址市 -查询条件及结果
ClassMethod HouseCity(MrEpisodeID As %String) As %List
{
	s result = $lb("")
	q:(MrEpisodeID = "") result
	s MrPatientID = $lg(^DHCEPRFS.INST.MREpisodeD(MrEpisodeID),2)
	q:(MrPatientID = "") result
	s result = $lg(^DHCEPRFS.INST.MRPatientD(MrPatientID),34)
	s result = $lb(result)
	q result
}

/// Desc: 户口地址县区 -查询条件及结果
ClassMethod HouseArea(MrEpisodeID As %String) As %List
{
	s result = $lb("")
	q:(MrEpisodeID = "") result
	s MrPatientID = $lg(^DHCEPRFS.INST.MREpisodeD(MrEpisodeID),2)
	q:(MrPatientID = "") result
	s result = $lg(^DHCEPRFS.INST.MRPatientD(MrPatientID),35)
	s result = $lb(result)
	q result
}

/// Desc: 户口地址 -查询条件及结果
ClassMethod HouseAddress(MrEpisodeID As %String) As %List
{
	s result = $lb("")
	q:(MrEpisodeID = "") result
	s MrPatientID = $lg(^DHCEPRFS.INST.MREpisodeD(MrEpisodeID),2)
	q:(MrPatientID = "") result
	s result = $lg(^DHCEPRFS.INST.MRPatientD(MrPatientID),36)
	s result = $lb(result)
	q result
}

/// Desc: 户口邮编 -查询条件及结果
ClassMethod HouseZipCode(MrEpisodeID As %String) As %List
{
	s result = $lb("")
	q:(MrEpisodeID = "") result
	s MrPatientID = $lg(^DHCEPRFS.INST.MREpisodeD(MrEpisodeID),2)
	q:(MrPatientID = "") result
	s result = $lg(^DHCEPRFS.INST.MRPatientD(MrPatientID),37)
	s result = $lb(result)
	q result
}

/// Desc: 现住址省 -查询条件及结果
ClassMethod ResidentProvince(MrEpisodeID As %String) As %List
{
	s result = $lb("")
	q:(MrEpisodeID = "") result
	s MrPatientID = $lg(^DHCEPRFS.INST.MREpisodeD(MrEpisodeID),2)
	q:(MrPatientID = "") result
	s result = $lg(^DHCEPRFS.INST.MRPatientD(MrPatientID),38)
	s result = $lb(result)
	q result
}

/// Desc: 现住址市 -查询条件及结果
ClassMethod ResidentCity(MrEpisodeID As %String) As %List
{
	s result = $lb("")
	q:(MrEpisodeID = "") result
	s MrPatientID = $lg(^DHCEPRFS.INST.MREpisodeD(MrEpisodeID),2)
	q:(MrPatientID = "") result
	s result = $lg(^DHCEPRFS.INST.MRPatientD(MrPatientID),39)
	s result = $lb(result)
	q result
}

/// Desc: 现住址县区 -查询条件及结果
ClassMethod ResidentArea(MrEpisodeID As %String) As %List
{
	s result = $lb("")
	q:(MrEpisodeID = "") result
	s MrPatientID = $lg(^DHCEPRFS.INST.MREpisodeD(MrEpisodeID),2)
	q:(MrPatientID = "") result
	s result = $lg(^DHCEPRFS.INST.MRPatientD(MrPatientID),40)
	s result = $lb(result)
	q result
}

/// Desc: 现住址地址 -查询条件及结果
ClassMethod ResidentAddress(MrEpisodeID As %String) As %List
{
	s result = $lb("")
	q:(MrEpisodeID = "") result
	s MrPatientID = $lg(^DHCEPRFS.INST.MREpisodeD(MrEpisodeID),2)
	q:(MrPatientID = "") result
	s result = $lg(^DHCEPRFS.INST.MRPatientD(MrPatientID),41)
	s result = $lb(result)
	q result
}

/// Desc: 现住址邮编 -查询条件及结果
ClassMethod ResidentZipCode(MrEpisodeID As %String) As %List
{
	s result = $lb("")
	q:(MrEpisodeID = "") result
	s MrPatientID = $lg(^DHCEPRFS.INST.MREpisodeD(MrEpisodeID),2)
	q:(MrPatientID = "") result
	s result = $lg(^DHCEPRFS.INST.MRPatientD(MrPatientID),42)
	s result = $lb(result)
	q result
}

// 就诊信息

/// Desc:就诊ID
ClassMethod EpisodeID(MrEpisodeID As %String) As %List
{
	s result = $lb("")
	q:(MrEpisodeID = "") result
	s result = $lg(^DHCEPRFS.INST.MREpisodeD(MrEpisodeID),4)
	s result = $lb(result)
	q result
}

/// Desc:病案号 -查询条件及结果
ClassMethod MedRecordNo(MrEpisodeID As %String) As %List
{
    s result = $lb("")
 	q:(MrEpisodeID = "") result
	s result = $lg(^DHCEPRFS.INST.MREpisodeD(MrEpisodeID),11)
	s result = $lb(result)
	q result
}

/// Desc: 就诊科室 -查询条件及结果
ClassMethod AdmLocID(MrEpisodeID As %String) As %List
{
	s result = $lb("")
	q:(MrEpisodeID = "") result
	s result = $lg(^DHCEPRFS.INST.MREpisodeD(MrEpisodeID),27)
	s result = $lb(result)
	q result
}

/// Desc: 就诊科室
ClassMethod AdmLoc(MrEpisodeID As %String) As %List
{
	s result = $lb("")
	q:(MrEpisodeID = "") result
	s result = $lg(^DHCEPRFS.INST.MREpisodeD(MrEpisodeID),21)
	s result = $lb(result)
	q result
}

/// Desc: 出院科室 -查询条件及结果
/// Debug: w ##Class(DHCEPRFS.BL.BLQueryClassMethod).DisLoc(1)
ClassMethod DisLoc(MrEpisodeID As %String) As %List
{
	s result = $lb("")
	q:(MrEpisodeID = "") result
	s result = $lg(^DHCEPRFS.INST.MREpisodeD(MrEpisodeID),23)
	s result = $lb(result)
	q result
}

/// Desc:转科科室
ClassMethod TransDept(MrEpisodeID As %String) As %List
{
	s result = $lb("")
	q:(MrEpisodeID = "") result
	s result = $lg(^DHCEPRFS.INST.MREpisodeD(MrEpisodeID),33)
	s result = $lb(result)
	q result
}

/// Desc: 就诊总次数
ClassMethod AdmNum(MrEpisodeID As %String) As %List
{
	s result = $lb("")
	q:(MrEpisodeID = "") result
	s result = $lg(^DHCEPRFS.INST.MREpisodeD(MrEpisodeID),9)
	s result = $lb(result)
	q result
}

/// Desc: 入院总次数 -查询条件及结果
ClassMethod InNum(MrEpisodeID As %String) As %List
{
	s result = $lb("")
	q:(MrEpisodeID = "") result
	s result = $lg(^DHCEPRFS.INST.MREpisodeD(MrEpisodeID),10)
	s result = $lb(result)
	q result
}

/// Desc: 就诊日期 -查询条件及结果
ClassMethod AdmDate(MrEpisodeID As %String) As %List
{
	s result = $lb("")
	q:(MrEpisodeID = "") result
	s AdmDate = $lg(^DHCEPRFS.INST.MREpisodeD(MrEpisodeID),15)
	q:(AdmDate = "") result
	s AdmDate = $zd(AdmDate,3)
	s result = $lb(AdmDate)
	q result
}

/// Desc: 入院病区 -查询条件及结果
ClassMethod AdmWard(MrEpisodeID As %String) As %List
{
	s result = $lb("")
	q:(MrEpisodeID = "") result
	s result = $lg(^DHCEPRFS.INST.MREpisodeD(MrEpisodeID),22)
	s result = $lb(result)
	q result
}

/// Desc: 出院病区 -查询条件及结果
ClassMethod DisWard(MrEpisodeID As %String) As %List
{
	s result = $lb("")
	q:(MrEpisodeID = "") result
	s result = $lg(^DHCEPRFS.INST.MREpisodeD(MrEpisodeID),24)
	s result = $lb(result)
	q result
}

/// Desc: 就诊时间
ClassMethod AdmTime(MrEpisodeID As %String) As %List
{
	s result = $lb("")
	q:(MrEpisodeID = "") result
	s AdmTime = $lg(^DHCEPRFS.INST.MREpisodeD(MrEpisodeID),16)
	q:(AdmTime = "") result
	s AdmTime = $zt(AdmTime)
	s result = $lb(AdmTime)
	q result
}

/// Desc: 出院日期
ClassMethod DisDate(MrEpisodeID As %String) As %List
{
	s result = $lb("")
	q:(MrEpisodeID = "") result
	s DisDate = $lg(^DHCEPRFS.INST.MREpisodeD(MrEpisodeID),17)
	q:(DisDate = "") result
	s DisDate = $zd(DisDate,3)
	s result = $lb(DisDate)
	q result
}

/// Desc:出院时间
ClassMethod DisTime(MrEpisodeID As %String) As %List
{
	s result = $lb("")
	q:(MrEpisodeID = "") result
	s DisTime = $lg(^DHCEPRFS.INST.MREpisodeD(MrEpisodeID),18)
	q:(DisTime = "") result
	s DisTime = $zt(DisTime)
	s result = $lb(DisTime)
	q result
}

/// Desc:死亡日期 --查询条件及结果
ClassMethod DeathDate(MrEpisodeID As %String) As %List
{
	s result = $lb("")
	q:(MrEpisodeID = "") result
	s DeathDate = $lg(^DHCEPRFS.INST.MREpisodeD(MrEpisodeID),19)
	q:(DeathDate = "") result
	s DeathDate = $zd(DeathDate)
	s result = $lb(DeathDate)
	q result
}

/// Desc:死亡时间 --查询条件及结果
ClassMethod DeathTime(MrEpisodeID As %String) As %List
{
	s result = $lb("")
	q:(MrEpisodeID = "") result
	s DeathTime = $lg(^DHCEPRFS.INST.MREpisodeD(MrEpisodeID),20)
	q:(DeathTime = "") result
	s DeathTime = $zt(DeathTime)
	s result = $lb(DeathTime)
	q result
}

/// Desc: 住院天数 --查询条件及结果
ClassMethod HospitalDays(MrEpisodeID As %String) As %List
{
	s result = $lb("")
	q:(MrEpisodeID = "") result
	s result = $lg(^DHCEPRFS.INST.MREpisodeD(MrEpisodeID),35)
	s result = $lb(result)
	q result
}

/// Desc:付费方式 --查询条件及结果
ClassMethod PayMode(MrEpisodeID As %String) As %List
{
	s result = $lb("")
	q:(MrEpisodeID = "") result
	s result = $lg($g(^DHCEPRFS.INST.MREpisodeD(MrEpisodeID)),36)
	s result = $lb(result)
	q result
}

/// Desc:病案质量
ClassMethod MedQuality(MrEpisodeID As %String) As %List
{
	s result = $lb("")
	q:(MrEpisodeID = "") result
	s result = $lg(^DHCEPRFS.INST.MREpisodeD(MrEpisodeID),38)
	s result = $lb(result)
	q result
}

/// Desc:住院费用
ClassMethod AllPay(MrEpisodeID As %String) As %List
{
	s result = $lb("")
	q:(MrEpisodeID = "") result
	s result = $lg(^DHCEPRFS.INST.MREpisodeD(MrEpisodeID),37)
	s result = $lb(result)
	q result
}

/// Desc:主治医师
ClassMethod AttendingDoc(MrEpisodeID As %String) As %List
{
	s result = $lb("")
	q:(MrEpisodeID = "") result
	s result = $lg(^DHCEPRFS.INST.MREpisodeD(MrEpisodeID),50)
	s result = $lb(result)
	q result
}

/// Desc:主管医师
ClassMethod MainDoctor(MrEpisodeID As %String) As %List
{
	s result = $lb("")
	q:(MrEpisodeID = "") result
	s result = $lg(^DHCEPRFS.INST.MREpisodeD(MrEpisodeID),25)
	s result = $lb(result)
	q result
}

/// Desc:住院医师
ClassMethod InHospitlDoc(MrEpisodeID As %String) As %List
{
	s result = $lb("")
	q:(MrEpisodeID = "") result
	s result = $lg(^DHCEPRFS.INST.MREpisodeD(MrEpisodeID),43)
	s result = $lb(result)
	q result
}

/// Desc:质控医师
ClassMethod QualityDoc(MrEpisodeID As %String) As %List
{
	s result = $lb("")
	q:(MrEpisodeID = "") result
	s result = $lg(^DHCEPRFS.INST.MREpisodeD(MrEpisodeID),47)
	s result = $lb(result)
	q result
}

/// Desc:主任(副)主任医师
ClassMethod SeniorDoc(MrEpisodeID As %String) As %List
{
	s result = $lb("")
	q:(MrEpisodeID = "") result
	s result = $lg(^DHCEPRFS.INST.MREpisodeD(MrEpisodeID),41)
	s result = $lb(result)
	q result
}

/// Desc: 科主任
ClassMethod LocManager(MrEpisodeID As %String) As %List
{
	s result = $lb("")
	q:(MrEpisodeID = "") result
	s result = $lg(^DHCEPRFS.INST.MREpisodeD(MrEpisodeID),45)
	s result = $lb(result)
	q result
}

/// Desc: 危重病人
ClassMethod IsCritiCal(MrEpisodeID As %String) As %List
{
	s result = $lb("")
	q:(MrEpisodeID = "") result
	s result = $lg(^DHCEPRFS.INST.MREpisodeD(MrEpisodeID),39)
	s result = $lb(result)
	q result
}

/// Desc: 医保细分类
ClassMethod InsuranceType(MrEpisodeID As %String) As %List
{
	s result = $lb("")
	q:(MrEpisodeID = "") result
	s result = $lg(^DHCEPRFS.INST.MREpisodeD(MrEpisodeID),53)
	s result = $lb(result)
	q result
}

/// Desc: 医保细分类代码
ClassMethod InsuranceTypeCode(MrEpisodeID As %String) As %List
{
	s result = $lb("")
	q:(MrEpisodeID = "") result
	s result = $lg(^DHCEPRFS.INST.MREpisodeD(MrEpisodeID),54)
	s result = $lb(result)
	q result
}

/// Desc: 付费方式代码
ClassMethod PayModeCode(MrEpisodeID As %String) As %List
{
	s result = $lb("")
	q:(MrEpisodeID = "") result
	s result = $lg(^DHCEPRFS.INST.MREpisodeD(MrEpisodeID),55)
	s result = $lb(result)
	q result
}

// 诊断数据

/// Desc: 主要诊断 --查询条件及结果
ClassMethod DiagMainDesc(MrEpisodeID As %String) As %List
{
	s result = $lb("")
	q:(MrEpisodeID = "") result
	s MREpisodeFPID = $o(^DHCEPRFS.INST.MREpisodeFPI("IdxMrEpisodeID"," "_MrEpisodeID,""))
	q:(MREpisodeFPID = "") result
	s result = $lg(^DHCEPRFS.INST.MREpisodeFPD(MREpisodeFPID),11)
	s result = $lb(result)
	q result
}

/// Desc: 主要诊断 --查询条件及结果
ClassMethod DiagMainDescCode(MrEpisodeID As %String) As %List
{
	s result = $lb("")
	q:(MrEpisodeID = "") result
	s MREpisodeFPID = $o(^DHCEPRFS.INST.MREpisodeFPI("IdxMrEpisodeID"," "_MrEpisodeID,""))
	q:(MREpisodeFPID = "") result
	s result = $lg(^DHCEPRFS.INST.MREpisodeFPD(MREpisodeFPID),10)
	s result = $lb(result)
	q result
}

/// Desc:门急诊诊断
ClassMethod DiagOutDesc(MrEpisodeID As %String) As %List
{
	s result = $lb("")
	q:(MrEpisodeID = "") result
	s MREpisodeFPID = $o(^DHCEPRFS.INST.MREpisodeFPI("IdxMrEpisodeID"," "_MrEpisodeID,""))
	q:(MREpisodeFPID = "") result
	s result = $lg(^DHCEPRFS.INST.MREpisodeFPD(MREpisodeFPID),175)
	s result = $lb(result)
	q result
}

/// Desc:门急诊诊断
ClassMethod DiagOutDescCode(MrEpisodeID As %String) As %List
{
	s result = $lb("")
	q:(MrEpisodeID = "") result
	s MREpisodeFPID = $o(^DHCEPRFS.INST.MREpisodeFPI("IdxMrEpisodeID"," "_MrEpisodeID,""))
	q:(MREpisodeFPID = "") result
	s result = $lg(^DHCEPRFS.INST.MREpisodeFPD(MREpisodeFPID),174)
	s result = $lb(result)
	q result
}

/// Desc:其它诊断
ClassMethod DiagDesc(MrEpisodeID As %String) As %List
{
	s result = $lb("")
	q:(MrEpisodeID = "") result
	s MREpisodeFPID = $o(^DHCEPRFS.INST.MREpisodeFPI("IdxMrEpisodeID"," "_MrEpisodeID,""))
	q:(MREpisodeFPID = "") result
	s result = $lb($lg(^DHCEPRFS.INST.MREpisodeFPD(MREpisodeFPID),15))
	s result = result_$lb($lg(^DHCEPRFS.INST.MREpisodeFPD(MREpisodeFPID),19))
	s result = result_$lb($lg(^DHCEPRFS.INST.MREpisodeFPD(MREpisodeFPID),23))
	s result = result_$lb($lg(^DHCEPRFS.INST.MREpisodeFPD(MREpisodeFPID),27))
	s result = result_$lb($lg(^DHCEPRFS.INST.MREpisodeFPD(MREpisodeFPID),31))
	s result = result_$lb($lg(^DHCEPRFS.INST.MREpisodeFPD(MREpisodeFPID),34))
	s result = result_$lb($lg(^DHCEPRFS.INST.MREpisodeFPD(MREpisodeFPID),39))
	s result = result_$lb($lg(^DHCEPRFS.INST.MREpisodeFPD(MREpisodeFPID),43))
	s result = result_$lb($lg(^DHCEPRFS.INST.MREpisodeFPD(MREpisodeFPID),47))
	s result = result_$lb($lg(^DHCEPRFS.INST.MREpisodeFPD(MREpisodeFPID),50))
    q result
}

/// Desc:其它诊断Code
ClassMethod DiagDescCode(MrEpisodeID As %String) As %List
{
	s result = $lb("")
	q:(MrEpisodeID = "") result
	s MREpisodeFPID = $o(^DHCEPRFS.INST.MREpisodeFPI("IdxMrEpisodeID"," "_MrEpisodeID,""))
	q:(MREpisodeFPID = "") result
	s result = $lb($lg(^DHCEPRFS.INST.MREpisodeFPD(MREpisodeFPID),14))
	s result = result_$lb($lg(^DHCEPRFS.INST.MREpisodeFPD(MREpisodeFPID),18))
	s result = result_$lb($lg(^DHCEPRFS.INST.MREpisodeFPD(MREpisodeFPID),22))
	s result = result_$lb($lg(^DHCEPRFS.INST.MREpisodeFPD(MREpisodeFPID),26))
	s result = result_$lb($lg(^DHCEPRFS.INST.MREpisodeFPD(MREpisodeFPID),30))
	s result = result_$lb($lg(^DHCEPRFS.INST.MREpisodeFPD(MREpisodeFPID),33))
	s result = result_$lb($lg(^DHCEPRFS.INST.MREpisodeFPD(MREpisodeFPID),38))
	s result = result_$lb($lg(^DHCEPRFS.INST.MREpisodeFPD(MREpisodeFPID),42))
	s result = result_$lb($lg(^DHCEPRFS.INST.MREpisodeFPD(MREpisodeFPID),46))
	s result = result_$lb($lg(^DHCEPRFS.INST.MREpisodeFPD(MREpisodeFPID),49))
    q result
}

/// Desc: 其它诊断01编码 --查询条件及结果
ClassMethod Diag01Code(MrEpisodeID As %String) As %List
{
	s result = $lb("")
	q:(MrEpisodeID = "") result
	s MREpisodeFPID = $o(^DHCEPRFS.INST.MREpisodeFPI("IdxMrEpisodeID"," "_MrEpisodeID,""))
	q:(MREpisodeFPID = "") result
	s result = $lg(^DHCEPRFS.INST.MREpisodeFPD(MREpisodeFPID),14)
	s result = $lb(result)
	q result
}

/// Desc: 其它诊断01描述 --查询条件及结果
ClassMethod Diag01Desc(MrEpisodeID As %String) As %List
{
	s result = $lb("")
	q:(MrEpisodeID = "") result
	s MREpisodeFPID = $o(^DHCEPRFS.INST.MREpisodeFPI("IdxMrEpisodeID"," "_MrEpisodeID,""))
	q:(MREpisodeFPID = "") result
	s result = $lg(^DHCEPRFS.INST.MREpisodeFPD(MREpisodeFPID),15)
	s result = $lb(result)
	q result
}

/// Desc: 其它诊断02编码 --查询条件及结果
ClassMethod Diag02Code(MrEpisodeID As %String) As %List
{
	s result = $lb("")
	q:(MrEpisodeID = "") result
	s MREpisodeFPID = $o(^DHCEPRFS.INST.MREpisodeFPI("IdxMrEpisodeID"," "_MrEpisodeID,""))
	q:(MREpisodeFPID = "") result
	s result = $lg(^DHCEPRFS.INST.MREpisodeFPD(MREpisodeFPID),18)
	s result = $lb(result)
	q result
}

/// Desc: 其它诊断02描述 --查询条件及结果
ClassMethod Diag02Desc(MrEpisodeID As %String) As %List
{
	s result = $lb("")
	q:(MrEpisodeID = "") result
	s MREpisodeFPID = $o(^DHCEPRFS.INST.MREpisodeFPI("IdxMrEpisodeID"," "_MrEpisodeID,""))
	q:(MREpisodeFPID = "") result
	s result = $lg(^DHCEPRFS.INST.MREpisodeFPD(MREpisodeFPID),19)
	s result = $lb(result)
	q result
}

/// Desc: 其它诊断03编码 --查询条件及结果
ClassMethod Diag03Code(MrEpisodeID As %String) As %List
{
	s result = $lb("")
	q:(MrEpisodeID = "") result
	s MREpisodeFPID = $o(^DHCEPRFS.INST.MREpisodeFPI("IdxMrEpisodeID"," "_MrEpisodeID,""))
	q:(MREpisodeFPID = "") result
	s result = $lg(^DHCEPRFS.INST.MREpisodeFPD(MREpisodeFPID),22)
	s result = $lb(result)
	q result
}

/// Desc: 其它诊断03描述 --查询条件及结果
ClassMethod Diag03Desc(MrEpisodeID As %String) As %List
{
	s result = $lb("")
	q:(MrEpisodeID = "") result
	s MREpisodeFPID = $o(^DHCEPRFS.INST.MREpisodeFPI("IdxMrEpisodeID"," "_MrEpisodeID,""))
	q:(MREpisodeFPID = "") result
	s result = $lg(^DHCEPRFS.INST.MREpisodeFPD(MREpisodeFPID),23)
	s result = $lb(result)
	q result
}

/// Desc: 其它诊断04编码 --查询条件及结果
ClassMethod Diag04Code(MrEpisodeID As %String) As %List
{
	s result = $lb("")
	q:(MrEpisodeID = "") result
	s MREpisodeFPID = $o(^DHCEPRFS.INST.MREpisodeFPI("IdxMrEpisodeID"," "_MrEpisodeID,""))
	q:(MREpisodeFPID = "") result
	s result = $lg(^DHCEPRFS.INST.MREpisodeFPD(MREpisodeFPID),26)
	s result = $lb(result)
	q result
}

/// Desc: 其它诊断04描述 --查询条件及结果
ClassMethod Diag04Desc(MrEpisodeID As %String) As %List
{
	s result = $lb("")
	q:(MrEpisodeID = "") result
	s MREpisodeFPID = $o(^DHCEPRFS.INST.MREpisodeFPI("IdxMrEpisodeID"," "_MrEpisodeID,""))
	q:(MREpisodeFPID = "") result
	s result = $lg(^DHCEPRFS.INST.MREpisodeFPD(MREpisodeFPID),27)
	s result = $lb(result)
	q result
}

/// Desc: 其它诊断05编码 --查询条件及结果
ClassMethod Diag05Code(MrEpisodeID As %String) As %List
{
	s result = $lb("")
	q:(MrEpisodeID = "") result
	s MREpisodeFPID = $o(^DHCEPRFS.INST.MREpisodeFPI("IdxMrEpisodeID"," "_MrEpisodeID,""))
	q:(MREpisodeFPID = "") result
	s result = $lg(^DHCEPRFS.INST.MREpisodeFPD(MREpisodeFPID),30)
	s result = $lb(result)
	q result
}

/// Desc: 其它诊断05描述 --查询条件及结果
ClassMethod Diag05Desc(MrEpisodeID As %String) As %List
{
	s result = $lb("")
	q:(MrEpisodeID = "") result
	s MREpisodeFPID = $o(^DHCEPRFS.INST.MREpisodeFPI("IdxMrEpisodeID"," "_MrEpisodeID,""))
	q:(MREpisodeFPID = "") result
	s result = $lg(^DHCEPRFS.INST.MREpisodeFPD(MREpisodeFPID),31)
	s result = $lb(result)
	q result
}

/// Desc: 其它诊断06编码 --查询条件及结果
ClassMethod Diag06Code(MrEpisodeID As %String) As %List
{
	s result = $lb("")
	q:(MrEpisodeID = "") result
	s MREpisodeFPID = $o(^DHCEPRFS.INST.MREpisodeFPI("IdxMrEpisodeID"," "_MrEpisodeID,""))
	q:(MREpisodeFPID = "") result
	s result = $lg(^DHCEPRFS.INST.MREpisodeFPD(MREpisodeFPID),34)
	s result = $lb(result)
	q result
}

/// Desc: 其它诊断06描述 --查询条件及结果
ClassMethod Diag06Desc(MrEpisodeID As %String) As %List
{
	s result = $lb("")
	q:(MrEpisodeID = "") result
	s MREpisodeFPID = $o(^DHCEPRFS.INST.MREpisodeFPI("IdxMrEpisodeID"," "_MrEpisodeID,""))
	q:(MREpisodeFPID = "") result
	s result = $lg(^DHCEPRFS.INST.MREpisodeFPD(MREpisodeFPID),35)
	s result = $lb(result)
	q result
}

/// Desc: 其它诊断07编码 --查询条件及结果
ClassMethod Diag07Code(MrEpisodeID As %String) As %List
{
	s result = $lb("")
	q:(MrEpisodeID = "") result
	s MREpisodeFPID = $o(^DHCEPRFS.INST.MREpisodeFPI("IdxMrEpisodeID"," "_MrEpisodeID,""))
	q:(MREpisodeFPID = "") result
	s result = $lg(^DHCEPRFS.INST.MREpisodeFPD(MREpisodeFPID),38)
	s result = $lb(result)
	q result
}

/// Desc: 其它诊断07描述 --查询条件及结果
ClassMethod Diag07Desc(MrEpisodeID As %String) As %List
{
	s result = $lb("")
	q:(MrEpisodeID = "") result
	s MREpisodeFPID = $o(^DHCEPRFS.INST.MREpisodeFPI("IdxMrEpisodeID"," "_MrEpisodeID,""))
	q:(MREpisodeFPID = "") result
	s result = $lg(^DHCEPRFS.INST.MREpisodeFPD(MREpisodeFPID),39)
	s result = $lb(result)
	q result
}

/// Desc: 其它诊断08编码 --查询条件及结果
ClassMethod Diag08Code(MrEpisodeID As %String) As %List
{
	s result = $lb("")
	q:(MrEpisodeID = "") result
	s MREpisodeFPID = $o(^DHCEPRFS.INST.MREpisodeFPI("IdxMrEpisodeID"," "_MrEpisodeID,""))
	q:(MREpisodeFPID = "") result
	s result = $lg(^DHCEPRFS.INST.MREpisodeFPD(MREpisodeFPID),42)
	s result = $lb(result)
	q result
}

/// Desc: 其它诊断08描述 --查询条件及结果
ClassMethod Diag08Desc(MrEpisodeID As %String) As %List
{
	s result = $lb("")
	q:(MrEpisodeID = "") result
	s MREpisodeFPID = $o(^DHCEPRFS.INST.MREpisodeFPI("IdxMrEpisodeID"," "_MrEpisodeID,""))
	q:(MREpisodeFPID = "") result
	s result = $lg(^DHCEPRFS.INST.MREpisodeFPD(MREpisodeFPID),43)
	s result = $lb(result)
	q result
}

/// Desc: 其它诊断09编码 --查询条件及结果
ClassMethod Diag09Code(MrEpisodeID As %String) As %List
{
	s result = $lb("")
	q:(MrEpisodeID = "") result
	s MREpisodeFPID = $o(^DHCEPRFS.INST.MREpisodeFPI("IdxMrEpisodeID"," "_MrEpisodeID,""))
	q:(MREpisodeFPID = "") result
	s result = $lg(^DHCEPRFS.INST.MREpisodeFPD(MREpisodeFPID),46)
	s result = $lb(result)
	q result
}

/// Desc: 其它诊断09描述 --查询条件及结果
ClassMethod Diag09Desc(MrEpisodeID As %String) As %List
{
	s result = $lb("")
	q:(MrEpisodeID = "") result
	s MREpisodeFPID = $o(^DHCEPRFS.INST.MREpisodeFPI("IdxMrEpisodeID"," "_MrEpisodeID,""))
	q:(MREpisodeFPID = "") result
	s result = $lg(^DHCEPRFS.INST.MREpisodeFPD(MREpisodeFPID),47)
	s result = $lb(result)
	q result
}

/// Desc: 其它诊断10编码 --查询条件及结果
ClassMethod Diag10Code(MrEpisodeID As %String) As %List
{
	s result = $lb("")
	q:(MrEpisodeID = "") result
	s MREpisodeFPID = $o(^DHCEPRFS.INST.MREpisodeFPI("IdxMrEpisodeID"," "_MrEpisodeID,""))
	q:(MREpisodeFPID = "") result
	s result = $lg(^DHCEPRFS.INST.MREpisodeFPD(MREpisodeFPID),50)
	s result = $lb(result)
	q result
}

/// Desc: 其它诊断10描述 --查询条件及结果
ClassMethod Diag10Desc(MrEpisodeID As %String) As %List
{
	s result = $lb("")
	q:(MrEpisodeID = "") result
	s MREpisodeFPID = $o(^DHCEPRFS.INST.MREpisodeFPI("IdxMrEpisodeID"," "_MrEpisodeID,""))
	q:(MREpisodeFPID = "") result
	s result = $lg(^DHCEPRFS.INST.MREpisodeFPD(MREpisodeFPID),51)
	s result = $lb(result)
	q result
}

/// Desc:病理诊断
ClassMethod DiagPathDesc(MrEpisodeID As %String) As %List
{
	s result = $lb("")
	q:(MrEpisodeID = "") result
	s MREpisodeFPID = $o(^DHCEPRFS.INST.MREpisodeFPI("IdxMrEpisodeID"," "_MrEpisodeID,""))
	q:(MREpisodeFPID = "") result
	s result = $lg(^DHCEPRFS.INST.MREpisodeFPD(MREpisodeFPID),180)
	s result = $lb(result)
	q result
}

/// Desc:病理诊断
ClassMethod DiagPathDescCode(MrEpisodeID As %String) As %List
{
	s result = $lb("")
	q:(MrEpisodeID = "") result
	s MREpisodeFPID = $o(^DHCEPRFS.INST.MREpisodeFPI("IdxMrEpisodeID"," "_MrEpisodeID,""))
	q:(MREpisodeFPID = "") result
	s result = $lg(^DHCEPRFS.INST.MREpisodeFPD(MREpisodeFPID),181)
	s result = $lb(result)
	q result
}

// 手术数据

/// Desc:手术名称 -查询条件
ClassMethod OperDesc(MrEpisodeID As %String) As %List
{
	s result = $lb("")
	q:(MrEpisodeID = "") result
	s MREpisodeFPID = $o(^DHCEPRFS.INST.MREpisodeFPI("IdxMrEpisodeID"," "_MrEpisodeID,""))
	q:(MREpisodeFPID = "") result
	s result = $lb($lg(^DHCEPRFS.INST.MREpisodeFPD(MREpisodeFPID),55))
	s result = result_$lb($lg(^DHCEPRFS.INST.MREpisodeFPD(MREpisodeFPID),70))
	s result = result_$lb($lg(^DHCEPRFS.INST.MREpisodeFPD(MREpisodeFPID),85))
	s result = result_$lb($lg(^DHCEPRFS.INST.MREpisodeFPD(MREpisodeFPID),100))
	s result = result_$lb($lg(^DHCEPRFS.INST.MREpisodeFPD(MREpisodeFPID),115))
	s result = result_$lb($lg(^DHCEPRFS.INST.MREpisodeFPD(MREpisodeFPID),130))
	s result = result_$lb($lg(^DHCEPRFS.INST.MREpisodeFPD(MREpisodeFPID),145))
	s result = result_$lb($lg(^DHCEPRFS.INST.MREpisodeFPD(MREpisodeFPID),160))
	q result
}

/// Desc:手术名称 -查询条件
ClassMethod OperDescCode(MrEpisodeID As %String) As %List
{
	s result = $lb("")
	q:(MrEpisodeID = "") result
	s MREpisodeFPID = $o(^DHCEPRFS.INST.MREpisodeFPI("IdxMrEpisodeID"," "_MrEpisodeID,""))
	q:(MREpisodeFPID = "") result
	s result = $lb($lg(^DHCEPRFS.INST.MREpisodeFPD(MREpisodeFPID),54))
	s result = result_$lb($lg(^DHCEPRFS.INST.MREpisodeFPD(MREpisodeFPID),69))
	s result = result_$lb($lg(^DHCEPRFS.INST.MREpisodeFPD(MREpisodeFPID),84))
	s result = result_$lb($lg(^DHCEPRFS.INST.MREpisodeFPD(MREpisodeFPID),99))
	s result = result_$lb($lg(^DHCEPRFS.INST.MREpisodeFPD(MREpisodeFPID),114))
	s result = result_$lb($lg(^DHCEPRFS.INST.MREpisodeFPD(MREpisodeFPID),129))
	s result = result_$lb($lg(^DHCEPRFS.INST.MREpisodeFPD(MREpisodeFPID),144))
	s result = result_$lb($lg(^DHCEPRFS.INST.MREpisodeFPD(MREpisodeFPID),159))
	q result
}

/// Desc: 手术名称1
/// debug: ##Class(DHCEPRFS.BL.BLQueryClassMethod).Oper01Desc(1)
ClassMethod Oper01Desc(MrEpisodeID As %String) As %List
{
	s result = $lb("")
	q:(MrEpisodeID = "") result
	s MREpisodeFPID = $o(^DHCEPRFS.INST.MREpisodeFPI("IdxMrEpisodeID"," "_MrEpisodeID,""))
	q:(MREpisodeFPID = "") result
	s result = $lg(^DHCEPRFS.INST.MREpisodeFPD(MREpisodeFPID),55)
	s result = $lb(result)
	q result
}

/// Desc: 手术名称2
/// debug: ##Class(DHCEPRFS.BL.BLQueryClassMethod).Oper02Desc(1)
ClassMethod Oper02Desc(MrEpisodeID As %String) As %List
{
	s result = $lb("")
	q:(MrEpisodeID = "") result
	s MREpisodeFPID = $o(^DHCEPRFS.INST.MREpisodeFPI("IdxMrEpisodeID"," "_MrEpisodeID,""))
	q:(MREpisodeFPID = "") result
	s result = $lg(^DHCEPRFS.INST.MREpisodeFPD(MREpisodeFPID),70)
	s result = $lb(result)
	q result
}

/// Desc: 手术名称3
/// debug: ##Class(DHCEPRFS.BL.BLQueryClassMethod).Oper03Desc(1)
ClassMethod Oper03Desc(MrEpisodeID As %String) As %List
{
	s result = $lb("")
	q:(MrEpisodeID = "") result
	s MREpisodeFPID = $o(^DHCEPRFS.INST.MREpisodeFPI("IdxMrEpisodeID"," "_MrEpisodeID,""))
	q:(MREpisodeFPID = "") result
	s result = $lg(^DHCEPRFS.INST.MREpisodeFPD(MREpisodeFPID),85)
	s result = $lb(result)
	q result
}

/// Desc: 手术名称4
/// debug: ##Class(DHCEPRFS.BL.BLQueryClassMethod).Oper04Desc(1)
ClassMethod Oper04Desc(MrEpisodeID As %String) As %List
{
	s result = $lb("")
	q:(MrEpisodeID = "") result
	s MREpisodeFPID = $o(^DHCEPRFS.INST.MREpisodeFPI("IdxMrEpisodeID"," "_MrEpisodeID,""))
	q:(MREpisodeFPID = "") result
	s result = $lg(^DHCEPRFS.INST.MREpisodeFPD(MREpisodeFPID),100)
	s result = $lb(result)
	q result
}

/// Desc: 手术名称5
/// debug: ##Class(DHCEPRFS.BL.BLQueryClassMethod).Oper05Desc(1)
ClassMethod Oper05Desc(MrEpisodeID As %String) As %List
{
	s result = $lb("")
	q:(MrEpisodeID = "") result
	s MREpisodeFPID = $o(^DHCEPRFS.INST.MREpisodeFPI("IdxMrEpisodeID"," "_MrEpisodeID,""))
	q:(MREpisodeFPID = "") result
	s result = $lg(^DHCEPRFS.INST.MREpisodeFPD(MREpisodeFPID),115)
	s result = $lb(result)
	q result
}

/// Desc: 手术名称6
/// debug: ##Class(DHCEPRFS.BL.BLQueryClassMethod).Oper06Desc(1)
ClassMethod Oper06Desc(MrEpisodeID As %String) As %List
{
	s result = $lb("")
	q:(MrEpisodeID = "") result
	s MREpisodeFPID = $o(^DHCEPRFS.INST.MREpisodeFPI("IdxMrEpisodeID"," "_MrEpisodeID,""))
	q:(MREpisodeFPID = "") result
	s result = $lg(^DHCEPRFS.INST.MREpisodeFPD(MREpisodeFPID),130)
	s result = $lb(result)
	q result
}

/// Desc: 手术名称7
/// debug: ##Class(DHCEPRFS.BL.BLQueryClassMethod).Oper07Desc(1)
ClassMethod Oper07Desc(MrEpisodeID As %String) As %List
{
	s result = $lb("")
	q:(MrEpisodeID = "") result
	s MREpisodeFPID = $o(^DHCEPRFS.INST.MREpisodeFPI("IdxMrEpisodeID"," "_MrEpisodeID,""))
	q:(MREpisodeFPID = "") result
	s result = $lg(^DHCEPRFS.INST.MREpisodeFPD(MREpisodeFPID),145)
	s result = $lb(result)
	q result
}

/// Desc: 手术名称8
/// debug: ##Class(DHCEPRFS.BL.BLQueryClassMethod).Oper08Desc(1)
ClassMethod Oper08Desc(MrEpisodeID As %String) As %List
{
	s result = $lb("")
	q:(MrEpisodeID = "") result
	s MREpisodeFPID = $o(^DHCEPRFS.INST.MREpisodeFPI("IdxMrEpisodeID"," "_MrEpisodeID,""))
	q:(MREpisodeFPID = "") result
	s result = $lg(^DHCEPRFS.INST.MREpisodeFPD(MREpisodeFPID),160)
	s result = $lb(result)
	q result
}

/// Desc: 手术代码1
/// debug: ##Class(DHCEPRFS.BL.BLQueryClassMethod).Oper01Code(1)
ClassMethod Oper01Code(MrEpisodeID As %String) As %List
{
	s result = $lb("")
	q:(MrEpisodeID = "") result
	s MREpisodeFPID = $o(^DHCEPRFS.INST.MREpisodeFPI("IdxMrEpisodeID"," "_MrEpisodeID,""))
	q:(MREpisodeFPID = "") result
	s result = $lg(^DHCEPRFS.INST.MREpisodeFPD(MREpisodeFPID),54)
	s result = $lb(result)
	q result
}

/// Desc: 手术代码2
/// debug: ##Class(DHCEPRFS.BL.BLQueryClassMethod).Oper02Code(1)
ClassMethod Oper02Code(MrEpisodeID As %String) As %List
{
	s result = $lb("")
	q:(MrEpisodeID = "") result
	s MREpisodeFPID = $o(^DHCEPRFS.INST.MREpisodeFPI("IdxMrEpisodeID"," "_MrEpisodeID,""))
	q:(MREpisodeFPID = "") result
	s result = $lg(^DHCEPRFS.INST.MREpisodeFPD(MREpisodeFPID),69)
	s result = $lb(result)
	q result
}

/// Desc: 手术代码3
/// debug: ##Class(DHCEPRFS.BL.BLQueryClassMethod).Oper03Code(1)
ClassMethod Oper03Code(MrEpisodeID As %String) As %List
{
	s result = $lb("")
	q:(MrEpisodeID = "") result
	s MREpisodeFPID = $o(^DHCEPRFS.INST.MREpisodeFPI("IdxMrEpisodeID"," "_MrEpisodeID,""))
	q:(MREpisodeFPID = "") result
	s result = $lg(^DHCEPRFS.INST.MREpisodeFPD(MREpisodeFPID),84)
	s result = $lb(result)
	q result
}

/// Desc: 手术代码4
/// debug: ##Class(DHCEPRFS.BL.BLQueryClassMethod).Oper04Code(1)
ClassMethod Oper04Code(MrEpisodeID As %String) As %List
{
	s result = $lb("")
	q:(MrEpisodeID = "") result
	s MREpisodeFPID = $o(^DHCEPRFS.INST.MREpisodeFPI("IdxMrEpisodeID"," "_MrEpisodeID,""))
	q:(MREpisodeFPID = "") result
	s result = $lg(^DHCEPRFS.INST.MREpisodeFPD(MREpisodeFPID),99)
	s result = $lb(result)
	q result
}

/// Desc: 手术代码5
/// debug: ##Class(DHCEPRFS.BL.BLQueryClassMethod).Oper05Code(1)
ClassMethod Oper05Code(MrEpisodeID As %String) As %List
{
	s result = $lb("")
	q:(MrEpisodeID = "") result
	s MREpisodeFPID = $o(^DHCEPRFS.INST.MREpisodeFPI("IdxMrEpisodeID"," "_MrEpisodeID,""))
	q:(MREpisodeFPID = "") result
	s result = $lg(^DHCEPRFS.INST.MREpisodeFPD(MREpisodeFPID),114)
	s result = $lb(result)
	q result
}

/// Desc: 手术代码6
/// debug: ##Class(DHCEPRFS.BL.BLQueryClassMethod).Oper06Code(1)
ClassMethod Oper06Code(MrEpisodeID As %String) As %List
{
	s result = $lb("")
	q:(MrEpisodeID = "") result
	s MREpisodeFPID = $o(^DHCEPRFS.INST.MREpisodeFPI("IdxMrEpisodeID"," "_MrEpisodeID,""))
	q:(MREpisodeFPID = "") result
	s result = $lg(^DHCEPRFS.INST.MREpisodeFPD(MREpisodeFPID),129)
	s result = $lb(result)
	q result
}

/// Desc: 手术代码7
/// debug: ##Class(DHCEPRFS.BL.BLQueryClassMethod).Oper07Code(1)
ClassMethod Oper07Code(MrEpisodeID As %String) As %List
{
	s result = $lb("")
	q:(MrEpisodeID = "") result
	s MREpisodeFPID = $o(^DHCEPRFS.INST.MREpisodeFPI("IdxMrEpisodeID"," "_MrEpisodeID,""))
	q:(MREpisodeFPID = "") result
	s result = $lg(^DHCEPRFS.INST.MREpisodeFPD(MREpisodeFPID),144)
	s result = $lb(result)
	q result
}

/// Desc: 手术代码8
/// debug: ##Class(DHCEPRFS.BL.BLQueryClassMethod).Oper08Code(1)
ClassMethod Oper08Code(MrEpisodeID As %String) As %List
{
	s result = $lb("")
	q:(MrEpisodeID = "") result
	s MREpisodeFPID = $o(^DHCEPRFS.INST.MREpisodeFPI("IdxMrEpisodeID"," "_MrEpisodeID,""))
	q:(MREpisodeFPID = "") result
	s result = $lg(^DHCEPRFS.INST.MREpisodeFPD(MREpisodeFPID),159)
	s result = $lb(result)
	q result
}

/// Desc: 手术日期 -查询条件
/// debug:w ##Class(DHCEPRFS.BL.BLQueryClassMethod).OperDate(1)
ClassMethod OperDate(MrEpisodeID As %String) As %List
{
	s result = $lb("")
	q:(MrEpisodeID = "") result
	s MREpisodeFPID = $o(^DHCEPRFS.INST.MREpisodeFPI("IdxMrEpisodeID"," "_MrEpisodeID,""))
	q:(MREpisodeFPID = "") result
	s result = $lb($lg(^DHCEPRFS.INST.MREpisodeFPD(MREpisodeFPID),57)) //手术日期1
	s result = result_$lb($lg(^DHCEPRFS.INST.MREpisodeFPD(MREpisodeFPID),72)) //手术日期2
	s result = result_$lb($lg(^DHCEPRFS.INST.MREpisodeFPD(MREpisodeFPID),87)) //手术日期3
	s result = result_$lb($lg(^DHCEPRFS.INST.MREpisodeFPD(MREpisodeFPID),102)) //手术日期4
    s result = result_$lb($lg(^DHCEPRFS.INST.MREpisodeFPD(MREpisodeFPID),117)) //手术日期5
    s result = result_$lb($lg(^DHCEPRFS.INST.MREpisodeFPD(MREpisodeFPID),132)) //手术日期6
    s result = result_$lb($lg(^DHCEPRFS.INST.MREpisodeFPD(MREpisodeFPID),147)) //手术日期7
    s result = result_$lb($lg(^DHCEPRFS.INST.MREpisodeFPD(MREpisodeFPID),162)) //手术日期8
    q result
}

/// Desc: 手术01日期
/// debug: ##Class(DHCEPRFS.BL.BLQueryClassMethod).Oper01Date(1)
ClassMethod Oper01Date(MrEpisodeID As %String) As %List
{
	s result = $lb("")
	q:(MrEpisodeID = "") result
	s MREpisodeFPID = $o(^DHCEPRFS.INST.MREpisodeFPI("IdxMrEpisodeID"," "_MrEpisodeID,""))
	q:(MREpisodeFPID = "") result
	s result = $lg(^DHCEPRFS.INST.MREpisodeFPD(MREpisodeFPID),57)
	s result = $lb(result)
	q result
}

/// Desc: 手术02日期
/// debug: ##Class(DHCEPRFS.BL.BLQueryClassMethod).Oper02Date(1)
ClassMethod Oper02Date(MrEpisodeID As %String) As %List
{
	s result = $lb("")
	q:(MrEpisodeID = "") result
	s MREpisodeFPID = $o(^DHCEPRFS.INST.MREpisodeFPI("IdxMrEpisodeID"," "_MrEpisodeID,""))
	q:(MREpisodeFPID = "") result
	s result = $lg(^DHCEPRFS.INST.MREpisodeFPD(MREpisodeFPID),72)
	s result = $lb(result)
	q result
}

/// Desc: 手术03日期
/// debug: ##Class(DHCEPRFS.BL.BLQueryClassMethod).Oper03Date(1)
ClassMethod Oper03Date(MrEpisodeID As %String) As %List
{
	s result = $lb("")
	q:(MrEpisodeID = "") result
	s MREpisodeFPID = $o(^DHCEPRFS.INST.MREpisodeFPI("IdxMrEpisodeID"," "_MrEpisodeID,""))
	q:(MREpisodeFPID = "") result
	s result = $lg(^DHCEPRFS.INST.MREpisodeFPD(MREpisodeFPID),87)
	s result = $lb(result)
	q result
}

/// Desc: 手术04日期
/// debug: ##Class(DHCEPRFS.BL.BLQueryClassMethod).Oper04Date(1)
ClassMethod Oper04Date(MrEpisodeID As %String) As %List
{
	s result = $lb("")
	q:(MrEpisodeID = "") result
	s MREpisodeFPID = $o(^DHCEPRFS.INST.MREpisodeFPI("IdxMrEpisodeID"," "_MrEpisodeID,""))
	q:(MREpisodeFPID = "") result
	s result = $lg(^DHCEPRFS.INST.MREpisodeFPD(MREpisodeFPID),102)
	s result = $lb(result)
	q result
}

/// Desc: 手术05日期
/// debug: ##Class(DHCEPRFS.BL.BLQueryClassMethod).Oper05Date(1)
ClassMethod Oper05Date(MrEpisodeID As %String) As %List
{
	s result = $lb("")
	q:(MrEpisodeID = "") result
	s MREpisodeFPID = $o(^DHCEPRFS.INST.MREpisodeFPI("IdxMrEpisodeID"," "_MrEpisodeID,""))
	q:(MREpisodeFPID = "") result
	s result = $lg(^DHCEPRFS.INST.MREpisodeFPD(MREpisodeFPID),117)
	s result = $lb(result)
	q result
}

/// Desc: 手术06日期
/// debug: ##Class(DHCEPRFS.BL.BLQueryClassMethod).Oper06Date(1)
ClassMethod Oper06Date(MrEpisodeID As %String) As %List
{
	s result = $lb("")
	q:(MrEpisodeID = "") result
	s MREpisodeFPID = $o(^DHCEPRFS.INST.MREpisodeFPI("IdxMrEpisodeID"," "_MrEpisodeID,""))
	q:(MREpisodeFPID = "") result
	s result = $lg(^DHCEPRFS.INST.MREpisodeFPD(MREpisodeFPID),132)
	s result = $lb(result)
	q result
}

/// Desc: 手术07日期
/// debug: ##Class(DHCEPRFS.BL.BLQueryClassMethod).Oper07Date(1)
ClassMethod Oper07Date(MrEpisodeID As %String) As %List
{
	s result = $lb("")
	q:(MrEpisodeID = "") result
	s MREpisodeFPID = $o(^DHCEPRFS.INST.MREpisodeFPI("IdxMrEpisodeID"," "_MrEpisodeID,""))
	q:(MREpisodeFPID = "") result
	s result = $lg(^DHCEPRFS.INST.MREpisodeFPD(MREpisodeFPID),147)
	s result = $lb(result)
	q result
}

/// Desc: 手术08日期
/// debug: ##Class(DHCEPRFS.BL.BLQueryClassMethod).Oper08Date(1)
ClassMethod Oper08Date(MrEpisodeID As %String) As %List
{
	s result = $lb("")
	q:(MrEpisodeID = "") result
	s MREpisodeFPID = $o(^DHCEPRFS.INST.MREpisodeFPI("IdxMrEpisodeID"," "_MrEpisodeID,""))
	q:(MREpisodeFPID = "") result
	s result = $lg(^DHCEPRFS.INST.MREpisodeFPD(MREpisodeFPID),162)
	s result = $lb(result)
	q result
}

/// Desc:手术等级 -查询条件
ClassMethod OperLevel(MrEpisodeID As %String) As %List
{
	s result = $lb("")
	q:(MrEpisodeID = "") result
	s MREpisodeFPID = $o(^DHCEPRFS.INST.MREpisodeFPI("IdxMrEpisodeID"," "_MrEpisodeID,""))
	q:(MREpisodeFPID = "") result
	s result = $lb($lg(^DHCEPRFS.INST.MREpisodeFPD(MREpisodeFPID),56)) //手术等级1
	s result = result_$lb($lg(^DHCEPRFS.INST.MREpisodeFPD(MREpisodeFPID),71)) //手术等级2
	s result = result_$lb($lg(^DHCEPRFS.INST.MREpisodeFPD(MREpisodeFPID),86)) //手术等级3
	s result = result_$lb($lg(^DHCEPRFS.INST.MREpisodeFPD(MREpisodeFPID),101)) //手术等级4
    s result = result_$lb($lg(^DHCEPRFS.INST.MREpisodeFPD(MREpisodeFPID),116)) //手术等级5
    s result = result_$lb($lg(^DHCEPRFS.INST.MREpisodeFPD(MREpisodeFPID),131)) //手术等级6
    s result = result_$lb($lg(^DHCEPRFS.INST.MREpisodeFPD(MREpisodeFPID),146)) //手术等级7
    s result = result_$lb($lg(^DHCEPRFS.INST.MREpisodeFPD(MREpisodeFPID),161)) //手术等级8
    q result
}

/// Desc: 手术等级1
/// debug: ##Class(DHCEPRFS.BL.BLQueryClassMethod).Oper01Level(1)
ClassMethod Oper01Level(MrEpisodeID As %String) As %List
{
	s result = $lb("")
	q:(MrEpisodeID = "") result
	s MREpisodeFPID = $o(^DHCEPRFS.INST.MREpisodeFPI("IdxMrEpisodeID"," "_MrEpisodeID,""))
	q:(MREpisodeFPID = "") result
	s result = $lg(^DHCEPRFS.INST.MREpisodeFPD(MREpisodeFPID),56)
	s result = $lb(result)
	q result
}

/// Desc: 手术等级2
/// debug: ##Class(DHCEPRFS.BL.BLQueryClassMethod).Oper02Level(1)
ClassMethod Oper02Level(MrEpisodeID As %String) As %List
{
	s result = $lb("")
	q:(MrEpisodeID = "") result
	s MREpisodeFPID = $o(^DHCEPRFS.INST.MREpisodeFPI("IdxMrEpisodeID"," "_MrEpisodeID,""))
	q:(MREpisodeFPID = "") result
	s result = $lg(^DHCEPRFS.INST.MREpisodeFPD(MREpisodeFPID),71)
	s result = $lb(result)
	q result
}

/// Desc: 手术等级3
/// debug: ##Class(DHCEPRFS.BL.BLQueryClassMethod).Oper03Level(1)
ClassMethod Oper03Level(MrEpisodeID As %String) As %List
{
	s result = $lb("")
	q:(MrEpisodeID = "") result
	s MREpisodeFPID = $o(^DHCEPRFS.INST.MREpisodeFPI("IdxMrEpisodeID"," "_MrEpisodeID,""))
	q:(MREpisodeFPID = "") result
	s result = $lg(^DHCEPRFS.INST.MREpisodeFPD(MREpisodeFPID),86)
	s result = $lb(result)
	q result
}

/// Desc: 手术等级4
/// debug: ##Class(DHCEPRFS.BL.BLQueryClassMethod).Oper04Level(1)
ClassMethod Oper04Level(MrEpisodeID As %String) As %List
{
	s result = $lb("")
	q:(MrEpisodeID = "") result
	s MREpisodeFPID = $o(^DHCEPRFS.INST.MREpisodeFPI("IdxMrEpisodeID"," "_MrEpisodeID,""))
	q:(MREpisodeFPID = "") result
	s result = $lg(^DHCEPRFS.INST.MREpisodeFPD(MREpisodeFPID),101)
	s result = $lb(result)
	q result
}

/// Desc: 手术等级5
/// debug: ##Class(DHCEPRFS.BL.BLQueryClassMethod).Oper05Level(1)
ClassMethod Oper05Level(MrEpisodeID As %String) As %List
{
	s result = $lb("")
	q:(MrEpisodeID = "") result
	s MREpisodeFPID = $o(^DHCEPRFS.INST.MREpisodeFPI("IdxMrEpisodeID"," "_MrEpisodeID,""))
	q:(MREpisodeFPID = "") result
	s result = $lg(^DHCEPRFS.INST.MREpisodeFPD(MREpisodeFPID),116)
	s result = $lb(result)
	q result
}

/// Desc: 手术等级6
/// debug: ##Class(DHCEPRFS.BL.BLQueryClassMethod).Oper06Level(1)
ClassMethod Oper06Level(MrEpisodeID As %String) As %List
{
	s result = $lb("")
	q:(MrEpisodeID = "") result
	s MREpisodeFPID = $o(^DHCEPRFS.INST.MREpisodeFPI("IdxMrEpisodeID"," "_MrEpisodeID,""))
	q:(MREpisodeFPID = "") result
	s result = $lg(^DHCEPRFS.INST.MREpisodeFPD(MREpisodeFPID),131)
	s result = $lb(result)
	q result
}

/// Desc: 手术等级7
/// debug: ##Class(DHCEPRFS.BL.BLQueryClassMethod).Oper07Level(1)
ClassMethod Oper07Level(MrEpisodeID As %String) As %List
{
	s result = $lb("")
	q:(MrEpisodeID = "") result
	s MREpisodeFPID = $o(^DHCEPRFS.INST.MREpisodeFPI("IdxMrEpisodeID"," "_MrEpisodeID,""))
	q:(MREpisodeFPID = "") result
	s result = $lg(^DHCEPRFS.INST.MREpisodeFPD(MREpisodeFPID),146)
	s result = $lb(result)
	q result
}

/// Desc: 手术等级8
/// debug: ##Class(DHCEPRFS.BL.BLQueryClassMethod).Oper08Level(1)
ClassMethod Oper08Level(MrEpisodeID As %String) As %List
{
	s result = $lb("")
	q:(MrEpisodeID = "") result
	s MREpisodeFPID = $o(^DHCEPRFS.INST.MREpisodeFPI("IdxMrEpisodeID"," "_MrEpisodeID,""))
	q:(MREpisodeFPID = "") result
	s result = $lg(^DHCEPRFS.INST.MREpisodeFPD(MREpisodeFPID),161)
	s result = $lb(result)
	q result
}

/// Desc: 麻醉方法 -查询条件
ClassMethod OperAnaMethod(MrEpisodeID As %String) As %List
{
	s result = $lb("")
	q:(MrEpisodeID = "") result
	s MREpisodeFPID = $o(^DHCEPRFS.INST.MREpisodeFPI("IdxMrEpisodeID"," "_MrEpisodeID,""))
	q:(MREpisodeFPID = "") result
	s result = $lb($lg(^DHCEPRFS.INST.MREpisodeFPD(MREpisodeFPID),65)) //麻醉方法1
	s result = result_$lb($lg(^DHCEPRFS.INST.MREpisodeFPD(MREpisodeFPID),80)) //麻醉方法2
	s result = result_$lb($lg(^DHCEPRFS.INST.MREpisodeFPD(MREpisodeFPID),95)) //麻醉方法3
	s result = result_$lb($lg(^DHCEPRFS.INST.MREpisodeFPD(MREpisodeFPID),110)) //麻醉方法4
    s result = result_$lb($lg(^DHCEPRFS.INST.MREpisodeFPD(MREpisodeFPID),125)) //麻醉方法5
    s result = result_$lb($lg(^DHCEPRFS.INST.MREpisodeFPD(MREpisodeFPID),140)) //麻醉方法6
    s result = result_$lb($lg(^DHCEPRFS.INST.MREpisodeFPD(MREpisodeFPID),155)) //麻醉方法7
    s result = result_$lb($lg(^DHCEPRFS.INST.MREpisodeFPD(MREpisodeFPID),170)) //麻醉方法8
    q result
}

/// Desc: 手术1麻醉方式
/// debug: ##Class(DHCEPRFS.BL.BLQueryClassMethod).Oper01AnaMethod(1)
ClassMethod Oper01AnaMethod(MrEpisodeID As %String) As %List
{
	s result = $lb("")
	q:(MrEpisodeID = "") result
	s MREpisodeFPID = $o(^DHCEPRFS.INST.MREpisodeFPI("IdxMrEpisodeID"," "_MrEpisodeID,""))
	q:(MREpisodeFPID = "") result
	s result = $lg(^DHCEPRFS.INST.MREpisodeFPD(MREpisodeFPID),65)
	s result = $lb(result)
	q result
}

/// Desc: 手术2麻醉方式
/// debug: ##Class(DHCEPRFS.BL.BLQueryClassMethod).Oper01AnaMethod(1)
ClassMethod Oper02AnaMethod(MrEpisodeID As %String) As %List
{
	s result = $lb("")
	q:(MrEpisodeID = "") result
	s MREpisodeFPID = $o(^DHCEPRFS.INST.MREpisodeFPI("IdxMrEpisodeID"," "_MrEpisodeID,""))
	q:(MREpisodeFPID = "") result
	s result = $lg(^DHCEPRFS.INST.MREpisodeFPD(MREpisodeFPID),80)
	s result = $lb(result)
	q result
}

/// Desc: 手术3麻醉方式
/// debug: ##Class(DHCEPRFS.BL.BLQueryClassMethod).Oper03AnaMethod(1)
ClassMethod Oper03AnaMethod(MrEpisodeID As %String) As %List
{
	s result = $lb("")
	q:(MrEpisodeID = "") result
	s MREpisodeFPID = $o(^DHCEPRFS.INST.MREpisodeFPI("IdxMrEpisodeID"," "_MrEpisodeID,""))
	q:(MREpisodeFPID = "") result
	s result = $lg(^DHCEPRFS.INST.MREpisodeFPD(MREpisodeFPID),95)
	s result = $lb(result)
	q result
}

/// Desc: 手术4麻醉方式
/// debug: ##Class(DHCEPRFS.BL.BLQueryClassMethod).Oper04AnaMethod(1)
ClassMethod Oper04AnaMethod(MrEpisodeID As %String) As %List
{
	s result = $lb("")
	q:(MrEpisodeID = "") result
	s MREpisodeFPID = $o(^DHCEPRFS.INST.MREpisodeFPI("IdxMrEpisodeID"," "_MrEpisodeID,""))
	q:(MREpisodeFPID = "") result
	s result = $lg(^DHCEPRFS.INST.MREpisodeFPD(MREpisodeFPID),110)
	s result = $lb(result)
	q result
}

/// Desc: 手术5麻醉方式
/// debug: ##Class(DHCEPRFS.BL.BLQueryClassMethod).Oper05AnaMethod(1)
ClassMethod Oper05AnaMethod(MrEpisodeID As %String) As %List
{
	s result = $lb("")
	q:(MrEpisodeID = "") result
	s MREpisodeFPID = $o(^DHCEPRFS.INST.MREpisodeFPI("IdxMrEpisodeID"," "_MrEpisodeID,""))
	q:(MREpisodeFPID = "") result
	s result = $lg(^DHCEPRFS.INST.MREpisodeFPD(MREpisodeFPID),125)
	s result = $lb(result)
	q result
}

/// Desc: 手术6麻醉方式
/// debug: ##Class(DHCEPRFS.BL.BLQueryClassMethod).Oper06AnaMethod(1)
ClassMethod Oper06AnaMethod(MrEpisodeID As %String) As %List
{
	s result = $lb("")
	q:(MrEpisodeID = "") result
	s MREpisodeFPID = $o(^DHCEPRFS.INST.MREpisodeFPI("IdxMrEpisodeID"," "_MrEpisodeID,""))
	q:(MREpisodeFPID = "") result
	s result = $lg(^DHCEPRFS.INST.MREpisodeFPD(MREpisodeFPID),140)
	s result = $lb(result)
	q result
}

/// Desc: 手术7麻醉方式
/// debug: ##Class(DHCEPRFS.BL.BLQueryClassMethod).Oper07AnaMethod(1)
ClassMethod Oper07AnaMethod(MrEpisodeID As %String) As %List
{
	s result = $lb("")
	q:(MrEpisodeID = "") result
	s MREpisodeFPID = $o(^DHCEPRFS.INST.MREpisodeFPI("IdxMrEpisodeID"," "_MrEpisodeID,""))
	q:(MREpisodeFPID = "") result
	s result = $lg(^DHCEPRFS.INST.MREpisodeFPD(MREpisodeFPID),155)
	s result = $lb(result)
	q result
}

/// Desc: 手术8麻醉方式
/// debug: ##Class(DHCEPRFS.BL.BLQueryClassMethod).Oper08AnaMethod(1)
ClassMethod Oper08AnaMethod(MrEpisodeID As %String) As %List
{
	s result = $lb("")
	q:(MrEpisodeID = "") result
	s MREpisodeFPID = $o(^DHCEPRFS.INST.MREpisodeFPI("IdxMrEpisodeID"," "_MrEpisodeID,""))
	q:(MREpisodeFPID = "") result
	s result = $lg(^DHCEPRFS.INST.MREpisodeFPD(MREpisodeFPID),170)
	s result = $lb(result)
	q result
}

/// Desc:麻醉医师 -查询条件
ClassMethod OperAnaDocName(MrEpisodeID As %String) As %List
{
	s result = $lb("")
	q:(MrEpisodeID = "") result
	s MREpisodeFPID = $o(^DHCEPRFS.INST.MREpisodeFPI("IdxMrEpisodeID"," "_MrEpisodeID,""))
	q:(MREpisodeFPID = "") result
	s result = $lb($lg(^DHCEPRFS.INST.MREpisodeFPD(MREpisodeFPID),67)) //麻醉医师1
	s result = result_$lb($lg(^DHCEPRFS.INST.MREpisodeFPD(MREpisodeFPID),82)) //麻醉医师2
	s result = result_$lb($lg(^DHCEPRFS.INST.MREpisodeFPD(MREpisodeFPID),97)) //麻醉医师3
	s result = result_$lb($lg(^DHCEPRFS.INST.MREpisodeFPD(MREpisodeFPID),112)) //麻醉医师4
    s result = result_$lb($lg(^DHCEPRFS.INST.MREpisodeFPD(MREpisodeFPID),127)) //麻醉医师5
    s result = result_$lb($lg(^DHCEPRFS.INST.MREpisodeFPD(MREpisodeFPID),142)) //麻醉医师6
    s result = result_$lb($lg(^DHCEPRFS.INST.MREpisodeFPD(MREpisodeFPID),157)) //麻醉医师7
    s result = result_$lb($lg(^DHCEPRFS.INST.MREpisodeFPD(MREpisodeFPID),172)) //麻醉医师8
    q result
}

/// Desc: 手术1麻醉医生
/// debug: ##Class(DHCEPRFS.BL.BLQueryClassMethod).Oper01AnaDocName(1)
ClassMethod Oper01AnaDocName(MrEpisodeID As %String) As %List
{
	s result = $lb("")
	q:(MrEpisodeID = "") result
	s MREpisodeFPID = $o(^DHCEPRFS.INST.MREpisodeFPI("IdxMrEpisodeID"," "_MrEpisodeID,""))
	q:(MREpisodeFPID = "") result
	s result = $lg(^DHCEPRFS.INST.MREpisodeFPD(MREpisodeFPID),67)
	s result = $lb(result)
	q result
}

/// Desc: 手术2麻醉医生
/// debug: ##Class(DHCEPRFS.BL.BLQueryClassMethod).Oper01AnaDocName(1)
ClassMethod Oper02AnaDocName(MrEpisodeID As %String) As %List
{
	s result = $lb("")
	q:(MrEpisodeID = "") result
	s MREpisodeFPID = $o(^DHCEPRFS.INST.MREpisodeFPI("IdxMrEpisodeID"," "_MrEpisodeID,""))
	q:(MREpisodeFPID = "") result
	s result = $lg(^DHCEPRFS.INST.MREpisodeFPD(MREpisodeFPID),82)
	s result = $lb(result)
	q result
}

/// Desc: 手术3麻醉医生
/// debug: ##Class(DHCEPRFS.BL.BLQueryClassMethod).Oper01AnaDocName(1)
ClassMethod Oper03AnaDocName(MrEpisodeID As %String) As %List
{
	s result = $lb("")
	q:(MrEpisodeID = "") result
	s MREpisodeFPID = $o(^DHCEPRFS.INST.MREpisodeFPI("IdxMrEpisodeID"," "_MrEpisodeID,""))
	q:(MREpisodeFPID = "") result
	s result = $lg(^DHCEPRFS.INST.MREpisodeFPD(MREpisodeFPID),97)
	s result = $lb(result)
	q result
}

/// Desc: 手术4麻醉医生
/// debug: ##Class(DHCEPRFS.BL.BLQueryClassMethod).Oper01AnaDocName(1)
ClassMethod Oper04AnaDocName(MrEpisodeID As %String) As %List
{
	s result = $lb("")
	q:(MrEpisodeID = "") result
	s MREpisodeFPID = $o(^DHCEPRFS.INST.MREpisodeFPI("IdxMrEpisodeID"," "_MrEpisodeID,""))
	q:(MREpisodeFPID = "") result
	s result = $lg(^DHCEPRFS.INST.MREpisodeFPD(MREpisodeFPID),112)
	s result = $lb(result)
	q result
}

/// Desc: 手术5麻醉医生
/// debug: ##Class(DHCEPRFS.BL.BLQueryClassMethod).Oper05AnaDocName(1)
ClassMethod Oper05AnaDocName(MrEpisodeID As %String) As %List
{
	s result = $lb("")
	q:(MrEpisodeID = "") result
	s MREpisodeFPID = $o(^DHCEPRFS.INST.MREpisodeFPI("IdxMrEpisodeID"," "_MrEpisodeID,""))
	q:(MREpisodeFPID = "") result
	s result = $lg(^DHCEPRFS.INST.MREpisodeFPD(MREpisodeFPID),127)
	s result = $lb(result)
	q result
}

/// Desc: 手术6麻醉医生
/// debug: ##Class(DHCEPRFS.BL.BLQueryClassMethod).Oper01AnaDocName(1)
ClassMethod Oper06AnaDocName(MrEpisodeID As %String) As %List
{
	s result = $lb("")
	q:(MrEpisodeID = "") result
	s MREpisodeFPID = $o(^DHCEPRFS.INST.MREpisodeFPI("IdxMrEpisodeID"," "_MrEpisodeID,""))
	q:(MREpisodeFPID = "") result
	s result = $lg(^DHCEPRFS.INST.MREpisodeFPD(MREpisodeFPID),142)
	s result = $lb(result)
	q result
}

/// Desc: 手术7麻醉医生
/// debug: ##Class(DHCEPRFS.BL.BLQueryClassMethod).Oper01AnaDocName(1)
ClassMethod Oper07AnaDocName(MrEpisodeID As %String) As %List
{
	s result = $lb("")
	q:(MrEpisodeID = "") result
	s MREpisodeFPID = $o(^DHCEPRFS.INST.MREpisodeFPI("IdxMrEpisodeID"," "_MrEpisodeID,""))
	q:(MREpisodeFPID = "") result
	s result = $lg(^DHCEPRFS.INST.MREpisodeFPD(MREpisodeFPID),157)
	s result = $lb(result)
	q result
}

/// Desc: 手术8麻醉医生
/// debug: ##Class(DHCEPRFS.BL.BLQueryClassMethod).Oper01AnaDocName(1)
ClassMethod Oper08AnaDocName(MrEpisodeID As %String) As %List
{
	s result = $lb("")
	q:(MrEpisodeID = "") result
	s MREpisodeFPID = $o(^DHCEPRFS.INST.MREpisodeFPI("IdxMrEpisodeID"," "_MrEpisodeID,""))
	q:(MREpisodeFPID = "") result
	s result = $lg(^DHCEPRFS.INST.MREpisodeFPD(MREpisodeFPID),172)
	s result = $lb(result)
	q result
}

/// Desc:一助 -查询条件
ClassMethod OperAssist1Name(MrEpisodeID As %String) As %List
{
	s result = $lb("")
	q:(MrEpisodeID = "") result
	s MREpisodeFPID = $o(^DHCEPRFS.INST.MREpisodeFPI("IdxMrEpisodeID"," "_MrEpisodeID,""))
	q:(MREpisodeFPID = "") result
	s result = $lb($lg(^DHCEPRFS.INST.MREpisodeFPD(MREpisodeFPID),61)) //一助1
	s result = result_$lb($lg(^DHCEPRFS.INST.MREpisodeFPD(MREpisodeFPID),76)) //一助2
	s result = result_$lb($lg(^DHCEPRFS.INST.MREpisodeFPD(MREpisodeFPID),91)) //一助3
	s result = result_$lb($lg(^DHCEPRFS.INST.MREpisodeFPD(MREpisodeFPID),106)) //一助4
    s result = result_$lb($lg(^DHCEPRFS.INST.MREpisodeFPD(MREpisodeFPID),121)) //一助5
    s result = result_$lb($lg(^DHCEPRFS.INST.MREpisodeFPD(MREpisodeFPID),136)) //一助6
    s result = result_$lb($lg(^DHCEPRFS.INST.MREpisodeFPD(MREpisodeFPID),151)) //一助7
    s result = result_$lb($lg(^DHCEPRFS.INST.MREpisodeFPD(MREpisodeFPID),166)) //一助8
    q result
}

/// Desc:手术1助手1 -查询条件
ClassMethod Oper01Assist1Name(MrEpisodeID As %String) As %List
{
	s result = $lb("")
	q:(MrEpisodeID = "") result
	s MREpisodeFPID = $o(^DHCEPRFS.INST.MREpisodeFPI("IdxMrEpisodeID"," "_MrEpisodeID,""))
	q:(MREpisodeFPID = "") result
	s result = $lb($lg(^DHCEPRFS.INST.MREpisodeFPD(MREpisodeFPID),61)) //手术医师1
    q result
}

/// Desc:手术2助手1 -查询条件
ClassMethod Oper02Assist1Name(MrEpisodeID As %String) As %List
{
	s result = $lb("")
	q:(MrEpisodeID = "") result
	s MREpisodeFPID = $o(^DHCEPRFS.INST.MREpisodeFPI("IdxMrEpisodeID"," "_MrEpisodeID,""))
	q:(MREpisodeFPID = "") result
	s result = $lb($lg(^DHCEPRFS.INST.MREpisodeFPD(MREpisodeFPID),76)) //手术医师1
    q result
}

/// Desc:手术3助手1 -查询条件
ClassMethod Oper03Assist1Name(MrEpisodeID As %String) As %List
{
	s result = $lb("")
	q:(MrEpisodeID = "") result
	s MREpisodeFPID = $o(^DHCEPRFS.INST.MREpisodeFPI("IdxMrEpisodeID"," "_MrEpisodeID,""))
	q:(MREpisodeFPID = "") result
	s result = $lb($lg(^DHCEPRFS.INST.MREpisodeFPD(MREpisodeFPID),91)) //手术医师1
    q result
}

/// Desc:手术4助手1 -查询条件
ClassMethod Oper04Assist1Name(MrEpisodeID As %String) As %List
{
	s result = $lb("")
	q:(MrEpisodeID = "") result
	s MREpisodeFPID = $o(^DHCEPRFS.INST.MREpisodeFPI("IdxMrEpisodeID"," "_MrEpisodeID,""))
	q:(MREpisodeFPID = "") result
	s result = $lb($lg(^DHCEPRFS.INST.MREpisodeFPD(MREpisodeFPID),106)) //手术医师1
    q result
}

/// Desc:手术5助手1 -查询条件
ClassMethod Oper05Assist1Name(MrEpisodeID As %String) As %List
{
	s result = $lb("")
	q:(MrEpisodeID = "") result
	s MREpisodeFPID = $o(^DHCEPRFS.INST.MREpisodeFPI("IdxMrEpisodeID"," "_MrEpisodeID,""))
	q:(MREpisodeFPID = "") result
	s result = $lb($lg(^DHCEPRFS.INST.MREpisodeFPD(MREpisodeFPID),121)) //手术医师1
    q result
}

/// Desc:手术6助手1 -查询条件
ClassMethod Oper06Assist1Name(MrEpisodeID As %String) As %List
{
	s result = $lb("")
	q:(MrEpisodeID = "") result
	s MREpisodeFPID = $o(^DHCEPRFS.INST.MREpisodeFPI("IdxMrEpisodeID"," "_MrEpisodeID,""))
	q:(MREpisodeFPID = "") result
	s result = $lb($lg(^DHCEPRFS.INST.MREpisodeFPD(MREpisodeFPID),136)) //手术医师1
    q result
}

/// Desc:手术7助手1 -查询条件
ClassMethod Oper07Assist1Name(MrEpisodeID As %String) As %List
{
	s result = $lb("")
	q:(MrEpisodeID = "") result
	s MREpisodeFPID = $o(^DHCEPRFS.INST.MREpisodeFPI("IdxMrEpisodeID"," "_MrEpisodeID,""))
	q:(MREpisodeFPID = "") result
	s result = $lb($lg(^DHCEPRFS.INST.MREpisodeFPD(MREpisodeFPID),151)) //手术医师1
    q result
}

/// Desc:手术8助手1 -查询条件
ClassMethod Oper08Assist1Name(MrEpisodeID As %String) As %List
{
	s result = $lb("")
	q:(MrEpisodeID = "") result
	s MREpisodeFPID = $o(^DHCEPRFS.INST.MREpisodeFPI("IdxMrEpisodeID"," "_MrEpisodeID,""))
	q:(MREpisodeFPID = "") result
	s result = $lb($lg(^DHCEPRFS.INST.MREpisodeFPD(MREpisodeFPID),166)) //手术医师1
    q result
}

/// Desc: 二助 -查询条件
ClassMethod OperAssist2Name(MrEpisodeID As %String) As %List
{
	s result = $lb("")
	q:(MrEpisodeID = "") result
	s MREpisodeFPID = $o(^DHCEPRFS.INST.MREpisodeFPI("IdxMrEpisodeID"," "_MrEpisodeID,""))
	q:(MREpisodeFPID = "") result
	s result = $lb($lg(^DHCEPRFS.INST.MREpisodeFPD(MREpisodeFPID),63)) //二助1
	s result = result_$lb($lg(^DHCEPRFS.INST.MREpisodeFPD(MREpisodeFPID),78)) //二助2
	s result = result_$lb($lg(^DHCEPRFS.INST.MREpisodeFPD(MREpisodeFPID),93)) //二助3
	s result = result_$lb($lg(^DHCEPRFS.INST.MREpisodeFPD(MREpisodeFPID),108)) //二助4
    s result = result_$lb($lg(^DHCEPRFS.INST.MREpisodeFPD(MREpisodeFPID),123)) //二助5
    s result = result_$lb($lg(^DHCEPRFS.INST.MREpisodeFPD(MREpisodeFPID),138)) //二助6
    s result = result_$lb($lg(^DHCEPRFS.INST.MREpisodeFPD(MREpisodeFPID),153)) //二助7
    s result = result_$lb($lg(^DHCEPRFS.INST.MREpisodeFPD(MREpisodeFPID),168)) //二助8
    q result
}

/// Desc:手术1助手2 -查询条件
ClassMethod Oper01Assist2Name(MrEpisodeID As %String) As %List
{
	s result = $lb("")
	q:(MrEpisodeID = "") result
	s MREpisodeFPID = $o(^DHCEPRFS.INST.MREpisodeFPI("IdxMrEpisodeID"," "_MrEpisodeID,""))
	q:(MREpisodeFPID = "") result
	s result = $lb($lg(^DHCEPRFS.INST.MREpisodeFPD(MREpisodeFPID),63)) //手术医师1
    q result
}

/// Desc:手术2助手2 -查询条件
ClassMethod Oper02Assist2Name(MrEpisodeID As %String) As %List
{
	s result = $lb("")
	q:(MrEpisodeID = "") result
	s MREpisodeFPID = $o(^DHCEPRFS.INST.MREpisodeFPI("IdxMrEpisodeID"," "_MrEpisodeID,""))
	q:(MREpisodeFPID = "") result
	s result = $lb($lg(^DHCEPRFS.INST.MREpisodeFPD(MREpisodeFPID),78)) //手术医师1
    q result
}

/// Desc:手术3助手2 -查询条件
ClassMethod Oper03Assist2Name(MrEpisodeID As %String) As %List
{
	s result = $lb("")
	q:(MrEpisodeID = "") result
	s MREpisodeFPID = $o(^DHCEPRFS.INST.MREpisodeFPI("IdxMrEpisodeID"," "_MrEpisodeID,""))
	q:(MREpisodeFPID = "") result
	s result = $lb($lg(^DHCEPRFS.INST.MREpisodeFPD(MREpisodeFPID),93)) //手术医师1
    q result
}

/// Desc:手术4助手2 -查询条件
ClassMethod Oper04Assist2Name(MrEpisodeID As %String) As %List
{
	s result = $lb("")
	q:(MrEpisodeID = "") result
	s MREpisodeFPID = $o(^DHCEPRFS.INST.MREpisodeFPI("IdxMrEpisodeID"," "_MrEpisodeID,""))
	q:(MREpisodeFPID = "") result
	s result = $lb($lg(^DHCEPRFS.INST.MREpisodeFPD(MREpisodeFPID),108)) //手术医师1
    q result
}

/// Desc:手术5助手2 -查询条件
ClassMethod Oper05Assist2Name(MrEpisodeID As %String) As %List
{
	s result = $lb("")
	q:(MrEpisodeID = "") result
	s MREpisodeFPID = $o(^DHCEPRFS.INST.MREpisodeFPI("IdxMrEpisodeID"," "_MrEpisodeID,""))
	q:(MREpisodeFPID = "") result
	s result = $lb($lg(^DHCEPRFS.INST.MREpisodeFPD(MREpisodeFPID),123)) //手术医师1
    q result
}

/// Desc:手术6助手2 -查询条件
ClassMethod Oper06Assist2Name(MrEpisodeID As %String) As %List
{
	s result = $lb("")
	q:(MrEpisodeID = "") result
	s MREpisodeFPID = $o(^DHCEPRFS.INST.MREpisodeFPI("IdxMrEpisodeID"," "_MrEpisodeID,""))
	q:(MREpisodeFPID = "") result
	s result = $lb($lg(^DHCEPRFS.INST.MREpisodeFPD(MREpisodeFPID),138)) //手术医师1
    q result
}

/// Desc:手术7助手2 -查询条件
ClassMethod Oper07Assist2Name(MrEpisodeID As %String) As %List
{
	s result = $lb("")
	q:(MrEpisodeID = "") result
	s MREpisodeFPID = $o(^DHCEPRFS.INST.MREpisodeFPI("IdxMrEpisodeID"," "_MrEpisodeID,""))
	q:(MREpisodeFPID = "") result
	s result = $lb($lg(^DHCEPRFS.INST.MREpisodeFPD(MREpisodeFPID),153)) //手术医师1
    q result
}

/// Desc:手术8助手2 -查询条件
ClassMethod Oper08Assist2Name(MrEpisodeID As %String) As %List
{
	s result = $lb("")
	q:(MrEpisodeID = "") result
	s MREpisodeFPID = $o(^DHCEPRFS.INST.MREpisodeFPI("IdxMrEpisodeID"," "_MrEpisodeID,""))
	q:(MREpisodeFPID = "") result
	s result = $lb($lg(^DHCEPRFS.INST.MREpisodeFPD(MREpisodeFPID),168)) //手术医师1
    q result
}

/// Desc:手术医师 -查询条件
ClassMethod OperDocName(MrEpisodeID As %String) As %List
{
	s result = $lb("")
	q:(MrEpisodeID = "") result
	s MREpisodeFPID = $o(^DHCEPRFS.INST.MREpisodeFPI("IdxMrEpisodeID"," "_MrEpisodeID,""))
	q:(MREpisodeFPID = "") result
	s result = $lb($lg(^DHCEPRFS.INST.MREpisodeFPD(MREpisodeFPID),59)) //手术医师1
	s result = result_$lb($lg(^DHCEPRFS.INST.MREpisodeFPD(MREpisodeFPID),74)) //手术医师2
	s result = result_$lb($lg(^DHCEPRFS.INST.MREpisodeFPD(MREpisodeFPID),89)) //手术医师3
	s result = result_$lb($lg(^DHCEPRFS.INST.MREpisodeFPD(MREpisodeFPID),104)) //手术医师4
    s result = result_$lb($lg(^DHCEPRFS.INST.MREpisodeFPD(MREpisodeFPID),119)) //手术医师5
    s result = result_$lb($lg(^DHCEPRFS.INST.MREpisodeFPD(MREpisodeFPID),134)) //手术医师6
    s result = result_$lb($lg(^DHCEPRFS.INST.MREpisodeFPD(MREpisodeFPID),149)) //手术医师7
    s result = result_$lb($lg(^DHCEPRFS.INST.MREpisodeFPD(MREpisodeFPID),164)) //手术医师8
    q result
}

/// Desc:手术1术者 -查询条件
ClassMethod Oper01DocName(MrEpisodeID As %String) As %List
{
	s result = $lb("")
	q:(MrEpisodeID = "") result
	s MREpisodeFPID = $o(^DHCEPRFS.INST.MREpisodeFPI("IdxMrEpisodeID"," "_MrEpisodeID,""))
	q:(MREpisodeFPID = "") result
	s result = $lb($lg(^DHCEPRFS.INST.MREpisodeFPD(MREpisodeFPID),59)) //手术医师1
    q result
}

/// Desc:手术2术者 -查询条件
ClassMethod Oper02DocName(MrEpisodeID As %String) As %List
{
	s result = $lb("")
	q:(MrEpisodeID = "") result
	s MREpisodeFPID = $o(^DHCEPRFS.INST.MREpisodeFPI("IdxMrEpisodeID"," "_MrEpisodeID,""))
	q:(MREpisodeFPID = "") result
	s result = $lb($lg(^DHCEPRFS.INST.MREpisodeFPD(MREpisodeFPID),74)) //手术医师1
    q result
}

/// Desc:手术3术者 -查询条件
ClassMethod Oper03DocName(MrEpisodeID As %String) As %List
{
	s result = $lb("")
	q:(MrEpisodeID = "") result
	s MREpisodeFPID = $o(^DHCEPRFS.INST.MREpisodeFPI("IdxMrEpisodeID"," "_MrEpisodeID,""))
	q:(MREpisodeFPID = "") result
	s result = $lb($lg(^DHCEPRFS.INST.MREpisodeFPD(MREpisodeFPID),89)) //手术医师1
    q result
}

/// Desc:手术4术者 -查询条件
ClassMethod Oper04DocName(MrEpisodeID As %String) As %List
{
	s result = $lb("")
	q:(MrEpisodeID = "") result
	s MREpisodeFPID = $o(^DHCEPRFS.INST.MREpisodeFPI("IdxMrEpisodeID"," "_MrEpisodeID,""))
	q:(MREpisodeFPID = "") result
	s result = $lb($lg(^DHCEPRFS.INST.MREpisodeFPD(MREpisodeFPID),104)) //手术医师1
    q result
}

/// Desc:手术5术者 -查询条件
ClassMethod Oper05DocName(MrEpisodeID As %String) As %List
{
	s result = $lb("")
	q:(MrEpisodeID = "") result
	s MREpisodeFPID = $o(^DHCEPRFS.INST.MREpisodeFPI("IdxMrEpisodeID"," "_MrEpisodeID,""))
	q:(MREpisodeFPID = "") result
	s result = $lb($lg(^DHCEPRFS.INST.MREpisodeFPD(MREpisodeFPID),119)) //手术医师1
    q result
}

/// Desc:手术6术者 -查询条件
ClassMethod Oper06DocName(MrEpisodeID As %String) As %List
{
	s result = $lb("")
	q:(MrEpisodeID = "") result
	s MREpisodeFPID = $o(^DHCEPRFS.INST.MREpisodeFPI("IdxMrEpisodeID"," "_MrEpisodeID,""))
	q:(MREpisodeFPID = "") result
	s result = $lb($lg(^DHCEPRFS.INST.MREpisodeFPD(MREpisodeFPID),134)) //手术医师1
    q result
}

/// Desc:手术7术者 -查询条件
ClassMethod Oper07DocName(MrEpisodeID As %String) As %List
{
	s result = $lb("")
	q:(MrEpisodeID = "") result
	s MREpisodeFPID = $o(^DHCEPRFS.INST.MREpisodeFPI("IdxMrEpisodeID"," "_MrEpisodeID,""))
	q:(MREpisodeFPID = "") result
	s result = $lb($lg(^DHCEPRFS.INST.MREpisodeFPD(MREpisodeFPID),149)) //手术医师1
    q result
}

/// Desc:手术8术者 -查询条件
ClassMethod Oper08DocName(MrEpisodeID As %String) As %List
{
	s result = $lb("")
	q:(MrEpisodeID = "") result
	s MREpisodeFPID = $o(^DHCEPRFS.INST.MREpisodeFPI("IdxMrEpisodeID"," "_MrEpisodeID,""))
	q:(MREpisodeFPID = "") result
	s result = $lb($lg(^DHCEPRFS.INST.MREpisodeFPD(MREpisodeFPID),164)) //手术医师1
    q result
}

/// Desc: 切口愈合等级 -查询条件
ClassMethod OperCutLevel(MrEpisodeID As %String) As %List
{
	s result = $lb("")
	q:(MrEpisodeID = "") result
	s MREpisodeFPID = $o(^DHCEPRFS.INST.MREpisodeFPI("IdxMrEpisodeID"," "_MrEpisodeID,""))
	q:(MREpisodeFPID = "") result
	s result = $lb($lg(^DHCEPRFS.INST.MREpisodeFPD(MREpisodeFPID),64)) //麻醉方法1
	s result = result_$lb($lg(^DHCEPRFS.INST.MREpisodeFPD(MREpisodeFPID),79)) //麻醉方法2
	s result = result_$lb($lg(^DHCEPRFS.INST.MREpisodeFPD(MREpisodeFPID),94)) //麻醉方法3
	s result = result_$lb($lg(^DHCEPRFS.INST.MREpisodeFPD(MREpisodeFPID),109)) //麻醉方法4
    s result = result_$lb($lg(^DHCEPRFS.INST.MREpisodeFPD(MREpisodeFPID),124)) //麻醉方法5
    s result = result_$lb($lg(^DHCEPRFS.INST.MREpisodeFPD(MREpisodeFPID),139)) //麻醉方法6
    s result = result_$lb($lg(^DHCEPRFS.INST.MREpisodeFPD(MREpisodeFPID),154)) //麻醉方法7
    s result = result_$lb($lg(^DHCEPRFS.INST.MREpisodeFPD(MREpisodeFPID),169)) //麻醉方法8
    q result
}

/// Desc: 手术1切口等级
/// debug: ##Class(DHCEPRFS.BL.BLQueryClassMethod).Oper01CutLevel(1)
ClassMethod Oper01CutLevel(MrEpisodeID As %String) As %List
{
	s result = $lb("")
	q:(MrEpisodeID = "") result
	s MREpisodeFPID = $o(^DHCEPRFS.INST.MREpisodeFPI("IdxMrEpisodeID"," "_MrEpisodeID,""))
	q:(MREpisodeFPID = "") result
	s result = $lg(^DHCEPRFS.INST.MREpisodeFPD(MREpisodeFPID),64)
	s result = $lb(result)
	q result
}

/// Desc: 手术2切口等级
/// debug: ##Class(DHCEPRFS.BL.BLQueryClassMethod).Oper01CutLevel(1)
ClassMethod Oper02CutLevel(MrEpisodeID As %String) As %List
{
	s result = $lb("")
	q:(MrEpisodeID = "") result
	s MREpisodeFPID = $o(^DHCEPRFS.INST.MREpisodeFPI("IdxMrEpisodeID"," "_MrEpisodeID,""))
	q:(MREpisodeFPID = "") result
	s result = $lg(^DHCEPRFS.INST.MREpisodeFPD(MREpisodeFPID),79)
	s result = $lb(result)
	q result
}

/// Desc: 手术3切口等级
/// debug: ##Class(DHCEPRFS.BL.BLQueryClassMethod).Oper01CutLevel(1)
ClassMethod Oper03CutLevel(MrEpisodeID As %String) As %List
{
	s result = $lb("")
	q:(MrEpisodeID = "") result
	s MREpisodeFPID = $o(^DHCEPRFS.INST.MREpisodeFPI("IdxMrEpisodeID"," "_MrEpisodeID,""))
	q:(MREpisodeFPID = "") result
	s result = $lg(^DHCEPRFS.INST.MREpisodeFPD(MREpisodeFPID),94)
	s result = $lb(result)
	q result
}

/// Desc: 手术4切口等级
/// debug: ##Class(DHCEPRFS.BL.BLQueryClassMethod).Oper01CutLevel(1)
ClassMethod Oper04CutLevel(MrEpisodeID As %String) As %List
{
	s result = $lb("")
	q:(MrEpisodeID = "") result
	s MREpisodeFPID = $o(^DHCEPRFS.INST.MREpisodeFPI("IdxMrEpisodeID"," "_MrEpisodeID,""))
	q:(MREpisodeFPID = "") result
	s result = $lg(^DHCEPRFS.INST.MREpisodeFPD(MREpisodeFPID),109)
	s result = $lb(result)
	q result
}

/// Desc: 手术5切口等级
/// debug: ##Class(DHCEPRFS.BL.BLQueryClassMethod).Oper01CutLevel(1)
ClassMethod Oper05CutLevel(MrEpisodeID As %String) As %List
{
	s result = $lb("")
	q:(MrEpisodeID = "") result
	s MREpisodeFPID = $o(^DHCEPRFS.INST.MREpisodeFPI("IdxMrEpisodeID"," "_MrEpisodeID,""))
	q:(MREpisodeFPID = "") result
	s result = $lg(^DHCEPRFS.INST.MREpisodeFPD(MREpisodeFPID),124)
	s result = $lb(result)
	q result
}

/// Desc: 手术6切口等级
/// debug: ##Class(DHCEPRFS.BL.BLQueryClassMethod).Oper01CutLevel(1)
ClassMethod Oper06CutLevel(MrEpisodeID As %String) As %List
{
	s result = $lb("")
	q:(MrEpisodeID = "") result
	s MREpisodeFPID = $o(^DHCEPRFS.INST.MREpisodeFPI("IdxMrEpisodeID"," "_MrEpisodeID,""))
	q:(MREpisodeFPID = "") result
	s result = $lg(^DHCEPRFS.INST.MREpisodeFPD(MREpisodeFPID),139)
	s result = $lb(result)
	q result
}

/// Desc: 手术7切口等级
/// debug: ##Class(DHCEPRFS.BL.BLQueryClassMethod).Oper01CutLevel(1)
ClassMethod Oper07CutLevel(MrEpisodeID As %String) As %List
{
	s result = $lb("")
	q:(MrEpisodeID = "") result
	s MREpisodeFPID = $o(^DHCEPRFS.INST.MREpisodeFPI("IdxMrEpisodeID"," "_MrEpisodeID,""))
	q:(MREpisodeFPID = "") result
	s result = $lg(^DHCEPRFS.INST.MREpisodeFPD(MREpisodeFPID),154)
	s result = $lb(result)
	q result
}

/// Desc: 手术8切口等级
/// debug: ##Class(DHCEPRFS.BL.BLQueryClassMethod).Oper01CutLevel(1)
ClassMethod Oper08CutLevel(MrEpisodeID As %String) As %List
{
	s result = $lb("")
	q:(MrEpisodeID = "") result
	s MREpisodeFPID = $o(^DHCEPRFS.INST.MREpisodeFPI("IdxMrEpisodeID"," "_MrEpisodeID,""))
	q:(MREpisodeFPID = "") result
	s result = $lg(^DHCEPRFS.INST.MREpisodeFPD(MREpisodeFPID),169)
	s result = $lb(result)
	q result
}

/// Desc:是否为手术患者 -查询条件
/// debugger:w ##Class(DHCEPRFS.BL.BLQueryClassMethod).Operation(1)
ClassMethod Operation(MrEpisodeID As %String) As %List
{
    s result = $lb("N")
	q:(MrEpisodeID = "") result
	s operValues = ..OperDate(MrEpisodeID)
    for i = 1:1:$listlength(operValues)
    {
	    if ($listget(operValues,i) '= "")
	    {
		    s result = $lb("Y")
		    q
		}
	}
	q result
}

/// Desc:是否不是手术患者 -查询条件
/// debugger:w ##Class(DHCEPRFS.BL.BLQueryClassMethod).NotOperation(1)
ClassMethod NotOperation(MrEpisodeID As %String) As %List
{
    s result = $lb("Y")
	q:(MrEpisodeID = "") result
	s operValues = ..OperDate(MrEpisodeID)
    for i = 1:1:$listlength(operValues)
    {
	    if ($listget(operValues,i) '= "")
	    {
		    s result = $lb("N")
		    q
		}
	}
	q result
}

/// Desc:是否死亡患者 -查询条件
ClassMethod Death(MrEpisodeID As %String) As %List
{
	s result = $lb("N")
	q:(MrEpisodeID = "") result
	//s deathDate = ..DeathDate(MrEpisodeID)
	s deathDate = $lg(^DHCEPRFS.INST.MREpisodeD(MrEpisodeID),19)
	s:(deathDate '= "") result = $lb("Y")
	q result
}

/// Desc:是否非死亡患者 -查询条件
ClassMethod NotDeath(MrEpisodeID As %String) As %List
{
	s result = $lb("Y")
	q:(MrEpisodeID = "") result
	s deathDate = ..DeathDate(MrEpisodeID)
	s:($listget(deathDate,1) '= "") result = $lb("N")
	q result
}

/// Desc:是否危重患者 -查询条件
ClassMethod CritiCal(MrEpisodeID As %String) As %List
{
	s result = $lb("N")
	q:(MrEpisodeID = "") result
	s critiCal = $lg(^DHCEPRFS.INST.MREpisodeD(MrEpisodeID),39)
	q:(critiCal = "") result
	s:(critiCal = "Y") result = $lb("Y")
	q result
}

/// Desc:是否非危重患者 -查询条件
ClassMethod NotCritiCal(MrEpisodeID As %String) As %List
{
	s result = $lb("Y")
	q:(MrEpisodeID = "") result
	s critiCal = $lg(^DHCEPRFS.INST.MREpisodeD(MrEpisodeID),39)
	q:(critiCal = "") result
	s:(critiCal = "Y") result = $lb("N")
	q result
}

/// Desc:是否非计划再次手术患者 -查询条件
ClassMethod NoPlanAgainOp(MrEpisodeID As %String) As %List
{
	s result = $lb("N")
	q:(MrEpisodeID = "") result
	s noPlanAgainOp = $lg(^DHCEPRFS.INST.MREpisodeD(MrEpisodeID),52)
	q:(noPlanAgainOp = "") result
	s:(noPlanAgainOp = "Y") result = $lb("Y")
	q result
}

// 费用信息

/// Desc: 总费用
ClassMethod F00TotalFee(MrEpisodeID As %String) As %List
{
	s result = $lb("")
	q:(MrEpisodeID = "") result
	s MREpisodeFeeID = $o(^DHCEPRFS.INST.MREpisodeFeeI("IdxMREpisodeID"," "_MrEpisodeID,""))
	q:(MREpisodeFeeID = "") result
	s result = $lg(^DHCEPRFS.INST.MREpisodeFeeD(MREpisodeFeeID),9)
	s result = $lb(result)
	q result
}

/// Desc: 一般医疗服务费(01)
ClassMethod F01YBYLFWF(MrEpisodeID As %String) As %List
{
	s result = $lb("")
	q:(MrEpisodeID = "") result
	s MREpisodeFeeID = $o(^DHCEPRFS.INST.MREpisodeFeeI("IdxMREpisodeID"," "_MrEpisodeID,""))
	q:(MREpisodeFeeID = "") result
	s result = $lg(^DHCEPRFS.INST.MREpisodeFeeD(MREpisodeFeeID),10)
	s result = $lb(result)
	q result
}

/// 11 一般治疗操作费(02)
/// Property F02YBZLCZF As %Float [ SqlColumnNumber = 11 ];
ClassMethod F02YBZLCZF(MrEpisodeID As %String) As %List
{
	s result = $lb("")
	q:(MrEpisodeID = "") result
	s MREpisodeFeeID = $o(^DHCEPRFS.INST.MREpisodeFeeI("IdxMREpisodeID"," "_MrEpisodeID,""))
	q:(MREpisodeFeeID = "") result
	s result = $lg(^DHCEPRFS.INST.MREpisodeFeeD(MREpisodeFeeID),11)
	s result = $lb(result)
	q result
}

/// 12 护理费(03)
/// Property F03HLF As %Float [ SqlColumnNumber = 12 ];
ClassMethod F03HLF(MrEpisodeID As %String) As %List
{
	s result = $lb("")
	q:(MrEpisodeID = "") result
	s MREpisodeFeeID = $o(^DHCEPRFS.INST.MREpisodeFeeI("IdxMREpisodeID"," "_MrEpisodeID,""))
	q:(MREpisodeFeeID = "") result
	s result = $lg(^DHCEPRFS.INST.MREpisodeFeeD(MREpisodeFeeID),12)
	s result = $lb(result)
	q result
}

/// 13 其他费用(04)
/// Property F04QTFY As %Float [ SqlColumnNumber = 13 ];
ClassMethod F04QTFY(MrEpisodeID As %String) As %List
{
	s result = $lb("")
	q:(MrEpisodeID = "") result
	s MREpisodeFeeID = $o(^DHCEPRFS.INST.MREpisodeFeeI("IdxMREpisodeID"," "_MrEpisodeID,""))
	q:(MREpisodeFeeID = "") result
	s result = $lg(^DHCEPRFS.INST.MREpisodeFeeD(MREpisodeFeeID),13)
	s result = $lb(result)
	q result
}

/// 14 病理诊断费(05)
/// Property F05BLZDF As %Float [ SqlColumnNumber = 14 ];
ClassMethod F05BLZDF(MrEpisodeID As %String) As %List
{
	s result = $lb("")
	q:(MrEpisodeID = "") result
	s MREpisodeFeeID = $o(^DHCEPRFS.INST.MREpisodeFeeI("IdxMREpisodeID"," "_MrEpisodeID,""))
	q:(MREpisodeFeeID = "") result
	s result = $lg(^DHCEPRFS.INST.MREpisodeFeeD(MREpisodeFeeID),14)
	s result = $lb(result)
	q result
}

/// 15 实验室诊断费(06)
/// Property F06SYSZDF As %Float [ SqlColumnNumber = 15 ];
ClassMethod F06SYSZDF(MrEpisodeID As %String) As %List
{
	s result = $lb("")
	q:(MrEpisodeID = "") result
	s MREpisodeFeeID = $o(^DHCEPRFS.INST.MREpisodeFeeI("IdxMREpisodeID"," "_MrEpisodeID,""))
	q:(MREpisodeFeeID = "") result
	s result = $lg(^DHCEPRFS.INST.MREpisodeFeeD(MREpisodeFeeID),15)
	s result = $lb(result)
	q result
}

/// 16 影像学诊断费(07)
/// Property F07YXXZDF As %Float [ SqlColumnNumber = 16 ];
ClassMethod F07YXXZDF(MrEpisodeID As %String) As %List
{
	s result = $lb("")
	q:(MrEpisodeID = "") result
	s MREpisodeFeeID = $o(^DHCEPRFS.INST.MREpisodeFeeI("IdxMREpisodeID"," "_MrEpisodeID,""))
	q:(MREpisodeFeeID = "") result
	s result = $lg(^DHCEPRFS.INST.MREpisodeFeeD(MREpisodeFeeID),16)
	s result = $lb(result)
	q result
}

/// 17 临床诊断项目费(08)
/// Property F08LCZDXMF As %Float [ SqlColumnNumber = 17 ];
ClassMethod F08LCZDXMF(MrEpisodeID As %String) As %List
{
	s result = $lb("")
	q:(MrEpisodeID = "") result
	s MREpisodeFeeID = $o(^DHCEPRFS.INST.MREpisodeFeeI("IdxMREpisodeID"," "_MrEpisodeID,""))
	q:(MREpisodeFeeID = "") result
	s result = $lg(^DHCEPRFS.INST.MREpisodeFeeD(MREpisodeFeeID),17)
	s result = $lb(result)
	q result
}

/// 18 非手术治疗项目费(09)
/// Property F09FSSZLF As %Float [ SqlColumnNumber = 18 ];
ClassMethod F09FSSZLF(MrEpisodeID As %String) As %List
{
	s result = $lb("")
	q:(MrEpisodeID = "") result
	s MREpisodeFeeID = $o(^DHCEPRFS.INST.MREpisodeFeeI("IdxMREpisodeID"," "_MrEpisodeID,""))
	q:(MREpisodeFeeID = "") result
	s result = $lg(^DHCEPRFS.INST.MREpisodeFeeD(MREpisodeFeeID),18)
	s result = $lb(result)
	q result
}

/// 19 手术治疗费(10)
/// Property F10SSZLF As %Float [ SqlColumnNumber = 19 ];
ClassMethod F10SSZLF(MrEpisodeID As %String) As %List
{
	s result = $lb("")
	q:(MrEpisodeID = "") result
	s MREpisodeFeeID = $o(^DHCEPRFS.INST.MREpisodeFeeI("IdxMREpisodeID"," "_MrEpisodeID,""))
	q:(MREpisodeFeeID = "") result
	s result = $lg(^DHCEPRFS.INST.MREpisodeFeeD(MREpisodeFeeID),19)
	s result = $lb(result)
	q result
}

/// 20 康复费(11)
/// Property F11KFF As %Float [ SqlColumnNumber = 20 ];
ClassMethod F11KFF(MrEpisodeID As %String) As %List
{
	s result = $lb("")
	q:(MrEpisodeID = "") result
	s MREpisodeFeeID = $o(^DHCEPRFS.INST.MREpisodeFeeI("IdxMREpisodeID"," "_MrEpisodeID,""))
	q:(MREpisodeFeeID = "") result
	s result = $lg(^DHCEPRFS.INST.MREpisodeFeeD(MREpisodeFeeID),20)
	s result = $lb(result)
	q result
}

/// 21 中医治疗费(12)
/// Property F12ZYZLF As %Float [ SqlColumnNumber = 21 ];
ClassMethod F12ZYZLF(MrEpisodeID As %String) As %List
{
	s result = $lb("")
	q:(MrEpisodeID = "") result
	s MREpisodeFeeID = $o(^DHCEPRFS.INST.MREpisodeFeeI("IdxMREpisodeID"," "_MrEpisodeID,""))
	q:(MREpisodeFeeID = "") result
	s result = $lg(^DHCEPRFS.INST.MREpisodeFeeD(MREpisodeFeeID),21)
	s result = $lb(result)
	q result
}

/// 22 西药费(13)
/// Property F13XYF As %Float [ SqlColumnNumber = 22 ];
ClassMethod F13XYF(MrEpisodeID As %String) As %List
{
	s result = $lb("")
	q:(MrEpisodeID = "") result
	s MREpisodeFeeID = $o(^DHCEPRFS.INST.MREpisodeFeeI("IdxMREpisodeID"," "_MrEpisodeID,""))
	q:(MREpisodeFeeID = "") result
	s result = $lg(^DHCEPRFS.INST.MREpisodeFeeD(MREpisodeFeeID),22)
	s result = $lb(result)
	q result
}

/// 23 中成药费(14)
/// Property F14ZCHYF As %Float [ SqlColumnNumber = 23 ];
ClassMethod F14ZCHYF(MrEpisodeID As %String) As %List
{
	s result = $lb("")
	q:(MrEpisodeID = "") result
	s MREpisodeFeeID = $o(^DHCEPRFS.INST.MREpisodeFeeI("IdxMREpisodeID"," "_MrEpisodeID,""))
	q:(MREpisodeFeeID = "") result
	s result = $lg(^DHCEPRFS.INST.MREpisodeFeeD(MREpisodeFeeID),23)
	s result = $lb(result)
	q result
}

/// 24 中草药费(15)
/// Property F15ZCYF As %Float [ SqlColumnNumber = 24 ];
ClassMethod F15ZCYF(MrEpisodeID As %String) As %List
{
	s result = $lb("")
	q:(MrEpisodeID = "") result
	s MREpisodeFeeID = $o(^DHCEPRFS.INST.MREpisodeFeeI("IdxMREpisodeID"," "_MrEpisodeID,""))
	q:(MREpisodeFeeID = "") result
	s result = $lg(^DHCEPRFS.INST.MREpisodeFeeD(MREpisodeFeeID),24)
	s result = $lb(result)
	q result
}

/// 25 血费(16)
/// Property F16XF As %Float [ SqlColumnNumber = 25 ];
ClassMethod F16XF(MrEpisodeID As %String) As %List
{
	s result = $lb("")
	q:(MrEpisodeID = "") result
	s MREpisodeFeeID = $o(^DHCEPRFS.INST.MREpisodeFeeI("IdxMREpisodeID"," "_MrEpisodeID,""))
	q:(MREpisodeFeeID = "") result
	s result = $lg(^DHCEPRFS.INST.MREpisodeFeeD(MREpisodeFeeID),25)
	s result = $lb(result)
	q result
}

/// 26 白蛋白类制品费(17)
/// Property F17BDBLF As %Float [ SqlColumnNumber = 26 ];
ClassMethod F17BDBLF(MrEpisodeID As %String) As %List
{
	s result = $lb("")
	q:(MrEpisodeID = "") result
	s MREpisodeFeeID = $o(^DHCEPRFS.INST.MREpisodeFeeI("IdxMREpisodeID"," "_MrEpisodeID,""))
	q:(MREpisodeFeeID = "") result
	s result = $lg(^DHCEPRFS.INST.MREpisodeFeeD(MREpisodeFeeID),26)
	s result = $lb(result)
	q result
}

/// 27 球蛋白类制品费(18)
/// Property F18QDBLF As %Float [ SqlColumnNumber = 27 ];
ClassMethod F18QDBLF(MrEpisodeID As %String) As %List
{
	s result = $lb("")
	q:(MrEpisodeID = "") result
	s MREpisodeFeeID = $o(^DHCEPRFS.INST.MREpisodeFeeI("IdxMREpisodeID"," "_MrEpisodeID,""))
	q:(MREpisodeFeeID = "") result
	s result = $lg(^DHCEPRFS.INST.MREpisodeFeeD(MREpisodeFeeID),27)
	s result = $lb(result)
	q result
}

/// 28 凝血因子类制品费(19)
/// Property F19NXYZF As %Float [ SqlColumnNumber = 28 ];
ClassMethod F19NXYZF(MrEpisodeID As %String) As %List
{
	s result = $lb("")
	q:(MrEpisodeID = "") result
	s MREpisodeFeeID = $o(^DHCEPRFS.INST.MREpisodeFeeI("IdxMREpisodeID"," "_MrEpisodeID,""))
	q:(MREpisodeFeeID = "") result
	s result = $lg(^DHCEPRFS.INST.MREpisodeFeeD(MREpisodeFeeID),28)
	s result = $lb(result)
	q result
}

/// 29 细胞因子类制品费(20)
/// Property F20XBYZF As %Float [ SqlColumnNumber = 29 ];
ClassMethod F20XBYZF(MrEpisodeID As %String) As %List
{
	s result = $lb("")
	q:(MrEpisodeID = "") result
	s MREpisodeFeeID = $o(^DHCEPRFS.INST.MREpisodeFeeI("IdxMREpisodeID"," "_MrEpisodeID,""))
	q:(MREpisodeFeeID = "") result
	s result = $lg(^DHCEPRFS.INST.MREpisodeFeeD(MREpisodeFeeID),29)
	s result = $lb(result)
	q result
}

/// 30 检查用一次性医用材料费(21)
/// Property F21JCYYCXCLF As %Float [ SqlColumnNumber = 30 ];
ClassMethod F21JCYYCXCLF(MrEpisodeID As %String) As %List
{
	s result = $lb("")
	q:(MrEpisodeID = "") result
	s MREpisodeFeeID = $o(^DHCEPRFS.INST.MREpisodeFeeI("IdxMREpisodeID"," "_MrEpisodeID,""))
	q:(MREpisodeFeeID = "") result
	s result = $lg(^DHCEPRFS.INST.MREpisodeFeeD(MREpisodeFeeID),30)
	s result = $lb(result)
	q result
}

/// 31 治疗用一次性医用材料费(22)
/// Property F22ZLYYCXCLF As %Float [ SqlColumnNumber = 31 ];
ClassMethod F22ZLYYCXCLF(MrEpisodeID As %String) As %List
{
	s result = $lb("")
	q:(MrEpisodeID = "") result
	s MREpisodeFeeID = $o(^DHCEPRFS.INST.MREpisodeFeeI("IdxMREpisodeID"," "_MrEpisodeID,""))
	q:(MREpisodeFeeID = "") result
	s result = $lg(^DHCEPRFS.INST.MREpisodeFeeD(MREpisodeFeeID),31)
	s result = $lb(result)
	q result
}

/// 32 手术用一次性医用材料费(23)
/// Property F23SSYYCXCLF As %Float [ SqlColumnNumber = 32 ];
ClassMethod F23SSYYCXCLF(MrEpisodeID As %String) As %List
{
	s result = $lb("")
	q:(MrEpisodeID = "") result
	s MREpisodeFeeID = $o(^DHCEPRFS.INST.MREpisodeFeeI("IdxMREpisodeID"," "_MrEpisodeID,""))
	q:(MREpisodeFeeID = "") result
	s result = $lg(^DHCEPRFS.INST.MREpisodeFeeD(MREpisodeFeeID),32)
	s result = $lb(result)
	q result
}

/// 33 其他费(24)
/// Property F24QTF As %Float [ SqlColumnNumber = 33 ];
ClassMethod F24QTF(MrEpisodeID As %String) As %List
{
	s result = $lb("")
	q:(MrEpisodeID = "") result
	s MREpisodeFeeID = $o(^DHCEPRFS.INST.MREpisodeFeeI("IdxMREpisodeID"," "_MrEpisodeID,""))
	q:(MREpisodeFeeID = "") result
	s result = $lg(^DHCEPRFS.INST.MREpisodeFeeD(MREpisodeFeeID),33)
	s result = $lb(result)
	q result
}

/// 34 临床物理治疗费(09-01)
/// Property F0901LCWLZLF As %Float [ SqlColumnNumber = 34 ];
ClassMethod F0901LCWLZLF(MrEpisodeID As %String) As %List
{
	s result = $lb("")
	q:(MrEpisodeID = "") result
	s MREpisodeFeeID = $o(^DHCEPRFS.INST.MREpisodeFeeI("IdxMREpisodeID"," "_MrEpisodeID,""))
	q:(MREpisodeFeeID = "") result
	s result = $lg(^DHCEPRFS.INST.MREpisodeFeeD(MREpisodeFeeID),34)
	s result = $lb(result)
	q result
}

/// 35 麻醉费(10-01)
/// Property F1001MZF As %Float [ SqlColumnNumber = 35 ];
ClassMethod F1001MZF(MrEpisodeID As %String) As %List
{
	s result = $lb("")
	q:(MrEpisodeID = "") result
	s MREpisodeFeeID = $o(^DHCEPRFS.INST.MREpisodeFeeI("IdxMREpisodeID"," "_MrEpisodeID,""))
	q:(MREpisodeFeeID = "") result
	s result = $lg(^DHCEPRFS.INST.MREpisodeFeeD(MREpisodeFeeID),35)
	s result = $lb(result)
	q result
}

/// 36 手术费(10-02)
/// Property F1002SSF As %Float [ SqlColumnNumber = 36 ];
ClassMethod F1002SSF(MrEpisodeID As %String) As %List
{
	s result = $lb("")
	q:(MrEpisodeID = "") result
	s MREpisodeFeeID = $o(^DHCEPRFS.INST.MREpisodeFeeI("IdxMREpisodeID"," "_MrEpisodeID,""))
	q:(MREpisodeFeeID = "") result
	s result = $lg(^DHCEPRFS.INST.MREpisodeFeeD(MREpisodeFeeID),36)
	s result = $lb(result)
	q result
}

/// 37 抗菌药物费用(13-01)
/// Property F1301KJYWF
ClassMethod F1301KJYWF(MrEpisodeID As %String) As %List
{
	s result = $lb("")
	q:(MrEpisodeID = "") result
	s MREpisodeFeeID = $o(^DHCEPRFS.INST.MREpisodeFeeI("IdxMREpisodeID"," "_MrEpisodeID,""))
	q:(MREpisodeFeeID = "") result
	s result = $lg(^DHCEPRFS.INST.MREpisodeFeeD(MREpisodeFeeID),37)
	s result = $lb(result)
	q result
}

/// 59 入院途径代码，1-急诊，2-门诊，3-其他医疗机构转入，9-其他
/// Property InPatientWayCode
ClassMethod InPatientWayCode(MrEpisodeID As %String) As %List
{
	s result = $lb("")
	q:(MrEpisodeID = "") result
	s result = $lg($g(^DHCEPRFS.INST.MREpisodeD(MrEpisodeID)),60)
	s result = $lb(result)
	q result
}

/// 60 入院途径描述，1-急诊，2-门诊，3-其他医疗机构转入，9-其他
/// Property InPatientWayDesc
ClassMethod InPatientWayDesc(MrEpisodeID As %String) As %List
{
	s result = $lb("")
	q:(MrEpisodeID = "") result
	s result = $lg($g(^DHCEPRFS.INST.MREpisodeD(MrEpisodeID)),61)
	s result = $lb(result)
	q result
}

/// 是否特殊病历
/// Debug:w ##class(DHCEPRFS.BL.BLQueryClassMethod).IsAdvancedSecurity("1")
ClassMethod IsAdvancedSecurity(MrEpisodeID As %String) As %List
{
	s result = $lb("N")
	q:(MrEpisodeID = "") result
	s EpisodeID = $lg(^DHCEPRFS.INST.MREpisodeD(MrEpisodeID),4)
	q:(EpisodeID = "") result
	
	s rowID = ""
	s rowID = $o(^DHCEPRRBAC.META.ASecurityI("IdxUnique"," DHC", " "_EpisodeID,rowID))
	q:(rowID = "") result
	s result = $lb("Y")
	q result
}

/// 是否生成病历(通过MRVerItem条目判断)
/// Debug:w ##class(DHCEPRFS.BL.BLQueryClassMethod).IsCreated("1")
ClassMethod IsCreated(MrEpisodeID As %String) As %List
{
	s result = $lb("N")
	q:(MrEpisodeID = "") result
	s Version=""
	s Version=$o(^DHCEPRFS.INST.MRVersionI("IdxMain"," "_MrEpisodeID,Version),-1) //newest
	q:(Version = "") result
	s MRVersionID=$o(^DHCEPRFS.INST.MRVersionI("IdxMain"," "_MrEpisodeID,Version,""))
	q:(MRVersionID = "") result
	
	s VerMRItemID=""
	for {
		s VerMRItemID=$o(^DHCEPRFS.INST.MRVerItemI("IdxMain"," "_MRVersionID,VerMRItemID))
		q:(VerMRItemID="")
		s MRItemID=$tr(VerMRItemID," ","")
		s objMRItem=##class(DHCEPRFS.META.MRItem).%OpenId(MRItemID)
		if (objMRItem'="")
		{
			if (objMRItem.Type'="PS")	//为非“PS”的类型
			{
				s result = $lb("Y")
				q
			}
		}
	}
	q result
}

/// 是否扫描病历(通过MRVerItem条目判断)
/// Debug:w ##class(DHCEPRFS.BL.BLQueryClassMethod).IsScanned("120")
ClassMethod IsScanned(MrEpisodeID As %String) As %List
{
	s result = $lb("N")
	q:(MrEpisodeID = "") result
	s Version=""
	s Version=$o(^DHCEPRFS.INST.MRVersionI("IdxMain"," "_MrEpisodeID,Version),-1) //newest
	q:(Version = "") result
	s MRVersionID=$o(^DHCEPRFS.INST.MRVersionI("IdxMain"," "_MrEpisodeID,Version,""))
	q:(MRVersionID = "") result
	
	s VerMRItemID=""
	for {
		s VerMRItemID=$o(^DHCEPRFS.INST.MRVerItemI("IdxMain"," "_MRVersionID,VerMRItemID))
		q:(VerMRItemID="")
		s MRItemID=$tr(VerMRItemID," ","")
		s objMRItem=##class(DHCEPRFS.META.MRItem).%OpenId(MRItemID)
		if (objMRItem'="")
		{
			if (objMRItem.Type="PS")	//为非“PS”的类型
			{
				s result = $lb("Y")
				q
			}
		}
	}
	q result
}

/// 是否有PDF病历(通过MRVerItem条目判断)
/// Debug:w ##class(DHCEPRFS.BL.BLQueryClassMethod).IsHavePDF("120")
ClassMethod IsHavePDF(MrEpisodeID As %String) As %List
{
	s result = $lb("N")
	q:(MrEpisodeID = "") result
	s Version=""
	s Version=$o(^DHCEPRFS.INST.MRVersionI("IdxMain"," "_MrEpisodeID,Version),-1) //newest
	q:(Version = "") result
	s MRVersionID=$o(^DHCEPRFS.INST.MRVersionI("IdxMain"," "_MrEpisodeID,Version,""))
	q:(MRVersionID = "") result
	
	s VerMRItemID=$o(^DHCEPRFS.INST.MRVerItemI("IdxMain"," "_MRVersionID,""))
	if (VerMRItemID'="")
	{
		s result = $lb("Y")
	}

	q result
}

/// 编目者
/// Debug:w ##class(DHCEPRFS.BL.BLQueryClassMethod).CatalogOperator("949988")
ClassMethod CatalogOperator(MrEpisodeID As %String) As %List
{
	q ..GetLogActOperator(MrEpisodeID,"CATALOG")
}

/// 复核者
/// Debug:w ##class(DHCEPRFS.BL.BLQueryClassMethod).ReviewOperator("949988")
ClassMethod ReviewOperator(MrEpisodeID As %String) As %List
{
	q ..GetLogActOperator(MrEpisodeID,"REVIEW")
}

/// 扫描者
/// Debug:w ##class(DHCEPRFS.BL.BLQueryClassMethod).ScanOperator("949988")
ClassMethod ScanOperator(MrEpisodeID As %String) As %List
{
	q ..GetLogActOperator(MrEpisodeID,"SCAN")
}

/// 打印者
/// Debug:w ##class(DHCEPRFS.BL.BLQueryClassMethod).PrintOperator("949988")
ClassMethod PrintOperator(MrEpisodeID As %String) As %List
{
	q ..GetLogActOperator(MrEpisodeID,"PRINT")
}

/// 分类者
/// Debug:w ##class(DHCEPRFS.BL.BLQueryClassMethod).ArrangeOperator("949988")
ClassMethod ArrangeOperator(MrEpisodeID As %String) As %List
{
	q ..GetLogActOperator(MrEpisodeID,"ARRANGE")
}

/// 替换者
/// Debug:w ##class(DHCEPRFS.BL.BLQueryClassMethod).ReplaceOperator("949988")
ClassMethod ReplaceOperator(MrEpisodeID As %String) As %List
{
	q ..GetLogActOperator(MrEpisodeID,"REPLACE")
}

/// 获取日志操作员名称
/// Debug:w ##class(DHCEPRFS.BL.BLQueryClassMethod).GetLogActOperator("949988")
ClassMethod GetLogActOperator(MrEpisodeID As %String, ActionCode As %String) As %List
{
	s result = $lb("")
	q:(MrEpisodeID = "") result
	
	s rowID = $o(^DHCEPRFS.INST.MRLogI("IdxMain"," "_MrEpisodeID,""))
	q:(rowID = "") result
	s ActionUserCode=""
	s DetailNum=""
	for {
		s DetailNum=$o(^DHCEPRFS.INST.MRLogDetailI("IdxMain",rowID,DetailNum),-1)
		q:(DetailNum="")
		s childSub=$o(^DHCEPRFS.INST.MRLogDetailI("IdxMain",rowID,DetailNum,""))
		s objMRLogDetail=##class(DHCEPRFS.INST.MRLogDetail).%OpenId(rowID_"||"_childSub)

		if (objMRLogDetail.MRAction=ActionCode)
		{
			s ActionUserCode=objMRLogDetail.ActUserID
			if (ActionUserCode '= "")
			{   
				if ($p(ActionUserCode,"^",1) = "TEMP")
    			{
					s objUser = ##class(DHCEPRFS.META.QueryUser).%OpenId($p(ActionUserCode,"^",2))
					s result = $lb(objUser.UserName)     
				}
				else
				{
    				s ActionUserName = ##Class(DHCEPRFS.BL.HISInfo.BLHISInfo).GetUserName(ActionUserCode)
    				s result = $lb(ActionUserName)
				}	
			}
			q
		}
	}
	q result
}

/// 留观号
ClassMethod ObservedNo(MrEpisodeID As %String) As %List
{
	
	s result = $lb("")
	q:(MrEpisodeID = "") result
	s MrPatientID = $lg(^DHCEPRFS.INST.MREpisodeD(MrEpisodeID),2)
	q:(MrPatientID = "") result
	s result = $lg(^DHCEPRFS.INST.MRPatientD(MrPatientID),60)
	s result = $lb(result)
	q result
}

/// Desc: 损伤中毒
ClassMethod DPDiagnose(MrEpisodeID As %String) As %List
{
	s result = $lb("")
	q:(MrEpisodeID = "") result
	s obj=##class(DHCEPRFS.INST.MREpisode).%OpenId(MrEpisodeID)
	s result=##class(DHCEPRFS.BL.HISInfo.BLEpisodeFPInfo).GetDPDiagnose(obj.EpisodeID,"1")
	s result = $lb(result)
	q result
}

/// Desc: 损伤中毒描述
ClassMethod DPDiagnoseDesc(MrEpisodeID As %String) As %List
{
	s result = $lb("")
	q:(MrEpisodeID = "") result
	s obj=##class(DHCEPRFS.INST.MREpisode).%OpenId(MrEpisodeID)
	s result=##class(DHCEPRFS.BL.HISInfo.BLEpisodeFPInfo).GetDPDiagnose(obj.EpisodeID,"2")
	s result = $lb(result)
	q result
}

/// Desc:EMRMainDiagCode
ClassMethod EMRMainDiagCode(MrEpisodeID As %String) As %List
{
	s result = $lb("")
	q:(MrEpisodeID = "") result
	s MREpisodeFPID = $o(^DHCEPRFS.INST.MREpisodeFPI("IdxMrEpisodeID"," "_MrEpisodeID,""))
	q:(MREpisodeFPID = "") result
	s obj=##class(DHCEPRFS.INST.MREpisodeFP).%OpenId(MREpisodeFPID)
	s result = $lb(obj.EMRMainDiagCode) 
    q result
}

/// Desc:EMRMainDiagDesc
ClassMethod EMRMainDiagDesc(MrEpisodeID As %String) As %List
{
	s result = $lb("")
	q:(MrEpisodeID = "") result
	s MREpisodeFPID = $o(^DHCEPRFS.INST.MREpisodeFPI("IdxMrEpisodeID"," "_MrEpisodeID,""))
	q:(MREpisodeFPID = "") result
	s obj=##class(DHCEPRFS.INST.MREpisodeFP).%OpenId(MREpisodeFPID)
	s result = $lb(obj.EMRMainDiagDesc) 
    q result
}

/// Desc: MRItemName
/// Debug:w ##class(DHCEPRFS.BL.BLQueryClassMethod).MRItemName("1")
ClassMethod MRItemName(MrEpisodeID As %String) As %List
{
	s result = $lb("N")
	s retstr=""
	q:(MrEpisodeID = "") result
	s Version=""
	s Version=$o(^DHCEPRFS.INST.MRVersionI("IdxMain"," "_MrEpisodeID,Version),-1) //newest
	q:(Version = "") result
	s MRVersionID=$o(^DHCEPRFS.INST.MRVersionI("IdxMain"," "_MrEpisodeID,Version,""))
	q:(MRVersionID = "") result
	
	s VerMRItemID=""
	for {
		s VerMRItemID=$o(^DHCEPRFS.INST.MRVerItemI("IdxMain"," "_MRVersionID,VerMRItemID))
		q:(VerMRItemID="")
		s MRItemID=$tr(VerMRItemID," ","")
		s objMRItem=##class(DHCEPRFS.META.MRItem).%OpenId(MRItemID)
		if (retstr = "")
		{
			s retstr = objMRItem.Name
		}
		else
		{
			s retstr = retstr_"-"_objMRItem.Name
		}
	}
	s result = $lb(retstr) 
	q result
}

}
