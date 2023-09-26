Class CHSSWeb.CommunityListService Extends %Persistent [ ClassType = "", Not ProcedureBlock ]
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
	s cityId=""
	;w tempString,!
	;&sql(select rowidParref into:cityId from chss.dictsection where )
	i (id="0") d
	.s sqlStr = "select RowId, '1'||RowId As nodeid, Description from CHSS.DictProvince where rowid="_ProvinceName
	
	.s level = "province"
	e  d
	.if level = "province" d
	..i CityName'="" d
	...s sqlStr = "select RowId, '2'||RowId As nodeid, Description from CHSS.DictCity where rowid ="_CityName
	..e  d
	...s sqlStr = "select RowId, '2'||RowId As nodeid, Description from CHSS.DictCity where rowidparref ="_id
	
	..s level = "city"
	.e  i level = "city" d
	..i SectionName'="" d
	...s sqlStr = "select RowId, '3'||RowId As nodeid, Description from CHSS.DictSection where rowid ="_SectionName
    ..e  d
	...s sqlStr = "select RowId, '3'||RowId As nodeid, Description from CHSS.DictSection where rowidparref ="_id
	
	..s level = ""
	..s Leaf = "true"
	;w sqlStr,!
	d result.Prepare(sqlStr)
	d result.Execute()
	s resultString = ""
	s json = ##class(Code.JsonObj).%New()
	While(result.Next())
	{
		s rowid = result.Data("RowId")
	    s nodeid = result.Data("nodeid")
		s text=result.Data("Description")
				
	    s tmp=nodeid_"^"_text_"^"_Leaf_"^"_level_"^"_rowid
	    d json.InsertRowData(tmp)
	    s count=count+1
	}
	d result.Close()
	s resultString = json.getTreeJsonData("id^text^leaf^level^rowid")
	k json
	q resultString
}

/// Creator: lyy
/// CreatDate：2010-07-
/// Description: 社区档案列表
/// Table：
/// Input: 
/// Output：
/// Return：
/// Others：
ClassMethod ListCommunity(SectionId As %Integer, start As %Integer, limit As %Integer, sort As %String, communitycode As %String, CommunityType) As %String
{
      
    Set start=$G(start)
	Set limit=$G(limit)
	Set communitycode=$G(communitycode)
	
	Set CommunityType=$G(CommunityType)
	Set count=0
	Set resultString = ""
	Set end = start+limit  
	
	Set json = ##class(Code.JsonObj).%New()
    Set tmp = ""
    
  
    s result = ##class(%Library.ResultSet).%New()
    I ((CommunityType = "县（区）卫生局")||(CommunityType = "市卫生局")||(CommunityType = "省卫生厅")) d
    
    .s sqlStr = "select hospital.Communitycode, hospital.Communityname, hospital.Communitytype from CHSS.DictStreet street, CHSS.DictHospital hospital where street.RowIdParref = "_SectionId_" and street.rowid = hospital.RecordDR and (hospital.communitytype = '社区卫生服务中心' or hospital.communitytype = '乡镇卫生院') "
    .s sqlStr = sqlStr_" union select hospital.Communitycode, hospital.Communityname, hospital.Communitytype from CHSS.DictStreet street, CHSS.DictVillage village, CHSS.DictHospital hospital where street.RowIdParref = "_SectionId_"  and street.rowid = village.RowIdParref and village.rowid = hospital.RecordDR and (hospital.communitytype = '社区卫生服务站' or hospital.communitytype = '村卫生所' )"
    e  d
    .s sqlStr = "select hospital.Communitycode, hospital.Communityname, hospital.Communitytype from CHSS.DictStreet street, CHSS.DictHospital hospital where street.RowIdParref = "_SectionId_" and street.rowid = hospital.RecordDR and  (hospital.Communitycode="_communitycode_" or  hospital.upCommunitycode="_communitycode_") and (hospital.communitytype = '社区卫生服务中心' or hospital.communitytype = '乡镇卫生院')"
    .s sqlStr = sqlStr_" union select hospital.Communitycode, hospital.Communityname, hospital.Communitytype from CHSS.DictStreet street, CHSS.DictVillage village, CHSS.DictHospital hospital where street.RowIdParref = "_SectionId_"  and street.rowid = village.RowIdParref and village.rowid = hospital.RecordDR and hospital.Communitycode="_communitycode_" or  hospital.upCommunitycode="_communitycode_" and (hospital.communitytype='社区卫生服务站' or hospital.communitytype = '村卫生所' )"  
    ;w sqlStr,!
	d result.Prepare(sqlStr)
	d result.Execute()
	
   
	While(result.Next())
	{
		s CommunityCode=result.Data("CommunityCode")
		s CommunityName=result.Data("CommunityName")
		s CommunityType=result.Data("CommunityType")
		
						
		Set tmp = CommunityCode_"^"_CommunityName_"^"_CommunityType
        
     	Set count=count+1
     	If (count>start)&(count<=end) d
     	.d json.InsertRowData(tmp)
    }
    
    d result.Close()
    
         
    Set resultString = json.getJsonData("CommunityCode^CommunityName^CommunityType",count)
    k json
      
    Quit resultString
}

/// Creator: lyy
/// CreatDate：2010-07-
/// Description: 社区档案列表
/// Table：
/// Input: 
/// Output：
/// Return：
/// Others：
ClassMethod ListCommunityList(commcode)
{
      
    Set commcode=$G(commcode)

	Set count=0
	Set resultString = ""
	
	
	Set json = ##class(Code.JsonObj).%New()
    Set tmp = ""
    
  
    s result = ##class(%Library.ResultSet).%New()
        
    
    s sqlStr = "select CommunityRowId  from chss.communitybaseinfo where communitycode="_commcode
    
	d result.Prepare(sqlStr)
	d result.Execute()
	
   
	While(result.Next())
	{
		
		s CommunityRowId=result.Data("CommunityRowId")
	    s temp=##class(CHSS.CommunityBaseInfo).%OpenId(CommunityRowId)
	    s CommunityCode=temp.CommunityCode
	    s CommunityName=temp.CommunityName
	    s Area=temp.Area
	    s TotalFamilyNum=temp.TotalFamilyNum
	    s TotalPersonNum=temp.TotalPersonNum
		s Year=temp.Year				
		Set tmp =CommunityRowId_"^"_CommunityCode_"^"_CommunityName_"^"_Year_"^"_Area_"^"_TotalFamilyNum_"^"_TotalPersonNum
        
     	Set count=count+1
     	d json.InsertRowData(tmp)
    }
    
    d result.Close()
    
         
    Set resultString = json.getJsonData("CommunityRowId^CommunityCode^CommunityName^Year^Area^TotalFamilyNum^TotalPersonNum",count)
    k json
      
    Quit resultString
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
    s HospitalName = ""
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
	s tmp=ProvinceName_"^"_CityName_"^"_SectionName_"^"_StreetName
	}
	d result.Close()
    k json
	q tmp
}

ClassMethod GetCommunityName(CommunityCode As %String) As %String
{
	q:CommunityCode="" ""
	s CommunityName = ""

    
    s result1 = ##class(%Library.ResultSet).%New()
	s sqlStr1 = "select CommunityName FROM CHSS.DictHospital where CommunityCode = "_CommunityCode
	
	d result1.Prepare(sqlStr1)
	d result1.Execute()
	
	While(result1.Next())
	{
		s CommunityName = result1.Data("CommunityName")
	}
	q CommunityName
}

}
