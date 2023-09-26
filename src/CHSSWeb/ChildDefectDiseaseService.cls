Class CHSSWeb.ChildDefectDiseaseService Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

//列出缺陷与疾病记录

ClassMethod List(Start, Limit, ChildRowId) As %String
{
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "SELECT * FROM CHSS.ChildDefectDisease where ChildRowId="_ChildRowId
	
	d result.Prepare(sqlStr)
	d result.Execute()
	
	s count = 0
	s resultString = ""
	s end = Start+Limit
	
	s json = ##class(Code.JsonObj).%New()
	
	While(result.Next())
	{
	s DefectRowId = result.Data("DefectRowId")
	
	s temp=##class(CHSS.ChildDefectDisease).%OpenId(DefectRowId)
	s ChildRowId=""
	s ChildName=""
	s ChildHandBookCode=""
	s Description=""
	s Birth=""
	s CureType=""
	i temp.ChildRowId '="" d
	.s ChildRowId=temp.ChildRowId.%Id()
	.s ChildName=temp.ChildRowId.Name
	.s ChildHandBookCode2=temp.ChildRowId.ChildHandBookCode
	.s Birth=temp.ChildRowId.Birth
    i temp.CureType '="" d
    .s CureType=temp.CureType.%Id()
	.s CureType=temp.CureType.Description
	i (Birth'="") d
	.s Birth=$zd(Birth,3)
	
	s Disease = result.Data("Disease")
	s Defect = result.Data("Defect")
	s Register = result.Data("Register")
	
	s DateOfRegistration = result.Data("DateOfRegistration")
	i (DateOfRegistration'="") d
	.s DateOfRegistration=$zd(DateOfRegistration,3)
	
	s CureInfo = result.Data("CureInfo")
	s Remark = result.Data("Remark")

	
	s tmp=DefectRowId_"^"_ChildRowId_"^"_ChildName_"^"_ChildHandBookCode2_"^"_Birth_"^"_Disease_"^"_Defect_"^"_Register_"^"_DateOfRegistration_"^"_CureInfo_"^"_Remark_"^"_CureType
	s count = count+1
	i (count>Start)&(count<=end) d
	.d json.InsertRowData(tmp)
	}
	d result.Close()
	s resultString = json.getJsonData("DefectRowId^ChildRowId^ChildName^ChildHandBookCode2^Birth^Disease^Defect^Register^DateOfRegistration^CureInfo^Remark^CureType",count)
	k json
	q resultString
}

//修改缺陷与疾病记录

ClassMethod Update(DefectRowId, CureType, Disease, Defect, Register, DateOfRegistration, CureInfo, Remark, ChildRowId)
{
	s tempChild="",result=""
	s temp=##class(CHSS.ChildDefectDisease).%OpenId(DefectRowId) 
	
	
	i CureType '="" do
	.s temp.CureType = ##class(CHSS.DictCureType).%OpenId(CureType)
	
	i Disease '="" do
	.s temp.Disease = Disease
	
	i DateOfRegistration '="" do
	.s DateOfRegistration=$zdh(DateOfRegistration,3)
	.s temp.DateOfRegistration = DateOfRegistration
	
	i Defect '="" do
	.s temp.Defect = Defect
	
	i Register '="" do
	.s temp.Register = Register
	

	i CureInfo '="" do
	.s temp.CureInfo = CureInfo
	
	i Remark '="" do
	.s temp.Remark = Remark
	
	i ChildRowId '="" do
	.s temp.ChildRowId = ##class(CHSS.ChildBaseInfo).%OpenId(ChildRowId)
	
	s result=""
    s result=temp.%Save()
    Set resultString = ""
    i result = "1" d
   .s resultString = "{""success"":""true"",""info"":"_temp.%Id()_"}"
    e  d
    .s resultString = "{""success"":""false"",""info"":""数据保存出错!""}"
    q resultString
}

//添加缺陷与疾病记录

ClassMethod Insert(CureType, Disease, Defect, Register, DateOfRegistration, CureInfo, Remark, ChildRowId)
{
	s temp=""
	s temp=##class(CHSS.ChildDefectDisease).%New()
	
	i DateOfRegistration '= "" d
	.s DateOfRegistration=$zdh(DateOfRegistration,3)
	.s temp.DateOfRegistration=DateOfRegistration
    
    i CureType'="" d
    .s temp.CureType=##class(CHSS.DictCureType).%OpenId(CureType)
    
    i ChildRowId'="" d
    .s temp.ChildRowId=##class(CHSS.ChildBaseInfo).%OpenId(ChildRowId)
    
    s temp.Disease=Disease
    s temp.Defect=Defect
    s temp.Register=Register
    s temp.CureInfo=CureInfo
    s temp.Remark=Remark

    
    
    s result=""
    s result=temp.%Save()
    Set resultString = ""
    i result = "1" d
    .s resultString = "{""success"":""true"",""info"":"_temp.%Id()_"}"
    e  d
    .s resultString = "{""success"":""false"",""info"":""数据保存出错!""}"
    q resultString
}

//删除缺陷与疾病记录

ClassMethod Delete(DefectRowId)
{
	s temp =##class(CHSS.ChildDefectDisease).%OpenId(DefectRowId)
 
    s result=temp.%DeleteId(DefectRowId)
	i result="1" d
	. s resultString="{""success"":""true"",""info"":""数据删除成功!""}"
    e  d
    .s resultString = "{""success"":""false"",""info"":""数据删除出错!""}"
    q resultString
}

//列出儿保编号

ClassMethod ListChileInfo(Start, Limit, ChildRowId)
{
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "SELECT * FROM CHSS.ChildBaseInfo where ChildRowId="_ChildRowId
	
	d result.Prepare(sqlStr)
	d result.Execute()
	
	s count = 0
	s resultString = ""
	s end = Start+Limit
	
	s json = ##class(Code.JsonObj).%New()
	
	While(result.Next())
	{
	s ChildRowId = result.Data("ChildRowId")
	s ChildHandBookCode2 = result.Data("ChildHandBookCode")
	s tmp=ChildRowId_"^"_ChildHandBookCode2
	s count = count+1
	i (count>Start)&(count<=end) d
	.d json.InsertRowData(tmp)
	}
	d result.Close()
	s resultString = json.getJsonData("ChildRowId^ChildHandBookCode2",count)
	k json
	q resultString
}

Storage Default
{
<Data name="ChildDefectDiseaseServiceDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^CHSSWeb.ChildDefectD9BED</DataLocation>
<DefaultData>ChildDefectDiseaseServiceDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSSWeb.ChildDefectD9BED</IdLocation>
<IndexLocation>^CHSSWeb.ChildDefectD9BEI</IndexLocation>
<StreamLocation>^CHSSWeb.ChildDefectD9BES</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
