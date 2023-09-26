Class CHSSWeb.PubModelListsService Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

ClassMethod List(Start, Limit)
{
	Set start=$G(Start)
	Set limit=$G(Limit)
	Set count=0
	Set resultString = ""
	Set end = start+limit
	Set json = ##class(Code.JsonObj).%New()
	s ModelRowId=0
	
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "SELECT ModelRowId,ModelRowIdParref,ModelCode,Text,Leaf,IconCls,Sort,URL,Status,bDict,bSame,MethodBefore,MethodAfter,Node,ReportUrl,bCacheApp,CacheAppName from CHSS.PubModelList order by ModelCode "
	;s sqlStr = "SELECT * from CHSS.PubModelList order by ModelCode "
	
	;ModelRowIdParref,
	d result.Prepare(sqlStr)
	d result.Execute()
	While(result.Next())
	{
	s ModelRowId = result.Data("ModelRowId")
	s ModelRowIdParref=result.Data("ModelRowIdParref")
	s ModelCode=result.Data("ModelCode")
	s Text=result.Data("Text")
	s Leaf=result.Data("Leaf")
	s IconCls=result.Data("IconCls")
	s Sort=result.Data("Sort")
	s URL=result.Data("URL")
	s Status=result.Data("Status")
	s bDict=result.Data("bDict")
	s bSame=result.Data("bSame")
	s MethodBefore=result.Data("MethodBefore")
	s MethodAfter=result.Data("MethodAfter")
	s Node=result.Data("Node")
	s ReportUrl = result.Data("ReportUrl")
	s bCacheApp = result.Data("bCacheApp")
	s CacheAppName = result.Data("CacheAppName")
	s ModelRowIdParrefName = ..GetModelNameWithCode(ModelRowIdParref)
	;w ModelRowIdParrefName,!
	s tmp=""
	s tmp= ModelRowId_"^"_ModelRowIdParref_"^"_ModelCode_"^"_Text_"^"_Leaf_"^"_IconCls_"^"_Sort_"^"_URL_"^"_Status_"^"_bDict_"^"_bSame_"^"_MethodBefore_"^"_MethodAfter_"^"_Node_"^"_ReportUrl_"^"_ModelRowIdParrefName_"^"_bCacheApp_"^"_CacheAppName
	s count = count+1
	i (count>Start)&(count<=end) d
	.d json.InsertRowData(tmp)
		}
	d result.Close()
	s resultString = json.getJsonData("ModelRowId^ModelRowIdParref^ModelCode^Text^Leaf^IconCls^Sort^URL^Status^bDict^bSame^MethodBefore^MethodAfter^Node^ReportUrl^ModelRowIdParrefName^bCacheApp^CacheAppName",count)
	k json	
	q resultString
}

//检索

