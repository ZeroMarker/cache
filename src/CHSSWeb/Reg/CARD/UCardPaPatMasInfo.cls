Class CHSSWeb.Reg.CARD.UCardPaPatMasInfo Extends %Persistent
{

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
	
	s myBirth=""
	s Vnull=$C(0)
	if (PatObj.Birth'=""){
		;;如果为空默认当前日期
		i PatObj.Birth["-" d  s myBirth=$zdh(PatObj.Birth,3)
		i PatObj.Birth["/" d  s myBirth=$zdh(PatObj.Birth,4)
	}
	
		b	;;获取是否已经生成Person的Id
		Set PatRowId = PatObj.PAPMIRowID
		;使用RowID来决定是否 更新和新增
		if ((PatRowId = "")||(PatRowId=$c(0)))
		{
			Set person = ##class(User.PAPerson).%New()
			s myNewFlag=1
		}
		else
		{
			Set person = ##class(User.PAPerson).%OpenId(PatRowId)
			s myNewFlag=0
		}
		
		;Set person.PAPERID = PatObj.IDCardNo1
		Set OtherCard=PatObj.OtherCardInfo
		Set person.PAPERName = PatObj.Name
		;s mybj=##class(%Library.Date).IsValidDT(PatObj.Birth)
		s person.PAPERGovernCardNo=PatObj.OpMedicare	;门诊病历号
		Set person.PAPERDob = myBirth
		;Set person.PAPERForeignAddress = PatObj.Address
		d person.PAPERStName.Insert(PatObj.Address)
		Set person.PAPERDateAdded = +$h
		Do person.PAPERSocialStatusDRSetObjectId(PatObj.PatType)
		i (PatObj.Sex'=""){
			Do person.PAPERSexDRSetObjectId(PatObj.Sex)
		}
		if (PatObj.UserDR'=""){
			d person.PAPERUserAddedDRSetObjectId(PatObj.UserDR)
			d person.PAPERUserUpdateSetObjectId(PatObj.UserDR)
		}
		;^CT("COU",{CTCOU_RowId})
		s myCountryDR=$o(^CT("COU",0))
		if (myCountryDR'=""){
			;设定国家
			d person.PAPERCountryDRSetObjectId(myCountryDR)
		}
		if (PatObj.CountryDescLookUpRowID'="")&&(PatObj.CountryDescLookUpRowID'=Vnull){
			d person.PAPERCountryDRSetObjectId(PatObj.CountryDescLookUpRowID)
		}
		
		;SetObjectId
		if (PatObj.ZipLookUpRowID'="")&&(PatObj.ZipLookUpRowID'=Vnull){
			d person.PAPERZipDRSetObjectId(PatObj.ZipLookUpRowID)
		}
		i (PatObj.CountryDescLookUpRowID'="")&&(PatObj.CountryDescLookUpRowID'=Vnull){
			d person.PAPERCountryDRSetObjectId(PatObj.CountryDescLookUpRowID)
		}
		if (PatObj.ProvinceInfoLookUpRowID'="")&&(PatObj.ProvinceInfoLookUpRowID'=Vnull){
			d person.PAPERCTProvinceDRSetObjectId(PatObj.ProvinceInfoLookUpRowID)
		}
		if ((PatObj.CityDescLookUpRowID'="")&&(PatObj.CityDescLookUpRowID'=Vnull)){
			d person.PAPERCityCodeDRSetObjectId(PatObj.CityDescLookUpRowID)
		}
		if (PatObj.CityAreaLookUpRowID'="")&&(PatObj.CityAreaLookUpRowID'=Vnull){
			d person.PAPERCityAreaDRSetObjectId(PatObj.CityAreaLookUpRowID)
		}
		
		if (PatObj.NationDescLookUpRowID'="")&&(PatObj.NationDescLookUpRowID'=Vnull)
		{
			d person.PAPERNationDRSetObjectId(PatObj.NationDescLookUpRowID)
		}
		
		if (PatObj.CTRelationDR'="")&&(PatObj.CTRelationDR'=Vnull){
			d person.PAPERCTRLTDRSetObjectId(PatObj.CTRelationDR)
		}
		
		///PAPER_ForeignId
		s person.PAPERForeignId =PatObj.ForeignName
		
		;设定语言
		s myLangDR=$o(^SS("LAN",0,"Code","CHN",0))
		i (myLangDR'=""){
			d person.PAPERLangPrimDRSetObjectId(myLangDR)
		}
		s person.PAPERUpdateDate=PatObj.UpdateDate
		s person.PAPERUpdateTime=PatObj.UpdateTime
		;特定值
		s person.PAPEREstDOB="N"	;
		s person.PAPERIncompleteRegistration="N"
		
		s person.PAPERTelH=PatObj.TelHome		;家庭电话
		s person.PAPERTelO=PatObj.TelOffice		;单位电话
		;PAPER_EmployeeCompany
		;PAPER_EmployeeCompany
		;;集团/单位
		i (PatObj.EmployeeCompanyLookUpRowID'="")&&(PatObj.EmployeeCompanyLookUpRowID'=Vnull){
			d person.PAPEREmployeeCompanySetObjectId(PatObj.EmployeeCompanyLookUpRowID)
		}
		
		s person.PAPEREmail=PatObj.EMail
		
		;PAPEROccupationDR  职业
		if (PatObj.Vocation'="")&&(PatObj.Vocation'=Vnull)
		{
			d person.PAPEROccupationDRSetObjectId(PatObj.Vocation)
		}
		
		Set sc = person.%Save()
		s ^guo("Tstart",3)=PatObj.PatType_"^"_sc
		b ;PersonSave
		If ($System.Status.IsError(sc))
		{
			Do $System.Status.DisplayError(sc)
			Set myrtn = "-100"
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
				s myMAXNo=0
				i $d(^PAPER(0,"CNT","I")) d
				.;s myMAXNo=^PAPER(0,"CNT","I") //最大登记号
				e  d
				.s myMAXNo=0
				;s ^PAPER(0,"CNT","I")=myMAXNo+1
				s myMAXNo=$i(^PAPER(0,"CNT","I"))
				;s myMAXNo=myMAXNo+1
				s myPatLen=+$p(^CF("PATCF",1,3),"^",5)
				s myMAXNo=$e("0000000000000000000",1,myPatLen-$l(myMAXNo))_myMAXNo
				
				s patmas.PAPMINo=myMAXNo
				s patmas.PAPMIIPNo=myMAXNo
				s patmas.PAPMIOPNo=myMAXNo
			}
			s patmas.PAPMIMedicare=PatObj.InMedicare	;InMedicare
			;证件类型
			;PatObj.CredType
			i (PatObj.CredType'=""){
				d patmas.PAPMICardTypeDRSetObjectId(PatObj.CredType)
			}
			;PAPMI_MobPhone   移动电话
			s patmas.PAPMIMobPhone=PatObj.MobPhone
			;过敏史
			d patmas.PAPMIAllergy.Insert(PatObj.Allergy)
			
			;证件号码  有索引
			s patmas.PAPMIDVAnumber=PatObj.CredNo
			;有效
			s patmas.PAPMIActive="Y"
			
			Set sc = patmas.%Save()
			If ($System.Status.IsError(sc))
			{
				Do $System.Status.DisplayError(sc)
				Set myrtn = "-101"
			}
			;&&(PatObj.IDCardNo1)
			if ((+myrtn=0)){
				s myrtn=+..UpdatePAPMSID(PAPMIRowID,PatObj.IDCardNo1)
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
		if (OtherCard'=""){
			s myrtn=..SaveOtherCardInfo(PAPMIRowID,OtherCard)
		}
	
	q myrtn_"^"_PAPMIRowID
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

Storage Default
{
<Data name="UCardPaPatMasInfoDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^CHSSWeb.Reg4E3.UCardPaPatMa652D</DataLocation>
<DefaultData>UCardPaPatMasInfoDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSSWeb.Reg4E3.UCardPaPatMa652D</IdLocation>
<IndexLocation>^CHSSWeb.Reg4E3.UCardPaPatMa652I</IndexLocation>
<StreamLocation>^CHSSWeb.Reg4E3.UCardPaPatMa652S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
