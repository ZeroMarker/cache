Class DHCExternalService.CardInterface.CardManager Extends %RegisteredObject [ ClassType = "" ]
{

Parameter IDCredTypeCode = 01;

/// w ##class(DHCExternalService.CardInterface.CardManager).CardManager("<Request><TradeCode>3001</TradeCode><PatientID></PatientID><BankCode>99</BankCode><PatientCard>0000123418</PatientCard><SecurityNo>000000</SecurityNo><ChipSerialNo></ChipSerialNo><TransactionId>0</TransactionId><PatientType></PatientType><PatientName>患者姓名3</PatientName><Sex>F</Sex><DOB>1988-09-09</DOB><Age>23</Age><MaritalStatus>5</MaritalStatus><Nation>01</Nation><Occupation></Occupation><Nationality></Nationality><IDType>1</IDType><IDNo>130636198809190518</IDNo><Address>家庭住址1</Address><AddressLocus></AddressLocus><Zip></Zip><Company></Company><CompanyAddr></CompanyAddr><CompanyZip></CompanyZip><CompanyTelNo>15812341234</CompanyTelNo><TelephoneNo></TelephoneNo><Mobile>15810980956</Mobile><ContactName></ContactName><ContactAddress></ContactAddress><Relation></Relation><ContactTelNo></ContactTelNo><SignedStatus></SignedStatus><PayMode></PayMode> <TotalAmount>200</TotalAmount><PayBankName></PayBankName><PayCardType></PayCardType><PayCardNo></PayCardNo></Request>")
ClassMethod CardManager(InputXml As %String = "") As DHCExternalService.CardInterface.Entity.ReturnInfo
{
	s $ZT="ManagerError"
	s (TradeCode,PatientID,BankCode,PatientName,TransactionId)=""
	s InputObj=##class(DHCExternalService.CardInterface.Entity.PatInfo).%New()
	d InputObj.XMLNodeDeserialize(.InputObj, "Request", InputXml)
	s RtnObj=##class(DHCExternalService.CardInterface.Entity.ReturnInfo).%New()
	s RtnObj.TradeCode=InputObj.TradeCode
	s RtnObj.BankCode=InputObj.BankCode
	s RtnObj.PatientName=InputObj.PatientName
	s RtnObj.TransactionId=InputObj.TransactionId
	s RtnObj.PatientID=InputObj.PatientID
	
	;登记号转换为ID
	s RtnObj.PatientID=##class(DHCExternalService.CardInterface.CardManager).PatientNoToID(RtnObj.PatientID)
	set InputObj.PatientID=RtnObj.PatientID
	/*
	i InputObj.BankCode=""{
		s RtnObj.ResultCode="-1"
		s RtnObj.ErrorMsg="银行代码不能为空"
		q RtnObj
	}
	i InputObj.TransactionId=""{
		s RtnObj.ResultCode="-1"
		s RtnObj.ErrorMsg="银行业务流水号不能为空"
		q RtnObj
	}
	*/
	s IDCardType=##class(DHCExternalService.CardInterface.GetRelate).GetIDCardType(InputObj.BankCode,InputObj.IDType)
	i IDCardType=""{
		s RtnObj.ResultCode="-1"
		s RtnObj.ErrorMsg="证件类型没有对照"
		q RtnObj
	}
	s CardType=##class(GetRelate).GetCardType(InputObj.BankCode,"","")
	i CardType=""{
		s RtnObj.ResultCode="-1"
		s RtnObj.ErrorMsg="银行没有对照对应的卡类型"
		q RtnObj
	}
	s TradeCode=InputObj.TradeCode
	i (TradeCode'="3005")&&(InputObj.PatientCard=""){
		s RtnObj.ResultCode="-1"
		s RtnObj.ErrorMsg="就诊卡号不能为空"
		q RtnObj
	}
	set InputObj.UserID=##class(DHCExternalService.CardInterface.GetRelate).GetUser()
	TSTART
	i (TradeCode="3001")||(TradeCode="3011"){ ;建卡 ;卡绑定
		set Bindflag=""
		if (TradeCode="3011") set Bindflag="B"  ;卡绑定
		s Rtn=..CardCreate(.InputObj,Bindflag)
		s RtnObj.PatientID=InputObj.PatientID
		s RtnObj.ActiveFlag=$piece(Rtn,"^",3)
	}elseif TradeCode="3002"{ ;挂失
		s Rtn=..CardReportLoss(InputObj)
	}elseif TradeCode="3003"{ ;撤销挂失
		s Rtn=..CardCancelLoss(InputObj)
	}elseif (TradeCode="3004")||(TradeCode="3012"){ ;销户 ;解绑
		set Bindflag=""
		if (TradeCode="3012") set Bindflag="B"  ;解绑
		s Rtn=..CardCancel(InputObj,Bindflag)
	}elseif TradeCode="3005"{ ;换卡
		s Rtn=..CardChange(InputObj)
	}elseif TradeCode="3006"{ ;信息修改
		s Rtn=..CardModify(InputObj)
	}elseif TradeCode="3007"{ ;签约
		s Rtn=..CardSigned(InputObj)
	}elseif (TradeCode="3008"){ ;解约 
		s Rtn=..CardCancelSigned(InputObj)
	}elseif TradeCode="3009"{ ;签约状态查询
		s Rtn=..GetCardSignedStatus(InputObj)
		i +Rtn=0{
			s RtnObj.SignedStatus=$P(Rtn,"^",2)
		}
	}elseif (TradeCode="3100"){ ;查询是否已经有病人信息 
		s Rtn=..GetPatientHadFlag(InputObj)
		set RtnObj.SignedStatus=+Rtn
	}
	elseif (TradeCode="3103"){ ;协和健康卡绑定 
		s Rtn=..HTCardBind(InputObj)
		set RtnObj.SignedStatus=+Rtn
	}elseif (TradeCode="3104"){ ;协和健康卡解绑 
		s Rtn=..HTCardUnBound(InputObj)
		set RtnObj.SignedStatus=+Rtn
	}
	else{
		s Rtn="-1^交易类型不对"
	}
	i +Rtn=-1{
		TROLLBACK
	}elseif((+Rtn=-50)||(+Rtn=-51)||(+Rtn=-52))
	{
		TROLLBACK		
	}
	else{
		s $P(Rtn,"^",1)="0" //
		TCOMMIT
	}
	;PatientID转换为登记号
	s RtnObj.PatientID=##class(DHCExternalService.CardInterface.CardManager).PatientIDToNo(RtnObj.PatientID)
	s RtnObj.ResultCode=+Rtn
	s RtnObj.ErrorMsg=$P(Rtn,"^",2)
	//s RtnObj.SignedStatus=InputObj.SignedStatus
	q RtnObj
ManagerError
	TROLLBACK
	s RtnObj=##class(DHCExternalService.CardInterface.Entity.ReturnInfo).%New()
	s RtnObj.ResultCode="-1"
	s RtnObj.ErrorMsg="DHCExternalService.CardInterface.CardManager调用异常失败"_$ZERROR
	q RtnObj
}

ClassMethod CardCreate(InfoObj As DHCExternalService.CardInterface.Entity.PatInfo, Bindflag As %String = "") As %String
{
	s $ZT="CreateErr"
	set CardTypeCode=InfoObj.CardTypeCode
	set BankCode=InfoObj.BankCode
	set HTBankCardNo=InfoObj.HTBankCardNo
	
	set InfoObj.SecurityNo=##Class(DHCExternalService.CardInterface.GetRelate).GetSecurityNo(InfoObj.SecurityNo)
	set BankCardActiveFlag=0
	s IDCardType=##class(DHCExternalService.CardInterface.GetRelate).GetIDCardType(InfoObj.BankCode,InfoObj.IDType)
	;b ;IDCardType
	i InfoObj.IDNo=""{
		q "-1^证件号码不能为空"
	}
	s CardType=##class(GetRelate).GetCardType(InfoObj.BankCode,"",Bindflag)
	set FindCardType=CardType
	if (Bindflag="B") set FindCardType=""
	s Status=..CardHadCreate(CardType,InfoObj.PatientCard)
	if $piece(Status,"^",1)'=""{
		set InfoObj.PatientID=$piece(Status,"^",2)
		s StatusDesc=..GetCardStatusDesc($piece(Status,"^",1))
		if ($piece(Status,"^",1)="N")
		{
			q "-50^"_"系统存在状态为'"_StatusDesc_"'的同卡号的卡"_"^"_BankCardActiveFlag
		}
		elseif ($piece(Status,"^",1)="UA")
		{
			s PatientIDs=..CheckInfoByIDCard(IDCardType,InfoObj.IDNo,FindCardType,InfoObj.PatientName)
			s IDTotal=0
			s Flag=$P(PatientIDs,"^",1)
			s IDTotal=$P(PatientIDs,"^",3)
			if (IDTotal>1)
			{
				set BankCardActiveFlag=1
			}
			else
			{
				set BankCardActiveFlag=2
			}
			q "-50^"_"系统存在状态为'"_StatusDesc_"'的同卡号的卡"_"^"_BankCardActiveFlag
		}
		else
		{
			if (Bindflag'="B")
			{
				q "-52^"_"系统存在状态为'"_StatusDesc_"'的同卡号的卡"
			}
		}
	}
	s PatientIDs=..CheckInfoByIDCard(IDCardType,InfoObj.IDNo,FindCardType,InfoObj.PatientName)
	s IDTotal=0
	s Flag=$P(PatientIDs,"^",1)
	s IDTotal=$P(PatientIDs,"^",3)
	if (IDTotal>1) set BankCardActiveFlag=1
	   //协和银医卡控制同一卡类型只建一张卡
	i (Flag=1)&&(Bindflag'="B"){
		s Status=$P(PatientIDs,"^",2)
		s StatusDesc=..GetCardStatusDesc(Status)
		q "-51^"_"存在状态为'"_StatusDesc_"'的同种类型的卡"
	}else{
		s PatientIDs=$P(PatientIDs,"^",2)
	}
	
	;s PatientIDs=$P(PatientIDs,"^",2)
	i (PatientIDs=""){ ;插入
		if Bindflag="B" set BankCardActiveFlag=3
		else  set BankCardActiveFlag=2
		s rtn=..CardInsert(InfoObj,Bindflag)
		i +rtn=0{
			s InfoObj.PatientID=$P(rtn,"^",2)
			q "0^成功^"_BankCardActiveFlag
		}else{
			q "-1^"_$P(rtn,"^",2)
		}
	}else{ ;更新
		s InfoObj.PatientID=PatientIDs
		s rtn=..CardRelate(InfoObj,IDTotal,Bindflag)
		i +rtn=0{
			q "0^成功^"_BankCardActiveFlag
		}else{
			q "-1^"_$P(rtn,"^",2)
		}
	}
	q
CreateErr
	q "-1^CardCreate调用异常失败"_$ZERROR
}

ClassMethod CardInsert(InfoObj As DHCExternalService.CardInterface.Entity.PatInfo, Bindflag As %String = "") As %String
{
	s $ZT="InsertErr"
	s myConfigObj=##class(web.DHCEntity.PCA.CardTypeConfig).%New()
	s PPAPersonInfo=##class(web.DHCEntity.PCA.PATMAS).%New()
	s myCardObj=##class(web.DHCEntity.PCA.CardRef).%New()
	s myCardINVObj = ##class(web.DHCEntity.PCA.CardINVPRT).%New()
	;配置信息
	s UserID=InfoObj.UserID
	s GroupID=##class(DHCExternalService.RegInterface.GetRelate).GetGroup(UserID)
	s BankCode=##class(DHCDoc.Interface.Outside.Config).GetConfigNode(GroupID,"DataCompareExtOrg",InfoObj.HospitalId)
	
	s CardType=InfoObj.CardTypeCode
	s CardTypeObj=##class(User.DHCCardTypeDef).%OpenId(CardType)
	s myCardRegConfig=##class(web.DHCBL.CARD.CardPATRegConfig).GetCardPatRegConfig()
	s myConfigObj.AccManageFLag=$p(myCardRegConfig, "^", 6)
	s myConfigObj.CardRefFlag=$p(myCardRegConfig, "^", 5)
	s myConfigObj.PatMasFlag=$p(myCardRegConfig, "^", 4)
	
	s myConfigObj.CardAccountRelation=CardTypeObj.CTDCardAccountRelation
	s myConfigObj.CardFareCost=CardTypeObj.CTDCardFareCost
	s myConfigObj.FareType=CardTypeObj.CTDFareType
	s myConfigObj.GroupRegFlag="PR"
	s myConfigObj.PANoCardRefFlag=CardTypeObj.CTDPANoCardRefFlag
	
	s myConfigObj.PreCardFlag=CardTypeObj.CTDPreCardFlag
	s myConfigObj.SearchMasFlag=CardTypeObj.CTDSearchMasFlag
	s myConfigObj.StChangeValidateFlag=CardTypeObj.CTDStChangeValidateFlag
	s myConfigObj.SecurityNoFlag=CardTypeObj.CTDSecurityNoFlag
	s myConfigObj.UseINVType=CardTypeObj.CTDUseINVType
	;构造病人信息
	s Sex=##class(DHCExternalService.CardInterface.GetRelate).GetSex(BankCode,InfoObj.Sex)
	i Sex=""{
		q "-1^性别对照不正确"
	}
	s PPAPersonInfo.Sex=Sex
	
	s TempName=$tr(InfoObj.PatientName," ")
	i TempName=""{
		q "-1^姓名信息不正确"
	}
	s PPAPersonInfo.Name=InfoObj.PatientName
	
	i ..ValidDate(InfoObj.DOB)=-1 {
		q "-1^出生日期格式不正确"
	}
	s PPAPersonInfo.Birth=InfoObj.DOB
	
	s MaritalStatus=##class(DHCExternalService.CardInterface.GetRelate).GetMarital(BankCode,InfoObj.MaritalStatus)
	if (InfoObj.MaritalStatus)&&('MaritalStatus) {
		q "-1^传入的婚姻状况未对照或对照后的HIS代码已失效"
	}
	s PPAPersonInfo.PAPERMarital=MaritalStatus
	;s PPAPersonInfo.PAPERMarital=InfoObj.MaritalStatus
	/*
	i InfoObj.SecurityNo=""{
		q "-1^卡校验码不能为空"
	}
	
	i InfoObj.ChipSerialNo=""{
		q "-1^芯片序列号不能为空"
	}
	*/
	i InfoObj.Mobile=""{
		q "-1^手机号(个人电话)不能为空"
	}
	s PPAPersonInfo.MobPhone=InfoObj.Mobile
	s Nation=##class(DHCExternalService.CardInterface.GetRelate).GetNation(BankCode,InfoObj.Nation)
	if (InfoObj.Nation)&&('Nation) {
		q "-1^传入的民族未对照或对照后的HIS代码已失效"
	}
	s PPAPersonInfo.NationDescLookUpRowID=Nation
	s Occupation=##class(DHCExternalService.CardInterface.GetRelate).GetOccupation(BankCode,InfoObj.Occupation)
	if (InfoObj.Occupation)&&('Occupation) {
		q "-1^传入的职业未对照或对照后的HIS代码已失效"
	}
	s PPAPersonInfo.Vocation=Occupation
	s Nationality=##class(DHCExternalService.CardInterface.GetRelate).GetNationality(BankCode,InfoObj.Nationality)
	s PPAPersonInfo.CountryDescLookUpRowID=Nationality
	s PPAPersonInfo.CredType=InfoObj.IDType
	s PPAPersonInfo.PatType=InfoObj.PatientType
	s PPAPersonInfo.PatYBCode=InfoObj.InsureCardNo
	s ZipInfo=##class(DHCExternalService.CardInterface.GetRelate).GetZip(InfoObj.Zip)
	s PPAPersonInfo.ZipLookUpRowID=$P(ZipInfo,"^",1) //邮编
	s PPAPersonInfo.ProvinceInfoLookUpRowID=$P(ZipInfo,"^",2) //省份
	s PPAPersonInfo.CityDescLookUpRowID=$P(ZipInfo,"^",3) //市
	s Relation=##class(DHCExternalService.CardInterface.GetRelate).GetRelation(BankCode,InfoObj.Relation)
	if (InfoObj.Relation)&&('Relation) {
		q "-1^传入的联系人关系未对照或对照后的HIS代码已失效"
	}
	s PPAPersonInfo.PhotoInfo=InfoObj.PhotoInfo
	s PPAPersonInfo.CTRelationDR=Relation
	s PPAPersonInfo.CredNo=InfoObj.IDNo
	s PPAPersonInfo.IDCardNo1=InfoObj.IDNo
	s PPAPersonInfo.Address=InfoObj.Address
	;s PPAPersonInfo.Company=InfoObj.Company
	;s PPAPersonInfo.EmployeeCompany=InfoObj.Company
	
	s PPAPersonInfo.TelOffice=InfoObj.CompanyTelNo
	s PPAPersonInfo.TelHome=InfoObj.TelephoneNo
	;联系人信息
	s PPAPersonInfo.ForeignName=InfoObj.ContactName
	s PPAPersonInfo.ForeignPhone=InfoObj.ContactTelNo
	s PPAPersonInfo.ForeignAddress=InfoObj.ContactAddress
	s PPAPersonInfo.ForeignIDCard=InfoObj.ContactIDNo
	s PPAPersonInfo.ForeignCredType=InfoObj.ContactIDType
	
	set User=InfoObj.UserID
	s PPAPersonInfo.UserDR=User
	;构造卡信息
	s myCardObj.ActiveFlag="N" ;未激活
	if (Bindflag="B") set myCardObj.ActiveFlag="N"  ;新建的绑定卡状态为正常
	
	s myCardObj.CardNo=InfoObj.PatientCard
	s myCardObj.CardTypeDefine=CardType
	s myCardObj.ComputerIP=InfoObj.BankCode
	s myCardObj.CredNo=InfoObj.IDNo
	s myCardObj.UserDR=User
	s myCardObj.LogonHospDR=InfoObj.HospitalId
	s myCardObj.SecurityNo=InfoObj.SecurityNo
	s rtn=myConfigObj.XMLExportToString(.ConfigInfo,"CardTypeConfig")
	i ($system.Status.IsError(rtn)) {
		q "-1^注册失败:卡类型配置序列化失败"
	}
	s rtn=PPAPersonInfo.XMLExportToString(.PaPatInfo,"PATMAS")
	i ($system.Status.IsError(rtn)) {
		q "-1^注册失败:病人信息序列化失败"
	}
	s rtn=myCardObj.XMLExportToString(.CardInfo,"CardRef")
	i ($system.Status.IsError(rtn)) {
		q "-1^注册失败:卡信息序列化失败"
	}
	s AccInfo=""
	s myAccObj=##class(web.DHCEntity.PCA.AccManager).%New()
	s myAccObj.PassWord=InfoObj.AccountPassword
	s myAccObj.AccountType="P"
	s myAccObj.CardNo=InfoObj.PatientCard
	s myAccObj.UserDR=User
	s myAccObj.HospitalID=InfoObj.HospitalId
	s rtn=myAccObj.XMLExportToString(.AccInfo,"AccManager")
	if ($system.Status.IsError(rtn)) {
		q "-1^注册失败:账户信息序列化失败"
	}
	s DepositInfo=""
	if (InfoObj.ChargeDepositAmt>0)
	{
		s myDepositObj=##class(web.DHCEntity.PCA.AccPreDeposit).%New()
		s myDepositObj.amt=InfoObj.ChargeDepositAmt
		s myDepositObj.PayMode=InfoObj.PayMode
		s myDepositObj.PayAccNo=InfoObj.TransactionId
		s myDepositObj.UserDR=User
		s rtn=myDepositObj.XMLExportToString(.DepositInfo,"AccPreDeposit")
		if ($system.Status.IsError(rtn)) {
			q "-1^注册失败:预交金信息序列化失败"
		}
	}	
	;发票信息
	s CardINVInfo="" 
	Set CardFareType=$P(^DHCCARDTYPEDef(CardType),"^",3)
	Set CardFareCost=+$P(^DHCCARDTYPEDef(CardType),"^",6)
	if (CardFareType="C")&&(CardFareCost>0)
	{
		set myCardINVObj.CardFareCost=CardFareCost
		set myCardINVObj.PayMode=InfoObj.PayMode
		set myCardINVObj.UserDR=User
		set myCardINVObj.HospitalID=InfoObj.HospitalId
		s rtn=myCardINVObj.XMLExportToString(.CardINVInfo,"CardINVPRT")
		if ($system.Status.IsError(rtn)) {
			q "-1^注册失败:卡收费信息序列化失败"
		}
	}
	/*
	if (InfoObj.TotalAmount>0)
	{
		set myCardINVObj.CardFareCost=InfoObj.TotalAmount
		set myCardINVObj.PayMode=InfoObj.PayMode
		set myCardINVObj.UserDR=User
		s rtn=myCardINVObj.XMLExportToString(.CardINVInfo,"CardINVPRT")
		if ($system.Status.IsError(rtn)) {
			q "-1^注册失败:卡收费信息序列化失败"
		}
	}
	*/
	s SepcialInfo=myCardObj.SecurityNo_"^"
	s UsePAPMINoToCardFlag=$P(^DHCCARDTYPEDef(CardType),"^",36)
	//扩展参数  1为大病历更新
	s ExpStr="^"_UsePAPMINoToCardFlag_"^"_InfoObj.HospitalId
	s Rtn=##class(web.DHCBL.CARDIF.ICardRefInfo).SavePCAInfoToServer(ConfigInfo, PaPatInfo, CardInfo, AccInfo, DepositInfo, CardINVInfo, SepcialInfo, ExpStr) 
	b ;Insert Ok
	s Status=+Rtn
	if Status=0 {
		q Rtn
	}
	elseif Status=-304
	{
		q "-50^(Insert)注册失败:此卡号已经存在,不能发卡"
	}
	elseif Status=-364
	{
		q "-51^(Insert)注册失败:已经存在此卡类型下的有效卡,不允许再发!"
	}
	elseif Status=-365
	{
		q "-51^(Insert)注册失败:此证件号码已经存在,请办理其他卡或办理补卡!"
	}
	elseif Status=-367
	{
		q "-51^(Insert)注册失败:证件号码不能为空!"
	}
	elseif Status=-369
	{
		q "-51^(Insert)注册失败:办理卡绑定时,获取患者信息错误!"
	}
	elseif Status=-370
	{
		q "-53^(Insert)注册失败:卡位数受限"
	}
	elseif Status=-341
	{
		q "-55^(Insert)此卡已经建卡,不能重复发卡!"
	}
	elseif Status=-351
	{
		q "-55^(Insert)此卡已经被挂失,不能使用"
	}
	elseif Status=-352
	{
		q "-54^(Insert)此卡已经被作废,不能使用"
	}
	elseif Status=-211
	{
		q "-54^(Insert)此帐户号码已存在"
	}
	else
	{
		q "-1^(Insert)注册失败,失败信息:"_$p(Rtn,$c(1),1)
	}
InsertErr
	q "-1^CardInsert发生异常"_$ZERROR
}

ClassMethod InsertBehavePat(InfoObj As DHCExternalService.CardInterface.Entity.PatInfo, IDTotal As %String = "", Bindflag As %String = "") As %String
{
	s $ZT="InsertBehaveErr"
	s PatientID=InfoObj.PatientID
	if (PatientID=""){
		q "-1^病人ID不存在"
	}
	s myCardObj=##class(web.DHCEntity.PCA.CardRef).%New()
	s CardRefID=""
	s CardRef=0
	f  s CardRef=$o(^DHCCARDi("CF",0,"PAPMIDR",PatientID,CardRef)) q:CardRef=""  d
	.s Status=$P(^DHCCARD("CF",CardRef),"^",10)
	.q:Status'="N"
	.s CardRefID=CardRef
	if (CardRefID=""){
		q "-1^卡ID解析错误"
	}
	s CardObj = ##class(User.DHCCardRef).%OpenId(CardRefID)
	;构造卡信息
	s myCardObj.PAPMIRowID=InfoObj.PatientID
	s myCardObj.CardNo=InfoObj.PatientCard
	s myCardObj.CardTypeDefine=##Class(DHCExternalService.RegInterface.GetRelate).GetHisCardTypeID(InfoObj.CardTypeCode)
	s myCardObj.ComputerIP=InfoObj.BankCode
	s myCardObj.CredNo=InfoObj.IDNo
	s myCardObj.UserDR=InfoObj.UserID
	s myCardObj.ActiveFlag="N" ;激活
	s:IDTotal>1 myCardObj.ActiveFlag="UA" ;未激活
	
	s myCardObj.Note4=InfoObj.SignedStatus ;1 签约
	s myCardObj.Note5=InfoObj.BankCode
	s myCardObj.ChipSerialNo=InfoObj.ChipSerialNo
	s myCardObj.SecurityNo=InfoObj.SecurityNo
	
	s myCardObj.CFAccNoDR=CardObj.CFAccNoDR
	s myCardObj.PAPMINo=CardObj.CFPAPMINo
	ts
	s rtn=##class(web.DHCBL.CARD.UCardRefInfo).SaveCardInfo(myCardObj)
	if (+rtn=0)
	{
		tcommit
		q 0_"^"_PatientID_"^"_$p(rtn,"^",2)
	}
	else
	{
		trollback
		q "-1^注册失败:插入卡表失败"
	}
	
InsertBehaveErr
	q "-1^InsertBehavePat发生异常:"_$ZERROR
}

ClassMethod CardRelate(InfoObj As DHCExternalService.CardInterface.Entity.PatInfo, IDTotal As %String = "", Bindflag As %String = "") As %String
{
	s $ZT="RelateErr"
	
	s User=InfoObj.UserID
	s GroupID=##class(DHCExternalService.RegInterface.GetRelate).GetGroup(User)
	s BankCode=##class(DHCDoc.Interface.Outside.Config).GetConfigNode(GroupID,"DataCompareExtOrg",InfoObj.HospitalId)
	
	s myConfigObj=##class(web.DHCEntity.PCA.CardTypeConfig).%New()
	s PPAPersonInfo=##class(web.DHCEntity.PCA.PATMAS).%New()
	s myCardObj=##class(web.DHCEntity.PCA.CardRef).%New()
	s myCardINVObj = ##class(web.DHCEntity.PCA.CardINVPRT).%New()
	;配置信息
	s CardType=InfoObj.CardTypeCode
	s CardTypeObj=##class(User.DHCCardTypeDef).%OpenId(CardType)
	s myCardRegConfig=##class(web.DHCBL.CARD.CardPATRegConfig).GetCardPatRegConfig()
	s myConfigObj.AccManageFLag=$p(myCardRegConfig, "^", 6)
	s myConfigObj.CardRefFlag=$p(myCardRegConfig, "^", 5)
	s myConfigObj.PatMasFlag="N" ;$p(myCardRegConfig, "^", 4)不更新病人信息
	
	s myConfigObj.CardAccountRelation=CardTypeObj.CTDCardAccountRelation
	s myConfigObj.CardFareCost=CardTypeObj.CTDCardFareCost
	s myConfigObj.FareType=CardTypeObj.CTDFareType
	s myConfigObj.GroupRegFlag="PR"
	s myConfigObj.PANoCardRefFlag=CardTypeObj.CTDPANoCardRefFlag
	
	s myConfigObj.PreCardFlag=CardTypeObj.CTDPreCardFlag
	s myConfigObj.SearchMasFlag=CardTypeObj.CTDSearchMasFlag
	s myConfigObj.StChangeValidateFlag=CardTypeObj.CTDStChangeValidateFlag
	s myConfigObj.SecurityNoFlag=CardTypeObj.CTDSecurityNoFlag
	s myConfigObj.UseINVType=CardTypeObj.CTDUseINVType
	
	;构造卡信息
	s myCardObj.PAPMIRowID=InfoObj.PatientID
	s myCardObj.CardNo=InfoObj.PatientCard
	s myCardObj.CardTypeDefine=CardType
	s myCardObj.ComputerIP=InfoObj.BankCode
	s myCardObj.CredNo=InfoObj.IDNo
	s myCardObj.UserDR=User
	s myCardObj.ActiveFlag="N" ;激活
	s:IDTotal>1 myCardObj.ActiveFlag="UA" ;未激活
	
	s myCardObj.SecurityNo=InfoObj.SecurityNo
	s myCardObj.LogonHospDR=InfoObj.HospitalId
	s rtn=myConfigObj.XMLExportToString(.ConfigInfo,"CardTypeConfig")
	i ($system.Status.IsError(rtn)) {
		q "-1^注册失败:卡类型配置序列化失败"
	}
	s rtn=myCardObj.XMLExportToString(.CardInfo,"CardRef")
	i ($system.Status.IsError(rtn)) {
		q "-1^注册失败:卡信息序列化失败"
	}
	;病人信息
	s PaPatInfo=""
	s IDCardType=InfoObj.IDType
	s PPAPersonInfo.CredType=IDCardType
	s PPAPersonInfo.CredNo=InfoObj.IDNo
	s PPAPersonInfo.IDCardNo1=InfoObj.IDNo
	s PPAPersonInfo.PhotoInfo=InfoObj.PhotoInfo
	s PPAPersonInfo.PAPMIRowID=InfoObj.PatientID
	s rtn=PPAPersonInfo.XMLExportToString(.PaPatInfo,"PATMAS")
	i ($system.Status.IsError(rtn)) {
		q "-1^注册失败:病人信息序列化失败"
	}
	;帐户信息
	s AccInfo=""
	s myAccObj=##class(web.DHCEntity.PCA.AccManager).%New()
	s myAccObj.PassWord=InfoObj.AccountPassword
	s myAccObj.AccountType="P"
	s myAccObj.CardNo=InfoObj.PatientCard
	s myAccObj.UserDR=User
	s myAccObj.HospitalID=InfoObj.HospitalId
	s rtn=myAccObj.XMLExportToString(.AccInfo,"AccManager")
	if ($system.Status.IsError(rtn)) {
		q "-1^注册失败:账户信息序列化失败"
	}
	;预交金信息
	s DepositInfo=""
	if (InfoObj.ChargeDepositAmt>0)
	{
		s myDepositObj=##class(web.DHCEntity.PCA.AccPreDeposit).%New()
		s myDepositObj.amt=InfoObj.ChargeDepositAmt
		s myDepositObj.PayMode=InfoObj.PayMode
		s myDepositObj.PayAccNo=InfoObj.TransactionId
		s myDepositObj.UserDR=User
		s rtn=myDepositObj.XMLExportToString(.DepositInfo,"AccPreDeposit")
		if ($system.Status.IsError(rtn)) {
			q "-1^注册失败:预交金信息序列化失败"
		}
	}	
	;发票信息
	s CardINVInfo="" 
	if (InfoObj.TotalAmount>0)
	{
		set myCardINVObj.CardFareCost=InfoObj.TotalAmount
		set myCardINVObj.PayMode=InfoObj.PayMode
		set myCardINVObj.UserDR=User
		set myCardINVObj.HospitalID=InfoObj.HospitalId
		s rtn=myCardINVObj.XMLExportToString(.CardINVInfo,"CardINVPRT")
		if ($system.Status.IsError(rtn)) {
			q "-1^注册失败:卡收费信息序列化失败"
		}
	}
	s SepcialInfo=myCardObj.SecurityNo_"^"
	s UsePAPMINoToCardFlag=$P(^DHCCARDTYPEDef(CardType),"^",36)
	//扩展参数  1为大病历更新
	s ExpStr="^"_UsePAPMINoToCardFlag_"^"_InfoObj.HospitalId
	s Rtn=##class(web.DHCBL.CARDIF.ICardRefInfo).SavePCAInfoToServer(ConfigInfo, PaPatInfo, CardInfo, AccInfo, DepositInfo, CardINVInfo, SepcialInfo, ExpStr) 
	s status=+Rtn
	if status=0 {
		q Rtn
	}
	elseif status=-304
	{
		q "-50^(Relate)注册失败:此卡号已经存在,不能发卡"
	}
	elseif status=-364
	{
		q "-50^(Relate)注册失败:已经存在此卡类型下的有效卡,不允许再发!"
	}
	elseif status=-365
	{
		q "-51^(Relate)注册失败:此证件号码已经存在,请办理其他卡或办理补卡!"
	}
	elseif status=-367
	{
		q "-51^(Relate)注册失败:证件号码不能为空!"
	}
	elseif status=-369
	{
		q "-51^(Relate)注册失败:办理卡绑定时,获取患者信息错误!"
	}
	elseif status=-351
	{
		q "-55^(Relate)此卡已经被挂失,不能使用"
	}
	elseif status=-352
	{
		q "-54^(Relate)此卡已经被作废,不能使用"
	}
	else
	{
		q "-1^(Relate)注册失败,失败信息:"_$p(Rtn,$c(1),1)
	}
RelateErr
	q "-1^CardRelate发生异常:"_$ZERROR
}

ClassMethod CardModify(InfoObj As DHCExternalService.CardInterface.Entity.PatInfo) As %String
{
	s $ZT="ModifyErr"
	s PersonObj=##class(User.PAPerson).%OpenId(InfoObj.PatientID)
	s PatMasObj=##class(User.PAPatMas).%OpenId(InfoObj.PatientID)
	s OldInfo=##class(web.DHCBL.Patient.DHCPatientBuilder).SearchPatInfoByRowID(InfoObj.PatientID)
	if '$IsObject(PersonObj){
		q "-1^病人主索引不正确"
	}
	/*
	s Sex=##class(DHCExternalService.CardInterface.GetRelate).GetSex(InfoObj.BankCode,InfoObj.Sex)
	i Sex=""{
		q "-1^性别对照不正确"
	}
	d PersonObj.PAPERSexDRSetObjectId(Sex)
	s TempName=$tr(InfoObj.PatientName," ")
	i TempName=""{
		q "-1^姓名信息不正确"
	}
	s PersonObj.PAPERName=Name
	
	i ..ValidDate(InfoObj.DOB)=-1 {
		q "-1^出生日期格式不正确"
	}
	s PersonObj.PAPERDob=InfoObj.DOB
	*/
	s MaritalStatus=##class(DHCExternalService.CardInterface.GetRelate).GetMarital(InfoObj.BankCode,InfoObj.MaritalStatus)
	i MaritalStatus=""{
		q "-1^婚姻状况格式不正确"
	}
	i PersonObj.PAPERMaritalDRGetObjectId()="" d PersonObj.PAPERMaritalDRSetObjectId(MaritalStatus)
	
	i InfoObj.Mobile=""{
		q "-1^手机号(个人电话)不能为空"
	}
	s PersonObj.PAPERMobPhone=InfoObj.Mobile
	
	s Nation=##class(DHCExternalService.CardInterface.GetRelate).GetNation(InfoObj.BankCode,InfoObj.Nation)
	i PersonObj.PAPERNationDRGetObjectId()="" d PersonObj.PAPERNationDRSetObjectId(Nation)
	s Occupation=##class(DHCExternalService.CardInterface.GetRelate).GetOccupation(InfoObj.BankCode,InfoObj.Occupation)
	i PersonObj.PAPEROccupationDRGetObjectId()="" d PersonObj.PAPEROccupationDRSetObjectId(Occupation)
	
	s Nationality=##class(DHCExternalService.CardInterface.GetRelate).GetNationality(InfoObj.BankCode,InfoObj.Nationality)
	i PersonObj.PAPERCountryDRGetObjectId()="" d PersonObj.PAPERCountryDRSetObjectId(Nationality)
	
	s IDCardType=##class(DHCExternalService.CardInterface.GetRelate).GetIDCardType(InfoObj.BankCode,InfoObj.IDType)
	i PatMasObj.PAPMICardTypeDRGetObjectId()="" d PatMasObj.PAPMICardTypeDRSetObjectId(IDCardType)
	s PatType=##class(DHCExternalService.CardInterface.GetRelate).GetPatType(InfoObj.BankCode,InfoObj.PatientType)
	i PersonObj.PAPERSocialStatusDRGetObjectId()="" d PersonObj.PAPERSocialStatusDRSetObjectId(PatType)
	
	s ZipInfo=##class(DHCExternalService.CardInterface.GetRelate).GetZip(InfoObj.Zip)
	i PersonObj.PAPERZipDRGetObjectId()="" d PersonObj.PAPERZipDRSetObjectId($P(ZipInfo,"^",1))
	i PersonObj.PAPERCTProvinceDRGetObjectId()="" d PersonObj.PAPERCTProvinceDRSetObjectId($P(ZipInfo,"^",2))
	i PersonObj.PAPERCityCodeDRGetObjectId()="" d PersonObj.PAPERCityCodeDRSetObjectId($P(ZipInfo,"^",3))
	
	s Relation=##class(DHCExternalService.CardInterface.GetRelate).GetRelation(InfoObj.BankCode,InfoObj.Relation)
	i PersonObj.PAPERCTRLTDRGetObjectId()="" d PersonObj.PAPERCTRLTDRSetObjectId(Relation)
	
	i PatMasObj.PAPMIDVAnumber="" s PatMasObj.PAPMIDVAnumber=InfoObj.IDNo
	
	d ##class(web.DHCBL.CARD.UCardPaPatMasInfo).UpdatePAPMSID(InfoObj.PatientID,InfoObj.IDNo)
	
	i PersonObj.PAPERStName.Count()=0{
		d PersonObj.PAPERStName.Clear()
		;s PersonObj.PAPERStName.GetAt(i)
		d PersonObj.PAPERStName.Insert(InfoObj.Address)
	}
	s PersonObj.PAPERSecondPhone =InfoObj.Company
	//s PPAPersonInfo.EmployeeCompany=InfoObj.Company
	
	s PersonObj.PAPERTelH=InfoObj.TelephoneNo
	s PersonObj.PAPERTelO=InfoObj.CompanyTelNo
	
	s PersonObj.PAPERForeignId=InfoObj.ContactName
	s PersonObj.PAPERForeignPostCode=InfoObj.ContactTelNo
	
	s PersonObj.PAPERUpdateDate= +$h
	s sc=PersonObj.%Save()
 	If $$$ISERR(sc) {
		Do $System.Status.DisplayError(sc)
 		q "-1^更新人员信息失败PAPerson"
 	}
 	s sc=PatMasObj.%Save()
 	If $$$ISERR(sc) {
		Do $System.Status.DisplayError(sc)
 		q "-1^更新人员信息失败PAPatMas"
 	}
	s NewInfo=##class(web.DHCBL.Patient.DHCPatientBuilder).SearchPatInfoByRowID(InfoObj.PatientID)
 	s LogInfo=##class(web.DHCBL.Patient.DHCPatientBuilder).CheckPatInfoUpdate(OldInfo,NewInfo)
 	s User=##class(DHCExternalService.CardInterface.GetRelate).GetUser()
 	s Flag=##class(web.DHCBL.Patient.DHCPatientBuilder).AddDHCPatientUpdateLog(LogInfo,User)
 	if Flag'=0{
		q "-1^更新人员信息日志失败"
 	}
 	q "0^成功"
