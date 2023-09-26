/// 名称: DHCEPRFS.Tool.InitOldMedRecord
/// 描述: 第三方历史患者基本信息和就诊信息，采集到病案归档系统
/// 编写者：yangshun
/// 编写日期: 2022-08-02
Class DHCEPRFS.Tool.InitOldMedRecord Extends %RegisteredObject [ ProcedureBlock ]
{

/// Creator：     yangshun
/// CreatDate：   2022-08-02
/// Description:  将数据采集到归档患者基本信息表、病案表、就诊信息表、患者基本信息就诊表
/// Table：       DHCEPRFS.INST.OldMedRecordInfo、DHCEPRFS.INST.MRPatient、DHCEPRFS.INST.MRMedRecord、DHCEPRFS.INST.MREpisode、DHCEPRFS.INST.MREpisodePat
/// Input：       AStart: 开始导入位置  Flag : " "--病案号是东华his有的； "VM"--病案号是东华his不存在
/// Return：      返回采集的数据记录数
/// d ##Class(DHCEPRFS.Tool.InitOldMedRecord).RegMRPatientID(0,"")
ClassMethod RegMRPatientID(AStart As %Integer, Flag As %String = "") As %String
{
	s ASysCode = "DHC",OldMedRecordInfoID = "",ret=0,mrMedRecordID = "",count=0
	s $ZTRAP = "OnRegMRError"
	if (AStart>0)
	{
		for i=1:1:AStart
		{
			s OldMedRecordInfoID=$o(^DHCEPRFS.INST.OldMedRecD(OldMedRecordInfoID))
			q:(OldMedRecordInfoID = "")
		}
	}
	for {
		s OldMedRecordInfoID=$o(^DHCEPRFS.INST.OldMedRecD(OldMedRecordInfoID))
		q:(OldMedRecordInfoID = "")
		
		s objOldMedRecordInfo=^DHCEPRFS.INST.OldMedRecD(OldMedRecordInfoID)
		s PatientID=$list(objOldMedRecordInfo,20) 
		s OldPatientID=$list(objOldMedRecordInfo,4) 
		s OldMedRecordNo=$list(objOldMedRecordInfo,18)
		s OldEpisodeID=$list(objOldMedRecordInfo,5)
		
		continue:((PatientID= "")&&(OldPatientID= ""))||(OldMedRecordNo="")||(OldEpisodeID="")
		s MedRecordNo=Flag_OldMedRecordNo
		s (mrPatientID,mrMedRecordID,tmpPatientID,MREpisodeID,MREpisodePatID) =""
		TSTART
		
		s papatmasID =..GetPatientIDByIDCard($list(objOldMedRecordInfo,3))
		
		i ((PatientID'= "")||(papatmasID'=""))
		{
			
			s:(papatmasID'="") PatientID=papatmasID
			s tmpPatientID=PatientID
			s mrPatientID = ##Class(DHCEPRFS.BL.BLMRPatient).GetMRPatientID(tmpPatientID, ASysCode)
			
			i mrPatientID="" s mrPatientID = ..CreateMRPatient(PatientID, ASysCode,"","","",MedRecordNo)			
		}
		else{
			
			s tmpPatientID="VP"_OldPatientID
			s mrPatientID = ##Class(DHCEPRFS.BL.BLMRPatient).GetMRPatientID(tmpPatientID, ASysCode)
			i mrPatientID="" s mrPatientID =..CreateMROldPatient(OldMedRecordInfoID,Flag)	
		}
		i mrPatientID'="" 
		{
			
			s mrMedRecordID= ..RegMRMedRecord(mrPatientID,MedRecordNo)
			s AEpisodeID=OldEpisodeID ;"VE"_OldEpisodeID
			i mrMedRecordID'=""{
				s MREpisodeID= ..RegMREpisodeID(mrPatientID,MedRecordNo,AEpisodeID,OldMedRecordInfoID,mrMedRecordID)
			}
			else{
				TROLLBACK	
			}
			i MREpisodeID'=""  
			{
				i tmpPatientID'["VP" s MREpisodePatID =..CreateMRPatient(PatientID, ASysCode,AEpisodeID,mrPatientID,mrMedRecordID,MedRecordNo)
				e  s MREpisodePatID =..CreateMROldPatient(OldMedRecordInfoID,Flag,mrPatientID,mrMedRecordID,MREpisodeID)
				i MREpisodePatID'="" 
				{
					TCOMMIT
					s count=count+1
				}else{
					TROLLBACK	
				}
			}else{
				TROLLBACK	
			}
		}else{
			TROLLBACK	
		}
	}
	w "count:"_count,!
	q count
OnRegMRError
	TROLLBACK
	q "0"
}

/// /s ret= ##Class(DHCEPRFS.Tool.InitOldMedRecord).CreateEMRPatientDHC("create","3066880","DHC","24544859","IP001472725900")
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
	
	s entity.MedRecordNo = AMedRecordNo
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
	
	s entity.AdmCount = 1 ;##Class(DHCEPRFS.BL.HISInfo.BLPatientInfo).GetAdmCount(APatientID)  //这里
    s entity.InCount = 1 ;##Class(DHCEPRFS.BL.HISInfo.BLPatientInfo).GetInCount(APatientID)
    s entity.RegNo = ##Class(DHCEPRFS.BL.HISInfo.BLPatientInfo).GetRegNo(APatientID)
    s entity.Gender = $P(##Class(DHCEPRFS.BL.HISInfo.BLPatientInfo).GetGender(APatientID),"^",3)
    s entity.Birthday = ##Class(DHCEPRFS.BL.HISInfo.BLPatientInfo).GetBirthday(APatientID)
    s age = "" ;##class(DHCEPRFS.BL.HISInfo.BLEpisodeInfo).GetAge(AEpisodeID)
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
	s entity.ObservedNo = "" ;##Class(DHCEPRFS.BL.HISInfo.BLPatientInfo).GetObservedNo(APatientID)
	
	q entity
}

/// Desc:	创建MRPatient
ClassMethod CreateMRPatient(APatientID As %String, ASysCode As %String, AEpisodeID As %String = "", AMRPatientID As %String = "", AMRMedRecordID As %String = "", AMedRecordNo As %String = "") As %String
{
	//此处可通过适配器适配其他系统患者基本信息
	
	s entity = ..CreateEMRPatientDHC("create",APatientID, ASysCode,AEpisodeID,AMedRecordNo)
	
	;s CreateDate=$zdh("2020-07-10",3) 
	
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

/// Desc:	用第三方his系统病人号创建MRPatient
ClassMethod CreateMROldPatient(OldMedRecordInfoID As %String, Flag As %String, AMRPatientID As %String = "", AMRMedRecordID As %String = "", AMREpisodeID As %String = "") As %String
{
	
	s objOldMedRecordInfo=^DHCEPRFS.INST.OldMedRecD(OldMedRecordInfoID)
	s Name=$list(objOldMedRecordInfo,2)
	s IDCard=$list(objOldMedRecordInfo,3)
	s OldPatientID=$list(objOldMedRecordInfo,4)
	s OldEpisodeID=$list(objOldMedRecordInfo,5)
	s OldRegNo=$list(objOldMedRecordInfo,6)
	s Gender=$list(objOldMedRecordInfo,21)
	s Birthday=$list(objOldMedRecordInfo,22)
	s ResidentProvince=$list(objOldMedRecordInfo,23)
	s ResidentCity=$list(objOldMedRecordInfo,24)
	s ResidentArea=$list(objOldMedRecordInfo,25)
	s ResidentAddress=$list(objOldMedRecordInfo,26)
	s ResidentZipCode=$list(objOldMedRecordInfo,27)
	s OldMedRecordNo=$list(objOldMedRecordInfo,18)
	if (AMRPatientID '= "")
	{
		s obj = ##Class(DHCEPRFS.INST.MREpisodePat).%New()
		s obj.EpisodeID = OldEpisodeID ;"VE"_OldEpisodeID
		s obj.MREpisodeID = AMREpisodeID
		s obj.MRPatientID = AMRPatientID
		s obj.MRMedRecordID = AMRMedRecordID
	}
	else
	{
		s obj = ##Class(DHCEPRFS.INST.MRPatient).%New()
	}
	//s obj = ##Class(DHCEPRFS.INST.MRPatient).%New() 不需要
	s obj.SysCode = "DHC"
	s obj.PatientID = "VP"_OldPatientID
	s obj.MedRecordNo = Flag_OldMedRecordNo
	s obj.IDCard = IDCard
	s obj.Name = Name
	s obj.CreateDate = $p($h,",",1) 
	s obj.CreateTime = $p($h,",",2) 
	s obj.LastModifyDate =  $p($h,",",1) 
	s obj.LastModifyTime = $p($h,",",2) 
    s obj.RegNo = OldRegNo
    s obj.Gender = Gender
    s obj.Birthday = $zdh(Birthday,5)
    s obj.ResidentProvince = ResidentProvince
    s obj.ResidentCity = ResidentCity
    s obj.ResidentArea = ResidentArea
    s obj.ResidentAddress = ResidentAddress
    s obj.ResidentZipCode = ResidentZipCode
	s obj.AliasName = ##Class(DHCEPRFS.Util.StringHelper).GetCNCODE(Name,3,"")
	s obj.AliasNameInitial = ##Class(DHCEPRFS.Util.StringHelper).GetCNCODE(Name,4,"")
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

/// d ##Class(DHCEPRFS.Tool.InitOldMedRecord).RegMRMedRecord()
ClassMethod RegMRMedRecord(MRPatientID As %String, MedRecordNo As %String) As %String
{
	s ASysCode = "DHC",ret=0,mrMedRecordID = ""
	
	s mrMedRecordID = ##Class(DHCEPRFS.BL.BLMRMedRecord).GetMRMedRecord(MedRecordNo, ASysCode)
	q:mrMedRecordID'="" mrMedRecordID
	s mrMedRecordID = ..CreateMRMedRecord(MRPatientID, MedRecordNo, ASysCode)
	q mrMedRecordID
}

ClassMethod CreateMRMedRecord(AMRPatientID As %String, AMedRecordNo As %String, ASysCode As %String = "DHC") As %String
{
	s obj = ##class(DHCEPRFS.INST.MRMedRecord).%New()
	s obj.CreateDate = $p($h,",",1)
	s obj.CreateTime = $p($h,",",2)
	s obj.LastModifyDate = $p($h,",",1)
	s obj.LastModifyTime = $p($h,",",2)
	s obj.MedRecordNo = AMedRecordNo
	s obj.MRPatientID = AMRPatientID
	s obj.SysCode = ASysCode
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

/// d ##Class(DHCEPRFS.Tool.InitOldMedRecord).RegMREpisodeID()
/// Desc:	注册MREpisode对象并获取其RowID
ClassMethod RegMREpisodeID(AMRPatientID As %String, AMRMedRecordNo As %String, AEpisodeID As %String, OldMedRecordInfoID As %String, AMRMedRecordID As %String = "") As %String
{
	q:(AMRPatientID="")||(AMRMedRecordNo="")||(AEpisodeID="")||(OldMedRecordInfoID="") ""
	s ASysCode = "DHC",ret=0
	
	s mrEpisodeID = ##Class(DHCEPRFS.BL.BLMREpisode).GetMREpisodeID(AMRPatientID, AEpisodeID, ASysCode)
	q:mrEpisodeID'="" mrEpisodeID
	;b ;w "RegMREpisodeID",!
	s mrEpisodeID = ..CreateMREpisode(AMRPatientID, AEpisodeID, ASysCode, AMRMedRecordNo,OldMedRecordInfoID,AMRMedRecordID)
	q mrEpisodeID
}

/// Desc:	创建CreateMREpisode
ClassMethod CreateMREpisode(AMRPatientID As %String, AEpisodeID As %String, ASysCode As %String = "DHC", AMRMedRecordNo As %String, OldMedRecordInfoID As %String, AMRMedRecordID As %String = "") As %String
{
	;b ;CreateMREpisode
	s objOldMedRecordInfo=^DHCEPRFS.INST.OldMedRecD(OldMedRecordInfoID)
	;b ;objOldMedRecordInfo
	s AdmDateTime=$list(objOldMedRecordInfo,7)
	s AdmDate = $P(AdmDateTime," ",1)
	s AdmTime = $P(AdmDateTime," ",2)
	s:AdmDate'="" AdmDate=$zdh(AdmDate,5)
	s:(AdmTime'="") AdmTime = $zth(AdmTime)
	s DisDateTime=$list(objOldMedRecordInfo,8)
	s DisDate = $P(DisDateTime," ",1)
	s DisTime = $P(DisDateTime," ",2)
	s:DisDate'="" DisDate=$zdh(DisDate,5)
	s:(DisTime'="") DisTime = $zth(DisTime)
	s AdmLocID=$list(objOldMedRecordInfo,9)
	s AdmLoc=$list(objOldMedRecordInfo,10)
	s DisLocID=$list(objOldMedRecordInfo,11)
	s DisLoc=$list(objOldMedRecordInfo,12)
	s AdmWard=$list(objOldMedRecordInfo,13)
	s DisWard=$list(objOldMedRecordInfo,14)
	s MainDoctor=$list(objOldMedRecordInfo,15)
	s AdmWardID=$list(objOldMedRecordInfo,16)
	s DisWardID=$list(objOldMedRecordInfo,17)
	s AdmType=$list(objOldMedRecordInfo,19)
	;b ;"进来了"
	s:AMRMedRecordID="" AMRMedRecordID = ##Class(DHCEPRFS.BL.BLMRMedRecord).GetMRMedRecord(AMRMedRecordNo, ASysCode)
	q:AMRMedRecordID="" ""
	;s CreateDate=$zdh("2020-07-10",3) 
	;b ;AMRMedRecordID
	s obj = ##Class(DHCEPRFS.INST.MREpisode).%New()
	s obj.MRPatientID = AMRPatientID 
	s obj.MRMedRecordID = AMRMedRecordID
	s obj.SysCode = ASysCode
	s obj.EpisodeID = AEpisodeID
	s obj.AdmDate = AdmDate
	s obj.AdmTime = AdmTime
	s obj.CreateDate = $p($h,",",1)
	s obj.CreateTime = $p($h,",",2)
	s obj.LastModifyDate = $p($h,",",1)
	s obj.LastModifyTime = $p($h,",",2)
	s obj.MedRecordNo = AMRMedRecordNo
	s obj.DisDate = DisDate
	s obj.DisTime = DisTime
	s obj.AdmLoc = AdmLoc
	s obj.AdmWard = AdmWard
	s obj.DisLoc = DisLoc
	s obj.DisWard = DisWard
	s obj.MainDoctor = MainDoctor
	s obj.AdmType = AdmType
	s obj.AdmLocID = AdmLocID
	s obj.AdmWardID = AdmWardID
	s obj.DisLocID = DisLocID
	s obj.DisWardID = DisWardID
	
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

/// Desc: 导入历史数据到中间表
/// Input: AStart 起始行 ACount 起始行后读入行数 这两个参数是方便测试以及测试完后的全部导入
/// Acount 为0时，会把后面的全部读完
/// Debug: d ##class(DHCEPRFS.Tool.InitOldMedRecord).InitOldMedRecordByFile(1,1000)
ClassMethod InitOldMedRecordByFile(AStart As %Integer, ACount As %Integer)
{
	s path = "d:\dhceprfs\patient.txt"
	s isExisted = ##class(%File).Exists(path) 
	If ('isExisted)
 	{
	 	Write "fliel is not exist!",!
	 	quit
 	}
 	w "+++++++++++ init OldMedRecordInfo started!",!
	
	s failCount = 0, okCount =0, totCount = 0, invalid = 0
	Set fs = ##class(%FileCharacterStream).%New()
	Set fs.Filename = path
	for i=1:1:AStart
	{
		d fs.ReadLine()
	}
	if (ACount>0)
	{
		for i=1:1:ACount
		{
			s sRec = fs.ReadLine()
			s isOK = ..AddOldMedRecordInfo(sRec)
			s totCount = totCount + 1
			if (isOK="1")
			{
				s okCount = okCount + 1
			}
			else
			{
				s failCount = failCount + 1
			}
			q:(fs.AtEnd)
		}
	}
	else
	{
		While 'fs.AtEnd {
			s sRec = fs.ReadLine()
			s isOK = ..AddOldMedRecordInfo(sRec)
			s totCount = totCount + 1
			if (isOK="1")
			{
				s okCount = okCount + 1
			}
			else
			{
				s failCount = failCount + 1
			}
	
		} 
	}
	d fs.%Close()
	s fs = ""
	
	w !, "+++++++++++totCount:"_totCount_", okCount:"_okCount_", failCount:"_failCount_",invalide:"_invalid
	w !, "+++++++++++init OldMedRecordInfo finished!"
	
	quit
}

/// Desc: 通过身份证号，获取PatientID
/// Creator: yangshun 2022-08-02
/// Debug: w ##class(DHCEPRFS.Tool.InitOldMedRecord).GetPatientIDByIDCard("610326197310011211")
ClassMethod GetPatientIDByIDCard(AIDCard As %String) As %String
{
	s id = ""
	s id = $O(^PAPERi("PAPMI_ICPPBC",AIDCard_"Z",""))
	q id
}

/// Desc: 将读取的一行导入OldMedRecordInfo里面
/// Creator: yangshun 2022-08-02
/// Input: ARec 读取的一行
/// Return: 1 加入成功 -1 这行没有数据 -2 身份证号不合理 -3 重复数据 -4 其他
ClassMethod AddOldMedRecordInfo(ARec As %String) As %String
{
	s sRec = $tr(ARec,$c(13),"")
	q:(sRec = "") "-1"
	s oldRegNo = "DR"_$E($p(sRec, $c(9), 2),3,10)  //对方要求his没有的患者登记号用DR开始
	s name = $p(sRec, $c(9), 3)
	s gender = $p(sRec, $c(9), 4)
	s birthday = $p(sRec, $c(9), 5)  //生日格式为1999/10/10
	s idcard = $p(sRec, $c(9), 6)
	q:($L(idcard)'=18) "-2"
	s residentPro = $p(sRec, $c(9), 7)
	s:(residentPro="-") residentPro=""  //无效字段设为""
	s residentCity = $p(sRec, $c(9), 8)
	s:(residentCity="-") residentCity=""
	s residentArea = $p(sRec, $c(9), 9)
	s:(residentArea="-") residentArea=""
	s residentAddress = $p(sRec, $c(9), 10)
	s:(residentAddress="-") residentAddress=""
	s residentZipCode = $p(sRec, $c(9), 11)
	s:(residentZipCode="-") residentZipCode=""
	s oldPatientID = $p(sRec, $c(9), 12)
	s oldEpisodeID = $p(sRec, $c(9), 13)
	s admDateTime = $p(sRec, $c(9), 14) 
	s disDateTime = $p(sRec, $c(9), 15)
	s admLoc = $p(sRec, $c(9), 16)
	s disLoc = $p(sRec, $c(9), 17)
	s admWard = $p(sRec, $c(9), 18)
	s disWard = $p(sRec, $c(9), 19)
	s locChief = $p(sRec, $c(9), 20)
	s chiefDoc = $p(sRec, $c(9), 21)
	s mainDoc = $p(sRec, $c(9), 22)
	s inDoc = $p(sRec, $c(9), 23)
	s oldMedRecord = $p(sRec, $c(9), 24)
	
	q:($O(^DHCEPRFS.INST.OldMedRecI("IdxOldEpisodeID"," "_oldEpisodeID,""))'="") "-3" //去重
	s obj = ##class(DHCEPRFS.INST.OldMedRecordInfo).%New()
	s obj.OldRegNo = oldRegNo
	s obj.Name = name
	s obj.Gender = gender
	s obj.Birthday = birthday
	s obj.IDCard = idcard
	s obj.ResidentProvince = residentPro
	s obj.ResidentCity = residentCity
	s obj.ResidentArea = residentArea
	s obj.ResidentAddress = residentAddress
	s obj.ResidentZipCode = residentZipCode
	s obj.OldPatientID = oldPatientID
	s obj.OldEpisodeID = oldEpisodeID
	s obj.AdmDate = admDateTime
	s obj.DisDate = disDateTime
	s obj.AdmLoc = admLoc
	s obj.DisLoc = disLoc
	s obj.AdmWard = admWard
	s obj.DisWard = disWard
	s obj.MainDoctor = mainDoc
	s obj.OldMedRecordNo = oldMedRecord
	s ok = obj.%Save()
	if ($$$ISOK(ok))
	{
		q "1"
	}
	q "-4"
}

}
