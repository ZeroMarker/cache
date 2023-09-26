Class DHCExternalService.MedicalEPMI.Methods Extends (%RegisteredObject, %XML.Adaptor) [ Not ProcedureBlock ]
{

/// w ##class(DHCExternalService.MedicalEPMI.Methods).GetPatInfo("")
ClassMethod GetPatInfo(XMLRequest As %String) As DHCExternalService.MedicalEPMI.Entity.GetPatInfoRp
{
	s ^TMPMedicalEPMIXML("Request","GetPatInfo")=XMLRequest
	;s XMLRequest="<Request><TradeCode>3030</TradeCode><TransactionId></TransactionId><ExtOrgCode>APP</ExtOrgCode><ClientType>WEB</ClientType><TerminalID></TerminalID><HospitalId>1</HospitalId><ExtUserID>APP_001</ExtUserID><PatientCard></PatientCard><CardType></CardType><PatientID></PatientID><TerminalID></TerminalID><IDNo>360822198305022623</IDNo><PatientName>东测12</PatientName></Request>"
	s $ZTRAP="GetPatInfoErr"
	;DHCExternalService.MedicalEPMI.Entity.GetPatInfoRq
	s InputObj=..GetInputObj("3030",XMLRequest)
	s UserID=##class(DHCExternalService.MedicalEPMI.GetRelate).GetUser(InputObj.ExtUserID)
	s CardType=InputObj.CardType
	s PatientCard=InputObj.PatientCard
	s PatientNo=InputObj.PatientID
	s CredNo=InputObj.IDNo
	
	s OutputObj=..GetOutputObj("3030")
	s OutputObj.ResultCode="0"
	s OutputObj.ResultContent=""
	
	if (CardType'="")
	{
		set CardType=##Class(DHCExternalService.MedicalEPMI.GetRelate).GetHisCardTypeID(CardType)
	}
	
	;必须条件判断
	if (PatientCard="")&&(PatientNo="")&&(CredNo="") d ..SetOutputCode(.OutputObj,"-330001","卡号和病人ID不能都为空.") q OutputObj
	s FindActivePatientCardRowid=""
	s myPatientID=""
	if PatientNo'="" {
		s myPatientID=$o(^PAPERi("PAPMI_PatNo",$ZCVT(PatientNo,"U"),""))
		s PatMasActive=$P($G(^PAPER(myPatientID,"PAT",1)),"^",6)
		if PatMasActive="N" d ..SetOutputCode(.OutputObj,"-330003","病人主索引为无效主索引,可能已经合并到其他的主索引上")
	}elseif PatientCard'="" {
		s CFRowid=0
		for {
			s CFRowid=$O(^DHCCARDi("CF",0,"CardNo",PatientCard,CFRowid)) Q:CFRowid=""
			s CFActive=$p(^DHCCARD("CF",CFRowid),"^",10)
			Continue:CFActive'="N"
			s CFCardTypeDR=$p(^DHCCARD("CF",CFRowid),"^",16)
			b ;aa
			Continue:(CardType'="")&(CardType'=CFCardTypeDR)
			s myPatientID=$p(^DHCCARD("CF",CFRowid),"^",4)
			b ;aaaaa
			s FindActivePatientCardRowid=CFRowid
		}
		if myPatientID="" d ..SetOutputCode(.OutputObj,"-330002","卡号在系统中未找到")
	}elseif CredNo'="" {
		;根据身份证取最近的患者病人ID
		s myPatientIDStr=##class(DHCExternalService.MedicalEPMI.Public).GetHighestLevelPAPMIByIDNo(CredNo)
		s myPatientID=$p(myPatientIDStr,"^",1)
		s MulIDCount=$p(myPatientIDStr,"^",2)
		i MulIDCount>1 {
			;d ..SetOutputCode(.OutputObj,"-330003","您在医院存在多个ID号，请到医院窗口进行合并，否则将无法使用手机APP进行挂号")
			;q OutputObj
		}
	}
	b ;11
	i '$d(^PAPER(+myPatientID,"ALL")) d ..SetOutputCode(.OutputObj,"-330004","证件号码在系统中未找到")
	;得到病人信息
	i OutputObj.ResultCode="0" {
		Set PatientName=$p(^PAPER(myPatientID,"ALL"),"^",1)
		//医保号
		set PatNo=$p(^PAPER(myPatientID,"PAT",1),"^",2)
		set PatYBCode=$p($g(^PAPER(myPatientID,"ALL")),"^",19)
		set Sex=""
		set SexCode=$p(^PAPER(myPatientID,"ALL"),"^",7)
		i SexCode'="" set Sex=$p(^CT("SEX",SexCode),"^",2)
		set DOB=$p(^PAPER(myPatientID,"ALL"),"^",6)
		set DocumentID=$p(^PAPER(myPatientID,"PAT",1),"^",22)
		set AddressId=+$g(^PAPER(myPatientID,"PER","ADD",0))
		set Address=$g(^PAPER(myPatientID,"PER","ADD",AddressId))
		set IDTypeDesc=""
		set IDTypeCode=$p(^PAPER(myPatientID,"PAT",3),"^",7)
		if IDTypeCode'="" set IDTypeDesc=$p(^PAC("CARD",IDTypeCode),"^",7)
		set IDNo=$p($g(^PAPER(myPatientID,"PAT",3)),"^",6)
		s TelPhone=$p($g(^PAPER(myPatientID,"PER",1)),"^",11)
		Set PatCatDr=$p(^PAPER(myPatientID,"PER",1),"^",10)
		i PatCatDr'="" {
			//病人类型描述
			s OutputObj.PatType=$p($g(^CT("SS",PatCatDr)),"^",2)
		}
		
		;对象赋值
		s OutputObj.PAPMIID=myPatientID
		s OutputObj.PatientID=PatNo
		s OutputObj.PatientName=PatientName
		s OutputObj.SexCode=SexCode
		s OutputObj.Sex=Sex
		s OutputObj.DOB=$zd(DOB,3)
		s OutputObj.DocumentID=DocumentID
		s OutputObj.Address=Address
		s OutputObj.IDTypeCode=IDTypeCode
		s OutputObj.IDTypeDesc=IDTypeDesc
		s OutputObj.IDNo=IDNo
		s OutputObj.MobilePhone=TelPhone
		
		
		i FindActivePatientCardRowid'="" {
			s CardTypeCode=""
			s CardTypeDR=$P(^DHCCARD("CF",FindActivePatientCardRowid),"^",16)
			i CardTypeDR'="" s CardTypeCode=$p(^DHCCARDTYPEDef(CardTypeDR),"^",1)
			s OutputObj.CardNo=PatientCard
			s OutputObj.CardTypeCode=CardTypeCode
		}else{
			s OutputObj.CardNo=##class(web.DHCDocCommon).GetCardNoByPAPER("LAST","",myPatientID)
			i OutputObj.CardNo'="" {
				s CFRowId=$O(^DHCCARDi("CF",0,"CardNo",OutputObj.CardNo,0))
				i CFRowId'="" {
					s CardTypeRowId=$p(^DHCCARD("CF",CFRowId),"^",16)
					s OutputObj.CardTypeCode=$p($g(^DHCCARDTYPEDef(CardTypeRowId)),"^",1)
				}
			}
		}
	}
	;s AccInfo=##class(web.UDHCAccManageCLS0).GetAccInfoByPAPMI(PatientCard,PatientID,"")
	;s OutputObj.AccDepositAmount=$p(AccInfo,"^",2)
	
	DO OutputObj.XMLExportToString(.XML,"Response")
	s ^TMPMedicalEPMIXML("Response","GetPatInfo")=XML
	q OutputObj
