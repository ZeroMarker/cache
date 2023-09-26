/// 名称:EMRservice.SystemData
/// 描述:个性化类,取HIS以及EMR相关数据
/// 编写者：Guozongtao
/// 编写日期: 2014-01-03
Class EMRservice.SystemData Extends %RegisteredObject
{

/// ------------------------已标准化返回值格式的类Start------------------------
/// ////////////////////////////////////////////////////////////////////////////////////////////////
/// Creator：	EPR
/// CreateDate：2009-03-16
/// Desc：		取患者基本信息[HIS]-01 200908OK
/// Input:		Adm: 就诊rowid
/// Return：
/// Test:		do ##class(%ResultSet).RunQuery("EMRservice.SystemData","GetPatientInfo","3691348")	
/// d ##class(%ResultSet).RunQuery("EMRservice.SystemData","GetPatientInfo","4065909")	
Query GetPatientInfo(Adm As %String) As %Query(ROWSPEC = "EpisodeID,PapmiDR,EpisodeNo,RegisterNo,IPRecordNo,OPRecordNo,EPRecordNo,InsuranceNo,IDCard,CardType,CardNumber,Name,Gender,GenderMono,GenderDict,GenderDesc,Birthday,Age,RecordAge,RecordAgeUnit,ClinicAge,BabyAge,MarriageDesc,MarriageDict,MarriageMono,Native,BlockBirthDict,CityBirthDict,ProvinceBirthDict,BlockBirthDesc,CityBirthDesc,ProvinceBirthDesc,OccupationDict,OccupationDesc,NationDict,NationDesc,CountryDict,CountryDesc,PayMode,PayTypeMono,PayTypeDict,MobilePhone,LinkName,LinkRelationDict,LinkRelationDesc,LinkAddress,LinkPhone,WorkAddress,WorkTel,WorkPostCode,HuKouAddress,HuKouTel,HuKouPostCode,curProvinceDict,curCityDict,curBlockDict,curStreet,CurAddress,HukouProvinceDict,HuKouCityDict,HuKouBlockDict,HuKouStreet,CurAddrPostCode,ProvinceNativeDict,CityNativeDict,InScore,OutScore,CardTypeMono,CardTypeDict,IsRepeat")
{
}

ClassMethod GetPatientInfoExecute(ByRef qHandle As %Binary, Adm As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	Set qHandle=$lb(0,repid,0)


	Quit:($d(^PAADM(Adm))=0)||(Adm="") $$$OK
	// 取系统参数
	s Hospital=##class(EMRservice.BL.BLSysOption).GetOptionValueByName("HospitalName")
  	s SpaceHIS=##class(EMRservice.BL.BLSysOption).GetOptionValueByName("NameSpaceHIS")
	if SpaceHIS'=""
	{
		s MEDDATA = $p($g(SpaceHIS),"^",1)
		s WEBSRC  = $p($g(SpaceHIS),"^",2)
	}
	s SpaceLIS=##class(EMRservice.BL.BLSysOption).GetOptionValueByName("NameSpaceLIS")
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
	s Name="" ,Gender="" ,GenderDict="" ,Birthday="" ,ArgBirthday="" ,Age="" ,RecordAge="" ,RecordAgeUnit="" ,ClinicAge="" ,BabyAge="" ,Marriage="" ,MarriageDesc="",MarriageDict="",Native="" ,CityBirth="" ,ProvinceBirth="" ,CityBirthDesc="" ,ProvinceBirthDesc="" ,Occupation="" ,Nation="" ,Country="" ,PayMode="" ,MobilePhone="",OccupationDesc="", NationDesc="", CountryDesc=""
	
	// 工作情况/户口情况/联系人情况大类
	s LinkName="" ,LinkRelation="" ,LinkRelationDesc="",LinkAddress="" ,LinkPhone="" ,WorkAddress="" ,WorkTel="" ,WorkPostCode="" ,HuKouAddress="" ,HuKouTel="" ,HuKouPostCode=""	
	
	s tmpRecordAge="" ,tmpNative="" ,tmpBirthPlace="" ,tmpOccupation="" ,tmpNation="" ,tmpCountry="" ,tmpLinkRelation=""

	s CardTypeDict="", CardTypeMono="",CardType=""
 	///////////////////////
 	// 患者标识号码大类  //
 	///////////////////////

 	// 标识号			[EpisodeID]			PA_Adm.PAAdm_RowID
 	s EpisodeID=Adm
 	 
 	// 登记RowId		[PapmiDR]			PA_Person.PAPER_RowId And PA_PatMas.PAPMI_PAPER_DR
 	s PapmiDR = ##Class(EMRservice.HISInterface.PatientInfoAssist).GetPapmiDR(Adm)
 	
 	// 就诊号			[EpisodeNo]			PA_Adm.PAADM_ADMNo
 	s EpisodeNo=##Class(EMRservice.HISInterface.PatientInfoAssist).GetEpisodeNo(Adm)
 	
 	// 登记号			[RegisterNo]		PA_PatMas.PAPMI_No
 	s RegisterNo = ##Class(EMRservice.HISInterface.PatientInfoAssist).GetPapmiNo(PapmiDR)
 	
 	// 住院病案号		[IPRecordNo]		PA_PatMas.PAPMI_Medicare
 	s IPRecordNo = ##class(EMRservice.HISInterface.PatientInfoAssist).GetMRNoByEpisodeID(Adm)
 	//s IPRecordNo=""
 	
 	// 门诊病案号		[OPRecordNo]		PA_Person.PAPER_GovernCardNo
 	s OPRecordNo = ##class(EMRservice.HISInterface.PatientInfoAssist).GetMRNoByEpisodeID(Adm)
 	
 	// 急诊病案号		[EPRecordNo]		DHC_Person.PAPER_FCMedicareCode1
 	s EPRecordNo = ##class(EMRservice.HISInterface.PatientInfoAssist).GetMRNoByEpisodeID(Adm)
 	
 	//依据患者类型，返回病案号
 	s AdmType=$p(^PAADM(Adm),"^",2)
 	
 	s IPRecordNo=$case(AdmType,"I":IPRecordNo,"O":OPRecordNo,"E":EPRecordNo)
 	
 	// 医保号			[InsuranceNo]		PA_Person.PAPER_ID
 	s InsuranceNo=##Class(EMRservice.HISInterface.PatientInfoAssist).InsuranceNo(Adm,Hospital)
 	s:(InsuranceNo="") InsuranceNo="-"
 	
	// 身份证号			[IDCard]			PA_Person.PAPER_ID
 	s IDCard=##Class(EMRservice.HISInterface.PatientInfoAssist).IDCard(PapmiDR)

	// 证件类型			[CardType]			PA_PatMas.PAPMI_CardType_DR -> PAC_CardType.CARD_Desc
 	s CardTypeDict=##Class(EMRservice.HISInterface.PatientInfoAssist).CardType(PapmiDR)
 	i (CardTypeDict="") { s CardType ="身份证" }
 	i (CardTypeDict '="")
 	{
	 	s CardTypeMono=$p(CardTypeDict,"^",2,3)
 	}
	// 证件号码			[CardNumber]		PA_PatMas.PAPMI_DVAnumber
 	s CardNumber=##Class(EMRservice.HISInterface.PatientInfoAssist).CardNumber(PapmiDR)
 	i (CardType="身份证")||(CardType="") { s CardNumber =IDCard }

 
 	///////////////////////
 	// 患者基本情况大类  //
 	///////////////////////
 	
 	// 姓名				[Name]				PA_Person.PAPER_Name
 	s Name=##Class(EMRservice.HISInterface.PatientInfoAssist).Name(PapmiDR)
 	
 	// 性别				[Gender]			PA_Person.PAPER_Sex_DR
 	s Gender=##Class(EMRservice.HISInterface.PatientInfoAssist).Gender(PapmiDR,Hospital)
 	i Gender'="" {s GenderDict = Gender}
 	i Gender'="" {
	 	s GenderCode= $p($g(Gender),"^",2)
	 	//医院性别代码 部分是 F、M 有的是 1、2 根据情况进行兼容，如果是FM，自动转换成数字，否则直接取code值
	 	//代码转换对照住院病案首页，病例中其他性别，尽可能用字典单元
	 	s GenderCode=$s(GenderCode="F":2,GenderCode="M":1,1:$p($g(Gender),"^",2))
	 	s GenderMono = GenderCode_"^"_$p($g(Gender),"^",3)
	 	
	 	}
 	i Gender'="" {s GenderDesc = $p($g(Gender),"^",3)}
 	i Gender'="" {s Gender = $p($g(Gender),"^",3)}
 	
 	// 出生日期			[Birthday]			PA_Person.PAPER_Dob
 	s Birthday=##Class(EMRservice.HISInterface.PatientInfoAssist).Birthday(PapmiDR)
 	if Birthday'=""
 	{
   		// 出生日期内部格式 PA_Person.PAPER_Dob 
   		s ArgBirthday=Birthday
   		// 出生日期外部格式 PA_Person.PAPER_Dob
   		s Birthday=$zd(Birthday,3)
 	}
 	
	// (用以计算年龄)入院日期时间	[AdmDateTime]		PAAdm_AdmDate And PAAdm_AdmTime 
	s AdmDate = "", AdmTime = ""
	s AdmDateTime=##class(EMRservice.HISInterface.PatientInfoAssist).AdmDateTime(Adm,Hospital)
	if AdmDateTime'="" 
	{ 
		   // 入院日期内部格式
		   s AdmDate = $P($G(AdmDateTime),",",1)
		   // 入院时间内部格式 
		   s AdmTime = $P($G(AdmDateTime),",",2)
	}
	  
   	//调用年龄统一接口 [Age]
   	s Age=##class(EMRservice.HISInterface.PatientInfoAssist).Age(PapmiDR,Adm,AdmDate,AdmTime)
    
   	//调用年龄统一接口			[RecordAge][RecordAgeUnit]
   	s tmpRecordAge =##class(EMRservice.HISInterface.PatientInfoAssist).Age(PapmiDR,Adm,AdmDate,AdmTime)
   	s RecordAge = $e(tmpRecordAge,1,$l(tmpRecordAge)-$l($zstrip(tmpRecordAge,"*N")))
    s RecordAgeUnit = $e(tmpRecordAge,$l(tmpRecordAge)-$l($zstrip(tmpRecordAge,"*N"))+1,$l(tmpRecordAge))
    
    //调用年龄统一接口	[ClinicAge]
   	s ClinicAge = ##class(EMRservice.HISInterface.PatientInfoAssist).Age(PapmiDR,Adm,AdmDate,AdmTime)
   	// 新生儿年龄 N天			[BabyAge]
 	s BabyAge =##class(EMRservice.HISInterface.PatientInfoAssist).Age(PapmiDR,Adm,AdmDate,AdmTime)
 	// 婚姻状况			[Marriage]			PA_Person.PAPER_Marital_DR ->
 	s Marriage=##Class(EMRservice.HISInterface.PatientInfoAssist).Marriage(PapmiDR)
 	if Marriage'=""
 	{
	 	s MarriageDesc= $p($g(Marriage),"^",3)
	 	s MarriageDict=Marriage
	 	s MarriageMono=$e($p($g(Marriage),"^",2),1,1)_"^"_$p($g(Marriage),"^",3)
	}
 	
 	// 籍贯				[Native]			PA_Person.PAPER_Province_Birth_DR And PA_Person.PAPER_CityBirth_DR
 	// 城市				[CityBirth]			PA_Person.PAPER_CityBirth_DR ->
 	// 省份				[ProvinceBirth]		PA_Person.PAPER_Province_Birth_DR ->
 	// ProvinceDR_"^"_ProvinceCode_"^"_ProvinceDesc_"!"_CityDR_"^"_CityCode_"^"_CityDesc
 	s tmpNative=##Class(EMRservice.HISInterface.PatientInfoAssist).Native(PapmiDR,Hospital)
 	s tmpBirthPlace=##Class(EMRservice.HISInterface.PatientInfoAssist).BirthPlaceNew(PapmiDR)
 	//现住址
 	s tmpcuraddr=##Class(EMRservice.HISInterface.PatientInfoAssist).ResidentAddressNew(PapmiDR,Hospital)
 	s tmpcuraddr=$tr(tmpcuraddr,"\","")
 	//户口地址
 	s tmpHuKou=##Class(EMRservice.HISInterface.PatientInfoAssist).HuKouAddressNew(PapmiDR,Hospital)
 	s tmpHuKou=$tr(tmpHuKou,"\","")
 	s tmpCityNative="",CityNative="",ProvinceNative="",CityNativeDesc="",ProvinceNativeDesc=""
 	i tmpNative'=""
 	{   
 		// 籍贯城市 
   		s tmpCityNative = $p($g(tmpNative),"!",2)
   		s CityNativeDict=tmpCityNative 
   		s CityNativeDesc = $p(tmpCityNative,"^",3)
 
   		// 籍贯省份 
   		s tmpProvinceNative = $p($g(tmpNative),"!",1)
        s ProvinceNativeDict=tmpProvinceNative
   		s ProvinceNativeDesc = $p(tmpProvinceNative,"^",3)

   		// 籍贯
   		s Native = $p($g(tmpProvinceNative),"^",3)
 	}
 	s curProvince="",curCity="",curBlock="",curStreet=""
 	i tmpcuraddr'=""
 	{
 		// 现住址城市 
   		s tmpcurCity = $p($g(tmpcuraddr),"!",2)
   		s curCityDict = tmpcurCity
   		s curCityDesc = $p(curCity,"^",3)
 
   		// 现住址省份 
   		s tmpcurProvince = $p($g(tmpcuraddr),"!",1)
   		s curProvinceDict = tmpcurProvince
   		s curProvinceDesc = $p(tmpcurProvince,"^",3)
   		
   		// 现住址区县 
   		s tmpcurBlock = $p($g(tmpcuraddr),"!",3)
   		s curBlockDict = tmpcurBlock
   		s curBlockDesc = $p(curBlockDict,"^",3)
   		
		s curStreet= $p($g(tmpcuraddr),"!",4)

   		// 现住址
   		// 20180312 标准地址存储，目前填写的现住址返回完整的数据。
   		// 依据项目实际情况调整返回值。lifb
   		if (curStreet="")
   		{
   			s CurAddress = $p($g(tmpcurProvince),"^",3)_$p($g(tmpcurCity),"^",3)_$p($g(tmpcurBlock),"^",3)
   		}
   		elseif((curStreet [ $p($g(tmpcurProvince),"^",3) )&&(curStreet [ $p($g(tmpcurCity),"^",3)))
   		{
   			s CurAddress = curStreet
   		}
   		else
 		{
	 		s CurAddress = $p($g(tmpcurProvince),"^",3)_$p($g(tmpcurCity),"^",3)_$p($g(tmpcurBlock),"^",3)_curStreet
	 	}
 		
 	}
 	
 	//协和户口地址
 	s HukouProvince="",HuKouCity="",HuKouBlock="",HuKouStreet="",HuKouaddr=""
 	i tmpHuKou'=""
 	{
 		// 户口地址城市 
   		s tmpHuKouCity = $p($g(tmpHuKou),"!",2)
   		s HuKouCityDict =tmpHuKouCity
   		s HuKouCityDesc =$p(HuKouCityDict,"^",3)
 
   		// 户口地址省份 
   		s tmpHukouProvince = $p($g(tmpHuKou),"!",1)
   		s HukouProvinceDict = tmpHukouProvince
   		s HukouProvinceDesc = $p(HukouProvinceDict,"^",3)
   		
   		
   		// 户口地址区县 
   		s tmpHuKouBlock = $p($g(tmpHuKou),"!",3)
   		s HuKouBlockDict = tmpHuKouBlock
   		s HuKouBlockDesc = $p(HuKouBlockDict,"^",3)
   		
   		s HuKouStreet= $p($g(tmpHuKou),"!",4)

   		// 户口地址
   		s HuKouaddr = $p($g(tmpHukouProvince),"^",3)_$p($g(tmpHuKouCity),"^",3)_$p($g(tmpHuKouBlock),"^",3)_HuKouStreet
 	}
 	
 	
 	s ProvinceBirth="",CityBirth="",CityBirth="",BirthPlace=""
 	if tmpBirthPlace'=""
 	{
	 	// 出生地省份 
   		s tmpProvinceBirth = $p($g(tmpBirthPlace),"!",1)
   		s ProvinceBirthDict = tmpProvinceBirth
   		s ProvinceBirthDesc = $p(ProvinceBirthDict,"^",3)
   		
 		// 出生地城市 
   		s tmpCityBirth = $p($g(tmpBirthPlace),"!",2)
   		s CityBirthDict =tmpCityBirth
   		s CityBirthDesc = $p(CityBirthDict,"^",3)
 
 		// 出生地区县 
   		s tmpBlockBirth = $p($g(tmpBirthPlace),"!",3)
   		s BlockBirthDict = tmpBlockBirth
   		s BlockBirthDesc = $p(BlockBirthDict,"^",3)   
   		
   		//完整出生地
   		s BirthPlace=$p($g(tmpProvinceBirth),"^",3)_$p($g(tmpCityBirth),"^",3)_$p($g(tmpBlockBirth),"^",3)	
   		
   		// 特殊处理住院登记无籍贯 故同出生地
 		;s:(Native="") Native = $p($g(tmpProvinceBirth),"^",3)_$p($g(tmpCityBirth),"^",3)

 	}
 	
 	
 	// 职业				[Occupation]		PA_Person.PAPER_Occupation_DR ->
 	// 职业描述			[OccupationDesc]
 	s OccupationDict=""	,OccupationDesc=""
 	s tmpOccupation=##Class(EMRservice.HISInterface.PatientInfoAssist).Occupation(PapmiDR,Hospital)
 	i tmpOccupation'=""
 	{
   		s OccupationDesc = $p($g(tmpOccupation),"^",3)
                s OccupationDict=tmpOccupation
 	}
	
	// 民族				[Nation]			PA_Person.PAPER_Nation_DR -> SQLUser.CT_Nation
	// 民族				[NationDesc]			
	s tmpNation=##Class(EMRservice.HISInterface.PatientInfoAssist).Nation(PapmiDR,Hospital)
	i tmpNation'=""
 	{	
   		s NationDict =tmpNation
   		s NationDesc = $p($g(tmpNation),"^",3)
 	}
		 
	// 国籍				[Country]			PA_Person.PAPER_Country_DR
	// 国籍				[CountryDesc]			
	s tmpCountry=##Class(EMRservice.HISInterface.PatientInfoAssist).Country(PapmiDR,Hospital)
	i tmpCountry'=""
 	{
   		s CountryDict = tmpCountry
   		s CountryDesc = $p($g(tmpCountry),"^",3)
   		
 	}
		
	// 病人类型			[PayType]			PAAdm_AdmReason_DR -> 
	s PayType1=##Class(EMRservice.HISInterface.PatientInfoAssist).PayType(Adm)
	s PayType=##Class(EMRservice.HISInterface.PatientInfoAssist).ConvertPayType(PayType1)
	s PayTypeDict=##Class(EMRservice.HISInterface.PatientInfoAssist).ConvertPayTypeDict(PayType1)
	
	
	// 医疗付款方式		[PayMode]			病案首页与病人类型对照
	s PayMode=##Class(EMRservice.HISInterface.PatientInfoAssist).PayModeLink(Adm,Hospital)
	
	
	s EmerPayMode=##Class(EMRservice.HISInterface.PatientInfoAssist).ConvertPayMode(PayType)


	// 手机				[MobilePhone]		PA_Person.PAPER_MobPhone
	s MobilePhone=##Class(EMRservice.HISInterface.PatientInfoAssist).MobilePhone(PapmiDR,Hospital)
	 
	 

 	///////////////////////////////////////////
 	// 患者联系人情况/工作情况/户口情况大类  //
 	///////////////////////////////////////////
 	
 	
 	// 联系人姓名		[LinkName]			PA_Person.PAPER_ForeignId
 	s LinkName = ##class(EMRservice.HISInterface.PatientInfoAssist).LinkmanName(PapmiDR,Hospital)
 
 	// 联系人关系		[LinkRelation]		PA_Person.PAPER_CTRLT_DR -> SQLUser.CT_Relation
 	s tmpLinkRelation = ##class(EMRservice.HISInterface.PatientInfoAssist).LinkmanRelation(PapmiDR,Hospital)
 	i tmpLinkRelation'=""
 	{       
   		//s LinkRelation = $p($g(tmpLinkRelation),"^",2)
   		i ($p($g(tmpLinkRelation),"^",3)["-") 
   		{
	   		s LinkRelationDict = $p($g(tmpLinkRelation),"^",1,2)_"^"_$p($p($g(tmpLinkRelation),"^",3),"-",2)
   			s LinkRelationDesc=$p($p($g(tmpLinkRelation),"^",3),"-",2)
   		}
   		else
   		{
	   		s LinkRelationDict = tmpLinkRelation 
	   		s LinkRelationDesc=$p($g(tmpLinkRelation),"^",3)
   		}
 	}
 	
 	// 联系人地址		[LinkAddress]		PA_Person.PAPER_ForeignAddress
 	s LinkAddress = ##class(EMRservice.HISInterface.PatientInfoAssist).LinkmanAddress(PapmiDR,Hospital)
 	s LinkAddress=$tr(LinkAddress,"\","")
 	// 联系人电话		[LinkPhone]			PA_Person.PAPER_ForeignPhone
 	s LinkPhone = ##class(EMRservice.HISInterface.PatientInfoAssist).LinkmanPhone(PapmiDR,Hospital)

 	// 工作单位地址		[WorkAddress]		PA_Person.PAPER_SecondPhone
 	s WorkAddress=##Class(EMRservice.HISInterface.PatientInfoAssist).WorkAddress(PapmiDR,Hospital)
 
 	// 工作电话			[WorkTel]			PA_Person.PAPER_TelO
 	// 如果工作电话为空  赋值手机
 	s WorkTel=##Class(EMRservice.HISInterface.PatientInfoAssist).WorkPhone(PapmiDR,Hospital)
 	i WorkTel=""
 	{
	 	s WorkTel = MobilePhone
 	}
 
 	// 工作邮编			[WorkPostCode]		DHC_Person.PAPER_Comment2
 	s WorkPostCode=##Class(EMRservice.HISInterface.PatientInfoAssist).WorkPostCode(PapmiDR,Hospital)

 	// 户口所在地址		[HuKouAddress]		PA_Person.PAPER_StName
 	s HuKouAddress=##Class(EMRservice.HISInterface.PatientInfoAssist).HuKouAddress(PapmiDR,Hospital)
	s HuKouAddress=$tr(HuKouAddress,"\","")
	
	// 户口电话			[HuKouTel]			PA_Person.PAPER_TelH
	s HuKouTel=##Class(EMRservice.HISInterface.PatientInfoAssist).HuKouPhone(PapmiDR,Hospital)
	
	// 户口邮编			[HuKouPostCode]		DHC_Person.PAPER_Comment1
	s HuKouPostCode=##Class(EMRservice.HISInterface.PatientInfoAssist).HuKouPostCode(PapmiDR,Hospital)
	//现住址邮编
	s CurAddrPostCode=##Class(EMRservice.HISInterface.PatientInfoAssist).ResidentPostCodeNew(PapmiDR,Hospital)
	
	//Add by Liaowp 2012-1-15
	//患者入出院生活能力评分
	s ScoreStr="",InScore="",OutScore=""
	s ScoreStr=##class(EPRservice.HISInterface.PatientInfoAssist).PatSelfCareDegree(Adm)
	s InScore=$P(ScoreStr,"^",1)
	s OutScore=$P(ScoreStr,"^",2)
	
	/*
	s GenderDict=##class(EMRservice.HISInterface.PatientInfoAssist).GetWSCodeDict(GenderDict,"GB/T 2261.1")
    s MarriageDict=##class(EMRservice.HISInterface.PatientInfoAssist).GetWSCodeDict(MarriageDict,"GB/T 2261.2")
    s OccupationDict=##class(EMRservice.HISInterface.PatientInfoAssist).GetWSCodeDict(OccupationDict,"GB/T 2261.4")
    s NationDict=##class(EMRservice.HISInterface.PatientInfoAssist).GetWSCodeDict(NationDict,"GB/T 3304")
    s CountryDict=##class(EMRservice.HISInterface.PatientInfoAssist).GetWSCodeDict(CountryDict,"GB/T 2659")
	s LinkRelationDict=##class(EMRservice.HISInterface.PatientInfoAssist).GetWSCodeDict(CountryDict,"GB/T 4761")
	*/	
	s IsRepeat="^"
	s IsRepeat = ##class(EMRservice.HISInterface.PatientInfoAssist).IsRepeatAdm(PapmiDR,Adm)
	set ^CacheTemp(repid, ind) = $LB(EpisodeID,PapmiDR,EpisodeNo,RegisterNo,IPRecordNo,OPRecordNo,EPRecordNo,InsuranceNo,IDCard,CardType,CardNumber,Name,Gender,GenderMono,GenderDict,GenderDesc,Birthday,Age,RecordAge,RecordAgeUnit,ClinicAge,BabyAge,MarriageDesc,MarriageDict,MarriageMono,Native,BlockBirthDict,CityBirthDict,ProvinceBirthDict,BlockBirthDesc,CityBirthDesc,ProvinceBirthDesc,OccupationDict,OccupationDesc,NationDict,NationDesc,CountryDict,CountryDesc,PayMode,PayType,PayTypeDict,MobilePhone,LinkName,LinkRelationDict,LinkRelationDesc,LinkAddress,LinkPhone,WorkAddress,WorkTel,WorkPostCode,HuKouAddress,HuKouTel,HuKouPostCode,curProvinceDict,curCityDict,curBlockDict,curStreet,CurAddress,HukouProvinceDict,HuKouCityDict,HuKouBlockDict,HuKouStreet,CurAddrPostCode,ProvinceNativeDict,CityNativeDict,InScore,OutScore,CardTypeMono,CardTypeDict,IsRepeat)
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
/// Test:		##Class(EMRservice.SystemData).testcliord(3691348)
/// d ##class(%ResultSet).RunQuery("EMRservice.SystemData","GetClinicOrdersInfo","1567704")		
Query GetClinicOrdersInfo(Adm As %String) As %Query(ROWSPEC = "EpisodeID,PapmiDR,EpisodeNo,RegisterNo,Name,AdmMasterDict,AdmDoctorDict,AdmNurseDict,Care1,Care2,Care3,Care4,Care5,Care6,CareClass,FoodTreatment,OrdersLabAndCheck,OrdersCaoYao,OrdersXiYao,MedAllergy,OutDrug,CriticallyMono")
{
}

ClassMethod GetClinicOrdersInfoExecute(ByRef qHandle As %Binary, Adm As %String) As %Status
{

	
	Set repid=$I(^CacheTemp)
	s ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:($d(^PAADM(Adm))=0)||(Adm="") $$$OK

	
	// 取系统参数
	s Hospital=##class(EMRservice.BL.BLSysOption).GetOptionValueByName("HospitalName")
  	s SpaceHIS=##class(EMRservice.BL.BLSysOption).GetOptionValueByName("NameSpaceHIS")
	if SpaceHIS'=""
	{
		s MEDDATA = $p($g(SpaceHIS),"^",1)
		s WEBSRC  = $p($g(SpaceHIS),"^",2)
	}
	s SpaceLIS=##class(EMRservice.BL.BLSysOption).GetOptionValueByName("NameSpaceLIS")
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
 	s PapmiDR = ##Class(EMRservice.HISInterface.PatientInfoAssist).GetPapmiDR(Adm)
 	s EpisodeNo=##Class(EMRservice.HISInterface.PatientInfoAssist).GetEpisodeNo(Adm)
 	s RegisterNo = ##Class(EMRservice.HISInterface.PatientInfoAssist).GetPapmiNo(PapmiDR)
	s Name=##Class(EMRservice.HISInterface.PatientInfoAssist).Name(PapmiDR)
	
	// 入院医生 		[AdmDoctor]			PA_Adm.PAAdm_AdmDocCodeDR ->
	s tmpAdmDoctor=##Class(EMRservice.HISInterface.PatientInfoAssist).AdmDoctor(Adm,Hospital)
	i tmpAdmDoctor'=""
 	{
                 s AdmDoctorDict =tmpAdmDoctor

 	}
 	
 	//主管护士
 	s tmpAdmNurse= ##Class(EMRservice.HISInterface.PatientInfoAssist).AdmNurse(Adm,Hospital)
	i tmpAdmNurse'=""
 	{
   		
		 s AdmNurseDict=tmpAdmNurse
 	}
 	s tmpAdmMaster="",AdmMaster=""
 	s tmpAdmMaster= ##Class(EMRservice.HISInterface.PatientInfoAssist).MasterDoctor(Adm,Hospital)
 	i tmpAdmMaster'=""
 	{
   		
		s AdmMasterDict=tmpAdmMaster
 	}
 	
	// Care1^Care2^Care3^Care4^Care5^Care6
	// 一级护理^二级护理^三级护理^特级护理^ICU护理常规^CCU护理常规^
	s caredesc0="特级护理",caredesc1="一级护理",caredesc2="二级护理",caredesc3="三级护理",icudesc="重症监护",ccudesc="CCU护理"
	s Caredays = ##class(EMRservice.HISInterface.PatientInfoAssist).CareDays(Adm,caredesc0,caredesc1,caredesc2,caredesc3,icudesc,ccudesc,Hospital)
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
	s CareClass=##class(EMRservice.HISInterface.PatientInfoAssist).CareClass(Adm,ItmMastDRStr)

	// 当前膳食 ARCIM_ItemCat_DR 为多个时，拼串处理
	s ItemCatDRStr="^111^"
	s FoodTreatment=##class(EMRservice.HISInterface.PatientInfoAssist).HadFoodTreatment(Adm,ItemCatDRStr)

	// 过敏记录[临床组接口]
	s MedAllergy=##class(EMRservice.HISInterface.PatientInfoAssist).EPRGetAllergy(PapmiDR)
	if (MedAllergy'="")
	{
		s MedAllergy=MedAllergy
		//_" "_##class(EMRservice.HISInterface.PatientInfoAssist).MedAllergy(Adm)
	}
	// (用以医嘱取值)入院日期时间		[AdmDateTime]		PAAdm_AdmDate And PAAdm_AdmTime 
		 	s AdmDate = "", AdmTime = ""
		 	s AdmDateTime=##class(EMRservice.HISInterface.PatientInfoAssist).AdmDateTime(Adm,Hospital)
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
		s OrdersLab=##Class(EMRservice.HISInterface.PatientInfoAssist).GetOrders(Adm,AdmDate,$ZD($H,3),"化验","0")
	 		 	
		// 门诊医嘱 检查(放射)
		s OrdersCheck1=##Class(EMRservice.HISInterface.PatientInfoAssist).GetOrders(Adm,AdmDate,$ZD($H,3),"放射检查","0")
	 
		// 门诊医嘱 检查(物理)
		s OrdersCheck2=##Class(EMRservice.HISInterface.PatientInfoAssist).GetOrders(Adm,AdmDate,$ZD($H,3),"物理检查","0")
	 	
		// 门诊医嘱 检查(病理)
		s OrdersCheck3=##Class(EMRservice.HISInterface.PatientInfoAssist).GetOrders(Adm,AdmDate,$ZD($H,3),"病理检查费","0")
		
		// 门诊医嘱 检查(内窥镜)
		s OrdersCheck4=##Class(EMRservice.HISInterface.PatientInfoAssist).GetOrders(Adm,AdmDate,$ZD($H,3),"内窥镜检查","0")
	 	
		s OrdersLabAndCheck=OrdersLab_OrdersCheck1_OrdersCheck2_OrdersCheck3_OrdersCheck4
		i OrdersLabAndCheck'="" { s OrdersLabAndCheck= $e( OrdersLabAndCheck,1,$l(OrdersLabAndCheck)-2) }
		
		// 门诊医嘱 草药处方
		s OrdersCaoYao=##class(EMRservice.HISInterface.PatientInfoAssist).GetOrdersCaoYao(Adm)
	
		// 门诊医嘱 西药处方
	 	s OrdersXiYao=##class(EMRservice.HISInterface.PatientInfoAssist).GetOrdersXiYao(Adm)
	}
	if (+($f(EpisodeNo,"EP"))'=0)
	{
		
		// 急诊医嘱 化验
	 	s OrdersLab=##Class(EMRservice.HISInterface.PatientInfoAssist).GetOrderDetailByOrdCat(Adm,AdmDate,$ZD($H,3),"化验",1)
	 	s:(OrdersLab'="") OrdersLab = OrdersLab_"、" 
	 		
		// 急诊医嘱 检查(放射)
	 	s OrdersCheck1=##Class(EMRservice.HISInterface.PatientInfoAssist).GetOrderDetailByOrdCat(Adm,AdmDate,$ZD($H,3),"放射检查",1)
	 	s:(OrdersCheck1'="") OrdersCheck1 = OrdersCheck1_"、" 
	 	
		// 急诊医嘱 检查(物理)
	 	s OrdersCheck2=##Class(EMRservice.HISInterface.PatientInfoAssist).GetOrderDetailByOrdCat(Adm,AdmDate,$ZD($H,3),"物理检查",1)
	 	s:(OrdersCheck2'="") OrdersCheck2 = OrdersCheck2_"、" 
	 		 	
		s OrdersLabAndCheck=OrdersLab_OrdersCheck1_OrdersCheck2
		s:(OrdersLabAndCheck'="") OrdersLabAndCheck= $e( OrdersLabAndCheck,1,$l(OrdersLabAndCheck)-1)
			
		// 急诊医嘱 西药
	 	s OrdersXiYao1 = ##Class(EMRservice.HISInterface.PatientInfoAssist).GetOrderDetailByOrdCat(Adm,AdmDate,$ZD($H,3),"西药")
	 		 	
	 	s OrdersXiYao2 = ##Class(EMRservice.HISInterface.PatientInfoAssist).GetOrderDetailByOrdCat(Adm,AdmDate,$ZD($H,3),"中成药")
	 	
	 	s Tag = ""
	 	
	 	s:(OrdersXiYao1'="")&&(OrdersXiYao2'="") Tag = $c(13,10)
	 	
	 	s OrdersXiYao=OrdersXiYao1_Tag_OrdersXiYao2
	 	
	 	// 急诊医嘱 草药
		//s OrdersCaoYao=##class(EMRservice.HISInterface.PatientInfoAssist).GetOrdersCaoYao(Adm)

	}
	//取出院医嘱　2011-11-30
	s OutDrug=""
	s OutDrug=##class(EMRservice.HISInterface.PatientInfoAssist).GetOrdersByPriority(Adm,"出院带药")

	s CriticallyMono=##Class(EMRservice.HISInterface.PatientInfoAssist).GetCriticallyMono(Adm)
	set ^CacheTemp(repid, ind) = $LB(EpisodeID,PapmiDR,EpisodeNo,RegisterNo,Name,AdmMasterDict,AdmDoctorDict,AdmNurseDict,Care1,Care2,Care3,Care4,Care5,Care6,CareClass,FoodTreatment,OrdersLabAndCheck,OrdersCaoYao,OrdersXiYao,MedAllergy,OutDrug,CriticallyMono)
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
/// Test:		##Class(EMRservice.SystemData).testclidiag(Adm)	
/// d ##class(%ResultSet).RunQuery("EMRservice.SystemData","GetClinicDiagInfo","6112")	
Query GetClinicDiagInfo(Adm As %String) As %Query(ROWSPEC = "EpisodeID,PapmiDR,EpisodeNo,RegisterNo,Name,AdmDiagString,AdmDiagStringH,TCMAdmDiagString,TCMAdmDiagStringH,OutDiagString,OutDiagStringH,TCMOutDiagString,TCMOutDiagStringH,OutDiag01Dict,OutDiag02Dict,OutDiag03Dict,OutDiag04Dict,OutDiag05Dict,OutDiag06Dict,OutDiag07Dict,OutDiag08Dict,OutDiag09Dict,OutDiag10Dict,OutDiag11Dict,OutDiag12Dict,OutDiag13Dict,OutDiag14Dict,OutDiag15Dict,OutDiag16Dict,OutDiag17Dict,OutDiag18Dict,OutDiag19Dict,OutDiag20Dict,OutDiag21Dict,OutDiag22Dict,OutDiag23Dict,OutDiag24Dict,OutDiag25Dict,OutDiag26Dict,OutDiag27Dict,OutDiag28Dict,OutDiag29Dict,OutDiag30Dict,OutDiag31Dict,OutDiag32Dict,OutDiag33Dict,OutDiag34Dict,OutDiag35Dict,OutDiag36Dict,OutDiag37Dict,OutDiag38Dict,OutDiag39Dict,OutDiag40Dict,OutDiag41Dict,OutDiag42Dict,OutDiag43Dict,OutDiag44Dict,OutDiag45Dict,OutDiag46Dict,OutDiag47Dict,OutDiag48Dict,OutDiag49Dict,OutDiag50Dict,TCMOutDiag01Dict,TCMOutDiag02Dict,TCMOutDiag03Dict,TCMOutDiag04Dict,TCMOutDiag05Dict,TCMOutDiag06Dict,TCMOutDiag07Dict,TCMOutDiag08Dict,TCMOutDiag09Dict,TCMOutDiag10Dict,TCMOutDiag11Dict,TCMOutDiag12Dict,TCMOutDiag13Dict,TCMOutDiag14Dict,TCMOutDiag15Dict,TCMOutDiag16Dict,TCMOutDiag17Dict,TCMOutDiag18Dict,TCMOutDiag19Dict,TCMOutDiag20Dict,IPBookDiagDict,AdmDiagstringEnt,AdmCondition01Dict,AdmCondition02Dict,AdmCondition03Dict,AdmCondition04Dict,AdmCondition05Dict,AdmCondition06Dict,AdmCondition07Dict,AdmCondition08Dict,AdmCondition09Dict,AdmCondition10Dict,AdmCondition11Dict,AdmCondition12Dict,AdmCondition13Dict,AdmCondition14Dict,AdmCondition15Dict,AdmCondition16Dict,AdmCondition17Dict,AdmCondition18Dict,AdmCondition19Dict,AdmCondition20Dict")
{
}

ClassMethod GetClinicDiagInfoExecute(ByRef qHandle As %Binary, Adm As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:($d(^PAADM(Adm))=0)||(Adm="") $$$OK
	
	//取系统参数
	s Hospital=##class(EMRservice.BL.BLSysOption).GetOptionValueByName("HospitalName")
	Quit:(Hospital="") $$$OK
	 
	// 初始化返回值
	// 入院诊断相关（西医入院竖排、西医入院横排、中医入院竖排、中医入院横排）
	s AdmDiagString = "",AdmDiagStringH = "",TCMAdmDiagString = "",TCMAdmDiagStringH = ""
	// 出院诊断相关（西医出院竖排、西医出院横排、中医出院竖排、中医出院横排）
	s OutDiagString = "",OutDiagStringH = "",TCMOutDiagString = "",TCMOutDiagStringH = ""
	
	// 住院病案首页的出院诊断
	// 西医出院诊断
	s (OutDiag01Dict,OutDiag02Dict,OutDiag03Dict,OutDiag04Dict,OutDiag05Dict,OutDiag06Dict,OutDiag07Dict,OutDiag08Dict,OutDiag09Dict,OutDiag10Dict)=""
	s (OutDiag11Dict,OutDiag12Dict,OutDiag13Dict,OutDiag14Dict,OutDiag15Dict,OutDiag16Dict,OutDiag17Dict,OutDiag18Dict,OutDiag19Dict,OutDiag20Dict)=""
	s (OutDiag21Dict,OutDiag22Dict,OutDiag23Dict) = ""
	
	// 中医出院诊断
	s (TCMOutDiag01Dict,TCMOutDiag02Dict,TCMOutDiag03Dict,TCMOutDiag04Dict,TCMOutDiag05Dict,TCMOutDiag06Dict,TCMOutDiag07Dict,TCMOutDiag08Dict,TCMOutDiag09Dict,TCMOutDiag10Dict)=""
	s (TCMOutDiag11Dict,TCMOutDiag12Dict,TCMOutDiag13Dict,TCMOutDiag14Dict,TCMOutDiag15Dict,TCMOutDiag16Dict,TCMOutDiag17Dict,TCMOutDiag18Dict,TCMOutDiag19Dict,TCMOutDiag20Dict)=""
	
	// 住院证上的门诊诊断
	s IPBookDiagDict=""
	
	// 标识号|登记RowId|就诊号|登记号|姓名
 	s EpisodeID=Adm
 	s PapmiDR = ##Class(EMRservice.HISInterface.PatientInfoAssist).GetPapmiDR(Adm)
 	s EpisodeNo = ##Class(EMRservice.HISInterface.PatientInfoAssist).GetEpisodeNo(Adm)
 	s RegisterNo = ##Class(EMRservice.HISInterface.PatientInfoAssist).GetPapmiNo(PapmiDR)
	s Name = ##Class(EMRservice.HISInterface.PatientInfoAssist).Name(PapmiDR)
	
	s MRADMID = $P(^PAADM(Adm),"^",61)
 	/////////////////////// 
 	// 患者临床诊断大类  // 
 	/////////////////////// 
	
	// 西医入院诊断
	s AdmDiagString = "",AdmDiagStringH = ""
	s tmpAdmDiagDict = "" //##class(EMRservice.HISInterface.PatientInfoAssist).GetMRDiagnoseListForEMR(MRADMID,2,"C008")
	s tmpPREDiagDict = ##class(EMRservice.HISInterface.PatientInfoAssist).GetMRDiagnoseListForEMR(MRADMID,2,"PRE")
	
	s:(tmpPREDiagDict'="")&&(tmpAdmDiagDict'="") tmpAdmDiagDict = tmpAdmDiagDict_$C(1)_tmpPREDiagDict
	s:(tmpPREDiagDict'="")&&(tmpAdmDiagDict="") tmpAdmDiagDict = tmpPREDiagDict
	
	if tmpAdmDiagDict'="" 
	{
		s AdmDiagLength = $L(tmpAdmDiagDict,$C(1))
		f i = 1:1:AdmDiagLength
		{
			// 西医入院诊断横排、竖排
			s DiagnosDesc = i_"、"_$P($P(tmpAdmDiagDict,$C(1),i),"^",1)
			
			s:(AdmDiagString'="") AdmDiagString = AdmDiagString_$C(10)_DiagnosDesc
			s:(AdmDiagString="") AdmDiagString = DiagnosDesc
			
			s:(AdmDiagStringH'="") AdmDiagStringH = AdmDiagStringH_","_DiagnosDesc
			s:(AdmDiagStringH="") AdmDiagStringH = DiagnosDesc
		}
	}
	
	// 中医入院诊断
	s TCMAdmDiagString = "",TCMAdmDiagStringH = ""
	s tmpTCMAdmDiagDict = ##class(EMRservice.HISInterface.PatientInfoAssist).GetMRDiagnoseListForEMR(MRADMID,1,"C008")
	s tmpTCMPREDiagDict = ##class(EMRservice.HISInterface.PatientInfoAssist).GetMRDiagnoseListForEMR(MRADMID,1,"PRE")
	
	s:(tmpTCMPREDiagDict'="")&&(tmpTCMAdmDiagDict'="") tmpTCMAdmDiagDict = tmpTCMAdmDiagDict_$C(1)_tmpTCMPREDiagDict
	s:(tmpTCMPREDiagDict'="")&&(tmpTCMAdmDiagDict="") tmpTCMAdmDiagDict = tmpTCMPREDiagDict
	
	if tmpTCMAdmDiagDict'="" 
	{
		s TCMAdmDiagLength = $L(tmpTCMAdmDiagDict,$C(1))
		f i = 1:1:TCMAdmDiagLength
		{
			// 中医入院诊断横排、竖排
			s DiagnosDesc = i_"、"_$P($P(tmpTCMAdmDiagDict,$C(1),i),"^",1)
			s:(i>1) DiagnosDesc = "  "_DiagnosDesc
			
			s:(TCMAdmDiagString'="") TCMAdmDiagString = TCMAdmDiagString_$C(10)_DiagnosDesc
			s:(TCMAdmDiagString="") TCMAdmDiagString = DiagnosDesc
			
			s:(TCMAdmDiagStringH'="") TCMAdmDiagStringH = TCMAdmDiagStringH_","_DiagnosDesc
			s:(TCMAdmDiagStringH="") TCMAdmDiagStringH = DiagnosDesc
		}
	}
	
	
	// 取西医出院诊断
	s OutDiagString = "",OutDiagStringH = ""
	s tmpOutDiag = ##class(EMRservice.HISInterface.PatientInfoAssist).GetMRDiagnoseListForEMR(MRADMID,2,"DIS")
	if tmpOutDiag'="" 
	{
		s outdiagcount=$L(tmpOutDiag,$C(1))
		f i=1:1:outdiagcount 
		{
			s OutDiagDict = $p($p($g(tmpOutDiag),$C(1),i),"^",3)_"^"_$p($p($g(tmpOutDiag),$C(1),i),"^",5)_"^"_$p($p($g(tmpOutDiag),$C(1),i),"^",1)
			i i=1  s OutDiag01Dict=OutDiagDict 
			i i=2  s OutDiag02Dict=OutDiagDict 
			i i=3  s OutDiag03Dict=OutDiagDict 
			i i=4  s OutDiag04Dict=OutDiagDict 
			i i=5  s OutDiag05Dict=OutDiagDict 
			i i=6  s OutDiag06Dict=OutDiagDict 
			i i=7  s OutDiag07Dict=OutDiagDict 
			i i=8  s OutDiag08Dict=OutDiagDict 
			i i=9  s OutDiag09Dict=OutDiagDict 
			i i=10 s OutDiag10Dict=OutDiagDict 
			i i=11 s OutDiag11Dict=OutDiagDict 
			i i=12 s OutDiag12Dict=OutDiagDict 
			i i=13 s OutDiag13Dict=OutDiagDict 
			i i=14 s OutDiag14Dict=OutDiagDict 
			i i=15 s OutDiag15Dict=OutDiagDict 
			i i=16 s OutDiag16Dict=OutDiagDict 
			i i=17 s OutDiag17Dict=OutDiagDict 
			i i=18 s OutDiag18Dict=OutDiagDict 
			i i=19 s OutDiag19Dict=OutDiagDict 
			i i=20 s OutDiag20Dict=OutDiagDict 
			i i=21 s OutDiag21Dict=OutDiagDict 
			i i=22 s OutDiag22Dict=OutDiagDict 
			i i=23 s OutDiag23Dict=OutDiagDict
			i i=24 s OutDiag24Dict=OutDiagDict 
			i i=25 s OutDiag25Dict=OutDiagDict 
			i i=26 s OutDiag26Dict=OutDiagDict 
			i i=27 s OutDiag27Dict=OutDiagDict 
			i i=28 s OutDiag28Dict=OutDiagDict 
			i i=29 s OutDiag29Dict=OutDiagDict 
			i i=30 s OutDiag30Dict=OutDiagDict
			
			i i=31 s OutDiag31Dict=OutDiagDict 
			i i=32 s OutDiag32Dict=OutDiagDict 
			i i=33 s OutDiag33Dict=OutDiagDict 
			i i=34 s OutDiag34Dict=OutDiagDict 
			i i=35 s OutDiag35Dict=OutDiagDict 
			i i=36 s OutDiag36Dict=OutDiagDict 
			i i=37 s OutDiag37Dict=OutDiagDict 
			i i=38 s OutDiag38Dict=OutDiagDict 
			i i=39 s OutDiag39Dict=OutDiagDict 
			
			i i=40 s OutDiag40Dict=OutDiagDict
			i i=41 s OutDiag41Dict=OutDiagDict 
			i i=42 s OutDiag42Dict=OutDiagDict 
			i i=43 s OutDiag43Dict=OutDiagDict 
			i i=44 s OutDiag44Dict=OutDiagDict 
			i i=45 s OutDiag45Dict=OutDiagDict 
			i i=46 s OutDiag46Dict=OutDiagDict 
			i i=47 s OutDiag47Dict=OutDiagDict 
			i i=48 s OutDiag48Dict=OutDiagDict 
			i i=49 s OutDiag49Dict=OutDiagDict 
			i i=50 s OutDiag50Dict=OutDiagDict
			
			
			// 西医出院横排、竖排
			s DiagnosDesc = i_"、"_$P($P(tmpOutDiag,$C(1),i),"^",1)
			
			s:(OutDiagString'="") OutDiagString = OutDiagString_$C(10)_DiagnosDesc
			s:(OutDiagString="") OutDiagString = DiagnosDesc
			
			s:(OutDiagStringH'="") OutDiagStringH = OutDiagStringH_","_DiagnosDesc
			s:(OutDiagStringH="") OutDiagStringH = DiagnosDesc
		}
	}
    
    // 取中医出院诊断
	s TCMOutDiagString = "",TCMOutDiagStringH = ""
	s tmpTCMOutDiag = ##class(EMRservice.HISInterface.PatientInfoAssist).GetMRDiagnoseListForEMR(MRADMID,1,"DIS")
	if tmpTCMOutDiag'="" 
	{
		s TCMoutdiagcount=$L(tmpTCMOutDiag,$C(1))
		f i=1:1:TCMoutdiagcount 
		{
			s OutDiagDict = $p($p($g(tmpTCMOutDiag),$C(1),i),"^",3)_"^"_$p($p($g(tmpTCMOutDiag),$C(1),i),"^",5)_"^"_$p($p($g(tmpTCMOutDiag),$C(1),i),"^",1)
			i i=1  s TCMOutDiag01Dict=OutDiagDict 
			i i=2  s TCMOutDiag02Dict=OutDiagDict 
			i i=3  s TCMOutDiag03Dict=OutDiagDict 
			i i=4  s TCMOutDiag04Dict=OutDiagDict 
			i i=5  s TCMOutDiag05Dict=OutDiagDict 
			i i=6  s TCMOutDiag06Dict=OutDiagDict 
			i i=7  s TCMOutDiag07Dict=OutDiagDict 
			i i=8  s TCMOutDiag08Dict=OutDiagDict 
			i i=9  s TCMOutDiag09Dict=OutDiagDict 
			i i=10 s TCMOutDiag10Dict=OutDiagDict 
			i i=11 s TCMOutDiag11Dict=OutDiagDict 
			i i=12 s TCMOutDiag12Dict=OutDiagDict 
			i i=13 s TCMOutDiag13Dict=OutDiagDict 
			i i=14 s TCMOutDiag14Dict=OutDiagDict 
			i i=15 s TCMOutDiag15Dict=OutDiagDict 
			i i=16 s TCMOutDiag16Dict=OutDiagDict 
			i i=17 s TCMOutDiag17Dict=OutDiagDict 
			i i=18 s TCMOutDiag18Dict=OutDiagDict 
			i i=19 s TCMOutDiag19Dict=OutDiagDict 
			i i=20 s TCMOutDiag20Dict=OutDiagDict 
			
		
			// 中医出院横排、竖排
			s DiagnosDesc = i_"、"_$P($P(tmpTCMOutDiag,$C(1),i),"^",1)
			s:(i>1) DiagnosDesc = "  "_DiagnosDesc
			
			s:(TCMOutDiagString'="") TCMOutDiagString = TCMOutDiagString_$C(10)_DiagnosDesc
			s:(TCMOutDiagString="") TCMOutDiagString = DiagnosDesc
			
			s:(TCMOutDiagStringH'="") TCMOutDiagStringH = TCMOutDiagStringH_","_DiagnosDesc
			s:(TCMOutDiagStringH="") TCMOutDiagStringH = DiagnosDesc
		}
	}
	
	// 住院证上的门诊诊断
	set IPBookDiagDict=##Class(EMRservice.HISInterface.PatientInfoAssist).GetIPBookDiagDict(Adm)

	s AdmDiagstringEnt =##class(EMRservice.BL.BLDiagRefFormatData).GetDiagRefFormatData(Adm,"diagnosesLayerV8","PRE")
	
	s (AdmCondition01Dict,AdmCondition02Dict,AdmCondition03Dict,AdmCondition04Dict,AdmCondition05Dict)="^^"
	s (AdmCondition06Dict,AdmCondition07Dict,AdmCondition08Dict,AdmCondition09Dict,AdmCondition10Dict)="^^"
	s (AdmCondition11Dict,AdmCondition12Dict,AdmCondition13Dict,AdmCondition14Dict,AdmCondition15Dict)="^^"
	s (AdmCondition16Dict,AdmCondition17Dict,AdmCondition18Dict,AdmCondition19Dict,AdmCondition20Dict)="^^"
	
	
	set ^CacheTemp(repid, ind) = $LB(EpisodeID,PapmiDR,EpisodeNo,RegisterNo,Name,AdmDiagString,AdmDiagStringH,TCMAdmDiagString,TCMAdmDiagStringH,OutDiagString,OutDiagStringH,TCMOutDiagString,TCMOutDiagStringH,OutDiag01Dict,OutDiag02Dict,OutDiag03Dict,OutDiag04Dict,OutDiag05Dict,OutDiag06Dict,OutDiag07Dict,OutDiag08Dict,OutDiag09Dict,OutDiag10Dict,OutDiag11Dict,OutDiag12Dict,OutDiag13Dict,OutDiag14Dict,OutDiag15Dict,OutDiag16Dict,OutDiag17Dict,OutDiag18Dict,OutDiag19Dict,OutDiag20Dict,OutDiag21Dict,OutDiag22Dict,OutDiag23Dict,OutDiag24Dict,OutDiag25Dict,OutDiag26Dict,OutDiag27Dict,OutDiag28Dict,OutDiag29Dict,OutDiag30Dict,OutDiag31Dict,OutDiag32Dict,OutDiag33Dict,OutDiag34Dict,OutDiag35Dict,OutDiag36Dict,OutDiag37Dict,OutDiag38Dict,OutDiag39Dict,OutDiag40Dict,OutDiag41Dict,OutDiag42Dict,OutDiag43Dict,OutDiag44Dict,OutDiag45Dict,OutDiag46Dict,OutDiag47Dict,OutDiag48Dict,OutDiag49Dict,OutDiag50Dict,TCMOutDiag01Dict,TCMOutDiag02Dict,TCMOutDiag03Dict,TCMOutDiag04Dict,TCMOutDiag05Dict,TCMOutDiag06Dict,TCMOutDiag07Dict,TCMOutDiag08Dict,TCMOutDiag09Dict,TCMOutDiag10Dict,TCMOutDiag11Dict,TCMOutDiag12Dict,TCMOutDiag13Dict,TCMOutDiag14Dict,TCMOutDiag15Dict,TCMOutDiag16Dict,TCMOutDiag17Dict,TCMOutDiag18Dict,TCMOutDiag19Dict,TCMOutDiag20Dict,IPBookDiagDict,AdmDiagstringEnt,AdmCondition01Dict,AdmCondition02Dict,AdmCondition03Dict,AdmCondition04Dict,AdmCondition05Dict,AdmCondition06Dict,AdmCondition07Dict,AdmCondition08Dict,AdmCondition09Dict,AdmCondition10Dict,AdmCondition11Dict,AdmCondition12Dict,AdmCondition13Dict,AdmCondition14Dict,AdmCondition15Dict,AdmCondition16Dict,AdmCondition17Dict,AdmCondition18Dict,AdmCondition19Dict,AdmCondition20Dict)
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
/// Test:		##Class(EMRservice.SystemData).testlab(Adm)
/// d ##class(%ResultSet).RunQuery("EMRservice.SystemData","GetLabInfo","1604")		
Query GetLabInfo(Adm As %String) As %Query(ROWSPEC = "EpisodeID,PapmiDR,EpisodeNo,RegisterNo,Name,BloodType,BloodTypeMono,Rh,RhMono,HBsAg,HCV,HIV,TP,ALT,HBeAg,HBS,AntiHBe,HBC,RBC,HCT,PLT,HGB,PT,APTT,FIB,BloodTypeDict,RhDict")
{
}

ClassMethod GetLabInfoExecute(ByRef qHandle As %Binary, Adm As %String) As %Status
{

	Set repid=$I(^CacheTemp)
	s ind=1
	Set qHandle=$lb(0,repid,0)

	Quit:($d(^PAADM(Adm))=0)||(Adm="") $$$OK
	
    	//取系统参数
	s Hospital=##class(EMRservice.BL.BLSysOption).GetOptionValueByName("HospitalName")
  	s SpaceHIS=##class(EMRservice.BL.BLSysOption).GetOptionValueByName("NameSpaceHIS")
	if SpaceHIS'=""
	{
		s MEDDATA = $p($g(SpaceHIS),"^",1)
		s WEBSRC  = $p($g(SpaceHIS),"^",2)
	}
	s SpaceLIS=##class(EMRservice.BL.BLSysOption).GetOptionValueByName("NameSpaceLIS")
	if SpaceLIS'=""
	{
	    s LABDATA = $p($g(SpaceLIS),"^",1)
	    s LABSRC  = $p($g(SpaceLIS),"^",2)
	 }
	 Quit:((Hospital="")||(SpaceHIS="")||(SpaceLIS="")) $$$OK
	
 	// 标识号|登记RowId|就诊号|登记号|姓名
 	s EpisodeID=Adm
 	s PapmiDR = ##Class(EMRservice.HISInterface.PatientInfoAssist).GetPapmiDR(Adm)
 	s EpisodeNo=##Class(EMRservice.HISInterface.PatientInfoAssist).GetEpisodeNo(Adm)
 	s RegisterNo = ##Class(EMRservice.HISInterface.PatientInfoAssist).GetPapmiNo(PapmiDR)
	s Name=##Class(EMRservice.HISInterface.PatientInfoAssist).Name(PapmiDR)

	//BG_"^"_Rh_"^"_RBC_"^"_HCT_"^"_HGB_"^"_PLT_"^"_ALT_"^"_HBsAg_"^"_AntiHBs_"^"_HBeAg_"^"_AntiHBe_"^"_AntiHBc_"^"_AntiHCV_"^"_AntiHIV_"^"_MD
	
	/*
	ABO （√）1
	Rh （√）2
	RBC （√）3
	Hb	=>	HGB（√）16
	HCT （√）4
	PLT （√）6

	ALT （√）7
	HBeAg （√）10
	HBsAg （√）8
	HBs （√）9
	HBe （√）11
	HBc （√）12
	HCV （√）13
	HIV （√）14

	MD	=>TPAB （√）15

	PT	（√）17
	APTT	（√）18
	FBG	=>	FIB（√）19
	*/
	s LabBldInfo=##Class(EMRservice.HISInterface.PatientInfoAssist).GetLabBldInfoNew(Adm)
	
	//ABO血型
	s BloodType=$p(LabBldInfo,"^",1)
	if (BloodType="") { s BloodType="未查" } 
	elseif ($L(BloodType,"ABO血型")>1) 
	{ 
		s BloodType=$P(BloodType,"ABO血型",2) 
		s BloodType=$P(BloodType,"型",1)
	}

	s BloodTypeMono=$$BloodTypeToMono(BloodType)
	s BloodTypeDict=$$BloodTypeToDict(BloodType)

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
	s RhMono=$$RhToMono(Rh)
	s RhDict=$$RhToDict(Rh)
	
	//ALT丙氨酸氨基转移酶
	s ALT=$p(LabBldInfo,"^",7)
	if (ALT="") { s ALT="未查" } 
	elseif ($L(ALT,"U/L")>1) { s ALT=$P(ALT,"U/L",1) }
	
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
	
	//RBC
	s RBC=$p(LabBldInfo,"^",3)
	if (RBC="") { s MD="未查" } 	
	elseif (($e(RBC,1)="阴")||($e(RBC,1)="-")) { s RBC="阴性" }
	elseif (($e(RBC,1)="阳")||($e(RBC,1)="+")) { s RBC="阳性" }
	
	//HCT
	s HCT=$p(LabBldInfo,"^",4)
	if (HCT="") { s HCT="未查" } 	
	elseif (($e(HCT,1)="阴")||($e(HCT,1)="-")) { s HCT="阴性" }
	elseif (($e(HCT,1)="阳")||($e(HCT,1)="+")) { s HCT="阳性" }
	
	//PLT
	s PLT=$p(LabBldInfo,"^",6)
	if (PLT="") { s PLT="未查" } 	
	elseif (($e(PLT,1)="阴")||($e(PLT,1)="-")) { s PLT="阴性" }
	elseif (($e(PLT,1)="阳")||($e(PLT,1)="+")) { s PLT="阳性" }
	
	
	//HGB
	s HGB=$p(LabBldInfo,"^",16)
	if (HGB="") { s HGB="未查" } 	
	elseif (($e(HGB,1)="阴")||($e(HGB,1)="-")) { s HGB="阴性" }
	elseif (($e(HGB,1)="阳")||($e(HGB,1)="+")) { s HGB="阳性" }
	
	
	//PT
	s PT=$p(LabBldInfo,"^",17)
	if (PT="") { s PT="未查" } 	
	elseif (($e(PT,1)="阴")||($e(PT,1)="-")) { s MD="阴性" }
	elseif (($e(PT,1)="阳")||($e(PT,1)="+")) { s MD="阳性" }
	
	//APTT
	s APTT=$p(LabBldInfo,"^",18)
	if (APTT="") { s APTT="未查" } 	
	elseif (($e(APTT,1)="阴")||($e(APTT,1)="-")) { s APTT="阴性" }
	elseif (($e(APTT,1)="阳")||($e(APTT,1)="+")) { s APTT="阳性" }
	
	//FIB
	s FIB=$p(LabBldInfo,"^",19)
	if (FIB="") { s FIB="未查" } 	
	elseif (($e(FIB,1)="阴")||($e(FIB,1)="-")) { s FIB="阴性" }
	elseif (($e(FIB,1)="阳")||($e(FIB,1)="+")) { s FIB="阳性" }
	

	set ^CacheTemp(repid, ind) = $LB(EpisodeID,PapmiDR,EpisodeNo,RegisterNo,Name,BloodType,BloodTypeMono,Rh,RhMono,HbsAg,HCVAb,HIVAb,MD,ALT,HBeAg,HbsAb,HBeAb,HBcAb,RBC,HCT,PLT,HGB,PT,APTT,FIB,BloodTypeDict,RhDict)
	set ind = ind + 1
	
	Quit $$$OK
	
RhToMono(aRh)
	s ret=""
	s ret=$s(aRh="阴性(-)":"1^阴",aRh="阳性(+)":"2^阳",aRh="不详":"3^不详",aRh="未查":"4^未查")
	q ret
BloodTypeToMono(aBloodType)
	s ret=""
	s ret=$s(aBloodType="A型":"1^A",aBloodType="B型":"2^B",aBloodType="O型":"3^O",aBloodType="AB型":"4^AB",aBloodType="不详":"5^不详",aBloodType="未查":"6^未查")
	q ret
RhToDict(aRh)
	s ret=""
	s ret=$s(aRh="阴性(-)":"1^1^阴",aRh="阳性(+)":"2^2^阳",aRh="不详":"3^3^不详",aRh="未查":"4^4^未查")
	q ret
BloodTypeToDict(aBloodType)
	s ret=""
	s ret=$s(aBloodType="A型":"1^1^A",aBloodType="B型":"2^2^B",aBloodType="O型":"3^3^O",aBloodType="AB型":"4^4^AB",aBloodType="不详":"5^5^不详",aBloodType="未查":"6^6^未查")
	q ret
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
/// Test:		d ##Class(EMRservice.SystemData).testchkinfo(31)
/// Test:		d ##Class(%ResultSet).RunQuery("EMRservice.SystemData","GetCheckInfo",Adm)		
Query GetCheckInfo(Adm As %String) As %Query(ROWSPEC = "EpisodeID,Temp1,TempNew,Pulse1,PulseNew,Resp1,RespNew,HBP1,HBPNew,LBP1,LBPNew,HR1,HRNew,Weight1,WeightNew,Height1,HeightNew")
{
}

ClassMethod GetCheckInfoExecute(ByRef qHandle As %Binary, Adm As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	Set qHandle=$lb(0,repid,0)

	Quit:($d(^PAADM(Adm))=0)||(Adm="") $$$OK

	s EpisodeID=Adm
	s (Temp1,TempNew,Pulse1,PulseNew,Resp1,RespNew,HBP1,HBPNew,LBP1,LBPNew,HR1,HRNew,Weight1,WeightNew)=""
    s Tempnew=##class(EMRservice.HISInterface.PatientInfoAssist).GetPatObservationsNew(EpisodeID)
    s Temp1=$p($p($p(Tempnew,"@",1),"^",1),":",2)
    s Pulse1=$p($p($p(Tempnew,"@",1),"^",2),":",2)
    s HR1=$p($p($p(Tempnew,"@",2),"^",3),":",2)
    s Resp1=$p($p($p(Tempnew,"@",1),"^",4),":",2)
    s HBP1=$p($p($p(Tempnew,"@",1),"^",5),":",2)
    s LBP1=$p($p($p(Tempnew,"@",1),"^",6),":",2)
    s Weight1=$p($p($p(Tempnew,"@",1),"^",7),":",2)
    s Height1=$p($p($p(Tempnew,"@",1),"^",8),":",2)
    
    s TempNew=$p($p($p(Tempnew,"@",2),"^",1),":",2)
    s PulseNew=$p($p($p(Tempnew,"@",2),"^",2),":",2)
    s HRNew=$p($p($p(Tempnew,"@",2),"^",3),":",2)
    s RespNew=$p($p($p(Tempnew,"@",2),"^",4),":",2)
    s HBPNew=$p($p($p(Tempnew,"@",2),"^",5),":",2)
    s LBPNew=$p($p($p(Tempnew,"@",2),"^",6),":",2)
    s HeightNew=$p($p($p(Tempnew,"@",1),"^",8),":",2)
    
	set ^CacheTemp(repid, ind) = $LB(EpisodeID,Temp1,TempNew,Pulse1,PulseNew,Resp1,RespNew,HBP1,HBPNew,LBP1,LBPNew,HR1,HRNew,Weight1,WeightNew,Height1,HeightNew)

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
/// Test:		##Class(EMRservice.SystemData).testatd(Adm)	
/// d ##class(%ResultSet).RunQuery("EMRservice.SystemData","GetATDInfo","165","2020-04-07 16:25:01")	
Query GetATDInfo(Adm As %String, AHappenDateTime As %String = "") As %Query(ROWSPEC = "EpisodeID,PapmiDR,EpisodeNo,RegisterNo,Name,AdmDate,AdmTime,AdmDateTime,AdmDateInBed,AdmTimeInBed,AdmDateTimeInBed,AdmDeptDict,AdmDeptDesc,AdmWardDict,AdmWardDesc,AdmRoom,AdmBed,DisDate,DisTime,DisDateTime,DisDeptDict,DisDeptDesc,DisWardDict,DisWardDesc,DisRoom,DisBed,TransDept,TransDeptDetail,TransDateTime1st,TransDept1stDict,TransDept1stDesc,TransWard1stDict,TransWard1stDesc,TransDeptAgain,DeathDateTime,ResidentDays,InTimes,CurDeptDict,CurDeptDesc,CurWardDict,CurWardDesc,CurRoom,CurBed,CurDate,CurTime,CurDateTime,InScore,OutScore,LastTransDept,AdmCTLoc,DisModeMono,DisModeDict")
{
}

ClassMethod GetATDInfoExecute(ByRef qHandle As %Binary, Adm As %String, AHappenDateTime As %String = "") As %Status
{

	
	Set repid=$I(^CacheTemp)
	s ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:($d(^PAADM(Adm))=0)||(Adm="") $$$OK
	
    	//取系统参数
	s Hospital=##class(EMRservice.BL.BLSysOption).GetOptionValueByName("HospitalName")
  	s SpaceHIS=##class(EMRservice.BL.BLSysOption).GetOptionValueByName("NameSpaceHIS")
	if SpaceHIS'=""
	{
		s MEDDATA = $p($g(SpaceHIS),"^",1)
		s WEBSRC  = $p($g(SpaceHIS),"^",2)
	}
	s SpaceLIS=##class(EMRservice.BL.BLSysOption).GetOptionValueByName("NameSpaceLIS")
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
	s DisDate="" ,DisTime="" ,DisDateTime="" ,DisDept="" ,DisDeptDesc="" ,DisWard="" ,DisWardDesc="" ,DisRoom="" ,DisBed="" ,DeathDateTime="" ,DisDateTimeMR="",DeathDate="",DeathTime="",DisModeMono=""
	
	// 转科信息
	s TransDept="" ,TransDeptDetail="" ,ResidentDays="" ,InTimes="" ,TransDateTime1st="" ,TransDept1st="" ,TransWard1st="" ,TransDeptAgain=""
	
	// 在院信息
	s CurDept="" ,CurDeptDesc="" ,CurWard="" ,CurWardDesc="" ,CurRoom="" ,CurBed=""


 	// 标识号|登记RowId|就诊号|登记号|姓名
 	s EpisodeID=Adm
 	s PapmiDR = ##Class(EMRservice.HISInterface.PatientInfoAssist).GetPapmiDR(Adm)
 	s EpisodeNo=##Class(EMRservice.HISInterface.PatientInfoAssist).GetEpisodeNo(Adm)
 	s RegisterNo = ##Class(EMRservice.HISInterface.PatientInfoAssist).GetPapmiNo(PapmiDR)
	s Name=##Class(EMRservice.HISInterface.PatientInfoAssist).Name(PapmiDR)


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
	
	s AdmDateTime=##class(EMRservice.HISInterface.PatientInfoAssist).AdmDateTime(Adm,Hospital)
	i AdmDateTime'="" 
	{ 

		s AdmDate = $ZD($P($G(AdmDateTime),",",1),3)
		s AdmTime = $ZT($P($G(AdmDateTime),",",2),1)
		s AdmDateTime=AdmDate_" "_AdmTime

	}   
	
	// 入院分床日期 	[AdmDateInBed]			
	// 入院分床时间		[AdmTimeInBed]			
	// 入院分床日期时间	[AdmDateTimeInBed]		
	// 统一入院时间，通过统一接口获取 （AdmDateTimeInBed 与AdmDateTime 保持一致，由业务配置数据控制数据源）
	//s AdmDateTimeInBed=##class(EMRservice.HISInterface.PatientInfoAssist).AdmDateTimeInBed(Adm,Hospital)
	s AdmDateTimeInBed=##class(EMRservice.HISInterface.PatientInfoAssist).AdmDateTime(Adm,Hospital)
	i AdmDateTimeInBed'="" 
	{
		s AdmDateInBed = $ZD($P($G(AdmDateTimeInBed),",",1),3)
		s AdmTimeInBed = $ZT($P($G(AdmDateTimeInBed),",",2),1)
		s AdmDateTimeInBed=AdmDateInBed_" "_AdmTimeInBed

	}  


	// 入院科室		[AdmDeptDict]
	// 入院科室描述		[AdmDeptDesc]
	s tmpAdmDept=##Class(EMRservice.HISInterface.PatientInfoAssist).AdmDept(Adm,Hospital)
	i tmpAdmDept'=""
 	{
  
   		s AdmDeptDict = tmpAdmDept
   		s AdmDeptDesc = $p($g(tmpAdmDept),"^",3)
	
 	} 

	// 入院病区			[AdmWardDict]
	// 入院病区描述		[AdmWardDesc]
	s tmpAdmWard=##Class(EMRservice.HISInterface.PatientInfoAssist).AdmWard(Adm,Hospital)
	i tmpAdmWard'=""
 	{
   		s AdmWardDict = tmpAdmWard
   		s AdmWardDesc = $p($g(tmpAdmWard),"^",3)

 	}

 	// 入院病室			[AdmRoom]
	s tmpAdmRoom=##Class(EMRservice.HISInterface.PatientInfoAssist).AdmRoom(Adm,Hospital)
	i tmpAdmRoom'=""
 	{
   		s AdmRoom = $p($g(tmpAdmRoom),"^",3)
 	}

	// 入院床号			[AdmBed]
	s AdmBed= ##Class(EMRservice.HISInterface.PatientInfoAssist).AdmBed(Adm) 
 
 
  	///////////////////////
 	// 患者出院信息大类  //
 	///////////////////////
 
 
 	//DisDate,DisTime,DisDateTime,DisDept,DisDeptDesc,DisWard,DisWardDesc,DisBed,
	// 出院日期 		[DisDate]			PAAdm_DischgDate
	// 出院时间			[DisTime]			PAAdm_DischgTime
	// 出院日期时间		[DisDateTime]		PAAdm_DischgDate And PAAdm_DischgTime
	// 出院日期通过统一接口获取，调用函数不变，代码兼容。
	s DisDateTime=##class(EMRservice.HISInterface.PatientInfoAssist).DisDateTime(Adm,Hospital)
	
	s DeathDateTime=##class(EMRservice.HISInterface.PatientInfoAssist).DeathDateTime(Adm,PapmiDR,Hospital)
	s DisDateTimeMR=##Class(EMRservice.HISInterface.PatientInfoAssist).DisDateTimeMR(Adm,Hospital)
 	s DisDateTimeDoctor=##Class(EMRservice.HISInterface.PatientInfoAssist).DisDateTimeDoctor(Adm,Hospital)
 	
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

		} 
	 	
	 	// 统计组[袁旭] 日期时间
		if ($p($g(DisDateTimeMR),",",1)'="")&&($p($g(DisDateTimeMR),",",2)'="")
		{ 
			
			s DisDate = $ZD($P($G(DisDateTimeMR),",",1),3)
			s DisTime = $ZT($P($G(DisDateTimeMR),",",2),1)
			s DisDateTime=DisDate_" "_DisTime
			
		} 
	 	
	 	// 死亡日期时间
		if DeathDateTime'="" 
		{ 
			s DeathDate = $ZD($P($G(DeathDateTime),",",1),3)
			s DeathTime = $ZT($P($G(DeathDateTime),",",2),1)
	   		s DeathDateTime=DeathDate_" "_DeathTime
			s DisDateTime=DeathDateTime

		}
 	}

	// 出院科室			[DisDeptDict]
	// 出院科室描述		[DisDeptDesc]
	s tmpDisDept=##Class(EMRservice.HISInterface.PatientInfoAssist).DisDept(Adm,Hospital,AHappenDateTime) 
	
	i tmpDisDept'=""
 	{
   		s DisDeptDict = tmpDisDept
   		s DisDeptDesc = $p($g(tmpDisDept),"^",3)
 	}
 	
	// 出院病区			[DisWardDict]
	// 出院病区描述		[DisWardDesc]
	s DisWardDict=""
	s DisWardDesc=""
	s tmpDisWard=##Class(EMRservice.HISInterface.PatientInfoAssist).DisWard(Adm,Hospital)
	i tmpDisWard'=""
 	{
   		s DisWardDict = tmpDisWard
   		s DisWardDesc = $p($g(tmpDisWard),"^",3)
 	}

 	// 出院病室			[DisRoom]
	s tmpDisRoom=##Class(EMRservice.HISInterface.PatientInfoAssist).DisRoom(Adm,Hospital)
	i tmpDisRoom'=""
 	{
   		s DisRoom = $p($g(tmpDisRoom),"^",3)

 	}
 	
	// 出院床号			[DisBed]
	s DisBed=##Class(EMRservice.HISInterface.PatientInfoAssist).DisBed(Adm)

 
   	///////////////////////
 	// 患者转科信息大类  //
 	///////////////////////

	
	// 转科情况			[TransDept]
	//末次转科 格式:转出科室->转入科室
	s LastTransDept=""
	s TransDept=##Class(EMRservice.HISInterface.PatientInfoAssist).TransDept(Adm) 
	if ($l(TransDept,"->")>1)
	{
		s Count=$l(TransDept,"->")
		if (Count=2)
		{
			s TransDeptDesc=$p(TransDept,"->",2)
			s LastTransDept=TransDeptDesc
			}
		else 
		{
			s TransDeptDesc=$p(TransDept,"->",Count-1)
			s LastTransDept=TransDeptDesc_"->"_$p(TransDept,"->",Count)
			}
		}
 
	// 转科情况明细		[TransDeptDetail]
	s TransDeptDetail=##Class(EMRservice.HISInterface.PatientInfoAssist).TransDeptDetail(Adm,Hospital) 

	//就诊科室
	s AdmCTLoc=##Class(EMRservice.HISInterface.PatientInfoAssist).GetEpisodeCTLoc(Adm)

	// 住院天数			[ResidentDays]
	s ResidentDays=##Class(EMRservice.HISInterface.PatientInfoAssist).ResidentDaysAdm(Adm,Hospital)

	// 入院次数			[InTimes]
	s InTimes=##Class(EMRservice.HISInterface.PatientInfoAssist).InTimes(Adm,Hospital)
	s tmpInTimes=##Class(EMRservice.HISInterface.PatientInfoAssist).InTimesWMR(Adm,Hospital)
	// 如果医政组接口正确 则取接口入院次数
	i tmpInTimes'=""
	{
		s InTimes=tmpInTimes
	}
	//转科日期时间1st[日期] TransDateTime1st,TransDept1st,TransWard1st,TransDeptAgain
	s:(TransDeptDetail'="")&&(TransDeptDetail'="无") TransDateTime1st=$tr($p($p(TransDeptDetail,"->",2),"^",3,4),"^"," ")
	s TransDept1stDict="─^─^─"
	//转科科室1st[字典]
	if (TransDeptDetail'="")&&(TransDeptDetail'="无") {

		s TransDept1stID=$p($p(TransDeptDetail,"->",2),"^",1)
		s TransDept1stDict=TransDept1stID_"^"_$p(^CTLOC(TransDept1stID),"^",1)_"^"_$p($p(TransDeptDetail,"->",2),"^",2)
		s TransDept1stDesc=$p($p(TransDeptDetail,"->",2),"^",2)

	}

	//转科病区1st[字典]
	if (TransDeptDetail'="")&&(TransDeptDetail'="无") {

		s TransWard1stID=$p($p(TransDeptDetail,"->",2),"^",5)
		s TransWard1stDict=TransWard1stID_"^"_$p(^PAWARD(TransWard1stID),"^",1)_"^"_$p($p(TransDeptDetail,"->",2),"^",6)
		s TransWard1stDesc=$p($p(TransDeptDetail,"->",2),"^",6)

	}
	
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
 	s CurTime=$zt($p($h,",",2),2)
 	s CurDatetime=CurDate_" "_CurTime
 	
 	// 当前科室			[CurDept]
	// 当前科室描述		[CurDeptDesc]
	s CurDeptDict=DisDeptDict
	s CurDeptDesc=DisDeptDesc
	
 	
	// 当前病区			[CurWard]
	// 当前病区描述		[CurWardDesc]
	s CurWardDict=DisWardDict
	s CurWardDesc=DisWardDesc

 	// 当前病室			[CurRoom]
	s CurRoom=DisRoom
 	
	// 当前床号			[CurBed]
	s CurBed=DisBed
	
	//Add by Liaowp 2012-1-15
	//患者入出院生活能力评分
	s ScoreStr="",InScore="─",OutScore="─"
	s ScoreStr=##class(EMRservice.HISInterface.PatientInfoAssist).PatSelfCareDegree(Adm)
	s InScore=$s($P(ScoreStr,"^",1)'="":$P(ScoreStr,"^",1),1:"─")
	s OutScore=$s($P(ScoreStr,"^",2)'="":$P(ScoreStr,"^",2),1:"─")
    s DisModeMono=##Class(EMRservice.HISInterface.PatientInfoAssist).GetDisModeMono(Adm)
    s DisModeDict=##Class(EMRservice.HISInterface.PatientInfoAssist).GetDisModeDict(Adm)
	set ^CacheTemp(repid, ind) = $LB(EpisodeID,PapmiDR,EpisodeNo,RegisterNo,Name,AdmDate,AdmTime,AdmDateTime,AdmDateInBed,AdmTimeInBed,AdmDateTimeInBed,AdmDeptDict,AdmDeptDesc,AdmWardDict,AdmWardDesc,AdmRoom,AdmBed,DisDate,DisTime,DisDateTime,DisDeptDict,DisDeptDesc,DisWardDict,DisWardDesc,DisRoom,DisBed,TransDept,TransDeptDetail,TransDateTime1st,TransDept1stDict,TransDept1stDesc,TransWard1stDict,TransWard1stDesc,TransDeptAgain,DeathDateTime,ResidentDays,InTimes,CurDeptDict,CurDeptDesc,CurWardDict,CurWardDesc,CurRoom,CurBed,CurDate,CurTime,CurDatetime,InScore,OutScore,LastTransDept,AdmCTLoc,DisModeMono,DisModeDict)
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

/// Creator：	EPR
/// CreateDate：
/// Desc：		取费用信息病案子类[HIS]-08 通过array将接口调试由对代码改为修改中文
/// Input:		Adm: 就诊rowid
/// Return：
/// Test:		##Class(EMRservice.SystemData).testmc(Adm)	
/// d ##class(%ResultSet).RunQuery("EMRservice.SystemData","GetMCFeeInfo","3691348")	
Query GetMCFeeInfo(Adm As %String) As %Query(ROWSPEC = "EpisodeID,PapmiDR,EpisodeNo,RegisterNo,Name,MCTotal,MCZFJE,MC01YBYLFWF,MC02YBZLCZF,MC03HLF,MC04QTF,MC05BLZDF,MC06SYSZDF,MC07YXXZDF,MC08LCZDXMF,MC09FSSZLXMF,MC10LCWLZLF,MC11SSZLF,MC12MZF,MC13SSF,MC14KFF,MC15ZYZLF,MC16XYF,MC17KJYWF,MC18ZCYF,MC19ZCYF,MC20XF,MC21BDBLZPF,MC22QDBLZPF,MC23NXYZLZPF,MC24XBYZLZPF,MC25JCYYCXYYCLF,MC26ZLYYCXYYCLF,MC27SSYYCXYYCLF,MC28QTF")
{
}

ClassMethod GetMCFeeInfoExecute(ByRef qHandle As %Binary, Adm As %String) As %Status
{

	Set repid=$I(^CacheTemp)
	s ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:($d(^PAADM(Adm))=0)||(Adm="") $$$OK

    //取系统参数
	s Hospital=##class(EMRservice.BL.BLSysOption).GetOptionValueByName("HospitalName")
  	s SpaceHIS=##class(EMRservice.BL.BLSysOption).GetOptionValueByName("NameSpaceHIS")
	if SpaceHIS'=""
	{
		s MEDDATA = $p($g(SpaceHIS),"^",1)
		s WEBSRC  = $p($g(SpaceHIS),"^",2)
	}
	s SpaceLIS=##class(EMRservice.BL.BLSysOption).GetOptionValueByName("NameSpaceLIS")
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
 	s PapmiDR = ##Class(EMRservice.HISInterface.PatientInfoAssist).GetPapmiDR(Adm)
 	s EpisodeNo=##Class(EMRservice.HISInterface.PatientInfoAssist).GetEpisodeNo(Adm)
 	s RegisterNo = ##Class(EMRservice.HISInterface.PatientInfoAssist).GetPapmiNo(PapmiDR)
	s Name=##Class(EMRservice.HISInterface.PatientInfoAssist).Name(PapmiDR)
	
	// 患者费用(病案费用子类)
	s InPatFee="" , CheckTotal="",CheckFee="",CheckFeeTag=""
	s arrFee = ##Class(%ArrayOfDataTypes).%New()
	s InPatFee=##class(EMRservice.HISInterface.PatientInfoAssist).InPatCostTrakCareSubNew(Adm,Hospital)
	s FeeNum=$l(InPatFee,"!")
	s i=0,FeeList="",tmpFee=""
	f i=1:1:FeeNum 
	{
		s tmpFee=$p(InPatFee,"!",i)
		s FeeType=$p(tmpFee,"^",2)
		s FeeNum=$p(tmpFee,"^",3)
		d arrFee.SetAt(FeeNum,FeeType)
		
		s:(i>1) CheckFee=CheckFee+ FeeNum
		s:(i=1) CheckTotal=FeeNum	
	}
	
	s MCTotal = arrFee.GetAt("总费用")
	s MCZFJE = arrFee.GetAt("自付金额")
	s MC01YBYLFWF = arrFee.GetAt("一般医疗服务费")
	s MC02YBZLCZF = arrFee.GetAt("一般治疗操作费")
	s MC03HLF = arrFee.GetAt("护理费")
	s MC04QTF = arrFee.GetAt("其他费")
	s MC05BLZDF = arrFee.GetAt("病理诊断费")
	s MC06SYSZDF = arrFee.GetAt("实验室诊断费")
	s MC07YXXZDF = arrFee.GetAt("影像学诊断费")
	s MC08LCZDXMF = arrFee.GetAt("临床诊断项目费")
	s MC09FSSZLXMF = $FN(arrFee.GetAt("非手术治疗项目费")+arrFee.GetAt("临床物理治疗费"),"",2)
	s MC10LCWLZLF = arrFee.GetAt("临床物理治疗费")
	s MC11SSZLF = $FN(arrFee.GetAt("手术治疗费")+arrFee.GetAt("麻醉费")+arrFee.GetAt("手术费"),"",2)
	s MC12MZF = arrFee.GetAt("麻醉费")
	s MC13SSF = arrFee.GetAt("手术费")
	s MC14KFF = arrFee.GetAt("康复费")
	s MC15ZYZLF = arrFee.GetAt("中医治疗费")
	s MC16XYF = $FN(arrFee.GetAt("西药费")+arrFee.GetAt("抗菌药物费"),"",2)
	s MC17KJYWF = arrFee.GetAt("抗菌药物费")
	s MC18ZCYF = arrFee.GetAt("中成药费")
	s MC19ZCYF = arrFee.GetAt("中草药费")
	s MC20XF = arrFee.GetAt("血费")
	s MC21BDBLZPF = arrFee.GetAt("白蛋白类制品费")
	s MC22QDBLZPF = arrFee.GetAt("球蛋白类制品费")
	s MC23NXYZLZPF = arrFee.GetAt("凝血因子类制品费")
	s MC24XBYZLZPF = arrFee.GetAt("细胞因子类制品费")
	s MC25JCYYCXYYCLF = arrFee.GetAt("检查用一次性医用材料费")
	s MC26ZLYYCXYYCLF = arrFee.GetAt("治疗用一次性医用材料费")
	s MC27SSYYCXYYCLF = arrFee.GetAt("手术用一次性医用材料费")
	s MC28QTF = arrFee.GetAt("其他费用")
	
	// 费用合计与费用子项审核
	i $fn(CheckTotal,"",2)'=$fn(CheckFee,"",2) { s CheckFeeTag="CheckFeeERROR" } else {s CheckFeeTag="CheckFeeOK" }
	
	set ^CacheTemp(repid, ind) = $LB(EpisodeID,PapmiDR,EpisodeNo,RegisterNo,Name,MCTotal,MCZFJE,MC01YBYLFWF,MC02YBZLCZF,MC03HLF,MC04QTF,MC05BLZDF,MC06SYSZDF,MC07YXXZDF,MC08LCZDXMF,MC09FSSZLXMF,MC10LCWLZLF,MC11SSZLF,MC12MZF,MC13SSF,MC14KFF,MC15ZYZLF,MC16XYF,MC17KJYWF,MC18ZCYF,MC19ZCYF,MC20XF,MC21BDBLZPF,MC22QDBLZPF,MC23NXYZLZPF,MC24XBYZLZPF,MC25JCYYCXYYCLF,MC26ZLYYCXYYCLF,MC27SSYYCXYYCLF,MC28QTF)
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
/// Desc：		取费用信息病案大类[HIS]-07 通过array将接口调试由对代码改为修改中文
/// Input:		Adm: 就诊rowid
/// Return：
/// Test:		##Class(EMRservice.SystemData).testtmc(Adm)
/// 		d ##class(%ResultSet).RunQuery("EMRservice.SystemData","GetTMCFeeInfo","3691348")
Query GetTMCFeeInfo(Adm As %String) As %Query(ROWSPEC = "EpisodeID,PapmiDR,EpisodeNo,RegisterNo,Name,TMCTotal,TMC01YBYLFWF,TMC02YBZLCZF,TMC03HLF,TMC04QTF,TMC05BLZDF,TMC06SYSZDF,TMC07YXXZDF,TMC08LCZDXMF,TMC09FSSZLXMF,TMC10SSZLF,TMC11KFF,TMC12ZYZLF,TMC13XYF,TMC14ZCYF,TMC15ZCYF,TMC16XF,TMC17BDBLZPF,TMC18QDBLZPF,TMC19NXYZLZPF,TMC20XBYZLZPF,TMC21JCYYCXYYCLF,TMC22ZLYYCXYYCLF,TMC23SSYYCXYYCLF,TMC24QTF")
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
	s Hospital=##class(EMRservice.BL.BLSysOption).GetOptionValueByName("HospitalName")
  	s SpaceHIS=##class(EMRservice.BL.BLSysOption).GetOptionValueByName("NameSpaceHIS")
	if SpaceHIS'=""
	{
		s MEDDATA = $p($g(SpaceHIS),"^",1)
		s WEBSRC  = $p($g(SpaceHIS),"^",2)
	}
	s SpaceLIS=##class(EMRservice.BL.BLSysOption).GetOptionValueByName("NameSpaceLIS")
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
 	s PapmiDR = ##Class(EMRservice.HISInterface.PatientInfoAssist).GetPapmiDR(Adm)
 	s EpisodeNo=##Class(EMRservice.HISInterface.PatientInfoAssist).GetEpisodeNo(Adm)
 	s RegisterNo = ##Class(EMRservice.HISInterface.PatientInfoAssist).GetPapmiNo(PapmiDR)
	s Name=##Class(EMRservice.HISInterface.PatientInfoAssist).Name(PapmiDR)

	
	// 患者费用(病案费用大类)
	s InPatFee="" ,CheckTotal="" ,CheckFee="" ,CheckFeeTag=""
	s arrFee = ##Class(%ArrayOfDataTypes).%New()
	s InPatFee=##class(EMRservice.HISInterface.PatientInfoAssist).InPatCostTrakCareNew(Adm,Hospital)
	s FeeNum=$l(InPatFee,"!")
	s i=0,FeeList="",tmpFee=""
	
	f i=1:1:FeeNum 
	{
		
		s tmpFee=$p(InPatFee,"!",i)
		s FeeType=$p(tmpFee,"^",2)
		s FeeNum=$p(tmpFee,"^",3)
		d arrFee.SetAt(FeeNum,FeeType)
		
		s:(i>1) CheckFee=CheckFee+ FeeNum
		s:(i=1) CheckTotal=FeeNum
			
	}
 
 	s TMCTotal = arrFee.GetAt("总费用")
	s TMC01YBYLFWF = arrFee.GetAt("一般医疗服务费")
	s TMC02YBZLCZF = arrFee.GetAt("一般治疗操作费")
	s TMC03HLF = arrFee.GetAt("护理费")
	s TMC04QTF = arrFee.GetAt("其他费")
	s TMC05BLZDF = arrFee.GetAt("病理诊断费")
	s TMC06SYSZDF = arrFee.GetAt("实验室诊断费")
	s TMC07YXXZDF = arrFee.GetAt("影像学诊断费")
	s TMC08LCZDXMF = arrFee.GetAt("临床诊断项目费")
	s TMC09FSSZLXMF = arrFee.GetAt("非手术治疗项目费")
	s TMC10SSZLF = arrFee.GetAt("手术治疗费")
	s TMC11KFF = arrFee.GetAt("康复费")
	s TMC12ZYZLF = arrFee.GetAt("中医治疗费")
	s TMC13XYF = arrFee.GetAt("西药费")
	s TMC14ZCYF = arrFee.GetAt("中成药费")
	s TMC15ZCYF = arrFee.GetAt("中草药费")
	s TMC16XF = arrFee.GetAt("血费")
	s TMC17BDBLZPF = arrFee.GetAt("白蛋白类制品费")
	s TMC18QDBLZPF = arrFee.GetAt("球蛋白类制品费")
	s TMC19NXYZLZPF = arrFee.GetAt("凝血因子类制品费")
	s TMC20XBYZLZPF = arrFee.GetAt("细胞因子类制品费")
	s TMC21JCYYCXYYCLF = arrFee.GetAt("检查用一次性医用材料费")
	s TMC22ZLYYCXYYCLF = arrFee.GetAt("治疗用一次性医用材料费")
	s TMC23SSYYCXYYCLF = arrFee.GetAt("手术用一次性医用材料费")
	s TMC24QTF = arrFee.GetAt("其他费用")
 
 
	// 费用合计与费用子项审核
	i $fn(CheckTotal,"",2)'=$fn(CheckFee,"",2) { s CheckFeeTag="CheckFeeERROR" } else {s CheckFeeTag="CheckFeeOK" }
	


	set ^CacheTemp(repid, ind) = $LB(EpisodeID,PapmiDR,EpisodeNo,RegisterNo,Name,TMCTotal,TMC01YBYLFWF,TMC02YBZLCZF,TMC03HLF,TMC04QTF,TMC05BLZDF,TMC06SYSZDF,TMC07YXXZDF,TMC08LCZDXMF,TMC09FSSZLXMF,TMC10SSZLF,TMC11KFF,TMC12ZYZLF,TMC13XYF,TMC14ZCYF,TMC15ZCYF,TMC16XF,TMC17BDBLZPF,TMC18QDBLZPF,TMC19NXYZLZPF,TMC20XBYZLZPF,TMC21JCYYCXYYCLF,TMC22ZLYYCXYYCLF,TMC23SSYYCXYYCLF,TMC24QTF)
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
/// Desc：		取用户登录信息[HIS]-09 200908OK
/// Input:		UserId: SS_User rowid
/// Return：
/// d ##class(%ResultSet).RunQuery("EMRservice.SystemData","GetUserInfo","3691348")
Query GetUserInfo(parUserId As %String) As %SQLQuery(CONTAINID = 0)
{
	SELECT SSUSR_Initials as CurUserCode ,SSUSR_Name as CurUserName ,SSUSR_RowId||'^'||SSUSR_Initials||'^'||SSUSR_Name as CurUserDict
	FROM   SQLUser.SS_User
	WHERE  SSUSR_Rowid=:parUserId
}

/// ////////////////////////////////////////////////////////////////////////////////////////////////
/// Creator：	EPR
/// CreateDate：2009-03-16
/// Desc：		取用户自定义信息[HIS]-10 200908OK
/// Input:		Adm: 就诊rowid
/// Return：
/// Test:		##Class(EMRservice.SystemData).tescus(Adm)		
Query GetCustomInfo(Adm As %String) As %Query(ROWSPEC = "EpisodeID,PapmiDR,EpisodeNo,RegisterNo,Name,HospitalName,OpOeord,CNOrder,OpDiag,VentilatorHour,OpDiagH")
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
	s Hospital=##class(EMRservice.BL.BLSysOption).GetOptionValueByName("HospitalName")
  	s SpaceHIS=##class(EMRservice.BL.BLSysOption).GetOptionValueByName("NameSpaceHIS")
	if SpaceHIS'=""
	{
		s MEDDATA = $p($g(SpaceHIS),"^",1)
		s WEBSRC  = $p($g(SpaceHIS),"^",2)
	}
	s SpaceLIS=##class(EMRservice.BL.BLSysOption).GetOptionValueByName("NameSpaceLIS")
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
 	s PapmiDR = ##Class(EMRservice.HISInterface.PatientInfoAssist).GetPapmiDR(Adm)
 	s EpisodeNo=##Class(EMRservice.HISInterface.PatientInfoAssist).GetEpisodeNo(Adm)
 	s RegisterNo = ##Class(EMRservice.HISInterface.PatientInfoAssist).GetPapmiNo(PapmiDR)
	s Name=##Class(EMRservice.HISInterface.PatientInfoAssist).Name(PapmiDR)
	
	
	s HospitalName = ##class(EMRservice.HISInterface.PatientInfoAssist).HospitalName(Adm)
	
	
	s OpOeord = ##Class(EMRservice.BL.opInterface).getOeordXH(Adm,"","\r\n")
	s CNOrder = ##Class(EMRservice.BL.opInterfaceBase).getOeordXH(Adm,"CHMED","\r\n")
	s OpDiag = ##Class(EMRservice.BL.opInterfaceBase).getDiagDataXH(Adm,"\r\n")
	s OpDiagH = ##Class(EMRservice.BL.opInterfaceBase).getDiagDataXH(Adm,";")
	
	s VentilatorHour = ""
	//监护仪使用时长
	s VentilatorHour=##class(web.DHCICUStat).GetVentilatorHour(Adm,"NoninvasiveVentilatorHour")
	//取最新的一条记录
	s VentilatorHour=$p(VentilatorHour,"@",$l(VentilatorHour,"@"))

	set ^CacheTemp(repid, ind) = $LB(EpisodeID,PapmiDR,EpisodeNo,RegisterNo,Name,HospitalName,OpOeord,CNOrder,OpDiag,VentilatorHour,OpDiagH)
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

/// =================== Query GetOperationInfo =====================================
/// CreateUser:	YK
/// CreateTime：2022-04-22
/// Desc：		取手术信息
/// Input:		argAdm：就诊RowId		
/// Debug:		d ##class(%ResultSet).RunQuery("EMRservice.SystemData","GetAnOperInfo","9")
Query GetAnOperInfo(argAdm As %String) As %Query(ROWSPEC = "AOperID1,AOperID2,AOperID3,AOperID4,AOperID5,AOperID6,AOperID7,AOperID8,AOperID9,AOperID10,OperDict1,OperDict2,OperDict3,OperDict4,OperDict5,OperDict6,OperDict7,OperDict8,OperDict9,OperDict10,OperDate1,OperDate2,OperDate3,OperDate4,OperDate5,OperDate6,OperDate7,OperDate8,OperDate9,OperDate10,OperEndDate1,OperEndDate2,OperEndDate3,OperEndDate4,OperEndDate5,OperEndDate6,OperEndDate7,OperEndDate8,OperEndDate9,OperEndDate10,OperLevel1,OperLevel2,OperLevel3,OperLevel4,OperLevel5,OperLevel6,OperLevel7,OperLevel8,OperLevel9,OperLevel10,OperDoc1,OperDoc2,OperDoc3,OperDoc4,OperDoc5,OperDoc6,OperDoc7,OperDoc8,OperDoc9,OperDoc10,AssistantFirst1,AssistantFirst2,AssistantFirst3,AssistantFirst4,AssistantFirst5,AssistantFirst6,AssistantFirst7,AssistantFirst8,AssistantFirst9,AssistantFirst10,AssistantSecond1,AssistantSecond2,AssistantSecond3,AssistantSecond4,AssistantSecond5,AssistantSecond6,AssistantSecond7,AssistantSecond8,AssistantSecond9,AssistantSecond10,AnaMethod1,AnaMethod2,AnaMethod3,AnaMethod4,AnaMethod5,AnaMethod6,AnaMethod7,AnaMethod8,AnaMethod9,AnaMethod10,AnaDoctor1,AnaDoctor2,AnaDoctor3,AnaDoctor4,AnaDoctor5,AnaDoctor6,AnaDoctor7,AnaDoctor8,AnaDoctor9,AnaDoctor10,AOperIDLast,OperDictLast,OperDateLast,OperEndDateLast,OperLevelLast,OperDocLast,AssistantFirstLast,AssistantSecondLast,AnaMethodLast,AnaDoctorLast")
{
}

ClassMethod GetAnOperInfoExecute(ByRef qHandle As %Binary, argAdm As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	Set qHandle=$lb(0,repid,0)
	
	//手术ID
	s (AOperID1,AOperID2,AOperID3,AOperID4,AOperID5,AOperID6,AOperID7,AOperID8,AOperID9,AOperID10)=""
	
	//手术名称（字典）
	s (OperDict1,OperDict2,OperDict3,OperDict4,OperDict5,OperDict6,OperDict7,OperDict8,OperDict9,OperDict10)=""
	
	//手术开始时间、手术结束时间
	s (OperDate1,OperDate2,OperDate3,OperDate4,OperDate5,OperDate6,OperDate7,OperDate8,OperDate9,OperDate10)=""
	s (OperEndDate1,OperEndDate2,OperEndDate3,OperEndDate4,OperEndDate5,OperEndDate6,OperEndDate7,OperEndDate8,OperEndDate9,OperEndDate10)=""
	
	//手术级别
	s (OperLevel1,OperLevel2,OperLevel3,OperLevel4,OperLevel5,OperLevel6,OperLevel7,OperLevel8,OperLevel9,OperLevel10)=""
	
	//术者
	s (OperDoc1,OperDoc2,OperDoc3,OperDoc4,OperDoc5,OperDoc6,OperDoc7,OperDoc8,OperDoc9,OperDoc10)=""
	
	//一助
	s (AssistantFirst1,AssistantFirst2,AssistantFirst3,AssistantFirst4,AssistantFirst5,AssistantFirst6,AssistantFirst7,AssistantFirst8,AssistantFirst9,AssistantFirst10)=""
	
	//二助
	s (AssistantSecond1,AssistantSecond2,AssistantSecond3,AssistantSecond4,AssistantSecond5,AssistantSecond6,AssistantSecond7,AssistantSecond8,AssistantSecond9,AssistantSecond10)=""
	
	//麻醉方式
	s (AnaMethod1,AnaMethod2,AnaMethod3,AnaMethod4,AnaMethod5,AnaMethod6,AnaMethod7,AnaMethod8,AnaMethod9,AnaMethod10)=""
	
	//麻醉医师
	s (AnaDoctor1,AnaDoctor2,AnaDoctor3,AnaDoctor4,AnaDoctor5,AnaDoctor6,AnaDoctor7,AnaDoctor8,AnaDoctor9,AnaDoctor10)=""	
	
	//Last
	s (AOperIDLast,OperDictLast,OperDateLast,OperEndDateLast,OperLevelLast,OperDocLast,AssistantFirstLast,AssistantSecondLast,AnaMethodLast,AnaDoctorLast)=""
	
	s OperStr = ##Class(EMRservice.HISInterface.PatientInfoAssist).GetANOperInfo(argAdm)
	s OperInfo1 = $P(OperStr,"#",1)
	s OperInfo2 = $P(OperStr,"#",2)
	s OperInfo3 = $P(OperStr,"#",3)
	s OperInfo4 = $P(OperStr,"#",4)
	s OperInfo5 = $P(OperStr,"#",5)
	s OperInfo6 = $P(OperStr,"#",6)
	s OperInfo7 = $P(OperStr,"#",7)
	s OperInfo8 = $P(OperStr,"#",8)
	s OperInfo9 = $P(OperStr,"#",9)
	s OperInfo10 = $P(OperStr,"#",10)
	
	// 获取最新的一条手术信息
	s OperLength = $L(OperStr,"#")
	s OperInfoLast = $P(OperStr,"#",OperLength)
	
	// 手术记录信息从手麻重症系统提取
	if (OperInfoLast '= "")
	{
		s AOperIDLast = $P(OperInfoLast,"@",1)
		// 手术名称
		s OperDictLast = $P(OperInfoLast,"@",2)
		// 手术开始日期时间
		s OperDateLast = $P(OperInfoLast,"@",3)
		// 手术结束日期时间
		s OperEndDateLast = $P(OperInfoLast,"@",4)
		// 手术级别
		s OperLevelLast = $P(OperInfoLast,"@",24)
		// 手术医生
		s OperDocLast = $P(OperInfoLast,"@",8)
		// 一助
		s AssistantFirstLast = $P(OperInfoLast,"@",9)
		// 二助
		s AssistantSecondLast = $P(OperInfoLast,"@",10)
		// 麻醉方式
		s AnaMethodLast = $P(OperInfoLast,"@",17)
		// 麻醉医生
		s AnaDoctorLast = $P(OperInfoLast,"@",19)
	}
	if (OperInfo1 '= "")
	{
		s AOperID1 = $P(OperInfo1,"@",1)
		// 手术名称
		s OperDict1 = $P(OperInfo1,"@",2)
		// 手术开始日期时间
		s OperDate1 = $P(OperInfo1,"@",3)
		// 手术结束日期时间
		s OperEndDate1 = $P(OperInfo1,"@",4)
		// 手术级别
		s OperLevel1 = $P(OperInfo1,"@",24)
		// 手术医生
		s OperDoc1 = $P(OperInfo1,"@",8)
		// 一助
		s AssistantFirst1 = $P(OperInfo1,"@",9)
		// 二助
		s AssistantSecond1 = $P(OperInfo1,"@",10)
		// 麻醉方式
		s AnaMethod1 = $P(OperInfo1,"@",17)
		// 麻醉医生
		s AnaDoctor1 = $P(OperInfo1,"@",19)
	}
	if (OperInfo2 '= "")
	{
		s AOperID2 = $P(OperInfo2,"@",1)
		// 手术名称
		s OperDict2 = $P(OperInfo2,"@",2)
		// 手术开始日期时间
		s OperDate2 = $P(OperInfo2,"@",3)
		// 手术结束日期时间
		s OperEndDate2 = $P(OperInfo2,"@",4)
		// 手术级别
		s OperLevel2 = $P(OperInfo2,"@",24)
		// 手术医生
		s OperDoc2 = $P(OperInfo2,"@",8)
		// 一助
		s AssistantFirst2 = $P(OperInfo2,"@",9)
		// 二助
		s AssistantSecond2 = $P(OperInfo2,"@",10)
		// 麻醉方式
		s AnaMethod2 = $P(OperInfo2,"@",17)
		// 麻醉医生
		s AnaDoctor2 = $P(OperInfo2,"@",19)
	}
	if (OperInfo3 '= "")
	{
		s AOperID3 = $P(OperInfo3,"@",1)
		// 手术名称
		s OperDict3 = $P(OperInfo3,"@",2)
		// 手术开始日期时间
		s OperDate3 = $P(OperInfo3,"@",3)
		// 手术结束日期时间
		s OperEndDate3 = $P(OperInfo3,"@",4)
		// 手术级别
		s OperLevel3 = $P(OperInfo3,"@",24)
		// 手术医生
		s OperDoc3 = $P(OperInfo3,"@",8)
		// 一助
		s AssistantFirst3 = $P(OperInfo3,"@",9)
		// 二助
		s AssistantSecond3 = $P(OperInfo3,"@",10)
		// 麻醉方式
		s AnaMethod3 = $P(OperInfo3,"@",17)
		// 麻醉医生
		s AnaDoctor3 = $P(OperInfo3,"@",19)
	}
	if (OperInfo4 '= "")
	{
		s AOperID4 = $P(OperInfo4,"@",1)
		// 手术名称
		s OperDict4 = $P(OperInfo4,"@",2)
		// 手术开始日期时间
		s OperDate4 = $P(OperInfo4,"@",3)
		// 手术结束日期时间
		s OperEndDate4 = $P(OperInfo4,"@",4)
		// 手术级别
		s OperLevel4 = $P(OperInfo4,"@",24)
		// 手术医生
		s OperDoc4 = $P(OperInfo4,"@",8)
		// 一助
		s AssistantFirst4 = $P(OperInfo4,"@",9)
		// 二助
		s AssistantSecond4 = $P(OperInfo4,"@",10)
		// 麻醉方式
		s AnaMethod4 = $P(OperInfo4,"@",17)
		// 麻醉医生
		s AnaDoctor4 = $P(OperInfo4,"@",19)
	}
	if (OperInfo5 '= "")
	{
		s AOperID5 = $P(OperInfo5,"@",1)
		// 手术名称
		s OperDict5 = $P(OperInfo5,"@",2)
		// 手术开始日期时间
		s OperDate5 = $P(OperInfo5,"@",3)
		// 手术结束日期时间
		s OperEndDate5 = $P(OperInfo5,"@",4)
		// 手术级别
		s OperLevel5 = $P(OperInfo5,"@",24)
		// 手术医生
		s OperDoc5 = $P(OperInfo5,"@",8)
		// 一助
		s AssistantFirst5 = $P(OperInfo5,"@",9)
		// 二助
		s AssistantSecond5 = $P(OperInfo5,"@",10)
		// 麻醉方式
		s AnaMethod5 = $P(OperInfo5,"@",17)
		// 麻醉医生
		s AnaDoctor5 = $P(OperInfo5,"@",19)
	}
	if (OperInfo6 '= "")
	{
		s AOperID6 = $P(OperInfo6,"@",1)
		// 手术名称
		s OperDict6 = $P(OperInfo6,"@",2)
		// 手术开始日期时间
		s OperDate6 = $P(OperInfo6,"@",3)
		// 手术结束日期时间
		s OperEndDate6 = $P(OperInfo6,"@",4)
		// 手术级别
		s OperLevel6 = $P(OperInfo6,"@",24)
		// 手术医生
		s OperDoc6 = $P(OperInfo6,"@",8)
		// 一助
		s AssistantFirst6 = $P(OperInfo6,"@",9)
		// 二助
		s AssistantSecond6 = $P(OperInfo6,"@",10)
		// 麻醉方式
		s AnaMethod6 = $P(OperInfo6,"@",17)
		// 麻醉医生
		s AnaDoctor6 = $P(OperInfo6,"@",19)
	}
	if (OperInfo7 '= "")
	{
		s AOperID7 = $P(OperInfo7,"@",1)
		// 手术名称
		s OperDict7 = $P(OperInfo7,"@",2)
		// 手术开始日期时间
		s OperDate7 = $P(OperInfo7,"@",3)
		// 手术结束日期时间
		s OperEndDate7 = $P(OperInfo7,"@",4)
		// 手术级别
		s OperLevel7 = $P(OperInfo7,"@",24)
		// 手术医生
		s OperDoc7 = $P(OperInfo7,"@",8)
		// 一助
		s AssistantFirst7 = $P(OperInfo7,"@",9)
		// 二助
		s AssistantSecond7 = $P(OperInfo7,"@",10)
		// 麻醉方式
		s AnaMethod7 = $P(OperInfo7,"@",17)
		// 麻醉医生
		s AnaDoctor7 = $P(OperInfo7,"@",19)
	}
	if (OperInfo8 '= "")
	{
		s AOperID8 = $P(OperInfo8,"@",1)
		// 手术名称
		s OperDict8 = $P(OperInfo8,"@",2)
		// 手术开始日期时间
		s OperDate8 = $P(OperInfo8,"@",3)
		// 手术结束日期时间
		s OperEndDate8 = $P(OperInfo8,"@",4)
		// 手术级别
		s OperLevel8 = $P(OperInfo8,"@",24)
		// 手术医生
		s OperDoc8 = $P(OperInfo8,"@",8)
		// 一助
		s AssistantFirst8 = $P(OperInfo8,"@",9)
		// 二助
		s AssistantSecond8 = $P(OperInfo8,"@",10)
		// 麻醉方式
		s AnaMethod8 = $P(OperInfo8,"@",17)
		// 麻醉医生
		s AnaDoctor8 = $P(OperInfo8,"@",19)
	}
	if (OperInfo9 '= "")
	{
		s AOperID9 = $P(OperInfo9,"@",1)
		// 手术名称
		s OperDict9 = $P(OperInfo9,"@",2)
		// 手术开始日期时间
		s OperDate9 = $P(OperInfo9,"@",3)
		// 手术结束日期时间
		s OperEndDate9 = $P(OperInfo9,"@",4)
		// 手术级别
		s OperLevel9 = $P(OperInfo9,"@",24)
		// 手术医生
		s OperDoc9 = $P(OperInfo9,"@",8)
		// 一助
		s AssistantFirst9 = $P(OperInfo9,"@",9)
		// 二助
		s AssistantSecond9 = $P(OperInfo9,"@",10)
		// 麻醉方式
		s AnaMethod9 = $P(OperInfo9,"@",17)
		// 麻醉医生
		s AnaDoctor9 = $P(OperInfo9,"@",19)
	}
	if (OperInfo10 '= "")
	{
		s AOperID10 = $P(OperInfo10,"@",1)
		// 手术名称
		s OperDict10 = $P(OperInfo10,"@",2)
		// 手术开始日期时间
		s OperDate10 = $P(OperInfo10,"@",3)
		// 手术结束日期时间
		s OperEndDate10 = $P(OperInfo10,"@",4)
		// 手术级别
		s OperLevel10 = $P(OperInfo10,"@",24)
		// 手术医生
		s OperDoc10 = $P(OperInfo10,"@",8)
		// 一助
		s AssistantFirst10 = $P(OperInfo10,"@",9)
		// 二助
		s AssistantSecond10 = $P(OperInfo10,"@",10)
		// 麻醉方式
		s AnaMethod10 = $P(OperInfo10,"@",17)
		// 麻醉医生
		s AnaDoctor10 = $P(OperInfo10,"@",19)
	}
	
	set ^CacheTemp(repid, ind) = $LB(AOperID1,AOperID2,AOperID3,AOperID4,AOperID5,AOperID6,AOperID7,AOperID8,AOperID9,AOperID10,OperDict1,OperDict2,OperDict3,OperDict4,OperDict5,OperDict6,OperDict7,OperDict8,OperDict9,OperDict10,OperDate1,OperDate2,OperDate3,OperDate4,OperDate5,OperDate6,OperDate7,OperDate8,OperDate9,OperDate10,OperEndDate1,OperEndDate2,OperEndDate3,OperEndDate4,OperEndDate5,OperEndDate6,OperEndDate7,OperEndDate8,OperEndDate9,OperEndDate10,OperLevel1,OperLevel2,OperLevel3,OperLevel4,OperLevel5,OperLevel6,OperLevel7,OperLevel8,OperLevel9,OperLevel10,OperDoc1,OperDoc2,OperDoc3,OperDoc4,OperDoc5,OperDoc6,OperDoc7,OperDoc8,OperDoc9,OperDoc10,AssistantFirst1,AssistantFirst2,AssistantFirst3,AssistantFirst4,AssistantFirst5,AssistantFirst6,AssistantFirst7,AssistantFirst8,AssistantFirst9,AssistantFirst10,AssistantSecond1,AssistantSecond2,AssistantSecond3,AssistantSecond4,AssistantSecond5,AssistantSecond6,AssistantSecond7,AssistantSecond8,AssistantSecond9,AssistantSecond10,AnaMethod1,AnaMethod2,AnaMethod3,AnaMethod4,AnaMethod5,AnaMethod6,AnaMethod7,AnaMethod8,AnaMethod9,AnaMethod10,AnaDoctor1,AnaDoctor2,AnaDoctor3,AnaDoctor4,AnaDoctor5,AnaDoctor6,AnaDoctor7,AnaDoctor8,AnaDoctor9,AnaDoctor10,AOperIDLast,OperDictLast,OperDateLast,OperEndDateLast,OperLevelLast,OperDocLast,AssistantFirstLast,AssistantSecondLast,AnaMethodLast,AnaDoctorLast)
	
	Quit $$$OK
}

ClassMethod GetAnOperInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAnOperInfoExecute ]
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

ClassMethod GetAnOperInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAnOperInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
	Quit $$$OK
}

/// ------------------------已标准化返回值格式的类End-------------------
/// Creator:	HouJian
/// CreateDate:	2009-03-17
/// Desc:		[BOQueryDataService类的患者就诊信息接口]获取患者就诊信息
/// Input： 	ItemName: 就诊信息项的名称，对应于 [维护程序--〉工具--〉就诊数据项维护] 中的 [Adm字段名称]
///        		Adm: 患者就诊rowid
/// Return：    就诊信息项的Value(不含Code)
/// Test:		##Class(EMRservice.SystemData).GetEpisodeInfoByItemName(3691348)
ClassMethod GetEpisodeInfoByItemName(ItemName As %String, Adm As %String) As %String
{
	//b "s"
	q:($d(ItemName)=0||$d(Adm)=0) ""
		
	//取系统参数
	s Hospital=##class(EMRservice.BL.BLSysOption).GetOptionValueByName("HospitalName")
  	s SpaceHIS=##class(EMRservice.BL.BLSysOption).GetOptionValueByName("NameSpaceHIS")
	if SpaceHIS'=""
	{
		s MEDDATA = $p($g(SpaceHIS),"^",1)
		s WEBSRC  = $p($g(SpaceHIS),"^",2)
	}
	s SpaceLIS=##class(EMRservice.BL.BLSysOption).GetOptionValueByName("NameSpaceLIS")
	if SpaceLIS'=""
	{
	    s LABDATA = $p($g(SpaceLIS),"^",1)
	    s LABSRC  = $p($g(SpaceLIS),"^",2)
	 }
	 
	//参数空值判断
	q:((Hospital="")||(SpaceHIS="")||(SpaceLIS="")) $$$OK
	
	
	s ReturnValue=""
	s PapmiDR= ##class(EMRservice.HISInterface.PatientInfoAssist).GetPapmiDR(Adm) 

	
	/////////////////////////////////
	///      就诊数据项维护       ///
	/////////////////////////////////
 	
	if ItemName="EpisodeID"				///患者就诊RowID
	{
		set ReturnValue=Adm
	}
	elseif ItemName="DisDateTime"		///出院日期,返回cache内部格式,必须
	{
		set ReturnValue=##class(EMRservice.HISInterface.PatientInfoAssist).DisDateTime(Adm)
		set ReturnValue=$p(ReturnValue,",",1)
	}
	elseif ItemName="AdmDateTime"		///入院日期,返回cache内部格式，必须
	{
		set ReturnValue=##class(EMRservice.HISInterface.PatientInfoAssist).AdmDateTime(Adm,Hospital)
		set ReturnValue=$p(ReturnValue,",",1)
	}
	elseif ItemName="PayType"			///患者费用类型(TrakCare)
	{	
		set ReturnValue=##class(EMRservice.HISInterface.PatientInfoAssist).PayType(Adm)
	}
	elseif ItemName="Gender"			///性别		
	{
		set ReturnValue=##class(EMRservice.HISInterface.PatientInfoAssist).Gender(PapmiDR)
		set ReturnValue=$p(ReturnValue,"^",3)
	}	
	elseif ItemName="Marriage"			///婚姻
	{
		set ReturnValue=##class(EMRservice.HISInterface.PatientInfoAssist).Marriage(PapmiDR)
		set ReturnValue=$p(ReturnValue,"^",3)
	}		
	elseif ItemName="Birthday"			///出生日期
	{
		set ReturnValue=##class(EMRservice.HISInterface.PatientInfoAssist).Birthday(PapmiDR)
	}			
	elseif ItemName="Occupation"		///职业
	{
		set ReturnValue=##class(EMRservice.HISInterface.PatientInfoAssist).Occupation(PapmiDR,Hospital)
		set ReturnValue=$p(ReturnValue,"^",3)
	}				
	elseif ItemName="Age"				///年龄
	{
		set TempBirthDay=##class(EMRservice.HISInterface.PatientInfoAssist).Birthday(PapmiDR)	
  		set TempAdmDate=##class(EMRservice.HISInterface.PatientInfoAssist).AdmDateTime(Adm,Hospital)	
  		//病案年龄 N_"^"_岁			[RecordAge][RecordAgeUnit]
   		s ReturnValue = ##class(EMRservice.HISInterface.PatientInfoAssist).Age(Adm,TempBirthDay,TempAdmDate,2)
   		s ReturnValue = $p($g(tmpRecordAge),"^",1)

	}	
	elseif ItemName="Nation"			///民族
	{
		set ReturnValue=##class(EMRservice.HISInterface.PatientInfoAssist).Nation(PapmiDR,Hospital)
		set ReturnValue=$p(ReturnValue,"^",3)
	}	
	elseif ItemName="AdmDept"			///入院科室
	{
		set ReturnValue=##class(EMRservice.HISInterface.PatientInfoAssist).AdmDept(Adm)
		s ReturnValue=$p(ReturnValue,"^",3)	 
	}	
	elseif ItemName="AdmWard"			///入院病区
	{
		set ReturnValue=##class(EMRservice.HISInterface.PatientInfoAssist).AdmWard(Adm)
		s ReturnValue=$p(ReturnValue,"^",3)	 
	}	
	elseif ItemName="DisDept"			///出院科室
	{
		set ReturnValue=##class(EMRservice.HISInterface.PatientInfoAssist).DisDept(Adm)
		s ReturnValue=$p(ReturnValue,"^",3)	 
	}	
	elseif ItemName="DisWard"			///出院病区
	{
		set ReturnValue=##class(EMRservice.HISInterface.PatientInfoAssist).DisWard(Adm)
		s ReturnValue=$p(ReturnValue,"^",3)	 
	}	
	elseif ItemName="TransDept"			///转科
	{
		set ReturnValue=##class(EMRservice.HISInterface.PatientInfoAssist).TransDept(Adm)
	}	
	elseif ItemName="ResidentDays"		///住院天数
	{
		set ReturnValue=##class(EMRservice.HISInterface.PatientInfoAssist).ResidentDaysAdm(Adm,Hospital)

		//set TmpAdmDateTime=##class(EMRservice.HISInterface.PatientInfoAssist).AdmDateTime(Adm,Hospital)
		//set TmpDisDateTime=##class(EMRservice.HISInterface.PatientInfoAssist).DisDateTime(Adm)
		//set ReturnValue=##class(EMRservice.HISInterface.PatientInfoAssist).ResidentDays(TmpAdmDateTime,TmpDisDateTime)
	}
	elseif ItemName="BloodType"			///血型
	{
		set ReturnValue=##class(EMRservice.HISInterface.PatientInfoAssist).ImmuneExamBloodType(PapmiDR,Hospital,MEDDATA,LABDATA)
	}
	elseif ItemName="Name"				///姓名
	{
		s ReturnValue=##class(EMRservice.HISInterface.PatientInfoAssist).Name(PapmiDR)
	}
	elseif ItemName="AdmDoctor"			///管床医生
	{
		s ReturnValue=##class(EMRservice.HISInterface.PatientInfoAssist).AdmDoctor(Adm)
	}
		
	quit ReturnValue
}

/// ////////////////////////////////////////////////////////////////////////////////////////////////
/// Creator：	EPR
/// CreateDate：2009-03-16
/// Desc：		病案号自动生成
/// Input:		Adm: 就诊rowid
/// Return：	目前限于安徽省立医院使用
/// Test:		##Class(EMRservice.SystemData).testcare(Adm)	
Query GetCaseRecordNoInfo(argAdmId As %String) As %Query(ROWSPEC = "BADisDeptFromHIS:%String,DisYearFromHIS:%String,BADisDept:%String,DisYear:%String,DiagICDCode:%String,DiseaseNo:%String")
{
}

ClassMethod GetCaseRecordNoInfoExecute(ByRef qHandle As %Binary, argAdmId As %String) As %Status
{
	s qHandle=""

	q:($d(argAdmId)=0)||(argAdmId="") $$$OK
	
	s Hospital="HeFei"
 	s className = "EMRservice.HISInterface.PatientInfoAssist"

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
/// Test:		##Class(EMRservice.SystemData).testcus(Adm)	
/// d ##class(%ResultSet).RunQuery("EMRservice.SystemData","GetWMRInterface","3691348")
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
 s PapmiDR = ##Class(EMRservice.HISInterface.PatientInfoAssist).GetPapmiDR(PapmiDR)


 //EPR> 入院日期时间 PAAdm_AdmDate And PAAdm_AdmTime
 s AdmDateTime=##class(EMRservice.HISInterface.PatientInfoAssist).AdmDateTime(Adm)
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
/// [error] d ##class(%ResultSet).RunQuery("EMRservice.SystemData","GetIPBookInfo","3691348")
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
	s ClinicDept = ##class(EMRservice.HISInterface.PatientInfoAssist).AdmDept(ClinicRowId)
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
/// d ##class(%ResultSet).RunQuery("EMRservice.SystemData","GetRecordSummaryInfo","3691348")
Query GetRecordSummaryInfo(argAdm As %String) As %Query(ROWSPEC = "Summary:%String")
{
}

ClassMethod GetRecordSummaryInfoExecute(ByRef qHandle As %Binary, argAdm As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	Set qHandle=$lb(0,repid,0)

	Quit:($d(^PAADM(argAdm))=0)||(argAdm="") $$$OK

	s summary = ""
	s chartItemId = "118"      	//病案摘要的ChartItemId
	
	s ECRecordId = ##class(EMRservice.EPRinstance).GetECRecordID(argAdm,chartItemId)
	q:(ECRecordId="") $$$OK
	
	s instanceDataId = $O(^DHCEPRI.InstanceDataI("IdxECRecord",ECRecordId,""))
	q:(instanceDataId="") $$$OK
	
	s objInstance = ##class(EPRinstance.InstanceData).%OpenId(instanceDataId)
	q:(objInstance="") $$$OK
	q:(objInstance.Status="UnSave") $$$OK
	q:(objInstance.RealTemplateID="") $$$OK
	
	s templateId = objInstance.TemplateID 
	if templateId = "29"
	{	s summary = ##class(EMRservice.BOScatterData).GetEPRData("住院病历.病历摘要.内科病历.病历摘要#TYPE:Segment#TID:29#TVER:0#GCODE:G0001")}
	elseif templateId = "149"
	{	s summary = ##class(EMRservice.BOScatterData).GetEPRData("住院病历.病历摘要.神经内科病历.病历摘要#TYPE:Segment#TID:149#TVER:0#GCODE:G0001")}
	elseif templateId = "252"
	{	s summary = ##class(EMRservice.BOScatterData).GetEPRData("住院病历.病历摘要.康复科.病历摘要#TYPE:Segment#TID:252#TVER:0#GCODE:G0001")}
	elseif templateId = "265"
	{	s summary = ##class(EMRservice.BOScatterData).GetEPRData("住院病历.病历摘要.中医科病历.病历摘要#TYPE:Segment#TID:265#TVER:0#GCODE:G0001")}
	elseif templateId = "280"
	{	s summary = ##class(EMRservice.BOScatterData).GetEPRData("住院病历.病历摘要.耳鼻喉科病历.病历摘要#TYPE:Segment#TID:280#TVER:0#GCODE:G0001")}
	elseif templateId = "283"
	{	s summary = ##class(EMRservice.BOScatterData).GetEPRData("住院病历.病历摘要.心理卫生病历.病历摘要#TYPE:Segment#TID:283#TVER:0#GCODE:G0001")}
	elseif templateId = "284"
	{	s summary = ##class(EMRservice.BOScatterData).GetEPRData("住院病历.病历摘要.眼科病历.病历摘要#TYPE:Segment#TID:284#TVER:0#GCODE:G0001")}
	elseif templateId = "285"
	{	s summary = ##class(EMRservice.BOScatterData).GetEPRData("住院病历.病历摘要.外科病历.病历摘要#TYPE:Segment#TID:285#TVER:0#GCODE:G0001")}
	elseif templateId = "290"
	{	s summary = ##class(EMRservice.BOScatterData).GetEPRData("住院病历.病历摘要.神外肿瘤.病历摘要#TYPE:Segment#TID:290#TVER:0#GCODE:G0001")}
	elseif templateId = "291"
	{	s summary = ##class(EMRservice.BOScatterData).GetEPRData("住院病历.病历摘要.颅脑损伤.病历摘要#TYPE:Segment#TID:291#TVER:0#GCODE:G0001")}
	
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
	
	s ECRecordId = ##class(EMRservice.EPRinstance).GetECRecordID(argAdm,chartItemId)
	q:(ECRecordId="") $$$OK
	
	s instanceDataId = $O(^DHCEPRI.InstanceDataI("IdxECRecord",ECRecordId,""))
	q:(instanceDataId="") $$$OK
	
	s objInstance = ##class(EPRinstance.InstanceData).%OpenId(instanceDataId)
	q:(objInstance="") $$$OK
	q:(objInstance.Status="UnSave") $$$OK
	q:(objInstance.TemplateID="") $$$OK
	
	s templateId = objInstance.TemplateID 
	if templateId = "29"
	{	s summary = ##class(EMRservice.BOScatterData).GetEPRData("住院病历.病历摘要.内科病历.病历摘要#TYPE:Segment#TID:29#TVER:0#GCODE:G0001")}
	elseif templateId = "149"
	{	s summary = ##class(EMRservice.BOScatterData).GetEPRData("住院病历.病历摘要.神经内科病历.病历摘要#TYPE:Segment#TID:149#TVER:0#GCODE:G0001")}
	elseif templateId = "252"
	{	s summary = ##class(EMRservice.BOScatterData).GetEPRData("住院病历.病历摘要.康复科.病历摘要#TYPE:Segment#TID:252#TVER:0#GCODE:G0001")}
	elseif templateId = "265"
	{	s summary = ##class(EMRservice.BOScatterData).GetEPRData("住院病历.病历摘要.中医科病历.病历摘要#TYPE:Segment#TID:265#TVER:0#GCODE:G0001")}
	elseif templateId = "280"
	{	s summary = ##class(EMRservice.BOScatterData).GetEPRData("住院病历.病历摘要.耳鼻喉科病历.病历摘要#TYPE:Segment#TID:280#TVER:0#GCODE:G0001")}
	elseif templateId = "283"
	{	s summary = ##class(EMRservice.BOScatterData).GetEPRData("住院病历.病历摘要.心理卫生病历.病历摘要#TYPE:Segment#TID:283#TVER:0#GCODE:G0001")}
	elseif templateId = "284"
	{	s summary = ##class(EMRservice.BOScatterData).GetEPRData("住院病历.病历摘要.眼科病历.病历摘要#TYPE:Segment#TID:284#TVER:0#GCODE:G0001")}
	elseif templateId = "285"
	{	s summary = ##class(EMRservice.BOScatterData).GetEPRData("住院病历.病历摘要.外科病历.病历摘要#TYPE:Segment#TID:285#TVER:0#GCODE:G0001")}
	elseif templateId = "290"
	{	s summary = ##class(EMRservice.BOScatterData).GetEPRData("住院病历.病历摘要.神外肿瘤.病历摘要#TYPE:Segment#TID:290#TVER:0#GCODE:G0001")}
	elseif templateId = "291"
	{	s summary = ##class(EMRservice.BOScatterData).GetEPRData("住院病历.病历摘要.颅脑损伤.病历摘要#TYPE:Segment#TID:291#TVER:0#GCODE:G0001")}*/
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
/// Test:		##Class(EMRservice.SystemData).testinstance(Adm,CID)	
/// 			d ##class(%ResultSet).RunQuery("EMRservice.SystemData","GetOtherInstanceDataInfo","21","54")
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
	    s templateID = objInstance.RealTemplateID
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
			s dateTime = ##class(EMRservice.BOScatterData).GetMultipleScatterData(aEpisodeID, templateID, "D0002", instanceID, "V")
			s careLevel = ##class(EMRservice.BOScatterData).GetMultipleScatterData(aEpisodeID, templateID, "O0003", instanceID, "V")
			s diet = ##class(EMRservice.BOScatterData).GetMultipleScatterData(aEpisodeID, templateID, "O0004", instanceID, "V")
			s bodyPos = ##class(EMRservice.BOScatterData).GetMultipleScatterData(aEpisodeID, templateID, "M0006", instanceID, "V")
			s conObsence = ##class(EMRservice.BOScatterData).GetMultipleScatterData(aEpisodeID, templateID, "M0022", instanceID, "V")
			s basisCare = ##class(EMRservice.BOScatterData).GetMultipleScatterData(aEpisodeID, templateID, "M0008", instanceID, "V")
			s pipeCare = ##class(EMRservice.BOScatterData).GetMultipleScatterData(aEpisodeID, templateID, "M0013", instanceID, "V")
			s currentRecord = ##class(EMRservice.BOScatterData).GetMultipleScatterData(aEpisodeID, templateID, "M0015", instanceID, "V")
			s other = ##class(EMRservice.BOScatterData).GetMultipleScatterData(aEpisodeID, templateID, "G0023", instanceID, "V")
			s nurse = ##class(EMRservice.BOScatterData).GetMultipleScatterData(aEpisodeID, templateID, "I0020", instanceID, "V")
			s nurseCap = ##class(EMRservice.BOScatterData).GetMultipleScatterData(aEpisodeID, templateID, "I0021", instanceID, "V")
		    
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
			    s patID = ##class(EMRservice.BOScatterData).GetMultipleScatterData(aEpisodeID, templateID, "S0012", instanceID, "V")
			    s bed = ##class(EMRservice.BOScatterData).GetMultipleScatterData(aEpisodeID, templateID, "S0009", instanceID, "V")
			    s name = ##class(EMRservice.BOScatterData).GetMultipleScatterData(aEpisodeID, templateID, "S0010", instanceID, "V")
			    s age = ##class(EMRservice.BOScatterData).GetMultipleScatterData(aEpisodeID, templateID, "S0011", instanceID, "V")    
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
/// Test:		d ##class(%ResultSet).RunQuery("EMRservice.SystemData","GetInstanceOper","21","54")		
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
	
	s UserNames = ##class(EMRservice.BOEPRLogs).GetAllUserByAction(aAdm,,printTmplateDocID,eprNum,"save^complete")
	
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
/// d ##class(%ResultSet).RunQuery("EMRservice.SystemData","GetInstanceDataInfo","56","48")
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
			s tid = objInstance.RealTemplateID
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
	s ^DHCEPRDebug("EMRservice.SystemData","retVal") = retVal
	s ^DHCEPRDebug("EMRservice.SystemData","chartItemID") = aChartItemID
	s ^DHCEPRDebug("EMRservice.SystemData","EpisodeID") = aEpisodeID
	s ^DHCEPRDebug("EMRservice.SystemData","ECRecord") = ECRecordID
	s ^DHCEPRDebug("EMRservice.SystemData","DateToday") = $zd($h,3)
	s ^DHCEPRDebug("EMRservice.SystemData","DateGroupBegin") = dateGroupBegin
	s ^DHCEPRDebug("EMRservice.SystemData","DateGroupCount") = dateGroupCount
	s ^DHCEPRDebug("EMRservice.SystemData","createDateGroup") = createDateGroup
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
	 		s patID = ##class(EMRservice.BOScatterData).GetMultipleScatterData(aEpisodeID, templateID, "S0012", instanceID, "V")
		   	s bed = ##class(EMRservice.BOScatterData).GetMultipleScatterData(aEpisodeID, templateID, "S0001", instanceID, "V")
		   	s name = ##class(EMRservice.BOScatterData).GetMultipleScatterData(aEpisodeID, templateID, "S0002", instanceID, "V")
		   	s age = ##class(EMRservice.BOScatterData).GetMultipleScatterData(aEpisodeID, templateID, "S0011", instanceID, "V")    
	 	}
	 			
		s dateTime = ##class(EMRservice.BOScatterData).GetMultipleScatterData(aEpisodeID, templateID, "D0005", instanceID, "V")
		s T = ##class(EMRservice.BOScatterData).GetMultipleScatterData(aEpisodeID, templateID, "S0006", instanceID, "V")
		s P = ##class(EMRservice.BOScatterData).GetMultipleScatterData(aEpisodeID, templateID, "S0007", instanceID, "V")
		s R= ##class(EMRservice.BOScatterData).GetMultipleScatterData(aEpisodeID, templateID, "S0008", instanceID, "V")
		s BP = ##class(EMRservice.BOScatterData).GetMultipleScatterData(aEpisodeID, templateID, "S0009", instanceID, "V")
		s ShuZhangYa = ##class(EMRservice.BOScatterData).GetMultipleScatterData(aEpisodeID, templateID, "S0021", instanceID, "V")
		s Spo2 = ##class(EMRservice.BOScatterData).GetMultipleScatterData(aEpisodeID, templateID, "S0022", instanceID, "V")
		s NiaoLiang = ##class(EMRservice.BOScatterData).GetMultipleScatterData(aEpisodeID, templateID, "S0014", instanceID, "V")
		s YinDaoLiuXue = ##class(EMRservice.BOScatterData).GetMultipleScatterData(aEpisodeID, templateID, "S0015", instanceID, "V")
		s FuYaYinLiu = ##class(EMRservice.BOScatterData).GetMultipleScatterData(aEpisodeID, templateID, "S0016", instanceID, "V")			
		s WeiGuanYinLiu = ##class(EMRservice.BOScatterData).GetMultipleScatterData(aEpisodeID, templateID, "S0017", instanceID, "V")
		s SheRu = ##class(EMRservice.BOScatterData).GetMultipleScatterData(aEpisodeID, templateID, "S0018", instanceID, "V")
		s GuanChaJiLu = ##class(EMRservice.BOScatterData).GetMultipleScatterData(aEpisodeID, templateID, "E0019", instanceID, "V")			
		s nurse = ##class(EMRservice.BOScatterData).GetMultipleScatterData(aEpisodeID, templateID, "I0020", instanceID, "V")
					
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
/// Debug:		d ##class(%ResultSet).RunQuery("EMRservice.SystemData","GetOperationInfo","2653342")
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
	
	s rset=##class(%ResultSet).%New("EMRservice.HISInterface.PatientInfoAssist:FindOrderItems")
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
/// Debug:		d ##class(%ResultSet).RunQuery("EMRservice.SystemData","GetBirthAddInfo","2671627")
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
	q:(objInstance.RealTemplateID="") $$$OK
	
	s templateId = objInstance.RealTemplateID
	if templateId = "15"   ///内科病历     
	{	s BirthAddPro = ##class(EMRservice.BOScatterData).GetEPRData(argAdm,"#TYPE:Simple#TID:15#TVER:0#SCODE:I0029#VTYPE:V")
	    s BirthAddCityAr = ##class(EMRservice.BOScatterData).GetEPRData(argAdm,"县#TYPE:Simple#TID:15#TVER:0#SCODE:S0028#VTYPE:V")
	 }
	elseif templateId = "36"  ///	心理卫生病历  
	{	s BirthAddPro = ##class(EMRservice.BOScatterData).GetEPRData(argAdm,"心理卫生病历.出生地省（市）#TYPE:Simple#TID:36#TVER:0#SCODE:I0045#VTYPE:V")
		s BirthAddCityAr = ##class(EMRservice.BOScatterData).GetEPRData(argAdm,"心理卫生病历.出生地县#TYPE:Simple#TID:36#TVER:0#SCODE:S0044#VTYPE:V")
    }
	elseif templateId = "56"   ///	眼科病历  
	{	s BirthAddPro = ##class(EMRservice.BOScatterData).GetEPRData(argAdm,"眼科病历.出生地省（市）#TYPE:Simple#TID:56#TVER:0#SCODE:I0029#VTYPE:V")
		s BirthAddCityAr = ##class(EMRservice.BOScatterData).GetEPRData(argAdm,"眼科病历.出生地县#TYPE:Simple#TID:56#TVER:0#SCODE:S0001#VTYPE:V")
    }
	elseif templateId = "82"   //	耳鼻喉科病历  
	{	s BirthAddPro = ##class(EMRservice.BOScatterData).GetEPRData(argAdm,"耳鼻喉科病历.出生地省（市）#TYPE:Simple#TID:82#TVER:0#SCODE:I0029#VTYPE:V")
	s BirthAddCityAr = ##class(EMRservice.BOScatterData).GetEPRData(argAdm,"耳鼻喉科病历.出生地县#TYPE:Simple#TID:82#TVER:0#SCODE:S0028#VTYPE:V")
	}
	elseif templateId = "101"  //	外科病历 
	{	s BirthAddPro = ##class(EMRservice.BOScatterData).GetEPRData(argAdm,"外科病历.出生地省（市）#TYPE:Simple#TID:101#TVER:0#SCODE:I0029#VTYPE:V")
	s BirthAddCityAr = ##class(EMRservice.BOScatterData).GetEPRData(argAdm,"外科病历.出生地县#TYPE:Simple#TID:101#TVER:0#SCODE:S0028#VTYPE:V")
	}
	elseif templateId = "127"  //	神经内科病历 
	{	s BirthAddPro = ##class(EMRservice.BOScatterData).GetEPRData(argAdm,"神经内科病历.出生地省（市）#TYPE:Simple#TID:127#TVER:0#SCODE:I0028#VTYPE:V")
	s BirthAddCityAr = ##class(EMRservice.BOScatterData).GetEPRData(argAdm,"神经内科病历.出生地县#TYPE:Simple#TID:127#TVER:0#SCODE:S0001#VTYPE:V")
	}
	elseif templateId = "154"  //	颅脑损伤    
	{	s BirthAddPro = ##class(EMRservice.BOScatterData).GetEPRData(argAdm,"颅脑损伤.出生地省（市）#TYPE:Simple#TID:154#TVER:0#SCODE:I0029#VTYPE:V")
	s BirthAddCityAr = ##class(EMRservice.BOScatterData).GetEPRData(argAdm,"颅脑损伤.出生地县#TYPE:Simple#TID:154#TVER:0#SCODE:S0028#VTYPE:V")
	}
	elseif templateId = "184"  //	中医科病历
	{	s BirthAddPro = ##class(EMRservice.BOScatterData).GetEPRData(argAdm,"中医科病历.出生地省（市）#TYPE:Simple#TID:184#TVER:0#SCODE:I0029#VTYPE:V")
	s BirthAddCityAr = ##class(EMRservice.BOScatterData).GetEPRData(argAdm,"中医科病历.出生地县#TYPE:Simple#TID:184#TVER:0#SCODE:S0028#VTYPE:V")
	}
	elseif templateId = "206"  //	神外肿瘤 
	{	s BirthAddPro = ##class(EMRservice.BOScatterData).GetEPRData(argAdm,"神外肿瘤.出生地省（市）#TYPE:Simple#TID:206#TVER:0#SCODE:I0030#VTYPE:V")
	s BirthAddCityAr = ##class(EMRservice.BOScatterData).GetEPRData(argAdm,"神外肿瘤.出生地县#TYPE:Simple#TID:206#TVER:0#SCODE:S0028#VTYPE:V")
	}
	elseif templateId = "238"  //	康复科
	{	s BirthAddPro = ##class(EMRservice.BOScatterData).GetEPRData(argAdm,"康复科.出生地省（市）#TYPE:Simple#TID:238#TVER:0#SCODE:I0041#VTYPE:V")
	s BirthAddCityAr = ##class(EMRservice.BOScatterData).GetEPRData(argAdm,"康复科.出生地县#TYPE:Simple#TID:238#TVER:0#SCODE:S0001#VTYPE:V")
	}
	elseif templateId = "404"  // 	内镜下治疗 
	{	s BirthAddPro = ##class(EMRservice.BOScatterData).GetEPRData(argAdm,"内镜下治疗.省（市）#TYPE:Simple#TID:404#TVER:0#SCODE:I0029#VTYPE:V")
	s BirthAddCityAr = ##class(EMRservice.BOScatterData).GetEPRData(argAdm,"内镜下治疗.县#TYPE:Simple#TID:404#TVER:0#SCODE:S0030#VTYPE:V")
	}
	elseif templateId = "426" //	金卡既往史 
	{	s BirthAddPro = ##class(EMRservice.BOScatterData).GetEPRData(argAdm,"住院病历.个人史 婚姻史 家族史.个人史.金卡个人史.Place of birth：#TYPE:Simple#TID:426#TVER:0#SCODE:S0001#VTYPE:V")
	//s BirthAddCityAr = ##class(EMRservice.BOScatterData).GetEPRData(argAdm,"住院病历.个人史 婚姻史 家族史.个人史.内科病历.出生地#TYPE:Simple#TID:15#TVER:0#SCODE:S0028#VTYPE:V")
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
/// Debug:		d ##class(%ResultSet).RunQuery("EMRservice.SystemData","GetPISRepInfo","2653342")
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
    Set rset = ##class(%ResultSet).%New("EMRservice.HISInterface.PatientInfoAssist:QueryStudyByPaadmDR")
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
/// Test: ##Class(EMRservice.SystemData).ConvertLocation(desc,type)
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

/// Debug:d ##class(EMRservice.SystemData).GetEPRDiagAndOper(5)
ClassMethod GetEPRDiagAndOper(argAdmId As %String)
{
	//电子病历组程序
    //返回值:主诊断描述^主诊断ICD代码^主诊断出院情况^手术1描述^手术1代码^手术2描述^手术2代码^手术3描述^手术3代码^手术4描述^手术4代码
	q:($d(argAdmId)=0)||(argAdmId="") ""
	s result=""
	
	///主诊断描述，主诊断代码，主诊断出院情况
	s mainDiagDesc= "", mainDiagCode="", mainDiagOut=""
	s mainDiagDesc = ##class(EMRservice.BOScatterData).GetEPRData(argAdmId,"#TYPE:Segment#TID:6#TVER:0#GCODE:G0070")
	if (mainDiagDesc="") {	s mainDiagDesc =  ##class(EMRservice.BOScatterData).GetEPRData(argAdmId,"#TYPE:SegmentSimple#TID:19#TVER:0#TCODE:G0017#SCODE:S0109#VTYPE:V")}
    s mainDiagCode = ##Class(web.DHCWMRCodingInterface).getFrontPageICD(argAdmId,"D/1",1)
    s mainDiagCode = $p($g(mainDiagCode),$c(2),1)
	s mainDiagOut = ##class(EMRservice.BOScatterData).GetEPRData(argAdmId,"#TYPE:Simple#TID:1#TVER:0#SCODE:O0062#VTYPE:V")
	;if (mainDiagOut="") {	s mainDiagOut =  ##class(EMRservice.BOScatterData).GetEPRData(argAdmId,"#TYPE:Simple#TID:22#TVER:0#SCODE:O0042#VTYPE:V")}
	
	
	///手术描述，手术代码
	s oper1Desc="", oper1Code="", oper2Desc="", oper2Code="", oper3Desc="", oper3Code="", oper4Desc="", oper4Code=""
	s oper1Desc = ##class(EMRservice.BOScatterData).GetEPRData(argAdmId,"#TYPE:Simple#TID:1#TVER:0#SCODE:I0078#VTYPE:V")
	if (oper1Desc="") {	s oper1Desc =  ##class(EMRservice.BOScatterData).GetEPRData(argAdmId,"#TYPE:Simple#TID:22#TVER:0#SCODE:I0215#VTYPE:V")}
    s oper1Code = ##Class(web.DHCWMRCodingInterface).getFrontPageICD(argAdmId,"O/1",1)
    s oper1Code = $p($g(oper1Code),$c(2),1)

	s oper2Desc = ##class(EMRservice.BOScatterData).GetEPRData(argAdmId,"#TYPE:Simple#TID:1#TVER:0#SCODE:I0087#VTYPE:V")
	if (oper2Desc="") {	s oper2Desc =  ##class(EMRservice.BOScatterData).GetEPRData(argAdmId,"#TYPE:Simple#TID:22#TVER:0#SCODE:I0214#VTYPE:V")}
	s oper2Code = ##Class(web.DHCWMRCodingInterface).getFrontPageICD(argAdmId,"O/1",2)
    s oper2Code = $p($g(oper2Code),$c(2),1)

	s oper3Desc = ##class(EMRservice.BOScatterData).GetEPRData(argAdmId,"#TYPE:Simple#TID:1#TVER:0#SCODE:I0086#VTYPE:V")
	if (oper3Desc="") {	s oper3Desc =  ##class(EMRservice.BOScatterData).GetEPRData(argAdmId,"#TYPE:Simple#TID:22#TVER:0#SCODE:I0213#VTYPE:V")}
    s oper3Code = ##Class(web.DHCWMRCodingInterface).getFrontPageICD(argAdmId,"O/1",3)
    s oper3Code = $p($g(oper3Code),$c(2),1)

	s oper4Desc = ##class(EMRservice.BOScatterData).GetEPRData(argAdmId,"#TYPE:Simple#TID:1#TVER:0#SCODE:I0085#VTYPE:V")
	if (oper4Desc="") {	s oper4Desc =  ##class(EMRservice.BOScatterData).GetEPRData(argAdmId,"#TYPE:Simple#TID:22#TVER:0#SCODE:I0212#VTYPE:V")}
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
/// Test:		##Class(EMRservice.SystemData).testcheck(Adm)		
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
	s Hospital=##class(EMRservice.BL.BLSysOption).GetOptionValueByName("HospitalName")
  	s SpaceHIS=##class(EMRservice.BL.BLSysOption).GetOptionValueByName("NameSpaceHIS")
	if SpaceHIS'=""
	{
		s MEDDATA = $p($g(SpaceHIS),"^",1)
		s WEBSRC  = $p($g(SpaceHIS),"^",2)
	}
	s SpaceLIS=##class(EMRservice.BL.BLSysOption).GetOptionValueByName("NameSpaceLIS")
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
	 s BFAdmID=##class(EMRservice.HISInterface.PatientInfoAssist).GetBFAdmID(Adm)
	 if (BFAdmID'="")
	 { 
	 	s InSts=##class(EMRservice.BOScatterData).GetEPRData(BFAdmID, InstsUnit)
	 	s DiagAndCure=##class(EMRservice.BOScatterData).GetEPRData(BFAdmID, DiagAndCureUnit)
	 	s PatSts=##class(EMRservice.BOScatterData).GetEPRData(BFAdmID, PatStsUnit)
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

/// --------------------------QueryTestMethod------Start-------------------
/// ##Class(EMRservice.SystemData).testpatinfo(Adm)
ClassMethod testpatinfo(Adm)
{
	 // Create a Result object for the Sample.Person:ByName query
	 Set rset = ##class(%ResultSet).%New("EMRservice.SystemData:GetPatientInfo")
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

/// --------------------------QueryTestMethod------Start-------------------
/// ##Class(EMRservice.SystemData).testfirstpageinfo(Adm)
ClassMethod testfirstpageinfo(Adm)
{
	 // Create a Result object for the Sample.Person:ByName query
	 Set rset = ##class(%ResultSet).%New("EMRservice.SystemData:GetFirstPageInfo")
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

/// ##Class(EMRservice.SystemData).testcliord(Adm)
ClassMethod testcliord(Adm)
{
	 // Create a Result object for the Sample.Person:ByName query
	 Set rset = ##class(%ResultSet).%New("EMRservice.SystemData:GetClinicOrdersInfo")
	 Set columns = rset.GetColumnCount()
	
	 // Execute the query
	 Set sc = rset.Execute(Adm)
	
	 // Now fetch the results
	 While (rset.Next()) {
	 Write "------------------------",!
	 For col = 1:1:columns {
	 Write rset.GetColumnName(col),": "
	 Write rset.GetData(col),!
	 //b:(GetColumnName(col)="MedAllergy")
	 }
	 Write "------------------------"
	 }
	 Do rset.Close()
}

/// ##Class(EMRservice.SystemData).testclidiag(Adm)
ClassMethod testclidiag(Adm)
{
	 // Create a Result object for the Sample.Person:ByName query
	 Set rset = ##class(%ResultSet).%New("EMRservice.SystemData:GetClinicDiagInfo")
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

/// ##Class(EMRservice.SystemData).testlabinfo(Adm)
ClassMethod testlabinfo(Adm)
{
	 // Create a Result object for the Sample.Person:ByName query
	 Set rset = ##class(%ResultSet).%New("EMRservice.SystemData:GetLabInfo")
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

/// ##Class(EMRservice.SystemData).testchkinfo(Adm)
ClassMethod testchkinfo(Adm)
{
	 // Create a Result object for the Sample.Person:ByName query
	 Set rset = ##class(%ResultSet).%New("EMRservice.SystemData:GetCheckInfo")
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

/// d ##Class(EMRservice.SystemData).testatdinfo(9963065)
ClassMethod testatdinfo(Adm)
{
	 // Create a Result object for the Sample.Person:ByName query
	 Set rset = ##class(%ResultSet).%New("EMRservice.SystemData:GetATDInfo")
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

/// ##Class(EMRservice.SystemData).testtmcinfo(Adm)
ClassMethod testtmcinfo(Adm)
{
	 // Create a Result object for the Sample.Person:ByName query
	 Set rset = ##class(%ResultSet).%New("EMRservice.SystemData:GetTMCFeeInfo")
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

/// ##Class(EMRservice.SystemData).testmcinfo(Adm)
ClassMethod testmcinfo(Adm)
{
	 // Create a Result object for the Sample.Person:ByName query
	 Set rset = ##class(%ResultSet).%New("EMRservice.SystemData:GetMCFeeInfo")
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

/// ##Class(EMRservice.SystemData).testuserinfo(Adm)
ClassMethod testuserinfo(Adm)
{
	 // Create a Result object for the Sample.Person:ByName query
	 Set rset = ##class(%ResultSet).%New("EMRservice.SystemData:GetUserInfo")
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

/// ##Class(EMRservice.SystemData).testcusinfo(1038)
ClassMethod testcusinfo(Adm)
{
	 // Create a Result object for the Sample.Person:ByName query
	 Set rset = ##class(%ResultSet).%New("EMRservice.SystemData:GetCustomInfo")
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

/// ##Class(EMRservice.SystemData).testoperinfo(Adm)
ClassMethod testoperinfo(Adm)
{
	 // Create a Result object for the Sample.Person:ByName query
	 Set rset = ##class(%ResultSet).%New("EMRservice.SystemData:GetAnOperInfo")
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

/// d ##class(EMRservice.SystemData).TestAllQuery(3691348)
ClassMethod TestAllQuery(Adm As %String)
{
	w !,"GetPatientInfo:",!
	d ##Class(EMRservice.SystemData).testpatinfo(Adm)
	w !,"GetClinicOrdersInfo:",!
	d ##Class(EMRservice.SystemData).testcliord(Adm)
	w !,"GetClinicDiagInfo:",!
	d ##Class(EMRservice.SystemData).testclidiag(Adm)
	w !,"GetLabInfo:",!
	d ##Class(EMRservice.SystemData).testlabinfo(Adm)
	w !,"GetCheckInfo:",!
	d ##Class(EMRservice.SystemData).testchkinfo(Adm)
	w !,"GetATDInfo:",!
	d ##Class(EMRservice.SystemData).testatdinfo(Adm)
	w !,"GetTMCFeeInfo:",!
	d ##Class(EMRservice.SystemData).testtmcinfo(Adm)
	w !,"GetMCFeeInfo:",!
	d ##Class(EMRservice.SystemData).testmcinfo(Adm)
	w !,"GetUserInfo:",!
	d ##Class(EMRservice.SystemData).testuserinfo(Adm)
	w !,"GetCustomInfo:",!
	d ##Class(EMRservice.SystemData).testcusinfo(Adm)
	w !,"GetAnOperInfo:",!
	d ##Class(EMRservice.SystemData).testoperinfo(Adm)
}

///               --------------------------QueryTestMethod------End-------------------
/// ---method test start
/// d ##class(EMRservice.SystemData).GetOper(8005864)
ClassMethod GetOper(AEpisodeID As %String)
{
	s opaId="",j=1
	for 
	{
		s opaId=$O(^DHCANOPArrange(0,"Adm",AEpisodeID,opaId)) 
		q:opaId=""
		q:$d(^DHCANOPArrange(opaId))<1
		//初始化数据
		s opdate="",oproomdes="",regno="",patname="",diag="",sex="",yy="",age="",opdes="",locdes="",opd="",mzdoc="",anmethod="",xsh="",xch="",OPCategory="",tAppCtcpDesc="",yg="",bg="",az="",md="",qt="",opdoc="",andoc="",FreezingSlice="",docNo="",technicalid="",technical="",asdocNo="",astechnicalid="",astechnical="",patStat="",patstatus="",BedId="",PAAdmBed="",visitstatus="",paweight="",address="",IsOrNotRelease="",pbrowid="",pbtype="",Chargestate="",xunhuino="",qixieno="",opstatus="N",xunhuino1="",xunhuino2="",locdesGroup="",eDeposit=""
		s andocNo="",operPosition="",opInterviewNur=""
		//手术起始截止时间
		s opstdate=$P(^DHCANOPArrange(opaId),"^",14)
		s opsttime=$P(^DHCANOPArrange(opaId),"^",15)
		s openddate=$P(^DHCANOPArrange(opaId),"^",16)
		s opendtime=$P(^DHCANOPArrange(opaId),"^",17)
		s opdatestr=$s(openddate'="":$ZD(opstdate,3)_" "_$zt(opsttime,2)_"~"_$zd(openddate,3)_$zt(opendtime,2),1:$ZD(opstdate,3)_" "_$zt(opsttime,2))
		s tOpStartDate=$ZD(opstdate,4),tOpStartTime=$zt(opsttime,2) 
		s nurNotes=$g(^DHCANARRAGE("opreq",opaId))
		//是否非计划再次手术
		s opUnPlanedOperation=$P(^DHCANOPArrange(opaId),"^",46) //whl 20120518
		//
		s nurNotes=$g(^DHCANARRAGE("opreq",opaId))            //for xiehe zhangtao 2011
		//
		s FreezingSlice=$P(^DHCANOPArrange(opaId),"^",56)
		s opmem=$P(^DHCANOPArrange(opaId),"^",19) 
	
		s opAppdate=$P(^DHCANOPArrange(opaId),"^",3)         //wkz 071225 S
		s opApptime=$P(^DHCANOPArrange(opaId),"^",5)
		s OpAppDateStr=$zd($G(opAppdate),3)_"  "_$zt($G(opApptime),2)  
		//安排时间
		s arrTime=$P(^DHCANOPArrange(opaId),"^",8)
		s arrDate=$P(^DHCANOPArrange(opaId),"^",7)
		//手术时间如果手术安排时间不为空取手术安排时间，否则取手术起始时间
		i (arrTime'="")  {
			s opdate=$ZD(arrDate,3)_" "_$ZT(arrTime,2)
		}
		else{
			s opdate=$ZD(opstdate,3)_" "_$zt(opsttime,2)
		}
		//手术状态
		s Stat=$P(^DHCANOPArrange(opaId),"^",27)
		//手术状态转译
		i Stat="A" s status="申请"
		i Stat="R" s status="安排"
		i Stat="N" s status="非预约"
		i Stat="I" s status="术中"
		i Stat="P" s status="恢复室"
		i Stat="L" s status="术毕"
		i Stat="F" s status="完成"

		
	
		//手术间、手术间描述
		s oproomdr=$P(^DHCANOPArrange(opaId),"^",20)
		s:(oproomdr'="") oproomdes=$p($g(^DHCANC("OPRoom",oproomdr)),"^",2)
		//手术间信息验证数据正确
		//q:(oproomdr'=oproom)&(oproomdes'="")&(Stat'="A")
		//手术见所在楼层
		s:(oproomdr'="") floorId=$p($g(^DHCANC("OPRoom",oproomdr)),"^",4)
		s:(floorId'="") oprFloor=$P($G(^DHCANC("Floor",floorId)),"^",2)
		
		//手术台次
		s opordno=$P(^DHCANOPArrange(opaId),"^",26)
		i (opordno'="")&(opordno=1) s opdate="8:30"
		s tmpDateStr=opordno
		i +tmpDateStr=0 {
			s tmpDateStr=""
		}
		else{
			s tmpDateStr=tmpDateStr-1
		}
		//验证admid
		//s adm=$P(^DHCANOPArrange(opaId),"^",1),admId=adm
		//q:(admId'=EpisodeID)
		s admId=AEpisodeID
		s adm=AEpisodeID
		
		s hz=..GetOrderItemInfo(admId)
		
		//支付状态
		s pbrowid=$O(^DHCPB(0,"ADM",adm,pbrowid))
		s:(pbrowid'="") pbtype=$p($g(^DHCPB(pbrowid)),"^",16)
		s Chargestate=$s(pbtype="P":"Y",1:"N")
		//图标
		s ico=""
		//s ico=##class(web.DHCANOPArrange).GetIco(admId)
		//床位信息
		s bedCode="",inPatNo="",admreason=""
		s bedSub=$p($p($g(^PAADM(adm)),"^",73),"||",2)
		s paweight=""
		s paweight=##class(web.DHCSTPIVA).GetPatWeight(adm)
		//病区
		s curWardId=$p($g(^PAADM(adm)),"^",70)  
		s curWardId=$p($g(^PAADM(adm)),"^",70)  
		i curWardId'=""{
			s WardDes=$P(^PAWARD(curWardId),"^",1) 
			s address=$p($g(^CTLOC($P(^PAWARD(curWardId),"^",5))),"^",16)
		}
		i (bedSub'="")&(curWardId'="") s bedCode=$p($g(^PAWARD(curWardId,"BED",bedSub)),"^",1)
		s inPatNo=$p($g(^PAADM(adm)),"^",29)
		s admreasondr=$p($g(^PAADM(adm,1)),"^",7)
		i admreasondr'="" { s admreason=$p(^PAC("ADMREA",admreasondr),"^",2) }

		//抗原抗体
		s yg=$P($g(^DHCANOPArrange(opaId,"PALab")),"^",29)			//OPA_PATestHBsAg  	免疫乙肝表面抗原
		s bg=$P($g(^DHCANOPArrange(opaId,"PALab")),"^",34)			//OPA_PATestHCVAb 	免疫丙型肝炎抗体
		s az=$P($g(^DHCANOPArrange(opaId,"PALab")),"^",35)			//OPA_PATestHivAb 	免疫艾滋病毒抗体
		s md=$P($g(^DHCANOPArrange(opaId,"PALab")),"^",36)			//OPA_PATestTPAb 	免疫梅毒
		s qt=$P($g(^DHCANOPArrange(opaId,"PALab")),"^",2)			//OPA_PATestOther	检其它阴阳性
		i yg="阳性" s yy="乙肝阳性"
		i bg="阳性" s yy=yy_"丙肝阳性"_" "
		i az="阳性" s yy=yy_"艾滋病阳性"_" "
		i md="阳性" s yy=yy_"梅毒阳性"_" "
		i qt="阳性" s yy=yy_"其他阳性"_" "
		
		s patStat=$P(^DHCANOPArrange(opaId),"^",23)
		
		i (Stat="D")&(patStat="") s status="拒绝",patstatus="手术室停手术"
		i (Stat="D")&(patStat="I") s status="撤销",patstatus="申请科室停手术"
		i (Stat="D")&(patStat="A") s status="拒绝",patstatus="麻醉科室停手术"
		
		
		s papmiId=$p($g(^PAADM(admId)),"^",1)
		s paadmtype=$p($g(^PAADM(admId)),"^",2)
		//手术申请者信息
		s appCtcpId=$P(^DHCANOPArrange(opaId),"^",6)  //zt 2011.8.24
	    i appCtcpId'="" s tAppCtcpDesc=##class(web.DHCANOPCom).GetNameById(appCtcpId)
	    s ctcptId=$P($g(^CTPCP(appCtcpId,1)),"^",4)  //ADD MFC 20140106申请手术人员类型
	    s ctcptType=$p(^CT("CPT",ctcptId),"^",4)
		//登记号
		s regno=$p($g(^PAPER(papmiId,"PAT",1)),"^",1)
		//病案号
		s medCareNo=##Class(EMRservice.HISInterface.PatientInfoAssist).GetMRNoByEpisodeID(admId)
		//姓名
		s patname=$p($g(^PAPER(papmiId,"ALL")),"^",1)
		
		s birth=$p($g(^PAPER(papmiId,"ALL")),"^",6)
		s age=$$CalAge(birth,opstdate)
		s sex=$p($g(^CT("SEX",$p($g(^PAPER(papmiId,"ALL")),"^",7))),"^",2)
		s chl=$P($P(^DHCANOPArrange(opaId),"^",2),"||",2)
		s admLocId=$p($g(^PAADM(adm)),"^",4)
		i admLocId'="" s admLocdes=$P($g(^CTLOC(admLocId)),"^",2)  //Add mfc 20131217 病人所在科室
		i $l(admLocdes,"-")>1 s admLocdes=$p(admLocdes,"-",2)
		
		//add mfc 20140416急诊病人交押金
		i (paadmtype="E") s eDeposit=##class(web.DHCBillInterface).IGetStayBalance(admId)  
		s jz=$P(^OR(adm,"ANA",chl),"^",32)   						//ANA_SourceType 急诊(E)/择期(B)
		s jzstat=$s(jz="E":"急诊",jz="B":"择期",1:"超时")
		s mzdr=$P(^OR(adm,"ANA",chl),"^",6)        					//ANA_Anaesthetist_Dr 
		//麻醉医师
		s andoc=""
		i mzdr'="" {
			
			s andoc=##class(web.DHCANOPCom).GetNameById(mzdr)
			s andocNo=$tr($p($g(^CTPCP(+mzdr,1)),"^",1)," ","") 		//add mfc 20140520
		}
		s anDocNote=$P(^DHCANOPArrange(opaId),"^",43)
		s opEndDate=$P($g(^OR(adm,"ANA",chl)),"^",41)  //手术结束日期
		s opEndTime=$P($g(^OR(adm,"ANA",chl)),"^",42)  //手术结束时间
		i opEndDate'=""  s opEndDate=$ZD(opEndDate,3)
		i opEndTime'=""  s opEndTime=$ZT(opEndTime,2)
		s openddatestr=opEndDate_" "_opEndTime
		s operShiJi=$p($g(^DHCANOPArrange(opaId,"Ext")),"^",30) //实际手术名称
		s operOptionDesc=""
		s operNote=$p(operShiJi,"!",1)
		s operOptionList=$p(operShiJi,"!",2)	
		f i=1:1:$l(operOptionList,"@") 
		{
			s operOption=$p(operOptionList,"@",i)
			s operOptionId=$p(operOption,"|",1)
			i operOptionDesc="" {
				s operOptionDesc=$p(operOption,"|",2)
			}
			else  {
				s operOptionDesc=operOptionDesc_";"_$p(operOption,"|",2)
			}
			s:(operNote="") operShiJi=operOptionDesc
			s:(operNote'="") operShiJi=operNote_";"_operOptionDesc
		}
		s mzsupdoc=""
		s mzsupdr=$P(^OR(adm,"ANA",chl),"^",7)        				;ANA_Supervisor_DR ///ck091203  
		s:(mzsupdr'="") mzdoc=##class(web.DHCANOPCom).GetNameById(mzsupdr)
		
		s anDocAss=""
		s ass=0,surgeonDesc=""
		f  {
			s ass=$o(^OR(adm,"ANA",chl,"OP",1,"ANASS",ass)) 
			q:ass=""  
			//麻醉助手
			s mzzsdr=$p($g(^OR(adm,"ANA",chl,"OP",1,"ANASS",ass)),"^",1)
			q:mzzsdr=""
			i anDocAss="" {
				s anDocAss=##class(web.DHCANOPCom).GetNameById(mzzsdr)
			}
			else {
				s anDocAss=anDocAss_" "_##class(web.DHCANOPCom).GetNameById(mzzsdr)
			}
		}
		s:(anDocAss'="") mzdoc=mzdoc_","_anDocAss
		
		//麻醉护士
		s anNurse=""
		s mzNurseId=$P(^OR(adm,"ANA",chl),"^",8)
		s:(mzNurseId'="") anNurse=##class(web.DHCANOPCom).GetNameById(mzNurseId)
		
		//ASA分级
		s ASA=""
	    s ASAId=$P(^OR(adm,"ANA",chl),"^",26)
		s:(ASAId'="") ASA=$P(^ORC("ASA",ASAId),"^",2)
		//ANA_Method	 麻醉方法
		s anmthdr=$P(^OR(adm,"ANA",chl),"^",5)						
		s anmethod=""
		i anmthdr'=""{
			s anmetNum=$l(anmthdr,"|")
			f i=1:1:anmetNum {
				s anmetId=$p(anmthdr,"|",i)
				q:anmetId=""
				s anmetDesc=$p($g(^ORC("ANMET",anmetId)),"^",2)
				i $P(anmetDesc,"-",2)'="" {s anmetDesc=$P(anmetDesc,"-",2)}
				i anmethod="" {s anmethod=anmetDesc}
				else  {s anmethod=anmethod_","_anmetDesc}
			}
		}
		////+ wxl 090316 合并疾病
		s anCompDesc=""                                        		
		s subchl=0 
		f  {
			s subchl=$O(^OR(adm,"ANA",chl,"COMP",subchl)) 
			q:(subchl="")
			s AnCompDr=$P(^OR(adm,"ANA",chl,"COMP",subchl),"^",1)
			q:AnCompDr=""
			i anCompDesc="" {
				s anCompDesc=$P(^ORC("COMP",AnCompDr),"^",2)
			}
			else  {
				s anCompDesc=anCompDesc_","_$P(^ORC("COMP",AnCompDr),"^",2)
			}
		}		
		s i=0
		s prediag="",diamen=""
		s subchl=0 
		f {
			s subchl=$O(^OR(adm,"ANA",chl,"OP",subchl)) 
			q:(subchl="")
			//ANAOP_Type_DR     ；手术名称
			s opdr=$P(^OR(adm,"ANA",chl,"OP",subchl),"^",6)       		
			i opdr'=""
			{
				i $P($g(^ORC("OPER",+opdr)),"^",2)'="" 
				{
					i opdes'="" 
					{	
						s opdes=opdes_";" 	 
					}
					s opdes=opdes_$P($g(^ORC("OPER",+opdr)),"^",2) 
				}
			}
			else
			{
				i $g(^OR(adm,"ANA",chl,"OP",subchl,"REM",2))'=""
				{
					
					i opdes'="" 
					{
						s opdes=opdes_";"		
					}
					s opdes=opdes_$G(^OR(adm,"ANA",chl,"OP",subchl,"REM",2))    ///ck091210
				}
			}
			s i=i+1
			q:i>1   ///ck091117
			s sub=subchl
		
			//手术部位
			s bodsIdList=$P(^OR(adm,"ANA",chl,"OP",sub),"^",24) 	 //ypz 070418 	手术部位
		    s bodsList="",bodsDesc=""
	  
		    i bodsIdList'=""
			{
				s bodsIdNum=$l(bodsIdList,"|")
				f j=1:1:bodsIdNum
				{
					s bodsId=$p(bodsIdList,"|",j)
					q:bodsId=""
					s bodsDesc2=$p($g(^OEC("BODS",+bodsId)),"^",2)
					i bodsDesc="" { 
						s bodsDesc=bodsDesc2 
					}
					else {
						 s bodsDesc=bodsDesc_"|"_bodsDesc2 
					}
				}
			}
			//ANAOP_Surgeon_DR   手术医师
			s docdr=$P(^OR(adm,"ANA",chl,"OP",subchl),"^",8)      		
			s docNo=$tr($p($g(^CTPCP(+docdr,1)),"^",1)," ","")            ;手术医师工号
			s opd=""
			s technicalid=$p($g(^CTPCP(+docdr,1)),"^",10)
			i technicalid'="" s technical=$p($g(^CT("SPC",technicalid)),"^",2) ;术者职称
			i docdr'="" 
			{
				s opdoc=##class(web.DHCANOPCom).GetNameById(docdr)
			}
			else  
			{
				s opdoc=$TR($p($p(^DHCANOPArrange(opaId),"^",42),"|",2)," ","")  //CK 091210 手术医生备注(外来手术医生)
			}
			s surgeonDesc=opdoc 
			//ANAOP_PreopDiag_DR 术前诊断  
			s predigdr=$P(^OR(adm,"ANA",chl,"OP",subchl),"^",4)   		
			i predigdr'=""{
				s prediag=$P(^MRC("ID",predigdr),"^",2)
				s diag=$G(prediag)
			}
			else	
			{
				i $g(^OR(adm,"ANA",chl,"TXT",2))'="" 
				{
					s diamen=^OR(adm,"ANA",chl,"TXT",2)  	//ck091210 麻醉表存放诊断备注ANA_Notes
					s diag=$G(diamen)
				}
			}
			s operLocId=$P(^OR(adm,"ANA",chl,"OP",subchl),"^",10) 		;ANAOP_CTLOC_DR
			i operLocId'="" 
			{
				s shoushujian=$p(^CTLOC(operLocId),"^",2)
			}
		}
		s ash=""
		s assDocNum=10 //最多显示的助手人数
		i $p($g(^DHCCLSet("AnOp","Ctcp")),"^",1)'="" 
		{
			s assDocNum=$p($g(^DHCCLSet("AnOp","Ctcp")),"^",1)
		}
		s p=0,list=0,asName=""
		//手动填写OPA_OpDocNote（实习医生1;实习医生2...|主刀|一助|二助|三助|四助|五助...）
		s opaDocNote=$P(^DHCANOPArrange(opaId),"^",42) 
		s len=$l(opaDocNote,"|")
		
		s as=0 
		f  {
			s as=$O(^OR(adm,"ANA",chl,"OP",sub,"ASS",as)) 
			q:(as="")!(p'<assDocNum)
			s asdr=$P(^OR(adm,"ANA",chl,"OP",sub,"ASS",as),"^",1)
			s p=p+1
			q:asdr=""
			s asName=asName_"^"_##class(web.DHCANOPCom).GetNameById(asdr)_","
			//一助工号
			s:(p=1) asdocNo=$tr($p($g(^CTPCP(+asdr,1)),"^",1)," ","")            
			s astechnicalid=$p($g(^CTPCP(+asdr,1)),"^",10)
			// 一助职称
			s:((astechnicalid'="")&(astechnical="")) astechnical=$p($g(^CT("SPC",astechnicalid)),"^",2)	
		}
		s:(len>assDocNum+2) len=assDocNum+2
		
		f getLen=3:1:len
		{
			i $p(opaDocNote,"|",getLen)'=""
			{
				s getName=$p(opaDocNote,"|",getLen)
			}
			else{
				s list=list+1
				s getName=$p(asName,"^",list+1)
			}
			s ash=ash_""_getName
		}
			//洗手
		s p=0,xs=0 
		f  {
			s xs=$O(^OR(adm,"ANA",chl,"OP",sub,"SCN",xs)) 
			q:(xs="")!(p=3)
			q:xs>20
			s xsdr=$P(^OR(adm,"ANA",chl,"OP",sub,"SCN",xs),"^",1)
			q:xsdr=""
			s p=p+1
			s xsh=xsh_" "_##class(web.DHCANOPCom).GetNameById(xsdr)
			s qixie=$tr($p($g(^CTPCP(+xsdr,1)),"^",1)," ","")
			q:qixie=""
			//add mfc 20140416 获取多的器械护士工号
			i qixieno="" 
			{
				s qixieno=qixie      
			}
			else
			{
				s qixieno=qixieno_" "_qixie
			}
		}
		//巡回
		s p=0,xc=0 			
		f
		{
			s xc=$O(^OR(adm,"ANA",chl,"OP",sub,"CIRN",xc)) 
			q:(xc="")!(p=3)
			q:xc>20
			s xchdr=$P(^OR(adm,"ANA",chl,"OP",sub,"CIRN",xc),"^",1)
			q:xchdr=""
			q:$tr($p($g(^CTPCP(+xchdr,1)),"^",1)," ","")=""
			s xunhui=$tr($p($g(^CTPCP(+xchdr,1)),"^",1)," ","")
			q:xunhui=""
			i xunhuino="" 
			{
				s xunhuino=xunhui      //add mfc 20140416 获取多的巡回护士工号
			}
			else  
			{
				s xunhuino=$G(xunhuino)_" "_xunhui
			}
			s p=p+1	
			s xch=$G(xch)_" "_##class(web.DHCANOPCom).GetNameById(xchdr)
		}		
		s scNurNote=$p($G(^DHCANOPArrange(opaId)),"^",51)		//OPA_ScrubNurseNote	器械护士备注 	
		s cirNurNote=$p($G(^DHCANOPArrange(opaId)),"^",52)		//OPA_CirculNurseNote	巡回护士备注
		s j=j+1
		s opd=opd_","_$G(ash)
		
		s sortOpRoomDesc=oproomdes
		s:(oproomdes="") oproomdes="无"
		s sortOpaSeq=opordno
		s:(opordno="") opordno="未排" ;Do OutRow2
		s NeedAnaesthetist=$p($G(^DHCANOPArrange(opaId)),"^",44)
		
		s oprFloor=""
		s operInstrumentId=$P(^DHCANOPArrange(opaId),"^",30)
		s operInstrument=""
		s:(operInstrumentId'="") operInstrument=$P($G(^DHCANC("Instrument",operInstrumentId)),"^",2)
		
		s EpisodeID=$P(^DHCANOPArrange(opaId),"^",1)
		s anaId=$P(^DHCANOPArrange(opaId),"^",2)
		s opstatus=$$getOpPayStatus(anaId)
		s anaSub=$P(anaId,"||",2)
		s operPositionId=$P($G(^OR(EpisodeID,"ANA",anaSub,"OP",1,"POS",1)),"^")
		i (operPositionId'=""){
			s operPositionIdNum=$l(operPositionId,"|")	
			f j=1:1:operPositionIdNum {
				s oposId=$p(operPositionId,"|",j)
				q:oposId=""
				s oposDesc=$p(^ORC("OPPOS",+oposId),"^",2)
				i operPosition="" { s operPosition=oposDesc }
				else{  s operPosition=operPosition_" "_oposDesc}
			}			
		}
		s OPCategory="",OPCategoryId=""
		s:(opdr'="") OPCategoryId=$p($g(^ORC("OPER",opdr)),"^",7) 
		s:(OPCategoryId'="") OPCategory=$p($g(^ORC("CATEG",OPCategoryId)),"^",2)
		s isAddInstrument=$P($G(^DHCANOPArrange(opaId)),"^",31)
		s instrumentDr=$P($G(^DHCANOPArrange(opaId)),"^",30)
		s instrument=""
		s:(instrumentDr'="") instrument=$P($G(^DHCANC("Instrument",instrumentDr)),"^",2)
		s patWardId1=$P($G(^DHCANOPArrange(opaId)),"^",32)
		
		//初始化患者病区
		s patWard=""
		i patWardId1'="" {
			s patWard=$P($G(^PAWARD(patWardId1)),"^",2) 
			s address=$p($g(^CTLOC($P(^PAWARD(patWardId1),"^",5))),"^",16)
		}
		s:(patWard["-") patWard=$p(patWard,"-",2)
		//患者状态
		s visitstatus=$P($g(^PAADM(adm)),"^",20)
		//状态转换
		s visitstatustemp=visitstatus
		i (visitstatustemp="A")&&(paadmtype'="O") s visitstatus="住院"
		i (visitstatustemp="P") s visitstatus="预约"
		i (visitstatustemp="A")&&(paadmtype="O") s visitstatus="门诊"
		i (visitstatustemp="A")&&(paadmtype="E") s visitstatus="急诊"
		i (visitstatustemp="D") s visitstatus="已出院"
		i (visitstatustemp="C") s visitstatus="撤销"
		//患者床号
		s BedId=$P($g(^PAADM(adm)),"^",73)
	    s:(BedId'="") PAAdmBed=$P($g(^PAWARD(+BedId,"BED",$P(BedId,"||",2))),"^",1)
		//病床地址
	    s:(address'["层") address=address_"层"
	    s address=patWard_"/"_address_"/"_PAAdmBed_"床"
		
		s estiOperDuration=$P($G(^DHCANOPArrange(opaId)),"^",37)
		s:(estiOperDuration'="") estiOperDuration=$ZT(estiOperDuration,2)
		s preDiscussDate=$P($G(^DHCANOPArrange(opaId)),"^",38)
		s preDiscussDate=$ZD(preDiscussDate,4)
		s isExCirculation=$P($G(^DHCANOPArrange(opaId)),"^",36)
		//血型
		s bloodType="不详"
		s bloodTypId=$P(^DHCANOPArrange(opaId),"^",11)
		s:((+bloodTypId'=0)&($d(^PAC("BLDT",+bloodTypId)))) bloodType=$P($G(^PAC("BLDT",bloodTypId)),"^",2)
		
		s opDocNote=$P($G(^DHCANOPArrange(opaId)),"^",42)
		s anDocNote=$P($G(^DHCANOPArrange(opaId)),"^",43)
		s opSeqNote=$P($G(^DHCANOPArrange(opaId)),"^",41)
		s AnaesthesiaID=$P($G(^DHCANOPArrange(opaId)),"^",2)
		s retReasonId=$P($G(^DHCANOPArrange(opaId)),"^",35)
		i Stat'="D"	s retReasonId=""   ;20120604+dyl
		i retReasonId'=""  s retReason=$p(^ORC("SUSP",retReasonId),"^",2)   //+ ck091212 手术拒绝原因
		e  s retReason=""
		s anaDoctorOrd=$p($G(^DHCANOPArrange(opaId)),"^",48)     	//+ ck091212 麻醉医生收费状态
		i anaDoctorOrd="Y"  s anaDoctorOrd="Y"
		e  s anaDoctorOrd="N"
		
		s anaNurseOrd=$p($G(^DHCANOPArrange(opaId)),"^",49)      	//+ ck091212 麻醉护士收费状态
		i anaNurseOrd="Y"  s anaNurseOrd="Y"
		e  s anaNurseOrd="N"
		
		s opNurseOrd=$p($G(^DHCANOPArrange(opaId)),"^",50)       	//+ ck091212 手术护士收费状态
		i opNurseOrd="Y"  s opNurseOrd="Y"
		e  s opNurseOrd="N"
		
		s tPacuBedId=$P($G(^DHCANOPArrange(opaId)),"^",47)		 	//OPA_PacuBed_Dr	麻醉恢复床
		i tPacuBedId'="" s tPacuBed=$p(^DHCANC("OPRoom",tPacuBedId),"^",2)
		e  s tPacuBed=""
		s PACUInDate=$P($G(^DHCANOPArrange(opaId,"PACU")),"^",6) 	//OPA_PACUInDate	入恢复室日期
		i PACUInDate'="" s PACUInDate=$zd(PACUInDate,3)
		s PACUInTime=$P($G(^DHCANOPArrange(opaId,"PACU")),"^",7) 	//OPA_PACUInTime	入恢复室时间
		i PACUInTime'="" s PACUInTime=$zt(PACUInTime)
		s PACUInDateTime=PACUInDate_" "_PACUInTime
		i sortOpRoomDesc="" s sortOpRoomDesc=0
		i sortOpaSeq<10 s sortOpaSeq=0_sortOpaSeq
		s opaSeqNote=$P($G(^DHCANOPArrange(opaId)),"^",41)	//OPA_SeqNote
		s appLocId=$P($G(^DHCANOPArrange(opaId)),"^",54)	//OPA_AppLoc_Dr
		s appLocDesc=$P($G(^CTLOC(+appLocId)),"^",2)
		s tDocArriveTime=$P(^DHCANOPArrange(opaId),"^",46)
		s opname=opdes
		i tDocArriveTime'="" s tDocArriveTime=##class(web.DHCANOPCom).ConvertToTime(tDocArriveTime)
		i ash'="" s opdoc=opdoc_","_ash
		s:(scNurNote'="") xsh=xsh_","_scNurNote
		s:(cirNurNote'="") xch=xch_","_cirNurNote
		s statusFlag=0				
		i status="拒绝" s statusFlag=4		
		e  i (opSeqNote["非手术日")&(status'="安排") s statusFlag=1
		e  i (status="安排") s statusFlag=3
		e  i (status="申请") s statusFlag=1
		e  i (status="完成") s statusFlag=2
		e  s statusFlag=1
		s antUsePurpose=""
		s opInterviewNur=##class(Nur.DHCMoudData).GetVisitUser("DHCNURXH_SQSHFSD",opaId) //Add mfc 20140523术前访视护士(护士站接口)
		//w !,status,jzstat,opdate,oproomdes,opordno,regno,patname,sex,age,opname,opdes,diag,opd,opdoc,locdes,anmethod,andoc,mzdoc,xsh,xch,yy,opaId,adm,opdatestr,OpAppDateStr,opmem,isAddInstrument,instrument,patWard,anNurse,medCareNo,oproomdr,oprFloor,estiOperDuration,preDiscussDate,isExCirculation,bloodType,opDocNote,anDocNote,opSeqNote,AnaesthesiaID,operPosition,OPCategory,opsttime,mzsupdoc,retReason,anaDoctorOrd,anaNurseOrd,opNurseOrd,inPatNo,admreason,tPacuBed,PACUInDateTime,scNurNote,cirNurNote,anDocAss,bedCode,tDocArriveTime,tOpStartDate,tOpStartTime,tAppCtcpDesc,nurNotes,mzdr,bodsDesc,yg,bg,az,md,qt,ASA,opUnPlanedOperation,FreezingSlice,ash,technical,docNo,astechnical,asdocNo,patstatus,ico,hz,visitstatus,paweight,address,IsOrNotRelease,Chargestate,qixieno,xunhuino,opstatus,shoushujian,paadmtype,admLocdes,openddatestr,operShiJi,xunhuino1,xunhuino2,locdesGroup,eDeposit,antUsePurpose,andocNo,opInterviewNur
		
		w !,status_"|"_jzstat_"|"_opdate_"|"_oproomdes_"|"_opordno_"|"_regno_"|"_patname_"|"_sex_"|"_age_"|"_opname_"|"_opdes_"|"_diag_"|"_opd_"|"_opdoc_"|"_locdes_"|"_anmethod_"|"_andoc_"|"_mzdoc_"|"_xsh_"|"_xch_"|"_yy_"|"_opaId_"|"_adm_"|"_opdatestr_"|"_OpAppDateStr_"|"_opmem_"|"_isAddInstrument_"|"_instrument_"|"_patWard_"|"_anNurse_"|"_medCareNo_"|"_oproomdr_"|"_oprFloor_"|"_estiOperDuration_"|"_preDiscussDate_"|"_isExCirculation_"|"_bloodType_"|"_opDocNote_"|"_anDocNote_"|"_opSeqNote_"|"_AnaesthesiaID_"|"_operPosition_"|"_OPCategory_"|"_opsttime_"|"_mzsupdoc_"|"_retReason_"|"_anaDoctorOrd_"|"_anaNurseOrd_"|"_opNurseOrd_"|"_inPatNo_"|"_admreason_"|"_tPacuBed_"|"_PACUInDateTime_"|"_scNurNote_"|"_cirNurNote_"|"_anDocAss_"|"_bedCode_"|"_tDocArriveTime_"|"_tOpStartDate_"|"_tOpStartTime_"|"_tAppCtcpDesc_"|"_nurNotes_"|"_mzdr_"|"_bodsDesc_"|"_yg_"|"_bg_"|"_az_"|"_md_"|"_qt_"|"_ASA_"|"_opUnPlanedOperation_"|"_FreezingSlice_"|"_ash_"|"_technical_"|"_docNo_"|"_astechnical_"|"_asdocNo_"|"_patstatus_"|"_ico_"|"_hz_"|"_visitstatus_"|"_paweight_"|"_address_"|"_IsOrNotRelease_"|"_Chargestate_"|"_qixieno_"|"_xunhuino_"|"_opstatus_"|"_shoushujian_"|"_paadmtype_"|"_admLocdes_"|"_openddatestr_"|"_operShiJi_"|"_xunhuino1_"|"_xunhuino2_"|"_locdesGroup_"|"_eDeposit_"|"_antUsePurpose_"|"_andocNo_"|"_opInterviewNur
			
	}
CalAge(IBirth,IToday )
	s IBirth=$g(IBirth),IToday=$g(IToday)
    i IBirth>2980000 s IBirth=""
    i IBirth<0 s IBirth=""
    q:'$G(IBirth) ""
    s XBirth=$ZD(IBirth)
    s XToday=$ZD(IToday)
    s AgeMth=XToday-XBirth
    s AgeDay=$p(XToday,"/",2)-$p(XBirth,"/",2)
    s CurrYear=$p(XToday,"/",3) s:CurrYear<100 CurrYear=CurrYear+1900
    s BirthYear=$p(XBirth,"/",3) s:BirthYear<100 BirthYear=BirthYear+1900
    s AgeYear=CurrYear-BirthYear
    i AgeDay<0 d
        . s AgeMth=AgeMth-1
	    . s AgeDay=AgeDay+$p("31,31,28,31,30,31,30,31,31,30,31,30,31",",",+XToday)
	    . q:XToday'=2
	    . s:((CurrYear#4)=0)&(((CurrYear#100)'=0)!((CurrYear#400)=0)) AgeDay=AgeDay+1
	i AgeMth<0 s AgeMth=AgeMth+12,AgeYear=AgeYear-1
	s $P(AgeYr,"|",12)=AgeYear
	//s reage=$p(AgeYr,"|",12)_"Y "_AgeMth_"M "_AgeDay_"D"
	i $p(AgeYr,"|",12)>0 s reage=$p(AgeYr,"|",12)_"岁"
	e  d
	.i AgeMth>0 s reage=AgeMth_"月"
	.e  d
	..s reage=AgeDay_"天"
	q reage

getOpPayStatus(mazuiid)
	s ret="N"
    s count=0
	s oeoriSub=""
	s anaId=mazuiid
	s oeordId=""
	f  s oeordId = $o(^OEORDi(0,"Ana",anaId,oeordId)) q:oeordId=""  d
	.f  s oeoriSub = $o(^OEORDi(0,"Ana",anaId,oeordId, oeoriSub)) q:oeoriSub=""  d
	..s ordStatCode=##Class(web.DHCANOPCom).GetOrdStatCode(oeordId_"||"_oeoriSub)
	..q:((ordStatCode'="E") && (ordStatCode'="V"))
	..s count=count+1
	i count>0 s ret="Y"
    q ret
}

ClassMethod GetOrderItemInfo(admid As %String)
{
		s oeordId="",arcimrowid="" ,oeoristtdate="",oeorisub="",flag="N"
		f  {
			s oeordId=$o(^OEORD(0,"Adm",admid,oeordId)) 
			q:oeordId=""
			
			f  {
				s arcimrowid=$o(^OEORDi(0,"ARCIM",oeordId,arcimrowid)) 
				q:arcimrowid=""
				
				s ordStatCode=##Class(web.DHCANOPCom).GetOrdStatCode(arcimrowid)
				q:((ordStatCode'="E") && (ordStatCode'="V")&&arcimrowid'="26521||1")
				s sttDate=$p($g(^OEORD($p(oeordId,"||",1),"I",oeoriSub,$p(oeordId,"||",1))),"^",9) //keep duplicate
				s sttTime=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",10)
				s flag="Y"_sttDate_sttTime
			}
		}	
        q flag
}

///   ---method test end
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
/// Debug:		d ##class(%ResultSet).RunQuery("EMRservice.SystemData","GetNewOperInfo","2653342")
/// ====================================================================================
Query GetNewOperInfo(argAdm As %String) As %Query(ROWSPEC = "OperStartDate1,OperEndDate1,OperDiagDesc1,OperName1Dict,OperAnaMethod1Dict,OperAnaDoc1Dict,OperDoc1Dict,OperAssist1Dict,OperSecAssist1Dict,OperInsNurse1Dict,OperCirNurse1Dict,OperdocAnMthDesc1,Operanapreop1,postdiag1,OperLevelDict1,OperStartDate2,OperEndDate2,OperDiagDesc2,OperName2Dict,OperAnaMethod2Dict,OperAnaDoc2Dict,OperDoc2Dict,OperAssist2Dict,OperSecAssist2Dict,OperInsNurse2Dict,OperCirNurse2Dict,OperdocAnMthDesc2,Operanapreop2,postdiag2,OperLevelDict2,OperStartDate3,OperEndDate3,OperDiagDesc3,OperName3Dict,OperAnaMethod3Dict,OperAnaDoc3Dict,OperDoc3Dict,OperAssist3Dict,OperSecAssist3Dict,OperInsNurse3Dict,OperCirNurse3Dict,OperdocAnMthDesc3,Operanapreop3,postdiag3,OperLevelDict3,OperStartDate4,OperEndDate4,OperDiagDesc4,OperName4Dict,OperAnaMethod4Dict,OperAnaDoc4Dict,OperDoc4Dict,OperAssist4Dict,OperSecAssist4Dict,OperInsNurse4Dict,OperCirNurse4Dict,OperdocAnMthDesc4,Operanapreop4,postdiag4,OperLevelDict4")
{
}

ClassMethod GetNewOperInfoExecute(ByRef qHandle As %Binary, argAdm As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	Set qHandle=$lb(0,repid,0)
	
	// 手术开始时间,  手术结束时间,术前诊断,     手术名称, 麻醉方式
	s (OperEndDate1,OperDiagDesc1,OperAnaMethod1,OperName1Dict) = ""
	s OperStartDate1="─"
	// 麻醉师,    手术者,  一助,       二助,          器械护士,     巡回护士
	s (OperAnaDoc1Dict,OperDoc1Dict,OperAssist1Dict,OperSecAssist1Dict,OperInsNurse1Dict,OperCirNurse1Dict) = ""
	//拟施麻醉方法,   拟施手术方法,    术后诊断,    
	S (OperdocAnMthDesc1,Operanapreop1,postdiag1) = ""
		
	s (OperStartDate2,OperEndDate2,OperDiagDesc2,OperName2Dict,OperAnaMethod2,OperAnaDoc2Dict,OperDoc2Dict,OperAssist2Dict,OperSecAssist2Dict,OperInsNurse2Dict,OperCirNurse2Dict,OperdocAnMthDesc2,Operanapreop2,postdiag2)=""
	s (OperStartDate3,OperEndDate3,OperDiagDesc3,OperName3Dict,OperAnaMethod3,OperAnaDoc3Dict,OperDoc3Dict,OperAssist3Dict,OperSecAssist3Dict,OperInsNurse3Dict,OperCirNurse3Dict,OperdocAnMthDesc3,Operanapreop3,postdiag3)=""
	s (OperStartDate4,OperEndDate4,OperDiagDesc4,OperName4Dict,OperAnaMethod4,OperAnaDoc4Dict,OperDoc4Dict,OperAssist4Dict,OperSecAssist4Dict,OperInsNurse4Dict,OperCirNurse4Dict,OperdocAnMthDesc4,Operanapreop4,postdiag4)=""
	s (OperStartDate5,OperEndDate5,OperDiagDesc5,OperName5Dict,OperAnaMethod5,OperAnaDoc5Dict,OperDoc5Dict,OperAssist5Dict,OperSecAssist5Dict,OperInsNurse5Dict,OperCirNurse5Dict,OperdocAnMthDesc5,Operanapreop5,postdiag5)=""
	s (OperStartDate6,OperEndDate6,OperDiagDesc6,OperName6Dict,OperAnaMethod6,OperAnaDoc6Dict,OperDoc6Dict,OperAssist6Dict,OperSecAssist6Dict,OperInsNurse6Dict,OperCirNurse6Dict,OperdocAnMthDesc6,Operanapreop6,postdiag6)=""
	s (OperStartDate7,OperEndDate7,OperDiagDesc7,OperName7Dict,OperAnaMethod7,OperAnaDoc7Dict,OperDoc7Dict,OperAssist7Dict,OperSecAssist7Dict,OperInsNurse7Dict,OperCirNurse7Dict,OperdocAnMthDesc7,Operanapreop7,postdiag7)=""
	s (OperStartDate8,OperEndDate8,OperDiagDesc8,OperName8Dict,OperAnaMethod8,OperAnaDoc8Dict,OperDoc8Dict,OperAssist8Dict,OperSecAssist8Dict,OperInsNurse8Dict,OperCirNurse8Dict,OperdocAnMthDesc8,Operanapreop8,postdiag8)=""
	s (OperStartDateLast,OperEndDateLast,OperDiagDescLast,OperNameLastDict,OperAnaMethodLast,OperAnaDocLastDict,OperDocLastDict,OperAssistLastDict,OperSecAssistLastDict,OperInsNurseLastDict,OperCirNurseLastDict,OperdocAnMthDescLast,OperanapreopLast,postdiagLast)=""
	s OperLevelDict1="─^─^─",(OperLevelDict2,OperLevelDict3,OperLevelDict4,OperLevelDict5,OperLevelDict6,OperLevelDict7,OperLevelDict8)=""
	
	
	s OperData1=$lb(OperStartDate1,OperEndDate1,OperDiagDesc1,OperName1Dict,OperAnaMethod1Dict,OperAnaDoc1Dict,OperDoc1Dict,OperAssist1Dict,OperSecAssist1Dict,OperInsNurse1Dict,OperCirNurse1Dict,OperdocAnMthDesc1,Operanapreop1,postdiag1,OperLevelDict1)
	s OperData2=$lb(OperStartDate2,OperEndDate2,OperDiagDesc2,OperName2Dict,OperAnaMethod2Dict,OperAnaDoc2Dict,OperDoc2Dict,OperAssist2Dict,OperSecAssist2Dict,OperInsNurse2Dict,OperCirNurse2Dict,OperdocAnMthDesc2,Operanapreop2,postdiag2,OperLevelDict2)
	s OperData3=$lb(OperStartDate3,OperEndDate3,OperDiagDesc3,OperName3Dict,OperAnaMethod3Dict,OperAnaDoc3Dict,OperDoc3Dict,OperAssist3Dict,OperSecAssist3Dict,OperInsNurse3Dict,OperCirNurse3Dict,OperdocAnMthDesc3,Operanapreop3,postdiag3,OperLevelDict3)
	s OperData4=$lb(OperStartDate4,OperEndDate4,OperDiagDesc4,OperName4Dict,OperAnaMethod4Dict,OperAnaDoc4Dict,OperDoc4Dict,OperAssist4Dict,OperSecAssist4Dict,OperInsNurse4Dict,OperCirNurse4Dict,OperdocAnMthDesc4,Operanapreop4,postdiag4,OperLevelDict4)
	
	s rset=##class(%ResultSet).%New("EMRservice.HISInterface.PatientInfoAssist:GetPatOperInfo")
	do rset.Execute(argAdm)
	s count = 0
	While (rset.Next()) {
		//status,jzstat,opdate,oproomdes,opordno,regno,patname,sex,age,opname,opdes,diag,opd,opdoc,
		//locdes,anmethod,andoc,mzdoc,xsh,xch,yy,opaId,adm,opdatestr,OpAppDateStr,opmem,isAddInstrument,
		//instrument,patWard,anNurse,medCareNo,oproomdr,oprFloor,estiOperDuration,preDiscussDate,isExCirculation,
		//bloodType,opDocNote,anDocNote,opSeqNote,AnaesthesiaID,operPosition,OPCategory,opsttime,mzsupdoc,retReason,
		//anaDoctorOrd,anaNurseOrd,opNurseOrd,inPatNo,admreason,tPacuBed,PACUInDateTime,scNurNote,cirNurNote,anDocAss,
		//bedCode,tDocArriveTime,tOpStartDate,tOpStartTime,tAppCtcpDesc,nurNotes,mzdr,bodsDesc,yg,bg,az,md,qt,ASA,
		//opUnPlanedOperation,FreezingSlice,ash,technical,docNo,astechnical,asdocNo,patstatus,ico,hz,visitstatus,
		//paweight,address,IsOrNotRelease,Chargestate,qixieno,xunhuino,opstatus,shoushujian,paadmtype,admLocdes,
		//openddatestr,operShiJi,xunhuino1,xunhuino2,locdesGroup,eDeposit,antUsePurpose,andocNo,opInterviewNur
		
	   	s count = count + 1
	   	
	   	if (count = 1)	{	d GetAnOper1	   	}	
	   	elseif (count = 2) {	d GetAnOper2	}
	   	elseif (count = 3) {	d GetAnOper3	}
	   	elseif (count = 4) {	d GetAnOper4	}

	}
	d rset.Close()
	
	set ^CacheTemp(repid, ind) = OperData1_OperData2_OperData3_OperData4
	
	Quit $$$OK
	
GetAnOper1
	//手术起始时间结束时间
	s OperStartDate1= $p(rset.Data("opdatestr"),"~",1)
	s OperEndDate1	= $p(rset.Data("opdatestr"),"~",2)
	//术前诊断
	s OperDiagDesc1	=rset.Data("diag")
	//手术名称
	s OperName1Desc	= rset.Data("opdes")
	s OperName1ID= rset.Data("opdr")
	s OperName1Dict		= $$GetOperNameDict(OperName1ID,OperName1Desc)
	//麻醉方法
	s OperAnaMethod1Desc= rset.Data("anmethod")
	s OperAnaMethod1Dict= $$GetAnaMethodDict(OperAnaMethod1Desc)
	
	//麻醉医师
	s OperAnaDoc1Desc	= rset.Data("andoc")
	s OperAnaDoc1Initials	= rset.Data("andocNo")
	s OperAnaDoc1Dict=$$GetSSUserDictbyInitials(OperAnaDoc1Initials,OperAnaDoc1Desc)
	
	//术者、一助、二助
	s OperDoc1Desc		= $p(rset.Data("opdoc"),",",1)
	s OperDoc1Initials		= rset.Data("docNo")
	s OperDoc1Dict=$$GetSSUserDictbyInitials(OperDoc1Initials,OperDoc1Desc)
	s OperAssist1Desc	= $p(rset.Data("opdoc"),",",2)
	s OperAssist1Initials = rset.Data("asdocNo")
	s OperAssist1Dict = $$GetSSUserDictbyInitials(OperAssist1Initials,OperAssist1Desc)
	s OperSecAssist1Desc= $p(rset.Data("opdoc"),",",3)
	s OperSecAssist1Initials = rset.Data("secasdocNo")
	s OperSecAssist1Dict= $$GetSSUserDictbyInitials(OperSecAssist1Initials,OperSecAssist1Desc)
	
	//手术等级
	s OperLevel1Desc= rset.Data("OPCategory")
	s OperLevelDict1=$$GetOperCategoryDict(OperLevel1Desc)
	s OperData1=$lb(OperStartDate1,OperEndDate1,OperDiagDesc1,OperName1Dict,OperAnaMethod1Dict,OperAnaDoc1Dict,OperDoc1Dict,OperAssist1Dict,OperSecAssist1Dict,OperInsNurse1Dict,OperCirNurse1Dict,OperdocAnMthDesc1,Operanapreop1,postdiag1,OperLevelDict1)
	q OperData1
GetAnOper2
	//手术起始时间结束时间
	s OperStartDate2= $p(rset.Data("opdatestr"),"~",1)
	s OperEndDate2	= $p(rset.Data("opdatestr"),"~",2)
	//术前诊断
	s OperDiagDesc2	=rset.Data("diag")
	//手术名称
	s OperName2Desc	= rset.Data("opdes")
	s OperName2ID= rset.Data("opdr")
	s OperName2Dict		= $$GetOperNameDict(OperName2ID,OperName2Desc)
	//麻醉方法
	s OperAnaMethod2Desc= rset.Data("anmethod")
	s OperAnaMethod2Dict= $$GetAnaMethodDict(OperAnaMethod2Desc)
	
	//麻醉医师
	s OperAnaDoc2Desc	= rset.Data("andoc")
	s OperAnaDoc2Initials	= rset.Data("andocNo")
	s OperAnaDoc2Dict=$$GetSSUserDictbyInitials(OperAnaDoc2Initials,OperAnaDoc2Desc)
	
	//术者、一助、二助
	s OperDoc2Desc		= $p(rset.Data("opdoc"),",",1)
	s OperDoc2Initials		= rset.Data("docNo")
	s OperDoc2Dict=$$GetSSUserDictbyInitials(OperDoc2Initials,OperDoc2Desc)
	s OperAssist2Desc	= $p(rset.Data("opdoc"),",",2)
	s OperAssist2Initials = rset.Data("asdocNo")
	s OperAssist2Dict = $$GetSSUserDictbyInitials(OperAssist2Initials,OperAssist2Desc)
	s OperSecAssist2Desc= $p(rset.Data("opdoc"),",",3)
	s OperSecAssist2Initials = rset.Data("secasdocNo")
	s OperSecAssist2Dict= $$GetSSUserDictbyInitials(OperSecAssist2Initials,OperSecAssist2Desc)
	
	//手术等级
	s OperLevel2Desc= rset.Data("OPCategory")
	s OperLevelDict2=$$GetOperCategoryDict(OperLevel2Desc)
	s OperData2=$lb(OperStartDate2,OperEndDate2,OperDiagDesc2,OperName2Dict,OperAnaMethod2Dict,OperAnaDoc2Dict,OperDoc2Dict,OperAssist2Dict,OperSecAssist2Dict,OperInsNurse2Dict,OperCirNurse2Dict,OperdocAnMthDesc2,Operanapreop2,postdiag2,OperLevelDict2)
	q OperData2
GetAnOper3
	//手术起始时间结束时间
	s OperStartDate3= $p(rset.Data("opdatestr"),"~",1)
	s OperEndDate3	= $p(rset.Data("opdatestr"),"~",2)
	//术前诊断
	s OperDiagDesc3	=rset.Data("diag")
	//手术名称
	s OperName3Desc	= rset.Data("opdes")
	s OperName3ID= rset.Data("opdr")
	s OperName3Dict		= $$GetOperNameDict(OperName3ID,OperName3Desc)
	//麻醉方法
	s OperAnaMethod3Desc= rset.Data("anmethod")
	s OperAnaMethod3Dict= $$GetAnaMethodDict(OperAnaMethod3Desc)
	
	//麻醉医师
	s OperAnaDoc3Desc	= rset.Data("andoc")
	s OperAnaDoc3Initials	= rset.Data("andocNo")
	s OperAnaDoc3Dict=$$GetSSUserDictbyInitials(OperAnaDoc3Initials,OperAnaDoc3Desc)
	
	//术者、一助、二助
	s OperDoc3Desc		= $p(rset.Data("opdoc"),",",1)
	s OperDoc3Initials		= rset.Data("docNo")
	s OperDoc3Dict=$$GetSSUserDictbyInitials(OperDoc3Initials,OperDoc3Desc)
	s OperAssist3Desc	= $p(rset.Data("opdoc"),",",2)
	s OperAssist3Initials = rset.Data("asdocNo")
	s OperAssist3Dict = $$GetSSUserDictbyInitials(OperAssist3Initials,OperAssist3Desc)
	s OperSecAssist3Desc= $p(rset.Data("opdoc"),",",3)
	s OperSecAssist3Initials = rset.Data("secasdocNo")
	s OperSecAssist3Dict= $$GetSSUserDictbyInitials(OperSecAssist3Initials,OperSecAssist3Desc)
	
	//手术等级
	s OperLevel3Desc= rset.Data("OPCategory")
	s OperLevelDict3=$$GetOperCategoryDict(OperLevel3Desc)
	s OperData3=$lb(OperStartDate3,OperEndDate3,OperDiagDesc3,OperName3Dict,OperAnaMethod3Dict,OperAnaDoc3Dict,OperDoc3Dict,OperAssist3Dict,OperSecAssist3Dict,OperInsNurse3Dict,OperCirNurse3Dict,OperdocAnMthDesc3,Operanapreop3,postdiag3,OperLevelDict3)
	q OperData3
GetAnOper4
	//手术起始时间结束时间
	s OperStartDate4= $p(rset.Data("opdatestr"),"~",1)
	s OperEndDate4	= $p(rset.Data("opdatestr"),"~",2)
	//术前诊断
	s OperDiagDesc4	=rset.Data("diag")
	//手术名称
	s OperName4Desc	= rset.Data("opdes")
	s OperName4ID= rset.Data("opdr")
	s OperName4Dict		= $$GetOperNameDict(OperName4ID,OperName4Desc)
	//麻醉方法
	s OperAnaMethod4Desc= rset.Data("anmethod")
	s OperAnaMethod4Dict= $$GetAnaMethodDict(OperAnaMethod4Desc)
	
	//麻醉医师
	s OperAnaDoc4Desc	= rset.Data("andoc")
	s OperAnaDoc4Initials	= rset.Data("andocNo")
	s OperAnaDoc4Dict=$$GetSSUserDictbyInitials(OperAnaDoc4Initials,OperAnaDoc4Desc)
	
	//术者、一助、二助
	s OperDoc4Desc		= $p(rset.Data("opdoc"),",",1)
	s OperDoc4Initials		= rset.Data("docNo")
	s OperDoc4Dict=$$GetSSUserDictbyInitials(OperDoc4Initials,OperDoc4Desc)
	s OperAssist4Desc	= $p(rset.Data("opdoc"),",",2)
	s OperAssist4Initials = rset.Data("asdocNo")
	s OperAssist4Dict = $$GetSSUserDictbyInitials(OperAssist4Initials,OperAssist4Desc)
	s OperSecAssist4Desc= $p(rset.Data("opdoc"),",",3)
	s OperSecAssist4Initials = rset.Data("secasdocNo")
	s OperSecAssist4Dict= $$GetSSUserDictbyInitials(OperSecAssist4Initials,OperSecAssist4Desc)
	
	//手术等级
	s OperLevel4Desc= rset.Data("OPCategory")
	s OperLevelDict4=$$GetOperCategoryDict(OperLevel4Desc)
	s OperData4=$lb(OperStartDate4,OperEndDate4,OperDiagDesc4,OperName4Dict,OperAnaMethod4Dict,OperAnaDoc4Dict,OperDoc4Dict,OperAssist4Dict,OperSecAssist4Dict,OperInsNurse4Dict,OperCirNurse4Dict,OperdocAnMthDesc4,Operanapreop4,postdiag4,OperLevelDict4)
	q OperData4
	
GetSSUserDictbyInitials(code,desc)
	s dict="^^",id=""
	q:(code="") dict
	s id=$o(^SSU("SSUSR",0,"SSUSR_Initials",code,id))
	q:(id="") dict
	s dict=id_"^"_code_"^"_desc
	b ;11
	q dict

GetAnaMethodDict(desc)
	s anadesc=""
	for {
		s anadesc=$o(^ORC("ANMET",0,"Desc",anadesc))
		q:(anadesc="")
		q:anadesc[desc
	}
	s anaid="",code="",anamethoddict="^^"
	if (anadesc'=""){
		s anaid=$o(^ORC("ANMET",0,"Desc",anadesc,anaid))
		s code=$p(^ORC("ANMET",anaid),"^",1)
		s anamethoddict=anaid_"^"_code_"^"_desc
	}
	q anamethoddict
GetOperCategoryDict(desc)
	//ORC_OperationCategory
	//^ORC("CATEG",0,"Desc",$$ALPHAUP({CATEG_Desc}),{CATEG_RowId})
	//^ORC("CATEG",{CATEG_RowId}) 
	s id="",code="",dict="─^─^─"
	q:(desc="") dict
	s id=$o(^ORC("CATEG",0,"Desc",desc,id))
	s code=$p($g(^ORC("CATEG",id)),"^",1)
	s dict=id_"^"_code_"^"_desc
	q dict
GetOperNameDict(id,desc)
	//ORC_Operation
	//^ORC("OPER",{OPER_RowId})
	s dict="^^"_desc,code=""
	q:(id="") dict
	
	s code=$p(^ORC("OPER",id),"^",1)
	s dict=id_"^"_code_"^"_desc
	
	q dict
}

ClassMethod GetNewOperInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetNewOperInfoExecute ]
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

ClassMethod GetNewOperInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetNewOperInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
	Quit $$$OK
}

/// ////////////////////////////////////////////////////////////////////////////////////////////////
/// Creator：	guozongtao
/// CreateDate：2015-05-21
/// Desc：		取首页数据绑定信息
/// Input:		Adm: 就诊rowid
/// Return：
/// Test:		do ##class(%ResultSet).RunQuery("EMRservice.SystemData","GetFirstPageInfo","18")		
Query GetFirstPageInfo(Adm As %String) As %Query(ROWSPEC = "ProvinceNativeDict,ProvinceBirthDict,curProvinceDict,HukouProvinceDict,curStreet,HuKouStreet,AdmWayMono,AdmWayDict,AdmDailyLifeScore,DischDailyLifeScore,WorkAddress,IsCriticalcaseMono,IsDifficultcaseMono,DisReocrdDiag1Dict,DisReocrdDiag2Dict,DisReocrdDiag3Dict,DisReocrdDiag4Dict,DisReocrdDiag5Dict,DisReocrdDiag6Dict,DisReocrdDiag7Dict,DisReocrdDiag8Dict,DisReocrdDiag9Dict,DisReocrdDiag10Dict,DisReocrdDiag11Dict,DisReocrdDiag12Dict,DisReocrdDiag13Dict,ICUWardDesc1,ICUWardStart1,ICUWardEnd1,ICUWardDesc2,ICUWardStart2,ICUWardEnd2,ICUWardDesc3,ICUWardStart3,ICUWardEnd3,DirectorDict,AttendingDoctorDict,ResidentDoctorDict,FirstPageAgeYear,FirstPageAgeMonth,DepartmentHeaderDict,PrimaryNurseDict,DepartmentHeaderDesc,PathologicDiag1Dict,PathologicDiag2Dict,PathologicDiag3Dict,PathologicalNumber1,PathologicalNumber2,PathologicalNumber3,ICUWardDesc4,ICUWardStart4,ICUWardEnd4,ICUWardDesc5,ICUWardStart5,ICUWardEnd5,FirstAge,FirstBabyAge,FirstBabyDay,FirstBabyMouth")
{
}

ClassMethod GetFirstPageInfoExecute(ByRef qHandle As %Binary, Adm As %String) As %Status
{
	//b "s"
	Set repid=$I(^CacheTemp)
	s ind=1
	Set qHandle=$lb(0,repid,0)

	Quit:($d(^PAADM(Adm))=0)||(Adm="") $$$OK
	
	s ProvinceNativeDict="",ProvinceBirthDict="",curProvinceDict="",HukouProvinceDict=""
	
	s Hospital=##class(EMRservice.BL.BLSysOption).GetOptionValueByName("HospitalName")
	// 登记RowId		[PapmiDR]			PA_Person.PAPER_RowId And PA_PatMas.PAPMI_PAPER_DR
 	s PapmiDR = ##Class(EMRservice.HISInterface.PatientInfoAssist).GetPapmiDR(Adm)


	// 籍贯				[Native]			PA_Person.PAPER_Province_Birth_DR And PA_Person.PAPER_CityBirth_DR
 	// 城市				[CityBirth]			PA_Person.PAPER_CityBirth_DR ->
 	// 省份				[ProvinceBirth]		PA_Person.PAPER_Province_Birth_DR ->
 	s tmpNative=##Class(EMRservice.HISInterface.PatientInfoAssist).Native(PapmiDR,Hospital)
	
   	// 籍贯省份 
	s tmpProvinceNative = $p($g(tmpNative),"!",1)
    s ProvinceNativeDict=tmpProvinceNative
	s ProvinceNativeDesc = $p(tmpProvinceNative,"^",3)
	i (ProvinceNativeDesc="北京市")||(ProvinceNativeDesc="天津市")||(ProvinceNativeDesc="上海市")||(ProvinceNativeDesc="重庆市")
	{
		s ProvinceNativeDict=$tr(ProvinceNativeDict,ProvinceNativeDesc,"─")
	}
	
	// 出生地
	s tmpBirthPlace=##Class(EMRservice.HISInterface.PatientInfoAssist).BirthPlaceNew(PapmiDR)
	
	// 出生地省份 
	s tmpProvinceBirth = $p($g(tmpBirthPlace),"!",1)
	s ProvinceBirthDict = tmpProvinceBirth
	s ProvinceBirthDesc = $p(ProvinceBirthDict,"^",3)
	i (ProvinceBirthDesc="北京市")||(ProvinceBirthDesc="天津市")||(ProvinceBirthDesc="上海市")||(ProvinceBirthDesc="重庆市")
	{
		s ProvinceBirthDict=$tr(ProvinceBirthDict,ProvinceBirthDesc,"─")
	}	
	
	 //现住址
 	s tmpcuraddr=##Class(EMRservice.HISInterface.PatientInfoAssist).ResidentAddressNew(PapmiDR,Hospital)
 	s tmpcuraddr=$tr(tmpcuraddr,"\","")
	
   	// 现住址省份 
	s tmpcurProvince = $p($g(tmpcuraddr),"!",1)
	s curProvinceDict = tmpcurProvince
	s curProvinceDesc = $p(tmpcurProvince,"^",3)
	i (curProvinceDesc="北京市")||(curProvinceDesc="天津市")||(curProvinceDesc="上海市")||(curProvinceDesc="重庆市")
	{
		s curProvinceDict=$tr(curProvinceDict,curProvinceDesc,"─")
	}	

 	// 现住址城市 
	s tmpcurCity = $p($g(tmpcuraddr),"!",2)
	s curCityDict = tmpcurCity
	s curCityDesc = $p(curCityDict,"^",3)
	
	// 现住址区县 
	s tmpcurBlock = $p($g(tmpcuraddr),"!",3)
	s curBlockDict = tmpcurBlock
	s curBlockDesc = $p(curBlockDict,"^",3)	

	s curStreet= $p($g(tmpcuraddr),"!",4)
	s curStreet= $tr(curStreet,curProvinceDesc,"")
	s curStreet= $tr(curStreet,curCityDesc,"")
	s curStreet= $tr(curStreet,curBlockDesc,"")

	
 	//户口地址
 	s tmpHuKou=##Class(EMRservice.HISInterface.PatientInfoAssist).HuKouAddressNew(PapmiDR,Hospital)
 	s tmpHuKou=$tr(tmpHuKou,"\","")
	
   	// 户口地址省份 
	s tmpHukouProvince = $p($g(tmpHuKou),"!",1)
	s HukouProvinceDict = tmpHukouProvince
	s HukouProvinceDesc = $p(HukouProvinceDict,"^",3)
	i (HukouProvinceDesc="北京市")||(HukouProvinceDesc="天津市")||(HukouProvinceDesc="上海市")||(HukouProvinceDesc="重庆市")
	{
		s HukouProvinceDict=$tr(HukouProvinceDict,HukouProvinceDesc,"─")
	}	
	
 	// 户口地址城市 
	s tmpHuKouCity = $p($g(tmpHuKou),"!",2)
	s HuKouCityDict =tmpHuKouCity
	s HuKouCityDesc =$p(HuKouCityDict,"^",3)
   		
	// 户口地址区县 
	s tmpHuKouBlock = $p($g(tmpHuKou),"!",3)
	s HuKouBlockDict = tmpHuKouBlock
	s HuKouBlockDesc = $p(HuKouBlockDict,"^",3)

	s HuKouStreet= $p($g(tmpHuKou),"!",4)
	s HuKouStreet=$tr(HuKouStreet,HukouProvinceDesc,"")
	s HuKouStreet=$tr(HuKouStreet,HuKouCityDesc,"")
	s HuKouStreet=$tr(HuKouStreet,HuKouBlockDesc,"")
	
	//入院途径 如果未填写取到值为Code值为空等，默认“其他”
	
	
	s AdmWayCode=""
	//PAC_AdmSource
	//9		1	门诊	N
	//10	2	急诊	N
	//11	3	其他医疗机构转入	N
	//12	9	其他	N
 	&sql(SELECT InSorce Into :AdmSourWayID FROM SQLUser.DHCDocIPBooking WHERE EpisodeIDTo =:Adm )
 	//s AdmSourWayID=$p(^PAADM(Adm),"^",10)
 	if (AdmSourWayID="")
 	{
	 	s AdmWayMono="9^其他"
	 	s AdmWayDict="4^9^其他"
	}
	else
	{
 		s admSourceCode=$p($g(^PAC("ADSOU",AdmSourWayID)),"^",1)
 		s admSourceDesc=$p($g(^PAC("ADSOU",AdmSourWayID)),"^",2)
 		//医生站存储中数据与首页内容不一致，需要转换
 		//2011年卫建委发布的行业标准 1门诊 2急诊
 		//2010年住院病案首页 1急诊 2门诊
		s AdmWayMono=$s(admSourceCode=1:"2^门诊",admSourceCode=2:"1^急诊",admSourceCode=3:"3^其他医疗机构转入",admSourceCode=4:"9^其他",1:"9^其他")
		//s AdmWayMono=admSourceCode_"^"_admSourceDesc
		s AdmWayDict=$s(admSourceCode=1:"2^2^门诊",admSourceCode=2:"1^1^急诊",admSourceCode=3:"3^3^其他医疗机构转入",admSourceCode=4:"4^9^其他",1:"4^9^其他")
		
	}
	
	//日常生活能力评定、PDA接口
	s AdmDailyLifeScore="─",DischDailyLifeScore="─"
	//SELECT Item11,Item12,* FROM Nur.dhcmouddataSub WHERE RecParref->EpisodeId='10424980' AND RecParref->EmrCode='DHCNurPFB'
	&sql(SELECT Item12 Into :AdmDailyLifeScore FROM Nur.dhcmouddataSub WHERE RecParref->EpisodeId=:Adm AND RecParref->EmrCode='DHCNurPFB' and Item11="入院" )
	&sql(SELECT Item12 Into :DischDailyLifeScore FROM Nur.dhcmouddataSub WHERE RecParref->EpisodeId=:Adm AND RecParref->EmrCode='DHCNurPFB' and Item11="出院前" )

	
	//工作单位及地址
	s WorkAddress="─",tmpOccupation="",tmpOccupationDesc=""
	s tmpOccupation=##Class(EMRservice.HISInterface.PatientInfoAssist).Occupation(PapmiDR,Hospital)
 	s WorkAddress=##Class(EMRservice.HISInterface.PatientInfoAssist).WorkAddress(PapmiDR,Hospital)
 	
	s tmpOccupationDesc=$p($g(tmpOccupation),"^",3)
	
	s:(tmpOccupationDesc="农民")||(tmpOccupationDesc="退休")||(tmpOccupationDesc="无业人员")||(WorkAddress="") WorkAddress="─"
	
	
	//病危病历，入院途径为急诊、死亡病例、MICU、ICU、CCU、NICU患者默认为1.是
	s IsCriticalcaseMono="2^否",IsDeadPat="",TransDept="",DeathDateTime=""
	s TransDept=##Class(EMRservice.HISInterface.PatientInfoAssist).TransDept(Adm)
	s DeathDateTime=##class(EMRservice.HISInterface.PatientInfoAssist).DeathDateTime(Adm,PapmiDR)
	s:(DeathDateTime'="") IsDeadPat="Y" 
	s:(AdmWayMono="1^急诊") IsCriticalcaseMono="1^是"
	s:(IsDeadPat="Y") IsCriticalcaseMono="1^是"
	s:(TransDept["CU") IsCriticalcaseMono="1^是"
	
	//疑难病历，有申请多科会诊、专业组查房记录的默认为1.是
	s IsDifficultcase="",IsDifficultcaseMono=""
	&sql(SELECT CONTYPE into :IsDifficultcase FROM SQLUser.dhc_consultation WHERE Adm =:Adm AND CONTYPE="M" )
	s IsDifficultcaseMono=$s(IsDifficultcase="M":"1^是",1:"2^否")
	s AllTitles=##class(EMRservice.HISInterface.PatientInfoAssist).GetAllInstanceTitles(Adm)
	s:(AllTitles["专业组查房记录") IsDifficultcaseMono="1^是"
	
	  s arr="",diagarr="",diagarrlist=""
  s (DisReocrdDiag1,DisReocrdDiag2,DisReocrdDiag3,DisReocrdDiag4,DisReocrdDiag5)=""
  s (DisReocrdDiag6,DisReocrdDiag7,DisReocrdDiag8,DisReocrdDiag9,DisReocrdDiag10)=""
  s (DisReocrdDiag11,DisReocrdDiag12,DisReocrdDiag13)=""

  s (DisReocrdDiag1Dict,DisReocrdDiag2Dict,DisReocrdDiag3Dict,DisReocrdDiag4Dict,DisReocrdDiag5Dict)=""
  s (DisReocrdDiag6Dict,DisReocrdDiag7Dict,DisReocrdDiag8Dict,DisReocrdDiag9Dict,DisReocrdDiag10Dict)=""
  s (DisReocrdDiag11Dict,DisReocrdDiag12Dict,DisReocrdDiag13Dict)=""

  s arr=##Class(EPRservice.BOScatterData).GetDataByGlossaryCategory(Adm,"HDSD00.14.13")
  s diagarr=arr.GetAt("HDSD00.14.018")

  s diagarrlist=$$ChangeStrToList(diagarr,13)

  s DisReocrdDiag1=$listget(diagarrlist,1)
  s DisReocrdDiag1Dict=$$GetDiagDict(DisReocrdDiag1)

  s DisReocrdDiag2=$listget(diagarrlist,2)
  s DisReocrdDiag2Dict=$$GetDiagDict(DisReocrdDiag2)

  s DisReocrdDiag3=$listget(diagarrlist,3)
  s DisReocrdDiag3Dict=$$GetDiagDict(DisReocrdDiag3)

  s DisReocrdDiag4=$listget(diagarrlist,4)
  s DisReocrdDiag4Dict=$$GetDiagDict(DisReocrdDiag4)

  s DisReocrdDiag5=$listget(diagarrlist,5)
  s DisReocrdDiag5Dict=$$GetDiagDict(DisReocrdDiag5)

  s DisReocrdDiag6=$listget(diagarrlist,6)
  s DisReocrdDiag6Dict=$$GetDiagDict(DisReocrdDiag6)

  s DisReocrdDiag7=$listget(diagarrlist,7)
  s DisReocrdDiag7Dict=$$GetDiagDict(DisReocrdDiag7)

  s DisReocrdDiag8=$listget(diagarrlist,8)
  s DisReocrdDiag8Dict=$$GetDiagDict(DisReocrdDiag8)

  s DisReocrdDiag9=$listget(diagarrlist,9)
  s DisReocrdDiag9Dict=$$GetDiagDict(DisReocrdDiag9)

  s DisReocrdDiag10=$listget(diagarrlist,10)
  s DisReocrdDiag10Dict=$$GetDiagDict(DisReocrdDiag10)

  s DisReocrdDiag11=$listget(diagarrlist,11)
  s DisReocrdDiag11Dict=$$GetDiagDict(DisReocrdDiag11)

  s DisReocrdDiag12=$listget(diagarrlist,12)
  s DisReocrdDiag12Dict=$$GetDiagDict(DisReocrdDiag12)

  s DisReocrdDiag13=$listget(diagarrlist,13)
  s DisReocrdDiag13Dict=$$GetDiagDict(DisReocrdDiag13)
	
	
	//取转科信息中的ICU相关科室入出时间
	s (TransICUInfo1,TransICUInfo2,TransICUInfo3,ICUWardDesc1,ICUWardStart1,ICUWardEnd1,ICUWardDesc2,ICUWardStart2,ICUWardEnd2,ICUWardDesc3,ICUWardStart3,ICUWardEnd3,ICUWardDesc4,ICUWardStart4,ICUWardEnd4,ICUWardDesc5,ICUWardStart5,ICUWardEnd5)=""
	
	s ICUInAndOutTimes=##class(EMRservice.HISInterface.PatientInfoAssist).TransDeptDetailInCludeICU(Adm)
 
	 If (ICUInAndOutTimes'="")
	 {
		d GetICUInAndOutTime1
		d GetICUInAndOutTime2
		d GetICUInAndOutTime3
 		d GetICUInAndOutTime4
 		d GetICUInAndOutTime5
	 }
	
	
	// (用以计算年龄)入院日期时间	[AdmDateTime]		PAAdm_AdmDate And PAAdm_AdmTime 
	s AdmDate = "", AdmTime = ""
	s AdmDateTime=##class(EMRservice.HISInterface.PatientInfoAssist).AdmDateTime(Adm,Hospital)
	if AdmDateTime'="" 
	{ 
		   // 入院日期内部格式
		   s AdmDate = $P($G(AdmDateTime),",",1)
		   // 入院时间内部格式 
		   s AdmTime = $P($G(AdmDateTime),",",2)
	}
	  
   	//调用年龄统一接口 [Age]
   	s Age=##class(EMRservice.HISInterface.PatientInfoAssist).Age(PapmiDR,Adm,AdmDate,AdmTime)
   	//s Age="3月11天"
   	//s Age="10天"
   	//s Age="12天3小时"
   	s FirstPageAgeYear="",FirstPageAgeMonth=""
   	s:(Age["岁") FirstPageAgeYear=$p(Age,"岁",1)_"岁"
   	if FirstPageAgeYear="" {
	   	s (tmpMonth,tmpDay)=""
	   	s FirstPageAgeYear=0
	   	s:(Age["月") tmpMonth=$p(Age,"月",1)
	   	s:((Age["天")&&(Age["月")) tmpDay=$p($p(Age,"月",2),"天",1)
	   	s:((Age["天")&&(Age'["月")) tmpDay=$p(Age,"天",1)
	   	
   		s FirstPageAgeMonth=$case(tmpMonth,"":"",:tmpMonth_" ")_$case(tmpDay,0:"","":"1/30",:tmpDay_"/30")
   	}
 	s (FirstAge,FirstBabyAge,FirstBabyDay,FirstBabyMouth)=""
 	if (Age["岁")
 	{
		s FirstAge = $P(Age,"岁",1)_"岁"
		s FirstBabyAge = ""
	}
	else
	{
		s FirstAge = "-"
		if (Age["月")&&(Age'["天")
		{
			s AgeMouth = $P(Age,"月",1)
			s FirstBabyAge = AgeMouth
		}
		elseif (Age["月")&&(Age["天")
		{
			s AgeMouth = $P(Age,"月",1)
			s AgeDay = $P($P(Age,"月",2),"天",1)
			s FirstBabyAge = AgeMouth
			s FirstBabyDay = AgeDay
			s FirstBabyMouth = "30"
		}
		elseif (Age["天")
		{
			s AgeDay = $P(Age,"天",1)
			s FirstBabyAge = ""
			s FirstBabyDay = AgeDay
			s FirstBabyMouth = "30"
		}
		else
		{
			s FirstBabyDay = "1"
			s FirstBabyMouth = "30"
		}
	}
    
	s (DirectorDict,AttendingDoctorDict,ResidentDoctorDict)=""
	
	s DepartmentHeaderDict=##class(EMRservice.HISInterface.PatientInfoAssist).GetDepartmentHeader(Adm)
	s DepartmentHeaderDesc=$p(DepartmentHeaderDict,"^",3)
	s PrimaryNurseDict = ##class(EMRservice.HISInterface.PatientInfoAssist).GetPrimaryNurse(Adm)
	
	
	//获取病理诊断/病理号 绑定数据
	s pathologicDiag1=""
	s PathologicalNumber1 = ""
	
	s pathologicDiag2=""
	s PathologicalNumber2 = ""
	
	s pathologicDiag3=""
	s PathologicalNumber3 = ""
	
	s pathologicalIndex = 1 
	zn "DHC-PIS"
	if (##Class(%ClassDefinition).%ExistsId("Src.DPIS3OutInterface")=1)
	{
		
		// 提供给电子病历看报告接口，通过就诊号查看申请单号
		//d ##class(%ResultSet).RunQuery("Src.DPIS3OutInterface","GetAppInfoByAdm","457")
		
		// 提供给电子病历看报告接口，通过申请单号得到病理诊断、检查所见、发报告日期、病理号
		// d ##class(%ResultSet).RunQuery("Src.DPIS3OutInterface","GetRptInfoByTmrowid","10")
		
		s result = ##class(%ResultSet).%New("Src.DPIS3OutInterface:GetAppInfoByAdm")
		d result.Execute(Adm)
		
		while(result.%Next())
		{
			s Tmrowid = result.Data("tmid")
			
			s resultRpt = ##class(%ResultSet).%New("Src.DPIS3OutInterface:GetRptInfoByTmrowid")
			d resultRpt.Execute(Tmrowid)
			
			while(resultRpt.%Next())
			{
			
				s pathologicDiag(pathologicalIndex) = resultRpt.Data("Diagnosis")
				s pathologicalNumber(pathologicalIndex) = resultRpt.Data("PathId")
				s pathologicalIndex = pathologicalIndex + 1	
			}
			d resultRpt.Close()
			
		}
		d result.Close()

	}
	zn "DHC-APP"
	
	
	s PathologicDiag1=$g(pathologicDiag(1))
	s PathologicalNumber1 = $g(pathologicalNumber(1))
	
	s PathologicDiag2=$g(pathologicDiag(2))
	s PathologicalNumber2 = $g(pathologicalNumber(2))
	
	s PathologicDiag3=$g(pathologicDiag(3))
	s PathologicalNumber3 = $g(pathologicalNumber(3))

	s PathologicDiag1Dict = "^^"_$zstrip(PathologicDiag1,"*C")
	s PathologicDiag2Dict = "^^"_$zstrip(PathologicDiag2,"*C")
	s PathologicDiag3Dict = "^^"_$zstrip(PathologicDiag3,"*C")
	
	
	set ^CacheTemp(repid, ind) = $LB(ProvinceNativeDict,ProvinceBirthDict,curProvinceDict,HukouProvinceDict,curStreet,HuKouStreet,AdmWayMono,AdmWayDict,AdmDailyLifeScore,DischDailyLifeScore,WorkAddress,IsCriticalcaseMono,IsDifficultcaseMono,DisReocrdDiag1Dict,DisReocrdDiag2Dict,DisReocrdDiag3Dict,DisReocrdDiag4Dict,DisReocrdDiag5Dict,DisReocrdDiag6Dict,DisReocrdDiag7Dict,DisReocrdDiag8Dict,DisReocrdDiag9Dict,DisReocrdDiag10Dict,DisReocrdDiag11Dict,DisReocrdDiag12Dict,DisReocrdDiag13Dict,ICUWardDesc1,ICUWardStart1,ICUWardEnd1,ICUWardDesc2,ICUWardStart2,ICUWardEnd2,ICUWardDesc3,ICUWardStart3,ICUWardEnd3,DirectorDict,AttendingDoctorDict,ResidentDoctorDict,FirstPageAgeYear,FirstPageAgeMonth,DepartmentHeaderDict,PrimaryNurseDict,DepartmentHeaderDesc,PathologicDiag1Dict,PathologicDiag2Dict,PathologicDiag3Dict,PathologicalNumber1,PathologicalNumber2,PathologicalNumber3,ICUWardDesc4,ICUWardStart4,ICUWardEnd4,ICUWardDesc5,ICUWardStart5,ICUWardEnd5,FirstAge,FirstBabyAge,FirstBabyDay,FirstBabyMouth)
	set ind = ind + 1
	Quit $$$OK

ChangeStrToList(astring,listlength)
	s retlist=""
	for i=1:1:listlength {
		s tmpdiag=""
		s tmpdiag=$p($g(astring),$c(10),i)
		if tmpdiag'=""{
			  s retlist=retlist_$lb(tmpdiag)
		}
		else
		{
			  s retlist=retlist_$lb("")
		}
	}
	q retlist
	
GetDiagDict(atmpdiagdesc)
	s retdict="^^"_atmpdiagdesc
	q:(atmpdiagdesc="") retdict
	s mricdxid=""
	s shorttmpdiagdesc = $ZSTRIP(atmpdiagdesc,"*C")
	s mricdxid=$o(^MRC("ID",0,"Desc",shorttmpdiagdesc,mricdxid))
	q:(mricdxid="") retdict
	s tmpdiagstr=$g(^MRC("ID",mricdxid))
 	s retdict=mricdxid_"^"_$p(tmpdiagstr,"^",1)_"^"_atmpdiagdesc
	q retdict
	
GetICUInAndOutTime1
	s TransICUInfo1=$p(ICUInAndOutTimes,"->",1)
	s ICUWardDesc1=$p(TransICUInfo1,"^",2)
	s ICUWardStart1=$p(TransICUInfo1,"^",3)_" "_$p(TransICUInfo1,"^",4)
	s ICUWardEnd1=$p(TransICUInfo1,"^",5)_" "_$p(TransICUInfo1,"^",6)

GetICUInAndOutTime2
	s TransICUInfo2=$p(ICUInAndOutTimes,"->",2)
	s ICUWardDesc2=$p(TransICUInfo2,"^",2)
	s ICUWardStart2=$p(TransICUInfo2,"^",3)_" "_$p(TransICUInfo2,"^",4)
	s ICUWardEnd2=$p(TransICUInfo2,"^",5)_" "_$p(TransICUInfo2,"^",6)


GetICUInAndOutTime3
	s TransICUInfo3=$p(ICUInAndOutTimes,"->",3)
	s ICUWardDesc3=$p(TransICUInfo3,"^",2)
	s ICUWardStart3=$p(TransICUInfo3,"^",3)_" "_$p(TransICUInfo3,"^",4)
	s ICUWardEnd3=$p(TransICUInfo3,"^",5)_" "_$p(TransICUInfo3,"^",6)
GetICUInAndOutTime4
	s TransICUInfo4=$p(ICUInAndOutTimes,"->",3)
	s ICUWardDesc4=$p(TransICUInfo4,"^",2)
	s ICUWardStart4=$p(TransICUInfo4,"^",3)_" "_$p(TransICUInfo4,"^",4)
	s ICUWardEnd4=$p(TransICUInfo4,"^",5)_" "_$p(TransICUInfo4,"^",6)
GetICUInAndOutTime5
	s TransICUInfo5=$p(ICUInAndOutTimes,"->",3)
	s ICUWardDesc5=$p(TransICUInfo5,"^",2)
	s ICUWardStart5=$p(TransICUInfo5,"^",3)_" "_$p(TransICUInfo5,"^",4)
	s ICUWardEnd5=$p(TransICUInfo5,"^",5)_" "_$p(TransICUInfo5,"^",6)
}

ClassMethod GetFirstPageInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetFirstPageInfoExecute ]
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

ClassMethod GetFirstPageInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetFirstPageInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
	Quit $$$OK
}

/// 
/// 1、医院有操作记录（可重复模板），模板中包含操作名称、操作级别、操作时间、操作者、一助、二助等信息。 
/// 2、打印病案首页模板时要能从操作记录模板中自动同步数据到病首页-操作情况中 
/// d ##class(%ResultSet).RunQuery("EMRservice.SystemData","GetOperRelRecordInfo",1000)
Query GetOperRelRecordInfo(AEpisodeID As %String) As %Query(ROWSPEC = "OperName1,OperLevel1,OperDateTime1,OperUser1,FirAssist1,SecAssist1,ASA1,AnaMthod1,AnaDoc1,OperName2,OperLevel2,OperDateTime2,OperUser2,FirAssist2,SecAssist2,ASA2,AnaMthod2,AnaDoc2,OperName3,OperLevel3,OperDateTime3,OperUser3,FirAssist3,SecAssist3,ASA3,AnaMthod3,AnaDoc3,OperName4,OperLevel4,OperDateTime4,OperUser4,FirAssist4,SecAssist4,ASA4,AnaMthod4,AnaDoc4,OperName5,OperLevel5,OperDateTime5,OperUser5,FirAssist5,SecAssist5,ASA5,AnaMthod5,AnaDoc5")
{
}

ClassMethod GetOperRelRecordInfoExecute(ByRef qHandle As %Binary, AEpisodeID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:(AEpisodeID="") $$$OK
		
	//操作名称、操作级别、操作时间、操作者、一助、二助等信息
	//操作记录
	//手术记录
	s (OperName,OperLevel,OperDateTime,OperUser,FirAssist,SecAssist,ASA,AnaMthod,AnaDoc)=""
	
	s instancedataid="",ret=""
	&sql(select ID into :instancedataid from EMRInstance.InstanceData where EpisodeID=:AEpisodeID and Title like "%操作记录%" and Status="Save")
	q:(instancedataid="") $$$OK
	s recordid=$p(instancedataid,"||",1)
	s subnum=$p(instancedataid,"||",2)
	s subcount=0
	
	&sql(select InstanceCount into :subcount from EMRInstance.ECRecord where ID=:recordid)
	s intobj=""
	for i=subnum:1:subcount{
		
			s intobj=##class(EMRinstance.InstanceData).%OpenId(recordid_"||"_i)
			continue:(intobj="")
			s intstatus=intobj.Status
			continue:(intstatus'="Save")
			s inttitle=intobj.Title
			continue:(inttitle'="操作记录")
			s inthpdate=intobj.HappenDate
			s inthptime=intobj.HappenTime
			s ^TempDHCEMRMFOROper("GetOperInfo",AEpisodeID,repid,inthpdate,inthptime)=recordid_"||"_i
		
		}

	s tmpDate="",tmpnum=1
	for {
		s tmpDate=$o(^TempDHCEMRMFOROper("GetOperInfo",AEpisodeID,repid,tmpDate))
		q:(tmpDate="")
		s tmpTime=""
		for {
			s tmpTime=$o(^TempDHCEMRMFOROper("GetOperInfo",AEpisodeID,repid,tmpDate,tmpTime))
			q:(tmpTime="")
			s tmpIntid=""
			s tmpIntid=$D(^TempDHCEMRMFOROper("GetOperInfo",AEpisodeID,repid,tmpDate,tmpTime))
			
			
			s OperName(tmpnum)=##Class(EMRservice.BL.BLScatterData).GetScatterData(AEpisodeID,"#TYPE:ICompositeSample#TID:295#SCODE:S004|CCODE:V007|CSCODE:I004#VTYPE:V",tmpIntid)
			s OperLevel(tmpnum)=##Class(EMRservice.BL.BLScatterData).GetScatterData(AEpisodeID,"#TYPE:ICompositeSample#TID:295#SCODE:S004|CCODE:V007|CSCODE:O001#VTYPE:V",tmpIntid)
			s OperDateTime(tmpnum)=##Class(EMRservice.BL.BLScatterData).GetScatterData(AEpisodeID,"#TYPE:ICompositeSample#TID:295#SCODE:S001|CCODE:V001|CSCODE:D001#VTYPE:V",tmpIntid)
			s OperUser(tmpnum)=##Class(EMRservice.BL.BLScatterData).GetScatterData(AEpisodeID,"#TYPE:ICompositeSample#TID:295#SCODE:S005|CCODE:V002|CSCODE:I007#VTYPE:V",tmpIntid)
			s FirAssist(tmpnum)=##Class(EMRservice.BL.BLScatterData).GetScatterData(AEpisodeID,"#TYPE:ICompositeSample#TID:295#SCODE:S005|CCODE:V002|CSCODE:I008#VTYPE:V",tmpIntid)
			s SecAssist(tmpnum)=##Class(EMRservice.BL.BLScatterData).GetScatterData(AEpisodeID,"#TYPE:ICompositeSample#TID:295#SCODE:S005|CCODE:V002|CSCODE:I006#VTYPE:V",tmpIntid)
			s ASA(tmpnum)=##Class(EMRservice.BL.BLScatterData).GetScatterData(AEpisodeID,"",tmpIntid)
			s AnaMthod(tmpnum)=##Class(EMRservice.BL.BLScatterData).GetScatterData(AEpisodeID,"#TYPE:ICompositeSample#TID:295#SCODE:S006|CCODE:V003|CSCODE:I002#VTYPE:V",tmpIntid)
			s AnaDoc(tmpnum)=##Class(EMRservice.BL.BLScatterData).GetScatterData(AEpisodeID,"#TYPE:ICompositeSample#TID:295#SCODE:S006|CCODE:V003|CSCODE:I003#VTYPE:V",tmpIntid)
			
			s tmpnum=tmpnum+1
			
		}
		
		
	}
	set ^CacheTemp(repid, ind)=$lb()
	
	for i=1:1:tmpnum {
		set ^CacheTemp(repid, ind) = ^CacheTemp(repid, ind)_$lb(OperName(i),OperLevel(i),OperDateTime(i),OperUser(i),FirAssist(i),SecAssist(i),ASA(i),AnaMthod(i),AnaDoc(i))
	}
	set ind = ind + 1
	k ^TempDHCEMRMFOROper("GetOperInfo",AEpisodeID,repid)
	Quit $$$OK
}

ClassMethod GetOperRelRecordInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetOperRelRecordInfoExecute ]
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

ClassMethod GetOperRelRecordInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetOperRelRecordInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
	Quit $$$OK
}

/// 扩展多模板入院记录的数据主诉等病历内容问题
/// 通过术语集，进行数据读取。并提供前端绑定
/// d ##class(%ResultSet).RunQuery("EMRservice.SystemData","GetEMRRecordDataInfo",11)
Query GetEMRRecordDataInfo(AEpisodeID As %String) As %Query(ROWSPEC = "zhusu,xianbingshi,tigejiancha,zhuankeqingkuang,fuzhujiancha,binglitedian,zhenduanyiju,chubuzhenduan,zhenliaojihua,jianbiezhenduan")
{
}

ClassMethod GetEMRRecordDataInfoExecute(ByRef qHandle As %Binary, AEpisodeID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:(AEpisodeID="") $$$OK
	
	s (zhusu,xianbingshi,tigejiancha,zhuankeqingkuang,fuzhujiancha) = ""
	//入院记录 术语集 HDSD00.13.01
	/*
		HDSD00.13.114 主诉
		HDSD00.13.095 现病史
		HDSD00.13.036 个人史
		HDSD00.13.041 婚育史
		HDSD00.13.106 月经史
		HDSD00.13.043 家族史
		HDSD00.13.088 体格检查--体温（℃）
		HDSD00.13.080 体格检查--脉率（次/min）
		HDSD00.13.077 体格检查--呼吸频率（次/min）
		HDSD00.13.085 体格检查--收缩压（mmHg）
		HDSD00.13.086 体格检查--舒张压（mmHg）
		HDSD00.13.094 体格检查--一般状况检查结果
		HDSD00.13.118 专科情况
		HDSD00.13.035 辅助检查结果
		HDSD00.13.112 中医“四诊”观察结果
		HDSD00.13.111 治则治法
		HDSD00.13.023 初步诊断-西医诊断名称
	
	*/
	s AdmRecordGlossary=##class(%ArrayOfDataTypes).%New()
	s AdmRecordGlossary=##class(EMRservice.BL.BLScatterData).GetNewStdDataByGlossary(AEpisodeID,"HDSD00.13.01")

	//主诉
	s zhusu=AdmRecordGlossary.GetAt("HDSD00.13.114")
	
	//现病史
	s xianbingshi=AdmRecordGlossary.GetAt("HDSD00.13.095")
	
	//体格检查
	s tigejiancha=AdmRecordGlossary.GetAt("HDSD00.13.094")
	
	//专科情况
	s zhuankeqingkuang=AdmRecordGlossary.GetAt("HDSD00.13.118")
	
	//辅助检查
	s fuzhujiancha=AdmRecordGlossary.GetAt("HDSD00.13.035")
	
	
	
	/*
	HDSD00.14.005|DE05.10.133.00|病例特点||对病史、体格检查和辅助检查进行全面分析、归纳和整理后写出本病例特征包括阳性发现和具有鉴别诊断意义的阴性症状和体征等|||
	HDSD00.14.119|DE05.01.070.00|诊断依据||疾病诊断的依据描述|||
	HDSD00.14.023|DE05.01.024.00|初步诊断-西医诊断编码||患者入院后初步做出的疾病诊断在西医诊断特定编码体系中的编码|||
	HDSD00.14.052|DE05.01.025.00|鉴别诊断-西医诊断名称||需要进行鉴别的西医疾病诊断名称|||
	HDSD00.14.122|DE06.00.298.00|诊疗计划||具体的检查、中西医治疗措施及中医调护|||

	
	*/
	//首次病程记录
	s FirstRecordGlossary=##class(%ArrayOfDataTypes).%New()
	s FirstRecordGlossary=##class(EMRservice.BL.BLScatterData).GetNewStdDataByGlossary(AEpisodeID,"HDSD00.14.01")
	
	//病例特点
	s binglitedian = FirstRecordGlossary.GetAt("HDSD00.14.005")
	
	//诊断依据
	s zhenduanyiju = FirstRecordGlossary.GetAt("HDSD00.14.119")
	
	//初步诊断
	s chubuzhenduan = FirstRecordGlossary.GetAt("HDSD00.14.023")
	
	//鉴别诊断
	s jianbiezhenduan = FirstRecordGlossary.GetAt("HDSD00.14.052")

	//诊疗计划
	s zhenliaojihua = FirstRecordGlossary.GetAt("HDSD00.14.122")
	
	
	
	
	
	
	s Data = $lb(zhusu,xianbingshi,tigejiancha,zhuankeqingkuang,fuzhujiancha,binglitedian,zhenduanyiju,chubuzhenduan,zhenliaojihua,jianbiezhenduan)
	
	set ^CacheTemp(repid, ind) = Data
	set ind = ind + 1
	Quit $$$OK
}

ClassMethod GetEMRRecordDataInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetEMRRecordDataInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
	Quit $$$OK
}

ClassMethod GetEMRRecordDataInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetEMRRecordDataInfoExecute ]
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

/// Desc:       取用户当前登陆信息服务
/// Creator:    Candy
/// CreateDate: 2016-5-10
/// Input:      parUserId 用户ID
///            parUserLocId 用户登陆科室ID
/// Desc:       d ##Class(%ResultSet).RunQuery("EMRservice.SystemData","GetUserLoginInfo",105,6)
Query GetUserLoginInfo(parUserId As %String, parUserLocId As %String) As %Query(ROWSPEC = "UserCode,UserName,UserDict,UserLocDesc,UserLocDict,UserImage")
{
}

ClassMethod GetUserLoginInfoExecute(ByRef qHandle As %Binary, parUserId As %String, parUserLocId As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	q:(parUserId = "") $$$OK
	s userCode = $p($g(^SSU("SSUSR",parUserId)),"^",1)
	s userName = $p($g(^SSU("SSUSR",parUserId)),"^",2)
	s userDict = parUserId_"^"_userCode_"^"_userName
	s userLocCode = $p($g(^CTLOC(parUserLocId)),"^",1) 
	s userLocDesc = $p($g(^CTLOC(parUserLocId)),"^",2)
	s userLocDict = parUserLocId_"^"_userLocCode_"^"_userLocDesc
	s caRowID = $o(^CA.UsrSignatureInfoI("InUseID"," "_parUserId,1,""))
	s UserImage =""
	if (caRowID'="")
	{
		s objCaUser = ##Class(CA.UsrSignatureInfo).%OpenId(caRowID)
		s UserImage = objCaUser.SignImage
	}
	Set ^CacheTemp(repid, ind) = $LB(userCode,userName,userDict,userLocDesc,userLocDict,UserImage)
	Set ind = ind + 1
	Quit $$$OK
}

ClassMethod GetUserLoginInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetUserLoginInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
	Quit $$$OK
}

ClassMethod GetUserLoginInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetUserLoginInfoExecute ]
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

/// Creator：	Donglulu
/// CreateDate：2017-04-12
/// Desc：		取用户登录信息[HIS]，并且登录用户必须为实习医师
/// Input:		UserId: SS_User rowid
/// Return：
/// Test:		do ##class(%ResultSet).RunQuery("EMRservice.SystemData","GetInternUserInfo","77")
Query GetInternUserInfo(parUserId As %String) As %Query(ROWSPEC = "CurUserCode:%String,CurUserName:%String,CurUserCodeAndName:%String")
{
}

ClassMethod GetInternUserInfoExecute(ByRef qHandle As %Binary, parUserId As %String) As %Status
{

	Set repid=$I(^CacheTemp)
	s ind=1
	Set qHandle=$lb(0,repid,0)

	Quit:($d(^SSU("SSUSR",parUserId))=0)||(parUserId="") $$$OK
	
	s (CurUserCode,CurUserName,CurUserCodeAndName,CTCareProvRowid,CTPCPCarPrvTpDR) = ""
	
	//取代码列,描述列,别名列
	s CurUserCode=$p($g(^SSU("SSUSR",parUserId)),"^",1)
	s CurUserName=$p($g(^SSU("SSUSR",parUserId)),"^",2)
	s CurUserCodeAndName=parUserId_"^"_CurUserCode_"^"_CurUserName
	
	s CTCareProvRowid = $p($g(^SSU("SSUSR",parUserId)),"^",14)
	Quit:(CTCareProvRowid ="") $$$OK
	s CTPCPCarPrvTpDR = $p($g(^CTPCP(CTCareProvRowid,1)),"^",4)
	Quit:(CTPCPCarPrvTpDR'=1)&&(CTPCPCarPrvTpDR'=19) $$$OK
		
	set ^CacheTemp(repid, ind) = $LB(CurUserCode,CurUserName,CurUserCodeAndName)
	set ind = ind + 1
	
	Quit $$$OK
}

ClassMethod GetInternUserInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetInternUserInfoExecute ]
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

ClassMethod GetInternUserInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetInternUserInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
	Quit $$$OK
}

/// Creator:	guozogntao
/// CreateDate:	2017-12-04
/// Desc:		[EMR]病历实例的全局参数信息
/// Input： 	PatientID：患者id  	
///             EpisodeID：就诊id
///             UserCode:  用户编码
///             SessionID: 会话ID
///             UserID：   用户ID
///             UserName： 用户姓名
///             SsgroupID: 安全组
///             UserLocID: 用户科室
///             DiseaseID：病种id
///             IPAddress：客户端IP地址
/// Return：    除了入参，增加返回列如下：
///             SsgroupName：安全组名称
///             UserDict：  用户ID^用户编码^用户名称
///             UserLocCode：用户科室编码
///             UserLocName：用户科室名称
///             UserLocDict：用户科室ID^用户科室编码^用户科室
/// Test:		d ##class(%ResultSet).RunQuery("EMRservice.SystemData","GetEMRInstParamInfo","1","1","UserCode","SessionID","UserID","UserName","1","1","0","IPAddress")
Query GetEMRInstParamInfo(PatientID As %String, EpisodeID As %String, UserCode As %String, SessionID As %String, UserID As %String, UserName As %String, SsgroupID As %String, UserLocID As %String, DiseaseID As %String, IPAddress As %String) As %Query(ROWSPEC = "DiseaseID,EpisodeID,IPAddress,PatientID,SessionID,SsgroupID,SsgroupName,UserID,UserCode,UserName,UserDict,UserLocID,UserLocCode,UserLocName,UserLocDict")
{
}

ClassMethod GetEMRInstParamInfoExecute(ByRef qHandle As %Binary, PatientID As %String, EpisodeID As %String, UserCode As %String, SessionID As %String, UserID As %String, UserName As %String, SsgroupID As %String, UserLocID As %String, DiseaseID As %String, IPAddress As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	Set qHandle=$lb(0,repid,0)
	Quit:($d(^PAADM(EpisodeID))=0)||(EpisodeID="") $$$OK
	s (UserLocCode,UserLocName)=""
	s SsgroupName = $p($g(^SSU("SSGRP",SsgroupID)),"^",1)
	
	s UserCode = $p($g(^SSU("SSUSR",UserID)),"^",1)
	s UserName = $p($g(^SSU("SSUSR",UserID)),"^",2)
	s UserDict = UserID_"^"_UserCode_"^"_UserName
	
	s UserLocCode = $p($g(^CTLOC(UserLocID)),"^",1)
	s UserLocName = $p($g(^CTLOC(UserLocID)),"^",2)
	s UserLocDict =UserLocID_"^"_UserLocCode_"^"_UserLocName
		
	set ^CacheTemp(repid, ind) = $LB(DiseaseID,EpisodeID,IPAddress,PatientID,SessionID,SsgroupID,SsgroupName,UserID,UserCode,UserName,c,UserLocID,UserLocCode,UserLocName,UserLocDict)
	set ind = ind + 1
	
	Quit $$$OK
}

ClassMethod GetEMRInstParamInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetEMRInstParamInfoExecute ]
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

ClassMethod GetEMRInstParamInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetEMRInstParamInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
	Quit $$$OK
}

/// 过敏史
/// W ##class(EMRservice.SystemData).GetAdmPAAllergyInfo(6598145)
ClassMethod GetAdmPAAllergyInfo(PapmiDR As %String) As %String
{
	
	s PAAllergyInfo = "",PAAllergyDesc = ""
	
	s count = $G(^PAPER(PapmiDR,"ALG",0))
	f i=1:1:count  d
	.s PAAllergyDesc = $P($g(^PAPER(PapmiDR,"ALG",i,"DHC")),"^",1)
	.s:(PAAllergyInfo'="") PAAllergyInfo = PAAllergyInfo_","
	.s PAAllergyInfo = PAAllergyInfo_PAAllergyDesc
	
	q PAAllergyInfo
}

/// Desc:       根据日期取患者当前就诊转科信息
/// Creator:    Candy
/// CreateDate: 2018-4-25
/// Input:      qEpisodeID 就诊ID
///            pDateTime 日期 时间 格式 "YYYY-MM-DD HH:MM:SS"
/// Output:     LocID:科室ID
///            LocDesc:科室描述
/// Debug:      d ##Class(%ResultSet).RunQuery("EMRservice.SystemData","GetAdmDataByDateTime",456449,"2018-04-19 09:26:55")
Query GetAdmDataByDateTime(qEpisodeID As %String, pDateTime As %String) As %Query(ROWSPEC = "LocID:%String,LocDesc:%String")
{
}

ClassMethod GetAdmDataByDateTimeExecute(ByRef qHandle As %Binary, qEpisodeID As %String, pDateTime As %String) As %Status
{
	s repid = $I(^CacheTemp)
	s qHandle = $lb(0,repid,0)
	s ind = 1
	q:(qEpisodeID = "")||(pDateTime = "") $$$OK
	s date = $zdh($p(pDateTime," ",1),3)
	s time = $zth($p(pDateTime," ",2))
	s datetime = ##Class(EMRservice.Tools.Tool).GetAbsTime(date_","_time)
	s locId = "",LocDesc = ""
	s childSub = 0
	for
	{
		s childSub = $o(^PAADM(qEpisodeID,"TRANS",childSub)) 
		q:(childSub = "")
		s startDate	= $p(^PAADM(qEpisodeID,"TRANS",childSub),"^",1)
		s startTime = $p(^PAADM(qEpisodeID,"TRANS",childSub),"^",2)
		s endDate = $p(^PAADM(qEpisodeID,"TRANS",childSub),"^",3)
		s endTime = $p(^PAADM(qEpisodeID,"TRANS",childSub),"^",4)
		s lastNum = ^PAADM(qEpisodeID,"TRANS",0)
		continue:((endDate = "")&&(lastNum '= childSub))
		s:(endDate = "") endDate = $p($h,",",1)
		s:(endTime = "") endTime = $p($h,",",2)
		s stDateTime = ##Class(EMRservice.Tools.Tool).GetAbsTime(startDate_","_startTime) 
		s edDateTime = ##Class(EMRservice.Tools.Tool).GetAbsTime(endDate_","_endTime)    	
		continue:((datetime > edDateTime)||(datetime < stDateTime))
		s locId = $p(^PAADM(qEpisodeID,"TRANS",childSub),"^",6)
		continue:(locId = "")
		s:(locId '= "") LocDesc = $p($g(^CTLOC(locId)),"^",2)
		s ^CacheTemp(repid,ind) = $lb(locId,LocDesc)
		s ind = ind + 1
		q:(locId '= "")
	}
	Quit $$$OK
}

ClassMethod GetAdmDataByDateTimeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAdmDataByDateTimeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetAdmDataByDateTimeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAdmDataByDateTimeExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 		kill ^CacheTemp(repid)
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Desc:       获取预检分诊信息
/// Creator:    Lina
/// CreateDate: 2018-9-3
/// Input:      parAdmId 就诊号
/// Return:     EmPatChkSign 生命体征
///             EmPatChkHis 既往史
///             EmSymDesc 症状
/// d ##class(%ResultSet).RunQuery("EMRservice.SystemData","GetPretriageData","343")
Query GetPretriageData(parAdmId As %String) As %Query(ROWSPEC = "EmPatChkSign:%String,EmPatChkHis:%String,EmSymDesc:%String")
{
}

ClassMethod GetPretriageDataExecute(ByRef qHandle As %Binary, parAdmId As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	q:(parAdmId = "") $$$OK
	
	//入参是就诊ID，出参是生命体征、既往史、症状，分隔符为"#"
	s PatChkString = ##Class(web.DHCEMPatCheckLevQuery).QueryPatChkSign(parAdmId)
	//s PatChkString = "时间:13:50; 体温:41.5; 心率HR:55; 脉搏R:66; 血压(BP)收缩压:120; 舒张压:88; 血氧饱合度SoP2:88:糖尿病; COPD:肢运:半边肢体肌力下降＜24h*(肌力＜5，时间＜24h); 肢运#半边肢体肌力下降＜3h*(肌力＜5，时间＜3h)#"
	
	//生命体征
	s EmPatChkSign = $P(PatChkString,"#",1)
	//既往史
	s EmPatChkHis = $P(PatChkString,"#",2)
	//症状
	s EmSymDesc = $P(PatChkString,"#",3)
	
	Set ^CacheTemp(repid, ind) = $LB(EmPatChkSign,EmPatChkHis,EmSymDesc)
	Set ind = ind + 1
	Quit $$$OK
}

ClassMethod GetPretriageDataClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPretriageDataExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
	Quit $$$OK
}

ClassMethod GetPretriageDataFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPretriageDataExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" 
	{				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      
	{				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

Query GetAdmOPInfo(parAdmId As %String) As %Query(ROWSPEC = "OPDiag,OPOeord")
{
}

/// do ##class(%ResultSet).RunQuery("EMRservice.SystemData","GetAdmOPInfo","2149")
ClassMethod GetAdmOPInfoExecute(ByRef qHandle As %Binary, parAdmId As %String) As %Status
{
	//s ^temp("aa",$h) = parAdmId
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	q:(parAdmId = "") $$$OK
	s OPDiag = ##Class(EMRservice.BL.opInterface).getDiagDataXH(parAdmId,"\r\n")
	s:(OPDiag) OPDiag=$REPLACE(OPDiag, "@", "\r\n")
	s OPOeord = ##Class(EMRservice.BL.opInterface).getOeordXH(parAdmId)
	s:(OPOeord) OPOeord=$REPLACE(OPOeord, "@", "\r\n")
	Set ^CacheTemp(repid, ind) = $LB(OPDiag,OPOeord)
	Set ind = ind + 1
	Quit $$$OK
}

ClassMethod GetAdmOPInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAdmOPInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
	Quit $$$OK
}

ClassMethod GetAdmOPInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAdmOPInfoExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" 
	{				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      
	{				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：	从会诊记录中取会诊信息,用于电子病历的模板“多学科综合会诊记录”
/// CreateDate：-190624
/// Desc：		取医嘱次数数据
/// Input:		ProductSourceCode: 会诊ID
/// Return：	//患者姓名^性别^年龄^出生日期^卡号^病案号^联系电话^通讯地 址^邮编^主持人描述^会诊日期^会诊地址^
///         	//病情摘要^会诊目的^会诊意见&科室1^用 户1^用户职称1@科室2^用户2^用户职称2
/// Test:			
/// ##Class(EMRservice.SystemData).testGetMdtConsData(461)	
Query GetMdtConsDataToemr(ProductSourceCode As %String) As %Query(ROWSPEC = "AddressCON,PostCodeCON,HostDesCON,PreDateTimeCON,CstNPlaceCON,CstTreProCON,CstPurposeCON,TreMeasuresCON,PatTelHCON,DocListCon")
{
}

ClassMethod GetMdtConsDataToemrExecute(ByRef qHandle As %Binary, ProductSourceCode As %String) As %Status
{

	Set repid=$I(^CacheTemp)
	s ind=1
	Set qHandle=$lb(0,repid,0)

	Quit:(ProductSourceCode="") $$$OK
	// 取系统参数
	//s Hospital=##class(EMRservice.BL.BLSysOption).GetOptionValueByName("HospitalName")
  	//s SpaceHIS=##class(EMRservice.BL.BLSysOption).GetOptionValueByName("NameSpaceHIS")
	
	//患者姓名^性别^年龄^出生日期^卡号^病案号^联系电话^通讯地 址^邮编^主持人描述^会诊日期^会诊地址^
	//病情摘要^会诊目的^会诊意见&科室1^用 户1^用户职称1@科室2^用户2^用户职称2
	//PatName_"^"_PatSex_"^"_PatAge_"^"_Birthday_"^"_PatCardNo_"^"_MedicalNo_"^"_PatTelH_^_Address_"^"_
	//PostCode_"^"_HostDes_"^"_PreDateTime_"^"_CstNPlace_"^"_CstTrePro_"^"_CstPurpose_"^"_TreMeasures
	//爱新觉罗·皇太极^男^119岁^1900-01-01^^100202^13111111111^^^^2019-06-25 上午^会诊科室4楼
	//^EDD^诊断诊断诊断^ascdscsdf^4&主任医师&何小慧@4&住院医师&王心慰@32&副主任医师&刘杰@32&主任医师&高纪东
    s (ConsDatatemp)=""
    s (AddressCON,PostCodeCON,HostDesCON,PreDateTimeCON,CstNPlaceCON,CstTreProCON,CstPurposeCON,TreMeasuresCON)=""
    //s ConsDatatemp=##Class(web.DHCMDTInterface).GetMdtConsDataInAppAdmID(Adm)
    s ConsDatatemp=##Class(web.DHCMDTInterface).GetMdtConsData(ProductSourceCode)
    s AddressCON     =$p(ConsDatatemp,"^",8)     //通讯地 址
	s PostCodeCON    =$p(ConsDatatemp,"^",9)     //邮编 
	s HostDesCON     =$p(ConsDatatemp,"^",10)    //主持人描述
	s PreDateTimeCON =$p($p(ConsDatatemp,"^",11)," ",1)  //会诊日期
	s CstNPlaceCON   =$p(ConsDatatemp,"^",12)  //会诊地址
	s CstTreProCON   =$p(ConsDatatemp,"^",13)  //病情摘要
	s CstPurposeCON  =$p(ConsDatatemp,"^",14)  //会诊目的
	s TreMeasuresCON =$p(ConsDatatemp,"^",15)  //会诊意见
    
    //联系电话
    s PatTelHCON     =$p(ConsDatatemp,"^",7)
    
    s DocListCon = ..GetFormateDocList($p(ConsDatatemp,"^",16))
    
	set ^CacheTemp(repid, ind) = $LB(AddressCON,PostCodeCON,HostDesCON,PreDateTimeCON,CstNPlaceCON,CstTreProCON,CstPurposeCON,TreMeasuresCON,PatTelHCON,DocListCon)
	set ind = ind + 1
	

	Quit $$$OK
}

ClassMethod GetMdtConsDataToemrFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetMdtConsDataToemrExecute ]
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

ClassMethod GetMdtConsDataToemrClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetMdtConsDataToemrExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
	Quit $$$OK
}

ClassMethod GetFormateDocList(list)
{
	//s list = $p(ConsDatatemp,"^",16)
	 
	s listid = ""
    s listdoc = ""
    
    s lc = $L(list,"@")
    for i = 1:1:lc
    {
	    s one = $p(list,"@",i)
	    continue:(one="")
	    
	    s ctloc = ""
	    s ctlocid = $p(one,"&",1)
	    s:(ctlocid '= "") ctloc = $p($g(^CTLOC(ctlocid)),"^",2)
		s:($l(ctloc,"-")>1) ctloc = $p(ctloc,"-",2)
	    
	    s doc = $p(one,"&",3)
	    
	    s index = $listfind(listid,ctlocid)
	    if (index = 0)
	    {
		    s listid = listid_$lb(ctlocid)
		    s listdoc = listdoc_$lb(ctloc_":"_doc)
	    }
	    else
	    {
		    s $list(listdoc,index) = $list(listdoc,index)_","_doc
	    }
    }
    
    q:(listdoc = "") ""
    
    q $listtostring(listdoc,$c(10))
}

/// 通过就诊号获取过敏史信息
/// d ##class(%ResultSet).RunQuery("EMRservice.SystemData","GetAllergicInfo",96)
Query GetAllergicInfo(parAdmId As %String) As %Query(ROWSPEC = "Allergic,allergicMono,allergicstr,allergicstrFirstPage")
{
}

ClassMethod GetAllergicInfoExecute(ByRef qHandle As %Binary, parAdmId As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	q:(parAdmId = "") $$$OK
	
	// 全部过敏信息
	s allergic = ##Class(EMRservice.BL.opInterface).getAllergic(parAdmId,"")
	s:(allergic="") allergic = "否认药物或食物过敏史"
	if (allergic'="否认药物或食物过敏史")
	{
		s allergicstr = allergic
		s:(allergicstr["]") allergicstr = $P(allergicstr,"]",2)
		s:(allergicstr["<") allergicstr = $P(allergicstr,"<",1)
	}
	
	// 病案首页-只留下药物过敏
	s allergicFirstPage = ##Class(EMRservice.BL.opInterface).getAllergicForFirstPage(parAdmId,"")
	s:(allergicFirstPage="") allergicFirstPage = "否认药物或食物过敏史"
	s allergicMono = "1^无"
	s allergicstrFirstPage = ""
	if (allergicFirstPage'="否认药物或食物过敏史")
	{
		s allergicMono = "2^有"
		//s:(allergicstrFirstPage["]") allergicstrFirstPage = $P(allergicFirstPage,"]",2)
		//s:(allergicstrFirstPage["<") allergicstrFirstPage = $P(allergicFirstPage,"<",1)
		s allergicstrFirstPage = allergicFirstPage
	}
	
	Set ^CacheTemp(repid, ind) = $LB(allergic,allergicMono,allergicstr,allergicstrFirstPage)
	Set ind = ind + 1
	Quit $$$OK
}

ClassMethod GetAllergicInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAllergicInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
	Quit $$$OK
}

ClassMethod GetAllergicInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAllergicInfoExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" 
	{				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      
	{				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Desc:       查询患者既往输血史数据
/// Creator:    董璐璐
/// CreateDate: 2020-1-8
/// Input:      parAdmId 就诊号
/// Output:     既往史，最近输血日期，不良反应，不良反应说明，器官移植，器官移植供血者血型DR，骨髓移植,骨髓移植供血者血型DR，特殊药物，药物说明，孕产史，孕次，产次，器官移植供血者血型,骨髓移植供血者血型
/// Desc:       d ##Class(%ResultSet).RunQuery("EMRservice.SystemData","GetPastHistoryInfo",5)
Query GetPastHistoryInfo(parAdmId As %String) As %Query(ROWSPEC = "IsTransHistory:%String,LastTransDate:%String,IsUntowardEffect:%String,UntowardEffectNote:%String,IsOrganExplant:%String,OrganBloodGroupDR:%String,IsKeestExplant:%String,KeestBloodGroupDR:%String,IsDrugHistory:%String,DrugList:%String,IsPregHistory:%String,Pregnancies:%String,ChildBirths:%String,OrganBloodGroup:%String,KeestBloodGroup:%String")
{
}

ClassMethod GetPastHistoryInfoExecute(ByRef qHandle As %Binary, parAdmId As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	q:(parAdmId = "") $$$OK
	
	s ds = ##Class(%Library.ResultSet).%New("DHCLIS.DHCBDAgreeFormInterface:QryPastHistoryInfo")
	d ds.Execute(parAdmId,"","","","","","","","","","","",20,1,"106^10^^13^1")
	While (ds.Next())
	{
		s IsTransHistory = ds.Data("IsTransHistory")
		s IsTransHistory = ##class(EMRservice.SystemData).ChangeTypeToO(IsTransHistory)
		s LastTransDate = ds.Data("LastTransDate")
		s:(LastTransDate '= "") LastTransDate = LastTransDate_" 00:00:00"
		s IsUntowardEffect = ds.Data("IsUntowardEffect")
		s IsUntowardEffect = ##class(EMRservice.SystemData).ChangeTypeToO(IsUntowardEffect)
		s UntowardEffectNote = ds.Data("UntowardEffectNote")
		s IsOrganExplant = ds.Data("IsOrganExplant")
		s IsOrganExplant = ##class(EMRservice.SystemData).ChangeTypeToO(IsOrganExplant)
		s OrganBloodGroupDR = ds.Data("OrganBloodGroupDR")
		s IsKeestExplant = ds.Data("IsKeestExplant")
		s IsKeestExplant = ##class(EMRservice.SystemData).ChangeTypeToO(IsKeestExplant)
		s KeestBloodGroupDR = ds.Data("KeestBloodGroupDR")
		s IsDrugHistory = ds.Data("IsDrugHistory")
		s IsDrugHistory = ##class(EMRservice.SystemData).ChangeTypeToO(IsDrugHistory)
		s DrugList = ds.Data("DrugList")
		s IsPregHistory = ds.Data("IsPregHistory")
		s IsPregHistory = ##class(EMRservice.SystemData).ChangeTypeToO(IsPregHistory)
		s Pregnancies = ds.Data("Pregnancies")
		s ChildBirths = ds.Data("ChildBirths")
		s OrganBloodGroup = ds.Data("OrganBloodGroup")
		s OrganBloodGroup = ##class(EMRservice.SystemData).ChangeBloodTypeToI(OrganBloodGroup)
		s KeestBloodGroup = ds.Data("KeestBloodGroup")
		s KeestBloodGroup = ##class(EMRservice.SystemData).ChangeBloodTypeToI(KeestBloodGroup)
		
		Set ^CacheTemp(repid, ind) = $LB(IsTransHistory,LastTransDate,IsUntowardEffect,UntowardEffectNote,IsOrganExplant,OrganBloodGroupDR,IsKeestExplant,KeestBloodGroupDR,IsDrugHistory,DrugList,IsPregHistory,Pregnancies,ChildBirths,OrganBloodGroup,KeestBloodGroup)
		Set ind = ind + 1
	}
	
	Quit $$$OK
}

ClassMethod GetPastHistoryInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPastHistoryInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
	Quit $$$OK
}

ClassMethod GetPastHistoryInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPastHistoryInfoExecute ]
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

/// W ##class(EMRservice.SystemData).ChangeTypeToO("0")
ClassMethod ChangeTypeToO(AValue As %String) As %String
{
	s result = "^"
	q:(AValue="") result
	if (AValue = "0")
	{
		s result = "0^无"
	}
	elseif(AValue = "1")
	{
		s result = "1^有"
	}
	else
	{
		s result = AValue
	}
	q result
}

/// W ##class(EMRservice.SystemData).ChangeBloodTypeToI("")
ClassMethod ChangeBloodTypeToI(AValue As %String) As %String
{
	s result = "^^"
	q:(AValue="") result
	s ds = ##Class(%Library.ResultSet).%New("DHCLIS.DHCBDAgreeFormInterface:QryBloodGroup")
	d ds.Execute("","","","","","","","","","","","",20,1,"106^10^^13^1")
	While (ds.Next())
	{
		continue:(ds.Data("CName")'=AValue)
		s result = ds.Data("RowID")_"^"_ds.Data("Code")_"^"_ds.Data("CName")
		
	}
	q result
}

/// Desc:       取多个危急值信息
/// Creator:    donglulu
/// CreateDate: 2020-4-20
/// Input:      criticalID 危急值ID（以上尖号为分隔）
/// Desc:       d ##Class(%ResultSet).RunQuery("EMRservice.SystemData","GetSeveralCVInfo",105^2^3)
Query GetSeveralCVInfo(parCriticalIDs As %String) As %Query(ROWSPEC = "referenceContent:%String")
{
}

ClassMethod GetSeveralCVInfoExecute(ByRef qHandle As %Binary, parCriticalIDs As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	q:(parCriticalIDs = "") $$$OK
	
	s referenceContent = ""
	s length = $l(parCriticalIDs,"^")
	for I=1:1:length
	{
		s parCriticalID = $p(parCriticalIDs,"^",I)
		s obj = ##Class(BSP.CV.SRV.Interface).GetOneCVInfo(parCriticalID)
		q:(obj = "")
		
		s schemeSys = ##Class(EMRservice.BL.BLSysOption).GetOptionValueByName("criticalBindScheme")
		s:(schemeSys = "") schemeSys = "<scheme><reference><parent><item><code>recDT</code><desc></desc><separate></separate></item><item><code>repResult</code><desc>接危急值报告：</desc><separate>；</separate></item></parent><child><item><code>ordDesc</code><desc></desc><separate></separate></item><item><code>ordDoseQty</code><desc></desc><separate></separate></item><item><code>ordDoseUnit</code><desc></desc><separate></separate></item><item><code>ordPHFreq</code><desc></desc><separate></separate></item><item><code>ordInstrDr</code><desc></desc><separate></separate></item><item><code>ordDura</code><desc></desc><separate></separate></item></child></reference></scheme>"
		s scheme = ##Class(%GlobalCharacterStream).%New()
		d scheme.Write(schemeSys)
		s sc =##class(%XML.XPATH.Document).CreateFromStream(scheme,.documentList)
		q:($$$ERROR(sc))
		s sc = documentList.EvaluateExpression("/scheme/reference/parent","count(item)",.documentNode)
		q:($$$ERROR(sc)||(documentNode.GetAt(1)=""))
		s dcount = documentNode.GetAt(1).Value
		for i=1:1:dcount
		{
			s sc = documentList.EvaluateExpression("/scheme/reference/parent/item["_i_"]/code","text()",.result)
			continue:($$$ERROR(sc)||(result.GetAt(1)=""))
			s code = result.GetAt(1).Value
			s sc = documentList.EvaluateExpression("/scheme/reference/parent/item["_i_"]/desc","text()",.result)
			continue:($$$ERROR(sc))
			s desc = ""
			s:(result.GetAt(1)'="") desc = result.GetAt(1).Value
			s sc = documentList.EvaluateExpression("/scheme/reference/parent/item["_i_"]/separate","text()",.result)
			continue:($$$ERROR(sc))
			s separate = ""
			s:(result.GetAt(1)'="") separate = result.GetAt(1).Value
			s:(separate = "enter") separate = "\r\n"
			s:(separate = "blackspace") separate = " "
			if (code '= "trOrdItemList")
			{
				s value = obj.%Get(code)
				s:(code [ "Date") value=$zd(value,3)
				s:(code [ "Time") value=$zt(value,2)
				s referenceContent = referenceContent_desc_value_separate 
			}
			else
			{
				s trOrdItemList = obj.trOrdItemList
				s trOrdItemContent = ""
				s len=trOrdItemList.%Size()
				for j=1:1:len{
					s objItem=trOrdItemList.%Get(j)

					s schemeSysChild = ##Class(EMRservice.BL.BLSysOption).GetOptionValueByName("criticalBindScheme")
					s:(schemeSysChild = "") schemeSysChild = "<scheme><reference><parent><item><code>recDT</code><desc></desc><separate></separate></item><item><code>repResult</code><desc>接危急值报告：</desc><separate>；</separate></item></parent><child><item><code>ordDesc</code><desc></desc><separate></separate></item><item><code>ordDoseQty</code><desc></desc><separate></separate></item><item><code>ordDoseUnit</code><desc></desc><separate></separate></item><item><code>ordPHFreq</code><desc></desc><separate></separate></item><item><code>ordInstrDr</code><desc></desc><separate></separate></item><item><code>ordDura</code><desc></desc><separate></separate></item></child></reference></scheme>"
					s schemeChild = ##Class(%GlobalCharacterStream).%New()
					d schemeChild.Write(schemeSysChild)
					s sc =##class(%XML.XPATH.Document).CreateFromStream(schemeChild,.documentListChild)
					q:($$$ERROR(sc))
					s sc = documentListChild.EvaluateExpression("/scheme/reference/child","count(item)",.documentNode)
					q:($$$ERROR(sc)||(documentNode.GetAt(1)=""))
					s count = documentNode.GetAt(1).Value
					for k=1:1:count
					{
						s sc = documentListChild.EvaluateExpression("/scheme/reference/child/item["_k_"]/code","text()",.result)
						continue:($$$ERROR(sc)||(result.GetAt(1)=""))
						s code = result.GetAt(1).Value
						s sc = documentListChild.EvaluateExpression("/scheme/reference/child/item["_k_"]/desc","text()",.result)
						continue:($$$ERROR(sc))
						s desc = ""
						s:(result.GetAt(1)'="") desc = result.GetAt(1).Value
						s sc = documentListChild.EvaluateExpression("/scheme/reference/child/item["_k_"]/separate","text()",.result)
						continue:($$$ERROR(sc))
						s separate = ""
						s:(result.GetAt(1)'="") separate = result.GetAt(1).Value	
						s:(separate = "enter") separate = "\r\n"
						s:(separate = "blackspace") separate = " "
						s value = objItem.%Get(code)
						s:(code [ "Date") value=$zd(value,3)
						s:(code [ "Time") value=$zt(value,2)
						s trOrdItemContent = trOrdItemContent_desc_value_separate 		
					}
				}
				s referenceContent = referenceContent_desc_trOrdItemContent_separate 
			}	
		}
	}
	Set ^CacheTemp(repid, ind) = $LB(referenceContent)
	Set ind = ind + 1
	
	Quit $$$OK
}

ClassMethod GetSeveralCVInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetSeveralCVInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
	Quit $$$OK
}

ClassMethod GetSeveralCVInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetSeveralCVInfoExecute ]
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

/// Desc:       取危急值信息
/// Creator:    donglulu
/// CreateDate: 2020-4-20
/// Input:      criticalID 危急值ID
/// Output:     reportID危急值id,examNo检验(检查)号,repResult危急值报告内容,repType危急值类型,repTypeDesc危急值类型描述,ordItemId此检验(检查)的医嘱Id,ordItemDesc此检验(检查)的医嘱名称,repLoc报告科室,repUserName报告人名字,repDate报告日期,repTime报告时间,repDT报告日期时间,trUserName处理人名字,trDate处理日期,trTime处理时间,trDT处理日期时间,trAdvice处理意见措施,trOrdItemContent处理医嘱,admDT就诊时间,admLocDesc就诊科室,admDocName主管医生,adm就诊id,patPhone患者手机,patientID患者ID,recUserName接收人名字,recDate接收日期,recTime接收时间,recDT接收日期时间
/// Desc:       d ##Class(%ResultSet).RunQuery("EMRservice.SystemData","GetOneCVInfo",105)
Query GetOneCVInfo(parCriticalID As %String) As %Query(ROWSPEC = "reportID:%String,examNo:%String,repResult:%String,repType:%String,repTypeDesc:%String,ordItemId:%String,ordItemDesc:%String,repLoc:%String,repUserName:%String,repDate:%String,repTime:%String,repDT:%String,trUserName:%String,trDate:%String,trTime:%String,trDT:%String,trAdvice:%String,trOrdItemContent:%String,admDT:%String,admLocDesc:%String,admDocName:%String,adm:%String,patPhone:%String,patientID:%String,recUserName:%String,recDate:%String,recTime:%String,recDT:%String,trOrdItemContent:%String")
{
}

ClassMethod GetOneCVInfoExecute(ByRef qHandle As %Binary, parCriticalID As %String, EventID As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	q:(parCriticalID = "") $$$OK
	
	if (EventID '= "")
	{
		s eventObj = ##class(EMRinstance.Events.CriticalValue).%OpenId(EventID)
		s parCriticalID = eventObj.FromCode
	}
	
	s parCriticalID = $p(parCriticalID,"^",1)
	s obj = ##Class(BSP.CV.SRV.Interface).GetOneCVInfo(parCriticalID)
	q:(obj = "") $$$OK
	
	s reportID = obj.reportID
	s examNo = obj.examNo
	s repResult = obj.repResult
	s repType = obj.repType
	s repTypeDesc = obj.repTypeDesc
	s ordItemId = obj.ordItemId
	s ordItemDesc = obj.ordItemDesc
	s repLoc = obj.repLoc
	s repUserName = obj.repUserName
	s repDate = obj.repDate
	s:(repDate'="") repDate=$zd(repDate,3)
	s repTime = obj.repTime
	s:(repTime'="") repTime=$zt(repTime,2)
	
	s repDT = obj.repDT
	s trUserName = obj.trUserName
	s trDate = obj.trDate
	s:(trDate'="") trDate=$zd(trDate,3)
	s trTime = obj.trTime
	s:(trTime'="") trTime=$zt(trTime,2)
	s trDT = obj.trDT
	s trAdvice = obj.trAdvice
	s trOrdItemList = obj.trOrdItemList
	
	s admDT = obj.admDT
	s admLocDesc = obj.admLocDesc
	s admDocName = obj.admDocName
	s adm = obj.adm
	s patPhone = obj.patPhone
	s patientID = obj.patientID
	s recUserName = obj.recUserName
	s recDate = obj.recDate
	s:(recDate'="") recDate=$zd(recDate,3)
	s recTime = obj.recTime
	s:(recTime'="") recTime=$zt(recTime,2)
	s recDT = obj.recDT	
	
	s trOrdItemContent = ""
	s len=trOrdItemList.%Size()
	for i=1:1:len{
		s objItem=trOrdItemList.%Get(i)

		s schemeSys = ##Class(EMRservice.BL.BLSysOption).GetOptionValueByName("criticalBindScheme")
		s:(schemeSys = "") schemeSys = "<scheme><reference><parent><item><code>recDT</code><desc></desc><separate></separate></item><item><code>repResult</code><desc>接危急值报告：</desc><separate>；</separate></item></parent><child><item><code>ordDesc</code><desc></desc><separate></separate></item><item><code>ordDoseQty</code><desc></desc><separate></separate></item><item><code>ordDoseUnit</code><desc></desc><separate></separate></item><item><code>ordPHFreq</code><desc></desc><separate></separate></item><item><code>ordInstrDr</code><desc></desc><separate></separate></item><item><code>ordDura</code><desc></desc><separate></separate></item></child></reference></scheme>"
		s scheme = ##Class(%GlobalCharacterStream).%New()
		d scheme.Write(schemeSys)
		s sc =##class(%XML.XPATH.Document).CreateFromStream(scheme,.documentList)
		q:($$$ERROR(sc))
		s sc = documentList.EvaluateExpression("/scheme/reference/child","count(item)",.documentNode)
		q:($$$ERROR(sc)||(documentNode.GetAt(1)=""))
		s dcount = documentNode.GetAt(1).Value
		for j=1:1:dcount
		{
			s sc = documentList.EvaluateExpression("/scheme/reference/child/item["_j_"]/code","text()",.result)
			continue:($$$ERROR(sc)||(result.GetAt(1)=""))
			s code = result.GetAt(1).Value
			s sc = documentList.EvaluateExpression("/scheme/reference/child/item["_j_"]/desc","text()",.result)
			continue:($$$ERROR(sc))
			s desc = ""
			s:(result.GetAt(1)'="") desc = result.GetAt(1).Value
			s sc = documentList.EvaluateExpression("/scheme/reference/child/item["_j_"]/separate","text()",.result)
			continue:($$$ERROR(sc))
			s separate = ""
			s:(result.GetAt(1)'="") separate = result.GetAt(1).Value	
			s:(separate = "enter") separate = "\r\n"
			s:(separate = "blackspace") separate = " "
			s value = objItem.%Get(code)
			s:(code [ "Date") value=$zd(value,3)
			s:(code [ "Time") value=$zt(value,2)
			s trOrdItemContent = trOrdItemContent_desc_value_separate 		
		}
	}
	Set ^CacheTemp(repid, ind) = $LB(reportID,examNo,repResult,repType,repTypeDesc,ordItemId,ordItemDesc,repLoc,repUserName,repDate,repTime,repDT,trUserName,trDate,trTime,trDT,trAdvice,trOrdItemContent,admDT,admLocDesc,admDocName,adm,patPhone,patientID,recUserName,recDate,recTime,recDT,trOrdItemContent)
	Set ind = ind + 1
	Quit $$$OK
}

ClassMethod GetOneCVInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetOneCVInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
	Quit $$$OK
}

ClassMethod GetOneCVInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetOneCVInfoExecute ]
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

/// Desc:       通过实例ID获取模板编码
/// Creator:    yejian
/// CreateDate: 2021-4-14
/// Input:      instanceID 实例ID
/// Output:     TemplateCode 模板编码（EMRmeta.Template表TypeCode字段）
/// Desc:       d ##Class(%ResultSet).RunQuery("EMRservice.SystemData","GetTemplateCode","325||1")
/// d ##class(%ResultSet).RunQuery("EMRservice.SystemData","GetAllergicInfo",27232504)
Query GetTemplateCode(aInstanceID As %String) As %Query(ROWSPEC = "TemplateCode:%String")
{
}

ClassMethod GetTemplateCodeExecute(ByRef qHandle As %Binary, aInstanceID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	q:(aInstanceID = "") $$$OK
	
	s objInstance = ##class(EMRinstance.InstanceData).%OpenId(aInstanceID)
	q:(objInstance = "") $$$OK
	s strTempateID = objInstance.RealTemplateID
	s objTemplate = ##Class(EMRmeta.Template).%OpenId(strTempateID)
	q:(objTemplate = "") $$$OK
	s TemplateCode = objTemplate.TypeCode
	d objInstance.%Close()
	Set ^CacheTemp(repid, ind) = $LB(TemplateCode)
	Set ind = ind + 1
	Quit $$$OK
}

ClassMethod GetTemplateCodeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetTemplateCodeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
	Quit $$$OK
}

ClassMethod GetTemplateCodeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetTemplateCodeExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" 
	{				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      
	{				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// 通过就诊号获取结构化诊断信息
/// d ##class(%ResultSet).RunQuery("EMRservice.SystemData","GetStructDiagInfo",27232504)
Query GetStructDiagInfo(parAdmId As %String) As %Query(ROWSPEC = "StructDiag")
{
}

ClassMethod GetStructDiagInfoExecute(ByRef qHandle As %Binary, parAdmId As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	q:(parAdmId = "") $$$OK
	
	s admNo = $p($g(^PAADM(parAdmId)),"^",81)
	q:(admNo = "") $$$OK
	
	s structDiag = ##Class(EMRservice.BL.HyperLink).GetStructDiagData(admNo)
	
	Set ^CacheTemp(repid, ind) = $LB(structDiag)
	Set ind = ind + 1
	Quit $$$OK
}

ClassMethod GetStructDiagInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetStructDiagInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
	Quit $$$OK
}

ClassMethod GetStructDiagInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetStructDiagInfoExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" 
	{				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      
	{				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// 通过事件ID获取危急值内容
/// Input:parEventIds 事件ID，多个以@分隔
/// d ##class(%ResultSet).RunQuery("EMRservice.SystemData","GetCriticalInfo","2@3")
Query GetCriticalInfo(parEventIds As %String) As %Query(ROWSPEC = "Content")
{
}

ClassMethod GetCriticalInfoExecute(ByRef qHandle As %Binary, parEventIds As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	q:(parEventIds = "") $$$OK
	
	s content = ""
	s length = $l(parEventIds,"@")
	for I=1:1:length
	{
		s eventID = $p(parEventIds,"@",I)
		s obj = ##Class(EMRinstance.Events.CriticalValue).%OpenId(eventID)
		q:(obj = "")
		continue:(obj.Content = "")
		s:(content'="") content = content_" "
		s content = content_obj.Content
	}
	
	Set ^CacheTemp(repid, ind) = $LB(content)
	Set ind = ind + 1
	Quit $$$OK
}

ClassMethod GetCriticalInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetCriticalInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
	Quit $$$OK
}

ClassMethod GetCriticalInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetCriticalInfoExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" 
	{				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      
	{				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// 通过事件ID获取会诊相关信息
/// Input:parEventIds 事件ID
/// Output:PatName患者姓名,CstType会诊类型,CstRDateTime会诊申请时间,CstRUser申请医师,CstRLoc申请科室,CstNPlace会诊地址,CstTrePro病情摘要,CstPurpose会诊理由及要求,CstCDateTime会诊完成时间,ConsultLoc会诊科室,Attitude会诊意见
/// d ##class(%ResultSet).RunQuery("EMRservice.SystemData","GetConsultInfo","62")
Query GetConsultInfo(parEventIds As %String) As %Query(ROWSPEC = "PatName:%String,CstType:%String,CstRDateTime:%String,CstRUser:%String,CstRLoc:%String,CstNPlace:%String,CstTrePro:%String,CstPurpose:%String,CstCDateTime:%String,ConsultLoc:%String,Attitude:%String")
{
}

ClassMethod GetConsultInfoExecute(ByRef qHandle As %Binary, parEventIds As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	q:(parEventIds = "") $$$OK
	
	if (parEventIds["ProductSourceCode")
	{
		s consultID = $replace(parEventIds,"ProductSourceCode:","")
		q:(consultID = "") $$$OK
	}
	else
	{
		s eventID = $p(parEventIds,"@",1)
		s obj = ##Class(EMRinstance.Events.Consult).%OpenId(eventID)
		q:(obj = "") $$$OK
		s consultID = obj.ConsultID
		q:(consultID = "") $$$OK
	}
	
	s (PatName,CstType,CstRDateTime,CstRUser,CstRLoc,CstNPlace,CstTrePro,CstPurpose,CstCDateTime,TreMeasures,ConStr) = ""
	s ConsultLoc = ""
	s Attitude = ""
	s ds = ##Class(%Library.ResultSet).%New("web.DHCEMConsInterface:QryGetDataForEmr")
	d ds.Execute(consultID)
	While (ds.Next())
	{
		s PatName = ds.Data("PatName")
		s CstType = ds.Data("CstType")
		s CstRDateTime = ds.Data("CstRDateTime")
		s CstRUser = ds.Data("CstRUser")
		s CstRLoc = ds.Data("CstRLoc")
		s CstNPlace = ds.Data("CstNPlace")
		s CstTrePro = ds.Data("CstTrePro")
		s CstPurpose = ds.Data("CstPurpose")
		s CstCDateTime = ds.Data("CstCDateTime")
		s TreMeasures = ds.Data("TreMeasures")
		s ConStr = ds.Data("ConStr")
		s Attitude = TreMeasures
		s length = $l(ConStr,$c(2))
		for I=1:1:length
		{
			s curInfo = $p(ConStr,$c(2),I)
			s:(ConsultLoc '= "") ConsultLoc = ConsultLoc_"，"
			s ConsultLoc = ConsultLoc_$p(curInfo,"&",1)
			if (TreMeasures = "")
			{
				s:(Attitude '= "") Attitude = Attitude_"，"
				s Attitude = Attitude_$p(curInfo,"&",1)
				s Attitude = Attitude_$p(curInfo,"&",2)_"："
				s Attitude = Attitude_$p(curInfo,"&",5)
			}
		}
	}
	
	
	Set ^CacheTemp(repid, ind) = $LB(PatName,CstType,CstRDateTime,CstRUser,CstRLoc,CstNPlace,CstTrePro,CstPurpose,CstCDateTime,ConsultLoc,Attitude)
	Set ind = ind + 1
	Quit $$$OK
}

ClassMethod GetConsultInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetConsultInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
	Quit $$$OK
}

ClassMethod GetConsultInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetConsultInfoExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" 
	{				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      
	{				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// d ##class(%ResultSet).RunQuery("EMRservice.SystemData","GetInstanceInfoData","304||15")
Query GetInstanceInfoData(AInstanceID As %String) As %Query(ROWSPEC = "TitlePrefix,UserDict")
{
}

ClassMethod GetInstanceInfoDataExecute(ByRef qHandle As %Binary, AInstanceID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	Set qHandle=$lb(0,repid,0)
	
    q:(AInstanceID = "") $$$OK
    s obj = ##Class(EMRinstance.InstanceData).%OpenId(AInstanceID)
 	q:(obj = "") $$$OK
 	s UserDict="",UserCode="",UserName=""
 	s TitlePrefix = ""
 	s TitlePrefixInfo = ##Class(EMRservice.BL.BLRecordTitleSuperiorDoctor).GetTitleSuperiorDoctorInfo(AInstanceID)
 	
 	s UserID = $p(TitlePrefixInfo,"|",1)
 	s TitlePrefix = $p(TitlePrefixInfo,"|",2)
 	if (UserID'="")
 	{
	 s UserCode = $p($g(^SSU("SSUSR",UserID)),"^",1)
	 s UserName = $p($g(^SSU("SSUSR",UserID)),"^",2)
	 
	 }
 	s UserDict = UserID_"^"_UserCode_"^"_UserName
 	set ^CacheTemp(repid, ind) = $lb(TitlePrefix,UserDict)
	set ind = ind +1

	Quit $$$OK
}

ClassMethod GetInstanceInfoDataClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetInstanceInfoDataExecute ]
{
	Set repid=$LIST(qHandle,1)
 	Kill ^CacheTemp(repid) 	
	Quit $$$OK
}

ClassMethod GetInstanceInfoDataFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetInstanceInfoDataExecute ]
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

}
