Class web.DHCBL.CARD.UCardPaPatMasInfo Extends (DHCDoc.Util.RegisteredObject, %XML.Adaptor, websys.Abstract) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

Parameter BUILD = 159;

/// 通过身份证号得到其他卡类型的唯一登记号时返回
/// 返回:标识^登记号/错误信息;标识为0则正确,其他为错误
/// w ##class(web.DHCBL.CARD.UCardPaPatMasInfo).GetPatIdByCardID("",310234197601013214,2,"")
ClassMethod GetPatIdByCardID(CredTypeDR As %Library.String, CardID As %Library.String, CardType As %String, CardNo As %String) As %String
{
	;n (CardID,CardType,CardNo)
	i CredTypeDR=$C(0) s CredTypeDR=""
	i CardID=$C(0) s CardID=""
	i CardType=$C(0) s CardType=""
	i CardNo=$C(0) s CardNo=""
	
	s myrtn=0
	s FindSum=0
	s findPapmiDr=""
	s myPAID=$ZConvert(CardID, "U")
	s myPAPMIDR=0
	f  s myPAPMIDR=$o(^PAPERi("DVA",myPAID,myPAPMIDR))  q:(myPAPMIDR="")  d
	.;同一证件类型才成
	.s myCredTypeDR=$p(^PAPER(myPAPMIDR,"PAT",3),"^",7)
	.q:(CredTypeDR'="")&&(CredTypeDR'=myCredTypeDR)
	.s myCardTypeDR=0
	.f  s myCardTypeDR=$o(^DHCCARDi("CF",0,"PAPMICTDR",myPAPMIDR ,myCardTypeDR)) q:(myCardTypeDR="")  d
	..s myIDUniqueFlag=$p($g(^DHCCARDTYPEDef(myCardTypeDR)),"^",30)		;CTD_ValidateMode
	..;同一种卡类型的不判断
	..q:(CardType'="")&&(myCardTypeDR=CardType)
	..s CFCardID=0
	..f  s CFCardID=$O(^DHCCARDi("CF",0,"PAPMICTDR",myPAPMIDR ,myCardTypeDR,CFCardID)) q:(CFCardID="")||(findPapmiDr'="")  d
	...s ActiveFlag=$p(^DHCCARD("CF",CFCardID),"^",10)
	...q:(" D R ")[(" "_ActiveFlag_" ")
	...s PapmiDr=$p($g(^DHCCARD("CF",CFCardID)),"^",4)
	...s PapmiNo=$p($g(^DHCCARD("CF",CFCardID)),"^",6)
	...s findPapmiDr=PapmiDr
	.s FindSum=FindSum+1
	
	;仅找到唯一的其他卡类型的病人rowid
	i (FindSum=1)&&(findPapmiDr'="") {
		s myrtn=0_"^"_PapmiDr
		q myrtn
	}else {
		if FindSum>1 {
			s myrtn="-2"_"^"_"存在多个病人"
			q myrtn
		}else{
			s myrtn="-1"_"^"_"未找到唯一的病人"
			q myrtn
		}
	}
}

/// 通过登记号码获取患者基本信息
/// 为了与卡建立对照提供帮助
/// 或者使用 身份证号获取 到登记号码， 再查询的数据
/// d ##class(web.DHCBL.CARD.UCardPaPatMasInfo).GetPatInfoByPANo("0000000013","")
ClassMethod GetPatInfoByPANo(PAPMINo As %Library.String = "", ExpStr As %String) As %String
{
    
    ;0000000284
	;n (PAPMINo, ExpStr)
	
	s (id,code,desc)=""
	s logonHospID=%session.Get("LOGON.HOSPID")
	s myrtn=0
 	s myXMLStr=""
	s myregobj=##class(web.DHCEntity.PCA.CardPatInfoReg).%New()
	s paraCredNo="",IsNeedRegMedicalEPMI=""
	if (ExpStr'=""){
		s paraCredNo=$p(ExpStr,"^",1)
		s paraCredNo=$ZConvert(paraCredNo_"Z","U")
		s IsNeedRegMedicalEPMI=$p(ExpStr,"^",2)
	}
	if (paraCredNo'="")&&(PAPMINo=""){
		s myregobj=..ChangeNullValue(myregobj)
		s ExistPAPMIRowID=$o(^PAPERi("PAPMI_ICPPBC",paraCredNo,""))
		if (ExistPAPMIRowID'=""){
			s myregobj.PAPMIRowID=ExistPAPMIRowID
		 	d myregobj.XMLExportToString(.myXMLStr)
			q 0_"^"_myXMLStr
		}
		
	}
 	;##class(web.DHCBL.CARD.UCardPaPatMasInfo).GetPatInfoByPANo("00000007","")
 	i PAPMINo=""{
	 	s myregobj=..ChangeNullValue(myregobj)
	 	d myregobj.XMLExportToString(.myXMLStr)
		q 0_"^"_myXMLStr
 	}
	s RName="",myPAPMIDR=""
	s PAPMINo=$g(PAPMINo)
	;优先判定此登记号是否被合并
	s NewPatNo=##class(web.DHCPATCardUnite).GetCardUnitNewByOld(PAPMINo)
	if (NewPatNo'="") {
		Q "2002"_"^"_NewPatNo
	}
	s PAPMFlag=2001			;无此登记号的病人
	s myAccSFlag=0			;账户状态
	;加入办理卡是，判断此登记号是否存在有效帐户
	s PapmiRowid=0
	f  s PapmiRowid=$o(^PAPERi("PAPMI_PatNo",$ZCVT(PAPMINo,"U"),PapmiRowid)) q:PapmiRowid=""  d
	.s RName=$p($g(^PAPER(PapmiRowid,"ALL")),"^",1)
	.q:$P(^PAPER(PapmiRowid,"PAT",1),"^",6)="N"
	.s PatientDOB=$p($g(^PAPER(PapmiRowid,"ALL")),"^",6)
	.s RBirth=..%ZD(PatientDOB) //$ZD(PatientDOB,3)
	.;调用标准库统一接口
	.s Age=##class(web.DHCDocInterfaceMethod).DHCDocHisInterface("doc.reg.GetPapmiAge",PapmiRowid,"",logonHospID)
    .s RAgeYear=Age
	.s RIDCardNo=$p($g(^PAPER(PapmiRowid,"ALL")),"^",9)
	.s sexid=$p($g(^PAPER(PapmiRowid,"ALL")),"^",7)
	.s RSex=$p($g(^CT("SEX",sexid)),"^",2)
	.s RId=$p($g(^PAPER(PapmiRowid,"PAT",1)),"^",2) ;IP_No
	.s RCredType=$p($g(^PAPER(PapmiRowid,"PAT",3)),"^",7)  ;PAPMI_CardType_DR
	.s RCredNo=$p($g(^PAPER(PapmiRowid,"PAT",3)),"^",6)  ;PAPMI_DVAnumber
	.s RTelNo=$p($g(^PAPER(PapmiRowid,"PER",1)),"^",11) ;pa_person.paper_telh
	.s RMobPhone=$p($g(^PAPER(PapmiRowid,"PER",4)),"^",21)   ;pa_patmas.PAPMI_MobPhone
	.s RInMedicare=##class(DHCWMR.IO.OutService).IGetMrNoByPatientID(PapmiRowid,"I",logonHospID) ;pa_patmas.papmi_medicare
	.s ROpMedicare=##class(DHCWMR.IO.OutService).IGetMrNoByPatientID(PapmiRowid,"O",logonHospID) ;paper_governcardno
	.s soc=""
	.s RPatType=""
	.s socialstatus=$p($g(^PAPER(PapmiRowid,"PER",1)),"^",10) 
	.i socialstatus'="" d
	..s RPatType=$p($g(^CT("SS",socialstatus)),"^",2)      ;paper_socialstatus_dr->ss_desc
    .s RCompany=$p($g(^PAPER(PapmiRowid,"PER",4)),"^",18) 
    .s RAddress=$p($g(^PAPER(PapmiRowid,"PER","ADD",1)),"^",1)
	.s PatYBCode=$p($g(^PAPER(PapmiRowid,"PAT",3)),"^",12)
	.s myPAPMIDR=PapmiRowid
	.s PAPMFlag=0
	.s myAccRowID=0
	
	.s ForeignName=$p($g(^PAPER(PapmiRowid,"PER",2)),"^",13)
	.s CTRelationDR=$p($g(^PAPER(PapmiRowid,"EMP")),"^",4)
	.//工号
	.s EmployeeNo=$p($g(^PAPER(PapmiRowid,"EMP")),"^",5) 
	.//合同单位
	.s HCPDR=$p($g(^PAPER(PapmiRowid,"PER",4)),"^",17) 
	.//公医证号
	.s InsurCardNo=$P($G(^PAPER(PapmiRowid,"DHCINS")),"^",2)
	.//费别
	.s AdmReason=$P($G(^PAPER(PapmiRowid,"DHCINS")),"^",3)
	.//职业 PAPEROccupationDR
	.s Vocation=$p($g(^PAPER(PapmiRowid,"PER",2)),"^",6)
	.//联系人身份证号  PAPERForeignCountry
	.s ForeignIDCard=$p($g(^PAPER(PapmiRowid,"PER",2)),"^",4)
	.//联系人证件类型
	.s ForeignCredType=$p($g(^PAPER(PapmiRowid,"ALL")),"^",25)
	.//PAPER_StayingPermanently  是否专程来京就诊
	.s AdmSource=$p($g(^PAPER(PapmiRowid,"PER",5)),"^",10)
	.i AdmSource="Y" d
	..s AdmSource=1
	.e  d
	..s AdmSource=0
	.//PAPER_ForeignPhone  联系人电话
	.s ForeignPhone=$p($g(^PAPER(PapmiRowid,"ALL")),"^",4)
	.//PAPER_Marital_DR   婚姻状况
	.s PAPERMarital=$p($g(^PAPER(PapmiRowid,"PER",2)),"^",3)
	.//PAPER_SecondPhone 工作单位
	.s Company=$p($g(^PAPER(PapmiRowid,"PER",4)),"^",18)
	.//PAPER_ForeignCity  行政区域
	.s HealthCareRegion=$p($g(^PAPER(PapmiRowid,"ALL")),"^",5)
	.//PAPMI_VIPFlag  协和国际医疗部标志
	.s VIPFlag=$p($g(^PAPER(PapmiRowid,"PAT",4)),"^",1)
	.i VIPFlag="Y" d
	..s VIPFlag=1
	.e  d
	..s VIPFlag=0
	
	.s BloodType=$p($g(^PAPER(PapmiRowid,"PER",5)),"^",32)
	.;s CompanyPostCode=$p($g(^PAPER(PapmiRowid,"ALL")),"^",22)
	.s ForeignAddress=$p($g(^PAPER(PapmiRowid,"PER",1)),"^",1)
	.s ForeignPostCode=$p($g(^PAPER(PapmiRowid,"PER",2)),"^",8)
	.s GPOrgAddress=$g(^PAPER(PapmiRowid,"GPA",1))
	.s AreaHome=$P($g(^PAPER(PapmiRowid,"PER",6)),"^",41)
	.s (BirthPlace,HomePlace,HouseArea,PostCode,RegisterPlace,CompanyPostCode)=""
	.s (ProvinceBirth,CityBirth,AreaBirth,AddressBirth,ProvinceHouse,Cityhouse,AreaHouse,PostCodeHouse)=""
	.;s BirthPlace=$P($G(^PAPER(PapmiRowid ,"DHC")),"^",2)
	.;s HomePlace=$P($G(^PAPER(PapmiRowid ,"DHC")),"^",32)
	.;s HouseArea=$P($G(^PAPER(PapmiRowid ,"DHC")),"^",34)
	.;获取base64照片信息
	.s PhotoInfo=$p($g(^PAPER(PapmiRowid,"PER",6)),"^",5)
	.;s PostCode=$P($G(^PAPER(PapmiRowid ,"DHC")),"^",31)
	.;s RegisterPlace=$P($G(^PAPER(PapmiRowid ,"DHC")),"^",33)
	.s DHCPersonID=$O(^DHCPERSON(0,"PAPERSON",PapmiRowid,0))
	.i DHCPersonID'="" d
	..s BirthPlace=$P(^DHCPERSON(DHCPersonID),"^",16)
	..s HomePlace=""
	..s HouseArea=""
	..s PostCode=$P(^DHCPERSON(DHCPersonID),"^",8)
	..s RegisterPlace=$P(^DHCPERSON(DHCPersonID),"^",20)
	..s CompanyPostCode=$P(^DHCPERSON(DHCPersonID),"^",7)
	..s ProvinceBirth=$P(^DHCPERSON(DHCPersonID),"^",13)
	..s CityBirth=$P(^DHCPERSON(DHCPersonID),"^",14)
	..s AreaBirth=$P(^DHCPERSON(DHCPersonID),"^",15)
	..s AddressBirth=$P(^DHCPERSON(DHCPersonID),"^",16)
	..s ProvinceHouse=$P(^DHCPERSON(DHCPersonID),"^",17)
	..s Cityhouse=$P(^DHCPERSON(DHCPersonID),"^",18)
	..s AreaHouse=$P(^DHCPERSON(DHCPersonID),"^",19)
	..s PostCodeHouse=$P(^DHCPERSON(DHCPersonID),"^",9)
	.s ProvinceHome=$p($g(^PAPER(PapmiRowid,"PER",2)),"^",11)
	.s CityHome=$p($g(^PAPER(PapmiRowid,"ALL")),"^",18)
	.s NationDesc=$p($g(^PAPER(PapmiRowid,"PER",2)),"^",1)
	.s CountryDesc=$p($g(^PAPER(PapmiRowid,"PER",1)),"^",8)
	.s ProvinceInfo=$p($g(^PAPER(PapmiRowid,"PER",4)),"^",2)
	.s TelOffice=$p($g(^PAPER(PapmiRowid,"PER",1)),"^",9)
	
	.s Allergy=$g(^PAPER(PapmiRowid,"ALLERGY",1)) ;ALLERGY
	.s CityDesc=$p($g(^PAPER(PapmiRowid,"PER",1)),"^",5)
	.s CityArea=$p($g(^PAPER(PapmiRowid,"PER",4)),"^",9)
	.s EMail=$p($g(^PAPER(PapmiRowid,"PER",4)),"^",19)
	.s Zip=$p($g(^PAPER(PapmiRowid,"PER",1)),"^",7)
	.s PAPMIEducation=$p($g(^PAPER(PapmiRowid,"PER",4)),"^",30)
	.s PAPMILangPrimDR=$p($g(^PAPER(PapmiRowid,"ALL")),"^",10)
	.;s MedicalCardNo=""
	.;^DHCACDi("AccM",0,"PAPMI",{AccM_PAPMI_DR},{AccM_RowID})
	.;f  s myAccRowID=$o(^DHCACDi("AccM",0,"PAPMI",myPAPMIDR, myAccRowID)) q:((myAccRowID="")!(+myAccSFlag=2003))  d
	.;.q:($d(^DHCACD("AccM",myAccRowID))=10)
	.s EmployeeFunctionDR=$p($g(^PAPER(PapmiRowid,"PER",3)),"^",3)
	.s PAPMISecretLevelDR=$p($g(^PAPER(PapmiRowid,"DHC")),"^",30)
	.s BirthTime=$p($g(^PAPER(PapmiRowid,"DHC")),"^",1)
	.i BirthTime'="" s BirthTime=..%ZT(BirthTime,1)
	.s PAPMILangSecondDR=$p($g(^PAPER(PapmiRowid,"PAT",2)),"^",4)
	.s StreetBirth=$p($g(^PAPER(PapmiRowid,"DHC")),"^",52)
	.s StreetHouse=$p($g(^PAPER(PapmiRowid,"DHC")),"^",53)
	.s StreetNow=$p($g(^PAPER(PapmiRowid,"DHC")),"^",54)
	.//国籍/地区(现住)
	.s CountryHouse=$p($g(^PAPER(PapmiRowid,"ALL")),"^",11)
	.//国籍/地区(籍贯)
	.s CountryHome=$p($g(^PAPER(PapmiRowid,"PER",5)),"^",12)
	.//国籍/地区(出生)
	.s CountryBirth=$p($g(^PAPER(PapmiRowid,"ALL")),"^",26)
	
	if (myPAPMIDR=""){
		q "2001"
	}
	
	s myregobj.Name=$g(RName)
	;s myregobj.PAPMINo= $g()
	s myregobj.AreaHome=$G(AreaHome)
	s myregobj.StreetBirth=$G(StreetBirth)
	s myregobj.StreetHouse=$G(StreetHouse)
	s myregobj.StreetNow=$G(StreetNow)
	s myregobj.PAPMILangPrimDR=$G(PAPMILangPrimDR)
	s myregobj.PAPMILangSecondDR=$G(PAPMILangSecondDR)
	s myregobj.Education=$G(PAPMIEducation)
	s myregobj.PAPMIRowID=$g(myPAPMIDR)
	s myregobj.Birth= $g(RBirth)
	s myregobj.Age=$g(RAgeYear)
	s myregobj.Sex = $g(sexid)
	s myregobj.PAPMINo =$g(PAPMINo)
	s myregobj.Address=$g(RAddress)
	s myregobj.PatType=$g(socialstatus)
	s myregobj.EmployeeCompany=$g(RCompany)
	s myregobj.InMedicare=$g(RInMedicare)
	s myregobj.OpMedicare=$g(ROpMedicare)
	s myregobj.MobPhone=$g(RMobPhone)
	s myregobj.TelHome=$g(RTelNo)
	s myregobj.CredType=$g(RCredType)
	s myregobj.CredNo=$g(RCredNo)
	s myregobj.ForeignName=$g(ForeignName)
	s myregobj.CTRelationDR=$g(CTRelationDR)
	//工号
	s myregobj.EmployeeNo=$g(EmployeeNo)
	//合同单位
	s myregobj.HCPDR=$g(HCPDR)
	//费别
	s myregobj.AdmReason=$G(AdmReason)
	//公医证号
	s myregobj.InsurCardNo=$G(InsurCardNo)
	//职业 PAPEROccupationDR
	s myregobj.Vocation=$g(Vocation)
	//联系人身份证号  PAPERForeignCountry
	s myregobj.ForeignIDCard=$g(ForeignIDCard)
	s myregobj.ForeignCredType=$g(ForeignCredType)
	//PAPER_StayingPermanently  是否专程来京就诊
	s myregobj.AdmSource=$g(AdmSource)
	//PAPER_ForeignPostCode  联系人电话
	s myregobj.ForeignPhone=$g(ForeignPhone)
	//PAPER_Marital_DR   婚姻状况
	s myregobj.PAPERMarital=$g(PAPERMarital)
	//PAPER_SecondPhone 工作单位
	s myregobj.Company=$g(Company)
	//PAPER_ForeignCity  行政区域
	s myregobj.HealthCareRegion=$g(HealthCareRegion)
	//PAPMI_VIPFlag 
	s myregobj.VIPFlag=$g(VIPFlag)
	//出生地
	s myregobj.BirthPlace=$G(BirthPlace)
	//血型
	s myregobj.BloodType=$G(BloodType)
	//工作单位邮编
	s myregobj.CompanyPostCode=$G(CompanyPostCode)
	//联系人地址
	s myregobj.ForeignAddress=$G(ForeignAddress)
	//联系人邮编
	s myregobj.ForeignPostCode=$G(ForeignPostCode)
	//初诊科室
	s myregobj.GPOrgAddress=$G(GPOrgAddress)
	//籍贯
	s myregobj.HomePlace=$G(HomePlace)
	//家庭所在地区
	s myregobj.HouseArea=$G(HouseArea)
	//照片信息Base64编码串 导入联众数据使用
	s myregobj.PhotoInfo=$G(PhotoInfo)
	//非代码表邮编
	s myregobj.PostCode=$G(PostCode)
	//户口地址
	s myregobj.RegisterPlace=$G(RegisterPlace)
	
	//国(籍贯)
	s myregobj.CountryHome=$G(CountryHome) //..GetCountryByProvice($G(ProvinceHome))
	//省(籍贯)
	s myregobj.ProvinceHome=$G(ProvinceHome)
	//市(籍贯)
	s myregobj.CityHome=$G(CityHome)
	//国(出生)
	s myregobj.CountryBirth=$G(CountryBirth) //..GetCountryByProvice($G(ProvinceBirth))
	//国(住地)
	s myregobj.CountryHouse=$G(CountryHouse) //..GetCountryByProvice($G(ProvinceInfo))
	//省(出生)
	s myregobj.ProvinceBirth=$G(ProvinceBirth)
	//市(出生)
	s myregobj.CityBirth=$G(CityBirth)
	//县(出生)
	s myregobj.AreaBirth=$G(AreaBirth)
	//地址(出生)
	s myregobj.AddressBirth=$G(AddressBirth)
	//省(户口)
	s myregobj.ProvinceHouse=$G(ProvinceHouse)
	//市(户口)
	s myregobj.Cityhouse=$G(Cityhouse)
	//县(户口)
	s myregobj.AreaHouse=$G(AreaHouse)
	//邮编(户口)
	s myregobj.PostCodeHouse=$G(PostCodeHouse)
	
	//民族
	s myregobj.NationDesc=$G(NationDesc)
	s myregobj.NationDescLookUpRowID=$G(NationDesc)
	//国籍
	s myregobj.CountryDesc=$G(CountryDesc)
	s myregobj.CountryDescLookUpRowID=$G(CountryDesc)
	//省份
	s myregobj.ProvinceInfo=$G(ProvinceInfo)
	s myregobj.ProvinceInfoLookUpRowID=$G(ProvinceInfo)
	//单位电话
	s myregobj.TelOffice=$G(TelOffice)
	
	s myregobj.Allergy=$G(Allergy) ;ALLERGY
	s myregobj.CityDesc=$G(CityDesc)
	s myregobj.CityDescLookUpRowID=$G(CityDesc)
	s myregobj.CityArea=$G(CityArea)
	s myregobj.CityAreaLookUpRowID=$G(CityArea)
	s myregobj.EMail=$G(EMail)
	s myregobj.Zip=$G(Zip)
	;s MedicalCardNo=""
	s myregobj.PoliticalLevel=$g(EmployeeFunctionDR)
	s myregobj.SecretLevel=$g(PAPMISecretLevelDR)
	//Set patmas = ##class(User.PAPatMas).%OpenId(myPAPMIDR)
	s myregobj.PatYBCode= $G(PatYBCode)
	s myregobj.BirthTime=$g(BirthTime)
	s OtherCredInfo=##class(web.DHCBL.Patient.DHCPatient).GetOtherCredInfo(myPAPMIDR)
	s OtherNameInfo=..GetOtherName(myPAPMIDR)
	s OtherNameInfo=$TR(OtherNameInfo,"^","@")
	s myregobj.OtherNameInfo=OtherNameInfo
	s OtherCredInfo=$TR(OtherCredInfo,"^","@")
	s myregobj.OtherCardInfo=OtherCredInfo
	//d patmas.%Close()
	if IsNeedRegMedicalEPMI="1" {
		d ..GetRegMedicalEPMI(.myregobj,PAPMINo)
	}
	
	s myregobj=..ChangeNullValue(myregobj)
	d myregobj.XMLExportToString(.myXMLStr)
	s myrtn= PAPMFlag
	
	q PAPMFlag_"^"_myXMLStr
}

/// 在修改患者信息时修改卡表信息,目前只针对于临时卡状态修改
/// 
/// 分为: 新增或者 更新
ClassMethod UpdateCardInfo(CardInfo As %String) As %String
{
	s myCardObj=##class(web.DHCEntity.PCA.CardRef).%New()
	d myCardObj.XMLNodeDeserialize(.myCardObj,"CardRef", CardInfo)
	s CardTypeDr=myCardObj.CardTypeDefine
	s CardNo=myCardObj.CardNo
	q:(CardTypeDr="")!(CardNo="") "-100"
	s CardRowID=$o(^DHCCARDi("CF",0,"CardTypeNo",CardTypeDr,CardNo,0))
	q:CardRowID="" "-3411"
	Set cf = ##class(User.DHCCardRef).%OpenId(CardRowID)
	if cf {
		s:myCardObj.TemporaryCard'="" cf.CFIsTemporaryCard=myCardObj.TemporaryCard
	}
	set ret=cf.%Save()
	Q 0
}

/// 保存患者基本信息
/// 分为: 新增或者 更新
ClassMethod SavePatInfo(PatObj As web.DHCEntity.PCA.PATMAS) As %String
{
  
	;s $ZT="ERROR^DHCSSERR"
	;需要保存 PA_PatMas
	;此处保存的都是患者基本的信息
	;对于其他信息需要一个更新过程接口
	;n (PatObj)
	s myrtn=0
	s PAPMIRowID=""
	s myNewFlag=0	;是新增,还是Update 标志
	s PrePatTypeId=""
	set OldDataObject=""
	set OldDataJson=""
	s myBirth=""
	s Vnull=$C(0)
	if (PatObj.Birth'="") {
		;;如果为空默认当前日期
		i PatObj.Birth["-" d  s myBirth=$zdh(PatObj.Birth,3)
		i PatObj.Birth["/" d  s myBirth=$zdh(PatObj.Birth,4)
	}
	
		b	;;获取是否已经生成Person的Id
		Set PatRowId = PatObj.PAPMIRowID
		;通过身份证关联唯一的病人
		if PatRowId="" {
			;s PatIdStr=..GetPatIdByCardID(PatObj.CredType,PatObj.CredNo,"","")
			;i $p(PatIdStr,"^")=0 s PatRowId=$p(PatIdStr,"^",2)
		}
		;s OldPatInfo=""
		;使用RowID来决定是否 更新和新增
		if ((PatRowId = "")||(PatRowId=$c(0)))
		{
			Set person = ##class(User.PAPerson).%New()
			s myNewFlag=1
			
		}
		else
		{
			Set person = ##class(User.PAPerson).%OpenId(PatRowId)
 			i $IsObject(person.PAPERSocialStatusDR) s PrePatTypeId=person.PAPERSocialStatusDR.%Id()
			s myNewFlag=0
			;s OldPatInfo=##class(web.DHCBL.Patient.DHCPatientBuilder).SearchPatInfoByRowID(PatRowId)
			set OldDataObject=##class(web.DHCBL.Patient.DHCPatientUpdateLog).GetLogData("User.PAPatMas"_$c(2)_PatRowId_"^"_"User.PAPerson"_$c(2)_PatRowId)
		    set OldDataJson=##class(web.DHCDocDataChangeLog).GetLogJsonData("User.PAPatMas"_$c(2)_PatRowId_"^"_"User.PAPerson"_$c(2)_PatRowId)
		}
		
		Set person.PAPERID = PatObj.IDCardNo1
		Set OtherCard=PatObj.OtherCardInfo
		if ($p(PatObj.Name, "!!", 2) = "Unicode") {
			s PatObj.Name = $zcvt($p(PatObj.Name, "!!", 1), "I", "URL")
		}
		//如果姓名包含汉字去除汉字中存在的空格
		Set person.PAPERName = ..ClearNameSpacing(PatObj.Name)
		Set person.PAPERName2 = ##class(ext.util.String).ToChineseSpell(PatObj.Name)
		s PAPERName3=##class(web.DHCINSUPort).GetCNCODE(PatObj.Name,3,"")
		;Name3与Name 公用一个索引，这个为了防止Name3的索引把Name的索引置空，保证在Name有值时，Name3也必须有值
		if (PatObj.Name'="")&&(PAPERName3="") s PAPERName3=PatObj.Name
		Set person.PAPERName3 = PAPERName3
		;s mybj=##class(%Library.Date).IsValidDT(PatObj.Birth)
		if (PatObj.OpMedicare'="") {
			s person.PAPERGovernCardNo=PatObj.OpMedicare	;门诊病历号
		}
		Set person.PAPERDob = myBirth
		;Set person.PAPERForeignAddress = PatObj.Address
		d person.PAPERStName.Clear()
		d person.PAPERStName.Insert(PatObj.Address)
		Do person.PAPERSocialStatusDRSetObjectId(PatObj.PatType)
		i (PatObj.Sex'=""){
			Do person.PAPERSexDRSetObjectId(PatObj.Sex)
		}
		if (PatObj.UserDR'=""){
			if (myNewFlag=1) {
				Set person.PAPERDateAdded = +$h
				d person.PAPERUserAddedDRSetObjectId(PatObj.UserDR)
			}else{
				d person.PAPERUserUpdateSetObjectId(PatObj.UserDR)
			}
		}
		;^CT("COU",{CTCOU_RowId})
		s myCountryDR=$o(^CT("COU",0))
		if (myCountryDR'=""){
			;设定国家
			d person.PAPERCountryDRSetObjectId(myCountryDR)
		}
		if (PatObj.CountryDescLookUpRowID'=Vnull){ //(PatObj.CountryDescLookUpRowID'="")&&
			d person.PAPERCountryDRSetObjectId(PatObj.CountryDescLookUpRowID)
		}
		
		///国籍现住
		if (PatObj.CountryHouse'=Vnull){ //(PatObj.CountryDescLookUpRowID'="")&&
			d person.PAPERCountryBirthDRSetObjectId(PatObj.CountryHouse)
		}
		
		////国籍籍贯
		if (PatObj.CountryHome'=Vnull){ //(PatObj.CountryDescLookUpRowID'="")&&
			d person.PAPERCountryCameFromDRSetObjectId(PatObj.CountryHome)
		}
		
		///
		
		;SetObjectId
		if (PatObj.ZipLookUpRowID'=Vnull){ //(PatObj.ZipLookUpRowID'="")&&
			d person.PAPERZipDRSetObjectId(PatObj.ZipLookUpRowID)
		}
		i (PatObj.CountryDescLookUpRowID'=Vnull){ //(PatObj.CountryDescLookUpRowID'="")&&
			d person.PAPERCountryDRSetObjectId(PatObj.CountryDescLookUpRowID)
		}
		if (PatObj.ProvinceInfoLookUpRowID'=Vnull){ //(PatObj.ProvinceInfoLookUpRowID'="")&&
			d person.PAPERCTProvinceDRSetObjectId(PatObj.ProvinceInfoLookUpRowID)
		}
		if ((PatObj.CityDescLookUpRowID'=Vnull)){ //(PatObj.CityDescLookUpRowID'="")&&
			d person.PAPERCityCodeDRSetObjectId(PatObj.CityDescLookUpRowID)
		}
		if (PatObj.CityAreaLookUpRowID'=Vnull){ //(PatObj.CityAreaLookUpRowID'="")&&
			d person.PAPERCityAreaDRSetObjectId(PatObj.CityAreaLookUpRowID)
		}
		
		if (PatObj.NationDescLookUpRowID'=Vnull) //(PatObj.NationDescLookUpRowID'="")&&
		{
			d person.PAPERNationDRSetObjectId(PatObj.NationDescLookUpRowID)
		}
		
		if (PatObj.CTRelationDR'=Vnull){ //(PatObj.CTRelationDR'="")&&
			d person.PAPERCTRLTDRSetObjectId(PatObj.CTRelationDR)
		}
		
		///PAPER_ForeignId
		s person.PAPERForeignId =PatObj.ForeignName
		
		;设定语言
		s myLangDR=$o(^SS("LAN",0,"Code","CHN",0))
		i (myLangDR'=""){
			d person.PAPERLangPrimDRSetObjectId(myLangDR)
		}
		s person.PAPERUpdateDate=..%SysDate() //PatObj.UpdateDate
		s person.PAPERUpdateTime=..%SysTime() //PatObj.UpdateTime
		;特定值
		s person.PAPEREstDOB="N"	;
		s person.PAPERIncompleteRegistration="N"
		
		s person.PAPERTelH=PatObj.TelHome		;家庭电话
		s person.PAPERTelO=PatObj.TelOffice		;单位电话
		s person.PAPERForeignPhone=PatObj.ForeignPhone
		;PAPER_EmployeeCompany
		;PAPER_EmployeeCompany
		;;集团/单位
		i (PatObj.EmployeeCompanyLookUpRowID'="")&&(PatObj.EmployeeCompanyLookUpRowID'=Vnull){
			d person.PAPEREmployeeCompanySetObjectId(PatObj.EmployeeCompanyLookUpRowID)
		}
		
		s person.PAPEREmail=PatObj.EMail
		
		;PAPEROccupationDR  职业
		if (PatObj.Vocation'=Vnull) //(PatObj.Vocation'="")&&
		{
			d person.PAPEROccupationDRSetObjectId(PatObj.Vocation)
		}
		//工号  2011-07-15
		s person.PAPEREmployeeNo=PatObj.EmployeeNo
		
		///PAPER_ForeignCountry 联系人身份证号  医联码新增
		if (PatObj.ForeignIDCard'=Vnull){
			s person.PAPERForeignCountry =PatObj.ForeignIDCard
			d person.PAPERForeignCardTypeDRSetObjectId(PatObj.ForeignCredType)
		}
		///PAPER_StayingPermanently  是否专程来京就诊  医联码新增
		if (PatObj.AdmSource="on") s AdmSource="Y"
		else  s AdmSource="N"
		s person.PAPERStayingPermanently =AdmSource
		///PAPER_Marital_DR   婚姻状况  医联码新增
		if (PatObj.PAPERMarital'=Vnull){ //(PatObj.PAPERMarital'="")&&
			Do person.PAPERMaritalDRSetObjectId(PatObj.PAPERMarital)
		}
		///PAPER_SecondPhone 工作单位  医联码新增
		if (PatObj.Company'=Vnull){ //(PatObj.Company'="")&&
			s person.PAPERSecondPhone =PatObj.Company
		}
		
		///PAPER_ForeignCity  行政区域  医联码新增
		if (PatObj.HealthCareRegion'="")&&(PatObj.HealthCareRegion'=Vnull){
			s person.PAPERName8 =PatObj.HealthCareRegion
		}
		//单位邮编
		s person.PAPERName6=PatObj.CompanyPostCode
		//联系人邮编
		s person.PAPERForeignPostCode=PatObj.ForeignPostCode
		//联系人地址
		s person.PAPERForeignAddress=PatObj.ForeignAddress
		//血型
		s person.PAPERBloodTypeDR=PatObj.BloodType
		
		//省(籍贯)
		d person.PAPERProvinceBirthDRSetObjectId(PatObj.ProvinceHome)
		//省(籍贯)
		d person.PAPERCityBirthDRSetObjectId(PatObj.CityHome)
		//省(籍贯)
		d person.PAPERAreaHomeDRSetObjectId(PatObj.AreaHome)
		///病人级别 
		if (PatObj.PoliticalLevel'=Vnull){ //(PatObj.PoliticalLevel'="")&&
			d person.PAPEREmployeeFunctionSetObjectId(PatObj.PoliticalLevel)
		}
		//照片信息base64
		if ((PatObj.PhotoInfo'="")&&(PatObj.PhotoInfo'=Vnull))
		{
			s person.PAPERPhoto=PatObj.PhotoInfo	
		}
		Set sc = person.%Save()
		b ;PersonSave
		If ($System.Status.IsError(sc))
		{
			Do $System.Status.DisplayError(sc)
			Set myrtn = "-100"
			q myrtn_"^"
		}
		b	;Save PaPerson
		;PatMas
		Set PAPMIRowID = person.%Id()
		
		If ((PAPMIRowID'="") && (+myrtn = 0))
		{
			;Set patmas = ##class(User.PAPatMas).%New()
			Set patmas = ##class(User.PAPatMas).%OpenId(PAPMIRowID)
			;设置登记号码
			;如果是新增的需要更新登记号码
			;而对于已经生成的登记号需要 不需要更新登记号
			if (+myNewFlag'=0){
				i PatObj.PAPMINo'=""{  ;导入数据时根据外面传入的病人ID使用
					s myMAXNo=PatObj.PAPMINo
				}else{ 
					s myMAXNo=0
					;pd by tanjishan 20201120
					;担心体检或其他系统批量新建患者，导致该Global死锁的问题
					;lock 不加参数，Caché将解锁所有先前的锁定并应用指定的锁定。但是只会在事务结束时释放
					//Lock ^PAPER(0,"CNT","I")
					s myMAXNo=$i(^PAPER(0,"CNT","I"))
					//Lock -^PAPER(0,"CNT","I")
					s myPatLen=+$p(^CF("PATCF",1,3),"^",5)
					s myMAXNo=$e("0000000000000000000",1,myPatLen-$l(myMAXNo))_myMAXNo
				}
				s patmas.PAPMINo=myMAXNo
				s patmas.PAPMIIPNo=myMAXNo
				s patmas.PAPMIOPNo=myMAXNo
			}
			if (PatObj.InMedicare'=""){
				s patmas.PAPMIMedicare=PatObj.InMedicare	;InMedicare 住院病案号
			}
			////国籍出生
			if (PatObj.CountryBirth'=Vnull){ //(PatObj.CountryDescLookUpRowID'="")&&
				d patmas.PAPMICountryOfBirthDRSetObjectId(PatObj.CountryBirth)
			}
			
			d patmas.PAPMILangPrimDRSetObjectId(PatObj.PAPMILangPrimDR) ;母语1
			
			d patmas.PAPMILangSecondDRSetObjectId(PatObj.PAPMILangSecondDR) ;母语2
			
			
			if (PatObj.Education'=""){
				d patmas.PAPMIEducationSetObjectId(PatObj.Education) ;学历
				//s patmas.PAPMIMedicare=PatObj.Education	;InMedicare 住院病案号
			}
			;证件类型
			;PatObj.CredType
			i (PatObj.CredType'=""){
				d patmas.PAPMICardTypeDRSetObjectId(PatObj.CredType)
			}
			;PAPMI_MobPhone   移动电话
			s patmas.PAPMIMobPhone=PatObj.MobPhone //移动电话
			;s ^wrz("MobPhone")=PatObj.MobPhone
			;s $P(^PAPER(PAPMIRowID,"PER",4),21)=PatObj.MobPhone
	
			;过敏史
			d patmas.PAPMIAllergy.Clear()
			d patmas.PAPMIAllergy.Insert(PatObj.Allergy)
			
			;证件号码  有索引
			s patmas.PAPMIDVAnumber=PatObj.CredNo
			;身份证的设置要判断证件类型是不是身份证
			s CredTypeDesc=""
			S:PatObj.CredType'="" CredTypeDesc=$P($G(^PAC("CARD",PatObj.CredType)),"^",2)
			s:(PatObj.IDCardNo1="")&&(CredTypeDesc[("身份证")) PatObj.IDCardNo1=PatObj.CredNo
			s IDCardNo=PatObj.IDCardNo1
			//此处极其影响效率，需要改为按照ID更新
			//&Sql(Update SQLUser.DHC_CardRef Set CF_IDCardNo=:IDCardNo Where CF_PAPMI_DR=:PAPMIRowID)
			s myCFRowID=0
			for{
				s myCFRowID=$O(^DHCCARDi("CF",0,"PAPMIDR",PAPMIRowID,myCFRowID))
				q:(myCFRowID="")
				&Sql(Update SQLUser.DHC_CardRef Set CF_IDCardNo=:IDCardNo Where CF_RowID=:myCFRowID)
			}
			
			if (+myNewFlag'=0){
				;有效
				s patmas.PAPMIActive="Y"
			}
			
			///PAPMI_VIPFlag  协和国际医疗部就诊卡标志
			if (PatObj.VIPFlag="on") s VIPFlag="Y"
			else  s VIPFlag="N"
			s patmas.PAPMIVIPFlag =VIPFlag
			
			//首诊科室
			d patmas.PAPMIGPOrgAddress.Clear()
			d patmas.PAPMIGPOrgAddress.Insert(PatObj.GPOrgAddress)
			
			Set sc = patmas.%Save()
			If ($System.Status.IsError(sc))
			{
				Do $System.Status.DisplayError(sc)
				Set myrtn = "-101"
				q myrtn_"^"
			}
			;&&(PatObj.IDCardNo1)
			if ((+myrtn=0)){
				s myrtn=+..UpdatePAPMSID(PAPMIRowID,PatObj.IDCardNo1)
				if (+myNewFlag=0) {
					;根据设置确定是否更新当日及以后就诊记录费别
				    s CFMedifyPatTypeSynAdmRea=##class(web.DHCOPRegConfig).GetSpecConfigNode("MedifyPatTypeSynAdmRea")
				    i (CFMedifyPatTypeSynAdmRea=1)&&(PrePatTypeId'=PatObj.PatType) {
						d ##class(web.DHCBL.Patient.DHCPatient).UpdateAdmedReason(PAPMIRowID)
				    }
			    }
			}
		}
		Else
		{
			Set myrtn = "-102"
		}
		
		;对于特殊的字段存储
		i (+myrtn=0){
			;留给其他医院的接口
			s myinfortn=##class(web.DHCBL.CARDIF.ICardPaPatMasInfo).SavePatOtherInfo(PAPMIRowID, PatObj)
			s myrtn=+$p(myinfortn,"^",1)
		}
		;保存其他证件类型
		if (OtherCard'="")&&(+myrtn = 0){
			s myrtn=##Class(web.DHCBL.CARD.UCardPaPatMasInfo).SaveOtherCardInfo(PAPMIRowID,OtherCard)
		}
		Set OtherName=PatObj.OtherNameInfo
		;保存多类型姓名
		if (OtherName'="")&&(+myrtn = 0){
			s myrtn=##Class(web.DHCBL.CARD.UCardPaPatMasInfo).SaveOtherName(PAPMIRowID,OtherName,PatObj.UserDR)
		}
		/*
		i OldPatInfo'="" d
		.s $ZT="LogErr"
		.s NewPatInfo=##class(web.DHCBL.Patient.DHCPatientBuilder).SearchPatInfoByRowID(PAPMIRowID)
		.s logInfo=##class(web.DHCBL.Patient.DHCPatientBuilder).CheckPatInfoUpdate(OldPatInfo,NewPatInfo)
		.d ##class(web.DHCBL.Patient.DHCPatientBuilder).AddDHCPatientUpdateLog(logInfo,PatObj.UserDR)
		.s $ZT=""
		*/
		///病人密级 密级表 DHC_ SecretLevel
		if (PatObj.SecretLevel'=Vnull){ //(PatObj.SecretLevel'="")&&
			s $P(^PAPER(PAPMIRowID ,"DHC"),"^",30)=PatObj.SecretLevel
		}
		;使用新的记日志方法 guobaoping 
		i $IsObject(OldDataObject)  
		{
			//set flag=##class(web.DHCBL.Patient.DHCPatientUpdateLog).SaveUpdLog(OldDataObject,"User.PAPatMas"_$c(2)_PAPMIRowID_"^"_"User.PAPerson"_$c(2)_PAPMIRowID,PatObj.UserDR)
		    set NewDataJson=##class(web.DHCDocDataChangeLog).GetLogJsonData("User.PAPatMas"_$c(2)_PatRowId_"^"_"User.PAPerson"_$c(2)_PatRowId)
		    s OperateType=$case(myNewFlag,0:"U",1:"A")
		    set falg=##class(web.DHCDocDataChangeLog).SaveLog("PA_PatMas#PA_Person","User.PAPatMas#User.PAPerson","患者基本信息","User.PAPatMas#User.PAPerson_"_PAPMIRowID,PatObj.Name,OperateType,NewDataJson,OldDataJson,PatObj.UserDR)
		}
		i (+myrtn=0)&&(myNewFlag=0) {
			// 更新患者信息后
			d ##class(DHCDoc.Interface.CardManage).Interface("AfterPatUpdate",PAPMIRowID)
		}
	q myrtn_"^"_PAPMIRowID
