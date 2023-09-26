Class DHCDoc.Interface.Outside.Template.Methods Extends (%RegisteredObject, %XML.Adaptor, DHCDoc.Interface.Outside.Template.Public) [ ProcedureBlock ]
{

/// w ##class(DHCDoc.Interface.Outside.Template.Methods).GetInfoExample("")
ClassMethod GetInfoExample(XMLRequest As %String) As DHCDoc.Interface.Outside.Template.Entity.GetPatInfoRp
{
	s ^TMPTemplateXML("Request","GetPatInfo")=XMLRequest
	;s XMLRequest="<Request><TradeCode>3030</TradeCode><TransactionId></TransactionId><ExtOrgCode>APP</ExtOrgCode><ClientType>WEB</ClientType><TerminalID></TerminalID><HospitalId>1</HospitalId><ExtUserID>APP_001</ExtUserID><PatientCard></PatientCard><CardType></CardType><PatientID></PatientID><TerminalID></TerminalID><IDNo>360822198305022623</IDNo><PatientName>东测12</PatientName></Request>"
	s $ZTRAP="GetPatInfoErr"
	;DHCDoc.Interface.Outside.Template.Entity.GetPatInfoRq
	s InputObj=..GetInputObj("3030",XMLRequest)
	s UserID=##class(DHCDoc.Interface.Outside.Template.GetRelate).GetUser(InputObj.ExtUserID)
	s CardType=InputObj.CardType
	s PatientCard=InputObj.PatientCard
	s PatientNo=InputObj.PatientID
	s CredNo=InputObj.IDNo
	
	s OutputObj=..GetOutputObj("3030")
	s OutputObj.ResultCode="0"
	s OutputObj.ResultContent=""
	
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
			Continue:(CardType'="")&(CardType'=CFCardTypeDR)
			s myPatientID=$p(^DHCCARD("CF",CFRowid),"^",4)
			s FindActivePatientCardRowid=CFRowid
		}
		if myPatientID="" d ..SetOutputCode(.OutputObj,"-330002","卡号在系统中未找到")
	}elseif CredNo'="" {
		;根据身份证取最近的患者病人ID
		s myPatientIDStr=##class(DHCDoc.Interface.Outside.Template.Public).GetHighestLevelPAPMIByIDNo(CredNo)
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
		set DocumentID=##Class(DHCWMR.IO.OutService).IGetMrNoByPatientID(myPatientID,"")
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
	DO OutputObj.XMLExportToString(.XML,"Response")
	s ^TMPTemplateXML("Response","GetPatInfo")=XML
	q OutputObj
GetPatInfoErr
	s OutputObj=..GetOutputObj("3030")
	s OutputObj.ResultCode="-1"
	s OutputObj.ResultContent="GetPatInfo调用异常"_$ZERROR
	q OutputObj
}

