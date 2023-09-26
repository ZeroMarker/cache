Class web.DHCENS.STBLL.LIS.METHOD.LISCollect Extends (%RegisteredObject, %XML.Adaptor)
{

/// w ##class(web.DHCENS.STBLL.LIS.METHOD.LISCollect).CollectInfo(^TEMPWYT("Input")).Read()
ClassMethod CollectInfo(Input As %String) As %GlobalCharacterStream
{
	try{
		s jsonStream=##class(%GlobalCharacterStream).%New()
		d jsonStream.Write(Input)
		d ##class(web.DHCENS.EnsHISService).DHCHisInterface("UpdateSystemStatus",jsonStream)
		s tmpJSONs={}.%FromJSON(Input)
		s count=tmpJSONs.%Size()
		s Msg=##class(web.DHCENS.STBLL.LIS.MODEL.Msg).%New()
		f i=1:1:count
		{
			s Data=##class(web.DHCENS.STBLL.LIS.MODEL.DataItem).%New()
			s tmpJSON=tmpJSONs.%Get(i-1)
			s UserID=tmpJSON.%Get("UserID")
			s UserName=tmpJSON.%Get("UserName")
			s ExamID=tmpJSON.%Get("ExamID")
			s Status=tmpJSON.%Get("Status")
			s:Status="COLLCM" Status="1"
			s:Status="CCOLLECT" Status="2"
			s UserRowID=""
			s UserRowID=$o(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(UserID),UserRowID))
			s HospitalDR=$p(^SSU("SSUSR",UserRowID),"^",98)
			s HOSPCode=$p(^CT("HOSP",HospitalDR),"^",1)
			s item=##class(web.DHCENS.STBLL.LIS.MODEL.CollectInfo).%New()
			s item.MODULE="B01"
			s item.OPERTYPE="1"
			s item.CONFIRMTYPE=Status
			s item.REQUISITIONID=ExamID
			s item.HOSPITALID=HOSPCode
			s item.LOGINID=UserID
			s item.USERNAME=UserName
			s Data.Collect=item
			d Msg.DATANews.Insert(Data)
		}
		d Msg.XMLExportToStream(.stream)
		b ;stream
		set ret=##class(web.DHCENS.BLL.Method.Conversion).MessageConversion("PS20018","","0",stream)
		set soap=##class(web.DHCENS.STBLL.SOAP.PUB0009Soap).%New()
		set ResultStr=soap.HIPMessageInfo("MES0159",ret)
	}catch{
		set xml=$ze
		set ResultStr=##class(%GlobalCharacterStream).%New()
		d ResultStr.Write(xml)
	}
	q ResultStr
}

/// w ##class(web.DHCENS.STBLL.LIS.METHOD.LISCollect).BarprtInfo(^TEMPWYT("Input")).Read()
ClassMethod BarprtInfo(Input As %String) As %GlobalCharacterStream
{
	try{
		s ^TEMPWYT("Input")=Input
		s jsonStream=##class(%GlobalCharacterStream).%New()
		d jsonStream.Write(Input)
		
		s tmpJSONs={}.%FromJSON(Input)
		s count=tmpJSONs.%Size()
		s Msg=##class(web.DHCENS.STBLL.LIS.MODEL.Msg).%New()
		s Data=##class(web.DHCENS.STBLL.LIS.MODEL.DataItem).%New()
		f i=1:1:count
		{
			s tmpJSON=tmpJSONs.%Get(i-1)
			s UserID=tmpJSON.%Get("UserID")
			s UserName=tmpJSON.%Get("UserName")
			s ExamID=tmpJSON.%Get("ExamID")
			s Status=tmpJSON.%Get("Status")
			if (Status="BARPRT") {
				set Status="ORDER_EXEC"
				d ##class(web.DHCENS.EnsHISService).DHCHisInterface("UpdateSystemStatus",jsonStream)
			}
			s UserRowID=""
			s UserRowID=$o(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(UserID),UserRowID))
			s HospitalDR=$p(^SSU("SSUSR",UserRowID),"^",98)
			s HOSPCode=$p(^CT("HOSP",HospitalDR),"^",1)
			s item=##class(web.DHCENS.STBLL.LIS.MODEL.DATA).%New()
			s item.MODULE="A02"
			s item.RETURNCODE="1"
			s item.ERRMSG="1"
			s item.OPERTYPE=Status
			s item.PATIENTTYPE="1"
			s item.REQUISITIONID=ExamID
			s item.LOGINID=UserID
			s item.USERNAME=UserName
			d Data.ITEM.Insert(item)
		}
		d Msg.DATA.Insert(Data)
		d Msg.XMLExportToStream(.stream)
		set ret=##class(web.DHCENS.BLL.Method.Conversion).MessageConversion("PS20019","","0",stream)
		;b  ;ret
		set soap=##class(web.DHCENS.STBLL.SOAP.PUB0009Soap).%New()
		set ResultStr=soap.HIPMessageInfo("MES0163",ret)
	}catch{
		set xml=$ze
		set ResultStr=##class(%GlobalCharacterStream).%New()
		d ResultStr.Write(xml)
	}
	q ResultStr
}

}
