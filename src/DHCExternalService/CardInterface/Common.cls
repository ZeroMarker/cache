Import SQLUser

Class DHCExternalService.CardInterface.Common Extends DHCDoc.Util.RegisteredObject
{

/// 根据病人表RowID取病人基本信息
ClassMethod GetPatientInfo(myPatientID As %String = "") As DHCExternalService.CardInterface.Common.PatientInfo
{
	set myrp=##Class(DHCExternalService.CardInterface.Common.PatientInfo).%New()
	if (myPatientID="") quit myrp
	if ('$data(^PAPER(myPatientID))) quit myrp
	
	set Sex=""
	set SexCode=$p($g(^PAPER(myPatientID,"ALL")),"^",7)
	if SexCode'="" set Sex=$p($g(^CT("SEX",SexCode)),"^",2)
	set DOB=$p($g(^PAPER(myPatientID,"ALL")),"^",6)
	set DocumentID=$p($g(^PAPER(myPatientID,"PAT",1)),"^",22)
	set IDTypeDesc=""
	set IDTypeCode=$p($g(^PAPER(myPatientID,"PAT",3)),"^",7)
	if IDTypeCode'="" set IDTypeDesc=$p($g(^PAC("CARD",IDTypeCode)),"^",2)
	set PatType=""
	set PatTypeDr=$p($g(^PAPER(myPatientID,"PER",1)),"^",10)
	if PatTypeDr'="" set PatType=$p($g(^CT("SS",PatTypeDr)),"^",2)
	set myrp.PapmiRowID=myPatientID
	set myrp.PatientID=##class(DHCExternalService.CardInterface.CardManager).PatientIDToNo(myPatientID)
	Set myrp.PatientName=$p($g(^PAPER(myPatientID,"ALL")),"^",1)
	//医保号
	set myrp.PatYBCode=$p($g(^PAPER(myPatientID,"ALL")),"^",19)
	set myrp.Sex=Sex
	set myrp.DOB=$zd(DOB,3)
	set myrp.Age=..GetPatAge(myPatientID)
	set myrp.IDType=IDTypeDesc
	set myrp.IDNo=$p($g(^PAPER(myPatientID,"PAT",3)),"^",6)
	set myrp.PatType=PatType
	
	quit myrp
}

/// 根据病人表RowID取病人年龄
ClassMethod GetPatAge(Papmi As %String) As %String
{
	&sql(select paper_ageyr,paper_agemth,paper_ageday into :AgeYear,:AgeMonth,:AgeDay 
	       from pa_person where paper_rowid=:Papmi)
	set AgeYear=+AgeYear,AgeMonth=+AgeMonth,AgeDay=+AgeDay
	if (AgeYear>0)
	{
		s AgeDesc=AgeYear_"岁"
	}
	else
	{
		if AgeMonth>0 s AgeDesc=AgeMonth_"月"
		else  s AgeDesc=AgeDay_"天"
	}
	quit AgeDesc
}

/// w ##class(DHCExternalService.CardInterface.Common).GetPatientHadFlag("370285199106144416","nk")
ClassMethod GetPatientHadFlag(IDCardType, IDNo, PatientName) As %String
{
	set myHadFlag=""
	i IDCardType="" s IDCardType="01"
	s IDTypeID=##class(DHCExternalService.CardInterface.GetRelate).GetIDCardType("",IDCardType)
	if IDNo=""{
		q "-1^证件号码不能为空"
	}
	if PatientName=""{
		q "-1^姓名不能为空"
	}
	if (IDTypeID=1)
	{
		if ($length(IDNo)=18)
		{
			set myIDCardNo18=IDNo
			set myIDCardNo15=##class(DHCExternalService.CardInterface.CardManager).ID18to15(IDNo)
		}
		else
		{
			set myIDCardNo15=IDNo
			set myIDCardNo18=##class(DHCExternalService.CardInterface.CardManager).ID15to18(IDNo)
		}
		set myHadFlag=..GetPatIDByIDCardAndName(myIDCardNo18,PatientName)
		if (myHadFlag="") set myHadFlag=..GetPatIDByIDCardAndName(myIDCardNo15,PatientName)
	}
	else
	{
		set myHadFlag=..GetPatIDByIDCardAndName(IDNo,PatientName)
	}
	
	quit myHadFlag
}

/// 根据证件号和姓名得到病人id，如果没有医保卡记录则取最新的一条记录，否则取医保卡对应记录
/// w ##class(DHCExternalService.CardInterface.Common).GetPatIDByIDCardAndName("370285199106144416","nk")
ClassMethod GetPatIDByIDCardAndName(IDCard As %String = "", Name As %String = "") As %String
{
	set FindPatientID=""
	quit:IDCard="" FindPatientID
	set YBPatientID="",FindPatientID=""
	for {
		s PatientID=$O(^PAPERi("DVA",IDCard,PatientID)) q:PatientID=""
		s ActiveFlag=$P(^PAPER(PatientID,"PAT",1),"^",6)
		continue:ActiveFlag="N"
		set CurName=$P(^PAPER(PatientID,"ALL"),"^",1)
		continue:(Name'="")&&(CurName'=Name)
		i FindPatientID="" s FindPatientID=PatientID
		e  s FindPatientID=FindPatientID_"^"_PatientID
	}
	quit FindPatientID
}

/// 补卡
/// w ##class(web.DHCBL.CARD.UCardStatusChangeBuilder).CardReissueNew(4,"0000000027",5706,"")
ClassMethod CardReissueNew(CardID As %String, NewCardNo As %String, UserId As %String, CardINVInfo As %String, CardTypeDefine As %String, CredNo As %String, ExpStr As %String = "") As %String
{
	set ^TMPZCZDFDFDD=CardID_","_NewCardNo_","_UserId_","_CardTypeDefine_","_CredNo
	//set ^ozrtest(101)=CardINVInfo
	
	s StatusInfo=##class(web.DHCEntity.PCA.CardStatusChange).%New()
	s StatusInfo.CardID=CardID
	s StatusInfo.UserDR=UserId
	s StatusInfo.ExchangeCardNo=NewCardNo
	s StatusInfo.CardTypeDefine=CardTypeDefine       
	s StatusInfo.IDCardNo=CredNo
	s mySecurityNo="",myRLPhoneNo=""
	if (ExpStr'=""){
		s mySecurityNo=$p(ExpStr,"^",1)
		s myRLPhoneNo=$p(ExpStr,"^",2)
	}
	s StatusInfo.RLPhoneNo=myRLPhoneNo
	s StatusInfo.SecrityNo=mySecurityNo
	//;$p(^DHCCARD("CF",CardID),"^",16)
	Set id=0
	Set SaveCardNo=""
	for  Set id=$o(^DHCCARDi("CF",0,"CardNo",NewCardNo,id)) Quit:(id="")||(SaveCardNo=1)  do
	.Set ActiveFalg=$p(^DHCCARD("CF",id),"^",10)
	.Quit:(ActiveFalg'="N")&&(ActiveFalg'="S")
	.Set SaveCardNo=1
	
	if SaveCardNo=1{
		Quit "-400"	  //该卡号已经存在有效卡,不能建卡
	}
	
	s newCardID=""
	TStart
	set rtn=0
	;1.验证卡状态
	set status=##class(web.DHCBL.CARD.CardManager).GetCardStatus(StatusInfo.CardID)
	if status="D" {
		set rtn=  -361 ;作废的卡不能再进行补卡
	}
	elseif status="N" {
		//set rtn=  -362 ;正常状态的卡不能进行补卡
	}
	s SDateDiff=+$g(^DHCACDP("ParaSet","SDateDiff")) ;挂失与补卡的日期差
	s ReportLossDate=+##class(web.DHCBL.CARD.CardManager).GetCardStatusChangeDate(StatusInfo.CardID)
	s DateDiff=..%SysDate()-ReportLossDate
	if (DateDiff<SDateDiff)
	{
		set rtn=  -363 ;挂失与补卡的日期差
	}
	
	s myCardRegConfig=##class(web.DHCBL.CARD.CardPATRegConfig).GetCardPatRegConfig()
	s myCardRefFlag=$p(myCardRegConfig, "^", 5)
	s myAccManageFLag= $p(myCardRegConfig, "^", 6)
	;2.作废卡
	if ((myCardRefFlag="Y")&&(+rtn=0)) {
		set StatusInfo.ActiveFlag="D"		;补卡
		set rtn=##class(web.DHCBL.CARD.CardStatusChange).UpdateCardStatus(StatusInfo)
		set rtn=+rtn
	}
	b	;2.写作废卡状态记录
	if ((myCardRefFlag="Y")&&(+rtn=0)) {
		set StatusInfo.ActiveFlag="STD"   ;补卡
		set rtn=##class(web.DHCBL.CARD.CardStatusChange).Insert(StatusInfo)
		set rtn=+rtn
	}
	b	;3.根据帐户配置,如果有帐户信息,更新帐户状态
	if ((myAccManageFLag="Y")&&(+rtn=0)) {
		set CardAccStatus=##class(web.DHCBL.CARD.CardManager).GenerateoCardAccStatus(StatusInfo,"N")
		if CardAccStatus.AccountID'=""
		{
			set myStatusInfo=##class(web.DHCBL.CARD.UCardAccStatusChange).Insert(CardAccStatus)
			i (+myStatusInfo<0){
				set rtn=+myStatusInfo
			}
		}
	}
	
	b	;4.新增卡
	if ((myCardRefFlag="Y")&&(+rtn=0)) {
		set StatusInfo.ActiveFlag="N"
		set rtn=##class(web.DHCBL.CARD.CardStatusChange).InsertCard(StatusInfo)
		set StatusInfo.CardID=$piece(rtn,"^",2)
		set newCardID=StatusInfo.CardID
		 ;更新病人身份信息，电话信息
		s TelH=StatusInfo.RLPhoneNo
		s IDCardNo=StatusInfo.IDCardNo
		s PAPMIDR=$p(^DHCCARD("CF",newCardID),"^",4)
		i IDCardNo'="" { 
		 &sql(
			update sqluser.pa_patmas
			Set PAPMI_ID = :IDCardNo,PAPMI_CardType_DR="1",PAPMI_DVAnumber=:IDCardNo
			where PAPMI_RowId = :PAPMIDR
	 	 )
		}
		i TelH'=""{
	 	 &sql(
			update sqluser.pa_person
			Set PAPER_TelH=:TelH
			where PAPER_RowId = :PAPMIDR
			)
		}
		set rtn=+rtn
	}
	;5.写新增卡状态记录
	if ((myCardRefFlag="Y")&&(+rtn=0)) {
		set StatusInfo.ActiveFlag="RN"			;	补有效的卡
		set rtn=##class(web.DHCBL.CARD.CardStatusChange).Insert(StatusInfo)
		set rtn=+rtn
	}
	///更新帐户里存的卡号
	if ((myAccManageFLag="Y")&&(+rtn=0)) {
		set AccountID=$p($g(^DHCCARD("CF",StatusInfo.CardID)),"^",1)
		if AccountID'=""{
			&sql(update SQLUSER.DHC_AccManager set AccM_CardNo=:NewCardNo where Accm_rowid=:AccountID)
			//s rtn=SQLCODE	
			b ;11111
		}
	}
	b	;6.根据帐户配置,新增帐户状态
	if (myAccManageFLag="Y")&&(+rtn=0) {
		set CardAccStatus=##class(web.DHCBL.CARD.CardManager).GenerateoCardAccStatus(StatusInfo,"N")
		if CardAccStatus.AccountID'=""
		{
			set myStatusInfo=##class(web.DHCBL.CARD.UCardAccStatusChange).Insert(CardAccStatus)
			i (+myStatusInfo<0){
				set rtn=+myStatusInfo
			}
		}
	}
	//卡计费和打印发票操作
	s InvPrtRowID=""
	
	s myFareType= ""
	s myCardINVObj = ##class(web.DHCEntity.PCA.CardINVPRT).%New()
	;7.卡计费
	if ((myCardRefFlag="Y")&&(+rtn=0)) {
	    //此卡是否计费等操作
		s myCardTypeDR = StatusInfo.CardTypeDefine
		if (myCardTypeDR'=""){
			s myobj=##class(User.DHCCardTypeDef).%OpenId(myCardTypeDR)
			//判断是否计费
			s myFareType = myobj.CTDFareType
			i (myobj.CTDFareType="C"){
				d myCardINVObj.XMLNodeDeserialize(.myCardINVObj, "CardINVPRT", CardINVInfo)
				;s myCardINVObj.CardDR=StatusInfo.CardID
				s myCardINVObj.PAPMIRowID=StatusInfo.PatientID
				s myCardINVObj.UserDR=StatusInfo.UserDR
				s myCardINVObj.Flag="N"
				s myCardINVObj.Date=..%SysDate()
				s myCardINVObj.Time=..%SysTime()
			}
			d myobj.%Close()
			//加入计费
			i (myFareType="C")
			{
				s rtn=##class(web.DHCBL.CARD.UCardINVPRTInfo).SaveCardINVInfo(myCardINVObj,myCardTypeDR)
				s InvPrtRowID=$p(rtn,"^",2)
				set rtn=+rtn
				
				if (rtn=0)
				{
					//获取发票打印信息
					;set JSFunName="DHCP_PrintFun"
					set JSFunName="InvPrintNew"
				
					&sql(update sqluser.dhc_cardref set cf_cardinvprt_dr=:InvPrtRowID where cf_rowid=:newCardID)
				}
			}
		}
	}
	if (+rtn=0)
	{
		TCommit
		;调用平台接口
		s rtnStr=##class(web.DHCENS.EnsHISService).DHCHisInterface("SENDREADDCARDINFO",StatusInfo.CardID)
		d ##Class(web.DHCCardPurchaseManage).UpdateCardPurchaseAllot(StatusInfo.CardID)
	}
	else
	{
		TRollback
	}
	
	quit rtn_"^"_InvPrtRowID
}

