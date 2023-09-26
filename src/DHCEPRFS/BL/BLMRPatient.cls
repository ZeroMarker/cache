Class DHCEPRFS.BL.BLMRPatient Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// Desc:	注册MRPatient对象并获取其实体对象 - 预留接口
ClassMethod RegMRPatient(APatientID As %String, ASysCode As %String = "DHC") As %String
{
	//获取MREpisode

	//MREpisode不存在，创建

	//获取EMREpisode
}

/// Debug: w ##class(DHCEPRFS.BL.BLMRPatient).RegMRPatByMedRecord("90222","Z088535","DHC")
ClassMethod RegMRPatByMedRecord(APatientID As %String, AMedRecordNo As %String, ASysCode As %String = "DHC") As %String
{
	//需要查看是否mrPatient已存在
	s mrPatientID = ..GetMRPatientID(APatientID, ASysCode)
	if (mrPatientID = "")
	{
		s mrPatientID = ..CreateMRPatient(APatientID,ASysCode,"","","",AMedRecordNo)
	}
	q mrPatientID
}

/// Desc:	注册MRPatient对象并获取其RowID
ClassMethod RegMRPatientID(APatientID As %String, ASysCode As %String = "DHC", AEpisodeID As %String = "", ATypeCode As %String = "DHC") As %String
{
	//获取MRPatientID
	s mrPatientID = ..GetMRPatientID(APatientID, ASysCode)
	
	//MREpisode不存在，创建
	if (mrPatientID = "")
	{
		s mrPatientID = ..CreateMRPatient(APatientID, ASysCode,AEpisodeID,"","","",ATypeCode)
	}
	else
	{
		s mrPatientID = ..UpdateMRPatient(APatientID, ASysCode,AEpisodeID,"",ATypeCode)	
	}
	
	q mrPatientID
}

ClassMethod RegMREpisodePatID(APatientID As %String, ASysCode As %String = "DHC", AEpisodeID As %String = "", AMRPatientID As %String = "", AMRMedRecordID As %String = "") As %String
{
	//每次就诊存一份患者信息到DHCEPRFS.INST.MREpisodePat
	//就诊是否已经存在
	s mrEpisodePatID = $o(^DHCEPRFS.INST.MREpisodePatI("IdxEpisodeID"," "_AEpisodeID,""))
	if (mrEpisodePatID = "")
	{
		s mrEpisodePatID = ..CreateMRPatient(APatientID, ASysCode,AEpisodeID,AMRPatientID,AMRMedRecordID)
	}
	
	q mrEpisodePatID
}

/// Desc:	获取MRPatientID
ClassMethod GetMRPatientID(APatientID As %String, ASysCode As %String = "DHC") As %String
{
	q:(APatientID="") ""
	
	s rowID = $O(^DHCEPRFS.INST.MRPatientI("IdxPatientID", " "_ASysCode, " "_APatientID, ""))
	q rowID
}

/// Desc:	通过MREpisodeID获取病案号
/// debug:  d ##class(DHCEPRFS.BL.BLMRPatient).GetMrPatientInfoByMrEpisodeID("13")
ClassMethod GetMrPatientInfoByMrEpisodeID(AMREpisodeID As %String) As DHCEPRFS.Entity.EMRPatient
{
	s objMrEpisode = ##Class(DHCEPRFS.INST.MREpisode).%OpenId(AMREpisodeID)
	q:(objMrEpisode = "") ""
	s mrPatientID = objMrEpisode.MRPatientID
	q:(mrPatientID = "") ""
	
	s obj = ##Class(DHCEPRFS.INST.MRPatient).%OpenId(mrPatientID)
	
	s entity = ##Class(DHCEPRFS.Entity.EMRPatient).%New()
	s entity.SysCode = obj.SysCode
	s entity.PatientID = obj.PatientID
	s entity.IDCard = obj.IDCard
	s entity.Name = obj.Name
	s entity.MedRecordNo = obj.MedRecordNo
	s entity.CompanyCode = obj.CompanyCode
	s entity.CreateDate = obj.CreateDate
	s entity.CreateTime = obj.CreateTime
	s entity.LastModifyDate = obj.LastModifyDate
	s entity.LastModifyTime = obj.LastModifyTime
	s entity.AdmCount = obj.AdmCount
    s entity.InCount = obj.InCount
    s entity.RegNo = obj.RegNo
    s entity.Gender = obj.Gender
    s entity.Birthday = obj.Birthday
    s entity.Age = obj.Age
    s entity.AgeMonth = obj.AgeMonth
    s entity.AgeDay = obj.AgeDay
    s entity.Marriage = obj.Marriage
    s entity.Nationality = obj.Nationality
    s entity.CardType = obj.CardType 
    s entity.GovCardno = obj.GovCardno
    s entity.OPCardType = obj.OPCardType
    s entity.OPCardID = obj.OPCardID
    s entity.InsuType = obj.InsuType
    s entity.InsuNo = obj.InsuNo
    s entity.PhoneNo = obj.PhoneNo
    s entity.LinkName = obj.LinkName
    s entity.LinkRelation = obj.LinkRelation
    s entity.LinkPhone = obj.LinkPhone
    s entity.Occupation = obj.Occupation
    s entity.Company = obj.Company
    s entity.Worktel = obj.Worktel
    s entity.HouseProvince = obj.HouseProvince
    s entity.HouseCity = obj.HouseCity
    s entity.HouseArea = obj.HouseArea
    s entity.HouseAddress = obj.HouseAddress
    s entity.HouseZipCode = obj.HouseZipCode
    s entity.ResidentProvince = obj.ResidentProvince
    s entity.ResidentCity = obj.ResidentCity
    s entity.ResidentArea = obj.ResidentArea
    s entity.ResidentAddress = obj.ResidentAddress
    s entity.ResidentZipCode = obj.ResidentZipCode
    s entity.MarriageID = obj.MarriageID
    s entity.NationalityID = obj.NationalityID
    s entity.CardTypeID = obj.CardTypeID
    s entity.OPCardTypeID = obj.OPCardTypeID
    s entity.InsuTypeID = obj.InsuTypeID
    s entity.LinkRelationID = obj.LinkRelationID
    s entity.HouseCity = obj.HouseCity
    s entity.HouseProvinceID = obj.HouseProvinceID
    s entity.HouseCityID = obj.HouseCityID
    s entity.HouseAreaID = obj.HouseAreaID
    s entity.ResidentProvinceID = obj.ResidentProvinceID
    s entity.ResidentCityID = obj.ResidentCityID
    s entity.ResidentAreaID = obj.ResidentAreaID
	s entity.MotherPatientID = obj.MotherPatientID
	s entity.AliasName = obj.AliasName
	s entity.AliasNameInitial = obj.AliasNameInitial
	s entity.ObservedNo = obj.ObservedNo
	
	q entity
}

