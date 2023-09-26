/// HospitalName=EPRSERVER20101122
/// HospitalName=HNZLYY
/// Creator:EPR
/// CreatDate:2009-03-16
/// Name:EPRservice.SystemData
/// Desc:个性化类,取HIS以及EPR相关数据.
/// Desc:尽量保持每个Query所取信息种类以及Query返回字段名称的一致性.
/// Desc:以提高可维护性和模板的通用性.
Class EPRservice.SystemData Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// //////////////////////////
///        测试代码       ////
/// //////////////////////////
/// ##Class(EPRservice.SystemData).testpat(Adm)
/// ##Class(EPRservice.SystemData).testcliord(Adm)
/// ##Class(EPRservice.SystemData).testclidiag(Adm)
/// ##Class(EPRservice.SystemData).testlab(Adm)
/// ##Class(EPRservice.SystemData).testcheck(Adm)
/// ##Class(EPRservice.SystemData).testatd(Adm)	
/// ##Class(EPRservice.SystemData).testtmc(Adm)
/// ##Class(EPRservice.SystemData).testmc(Adm)	
/// ##Class(EPRservice.SystemData).testcus(Adm)
/// ##Class(EPRservice.SystemData).testcase(Adm)
/// ##Class(EPRservice.SystemData).testwmr(Adm)
/// ##Class(EPRservice.SystemData).testbook(Adm)
/// 
/// 
/// Creator:	HouJian
/// CreateDate:	2009-03-17
/// Desc:		[BOQueryDataService类的患者就诊信息接口]获取患者就诊信息
/// Input： 	ItemName: 就诊信息项的名称，对应于 [维护程序--〉工具--〉就诊数据项维护] 中的 [Adm字段名称]
///        		Adm: 患者就诊rowid
/// Return：    就诊信息项的Value(不含Code)
/// Test:		##Class(EPRservice.SystemData).GetEpisodeInfoByItemName()
ClassMethod GetEpisodeInfoByItemName(ItemName As %String, Adm As %String) As %String
{
	//b "s"
	q:($d(ItemName)=0||$d(Adm)=0) ""
		
	//取系统参数
	s Hospital=##class(EPRmeta.SysOption).GetOptionValueByName("HospitalName")
  	s SpaceHIS=##class(EPRmeta.SysOption).GetOptionValueByName("NameSpaceHIS")
	if SpaceHIS'=""
	{
		s MEDDATA = $p($g(SpaceHIS),"^",1)
		s WEBSRC  = $p($g(SpaceHIS),"^",2)
	}
	s SpaceLIS=##class(EPRmeta.SysOption).GetOptionValueByName("NameSpaceLIS")
	if SpaceLIS'=""
	{
	    s LABDATA = $p($g(SpaceLIS),"^",1)
	    s LABSRC  = $p($g(SpaceLIS),"^",2)
	 }
	 
	//参数空值判断
	q:((Hospital="")||(SpaceHIS="")||(SpaceLIS="")) $$$OK
	
	
	s ReturnValue=""
	s PapmiDR= ##class(EPRservice.HISInterface.PatientInfoAssist).GetPapmiDR(Adm) 

	
	/////////////////////////////////
	///      就诊数据项维护       ///
	/////////////////////////////////
 	
	if ItemName="EpisodeID"				///患者就诊RowID
	{
		set ReturnValue=Adm
	}
	elseif ItemName="DisDateTime"		///出院日期,返回cache内部格式,必须
	{
		set ReturnValue=##class(EPRservice.HISInterface.PatientInfoAssist).DisDateTime(Adm)
		set ReturnValue=$p(ReturnValue,",",1)
	}
	elseif ItemName="AdmDateTime"		///入院日期,返回cache内部格式，必须
	{
		set ReturnValue=##class(EPRservice.HISInterface.PatientInfoAssist).AdmDateTime(Adm,Hospital)
		set ReturnValue=$p(ReturnValue,",",1)
	}
	elseif ItemName="PayType"			///患者费用类型(TrakCare)
	{	
		set ReturnValue=##class(EPRservice.HISInterface.PatientInfoAssist).PayType(Adm)
	}
	elseif ItemName="Gender"			///性别		
	{
		set ReturnValue=##class(EPRservice.HISInterface.PatientInfoAssist).Gender(PapmiDR)
		set ReturnValue=$p(ReturnValue,"^",3)
	}	
	elseif ItemName="Marriage"			///婚姻
	{
		set ReturnValue=##class(EPRservice.HISInterface.PatientInfoAssist).Marriage(PapmiDR)
		set ReturnValue=$p(ReturnValue,"^",3)
	}		
	elseif ItemName="Birthday"			///出生日期
	{
		set ReturnValue=##class(EPRservice.HISInterface.PatientInfoAssist).Birthday(PapmiDR)
	}			
	elseif ItemName="Occupation"		///职业
	{
		set ReturnValue=##class(EPRservice.HISInterface.PatientInfoAssist).Occupation(PapmiDR,Hospital)
		set ReturnValue=$p(ReturnValue,"^",3)
	}				
	elseif ItemName="Age"				///年龄
	{
		set TempBirthDay=##class(EPRservice.HISInterface.PatientInfoAssist).Birthday(PapmiDR)	
  		set TempAdmDate=##class(EPRservice.HISInterface.PatientInfoAssist).AdmDateTime(Adm,Hospital)	
  		//病案年龄 N_"^"_岁			[RecordAge][RecordAgeUnit]
   		s ReturnValue = ##class(EPRservice.HISInterface.PatientInfoAssist).Age(Adm,TempBirthDay,TempAdmDate,2)
   		s ReturnValue = $p($g(tmpRecordAge),"^",1)

	}	
	elseif ItemName="Nation"			///民族
	{
		set ReturnValue=##class(EPRservice.HISInterface.PatientInfoAssist).Nation(PapmiDR,Hospital)
		set ReturnValue=$p(ReturnValue,"^",3)
	}	
	elseif ItemName="AdmDept"			///入院科室
	{
		set ReturnValue=##class(EPRservice.HISInterface.PatientInfoAssist).AdmDept(Adm)
		s ReturnValue=$p(ReturnValue,"^",3)	 
	}	
	elseif ItemName="AdmWard"			///入院病区
	{
		set ReturnValue=##class(EPRservice.HISInterface.PatientInfoAssist).AdmWard(Adm)
		s ReturnValue=$p(ReturnValue,"^",3)	 
	}	
	elseif ItemName="DisDept"			///出院科室
	{
		set ReturnValue=##class(EPRservice.HISInterface.PatientInfoAssist).DisDept(Adm)
		s ReturnValue=$p(ReturnValue,"^",3)	 
	}	
	elseif ItemName="DisWard"			///出院病区
	{
		set ReturnValue=##class(EPRservice.HISInterface.PatientInfoAssist).DisWard(Adm)
		s ReturnValue=$p(ReturnValue,"^",3)	 
	}	
	elseif ItemName="TransDept"			///转科
	{
		set ReturnValue=##class(EPRservice.HISInterface.PatientInfoAssist).TransDept(Adm)
	}	
	elseif ItemName="ResidentDays"		///住院天数
	{
		set ReturnValue=##class(EPRservice.HISInterface.PatientInfoAssist).ResidentDaysAdm(Adm,Hospital)

		//set TmpAdmDateTime=##class(EPRservice.HISInterface.PatientInfoAssist).AdmDateTime(Adm,Hospital)
		//set TmpDisDateTime=##class(EPRservice.HISInterface.PatientInfoAssist).DisDateTime(Adm)
		//set ReturnValue=##class(EPRservice.HISInterface.PatientInfoAssist).ResidentDays(TmpAdmDateTime,TmpDisDateTime)
	}
	elseif ItemName="BloodType"			///血型
	{
		set ReturnValue=##class(EPRservice.HISInterface.PatientInfoAssist).ImmuneExamBloodType(PapmiDR,Hospital,MEDDATA,LABDATA)
	}
	elseif ItemName="Name"				///姓名
	{
		s ReturnValue=##class(EPRservice.HISInterface.PatientInfoAssist).Name(PapmiDR)
	}
	elseif ItemName="AdmDoctor"			///管床医生
	{
		s ReturnValue=##class(EPRservice.HISInterface.PatientInfoAssist).AdmDoctor(Adm)
	}
		
	quit ReturnValue
}

/// ////////////////////////////////////////////////////////////////////////////////////////////////
/// Creator：	EPR
/// CreateDate：2009-03-16
/// Desc：		取患者基本信息[HIS]-01 200908OK
/// Input:		Adm: 就诊rowid
/// Return：
/// Test:		##Class(EPRservice.SystemData).testpat(Adm)		
Query GetPatientInfo(Adm As %String) As %Query(ROWSPEC = "EpisodeID,PapmiDR,EpisodeNo,RegisterNo,IPRecordNo,OPRecordNo,EPRecordNo,InsuranceNo,IDCard,CardType,CardNumber,Name,Gender,GenderDict,Birthday,Age,RecordAge,RecordAgeUnit,ClinicAge,BabyAge,Marriage,Native,BlockBirth,CityBirth,ProvinceBirth,CityBirthDesc,ProvinceBirthDesc,Occupation,OccupationDesc,Nation,NationDesc,Country,CountryDesc,PayMode,PayType,MobilePhone,LinkName,LinkRelation,LinkRelationDesc,LinkAddress,LinkPhone,WorkAddress,WorkTel,WorkPostCode,HuKouAddress,HuKouTel,HuKouPostCode,curProvince,curCity,curBlock,curStreet,HukouProvince,HuKouCity,HuKouBlock,HuKouStreet,CurAddrPostCode,ProvinceNative,CityNative")
{
}

ClassMethod GetPatientInfoExecute(ByRef qHandle As %Binary, Adm As %String) As %Status
{
	
	Set repid=$I(^CacheTemp)
	s ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:($d(^PAADM(Adm))=0)||(Adm="") $$$OK
	
	// 取系统参数
	s Hospital=##class(EPRmeta.SysOption).GetOptionValueByName("HospitalName")
  	s SpaceHIS=##class(EPRmeta.SysOption).GetOptionValueByName("NameSpaceHIS")
	if SpaceHIS'=""
	{
		s MEDDATA = $p($g(SpaceHIS),"^",1)
		s WEBSRC  = $p($g(SpaceHIS),"^",2)
	}
	s SpaceLIS=##class(EPRmeta.SysOption).GetOptionValueByName("NameSpaceLIS")
	if SpaceLIS'=""
	{
	    s LABDATA = $p($g(SpaceLIS),"^",1)
	    s LABSRC  = $p($g(SpaceLIS),"^",2)
	 }
	 
	// 参数空值判断
	Quit:((Hospital="")||(SpaceHIS="")||(SpaceLIS="")) $$$OK
	 
	 	
	
	// 初始化返回值
	
	// 患者标识号大类
	s EpisodeID="" ,PapmiDR="" ,EpisodeNo="" ,RegisterNo="" ,IPRecordNo="" ,OPRecordNo="" ,EPRecordNo="" ,InsuranceNo="" ,IDCard=""
	
	// 患者基本情况大类
	s Name="" ,Gender="" ,GenderDict="" ,Birthday="" ,ArgBirthday="" ,Age="" ,RecordAge="" ,RecordAgeUnit="" ,ClinicAge="" ,BabyAge="" ,Marriage="" ,Native="" ,CityBirth="" ,ProvinceBirth="" ,CityBirthDesc="" ,ProvinceBirthDesc="" ,Occupation="" ,Nation="" ,Country="" ,PayMode="" ,MobilePhone="",OccupationDesc="", NationDesc="", CountryDesc=""
	
	// 工作情况/户口情况/联系人情况大类
	s LinkName="" ,LinkRelation="" ,LinkRelationDesc="",LinkAddress="" ,LinkPhone="" ,WorkAddress="" ,WorkTel="" ,WorkPostCode="" ,HuKouAddress="" ,HuKouTel="" ,HuKouPostCode=""	
	
	s tmpRecordAge="" ,tmpNative="" ,tmpBirthPlace="" ,tmpOccupation="" ,tmpNation="" ,tmpCountry="" ,tmpLinkRelation=""

 	///////////////////////
 	// 患者标识号码大类  //
 	///////////////////////

 	// 标识号			[EpisodeID]			PA_Adm.PAAdm_RowID
 	s EpisodeID=Adm
 	 
 	// 登记RowId		[PapmiDR]			PA_Person.PAPER_RowId And PA_PatMas.PAPMI_PAPER_DR
 	s PapmiDR = ##Class(EPRservice.HISInterface.PatientInfoAssist).GetPapmiDR(Adm)
 	
 	// 就诊号			[EpisodeNo]			PA_Adm.PAADM_ADMNo
 	s EpisodeNo=##Class(EPRservice.HISInterface.PatientInfoAssist).GetEpisodeNo(Adm)
 	
 	// 登记号			[RegisterNo]		PA_PatMas.PAPMI_No
 	s RegisterNo = ##Class(EPRservice.HISInterface.PatientInfoAssist).GetPapmiNo(PapmiDR)
 	
 	// 住院病案号		[IPRecordNo]		PA_PatMas.PAPMI_Medicare
 	s IPRecordNo = ##class(EPRservice.HISInterface.PatientInfoAssist).IPRecordNoByMRNew(EpisodeID,Hospital)
 	
 	// 门诊病案号		[OPRecordNo]		PA_Person.PAPER_GovernCardNo
 	s OPRecordNo = ##class(EPRservice.HISInterface.PatientInfoAssist).OPRecordNo(PapmiDR,Hospital)
 	
 	// 急诊病案号		[EPRecordNo]		DHC_Person.PAPER_FCMedicareCode1
 	s EPRecordNo = ##class(EPRservice.HISInterface.PatientInfoAssist).EPRecordNo(PapmiDR,Hospital)
 	
 	// 医保号			[InsuranceNo]		PA_Person.PAPER_ID
 	s InsuranceNo=##Class(EPRservice.HISInterface.PatientInfoAssist).InsuranceNo(Adm,Hospital)
 	s:(InsuranceNo="") InsuranceNo="-"
 	
	// 身份证号			[IDCard]			PA_Person.PAPER_ID
 	s IDCard=##Class(EPRservice.HISInterface.PatientInfoAssist).IDCard(PapmiDR)

	// 证件类型			[CardType]			PA_PatMas.PAPMI_CardType_DR -> PAC_CardType.CARD_Desc
 	s CardType=##Class(EPRservice.HISInterface.PatientInfoAssist).CardType(PapmiDR)
 	i (CardType="") { s CardType ="身份证" }

	// 证件号码			[CardNumber]		PA_PatMas.PAPMI_DVAnumber
 	s CardNumber=##Class(EPRservice.HISInterface.PatientInfoAssist).CardNumber(PapmiDR)
 	i (CardType="身份证")||(CardType="") { s CardNumber =IDCard }

 
 	///////////////////////
 	// 患者基本情况大类  //
 	///////////////////////
 	
 	// 姓名				[Name]				PA_Person.PAPER_Name
 	s Name=##Class(EPRservice.HISInterface.PatientInfoAssist).Name(PapmiDR)
 	
 	// 性别				[Gender]			PA_Person.PAPER_Sex_DR
 	s Gender=##Class(EPRservice.HISInterface.PatientInfoAssist).Gender(PapmiDR,Hospital)
 	i Gender'="" {s GenderDict = $p($g(Gender),"^",2)_"^"_$p($g(Gender),"^",3)}
 	i Gender'="" {s Gender = $p($g(Gender),"^",3)}
 	
 	// 出生日期			[Birthday]			PA_Person.PAPER_Dob
 	s Birthday=##Class(EPRservice.HISInterface.PatientInfoAssist).Birthday(PapmiDR)
 	if Birthday'=""
 	{
   		// 出生日期内部格式 PA_Person.PAPER_Dob 
   		s ArgBirthday=Birthday
   		// 出生日期外部格式 PA_Person.PAPER_Dob
   		s Birthday=$zd(Birthday,3)
 	}
 	
	// (用以计算年龄)入院日期时间	[AdmDateTime]		PAAdm_AdmDate And PAAdm_AdmTime 
		 	s AdmDate = "", AdmTime = ""
		 	s AdmDateTime=##class(EPRservice.HISInterface.PatientInfoAssist).AdmDateTime(Adm,Hospital)
		 	if AdmDateTime'="" 
		 	{ 
		   		// 入院日期内部格式
		   		s AdmDate = $P($G(AdmDateTime),",",1)
		   		// 入院时间内部格式 
		   		s AdmTime = $P($G(AdmDateTime),",",2)
		 	}
	  
 	// DtHealth年龄 N年 N月 N天		[Age]
   	s Age = ##class(EPRservice.HISInterface.PatientInfoAssist).Age(Adm,ArgBirthday,AdmDate,1)  
   	
   	// 病案年龄 N_"^"_岁			[RecordAge][RecordAgeUnit]
   	s tmpRecordAge = ##class(EPRservice.HISInterface.PatientInfoAssist).Age(Adm,ArgBirthday,AdmDate,2)
   	s RecordAge = $p($g(tmpRecordAge),"^",1)
    s RecordAgeUnit = $p($g(tmpRecordAge),"^",2)
    
    // 临床年龄 N岁 N岁N月 N天	[ClinicAge]
   	s ClinicAge = ##class(EPRservice.HISInterface.PatientInfoAssist).Age(Adm,ArgBirthday,AdmDate,4)
   	
   	// 新生儿年龄 N天			[BabyAge]
   	s BabyAge = ##class(EPRservice.HISInterface.PatientInfoAssist).Age(Adm,ArgBirthday,AdmDate,3)
 	
 	// 婚姻状况			[Marriage]			PA_Person.PAPER_Marital_DR ->
 	s Marriage=##Class(EPRservice.HISInterface.PatientInfoAssist).Marriage(PapmiDR)
 	if Marriage'=""
 	{
	 	s Marriage= $p($g(Marriage),"^",3)
	}
 	
 	// 籍贯				[Native]			PA_Person.PAPER_Province_Birth_DR And PA_Person.PAPER_CityBirth_DR
 	// 城市				[CityBirth]			PA_Person.PAPER_CityBirth_DR ->
 	// 省份				[ProvinceBirth]		PA_Person.PAPER_Province_Birth_DR ->
 	// ProvinceDR_"^"_ProvinceCode_"^"_ProvinceDesc_"!"_CityDR_"^"_CityCode_"^"_CityDesc
 	s tmpNative=##Class(EPRservice.HISInterface.PatientInfoAssist).Native(PapmiDR,Hospital)
 	s tmpBirthPlace=##Class(EPRservice.HISInterface.PatientInfoAssist).BirthPlaceNew(PapmiDR)
 	//现住址
 	s tmpcuraddr=##Class(EPRservice.HISInterface.PatientInfoAssist).ResidentAddressNew(PapmiDR,Hospital)
 	//户口地址
 	s tmpHuKou=##Class(EPRservice.HISInterface.PatientInfoAssist).HuKouAddressNew(PapmiDR,Hospital)
 	s tmpCityNative="",CityNative="",ProvinceNative="",CityNativeDesc="",ProvinceNativeDesc=""
 	i tmpNative'=""
 	{
 		// 籍贯城市 
   		s tmpCityNative = $p($g(tmpNative),"!",2)
   		s CityNative = $p($g(tmpCityNative),"^",2)
   		s CityNative = CityNative_"^"_$p($g(tmpCityNative),"^",3)
   		s CityNativeDesc = $p(CityNative,"^",2)
 
   		// 籍贯省份 
   		s tmpProvinceNative = $p($g(tmpNative),"!",1)
   		s ProvinceNative = $p($g(tmpProvinceNative),"^",2)
   		s ProvinceNative = ProvinceNative_"^"_$p($g(tmpProvinceNative),"^",3)
   		s ProvinceNativeDesc = $p(ProvinceNative,"^",2)

   		// 籍贯
   		s Native = $p($g(tmpProvinceBirth),"^",3)_$p($g(tmpCityBirth),"^",3)
 	}
 	s curProvince="",curCity="",curBlock="",curStreet=""
 	i tmpcuraddr'=""
 	{
 		// 现住址城市 
   		s tmpcurCity = $p($g(tmpcuraddr),"!",2)
   		s curCity = $p($g(tmpcurCity),"^",2)
   		s curCity = curCity_"^"_$p($g(tmpcurCity),"^",3)
   		s curCityDesc = $p(curCity,"^",2)
 
   		// 现住址省份 
   		s tmpcurProvince = $p($g(tmpcuraddr),"!",1)
   		s curProvince = $p($g(tmpcurProvince),"^",2)
   		s curProvince = curProvince_"^"_$p($g(tmpcurProvince),"^",3)
   		s curProvinceDesc = $p(curProvince,"^",2)
   		
   		// 现住址区县 
   		s tmpcurBlock = $p($g(tmpcuraddr),"!",3)
   		s curBlock = $p($g(tmpcurBlock),"^",2)
   		s curBlock = curBlock_"^"_$p($g(tmpcurBlock),"^",3)
   		s curBlockDesc = $p(curBlock,"^",2)
   		
   		s curStreet= $p($g(tmpcuraddr),"!",4)

   		// 现住址
   		s CurAddress = $p($g(tmpcurProvince),"^",3)_$p($g(tmpcurCity),"^",3)_$p($g(tmpcurBlock),"^",3)_curStreet
 	}
 	//协和户口地址
 	s HukouProvince="",HuKouCity="",HuKouBlock="",HuKouStreet="",HuKouaddr=""
 	i tmpHuKou'=""
 	{
 		// 户口地址城市 
   		s tmpHuKouCity = $p($g(tmpHuKou),"!",2)
   		s HuKouCity = $p($g(tmpHuKouCity),"^",2)
   		s HuKouCity = HuKouCity_"^"_$p($g(tmpHuKouCity),"^",3)
   		s HuKouCityDesc = $p(HuKouCity,"^",2)
 
   		// 户口地址省份 
   		s tmpHukouProvince = $p($g(tmpHuKou),"!",1)
   		s HukouProvince = $p($g(tmpHukouProvince),"^",2)
   		s HukouProvince = HukouProvince_"^"_$p($g(tmpHukouProvince),"^",3)
   		s HukouProvinceDesc = $p(HukouProvince,"^",2)
   		
   		// 户口地址区县 
   		s tmpHuKouBlock = $p($g(tmpHuKou),"!",3)
   		s HuKouBlock = $p($g(tmpHuKouBlock),"^",2)
   		s HuKouBlock = HuKouBlock_"^"_$p($g(tmpHuKouBlock),"^",3)
   		s HuKouBlockDesc = $p(HuKouBlock,"^",2)
   		
   		s HuKouStreet= $p($g(tmpHuKou),"!",4)

   		// 户口地址
   		s HuKouaddr = $p($g(tmpHukouProvince),"^",3)_$p($g(tmpHuKouCity),"^",3)_$p($g(tmpHuKouBlock),"^",3)_HuKouStreet
 	}
 	
 	
 	;if tmpBirthPlace="" s tmpBirthPlace=tmpNative
 	s ProvinceBirth="",CityBirth="",CityBirth="",BirthPlace=""
 	if tmpBirthPlace'=""
 	{
	 	// 出生地省份 
   		s tmpProvinceBirth = $p($g(tmpBirthPlace),"!",1)
   		s ProvinceBirth = $p($g(tmpProvinceBirth),"^",2)
   		s ProvinceBirth = ProvinceBirth_"^"_$p($g(tmpProvinceBirth),"^",3)
   		s ProvinceBirthDesc = $p(ProvinceBirth,"^",2)
   		
 		// 出生地城市 
   		s tmpCityBirth = $p($g(tmpBirthPlace),"!",2)
   		s CityBirth = $p($g(tmpCityBirth),"^",2)
   		s CityBirth = CityBirth_"^"_$p($g(tmpCityBirth),"^",3)
   		s CityBirthDesc = $p(CityBirth,"^",2)
 
 		// 出生地区县 
   		s tmpBlockBirth = $p($g(tmpBirthPlace),"!",3)
   		s BlockBirth = $p($g(tmpBlockBirth),"^",2)
   		s BlockBirth = BlockBirth_"^"_$p($g(tmpBlockBirth),"^",3)
   		s BlockBirthDesc = $p(BlockBirth,"^",2)   
   		
   		//完整出生地
   		s BirthPlace=$p($g(tmpProvinceBirth),"^",3)_$p($g(tmpCityBirth),"^",3)_$p($g(tmpBlockBirth),"^",3)	
   		
   		// 特殊处理住院登记无籍贯 故同出生地
 		;s:(Native="") Native = $p($g(tmpProvinceBirth),"^",3)_$p($g(tmpCityBirth),"^",3)

 	}
 	
 	
 	// 职业				[Occupation]		PA_Person.PAPER_Occupation_DR ->
 	// 职业描述			[OccupationDesc]	
 	s tmpOccupation=##Class(EPRservice.HISInterface.PatientInfoAssist).Occupation(PapmiDR,Hospital)
 	i tmpOccupation'=""
 	{
   		s Occupation = $p($g(tmpOccupation),"^",2)
   		s OccupationDesc = $p($g(tmpOccupation),"^",3)
   		s Occupation = Occupation_"^"_OccupationDesc
 	}
	
	// 民族				[Nation]			PA_Person.PAPER_Nation_DR -> SQLUser.CT_Nation
	// 民族				[NationDesc]			
	s tmpNation=##Class(EPRservice.HISInterface.PatientInfoAssist).Nation(PapmiDR,Hospital)
	i tmpNation'=""
 	{
   		s Nation = $p($g(tmpNation),"^",2)
   		s NationDesc = $p($g(tmpNation),"^",3)
   		s Nation = Nation_"^"_NationDesc
 	}
		 
	// 国籍				[Country]			PA_Person.PAPER_Country_DR
	// 国籍				[CountryDesc]			
	s tmpCountry=##Class(EPRservice.HISInterface.PatientInfoAssist).Country(PapmiDR,Hospital)
	i tmpCountry'=""
 	{
   		s Country = $p($g(tmpCountry),"^",2)
   		s CountryDesc = $p($g(tmpCountry),"^",3)
   		s Country = Country_"^"_CountryDesc
 	}
		
	// 病人类型			[PayType]			PAAdm_AdmReason_DR -> 
	s PayType=##Class(EPRservice.HISInterface.PatientInfoAssist).PayType(Adm)
	
	
	// 医疗付款方式		[PayMode]			病案首页与病人类型对照
	//s PayMode=##Class(EPRservice.HISInterface.PatientInfoAssist).PayMode(Adm,Hospital)
	s PayMode=##Class(EPRservice.HISInterface.PatientInfoAssist).PayModeLink(Adm,Hospital)


	// 手机				[MobilePhone]		PA_Person.PAPER_MobPhone
	s MobilePhone=##Class(EPRservice.HISInterface.PatientInfoAssist).MobilePhone(PapmiDR,Hospital)
	 
	 

 	///////////////////////////////////////////
 	// 患者联系人情况/工作情况/户口情况大类  //
 	///////////////////////////////////////////
 	
 	
 	// 联系人姓名		[LinkName]			PA_Person.PAPER_ForeignId
 	s LinkName = ##class(EPRservice.HISInterface.PatientInfoAssist).LinkmanName(PapmiDR,Hospital)
 
 	// 联系人关系		[LinkRelation]		PA_Person.PAPER_CTRLT_DR -> SQLUser.CT_Relation
 	s tmpLinkRelation = ##class(EPRservice.HISInterface.PatientInfoAssist).LinkmanRelation(PapmiDR,Hospital)
 	i tmpLinkRelation'=""
 	{
   		s LinkRelation = $p($g(tmpLinkRelation),"^",2)
   		i ($p($g(tmpLinkRelation),"^",3)["-") 
   		{
	   		s LinkRelation = LinkRelation_"^"_$p($p($g(tmpLinkRelation),"^",3),"-",2)
   			s LinkRelationDesc=$p($p($g(tmpLinkRelation),"^",3),"-",2)
   		}
   		else
   		{
	   		s LinkRelation = LinkRelation_"^"_$p($g(tmpLinkRelation),"^",3)
	   		s LinkRelationDesc=$p($g(tmpLinkRelation),"^",3)
   		}
 	}
 	
 	// 联系人地址		[LinkAddress]		PA_Person.PAPER_ForeignAddress
 	s LinkAddress = ##class(EPRservice.HISInterface.PatientInfoAssist).LinkmanAddress(PapmiDR,Hospital)
 
 	// 联系人电话		[LinkPhone]			PA_Person.PAPER_ForeignPhone
 	s LinkPhone = ##class(EPRservice.HISInterface.PatientInfoAssist).LinkmanPhone(PapmiDR,Hospital)

 	// 工作单位地址		[WorkAddress]		PA_Person.PAPER_SecondPhone
 	s WorkAddress=##Class(EPRservice.HISInterface.PatientInfoAssist).WorkAddress(PapmiDR,Hospital)
 
 	// 工作电话			[WorkTel]			PA_Person.PAPER_TelO
 	// 如果工作电话为空  赋值手机
 	s WorkTel=##Class(EPRservice.HISInterface.PatientInfoAssist).WorkPhone(PapmiDR,Hospital)
 	i WorkTel=""
 	{
	 	s WorkTel = MobilePhone
 	}
 
 	// 工作邮编			[WorkPostCode]		DHC_Person.PAPER_Comment2
 	s WorkPostCode=##Class(EPRservice.HISInterface.PatientInfoAssist).WorkPostCode(PapmiDR,Hospital)

 	// 户口所在地址		[HuKouAddress]		PA_Person.PAPER_StName
 	s HuKouAddress=##Class(EPRservice.HISInterface.PatientInfoAssist).HuKouAddress(PapmiDR,Hospital)
	
	// 户口电话			[HuKouTel]			PA_Person.PAPER_TelH
	s HuKouTel=##Class(EPRservice.HISInterface.PatientInfoAssist).HuKouPhone(PapmiDR,Hospital)
	
	// 户口邮编			[HuKouPostCode]		DHC_Person.PAPER_Comment1
	s HuKouPostCode=##Class(EPRservice.HISInterface.PatientInfoAssist).HuKouPostCode(PapmiDR,Hospital)
	//现住址邮编
	s CurAddrPostCode=##Class(EPRservice.HISInterface.PatientInfoAssist).ResidentPostCodeNew(PapmiDR,Hospital)

	set ^CacheTemp(repid, ind) = $LB(EpisodeID,PapmiDR,EpisodeNo,RegisterNo,IPRecordNo,OPRecordNo,EPRecordNo,InsuranceNo,IDCard,CardType,CardNumber,Name,Gender,GenderDict,Birthday,Age,RecordAge,RecordAgeUnit,ClinicAge,BabyAge,Marriage,Native,BlockBirth,CityBirth,ProvinceBirth,CityBirthDesc,ProvinceBirthDesc,Occupation,OccupationDesc,Nation,NationDesc,Country,CountryDesc,PayMode,PayType,MobilePhone,LinkName,LinkRelation,LinkRelationDesc,LinkAddress,LinkPhone,WorkAddress,WorkTel,WorkPostCode,HuKouAddress,HuKouTel,HuKouPostCode,curProvince,curCity,curBlock,curStreet,HukouProvince,HuKouCity,HuKouBlock,HuKouStreet,CurAddrPostCode,ProvinceNative,CityNative)
	set ind = ind + 1
	
	Quit $$$OK
}

ClassMethod GetPatientInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPatientInfoExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetPatientInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPatientInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
	Quit $$$OK
}