ClassMethod CheckIDType(IDTypeID As %String)
{
	s rtn=""
	if '$d(^PAC("CARD",IDTypeID)){
		s rtn="该证件类型在His中不存在"
		Q rtn
	}
	s Active=$p($g(^PAC("CARD",IDTypeID,"DHC")),"^",1)
	s DateFrom=$p($g(^PAC("CARD",IDTypeID)),"^",3)
	s DateTo=$p($g(^PAC("CARD",IDTypeID)),"^",4)
	if Active'="Y"{
		s rtn="该证件类型在His中未激活"	
	}else{
		if (DateFrom'="")&&(DateFrom>+$h){
			s rtn="该证件类型在His中未开始使用"	
		}
		if (DateTo'="")&&(DateTo'>+$h){
			s rtn="该证件类型已失效"	
		}
	}
	Q rtn
}

/// W ##class(DHCExternalService.CardInterface.Common).CheckCredCard("","20","2020-09-01",2)
ClassMethod CheckCredCard(IDNo As %String, IDTypeID As %String, Age As %String, HospId As %String)
{
	s rtn=""
	if IDNo=""{
		s CredNoRequired=##class(web.DHCBL.CARD.UCardRefInfo).CheckCardNoRequired(IDTypeID)
		s AgeAllow=##class(web.DHCDocConfig).GetDHCDocCardConfig("AllowAgeNoCreadCard",HospId)
		s FlagNoCread=##class(web.DHCDocConfig).GetDHCDocCardConfig("NOCREAD",HospId)
		if (CredNoRequired="Y"){
			if ((AgeAllow'="")&&(Age'>AgeAllow)){}
			else{
				s rtn="证件号不能为空."
			}
		}	
	}else{
		//验证身份证号的有效性
		if ($p(^PAC("CARD",IDTypeID),"^",1)="01"){
			s errMsg=""
			s crtn=##class(DHCDoc.Util.Base).CheckIdCardNo(IDNo,.errMsg)
			if (crtn'="Y") {
				s rtn=errMsg
			}
		}
	}
	Q rtn
}

