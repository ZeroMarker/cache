Class DHCENS.LIS.GetPatInfo Extends (%RegisteredObject, %XML.Adaptor) [ Inheritance = right ]
{

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLNAME = "GetPatInfoReturn";

Parameter XMLIGNORENULL = 1;

Property DOB As %String(TRUNCATE = 1);

Property DocumentID As %String(TRUNCATE = 1);

Property IdentityCardNo As %String(TRUNCATE = 1);

Property PatientAddress As %String(TRUNCATE = 1);

Property PatientName As %String(TRUNCATE = 1);

Property RegisterNo As %String(TRUNCATE = 1);

Property Sex As %String(TRUNCATE = 1);

/// 病人就诊列表
Property AdmInfos As list Of DHCENS.LIS.AdmInfo;

Property ResultCode As %String(TRUNCATE = 1);

Property ResultContent As %String(TRUNCATE = 1);

/// w ##class(DHCENS.LIS.GetPatInfo).GetByCardNoAndPatientNo("","000000000002","0000000003")
ClassMethod GetByCardNoAndPatientNo(CardType As %String, CardNo As %String, PatientNo As %String) As %GlobalCharacterStream
{
	s obj=##class(DHCENS.LIS.GetPatInfo).%New()
	if (CardNo'="") {
		//卡类型需要给定
		s CardType=1
		s PatientID=..GetPatIdByCardNo(CardNo,CardType)
	}
	else
	{
		if (PatientNo'="")
		{
			s PatientID=$o(^PAPERi("PAPMI_PatNo",PatientNo,0))
		}
		else
		{
			s PatientID=""
		}
	}
	
	if PatientID'="" {
		s obj=..GetByPatientID(PatientID)
		s obj.ResultCode="0"
		s obj.ResultContent="成功！！"
	}
	else
	{
		s obj.ResultCode="-1"
		s obj.ResultContent="病人信息不存在！！"
	}

	Do obj.XMLExportToStream(.Xml)
	Set objStream=##class(%GlobalCharacterStream).%New()
    Do objStream.Write("<Response>")
    Do objStream.CopyFrom(Xml)
    Do objStream.Write("</Response>")
	Quit objStream
}

/// 通过ID获取
ClassMethod GetByPatientID(PatientID As %String) As DHCENS.LIS.GetPatInfo
{
	&SQL(Select PAPMI_No,PAPMI_Name,PAPMI_Sex_DR->CTSEX_Desc,PAPMI_Sex_DR->CTSEX_Code,
		TO_Date(PAPMI_DOB,'YYYY-MM-DD'),PAPMI_Medicare,PAPMI_SecondPhone
	     Into :RegisterNo,:PatientName,:Sex,:SexCode,:DOB,:DocumentID,:PatientAddress
	     From SQLUser.PA_PatMas Where PAPMI_RowId=:PatientID)
	i 'SQLCODE {
		s PatientAddress=$g(^PAPER(PatientID,"PER","ADD",1))
		s IdentityCardNo=$P(^PAPER(PatientID,"ALL"),"^",9)
		s object=##class(DHCENS.LIS.GetPatInfo).%New()
		s object.RegisterNo=RegisterNo
		s object.PatientName=PatientName
		s object.Sex=SexCode_"@"_Sex
		s object.DOB=DOB
		s object.IdentityCardNo=IdentityCardNo
		s object.PatientAddress=PatientAddress
		s object.DocumentID=DocumentID
		
		s AdmRowid=""
		for  s AdmRowid=$O(^PAPERdr(PatientID,"ADM","I",AdmRowid))  q:AdmRowid=""  do
		.s AdmInfo=##class(DHCENS.LIS.AdmInfo).GetAdmInfoByRowid(AdmRowid)
		.d object.AdmInfos.Insert(AdmInfo)
		
		Quit object
	}
}

/// 检查卡是否有效
ClassMethod GetPatIdByCardNo(CardNo As %String, CardType As %String) As %String
{
	q:CardNo="" ""
	s ExpStr=""_$C(2)_CardType_$C(2)_"PatInfo"
	s ret=##class(web.UDHCAccManageCLSIF).getaccinfofromcardno(CardNo,"",ExpStr)
	s myACFlag=$P(ret,"^",1)
	Q:(myACFlag="-200") ""   
	s PatId=$p(ret,"^",8)
	q PatId
}

}