LogErr
	q myrtn_"^"_PAPMIRowID
}

/// /修改身份证号码
ClassMethod UpdatePAPMSID(PAPMIRowID As %String, PAID As %String) As %String
{
	;##class(web.DHCBL.CARD.UCardPaPatMasInfo).UpdatePAPMSID(PAPMIRowID, PAID)
	//q:(PAPMIRowID="") 0
	Set person = ##class(User.PAPerson).%OpenId(PAPMIRowID)
	Do person.%Reload()			//禁用对象缓存，从磁盘重新加载数据，防止对象获取到错误的数据
	set person.PAPERID=PAID
	Set sc = person.%Save()
	If ($$$ISERR(sc)){
		Q "-1011"
	}
	
	/*
	//PA_Person中PAPER_ID字段MAXLEN=17,才需要用以下的程序处理;Cache2010及后续版本都已经改为MAXLEN=18
	d ..ClearPAPERIdIndex(PAPMIRowID)
	s myPAID=$ZConvert(PAID,"U")
	
	s $p(^PAPER(PAPMIRowID,"ALL"),"^",9)=myPAID
	
	s myPAID=$ZConvert(PAID_"Z","U")
	s ^PAPERi("PAPMI_ICPPBC",myPAID,PAPMIRowID)=""
	*/
	
	q 0
}