ModifyErr
	q "-1^CardModify发生异常"_$ZERROR
}

/// w ##class(DHCExternalService.CardInterface.CardManager).UpdateAdmedReason(PatientID)
ClassMethod CardReportLoss(InfoObj As DHCExternalService.CardInterface.Entity.PatInfo) As %String
{
	s $ZT="CardReportLossErr"
	
	s CardType=##class(GetRelate).GetCardType(InfoObj.BankCode,"","")
	s Status=..CardHadCreate(CardType,InfoObj.PatientCard)
	i $piece(Status,"^",1)=""{
		q "-1^系统中卡号不存在"
	}elseif($piece(Status,"^",1)="S")
	{
		q "-50^此卡已挂失"
	}
	elseif(($piece(Status,"^",1)'="N")&&($piece(Status,"^",1)'="UA")){
		s StatusDesc=..GetCardStatusDesc($piece(Status,"^",1))
		q "-1^"_"卡号在系统中状态为'"_StatusDesc_"'"
	}
	s CardInfo=##class(web.DHCEntity.PCA.CardStatusChange).%New()
	s PersonObj=##class(User.PAPerson).%OpenId(InfoObj.PatientID)
	if '$IsObject(PersonObj){
		q "-1^病人主索引不正确"
	}
	s CardID=##class(DHCExternalService.CardInterface.CardManager).GetCardIDByCardNo(CardType,InfoObj.PatientCard)
	s CardInfo.CardNo=InfoObj.PatientCard
	s CardInfo.CardID=CardID
	s CredType=##class(DHCExternalService.CardInterface.GetRelate).GetIDCardType(InfoObj.BankCode,InfoObj.IDType)
	//s CardStatus=..GetCardStatus(CardID)
	//##class(GetRelate).GetIDCardType(InputObj.BankCode,InputObj.IDType)
	s CardInfo.ComputerIP=InfoObj.BankCode
	s CardInfo.UserDR=##class(DHCExternalService.CardInterface.GetRelate).GetUser()
	
	s CardInfo.RLName=PersonObj.PAPERName
	s CardInfo.RLPhoneNo=PersonObj.PAPERTelH
	s:PersonObj.PAPERStName.Count()'=0 CardInfo.RLAddress=PersonObj.PAPERStName.GetAt(PersonObj.PAPERStName.Count())
	s PatInfo=##class(User.PAPatMas).%OpenId(InfoObj.PatientID)
	s CardInfo.RLCredTypeID=CredType
	s CardInfo.RLCredNo=InfoObj.IDCode
	s CardInfo.RLCredType=CredType
	s rtn=CardInfo.XMLExportToString(.XML,"DHCCardStatusChange")
	i ($system.Status.IsError(rtn)) {
		q "-1^挂失失败:序列化卡状态对象失败"
	 }
	
	s rtn=##class(web.DHCBL.CARD.UCardStatusChangeBuilder).CardReportOrCancelLoss(XML,$piece(Status,"^",1))
	if rtn'="0" {
		q "-1^挂失失败：错误号"_rtn
	}
	q "0^成功"
