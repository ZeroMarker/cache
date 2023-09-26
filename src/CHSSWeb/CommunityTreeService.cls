Class CHSSWeb.CommunityTreeService Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

ClassMethod List(id, level, start, limit, communityCode)
{
    
    s sqlStr=""
    s Leaf="false"
    
	Set start=$G(Start)
	Set limit=$G(Limit)
	Set count=0
	Set end = start+limit
	s result = ##class(%Library.ResultSet).%New()
	s tempString=..getCommunityDetail(communityCode)
	;w tempString,!
	s ProvinceName=$p(tempString,"^",1)
	s CityName=$p(tempString,"^",2)
	s SectionName=$p(tempString,"^",3)
	s StreetName=$p(tempString,"^",4)
	s VillageName=$p(tempString,"^",5)
	s cityId=""
	;w tempString,!
	;&sql(select rowidParref into:cityId from chss.dictsection where )
	i (id="0") d
	.s sqlStr = "select RowId, '1'||RowId As nodeid,' ' as CommunityCode,' ' as CommunityType, Description from CHSS.DictProvince where rowid="_ProvinceName
	.;w sqlStr,!
	.s level = "province"
	e  d
	.if level = "province" d
	..i CityName'="" d
	...s sqlStr = "select RowId, '2'||RowId As nodeid,' ' as CommunityCode,' ' as CommunityType, Description from CHSS.DictCity where rowid ="_CityName
	..e  d
	...s sqlStr = "select RowId, '2'||RowId As nodeid,' ' as CommunityCode,' ' as CommunityType, Description from CHSS.DictCity where rowidparref ="_id
	
	..s level = "city"
	
	
	.e  i level = "city" d
	..i SectionName'="" d
	...s sqlStr = "select RowId, '3'||RowId As nodeid,' ' as CommunityCode,' ' as CommunityType, Description from CHSS.DictSection where rowid ="_SectionName
    ..e  d
	...s sqlStr = "select RowId, '3'||RowId As nodeid,' ' as CommunityCode,' ' as CommunityType, Description from CHSS.DictSection where rowidparref ="_id
	..s level = "section"
	
	.e  i level = "section" d
	..i StreetName'="" d
	...s sqlStr = "select RowId, '4'||RowId As nodeid,' ' as CommunityCode,' ' as CommunityType, Description from CHSS.DictStreet where rowid ="_StreetName
    ..e  d
   	...s sqlStr = "select RowId, '4'||RowId As nodeid,' ' as CommunityCode,' ' as CommunityType, Description from CHSS.DictStreet where rowidparref ="_id
    ..;w sqlStr,!
	..s level = ""
	..s Leaf = "true"
	
	
	
	.e  i level = "street" d
	..i VillageName'="" d
	...s sqlStr = "select RowId, '5'||RowId As nodeid,' ' as CommunityCode,' ' as CommunityType, Description from CHSS.DictVillage where rowid ="_VillageName
    ..e  d
   	...s sqlStr = "select RowId, '5'||RowId As nodeid,' ' as CommunityCode,' ' as CommunityType, Description from CHSS.DictVillage where rowidparref ="_id
	..s level = ""
	..s Leaf = "true"
	
	d result.Prepare(sqlStr)
	d result.Execute()
	s resultString = ""
	s json = ##class(Code.JsonObj).%New()
	While(result.Next())
	{  
	    
		s rowid = result.Data("RowId")
	    s nodeid = result.Data("nodeid")
		s text=result.Data("Description")
		s communitycode=result.Data("CommunityCode")
		s communityType=result.Data("CommunityType")
	    s tmp=nodeid_"^"_text_"^"_Leaf_"^"_level_"^"_rowid_"^"_communitycode_"^"_communityType
	    d json.InsertRowData(tmp)
	    s count=count+1
	}
	d result.Close()
	s resultString = json.getTreeJsonData("id^text^leaf^level^rowid^communitycode^communityType")
	k json
	q resultString
}

//根据登陆进去来的communitycode动态生成树

//返回省市县的Id

