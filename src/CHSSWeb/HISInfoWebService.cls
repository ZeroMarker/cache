Class CHSSWeb.HISInfoWebService Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

ClassMethod PersonListFromHIS(CardNumber As %String) As %String
{
	s count = 0
	s start = 0
	s resultString = ""
	s end = 1
	
	s json = ##class(Code.JsonObj).%New()
	s PersonHisInfo=##class(CHSS.PersonHISInfoXml).%New()

	s export =##class(CHSSWeb.soap.HealthFileTranCardServiceSoap).%New()	
	;000000000001212
	s CardNumberXml = "<Request><CardNumber>"_CardNumber_"</CardNumber></Request>"
	s tempPersonXml = export.HealthFileCheckCard(CardNumberXml)
	s reader=##Class(%XML.Reader).%New()
	s sc=reader.OpenString(tempPersonXml)
	;Request
	d reader.Correlate("Response","CHSS.PersonHISInfoXml")
	s CardNumber = ""
	s PersonName = ""
	s SexDR = ""
	s Birth = ""
	s IDCardTypeDR = ""
	s IDCard = ""
	s Address = ""
	s LinkManPhone = ""
	
	while reader.Next(.healthfile,.sc) {
		if healthfile.CardNumber'="" {
		s CardNumber = healthfile.CardNumber
		s PersonName = healthfile.PersonName
		s SexDR =healthfile.SexDR
		s Birth = healthfile.Birth
		s IDCardTypeDR = healthfile.IDCardTypeDR
		s IDCard = healthfile.IDCard
		s Address = healthfile.Address
		s LinkManPhone = ""
		s count = 1
			}
	
	}
	
	Set tmp= CardNumber_"^"_PersonName_"^"_SexDR_"^"_Birth_"^"_IDCard_"^"_LinkManPhone
	If (count>start)&(count<=end) d
	.d json.InsertRowData(tmp)
	    //Set resultString = json.getJsonData("CardNumber^PersonName^SexDR^Birth^SpellCode^CardNumber^IDCard^BirthPlace^WorkPlace^NationalityDR^NationDR^BloodTypeDR^MarriageDR^EducationDR^ProfessionDR",count)
	 s resultString = json.getJsonData("CardNumber^PersonName^SexDR^Birth^IDCard^LinkManPhone",count)
	 	
	 k json
	 	
	 Quit resultString
}