CardReportLossErr
	q "-1^CardReportLossErr发生异常"_$ZERROR
}

ClassMethod CardCancelLoss(InfoObj As DHCExternalService.CardInterface.Entity.PatInfo) As %String
{
	;web.DHCBL.CARD.UCardStatusChangeBuilder.CardReportOrCancelLoss
	s CardType=##class(GetRelate).GetCardType(InfoObj.BankCode,"","")
	s Status=..CardHadCreate(CardType,InfoObj.PatientCard)
	i $piece(Status,"^",1)=""{
		q "-1^系统中卡号不存在"
	}elseif($piece(Status,"^",1)'="S"){
		s StatusDesc=..GetCardStatusDesc($piece(Status,"^",1))
		q "-50^此卡已解除挂失"               //_"卡号在系统中状态为'"_StatusDesc_"'"
	}
	s CardInfo=##class(web.DHCEntity.PCA.CardStatusChange).%New()
	s PersonObj=##class(User.PAPerson).%OpenId(InfoObj.PatientID)
	if '$IsObject(PersonObj){
		q "-1^病人主索引不正确"
	}
	s CardID=##class(DHCExternalService.CardInterface.CardManager).GetCardIDByCardNo(CardType,InfoObj.PatientCard)
	s CardInfo.CardNo=InfoObj.PatientCard
	s CardInfo.CardID=CardID
	s CredType=##class(DHCExternalService.CardInterface.GetRelate).GetIDCardType(InfoObj.BankCode,InfoObj.IDType)
	//s CardStatus=..GetCardStatus(CardID)
	
	s CardInfo.ComputerIP=InfoObj.BankCode
	s CardInfo.UserDR=##class(DHCExternalService.CardInterface.GetRelate).GetUser()
	
	s CardInfo.RLName=PersonObj.PAPERName
	s CardInfo.RLPhoneNo=PersonObj.PAPERTelH
	s:PersonObj.PAPERStName.Count()'=0 CardInfo.RLAddress=PersonObj.PAPERStName.GetAt(PersonObj.PAPERStName.Count())
	s PatInfo=##class(User.PAPatMas).%OpenId(InfoObj.PatientID)
	s CardInfo.RLCredTypeID=CredType
	s CardInfo.RLCredNo=InfoObj.IDCode
	s CardInfo.RLCredType=CredType
	s rtn=CardInfo.XMLExportToString(.XML,"DHCCardStatusChange")
	i ($system.Status.IsError(rtn)) {
		q "-1^撤销挂失失败:序列化卡状态对象失败"
	 }
	 
	s rtn=##class(web.DHCBL.CARD.UCardStatusChangeBuilder).CardReportOrCancelLoss(XML,$piece(Status,"^",1))
	if rtn'="0" {
		q "-1^撤销挂失失败：错误号"_rtn
	}
	q "0^成功"
}

ClassMethod RemoveCardInfo(XMLRequest As %String) As DHCExternalService.CardInterface.Entity.RemoveCardInfoRp
{
	Set $ZTRAP="RemoveCardInfoErr"
	Set InputObj=##class(DHCExternalService.CardInterface.Entity.RemoveCardInfoRt).%New()
	d InputObj.XMLNodeDeserialize(.InputObj,"Request",XMLRequest)
	Set OutputObj=##class(DHCExternalService.CardInterface.Entity.RemoveCardInfoRp).%New()
	Set PatientNo=InputObj.PatientID
	Set CardTypeCode=InputObj.CardTypeCode
	Set CardType=##class(DHCExternalService.RegInterface.GetRelate).GetHisCardTypeID(CardTypeCode)
	Set PatientCard=InputObj.PatientCard
	s UserDR=##class(DHCExternalService.RegInterface.GetRelate).GetUser(InputObj.ExtUserID)
	s PatientID=""
	if (PatientNo'=""){
		s PatientID=$O(^PAPERi("PAPMI_PatNo",PatientNo,0))
	}
	if (PatientID=""){
		d ..SetOutputCode(.OutputObj,"-104","登记号不得为空" )
		quit OutputObj
	}
	
	if (CardType=""){
		d ..SetOutputCode(.OutputObj,"-107","卡类型不得为空" )
		quit OutputObj
	}
	if (PatientCard=""){
		d ..SetOutputCode(.OutputObj,"-106","卡号不得为空" )
		quit OutputObj
	}
	
	if (UserDR=""){
		d ..SetOutputCode(.OutputObj,"-106","ExtUserID操作员代码不得为空" )
		quit OutputObj
	}
	
	s CardInfo=##class(web.DHCEntity.PCA.CardStatusChange).%New()
	s PersonObj=##class(User.PAPerson).%OpenId(PatientID)
	if '$IsObject(PersonObj){
		d ..SetOutputCode(.OutputObj,"-120","病人主索引不正确" )
		quit OutputObj
	}
	s CardID=##class(DHCExternalService.CardInterface.CardManager).GetCardIDByCardNo(CardType,PatientCard)
	if (CardID=""){
		d ..SetOutputCode(.OutputObj,"-127","卡记录不存在" )
		quit OutputObj
	}
	
	s CardInfo.CardNo=PatientCard
	s CardInfo.CardID=CardID
	s CredType=##class(DHCExternalService.CardInterface.GetRelate).GetIDCardType("",InputObj.IDType)
	
	//s CardInfo.ComputerIP=InfoObj.BankCode
	s CardInfo.UserDR=UserDR
	
	s CardInfo.RLName=PersonObj.PAPERName
	s CardInfo.RLPhoneNo=PersonObj.PAPERTelH
	s:PersonObj.PAPERStName.Count()'=0 CardInfo.RLAddress=PersonObj.PAPERStName.GetAt(PersonObj.PAPERStName.Count())
	s PatInfo=##class(User.PAPatMas).%OpenId(PatientID)
	s CardInfo.RLCredTypeID=CredType
	s CardInfo.RLCredNo=CredType
	s CardInfo.RLCredType=CredType
	s rtn=CardInfo.XMLExportToString(.CardStatusChangeInfo,"CardStatusChange")
	i ($system.Status.IsError(rtn)) {
		d ..SetOutputCode(.OutputObj,"-121","注销失败:序列化卡状态对象失败" )
		quit OutputObj
	}
	s ExpStr=""
	s rtn=##Class(web.DHCBL.CARD.UCardRefBulider).CancelCardInfo(UserDR, "A", CardStatusChangeInfo, ExpStr)
	if rtn'="0" {
		d ..SetOutputCode(.OutputObj,"-122", "注销失败：错误号"_rtn)
		quit OutputObj
	}
	
	s OutputObj.TradeCode=InputObj.TradeCode
	d ..SetOutputCode(.OutputObj,"0", "成功")
	quit OutputObj

	
RemoveCardInfoErr
	Set OutputObj=##class(DHCExternalService.CardInterface.Entity.RemoveCardInfoRp).%New()
	Set OutputObj.ResultCode="-1"
	Set OutputObj.ErrorMsg="解绑失败:"_$ZError
	quit OutputObj
}

ClassMethod CardCancel(InfoObj As DHCExternalService.CardInterface.Entity.PatInfo, Bindflag As %String = "") As %String
{
	//d ##class(web.DHCBL.CARDIF.ICardRefInfo).CancelCardInfo(xml)
	s CardType=##class(GetRelate).GetCardType(InfoObj.BankCode,"",Bindflag)
	s Status=..CardHadCreate(CardType,InfoObj.PatientCard)
	i $piece(Status,"^",1)=""{
		q "-1^系统中卡号不存在"
	}elseif($piece(Status,"^",1)="R"){
		s StatusDesc=..GetCardStatusDesc($piece(Status,"^",1))
		q "-50^此卡已注销"             //_"卡号在系统中状态为'"_StatusDesc_"'"
	}elseif($piece(Status,"^",1)="D")
	{
		s StatusDesc=..GetCardStatusDesc($piece(Status,"^",1))
		q "-52^"_"卡号在系统中状态为'"_StatusDesc_"'"
	}
	
	s CardInfo=##class(web.DHCEntity.PCA.CardStatusChange).%New()
	s PersonObj=##class(User.PAPerson).%OpenId(InfoObj.PatientID)
	if '$IsObject(PersonObj){
		q "-1^病人主索引不正确"
	}
	s CardID=##class(DHCExternalService.CardInterface.CardManager).GetCardIDByCardNo(CardType,InfoObj.PatientCard)
	set myCardDR=$piece($get(^DHCCARD("CF",CardID)),"^",23)
	if (myCardDR'="")
	{
		q "-1^此交易不能解绑健康卡"
	}
	s CardInfo.CardNo=InfoObj.PatientCard
	s CardInfo.CardID=CardID
	s CredType=##class(DHCExternalService.CardInterface.GetRelate).GetIDCardType(InfoObj.BankCode,InfoObj.IDType)
	//s CardStatus=..GetCardStatus(CardID)
	
	s CardInfo.ComputerIP=InfoObj.BankCode
	s CardInfo.UserDR=##class(DHCExternalService.CardInterface.GetRelate).GetUser()
	
	s CardInfo.RLName=PersonObj.PAPERName
	s CardInfo.RLPhoneNo=PersonObj.PAPERTelH
	s:PersonObj.PAPERStName.Count()'=0 CardInfo.RLAddress=PersonObj.PAPERStName.GetAt(PersonObj.PAPERStName.Count())
	s PatInfo=##class(User.PAPatMas).%OpenId(InfoObj.PatientID)
	s CardInfo.RLCredTypeID=CredType
	s CardInfo.RLCredNo=InfoObj.IDCode
	s CardInfo.RLCredType=CredType
	s rtn=CardInfo.XMLExportToString(.XML,"DHCCardStatusChange")
	i ($system.Status.IsError(rtn)) {
		q "-1^注销失败:序列化卡状态对象失败"
	 }
	//s rtn=..CardRepeal(XML)
	s rtn=##Class(web.DHCBL.CARD.UCardRefBulider).CancelCardInfo(UserDR, sFlag, CardStatusChangeInfo, ExpStr)
	if rtn'="0" {
		q "-1^注销失败：错误号"_rtn
	}

	q "0^成功"
}

ClassMethod CardRepeal(CardStatusChangeInfo As %String) As %String
{
	s StatusInfo=##class(web.DHCEntity.PCA.CardStatusChange).%New()
	d StatusInfo.XMLNodeDeserialize(.StatusInfo,"DHCCardStatusChange",CardStatusChangeInfo)
	
	set rtn=0
	;1.验证卡状态
	set status=##class(web.DHCBL.CARD.CardManager).GetCardStatus(StatusInfo.CardID)
	if (status="R")||(status="D") {
		set rtn= -359 ;作废的卡不能再进行作废
	}
	
	s myCardRegConfig=##class(web.DHCBL.CARD.CardPATRegConfig).GetCardPatRegConfig()
	s myCardRefFlag=$p(myCardRegConfig, "^", 5)
	s myAccManageFLag= $p(myCardRegConfig, "^", 6)
	;2.回收卡
	if ((myCardRefFlag="Y")&&(+rtn=0)) {
		set StatusInfo.ActiveFlag="R"
		set rtn=##class(web.DHCBL.CARD.CardStatusChange).UpdateCardStatus(StatusInfo)
		set rtn=+rtn
	}
	
	;2.写回收卡状态记录
	if ((myCardRefFlag="Y")&&(+rtn=0)) {
		set StatusInfo.ActiveFlag="R"
		set rtn=##class(web.DHCBL.CARD.CardStatusChange).Insert(StatusInfo)
		set rtn=+rtn
	}
	;3.根据帐户配置,如果有帐户信息,更新帐户状态
	if ((myAccManageFLag="Y")&&(+rtn=0)) {
		set CardAccStatus=##class(web.DHCBL.CARD.CardManager).GenerateoCardAccStatus(StatusInfo,"N")
		if CardAccStatus.AccountID'=""
		{
			set myStatusInfo=##class(web.DHCBL.CARD.UCardAccStatusChange).Insert(CardAccStatus)
			i (+myStatusInfo<0){
				s rtn=+myStatusInfo
			}
			
		}
	}
	
	quit rtn
}

ClassMethod CardChange(InfoObj As DHCExternalService.CardInterface.Entity.PatInfo) As %String
{
	;web.DHCBL.CARD.UCardStatusChangeBuilder.CardExechange
	
	i InfoObj.NewPatientCard=""{
		q "-1^新卡号不能为空"
	}
	s CardInfo=##class(web.DHCEntity.PCA.CardStatusChange).%New()
	s PersonObj=##class(User.PAPerson).%OpenId(InfoObj.PatientID)
	if '$IsObject(PersonObj){
		q "-1^病人主索引不正确"
	}
	
	s CardType=##class(GetRelate).GetCardType(InfoObj.BankCode,"","")
	s Status=..CardHadCreate(CardType,InfoObj.OldPatientCard)
	i $piece(Status,"^",1)=""{
		q "-1^系统中旧卡号不存在"
	}elseif(($piece(Status,"^",1)'="N")&&($piece(Status,"^",1)'="UA")){
		s StatusDesc=..GetCardStatusDesc($piece(Status,"^",1))
		s NewStatus=..CardHadCreate(CardType,InfoObj.NewPatientCard)
		if ($piece(NewStatus,"^",1)'=""){
			set NewPatientID=$piece(NewStatus,"^",2)
			s StatusDesc=..GetCardStatusDesc($piece(NewStatus,"^",1))
			if (InfoObj.PatientID=NewPatientID)&&(($piece(NewStatus,"^",1)="N")||($piece(NewStatus,"^",1)="UA"))
			{
				q "-50^已换卡成功"
			}
			else
			{
				q "-52^"_"新卡号在系统中已存在,状态为'"_StatusDesc_"'"_",不能再作新卡"
			}
		}
		else
		{	
			q "-52^"_"旧卡号在系统中状态为'"_StatusDesc_"'"_",不能换卡"
		}
	}
	
	
	s CardID=##class(DHCExternalService.CardInterface.CardManager).GetCardIDByCardNo(CardType,InfoObj.OldPatientCard)
	s CardInfo.CardTypeDefine=CardType
	s CardInfo.CardNo=InfoObj.PatientCard
	s CardInfo.CardID=CardID
	s CredType=##class(DHCExternalService.CardInterface.GetRelate).GetIDCardType(InfoObj.BankCode,InfoObj.IDType)
	//s CardStatus=..GetCardStatus(CardID)
	
	s CardInfo.ComputerIP=InfoObj.BankCode
	s CardInfo.UserDR=##class(DHCExternalService.CardInterface.GetRelate).GetUser()
	
	
	s NewStatus=..CardHadCreate(CardType,InfoObj.NewPatientCard)
	if ($piece(NewStatus,"^",1)'=""){
		s StatusDesc=..GetCardStatusDesc($piece(NewStatus,"^",1))
		q "-52^"_"新卡号在系统中已存在,状态为'"_StatusDesc_"'"_",不能再作新卡"
		
	}
	s CardInfo.ExchangeCardNo=InfoObj.NewPatientCard
	s CardInfo.SecrityNo=##class(web.UDHCAccEnrypt).Decrypt(InfoObj.SecurityNo)
	
	s CardInfo.RLName=PersonObj.PAPERName
	s CardInfo.RLPhoneNo=PersonObj.PAPERTelH
	s:PersonObj.PAPERStName.Count()'=0 CardInfo.RLAddress=PersonObj.PAPERStName.GetAt(PersonObj.PAPERStName.Count())
	s PatInfo=##class(User.PAPatMas).%OpenId(InfoObj.PatientID)
	s CardInfo.RLCredType=CredType
	s CardInfo.RLCredTypeID=CredType
	s CardInfo.RLCredNo=InfoObj.IDCode
	
	s rtn=CardInfo.XMLExportToString(.XML,"DHCCardStatusChange")
	i ($system.Status.IsError(rtn)) {
		q "-1^换卡失败:序列化卡状态对象失败"
	 }
	s rtn=##class(web.DHCBL.CARD.UCardStatusChangeBuilder).CardExechange(XML)
	if +rtn'="0" {
		q "-1^换卡失败：错误号"_rtn
	}
	q "0^换卡成功"
}

