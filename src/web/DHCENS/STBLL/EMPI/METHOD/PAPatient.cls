Class web.DHCENS.STBLL.EMPI.METHOD.PAPatient Extends (%RegisteredObject, %XML.Adaptor)
{

// w ##class(web.DHCENS.STBLL.EMPI.METHOD.PAPatient).Test()

// w ##class(web.DHCENS.EnsHISService).DHCHisInterfaceV8("SENDPATINFO","5403183")

ClassMethod Test()
{
	/*
	s count=0
	set date=63552 for  set date=$o(^PAPERi("UpdDate",date)) q:((date="")||(date>63583))  d
	.set rowId="0"  for  set rowId=$o(^PAPERi("UpdDate",date,rowId))  q:(rowId="")  d
	..//set tSc=##class(web.DHCENS.EnsHISService).DHCHisInterfaceV8("SENDPATINFO",rowId)
	..set ^DHCENSPatient(rowId)=""
	..set count=count+1
	*/
	set id="" for  set id=$o(^DHCENSPatient(id)) q:id=""  d
	.set tSc=##class(web.DHCENS.EnsHISService).DHCHisInterfaceV8("SENDPATINFO",id)
	QUit tSc
}

// w ##class(web.DHCENS.STBLL.EMPI.METHOD.PAPatient).PAPatient("5350482")

ClassMethod PAPatient(patRowId As %String) As %GlobalCharacterStream
{
	set $zt="Exception"
	set request=##class(web.DHCENS.STBLL.EMPI.MODEL.Request).%New()
	set header=##class(web.DHCENS.STBLL.EMPI.MODEL.Header).%New()
	set header.SourceSystem="01"
	set header.TargetSystem="医院信息平台"
	set request.header=header
	set body=##class(web.DHCENS.STBLL.EMPI.MODEL.Body).%New()
	set Obj=##class(web.DHCENS.STBLL.EMPI.MODEL.PAPatient).%New()
	q:(patRowId="")||($d(^PAPER(patRowId))=0) Obj
	set Obj.PAPATPatientID=$p($g(^PAPER(patRowId,"PAT",1)),"^",1)
	set Obj.PAPATDEName=$p($g(^PAPER(patRowId,"ALL")),"^",1)
	set sexRowID=$p($g(^PAPER(patRowId,"ALL")),"^",7)
	if sexRowID'="" {
		set sexCode=$p($g(^CT("SEX",sexRowID)),"^",1)
		set PAPATDESexCode=##class(web.DHCENS.STBLL.UTIL.EnsSourceLookUpTData).GetTarCode(sexCode,"CT_Sex")
		if $p(PAPATDESexCode,"^",1)=0 {
			set Obj.PAPATDESexCode=$p(PAPATDESexCode,"^",2)
		}
		else  {
			set Obj.PAPATDESexCode=sexCode
		}
	}
	set birthDay=$p($g(^PAPER(patRowId,"ALL")),"^",6)
	set:birthDay="" birthDay=1846
	set:birthDay'="" Obj.PAPATDEDob=$zd(birthDay,3)		
	set PAPATTelephone=$P($g(^PAPER(patRowId,"PER",1)),"^",11)
	set Obj.PAPATTelephone=$e(PAPATTelephone,1,11)
	set occupationRowID="",OccupationDesc=""
	set occupationRowID=$P($G(^PAPER(patRowId,"PER",2)),"^",6)
	if occupationRowID'="" {
		set PAPATOccupationCode=##class(web.DHCENS.STBLL.UTIL.EnsSourceLookUpTData).GetTarCode($p($g(^CT("OCC",occupationRowID)),"^",1),"CT_Occupation")
		set Obj.PAPATOccupationCode=$p(PAPATOccupationCode,"^",2)
	}
	set marryRowID=""
	set marryRowID=$p($g(^PAPER(patRowId,"PER",2)),"^",3)
	if marryRowID'="" {
		set PAPATDEMaritalStatusCode=##class(web.DHCENS.STBLL.UTIL.EnsSourceLookUpTData).GetTarCode($p($g(^CT("MAR",marryRowID)),"^",1),"CT_Marital")
		set Obj.PAPATDEMaritalStatusCode=$p(PAPATDEMaritalStatusCode,"^",2)
	}
	set countryRowID=""
	set countryRowID=$p($g(^PAPER(patRowId,"PER",1)),"^",8)
	set:countryRowID=192 countryRowID=1
	if countryRowID'="" {
		set countryCode=##class(web.DHCENS.STBLL.UTIL.EnsSourceLookUpTData).GetTarCode($p($g(^CT("COU",countryRowID)),"^",1),"CT_Country")
		if $p(countryCode,"^",1)=0 {
			set Obj.PAPATDECountryCode=$p(countryCode,"^",2)
		}
		else  {
			set Obj.PAPATDECountryCode=countryCode
		}
	}
	set nationRowID=""
	set nationRowID=$p($g(^PAPER(patRowId,"PER",2)),"^",1)
	if nationRowID'="" {
		set PAPATDENationCode=##class(web.DHCENS.STBLL.UTIL.EnsSourceLookUpTData).GetTarCode($p($g(^CT("NAT",nationRowID)),"^",1),"CT_Nation")
		set Obj.PAPATDENationCode=$p(PAPATDENationCode,"^",2)
	}
	
	
	set Obj.PAPATRelationName=$p($g(^PAPER(patRowId,"PER",2)),"^",13)
	set PAPATRelationPhone=$P($G(^PAPER(patRowId,"ALL")),"^",4)
	set Obj.PAPATRelationPhone=$e(PAPATRelationPhone,1,11)
	
	set deathDate=$p($g(^PAPER(patRowId,"ALL")),"^",13)
	set:deathDate'="" Obj.PAPATDEDeceasedDate=$zd(deathDate,3)
	set deathTime=$p($g(^PAPER(patRowId,"ALL")),"^",8)
	set:deathTime'="" Obj.PAPATDEDeceasedTime=$zt(deathTime)
	set Obj.PAPATUpdateUserCode="宁医总院"
	
	set identifier=##class(web.DHCENS.STBLL.EMPI.MODEL.PAIdentifier).%New()
	set identifier.PAPATIDPatientID=$p($g(^PAPER(patRowId,"PAT",1)),"^",1)
	set identifier.PAPATIDTypeCode="01"
	set PAPATIDNo=$p($g(^PAPER(patRowId,"PAT",3)),"^",6)
	set:PAPATIDNo="" PAPATIDNo=$p($g(^PAPER(patRowId,"ALL")),"^",9)
	set identifier.PAPATIDNo=PAPATIDNo
	set identifier.PAPATIDUpdateUserCode="无"
	d Obj.identifiers.Insert(identifier)
	d body.paPatients.Insert(Obj)
	set request.body=body
	d request.XMLExportToStream(.stream)
	b ;1
	q stream
