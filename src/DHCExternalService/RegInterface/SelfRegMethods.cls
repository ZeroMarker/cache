Class DHCExternalService.RegInterface.SelfRegMethods Extends (DHCDoc.Util.RegisteredObject, %XML.Adaptor, DHCExternalService.RegInterface.SelfRegPlulic) [ ProcedureBlock ]
{

/// 锁号缓存时间
Parameter LockCacheTime = 60;

/// 此类序列化解析类中的Code属性,都存RowId
/// w ##Class(web.UDHCJFCKD).GetShare($g(%request.Data("EpisodeID",1)))
/// w ##Class(web.UDHCJFCKD).GetShare(^tan("GetShare"))
ClassMethod GetShare(AdmRowID As %String = "") As %String
{
	q:AdmRowID="" "无法显示"
	s deposit=##class(web.UDHCJFCKD).deposit(AdmRowID)
	s total1=##class(web.UDHCJFBILLIP2).BILL(AdmRowID)
	s total1=$p(total1,"^",3)
	s rate=##class(web.UDHCJFCKD).GetPatRate(AdmRowID)
	
	s rtn=$number(deposit)-($number(total1)*$number(rate))
	q rtn
}

/// w ##class(DHCExternalService.RegInterface.SelfRegMethods).GetPatInfo("")
/// w ##class(DHCExternalService.RegInterface.SelfRegMethods).GetPatInfo(^TMPSelfRegXML("Request","GetPatInfo"))
ClassMethod GetPatInfo(XMLRequest As %String) As DHCExternalService.RegInterface.Entity.SelfReg.GetPatInfoRp
{
	s ^TMPSelfRegXML("Request","GetPatInfo")=XMLRequest
	;s XMLRequest="<Request><TradeCode>3300</TradeCode><TransactionId></TransactionId><ExtOrgCode></ExtOrgCode><ClientType></ClientType><TerminalID></TerminalID><HospitalId></HospitalId><ExtUserID></ExtUserID><PatientCard></PatientCard><CardType></CardType><PatientID></PatientID><Phone></Phone><IDCardType></IDCardType><IDNo>370285199106144416</IDNo><PatientName>nk</PatientName></Request>"
	s $ZTRAP="GetPatInfoErr"
	s InputObj=..GetInputObj("3300",XMLRequest)
	s CardType=InputObj.CardType
	s PatientCard=InputObj.PatientCard
	s PatientNo=InputObj.PatientID
	s IDCardType=InputObj.IDCardType
	s IDCardNo=InputObj.IDNo
	s PatientName=InputObj.PatientName
	s PhoneNo=InputObj.Phone
	s SecurityNo=InputObj.SecurityNo
	s HospitalId=InputObj.HospitalId
	s OutputObj=..GetOutputObj("3300")
	s OutputObj.ResultCode="0"
	s OutputObj.ResultContent=""
	
	s HospitalId=##class(DHCExternalService.RegInterface.GetRelate).GetHISHospitalIdFromOuterCode(HospitalId) 
	if HospitalId=""{
		d ..SetOutputCode(.OutputObj,"-330001","请传入正确的院区代码.")
		quit OutputObj	
	}
	s UserID=##class(DHCExternalService.RegInterface.GetRelate).GetUser(InputObj.ExtUserID,"",HospitalId)
	if (UserID=""){
		d ..SetOutputCode(.OutputObj,"-330001","请传入正确的操作用户.")
		q OutputObj	
	}
	
	s GroupID=##class(DHCExternalService.RegInterface.GetRelate).GetGroup(UserID)
	s BankCode=##class(DHCDoc.Interface.Outside.Config).GetConfigNode(GroupID,"DataCompareExtOrg",HospitalId)
	s CardType=##class(DHCExternalService.RegInterface.GetRelate).GetHisCardTypeID(CardType,BankCode,"",HospitalId)
	s IDCardType=##class(DHCExternalService.CardInterface.GetRelate).GetIDCardType(BankCode,IDCardType,HospitalId)
	s GetPatientIDRule=##class(DHCDoc.Interface.Outside.Config).GetConfigNode(GroupID,"GetPatientIDRule",HospitalId)
	b ;必须条件判断
	if ((PatientCard="")&&(PatientNo=""))&&((IDCardNo="")&&(PatientName="")) {
		d ..SetOutputCode(.OutputObj,"-330002","查询所需患者信息不全.")
		q OutputObj
	}
	s PatientIDStr=""
	if PatientCard'="" {
		s CFRowid=0
		for {
			s CFRowid=$O(^DHCCARDi("CF",0,"CardNo",PatientCard,CFRowid)) Q:CFRowid=""
			s CFActive=$p(^DHCCARD("CF",CFRowid),"^",10)
			Continue:CFActive'="N"
			s CFCardTypeDR=$p(^DHCCARD("CF",CFRowid),"^",16)
			Continue:(CardType'="")&(CardType'=CFCardTypeDR)
			s PatientIDStr=$p(^DHCCARD("CF",CFRowid),"^",4)
		}
		if PatientIDStr=""{
			d ..SetOutputCode(.OutputObj,"-330003","卡号在系统中未找到")
			Q OutputObj
		}
	}elseif PatientNo'="" {
		s PatientIDStr=$o(^PAPERi("PAPMI_PatNo",$ZCVT(PatientNo,"U"),""))
		if PatientIDStr=""{
			d ..SetOutputCode(.OutputObj,"-330003","该患者ID号在系统中未找到")
			Q OutputObj
		}
	}elseif (IDCardNo'=""){
		if PatientName=""{
			d ..SetOutputCode(.OutputObj,"-330006","使用证件号查询时姓名不能为空")
			q OutputObj
		}
		i IDCardType=""{
			d ..SetOutputCode(.OutputObj,"-330007","证件类型为空或未对照")
			q OutputObj
		}else{
			s rtn=##class(DHCExternalService.CardInterface.Common).CheckIDType(IDCardType)
			if rtn'=""{
				d ..SetOutputCode(.OutputObj,"-330008",rtn)
				q OutputObj
			}	
		}
		s PatientIDStr=##class(DHCExternalService.RegInterface.PatientManager).GetPatientHadFlag(IDCardType,IDCardNo,PatientName,GetPatientIDRule)
		if PatientIDStr=""{
			d ..SetOutputCode(.OutputObj,"-330003","该证件信息在系统中未找到")	
			q OutputObj
		}
	}
	i '$d(^PAPER(+PatientIDStr,"ALL")) d ..SetOutputCode(.OutputObj,"-330004","系统中未找到对应信息")
	s myPatientID=""
	i OutputObj.ResultCode="0" {
		set PatientIDStrLen=$l(PatientIDStr,"^")
		for mycount=1:1:PatientIDStrLen{
			s myPatientID=$p(PatientIDStr,"^",mycount)
			continue:myPatientID=""
			Set PatientName=$p(^PAPER(myPatientID,"ALL"),"^",1)
			//医保号
			set PatYBCode=$p($g(^PAPER(myPatientID,"ALL")),"^",19)
			set Sex=""
			set SexCode=$p(^PAPER(myPatientID,"ALL"),"^",7)
			set OuterSex=##class(DHCExternalService.RegInterface.GetRelate).GetOuterSexCode(SexCode,BankCode)
			set SexCode=$p(OuterSex,"^",1)
			set Sex=$p(OuterSex,"^",2)
			set DOB=$p(^PAPER(myPatientID,"ALL"),"^",6)
			set DocumentID=$p(^PAPER(myPatientID,"PAT",1),"^",22)
			set AddressId=$o(^PAPER(myPatientID,"PER","ADD",""),-1)
			set Address=""
			set:AddressId'="" Address=$g(^PAPER(myPatientID,"PER","ADD",AddressId))
			set IDTypeDesc=""
			set IDTypeCode=$p(^PAPER(myPatientID,"PAT",3),"^",7)
			if IDTypeCode'=""{
				set OuterCredType=##class(DHCExternalService.RegInterface.GetRelate).GetOuterCredTypeCode(IDTypeCode,BankCode)
				set IDTypeDesc=$p(OuterCredType,"^",1)
				set IDTypeCode=$p(OuterCredType,"^",2)
			}
			set IDNo=$p($g(^PAPER(myPatientID,"PAT",3)),"^",6)
			s TelephoneNo=$p(^PAPER(myPatientID,"PER",1),"^",11)
			s Mobile=$p($g(^PAPER(myPatientID,"PER",4)),"^",21)
			if (PatientCard=""){
				s PatientCardID=""
				for {
					s PatientCardID=$o(^DHCCARDi("CF",0,"PAPMIDR",myPatientID,PatientCardID))
					q:PatientCardID=""
					s CFActive=$p(^DHCCARD("CF",PatientCardID),"^",10)
					Continue:CFActive'="N"
					s CFCardTypeDR=$p(^DHCCARD("CF",PatientCardID),"^",16)
					Continue:(CardType'="")&(CardType'=CFCardTypeDR)
					s PatientCard=$p(^DHCCARD("CF",PatientCardID),"^",2)
				}
			}
			s PatYBFlag=0
			s PatType=$p(^PAPER(myPatientID,"PER",1),"^",10)
			s PatTypeCode="",PatTypeDesc=""
			if (PatType'=""){
				s OuterPatType=##class(DHCExternalService.RegInterface.GetRelate).GetOuterPatTypeCode(PatType,BankCode)
				s PatTypeCode=$p(OuterPatType,"^",1)
				s PatTypeDesc=$p(OuterPatType,"^",2)
			}
			s PatInfoObj=##class(DHCExternalService.RegInterface.Entity.SelfReg.List.PatInfo).%New()
			s PatInfoObj.PatientID=##class(DHCExternalService.CardInterface.CardManager).PatientIDToNo(myPatientID)
			s PatInfoObj.PatientName=PatientName
			s PatInfoObj.SexCode=SexCode
			s PatInfoObj.Sex=Sex
			s PatInfoObj.DOB=$zd(DOB,3)
			s PatInfoObj.DocumentID=DocumentID
			s PatInfoObj.Address=Address
			s PatInfoObj.IDTypeCode=IDTypeCode
			s PatInfoObj.IDTypeDesc=IDTypeDesc
			s PatInfoObj.IDNo=IDNo
			s PatInfoObj.TelephoneNo=TelephoneNo
			s PatInfoObj.Mobile=Mobile
			s PatInfoObj.InsureCardNo=PatYBCode
			s PatInfoObj.DocumentID=""
			s PatInfoObj.PatientCard=PatientCard
			s PatACCInfo=##CLASS(DHCExternalService.RegInterface.PatientManager).getaccinfofromcardno(PatientCard,SecurityNo,CardType,"","","")
			s PatInfoObj.AccInfo=PatACCInfo
			i +PatACCInfo=0{
				S PatInfoObj.AccInfoBalance=$p(PatACCInfo,"^",4)
				S PatInfoObj.AccInfoNo=$p(PatACCInfo,"^",2)
			}
			s PatInfoObj.PatType=PatTypeDesc
			s PatInfoObj.PatTypeCode=PatTypeCode
			s PatInfoObj.YBFlag=PatYBFlag
			if ($IsObject(PatInfoObj)){
				do OutputObj.PatInfos.Insert(PatInfoObj)
				do PatInfoObj.%Close()
			}
		}
	}	
	DO OutputObj.XMLExportToString(.XML,"Response")
	q OutputObj
GetPatInfoErr
	;q "-1^GetPatInfo调用异常"_$ZERROR
	s OutputObj=..GetOutputObj("3300")
	s OutputObj.ResultCode="-1"
	s OutputObj.ResultContent="GetPatInfo调用异常"_$ZERROR
	q OutputObj
}

/// w ##class(DHCExternalService.RegInterface.SelfRegMethods).GetPatBillType("<Request><TradeCode>3302</TradeCode><TransactionId></TransactionId><ExtOrgCode></ExtOrgCode><ClientType></ClientType><TerminalID></TerminalID><HospitalId></HospitalId><ExtUserID>sf01</ExtUserID><PatientCard></PatientCard><CardType></CardType><PatientID>0000002256</PatientID><PatientName>mic13</PatientName></Request>")
ClassMethod GetPatBillType(XMLRequest As %String) As DHCExternalService.RegInterface.Entity.SelfReg.GetPatBillTypeRp
{
	s $ZTRAP="GetPatBillTypeErr"
	s ^TMPSelfRegXML("Request","GetPatBillType")=XMLRequest
	s InputObj=..GetInputObj("3302",XMLRequest)
	s ClientType=InputObj.ClientType
	s ExtUserID=InputObj.ExtUserID
	s PatientCard=InputObj.CardNo
	s CardType=InputObj.CardType
	s PatientNo=InputObj.PatientID
	s HospitalId=InputObj.HospitalId
	s OutputObj=..GetOutputObj("3302")
	s HospitalId=##class(DHCExternalService.RegInterface.GetRelate).GetHISHospitalIdFromOuterCode(HospitalId) 
	if HospitalId=""{
		d ..SetOutputCode(.OutputObj,"-330201","请传入正确的院区代码.")
		quit OutputObj	
	}
	s UserID=##class(DHCExternalService.RegInterface.GetRelate).GetUser(ExtUserID,"",HospitalId)
	if (UserID=""){
    	d ..SetOutputCode(.OutputObj,"-330201","操作员信息为空")
		q OutputObj
	}
	s GroupID=##class(DHCExternalService.RegInterface.GetRelate).GetGroup(UserID)
	s BankCode=##class(DHCDoc.Interface.Outside.Config).GetConfigNode(GroupID,"DataCompareExtOrg",HospitalId)
	s CardType=##class(DHCExternalService.RegInterface.GetRelate).GetHisCardTypeID(CardType,BankCode)
	
	s myPatientID=""
	if PatientNo'=""{
		 s myPatientID=$o(^PAPERi("PAPMI_PatNo",$ZCVT(PatientNo,"U"),""))
	}
	else{
		if PatientCard'=""{
			s CFRowid=0
			for {
				s CFRowid=$O(^DHCCARDi("CF",0,"CardNo",PatientCard,CFRowid)) Q:CFRowid=""
				s CFActive=$p(^DHCCARD("CF",CFRowid),"^",10)
				Continue:CFActive'="N"
				s CFCardTypeDR=$p(^DHCCARD("CF",CFRowid),"^",16)
				Continue:(CardType'="")&(CardType'=CFCardTypeDR)
				s myPatientID=$p(^DHCCARD("CF",CFRowid),"^",4)
			}
		}
	}
	
	if myPatientID=""{
		d ..SetOutputCode(.OutputObj,"-330202","HIS中未找到该患者信息")
		q OutputObj
	}
	s BillData=##class(web.DHCOPAdmReg).GetBillTypeListBroker("GetBillTypeToHUIJson","",myPatientID,HospitalId)
	d ##Class(DHCDoc.Util.FromJSON).FromJSONToArr(BillData,.BillDataArr)
	s ResultCount=0
	if $d(BillDataArr){
		s loop=""
		for{
			s loop=$o(BillDataArr(loop))
			q:loop=""
			s BillTypeID=BillDataArr(loop,"id")
			s BillTypeDesc=BillDataArr(loop,"text")
			s InsuBillFlag=##class(web.DHCDocOrderCommon).GetInsurFlag(BillTypeID)
			
			set BillTypeObj=##class(DHCExternalService.RegInterface.Entity.SelfReg.List.PatBillType).%New()
			set BillTypeObj.BillTypeID=BillTypeID
			set BillTypeObj.BillTypeDesc=BillTypeDesc
			set BillTypeObj.InsuBillFlag=InsuBillFlag
			do OutputObj.PatBillTypes.Insert(BillTypeObj)
			do BillTypeObj.%Close()
			s ResultCount=ResultCount+1
		}
	}
	s OutputObj.RecordCount=ResultCount
	s OutputObj.ResultCode="0"
	s OutputObj.ResultContent="查询成功"
	q OutputObj
GetPatBillTypeErr
	s OutputObj=..GetOutputObj("3302")
	s OutputObj.ResultCode="-1"
	s OutputObj.ResultContent="GetPatBillType调用异常"_$ZERROR
	q OutputObj
}

/// w ##class(DHCExternalService.RegInterface.SelfRegMethods).QueryPatCard("")
ClassMethod QueryPatCard(XMLRequest As %String) As DHCExternalService.RegInterface.Entity.SelfReg.QueryPatCardRp
{
	s ^TMPSelfRegXML("Request","QueryPatCard")=XMLRequest
	;s XMLRequest="<Request><TradeCode>3301</TradeCode><TransactionId></TransactionId><ExtOrgCode></ExtOrgCode><ClientType></ClientType><TerminalID></TerminalID><HospitalId></HospitalId><ExtUserID></ExtUserID><PatientCard></PatientCard><CardType></CardType><PatientID></PatientID><Phone></Phone><IDCardType></IDCardType><IDNo>620502198803151673</IDNo><PatientName>mic13</PatientName></Request>"
	s $ZTRAP="QueryPatCardErr"
	s InputObj=..GetInputObj("3301",XMLRequest)
	s IDCardType=InputObj.IDCardType
	s IDCardNo=InputObj.IDNo
	s PatientName=InputObj.PatientName
	s PhoneNo=InputObj.Phone
	s HospitalId=InputObj.HospitalId
	s OutputObj=..GetOutputObj("3301")
	s OutputObj.ResultCode="0"
	s OutputObj.ResultContent="查询成功"
	s CardType=""
	s HospitalId=##class(DHCExternalService.RegInterface.GetRelate).GetHISHospitalIdFromOuterCode(HospitalId) 
	if HospitalId=""{
		d ..SetOutputCode(.OutputObj,"-330001","请传入正确的院区代码.")
		quit OutputObj	
	}
	s UserID=##class(DHCExternalService.RegInterface.GetRelate).GetUser(InputObj.ExtUserID,"",HospitalId)
	if UserID=""{
		d ..SetOutputCode(.OutputObj,"-330001","请传入正确的操作用户.")
		q OutputObj		
	}
	s GroupID=##class(DHCExternalService.RegInterface.GetRelate).GetGroup(UserID)
	s BankCode=##class(DHCDoc.Interface.Outside.Config).GetConfigNode(GroupID,"DataCompareExtOrg",HospitalId)
	
	s IDCardType=##class(DHCExternalService.CardInterface.GetRelate).GetIDCardType(BankCode,IDCardType,HospitalId)
	if (IDCardNo="") {
		d ..SetOutputCode(.OutputObj,"-330101","证件信息不能为空.") q OutputObj
	}
	i IDCardType=""{
		d ..SetOutputCode(.OutputObj,"-330107","证件类型为空或未对照")
		q OutputObj
	}else{
		s rtn=##class(DHCExternalService.CardInterface.Common).CheckIDType(IDCardType)
		if rtn'=""{
			d ..SetOutputCode(.OutputObj,"-330108",rtn)
			q OutputObj
		}	
	}
	if (PatientName="") {
		d ..SetOutputCode(.OutputObj,"-330102","患者姓名不能为空.") q OutputObj
	}
	set myPatientID=""
	set PatientIDStr=##class(DHCExternalService.RegInterface.PatientManager).GetPatientHadFlag(IDCardType,IDCardNo,PatientName,"GETALL")
	if PatientIDStr="" d ..SetOutputCode(.OutputObj,"-330103","该证件信息在系统中未找到相应的卡信息.")	
	set PatientIDStrLen=$l(PatientIDStr,"^")
	for mycount=1:1:PatientIDStrLen{
		s myPatientID=$p(PatientIDStr,"^",mycount)
		continue:myPatientID=""
		Set PatientName=$p(^PAPER(myPatientID,"ALL"),"^",1)
		s PatType=$p(^PAPER(myPatientID,"PER",1),"^",10)
		s PatTypeCode="",PatTypeDesc=""
		if (PatType'=""){
			s PatTypeCode=$p(^CT("SS",PatType),"^",1)	
			s PatTypeDesc=$p(^CT("SS",PatType),"^",2)	
		}
		s PatientCardID=""
		for {
			set PatientCardID=$o(^DHCCARDi("CF",0,"PAPMIDR",myPatientID,PatientCardID))
			Quit:PatientCardID=""
			set CFActive=$p(^DHCCARD("CF",PatientCardID),"^",10)
			continue:CFActive'="N"
			set CFCardTypeDR=$p(^DHCCARD("CF",PatientCardID),"^",16)
			;未授权的卡类型不显示
			set HospShowDataFlag=##class(DHCDoc.Common.Hospital).GetHospShowDataFlag("DHC_CardTypeDef",CFCardTypeDR,HospitalId)
			continue:(HospShowDataFlag="N")
			continue:(CardType'="")&(CardType'=CFCardTypeDR)
			set CFCardTypeDesc=$p($g(^DHCCARDTYPEDef(CFCardTypeDR)),"^",2)
			set CFCardTypeCode=$p($g(^DHCCARDTYPEDef(CFCardTypeDR)),"^",1)
			set PatientCard=$p(^DHCCARD("CF",PatientCardID),"^",2)
			set PatCartObj=##class(DHCExternalService.RegInterface.Entity.SelfReg.List.PatCard).%New()
			set PatCartObj.CardNo=PatientCard
			set PatCartObj.CardTypeCode=CFCardTypeCode
			set PatCartObj.CardType=CFCardTypeDesc
			set PatCartObj.PatientID=##class(DHCExternalService.CardInterface.CardManager).PatientIDToNo(myPatientID)
			set PatCartObj.PatientName=PatientName
			set PatCartObj.PatType=PatTypeDesc
			do OutputObj.PatCards.Insert(PatCartObj)
			do PatCartObj.%Close()
		}
	}
	
	DO OutputObj.XMLExportToString(.XML,"Response")
	q OutputObj
QueryPatCardErr
	s OutputObj=..GetOutputObj("3301")
	s OutputObj.ResultCode="-1"
	s OutputObj.ResultContent="QueryPatCard调用异常"_$ZERROR
	q OutputObj
}

/// d ##class(DHCExternalService.RegInterface.SelfRegMethods).QueryDepartmentGroup("<Request><TradeCode>1014</TradeCode><ExtUserID>sf01</ExtUserID><HospitalId>DHSZHYYKQ</HospitalId></Request>").XMLExportToString(.Str,"Response")
ClassMethod QueryDepartmentGroup(XMLRequest As %String) As DHCExternalService.RegInterface.Entity.SelfReg.QueryDepRp
{
	s ^TMPSelfRegXML("Request","QueryDepartmentGroup")=XMLRequest
	;s XMLRequest="<Request><TradeCode>1014</TradeCode><ExtOrgCode></ExtOrgCode><ClientType></ClientType><HospitalId></HospitalId><ExtUserID>3883</ExtUserID><ScheduleFlag>Y</ScheduleFlag></Request>"
	s $ZTRAP="QueryDepartmentGroupErr"
	s InputObj=..GetInputObj("1014",XMLRequest)
	s HospitalId=InputObj.HospitalId
	s HospitalId=##class(DHCExternalService.RegInterface.GetRelate).GetHISHospitalIdFromOuterCode(HospitalId)     //$o(^CT("HOSP",0,"Code",HospitalId,0))
	s ScheduleFlag=InputObj.ScheduleFlag
	s OutputObj=..GetOutputObj("1014")
	s OutputObj.ResultCode="0"
	s OutputObj.ResultContent=""
	if HospitalId=""{
		d ..SetOutputCode(.OutputObj,"-1014","请传入正确的院区代码.")
		quit OutputObj	
	}
	s UserID=##class(DHCExternalService.RegInterface.GetRelate).GetUser(InputObj.ExtUserID,"",HospitalId)
	if (UserID="") {
		d ..SetOutputCode(.OutputObj,"-1014","请传入正确的操作用户.")
		quit OutputObj
	}
	s GroupRowId=##class(DHCExternalService.RegInterface.GetRelate).GetGroup(UserID)
	s MajorCTLocSortType=##class(DHCDoc.Interface.Outside.Config).GetConfigNode(GroupRowId,"AppRegMajorCTLocSort",HospitalId)

	Set RecordCount=0
	s LocmjId=0
	s Index=0
	for {
		Set LocmjId=$O(^DHCCTLoc(LocmjId)) q:LocmjId=""
		Set DepId=LocmjId
		Set Code=$p($g(^DHCCTLoc(LocmjId)),"^",2)
		Set DepDesc=$p($g(^DHCCTLoc(LocmjId)),"^",1)
		Set StartDate=$p($g(^DHCCTLoc(LocmjId)),"^",3)
		Set EndDate=$p($g(^DHCCTLoc(LocmjId)),"^",4)
		Continue:(StartDate'="")&(StartDate>+$H)
		Continue:(EndDate'="")&(EndDate<+$H)
		Set MinorID=$O(^DHCCTLoc(LocmjId,"MINOR",0))
		if MinorID="" {
			Set DepartmentGroup="N"
		}else{
			Set DepartmentGroup="Y"
		}
		
		Set HospitalDR=$p($g(^DHCCTLoc(LocmjId)),"^",5)
		Continue:(HospitalId'="")&&(HospitalId'=HospitalDR)
		Continue:(ScheduleFlag="Y")&&($$CheckHasSchedule(LocmjId)'=1)	;判断当天是否有排班
		
		Set MajorCTLocSort=9999 
		if MajorCTLocSortType'=""{
			Set MajorCTLocSort=##class(web.DHCBL.BDP.BDPSort).GetSortNum("User.DHCCTLocMajor",MajorCTLocSortType,LocmjId)
			if (MajorCTLocSort="") Set MajorCTLocSort=9999
		}
		Set Index=Index+1
		Set MajorCTLocSortArry(MajorCTLocSort,Index)=LocmjId_"^"_DepId_"^"_DepDesc_"^"_DepartmentGroup
	}
	s MajorCTLocSort=""
	for{
		s MajorCTLocSort=$O(MajorCTLocSortArry(MajorCTLocSort))
		q:MajorCTLocSort=""
		s Ind=""
		for{
			s Ind=$O(MajorCTLocSortArry(MajorCTLocSort,Ind))
			q:Ind=""
			s DepId=$P(MajorCTLocSortArry(MajorCTLocSort,Ind),"^",2)
			s DepDesc=$P(MajorCTLocSortArry(MajorCTLocSort,Ind),"^",3)
			s DepartmentGroup=$P(MajorCTLocSortArry(MajorCTLocSort,Ind),"^",4)
			Set DepartmentObj=##Class(DHCExternalService.RegInterface.Entity.SelfReg.List.Department).%New()
			Set DepartmentObj.DepartmentCode=DepId
			Set DepartmentObj.DepartmentName=DepDesc
			Set DepartmentObj.DepartmentGroup=DepartmentGroup
			Do OutputObj.Departments.Insert(DepartmentObj)
			Do DepartmentObj.%Close()
			Set RecordCount=RecordCount+1
		}
	}
	s OutputObj.RecordCount=RecordCount
	 DO OutputObj.XMLExportToString(.XML,"Response")
	 s ^TMPSelfRegXML("Response","QueryDepartmentGroup")=XML
	 q OutputObj
CheckHasSchedule(LocmjId)
	s HasFlag=0
	s MinorID=0 f  s MinorID=$o(^DHCCTLoc(LocmjId,"MINOR",MinorID)) q:MinorID=""  d
	.s DepId=$p(^DHCCTLoc(LocmjId,"MINOR",MinorID),"^",1)
	.s Active=$p(^DHCCTLoc(LocmjId,"MINOR",MinorID),"^",2)
	.q:Active'="1"
	.s ret=##class(DHCExternalService.RegInterface.RegManager).IsExistDepSchedule(DepId, +$h, +$h)
	.s:ret=1 HasFlag=1
	q HasFlag
QueryDepartmentGroupErr
	s OutputObj=..GetOutputObj("1014")
	s OutputObj.ResultCode="-1"
	s OutputObj.ResultContent="QueryDepartmentGroup调用异常"_$ZERROR
	q OutputObj
}

/// w ##class(DHCExternalService.RegInterface.SelfRegMethods).QueryDepartment("<Request><TradeCode>1012</TradeCode><ExtUserID>sf01</ExtUserID><DepartmentGroupCode></DepartmentGroupCode><ExtOrgCode></ExtOrgCode><ClientType>ATM</ClientType><HospitalId></HospitalId></Request>").XMLExportToString(.str,"Response")
ClassMethod QueryDepartment(XMLRequest As %String) As DHCExternalService.RegInterface.Entity.SelfReg.QueryDepRp
{
	s ^TMPSelfRegXML("Request","QueryDepartment")=XMLRequest
	;s XMLRequest="<Request><TradeCode>1012</TradeCode><ExtUserID>reg</ExtUserID><DepartmentCode></DepartmentCode><StartDate>2019-03-20</StartDate><EndDate>2019-03-20</EndDate><HospitalId></HospitalId></Request>"
	s $ZTRAP="QueryDepartmentErr"
	s InputObj=..GetInputObj("1012",XMLRequest)
	s DepartmentCode=InputObj.DepartmentCode
	s DepartmentGroupCode=InputObj.DepartmentGroupCode
	s HospitalId=InputObj.HospitalId
	s StartDate=InputObj.StartDate
	s EndDate=InputObj.EndDate
	;HospitalId不传的话，则默认查询院区表第一个院区的科室
	s HospitalId=##class(DHCExternalService.RegInterface.GetRelate).GetHISHospitalIdFromOuterCode(HospitalId) 
	s OutputObj=..GetOutputObj("1012")
	s OutputObj.ResultCode="0"
	s OutputObj.ResultContent=""
	if HospitalId=""{
		d ..SetOutputCode(.OutputObj,"-101201","请传入正确的院区代码.")
		quit OutputObj	
	}
	s UserID=##class(DHCExternalService.RegInterface.GetRelate).GetUser(InputObj.ExtUserID,"",HospitalId)
	if (UserID=""){
		d ..SetOutputCode(.OutputObj,"-101201","请传入正确的操作用户.")
		quit OutputObj
	}
	
	s myStartDate="",myEndDate=""
	if (StartDate'="")&&(($l(StartDate,"-")=3)||($l(StartDate,"/")=3)){
		s:StartDate["-" myStartDate=$zdh(StartDate,3)	
		s:StartDate["/" myStartDate=$zdh(StartDate,4)
		if myStartDate<+$h{
			s OutputObj.ResultCode="-101202"
			s OutputObj.ResultContent="查询开始日期不能早于当前日期"
			q OutputObj		
		}
	}
	if (EndDate'="")&&(($l(EndDate,"-")=3)||($l(EndDate,"/")=4)){
		s:EndDate["-" myEndDate=$zdh(EndDate,3)
		s:EndDate["/" myEndDate=$zdh(EndDate,4)	
		if myEndDate<+$h{
			s OutputObj.ResultCode="-101203"
			s OutputObj.ResultContent="查询结束日期不能早于当前日期"
			q OutputObj		
		}
	}
	if (myStartDate'="")&&(myEndDate'=""){
		if (myEndDate<myStartDate){
			s OutputObj.ResultCode="-101204"
			s OutputObj.ResultContent="查询结束日期不能早于开始日期"
			q OutputObj			
		}
		if (myEndDate-myStartDate>15){
			s OutputObj.ResultCode="-101205"
			s OutputObj.ResultContent="查询时间段不宜超过15天"
			q OutputObj			
		}
	}
	k ^Temp("LocSort",$j,UserID)
	s RecordCount=0
	s GroupID=##class(DHCExternalService.RegInterface.GetRelate).GetGroup(UserID)
	s GroupRowId=GroupID
	s GroupResRowIdStr=##class(web.DHCOPRegConfig).GetGroupRes(GroupID,HospitalId)
	s SortType=##class(web.DHCOPRegConfig).GetSpecConfigNode("OutsideLocSort",HospitalId)
	s AllowAdmType="O^E"
	s CTMLNRowid=0
	if ($data(^DHCCTLoc)=11)&&(DepartmentGroupCode'="")
	{
		for {
			Set CTMLNRowid=$O(^DHCCTLoc(DepartmentGroupCode,"MINOR",CTMLNRowid)) q:CTMLNRowid=""
			Set CTLMNCTLocDR=$p($g(^DHCCTLoc(DepartmentGroupCode,"MINOR",CTMLNRowid)),"^",1)
			Set DepartmentName=""
			if CTLMNCTLocDR'="" Set DepartmentName=$p($g(^CTLOC(CTLMNCTLocDR)),"^",2)
			Set CTLMNIsActive=$p($g(^DHCCTLoc(DepartmentGroupCode,"MINOR",CTMLNRowid)),"^",2)
			Continue:CTLMNIsActive'=1
			Set AllowAdmTypeFlag=0
			for loop=1:1:$l(AllowAdmType,"^"){
				s AdmTypePut=$P(AllowAdmType,"^",loop)
				continue:AdmTypePut=""
				if $d(^PAC("ADMLOC",0,"AdmType",AdmTypePut,CTLMNCTLocDR)){
					s AllowAdmTypeFlag=1	
				}
			}
			Continue:AllowAdmTypeFlag=0
			set flag=0
			set ResRowId=0
			for{
				s ResRowId=$O(^RB("RES",0,"CTLOC",CTLMNCTLocDR,ResRowId)) Q:ResRowId=""
 				Continue:("!"_GroupResRowIdStr_"!")'[("!"_ResRowId_"!")
 				s flag=1
			}
 			if ((flag=0)&&(GroupResRowIdStr'="")) continue
 			set ExistDepSchedule=##class(DHCExternalService.RegInterface.RegManager).IsExistDepSchedule(CTLMNCTLocDR,StartDate,EndDate)
			;查科室过滤没有排班的科室
			continue:(ExistDepSchedule=0)
 			Set DepartmentHospCode=$p($g(^CTLOC(CTLMNCTLocDR)),"^",22)
			continue:(HospitalId'="")&&(HospitalId'=DepartmentHospCode)
			set DepartmentHospDesc=""
			if DepartmentHospCode'="" s DepartmentHospDesc=$p(^CT("HOSP",DepartmentHospCode),"^",2)
 			set LocAddress=""
			set AddDr=$o(^CTLOC(CTLMNCTLocDR,"ADDR",""),-1)
			if (AddDr'="") set LocAddress=$get(^CTLOC(CTLMNCTLocDR,"ADDR",AddDr))
			
			s CTLOCMarkNO=""
			/*i SortType'="" s CTLOCMarkNO=##class(web.DHCBL.BDP.BDPSort).GetSortNum("User.CTLoc",SortType,CTLMNCTLocDR)
			s CTLOCMarkNO=$case($l(CTLOCMarkNO),0:"999",1:"00"_CTLOCMarkNO,2:"0"_CTLOCMarkNO,:CTLOCMarkNO)*/
			s SortType=##class(DHCDoc.Interface.Outside.Config).GetConfigNode(GroupRowId,"MinorCTLocSort"_DepartmentGroupCode,HospitalId)
			i SortType'="" s CTLOCMarkNO=##class(web.DHCBL.BDP.BDPSort).GetSortNum("User.DHCCTLocMinor",SortType,DepartmentGroupCode_"||"_CTMLNRowid)
			s CTLOCMarkNO=$case($l(CTLOCMarkNO),0:"999",1:"00"_CTLOCMarkNO,2:"0"_CTLOCMarkNO,:CTLOCMarkNO)
			s ^Temp("LocSort",$j,UserID,CTLOCMarkNO,CTLMNCTLocDR)=CTLMNCTLocDR_"^"_DepartmentName_"^"_DepartmentGroupCode_"^"_LocAddress_"^"_DepartmentHospCode_"^"_DepartmentHospDesc
			Set RecordCount=RecordCount+1
		}
	}
	elseif (DepartmentCode'="")&&($d(^CTLOC(DepartmentCode)))
	{
		set DepartmentName=$p(^CTLOC(DepartmentCode),"^",2)
		if (DepartmentName["-") d
		.set DepartmentName=$piece(DepartmentName,"-",2)
		set LocAddress=""
		set AddDr=$o(^CTLOC(DepartmentCode,"ADDR",""),-1)
		if (AddDr'="") set LocAddress=$get(^CTLOC(DepartmentCode,"ADDR",AddDr))
		;科室挂号年龄限制将取“挂号设置-挂号科室扩展设置”
		set DepartmentAgeLimit="" ;$p($g(^DHCOPRegConfig("OPRegDepExpand",DepartmentCode)),"^",3)
		set DepartmentDepDR=$p(^CTLOC(DepartmentCode),"^",19)
		set DepartmentHospCode=$p(^CTLOC(DepartmentCode),"^",22)
		set DepartmentHospDesc=""
		if DepartmentHospCode'="" s DepartmentHospDesc=$p(^CT("HOSP",DepartmentHospCode),"^",2)
		
		s CTLOCMarkNO=##class(web.DHCBL.BDP.BDPSort).GetSortNum("User.CTLoc","正式",DepartmentCode)
		i CTLOCMarkNO="" s CTLOCMarkNO="999"
		s ^Temp("LocSort",$j,UserID,CTLOCMarkNO,DepartmentCode)=DepartmentCode_"^"_DepartmentName_"^"_"-1"_"^"_LocAddress_"^"_DepartmentHospCode_"^"_DepartmentHospDesc_"^"_DepartmentAgeLimit
		Set RecordCount=RecordCount+1
	}
	else
	{
		set myOPDeptStr=##class(DHCExternalService.RegInterface.SelfRegQueryMetods).GetOPDeptStr(UserID,AllowAdmType,HospitalId)
		set myDeptNum=$length(myOPDeptStr,"^")
		for i=1:1:myDeptNum
		{
			set myOneDeptStr=$piece(myOPDeptStr,"^",i)
			set DepartmentCode=$piece(myOneDeptStr,$C(1),1)
			continue:DepartmentCode=""
			set DepartmentName=$p(^CTLOC(DepartmentCode),"^",2)
			if (DepartmentName["-") d
			.set DepartmentName=$piece(DepartmentName,"-",1)
			set LocAddress=""
			set AddDr=$o(^CTLOC(DepartmentCode,"ADDR",""),-1)
			if (AddDr'="") set LocAddress=$get(^CTLOC(DepartmentCode,"ADDR",AddDr))
			set flag=0
			set ResRowId=0  f  s ResRowId=$O(^RB("RES",0,"CTLOC",DepartmentCode,ResRowId)) Q:ResRowId=""  d
 			.Q:("!"_GroupResRowIdStr_"!")'[("!"_ResRowId_"!")
 			.s flag=1
			if ((flag=0)&&(GroupResRowIdStr'="")) continue
			set ExistDepSchedule=##class(DHCExternalService.RegInterface.RegManager).IsExistDepSchedule(DepartmentCode,StartDate,EndDate)
			;查科室过滤没有排班的科室
			continue:(ExistDepSchedule=0)
			;科室挂号年龄限制将取“挂号设置-挂号科室扩展设置”
			set DepartmentAgeLimit="" ;$p($g(^DHCOPRegConfig("OPRegDepExpand",DepartmentCode)),"^",3)
			set DepartmentDepDR=$p(^CTLOC(DepartmentCode),"^",19)
			set DepartmentHospCode=$p(^CTLOC(DepartmentCode),"^",22)
			continue:(HospitalId'="")&&(HospitalId'=DepartmentHospCode)
			set DepartmentHospDesc=""
			if DepartmentHospCode'="" s DepartmentHospDesc=$p(^CT("HOSP",DepartmentHospCode),"^",2)
			;if (DepartmentName["急诊") continue
			
			s CTLOCMarkNO=##class(web.DHCBL.BDP.BDPSort).GetSortNum("User.CTLoc","正式",DepartmentCode)
			i CTLOCMarkNO="" s CTLOCMarkNO="999"
			s ^Temp("LocSort",$j,UserID,CTLOCMarkNO,DepartmentCode)=DepartmentCode_"^"_DepartmentName_"^"_"-1"_"^"_LocAddress_"^"_DepartmentHospCode_"^"_DepartmentHospDesc_"^"_DepartmentAgeLimit
			Set RecordCount=RecordCount+1
		}
	}
	d OutPutSortRow
	s OutputObj.RecordCount=RecordCount
	k ^Temp("LocSort",$j,UserID)
	DO OutputObj.XMLExportToString(.XML,"Response")
	q OutputObj
OutPutSortRow
	s l1=0 f  {
		s l1=$o(^Temp("LocSort",$j,UserID,l1)) 
		q:l1="" 
		s l2=0 f  {
			s l2=$o(^Temp("LocSort",$j,UserID,l1,l2)) 
			q:l2=""
			s Info=$g(^Temp("LocSort",$j,UserID,l1,l2))
			s CTLMNCTLocDR=$p(Info,"^",1)
			s DepartmentName=$p(Info,"^",2)
			s DepartmentGroupCode=$p(Info,"^",3)
			s LocAddress=$p(Info,"^",4)
			s DepartmentHospCode=$p(Info,"^",5)
			s DepartmentHospDesc=$p(Info,"^",6)
			s DepartmentAgeLimit=$p(Info,"^",7)
			
			Set DepartmentObj=##Class(DHCExternalService.RegInterface.Entity.SelfReg.List.Department).%New()
			Set DepartmentObj.DepartmentCode=CTLMNCTLocDR
			Set DepartmentObj.DepartmentName=DepartmentName
			set DepartmentObj.ParentId=DepartmentGroupCode
			set DepartmentObj.DepartmentAddress=LocAddress
			set DepartmentObj.DepartmentHospCode=DepartmentHospCode
			set DepartmentObj.DepartmentHospDesc=DepartmentHospDesc
			set DepartmentObj.Description=""
			set DepartmentObj.DepartmentAgeLimit=DepartmentAgeLimit
			
			Do OutputObj.Departments.Insert(DepartmentObj)
			Do DepartmentObj.%Close()
		}
	}
	q 0
	
QueryDepartmentErr
	s OutputObj=..GetOutputObj("1012")
	s OutputObj.ResultCode="-1"
	s OutputObj.ResultContent="QueryDepartment调用异常"_$ZERROR
	q OutputObj
}

/// w ##class(DHCExternalService.RegInterface.SelfRegMethods).QueryDoctor("<Request><TradeCode>1013</TradeCode><ExtOrgCode></ExtOrgCode><ClientType></ClientType><HospitalId></HospitalId><ExtUserID>457</ExtUserID><DepartmentCode>49</DepartmentCode></Request>")
ClassMethod QueryDoctor(XMLRequest As %String) As DHCExternalService.RegInterface.Entity.SelfReg.QueryDocRp
{
	;s ^TMPSelfRegXML("Request","QueryDoctor")=XMLRequest
	s $ZTRAP="QueryDoctorErr"
	s RecordCount=0
	s InputObj=..GetInputObj("1013",XMLRequest)
	s DepartmentCode=InputObj.DepartmentCode
	s HospitalId=InputObj.HospitalId
	s DoctorCode=InputObj.DoctorCode
	s HospitalId=##class(DHCExternalService.RegInterface.GetRelate).GetHISHospitalIdFromOuterCode(HospitalId) 
	s OutputObj=..GetOutputObj("1013")
	s OutputObj.ResultCode="0"
	s OutputObj.ResultContent=""
	
	if HospitalId=""{
		d ..SetOutputCode(.OutputObj,"-100","请传入正确的院区代码.")
		quit OutputObj	
	}
	s UserID=##class(DHCExternalService.RegInterface.GetRelate).GetUser(InputObj.ExtUserID,"",HospitalId)
	if (UserID=""){
		s OutputObj.ResultCode="-101"
		s OutputObj.ResultContent="请传入正确的操作用户"
		q OutputObj	
	}
	i DepartmentCode=""{
		d ..SetOutputCode(.OutputObj,"-101202","科室代码不能都为空.")
		q OutputObj
	}
	
	s GroupID=##class(DHCExternalService.RegInterface.GetRelate).GetGroup(UserID)
	s GroupResRowIdStr=##class(web.DHCOPRegConfig).GetGroupRes(GroupID,HospitalId)
	
	Set rs1=##class(%ResultSet).%New("DHCExternalService.RegInterface.SelfRegQueryMetods:FindResDoc")
	Set Status=0
	If rs1.QueryIsValid() { 
		Set Status=rs1.Execute(DepartmentCode,UserID,DoctorCode,HospitalId)
		If 'Status Quit
		While rs1.Next() {
			set DocDesc=rs1.GetData(1)
			set DocCode=rs1.GetData(2)
			set DocID=rs1.GetData(3)
			set ResRowid=rs1.GetData(4)
			set DeptId=rs1.GetData(5)
			set DeptDesc=rs1.GetData(6)
			set DocProveTypeDesc=rs1.GetData(7)
			set DocProveTypeID=rs1.GetData(8)
			set DocIntruduction=rs1.GetData(9)
			set flag=0
			set ResRowId=0 
			for{
				s ResRowId=$O(^RB("RES",0,"CTPCP",DocID,DeptId,ResRowId)) Q:ResRowId=""
 				continue:("!"_GroupResRowIdStr_"!")'[("!"_ResRowId_"!")
 				set flag=1
			}
			if ((flag=0)&&(GroupResRowIdStr'="")) continue
			Set DoctorObj=##Class(DHCExternalService.RegInterface.Entity.SelfReg.List.Doctor).%New()
			Set DoctorObj.DoctorCode=DocID
			Set DoctorObj.DoctorName=DocDesc
			Set DoctorObj.DoctotLevelCode=DocProveTypeDesc
			Set DoctorObj.DoctorLevel=DocProveTypeID
			Set DoctorObj.DeptId=DeptId
			Set DoctorObj.DeptName=DeptDesc
			Set DoctorObj.Description=DocIntruduction
			Do OutputObj.Doctors.Insert(DoctorObj)
			Do DoctorObj.%Close()
			Set RecordCount=RecordCount+1
		}
	}
	s OutputObj.RecordCount=RecordCount
	q OutputObj
QueryDoctorErr
	s OutputObj=..GetOutputObj("1013")
	s OutputObj.ResultCode="-1"
	s OutputObj.ResultContent="QueryDepartmentGroup调用异常"_$ZERROR
	q OutputObj
}

/// s rp=##class(DHCExternalService.RegInterface.SelfRegMethods).QueryAdmSchedule("<Request><TradeCode>1004</TradeCode><ExtOrgCode>H1</ExtOrgCode><ClientType>ATM</ClientType><HospitalId>1</HospitalId><ExtUserID>reg</ExtUserID><StartDate>2017-07-19</StartDate><EndDate>2016-04-14</EndDate><DepartmentCode>63</DepartmentCode><ServiceCode></ServiceCode><DoctorCode></DoctorCode><RBASSessionCode></RBASSessionCode></Request>","")
/// w ##class(DHCExternalService.RegInterface.SelfRegMethods).QueryAdmSchedule(^TMPSelfRegXML("Request","QueryAdmSchedule"),"")
ClassMethod QueryAdmSchedule(XMLRequest As %String, SeachType As %String = "") As DHCExternalService.RegInterface.Entity.SelfReg.QueryAdmScheduleRp
{
	s ^TMPSelfRegXML("Request","QueryAdmSchedule")=XMLRequest
	;s XMLRequest="<Request><TradeCode>1004</TradeCode><ExtOrgCode>H1</ExtOrgCode><ClientType>ATM</ClientType><HospitalId>1</HospitalId><ExtUserID>810_100</ExtUserID><StartDate>2012-10-10</StartDate><EndDate>2012-10-10</EndDate><DepartmentCode>229</DepartmentCode><ServiceCode></ServiceCode><DoctorCode></DoctorCode><RBASSessionCode></RBASSessionCode></Request>"
	s $ZTRAP="QueryAdmScheduleErr"
	s InputObj=..GetInputObj("1004",XMLRequest)
	s HospitalId=InputObj.HospitalId
	s HospitalId=##class(DHCExternalService.RegInterface.GetRelate).GetHISHospitalIdFromOuterCode(HospitalId)
	s PatientID=InputObj.PatientID
	s StartDate=InputObj.StartDate
	s EndDate=InputObj.EndDate
	s DepartmentCode=InputObj.DepartmentCode
	s ServiceCode=InputObj.ServiceCode
	s DoctorCode=InputObj.DoctorCode
	s SessionCode=InputObj.RBASSessionCode
	s SessionCode=##Class(DHCExternalService.RegInterface.SelfRegPlulic).GetOuterTimeRangeCodeAnti(SessionCode)
	s BillTypeID=InputObj.BillTypeID
	if (PatientID'=""){
		set PatientID=$Order(^PAPERi("PAPMI_PatNo",PatientID,0))
	}
	s OutputObj=..GetOutputObj("1004")
	s OutputObj.ResultCode="0"
	s OutputObj.ResultContent=""
	i StartDate="" s StartDate=$zd(+$h,3)
	i EndDate="" s EndDate=$zd(+$h,3)
	s CurrTime=..%SysTime()
	if HospitalId=""{
		d ..SetOutputCode(.OutputObj,"-100","请传入正确的院区代码.")
		quit OutputObj	
	}
	s UserID=##class(DHCExternalService.RegInterface.GetRelate).GetUser(InputObj.ExtUserID,"",HospitalId)
	i StartDate="" {
		d ..SetOutputCode(.OutputObj,"-100401","开始日期不能都为空.")
		q OutputObj
	}else{
		i ($l(StartDate,"-")'=3)&&($l(StartDate,"/")'=3) {
			d ..SetOutputCode(.OutputObj,"-100402","开始日期格式不对.")
			q OutputObj
		}
	}
	i EndDate="" {
		d ..SetOutputCode(.OutputObj,"-100403","结束日期不能都为空.")
		q OutputObj
	}else{
		i ($l(EndDate,"-")'=3)&&($l(EndDate,"/")'=3) {
			d ..SetOutputCode(.OutputObj,"-100404","结束日期格式不对.")
			q OutputObj
		}
	}
	i DepartmentCode="" {
		d ..SetOutputCode(.OutputObj,"-100405","科室代码不能都为空.")
		q OutputObj
	}
	s RecordCount=0
	s:StartDate["-" StartDate=$zdh(StartDate,3)
	s:StartDate["/" StartDate=$zdh(StartDate,4)
	s:EndDate["-" EndDate=$zdh(EndDate,3)
	s:EndDate["/" EndDate=$zdh(EndDate,4)
	s GroupRowId=$p($g(^SSU("SSUSR",UserID)),"^",5)
	s BankCode=##class(DHCDoc.Interface.Outside.Config).GetConfigNode(GroupRowId,"DataCompareExtOrg",HospitalId)
	S AppRegMethodCode=""
	s AppRegMethodRowID=##class(DHCDoc.Interface.Outside.Config).GetConfigNode(GroupRowId,"AppRegMethod")
	if AppRegMethodRowID'="" s AppRegMethodCode=$P(^RBC("APTM",AppRegMethodRowID),"^",1)
	if AppRegMethodCode="" s AppRegMethodCode="WIN"
	s QuitNoAvailbleSchdule=+(##class(DHCDoc.Interface.Outside.Config).GetConfigNode(GroupRowId,"QuitNoAvailbleSchdule"))
	
	if $g(BillTypeID)'=""{
		s AdmReason=BillTypeID
		if '$d(^PAC("ADMREA",AdmReason)){
			d ..SetOutputCode(.OutputObj,"-100406","HIS系统中未找到该就诊结算费别信息")
			q OutputObj
		}
	}else{
		s AdmReason=""
		if (PatientID'="") {
			s PatCatDr=$p(^PAPER(PatientID,"PER",1),"^",10)
			s PatCatDesc=$p(^CT("SS",PatCatDr),"^",2)
			s AdmReason=##Class(web.DHCOPAdmReg).GetDefaultBillType(PatCatDr)
		}
	}
	s SchdulExpStr=BankCode_"^"_GroupRowId_"^"_QuitNoAvailbleSchdule_"^"_"" ;第4位亚专业占位
	if SeachType="" {
		s TimeRangeId=SessionCode
		;上下午
		Set SelectTRQuery=""
		;服务组
		Set ClinicServiceGroupRowId=""
		;是否显示停诊
		Set ShowStopFlag="0"
		;优惠类型
		Set RegConDisId=""
		;登录医院
		Set LogonHospId=HospitalId
		;是否显示无可预约号源的排班
		Set ShowNoAppLoadFlag=$case(QuitNoAvailbleSchdule,1:"",:"Y")
		
		;出诊科室^排班查询用户^排班日期^患者ID^时段ID
		;^出诊医生^安全组^患者费别^DiagnosCatRowId^上下午
		;^服务组^是否显示停诊^优惠类型^登录医院^预约方式
		;^是否显示无可预约号源的排班
		s val=DepartmentCode_"^"_UserID_"^"_"^^"_TimeRangeId_"^"_DoctorCode_"^"_GroupRowId_"^"_AdmReason_"^false^"_SelectTRQuery_"^"_ClinicServiceGroupRowId_"^"_ShowStopFlag_"^"_RegConDisId_"^"_LogonHospId_"^"_AppRegMethodCode_"^"_ShowNoAppLoadFlag
		if (StartDate>+$H) {
			s $p(val,"^",3)=StartDate_"||"_EndDate
		}
		;s ^TMP("QueryAdmSchedule")=val
		s rs=##Class(%ResultSet).%New("web.DHCOPAdmReg:OPDocList")
		;查询时间段的预约排班信息
		;s rs=##Class(%ResultSet).%New("DHCExternalService.RegInterface.SelfRegQueryMetods:OPDocList")
		i rs.QueryIsValid() { 
			Set Status=rs.Execute(val)
			Set columns = rs.GetColumnCount()
			If 'Status Quit
			While rs.Next() {
				s ASRowId=rs.GetDataByName("ASRowId")
				s Load=rs.GetDataByName("Load")
				s NoLimitLoadFlag=rs.GetDataByName("NoLimitLoadFlag")
				i (NoLimitLoadFlag'="Y")&&(+Load=0)  continue
				s RegedCount=rs.GetDataByName("RegedCount")
				s AppLoad=rs.GetDataByName("AppLoad")
				s AppedCount=rs.GetDataByName("AppedCount")
				s AddLoad=rs.GetDataByName("AddLoad")
				s AddedCount=rs.GetDataByName("AddedCount")
				s AvailSeqNo=rs.GetDataByName("AvailNorSeqNoStr") ;现场剩号
				s AvailSeqNo=rs.GetDataByName("AvailSeqNoStr") ;剩号
				s RegFee=rs.GetDataByName("RegFee")
				s ExamFee=rs.GetDataByName("ExamFee")
				s ClinicGroupDr=rs.GetDataByName("ClinicGroupDr")
				s RegFee=ExamFee+RegFee
				continue:+ASRowId=0
				s ResID=+ASRowId
				s Sub=$p(ASRowId,"||",2)
				s ASDate=$p($g(^RBAS(ResID,Sub)),"^",1)
				s SessEndTime=$p($g(^RBAS(ResID,Sub)),"^",5)
				;不显示当前时段以前的号
				Continue:(ASDate=..%SysDate())&&(SessEndTime<..%SysTime())
				Continue:(EndDate'="")&&(ASDate>EndDate)
				s $p(SchdulExpStr,"^",4)=ClinicGroupDr
				s OneAdmScheduleObj=..QueryOneAdmSchedule(ASRowId,PatientID,AppRegMethodCode,"",SchdulExpStr)
				if $IsObject(OneAdmScheduleObj) {
					do OutputObj.Schedules.Insert(OneAdmScheduleObj)
					s RecordCount=RecordCount+1
				}
			}
		}
	}else{
		s ResID=0
		for {
			s ResID=$O(^RB("RES",0,"CTLOC",DepartmentCode,ResID)) q:ResID=""
			s ResCTPCPDR=$p($g(^RB("RES",ResID)),"^",2)
			Continue:ResCTPCPDR=""
			Continue:(DoctorCode'="")&(DoctorCode'=ResCTPCPDR)
			s Date=StartDate-1
			for {
				s Date=$O(^RBAS(ResID,0,"DateSTime",Date)) q:(Date="")||(Date>EndDate)
				s Time=""
				for {
					s Time=$O(^RBAS(ResID,0,"DateSTime",Date,Time)) q:(Time="")
					s Sub=0
					for {
						s Sub=$O(^RBAS(ResID,0,"DateSTime",Date,Time,Sub)) q:(Sub="")  d
						s RBASID=ResID_"||"_Sub
						s ASDate=$p($g(^RBAS(ResID,Sub)),"^",1)
						s SessEndTime=$p($g(^RBAS(ResID,Sub)),"^",5)
						b ;不显示当前时段以前的号
						Continue:(ASDate=..%SysDate())&&(SessEndTime<..%SysTime())
						s RBASServiceCode=$p($g(^RBAS(ResID,Sub,"DHC")),"^",7)
						Continue:(ServiceCode'="")&(ServiceCode'=RBASServiceCode)
						s RBASSessionCode=$p($g(^RBAS(ResID,Sub,"DHC")),"^",17)
						Continue:(SessionCode'="")&(SessionCode'=RBASSessionCode)
						s OneAdmScheduleObj=..QueryOneAdmSchedule(RBASID,"",AppRegMethodCode,AdmReason,SchdulExpStr)
						if $IsObject(OneAdmScheduleObj) {
							do OutputObj.Schedules.Insert(OneAdmScheduleObj)
							s RecordCount=RecordCount+1
						}
					}
				}
			}
		}
	}
	s OutputObj.RecordCount=RecordCount
	if (RecordCount=0) set OutputObj.ResultContent="号已挂完"
	q OutputObj
QueryAdmScheduleErr
	;q "-1^QueryAdmSchedule调用异常"_$ZERROR
	s OutputObj=..GetOutputObj("1004")
	s OutputObj.ResultCode="-1"
	s OutputObj.ResultContent="QueryAdmSchedule调用异常"_$ZERROR
	q OutputObj
}

/// w ##class(DHCExternalService.RegInterface.SelfRegMethods).QueryScheduleTimeInfo(^TMPSelfRegXML("Request","QueryScheduleTimeInfo"))
ClassMethod QueryScheduleTimeInfo(XMLRequest As %String) As DHCExternalService.RegInterface.Entity.SelfReg.QueryScheduleTimeInfoRp
{
	s ^TMPSelfRegXML("Request","QueryScheduleTimeInfo")=XMLRequest
	;s XMLRequest="<Request><TradeCode>10041</TradeCode><ExtOrgCode>H1</ExtOrgCode><ClientType>ATM</ClientType><ScheduleItemCode>2||333</ScheduleItemCode><ExtUserID>sf01</ExtUserID><StartDate></StartDate><EndDate></EndDate><DepartmentCode></DepartmentCode><ServiceCode></ServiceCode><DoctorCode></DoctorCode><RBASSessionCode></RBASSessionCode></Request>"
	s $ZTRAP="QueryScheduleTimeInfoErr"
	s InputObj=..GetInputObj("10041",XMLRequest)
	s ScheduleItemCode=InputObj.ScheduleItemCode
	s DepartmentCode=InputObj.DepartmentCode
	s DoctorCode=InputObj.DoctorCode
	s SessionCode=InputObj.RBASSessionCode
	s ServiceDate=InputObj.ServiceDate
	s HospitalId=InputObj.HospitalId
	s ClinicGroupDr=InputObj.ClinicGroupDr
	s HospitalId=##class(DHCExternalService.RegInterface.GetRelate).GetHISHospitalIdFromOuterCode(HospitalId,ScheduleItemCode)
	s SessionCode=##Class(DHCExternalService.RegInterface.SelfRegPlulic).GetOuterTimeRangeCodeAnti(SessionCode)
	s OutputObj=..GetOutputObj("10041")
	s OutputObj.ResultCode="0"
	s OutputObj.ResultContent=""
	i ServiceDate["-" s ServiceDate=$zdh(ServiceDate,3)
	i ServiceDate["/" s ServiceDate=$zdh(ServiceDate,4)
	if HospitalId=""{
		d ..SetOutputCode(.OutputObj,"-100","请传入正确的院区代码.")
		quit OutputObj	
	}
	s UserID=##class(DHCExternalService.RegInterface.GetRelate).GetUser(InputObj.ExtUserID,"",HospitalId)
	if (UserID=""){
    	d ..SetOutputCode(.OutputObj,"-1001506","请传入正确的操作用户")
		q OutputObj
	}
	s GroupID=##class(DHCExternalService.RegInterface.GetRelate).GetGroup(UserID)
	s BankCode=##class(DHCDoc.Interface.Outside.Config).GetConfigNode(GroupID,"DataCompareExtOrg",HospitalId)
	S AppRegMethodCode=""
	s AppRegMethodRowID=##class(DHCDoc.Interface.Outside.Config).GetConfigNode(GroupID,"AppRegMethod",HospitalId)
	if AppRegMethodRowID'="" s AppRegMethodCode=$P(^RBC("APTM",AppRegMethodRowID),"^",1)
	if AppRegMethodCode="" s AppRegMethodCode="WIN"
	i ScheduleItemCode=""{
		i DepartmentCode="" {
			d ..SetOutputCode(.OutputObj,"-100411","科室代码不能都为空.")
			q OutputObj
		}
		i DoctorCode="" {
			d ..SetOutputCode(.OutputObj,"-100412","医生代码不能都为空.")
			q OutputObj
		}
		i SessionCode="" {
			d ..SetOutputCode(.OutputObj,"-100412","班别代码不能都为空.")
			q OutputObj
		}
		i ServiceDate=""{
			d ..SetOutputCode(.OutputObj,"-100412","出诊日期不能都为空.")
			q OutputObj
		}
		s StartDate=ServiceDate
		s EndDate=ServiceDate
		s ResID=0
		for {
			s ResID=$O(^RB("RES",0,"CTLOC",DepartmentCode,ResID)) q:ResID=""
			s ResCTPCPDR=$p($g(^RB("RES",ResID)),"^",2)
			Continue:ResCTPCPDR=""
			Continue:(DoctorCode'="")&(DoctorCode'=ResCTPCPDR)
			s Date=StartDate-1
			for {
				s Date=$O(^RBAS(ResID,0,"DateSTime",Date)) q:(Date="")||(Date>EndDate)
				s Time=0
				for {
					s Time=$O(^RBAS(ResID,0,"DateSTime",Date,Time)) q:(Time="")
					s Sub=0
					for {
						s Sub=$O(^RBAS(ResID,0,"DateSTime",Date,Time,Sub)) q:(Sub="")  d
						s RBASID=ResID_"||"_Sub
						s ASDate=$p($g(^RBAS(ResID,Sub)),"^",1)
						s SessEndTime=$p($g(^RBAS(ResID,Sub)),"^",5)
						;不显示当前时段以前的号
						Continue:(ASDate=..%SysDate())&&(SessEndTime<..%SysTime())
						;s RBASServiceCode=$p($g(^RBAS(ResID,Sub,"DHC")),"^",7)
						;Continue:(ServiceCode'="")&(ServiceCode'=RBASServiceCode)
						s RBASSessionCode=$p($g(^RBAS(ResID,Sub,"DHC")),"^",17)
						Continue:(SessionCode'="")&(SessionCode'=RBASSessionCode)
						s ScheduleItemCode=RBASID
					}
				}
			}
		}
	}
	s RecordCount=0
	if ScheduleItemCode'="" {
		if ($l(ScheduleItemCode,"||")'=2){
			d ..SetOutputCode(.OutputObj,"-100413","排班ID格式不正确")
			q OutputObj
		}
		if '$d(^RBAS(+ScheduleItemCode,+$p(ScheduleItemCode,"||",2))){
			d ..SetOutputCode(.OutputObj,"-100414","排班不存在")
			q OutputObj	
		}
		s ASStatusDR=$P($g(^RBAS(+ScheduleItemCode,$p(ScheduleItemCode,"||",2),"DHC")),"^",10)
		s ASTimeRangeFlag=$P($g(^RBAS(+ScheduleItemCode,$p(ScheduleItemCode,"||",2),"DHC")),"^",19)
		s ASStatus=$P($g(^DHCRBCASStatus(+ASStatusDR)),"^",1)
		if (ASStatus="S")||(ASStatus="TR")
		{
			d ..SetOutputCode(.OutputObj,"-100415","排班已经停诊或替诊")
			q OutputObj
		}
		if (ASTimeRangeFlag'="Y"){
			d ..SetOutputCode(.OutputObj,"-100417","该排班未有分时段信息")
			q OutputObj
		}
		s RBASObject=##class(User.RBApptSchedule).%OpenId(ScheduleItemCode,0,.sc)
		/*s ASLoad=RBASObject.ASLoad
		s AvailSeqNoStr=..GetAvailSeqNoStr(ScheduleItemCode,AppRegMethodCode)
		s AvailSeqNoStr=$p(AvailSeqNoStr,"^")*/
		s TimeRange=""
		s OneEndNo=0
		s ASTRSub=0 for {
			s ASTRSub=$O(^RBAS(+ScheduleItemCode,$P(ScheduleItemCode,"||",2),"ASTR",ASTRSub)) q:(ASTRSub="")||(TimeRange'="")
			s TRLoad=$P(^RBAS(+ScheduleItemCode,$P(ScheduleItemCode,"||",2),"ASTR",ASTRSub),"^",3)
			s OneSttNo=OneEndNo+1,OneEndNo=OneEndNo+TRLoad
			s StartTime=$P(^RBAS(+ScheduleItemCode,$P(ScheduleItemCode,"||",2),"ASTR",ASTRSub),"^",1)
			s EndTime=$P(^RBAS(+ScheduleItemCode,$P(ScheduleItemCode,"||",2),"ASTR",ASTRSub),"^",2)
			s OneTimeRange=..%ZT(StartTime)_"-"_..%ZT(EndTime)
			s OneRegNumRange=OneSttNo_"-"_OneEndNo
			s RBASRecObj=..GetRBASRecTimeObj(RBASObject,OneTimeRange,OneRegNumRange,TRLoad,AppRegMethodCode,BankCode,ClinicGroupDr)			
			;s AvailableLeftNum=RBASRecObj.AvailableLeftNum
			;continue:+AvailableLeftNum=0
			if $IsObject(RBASRecObj) {
				do OutputObj.TimeRanges.Insert(RBASRecObj)
				s RecordCount=RecordCount+1
			}
		}
		;退号不释放资源并增号出来的号不在分时段内,接口不会返回这些增的号,需解决
		;如果最大的号大于分时段最后一个序号,则将之后的号放在整个大的分时段内
		;那如果本来就不在分时段里的怎么办?
		;比如一共20个号,只有1-10号是在分时段里,增的号还放到大的时段里?那不是本来不在分时段里的11-20号也搞到分时段里了
		/*s LastASTRRegNum=$p(ASTRRegNumStr,"-",$l(ASTRRegNumStr,"-"))
		s LastASTRRegNumA=LastASTRRegNum+1
		S MaxQueueNO=##class(web.DHCRBResourceRule).GetMaxQueueNO($p(DHCRBASObject.ASQueueNo,$c(1)))
		if MaxQueueNO>LastASTRRegNum{
			s ASTRRegNumStr=ASTRRegNumStr_","_LastASTRRegNumA_"-"_MaxQueueNO
			s ASTRRegInfoStr=ASTRRegInfoStr_","_$p(ASTRRegInfoStr,"-",1)_"-"_$p(ASTRRegInfoStr,"-",$l(ASTRRegInfoStr,"-"))
		}*/
		
		d RBASObject.%Close()
	}else{
		d ..SetOutputCode(.OutputObj,"-100416","未查询到排班信息")
		q OutputObj	
	}
	s OutputObj.RecordCount=RecordCount
	if (RecordCount=0) set OutputObj.ResultContent="号已挂完"
	q OutputObj
QueryScheduleTimeInfoErr
	s OutputObj=..GetOutputObj("10041")
	s OutputObj.ResultCode="-1"
	s OutputObj.ResultContent="QueryScheduleTimeInfo调用异常"_$ZERROR
	q OutputObj
}

/// s rp=##class(DHCExternalService.RegInterface.SelfRegMethods).LockOrder("<Request><TradeCode>10016</TradeCode><PatientCard></PatientCard><PatientID>0000001337</PatientID><ExtUserID>457</ExtUserID><ScheduleItemCode>1087||1207</ScheduleItemCode><PayOrderId></PayOrderId></Request>")
/// w ##class(DHCExternalService.RegInterface.SelfRegMethods).LockOrder(^TMPSelfRegXML("Request","LockOrder"))
ClassMethod LockOrder(XMLRequest As %String) As DHCExternalService.RegInterface.Entity.SelfReg.LockOrderRp
{
	s $ZTRAP="LockOrderErr"
	s ^TMPSelfRegXML("Request","LockOrder")=XMLRequest
	s InputObj=..GetInputObj("10015",XMLRequest)
	s ClientType=InputObj.ClientType
	s ExtUserID=InputObj.ExtUserID
	s ScheduleItemCode=InputObj.ScheduleItemCode
	s PatientCard=InputObj.CardNo
	s CardType=InputObj.CardType
	s CredTypeCode=InputObj.CredTypeCode
	s IDCardNo=InputObj.IDCardNo
	s LockQueueNo=InputObj.LockQueueNo
	s PatientNo=InputObj.PatientID
	s TradeCode=InputObj.TradeCode
	s HospitalId=InputObj.HospitalId
	s BeginTime=InputObj.BeginTime
	s EndTime=InputObj.EndTime
	s TransactionId=InputObj.TransactionId
	s PayOrdId=InputObj.PayOrderId 
	s BillTypeID=InputObj.BillTypeID 
	s NeedInsuRegData=InputObj.NeedInsuRegData
	s PayModeCode=InputObj.PayModeCode
	s ClinicGroupDr=InputObj.ClinicGroupDr
	s OutputObj=..GetOutputObj("10015")
	s HospitalId=##class(DHCExternalService.RegInterface.GetRelate).GetHISHospitalIdFromOuterCode(HospitalId,ScheduleItemCode) 
	s Mobile=InputObj.Mobile
	if HospitalId=""{
		d ..SetOutputCode(.OutputObj,"-100","请传入正确的院区代码.")
		quit OutputObj	
	}
	s UserID=##class(DHCExternalService.RegInterface.GetRelate).GetUser(ExtUserID,"",HospitalId)
	if (UserID=""){
    	d ..SetOutputCode(.OutputObj,"-1001501","操作员信息为空")
		q OutputObj
	}
	s GroupID=##class(DHCExternalService.RegInterface.GetRelate).GetGroup(UserID)
	s BankCode=##class(DHCDoc.Interface.Outside.Config).GetConfigNode(GroupID,"DataCompareExtOrg",HospitalId)
	s CardType=##class(DHCExternalService.RegInterface.GetRelate).GetHisCardTypeID(CardType,BankCode)
	s NotUseLockRegFlag=##class(DHCDoc.Interface.Outside.Config).GetConfigNode(GroupID,"NotUseLockReg",HospitalId)
	if (NotUseLockRegFlag=1){
		d ..SetOutputCode(.OutputObj,"-1001502","锁号功能未启用")
		q OutputObj	
	}
	s CheckRegTimeFlag=##class(DHCExternalService.RegInterface.RegManager).CheckRegTime(GroupID,HospitalId)
	i CheckRegTimeFlag=0{
		d ..SetOutputCode(.OutputObj,"-1001503","当前时间无法挂号.")
		q OutputObj	
	}
	
	s myPatientID=""
	if PatientNo'=""{
		 s myPatientID=$o(^PAPERi("PAPMI_PatNo",$ZCVT(PatientNo,"U"),""))
	}
	else{
		if PatientCard'=""{
			s CFRowid=0
			for {
				s CFRowid=$O(^DHCCARDi("CF",0,"CardNo",PatientCard,CFRowid)) Q:CFRowid=""
				s CFActive=$p(^DHCCARD("CF",CFRowid),"^",10)
				Continue:CFActive'="N"
				s CFCardTypeDR=$p(^DHCCARD("CF",CFRowid),"^",16)
				Continue:(CardType'="")&(CardType'=CFCardTypeDR)
				s myPatientID=$p(^DHCCARD("CF",CFRowid),"^",4)
			}
		}
	}
	if (ScheduleItemCode=""){
		d ..SetOutputCode(.OutputObj,"-1001504","排班记录标识不能为空")
		q OutputObj
	}
	if ($l(ScheduleItemCode,"||")'=2){
		d ..SetOutputCode(.OutputObj,"-1001505","排班ID格式不正确")
		q OutputObj
	}
	s ASDate=$P($G(^RBAS(+ScheduleItemCode,$p(ScheduleItemCode,"||",2))),"^",1) 
	if (+ASDate<+$h){
		d ..SetOutputCode(.OutputObj,"-1001506","不可挂出当日之前的排班")
		q OutputObj
	}
	;是否禁用提前挂号配置
	s NotAllowAppRegFlag=+(##class(DHCDoc.Interface.Outside.Config).GetConfigNode(GroupID,"AppReg",HospitalId))
	if (NotAllowAppRegFlag=1)&&(+ASDate'=..%SysDate()){
		d ..SetOutputCode(.OutputObj,"-1001507","不可挂出当日号之外的排班")
		q OutputObj
	}
	
	if '$d(^RBAS(+ScheduleItemCode,+$p(ScheduleItemCode,"||",2))){
		d ..SetOutputCode(.OutputObj,"-1001508","排班不存在")
		q OutputObj	
	}
	s ASStatusDR=$P($g(^RBAS(+ScheduleItemCode,$p(ScheduleItemCode,"||",2),"DHC")),"^",10)
	s ASTimeRangeFlag=$P($g(^RBAS(+ScheduleItemCode,$p(ScheduleItemCode,"||",2),"DHC")),"^",19)
	s ASStatus=$P($g(^DHCRBCASStatus(+ASStatusDR)),"^",1)
	if (ASStatus="S")||(ASStatus="TR")
	{
		d ..SetOutputCode(.OutputObj,"-1001509","排班已经停诊或替诊")
		q OutputObj
	}
	
	if (myPatientID=""){
    	d ..SetOutputCode(.OutputObj,"-1001510","指定有效患者信息")
		q OutputObj
	}
	
	s checkret=##class(DHCExternalService.RegInterface.RegManager).CheckBeforeReg(ScheduleItemCode,myPatientID,HospitalId)
	if (checkret'=""){
    	d ..SetOutputCode(.OutputObj,"-1001511",checkret)
		q OutputObj
	}
	
	s PatCatDr=$p(^PAPER(myPatientID,"PER",1),"^",10)
	s PatCatDesc=$p(^CT("SS",PatCatDr),"^",2)
	if (PatCatDr="")&&('$d(^CT("SS",PatCatDr))){
		d ..SetOutputCode(.OutputObj,"-1001512","您的患者类型有误,请前往窗口修改患者类型")
		q OutputObj
	}
	
	if $g(BillTypeID)'=""{
		if '$d(^PAC("ADMREA",BillTypeID)){
			d ..SetOutputCode(.OutputObj,"-1001514","HIS系统中未找到该就诊结算费别信息")
			q OutputObj
		}
		s DefaultBillType=BillTypeID
	}else{
		s DefaultBillType=##Class(web.DHCOPAdmReg).GetDefaultBillType(PatCatDr)
	}
	s InsuPatSelfPayRegFlag=+(##class(DHCDoc.Interface.Outside.Config).GetConfigNode(GroupID,"InsuPatSelfPayReg",HospitalId))
	s InsuRegFlag=+(##class(DHCDoc.Interface.Outside.Config).GetConfigNode(GroupID,"InsuReg",HospitalId))
	s InsurFlag=##class(web.DHCDocOrderCommon).GetInsurFlag(DefaultBillType)
	if InsuRegFlag=0{
		if (InsurFlag>0){
			if (InsuPatSelfPayRegFlag=0){
				d ..SetOutputCode(.OutputObj,"-1001515","目前不支持医保患者挂号，请到窗口挂号")
				q OutputObj
			}else{
				s SelfAdmReason=##class(DHCDoc.Interface.Outside.Config).GetConfigNode(GroupID,"SelfAdmReason",HospitalId)
				if (SelfAdmReason="")!(SelfAdmReason="0"){
					d ..SetOutputCode(.OutputObj,"-1001516","请联系管理员维护自费费别")
					q OutputObj
				}
				s DefaultBillType=SelfAdmReason
			}
		}
	}
	
	s PatientNo=##class(DHCExternalService.CardInterface.CardManager).PatientIDToNo(myPatientID)
	S AppRegMethodCode=""
	s AppRegMethodRowID=##class(DHCDoc.Interface.Outside.Config).GetConfigNode(GroupID,"AppRegMethod",HospitalId)
	if AppRegMethodRowID'="" s AppRegMethodCode=$P(^RBC("APTM",AppRegMethodRowID),"^",1)
	if AppRegMethodCode="" s AppRegMethodCode="WIN"
	s RegType=##CLass(web.DHCLockSchedule).GetAutoRegType(ScheduleItemCode)
	;s DefaultBillType=##Class(web.DHCOPAdmReg).GetDefaultBillType(PatCatDr)
	s AdmReason=+DefaultBillType
	s SessionTypeDr=$P($G(^RBAS(+ScheduleItemCode,+$p(ScheduleItemCode,"||",2),"DHC")),"^",6)
	s SessionTypeDesc=""
	i SessionTypeDr'="" s SessionTypeDesc=$P($G(^RBC("SESS",SessionTypeDr)),"^",2)
	s (InsuRegParaInfo,NoInsuRegParaReason,AdmReasonSource)=""
	s MRFee=0,CardFee=0
	s DocResValue=##Class(web.DHCOPAdmReg).GetMarkRegFee(ScheduleItemCode,AdmReason,myPatientID,AppRegMethodCode)
	s NoLimitLoadFlag=$p(DocResValue,"^",31)
	s RegFee=$p(DocResValue,"^",12)
	s CheckupFee=$p(DocResValue,"^",14)
	s HoliFee=+$p(DocResValue,"^",16)
	s AppFee=+$p(DocResValue,"^",18)
	s ReCheckFee=+$p(DocResValue,"^",15)
	s OtherFee=+$p(DocResValue,"^",20)
	s TotalFee=RegFee+CheckupFee+(+OtherFee)+(+ReCheckFee)+(+AppFee)+(+HoliFee) //总挂号费
	if NeedInsuRegData="Y"{
		s PayModeCode=##class(DHCExternalService.RegInterface.GetRelate).GetHisPayModeID(PayModeCode,BankCode)
		if PayModeCode=""{
			d ..SetOutputCode(.OutputObj,"-1001513","系统中未找到此支付方式.")
			q OutputObj
		}
		i PayModeCode'=""{
			s PayModeCode=$P(^CT("CTPM",PayModeCode),"^",1)
		}
	
		s InsuRegType=""
		s InsuJoinType=""
		s InsuJoinType="", FreeRegFeeFlag="", InsuReadCardInfo="", RetInsuGSInfo=""
		s AccRowId="",RegConDisId=""
		s InsuGHLY="20"
		s InsuDepDr=+$g(^RB("RES",+ScheduleItemCode))
		s InsuDocRowId=$P(^RB("RES",+ScheduleItemCode),"^",2)
		s PatientName=$p(^PAPER(myPatientID,"ALL"),"^",1)
		s TotalAmount=TotalFee
		s FeeStr=TotalAmount_"||"_CheckupFee_"||"_HoliFee_"||"_AppFee_"||"_MRFee_"||"_ReCheckFee_"||"_CardFee
		s ExpString=AccRowId_"^"_PayModeCode_"^"_GroupID_"^"_InsuGHLY_"^"_RegConDisId
		s InsuBillParaString=##class(web.DHCOPAdm).GetInsuBillPara(InsuDepDr,InsuDocRowId,myPatientID,PatientName,UserID, ScheduleItemCode, DefaultBillType,FeeStr,InsuRegType, InsuJoinType, FreeRegFeeFlag, InsuReadCardInfo , RetInsuGSInfo,ExpString)
		s InsuRegParaInfo=InsuBillParaString
		s AdmReasonSource=+$p($g(^PAC("ADMREA",DefaultBillType)),"^",9)
	}
	if TransactionId'=""{
		s HisTradeNo=TransactionId
	}else{
		s HisTradeNo=PayOrdId
	}
	;是否启用分时段
	s LockUseTimeRangeFlag=+(##class(DHCDoc.Interface.Outside.Config).GetConfigNode(GroupID,"LockUseTimeRange",HospitalId))
	s AllowAddRegFlag=+(##class(DHCDoc.Interface.Outside.Config).GetConfigNode(GroupID,"AllowAddReg",HospitalId))
	if AllowAddRegFlag'="1"{
		s AllowAddRegFlag="N"	
	}else{
		s AllowAddRegFlag="Y"		
	}
	
    //加入挂号的限额限制
    s EPMark=##class(web.DHCRBResource).GetEPMarkFlag(+ScheduleItemCode)
	i (EPMark'=1)
	{
		s LimitRet=##class(web.DHCOPAdmReg).CheckRegCountLimit(myPatientID,ScheduleItemCode,HospitalId)
		if (LimitRet'=0)
		{
			if LimitRet="-301" s ErrorMsg="超过每人每天挂号总数限额"
			else  if LimitRet="-302" s ErrorMsg="超过每人每天挂相同医生的号数限制"
			else  if LimitRet="-304" s ErrorMsg="超过每人该时段可挂号限额!不能进行挂号和预约."
			else  if LimitRet="-305" s ErrorMsg="超过每人该时段可挂相同科室限额!不能进行挂号和预约"
			else  s ErrorMsg=LimitRet
			d ..SetOutputCode(.OutputObj,"-1001517",ErrorMsg)
			q OutputObj
		}
		s LockLimitRet=##class(web.DHCLockSchedule).GetPADayLockCount(myPatientID,ScheduleItemCode,HospitalId)
		s LockSameASCount=$P(LockLimitRet,"^",3)	
		if +LockSameASCount>0 
		{
			s ErrorMsg="您有此科室医生待付费挂号记录,请付费!"
			d ..SetOutputCode(.OutputObj,"-1001518",ErrorMsg)
			q OutputObj
		}
	}
	TS
	if (LockQueueNo=""){
		;自动释放超时锁，已经在前面调用的##Class(web.DHCOPAdmReg).GetMarkRegFee方法中调用过
		if (LockUseTimeRangeFlag=1){
			if (ASTimeRangeFlag="Y")&&((BeginTime="")!(EndTime="")){
				TRO
				d ..SetOutputCode(.OutputObj,"-1001519","该排班存在分时段信息,请选择分时段信息")
				q OutputObj
			}
			s AdmitRange=BeginTime_"-"_EndTime
			if (ASTimeRangeFlag="Y")&&(BeginTime'="")&&(EndTime'=""){
				s CacheFlag=$$CheckLockCacheTime(ScheduleItemCode,BeginTime)
	            if CacheFlag=1{
		        	TRO
	    			d ..SetOutputCode(.OutputObj,"-1001520","该时段号源号已挂完")
					q OutputObj    
		        }
				s LockQueueNo=##class(web.DHCRBAppointment).GetSpecSeqNo(ScheduleItemCode,LockQueueNo,RegType,AppRegMethodCode,"",HospitalId,BeginTime,EndTime,AllowAddRegFlag,ClinicGroupDr)
				;if +LockQueueNo=0
				if ((NoLimitLoadFlag'="Y")&&(LockQueueNo=""))!(LockQueueNo="0")!(LockQueueNo="-1")
				{
	    			TRO
	    			s ^TEMPCTLS("CacheLockTime.TimeRange",ScheduleItemCode,BeginTime)=$H
	    			d ..SetOutputCode(.OutputObj,"-1001521","该时段号源号已挂完")
	    			q OutputObj
				}
			}
		}
		//若未获取到分时段信息,则按正常方式取号
        if +LockQueueNo=0 {
            s CacheFlag=$$CheckLockCacheTime(ScheduleItemCode)
            if CacheFlag=1{
	        	TRO
    			d ..SetOutputCode(.OutputObj,"-1001522","号已挂完")
				q OutputObj    
	        }
			s LockQueueNo=##class(web.DHCRBAppointment).GetSeqNo(ScheduleItemCode,RegType,AppRegMethodCode,"",HospitalId,AllowAddRegFlag,ClinicGroupDr)
			;if +LockQueueNo=0
			if ((NoLimitLoadFlag'="Y")&&(LockQueueNo=""))!(LockQueueNo="0")!(LockQueueNo="-1")
			{
    			TRO
    			s ^TEMPCTLS("CacheLockTime",ScheduleItemCode)=$H
    			d ..SetOutputCode(.OutputObj,"-1001523","号已挂完")
				q OutputObj
			}
		}
    }else{
		s LockQueueNo=##class(web.DHCRBAppointment).GetSpecSeqNo(ScheduleItemCode,LockQueueNo,RegType,AppRegMethodCode,"",HospitalId,BeginTime,EndTime,AllowAddRegFlag,ClinicGroupDr)
		;if +LockQueueNo=0
		if ((NoLimitLoadFlag'="Y")&&(LockQueueNo=""))!(LockQueueNo="0")!(LockQueueNo="-1")
		{
			TRO
			if LockUseTimeRangeFlag=1 d ..SetOutputCode(.OutputObj,"-1001513","该时段号已挂完")
			else  d ..SetOutputCode(.OutputObj,"-1001524","该挂号序号已失效")
			q OutputObj
		}    
	}
	
	s:HisTradeNo="" HisTradeNo=##class(web.DHCLockSchedule).SetLockTradeNo(PatientNo)
	s CurrData=..%SysDate()
	s CurrTime=..%SysTime()
	&sql(insert into SQLUser.CT_LockSchedule (CT_PatNo,CT_Schedule,CT_LockQueueNo,
				CT_UpdateDate,CT_UpdatTime,CT_UserID,CT_ActiveFlag,CT_HisTradeNo) values (:PatientNo,
				:ScheduleItemCode,:LockQueueNo,:CurrData,:CurrTime,:UserID,'Y',:HisTradeNo))
	if SQLCODE 
	{
		TRO
		d ..SetOutputCode(.OutputObj,"-1001525","锁号失败,稍后请再次尝试")
		q OutputObj
	}
	s OutputObj.ResultCode="0"
	s OutputObj.ResultContent="锁号成功"
	
	TC
	s OutputObj.TradeCode=TradeCode
	;s HisTradeNo=HisTradeNo_"$"_LockQueueNo
	s OutputObj.TransactionId=$g(HisTradeNo)
	s OutputObj.LockQueueNo=LockQueueNo
	s OutputObj.ScheduleItemCode=ScheduleItemCode
	s OutputObj.AdmDoc=SessionTypeDesc
	s AdmDate=$P(^RBAS(+ScheduleItemCode,+$p(ScheduleItemCode,"||",2)),"^",1)
	s AdmDate=$zd(AdmDate,3)
	s OutputObj.AdmDate=AdmDate
	s ASStartTime=$P($G(^RBAS(+ScheduleItemCode,+$p(ScheduleItemCode,"||",2))),"^",4) 
	s TimeRangeDr=$P($G(^RBAS(+ScheduleItemCode,+$p(ScheduleItemCode,"||",2),"DHC")),"^",17)  ;..GetTimeRangeByTime(ASStartTime)
	s TimeRange=""
	s:TimeRangeDr'="" TimeRange=$p(^DHCTimeRange(TimeRangeDr),"^",2)
	s OutputObj.AdmTime=TimeRange
	s OutputObj.RegFee=TotalFee
	s OutputObj.InsuRegParaInfo=InsuRegParaInfo
	s OutputObj.InsuAdmReasonSource=AdmReasonSource
    q OutputObj
CheckLockCacheTime(ScheduleID,BeginTime="")
	s LockCacheTime=+(##class(DHCDoc.Interface.Outside.Config).GetConfigNode(GroupID,"LockCacheTime",HospitalId))
	if LockCacheTime=0{
		s LockCacheTime=..#LockCacheTime	
	}
	s CacheFlag=0,CacheTime=""
	if BeginTime'=""{
		if $d(^TEMPCTLS("CacheLockTime.TimeRange",ScheduleID,BeginTime)){
	    	s CacheTime=^TEMPCTLS("CacheLockTime.TimeRange",ScheduleID,BeginTime) 
	    }
	}else{
		if $d(^TEMPCTLS("CacheLockTime",ScheduleID)){
	    	s CacheTime=^TEMPCTLS("CacheLockTime",ScheduleID) 
	    }
	}
	if CacheTime'=""{
		s DiffTime=(+$H-$p(CacheTime,",",1))*86400+($p($H,",",2)-$p(CacheTime,",",2))
    	if DiffTime<=LockCacheTime{
        	s CacheFlag=1
        }else{
	    	if BeginTime'=""{
		    	k ^TEMPCTLS("CacheLockTime.TimeRange",ScheduleID,BeginTime)  
	    	}else{
		    	k ^TEMPCTLS("CacheLockTime",ScheduleID)   
		    } 
	    }
	}
    ;将过期的排班缓存记录global kill掉
    s tmpStr="CacheLockTime^CacheLockTime.TimeRange"
    for loop=1:1:2{
	    s NodeName=$p(tmpStr,"^",loop)
	    if $d(^TEMPCTLS(NodeName)){
			s id=""
			for{
				s id=$o(^TEMPCTLS(NodeName,id))
				Q:id=""
				s ASDate=$P($G(^RBAS(+id,+$p(id,"||",2))),"^",1) 
				if (+ASDate<+$H){
					k ^TEMPCTLS(NodeName,id)   	
				}
			}    
		}
    }
    Q CacheFlag
LockOrderErr
	if $TLEVEL>0{
    	TRO
	}
	s OutputObj=..GetOutputObj("10015")
	d ..SetOutputCode(.OutputObj,"-1","LockOrder调用异常"_$TR($TR($ZE,"<","!!"),">","!!"))
    q OutputObj
}

/// w ##class(DHCExternalService.RegInterface.SelfRegMethods).UnLockOrder(^TMPSelfRegXML("Request","UnLockOrderErr"))
ClassMethod UnLockOrder(XMLRequest As %String) As DHCExternalService.RegInterface.Entity.SelfReg.LockOrderRp
{
	s $ZTRAP="UnLockOrderErr"
	s ^TMPSelfRegXML("Request","UnLockOrderErr")=XMLRequest
	s InputObj=..GetInputObj("10015",XMLRequest)
	s ClientType=InputObj.ClientType
	s ExtUserID=InputObj.ExtUserID
	s ScheduleItemCode=InputObj.ScheduleItemCode
	s PatientCard=InputObj.CardNo
	s CardType=InputObj.CardType
	s LockQueueNo=InputObj.LockQueueNo
	s PatientNo=InputObj.PatientID
	s TradeCode=InputObj.TradeCode
	s TransactionId=InputObj.TransactionId
	s PayOrdId=InputObj.PayOrderId 
	s HospitalId=InputObj.HospitalId
	
	if TransactionId'=""{
		s HisTradeNo=TransactionId
	}else{
		s HisTradeNo=PayOrdId
	}
	if HisTradeNo'=""{
		s CTLSRowID=$o(^CTLS(0,"HISTradNo",HisTradeNo,""),-1)
		if CTLSRowID'=""{
			s LockScheduleItemCode=$p(^CTLS(CTLSRowID),"^",2)
			if ScheduleItemCode="" s ScheduleItemCode=LockScheduleItemCode
			s AdmDepId=$P($G(^RB("RES",+ScheduleItemCode)),"^",1)
			s AdmDepHospId=$p(^CTLOC(AdmDepId),"^",22)
		}
	}
	s HospitalId=##class(DHCExternalService.RegInterface.GetRelate).GetHISHospitalIdFromOuterCode(HospitalId,$case(HospitalId,"":ScheduleItemCode,:""))
	s OutputObj=..GetOutputObj("10015")	
	if HospitalId=""{
		d ..SetOutputCode(.OutputObj,"-100","请传入正确的院区代码.")
		quit OutputObj	
	}
	if (HospitalId'=AdmDepHospId)&&($g(AdmDepHospId)) {
		d ..SetOutputCode(.OutputObj,"-100","非当前院区的订单，不能操作！")
		quit OutputObj
	}
	s UserID=##class(DHCExternalService.RegInterface.GetRelate).GetUser(ExtUserID,"",HospitalId)
	if (UserID=""){
    	d ..SetOutputCode(.OutputObj,"-1001604","请传入正确的操作用户.")
		q OutputObj
	}
	s GroupID=##class(DHCExternalService.RegInterface.GetRelate).GetGroup(UserID)
	s BankCode=##class(DHCDoc.Interface.Outside.Config).GetConfigNode(GroupID,"DataCompareExtOrg",HospitalId)
	s CardType=##class(DHCExternalService.RegInterface.GetRelate).GetHisCardTypeID(CardType,BankCode)
	s myPatientID=""
	if HisTradeNo'=""{
		s CTLSRowID=$o(^CTLS(0,"HISTradNo",HisTradeNo,""),-1)
		if CTLSRowID'=""{
			s HISAdmDr=$p(^CTLS(CTLSRowID),"^",9)
			if HISAdmDr'=""{
				d ..SetOutputCode(.OutputObj,"-1001601","该订单已挂号支付,无法取消锁号")
				q OutputObj	
			}
			s LockScheduleItemCode=$p(^CTLS(CTLSRowID),"^",2)
			s QueueNo=$p(^CTLS(CTLSRowID),"^",3)
			s LockPatientNo=$p(^CTLS(CTLSRowID),"^",1)
			i LockQueueNo="" s LockQueueNo=QueueNo
			i ScheduleItemCode="" s ScheduleItemCode=LockScheduleItemCode
			i PatientNo="" s PatientNo=LockPatientNo
		}else{
			d ..SetOutputCode(.OutputObj,"-1001601","该订单已失效")
			q OutputObj
		}
	}
	if PatientNo'=""{
		s myPatientID=$o(^PAPERi("PAPMI_PatNo",$ZCVT(PatientNo,"U"),""))
	}elseif PatientCard'=""{
		s myPatientID=..getPatIDByCardInfo(CardType,PatientCard)
	}
	
	if (myPatientID=""){
    	d ..SetOutputCode(.OutputObj,"-1001605","指定有效患者信息")
		q OutputObj
	}
	s PatientNo=##class(DHCExternalService.CardInterface.CardManager).PatientIDToNo(myPatientID)

	if (ScheduleItemCode=""){
		d ..SetOutputCode(.OutputObj,"-1001602","排班记录标识不能为空")
		q OutputObj
	}
	if ($l(ScheduleItemCode,"||")'=2){
		d ..SetOutputCode(.OutputObj,"-1001603","排班ID格式不正确")
		q OutputObj
	}
	
	if (LockQueueNo=""){
		;d ..SetOutputCode(.OutputObj,"-1001606","取消订单时,顺序号不得为空")
		;q OutputObj
	}
	b //取消锁号
	;TS
	d ##class(web.DHCLockSchedule).UnLockSchedule(ScheduleItemCode,PatientNo,LockQueueNo,"",HisTradeNo)
	s OutputObj.ResultCode="0"
	s OutputObj.ResultContent="取消订单成功"
	;TC
	s OutputObj.TradeCode=TradeCode
    q OutputObj
UnLockOrderErr
	s OutputObj=..GetOutputObj("10015")
	d ..SetOutputCode(.OutputObj,"-10016","UnLockOrder调用异常"_$TR($TR($ZE,"<","!!"),">","!!"))
    q OutputObj
}

/// w ##Class(DHCExternalService.RegInterface.SelfRegMethods).GetTimeRangeByTime("23400")
ClassMethod GetTimeRangeByTime(SessTime As %String = "") As %String
{
	
	 S TimeRangStr=..GetTimeRangeStrByTime(SessTime)
	 s RangeLong=$L(TimeRangStr,"!")
	 for i=1:1:RangeLong
	 {
		 s RangeID=$P(TimeRangStr,"!",i)
		 continue:RangeID=""
		 s StartTime=$P(^DHCTimeRange(RangeID),"^",3)
		 s EndTime=$P(^DHCTimeRange(RangeID),"^",4)
		 s sub=(EndTime-StartTime)
		 s TempTimRang(sub)=RangeID
	 }
	 s myTimeRangeID=""
	 s SubID=$O(TempTimRang(0))
	 i SubID'="" s myTimeRangeID=$G(TempTimRang(SubID))
	 Q myTimeRangeID
}

/// creater	lxz
/// desc     通过时间点获取包含当前时间点的所有时段
/// w ##class(web.DHCRBApptSchedule).GetTimeRangeStrByTime(28800)
ClassMethod GetTimeRangeStrByTime(TimInput As %String = "") As %String
{
	s ret=""
	if TimInput=""  s TimInput=..%SysTime()
	s TRRowId=0  f  s TRRowId=$O(^DHCTimeRange(TRRowId)) Q:(TRRowId="")  d
	.s StartTime=$P(^DHCTimeRange(TRRowId),"^",3)
	.s EndTime=$P(^DHCTimeRange(TRRowId),"^",4)
	.s UseStDate=$P(^DHCTimeRange(TRRowId),"^",7)
	.Q:(UseStDate>+$H)&&(UseStDate'="")
	.s UseEndDate=$P(^DHCTimeRange(TRRowId),"^",8)
	.Q:(UseEndDate<+$H)&&(UseEndDate'="")
	.i (TimInput>=StartTime)&&(TimInput<EndTime) d
	..if ret="" s ret=TRRowId
	..else  s ret=ret_"!"_TRRowId
	Q ret
}

/// W ##Class(DHCExternalService.RegInterface.SelfRegMethods).OPRegister("<Request><TradeCode>1101</TradeCode><TransactionId></TransactionId><ExtOrgCode></ExtOrgCode><ClientType></ClientType><HospitalId></HospitalId><TerminalID></TerminalID><ScheduleItemCode>1956||2310</ScheduleItemCode><ExtUserID>zz001</ExtUserID><PatientCard></PatientCard><QueueNo>2</QueueNo><CardType></CardType><PatientID>00326006</PatientID><PayBankCode></PayBankCode><PayCardNo></PayCardNo><PayModeCode>1</PayModeCode><PayFee>10</PayFee><PayInsuFeeStr></PayInsuFeeStr><PayTradeNo></PayTradeNo><PayOrderId>Z700120131001190947</PayOrderId></Request>")
/// W ##Class(DHCExternalService.RegInterface.SelfRegMethods).OPRegister(^TMPSelfRegXML("Request","OPRegister"))
ClassMethod OPRegister(XMLRequest As %String) As DHCExternalService.RegInterface.Entity.SelfReg.OPRegisterRp
{
	s ^TMPSelfRegXML("Request","OPRegister")=XMLRequest
	s $ZTRAP="OPRegisterErr"
	;DHCExternalService.RegInterface.Entity.SelfReg.OPRegisterRq
	s InputObj=..GetInputObj("1101",XMLRequest)
	s TransactionId=InputObj.TransactionId
	s TerminalID=InputObj.TerminalID
	s ScheduleItemCode=InputObj.ScheduleItemCode
	s PatientCard=InputObj.PatientCard
	s CardType=InputObj.CardType
	s PatientID=InputObj.PatientID
	s PayBankCode=InputObj.PayBankCode
	s PayCardNo=InputObj.PayCardNo
	s PayModeCode=InputObj.PayModeCode
	s PayFee=InputObj.PayFee
	s InsertQueueNo=InputObj.QueueNo
	s PayInsuFeeStr=InputObj.PayInsuFeeStr
	s PayTradeNo=InputObj.PayTradeNo
	s BankTradeInfo=InputObj.BankTradeInfo
	s PayMRBookFlag=InputObj.PayMRBookFlag
	s PayOrderId=InputObj.PayOrderId
	s BillTypeID=InputObj.BillTypeID 
	s PayTime=InputObj.PayTime
	s AppOrderCode=InputObj.AppOrderCode ;预约取号ID
	;支付宝、微信挂号银行支付信息
	s PayDetailsObj=##class(DHCBILL.SelfPay.Entity.CompleteCharge.Req.PayDetails).%New()
    s PayDetailsObj=InputObj.PayDetails
	s HospitalId=InputObj.HospitalId
	s HospitalId=##class(DHCExternalService.RegInterface.GetRelate).GetHISHospitalIdFromOuterCode(HospitalId) 
	s ClinicGroupDr=InputObj.ClinicGroupDr
	s ApptTypeCode=InputObj.ExtOrgCode ;预约机构->预约渠道
	s OutputObj=..GetOutputObj("1101")
	s OutputObj.ResultCode="0"
	s OutputObj.ResultContent=""
	if HospitalId=""{
		d ..SetOutputCode(.OutputObj,"-100","请传入正确的院区代码.")
		quit OutputObj	
	}
	
	s UserID=##class(DHCExternalService.RegInterface.GetRelate).GetUser(InputObj.ExtUserID,"",HospitalId)
	if UserID=""{
		d ..SetOutputCode(.OutputObj,"-110101","请传入正确的系统操作用户.")
		q OutputObj
	}
	
	if PatientID=""{
		if (PatientCard="") {
			d ..SetOutputCode(.OutputObj,"-110102","患者卡号不能都为空.")
			q OutputObj
		}
		if (CardType=""){
			d ..SetOutputCode(.OutputObj,"-110103","卡类型不能都为空.")
			q OutputObj
		}
	}
	if (PatientID'="")
	{
		set PatientID=$Order(^PAPERi("PAPMI_PatNo",PatientID,0))
		if PatientID=""{
			d ..SetOutputCode(.OutputObj,"-110106","患者ID不存在")
			q OutputObj
		}
	}else
	{
		s PatientID=..getPatIDByCardInfo(CardType,PatientCard)
		if (PatientID)=""{
			d ..SetOutputCode(.OutputObj,"-110106","系统中未找到此卡号.")
			q OutputObj
		}
	}
	s PatNo=$p(^PAPER(PatientID,"PAT",1),"^",1)
	
	s GroupID=##class(DHCExternalService.RegInterface.GetRelate).GetGroup(UserID)
	s BankCode=##class(DHCDoc.Interface.Outside.Config).GetConfigNode(GroupID,"DataCompareExtOrg",HospitalId)
	s CardType=##class(DHCExternalService.RegInterface.GetRelate).GetHisCardTypeID(CardType,BankCode,"",HospitalId)
	;将取号接口与挂号接口合并，取号时无需判断锁号状态，也无需调用锁号
	if AppOrderCode=""{
		;锁号需加控制Start2016-09-09
		;是否启用挂号锁号配置
		s NotUseLockRegFlag=##class(DHCDoc.Interface.Outside.Config).GetConfigNode(GroupID,"NotUseLockReg",HospitalId)
		if (NotUseLockRegFlag'=1){
			;如果移动订单号由第三方生成，则这里的HISTradNo为第三方生成的订单号
			;实际PayOrderId已弃用
			if (PayOrderId="")&&(TransactionId="")
			{
				d ..SetOutputCode(.OutputObj,"-110101","订单不能为空")
				q OutputObj
			}
			if (TransactionId=""){
				s TransactionId=PayOrderId
			}
			;增加00:00:30 的时长 验证订单后再完成挂号前保持订单有效 防止刚验证完有效后订单就超时的并发造成重号
			s QueueNoActive=##class(web.DHCLockSchedule).CheckQueueNoActive(TransactionId,"","",PatNo,HospitalId,"00:00:30")
			b ;QueueNoActive
			s QueueNoActiveFlag=$p(QueueNoActive,"^",1)
			s QueueNoActiveStr=$p(QueueNoActive,"^",2)
			if QueueNoActiveFlag'=1{
				if (QueueNoActiveFlag="Reg"){
					d ..SetOutputCode(.OutputObj,"-110227","该号已支付,请尝试重新生成订单.")
					q OutputObj		
				}elseif (QueueNoActiveFlag="OutActiveTime"){
					d ..SetOutputCode(.OutputObj,"-110227","该号超时未支付,已被系统自动失效,请尝试重新生成订单.")
					q OutputObj		
				}elseif (QueueNoActiveFlag="NotSamePerson"){
					d ..SetOutputCode(.OutputObj,"-110227","该号已被他人锁定,请尝试重新生成订单.")
					q OutputObj		
				}elseif (QueueNoActiveFlag="-100"){
					d ..SetOutputCode(.OutputObj,"-110227","订单在系统中不存在,请尝试重新生成订单.")
					q OutputObj		
				}elseif (QueueNoActiveFlag="-101"){
					d ..SetOutputCode(.OutputObj,"-110227","锁号错误,排班信息为空,请尝试重新生成订单.")
					q OutputObj		
				}elseif (QueueNoActiveFlag="-102"){
					d ..SetOutputCode(.OutputObj,"-110227","锁号错误,锁定序号为空,请尝试重新生成订单.")
					q OutputObj		
				}elseif(QueueNoActiveFlag="NotCurHosp"){
					d ..SetOutputCode(.OutputObj,"-110227","非当前院区的订单，不能操作.")
					q OutputObj
				}else{
					d ..SetOutputCode(.OutputObj,"-110227","该订单已失效,请尝试重新生成订单")
					q OutputObj		
				}
			}else{
				s ScheduleItemCode=$p(QueueNoActiveStr,"!",1)
				s InsertQueueNo=$p(QueueNoActiveStr,"!",2)
				i PatientID="" s PatientID=$p(QueueNoActiveStr,"!",3)
			}
		}else{
			s CheckRegTimeFlag=##class(DHCExternalService.RegInterface.RegManager).CheckRegTime(GroupID,HospitalId)
			i CheckRegTimeFlag=0{
				d ..SetOutputCode(.OutputObj,"-110101","当前时间无法挂号.")
				q OutputObj	
			}
		}
		;b ;锁号需加控制End
	}else{
		s NotUseLockRegFlag=1
		if +$l(AppOrderCode,"||")'=3{
			d ..SetOutputCode(.OutputObj,"-110130","预约取号ID传入格式不正确")
			q OutputObj	
		}
		Set RBAppTobject =##class(User.RBAppointment).%OpenId(AppOrderCode)
		if '$IsObject(RBAppTobject){
			d ..SetOutputCode(.OutputObj,"-110131","不存在预约记录.")
			q OutputObj
		}
		s APPTStatus=RBAppTobject.APPTStatus
		s APPTPatientDr=RBAppTobject.APPTPAPMIDRGetObjectId()
		s APPTSeqNo=RBAppTobject.APPTQueueNo
		d RBAppTobject.%Close()
		if (APPTStatus'="I"){
			s APPTStatus=$s(APPTStatus="A":"已取号",APPTStatus="X":"已取消",APPTStatus="J":"已违约",1:"预约状态异常")
			d ..SetOutputCode(.OutputObj,"-110132",APPTStatus)
			q OutputObj
		}
		s CommonPatientID=##class(web.DHCOPAdmReg).GetCommonPatientID("",HospitalId)
		if (CommonPatientID'=""){
			s CommonPatientID="^"_CommonPatientID_"^"
			if (CommonPatientID'[("^"_APPTPatientDr_"^"))&&(APPTPatientDr'=PatientID){
				d ..SetOutputCode(.OutputObj,"-110133","非公共卡预约只能本人取号")
				q OutputObj
			}
		}
		set AdvanceAppAdm=##class(web.DHCOPRegConfig).GetSpecConfigNode("AdvanceAppAdm",HospitalId) //是否可以提前取预约号
		
		s ScheduleItemCode=$p(AppOrderCode,"||",1,2)
	  	s RBASStatusDr=$P(^RBAS(+ScheduleItemCode,$P(ScheduleItemCode,"||",2),"DHC"),"^",10)
	  	s RBASDate=$P($G(^RBAS(+ScheduleItemCode,$p(ScheduleItemCode,"||",2))),"^",1) 
	  	if (AdvanceAppAdm'=1)&&(RBASDate>+$h){
			d ..SetOutputCode(.OutputObj,"-110133","不允许提前取号,请在就诊当日取号")
			q OutputObj	
		}
	 	s RBASStatusCode=$P(^DHCRBCASStatus(RBASStatusDr),"^",1)
	 	if (RBASStatusCode="S") {
		 	d ..SetOutputCode(.OutputObj,"-110134","此排班已停诊.")
			q OutputObj
	 	}
	 	s TRRBASRowId=""
	 	i (RBASStatusCode="TR"){
	 		s TRRBASRowId=$P(^RBAS(+ScheduleItemCode,$P(ScheduleItemCode,"||",2),"DHC"),"^",12)
	 	}
	 	;如果有替诊则取替诊的信息
		i $G(TRRBASRowId)'="" s ScheduleItemCode=TRRBASRowId
		s InsertQueueNo=APPTSeqNo
		i PatientID="" s PatientID=APPTPatientDr
	}
	
	if ScheduleItemCode="" {
		d ..SetOutputCode(.OutputObj,"-110134","排班记录标识不能为空.")
		q OutputObj
	}
	
	if PayModeCode=""{
		d ..SetOutputCode(.OutputObj,"-110135","支付方式不能都为空.")
		q OutputObj
	}
	if PayFee=""{
		d ..SetOutputCode(.OutputObj,"-110136","挂号费不能都为空.")
		q OutputObj
	}
	
	s RBAS=ScheduleItemCode
	s Patient=PatientID   //_"^N"
	s checkret=##class(DHCExternalService.RegInterface.RegManager).CheckBeforeReg(ScheduleItemCode,PatientID,HospitalId)
	if (checkret'=""){
    	d ..SetOutputCode(.OutputObj,"-110137",checkret)
		q OutputObj
	}
	s ASDate=$P($G(^RBAS(+RBAS,$p(RBAS,"||",2))),"^",1) 
	if (+ASDate<+$h){
		d ..SetOutputCode(.OutputObj,"-110138","不可挂出当日之前的排班")
		q OutputObj
	}
	s CurrDate=..%SysDate()
	s NotAllowAppRegFlag=+(##class(DHCDoc.Interface.Outside.Config).GetConfigNode(GroupID,"AppReg",HospitalId))
	if (AppOrderCode="")&&(NotAllowAppRegFlag=1)&&(+ASDate'=CurrDate){
		d ..SetOutputCode(.OutputObj,"-110139","不可挂出当日号之外的排班")
		q OutputObj
	}
	if (+ASDate>CurrDate){
		if ApptTypeCode=""{
			d ..SetOutputCode(.OutputObj,"-110140","请传入预约渠道.")
			q OutputObj	
		}else{
			s ApptTypeID=##class(web.DHCRBAppointment).GetApptTypeByCode(ApptTypeCode)
			if ApptTypeID=""{
				d ..SetOutputCode(.OutputObj,"-110141","系统中未获取到相应的预约渠道信息.")
				q OutputObj		
			}
		}
	}
	
	s PatCatDr=$p(^PAPER(PatientID,"PER",1),"^",10)
	s PatCatDesc=$p(^CT("SS",PatCatDr),"^",2)
	
	if $g(BillTypeID)'=""{
		if '$d(^PAC("ADMREA",BillTypeID)){
			d ..SetOutputCode(.OutputObj,"-110142","HIS系统中未找到该就诊结算费别信息")
			q OutputObj
		}
		s DefaultBillType=BillTypeID
	}else{
		s DefaultBillType=##Class(web.DHCOPAdmReg).GetDefaultBillType(PatCatDr)
	}
	s InsuPatSelfPayRegFlag=+(##class(DHCDoc.Interface.Outside.Config).GetConfigNode(GroupID,"InsuPatSelfPayReg",HospitalId))
	s InsurFlag=##class(web.DHCDocOrderCommon).GetInsurFlag(DefaultBillType)
	s InsuRegFlag=+(##class(DHCDoc.Interface.Outside.Config).GetConfigNode(GroupID,"InsuReg",HospitalId))
	if InsuRegFlag=0{
		if (InsurFlag>0){
			if (InsuPatSelfPayRegFlag=0){
				d ..SetOutputCode(.OutputObj,"-110143","目前不支持医保患者挂号，请到窗口挂号")
				q OutputObj
			}else{
				s SelfAdmReason=(##class(DHCDoc.Interface.Outside.Config).GetConfigNode(GroupID,"SelfAdmReason",HospitalId))
				if (SelfAdmReason="")!(SelfAdmReason="0"){
					d ..SetOutputCode(.OutputObj,"-110144","请联系管理员维护自费费别")
					q OutputObj
				}
				s DefaultBillType=SelfAdmReason
			}
			
		}
	}
	set AdmReason=DefaultBillType
	if (AdmReason="") set AdmReason=##Class(DHCExternalService.RegInterface.GetRelate).GetAdmReason(HospitalId)
	S AppRegMethodCode=""
	s AppRegMethodRowID=##class(DHCDoc.Interface.Outside.Config).GetConfigNode(GroupID,"AppRegMethod",HospitalId)
	if AppRegMethodRowID'="" s AppRegMethodCode=$P(^RBC("APTM",AppRegMethodRowID),"^",1)
	if AppRegMethodCode="" s AppRegMethodCode="WIN"
	s DocResValue=##Class(web.DHCOPAdmReg).GetMarkRegFee(RBAS,DefaultBillType,PatientID,AppRegMethodCode)
	s TotalFee=$p(DocResValue,"^",12)	//1
	s CheckFee=$p(DocResValue,"^",14)  //2
	s HoliFee=$p(DocResValue,"^",16)  //3
	s AppFee=$p(DocResValue,"^",18)   //4
	s ReCheckFee=$p(DocResValue,"^",15)  //6
	s OtherFee=$p(DocResValue,"^",20)  //6
	s TotalFee=(+TotalFee)+(+CheckFee)+(+HoliFee)+(+AppFee)+(+ReCheckFee)+(+OtherFee) //总挂号费
	if (+TotalFee'=+PayFee)
	{
		d ..SetOutputCode(.OutputObj,"-110145","总费用金额错误")
		q OutputObj
	}
	
	s FeeStr=TotalFee_"||"_CheckFee_"||"_HoliFee_"||"_AppFee_"||0||"_ReCheckFee_"||0"
	if (PayMRBookFlag="1")
	{
		s FeeStr=TotalFee_"||"_CheckFee_"||"_HoliFee_"||"_AppFee_"||1||"_ReCheckFee_"||0"
	}
	s PayModeID=##class(DHCExternalService.RegInterface.GetRelate).GetHisPayModeID(PayModeCode,BankCode)
	if PayModeID=""{
		d ..SetOutputCode(.OutputObj,"-110146","系统中未找到此支付方式.")
		q OutputObj
	}
	i PayModeID'=""{
		s PayModeCode=$P(^CT("CTPM",PayModeID),"^",1)
	}
	s AccInfo=##class(DHCExternalService.RegInterface.RegManager).getaccinfofromcardno(PatientCard,"0")
	s AccRowId=$piece(AccInfo,"^",2)
	s GroupID=##class(DHCExternalService.RegInterface.GetRelate).GetGroup(UserID)
	s AdmDep=$p($g(^RB("RES",+RBAS)),"^",1)
	s ret=##class(web.DHCOPAdmReg).IsEmergency(AdmDep)
	s:(+ret=0) AdmType="O"
	s:(+ret=1) AdmType="E"
	s Left=$piece(AccInfo,"^",4)
	s CashPay=0
	if (PayInsuFeeStr'=""){
		s PayInsuStr=$p(PayInsuFeeStr,"!",2)
		s Length=$Length(PayInsuStr,$c(2))
		f i=1:1:Length
		{
			s Str=$p(PayInsuStr,$c(2),i)
			s InsuPayMode=$p(Str,"^",1)
			i (InsuPayMode="1"){
				s CashPay=$p(Str,"^",2)
			}
		}
	}
	else{
		s CashPay=PayFee
	}
	if (Left<CashPay)&&(PayModeCode="CPP"){
		d ..SetOutputCode(.OutputObj,"-110147","卡余额不足,请充值.")
		q OutputObj
	}

	s TabFreeRegFlag=""
	s TabFreeCheckFlag=""
	s InsuJoinStr=InputObj.PayInsuFeeStr	;医保挂号返回信息串，需与HIS窗口医保挂号返回串字段顺序严格一致。
	s DiagnosCatRowId="" ;$p(InsuJoinStr,"^",3)
	s DiscountFactor=""
	;PayBankCode	银行代码
	;PayCardNo	银行卡卡号
	;PayFee	支付费用
	;TransactionId 交易流水号
	;根据银医卡接口需要确定如下四个参数如何使用
	;号源平台传过来的费用和his计算费用的比较
	s PayBankCode=InputObj.PayBankCode
	s PayCardNo=InputObj.PayCardNo
	s PayFee=InputObj.PayFee
	s TransactionId=InputObj.TransactionId
	
	s SourceType=""
	if (NotUseLockRegFlag'=1){
		s SourceType="LOCK"
	}
	
	TS
	s TradeType="OP"
	s TExpstr=UserID_"^"_GroupID_"^"_""_"^"_HospitalId_"^"_TerminalID_"^"_TradeType_"^"_Patient
	s myRet=##class(DHCExternalService.RegInterface.RegManager).SavePayInfoNew(PatientCard,PayModeID,PayFee,.PayDetailsObj,TExpstr)
	if $P(myRet,"^",1)'=0{
		TRO
		d ..SetOutputCode(.OutputObj,$P(myRet,"^",1),$P(myRet,"^",2))
		q OutputObj
	}
	s ETPRowID=$P(myRet,"^",2)
	s TradeID=$P(myRet,"^",3)
	s RegExpStr="^^"_ClinicGroupDr_"^"_ApptTypeCode
	///PatientID , ASRowId , AdmReason , QueueNo , FeeStr , PayModeCode , AccRowId , user , group , AdmType , DiagnosCatRowId , FreeRegFlag , FreeCheckFlag , ByRef RegfeeRowId , InsuJoinStr , DiscountFactor , TAPPTRowID , UnBillFlag , TabPCLRowID , ApptMethodCode , SourceType , RegConDisId 
	s ret=##class(web.DHCOPAdmReg).OPRegistBroker(Patient,RBAS,AdmReason,InsertQueueNo,FeeStr,PayModeCode,AccRowId,UserID,GroupID,AdmType,DiagnosCatRowId,TabFreeRegFlag,TabFreeCheckFlag,"",InsuJoinStr,DiscountFactor,AppOrderCode,"","",AppRegMethodCode,SourceType,"",HospitalId,ETPRowID,"","SERV",RegExpStr)
	;OPRegistBroker OK
	s retFlag=$P(ret,"$",1)
	i (retFlag'=0){
		s errmsg=""
		if retFlag="-201"{
			s errmsg="生成就诊记录失败!"
		}elseif retFlag="-202"{
			s errmsg="取号不成功!"
		}elseif retFlag="-2121"{
			s errmsg="更新预约状态失败"
		}elseif retFlag="-2122"{
			s errmsg="系统繁忙"
		}elseif retFlag="-206"{
			s errmsg="插入挂号费医嘱失败!"
		}elseif retFlag="-207"{
			s errmsg="插入诊查费医嘱失败!"
		}elseif retFlag="-208"{
			s errmsg="插入假日费医嘱失败!"
		}elseif retFlag="-209"{
			s errmsg="插入预约费医嘱失败!"
		}elseif retFlag="-210"{
			s errmsg="计费失败"
		}elseif retFlag="-211"{
			s errmsg="插入挂号记录失败!"
		}elseif retFlag="-212"{
			s errmsg="插入叫号队列失败!"
		}elseif retFlag="-301"{
			s errmsg="超过每人每天可挂限额,不能再挂号或预约!"
		}elseif retFlag="-302"{
			s errmsg="超过每人每天可挂相同号的限额!"
		}elseif retFlag="-303"{
			s errmsg="超过每人每天可挂相同科室号的限额!"
		}elseif retFlag="-304"{
			s errmsg="超过每人每天相同时段同科室同医生限额!"
		}elseif retFlag="-401"{
			s errmsg="还未到达规定的挂号时间"
		}elseif retFlag="-402"{
			s errmsg="还未到达预约时间"
		}elseif retFlag="-403"{
			s errmsg="还未到达加号的时间"
		}elseif retFlag="-404"{
			s errmsg="已经过了此排班记录出诊时间点!"
		}elseif retFlag="-405"{
			s errmsg="请去挂号设置界面维护免费医嘱!"
		}elseif retFlag="-406"{
			s errmsg="已过挂号结束时间!"
		}elseif retFlag="-2010"{
			s errmsg="更新医保挂号信息失败!"
		}elseif retFlag="-213"{
			s errmsg="已经开启停止挂号,不予许挂号及取号!"
		}elseif retFlag="-214"{
			s errmsg="没有需要结算的医嘱，请核实是否关联级别费用或维护挂号免费医嘱!"
		}elseif retFlag[","{
			s errmsg=$p(retFlag,",",2,$l(retFlag,","))
			s retFlag=$p(retFlag,",",1)
		}else{
			
		}
		s errmsg=retFlag_"-挂号失败:"_errmsg
		TRO
		d ..SetOutputCode(.OutputObj,"-110120",errmsg)
		q OutputObj
	}
	
	s RegInfoStr=$P(ret,"$",2)
	d ##Class(DHCDoc.Util.FromJSON).FromJSONToArr(RegInfoStr,.RegInfoArr)
	s AdmDr=""
	s RegOrderFee=""
	if $d(RegInfoArr){
		s AdmDr=RegInfoArr(1,"AdmNo")
		s RegOrderFee=RegInfoArr(1,"Total")
	}
	S RegFeeRowId=$O(^User.DHCRegistrationFeeI("ADM",AdmDr,""))
	s myCTLSRowID=""
	if TransactionId'=""{
		s myCTLSRowID=$o(^CTLS(0,"HISTradNo",TransactionId,""),-1)
	}elseif (InsertQueueNo'=""){
		s LockRowID=0
		for {
			s LockRowID=$o(^CTLS(0,"SchedulePatNo",RBAS,PatNo,LockRowID),-1)
			q:LockRowID=""
			s LockQueueNo=$p(^CTLS(LockRowID),"^",3)
			continue:InsertQueueNo'=LockQueueNo
			s HISAdmDr=$p(^CTLS(LockRowID),"^",9)
			continue:HISAdmDr'=""	//已付费了,这种情况应该只有p5的版本会出现吧	
			s myCTLSRowID=LockRowID
			Q:myCTLSRowID'=""
		}
	}
	if (myCTLSRowID'=""){
		&sql(update SQLUser.CT_LockSchedule Set CT_HISAdmDr=:AdmDr
         where CT_LSRowID=:myCTLSRowID
		)
	}
	TC
	s OutputObj.ResultCode="0"
	s OutputObj.ResultContent="挂号成功"
	if $d(RegInfoArr){
		s SeqCode=RegInfoArr(1,"SeqNo")
		s RegFee=RegInfoArr(1,"RegFee")
		s CheckFee=RegInfoArr(1,"OtherFee")+RegInfoArr(1,"AppFee")
		s TotalFee=+($tr(RegInfoArr(1,"Total")," ",""))
		s TotalRMBDX=RegInfoArr(1,"TotalRMBDX")
		s AdmitRange=RegInfoArr(1,"TimeRangeInfo")
		s DeptName=RegInfoArr(1,"RegDep")
		s DoctorName=RegInfoArr(1,"DocDesc")
		s DoctorLevelDesc=RegInfoArr(1,"SessionType")
		s ReceiptNo=RegInfoArr(1,"INVPRTNo")
		s RegistrationID=RegInfoArr(1,"RegfeeRowId")
		s TimeRange=RegInfoArr(1,"TimeRange")
		s OutputObj.SeqCode=SeqCode
		s OutputObj.RegFee=RegFee
		s OutputObj.CheckFee=CheckFee
		s OutputObj.TotalFee=TotalFee
		s OutputObj.TotalRMBDX=TotalRMBDX
		s OutputObj.AdmitRange=AdmitRange
		s OutputObj.AdmitAddress=##class(DHCExternalService.RegInterface.SynVisitSchedule).GetAdmitAddress(RBAS)
		s OutputObj.TransactionId=TransactionId
		s OutputObj.HisTradeOrderId=TradeID
		s OutputObj.PayOrderId=PayOrderId
		s OutputObj.AdmNo=AdmDr
		s OutputObj.DeptCode=""
		s OutputObj.DeptName=DeptName
		s OutputObj.DoctorCode=""
		s OutputObj.DoctorName=DoctorName
		s OutputObj.DoctorLevelCode=""
		s OutputObj.DoctorLevelDesc=DoctorLevelDesc
		s OutputObj.ReceiptNo=ReceiptNo
		s OutputObj.RegistrationID=RegistrationID
		s OutputObj.TimeRange=TimeRange
		s OutputObj.PrintDataJson=RegInfoStr
	}
	q OutputObj
OPRegisterErr
	if $TLEVEL>0{
    	TRO
	}
	s OutputObj=..GetOutputObj("1101")
	s OutputObj.ResultCode="-1"
	s OutputObj.ResultContent="OPRegister调用异常"_$ZERROR
	q OutputObj
}

ClassMethod NetTest(RequestStr As %String) As %String
{
	s $ZT="NetTestErr"
	q RequestStr
NetTestErr
	if $TLEVEL>0{
    	TRO
	}
	q "Err"
}

ClassMethod QueryOneAdmSchedule(RBASID As %String = "", PatientID As %String = "", AppRegMethodCode As %String = "", AdmReason As %String = "", ExpStr As %String = "") As DHCDoc.Util.RegisteredObject
{
	s $ZT="QueryOneAdmScheduleErr"
	s QuitNoAvailbleSchdule=""
	if ExpStr'=""{
		s QuitNoAvailbleSchdule=$p(ExpStr,"^",3)	
	}
	s Obj=##class(User.RBApptSchedule).%OpenId(RBASID,0,.sc)
	s ASStatusCode=""
	s ASStatusDR=$P($g(^RBAS(+RBASID,$p(RBASID,"||",2),"DHC")),"^",10)
	s:ASStatusDR'="" ASStatusCode=$p($g(^DHCRBCASStatus(ASStatusDR)),"^",1)
	q:ASStatusCode="S" "-1^停诊"
	q:ASStatusCode="TR" "-1^被替诊"
	q:ASStatusCode="PS" "-1^中途停诊"
	q:ASStatusCode="SPSA" "-1^只停正号"
	q:Obj.ASIrregularFlag="A" "-1^不规则排班"
	s RBASRecObj=..GetRBASRecObjByRBASObj(Obj,PatientID,AppRegMethodCode,AdmReason,ExpStr)
	s ASNoLimitLoadFlag=RBASRecObj.ASNoLimitLoadFlag
	s AvailableLeftNum=+RBASRecObj.AvailableLeftNum
	q:(QuitNoAvailbleSchdule="1")&&(AvailableLeftNum=0)&&(ASNoLimitLoadFlag'="Y") "-1^排班无可用号源"
	;if +RBASRecObj.AvailableLeftNum=0 s RBASRecObj.AvailableNumStr="号已挂完"
	;q:+RBASRecObj.Fee=0 "-1^挂号费错误"
	q RBASRecObj
QueryOneAdmScheduleErr
	q "-1^QueryOneAdmSchedule调用异常错误"_$ZERROR
}

/// 得到单个出诊信息对象
/// 通
ClassMethod GetRBASRecObjByRBASObj(RBASObj As User.RBApptSchedule, PatientID As %String = "", AppRegMethodCode As %String = "", AdmReason As %String = "", ExpStr As %String = "") As DHCDoc.Util.RegisteredObject
{
	s BankCode="",GroupID="",ClinicGroupDr=""
	if ExpStr'=""{
		s BankCode=$p(ExpStr,"^",1)
		s GroupID=$p(ExpStr,"^",2)
		s ClinicGroupDr=$p(ExpStr,"^",4)
	}
	s RBASSessionLoad=..GetAppQty(RBASObj.%Id())
	s RtnObj=##class(DHCExternalService.RegInterface.Entity.SelfReg.List.Schedule).%New()
	s DHCRBASObj=##class(User.DHCRBApptSchedule).%OpenId(RBASObj.%Id(),0,.sc)
	s RtnObj.ScheduleItemCode=RBASObj.%Id()
	s RtnObj.ServiceDate=..%ZD(RBASObj.ASDate) //$ZD(RBASObj.ASDate,3)
	s RtnObj.WeekDay=$ZD(RBASObj.ASDate,10)
	s:RtnObj.WeekDay=0 RtnObj.WeekDay=7
	s ASNoLimitLoadFlag=DHCRBASObj.ASNoLimitLoadFlag
	s ASTimeRangeDR=DHCRBASObj.ASTimeRangeDR.%Id()
	s OuterTimeRange=##class(DHCExternalService.RegInterface.GetRelate).GetOuterTimeRangeCode(ASTimeRangeDR,BankCode)
	s RtnObj.SessionCode=$p(OuterTimeRange,"^",1)
	s RtnObj.SessionName=$p(OuterTimeRange,"^",2)
	s TimeRangeFlag=DHCRBASObj.ASTimeRangeFlag
	s RtnObj.DoctorCode=RBASObj.ASRESParRef.RESCTPCPDRGetObjectId()
	s RtnObj.DoctorName=RBASObj.ASRESParRef.RESCTPCPDR.CTPCPDesc
	i TimeRangeFlag="Y" s RtnObj.TimeRangeFlag="1"
	e  s RtnObj.TimeRangeFlag="0"
	s RtnObj.DepartmentCode=RBASObj.ASRESParRef.RESCTLOCDRGetObjectId()
	s RtnObj.DepartmentName=RBASObj.ASRESParRef.RESCTLOCDR.CTLOCDesc
	if (RBASObj.ASRESParRef.RESCTLOCDR.CTLOCDesc["-") set RtnObj.DepartmentName=$piece(RBASObj.ASRESParRef.RESCTLOCDR.CTLOCDesc,"-",2)
	s RtnObj.ClinicRoomCode=""
	s RtnObj.ClinicRoomName=""
	s RtnObj.ServiceCode=""
	s RtnObj.ServiceName=""
	if (ClinicGroupDr'=""){
		s RtnObj.ServiceCode=ClinicGroupDr //DHCRBASObj.ASClinicGroupDRGetObjectId()
		s RtnObj.ServiceName=$p(^RBC("CLGRP",ClinicGroupDr),"^",2) //DHCRBASObj.ASClinicGroupDR.CLGRPDesc
	}else{
		//s RtnObj.ServiceCode=DHCRBASObj.ASClinicGroupDRGetObjectId()
		//s RtnObj.ServiceName=DHCRBASObj.ASClinicGroupDR.CLGRPDesc
	}
	s RtnObj.DoctorSpec=RBASObj.ASRESParRef.RESCTPCPDR.CTPCPSpecDR.CTSPCDesc //医生介绍
	if (PatientID'="")          
	{
		s PatCatDr=$p(^PAPER(PatientID,"PER",1),"^",10)
		i AdmReason'="" s DefaultBillType=AdmReason
		e  s DefaultBillType=##Class(web.DHCOPAdmReg).GetDefaultBillType(PatCatDr)
		s DocResValue=##Class(web.DHCOPAdmReg).GetMarkRegFee(RBASObj.%Id(),DefaultBillType,PatientID)
		s RtnObj.RegFee=$p(DocResValue,"^",12)
		s RtnObj.CheckupFee=$p(DocResValue,"^",14)
		s RtnObj.OtherFee=((+$p(DocResValue,"^",20))+(+$p(DocResValue,"^",15))+(+$p(DocResValue,"^",18))+(+$p(DocResValue,"^",16)))
		s RtnObj.Fee=((+RtnObj.RegFee)+(+RtnObj.CheckupFee)+(+RtnObj.ServiceFee)+(+RtnObj.OtherFee)) //总挂号费
		s RtnObj.DoctorTitleCode=$p(DocResValue,"^",11)
		s RtnObj.DoctorTitle=$p(DocResValue,"^",10)
	}
	else
	{
		s DefaultBillType=AdmReason
		s DocResValue=##Class(web.DHCOPAdmReg).GetMarkRegFee(RBASObj.%Id(),DefaultBillType,"")
		s RtnObj.RegFee=$p(DocResValue,"^",12)
		s RtnObj.CheckupFee=$p(DocResValue,"^",14)
		s RtnObj.OtherFee=((+$p(DocResValue,"^",20))+(+$p(DocResValue,"^",15))+(+$p(DocResValue,"^",18))+(+$p(DocResValue,"^",16)))
		s RtnObj.Fee=((+RtnObj.RegFee)+(+RtnObj.CheckupFee)+(+RtnObj.ServiceFee)+(+RtnObj.OtherFee)) //总挂号费
		s RtnObj.DoctorTitleCode=$p(DocResValue,"^",11)
		s RtnObj.DoctorTitle=$p(DocResValue,"^",10)
	}
	s RtnObj.ServiceFee=""  //服务费
	
	s myRBASID=RBASObj.%Id()
	s UsedSeqNoCount=##class(web.DHCRBApptSchedule).GetUsedSeqNoCount(myRBASID)
	s RegedCount=$P(UsedSeqNoCount,"^",1)
	s AppedCount=$P(UsedSeqNoCount,"^",2)
	s AddedCount=$P(UsedSeqNoCount,"^",3)
	s RegType=##CLass(web.DHCLockSchedule).GetAutoRegType(myRBASID)
	
	s AvailableNumStr=""
	if ASNoLimitLoadFlag'="Y"{
		if $g(RegType)="APP"{
			s AvailableNumStr=..GetAvailSeqNoStrWithOutForm(myRBASID,RegType,AppRegMethodCode,ExpStr)
		}else{
			s AvailableNumStr=..GetAvailSeqNoStrWithOutForm(myRBASID,RegType,"",ExpStr)
		}
	}else{
		s AvailableNumStr="^∞^∞"	
	}
	
	s mySeqNoStr=AvailableNumStr
	;可用号串^预约(正号)限额^剩余号数量
	s AvailableNumStr=$p(mySeqNoStr,"^",1)
	s AvailableTotal=$p(mySeqNoStr,"^",2)
	s AvailableLeft=$p(mySeqNoStr,"^",3)
	s RtnObj.AvailableNumStr=AvailableNumStr
	s RtnObj.AvailableTotalNum=AvailableTotal
	s RtnObj.AvailableLeftNum=AvailableLeft
	s RtnObj.DoctorSessTypeCode=DHCRBASObj.ASSessionTypeDRGetObjectId()
	s RtnObj.DoctorSessType=DHCRBASObj.ASSessionTypeDR.SESSDesc
	s RtnObj.DoctorSessType=$P(RtnObj.DoctorSessType,"(",1)
	//s RtnObj.ServiceCode=DHCRBASObj.ASClinicGroupDRGetObjectId()
	//s RtnObj.ServiceName=DHCRBASObj.ASClinicGroupDR.CLGRPDesc
	s RtnObj.AdmitAddress=DHCRBASObj.ASRoomDR.CTLOCFloor //就诊地点
	s RtnObj.ASNoLimitLoadFlag=ASNoLimitLoadFlag
	if RtnObj.AdmitAddress=""{
		s RtnObj.AdmitAddress=##class(DHCExternalService.RegInterface.SynVisitSchedule).GetAdmitAddress(myRBASID)
	}
	
	s RtnObj.StartTime=RBASObj.ASSessStartTime
	s:RtnObj.StartTime'="" RtnObj.StartTime=..%ZT(RtnObj.StartTime,2) 
	
	s RtnObj.EndTime=RBASObj.ASSessEndTime
	s:RtnObj.EndTime'="" RtnObj.EndTime=..%ZT(RtnObj.EndTime,2)
	s RtnObj.ScheduleStatus="1"
	;s RtnObj.Note=RBASObj.ASRemarks.GetAt(RBASObj.ASRemarks.Count())
	s RtnObj.Note=RBASObj.ASRemarks
	if (RtnObj.Note="") s RtnObj.Note=$p($g(^RBAS(+myRBASID,$P(myRBASID,"||",2))),"^",28)
	q RtnObj
}

ClassMethod GetRBASRecTimeObj(RBASObj As User.RBApptSchedule, OneTimeRange As %String, OneRegNumRange As %String, TRLoad As %String, AppMedthodCode As %String = "", BankCode As %String = "", ClinicGroupDr As %String = "") As DHCDoc.Util.RegisteredObject
{
	s RBASRowID=RBASObj.%Id()
	s RBASSessionLoad=..GetAppQty(RBASRowID)
	s RtnObj=##class(DHCExternalService.RegInterface.Entity.SelfReg.List.TimeRange).%New()
	s DHCRBASObj=##class(User.DHCRBApptSchedule).%OpenId(RBASRowID,0,.sc)
	s RtnObj.ScheduleItemCode=RBASObj.%Id()
	s RtnObj.ServiceDate=$ZD(RBASObj.ASDate,3)
	s RtnObj.WeekDay=$ZD(RBASObj.ASDate,10)
	s:RtnObj.WeekDay=0 RtnObj.WeekDay=7
	
	s ASTimeRangeDR=DHCRBASObj.ASTimeRangeDR.%Id()
	s OuterTimeRange=##class(DHCExternalService.RegInterface.GetRelate).GetOuterTimeRangeCode(ASTimeRangeDR,BankCode)
	s RtnObj.SessionCode=$p(OuterTimeRange,"^",1)
	s:RtnObj.SessionCode="" RtnObj.SessionCode=DHCRBASObj.ASTimeRangeDR.TRCode
	s RtnObj.SessionName=$p(OuterTimeRange,"^",2)
	s RegType=##CLass(web.DHCLockSchedule).GetAutoRegType(RBASRowID)
	if DHCRBASObj.ASTimeRangeFlag="Y"{
		s RBASHospId=##class(DHCExternalService.RegInterface.GetRelate).GetHISHospitalIdFromOuterCode("",RBASRowID)
		s QueueNoStr=##class(web.DHCRBAppointment).GetAvailableSeqNoStr(RBASRowID,RegType,AppMedthodCode,RBASHospId,$p(OneTimeRange,"-",1),$p(OneTimeRange,"-",2),"",ClinicGroupDr)
		if QueueNoStr="" s AppAllNumber=0
		else  s AppAllNumber=$l(QueueNoStr,",")
		
		s RtnObj.AvailableNumStr=QueueNoStr
		s RtnObj.AvailableTotalNum=TRLoad
		s RtnObj.AvailableLeftNum=AppAllNumber
		
	}
	s RtnObj.StartTime=$p(OneTimeRange,"-",1)
	s RtnObj.EndTime=$p(OneTimeRange,"-",2)
	d DHCRBASObj.%Close()
	q RtnObj
}

/// w ##class(DHCExternalService.RegInterface.SelfRegMethods).GetAvailSeqNoStr("1||18","WIN")
ClassMethod GetAvailSeqNoStr(RBASRowID As %String, AppRegMethodCode As %String = "")
{
	s AvailableNumStr=""
	s RegType=##CLass(web.DHCLockSchedule).GetAutoRegType(RBASRowID)
	
	s AvailableNumStr=""
	if $g(RegType)="APP" d
	.s AvailableNumStr=..GetAvailSeqNoStrWithOutForm(RBASRowID,RegType,AppRegMethodCode)
	else  d
	.;s TimeReturnDesc=$P(^DHCTimeRange(SessionTypeDr),"^",5)
	.;i (+TimeReturnDesc)>(+..%SysTime()) d
	.;.s AvailableNumStr=..GetAvailSeqNoStrWithOutForm(RBASRowID,RegType)
	.;e  d
	.s AvailableNumStr=..GetAvailSeqNoStrWithOutForm(RBASRowID,RegType)
	q AvailableNumStr
}

/// w ##class(DHCExternalService.RegInterface.SelfRegMethods).GetTimeRangeSeqNo("1956||2304","1")
ClassMethod GetTimeRangeSeqNo(RBASId As %String, SeqNo As %String) As %String
{
	s OutputString=""
	s ResRowId=$P(RBASId,"||",1)
	s Childsub=$P(RBASId,"||",2)
	s NumStr=$P($g(^RBAS(ResRowId,Childsub,"DHC")),"^",24)
	s TimeStr=$P($g(^RBAS(ResRowId,Childsub,"DHC")),"^",25)
	
	if (NumStr="")||(TimeStr=""){
		q OutputString
	}
	For i=1:1:$Length(NumStr,",")
	{
		s OneNumStr=$p(NumStr,",",i)
		s OneTimeStr=$p(TimeStr,",",i)
		s StartNum=$p(OneNumStr,"-",1)
		s EndNum=$p(OneNumStr,"-",2)
		s AvailFlag=0
		if ((StartNum<=SeqNo)&&(EndNum>=SeqNo)){
			s OutputString=OneTimeStr
			q
		}		
	}
	q OutputString
}

/// w ##Class(DHCExternalService.RegInterface.SelfRegMethods).GetTimeRangeSeqNoInfo("1956||2304")
ClassMethod GetTimeRangeSeqNoInfo(RBASId As %String) As %String
{
	s OutputString=""
	s ResRowId=$P(RBASId,"||",1)
	s Childsub=$P(RBASId,"||",2)
	s ASQueueNo=$P($g(^RBAS(ResRowId,Childsub,"DHC")),"^",4)
	s NormalQueueNoStr=$P(ASQueueNo,$C(1),1)
	s AddQueueNoStr=$P(ASQueueNo,$C(1),2)
	s AppReturnTime=0
	s TRRowId=$P($G(^RBAS(ResRowId,Childsub,"DHC")),"^",17)
	if TRRowId'="" s AppReturnTime=$p($g(^DHCTimeRange(TRRowId)),"^",5)
	
	s ReturnAllowRegFlag=##class(web.DHCRBAppointment).GetReturnAllowRegFlag(4)
	
	s NumStr=$P($g(^RBAS(ResRowId,Childsub,"DHC")),"^",24)
	s TimeStr=$P($g(^RBAS(ResRowId,Childsub,"DHC")),"^",25)
	
	if (NumStr="")||(TimeStr=""){
		q OutputString
	}
	
	For i=1:1:$Length(NumStr,",")
	{
		s OneNumStr=$p(NumStr,",",i)
		s OneTimeStr=$p(TimeStr,",",i)
		s StartNum=$p(OneNumStr,"-",1)
		s EndNum=$p(OneNumStr,"-",2)
		s AvailFlag=0
		For j=StartNum:1:EndNum
		{
			if (NormalQueueNoStr[(j_":0"))||((ReturnAllowRegFlag=1)&&(NormalQueueNoStr[(j_":4")))
			{
				s AvailFlag=1
				q
			}
			
		}
		if OutputString="" s OutputString=OneTimeStr_";"_AvailFlag
		else  s OutputString=OutputString_","_OneTimeStr_";"_AvailFlag
			
	}
	
	q OutputString
}

/// w ##class(DHCExternalService.RegInterface.SelfRegMethods).QueryAdmOPReg("<Request><TradeCode>1104</TradeCode><PatientCard>1000000000000304570</PatientCard><AdmNo>511517</AdmNo><PatientID>0000201967</PatientID><PayOrdId></PayOrdId><ExtUserID>APP01</ExtUserID></Request>")
ClassMethod QueryAdmOPReg(XMLRequest As %String) As DHCExternalService.RegInterface.Entity.SelfReg.QueryAdmOPRegRp
{
	s $ZTRAP="QueryAdmOPRegErr"
	s ^tmpnk("QueryAdmOPReg")=XMLRequest
	//s XMLRequest="<Request><TradeCode>1104</TradeCode><ExtOrgCode></ExtOrgCode><ClientType></ClientType><HospitalId></HospitalId><ExtUserID>zz00</ExtUserID><CardType>HT-BOC</CardType><PatientCard>1234567890</PatientCard><PatientID></PatientID><StartDate>2013-07-14</StartDate><EndDate>2013-07-16</EndDate></Request>"
	s InputObj=..GetInputObj("1104",XMLRequest)
	s CardType=InputObj.CardType
	s HospitalId=InputObj.HospitalId
	s PatientCard=InputObj.PatientCard
	s PatientNo=InputObj.PatientID
	s AdmNo=InputObj.AdmNo
	s PayOrdId=InputObj.PayOrdId
	s TransactionId=InputObj.TransactionId
	s OutputObj=..GetOutputObj("1104")
	s OutputObj.ResultCode="0"
	s OutputObj.ResultContent=""
	s HospitalId=##class(DHCExternalService.RegInterface.GetRelate).GetHISHospitalIdFromOuterCode(HospitalId) 
	if HospitalId=""{
		d ..SetOutputCode(.OutputObj,"-110401","请传入正确的院区代码.")
		quit OutputObj	
	}
	s UserID=##class(DHCExternalService.RegInterface.GetRelate).GetUser(InputObj.ExtUserID,"",HospitalId)
	if (UserID=""){
		d ..SetOutputCode(.OutputObj,"-110402","请传入正确的操作用户.")
		q OutputObj
	}
	s GroupID=##class(DHCExternalService.RegInterface.GetRelate).GetGroup(UserID)
	s BankCode=##class(DHCDoc.Interface.Outside.Config).GetConfigNode(GroupID,"DataCompareExtOrg",HospitalId)
	s CardType=##class(DHCExternalService.RegInterface.GetRelate).GetHisCardTypeID(CardType,BankCode,"",HospitalId)
	;必须条件判断
	if (PatientCard="")&&(PatientNo="")&&(AdmNo="")&&(TransactionId=""){
		 d ..SetOutputCode(.OutputObj,"-110403","查询信息不能都为空.")
		 q OutputObj
	}
	
	s RegFeeId=""
	if (AdmNo'=""){
		set RegFeeId=$o(^User.DHCRegistrationFeeI("ADM",AdmNo,""))
	}
	
	if (RegFeeId="")&&(TransactionId'=""){
		s CTLSRowID=$o(^CTLS(0,"HISTradNo",TransactionId,""))
		s Activity=$p(^CTLS(CTLSRowID),"^",7)
		if (Activity="Y"){
			set ADMDr=$p(^CTLS(CTLSRowID),"^",9)
			if (ADMDr'=""){
				s RegFeeId=$o(^User.DHCRegistrationFeeI("ADM",ADMDr,""))
			}
		}	
	}
	Set RecordCount=0
	if RegFeeId'=""{
		s AdmRowid=$list(^User.DHCRegistrationFeeD(RegFeeId),2)
		s AdmHospitalId=##class(DHCDoc.Common.Hospital).GetAdmHospitalId(AdmRowid)
		if (AdmHospitalId=HospitalId) {
			s OrderObj=..GetAdmInfoObj(AdmRowid,UserID)
			if $IsObject(OrderObj){
				do OutputObj.Orders.Insert(OrderObj)
				s RecordCount=RecordCount+1
			}
		}
	}else{
		s myPatientID=""
		if PatientCard'="" {
			if (CardType=""){
				d ..SetOutputCode(.OutputObj,"-110404","卡类型不能为空或与His未对照.")
				q OutputObj
			}
			s myPatientID=..getPatIDByCardInfo(CardType,PatientCard)
			if myPatientID="" d ..SetOutputCode(.OutputObj,"-110405","卡号在系统中未找到")
		}elseif PatientNo'="" {
			s myPatientID=$o(^PAPERi("PAPMI_PatNo",$ZCVT(PatientNo,"U"),""))	
		}
		i '$d(^PAPER(+myPatientID,"ALL")){
			d ..SetOutputCode(.OutputObj,"-110406","患者信息在系统中未找到")
		}
		if OutputObj.ResultCode="0" {
			Set StartDate=InputObj.StartDate
			Set EndDate=InputObj.EndDate
			if StartDate'="" {
				Set:StartDate["-" StartDate=$zdh(StartDate,3)
				Set:StartDate["/" StartDate=$zdh(StartDate,4)
			}else {
				Set StartDate=..%SysDate()
			}
			if EndDate'="" {
				Set:EndDate["-" EndDate=$zdh(EndDate,3)
				Set:EndDate["/" EndDate=$zdh(EndDate,4)
			}
			Set AdmRowid=0
			Set AdmType=0
			for  Set AdmType=$o(^PAPERdr(myPatientID,"ADM",AdmType)) Quit:AdmType=""  do
			.Set AdmRowid=0
			.for  Set AdmRowid=$o(^PAPERdr(myPatientID,"ADM",AdmType,AdmRowid)) Quit:AdmRowid=""  do
			..Set AdmDate=$p(^PAADM(AdmRowid),"^",6)
			..Quit:(StartDate'="")&&(AdmDate<StartDate) 
			..Quit:(EndDate'="")&&(AdmDate>EndDate)
			..s AdmHospitalId=##class(DHCDoc.Common.Hospital).GetAdmHospitalId(AdmRowid)
		    ..Quit:AdmHospitalId'=HospitalId
			..Set RegfeeRowId=$o(^User.DHCRegistrationFeeI("ADM",AdmRowid,0))
			..Quit:RegfeeRowId=""
			..Set OrderObj=..GetAdmInfoObj(AdmRowid,UserID)
			..if $IsObject(OrderObj) do
			...do OutputObj.Orders.Insert(OrderObj)
			...s RecordCount=RecordCount+1

		}
	}
	if RecordCount'=0{
		s OutputObj.ResultCode="0"
		s OutputObj.ResultContent="查询成功"	
	}else{
		s OutputObj.ResultCode="100"
		s OutputObj.ResultContent="没有查询到挂号记录"	
	}
	Set OutputObj.RecordCount=RecordCount
	Quit OutputObj
QueryAdmOPRegErr
	s OutputObj=..GetOutputObj("1104")
	s OutputObj.ResultCode="-1"
	s OutputObj.ResultContent="QueryAdmOPRegErr调用异常"_$ZERROR
	q OutputObj
}

ClassMethod GetAdmInfoObj(AdmRowid As %String, UserID As %String, HospRowId As %String = "") As DHCExternalService.RegInterface.Entity.SelfReg.List.Order
{
	//w ##class(DHCExternalService.RegInterface.SelfRegMethods)GetAdmInfoObj()
	s RtnObj=##class(DHCExternalService.RegInterface.Entity.SelfReg.List.Order).%New()
	Set RegID=AdmRowid
	Set RegDate=..%ZD($p(^PAADM(AdmRowid),"^",6))  //挂号日期
	Set VisitStatus=$p(^PAADM(AdmRowid),"^",20)   //状态
	if VisitStatus="A" Set Status="正常"
	if VisitStatus="C" Set Status="退号"
	if VisitStatus="D" Set Status="出院"
	if Status="" Set Status=VisitStatus
	Set PatientID=$p(^PAADM(AdmRowid),"^",1)
	Set PatName=$p(^PAPER(PatientID,"ALL"),"^",1)  //患者姓名
	Set AdmitDate=$zd($p(^PAADM(AdmRowid),"^",6),3)       //就诊日期
	Set DepartmentId=$p(^PAADM(AdmRowid),"^",4)    //就诊科室
	Set Department=""
	if DepartmentId'="" Set Department=$p(^CTLOC(DepartmentId),"^",2)
	if (Department["-") set Department=$piece(Department,"-",2)
	Set HospitalName=""
	Set HospitalId=$p(^CTLOC(DepartmentId),"^",22)
	if HospitalId'="" Set HospitalName=$p(^CT("HOSP",HospitalId),"^",2)  //医院
	Set DoctorId=$p(^PAADM(AdmRowid),"^",9)
	Set Doctor=""
	if DoctorId'="" Set Doctor=$p(^CTPCP(DoctorId,1),"^",2)
	Set RtnObj.AdmNo=RegID
	Set RtnObj.RegDate=RegDate
	Set RtnObj.Status=Status
	Set RtnObj.PatName=PatName
	Set RtnObj.PatientID=$P(^PAPER(PatientID,"PAT",1),"^",1)
	Set RtnObj.AdmitDate=AdmitDate
	Set RtnObj.HospitalName=HospitalName
	Set RtnObj.Department=Department
	Set RtnObj.Doctor=Doctor
	Set RtnObj.DoctorCode=DoctorId
	Set RtnObj.DepartmentCode=DepartmentId
	Set RegfeeRowId=$o(^User.DHCRegistrationFeeI("ADM",AdmRowid,0))
	if RegfeeRowId'="" {
		Set RegInfoStr=##class(web.DHCOPAdmReg).GetPrintData(RegfeeRowId)  //981
		Set DoctorTitle=$P(RegInfoStr,"^",5)   //挂号职称
		Set RegFee=$p(RegInfoStr,"^",17)
		Set SeqCode=$p(RegInfoStr,"^",8)
		Set AdmitAddress=$p(RegInfoStr,"^",10)
		Set SessionName=$p(RegInfoStr,"^",7)
		Set AdmitRange=$P(RegInfoStr,"^",38)
		Set RtnObj.DoctorTitle=DoctorTitle
		Set RtnObj.RegFee=RegFee
		Set RtnObj.SeqCode=SeqCode
		Set RtnObj.AdmitAddress=AdmitAddress
		Set RtnObj.SessionName=SessionName
		Set RtnObj.AdmitRange=AdmitRange
		set RtnObj.ServiceName=$P(RegInfoStr,"^",21)
	}
	s GroupID=##class(DHCExternalService.RegInterface.GetRelate).GetGroup(UserID)
	s ReturnFlag="Y",ReturnMsg="可退"
	s ret=##class(DHCExternalService.RegInterface.RegManager).CheckCancelOPRegist(AdmRowid,GroupID,HospRowId)
	if ret'=""{
		s ReturnFlag="N"
		s ReturnMsg=ret
	}
	if VisitStatus="C"{
		s ReturnFlag="N"
		s ReturnMsg="不可退号,已退号."
	}
	s InsuRegInfo=""
	if (ReturnFlag="Y"){
		s AdmReason=$P(^PAADM(AdmRowid,1),"^",7)
		s InsuRowId=$O(^DHCINADM("0","ADM",AdmRowid,""),-1)
		if (InsuRowId'=""){
			///以&分割的N个入参
			s InsuRegInfo="0&"_UserID_"&"_InsuRowId_"&"_AdmReason_"&"_AdmReason_"&"
		}
	}
	Set RtnObj.InsuRegInfo=InsuRegInfo
	Set RtnObj.ReturnFlag=ReturnFlag
	Set RtnObj.ReturnMsg=ReturnMsg
	Quit RtnObj
}

/// 根据患者表ID和排班表ID取挂号费用信息(主要处理附加费用、初诊和复诊的费用信息不同的问题)
ClassMethod GetPatientScheduleFee(PAPERRowid As %String = "", ASRowId As %String = "") As %String
{
	
	s SocialStatus=$P(^PAPER(PAPERRowid,"PER",1),"^",10)
	set AdmReason=##Class(web.DHCOPAdmReg).GetDefaultBillType(SocialStatus)
	if (AdmReason="") set AdmReason=##Class(DHCExternalService.RegInterface.GetRelate).GetAdmReason()
	
	s OldManCardId=$p(^PAPER(PAPERRowid,"ALL"),"^",20)
	set DOB=$p(^PAPER(PAPERRowid,"ALL"),"^",6)
	set PatAge=(+$zd(+$H,3))-(+$zd(DOB,3))
	
	s Fee=0
	s checkfee=0
	s regfee=0
	s otherfee=0
	set err=0
	set Price=0
	set MentalityFristFlag=0																																																																																																																																																												
	;取挂号费和诊查费和节假日挂号费信息
	i SocialStatus="20" s AdmReason="3" //yjy 2008.4.24
	i SocialStatus="15" s AdmReason="3" //yjy 2008.5.18
	i SocialStatus="22" s AdmReason="3" //yjy 2008.5.21
	i SocialStatus="25" s AdmReason="3" //yjy 2008.7.11
	s SerIdStr=##Class(web.DHCOPAdmReg).GetScheduleService(ASRowId,AdmReason)
	s SerIdStr=##Class(web.DHCOPAdmReg).GetCustomScheduleService(PAPERRowid,ASRowId,SerIdStr,"Search")
    s AdmDep=$P($G(^RB("RES",+ASRowId)),"^",1)
    if (AdmDep="229") set ReAdmCodeBegin=##Class(web.DHCOPAdmReg).GetReAdmCodeBegin(PAPERRowid,ASRowId)

    
	 for i=1:1:$l(SerIdStr,"^") {
		 s ArcimId=$P(SerIdStr,"^",i)
		 i (ArcimId="") {continue}
		 s RegSerBillSubType=##Class(web.DHCOPAdmReg).GetRegArcimBillSubType(ArcimId)
		 s BillPrice=+$p(##Class(web.UDHCJFPRICE).GetOrderPrice("",AdmReason,ArcimId,+$H,"","","",""),"^",4)
		 
		 if (RegSerBillSubType="Reg")
		 {
			 if (AdmDep'=229)&&(AdmDep'=547)&&(PatAge'<60)      ///60岁以上老人免挂号费(著名专家和特需门诊除外)
			{
				set BillPrice=0
			}
			 set regfee=regfee+BillPrice
		 }
		 elseif((RegSerBillSubType="Check")||(RegSerBillSubType="ReCheck"))
		 {
			 if (AdmDep="229") 
			 {
				 
			 	 if (ReAdmCodeBegin="F")&&(RegSerBillSubType="Check")
			 	 {
				 	 set checkfee=checkfee+BillPrice
				 }
				 if (ReAdmCodeBegin="R")&&(RegSerBillSubType="ReCheck")
			 	 {
				 	  set checkfee=checkfee+BillPrice
				 }
				 
			 }
			 else
			 {
			 	if (RegSerBillSubType="Check") set checkfee=checkfee+BillPrice
			 }
		 }
		 else
		 {
			 set otherfee=otherfee+BillPrice
		 }
		 
		 
	 }
	 
	s Price=regfee+checkfee+otherfee
	q Price_"^"_regfee_"^"_checkfee_"^"_otherfee
}

/// 查询预约挂号信息
/// s ret=##Class(DHCExternalService.RegInterface.SelfRegMethods).QueryOPAppArriveList(^tan("QueryOPAppArriveList",2))
/// <Request><TradeCode>1005</TradeCode><ExtOrgCode></ExtOrgCode><ClientType></ClientType><HospitalId></HospitalId><ExtUserID></ExtUserID><CardNo>000000000110</CardNo><CredTypeCode>1</CredTypeCode><IDCardNo></IDCardNo><PatientNo></PatientNo><OrderApptStartDate>2013-05-10</OrderApptStartDate><OrderApptEndDate>2013-05-19</OrderApptEndDate><QueryDateFlag>AdmDate</QueryDateFlag><QueryUserType></QueryUserType><OrderStatus></OrderStatus><OrderCode></OrderCode></Request>
ClassMethod QueryOPAppArriveList(XMLRequest As %String = "") As DHCExternalService.RegInterface.Entity.SelfAppt.QueryOPAppArriveListRp
{
	//含有卡取号:卡号必填,无卡取号:身份证必填;标识节点区分有卡,无卡
	s ^tmp("QueryOPAppArriveList")=XMLRequest
	s $ZTRAP="QueryOPAppArriveListErr"
	s InputObj=..GetInputObj("1005",XMLRequest)
	s OutputObj=..GetOutputObj("1005")
	s OutputObj.ResultCode="0"
	s OutputObj.ResultContent=""
	s CardNo="",IDCardNo=""
	s IDCardNo=InputObj.IDCardNo
	s CardNo=InputObj.CardNo
	s CardType=InputObj.CardType
	s PatientNo=InputObj.PatientNo
	s ExtUserID=InputObj.ExtUserID
	s HospitalId=InputObj.HospitalId
	s HospitalId=##class(DHCExternalService.RegInterface.GetRelate).GetHISHospitalIdFromOuterCode(HospitalId) 
	if HospitalId=""{
		d ..SetOutputCode(.OutputObj,"-100501","请传入正确的院区代码.")
		quit OutputObj	
	}
	if ((CardNo="")&&(IDCardNo="")&&(PatientNo="")){
		d ..SetOutputCode(.OutputObj,"-100502","卡号或身份证号或登记号不能同时为空")
		q OutputObj
	}
	if ExtUserID=""{
		d ..SetOutputCode(.OutputObj,"-100503","操作员用户不能为空")
		q OutputObj
	}
	s UserID=##class(DHCExternalService.RegInterface.GetRelate).GetUser(ExtUserID,"",HospitalId)
	if (UserID=""){
		d ..SetOutputCode(.OutputObj,"-100504","操作员代码为空")
		q OutputObj
	}
	
	s GroupID=##class(DHCExternalService.RegInterface.GetRelate).GetGroup(UserID)
	s BankCode=##class(DHCDoc.Interface.Outside.Config).GetConfigNode(GroupID,"DataCompareExtOrg",HospitalId)
	s CardType=##class(DHCExternalService.RegInterface.GetRelate).GetHisCardTypeID(CardType,BankCode,"",HospitalId)
	s myPatientID=""
	if (PatientNo'=""){
		s myPatientID=$O(^PAPERi("PAPMI_PatNo",PatientNo,0))
	}elseif (CardNo'=""){
		if (CardType=""){
			d ..SetOutputCode(.OutputObj,"-100505","卡类型不能为空或与His未对照.")
			q OutputObj
		}
		s myPatientID=..getPatIDByCardInfo(CardType,CardNo)
		if myPatientID=""{
			d ..SetOutputCode(.OutputObj,"-100506","卡号在系统中未找到")
			q OutputObj
		}
	}else{
		d ..SetOutputCode(.OutputObj,"-100507","卡号或登记号不能同时为空")
		q OutputObj
	}
	if (myPatientID=""){
		d ..SetOutputCode(.OutputObj,"-100508","患者记录不存在")
		q OutputObj
	}
	s IDCardNo=$p(^PAPER(myPatientID,"PAT",3),"^",6)
	if (OutputObj.ResultCode=0){
		Set StartDate=InputObj.OrderApptStartDate
		Set EndDate=InputObj.OrderApptEndDate
		s:StartDate'="" StartDate=$zdh(StartDate,3)
		s:EndDate'="" EndDate=$zdh(EndDate,3)
		s:StartDate="" StartDate=..%SysDate()
		s:EndDate="" EndDate=..%SysDate()
		s OrderStatus=InputObj.OrderStatus
		s QueryDateFlag=InputObj.QueryDateFlag	//AppDate:预约申请日期；AdmDate:预约就诊日期；"":查询没有过期的预约记录，不需要开始日期和结束日期条件。
		i (QueryDateFlag="AdmDate") d
		.d ..GetApptListByAdmDate(.OutputObj,myPatientID,StartDate,EndDate,OrderStatus,IDCardNo,HospitalId)
		e  i (QueryDateFlag="AppDate") d
		.d ..GetApptListByAppDate(.OutputObj,myPatientID,StartDate,EndDate,OrderStatus,IDCardNo,HospitalId)
		e  d
		.d ..GetApptListByAppDate(.OutputObj,myPatientID,+$h,"",OrderStatus,IDCardNo,HospitalId)
	}
	q OutputObj
QueryOPAppArriveListErr
	s OutputObj=..GetOutputObj("1005")
	s OutputObj.ResultCode="-1005"
	s OutputObj.ResultContent="查询预约失败"_$ze
}

/// s a=##Class(DHCExternalService.RegInterface.SelfRegMethods).GetApptListByAdmDate(18341,"62950","62959","normal")
ClassMethod GetApptListByAdmDate(ByRef OutputObj As DHCExternalService.RegInterface.Entity.SelfAppt.QueryOPAppArriveListRp, PatientID As %String, StartDate As %String, EndDate As %String, AppStatus As %String = "", IDCardNo As %String = "", HospitalId As %String = "")
{
	;s OutputObj=##class(DHCExternalService.RegInterface.Entity.SelfAppt.QueryOPAppArriveListRp).%New()
	s RecordCount=0
	s CommonPatientID=##class(web.DHCOPAdmReg).GetCommonPatientID("",HospitalId)
	s PatTelNo=$p($g(^PAPER(PatientID,"PER",1)),"^",11)
	s PatMobil=$p($g(^PAPER(PatientID,"PER",4)),"^",21)
	if AppStatus="cancel" d
	.s AppStatus="X"
	e  i (AppStatus="normal") d
	.s AppStatus="I"
	s RecordCount=0
	s ResRowId=0  f  s ResRowId=$O(^RBAS("APPT_Date",ResRowId)) Q:ResRowId=""  d
	.s RESCTLOCDR=$p(^RB("RES",ResRowId),"^",1)
	.s LocHospDr=$p(^CTLOC(RESCTLOCDR),"^",22)
	.Q:(HospitalId'="")&&(HospitalId'=LocHospDr)
	.s AppDate=(StartDate-1) f  s AppDate=$O(^RBAS("APPT_Date",ResRowId,AppDate)) Q:(AppDate="")!((EndDate'="")&&(+AppDate>EndDate))  d
	..s AppTime=0 f  s AppTime=$O(^RBAS("APPT_Date",ResRowId,AppDate,AppTime)) Q:AppTime=""  d
	...s ASChild=0 f  s ASChild=$O(^RBAS("APPT_Date",ResRowId,AppDate,AppTime,ASChild)) Q:ASChild=""  d
	....s APPChild=0 f  s APPChild=$O(^RBAS("APPT_Date",ResRowId,AppDate,AppTime,ASChild,APPChild)) Q:APPChild=""  d
	.....;w ResRowId_"||"_ASChild_"||"_APPChild,!
	.....Q:'$D(^RB("RES",ResRowId))
	.....Q:(EndDate'="")&(+AppDate>EndDate)
	.....q:(StartDate'="")&(StartDate>+AppDate)
	.....s Appt=$G(^RBAS(ResRowId,ASChild,"APPT",APPChild))
	.....;预约人姓名
	.....s AppPatientID=$P(Appt,"^",2)
	.....Q:'$D(^PAPER(AppPatientID))
	.....Q:(PatientID'="")&&(AppPatientID'=PatientID)&&(CommonPatientID'=AppPatientID)
	.....s StatusCode=$P(Appt,"^",3)
	.....Q:(AppStatus'="")&(AppStatus'=StatusCode)
	.....Q:(AppStatus="")&(StatusCode'="I")
	.....Q:(StatusCode="J")
	.....s StatusDesc=""
	.....i StatusCode="I" s StatusDesc="已预约"
	.....i StatusCode="A" s StatusDesc="已取号"
	.....i StatusCode="X" s StatusDesc="已取消"
	.....s NoCommon=0
	.....if (AppPatientID=CommonPatientID) d
	......s ApptCredNo=$p($g(^RBAS(ResRowId,ASChild,"APPT",APPChild,"DHC")),"^",8)
	......s ApptTelNo=$p($g(^RBAS(ResRowId,ASChild,"APPT",APPChild,"DHC")),"^",5)
	......if ((ApptCredNo'=IDCardNo)&&(ApptTelNo'=PatMobil)&&(ApptTelNo'=PatTelNo)) d
	.......s NoCommon=1
	.....q:NoCommon=1
	.....s APPTRowId=ResRowId_"||"_ASChild_"||"_APPChild
	.....s ApptOrderObj=..GetApptObjByRBASObj(APPTRowId,PatientID)
	.....if $IsObject(ApptOrderObj) d
	......do OutputObj.Orders.Insert(ApptOrderObj)
	......s RecordCount=RecordCount+1
	
	;DO ret.XMLExportToString(.XML,"Response")
	if RecordCount'=0{
		s OutputObj.ResultCode="0"
		s OutputObj.ResultContent="查询成功"	
	}else{
		s OutputObj.ResultCode="100"
		s OutputObj.ResultContent="没有查询到预约记录"	
	}
	Set OutputObj.RecordCount=RecordCount
	;Quit OutputObj
}

/// ByRef OutputObj As DHCExternalService.RegInterface.Entity.SelfAppt.QueryOPAppArriveListRp,
/// s a=##Class(DHCExternalService.RegInterface.SelfRegMethods).GetApptListByAppDate(18341,62950,62959,"normal")
ClassMethod GetApptListByAppDate(ByRef OutputObj As DHCExternalService.RegInterface.Entity.SelfAppt.QueryOPAppArriveListRp, PatientID As %String, StartDate As %String, EndDate As %String, AppStatus As %String = "", IDCardNo As %String = "", HospitalId As %String = "")
{
	;s OutputObj=##class(DHCExternalService.RegInterface.Entity.SelfAppt.QueryOPAppArriveListRp).%New()
	s RecordCount=0
	s PatTelNo=$p($g(^PAPER(PatientID,"PER",1)),"^",11)
	s PatMobil=$p($g(^PAPER(PatientID,"PER",4)),"^",21)
	s PatName=$p(^PAPER(PatientID,"ALL"),"^",1)
	if AppStatus="cancel" d
	.s AppStatus="X"
	e  i (AppStatus="normal") d
	.s AppStatus="I"
	
	///先检索自己名下的预约信息
	s RecordCount=0
	//^PAPERDR({APPT_PAPMI_DR},"RB_Appt",{APPT_Status},{RB_Resource.RES_RowId},{RB_ApptSchedule.AS_ChildSub},{APPT_ChildSub})
	s Status=0 f  s Status=$o(^PAPERDR(PatientID,"RB_Appt",Status)) q:Status=""  d
	.Q:(AppStatus'="")&(AppStatus'=Status)
	.Q:(AppStatus="")&(Status'="I")
	.Q:(Status="J")
	.s StatusDesc=""
	.i Status="I" s StatusDesc="已预约"
	.i Status="A" s StatusDesc="已取号"
	.i Status="X" s StatusDesc="已取消"
	.s ResRowId=0 f  s ResRowId=$o(^PAPERDR(PatientID,"RB_Appt",Status,ResRowId)) q:ResRowId=""  d
	..s RESCTLOCDR=$p(^RB("RES",ResRowId),"^",1)
	..s LocHospDr=$p(^CTLOC(RESCTLOCDR),"^",22)
	..Q:(HospitalId'="")&&(HospitalId'=LocHospDr)
	..s ASChild=0 f  s ASChild=$o(^PAPERDR(PatientID,"RB_Appt",Status,ResRowId,ASChild)) q:ASChild=""  d
	...s APPChild=0 f  s APPChild=$o(^PAPERDR(PatientID,"RB_Appt",Status,ResRowId,ASChild,APPChild)) q:APPChild=""  d
	....Q:'$D(^RB("RES",ResRowId))
	....s Appt=$G(^RBAS(ResRowId,ASChild,"APPT",APPChild))
	....s TransDate=$p(Appt,"^",8)
	....Q:(EndDate'="")&(+TransDate>EndDate)
	....Q:(StartDate'="")&(StartDate>+TransDate)
	....s APPTRowId=ResRowId_"||"_ASChild_"||"_APPChild
	....;w "APPTRowId:"_APPTRowId,!
	....s ApptOrderObj=..GetApptObjByRBASObj(APPTRowId,PatientID)
	....if $IsObject(ApptOrderObj) d
	.....do OutputObj.Orders.Insert(ApptOrderObj)
	.....s RecordCount=RecordCount+1
	b
	///检索公共卡名下的预约信息
	s CommonPatientID=##class(web.DHCOPAdmReg).GetCommonPatientID("",HospitalId)
	if (CommonPatientID'=""){
	//^PAPERDR({APPT_PAPMI_DR},"RB_Appt",{APPT_Status},{RB_Resource.RES_RowId},{RB_ApptSchedule.AS_ChildSub},{APPT_ChildSub})
	s Status=0 f  s Status=$o(^PAPERDR(CommonPatientID,"RB_Appt",Status)) q:Status=""  d
	.Q:(AppStatus'="")&(AppStatus'=Status)
	.Q:(AppStatus="")&(Status'="I")
	.Q:(Status="J")
	.s StatusDesc=""
	.i Status="I" s StatusDesc="已预约"
	.i Status="A" s StatusDesc="已取号"
	.i Status="X" s StatusDesc="已取消"
	.s ResRowId=0 f  s ResRowId=$o(^PAPERDR(CommonPatientID,"RB_Appt",Status,ResRowId)) q:ResRowId=""  d
	..s ASChild=0 f  s ASChild=$o(^PAPERDR(CommonPatientID,"RB_Appt",Status,ResRowId,ASChild)) q:ASChild=""  d
	...s APPChild=0 f  s APPChild=$o(^PAPERDR(CommonPatientID,"RB_Appt",Status,ResRowId,ASChild,APPChild)) q:APPChild=""  d
	....Q:'$D(^RB("RES",ResRowId))
	....s Appt=$G(^RBAS(ResRowId,ASChild,"APPT",APPChild))
	....s TransDate=$p(Appt,"^",8)
	....Q:(EndDate'="")&(+TransDate>EndDate)
	....Q:(StartDate'="")&(StartDate>+TransDate)
	....s ApptCredNo=$p($g(^RBAS(ResRowId,ASChild,"APPT",APPChild,"DHC")),"^",8)
	....s ApptTelNo=$p($g(^RBAS(ResRowId,ASChild,"APPT",APPChild,"DHC")),"^",5)
	....s ApptName=$p($g(^RBAS(ResRowId,ASChild,"APPT",APPChild,"DHC")),"^",5)
	....;w ApptName_"!"_PatName_"!"_ApptCredNo_"!"_IDCardNo_"!"_ApptTelNo_"!"_PatTelNo,!
	....q:((ApptCredNo'=IDCardNo)&&(ApptTelNo'=PatMobil)&&(ApptTelNo'=PatTelNo))
	....s APPTRowId=ResRowId_"||"_ASChild_"||"_APPChild
	....;w "APPTRowId:"_APPTRowId,!
	....s ApptOrderObj=..GetApptObjByRBASObj(APPTRowId,CommonPatientID)
	....;w ApptOrderObj,!
	....if $IsObject(ApptOrderObj) d
	.....do OutputObj.Orders.Insert(ApptOrderObj)
	.....s RecordCount=RecordCount+1
	}
	if RecordCount'=0{
		s OutputObj.ResultCode=0
		s OutputObj.ResultContent="查询成功"	
	}else{
		s OutputObj.ResultCode=100
		s OutputObj.ResultContent="没有查询到预约记录"	
	}
	Set OutputObj.RecordCount=RecordCount
	;Quit OutputObj
}

/// 得到单个预约记录
/// w ##Class(DHCExternalService.RegInterface.SelfRegMethods).GetApptObjByRBASObj("688||64||1",18341)
ClassMethod GetApptObjByRBASObj(APPTRowId As %String, PatientID As %String) As DHCExternalService.RegInterface.Entity.SelfAppt.List.ApptOrder
{
	q:(APPTRowId="")!(PatientID="") ""
	s DeptRowId=$P(^RB("RES",+APPTRowId),"^",1)
	s HospitalId=##class(DHCDoc.Common.Hospital).GetLocHospitalId(DeptRowId)
	s CommonFlag=0
	s DHCRBAppTobject=""
	if (PatientID=##class(web.DHCOPAdmReg).GetCommonPatientID("",HospitalId)){
		s CommonFlag=1
		s DHCRBAppTobject=##class(User.DHCRBAppointment).%OpenId(APPTRowId)
	}
	Set RBAppTobject =##class(User.RBAppointment).%OpenId(APPTRowId)
	
	s RBObject=##class(User.RBResource).%OpenId(+APPTRowId)
	s ApptOrderObj=##class(DHCExternalService.RegInterface.Entity.SelfAppt.List.ApptOrder).%New()
	s ApptOrderObj.OrderCode=APPTRowId
	s ApptOrderObj.OrderApptDate=$zd(RBAppTobject.APPTTransDate,3)
	s APPTStatus=RBAppTobject.APPTStatus
	if APPTStatus="I"{
		s ApptOrderObj.OrderStatus="normal"
	}
	else{
		s ApptOrderObj.OrderStatus="cancel"
	}
	if (CommonFlag=0){
		s ApptOrderObj.OrderApptUser=RBAppTobject.APPTPAPMIDR.PAPMIName
		s ApptOrderObj.PatientNo=$P($G(^PAPER(PatientID,"PAT",1)),"^",2)	////-------登记号
	}
	else{
		s ApptOrderObj.OrderApptUser=DHCRBAppTobject.APPTPatientName
	}
	
	s RBASRowId=$p(APPTRowId,"||",1,2)
	s TRRBASRowId=""
  	s RBASStatusDr=$P(^RBAS(+RBASRowId,$P(RBASRowId,"||",2),"DHC"),"^",10)
 	s RBASStatusCode=$P(^DHCRBCASStatus(RBASStatusDr),"^",1)
 	i (RBASStatusCode="TR") d
 	.s TRRBASRowId=$P(^RBAS(+RBASRowId,$P(RBASRowId,"||",2),"DHC"),"^",12)
 	;如果有替诊则取替诊的信息
	i $G(TRRBASRowId)'="" s RBASRowId=TRRBASRowId
	
	
	s APPTDateComp=$p(^RBAS(+RBASRowId,$p(RBASRowId,"||",2)),"^")
	s ApptOrderObj.AdmitDate=..%ZD(APPTDateComp)
	;w "时间："_ApptOrderObj.AdmitDate,!
	s DeptRowId=$P(^RB("RES",+RBASRowId),"^",1)
	s DepDesc=$p($g(^CTLOC(DeptRowId)),"^",2)
	s DocRowId=$P(^RB("RES",+RBASRowId),"^",2)
	s DocDesc=$P($g(^CTPCP(DocRowId,1)),"^",2)
	
	s ApptOrderObj.Department=DepDesc
	s ApptOrderObj.Doctor=DocDesc
	s SessionTypeDr=$P($G(^RBAS(+RBASRowId,$P(RBASRowId,"||",2),"DHC")),"^",6)
	s SessionTypeDesc=""
	i SessionTypeDr'="" s SessionTypeDesc=$P($G(^RBC("SESS",SessionTypeDr)),"^",2)
	s ApptOrderObj.DoctorTitle=SessionTypeDesc
	s NeedAppFee=##class(web.DHCRBAppointment).NeedAppFee(RBASRowId)
	s FeeStr="1||||0||0"
	i NeedAppFee="1" s FeeStr="1||1||0||1"
	s PatCatDr=$p(^PAPER(PatientID,"PER",1),"^",10)
	s AdmReason=##class(web.DHCOPAdmReg).GetDefaultBillType(PatCatDr)
	s Sum=##class(web.DHCOPAdmReg).GetScheduleFee(RBASRowId,AdmReason,+$H,FeeStr)
	s ApptOrderObj.RegFee=Sum
	s ApptOrderObj.SeqCode=RBAppTobject.APPTQueueNo
	s ApptOrderObj.AdmitAddress=""	//-------候诊地点	
	set SessionTimeID=$P($G(^RBAS(+RBASRowId,$P(RBASRowId,"||",2),"DHC")),"^",17)
	;Set SessionTimeID=##class(web.DHCRBResSession).GetTimeRangeByTime(SessionStartTime)
	if SessionTimeID'="" s SessionTimeName=$P(^DHCTimeRange(SessionTimeID),"^",2)
	s ApptOrderObj.SessionName=$g(SessionTimeName)
	s ApptOrderObj.OrderContent=""	//--------预约单内容
	s ApptOrderObj.AdmitRange=""	///-------候诊时间
	s ApptOrderObj.TelePhoneNo=$P($G(^PAPER(PatientID,"PER",1)),"^",38)
	s ApptOrderObj.MobileNo=$P($G(^PAPER(PatientID,"PER",1)),"^",36)
	if APPTStatus="I"{
		s ApptOrderObj.AllowRefundFlag="Y"
	}
	
	s ResRowId=$P(RBASRowId,"||",1)
	s Childsub=$P(RBASRowId,"||",2)
	s SingleQueueNo=0
	s ASQueueNo=$P($G(^RBAS(ResRowId,Childsub,"DHC")),"^",4)
	s NormalQueueNoStr=$P(ASQueueNo,$C(1),1)
	s AddQueueNoStr=$P(ASQueueNo,$C(1),2)
	s StatusCode=""
	for i=1:1:$l(NormalQueueNoStr,",") {
		s SingleQueueNoStr=$P(NormalQueueNoStr,",",i)
		s SingleQueueNo=$P(SingleQueueNoStr,":",1)
		s SingleQueueNoAPPMethodRowId=$P(SingleQueueNoStr,":",3)
		i (SingleQueueNo=ApptOrderObj.SeqCode) {
			s StatusCode=$P(SingleQueueNoStr,":",2)
		}
	}
	if StatusCode="" {
		 for i=1:1:$l(AddQueueNoStr,",") {
			 s SingleQueueNoStr=$P(AddQueueNoStr,",",i)
			 s SingleQueueNo=$P(SingleQueueNoStr,":",1)
			 ;s SingleQueueNoAPPMethodRowId=$P(SingleQueueNoStr,":",3)
			 i (SingleQueueNo=ApptOrderObj.SeqCode) {
				s StatusCode=$P(SingleQueueNoStr,":",2)
			 }
		 }
	}
	s PayFlag=$s(StatusCode=2:"TB",StatusCode=3:"P",StatusCode=4:"R",1:"")
	s ApptOrderObj.PayFlag=PayFlag
	s ApptOrderObj.HospitalName=RBObject.RESCTLOCDR.CTLOCHospitalDR.HOSPDesc
	s RESClinicGroupDR=$p($g(^RB("RES",+RBASRowId,"DHC")),"^",2)
	s:RESClinicGroupDR'="" RESClinicGroup=$p(^RBC("CLGRP",RESClinicGroupDR),"^",2)
	s ApptOrderObj.ServiceName=$g(RESClinicGroup)	//------亚专业
	
	q ApptOrderObj
}

/// s a=##Class(DHCExternalService.RegInterface.SelfRegMethods).OPAppArrive("<Request><TradeCode>2001</TradeCode><OrderCode>332||2327||14</OrderCode><ExtUserID>APP01</ExtUserID><PatientID>0000201967</PatientID><PayModeCode>CASH</PayModeCode></Request>")
/// <Request><TradeCode>2001</TradeCode><HospitalId></HospitalId><TransactionId></TransactionId><OrderCode>688||65||1</OrderCode><PayDate></PayDate><PayModeCode></PayModeCode><PayTime></PayTime></Request>
/// 请注意该接口已与挂号接口合并，该接口不再继续使用
ClassMethod OPAppArrive(XMLRequest As %String) As DHCExternalService.RegInterface.Entity.SelfAppt.OPAppArriveRp
{
	;s $ZTRAP="OPAppArriveErr"
	s ^TMPNK("OPAppArrive")=XMLRequest
	s InputObj=..GetInputObj("2001",XMLRequest)
	s OutputObj=..GetOutputObj("2001")
	s OutputObj.ResultCode="0"
	s OutputObj.ResultContent=""
	d ..SetOutputCode(.OutputObj,"-1","请注意该接口已与挂号接口合并，该接口不再继续使用,请调用OPRegister挂号接口")
	q OutputObj
	/*
	s APPTRowId=InputObj.OrderCode
	s PatientNo=InputObj.PatientID
	s PayDate=InputObj.PayDate		///-------取his时间为准？
	s PayTime=InputObj.PayTime		///-------
	s TransactionId=InputObj.TransactionId
	s BankTradeInfo=InputObj.BankTradeInfo
	s PayInsuFeeStr=InputObj.PayInsuFeeStr
	;new-add 支付宝、微信挂号银行支付信息
	Set PayDetailsObj=##class(DHCBILL.SelfPay.Entity.CompleteCharge.Req.PayDetails).%New()
    Set PayDetailsObj=InputObj.PayDetails
	Set RBAppTobject =##class(User.RBAppointment).%OpenId(APPTRowId)
	if '$IsObject(RBAppTobject){
		d ..SetOutputCode(.OutputObj,"-1","不存在预约记录.")
		q OutputObj
	}
	s APPTStatus=RBAppTobject.APPTStatus
	if (APPTStatus'="I"){
		d ..SetOutputCode(.OutputObj,"-2",$s(APPTStatus="A":"已取号",APPTStatus="X":"已取消",APPTStatus="J":"已违约",1:"预约状态异常"))
		q OutputObj
	}
	if (PatientNo=""){
		d ..SetOutputCode(.OutputObj,"-3","患者登记号不得为空")
		q OutputObj
	}
	s User=InputObj.ExtUserID
	s UserID=##class(DHCExternalService.RegInterface.GetRelate).GetUser(User,"",HospitalId)
	if (UserID=""){
		d ..SetOutputCode(.OutputObj,"-3","操作员代码不正确或为空") 
		q OutputObj
	}
	s GroupID=##class(DHCExternalService.RegInterface.GetRelate).GetGroup(UserID)
	s PatientID=$O(^PAPERi("PAPMI_PatNo",PatientNo,0))
	if (PatientID=""){
		d ..SetOutputCode(.OutputObj,"-3","检索不到患者记录")
		q OutputObj
	}
	//s CommonPatInfo=##Class(web.DHCOPAdmReg).GetCommonCardInfo()
	//s CommonPatientID=$p(CommonPatInfo,",",2)
	s CommonPatientID=##class(web.DHCOPAdmReg).GetCommonPatientID()
	s APPTPAPMIDR=RBAppTobject.APPTPAPMIDRGetObjectId()
	s CommOPAppArrive=0		///公共卡
	if ((CommonPatientID'="")&&(CommonPatientID=APPTPAPMIDR))
	{
		s CommOPAppArrive=1
	}
	if ((CommOPAppArrive=0)&&(APPTPAPMIDR'=PatientID))
	{
		d ..SetOutputCode(.OutputObj,"-3","非公共卡预约只能本人取号")
		q OutputObj
	}
	
	s PatCatDr=$p(^PAPER(PatientID,"PER",1),"^",10)
	s PatCatDesc=$p(^CT("SS",PatCatDr),"^",2)
	s AdmReason=##class(web.DHCOPAdmReg).GetDefaultBillType(PatCatDr)
	s CardNo=""
	s CFRowID=0 f  s CFRowID=$O(^DHCCARDi("CF",0,"PAPMIDR",PatientID,CFRowID)) q:(CFRowID="")!(CardNo'="")  d
	.s status=$p(^DHCCARD("CF",CFRowID),"^",10) ;CF_ActiveFlag Normal||N  正常 Suspend||S  挂失 Reclaim||R  回收 Depose||D  作废	
	.q:status'="N"
	.s AccRowID=$p(^DHCCARD("CF",CFRowID),"^",2)
	.q:AccRowID=""
	.s CardNo=$p(^DHCCARD("CF",CFRowID),"^",2)
	if (CardNo=""){
		d ..SetOutputCode(.OutputObj,"-110208","患者没有对应有效的卡记录")
		q OutputObj
	}
	s AccInfo=##class(DHCExternalService.RegInterface.RegManager).getaccinfofromcardno(CardNo,"O")
	s rtn=$piece(AccInfo,"^",1)
	s AccRowId=$piece(AccInfo,"^",2)
	s left=$piece(AccInfo,"^",4)
	s PayMode=InputObj.PayModeCode	//预交金支付
	s PayModeCode=##class(DHCExternalService.RegInterface.GetRelate).GetHisPayModeID(PayMode)
	if PayModeCode=""{
		d ..SetOutputCode(.OutputObj,"-110208","系统中未找到此支付方式.")
		q OutputObj
	}
	i PayModeCode'="" d
	.s PayModeCode=$P(^CT("CTPM",PayModeCode),"^",1)
	
	s RBASRowId=$p(APPTRowId,"||",1,2)
	s TRRBASRowId=""
  	s RBASStatusDr=$P(^RBAS(+APPTRowId,$P(APPTRowId,"||",2),"DHC"),"^",10)
 	s RBASStatusCode=$P(^DHCRBCASStatus(RBASStatusDr),"^",1)
 	if (RBASStatusCode="S") {
	 	d ..SetOutputCode(.OutputObj,"-110208","此排班已停诊.")
		q OutputObj
 	}
 	i (RBASStatusCode="TR") d
 	.s TRRBASRowId=$P(^RBAS(+RBASRowId,$P(RBASRowId,"||",2),"DHC"),"^",12)
 	;如果有替诊则取替诊的信息
	i $G(TRRBASRowId)'="" s RBASRowId=TRRBASRowId
	
	
	if (PayModeCode="CPP")
	{
		s DocResValue=##Class(web.DHCOPAdmReg).GetMarkRegFee(RBASRowId,AdmReason,PatientID)
		s TotalFee=$p(DocResValue,"^",12)	//1
		s CheckFee=$p(DocResValue,"^",14)  //2
		s HoliFee=$p(DocResValue,"^",16)  //3
		s AppFee=$p(DocResValue,"^",18)   //4
		s ReCheckFee=$p(DocResValue,"^",15)  //6
		s TotalFee=(+TotalFee)+(+CheckFee)+(+HoliFee)+(+AppFee)+(+ReCheckFee)
		if (PayInsuFeeStr'=""){
			s PayInsuStr=$p(PayInsuFeeStr,"!",2)
			s Length=$Length(PayInsuStr,$c(2))
			f i=1:1:Length
			{
				s Str=$p(PayInsuStr,$c(2),i)
				s InsuPayMode=$p(Str,"^",1)
				i (InsuPayMode="1"){
					s TotalFee=$p(Str,"^",2)
				}
			}
		}
		if (left<TotalFee){
			d ..SetOutputCode(.OutputObj,"-110209","账户余额:"_left_",不足以支付此费用！")
			q OutputObj
		}
	}
	s BankTradeInfo=InputObj.BankTradeInfo
	TS
	if (CommOPAppArrive=1){
		///公共卡取号
		s rtn=##class(web.DHCOPAdmReg).OPAppArriveTransferBroker("","",APPTRowId,CardNo,UserID,GroupID,PayModeCode,AccRowId)
	}else{
		///非公共卡取号
		s rtn=##class(web.DHCOPAdmReg).OPAppArriveBroker("","",APPTRowId,UserID,GroupID,PayModeCode,AccRowId)
	
	}
	s AdmDr=""
	s RegistrationID=""
	if (+rtn=0){
		s OutputObj.ResultCode=0
		if (CommOPAppArrive=0){
			s OutputObj.ResultContent="取号成功"
		}else{
			s OutputObj.ResultContent="转号成功"
		}
		s PrintData=$p(rtn,"$",2)
		s AdmDr=$p(rtn,"$",1)
		s OutputObj.SeqCode=$p(PrintData,"^",8)
		s OutputObj.RegFee=$p(PrintData,"^",17)
		s OutputObj.AdmitRange=$p(PrintData,"^",38)
		s OutputObj.AdmitAddress=$p(PrintData,"^",24)_$p(PrintData,"^",33)
		s DeptName=$p(PrintData,"^",3)
		s DoctorName=$p(PrintData,"^",4)
		s DoctorLevelDesc=$p(PrintData,"^",5)
		s ReceiptNo=$p(PrintData,"^",31)
		s RegistrationID=$p(PrintData,"^",43)
		s TimeRange=$p(PrintData,"^",7)
		s OutputObj.DeptCode=""
		s OutputObj.DeptName=DeptName
		s OutputObj.DoctorCode=""
		s OutputObj.DoctorName=DoctorName
		s OutputObj.DoctorLevelCode=""
		s OutputObj.DoctorLevelDesc=DoctorLevelDesc
		s OutputObj.ReceiptNo=ReceiptNo
		s OutputObj.RegistrationID=RegistrationID
		s OutputObj.TimeRange=TimeRange
	}else{
		s OutputObj.ResultCode=rtn
		s rtn=+rtn
		s:(rtn="-201") errmsg="插入就诊记录失败"
		s:(rtn="-202") errmsg="取就诊号失败"
		s:(rtn="-2121") errmsg="预约状态更新失败"
		s:(rtn="-206") errmsg="PriceArcOrderInsertFail"
		s:(rtn="-207") errmsg="chrhfeeOrderInsertFail"
		s:(rtn="-208") errmsg="holiOrderInsertFail"
		s:(rtn="-209") errmsg="AppOrderInsertFail"
		s:(rtn="-210") errmsg="FailCharge"
		s:(rtn="-211") errmsg="RegFeeInsertFail"
		s:(rtn="-212") errmsg="QueueInsertFail"
		s:(rtn="-220") errmsg="该号已取消"
		s:(rtn="-221") errmsg="该号已取号"
		s:(rtn="-222") errmsg="UpdateStatusFail"
		s:(rtn="-223") errmsg="AppNotExist"
		s:(rtn="-224") errmsg="该医生已停诊"
		s:(rtn="-230") errmsg="只能取当日的号码"
		s:(rtn="-231") errmsg="预约号已失效"
		s errmsg=rtn_"取号失败"_$g(errmsg)
		s OutputObj.ResultContent=errmsg
		TRO
		q OutputObj
	}
	s HospitalId=$o(^CT("HOSP",0))
	s RegOrderFee=+$p($p(rtn,"$",2),"^",17)
	s PayModeDr=$o(^CT("CTPM",0,"Code",PayModeCode,0))
	s JFPayMode=" "_PayModeDr
	if $d(^User.DHCCTPayModeExpI("PMEPayModeIDIndex",JFPayMode)){
		if (RegOrderFee>0) {
			Set TradeType="OP"
			set Papmi=""
			if AdmDr'="" set Papmi=$p(^PAADM(AdmDr),"^",1)
			Set TExpstr=UserID_"^"_GroupID_"^"_""_"^"_HospitalId_"^"_""_"^"_TradeType_"^"_Papmi
			Set InsTraderInfo=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).SetHISTradeNo(CardNo,AdmDr,"","C",RegOrderFee,TExpstr)
			Set RetCode=$p(InsTraderInfo,"^",1)
			if (+RetCode'=0){
		    	do ..SetOutputCode(.OutputObj,"-110226","生成交易流水号失败！")
		    	TRO
				quit OutputObj
		    }
		    Set OrderNo=$p(InsTraderInfo,"^",3)
			Set IBPRowID=$p(InsTraderInfo,"^",2)
			set InvoiceId=$List(^User.DHCRegistrationFeeD(RegistrationID),11)
			;PayDetailsObj 未定义.......... 医生站组织还是第三方传？？？？
			Set RetCode=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).SavePayInfo(OrderNo,InvoiceId,.PayDetailsObj,TExpstr)
			If (RetCode'=0){
				do ..SetOutputCode(.OutputObj,"-110226","保存交易信息失败！"_RetCode)
		    	TRO
				quit OutputObj
			}
		}
	}
	TC
	*/
	q OutputObj
OPAppArriveErr
	if $TLEVEL>0{
    	TRO
	}
	s OutputObj=..GetOutputObj("2001")
	s OutputObj.ResultCode="-1"
	s OutputObj.ResultContent="取号失败"_$ze
	q OutputObj
}

/// w ##class(DHCExternalService.RegInterface.SelfRegMethods).CancelOrder("<Request><TradeCode>1001</TradeCode><ExtOrgCode>02</ExtOrgCode><ClientType>ATM</ClientType><HospitalId>02</HospitalId><ExtUserID>MZ001</ExtUserID><TransactionId></TransactionId><OrderCode>1535||1442||1</OrderCode></Request>")
ClassMethod CancelOrder(Input As %String) As DHCExternalService.RegInterface.Entity.SelfAppt.CancelRegistrationRp
{
	s ^TMPSelfRegXML("Request","CancelOrder")=Input
	s $ZTrap = "CancelOrderET"
	s reader=##class(%XML.Reader).%New()
	s sc=reader.OpenString(Input)
	s ExtUserID="",OrderCode="",HospitalId=""
	d reader.Correlate("Request","DHCExternalService.RegInterface.Entity.SelfAppt.CancelRegistrationRt")
	While reader.Next(.obj,.sc) {
		s ExtUserID=obj.ExtUserID
		s OrderCode=obj.OrderCode
		s HospitalId=obj.HospitalId
	} 
	s HospitalId=##class(DHCExternalService.RegInterface.GetRelate).GetHISHospitalIdFromOuterCode(HospitalId,OrderCode) 
	if HospitalId=""{
		d ..SetOutputCode(.OutputObj,"-100001","请传入正确的院区代码.")
		quit OutputObj	
	}
	s MainObj=##class(DHCExternalService.RegInterface.Entity.SelfAppt.CancelRegistrationRp).%New()
	if (OrderCode=""){
		s MainObj.ResultCode="-1"
		s MainObj.ResultContent="预约记录ID不能为空"
		q MainObj
	}
	s UserID=##class(DHCExternalService.RegInterface.GetRelate).GetUser(ExtUserID,"",HospitalId)
	if UserID="" {
		s MainObj.ResultCode="-1"
		s MainObj.ResultContent="请传入正确的操作用户"
		q MainObj
	}
	TS
	s rtn=##class(web.DHCRBAppointment).CancelAppointment(OrderCode,UserID,HospitalId)
	if (+rtn=0) 
	{
		s MainObj.ResultCode=0
		s MainObj.ResultContent="取消预约成功"
		TC
	}else
	{
		TRO
		s MainObj.ResultCode=1
		s MainObj.ResultContent="取消预约失败,Code:"_rtn
	}
	Quit MainObj 
CancelOrderET
	if $TLEVEL>0{
    	TRO
	}
	s MainObj=##class(DHCExternalService.RegInterface.Entity.SelfAppt.CancelRegistrationRp).%New()
	s MainObj.ResultCode="-1"
	s MainObj.ResultContent=$ze
    Quit MainObj
}

ClassMethod GetAvailSeqNoStrWithOutForm(RBASId As %String, RegType As %String, APPMethodCode As %String = "", ExpStr As %String = "") As %String
{
	;w ##class(DHCExternalService.RegInterface.SelfRegMethods).GetAvailSeqNoStrWithOutForm("332||2343","APP")
	s ^tmpnk("GetAvailSeqNoStrWithOutForm")=RBASId_","_RegType_","_APPMethodCode
	s BankCode="",GroupID="",ClinicGroupDr=""
	if ExpStr'=""{
		s BankCode=$p(ExpStr,"^",1)
		s GroupID=$p(ExpStr,"^",2)
		s ClinicGroupDr=$p(ExpStr,"^",4)
	}
	i APPMethodCode="" d
	.s WinAPPMethodRowId=$O(^RBC("APTM",0,"Code","WIN",0))
	.i WinAPPMethodRowId'="" s APPMethodRowId=WinAPPMethodRowId
	e  s APPMethodRowId=$O(^RBC("APTM",0,"Code",APPMethodCode,0))
	s ResRowId=$P(RBASId,"||",1)
	s Childsub=$P(RBASId,"||",2)
	;无此排班记录
	Q:'$d(^RBAS(ResRowId,Childsub)) "-1"
	s RBASHospId=$p(##class(web.DHCOPAdmReg).GetCurrentHosp("","",RBASId,""),"^",1)
	s AppReturnTime=0
	s TRRowId=$P($G(^RBAS(ResRowId,Childsub,"DHC")),"^",17)
	if TRRowId'="" s AppReturnTime=$p($g(^DHCTimeRange(TRRowId)),"^",5)
	s CurrentTime=..%SysTime()
	
	s ASDate=$P(^RBAS(ResRowId,Childsub),"^",1)
	
	;取预约号信息
	s AppStartSeqNo=$P(^RBAS(ResRowId,Childsub),"^",10)
	;预约限额
	s APPSeqNoCount=$P(^RBAS(ResRowId,Childsub),"^",2)
	;正号限额
	s NormalSeqNoCount=$P(^RBAS(ResRowId,Childsub),"^",8)
	i AppStartSeqNo="" s AppStartSeqNo=0
	i APPSeqNoCount="" s AppStartSeqNo=0
	;加号限额
	s AddSeqNoCount=$P(^RBAS(ResRowId,Childsub,"DHC"),"^",3)
	s ASQueueNo=$P(^RBAS(ResRowId,Childsub,"DHC"),"^",4)
	;正号串与加号串
	s NormalQueueNoStr=$P(ASQueueNo,$C(1),1)
	s AddQueueNoStr=$P(ASQueueNo,$C(1),2)
	 
	Q:(NormalQueueNoStr="")&&((RegType="NOR")||(RegType="APP")) ""
	s AsLoadCount=NormalSeqNoCount
	s AllowAddRegFlag=+(##class(DHCDoc.Interface.Outside.Config).GetConfigNode(GroupID,"AllowAddReg",RBASHospId))
	if AllowAddRegFlag'="1"{
		s AllowAddRegFlag="N"	
	}else{
		s AllowAddRegFlag="Y"	
		s AsLoadCount=AsLoadCount+AddSeqNoCount
	}
	
	s QueueNoStr=##class(web.DHCRBAppointment).GetAvailableSeqNoStr(RBASId,RegType,APPMethodCode,RBASHospId,"","",AllowAddRegFlag,ClinicGroupDr)
	;s ^tmplog("QueueNoStr")=$lb(QueueNoStr,RBASId,RegType,APPMethodCode,RBASHospId,"","",AllowAddRegFlag)
	if QueueNoStr="" s AppAllNumber=0
	else  s AppAllNumber=$l(QueueNoStr,",") ;##class(web.DHCRBAppointment).GetAvailableNum(RBASId,RegType,APPMethodCode,RBASHospId,"","",AllowAddRegFlag)
	s APPSeqNoCount=##class(web.DHCRBAppointment).GetAppSeqNo(RBASId,APPMethodCode,RBASHospId)
	;取可用排号和预约排号,加号排号
	s AvailSeqNoStr=##class(web.DHCRBAppointment).GetAvailableNum(RBASId,RegType,APPMethodCode,RBASHospId,"","",AllowAddRegFlag,ClinicGroupDr)
	i RegType="APP" s QueueNoStr=QueueNoStr_"^"_APPSeqNoCount_"^"_AvailSeqNoStr
	e  s QueueNoStr=QueueNoStr_"^"_AsLoadCount_"^"_AvailSeqNoStr
	;可用号串^总数量^剩余数量
	q QueueNoStr
}

/// s ret=##class(DHCExternalService.RegInterface.SelfRegMethods).BookService("<Request><TradeCode>1000</TradeCode><ExtOrgCode>1001</ExtOrgCode><ClientType>ATM</ClientType><HospitalId>1001</HospitalId><ExtUserID>zzjkgh1</ExtUserID><TransactionId>14111908454781001</TransactionId><ScheduleItemCode>52||1</ScheduleItemCode><CardNo>100000002439</CardNo><CardType>02</CardType><CredTypeCode>01</CredTypeCode><IDCardNo>430781199110083511</IDCardNo><TelePhoneNo></TelePhoneNo><MobileNo></MobileNo><PatientName>兰敏</PatientName><PayFlag></PayFlag><PayModeCode>4</PayModeCode><PayBankCode></PayBankCode><PayCardNo></PayCardNo><PayFee>7</PayFee><PayInsuFee></PayInsuFee><PayInsuFeeStr></PayInsuFeeStr><PayTradeNo></PayTradeNo><LockQueueNo></LockQueueNo><Gender>男</Gender><Address></Address><HISApptID></HISApptID><SeqCode></SeqCode><AdmitRange></AdmitRange><PayTradeStr></PayTradeStr></Request>")
/// w ##class(DHCExternalService.RegInterface.SelfRegMethods).BookService(^TMPBookService("BookService"))
ClassMethod BookService(XMLRequest As %String) As DHCExternalService.RegInterface.Entity.SelfAppt.BookServiceRp
{
	s $ZTRAP="BookServiceErr"
	s ^TMPBookService("BookService")=XMLRequest
	s InputObj=..GetInputObj("1000",XMLRequest)
	s OutputObj=..GetOutputObj("1000")
	s OutputObj.ResultCode="0"
	s OutputObj.ResultContent=""
	s ASRowId=InputObj.ScheduleItemCode
	s InsertQueueNo=InputObj.LockQueueNo
	s ExtUserID=InputObj.ExtUserID
	s HospitalId=InputObj.HospitalId
	s HospitalId=##class(DHCExternalService.RegInterface.GetRelate).GetHISHospitalIdFromOuterCode(HospitalId,ASRowId) 
	if HospitalId=""{
		d ..SetOutputCode(.OutputObj,"-100001","请传入正确的院区代码.")
		quit OutputObj	
	}
	s UserID=##class(DHCExternalService.RegInterface.GetRelate).GetUser(ExtUserID,"",HospitalId)
	if UserID=""{
		d ..SetOutputCode(.OutputObj,"-100002","请传入正确的操作用户.")
		q OutputObj
	}
	s GroupID=##class(DHCExternalService.RegInterface.GetRelate).GetGroup(UserID)
	s BankCode=##class(DHCDoc.Interface.Outside.Config).GetConfigNode(GroupID,"DataCompareExtOrg",HospitalId)
	s CardNo=InputObj.CardNo
	s CardType=##class(DHCExternalService.RegInterface.GetRelate).GetHisCardTypeID(InputObj.CardType,BankCode,"",HospitalId)
	s PatientID=InputObj.PatientID
	s IDCardNo=InputObj.IDCardNo
	s CredTypeCode=InputObj.CredTypeCode
	s PatientName=InputObj.PatientName
	s TelePhoneNo=InputObj.TelePhoneNo
	s Address=InputObj.Address
	s AdmitRange=InputObj.AdmitRange
	if TelePhoneNo="" s TelePhoneNo=InputObj.MobileNo
	s ApptTypeCode=InputObj.ExtOrgCode ;预约机构->预约渠道
	s AppPatInfo=""
	s MethodCode=""
	s AppRegMethodRowID=##class(DHCDoc.Interface.Outside.Config).GetConfigNode(GroupID,"AppRegMethod",HospitalId)
	if AppRegMethodRowID'="" s MethodCode=$P(^RBC("APTM",AppRegMethodRowID),"^",1)
	if MethodCode="" s MethodCode="WIN"
	
	if ApptTypeCode=""{
		d ..SetOutputCode(.OutputObj,"-100002","请传入预约渠道.")
		q OutputObj	
	}else{
		s ApptTypeID=##class(web.DHCRBAppointment).GetApptTypeByCode(ApptTypeCode)
		if ApptTypeID=""{
			d ..SetOutputCode(.OutputObj,"-100002","系统中未获取到相应的预约渠道信息.")
			q OutputObj		
		}
	}
	if (ASRowId="") {
		d ..SetOutputCode(.OutputObj,"-100003","请传入正确的排班ID.")
		q OutputObj
	}
	
	if (PatientID'="")
	{
		s PatientID=$O(^PAPERi("PAPMI_PatNo",PatientID,0))
		if PatientID=""{
			d ..SetOutputCode(.OutputObj,"-100004","患者ID不存在")
			q OutputObj
		}
	}else{
		if ((CardNo="")&&(IDCardNo="")){
			d ..SetOutputCode(.OutputObj,"-100005","卡号与证件号为空，无法确定患者")
			q OutputObj
		}
		if CardNo'=""{
			if CardType=""{
				if BankCode'=""{
					s ResultContent="已启用外部数据对照,但卡类型未对照"
				}else{
					s ResultContent="卡类型为空"	
				}
				d ..SetOutputCode(.OutputObj,"-100006",ResultContent)
				q OutputObj	
			}
			s PatientID=..getPatIDByCardInfo(CardType,CardNo)
			if (PatientID=""){
				d ..SetOutputCode(.OutputObj,"-100007","系统中未找到此卡号.")
				q OutputObj
			}
		}
	}

	s CommonPatientID=##class(web.DHCOPAdmReg).GetCommonPatientID("",HospitalId)
	if (CardNo="")||(($g(PatientID))&&(("^"_CommonPatientID_"^")[("^"_$g(PatientID)_"^"))){
		/*
		s ret=##Class(DHCExternalService.RegInterface.GetRelate).GetPatIDByDVA(IDCardNo,CredTypeCode,PatientName,TelePhoneNo)
		if (+ret=0){
			s PatientID=$p(ret,"^",2)
		}
		else{
			d ..SetOutputCode(.OutputObj,"-1",ret)
			q OutputObj
		}
		*/
		if (PatientName=""){
			d ..SetOutputCode(.OutputObj,"-1","无卡患者预约时，患者姓名不得为空")
			q OutputObj
		}
		if (IDCardNo=""){
			d ..SetOutputCode(.OutputObj,"-1","无卡患者预约时，患者证件号不得为空")
			q OutputObj
		}
		if (TelePhoneNo=""){
			d ..SetOutputCode(.OutputObj,"-1","无卡患者预约时，患者联系方式不得为空")
			q OutputObj
		}
		s AppPatInfo=PatientName_"$"_IDCardNo_"$"_TelePhoneNo_"$"_Address
		//s PatientID=##class(web.DHCOPAdmReg).GetCommonPatientID("",HospitalId)
		if (CommonPatientID)=""{
			d ..SetOutputCode(.OutputObj,"-1","系统未维护公共卡，请联系管理员！")
			q OutputObj
		}
		if ($g(PatientID)="") s PatientID=$p(CommonPatientID,"^",1)
	}else{
		s IsTempCard=##class(web.DHCBL.CARD.UCardRefInfo).GetTemporaryCardFlag(CardType, CardNo)
		if IsTempCard="Y" {
			d ..SetOutputCode(.OutputObj,"-1","临时卡不能进行预约！")
			q OutputObj
		}
		if (PatientID=""){
			d ..SetOutputCode(.OutputObj,"-1","系统中未找到此卡号.")
			q OutputObj
		}
		s BlackFlag=##class(web.DHCRBAppointment).GetLimitAppFlag(PatientID,"",HospitalId)
		if ($p(BlackFlag,"^",1)=1){
			d ..SetOutputCode(.OutputObj,"-1","存在有效黑名单记录,不允许预约.")
			q OutputObj
		}
	}
	/*
	s SessionTypeDr=DHCRBASObj.ASTimeRangeDR.%Id()
	s SessionTypeDesc="",Desc=""
	i SessionTypeDr'="" s SessionTypeDesc=$P($G(^DHCTimeRange(SessionTypeDr)),"^",2)
	s TRRowId=##class(web.DHCRBResSession).GetTimeRangeByTime(..%SysTime())
	s:TRRowId'="" Desc=$P(^DHCTimeRange(TRRowId),"^",2)
	*/
	s AdmDate=$P(^RBAS(+ASRowId,$p(ASRowId,"||",2)),"^",1)
	s TRRowId=$P($G(^RBAS(+ASRowId,$p(ASRowId,"||",2),"DHC")),"^",17)
	if TRRowId'="" s TRDesc=$P(^DHCTimeRange(TRRowId),"^",2)
	s DTRRowId=..GetTimeRangeByTime(..%SysTime())
	s:DTRRowId'="" Desc=$P(^DHCTimeRange(DTRRowId),"^",2)
	if '((+AdmDate)>(+$h)){
		if '($g(Desc)="下午")&&($g(TRDesc)="上午")&&((+AdmDate)=(+$h)){
			d ..SetOutputCode(.OutputObj,"-1","不可预约当日或已失效排班")
			q OutputObj
		}
	}
	if (AdmitRange'="")&&(InsertQueueNo=""){
		s InsertQueueNo=##class(web.DHCLockSchedule).GetSeqNoByTimeRange(ASRowId,AdmitRange,MethodCode)
	}
	
	;w PatientID_","_ASRowId_","_QueueNo_","_ UserID_","_ ""_","_ MethodCode,!
	s ret=##class(web.DHCOPAdmReg).OPAppBroker("","",PatientID , ASRowId , InsertQueueNo, UserID,"", MethodCode,"",HospitalId,"",ApptTypeCode)
	if ($p(ret,"^",1)="0"){
		s APPTRowId=$p(ret,"^",2)
		s QueueNo=$p(ret,"^",3)
		s printData=##class(web.DHCOPAdmReg).GetAppPrintData(APPTRowId)
		s OutputObj.ResultContent="预约成功"
		s OutputObj.OrderCode=APPTRowId
		s OutputObj.SeqCode=$p(printData,"^",8)
		s NeedAppFee=##class(web.DHCRBAppointment).NeedAppFee(APPTRowId)
		s FeeStr="||1||0||0"
		i NeedAppFee="1" s FeeStr="||1||0||1"
		s PatCatDr=$p(^PAPER(PatientID,"PER",1),"^",10)
		s AdmReason=##class(web.DHCOPAdmReg).GetDefaultBillType(PatCatDr)
		s Sum=##class(web.DHCOPAdmReg).GetScheduleFee(APPTRowId,AdmReason,+$H,FeeStr)
		s OutputObj.RegFee=Sum
		s OutputObj.AdmitRange=$p(printData,"^",15)
		s LocDr=$p(^RB("RES",+APPTRowId),"^",1)
		s AdmitAddress=$g(^CTLOC(LocDr,"ADDR",1))
		s OutputObj.AdmitAddress=AdmitAddress
		s OutputObj.OrderContent=printData
		s OutputObj.TransactionId=""
	}
	else{
		s errmsg=""
		if (ret=-201){
			s errmsg="ADMInsertFail"
		}elseif (ret=-202){
			s errmsg="FailGetQueueNo"
		}elseif (ret=2121){
			s errmsg="UpdateAppStatusFail"
		}elseif (ret=-206){
			s errmsg="PriceArcOrderInsertFail"
		}elseif (ret=-207){
			s errmsg="chrhfeeOrderInsertFail"
		}elseif (ret=-208){
			s errmsg="AppOrderInsertFail"
		}elseif (ret=-210){
			s errmsg="FailCharge"
		}elseif (ret=-211){
			s errmsg="RegFeeInsertFail"
		}elseif (ret=-212){
			s errmsg="QueueInsertFail"
		}elseif (ret=-220){
			s errmsg="StatusIsCancel"
		}elseif (ret=-221){
			s errmsg="StatusIsArrival"
		}elseif (ret=-222){
			s errmsg="UpdateStatusFail"
		}elseif (ret=-302){
			s errmsg="超过每人每天挂相同医生限额"
		}
		elseif (ret=-223){
			s errmsg="AppNotExist"
		}
		elseif (ret=-230){
			s errmsg="UpdateFile"
		}
		d ..SetOutputCode(.OutputObj,"-1","预约失败"_ret_errmsg)
		q OutputObj
	}
	
	q OutputObj
BookServiceErr
	if $TLEVEL>0{
    	TRO
	}
	s OutputObj=..GetOutputObj("1000")
	s OutputObj.ResultCode="-1"
	s OutputObj.ResultContent="预约失败"_$ze
	q OutputObj
}

/// <Request><ExtUserID>MZ001</ExtUserID><CardType>03</CardType><CardNo>010000737032</CardNo><ScheduleItemCode>1551||1998</ScheduleItemCode></Request>
ClassMethod GetInsuRegPara(XMLRequest As %String) As DHCExternalService.RegInterface.Entity.SelfReg.GetInsuRegParaRq
{
	;s ret=##class(DHCExternalService.RegInterface.SelfRegMethods).GetInsuRegPara("<Request><ExtUserID>SF01</ExtUserID><PatientID>0000000005</PatientID><CardType></CardType><CardNo></CardNo><PayModeCode>CASH</PayModeCode><BillTypeID>33</BillTypeID><ScheduleItemCode>2||256</ScheduleItemCode></Request>")
	s $ZTRAP="GetInsuRegParaErr"
	s ^tmp("GetInsuRegPara")=XMLRequest
	s InputObj=..GetInputObj("1105",XMLRequest)
	s OutputObj=..GetOutputObj("1105")
	s ExtUserID=InputObj.ExtUserID
	s PatientCard=InputObj.CardNo
	s ScheduleItemCode=InputObj.ScheduleItemCode
	s CardType=InputObj.CardType
	s PatientID=InputObj.PatientID
	s BillTypeID=InputObj.BillTypeID
	s CardData=InputObj.InsuCardData			//医保卡信息
	s PayModeCode=InputObj.PayModeCode
	s HospitalId=InputObj.HospitalId
	s HospitalId=##class(DHCExternalService.RegInterface.GetRelate).GetHISHospitalIdFromOuterCode(HospitalId,ScheduleItemCode) 
	if HospitalId=""{
		d ..SetOutputCode(.OutputObj,"-100","请传入正确的院区代码.")
		quit OutputObj	
	}
	s UserID=##class(DHCExternalService.RegInterface.GetRelate).GetUser(ExtUserID,"",HospitalId)
	if (UserID=""){
		d ..SetOutputCode(.OutputObj,"-100","请传入正确的操作用户.")
		q OutputObj
	}
	s GroupID=##class(DHCExternalService.RegInterface.GetRelate).GetGroup(UserID)
	s BankCode=##class(DHCDoc.Interface.Outside.Config).GetConfigNode(GroupID,"DataCompareExtOrg",HospitalId)
	s CardType=##class(DHCExternalService.RegInterface.GetRelate).GetHisCardTypeID(InputObj.CardType,BankCode,"",HospitalId)
	if (PatientID="")&&(PatientCard=""){
		d ..SetOutputCode(.OutputObj,"-110501","请传入患者唯一ID或卡号查询")
		q OutputObj
	}
	if (PatientID'="")
	{
		set PatientID=$Order(^PAPERi("PAPMI_PatNo",PatientID,0))
		if PatientID=""{
			d ..SetOutputCode(.OutputObj,"-110502","患者ID不存在")
			q OutputObj
		}
	}
	elseif PatientCard'=""
	{
		s PatientID=..getPatIDByCardInfo(CardType,PatientCard)
		if (PatientID)=""{
			d ..SetOutputCode(.OutputObj,"-110503","系统中未找到此卡号.")
			q OutputObj
		}
	}
	if (PatientID=""){
		d ..SetOutputCode(.OutputObj,"-110504","无此患者信息")
		q OutputObj
	}
	if (ScheduleItemCode=""){
		d ..SetOutputCode(.OutputObj,"-110505","排班记录不得为空")
		q OutputObj
	}
	s PayModeCode=##class(DHCExternalService.RegInterface.GetRelate).GetHisPayModeID(PayModeCode,BankCode)
	if PayModeCode=""{
		d ..SetOutputCode(.OutputObj,"-110506","系统中未找到此支付方式.")
		q OutputObj
	}
	i PayModeCode'=""{
		s PayModeCode=$P(^CT("CTPM",PayModeCode),"^",1)
	}
	s RBASRowId=ScheduleItemCode
	if BillTypeID'=""{
		s AdmReason=BillTypeID
		if '$d(^PAC("ADMREA",AdmReason)){
			d ..SetOutputCode(.OutputObj,"-110507","HIS系统中未找到该就诊结算费别信息")
			q OutputObj
		}
		s AdmReasonAdmSource=##class(web.DHCDocOrderCommon).GetInsurFlag(AdmReason)
	}else{
		s DefaultBillType=..GetDefaultBillTypeStr(PatientID)
		s AdmReason=$p(DefaultBillType,"^",1)
		s AdmReasonAdmSource=$p(DefaultBillType,"^",2)
	}
	
	if ('$d(^RBAS(+RBASRowId,$P(RBASRowId,"||",2)))){
		d ..SetOutputCode(.OutputObj,"-1","无此排班")
		q OutputObj
	}
	s Name=$p(^PAPER(PatientID,"ALL"),"^",1)
	s DepDr=+$g(^RB("RES",+RBASRowId))
	s DepCode=$p($g(^CTLOC(DepDr)),"^",1)
	s DepDesc=$p($g(^CTLOC(DepDr)),"^",2)
	s DocRowId=$P(^RB("RES",+RBASRowId),"^",2)
	s DocDesc=$P($g(^CTPCP(DocRowId,1)),"^",2)
	s DocResValue=##Class(web.DHCOPAdmReg).GetMarkRegFee(RBASRowId,AdmReason,PatientID)
	s RegFeeDr=0,CheckFee=0,ReCheckFee=0,OtherFee=0,HoliFeeDr=0,AppFeeDr=0,MRFee=0,CardFee=0
	s RegFee=+$p(DocResValue,"^",12)
	s CheckFee=+$p(DocResValue,"^",14)
	s HoliFee=+$p(DocResValue,"^",16)
	s AppFee=+$p(DocResValue,"^",18)
	s ReCheckFee=+$p(DocResValue,"^",15)
	s OtherFee=+$p(DocResValue,"^",20)
	s TotalAmount=+(RegFee+CheckFee+HoliFee+AppFee+ReCheckFee+OtherFee)
	s FeeStr=TotalAmount_"||"_CheckFee_"||"_HoliFee_"||"_AppFee_"||"_MRFee_"||"_ReCheckFee_"||"_CardFee
	s RegType=""
	s InsuJoinType=""
	s InsuJoinType="", FreeRegFeeFlag="", InsuReadCardInfo="", RetInsuGSInfo=""
	s AccRowId="",GHLY="",RegConDisId=""
	s ExpString=AccRowId_"^"_PayModeCode_"^"_GroupID_"^"_GHLY_"^"_RegConDisId
	s InsuBillParaString=##class(web.DHCOPAdm).GetInsuBillPara(DepDr,DocRowId,PatientID,Name,UserID, RBASRowId, AdmReason,FeeStr,RegType, InsuJoinType, FreeRegFeeFlag, InsuReadCardInfo , RetInsuGSInfo,ExpString)
	;AdmType_"^"_PatName_"^"_TotalAmount_"^"_LocCode_"^"_UserId_"^"_DocCode_"^"_InsuNo_"^"_CardType_"^"_YLLB_"^"_DiagCode_"^"_DiagDesc_"^"_GHLY_"!"_TarItemStr
	;就诊类型^患者姓名^总金额^挂号科室代码^用户ID^挂号医生代码^医保号^类型^医疗类别^诊断代码^诊断名称^挂号类别!
	s ExpString=InsuBillParaString
	
	;if ((AdmReasonAdmSource'="")&&((+AdmReasonAdmSource=1)||(+AdmReasonAdmSource=5))&&(TotalAmount'="0")){
	if ((+AdmReasonAdmSource>0)&&(TotalAmount'="0")){
		s OutputObj.ResultCode="0"
		s OutputObj.ResultContent=""
		s OutputObj.AdmReasonAdmSource=AdmReasonAdmSource
		s OutputObj.AdmReason=AdmReason
		s OutputObj.Handle=0
		s OutputObj.UserID=UserID
		s OutputObj.PAAdmID=""
		s ExpString=##class(web.DHCINSUFacade).TransforRegInfo(ExpString,AdmReason)
		s OutputObj.ExpString=ExpString
	}
	else {
		d ..SetOutputCode(.OutputObj,"100","自费患者类型无需进行医保挂号")
		q OutputObj
	}
	q OutputObj
GetInsuRegParaErr
	s OutputObj=..GetOutputObj("-1105")
	s OutputObj.ResultCode="-1"
	s OutputObj.ResultContent="查询失败："_$ze
	q OutputObj
}

/// /w ##Class(DHCExternalService.RegInterface.SelfRegMethods).getPatIDByCardInfo(1,"001000004659")
ClassMethod getPatIDByCardInfo(CardType As %String, cardno As %String) As %String
{
	q:(CardType="")||(cardno="") ""
	s PAPMIID=""
	s cardid=0 f  s cardid=$o(^DHCCARDi("CF",0,"CardNo",cardno,cardid)) q:(cardid="")  d
	.s ActiveFlag=$p(^DHCCARD("CF",cardid),"^",10)
	.q:ActiveFlag'="N"
	.s CFCardTypeDR=$p(^DHCCARD("CF",cardid),"^",16)
	.q:(CardType'="")&&(CFCardTypeDR'=CardType)
	.s PAPMIID=$p(^DHCCARD("CF",cardid),"^",4)
	
	q PAPMIID
}

ClassMethod GetDefaultBillTypeStrByPatNo(PatientNo As %String) As %String
{
	s PatientID=$o(^PAPERi("PAPMI_PatNo",PatientNo,0))
	s Str=..GetDefaultBillTypeStr(PatientID)
	q Str
}

ClassMethod GetDefaultBillTypeStr(PatientID As %String) As %String
{
	s PatCatDr=$p(^PAPER(PatientID,"PER",1),"^",10)
	set AdmReason=""
	i PatCatDr'="" set DHCPACADMDr=$o(^DHCPACADM(0,"Social",PatCatDr,""))
	i $g(DHCPACADMDr)'="" set AdmReason=$p(^DHCPACADM(DHCPACADMDr),"^",2)
	Set AdmReasonSource=""
	if AdmReason'="" do
	.Set AdmReasonSource=$p(^PAC("ADMREA",AdmReason),"^",9)
	.//Set AdmReasonDesc=$p($g(^PAC("ADMREA",PACAdmReasonDr)),"^",2)
	Q AdmReason_"^"_AdmReasonSource
}

/// w ##Class(DHCExternalService.RegInterface.SelfRegMethods).OPRegReturn("<Request><AdmNo>714</AdmNo><ExtUserID>sf01</ExtUserID></Request>")
/// <Request><AdmNo>714</AdmNo><ExtUserID>sf01</ExtUserID></Request>
ClassMethod OPRegReturn(XMLRequest As %String) As DHCExternalService.RegInterface.Entity.SelfReg.OPRegReturnRp
{
	s ^TMPSelfRegXML("Request","OPRegReturn")=XMLRequest
	s $ZTRAP="OPRegReturnET"
	s InputObj=..GetInputObj("1003",XMLRequest)
	s OutputObj=..GetOutputObj("1003")
	s ExtUserID=InputObj.ExtUserID
	s AdmNo=InputObj.AdmNo
	s TransactionId=InputObj.TransactionId
	s TerminalID=InputObj.TerminalID
	s BankNo=InputObj.BankNo
	s BankTradeNo=InputObj.BankTradeNo
	s RefundType=InputObj.RefundType
	s PayOrdId=InputObj.PayOrderId
	s HospitalId=InputObj.HospitalId
	s HospitalId=##class(DHCExternalService.RegInterface.GetRelate).GetHISHospitalIdFromOuterCode(HospitalId) 
	if HospitalId=""{
		d ..SetOutputCode(.OutputObj,"-100","请传入正确的院区代码.")
		quit OutputObj	
	}
	s UserID=##class(DHCExternalService.RegInterface.GetRelate).GetUser(ExtUserID,"",HospitalId)
	if UserID="" {
		d ..SetOutputCode(.OutputObj,"-10031","请传入正确的操作用户.")
		q OutputObj
	}
	if AdmNo="" {
		if TransactionId=""{
			d ..SetOutputCode(.OutputObj,"-10032","就诊流水号与His交易流水号不能都为空")
			q OutputObj
		}
	}
	if (BankNo'="")||(BankTradeNo'=""){
		d ..SetOutputCode(.OutputObj,"-10033","暂不支持银联退款")
		q OutputObj
	}
	s RegFeeRowId=""
	if AdmNo'=""{
		s RegFeeRowId=$O(^User.DHCRegistrationFeeI("ADM",AdmNo,""))
	}elseif TransactionId'=""{
		s CTLSRowID=$o(^CTLS(0,"HISTradNo",TransactionId,""))
		if (CTLSRowID'=""){
			s Activity=$p(^CTLS(CTLSRowID),"^",7)
			if (Activity="Y"){
				s AdmNo=$p(^CTLS(CTLSRowID),"^",9)
				if (AdmNo'=""){
					s RegFeeRowId=$o(^User.DHCRegistrationFeeI("ADM",AdmNo,""))
				}
			}
		}
	}
	if RegFeeRowId="" {
		d ..SetOutputCode(.OutputObj,"-10034","挂号记录不存在")
		q OutputObj	
	}
	s GroupID=##class(DHCExternalService.RegInterface.GetRelate).GetGroup(UserID)
	s DefaultLoc=##class(DHCExternalService.RegInterface.GetRelate).GetLoc(UserID)
	s AdmHospitalId=##class(DHCDoc.Common.Hospital).GetAdmHospitalId(AdmNo)
	s Msg=##class(DHCExternalService.RegInterface.RegManager).CheckCancelOPRegist(AdmNo,GroupID,HospitalId)
	if Msg'=""{
		d ..SetOutputCode(.OutputObj,"-10034",Msg)
		q OutputObj	
	}
	s InvoiceId=$List(^User.DHCRegistrationFeeD(RegFeeRowId),11)
	s Sum=0
	s NewInvoiceId="",PayMode="",PayModeCode=""
	i InvoiceId'=""{
		s Sum=$P(^DHCINVPRT(InvoiceId),"^",1)
		s PayMode=$p($g(^DHCINVPRT(InvoiceId,"P",1)),"^")   
        s:PayMode'="" PayModeCode=$p(^CT("CTPM",PayMode),"^",1)
	}

	TS
	s myRtn=##class(web.DHCOPAdmReg).CancelOPRegist(RegFeeRowId,UserID,GroupID,DefaultLoc,.NewInvoiceId,"","",HospitalId)
	if $l(myRtn,"^")>1{
		s rtn=$p(myRtn,"^",1)	
	}else{
		s rtn=myRtn	
	}
	if (rtn'=0) 
	{
		TRO
		s ErrMsg=""
		if (rtn="diagnos"){
			s ErrMsg="已下诊断，不可退号"
		}elseif (rtn="cancel"){
			s ErrMsg="已退号"
		}elseif (rtn="overtime"){
			s ErrMsg="已过退号时间"
		}elseif (rtn="-200"){
			s ErrMsg="退费失败"
		}elseif (rtn="-204"){
			s ErrMsg="更新部分退费失败"
		}elseif (rtn="-201"){
			s ErrMsg="回置状态失败"
		}elseif (rtn="-210"){
			s ErrMsg="回退号源失败"
		}elseif (rtn="-202"){
			s ErrMsg="重置队列状态失败"
		}
		if ErrMsg="" s ErrMsg=rtn
		s OutputObj.ResultCode="-10036"
		s OutputObj.ResultContent="退号失败,"_ErrMsg
	}else{
		s HisTradeNo=""
		s ReturnFee=Sum
		if (NewInvoiceId'=""){
			s ReSum=$P(^DHCINVPRT(NewInvoiceId),"^",1)
			s ReturnFee=Sum-ReSum
		}
		
		set INVIdStr=##class(web.DHCOPAdmRegPay).GetMisposINVIdStr(RegFeeRowId)
		set ReceipRowid=$p(INVIdStr,"^",1)
		set StrikeRowID=$p(INVIdStr,"^",2)
		set myPRTRowID=$p(INVIdStr,"^",3)
		
		set TradeType="OP"
		;操作员ID^安全组^科室^院区^卡号^退费原因
		set TExpstr=UserID_"^"_GroupID_"^^"_HospitalId_"^^"
		set RefundRtn=##class(DHCBILL.SelfPay.BLL.DHCOPBillPayLogic).RefundAll("OP",InvoiceId,StrikeRowID,NewInvoiceId,"",TExpstr)
		;s ^tmplog("RefundAll")=$lb("OP",InvoiceId,StrikeRowID,NewInvoiceId,"",TExpstr,RefundRtn)
		set RefundCode=$p(RefundRtn,"^",1)
		set RefundMsg=$p(RefundRtn,"^",2)
		if (+RefundCode'=0){
	    	do ..SetOutputCode(.OutputObj,"-10037","退费失败:"_RefundMsg)
	    	TRO
			quit OutputObj
	    }
		Tc
		d ..SetOutputCode(.OutputObj,"0","退号成功")
		s OutputObj.ReturnFee=ReturnFee
		s OutputObj.HisTradeNo=HisTradeNo
	}
	Quit OutputObj 
OPRegReturnET
	if $TLEVEL>0{
    	TRO
	}
	s OutputObj=##class(DHCExternalService.RegInterface.Entity.SelfReg.OPRegReturnRp).%New()
	s OutputObj.ResultCode="-10030"
	s OutputObj.ResultContent=$Replace($Replace($ze,"<","!!"),">","!!")
    Quit OutputObj
}

/// 报到机接口---该接口已弃用，请使用DHCExternalService.OPAlloc.Service.OPAllocService
/// s ret=##ClassMethod(DHCExternalService.RegInterface.SelfRegMethods).OPPatArrive("")
ClassMethod OPPatArrive(XMLRequest As %String) As DHCExternalService.RegInterface.Entity.SelfReg.OPPatArriveRp
{
	s ^TMPSelfRegXML("Request","OPPatArrive")=XMLRequest
	s $ZTRAP="OPPatArriveErr"
	s OutputObj=##Class(DHCExternalService.RegInterface.Entity.SelfReg.OPPatArriveRp).%New()
	d ..SetOutputCode(.OutputObj,"-1","报到失败,该接口已弃用")
	q OutputObj
OPPatArriveErr
	s OutputObj=##Class(DHCExternalService.RegInterface.Entity.SelfReg.OPPatArriveRp).%New()
	s OutputObj.ResultCode=-1
	s OutputObj.ResultContent="报到失败:"_$ZERROR
	q OutputObj
}

/// /##class(DHCExternalService.RegInterface.SelfRegMethods).GetFrontNum()
ClassMethod GetFrontNum(AdmRowid As %String) As %String
{
	Set LocID=$p(^PAADM(AdmRowid),"^",4)
	Set DoctorId=$p(^PAADM(AdmRowid),"^",9)
	Set RegDate=$zd($p(^PAADM(AdmRowid),"^",41),3)
	s FrontNum=1
	
	Set QueDr=0
	For  Set QueDr=$O(^User.DHCQueueI("QueDateDeptIndex",+$H,LocID,QueDr)) Quit:((QueDr="")||($g(PAAdm)=AdmRowid))  Do
	.Set QueObj=##Class(User.DHCQueue).%OpenId(QueDr)
	.Set QuitFlag=0
	.Set QueConsultArea=QueObj.QueExabDrGetObjectId()
	.Set QueMark=QueObj.QueMarkDrGetObjectId()
	.Set QueStatus=QueObj.QueStateDr.PersName
	.If (QueStatus="到达") Set QuitFlag=1
	.If QueStatus="退号" Set QuitFlag=1
	.If QueStatus="报到" Set QuitFlag=1
	.Set PAAdm=QueObj.QuePaadmDrGetObjectId()
	.If (PAAdm="")!('$D(^PAADM(PAAdm))) Set QuitFlag=1
	.Set AdmDoctor=$P($g(^PAADM(PAAdm)),"^",9)
	.If (DoctorId'=QueObj.QueDocDrGetObjectId())&(QueObj.QueDocDrGetObjectId()'="") Set QuitFlag=1
	.Do QueObj.%Close()
	.Quit:QuitFlag=1
	.s FrontNum=FrontNum+1
	
	q FrontNum
}

/// /##class(DHCExternalService.RegInterface.SelfRegMethods).QueryStopDoctorInfo(^TMPSelfRegXML("Request","QueryDoctor"))
ClassMethod QueryStopDoctorInfo(XMLRequest As %String) As DHCExternalService.RegInterface.Entity.SelfReg.QueryStopDoctorRp
{
	s ^TMPSelfRegXML("Request","QueryDoctor")=XMLRequest
	s $ZTRAP="QueryStopDoctorErr"
	s RecordCount=0
	s InputObj=..GetInputObj("1107",XMLRequest)
	s DepartmentCode=InputObj.DepartmentCode
	s StartDate=InputObj.StartDate
	s EndDate=InputObj.EndDate
	s HospitalId=InputObj.HospitalId
	s OutputObj=..GetOutputObj("1107")
	s OutputObj.ResultCode="0"
	s OutputObj.ResultContent=""
	s HospitalId=##class(DHCExternalService.RegInterface.GetRelate).GetHISHospitalIdFromOuterCode(HospitalId) 
	if HospitalId=""{
		d ..SetOutputCode(.OutputObj,"-100","请传入正确的院区代码.")
		quit OutputObj	
	}
	s UserID=##class(DHCExternalService.RegInterface.GetRelate).GetUser(InputObj.ExtUserID,"",HospitalId)
	i (StartDate="")!(EndDate=""){
		d ..SetOutputCode(.OutputObj,"110701","开始日期或者结束日期不能为空.")
		q OutputObj	
	}
	i (StartDate'["-")!(EndDate'["-"){
		d ..SetOutputCode(.OutputObj,"110702","开始日期或者结束日期格式不正确.")
		q OutputObj	
	}
	i (EndDate-StartDate)>30{
		d ..SetOutputCode(.OutputObj,"110703","查询周期不能超过30天.")
		q OutputObj	
	}
	i (EndDate-StartDate)<0{
		d ..SetOutputCode(.OutputObj,"110704","开始日期不能小于结束日期.")
		q OutputObj	
	}
	s StartDate=$zdh(StartDate,3)
	s EndDate=$zdh(EndDate,3)
	if (StartDate<+$h){
		d ..SetOutputCode(.OutputObj,"110704","开始日期不能小于当天.")
		q OutputObj	
	}
	Set rs=##class(%ResultSet).%New("DHCExternalService.RegInterface.SelfRegQueryMetods:FindRBAS")
	Set Status=0
	If rs.QueryIsValid() { 
		Set Status=rs.Execute(DepartmentCode,"",StartDate,EndDate,HospitalId)
		If 'Status Quit
		While rs.Next() {
			set ServiceDate=rs.GetData(3)
			set DepartmentCode=rs.GetData(4)
			set DepartmentName=rs.GetData(5)
			set ScheduleItemCode=rs.GetData(13)
			set TimeRangeCode=rs.GetData(11)
			set TimeRangeName=rs.GetData(12)
			set StartTime=""
			set EndTime=""
			set DoctorCode=rs.GetData(6)
			set DoctorName=rs.GetData(7)
			set Reason=rs.GetData(8)
			set OrderId=""
			set ReplaceDoctorId=rs.GetData(10)
			set ReplaceDoctorName=rs.GetData(9)
			set TimeRange=$P($g(^RBAS(+ScheduleItemCode,$p(ScheduleItemCode,"||",2),"DHC")),"^",17)
			set TimeRangeStartTime=""
			set TimeRangeEndTime=""
			if TimeRange'=""{
				set TimeRangeStartTime=$p(^DHCTimeRange(TimeRange),"^",3)
				set TimeRangeStartTime=..%ZT(TimeRangeStartTime,2)
	 			set TimeRangeEndTime=$p(^DHCTimeRange(TimeRange),"^",4)
	 			set TimeRangeEndTime=..%ZT(TimeRangeEndTime,2)
			}
			Set StopScheduleObj=##Class(DHCExternalService.RegInterface.Entity.SelfReg.List.StopSchedule).%New()
			Set StopScheduleObj.ScheduleCode=ScheduleItemCode
			Set StopScheduleObj.ServiceDate=ServiceDate
			Set StopScheduleObj.TimeRangeName=TimeRangeName
			Set StopScheduleObj.TimeRangeCode=TimeRangeCode
			Set StopScheduleObj.StartTime=StartTime
			Set StopScheduleObj.EndTime=EndTime
			Set StopScheduleObj.DepartmentCode=DepartmentCode
			Set StopScheduleObj.DepartmentName=DepartmentName
			Set StopScheduleObj.DoctorCode=DoctorCode
			Set StopScheduleObj.DoctorName=DoctorName
			Set StopScheduleObj.Reason=Reason
			Set StopScheduleObj.OrderId=OrderId
			Set StopScheduleObj.ReplaceDoctorId=ReplaceDoctorId
			Set StopScheduleObj.ReplaceDoctorName=ReplaceDoctorName
			set StopScheduleObj.StartTime=TimeRangeStartTime
			set StopScheduleObj.EndTime=TimeRangeEndTime
			Do OutputObj.Schedules.Insert(StopScheduleObj)
			Do StopScheduleObj.%Close()
			Set RecordCount=RecordCount+1
		}
	}
	s OutputObj.RecordCount=RecordCount
	if (RecordCount=0){
		s OutputObj.ResultContent="未查询到停诊记录"
	}else{
		s OutputObj.ResultContent="查询成功"	
	}
	q OutputObj
QueryStopDoctorErr
	s OutputObj=..GetOutputObj("1107")
	s OutputObj.ResultCode="-1"
	s OutputObj.ResultContent="QueryStopDoctorInfo调用异常"_$ZERROR
	q OutputObj
}

/// w ##class(DHCExternalService.RegInterface.SelfRegMethods).QueryRegStatus("<Request><TradeCode>1108</TradeCode><ExtOrgCode></ExtOrgCode><ClientType></ClientType><HospitalId></HospitalId><ExtUserID></ExtUserID><PatientCard></PatientCard><CardType></CardType><PayOrdId>Z700120131001190947</PayOrdId><IDNo></IDNo><PatienName></PatienName></Request>")
ClassMethod QueryRegStatus(XMLRequest As %String) As DHCExternalService.RegInterface.Entity.SelfReg.QueryRegStatusRp
{
	s ^TMPSelfRegXML("Request","QueryRegStatus")=XMLRequest
	set $ZTRAP="QueryRegStatusErr"
	set InputObj=..GetInputObj("1108",XMLRequest)
	set PayOrdId=InputObj.PayOrdId
	set PatienName=InputObj.PatienName
	set PatientID=InputObj.PatientID
	set HospitalId=InputObj.HospitalId
	set IDNo=InputObj.IDNo
	set CardType=InputObj.CardType
	set PatientCard=InputObj.PatientCard
	set TransactionId=InputObj.TransactionId
	set OutputObj=..GetOutputObj("1108")
	set OutputObj.ResultCode="0"
	set OutputObj.ResultContent=""
	s HospitalId=##class(DHCExternalService.RegInterface.GetRelate).GetHISHospitalIdFromOuterCode(HospitalId) 
	if HospitalId=""{
		d ..SetOutputCode(.OutputObj,"-100","请传入正确的院区代码.")
		quit OutputObj	
	}
	set UserID=##class(DHCExternalService.RegInterface.GetRelate).GetUser(InputObj.ExtUserID,"",HospitalId)
	if UserID=""{
		d ..SetOutputCode(.OutputObj,"-100","请传入正确的操作用户.")
		quit OutputObj	
	}
	if TransactionId="" s TransactionId=PayOrdId
	if TransactionId="" d ..SetOutputCode(.OutputObj,"-110801","订单号不能为空.") q OutputObj
	s RegFeeId=""
	s PayOrdId=$zcvt(PayOrdId,"U")
	s CTLSRowID=$o(^CTLS(0,"HISTradNo",TransactionId,""))
	if (CTLSRowID'=""){
		s CTScheduleId=$p(^CTLS(CTLSRowID),"^",2)
		s AdmDepId=$P($G(^RB("RES",+CTScheduleId)),"^",1)
		s AdmDepHospId=$p(^CTLOC(AdmDepId),"^",22)
		if (HospitalId'=AdmDepHospId) {
			d ..SetOutputCode(.OutputObj,"-100","非当前院区的订单，不能操作！")
			quit OutputObj
		}
		s Activity=$p(^CTLS(CTLSRowID),"^",7)
		if (Activity="Y"){
			set ADMDr=$p(^CTLS(CTLSRowID),"^",9)
			if (ADMDr'=""){
				s RegFeeId=$o(^User.DHCRegistrationFeeI("ADM",ADMDr,""))
			}
			if RegFeeId="" {
				s QueueNoActive=##class(web.DHCLockSchedule).CheckQueueNoActive(TransactionId,"","","")
				s QueueNoActiveFlag=$p(QueueNoActive,"^",1)
				s QueueNoActiveStr=$p(QueueNoActive,"^",2)
				if QueueNoActiveFlag'=1{
					if (QueueNoActiveFlag="Reg"){
						set OutputObj.ResultCode="0"
						set OutputObj.Status="2"
						set OutputObj.ResultContent="该号已支付."	
					}elseif (QueueNoActiveFlag="OutActiveTime"){
						set OutputObj.ResultCode="0"
						set OutputObj.Status="-1"
						set OutputObj.ResultContent="该号超时未支付,已被系统自动失效"	
					}elseif (QueueNoActiveFlag="NotSamePerson"){
						set OutputObj.ResultCode="0"
						set OutputObj.Status="-1"
						set OutputObj.ResultContent="该号已被他人锁定"		
					}else{
						set OutputObj.ResultCode="0"
						set OutputObj.Status="-1"
						set OutputObj.ResultContent="该订单已失效"		
					}
		
				}else{
					set OutputObj.ResultCode="0"
					set OutputObj.Status="1"
					set OutputObj.ResultContent="该正常订单未支付"	
				}	
			}else{
				set TradeID=""
				set AdmStatus="2"
				set ret=##class(web.DHCOPAdmReg).GetPrintData(RegFeeId)
				set OutputObj.ResultCode="0"
				set OutputObj.ResultContent="该订单已支付"	
				set ADMDr=$P(ret,"^",1)
				set SeqCode=$P(ret,"^",8) ;挂号序号
				set RegFee=$P(ret,"^",17) ;费用
				set RegFee=$tr(RegFee," ","")
				set RegFee=+RegFee
				set RegFee=RegFee*100
				set AdmitRange=$P(ret,"^",7) ;时段信息
				set RBAS=$P(ret,"^",23) ;
				if ADMDr'="" {
					set CLRowID=$o(^CTLS(0,"AdmDr",ADMDr,""))
					if CLRowID'="" set TradeID=$p($g(^CTLS(CLRowID)),"^",8)
					set PaadmStatus=$p($G(^PAADM(ADMDr)),"^",20)
					if PaadmStatus'="A"{
						 set AdmStatus="4"
					}else {
						set mradm=##Class(web.DHCPAADM).GetMRAdmID(ADMDr)
						s kid=""
						s Childsub=0 f{
					    	s Childsub=$o(^MR(mradm,"DIA",Childsub)) q:Childsub=""
							s kid=mradm_"||"_Childsub
						}
						if kid'="" set AdmStatus="3"
					}
			
				}
				set OutputObj.SeqCode=SeqCode
				set OutputObj.RegFee=RegFee
				set OutputObj.AdmitRange=AdmitRange
				set OutputObj.Status=AdmStatus
				set OutputObj.AdmitAddress=##class(DHCExternalService.RegInterface.SynVisitSchedule).GetAdmitAddress(RBAS)
				set OutputObj.TransactionId=TradeID
				;set OutputObj.PayOrderId=PayOrdId
			}
		}else{
			set OutputObj.ResultCode="0"
			set OutputObj.Status="-1"
			set OutputObj.ResultContent="该订单已失效"
		}
	}else{
		set OutputObj.ResultCode="0"
		set OutputObj.Status="-1"
		set OutputObj.ResultContent="未查询到该订单信息"
	}
	quit OutputObj
QueryRegStatusErr
	set OutputObj=..GetOutputObj("1108")
	set OutputObj.ResultCode="-110800"
	set OutputObj.ResultContent="QueryRegStatus调用异常"_$ZERROR
	quit OutputObj
}

/// w ##class(DHCExternalService.RegInterface.SelfRegMethods).QueryPatList(^TMPSelfRegXML("Request","QueryPatList"))
/// 查询患者候诊排队信息
/// 该接口调用了Query:web.DHCDocOutPatientList:FindLocDocCurrentAdm 程序中取Sessio值会报错，注意修改
ClassMethod QueryPatList(XMLRequest As %String) As DHCExternalService.RegInterface.Entity.SelfReg.QueryPatListRp
{
	s $ZTrap = "QueryPatListET"
	s ^TMPSelfRegXML("Request","QueryPatList")=XMLRequest
	;s XMLRequest="<Request><TradeCode>1109</TradeCode><HospitalId></HospitalId><DoctorCode></DoctorCode><DepartmentCode></DepartmentCode><PatientCard></PatientCard><CardType></CardType><PatientID>0000001340</PatientID></Request>"
	s InputObj=..GetInputObj("1109",XMLRequest)
	s OutputObj=..GetOutputObj("1109")
	s CardType=InputObj.CardType
	s PatientCard=InputObj.PatientCard
	s PatientNo=InputObj.PatientID
	s DepartmentCode=InputObj.DepartmentCode
	s ScheduleItemCode=InputObj.ScheduleItemCode
	s DoctorCode=InputObj.DoctorCode
	s ExtUserID=InputObj.ExtUserID
	s HospitalId=InputObj.HospitalId
	s OutputObj.ResultCode="0"
	s OutputObj.ResultContent=""
	s HospitalId=##class(DHCExternalService.RegInterface.GetRelate).GetHISHospitalIdFromOuterCode(HospitalId) 
	if HospitalId=""{
		d ..SetOutputCode(.OutputObj,"-100","请传入正确的院区代码.")
		quit OutputObj	
	}
	set ExtUserID=##class(DHCExternalService.RegInterface.GetRelate).GetUser(InputObj.ExtUserID,"",HospitalId)
	if (ExtUserID=""){
		d ..SetOutputCode(.OutputObj,"-110901","请正确传入操作用户信息")
		q OutputObj
	}
	s GroupID=##class(DHCExternalService.RegInterface.GetRelate).GetGroup(ExtUserID)
	
	s BankCode=##class(DHCDoc.Interface.Outside.Config).GetConfigNode(GroupID,"DataCompareExtOrg",HospitalId)
	s CardType=##Class(DHCExternalService.RegInterface.GetRelate).GetHisCardTypeID(CardType,BankCode,"",HospitalId)
	if (PatientCard="")&&(PatientNo=""){
		d ..SetOutputCode(.OutputObj,"-110902","卡号和患者ID不能都为空.")
		q OutputObj
	}
	s myPatientID=""
	if PatientCard'="" {
		s myPatientID=..getPatIDByCardInfo(CardType,PatientCard)
		if myPatientID="" d ..SetOutputCode(.OutputObj,"-110903","卡号在系统中未找到")
			
	}elseif PatientNo'="" {
		s myPatientID=$o(^PAPERi("PAPMI_PatNo",$ZCVT(PatientNo,"U"),""))	
	}
	i '$d(^PAPER(+myPatientID,"ALL")){
		d ..SetOutputCode(.OutputObj,"-110904","患者信息在系统中未找到")
		Q OutputObj
	}
	
	k ^DHCClearPatListTime(+$h-1)
	d ClearData
	k QueueDocList
	s SelfPAAdmStr=""
	
	s AdmRowid=0
	for{
		s AdmRowid=$o(^PAPERdr(myPatientID,"ADM","O",AdmRowid)) Quit:AdmRowid=""
		s AdmDate=$p(^PAADM(AdmRowid),"^",6)
		continue:AdmDate'=..%SysDate()
		s RegfeeRowId=$o(^User.DHCRegistrationFeeI("ADM",AdmRowid,0))
		continue:RegfeeRowId=""
		s VisitStatus=$p(^PAADM(AdmRowid),"^",20)   //状态
		continue:VisitStatus'="A"
		s AdmLoc=$p(^PAADM(AdmRowid),"^",4)
		continue:(DepartmentCode'="")&&(DepartmentCode'=AdmLoc)
		s AdmDoc=$p(^PAADM(AdmRowid),"^",9)
		continue:(DoctorCode'="")&&(DoctorCode'=AdmDoc)
		s RBASDR=$List(^User.DHCRegistrationFeeD(RegfeeRowId),18)
		continue:(ScheduleItemCode'="")&&(ScheduleItemCode'=RBASDR)
		s QueRowId=""
		s QueRowId=$O(^User.DHCQueueI("QuePaadmDrIndex",AdmRowid,QueRowId))
		continue:'$d(^User.DHCQueueD(QueRowId))
		s PAAdm=$List(^User.DHCQueueD(QueRowId),11)
		s QueDoc=$List(^User.DHCQueueD(QueRowId),5)
		s MarkDoc=$List(^User.DHCQueueD(QueRowId),8)
		s StatusName=##class(DHCDoc.OPDoc.PatientListConfig).GetQueueStatus(QueRowId,PAAdm,AdmLoc)
		continue:StatusName=""
		i SelfPAAdmStr="" s SelfPAAdmStr=PAAdm
		e  s SelfPAAdmStr=SelfPAAdmStr_"^"_PAAdm
		;如果这个号别已经被医生叫过或者指定过医生,则按医生查询
		i QueDoc'="" s MarkDoc=QueDoc
		s QueueDocList(MarkDoc,AdmLoc,QueRowId)=""
	}
	if ('$D(QueueDocList)){
		d ..SetOutputCode(.OutputObj,"-110905","未找到查询记录")
		q OutputObj
	}
	s DocDr="0"
	for {
		s DocDr=$O(QueueDocList(DocDr))
		q:DocDr=""
		s LocDr=0
		for {
			s LocDr=$O(QueueDocList(DocDr,LocDr))
			q:LocDr=""
			d OutOPPAPMINew(DocDr,LocDr)
		}
	}
	s SelfPAAdmStr="^"_SelfPAAdmStr_"^"
	s OutputObj.ResultCode="0"
	s OutputObj.ResultContent="查询成功"
	s ResultCount=0
	s Loc="0" 
	f {
		s Loc=$o(^||TMPQueryPatList("QueryPatList",+$h,Loc)) 
		q:Loc=""
		s DocDr="0"
		f {
			s DocDr=$o(^||TMPQueryPatList("QueryPatList",+$h,Loc,DocDr))
			q:DocDr=""
			s CTLocDr=""
			s CTLocName=""
			s CTPCPDr=""
			s CTPCPName=""
			s CallNo=""
			s ConsultRoom="0"
			s QueueWaitNum=0
			for {
				s ConsultRoom=$o(^||TMPQueryPatList("QueryPatList",+$h,Loc,DocDr,ConsultRoom))
				q:ConsultRoom=""
				s AdmId=0
				for {
					s AdmId=$o(^||TMPQueryPatList("QueryPatList",+$h,Loc,DocDr,ConsultRoom,"Adm",AdmId)) q:AdmId=""
					;非本患者则退出
					continue:SelfPAAdmStr'[("^"_AdmId_"^")
					s RBASDr=$G(^||TMPQueryPatList("QueryPatList",+$h,Loc,DocDr,ConsultRoom,"Adm",AdmId))
					s DepDr=$tr(Loc," ","")
					s RoomDr=$tr(ConsultRoom," ","")
					s DocID=$tr(DocDr," ","")
					s CTPCPDesc=""
					s:DocID'="" CTPCPDesc=$p(^CTPCP(DocID,1),"^",2)
					i DepDr'="" d
					.;w DepDr_","_$P(^CTLOC(DepDr),"^",1),!
					s ExaBorDepDr=$o(^User.DHCExaBorDepI("BordDepDrIndex"," "_DepDr,""),-1)
					;continue:ExaBorDepDr=""
					;s QueueWaitNum=QueueWaitNum+1
					s ExaBorDepDr=$tr(ExaBorDepDr," ","")
					s BorDr="",BorName=""
					s RoomName=""
					s macIPAdress=""
					if (ExaBorDepDr'=""){
						s BorDr=$ListGet(^User.DHCExaBorDepD(ExaBorDepDr),6)  //
						if (BorDr'="")&&($d(^User.DHCExaBoroughD(BorDr))) s BorName=$ListGet(^User.DHCExaBoroughD(BorDr),5) //诊区
					}
					if (RoomDr'=""){
						s RoomName=$P(^CTLOC(RoomDr),"^",13)
						&sql(SELECT RoomcIp into :macIPAdress FROM SQLUser.DHCRoomComp WHERE RoomcRoomDr=:RoomDr)
					}
					s CTPCPDr=$P(^RB("RES",+RBASDr),"^",2)
					s CTPCPName=$P(^CTPCP(CTPCPDr,1),"^",2)
					s SessionTypeDR=$P(^RBAS(+RBASDr,$P(RBASDr,"||",2),"DHC"),"^",6)
					s SessionTypeDesc=$P(^RBC("SESS",SessionTypeDR),"^",2)
					s CTLocDr=$P(^RB("RES",+RBASDr),"^",1)
					s CTLocName=$P(^CTLOC(CTLocDr),"^",2)
					s DoctorList=##Class(DHCExternalService.RegInterface.Entity.SelfReg.List.QueryPatList).%New()
					/// 诊区名称
					s DoctorList.CallArea=BorName
					s BorAddress=""
					;S BorAddDr=$o(^CTLOC(BorDr,"ADDR",""),-1)
					;if (BorAddDr'="") set BorAddress=$get(^CTLOC(BorDr,"ADDR",BorAddDr))
					i RoomDr'="" {
						s Room=$p($g(^CTLOC(RoomDr)),"^",2)
						i (Room["-") s Room=$p(Room,"-",2)
						;地址
						s WaitingAddress=$p($g(^CTLOC(RoomDr)),"^",16)
						s RoomNo=$P(WaitingAddress,",",2)
						;取地址必须放在取诊室号后面
						s WaitingAddress=$P(WaitingAddress,",",1)
					}elseif CTLocDr'=""{
						s WaitingAddress=$p($g(^CTLOC(CTLocDr)),"^",16)
						s RoomNo=$P(WaitingAddress,",",2)
						;i RoomNo'="" s Room=RoomNo
						;取地址必须放在取诊室号后面
						s WaitingAddress=$P(WaitingAddress,",",1)
					}
				
					s DoctorList.CallAreaAddress=WaitingAddress
					/// 诊室名称
					;s DoctorList.CallRoom=RoomName
					/// 呼叫计算机IP地址
					;s DoctorList.IPaddress=macIPAdress
					/// 号别级别
					s DoctorList.DoctorTitle=SessionTypeDesc
					/// 号别名称
					s DoctorList.DoctorCallName=CTPCPName
					/// 科室名称
					i CTLocName["-" s CTLocName=$p(CTLocName,"-",2)
					s DoctorList.DeptName=CTLocName
					s LocAddress=""
					S DepAddDr=$o(^CTLOC(DepDr,"ADDR",""),-1)
					if (DepAddDr'="") set LocAddress=$get(^CTLOC(DepDr,"ADDR",DepAddDr))
					s DoctorList.DeptAddress=LocAddress
					s DoctorList.QueueWaitStatus=""
					s CallCallNo="无"
					s WaitCallNo="",WaitPAPMIName="",WaitPatientID=""
					s FindFlag=0
					i $d(^||TMPQueryPatList("QueryPatList",+$h,Loc,DocDr,ConsultRoom,"正在呼叫",AdmId)) {
						s WaitPatientID=$P(^PAADM(AdmId),"^",1)
						s WaitPAPMIName=$P(^PAPER(WaitPatientID,"ALL"),"^",1)
						s WaitQueRowid=$O(^User.DHCQueueI("QuePaadmDrIndex",AdmId,""),-1)
						s WaitCallNo=$LIST(^User.DHCQueueD(WaitQueRowid),10)
						s DoctorList.QueueWaitStatus="正在呼叫"
						s CallCallNo=WaitCallNo
						s FindFlag=1
					}
					i FindFlag=0{
						i $d(^||TMPQueryPatList("QueryPatList",+$h,Loc,DocDr,ConsultRoom,"等待",AdmId)) {
							s WaitAllNumber=0,QueueWaitNum=-1
							i $d(^||TMPQueryPatList("QueryPatList",+$h,Loc,DocDr,ConsultRoom,"等待","PAAdmQue")) d
							.s WaitAllNumber=$l(^||TMPQueryPatList("QueryPatList",+$h,Loc,DocDr,ConsultRoom,"等待","PAAdmQue"),"!")
							f i=1:1:WaitAllNumber{
								s WaitPaadm=$p(^||TMPQueryPatList("QueryPatList",+$h,Loc,DocDr,ConsultRoom,"等待","PAAdmQue"),"!",i)
								continue:WaitPaadm=""
								;w "DocDr:"_DocDr_","_"WaitPaadm:"_WaitPaadm,!
								s QueueWaitNum=QueueWaitNum+1
								continue:WaitPaadm'=AdmId
								s WaitPatientID=$P(^PAADM(WaitPaadm),"^",1)
								s WaitPAPMIName=$P(^PAPER(WaitPatientID,"ALL"),"^",1)
								s WaitQueRowid=$O(^User.DHCQueueI("QuePaadmDrIndex",WaitPaadm,""),-1)
								s WaitCallNo=$LIST(^User.DHCQueueD(WaitQueRowid),10)
								;s CallKind=..GetCallKindByStatus(Paadm)-wait
								s DoctorList.QueueWaitStatus="等候"
								;得到队列状态
								s Remark=""
								s QueRowId=##Class(web.DHCDocOutPatientList).GetQueRowidByMore(AdmId,"")
								If QueRowId'="" {
									Set QueObj=##Class(User.DHCQueue).%OpenId(QueRowId)
									Set QueStatusName=QueObj.QueStateDr.PersName
									if QueStatusName["报到" s Remark="就诊前请您先刷卡报到"
									else  if QueStatusName["过号" s Remark="您已过号，请重新报到"
								}
								s DoctorList.Remark=Remark
								q:WaitPaadm=AdmId
							}
						}
					}
					
					if CallCallNo="无"{
						i $d(^||TMPQueryPatList("QueryPatList",+$h,Loc,DocDr,ConsultRoom,"正在呼叫")) {
							s CallAdmId=""
							for {
								s CallAdmId=$o(^||TMPQueryPatList("QueryPatList",+$h,Loc,DocDr,ConsultRoom,"正在呼叫",CallAdmId))
								q:CallAdmId=""
								s WaitQueRowid=$O(^User.DHCQueueI("QuePaadmDrIndex",CallAdmId,""),-1)
								i WaitQueRowid'="" s CallCallNo=$LIST(^User.DHCQueueD(WaitQueRowid),10)
							}
						}	
					}
					s DoctorList.CallNo=CallCallNo
					s DoctorList.WaitCallNo=WaitCallNo
					s DoctorList.WaitPAPMIName=WaitPAPMIName
					i QueueWaitNum>0 s QueueWaitNum=QueueWaitNum
					e  s QueueWaitNum=""
					s DoctorList.QueueWaitNum=QueueWaitNum
					s DoctorList.CurrentCallNo=CallCallNo
					s DoctorList.ScheduleItemCode=RBASDr
					s TimeRange=""
					i RBASDr'="" {
						s TimeRangeDR=$p(^RBAS(+RBASDr,$p(RBASDr,"||",2),"DHC"),"^",17)
						i TimeRangeDR'="" s TimeRange=$p(^DHCTimeRange(TimeRangeDR),"^",2)
					}
					s DoctorList.TimeRange=TimeRange
					d DoctorList.XMLExportToString(.xml)
					d OutputObj.infos.Insert(DoctorList)
					d DoctorList.%Close()
					s ResultCount=ResultCount+1
				}
			}
		}
	}
	
	if ResultCount=0{
		s OutputObj.ResultCode="-100"
		s OutputObj.ResultContent="查询成功,暂无候诊信息,若已挂号请确认是否已报到"
	}
	s OutputXML=""
	Do OutputObj.XMLExportToString(.OutputXML,"Response")
  	Do OutputObj.%Close()
  	b ////-----w OutputXML
  	
  	d ClearAfterSend
	q OutputObj

OutOPPAPMINew(DocDr,LocDr)
	s DocUserID=$O(^SSU("SSUSR",0,"CTPCP",DocDr,""),-1)
	;如果号别没有对应到用户,例如:普通号;需要再通过医生号别对照找一个有对照关系的医生传入医生的用户,并传入号别参数
	if DocUserID="" {
		s MarkDocID=0
		for {
			s MarkDocID=$O(^User.DHCMarkDocI("MarkddepDrIndex",LocDr,MarkDocID)) Q:MarkDocID=""
			s MarkDocDr=$lg(^User.DHCMarkDocD(MarkDocID),2)
			continue:MarkDocDr=""
			i $d(^User.DHCMarkDocI("MarkdDocMarkIndex",MarkDocDr,DocDr)) s DocUserID=$O(^SSU("SSUSR",0,"CTPCP",MarkDocDr,""),-1)
		}
	}
	s ExpSessionStr=GroupID_"^"_HospitalId 
	s rset=##Class(%ResultSet).%New("web.DHCDocOutPatientList:FindLocDocCurrentAdm")
	i rset.QueryIsValid() { 
		s Status=rset.Execute(LocDr, DocUserID, "", "", "", "", "", "", "", "on","",DocDr,"","",ExpSessionStr)
		i 'Status q
		s columns = rset.GetColumnCount()
		While (rset.Next()) {
			s ret=""
			s AdmID=rset.GetData(2)
			continue:AdmID=""
			s PAAdmHosp=##class(DHCDoc.Common.Hospital).GetAdmHospitalId(AdmID)
			continue:(HospitalId'="")&&(HospitalId'=PAAdmHosp)
			Do GetList(AdmID)
		}
		d rset.Close()
	}
	
	Quit
GetList(PAAdm)
	;w PAAdm,!
	s PatientID=$P(^PAADM(PAAdm),"^",1)
	s PAPMIName=$P(^PAPER(PatientID,"ALL"),"^",1)
	s Loc=$P($g(^PAADM(PAAdm)),"^",4)
	s DocDr=$P($g(^PAADM(PAAdm)),"^",9)
	s QueRowId=##Class(web.DHCDocOutPatientList).GetQueRowidByMore(PAAdm,"")
	s LocSeqNo=""
	if QueRowId'=""{
		s Called=$List(^User.DHCQueueD(QueRowId),2) ;QueObj.QueCompDr
		s ConsultRoomDr=$List(^User.DHCQueueD(QueRowId),13) ;QueObj.QueRoomDr
		s LocSeqNo=$List(^User.DHCQueueD(QueRowId),10) ;QueObj.QueNo
		s MarkDoc=$List(^User.DHCQueueD(QueRowId),8) ;QueObj.QueMarkDrGetObjectId()
	}else{
		s Called=""
	}
	s RegistDr=$o(^User.DHCRegistrationFeeI("ADM",PAAdm,""),-1)
	if RegistDr'=""{
		s RBASDr=$List(^User.DHCRegistrationFeeD(RegistDr),18)
		//tanjishan
		s TRDesc="",DTRDesc=""
		s TRRowId=$P($G(^RBAS(+RBASDr,$p(RBASDr,"||",2),"DHC")),"^",17)
		if TRRowId'="" s TRDesc=$P(^DHCTimeRange(TRRowId),"^",2)
		s DTRRowId=##class(web.DHCRBResSession).GetTimeRangeByTime(..%SysTime())
		s:DTRRowId'="" DTRDesc=$P(^DHCTimeRange(DTRRowId),"^",2)
		if (TRDesc="上午")&&(DTRDesc="下午"){
			s LocSeqNo="上午"
		}
		///tanjishan
		s RoomID=$List(^User.DHCRegistrationFeeD(RegistDr),20)
		if (RoomID=""){
			Set RoomID=$p($G(^RBAS(+RBASDr,$P(RBASDr,"||",2),"DHC")),"^",5)
		}
	}
	i $g(RoomID)'="" s ConsultRoomDr=RoomID
	q:($g(^||TMPQueryPatList("QueryPatList",+$h," "_Loc," "_DocDr," "_ConsultRoomDr,"正在呼叫",PAAdm))=(LocSeqNo_","_PAPMIName))&&(Called'="1")
	s ^||TMPQueryPatList("QueryPatList",+$h," "_Loc," "_DocDr," "_ConsultRoomDr,"Adm",PAAdm)=RBASDr
	i Called="1"{
		s ^||TMPQueryPatList("QueryPatList",+$h," "_Loc," "_DocDr," "_ConsultRoomDr,"正在呼叫",PAAdm)=""
		i '$d(^||TMPQueryPatList("QueryPatList",+$h," "_Loc," "_DocDr," "_ConsultRoomDr,"正在呼叫","PAAdmQue")){
			s ^||TMPQueryPatList("QueryPatList",+$h," "_Loc," "_DocDr," "_ConsultRoomDr,"正在呼叫","PAAdmQue")=PAAdm
		}else{
			s ^||TMPQueryPatList("QueryPatList",+$h," "_Loc," "_DocDr," "_ConsultRoomDr,"正在呼叫","PAAdmQue")=^||TMPQueryPatList("QueryPatList",+$h," "_Loc," "_DocDr," "_ConsultRoomDr,"正在呼叫","PAAdmQue")_"!"_PAAdm
		}
	}else{
		s ^||TMPQueryPatList("QueryPatList",+$h," "_Loc," "_DocDr," "_ConsultRoomDr,"等待",PAAdm)=""
		i '$d(^||TMPQueryPatList("QueryPatList",+$h," "_Loc," "_DocDr," "_ConsultRoomDr,"等待","PAAdmQue")){
			s ^||TMPQueryPatList("QueryPatList",+$h," "_Loc," "_DocDr," "_ConsultRoomDr,"等待","PAAdmQue")=PAAdm
		}else{
			s ^||TMPQueryPatList("QueryPatList",+$h," "_Loc," "_DocDr," "_ConsultRoomDr,"等待","PAAdmQue")=^||TMPQueryPatList("QueryPatList",+$h," "_Loc," "_DocDr," "_ConsultRoomDr,"等待","PAAdmQue")_"!"_PAAdm
		}
	}
	Quit
QueryPatListET
	set OutputObj=..GetOutputObj("1109")
	s OutputObj.ResultCode="-1109"
	s OutputObj.ResultContent=$ze
    Quit OutputObj
ClearData
	s Loc="" f  s Loc=$o(^||TMPQueryPatList("QueryPatList",+$h,Loc)) q:Loc=""  d
	.s DocDr="" f  s DocDr=$o(^||TMPQueryPatList("QueryPatList",+$h,Loc,DocDr)) q:DocDr=""  d
	..s ConsultRoom="" f  s ConsultRoom=$o(^||TMPQueryPatList("QueryPatList",+$h,Loc,DocDr,ConsultRoom)) q:ConsultRoom=""  d
	...
	...k ^||TMPQueryPatList("QueryPatList",+$h,Loc,DocDr,ConsultRoom,"等待")
	...k ^||TMPQueryPatList("QueryPatList",+$h,Loc,DocDr,ConsultRoom,"正在呼叫")
	q
ClearAfterSend
	s Loc="" f  s Loc=$o(^||TMPQueryPatList("QueryPatList",+$h,Loc)) q:Loc=""  d
	.s DocDr="" f  s DocDr=$o(^||TMPQueryPatList("QueryPatList",+$h,Loc,DocDr)) q:DocDr=""  d
	..s ConsultRoom="" f  s ConsultRoom=$o(^||TMPQueryPatList("QueryPatList",+$h,Loc,DocDr,ConsultRoom)) q:ConsultRoom=""  d
	...i ((..%SysTime()-$g(^DHCClearPatListTime(+$h)))>(60*5)) d
	....k ^||TMPQueryPatList("QueryPatList",+$h,Loc,DocDr,ConsultRoom,"正在呼叫")
	....s ^DHCClearPatListTime(+$h)=..%SysTime()
	q
}

ClassMethod QueryScheduleTimeInfoNew(XMLRequest As %String) As DHCExternalService.RegInterface.Entity.SelfReg.QueryScheduleTimeInfoRp
{
	s ^TMPSelfRegXML("Request","QueryScheduleTimeInfoNew")=XMLRequest
	;s XMLRequest="<Request><TradeCode>10041</TradeCode><ExtOrgCode>H1</ExtOrgCode><ClientType>ATM</ClientType><ScheduleItemCode>1||1409</ScheduleItemCode><ExtUserID>reg</ExtUserID><StartDate></StartDate><EndDate></EndDate><DepartmentCode></DepartmentCode><ServiceCode></ServiceCode><DoctorCode></DoctorCode><RBASSessionCode></RBASSessionCode></Request>"
	s $ZTRAP="QueryScheduleTimeInfoErrNew"
	s InputObj=..GetInputObj("10041",XMLRequest)
	s ScheduleItemCode=InputObj.ScheduleItemCode
	s DepartmentCode=InputObj.DepartmentCode
	s DoctorCode=InputObj.DoctorCode
	s SessionCode=InputObj.RBASSessionCode
	s ServiceDate=InputObj.ServiceDate
	s HospitalId=InputObj.HospitalId
	s HospitalId=##class(DHCExternalService.RegInterface.GetRelate).GetHISHospitalIdFromOuterCode(HospitalId,ScheduleItemCode)
	s SessionCode=##Class(DHCExternalService.RegInterface.SelfRegPlulic).GetOuterTimeRangeCodeAnti(SessionCode)
	s OutputObj=..GetOutputObj("10041")
	s OutputObj.ResultCode="0"
	s OutputObj.ResultContent=""
	i ServiceDate["-" s ServiceDate=$zdh(ServiceDate,3)
	i ServiceDate["/" s ServiceDate=$zdh(ServiceDate,4)
	if HospitalId=""{
		d ..SetOutputCode(.OutputObj,"-100","请传入正确的院区代码.")
		quit OutputObj	
	}
	s UserID=##class(DHCExternalService.RegInterface.GetRelate).GetUser(InputObj.ExtUserID,"",HospitalId)
	if (UserID=""){
    	d ..SetOutputCode(.OutputObj,"-1001506","操作员信息为空")
		q OutputObj
	}
	s GroupID=##class(DHCExternalService.RegInterface.GetRelate).GetGroup(UserID)
	s BankCode=##class(DHCDoc.Interface.Outside.Config).GetConfigNode(GroupID,"DataCompareExtOrg",HospitalId)
	S AppRegMethodCode=""
	s AppRegMethodRowID=##class(DHCDoc.Interface.Outside.Config).GetConfigNode(GroupID,"AppRegMethod",HospitalId)
	if AppRegMethodRowID'="" s AppRegMethodCode=$P(^RBC("APTM",AppRegMethodRowID),"^",1)
	if AppRegMethodCode="" s AppRegMethodCode="WIN"
	i ScheduleItemCode=""{
		i DepartmentCode="" {
			d ..SetOutputCode(.OutputObj,"-100411","科室代码不能都为空.")
			q OutputObj
		}
		i DoctorCode="" {
			d ..SetOutputCode(.OutputObj,"-100412","医生代码不能都为空.")
			q OutputObj
		}
		i SessionCode="" {
			d ..SetOutputCode(.OutputObj,"-100412","班别代码不能都为空.")
			q OutputObj
		}
		i ServiceDate=""{
			d ..SetOutputCode(.OutputObj,"-100412","出诊日期不能都为空.")
			q OutputObj
		}
		s StartDate=ServiceDate
		s EndDate=ServiceDate
		s ResID=0
		for {
			s ResID=$O(^RB("RES",0,"CTLOC",DepartmentCode,ResID)) q:ResID=""
			s ResCTPCPDR=$p($g(^RB("RES",ResID)),"^",2)
			Continue:ResCTPCPDR=""
			Continue:(DoctorCode'="")&(DoctorCode'=ResCTPCPDR)
			s Date=StartDate-1
			for {
				s Date=$O(^RBAS(ResID,0,"DateSTime",Date)) q:(Date="")||(Date>EndDate)
				s Time=0
				for {
					s Time=$O(^RBAS(ResID,0,"DateSTime",Date,Time)) q:(Time="")
					s Sub=0
					for {
						s Sub=$O(^RBAS(ResID,0,"DateSTime",Date,Time,Sub)) q:(Sub="")  d
						s RBASID=ResID_"||"_Sub
						s ASDate=$p($g(^RBAS(ResID,Sub)),"^",1)
						s SessEndTime=$p($g(^RBAS(ResID,Sub)),"^",5)
						;不显示当前时段以前的号
						Continue:(ASDate=..%SysDate())&&(SessEndTime<..%SysTime())
						;s RBASServiceCode=$p($g(^RBAS(ResID,Sub,"DHC")),"^",7)
						;Continue:(ServiceCode'="")&(ServiceCode'=RBASServiceCode)
						s RBASSessionCode=$p($g(^RBAS(ResID,Sub,"DHC")),"^",17)
						Continue:(SessionCode'="")&(SessionCode'=RBASSessionCode)
						s ScheduleItemCode=RBASID
					}
				}
			}
		}
	}
	s RecordCount=0
	if ScheduleItemCode'="" {
		if ($l(ScheduleItemCode,"||")'=2){
		d ..SetOutputCode(.OutputObj,"-100413","排班ID格式不正确")
		q OutputObj
		}
		
		if '$d(^RBAS(+ScheduleItemCode,+$p(ScheduleItemCode,"||",2))){
			d ..SetOutputCode(.OutputObj,"-100414","排班不存在")
			q OutputObj	
		}
		s ASStatusDR=$P($g(^RBAS(+ScheduleItemCode,$p(ScheduleItemCode,"||",2),"DHC")),"^",10)
		s ASTimeRangeFlag=$P($g(^RBAS(+ScheduleItemCode,$p(ScheduleItemCode,"||",2),"DHC")),"^",19)
		s ASStatus=$P($g(^DHCRBCASStatus(+ASStatusDR)),"^",1)
		if (ASStatus="S")||(ASStatus="TR")
		{
			d ..SetOutputCode(.OutputObj,"-100415","排班已经停诊或替诊")
			q OutputObj
		}
		s RBASObject=##class(User.RBApptSchedule).%OpenId(ScheduleItemCode,0,.sc)
		s DHCRBASObject=##class(User.DHCRBApptSchedule).%OpenId(ScheduleItemCode,0,.sc)

		s AvailSeqNoStr=..GetAvailSeqNoStr(ScheduleItemCode,AppRegMethodCode)
		s AvailSeqNoStr=$p(AvailSeqNoStr,"^")
		if AvailSeqNoStr=""{
			d ..SetOutputCode(.OutputObj,"-100416","号已挂完")
			q OutputObj	
		}
		if ASTimeRangeFlag="Y"{
			s ASTRRegNumStr=DHCRBASObject.ASTRRegNumStr
			s ASTRRegInfoStr=DHCRBASObject.ASTRRegInfoStr
			;退号不释放资源并增号出来的号不在分时段内,接口不会返回这些增的号,需解决
			;如果最大的号大于分时段最后一个序号,则将之后的号放在整个大的分时段内
			;那如果本来就不在分时段里的怎么办?
			;比如一共20个号,只有1-10号是在分时段里,增的号还放到大的时段里?那不是本来不在分时段里的11-20号也搞到分时段里了
			/*s LastASTRRegNum=$p(ASTRRegNumStr,"-",$l(ASTRRegNumStr,"-"))
			s LastASTRRegNumA=LastASTRRegNum+1
			S MaxQueueNO=##class(web.DHCRBResourceRule).GetMaxQueueNO($p(DHCRBASObject.ASQueueNo,$c(1)))
			if MaxQueueNO>LastASTRRegNum{
				s ASTRRegNumStr=ASTRRegNumStr_","_LastASTRRegNumA_"-"_MaxQueueNO
				s ASTRRegInfoStr=ASTRRegInfoStr_","_$p(ASTRRegInfoStr,"-",1)_"-"_$p(ASTRRegInfoStr,"-",$l(ASTRRegInfoStr,"-"))
			}*/
			s ASTRRegInfoStrLen=$l(ASTRRegInfoStr,",")
			s AvailSeqNoStrs=","_AvailSeqNoStr_","
			f mycount=1:1:ASTRRegInfoStrLen{
				s OneTimeRange=$p(ASTRRegInfoStr,",",mycount)
				s OneRegNumRange=$p(ASTRRegNumStr,",",mycount)
				s StartNoNew=$p(OneRegNumRange,"-",1)
				s EndNoNew=$p(OneRegNumRange,"-",2)
				f mySeqNoNew=StartNoNew:1:EndNoNew{
					s mySeqNoNews=","_mySeqNoNew_","
					continue:AvailSeqNoStrs'[mySeqNoNews
					s RBASRecObj=..GetRBASRecTimeObjNew(RBASObject,OneTimeRange,mySeqNoNew,AvailSeqNoStr,AppRegMethodCode,BankCode)			
					;B //w OneAdmScheduleObj,!
					s AvailableLeftNum=RBASRecObj.AvailableLeftNum
					continue:+AvailableLeftNum=0
					if $IsObject(RBASRecObj) {
						do OutputObj.TimeRanges.Insert(RBASRecObj)
						s RecordCount=RecordCount+1
					}
					
				}
			}
		}else{
			s AvailSeqNoStrlen=$l(AvailSeqNoStr,",")
			for i=1:1:AvailSeqNoStrlen{
				s myseqno=$p(AvailSeqNoStr,",",i)
				continue:myseqno=""
				
				s RBASRecObj=..GetRBASRecTimeObjNew(RBASObject,"",myseqno,AvailSeqNoStr,AppRegMethodCode,BankCode)			
				B //w OneAdmScheduleObj,!
				s AvailableLeftNum=RBASRecObj.AvailableLeftNum
				if (AvailableLeftNum>0){
					if $IsObject(RBASRecObj) {
						do OutputObj.TimeRanges.Insert(RBASRecObj)
						s RecordCount=RecordCount+1
					}	
				}
			}
		}
		d RBASObject.%Close()
		d DHCRBASObject.%Close()
	}else{
		d ..SetOutputCode(.OutputObj,"-100416","未查询到排班信息")
		q OutputObj	
	}
	s OutputObj.RecordCount=RecordCount
	if (RecordCount=0) set OutputObj.ResultContent="号已挂完"
	q OutputObj
QueryScheduleTimeInfoErrNew
	s OutputObj=..GetOutputObj("10041")
	s OutputObj.ResultCode="-1"
	s OutputObj.ResultContent="QueryScheduleTimeInfo调用异常"_$ZERROR
	q OutputObj
}

ClassMethod GetRBASRecTimeObjNew(RBASObj As User.RBApptSchedule, OneTimeRange As %String, OneRegNumRange As %String, AvailSeqNoStr As %String, AppMedthodCode As %String = "", BankCode As %String = "") As DHCDoc.Util.RegisteredObject
{
	s RBASSessionLoad=..GetAppQty(RBASObj.%Id())
	s RtnObj=##class(DHCExternalService.RegInterface.Entity.SelfReg.List.TimeRange).%New()
	s DHCRBASObj=##class(User.DHCRBApptSchedule).%OpenId(RBASObj.%Id(),0,.sc)
	s RtnObj.ScheduleItemCode=RBASObj.%Id()
	s RtnObj.ServiceDate=$ZD(RBASObj.ASDate,3)
	s RtnObj.WeekDay=$ZD(RBASObj.ASDate,10)
	s:RtnObj.WeekDay=0 RtnObj.WeekDay=7
	
	s ASTimeRangeDR=DHCRBASObj.ASTimeRangeDR.%Id()
	s OuterTimeRange=##class(DHCExternalService.RegInterface.GetRelate).GetOuterTimeRangeCode(ASTimeRangeDR,BankCode)
	s RtnObj.SessionCode=$p(OuterTimeRange,"^",1)
	s:RtnObj.SessionCode="" RtnObj.SessionCode=DHCRBASObj.ASTimeRangeDR.TRCode
	s RtnObj.SessionName=$p(OuterTimeRange,"^",2)
	if DHCRBASObj.ASTimeRangeFlag="Y"{
		s NewAvailSeqNoStr=""
		s AvailSeqNoStr=","_AvailSeqNoStr_","
		s NewAvailSeqNoStr=OneRegNumRange
		s mycount=1
		s myavaicount=1
		s RtnObj.AvailableNumStr=NewAvailSeqNoStr
		s RtnObj.AvailableTotalNum=mycount
		s RtnObj.AvailableLeftNum=myavaicount
		s RtnObj.StartTime=$p(OneTimeRange,"-",1)
		s RtnObj.EndTime=$p(OneTimeRange,"-",2)
		
	}else{
		s RtnObj.AvailableNumStr=OneRegNumRange
		s mycount=$l(AvailSeqNoStr,",")
		s RtnObj.AvailableTotalNum=1
		s RtnObj.AvailableLeftNum=1
		s ASTRStartTime=DHCRBASObj.ASTRStartTime
		i ASTRStartTime="" s ASTRStartTime=DHCRBASObj.ASTimeRangeDR.TRStartTime
		i ASTRStartTime="" s ASTRStartTime="0"
		s ASTREndTime=DHCRBASObj.ASTREndTime
		i ASTREndTime="" s ASTREndTime=DHCRBASObj.ASTimeRangeDR.TREndTime
		i ASTREndTime="83499"
		s RtnObj.StartTime=..%ZT(ASTRStartTime,2)
		s RtnObj.EndTime=..%ZT(ASTREndTime,2)
	}
	d DHCRBASObj.%Close()
	q RtnObj
}

/// 实现自费挂号转医保挂号_重庆中医_方法核心为计费接口，标板暂缺少计费方法
ClassMethod ChangeRegFeeToInsu(XMLRequest) As DHCExternalService.RegInterface.Entity.SelfReg.RegFeeToINSURp
{
	s $ZTRAP="ChangeRegFeeToInsuErr"
	s InputObj=##class(DHCExternalService.RegInterface.Entity.SelfReg.RegFeeToINSURq).%New()
	d InputObj.XMLNodeDeserialize(.InputObj,"Request",XMLRequest)

	s OutputObj=##class(DHCExternalService.RegInterface.Entity.SelfReg.RegFeeToINSURp).%New()
	s AdmNo=InputObj.AdmNo
	if AdmNo=""{
		d ..SetOutputCode(.OutputObj,"-1001701","就诊号AdmNo不能为空")
		q OutputObj
	}
	s UserID=##class(DHCExternalService.RegInterface.GetRelate).GetUser(InputObj.ExtUserID,"",HospitalId)
	if UserID=""{
		d ..SetOutputCode(.OutputObj,"-1001702","授权工号ExtUserID非法")
		q OutputObj
	}
	
	s VisitStatus=$P($G(^PAADM(AdmNo)),"^",20)
	if VisitStatus'="A"{
		d ..SetOutputCode(.OutputObj,"-1001703","已退号记录不能转医保")
		q OutputObj
	}
	s RegID=$o(^User.DHCRegistrationFeeI("ADM",AdmNo,0))
	s InvoiceId=$LG($G(^User.DHCRegistrationFeeD(+RegID)),11)
	if InvoiceId=""{
		d ..SetOutputCode(.OutputObj,"-1001704","不存在有效的挂号发票记录")
		q OutputObj
	}
	;---计费方法，标板暂缺失
	s PrtToYB=##class(DHCExternalService.BillInterface.Service.DHCOPBillPayLogic).CheckPrtToYB(InvoiceId)
	if PrtToYB'=0{
		d ..SetOutputCode(.OutputObj,"-1001704","发票已打印或不是自助支付,请前往窗口操作")
		q OutputObj
	}
	/// 医疗类别
	s InsuYLLB=InputObj.InsuYLLB
	/// 参保类别
	s InsuCBLB=InputObj.InsuCBLB
	;;---计费方法，标板暂缺失
	s NInsTypeDr=##class(web.DHCINSUAdmInfoCtl).GetBRFB(InsuYLLB,InsuCBLB)
	if NInsTypeDr=""{
		d ..SetOutputCode(.OutputObj,"-1001705","'医疗类别'与'参保类别'字段不合法")
		q OutputObj
	}
	s PayMode=##class(DHCExternalService.RegInterface.GetRelate).GetHisPayModeID(InputObj.PayModeCode,"")
	if PayMode=""{
		d ..SetOutputCode(.OutputObj,"-1001706","HIS支付方式代码PayModeCode不能为空")
		q OutputObj
	}
	b ;医保、银行信息串直接交给计费处理
	s YBChargeStr="<Request>"_$P($P(XMLRequest,"<PayInsuFeeStr>",2),"</PayInsuFeeStr>")_"</Request>"
	s PayFee=InputObj.PayFee
	s PayTradeNo=InputObj.PayTradeNo
	s PayCardNo=InputObj.PayCardNo
	s BankTradeObj=##class(DHCExternalService.BillInterface.DHCEntity.BankTradeOutput).%New()
    S BankTradeStr=""
    s BankTradeObj.BankAccDate=$zd(+$h,3)
	s BankTradeObj.BankDate=$zd(+$h,3)
	s BankTradeObj.BankTime=..%ZT(..%SysTime())
	s BankTradeObj.BankTradeNo=PayTradeNo
	s BankTradeObj.PayCardNo=PayCardNo
	s BankTradeObj.PatientID=$P(^PAADM(AdmNo),"^",1)
	s BankTradeObj.ResultCode="0000"
	s BankTradeObj.ResultContent="成功"
	s BankTradeObj.PayAmt=PayFee    //$P(^DHCINVPRT(InvoiceId),"^",1)
	d BankTradeObj.XMLExportToString(.BankTradeStr,"Response")
	;---计费方法，标板暂缺失
	s ret=##class(DHCExternalService.BillInterface.Service.DHCOPBillPayLogic).RefundChargeYBForReg(AdmNo, InvoiceId, UserID, NInsTypeDr, PayMode, BankTradeStr, YBChargeStr)
	if $P(ret,"^",1)=0{
		s OutputObj.ResultCode=0
		s OutputObj.ResultContent="转医保成功!"
		if ($P(ret,"^",2)'=0){
			s OutputObj.ResultCode=-1
			s OutputObj.ResultContent="转医保成功,微信退费失败，请去窗口补退！"
		}
	}else{
		s OutputObj.ResultContent="HIS转医保失败:"_ret
	}
	Q OutputObj
ChangeRegFeeToInsuErr
	s $ZTRAP=""
	s OutputObj=##class(DHCExternalService.RegInterface.Entity.SelfReg.RegFeeToINSURp).%New()
	s OutputObj.ResultCode="-1"
	s OutputObj.ResultContent="调用异常"_$TR($ZERROR,"/","")
	Q OutputObj
}

/// w ##class(DHCExternalService.RegInterface.SelfRegMethods).GetOPRapidRegistAS("")
ClassMethod GetOPRapidRegistAS(XMLRequest As %String) As DHCExternalService.RegInterface.Entity.SelfReg.GetOPRapidRegistASRp
{
	s $ZTRAP="GetOPRapidRegistASErr"
	;s XMLRequest="<Request><TradeCode>10041</TradeCode><ExtOrgCode>H1</ExtOrgCode><ClientType>ATM</ClientType><ExtUserID>YS01</ExtUserID><DepartmentCode>60</DepartmentCode><DoctorCode>1608</DoctorCode><PatientID>0000000003</PatientID></Request>"
	s ^TMPSelfRegXML("Request","GetOPRapidRegistAS")=XMLRequest
	s InputObj=..GetInputObj("1112",XMLRequest)
	s TransactionId=InputObj.TransactionId
	s TerminalID=InputObj.TerminalID
	s ClientType=InputObj.ClientType
	s RegCTLocCode=InputObj.DepartmentCode
	s RegDocCode=InputObj.DoctorCode
	s PatientCard=InputObj.PatientCard
	s CardType=InputObj.CardType
	s PatientID=InputObj.PatientID
	s BillTypeID=InputObj.BillTypeID 
	s ExtUserID=InputObj.ExtUserID
	set HospitalId=InputObj.HospitalId
	s HospitalId=##class(DHCExternalService.RegInterface.GetRelate).GetHISHospitalIdFromOuterCode(HospitalId) 
	s OutputObj=..GetOutputObj("1112")
	if HospitalId=""{
		d ..SetOutputCode(.OutputObj,"-100","请传入正确的院区代码.")
		quit OutputObj	
	}
	s UserID=##class(DHCExternalService.RegInterface.GetRelate).GetUser(ExtUserID,"",HospitalId)
	if (UserID=""){
    	d ..SetOutputCode(.OutputObj,"-111201","操作员信息为空")
		q OutputObj
	}
	s GroupID=##class(DHCExternalService.RegInterface.GetRelate).GetGroup(UserID)
	s BankCode=##class(DHCDoc.Interface.Outside.Config).GetConfigNode(GroupID,"DataCompareExtOrg",HospitalId)
	s CardType=##class(DHCExternalService.RegInterface.GetRelate).GetHisCardTypeID(CardType,BankCode)
	
	;患者验证
	s myPatientID=""
	if PatientID'=""{
		 s myPatientID=$o(^PAPERi("PAPMI_PatNo",$ZCVT(PatientID,"U"),""))
	}elseif PatientCard'=""{
		s PatientID=..getPatIDByCardInfo(CardType,PatientCard)
		if (PatientID)=""{
			d ..SetOutputCode(.OutputObj,"-111202","系统中未找到此卡号.")
			q OutputObj
		}
	}
	
	if (myPatientID=""){
    	d ..SetOutputCode(.OutputObj,"-111203","请指定有效患者信息")
		q OutputObj
	}
	s PatCatDr=$p(^PAPER(myPatientID,"PER",1),"^",10)
	s PatCatDesc=$p(^CT("SS",PatCatDr),"^",2)
	if (PatCatDr="")&&('$d(^CT("SS",PatCatDr))){
		d ..SetOutputCode(.OutputObj,"-111204","您的患者类型有误,请前往窗口修改患者类型")
		q OutputObj
	}
	if $g(BillTypeID)'=""{
		if '$d(^PAC("ADMREA",BillTypeID)){
			d ..SetOutputCode(.OutputObj,"-111205","HIS系统中未找到该就诊结算费别信息")
			q OutputObj
		}
		s DefaultBillType=BillTypeID
	}else{
		s DefaultBillType=##Class(web.DHCOPAdmReg).GetDefaultBillType(PatCatDr)
	}
	s InsuPatSelfPayRegFlag=+(##class(DHCDoc.Interface.Outside.Config).GetConfigNode(GroupID,"InsuPatSelfPayReg",HospitalId))
	s InsuRegFlag=+(##class(DHCDoc.Interface.Outside.Config).GetConfigNode(GroupID,"InsuReg",HospitalId))
	s InsurFlag=##class(web.DHCDocOrderCommon).GetInsurFlag(DefaultBillType)
	if InsuRegFlag=0{
		if (InsurFlag>0){
			if (InsuPatSelfPayRegFlag=0){
				d ..SetOutputCode(.OutputObj,"-111206","目前不支持医保患者挂号，请到窗口挂号")
				q OutputObj
			}else{
				s SelfAdmReason=##class(DHCDoc.Interface.Outside.Config).GetConfigNode(GroupID,"SelfAdmReason",HospitalId)
				if (SelfAdmReason="")!(SelfAdmReason="0"){
					d ..SetOutputCode(.OutputObj,"-111207","请联系管理员维护自费费别")
					q OutputObj
				}
				s DefaultBillType=SelfAdmReason
			}
			
		}
	}
	;挂号信息验证
	if (RegCTLocCode=""){
		d ..SetOutputCode(.OutputObj,"-111208","请指定有效的科室")
		q OutputObj
	}elseif '$d(^CTLOC(RegCTLocCode)) {
		d ..SetOutputCode(.OutputObj,"-111209","系统未查询到该科室信息")
		q OutputObj
	}
	if (RegDocCode=""){
		d ..SetOutputCode(.OutputObj,"-111210","请指定有效的医生")
		q OutputObj
	}elseif '$d(^CTPCP(RegDocCode)) {
		d ..SetOutputCode(.OutputObj,"-111211","系统未查询到该医生号别信息")
		q OutputObj
	}
	s ResRowId=$O(^RB("RES",0,"CTPCP",RegDocCode,RegCTLocCode,0))
	if ResRowId=""{
		d ..SetOutputCode(.OutputObj,"-111291","系统未查询到该医生号别有效的资源信息")
		q OutputObj	
	}
	s GrantedMarkStr=##class(DHCDoc.Interface.Outside.Config).GetConfigNode(GroupID,"EmpowerRes",HospitalId,RegCTLocCode)
	if (GrantedMarkStr="")!(("^"_GrantedMarkStr_"^")'[("^"_ResRowId_"^")){
		d ..SetOutputCode(.OutputObj,"-111292","该医生号别未授权可直接挂号")
		q OutputObj	
	}
	s (SecheduleDate,TimeRangeId,RegConDisId,BillAmount)=""
	s FeeStr="1||1||0||0"
	s ScheduleItemCode=##class(web.DHCOPAdmReg).GetRapidASRowId(RegCTLocCode,"","",SecheduleDate,TimeRangeId,RegDocCode)
	if ScheduleItemCode=""{
		s IrrScheduleFlag=##class(web.DHCRBApptSchedule).CheckInsertOneIrrSchedule(RegCTLocCode,RegDocCode,SecheduleDate,TimeRangeId)
		if (IrrScheduleFlag'=0){
			d ..SetOutputCode(.OutputObj,"-111212","该科室医生未找到出诊记录,或者从未排班.")
			q OutputObj
		}
	}
	s IISRtn=##class(web.DHCRBApptSchedule).OPDocRegistInsertIrrSchedule(RegCTLocCode,RegDocCode,myPatientID,DefaultBillType,RegConDisId,ScheduleItemCode,FeeStr)
	if $p(IISRtn,"^",1)=0{
		s ScheduleItemCode=$p(IISRtn,"^",2)
		s BillAmount=$p(IISRtn,"^",3)
		s AdmReason=$p(IISRtn,"^",4)
	} else {
		d ..SetOutputCode(.OutputObj,"-111213",$p(IISRtn,"^",2))
		q OutputObj
	}
	
	if ScheduleItemCode=""{
		d ..SetOutputCode(.OutputObj,"-111217","无法获取指定科室医师出诊排班")
		q OutputObj
	}else{
		s ASDate=$P($G(^RBAS(+ScheduleItemCode,$p(ScheduleItemCode,"||",2))),"^",1) 
		if (+ASDate<+$h){
			d ..SetOutputCode(.OutputObj,"-111214","不可挂出当日之前的排班")
			q OutputObj
		}
		;是否禁用提前挂号配置
		s NotAllowAppRegFlag=+(##class(DHCDoc.Interface.Outside.Config).GetConfigNode(GroupID,"AppReg",HospitalId))
		if (NotAllowAppRegFlag=1)&&(+ASDate'=..%SysDate()){
			d ..SetOutputCode(.OutputObj,"-111215","不可挂出当日号之外的排班")
			q OutputObj
		}
		
		s checkret=##class(DHCExternalService.RegInterface.RegManager).CheckBeforeReg(ScheduleItemCode,myPatientID,HospitalId)
		if (checkret'=""){
	    	d ..SetOutputCode(.OutputObj,"-111216",checkret)
			q OutputObj
		}
		s SchdulExpStr=BankCode_"^"_GroupID
		s RBASObj=##class(User.RBApptSchedule).%OpenId(ScheduleItemCode,0,.sc)
		s RBASRecObj=..GetRBASRecObjByRBASObj(RBASObj,myPatientID,"",AdmReason,SchdulExpStr)
		d RBASObj.%Close()
		s OutputObj.ScheduleItemCode=RBASRecObj.ScheduleItemCode
		s OutputObj.ServiceDate=RBASRecObj.ServiceDate
		s OutputObj.WeekDay=RBASRecObj.WeekDay
		s OutputObj.SessionCode=RBASRecObj.SessionCode
		s OutputObj.SessionName=RBASRecObj.SessionName
		s OutputObj.StartTime=RBASRecObj.StartTime
		s OutputObj.EndTime=RBASRecObj.EndTime
		s OutputObj.DepartmentCode=RBASRecObj.DepartmentCode
		s OutputObj.DepartmentName=RBASRecObj.DepartmentName
		s OutputObj.ClinicRoomCode=RBASRecObj.ClinicRoomCode
		s OutputObj.ClinicRoomName=RBASRecObj.ClinicRoomName
		s OutputObj.DoctorCode=RBASRecObj.DoctorCode
		s OutputObj.DoctorName=RBASRecObj.DoctorName
		s OutputObj.DoctorTitleCode=RBASRecObj.DoctorTitleCode
		s OutputObj.DoctorTitle=RBASRecObj.DoctorTitle
		s OutputObj.DoctorSpec=RBASRecObj.DoctorSpec
		s OutputObj.DoctorSessTypeCode=RBASRecObj.DoctorSessTypeCode
		s OutputObj.DoctorSessType=RBASRecObj.DoctorSessType
		s OutputObj.ServiceCode=RBASRecObj.ServiceCode
		s OutputObj.ServiceName=RBASRecObj.ServiceName
		s OutputObj.Fee=RBASRecObj.Fee
		s OutputObj.RegFee=RBASRecObj.RegFee
		s OutputObj.CheckupFee=RBASRecObj.CheckupFee
		s OutputObj.ServiceFee=RBASRecObj.ServiceFee
		s OutputObj.OtherFee=RBASRecObj.OtherFee
		s OutputObj.AdmitAddress=RBASRecObj.AdmitAddress
		s OutputObj.AdmitTimeRange=RBASRecObj.AdmitTimeRange
		s OutputObj.Note=RBASRecObj.Note
		s OutputObj.ResultCode="0"
		s OutputObj.ResultContent="获取指定科室医师出诊排班成功"
	}
	q OutputObj
GetOPRapidRegistASErr
	if $TLEVEL>0{
    	TRO
	}
	s $ZTRAP=""
	s OutputObj=..GetOutputObj("1112")
	d ..SetOutputCode(.OutputObj,"-1","GetOPRapidRegistAS调用异常"_$TR($TR($ZE,"<","!!"),">","!!"))
    q OutputObj
}

/// w ##class(DHCExternalService.RegInterface.SelfRegMethods).OPRapidRegist("") ^TMPSelfRegXML("Request","OPRapidRegist")
ClassMethod OPRapidRegist(XMLRequest As %String) As DHCExternalService.RegInterface.Entity.SelfReg.OPRegisterRp
{
	s $ZTRAP="OPRapidRegistErr"
	;s XMLRequest="<Request><TradeCode>10041</TradeCode><ExtOrgCode>H1</ExtOrgCode><ClientType>ATM</ClientType><ExtUserID>SF01</ExtUserID><ScheduleItemCode>3146||145</ScheduleItemCode><PatientID>0000000003</PatientID><PayModeCode>CASH</PayModeCode></Request>"
	s ^TMPSelfRegXML("Request","OPRapidRegist")=XMLRequest
	s InputObj=..GetInputObj("1111",XMLRequest)
	s TransactionId=InputObj.TransactionId
	s TerminalID=InputObj.TerminalID
	s ClientType=InputObj.ClientType
	s ScheduleItemCode=InputObj.ScheduleItemCode
	s PatientCard=InputObj.PatientCard
	s CardType=InputObj.CardType
	s PatientID=InputObj.PatientID
	s PayModeCode=InputObj.PayModeCode
	s PayInsuFeeStr=InputObj.PayInsuFeeStr
	s BillTypeID=InputObj.BillTypeID 
	s PayTime=InputObj.PayTime
	s ExtUserID=InputObj.ExtUserID
	;支付宝、微信挂号银行支付信息
	s PayDetailsObj=##class(DHCBILL.SelfPay.Entity.CompleteCharge.Req.PayDetails).%New()
    s PayDetailsObj=InputObj.PayDetails
	s HospitalId=InputObj.HospitalId
	s HospitalId=##class(DHCExternalService.RegInterface.GetRelate).GetHISHospitalIdFromOuterCode(HospitalId) 
	s OutputObj=..GetOutputObj("1101")
	if HospitalId=""{
		d ..SetOutputCode(.OutputObj,"-100","请传入正确的院区代码.")
		quit OutputObj	
	}
	s UserID=##class(DHCExternalService.RegInterface.GetRelate).GetUser(ExtUserID,"",HospitalId)
	if (UserID=""){
    	d ..SetOutputCode(.OutputObj,"-111101","操作员信息为空")
		q OutputObj
	}
	s GroupID=##class(DHCExternalService.RegInterface.GetRelate).GetGroup(UserID)
	s BankCode=##class(DHCDoc.Interface.Outside.Config).GetConfigNode(GroupID,"DataCompareExtOrg",HospitalId)
	s CardType=##class(DHCExternalService.RegInterface.GetRelate).GetHisCardTypeID(CardType,BankCode)
	s CheckRegTimeFlag=##class(DHCExternalService.RegInterface.RegManager).CheckRegTime(GroupID,HospitalId)
	i CheckRegTimeFlag=0{
		d ..SetOutputCode(.OutputObj,"-111102","当前时间无法挂号.")
		q OutputObj	
	}
	
	;患者验证
	s myPatientID=""
	if PatientID'=""{
		 s myPatientID=$o(^PAPERi("PAPMI_PatNo",$ZCVT(PatientID,"U"),""))
	}elseif PatientCard'=""{
		s PatientID=..getPatIDByCardInfo(CardType,PatientCard)
		if (PatientID)=""{
			d ..SetOutputCode(.OutputObj,"-111103","系统中未找到此卡号.")
			q OutputObj
		}
	}
	
	if (myPatientID=""){
    	d ..SetOutputCode(.OutputObj,"-111104","请指定有效患者信息")
		q OutputObj
	}
	
	s PatCatDr=$p(^PAPER(myPatientID,"PER",1),"^",10)
	s PatCatDesc=$p(^CT("SS",PatCatDr),"^",2)
	if (PatCatDr="")&&('$d(^CT("SS",PatCatDr))){
		d ..SetOutputCode(.OutputObj,"-111105","您的患者类型有误,请前往窗口修改患者类型")
		q OutputObj
	}
	if $g(BillTypeID)'=""{
		if '$d(^PAC("ADMREA",BillTypeID)){
			d ..SetOutputCode(.OutputObj,"-111106","HIS系统中未找到该就诊结算费别信息")
			q OutputObj
		}
		s DefaultBillType=BillTypeID
	}else{
		s DefaultBillType=##Class(web.DHCOPAdmReg).GetDefaultBillType(PatCatDr)
	}
	s InsuPatSelfPayRegFlag=+(##class(DHCDoc.Interface.Outside.Config).GetConfigNode(GroupID,"InsuPatSelfPayReg",HospitalId))
	s InsuRegFlag=+(##class(DHCDoc.Interface.Outside.Config).GetConfigNode(GroupID,"InsuReg",HospitalId))
	s InsurFlag=##class(web.DHCDocOrderCommon).GetInsurFlag(DefaultBillType)
	if InsuRegFlag=0{
		if (InsurFlag>0){
			if (InsuPatSelfPayRegFlag=0){
				d ..SetOutputCode(.OutputObj,"-111107","目前不支持医保患者挂号，请到窗口挂号")
				q OutputObj
			}else{
				s SelfAdmReason=##class(DHCDoc.Interface.Outside.Config).GetConfigNode(GroupID,"SelfAdmReason",HospitalId)
				if (SelfAdmReason="")!(SelfAdmReason="0"){
					d ..SetOutputCode(.OutputObj,"-111108","请联系管理员维护自费费别")
					q OutputObj
				}
				s DefaultBillType=SelfAdmReason
			}
			
		}
	}
	;挂号信息验证
	s FeeStr="1||1||0||0"
	s (SecheduleDate,TimeRangeId,RegConDisId,BillAmount)=""
	if ScheduleItemCode'=""{
		if '$d(^RBAS(+ScheduleItemCode,+$p(ScheduleItemCode,"||",2))){
			d ..SetOutputCode(.OutputObj,"-111109","指定出诊排班信息无效")
			q OutputObj	
		}
		s AdmDep=$p($g(^RB("RES",+ScheduleItemCode)),"^",1)
		s AdmDoc=$p($g(^RB("RES",+ScheduleItemCode)),"^",2)
		s EpisodeID=##class(web.DHCOPAdmReg).GetSameAdm(myPatientID,AdmDep,AdmDoc,+$H)
		if EpisodeID'=""{
			d ..SetOutputCode(.OutputObj,"-111110","已存在相同科室医生的就诊登记记录,请正常就诊.")
			q OutputObj
		}
		s IISRtn=##class(web.DHCRBApptSchedule).OPDocRegistInsertIrrSchedule("","",myPatientID,DefaultBillType,RegConDisId,ScheduleItemCode,FeeStr)
		if $p(IISRtn,"^",1)=0{
			s ScheduleItemCode=$p(IISRtn,"^",2)
			s BillAmount=$p(IISRtn,"^",3)
			s AdmReason=$p(IISRtn,"^",4)
		} else {
			d ..SetOutputCode(.OutputObj,"-111111",$p(IISRtn,"^",2))
			q OutputObj
		}
		s ASDate=$P($G(^RBAS(+ScheduleItemCode,$p(ScheduleItemCode,"||",2))),"^",1) 
		if (+ASDate<+$h){
			d ..SetOutputCode(.OutputObj,"-111112","不可挂出当日之前的排班")
			q OutputObj
		}
		;是否禁用提前挂号配置
		s NotAllowAppRegFlag=+(##class(DHCDoc.Interface.Outside.Config).GetConfigNode(GroupID,"AppReg",HospitalId))
		if (NotAllowAppRegFlag=1)&&(+ASDate'=..%SysDate()){
			d ..SetOutputCode(.OutputObj,"-111113","不可挂出当日号之外的排班")
			q OutputObj
		}
		
		s checkret=##class(DHCExternalService.RegInterface.RegManager).CheckBeforeReg(ScheduleItemCode,myPatientID,HospitalId)
		if (checkret'=""){
	    	d ..SetOutputCode(.OutputObj,"-111114",checkret)
			q OutputObj
		}
	}else{
		d ..SetOutputCode(.OutputObj,"-111115","请指定有效的出诊排班信息")
		q OutputObj	
	}
				
	s PayModeID=##class(DHCExternalService.RegInterface.GetRelate).GetHisPayModeID(PayModeCode,BankCode)
	if PayModeID=""{
		d ..SetOutputCode(.OutputObj,"-111116","系统中未找到此支付方式.")
		q OutputObj
	}
	i PayModeID'=""{
		s PayModeCode=$P(^CT("CTPM",PayModeID),"^",1)
	}
	s PatientNo=##class(DHCExternalService.CardInterface.CardManager).PatientIDToNo(myPatientID)
	s AppRegMethodCode=""
	s AppRegMethodRowID=##class(DHCDoc.Interface.Outside.Config).GetConfigNode(GroupID,"AppRegMethod",HospitalId)
	if AppRegMethodRowID'="" s AppRegMethodCode=$P(^RBC("APTM",AppRegMethodRowID),"^",1)
	if AppRegMethodCode="" s AppRegMethodCode="WIN"
	s RegType=##CLass(web.DHCLockSchedule).GetAutoRegType(ScheduleItemCode)
	s AdmReason=+DefaultBillType
	
	s AccInfo=##class(DHCExternalService.RegInterface.RegManager).getaccinfofromcardno(PatientCard,"0")
	s AccRowId=$piece(AccInfo,"^",2)
	s GroupID=##class(DHCExternalService.RegInterface.GetRelate).GetGroup(UserID)
	s AdmDep=$p($g(^RB("RES",+ScheduleItemCode)),"^",1)
	s ret=##class(web.DHCOPAdmReg).IsEmergency(AdmDep)
	s:(+ret=0) AdmType="O"
	s:(+ret=1) AdmType="E"
	s Left=$piece(AccInfo,"^",4)
	s CashPay=0
	if (PayInsuFeeStr'=""){
		s PayInsuStr=$p(PayInsuFeeStr,"!",2)
		s Length=$Length(PayInsuStr,$c(2))
		f i=1:1:Length
		{
			s Str=$p(PayInsuStr,$c(2),i)
			s InsuPayMode=$p(Str,"^",1)
			i (InsuPayMode="1"){
				s CashPay=$p(Str,"^",2)
			}
		}
	}
	else{
		s CashPay=BillAmount
	}
	if (Left<CashPay)&&(PayModeCode="CPP"){
		d ..SetOutputCode(.OutputObj,"-111117","卡余额不足,请充值.")
		q OutputObj
	}
	s InsuJoinStr=InputObj.PayInsuFeeStr	;医保挂号返回信息串，需与HIS窗口医保挂号返回串字段顺序严格一致。
	s PayBankCode=InputObj.PayBankCode
	s PayCardNo=InputObj.PayCardNo
	s PayFee=InputObj.PayFee
	s TransactionId=InputObj.TransactionId
	s DocOPRegistBill="1" ;直接消费
	TS
	s TradeType="OP"
	s TExpstr=UserID_"^"_GroupID_"^"_""_"^"_HospitalId_"^"_TerminalID_"^"_TradeType_"^"_myPatientID
	s myRet=##class(DHCExternalService.RegInterface.RegManager).SavePayInfoNew(PatientCard,PayModeID,PayFee,.PayDetailsObj,TExpstr)
	if $P(myRet,"^",1)'=0{
		TRO
		d ..SetOutputCode(.OutputObj,$P(myRet,"^",1),$P(myRet,"^",2))
		q OutputObj
	}
	s ETPRowID=$P(myRet,"^",2)
	s TradeID=$P(myRet,"^",3)
	
	s ret=##class(web.DHCOPAdmReg).OPDocRapidRegistBroker(myPatientID,ScheduleItemCode,AdmReason,FeeStr,UserID,GroupID,"","",TimeRangeId,PayModeCode,AccRowId,RegConDisId,InsuJoinStr,ETPRowID,DocOPRegistBill)
	b ;OPRegistBroker OK
	s retFlag=$P(ret,"^",1)
	i (retFlag'=0){
		s errmsg=""
		if retFlag="-201"{
			s errmsg="生成就诊记录失败!"
		}elseif retFlag="-202"{
			s errmsg="取号不成功!"
		}elseif retFlag="-2121"{
			s errmsg="更新预约状态失败"
		}elseif retFlag="-2122"{
			s errmsg="系统繁忙"
		}elseif retFlag="-206"{
			s errmsg="插入挂号费医嘱失败!"
		}elseif retFlag="-207"{
			s errmsg="插入诊查费医嘱失败!"
		}elseif retFlag="-208"{
			s errmsg="插入假日费医嘱失败!"
		}elseif retFlag="-209"{
			s errmsg="插入预约费医嘱失败!"
		}elseif retFlag="-210"{
			s errmsg="计费失败"
		}elseif retFlag="-211"{
			s errmsg="插入挂号记录失败!"
		}elseif retFlag="-212"{
			s errmsg="插入叫号队列失败!"
		}elseif retFlag="-301"{
			s errmsg="超过每人每天可挂限额,不能再挂号或预约!"
		}elseif retFlag="-302"{
			s errmsg="超过每人每天可挂相同号的限额!"
		}elseif retFlag="-303"{
			s errmsg="超过每人每天可挂相同科室号的限额!"
		}elseif retFlag="-304"{
			s errmsg="超过每人每天相同时段同科室同医生限额!"
		}elseif retFlag="-401"{
			s errmsg="还未到达规定的挂号时间"
		}elseif retFlag="-402"{
			s errmsg="还未到达预约时间"
		}elseif retFlag="-403"{
			s errmsg="还未到达加号的时间"
		}elseif retFlag="-404"{
			s errmsg="已经过了此排班记录出诊时间点!"
		}elseif retFlag="-405"{
			s errmsg="请去挂号设置界面维护免费医嘱!"
		}elseif retFlag="-406"{
			s errmsg="已过挂号结束时间!"
		}elseif retFlag="-2010"{
			s errmsg="更新医保挂号信息失败!"
		}elseif retFlag="-213"{
			s errmsg="已经开启停止挂号,不予许挂号及取号!"
		}elseif retFlag="-405"{
			s errmsg="请联系管理员到挂号设置界面维护免费医嘱!"
		}elseif retFlag[","{
			s errmsg=$p(retFlag,",",2,$l(retFlag,","))
			s retFlag=$p(retFlag,",",1)
		}else{
			
		}
		s errmsg=retFlag_"-挂号失败:"_errmsg
		TRO
		d ..SetOutputCode(.OutputObj,"-111118",errmsg)
		q OutputObj
	}
	
	s AdmDr=$P(ret,"^",2)
	S RegFeeRowId=$O(^User.DHCRegistrationFeeI("ADM",AdmDr,""))
	s RegInfoStr=##class(DHCDoc.Common.pa).GetOPPrintData(RegFeeRowId)
	d ##Class(DHCDoc.Util.FromJSON).FromJSONToArr(RegInfoStr,.RegInfoArr)
	s RegOrderFee=""
	if $d(RegInfoArr){
		s AdmDr=RegInfoArr(1,"AdmNo")
		s RegOrderFee=RegInfoArr(1,"Total")
	}
	/*s TradeID=""
	s RegOrderFee=$tr(RegOrderFee," ","")
	s RegOrderFee=+RegOrderFee
	s PayModeDr=$o(^CT("CTPM",0,"Code",PayModeCode,0))
	s TradeType="OP"
	s TExpstr=UserID_"^"_GroupID_"^"_""_"^"_HospitalId_"^"_TerminalID_"^"_TradeType_"^"_myPatientID_"^"_PayModeDr
	s ret=##class(DHCExternalService.RegInterface.RegManager).SavePayInfo(AdmDr,PayModeDr,PayFee,PatientCard,.PayDetailsObj,TExpstr,.errmsg)
	if +ret=0{
		s TradeID=$p(ret,"^",4)	
	}else{
		TRO
		d ..SetOutputCode(.OutputObj,"-111119",errmsg)
		q OutputObj
	}*/
	TC
	s OutputObj.ResultCode="0"
	s OutputObj.ResultContent="挂号成功"
	if $d(RegInfoArr){
		s SeqCode=RegInfoArr(1,"SeqNo")
		s RegFee=RegInfoArr(1,"RegFee")
		s CheckFee=RegInfoArr(1,"OtherFee")+RegInfoArr(1,"AppFee")
		s TotalFee=+($tr(RegInfoArr(1,"Total")," ",""))
		s TotalRMBDX=RegInfoArr(1,"TotalRMBDX")
		s AdmitRange=RegInfoArr(1,"TimeRangeInfo")
		s DeptName=RegInfoArr(1,"RegDep")
		s DoctorName=RegInfoArr(1,"DocDesc")
		s DoctorLevelDesc=RegInfoArr(1,"SessionType")
		s ReceiptNo=RegInfoArr(1,"INVPRTNo")
		s RegistrationID=RegInfoArr(1,"RegfeeRowId")
		s TimeRange=RegInfoArr(1,"TimeRange")
		s OutputObj.SeqCode=SeqCode
		s OutputObj.RegFee=RegFee
		s OutputObj.CheckFee=CheckFee
		s OutputObj.TotalFee=TotalFee
		s OutputObj.TotalRMBDX=TotalRMBDX
		s OutputObj.AdmitRange=AdmitRange
		s OutputObj.AdmitAddress=##class(DHCExternalService.RegInterface.SynVisitSchedule).GetAdmitAddress(ScheduleItemCode)
		s OutputObj.TransactionId=TransactionId
		s OutputObj.HisTradeOrderId=TradeID
		s OutputObj.AdmNo=AdmDr
		s OutputObj.DeptCode=""
		s OutputObj.DeptName=DeptName
		s OutputObj.DoctorCode=""
		s OutputObj.DoctorName=DoctorName
		s OutputObj.DoctorLevelCode=""
		s OutputObj.DoctorLevelDesc=DoctorLevelDesc
		s OutputObj.ReceiptNo=ReceiptNo
		s OutputObj.RegistrationID=RegistrationID
		s OutputObj.TimeRange=TimeRange
		s OutputObj.PrintDataJson=RegInfoStr
	}
	q OutputObj
OPRapidRegistErr
	if $TLEVEL>0{
    	TRO
	}
	s $ZTRAP=""
	s OutputObj=..GetOutputObj("1101")
	d ..SetOutputCode(.OutputObj,"-1","OPRapidRegist调用异常"_$TR($TR($ZE,"<","!!"),">","!!"))
    q OutputObj
}

}