ClassMethod CardSigned(InfoObj As DHCExternalService.CardInterface.Entity.PatInfo) As %String
{
	s CardType=##class(GetRelate).GetCardType(InfoObj.BankCode,"","")
	s Status=..CardHadCreate(CardType,InfoObj.PatientCard)
	i $piece(Status,"^",1)=""{
		q "-1^系统中卡号不存在"
	}elseif(($piece(Status,"^",1)'="N")&&($piece(Status,"^",1)'="UA")){
		s StatusDesc=..GetCardStatusDesc($piece(Status,"^",1))
		q "-52^"_"卡号在系统中状态为'"_StatusDesc_"'"
	}
	s CardID=##class(DHCExternalService.CardInterface.CardManager).GetCardIDByCardNo(CardType,InfoObj.PatientCard)
	s SignStatus=..GetSignStatus(CardID)
	i SignStatus=1{
		q "-50^此卡已经签约"
	}
	q ..SetSignStatus(CardID,"1")
}

ClassMethod CardCancelSigned(InfoObj As DHCExternalService.CardInterface.Entity.PatInfo) As %String
{
	s CardType=##class(GetRelate).GetCardType(InfoObj.BankCode,"","")
	s Status=..CardHadCreate(CardType,InfoObj.PatientCard)
	i $piece(Status,"^",1)=""{
		q "-1^系统中卡号不存在"
	}elseif(($piece(Status,"^",1)'="N")&&($piece(Status,"^",1)'="UA")){
		s StatusDesc=..GetCardStatusDesc($piece(Status,"^",1))
		q "-52^"_"卡号在系统中状态为'"_StatusDesc_"'"
	}
	s CardID=##class(DHCExternalService.CardInterface.CardManager).GetCardIDByCardNo(CardType,InfoObj.PatientCard)
	s SignStatus=..GetSignStatus(CardID)
	i SignStatus'=1{
		q "-50^此卡未签约,不需要解约"
	}
	q ..SetSignStatus(CardID,"0")
}

ClassMethod SetSignStatus(CardID, Status)
{
	//&sql(Update sqluser.DHC_CardRef set CF_BankSignFlag=:Status where CF_RowID=:CardID)
	i SQLCODE'=0{
		q "-1^更新签约状态失败,错误号:"_SQLCODE
	}
	q "0^修改签约状态成功"
}

ClassMethod GetCardSignedStatus(InfoObj As DHCExternalService.CardInterface.Entity.PatInfo) As %String
{
	s CardType=##class(GetRelate).GetCardType(InfoObj.BankCode,"","")
	s Status=..CardHadCreate(CardType,InfoObj.PatientCard)
	i $piece(Status,"^",1)=""{
		q "0^0"
		;q "-1^系统中卡号不存在"
	}elseif(($piece(Status,"^",1)'="N")&&($piece(Status,"^",1)'="UA")){
		q "0^0"
		;s StatusDesc=..GetCardStatusDesc($piece(Status,"^",1))
		;q "-1^"_"卡号在系统中状态为'"_StatusDesc_"'"
	}
	s CardID=##class(DHCExternalService.CardInterface.CardManager).GetCardIDByCardNo(CardType,InfoObj.PatientCard)
	s SignStatus=..GetSignStatus(CardID)
	set CardTypeCode=$P(^DHCCARDTYPEDef(CardType),"^",1)
	if (CardTypeCode["-B")&&(SignStatus=1) set SignStatus=2
	q "0^"_SignStatus
}

ClassMethod ActiveCardCheck(PatientID, PatType, CardType, CardNo, CredType, CredNo)
{
	s YYKFlag=0
	s ModifyReg=0
	s PatientNum=0
	;s CardTypeCode=$P(^DHCCARDTYPEDef(CardType),"^",1)
	q:'..IsBankCard(CardType) YYKFlag_"^"_ModifyReg_"^"_PatientNum
	s id=0
	f  s id=$O(^DHCCARDi("CF",0,"CardTypeNo",CardType,CardNo,id)) q:id=""  d
	.s Status=$P(^DHCCARD("CF",id),"^",10)
	.q:(Status'="N")&&(Status'="UA")
	.s:Status="N" YYKFlag=-1
	q:YYKFlag=-1 YYKFlag_"^"_ModifyReg_"^"_PatientNum
	s YYKFlag=1
	i CredNo="" {
		s PatientNum=1
	}else{
		s CheckInfo=..CheckInfoByIDCard(CredType,CredNo)
		s PatientNum=$P(CheckInfo,"^",3)
	}
	s OldPatType=$P(^PAPER(PatientID,"PER",1),"^",10)
	i OldPatType=PatType{
		q YYKFlag_"^"_ModifyReg_"^"_PatientNum
	}else{
		s id=0
		f  s id=$O(^PAPERdr(PatientID,"ADM","O",id)) q:id=""  d
		.s ActiveFlag=$P(^PAADM(id),"^",20)
		.q:ActiveFlag="C"
		.s Date=$P(^PAADM(id),"^",6)
		.q:Date<+$H  ;只是判断了日期,没有判断时间
		.s ModifyReg=ModifyReg+1
		s id=0
		f  s id=$O(^PAPERdr(PatientID,"ADM","E",id)) q:id=""  d
		.s ActiveFlag=$P(^PAADM(id),"^",20)
		.q:ActiveFlag="C"
		.s Date=$P(^PAADM(id),"^",6)
		.q:Date<+$H  ;只是判断了日期,没有判断时间
		.s ModifyReg=ModifyReg+1
		q YYKFlag_"^"_ModifyReg_"^"_PatientNum
	}
}

ClassMethod ActiveCard(myConfigInfo As %String, myPatInfo As %String, myCardInfo As %String, myAccInfo As %String, myAccDepInfo As %String, myCardInvInfo As %String, mySpecInfo As %String, myExpStr As %String)
{
	TSTART
	s rtn=##class(web.DHCBL.CARD.UCardPatRegBuilder).SavePCAInfoToServer(myConfigInfo, myPatInfo, myCardInfo, myAccInfo, myAccDepInfo, myCardInvInfo, mySpecInfo, "1")
	i +rtn'=0{
		TROLLBACK
		q "-1^修改患者信息错误"
	}
	s PatientID=$P(myExpStr,"^",1)
	s ModifyReg=$P(myExpStr,"^",2)
	s PatType=$P(myExpStr,"^",3)
	s CardType=$P(myExpStr,"^",4)
	s CardNo=$P(myExpStr,"^",5)
	s UserID=$P(myExpStr,"^",6)
	s IP=$P(myExpStr,"^",7)
	s ExpStr=UserID_"^"_IP
	s rtn=..ModifyCardActive(CardType,CardNo,ExpStr)
	i rtn'=0{
		TROLLBACK
		q "-1^更新卡激活状态错误"
	}
	s SQLCODE=0
	i ModifyReg>0{
		
		s id=0
		f  s id=$O(^PAPERdr(PatientID,"ADM","O",id)) q:id=""||SQLCODE'=0  d
		.s ActiveFlag=$P(^PAADM(id),"^",20)
		.q:ActiveFlag="C"
		.s Date=$P(^PAADM(id),"^",6)
		.q:Date<+$H  ;只是判断了日期,没有判断时间
		.s SQLCODE=##class(web.DHCOPChgAdmreason).SetPattype("","",PatType,id,"","")
		s rtn=SQLCODE
	}
	i SQLCODE'=0{
		TROLLBACK
		q "-1^更新费别错误"
	}
	TCOMMIT
	q "0^卡激活成功"
}

ClassMethod ModifyCardActive(CardType, CardNo, ExpStr)
{
	s UserID=$P(ExpStr,"^",1)
	s IP=$P(ExpStr,"^",2)
	s rtn=0
	s id=0
	f  s id=$O(^DHCCARDi("CF",0,"CardTypeNo",CardType,CardNo,id)) q:id=""  d
	.s Status=$P(^DHCCARD("CF",id),"^",10)
	.q:Status'="UA"
	.s rtn=##class(web.UDHCAccCardManage).CardStatusChange(id,"N",UserID,IP,"")
	q rtn
}

ClassMethod GetSignStatus(CardID)
{
	q $P(^DHCCARD("CF",CardID),"^",19)
}

ClassMethod GetIDTotal(RegNo, Type As %String = "RegNo")
{
	i Type="RegNo"{
		s PatientID=$O(^PAPERi("PAPMI_PatNo",RegNo,0))
		q:PatientID="" "0^^0"
	}else{
		s PatientID=RegNo
	}
	s IDCard=$P(^PAPER(PatientID,"PAT",3),"^",6)
	q:IDCard="" "0^"_PatientID_"^1"
	s IDCardType=$P(^PAPER(PatientID,"PAT",3),"^",7)
	s PatName=$P(^PAPER(PatientID,"ALL"),"^",1)
	s Length=$L(IDCard)
	q:(IDCardType="1")&&((Length'=15)&&(Length'=18)) "0^"_PatientID_"^1"
	s MutipuleIDInfo=..CheckInfoByIDCard(IDCardType,IDCard,"",PatName)

	s HighlevelID=$P(MutipuleIDInfo,"^",2)
	s IDTotal=$P(MutipuleIDInfo,"^",3)
	s IDStr=$P(MutipuleIDInfo,"^",4)
	;判断例外
	i (+IDTotal>1)&&(HighlevelID'=PatientID) {
		s UniteCheckFlag=0
		f IDLoop=1:1:$l(IDStr,$C(2)) q:UniteCheckFlag=1  d
		.s ID=$p(IDStr,$C(2),IDLoop)
		.q:ID=""
		.q:ID=HighlevelID	
		.s RegNo=$p($g(^PAPER(ID,"PAT",1)),"^",1)
		.s UniteCheckInfo=##class(web.DHCPATCardUnite).CheckCardUnite(RegNo)
  		.s UniteCheckFlag=$p(UniteCheckInfo,"^",1)
  		b ;22
  		q:UniteCheckFlag=1 "0^"_PatientID_"^1"
	}
	
	q MutipuleIDInfo
}