/// Desc:	更新MRPatient
ClassMethod UpdateMRPatient(APatientID As %String, ASysCode As %String, AEpisodeID As %String = "", AMedRecordNo As %String = "", ATypeCode As %String = "DHC") As %String
{
	//此处可通过适配器适配其他系统患者基本信息
	//从医政组首页数据池取信息
	if (ATypeCode = "MRQ")
	{
		s entity = ..CreateEMRPatientMRQ("update",APatientID, ASysCode,AEpisodeID,AMedRecordNo)
	}
	//if (ATypeCode = "DHC")
	else
	{
		s entity = ..CreateEMRPatientDHC("update",APatientID, ASysCode,AEpisodeID,AMedRecordNo)
	}
	
	s mrPatientID = ..GetMRPatientID(APatientID, ASysCode)
	
	s obj = ##Class(DHCEPRFS.INST.MRPatient).%OpenId(mrPatientID)
	s obj.SysCode = entity.SysCode
	s obj.PatientID = entity.PatientID
	s obj.IDCard = entity.IDCard
	s obj.Name = entity.Name
	s obj.MedRecordNo = entity.MedRecordNo	
	s obj.CompanyCode = entity.CompanyCode
	s obj.CreateDate = entity.CreateDate
	s obj.CreateTime = entity.CreateTime
	s obj.LastModifyDate =  entity.LastModifyDate
	s obj.LastModifyTime = entity.LastModifyTime
	s obj.AdmCount =  entity.AdmCount
    s obj.InCount = entity.InCount
    s obj.RegNo = entity.RegNo
    s obj.Gender = entity.Gender
    s obj.Birthday = entity.Birthday
    s obj.Age = entity.Age
    s obj.AgeMonth = entity.AgeMonth
    s obj.AgeDay = entity.AgeDay
    s obj.Marriage = entity.Marriage
    s obj.Nationality = entity.Nationality
    s obj.CardType = entity.CardType
    s obj.GovCardno = entity.GovCardno
    s obj.OPCardType = entity.OPCardType
    s obj.OPCardID = entity.OPCardID
    s obj.InsuType = entity.InsuType
    s obj.InsuNo = entity.InsuNo
    s obj.PhoneNo = entity.PhoneNo
    s obj.LinkName = entity.LinkName
    s obj.LinkRelation = entity.LinkRelation
    s obj.LinkPhone = entity.LinkPhone
    s obj.Occupation = entity.Occupation
    s obj.Company = entity.Company
    s obj.Worktel = entity.Worktel
    s obj.HouseProvince = entity.HouseProvince
    s obj.HouseCity = entity.HouseCity
    s obj.HouseArea = entity.HouseArea
    s obj.HouseAddress = entity.HouseAddress
    s obj.HouseZipCode = entity.HouseZipCode
    s obj.ResidentProvince = entity.ResidentProvince
    s obj.ResidentCity = entity.ResidentCity
    s obj.ResidentArea = entity.ResidentArea
    s obj.ResidentAddress = entity.ResidentAddress
    s obj.ResidentZipCode = entity.ResidentZipCode
    s obj.MarriageID = entity.MarriageID 
    s obj.NationalityID = entity.NationalityID
    s obj.CardTypeID = entity.CardTypeID
    s obj.OPCardTypeID = entity.OPCardTypeID
    s obj.InsuTypeID = entity.InsuTypeID
    s obj.LinkRelationID = entity.LinkRelationID
    s obj.HouseCity = entity.HouseCity
    s obj.HouseProvinceID = entity.HouseProvinceID
    s obj.HouseCityID = entity.HouseCityID
    s obj.HouseAreaID = entity.HouseAreaID
    s obj.ResidentProvinceID = entity.ResidentProvinceID
    s obj.ResidentCityID = entity.ResidentCityID
    s obj.ResidentAreaID = entity.ResidentAreaID
	s obj.MotherPatientID = entity.MotherPatientID
	s obj.AliasName = entity.AliasName
	s obj.AliasNameInitial = entity.AliasNameInitial
	s obj.ObservedNo = entity.ObservedNo
	
	s status = obj.%Save()
	if ($$$ISOK(status))
	{
		q obj.%Id()
	}
	else
	{
		q ""
	}
}

/// Desc:	更新MRPatient
ClassMethod UpdateMREpisodePat(APatientID As %String, ASysCode As %String, AEpisodeID As %String) As %String
{
	//此处可通过适配器适配其他系统患者基本信息
	s entity = ..CreateEMRPatientDHC("update",APatientID, ASysCode,AEpisodeID)
	
	s mrPatientID = ..GetMRPatientID(APatientID, ASysCode)
	
	s mrEpisodePatID = ""
	s mrEpisodePatID = $o(^DHCEPRFS.INST.MREpisodePatI("IdxEpisodeID"," "_AEpisodeID,mrEpisodePatID))
	q:(mrEpisodePatID = "") "-1"
	
	s obj = ##Class(DHCEPRFS.INST.MREpisodePat).%OpenId(mrEpisodePatID)
	s obj.SysCode = entity.SysCode
	s obj.PatientID = entity.PatientID
	s obj.IDCard = entity.IDCard
	s obj.Name = entity.Name
	s obj.MedRecordNo = entity.MedRecordNo	
	s obj.CompanyCode = entity.CompanyCode
	//s obj.CreateDate = entity.CreateDate
	//s obj.CreateTime = entity.CreateTime
	s obj.LastModifyDate =  entity.LastModifyDate
	s obj.LastModifyTime = entity.LastModifyTime
	s obj.AdmCount =  entity.AdmCount
    s obj.InCount = entity.InCount
    s obj.RegNo = entity.RegNo
    s obj.Gender = entity.Gender
    s obj.Birthday = entity.Birthday
    s obj.Age = entity.Age
    s obj.AgeMonth = entity.AgeMonth
    s obj.AgeDay = entity.AgeDay
    s obj.Marriage = entity.Marriage
    s obj.Nationality = entity.Nationality
    s obj.CardType = entity.CardType
    s obj.GovCardno = entity.GovCardno
    s obj.OPCardType = entity.OPCardType
    s obj.OPCardID = entity.OPCardID
    s obj.InsuType = entity.InsuType
    s obj.InsuNo = entity.InsuNo
    s obj.PhoneNo = entity.PhoneNo
    s obj.LinkName = entity.LinkName
    s obj.LinkRelation = entity.LinkRelation
    s obj.LinkPhone = entity.LinkPhone
    s obj.Occupation = entity.Occupation
    s obj.Company = entity.Company
    s obj.Worktel = entity.Worktel
    s obj.HouseProvince = entity.HouseProvince
    s obj.HouseCity = entity.HouseCity
    s obj.HouseArea = entity.HouseArea
    s obj.HouseAddress = entity.HouseAddress
    s obj.HouseZipCode = entity.HouseZipCode
    s obj.ResidentProvince = entity.ResidentProvince
    s obj.ResidentCity = entity.ResidentCity
    s obj.ResidentArea = entity.ResidentArea
    s obj.ResidentAddress = entity.ResidentAddress
    s obj.ResidentZipCode = entity.ResidentZipCode
    s obj.MarriageID = entity.MarriageID 
    s obj.NationalityID = entity.NationalityID
    s obj.CardTypeID = entity.CardTypeID
    s obj.OPCardTypeID = entity.OPCardTypeID
    s obj.InsuTypeID = entity.InsuTypeID
    s obj.LinkRelationID = entity.LinkRelationID
    s obj.HouseCity = entity.HouseCity
    s obj.HouseProvinceID = entity.HouseProvinceID
    s obj.HouseCityID = entity.HouseCityID
    s obj.HouseAreaID = entity.HouseAreaID
    s obj.ResidentProvinceID = entity.ResidentProvinceID
    s obj.ResidentCityID = entity.ResidentCityID
    s obj.ResidentAreaID = entity.ResidentAreaID
	s obj.MotherPatientID = entity.MotherPatientID
	s obj.AliasName = entity.AliasName
	s obj.AliasNameInitial = entity.AliasNameInitial
	s obj.ObservedNo = entity.ObservedNo
	
	s status = obj.%Save()
	if ($$$ISOK(status))
	{
		q obj.%Id()
	}
	else
	{
		q ""
	}
}