Exception
	Quit "-1^"_$ze
}

ClassMethod PAPatientOld(patRowId As %String) As %String
{
	set $zt="Exception"
	set request=##class(web.DHCENS.STBLL.EMPI.MODEL.Request).%New()
	set header=##class(web.DHCENS.STBLL.EMPI.MODEL.Header).%New()
	set header.SourceSystem="BJXHYY"
	set header.TargetSystem="医院信息平台"
	set request.header=header
	set body=##class(web.DHCENS.STBLL.EMPI.MODEL.Body).%New()
	set Obj=##class(web.DHCENS.STBLL.EMPI.MODEL.PAPatient).%New()
	q:(patRowId="")||($d(^PAPER(patRowId))=0) Obj
	set Obj.PAPATPatientID=$p($g(^PAPER(patRowId,"PAT",1)),"^",1)
	set Obj.PAPATDEName=$p($g(^PAPER(patRowId,"ALL")),"^",1)
	set sexRowID=$p($g(^PAPER(patRowId,"ALL")),"^",7)
	if sexRowID'="" {
		set sexCode=$p($g(^CT("SEX",sexRowID)),"^",1)
		set PAPATDESexCode=##class(web.DHCENS.STBLL.UTIL.EnsSourceLookUpTData).GetTarCode(sexCode,"CT_Sex")
		if $p(PAPATDESexCode,"^",1)=0 {
			set Obj.PAPATDESexCode=$p(PAPATDESexCode,"^",2)
		}
		else  {
			set Obj.PAPATDESexCode=sexCode
		}
	}
	set birthDay=$p($g(^PAPER(patRowId,"ALL")),"^",6)
	set:birthDay'="" Obj.PAPATDEDob=$zd(birthDay,3)		
	set Obj.PAPATTelephone=$P($g(^PAPER(patRowId,"PER",1)),"^",11)
	set occupationRowID="",OccupationDesc=""
	set occupationRowID=$P($G(^PAPER(patRowId,"PER",2)),"^",6)
	b ;0
	set:occupationRowID'="" Obj.PAPATOccupationCode=$p($g(^CT("OCC",occupationRowID)),"^",1)
	set marryRowID=""
	set marryRowID=$p($g(^PAPER(patRowId,"PER",2)),"^",3)
	set:marryRowID'="" Obj.PAPATDEMaritalStatusCode=$p($g(^CT("MAR",marryRowID)),"^",1)
	set countryRowID=""
	set countryRowID=$p($g(^PAPER(patRowId,"PER",1)),"^",8)
	if countryRowID'="" {
		set countryCode=$p($g(^CT("COU",countryRowID)),"^",1)
		set PAPATDECountryCode=##class(web.DHCENS.STBLL.UTIL.EnsSourceLookUpTData).GetTarCode(countryCode,"CT_Country")
		if $p(PAPATDECountryCode,"^",1)=0 {
			set Obj.PAPATDECountryCode=$p(PAPATDECountryCode,"^",2)
		}
		else  {
			set Obj.PAPATDECountryCode=countryCode
		}
	}
	set nationRowID=""
	set nationRowID=$p($g(^PAPER(patRowId,"PER",2)),"^",1)
	set:nationRowID'="" Obj.PAPATDENationCode=$p($g(^CT("NAT",nationRowID)),"^",1)
	set Obj.PAPATRelationName=$p($g(^PAPER(patRowId,"PER",2)),"^",13)
	set Obj.PAPATRelationPhone=$P($G(^PAPER(patRowId,"ALL")),"^",4)
	set deathDate=$p($g(^PAPER(patRowId,"ALL")),"^",13)
	set:deathDate'="" Obj.PAPATDEDeceasedDate=$zd(deathDate,3)
	set deathTime=$p($g(^PAPER(patRowId,"ALL")),"^",8)
	set:deathTime'="" Obj.PAPATDEDeceasedTime=$zt(deathTime)
	set Obj.PAPATUpdateUserCode="协和医院"
	d body.paPatients.Insert(Obj)
	set request.body=body
	d request.XMLExportToStream(.stream)
	set soapObj=##class(web.DHCENS.STBLL.EMPI.SOAP.GMDM.PublishedWebServiceSoap).%New()
	set tSC=soapObj.SaveManagerDataInfo("GMDMMES0024",stream)
	q tSC
