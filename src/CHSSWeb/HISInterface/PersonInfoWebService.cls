/// CHSSWeb.HISInterface.PersonInfoWebService
Class CHSSWeb.HISInterface.PersonInfoWebService Extends %SOAP.WebService [ ClassType = "", ProcedureBlock ]
{

Parameter LOCATION = "http://localhost/trakcarelivess/trak/Web";

/// Name of the WebService.
Parameter SERVICENAME = "CHSSWeb.HISInterface.PersonInfoWeb";

/// TODO: change this to actual SOAP namespace.
/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/CHSSWeb/HISInterface/PersonInfoWeb";

ClassMethod test() As %String [ WebMethod ]
{
	q ""
}

/// 根据身份证号检索个人档案
ClassMethod GetPersonInfo(IDCard As %String) As %String [ WebMethod ]
{
	s rtn=##class(CHSSWeb.HISInterface.PersonInterface).GetPersonInfoData(IDCard)
	Quit rtn
}

/// 根据社区编码检索个人档案列表
ClassMethod GetPersonListWithCommunityCode(CommunityCode As %String) As %String [ WebMethod ]
{
	s rtn=##class(CHSSWeb.HISInterface.PersonInterface).GetPersonListWithCommunityCode(CommunityCode)
	;s rtn = ##class(CHSSWeb.HISInterface.PersonInterface).GenPersonReportData("100", 0, 10, "", "", "")
	;rtn.XMLExport()
	Quit rtn
	;q ""
}

/// Description:生活方式
ClassMethod GetLifeStyleData(IDCard As %String) As %String [ WebMethod ]
{
	s rtn=##class(CHSSWeb.HISInterface.PersonLifeStyleInterface).GetData(IDCard)
	Quit rtn
}

/// Description:老年人档案接口--检索身份证号返回老年人档案信息(HIS调用)
ClassMethod GetElerlyBaseInfoData(IDCard As %String) As %String [ WebMethod ]
{
	s rtn=##class(CHSSWeb.HISInterface.ElerlyBaseInterface).GetElerlyBaseInfoData(IDCard)
	Quit rtn
}

/// Description:老年人健康随访记录接口--检索身份证号返回老年人健康随访记录信息(HIS调用)
ClassMethod GetElerlyHealthCheckData(IDCard As %String) As %String [ WebMethod ]
{
	s rtn=##class(CHSSWeb.HISInterface.ElerlyHealthCheckInterface).GetElerlyHealthCheckData(IDCard)
	Quit rtn
}

/// Description:高血压首页接口--检索身份证号返回高血压首页信息(HIS调用)
ClassMethod GetHBPHeadData(IDCard As %String) As %String [ WebMethod ]
{
	s rtn=##class(CHSSWeb.HISInterface.HBPHeadPageInterface).HBPHeadRecordData(IDCard)
	Quit rtn
}

/// Description:高血压随访记录接口--检索身份证号返回高血压随访信息(HIS调用)
ClassMethod GetHBPRecordData(IDCard As %String) As %String [ WebMethod ]
{
	s rtn=##class(CHSSWeb.HISInterface.HBPCheckRecordInterface).HBPCheckRecordData(IDCard)
	Quit rtn
}

/// Description:糖尿病首页接口--检索身份证号返回糖尿病首页信息(HIS调用)
ClassMethod GetDiabetesHeadData(IDCard As %String) As %String [ WebMethod ]
{
	s rtn=##class(CHSSWeb.HISInterface.DiabetesHeadRecordInterface).DiabetesHeadRecordData(IDCard)
	Quit rtn
}

/// Description:糖尿病随访记录接口--检索身份证号返回糖尿病随访信息(HIS调用)
ClassMethod GetDiabetesRecordData(IDCard As %String) As %String [ WebMethod ]
{
	s rtn=##class(CHSSWeb.HISInterface.DiabetesCheckRecordInterface).DiabetesCheckRecordData(IDCard)
	Quit rtn
}

/// Description:读取二维码
ClassMethod GetPersonBarcodeData(YearCheckRowId As %String, PersonRowId As %String) As %String [ WebMethod ]
{
	s rtn=##class(CHSSWeb.HISInterface.BarCodeInterface).GetPersonBarcodeData(YearCheckRowId, PersonRowId)
	Quit rtn
}

ClassMethod PersonSearchSql(communityCode As %String, start As %Integer, limit As %Integer, sort As %String, whereStr As %String) As %String [ WebMethod ]
{
	;s ^tempPerson = whereStr
	s rtn=##class(CHSSWeb.PHRSearchService).PersonSearchSqlForBrowser(start, limit, sort, whereStr)
	
	Quit rtn
}

/// 读取个人档案主菜单
ClassMethod GetMainMenuForPerson(UserId As %String) As %String [ WebMethod ]
{
	;s ^tempPerson = UserId
	s rtn=##class(CHSSWeb.PubModelListService).GetPanelList(UserId,1)	
	Quit rtn
}

/// 读取个人档案子菜单
ClassMethod GetChildMenuForPerson(ModelCode As %String, UserId As %String) As %String [ WebMethod ]
{
	;s ^tempPerson = ModelCode
	s rtn=##class(CHSSWeb.PubModelListService).List(0,10,ModelCode,UserId,1)	
	Quit rtn
}

/// 导入家庭档案信息
/// AddFamilyData(HouseHoldName As %String, CommunityCode As %String, FamilyStatus As %Integer, ProvinceDR As %Integer, CityDR As %Integer, SectionDR As %Integer, StreetDR As %Integer, VillageDR As %Integer, DoorPlate As %String, VillageName As %String)
ClassMethod AddFamilyData(HouseHoldName As %String, CommunityCode As %String, FamilyStatus As %String, ProvinceDR As %String, CityDR As %String, SectionDR As %String, StreetDR As %String, VillageDR As %String, DoorPlate As %String, VillageName As %String) As %String [ WebMethod ]
{
	;s ^tempPerson = DateOfRegister_HouseHoldName_VillageName
	s rtn=##class(CHSSWeb.EHRDataImport).AddFamilyData(HouseHoldName, CommunityCode, FamilyStatus, ProvinceDR, CityDR, SectionDR, StreetDR, VillageDR, DoorPlate, VillageName)	
	Quit rtn
	;Quit ""
}

/// 导入个人档案信息
/// AddPersonData(HouseHoldName As %String, CommunityCode As %String, FamilyStatus As %String, ProvinceDR As %String, CityDR As %String, SectionDR As %String, StreetDR As %String, VillageDR As %String, DoorPlate As %String, VillageName As %String,PersonName As %String, SexDR As %String, Birth As %String, IDCard As %String, Address As %String, AddressTypeDR As %String,  RelationHourseHoldDR As %String, PersonStatus As %String)
ClassMethod AddPersonData(HouseHoldName As %String, CommunityCode As %String, FamilyStatus As %String, ProvinceDR As %String, CityDR As %String, SectionDR As %String, StreetDR As %String, VillageDR As %String, DoorPlate As %String, VillageName As %String, PersonName As %String, SexDR As %String, Birth As %String, IDCard As %String, Address As %String, AddressTypeDR As %String, RelationHourseHoldDR As %String, PersonStatus As %String) As %String [ WebMethod ]
{
	;s ^tempPerson = DateOfRegister_HouseHoldName_VillageName
	s rtn=##class(CHSSWeb.EHRDataImport).AddPersonData(HouseHoldName, CommunityCode, FamilyStatus, ProvinceDR, CityDR, SectionDR, StreetDR, VillageDR, DoorPlate, VillageName, PersonName, SexDR, Birth, IDCard , Address , AddressTypeDR,RelationHourseHoldDR, PersonStatus)	
	Quit rtn
	;Quit ""
}

}