/// 根据患者必要信息是否存在有效的患者记录
/// input: 姓名  出生日期(2020-01-01) 性别(Code) 电话  卡类型
ClassMethod CheckInfoByPatInfo(Name As %String, Dob As %String, Sex As %String, Tel As %String, CardTypeID As %String)
{
	s HadFlag=0, CurStatus="", IDStr=""
	i $d(^PAPERi("PAPER_PatName",$$ALPHAUP^SSUTIL4(Name))) {
		s PatRowId=0 f  {
			s PatRowId=$o(^PAPERi("PAPER_PatName",$$ALPHAUP^SSUTIL4(Name),PatRowId))
			q:PatRowId=""
			s PatDob=$p($g(^PAPER(PatRowId,"ALL")),"^",6)
			s:PatDob'="" PatDob=$zd(PatDob,3)
			s PatSex=$p($g(^PAPER(PatRowId,"ALL")),"^",7)
			s:PatSex'="" PatSex=$p(^CT("SEX",PatSex),"^",1)
			s PatTel=$p($g(^PAPER(PatRowId,"PER",1)),"^",11)
			s CredNo=$p($g(^PAPER(PatRowId,"PAT",3)),"^",6)
			if PatDob=Dob, PatSex=Sex, Tel=PatTel {
				s CfRowId=0 f {
					s CfRowId=$o(^DHCCARDi("CF",0,"PAPMIDR",PatRowId,CfRowId))
					q:CfRowId=""
					s CardType=$P(^DHCCARD("CF",CfRowId),"^",16)
					continue:(CardType'=CardTypeID)&&(CardTypeID'="")
					s Status=$P(^DHCCARD("CF",CfRowId),"^",10)
					continue:(Status'="N")&&(Status'="S")&&(Status'="UA")
					s HadFlag=1
					s CurStatus=Status
				}
			}
			if HadFlag=1 {
				i IDStr="" s IDStr=PatRowId
				e  s IDStr=IDStr_$C(2)_PatRowId
			}
		}
	}
	q HadFlag_"^"_CurStatus_"^"_IDStr
}

/// w ##class(DHCExternalService.CardInterface.CardManager).CheckInfoByIDCard(20,"110101199003071911")
ClassMethod CheckInfoByIDCard(IDCardType, IDCard, CardType As %String = "", Name As %String = "")
{
	q:IDCard="" "0^^0^"
	s Job=$J
	k ^TempGetCard(Job)
	//设置优先级ID
	s IDCredTypeID=$o(^PAC("CARD",0,"Code",..#IDCredTypeCode,""))
	i IDCardType=IDCredTypeID{
		if ($length(IDCard)=18){
			set myIDCardNo18=IDCard
			set myIDCardNo15=..ID18to15(IDCard)
		}else{
			set myIDCardNo15=IDCard
			set myIDCardNo18=..ID15to18(IDCard)
		}
		s ret=..GetIDByIDCard(IDCardType,myIDCardNo18,CardType,Name,Job)
		s Total=$P(ret,"^",3)
		if Total=0{
			s ret=..GetIDByIDCard(IDCardType,myIDCardNo15,CardType,Name,Job)	
		}
	}else{
		s ret=..GetIDByIDCard(IDCardType,IDCard,CardType,Name,Job)
	}
	s Total=$P(ret,"^",3)
	s IDStr=$P(ret,"^",4)
	//得到级别最高的ID
	s ID=""
	s Level=$O(^TempGetCard(Job,""))
	i Level'=""{
		s ID=$O(^TempGetCard(Job,Level,""),-1)
	}
	k ^TempGetCard(Job)
	
	q:$P(ret,"^",1)=1 $P(ret,"^",1,2)_"^"_Total_"^"_IDStr
	//同种类型的卡已经存在
	q "0^"_ID_"^"_Total_"^"_IDStr
}

/// w ##class(DHCExternalService.CardInterface.CardManager).GetIDByIDCard(IDCardType,IDCard)
ClassMethod GetIDByIDCard(IDCardType, IDCard, CardType As %String = "", Name As %String = "", Job)
{
	s Total=0
	s IDStr=""
	s IDCard=$ZCVT(IDCard,"U")
	s HadFlag=0
	s CurStatus=""
	q:IDCard="" HadFlag_"^"_CurStatus_"^"_Total_"^"_IDStr
	s PatientID=""
	f  s PatientID=$O(^PAPERi("DVA",IDCard,PatientID),-1) q:(PatientID="")||(HadFlag=1)  d
	.s ActiveFlag=$P(^PAPER(PatientID,"PAT",1),"^",6)
	.q:ActiveFlag="N"
	.s CurName=$P(^PAPER(PatientID,"ALL"),"^",1)
	.q:(CurName'=Name)&&(Name'="")
	.s CredType=$P(^PAPER(PatientID,"PAT",3),"^",7)
	.q:(CredType'=IDCardType)
	.s CurCardType=""
	.s Total=Total+1
	.i IDStr="" s IDStr=PatientID
	.e  s IDStr=IDStr_$C(2)_PatientID
	.s IDlevel=##class(web.DHCPATCardUnite).GetIDLevel(PatientID)
	.f  s CurCardType=$O(^DHCCARDi("CF",0,"PAPMICTDR",PatientID,CurCardType)) 	q:(CurCardType="")  d
	..s CardID=0
	..f  s CardID=$O(^DHCCARDi("CF",0,"PAPMICTDR",PatientID,CurCardType,CardID)) 	q:(CardID="")  d
	...s Status=$P(^DHCCARD("CF",CardID),"^",10)
	...;s Status="D"
	...q:(Status'="N")&&(Status'="S")&&(Status'="UA")
	...s:CurCardType=CardType HadFlag=1
	...s CurStatus=Status
	.s ^TempGetCard(Job,IDlevel,PatientID)=0
	q HadFlag_"^"_CurStatus_"^"_Total_"^"_IDStr
}

ClassMethod GetCardStatusDesc(CardStatus)
{
	q:CardStatus="S" "挂失"
	q:CardStatus="N" "正常"
	q:CardStatus="D" "作废"
	q:CardStatus="UA" "未激活"
	q "不存在"
}

ClassMethod CardHadCreate(CardType, CardNo)
{
	;只允许在系统中存在一个卡的情况适合使用
	s CardID="",Status="",PatientID=""
	s ID=0
	f  s ID=$O(^DHCCARDi("CF",0,"CardTypeNo",CardType,CardNo,ID)) q:ID=""  d
	.s Status=$P(^DHCCARD("CF",ID),"^",10)
	.s PatientID=$P(^DHCCARD("CF",ID),"^",4)
	q Status_"^"_PatientID
}

ClassMethod GetCardIDByCardNo(CardType, CardNo)
{
	;只允许在系统中存在一个卡的情况适合使用
	q $O(^DHCCARDi("CF",0,"CardTypeNo",CardType,CardNo,""),-1)
}

/// 日期检查
ClassMethod ValidDate(para As %String) As %String
{
	s $ZT="DateErr"
	q $ZDH(para,3)
DateErr
	q -1
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

/// 身份证号18位转15位
ClassMethod ID18to15(IDCardNo18 As %String = "") As %String
{
	if $length(IDCardNo18)'=18 quit IDCardNo18
	set IDCardNo15=$extract(IDCardNo18,1,6)_$extract(IDCardNo18,9,17)

	quit IDCardNo15
}

/// PatientID to RegNo
ClassMethod PatientIDToNo(PatientID As %String = "") As %String
{
	;w ##class(DHCExternalService.CardInterface.CardManager).PatientIDToNo("6")
	q:PatientID="" ""
	q $P($g(^PAPER(PatientID,"PAT",1)),"^",1)
}

/// RegNo to PatientID
ClassMethod PatientNoToID(RegNo As %String = "") As %String
{
	;w ##class(DHCExternalService.CardInterface.CardManager).PatientNoToID("00000006")
	q:RegNo="" ""
	q $O(^PAPERi("PAPMI_PatNo",RegNo,0))
}

/// 判断是否为银医卡
ClassMethod IsBankCard(CardType)
{
	s BankCode=##class(DHCExternalService.CardInterface.GetRelate).GetBankCodeByCardType(CardType)
	q:BankCode'="" 1
	q 0
}

ClassMethod ISynActiveCard(CardType, CardRowId, NewActiveFlag, Status = "")
{
	s myrtn=0
	s PatientID=$P($g(^DHCCARD("CF",CardRowId)),"^",4)
	s OldActiveFlag=$P($g(^DHCCARD("CF",CardRowId)),"^",10)
	i (CardType=4)&&(OldActiveFlag="UA")&&(NewActiveFlag="Y") {
		s PatType=$p($g(^PAPER(PatientID,"PER",1)),"^",10)
		i PatType'="" {
			s SQLCODE=0
			s id=0
			f  s id=$O(^PAPERdr(PatientID,"ADM","O",id)) q:(id="")||(SQLCODE'=0)  d
			.s ActiveFlag=$P(^PAADM(id),"^",20)
			.q:ActiveFlag="C"
			.s Date=$P(^PAADM(id),"^",6)
			.q:Date<+$H  ;只是判断了日期,没有判断时间
			.s SQLCODE=##class(web.DHCOPChgAdmreason).SetPattype("","",PatType,id,"","")
			s myrtn=SQLCODE
			i myrtn=0 {
				s id=0
				f  s id=$O(^PAPERdr(PatientID,"ADM","E",id)) q:(id="")||(SQLCODE'=0)  d
				.s ActiveFlag=$P(^PAADM(id),"^",20)
				.q:ActiveFlag="C"
				.s Date=$P(^PAADM(id),"^",6)
				.q:Date<+$H  ;只是判断了日期,没有判断时间
				.s SQLCODE=##class(web.DHCOPChgAdmreason).SetPattype("","",PatType,id,"","")
				s myrtn=SQLCODE
			}
			;s ^tmpgry("ISynActiveCard",1)=myrtn
		}
	}
	
	;就诊卡
	i (CardType=2)&&(Status="N") {
		s myrtn=..UpdateAdmedReason(PatientID)
	}
	
	q myrtn
}

ClassMethod UpdateAdmedReason(PatientID) As %String
{
	s myrtn=0
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
		.q:(DepDesc["国际医疗")||(DepDesc["口腔科特需门诊")
		.s SQLCODE=##class(web.DHCOPChgAdmreason).SetPattype("","",PatType,id,"")
		s myrtn=SQLCODE
		i myrtn=0 {
			s id=0
			f  s id=$O(^PAPERdr(PatientID,"ADM","E",id)) q:(id="")||(SQLCODE'=0)  d
			.s ActiveFlag=$P(^PAADM(id),"^",20)
			.q:ActiveFlag="C"
			.s Date=$P(^PAADM(id),"^",6)
			.q:Date<+$H  ;只是判断了日期,没有判断时间
			.s DepDesc=""
			.s DepCodeDR=$P(^PAADM(id),"^",4)
			.i DepCodeDR'="" s DepDesc=$p($g(^CTLOC(DepCodeDR)),"^",2)
			.q:(DepDesc["国际医疗")||(DepDesc["口腔科特需门诊")
			.s SQLCODE=##class(web.DHCOPChgAdmreason).SetPattype("","",PatType,id,"")
			s myrtn=SQLCODE
		}
	}
	
	q myrtn
}

/// w ##class(DHCExternalService.CardInterface.CardManager).FindPatientCard(^tmpnk("FindPatientCard"))
/// w ##class(DHCExternalService.CardInterface.CardManager).FindPatientCard("<Request><TradeCode>3013</TradeCode><IDType>01</IDType><IDNo>430105199201254314</IDNo><PatientName>对外接口测试</PatientName><CardTypeCode>02</CardTypeCode><PatientCard>430105199201254314</PatientCard><UserID>SF02</UserID><TerminalID></TerminalID></Request>").XMLExportToString(.str,"Response")
/// <Request><TradeCode>3013</TradeCode><IDType>10</IDType><IDNo>123456789009876</IDNo><PatientName>志明</PatientName><CardTypeCode></CardTypeCode><PatientCard></PatientCard><UserID></UserID><TerminalID></TerminalID><MobilePhone></MobilePhone><PatientSex></PatientSex><PatientDob></PatientDob></Request>
ClassMethod FindPatientCard(XMLRequest As %String) As DHCExternalService.CardInterface.Entity.FindPatientCardRp
{
	Set $ZTRAP="FindPatientCardErr"
	s InputObj=##class(DHCExternalService.CardInterface.Entity.FindPatientCardRt).%New()
	d InputObj.XMLNodeDeserialize(.InputObj, "Request", XMLRequest)
	Set TradeCode=InputObj.TradeCode
	Set CardTypeCode=InputObj.CardTypeCode
	Set PatientCard=InputObj.PatientCard
	Set PatientName=InputObj.PatientName
	Set IDType=InputObj.IDType
	Set IDNo=InputObj.IDNo
	Set PatientSex=InputObj.PatientSex
	Set PatientDob=InputObj.PatientDob
	Set MobilePhone=InputObj.MobilePhone
	Set SearchFlag=InputObj.SearchFlag
	Set HospitalId=InputObj.HospitalId
	Set HospitalId=##class(DHCExternalService.RegInterface.GetRelate).GetHISHospitalIdFromOuterCode(HospitalId) 
	Set TerminalID=InputObj.TerminalID
	Set OutputObj=##Class(DHCExternalService.CardInterface.Entity.FindPatientCardRp).%New()
	if HospitalId=""{
		d ..SetOutputCode(.OutputObj,"-100","请传入正确的院区代码.")
		quit OutputObj	
	}
	Set UserID=##class(DHCExternalService.RegInterface.GetRelate).GetUser(InputObj.UserID,"",HospitalId)
	if (UserID="") {
		d ..SetOutputCode(.OutputObj,"-100","请传入正确的操作用户.")
		quit OutputObj
	}
	Set GroupID=##class(DHCExternalService.RegInterface.GetRelate).GetGroup(UserID)
	if GroupID'=""{
		s BankCode=##class(DHCDoc.Interface.Outside.Config).GetConfigNode(GroupID,"DataCompareExtOrg",HospitalId)
		s CardTypeID=##class(DHCExternalService.RegInterface.GetRelate).GetHisCardTypeID(CardTypeCode,BankCode,"",HospitalId)
		s IDTypeID=##class(DHCExternalService.CardInterface.GetRelate).GetIDCardType(BankCode,IDType,HospitalId)
		s PatientSex=##class(DHCExternalService.CardInterface.GetRelate).GetSex(BankCode,PatientSex)
	}
	
	if (CardTypeID="") {
		d ..SetOutputCode(.OutputObj,"-100","卡类型不能为空.")
		quit OutputObj
	}else{
		if '$d(^DHCCARDTYPEDef(CardTypeID)){
			d ..SetOutputCode(.OutputObj,"-100","His中未找到此卡类型.")
			quit OutputObj
		}
	}
	if (PatientName="") {
		d ..SetOutputCode(.OutputObj,"-100","患者姓名不能为空.")
		quit OutputObj
	}
	Set HospShowDataFlag=##Class(DHCDoc.Common.Hospital).GetHospShowDataFlag("DHC_CardTypeDef",CardTypeID,HospitalId)
	if HospShowDataFlag="N"{
		d ..SetOutputCode(.OutputObj,"-100","该卡类型未在本院区授权使用,不能发卡")
		quit OutputObj
	}
	if SearchFlag=1 {
		;增加其他必要条件查找患者信息
		if (PatientSex="") {
			d ..SetOutputCode(.OutputObj,"-101","患者性别不能为空.")
			quit OutputObj
		}
		if (PatientDob="") {
			d ..SetOutputCode(.OutputObj,"-101","患者出生日期不能为空.")
			quit OutputObj
		}
		if (MobilePhone="") {
			d ..SetOutputCode(.OutputObj,"-101","患者联系电话不能为空.")
			quit OutputObj
		}
	}else {
		if (IDTypeID="") {
			d ..SetOutputCode(.OutputObj,"-102","证件类型不能为空.")
			q OutputObj
		}else{
			s rtn=##class(DHCExternalService.CardInterface.Common).CheckIDType(IDTypeID)
			if rtn'=""{
				d ..SetOutputCode(.OutputObj,"-108",rtn)
				q OutputObj
			}	
		}
		if (IDNo="") {
			d ..SetOutputCode(.OutputObj,"-103","证件号码不能为空.")
			quit OutputObj
		}
	}
	
	if (PatientCard'="")
	{
		s Status=..CardHadCreate(CardTypeID,PatientCard)
		if $piece(Status,"^",1)'=""{
			set PatientID=$piece(Status,"^",2)
			s StatusDesc=..GetCardStatusDesc($piece(Status,"^",1))
			if ($piece(Status,"^",1)="N")
			{
				d ..SetOutputCode(.OutputObj,"-50","此卡号已建卡.")
				
				s PatientCard=..GetPatientCard(PatientID)
				s PatientCardType=$p(PatientCard,"^",2)
				s PatientCard=$p(PatientCard,"^",1)
				set OutputObj.CardTypeCode=$p(##class(DHCExternalService.RegInterface.GetRelate).GetOuterCardType(BankCode,PatientCardType),"^",1)
				set OutputObj.PatientCard=PatientCard
				;set OutputObj.SecurityNo=mySecurityNo
				set OutputObj.PatientID=##class(DHCExternalService.CardInterface.CardManager).PatientIDToNo(PatientID)					
				quit OutputObj
			
			}
		}
	}
	if (IDNo'="")&&(SearchFlag'=1) {
		s PatientIDs=..CheckInfoByIDCard(IDTypeID,IDNo,CardTypeID,PatientName)
		s IDTotal=0
		s Flag=$P(PatientIDs,"^",1)
		s IDTotal=$P(PatientIDs,"^",3)
		i (Flag=1){
			s Status=$P(PatientIDs,"^",2)
			s StatusDesc=..GetCardStatusDesc(Status)
			d ..SetOutputCode(.OutputObj,"-51","已存在同种类型的卡,不能发卡")
			s myPatientID=+$P(PatientIDs,"^",4)
			s PatientCard=..GetPatientCard(myPatientID,CardTypeID)
			s PatientCardType=$p(PatientCard,"^",2)
			s PatientCard=$p(PatientCard,"^",1)
			set OutputObj.CardTypeCode=$p(##class(DHCExternalService.RegInterface.GetRelate).GetOuterCardType(BankCode,PatientCardType),"^",1)
			set OutputObj.PatientCard=PatientCard
			;set OutputObj.SecurityNo=mySecurityNo
			set OutputObj.PatientID=##class(DHCExternalService.CardInterface.CardManager).PatientIDToNo(myPatientID)
			quit OutputObj
		}else{
			s PatientIDs=$P(PatientIDs,"^",2)
		}
	}else {
		s PatientIDs=..CheckInfoByPatInfo(PatientName,PatientDob,PatientSex,MobilePhone,CardTypeID)
		s Flag=$p(PatientIDs,"^",1)
		if Flag=1 {
			d ..SetOutputCode(.OutputObj,"-52","该患者信息已存在,不能发卡")
			
			s myPatientID=+$P(PatientIDs,"^",3)
			s PatientCard=..GetPatientCard(myPatientID,CardTypeID)
			s PatientCardType=$p(PatientCard,"^",2)
			s PatientCard=$p(PatientCard,"^",1)
			set OutputObj.CardTypeCode=$p(##class(DHCExternalService.RegInterface.GetRelate).GetOuterCardType(BankCode,PatientCardType),"^",1)
			set OutputObj.PatientCard=PatientCard
			;set OutputObj.SecurityNo=mySecurityNo
			set OutputObj.PatientID=##class(DHCExternalService.CardInterface.CardManager).PatientIDToNo(myPatientID)
			quit OutputObj
		}else{
			s PatientIDs=$P(PatientIDs,"^",2)
		}
	}
	
	Set OutputObj.ResultCode="0"
	;Set OutputObj.test="test"
	Set OutputObj.ResultContent="可以发卡"
	Set CardFareType=$P($g(^DHCCARDTYPEDef(CardTypeID)),"^",3)
	Set CardFareCost=$P($g(^DHCCARDTYPEDef(CardTypeID)),"^",6)
	if (CardFareType="C")
	{
		Set OutputObj.CardDepositAmt=CardFareCost
	}
	else 
	{
		Set OutputObj.CardDepositAmt=0
	}
	quit OutputObj
FindPatientCardErr
	Set OutputObj=##Class(DHCExternalService.CardInterface.Entity.FindPatientCardRp).%New()
	Set OutputObj.ResultCode="-1"
	Set OutputObj.ResultContent="不能发卡"_$ZERROR
	quit OutputObj
}

/// 赋值出参标识
ClassMethod SetOutputCode(ByRef object As %ObjectHandle, ResultCode As %String, ResultContent As %String)
{
	s object.ResultCode=ResultCode
	
	if ($d(^oddCOM(object.%ClassName(1),"a","ResultContent"))){
		s object.ResultContent=ResultContent
	}elseif ($d(^oddCOM(object.%ClassName(1),"a","ErrorMsg"))){
		s object.ErrorMsg=ResultContent
	}
}

ClassMethod GetPatientCard(PatientID As %String, CardType As %String = "")
{
	Q:PatientID="" ""
	s ret=""
	s PatientCard="",PatientCardType=""
	s PatientCardID=""
	for {
		s PatientCardID=$o(^DHCCARDi("CF",0,"PAPMIDR",PatientID,PatientCardID))
		q:PatientCardID=""
		s CFActive=$p(^DHCCARD("CF",PatientCardID),"^",10)
		Continue:CFActive'="N"
		s CFCardTypeDR=$p(^DHCCARD("CF",PatientCardID),"^",16)
		Continue:(CardType'="")&(CardType'=CFCardTypeDR)
		s PatientCard=$p(^DHCCARD("CF",PatientCardID),"^",2)
		s PatientCardType=$p(^DHCCARDTYPEDef(CFCardTypeDR),"^",1)
		s ret=PatientCard_"^"_CFCardTypeDR
	}
	Q ret
}

/// s RtnObj=##class(DHCExternalService.CardInterface.CardManager).SavePatientCard(^TMP("SavePatientCard"))
/// w ##class(DHCExternalService.CardInterface.CardManager).SavePatientCard("<Request><TradeCode>3014</TradeCode><CardTypeCode></CardTypeCode><PatientCard></PatientCard><SecurityNo></SecurityNo><ChipSerialNo></ChipSerialNo><PatientType>01</PatientType><PatientName>志明</PatientName><Sex>1</Sex><DOB>1985-06-09</DOB><MaritalStatus></MaritalStatus><Nation></Nation><Occupation></Occupation><Nationality></Nationality><IDType>01</IDType><IDNo>320721198708275413</IDNo><Address>大城市铁岭</Address><AddressLocus></AddressLocus><Zip></Zip><Company></Company><CompanyAddr></CompanyAddr><CompanyZip></CompanyZip><CompanyTelNo></CompanyTelNo><TelephoneNo>telephoneno</TelephoneNo><Mobile>mobile</Mobile><ContactName></ContactName><ContactAddress></ContactAddress><Relation></Relation><ContactTelNo></ContactTelNo><InsureCardFlag></InsureCardFlag><InsureCardNo></InsureCardNo><UserID>REG</UserID><TerminalID>TD0987654321</TerminalID><TransactionId>1</TransactionId><CardDepositAmt></CardDepositAmt><ChargeDepositAmt></ChargeDepositAmt><PayModeCode>2</PayModeCode><PayBankCode></PayBankCode><PayCardNo></PayCardNo><PayTradeStr></PayTradeStr><AccountPassword></AccountPassword><TheArea></TheArea><PatientID></PatientID><BankCode>03</BankCode><BindFlag></BindFlag><SignedStatus></SignedStatus><HTBankCardNo></HTBankCardNo><BankTradeInfo></BankTradeInfo></Request>")
ClassMethod SavePatientCard(XMLRequest As %String) As DHCExternalService.CardInterface.Entity.SavePatientCardRp
{
	Set $ZTRAP="SavePatientCardErr"
	s ^TMP("SavePatientCard")=XMLRequest
	Set InputObj=##class(DHCExternalService.CardInterface.Entity.SavePatientCardRt).%New()
	d InputObj.XMLNodeDeserialize(.InputObj,"Request",XMLRequest)
	Set TradeCode=InputObj.TradeCode
	Set CardTypeCode=InputObj.CardTypeCode
	Set PatientCard=InputObj.PatientCard
	Set SecurityNo=InputObj.SecurityNo
	Set PatientName=InputObj.PatientName
	Set Sex=InputObj.Sex
	Set DOB=InputObj.DOB
	Set IDType=InputObj.IDType
	Set IDNo=InputObj.IDNo
	Set PhotoInfo=InputObj.PhotoInfo
	Set Mobile=InputObj.Mobile
	Set TerminalID=InputObj.TerminalID
	Set CardDepositAmt=+InputObj.CardDepositAmt
	Set PayModeCode=InputObj.PayModeCode
	Set PayBankCode=InputObj.PayBankCode
	Set PayCardNo=InputObj.PayCardNo
	Set PayTradeStr=InputObj.PayTradeStr
	set PatientType=InputObj.PatientType
	set ChargeDepositAmt=InputObj.ChargeDepositAmt
	set AccountPassword=InputObj.AccountPassword
	set TheArea=InputObj.TheArea
	set BankTradeInfo=InputObj.BankTradeInfo
	set ContactName=InputObj.ContactName
	set ContactTelNo=InputObj.ContactTelNo
	set ContactIDNo=InputObj.ContactIDNo
	set ContactIDType=InputObj.ContactIDType
	set InsureCardNo=InputObj.InsureCardNo
	Set PayDetailsObj=##class(DHCBILL.SelfPay.Entity.CompleteCharge.Req.PayDetails).%New()
    Set PayDetailsObj=InputObj.PayDetails
	set HospitalId=InputObj.HospitalId
	set HospitalId=##class(DHCExternalService.RegInterface.GetRelate).GetHISHospitalIdFromOuterCode(HospitalId) 
	Set OutputObj=##Class(DHCExternalService.CardInterface.Entity.SavePatientCardRp).%New()
	if HospitalId=""{
		d ..SetOutputCode(.OutputObj,"-100","请传入正确的院区代码.")
		quit OutputObj	
	}
	Set UserID=##class(DHCExternalService.RegInterface.GetRelate).GetUser(InputObj.UserID,"",HospitalId)
	if (UserID="")
	{
		d ..SetOutputCode(.OutputObj,"-101","用户ID不能为空.")
		quit OutputObj
	}
	set GroupID=##class(DHCExternalService.RegInterface.GetRelate).GetGroup(UserID)
	set BankCode=##class(DHCDoc.Interface.Outside.Config).GetConfigNode(GroupID,"DataCompareExtOrg",HospitalId)
	Set CardTypeID=##class(DHCExternalService.RegInterface.GetRelate).GetHisCardTypeID(CardTypeCode,BankCode,"",HospitalId)
	set IDTypeID=##class(DHCExternalService.CardInterface.GetRelate).GetIDCardType(BankCode,IDType,HospitalId)
	set ContactIDTypeID=##class(DHCExternalService.CardInterface.GetRelate).GetIDCardType(BankCode,ContactIDType,HospitalId)
	set PayModeID=##Class(DHCExternalService.RegInterface.GetRelate).GetHisPayModeID(PayModeCode,BankCode)
	
	if ((ChargeDepositAmt+CardDepositAmt)>0)&&(PayModeID="")
	{
		d ..SetOutputCode(.OutputObj,"-102","支付方式不能为空." )
		quit OutputObj
	}
	i PayModeID'=""{
		s PayModeCode=$P(^CT("CTPM",PayModeID),"^",1)
	}
	
	if (TradeCode="")
	{
		d ..SetOutputCode(.OutputObj,"-103","交易代码不能为空." )
		quit OutputObj
	}
		
	if (PatientName="")
	{
		d ..SetOutputCode(.OutputObj,"-104","患者姓名不能为空." )
		quit OutputObj
	}
	if (Sex="")
	{
		d ..SetOutputCode(.OutputObj,"-105","性别不能为空.")
		quit OutputObj	
	}		
	if (DOB="")
	{
		d ..SetOutputCode(.OutputObj,"-106","出生日期不能为空.")
		quit OutputObj	
	}else{
		if $l(DOB,"-")'=3{
			d ..SetOutputCode(.OutputObj,"-106","出生日期格式为YYYY-MM-DD.")
			quit OutputObj	
		}	
	}
	if (IDTypeID="")
	{
		d ..SetOutputCode(.OutputObj,"-107","传入的证件类型为空或与HIS未对照." )
		quit OutputObj
	}else{
		s rtn=##class(DHCExternalService.CardInterface.Common).CheckIDType(IDTypeID)
		if rtn'=""{
			d ..SetOutputCode(.OutputObj,"-108",rtn)
			q OutputObj
		}
	}
	
	s PatBirthY=$p(DOB,"-",1)
	s CurrYear=$p($zd(+$h,3),"-",1)
	s Age=CurrYear-PatBirthY
	s rtn=##class(DHCExternalService.CardInterface.Common).CheckCredCard(IDNo,IDTypeID,Age,HospitalId)
	if rtn'=""{
		d ..SetOutputCode(.OutputObj,"-109",rtn)
		q OutputObj
	}
		
	s ForeignInfo=ContactName_"^"_ContactTelNo_"^"_ContactIDNo_"^"_ContactIDTypeID
	s rtn=##class(DHCExternalService.CardInterface.Common).CheckForeignInfo(Age,ForeignInfo,HospitalId)
	if rtn'=""{
		d ..SetOutputCode(.OutputObj,"-109",rtn)
		q OutputObj
	}	
	
	if (Mobile="")
	{
		d ..SetOutputCode(.OutputObj,"-110","手机号(个人电话)不能为空.")
		quit OutputObj	
	}	
		
	if (TerminalID="")
	{
		;d ..SetOutputCode(.OutputObj,"-111","自助机终端号不能为空.")
		;quit OutputObj	
	}
	;由his生成虚拟卡号
	s HisCreateCardNoFlag=+(##class(DHCDoc.Interface.Outside.Config).GetConfigNode(GroupID,"HisCreateCardNo",HospitalId))
	;自动建一个条形码
	s UsePAPMINoToCardFlag=+(##class(DHCDoc.Interface.Outside.Config).GetConfigNode(GroupID,"UsePAPMINoToCard",HospitalId))
	
	if (UsePAPMINoToCardFlag=0){
		if (CardTypeID="")
		{
			d ..SetOutputCode(.OutputObj,"-112","卡类型不能为空.")
			quit OutputObj	
		}else{
			if '$d(^DHCCARDTYPEDef(CardTypeID)){
				d ..SetOutputCode(.OutputObj,"-113","His中未找到此卡类型.")
				quit OutputObj
			}
		}
		s UsePAPMINoToCardFlag=$P(^DHCCARDTYPEDef(CardTypeID),"^",36)
		s AllowNoCardNoFlag=$P(^DHCCARDTYPEDef(CardTypeID),"^",42)
		if (UsePAPMINoToCardFlag'="Y")&&(AllowNoCardNoFlag'="Y") {
			if PatientCard=""{
				if (HisCreateCardNoFlag="1")    /// HIS生成就诊卡卡号
				{
					set PatientCard=##Class(DHCExternalService.CardInterface.GetRelate).CreateCardNo(CardTypeID)
				}
			}
			if (PatientCard="") 
			{
				d ..SetOutputCode(.OutputObj,"-114","卡号不能为空")
				quit OutputObj
			}
			
			s Status=..CardHadCreate(CardTypeID,PatientCard)
			if $piece(Status,"^",1)'=""{
				set PatientID=$piece(Status,"^",2)
				s StatusDesc=..GetCardStatusDesc($piece(Status,"^",1))
				if ($piece(Status,"^",1)="N")
				{
					d ..SetOutputCode(.OutputObj,"-50","此卡号已建卡.")
					s PatientCard=..GetPatientCard(PatientID)
					s PatientCardType=$p(PatientCard,"^",2)
					s PatientCard=$p(PatientCard,"^",1)
					set OutputObj.CardTypeCode=$p(##class(DHCExternalService.RegInterface.GetRelate).GetOuterCardType(BankCode,PatientCardType),"^",1)
					set OutputObj.PatientCard=PatientCard
					;set OutputObj.SecurityNo=mySecurityNo
					set OutputObj.PatientID=##class(DHCExternalService.CardInterface.CardManager).PatientIDToNo(PatientID)
					set AccInfo=..getaccinfofrompapmino(OutputObj.PatientID)
					set OutputObj.DepositAmount=+$piece(AccInfo,"^",4)
					quit OutputObj
				
				}
			}
		}
	}else{
		;条形码卡类型RowID?
		s CardTypeID=+(##class(DHCDoc.Interface.Outside.Config).GetConfigNode("","BarCardType",HospitalId))
		if CardTypeID=0{
			d ..SetOutputCode(.OutputObj,"-115","请联系管理员配置条形码卡类型")
			quit OutputObj	
		}else{
			s CardTypeCode=$P(^DHCCARDTYPEDef(CardTypeID),"^",1)
		}
	}
	Set HospShowDataFlag=##Class(DHCDoc.Common.Hospital).GetHospShowDataFlag("DHC_CardTypeDef",CardTypeID,HospitalId)
	if HospShowDataFlag="N"{
		d ..SetOutputCode(.OutputObj,"-116","该卡类型未在本院区授权使用,不能发卡")
		quit OutputObj
	}
	
	Set CardFareType=$P(^DHCCARDTYPEDef(CardTypeID),"^",3)
	Set CardFareCost=+$P(^DHCCARDTYPEDef(CardTypeID),"^",6)
	if (CardFareType="C"){
		if (CardDepositAmt'=CardFareCost){
			d ..SetOutputCode(.OutputObj,"-117","卡费金额错误")
			quit OutputObj	
		}
		if (PayModeID=""){
			d ..SetOutputCode(.OutputObj,"-118","支付方式为空")
			quit OutputObj
		}
		s LeftChargeDepositAmt=+InputObj.ChargeDepositAmt-InputObj.CardDepositAmt
		if LeftChargeDepositAmt<0{
			d ..SetOutputCode(.OutputObj,"-119","充值金额扣除卡费金额后,费用为负数")
			quit OutputObj
		}
	}else{
		s LeftChargeDepositAmt=+InputObj.ChargeDepositAmt
	}
	set mySecurityNo=SecurityNo

	set mySecurityFlag=$p($g(^DHCCARDTYPEDef(CardTypeID)),"^", 18)		;CTD_SecurityNoFlag
	if (mySecurityNo="")&&(mySecurityFlag="Y")
	{
		set mySecurityNo=##Class(web.UDHCAccCardManage).GetCardCheckNo("")
	}
	s PatientIDs=..CheckInfoByIDCard(IDTypeID,IDNo,CardTypeID,PatientName)
	s IDTotal=0
	s Flag=$P(PatientIDs,"^",1)
	s IDTotal=$P(PatientIDs,"^",3)
	if (Flag=1)||((Flag=-1)){
		s PatientCard="",PatientCardType=""
		s Status=$P(PatientIDs,"^",2)
		s StatusDesc=..GetCardStatusDesc(Status)
		d ..SetOutputCode(.OutputObj,"-51","已存在同种类型的卡")
		s myPatientID=+$P(PatientIDs,"^",4)
		s PatientCard=..GetPatientCard(myPatientID,CardTypeID)
		s PatientCardType=$p(PatientCard,"^",2)
		s PatientCard=$p(PatientCard,"^",1)
		set OutputObj.CardTypeCode=$p(##class(DHCExternalService.RegInterface.GetRelate).GetOuterCardType(BankCode,PatientCardType),"^",1)
		set OutputObj.PatientCard=PatientCard
		;set OutputObj.SecurityNo=mySecurityNo
		set OutputObj.PatientID=##class(DHCExternalService.CardInterface.CardManager).PatientIDToNo(myPatientID)
		set AccInfo=..getaccinfofrompapmino(OutputObj.PatientID)
		set OutputObj.DepositAmount=+$piece(AccInfo,"^",4)

		quit OutputObj
	}else{
		s PatientIDs=$P(PatientIDs,"^",2)
	}
	;是否允许关联卡
	s AllowRelateCardFlag=+(##class(DHCDoc.Interface.Outside.Config).GetConfigNode(GroupID,"AllowRelateCard",HospitalId))
	if (PatientIDs'="")&&(AllowRelateCardFlag=0){
		d ..SetOutputCode(.OutputObj,"-50","已存在一种类型的正常卡,不允许再关联卡")
		s PatientCard="",PatientCardType=""
		s myPatientID=+PatientIDs
		s PatientCard=..GetPatientCard(myPatientID)
		s PatientCardType=$p(PatientCard,"^",2)
		s PatientCard=$p(PatientCard,"^",1)
		set OutputObj.CardTypeCode=$p(##class(DHCExternalService.RegInterface.GetRelate).GetOuterCardType(BankCode,PatientCardType),"^",1)
		set OutputObj.PatientCard=PatientCard
		;set OutputObj.SecurityNo=mySecurityNo
		set OutputObj.PatientID=##class(DHCExternalService.CardInterface.CardManager).PatientIDToNo(myPatientID)
		set AccInfo=..getaccinfofrompapmino(OutputObj.PatientID)
		set OutputObj.DepositAmount=+$piece(AccInfo,"^",4)
		quit OutputObj
	}
	set PatType=##class(DHCExternalService.CardInterface.GetRelate).GetPatType(BankCode,PatientType)
	if (PatType=""){
		d ..SetOutputCode(.OutputObj,"-119","病人类型不能为空或与His未对照")
		quit OutputObj
	}
	if (PatType'=1){
		;d ..SetOutputCode(.OutputObj,"-1867","非自费患者请前往窗口建卡")
		;quit OutputObj
	}
	set InsurFlag=##class(web.DHCBL.CARD.UCardRefInfo).GetInsurFlag(PatType)
	if (InsurFlag'=0){
		if (InsureCardNo=""){
			d ..SetOutputCode(.OutputObj,"-120","医保患者类型,请填写正确的医保卡号")
			quit OutputObj
		}elseif (InsureCardNo'="99999999999S") {}
	}else{
		if (InsureCardNo'=""){
			d ..SetOutputCode(.OutputObj,"-121","非医保患者类型,医保卡号不可填")
			quit OutputObj
		}
	}
	
	set InfoObj=##class(DHCExternalService.CardInterface.Entity.PatInfo).%New()
	set InfoObj.Address=InputObj.Address
	set InfoObj.CardTypeCode=CardTypeID
	set InfoObj.DOB=InputObj.DOB
	set InfoObj.IDType=IDTypeID
	set InfoObj.IDNo=InputObj.IDNo
	set InfoObj.InsureCardFlag=InputObj.InsureCardFlag
	set InfoObj.InsureCardNo=InputObj.InsureCardNo
	set InfoObj.Mobile=Mobile
	set InfoObj.PatientCard=PatientCard
	set InfoObj.PatientName=InputObj.PatientName
	set InfoObj.PatientType=PatType
	set InfoObj.SecurityNo=mySecurityNo
	set InfoObj.Sex=InputObj.Sex
	set InfoObj.PayMode=PayModeID
	set InfoObj.TotalAmount=InputObj.CardDepositAmt
	set InfoObj.TelephoneNo=Mobile
	set InfoObj.UserID=UserID
	set InfoObj.ChargeDepositAmt=LeftChargeDepositAmt ;+InputObj.ChargeDepositAmt-InputObj.CardDepositAmt
	set InfoObj.AccountPassword=InputObj.AccountPassword
	set InfoObj.TheArea=InputObj.TheArea
	set InfoObj.MaritalStatus=InputObj.MaritalStatus
	set InfoObj.Nation=InputObj.Nation
	set InfoObj.Occupation=InputObj.Occupation
	set InfoObj.Relation=InputObj.Relation
	set InfoObj.HospitalId=HospitalId
	set InfoObj.Nationality=InputObj.Nationality
	set InfoObj.PhotoInfo=PhotoInfo
	set InfoObj.ContactName=ContactName
	set InfoObj.ContactTelNo=ContactTelNo
	set InfoObj.ContactIDNo=ContactIDNo
	set InfoObj.ContactIDType=ContactIDTypeID
	set InfoObj.ContactAddress=InputObj.ContactAddress
	
	set CardInvRowID=""
	set CardAccPreRowID=""
	TStart
	if (PatientIDs=""){ ;插入
		s rtn=..CardInsert(InfoObj,"")
		i +rtn=0{
			set PatientID=$p(rtn,$c(1),5)
			set CardInvRowID=$p(rtn,$c(1),2)
			set CardAccPreRowID=$p(rtn,$c(1),3)
			set PatientCard=$p(rtn,$c(1),8)
			Set OutputObj.ResultCode="0"
			Set OutputObj.ResultContent="建卡成功"
		}else{
			Set OutputObj.ResultCode="-1"
			Set OutputObj.ResultContent="建卡失败:"_rtn
		}
	}else{ ;更新
		set PatientID=PatientIDs
		set InfoObj.PatientID=PatientID
		s rtn=..CardRelate(InfoObj,IDTotal,"")
		i +rtn=0{
			set CardInvRowID=$p(rtn,$c(1),2)
			set CardAccPreRowID=$p(rtn,$c(1),3)
			set PatientCard=$p(rtn,$c(1),8)
			Set OutputObj.ResultCode="0"
			Set OutputObj.ResultContent="发卡成功"
		}else{
			Set OutputObj.ResultCode="-1"
			Set OutputObj.ResultContent="发卡失败:"_rtn
		}
	}
	///保存银行交易记录
	s JFPayMode=" "_PayModeID
	if (OutputObj.ResultCode="0"){
		if $d(^User.DHCCTPayModeExpI("PMEPayModeIDIndex",JFPayMode)){
			s PayFee=+InputObj.ChargeDepositAmt
			if (PayFee>0) {
				Set TradeType="CARD"
				Set TExpstr=UserID_"^"_GroupID_"^"_""_"^"_HospitalId_"^"_TerminalID_"^"_TradeType_"^"_PatientID_"^"_PayModeID
				Set InsTraderInfo=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).SetHISTradeNo(PatientCard,"","","C",PayFee,TExpstr)
				Set RetCode=$p(InsTraderInfo,"^",1)
				if (+RetCode'=0){
			    	do ..SetOutputCode(.OutputObj,"-110226","生成交易流水号失败！")
			    	TRO
					quit OutputObj
			    }
			    Set OrderNo=$p(InsTraderInfo,"^",3)
			    Set TradeID=OrderNo
				Set IBPRowID=$p(InsTraderInfo,"^",2)
				set InvoiceId=CardInvRowID_"@"_CardAccPreRowID
				;PayDetailsObj 未定义.......... 医生站组织还是第三方传？？？？
				Set RetCode=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).SavePayInfo(OrderNo,InvoiceId,.PayDetailsObj,TExpstr)
				If (RetCode'=0){
					do ..SetOutputCode(.OutputObj,"-110226","保存交易信息失败！"_RetCode)
			    	TRO
					quit OutputObj
				}
			}
		}
	}
			
	if (OutputObj.ResultCode="0")
	{
		TCommit
		set OutputObj.CardTypeCode=$p(##class(DHCExternalService.RegInterface.GetRelate).GetOuterCardType(BankCode,CardTypeID),"^",1)
		set OutputObj.PatientCard=PatientCard
		set OutputObj.SecurityNo=mySecurityNo
		set OutputObj.PatientID=##class(DHCExternalService.CardInterface.CardManager).PatientIDToNo(PatientID)
		set AccInfo=..getaccinfofrompapmino(OutputObj.PatientID)
		set OutputObj.DepositAmount=+$piece(AccInfo,"^",4)
	}
	else
	{
		TRollback
	}
	quit OutputObj
	
SavePatientCardErr
	if $TLEVEL>0{
    	TRO
	}
	Set OutputObj=##class(DHCExternalService.CardInterface.Entity.SavePatientCardRp).%New()
	Set OutputObj.ResultCode="-1"
	Set OutputObj.ResultContent="发卡失败:"_$ZError
	quit OutputObj
}

ClassMethod getaccinfofrompapmino(papmino As %Library.String) As %Library.String
{
	;w ##class(DHCExternalService.CardInterface.CardManager).getaccinfofrompapmino("18653575")
	q:papmino="" "-200^^^^^^^^"		;;无效卡标志
	
	s rtn=0
	
	s AccID="",AccNo="",left=0,Balance=0,DepPrice=0
	s Papmi=""
	s Pass=""
	s PAPMINo=""
	s myCardRowID=""
	s myACFlag=-200		;无效卡
	s myAccType="P"
	;逻辑：找到有效卡后，不应该在循环了
	;s dd=##class(web.UDHCCardInfoResume).AutoRepairSec(cardno,securityno)
	;s mySecNoEncrypt=##class(web.UDHCAccEnrypt).Encrypt(securityno)
	s papmi=$o(^PAPERi("PAPMI_PatNo",papmino,""))
	s cardid="0"
	f  s cardid=$o(^DHCCARDi("CF",0,"PAPMIDR",papmi,cardid)) q:((cardid="")!(myACFlag=0))  d
	.s ActiveFlag=$p(^DHCCARD("CF",cardid),"^",10)
	.q:ActiveFlag'="N"
	.;s CardID=cardid
	.s SecurityNO=$p(^DHCCARD("CF",cardid),"^",3)
	.;q:SecurityNO'=mySecNoEncrypt			;securityno
	.;判断有效卡标志
	.s myACFlag=0		;此卡有效
	.s Papmi=$p(^DHCCARD("CF",cardid),"^",4)
	.s myCardRowID=cardid
	.s PAPMINo=##Class(web.PAPatMas).GetRegistration(Papmi)
	.s cfrowid=$p(^DHCCARD("CF",cardid),"^",1)
	.q:cfrowid=""
	.s AccStatus=$p(^DHCACD("AccM",cfrowid),"^",13)
	.q:AccStatus'="N"
	.s AccID=cfrowid
	.s AccNo=$p(^DHCACD("AccM",cfrowid),"^",1)
	.;s RegNo=$p(^DHCACD("AccM",cfrowid),"^",3)
	.;s CardNo=$p(^DHCACD("AccM",cfrowid),"^",4)
	.s Balance=$p(^DHCACD("AccM",cfrowid),"^",8)
	.s Pass=$p(^DHCACD("AccM",cfrowid),"^",12)
	.s DepPrice=$p(^DHCACD("AccM",cfrowid),"^",14)
	.s left=Balance-DepPrice
	.s myAccType=$p(^DHCACD("AccM",cfrowid),"^",16)
	.;s AccType= $p(^DHCACD("AccM",cfrowid),"^",16)
	.;s CredTypeID=$p(^DHCACD("AccM",cfrowid),"^",17)
	.;s IDCardNo=$p(^DHCACD("AccM",cfrowid),"^",18)
	;
	s rtn=myACFlag
	;卡有效，而账户无效返回-201
	i ((myACFlag=0)&&(AccID="")) d
	.s rtn=-201
	;
	s str=rtn_"^"_AccID_"^"_AccNo_"^"_left_"^"_Balance_"^"_DepPrice_"^"_Pass
	s str=str_"^"_Papmi_"^"_PAPMINo_"^"_myCardRowID_"^"_myAccType
	;
	q str
}

ClassMethod GetPatientHadFlag(InfoObj As DHCExternalService.CardInterface.Entity.PatInfo) As %String
{
	set myHadFlag="0"
	s IDCardType=##class(DHCExternalService.CardInterface.GetRelate).GetIDCardType(InfoObj.BankCode,InfoObj.IDType)
	if InfoObj.IDNo=""{
		q "-1^证件号码不能为空"
	}
	if InfoObj.PatientName=""{
		q "-1^姓名不能为空"
	}
	
	s IDCredTypeID=$o(^PAC("CARD",0,"Code",..#IDCredTypeCode,""))		
	if (IDCardType=IDCredTypeID)
	{
		if ($length(InfoObj.IDNo)=18)
		{
			set myIDCardNo18=InfoObj.IDNo
			set myIDCardNo15=..ID18to15(InfoObj.IDNo)
		}
		else
		{
			set myIDCardNo15=InfoObj.IDNo
			set myIDCardNo18=..ID15to18(InfoObj.IDNo)
		}
		set myHadFlag=..GetPatIDByIDCardAndName(myIDCardNo18,InfoObj.PatientName)
		if (myHadFlag'="1") set myHadFlag=..GetPatIDByIDCardAndName(myIDCardNo15,InfoObj.PatientName)
		
		
	}
	else
	{
		set myHadFlag=..GetPatIDByIDCardAndName(InfoObj.IDNo,InfoObj.PatientName)
	}
	
	quit myHadFlag
}

/// 根据证件号和姓名判断是否有人员记录
ClassMethod GetPatIDByIDCardAndName(IDCard As %String = "", Name As %String = "") As %String
{
	set PatientID="",HadFlag="0"
	quit:IDCard="" HadFlag
	while($O(^PAPERi("DVA",IDCard,PatientID))'="")||(HadFlag="1")
	{
		s PatientID=$O(^PAPERi("DVA",IDCard,PatientID))
		s ActiveFlag=$P(^PAPER(PatientID,"PAT",1),"^",6)
		continue:ActiveFlag="N"
		s CurName=$P(^PAPER(PatientID,"ALL"),"^",1)
		continue:(Name'="")&&(CurName'=Name)
		s HadFlag="1"
	}
	
	quit HadFlag
}

ClassMethod HTCardBind(InfoObj As DHCExternalService.CardInterface.Entity.PatInfo) As %String
{
	set $ZT="HTCardBindErr"
	set Bindflag="B"
	set CardTypeCode=InfoObj.CardTypeCode
	set BankCode=InfoObj.BankCode
	set HTBankCardNo=InfoObj.HTBankCardNo
	if (HTBankCardNo="") 
	{
		set InfoObj.SignedStatus="0"
	}
	else
	{
		set InfoObj.SignedStatus="1"
	}
	set ChipSerialNo=InfoObj.ChipSerialNo
	if (ChipSerialNo="")
	{
		q "-1^芯片序列号不能为空"
	}
	set InfoObj.SecurityNo=##Class(DHCExternalService.CardInterface.GetRelate).GetSecurityNo(InfoObj.SecurityNo)
	set BankCardActiveFlag=0
	s IDCardType=##class(DHCExternalService.CardInterface.GetRelate).GetIDCardType(InfoObj.BankCode,InfoObj.IDType)
	i InfoObj.IDNo=""{
		q "-1^证件号码不能为空"
	}
	set CardTypeCode="HTCARD"
	set HTCardType=##Class(DHCExternalService.RegInterface.GetRelate).GetHisCardTypeID(CardTypeCode)
	s CardType=##class(GetRelate).GetCardType(InfoObj.BankCode,"",Bindflag)
	set FindCardType=CardType
	if (Bindflag="B") set FindCardType=""
	set myHTCardID=""
	if (HTBankCardNo="") 
	{
		s Status=..HTCardHadCreate(HTCardType,InfoObj.PatientCard,CardType,HTBankCardNo)
		s myHTCardID=$piece(Status,"^",4)
	}
	if $piece(Status,"^",1)'=""{
		set InfoObj.PatientID=$piece(Status,"^",2)
		s StatusDesc=..GetCardStatusDesc($piece(Status,"^",1))
		if ($piece(Status,"^",1)="N")
		{
			q "-50^"_"系统存在状态为'"_StatusDesc_"'的同卡号的卡"_"^"_BankCardActiveFlag
		}
		elseif ($piece(Status,"^",1)="UA")
		{
			s PatientIDs=..CheckInfoByIDCard(IDCardType,InfoObj.IDNo,FindCardType,InfoObj.PatientName)
			s IDTotal=0
			s Flag=$P(PatientIDs,"^",1)
			s IDTotal=$P(PatientIDs,"^",3)
			if (IDTotal>1)
			{
				set BankCardActiveFlag=1
			}
			else
			{
				set BankCardActiveFlag=2
			}
			q "-50^"_"系统存在状态为'"_StatusDesc_"'的同卡号的卡"_"^"_BankCardActiveFlag
		}
		else
		{
			if (Bindflag'="B")
			{
				q "-52^"_"系统存在状态为'"_StatusDesc_"'的同卡号的卡"
			}
		}
	}
	s PatientIDs=..CheckInfoByIDCard(IDCardType,InfoObj.IDNo,FindCardType,InfoObj.PatientName)
	s IDTotal=0
	s Flag=$P(PatientIDs,"^",1)
	s IDTotal=$P(PatientIDs,"^",3)
	if (IDTotal>1) set BankCardActiveFlag=1
	   //协和银医卡控制同一卡类型只建一张卡
	i (Flag=1)&&(Bindflag'="B"){
		s Status=$P(PatientIDs,"^",2)
		s StatusDesc=..GetCardStatusDesc(Status)
		q "-51^"_"存在状态为'"_StatusDesc_"'的同种类型的卡"
	}else{
		s PatientIDs=$P(PatientIDs,"^",2)
	}
	
	;s PatientIDs=$P(PatientIDs,"^",2)
	b ;
	i (PatientIDs=""){ ;插入
		if Bindflag="B" set BankCardActiveFlag=3
		else  set BankCardActiveFlag=2
		set InfoObj.CardTypeCode=CardTypeCode
		s rtn=..CardInsert(InfoObj,Bindflag)
		b ;rrrs
		i +rtn=0{
			if (HTBankCardNo="")
			{
				q "0^成功^"_BankCardActiveFlag
			}
			else
			{
				s myHTCardID=$P(rtn,"^",3)
				s InfoObj.PatientID=$P(rtn,"^",2)
				s InfoObj.PatientCard=HTBankCardNo
				s InfoObj.CardDR=myHTCardID
				set InfoObj.CardTypeCode=""
				s rtn=..CardRelate(InfoObj,IDTotal,Bindflag)
				b ;rrn
				i +rtn=0{
					q "0^成功^"_BankCardActiveFlag
				}else{
					q "-1^"_$P(rtn,"^",2)
				}		
			}
			
		}else{
			q "-1^"_$P(rtn,"^",2)
		}
	}else{ ;更新
		
		s InfoObj.PatientID=PatientIDs
		b ;InfooPat
		if (myHTCardID="")
		{
			set InfoObj.CardTypeCode=CardTypeCode
			s rtn=..CardRelate(InfoObj,IDTotal,Bindflag)
			if (+rtn=0)
			{
				s myHTCardID=$P(rtn,"^",3)
			}
			else
			{
				q "-1^"_$P(rtn,"^",2)
			}
		}
		s InfoObj.PatientCard=HTBankCardNo
		s InfoObj.CardDR=myHTCardID
		set InfoObj.CardTypeCode=""
		s rtn=..CardRelate(InfoObj,IDTotal,Bindflag)
		b ;rrrt
		i +rtn=0{
			q "0^成功^"_BankCardActiveFlag
		}else{
			q "-1^"_$P(rtn,"^",2)
		}
	}
	q
HTCardBindErr
	q "-1^HTCardBind调用异常失败"_$ZERROR
}

ClassMethod HTCardHadCreate(CardType, CardNo, BankCardType, HTBankCardNo)
{
	s CardID="",Status="",PatientID="",HTCardStatus=""
	s ID=0
	f  s ID=$O(^DHCCARDi("CF",0,"CardTypeNo",CardType,CardNo,ID)) q:ID=""  d
	.s Status=$P(^DHCCARD("CF",ID),"^",10)
	.s PatientID=$P(^DHCCARD("CF",ID),"^",4)
	.if (Status="N")||(Status="UA") set CardID=ID
	.s HTCardStatus=Status
	if (BankCardType'="")&&(HTBankCardNo'="")
	{
		s ID=0
		f  s ID=$O(^DHCCARDi("CF",0,"CardTypeNo",BankCardType,HTBankCardNo,ID)) q:ID=""  d
		.s Status=$P(^DHCCARD("CF",ID),"^",10)
			
	}
	q Status_"^"_PatientID_"^"_HTCardStatus_"^"_CardID
}

ClassMethod HTCardUnBound(InfoObj As DHCExternalService.CardInterface.Entity.PatInfo) As %String
{
}

ClassMethod UpdatePatMobile(XMLRequest As %String) As DHCExternalService.CardInterface.Entity.UpdatePatMobileRp
{
	Set $ZTRAP="UpdatePatMobileErr"
	Set InputObj=##class(DHCExternalService.CardInterface.Entity.UpdatePatMobileRt).%New()
	d InputObj.XMLNodeDeserialize(.InputObj,"Request",XMLRequest)
	Set OutputObj=##class(DHCExternalService.CardInterface.Entity.UpdatePatMobileRp).%New()
 	d ..SetOutputCode(.OutputObj,"-1","接口已弃用,请使用更新患者信息接口")
	quit OutputObj
UpdatePatMobileErr
	if $TLEVEL>0{
    	TRO
	}
	Set OutputObj=##class(DHCExternalService.CardInterface.Entity.UpdatePatMobileRp).%New()
	Set OutputObj.ResultCode="-1"
	Set OutputObj.ResultContent="保存失败:"_$ZError
	quit OutputObj
}

/// w ##class(DHCExternalService.CardInterface.CardManager).UpdatePatInfo(^tmpnk("UpdatePatInfo"))
/// w ##class(DHCExternalService.CardInterface.CardManager).SavePatientCard("<Request><TradeCode>3014</TradeCode><CardTypeCode></CardTypeCode><PatientCard></PatientCard><SecurityNo></SecurityNo><ChipSerialNo></ChipSerialNo><PatientType>01</PatientType><PatientName>志明</PatientName><Sex>1</Sex><DOB>1985-06-09</DOB><MaritalStatus></MaritalStatus><Nation></Nation><Occupation></Occupation><Nationality></Nationality><IDType>01</IDType><IDNo>320721198708275413</IDNo><Address>大城市铁岭</Address><AddressLocus></AddressLocus><Zip></Zip><Company></Company><CompanyAddr></CompanyAddr><CompanyZip></CompanyZip><CompanyTelNo></CompanyTelNo><TelephoneNo>telephoneno</TelephoneNo><Mobile>mobile</Mobile><ContactName></ContactName><ContactAddress></ContactAddress><Relation></Relation><ContactTelNo></ContactTelNo><InsureCardFlag></InsureCardFlag><InsureCardNo></InsureCardNo><UserID>zzj001</UserID><TerminalID>TD0987654321</TerminalID><TransactionId>1</TransactionId><CardDepositAmt></CardDepositAmt><ChargeDepositAmt></ChargeDepositAmt><PayModeCode>2</PayModeCode><PayBankCode></PayBankCode><PayCardNo></PayCardNo><PayTradeStr></PayTradeStr><AccountPassword></AccountPassword><TheArea></TheArea><PatientID></PatientID><BankCode>03</BankCode><BindFlag></BindFlag><SignedStatus></SignedStatus><HTBankCardNo></HTBankCardNo><BankTradeInfo></BankTradeInfo></Request>")
ClassMethod UpdatePatInfo(XMLRequest As %String) As DHCExternalService.CardInterface.Entity.UpdatePatMobileRp
{
	Set $ZTRAP="UpdatePatInfoErr"
	s ^tmpnk("UpdatePatInfo")=XMLRequest
	Set InputObj=##class(DHCExternalService.CardInterface.Entity.UpdatePatMobileRt).%New()
	d InputObj.XMLNodeDeserialize(.InputObj,"Request",XMLRequest)
	Set OutputObj=##class(DHCExternalService.CardInterface.Entity.UpdatePatMobileRp).%New()
	Set TradeCode=InputObj.TradeCode
	Set CardTypeCode=InputObj.CardTypeCode
	Set PatientCard=InputObj.PatientCard
	Set PatientNo=InputObj.PatientID
	Set Mobile=InputObj.TelephoneNo
	Set IDType=InputObj.IDType
	Set IDNo=InputObj.IDNo
	Set Address=InputObj.Address
	Set PatName=InputObj.PatName
	Set PatSex=InputObj.PatSex
	set PatType=InputObj.PatType
	set ContactName=InputObj.ContactName
	set ContactTelNo=InputObj.ContactTelNo
	set ContactIDNo=InputObj.ContactIDNo
	set ContactIDType=InputObj.ContactIDType
	set ContactAddress=InputObj.ContactAddress
	set PatBirth=InputObj.PatBirth
	set HospitalId=InputObj.HospitalId
	set HospitalId=##class(DHCExternalService.RegInterface.GetRelate).GetHISHospitalIdFromOuterCode(HospitalId) 
	Set OutputObj=##Class(DHCExternalService.CardInterface.Entity.FindPatientCardRp).%New()
	if HospitalId=""{
		d ..SetOutputCode(.OutputObj,"-100","请传入正确的院区代码.")
		quit OutputObj	
	}
	Set UserID=##class(DHCExternalService.RegInterface.GetRelate).GetUser(InputObj.ExtUserID,"",HospitalId)
	if (UserID="") {
		d ..SetOutputCode(.OutputObj,"-101","请传入正确的操作用户.")
		quit OutputObj
	}
	
	s GroupID=##class(DHCExternalService.RegInterface.GetRelate).GetGroup(UserID)
	s BankCode=##class(DHCDoc.Interface.Outside.Config).GetConfigNode(GroupID,"DataCompareExtOrg",HospitalId)
	set PatSex=##class(DHCExternalService.CardInterface.GetRelate).GetSex(BankCode,PatSex)
	Set CardTypeID=##class(DHCExternalService.RegInterface.GetRelate).GetHisCardTypeID(CardTypeCode,BankCode,"",HospitalId)
	
	if (PatientNo="")&&(PatientCard=""){
		d ..SetOutputCode(.OutputObj,"-102","无法确定病人，请务必传入登记号或就诊卡号")
		q OutputObj
	}
	s myPatientID="",FindCardid=""
	if PatientCard'="" {
		if (CardTypeID=""){
			d ..SetOutputCode(.OutputObj,"-103","卡类型不能为空或与His未对照.")
			q OutputObj
		}
		s myPatientID=##class(DHCExternalService.RegInterface.SelfRegMethods).getPatIDByCardInfo(CardTypeID,PatientCard)
		if myPatientID=""{
			d ..SetOutputCode(.OutputObj,"-104","卡号在系统中未找到")
		}
	}elseif PatientNo'="" {
		s myPatientID=$o(^PAPERi("PAPMI_PatNo",$ZCVT(PatientNo,"U"),""))	
	}
	if myPatientID=""{
		d ..SetOutputCode(.OutputObj,"-104","该患者信息在His系统中未找到")
		q OutputObj
	}
	
	if (PatName=""){
		d ..SetOutputCode(.OutputObj,"-105","姓名不能为空")
		q OutputObj
	}
	
	if (IDNo=""){
		;s OutputObj.ResultCode="-1"
		;s OutputObj.ResultContent="证件号不能为空"
		;quit OutputObj
	}else{
		if (IDType=""){	
			d ..SetOutputCode(.OutputObj,"-106","证件类型不能为空")
			q OutputObj
		}
	}
	s IDCardType=""
	if (IDType'=""){
		s IDCardType=##class(DHCExternalService.CardInterface.GetRelate).GetIDCardType(BankCode,IDType,HospitalId)
		i IDCardType=""{
			d ..SetOutputCode(.OutputObj,"-107","证件类型为空或未对照")
			q OutputObj
		}else{
			s rtn=##class(DHCExternalService.CardInterface.Common).CheckIDType(IDCardType)
			if rtn'=""{
				d ..SetOutputCode(.OutputObj,"-108",rtn)
				q OutputObj
			}	
		}
	}
	if (PatBirth=""){
		d ..SetOutputCode(.OutputObj,"-106","出生日期不能为空.")
		quit OutputObj	
	}else{
		if $l(PatBirth,"-")'=3{
			d ..SetOutputCode(.OutputObj,"-106","出生日期格式需为YYYY-MM-DD.")
			quit OutputObj	
		}	
	}
	
	s PatBirthY=$p(PatBirth,"-",1)
	s CurrYear=$p($zd(+$h,3),"-",1)
	s Age=CurrYear-PatBirthY
	s rtn=##class(DHCExternalService.CardInterface.Common).CheckCredCard(IDNo,IDCardType,Age,HospitalId)
	if rtn'=""{
		d ..SetOutputCode(.OutputObj,"-109",rtn)
		q OutputObj
	}	
	s ContactIDTypeID=""
	if ContactIDType'=""{
		s ContactIDTypeID=##class(DHCExternalService.CardInterface.GetRelate).GetIDCardType(BankCode,ContactIDType,HospitalId)
	}
	s ForeignInfo=ContactName_"^"_ContactTelNo_"^"_ContactIDNo_"^"_ContactIDTypeID
	s rtn=##class(DHCExternalService.CardInterface.Common).CheckForeignInfo(Age,ForeignInfo,HospitalId)
	if rtn'=""{
		d ..SetOutputCode(.OutputObj,"-109",rtn)
		q OutputObj
	}	
	/*if (PatBirth=""){
		s OutputObj.ReturnCode="-1"
		s OutputObj.ResultContent="出生日期不能为空"
		quit OutputObj
	}
	if (Mobile=""){
		s OutputObj.ResultCode="-1"
		s OutputObj.ResultContent="联系方式不能为空"
		quit OutputObj
	}*/
	s PatMasObj=##class(web.DHCEntity.PCA.PATMAS).%New()
	s PatMasObj.PAPMIRowID=myPatientID
	s PatMasObj.PAPMINo=PatientNo
	i Address'=""{
		s PatMasObj.Address=Address
	}
	s:PatName'="" PatMasObj.Name=PatName
	s:PatSex'="" PatMasObj.Sex=PatSex
	s:PatBirth'="" PatMasObj.Birth=PatBirth ;$zdh(PatBirth,3)
	s:Mobile'="" PatMasObj.MobPhone=Mobile
	s:IDCardType'="" PatMasObj.CredType=IDCardType
	s:IDNo'="" PatMasObj.CredNo=IDNo
	s:ContactIDNo'="" PatMasObj.ForeignIDCard=ContactIDNo
	s:ContactIDTypeID'="" PatMasObj.ForeignCredType=ContactIDTypeID
	s:ContactName'="" PatMasObj.ForeignName=ContactName
	s:ContactAddress'="" PatMasObj.ForeignAddress=ContactAddress
	s:ContactTelNo'="" PatMasObj.ForeignPhone=ContactTelNo

	s PatMasObj.UserDR=UserID
	d PatMasObj.XMLExportToString(.PAPersonInfo,"TransContent")
	s rtn=##class(web.DHCBL.Patient.DHCPatientBuilder).DHCPatientUpdate(PAPersonInfo)
	if (rtn="0"){
	 	s OutputObj.ResultCode="0"
		s OutputObj.ResultContent="更新成功"
	}else{
		s OutputObj.ResultCode="-100"
		s OutputObj.ResultContent="更新失败"
	}
	quit OutputObj
UpdatePatInfoErr
	if $TLEVEL>0{
    	TRO
	}
	Set OutputObj=##class(DHCExternalService.CardInterface.Entity.UpdatePatMobileRp).%New()
	Set OutputObj.ResultCode="-1"
	Set OutputObj.ResultContent="更新失败:"_$ZError
	quit OutputObj
}

ClassMethod FindCardFromIDNo(XMLRequest As %String) As DHCExternalService.CardInterface.Entity.FindCardFromIDNoRp
{
	Set $ZTRAP="FindCardFromIDNoErr"
	s ^tmpnk("FindCardFromIDNo")=XMLRequest
	Set InputObj=##class(DHCExternalService.CardInterface.Entity.FindCardFromIDNoRq).%New()
	d InputObj.XMLNodeDeserialize(.InputObj,"Request",XMLRequest)
	Set OutputObj=##class(DHCExternalService.CardInterface.Entity.FindCardFromIDNoRp).%New()
	Set TradeCode=InputObj.TradeCode
	Set CardTypeCode=InputObj.CardTypeCode
	Set CardTypeID=##class(DHCExternalService.RegInterface.GetRelate).GetHisCardTypeID(CardTypeCode)
	Set PatientCard=InputObj.PatientCard
	Set PatientNo=InputObj.PatientID
	Set IDType=InputObj.IDType
	Set IDNo=InputObj.IDNo
	Set PatName=InputObj.PatName
	Set ExtUserID=InputObj.ExtUserID
	Set CardStatus=InputObj.CardStatus
	s UserDR=##class(DHCExternalService.RegInterface.GetRelate).GetUser(ExtUserID)
	if (IDNo=""){
		s OutputObj.ResultCode="-301501"
		s OutputObj.ResultContent="身份证号不能为空"
		quit OutputObj
	}
	if (UserDR=""){
		s OutputObj.ResultCode="-301502"
		s OutputObj.ResultContent="该操作用户不存在"
		quit OutputObj
	}
	s myPatientID=""
	if PatientCard'="" {
		if (CardTypeID=""){
			s OutputObj.ResultCode="-301503"
			s OutputObj.ResultContent="卡类型对照不正确"
			quit OutputObj
		}
		s CFRowid=0
		for {
			s CFRowid=$o(^DHCCARDi("CF",0,"CardNo",PatientCard,CFRowid)) Quit:CFRowid=""
			Set CFActive=$p(^DHCCARD("CF",CFRowid),"^",10)
			Continue:CFActive'="N"
			Set CFCardTypeDR=$p(^DHCCARD("CF",CFRowid),"^",16)
			Continue:(CardTypeID'="")&(CardTypeID'=CFCardTypeDR)
			Set myPatientID=$p(^DHCCARD("CF",CFRowid),"^",4)
		}
	}elseif PatientNo'="" {
		s myPatientID=$o(^PAPERi("PAPMI_PatNo",$ZCVT(PatientNo,"U"),""))	
	}elseif (IDNo'=""){
		s myPatientID=##class(DHCExternalService.CardInterface.Common).GetPatientHadFlag(IDType,IDNo,PatName)
	}
	if myPatientID=""{
		s OutputObj.ResultCode="-301504"
		s OutputObj.ResultContent="未找到相关信息"
		quit OutputObj
	}
	;web.DHCBL.CARD.CardManager PatientCardQuery
	
 	s OutputObj.ResultCode="0"
	s OutputObj.ResultContent="保存成功"
 	;s OutputObj.TradeCode=TradeCode
	quit OutputObj
FindCardFromIDNoErr
	TRollback	
	Set OutputObj=##class(DHCExternalService.CardInterface.Entity.UpdatePatMobileRp).%New()
	Set OutputObj.ResultCode="-1"
	Set OutputObj.ResultContent="更新失败:"_$ZError
	quit OutputObj
}

/// w ##class(DHCExternalService.CardInterface.CardManager).PartientCardReissue("<Request><TradeCode>3015</TradeCode><CardTypeCode>02</CardTypeCode><PatientCard>000787366601</PatientCard><PatientName>春娇1</PatientName><IDCardType>01</IDCardType><IDNo>320721198708275417</IDNo><Mobile>123</Mobile><ExtUserID>sf01</ExtUserID><CardDepositAmt>0.5</CardDepositAmt><OldCardType>02</OldCardType><OldPatientCard>000787366600</OldPatientCard></Request>")
ClassMethod PartientCardReissue(XMLRequest As %String) As DHCExternalService.CardInterface.Entity.PartientCardReissueRp
{
	;s XMLRequest="<Request><TradeCode>3015</TradeCode><CardTypeCode>02</CardTypeCode><PatientCard>000787366601</PatientCard><PatientName>春娇1</PatientName><IDCardType>01</IDCardType><IDNo>320721198708275417</IDNo><Mobile>123</Mobile><ExtUserID>sf01</ExtUserID><AccountPassword></AccountPassword><OldCardType>02</OldCardType><OldPatientCard>000787366600</OldPatientCard></Request>"
	Set $ZTRAP="PartientCardReissueErr"
	Set InputObj=##class(DHCExternalService.CardInterface.Entity.PartientCardReissueRt).%New()
	d InputObj.XMLNodeDeserialize(.InputObj,"Request",XMLRequest)
	Set TradeCode=InputObj.TradeCode
	Set CardType=InputObj.CardTypeCode
	Set PatientCard=InputObj.PatientCard
	Set PatientName=InputObj.PatientName
	Set IDCardType=InputObj.IDCardType
	Set IDNo=InputObj.IDNo
	Set Mobile=InputObj.Mobile
	Set OldCardType=InputObj.OldCardType
	Set OldPatientCard=InputObj.OldPatientCard
	set AccountPassword=InputObj.AccountPassword
	Set CardDepositAmt=InputObj.CardDepositAmt
	Set PayModeCode=InputObj.PayModeCode
	Set TerminalID=InputObj.TerminalID
	Set PayDetailsObj=##class(DHCBILL.SelfPay.Entity.CompleteCharge.Req.PayDetails).%New()
    Set PayDetailsObj=InputObj.PayDetails
	set HospitalId=InputObj.HospitalId
	set HospitalId=##class(DHCExternalService.RegInterface.GetRelate).GetHISHospitalIdFromOuterCode(HospitalId) 
	Set OutputObj=##class(DHCExternalService.CardInterface.Entity.PartientCardReissueRp).%New()
	if HospitalId=""{
		d ..SetOutputCode(.OutputObj,"-100","请传入正确的院区代码.")
		quit OutputObj	
	}
	Set UserID=##class(DHCExternalService.RegInterface.GetRelate).GetUser(InputObj.ExtUserID,"",HospitalId)
	if (UserID="")
	{
		d ..SetOutputCode(.OutputObj,"-301506","用户ID不能为空.")
		quit OutputObj	
	}
	s GroupID=##class(DHCExternalService.RegInterface.GetRelate).GetGroup(UserID)
	s BankCode=##class(DHCDoc.Interface.Outside.Config).GetConfigNode(GroupID,"DataCompareExtOrg",HospitalId)
	Set OldCardTypeID=##class(DHCExternalService.RegInterface.GetRelate).GetHisCardTypeID(OldCardType,BankCode,"",HospitalId)
	Set CardTypeID=##class(DHCExternalService.RegInterface.GetRelate).GetHisCardTypeID(CardType,BankCode,"",HospitalId)
	set IDTypeID=##class(DHCExternalService.CardInterface.GetRelate).GetIDCardType(BankCode,IDCardType,HospitalId)
	set PayModeID=##Class(DHCExternalService.RegInterface.GetRelate).GetHisPayModeID(PayModeCode,BankCode)
	if (TradeCode="")
	{
		d ..SetOutputCode(.OutputObj,"-301501","交易代码不能为空." )
		quit OutputObj
	}
		
	if (PatientName="")
	{
		d ..SetOutputCode(.OutputObj,"-301502","患者姓名不能为空." )
		quit OutputObj
	}
	
	if (IDTypeID="")
	{
		d ..SetOutputCode(.OutputObj,"-301503","证件类型不能为空." )
		quit OutputObj
	}
	if (IDNo="")
	{
		d ..SetOutputCode(.OutputObj,"-301504","证件号不能为空.")
		quit OutputObj	
	}		
	if (Mobile="")
	{
		d ..SetOutputCode(.OutputObj,"-301505","手机号(个人电话)不能为空.")
		quit OutputObj	
	}	
		
	if (CardTypeID="")
	{
		d ..SetOutputCode(.OutputObj,"-301507","新卡卡类型不能为空.")
		quit OutputObj	
	}
	if (PatientCard="") 
	{
		d ..SetOutputCode(.OutputObj,"-301508","新卡卡号不能为空")
		quit OutputObj
	}else{
		Set CardFareType=$P(^DHCCARDTYPEDef(CardTypeID),"^",3)
		Set CardFareCost=+$P(^DHCCARDTYPEDef(CardTypeID),"^",6)
		Set CardNoLength=$P(^DHCCARDTYPEDef(CardTypeID),"^",17)
		if (CardNoLength'=$l(PatientCard)){
			d ..SetOutputCode(.OutputObj,"-301517","新卡卡号位数不正确")
			quit OutputObj	
		}
		if (CardFareType="C")&&(CardFareCost>0)&&(CardFareCost'=+CardDepositAmt){
			d ..SetOutputCode(.OutputObj,"-301518","卡费用金额错误")
			quit OutputObj	
		}
		if (CardFareType="C")&&(CardFareCost>0)&&(PayModeID=""){
			d ..SetOutputCode(.OutputObj,"-301519","补卡需要收费,支付方式不能为空")
			quit OutputObj	
		}
	}
	set mySecurityNo=""
	set mySecurityFlag=$p($g(^DHCCARDTYPEDef(CardTypeID)),"^", 18)		;CTD_SecurityNoFlag
	if (mySecurityFlag="Y")
	{
		set mySecurityNo=##Class(web.UDHCAccCardManage).GetCardCheckNo("")
	}
	/*set AccCardNo=##class(web.DHCOPAdmReg).CheckPatAcc(IDTypeID,IDNo)
	if AccCardNo'=""{
		d ..SetOutputCode(.OutputObj,"-109","病人的卡号为"_AccCardNo_"的卡余额是负值,请先充值再进行补卡")
		quit OutputObj	
	}*/
	
	s Status=..CardHadCreate(CardTypeID,PatientCard)
	if $piece(Status,"^",1)'=""{
		set PatientID=$piece(Status,"^",2)
		s StatusDesc=..GetCardStatusDesc($piece(Status,"^",1))
		if ($piece(Status,"^",1)="N")
		{
			d ..SetOutputCode(.OutputObj,"-301509","此卡号已建卡.")
			quit OutputObj
		
		}
	}

	if IDNo'=""{
		s CFRowID="",CardNo="",ret=""
		Set ret=""
		Set CredNo=$ZCVT(IDNo,"U")
		Set PatId=0
		for  Set PatId=$o(^PAPERi("DVA",CredNo,PatId)) Quit:PatId=""  do
		.Quit:'$d(^PAPER(PatId,"PAT",3))
		.Set CredTypeId=$p(^PAPER(PatId,"PAT",3),"^",7)
		.Quit:IDTypeID'=CredTypeId
		.Set rowid=0
		.for  Set rowid=$o(^DHCCARDi("CF",0,"PAPMIDR",PatId,rowid)) Quit:rowid=""  do
		..s CFActiveFlag=$p($g(^DHCCARD("CF",rowid)),"^",10)
		..q:(CFActiveFlag'="N")
		..s CFIDCardNo=$p($g(^DHCCARD("CF",rowid)),"^",5)
		..s CardNo=$p($g(^DHCCARD("CF",rowid)),"^",2)
		..s cardtypeId=$p($g(^DHCCARD("CF",rowid)),"^",16)
		..Quit:cardtypeId'=CardTypeID
		..s ret=CardNo
		if ret'=""{
			d ..SetOutputCode(.OutputObj,"-301510","该身份证已存在相同卡类型的卡")
			quit OutputObj	
		}
	}
	if OldPatientCard'=""{
		s ID=0
		Set PatientID="",CardId=""
		f  s ID=$O(^DHCCARDi("CF",0,"CardTypeNo",OldCardTypeID,OldPatientCard,ID)) q:ID=""  d
		.s Status=$P(^DHCCARD("CF",ID),"^",10)
		.Quit:(Status="R")||(Status="D")
		.s PatientID=$P(^DHCCARD("CF",ID),"^",4)
		.Set CardId=ID
		if PatientID=""{
			d ..SetOutputCode(.OutputObj,"-301511","旧卡号在系统中不存在或已作废")
			quit OutputObj	
		}
		
	}else{
		s PatientIDs=..GetCardIDByIDCard(IDTypeID,IDNo,CardTypeID,PatientName)
		Set CardId=$P(PatientIDs,"^",1)
		Set PatientID=$P(PatientIDs,"^",2)
		if CardId=""{
			d ..SetOutputCode(.OutputObj,"-301512","该证件号没有对应挂失卡记录,不能补卡")
			quit OutputObj		
		}
	}
	if PatientID'=""{
		Set Name=$p(^PAPER(PatientID,"ALL"),"^",1)
		if Name'=PatientName{
			d ..SetOutputCode(.OutputObj,"-301513","您录入的姓名与原有诊疗卡中的姓名不一致,请到人工窗口办理")
			quit OutputObj	
		}	
		Set TelH=$p(^PAPER(PatientID,"PER",1),"^",11)
		if TelH'=Mobile{
			d ..SetOutputCode(.OutputObj,"-301514","您录入的手机号与原有诊疗卡中的手机号不一致,请到人工窗口办理")
			quit OutputObj		
		}
	}else{
		d ..SetOutputCode(.OutputObj,"-301515","病人信息在系统中未找到.")
		quit OutputObj	
	}
	b ;CardReissueNewStart
	s ExpStr=mySecurityNo_"^"_Mobile
	s ret=##class(DHCExternalService.CardInterface.Common).CardReissueNew(CardId,PatientCard,UserID,"", CardTypeID,IDNo,ExpStr)
	b ;CardReissueNewEnd
	if $p(ret,"^",1)=0{
		///保存银行交易记录
		s CardInvRowID=$p(ret,"^",2)
		s CardAccPreRowID=""
		s JFPayMode=" "_PayModeID
		if $d(^User.DHCCTPayModeExpI("PMEPayModeIDIndex",JFPayMode)){
			s PayFee=+CardDepositAmt
			if (PayFee>0) {
				Set TradeType="CARD"
				Set TExpstr=UserID_"^"_GroupID_"^"_""_"^"_HospitalId_"^"_TerminalID_"^"_TradeType_"^"_PatientID_"^"_PayModeID
				Set InsTraderInfo=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).SetHISTradeNo(PatientCard,"","","C",PayFee,TExpstr)
				Set RetCode=$p(InsTraderInfo,"^",1)
				if (+RetCode'=0){
			    	do ..SetOutputCode(.OutputObj,"-110226","生成交易流水号失败！")
			    	TRO
					quit OutputObj
			    }
			    Set OrderNo=$p(InsTraderInfo,"^",3)
			    Set TradeID=OrderNo
				Set IBPRowID=$p(InsTraderInfo,"^",2)
				set InvoiceId=CardInvRowID_"@"_CardAccPreRowID
				;PayDetailsObj 未定义.......... 医生站组织还是第三方传？？？？
				Set RetCode=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).SavePayInfo(OrderNo,InvoiceId,.PayDetailsObj,TExpstr)
				If (RetCode'=0){
					do ..SetOutputCode(.OutputObj,"-110226","保存交易信息失败！"_RetCode)
			    	TRO
					quit OutputObj
				}
			}
		}
	
		Set OutputObj.ResultCode=0
		Set OutputObj.ResultContent="补卡成功"	
		if AccountPassword=""{
			//s password="670B14728AD9902AECBA32E22FA4F6BD"
			//&sql(update SQLUSER.dhc_accmanager set accm_password=:password where accm_papmi_dr=:PatientID)	
		}
		set OutputObj.SecurityNo=mySecurityNo
	}else{
		Set OutputObj.ResultCode="-301516"
		Set OutputObj.ResultContent="补卡失败"_ret	
	}
	
	quit OutputObj
	