ClassMethod SaveOtherCardInfo(PAPMIRowID As %String, OtherCard As %String) As %String
{
  //Set ^yjy(33)=OtherCard
  //w ##Class(web.DHCBL.CARD.UCardPaPatMasInfo).SaveOtherCardInfo("6","2^2!3^3")
  If '$D(^DHCPCNi("PAPMI",PAPMIRowID)) Do
  .For i=1:1:$L(OtherCard,"!") Do
  ..Set CardInfo=$P(OtherCard,"!",i)
  ..Set CardType=$P(CardInfo,"^",1)
  ..Set CardNo=$P(CardInfo,"^",2)
  ..Q:CardType=""
  ..&sql(Insert into SQLUser.DHC_PaperCardNum Set DHCPCN_CardType_DR=:CardType,DHCPCN_Papmi_DR=:PAPMIRowID,DHCPCN_CardNo=:CardNo)
  Else  DO
  .For i=1:1:$L(OtherCard,"!") Do
  ..Set CardInfo=$P(OtherCard,"!",i)
  ..Set CardType=$P(CardInfo,"^",1)
  ..Set CardNo=$P(CardInfo,"^",2)
  ..If $D(^DHCPCNi("PAPMI",PAPMIRowID,CardType)) Do
  ...Set DHCPCNROWID=$O(^DHCPCNi("PAPMI",PAPMIRowID,CardType,-1))
  ...Q:DHCPCNROWID=""
  ...Q:CardType=""
  ...&Sql(Update SQLUser.DHC_PaperCardNum Set DHCPCN_CardNo=:CardNo Where DHCPCN_ROWID=:DHCPCNROWID)
  ..Else  Do
  ...Q:CardType=""
  ...&sql(Insert into SQLUser.DHC_PaperCardNum Set DHCPCN_CardType_DR=:CardType,DHCPCN_Papmi_DR=:PAPMIRowID,DHCPCN_CardNo=:CardNo)
  Q 0
}