ClassMethod search(Start, Limit, Str)
{
	;s sqlStr = "SELECT ModelRowId,ModelRowIdParref,ModelCode,Text,Leaf,IconCls,Sort,URL,Status,bDict,bSame,MethodBefore,MethodAfter,Node,ReportUrl,bCacheApp,CacheAppName from CHSS.PubModelList  where Text like '%"_Str_"%' order by ModelCode"
	Set start=$G(Start)
	Set limit=$G(Limit)
    Set count=0
	Set resultString = ""
	Set end = start+limit
	Set json = ##class(Code.JsonObj).%New()
	s ModelRowId=0
	s sqlStr=""
	s sqlS=""
	s ModerParrId=""
	
	
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "SELECT ModelRowId,ModelRowIdParref,ModelCode,Text,Leaf,IconCls,Sort,URL,Status,bDict,bSame,MethodBefore,MethodAfter,Node,ReportUrl,bCacheApp,CacheAppName from CHSS.PubModelList order by ModelCode"
	
	
	i Str'=""
	{
        d result.Prepare(sqlStr)
	    d result.Execute()
	    while(result.Next())
	   {
		   s ModelRowIdParref=result.Data("ModelRowIdParref")
		   continue:ModelRowIdParref=""
		   s ModelParrefName=..GetModelNameWithCode(ModelRowIdParref)
		   i ModelParrefName[Str
		   {
		    s ModerParrId=ModelRowIdParref
		    s sqlS=sqlS_"or ModelRowIdParref="_ModerParrId
		   }
	   }
       
	    s result = ##class(%Library.ResultSet).%New()
        s sqlStr = "SELECT ModelRowId,ModelRowIdParref,ModelCode,Text,Leaf,IconCls,Sort,URL,Status,bDict,bSame,MethodBefore,MethodAfter,Node,ReportUrl,bCacheApp,CacheAppName from CHSS.PubModelList  where Text like '%"_Str_"%'"_sqlS_"order by ModelCode"
    }
    
    
    
    d result.Prepare(sqlStr)
	d result.Execute()
	While(result.Next())
	{
	s ModelRowId = result.Data("ModelRowId")
	s ModelRowIdParref=result.Data("ModelRowIdParref")
    s ModelRowIdParrefName = ..GetModelNameWithCode(ModelRowIdParref)
	s ModelCode=result.Data("ModelCode")
	s Text=result.Data("Text")
	s Leaf=result.Data("Leaf")
	s IconCls=result.Data("IconCls")
	s Sort=result.Data("Sort")
	s URL=result.Data("URL")
	s Status=result.Data("Status")
	s bDict=result.Data("bDict")
	s bSame=result.Data("bSame")
	s MethodBefore=result.Data("MethodBefore")
	s MethodAfter=result.Data("MethodAfter")
	s Node=result.Data("Node")
	s ReportUrl = result.Data("ReportUrl")
	s bCacheApp = result.Data("bCacheApp")
	s CacheAppName = result.Data("CacheAppName")
    s tmp=""
	s tmp= ModelRowId_"^"_ModelRowIdParref_"^"_ModelCode_"^"_Text_"^"_Leaf_"^"_IconCls_"^"_Sort_"^"_URL_"^"_Status_"^"_bDict_"^"_bSame_"^"_MethodBefore_"^"_MethodAfter_"^"_Node_"^"_ReportUrl_"^"_ModelRowIdParrefName_"^"_bCacheApp_"^"_CacheAppName
	s count = count+1
	i (count>Start)&(count<=end) d
	.d json.InsertRowData(tmp)
    }
	d result.Close()
	s resultString = json.getJsonData("ModelRowId^ModelRowIdParref^ModelCode^Text^Leaf^IconCls^Sort^URL^Status^bDict^bSame^MethodBefore^MethodAfter^Node^ReportUrl^ModelRowIdParrefName^bCacheApp^CacheAppName",count)
	k json	
	q resultString
}

ClassMethod insertupdata(ModelRowId, ModelRowIdParref, ModelCode, Text, Leaf, IconCls, Sort, URL, Status, bDict, bSame, MethodBefore, MethodAfter, Node, ReportUrl, bCacheApp, CacheAppName)
{
	s tempMode=""
	
	i ModelRowId '="" d
	.s tempMode=##class(CHSS.PubModelList).%OpenId(ModelRowId)
	e  d
	.s tempMode=##class(CHSS.PubModelList).%New()
	
	s tempMode.ModelRowIdParref=ModelRowIdParref
	s tempMode.ModelCode=ModelCode
	s tempMode.Text=Text
	s tempMode.Leaf=Leaf
	s tempMode.IconCls=IconCls
	s tempMode.Sort=Sort
	s tempMode.URL=URL
	s tempMode.Status=Status
	s tempMode.bDict=bDict
	s tempMode.bSame=bSame
	s tempMode.MethodBefore=MethodBefore
	s tempMode.MethodAfter=MethodAfter
	s tempMode.Node=Node
	s tempMode.ReportUrl = ReportUrl
	
	s tempMode.bCacheApp = bCacheApp
	s tempMode.CacheAppName = CacheAppName
	s result=""
    s result=tempMode.%Save()
  
    Set resultString = ""
    i result = "1" d
    .s resultString = "{""success"":""true"",""info"":"_tempMode.%Id()_"}"
    e  d
    .s resultString = "{""success"":""false"",""info"":""数据保存出错!""}"
    q resultString
}

ClassMethod delete(ModelRowId)
{
	q:(ModelRowId = "") ""
	s tempMode=##class(CHSS.PubModelList).%OpenId(ModelRowId)
	q:(tempMode="") ""
	
	s result=tempMode.%DeleteId(ModelRowId)
	
	i result = "1" d
    .w "{""success"":""true"",""info"":""数据删除成功！""}"

    e  d
    .w "{""success"":""false"",""info"":""数据删除出错！""}"
    
    q ""
}

ClassMethod ListParent(ModelRowId, Strat, Limit)
{
	Set start=$G(Start)
	Set limit=$G(Limit)
	set ModelRowId=$G(ModelRowId)
	Set count=0
	Set resultString = ""
	Set end = start+limit
	Set json = ##class(Code.JsonObj).%New()
	s RowId=""
	
    For  Set RowId=$O(^CHSS.PubModelListD(RowId)) q:RowId=""  d
    .i RowId'=ModelRowId d
	..s tempMode=##class(CHSS.PubModelList).%OpenId(RowId)
	..s ModelCode=tempMode.ModelCode
	..s Text=tempMode.Text
	..
	..s tmp=""
	..s tmp=RowId_"^"_ModelCode_"^"_Text
	..s count=count+1
	..i (count>start)&(count<=end) d
    ...d json.InsertRowData(tmp)
    
    s resultString= json.getJsonData("RowId^ModelCode^Text",count)
    k json	
	Quit resultString
}

ClassMethod ListParentSearch(ModelRowId, Strat, Limit, SearchSql)
{
	Set start=$G(Start)
	Set limit=$G(Limit)
	set ModelRowId=$G(ModelRowId)
	Set count=0
	Set resultString = ""
	Set end = start+limit
	Set json = ##class(Code.JsonObj).%New()
	s RowId=""
	
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr2 = ""
	i SearchSql '= "" d
	.s sqlStr2 = "where Text like '%"_SearchSql_"%'"
	s sqlStr = "SELECT * from CHSS.PubModelList "_sqlStr2_" order by ModelCode "
	;ModelRowIdParref,
	d result.Prepare(sqlStr)
	d result.Execute()
	While(result.Next())
	{
	s ModelRowId = result.Data("ModelRowId")
	s ModelCode=result.Data("ModelCode")
	s Text=result.Data("Text")
	
	s tmp=""
	s tmp= ModelRowId_"^"_ModelCode_"^"_Text
	s count = count+1
	d json.InsertRowData(tmp)
	}
	d result.Close()

    s resultString= json.getJsonData("RowId^ModelCode^Text",count)
    k json	
	Quit resultString
}

ClassMethod GetModelNameWithCode(ModelCode)
{
	s text = ""
	&SQL(SELECT Text into :text from CHSS.PubModelList where ModelCode = :ModelCode)
	q text
}

Storage Default
{
<Data name="PubModelListsServiceDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^CHSSWeb.PubModelListsServiceD</DataLocation>
<DefaultData>PubModelListsServiceDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSSWeb.PubModelListsServiceD</IdLocation>
<IndexLocation>^CHSSWeb.PubModelListsServiceI</IndexLocation>
<StreamLocation>^CHSSWeb.PubModelListsServiceS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