PartientCardReissueErr
	if $TLEVEL>0{
    	TRO
	}
	Set OutputObj=##class(DHCExternalService.CardInterface.Entity.PartientCardReissueRp).%New()
	Set OutputObj.ResultCode="-3015"
	Set OutputObj.ResultContent="补卡失败:"_$ZError
	quit OutputObj
}

/// w ##class(DHCExternalService.CardInterface.CardManager).GetCardIDByIDCard("1","370982199104203207")
ClassMethod GetCardIDByIDCard(IDCardType, IDCard, CardType As %String = "", Name As %String = "")
{
	Set CardId="",PatientId=""
	s IDCard=$ZCVT(IDCard,"U")
	s HadFlag=0
	s CurStatus=""
	q:IDCard="" "^"
	s PatientID=""
	f  s PatientID=$O(^PAPERi("DVA",IDCard,PatientID)) q:(PatientID="")||(HadFlag=1)  d
	.Quit:'$d(^PAPER(PatientID,"PAT",1))
	.s ActiveFlag=$P(^PAPER(PatientID,"PAT",1),"^",6)
	.q:ActiveFlag="N"
	.s CurName=$P(^PAPER(PatientID,"ALL"),"^",1)
	.q:(CurName'=Name)&&(Name'="")
	.s CurCardType=""
	.f  s CurCardType=$O(^DHCCARDi("CF",0,"PAPMICTDR",PatientID,CurCardType)) 	q:(CurCardType="")  d
	..s CardID=0
	..f  s CardID=$O(^DHCCARDi("CF",0,"PAPMICTDR",PatientID,CurCardType,CardID)) 	q:(CardID="")  d
	...s Status=$P(^DHCCARD("CF",CardID),"^",10)
	...q:(Status'="N")&&(Status'="S")&&(Status'="UA")
	...Set CardId=CardID
	...Set PatientId=PatientID
	q CardId_"^"_PatientId
}

}
