Class CHSSWeb.HealthEducationRecordService Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

//列出所有记录

ClassMethod listPage(CommunityCode, Start, Limit) As %String
{
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "SELECT * FROM CHSS.HealthEducationRecord where CommunityCode ="_CommunityCode
	
	d result.Prepare(sqlStr)
	d result.Execute()
	
	s count = 0
	s resultString = ""
	s end = Start+Limit
	
	s json = ##class(Code.JsonObj).%New()
	
	While(result.Next())
	{
	s RecordRowId = result.Data("RecordRowId")
	
	s temp=##class(CHSS.HealthEducationRecord).%OpenId(RecordRowId)
	
	s Theme = result.Data("Theme")
	s HEPlace = result.Data("HEPlace")
	s Unit = result.Data("Unit")
	s HETime = result.Data("HETime")
	i (HETime'="") d
	.s HETime=$zd(HETime,3)
	
	s HEType=""
	s HETypeName=""
	i temp.HEType '="" d
	.s HEType=temp.HEType.%Id()
	.s HETypeName=temp.HEType.Description
	
	s CollaborateUnit = result.Data("CollaborateUnit")
	s PersonNum = result.Data("PersonNum")
	s PromoType = result.Data("PromoType")
    s PromoNum = result.Data("PromoNum")
	s Name = result.Data("Name")
	s DateOfCreate = result.Data("DateOfCreate")
	i (DateOfCreate'="") d
	.s DateOfCreate = $zd(DateOfCreate,3)
	s Summarize = result.Data("Summarize")
	s Appraise = result.Data("Appraise")
	s Principal= result.Data("Principal")
	s MaterialType = result.Data("MaterialType")
	s CommunityCode = result.Data("CommunityCode")
	
	
	s tmp=RecordRowId_"^"_Theme_"^"_HEPlace_"^"_Unit_"^"_HETime_"^"_HEType_"^"_HETypeName_"^"_CollaborateUnit_"^"_PersonNum_"^"_PromoType_"^"_PromoNum_"^"_Name_"^"_DateOfCreate_"^"_Summarize_"^"_Appraise_"^"_Principal_"^"_MaterialType_"^"_CommunityCode
	s count = count+1
	i (count>Start)&(count<=end) d
	.d json.InsertRowData(tmp)
	}
	d result.Close()
	s resultString = json.getJsonData("RecordRowId^Theme^HEPlace^Unit^HETime^HEType^HETypeName^CollaborateUnit^PersonNum^PromoType^PromoNum^Name^DateOfCreate^Summarize^Appraise^Principal^MaterialType^CommunityCode",count)
	k json
	q resultString
}

//添加记录

ClassMethod insert(Theme, HEPlace, Unit, HETime, HEType, CollaborateUnit, PersonNum, PromoType, PromoNum, Name, DateOfCreate, Summarize, Appraise, Principal, MaterialType, CommunityCode) As %String
{
	s temp=""
	s temp=##class(CHSS.HealthEducationRecord).%New()
	
	i HETime '= "" d
	.s HETime=$zdh(HETime,3)
	i DateOfCreate '= "" d
	.s DateOfCreate=$zdh(DateOfCreate,3)
    
    i HEType'="" d
    .s temp.HEType=##class(CHSS.DictHERecordType).%OpenId(HEType)
    
    s temp.Theme=Theme
    s temp.HEPlace=HEPlace
    s temp.Unit=Unit
    s temp.HETime=HETime
    s temp.CollaborateUnit=CollaborateUnit
    s temp.PersonNum=PersonNum
    s temp.PromoType=PromoType
    s temp.PromoNum=PromoNum
    s temp.Name=Name
    s temp.DateOfCreate=DateOfCreate
    s temp.Summarize=Summarize
    s temp.Appraise=Appraise
    s temp.Principal=Principal
    s temp.MaterialType=MaterialType
	s temp.CommunityCode=CommunityCode
    
    s result=""
    s result=temp.%Save()
    Set resultString = ""
    i result = "1" d
   .s resultString = "{""success"":""true"",""info"":"_temp.%Id()_"}"
    e  d
    .s resultString = "{""success"":""false"",""info"":""数据保存出错!""}"
    q resultString
}

//修改记录

ClassMethod update(RecordRowId, Theme, HEPlace, Unit, HETime, HEType, CollaborateUnit, PersonNum, PromoType, PromoNum, Name, DateOfCreate, Summarize, Appraise, Principal, MaterialType, CommunityCode) As %String
{
	s tempChild="",result=""
	s temp=##class(CHSS.HealthEducationRecord).%OpenId(RecordRowId) 
	
	i Theme '="" do
	.s temp.Theme = Theme
	
	i HEPlace '="" do
	.s temp.HEPlace = HEPlace
	
	i Unit '="" do
	.s temp.Unit = Unit
	
	i HETime '="" do
	.s HETime=$zdh(HETime,3)
	.s temp.HETime = HETime
	
	i HEType '="" do 
	.s temp.HEType=##class(CHSS.DictHERecordType).%OpenId(HEType)
	
	i CollaborateUnit '="" do
	.s temp.CollaorateUnit = CollaorateUnit
	
	i PersonNum '="" do
	.s temp.PersonNum = PersonNum
	

	i PromoType '="" do
	.s temp.PromoType = PromoType
	
	i PromoNum '="" do
	.s temp.PromoNum = PromoNum
	
	i Name '="" do
	.s temp.Name = Name
	
	i DateOfCreate '="" do
	.s DateOfCreate = $zdh(DateOfCreate,3)
	.s temp.DateOfCreate = DateOfCreate
	
	i Summarize '="" do
	.s temp.Summarize = Summarize
	
	i Appraise '="" do
	.s temp.Appraise =  Appraise
	
	i Principal '="" do
	.s temp.Principal = Principal
	
	i MaterialType '="" do
	.s temp.MaterialType = MaterialType
	
	i CommunityCode'="" do
	.s temp.CommunityCode = CommunityCode
	
	s result=""
    s result=temp.%Save()
    Set resultString = ""
    i result = "1" d
   .s resultString = "{""success"":""true"",""info"":"_temp.%Id()_"}"
    e  d
    .s resultString = "{""success"":""false"",""info"":""数据保存出错!""}"
    q resultString
}

//删除记录

ClassMethod delete(RecordRowId) As %String
{
	
	s temp =##class(CHSS.HealthEducationRecord).%OpenId(RecordRowId)
 
    s result=temp.%DeleteId(RecordRowId)
	i result="1" d
	. s resultString="{""success"":""true"",""info"":""数据删除成功!""}"
    e  d
    .s resultString = "{""success"":""false"",""info"":""数据删除出错!""}"
    q resultString
}

//查询

ClassMethod search(CommunityCode, Start, Limit, SqlStr)
{
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "SELECT * FROM CHSS.HealthEducationRecord where CommunityCode ="_CommunityCode_SqlStr
	
	d result.Prepare(sqlStr)
	d result.Execute()
	
	s count = 0
	s resultString = ""
	s end = Start+Limit
	
	s json = ##class(Code.JsonObj).%New()
	
	While(result.Next())
	{
	s RecordRowId = result.Data("RecordRowId")
	
	s temp=##class(CHSS.HealthEducationRecord).%OpenId(RecordRowId)
	
	s Theme = result.Data("Theme")
	s HEPlace = result.Data("HEPlace")
	s Unit = result.Data("Unit")
	s HETime = result.Data("HETime")
	i (HETime'="") d
	.s HETime=$zd(HETime,3)
	
	s HEType=""
	s HETypeName=""
	i temp.HEType '="" d
	.s HEType=temp.HEType.%Id()
	.s HETypeName=temp.HEType.Description
	
	s CollaborateUnit = result.Data("CollaborateUnit")
	s PersonNum = result.Data("PersonNum")
	s PromoType = result.Data("PromoType")
    s PromoNum = result.Data("PromoNum")
	s Name = result.Data("Name")
	s DateOfCreate = result.Data("DateOfCreate")
	i (DateOfCreate'="") d
	.s DateOfCreate = $zd(DateOfCreate,3)
	s Summarize = result.Data("Summarize")
	s Appraise = result.Data("Appraise")
	s Principal= result.Data("Principal")
	s MaterialType = result.Data("MaterialType")
	s CommunityCode = result.Data("CommunityCode")
	
	
	s tmp=RecordRowId_"^"_Theme_"^"_HEPlace_"^"_Unit_"^"_HETime_"^"_HEType_"^"_HETypeName_"^"_CollaborateUnit_"^"_PersonNum_"^"_PromoType_"^"_PromoNum_"^"_Name_"^"_DateOfCreate_"^"_Summarize_"^"_Appraise_"^"_Principal_"^"_MaterialType_"^"_CommunityCode
	s count = count+1
	i (count>Start)&(count<=end) d
	.d json.InsertRowData(tmp)
	}
	d result.Close()
	s resultString = json.getJsonData("RecordRowId^Theme^HEPlace^Unit^HETime^HEType^HETypeName^CollaborateUnit^PersonNum^PromoType^PromoNum^Name^DateOfCreate^Summarize^Appraise^Principal^MaterialType^CommunityCode",count)
	k json
	q resultString
}

Storage Default
{
<Data name="HealthEducationRecordServiceDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^CHSSWeb.HealthEducatB22D</DataLocation>
<DefaultData>HealthEducationRecordServiceDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSSWeb.HealthEducatB22D</IdLocation>
<IndexLocation>^CHSSWeb.HealthEducatB22I</IndexLocation>
<StreamLocation>^CHSSWeb.HealthEducatB22S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