ClassMethod GetCountryByProvice(ProviceID)
{
	q:ProviceID="" ""
	s Region=$P(^CT("PROV",ProviceID),"^",3)
	q:Region="" ""
	s Country=$P(^CT("RG",Region),"^",4)
	q Country
}

ClassMethod ChangeNullValue(Obj)
{
	s clsDef=##class(%Library.ClassDefinition).%OpenId("web.DHCEntity.PCA.CardPatInfoReg")
	s clsProList=clsDef.Properties
	f Num=1:1:clsProList.Count()
	{
		s clsPro=clsProList.GetAt(Num)
		s proName=clsPro.Name
		continue:proName["%"
		continue:clsPro.Cardinality="children"
		s:$ZOBJPROPERTY(Obj,proName)="" $ZOBJPROPERTY(Obj,proName)=$c(0)
		
	}
	q Obj
}

/// creator:郭荣勇
/// desc:提供根据病人RowId获取病人密级和病人级别
/// input:PA_PatMas表RowId,执行此方法返回的错误信息
/// output:密级特殊字符^病人级别^密级代码^密级描述 或 空
ClassMethod GetPatEncryptLevel(PAPMIRowId As %String, ByRef ErrMsg As %String) As %String
{
	s ErrMsg=""
	if PAPMIRowId="" {
		s ErrMsg="入参中病人RowId不存在"
		Q ""
	}
	Set langid=..%LanguageID()
	s EmployeeFunction=""
	s EmployeeFunctionDR=$p($g(^PAPER(PAPMIRowId,"PER",3)),"^",3)
	if EmployeeFunctionDR'="" s EmployeeFunction=$P($g(^CT("EMF",EmployeeFunctionDR)),"^",2)
	s EmployeeFunction=##class(User.CTEmpFunc).GetTranByDesc("CTEMFDesc",EmployeeFunction,langid)
	s SecCode="",SecDesc="",SecAlias=""
	s PAPMISecretLevelDR=$p($g(^PAPER(PAPMIRowId,"DHC")),"^",30)
	if PAPMISecretLevelDR'="" {
		s SecCode=$List(^User.DHCSecretLevelD(PAPMISecretLevelDR),2)
		s SecDesc=$List(^User.DHCSecretLevelD(PAPMISecretLevelDR),3)
		s SecAlias=$List(^User.DHCSecretLevelD(PAPMISecretLevelDR),4)
		s Languages="CH"
		if langid'="" s Languages=$p($g(^SS("LAN",langid)),"^",1)
		s SecDesc=##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("User.DHCSecretLevel","Level_Desc",Languages,SecDesc)
	}
	
	Q SecAlias_"^"_EmployeeFunction_"^"_SecCode_"^"_SecDesc
}

