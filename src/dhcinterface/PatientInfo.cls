Class dhcinterface.PatientInfo Extends (%Persistent, %XML.Adaptor) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter XMLIGNOREINVALIDTAG = 1;

/// 住址
Property Address As %String(TRUNCATE = 1);

/// 工作单位
Property Company As %String(TRUNCATE = 1);

/// 出生日期
Property DOB As %String(TRUNCATE = 1);

/// 证件类型
Property IDCardType As %String(TRUNCATE = 1);

/// 身份证号
Property IDCode As %String(TRUNCATE = 1);

/// 姓名
Property Name As %String(TRUNCATE = 1);

/// 用户ID
Property PatientID As %String(TRUNCATE = 1);

/// 病人登记号
Property PatientNo As %String(TRUNCATE = 1);

/// 性别
Property Sex As %String(TRUNCATE = 1);

/// 联系电话
Property TelephoneNo As %String(TRUNCATE = 1);

ClassMethod GetByPatinetID(PatinetID, CardType) As dhcinterface.PatientInfo
{
	n (PatinetID,CardType)
	set PatObj=##class(User.PAPerson).%OpenId(PatinetID)
	set PatientInfoObj=##class(dhcinterface.PatientInfo).%New()
	set PatientInfoObj.Address=PatObj.PAPERStName.GetAt(1)
	set Company=""
	set ComRowId=PatObj.PAPEREmployeeCompanyGetObjectId()
	if (ComRowId'=""){
		set Company=$p(^CT("CTCO",ComRowId),"^",2)
	}
	set PatientInfoObj.Company=PatObj.PAPEREmployeeCompanyGetObjectId()
	set dob=PatObj.PAPERDob
	if dob'="" s dob=$zd(dob,3)
	set PatientInfoObj.DOB=dob
	set IDCardType=$p(^PAPER(PatinetID,"PAT",3),"^",7)
	set PatientInfoObj.IDCardType=IDCardType
	set PatientInfoObj.IDCode=$tr($p(^PAPER(PatinetID,"PAT",3),"^",6)," ")
	set PatientInfoObj.Name=PatObj.PAPERName
	set PatientInfoObj.PatientID=PatinetID
	set PatientInfoObj.PatientNo=$p(^PAPER(PatinetID,"PAT",1),"^",2)
	set PatientInfoObj.Sex=PatObj.PAPERSexDRGetObjectId()
	set PatientInfoObj.TelephoneNo=PatObj.PAPERTelH     ;PAPERTelO
	
	quit PatientInfoObj
}

/// 根据卡号得到病人信息,返回标志和病人的PatientID
ClassMethod GetCardInfo(PatientCardNo, CardType) As %String
{
	n (PatientCardNo,CardType)
	if PatientCardNo="" Quit "-100"
	set CFPatientID=""
	set LocCardType=""
	set CFRowId=0
	for {
		set CFRowId=$O(^DHCCARDi("CF",0,"CardNo",PatientCardNo,CFRowId)) quit:CFRowId=""
		set CardTypeDr=$p(^DHCCARD("CF",CFRowId),"^",16)
		set LocCardType=CardTypeDr
		;set LocCardType=$p(^DHCCARDTYPEDef(CardTypeDr),"^",35)
		if (CardType'="")&&(CardType'=LocCardType) quit
		set CFPatientID=$p(^DHCCARD("CF",CFRowId),"^",4)
	}
	
	if (CFPatientID=""){
		quit "-100^"
	}else{
		quit "0^"_CFPatientID_"^"_LocCardType
	}
}

}