ClassMethod getCommunityDetail(communitycode)
{

	s result = ##class(%Library.ResultSet).%New()

	s sqlStr = "SELECT RowId,CommunityName,SpellCode,UpCommunityCode,CommunityCodePrex,CommunityType,HospitalDR,RecordDR FROM CHSS.DictHospital where Communitycode ="_communitycode


	d result.Prepare(sqlStr)
	d result.Execute()
	
	s count = 0
	s resultString = ""
	
	
	s json = ##class(Code.JsonObj).%New()
	
	While(result.Next())
	{
	s Rowid = result.Data("RowId")
	s CommunityName = result.Data("CommunityName")
	s SepllCode = result.Data("SpellCode")
	s UpCommunityCode = result.Data("UpCommunityCode")
	s CommunityCodePrex = result.Data("CommunityCodePrex")
	s CommunityType = result.Data("CommunityType")
	s HospitalDR = result.Data("HospitalDR")
	s RecordDR = result.Data("RecordDR")
    s HospitalName = ""
    s ProvinceName = ""
    s CityName = ""
    s SectionName = ""
    s StreetName = ""
    s VillageName = ""
    s UpCommunityName = ""
    i CommunityType = "省卫生厅" d
	.s ProvinceName =RecordDR
	..
    i CommunityType = "市卫生局" d
	.s tempHospital = ##class(CHSS.DictCity).%OpenId(RecordDR)
	.i tempHospital '= "" d
	..s CityName = RecordDR
	..s ProvinceName=tempHospital.RowIdParref.%Id()
    e  i (CommunityType = "县（区）卫生局") d
	.s tempHospital = ##class(CHSS.DictSection).%OpenId(RecordDR)
	.i tempHospital '= "" d
	..s SectionName = RecordDR
	..s tempSection=tempHospital.RowIdParref
	..i tempSection'="" d
	...s CityName=tempSection.%Id()
	
	...i tempSection.RowIdParref'="" d
	....s ProvinceName=tempSection.RowIdParref.%Id()
	e  i ((CommunityType = "乡镇卫生院")||(CommunityType = "社区卫生服务中心")) d
	.s tempHospital = ##class(CHSS.DictStreet).%OpenId(RecordDR)
	.i tempHospital '= "" d
	..s StreetName = RecordDR
	..
	..s SectionId=tempHospital.RowIdParref.%Id()
	..i SectionId '= "" d
	...s tempSection=##class(CHSS.DictSection).%OpenId(SectionId)
	...s SectionName=SectionId
	...
	...s CityId=tempSection.RowIdParref.%Id()
	...i CityId '= "" d
	....s tempCity=##class(CHSS.DictCity).%OpenId(CityId)
	....s CityName=CityId
	....
	....s ProvinceId=tempCity.RowIdParref.%Id()
	....s tempProvince=##class(CHSS.DictProvince).%OpenId(ProvinceId)
	....s ProvinceName=ProvinceId
	e  i ((CommunityType = "村卫生所")||(CommunityType = "社区卫生服务站")) d
	.s VillageName=RecordDR
	.s tempHospital = ##class(CHSS.DictVillage).%OpenId(RecordDR)
	.i tempHospital '= "" d
	..s HospitalName = tempHospital.Description
	..s streetId = tempHospital.RowIdParref.%Id()
	..s tempStreet=##class(CHSS.DictStreet).%OpenId(streetId)
	..s StreetName=streetId
	..
	..s SectionId=tempStreet.RowIdParref.%Id()
	..s tempSection=##class(CHSS.DictSection).%OpenId(SectionId)
	..s SectionName=SectionId
	..
	..s CityId=tempSection.RowIdParref.%Id()
	..s tempCity=##class(CHSS.DictCity).%OpenId(CityId)
	..s CityName=CityId
	..
	..s ProvinceId=tempCity.RowIdParref.%Id()
	..s tempProvince=##class(CHSS.DictProvince).%OpenId(ProvinceId)
	..s ProvinceName=ProvinceId
	s tmp=ProvinceName_"^"_CityName_"^"_SectionName_"^"_StreetName_"^"_VillageName
	}
	d result.Close()
    k json
	q tmp
}

Storage Default
{
<Data name="CommunityTreeServiceDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^CHSSWeb.CommunityTreeServiceD</DataLocation>
<DefaultData>CommunityTreeServiceDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSSWeb.CommunityTreeServiceD</IdLocation>
<IndexLocation>^CHSSWeb.CommunityTreeServiceI</IndexLocation>
<StreamLocation>^CHSSWeb.CommunityTreeServiceS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