ClassMethod CheckForeignInfo(Age As %String, ForeignInfo As %String, HospitalId As %String)
{
	s rtn=""
	s ContactName=$P(ForeignInfo,"^",1)
	s ContactTelNo=$P(ForeignInfo,"^",2)
	s ContactIDNo=$P(ForeignInfo,"^",3)
	s ContactIDTypeID=$P(ForeignInfo,"^",4)
	s ForeignInfoByAge=##class(web.DHCDocConfig).GetDHCDocCardConfig("ForeignInfoByAge",HospitalId)
	if (Age < ForeignInfoByAge) {
		if ContactIDTypeID'=""{
			s rtn=..CheckIDType(ContactIDTypeID)
			if rtn'=""{
				s rtn="联系人证件类型:"_rtn
			}
			if (ContactIDNo'="")&&($p(^PAC("CARD",ContactIDTypeID),"^",1)="01"){
				s errMsg=""
				s crtn=##class(DHCDoc.Util.Base).CheckIdCardNo(ContactIDNo,.errMsg)
				if (crtn'="Y") {
					s rtn="联系人证件号:"_errMsg
				}
			}
		}else{
			s rtn="年龄小于"_ForeignInfoByAge_"岁的患者须填写完整联系人信息，该联系人证件类型为空或与HIS未对照"
		}
		if rtn=""{
			if ((ContactName="")!(ContactTelNo="")!(ContactIDNo="")){
				s rtn="年龄小于"_ForeignInfoByAge_"岁的患者须填写完整联系人信息，联系人姓名、联系人联系方式、联系人证件类型、联系人证件号不能为空"
			}
		}
	}
	Q rtn
}

}