GetPatInfoErr
	;q "-1^GetPatInfo调用异常"_$ZERROR
	s OutputObj=..GetOutputObj("3030")
	s OutputObj.ResultCode="-1"
	s OutputObj.ResultContent="GetPatInfo调用异常"_$ZERROR
	q OutputObj
}

/// w ##class(DHCExternalService.MedicalEPMI.Methods).BuildMedical("")
ClassMethod BuildMedical(XMLRequest As %String) As DHCExternalService.MedicalEPMI.Entity.BuildMedicalRp
{
	s ^TMPMedicalEPMIXML("Request","BuildMedical")=XMLRequest
	;s XMLRequest="<Request><TradeCode>3030</TradeCode><TransactionId></TransactionId><ExtOrgCode>APP</ExtOrgCode><ClientType>WEB</ClientType><TerminalID></TerminalID><HospitalId>1</HospitalId><ExtUserID>APP_001</ExtUserID><PatientCard>2157988279</PatientCard><CardType></CardType><PatientID></PatientID><TerminalID></TerminalID><IDNo>500234193508077625</IDNo><PatientName>东测12</PatientName></Request>"
	s $ZTRAP="BuildMedicalErr"
	;DHCExternalService.MedicalEPMI.Entity.BuildMedicalRq
	s InputObj=..GetInputObj("3031",XMLRequest)
	s UserID=##class(DHCExternalService.MedicalEPMI.GetRelate).GetUser(InputObj.ExtUserID)
	
	s OutputObj=..GetOutputObj("3031")
	s OutputObj.ResultCode="0000"
	s OutputObj.ResultContent=""
	
	if InputObj.PatientID="" d ..SetOutputCode(.OutputObj,"-3031001","患者ID不能为空.") q OutputObj
	if InputObj.Name="" d ..SetOutputCode(.OutputObj,"-3031002","姓名不能为空.") q OutputObj
	if InputObj.Sex="" d ..SetOutputCode(.OutputObj,"-3031003","性别不能为空.") q OutputObj
	if InputObj.Birth="" d ..SetOutputCode(.OutputObj,"-3031004","出生日期不能为空.") q OutputObj
	if InputObj.CredType="" d ..SetOutputCode(.OutputObj,"-3031005","证件类型不能为空.") q OutputObj
	if InputObj.CredNo="" d ..SetOutputCode(.OutputObj,"-3031006","证件号码不能为空.") q OutputObj
	//if InputObj.PatYBCode="" d ..SetOutputCode(.OutputObj,"-3031007","医保号") q OutputObj
	if InputObj.PAPERMarital="" d ..SetOutputCode(.OutputObj,"-3031008","婚姻情况不能为空.") q OutputObj
	if InputObj.TelHome="" d ..SetOutputCode(.OutputObj,"-3031009","联系电话不能为空.") q OutputObj
	if InputObj.PatType="" d ..SetOutputCode(.OutputObj,"-3031010","病人类型不能为空.") q OutputObj
	if InputObj.Nation="" d ..SetOutputCode(.OutputObj,"-3031011","民族不能为空.") q OutputObj
	if InputObj.Country="" d ..SetOutputCode(.OutputObj,"-3031012","国籍不能为空.") q OutputObj
	if InputObj.HomePlace="" d ..SetOutputCode(.OutputObj,"-3031013","籍贯不能为空.") q OutputObj
	if InputObj.CountryBirth="" d ..SetOutputCode(.OutputObj,"-3031014","出生国家不能为空.") q OutputObj
	if InputObj.ProvinceBirth="" d ..SetOutputCode(.OutputObj,"-3031015","出生省不能为空.") q OutputObj
	if InputObj.CityBirth="" d ..SetOutputCode(.OutputObj,"-3031016","出生市不能为空.") q OutputObj
	if InputObj.AreaBirth="" d ..SetOutputCode(.OutputObj,"-3031017","出生区县不能为空.") q OutputObj
	//if InputObj.AddressBirth="" d ..SetOutputCode(.OutputObj,"-3031018","出生地址") q OutputObj
	if InputObj.CountryCurrent="" d ..SetOutputCode(.OutputObj,"-3031019","现住址国家不能为空.") q OutputObj
	if InputObj.ProvinceCurrent="" d ..SetOutputCode(.OutputObj,"-3031020","现住址省不能为空.") q OutputObj
	if InputObj.CityCurrent="" d ..SetOutputCode(.OutputObj,"-3031021","现住市不能为空.") q OutputObj
	if InputObj.AreaCurrent="" d ..SetOutputCode(.OutputObj,"-3031022","现住区县不能为空.") q OutputObj
	if InputObj.AddressCurrent="" d ..SetOutputCode(.OutputObj,"-3031023","现住地址不能为空.") q OutputObj
	//if InputObj.ZipCurrent="" d ..SetOutputCode(.OutputObj,"-3031024","现住邮编") q OutputObj
	if InputObj.CountryHouse="" d ..SetOutputCode(.OutputObj,"-3031025","户口国家不能为空.") q OutputObj
	if InputObj.ProvinceHouse="" d ..SetOutputCode(.OutputObj,"-3031026","户口省不能为空.") q OutputObj
	if InputObj.CityHouse="" d ..SetOutputCode(.OutputObj,"-3031027","户口市不能为空.") q OutputObj
	if InputObj.AreaHouse="" d ..SetOutputCode(.OutputObj,"-3031028","户口区县不能为空.") q OutputObj
	if InputObj.AddressHouse="" d ..SetOutputCode(.OutputObj,"-3031029","户口地址不能为空.") q OutputObj
	//if InputObj.ZipHouse="" d ..SetOutputCode(.OutputObj,"-3031030","户口邮编") q OutputObj
	if InputObj.Vocation="" d ..SetOutputCode(.OutputObj,"-3031031","职业不能为空.") q OutputObj
	if InputObj.Company="" d ..SetOutputCode(.OutputObj,"-3031032","工作单位不能为空.") q OutputObj
	//if InputObj.TelOffice="" d ..SetOutputCode(.OutputObj,"-3031033","工作单位电话") q OutputObj
	//if InputObj.CompanyZip="" d ..SetOutputCode(.OutputObj,"-3031034","工作单位邮编") q OutputObj
	if InputObj.ForeignName="" d ..SetOutputCode(.OutputObj,"-3031035","联系人姓名不能为空.") q OutputObj
	if InputObj.CTRelation="" d ..SetOutputCode(.OutputObj,"-3031036","与联系人关系不能为空.") q OutputObj
	//if InputObj.ForeignAddress="" d ..SetOutputCode(.OutputObj,"-3031037","联系人地址") q OutputObj
	//if InputObj.ForeignZip="" d ..SetOutputCode(.OutputObj,"-3031038","联系人邮编") q OutputObj
	if InputObj.ForeignPhone="" d ..SetOutputCode(.OutputObj,"-3031039","联系人电话不能为空.") q OutputObj
	//if InputObj.ForeignIDCard="" d ..SetOutputCode(.OutputObj,"-3031040","联系人证件号") q OutputObj
	//if InputObj.HCP="" d ..SetOutputCode(.OutputObj,"-3031041","公费单位") q OutputObj
	//if InputObj.EmployeeNo="" d ..SetOutputCode(.OutputObj,"-3031042","工号") q OutputObj
	//if InputObj.HealthCareRegion="" d ..SetOutputCode(.OutputObj,"-3031043","行政区域") q OutputObj
	//if InputObj.AdmSource="" d ..SetOutputCode(.OutputObj,"-3031044","是否专程来京就诊") q OutputObj
	
	;组织建大病历参数
	s ConfigInfo="",CardInfo="",AccInfo="",DepositInfo="",CardINVInfo="",SepcialInfo=""
	s PaPatInfo=""
	s ExpStr="1^"
	/* 注释的这段是web.DHCEntity.PCA.PATMAS类和User.DHCRegMedicalEPMI类的匹配
	s myPatObj=##class(web.DHCEntity.PCA.PATMAS).%New()
	s myPatObj.PAPMIRowID=InputObj.PatientID
	s myPatObj.Name=InputObj.Name
	s myPatObj.Sex=InputObj.Sex
	s myPatObj.Birth=InputObj.Birth
	s myPatObj.CredType=InputObj.CredType
	s myPatObj.CredNo=InputObj.CredNo
	s myPatObj.PatYBCode=InputObj.PatYBCode
	s myPatObj.PAPERMarital=InputObj.PAPERMarital
	s myPatObj.TelHome=InputObj.TelHome
	s myPatObj.PatType=InputObj.PatType
	s myPatObj.NationDescLookUpRowID=InputObj.Nation
	s myPatObj.CountryDescLookUpRowID=InputObj.Country
	s myPatObj.HomePlace=InputObj.HomePlace
	//s myPatObj.CountryBirth=InputObj.CountryBirth	;出生国家同国籍
	s myPatObj.ProvinceBirth=InputObj.ProvinceBirth
	s myPatObj.CityBirth=InputObj.CityBirth
	s myPatObj.AreaBirth=InputObj.AreaBirth
	s myPatObj.AddressBirth=InputObj.AddressBirth
	//s myPatObj.CountryCurrent=InputObj.CountryCurrent ;现住址国家同国籍
	s myPatObj.ProvinceInfoLookUpRowID=InputObj.ProvinceCurrent
	s myPatObj.CityDescLookUpRowID=InputObj.CityCurrent
	s myPatObj.CTAreaLookUpRowID=InputObj.AreaCurrent
	s myPatObj.Address=InputObj.AddressCurrent
	s myPatObj.PostCode=InputObj.ZipCurrent
	//s myPatObj.CountryHouse=InputObj.CountryHouse ;现住址国家同国籍
	s myPatObj.ProvinceHouse=InputObj.ProvinceHouse
	s myPatObj.Cityhouse=InputObj.CityHouse
	s myPatObj.AreaHouse=InputObj.AreaHouse
	s myPatObj.RegisterPlace=InputObj.AddressHouse
	s myPatObj.PostCodeHouse=InputObj.ZipHouse
	s myPatObj.Vocation=InputObj.Vocation
	s myPatObj.Company=InputObj.Company
	s myPatObj.TelOffice=InputObj.TelOffice
	s myPatObj.CompanyPostCode=InputObj.CompanyZip
	s myPatObj.ForeignName=InputObj.ForeignName
	s myPatObj.CTRelationDR=InputObj.CTRelation
	s myPatObj.ForeignAddress=InputObj.ForeignAddress
	s myPatObj.ForeignPostCode=InputObj.ForeignZip
	s myPatObj.ForeignPhone=InputObj.ForeignPhone
	s myPatObj.ForeignIDCard=InputObj.ForeignIDCard
	s myPatObj.HCPDR=InputObj.HCP
	s myPatObj.InsurCardNo=InputObj.HCPNo
	s myPatObj.EmployeeNo=InputObj.EmployeeNo
	s myPatObj.HealthCareRegion=InputObj.HealthCareRegion
	s myPatObj.AdmSource=InputObj.AdmSource
	*/
	s MedicalEPMIId=$O(^User.DHCRegMedicalEPMII("EPMI",InputObj.PatientID,0))
	if MedicalEPMIId'="" {
		s MEPMIObj=##class(User.DHCRegMedicalEPMI).%OpenId(MedicalEPMIId,1)
	}else{
		s MEPMIObj=##class(User.DHCRegMedicalEPMI).%New()
	}
	if '$ISOBJECT(MEPMIObj) {
		d ..SetOutputCode(.OutputObj,"-3031045","HIS创建存储对象失败,错误:"_$zerror)
		q OutputObj
	}
	
	s MEPMIObj.PatientID=InputObj.PatientID
	s MEPMIObj.Name=InputObj.Name
	s MEPMIObj.Sex=InputObj.Sex
	s MEPMIObj.Birth=InputObj.Birth
	s MEPMIObj.CredType=InputObj.CredType
	s MEPMIObj.CredNo=InputObj.CredNo
	s MEPMIObj.PatYBCode=InputObj.PatYBCode
	s MEPMIObj.PAPERMarital=InputObj.PAPERMarital
	s MEPMIObj.TelHome=InputObj.TelHome
	s MEPMIObj.PatType=InputObj.PatType
	s MEPMIObj.Nation=InputObj.Nation
	s MEPMIObj.Country=InputObj.Country
	s MEPMIObj.HomePlace=InputObj.HomePlace
	s MEPMIObj.CountryBirth=InputObj.CountryBirth	;出生国家同国籍
	s MEPMIObj.ProvinceBirth=InputObj.ProvinceBirth
	s MEPMIObj.CityBirth=InputObj.CityBirth
	s MEPMIObj.AreaBirth=InputObj.AreaBirth
	s MEPMIObj.AddressBirth=InputObj.AddressBirth
	s MEPMIObj.CountryCurrent=InputObj.CountryCurrent ;现住址国家同国籍
	s MEPMIObj.ProvinceCurrent=InputObj.ProvinceCurrent
	s MEPMIObj.CityCurrent=InputObj.CityCurrent
	s MEPMIObj.AreaCurrent=InputObj.AreaCurrent
	s MEPMIObj.AddressCurrent=InputObj.AddressCurrent
	s MEPMIObj.ZipCurrent=InputObj.ZipCurrent
	s MEPMIObj.CountryHouse=InputObj.CountryHouse ;现住址国家同国籍
	s MEPMIObj.ProvinceHouse=InputObj.ProvinceHouse
	s MEPMIObj.CityHouse=InputObj.CityHouse
	s MEPMIObj.AreaHouse=InputObj.AreaHouse
	s MEPMIObj.AddressHouse=InputObj.AddressHouse
	s MEPMIObj.ZipHouse=InputObj.ZipHouse
	s MEPMIObj.Vocation=InputObj.Vocation
	s MEPMIObj.Company=InputObj.Company
	s MEPMIObj.TelOffice=InputObj.TelOffice
	s MEPMIObj.CompanyZip=InputObj.CompanyZip
	s MEPMIObj.ForeignName=InputObj.ForeignName
	s MEPMIObj.CTRelation=InputObj.CTRelation
	s MEPMIObj.ForeignAddress=InputObj.ForeignAddress
	s MEPMIObj.ForeignZip=InputObj.ForeignZip
	s MEPMIObj.ForeignPhone=InputObj.ForeignPhone
	s MEPMIObj.ForeignIDCard=InputObj.ForeignIDCard
	s MEPMIObj.HCP=InputObj.HCP
	s MEPMIObj.HCPNo=InputObj.HCPNo
	s MEPMIObj.EmployeeNo=InputObj.EmployeeNo
	s MEPMIObj.HealthCareRegion=InputObj.HealthCareRegion
	s MEPMIObj.AdmSource=InputObj.AdmSource
	s sc=MEPMIObj.%Save()
	if $$$ISERR(sc) {
		d ..SetOutputCode(.OutputObj,"-3031046","保存建大病历信息失败,错误代码:"_rtn)
		q OutputObj
	}else{
		s OutputObj.ResultCode="0000"
		s OutputObj.ResultContent="成功"
		s OutputObj.UniqueID=MEPMIObj.%Id()
		DO OutputObj.XMLExportToString(.XML,"Response")
		s ^TMPMedicalEPMIXML("Response","BuildMedical")=XML
	}
	q OutputObj