Exception
	Quit "-1^"_$ze
}

/// Return:0^PatRowId^登记号
/// w ##class(web.DHCENS.STBLL.EMPI.METHOD.PAPatient).SavePAPatient("")
ClassMethod SavePAPatient(Input As %GlobalCharacterStream) As %String
{
	
	set $ZTrap = "Exception"

	Set reader=##class(%XML.Reader).%New()
	Set sc=reader.OpenStream(Input)
	Do reader.Correlate("Request","web.DHCENS.STBLL.EMPI.MODEL.Request")
	Set Mainobj=##class(web.DHCENS.STBLL.EMPI.MODEL.Request).%New()
	While reader.Next(.Obj,.sc) {
		 set Mainobj=Obj
	}
	s Patobj=##class(web.DHCENS.STBLL.EMPI.MODEL.PAPatient).%New()
	s Patobj=Mainobj.body.paPatients.GetAt(1)
	s PAPMIRowID=""
	// 判断第三方登记号在对照表中是否存在
	set RowId=$o(^User.EnsPIXI("PatientID",Patobj.PAPATPatientID,""))
	i RowId'=""
	{		
		s PAPMIRowID=$o(^PAPERi("PAPMI_PatNo",$$ALPHAUP^SSUTIL4(Patobj.PAPATPatientID),""))
	}
	
	s PatMAS=##class(web.DHCEntity.PCA.PATMAS).%New()	
	s PatMAS.PAPMIRowID		=PAPMIRowID
	s PatMAS.PAPMINo		=Patobj.PAPATPatientID	//登记号
	s PatMAS.Name			=Patobj.PAPATDEName		//姓名
	s CTSexDr=""
	s:Patobj.PAPATDESexCode'="" CTSexDr=$o(^CT("SEX",0,"Code",$$ALPHAUP^SSUTIL4(Patobj.PAPATDESexCode),""))
	s PatMAS.Sex			=CTSexDr			//性别	
	s PatMAS.Birth			=Patobj.PAPATDEDob	//出生日期	
	s MaritalDr=""
	s:Patobj.PAPATDEMaritalStatusCode'="" MaritalDr=$o(^CT("MAR",0,"Code",$$ALPHAUP^SSUTIL4(Patobj.PAPATDEMaritalStatusCode),""))
	s PatMAS.PAPERMarital	=MaritalDr			//婚姻
	s CTNationDr=""
	s:Patobj.PAPATDENationCode'="" CTNationDr=$o(^CT("NAT",0,"Code",$$ALPHAUP^SSUTIL4(Patobj.PAPATDENationCode),""))
	s PatMAS.NationDescLookUpRowID	=CTNationDr			//民族	
	s CTCountryDr=""	
	s:Patobj.PAPATDECountryCode'="" CTCountryDr=$o(^CT("COU",0,"Code",$$ALPHAUP^SSUTIL4(Patobj.PAPATDECountryCode),""))
	s PatMAS.CountryDescLookUpRowID	=CTCountryDr		//国籍	
	
	//死亡
	s PatMAS.TelHome		=Patobj.PAPATTelephone		//联系电话
	s PatMAS.PatYBCode		=Patobj.PAPATHealthCardID	//健康卡号(医保号)
	s PatMAS.ForeignName	=Patobj.PAPATRelationName	//联系人姓名
	s PatMAS.ForeignPhone	=Patobj.PAPATRelationPhone	//联系人电话
	
	s UpdUserDR=""
	s:Patobj.PAPATUpdateUserCode'="" UpdUserDR=$o(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(Patobj.PAPATUpdateUserCode),""))
	s PatMAS.UserDR			=UpdUserDR					//更新人
	s PatMAS.UpdateDate		=Patobj.PAPATUpdateDate		//最后更新日期
	s PatMAS.UpdateTime		=Patobj.PAPATUpdateTime		//最后更新时间
	//母亲ID
	//备注
	//关联patientID，用于病人合并
	s OCCUPATIONDr=""
	s:Patobj.PAPATOccupationCode'="" OCCUPATIONDr=$o(^CT("OCC",0,"Code",$$ALPHAUP^SSUTIL4(Patobj.PAPATOccupationCode),""))
	s PatMAS.Vocation=OCCUPATIONDr						//职业	
	s PatMAS.CredNo			=Patobj.PAPATCardNO			//身份证号
	s PatMAS.InMedicare		=Patobj.PAPATInMedicare		//病案号

	TSTART
	
	s result=##class(web.DHCBL.CARD.UCardPaPatMasInfo).SavePatInfo(PatMAS)
	
	s flag					=$p(result,"^",1)
	s PatRowId				=$p(result,"^",2)
	if flag=0
	{	
		// 保存登记号到对照表中
		s RegisterNo=$p($g(^PAPER(PatRowId,"PAT",1)),"^",1)		//登记号		
		s PIXpat=##class(User.EnsPIX).%New()	
		s PIXpat.IntPIXExtPatientID			=Patobj.PAPATPatientID	//第三方登记号
		s PIXpat.IntPIXIntPatientID			=RegisterNo
		s PIXpat.IntPIXTDate				=+$h
		s PIXpat.IntPIXTTime				=$p($h,",",2)
		Set sc2 = PIXpat.%Save()
		
		s return="0^"_PatRowId_"^"_RegisterNo
		
	}
	if (flag=0&&sc2=1)
	{
		TCOMMIT
		s return="0^插入成功^"_PatRowId
	}
	else
	{
		TROLLBACK	
		s return="-1^插入失败"
	}	
	q return
	
Exception
	TROLLBACK	
	q "-1^"_$ze
}

/// Input:开始日期,结束日期
/// Return:0^PatRowId^登记号
/// w ##class(web.DHCENS.STBLL.EMPI.METHOD.PAPatient).SavePAPatientByUpdDate("2015-06-02","2015-06-02")
ClassMethod SavePAPatientByUpdDate(SDate As %String, EDate As %String) As %String
{
	
	set $ZTrap = "Exception"
	
	s:SDate'="" SDate=$zdh(SDate,3)
	s:EDate'="" EDate=$zdh(EDate,3)	
	s:SDate="" SDate=$p($h,",",1)
	s:EDate="" EDate=$p($h,",",2)
	
	s patRowId=""
	f date=SDate:1:EDate  d
	.f  s patRowId=$o(^PAPERi("UpdDate",date,patRowId)) q:patRowId=""  d
	..s return=..PAPatient(patRowId)
	..w return,!
	
	q "Over"
	
Exception
	q "-1^"_$ze
}

}
