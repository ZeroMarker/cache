Class CHSSWeb.CHSSResourceService Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

ClassMethod List(Start, Limit)
{
	Set start=$G(Start)
	Set limit=$G(Limit)
	set Limit = 200
	s sqlstr = "select a.*,a.ResTypeRowId->Description as ResTypeRowIdName,ModelRowId->Text as ModelRowIdName  from CHSS.CHSSResource a"
	s tempRes = ##class(%Library.ResultSet).%New()
	d tempRes.Prepare(sqlstr)
	d tempRes.Execute()
	
	s count = 0
	s resultString = ""
	s end = start+limit
	
	s json = ##class(Code.JsonObj).%New()
	
	While(tempRes.Next())
	{
	s ResRowId = tempRes.Data("ResRowId")
	s ModelRowId=tempRes.Data("ModelRowId")
	s ResCode=tempRes.Data("ResCode")
	s ResName=tempRes.Data("ResName")
	s ResDescription=tempRes.Data("ResDescription")
	
	s ResTypeRowId = tempRes.Data("ResTypeRowId")
	s ResTypeRowIdName = tempRes.Data("ResTypeRowIdName")
	s ModelRowIdName = tempRes.Data("ModelRowIdName")
	s tmp=""
	s tmp=ResRowId_"^"_ModelRowId_"^"_ModelRowIdName_"^"_ResTypeRowId_"^"_ResTypeRowIdName_"^"_ResCode_"^"_ResName_"^"_ResDescription
	;s tmp = ResRowId_"^"_ModelRowId_"^"_ModelRowIdName_"^"_ResTypeRowId
	s count=count+1
	i (count>start)&(count<=end) d
	.d json.InsertRowData(tmp)
	}
	d tempRes.Close()
	s resultString=json.getJsonData("ResRowId^ModelRowId^ModelRowIdName^ResTypeRowId^ResTypeRowIdName^ResCode^ResName^ResDescription",count)
	k json        
	Quit resultString
}

ClassMethod insertupdata(ResRowId, ModelRowId, ResTypeRowId, ResCode, ResName, ResDescription)
{
	s tempRes=""
	s ResRowIdPre = ""
	i ResRowId="" d
	.s tempRes=##class(CHSS.CHSSResource).%New()
	e  d
	.s tempRes=##class(CHSS.CHSSResource).%OpenId(ResRowId)

	i ModelRowId '= "" d
	.s ModelObj = ##class(CHSS.PubModelList).%OpenId(ModelRowId)
	.s tempRes.ModelRowId=ModelObj

	i ResTypeRowId '= "" d
	.s ResTypeObj = ##class(CHSS.CHSSResourceType).%OpenId(ResTypeRowId)
	.s tempRes.ResTypeRowId=ResTypeObj
	
	s tempRes.ResCode=ResCode
	s tempRes.ResName=ResName
	s tempRes.ResDescription=ResDescription
	
	s result=""
	s result=tempRes.%Save()
	s resultString=""
	
	i result="1" d
	.s resultString="{""success"":""true"",""info"":"_tempRes.%Id()_"}"
	e  d
	.s resultString="{""success"":""false"",""info"":""数据保存出错！""}"
	q resultString
}

ClassMethod del(ResRowId)
{
	q:(ResRowId="") ""
	s tempRes=##class(CHSS.CHSSResource).%OpenId(ResRowId)	
	q:(tempRes="") ""
	
	s result=tempRes.%DeleteId(ResRowId)
	
	i result="1" d
	 .w "{""success"":""true"",""info"":""数据删除成功！""}"
    e  d
    .w "{""success"":""false"",""info"":""数据删除出错！""}"
    
    q ""
}

ClassMethod ImportData()
{
	&sql(insert into CHSS.CHSSResource (ModelRowId,ResCode,ResDescription,ResName) select ModelRowId, ModelCode,Text,Text from CHSS.PubModelList where ModelRowId not in (select ModelRowId from CHSS.CHSSResource))
	;w SQLCODE
	;i SQLCODE=0 d
	w "{""success"":""true"",""info"":""数据导入成功！""}"
   
    q ""
}

Storage Default
{
<Data name="CHSSResourceServiceDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^CHSSWeb.CHSSResourceServiceD</DataLocation>
<DefaultData>CHSSResourceServiceDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSSWeb.CHSSResourceServiceD</IdLocation>
<IndexLocation>^CHSSWeb.CHSSResourceServiceI</IndexLocation>
<StreamLocation>^CHSSWeb.CHSSResourceServiceS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