BuildMedicalErr
	;q "-1^BuildMedical调用异常"_$ZERROR
	s OutputObj=..GetOutputObj("3031")
	s OutputObj.ResultCode="-1"
	s OutputObj.ResultContent="BuildMedical调用异常"_$ZERROR
	q OutputObj
}

/// 得到入参对象
ClassMethod GetInputObj(TradeCode, XMLRequest) As %RegisteredObject
{
	n (TradeCode,XMLRequest)
	s:TradeCode="3030" ClassName="DHCExternalService.MedicalEPMI.Entity.GetPatInfoRq"
	s:TradeCode="3031" ClassName="DHCExternalService.MedicalEPMI.Entity.BuildMedicalRq"
	
	s InputObj=$ZOBJCLASSMETHOD(ClassName,"%New")
	d InputObj.XMLNodeDeserialize(.InputObj,"Request",XMLRequest)
	q InputObj
}

/// 得到出参对象
ClassMethod GetOutputObj(TradeCode) As %RegisteredObject
{
	n (TradeCode)
	s:TradeCode="3030" ClassName="DHCExternalService.MedicalEPMI.Entity.GetPatInfoRp"
	s:TradeCode="3031" ClassName="DHCExternalService.MedicalEPMI.Entity.BuildMedicalRp"
	
	s OutputObj=$ZOBJCLASSMETHOD(ClassName,"%New")
	q OutputObj
}

/// 赋值出参标识
ClassMethod SetOutputCode(ByRef object As %ObjectHandle, ResultCode As %String, ResultContent As %String)
{
	s object.ResultCode=ResultCode
	s object.ResultContent=ResultContent
}

}
