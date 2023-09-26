Class web.DHCENS.STBLL.MDMR2.Method.PAPatient Extends (%RegisteredObject, %XML.Adaptor, web.DHCENS.STBLL.MDMR2.Model.BusinessField)
{

/// Creator：ZhangXinying
/// CreatDate：2022-11-27
/// 主数据管理平台2.0  获取患者基本消息格式（Json）
/// Others：w ##class(web.DHCENS.STBLL.MDMR2.Method.PAPatient).GetPatientInfo(1).Read()
ClassMethod GetPatientInfo(patRowId As %String = "") As %GlobalCharacterStream
{
	s retStream=##class(%GlobalCharacterStream).%New()
	s mainJson=##class(%DynamicObject).%New()
	s reqJson=##class(%DynamicObject).%New()
	s dataArr=##class(%DynamicArray).%New()
	if patRowId=0 {
		s json=##class(%DynamicObject).%New()
		d dataArr.%Push(json)
		s reqJson.data=dataArr
		s reqJson.tableCode="pa_patient"
		s mainJson.request=reqJson
		s jsonStr=mainJson.%ToJSON()
		d retStream.Write(jsonStr)
		q retStream
		}
	try{
		s status="",code="",sourcerowid="",originalDesc="",release="1",description="",createDate="",createTime="",businessrowid=""
		s businessFieldCode="00001",hosCode="",startDate="",endDate="",version="",system="",codeSystemCode="pa_patient"
		s lastUpdateDate="",lastUpdateTime="",lastUpdateUser="demo"
	
		s sourcerowid=patRowId
		s businessrowid=businessFieldCode_"_"_sourcerowid
		s patNo=$p($g(^PAPER(patRowId,"PAT",1)),"^",1)
		s healthCardID=""
		s documentNO=##Class(DHCWMR.IO.OutService).IGetMrNoByPatientID(patRowId,"I","",.ErrMsg)
		s patName=$p($g(^PAPER(patRowId,"ALL")),"^",1)
		s sexRowId=$p($g(^PAPER(patRowId,"ALL")),"^",7)
		s birthDay=$p($g(^PAPER(patRowId,"ALL")),"^",6),DOB=""
		s:birthDay'="" DOB=$zd(birthDay,3)
		s marryRowID=$p($g(^PAPER(patRowId,"PER",2)),"^",3)
		s nationRowID=$p($g(^PAPER(patRowId,"PER",2)),"^",1)
		s countryRowID=$p($g(^PAPER(patRowId,"PER",1)),"^",8)
		s occupationRowID=$P($G(^PAPER(patRowId,"PER",2)),"^",6)
		s jgProvinceId=$P($g(^PAPER(patRowId,"PER",2)),"^",11)
		s jgCityId=$P($g(^PAPER(patRowId,"ALL")),"^",18)
		s jgRegionId=$P($g(^PAPER(patRowId,"ALL")),"^",14)
		s jgPostId=""
		s json=##class(%DynamicObject).%New()
		d json.%Set("businessfieldcode",businessFieldCode)
		d json.%Set("sourcerowid",patRowId)
		d json.%Set("businessrowid",businessrowid)
		d json.%Set("papat_registerno",patNo)
		d json.%Set("papat_healthcardno",healthCardID)
		d json.%Set("papat_documentno",documentNO)
		d json.%Set("papat_name",patName)
		d json.%Set("papat_gender",sexRowId)
		d json.%Set("papat_birthdate",DOB)
		d json.%Set("papat_maritalstatus",marryRowID)
		d json.%Set("papat_nation",nationRowID)
		d json.%Set("papat_country",countryRowID)
		d json.%Set("papat_occupation",occupationRowID)
		d json.%Set("papat_originprovince",jgProvinceId)
		d json.%Set("papat_origincity",jgCityId)
		d json.%Set("papat_origindistrict",jgRegionId)
		d json.%Set("papat_originpostcode",jgPostId)
		s dhcPersonID=$O(^DHCPERSON(0,"PAPERSON",patRowId,"")),address=""
		s:dhcPersonID'="" address=$p($g(^DHCPERSON(dhcPersonID)),"^",16)
		d json.%Set("papat_address",address)
		s telephone=$p($g(^PAPER(patRowId,"PER",1)),"^",11)
		d json.%Set("papat_telephone",telephone)
		s post=$P($g(^PAPER(patRowId,"PER",6)),"^",23)
		d json.%Set("papat_postcode",post)
		s workPlace=$p($g(^PAPER(patRowId,"PER",4)),"^",18)
		d json.%Set("papat_workplace",workPlace)
		s workPlaceTel=$p($g(^PAPER(patRowId,"PER",1)),"^",9)
		d json.%Set("papat_workplacetel",workPlaceTel)
		s relationId=$P($G(^PAPER(patRowId,"EMP")),"^",4)
		d json.%Set("papat_relationship",relationId)
		s relationName=$p($g(^PAPER(patRowId,"PER",2)),"^",13)
		d json.%Set("papat_contactname",relationName)
		s relationPhone=$P($G(^PAPER(patRowId,"ALL")),"^",4)
		d json.%Set("papat_contacttelephone",relationPhone)
		d json.%Set("papat_contactaddress",relationPhone)
		s relationAddr=$P($G(^PAPER(patRowId,"PER",1)),"^",1)
		s patMotherID=$p($g(^PAPER(patRowId,"PER",4)),"^",13)
		d json.%Set("papat_motherid",patMotherID)
		d json.%Set("papat_linkpatientid",businessrowid)
		s patDeceasedDate="",patDeceasedTime="",deathFlag=""
		set deathDate=$p($g(^PAPER(patRowId,"ALL")),"^",13)
		set:deathDate'="" patDeceasedDate=$zd(deathDate,3)
		set deathTime=$p($g(^PAPER(patRowId,"ALL")),"^",8)
		set:deathTime'="" patDeceasedTime=$zt(deathTime)
		s:patDeceasedDate'="" deathFlag="1"
		d json.%Set("papat_deceasedflag",deathFlag)
		d json.%Set("papat_deceaseddate",patDeceasedDate)
		d json.%Set("papat_deceasedtime",patDeceasedTime)
		d json.%Set("papat_activity","1")
		set UpdateDate=$p($g(^PAPER(patRowId,"PER",5)),"^",2)
		set:UpdateDate'="" UpdateDate=$zd(UpdateDate,3)
		set UpdateTime=$p($g(^PAPER(patRowId,"PER",5)),"^",3)
		set:UpdateTime'="" UpdateTime=$zt(UpdateTime,1)
		s updateUserDr=$p($g(^PAPER(patRowId,"PER",4)),"^",7)
		d json.%Set("papat_lastupdatedate",UpdateDate)
		d json.%Set("papat_lastupdatetime",UpdateTime)
		d json.%Set("papat_lastupdateuser",updateUserDr)
		s identifier=[]
		set PATIdentityNum=$p($g(^PAPER(patRowId,"PAT",3)),"^",6)
		if PATIdentityNum'=""
		{
			s identifierJson=##class(%DynamicObject).%New()
			set credentialTypeRowID=$p($g(^PAPER(patRowId,"PAT",3)),"^",7) 
			d identifierJson.%Set("papatid_type",credentialTypeRowID)
			
			d identifierJson.%Set("papatid_no",PATIdentityNum)
			d identifier.%Push(identifierJson)
		}
		d json.%Set("identifier",identifier)

		s addressJsonArr=[]
		s birthProvinceRowID="",birthProvinceDesc=""
		s:dhcPersonID'="" birthProvinceRowID=$p($g(^DHCPERSON(dhcPersonID)),"^",13)  
		if birthProvinceRowID'=""
		{
			s addressJson=##class(%DynamicObject).%New()
			s addressJson."papatad_typecode"="06"
			s addressJson."papatad_typedesc"="出生地址"
			s addressJson."papatad_country"="" ///
		
			s addressJson."papatad_province"=birthProvinceRowID
			s:birthProvinceRowID'="" birthProvinceDesc=$p($g(^CT("PROV",birthProvinceRowID)),"^",2)
		
			s birthCityRowID="",birthCityDesc=""
			s:dhcPersonID'="" birthCityRowID=$p($g(^DHCPERSON(dhcPersonID)),"^",14)  
			s addressJson."papatad_city"=birthCityRowID
			s:birthCityRowID'="" birthCityDesc=$p($g(^CT("CIT",birthCityRowID)),"^",2)
			s birthCountyRowID="",birthCountyDesc=""
			s:dhcPersonID'="" birthCountyRowID=$p($g(^DHCPERSON(dhcPersonID)),"^",15)
			s addressJson."papatad_district"=birthCountyRowID
			s:birthCountyRowID'="" birthCountyDesc=$p($g(^CT("CITAREA",birthCountyRowID)),"^",2)
			s addressJson."papatad_postcode"=""
			s addressJson."papatad_desc"=birthProvinceDesc_birthCityDesc_birthCountyDesc
			d addressJsonArr.%Push(addressJson)
		}
		s houseCountryRowID=""
		s:dhcPersonID'="" houseCountryRowID=$p($g(^DHCPERSON(dhcPersonID)),"^",21) 
		s houseProvinceRowID=$P($g(^PAPER(patRowId,"PER",4)),"^",2)
		if (houseCountryRowID'="")||(houseProvinceRowID'="")
		{
			s addressJson=##class(%DynamicObject).%New()
			s addressJson."papatad_typecode"="09"
			s addressJson."papatad_typedesc"="现住址"
		 
			s addressJson."papatad_country"=houseCountryRowID
			s addressJson."papatad_province"=houseProvinceRowID

			s houseCityCodeRowID=""
			s houseCityCodeRowID=$P($g(^PAPER(patRowId,"PER",1)),"^",5) 
			s addressJson."papatad_city"=houseCityCodeRowID

			s houseCityAreaRowID=""
			s houseCityAreaRowID=$P($g(^PAPER(patRowId,"PER",4)),"^",9) 
			s addressJson."papatad_district"=houseCityAreaRowID
			s addressJson."papatad_postcode"=""
			s addressJson."papatad_desc"=$P($G(^PAPER(patRowId,"PER",1)),"^",1)
			d addressJsonArr.%Push(addressJson)
		}
		s hjProvinceRowID="",hjProvinceDesc=""
		s:dhcPersonID'="" hjProvinceRowID=$P(^DHCPERSON(dhcPersonID),"^",17) 
		if hjProvinceRowID'=""
		{
			s addressJson=##class(%DynamicObject).%New()
			s addressJson."papatad_typecode"="01"
			s addressJson."papatad_typedesc"="户籍地址"
			s addressJson."papatad_province"=hjProvinceRowID
			s:hjProvinceRowID'="" hjProvinceDesc=$p($g(^CT("PROV",hjProvinceRowID)),"^",2)
			
			s hjCityCodeRowID="",hjCityCodeDesc=""
			s:dhcPersonID'="" hjCityCodeRowID=$P(^DHCPERSON(dhcPersonID),"^",18) 
			s addressJson."papatad_city"=hjCityCodeRowID
			s:hjCityCodeRowID'="" hjCityCodeDesc=$p($g(^CT("CIT",hjCityCodeRowID)),"^",2)
		
			s CityAreaRowID="",CityAreaDesc=""
			s:dhcPersonID'="" CityAreaRowID=$P(^DHCPERSON(dhcPersonID),"^",19) 
			
			s:CityAreaRowID'="" CityAreaDesc=$p($g(^CT("CITAREA",CityAreaRowID)),"^",2)
			s addressJson."papatad_district"=CityAreaRowID
			s addressJson."papatad_desc"=$P(^DHCPERSON(dhcPersonID),"^",20)
			s:dhcPersonID'="" addressJson."papatad_postcode"=$p($g(^DHCPERSON(dhcPersonID)),"^",8)
			d addressJsonArr.%Push(addressJson)
		}
		s json."address"=addressJsonArr
 	

		d dataArr.%Push(json)
		s reqJson.data=dataArr
		s reqJson.tableCode="pa_patient"
		s mainJson.request=reqJson
		s jsonStr=mainJson.%ToJSON()
		d retStream.Write(jsonStr)
	}
	catch{
		s json=##class(%DynamicObject).%New()
		d dataArr.%Push(json)
		s reqJson.data=dataArr
		s reqJson.tableCode="pa_patient"
		s mainJson.request=reqJson
		s jsonStr=mainJson.%ToJSON()
		d retStream.Write(jsonStr)	
		b ;$ze		
		}
	q retStream
}

/// Debug:w ##class(web.DHCENS.STBLL.MDMR2.Method.PAPatient).PostPatient(101)
ClassMethod PostPatient(patRowID As %String) As %String
{
	try
	{
		s httprequest=##class(%Net.HttpRequest).%New()
		d httprequest.SetHeader("Content-Type","application/json;charset=utf-8")
		s url="http://211.101.232.11:9003/api/patient/add"
		s url=..#PatUrl
		s stream=..GetPatientInfo(patRowID)
		d httprequest.EntityBody.CopyFrom(stream)
		s ret = httprequest.Post(url)
		s returnstream = httprequest.HttpResponse.Data
	}
	catch
	{
		s $zt=""
	}
	q returnstream
}

/// Debug:w ##class(web.DHCENS.STBLL.MDMR2.Method.PAPatient).PostPatientHistory()
ClassMethod PostPatientHistory() As %String
{
	try
	{
		s rowid="0",num=0
		for
		{
			s rowid=$o(^PAPER(rowid))
			q:rowid=""
			s num=num+1
			s rtn=..PostPatient(rowid)	
			w !,rowid_"^"_$p($g(^PAPER(rowid,"ALL")),"^",1)_"^"_rtn.Read()
		}
		
		
	}
	catch
	{
		s $zt=""
	}
	q "0"
}

/// Others：w ##class(web.DHCENS.STBLL.MDMR2.Method.PAPatient).GetPatientJson(1)
ClassMethod GetPatientJson(patRowId As %String = "") As %Library.DynamicObject
{
	s retStream=##class(%GlobalCharacterStream).%New()
	s mainJson=##class(%DynamicObject).%New()
	s reqJson=##class(%DynamicObject).%New()
	s dataArr=##class(%DynamicArray).%New()
	q:patRowId="" reqJson
	try{
		s status="",code="",sourcerowid="",originalDesc="",release="1",description="",createDate="",createTime="",businessrowid=""
		s businessFieldCode="00001",hosCode="",startDate="",endDate="",version="",system="",codeSystemCode="pa_patient"
		s lastUpdateDate="",lastUpdateTime="",lastUpdateUser="demo"
	
		s sourcerowid=patRowId
		s businessrowid=businessFieldCode_"_"_sourcerowid
		s patNo=$p($g(^PAPER(patRowId,"PAT",1)),"^",1)
		s healthCardID=""
		s documentNO=##Class(DHCWMR.IO.OutService).IGetMrNoByPatientID(patRowId,"I","",.ErrMsg)
		s patName=$p($g(^PAPER(patRowId,"ALL")),"^",1)
		s sexRowId=$p($g(^PAPER(patRowId,"ALL")),"^",7)
		s birthDay=$p($g(^PAPER(patRowId,"ALL")),"^",6),DOB=""
		s:birthDay'="" DOB=$zd(birthDay,3)
		s marryRowID=$p($g(^PAPER(patRowId,"PER",2)),"^",3)
		s nationRowID=$p($g(^PAPER(patRowId,"PER",2)),"^",1)
		s countryRowID=$p($g(^PAPER(patRowId,"PER",1)),"^",8)
		s occupationRowID=$P($G(^PAPER(patRowId,"PER",2)),"^",6)
		s jgProvinceId=$P($g(^PAPER(patRowId,"PER",2)),"^",11)
		s jgCityId=$P($g(^PAPER(patRowId,"ALL")),"^",18)
		s jgRegionId=$P($g(^PAPER(patRowId,"ALL")),"^",14)
		s jgPostId=""
		s json=##class(%DynamicObject).%New()
		d json.%Set("businessfieldcode",businessFieldCode)
		d json.%Set("sourcerowid",patRowId)
		d json.%Set("businessrowid",businessrowid)
		d json.%Set("papat_registerno",patNo)
		d json.%Set("papat_healthcardno",healthCardID)
		d json.%Set("papat_documentno",documentNO)
		d json.%Set("papat_name",patName)
		d json.%Set("papat_gender",sexRowId)
		d json.%Set("papat_birthdate",DOB)
		d json.%Set("papat_maritalstatus",marryRowID)
		d json.%Set("papat_nation",nationRowID)
		d json.%Set("papat_country",countryRowID)
		d json.%Set("papat_occupation",occupationRowID)
		d json.%Set("papat_originprovince",jgProvinceId)
		d json.%Set("papat_origincity",jgCityId)
		d json.%Set("papat_origindistrict",jgRegionId)
		d json.%Set("papat_originpostcode",jgPostId)
		s dhcPersonID=$O(^DHCPERSON(0,"PAPERSON",patRowId,"")),address=""
		s:dhcPersonID'="" address=$p($g(^DHCPERSON(dhcPersonID)),"^",16)
		d json.%Set("papat_address",address)
		s telephone=$p($g(^PAPER(patRowId,"PER",1)),"^",11)
		d json.%Set("papat_telephone",telephone)
		s post=$P($g(^PAPER(patRowId,"PER",6)),"^",23)
		d json.%Set("papat_postcode",post)
		s workPlace=$p($g(^PAPER(patRowId,"PER",4)),"^",18)
		d json.%Set("papat_workplace",workPlace)
		s workPlaceTel=$p($g(^PAPER(patRowId,"PER",1)),"^",9)
		d json.%Set("papat_workplacetel",workPlaceTel)
		s relationId=$P($G(^PAPER(patRowId,"EMP")),"^",4)
		d json.%Set("papat_relationship",relationId)
		s relationName=$p($g(^PAPER(patRowId,"PER",2)),"^",13)
		d json.%Set("papat_contactname",relationName)
		s relationPhone=$P($G(^PAPER(patRowId,"ALL")),"^",4)
		d json.%Set("papat_contacttelephone",relationPhone)
		d json.%Set("papat_contactaddress",relationPhone)
		s relationAddr=$P($G(^PAPER(patRowId,"PER",1)),"^",1)
		s patMotherID=$p($g(^PAPER(patRowId,"PER",4)),"^",13)
		d json.%Set("papat_motherid",patMotherID)
		d json.%Set("papat_linkpatientid",businessrowid)
		s patDeceasedDate="",patDeceasedTime="",deathFlag=""
		set deathDate=$p($g(^PAPER(patRowId,"ALL")),"^",13)
		set:deathDate'="" patDeceasedDate=$zd(deathDate,3)
		set deathTime=$p($g(^PAPER(patRowId,"ALL")),"^",8)
		set:deathTime'="" patDeceasedTime=$zt(deathTime)
		s:patDeceasedDate'="" deathFlag="1"
		d json.%Set("papat_deceasedflag",deathFlag)
		d json.%Set("papat_deceaseddate",patDeceasedDate)
		d json.%Set("papat_deceasedtime",patDeceasedTime)
		d json.%Set("papat_activity","1")
		set UpdateDate=$p($g(^PAPER(patRowId,"PER",5)),"^",2)
		set:UpdateDate'="" UpdateDate=$zd(UpdateDate,3)
		set UpdateTime=$p($g(^PAPER(patRowId,"PER",5)),"^",3)
		set:UpdateTime'="" UpdateTime=$zt(UpdateTime,1)
		s updateUserDr=$p($g(^PAPER(patRowId,"PER",4)),"^",7)
		d json.%Set("papat_lastupdatedate",UpdateDate)
		d json.%Set("papat_lastupdatetime",UpdateTime)
		d json.%Set("papat_lastupdateuser",updateUserDr)
		s identifier=[]
		set PATIdentityNum=$p($g(^PAPER(patRowId,"PAT",3)),"^",6)
		if PATIdentityNum'=""
		{
			s identifierJson=##class(%DynamicObject).%New()
			set credentialTypeRowID=$p($g(^PAPER(patRowId,"PAT",3)),"^",7) 
			d identifierJson.%Set("papatid_type",credentialTypeRowID)
			
			d identifierJson.%Set("papatid_no",PATIdentityNum)
			d identifier.%Push(identifierJson)
		}
		d json.%Set("identifier",identifier)

		s addressJsonArr=[]
		s birthProvinceRowID="",birthProvinceDesc=""
		s:dhcPersonID'="" birthProvinceRowID=$p($g(^DHCPERSON(dhcPersonID)),"^",13)  
		if birthProvinceRowID'=""
		{
			s addressJson=##class(%DynamicObject).%New()
			s addressJson."papatad_typecode"="06"
			s addressJson."papatad_typedesc"="出生地址"
			s addressJson."papatad_country"="" ///
		
			s addressJson."papatad_province"=birthProvinceRowID
			s:birthProvinceRowID'="" birthProvinceDesc=$p($g(^CT("PROV",birthProvinceRowID)),"^",2)
		
			s birthCityRowID="",birthCityDesc=""
			s:dhcPersonID'="" birthCityRowID=$p($g(^DHCPERSON(dhcPersonID)),"^",14)  
			s addressJson."papatad_city"=birthCityRowID
			s:birthCityRowID'="" birthCityDesc=$p($g(^CT("CIT",birthCityRowID)),"^",2)
			s birthCountyRowID="",birthCountyDesc=""
			s:dhcPersonID'="" birthCountyRowID=$p($g(^DHCPERSON(dhcPersonID)),"^",15)
			s addressJson."papatad_district"=birthCountyRowID
			s:birthCountyRowID'="" birthCountyDesc=$p($g(^CT("CITAREA",birthCountyRowID)),"^",2)
			s addressJson."papatad_postcode"=""
			s addressJson."papatad_desc"=birthProvinceDesc_birthCityDesc_birthCountyDesc
			d addressJsonArr.%Push(addressJson)
		}
		s houseCountryRowID=""
		s:dhcPersonID'="" houseCountryRowID=$p($g(^DHCPERSON(dhcPersonID)),"^",21) 
		s houseProvinceRowID=$P($g(^PAPER(patRowId,"PER",4)),"^",2)
		if (houseCountryRowID'="")||(houseProvinceRowID'="")
		{
			s addressJson=##class(%DynamicObject).%New()
			s addressJson."papatad_typecode"="09"
			s addressJson."papatad_typedesc"="现住址"
		 
			s addressJson."papatad_country"=houseCountryRowID
			s addressJson."papatad_province"=houseProvinceRowID

			s houseCityCodeRowID=""
			s houseCityCodeRowID=$P($g(^PAPER(patRowId,"PER",1)),"^",5) 
			s addressJson."papatad_city"=houseCityCodeRowID

			s houseCityAreaRowID=""
			s houseCityAreaRowID=$P($g(^PAPER(patRowId,"PER",4)),"^",9) 
			s addressJson."papatad_district"=houseCityAreaRowID
			s addressJson."papatad_postcode"=""
			s addressJson."papatad_desc"=$P($G(^PAPER(patRowId,"PER",1)),"^",1)
			d addressJsonArr.%Push(addressJson)
		}
		s hjProvinceRowID="",hjProvinceDesc=""
		s:dhcPersonID'="" hjProvinceRowID=$P(^DHCPERSON(dhcPersonID),"^",17) 
		if hjProvinceRowID'=""
		{
			s addressJson=##class(%DynamicObject).%New()
			s addressJson."papatad_typecode"="01"
			s addressJson."papatad_typedesc"="户籍地址"
			s addressJson."papatad_province"=hjProvinceRowID
			s:hjProvinceRowID'="" hjProvinceDesc=$p($g(^CT("PROV",hjProvinceRowID)),"^",2)
			
			s hjCityCodeRowID="",hjCityCodeDesc=""
			s:dhcPersonID'="" hjCityCodeRowID=$P(^DHCPERSON(dhcPersonID),"^",18) 
			s addressJson."papatad_city"=hjCityCodeRowID
			s:hjCityCodeRowID'="" hjCityCodeDesc=$p($g(^CT("CIT",hjCityCodeRowID)),"^",2)
		
			s CityAreaRowID="",CityAreaDesc=""
			s:dhcPersonID'="" CityAreaRowID=$P(^DHCPERSON(dhcPersonID),"^",19) 
			
			s:CityAreaRowID'="" CityAreaDesc=$p($g(^CT("CITAREA",CityAreaRowID)),"^",2)
			s addressJson."papatad_district"=CityAreaRowID
			s addressJson."papatad_desc"=$P(^DHCPERSON(dhcPersonID),"^",20)
			s:dhcPersonID'="" addressJson."papatad_postcode"=$p($g(^DHCPERSON(dhcPersonID)),"^",8)
			d addressJsonArr.%Push(addressJson)
		}
		s json."address"=addressJsonArr
	}
	catch{
		s json=##class(%DynamicObject).%New()
		s $zt=""	
		}
	q json
}

/// Debug:w ##class(web.DHCENS.STBLL.MDMR2.Method.PAPatient).PostPatientHistoryBatch()
ClassMethod PostPatientHistoryBatch() As %String
{
	try
	{
		s rowid="0",num=1
		s retStream=##class(%Stream.GlobalCharacter).%New()
		s mainJson=##class(%DynamicObject).%New()
		s reqJson=##class(%DynamicObject).%New()
		s dataArr=##class(%DynamicArray).%New()
		s plist=##class(%ArrayOfDataTypes).%New()
		for
		{
			s rowid=$o(^PAPER(rowid))
			q:rowid=""
			d plist.SetAt(rowid,num)
			s num=num+1
			if num>100
			{
				s datas=..GetPatientByID(plist)
				s reqJson."data"=datas
				s mainJson."request"=reqJson
				s jsonStr=mainJson.%ToJSON()
				d retStream.Write(jsonStr)
				s rtn=..PostPatientBatch(retStream)
				do plist.Clear()
				s num=1
			}
		}
		set length=plist.Count()
		if length>0 
		{
			set datas=..GetPatientByID(plist)
			s reqJson."data"=datas
			s mainJson."request"=reqJson
			s jsonStr=mainJson.%ToJSON()
			d retStream.Clear()
			d retStream.Write(jsonStr)
			s rtn=..PostPatientBatch(retStream)
		}
		
	}
	catch
	{
		s $zt=""
	}
	q "0"
}

/// Debug:w ##class(web.DHCENS.STBLL.MDMR2.Method.PAPatient).PostPatientBatch()
ClassMethod PostPatientBatch(stream As %Stream.GlobalCharacter) As %String
{
	try
	{
		s httprequest=##class(%Net.HttpRequest).%New()
		d httprequest.SetHeader("Content-Type","application/json;charset=utf-8")
		s url="http://211.101.232.11:9003/api/patient/add"
		s url=..#PatUrl
		d httprequest.EntityBody.CopyFrom(stream)
		s ret = httprequest.Post(url)
		s returnstream = httprequest.HttpResponse.Data
	}
	catch
	{
		s $zt=""
	}
	q returnstream
}

ClassMethod GetPatientByID(pList As %ArrayOfDataTypes) As %DynamicArray
{
	try
	{
		s dataArr=##class(%DynamicArray).%New()
		set count=pList.Count()
		for i=1:1:count
		{
			set rowid=pList.GetAt(i)
			set json=..GetPatientJson(rowid)
			;w !,"^rowid^"_rowid
			d dataArr.%Push(json)
			
		}	
	}
	catch
	{
		s $zt=""	
	}
	q dataArr
}

}
