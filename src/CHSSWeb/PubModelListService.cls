Class CHSSWeb.PubModelListService Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

ClassMethod List(Start As %Integer, Limit As %Integer, ModelCode As %String, UserId As %Integer, GroupType As %Integer) As %String
{
	
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "SELECT ModelRowId,ModelRowIdParref,ModelCode,Text,Leaf,IconCls,Sort,URL,Status,ReportUrl from CHSS.PubModelList"
	s sqlStr = sqlStr_" where ModelRowIdParref = '"_ModelCode_"' and Status = 'true' "
	s sqlStr = sqlStr_" and ModelRowId in  (select a.ModelRowId from CHSS.PubModelList a"
    s sqlStr = sqlStr_" left join CHSS.CHSSResource b on a.ModelRowId = b.ModelRowId"
    s sqlStr = sqlStr_" left join CHSS.CHSSResourceVsGroup c on c.ResRowId = b.ResRowId"
    s sqlStr = sqlStr_" left join CHSS.CHSSUserVsResource d on d.GroupRowId = c.GroupRowId"

    s sqlStr = sqlStr_" left join CHSS.CHSSResourceGroup e on e.GroupRowId = c.GroupRowId"
    ;s sqlStr = sqlStr_" where  e.GroupType = "_GroupType_"  ) order by Sort"
    s sqlStr = sqlStr_" where  e.GroupType = "_GroupType
    s sqlStr = sqlStr_"  and d.UserRowId in (select  SSUSR_Group from SQLUser.SS_User where SSUSR_RowId= "_UserId_" ) "
    s sqlStr = sqlStr_" ) order by Sort"
	;w sqlStr,!
	d result.Prepare(sqlStr)
	d result.Execute()
	
	s count = 0
	s resultString = ""
	s end = Start+Limit
	
	s json = ##class(Code.JsonObj).%New()
	While(result.Next())
	{
	s ModelRowId = result.Data("ModelRowId")
	
	s ModelRowIdParref = result.Data("ModelRowIdParref")
	s ModelCode = result.Data("ModelCode")
	s Text = result.Data("Text")
	s Leaf = result.Data("Leaf")
	s IconCls = result.Data("IconCls")
	s Sort = "1"
	;result.Data("Sort")
	s URL = result.Data("URL")
	s Status = result.Data("Status")
	s ReportUrl = result.Data("ReportUrl")
	
	s tmp=ModelCode_"^"_ModelRowIdParref_"^"_Text_"^"_Leaf_"^"_IconCls_"^"_Sort_"^"_URL_"^true"_"^"_ReportUrl
	s count = count+1
	i (count>Start)&(count<=end) d
	.d json.InsertRowData(tmp)
	}
	d result.Close()
	s resultString = json.getTreeJsonData("id^parentid^text^leaf^cls^number^url^authority^ReportUrl",count)
	k json
	w resultString
	q ""
}

ClassMethod GetPanelList(UserId As %Integer, GroupType As %Integer) As %String
{
	
	s result = ##class(%Library.ResultSet).%New()
	
	
	s sqlStr = "SELECT * from CHSS.PubModelList"
	s sqlStr = sqlStr_" where Leaf = 'false' and Status = 'true' "
	s sqlStr = sqlStr_" and ModelRowId in  (select a.ModelRowId from CHSS.PubModelList a"
    s sqlStr = sqlStr_" left join CHSS.CHSSResource b on a.ModelRowId = b.ModelRowId"
    s sqlStr = sqlStr_" left join CHSS.CHSSResourceVsGroup c on c.ResRowId = b.ResRowId"
    s sqlStr = sqlStr_" left join CHSS.CHSSUserVsResource d on d.GroupRowId = c.GroupRowId"
    s sqlStr = sqlStr_" left join CHSS.CHSSResourceGroup e on e.GroupRowId = c.GroupRowId"
    ;s sqlStr = sqlStr_" where  e.GroupType = "_GroupType_" ) order by Sort"
    s sqlStr = sqlStr_" where  e.GroupType = "_GroupType
    s sqlStr = sqlStr_"  and d.UserRowId in (select  SSUSR_Group from SQLUser.SS_User where SSUSR_RowId= "_UserId_" ) ) order by Sort"
	
	;s sqlStr = "SELECT * from CHSS.PubModelList"
	;s sqlStr = sqlStr_" where Leaf = 'false' "
	
	;w sqlStr,!
	
	d result.Prepare(sqlStr)
	d result.Execute()
	s Start = 0
	s Limit = 100
	s count = 0
	s resultString = ""
	s end = Start+Limit
	
	s json = ##class(Code.JsonObj).%New()
	While(result.Next())
	{
	s ModelRowId = result.Data("ModelRowId")
	
	s ModelRowIdParref = result.Data("ModelRowIdParref")
	s ModelCode = result.Data("ModelCode")
	s Text = result.Data("Text")
	s Leaf = result.Data("Leaf")
	s IconCls = result.Data("IconCls")
	s Sort = "1"
	;result.Data("Sort")
	s URL = result.Data("URL")
	s Status = result.Data("Status")
	s Node = result.Data("Node")
	s ReportUrl = result.Data("ReportUrl")
	s tmp=ModelCode_"^"_ModelRowIdParref_"^"_Text_"^"_Leaf_"^"_IconCls_"^"_Sort_"^"_URL_"^"_Node_"^true"_"^"_ReportUrl
	s count = count+1
	i (count>Start)&(count<=end) d
	.d json.InsertRowData(tmp)
	}
	d result.Close()
	s resultString = json.getJsonData("id^parentid^text^leaf^cls^number^url^node^authority^ReportUrl",count)
	k json
	q resultString
}

