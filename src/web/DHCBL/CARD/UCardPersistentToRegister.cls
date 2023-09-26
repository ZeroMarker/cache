/// 提供存储类到注册实体类的转换方法
Class web.DHCBL.CARD.UCardPersistentToRegister Extends %RegisteredObject
{

ClassMethod GetCardPatInfoRegByPAPMIDR(PAPMIDR As %String, ExpStr As %String) As %ObjectHandle
{
	s myregobj=##class(web.DHCEntity.PCA.CardPatInfoReg).%New()
	
	;
	s myregobj.PAPMIRowID=$g(PAPMIDR)
	
	Set patmas = ##class(User.PAPatMas).%OpenId(myPAPMIDR)
	s myregobj.PatYBCode= patmas.PAPMIName3
	s myregobj.PAPMINo = patmas.PAPMINo
	d patmas.%Close()
	
		Set myregobj.Name = person.PAPERName
		
		s myregobj.OpMedicare = person.PAPERGovernCardNo	;门诊病历号
		s myBirth=person.PAPERDob
		Set myregobj.Birth = myBirth
		
		s PatObj.Address= person.PAPERStName
		
		s PatObj.PatType= person.PAPERSocialStatusDRSetObjectId()
		
		s myregobj.Sex=person.PAPERSexDRSetObjectId()
		
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
				
			}
		}
		Else
		{
			Set myrtn = "-102"
		}
	
	q myregobj
}

}