/// ////////////////////////////////////////////////////////////////////////////////////////////////
/// Creator：	EPR
/// CreateDate：2009-03-16
/// Desc：		取患者临床医嘱信息[HIS]-02
/// Input:		Adm: 就诊rowid
/// Return：
/// Test:		##Class(EPRservice.SystemData).testcliord(Adm)		
Query GetClinicOrdersInfo(Adm As %String) As %Query(ROWSPEC = "EpisodeID,PapmiDR,EpisodeNo,RegisterNo,Name,AdmMaster,AdmDoctor,AdmNurse,Care1,Care2,Care3,Care4,Care5,Care6,CareClass,FoodTreatment,OrdersLabAndCheck,OrdersCaoYao,OrdersXiYao,MedAllergy,OutDrug")
{
}

ClassMethod GetClinicOrdersInfoExecute(ByRef qHandle As %Binary, Adm As %String) As %Status
{

	
	Set repid=$I(^CacheTemp)
	s ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:($d(^PAADM(Adm))=0)||(Adm="") $$$OK

	
	// 取系统参数
	s Hospital=##class(EPRmeta.SysOption).GetOptionValueByName("HospitalName")
  	s SpaceHIS=##class(EPRmeta.SysOption).GetOptionValueByName("NameSpaceHIS")
	if SpaceHIS'=""
	{
		s MEDDATA = $p($g(SpaceHIS),"^",1)
		s WEBSRC  = $p($g(SpaceHIS),"^",2)
	}
	s SpaceLIS=##class(EPRmeta.SysOption).GetOptionValueByName("NameSpaceLIS")
	if SpaceLIS'=""
	{
	    s LABDATA = $p($g(SpaceLIS),"^",1)
	    s LABSRC  = $p($g(SpaceLIS),"^",2)
	 }
	 
	// 参数空值判断
	Quit:((Hospital="")||(SpaceHIS="")||(SpaceLIS="")) $$$OK
	 
	//初始化返回值
	s AdmDoctor="" ,Care1="" ,Care2="" ,Care3="" ,Care4="" ,Care5="" ,Care6="" ,CareClass="" ,FoodTreatment="" ,OrdersLabAndCheck="" ,OrdersCaoYao="" ,OrdersXiYao=""
	
	// 标识号|登记RowId|就诊号|登记号|姓名
 	s EpisodeID=Adm
 	s PapmiDR = ##Class(EPRservice.HISInterface.PatientInfoAssist).GetPapmiDR(Adm)
 	s EpisodeNo=##Class(EPRservice.HISInterface.PatientInfoAssist).GetEpisodeNo(Adm)
 	s RegisterNo = ##Class(EPRservice.HISInterface.PatientInfoAssist).GetPapmiNo(PapmiDR)
	s Name=##Class(EPRservice.HISInterface.PatientInfoAssist).Name(PapmiDR)
	
	// 入院医生 		[AdmDoctor]			PA_Adm.PAAdm_AdmDocCodeDR ->
	s tmpAdmDoctor=##Class(EPRservice.HISInterface.PatientInfoAssist).AdmDoctor(Adm,Hospital)
	i tmpAdmDoctor'=""
 	{
   		s AdmDoctor = $p($g(tmpAdmDoctor),"^",2)
   		s AdmDoctor = AdmDoctor_"^"_$p($g(tmpAdmDoctor),"^",3)
 	}
 	
 	//主管护士
 	s tmpAdmNurse= ##Class(EPRservice.HISInterface.PatientInfoAssist).AdmNurse(Adm,Hospital)
	i tmpAdmNurse'=""
 	{
   		s AdmNurse = $p($g(tmpAdmNurse),"^",2)
   		s AdmNurse = AdmNurse_"^"_$p($g(tmpAdmNurse),"^",3)
 	}
 	s tmpAdmMaster="",AdmMaster=""
 	s tmpAdmMaster= ##Class(EPRservice.HISInterface.PatientInfoAssist).MasterDoctor(Adm,Hospital)
 	i tmpAdmMaster'=""
 	{
   		s AdmMaster = $p($g(tmpAdmMaster),"^",2)
   		s AdmMaster = AdmMaster_"^"_$p($g(tmpAdmMaster),"^",3)
 	}
 	
	// Care1^Care2^Care3^Care4^Care5^Care6
	// 一级护理^二级护理^三级护理^特级护理^ICU护理常规^CCU护理常规^
	s caredesc0="特级护理",caredesc1="一级护理",caredesc2="二级护理",caredesc3="三级护理",icudesc="重症监护",ccudesc="CCU护理"
	s Caredays = ##class(EPRservice.HISInterface.PatientInfoAssist).CareDays(Adm,caredesc0,caredesc1,caredesc2,caredesc3,icudesc,ccudesc,Hospital)
	i (Caredays'="")
	{
		s Care1 =$p(Caredays ,"^" ,2)
		s Care2 =$p(Caredays ,"^" ,3)
		s Care3 =$p(Caredays ,"^" ,4)
		s Care4 =$p(Caredays ,"^" ,1)
		s Care5 =$p(Caredays ,"^" ,5)
		s Care6 =$p(Caredays ,"^" ,6)
	}
	
	// 当前护理等级 OEORI_ItmMast_DR 为多个时，拼串处理 select * from  ARC_ItmMast  where ARCIM_ItemCat_DR in ('157','000')   
	s ItmMastDRStr="^61||1^62||1^63||1^64||1^"
	s CareClass=##class(EPRservice.HISInterface.PatientInfoAssist).CareClass(Adm,ItmMastDRStr)

	// 当前膳食 ARCIM_ItemCat_DR 为多个时，拼串处理
	s ItemCatDRStr="^111^"
	s FoodTreatment=##class(EPRservice.HISInterface.PatientInfoAssist).HadFoodTreatment(Adm,ItemCatDRStr)

	// 过敏记录[临床组接口]
	s MedAllergy=##class(EPRservice.HISInterface.PatientInfoAssist).EPRGetAllergy(PapmiDR)
	if (MedAllergy'="")
	{
		s MedAllergy=MedAllergy_" "_##class(EPRservice.HISInterface.PatientInfoAssist).MedAllergy(Adm)
	}
	// (用以医嘱取值)入院日期时间		[AdmDateTime]		PAAdm_AdmDate And PAAdm_AdmTime 
		 	s AdmDate = "", AdmTime = ""
		 	s AdmDateTime=##class(EPRservice.HISInterface.PatientInfoAssist).AdmDateTime(Adm,Hospital)
		 	if AdmDateTime'="" 
		 	{ 
		   		// 入院日期内部格式
		   		s AdmDate = $P($G(AdmDateTime),",",1)
		   		s AdmDate = $zd(AdmDate,3)
		   		// 入院时间内部格式 
		   		s AdmTime = $P($G(AdmDateTime),",",2)
		 	}  
	
	if (+($f(EpisodeNo,"OP"))'=0)
	{

		// 门诊医嘱 化验
		s OrdersLab=##Class(EPRservice.HISInterface.PatientInfoAssist).GetOrders(Adm,AdmDate,$ZD($H,3),"化验","0")
	 		 	
		// 门诊医嘱 检查(放射)
		s OrdersCheck1=##Class(EPRservice.HISInterface.PatientInfoAssist).GetOrders(Adm,AdmDate,$ZD($H,3),"放射检查","0")
	 
		// 门诊医嘱 检查(物理)
		s OrdersCheck2=##Class(EPRservice.HISInterface.PatientInfoAssist).GetOrders(Adm,AdmDate,$ZD($H,3),"物理检查","0")
	 	
		// 门诊医嘱 检查(病理)
		s OrdersCheck3=##Class(EPRservice.HISInterface.PatientInfoAssist).GetOrders(Adm,AdmDate,$ZD($H,3),"病理检查费","0")
		
		// 门诊医嘱 检查(内窥镜)
		s OrdersCheck4=##Class(EPRservice.HISInterface.PatientInfoAssist).GetOrders(Adm,AdmDate,$ZD($H,3),"内窥镜检查","0")
	 	
		s OrdersLabAndCheck=OrdersLab_OrdersCheck1_OrdersCheck2_OrdersCheck3_OrdersCheck4
		i OrdersLabAndCheck'="" { s OrdersLabAndCheck= $e( OrdersLabAndCheck,1,$l(OrdersLabAndCheck)-2) }
		
		// 门诊医嘱 草药处方
		s OrdersCaoYao=##class(EPRservice.HISInterface.PatientInfoAssist).GetOrdersCaoYao(Adm)
	
		// 门诊医嘱 西药处方
	 	s OrdersXiYao=##class(EPRservice.HISInterface.PatientInfoAssist).GetOrdersXiYao(Adm)
	}
	if (+($f(EpisodeNo,"EP"))'=0)
	{
		
		// 急诊医嘱 化验
	 	s OrdersLab=##Class(EPRservice.HISInterface.PatientInfoAssist).GetOrderDetailByOrdCat(Adm,AdmDate,$ZD($H,3),"化验",1)
	 	s:(OrdersLab'="") OrdersLab = OrdersLab_"、" 
	 		
		// 急诊医嘱 检查(放射)
	 	s OrdersCheck1=##Class(EPRservice.HISInterface.PatientInfoAssist).GetOrderDetailByOrdCat(Adm,AdmDate,$ZD($H,3),"放射检查",1)
	 	s:(OrdersCheck1'="") OrdersCheck1 = OrdersCheck1_"、" 
	 	
		// 急诊医嘱 检查(物理)
	 	s OrdersCheck2=##Class(EPRservice.HISInterface.PatientInfoAssist).GetOrderDetailByOrdCat(Adm,AdmDate,$ZD($H,3),"物理检查",1)
	 	s:(OrdersCheck2'="") OrdersCheck2 = OrdersCheck2_"、" 
	 		 	
		s OrdersLabAndCheck=OrdersLab_OrdersCheck1_OrdersCheck2
		s:(OrdersLabAndCheck'="") OrdersLabAndCheck= $e( OrdersLabAndCheck,1,$l(OrdersLabAndCheck)-1)
			
		// 急诊医嘱 西药
	 	s OrdersXiYao1 = ##Class(EPRservice.HISInterface.PatientInfoAssist).GetOrderDetailByOrdCat(Adm,AdmDate,$ZD($H,3),"西药")
	 		 	
	 	s OrdersXiYao2 = ##Class(EPRservice.HISInterface.PatientInfoAssist).GetOrderDetailByOrdCat(Adm,AdmDate,$ZD($H,3),"中成药")
	 	
	 	s Tag = ""
	 	
	 	s:(OrdersXiYao1'="")&&(OrdersXiYao2'="") Tag = $c(13,10)
	 	
	 	s OrdersXiYao=OrdersXiYao1_Tag_OrdersXiYao2
	 	
	 	// 急诊医嘱 草药
		//s OrdersCaoYao=##class(EPRservice.HISInterface.PatientInfoAssist).GetOrdersCaoYao(Adm)

	}
	//取出院医嘱　2011-11-30
	s OutDrug=""
	s OutDrug=##class(EPRservice.HISInterface.PatientInfoAssist).GetOrdersByPriority(Adm,"出院带药")


	set ^CacheTemp(repid, ind) = $LB(EpisodeID,PapmiDR,EpisodeNo,RegisterNo,Name,AdmMaster,AdmDoctor,AdmNurse,Care1,Care2,Care3,Care4,Care5,Care6,CareClass,FoodTreatment,OrdersLabAndCheck,OrdersCaoYao,OrdersXiYao,MedAllergy,OutDrug)
	set ind = ind + 1
	
	Quit $$$OK
}

ClassMethod GetClinicOrdersInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetClinicOrdersInfoExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetClinicOrdersInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetClinicOrdersInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
	Quit $$$OK
}

/// ////////////////////////////////////////////////////////////////////////////////////////////////
/// Creator：	EPR
/// CreateDate：2009-03-16
/// Desc：		取患者临床诊断信息[HIS]-03 200908OK
/// Input:		Adm: 就诊rowid
/// Return：
/// Test:		##Class(EPRservice.SystemData).testclidiag(Adm)		
Query GetClinicDiagInfo(Adm As %String) As %Query(ROWSPEC = "EpisodeID,PapmiDR,EpisodeNo,RegisterNo,Name,AdmDiag,AdmDiagDesc,MainDiag,MainDiagDesc,OutDiag01,OutDiag02,OutDiag03,OutDiag04,OutDiag05,OutDiag06,OutDiag07,OutDiag08,OutDiag09,OutDiag10,OutDiag11,OutDiag12,OutDiag13,OutDiag14,OutDiag15,OutDiag16,OutDiag17,OutDiag18,OutDiag19,OutDiag20,DiagAllString,Diag01,Diag02,Diag03,Diag04,Diag05,Diag06,Diag07,Diag08,Diag09,Diag10,Diag11,Diag12,Diag13,Diag14,Diag15,Diag16,Diag17,Diag18,Diag19,Diag20,DiagWMString,DiagWM01,DiagWM02,DiagWM03,DiagWM04,DiagWM05,DiagWM06,DiagWM07,DiagWM08,DiagWM09,DiagWM10,DiagWM11,DiagWM12,DiagWM13,DiagWM14,DiagWM15,DiagWM16,DiagWM17,DiagWM18,DiagWM19,DiagWM20,DiagTCMString,DiagTCM01,DiagTCM02,DiagTCM03,DiagTCM04,DiagTCM05,DiagTCM06,DiagTCM07,DiagTCM08,DiagTCM09,DiagTCM10,DiagSYMString,DiagSYM01,DiagSYM02,DiagSYM03,DiagSYM04,DiagSYM05,DiagSYM06,DiagSYM07,DiagSYM08,DiagSYM09,DiagSYM10,Diag01Desc,Diag02Desc,Diag03Desc")
{
}

ClassMethod GetClinicDiagInfoExecute(ByRef qHandle As %Binary, Adm As %String) As %Status
{
	//b "s"
	
	Set repid=$I(^CacheTemp)
	s ind=1
	Set qHandle=$lb(0,repid,0)

	Quit:($d(^PAADM(Adm))=0)||(Adm="") $$$OK
	
    //取系统参数
	s Hospital=##class(EPRmeta.SysOption).GetOptionValueByName("HospitalName")
  	s SpaceHIS=##class(EPRmeta.SysOption).GetOptionValueByName("NameSpaceHIS")
	if SpaceHIS'=""
	{
		s MEDDATA = $p($g(SpaceHIS),"^",1)
		s WEBSRC  = $p($g(SpaceHIS),"^",2)
	}
	s SpaceLIS=##class(EPRmeta.SysOption).GetOptionValueByName("NameSpaceLIS")
	if SpaceLIS'=""
	{
	    s LABDATA = $p($g(SpaceLIS),"^",1)
	    s LABSRC  = $p($g(SpaceLIS),"^",2)
	 }
	 Quit:((Hospital="")||(SpaceHIS="")||(SpaceLIS="")) $$$OK
	 
	// 初始化返回值
	s AdmDiag="",AdmDiagDesc="",AdmDiag2="",AdmDiag2Desc="",MainDiag="",MainDiagDesc="",OutDiag="",OutDiagDesc=""
	
	s Diagnosis="",Diagcount="",i=""
	s DiagAllString="",Diag01="",Diag02="",Diag03="",Diag04="",Diag05="",Diag06="",Diag07="",Diag08="",Diag09="",Diag10="",Diag11="",Diag12="",Diag13="",Diag14="",Diag15="",Diag16="",Diag17="",Diag18="",Diag19="",Diag20=""
	s Diag01Desc="",Diag02Desc="",Diag03Desc="",Diag04Desc="",Diag05Desc="",Diag06Desc="",Diag07Desc="",Diag08Desc="",Diag09Desc="",Diag10Desc="",Diag11Desc="",Diag12Desc="",Diag13Desc="",Diag14Desc="",Diag15Desc="",Diag16Desc="",Diag17Desc="",Diag18Desc="",Diag19Desc="",Diag20Desc=""
	
	s DiagWMString="",DiagWM01="",DiagWM02="",DiagWM03="",DiagWM04="",DiagWM05="",DiagWM06="",DiagWM07="",DiagWM08="",DiagWM09="",DiagWM10="",DiagWM11="",DiagWM12="",DiagWM13="",DiagWM14="",DiagWM15="",DiagWM16="",DiagWM17="",DiagWM18="",DiagWM19="",DiagWM20=""
	s DiagWM01Desc="",DiagWM02Desc="",DiagWM03Desc="",DiagWM04Desc="",DiagWM05Desc="",DiagWM06Desc="",DiagWM07Desc="",DiagWM08Desc="",DiagWM09Desc="",DiagWM10Desc="",DiagWM11Desc="",DiagWM12Desc="",DiagWM13Desc="",DiagWM14Desc="",DiagWM15Desc="",DiagWM16Desc="",DiagWM17Desc="",DiagWM18Desc="",DiagWM19Desc="",DiagWM20Desc=""
	
	s DiagTCMString="",DiagTCM01="",DiagTCM02="",DiagTCM03="",DiagTCM04="",DiagTCM05="",DiagTCM06="",DiagTCM07="",DiagTCM08="",DiagTCM09="",DiagTCM10=""
	s DiagTCM01Desc="",DiagTCM02Desc="",DiagTCM03Desc="",DiagTCM04Desc="",DiagTCM05Desc="",DiagTCM06Desc="",DiagTCM07Desc="",DiagTCM08Desc="",DiagTCM09Desc="",DiagTCM10Desc=""

	s DiagSYMString="",DiagSYM01="",DiagSYM02="",DiagSYM03="",DiagSYM04="",DiagSYM05="",DiagSYM06="",DiagSYM07="",DiagSYM08="",DiagSYM09="",DiagSYM10=""
	s DiagSYM01Desc="",DiagSYM02Desc="",DiagSYM03Desc="",DiagSYM04Desc="",DiagSYM05Desc="",DiagSYM06Desc="",DiagSYM07Desc="",DiagSYM08Desc="",DiagSYM09Desc="",DiagSYM10Desc=""
	
	// 标识号|登记RowId|就诊号|登记号|姓名
 	s EpisodeID=Adm
 	s PapmiDR = ##Class(EPRservice.HISInterface.PatientInfoAssist).GetPapmiDR(Adm)
 	s EpisodeNo=##Class(EPRservice.HISInterface.PatientInfoAssist).GetEpisodeNo(Adm)
 	s RegisterNo = ##Class(EPRservice.HISInterface.PatientInfoAssist).GetPapmiNo(PapmiDR)
	s Name=##Class(EPRservice.HISInterface.PatientInfoAssist).Name(PapmiDR)

 	///////////////////////
 	// 患者临床诊断大类  //
 	///////////////////////


	//取入院诊断
	s tmpAdmDiag = ##Class(EPRservice.HISInterface.PatientInfoAssist).AdmDiagnos(Adm)
	i tmpAdmDiag'="" 
	{
		i $l(tmpAdmDiag,"!")>1
		{
			s tmpAdmDiag=$p($g(tmpAdmDiag),"!",$l(tmpAdmDiag,"!"))
		}
		s AdmDiag=$p($g(tmpAdmDiag),"^",1)
		s AdmDiagDesc=$p($g(tmpAdmDiag),"^",3)
		
	}
		
	
	//取主要诊断
	s tmpMainDiag = ##Class(EPRservice.HISInterface.PatientInfoAssist).MainDiagnos(Adm)
	i tmpMainDiag'="" 
	{
		i $l(tmpMainDiag,"!")>1
		{
			s tmpMainDiag=$p($g(tmpMainDiag),"!",$l(tmpMainDiag,"!"))
		}
		s MainDiag=$p($g(tmpMainDiag),"^",1)
		s MainDiagDesc=$p($g(tmpMainDiag),"^",3)
		s MainDiag=MainDiag_"^"_MainDiagDesc

	}


	//取出院诊断
	s tmpOutDiag = ##Class(EPRservice.HISInterface.PatientInfoAssist).OutDiagnos(Adm)
	i tmpOutDiag'="" 
	{
		/*i $l(tmpOutDiag,"!")>1
		{
			s tmpOutDiag=$p($g(tmpOutDiag),"!",$l(tmpOutDiag,"!"))
		}
		s OutDiag=$p($g(tmpOutDiag),"^",1)
		s OutDiagDesc=$p($g(tmpOutDiag),"^",3)
		s OutDiag=OutDiag_"^"_OutDiagDesc*/
		s outdiagcount=$l(tmpOutDiag,"!")
		
		f i=1:1:outdiagcount 
		{
			i i=1  s OutDiag01=$p($g(tmpOutDiag),"!",i) s OutDiag01=$p($g(OutDiag01),"^",2)_"^"_$p($g(OutDiag01),"^",3)
			i i=2  s OutDiag02=$p($g(tmpOutDiag),"!",i) s OutDiag02=$p($g(OutDiag01),"^",2)_"^"_$p($g(OutDiag02),"^",3)
			i i=3  s OutDiag03=$p($g(tmpOutDiag),"!",i) s OutDiag03=$p($g(OutDiag01),"^",2)_"^"_$p($g(OutDiag03),"^",3)
			i i=4  s OutDiag04=$p($g(tmpOutDiag),"!",i) s OutDiag04=$p($g(OutDiag01),"^",2)_"^"_$p($g(OutDiag04),"^",3)
			i i=5  s OutDiag05=$p($g(tmpOutDiag),"!",i) s OutDiag05=$p($g(OutDiag01),"^",2)_"^"_$p($g(OutDiag05),"^",3)
			i i=6  s OutDiag06=$p($g(tmpOutDiag),"!",i) s OutDiag06=$p($g(OutDiag01),"^",2)_"^"_$p($g(OutDiag06),"^",3)
			i i=7  s OutDiag07=$p($g(tmpOutDiag),"!",i) s OutDiag07=$p($g(OutDiag01),"^",2)_"^"_$p($g(OutDiag07),"^",3)
			i i=8  s OutDiag08=$p($g(tmpOutDiag),"!",i) s OutDiag08=$p($g(OutDiag01),"^",2)_"^"_$p($g(OutDiag08),"^",3)
			i i=9  s OutDiag09=$p($g(tmpOutDiag),"!",i) s OutDiag09=$p($g(OutDiag01),"^",2)_"^"_$p($g(OutDiag09),"^",3)
			i i=10 s OutDiag10=$p($g(tmpOutDiag),"!",i) s OutDiag10=$p($g(OutDiag01),"^",2)_"^"_$p($g(OutDiag10),"^",3)
			i i=11 s OutDiag11=$p($g(tmpOutDiag),"!",i) s OutDiag11=$p($g(OutDiag01),"^",2)_"^"_$p($g(OutDiag11),"^",3)
			i i=12 s OutDiag12=$p($g(tmpOutDiag),"!",i) s OutDiag12=$p($g(OutDiag01),"^",2)_"^"_$p($g(OutDiag12),"^",3)
			i i=13 s OutDiag13=$p($g(tmpOutDiag),"!",i) s OutDiag13=$p($g(OutDiag01),"^",2)_"^"_$p($g(OutDiag13),"^",3)
			i i=14 s OutDiag14=$p($g(tmpOutDiag),"!",i) s OutDiag14=$p($g(OutDiag01),"^",2)_"^"_$p($g(OutDiag14),"^",3)
			i i=15 s OutDiag15=$p($g(tmpOutDiag),"!",i) s OutDiag15=$p($g(OutDiag01),"^",2)_"^"_$p($g(OutDiag15),"^",3)
			i i=16 s OutDiag16=$p($g(tmpOutDiag),"!",i) s OutDiag16=$p($g(OutDiag01),"^",2)_"^"_$p($g(OutDiag16),"^",3)
			i i=17 s OutDiag17=$p($g(tmpOutDiag),"!",i) s OutDiag17=$p($g(OutDiag01),"^",2)_"^"_$p($g(OutDiag17),"^",3)
			i i=18 s OutDiag18=$p($g(tmpOutDiag),"!",i) s OutDiag18=$p($g(OutDiag01),"^",2)_"^"_$p($g(OutDiag18),"^",3)
			i i=19 s OutDiag19=$p($g(tmpOutDiag),"!",i) s OutDiag19=$p($g(OutDiag01),"^",2)_"^"_$p($g(OutDiag19),"^",3)
			i i=20 s OutDiag20=$p($g(tmpOutDiag),"!",i) s OutDiag20=$p($g(OutDiag01),"^",2)_"^"_$p($g(OutDiag20),"^",3)
		}
		
	}

	//b:(Adm = 9185) "s"
	//取所有诊断及分项
	s Diagnosis = ""
	s:(Adm '= 9185) Diagnosis = ##Class(EPRservice.HISInterface.PatientInfoAssist).GetDiagnos(Adm)
	s Diagnosis = $tr(Diagnosis,"？","?")
	s Diagnosis = $tr(Diagnosis,"，",",")
	
	
	if Diagnosis'=""
	{
		s diagcount=$l(Diagnosis,"!")-1
		f i=1:1:diagcount 
		{
			i i=1  s Diag01=$p($g(Diagnosis),"!",i) s Diag01Desc="1."_$p($g(Diag01),"^",2)
			i i=2  s Diag02=$p($g(Diagnosis),"!",i) s Diag02Desc="2."_$p($g(Diag02),"^",2)
			i Adm=19048  s Diag02="" s Diag02Desc="2."_""
			i i=3  s Diag03=$p($g(Diagnosis),"!",i) s Diag03Desc="3."_$p($g(Diag03),"^",2)
			i Adm=14447||22913  s Diag03="" s Diag03Desc="3."_""
			i i=4  s Diag04=$p($g(Diagnosis),"!",i) s Diag04Desc="4."_$p($g(Diag04),"^",2)
			i Adm=22913  s Diag04="" s Diag04Desc="4."_""
			i i=5  s Diag05=$p($g(Diagnosis),"!",i) s Diag05Desc="5."_$p($g(Diag05),"^",2)
			i Adm=22913  s Diag05="" s Diag05Desc="5."_""
			i i=6  s Diag06=$p($g(Diagnosis),"!",i) s Diag06Desc="6."_$p($g(Diag06),"^",2)
			i i=7  s Diag07=$p($g(Diagnosis),"!",i) s Diag07Desc="7."_$p($g(Diag07),"^",2)
			i i=8  s Diag08=$p($g(Diagnosis),"!",i) s Diag08Desc="8."_$p($g(Diag08),"^",2)
			i i=9  s Diag09=$p($g(Diagnosis),"!",i) s Diag09Desc="9."_$p($g(Diag09),"^",2)
			i i=10 s Diag10=$p($g(Diagnosis),"!",i) s Diag10Desc="10."_$p($g(Diag10),"^",2)
			i i=11 s Diag11=$p($g(Diagnosis),"!",i) s Diag11Desc=",11."_$p($g(Diag11),"^",2)
			i i=12 s Diag12=$p($g(Diagnosis),"!",i) s Diag12Desc=",12."_$p($g(Diag12),"^",2)
			i i=13 s Diag13=$p($g(Diagnosis),"!",i) s Diag13Desc=",13."_$p($g(Diag13),"^",2)
			i i=14 s Diag14=$p($g(Diagnosis),"!",i) s Diag14Desc=",14."_$p($g(Diag14),"^",2)
			i i=15 s Diag15=$p($g(Diagnosis),"!",i) s Diag15Desc=",15."_$p($g(Diag15),"^",2)
			i i=16 s Diag16=$p($g(Diagnosis),"!",i) s Diag16Desc=",16."_$p($g(Diag16),"^",2)
			i i=17 s Diag17=$p($g(Diagnosis),"!",i) s Diag17Desc=",17."_$p($g(Diag17),"^",2)
			i i=18 s Diag18=$p($g(Diagnosis),"!",i) s Diag18Desc=",18."_$p($g(Diag18),"^",2)
			i i=19 s Diag19=$p($g(Diagnosis),"!",i) s Diag19Desc=",19."_$p($g(Diag19),"^",2)
			i i=20 s Diag20=$p($g(Diagnosis),"!",i) s Diag20Desc=",20."_$p($g(Diag20),"^",2)
		}
		
	//s DiagAllString=$tr(Diagnosis,"!",",")
	//s DiagAllString=$e(DiagAllString,1,$l(DiagAllString)-1)
	s DiagAllString = Diag01Desc
	if (Diag02Desc'="")
	{ s DiagAllString = DiagAllString_","_Diag02Desc }
	if (Diag03Desc'="")
	{ s DiagAllString = DiagAllString_","_Diag03Desc }
	if (Diag04Desc'="")
	{ s DiagAllString = DiagAllString_","_Diag04Desc }
	if (Diag05Desc'="")
	{ s DiagAllString = DiagAllString_","_Diag05Desc }
	//_","_Diag03Desc_","_Diag04Desc_","_Diag05Desc_","_Diag06Desc_","_Diag07Desc_","_Diag08Desc_","_Diag09Desc_","_Diag10Desc_Diag11Desc_Diag12Desc_Diag13Desc_Diag14Desc_Diag15Desc_Diag16Desc_Diag17Desc_Diag18Desc_Diag19Desc_Diag20Desc

  }
 
 //取西医诊断及分项
	s Diagnosis = ""
	s:(Adm '= 9185) Diagnosis = "" //##Class(EPRservice.HISInterface.PatientInfoAssist).GetDiagnos(Adm,1)
 s Diagnosis = $tr(Diagnosis,"？","?")
 s Diagnosis = $tr(Diagnosis,"，",",")

 
 
 if Diagnosis'=""
 {
	 s diagcount=$l(Diagnosis,"!")-1
	 f i=1:1:diagcount 
	 {
		 i i=1  s DiagWM01=$p($g(Diagnosis),"!",i) s DiagWM01Desc=$p($g(DiagWM01),"^",2)
		 i i=2  s DiagWM02=$p($g(Diagnosis),"!",i) s DiagWM02Desc=","_$p($g(DiagWM02),"^",2)
		 i i=3  s DiagWM03=$p($g(Diagnosis),"!",i) s DiagWM03Desc=","_$p($g(DiagWM03),"^",2)
		 i i=4  s DiagWM04=$p($g(Diagnosis),"!",i) s DiagWM04Desc=","_$p($g(DiagWM04),"^",2)
	     i i=5  s DiagWM05=$p($g(Diagnosis),"!",i) s DiagWM05Desc=","_$p($g(DiagWM05),"^",2)
	     i i=6  s DiagWM06=$p($g(Diagnosis),"!",i) s DiagWM06Desc=","_$p($g(DiagWM06),"^",2)
	     i i=7  s DiagWM07=$p($g(Diagnosis),"!",i) s DiagWM07Desc=","_$p($g(DiagWM07),"^",2)
	     i i=8  s DiagWM08=$p($g(Diagnosis),"!",i) s DiagWM08Desc=","_$p($g(DiagWM08),"^",2)
	     i i=9  s DiagWM09=$p($g(Diagnosis),"!",i) s DiagWM09Desc=","_$p($g(DiagWM09),"^",2)
	     i i=10 s DiagWM10=$p($g(Diagnosis),"!",i) s DiagWM10Desc=","_$p($g(DiagWM10),"^",2)
		 i i=11 s DiagWM11=$p($g(Diagnosis),"!",i) s DiagWM11Desc=","_$p($g(DiagWM11),"^",2)
		 i i=12 s DiagWM12=$p($g(Diagnosis),"!",i) s DiagWM12Desc=","_$p($g(DiagWM12),"^",2)
		 i i=13 s DiagWM13=$p($g(Diagnosis),"!",i) s DiagWM13Desc=","_$p($g(DiagWM13),"^",2)
		 i i=14 s DiagWM14=$p($g(Diagnosis),"!",i) s DiagWM14Desc=","_$p($g(DiagWM14),"^",2)
	     i i=15 s DiagWM15=$p($g(Diagnosis),"!",i) s DiagWM15Desc=","_$p($g(DiagWM15),"^",2)
	     i i=16 s DiagWM16=$p($g(Diagnosis),"!",i) s DiagWM16Desc=","_$p($g(DiagWM16),"^",2)
	     i i=17 s DiagWM17=$p($g(Diagnosis),"!",i) s DiagWM17Desc=","_$p($g(DiagWM17),"^",2)
	     i i=18 s DiagWM18=$p($g(Diagnosis),"!",i) s DiagWM18Desc=","_$p($g(DiagWM18),"^",2)
	     i i=19 s DiagWM19=$p($g(Diagnosis),"!",i) s DiagWM19Desc=","_$p($g(DiagWM19),"^",2)
	     i i=20 s DiagWM20=$p($g(Diagnosis),"!",i) s DiagWM20Desc=","_$p($g(DiagWM20),"^",2)
	 }
	 
	 //s DiagWMString=$tr(Diagnosis,"!",",")
	 //s DiagWMString=$e(DiagWMString,1,$l(DiagWMString)-1)
	 
	 s DiagWMString =DiagWM01Desc_DiagWM02Desc_DiagWM03Desc_DiagWM04Desc_DiagWM05Desc_DiagWM06Desc_DiagWM07Desc_DiagWM08Desc_DiagWM09Desc_DiagWM10Desc_DiagWM11Desc_DiagWM12Desc_DiagWM13Desc_DiagWM14Desc_DiagWM15Desc_DiagWM16Desc_DiagWM17Desc_DiagWM18Desc_DiagWM19Desc_DiagWM20Desc
	 
  }

 
 s Diagnosis = ##Class(EPRservice.HISInterface.PatientInfoAssist).GetDiagnos(Adm,2)
  if Diagnosis'=""
 {
	 s diagcount=$l(Diagnosis,"!")-1
	 f i=1:1:diagcount 
	 {
		 i i=1 { s DiagTCM01=$p($g(Diagnosis),"!",i) i (+$f(DiagTCM01,"^")>0) { s DiagTCM01Desc="1."_$p($g(DiagTCM01),"^",2) } else { s DiagTCM01Desc="1."_DiagTCM01}}
		 i i=2 { s DiagTCM02=$p($g(Diagnosis),"!",i) i (+$f(DiagTCM02,"^")>0) { s DiagTCM02Desc=",2."_$p($g(DiagTCM02),"^",2)} else { s DiagTCM02Desc=",2."_DiagTCM02}}
		 i i=3 { s DiagTCM03=$p($g(Diagnosis),"!",i) i (+$f(DiagTCM03,"^")>0) { s DiagTCM03Desc=",3."_$p($g(DiagTCM03),"^",2)} else { s DiagTCM03Desc=",3."_DiagTCM03}}
		 i i=4 { s DiagTCM04=$p($g(Diagnosis),"!",i) i (+$f(DiagTCM04,"^")>0) { s DiagTCM04Desc=",4."_$p($g(DiagTCM04),"^",2)} else { s DiagTCM04Desc=",4."_DiagTCM04}}
	     i i=5 { s DiagTCM05=$p($g(Diagnosis),"!",i) i (+$f(DiagTCM05,"^")>0) { s DiagTCM05Desc=",5."_$p($g(DiagTCM05),"^",2)} else { s DiagTCM05Desc=",5."_DiagTCM05}}
	     i i=6 { s DiagTCM06=$p($g(Diagnosis),"!",i) i (+$f(DiagTCM06,"^")>0) { s DiagTCM06Desc=",6."_$p($g(DiagTCM06),"^",2)} else { s DiagTCM06Desc=",6."_DiagTCM06}}
	     i i=7 { s DiagTCM07=$p($g(Diagnosis),"!",i) i (+$f(DiagTCM07,"^")>0) { s DiagTCM07Desc=",7."_$p($g(DiagTCM07),"^",2)} else { s DiagTCM07Desc=",7."_DiagTCM07}}
	     i i=8 { s DiagTCM08=$p($g(Diagnosis),"!",i) i (+$f(DiagTCM08,"^")>0) { s DiagTCM08Desc=",8."_$p($g(DiagTCM08),"^",2)} else { s DiagTCM08Desc=",8."_DiagTCM08}}
	     i i=9 { s DiagTCM09=$p($g(Diagnosis),"!",i) i (+$f(DiagTCM09,"^")>0) { s DiagTCM09Desc=",9."_$p($g(DiagTCM09),"^",2)} else { s DiagTCM09Desc=",9."_DiagTCM09}}
	     i i=10{ s DiagTCM10=$p($g(Diagnosis),"!",i) i (+$f(DiagTCM10,"^")>0) { s DiagTCM10Desc=",10."_$p($g(DiagTCM10),"^",2)}else { s DiagTCM10Desc=",10."_DiagTCM10}}
	 }
	 
	 //s DiagTCMString=$tr(Diagnosis,"!",",")
	 //s DiagTCMString=$e(DiagTCMString,1,$l(DiagTCMString)-1)
	 
	 s DiagTCMString = DiagTCM01Desc_DiagTCM02Desc_DiagTCM03Desc_DiagTCM04Desc_DiagTCM05Desc_DiagTCM06Desc_DiagTCM07Desc_DiagTCM08Desc_DiagTCM09Desc_DiagTCM10Desc

  }


 s Diagnosis =  ##Class(EPRservice.HISInterface.PatientInfoAssist).GetDiagnos(Adm,3)
  if Diagnosis'=""
 {
	 s diagcount=$l(Diagnosis,"!")-1
	 f i=1:1:diagcount 
	 {
		 i i=1 { s DiagSYM01=$p($g(Diagnosis),"!",i) i (+$f(DiagSYM01,"^")>0) { s DiagSYM01Desc="1."_$p($g(DiagSYM01),"^",2) } else { s DiagSYM01Desc="1."_DiagSYM01}}
		 i i=2 { s DiagSYM02=$p($g(Diagnosis),"!",i) i (+$f(DiagSYM02,"^")>0) { s DiagSYM02Desc=",2."_$p($g(DiagSYM02),"^",2)} else { s DiagSYM02Desc=",2."_DiagSYM02}}
		 i i=3 { s DiagSYM03=$p($g(Diagnosis),"!",i) i (+$f(DiagSYM03,"^")>0) { s DiagSYM03Desc=",3."_$p($g(DiagSYM03),"^",2)} else { s DiagSYM03Desc=",3."_DiagSYM03}}
		 i i=4 { s DiagSYM04=$p($g(Diagnosis),"!",i) i (+$f(DiagSYM04,"^")>0) { s DiagSYM04Desc=",4."_$p($g(DiagSYM04),"^",2)} else { s DiagSYM04Desc=",4."_DiagSYM04}}
	     i i=5 { s DiagSYM05=$p($g(Diagnosis),"!",i) i (+$f(DiagSYM05,"^")>0) { s DiagSYM05Desc=",5."_$p($g(DiagSYM05),"^",2)} else { s DiagSYM05Desc=",5."_DiagSYM05}}
	     i i=6 { s DiagSYM06=$p($g(Diagnosis),"!",i) i (+$f(DiagSYM06,"^")>0) { s DiagSYM06Desc=",6."_$p($g(DiagSYM06),"^",2)} else { s DiagSYM06Desc=",6."_DiagSYM06}}
	     i i=7 { s DiagSYM07=$p($g(Diagnosis),"!",i) i (+$f(DiagSYM07,"^")>0) { s DiagSYM07Desc=",7."_$p($g(DiagSYM07),"^",2)} else { s DiagSYM07Desc=",7."_DiagSYM07}}
	     i i=8 { s DiagSYM08=$p($g(Diagnosis),"!",i) i (+$f(DiagSYM08,"^")>0) { s DiagSYM08Desc=",8."_$p($g(DiagSYM08),"^",2)} else { s DiagSYM08Desc=",8."_DiagSYM08}}
	     i i=9 { s DiagSYM09=$p($g(Diagnosis),"!",i) i (+$f(DiagSYM09,"^")>0) { s DiagSYM09Desc=",9."_$p($g(DiagSYM09),"^",2)} else { s DiagSYM09Desc=",9."_DiagSYM09}}
	     i i=10{ s DiagSYM10=$p($g(Diagnosis),"!",i) i (+$f(DiagSYM10,"^")>0) { s DiagSYM10Desc=",10."_$p($g(DiagSYM10),"^",2)}else { s DiagSYM10Desc=",10."_DiagSYM10}}
	 }
	 
	 //s DiagSYMString=$tr(Diagnosis,"!",",")
	 //s DiagSYMString=$e(DiagSYMString,1,$l(DiagSYMString)-1)
	 
	 s DiagSYMString = DiagSYM01Desc_DiagSYM02Desc_DiagSYM03Desc_DiagSYM04Desc_DiagSYM05Desc_DiagSYM06Desc_DiagSYM07Desc_DiagSYM08Desc_DiagSYM09Desc_DiagSYM10Desc

  }
  

	set ^CacheTemp(repid, ind) = $LB(EpisodeID,PapmiDR,EpisodeNo,RegisterNo,Name,AdmDiag,AdmDiagDesc,MainDiag,MainDiagDesc,OutDiag01,OutDiag02,OutDiag03,OutDiag04,OutDiag05,OutDiag06,OutDiag07,OutDiag08,OutDiag09,OutDiag10,OutDiag11,OutDiag12,OutDiag13,OutDiag14,OutDiag15,OutDiag16,OutDiag17,OutDiag18,OutDiag19,OutDiag20,DiagAllString,Diag01,Diag02,Diag03,Diag04,Diag05,Diag06,Diag07,Diag08,Diag09,Diag10,Diag11,Diag12,Diag13,Diag14,Diag15,Diag16,Diag17,Diag18,Diag19,Diag20,DiagWMString,DiagWM01,DiagWM02,DiagWM03,DiagWM04,DiagWM05,DiagWM06,DiagWM07,DiagWM08,DiagWM09,DiagWM10,DiagWM11,DiagWM12,DiagWM13,DiagWM14,DiagWM15,DiagWM16,DiagWM17,DiagWM18,DiagWM19,DiagWM20,DiagTCMString,DiagTCM01,DiagTCM02,DiagTCM03,DiagTCM04,DiagTCM05,DiagTCM06,DiagTCM07,DiagTCM08,DiagTCM09,DiagTCM10,DiagSYMString,DiagSYM01,DiagSYM02,DiagSYM03,DiagSYM04,DiagSYM05,DiagSYM06,DiagSYM07,DiagSYM08,DiagSYM09,DiagSYM10,Diag01Desc,Diag02Desc,Diag03Desc)
	set ind = ind + 1
	
	Quit $$$OK
}

ClassMethod GetClinicDiagInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetClinicDiagInfoExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetClinicDiagInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetClinicDiagInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
	Quit $$$OK
}

/// ////////////////////////////////////////////////////////////////////////////////////////////////
/// Creator：	EPR
/// CreateDate：2009-03-16
/// Desc：		取患者检验信息[HIS]-04
/// Input:		Adm: 就诊rowid
/// Return：
/// Test:		##Class(EPRservice.SystemData).testlab(Adm)		
Query GetLabInfo(Adm As %String) As %Query(ROWSPEC = "EpisodeID,PapmiDR,EpisodeNo,RegisterNo,Name,BloodType,Rh,HBsAg,HCV,HIV,TP,ALT,HBeAg,HBS,AntiHBe,HBC")
{
}

ClassMethod GetLabInfoExecute(ByRef qHandle As %Binary, Adm As %String) As %Status
{
	//b "s"
	
	Set repid=$I(^CacheTemp)
	s ind=1
	Set qHandle=$lb(0,repid,0)

	Quit:($d(^PAADM(Adm))=0)||(Adm="") $$$OK
	
    //取系统参数
	s Hospital=##class(EPRmeta.SysOption).GetOptionValueByName("HospitalName")
  	s SpaceHIS=##class(EPRmeta.SysOption).GetOptionValueByName("NameSpaceHIS")
	if SpaceHIS'=""
	{
		s MEDDATA = $p($g(SpaceHIS),"^",1)
		s WEBSRC  = $p($g(SpaceHIS),"^",2)
	}
	s SpaceLIS=##class(EPRmeta.SysOption).GetOptionValueByName("NameSpaceLIS")
	if SpaceLIS'=""
	{
	    s LABDATA = $p($g(SpaceLIS),"^",1)
	    s LABSRC  = $p($g(SpaceLIS),"^",2)
	 }
	 Quit:((Hospital="")||(SpaceHIS="")||(SpaceLIS="")) $$$OK
	
 	// 标识号|登记RowId|就诊号|登记号|姓名
 	s EpisodeID=Adm
 	s PapmiDR = ##Class(EPRservice.HISInterface.PatientInfoAssist).GetPapmiDR(Adm)
 	s EpisodeNo=##Class(EPRservice.HISInterface.PatientInfoAssist).GetEpisodeNo(Adm)
 	s RegisterNo = ##Class(EPRservice.HISInterface.PatientInfoAssist).GetPapmiNo(PapmiDR)
	s Name=##Class(EPRservice.HISInterface.PatientInfoAssist).Name(PapmiDR)

	//BG_"^"_Rh_"^"_RBC_"^"_HCT_"^"_HGB_"^"_PLT_"^"_ALT_"^"_HBsAg_"^"_AntiHBs_"^"_HBeAg_"^"_AntiHBe_"^"_AntiHBc_"^"_AntiHCV_"^"_AntiHIV_"^"_MD
	s LabBldInfo=##Class(EPRservice.HISInterface.PatientInfoAssist).GetLabBldInfoNew(Adm)
	
	//ABO血型
	s BloodType=$p(LabBldInfo,"^",1)
	if (BloodType="") { s BloodType="未查" } 
	elseif ($L(BloodType,"ABO血型")>1) 
	{ 
		s BloodType=$P(BloodType,"ABO血型",2) 
		s BloodType=$P(BloodType,"型",1)
		}
	
	//Rh血型
	s Rh=$p(LabBldInfo,"^",2)
	if (Rh="") { s Rh="未查" } 
	elseif ($L(Rh,"Rh血型")>1) 
	{ 
		s Rh=$P(Rh,"Rh血型",2) 
		if ($L(Rh,"(+)")>1)
		{
			s Rh=$P(Rh,"(+)",1)
			if ($L(Rh,"性")>1) { s Rh=$P(Rh,"性",1) }
			}
		if ($L(Rh,"(-)")>1)
		{
			s Rh=$P(Rh,"(-)",1)
			if ($L(Rh,"性")>1) { s Rh=$P(Rh,"性",1) }
			}
	}
	
	//ALT丙氨酸氨基转移酶
	s ALT=$p(LabBldInfo,"^",7)
	if (ALT="") { s ALT="未查" } 
	elseif ($L(ALT,"U/L")>1) { s ALT=$P(ALT,"U/L",1) }
	//elseif (Rh="阴性(-)") { s Rh="阴" }
	
	//HBeAg乙肝e抗原
	s HBeAg=$p(LabBldInfo,"^",10)
	if (HBeAg="") { s HBeAg="未查" } 
	elseif (($e(HBeAg,1)="-")||($e(HBeAg,1)="阴")) { s HBeAg="阴性" }
	elseif (($e(HBeAg,1)="+")||($e(HBeAg,1)="阳")) { s HBeAg="阳性" }
	
	//HBeAg乙肝e抗体
	s HBeAb=$p(LabBldInfo,"^",11)
	if (HBeAb="") { s HBeAb="未查" } 
	elseif (($e(HBeAb,1)="-")||($e(HBeAb,1)="阴")) { s HBeAb="阴性" }
	elseif (($e(HBeAb,1)="+")||($e(HBeAb,1)="阳")) { s HBeAb="阳性" }
	
	//HBeAg乙肝核心抗体
	s HBcAb=$p(LabBldInfo,"^",12)
	if (HBcAb="") { s HBcAb="未查" } 
	elseif (($e(HBcAb,1)="-")||($e(HBcAb,1)="阴")) { s HBcAb="阴性" }
	elseif (($e(HBcAb,1)="+")||($e(HBcAb,1)="阳")) { s HBcAb="阳性" }
	
	//HbsAg乙肝病毒表面抗原
	s HbsAg=$p(LabBldInfo,"^",8)
	if (HbsAg="") { s HbsAg="未查" }
	elseif (($e(HbsAg,1)="-")||($e(HbsAg,1)="阴")) { s HbsAg="阴性" }
	elseif (($e(HbsAg,1)="+")||($e(HbsAg,1)="阳")) { s HbsAg="阳性" }
	
	//HbsAb乙肝病毒表面抗体
	s HbsAb=$p(LabBldInfo,"^",9)
	if (HbsAb="") { s HbsAb="未查" }
	elseif (($e(HbsAb,1)="-")||($e(HbsAb,1)="阴")) { s HbsAb="阴性" }
	elseif (($e(HbsAb,1)="+")||($e(HbsAb,1)="阳")) { s HbsAb="阳性" }

	//HCVAb丙型肝炎病毒抗体
	s HCVAb=$p(LabBldInfo,"^",13)
	;if (HCVAb="") { s HCVAb="未做" } 
	;s HCVAb=$e(HCVAb,$f(HCVAb,"("),$f(HCVAb,")")-3)
	if (HCVAb="") { s HCVAb="未查" } 
	elseif (($e(HCVAb,1)="-")||($e(HCVAb,1)="阴")) { s HCVAb="阴性" }
	elseif (($e(HCVAb,1)="+")||($e(HCVAb,1)="阳")) { s HCVAb="阳性" }
	
	//HIVAb艾滋病病毒抗体
	s HIVAb=$p(LabBldInfo,"^",14)
	if (HIVAb="") { s HIVAb="未查" } 
	elseif (($e(HIVAb,1)="阴")||($e(HIVAb,1)="-")) { s HIVAb="阴性" }
	elseif (($e(HIVAb,1)="阳")||($e(HIVAb,1)="+")) { s HIVAb="阳性" }
	
	//MD梅毒
	s MD=$p(LabBldInfo,"^",15)
	if (MD="") { s MD="未查" } 	
	elseif (($e(MD,1)="阴")||($e(MD,1)="-")) { s MD="阴性" }
	elseif (($e(MD,1)="阳")||($e(MD,1)="+")) { s MD="阳性" }
	

	set ^CacheTemp(repid, ind) = $LB(EpisodeID,PapmiDR,EpisodeNo,RegisterNo,Name,BloodType,Rh,HbsAg,HCVAb,HIVAb,MD,ALT,HBeAg,HbsAb,HBeAb,HBcAb)
	set ind = ind + 1
	
	Quit $$$OK
}

ClassMethod GetLabInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetLabInfoExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetLabInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetLabInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
	Quit $$$OK
}

/// ////////////////////////////////////////////////////////////////////////////////////////////////
/// Creator：	EPR
/// CreateDate：2009-03-16
/// Desc：		取患者检查信息[HIS]-05
/// Input:		Adm: 就诊rowid
/// Return：
/// Test:		##Class(EPRservice.SystemData).testcheck(Adm)		
Query GetCheckInfo(Adm As %String) As %Query(ROWSPEC = "EpisodeID")
{
}

ClassMethod GetCheckInfoExecute(ByRef qHandle As %Binary, Adm As %String) As %Status
{
	//b "s"
	Set repid=$I(^CacheTemp)
	s ind=1
	Set qHandle=$lb(0,repid,0)

	Quit:($d(^PAADM(Adm))=0)||(Adm="") $$$OK

	
    //取系统参数
	s Hospital=##class(EPRmeta.SysOption).GetOptionValueByName("HospitalName")
  	s SpaceHIS=##class(EPRmeta.SysOption).GetOptionValueByName("NameSpaceHIS")
	if SpaceHIS'=""
	{
		s MEDDATA = $p($g(SpaceHIS),"^",1)
		s WEBSRC  = $p($g(SpaceHIS),"^",2)
	}
	s SpaceLIS=##class(EPRmeta.SysOption).GetOptionValueByName("NameSpaceLIS")
	if SpaceLIS'=""
	{
	    s LABDATA = $p($g(SpaceLIS),"^",1)
	    s LABSRC  = $p($g(SpaceLIS),"^",2)
	 }
	 Quit:((Hospital="")||(SpaceHIS="")||(SpaceLIS="")) $$$OK
	/* 
	 s CurString="",CurT="",CurP="",CurHBP="",CurLBP="",CurSpO2=""
	 s CurString=##class(web.DHCEmergency).GetEMObservationItem(Adm)
	 if (CurString'="")
	 {
		 s CurT=$P(CurString,"^",1)
		 s CurP=$P(CurString,"^",2)
		 s CurHBP=$P(CurString,"^",3)
		 s CurLBP=$P(CurString,"^",4)
		 s CurSpO2=$P(CurString,"^",5)
		 }
        */
	// 初始化返回值
	

	set ^CacheTemp(repid, ind) = $LB(EpisodeID)
	set ind = ind + 1
	
	Quit $$$OK
}

ClassMethod GetCheckInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetCheckInfoExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetCheckInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetCheckInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
	Quit $$$OK
}

/// ////////////////////////////////////////////////////////////////////////////////////////////////
/// Creator：	EPR
/// CreateDate：2009-03-16
/// Desc：		取患者出入院信息[HIS]-06 200908OK
/// Input:		Adm: 就诊rowid
/// Return：
/// Test:		##Class(EPRservice.SystemData).testatd(Adm)		
Query GetATDInfo(Adm As %String) As %Query(ROWSPEC = "EpisodeID,PapmiDR,EpisodeNo,RegisterNo,Name,AdmDate,AdmTime,AdmDateTime,AdmDateInBed,AdmTimeInBed,AdmDateTimeInBed,AdmDept,AdmDeptDesc,AdmWard,AdmWardDesc,AdmRoom,AdmBed,DisDate,DisTime,DisDateTime,DisDept,DisDeptDesc,DisWard,DisWardDesc,DisRoom,DisBed,TransDept,TransDeptDetail,TransDateTime1st,TransDept1st,TransWard1st,TransDeptAgain,DeathDateTime,ResidentDays,InTimes,CurDept,CurDeptDesc,CurWard,CurWardDesc,CurRoom,CurBed,CurDate,CurTime,CurDatetime,InScore,OutScore,LastTransDept")
{
}

ClassMethod GetATDInfoExecute(ByRef qHandle As %Binary, Adm As %String) As %Status
{
	//b "s"
	
	Set repid=$I(^CacheTemp)
	s ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:($d(^PAADM(Adm))=0)||(Adm="") $$$OK
	
    //取系统参数
	s Hospital=##class(EPRmeta.SysOption).GetOptionValueByName("HospitalName")
  	s SpaceHIS=##class(EPRmeta.SysOption).GetOptionValueByName("NameSpaceHIS")
	if SpaceHIS'=""
	{
		s MEDDATA = $p($g(SpaceHIS),"^",1)
		s WEBSRC  = $p($g(SpaceHIS),"^",2)
	}
	s SpaceLIS=##class(EPRmeta.SysOption).GetOptionValueByName("NameSpaceLIS")
	if SpaceLIS'=""
	{
	    s LABDATA = $p($g(SpaceLIS),"^",1)
	    s LABSRC  = $p($g(SpaceLIS),"^",2)
	 }
	 Quit:((Hospital="")||(SpaceHIS="")||(SpaceLIS="")) $$$OK
	 

	// 初始化返回值
	
	// 入院信息
	s AdmDate="" ,AdmTime="" ,AdmDateTime="" ,AdmDateInBed="" ,AdmTimeInBed="" ,AdmDateTimeInBed="" ,AdmDept="" ,AdmDeptDesc="" ,AdmWard="" ,AdmWardDesc="" ,AdmRoom="" ,AdmBed="" 
	
	// 出院信息
	s DisDate="" ,DisTime="" ,DisDateTime="" ,DisDept="" ,DisDeptDesc="" ,DisWard="" ,DisWardDesc="" ,DisRoom="" ,DisBed="" ,DeathDateTime="" ,DisDateTimeMR="",DeathDate="",DeathTime=""
	
	// 转科信息
	s TransDept="" ,TransDeptDetail="" ,ResidentDays="" ,InTimes="" ,TransDateTime1st="" ,TransDept1st="" ,TransWard1st="" ,TransDeptAgain=""
	
	// 在院信息
	s CurDept="" ,CurDeptDesc="" ,CurWard="" ,CurWardDesc="" ,CurRoom="" ,CurBed=""


 	// 标识号|登记RowId|就诊号|登记号|姓名
 	s EpisodeID=Adm
 	s PapmiDR = ##Class(EPRservice.HISInterface.PatientInfoAssist).GetPapmiDR(Adm)
 	s EpisodeNo=##Class(EPRservice.HISInterface.PatientInfoAssist).GetEpisodeNo(Adm)
 	s RegisterNo = ##Class(EPRservice.HISInterface.PatientInfoAssist).GetPapmiNo(PapmiDR)
	s Name=##Class(EPRservice.HISInterface.PatientInfoAssist).Name(PapmiDR)


 	///////////////////////
 	// 患者入院信息大类  //
 	///////////////////////

	//	患者出入院情况大类
 	//	s AdmDoctor="",AdmDateTime="",AdmDate="",AdmTime="",AdmDateTimeInBed="",AdmDateInBed="",AdmTimeInBed="",InTimes="",AdmDept="",AdmWard="",AdmBed=""
 	//	s DischgDateTime="",DischgDate="",DischgTime="",DischgDept="",DischgWard="",DischgBed=""
 	//	s TransDept="",TransDeptDetail="",TransDeptInterface="",TransDeptFirstTime="",TransDeptFirstDept=""
 	//	s ResidentDays=""
 	//	s DeathDateTime="",DeathDate="",DeathTime=""
 	//	s MRDisDateTime="",MRDisDate="",MRDisTime="" 
	
	//	患者出入院情况大类
 

	// 入院登记日期 	[AdmDate]			PAAdm_AdmDate
	// 入院登记时间		[AdmTime]			PAAdm_AdmTime
	// 入院登记日期时间	[AdmDateTime]		PAAdm_AdmDate And PAAdm_AdmTime
	s AdmDateTime=##class(EPRservice.HISInterface.PatientInfoAssist).AdmDateTime(Adm,Hospital)
	i AdmDateTime'="" 
	{ 

		s AdmDate = $ZD($P($G(AdmDateTime),",",1),3)
		s AdmTime = $ZT($P($G(AdmDateTime),",",2),1)
		s AdmDateTime=AdmDate_" "_AdmTime
		
		s AdmDate =AdmDate_" "_"00:00:00"
	}  


	// 入院分床日期 	[AdmDateInBed]			
	// 入院分床时间		[AdmTimeInBed]			
	// 入院分床日期时间	[AdmDateTimeInBed]		
	s AdmDateTimeInBed=##class(EPRservice.HISInterface.PatientInfoAssist).AdmDateTimeInBed(Adm,Hospital)
	i AdmDateTimeInBed'="" 
	{
		s AdmDateInBed = $ZD($P($G(AdmDateTimeInBed),",",1),3)
		s AdmTimeInBed = $ZT($P($G(AdmDateTimeInBed),",",2),1)
		s AdmDateTimeInBed=AdmDateInBed_" "_AdmTimeInBed
		
		s AdmDateInBed =AdmDateInBed_" "_"00:00:00"
	}  

	// 入院科室			[AdmDept]
	// 入院科室描述		[AdmDeptDesc]
	s tmpAdmDept=##Class(EPRservice.HISInterface.PatientInfoAssist).AdmDept(Adm,Hospital)
	i tmpAdmDept'=""
 	{
   		s AdmDept = $p($g(tmpAdmDept),"^",1)
   		s AdmDept = AdmDept_"^"_$p($g(tmpAdmDept),"^",3)
   		s AdmDeptDesc = $p($g(tmpAdmDept),"^",3)
   		//HNZLYY PRIVACY
   		//s AdmDept =$p($g(tmpAdmDept),"^",1)_"^"_..ConvertLocation(AdmDeptDesc,"E")
   		//s AdmDeptDesc = ..ConvertLocation(AdmDeptDesc,"E")	
 	} 

	// 入院病区			[AdmWard]
	// 入院病区描述		[AdmWardDesc]
	s tmpAdmWard=##Class(EPRservice.HISInterface.PatientInfoAssist).AdmWard(Adm,Hospital)
	i tmpAdmWard'=""
 	{
   		s AdmWard = $p($g(tmpAdmWard),"^",1)
   		s AdmWard = AdmWard_"^"_$p($g(tmpAdmWard),"^",3)
   		s AdmWardDesc = $p($g(tmpAdmWard),"^",3)
   		//HNZLYY PRIVACY
   		//s AdmWard = $p($g(tmpAdmWard),"^",1)_"^"_..ConvertLocation(AdmWardDesc,"W")
   		//s AdmWardDesc = ..ConvertLocation(AdmWardDesc,"W")
 	}

 	// 入院病室			[AdmRoom]
	s tmpAdmRoom=##Class(EPRservice.HISInterface.PatientInfoAssist).AdmRoom(Adm,Hospital)
	i tmpAdmRoom'=""
 	{
   		s AdmRoom = $p($g(tmpAdmRoom),"^",3)
 	}

	// 入院床号			[AdmBed]
	s AdmBed=##Class(EPRservice.HISInterface.PatientInfoAssist).AdmBed(Adm) 
 
 
  	///////////////////////
 	// 患者出院信息大类  //
 	///////////////////////
 
 
 	//DisDate,DisTime,DisDateTime,DisDept,DisDeptDesc,DisWard,DisWardDesc,DisBed,
 	//b "s"
	// 出院日期 		[DisDate]			PAAdm_DischgDate
	// 出院时间			[DisTime]			PAAdm_DischgTime
	// 出院日期时间		[DisDateTime]		PAAdm_DischgDate And PAAdm_DischgTime
	s DisDateTime=##class(EPRservice.HISInterface.PatientInfoAssist).DisDateTime(Adm,Hospital)
	s DeathDateTime=##class(EPRservice.HISInterface.PatientInfoAssist).DeathDateTime(PapmiDR,Hospital)
	s DisDateTimeMR=##Class(EPRservice.HISInterface.PatientInfoAssist).DisDateTimeMR(Adm,Hospital)
 	s DisDateTimeDoctor=##Class(EPRservice.HISInterface.PatientInfoAssist).DisDateTimeDoctor(Adm,Hospital)
 	
 	//^DHCWLInitStat("Discharge")="E"预计出院日期
	//^DHCWLInitStat("Discharge")="D"最终结算日期
	//^DHCWLInitStat("Discharge")="C"财务结算日期
	//^DHCWLInitStat("Discharge")="H"手工填写
 	if ($d(^DHCWLInitStat("Discharge"))'=0)
 	{
	 	if ($g(^DHCWLInitStat("Discharge"))="E")
	 	{
			s DisDate = $ZD($P($G(DisDateTimeDoctor),",",1),3)
			s DisTime = $ZT($P($G(DisDateTimeDoctor),",",2),1)
			s DisDateTime=DisDate_" "_DisTime
	 	}
	 	elseif ($g(^DHCWLInitStat("Discharge"))="D")
	 	{
			s DisDate = $ZD($P($G(DisDateTime),",",1),3)
			s DisTime = $ZT($P($G(DisDateTime),",",2),1)
			s DisDateTime=DisDate_" "_DisTime
	 	}
	 	elseif ($p($g(DisDateTimeMR),",",1)'="")&&($p($g(DisDateTimeMR),",",2)'="")
	 	{
			s DisDate = $ZD($P($G(DisDateTime),",",1),3)
			s DisTime = $ZT($P($G(DisDateTime),",",2),1)
			s DisDateTime=DisDate_" "_DisTime
	 	}
 	}
 	else
 	{
		if DisDateTime'="" 
		{ 
			s DisDate = $ZD($P($G(DisDateTime),",",1),3)
			s DisTime = $ZT($P($G(DisDateTime),",",2),1)
			s DisDateTime=DisDate_" "_DisTime
			
			//s DisDate =DisDate_" "_"00:00:00"
		} 
	 	
	 	// 统计组[袁旭] 日期时间
		if ($p($g(DisDateTimeMR),",",1)'="")&&($p($g(DisDateTimeMR),",",2)'="")
		{ 
			
			s DisDate = $ZD($P($G(DisDateTimeMR),",",1),3)
			s DisTime = $ZT($P($G(DisDateTimeMR),",",2),1)
			s DisDateTime=DisDate_" "_DisTime
			
			//s DisDate =DisDate_" "_"00:00:00"
		} 
	 	
	 	// 死亡日期时间
		if DeathDateTime'="" 
		{ 
			s DeathDate = $ZD($P($G(DeathDateTime),",",1),3)
			s DeathTime = $ZT($P($G(DeathDateTime),",",2),1)
	   		s DeathDateTime=DeathDate_" "_DeathTime
			
			s DisDateTime=DeathDateTime
			
			//s DisDate =DisDate_" "_"00:00:00"
		}
 	}

	// 出院科室			[DisDept]
	// 出院科室描述		[DisDeptDesc]
	s tmpDisDept=##Class(EPRservice.HISInterface.PatientInfoAssist).DisDept(Adm,Hospital) 
	i tmpDisDept'=""
 	{
   		s DisDept = $p($g(tmpDisDept),"^",1)
   		s DisDept = DisDept_"^"_$p($g(tmpDisDept),"^",3)
   		s DisDeptDesc = $p($g(tmpDisDept),"^",3)
   		//HNZLYY PRIVACY
   		//s DisDept =$p($g(tmpDisDept),"^",1)_"^"_..ConvertLocation(DisDeptDesc,"E")
   		//s DisDeptDesc = ..ConvertLocation(DisDeptDesc,"E")
 	}
 	
	// 出院病区			[DisWard]
	// 出院病区描述		[DisWardDesc]
	s tmpDisWard=##Class(EPRservice.HISInterface.PatientInfoAssist).DisWard(Adm,Hospital)
	i tmpDisWard'=""
 	{
   		s DisWard = $p($g(tmpDisWard),"^",1)
   		s DisWard = DisWard_"^"_$p($g(tmpDisWard),"^",3)
   		s DisWardDesc = $p($g(tmpDisWard),"^",3)
   		//HNZLYY PRIVACY
   		s DisWard = $p($g(tmpDisWard),"^",1)_"^"_..ConvertLocation(DisWardDesc,"W")
   		s DisWardDesc = ..ConvertLocation(DisWardDesc,"W")
 	}

 	// 出院病室			[DisRoom]
	s tmpDisRoom=##Class(EPRservice.HISInterface.PatientInfoAssist).DisRoom(Adm,Hospital)
	i tmpDisRoom'=""
 	{
   		s DisRoom = $p($g(tmpDisRoom),"^",3)

 	}
 	
	// 出院床号			[DisBed]
	s DisBed=##Class(EPRservice.HISInterface.PatientInfoAssist).DisBed(Adm)

 
   	///////////////////////
 	// 患者转科信息大类  //
 	///////////////////////

	
	// 转科情况			[TransDept]
	//末次转科 格式:转出科室->转入科室
	s LastTransDept=""
	s TransDept=##Class(EPRservice.HISInterface.PatientInfoAssist).TransDept(Adm) 
	if ($l(TransDept,"->")>1)
	{
		s Count=$l(TransDept,"->")
		if (Count=2)
		{
			s TransDept=$p(TransDept,"->",2)
			s LastTransDept=TransDept
			}
		else 
		{
			s TransDept=$p(TransDept,"->",Count-1)
			s LastTransDept=TransDept_"->"_$p(TransDept,"->",Count)
			}
		}
 
	// 转科情况明细		[TransDeptDetail]
	s TransDeptDetail=##Class(EPRservice.HISInterface.PatientInfoAssist).TransDeptDetail(Adm,Hospital) 

	
	

	// 住院天数			[ResidentDays]
	s ResidentDays=##Class(EPRservice.HISInterface.PatientInfoAssist).ResidentDaysAdm(Adm,Hospital)

	// 入院次数			[InTimes]
	s InTimes=##Class(EPRservice.HISInterface.PatientInfoAssist).InTimes(Adm,Hospital)
	s tmpInTimes=##Class(EPRservice.HISInterface.PatientInfoAssist).InTimesWMR(Adm,Hospital)
	// 如果医政组接口正确 则取接口入院次数
	i tmpInTimes'=""
	{
		s InTimes=tmpInTimes
	}
	//转科日期时间1st[日期] TransDateTime1st,TransDept1st,TransWard1st,TransDeptAgain
	s:(TransDeptDetail'="")&&(TransDeptDetail'="无") TransDateTime1st=$tr($p($p(TransDeptDetail,"->",2),"^",3,4),"^"," ")
	
	//转科科室1st[字典]
	s:(TransDeptDetail'="")&&(TransDeptDetail'="无") TransDept1st=$p($p(TransDeptDetail,"->",2),"^",1,2)

	//转科病区1st[字典]
	s:(TransDeptDetail'="")&&(TransDeptDetail'="无") TransWard1st=$p($p(TransDeptDetail,"->",2),"^",5,6)
	
	//再转科别[字符]
	s:($f($e(TransDept,$f(TransDept,"->"),$l(TransDept)),"->")'=0) TransDeptAgain=$e(TransDept,$f(TransDept,"->"),$l(TransDept))
	s:(TransDeptAgain'="") TransDeptAgain=$e(TransDeptAgain,$f(TransDeptAgain,"->"),$l(TransDeptAgain))
    s:(TransDept="无")||(TransDeptAgain="") TransDeptAgain="无"
 
   	///////////////////////
 	// 患者在院信息大类  //
 	///////////////////////
 	//当前日期时间
 	s CurDate="",CurTime="",CurDatetime=""
 	s CurDate=$zd($p($h,",",1),3)
 	s CurTime=$zt($p($h,",",2),1)
 	s CurDatetime=CurDate_" "_CurTime
 	
 	// 当前科室			[CurDept]
	// 当前科室描述		[CurDeptDesc]
	s CurDept=DisDept
	s CurDeptDesc=DisDeptDesc
 	
	// 当前病区			[CurWard]
	// 当前病区描述		[CurWardDesc]
	s CurWard=DisWard
	s CurWardDesc=DisWardDesc

 	// 当前病室			[CurRoom]
	s CurRoom=DisRoom
 	
	// 当前床号			[CurBed]
	s CurBed=DisBed
	
	//Add by Liaowp 2012-1-15
	//患者入出院生活能力评分
	s ScoreStr="",InScore="",OutScore=""
	s ScoreStr=##class(EPRservice.HISInterface.PatientInfoAssist).PatSelfCareDegree(Adm)
	s InScore=$P(ScoreStr,"^",1)
	s OutScore=$P(ScoreStr,"^",2)

	set ^CacheTemp(repid, ind) = $LB(EpisodeID,PapmiDR,EpisodeNo,RegisterNo,Name,AdmDate,AdmTime,AdmDateTime,AdmDateInBed,AdmTimeInBed,AdmDateTimeInBed,AdmDept,AdmDeptDesc,AdmWard,AdmWardDesc,AdmRoom,AdmBed,DisDate,DisTime,DisDateTime,DisDept,DisDeptDesc,DisWard,DisWardDesc,DisRoom,DisBed,TransDept,TransDeptDetail,TransDateTime1st,TransDept1st,TransWard1st,TransDeptAgain,DeathDateTime,ResidentDays,InTimes,CurDept,CurDeptDesc,CurWard,CurWardDesc,CurRoom,CurBed,CurDate,CurTime,CurDatetime,InScore,OutScore,LastTransDept)
	set ind = ind + 1
	
	Quit $$$OK
}

ClassMethod GetATDInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetATDInfoExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetATDInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetATDInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
	Quit $$$OK
}

/// ////////////////////////////////////////////////////////////////////////////////////////////////
/// Creator：	EPR
/// CreateDate：2009-03-16
/// Desc：		取费用信息病案大类[HIS]-07 200908OK
/// Input:		Adm: 就诊rowid
/// Return：
/// Test:		##Class(EPRservice.SystemData).testtmc(Adm)		
Query GetTMCFeeInfo(Adm As %String) As %Query(ROWSPEC = "EpisodeID,PapmiDR,EpisodeNo,RegisterNo,Name,TMCTotal,TMC12CWF,TMC13FSF,TMC14HLF,TMC15HYF,TMC16JCF,TMC17JSF,TMC18MZF,TMC19PCF,TMC20QTF,TMC22SSF,TMC23SXF,TMC24SYF,TMC25XYF,TMC26YEF,TMC27ZLF,TMC28ZLF,TMC29ZCYF,TMC30ZCHYF,TMCCheckFeeTag")
{
}

ClassMethod GetTMCFeeInfoExecute(ByRef qHandle As %Binary, Adm As %String) As %Status
{
	//b "s"
	
	Set repid=$I(^CacheTemp)
	s ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:($d(^PAADM(Adm))=0)||(Adm="") $$$OK

    //取系统参数
	s Hospital=##class(EPRmeta.SysOption).GetOptionValueByName("HospitalName")
  	s SpaceHIS=##class(EPRmeta.SysOption).GetOptionValueByName("NameSpaceHIS")
	if SpaceHIS'=""
	{
		s MEDDATA = $p($g(SpaceHIS),"^",1)
		s WEBSRC  = $p($g(SpaceHIS),"^",2)
	}
	s SpaceLIS=##class(EPRmeta.SysOption).GetOptionValueByName("NameSpaceLIS")
	if SpaceLIS'=""
	{
	    s LABDATA = $p($g(SpaceLIS),"^",1)
	    s LABSRC  = $p($g(SpaceLIS),"^",2)
	 }
	 Quit:((Hospital="")||(SpaceHIS="")||(SpaceLIS="")) $$$OK
	 

	// 初始化返回值
	s ResultFee=""
	
	// 标识号|登记RowId|就诊号|登记号|姓名
 	s EpisodeID=Adm
 	s PapmiDR = ##Class(EPRservice.HISInterface.PatientInfoAssist).GetPapmiDR(Adm)
 	s EpisodeNo=##Class(EPRservice.HISInterface.PatientInfoAssist).GetEpisodeNo(Adm)
 	s RegisterNo = ##Class(EPRservice.HISInterface.PatientInfoAssist).GetPapmiNo(PapmiDR)
	s Name=##Class(EPRservice.HISInterface.PatientInfoAssist).Name(PapmiDR)

	
	// 患者费用(病案费用大类)
	s InPatFee="" ,CheckTotal="" ,CheckFee="" ,CheckFeeTag=""
	s InPatFee=##class(EPRservice.HISInterface.PatientInfoAssist).InPatCostTrakCare(Adm,Hospital)
	s FeeNum=$l(InPatFee,"!")
	s i=0,FeeList="",tmpFee=""
	f i=1:1:(FeeNum) d
	.s tmpFee=$p(InPatFee,"!",i)
	.i tmpFee'="" {s ResultFee=ResultFee_$lb($p($p(InPatFee,"!",i),"^",3))}
	.i i=1 {s CheckTotal=$p($p(InPatFee,"!",i),"^",3)} 
	.i i>1 {s CheckFee=CheckFee+$p($p(InPatFee,"!",i),"^",3)}
 
	// 费用合计与费用子项审核
	i $fn(CheckTotal,"",2)'=$fn(CheckFee,"",2) { s CheckFeeTag="CheckFeeERROR" } else {s CheckFeeTag="CheckFeeOK" }
	s ResultFee=ResultFee_$lb(CheckFeeTag)


	set ^CacheTemp(repid, ind) = $LB(EpisodeID,PapmiDR,EpisodeNo,RegisterNo,Name)_ResultFee
	set ind = ind + 1
	
	Quit $$$OK
}

ClassMethod GetTMCFeeInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetTMCFeeInfoExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetTMCFeeInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetTMCFeeInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
	Quit $$$OK
}

/// ////////////////////////////////////////////////////////////////////////////////////////////////
/// Creator：	EPR
/// CreateDate：2009-03-16
/// Desc：		取费用信息病案子类[HIS]-08 200908OK
/// Input:		Adm: 就诊rowid
/// Return：
/// Test:		##Class(EPRservice.SystemData).testmc(Adm)		
Query GetMCFeeInfo(Adm As %String) As %Query(ROWSPEC = "EpisodeID,PapmiDR,EpisodeNo,RegisterNo,Name,TMCTotal,TMC01CWF,TMC02HLF,TMC03XYF,TMC04ZCHYF,TMC05ZCYF,TMC06FSF,TMC07HYF,TMC08SYF,TMC09SXF,TMC10ZLF,TMC11SSF,TMC12JSF,TMC13JCF,TMC14MZF,TMC15YEF,TMC16PCF,TMC17QTF,TMCCheckFeeTag")
{
}

ClassMethod GetMCFeeInfoExecute(ByRef qHandle As %Binary, Adm As %String) As %Status
{
	//b "s"
	
	Set repid=$I(^CacheTemp)
	s ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:($d(^PAADM(Adm))=0)||(Adm="") $$$OK

    //取系统参数
	s Hospital=##class(EPRmeta.SysOption).GetOptionValueByName("HospitalName")
  	s SpaceHIS=##class(EPRmeta.SysOption).GetOptionValueByName("NameSpaceHIS")
	if SpaceHIS'=""
	{
		s MEDDATA = $p($g(SpaceHIS),"^",1)
		s WEBSRC  = $p($g(SpaceHIS),"^",2)
	}
	s SpaceLIS=##class(EPRmeta.SysOption).GetOptionValueByName("NameSpaceLIS")
	if SpaceLIS'=""
	{
	    s LABDATA = $p($g(SpaceLIS),"^",1)
	    s LABSRC  = $p($g(SpaceLIS),"^",2)
	 }
	 Quit:((Hospital="")||(SpaceHIS="")||(SpaceLIS="")) $$$OK
	 
	
	// 初始化返回值
	s ResultFee=""
	
	// 标识号|登记RowId|就诊号|登记号|姓名
 	s EpisodeID=Adm
 	s PapmiDR = ##Class(EPRservice.HISInterface.PatientInfoAssist).GetPapmiDR(Adm)
 	s EpisodeNo=##Class(EPRservice.HISInterface.PatientInfoAssist).GetEpisodeNo(Adm)
 	s RegisterNo = ##Class(EPRservice.HISInterface.PatientInfoAssist).GetPapmiNo(PapmiDR)
	s Name=##Class(EPRservice.HISInterface.PatientInfoAssist).Name(PapmiDR)

	
	// 患者费用(病案费用子类)
	s InPatFee="" , CheckTotal="",CheckFee="",CheckFeeTag=""
	s InPatFee=##class(EPRservice.HISInterface.PatientInfoAssist).InPatCostTrakCareSub(Adm,Hospital)
	s FeeNum=$l(InPatFee,"!")
	s i=0,FeeList="",tmpFee=""
	f i=1:1:(FeeNum) d
	.s tmpFee=$p(InPatFee,"!",i)
	.i tmpFee'="" {s ResultFee=ResultFee_$lb($p($p(InPatFee,"!",i),"^",3))}
	.i i=1 {s CheckTotal=$p($p(InPatFee,"!",i),"^",3)} 
	.i i>1 {s CheckFee=CheckFee+$p($p(InPatFee,"!",i),"^",3)}
 
 
	// 费用合计与费用子项审核
	i $fn(CheckTotal,"",2)'=$fn(CheckFee,"",2) { s CheckFeeTag="CheckFeeERROR" } else {s CheckFeeTag="CheckFeeOK" }
	s ResultFee=ResultFee_$lb(CheckFeeTag)


	set ^CacheTemp(repid, ind) = $LB(EpisodeID,PapmiDR,EpisodeNo,RegisterNo,Name)_ResultFee
	set ind = ind + 1
	
	Quit $$$OK
}

ClassMethod GetMCFeeInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetMCFeeInfoExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetMCFeeInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetMCFeeInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
	Quit $$$OK
}

/// ////////////////////////////////////////////////////////////////////////////////////////////////
/// Creator：	EPR
/// CreateDate：2009-03-16
/// Desc：		取用户登录信息[HIS]-09 200908OK
/// Input:		UserId: SS_User rowid
/// Return：
Query GetUserInfo(parUserId As %String) As %SQLQuery(CONTAINID = 0)
{
	SELECT SSUSR_Initials as CurUserCode ,SSUSR_Name as CurUserName ,SSUSR_Initials||'^'||SSUSR_Name as CurUserCodeAndName
	FROM   SQLUser.SS_User
	WHERE  SSUSR_Rowid=:parUserId
}

/// ////////////////////////////////////////////////////////////////////////////////////////////////
/// Creator：	EPR
/// CreateDate：2009-03-16
/// Desc：		取用户自定义信息[HIS]-10 200908OK
/// Input:		Adm: 就诊rowid
/// Return：
/// Test:		##Class(EPRservice.SystemData).tescus(Adm)		
Query GetCustomInfo(Adm As %String) As %Query(ROWSPEC = "EpisodeID,PapmiDR,EpisodeNo,RegisterNo,Name,RescueCount,TraOutDiag,TraAdmDiag1,TraDiag1,TraDiag2,TraDiag3,TraDiag4,TraDiag5,TraDiag6,TraDiag7,TraDiag8,TraDiag9,TraDiag10,TraDiag11,TraDiag12,TraDiag13,TraDiag14,TraDiag15,TraDiag16,TraOper1,TraOper2,TraOper3,TraOper4,TraOper5,TraOper6,TraOper7,TraOper8,TraOper9,TraOper10,OperData,TimeStart,TimeClose,OperDiag,OperName,AnaestMethod,OperContent,IsFZJC,IsXCG,IsNCG,IsBCG,IsSHJC,IsNXGN,IsSGBD,IsQTBYKT,IsXDT,IsXXJC,IsCSJC,IsCTJC,IsMRIJC,IsQTJC,IsFemaleAndFirstTime,IsFirstTime,EPGLASGOW,EPAPACHE")
{
}

ClassMethod GetCustomInfoExecute(ByRef qHandle As %Binary, Adm As %String) As %Status
{
	//b "s"
	
	Set repid=$I(^CacheTemp)
	s ind=1
	Set qHandle=$lb(0,repid,0)

	Quit:($d(^PAADM(Adm))=0)||(Adm="") $$$OK
	
    //取系统参数
	s Hospital=##class(EPRmeta.SysOption).GetOptionValueByName("HospitalName")
  	s SpaceHIS=##class(EPRmeta.SysOption).GetOptionValueByName("NameSpaceHIS")
	if SpaceHIS'=""
	{
		s MEDDATA = $p($g(SpaceHIS),"^",1)
		s WEBSRC  = $p($g(SpaceHIS),"^",2)
	}
	s SpaceLIS=##class(EPRmeta.SysOption).GetOptionValueByName("NameSpaceLIS")
	if SpaceLIS'=""
	{
	    s LABDATA = $p($g(SpaceLIS),"^",1)
	    s LABSRC  = $p($g(SpaceLIS),"^",2)
	 }
	 Quit:((Hospital="")||(SpaceHIS="")||(SpaceLIS="")) $$$OK

	// 初始化返回值
	s InstanceCount=""


	// 标识号|登记RowId|就诊号|登记号|姓名
 	s EpisodeID=Adm
 	s PapmiDR = ##Class(EPRservice.HISInterface.PatientInfoAssist).GetPapmiDR(Adm)
 	s EpisodeNo=##Class(EPRservice.HISInterface.PatientInfoAssist).GetEpisodeNo(Adm)
 	s RegisterNo = ##Class(EPRservice.HISInterface.PatientInfoAssist).GetPapmiNo(PapmiDR)
	s Name=##Class(EPRservice.HISInterface.PatientInfoAssist).Name(PapmiDR)
	
	
	//Begin======================取首页诊断和手术ValueCode转换为icd10================================================
	
	s Diag1= "主要诊断1#TYPE:Simple#TID:2#TVER:0#SCODE:I0002#VTYPE:C"
	s Diag2= "次要诊断2#TYPE:Simple#TID:2#TVER:0#SCODE:I0003#VTYPE:C"
	s Diag3= "次要诊断3#TYPE:Simple#TID:2#TVER:0#SCODE:I0009#VTYPE:C"
	s Diag4= "次要诊断4#TYPE:Simple#TID:2#TVER:0#SCODE:I0010#VTYPE:C"
	s Diag5= "次要诊断5#TYPE:Simple#TID:2#TVER:0#SCODE:I0011#VTYPE:C"
	s Diag6= "次要诊断6#TYPE:Simple#TID:2#TVER:0#SCODE:I0012#VTYPE:C"
	s Diag7= "次要诊断7#TYPE:Simple#TID:2#TVER:0#SCODE:I0013#VTYPE:C"
	s Diag8= "次要诊断8#TYPE:Simple#TID:2#TVER:0#SCODE:I0036#VTYPE:C"
	//s Diag9= "次要诊断9#TYPE:Simple#TID:2#TVER:0#SCODE:I0109#VTYPE:C"
	//s Diag10= "次要诊断10#TYPE:Simple#TID:2#TVER:0#SCODE:I0110#VTYPE:C"
	//s Diag11= "次要诊断11#TYPE:Simple#TID:2#TVER:0#SCODE:I0108#VTYPE:C"
	//s Diag12= "次要诊断12#TYPE:Simple#TID:2#TVER:0#SCODE:I0107#VTYPE:C"
	//s Diag13= "次要诊断13#TYPE:Simple#TID:2#TVER:0#SCODE:I0037#VTYPE:C"
	//s Diag14= "次要诊断14#TYPE:Simple#TID:2#TVER:0#SCODE:I0035#VTYPE:C"
	//s Diag15= "次要诊断15#TYPE:Simple#TID:2#TVER:0#SCODE:I0090#VTYPE:C"
	//s Diag16= "次要诊断16#TYPE:Simple#TID:2#TVER:0#SCODE:I0038#VTYPE:C"
	s Oper1= "手术操作名称1#TYPE:Simple#TID:3#TVER:0#SCODE:I0022#VTYPE:C"
	s Oper2= "手术操作名称2#TYPE:Simple#TID:3#TVER:0#SCODE:I0023#VTYPE:C"
	s Oper3= "手术操作名称3#TYPE:Simple#TID:3#TVER:0#SCODE:I0024#VTYPE:C"
	s Oper4= "手术操作名称4#TYPE:Simple#TID:3#TVER:0#SCODE:I0025#VTYPE:C"
	s Oper5= "手术操作名称5#TYPE:Simple#TID:3#TVER:0#SCODE:I0093#VTYPE:C"
	s Oper6= "手术操作名称6^#TYPE:Simple#TID:6#TVER:0#SCODE:I0022#VTYPE:C"
	s Oper7= "手术操作名称7^#TYPE:Simple#TID:6#TVER:0#SCODE:I0023#VTYPE:C"
	s Oper8= "手术操作名称8^#TYPE:Simple#TID:6#TVER:0#SCODE:I0024#VTYPE:C"
	s Oper9= "手术操作名称9^#TYPE:Simple#TID:6#TVER:0#SCODE:I0025#VTYPE:C"
	s Oper10= "手术操作名称10^#TYPE:Simple#TID:6#TVER:0#SCODE:I0093#VTYPE:C"

	
	//门诊诊断icd10
	s OutDiag="门(急)诊诊断^#TYPE:Simple#TID:1#TVER:0#SCODE:I0043#VTYPE:C"
	//入院诊断icd10
	s AdmDiag1="入院诊断1^#TYPE:Simple#TID:1#TVER:0#SCODE:I0044#VTYPE:C"
	//s AdmDiag2="入院诊断2^#TYPE:Simple#TID:1#TVER:0#SCODE:I0078#VTYPE:C"
	

	s DiagDR1 =##class(EPRservice.BOScatterData).GetEPRData(Adm, Diag1)
	s DiagDR2 =##class(EPRservice.BOScatterData).GetEPRData(Adm, Diag2)
	s DiagDR3 =##class(EPRservice.BOScatterData).GetEPRData(Adm, Diag3)
	s DiagDR4 =##class(EPRservice.BOScatterData).GetEPRData(Adm, Diag4)
	s DiagDR5 =##class(EPRservice.BOScatterData).GetEPRData(Adm, Diag5)
	s DiagDR6 =##class(EPRservice.BOScatterData).GetEPRData(Adm, Diag6)
	s DiagDR7 =##class(EPRservice.BOScatterData).GetEPRData(Adm, Diag7)
	s DiagDR8 =##class(EPRservice.BOScatterData).GetEPRData(Adm, Diag8)
	//s DiagDR9 =##class(EPRservice.BOScatterData).GetEPRData(Adm, Diag9)
	//s DiagDR10 =##class(EPRservice.BOScatterData).GetEPRData(Adm, Diag10)
	//s DiagDR11 =##class(EPRservice.BOScatterData).GetEPRData(Adm, Diag11)
	//s DiagDR12 =##class(EPRservice.BOScatterData).GetEPRData(Adm, Diag12)
	//s DiagDR13 =##class(EPRservice.BOScatterData).GetEPRData(Adm, Diag13)
	//s DiagDR14 =##class(EPRservice.BOScatterData).GetEPRData(Adm, Diag14)
	//s DiagDR15 =##class(EPRservice.BOScatterData).GetEPRData(Adm, Diag15)
	//s DiagDR16 =##class(EPRservice.BOScatterData).GetEPRData(Adm, Diag16)
	s OperDR1 =##class(EPRservice.BOScatterData).GetEPRData(Adm, Oper1)
	s OperDR2 =##class(EPRservice.BOScatterData).GetEPRData(Adm, Oper2)
	s OperDR3 =##class(EPRservice.BOScatterData).GetEPRData(Adm, Oper3)
	s OperDR4 =##class(EPRservice.BOScatterData).GetEPRData(Adm, Oper4)
	s OperDR5 =##class(EPRservice.BOScatterData).GetEPRData(Adm, Oper5)
	s OperDR6 =##class(EPRservice.BOScatterData).GetEPRData(Adm, Oper6)
	s OperDR7 =##class(EPRservice.BOScatterData).GetEPRData(Adm, Oper7)
	s OperDR8 =##class(EPRservice.BOScatterData).GetEPRData(Adm, Oper8)
	s OperDR9 =##class(EPRservice.BOScatterData).GetEPRData(Adm, Oper9)
	s OperDR10 =##class(EPRservice.BOScatterData).GetEPRData(Adm, Oper10)


	//门诊诊断icd10 
	s OutDiagDR=##class(EPRservice.BOScatterData).GetEPRData(Adm, OutDiag)
	//入院诊断icd10
	s AdmDiagDR1=##class(EPRservice.BOScatterData).GetEPRData(Adm, AdmDiag1)
	//s AdmDiagDR2=##class(EPRservice.BOScatterData).GetEPRData(Adm, AdmDiag2)


	i DiagDR1'=""  s TraDiag1= $p($g(^MRC("ID",DiagDR1)),"^",4)
	i DiagDR2'=""  s TraDiag2= $p($g(^MRC("ID",DiagDR2)),"^",4)
	i DiagDR3'=""  s TraDiag3= $p($g(^MRC("ID",DiagDR3)),"^",4)
	i DiagDR4'=""  s TraDiag4= $p($g(^MRC("ID",DiagDR4)),"^",4)
	i DiagDR5'=""  s TraDiag5= $p($g(^MRC("ID",DiagDR5)),"^",4)
	i DiagDR6'=""  s TraDiag6= $p($g(^MRC("ID",DiagDR6)),"^",4)
	i DiagDR7'=""  s TraDiag7= $p($g(^MRC("ID",DiagDR7)),"^",4)
	i DiagDR8'=""  s TraDiag8= $p($g(^MRC("ID",DiagDR8)),"^",4)
	//i DiagDR9'=""  s TraDiag9= $p($g(^MRC("ID",DiagDR9)),"^",4)
	//i DiagDR10'=""  s TraDiag10= $p($g(^MRC("ID",DiagDR10)),"^",4)
	//i DiagDR11'=""  s TraDiag11= $p($g(^MRC("ID",DiagDR11)),"^",4)
	//i DiagDR12'=""  s TraDiag12= $p($g(^MRC("ID",DiagDR12)),"^",4)
	//i DiagDR13'=""  s TraDiag13= $p($g(^MRC("ID",DiagDR13)),"^",4)
	//i DiagDR14'=""  s TraDiag14= $p($g(^MRC("ID",DiagDR14)),"^",4)
	//i DiagDR15'=""  s TraDiag15= $p($g(^MRC("ID",DiagDR15)),"^",4)
	//i DiagDR16'=""  s TraDiag16= $p($g(^MRC("ID",DiagDR16)),"^",4)
	
	i OperDR1'=""  s TraOper1= $p($g(^ORC("OPER",OperDR1)),"^",14)
	i OperDR2'=""  s TraOper2= $p($g(^ORC("OPER",OperDR2)),"^",14)
	i OperDR3'=""  s TraOper3= $p($g(^ORC("OPER",OperDR3)),"^",14)
	i OperDR4'=""  s TraOper4= $p($g(^ORC("OPER",OperDR4)),"^",14)
	i OperDR5'=""  s TraOper5= $p($g(^ORC("OPER",OperDR5)),"^",14)
	i OperDR6'=""  s TraOper6= $p($g(^ORC("OPER",OperDR6)),"^",14)
	i OperDR7'=""  s TraOper7= $p($g(^ORC("OPER",OperDR7)),"^",14)
	i OperDR8'=""  s TraOper8= $p($g(^ORC("OPER",OperDR8)),"^",14)
	i OperDR9'=""  s TraOper9= $p($g(^ORC("OPER",OperDR9)),"^",14)
	i OperDR10'=""  s TraOper10= $p($g(^ORC("OPER",OperDR10)),"^",14)

	
	
	//门诊诊断icd10 
	i OutDiagDR'=""  s TraOutDiag= $p($g(^MRC("ID",OutDiagDR)),"^",4)
	//入院诊断icd10
	i AdmDiagDR1'=""  s TraAdmDiag1= $p($g(^MRC("ID",AdmDiagDR1)),"^",4)
	//i AdmDiagDR2'=""  s TraAdmDiag2= $p($g(^MRC("ID",AdmDiagDR2)),"^",4)

		
	//End========================取首页诊断和手术ValueCode转换为icd10================================================
	
	
	
	//Begin======================术后首次病程绑定手术在记录信息================================================
	/*
	s BindTagCode="#TYPE:Simple#TID:172#TVER:0#SCODE:O0001#VTYPE:C"
	s OperData="",TimeStart="",TimeClose="",OperDiag="",OperName="",AnaestMethod="",OperContent=""
	
	s BindTag=##class(EPRservice.BOScatterData).GetEPRData(Adm,BindTagCode)
	
	if (BindTag=1)
	{
		s OperData=##class(EPRservice.BOScatterData).GetEPRData(Adm,"手术日期#TYPE:Simple#TID:46#TVER:0#SCODE:D0005#VTYPE:C")
		s TimeStart=##class(EPRservice.BOScatterData).GetEPRData(Adm,"开始时间#TYPE:Simple#TID:46#TVER:0#SCODE:D0028#VTYPE:C")
		s TimeClose=##class(EPRservice.BOScatterData).GetEPRData(Adm,"术毕时间#TYPE:Simple#TID:46#TVER:0#SCODE:D0029#VTYPE:C")
		s OperDiag=##class(EPRservice.BOScatterData).GetEPRData(Adm,"术后诊断#TYPE:Simple#TID:46#TVER:0#SCODE:S0067#VTYPE:V")
		s OperName=##class(EPRservice.BOScatterData).GetEPRData(Adm,"手术名称#TYPE:Simple#TID:46#TVER:0#SCODE:S0066#VTYPE:V")
		s AnaestMethod=##class(EPRservice.BOScatterData).GetEPRData(Adm,"麻醉方式#TYPE:SegmentSimple#TID:46#TVER:0#TCODE:G0031#SCODE:M0032#VTYPE:V")
		s OperContent=##class(EPRservice.BOScatterData).GetEPRData(Adm,"手术步骤#TYPE:TextDesc#TID:46#TVER:0#ECODE:E0022")
	}
	elseif (BindTag=2)
	{
		s OperData=##class(EPRservice.BOScatterData).GetEPRData(Adm,"手术日期#TYPE:Simple#TID:150#TVER:0#SCODE:D0005#VTYPE:C")
		s TimeStart=##class(EPRservice.BOScatterData).GetEPRData(Adm,"开始时间#TYPE:Simple#TID:150#TVER:0#SCODE:D0028#VTYPE:C")
		s TimeClose=##class(EPRservice.BOScatterData).GetEPRData(Adm,"术毕时间#TYPE:Simple#TID:150#TVER:0#SCODE:D0029#VTYPE:C")
		s OperDiag=##class(EPRservice.BOScatterData).GetEPRData(Adm,"术后诊断#TYPE:Simple#TID:150#TVER:0#SCODE:S0067#VTYPE:V")
		s OperName=##class(EPRservice.BOScatterData).GetEPRData(Adm,"手术名称#TYPE:Simple#TID:150#TVER:0#SCODE:S0066#VTYPE:V")
		s AnaestMethod=##class(EPRservice.BOScatterData).GetEPRData(Adm,"麻醉方式#TYPE:SegmentSimple#TID:150#TVER:0#TCODE:G0031#SCODE:M0032#VTYPE:V")
		s OperContent=##class(EPRservice.BOScatterData).GetEPRData(Adm,"手术步骤#TYPE:TextDesc#TID:150#TVER:0#ECODE:E0022")
	}
	elseif (BindTag=3)
	{
		s OperData=##class(EPRservice.BOScatterData).GetEPRData(Adm,"手术日期#TYPE:Simple#TID:151#TVER:0#SCODE:D0005#VTYPE:C")
		s TimeStart=##class(EPRservice.BOScatterData).GetEPRData(Adm,"开始时间#TYPE:Simple#TID:151#TVER:0#SCODE:D0028#VTYPE:C")
		s TimeClose=##class(EPRservice.BOScatterData).GetEPRData(Adm,"术毕时间#TYPE:Simple#TID:151#TVER:0#SCODE:D0029#VTYPE:C")
		s OperDiag=##class(EPRservice.BOScatterData).GetEPRData(Adm,"术后诊断#TYPE:Simple#TID:151#TVER:0#SCODE:S0067#VTYPE:V")
		s OperName=##class(EPRservice.BOScatterData).GetEPRData(Adm,"手术名称#TYPE:Simple#TID:151#TVER:0#SCODE:S0066#VTYPE:V")
		s AnaestMethod=##class(EPRservice.BOScatterData).GetEPRData(Adm,"麻醉方式#TYPE:SegmentSimple#TID:151#TVER:0#TCODE:G0031#SCODE:M0032#VTYPE:V")
		s OperContent=##class(EPRservice.BOScatterData).GetEPRData(Adm,"手术步骤#TYPE:TextDesc#TID:151#TVER:0#ECODE:E0022")
	}
	elseif (BindTag=4)
	{
		s OperData=##class(EPRservice.BOScatterData).GetEPRData(Adm,"手术日期#TYPE:Simple#TID:154#TVER:0#SCODE:D0005#VTYPE:C")
		s TimeStart=##class(EPRservice.BOScatterData).GetEPRData(Adm,"开始时间#TYPE:Simple#TID:154#TVER:0#SCODE:D0028#VTYPE:C")
		s TimeClose=##class(EPRservice.BOScatterData).GetEPRData(Adm,"术毕时间#TYPE:Simple#TID:154#TVER:0#SCODE:D0029#VTYPE:C")
		s OperDiag=##class(EPRservice.BOScatterData).GetEPRData(Adm,"术后诊断#TYPE:Simple#TID:154#TVER:0#SCODE:S0067#VTYPE:V")
		s OperName=##class(EPRservice.BOScatterData).GetEPRData(Adm,"手术名称#TYPE:Simple#TID:154#TVER:0#SCODE:S0066#VTYPE:V")
		s AnaestMethod=##class(EPRservice.BOScatterData).GetEPRData(Adm,"麻醉方式#TYPE:SegmentSimple#TID:154#TVER:0#TCODE:G0031#SCODE:M0032#VTYPE:V")
		s OperContent=##class(EPRservice.BOScatterData).GetEPRData(Adm,"手术步骤#TYPE:TextDesc#TID:154#TVER:0#ECODE:E0022")
	}
	elseif (BindTag=5)
	{
		s OperData=##class(EPRservice.BOScatterData).GetEPRData(Adm,"手术日期#TYPE:Simple#TID:155#TVER:0#SCODE:D0005#VTYPE:C")
		s TimeStart=##class(EPRservice.BOScatterData).GetEPRData(Adm,"开始时间#TYPE:Simple#TID:155#TVER:0#SCODE:D0028#VTYPE:C")
		s TimeClose=##class(EPRservice.BOScatterData).GetEPRData(Adm,"术毕时间#TYPE:Simple#TID:155#TVER:0#SCODE:D0029#VTYPE:C")
		s OperDiag=##class(EPRservice.BOScatterData).GetEPRData(Adm,"术后诊断#TYPE:Simple#TID:155#TVER:0#SCODE:S0067#VTYPE:V")
		s OperName=##class(EPRservice.BOScatterData).GetEPRData(Adm,"手术名称#TYPE:Simple#TID:155#TVER:0#SCODE:S0066#VTYPE:V")
		s AnaestMethod=##class(EPRservice.BOScatterData).GetEPRData(Adm,"麻醉方式#TYPE:SegmentSimple#TID:155#TVER:0#TCODE:G0031#SCODE:M0032#VTYPE:V")
		s OperContent=##class(EPRservice.BOScatterData).GetEPRData(Adm,"手术步骤#TYPE:TextDesc#TID:155#TVER:0#ECODE:E0022")
	}
	elseif (BindTag=6)
	{
		s OperData=##class(EPRservice.BOScatterData).GetEPRData(Adm,"手术日期#TYPE:Simple#TID:156#TVER:0#SCODE:D0005#VTYPE:C")
		s TimeStart=##class(EPRservice.BOScatterData).GetEPRData(Adm,"开始时间#TYPE:Simple#TID:156#TVER:0#SCODE:D0028#VTYPE:C")
		s TimeClose=##class(EPRservice.BOScatterData).GetEPRData(Adm,"术毕时间#TYPE:Simple#TID:156#TVER:0#SCODE:D0029#VTYPE:C")
		s OperDiag=##class(EPRservice.BOScatterData).GetEPRData(Adm,"术后诊断#TYPE:Simple#TID:156#TVER:0#SCODE:S0067#VTYPE:V")
		s OperName=##class(EPRservice.BOScatterData).GetEPRData(Adm,"手术名称#TYPE:Simple#TID:156#TVER:0#SCODE:S0066#VTYPE:V")
		s AnaestMethod=##class(EPRservice.BOScatterData).GetEPRData(Adm,"麻醉方式#TYPE:SegmentSimple#TID:156#TVER:0#TCODE:G0031#SCODE:M0032#VTYPE:V")
		s OperContent=##class(EPRservice.BOScatterData).GetEPRData(Adm,"手术步骤#TYPE:TextDesc#TID:156#TVER:0#ECODE:E0022")
	}
	elseif (BindTag=7)
	{
		s OperData=##class(EPRservice.BOScatterData).GetEPRData(Adm,"手术日期#TYPE:Simple#TID:157#TVER:0#SCODE:D0005#VTYPE:C")
		s TimeStart=##class(EPRservice.BOScatterData).GetEPRData(Adm,"开始时间#TYPE:Simple#TID:157#TVER:0#SCODE:D0028#VTYPE:C")
		s TimeClose=##class(EPRservice.BOScatterData).GetEPRData(Adm,"术毕时间#TYPE:Simple#TID:157#TVER:0#SCODE:D0029#VTYPE:C")
		s OperDiag=##class(EPRservice.BOScatterData).GetEPRData(Adm,"术后诊断#TYPE:Simple#TID:157#TVER:0#SCODE:S0067#VTYPE:V")
		s OperName=##class(EPRservice.BOScatterData).GetEPRData(Adm,"手术名称#TYPE:Simple#TID:157#TVER:0#SCODE:S0066#VTYPE:V")
		s AnaestMethod=##class(EPRservice.BOScatterData).GetEPRData(Adm,"麻醉方式#TYPE:SegmentSimple#TID:157#TVER:0#TCODE:G0031#SCODE:M0032#VTYPE:V")
		s OperContent=##class(EPRservice.BOScatterData).GetEPRData(Adm,"手术步骤#TYPE:TextDesc#TID:157#TVER:0#ECODE:E0022")
	}
	elseif (BindTag=8)
	{
		s OperData=##class(EPRservice.BOScatterData).GetEPRData(Adm,"手术日期#TYPE:Simple#TID:158#TVER:0#SCODE:D0005#VTYPE:C")
		s TimeStart=##class(EPRservice.BOScatterData).GetEPRData(Adm,"开始时间#TYPE:Simple#TID:158#TVER:0#SCODE:D0028#VTYPE:C")
		s TimeClose=##class(EPRservice.BOScatterData).GetEPRData(Adm,"术毕时间#TYPE:Simple#TID:158#TVER:0#SCODE:D0029#VTYPE:C")
		s OperDiag=##class(EPRservice.BOScatterData).GetEPRData(Adm,"术后诊断#TYPE:Simple#TID:158#TVER:0#SCODE:S0067#VTYPE:V")
		s OperName=##class(EPRservice.BOScatterData).GetEPRData(Adm,"手术名称#TYPE:Simple#TID:158#TVER:0#SCODE:S0066#VTYPE:V")
		s AnaestMethod=##class(EPRservice.BOScatterData).GetEPRData(Adm,"麻醉方式#TYPE:SegmentSimple#TID:158#TVER:0#TCODE:G0031#SCODE:M0032#VTYPE:V")
		s OperContent=##class(EPRservice.BOScatterData).GetEPRData(Adm,"手术步骤#TYPE:TextDesc#TID:158#TVER:0#ECODE:E0022")
	}
	elseif (BindTag=9)
	{
		s OperData=##class(EPRservice.BOScatterData).GetEPRData(Adm,"手术日期#TYPE:Simple#TID:159#TVER:0#SCODE:D0005#VTYPE:C")
		s TimeStart=##class(EPRservice.BOScatterData).GetEPRData(Adm,"开始时间#TYPE:Simple#TID:159#TVER:0#SCODE:D0028#VTYPE:C")
		s TimeClose=##class(EPRservice.BOScatterData).GetEPRData(Adm,"术毕时间#TYPE:Simple#TID:159#TVER:0#SCODE:D0029#VTYPE:C")
		s OperDiag=##class(EPRservice.BOScatterData).GetEPRData(Adm,"术后诊断#TYPE:Simple#TID:159#TVER:0#SCODE:S0067#VTYPE:V")
		s OperName=##class(EPRservice.BOScatterData).GetEPRData(Adm,"手术名称#TYPE:Simple#TID:159#TVER:0#SCODE:S0066#VTYPE:V")
		s AnaestMethod=##class(EPRservice.BOScatterData).GetEPRData(Adm,"麻醉方式#TYPE:SegmentSimple#TID:159#TVER:0#TCODE:G0031#SCODE:M0032#VTYPE:V")
		s OperContent=##class(EPRservice.BOScatterData).GetEPRData(Adm,"手术步骤#TYPE:TextDesc#TID:159#TVER:0#ECODE:E0022")
	}	
	*/
	//End========================术后首次病程绑定手术在记录信息================================================
	
	
	
	//Begin======================取辅助检查内容判断是否填写用于打印模板显示条件配置================================================
	s XCG="",CG="",BCG="",SHJC="",XG="",SGBD="",QTBYKT="",XDT="",XXJC="",CSJC="",CTJC="",MRIJC="",QTJC=""
	s IsFZJC="N",IsXCG="N",IsNCG="N",IsBCG="N",IsSHJC="N",IsNXGN="N",IsSGBD="N",IsQTBYKT="N",IsXDT="N",IsXXJC="N",IsCSJC="N",IsCTJC="N",IsMRIJC="N",IsQTJC="N"
	
	s XCG    = ##class(EPRservice.BOScatterData).GetEPRData(Adm,"血常规#TYPE:Segment#TID:200#TVER:0#GCODE:G0099")
	s NCG    = ##class(EPRservice.BOScatterData).GetEPRData(Adm,"尿常规#TYPE:Segment#TID:200#TVER:0#GCODE:G0013")
	s BCG    = ##class(EPRservice.BOScatterData).GetEPRData(Adm,"粪常规#TYPE:Segment#TID:200#TVER:0#GCODE:G0026")
	s SHJC   = ##class(EPRservice.BOScatterData).GetEPRData(Adm,"生化检查#TYPE:Segment#TID:200#TVER:0#GCODE:G0120")
	s NXGN   = ##class(EPRservice.BOScatterData).GetEPRData(Adm,"凝血功能#TYPE:Segment#TID:200#TVER:0#GCODE:G0143")
	s SGBD   = ##class(EPRservice.BOScatterData).GetEPRData(Adm,"嗜肝病毒#TYPE:Segment#TID:200#TVER:0#GCODE:G0154")
	s QTBYKT = ##class(EPRservice.BOScatterData).GetEPRData(Adm,"其它病原抗体#TYPE:Segment#TID:200#TVER:0#GCODE:G0171")
	s XDT    = ##class(EPRservice.BOScatterData).GetEPRData(Adm,"心电图#TYPE:Segment#TID:200#TVER:0#GCODE:G0185")
	s XXJC   = ##class(EPRservice.BOScatterData).GetEPRData(Adm,"X线检查#TYPE:Segment#TID:200#TVER:0#GCODE:G0186")
	s CSJC   = ##class(EPRservice.BOScatterData).GetEPRData(Adm,"超声检查#TYPE:Segment#TID:200#TVER:0#GCODE:G0193")
	s CTJC   = ##class(EPRservice.BOScatterData).GetEPRData(Adm,"CT检查#TYPE:Segment#TID:200#TVER:0#GCODE:G0197")
	s MRIJC  = ##class(EPRservice.BOScatterData).GetEPRData(Adm,"MRI检查#TYPE:Segment#TID:200#TVER:0#GCODE:G0237")
	s QTJC   = ##class(EPRservice.BOScatterData).GetEPRData(Adm,"其它检查#TYPE:Segment#TID:200#TVER:0#GCODE:G0201")
	
	s:($l($tr(XCG," "))'=0) IsXCG = "Y"
	s:($l($tr(NCG," "))'=0) IsNCG = "Y"
	s:($l($tr(BCG," "))'=0) IsBCG = "Y"
	s:($l($tr(SHJC," "))'=0) IsSHJC = "Y"
	s:($l($tr(NXGN," "))'=0) IsNXGN = "Y"
	s:($l($tr(SGBD," "))'=0) IsSGBD = "Y"
	s:($l($tr(QTBYKT," "))'=0) IsQTBYKT = "Y"
	s:($l($tr(XDT," "))'=0) IsXDT = "Y"
	s:($l($tr(XXJC," "))'=0) IsXXJC = "Y"
	s:($l($tr(CSJC," "))'=0) IsCSJC = "Y"
	s:($l($tr(CTJC," "))'=0) IsCTJC = "Y"
	s:($l($tr(MRIJC," "))'=0) IsMRIJC = "Y"
	s:($l($tr(QTJC," "))'=0) IsQTJC = "Y"
	
	s:((IsXCG="Y") || (IsNCG="Y") || (IsBCG="Y") || (IsSHJC="Y") || (IsNXGN="Y") || (IsSGBD="Y") || (IsQTBYKT="Y") || (IsXDT="Y") || (IsXXJC="Y") || (IsCSJC="Y") || (IsCTJC="Y") || (IsMRIJC="Y") || (IsQTJC="Y")) IsFZJC="Y"
	//End========================取辅助检查内容判断是否填写用于打印模板显示条件配置================================================
	
	/*
	//Begin======================南通大学附院第三方病案接口================================================
	
	//确诊天数
	s AdmDateTimeInBed="",AdmDateInBed=""
		
	s AdmDateTimeInBed=##class(EPRservice.HISInterface.PatientInfoAssist).AdmDateTimeInBed(Adm)
	i AdmDateTimeInBed'="" 
	{
		s AdmDateInBed = $P($G(AdmDateTimeInBed),",",1)
	} 
	s AdmDiagDate=##class(EPRservice.BOScatterData).GetEPRData(Adm,"入院后确诊日期^#TYPE:Simple#TID:1#TVER:0#SCODE:D0007#VTYPE:C")
	i AdmDiagDate'=""
	{
		s AdmDiagDate=$zdth(AdmDiagDate,3,1)
	}
	i (AdmDateInBed'="")&&(AdmDiagDate'="")
	{
		s AdmDiagDays=AdmDiagDate-AdmDateInBed
	}
	
	//出院诊断疑诊标志
	s DisDiagDoubtType=##class(EPRservice.BOScatterData).GetEPRData(Adm,"怀疑诊断类型1^#TYPE:Simple#TID:2#TVER:0#SCODE:O0095#VTYPE:C")
	if DisDiagDoubtType'=""
	{
		s IsDisDiagDoubtFlag="1"
	}
	else
	{
		s IsDisDiagDoubtFlag="2"
	}
	
	//肿瘤编码
	i (DiagDR1'="")
	{
		 s PhymaCode= $p($g(^MRC("ID",DiagDR1)),"^",43)
	}
	
	//病理检查标志 (病理检查号不为无,则标志为1否则标志为2)
	s PathologyCode =##class(EPRservice.BOScatterData).GetEPRData(Adm, "病理检查号^#TYPE:Simple#TID:2#TVER:0#SCODE:S0129#VTYPE:V")
	if (PathologyCode'="无")&&(PathologyCode'="")&&(PathologyCode'="-")
	{
		s IsPathologyCheckFlag="1"
	}
	else
	{
		s IsPathologyCheckFlag="2"
	}
	
	//医院感染标志
	s HosInfectionDesc =##class(EPRservice.BOScatterData).GetEPRData(Adm, "医院感染名称^#TYPE:Simple#TID:2#TVER:0#SCODE:S0079#VTYPE:V")
	if (HosInfectionDesc'="无")&&(HosInfectionDesc'="")&&(HosInfectionDesc'="-")
	{
		s IsHosInfectionFlag="1"
	}
	else
	{
		s IsHosInfectionFlag="2"
	}
	
	//手术标志 (通过术前术后判断)
	s OperBeforeAfter =##class(EPRservice.BOScatterData).GetEPRData(Adm, "术前与术后^#TYPE:Simple#TID:2#TVER:0#SCODE:O0051#VTYPE:C")
	if (OperBeforeAfter'="0")&&(HosInfectionDesc'="")
	{
		s IsOperFlag="1"
	}
	else
	{
		s IsOperFlag="2"
	}
	
	
	//药物过敏标志 (通过术前术后判断)
	s MedAllergyDesc =##class(EPRservice.BOScatterData).GetEPRData(Adm, "药物过敏^#TYPE:Simple#TID:2#TVER:0#SCODE:S0091#VTYPE:V")
	if (MedAllergyDesc'="")&&(MedAllergyDesc'["未发现")&&(MedAllergyDesc'["不详")&&(MedAllergyDesc'["未知")&&(MedAllergyDesc'["未提供")&&(MedAllergyDesc'["无")&&(MedAllergyDesc'="-")
	{
		s IsMedAllergyFlag="1"
	}
	else
	{
		s IsMedAllergyFlag="2"
	}
	
	//术前诊断
	s OperBeforeDiagDR1 =##class(EPRservice.BOScatterData).GetEPRData(Adm, "术前诊断^#TYPE:Simple#TID:5#TVER:0#SCODE:I0050#VTYPE:C")
	i (OperBeforeDiagDR1'="")&&(OperBeforeDiagDR1'="无")&&(OperBeforeDiagDR1'="-") 
	{
		s OperBeforeDiag1= $p($g(^MRC("ID",OperBeforeDiagDR1)),"^",4)
	}

	//术后诊断
	s OperAfterDiagDR1 =##class(EPRservice.BOScatterData).GetEPRData(Adm, "术后诊断^#TYPE:Simple#TID:5#TVER:0#SCODE:I0051#VTYPE:C")
	i (OperAfterDiagDR1'="")&&(OperAfterDiagDR1'="无")&&(OperAfterDiagDR1'="-")
	{
		s OperAfterDiag1= $p($g(^MRC("ID",OperAfterDiagDR1)),"^",4)
	}
	
	//End========================南通大学附院第三方病案接口================================================
	*/



	//Begin======================南通大学附院模板绑定个性接口================================================
	
	// (用以计算年龄)入院日期时间	[AdmDateTime]		PAAdm_AdmDate And PAAdm_AdmTime 
		 	s tmpCusAdmDate = "", tmpCusAdmTime = ""
		 	s tmpCusAdmDateTime=##class(EPRservice.HISInterface.PatientInfoAssist).AdmDateTime(Adm,Hospital)
		 	if tmpCusAdmDateTime'="" 
		 	{ 
		   		// 入院日期内部格式
		   		s tmpCusAdmDate = $P($G(AdmDateTime),",",1)
		   		// 入院时间内部格式 
		   		s tmpCusAdmTime = $P($G(AdmDateTime),",",2)
		 	}
		 	
	//抢救次数 抢救次数取自病程中抢救记录次数
	//s RescueCount = ##Class(EPRservice.Quality.CheckRule.Course).GetMultiTemReCount(Adm,"307|抢救记录",tmpCusAdmDate,tmpCusAdmTime,$p($h,",",1),$p($h,",",2))
	//s RescueCount = $p(RescueCount,"^",2)
	s RescueCount = ""
	//End========================南通大学附院模板绑定个性接口================================================




	//Begin======================湖南肿瘤医院模板绑定个性接口================================================
	
	s IsFemaleAndFirstTime="N",IsFirstTime="N"
	
	s SexDR=##Class(EPRservice.HISInterface.PatientInfoAssist).Gender(PapmiDR,"")
	s PatTpyeDR=##Class(EPRservice.Privilege.BOPrivAssist).GetPatTpyeID(Adm)
	s:(+SexDR=1)&&(PatTpyeDR=80) IsFemaleAndFirstTime ="Y"
	s:(PatTpyeDR=80) IsFirstTime ="Y"
	
	
	



	//End========================湖南肿瘤医院模板绑定个性接口================================================
	
	
	
	//Begin======================北京协和医院模板绑定个性接口================================================

	//急诊病人评分
	s (EPGLASGOW,EPAPACHE)=""
	
	s EPGLASGOW = ##class(EPRservice.HISInterface.PatientInfoAssist).GetPatScoreByAdmAndScoreType(Adm,"GLASG")
	s:(EPGLASGOW'="") EPGLASGOW = $p(EPGLASGOW,"^")
	
	s EPAPACHE = ##class(EPRservice.HISInterface.PatientInfoAssist).GetPatScoreByAdmAndScoreType(Adm,"APACHE")
	s:(EPAPACHE'="") EPAPACHE = $p(EPAPACHE,"^")
	
	//End========================北京协和医院模板绑定个性接口================================================
	
	
	
	set ^CacheTemp(repid, ind) = $LB(EpisodeID,PapmiDR,EpisodeNo,RegisterNo,Name,RescueCount,TraOutDiag,TraAdmDiag1,TraDiag1,TraDiag2,TraDiag3,TraDiag4,TraDiag5,TraDiag6,TraDiag7,TraDiag8,TraDiag9,TraDiag10,TraDiag11,TraDiag12,TraDiag13,TraDiag14,TraDiag15,TraDiag16,TraOper1,TraOper2,TraOper3,TraOper4,TraOper5,TraOper6,TraOper7,TraOper8,TraOper9,TraOper10,OperData,TimeStart,TimeClose,OperDiag,OperName,AnaestMethod,OperContent,IsFZJC,IsXCG,IsNCG,IsBCG,IsSHJC,IsNXGN,IsSGBD,IsQTBYKT,IsXDT,IsXXJC,IsCSJC,IsCTJC,IsMRIJC,IsQTJC,IsFemaleAndFirstTime,IsFirstTime,EPGLASGOW,EPAPACHE)
	set ind = ind + 1
	
	Quit $$$OK
}

ClassMethod GetCustomInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetCustomInfoExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetCustomInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetCustomInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
	Quit $$$OK
}

/// ////////////////////////////////////////////////////////////////////////////////////////////////
/// Creator：	EPR
/// CreateDate：2009-03-16
/// Desc：		病案号自动生成
/// Input:		Adm: 就诊rowid
/// Return：	目前限于安徽省立医院使用
/// Test:		##Class(EPRservice.SystemData).testcare(Adm)	
Query GetCaseRecordNoInfo(argAdmId As %String) As %Query(ROWSPEC = "BADisDeptFromHIS:%String,DisYearFromHIS:%String,BADisDept:%String,DisYear:%String,DiagICDCode:%String,DiseaseNo:%String")
{
}

ClassMethod GetCaseRecordNoInfoExecute(ByRef qHandle As %Binary, argAdmId As %String) As %Status
{
	s qHandle=""

	q:($d(argAdmId)=0)||(argAdmId="") $$$OK
	
	s Hospital="HeFei"
 	s className = "EPRservice.HISInterface.PatientInfoAssist"

 	//initialize all return fields
 	s BADisDeptFromHIS="",DisYearFromHIS=""
 	s BADisDept="", DisYear="", DiagICDCode="", DiseaseNo=""

 	//get fields from HIS
 	s BADisDeptFromHIS = $ZOBJCLASSMETHOD(className,"DisDeptForBingAn",argAdmId,Hospital)
	s BADisDeptFromHIS = $P(BADisDeptFromHIS,"^",2)
	s disDate = $ZOBJCLASSMETHOD(className,"DisDate",argAdmId)
	if disDate'="" {s DisYearFromHIS= $P($ZD(disDate,3),"-",1)}
	    
 	//get fields saved by 病案室一
 	s caseRecordNo = $ZOBJCLASSMETHOD(className, "CaseRecordNoInfo", argAdmId, Hospital)
 	//w !!,caseRecordNo
 	s BADisDept = $P(caseRecordNo,"^",1)
 	s DisYear = $P(caseRecordNo,"^",2)
 	s DiagICDCode = $P(caseRecordNo,"^",3)
 	s DiseaseNo = $P(caseRecordNo,"^",4)

 	s myQueryResult = $LB(BADisDeptFromHIS,DisYearFromHIS,BADisDept, DisYear, DiagICDCode, DiseaseNo)   		
 	s qHandle = myQueryResult
	
	Quit $$$OK
}

ClassMethod GetCaseRecordNoInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetCaseRecordNoInfoExecute ]
{
	if qHandle'=""
	{
		s Row=qHandle
		s qHandle=""
	}
	else
	{
		s Row = ""
		s AtEnd=1
	}
	
	Quit $$$OK
}

ClassMethod GetCaseRecordNoInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetCaseRecordNoInfoExecute ]
{
	//Query "GetCaseRecordNoInfo" is used to get information about Case Record No.
	//
	//
	s qHandle=""
	Quit $$$OK
}

/// ////////////////////////////////////////////////////////////////////////////////////////////////
/// Creator：	EPR
/// CreateDate：2009-03-16
/// Desc：		病案首页(诊断、手术操作) 编目数据接口
/// Input:		Adm: 就诊rowid
/// Return：	[WMR]And[EPR] 医政管理与电子病历接口
/// Test:		##Class(EPRservice.SystemData).testcus(Adm)	
Query GetWMRInterface(Adm As %String) As %Query(ROWSPEC = "NULL:%String,AdmID:%String,PapmiDR:%String,Opdiagcode:%String,Opdiagdesc:%String,Ipdiagcode:%String,Ipdiagdesc:%String,icdcode1:%String,icddesc1:%String,CureResult1:%String,icdcode2:%String,icddesc2:%String,CureResult2:%String,icdcode3:%String,icddesc3:%String,CureResult3:%String,icdcode4:%String,icddesc4:%String,CureResult4:%String,icdcode5:%String,icddesc5:%String,CureResult5:%String,icdcode6:%String,icddesc6:%String,CureResult6:%String,icdcode7:%String,icddesc7:%String,CureResult7:%String,icdcode8:%String,icddesc8:%String,CureResult8:%String,icdcode9:%String,icddesc9:%String,CureResult9:%String,icdcode10:%String,icddesc10:%String,CureResult10:%String,icdcode11:%String,icddesc11:%String,CureResult11:%String,icdcode12:%String,icddesc12:%String,icdcode13:%String,icddesc13:%String,icdcode14:%String,icddesc14:%String,CureResult14:%String,opercode1:%String,operdesc1:%String,operdate1:%String,operdoc1:%String,operassifir1:%String,operassistsec1:%String,cutcode1:%String,ciccode1:%String,AnaestMethod1:%String,Anaestdoc1:%String,opercode2:%String,operdesc2:%String,operdate2:%String,operdoc2:%String,operassifir2:%String,operassistsec2:%String,cutcode2:%String,ciccode2:%String,AnaestMethod2:%String,Anaestdoc2:%String,opercode3:%String,operdesc3:%String,operdate3:%String,operdoc3:%String,operassifir3:%String,operassistsec3:%String,cutcode3:%String,ciccode3:%String,AnaestMethod3:%String,Anaestdoc3:%String,opercode4:%String,operdesc4:%String,operdate4:%String,operdoc4:%String,operassifir4:%String,operassistsec4:%String,cutcode4:%String,ciccode4:%String,AnaestMethod4:%String,Anaestdoc4:%String,opercode5:%String,operdesc5:%String,operdate5:%String,operdoc5:%String,operassifir5:%String,operassistsec5:%String,cutcode5:%String,ciccode5:%String,AnaestMethod5:%String,Anaestdoc5:%String,opercode6:%String,operdesc6:%String,operdate6:%String,operdoc6:%String,operassifir6:%String,operassistsec6:%String,AnaestMethod6:%String,Anaestdoc6:%String,opercode7:%String,operdesc7:%String,operdate7:%String,operdoc7:%String,operassifir7:%String,operassistsec7:%String,AnaestMethod7:%String,Anaestdoc7:%String,opercode8:%String,operdesc8:%String,operdate8:%String,operdoc8:%String,operassifir8:%String,operassistsec8:%String,AnaestMethod8:%String,Anaestdoc8:%String,opercode9:%String,operdesc9:%String,operdate9:%String,operdoc9:%String,operassifir9:%String,operassistsec9:%String,AnaestMethod9:%String,Anaestdoc9:%String,opercode10:%String,operdesc10:%String,operdate10:%String,operdoc10:%String,operassifir10:%String,operassistsec10:%String,AnaestMethod10:%String,Anaestdoc10:%String")
{
}

ClassMethod GetWMRInterfaceExecute(ByRef qHandle As %Binary, Adm As %String) As %Status
{
 s qHandle=""

 Quit:($d(^PAADM(Adm))=0)||(Adm="") $$$OK
 
 s SQLCODE=0
 
 //EPR> 系统标识号
 s PapmiDR="",PapmiDR=""
 s AdmDateTime="",AdmDate=""

 //EPR> PA_Adm.PAAdm_PAPMI_DR
 s PapmiDR = $P($g(^PAAdm(Adm)),"^",1)
 
 //EPR> PA_Person.PAPER_RowId And PA_PatMas.PAPMI_PAPER_DR
 s PapmiDR = ##Class(EPRservice.HISInterface.PatientInfoAssist).GetPapmiDR(PapmiDR)


 //EPR> 入院日期时间 PAAdm_AdmDate And PAAdm_AdmTime
 s AdmDateTime=##class(EPRservice.HISInterface.PatientInfoAssist).AdmDateTime(Adm)
 i AdmDateTime'="" 
 { 
   //EPR> 入院日期
   s AdmDate = $ZD($P($G(AdmDateTime),",",1),3)
 }



 //EPR> 与医政管理组病案首页内部接口大类
 
 //w ##Class(web.DHCWMRCodingInterface).getFrontPageICD(PaAdm,GetType,Index)
 //导出病案编目数据：getFrontPageICD
 //入参：
 //  1-PaAdm               就诊号
 //  2-GetType             类型
 //        D/1:            主要诊断
 //        D/2:            次要诊断
 //        D/3:            医院感染诊断
 //        D/4:            病理诊断
 //        D/5:            损伤、中毒的外部因素
 //        D/6:            门急诊诊断
 //        D/7:            入院诊断
 //        O/1:            手术
 //        O/2:            操作
 //  3-Index               第几条记录
 
 //EPR> 门诊入院诊断
 
 s Opdiagstr="",Ipdiagstr=""
 s Opdiagcode="",Opdiagdesc=""
 s Ipdiagcode="",Ipdiagdesc=""
 
 s Opdiagstr=##Class(web.DHCWMRCodingInterface).getFrontPageICD(Adm,"D/6",1)
 i Opdiagstr'=""
 {
	  s Opdiagcode		=$p($g(Opdiagstr),$c(2),1)
	  s Opdiagdesc		=$p($g(Opdiagstr),$c(2),2)
	 }
	 
 s Ipdiagstr=##Class(web.DHCWMRCodingInterface).getFrontPageICD(Adm,"D/7",1)
 i Ipdiagstr'=""
 {
	  s Ipdiagcode		=$p($g(Ipdiagstr),$c(2),1)
	  s Ipdiagdesc		=$p($g(Ipdiagstr),$c(2),2)
	 }

 
 //EPR> 出院诊断
 
 s diagstr1="",diagstr2="",diagstr3="",diagstr4="",diagstr5="",diagstr6="",diagstr7="",diagstr8="",diagstr9="",diagstr10="",diagstr11=""
 s icdcode1="",icddesc1="",CureResult1=""
 s icdcode2="",icddesc2="",CureResult2=""
 s icdcode3="",icddesc3="",CureResult3=""
 s icdcode4="",icddesc4="",CureResult4=""
 s icdcode5="",icddesc5="",CureResult5=""
 s icdcode6="",icddesc6="",CureResult6=""
 s icdcode7="",icddesc7="",CureResult7=""
 s icdcode8="",icddesc8="",CureResult8=""
 s icdcode9="",icddesc9="",CureResult9=""
 s icdcode10="",icddesc10="",CureResult10=""
 s icdcode11="",icddesc11="",CureResult11=""
 

 s diagstr1=##Class(web.DHCWMRCodingInterface).getFrontPageICD(Adm,"D/1",1)
 i diagstr1'=""
 {
	  s icdcode1		=$p($g(diagstr1),$c(2),1)
	  s icddesc1		=$p($g(diagstr1),$c(2),2)
	  s CureResult1		=$p($g(diagstr1),$c(2),3)
	 }

 s diagstr2=##Class(web.DHCWMRCodingInterface).getFrontPageICD(Adm,"D/2",1)
 i diagstr2'=""
 {
	  s icdcode2		=$p($g(diagstr2),$c(2),1)
	  s icddesc2		=$p($g(diagstr2),$c(2),2)
	  s CureResult2		=$p($g(diagstr2),$c(2),3)
	 }
	 
 s diagstr3=##Class(web.DHCWMRCodingInterface).getFrontPageICD(Adm,"D/2",2)
 i diagstr3'=""
 {
	  s icdcode3		=$p($g(diagstr3),$c(2),1)
	  s icddesc3		=$p($g(diagstr3),$c(2),2)
	  s CureResult3		=$p($g(diagstr3),$c(2),3)
	 }

 s diagstr4=##Class(web.DHCWMRCodingInterface).getFrontPageICD(Adm,"D/2",3)
 i diagstr4'=""
 {
	  s icdcode4		=$p($g(diagstr4),$c(2),1)
	  s icddesc4		=$p($g(diagstr4),$c(2),2)
	  s CureResult4		=$p($g(diagstr4),$c(2),3)
	 }

 s diagstr5=##Class(web.DHCWMRCodingInterface).getFrontPageICD(Adm,"D/2",4)
 i diagstr5'=""
 {
	  s icdcode5		=$p($g(diagstr5),$c(2),1)
	  s icddesc5		=$p($g(diagstr5),$c(2),2)
	  s CureResult5		=$p($g(diagstr5),$c(2),3)
	 }

 s diagstr6=##Class(web.DHCWMRCodingInterface).getFrontPageICD(Adm,"D/2",5)
 i diagstr6'=""
 {
	  s icdcode6		=$p($g(diagstr6),$c(2),1)
	  s icddesc6		=$p($g(diagstr6),$c(2),2)
	  s CureResult6		=$p($g(diagstr6),$c(2),3)
	 }

 s diagstr7=##Class(web.DHCWMRCodingInterface).getFrontPageICD(Adm,"D/2",6)
 i diagstr7'=""
 {
	  s icdcode7		=$p($g(diagstr7),$c(2),1)
	  s icddesc7		=$p($g(diagstr7),$c(2),2)
	  s CureResult7		=$p($g(diagstr7),$c(2),3)
	 }

 s diagstr8=##Class(web.DHCWMRCodingInterface).getFrontPageICD(Adm,"D/2",7)
 i diagstr8'=""
 {
	  s icdcode8		=$p($g(diagstr8),$c(2),1)
	  s icddesc8		=$p($g(diagstr8),$c(2),2)
	  s CureResult8		=$p($g(diagstr8),$c(2),3)
	 }

 s diagstr9=##Class(web.DHCWMRCodingInterface).getFrontPageICD(Adm,"D/2",8)
 i diagstr9'=""
 {
	  s icdcode9		=$p($g(diagstr9),$c(2),1)
	  s icddesc9		=$p($g(diagstr9),$c(2),2)
	  s CureResult9		=$p($g(diagstr9),$c(2),3)
	 }

 s diagstr10=##Class(web.DHCWMRCodingInterface).getFrontPageICD(Adm,"D/2",9)
 i diagstr10'=""
 {
	  s icdcode10		=$p($g(diagstr10),$c(2),1)
	  s icddesc10		=$p($g(diagstr10),$c(2),2)
	  s CureResult10	=$p($g(diagstr10),$c(2),3)
	 }

 s diagstr11=##Class(web.DHCWMRCodingInterface).getFrontPageICD(Adm,"D/2",10)
 i diagstr11'=""
 {
	  s icdcode11		=$p($g(diagstr11),$c(2),1)
	  s icddesc11		=$p($g(diagstr11),$c(2),2)
	  s CureResult11	=$p($g(diagstr11),$c(2),3)
	 }


 //EPR> 病理诊断

  s diagstr12=""
  s icdcode12="",icddesc12=""
  
 s diagstr12=##Class(web.DHCWMRCodingInterface).getFrontPageICD(Adm,"D/3",1)
 i diagstr12'=""
 {
	  s icdcode12		=$p($g(diagstr12),$c(2),1)
	  s icddesc12		=$p($g(diagstr12),$c(2),2)
	 }
  
 
 //EPR> 损伤、中毒的外部因素诊断
 
 
  s diagstr13=""
  s icdcode13="",icddesc13=""
  
 s diagstr13=##Class(web.DHCWMRCodingInterface).getFrontPageICD(Adm,"D/5",1)
 i diagstr13'=""
 {
	  s icdcode13		=$p($g(diagstr13),$c(2),1)
	  s icddesc13		=$p($g(diagstr13),$c(2),2)
	 }
 
 
 //EPR> 医院感染诊断
 
 s diagstr14=""
 s icdcode14="",icddesc14="",CureResult14=""
 
 s diagstr14=##Class(web.DHCWMRCodingInterface).getFrontPageICD(Adm,"D/4",1)
 i diagstr14'=""
 {
	  s icdcode14		=$p($g(diagstr14),$c(2),1)
	  s icddesc14		=$p($g(diagstr14),$c(2),2)
	  s CureResult14	=$p($g(diagstr14),$c(2),3)
	 }
 
 
 
 //EPR> 手术情况
 
 s operstr1="",operstr2="",operstr3="",operstr4="",operstr5=""
 s opercode1="",operdesc1="",operdate1="",operdoc1="",operassifir1="",operassistsec1="",cutcode1="",ciccode1="",AnaestMethod1="",Anaestdoc1=""
 s opercode2="",operdesc2="",operdate2="",operdoc2="",operassifir2="",operassistsec2="",cutcode2="",ciccode2="",AnaestMethod2="",Anaestdoc2=""
 s opercode3="",operdesc3="",operdate3="",operdoc3="",operassifir3="",operassistsec3="",cutcode3="",ciccode3="",AnaestMethod3="",Anaestdoc3=""
 s opercode4="",operdesc4="",operdate4="",operdoc4="",operassifir4="",operassistsec4="",cutcode4="",ciccode4="",AnaestMethod4="",Anaestdoc4=""
 s opercode5="",operdesc5="",operdate5="",operdoc5="",operassifir5="",operassistsec5="",cutcode5="",ciccode5="",AnaestMethod5="",Anaestdoc5=""
 
 
 s operstr1=##Class(web.DHCWMRCodingInterface).getFrontPageICD(Adm,"O/1",1)
 i operstr1'=""
 {
	  s opercode1		=$p($g(operstr1),$c(2),1)
	  s operdesc1		=$p($g(operstr1),$c(2),2)
	  s operdate1		=$p($g(operstr1),$c(2),3)
	  s operdoc1		=$p($g(operstr1),$c(2),4)
	  s operassifir1	=$p($g(operstr1),$c(2),5)
	  s operassistsec1	=$p($g(operstr1),$c(2),6)
	  s AnaestMethod1	=$p($g(operstr1),$c(2),7)
	  s cutcode1		=$p($p($g(operstr1),$c(2),8),"/",1)
	  s ciccode1		=$p($p($g(operstr1),$c(2),8),"/",2)
	  s Anaestdoc1		=$p($g(operstr1),$c(2),9)
	 }

 s operstr2=##Class(web.DHCWMRCodingInterface).getFrontPageICD(Adm,"O/1",2)
 i operstr2'=""
 {
	  s opercode2		=$p($g(operstr2),$c(2),1)
	  s operdesc2		=$p($g(operstr2),$c(2),2)
	  s operdate2		=$p($g(operstr2),$c(2),3)
	  s operdoc2		=$p($g(operstr2),$c(2),4)
	  s operassifir2	=$p($g(operstr2),$c(2),5)
	  s operassistsec2	=$p($g(operstr2),$c(2),6)
	  s AnaestMethod2	=$p($g(operstr2),$c(2),7)
	  s cutcode2		=$p($p($g(operstr2),$c(2),8),"/",1)
	  s ciccode2		=$p($p($g(operstr2),$c(2),8),"/",2)
	  s Anaestdoc2		=$p($g(operstr2),$c(2),9)
	 }

 s operstr3=##Class(web.DHCWMRCodingInterface).getFrontPageICD(Adm,"O/1",3)
 i operstr3'=""
 {
	  s opercode3		=$p($g(operstr3),$c(2),1)
	  s operdesc3		=$p($g(operstr3),$c(2),2)
	  s operdate3		=$p($g(operstr3),$c(2),3)
	  s operdoc3		=$p($g(operstr3),$c(2),4)
	  s operassifir3	=$p($g(operstr3),$c(2),5)
	  s operassistsec3	=$p($g(operstr3),$c(2),6)
	  s AnaestMethod3	=$p($g(operstr3),$c(2),7)
	  s cutcode3		=$p($p($g(operstr3),$c(2),8),"/",1)
	  s ciccode3		=$p($p($g(operstr3),$c(2),8),"/",2)
	  s Anaestdoc3		=$p($g(operstr3),$c(2),9)
	 }

 s operstr4=##Class(web.DHCWMRCodingInterface).getFrontPageICD(Adm,"O/1",4)
 i operstr4'=""
 {
	  s opercode4		=$p($g(operstr4),$c(2),1)
	  s operdesc4		=$p($g(operstr4),$c(2),2)
	  s operdate4		=$p($g(operstr4),$c(2),3)
	  s operdoc4		=$p($g(operstr4),$c(2),4)
	  s operassifir4	=$p($g(operstr4),$c(2),5)
	  s operassistsec4	=$p($g(operstr4),$c(2),6)
	  s AnaestMethod4	=$p($g(operstr4),$c(2),7)
	  s cutcode4		=$p($p($g(operstr4),$c(2),8),"/",1)
	  s ciccode4		=$p($p($g(operstr4),$c(2),8),"/",2)
	  s Anaestdoc4		=$p($g(operstr4),$c(2),9)
	 }

 s operstr5=##Class(web.DHCWMRCodingInterface).getFrontPageICD(Adm,"O/1",5)
 i operstr5'=""
 {
	  s opercode5		=$p($g(operstr5),$c(2),1)
	  s operdesc5		=$p($g(operstr5),$c(2),2)
	  s operdate5		=$p($g(operstr5),$c(2),3)
	  s operdoc5		=$p($g(operstr5),$c(2),4)
	  s operassifir5	=$p($g(operstr5),$c(2),5)
	  s operassistsec5	=$p($g(operstr5),$c(2),6)
	  s AnaestMethod5	=$p($g(operstr5),$c(2),7)
	  s cutcode5		=$p($p($g(operstr5),$c(2),8),"/",1)
	  s ciccode5		=$p($p($g(operstr5),$c(2),8),"/",2)
	  s Anaestdoc5		=$p($g(operstr5),$c(2),9)
	 }



 
 //EPR> 操作情况
 
 s operstr6="",operstr7="",operstr8="",operstr9="",operstr10=""
 s opercode6="",operdesc6="",operdate6="",operdoc6="",operassifir6="",operassistsec6="",cutcode6="",ciccode6="",AnaestMethod6="",Anaestdoc6=""
 s opercode7="",operdesc7="",operdate7="",operdoc7="",operassifir7="",operassistsec7="",cutcode7="",ciccode7="",AnaestMethod7="",Anaestdoc7=""
 s opercode8="",operdesc8="",operdate8="",operdoc8="",operassifir8="",operassistsec8="",cutcode8="",ciccode8="",AnaestMethod8="",Anaestdoc8=""
 s opercode9="",operdesc9="",operdate9="",operdoc9="",operassifir9="",operassistsec9="",cutcode9="",ciccode9="",AnaestMethod9="",Anaestdoc9=""
 s opercode10="",operdesc10="",operdate10="",operdoc10="",operassifir10="",operassistsec10="",cutcode10="",ciccode10="",AnaestMethod10="",Anaestdoc10=""
 
  s operstr6=##Class(web.DHCWMRCodingInterface).getFrontPageICD(Adm,"O/2",1)
 i operstr6'=""
 {
	  s opercode6		=$p($g(operstr6),$c(2),1)
	  s operdesc6		=$p($g(operstr6),$c(2),2)
	  s operdate6		=$p($g(operstr6),$c(2),3)
	  s operdoc6		=$p($g(operstr6),$c(2),4)
	  s operassifir6	=$p($g(operstr6),$c(2),5)
	  s operassistsec6	=$p($g(operstr6),$c(2),6)
	  s AnaestMethod6	=$p($g(operstr6),$c(2),7)
	  ;s cutcode6		=$p($p($g(operstr6),$c(2),8),"/",1)
	  ;s ciccode6		=$p($p($g(operstr6),$c(2),8),"/",2)
	  s Anaestdoc6		=$p($g(operstr6),$c(2),9)
	 }

 s operstr7=##Class(web.DHCWMRCodingInterface).getFrontPageICD(Adm,"O/2",2)
 i operstr7'=""
 {
	  s opercode7		=$p($g(operstr7),$c(2),1)
	  s operdesc7		=$p($g(operstr7),$c(2),2)
	  s operdate7		=$p($g(operstr7),$c(2),3)
	  s operdoc7		=$p($g(operstr7),$c(2),4)
	  s operassifir7	=$p($g(operstr7),$c(2),5)
	  s operassistsec7	=$p($g(operstr7),$c(2),6)
	  s AnaestMethod7	=$p($g(operstr7),$c(2),7)
	  ;s cutcode7		=$p($p($g(operstr7),$c(2),8),"/",1)
	  ;s ciccode7		=$p($p($g(operstr7),$c(2),8),"/",2)
	  s Anaestdoc7		=$p($g(operstr7),$c(2),9)
	 }

 s operstr8=##Class(web.DHCWMRCodingInterface).getFrontPageICD(Adm,"O/2",3)
 i operstr8'=""
 {
	  s opercode8		=$p($g(operstr8),$c(2),1)
	  s operdesc8		=$p($g(operstr8),$c(2),2)
	  s operdate8		=$p($g(operstr8),$c(2),3)
	  s operdoc8		=$p($g(operstr8),$c(2),4)
	  s operassifir8	=$p($g(operstr8),$c(2),5)
	  s operassistsec8	=$p($g(operstr8),$c(2),6)
	  s AnaestMethod8	=$p($g(operstr8),$c(2),7)
	  ;s cutcode8		=$p($p($g(operstr8),$c(2),8),"/",1)
	  ;s ciccode8		=$p($p($g(operstr8),$c(2),8),"/",2)
	  s Anaestdoc8		=$p($g(operstr8),$c(2),9)
	 }

 s operstr9=##Class(web.DHCWMRCodingInterface).getFrontPageICD(Adm,"O/2",4)
 i operstr9'=""
 {
	  s opercode9		=$p($g(operstr9),$c(2),1)
	  s operdesc9		=$p($g(operstr9),$c(2),2)
	  s operdate9		=$p($g(operstr9),$c(2),3)
	  s operdoc9		=$p($g(operstr9),$c(2),4)
	  s operassifir9	=$p($g(operstr9),$c(2),5)
	  s operassistsec9	=$p($g(operstr9),$c(2),6)
	  s AnaestMethod9	=$p($g(operstr9),$c(2),7)
	  ;s cutcode9		=$p($p($g(operstr9),$c(2),8),"/",1)
	  ;s ciccode9		=$p($p($g(operstr9),$c(2),8),"/",2)
	  s Anaestdoc9		=$p($g(operstr9),$c(2),9)
	 }

 s operstr10=##Class(web.DHCWMRCodingInterface).getFrontPageICD(Adm,"O/2",5)
 i operstr10'=""
 {
	  s opercode10		=$p($g(operstr10),$c(2),1)
	  s operdesc10		=$p($g(operstr10),$c(2),2)
	  s operdate10		=$p($g(operstr10),$c(2),3)
	  s operdoc10		=$p($g(operstr10),$c(2),4)
	  s operassifir10	=$p($g(operstr10),$c(2),5)
	  s operassistsec10	=$p($g(operstr10),$c(2),6)
	  s AnaestMethod10	=$p($g(operstr10),$c(2),7)
	  ;s cutcode10		=$p($p($g(operstr10),$c(2),8),"/",1)
	  ;s ciccode10		=$p($p($g(operstr10),$c(2),8),"/",2)
	  s Anaestdoc10		=$p($g(operstr10),$c(2),9)
	 }

 
 set MQueryPat=$LB("",Adm,PapmiDR,Opdiagcode,Opdiagdesc,Ipdiagcode,Ipdiagdesc,icdcode1,icddesc1,CureResult1,icdcode2,icddesc2,CureResult2,icdcode3,icddesc3,CureResult3,icdcode4,icddesc4,CureResult4,icdcode5,icddesc5,CureResult5,icdcode6,icddesc6,CureResult6,icdcode7,icddesc7,CureResult7,icdcode8,icddesc8,CureResult8,icdcode9,icddesc9,CureResult9,icdcode10,icddesc10,CureResult10,icdcode11,icddesc11,CureResult11,icdcode12,icddesc12,icdcode13,icddesc13,icdcode14,icddesc14,CureResult14,opercode1,operdesc1,operdate1,operdoc1,operassifir1,operassistsec1,cutcode1,ciccode1,AnaestMethod1,Anaestdoc1,opercode2,operdesc2,operdate2,operdoc2,operassifir2,operassistsec2,cutcode2,ciccode2,AnaestMethod2,Anaestdoc2,opercode3,operdesc3,operdate3,operdoc3,operassifir3,operassistsec3,cutcode3,ciccode3,AnaestMethod3,Anaestdoc3,opercode4,operdesc4,operdate4,operdoc4,operassifir4,operassistsec4,cutcode4,ciccode4,AnaestMethod4,Anaestdoc4,opercode5,operdesc5,operdate5,operdoc5,operassifir5,operassistsec5,cutcode5,ciccode5,AnaestMethod5,Anaestdoc5,opercode6,operdesc6,operdate6,operdoc6,operassifir6,operassistsec6,AnaestMethod6,Anaestdoc6,opercode7,operdesc7,operdate7,operdoc7,operassifir7,operassistsec7,AnaestMethod7,Anaestdoc7,opercode8,operdesc8,operdate8,operdoc8,operassifir8,operassistsec8,AnaestMethod8,Anaestdoc8,opercode9,operdesc9,operdate9,operdoc9,operassifir9,operassistsec9,AnaestMethod9,Anaestdoc9,opercode10,operdesc10,operdate10,operdoc10,operassifir10,operassistsec10,AnaestMethod10,Anaestdoc10)
 
 s qHandle=MQueryPat
 Quit $$$OK
}

ClassMethod GetWMRInterfaceFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetWMRInterfaceExecute ]
{
	if qHandle'=""
	{
		s Row=qHandle
		s qHandle=""
	}
	else
	{
		s Row = ""
		s AtEnd=1
	}
	Quit $$$OK
}

ClassMethod GetWMRInterfaceClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetWMRInterfaceExecute ]
{
 s qHandle="" 
	Quit $$$OK
}

/// ================== Query GetIPBookInfo ==================================================
/// CreateUser:	HouJian
/// CreateTime：2009-01-09
/// Desc：		取医政组住院证信息，供界面模板引用
/// Input：		Adm: 就诊RowId
/// Output:		CreateDate:建住院证日期, 
/// 			CreateTime:建住院证时间, 
/// 			CreateUser:建住院证操作员,
/// 			CreateDoc:建住院证医师, 
/// 			BookingDate:预约日期, 
/// 			Ward:住院病区, 
/// 			Bed:住院床号,
/// 			Loc:住院科室,
/// 			ICDDx:诊断,
/// 			Resume:备注信息,
/// 			FirstVisitHospital:首诊医院, 
/// 			Days:预计住院天数,
/// 			ClinicDept:门诊科室
/// ==========================================================================================
Query GetIPBookInfo(Adm As %String) As %Query(ROWSPEC = "CreateDate:%String,CreateTime:%String,CreateUser:%String,CreateDoc:%String,BookingDate:%String,Ward:%String,Bed:%String,Loc:%String,ICDDx:%String,Resume:%String,FirstVisitHospital:%String,Days:%String,ClinicDept:%String")
{
}

ClassMethod GetIPBookInfoExecute(ByRef qHandle As %Binary, Adm As %String) As %Status
{
	
	Set repid=$I(^CacheTemp)
	s ind=1
	Set qHandle=$lb(0,repid,0)

	Quit:($d(^PAADM(Adm))=0)||(Adm="") $$$OK
	
	s IPBookData = ##class(web.DHCMedIPBookingCtl).IGetIPBookByIPPaAdm(Adm)
	//q:(IPBookData="") $$$OK
	///IPBookData的字段顺序
	/// 		顺序	字段名称			说明				指向表
	/// 		1		RowID				RowID		
	/// 		2		PatientID			PA_PatMas.RowID		PA_PatMas
	/// 		3		EpisodeIDFrom		门诊就诊PAAdm RowID	PA_Adm
	/// 		4		EpisodeIDTo			住院就诊PAAdm RowID	PA_Adm
	/// 		5		CreateDate			建住院证日
	/// 		6		CreateTime			建住院证时间	
	/// 		7		CreateUserID		建住院证操作员ID 	SS_User
	/// 		8		CreateDocID			建住院证医师ID		SS_User
	/// 		9		CurrentStateID		当前状态ID 			DR	DHC_MedDictory
	/// 		10		IsActive			有效状态			
	/// 		11		BookingDate			预约日期				
	/// 		12		Text1				住院病区ID			PAC_Ward
	/// 		13		Text2				住院床位ID			PAC_Bed
	/// 		14		Text3				住院科室ID			CT_Loc
	/// 		15		Text4				诊断ID				MRC_ICDDx
	/// 		16		ResumeText			备注
	/// 		17      FirstVisitHospital  首诊医院
	/// 		18		Days					
	s CreateDate = $p(IPBookData,"^",5)
	if (CreateDate '= "") {s CreateDate = $zd(CreateDate,3)}
	
	s CreateTime = $p(IPBookData,"^",6)
	if (CreateTime '= "") {s CreateTime = $zt(CreateTime,2)}
	
	s CreateUser = $p(IPBookData,"^",7)
	if (CreateUser '="") {s CreateUser = $p($g(^SSU("SSUSR",CreateUser)),"^",2)}
	
	s CreateDoc  = $p(IPBookData,"^",8)
	if (CreateDoc '="") {s CreateDoc  = $p($g(^SSU("SSUSR",CreateDoc)),"^",2)}
	
	s BookingDate= $p(IPBookData,"^",11)
	if (BookingDate '= "") {s BookingDate = $zd(BookingDate,3)}
	
	s Ward		 = $p(IPBookData,"^",12)
	if (Ward '="") {s Ward = $p($g(^PAWARD(Ward)),"^",2)}
	
	s Bed        = $p(IPBookData,"^",13)
	s bedrowid   = $p(Bed,"||",1)
	s bedsub     = $p(Bed,"||",2)
	if (bedrowid '= "")&&(bedsub '= "") {s Bed = $p($g(^PAWARD(bedrowid,"BED",bedsub)),"^",1)} 
	
	s Loc        = $p(IPBookData,"^",14)
	if (Loc '= "") {s Loc = $p($g(^CTLOC(Loc)),"^",2)}
	
	s ICDDx      = $p(IPBookData,"^",15)
	if (ICDDx '= "") {s ICDDx = $p($g(^MRC("ID",ICDDx)),"^",2)}
	if (ICDDx = "") {s ICDDx = $p(IPBookData,"^",15)}
	
	s Resume     = $p(IPBookData,"^",16)
	
	s FirstVisitHospital = $p(IPBookData,"^",17)
	
	s Days = $p(IPBookData,"^",18)
	
	s ClinicRowId = $p(IPBookData,"^",3)
	s ClinicDept = ##class(EPRservice.HISInterface.PatientInfoAssist).AdmDept(ClinicRowId)
	s ClinicDept = $p(ClinicDept,"^",2)
		
	set ^CacheTemp(repid, ind) = $LB(CreateDate,CreateTime,CreateUser,CreateDoc,BookingDate,Ward,Bed,Loc,ICDDx,Resume,FirstVisitHospital,Days,ClinicDept)
	set ind = ind + 1
	
	Quit $$$OK
}

ClassMethod GetIPBookInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetIPBookInfoExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetIPBookInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetIPBookInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
	Quit $$$OK
}

/// =================== Query GetRecordSummaryInfo =====================================
/// CreateUser:	HouJian
/// CreateTime：2009-01-12
/// Desc：		取病案摘要信息，供医疗文书的模板引用
/// Input:		argAdm：就诊RowId
/// Output：	Summary：病案摘要信息
/// Table：		EPRinstance.ECRecord, EPRinstance.InstanceData, EPRinstance.ISegment
/// ====================================================================================
Query GetRecordSummaryInfo(argAdm As %String) As %Query(ROWSPEC = "Summary:%String")
{
}

ClassMethod GetRecordSummaryInfoExecute(ByRef qHandle As %Binary, argAdm As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	Set qHandle=$lb(0,repid,0)

	Quit:($d(^PAADM(Adm))=0)||(Adm="") $$$OK

	s summary = ""
	s chartItemId = "118"      	//病案摘要的ChartItemId
	
	s ECRecordId = ##class(EPRservice.EPRinstance).GetECRecordID(argAdm,chartItemId)
	q:(ECRecordId="") $$$OK
	
	s instanceDataId = $O(^DHCEPRI.InstanceDataI("IdxECRecord",ECRecordId,""))
	q:(instanceDataId="") $$$OK
	
	s objInstance = ##class(EPRinstance.InstanceData).%OpenId(instanceDataId)
	q:(objInstance="") $$$OK
	q:(objInstance.Status="UnSave") $$$OK
	q:(objInstance.TemplateID="") $$$OK
	
	s templateId = objInstance.TemplateID 
	if templateId = "29"
	{	s summary = ##class(EPRservice.BOScatterData).GetEPRData("住院病历.病历摘要.内科病历.病历摘要#TYPE:Segment#TID:29#TVER:0#GCODE:G0001")}
	elseif templateId = "149"
	{	s summary = ##class(EPRservice.BOScatterData).GetEPRData("住院病历.病历摘要.神经内科病历.病历摘要#TYPE:Segment#TID:149#TVER:0#GCODE:G0001")}
	elseif templateId = "252"
	{	s summary = ##class(EPRservice.BOScatterData).GetEPRData("住院病历.病历摘要.康复科.病历摘要#TYPE:Segment#TID:252#TVER:0#GCODE:G0001")}
	elseif templateId = "265"
	{	s summary = ##class(EPRservice.BOScatterData).GetEPRData("住院病历.病历摘要.中医科病历.病历摘要#TYPE:Segment#TID:265#TVER:0#GCODE:G0001")}
	elseif templateId = "280"
	{	s summary = ##class(EPRservice.BOScatterData).GetEPRData("住院病历.病历摘要.耳鼻喉科病历.病历摘要#TYPE:Segment#TID:280#TVER:0#GCODE:G0001")}
	elseif templateId = "283"
	{	s summary = ##class(EPRservice.BOScatterData).GetEPRData("住院病历.病历摘要.心理卫生病历.病历摘要#TYPE:Segment#TID:283#TVER:0#GCODE:G0001")}
	elseif templateId = "284"
	{	s summary = ##class(EPRservice.BOScatterData).GetEPRData("住院病历.病历摘要.眼科病历.病历摘要#TYPE:Segment#TID:284#TVER:0#GCODE:G0001")}
	elseif templateId = "285"
	{	s summary = ##class(EPRservice.BOScatterData).GetEPRData("住院病历.病历摘要.外科病历.病历摘要#TYPE:Segment#TID:285#TVER:0#GCODE:G0001")}
	elseif templateId = "290"
	{	s summary = ##class(EPRservice.BOScatterData).GetEPRData("住院病历.病历摘要.神外肿瘤.病历摘要#TYPE:Segment#TID:290#TVER:0#GCODE:G0001")}
	elseif templateId = "291"
	{	s summary = ##class(EPRservice.BOScatterData).GetEPRData("住院病历.病历摘要.颅脑损伤.病历摘要#TYPE:Segment#TID:291#TVER:0#GCODE:G0001")}
	
	set ^CacheTemp(repid, ind) = $LB(summary)
	
	Quit $$$OK
}

/// =================== Query GetRecordSummaryInfo =====================================
/// CreateUser:	HouJian
/// CreateTime：2009-01-12
/// Desc：		取病案摘要信息，供医疗文书的模板引用
/// Input:		argAdm：就诊RowId
/// Output：	Summary：病案摘要信息
/// Table：		EPRinstance.ECRecord, EPRinstance.InstanceData, EPRinstance.ISegment
/// ====================================================================================
Query GetEPRDataInfo(argAdm As %String) As %Query(ROWSPEC = "Summary:%String")
{
}

ClassMethod GetEPRDataInfoExecute(ByRef qHandle As %Binary, argAdm As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	Set qHandle=$lb(0,repid,0)

	Quit:($d(^PAADM(Adm))=0)||(Adm="") $$$OK

	/*s summary = ""
	s chartItemId = "118"      	//病案摘要的ChartItemId
	
	s ECRecordId = ##class(EPRservice.EPRinstance).GetECRecordID(argAdm,chartItemId)
	q:(ECRecordId="") $$$OK
	
	s instanceDataId = $O(^DHCEPRI.InstanceDataI("IdxECRecord",ECRecordId,""))
	q:(instanceDataId="") $$$OK
	
	s objInstance = ##class(EPRinstance.InstanceData).%OpenId(instanceDataId)
	q:(objInstance="") $$$OK
	q:(objInstance.Status="UnSave") $$$OK
	q:(objInstance.TemplateID="") $$$OK
	
	s templateId = objInstance.TemplateID 
	if templateId = "29"
	{	s summary = ##class(EPRservice.BOScatterData).GetEPRData("住院病历.病历摘要.内科病历.病历摘要#TYPE:Segment#TID:29#TVER:0#GCODE:G0001")}
	elseif templateId = "149"
	{	s summary = ##class(EPRservice.BOScatterData).GetEPRData("住院病历.病历摘要.神经内科病历.病历摘要#TYPE:Segment#TID:149#TVER:0#GCODE:G0001")}
	elseif templateId = "252"
	{	s summary = ##class(EPRservice.BOScatterData).GetEPRData("住院病历.病历摘要.康复科.病历摘要#TYPE:Segment#TID:252#TVER:0#GCODE:G0001")}
	elseif templateId = "265"
	{	s summary = ##class(EPRservice.BOScatterData).GetEPRData("住院病历.病历摘要.中医科病历.病历摘要#TYPE:Segment#TID:265#TVER:0#GCODE:G0001")}
	elseif templateId = "280"
	{	s summary = ##class(EPRservice.BOScatterData).GetEPRData("住院病历.病历摘要.耳鼻喉科病历.病历摘要#TYPE:Segment#TID:280#TVER:0#GCODE:G0001")}
	elseif templateId = "283"
	{	s summary = ##class(EPRservice.BOScatterData).GetEPRData("住院病历.病历摘要.心理卫生病历.病历摘要#TYPE:Segment#TID:283#TVER:0#GCODE:G0001")}
	elseif templateId = "284"
	{	s summary = ##class(EPRservice.BOScatterData).GetEPRData("住院病历.病历摘要.眼科病历.病历摘要#TYPE:Segment#TID:284#TVER:0#GCODE:G0001")}
	elseif templateId = "285"
	{	s summary = ##class(EPRservice.BOScatterData).GetEPRData("住院病历.病历摘要.外科病历.病历摘要#TYPE:Segment#TID:285#TVER:0#GCODE:G0001")}
	elseif templateId = "290"
	{	s summary = ##class(EPRservice.BOScatterData).GetEPRData("住院病历.病历摘要.神外肿瘤.病历摘要#TYPE:Segment#TID:290#TVER:0#GCODE:G0001")}
	elseif templateId = "291"
	{	s summary = ##class(EPRservice.BOScatterData).GetEPRData("住院病历.病历摘要.颅脑损伤.病历摘要#TYPE:Segment#TID:291#TVER:0#GCODE:G0001")}*/
	;s Account="",H
	
	set ^CacheTemp(repid, ind) = $LB(summary)
	
	Quit $$$OK
}

ClassMethod GeEPRDataInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetRecordSummaryInfoExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetEPRDataInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetRecordSummaryInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
	Quit $$$OK
}

ClassMethod GetRecordSummaryInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetRecordSummaryInfoExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetRecordSummaryInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetRecordSummaryInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
	Quit $$$OK
}

/// ////////////////////////////////////////////////////////////////////////////////////////////////
/// Creator：	EPR
/// CreateDate：2010-01-01
/// Desc：		取患者病程历史信息
/// Input:		Adm: 就诊rowid
/// Return：
/// Test:		##Class(EPRservice.SystemData).testinstance(Adm,CID)	
/// 			d ##class(%ResultSet).RunQuery("EPRservice.SystemData","GetOtherInstanceDataInfo","21","54")
/// ////////////////////////////////////////////////////////////////////////////////////////////////
Query GetOtherInstanceDataInfo(EpisodeID As %String, ChartItemID As %String) As %Query(ROWSPEC = "InstanceData:%String")
{
}

ClassMethod GetOtherInstanceDataInfoExecute(ByRef qHandle As %Binary, aEpisodeID As %String, aChartItemID As %String) As %Status
{
	s qHandle=""
	q $$$OK

	q:(($d(aEpisodeID)=0)||(aEpisodeID="")||($d(aChartItemID)=0)||(aChartItemID="")) $$$OK
	
	//初始化返回值
	s retVal = ""
	s patID = "", name = "", bed = "", age = ""
	
	//配置要取的可重复模板的ChartItemID
	s otherChartItemID = ""
	if aChartItemID = 54                ///自己
	{	s otherChartItemID = 53}    ////划

	//指定要取的历次病程记录天数, 从今天(包含今天)往前推算
	s dayRange = 3 
	
	//获取历次病程记录总数
	s ECRecordID = ##class(EPRinstance.ECRecord).GetECRecordID("", aEpisodeID, otherChartItemID)
	s objECRecord = ##class(EPRinstance.ECRecord).%OpenId(ECRecordID)
	quit:(objECRecord = "") $$$OK
	s instanceCount = objECRecord.InstanceCount
	quit:(instanceCount = "") $$$OK
	
	//获取历次病程创建日期
	s createDateGroup = ""
	s dt = ##class(%ResultSet).%New("EPRinstance.InstanceData:SELECTCreateDateGroupList")
 d dt.Execute(ECRecordID)
 while (dt.Next())
 {	
 s createDate = dt.Data("CreateDate")
 //检测日期格式?防止自动格式转换
 if (createDate?.N)
 {	s createDateGroup = createDateGroup_"^"_createDate}
 elseif (createDate?4N1"-"1.2N1"-"1.2N)
 {	s createDateGroup = createDateGroup_"^"_$zdh(createDate,3)}
 }
	if (createDateGroup '= "")
	{	s createDateGroup = $e(createDateGroup,2,$l(createDateGroup))}
	s dateGroupCount = $L(createDateGroup,"^")
	
	//如果今天还未写过历次病程,将今日添加到创建日期中,以便下面推算要提取的创建日期
	s today = $p($h,",",1)
	if (today '= $p(createDateGroup,"^",dateGroupCount))
	{	
		s createDateGroup = createDateGroup_"^"_today
		s dateGroupCount = dateGroupCount + 1
	}
	 
	//由指定要取的历次护理记录天数推算要取的创建日期
	s dateGroupBegin = ""
	if (dayRange < dateGroupCount)
	{
		s dateGroupBegin = dateGroupCount - dayRange + 1
	}
	else
	{
		s dateGroupBegin = 1
	} 
	//获取指定天数的历次病程记录
	for I = 1:1:instanceCount
	{ 
		s objInstance = objECRecord.Instances.GetAt(I)
		quit:(objInstance="") 
		s instanceID = objInstance.%Id()
	    s templateID = objInstance.TemplateID
	    s createDate = objInstance.CreateDate

		//判断是否在指定天数之内
		s inFlag = 0
		for J = dateGroupBegin:1:dateGroupCount
		{
			if (createDate = $p(createDateGroup,"^",J))
			{	
				s inFlag = 1
				quit
			}
		}
	  
 if (inFlag=1)&&(otherChartItemID=53) 
 {
			s dateTime = ##class(EPRservice.BOScatterData).GetMultipleScatterData(aEpisodeID, templateID, "D0002", instanceID, "V")
			s careLevel = ##class(EPRservice.BOScatterData).GetMultipleScatterData(aEpisodeID, templateID, "O0003", instanceID, "V")
			s diet = ##class(EPRservice.BOScatterData).GetMultipleScatterData(aEpisodeID, templateID, "O0004", instanceID, "V")
			s bodyPos = ##class(EPRservice.BOScatterData).GetMultipleScatterData(aEpisodeID, templateID, "M0006", instanceID, "V")
			s conObsence = ##class(EPRservice.BOScatterData).GetMultipleScatterData(aEpisodeID, templateID, "M0022", instanceID, "V")
			s basisCare = ##class(EPRservice.BOScatterData).GetMultipleScatterData(aEpisodeID, templateID, "M0008", instanceID, "V")
			s pipeCare = ##class(EPRservice.BOScatterData).GetMultipleScatterData(aEpisodeID, templateID, "M0013", instanceID, "V")
			s currentRecord = ##class(EPRservice.BOScatterData).GetMultipleScatterData(aEpisodeID, templateID, "M0015", instanceID, "V")
			s other = ##class(EPRservice.BOScatterData).GetMultipleScatterData(aEpisodeID, templateID, "G0023", instanceID, "V")
			s nurse = ##class(EPRservice.BOScatterData).GetMultipleScatterData(aEpisodeID, templateID, "I0020", instanceID, "V")
			s nurseCap = ##class(EPRservice.BOScatterData).GetMultipleScatterData(aEpisodeID, templateID, "I0021", instanceID, "V")
		    
		    s retVal = retVal_"日期时间?"_dateTime_"? "_$c(13)
		    s retVal = retVal_"护理级别: "_careLevel_"? "_$c(13)
			s retVal = retVal_"饮食护理: "_diet_"? "_$c(13)
			s retVal = retVal_"体位: "_bodyPos_"? "_$c(13)
			s retVal = retVal_"病情观察: "_conObsence_"? "_$c(13)
			s retVal = retVal_"基础护理: "_basisCare_"? "_$c(13)
			s retVal = retVal_"留置管道的护理: "_pipeCare_"? "_$c(13)
			s retVal = retVal_"出入量记录: "_currentRecord_"? "_$c(13)
			s retVal = retVal_"其他: "_other_"? "_$c(13)
			s retVal = retVal_"护士  护士长/组长: "_nurse_"   "_nurseCap_$c(13,13)
		    
		    if (I = instanceCount)
		    {
			    s patID = ##class(EPRservice.BOScatterData).GetMultipleScatterData(aEpisodeID, templateID, "S0012", instanceID, "V")
			    s bed = ##class(EPRservice.BOScatterData).GetMultipleScatterData(aEpisodeID, templateID, "S0009", instanceID, "V")
			    s name = ##class(EPRservice.BOScatterData).GetMultipleScatterData(aEpisodeID, templateID, "S0010", instanceID, "V")
			    s age = ##class(EPRservice.BOScatterData).GetMultipleScatterData(aEpisodeID, templateID, "S0011", instanceID, "V")    
			}
		}
		///elseif (inFlag=1)&&(otherChartItemID=???)
		///{}
	}	
	

	s retVal = "登记号: "_patID_"     "_"床号: "_bed_"     "_"姓名: "_name_"     "_"年龄: "_age_$c(13,13)_retVal
	  
	s myQueryResult = $LB(retVal)   		
 s qHandle = myQueryResult
	
	Quit $$$OK
}

ClassMethod GetOtherInstanceDataInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetOtherInstanceDataInfoExecute ]
{
	if qHandle'=""
	{
		s Row=qHandle
		s qHandle=""
	}
	else
	{
		s Row = ""
		s AtEnd=1
	}
	Quit $$$OK
}

ClassMethod GetOtherInstanceDataInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetOtherInstanceDataInfoExecute ]
{
 s qHandle="" 
 Quit $$$OK
}

/// ////////////////////////////////////////////////////////////////////////////////////////////////
/// Creator：	EPR
/// CreateDate：2010-01-01
/// Desc：		取实例信息
/// Input:		Adm: 就诊rowid
/// Return：
/// Test:		d ##class(%ResultSet).RunQuery("EPRservice.SystemData","GetInstanceOper","21","54")		
/// ////////////////////////////////////////////////////////////////////////////////////////////////
Query GetInstanceOper(aAdm As %String, aInstanceID As %String) As %Query(ROWSPEC = "UserNames")
{
}

ClassMethod GetInstanceOperExecute(ByRef qHandle As %Binary, aAdm As %String, aInstanceID As %String) As %Status
{
	//b "s"
	
	Set repid=$I(^CacheTemp)
	set ind=1
	Set qHandle=$lb(0,repid,0)

	Quit:($d(^PAADM(aAdm))=0)||(aAdm="") $$$OK
	Quit:($d(^PAADM(aInstanceID))=0)||(aInstanceID="") $$$OK

	set UserNames = ""
	set ecRecordID = $P(aInstanceID,"||",1)
	set eprNum = $P(aInstanceID,"||",2)
	quit:(eprNum="") $$$OK
	
	set objECRecord = ##class(EPRinstance.InstanceData).%OpenId(ecRecordID)
	set chartID = objECRecord.ChartItemID
	quit:($E(chartID,1,2)'="ML") $$$OK
	
	set printTmplateDocID = $E(chartID,2,$L(chartID))
	quit:(printTmplateDocID="") $$$OK
	
	s UserNames = ##class(EPRservice.BOEPRLogs).GetAllUserByAction(aAdm,,printTmplateDocID,eprNum,"save^complete")
	
	set ^CacheTemp(repid, ind) = $LB(UserNames)
	set ind = ind + 1
	
	Quit $$$OK
}

ClassMethod GetInstanceOperFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetInstanceOperExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetInstanceOperClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetInstanceOperExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
	Quit $$$OK
}

/// 取历次病历格式护理记录的实例数据
/// d ##class(%ResultSet).RunQuery("EPRservice.SystemData","GetInstanceDataInfo","56","48")
Query GetInstanceDataInfo(aEpisodeID As %String, aChartItemID As %String = "", aInstanceID As %String = "") As %Query(ROWSPEC = "InstanceData:%String")
{
}

ClassMethod GetInstanceDataInfoExecute(ByRef qHandle As %Binary, aEpisodeID As %String, aChartItemID As %String = "", aInstanceID As %String = "") As %Status
{
	s qHandle=""
	q:(($d(aEpisodeID)=0)||(aEpisodeID="")||($d(aChartItemID)=0)||(aChartItemID="")) $$$OK
	q:((aChartItemID="")&&(aInstanceID="")) $$$OK
	
	//初始化返回值
	s retVal = ""
	s name ="", age = "", bed ="", patID = ""
	
	//指定要取的历次病程记录天数, 从今天(包含今天)往前推算
	s dayRange = 3
	s dayCount = 0
	s recordCount = 0
	
	//判断历次病历是否保存过至少一条
	if (aInstanceID = "")
	{
		s ECRecordID = ##class(EPRinstance.ECRecord).GetECRecordID("", aEpisodeID, aChartItemID)
		q:(ECRecordID="") $$$OK
		s listNo = $O(^DHCEPRI.InstanceDataI("IdxECRecord",ECRecordID,""))
		q:(listNo="") $$$OK
	}
	else
	{
		q:($L(aInstanceID,"||")'=2) $$$OK
		s ECRecordID = $P(aInstanceID,"||",1)
		s listNo = 1
	}
	
	//取所有历次病历日期、时间, 并排序
	s repid = $I(^CacheTemp)
	while (listNo '= "")
	{
		s instanceId = ECRecordID_"||"_listNo
		s objInstance = ##class(EPRinstance.InstanceData).%OpenId(instanceId)
		if (objInstance '= "")&&(objInstance.HappenDate '= "")&&(objInstance.HappenTime '= "")
		{
			s date = objInstance.HappenDate
			s time = objInstance.HappenTime
			s tid = objInstance.TemplateID
			s ^CacheTemp(repid, date, time) = instanceId
			s ^CacheTemp(repid, date, time, "TemplateID") = tid
		}
		
		s listNo = $O(^DHCEPRI.InstanceDataI("IdxECRecord",ECRecordID,listNo))
	}
	q:($d(^CacheTemp(repid))=0) $$$OK
	
	//若本次病历未保存过，按照日期从最后往前取一定天数的病历内容
	//若本次病历已保存过，按照日期从本次病历的HappenDate往前取一定天数的病历内容
	s date="", time=""
	s curInstanceDate="", curInstanceTime=""
	if (aInstanceID'="")
	{
		s objInstance = ##class(EPRinstance.InstanceData).%OpenId(aInstanceID)
		if (objInstance'="")
		{	
			s curInstanceDate = objInstance.HappenDate
			s curInstanceTime = objInstance.HappenTime
			s date = curInstanceDate
		}	
	}
	
	if (date="")
	{	s date = $O(^CacheTemp(repid, ""), -1)} 	
	while (date '= "")
	{
		s dayCount = dayCount + 1
		q:(dayCount>dayRange)	//取够一定天数的病历就退出
		
		if (date=curInstanceDate)
		{	s time = curInstanceTime}
		else
		{	s time = $O(^CacheTemp(repid, date, ""), -1)}
		while (time'="")
		{
			s recordCount = recordCount + 1
			s instanceID = ^CacheTemp(repid, date, time)
			s templateID = ^CacheTemp(repid, date, time, "TemplateID")
			
			do GetData
			
			s time = $O(^CacheTemp(repid, date, time), -1)
		}
		
		s date = $O(^CacheTemp(repid, date), -1)
	}
	
	kill ^CacheTemp(repid)
	
	s retVal = "登记号:"_patID_"     "_"床号:"_bed_"     "_"姓名:"_name_"     "_"年龄:"_age_$c(13,13)_retVal
	
	
	//debug
	/*
	s ^DHCEPRDebug("EPRservice.SystemData","retVal") = retVal
	s ^DHCEPRDebug("EPRservice.SystemData","chartItemID") = aChartItemID
	s ^DHCEPRDebug("EPRservice.SystemData","EpisodeID") = aEpisodeID
	s ^DHCEPRDebug("EPRservice.SystemData","ECRecord") = ECRecordID
	s ^DHCEPRDebug("EPRservice.SystemData","DateToday") = $zd($h,3)
	s ^DHCEPRDebug("EPRservice.SystemData","DateGroupBegin") = dateGroupBegin
	s ^DHCEPRDebug("EPRservice.SystemData","DateGroupCount") = dateGroupCount
	s ^DHCEPRDebug("EPRservice.SystemData","createDateGroup") = createDateGroup
	*/

	s myQueryResult = $LB(retVal)
 	s qHandle = myQueryResult

	Quit $$$OK

GetData
	//if (aChartItemID=54) 
 	//{
		if (recordCount = 1)
	 	{
			//病人基本信息只需要取一份即可
	 		s patID = ##class(EPRservice.BOScatterData).GetMultipleScatterData(aEpisodeID, templateID, "S0012", instanceID, "V")
		   	s bed = ##class(EPRservice.BOScatterData).GetMultipleScatterData(aEpisodeID, templateID, "S0001", instanceID, "V")
		   	s name = ##class(EPRservice.BOScatterData).GetMultipleScatterData(aEpisodeID, templateID, "S0002", instanceID, "V")
		   	s age = ##class(EPRservice.BOScatterData).GetMultipleScatterData(aEpisodeID, templateID, "S0011", instanceID, "V")    
	 	}
	 			
		s dateTime = ##class(EPRservice.BOScatterData).GetMultipleScatterData(aEpisodeID, templateID, "D0005", instanceID, "V")
		s T = ##class(EPRservice.BOScatterData).GetMultipleScatterData(aEpisodeID, templateID, "S0006", instanceID, "V")
		s P = ##class(EPRservice.BOScatterData).GetMultipleScatterData(aEpisodeID, templateID, "S0007", instanceID, "V")
		s R= ##class(EPRservice.BOScatterData).GetMultipleScatterData(aEpisodeID, templateID, "S0008", instanceID, "V")
		s BP = ##class(EPRservice.BOScatterData).GetMultipleScatterData(aEpisodeID, templateID, "S0009", instanceID, "V")
		s ShuZhangYa = ##class(EPRservice.BOScatterData).GetMultipleScatterData(aEpisodeID, templateID, "S0021", instanceID, "V")
		s Spo2 = ##class(EPRservice.BOScatterData).GetMultipleScatterData(aEpisodeID, templateID, "S0022", instanceID, "V")
		s NiaoLiang = ##class(EPRservice.BOScatterData).GetMultipleScatterData(aEpisodeID, templateID, "S0014", instanceID, "V")
		s YinDaoLiuXue = ##class(EPRservice.BOScatterData).GetMultipleScatterData(aEpisodeID, templateID, "S0015", instanceID, "V")
		s FuYaYinLiu = ##class(EPRservice.BOScatterData).GetMultipleScatterData(aEpisodeID, templateID, "S0016", instanceID, "V")			
		s WeiGuanYinLiu = ##class(EPRservice.BOScatterData).GetMultipleScatterData(aEpisodeID, templateID, "S0017", instanceID, "V")
		s SheRu = ##class(EPRservice.BOScatterData).GetMultipleScatterData(aEpisodeID, templateID, "S0018", instanceID, "V")
		s GuanChaJiLu = ##class(EPRservice.BOScatterData).GetMultipleScatterData(aEpisodeID, templateID, "E0019", instanceID, "V")			
		s nurse = ##class(EPRservice.BOScatterData).GetMultipleScatterData(aEpisodeID, templateID, "I0020", instanceID, "V")
					
		s tmpVal = ""	    
		s tmpVal = tmpVal_"日期时间?"_dateTime_$c(13)
		s tmpVal = tmpVal_"T?"_T_"    P: "_P_"    R?"_R_$c(13)
		s tmpVal = tmpVal_"BP?"_BP_"/"_ShuZhangYa_"    Spo2?"_Spo2_$c(13)
		s tmpVal = tmpVal_"尿量?"_NiaoLiang_"    阴道流血?"_YinDaoLiuXue_$c(13)
		s tmpVal = tmpVal_"负压引流: "_FuYaYinLiu_"    胃管引流?"_WeiGuanYinLiu_$c(13)
		s tmpVal = tmpVal_"摄入: "_SheRu_$c(13)
		s tmpVal = tmpVal_"观察记录: "_GuanChaJiLu_$c(13)
		s tmpVal = tmpVal_"签名?"_nurse
		
		if retVal = ""
		{	s retVal = tmpVal}
		else
		{	s retVal = tmpVal_$c(13,13)_retVal}
 	//} 
 	quit
}

ClassMethod GetInstanceDataInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetInstanceDataInfoExecute ]
{
	if qHandle'=""
	{
		s Row=qHandle
		s qHandle=""
	}
	else
	{
		s Row = ""
		s AtEnd=1
	}
	Quit $$$OK
}

ClassMethod GetInstanceDataInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetInstanceDataInfoExecute ]
{
 s qHandle="" 
 Quit $$$OK
}

/// =================== Query GetOperationInfo =====================================
/// CreateUser:	HouJian
/// CreateTime：2009-01-21
/// Desc：		取手术信息
/// Input:		argAdm：就诊RowId
/// Output：	OperDesc1：手术名称一
/// 			OperDesc2：手术名称二
/// 			OperDesc3：手术名称三
/// 			OperDesc4：手术名称四
/// Table：		
/// Debug:		d ##class(%ResultSet).RunQuery("EPRservice.SystemData","GetOperationInfo","2653342")
/// ====================================================================================
Query GetOperationInfo(argAdm As %String) As %Query(ROWSPEC = "OperDesc1:%String,OperDesc2:%String,OperDesc3:%String,OperDesc4:%String")
{
}

ClassMethod GetOperationInfoExecute(ByRef qHandle As %Binary, argAdm As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	Set qHandle=$lb(0,repid,0)
	
	s OperDesc1 = "", OperDesc1=2 = "", OperDesc3 = "", OperDesc4 = ""
	s OperStr = ""
	
	s rset=##class(%ResultSet).%New("EPRservice.HISInterface.PatientInfoAssist:FindOrderItems")
	do rset.Execute(argAdm,"2")
	While (rset.Next()) {
		
		s OperStr = OperStr_"^"_rset.Data("OrderName")
	}
	d rset.Close()
	
	if (OperStr '= "")
	{	s OperStr = $E(OperStr,2,$L(OperStr))}
	s OperDesc1 = $P(OperStr,"^",1)
	s OperDesc2 = $P(OperStr,"^",2)
	s OperDesc3 = $P(OperStr,"^",3)
	s OperDesc4 = $P(OperStr,"^",4)
	
	set ^CacheTemp(repid, ind) = $LB(OperDesc1,OperDesc2,OperDesc3,OperDesc4)
	
	Quit $$$OK
}

ClassMethod GetOperationInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetOperationInfoExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetOperationInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetOperationInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
	Quit $$$OK
}

/// =================== Query GetBirthAddInfo =====================================
/// CreateUser:	xuefl
/// CreateTime：2009-06-26
/// Desc：		取界面模板个人史出生地信息，供医疗文书的模板引用
/// Input:		argAdm：就诊RowId
/// Output：	：个人史信息
/// Table：		EPRinstance.ECRecord, EPRinstance.InstanceData, EPRinstance.ITextDesc
/// Debug:		d ##class(%ResultSet).RunQuery("EPRservice.SystemData","GetBirthAddInfo","2671627")
/// ====================================================================================
Query GetBirthAddInfo(argAdm As %String) As %Query(ROWSPEC = "BirthAddPro:%String,BirthAddCityAro:%String")
{
}

ClassMethod GetBirthAddInfoExecute(ByRef qHandle As %Binary, argAdm As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	Set qHandle=$lb(0,repid,0)
	
	//b "s"
	
	s BirthAddPro= "",BirthAddCityAr="" // 取大病历的出生地省和出生地市县，用于首页
	s chartItemId = "112"      	//[一般情况主诉现病史]横排的ChartItemId
	
	s ECRecordId = ##class(EPRinstance.ECRecord).GetECRecordID("",argAdm,chartItemId)
	q:(ECRecordId="") $$$OK
	
	//s instanceDataId = $O(^DHCEPRI.InstanceDataI("IdxECRecord",ECRecordId,""))
	//q:(instanceDataId="") $$$OK
	s instanceDataId = ECRecordId_"||1"		//[个人史]模板在该横排的第1位
	
	s objInstance = ##class(EPRinstance.InstanceData).%OpenId(instanceDataId)
	q:(objInstance="") $$$OK
	q:(objInstance.Status="UnSave") $$$OK
	q:(objInstance.TemplateID="") $$$OK
	
	s templateId = objInstance.TemplateID 
	if templateId = "15"   ///内科病历     
	{	s BirthAddPro = ##class(EPRservice.BOScatterData).GetEPRData(argAdm,"#TYPE:Simple#TID:15#TVER:0#SCODE:I0029#VTYPE:V")
	    s BirthAddCityAr = ##class(EPRservice.BOScatterData).GetEPRData(argAdm,"县#TYPE:Simple#TID:15#TVER:0#SCODE:S0028#VTYPE:V")
	 }
	elseif templateId = "36"  ///	心理卫生病历  
	{	s BirthAddPro = ##class(EPRservice.BOScatterData).GetEPRData(argAdm,"心理卫生病历.出生地省（市）#TYPE:Simple#TID:36#TVER:0#SCODE:I0045#VTYPE:V")
		s BirthAddCityAr = ##class(EPRservice.BOScatterData).GetEPRData(argAdm,"心理卫生病历.出生地县#TYPE:Simple#TID:36#TVER:0#SCODE:S0044#VTYPE:V")
    }
	elseif templateId = "56"   ///	眼科病历  
	{	s BirthAddPro = ##class(EPRservice.BOScatterData).GetEPRData(argAdm,"眼科病历.出生地省（市）#TYPE:Simple#TID:56#TVER:0#SCODE:I0029#VTYPE:V")
		s BirthAddCityAr = ##class(EPRservice.BOScatterData).GetEPRData(argAdm,"眼科病历.出生地县#TYPE:Simple#TID:56#TVER:0#SCODE:S0001#VTYPE:V")
    }
	elseif templateId = "82"   //	耳鼻喉科病历  
	{	s BirthAddPro = ##class(EPRservice.BOScatterData).GetEPRData(argAdm,"耳鼻喉科病历.出生地省（市）#TYPE:Simple#TID:82#TVER:0#SCODE:I0029#VTYPE:V")
	s BirthAddCityAr = ##class(EPRservice.BOScatterData).GetEPRData(argAdm,"耳鼻喉科病历.出生地县#TYPE:Simple#TID:82#TVER:0#SCODE:S0028#VTYPE:V")
	}
	elseif templateId = "101"  //	外科病历 
	{	s BirthAddPro = ##class(EPRservice.BOScatterData).GetEPRData(argAdm,"外科病历.出生地省（市）#TYPE:Simple#TID:101#TVER:0#SCODE:I0029#VTYPE:V")
	s BirthAddCityAr = ##class(EPRservice.BOScatterData).GetEPRData(argAdm,"外科病历.出生地县#TYPE:Simple#TID:101#TVER:0#SCODE:S0028#VTYPE:V")
	}
	elseif templateId = "127"  //	神经内科病历 
	{	s BirthAddPro = ##class(EPRservice.BOScatterData).GetEPRData(argAdm,"神经内科病历.出生地省（市）#TYPE:Simple#TID:127#TVER:0#SCODE:I0028#VTYPE:V")
	s BirthAddCityAr = ##class(EPRservice.BOScatterData).GetEPRData(argAdm,"神经内科病历.出生地县#TYPE:Simple#TID:127#TVER:0#SCODE:S0001#VTYPE:V")
	}
	elseif templateId = "154"  //	颅脑损伤    
	{	s BirthAddPro = ##class(EPRservice.BOScatterData).GetEPRData(argAdm,"颅脑损伤.出生地省（市）#TYPE:Simple#TID:154#TVER:0#SCODE:I0029#VTYPE:V")
	s BirthAddCityAr = ##class(EPRservice.BOScatterData).GetEPRData(argAdm,"颅脑损伤.出生地县#TYPE:Simple#TID:154#TVER:0#SCODE:S0028#VTYPE:V")
	}
	elseif templateId = "184"  //	中医科病历
	{	s BirthAddPro = ##class(EPRservice.BOScatterData).GetEPRData(argAdm,"中医科病历.出生地省（市）#TYPE:Simple#TID:184#TVER:0#SCODE:I0029#VTYPE:V")
	s BirthAddCityAr = ##class(EPRservice.BOScatterData).GetEPRData(argAdm,"中医科病历.出生地县#TYPE:Simple#TID:184#TVER:0#SCODE:S0028#VTYPE:V")
	}
	elseif templateId = "206"  //	神外肿瘤 
	{	s BirthAddPro = ##class(EPRservice.BOScatterData).GetEPRData(argAdm,"神外肿瘤.出生地省（市）#TYPE:Simple#TID:206#TVER:0#SCODE:I0030#VTYPE:V")
	s BirthAddCityAr = ##class(EPRservice.BOScatterData).GetEPRData(argAdm,"神外肿瘤.出生地县#TYPE:Simple#TID:206#TVER:0#SCODE:S0028#VTYPE:V")
	}
	elseif templateId = "238"  //	康复科
	{	s BirthAddPro = ##class(EPRservice.BOScatterData).GetEPRData(argAdm,"康复科.出生地省（市）#TYPE:Simple#TID:238#TVER:0#SCODE:I0041#VTYPE:V")
	s BirthAddCityAr = ##class(EPRservice.BOScatterData).GetEPRData(argAdm,"康复科.出生地县#TYPE:Simple#TID:238#TVER:0#SCODE:S0001#VTYPE:V")
	}
	elseif templateId = "404"  // 	内镜下治疗 
	{	s BirthAddPro = ##class(EPRservice.BOScatterData).GetEPRData(argAdm,"内镜下治疗.省（市）#TYPE:Simple#TID:404#TVER:0#SCODE:I0029#VTYPE:V")
	s BirthAddCityAr = ##class(EPRservice.BOScatterData).GetEPRData(argAdm,"内镜下治疗.县#TYPE:Simple#TID:404#TVER:0#SCODE:S0030#VTYPE:V")
	}
	elseif templateId = "426" //	金卡既往史 
	{	s BirthAddPro = ##class(EPRservice.BOScatterData).GetEPRData(argAdm,"住院病历.个人史 婚姻史 家族史.个人史.金卡个人史.Place of birth：#TYPE:Simple#TID:426#TVER:0#SCODE:S0001#VTYPE:V")
	//s BirthAddCityAr = ##class(EPRservice.BOScatterData).GetEPRData(argAdm,"住院病历.个人史 婚姻史 家族史.个人史.内科病历.出生地#TYPE:Simple#TID:15#TVER:0#SCODE:S0028#VTYPE:V")
	}
    i BirthAddPro'="" s BirthAddPro= ""_"^"_ BirthAddPro
	
	set ^CacheTemp(repid, ind) = $LB(BirthAddPro,BirthAddCityAr)
	
	Quit $$$OK
}

ClassMethod GetBirthAddInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetBirthAddInfoExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetBirthAddInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetBirthAddInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
	Quit $$$OK
}

/// =================== Query GetPISRepInfo=====================================
/// CreateUser:	xuefl
/// CreateTime：2009-07-07
/// Desc：		取病理诊断，供首页的模板引用
/// Input:		argAdm：就诊RowId
/// Output：	 PISRepList:%String：院内感染	
/// Table：		
/// Debug:		d ##class(%ResultSet).RunQuery("EPRservice.SystemData","GetPISRepInfo","2653342")
/// ====================================================================================
Query GetPISRepInfo(argAdm As %String) As %Query(ROWSPEC = "PISRepList:%String")
{
}

ClassMethod GetPISRepInfoExecute(ByRef qHandle As %Binary, argAdm As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	Set qHandle=$lb(0,repid,0)
	
	s retStr = ""
    //"TRegNo:%String,TStudyNo:%String,TItemName:%String,TItemDate:%String,TItemStatus:%String,TOEOrderDr:%String,TIsIll:%String,TLocName:%String,TreplocDr:%String,TIshasImg:%String,TMediumName:%String,TImgBrowse:%String,TImgShut:%String,TOpenRpt:%String,Memo:%String,TOtherParam:%String,TOrdCat:%String"
    Set rset = ##class(%ResultSet).%New("EPRservice.HISInterface.PatientInfoAssist:QueryStudyByPaadmDR")
	do rset.Execute(argAdm)
	While (rset.Next()) {
	 s PISOEOrderDr="" , PISreplocDrDr="" ,PISdiaName="" 
	 s PISOEOrderDr = rset.Data("TOEOrderDr")
	 s PISreplocDrDr = rset.Data("TreplocDr")
        s ^xuefl(88,argAdm,1)=PISreplocDrDr_" PISOEOrderDr:"_PISOEOrderDr
		if PISreplocDrDr'=""  //(72)
		 {
			d $zu(5,"PIS")
			s PISdiaNametemp= ##class(PISApp.PISService).GetRptInfoByOeorditemID(PISOEOrderDr) 
			s PISdiaName = $P($G(PISdiaNametemp),"^",14)
			d $zu(5,"DHC-APP")
			 } 
		;s ^xuefl(88,2,argAdm)=PISdiaName
		;s ^xuefl(88,4,argAdm)=PISdiaNametemp
		if PISdiaName'="" {	s retStr = retStr_PISdiaName_$c(13,10) }
	}
	d rset.Close()
	if retStr'="" {s YesNo="是"  }
	else { s YesNo="否"} 
	
	if retStr'= ""
	{	s retStr = $e(retStr,1,$l(retStr)-2)}
	//{	s retStr = retStr_":"_YesNo }
	;w retStr
	set ^CacheTemp(repid, ind) = $LB(retStr)
	
	Quit $$$OK
}

ClassMethod GetPISRepInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPISRepInfoExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetPISRepInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPISRepInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
	Quit $$$OK
}

/// =========================================================================
/// Desc: 湖南肿瘤医院科别 病区 个性化处理
/// Input: argDesc="五病区(肝胆胰内科)"or"五病区护理单元" argType="E"or"W"
/// Test: ##Class(EPRservice.SystemData).ConvertLocation(desc,type)
ClassMethod ConvertLocation(argDesc As %String, argType As %String) As %String
{
	q:(argDesc="")||(argType="") ""
	
	s RetCvt="",cvtfrom="",cvtto=""
	
	if (argType="E")
	{
		s:($f(argDesc,"(")'=0) cvtfrom=$f(argDesc,"(")
		s:($f(argDesc,")")'=0) cvtto=$f(argDesc,")")-2
		s:(cvtfrom'="")&&(cvtto'="") RetCvt=$e(argDesc,cvtfrom,cvtto)
	}
	elseif (argType="W")
	{
		s RetCvt=$tr(argDesc,"护理单元")
	}
	else
	{
		s RetCvt=argDesc
	}
	
	q RetCvt
}

/// Debug:d ##class(EPRservice.SystemData).GetEPRDiagAndOper(5)
ClassMethod GetEPRDiagAndOper(argAdmId As %String)
{
	//电子病历组程序
    //返回值:主诊断描述^主诊断ICD代码^主诊断出院情况^手术1描述^手术1代码^手术2描述^手术2代码^手术3描述^手术3代码^手术4描述^手术4代码
	q:($d(argAdmId)=0)||(argAdmId="") ""
	s result=""
	
	///主诊断描述，主诊断代码，主诊断出院情况
	s mainDiagDesc= "", mainDiagCode="", mainDiagOut=""
	s mainDiagDesc = ##class(EPRservice.BOScatterData).GetEPRData(argAdmId,"#TYPE:Segment#TID:6#TVER:0#GCODE:G0070")
	if (mainDiagDesc="") {	s mainDiagDesc =  ##class(EPRservice.BOScatterData).GetEPRData(argAdmId,"#TYPE:SegmentSimple#TID:19#TVER:0#TCODE:G0017#SCODE:S0109#VTYPE:V")}
    s mainDiagCode = ##Class(web.DHCWMRCodingInterface).getFrontPageICD(argAdmId,"D/1",1)
    s mainDiagCode = $p($g(mainDiagCode),$c(2),1)
	s mainDiagOut = ##class(EPRservice.BOScatterData).GetEPRData(argAdmId,"#TYPE:Simple#TID:1#TVER:0#SCODE:O0062#VTYPE:V")
	;if (mainDiagOut="") {	s mainDiagOut =  ##class(EPRservice.BOScatterData).GetEPRData(argAdmId,"#TYPE:Simple#TID:22#TVER:0#SCODE:O0042#VTYPE:V")}
	
	
	///手术描述，手术代码
	s oper1Desc="", oper1Code="", oper2Desc="", oper2Code="", oper3Desc="", oper3Code="", oper4Desc="", oper4Code=""
	s oper1Desc = ##class(EPRservice.BOScatterData).GetEPRData(argAdmId,"#TYPE:Simple#TID:1#TVER:0#SCODE:I0078#VTYPE:V")
	if (oper1Desc="") {	s oper1Desc =  ##class(EPRservice.BOScatterData).GetEPRData(argAdmId,"#TYPE:Simple#TID:22#TVER:0#SCODE:I0215#VTYPE:V")}
    s oper1Code = ##Class(web.DHCWMRCodingInterface).getFrontPageICD(argAdmId,"O/1",1)
    s oper1Code = $p($g(oper1Code),$c(2),1)

	s oper2Desc = ##class(EPRservice.BOScatterData).GetEPRData(argAdmId,"#TYPE:Simple#TID:1#TVER:0#SCODE:I0087#VTYPE:V")
	if (oper2Desc="") {	s oper2Desc =  ##class(EPRservice.BOScatterData).GetEPRData(argAdmId,"#TYPE:Simple#TID:22#TVER:0#SCODE:I0214#VTYPE:V")}
	s oper2Code = ##Class(web.DHCWMRCodingInterface).getFrontPageICD(argAdmId,"O/1",2)
    s oper2Code = $p($g(oper2Code),$c(2),1)

	s oper3Desc = ##class(EPRservice.BOScatterData).GetEPRData(argAdmId,"#TYPE:Simple#TID:1#TVER:0#SCODE:I0086#VTYPE:V")
	if (oper3Desc="") {	s oper3Desc =  ##class(EPRservice.BOScatterData).GetEPRData(argAdmId,"#TYPE:Simple#TID:22#TVER:0#SCODE:I0213#VTYPE:V")}
    s oper3Code = ##Class(web.DHCWMRCodingInterface).getFrontPageICD(argAdmId,"O/1",3)
    s oper3Code = $p($g(oper3Code),$c(2),1)

	s oper4Desc = ##class(EPRservice.BOScatterData).GetEPRData(argAdmId,"#TYPE:Simple#TID:1#TVER:0#SCODE:I0085#VTYPE:V")
	if (oper4Desc="") {	s oper4Desc =  ##class(EPRservice.BOScatterData).GetEPRData(argAdmId,"#TYPE:Simple#TID:22#TVER:0#SCODE:I0212#VTYPE:V")}
    s oper4Code = ##Class(web.DHCWMRCodingInterface).getFrontPageICD(argAdmId,"O/1",4)
    s oper4Code = $p($g(oper4Code),$c(2),1)
	
	s result = mainDiagDesc_"^"_mainDiagCode_"^"_mainDiagOut_"^"_oper1Desc_"^"_oper1Code_"^"_oper2Desc_"^"_oper2Code_"^"_oper3Desc_"^"_oper3Code_"^"_oper4Desc_"^"_oper4Code
	Quit result
}

/// ////////////////////////////////////////////////////////////////////////////////////////////////
/// Creator：	EPR
/// CreateDate：2012-04-05
/// Desc：		取患者前次就诊病历信息[HIS]-05
/// Input:		Adm: 就诊rowid
/// Return：
/// Test:		##Class(EPRservice.SystemData).testcheck(Adm)		
Query GetBFEPRInfo(Adm As %String) As %Query(ROWSPEC = "InSts,DiagAndCure,PatSts")
{
}

ClassMethod GetBFEPRInfoExecute(ByRef qHandle As %Binary, Adm As %String) As %Status
{
	//b "s"
	Set repid=$I(^CacheTemp)
	s ind=1
	Set qHandle=$lb(0,repid,0)

	Quit:($d(^PAADM(Adm))=0)||(Adm="") $$$OK

	
    //取系统参数
	s Hospital=##class(EPRmeta.SysOption).GetOptionValueByName("HospitalName")
  	s SpaceHIS=##class(EPRmeta.SysOption).GetOptionValueByName("NameSpaceHIS")
	if SpaceHIS'=""
	{
		s MEDDATA = $p($g(SpaceHIS),"^",1)
		s WEBSRC  = $p($g(SpaceHIS),"^",2)
	}
	s SpaceLIS=##class(EPRmeta.SysOption).GetOptionValueByName("NameSpaceLIS")
	if SpaceLIS'=""
	{
	    s LABDATA = $p($g(SpaceLIS),"^",1)
	    s LABSRC  = $p($g(SpaceLIS),"^",2)
	 }
	 Quit:((Hospital="")||(SpaceHIS="")||(SpaceLIS="")) $$$OK
	 s BFAdmID=""
	 //出院记录-入院情况,诊治经过,目前病情
	 s InSts="",DiagAndCure="",PatSts=""
	 s InstsUnit="#TYPE:TextDesc#TID:7#TVER:0#ECODE:E0043"
	 s DiagAndCureUnit="#TYPE:TextDesc#TID:7#TVER:0#ECODE:E0045"
	 s PatStsUnit="#TYPE:TextDesc#TID:7#TVER:0#ECODE:E0044"
	 s BFAdmID=##class(EPRservice.HISInterface.PatientInfoAssist).GetBFAdmID(Adm)
	 if (BFAdmID'="")
	 { 
	 	s InSts=##class(EPRservice.BOScatterData).GetEPRData(BFAdmID, InstsUnit)
	 	s DiagAndCure=##class(EPRservice.BOScatterData).GetEPRData(BFAdmID, DiagAndCureUnit)
	 	s PatSts=##class(EPRservice.BOScatterData).GetEPRData(BFAdmID, PatStsUnit)
	 }
	

	// 初始化返回值
	

	set ^CacheTemp(repid, ind) = $LB(InSts,DiagAndCure,PatSts)
	set ind = ind + 1
	
	Quit $$$OK
}

ClassMethod GetBFEPRInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetBFEPRInfoExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetBFEPRInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetBFEPRInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
	Quit $$$OK
}

/// *****************************************************************
/// **                                                             **
/// **                测试   代码   段落   Begin                   **
/// **                                                             **
/// *****************************************************************
/// ##Class(EPRservice.SystemData).testpat(Adm)
ClassMethod testpat(Adm)
{
	 // Create a Result object for the Sample.Person:ByName query
	 Set rset = ##class(%ResultSet).%New("EPRservice.SystemData:GetPatientInfo")
	 Set columns = rset.GetColumnCount()
	
	 // Execute the query
	 Set sc = rset.Execute(Adm)
	
	 // Now fetch the results
	 While (rset.Next()) {
	 Write "------------------------",!
	 For col = 1:1:columns {
	 Write rset.GetColumnName(col),": "
	 Write rset.GetData(col),!
	 }
	 Write "------------------------"
	 }
	 Do rset.Close()
}

/// ##Class(EPRservice.SystemData).testcliord(Adm)
ClassMethod testcliord(Adm)
{
	 // Create a Result object for the Sample.Person:ByName query
	 Set rset = ##class(%ResultSet).%New("EPRservice.SystemData:GetClinicOrdersInfo")
	 Set columns = rset.GetColumnCount()
	
	 // Execute the query
	 Set sc = rset.Execute(Adm)
	
	 // Now fetch the results
	 While (rset.Next()) {
	 Write "------------------------",!
	 For col = 1:1:columns {
	 Write rset.GetColumnName(col),": "
	 Write rset.GetData(col),!
	 }
	 Write "------------------------"
	 }
	 Do rset.Close()
}

/// ##Class(EPRservice.SystemData).testclidiag(Adm)
ClassMethod testclidiag(Adm)
{
	 // Create a Result object for the Sample.Person:ByName query
	 Set rset = ##class(%ResultSet).%New("EPRservice.SystemData:GetClinicDiagInfo")
	 Set columns = rset.GetColumnCount()
	
	 // Execute the query
	 Set sc = rset.Execute(Adm)
	
	 // Now fetch the results
	 While (rset.Next()) {
	 Write "------------------------",!
	 For col = 1:1:columns {
	 Write rset.GetColumnName(col),": "
	 Write rset.GetData(col),!
	 }
	 Write "------------------------"
	 }
	 Do rset.Close()
}

/// ##Class(EPRservice.SystemData).testatd(Adm)
ClassMethod testatd(Adm)
{
	// Create a Result object for the Sample.Person:ByName query
	Set rset = ##class(%ResultSet).%New("EPRservice.SystemData:GetATDInfo")
	Set columns = rset.GetColumnCount()

	// Execute the query
	Set sc = rset.Execute(Adm)

	// Now fetch the results
	While (rset.Next()) {
	Write "------------------------",!
	For col = 1:1:columns {
	Write rset.GetColumnName(col),": "
	Write rset.GetData(col),!
	}
	Write "------------------------"
	}
	Do rset.Close()
}

/// ##Class(EPRservice.SystemData).testtmc(Adm)
ClassMethod testtmc(Adm)
{
	// Create a Result object for the Sample.Person:ByName query
 Set rset = ##class(%ResultSet).%New("EPRservice.SystemData:GetTMCFeeInfo")
 Set columns = rset.GetColumnCount()

 // Execute the query
 Set sc = rset.Execute(Adm)

 // Now fetch the results
 While (rset.Next()) {
 Write "------------------------",!
 For col = 1:1:columns {
 Write rset.GetColumnName(col),": "
 Write rset.GetData(col),!
 }
 Write "------------------------"
 }
 Do rset.Close()
}

/// ##Class(EPRservice.SystemData).testmc(Adm)
ClassMethod testmc(Adm)
{
	// Create a Result object for the Sample.Person:ByName query
 Set rset = ##class(%ResultSet).%New("EPRservice.SystemData:GetMCFeeInfo")
 Set columns = rset.GetColumnCount()

 // Execute the query
 Set sc = rset.Execute(Adm)

 // Now fetch the results
 While (rset.Next()) {
 Write "------------------------",!
 For col = 1:1:columns {
 Write rset.GetColumnName(col),": "
 Write rset.GetData(col),!
 }
 Write "------------------------"
 }
 Do rset.Close()
}

/// ##Class(EPRservice.SystemData).testcus(Adm)
ClassMethod testcus(Adm)
{
	// Create a Result object for the Sample.Person:ByName query
 Set rset = ##class(%ResultSet).%New("EPRservice.SystemData:GetCustomInfo")
 Set columns = rset.GetColumnCount()

 // Execute the query
 Set sc = rset.Execute(Adm)

 // Now fetch the results
 While (rset.Next()) {
 Write "------------------------",!
 For col = 1:1:columns {
 Write rset.GetColumnName(col),": "
 Write rset.GetData(col),!
 }
 Write "------------------------"
 }
 Do rset.Close()
}

/// ##Class(EPRservice.SystemData).testcase(Adm)
ClassMethod testcase(Adm)
{
	// Create a Result object for the Sample.Person:ByName query
 Set rset = ##class(%ResultSet).%New("EPRservice.SystemData:GetCaseRecordNoInfo")
 Set columns = rset.GetColumnCount()

 // Execute the query
 Set sc = rset.Execute(Adm)

 // Now fetch the results
 While (rset.Next()) {
 Write "------------------------",!
 For col = 1:1:columns {
 Write rset.GetColumnName(col),": "
 Write rset.GetData(col),!
 }
 Write "------------------------"
 }
 Do rset.Close()
}

/// ##Class(EPRservice.SystemData).testwmr(Adm)
ClassMethod testwmr(Adm)
{
	// Create a Result object for the Sample.Person:ByName query
 Set rset = ##class(%ResultSet).%New("EPRservice.SystemData:GetWMRInterface")
 Set columns = rset.GetColumnCount()

 // Execute the query
 Set sc = rset.Execute(Adm)

 // Now fetch the results
 While (rset.Next()) {
 Write "------------------------",!
 For col = 1:1:columns {
 Write rset.GetColumnName(col),": "
 Write rset.GetData(col),!
 }
 Write "------------------------"
 }
 Do rset.Close()
}

/// ##Class(EPRservice.SystemData).testlab(Adm)
ClassMethod testlab(Adm)
{
	// Create a Result object for the Sample.Person:ByName query
 Set rset = ##class(%ResultSet).%New("EPRservice.SystemData:GetLabInfo")
 Set columns = rset.GetColumnCount()

 // Execute the query
 Set sc = rset.Execute(Adm)

 // Now fetch the results
 While (rset.Next()) {
 Write "------------------------",!
 For col = 1:1:columns {
 Write rset.GetColumnName(col),": "
 Write rset.GetData(col),!
 }
 Write "------------------------"
 }
 Do rset.Close()
}

/// ##Class(EPRservice.SystemData).testcheck(Adm)
ClassMethod testcheck(Adm)
{
	// Create a Result object for the Sample.Person:ByName query
 Set rset = ##class(%ResultSet).%New("EPRservice.SystemData:GetCheckInfo")
 Set columns = rset.GetColumnCount()

 // Execute the query
 Set sc = rset.Execute(Adm)

 // Now fetch the results
 While (rset.Next()) {
 Write "------------------------",!
 For col = 1:1:columns {
 Write rset.GetColumnName(col),": "
 Write rset.GetData(col),!
 }
 Write "------------------------"
 }
 Do rset.Close()
}

/// ##Class(EPRservice.SystemData).testinstance(Adm,CID)
ClassMethod testinstance(Adm As %String, CID As %String)
{
	// Create a Result object for the Sample.Person:ByName query
 Set rset = ##class(%ResultSet).%New("EPRservice.SystemData:GetOtherInstanceDataInfo")
 Set columns = rset.GetColumnCount()

 // Execute the query
 Set sc = rset.Execute(Adm,CID)

 // Now fetch the results
 While (rset.Next()) {
 Write "------------------------",!
 For col = 1:1:columns {
 Write rset.GetColumnName(col),": "
 Write rset.GetData(col),!
 }
 Write "------------------------"
 }
 Do rset.Close()
}

/// w ##Class(EPRservice.SystemData).testuserinfo(userId)
ClassMethod testuserinfo(userId As %String)
{
	// Create a Result object for the Sample.Person:ByName query
 Set rset = ##class(%ResultSet).%New("EPRservice.SystemData:GetUserInfo")
 Set columns = rset.GetColumnCount()

 // Execute the query
 Set sc = rset.Execute(userId)

 // Now fetch the results
 While (rset.Next()) {
 Write "------------------------",!
 For col = 1:1:columns {
 Write rset.GetColumnName(col),": "
 Write rset.GetData(col),!
 }
 Write "------------------------"
 }
 Do rset.Close()
}

/// ##Class(EPRservice.SystemData).testbook(Adm)
ClassMethod testbook(Adm)
{
	// Create a Result object for the Sample.Person:ByName query
 Set rset = ##class(%ResultSet).%New("EPRservice.SystemData:GetIPBookInfo")
 Set columns = rset.GetColumnCount()

 // Execute the query
 Set sc = rset.Execute(Adm)

 // Now fetch the results
 While (rset.Next()) {
 Write "------------------------",!
 For col = 1:1:columns {
 Write rset.GetColumnName(col),": "
 Write rset.GetData(col),!
 }
 Write "------------------------"
 }
 Do rset.Close()
}

///            *****************************************************************
///            **                                                             **
///            **                测试   代码   段落   Close                   **
///            **                                                             **
///            *****************************************************************

}