ClassMethod GetMainMenuTreelList(UserId As %Integer, GroupType As %Integer, Type As %Integer) As %String
{
	;w Type
	if (Type '= 0)
	{
		d ..List(0,100,Type,UserId,3)
		q ""
	}
	
	s result = ##class(%Library.ResultSet).%New()

	
	s sqlStr = "SELECT * from CHSS.PubModelList"
	s sqlStr = sqlStr_" where Leaf = 'false' and Status = 'true' "
	s sqlStr = sqlStr_" and ModelRowIdParref is null "
	s sqlStr = sqlStr_" and ModelRowId in  (select a.ModelRowId from CHSS.PubModelList a"
    s sqlStr = sqlStr_" left join CHSS.CHSSResource b on a.ModelRowId = b.ModelRowId"
    s sqlStr = sqlStr_" left join CHSS.CHSSResourceVsGroup c on c.ResRowId = b.ResRowId"
    s sqlStr = sqlStr_" left join CHSS.CHSSUserVsResource d on d.GroupRowId = c.GroupRowId"
    s sqlStr = sqlStr_" left join CHSS.CHSSResourceGroup e on e.GroupRowId = c.GroupRowId"
    ;s sqlStr = sqlStr_" where  e.GroupType = "_GroupType_" ) order by Sort"
    s sqlStr = sqlStr_" where  e.GroupType = "_GroupType
    s sqlStr = sqlStr_"  and d.UserRowId in (select  SSUSR_Group from SQLUser.SS_User where SSUSR_RowId= "_UserId_" ) ) order by Sort"
	
	;s sqlStr = "SELECT * from CHSS.PubModelList"
	;s sqlStr = sqlStr_" where Leaf = 'false' "
	
	;w sqlStr,!
	d result.Prepare(sqlStr)
	d result.Execute()
	s Start = 0
	s Limit = 100
	s count = 0
	s resultString = ""
	s end = Start+Limit
	
	s json = ##class(Code.JsonObj).%New()
	While(result.Next())
	{
	s ModelRowId = result.Data("ModelRowId")
	
	s ModelRowIdParref = "1" ;result.Data("ModelRowIdParref")
	s ModelCode = result.Data("ModelCode")
	s Text = result.Data("Text")
	s Leaf = result.Data("Leaf")
	s IconCls = ""
	//result.Data("IconCls")
	s Sort = "1"
	;result.Data("Sort")
	s URL = result.Data("URL")
	s Status = result.Data("Status")
	s Node = result.Data("Node")
	s ReportUrl = result.Data("ReportUrl")
	s tmp=ModelCode_"^"_ModelRowIdParref_"^"_Text_"^"_Leaf_"^"_IconCls_"^"_Sort_"^"_URL_"^"_Node_"^true"_"^"_ReportUrl
	s count = count+1
	i (count>Start)&(count<=end) d
	.d json.InsertRowData(tmp)
	}
	d result.Close()
	s resultString = json.getTreeJsonData("id^parentid^text^leaf^cls^number^url^node^authority^ReportUrl",count)
	k json
	q resultString
}

ClassMethod CheckAuthority(UserGroup As %Integer) As %String
{
}

Storage Default
{
<Data name="PubModelListServiceDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^CHSSWeb.PubModelListServiceD</DataLocation>
<DefaultData>PubModelListServiceDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSSWeb.PubModelListServiceD</IdLocation>
<IndexLocation>^CHSSWeb.PubModelListServiceI</IndexLocation>
<StreamLocation>^CHSSWeb.PubModelListServiceS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