ClassMethod ID15to18(IDCardNo15 As %String = "") As %String
{

	if $length(IDCardNo15)'=15 quit IDCardNo15
	set IDCardNo17=$extract(IDCardNo15,1,6)_"19"_$extract(IDCardNo15,7,15)

	set W(1)=1,W(2)=2,W(3)=4,W(4)=8,W(5)=5,W(6)=10,W(7)=9,W(8)=7,W(9)=3,W(10)=6
	set W(11)=1,W(12)=2,W(13)=4,W(14)=8,W(15)=5,W(16)=10,W(17)=9,W(18)=7
	set Y(0)="1",Y(1)="0",Y(2)="X",Y(3)="9",Y(4)="8",Y(5)="7",Y(6)="6",Y(7)="5",Y(8)="4",Y(9)="3",Y(10)="2"

	set snum=0
	for i=18:-1:2
	{
		set snum=snum+($extract(IDCardNo17,19-i,19-i)*W(i))
	}

	set ynum=snum#11

	set IDCardNo18=IDCardNo17_Y(ynum)
	quit IDCardNo18
}

/// 清除PA_PatMas的PAPMI_ID身份证号字段的索引  2017.4.27  Yzs 
/// d ##class(web.DHCBL.CARD.UCardPaPatMasInfo).ClearPAPERIdIndex("48")
ClassMethod ClearPAPERIdIndex(PAPMIRowID As %String) As %String
{
	;n (PAPMIRowID)
	q:PAPMIRowID=""
	s PAPERId=$p($g(^PAPER(PAPMIRowID,"ALL")),"^",9)
	q:PAPERId="" 
	if $l(PAPERId)=15{
				s myPAID15=$ZConvert(PAPERId_"Z", "U")
				s myPAID18=..ID15to18(PAPERId)
				s myPAID18=$ZConvert(myPAID18_"Z","U")
				
	}elseif($l(PAPERId)=18){
				s myPAID18=$ZConvert(PAPERId_"Z", "U")
				s myPAID15=$e(PAPERId,1,6)_$e(PAPERId,9,17)
				s myPAID15=$ZConvert(myPAID15_"Z","U")
	}else{
				s myPAID18="ZX"
				s myPAID15="ZX"
	}
	i $d(^PAPERi("PAPMI_ICPPBC",myPAID18,PAPMIRowID)) k ^PAPERi("PAPMI_ICPPBC",myPAID18,PAPMIRowID)
	i $d(^PAPERi("PAPMI_ICPPBC",myPAID15,PAPMIRowID)) k ^PAPERi("PAPMI_ICPPBC",myPAID15,PAPMIRowID)
	q
}

