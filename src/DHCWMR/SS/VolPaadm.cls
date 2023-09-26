/// 病案首页信息（病人基本信息+就诊信息）
Class DHCWMR.SS.VolPaadm Extends %Persistent [ ClassType = persistent, Not ProcedureBlock ]
{

Relationship Parref As DHCWMR.SS.Volume [ Cardinality = parent, Inverse = ChildPaadm ];

/// 病人基本信息
Property VPPatientID As %String(MAXLEN = 100, TRUNCATE = 1);

/// 就诊号
Property VPEpisodeID As %String(MAXLEN = 100, TRUNCATE = 1);

/// 历史就诊号/住院号
Property VPAdmNo As %String(MAXLEN = 100, TRUNCATE = 1);

/// 就诊状态（P预约/A在院/D出院）
Property VPAdmitStatus As %String(MAXLEN = 100, TRUNCATE = 1);

/// 患者姓名
Property VPPatName As %String(MAXLEN = 100, TRUNCATE = 1);

/// 姓名全拼/首拼
Property VPNameSpell As %String(MAXLEN = 100, TRUNCATE = 1);

/// 性别
Property VPSex As %String(MAXLEN = 100, TRUNCATE = 1);

/// 出生日期
Property VPBirthday As %Date;

/// 出生省市
Property VPBirthProvince As %String(MAXLEN = 100, TRUNCATE = 1);

/// 出生县
Property VPBirthCity As %String(MAXLEN = 100, TRUNCATE = 1);

/// 年龄
Property VPAge As %String(MAXLEN = 100, TRUNCATE = 1);

/// 婚姻状况
Property VPWedlock As %String(MAXLEN = 100, TRUNCATE = 1);

/// 职业
Property VPOccupation As %String(MAXLEN = 100, TRUNCATE = 1);

/// 户籍地址
Property VPRegAddress As %String(MAXLEN = 100, TRUNCATE = 1);

/// 户籍地址（省）
Property VPRegProvince As %String(MAXLEN = 100, TRUNCATE = 1);

/// 户籍地址（市）
Property VPRegCity As %String(MAXLEN = 100, TRUNCATE = 1);

/// 户籍地址（县）
Property VPRegCounty As %String(MAXLEN = 100, TRUNCATE = 1);

/// 户籍邮编
Property VPRegZip As %String(MAXLEN = 100, TRUNCATE = 1);

/// 民族
Property VPNation As %String(MAXLEN = 100, TRUNCATE = 1);

/// 国籍
Property VPNationality As %String(MAXLEN = 100, TRUNCATE = 1);

/// 证件类型
Property VPCardType As %String(MAXLEN = 100, TRUNCATE = 1);

/// 身份证号
Property VPIdentityCode As %String(MAXLEN = 100, TRUNCATE = 1);

/// 工作单位
Property VPCompany As %String(MAXLEN = 100, TRUNCATE = 1);

/// 工作单位电话
Property VPCompanyTel As %String(MAXLEN = 100, TRUNCATE = 1);

/// 工作单位邮编
Property VPCompanyZip As %String(MAXLEN = 100, TRUNCATE = 1);

/// 现住址
Property VPHomeAddress As %String(MAXLEN = 100, TRUNCATE = 1);

/// 现住址（省）
Property VPHomeProvince As %String(MAXLEN = 100, TRUNCATE = 1);

/// 现住址（市）
Property VPHomeCity As %String(MAXLEN = 100, TRUNCATE = 1);

/// 现住址（县）
Property VPHomeCounty As %String(MAXLEN = 100, TRUNCATE = 1);

/// 现住址电话
Property VPHomeTel As %String(MAXLEN = 100, TRUNCATE = 1);

/// 现住址邮编
Property VPHomeZip As %String(MAXLEN = 100, TRUNCATE = 1);

/// 与联系人关系(患者)
Property VPRelationDesc As %String(MAXLEN = 100, TRUNCATE = 1);

/// 联系人姓名
Property VPRelativeName As %String(MAXLEN = 100, TRUNCATE = 1);

/// 联系人电话
Property VPRelativeTel As %String(MAXLEN = 100, TRUNCATE = 1);

/// 联系人地址
Property VPRelativeAddress As %String(MAXLEN = 100, TRUNCATE = 1);

/// 入院日期
Property VPAdmitDate As %Date;

/// 入院时间
Property VPAdmitTime As %Time;

/// 入院科室
Property VPAdmitDept As %String(MAXLEN = 100, TRUNCATE = 1);

/// 入院科室名称
Property VPAdmitDeptDesc As %String(MAXLEN = 500, TRUNCATE = 1);

/// 入院病区
Property VPAdmitWard As %String(MAXLEN = 100, TRUNCATE = 1);

/// 入院病区名称
Property VPAdmitWardDesc As %String(MAXLEN = 500, TRUNCATE = 1);

/// 入院诊断
Property VPAdmitDiagnos As %String(MAXLEN = 100, TRUNCATE = 1);

/// 医疗结算日期
Property VPEstimDischDate As %Date;

/// 医疗结算时间
Property VPEstimDischTime As %Time;

/// 最终结算日期
Property VPDischDate As %Date;

/// 最终结算时间
Property VPDischTime As %Time;

/// 出院科室
Property VPDischDept As %String(MAXLEN = 100, TRUNCATE = 1);

/// 出院科室名称
Property VPDischDeptDesc As %String(MAXLEN = 500, TRUNCATE = 1);

/// 出院病区
Property VPDischWard As %String(MAXLEN = 100, TRUNCATE = 1);

/// 出院病区名称
Property VPDischWardDesc As %String(MAXLEN = 500, TRUNCATE = 1);

/// 出院床位
Property VPDischBed As %String(MAXLEN = 100, TRUNCATE = 1);

/// 出院床位名称
Property VPDischBedDesc As %String(MAXLEN = 500, TRUNCATE = 1);

/// 出院诊断
Property VPDischDiagnos As %String(MAXLEN = 100, TRUNCATE = 1);

/// 是否死亡
Property VPIsDeath As %Boolean;

/// 死亡日期
Property VPDeathDate As %Date;

/// 死亡时间
Property VPDeathTime As %Time;

/// 曾经用病案号（多值#分隔）
Property VPMrNos As %String(MAXLEN = 100, TRUNCATE = 1);

/// 男方姓名(门诊病案)
Property VPManName As %String(MAXLEN = 100, TRUNCATE = 1);

/// EpisodeID索引
Index IndexEpisodeID On (VPEpisodeID, Parref);

/// AdmNo索引
Index IndexAdmNo On (VPAdmNo, Parref);

/// PatientID索引
Index IndexPatientID On (VPPatientID, Parref);

/// 患者姓名索引 Add By LiYang 2014-09-06
Index IndexPatName On VPPatName;

/// 拼音索引 Add By LiYang 2014-09-06
Index IndexNameSpell On VPNameSpell;

/// 身份者号码索引 Add By LiYang 2014-09-06
Index IndexIdentityCode On VPIdentityCode;

/// 联系人姓名索引 Add By LiYang 2014-09-06
Index IndexRelativeName On VPRelativeName;

/// Creator：     liyi
/// CreatDate：   2015-03-29
/// Description:  门诊病案关联多次就诊方法
///               门诊病案只建一个病案卷，所有就诊都关联到此病案卷下
///               同一患者多个登记号的就诊信息，也可以关联到同一卷下
/// Table:        DHCWMR.SS.VolPaadm
/// Input:        VolumeID : DHCWMR.SS.Volume.ID
/// 			  EpisodeID : 就诊号
/// Return：      return>0:成功  return<=0:失败
/// w ##class(DHCWMR.SS.VolPaadm).RsAssociatCard()
ClassMethod RsAssociatCard(aVolumeID As %String, aEpisodeID As %String)
{
	New (aEpisodeID,aVolumeID)
	Set return=0
	Quit:(aEpisodeID="")||(aVolumeID="") return
	
	Set objVol = ##class(DHCWMR.SS.Volume).GetObjById(aVolumeID)
	Quit:'$IsObject(objVol) return
	Quit:objVol.SVIsActive'=1 return
	Quit:'$IsObject(objVol.SVMainDr) return
	Quit:objVol.SVMainDr.SMIsActive'=1 return
	
	Set return=##class(DHCWMR.SS.VolPaadm).Update(aVolumeID,aEpisodeID)
	Quit return
}

/// Creator：     liyi
/// CreatDate：   2015-03-29
/// Description:  通过卷ID更新门诊病案男方姓名
/// Table:        DHCWMR.SS.VolPaadm
/// Input:        VolumeID : DHCWMR.SS.Volume.ID
/// 			  ManName : 男方姓名
/// Return：      return>0:成功  return<=0:失败
/// w ##Class(DHCWMR.SS.VolPaadm).UpdateManNameByVol()
ClassMethod UpdateManNameByVol(aVolumeID As %String, aManName As %String)
{
	New (aManName,aVolumeID)
	Set return = 0
	Quit:aVolumeID="" return
	
	Set objVol=##Class(DHCWMR.SS.Volume).GetObjById(aVolumeID)
	Quit:'$IsObject(objVol) return
	
	For indAdm=1:1:objVol.ChildPaadm.Count() {
		Set objVolPaadm=objVol.ChildPaadm.GetAt(indAdm)
		Continue:'$IsObject(objVolPaadm)
		Set VolPaadmID = objVolPaadm.%Id()
		
		Set flg=..UpdateManName(VolPaadmID,aManName)
		If (+flg)<0 {
			Set return=-1
		}
	}
	Quit:return<0 return
	
	Set return=1
	Quit return
}

/// Creator：     liyi
/// CreatDate：   2015-03-29
/// Description:  更新门诊病案男方姓名
/// Table:        DHCWMR.SS.VolPaadm
/// Input:        VolPaadmID : DHCWMR.SS.VolPaadm.ID
/// 			  ManName : 男方姓名
/// Return：      return>0:成功  return<=0:失败
/// w ##Class(DHCWMR.SS.VolPaadm).UpdateManName()
ClassMethod UpdateManName(aVolPaadmID As %String, aManName As %String)
{
	New (aVolPaadmID,aManName)
	Set return = 0
	Quit:(aVolPaadmID="") return
	
	Set obj=##Class(DHCWMR.SS.VolPaadm).%OpenId(aVolPaadmID)
	Quit:'$IsObject(obj) return
	
	Set obj.VPManName = aManName
	Set sc=obj.%Save()
	If $System.Status.IsError(sc) {  //检查Save是否成功
   		Do $System.OBJ.DisplayError(sc)
   		Set return=-1
	} Else {
		Set return=obj.%Id()
	}
	Quit return
}

/// Creator：     liyi
/// CreatDate：   2014-08-29
/// Description:  根据ID取病案首页信息信息
/// Table:        DHCWMR.SS.VolPaadm
/// Input:        Id : DHCWMR.SS.VolPaadm.ID
/// Output:       返回Object
/// w ##Class(DHCWMR.SS.VolPaadm).GetObjById(21)
ClassMethod GetObjById(aId As %String) As DHCWMR.SS.VolPaadm
{
	new (aId)
	quit:'##class(DHCWMR.SS.VolPaadm).%ExistsId(aId) ""
	set obj=##Class(DHCWMR.SS.VolPaadm).%OpenId(aId)
	do:obj'="" obj.%Close()
	quit obj
}

/// Creator：     liyi
/// CreatDate：   2015-04-01
/// Description:  根据登记ID获取男方姓名
/// Table:        DHCWMR.SS.VolPaadm
/// Input:        PatientID：就诊ID
/// 			  MrTypeID:DHCWMR.SS.MrType.ID
/// Output:       返回ManName
/// w ##Class(DHCWMR.SS.VolPaadm).GetManNameByPatID()
ClassMethod GetManNameByPatID(aPatientID As %String, aMrTypeID As %String)
{
	New (aMrTypeID,aPatientID)
	Set return=""
	Quit:(aMrTypeID="")||(aPatientID="") return
	
	Set xVolID=0
	For {
		Set xVolID=$o(^DHCWMR.SS.VolumeI("VP","IndexPatientID"," "_aPatientID,xVolID))
		Quit:xVolID=""
		Quit:return'=""
		
		Set objVol=##class(DHCWMR.SS.Volume).GetObjById(xVolID)
		Continue:'$IsObject(objVol)
		Continue:objVol.SVIsActive'=1
		Continue:'$IsObject(objVol.SVMainDr)
		Continue:objVol.SVMainDr.SMIsActive'=1
		Continue:((aMrTypeID'="")&&(aMrTypeID'=objVol.SVMainDr.SMMrType.%Id()))
	
		Set xSubID=$o(^DHCWMR.SS.VolumeI("VP","IndexPatientID"," "_aPatientID,xVolID,0))
		Continue:xSubID=""
		Set objVolPaadm=##class(DHCWMR.SS.VolPaadm).GetObjById(xVolID_"||"_xSubID)
		Continue:'$IsObject(objVolPaadm)
		Set return=objVolPaadm.VPManName
	}
	
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2015-04-24
/// Description:  根据卷ID取卷就诊信息
/// Table:        DHCWMR.SS.VolPaadm
/// Input:        VolID : 就诊号
/// Output:       返回String（ID，就诊号，当前科室，当前病区，院区）
/// w ##Class(DHCWMR.SS.VolPaadm).GetAdmStrByVol(1)
ClassMethod GetAdmStrByVol(aVolID As %String) As %String
{
	New (aVolID)
	Set return=""
	Quit:aVolID="" return
	
	Kill arrPaadmList
	Set xSub=""
	For {
		Set xSub=$o(^DHCWMR.SS.VolumeD(aVolID,"P",xSub),-1)
		Quit:xSub=""
		
		Set VolPaadmID=aVolID_"||"_xSub
		Set objVolPaadm=##Class(DHCWMR.SS.VolPaadm).GetObjById(VolPaadmID)
		Continue:'$IsObject(objVolPaadm)
		Set EpisodeID=objVolPaadm.VPEpisodeID
		Set AdmitDept=objVolPaadm.VPAdmitDept
		Set AdmitWard=objVolPaadm.VPAdmitWard
		Set DischDept=objVolPaadm.VPDischDept
		Set:DischDept'="" AdmitDept=DischDept
		Set DischWard=objVolPaadm.VPDischWard
		Set:DischWard'="" AdmitWard=DischWard
		Set AdmHospID=##class(DHCWMR.SSService.HospitalSrv).GetCTHospID(AdmitDept)
		If EpisodeID="" {
			Set AdmNo=objVolPaadm.VPAdmNo
			Set:AdmNo="" AdmNo="H"_VolPaadmID
			Set arrPaadmList(0,AdmNo)=VolPaadmID_","_EpisodeID_","_AdmitDept_","_AdmitWard_","_DischDept_","_DischWard_","_AdmHospID
		} Else {
			Continue:$p($g(^PAADM(EpisodeID)),"^",20)="C"  //取消就诊
			Set tmpAdmitDept=$p($g(^PAADM(+EpisodeID)),"^",4)
			Set tmpAdmitWard=$p($g(^PAADM(+EpisodeID)),"^",70)
			Set tmpAdmitWard=$p($g(^PAWARD(+tmpAdmitWard)),"^",5)
			Set:tmpAdmitDept'="" AdmitDept=tmpAdmitDept
			Set:tmpAdmitWard'="" AdmitWard=tmpAdmitWard
			Set arrPaadmList(1,EpisodeID)=VolPaadmID_","_EpisodeID_","_AdmitDept_","_AdmitWard_","_AdmHospID
		}
	}
	If $o(arrPaadmList(1,""),-1)="" {
		Set AdmIndex=$o(arrPaadmList(0,""),-1)
		Quit:AdmIndex="" return
		Set return=$g(arrPaadmList(0,AdmIndex))
	} Else {
		Set AdmIndex=$o(arrPaadmList(1,""),-1)
		Quit:AdmIndex="" return
		Set return=$g(arrPaadmList(1,AdmIndex))
	}
	Kill arrPaadmList
	Quit return
}

/// Creator：     liyi
/// CreatDate：   2014-09-09
/// Description:  根据EpisodeID获取病案首页信息
/// Table:        DHCWMR.SS.VolPaadm
/// Input:        EpisodeID : 就诊号  Pa_Adm.ID
///               VolAdmID : 卷就诊ID
/// Output:       返回Object
/// w ##Class(DHCWMR.SS.VolPaadm).GetPatObjByAdm(283)
ClassMethod GetPatObjByAdm(aEpisodeID As %String, aAdmNo As %String, aVolAdmID As %String) As DHCWMR.SS.VolPaadm
{
	New (aEpisodeID,aAdmNo,aVolAdmID)
	Set return=""
	Quit:(aEpisodeID="")&&(aAdmNo="")&&(aVolAdmID="") return
	
	Set objPatient=""
	If aVolAdmID'="" {
		Set objPatient=..GetObjById(aVolAdmID)
	} ElseIf aEpisodeID'="" {
		Set xVolID=0
		For {
			Set xVolID=$o(^DHCWMR.SS.VolumeI("VP","IndexEpisodeID"," "_aEpisodeID,xVolID))
			Quit:xVolID=""
			
			Set xSubID=$o(^DHCWMR.SS.VolumeI("VP","IndexEpisodeID"," "_aEpisodeID,xVolID,0))
			Continue:xSubID=""
			Set objVolPaadm=..GetObjById(xVolID_"||"_xSubID)
			Continue:'$IsObject(objVolPaadm)
			Set objVol=objVolPaadm.Parref
			Continue:objVol.SVIsActive'=1
			Continue:'$IsObject(objVol.SVMainDr)
			Continue:objVol.SVMainDr.SMIsActive'=1
			
			Set objPatient=objVolPaadm
			Quit //取到对应结果即退出循环
		}
	} ElseIf aAdmNo'="" {
		Set xVolID=0
		For {
			Set xVolID=$o(^DHCWMR.SS.VolumeI("VP","IndexAdmNo"," "_aAdmNo,xVolID))
			Quit:xVolID=""
			
			Set xSubID=$o(^DHCWMR.SS.VolumeI("VP","IndexAdmNo"," "_aAdmNo,xVolID,0))
			Continue:xSubID=""
			Set objVolPaadm=..GetObjById(xVolID_"||"_xSubID)
			Continue:'$IsObject(objVolPaadm)
			Set objVol=objVolPaadm.Parref
			Continue:objVol.SVIsActive'=1
			Continue:'$IsObject(objVol.SVMainDr)
			Continue:objVol.SVMainDr.SMIsActive'=1
			
			Set objPatient=objVolPaadm
			Quit //取到对应结果即退出循环
		}
	}
	
	Set return=objPatient
	Set EpisodeID=objPatient.VPEpisodeID
	Set PatientID=objPatient.VPPatientID
	Set:EpisodeID'="" PatientID=$p($g(^PAADM(EpisodeID)),"^",1)
	Quit:PatientID="" return
	
	//update by mxp 20160427 病案状态查询、病案查找 不足一天的病人取年龄为‘0分’
	if EpisodeID'="" {
		Set tmpDateTime=##Class(DHCWMR.IO.FromAdmSrv).GetAdmDateTime(EpisodeID)
		Set AdmitDate=$p(tmpDateTime,"^",1)
		Set:AdmitDate["-" AdmitDate=$zdh(AdmitDate,3)
		Set AdmitTime=$p(tmpDateTime,"^",2)
		Set:AdmitTime[":" AdmitTime=$zth(AdmitTime,1)
		Set Age=##class(DHCWMR.IO.FromHisSrv).GetPapmiAge(PatientID,EpisodeID,AdmitDate,AdmitTime)
		Set objPatient.VPAge=Age
	}
	
	Quit:$IsObject(objPatient) objPatient
	
	Set PatName=$p($g(^PAPER(PatientID,"ALL")),"^",1)
	Set NameSpell=$p($g(^PAPER(PatientID,"ALL")),"^",2)
	Set SexID=$p($g(^PAPER(PatientID,"ALL")),"^",7)
	Set SexDesc=""
	Set:SexID'="" SexDesc=$p($g(^CT("SEX",SexID)),"^",2)
	Set Birthday=$p($g(^PAPER(PatientID,"ALL")),"^",6)
	Set MaritalID=$p($g(^PAPER(PatientID,"PER",2)),"^",3)
    Set MaritalDesc=""
    Set:MaritalID'="" MaritalDesc=$p(^CT("MAR",+MaritalID),"^",2)
	Set NationID=$p($g(^PAPER(PatientID,"PER",2)),"^",1)
	Set NationDesc=""
	Set:NationID'="" NationDesc=$p(^CT("NAT",+NationID),"^",2)
	Set:NationDesc["-" NationDesc=$p(NationDesc,"-",2)
	Set CountryID=$p($g(^PAPER(PatientID,"PER",1)),"^",8)
    Set CountryDesc=""
    Set:CountryID'="" CountryDesc=$p(^CT("COU",+CountryID),"^",2)
    Set PersonalID=$p($g(^PAPER(PatientID,"ALL")),"^",9)
    Set Company=$p($g(^PAPER(PatientID,"PER",4)),"^",18)
    Set Telephone=$p($g(^PAPER(PatientID,"PER",1)),"^",11)
    Set RelationID=$p($g(^PAPER(PatientID,"EMP")),"^",4)
    Set RelationDesc=""
    Set:RelationID'="" RelationDesc=$p($g(^CT("RLT",RelationID)),"^",2)
    Set RelativeName=$p($g(^PAPER(PatientID,"PER",2)),"^",13)
    Set RelativeTel=$p($g(^PAPER(PatientID,"ALL")),"^",4)
	Set RelativeAddress=$p($g(^PAPER(PatientID,"PER",1)),"^",1)
    
	Set RegAddress="",RegProvinceDesc="",RegCityDesc="",RegCountyDesc=""
	Set DHCPersonID=$o(^DHCPERSON(0,"PAPERSON",PatientID,0))
	If DHCPersonID'="" {
		Set RegAddress=$p($g(^DHCPERSON(DHCPersonID)),"^",16)
		Set RegProvinceDr=$p($g(^DHCPERSON(DHCPersonID)),"^",17)
		Set:RegProvinceDr'="" RegProvinceDesc=$p($g(^CT("PROV",RegProvinceDr)),"^",2)
		Set:$p(RegProvinceDesc,"-",2)'="" RegProvinceDesc=$p(RegProvinceDesc,"-",2)
		Set RegCityDr=$p($g(^DHCPERSON(DHCPersonID)),"^",18)
		Set:RegCityDr'="" RegCityDesc=$p($g(^CT("CIT",RegCityDr)),"^",2)
		Set:$p(RegCityDesc,"-",2)'="" RegCityDesc=$p(RegCityDesc,"-",2)
		Set RegCountyDr=$p($g(^DHCPERSON(DHCPersonID)),"^",19)
		Set:RegCountyDr'="" RegCountyDesc=$p($g(^CT("CITAREA",RegCountyDr)),"^",2)
		Set:$p(RegCountyDesc,"-",2)'="" RegCountyDesc=$p(RegCountyDesc,"-",2)
		Set RegVillage=$p($g(^DHCPERSON(DHCPersonID)),"^",20)
		If RegAddress="" {
			Set:RegProvinceDesc'="" RegAddress=RegAddress_RegProvinceDesc
			Set:RegCityDesc'="" RegAddress=RegAddress_RegCityDesc
			Set:RegCountyDesc'="" RegAddress=RegAddress_RegCountyDesc
			Set:RegVillage'="" RegAddress=RegAddress_RegVillage
		}
	}
	
	Set HomeAddress="",HomeProvinceDesc="",HomeCityDesc="",HomeCountyDesc=""
	Set HomeAddress=$p($g(^PAPER(PatientID,"PER","ADD",1)),"^",1)
	Set HomeProvinceDr=$p($g(^PAPER(PatientID,"PER",4)),"^",2)
	Set:HomeProvinceDr'="" HomeProvinceDesc=$p(^CT("PROV",HomeProvinceDr),"^",2)
	Set:$p(HomeProvinceDesc,"-",2)'="" HomeProvinceDesc=$p(HomeProvinceDesc,"-",2)
	Set HomeCityDr=$p($g(^PAPER(PatientID,"PER",1)),"^",5)
	Set:HomeCityDr'="" HomeCityDesc=$p($g(^CT("CIT",HomeCityDr)),"^",2)
	Set:$p(HomeCityDesc,"-",2)'="" HomeCityDesc=$p(HomeCityDesc,"-",2)
	Set HomeCountyDr=$p($g(^PAPER(PatientID,"PER",4)),"^",9)
	Set:HomeCountyDr'="" HomeCountyDesc=$p(^CT("CITAREA",HomeCountyDr),"^",2)
	Set:$p(HomeCountyDesc,"-",2)'="" HomeCountyDesc=$p(HomeCountyDesc,"-",2)
	Set HomeVillage=$g(^PAPER(PatientID,"PER","ADD"))
	If HomeAddress="" {
		Set:HomeProvinceDesc'="" HomeAddress=HomeAddress_HomeProvinceDesc
		Set:HomeCityDesc'="" HomeAddress=HomeAddress_HomeCityDesc
		Set:HomeCountyDesc'="" HomeAddress=HomeAddress_HomeCountyDesc
		Set:HomeVillage'="" HomeAddress=HomeAddress_HomeVillage
	}
	
	Set objPatient.VPPatName         = PatName
	Set objPatient.VPNameSpell       = NameSpell
	Set objPatient.VPSex             = SexDesc
	Set objPatient.VPBirthday        = Birthday
	Set objPatient.VPWedlock         = MaritalDesc
	Set objPatient.VPOccupation      = ""
	Set objPatient.VPNation          = NationDesc
	Set objPatient.VPNationality     = CountryDesc
	Set objPatient.VPIdentityCode    = PersonalID
	Set objPatient.VPCompany         = Company
	Set objPatient.VPCompanyTel      = ""
	Set objPatient.VPCompanyZip      = ""
	Set objPatient.VPRegAddress      = RegAddress
	Set objPatient.VPRegProvince     = RegProvinceDesc
	Set objPatient.VPRegCity         = RegCityDesc
	Set objPatient.VPRegCounty       = RegCountyDesc
	Set objPatient.VPHomeTel         = Telephone
	Set objPatient.VPHomeZip         = ""
	Set objPatient.VPHomeAddress     = HomeAddress
	Set objPatient.VPHomeProvince    = HomeProvinceDesc
	Set objPatient.VPHomeCity        = HomeCityDesc
	Set objPatient.VPHomeCounty      = HomeCountyDesc
	Set objPatient.VPRelationDesc    = RelationDesc
	Set objPatient.VPRelativeName    = RelativeName
	Set objPatient.VPRelativeTel     = RelativeTel
	Set objPatient.VPRelativeAddress = RelativeAddress
	//modify by liyi fix 116607
	//Set Age=##class(DHCWMR.IO.FromHisSrv).GetPapmiAge(PatientID,EpisodeID,"","")
	//Set objPatient.VPAge=Age
	If EpisodeID="" {
		Set return=objPatient
		Quit return
	}
	
	Set VisitStatus=$p($g(^PAADM(EpisodeID)),"^",20)
	//Set tmpDateTime=##Class(DHCWMR.SSService.CommonSrv).GetAdmitDate(EpisodeID)
	
	Set tmpDeptWard=##Class(DHCWMR.SSService.CommonSrv).GetAdmitDept(EpisodeID)
	Set AdmitDept=$p(tmpDeptWard,",",1)
	Set AdmitDeptDesc=""
	Set:AdmitDept'="" AdmitDeptDesc=$p($g(^CTLOC(+AdmitDept)),"^",2)
	Set AdmitWard=$p(tmpDeptWard,",",2)
	Set AdmitWardDesc=""
	Set:AdmitWard'="" AdmitWardDesc=$p($g(^CTLOC(+AdmitWard)),"^",2)
	Set AdmitBed=$p(tmpDeptWard,",",3)
	Set AdmitBedDesc=""
	Set:AdmitBed'="" AdmitBedDesc=$p($g(^PAWARD(+AdmitBed,"BED",+$p(AdmitBed,"||",2))),"^",1)
	Set AdmitDiagnos=##Class(DHCWMR.SSService.CommonSrv).GetAdmitDiagnos(EpisodeID)
	Set tmpDateTime=##Class(DHCWMR.IO.FromAdmSrv).GetDischDateTime(EpisodeID)
	Set DischDate=$p(tmpDateTime,"^",1)
	Set:DischDate["-" DischDate=$zdh(DischDate,3)
	Set DischTime=$p(tmpDateTime,"^",2)
	Set:DischTime[":" DischTime=$zth(DischTime,1)
	Set tmpDateTime=##Class(DHCWMR.SSService.CommonSrv).GetEstimDischDate(EpisodeID)
	Set EstimDischDate=$p(tmpDateTime," ",1)
	;Set:EstimDischDate["-" EstimDischDate=$zdh(EstimDischDate,3)
	Set:EstimDischDate'="" EstimDischDate=##Class(DHCWMR.SSService.CommonSrv).DateHtmlToLogical(EstimDischDate)
	Set EstimDischTime=$p(tmpDateTime," ",2)
	Set:EstimDischTime[":" EstimDischTime=$zth(EstimDischTime,1)
	Set tmpDeptWard=##Class(DHCWMR.SSService.CommonSrv).GetDischDept(EpisodeID)
	Set DischDept=$p(tmpDeptWard,",",1)
	Set DischDeptDesc=""
	Set:DischDept'="" DischDeptDesc=$p($g(^CTLOC(+DischDept)),"^",2)
	Set DischWard=$p(tmpDeptWard,",",2)
	Set DischWardDesc=""
	Set:DischWard'="" DischWardDesc=$p($g(^CTLOC(+DischWard)),"^",2)
	Set DischBed=$p(tmpDeptWard,",",3)
	Set DischBedDesc=""
	Set:DischBed'="" DischBedDesc=$p($g(^PAWARD(+DischBed,"BED",+$p(DischBed,"||",2))),"^",1)
	Set DischDiagnos=##Class(DHCWMR.SSService.CommonSrv).GetDischDiagnos(EpisodeID)
	Set tmpDateTime=##Class(DHCWMR.SSService.CommonSrv).GetDeathDate(EpisodeID)
	Set DeathDate=$p(tmpDateTime," ",1)
	Set:DeathDate["-" DeathDate=$zdh(DeathDate,3)
	Set DeathTime=$p(tmpDateTime," ",2)
	Set:DeathTime[":" DeathTime=$zth(DeathTime,1)
	Set IsDeath=0
	Set:DeathDate'="" IsDeath=1
	
	Set objPatient.VPAdmitStatus     = VisitStatus
	Set objPatient.VPAdmitDate       = AdmitDate
	Set objPatient.VPAdmitTime       = AdmitTime
	Set objPatient.VPAdmitDept       = AdmitDept
	Set objPatient.VPAdmitDeptDesc   = AdmitDeptDesc
	Set objPatient.VPAdmitWard       = AdmitWard
	Set objPatient.VPAdmitWardDesc   = AdmitWardDesc
	Set objPatient.VPAdmitDiagnos    = AdmitDiagnos
	Set objPatient.VPEstimDischDate  = EstimDischDate
	Set objPatient.VPEstimDischTime  = EstimDischTime
	Set objPatient.VPDischDate       = DischDate
	Set objPatient.VPDischTime       = DischTime
	Set objPatient.VPDischDept       = DischDept
	Set objPatient.VPDischDeptDesc   = DischDeptDesc
	Set objPatient.VPDischWard       = DischWard
	Set objPatient.VPDischWardDesc   = DischWardDesc
	Set objPatient.VPDischBed        = DischBed
	Set objPatient.VPDischBedDesc    = DischBedDesc
	Set objPatient.VPDischDiagnos    = DischDiagnos
	Set objPatient.VPIsDeath         = IsDeath
	Set objPatient.VPDeathDate       = DeathDate
	Set objPatient.VPDeathTime       = DeathTime
	Set return=objPatient
	Quit return
}

/// Creator：     liyi
/// CreatDate：   2014-08-29
/// Description:  更新【病案首页信息】
/// Table：       DHCWMR.SS.VolPaadm
/// Input：       VolumeID ：卷ID
///               EpisodeID : 就诊号
/// Return：      返回新纪录的%Id()值
/// w ##class(DHCWMR.SS.VolPaadm).Update(1,86)
ClassMethod Update(aVolumeID As %String, aEpisodeID As %String) As %String
{
	New (aVolumeID,aEpisodeID)
	Set return=0
	Quit:(aVolumeID="")||(aEpisodeID="") return
	
	Set $ZT="UpdateVolPaadmErr"
	
	Quit:'$d(^PAADM(aEpisodeID)) return
	Set PatientID=$p($g(^PAADM(aEpisodeID)),"^",1)
	Quit:PatientID="" return
	
	Set objVol=##Class(DHCWMR.SS.Volume).GetObjById(aVolumeID)
	Quit:'$IsObject(objVol) return
	
	Set VolPaadmID=""
	Set xSub=$o(^DHCWMR.SS.VolumeI("VP","IndexEpisodeID"," "_aEpisodeID,aVolumeID,""))
	Set:xSub'="" VolPaadmID=aVolumeID_"||"_xSub
	
	If VolPaadmID="" {
		Set obj=##Class(DHCWMR.SS.VolPaadm).%New()
	} Else {
		Set obj=##Class(DHCWMR.SS.VolPaadm).%OpenId(VolPaadmID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.Parref			  = objVol
	Set obj.VPPatientID       = PatientID
	Set obj.VPEpisodeID       = aEpisodeID
	
	Set EpisodeID=aEpisodeID
	Set PatName=$p($g(^PAPER(PatientID,"ALL")),"^",1)
	Set NameSpell=$p($g(^PAPER(PatientID,"ALL")),"^",2)
	Set SexID=$p($g(^PAPER(PatientID,"ALL")),"^",7)
	Set SexDesc=""
	Set:SexID'="" SexDesc=$p($g(^CT("SEX",SexID)),"^",2)
	Set Birthday=$p($g(^PAPER(PatientID,"ALL")),"^",6)
	Set MaritalID=$p($g(^PAPER(PatientID,"PER",2)),"^",3)
    Set MaritalDesc=""
    Set:MaritalID'="" MaritalDesc=$p(^CT("MAR",+MaritalID),"^",2)
	Set NationID=$p($g(^PAPER(PatientID,"PER",2)),"^",1)
	Set NationDesc=""
	Set:NationID'="" NationDesc=$p(^CT("NAT",+NationID),"^",2)
	Set:NationDesc["-" NationDesc=$p(NationDesc,"-",2)
	Set CountryID=$p($g(^PAPER(PatientID,"PER",1)),"^",8)
    Set CountryDesc=""
    Set:CountryID'="" CountryDesc=$p(^CT("COU",+CountryID),"^",2)
    Set PersonalID=$p($g(^PAPER(PatientID,"ALL")),"^",9)
    Set Company=$p($g(^PAPER(PatientID,"PER",4)),"^",18)
    Set Telephone=$p($g(^PAPER(PatientID,"PER",1)),"^",11)
    Set RelationID=$p($g(^PAPER(PatientID,"EMP")),"^",4)
    Set RelationDesc=""
    Set:RelationID'="" RelationDesc=$p($g(^CT("RLT",RelationID)),"^",2)
    Set RelativeName=$p($g(^PAPER(PatientID,"PER",2)),"^",13)
    Set RelativeTel=$p($g(^PAPER(PatientID,"ALL")),"^",4)
	Set RelativeAddress=$p($g(^PAPER(PatientID,"PER",1)),"^",1)
    
	Set RegAddress="",RegProvinceDesc="",RegCityDesc="",RegCountyDesc=""
	Set DHCPersonID=$o(^DHCPERSON(0,"PAPERSON",PatientID,0))
	If DHCPersonID'="" {
		Set RegAddress=$p($g(^DHCPERSON(DHCPersonID)),"^",16)
		Set RegProvinceDr=$p($g(^DHCPERSON(DHCPersonID)),"^",17)
		Set:RegProvinceDr'="" RegProvinceDesc=$p($g(^CT("PROV",RegProvinceDr)),"^",2)
		Set:$p(RegProvinceDesc,"-",2)'="" RegProvinceDesc=$p(RegProvinceDesc,"-",2)
		Set RegCityDr=$p($g(^DHCPERSON(DHCPersonID)),"^",18)
		Set:RegCityDr'="" RegCityDesc=$p($g(^CT("CIT",RegCityDr)),"^",2)
		Set:$p(RegCityDesc,"-",2)'="" RegCityDesc=$p(RegCityDesc,"-",2)
		Set RegCountyDr=$p($g(^DHCPERSON(DHCPersonID)),"^",19)
		Set:RegCountyDr'="" RegCountyDesc=$p($g(^CT("CITAREA",RegCountyDr)),"^",2)
		Set:$p(RegCountyDesc,"-",2)'="" RegCountyDesc=$p(RegCountyDesc,"-",2)
		Set RegVillage=$p($g(^DHCPERSON(DHCPersonID)),"^",20)
		If RegAddress="" {
			Set:RegProvinceDesc'="" RegAddress=RegAddress_RegProvinceDesc
			Set:RegCityDesc'="" RegAddress=RegAddress_RegCityDesc
			Set:RegCountyDesc'="" RegAddress=RegAddress_RegCountyDesc
			Set:RegVillage'="" RegAddress=RegAddress_RegVillage
		}
	}
	
	Set HomeAddress="",HomeProvinceDesc="",HomeCityDesc="",HomeCountyDesc=""
	Set HomeAddress=$p($g(^PAPER(PatientID,"PER","ADD",1)),"^",1)
	Set HomeProvinceDr=$p($g(^PAPER(PatientID,"PER",4)),"^",2)
	Set:HomeProvinceDr'="" HomeProvinceDesc=$p(^CT("PROV",HomeProvinceDr),"^",2)
	Set:$p(HomeProvinceDesc,"-",2)'="" HomeProvinceDesc=$p(HomeProvinceDesc,"-",2)
	Set HomeCityDr=$p($g(^PAPER(PatientID,"PER",1)),"^",5)
	Set:HomeCityDr'="" HomeCityDesc=$p($g(^CT("CIT",HomeCityDr)),"^",2)
	Set:$p(HomeCityDesc,"-",2)'="" HomeCityDesc=$p(HomeCityDesc,"-",2)
	Set HomeCountyDr=$p($g(^PAPER(PatientID,"PER",4)),"^",9)
	Set:HomeCountyDr'="" HomeCountyDesc=$p(^CT("CITAREA",HomeCountyDr),"^",2)
	Set:$p(HomeCountyDesc,"-",2)'="" HomeCountyDesc=$p(HomeCountyDesc,"-",2)
	Set HomeVillage=$g(^PAPER(PatientID,"PER","ADD"))
	If HomeAddress="" {
		Set:HomeProvinceDesc'="" HomeAddress=HomeAddress_HomeProvinceDesc
		Set:HomeCityDesc'="" HomeAddress=HomeAddress_HomeCityDesc
		Set:HomeCountyDesc'="" HomeAddress=HomeAddress_HomeCountyDesc
		Set:HomeVillage'="" HomeAddress=HomeAddress_HomeVillage
	}
	
	Set obj.VPPatName         = PatName
	Set obj.VPNameSpell       = NameSpell
	Set obj.VPSex             = SexDesc
	Set obj.VPBirthday        = Birthday
	Set obj.VPAge	 		  = ##class(DHCWMR.IO.FromHisSrv).GetPapmiAge(PatientID,"",+$h,"")
	Set obj.VPWedlock         = MaritalDesc
	Set obj.VPOccupation      = ""
	Set obj.VPNation          = NationDesc
	Set obj.VPNationality     = CountryDesc
	Set obj.VPIdentityCode    = PersonalID
	Set obj.VPCompany         = Company
	Set obj.VPCompanyTel      = ""
	Set obj.VPCompanyZip      = ""
	Set obj.VPRegAddress      = RegAddress
	Set obj.VPRegProvince     = RegProvinceDesc
	Set obj.VPRegCity         = RegCityDesc
	Set obj.VPRegCounty       = RegCountyDesc
	Set obj.VPHomeTel         = Telephone
	Set obj.VPHomeZip         = ""
	Set obj.VPHomeAddress     = HomeAddress
	Set obj.VPHomeProvince    = HomeProvinceDesc
	Set obj.VPHomeCity        = HomeCityDesc
	Set obj.VPHomeCounty      = HomeCountyDesc
	Set obj.VPRelationDesc    = RelationDesc
	Set obj.VPRelativeName    = RelativeName
	Set obj.VPRelativeTel     = RelativeTel
	Set obj.VPRelativeAddress = RelativeAddress
	
	Set VisitStatus=$p($g(^PAADM(EpisodeID)),"^",20)
	Set tmpDateTime=##Class(DHCWMR.IO.FromAdmSrv).GetAdmDateTime(EpisodeID)
	Set AdmitDate=$p(tmpDateTime,"^",1)
	Set Age=##class(DHCWMR.IO.FromHisSrv).GetPapmiAge(Birthday,"",AdmitDate,"")
	Set:AdmitDate["-" AdmitDate=$zdh(AdmitDate,3)
	Set AdmitTime=$p(tmpDateTime,"^",2)
	Set:AdmitTime[":" AdmitTime=$zth(AdmitTime,1)
	Set tmpDeptWard=##Class(DHCWMR.SSService.CommonSrv).GetAdmitDept(EpisodeID)
	Set AdmitDept=$p(tmpDeptWard,",",1)
	Set AdmitDeptDesc=""
	Set:AdmitDept'="" AdmitDeptDesc=$p($g(^CTLOC(+AdmitDept)),"^",2)
	Set AdmitWard=$p(tmpDeptWard,",",2)
	Set AdmitWardDesc=""
	Set:AdmitWard'="" AdmitWardDesc=$p($g(^CTLOC(+AdmitWard)),"^",2)
	Set AdmitBed=$p(tmpDeptWard,",",3)
	Set AdmitBedDesc=""
	Set:AdmitBed'="" AdmitBedDesc=$p($g(^PAWARD(+AdmitBed,"BED",+$p(AdmitBed,"||",2))),"^",1)
	Set AdmitDiagnos=##Class(DHCWMR.SSService.CommonSrv).GetAdmitDiagnos(EpisodeID)
	Set tmpDateTime=##Class(DHCWMR.IO.FromAdmSrv).GetDischDateTime(EpisodeID)
	Set DischDate=$p(tmpDateTime,"^",1)
	Set:DischDate["-" DischDate=$zdh(DischDate,3)
	Set DischTime=$p(tmpDateTime,"^",2)
	Set:DischTime[":" DischTime=$zth(DischTime,1)
	Set tmpDateTime=##Class(DHCWMR.SSService.CommonSrv).GetEstimDischDate(EpisodeID)
	Set EstimDischDate=$p(tmpDateTime," ",1)
	;Set:EstimDischDate["-" EstimDischDate=$zdh(EstimDischDate,3)
	Set:EstimDischDate'="" EstimDischDate=##Class(DHCWMR.SSService.CommonSrv).DateHtmlToLogical(EstimDischDate)
	Set EstimDischTime=$p(tmpDateTime," ",2)
	Set:EstimDischTime[":" EstimDischTime=$zth(EstimDischTime,1)
	Set tmpDeptWard=##Class(DHCWMR.SSService.CommonSrv).GetDischDept(EpisodeID)
	Set DischDept=$p(tmpDeptWard,",",1)
	Set DischDeptDesc=""
	Set:DischDept'="" DischDeptDesc=$p($g(^CTLOC(+DischDept)),"^",2)
	Set DischWard=$p(tmpDeptWard,",",2)
	Set DischWardDesc=""
	Set:DischWard'="" DischWardDesc=$p($g(^CTLOC(+DischWard)),"^",2)
	Set DischBed=$p(tmpDeptWard,",",3)
	Set DischBedDesc=""
	Set:DischBed'="" DischBedDesc=$p($g(^PAWARD(+DischBed,"BED",+$p(DischBed,"||",2))),"^",1)
	Set DischDiagnos=##Class(DHCWMR.SSService.CommonSrv).GetDischDiagnos(EpisodeID)
	Set tmpDateTime=##Class(DHCWMR.SSService.CommonSrv).GetDeathDate(EpisodeID)
	Set DeathDate=$p(tmpDateTime," ",1)
	Set:DeathDate["-" DeathDate=$zdh(DeathDate,3)
	Set DeathTime=$p(tmpDateTime," ",2)
	Set:DeathTime[":" DeathTime=$zth(DeathTime,1)
	Set IsDeath=0
	Set:DeathDate'="" IsDeath=1
	
	Set obj.VPAdmitStatus     = VisitStatus
	Set obj.VPAdmitDate       = AdmitDate
	Set obj.VPAdmitTime       = AdmitTime
	Set obj.VPAdmitDept       = AdmitDept
	Set obj.VPAdmitDeptDesc   = AdmitDeptDesc
	Set obj.VPAdmitWard       = AdmitWard
	Set obj.VPAdmitWardDesc   = AdmitWardDesc
	Set obj.VPAdmitDiagnos    = AdmitDiagnos
	Set obj.VPEstimDischDate  = EstimDischDate
	Set obj.VPEstimDischTime  = EstimDischTime
	Set obj.VPDischDate       = DischDate
	Set obj.VPDischTime       = DischTime
	Set obj.VPDischDept       = DischDept
	Set obj.VPDischDeptDesc   = DischDeptDesc
	Set obj.VPDischWard       = DischWard
	Set obj.VPDischWardDesc   = DischWardDesc
	Set obj.VPDischBed        = DischBed
	Set obj.VPDischBedDesc    = DischBedDesc
	Set obj.VPDischDiagnos    = DischDiagnos
	Set obj.VPIsDeath         = IsDeath
	Set obj.VPDeathDate       = DeathDate
	Set obj.VPDeathTime       = DeathTime
	Set sc=obj.%Save()
	If $System.Status.IsError(sc) {  //检查Save是否成功
   		Do $System.OBJ.DisplayError(sc)
   		Set return=-1
	} Else {
		Set return=obj.%Id()
	}	
	Quit return
	
UpdateVolPaadmErr
	Quit -999_"^"_$ZE
}

/// Creator：     zhufei
/// CreatDate：   2015-05-13
/// Description:  更新【病案首页信息】
/// Table：       DHCWMR.SS.VolPaadm
/// Input：       VolumeID ：卷ID
///               PatientID : 病人ID
/// 				  aPatInfo :录入信息
/// Return：      返回新纪录的%Id()值
/// w ##class(DHCWMR.SS.VolPaadm).UpdateByPat(1,86)
ClassMethod UpdateByPat(aVolumeID As %String, aPatientID As %String, aPatInfo As %String = "") As %String
{
	New (aVolumeID,aPatientID,aPatInfo)
	Set return=0
	Quit:(aVolumeID="")||(aPatientID="") return
	
	Set $ZT="UpdateByPatErr"
	
	Quit:'$d(^PAPER(aPatientID)) return
	
	Set objVol=##Class(DHCWMR.SS.Volume).GetObjById(aVolumeID)
	Quit:'$IsObject(objVol) return
	Set VolPaadmID=""
	Set xSub=$o(^DHCWMR.SS.VolumeI("VP","IndexPatientID"," "_aPatientID,aVolumeID,""))
	Set:xSub'="" VolPaadmID=aVolumeID_"||"_xSub
	Quit:VolPaadmID'="" return
	
	Set obj=##Class(DHCWMR.SS.VolPaadm).%New()
	Quit:'$IsObject(obj) return
	
	Set obj.Parref			  = objVol
	Set obj.VPPatientID       = aPatientID
	Set sc=obj.%Save()
	If $System.Status.IsError(sc) {  //检查Save是否成功
   		Do $System.OBJ.DisplayError(sc)
   		Set return=-1
	} Else {
		Set return=obj.%Id()
	}	
	Quit return
	
UpdateByPatErr
	Quit -999_"^"_$ZE
}

/// Creator：     zhufei
/// CreatDate：   2014-09-29
/// Description:  更新卷病案首页信息
/// Table:        DHCWMR.SS.VolPaadm
/// Input:        VolumeID : DHCWMR.SS.Volume.ID
/// Return：      return>0:成功  return<=0:失败
/// w ##class(DHCWMR.SS.VolPaadm).UpdateByVol()
ClassMethod UpdateByVol(aVolumeID As %String) As %String
{
	New (aVolumeID)
	Set return=0
	Quit:aVolumeID="" return
	
	Set objVol=##Class(DHCWMR.SS.Volume).GetObjById(aVolumeID)
	Quit:'$IsObject(objVol) return
	
	For indAdm=1:1:objVol.ChildPaadm.Count() {
		Set objVolPaadm=objVol.ChildPaadm.GetAt(indAdm)
		Continue:'$IsObject(objVolPaadm)
		Set EpisodeID=objVolPaadm.VPEpisodeID
		Continue:EpisodeID=""
		Set EpisodeID=+EpisodeID
		Continue:EpisodeID<1
		Set flg=..Update(aVolumeID,EpisodeID)
		If (+flg)<0 {
			Set return=-1
		}
	}
	Quit:return<0 return
	
	Set return=1
	Quit return
}

/// Creator：     liyi
/// CreatDate：   2015-10-29
/// Description:  通过病案室输入内容保存病人基本信息
/// Table:        DHCWMR.SS.VolPaadm
/// Input:        aMrTypeID:病案类型,aMrNo:病案号,aMrInfo:病人基本信息
/// Return：      return>0:成功  return<=0:失败
ClassMethod UpdateByMrNo(aMrTypeID As %String, aMrNo As %String, aMrInfo As %String, aAdmInfo As %String)
{
	New (aMrTypeID,aMrNo,aMrInfo,aAdmInfo)
	
	Set return=0
	Quit:(aMrInfo="")||(aMrNo="")||(aMrTypeID="") return
	Set $ZT="UpdateByMrNoErr"
	
	Set PatName 		=$p(aMrInfo,"^",1)
	Set NameSpell 		=$p(aMrInfo,"^",2)
	Set Sex 			=$p(aMrInfo,"^",3)
	Set Birthday 		=$p(aMrInfo,"^",4)
	;Set Birthday		= $zdh(Birthday,3)
	Set Birthday		= ##Class(DHCWMR.SSService.CommonSrv).DateHtmlToLogical(Birthday)
	Set Age 			=$p(aMrInfo,"^",5)
	Set CardType 		=$p(aMrInfo,"^",6)
	Set IdentityCode 	=$p(aMrInfo,"^",7)
	Set Wedlock 		=$p(aMrInfo,"^",8)
	Set Occupation 		=$p(aMrInfo,"^",9)
	Set Nation 			=$p(aMrInfo,"^",10)
	Set Nationality 	=$p(aMrInfo,"^",11)
	Set BirthProvince	=$p(aMrInfo,"^",12)
	Set BirthCity		=$p(aMrInfo,"^",13)
	Set RegAddress 		=$p(aMrInfo,"^",14)
	Set RegZip 			=$p(aMrInfo,"^",15)
	Set Company 		=$p(aMrInfo,"^",16)
	Set CompanyZip 		=$p(aMrInfo,"^",17)
	Set CompanyTel 		=$p(aMrInfo,"^",18)
	Set RelativeName 	=$p(aMrInfo,"^",19)
	Set RelationDesc 	=$p(aMrInfo,"^",20)
	Set RelativeAddress =$p(aMrInfo,"^",21)
	Set RelativeTel 	=$p(aMrInfo,"^",22)
	
	Set EpisodeID=$p(aAdmInfo,"^",5)
	Set AdmStatus=$p(aAdmInfo,"^",8)
	Set (AdmitDate,AdmitTime,AdmitDept,AdmitDeptDesc)=""
	if EpisodeID'="" {
		Set tmpDateTime=##Class(DHCWMR.IO.FromAdmSrv).GetAdmDateTime(EpisodeID)
		Set AdmitDate=$p(tmpDateTime,"^",1)
		Set:AdmitDate["-" AdmitDate=$zdh(AdmitDate,3)
		Set AdmitTime=$p(tmpDateTime,"^",2)
		Set:AdmitTime[":" AdmitTime=$zth(AdmitTime,1)
		
		Set tmpDeptWard=##Class(DHCWMR.SSService.CommonSrv).GetAdmitDept(EpisodeID)
		Set AdmitDept=$p(tmpDeptWard,",",1)
		Set:AdmitDept'="" AdmitDeptDesc=$p($g(^CTLOC(+AdmitDept)),"^",2)
	}
	else{
		Set AdmitDate=$p(aAdmInfo,"^",4)
		//Set:AdmitDate["-" AdmitDate=$zdh(AdmitDate,3)
		Set AdmitDate=##Class(DHCWMR.SSService.CommonSrv).DateHtmlToLogical(AdmitDate)
		Set AdmitTime=""
		Set AdmitDept=$p(aAdmInfo,"^",2)
		Set:AdmitDept'="" AdmitDeptDesc=$p($g(^CTLOC(+AdmitDept)),"^",2)
	}
	
	Set objMrType = ##class(DHCWMR.SS.MrType).GetObjById(aMrTypeID)
	Quit:'$IsObject(objMrType) return

	Set xMainID=""
	For {
		Set xMainID=$o(^DHCWMR.SS.MainI("IndexTypeNoAct",aMrTypeID," "_$zcvt(aMrNo,"U"),1,xMainID))
		Quit:xMainID=""
		
		Set xVolumeID=""
		For {
			Set xVolumeID=$o(^DHCWMR.SS.VolumeI("IndexMainDrAct",xMainID,1,xVolumeID))
			Quit:xVolumeID=""
			
			Set xSubId=""
			For {
				Set xSubId=$o(^DHCWMR.SS.VolumeD(xVolumeID,"P",xSubId))
				Quit:xSubId=""
				
				Set VolPaadmID =xVolumeID_"||" _xSubId
				Set obj=##Class(DHCWMR.SS.VolPaadm).%OpenId(VolPaadmID)
				Continue:'$IsObject(obj)
				Set obj.VPPatName 			= PatName
				Set obj.VPNameSpell 		= NameSpell
				Set obj.VPSex 				= Sex
				Set obj.VPBirthday 			= Birthday
				Set obj.VPAge 				= Age
				Set obj.VPCardType 			= CardType
				Set obj.VPIdentityCode 		= IdentityCode				 
				Set obj.VPWedlock 			= Wedlock
				Set obj.VPOccupation 		= Occupation
				Set obj.VPNation 			= Nation
				Set obj.VPNationality 		= Nationality
				Set obj.VPBirthProvince 	= BirthProvince
				Set obj.VPBirthCity 		= BirthCity
				Set obj.VPRegAddress 		= RegAddress
				Set obj.VPRegZip 			= RegZip
				Set obj.VPCompany 			= Company 
				Set obj.VPCompanyZip 		= CompanyZip
				Set obj.VPCompanyTel 		= CompanyTel
				Set obj.VPRelativeName 		= RelativeName
				Set obj.VPRelationDesc 		= RelationDesc
				Set obj.VPRelativeAddress 	= RelativeAddress
				Set obj.VPRelativeTel 		= RelativeTel
				
				Set obj.VPEpisodeID		  = EpisodeID
				Set obj.VPAdmitStatus     = AdmStatus
				Set obj.VPAdmitDate       = AdmitDate
				Set obj.VPAdmitTime       = AdmitTime
				Set obj.VPAdmitDept       = AdmitDept
				Set obj.VPAdmitDeptDesc   = AdmitDeptDesc
				
				Set sc=obj.%Save()
				If $System.Status.IsError(sc) {  //检查Save是否成功
			   		Do $System.OBJ.DisplayError(sc)
			   		Set return=-1
				} Else {
					Set return=obj.%Id()
				}
				Do obj.%Close()
			}
		}
	}
	
	Quit return
	
UpdateByMrNoErr
	Quit -999_"^"_$ZE
}

/// Creator：     liyi
/// CreatDate：   2014-08-29
/// Description:  删除病案首页信息
/// Table:        DHCWMR.SS.VolPaadm
/// Input:        Id : DHCWMR.SS.VolPaadm.ID
/// Return：      return>0:成功  return<=0:失败
ClassMethod DeleteById(aId As %String) As %String
{
	new (aId)
	set return=0
	quit:aId="" return
	set sc = ##class(DHCWMR.SS.VolPaadm).%DeleteId(aId)
	if $system.Status.IsError(sc) {            //检查删除是否成功
   		d $system.OBJ.DisplayError(sc)
   		set return=-1
	}else{
		set return=1
	}
	quit return
}

Storage Default
{
<Data name="DefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>VPPatientID</Value>
</Value>
<Value name="3">
<Value>VPEpisodeID</Value>
</Value>
<Value name="4">
<Value>VPAdmitStatus</Value>
</Value>
<Value name="5">
<Value>VPPatName</Value>
</Value>
<Value name="6">
<Value>VPNameSpell</Value>
</Value>
<Value name="7">
<Value>VPSex</Value>
</Value>
<Value name="8">
<Value>VPBirthday</Value>
</Value>
<Value name="9">
<Value>VPAge</Value>
</Value>
<Value name="10">
<Value>VPWedlock</Value>
</Value>
<Value name="11">
<Value>VPOccupation</Value>
</Value>
<Value name="12">
<Value>VPRegAddress</Value>
</Value>
<Value name="13">
<Value>VPRegProvince</Value>
</Value>
<Value name="14">
<Value>VPRegCity</Value>
</Value>
<Value name="15">
<Value>VPRegCounty</Value>
</Value>
<Value name="16">
<Value>VPNation</Value>
</Value>
<Value name="17">
<Value>VPNationality</Value>
</Value>
<Value name="18">
<Value>VPIdentityCode</Value>
</Value>
<Value name="19">
<Value>VPCompany</Value>
</Value>
<Value name="20">
<Value>VPCompanyTel</Value>
</Value>
<Value name="21">
<Value>VPCompanyZip</Value>
</Value>
<Value name="22">
<Value>VPHomeAddress</Value>
</Value>
<Value name="23">
<Value>VPHomeProvince</Value>
</Value>
<Value name="24">
<Value>VPHomeCity</Value>
</Value>
<Value name="25">
<Value>VPHomeCounty</Value>
</Value>
<Value name="26">
<Value>VPHomeTel</Value>
</Value>
<Value name="27">
<Value>VPHomeZip</Value>
</Value>
<Value name="28">
<Value>VPRelationDesc</Value>
</Value>
<Value name="29">
<Value>VPRelativeName</Value>
</Value>
<Value name="30">
<Value>VPRelativeTel</Value>
</Value>
<Value name="31">
<Value>VPRelativeAddress</Value>
</Value>
<Value name="32">
<Value>VPAdmitDate</Value>
</Value>
<Value name="33">
<Value>VPAdmitTime</Value>
</Value>
<Value name="34">
<Value>VPAdmitDept</Value>
</Value>
<Value name="35">
<Value>VPAdmitWard</Value>
</Value>
<Value name="36">
<Value>VPAdmitDiagnos</Value>
</Value>
<Value name="37">
<Value>VPEstimDischDate</Value>
</Value>
<Value name="38">
<Value>VPEstimDischTime</Value>
</Value>
<Value name="39">
<Value>VPDischDate</Value>
</Value>
<Value name="40">
<Value>VPDischTime</Value>
</Value>
<Value name="41">
<Value>VPDischDept</Value>
</Value>
<Value name="42">
<Value>VPDischWard</Value>
</Value>
<Value name="43">
<Value>VPDischBed</Value>
</Value>
<Value name="44">
<Value>VPDischDiagnos</Value>
</Value>
<Value name="45">
<Value>VPIsDeath</Value>
</Value>
<Value name="46">
<Value>VPDeathDate</Value>
</Value>
<Value name="47">
<Value>VPDeathTime</Value>
</Value>
<Value name="48">
<Value>VPMrNos</Value>
</Value>
<Value name="49">
<Value>VPManName</Value>
</Value>
<Value name="50">
<Value>VPAdmitDeptDesc</Value>
</Value>
<Value name="51">
<Value>VPAdmitWardDesc</Value>
</Value>
<Value name="52">
<Value>VPDischDeptDesc</Value>
</Value>
<Value name="53">
<Value>VPDischWardDesc</Value>
</Value>
<Value name="54">
<Value>VPDischBedDesc</Value>
</Value>
<Value name="55">
<Value>VPAdmNo</Value>
</Value>
<Value name="56">
<Value>VPRegZip</Value>
</Value>
<Value name="57">
<Value>VPCardType</Value>
</Value>
<Value name="58">
<Value>VPBirthProvince</Value>
</Value>
<Value name="59">
<Value>VPBirthCity</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("P")</DataLocation>
<DefaultData>DefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>{%%PARENT}("P")</IdLocation>
<IndexLocation>^DHCWMR.SS.VolumeI("VP")</IndexLocation>
<StreamLocation>^DHCWMR.SS.VolPaadmS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