ClassMethod SavePCAInfoToServerCHSS(PersonCode As %String, CommunityCode As %String, PersonName As %String, SexDR As %Integer, Birth As %Date, SpellCode As %String, CardNumber As %String, IDCard As %String, BirthPlace As %String, DateOfWork As %Date, WorkPlace As %String, DateOFRetire As %Date, DeformityCode As %String, RelationHourseHoldDR As %Integer, DoctorRegister As %Integer, NurseRegister As %Integer, OperatorInput As %Integer, NationalityDR As %Integer, FamilyRowId As %Integer, HouseHoldTypeDR As %Integer, DocimialTypeDR As %Integer, MedicalInsuranceTypeDR As %Integer, PointHospitalRowIdDR As %Integer, CommitteeDR As %Integer, PoliceRowIdDR As %Integer, StreetRowIdDR As %Integer, DeformityType As %Integer, StaffOfUpdate As %Integer, DateOfUpdate As %Date, NationDR As %Integer, BloodTypeDR As %Integer, MarriageDR As %Integer, EducationDR As %Integer, ProfessionDR As %Integer, DateRegister As %Date, DateInput As %Date, IDCardTypeDR As %Integer, DateOfIDStart As %Date, DateOfIDEnd As %Date, IDCardProvider As %String, MedicalInsuranceID As %String, Address As %String, AddressTypeDR As %Integer, LinkManName As %String, LinkManPhone As %String, HosDiagnoseId As %String, bSaveCardInfo As %String) As %String
{
	q:(CardNumber = "") "0"
	q:(IDCard = "") "0"
	q:(SexDR = "") "0"
	;判断是否发卡
	q:(bSaveCardInfo '= "1") "0"
	;默认发卡人员为208
	s OperatorInput = "208"
	s SpellCode = ""
	s Sex = ""
	i SexDR = 1 d
	.s Sex = "男"
	e  i SexDR = 2 d
	.s Sex = "女"
	i Birth '= "" d
	.s Birth=$zd(Birth,3)
	;卡类型;38(00502)
	s CardType = "38"
	;患者类别
	s PatType = "1"
	s PaPatInfo = ..GetPatientXML(PersonName,PersonCode, Address, Birth, Sex, SpellCode, IDCard, LinkManPhone, OperatorInput, IDCardTypeDR,PatType,CardType,CardNumber)
	//s PaPatInfo="<Request><Name>测试3</Name><Sex>男</Sex><CredType>3</CredType><CredNo>140109851007101</CredNo><Birth>"_Birth_"</Birth><Address>成都市</Address><TelHome>13880420460</TelHome><PatType>1</PatType><CardType>38</CardType><CardNo>005020000000107</CardNo><UserDR>208</UserDR></Request>"
    ;w PaPatInfo
    ;q ""
	s import =##class(CHSSWeb.soap.HealthFileTranCardServiceSoap).%New()	
	s resultStr = import.HealthFileTranCard(PaPatInfo)
	//s ^test("CradInfo")=resultStr
	//k ^test("CradInfo")
	q resultStr
}

ClassMethod SaveTest() As %String
{
	s Birth = "1985-10-07"
	
	;s PaPatInfo = ..GetPatientXML(PersonName,PersonCode, Address, Birth, Sex, SpellCode, IDCard, LinkManPhone, OperatorInput, IDCardTypeDR,"1","23",CardNumber)
	s PaPatInfo="<Request><Name>测试</Name><Sex>男</Sex><CredType>3</CredType><CredNo>140109851007101</CredNo><Birth>"_Birth_"</Birth><Address>成都市</Address><TelHome>13880420460</TelHome><PatType>1</PatType><CardType>38</CardType><CardNo>005020000000107</CardNo><UserDR>208</UserDR></Request>"
	s import =##class(CHSSWeb.soap.HealthFileTranCardServiceSoap).%New()	
	s resultStr = import.HealthFileTranCard(PaPatInfo)
	q resultStr
}

ClassMethod GetCardTypeXML() As %String
{
	s xml = "<CardTypeConfig><AccManageFLag>N</AccManageFLag><CardAccountRelation>N</CardAccountRelation><CardFareCost>2</CardFareCost><CardRefFlag>Y</CardRefFlag><FareType>C</FareType><GroupRegFlag>PR</GroupRegFlag><PANoCardRefFlag>Y</PANoCardRefFlag><PatMasFlag>Y</PatMasFlag><SecurityNoFlag>Y</SecurityNoFlag><StChangeValidateFlag>Y</StChangeValidateFlag><UseINVType>R</UseINVType></CardTypeConfig>"

	q xml
}

ClassMethod GetPatientXML(Name, PersonCode, Address, Birth, Sex, SpellCode, IDCard, LinkManPhone, UserId, CredType, PatType, CardType, CardNo) As %String
{
	s patientxml = "<Request><Name>"_Name_"</Name><Sex>"_Sex_"</Sex><Birth>"_Birth_"</Birth><CredType>"_CredType_"</CredType><CredNo>"_IDCard_"</CredNo><Address>"_Address_"</Address><TelHome>"_LinkManPhone_"</TelHome><PatType>"_PatType_"</PatType><CardType>"_CardType_"</CardType><CardNo>"_CardNo_"</CardNo><UserDR>"_UserId_"</UserDR></Request>"
	
	q patientxml
}

ClassMethod GetCardRefXML(CardNumber As %String, CardType As %String, IDCard As %String, UserId As %String) As %String
{
	s xml = "<CardRef><ActiveFlag></ActiveFlag><CFAccNoDR></CFAccNoDR><CFDate></CFDate><CFTime></CFTime><CardINVPRTDR></CardINVPRTDR><CardNo>"_CardNumber_"</CardNo><CardRowID></CardRowID><CardTypeDefine>16</CardTypeDefine><ComputerIP>PC-200811181422</ComputerIP><CredNo>"_IDCard_"</CredNo><FareType></FareType><Organ></Organ><PAPMINo></PAPMINo><PAPMIRowID></PAPMIRowID><SecurityNo></SecurityNo><UserDR>"_UserId_"</UserDR></CardRef>"
	
	q xml
}

ClassMethod GetCardINVPRTXML(CardFareCost As %String, PayModel As %String, UserId As %String) As %String
{
	s xml = "<CardINVPRT><Bank></Bank><BankCardType></BankCardType><CardChequeNo></CardChequeNo><CardFareCost>"_CardFareCost_"</CardFareCost><ChequeDate></ChequeDate><Date></Date><Flag></Flag><PAPMIRowID></PAPMIRowID><PayAccNo></PayAccNo><PayCompany></PayCompany><PayMode>"_PayModel_"</PayMode><ReceiptNO></ReceiptNO><Remark></Remark><Time></Time><UserDR>"_UserId_"</UserDR></CardINVPRT>"
	q xml
}

}
