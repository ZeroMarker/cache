Class CHSSWeb.ChildDiseaseHisService Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

ClassMethod List(Child36Id)
{
	
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "SELECT * FROM CHSS.ChildDiseaseHis where RowIdParref = "_Child36Id
	
	d result.Prepare(sqlStr)
	d result.Execute()
	
	s count = 0
	s resultString = ""
	
	
	s json = ##class(Code.JsonObj).%New()
	
	While(result.Next())
	{
	 s count= count+1
	 s DisRowId=result.Data("DisRowId")
	 s tempChild= ##class(CHSS.ChildDiseaseHis).%OpenId(DisRowId)
	 
	 
	 s RowIdParref=""
     i tempChild.RowIdParref'="" d
	 .s RowIdParref=tempChild.RowIdParref.%Id()
	 
	 s DiseaseCode  = tempChild.DiseaseCode
     s DiseaseName = tempChild.DiseaseName
     s DiseaseTimes=tempChild.DiseaseTimes
     
    s tmp=""
	s tmp=DisRowId_"^"_RowIdParref_"^"_DiseaseCode_"^"_DiseaseName_"^"_DiseaseTimes
    d json.InsertRowData(tmp)
	}
    d result.Close()	
	s resultString = json.getJsonData("DisRowId^RowIdParref^DiseaseCode^DiseaseName^DiseaseTimes",count)
	k json
	
    Quit resultString
}

ClassMethod ShowInfo(Child36Id)
{
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "SELECT * FROM CHSS.ChildDiseaseHis where RowIdParref = "_Child36Id
	
	d result.Prepare(sqlStr)
	d result.Execute()
	
	s count = 0
	s resultString = ""
    set tmp = ""
    set startStr = "'"
	
	s json = ##class(Code.JsonObj).%New()
	
	While(result.Next())
{
     s DisRowId=result.Data("DisRowId")
	 s tempChild= ##class(CHSS.ChildDiseaseHis).%OpenId(DisRowId)
	 
	 
	 s RowIdParref=""
     i tempChild.RowIdParref'="" d
	 .s RowIdParref=tempChild.RowIdParref.%Id()
	 
	 s DiseaseCode  = tempChild.DiseaseCode
     s DiseaseName = tempChild.DiseaseName
     s DiseaseTimes=tempChild.DiseaseTimes

    Set tmp = tmp_startStr_"疾病名称: "_DiseaseName_", 患病次数: "_DiseaseTimes
    s startStr = "\r\n"
    }

    i tmp '= "" d
    .s tmp = tmp_"'"
    e  d
    .s tmp = """"""
    q "{""success"":""true"",""info"":"_tmp_"}"
}

ClassMethod insert(Child36Id, DiseaseCode, DiseaseName, DiseaseTimes)
{
	
	s tempChild = ""
	s tempChild =##class(CHSS.ChildDiseaseHis).%New()
	
		
	i Child36Id '= "" d
	.s tempChild.RowIdParref=##class(CHSS.Child36CheckRecord).%OpenId(Child36Id)
	
	s tempChild.DiseaseCode=DiseaseCode
	
	s tempChild.DiseaseName=DiseaseName
	
	s tempChild.DiseaseTimes=DiseaseTimes
	 
	s result=""
    s result=tempChild.%Save()
    Set resultString = ""
    i result = "1" d
    .s resultString = "{""success"":""true"",""info"":"_tempChild.%Id()_"}"
    e  d
    .s resultString = "{""success"":""false"",""info"":""数据保存出错!""}"
    q resultString
}

ClassMethod update(DisRowId, Child36Id, DiseaseCode, DiseaseName, DiseaseTimes)
{
	
	i DisRowId '= ""
	s tempChild =##class(CHSS.ChildDiseaseHis).%OpenId(DisRowId)
	
		
	i Child36Id '= "" d
	.s tempChild.RowIdParref=##class(CHSS.Child36CheckRecord).%OpenId(Child36Id)
	
	s tempChild.DiseaseCode=DiseaseCode
	
	s tempChild.DiseaseName=DiseaseName
	
	s tempChild.DiseaseTimes=DiseaseTimes
	 
	s result=""
    s result=tempChild.%Save()
    Set resultString = ""
    i result = "1" d
    .s resultString = "{""success"":""true"",""info"":"_tempChild.%Id()_"}"
    e  d
    .s resultString = "{""success"":""false"",""info"":""数据保存出错!""}"
    q resultString
}

ClassMethod delete(DisRowId)
{
	s DisRowId = ""
	s tempChild =##class(CHSS.ChildDiseaseHis).%OpenId(DisRowId)
 
    s result=tempChild.%DeleteId(DisRowId)
	i result="1" d
	. s resultString="{""success"":""true"",""info"":""数据删除成功!""}"
    e  d
    .s resultString = "{""success"":""false"",""info"":""数据删除出错!""}"
    q resultString
}

Storage Default
{
<Data name="ChildDiseaseHisServiceDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^CHSSWeb.ChildDisease897D</DataLocation>
<DefaultData>ChildDiseaseHisServiceDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSSWeb.ChildDisease897D</IdLocation>
<IndexLocation>^CHSSWeb.ChildDisease897I</IndexLocation>
<StreamLocation>^CHSSWeb.ChildDisease897S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