/// w ##class(DHCDoc.Interface.Outside.Template.Methods).QueryDepartment("")
ClassMethod QueryDepartment(XMLRequest As %String) As DHCDoc.Interface.Outside.Template.Entity.QueryDepartmentRp
{
	s ^TMPTemplateXML("Request","QueryDepartment")=XMLRequest
	//s XMLRequest="<Request><TradeCode>1012</TradeCode><ExtOrgCode>APP</ExtOrgCode><ClientType>WEB</ClientType><HospitalId>2</HospitalId><ExtUserID>gh01</ExtUserID></Request>"
	s $ZTRAP="QueryDepartmentErr"
	;DHCDoc.Interface.Outside.Template.Entity.QueryDepartmentRq
	s InputObj=..GetInputObj("1012",XMLRequest)
	s UserID=##class(DHCDoc.Interface.Outside.Template.GetRelate).GetUser(InputObj.ExtUserID)
	s HospitalId=InputObj.HospitalId
	set HospitalId=##class(DHCDoc.Interface.Outside.Template.GetRelate).GetHISHospitalIdFromOuterCode(HospitalId)
	s OutputObj=..GetOutputObj("1012")
	s OutputObj.ResultCode="0000"
	s OutputObj.ResultContent=""
	
	Set rset=##class(%ResultSet).%New("web.DHCOPAdmReg:OPDeptList")
	do rset.Execute(UserID,"O","",HospitalId)
	Set columns = rset.GetColumnCount()
	set row=0
	While (rset.Next()) {
		set RowId=rset.GetData(1)
		set Deptdesc=rset.GetData(2)
		set:Deptdesc["-" Deptdesc=$p(Deptdesc,"-",2)
		s DepObj=##CLass(DHCDoc.Interface.Outside.Template.Entity.List.Department).%New()
		s DepObj.DepartmentCode=RowId
		s DepObj.DepartmentName=Deptdesc
		d OutputObj.Departments.Insert(DepObj)
		s OutputObj.RecordCount=OutputObj.RecordCount+1
		d DepObj.%Close()
	}
	s OutputObj.ResultCode="0000"
	s OutputObj.ResultContent="成功"
	DO OutputObj.XMLExportToString(.XML,"Response")
	s ^TMPTemplateXML("Response","QueryDepartment")=XML
	q OutputObj
QueryDepartmentErr
	s OutputObj=..GetOutputObj("1012")
	s OutputObj.ResultCode="-1"
	s OutputObj.ResultContent="QueryDepartment调用异常"_$ZERROR
	q OutputObj
}

/// w ##class(DHCDoc.Interface.Outside.Template.Methods).QueryDepartmentJson("")
ClassMethod QueryDepartmentJson(JSONRequest As %String) As %Stream.GlobalCharacter
{
	s ^TMPTemplateXML("Request","QueryDepartmentJson")=JSONRequest
	//s JSONRequest="{""TradeCode"":""1012"",""ExtOrgCode"":""APP"",""ClientType"":""WEB"",""HospitalId"":""2"",""ExtUserID"":""gh01""}"
	s $ZTRAP="QueryDepartmentJson"
	s OutputObj=..GetOutputObj("1012")
	s OutputObj.ResultCode="0000"
	s OutputObj.ResultContent=""
	
	;DHCDoc.Interface.Outside.Template.Entity.QueryDepartmentRq
	s sc=..GetInputObjFromJson("1012",JSONRequest,.InputObj)
	if (+sc=0){
		s OutputObj.ResultCode="-1"
		s OutputObj.ResultContent="QueryDepartmentJson调用异常:JSON序列化失败"
	}
	s UserID=##class(DHCDoc.Interface.Outside.Template.GetRelate).GetUser(InputObj.ExtUserID)
	s HospitalId=InputObj.HospitalId
	set HospitalId=##class(DHCDoc.Interface.Outside.Template.GetRelate).GetHISHospitalIdFromOuterCode(HospitalId)
	
	Set rset=##class(%ResultSet).%New("web.DHCOPAdmReg:OPDeptList")
	do rset.Execute(UserID,"O","",HospitalId)
	Set columns = rset.GetColumnCount()
	set row=0
	While (rset.Next()) {
		set RowId=rset.GetData(1)
		set Deptdesc=rset.GetData(2)
		set:Deptdesc["-" Deptdesc=$p(Deptdesc,"-",2)
		s DepObj=##CLass(DHCDoc.Interface.Outside.Template.Entity.List.Department).%New()
		s DepObj.DepartmentCode=RowId
		s DepObj.DepartmentName=Deptdesc
		
		d OutputObj.Departments.Insert(DepObj)
		s OutputObj.RecordCount=OutputObj.RecordCount+1
		d DepObj.%Close()
	}
	s OutputObj.ResultCode="0000"
	s OutputObj.ResultContent="成功"
	//DO OutputObj.XMLExportToString(.XML,"Response")
	s json = ..FromObjectJson(OutputObj)
	s ^TMPTemplateXML("Response","QueryDepartmentJson")=json
	q json
QueryDepartmentJson
	s OutputObj=..GetOutputObj("1012")
	s OutputObj.ResultCode="-1"
	s OutputObj.ResultContent="QueryDepartment调用异常"_$ZERROR
	s json = ..FromObjectJson(OutputObj)
	q json
}

}