/// creator:郭荣勇
/// date:2017-06-28
/// 判断是否要使用APP患者录入的建大病历的暂存信息
/// input:PAPMIRowID 患者RowId,PAPMINo 患者登记号   传一个参数即可使用此方法
/// output: 标识^患者登记号，标识：1 需要，0 不需要
ClassMethod IsNeedRegMedicalEPMI(PAPMIRowID As %String, PAPMINo As %String) As %String
{
	Q:(PAPMIRowID="")&&(PAPMINo="") "0^"
	if PAPMIRowID="" s PAPMIRowID=$o(^PAPERi("PAPMI_PatNo",$ZCVT(PAPMINo,"U"),""))
	Q:PAPMIRowID="" "0^"
	
	s PAPMINo=$P(^PAPER(PAPMIRowID,"PAT",1),"^",1)
	;判断暂存信息是否存在
	s MedicalEPMIId=$O(^User.DHCRegMedicalEPMII("EPMI",PAPMINo,0))
	Q:MedicalEPMIId="" "0^"
	s PAPMIMedicare=##Class(DHCWMR.IO.OutService).IGetMrNoByPatientID(PAPMIRowID,"")
	i PAPMIMedicare'="" {
		Q "0^"_PAPMINo
	}else{
		Q "1^"_PAPMINo
	}
}

