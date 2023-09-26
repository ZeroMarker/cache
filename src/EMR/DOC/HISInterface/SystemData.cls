/// 名称:	EMR.DOC.HISInterface.SystemData
/// 描述:	电子病历数据集接口类
/// 编写者：	yejian
/// 编写日期: 	2020-12-28
Class EMR.DOC.HISInterface.SystemData Extends EMR.DOC.COM.ActionBase
{

/// ------------------------已标准化返回值格式的类Start------------------------
/// ////////////////////////////////////////////////////////////////////////////////////////////////
/// Creator：	EPR
/// CreateDate：2009-03-16
/// Desc：		取患者基本信息[HIS]-01 200908OK
/// Input:		Adm: 就诊rowid
/// Return：
/// debug:		d ##class(%ResultSet).RunQuery("EMR.OP.HISInterface.SystemData","GetPatientInfo","67")	
Query GetPatientInfo(Adm As %String) As %Query(ROWSPEC = "EpisodeID,PapmiDR,EpisodeNo,RegisterNo,IPRecordNo,OPRecordNo,EPRecordNo,InsuranceNo,IDCard,CardType,CardNumber,Name,Gender,GenderMono,GenderDict,GenderDesc,Birthday,Age,RecordAge,RecordAgeUnit,ClinicAge,BabyAge,MarriageDesc,MarriageDict,MarriageMono,Native,BlockBirthDict,CityBirthDict,ProvinceBirthDict,BlockBirthDesc,CityBirthDesc,ProvinceBirthDesc,OccupationDict,OccupationDesc,NationDict,NationDesc,CountryDict,CountryDesc,PayMode,PayTypeMono,MobilePhone,LinkName,LinkRelationDict,LinkRelationDesc,LinkAddress,LinkPhone,WorkAddress,WorkTel,WorkPostCode,HuKouAddress,HuKouTel,HuKouPostCode,curProvinceDict,curCityDict,curBlockDict,curStreet,CurAddress,HukouProvinceDict,HuKouCityDict,HuKouBlockDict,HuKouStreet,CurAddrPostCode,ProvinceNativeDict,CityNativeDict,InScore,OutScore")
{
}

ClassMethod GetPatientInfoExecute(ByRef qHandle As %Binary, Adm As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	Set qHandle=$lb(0,repid,0)


	Quit:($d(^PAADM(Adm))=0)||(Adm="") $$$OK
	// 取系统参数
	s Hospital=##class(EMR.DOC.BL.SysOption).GetOptionValueByName("HospitalName",..#ProductCode)
  	s SpaceHIS=##class(EMR.DOC.BL.SysOption).GetOptionValueByName("NameSpaceHIS",..#ProductCode)
	if SpaceHIS'=""
	{
		s MEDDATA = $p($g(SpaceHIS),"^",1)
		s WEBSRC  = $p($g(SpaceHIS),"^",2)
	}
	s SpaceLIS=##class(EMR.DOC.BL.SysOption).GetOptionValueByName("NameSpaceLIS",..#ProductCode)
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

 	///////////////////////
 	// 患者标识号码大类  //
 	///////////////////////

 	// 标识号			[EpisodeID]			PA_Adm.PAAdm_RowID
 	s EpisodeID=Adm
 	 
 	// 登记RowId		[PapmiDR]			PA_Person.PAPER_RowId And PA_PatMas.PAPMI_PAPER_DR
 	s PapmiDR = ##Class(EMR.DOC.HISInterface.PatientInfoAssist).GetPapmiDR(Adm)
 	
 	// 就诊号			[EpisodeNo]			PA_Adm.PAADM_ADMNo
 	s EpisodeNo=##Class(EMR.DOC.HISInterface.PatientInfoAssist).GetEpisodeNo(Adm)
 	
 	// 登记号			[RegisterNo]		PA_PatMas.PAPMI_No
 	s RegisterNo = ##Class(EMR.DOC.HISInterface.PatientInfoAssist).GetPapmiNo(PapmiDR)
 	
 	// 住院病案号		[IPRecordNo]		PA_PatMas.PAPMI_Medicare
 	s IPRecordNo = ##class(EMR.DOC.HISInterface.PatientInfoAssist).GetMRNoByEpisodeID(Adm)
 	//s IPRecordNo=""
 	
 	// 门诊病案号		[OPRecordNo]		PA_Person.PAPER_GovernCardNo
 	s OPRecordNo = ##class(EMR.DOC.HISInterface.PatientInfoAssist).GetMRNoByEpisodeID(Adm)
 	
 	// 急诊病案号		[EPRecordNo]		DHC_Person.PAPER_FCMedicareCode1
 	s EPRecordNo = ##class(EMR.DOC.HISInterface.PatientInfoAssist).GetMRNoByEpisodeID(Adm)
 	
 	//依据患者类型，返回病案号
 	s AdmType=$p(^PAADM(Adm),"^",2)
 	
 	s IPRecordNo=$case(AdmType,"I":IPRecordNo,"O":OPRecordNo,"E":EPRecordNo)
 	
 	// 医保号			[InsuranceNo]		PA_Person.PAPER_ID
 	s InsuranceNo=##Class(EMR.DOC.HISInterface.PatientInfoAssist).InsuranceNo(Adm,Hospital)
 	s:(InsuranceNo="") InsuranceNo="-"
 	
	// 身份证号			[IDCard]			PA_Person.PAPER_ID
 	s IDCard=##Class(EMR.DOC.HISInterface.PatientInfoAssist).IDCard(PapmiDR)

	// 证件类型			[CardType]			PA_PatMas.PAPMI_CardType_DR -> PAC_CardType.CARD_Desc
 	s CardType=##Class(EMR.DOC.HISInterface.PatientInfoAssist).CardType(PapmiDR)
 	i (CardType="") { s CardType ="身份证" }

	// 证件号码			[CardNumber]		PA_PatMas.PAPMI_DVAnumber
 	s CardNumber=##Class(EMR.DOC.HISInterface.PatientInfoAssist).CardNumber(PapmiDR)
 	i (CardType="身份证")||(CardType="") { s CardNumber =IDCard }

 
 	///////////////////////
 	// 患者基本情况大类  //
 	///////////////////////
 	
 	// 姓名				[Name]				PA_Person.PAPER_Name
 	s Name=##Class(EMR.DOC.HISInterface.PatientInfoAssist).Name(PapmiDR)
 	
 	// 性别				[Gender]			PA_Person.PAPER_Sex_DR
 	s Gender=##Class(EMR.DOC.HISInterface.PatientInfoAssist).Gender(PapmiDR,Hospital)
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
 	s Birthday=##Class(EMR.DOC.HISInterface.PatientInfoAssist).Birthday(PapmiDR)
 	if Birthday'=""
 	{
   		// 出生日期内部格式 PA_Person.PAPER_Dob 
   		s ArgBirthday=Birthday
   		// 出生日期外部格式 PA_Person.PAPER_Dob
   		s Birthday=$zd(Birthday,3)
 	}
 	
	// (用以计算年龄)入院日期时间	[AdmDateTime]		PAAdm_AdmDate And PAAdm_AdmTime 
	s AdmDate = "", AdmTime = ""
	s AdmDateTime=##class(EMR.DOC.HISInterface.PatientInfoAssist).AdmDateTime(Adm,Hospital)
	if AdmDateTime'="" 
	{ 
		   // 入院日期内部格式
		   s AdmDate = $P($G(AdmDateTime),",",1)
		   // 入院时间内部格式 
		   s AdmTime = $P($G(AdmDateTime),",",2)
	}
	  
   	//调用年龄统一接口 [Age]
   	s Age=##class(EMR.DOC.HISInterface.PatientInfoAssist).Age(PapmiDR,Adm,AdmDate,AdmTime)
    ;s Age="8岁"
   	//调用年龄统一接口			[RecordAge][RecordAgeUnit]
   	s tmpRecordAge =##class(EMR.DOC.HISInterface.PatientInfoAssist).Age(PapmiDR,Adm,AdmDate,AdmTime)
   	s RecordAge = $e(tmpRecordAge,1,$l(tmpRecordAge)-$l($zstrip(tmpRecordAge,"*N")))
    s RecordAgeUnit = $e(tmpRecordAge,$l(tmpRecordAge)-$l($zstrip(tmpRecordAge,"*N"))+1,$l(tmpRecordAge))
    
    //调用年龄统一接口	[ClinicAge]
   	s ClinicAge = ##class(EMR.DOC.HISInterface.PatientInfoAssist).Age(PapmiDR,Adm,AdmDate,AdmTime)
   	// 新生儿年龄 N天			[BabyAge]
 	s BabyAge =##class(EMR.DOC.HISInterface.PatientInfoAssist).Age(PapmiDR,Adm,AdmDate,AdmTime)
 	// 婚姻状况			[Marriage]			PA_Person.PAPER_Marital_DR ->
 	s Marriage=##Class(EMR.DOC.HISInterface.PatientInfoAssist).Marriage(PapmiDR)
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
 	s tmpNative=##Class(EMR.DOC.HISInterface.PatientInfoAssist).Native(PapmiDR,Hospital)
 	s tmpBirthPlace=##Class(EMR.DOC.HISInterface.PatientInfoAssist).BirthPlaceNew(PapmiDR)
 	//现住址
 	s tmpcuraddr=##Class(EMR.DOC.HISInterface.PatientInfoAssist).ResidentAddressNew(PapmiDR,Hospital)
 	s tmpcuraddr=$tr(tmpcuraddr,"\","")
 	//户口地址
 	s tmpHuKou=##Class(EMR.DOC.HISInterface.PatientInfoAssist).HuKouAddressNew(PapmiDR,Hospital)
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
   		//s CurAddress = $p($g(tmpcurProvince),"^",3)_$p($g(tmpcurCity),"^",3)_$p($g(tmpcurBlock),"^",3)_curStreet
 		s CurAddress = curStreet
 		
 		
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
 	s tmpOccupation=##Class(EMR.DOC.HISInterface.PatientInfoAssist).Occupation(PapmiDR,Hospital)
 	i tmpOccupation'=""
 	{
   		s OccupationDesc = $p($g(tmpOccupation),"^",3)
                s OccupationDict=tmpOccupation
 	}
	
	// 民族				[Nation]			PA_Person.PAPER_Nation_DR -> SQLUser.CT_Nation
	// 民族				[NationDesc]			
	s tmpNation=##Class(EMR.DOC.HISInterface.PatientInfoAssist).Nation(PapmiDR,Hospital)
	i tmpNation'=""
 	{	
   		s NationDict =tmpNation
   		s NationDesc = $p($g(tmpNation),"^",3)
 	}
		 
	// 国籍				[Country]			PA_Person.PAPER_Country_DR
	// 国籍				[CountryDesc]			
	s tmpCountry=##Class(EMR.DOC.HISInterface.PatientInfoAssist).Country(PapmiDR,Hospital)
	i tmpCountry'=""
 	{
   		s CountryDict = tmpCountry
   		s CountryDesc = $p($g(tmpCountry),"^",3)
   		
 	}
		
	// 病人类型			[PayType]			PAAdm_AdmReason_DR -> 
	s PayType1=##Class(EMR.DOC.HISInterface.PatientInfoAssist).PayType(Adm)
	s PayType=##Class(EMR.DOC.HISInterface.PatientInfoAssist).ConvertPayType(PayType1)
	
	
	// 医疗付款方式		[PayMode]			病案首页与病人类型对照
	s PayMode=##Class(EMR.DOC.HISInterface.PatientInfoAssist).PayModeLink(Adm,Hospital)
	
	
	s EmerPayMode=##Class(EMR.DOC.HISInterface.PatientInfoAssist).ConvertPayMode(PayType)


	// 手机				[MobilePhone]		PA_Person.PAPER_MobPhone
	s MobilePhone=##Class(EMR.DOC.HISInterface.PatientInfoAssist).MobilePhone(PapmiDR,Hospital)
	 
	 

 	///////////////////////////////////////////
 	// 患者联系人情况/工作情况/户口情况大类  //
 	///////////////////////////////////////////
 	
 	
 	// 联系人姓名		[LinkName]			PA_Person.PAPER_ForeignId
 	s LinkName = ##class(EMR.DOC.HISInterface.PatientInfoAssist).LinkmanName(PapmiDR,Hospital)
 
 	// 联系人关系		[LinkRelation]		PA_Person.PAPER_CTRLT_DR -> SQLUser.CT_Relation
 	s tmpLinkRelation = ##class(EMR.DOC.HISInterface.PatientInfoAssist).LinkmanRelation(PapmiDR,Hospital)
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
 	s LinkAddress = ##class(EMR.DOC.HISInterface.PatientInfoAssist).LinkmanAddress(PapmiDR,Hospital)
 	s LinkAddress=$tr(LinkAddress,"\","")
 	// 联系人电话		[LinkPhone]			PA_Person.PAPER_ForeignPhone
 	s LinkPhone = ##class(EMR.DOC.HISInterface.PatientInfoAssist).LinkmanPhone(PapmiDR,Hospital)

 	// 工作单位地址		[WorkAddress]		PA_Person.PAPER_SecondPhone
 	s WorkAddress=##Class(EMR.DOC.HISInterface.PatientInfoAssist).WorkAddress(PapmiDR,Hospital)
 
 	// 工作电话			[WorkTel]			PA_Person.PAPER_TelO
 	// 如果工作电话为空  赋值手机
 	s WorkTel=##Class(EMR.DOC.HISInterface.PatientInfoAssist).WorkPhone(PapmiDR,Hospital)
 	i WorkTel=""
 	{
	 	s WorkTel = MobilePhone
 	}
 
 	// 工作邮编			[WorkPostCode]		DHC_Person.PAPER_Comment2
 	s WorkPostCode=##Class(EMR.DOC.HISInterface.PatientInfoAssist).WorkPostCode(PapmiDR,Hospital)

 	// 户口所在地址		[HuKouAddress]		PA_Person.PAPER_StName
 	s HuKouAddress=##Class(EMR.DOC.HISInterface.PatientInfoAssist).HuKouAddress(PapmiDR,Hospital)
	s HuKouAddress=$tr(HuKouAddress,"\","")
	
	// 户口电话			[HuKouTel]			PA_Person.PAPER_TelH
	s HuKouTel=##Class(EMR.DOC.HISInterface.PatientInfoAssist).HuKouPhone(PapmiDR,Hospital)
	
	// 户口邮编			[HuKouPostCode]		DHC_Person.PAPER_Comment1
	s HuKouPostCode=##Class(EMR.DOC.HISInterface.PatientInfoAssist).HuKouPostCode(PapmiDR,Hospital)
	//现住址邮编
	s CurAddrPostCode=##Class(EMR.DOC.HISInterface.PatientInfoAssist).ResidentPostCodeNew(PapmiDR,Hospital)
	
	//Add by Liaowp 2012-1-15
	//患者入出院生活能力评分
	s ScoreStr="",InScore="",OutScore=""
	s ScoreStr=##class(EMR.DOC.HISInterface.PatientInfoAssist).PatSelfCareDegree(Adm)
	s InScore=$P(ScoreStr,"^",1)
	s OutScore=$P(ScoreStr,"^",2)
	
	/*
	s GenderDict=##class(EMR.DOC.HISInterface.PatientInfoAssist).GetWSCodeDict(GenderDict,"GB/T 2261.1")
    s MarriageDict=##class(EMR.DOC.HISInterface.PatientInfoAssist).GetWSCodeDict(MarriageDict,"GB/T 2261.2")
    s OccupationDict=##class(EMR.DOC.HISInterface.PatientInfoAssist).GetWSCodeDict(OccupationDict,"GB/T 2261.4")
    s NationDict=##class(EMR.DOC.HISInterface.PatientInfoAssist).GetWSCodeDict(NationDict,"GB/T 3304")
    s CountryDict=##class(EMR.DOC.HISInterface.PatientInfoAssist).GetWSCodeDict(CountryDict,"GB/T 2659")
	s LinkRelationDict=##class(EMR.DOC.HISInterface.PatientInfoAssist).GetWSCodeDict(CountryDict,"GB/T 4761")
	*/	
	set ^CacheTemp(repid, ind) = $LB(EpisodeID,PapmiDR,EpisodeNo,RegisterNo,IPRecordNo,OPRecordNo,EPRecordNo,InsuranceNo,IDCard,CardType,CardNumber,Name,Gender,GenderMono,GenderDict,GenderDesc,Birthday,Age,RecordAge,RecordAgeUnit,ClinicAge,BabyAge,MarriageDesc,MarriageDict,MarriageMono,Native,BlockBirthDict,CityBirthDict,ProvinceBirthDict,BlockBirthDesc,CityBirthDesc,ProvinceBirthDesc,OccupationDict,OccupationDesc,NationDict,NationDesc,CountryDict,CountryDesc,PayMode,PayType,MobilePhone,LinkName,LinkRelationDict,LinkRelationDesc,LinkAddress,LinkPhone,WorkAddress,WorkTel,WorkPostCode,HuKouAddress,HuKouTel,HuKouPostCode,curProvinceDict,curCityDict,curBlockDict,curStreet,CurAddress,HukouProvinceDict,HuKouCityDict,HuKouBlockDict,HuKouStreet,CurAddrPostCode,ProvinceNativeDict,CityNativeDict,InScore,OutScore)
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
/// Test:		##Class(EMR.OP.HISInterface.SystemData).testcliord(3691348)
/// d ##class(%ResultSet).RunQuery("EMR.OP.HISInterface.SystemData","GetClinicOrdersInfo","67")		
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
	s Hospital=##class(EMR.DOC.BL.SysOption).GetOptionValueByName("HospitalName",..#ProductCode)
  	s SpaceHIS=##class(EMR.DOC.BL.SysOption).GetOptionValueByName("NameSpaceHIS",..#ProductCode)
	if SpaceHIS'=""
	{
		s MEDDATA = $p($g(SpaceHIS),"^",1)
		s WEBSRC  = $p($g(SpaceHIS),"^",2)
	}
	s SpaceLIS=##class(EMR.DOC.BL.SysOption).GetOptionValueByName("NameSpaceLIS",..#ProductCode)
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
 	s PapmiDR = ##Class(EMR.DOC.HISInterface.PatientInfoAssist).GetPapmiDR(Adm)
 	s EpisodeNo=##Class(EMR.DOC.HISInterface.PatientInfoAssist).GetEpisodeNo(Adm)
 	s RegisterNo = ##Class(EMR.DOC.HISInterface.PatientInfoAssist).GetPapmiNo(PapmiDR)
	s Name=##Class(EMR.DOC.HISInterface.PatientInfoAssist).Name(PapmiDR)
	
	// 入院医生 		[AdmDoctor]			PA_Adm.PAAdm_AdmDocCodeDR ->
	s tmpAdmDoctor=##Class(EMR.DOC.HISInterface.PatientInfoAssist).AdmDoctor(Adm,Hospital)
	i tmpAdmDoctor'=""
 	{
                 s AdmDoctorDict =tmpAdmDoctor

 	}
 	
 	//主管护士
 	s tmpAdmNurse= ##Class(EMR.DOC.HISInterface.PatientInfoAssist).AdmNurse(Adm,Hospital)
	i tmpAdmNurse'=""
 	{
   		
		 s AdmNurseDict=tmpAdmNurse
 	}
 	s tmpAdmMaster="",AdmMaster=""
 	s tmpAdmMaster= ##Class(EMR.DOC.HISInterface.PatientInfoAssist).MasterDoctor(Adm,Hospital)
 	i tmpAdmMaster'=""
 	{
   		
		s AdmMasterDict=tmpAdmMaster
 	}
 	
	// Care1^Care2^Care3^Care4^Care5^Care6
	// 一级护理^二级护理^三级护理^特级护理^ICU护理常规^CCU护理常规^
	s caredesc0="特级护理",caredesc1="一级护理",caredesc2="二级护理",caredesc3="三级护理",icudesc="重症监护",ccudesc="CCU护理"
	s Caredays = ##class(EMR.DOC.HISInterface.PatientInfoAssist).CareDays(Adm,caredesc0,caredesc1,caredesc2,caredesc3,icudesc,ccudesc,Hospital)
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
	s CareClass=##class(EMR.DOC.HISInterface.PatientInfoAssist).CareClass(Adm,ItmMastDRStr)

	// 当前膳食 ARCIM_ItemCat_DR 为多个时，拼串处理
	s ItemCatDRStr="^111^"
	s FoodTreatment=##class(EMR.DOC.HISInterface.PatientInfoAssist).HadFoodTreatment(Adm,ItemCatDRStr)

	// 过敏记录[临床组接口]
	s MedAllergy=##class(EMR.DOC.HISInterface.PatientInfoAssist).EPRGetAllergy(PapmiDR)
	if (MedAllergy'="")
	{
		s MedAllergy=MedAllergy
		//_" "_##class(EMR.DOC.HISInterface.PatientInfoAssist).MedAllergy(Adm)
	}
	// (用以医嘱取值)入院日期时间		[AdmDateTime]		PAAdm_AdmDate And PAAdm_AdmTime 
		 	s AdmDate = "", AdmTime = ""
		 	s AdmDateTime=##class(EMR.DOC.HISInterface.PatientInfoAssist).AdmDateTime(Adm,Hospital)
		 	if AdmDateTime'="" 
		 	{ 
		   		// 入院日期内部格式
		   		s AdmDate = $P($G(AdmDateTime),",",1)
		   		s AdmDate = $zd(AdmDate,3)
		   		// 入院时间内部格式 
		   		s AdmTime = $P($G(AdmDateTime),",",2)
		 	}  
	
	if (+($f(EpisodeNo,..#ProductCode))'=0)
	{

		// 门诊医嘱 化验
		s OrdersLab=##Class(EMR.DOC.HISInterface.PatientInfoAssist).GetOrders(Adm,AdmDate,$ZD($H,3),"化验","0")
	 		 	
		// 门诊医嘱 检查(放射)
		s OrdersCheck1=##Class(EMR.DOC.HISInterface.PatientInfoAssist).GetOrders(Adm,AdmDate,$ZD($H,3),"放射检查","0")
	 
		// 门诊医嘱 检查(物理)
		s OrdersCheck2=##Class(EMR.DOC.HISInterface.PatientInfoAssist).GetOrders(Adm,AdmDate,$ZD($H,3),"物理检查","0")
	 	
		// 门诊医嘱 检查(病理)
		s OrdersCheck3=##Class(EMR.DOC.HISInterface.PatientInfoAssist).GetOrders(Adm,AdmDate,$ZD($H,3),"病理检查费","0")
		
		// 门诊医嘱 检查(内窥镜)
		s OrdersCheck4=##Class(EMR.DOC.HISInterface.PatientInfoAssist).GetOrders(Adm,AdmDate,$ZD($H,3),"内窥镜检查","0")
	 	
		s OrdersLabAndCheck=OrdersLab_OrdersCheck1_OrdersCheck2_OrdersCheck3_OrdersCheck4
		i OrdersLabAndCheck'="" { s OrdersLabAndCheck= $e( OrdersLabAndCheck,1,$l(OrdersLabAndCheck)-2) }
		
		// 门诊医嘱 草药处方
		s OrdersCaoYao=##class(EMR.DOC.HISInterface.PatientInfoAssist).GetOrdersCaoYao(Adm)
	
		// 门诊医嘱 西药处方
	 	s OrdersXiYao=##class(EMR.DOC.HISInterface.PatientInfoAssist).GetOrdersXiYao(Adm)
	}
	if (+($f(EpisodeNo,"EP"))'=0)
	{
		
		// 急诊医嘱 化验
	 	s OrdersLab=##Class(EMR.DOC.HISInterface.PatientInfoAssist).GetOrderDetailByOrdCat(Adm,AdmDate,$ZD($H,3),"化验",1)
	 	s:(OrdersLab'="") OrdersLab = OrdersLab_"、" 
	 		
		// 急诊医嘱 检查(放射)
	 	s OrdersCheck1=##Class(EMR.DOC.HISInterface.PatientInfoAssist).GetOrderDetailByOrdCat(Adm,AdmDate,$ZD($H,3),"放射检查",1)
	 	s:(OrdersCheck1'="") OrdersCheck1 = OrdersCheck1_"、" 
	 	
		// 急诊医嘱 检查(物理)
	 	s OrdersCheck2=##Class(EMR.DOC.HISInterface.PatientInfoAssist).GetOrderDetailByOrdCat(Adm,AdmDate,$ZD($H,3),"物理检查",1)
	 	s:(OrdersCheck2'="") OrdersCheck2 = OrdersCheck2_"、" 
	 		 	
		s OrdersLabAndCheck=OrdersLab_OrdersCheck1_OrdersCheck2
		s:(OrdersLabAndCheck'="") OrdersLabAndCheck= $e( OrdersLabAndCheck,1,$l(OrdersLabAndCheck)-1)
			
		// 急诊医嘱 西药
	 	s OrdersXiYao1 = ##Class(EMR.DOC.HISInterface.PatientInfoAssist).GetOrderDetailByOrdCat(Adm,AdmDate,$ZD($H,3),"西药")
	 		 	
	 	s OrdersXiYao2 = ##Class(EMR.DOC.HISInterface.PatientInfoAssist).GetOrderDetailByOrdCat(Adm,AdmDate,$ZD($H,3),"中成药")
	 	
	 	s Tag = ""
	 	
	 	s:(OrdersXiYao1'="")&&(OrdersXiYao2'="") Tag = $c(13,10)
	 	
	 	s OrdersXiYao=OrdersXiYao1_Tag_OrdersXiYao2
	 	
	 	// 急诊医嘱 草药
		//s OrdersCaoYao=##class(EMR.DOC.HISInterface.PatientInfoAssist).GetOrdersCaoYao(Adm)

	}
	//取出院医嘱　2011-11-30
	s OutDrug=""
	s OutDrug=##class(EMR.DOC.HISInterface.PatientInfoAssist).GetOrdersByPriority(Adm,"出院带药")

	s CriticallyMono=##Class(EMR.DOC.HISInterface.PatientInfoAssist).GetCriticallyMono(Adm)
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
/// Test:		##Class(EMR.OP.HISInterface.SystemData).testclidiag(Adm)	
/// d ##class(%ResultSet).RunQuery("EMR.OP.HISInterface.SystemData","GetClinicDiagInfo","67")	
Query GetClinicDiagInfo(Adm As %String) As %Query(ROWSPEC = "EpisodeID,PapmiDR,EpisodeNo,RegisterNo,Name,AdmDiagString,AdmDiagStringH,TCMAdmDiagString,TCMAdmDiagStringH,OutDiagString,OutDiagStringH,TCMOutDiagString,TCMOutDiagStringH,OutDiag01Dict,OutDiag02Dict,OutDiag03Dict,OutDiag04Dict,OutDiag05Dict,OutDiag06Dict,OutDiag07Dict,OutDiag08Dict,OutDiag09Dict,OutDiag10Dict,OutDiag11Dict,OutDiag12Dict,OutDiag13Dict,OutDiag14Dict,OutDiag15Dict,OutDiag16Dict,OutDiag17Dict,OutDiag18Dict,OutDiag19Dict,OutDiag20Dict,OutDiag21Dict,OutDiag22Dict,OutDiag23Dict,TCMOutDiag01Dict,TCMOutDiag02Dict,TCMOutDiag03Dict,TCMOutDiag04Dict,TCMOutDiag05Dict,TCMOutDiag06Dict,TCMOutDiag07Dict,TCMOutDiag08Dict,TCMOutDiag09Dict,TCMOutDiag10Dict,TCMOutDiag11Dict,TCMOutDiag12Dict,TCMOutDiag13Dict,TCMOutDiag14Dict,TCMOutDiag15Dict,TCMOutDiag16Dict,TCMOutDiag17Dict,TCMOutDiag18Dict,TCMOutDiag19Dict,TCMOutDiag20Dict,IPBookDiagDict,AdmDiagstringEnt")
{
}

ClassMethod GetClinicDiagInfoExecute(ByRef qHandle As %Binary, Adm As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:($d(^PAADM(Adm))=0)||(Adm="") $$$OK
	
	//取系统参数
	s Hospital=##class(EMR.DOC.BL.SysOption).GetOptionValueByName("HospitalName",..#ProductCode)
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
 	s PapmiDR = ##Class(EMR.DOC.HISInterface.PatientInfoAssist).GetPapmiDR(Adm)
 	s EpisodeNo = ##Class(EMR.DOC.HISInterface.PatientInfoAssist).GetEpisodeNo(Adm)
 	s RegisterNo = ##Class(EMR.DOC.HISInterface.PatientInfoAssist).GetPapmiNo(PapmiDR)
	s Name = ##Class(EMR.DOC.HISInterface.PatientInfoAssist).Name(PapmiDR)
	
	s MRADMID = $P(^PAADM(Adm),"^",61)
 	/////////////////////// 
 	// 患者临床诊断大类  // 
 	/////////////////////// 
	
	// 西医入院诊断
	s AdmDiagString = "",AdmDiagStringH = ""
	s tmpAdmDiagDict = ##class(EMR.DOC.HISInterface.PatientInfoAssist).GetMRDiagnoseListForEMR(MRADMID,2,"C008")
	s tmpPREDiagDict = ##class(EMR.DOC.HISInterface.PatientInfoAssist).GetMRDiagnoseListForEMR(MRADMID,2,"PRE")
	
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
	s tmpTCMAdmDiagDict = ##class(EMR.DOC.HISInterface.PatientInfoAssist).GetMRDiagnoseListForEMR(MRADMID,1,"C008")
	s tmpTCMPREDiagDict = ##class(EMR.DOC.HISInterface.PatientInfoAssist).GetMRDiagnoseListForEMR(MRADMID,1,"PRE")
	
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
	s tmpOutDiag = ##class(EMR.DOC.HISInterface.PatientInfoAssist).GetMRDiagnoseListForEMR(MRADMID,2,"DIS")
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
	s tmpTCMOutDiag = ##class(EMR.DOC.HISInterface.PatientInfoAssist).GetMRDiagnoseListForEMR(MRADMID,1,"DIS")
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
	set IPBookDiagDict=##Class(EMR.DOC.HISInterface.PatientInfoAssist).GetIPBookDiagDict(Adm)

	s AdmDiagstringEnt =##class(EMRservice.BL.BLDiagRefFormatData).GetDiagRefFormatData(Adm,"diagnosesLayerV8","PRE")
	
	set ^CacheTemp(repid, ind) = $LB(EpisodeID,PapmiDR,EpisodeNo,RegisterNo,Name,AdmDiagString,AdmDiagStringH,TCMAdmDiagString,TCMAdmDiagStringH,OutDiagString,OutDiagStringH,TCMOutDiagString,TCMOutDiagStringH,OutDiag01Dict,OutDiag02Dict,OutDiag03Dict,OutDiag04Dict,OutDiag05Dict,OutDiag06Dict,OutDiag07Dict,OutDiag08Dict,OutDiag09Dict,OutDiag10Dict,OutDiag11Dict,OutDiag12Dict,OutDiag13Dict,OutDiag14Dict,OutDiag15Dict,OutDiag16Dict,OutDiag17Dict,OutDiag18Dict,OutDiag19Dict,OutDiag20Dict,OutDiag21Dict,OutDiag22Dict,OutDiag23Dict,TCMOutDiag01Dict,TCMOutDiag02Dict,TCMOutDiag03Dict,TCMOutDiag04Dict,TCMOutDiag05Dict,TCMOutDiag06Dict,TCMOutDiag07Dict,TCMOutDiag08Dict,TCMOutDiag09Dict,TCMOutDiag10Dict,TCMOutDiag11Dict,TCMOutDiag12Dict,TCMOutDiag13Dict,TCMOutDiag14Dict,TCMOutDiag15Dict,TCMOutDiag16Dict,TCMOutDiag17Dict,TCMOutDiag18Dict,TCMOutDiag19Dict,TCMOutDiag20Dict,IPBookDiagDict,AdmDiagstringEnt)
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
/// Test:		##Class(EMR.OP.HISInterface.SystemData).testlab(Adm)
/// d ##class(%ResultSet).RunQuery("EMR.OP.HISInterface.SystemData","GetLabInfo","67")		
Query GetLabInfo(Adm As %String) As %Query(ROWSPEC = "EpisodeID,PapmiDR,EpisodeNo,RegisterNo,Name,BloodType,BloodTypeMono,Rh,RhMono,HBsAg,HCV,HIV,TP,ALT,HBeAg,HBS,AntiHBe,HBC,RBC,HCT,PLT,HGB,PT,APTT,FIB")
{
}

ClassMethod GetLabInfoExecute(ByRef qHandle As %Binary, Adm As %String) As %Status
{

	Set repid=$I(^CacheTemp)
	s ind=1
	Set qHandle=$lb(0,repid,0)

	Quit:($d(^PAADM(Adm))=0)||(Adm="") $$$OK
	
    	//取系统参数
	s Hospital=##class(EMR.DOC.BL.SysOption).GetOptionValueByName("HospitalName",..#ProductCode)
  	s SpaceHIS=##class(EMR.DOC.BL.SysOption).GetOptionValueByName("NameSpaceHIS",..#ProductCode)
	if SpaceHIS'=""
	{
		s MEDDATA = $p($g(SpaceHIS),"^",1)
		s WEBSRC  = $p($g(SpaceHIS),"^",2)
	}
	s SpaceLIS=##class(EMR.DOC.BL.SysOption).GetOptionValueByName("NameSpaceLIS",..#ProductCode)
	if SpaceLIS'=""
	{
	    s LABDATA = $p($g(SpaceLIS),"^",1)
	    s LABSRC  = $p($g(SpaceLIS),"^",2)
	 }
	 Quit:((Hospital="")||(SpaceHIS="")||(SpaceLIS="")) $$$OK
	
 	// 标识号|登记RowId|就诊号|登记号|姓名
 	s EpisodeID=Adm
 	s PapmiDR = ##Class(EMR.DOC.HISInterface.PatientInfoAssist).GetPapmiDR(Adm)
 	s EpisodeNo=##Class(EMR.DOC.HISInterface.PatientInfoAssist).GetEpisodeNo(Adm)
 	s RegisterNo = ##Class(EMR.DOC.HISInterface.PatientInfoAssist).GetPapmiNo(PapmiDR)
	s Name=##Class(EMR.DOC.HISInterface.PatientInfoAssist).Name(PapmiDR)

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
	s LabBldInfo=##Class(EMR.DOC.HISInterface.PatientInfoAssist).GetLabBldInfoNew(Adm)
	
	//ABO血型
	s BloodType=$p(LabBldInfo,"^",1)
	if (BloodType="") { s BloodType="未查" } 
	elseif ($L(BloodType,"ABO血型")>1) 
	{ 
		s BloodType=$P(BloodType,"ABO血型",2) 
		s BloodType=$P(BloodType,"型",1)
	}

	s BloodTypeMono=$$BloodTypeToMono(BloodType)

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
	

	set ^CacheTemp(repid, ind) = $LB(EpisodeID,PapmiDR,EpisodeNo,RegisterNo,Name,BloodType,BloodTypeMono,Rh,RhMono,HbsAg,HCVAb,HIVAb,MD,ALT,HBeAg,HbsAb,HBeAb,HBcAb,RBC,HCT,PLT,HGB,PT,APTT,FIB)
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
/// Test:		d ##Class(%ResultSet).RunQuery("EMR.OP.HISInterface.SystemData","GetCheckInfo","67")		
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
    s Tempnew=##class(EMR.DOC.HISInterface.PatientInfoAssist).GetPatObservationsNew(EpisodeID)
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
/// d ##class(%ResultSet).RunQuery("EMR.OP.HISInterface.SystemData","GetATDInfo","165","2020-04-07 16:25:01")	
Query GetATDInfo(Adm As %String, AHappenDateTime As %String = "") As %Query(ROWSPEC = "EpisodeID,PapmiDR,EpisodeNo,RegisterNo,Name,AdmDate,AdmTime,AdmDateTime,AdmDateInBed,AdmTimeInBed,AdmDateTimeInBed,AdmDeptDict,AdmDeptDesc,AdmWardDict,AdmWardDesc,AdmRoom,AdmBed,DisDate,DisTime,DisDateTime,DisDeptDict,DisDeptDesc,DisWardDict,DisWardDesc,DisRoom,DisBed,TransDept,TransDeptDetail,TransDateTime1st,TransDept1stDict,TransDept1stDesc,TransWard1stDict,TransWard1stDesc,TransDeptAgain,DeathDateTime,ResidentDays,InTimes,CurDeptDict,CurDeptDesc,CurWardDict,CurWardDesc,CurRoom,CurBed,CurDate,CurTime,CurDateTime,InScore,OutScore,LastTransDept,AdmCTLoc,DisModeMono")
{
}

ClassMethod GetATDInfoExecute(ByRef qHandle As %Binary, Adm As %String, AHappenDateTime As %String = "") As %Status
{

	
	Set repid=$I(^CacheTemp)
	s ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:($d(^PAADM(Adm))=0)||(Adm="") $$$OK
	
    	//取系统参数
	s Hospital=##class(EMR.DOC.BL.SysOption).GetOptionValueByName("HospitalName",..#ProductCode)
  	s SpaceHIS=##class(EMR.DOC.BL.SysOption).GetOptionValueByName("NameSpaceHIS",..#ProductCode)
	if SpaceHIS'=""
	{
		s MEDDATA = $p($g(SpaceHIS),"^",1)
		s WEBSRC  = $p($g(SpaceHIS),"^",2)
	}
	s SpaceLIS=##class(EMR.DOC.BL.SysOption).GetOptionValueByName("NameSpaceLIS",..#ProductCode)
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
 	s PapmiDR = ##Class(EMR.DOC.HISInterface.PatientInfoAssist).GetPapmiDR(Adm)
 	s EpisodeNo=##Class(EMR.DOC.HISInterface.PatientInfoAssist).GetEpisodeNo(Adm)
 	s RegisterNo = ##Class(EMR.DOC.HISInterface.PatientInfoAssist).GetPapmiNo(PapmiDR)
	s Name=##Class(EMR.DOC.HISInterface.PatientInfoAssist).Name(PapmiDR)


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
	
	s AdmDateTime=##class(EMR.DOC.HISInterface.PatientInfoAssist).AdmDateTime(Adm,Hospital)
	i AdmDateTime'="" 
	{ 

		s AdmDate = $ZD($P($G(AdmDateTime),",",1),3)
		s AdmTime = $ZT($P($G(AdmDateTime),",",2),2)
		s AdmDateTime=AdmDate_" "_AdmTime

	}   
	
	// 入院分床日期 	[AdmDateInBed]			
	// 入院分床时间		[AdmTimeInBed]			
	// 入院分床日期时间	[AdmDateTimeInBed]		
	// 统一入院时间，通过统一接口获取 （AdmDateTimeInBed 与AdmDateTime 保持一致，由业务配置数据控制数据源）
	//s AdmDateTimeInBed=##class(EMR.DOC.HISInterface.PatientInfoAssist).AdmDateTimeInBed(Adm,Hospital)
	s AdmDateTimeInBed=##class(EMR.DOC.HISInterface.PatientInfoAssist).AdmDateTime(Adm,Hospital)
	i AdmDateTimeInBed'="" 
	{
		s AdmDateInBed = $ZD($P($G(AdmDateTimeInBed),",",1),3)
		s AdmTimeInBed = $ZT($P($G(AdmDateTimeInBed),",",2),2)
		s AdmDateTimeInBed=AdmDateInBed_" "_AdmTimeInBed

	}  


	// 入院科室		[AdmDeptDict]
	// 入院科室描述		[AdmDeptDesc]
	s tmpAdmDept=##Class(EMR.DOC.HISInterface.PatientInfoAssist).AdmDept(Adm,Hospital)
	i tmpAdmDept'=""
 	{
  
   		s AdmDeptDict = tmpAdmDept
   		s AdmDeptDesc = $p($g(tmpAdmDept),"^",3)
	
 	} 

	// 入院病区			[AdmWardDict]
	// 入院病区描述		[AdmWardDesc]
	s tmpAdmWard=##Class(EMR.DOC.HISInterface.PatientInfoAssist).AdmWard(Adm,Hospital)
	i tmpAdmWard'=""
 	{
   		s AdmWardDict = tmpAdmWard
   		s AdmWardDesc = $p($g(tmpAdmWard),"^",3)

 	}

 	// 入院病室			[AdmRoom]
	s tmpAdmRoom=##Class(EMR.DOC.HISInterface.PatientInfoAssist).AdmRoom(Adm,Hospital)
	i tmpAdmRoom'=""
 	{
   		s AdmRoom = $p($g(tmpAdmRoom),"^",3)
 	}

	// 入院床号			[AdmBed]
	s AdmBed= ##Class(EMR.DOC.HISInterface.PatientInfoAssist).AdmBed(Adm) 
 
 
  	///////////////////////
 	// 患者出院信息大类  //
 	///////////////////////
 
 
 	//DisDate,DisTime,DisDateTime,DisDept,DisDeptDesc,DisWard,DisWardDesc,DisBed,
	// 出院日期 		[DisDate]			PAAdm_DischgDate
	// 出院时间			[DisTime]			PAAdm_DischgTime
	// 出院日期时间		[DisDateTime]		PAAdm_DischgDate And PAAdm_DischgTime
	// 出院日期通过统一接口获取，调用函数不变，代码兼容。
	s DisDateTime=##class(EMR.DOC.HISInterface.PatientInfoAssist).DisDateTime(Adm,Hospital)
	
	s DeathDateTime=##class(EMR.DOC.HISInterface.PatientInfoAssist).DeathDateTime(Adm,PapmiDR,Hospital)
	s DisDateTimeMR=##Class(EMR.DOC.HISInterface.PatientInfoAssist).DisDateTimeMR(Adm,Hospital)
 	s DisDateTimeDoctor=##Class(EMR.DOC.HISInterface.PatientInfoAssist).DisDateTimeDoctor(Adm,Hospital)
 	
 	//^DHCWLInitStat("Discharge")="E"预计出院日期
	//^DHCWLInitStat("Discharge")="D"最终结算日期
	//^DHCWLInitStat("Discharge")="C"财务结算日期
	//^DHCWLInitStat("Discharge")="H"手工填写
 	if ($d(^DHCWLInitStat("Discharge"))'=0)
 	{
	 	if ($g(^DHCWLInitStat("Discharge"))="E")
	 	{
			s DisDate = $ZD($P($G(DisDateTimeDoctor),",",1),3)
			s DisTime = $ZT($P($G(DisDateTimeDoctor),",",2),2)
			s DisDateTime=DisDate_" "_DisTime
	 	}
	 	elseif ($g(^DHCWLInitStat("Discharge"))="D")
	 	{
			s DisDate = $ZD($P($G(DisDateTime),",",1),3)
			s DisTime = $ZT($P($G(DisDateTime),",",2),2)
			s DisDateTime=DisDate_" "_DisTime
	 	}
	 	elseif ($p($g(DisDateTimeMR),",",1)'="")&&($p($g(DisDateTimeMR),",",2)'="")
	 	{
			s DisDate = $ZD($P($G(DisDateTime),",",1),3)
			s DisTime = $ZT($P($G(DisDateTime),",",2),2)
			s DisDateTime=DisDate_" "_DisTime
	 	}
 	}
 	else
 	{
		if DisDateTime'="" 
		{ 
			s DisDate = $ZD($P($G(DisDateTime),",",1),3)
			s DisTime = $ZT($P($G(DisDateTime),",",2),2)
			s DisDateTime=DisDate_" "_DisTime

		} 
	 	
	 	// 统计组[袁旭] 日期时间
		if ($p($g(DisDateTimeMR),",",1)'="")&&($p($g(DisDateTimeMR),",",2)'="")
		{ 
			
			s DisDate = $ZD($P($G(DisDateTimeMR),",",1),3)
			s DisTime = $ZT($P($G(DisDateTimeMR),",",2),2)
			s DisDateTime=DisDate_" "_DisTime
			
		} 
	 	
	 	// 死亡日期时间
		if DeathDateTime'="" 
		{ 
			s DeathDate = $ZD($P($G(DeathDateTime),",",1),3)
			s DeathTime = $ZT($P($G(DeathDateTime),",",2),2)
	   		s DeathDateTime=DeathDate_" "_DeathTime
			s DisDateTime=DeathDateTime

		}
 	}

	// 出院科室			[DisDeptDict]
	// 出院科室描述		[DisDeptDesc]
	s tmpDisDept=##Class(EMR.DOC.HISInterface.PatientInfoAssist).DisDept(Adm,Hospital,AHappenDateTime) 
	
	i tmpDisDept'=""
 	{
   		s DisDeptDict = tmpDisDept
   		s DisDeptDesc = $p($g(tmpDisDept),"^",3)
 	}
 	
	// 出院病区			[DisWardDict]
	// 出院病区描述		[DisWardDesc]
	s DisWardDict=""
	s DisWardDesc=""
	s tmpDisWard=##Class(EMR.DOC.HISInterface.PatientInfoAssist).DisWard(Adm,Hospital)
	i tmpDisWard'=""
 	{
   		s DisWardDict = tmpDisWard
   		s DisWardDesc = $p($g(tmpDisWard),"^",3)
 	}

 	// 出院病室			[DisRoom]
	s tmpDisRoom=##Class(EMR.DOC.HISInterface.PatientInfoAssist).DisRoom(Adm,Hospital)
	i tmpDisRoom'=""
 	{
   		s DisRoom = $p($g(tmpDisRoom),"^",3)

 	}
 	
	// 出院床号			[DisBed]
	s DisBed=##Class(EMR.DOC.HISInterface.PatientInfoAssist).DisBed(Adm)

 
   	///////////////////////
 	// 患者转科信息大类  //
 	///////////////////////

	
	// 转科情况			[TransDept]
	//末次转科 格式:转出科室->转入科室
	s LastTransDept=""
	s TransDept=##Class(EMR.DOC.HISInterface.PatientInfoAssist).TransDept(Adm) 
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
	s TransDeptDetail=##Class(EMR.DOC.HISInterface.PatientInfoAssist).TransDeptDetail(Adm,Hospital) 

	//就诊科室
	s AdmCTLoc=##Class(EMR.DOC.HISInterface.PatientInfoAssist).GetEpisodeCTLoc(Adm)

	// 住院天数			[ResidentDays]
	s ResidentDays=##Class(EMR.DOC.HISInterface.PatientInfoAssist).ResidentDaysAdm(Adm,Hospital)

	// 入院次数			[InTimes]
	s InTimes=##Class(EMR.DOC.HISInterface.PatientInfoAssist).InTimes(Adm,Hospital)
	s tmpInTimes=##Class(EMR.DOC.HISInterface.PatientInfoAssist).InTimesWMR(Adm,Hospital)
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
	s ScoreStr=##class(EMR.DOC.HISInterface.PatientInfoAssist).PatSelfCareDegree(Adm)
	s InScore=$s($P(ScoreStr,"^",1)'="":$P(ScoreStr,"^",1),1:"─")
	s OutScore=$s($P(ScoreStr,"^",2)'="":$P(ScoreStr,"^",2),1:"─")
    s DisModeMono=##Class(EMR.DOC.HISInterface.PatientInfoAssist).GetDisModeMono(Adm)
	set ^CacheTemp(repid, ind) = $LB(EpisodeID,PapmiDR,EpisodeNo,RegisterNo,Name,AdmDate,AdmTime,AdmDateTime,AdmDateInBed,AdmTimeInBed,AdmDateTimeInBed,AdmDeptDict,AdmDeptDesc,AdmWardDict,AdmWardDesc,AdmRoom,AdmBed,DisDate,DisTime,DisDateTime,DisDeptDict,DisDeptDesc,DisWardDict,DisWardDesc,DisRoom,DisBed,TransDept,TransDeptDetail,TransDateTime1st,TransDept1stDict,TransDept1stDesc,TransWard1stDict,TransWard1stDesc,TransDeptAgain,DeathDateTime,ResidentDays,InTimes,CurDeptDict,CurDeptDesc,CurWardDict,CurWardDesc,CurRoom,CurBed,CurDate,CurTime,CurDatetime,InScore,OutScore,LastTransDept,AdmCTLoc,DisModeMono)
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
/// Test:		##Class(EMR.OP.HISInterface.SystemData).testmc(Adm)	
/// d ##class(%ResultSet).RunQuery("EMR.OP.HISInterface.SystemData","GetMCFeeInfo","67")	
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
	s Hospital=##class(EMR.DOC.BL.SysOption).GetOptionValueByName("HospitalName",..#ProductCode)
  	s SpaceHIS=##class(EMR.DOC.BL.SysOption).GetOptionValueByName("NameSpaceHIS",..#ProductCode)
	if SpaceHIS'=""
	{
		s MEDDATA = $p($g(SpaceHIS),"^",1)
		s WEBSRC  = $p($g(SpaceHIS),"^",2)
	}
	s SpaceLIS=##class(EMR.DOC.BL.SysOption).GetOptionValueByName("NameSpaceLIS",..#ProductCode)
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
 	s PapmiDR = ##Class(EMR.DOC.HISInterface.PatientInfoAssist).GetPapmiDR(Adm)
 	s EpisodeNo=##Class(EMR.DOC.HISInterface.PatientInfoAssist).GetEpisodeNo(Adm)
 	s RegisterNo = ##Class(EMR.DOC.HISInterface.PatientInfoAssist).GetPapmiNo(PapmiDR)
	s Name=##Class(EMR.DOC.HISInterface.PatientInfoAssist).Name(PapmiDR)

	
	// 患者费用(病案费用子类)
	s InPatFee="" , CheckTotal="",CheckFee="",CheckFeeTag=""
	s arrFee = ##Class(%ArrayOfDataTypes).%New()
	
	s InPatFee=##class(EMR.DOC.HISInterface.PatientInfoAssist).InPatCostTrakCareSubNew(Adm,Hospital)
	
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
	s MC09FSSZLXMF = arrFee.GetAt("非手术治疗项目费")
	s MC10LCWLZLF = arrFee.GetAt("临床物理治疗费")
	s MC11SSZLF = arrFee.GetAt("手术治疗费")
	s MC12MZF = arrFee.GetAt("麻醉费")
	s MC13SSF = arrFee.GetAt("手术费")
	s MC14KFF = arrFee.GetAt("康复费")
	s MC15ZYZLF = arrFee.GetAt("中医治疗费")
	s MC16XYF = arrFee.GetAt("西药费")
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
/// Test:		##Class(EMR.OP.HISInterface.SystemData).testtmc(Adm)
/// 		d ##class(%ResultSet).RunQuery("EMR.OP.HISInterface.SystemData","GetTMCFeeInfo","67")
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
	s Hospital=##class(EMR.DOC.BL.SysOption).GetOptionValueByName("HospitalName",..#ProductCode)
  	s SpaceHIS=##class(EMR.DOC.BL.SysOption).GetOptionValueByName("NameSpaceHIS",..#ProductCode)
	if SpaceHIS'=""
	{
		s MEDDATA = $p($g(SpaceHIS),"^",1)
		s WEBSRC  = $p($g(SpaceHIS),"^",2)
	}
	s SpaceLIS=##class(EMR.DOC.BL.SysOption).GetOptionValueByName("NameSpaceLIS",..#ProductCode)
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
 	s PapmiDR = ##Class(EMR.DOC.HISInterface.PatientInfoAssist).GetPapmiDR(Adm)
 	s EpisodeNo=##Class(EMR.DOC.HISInterface.PatientInfoAssist).GetEpisodeNo(Adm)
 	s RegisterNo = ##Class(EMR.DOC.HISInterface.PatientInfoAssist).GetPapmiNo(PapmiDR)
	s Name=##Class(EMR.DOC.HISInterface.PatientInfoAssist).Name(PapmiDR)

	
	// 患者费用(病案费用大类)
	s InPatFee="" ,CheckTotal="" ,CheckFee="" ,CheckFeeTag=""
	s arrFee = ##Class(%ArrayOfDataTypes).%New()
	s InPatFee=##class(EMR.DOC.HISInterface.PatientInfoAssist).InPatCostTrakCareNew(Adm,Hospital)
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
/// d ##class(%ResultSet).RunQuery("EMR.OP.HISInterface.SystemData","GetUserInfo","10209")
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
/// Test:		d ##class(%ResultSet).RunQuery("EMR.OP.HISInterface.SystemData","GetCustomInfo","67")
Query GetCustomInfo(Adm As %String) As %Query(ROWSPEC = "EpisodeID,PapmiDR,EpisodeNo,RegisterNo,Name,HospitalName,OpOeord,CNOrder,OpDiag,VentilatorHour")
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
	s Hospital=##class(EMR.DOC.BL.SysOption).GetOptionValueByName("HospitalName",..#ProductCode)
  	s SpaceHIS=##class(EMR.DOC.BL.SysOption).GetOptionValueByName("NameSpaceHIS",..#ProductCode)
	if SpaceHIS'=""
	{
		s MEDDATA = $p($g(SpaceHIS),"^",1)
		s WEBSRC  = $p($g(SpaceHIS),"^",2)
	}
	s SpaceLIS=##class(EMR.DOC.BL.SysOption).GetOptionValueByName("NameSpaceLIS",..#ProductCode)
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
 	s PapmiDR = ##Class(EMR.DOC.HISInterface.PatientInfoAssist).GetPapmiDR(Adm)
 	s EpisodeNo=##Class(EMR.DOC.HISInterface.PatientInfoAssist).GetEpisodeNo(Adm)
 	s RegisterNo = ##Class(EMR.DOC.HISInterface.PatientInfoAssist).GetPapmiNo(PapmiDR)
	s Name=##Class(EMR.DOC.HISInterface.PatientInfoAssist).Name(PapmiDR)
	
	
	s HospitalName = ##class(EMR.DOC.HISInterface.PatientInfoAssist).HospitalName(Adm)
	
	
	s OpOeord = ##Class(EMRservice.BL.opInterface).getOeordXH(Adm,"","\r\n")
	s CNOrder = ##Class(EMRservice.BL.opInterfaceBase).getOeordXH(Adm,"CHMED","\r\n")
	s OpDiag = ##Class(EMRservice.BL.opInterfaceBase).getDiagDataXH(Adm,"\r\n")
	
	s VentilatorHour = ""
	//监护仪使用时长
	 s strMethodName = "web.DHCICUStat||GetVentilatorHour"
	 s strMethodRes =##Class(EMR.DOC.COM.ClassDefine).CheckMethodExist(strMethodName)
	 if (strMethodRes="1")
	 {
		s VentilatorHour=##class(web.DHCICUStat).GetVentilatorHour(Adm,"NoninvasiveVentilatorHour")
		//取最新的一条记录
		s VentilatorHour=$p(VentilatorHour,"@",$l(VentilatorHour,"@"))
	 }
	set ^CacheTemp(repid, ind) = $LB(EpisodeID,PapmiDR,EpisodeNo,RegisterNo,Name,HospitalName,OpOeord,CNOrder,OpDiag,VentilatorHour)
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
/// CreateUser:	HouJian
/// CreateTime：2009-01-21
/// Desc：		取手术信息
/// Input:		argAdm：就诊RowId		
/// Debug:		d ##class(%ResultSet).RunQuery("EMR.OP.HISInterface.SystemData","GetAnOperInfo","67")
Query GetAnOperInfo(argAdm As %String) As %Query(ROWSPEC = "OperName1Dict,OperStartDate1,OperEndDate1,OperLevelDict1,OperDoc1Dict,OperAssist1Dict,OperSecAssist1Dict,OperAnaMethod1Dict,OperAnaDoc1Dict,OperName2Dict,OperStartDate2,OperEndDate2,OperLevelDict2,OperDoc2Dict,OperAssist2Dict,OperSecAssist2Dict,OperAnaMethod2Dict,OperAnaDoc2Dict,OperName3Dict,OperStartDate3,OperEndDate3,OperLevelDict3,OperDoc3Dict,OperAssist3Dict,OperSecAssist3Dict,OperAnaMethod3Dict,OperAnaDoc3Dict,OperName4Dict,OperStartDate4,OperEndDate4,OperLevelDict4,OperDoc4Dict,OperAssist4Dict,OperSecAssist4Dict,OperAnaMethod4Dict,OperAnaDoc4Dict,OperName5Dict,OperStartDate5,OperEndDate5,OperLevelDict5,OperDoc5Dict,OperAssist5Dict,OperSecAssist5Dict,OperAnaMethod5Dict,OperAnaDoc5Dict,OperName6Dict,OperStartDate6,OperEndDate6,OperLevelDict6,OperDoc6Dict,OperAssist6Dict,OperSecAssist6Dict,OperAnaMethod6Dict,OperAnaDoc6Dict,OperName7Dict,OperStartDate7,OperEndDate7,OperLevelDict7,OperDoc7Dict,OperAssist7Dict,OperSecAssist7Dict,OperAnaMethod7Dict,OperAnaDoc7Dict,OperName8Dict,OperStartDate8,OperEndDate8,OperLevelDict8,OperDoc8Dict,OperAssist8Dict,OperSecAssist8Dict,OperAnaMethod8Dict,OperAnaDoc8Dict,OperNameLastDict,OperStartDateLast,OperEndDateLast,OperLevelDictLast,OperDocLastDict,OperAssistLastDict,OperSecAssistLastDict,OperAnaMethodLastDict,OperAnaDocLastDict")
{
}

ClassMethod GetAnOperInfoExecute(ByRef qHandle As %Binary, argAdm As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	Set qHandle=$lb(0,repid,0)
	
	//获取入院日期
	s AdmDateTime = "",AdmDate = ""
	s AdmDateTime = ##class(EMR.DOC.HISInterface.PatientInfoAssist).AdmDateTime(argAdm,"")
	s AdmDate = $P(AdmDateTime,",",1)
	
	//手术ID、手术名称（字典）
	s OperID1 = "", OperID2 = "", OperID3 = "", OperID4 = "", OperID5 = "", OperID6 = ""
	s OperDict1 = "", OperDict2 = "", OperDict3 = "", OperDict4 = "", OperDict5 ="", OperDict6 =""
	//手术日期
	s OperDate1 = "", OperDate2 = "", OperDate3 = "", OperDate4 = "", OperDate5 ="", OperDate6 =""
	s OperEndDate1 = "", OperEndDate2 = "", OperEndDate3 = "", OperEndDate4 = "", OperEndDate5 ="", OperEndDate6 =""
	//手术级别
	s OperLevel1 = "", OperLevel2= "", OperLevel3 = "", OperLevel4 = "",OperLevel5 = "", OperLevel6 =""
	//术者
	s OperDoc1 = "", OperDoc2= "", OperDoc3 = "", OperDoc4 = "",OperDoc5 = "",OperDoc6 = ""
	//一助
	s OperAssistantFirst1 = "", OperAssistantFirst2= "", OperAssistantFirst3 = "", OperAssistantFirst4 = "",OperAssistantFirst5 = "",OperAssistantFirst6 = ""
	//二助
	s OperAssistantSecond1 = "", OperAssistantSecond2= "", OperAssistantSecond3= "", OperAssistantSecond4 = "",OperAssistantSecond5 ="",OperAssistantSecond6 =""
	//麻醉方式
	s OperAnaMethod1 = "", OperAnaMethod2= "",OperAnaMethod3 = "", OperAnaMethod4 = "",OperAnaMethod5 ="",OperAnaMethod6=""
	//麻醉医师
	s OperAnaDoctor1 = "", OperAnaDoctor2 = "", OperAnaDoctor3 = "", OperAnaDoctor4 = "",OperAnaDoctor5="",OperAnaDoctor6=""	
	
	//Last
	s (OperIDLast,OperDictLast,OperDateLast,OperEndDateLast,OperLevel,OperDocLast,OperAssistantFirstLast,OperAssistantSecondLast,OperAnaMetodLast,AnaDoctorLast)=""
	
	s OperStrtmp = ""
	s OperStrtmp = ##Class(EMR.DOC.HISInterface.PatientInfoAssist).GetANOperInfoSep(argAdm)
	s OperInfo1 = $P(OperStrtmp,"#",1)
	s OperInfo2 = $P(OperStrtmp,"#",2)
	s OperInfo3 = $P(OperStrtmp,"#",3)
	s OperInfo4 = $P(OperStrtmp,"#",4)
	s OperInfo5 = $P(OperStrtmp,"#",5)
	s OperInfo6 = $P(OperStrtmp,"#",6)
	s OperInfo7 = $P(OperStrtmp,"#",7)
	s OperInfo8 = $P(OperStrtmp,"#",8)
	
	// 获取最新的一条手术数据
	s OperLength = $L(OperStrtmp,"#")
	s OperInfoLast = $P(OperStrtmp,"#",OperLength)
	
	
	// 手术记录信息从手麻重症系统提取
	if (OperInfoLast '= "")
	{
		// 手术名称
		s OperIDLast = $P(OperInfoLast,"@",6)
		if (OperIDLast'="") 
		{
			s OperDictLast = OperIDLast_"^"_$P(^ORC("OPER",OperIDLast),"^",14)_"^"_$P(^ORC("OPER",OperIDLast),"^",2)
		}
		else
		{
			s OperDictLast = "^^"_$P(OperInfo1,"@",7)
		}
		// 手术开始日期时间
		s OperDateLast = $P(OperInfoLast,"@",1)
		// 手术结束日期时间
		s OperEndDateLast = $P($P(OperInfoLast,"@",3)," ",1)
		// 手术级别
		s OperLevelCodeLast = "",OperLevelRowIDLast = "",OperLevelDescLast = ""
		s OperLevelRowIDLast = $P(OperInfoLast,"@",79)
		if (OperLevelRowIDLast'="")
		{
			s OperLevelCodeLast = $P(^ORC("CATEG",OperLevelRowIDLast),"^",1)
			s OperLevelDescLast = $P(^ORC("CATEG",OperLevelRowIDLast),"^",2)
			s OperLevelLast = OperLevelRowIDLast_"^"_OperLevelCodeLast_"^"_OperLevelDescLast
		}
		// 手术医生
		s OperDocID = $P(OperInfoLast,"@",18)
		if (OperDocID'="") 
		{
			s OperDocID = OperDocID_"^"_$P(^CTPCP(OperDocID,1),"^",1)_"^"
		}
		else
		{
			s OperDocID = "^^"
		}
		s OperDocLast = OperDocID_$P(OperInfoLast,"@",19)
		
		// 一助
		s OperDocID = $P(OperInfoLast,"@",20)
		if (OperDocID'="") 
		{
			s OperDocID = OperDocID_"^"_$P(^CTPCP(OperDocID,1),"^",1)_"^"
		}
		else
		{
			s OperDocID = "^^"
		}
		s OperAssistantFirstLast = OperDocID_$P(OperInfoLast,"@",21)
		// 二助
		s OperDocID = $P(OperInfoLast,"@",22)
		if (OperDocID'="") 
		{
			s OperDocID = OperDocID_"^"_$P(^CTPCP(OperDocID,1),"^",1)_"^"
		}
		else
		{
			s OperDocID = "^^"
		}
		s OperAssistantSecondLast = OperDocID_$P(OperInfoLast,"@",23)
		// 麻醉方式
		s OperAnaMethodLast = $P(OperInfoLast,"@",24)
		s OperAnaMethodLast = ##Class(EMR.DOC.HISInterface.PatientInfoAssist).GetAnaMedhodDict(OperAnaMethodLast)
		// 麻醉医生
		s OperDocID = $P(OperInfoLast,"@",25)
		if (OperDocID'="") 
		{
			s OperDocID = OperDocID_"^"_$P(^CTPCP(OperDocID,1),"^",1)_"^"
		}
		else
		{
			s OperDocID = "^^"
		}
		s OperAnaDoctorLast = OperDocID_$P(OperInfoLast,"@",26)
	}
	if (OperInfo1 '= "")
	{
		// 手术名称
		s OperID1 = $P(OperInfo1,"@",6)
		if (OperID1'="") 
		{
			s OperDict1 = OperID1_"^"_$P(^ORC("OPER",OperID1),"^",14)_"^"_$P(^ORC("OPER",OperID1),"^",2)
		}
		else
		{
			s OperDict1 = "^^"_$P(OperInfo1,"@",7)
		}
		// 手术开始日期时间
		s OperDate1 = $P(OperInfo1,"@",1)
		// 手术结束日期时间
		s OperEndDate1 = $P($P(OperInfo1,"@",3)," ",1)
		// 手术级别
		s OperLevelCode1 = "",OperLevelRowID1 = "",OperLevelDesc1 = ""
		s OperLevelRowID1 = $P(OperInfo1,"@",79)
		if (OperLevelRowID1'="")
		{
			s OperLevelCode1 = $P(^ORC("CATEG",OperLevelRowID1),"^",1)
			s OperLevelDesc1 = $P(^ORC("CATEG",OperLevelRowID1),"^",2)
			s OperLevel1 = OperLevelRowID1_"^"_OperLevelCode1_"^"_OperLevelDesc1
		}
		// 手术医生
		s OperDocID = $P(OperInfo1,"@",18)
		if (OperDocID'="") 
		{
			s OperDocID = OperDocID_"^"_$P(^CTPCP(OperDocID,1),"^",1)_"^"
		}
		else
		{
			s OperDocID = "^^"
		}
		s OperDoc1 = OperDocID_$P(OperInfo1,"@",19)
		// 一助
		s OperDocID = $P(OperInfo1,"@",20)
		if (OperDocID'="") 
		{
			s OperDocID = OperDocID_"^"_$P(^CTPCP(OperDocID,1),"^",1)_"^"
		}
		else
		{
			s OperDocID = "^^"
		}
		s OperAssistantFirst1 = OperDocID_$P(OperInfo1,"@",21)
		// 二助
		s OperDocID = $P(OperInfo1,"@",22)
		if (OperDocID'="") 
		{
			s OperDocID = OperDocID_"^"_$P(^CTPCP(OperDocID,1),"^",1)_"^"
		}
		else
		{
			s OperDocID = "^^"
		}
		s OperAssistantSecond1 = OperDocID_$P(OperInfo1,"@",23)
		// 麻醉方式
		s OperAnaMethod1 = $P(OperInfo1,"@",24)
		s OperAnaMethod1 = ##Class(EMR.DOC.HISInterface.PatientInfoAssist).GetAnaMedhodDict(OperAnaMethod1)
		// 麻醉医生
		s OperDocID = $P(OperInfo1,"@",25)
		if (OperDocID'="") 
		{
			s OperDocID = OperDocID_"^"_$P(^CTPCP(OperDocID,1),"^",1)_"^"
		}
		else
		{
			s OperDocID = "^^"
		}
		s OperAnaDoctor1 = OperDocID_$P(OperInfo1,"@",26)
	}
	if (OperInfo2 '= "")
	{
		// 手术名称
		s OperID2 = $P(OperInfo2,"@",6)
		if (OperID2'="") 
		{
			s OperDict2 = OperID2_"^"_$P(^ORC("OPER",OperID2),"^",14)_"^"_$P(^ORC("OPER",OperID2),"^",2)
		}
		else
		{
			s OperDict2 = "^^"_$P(OperInfo2,"@",7)
		}
		// 手术开始日期时间
		s OperDate2 = $P(OperInfo2,"@",1)
		// 手术结束日期时间
		s OperEndDate2 = $P($P(OperInfo2,"@",3)," ",1)
		// 手术级别
		s OperLevelCode2 = "",OperLevelRowID2 = "",OperLevelDesc2 = ""
		s OperLevelRowID2 = $P(OperInfo2,"@",79)
		if (OperLevelRowID2'="")
		{
			s OperLevelCode2 = $P(^ORC("CATEG",OperLevelRowID2),"^",1)
			s OperLevelDesc2 = $P(^ORC("CATEG",OperLevelRowID2),"^",2)
			s OperLevel2 = OperLevelRowID2_"^"_OperLevelCode2_"^"_OperLevelDesc2
		}
		// 手术医生
		s OperDocID = $P(OperInfo2,"@",18)
		if (OperDocID'="") 
		{
			s OperDocID = OperDocID_"^"_$P(^CTPCP(OperDocID,1),"^",1)_"^"
		}
		else
		{
			s OperDocID = "^^"
		}
		s OperDoc2 = OperDocID_$P(OperInfo2,"@",19)
		// 一助
		s OperDocID = $P(OperInfo2,"@",20)
		if (OperDocID'="") 
		{
			s OperDocID = OperDocID_"^"_$P(^CTPCP(OperDocID,1),"^",1)_"^"
		}
		else
		{
			s OperDocID = "^^"
		}
		s OperAssistantFirst2 = OperDocID_$P(OperInfo2,"@",21)
		// 二助
		s OperDocID = $P(OperInfo2,"@",22)
		if (OperDocID'="") 
		{
			s OperDocID = OperDocID_"^"_$P(^CTPCP(OperDocID,1),"^",1)_"^"
		}
		else
		{
			s OperDocID = "^^"
		}
		s OperAssistantSecond2 = OperDocID_$P(OperInfo2,"@",23)
		// 麻醉方式
		s OperAnaMethod2 = $P(OperInfo2,"@",24)
		s OperAnaMethod2 = ##Class(EMR.DOC.HISInterface.PatientInfoAssist).GetAnaMedhodDict(OperAnaMethod2)
		// 麻醉医生
		s OperDocID = $P(OperInfo2,"@",25)
		if (OperDocID'="") 
		{
			s OperDocID = OperDocID_"^"_$P(^CTPCP(OperDocID,1),"^",1)_"^"
		}
		else
		{
			s OperDocID = "^^"
		}
		s OperAnaDoctor2 = OperDocID_$P(OperInfo2,"@",26)
	}
	if (OperInfo3 '= "")
	{
		// 手术名称
		s OperID3 = $P(OperInfo3,"@",6)
		if (OperID3'="") 
		{
			s OperDict3 = OperID3_"^"_$P(^ORC("OPER",OperID3),"^",14)_"^"_$P(^ORC("OPER",OperID3),"^",2)
		}
		else
		{
			s OperDict3 = "^^"_$P(OperInfo3,"@",7)
		}
		// 手术开始日期时间
		s OperDate3 = $P(OperInfo3,"@",1)
		// 手术结束日期时间
		s OperEndDate3 = $P($P(OperInfo3,"@",3)," ",1)
		// 手术级别
		s OperLevelCode3 = "",OperLevelRowID3 = "",OperLevelDesc3 = ""
		s OperLevelRowID3 = $P(OperInfo3,"@",79)
		if (OperLevelRowID3'="")
		{
			s OperLevelCode3 = $P(^ORC("CATEG",OperLevelRowID3),"^",1)
			s OperLevelDesc3 = $P(^ORC("CATEG",OperLevelRowID3),"^",2)
			s OperLevel3 = OperLevelRowID3_"^"_OperLevelCode3_"^"_OperLevelDesc3
		}
		// 手术医生
		s OperDocID = $P(OperInfo3,"@",18)
		if (OperDocID'="") 
		{
			s OperDocID = OperDocID_"^"_$P(^CTPCP(OperDocID,1),"^",1)_"^"
		}
		else
		{
			s OperDocID = "^^"
		}
		s OperDoc3 = OperDocID_$P(OperInfo3,"@",19)
		// 一助
		s OperDocID = $P(OperInfo3,"@",20)
		if (OperDocID'="") 
		{
			s OperDocID = OperDocID_"^"_$P(^CTPCP(OperDocID,1),"^",1)_"^"
		}
		else
		{
			s OperDocID = "^^"
		}
		s OperAssistantFirst3 = OperDocID_$P(OperInfo3,"@",21)
		// 二助
		s OperDocID = $P(OperInfo3,"@",22)
		if (OperDocID'="") 
		{
			s OperDocID = OperDocID_"^"_$P(^CTPCP(OperDocID,1),"^",1)_"^"
		}
		else
		{
			s OperDocID = "^^"
		}
		s OperAssistantSecond3 = OperDocID_$P(OperInfo3,"@",23)
		// 麻醉方式
		s OperAnaMethod3 = $P(OperInfo3,"@",24)
		s OperAnaMethod3 = ##Class(EMR.DOC.HISInterface.PatientInfoAssist).GetAnaMedhodDict(OperAnaMethod3)
		// 麻醉医生
		s OperDocID = $P(OperInfo3,"@",25)
		if (OperDocID'="") 
		{
			s OperDocID = OperDocID_"^"_$P(^CTPCP(OperDocID,1),"^",1)_"^"
		}
		else
		{
			s OperDocID = "^^"
		}
		s OperAnaDoctor3 = OperDocID_$P(OperInfo3,"@",26)
	}
	if (OperInfo4 '= "")
	{
		// 手术名称
		s OperID4 = $P(OperInfo4,"@",6)
		if (OperID4'="") 
		{
			s OperDict4 = OperID4_"^"_$P(^ORC("OPER",OperID4),"^",14)_"^"_$P(^ORC("OPER",OperID4),"^",2)
		}
		else
		{
			s OperDict4 = "^^"_$P(OperInfo4,"@",7)
		}
		// 手术开始日期时间
		s OperDate4 = $P(OperInfo4,"@",1)
		// 手术结束日期时间
		s OperEndDate4 = $P($P(OperInfo4,"@",3)," ",1)
		// 手术级别
		s OperLevelCode4 = "",OperLevelRowID4 = "",OperLevelDesc4 = ""
		s OperLevelRowID4 = $P(OperInfo4,"@",79)
		if (OperLevelRowID4'="")
		{
			s OperLevelCode4 = $P(^ORC("CATEG",OperLevelRowID4),"^",1)
			s OperLevelDesc4 = $P(^ORC("CATEG",OperLevelRowID4),"^",2)
			s OperLevel4 = OperLevelRowID4_"^"_OperLevelCode4_"^"_OperLevelDesc4
		}
		// 手术医生
		s OperDocID = $P(OperInfo4,"@",18)
		if (OperDocID'="") 
		{
			s OperDocID = OperDocID_"^"_$P(^CTPCP(OperDocID,1),"^",1)_"^"
		}
		else
		{
			s OperDocID = "^^"
		}
		s OperDoc4 = OperDocID_$P(OperInfo4,"@",19)
		// 一助
		s OperDocID = $P(OperInfo4,"@",20)
		if (OperDocID'="") 
		{
			s OperDocID = OperDocID_"^"_$P(^CTPCP(OperDocID,1),"^",1)_"^"
		}
		else
		{
			s OperDocID = "^^"
		}
		s OperAssistantFirst4 = OperDocID_$P(OperInfo4,"@",21)
		// 二助
		s OperDocID = $P(OperInfo4,"@",22)
		if (OperDocID'="") 
		{
			s OperDocID = OperDocID_"^"_$P(^CTPCP(OperDocID,1),"^",1)_"^"
		}
		else
		{
			s OperDocID = "^^"
		}
		s OperAssistantSecond4 = OperDocID_$P(OperInfo4,"@",23)
		// 麻醉方式
		s OperAnaMethod4 = $P(OperInfo4,"@",24)
		s OperAnaMethod4 = ##Class(EMR.DOC.HISInterface.PatientInfoAssist).GetAnaMedhodDict(OperAnaMethod4)
		// 麻醉医生
		s OperDocID = $P(OperInfo4,"@",25)
		if (OperDocID'="") 
		{
			s OperDocID = OperDocID_"^"_$P(^CTPCP(OperDocID,1),"^",1)_"^"
		}
		else
		{
			s OperDocID = "^^"
		}
		s OperAnaDoctor4 = OperDocID_$P(OperInfo4,"@",26)
	}
	if (OperInfo5 '= "")
	{
		// 手术名称
		s OperID5 = $P(OperInfo5,"@",6)
		if (OperID5'="") 
		{
			s OperDict5 = OperID5_"^"_$P(^ORC("OPER",OperID5),"^",14)_"^"_$P(^ORC("OPER",OperID5),"^",2)
		}
		else
		{
			s OperDict5 = "^^"_$P(OperInfo5,"@",7)
		}
		// 手术开始日期时间
		s OperDate5 = $P(OperInfo5,"@",1)
		// 手术结束日期时间
		s OperEndDate5 = $P($P(OperInfo5,"@",3)," ",1)
		// 手术级别
		s OperLevelCode5 = "",OperLevelRowID5 = "",OperLevelDesc5 = ""
		s OperLevelRowID5 = $P(OperInfo5,"@",79)
		if (OperLevelRowID5'="")
		{
			s OperLevelCode5 = $P(^ORC("CATEG",OperLevelRowID5),"^",1)
			s OperLevelDesc5 = $P(^ORC("CATEG",OperLevelRowID5),"^",2)
			s OperLevel5 = OperLevelRowID5_"^"_OperLevelCode5_"^"_OperLevelDesc5
		}
		// 手术医生
		s OperDocID = $P(OperInfo5,"@",18)
		if (OperDocID'="") 
		{
			s OperDocID = OperDocID_"^"_$P(^CTPCP(OperDocID,1),"^",1)_"^"
		}
		else
		{
			s OperDocID = "^^"
		}
		s OperDoc5 = OperDocID_$P(OperInfo5,"@",19)
		// 一助
		s OperDocID = $P(OperInfo5,"@",20)
		if (OperDocID'="") 
		{
			s OperDocID = OperDocID_"^"_$P(^CTPCP(OperDocID,1),"^",1)_"^"
		}
		else
		{
			s OperDocID = "^^"
		}
		s OperAssistantFirst5 = OperDocID_$P(OperInfo5,"@",21)
		// 二助
		s OperDocID = $P(OperInfo5,"@",22)
		if (OperDocID'="") 
		{
			s OperDocID = OperDocID_"^"_$P(^CTPCP(OperDocID,1),"^",1)_"^"
		}
		else
		{
			s OperDocID = "^^"
		}
		s OperAssistantSecond5 = OperDocID_$P(OperInfo5,"@",23)
		// 麻醉方式
		s OperAnaMethod5 = $P(OperInfo5,"@",24)
		s OperAnaMethod5 = ##Class(EMR.DOC.HISInterface.PatientInfoAssist).GetAnaMedhodDict(OperAnaMethod5)
		// 麻醉医生
		s OperDocID = $P(OperInfo5,"@",25)
		if (OperDocID'="") 
		{
			s OperDocID = OperDocID_"^"_$P(^CTPCP(OperDocID,1),"^",1)_"^"
		}
		else
		{
			s OperDocID = "^^"
		}
		s OperAnaDoctor5 = OperDocID_$P(OperInfo5,"@",26)
	}
	if (OperInfo6 '= "")
	{
		// 手术名称
		s OperID6 = $P(OperInfo6,"@",6)
		if (OperID6'="") 
		{
			s OperDict6 = OperID6_"^"_$P(^ORC("OPER",OperID6),"^",14)_"^"_$P(^ORC("OPER",OperID6),"^",2)
		}
		else
		{
			s OperDict6 = "^^"_$P(OperInfo6,"@",7)
		}
		// 手术开始日期时间
		s OperDate6 = $P(OperInfo6,"@",1)
		// 手术结束日期时间
		s OperEndDate6 = $P($P(OperInfo6,"@",3)," ",1)
		// 手术级别
		s OperLevelCode6 = "",OperLevelRowID6 = "",OperLevelDesc6 = ""
		s OperLevelRowID6 = $P(OperInfo6,"@",79)
		if (OperLevelRowID6'="")
		{
			s OperLevelCode6 = $P(^ORC("CATEG",OperLevelRowID6),"^",1)
			s OperLevelDesc6 = $P(^ORC("CATEG",OperLevelRowID6),"^",2)
			s OperLevel6 = OperLevelRowID6_"^"_OperLevelCode6_"^"_OperLevelDesc6
		}
		// 手术医生
		s OperDocID = $P(OperInfo6,"@",18)
		if (OperDocID'="") 
		{
			s OperDocID = OperDocID_"^"_$P(^CTPCP(OperDocID,1),"^",1)_"^"
		}
		else
		{
			s OperDocID = "^^"
		}
		s OperDoc6 = OperDocID_$P(OperInfo6,"@",19)
		// 一助
		s OperDocID = $P(OperInfo6,"@",20)
		if (OperDocID'="") 
		{
			s OperDocID = OperDocID_"^"_$P(^CTPCP(OperDocID,1),"^",1)_"^"
		}
		else
		{
			s OperDocID = "^^"
		}
		s OperAssistantFirst6 = OperDocID_$P(OperInfo6,"@",21)
		// 二助
		s OperDocID = $P(OperInfo6,"@",22)
		if (OperDocID'="") 
		{
			s OperDocID = OperDocID_"^"_$P(^CTPCP(OperDocID,1),"^",1)_"^"
		}
		else
		{
			s OperDocID = "^^"
		}
		s OperAssistantSecond6 = OperDocID_$P(OperInfo6,"@",23)
		// 麻醉方式
		s OperAnaMethod6 = $P(OperInfo6,"@",24)
		s OperAnaMethod6 = ##Class(EMR.DOC.HISInterface.PatientInfoAssist).GetAnaMedhodDict(OperAnaMethod6)
		// 麻醉医生
		s OperDocID = $P(OperInfo6,"@",25)
		if (OperDocID'="") 
		{
			s OperDocID = OperDocID_"^"_$P(^CTPCP(OperDocID,1),"^",1)_"^"
		}
		else
		{
			s OperDocID = "^^"
		}
		s OperAnaDoctor6 = OperDocID_$P(OperInfo6,"@",26)
	}
	if (OperInfo7 '= "")
	{
		// 手术名称
		s OperID7 = $P(OperInfo7,"@",6)
		if (OperID7'="") 
		{
			s OperDict7 = OperID7_"^"_$P(^ORC("OPER",OperID7),"^",14)_"^"_$P(^ORC("OPER",OperID7),"^",2)
		}
		else
		{
			s OperDict7 = "^^"_$P(OperInfo7,"@",7)
		}
		// 手术开始日期时间
		s OperDate7 = $P(OperInfo7,"@",1)
		// 手术结束日期时间
		s OperEndDate7 = $P($P(OperInfo7,"@",3)," ",1)
		// 手术级别
		s OperLevelCode7 = "",OperLevelRowID7 = "",OperLevelDesc7 = ""
		s OperLevelRowID7 = $P(OperInfo7,"@",79)
		if (OperLevelRowID7'="")
		{
			s OperLevelCode7 = $P(^ORC("CATEG",OperLevelRowID7),"^",1)
			s OperLevelDesc7 = $P(^ORC("CATEG",OperLevelRowID7),"^",2)
			s OperLevel7 = OperLevelRowID7_"^"_OperLevelCode7_"^"_OperLevelDesc7
		}
		// 手术医生
		s OperDocID = $P(OperInfo7,"@",18)
		if (OperDocID'="") 
		{
			s OperDocID = OperDocID_"^"_$P(^CTPCP(OperDocID,1),"^",1)_"^"
		}
		else
		{
			s OperDocID = "^^"
		}
		s OperDoc7 = OperDocID_$P(OperInfo7,"@",19)
		// 一助
		s OperDocID = $P(OperInfo7,"@",20)
		if (OperDocID'="") 
		{
			s OperDocID = OperDocID_"^"_$P(^CTPCP(OperDocID,1),"^",1)_"^"
		}
		else
		{
			s OperDocID = "^^"
		}
		s OperAssistantFirst7 = OperDocID_$P(OperInfo7,"@",21)
		// 二助
		s OperDocID = $P(OperInfo7,"@",22)
		if (OperDocID'="") 
		{
			s OperDocID = OperDocID_"^"_$P(^CTPCP(OperDocID,1),"^",1)_"^"
		}
		else
		{
			s OperDocID = "^^"
		}
		s OperAssistantSecond7 = OperDocID_$P(OperInfo7,"@",23)
		// 麻醉方式
		s OperAnaMethod7 = $P(OperInfo7,"@",24)
		s OperAnaMethod7 = ##Class(EMR.DOC.HISInterface.PatientInfoAssist).GetAnaMedhodDict(OperAnaMethod7)
		// 麻醉医生
		s OperDocID = $P(OperInfo7,"@",25)
		if (OperDocID'="") 
		{
			s OperDocID = OperDocID_"^"_$P(^CTPCP(OperDocID,1),"^",1)_"^"
		}
		else
		{
			s OperDocID = "^^"
		}
		s OperAnaDoctor7 = OperDocID_$P(OperInfo7,"@",26)
	}
	if (OperInfo8 '= "")
	{
		// 手术名称
		s OperID8 = $P(OperInfo8,"@",6)
		if (OperID8'="") 
		{
			s OperDict8 = OperID8_"^"_$P(^ORC("OPER",OperID8),"^",14)_"^"_$P(^ORC("OPER",OperID8),"^",2)
		}
		else
		{
			s OperDict8 = "^^"_$P(OperInfo8,"@",7)
		}
		// 手术开始日期时间
		s OperDate8 = $P(OperInfo8,"@",1)
		// 手术结束日期时间
		s OperEndDate8 = $P($P(OperInfo8,"@",3)," ",1)
		// 手术级别
		s OperLevelCode8 = "",OperLevelRowID8 = "",OperLevelDesc8 = ""
		s OperLevelRowID8 = $P(OperInfo8,"@",79)
		if (OperLevelRowID8'="")
		{
			s OperLevelCode8 = $P(^ORC("CATEG",OperLevelRowID8),"^",1)
			s OperLevelDesc8 = $P(^ORC("CATEG",OperLevelRowID8),"^",2)
			s OperLevel8 = OperLevelRowID8_"^"_OperLevelCode8_"^"_OperLevelDesc8
		}
		// 手术医生
		s OperDocID = $P(OperInfo8,"@",18)
		if (OperDocID'="") 
		{
			s OperDocID = OperDocID_"^"_$P(^CTPCP(OperDocID,1),"^",1)_"^"
		}
		else
		{
			s OperDocID = "^^"
		}
		s OperDoc8 = OperDocID_$P(OperInfo8,"@",19)
		// 一助
		s OperDocID = $P(OperInfo8,"@",20)
		if (OperDocID'="") 
		{
			s OperDocID = OperDocID_"^"_$P(^CTPCP(OperDocID,1),"^",1)_"^"
		}
		else
		{
			s OperDocID = "^^"
		}
		s OperAssistantFirst8 = OperDocID_$P(OperInfo8,"@",21)
		// 二助
		s OperDocID = $P(OperInfo8,"@",22)
		if (OperDocID'="") 
		{
			s OperDocID = OperDocID_"^"_$P(^CTPCP(OperDocID,1),"^",1)_"^"
		}
		else
		{
			s OperDocID = "^^"
		}
		s OperAssistantSecond8 = OperDocID_$P(OperInfo8,"@",23)
		// 麻醉方式
		s OperAnaMethod8 = $P(OperInfo8,"@",24)
		s OperAnaMethod8 = ##Class(EMR.DOC.HISInterface.PatientInfoAssist).GetAnaMedhodDict(OperAnaMethod8)
		// 麻醉医生
		s OperDocID = $P(OperInfo8,"@",25)
		if (OperDocID'="") 
		{
			s OperDocID = OperDocID_"^"_$P(^CTPCP(OperDocID,1),"^",1)_"^"
		}
		else
		{
			s OperDocID = "^^"
		}
		s OperAnaDoctor8 = OperDocID_$P(OperInfo8,"@",26)
	}
	
	set ^CacheTemp(repid, ind) = $LB(OperDict1,OperDate1,OperEndDate1,OperLevel1,OperDoc1,OperAssistantFirst1,OperAssistantSecond1,OperAnaMethod1,OperAnaDoctor1,OperDict2,OperDate2,OperEndDate2,OperLevel2,OperDoc2,OperAssistantFirst2,OperAssistantSecond2,OperAnaMethod2,OperAnaDoctor2,OperDict3,OperDate3,OperEndDate3,OperLevel3,OperDoc3,OperAssistantFirst3,OperAssistantSecond3,OperAnaMethod3,OperAnaDoctor3,OperDict4,OperDate4,OperEndDate4,OperLevel4,OperDoc4,OperAssistantFirst4,OperAssistantSecond4,OperAnaMethod4,OperAnaDoctor4,OperDict5,OperDate5,OperEndDate5,OperLevel5,OperDoc5,OperAssistantFirst5,OperAssistantSecond5,OperAnaMethod5,OperAnaDoctor5,OperDict6,OperDate6,OperEndDate6,OperLevel6,OperDoc6,OperAssistantFirst6,OperAssistantSecond6,OperAnaMethod6,OperAnaDoctor6,OperDict7,OperDate7,OperEndDate7,OperLevel7,OperDoc7,OperAssistantFirst7,OperAssistantSecond7,OperAnaMethod7,OperAnaDoctor7,OperDict8,OperDate8,OperEndDate8,OperLevel8,OperDoc8,OperAssistantFirst8,OperAssistantSecond8,OperAnaMethod8,OperAnaDoctor8,OperDictLast,OperDateLast,OperEndDateLast,OperLevelLast,OperDocLast,OperAssistantFirstLast,OperAssistantSecondLast,OperAnaMethodLast,OperAnaDoctorLast)
	
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

/// ////////////////////////////////////////////////////////////////////////////////////////////////
/// Creator：	guozongtao
/// CreateDate：2015-05-21
/// Desc：		取首页数据绑定信息
/// Input:		Adm: 就诊rowid
/// Return：
/// Test:		do ##class(%ResultSet).RunQuery("EMR.OP.HISInterface.SystemData","GetFirstPageInfo","67")		
Query GetFirstPageInfo(Adm As %String) As %Query(ROWSPEC = "ProvinceNativeDict,ProvinceBirthDict,curProvinceDict,HukouProvinceDict,curStreet,HuKouStreet,AdmWayMono,AdmDailyLifeScore,DischDailyLifeScore,WorkAddress,IsCriticalcaseMono,IsDifficultcaseMono,DisReocrdDiag1Dict,DisReocrdDiag2Dict,DisReocrdDiag3Dict,DisReocrdDiag4Dict,DisReocrdDiag5Dict,DisReocrdDiag6Dict,DisReocrdDiag7Dict,DisReocrdDiag8Dict,DisReocrdDiag9Dict,DisReocrdDiag10Dict,DisReocrdDiag11Dict,DisReocrdDiag12Dict,DisReocrdDiag13Dict,ICUWardDesc1,ICUWardStart1,ICUWardEnd1,ICUWardDesc2,ICUWardStart2,ICUWardEnd2,ICUWardDesc3,ICUWardStart3,ICUWardEnd3,DirectorDict,AttendingDoctorDict,ResidentDoctorDict,FirstPageAgeYear,FirstPageAgeMonth,DepartmentHeaderDict,PrimaryNurseDict,DepartmentHeaderDesc,PathologicDiag1Dict,PathologicDiag2Dict,PathologicDiag3Dict,PathologicalNumber1,PathologicalNumber2,PathologicalNumber3")
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
	
	s Hospital=##class(EMR.DOC.BL.SysOption).GetOptionValueByName("HospitalName",..#ProductCode)
	// 登记RowId		[PapmiDR]			PA_Person.PAPER_RowId And PA_PatMas.PAPMI_PAPER_DR
 	s PapmiDR = ##Class(EMR.DOC.HISInterface.PatientInfoAssist).GetPapmiDR(Adm)


	// 籍贯				[Native]			PA_Person.PAPER_Province_Birth_DR And PA_Person.PAPER_CityBirth_DR
 	// 城市				[CityBirth]			PA_Person.PAPER_CityBirth_DR ->
 	// 省份				[ProvinceBirth]		PA_Person.PAPER_Province_Birth_DR ->
 	s tmpNative=##Class(EMR.DOC.HISInterface.PatientInfoAssist).Native(PapmiDR,Hospital)
	
   	// 籍贯省份 
	s tmpProvinceNative = $p($g(tmpNative),"!",1)
    s ProvinceNativeDict=tmpProvinceNative
	s ProvinceNativeDesc = $p(tmpProvinceNative,"^",3)
	i (ProvinceNativeDesc="北京市")||(ProvinceNativeDesc="天津市")||(ProvinceNativeDesc="上海市")||(ProvinceNativeDesc="重庆市")
	{
		s ProvinceNativeDict=$tr(ProvinceNativeDict,ProvinceNativeDesc,"─")
	}
	
	// 出生地
	s tmpBirthPlace=##Class(EMR.DOC.HISInterface.PatientInfoAssist).BirthPlaceNew(PapmiDR)
	
	// 出生地省份 
	s tmpProvinceBirth = $p($g(tmpBirthPlace),"!",1)
	s ProvinceBirthDict = tmpProvinceBirth
	s ProvinceBirthDesc = $p(ProvinceBirthDict,"^",3)
	i (ProvinceBirthDesc="北京市")||(ProvinceBirthDesc="天津市")||(ProvinceBirthDesc="上海市")||(ProvinceBirthDesc="重庆市")
	{
		s ProvinceBirthDict=$tr(ProvinceBirthDict,ProvinceBirthDesc,"─")
	}	
	
	 //现住址
 	s tmpcuraddr=##Class(EMR.DOC.HISInterface.PatientInfoAssist).ResidentAddressNew(PapmiDR,Hospital)
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
 	s tmpHuKou=##Class(EMR.DOC.HISInterface.PatientInfoAssist).HuKouAddressNew(PapmiDR,Hospital)
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
 	//&sql(SELECT AdmSource Into :AdmWayCode FROM SQLUser.DHCDocIPBooking WHERE EpisodeIDTo =:Adm )
 	s AdmSourWayID=$p(^PAADM(Adm),"^",10)
 	if (AdmSourWayID="")
 	{
	 	s AdmWayMono="9^其他"
	}else
	{
 	s admSourceCode=$p(^PAC("ADSOU",AdmSourWayID),"^",1)
 	s admSourceDesc=$p(^PAC("ADSOU",AdmSourWayID),"^",2)
	//s AdmWayMono=$s(AdmWayCode=1:"1^急诊",AdmWayCode=2:"2^门诊",AdmWayCode=3:"3^其他医疗机构转入",AdmWayCode=4:"9^其他",1:"9^其他")
	s AdmWayMono=admSourceCode_"^"_admSourceDesc
	}
	
	//日常生活能力评定、PDA接口
	s AdmDailyLifeScore="─",DischDailyLifeScore="─"
	//SELECT Item11,Item12,* FROM Nur.dhcmouddataSub WHERE RecParref->EpisodeId='10424980' AND RecParref->EmrCode='DHCNurPFB'
	&sql(SELECT Item12 Into :AdmDailyLifeScore FROM Nur.dhcmouddataSub WHERE RecParref->EpisodeId=:Adm AND RecParref->EmrCode='DHCNurPFB' and Item11="入院" )
	&sql(SELECT Item12 Into :DischDailyLifeScore FROM Nur.dhcmouddataSub WHERE RecParref->EpisodeId=:Adm AND RecParref->EmrCode='DHCNurPFB' and Item11="出院前" )

	
	//工作单位及地址
	s WorkAddress="─",tmpOccupation="",tmpOccupationDesc=""
	s tmpOccupation=##Class(EMR.DOC.HISInterface.PatientInfoAssist).Occupation(PapmiDR,Hospital)
 	s WorkAddress=##Class(EMR.DOC.HISInterface.PatientInfoAssist).WorkAddress(PapmiDR,Hospital)
 	
	s tmpOccupationDesc=$p($g(tmpOccupation),"^",3)
	
	s:(tmpOccupationDesc="农民")||(tmpOccupationDesc="退休")||(tmpOccupationDesc="无业人员")||(WorkAddress="") WorkAddress="─"
	
	
	//病危病历，入院途径为急诊、死亡病例、MICU、ICU、CCU、NICU患者默认为1.是
	s IsCriticalcaseMono="2^否",IsDeadPat="",TransDept="",DeathDateTime=""
	s TransDept=##Class(EMR.DOC.HISInterface.PatientInfoAssist).TransDept(Adm)
	s DeathDateTime=##class(EMR.DOC.HISInterface.PatientInfoAssist).DeathDateTime(Adm,PapmiDR)
	s:(DeathDateTime'="") IsDeadPat="Y" 
	s:(AdmWayMono="1^急诊") IsCriticalcaseMono="1^是"
	s:(IsDeadPat="Y") IsCriticalcaseMono="1^是"
	s:(TransDept["CU") IsCriticalcaseMono="1^是"
	
	//疑难病历，有申请多科会诊、专业组查房记录的默认为1.是
	s IsDifficultcase="",IsDifficultcaseMono=""
	&sql(SELECT CONTYPE into :IsDifficultcase FROM SQLUser.dhc_consultation WHERE Adm =:Adm AND CONTYPE="M" )
	s IsDifficultcaseMono=$s(IsDifficultcase="M":"1^是",1:"2^否")
	s AllTitles=##class(EMR.DOC.HISInterface.PatientInfoAssist).GetAllInstanceTitles(Adm)
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
	s (TransICUInfo1,TransICUInfo2,TransICUInfo3,ICUWardDesc1,ICUWardStart1,ICUWardEnd1,ICUWardDesc2,ICUWardStart2,ICUWardEnd2,ICUWardDesc3,ICUWardStart3,ICUWardEnd3)=""
	
	s ICUInAndOutTimes=##class(EMR.DOC.HISInterface.PatientInfoAssist).TransDeptDetailInCludeICU(Adm)
 
	 If (ICUInAndOutTimes'="")
	 {
		d GetICUInAndOutTime1
		d GetICUInAndOutTime2
		d GetICUInAndOutTime3
 
	 }
	
	
	// (用以计算年龄)入院日期时间	[AdmDateTime]		PAAdm_AdmDate And PAAdm_AdmTime 
	s AdmDate = "", AdmTime = ""
	s AdmDateTime=##class(EMR.DOC.HISInterface.PatientInfoAssist).AdmDateTime(Adm,Hospital)
	if AdmDateTime'="" 
	{ 
		   // 入院日期内部格式
		   s AdmDate = $P($G(AdmDateTime),",",1)
		   // 入院时间内部格式 
		   s AdmTime = $P($G(AdmDateTime),",",2)
	}
	  
   	//调用年龄统一接口 [Age]
   	s Age=##class(EMR.DOC.HISInterface.PatientInfoAssist).Age(PapmiDR,Adm,AdmDate,AdmTime)
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
    
	s (DirectorDict,AttendingDoctorDict,ResidentDoctorDict)=""
	
	s DepartmentHeaderDict=##class(EMR.DOC.HISInterface.PatientInfoAssist).GetDepartmentHeader(Adm)
	s DepartmentHeaderDesc=$p(DepartmentHeaderDict,"^",3)
	s PrimaryNurseDict = ##class(EMR.DOC.HISInterface.PatientInfoAssist).GetPrimaryNurse(Adm)
	
	
	//获取病理诊断/病理号 绑定数据
	s pathologicDiag1=""
	s PathologicalNumber1 = ""
	
	s pathologicDiag2=""
	s PathologicalNumber2 = ""
	
	s pathologicDiag3=""
	s PathologicalNumber3 = ""
	
	s pathologicalIndex = 1 
	zn "PIS"
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
	
	
	set ^CacheTemp(repid, ind) = $LB(ProvinceNativeDict,ProvinceBirthDict,curProvinceDict,HukouProvinceDict,curStreet,HuKouStreet,AdmWayMono,AdmDailyLifeScore,DischDailyLifeScore,WorkAddress,IsCriticalcaseMono,IsDifficultcaseMono,DisReocrdDiag1Dict,DisReocrdDiag2Dict,DisReocrdDiag3Dict,DisReocrdDiag4Dict,DisReocrdDiag5Dict,DisReocrdDiag6Dict,DisReocrdDiag7Dict,DisReocrdDiag8Dict,DisReocrdDiag9Dict,DisReocrdDiag10Dict,DisReocrdDiag11Dict,DisReocrdDiag12Dict,DisReocrdDiag13Dict,ICUWardDesc1,ICUWardStart1,ICUWardEnd1,ICUWardDesc2,ICUWardStart2,ICUWardEnd2,ICUWardDesc3,ICUWardStart3,ICUWardEnd3,DirectorDict,AttendingDoctorDict,ResidentDoctorDict,FirstPageAgeYear,FirstPageAgeMonth,DepartmentHeaderDict,PrimaryNurseDict,DepartmentHeaderDesc,PathologicDiag1Dict,PathologicDiag2Dict,PathologicDiag3Dict,PathologicalNumber1,PathologicalNumber2,PathologicalNumber3)
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

/// Desc:  调试命令
/// Debug: d ##Class(EMR.OP.HISInterface.SystemData).test("EMR.OP.HISInterface.SystemData:GetPatientInfo")
ClassMethod test(aClassMethod As %String)
{
	s strRes = "-1"
	q:(aClassMethod="") strRes
	s strClass = $p(aClassMethod,":",1)
	s strMethod = $p(aClassMethod,":",2)
	s strMethodQuery = strClass_"||"_strMethod
	s classExist = ##class(%Dictionary.CompiledClass).%ExistsId(strClass)
	s methodQuery = ##class(%Dictionary.CompiledQuery).%ExistsId(strMethodQuery)
	;s methodExist =##class(%Dictionary.CompiledMethod).%Exists(strClass_"||"_strMethod)
	q:(methodQuery="0") strRes
	s obj = ##class(%Dictionary.CompiledQuery).%OpenId(strMethodQuery)
	q:(obj="") strRes
	s cnt=$ll(obj.ColNames)
	for i=1:1:cnt 
	{
		s colName=$listget(obj.ColNames,i) 
	    w colName_","
	}
}

/// 获取数据
/// Debug: d ##Class(EMR.OP.HISInterface.SystemData).TestGetValue("1","67")
ClassMethod TestGetValue(aBindQueryID As %String, params As %String)
{
	s strRes = "-1"
	s objBindQuery = ##class(CF.EMR.DOC.BindQuery).%OpenId(aBindQueryID)
	q:(objBindQuery="") strRes
	s stramMessage = ##Class(%GlobalBinaryStream).%New()
	s className = $p(objBindQuery.QueryName,":",1)
	s queryName = $p(objBindQuery.QueryName,":",2)
	s strMethodQuery = className_"||"_queryName
	s classExist = ##class(%Dictionary.CompiledClass).%ExistsId(className)
	s methodQuery = ##class(%Dictionary.CompiledQuery).%ExistsId(strMethodQuery)
	q:(methodQuery="0") strRes
	s obj = ##class(%Dictionary.CompiledQuery).%OpenId(strMethodQuery)
	q:(obj="") strRes
	s colCount=$ll(obj.ColNames)
	q:(colCount<1) strRes

	
	
	s resultDataSet = ..GetDataByQueryName(className,queryName,params)
	s:(resultDataSet = "") errorMessage = errorMessage_className_"|"_queryName_"^"
    q:(resultDataSet = "")
	While resultDataSet.Next() 
	{
		for i=1:1:colCount
		{
			
			s colCode=$listget(obj.ColNames,i) 
			continue:(colCode = "")
			s value = resultDataSet.GetDataByName(colCode)
			s strName = $o(^CF.EMR.DOC.BindFieldI("IdxQueryFName",aBindQueryID," "_$zcvt(colCode,"U"),""))
			continue:(strName="")
			;s value = $ZCVT(value,"O","UTF8")
			s json = ""
			s json = "{""Code"":"""_colCode_""",""Name"":"""_strName_""",""Value"":"""_value_"""}"
			
			d stramMessage.Write(json)
		}
	}
	d stramMessage.OutputToDevice()
}

/// Desc:       取数据信息
/// Creator:    Candy
/// CreateDate: 2014-3-13  
/// Input:      AClassName 类名
///             AQueryName 参数名
/// OutPut:     query数据集合
/// Debug: d ##Class(EMR.OP.HISInterface.SystemData).GetDataByQueryName("EMR.OP.HISInterface.SystemData","GetPatientInfo","67")
ClassMethod GetDataByQueryName(AClassName As %String, AQueryName As %String, AParameterS As %String) As %ResultSet
{
	s $ZT="ERROR"
	s tempNameSpace = $namespace
	s result = ##class(%ResultSet).%New()
	s result.ClassName = AClassName
	s result.QueryName = AQueryName
	if (AParameterS="")
	{
		d result.Execute() 
		q result
	}
	elseif (AParameterS'="") 	 
	{
		s ParaCount = $LENGTH(AParameterS,",")

		q:(ParaCount>10) 
		if (ParaCount=1)	 
		{
			d result.Execute($P(AParameterS,",",1))
		}
		elseif (ParaCount=2)	 
		{
			d result.Execute($P(AParameterS,",",1),$P(AParameterS,",",2))  
		}	 
		elseif (ParaCount=3)	 
		{
			d result.Execute($P(AParameterS,",",1),$P(AParameterS,",",2),$P(AParameterS,",",3))  
		}	 
		elseif (ParaCount=4)	 
		{
			d result.Execute($P(AParameterS,",",1),$P(AParameterS,",",2),$P(AParameterS,",",3),$P(AParameterS,",",4))  
		}	 
		elseif (ParaCount=5)	 
		{
			d result.Execute($P(AParameterS,",",1),$P(AParameterS,",",2),$P(AParameterS,",",3),$P(AParameterS,",",4),$P(AParameterS,",",5))  
		}	 
		elseif (ParaCount=6)	 
		{
			d result.Execute($P(AParameterS,",",1),$P(AParameterS,",",2),$P(AParameterS,",",3),$P(AParameterS,",",4),$P(AParameterS,",",5),$P(AParameterS,",",6))  
		}	 
		elseif (ParaCount=7)	 
		{
			d result.Execute($P(AParameterS,",",1),$P(AParameterS,",",2),$P(AParameterS,",",3),$P(AParameterS,",",4),$P(AParameterS,",",5),$P(AParameterS,",",6),$P(AParameterS,",",7))  
		}	 
		elseif (ParaCount=8)	 
		{
			d result.Execute($P(AParameterS,",",1),$P(AParameterS,",",2),$P(AParameterS,",",3),$P(AParameterS,",",4),$P(AParameterS,",",5),$P(AParameterS,",",6),$P(AParameterS,",",7),$P(AParameterS,",",8))  
		}	 
		elseif (ParaCount=9)	 
		{
			d result.Execute($P(AParameterS,",",1),$P(AParameterS,",",2),$P(AParameterS,",",3),$P(AParameterS,",",4),$P(AParameterS,",",5),$P(AParameterS,",",6),$P(AParameterS,",",7),$P(AParameterS,",",8),$P(AParameterS,",",9))  
		}	 
		elseif (ParaCount=10)	 
		{
			d result.Execute($P(AParameterS,",",1),$P(AParameterS,",",2),$P(AParameterS,",",3),$P(AParameterS,",",4),$P(AParameterS,",",5),$P(AParameterS,",",6),$P(AParameterS,",",7),$P(AParameterS,",",8),$P(AParameterS,",",9),$P(AParameterS,",",10))  
		}
		q result
	}
ERROR
	s:($namespace '= tempNameSpace) $namespace = tempNameSpace					 	        
	q ""
}

}
