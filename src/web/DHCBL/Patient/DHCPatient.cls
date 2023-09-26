Class web.DHCBL.Patient.DHCPatient Extends (DHCDoc.Util.RegisteredObject, %XML.Adaptor) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

ClassMethod OutpatientMRIndex(PatientID As %String) As %String
{
	;d ##class(web.DHCBL.Patient.DHCPatient).OutpatientMRIndex("")
	n (PatientID)
	Set Name = "",Sex = "",Dob = "",Occupation = ""
	Set Street = "",Nation = "",Allergy="",PatientNo = ""
	
	&sql(
		SELECT PAPER_Name,
		PAPER_Sex_DR->CTSEX_Desc,
		PAPER_Dob,
		PAPER_Occupation_DR->CTOCC_Desc,
		PAPER_StNameLine1,	
		PAPER_Nation_DR->CTNAT_Desc,
		PAPER_PAPMI_DR->PAPMI_Allergy,
		PAPER_RowId	
		into :Name,:Sex,:Dob,:Occupation,
		:Street,:Nation,:Allergy,:PatientNo
			FROM SQLUser.PA_Person
				WHERE PAPER_RowId = :PatientID
	)
	
	Quit Name _ "^" _ Sex _ "^" _ Dob_ "^" _ Occupation_ "^" _ Street_ "^" _ Nation_ "^" _ Allergy_ "^" _ PatientNo
}

/// 删除PAPerson
ClassMethod PAPersonDelete(PAPersonInfo As web.DHCEntity.PCA.PAPerson) As %String
{
 TStart
 set sc= ##class(User.PAPerson).%DeleteId(PAPersonInfo.ID)

 If $$$ISERR(sc) {
 Do $System.Status.DisplayError()
 Trollback
 Quit -100
 }
 TCommit
 quit 0
}