/// creator:郭荣勇
/// date:2017-06-28
/// 获取APP患者录入的建大病历的暂存信息
/// input:PAPMIRowID 患者RowId
/// output: 需要赋值到建大病历页面的XML串
ClassMethod GetRegMedicalEPMI(ByRef myregobj As web.DHCEntity.PCA.CardPatInfoReg, PAPMINo As %String) As %String
{
	Q:(PAPMINo="") ""
	s PAPMIXMLStr=""
	s MedicalEPMIId=$O(^User.DHCRegMedicalEPMII("EPMI",PAPMINo,0))
	Q:MedicalEPMIId="" ""
	
	s MEPMIObj=##class(User.DHCRegMedicalEPMI).%OpenId(MedicalEPMIId,0)
	
	;s myregobj.NewBabyFlag=$g(NewBabyFlag)
	;s myregobj.NoNameInfoFlag=$g(NoNameInfoFlag)
	s myregobj.Name=MEPMIObj.Name
	;s myregobj.PAPMIRowID=$g(myPAPMIDR)
	s myregobj.Birth=MEPMIObj.Birth
	s myregobj.Age=$P($$CalAge^at182(..%ZDH(MEPMIObj.Birth),+$H,"","",""),"|",12)
	s myregobj.Sex = MEPMIObj.Sex
	;s myregobj.PAPMINo =$g(PAPMINo)
	s myregobj.Address=MEPMIObj.AddressCurrent
	s myregobj.PatType=MEPMIObj.PatType
	s myregobj.EmployeeCompany=MEPMIObj.Company
	;s myregobj.InMedicare=$g(RInMedicare)
	;s myregobj.OpMedicare=$g(ROpMedicare)
	;s myregobj.MobPhone=$g(RMobPhone)
	s myregobj.TelHome=MEPMIObj.TelHome
	s myregobj.CredType=MEPMIObj.CredType
	s myregobj.CredNo=MEPMIObj.CredNo
	s myregobj.ForeignName=MEPMIObj.ForeignName
	s myregobj.CTRelationDR=MEPMIObj.CTRelation
	//工号
	s myregobj.EmployeeNo=MEPMIObj.EmployeeNo
	//合同单位
	s myregobj.HCPDR=MEPMIObj.HCP
	//费别
	;s myregobj.AdmReason=$G(AdmReason)
	//公医证号
	s myregobj.InsurCardNo=MEPMIObj.HCPNo
	//医联码  PAPMIHealthFundNo
	;s myregobj.MedUnionCard=$g(MedUnionCard)
	//职业 PAPEROccupationDR
	s myregobj.Vocation=MEPMIObj.Vocation
	//联系人身份证号  PAPERForeignCountry
	s myregobj.ForeignIDCard=MEPMIObj.ForeignIDCard
	//PAPER_StayingPermanently  是否专程来京就诊
	s myregobj.AdmSource=MEPMIObj.AdmSource
	//PAPER_ForeignPostCode  联系人电话
	s myregobj.ForeignPhone=MEPMIObj.ForeignPhone
	//PAPER_Marital_DR   婚姻状况
	s myregobj.PAPERMarital=MEPMIObj.PAPERMarital
	//PAPER_SecondPhone 工作单位
	s myregobj.Company=MEPMIObj.Company
	//PAPER_ForeignCity  行政区域
	s myregobj.HealthCareRegion=MEPMIObj.HealthCareRegion
	//PAPMI_VIPFlag 
	;s myregobj.VIPFlag=$g(VIPFlag)
	//出生地
	;s myregobj.BirthPlace=$G(BirthPlace)
	//血型
	;s myregobj.BloodType=$G(BloodType)
	//工作单位邮编
	s myregobj.CompanyPostCode=MEPMIObj.CompanyZip
	//联系人地址
	s myregobj.ForeignAddress=MEPMIObj.ForeignAddress
	//联系人邮编
	s myregobj.ForeignPostCode=MEPMIObj.ForeignZip
	//初诊科室
	;s myregobj.GPOrgAddress=$G(GPOrgAddress)
	//籍贯
	s myregobj.HomePlace=MEPMIObj.HomePlace
	//家庭所在地区
	;s myregobj.HouseArea=$G(HouseArea)
	//照片信息Base64编码串 导入联众数据使用
	//s myregobj.PhotoInfo=$G(PhotoInfo)
	//非代码表邮编
	s myregobj.PostCode=MEPMIObj.ZipCurrent
	//户口地址
	s myregobj.RegisterPlace=MEPMIObj.AddressHouse
	
	//国(籍贯)
	s myregobj.CountryHome=MEPMIObj.Country
	//省(籍贯)
	s myregobj.ProvinceHome=MEPMIObj.HomePlace
	//市(籍贯)
	s myregobj.CityHome=MEPMIObj.CityCurrent
	//国(出生)
	s myregobj.CountryBirth=MEPMIObj.CountryBirth
	//国(住地)
	;s myregobj.CountryHouse=MEPMIObj.CountryHouse
	s myregobj.CountryHouse=MEPMIObj.CountryCurrent
	
	//省(出生)
	s myregobj.ProvinceBirth=MEPMIObj.ProvinceBirth
	//市(出生)
	s myregobj.CityBirth=MEPMIObj.CityBirth
	//县(出生)
	s myregobj.AreaBirth=MEPMIObj.AreaBirth
	//地址(出生)
	s myregobj.AddressBirth=MEPMIObj.AddressBirth
	//省(户口)
	s myregobj.ProvinceHouse=MEPMIObj.ProvinceHouse
	//市(户口)
	s myregobj.Cityhouse=MEPMIObj.CityHouse
	//县(户口)
	s myregobj.AreaHouse=MEPMIObj.AreaHouse
	//邮编(户口)
	s myregobj.PostCodeHouse=MEPMIObj.ZipHouse
	
	//民族
	s myregobj.NationDesc=MEPMIObj.Nation
	//国家(户口)
	;s myregobj.CountryDesc=MEPMIObj.CountryCurrent
	s myregobj.CountryDesc=MEPMIObj.CountryHouse
	
	//省份
	s myregobj.ProvinceInfo=MEPMIObj.ProvinceCurrent
	//单位电话
	s myregobj.TelOffice=MEPMIObj.TelOffice
	
	;s myregobj.Allergy=$G(Allergy) ;ALLERGY
	s myregobj.CityDesc=MEPMIObj.CityCurrent
	s myregobj.CityArea=MEPMIObj.AreaCurrent
	;s myregobj.EMail=$G(EMail)
	;s myregobj.Zip=$G(Zip)
	;s MedicalCardNo=""
	
	s myregobj.PatYBCode= MEPMIObj.PatYBCode
	
	Q
}

