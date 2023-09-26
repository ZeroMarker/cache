Class dhcinterface.Portal.Registration Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

/// ##class(dhcinterface.Portal.Registration).AutoRegister("13775043","13797282")
ClassMethod AutoRegister(PatientID As %String = "", CardRowID As %String = "") As %String
{
	Set $ZTrap = "AutoRegisterET"
	set rtn=""
	if CardRowID="" quit rtn
	set myCardObj=##class(User.DHCCardRef).%OpenId(CardRowID)
	if '$IsObject(myCardObj) quit rtn
	if PatientID="" quit rtn
	set myPapmiObj=##Class(User.PAPatMas).%OpenId(PatientID)
	set myPaperObj=##Class(User.PAPerson).%OpenId(PatientID)
	if '$IsObject(myPapmiObj) quit rtn
	set myCheck=..CheckCardType(myCardObj.CFCardTypeDR.CTDCode)
	b   //
	if (myCheck'="1")
	{
		do myCardObj.%Close()
		do myPapmiObj.%Close()
		do myPaperObj.%Close()
		quit rtn
	}
	b
	set myObj=##Class(dhcinterface.Portal.RegInfoRequest).%New()
	set myObj.LoginName=myCardObj.CFCardNo
	set mylen=$length(myCardObj.CFCardNo)
	set myPassword=$Extract(myCardObj.CFCardNo,mylen-5,mylen)   //默认密码是卡号的后六位
	set myObj.Password=myPassword
	set Address=""
	set myArrCount=myPaperObj.PAPERStName.Count()
	if myArrCount>0 set Address=myPaperObj.PAPERStName.GetAt(myArrCount)
	set myObj.Adress=Address
	set myObj.DateofBirth=myPaperObj.PAPERDob
	set myBirthYear=+$ZDate(myPaperObj.PAPERDob,3)
	set myYear=$ZDate(+$H,3)
	set myObj.Age=myYear-myBirthYear
	set myObj.NickName=myPaperObj.PAPERName
	set myObj.CompanyName=myPaperObj.PAPEREmployeeCompany.CTCODesc
	set myObj.CredentialTypeCode=myPapmiObj.PAPMICardTypeDR.CARDCode
	set myObj.CredentialNo=myPapmiObj.PAPMIDVAnumber
	set myObj.SafeEmal=myPaperObj.PAPEREmail
	set myObj.Name=myPaperObj.PAPERName
	set myObj.Gender=myPaperObj.PAPERSexDR.CTSEXCode
	set myObj.OrganCode="1"
	set myObj.PatientNo=myPapmiObj.PAPMIOPNo
	set myObj.CardType=myCardObj.CFCardTypeDR.CTDCode
	set myObj.CardNo=myCardObj.CFCardNo
	do myObj.XMLExportToString(.XMLData,"Request")
	b ;XMLData
	set myWebObj=##Class(dhcinterface.Portal.SOAP.RegistrationSoap).%New()
	set rtn=myWebObj.AutoRegister(XMLData)
	
	quit rtn
AutoRegisterET
	quit "Error:"_$ZERROR
}

ClassMethod CheckCardType(CardTypeCode As %String) As %String
{
	
	set myrtn1="0"
	if $get(CardTypeCode)="" quit myrtn1
	set CardTypeCode=$ZConvert("^"_CardTypeCode_"^","U")
	set CardTypeCodeAllow="^ABC^BC^ICBC^CBC^"
	//set CardTypeCodeAllow="^jhyyk^"
	set CardTypeCodeAllow=$ZConvert(CardTypeCodeAllow,"U")
	if CardTypeCodeAllow[CardTypeCode quit "1"
	quit myrtn1
}

ClassMethod UpdateCardStatus(PatientID As %String = "", CardRowID As %String = "", NewCardRowID As %String = "") As %String
{
	Set $ZTrap = "UpdateCardStatusET"
	set rtn=""
	if CardRowID="" quit rtn
	set myCardObj=##class(User.DHCCardRef).%OpenId(CardRowID)
	if '$IsObject(myCardObj) quit rtn
	set myCheck=..CheckCardType(myCardObj.CFCardTypeDR.CTDCode)
	if (myCheck'="1")
	{
		do myCardObj.%Close()
		quit rtn
	}
	if PatientID="" quit rtn
	set myPapmiObj=##Class(User.PAPatMas).%OpenId(PatientID)
	set myPaperObj=##Class(User.PAPerson).%OpenId(PatientID)
	if '$IsObject(myPapmiObj) 
	{
		do myCardObj.%Close()
		quit rtn
	}
	
	
	
	set CardStatus="Y"
	if (myCardObj.CFActiveFlag'="N")&&(myCardObj.CFActiveFlag'="UA") set CardStatus="N"
	
	set NewCardNo=""
	if (NewCardRowID'="")
	{
		set NewCardNo=$piece($get(^DHCCARD("CF",NewCardRowID)),"^",2)
		
	}
	set myObj=##Class(dhcinterface.Portal.UpdateCardStatusRt).%New()
	set myObj.Name=myPaperObj.PAPERName
	set myObj.PatientNo=myPapmiObj.PAPMIOPNo
	set myObj.CardType=myCardObj.CFCardTypeDR.CTDCode
	set myObj.CardNo=myCardObj.CFCardNo
	set myObj.CardStatus=CardStatus
	set myObj.NewCardNo=NewCardNo
	do myObj.XMLExportToString(.XMLData,"Request")
	
	set myWebObj=##Class(dhcinterface.Portal.SOAP.RegistrationSoap).%New()
	set rtn=myWebObj.UpdateCardStatus(XMLData)
	
	do myCardObj.%Close()
	do myPapmiObj.%Close()
	do myPaperObj.%Close()
	do myObj.%Close()
	do myWebObj.%Close()
	quit rtn
UpdateCardStatusET
	quit "Error:"_$ZERROR
}

ClassMethod TaskRegister(StartDate) As %String
{
	Set $ZTrap = "TaskRegisterET"
	set rtn=""
	if StartDate="" quit rtn
	if StartDate["-" set StartDate=$ZDateH(StartDate,3)
	set myCardID=""
	while ($order(^DHCCARDi("CF",0,"Date",StartDate,myCardID))'="")
	{
		set myCardID=$order(^DHCCARDi("CF",0,"Date",StartDate,myCardID))
		set myPatientID=$piece($get(^DHCCARD("CF",myCardID)),"^",4)
		set myActiveFlag=$piece($get(^DHCCARD("CF",myCardID)),"^",10)
		if (myActiveFlag'="N") continue
		set rtn=..AutoRegister(myPatientID,myCardID)
		hang 1
	}
	quit rtn
TaskRegisterET
	quit "Error:"_$ZERROR
}

// w ##Class(dhcinterface.Portal.Registration).RegistrationManual("2010-04-15","2010-04-12")

ClassMethod RegistrationManual(StartDate As %String = "", EndDate As %String = "") As %String
{
	Set $ZTrap="RegManualET"
	set rtn=""
	if (StartDate="")||(EndDate="") quit ""
	if StartDate["-" set StartDate=$ZDateH(StartDate,3)
	if EndDate["-" set EndDate=$ZDateH(EndDate,3)
	set myDate=StartDate-1
	while($order(^DHCCARDi("CF",0,"Date",myDate))'>EndDate)
	{
		set myDate=$order(^DHCCARDi("CF",0,"Date",myDate))
		set myCardID=""
		while($order(^DHCCARDi("CF",0,"Date",myDate,myCardID))'="")
		{
			set myCardID=$order(^DHCCARDi("CF",0,"Date",myDate,myCardID))
			set CardStatus=$piece($get(^DHCCARD("CF",myCardID)),"^",10)
			if CardStatus'="N" continue
			set myLocalPMI=$piece($get(^DHCCARD("CF",myCardID)),"^",4)
			set rtn=..AutoRegister(myLocalPMI,myCardID)
			hang 1
		}
	}
	quit rtn
	
RegManualET
	quit "Error:"_$ZERROR
}

}
