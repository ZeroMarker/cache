Class DHCEPRFS.web.eprajax.FilterQueryItem Extends %CSP.Page [ ClassType = "", ProcedureBlock ]
{

ClassMethod OnPage() As %Status
{
	s action = $Get(%request.Data("Action",1),"-1")
	s groupID = $Get(%request.Data("GroupID",1),"-1")
	s filterWord = $Get(%request.Data("FilterWord",1),"-1")
	s alreadyChecked = $Get(%request.Data("AlreadyChecked",1),"-1")
	
	if (action = "group")
	{
		d ..GetGroup()
	}
	elseif (action = "detail")
	{
		d ..GetFilterQueryItem(groupID,filterWord,alreadyChecked)
	}
	
	Quit $$$OK
}

ClassMethod GetGroup() As %String
{
	s itemGroupID = ""
	s count = 0
	s ret = ""
	for {
		s itemGroupID = $O(^DHCEPRFS.META.FilterQueryItemI("IdxItemGroupID", itemGroupID))
		q:(itemGroupID = "")
		s rowID = $O(^DHCEPRFS.META.FilterQueryItemI("IdxItemGroupID", itemGroupID,""))
		continue:(rowID = "")
		s obj = ##class(DHCEPRFS.META.FilterQueryItem).%OpenId(rowID)

		s count = count + 1
		if (count=1)
		{
			s ret = obj.ItemGroupID_"^"_obj.ItemGroupName_"^"_obj.ItemGroupDesc
		}
		else
		{
			s ret = ret_"|"_obj.ItemGroupID_"^"_obj.ItemGroupName_"^"_obj.ItemGroupDesc
		}
	}
	w ret
}

/// d ##class(DHCEPRFS.web.eprajax.FilterQueryItem).GetFilterQueryItem("1","体","")
ClassMethod GetFilterQueryItem(AGroupID As %String, AFilterWord As %String, AAlreadyChecked As %String)
{
	q:(AGroupID = "") ""
	
	w "{""rows"":["
	
	s count = 0
		
		s rowID = ""
		for {
			s rowID = $O(^DHCEPRFS.META.FilterQueryItemI("IdxItemGroupID", " "_AGroupID,rowID))
			//b "s"
			q:(rowID = "")
			s obj = ##class(DHCEPRFS.META.FilterQueryItem).%OpenId(rowID)
			s OItemGroupID = obj.ItemGroupID
			s OItemGroupName = obj.ItemGroupName
			s OItemGroupDesc = obj.ItemGroupDesc
			s OItemID = obj.ItemID
			s OItemName = obj.ItemName
			s OItemAlias = obj.ItemAlias
			s count = count + 1
			if (count > 1) w ","
			w "{"
			w ..TrimEnter("""itemName"":"""_OItemName_""",")
			w ..TrimEnter("""itemID"":"""_OItemID_""",")
			w ..TrimEnter("""itemAlias"":"""_OItemAlias_""",")
			w ..TrimEnter("""group"":"""_OItemGroupName_""",")
			w ..TrimEnter("""groupDesc"":"""_OItemGroupDesc_""",")
			s flag = "false"
			for index=1:1:$l(AAlreadyChecked,"^")
			{
				if (OItemID = $p(AAlreadyChecked,"^",index))
				{
					s flag = "true"
					q	
				}
			}
			w ..TrimEnter("""alreadyChecked"":"""_flag_""",")
			
			if ((AFilterWord '= "") && ($f(OItemName,AFilterWord)>0))
			{
				w ..TrimEnter("""select"":""0"",")
			}
			else
			{
				w ..TrimEnter("""select"":""1"",") 	
			}
			w ..TrimEnter("""groupID"":"""_OItemGroupID_"""")
			w "}"
		}
	w "],""total"":"_count_"}"
}

ClassMethod TrimEnter(AInput As %String) As %String
{
	s ret = $TR(AInput,$C(13),"")
	s ret = $TR(ret,$C(10),"")
	q ret
}

/// d ##class(DHCEPRFS.web.eprajax.FilterQueryItem).InsertFilterQueryItem()
ClassMethod InsertFilterQueryItem()
{
	d ..InsertMRItem()
	d ..InsertLoc("adm")
	d ..InsertLoc("dis")
}

ClassMethod InsertMRItem()
{
	s code = ""
	for {
		s code = $O(^DHCEPRFS.META.MRItemI("IdxMain", code))
		q:(code="")
		s rowID = ""
		for {
			s rowID = $O(^DHCEPRFS.META.MRItemI("IdxMain", code,rowID))
			q:(rowID="")
			s obj = ##class(DHCEPRFS.META.MRItem).%OpenId(rowID)

			s objFQ = ##class(DHCEPRFS.META.FilterQueryItem).%New()
			s objFQ.ItemGroupID = "1"
			s objFQ.ItemGroupName = "MRItemID"
			s objFQ.ItemGroupDesc = "分类"
			s objFQ.ItemID = rowID
			s objFQ.ItemName = obj.Name
			
			s status = objFQ.%Save()
			w !,obj.Name
		}
	}
}

ClassMethod InsertLoc(AType As %String)
{
	s rset = ##Class(%XML.DataSet).%New("DHCEPRFS.BL.HISInfo.BLDictionaryInfo:CTLoc")
	s sc = rset.Execute()
	
	while (rset.Next())
	{
		//rowid:%String,Code:%String,Desc:%String,Alias:%String
		s rowID = rset.Data("rowid")
		s code = rset.Data("Code")
		s desc = rset.Data("Desc")
		s alias = rset.Data("Alias")
		
		s objFQ = ##class(DHCEPRFS.META.FilterQueryItem).%New()
		if (AType = "adm")
		{
			s objFQ.ItemGroupID = "2"
			s objFQ.ItemGroupName = "AdmLocID"
			s objFQ.ItemGroupDesc = "入院科室"
		}
		else
		{
			s objFQ.ItemGroupID = "3"
			s objFQ.ItemGroupName = "DisLocID"
			s objFQ.ItemGroupDesc = "出院科室"			
		}
		s objFQ.ItemID = rowID
		s objFQ.ItemName = desc
		s objFQ.ItemAlias = alias
			
		s status = objFQ.%Save()
		w !,objFQ.ItemName
	}
}

}
