Class EMRservice.Ajax.Repository Extends %CSP.Page
{

ClassMethod OnPage() As %Status
{
	s action = $g(%request.Data("Action",1),"")
	s userID = $g(%request.Data("userID",1),"")	
	s userLocID = $g(%request.Data("userLocID",1),"")
	If (action="GetLocList")
	{
		d ..GetLocList()
	}
	ElseIf (action="GetCateList"){
		w ..GetAllCateList("0")
	}
	ElseIf (action="GetkbNodeList")
	{
		w ..GetkbNodeList(userID)
	}
	ElseIf (action="GetiBookList")
	{
		w ..GetiBookList(userLocID)
	}
	
	Quit $$$OK
}

/// d ##class(EMRservice.Ajax.Repository).GetLocList()
ClassMethod GetLocList() As %String
{
	s currjson = ""
	s json = ##class(%GlobalCharacterStream).%New()
	d json.Write("[")
	s count = 0
	s ds = ##Class(%Library.ResultSet).%New("EMRservice.BL.BLEMROrganSchemeLoc:SelectAllLocRowId")
	d ds.Execute()
	While (ds.Next())
	{
	    d:(count '= 0) json.Write(",")
		s currjson = "{"
		s currjson = currjson_"""id"":"""_ds.Data("Code")_""","
		s currjson = currjson_"""text"":"""_ds.Data("Des")_""","
		//s currjson = currjson_"""checked"":true,"
		s currjson = currjson_"""attributes"":{""index"":"_count_"}"	
		s currjson = currjson_"}"
		d json.Write(currjson)
		s count = count + 1
	}
	d json.Write("]")
	while (json.AtEnd = 0)
	{
		w $ZSTRIP(json.Read(32000),"*C")
	}
}

ClassMethod GetkbNodeList(AUserID) As %String
{
	q ""
}

/// w ##class(EMRservice.Ajax.Repository).GetAllCateList("0")
ClassMethod GetAllCateList(AParentID) As %String
{
	s:(AParentID = "") AParentID = "0"
	s json = ""
	s CategoryID = ""
	s count = 0
	for
	{
		s CategoryID = $o(^DHCEMRM.iBookCategoryI("IdxParentID", " "_AParentID,CategoryID))
		q:(CategoryID = "")
		s CategoryOBJ = ##class(EMRmeta.Repository.iBookCategory).%OpenId(CategoryID)
		q:(CategoryOBJ = "")
		
		s childrenjson = ""
		s:(AParentID = "0") childrenjson = ..GetAllCateList(CategoryID)
		if (childrenjson '= "[]")
		{
			s:(json'="") json = json_","
			s json = json_"{""id"":"_"""CG"_CategoryID_""""
			s json = json_",""text"":"_""""_CategoryOBJ.Description_""""
			s json = json_",""attributes"":{""index"":"_count_"}"
			s:(childrenjson '= "") json = json_",""children"":"_childrenjson
			s json = json_"}"
			s count = count+1
		}
	}
	q "["_json_"]"
}

/// w ##class(EMRservice.Ajax.Repository).GetiBookList("6")
ClassMethod GetiBookList(AUserLocID) As %String
{
	q:(AUserLocID = "") ""
	s json = ""
	s RestrictionID = ""
	for
	{
		s RestrictionID = $o(^DHCEMRM.iBookRestrictionI("IdxRuleID"," 0", RestrictionID))
		q:(RestrictionID = "")
		s RestrictionOBJ = ##class(EMRmeta.Repository.iBookRestriction).%OpenId(RestrictionID)
		s CategoryID = RestrictionOBJ.iBookCategoryID
		s CategoryOBJ = ##class(EMRmeta.Repository.iBookCategory).%OpenId(CategoryID)
		s iBookID = ""
		for
		{
			s iBookID = $o(^DHCEMRM.iBookI("IdxCategoryID"," "_CategoryID, iBookID))
			q:(iBookID="")
			s iBookOBJ = ##class(EMRmeta.Repository.iBook).%OpenId(iBookID)
			s:(json '= "") json = json_","
			s json = json_"{""id"":""IB"_iBookID_""""
			s json = json_",""text"":"""_iBookOBJ.Name_"""}"
		}
	}
	for
	{
		s RestrictionID = $o(^DHCEMRM.iBookRestrictionI("IdxRuleID"," "_AUserLocID, RestrictionID))
		q:(RestrictionID = "")
		s RestrictionOBJ = ##class(EMRmeta.Repository.iBookRestriction).%OpenId(RestrictionID)
		s CategoryID = RestrictionOBJ.iBookCategoryID
		s CategoryOBJ = ##class(EMRmeta.Repository.iBookCategory).%OpenId(CategoryID)
		s iBookID = ""
		for
		{
			s iBookID = $o(^DHCEMRM.iBookI("IdxCategoryID"," "_CategoryID, iBookID))
			q:(iBookID="")
			s iBookOBJ = ##class(EMRmeta.Repository.iBook).%OpenId(iBookID)
			s:(json '= "") json = json_","
			s json = json_"{""id"":""IB"_iBookID_""""
			s json = json_",""text"":"""_iBookOBJ.Name_"""}"
		}
	}
	q "["_json_"]"
}

}
