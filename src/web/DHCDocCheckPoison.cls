Class web.DHCDocCheckPoison Extends DHCDoc.Util.RegisteredObject
{

/// 
/// 	description:根据病人ID获取医嘱录入填写的代办人信息
/// CreatTime:2016-01-28
/// OutPut:   患者身份证号、代办人姓名、代办人身份证号、代办人联系电话
/// w ##class(web.DHCDocCheckPoison).GetSupplyMethod("")
ClassMethod GetSupplyMethod(EpisodeID As %String, OrderPrescNo As %String = "") As %String
{
	s ret=""
	q:EpisodeID="" ret
	s PatientID=$p(^PAADM(EpisodeID),"^",1)
	//s PAPMIDVAnumber=##class(web.DHCDocOrderEntry).FindPAPMIID(PatientID)
	s PAPMIDVAnumber=$p($g(^PAPER(PatientID,"PAT",3)),"^",6)
	s PAPMIDCredTypeDr=$P($G(^PAPER(PatientID,"PAT",3)),"^",7)
	if (PAPMIDCredTypeDr'=""){
		s CredTypeCode=$p(^PAC("CARD",PAPMIDCredTypeDr),"^",1)
		s PAPMIDCredTypeDr=PAPMIDCredTypeDr_"$"_CredTypeCode
	}
	 

	
	Set AgencyName=$P($G(^PAADM(EpisodeID,"DHC")),"^",36)
	Set AgencyCredNo=$P($G(^PAADM(EpisodeID,"DHC")),"^",35)
	Set AgencyTel=$P($G(^PAADM(EpisodeID,"DHC")),"^",37)
	Set AgencyCredDr=$P($G(^PAADM(EpisodeID,"DHC")),"^",55)
	//处方号不为空 取处方上的毒麻代办人信息
	s DMFlag=##Class(DHCDoc.OPDoc.TreatPrint).CheckPrescIsDMFlag(OrderPrescNo)
	if (DMFlag=1){
		s QUE1RowID=$O(^PAQUE1(0,"PrescNo",OrderPrescNo,""))
		if (QUE1RowID'=""){
			s AgencyName=$P($G(^PAQUE1(QUE1RowID)),"^",35)
			s AgencyCredNo=$P($G(^PAQUE1(QUE1RowID)),"^",33)
			s AgencyTel=$P($G(^PAQUE1(QUE1RowID)),"^",36)
			s AgencyCredDr=$P($G(^PAQUE1(QUE1RowID)),"^",34)
		}
	}
	if (AgencyCredDr'=""){
		s CredTypeCode=$p(^PAC("CARD",AgencyCredDr),"^",1)
		s AgencyCredDr=AgencyCredDr_"$"_CredTypeCode
	}
	s PatientID=$p($g(^PAADM(EpisodeID)),"^",1)
	s PatAddressDr=$O(^PAPER(PatientID,"PER","ADD",""),-1)
	s PatAddress=""
	if (PatAddressDr'=""){
		s PatAddress=$g(^PAPER(PatientID,"PER","ADD",PatAddressDr))
	}

	s mradm=$p($g(^PAADM(EpisodeID)),"^",61)
	s Weight=$p($g(^MR(mradm,"PRO",1)),"^",27)
	s PatDobDate=##class(web.DHCDoc.OP.AjaxInterface).GetPatDob($g(PatientID))
	s PatSex=##class(DHCDoc.OPDoc.AjaxInterface).GetPatSex($g(PatientID))
	// renyx 增加科室的输出
	s PACWardID=$P($g(^PAADM(EpisodeID)),"^",70)
	Set ret=PAPMIDVAnumber_"^"_AgencyName_"^"_AgencyCredNo_"^"_AgencyTel_"^"_AgencyCredDr_"^"_PAPMIDCredTypeDr_"^"_Weight_"^"_PatAddress_"^"_mradm_"^"_PatientID_"^"_PatDobDate_"^"_PatSex_"^"_PACWardID
	Quit ret
	/*Set ret=""
	Quit:PersonID="" ret
	s PAPMIDVAnumber=##class(web.DHCDocOrderEntry).FindPAPMIID(PersonID)
	Set PAPMIID=$P($G(^PAPER(PersonID,"PAT",3)),"^",6)
	Set AgencyName=$P($G(^PAPER(PersonID,"DHC")),"^",49)
	Set AgencyCredNo=$P($G(^PAPER(PersonID,"DHC")),"^",48)
	Set AgencyTel=$P($G(^PAPER(PersonID,"DHC")),"^",50)
	Set ret=PAPMIDVAnumber_"^"_AgencyName_"^"_AgencyCredNo_"^"_AgencyTel
	Quit ret*/
}

/// CreateDate 2016-01-28
/// Description:  医嘱录入开毒麻处方时、保存代办人信息
/// w ##class(web.DHCDocCheckPoison).UpdateAgencyInfo("597","370285199106144416^^^")
ClassMethod UpdateAgencyInfo(EpisodeID As %String, PatInfo As %String, OrderPrescNo As %String = "") As %String
{
	Q:EpisodeID="" -100
	s PatientID=$p(^PAADM(EpisodeID),"^",1)
	s ^tmpnk("UpdateAgencyInfo")=PatientID_"^"_PatInfo
	s myIDNo=$P(PatInfo,"^",1)
	s AgencyName=$P(PatInfo,"^",2)
	s AgencyCredNo=$P(PatInfo,"^",3)
	s AgencyTel=$P(PatInfo,"^",4)
	s PAPMICredTypeId="",AgencyCredTypeId=""
	if ($l(PatInfo,"^")>4){
		s PAPMICredTypeId=$P(PatInfo,"^",5)
		s AgencyCredTypeId=$P(PatInfo,"^",6)
	}
	s CredTypeID=..GetCredTypeID()
	TSTART
	if (myIDNo'=""){
		s CheckSameCredID=##class(web.DHCBL.CARD.UCardPaPatMasInfo).CheckCredNoIDU(PatientID,myIDNo,PAPMICredTypeId)
		if (CheckSameCredID=1) {
			Trollback
			Q myIDNo_..%Translate("dhcdoccheckpoison.csp"," 此证件号码已经被使用!")
		}
		set OldDataObject=##class(web.DHCBL.Patient.DHCPatientUpdateLog).GetLogData("User.PAPatMas"_$c(2)_PatientID_"^"_"User.PAPerson"_$c(2)_PatientID)
		set OldDataJson=##class(web.DHCDocDataChangeLog).GetLogJsonData("User.PAPatMas"_$c(2)_PatientID_"^"_"User.PAPerson"_$c(2)_PatientID)
		s Obj=##class(User.PAPatMas).%OpenId(PatientID)
		if $IsObject(Obj){
			s Obj.PAPMIDVAnumber=myIDNo
			if (PAPMICredTypeId'="")&&(PAPMICredTypeId=CredTypeID){
				s Obj.PAPMIID=myIDNo
			}
			do Obj.PAPMICardTypeDRSetObjectId(PAPMICredTypeId)
			Set sc=Obj.%Save()
			If $$$ISERR(sc) {
		 		Trollback
		 		Quit -100
		 	}
		 	d Obj.%Close()
		}
		s myrtn=##class(web.DHCBL.CARD.UCardRefInfo).UpdateDHCCardIDNo(PatientID,myIDNo,CredTypeID)
		if (myrtn'=0){
			Trollback
		 	Quit -100
		}
		if (PAPMICredTypeId'="")&&(PAPMICredTypeId=CredTypeID){
			s PersonObj=##class(User.PAPerson).%OpenId(PatientID)
		 	if $IsObject(PersonObj){
			 	s PersonObj.PAPERID=myIDNo
			 	Set sc1=PersonObj.%Save()
				If $$$ISERR(sc1) {
			 		Trollback
			 		Quit -100
			 	}
			 	d PersonObj.%Close()
		 	}
	 	}
		if $IsObject(OldDataObject) { 
			set NewDataJson=##class(web.DHCDocDataChangeLog).GetLogJsonData("User.PAPatMas"_$c(2)_PatientID_"^"_"User.PAPerson"_$c(2)_PatientID)
			s OperateType="U"
			s PatName=$P($G(^PAPER(PatientID,"ALL")),"^",1)
			set falg=##class(web.DHCDocDataChangeLog).SaveLog("PA_PatMas#PA_Person","User.PAPatMas#User.PAPerson","患者基本信息","User.PAPatMas#User.PAPerson_"_PatientID,PatName,OperateType,NewDataJson,OldDataJson)
		}
	}
	
 	/*s DHCObj=##class(User.DHCPAPatMas).%OpenId(PatientID)
 	if $IsObject(DHCObj){
		s DHCObj.PAPMIAgencyCredNo=AgencyCredNo
		s DHCObj.PAPMIAgencyName=AgencyName
		s DHCObj.PAPMIAgencyTel=AgencyTel
		Set sc2=DHCObj.%Save()
		If $$$ISERR(sc2) {
	 		Trollback
	 		Quit -100
	 	}
	 	d DHCObj.%Close()
 	}*/
 	s DHCObj=##class(User.PAAdmExt).%OpenId(EpisodeID)
 	if $IsObject(DHCObj){
		s DHCObj.PAADMAgencyCredNo=AgencyCredNo
		s DHCObj.PAADMAgencyName=AgencyName
		s DHCObj.PAADMAgencyTel=AgencyTel
		d DHCObj.PAADMAgencyCredTypeDRSetObjectId(AgencyCredTypeId)
		Set sc2=DHCObj.%Save()
		If $$$ISERR(sc2) {
	 		Trollback
	 		Quit -100
	 	}
	 	d DHCObj.%Close()
 	}
 	s DMFlag=##Class(DHCDoc.OPDoc.TreatPrint).CheckPrescIsDMFlag(OrderPrescNo)
 	if (DMFlag=1){
	 	s QUE1RowID=$O(^PAQUE1(0,"PrescNo",OrderPrescNo,""))
	 	if (QUE1RowID'=""){
	 		s PAQue1Obj=##class(User.PAQue1).%OpenId(QUE1RowID)
	 		if $IsObject(PAQue1Obj){
				s PAQue1Obj.QUE1AgencyCredNo=AgencyCredNo
				s PAQue1Obj.QUE1AgencyName=AgencyName
				s PAQue1Obj.QUE1AgencyTel=AgencyTel
				d PAQue1Obj.QUE1AgencyCredTypeDRSetObjectId(AgencyCredTypeId)
				Set sc3=PAQue1Obj.%Save()
				If $$$ISERR(sc3) {
			 		Trollback
			 		Quit -100
			 	}
			 	d PAQue1Obj.%Close()
		 	}
	 	}
	 }
 	
 	TCommit
	q 0
}

ClassMethod GetCredTypeID() As %String
{
	s findCredTypeID="",CredTypeID=""
	f  s CredTypeID=$o(^PAC("CARD",CredTypeID)) Q:(CredTypeID="")||(findCredTypeID'="")  d
	.s CredTypeDesc=$p(^PAC("CARD",CredTypeID),"^",2)
	.i CredTypeDesc["身份证" s findCredTypeID=CredTypeID
	Q findCredTypeID
}

/// Description:保存处方预览打印时的相关打印信息
///  			信息包括：处方号、代办人姓名、代办人身份证号、本人身份证号、打印日期、打印用户
/// Creator:nikang
/// w ##class(web.DHCDocCheckPoison).InsertPAQPrintLog("*I190103000014*^4634^^^")
ClassMethod InsertPAQPrintLog(PrintLogInfo As %String) As %String
{
	s ^tmpnk("InsertPAQPrintLog")=PrintLogInfo
	s myrtn=0
	s PrescNo=$p(PrintLogInfo,"^",1)
	s PrintUser=$p(PrintLogInfo,"^",2)
	s AgencyCredNo=$p(PrintLogInfo,"^",3)
	s AgencyName=$p(PrintLogInfo,"^",4)
	s AgencyTel=$p(PrintLogInfo,"^",5)
	s PrintDate=..%SysDate()
	s PrintTime=..%SysTime()
	Q:PrescNo="" myrtn
	Ts
	s LogObj=##class(User.DHCPAQuePrintLog).%New()
	if $IsObject(LogObj){
		s LogObj.PQPLPrescNo=PrescNo
		s LogObj.PQPLAgencyCredNo=AgencyCredNo
		s LogObj.PQPLAgencyName=AgencyName
		s LogObj.PQPLAgencyTel=AgencyTel
		s LogObj.PQPLPrintDate=PrintDate
		s LogObj.PQPLPrintTime=PrintTime
		d LogObj.PQPLPrintUserDRSetObjectId(PrintUser)
		Set sc=LogObj.%Save()
		If $$$ISERR(sc) {
	 		s myrtn="-100"
	 	}
	 	d LogObj.%Close()
	}
	if (+myrtn=0){
		s myrtn=..SavePrecNoOrdPrintFlag($tr(PrescNo,"*",""))
	}
	if (+myrtn=0){
		TCommit
	}else{
		Tro
	}
	q myrtn
}

ClassMethod SavePrecNoOrdPrintFlag(PrescNo As %String) As %String
{
	Q:PrescNo="" 0
	s OrdItemList=""
	s Ord=0
	f  s Ord=$o(^OEORD(0,"PrescNo",PrescNo,Ord)) q:Ord=""  d
	.s OrdSub=0
	.f  s OrdSub=$o(^OEORD(0,"PrescNo",PrescNo,Ord,OrdSub)) q:OrdSub=""  d
	..i OrdItemList="" s OrdItemList=Ord_"||"_OrdSub
	..e  s OrdItemList=OrdItemList_"^"_Ord_"||"_OrdSub
	Q:OrdItemList="" 0
	Q ##class(web.UDHCPrescript).SetOrdItemPrintFlag(OrdItemList)
}

/// Description：根据处方号得到最近一次的打印时保存的代办人信息
/// w ##class(web.DHCDocCheckPoison).GetAgencyInfoByPrescNo("O16012800002")
ClassMethod GetAgencyInfoByPrescNo(PrescNo As %String, PersonID As %String = "")
{
	;s ^tmpnk("GetAgencyInfoByPrescNo")=PrescNo
	q:PrescNo="" ""
	s findflag=0
	s ret=""
	s PAQPrintDate=""
	f  s PAQPrintDate=$o(^DHCPAQPL("PL",0,"PrescNo",PrescNo,PAQPrintDate),-1) q:(PAQPrintDate="")!(findflag=1)  d
	.s PAQPrintTime=""
	.f  s PAQPrintTime=$o(^DHCPAQPL("PL",0,"PrescNo",PrescNo,PAQPrintDate,PAQPrintTime),-1) q:(PAQPrintTime="")!(findflag=1)  d
	..s PAQPLRowID=0
	..f  s PAQPLRowID=$o(^DHCPAQPL("PL",0,"PrescNo",PrescNo,PAQPrintDate,PAQPrintTime,PAQPLRowID)) q:PAQPLRowID=""  d
	...s PQPLAgencyCredNo=$p(^DHCPAQPL("PL",PAQPLRowID),"^",2)
	...s PQPLAgencyName=$p(^DHCPAQPL("PL",PAQPLRowID),"^",3)
	...s PQPLAgencyTel=$p(^DHCPAQPL("PL",PAQPLRowID),"^",4)
	...s findflag=1
	...s ret=PQPLAgencyCredNo_"^"_PQPLAgencyName_"^"_PQPLAgencyTel
	;如果未保存过,则取医嘱录入时保存信息
	i findflag=0 d
	.s SupplyInfo=..GetSupplyMethod(PersonID)
	.s PQPLAgencyCredNo=$p(SupplyInfo,"^",3)
	.s PQPLAgencyName=$p(SupplyInfo,"^",2)
	.s PQPLAgencyTel=$p(SupplyInfo,"^",4)
	.s ret=PQPLAgencyCredNo_"^"_PQPLAgencyName_"^"_PQPLAgencyTel
	q ret
}

}