/// Desc:	创建MRPatient
ClassMethod CreateMRPatient(APatientID As %String, ASysCode As %String, AEpisodeID As %String = "", AMRPatientID As %String = "", AMRMedRecordID As %String = "", AMedRecordNo As %String = "", ATypeCode As %String = "DHC") As %String
{
	//此处可通过适配器适配其他系统患者基本信息
	//从医政组首页数据池取信息
	if (ATypeCode = "MRQ")
	{
		s entity = ..CreateEMRPatientMRQ("create",APatientID, ASysCode,AEpisodeID,AMedRecordNo)
	}
	//if (ATypeCode = "DHC")
	else
	{
		s entity = ..CreateEMRPatientDHC("create",APatientID, ASysCode,AEpisodeID,AMedRecordNo)
	}
	if (AMRPatientID '= "")
	{
		s obj = ##Class(DHCEPRFS.INST.MREpisodePat).%New()
		s obj.EpisodeID = AEpisodeID
		s mrEpisodeID = $o(^DHCEPRFS.INST.MREpisodeI("IdxSysCodeAndEpisodeID"," DHC"," "_AEpisodeID,""))
		s obj.MREpisodeID = mrEpisodeID
		s obj.MRPatientID = AMRPatientID
		s obj.MRMedRecordID = AMRMedRecordID
	}
	else
	{
		s obj = ##Class(DHCEPRFS.INST.MRPatient).%New()
	}
	s obj.SysCode = entity.SysCode
	s obj.PatientID = entity.PatientID
	s obj.IDCard = entity.IDCard
	s obj.Name = entity.Name
	s obj.MedRecordNo = entity.MedRecordNo	
	s obj.CompanyCode = entity.CompanyCode
	s obj.CreateDate = entity.CreateDate
	s obj.CreateTime = entity.CreateTime
	s obj.LastModifyDate =  entity.LastModifyDate
	s obj.LastModifyTime = entity.LastModifyTime
	s obj.AdmCount =  entity.AdmCount
    s obj.InCount = entity.InCount
    s obj.RegNo = entity.RegNo
    s obj.Gender = entity.Gender
    s obj.Birthday = entity.Birthday
    s obj.Age = entity.Age
    s obj.AgeMonth = entity.AgeMonth
    s obj.AgeDay = entity.AgeDay
    s obj.Marriage = entity.Marriage
    s obj.Nationality = entity.Nationality
    s obj.CardType = entity.CardType
    s obj.GovCardno = entity.GovCardno
    s obj.OPCardType = entity.OPCardType
    s obj.OPCardID = entity.OPCardID
    s obj.InsuType = entity.InsuType
    s obj.InsuNo = entity.InsuNo
    s obj.PhoneNo = entity.PhoneNo
    s obj.LinkName = entity.LinkName
    s obj.LinkRelation = entity.LinkRelation
    s obj.LinkPhone = entity.LinkPhone
    s obj.Occupation = entity.Occupation
    s obj.Company = entity.Company
    s obj.Worktel = entity.Worktel
    s obj.HouseProvince = entity.HouseProvince
    s obj.HouseCity = entity.HouseCity
    s obj.HouseArea = entity.HouseArea
    s obj.HouseAddress = entity.HouseAddress
    s obj.HouseZipCode = entity.HouseZipCode
    s obj.ResidentProvince = entity.ResidentProvince
    s obj.ResidentCity = entity.ResidentCity
    s obj.ResidentArea = entity.ResidentArea
    s obj.ResidentAddress = entity.ResidentAddress
    s obj.ResidentZipCode = entity.ResidentZipCode
    s obj.MarriageID = entity.MarriageID 
    s obj.NationalityID = entity.NationalityID
    s obj.CardTypeID = entity.CardTypeID
    s obj.OPCardTypeID = entity.OPCardTypeID
    s obj.InsuTypeID = entity.InsuTypeID
    s obj.LinkRelationID = entity.LinkRelationID
    s obj.HouseCity = entity.HouseCity
    s obj.HouseProvinceID = entity.HouseProvinceID
    s obj.HouseCityID = entity.HouseCityID
    s obj.HouseAreaID = entity.HouseAreaID
    s obj.ResidentProvinceID = entity.ResidentProvinceID
    s obj.ResidentCityID = entity.ResidentCityID
    s obj.ResidentAreaID = entity.ResidentAreaID
	s obj.MotherPatientID = entity.MotherPatientID
	s obj.AliasName = entity.AliasName
	s obj.AliasNameInitial = entity.AliasNameInitial
	s obj.ObservedNo = entity.ObservedNo
	
	s status = obj.%Save()
	if ($$$ISOK(status))
	{
		q obj.%Id()
	}
	else
	{
		q ""
	}
}

ClassMethod CreateEMRPatientDHC(AType As %String, APatientID As %String, ASysCode As %String, AEpisodeID As %String = "", AMedRecordNo As %String = "") As %String
{
	s entity = ##Class(DHCEPRFS.Entity.EMRPatient).%New()
	s entity.SysCode = ASysCode
	s entity.PatientID = APatientID
	s entity.IDCard = ##Class(DHCEPRFS.BL.HISInfo.BLPatientInfo).GetIDCard(APatientID)
	s Name = ##Class(DHCEPRFS.BL.HISInfo.BLPatientInfo).GetName(APatientID)
	s entity.Name = Name
	s entity.AliasName = ##Class(DHCEPRFS.Util.StringHelper).GetCNCODE(Name,3,"")
	s entity.AliasNameInitial = ##Class(DHCEPRFS.Util.StringHelper).GetCNCODE(Name,4,"")

	if (AMedRecordNo '= "")
	{
		s entity.MedRecordNo = AMedRecordNo
	}
	else
	{
		s entity.MedRecordNo = ##Class(DHCEPRFS.BL.HISInfo.BLPatientInfo).GetMedRecordNo(APatientID,"",AEpisodeID)
	}
	s entity.CompanyCode = ##Class(DHCEPRFS.BL.HISInfo.BLPatientInfo).GetCompanyCode(APatientID)
	if (AType = "create")
	{
		s entity.CreateDate = $p($h,",",1)  
		s entity.CreateTime = $p($h,",",2)  //06
	}
	else
	{
		s mrPatientID = $o(^DHCEPRFS.INST.MRPatientI("IdxPatientID", " "_ASysCode, " "_APatientID, ""))
		s obj = ##class(DHCEPRFS.INST.MRPatient).%OpenId(mrPatientID)
		s entity.CreateDate = obj.CreateDate 
		s entity.CreateTime = obj.CreateTime
		d obj.%Close()	
	}
	s entity.LastModifyDate = $p($h,",",1)
	s entity.LastModifyTime = $p($h,",",2)
	s entity.AdmCount = "" //##Class(DHCEPRFS.BL.HISInfo.BLPatientInfo).GetAdmCount(APatientID)
    s entity.InCount = "" //##Class(DHCEPRFS.BL.HISInfo.BLPatientInfo).GetInCount(APatientID)
    s entity.RegNo = ##Class(DHCEPRFS.BL.HISInfo.BLPatientInfo).GetRegNo(APatientID)
    s entity.Gender = $P(##Class(DHCEPRFS.BL.HISInfo.BLPatientInfo).GetGender(APatientID),"^",3)
    s entity.Birthday = ##Class(DHCEPRFS.BL.HISInfo.BLPatientInfo).GetBirthday(APatientID)
    s age = ##class(DHCEPRFS.BL.HISInfo.BLEpisodeInfo).GetAge(AEpisodeID)
    if ((age '= "") || (age '= $c(0)))
    {
		s entity.Age = $p(age,"^",1)    
		s entity.AgeMonth = $p(age,"^",2)   
		s entity.AgeDay = $p(age,"^",3)   
	}
	else
	{
		s entity.Age = ""   
		s entity.AgeMonth = ""   
		s entity.AgeDay = ""  
	}
    s entity.Marriage = $P(##Class(DHCEPRFS.BL.HISInfo.BLPatientInfo).GetMarriage(APatientID),"^",3)
    s entity.Nationality = $P(##Class(DHCEPRFS.BL.HISInfo.BLPatientInfo).GetNationality(APatientID),"^",3)
    s entity.CardType = $p(##Class(DHCEPRFS.BL.HISInfo.BLPatientInfo).GetCardType(APatientID),"^",2)
    s entity.GovCardno=##Class(DHCEPRFS.BL.HISInfo.BLPatientInfo).GetGovCardno(APatientID)
    s entity.OPCardType=##Class(DHCEPRFS.BL.HISInfo.BLPatientInfo).GetOPCardType(APatientID)
    s entity.OPCardID=##Class(DHCEPRFS.BL.HISInfo.BLPatientInfo).GetOPCardID(APatientID)
    s entity.InsuType = $p(##Class(DHCEPRFS.BL.HISInfo.BLPatientInfo).GetInsuType(APatientID),"^",2)
    s entity.InsuNo=##Class(DHCEPRFS.BL.HISInfo.BLPatientInfo).GetInsuNo(APatientID)
    s entity.PhoneNo=##Class(DHCEPRFS.BL.HISInfo.BLPatientInfo).GetPhoneNo(APatientID)
    s entity.LinkName=##Class(DHCEPRFS.BL.HISInfo.BLPatientInfo).GetLinkName(APatientID)
    s entity.LinkRelation = $p(##Class(DHCEPRFS.BL.HISInfo.BLPatientInfo).GetLinkRelation(APatientID),"^",3)
    s entity.LinkPhone=##Class(DHCEPRFS.BL.HISInfo.BLPatientInfo).GetLinkPhone(APatientID)
    s entity.Occupation = $P(##Class(DHCEPRFS.BL.HISInfo.BLPatientInfo).GetOccupation(APatientID),"^",3)
    s entity.Company = ##Class(DHCEPRFS.BL.HISInfo.BLPatientInfo).GetCompany(APatientID)
    s entity.Worktel = ##Class(DHCEPRFS.BL.HISInfo.BLPatientInfo).GetWorktel(APatientID)
    s entity.HouseProvince = $P(##Class(DHCEPRFS.BL.HISInfo.BLPatientInfo).GetHouseProvince(APatientID),"^",2)
    s entity.HouseCity = $p(##Class(DHCEPRFS.BL.HISInfo.BLPatientInfo).GetHouseCity(APatientID),"^",2)
    s entity.HouseArea = $p(##Class(DHCEPRFS.BL.HISInfo.BLPatientInfo).GetHouseArea(APatientID),"^",2)
    s entity.HouseAddress = ##Class(DHCEPRFS.BL.HISInfo.BLPatientInfo).GetHouseAddress(APatientID)
    s entity.HouseZipCode = ##Class(DHCEPRFS.BL.HISInfo.BLPatientInfo).GetHouseZipCode(APatientID)
    s entity.ResidentProvince = $p($p(##Class(DHCEPRFS.BL.HISInfo.BLPatientInfo).GetResidentAddress(APatientID),"!",1),"^",4)
    s entity.ResidentCity = $p($p(##Class(DHCEPRFS.BL.HISInfo.BLPatientInfo).GetResidentAddress(APatientID),"!",2),"^",4)
    s entity.ResidentArea = $p($p(##Class(DHCEPRFS.BL.HISInfo.BLPatientInfo).GetResidentAddress(APatientID),"!",3),"^",4)
    s entity.ResidentAddress = $p(##Class(DHCEPRFS.BL.HISInfo.BLPatientInfo).GetResidentAddress(APatientID),"!",4)
    s entity.ResidentZipCode = ##Class(DHCEPRFS.BL.HISInfo.BLPatientInfo).GetResidentZipCode(APatientID)
    s entity.MarriageID = $p(##Class(DHCEPRFS.BL.HISInfo.BLPatientInfo).GetMarriage(APatientID),"^",1)
    s entity.NationalityID = $p(##Class(DHCEPRFS.BL.HISInfo.BLPatientInfo).GetNationality(APatientID),"^",1)
    s entity.CardTypeID = $p(##Class(DHCEPRFS.BL.HISInfo.BLPatientInfo).GetCardType(APatientID),"^",1)
    s entity.OPCardTypeID = ""  //##Class(DHCEPRFS.BL.HISInfo.BLPatientInfo).GetOPCardTypeID(APatientID)
    s entity.InsuTypeID = $p(##Class(DHCEPRFS.BL.HISInfo.BLPatientInfo).GetInsuType(APatientID),"^",1)
    s entity.LinkRelationID = $p(##Class(DHCEPRFS.BL.HISInfo.BLPatientInfo).GetLinkRelation(APatientID),"^",1)
    s entity.HouseProvinceID = $P(##Class(DHCEPRFS.BL.HISInfo.BLPatientInfo).GetHouseProvince(APatientID),"^",1)  //##Class(DHCEPRFS.BL.HISInfo.BLPatientInfo).GetHouseProvinceID(APatientID)
    s entity.HouseCityID = $p(##Class(DHCEPRFS.BL.HISInfo.BLPatientInfo).GetHouseCity(APatientID),"^",1)
    s entity.HouseAreaID = $p(##Class(DHCEPRFS.BL.HISInfo.BLPatientInfo).GetHouseArea(APatientID),"^",1)
    s entity.ResidentProvinceID = $p($p(##Class(DHCEPRFS.BL.HISInfo.BLPatientInfo).GetResidentAddress(APatientID),"!",1),"^",1)
    s entity.ResidentCityID = $p($p(##Class(DHCEPRFS.BL.HISInfo.BLPatientInfo).GetResidentAddress(APatientID),"!",2),"^",1)
    s entity.ResidentAreaID = $p($p(##Class(DHCEPRFS.BL.HISInfo.BLPatientInfo).GetResidentAddress(APatientID),"!",3),"^",1)
	s entity.MotherPatientID = ##Class(DHCEPRFS.BL.HISInfo.BLPatientInfo).GetMotherDR(APatientID)
	
	s entity.ObservedNo = ##Class(DHCEPRFS.BL.HISInfo.BLPatientInfo).GetObservedNo(APatientID)
	
	q entity
}

ClassMethod CreateEMRPatientMRQ(AType As %String, APatientID As %String, ASysCode As %String, AEpisodeID As %String = "", AMedRecordNo As %String = "") As %String
{
	//获取就诊的首页数据
	s arr = ##class(DHCEPRFS.BL.HISInfo.BLMRQInfo).GetArrayOfDataByAdm(AEpisodeID)
	
	s entity = ##Class(DHCEPRFS.Entity.EMRPatient).%New()
	s entity.SysCode = ASysCode
	s entity.PatientID = APatientID
	s entity.IDCard = arr.GetAt("P00030000")
	s Name = arr.GetAt("P00060000")
	s entity.Name = Name
	s entity.AliasName = ##Class(DHCEPRFS.Util.StringHelper).GetCNCODE(Name,3,"")
	s entity.AliasNameInitial = ##Class(DHCEPRFS.Util.StringHelper).GetCNCODE(Name,4,"")
	s entity.MedRecordNo = arr.GetAt("P00050000")

	s entity.CompanyCode = arr.GetAt("P00210000")
	if (AType = "create")
	{
		s entity.CreateDate = $p($h,",",1)  
		s entity.CreateTime = $p($h,",",2)  //06
	}
	else
	{
		s mrPatientID = $o(^DHCEPRFS.INST.MRPatientI("IdxPatientID", " "_ASysCode, " "_APatientID, ""))
		s obj = ##class(DHCEPRFS.INST.MRPatient).%OpenId(mrPatientID)
		s entity.CreateDate = obj.CreateDate 
		s entity.CreateTime = obj.CreateTime
		d obj.%Close()	
	}
	s entity.LastModifyDate = $p($h,",",1)
	s entity.LastModifyTime = $p($h,",",2)
	s entity.AdmCount = "" //##Class(DHCEPRFS.BL.HISInfo.BLPatientInfo).GetAdmCount(APatientID)
    s entity.InCount = "" //##Class(DHCEPRFS.BL.HISInfo.BLPatientInfo).GetInCount(APatientID)
    s entity.RegNo = arr.GetAt("P00030000")
    s entity.Gender = arr.GetAt("P00070000")
    s entity.Birthday = arr.GetAt("P00080000")

	s entity.Age = arr.GetAt("P00090000")    
	s entity.AgeMonth = arr.GetAt("P00090100")  
	s entity.AgeDay = arr.GetAt("P00090200")  

    s entity.Marriage = arr.GetAt("P00180000") 
    s entity.MarriageID = arr.GetAt("P00180001") 
    s entity.Nationality = arr.GetAt("P00100000") 
    s entity.NationalityID = arr.GetAt("P00100001") 
    s entity.CardType = arr.GetAt("P00160001") 
    s entity.CardTypeID = arr.GetAt("P00160002")
    s entity.GovCardno = arr.GetAt("P00160000") 
    s entity.OPCardType = ""
    s entity.OPCardTypeID = "" 
    s entity.OPCardID = ""
    s entity.InsuType = ""
    s entity.InsuTypeID = ""
    s entity.InsuNo = ""
    s entity.PhoneNo = arr.GetAt("P00190500") 
    s entity.LinkName = arr.GetAt("P00220000") 
    s entity.LinkRelation = arr.GetAt("P00220100") 
    s entity.LinkRelationID = arr.GetAt("P00220101") 
    s entity.LinkPhone = arr.GetAt("P00220300") 
    s entity.Occupation = arr.GetAt("P00170000") 
    s entity.Company = arr.GetAt("P00210000") 
    s entity.Worktel = arr.GetAt("P00210100") 
    s entity.HouseProvince = arr.GetAt("P00200100") 
    s entity.HouseProvinceID = arr.GetAt("P00200101") 
    s entity.HouseCity = arr.GetAt("P00200200") 
    s entity.HouseCityID = arr.GetAt("P00200201") 
    s entity.HouseArea = arr.GetAt("P00200300")
    s entity.HouseAreaID = arr.GetAt("P00200301")  
    s entity.HouseAddress = arr.GetAt("P00200000") 
    s entity.HouseZipCode = arr.GetAt("P00200500") 
    s entity.ResidentProvince = arr.GetAt("P00190100") 
    s entity.ResidentProvinceID = arr.GetAt("P00190101") 
    s entity.ResidentCity = arr.GetAt("P00190200")
    s entity.ResidentCityID = arr.GetAt("P00190201")  
    s entity.ResidentArea = arr.GetAt("P00190300") 
    s entity.ResidentAreaID = arr.GetAt("P00190301") 
    s entity.ResidentAddress = arr.GetAt("P00190000") 
    s entity.ResidentZipCode = arr.GetAt("P00190600") 

	s entity.MotherPatientID = ""
	s entity.ObservedNo = ""
	
	q entity
}

/// Desc:	根据母亲的PatientID获取其新生儿子女的MRPatientID列表
/// Input:	ASysCode :  系统标识号
/// 		APatientID :  患者登记RowID
/// Return: 新生儿子女的MRPatientID列表,多个MRPatientID之间以^分割
/// Debug:	w ##Class(DHCEPRFS.BL.BLMRPatient).GetChildByPatID("DHC","1")
ClassMethod GetChildByPatID(ASysCode As %String, APatientID As %String) As %String
{
	s childMRPatID = ""
	
	s rowID = ""
	for {
		s rowID = $O(^DHCEPRFS.INST.MRPatientI("IdxMotherPatientID", " "_ASysCode, " "_APatientID, rowID))
		q:(rowID="")
		
		if (childMRPatID = "")
		{	s childMRPatID = rowID}
		else
		{	s childMRPatID = childMRPatID_"^"_rowID}	
	}
	
	q childMRPatID
}

/// Desc:	根据母亲的MRPatientID获取其新生儿子女的MRPatientID列表
/// Input:	AMRPatientID : 归档患者登记RowID
/// Return: 新生儿子女的MRPatientID列表,多个MRPatientID之间以^分割
/// Debug:	w ##Class(DHCEPRFS.BL.BLMRPatient).GetChildByMRPatID("1")
ClassMethod GetChildByMRPatID(AMRPatientID As %String) As %String
{
	s childMRPatID = ""
	
	s objMRPatient = ##Class(DHCEPRFS.INST.MRPatient).%OpenId(AMRPatientID)
	q:(objMRPatient="") childMRPatID
	
	s sysCode = objMRPatient.SysCode
	s patID = objMRPatient.PatientID
	
	s childMRPatID = ..GetChildByPatID(sysCode, patID)
	
	q childMRPatID
}

/// debug: w ##class(DHCEPRFS.BL.BLMRPatient).GetPatientInfoByMRMedRecordNo("17")
ClassMethod GetPatientInfoByMRMedRecordNo(AMRMedRecordNo As %String) As DHCEPRFS.Entity.EMRPatient
{
	s id = ""
	s type = ""
	s AMRMedRecordNo = $zcvt(AMRMedRecordNo,"U")
	
	s objMRMedRecord = ##class(DHCEPRFS.INST.MRMedRecord).%OpenId(AMRMedRecordNo)
	s mrPatientID = objMRMedRecord.MRPatientID
	s medRecordNo = objMRMedRecord.MedRecordNo

	s obj = ##class(DHCEPRFS.INST.MRPatient).%OpenId(mrPatientID)
	s patientID = obj.PatientID
	
	if ($e(patientID,1,2) '= "VP")
	{
		d obj.%Close()
	
		d ..UpdateMRPatient(patientID,"DHC","",medRecordNo)
		s obj = ##class(DHCEPRFS.INST.MRPatient).%OpenId(mrPatientID)
	}
	s entity = ##class(DHCEPRFS.Entity.EMRPatient).%New()
	s entity.ID = mrPatientID
	s entity.MedRecordNo = medRecordNo
	s entity.AdmCount = obj.AdmCount
	s entity.Age = obj.Age
	s entity.AgeDay = obj.AgeDay
	s entity.AgeMonth = obj.AgeMonth
	if (obj.Birthday '= "")
	{
		s entity.Birthday = $zd(obj.Birthday,3)
	}
	else
	{
		s entity.Birthday = ""	
	}
	s entity.CardType = obj.CardType
	s entity.CardTypeID = obj.CardTypeID
	s entity.Company = obj.Company
	s entity.CompanyCode = obj.CompanyCode
	s entity.CreateDate = obj.CreateDate
	s entity.CreateTime = obj.CreateTime
	s entity.Gender = obj.Gender
	s entity.GovCardno = obj.GovCardno
	s entity.HouseAddress = obj.HouseAddress
	s entity.HouseArea = obj.HouseArea
	s entity.HouseAreaID = obj.HouseAreaID
	s entity.HouseCity = obj.HouseCity
	s entity.HouseCityID = obj.HouseCityID
	s entity.HouseProvince = obj.HouseProvince
	s entity.HouseProvinceID = obj.HouseProvinceID
	s entity.HouseZipCode = obj.HouseZipCode
	s entity.IDCard = obj.IDCard
	s entity.InCount = obj.InCount
	s entity.InsuNo = obj.InsuNo
	s entity.InsuType = obj.InsuType
	s entity.InsuTypeID = obj.InsuTypeID
	s entity.LastModifyDate = obj.LastModifyDate
	s entity.LastModifyTime = obj.LastModifyTime
	s entity.LinkName = obj.LinkName
	s entity.LinkPhone = obj.LinkPhone
	s entity.LinkRelation = obj.LinkRelation
	s entity.LinkRelationID = obj.LinkRelationID
	s entity.Marriage = obj.Marriage
	s entity.MarriageID = obj.MarriageID
	s entity.MotherPatientID = obj.MotherPatientID
	s entity.Name = obj.Name
	s entity.Nationality = obj.Nationality
	s entity.NationalityID = obj.NationalityID
	s entity.Occupation = obj.Occupation
	s entity.OPCardID = obj.OPCardID
	s entity.OPCardType = obj.OPCardType
	s entity.OPCardTypeID = obj.OPCardTypeID
	s entity.PatientID = obj.PatientID
	s entity.PhoneNo = obj.PhoneNo
	s entity.RegNo = obj.RegNo
	s entity.ResidentAddress = obj.ResidentAddress
	s entity.ResidentArea = obj.ResidentArea
	s entity.ResidentAreaID = obj.ResidentAreaID
	s entity.ResidentCity = obj.ResidentCity
	s entity.ResidentCityID = obj.ResidentCityID
	s entity.ResidentProvince = obj.ResidentProvince
	s entity.ResidentProvinceID = obj.ResidentProvinceID
	s entity.ResidentZipCode = obj.ResidentZipCode
	s entity.SysCode = obj.SysCode
	s entity.Worktel = obj.Worktel
	s entity.AliasName = obj.AliasName
	s entity.AliasNameInitial = obj.AliasNameInitial
	s entity.ObservedNo = obj.ObservedNo
	
	q entity
}

/// debug: w ##class(DHCEPRFS.BL.BLMRPatient).CreateFSMRPatient()
ClassMethod CreateFSMRPatient() As %String
{
	s obj = ##class(DHCEPRFS.INST.MRPatient).%New()
	s obj.SysCode = "DHC"
	s obj.CreateDate = $p($h,",",1)
	s obj.CreateTime = $p($h,",",2)
	s obj.LastModifyDate = $p($h,",",1)
	s obj.LastModifyTime = $p($h,",",2)
	s status = obj.%Save()
	if ($$$ISOK(status))
	{
		s id =  obj.%Id()
		s patientID = "VP"_id
		s obj.PatientID = patientID
		s status = obj.%Save()
		if ($$$ISOK(status))
		{
			q obj.%Id()
		}
		else
		{
			q "-2"	
		}
	}
	else
	{
		q "-1"
	}
}

/// do ##Class(DHCEPRFS.BL.BLMRPatient).Test()
ClassMethod Test()
{
	s EP = ##Class(DHCEPRFS.Entity.EMRPatient).%New()
	s EP.MedRecordNo = J100005
	//s EP.Name = "dfd"
	s obj = ##Class(%ResultSet).%New("DHCEPRFS.BL.BLMRMedRecord:GetMedRecordInfo")
	d obj.Execute(EP)
	while (obj.Next())
	{
		w obj.Data("MRMedRecordNo")
	}
}

ClassMethod SaveMRPatientInfo(AEntity As DHCEPRFS.Entity.EMRPatient) As %String
{
	s mrPatientID = AEntity.ID
	q:(mrPatientID = "") "-1"
	s obj = ##class(DHCEPRFS.INST.MRPatient).%OpenId(mrPatientID)	
	s obj.LastModifyDate = $p($h,",",1)
	s obj.LastModifyTime = $p($h,",",2)
	
	s AMedRecordNo = $zcvt(AEntity.MedRecordNo,"U")
	s obj.MedRecordNo = AMedRecordNo
	
	s obj.PatientID = AEntity.PatientID
	s obj.Name = AEntity.Name
	s obj.Gender = AEntity.Gender
	s:(AEntity.Birthday = $c(0)) AEntity.Birthday = ""
	if (AEntity.Birthday '= "")
	{
		s AEntity.Birthday = $zdh(AEntity.Birthday,3)	
	}
	s obj.Birthday = AEntity.Birthday
	s obj.Age = AEntity.Age
	s obj.Nationality = AEntity.Nationality
	s obj.Marriage = AEntity.Marriage
	s obj.Occupation = AEntity.Occupation
	s obj.Company = AEntity.Company
	s obj.IDCard = AEntity.IDCard
	s obj.PhoneNo = AEntity.PhoneNo
	s obj.ResidentProvince = AEntity.ResidentProvince
	s obj.ResidentCity = AEntity.ResidentCity
	s obj.ResidentArea = AEntity.ResidentArea
	s obj.ResidentAddress = AEntity.ResidentAddress
	s obj.HouseProvince = AEntity.HouseProvince
	s obj.HouseCity = AEntity.HouseCity
	s obj.HouseArea = AEntity.HouseArea
	s obj.HouseAddress = AEntity.HouseAddress
	s obj.LinkName = AEntity.LinkName
	s obj.LinkRelation = AEntity.LinkRelation
	s obj.LinkPhone = AEntity.LinkPhone
	s obj.AliasName = AEntity.AliasName
	s obj.AliasNameInitial = AEntity.AliasNameInitial
	
	s status = obj.%Save()
	if ($$$ISOK(status))
	{
		q obj.%Id()
	}
	else
	{
		q "-1"	
	}
}

ClassMethod CreateFSMREpisodePat(AMREpisodeID As %String, AEpisodeID As %String, AMRPatientID As %String, AMRMedRecordID As %String, AMedRecordNo As %String)
{
	s obj = ##class(DHCEPRFS.INST.MREpisodePat).%New()
	s obj.EpisodeID = AEpisodeID
	s obj.MREpisodeID = AMREpisodeID
	s obj.MRPatientID = AMRPatientID
	s obj.MRMedRecordID = AMRMedRecordID
	
	s objMREpisode = ##class(DHCEPRFS.INST.MREpisode).%OpenId(AMREpisodeID)
	
	s obj.MedRecordNo = objMREpisode.MedRecordNo
	
	s obj.CreateDate = $p($h,",",1)
	s obj.CreateTime = $p($h,",",2)
	s obj.LastModifyDate = $p($h,",",1)
	s obj.LastModifyTime = $p($h,",",2)
	
	s objPatient = ##class(DHCEPRFS.INST.MRPatient).%OpenId(AMRPatientID)

	s obj.SysCode = objPatient.SysCode
	s obj.PatientID = objPatient.PatientID
	s obj.IDCard = objPatient.IDCard
	s obj.Name = objPatient.Name
	s obj.MedRecordNo = objPatient.MedRecordNo	
	s obj.CompanyCode = objPatient.CompanyCode
	s obj.AdmCount =  objPatient.AdmCount
    s obj.InCount = objPatient.InCount
    s obj.RegNo = objPatient.RegNo
    s obj.Gender = objPatient.Gender
    s obj.Birthday = objPatient.Birthday
    s obj.Age = objPatient.Age
    s obj.AgeMonth = objPatient.AgeMonth
    s obj.AgeDay = objPatient.AgeDay
    s obj.Marriage = objPatient.Marriage
    s obj.Nationality = objPatient.Nationality
    s obj.CardType = objPatient.CardType
    s obj.GovCardno = objPatient.GovCardno
    s obj.OPCardType = objPatient.OPCardType
    s obj.OPCardID = objPatient.OPCardID
    s obj.InsuType = objPatient.InsuType
    s obj.InsuNo = objPatient.InsuNo
    s obj.PhoneNo = objPatient.PhoneNo
    s obj.LinkName = objPatient.LinkName
    s obj.LinkRelation = objPatient.LinkRelation
    s obj.LinkPhone = objPatient.LinkPhone
    s obj.Occupation = objPatient.Occupation
    s obj.Company = objPatient.Company
    s obj.Worktel = objPatient.Worktel
    s obj.HouseProvince = objPatient.HouseProvince
    s obj.HouseCity = objPatient.HouseCity
    s obj.HouseArea = objPatient.HouseArea
    s obj.HouseAddress = objPatient.HouseAddress
    s obj.HouseZipCode = objPatient.HouseZipCode
    s obj.ResidentProvince = objPatient.ResidentProvince
    s obj.ResidentCity = objPatient.ResidentCity
    s obj.ResidentArea = objPatient.ResidentArea
    s obj.ResidentAddress = objPatient.ResidentAddress
    s obj.ResidentZipCode = objPatient.ResidentZipCode
    s obj.MarriageID = objPatient.MarriageID 
    s obj.NationalityID = objPatient.NationalityID
    s obj.CardTypeID = objPatient.CardTypeID
    s obj.OPCardTypeID = objPatient.OPCardTypeID
    s obj.InsuTypeID = objPatient.InsuTypeID
    s obj.LinkRelationID = objPatient.LinkRelationID
    s obj.HouseCity = objPatient.HouseCity
    s obj.HouseProvinceID = objPatient.HouseProvinceID
    s obj.HouseCityID = objPatient.HouseCityID
    s obj.HouseAreaID = objPatient.HouseAreaID
    s obj.ResidentProvinceID = objPatient.ResidentProvinceID
    s obj.ResidentCityID = objPatient.ResidentCityID
    s obj.ResidentAreaID = objPatient.ResidentAreaID
	s obj.MotherPatientID = objPatient.MotherPatientID
	s obj.AliasName = objPatient.AliasName
	s obj.AliasNameInitial = objPatient.AliasNameInitial
	s obj.ObservedNo = objPatient.ObservedNo
	s status = obj.%Save()
	if ($$$ISOK(status))
	{
		q obj.%Id()
	}
	else
	{
		q "-1"
	}
}

ClassMethod UpdateFSMREpisodePat(AMREpisodePatID As %String, AMRPatientID As %String, AMedRecordNo As %String) As %String
{
	s obj = ##class(DHCEPRFS.INST.MREpisodePat).%OpenId(AMREpisodePatID)

	s obj.MedRecordNo = AMedRecordNo
	
	s objPatient = ##class(DHCEPRFS.INST.MRPatient).%OpenId(AMRPatientID)

	s obj.SysCode = objPatient.SysCode
	s obj.IDCard = objPatient.IDCard
	s obj.Name = objPatient.Name
	s obj.MedRecordNo = objPatient.MedRecordNo	
	s obj.CompanyCode = objPatient.CompanyCode
	s obj.AdmCount =  objPatient.AdmCount
    s obj.InCount = objPatient.InCount
    s obj.RegNo = objPatient.RegNo
    s obj.Gender = objPatient.Gender
    s obj.Birthday = objPatient.Birthday
    s obj.Age = objPatient.Age
    s obj.AgeMonth = objPatient.AgeMonth
    s obj.AgeDay = objPatient.AgeDay
    s obj.Marriage = objPatient.Marriage
    s obj.Nationality = objPatient.Nationality
    s obj.CardType = objPatient.CardType
    s obj.GovCardno = objPatient.GovCardno
    s obj.OPCardType = objPatient.OPCardType
    s obj.OPCardID = objPatient.OPCardID
    s obj.InsuType = objPatient.InsuType
    s obj.InsuNo = objPatient.InsuNo
    s obj.PhoneNo = objPatient.PhoneNo
    s obj.LinkName = objPatient.LinkName
    s obj.LinkRelation = objPatient.LinkRelation
    s obj.LinkPhone = objPatient.LinkPhone
    s obj.Occupation = objPatient.Occupation
    s obj.Company = objPatient.Company
    s obj.Worktel = objPatient.Worktel
    s obj.HouseProvince = objPatient.HouseProvince
    s obj.HouseCity = objPatient.HouseCity
    s obj.HouseArea = objPatient.HouseArea
    s obj.HouseAddress = objPatient.HouseAddress
    s obj.HouseZipCode = objPatient.HouseZipCode
    s obj.ResidentProvince = objPatient.ResidentProvince
    s obj.ResidentCity = objPatient.ResidentCity
    s obj.ResidentArea = objPatient.ResidentArea
    s obj.ResidentAddress = objPatient.ResidentAddress
    s obj.ResidentZipCode = objPatient.ResidentZipCode
    s obj.MarriageID = objPatient.MarriageID 
    s obj.NationalityID = objPatient.NationalityID
    s obj.CardTypeID = objPatient.CardTypeID
    s obj.OPCardTypeID = objPatient.OPCardTypeID
    s obj.InsuTypeID = objPatient.InsuTypeID
    s obj.LinkRelationID = objPatient.LinkRelationID
    s obj.HouseCity = objPatient.HouseCity
    s obj.HouseProvinceID = objPatient.HouseProvinceID
    s obj.HouseCityID = objPatient.HouseCityID
    s obj.HouseAreaID = objPatient.HouseAreaID
    s obj.ResidentProvinceID = objPatient.ResidentProvinceID
    s obj.ResidentCityID = objPatient.ResidentCityID
    s obj.ResidentAreaID = objPatient.ResidentAreaID
	s obj.MotherPatientID = objPatient.MotherPatientID
	s obj.AliasName = objPatient.AliasName
	s obj.AliasNameInitial = objPatient.AliasNameInitial
	s obj.ObservedNo = objPatient.ObservedNo
	s status = obj.%Save()
	if ($$$ISOK(status))
	{
		q obj.%Id()
	}
	else
	{
		q "-1"
	}
}

/// do ##Class(DHCEPRFS.BL.BLMRPatient).SaveMRPatientLog("37","MEDRECORD","MODIFY","J100005","295264","","")
ClassMethod SaveMRPatientLog(AUserID As %String, AType As %String, AOperatorType As %String, MedRecordNo As %String, MRMedRecordNo As %String, EpisodeID As %String = "", MREpisodeID As %String = "") As %String
{
	b "s"
	s obj = ##class(DHCEPRFS.INST.InputMedLog).%New()
	s obj.UserID = AUserID
	s obj.AType = AType
	s obj.ActiveType = AOperatorType
	s obj.ActiveDate = $p($h,",",1)
	s obj.ActiveTime = $p($h,",",2)
	s obj.MedRecordNo = MedRecordNo
	s obj.MRMedRecordNo = MRMedRecordNo
	s obj.EpisodeID = EpisodeID
	s obj.MREpisodeID = MREpisodeID
	
	s status = obj.%Save()
	if ($$$ISOK(status))
	{
		q obj.%Id()	
	}
	else
	{
		q "-1"	
	}
}

}