/// 更新PAPerson
ClassMethod PAPersonUpdate(PAPersonInfo As web.DHCEntity.PCA.PAPerson) As %String
{
	//Set ^zjtest = "ID:"_PAPersonInfo.ID
	//set ^linli("OccupationDR")=PAPersonInfo.PAPEROccupationDR
 TStart

 set object=##class(User.PAPerson).%OpenId(PAPersonInfo.ID)  

 if ((PAPersonInfo.PAPERCityAreaDR '= "") && (PAPersonInfo.PAPERCityAreaDR '= $c(0)))
 {
 do object.PAPERCityAreaDRSetObjectId(PAPersonInfo.PAPERCityAreaDR)
 }
 
 ///市
 if ((PAPersonInfo.PAPERCityCodeDR '= "") && (PAPersonInfo.PAPERCityCodeDR '= $c(0)))
 {
	if PAPersonInfo.PAPERCityCodeDR=" " s PAPersonInfo.PAPERCityCodeDR=""
	if (object.PAPERCityCodeDR'=PAPersonInfo.PAPERCityCodeDR){
		 do object.PAPERCityAreaDRSetObjectId("")
	}
	do object.PAPERCityCodeDRSetObjectId(PAPersonInfo.PAPERCityCodeDR)
 }
 ///国家
 if ((PAPersonInfo.PAPERCountryDR '= "") && (PAPersonInfo.PAPERCountryDR '= $c(0)))
 {
	if PAPersonInfo.PAPERCountryDR=" " s PAPersonInfo.PAPERCountryDR=""
 	do object.PAPERCountryDRSetObjectId(PAPersonInfo.PAPERCountryDR)
 }

 ///省PAPERCTProvinceDR
 if ((PAPersonInfo.PAPERCTProvinceDR '="")&&(PAPersonInfo.PAPERCTProvinceDR'=$c(0))){
	if PAPersonInfo.PAPERCTProvinceDR=" " s PAPersonInfo.PAPERCTProvinceDR=""
 	do object.PAPERCTProvinceDRSetObjectId(PAPersonInfo.PAPERCTProvinceDR)
 }

 if ((PAPersonInfo.PAPERDob '="") && (PAPersonInfo.PAPERDob '= $c(0))){
 	set object.PAPERDob=..%ZDH(PAPersonInfo.PAPERDob) //$zdh(PAPersonInfo.PAPERDob,3)
 }

 if ((PAPersonInfo.PAPEREducationDR '= "") && (PAPersonInfo.PAPEREducationDR '= $c(0))){
 	do object.PAPEREducationDRSetObjectId(PAPersonInfo.PAPEREducationDR)
 }
 set object.PAPEREmail = PAPersonInfo.PAPEREmail
 set object.PAPERName=PAPersonInfo.PAPERName
 set object.PAPERName2=##class(ext.util.String).ToChineseSpell(PAPersonInfo.PAPERName)
 Set object.PAPERName3 = ##class(web.DHCINSUPort).GetCNCODE(PAPersonInfo.PAPERName,3,"")
 if ((PAPersonInfo.PAPERNationDR '= "") && (PAPersonInfo.PAPERNationDR '= $c(0))){
 	do object.PAPERNationDRSetObjectId(PAPersonInfo.PAPERNationDR)
 }

 //if ((PAPersonInfo.PAPEROccupationDR '= "") && (PAPersonInfo.PAPEROccupationDR '= $c(0)))
 if (PAPersonInfo.PAPEROccupationDR '= $c(0)){
 	do object.PAPEROccupationDRSetObjectId(PAPersonInfo.PAPEROccupationDR)
 }

 if ((PAPersonInfo.PAPERSexDR '= "") && (PAPersonInfo.PAPERSexDR '= $c(0))){
 	do object.PAPERSexDRSetObjectId(PAPersonInfo.PAPERSexDR)
 }
 
 s PrePatTypeId=""
 i $IsObject(object.PAPERSocialStatusDR) s PrePatTypeId=object.PAPERSocialStatusDR.%Id()
 if ((PAPersonInfo.PAPERSocialStatusDR '= "") && (PAPersonInfo.PAPERSocialStatusDR '= $c(0))){
 	do object.PAPERSocialStatusDRSetObjectId(PAPersonInfo.PAPERSocialStatusDR)
 }
 
 if ((PAPersonInfo.PAPERZipDR '= "") && (PAPersonInfo.PAPERZipDR '= $c(0))){
 	do object.PAPERZipDRSetObjectId(PAPersonInfo.PAPERZipDR)
 }
 ///家庭地址
 /// 
 // s ^Linli("PAPERStName")= PAPersonInfo.PAPERForeignAddress
 //s mycount=object.PAPERStName.Count()
 d object.PAPERStName.Clear() 
 d object.PAPERStName.Insert(PAPersonInfo.PAPERForeignAddress)

 ///联系电话

 set object.PAPERTelH = PAPersonInfo.TelHome 

 ///联系人

 set object.PAPERForeignId =PAPersonInfo.PAPERForeignId
 ///联系人电话
 set object.PAPERForeignPhone=PAPersonInfo.ForeignPhone
 ///家庭 

 if ((PAPersonInfo.PAPERCTRLTDR '="")&&(PAPersonInfo.PAPERCTRLTDR'=$c(0))){
	 do object.PAPERCTRLTDRSetObjectId(PAPersonInfo.PAPERCTRLTDR)
 }
 //工号  2011-07-20
 s object.PAPEREmployeeNo=PAPersonInfo.EmployeeNo
 ///PAPER_Marital_DR   婚姻状况
 if (PAPersonInfo.PAPERMarital'="")&&(PAPersonInfo.PAPERMarital'=$c(0)){
 	Do object.PAPERMaritalDRSetObjectId(PAPersonInfo.PAPERMarital)
 }
 ///病人级别 
 if (PAPersonInfo.PoliticalLevel'="")&&(PAPersonInfo.PoliticalLevel'=$c(0)){
	d object.PAPEREmployeeFunctionSetObjectId(PAPersonInfo.PoliticalLevel)
 }
 //set object.PAPERCTRLTDR = PAPersonInfo.PAPERCTRLTDR
 //set object.PAPERStName=PAPersonInfo.PAPERStName
 set object.PAPERTelH=PAPersonInfo.PAPERTelH
 set object.PAPERUpdateDate= +$h
 //合同单位
 d object.PAPERHCPDRSetObjectId(PAPersonInfo.HCPDR)
	 set sc=object.%Save()
	 If $$$ISERR(sc) {
	 Do $System.Status.DisplayError(sc)
	 Trollback
	 Quit -100
 }
 if (PAPersonInfo.BirthTime'=""){
    s myBirthTime=..%ZTH(PAPersonInfo.BirthTime)
    s DHCPatObj=##class(User.DHCPAPatMas).%OpenId(PAPersonInfo.ID)
    s DHCPatObj.PAPMIBirthTime=myBirthTime
    s sc=DHCPatObj.%Save()
    //为-1041则说明是DHC_PA_PatMas表插入错误
    if $$$ISERR(sc) {
	    s myrtn="-1041"
	    quit myrtn
    }
    d DHCPatObj.%Close()
}
 ;根据设置确定是否更新当日及以后就诊记录费别
 s CFMedifyPatTypeSynAdmRea=##class(web.DHCOPRegConfig).GetSpecConfigNode("MedifyPatTypeSynAdmRea")
 i (CFMedifyPatTypeSynAdmRea=1)&&(PrePatTypeId'=PAPersonInfo.PAPERSocialStatusDR) {
	d ..UpdateAdmedReason(PAPersonInfo.ID)
 }
 set objectM = ##class(User.PAPatMas).%OpenId(PAPersonInfo.ID)
 ///过敏史PAPMIAllergy

 //if ((PAPersonInfo.PAPMIAllergy '="") && (PAPersonInfo.PAPMIAllergy '=$c(0)))
 if (PAPersonInfo.PAPMIAllergy '=$c(0))
 {
	if (objectM.PAPMIAllergy.Count()=0)
	{
		do objectM.PAPMIAllergy.Insert(PAPersonInfo.PAPMIAllergy)
	}
	else
	{
		do objectM.PAPMIAllergy.SetAt(PAPersonInfo.PAPMIAllergy,1)
	}
 }
 ///证件类型
 if ((PAPersonInfo.PAPMICardTypeDR '="")&&(PAPersonInfo.PAPMICardTypeDR'=$c(0)))
 {
	if PAPersonInfo.PAPMICardTypeDR=" " s PAPersonInfo.PAPMICardTypeDR=""
 	do objectM.PAPMICardTypeDRSetObjectId(PAPersonInfo.PAPMICardTypeDR)
 }

 set objectM.PAPMIDVAnumber =PAPersonInfo.PAPERID //$ZCONVERT(PAPersonInfo.PAPERID,"U")
 //医保号 工作单位
 set objectM.PAPMIHealthFundNo=PAPersonInfo.InsuranceNo
 set objectM.PAPMISecondPhone=PAPersonInfo.PAPERCompany
 
 set ss = objectM.%Save()
 If $$$ISERR(ss) {
 Do $System.Status.DisplayError(ss)
 Trollback
 Quit -100
 }
 ;根据病人ID和身份证号同步卡表DHC_CardRef的身份证号字段
 s myrtn=##class(web.DHCBL.CARD.UCardRefInfo).UpdateDHCCardIDNo(PAPersonInfo.ID,PAPersonInfo.PAPERID,PAPersonInfo.PAPMICardTypeDR)
 if +myrtn {
 Trollback
 Quit -100	    
 }
 ///病人密级 密级表 DHC_ SecretLevel
 s $P(^PAPER(PAPersonInfo.ID ,"DHC"),"^",30)=PAPersonInfo.SecretLevel
 s myPAID=""
 set card= ##class(User.PACCardType).%OpenId(PAPersonInfo.PAPMICardTypeDR)
 if ($IsObject(card)){
	 if card.CARDCode ="01"
	 {
	 	set myPAID= $ZCONVERT(PAPersonInfo.PAPERID,"U")
	 }
 }

 s myrtn=##class(web.DHCBL.CARD.UCardPaPatMasInfo).UpdatePAPMSID(PAPersonInfo.ID, myPAID)
 if +myrtn {
 Trollback
 Quit -100	    
 }
 
 Set OtherCard=PAPersonInfo.OtherCardInfo
 if (OtherCard'=""){
	s myrtn=##Class(web.DHCBL.CARD.UCardPaPatMasInfo).SaveOtherCardInfo(PAPersonInfo.ID,OtherCard)
	if +myrtn {
		Trollback
		Quit -101
	}
 }

 TCommit
 quit object.%Id()
}

/// w ##class(web.DHCBL.Patient.DHCPatient).GetOtherCredInfo(1)
ClassMethod GetOtherCredInfo(PAPMIRowId As %String) As %String
{
	s retStr=""
	Q:PAPMIRowId="" retStr
	s CredType=0
	for {
		s CredType=$O(^DHCPCNi("PAPMI",PAPMIRowId,CredType))
		q:CredType=""
		s DHCPCNROWID=0
		for {
			s DHCPCNROWID=$O(^DHCPCNi("PAPMI",PAPMIRowId,CredType,DHCPCNROWID))
			Q:DHCPCNROWID=""
			s CredNo=$P($g(^DHCPCN(DHCPCNROWID)),"^",4)
			if retStr="" s retStr=CredType_"^"_CredNo
			else  s retStr=retStr_"!"_CredType_"^"_CredNo
		}
	}
    
    Q retStr
}

ClassMethod PatUniInfoQuery(PatientDr As %String, Type As %String, NoStr As %String) As %String
{
	set Rtn=0
	q:(PatientDr="")&&(Type'="InsuNo") Rtn
	q:NoStr="" Rtn

	set ^DHCAA=Type_"^"_NoStr
	if Type="EOP" d
	.s NoStr=$ZCVT(NoStr,"U")
	.s NoStr=NoStr_"Z"
	.s PapmiRowid=0  f  s PapmiRowid=$o(^PAPERi("Govern",NoStr,PapmiRowid)) q:PapmiRowid=""  d
	..q:PapmiRowid=PatientDr
	..s CardRowId=$o(^DHCCARDi("CF",0,"PAPMIDR",PapmiRowid,""),-1)
	..q:CardRowId=""
	..s status=$p(^DHCCARD("CF",CardRowId),"^",10)
	..q:status'="N"
	..s Rtn=Rtn+1
	
	if Type="EIP" d
	.s NoStr=$ZCVT(NoStr,"U")
	.s NoStr=NoStr_"Z"
	.s PapmiRowid=0  f  s PapmiRowid=$o(^PAPERi("Medicare",NoStr,PapmiRowid)) q:PapmiRowid=""  d
	..q:PapmiRowid=PatientDr
	..s CardRowId=$o(^DHCCARDi("CF",0,"PAPMIDR",PapmiRowid,""),-1)
	..q:CardRowId=""
	..s status=$p(^DHCCARD("CF",CardRowId),"^",10)
	..q:status'="N"
	..s Rtn=Rtn+1
	
	//set PersonRowId =$o(^DHCPERSON(0,"FCMedicareCode1",qNewOutMedicareNo,0))

		
	if Type="WOP" d
	.s DHCPapmiRowid=0  f  s DHCPapmiRowid=$o(^DHCPERSON(0,"FCMedicareCode1",NoStr,DHCPapmiRowid)) q:DHCPapmiRowid=""  d
	..s PapmiRowid=$p(^DHCPERSON(DHCPapmiRowid),"^",1)
	..q:PapmiRowid=PatientDr
	..s CardRowId=$o(^DHCCARDi("CF",0,"PAPMIDR",PapmiRowid,""),-1)
	..q:CardRowId=""
	..s status=$p(^DHCCARD("CF",CardRowId),"^",10)
	..q:status'="N"
	..s Rtn=Rtn+1

	
	
	if Type="WIP" d
	.s DHCPapmiRowid=0  f  s DHCPapmiRowid=$o(^DHCPERSON(0,"FCMedicareCode2",NoStr,DHCPapmiRowid)) q:DHCPapmiRowid=""  d
	..s PapmiRowid=$p(^DHCPERSON(DHCPapmiRowid),"^",1)
	..q:PapmiRowid=PatientDr
	..s CardRowId=$o(^DHCCARDi("CF",0,"PAPMIDR",PapmiRowid,""),-1)
	..q:CardRowId=""
	..//s ^DHCAA("CardRowId")=PapmiRowid_"^"_CardRowId
	..S status=""
	..s status=$p(^DHCCARD("CF",CardRowId),"^",10)
	..q:status'="N"
	..s Rtn=Rtn+1
	
	if Type="InsuNo" d
	.s NoStr=$ZCVT(NoStr,"U")
	.s PapmiRowid=0  f  s PapmiRowid=$o(^PAPERi("PAPER_HFundNo",NoStr,PapmiRowid)) q:PapmiRowid=""  d
	..q:PapmiRowid=PatientDr
	..s CardRowId=$o(^DHCCARDi("CF",0,"PAPMIDR",PapmiRowid,""),-1)
	..q:CardRowId=""
	..s status=""
	..s status=$p(^DHCCARD("CF",CardRowId),"^",10)
	..q:status'="N"
	..s Rtn=Rtn+1
	
	
	q Rtn
}

ClassMethod SelectByPAPERIDClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SelectByPAPERIDExecute ]
{
	Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// d ##class(%ResultSet).RunQuery("web.DHCBL.Patient.DHCPatient","SelectByPAPERID","","","","000000000120")
ClassMethod SelectByPAPERIDExecute(ByRef qHandle As %Binary, SPAPERID As %String, SPAPERName As %String, SPAPMINo As %String, CardNo As %String, OutMedicareNo As %String, InMedicareNo As %String, EmMedicare As %String) As %Status
{
	s ^DHCXPTest("PatQuery")=$LB(SPAPERID,SPAPERName,SPAPMINo,CardNo,OutMedicareNo,InMedicareNo,EmMedicare)
	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	s HospID=##Class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId("")
 	Set TID = ""
	Set PAPERID = $ZCONVERT(SPAPERID,"U")
	set PAPERName = $ZCONVERT(SPAPERName,"U")
	Set SPAPERName = PAPERName
	Set PAPMINo = SPAPMINo
	Set sCardNo =CardNo

	Set TPAPERAge=""
	Set TPAPERDob=""
	Set TPAPERID=""
	Set TPAPERName=""
	Set TPAPERNationDR=""
	Set TPAPEROccupationDR=""
	Set TPAPERSexDR=""
	Set TPAPERSocialStatusDR=""
	Set TPAPERCountryDR=""
	Set TPAPERCityCodeDR=""
	Set TPAPERCityAreaDR=""
	Set TPAPERZipDR=""
	Set TPAPERStName=""
	Set TPAPERTelO=""
	Set TPAPERTelH=""
	Set TPAPEREmail=""
	Set TPAPERUpdateDate=""
	Set TPAPERSex=""
	Set TPAPERNation=""
	Set TPAPEROccupation=""
	Set TPAPERSocialStatus=""
	Set TPAPERCountry=""
	Set TPAPERCityCode=""
	Set TPAPERCityArea=""
	Set TPAPERZip=""
	set TPAPMIAllergy=""
	set TTelHome=""
	set TPAPERForeignId=""
	set TPAPERForeign=""
	set TPAPERCTRLTDR=""
	set TPAPERCTRLT=""
	set TPAPMICardTypeDR=""
	set TPAPMICardType=""
	set TPAPERForeignAddress=""
	set TPAPERForeignAddress = ""
	set TPAPERCTProvinceDR=""
	set TPAPERCTProvince=""
	set TPAPMIDVAnumber =""
	set TPAPERCompany=""
	/// 工号  协和
	set TEmployeeNo=""
	/// 婚姻状况
	set TPAPERMarital=""
	/// 联系人电话
	set TForeignPhone=""
	set TPoliticalLevel=""
	set TSecretLevel=""
	
	set cardid=""
	If ((PAPERID = "" ) && (PAPERName = "") && (PAPMINo = "")&&(CardNo = "")&& (OutMedicareNo = "")&& (InMedicareNo = "")&& (EmMedicare = "")) goto end 
	s OutMedicareNo=$ZConvert(OutMedicareNo,"U")		;门诊病历号转换成大写	
	s InMedicareNo=$ZConvert(InMedicareNo,"U")			;住院病历号转换成大写	
	s EmMedicare=$ZConvert(EmMedicare,"U")				;急诊病历号转换成大写
	Set rowId = ""
	Set validation = 0
	if (PAPERID '= ""){
		Set rowId = $o(^PAPERi("DVA",PAPERID,0))
		Set validation = 1
	}elseif (PAPERName '= ""){
	    Set PAPERName = $o(^PAPERi("PAPER_PatName","")) //模糊查询
		While (PAPERName '[ SPAPERName){
			Set PAPERName = $o(^PAPERi("PAPER_PatName",PAPERName))
			if ( PAPERName="") quit
		}		
		if (PAPERName ="") {goto end}
		Set rowId =$o(^PAPERi("PAPER_PatName",PAPERName,0))
		Set validation = 2
	}elseif (sCardNo '=""){
		 set cardid=$o(^DHCCARDi("CF",0,"CardNo",sCardNo,0))
		 if cardid'=""{
		   set rowId=$p($g(^DHCCARD("CF",cardid)),"^",4)
		 }
		 set validation = 3
	}elseif (OutMedicareNo '=""){
		s OutMedicareNo=OutMedicareNo_"Z"
		set rowId =$o(^PAPERi("Govern",OutMedicareNo,0))
		set validation = 5
	}elseif (InMedicareNo '=""){
		//set rowId=##Class(web.DHCWMRService).IGetPatientIDByMrNo(InMedicareNo)
		s rowId=##class(MA.IPMR.IO.OutService).GetPatientIDByMrNo(InMedicareNo,"")
		set validation =6
	}elseif (EmMedicare '=""){
		set rowId = $o(^DHCPERSON(0,"FCMedicareCode1",EmMedicare,0))
		set validation = 7
	}else{
		If ($o(^PAPERi("PAPMI_PatNo",PAPMINo,0)) = ""){
			//Set PAPMINo = $o(^PAPERi("PAPMI_PatNo",PAPMINo))
		}
		if (PAPMINo'=""){
			Set rowId = $o(^PAPERi("PAPMI_PatNo",PAPMINo,0))
		}
		Set validation = 4
	}
	
	while (+rowId'=0){
		s ReturnFlag=""	
		Set TPAPMINo = ""
		Set TID = rowId
		If (+$p($g(^PAPER(rowId,"PAT",1)),"^",1) '=0){
			 Set TPAPMINo = $p($g(^PAPER(rowId,"PAT",1)),"^",1)
		}else{
			Set TPAPMINo = $p($g(^PAPER(rowId,"PAT",2)),"^",1)
		}
		i (SPAPMINo'="")&&(SPAPMINo'=TPAPMINo) s ReturnFlag="Y"
		//SPAPERID, CardNo, OutMedicareNo, InMedicareNo, EmMedicare
		Set TPAPERDob = $p($g(^PAPER(rowId,"ALL")),"^",6)
		s TPAPERAge=##class(web.DHCDocInterfaceMethod).DHCDocHisInterface("doc.reg.GetPapmiAge",rowId,"",HospID)
		Set TPAPERID = $p($g(^PAPER(rowId,"PAT",3)),"^",6)
		Set TPAPERName = $p($g(^PAPER(rowId,"ALL")),"^",1)
		i (SPAPERName'="")&&(TPAPERName'[SPAPERName) s ReturnFlag="Y"
		Set TPAPERNationDR = $p($g(^PAPER(rowId,"PER",2)),"^",1)
 		Set TPAPERNation = $s(+$p($g(^PAPER(rowId,"PER",2)),"^",1)'=0:$p($g(^CT("NAT",$p($g(^PAPER(rowId,"PER",2)),"^",1))),"^",2),1:"")

 		Set TPAPEROccupationDR = +$p($g(^PAPER(rowId,"PER",2)),"^",6)
		Set TPAPEROccupation = $s(+$p($g(^PAPER(rowId,"PER",2)),"^",6)'=0:$p($g(^CT("OCC",$p($g(^PAPER(rowId,"PER",2)),"^",6))),"^",2),1:"")
		
		Set TPAPERSexDR = $p($g(^PAPER(rowId,"ALL")),"^",7)
		Set TPAPERSex = $s(+$p($g(^PAPER(rowId,"ALL")),"^",7)'=0:$p($g(^CT("SEX",$p($g(^PAPER(rowId,"ALL")),"^",7))),"^",2),1:"")
		
		Set TPAPERSocialStatusDR = $p($g(^PAPER(rowId,"PER",1)),"^",10)
		Set TPAPERSocialStatus = $s(+$p($g(^PAPER(rowId,"PER",1)),"^",10)'=0:$p($g(^CT("SS",$p($g(^PAPER(rowId,"PER",1)),"^",10))),"^",2),1:"")
		
		Set TPAPERCountryDR = $p($g(^PAPER(rowId,"PER",1)),"^",8)
		Set TPAPERCountry =  $s(+$p($g(^PAPER(rowId,"PER",1)),"^",8)'=0:$p($g(^CT("COU",$p($g(^PAPER(rowId,"PER",1)),"^",8))),"^",2),1:"")
		
		set TPAPERCTProvinceDR = $p($g(^PAPER(rowId,"PER",4)),"^",2)
	    set TPAPERCTProvince = $s(+$p($g(^PAPER(rowId,"PER",4)),"^",2)'=0:$p($g(^CT("PROV",$p($g(^PAPER(rowId,"PER",4)),"^",2))),"^",2),1:"")
		
		Set TCountryHouseDR =$p($g(^PAPER(rowId,"ALL")),"^",11) //##class(web.DHCBL.CARD.UCardPaPatMasInfo).GetCountryByProvice(TPAPERCTProvinceDR) 
		Set TCountryHouse =  $s(+TCountryHouseDR'=0:$p($g(^CT("COU",TCountryHouseDR)),"^",2),1:"")
		
		Set TPAPERCityCodeDR = $p($g(^PAPER(rowId,"PER",1)),"^",5)
		Set TPAPERCityCode = $s(+$p($g(^PAPER(rowId,"PER",1)),"^",5)'=0:$p($g(^CT("CIT",$p($g(^PAPER(rowId,"PER",1)),"^",5))),"^",2),1:"")
		
		Set TPAPERCityAreaDR = $p($g(^PAPER(rowId,"PER",4)),"^",9)
		Set TPAPERCityArea = $s(+$p($g(^PAPER(rowId,"PER",4)),"^",9)'=0:$p($g(^CT("CITAREA",$p($g(^PAPER(rowId,"PER",4)),"^",9))),"^",2),1:"")
	
		Set TPAPERZipDR = $p($g(^PAPER(rowId,"PER",1)),"^",7)
		Set TPAPERZip = $s(+$p($g(^PAPER(rowId,"PER",1)),"^",7)'=0:$p($g(^CT("ZIP",$p($g(^PAPER(rowId,"PER",1)),"^",7))),"^",2),1:"")
		Set TPAPERStName = $g(^PAPER(rowId,"PER","ADD"))
		Set TPAPERTelO = $p($g(^PAPER(rowId,"PER",1)),"^",9)
		Set TPAPERTelH = $p($g(^PAPER(rowId,"PER",1)),"^",11)
		Set TPAPEREmail = $p($g(^PAPER(rowId,"PER",4)),"^",19)
		Set TPAPERUpdateDate = ..%ZD($p($g(^PAPER(rowId,"PER",5)),"^",2)) //$zd($p($g(^PAPER(rowId,"PER",5)),"^",2),3)
		//set AllergyListCount =$g(^PAPER(rowId,"ALLERGY",0))
		//过敏史只取第一个
		set TPAPMIAllergy=$g(^PAPER(rowId,"ALLERGY",1))
		/*
		For i=1:1:AllergyListCount
		{
			Set TPAPMIAllergy=TPAPMIAllergy_$g(^PAPER(rowId,"ALLERGY",0))
		}
		*/
	    set TTelHome=$p($g(^PAPER(rowId,"PER",1)),"^",11)
	    set TPAPERForeignId=$p($g(^PAPER(rowId,"PER",2)),"^",13)
	    set TPAPERForeign=$p($g(^PAPER(rowId,"PER",2)),"^",13)
	    set TPAPERCTRLTDR=$p($g(^PAPER(rowId,"EMP")),"^",4)
	    set TPAPERCTRLT= $s(+$p($g(^PAPER(rowId,"EMP")),"^",4)'=0:$p($g(^CT("RLT",$p($g(^PAPER(rowId,"EMP")),"^",4))),"^",2),1:"")
	    set TPAPMICardTypeDR=$p($g(^PAPER(rowId,"PAT",3)),"^",7)
	    set TPAPMICardType=$s(+$p($g(^PAPER(rowId,"PAT",3)),"^",7)'=0:$p($g(^PAC("CARD",$p($g(^PAPER(rowId,"PAT",3)),"^",7))),"^",2),1:"")
	    set TPAPERForeignAddress = $G(^PAPER(rowId,"PER","ADD",1))
	    
		set TPAPMIDVAnumber =$p($g(^PAPER(rowId,"PAT",3)),"^",6)
		i (SPAPERID'="")&&(TPAPMIDVAnumber'=SPAPERID) s ReturnFlag="Y"
		set TPAPERCompany=$p($g(^PAPER(rowId,"PER",4)),"^",18)
		
		set TForeignPhone=$p($g(^PAPER(rowId,"ALL")),"^",4)
		/// 工号  协和
		set TEmployeeNo=$p($g(^PAPER(rowId,"EMP")),"^",5) 
		/// 婚姻状况
		set TPAPERMarital=$p($g(^PAPER(rowId,"PER",2)),"^",3)
		set TPoliticalLevel=$p($g(^PAPER(rowId,"PER",3)),"^",3)
		set TSecretLevel=$p($g(^PAPER(rowId,"DHC")),"^",30)
		///合同单位
		set PAPERHCPDR=$p($g(^PAPER(rowId,"PER",4)),"^",17)
		s BirthTime=$p($g(^PAPER(rowId,"DHC")),"^",1)
		i BirthTime'="" s BirthTime=..%ZT(BirthTime,1)
		s TPAPERDob=..%ZD(TPAPERDob)
		s ForeignAddress=$p($g(^PAPER(rowId,"PER",1)),"^",1)
		s ForeignIDCard=$p($g(^PAPER(rowId,"PER",2)),"^",4)
		s ForeignCredType=$p($g(^PAPER(rowId,"ALL")),"^",25)
		s PatActive=$p($g(^PAPER(rowId,"PAT",1)),"^",6)
		s PatActive=$case(PatActive,"Y":"有效",:"无效")
		s PAPMILangSecondDR=$p($g(^PAPER(rowId,"PAT",2)),"^",4)
		s PAPMIEducation=$p($g(^PAPER(rowId,"PER",4)),"^",30)
		s PAPMILangPrimDR=$p($g(^PAPER(rowId,"ALL")),"^",10)
		s StreetNow=$p($g(^PAPER(rowId,"DHC")),"^",54)
		;是否存在新登记号
		s TNewPatNo=##class(web.DHCPATCardUnite).GetCardUnitNewByOld(TPAPMINo)
        ;新增获取卡号信息
        s (TCardID,TCardNo,TCardType,TCardTypeDesc)=""
        if cardid'="" {
            s TCardID=cardid
            s TCardNo=$P(^DHCCARD("CF",cardid),"^",2)
            s TCardType=$p($g(^DHCCARD("CF",cardid)),"^",16)
            s:TCardType'="" TCardTypeDesc=$P(^DHCCARDTYPEDef(TCardType),"^",2)
        }else{
            s CardInfo=##Class(web.DHCOPAdmReg).GetCardNoByPatientNo(TPAPMINo,HospID)
            if CardInfo'=""{
                s TCardNo=$p(CardInfo,"^",1)
                s TCardType=$p(CardInfo,"^",2)
                s TCardTypeDesc=$p(CardInfo,"^",3)
                s TCardID=$p(CardInfo,"^",6)
            }
        }
		//TPAPERCityAreaDR
		///联系人地址身份证号证件类型
		Set Data=$ListBuild(TID,TPAPMINo,TPAPERID,TPAPERName,TPAPERDob,TPAPERAge,TPAPERSexDR,
			TPAPERNationDR,TPAPEROccupationDR,TPAPERSocialStatusDR,
			TPAPERCountryDR,TPAPERCityCodeDR,TPAPERCityAreaDR,TPAPERZipDR,
			TPAPERStName,TPAPERTelO,TPAPERTelH,TPAPEREmail,TPAPERUpdateDate,
			TPAPERSex,TPAPERNation,TPAPEROccupation,TPAPERSocialStatus,
			TPAPERCountry,TPAPERCityCode,TPAPERCityArea,TPAPERZip,
			TPAPMIAllergy,TTelHome,TPAPERForeignId,TPAPERForeign,
			TPAPERCTRLTDR,TPAPERCTRLT,TPAPMICardTypeDR,TPAPMICardType,
			TPAPERForeignAddress,TPAPERCTProvinceDR,TPAPERCTProvince,TPAPMIDVAnumber,TPAPERCompany,
			TEmployeeNo,TPAPERMarital,TForeignPhone,TPoliticalLevel,TSecretLevel,PAPERHCPDR,BirthTime,
			TCountryHouseDR,TCountryHouse,ForeignAddress,ForeignIDCard,ForeignCredType,PatActive,PAPMILangPrimDR,
			PAPMILangSecondDR,PAPMIEducation,StreetNow,TNewPatNo,TCardID,TCardNo,TCardType,TCardTypeDesc
		)
		
		;通过卡号查询只要查询出卡状态为N的病人信息
		if (ReturnFlag'="Y"){
			if (+validation=3)&&(cardid'=""){
				Set CardStatus=$p($g(^DHCCARD("CF",cardid)),"^",10)	
				if (CardStatus="N")&&(((TPAPMINo=PAPMINo)&&(PAPMINo'=""))||(PAPMINo="")){
				    s PAPMIDOB=$p(^PAPER(rowId,"ALL"),"^",6)
					s ind1=100000+ind
					s Tind=PAPMIDOB_ind1
					Set ^CacheTemp(repid,Tind)=Data
		 			Set ind=ind+1		
				}
			}else{
				s PAPMIDOB=$p(^PAPER(rowId,"ALL"),"^",6)
				s ind1=100000+ind
				s Tind=PAPMIDOB_ind1
				Set ^CacheTemp(repid,Tind)=Data
		 		Set ind=ind+1
			}
		}
	 	if (+validation = 1) {
		 	Set rowId = $o(^PAPERi("DVA",PAPERID,rowId))
			if rowId =""{
				 quit
			 }
		}
	 	
	 	if (+validation=2){	
			Set rowId =$o(^PAPERi("PAPER_PatName",PAPERName,rowId))
			if (rowId = ""){
				 Set PAPERName = $o(^PAPERi("PAPER_PatName",PAPERName)) //模糊查询
				 if (PAPERName ="") quit  ; xp add,2008-05-05,避免可能出现的死循环
				  ; 如果查询的名字关键字包含在Global中的最后一个节点中，则出现死循环
				 While (PAPERName '[ SPAPERName){
					Set PAPERName = $o(^PAPERi("PAPER_PatName",PAPERName))
					if (PAPERName ="") quit 
				 }
				 if ( PAPERName ="") quit	
				 Set rowId =$o(^PAPERi("PAPER_PatName",PAPERName,0))
		    }
			if ( PAPERName ="") quit
			
		}elseif (+validation=3){
			set cardid=$o(^DHCCARDi("CF",0,"CardNo",sCardNo,cardid))
			if cardid'=""{
			 	 set rowId=$p($g(^DHCCARD("CF",cardid)),"^",4)
			}else{
				quit
			}
		}elseif (+validation=4){
			Set PAPMINo = $o(^PAPERi("PAPMI_PatNo",PAPMINo))
			if ($extract(PAPMINo,1,$Length(SPAPMINo))'=SPAPMINo)	 Quit
			Set rowId = $o(^PAPERi("PAPMI_PatNo",PAPMINo,0))
		}elseif (+validation = 5) {
		 	 s OutMedicareNo=OutMedicareNo_"Z"
			 set rowId =$o(^PAPERi("Govern",OutMedicareNo,0))
			 if rowId =""{
				 quit
			 }
		}elseif (+validation = 6) {
			quit
		}elseif (+validation = 7) {
		 	Set rowId = $o(^DHCPERSON(0,"FCMedicareCode1",EmMedicare,0))
			if rowId =""{
				quit
			}
		}
	}

end 
  Set qHandle=$lb(0,repid,0)
  Quit $$$OK
}

ClassMethod SelectByPAPERIDFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SelectByPAPERIDExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
	//
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

Query SelectByPAPERID(SPAPERID As %String, SPAPERName As %String, SPAPMINo As %String, CardNo As %String, OutMedicareNo As %String, InMedicareNo As %String, EmMedicare As %String) As %Query(ROWSPEC = "TID:%String,TPAPMINo:%String,TPAPERID:%String,TPAPERName:%String,TPAPERDob:%String,TPAPERAge:%String,TPAPERSexDR:%String,TPAPERNationDR:%String,TPAPEROccupationDR:%String,TPAPERSocialStatusDR:%String,TPAPERCountryDR:%String,TPAPERCityCodeDR:%String,TPAPERCityAreaDR:%String,TPAPERZipDR:%String,TPAPERStName:%String,TPAPERTelO:%String,TPAPERTelH:%String,TPAPEREmail:%String,TPAPERUpdateDate:%String,TPAPERSex:%String,TPAPERNation:%String,TPAPEROccupation:%String,TPAPERSocialStatus:%String,TPAPERCountry:%String,TPAPERCityCode:%String,TPAPERCityArea:%String,TPAPERZip:%String,TPAPMIAllergy:%String,TTelHome:%String,TPAPERForeignId:%String,TPAPERForeign:%String,TPAPERCTRLTDR:%String,TPAPERCTRLT:%String,TPAPMICardTypeDR:%String,TPAPMICardType:%String,TPAPERForeignAddress:%String,TPAPERCTProvinceDR:%String,TPAPERCTProvince:%String,TPAPMIDVAnumber:%String,TPAPERCompany:%String,TEmployeeNo:%String,TPAPERMarital:%String,TForeignPhone:%String,TPoliticalLevel:%String,TSecretLevel:%String,TPAPERHCPDR:%String,BirthTime:%String,TCountryHouseDR:%String,TCountryHouse:%String,ForeignAddress:%String,ForeignIDCard:%String,ForeignCredType:%String,PatActive:%String,PAPMILangPrimDR:%String,PAPMILangSecondDR:%String,PAPMIEducation:%String,StreetNow:%String,TNewPatNo:%String,TCardID:%String,TCardNo:%String,TCardType:%String,TCardTypeDesc:%String")
{
}

// 修改病人就诊费别,不包括:国际医疗,口腔科特需门诊

// w ##class(CardInterface.CardManager).UpdateAdmedReason(PatientID)

ClassMethod UpdateAdmedReason(PatientID) As %String
{
	n (PatientID)
	s myrtn=0
	s PatYBCode=$p($g(^PAPER(PatientID,"PAT",3)),"^",12)
	s PatType=$p($g(^PAPER(PatientID,"PER",1)),"^",10)
	i PatType'="" {
		s SQLCODE=0
		s id=0
		f  s id=$O(^PAPERdr(PatientID,"ADM","O",id)) q:(id="")||(SQLCODE'=0)  d
		.s ActiveFlag=$P(^PAADM(id),"^",20)
		.q:ActiveFlag="C"
		.s Date=$P(^PAADM(id),"^",6)
		.q:Date<+$H  ;只是判断了日期,没有判断时间
		.s DepDesc=""
		.s DepCodeDR=$P(^PAADM(id),"^",4)
		.i DepCodeDR'="" s DepDesc=$p($g(^CTLOC(DepCodeDR)),"^",2)
		.;例外退出,按实际情况处理
		.;q:(DepDesc["国际医疗")||(DepDesc["口腔科特需门诊")
		.s SQLCODE=##class(web.DHCOPChgAdmreason).SetPattype("","",PatType,id,PatYBCode)
		s myrtn=SQLCODE
		i myrtn=0 {
			s id=0
			f  s id=$O(^PAPERdr(PatientID,"ADM","E",id)) q:(id="")||(SQLCODE'=0)  d
			.s ActiveFlag=$P(^PAADM(id),"^",20)
			.q:ActiveFlag="C"
			.s Date=$P(^PAADM(id),"^",6)
			.;只是判断了日期,没有判断时间
			.q:Date<+$H
			.s DepDesc=""
			.s DepCodeDR=$P(^PAADM(id),"^",4)
			.i DepCodeDR'="" s DepDesc=$p($g(^CTLOC(DepCodeDR)),"^",2)
			.;例外退出,按实际情况处理
			.;q:(DepDesc["国际医疗")||(DepDesc["口腔科特需门诊")
			.s SQLCODE=##class(web.DHCOPChgAdmreason).SetPattype("","",PatType,id,PatYBCode)
			s myrtn=SQLCODE
		}
	}
	
	q myrtn
}

}