// w ##class(web.DHCBL.CARD.UCardPaPatMasInfo).CheckCredNoIDU(1193,"JMHKB009009",21)

ClassMethod CheckCredNoIDU(PatientID As %String, CredNo As %String, CredTypeDR As %String) As %String
{
  
	s mySameFind=0
	Q:(CredNo="")||(CredTypeDR="") mySameFind //(PatientID="")||
	s myPAID=$ZConvert(CredNo, "U")
	;验证证件类型和证件号码
	;没有发现身份证号重复
	s myPAPMIDR=0
	f  s myPAPMIDR=$o(^PAPERi("DVA",myPAID,myPAPMIDR))  q:(myPAPMIDR="")||(+mySameFind)  d
	.;同一证件类型才成
	.s myCredTypeDR=$p(^PAPER(myPAPMIDR,"PAT",3),"^",7)	;CardType_DR
	.i CredTypeDR=myCredTypeDR,myPAPMIDR'=PatientID d
	..q:$d(^User.DHCPATCardUniteLogI("OldNewPAPMI"," 1"," "_myPAPMIDR," "_PatientID,"PAPATMAS"))
	..s mySameFind=1
	Q mySameFind
}

ClassMethod SavePhoto(RegNo, PhotoInfo)
{
	set stream=##class(%Stream.GlobalCharacter).%New()
	if '$IsObject(PhotoInfo) {
		d stream.Write(PhotoInfo)
	}else {
		d stream.CopyFrom(PhotoInfo)
	}
	Q ##class(web.DHCPE.PreIBIUpdate).SavePhoto(RegNo,stream)
}

/// 建卡时如果姓名中包含汉字去除多余空格
/// w ##class(web.DHCBL.CARD.UCardPaPatMasInfo).ClearNameSpacing("中 国")
ClassMethod ClearNameSpacing(PatName)
{
	q:PatName="" ""
	s len = $l(PatName)
	s HZFlag=""
	for i = 1 : 1 : len {
		q:HZFlag="Y"
		s char = $e(PatName, i)
		s flag=##class(Util.StringUtils).IsChinese(char)
		i flag=1 s HZFlag="Y"
	}
	i HZFlag="Y" s PatName=$replace(PatName," ","")
	q PatName
}

ClassMethod SaveOtherName(PAPMIRowID As %String, OtherName As %String, UserID As %String) As %String
{

	s ^tmp("SaveOtherName")=$LB(PAPMIRowID,OtherName)
  s NowDate=+$H
  s NowTime=$P($H,",",2)
  If '$D(^DHCPN(0,"PersonType",PAPMIRowID)) Do
  .For i=1:1:$L(OtherName,"!") Do
  ..Set NameInfo=$P(OtherName,"!",i)
  ..Set NameType=$P(NameInfo,"^",1)
  ..Set Name=$P(NameInfo,"^",2)
  ..Q:NameType=""
  
  ..&sql(Insert into SQLUser.DHC_PersonName Set DHCPN_NameType_DR=:NameType,DHCPN_PAPerson_DR=:PAPMIRowID,
  					 DHCPN_CreateUser_DR=:UserID,DHCPN_CreateDate=:NowDate,DHCPN_CreateTime=:NowTime,DHCPN_PatName=:Name)
  Else  DO
  .For i=1:1:$L(OtherName,"!") Do
  ..Set NameInfo=$P(OtherName,"!",i)
  ..Set NameType=$P(NameInfo,"^",1)
  ..Set Name=$P(NameInfo,"^",2)
  ..Q:NameType=""
  ..If $D(^DHCPN(0,"PersonType",PAPMIRowID,NameType)) Do
  ...Set DHCPNRowid=$O(^DHCPN(0,"PersonType",PAPMIRowID,NameType,0))
  ...Q:DHCPNRowid=""
  ...&Sql(Update SQLUser.DHC_PersonName Set DHCPN_PatName=:Name,DHCPN_UpdateUser_DR=:UserID,
				 DHCPN_UpdateDate=:NowDate,DHCPN_UpdateTime=:NowTime Where DHCPN_Rowid=:DHCPNRowid)
  ..Else  Do
  ...&sql(Insert into SQLUser.DHC_PersonName Set DHCPN_NameType_DR=:NameType,DHCPN_PAPerson_DR=:PAPMIRowID,
  					  DHCPN_CreateUser_DR=:UserID,DHCPN_CreateDate=:NowDate,DHCPN_CreateTime=:NowTime,DHCPN_PatName=:Name)
  Q 0
}

/// w ##class(web.DHCBL.CARD.UCardPaPatMasInfo).GetOtherName(1)
ClassMethod GetOtherName(PAPMIRowId As %String) As %String
{
	s retStr=""
	Q:PAPMIRowId="" retStr
	s NameType=0
	for {
		s NameType=$O(^DHCPN(0,"PersonType",PAPMIRowId,NameType))
		q:NameType=""
		s DHCPNRowid=0
		for {
			s DHCPNRowid=$O(^DHCPN(0,"PersonType",PAPMIRowId,NameType,DHCPNRowid))
			Q:DHCPNRowid=""
			s Name=$P($g(^DHCPN(DHCPNRowid)),"^",3)
			if retStr="" s retStr=NameType_"^"_Name
			else  s retStr=retStr_"!"_NameType_"^"_Name
		}
	}
    
    Q retStr
}

}
