Class DHCEPRSearch.web.eprajax.AjaxFilterQueryItem Extends %CSP.Page [ ClassType = "", ProcedureBlock ]
{

ClassMethod OnPage() As %Status
{
	s action = $Get(%request.Data("Action",1),"-1")
	s groupID = $Get(%request.Data("GroupID",1),"-1")
	s filterWord = $Get(%request.Data("FilterWord",1),"-1")
	s alreadyChecked = $Get(%request.Data("AlreadyChecked",1),"-1")
	s fqCategoryID = $Get(%request.Data("FQCategoryID",1),"-1")
	s hosareaID = $G(%request.Data("HospID",1),"-1")
	if (action = "group")
	{
		d ..GetGroup()
	}
	elseif (action = "detail")
	{
		d ..GetFilterQueryItem(groupID,filterWord,alreadyChecked)
	}
	elseif (action = "tree")
	{
		d ..GetAllTreeNode(fqCategoryID)
	}
	elseif (action="treebyhosp")
	{
		d ..GetAllTreeNodeByHos(fqCategoryID,hosareaID)
	}
	
	Quit $$$OK
}

/// Debug: d ##class(DHCEPRSearch.web.eprajax.AjaxFilterQueryItem).GetGroup()
ClassMethod GetGroup() As %String
{
	s sequence = ""
	s count = 0
	s ret = ""
	for {
		s sequence =  $o(^DHCEPRSearch.META.FQCategoryI("IdxSequence",sequence))
		q:(sequence="")
		s rowID = ""
		for {
			s rowID = $o(^DHCEPRSearch.META.FQCategoryI("IdxSequence",sequence,rowID))
			q:(rowID="")
			s obj = ##class(DHCEPRSearch.META.FQCategory).%OpenId(rowID)
			
			s count = count +1
			if (count = 1)
			{
				s ret = rowID_"^"_obj.Name_"^"_obj.Description
			}
			else
			{
				s ret = ret_"|"_rowID_"^"_obj.Name_"^"_obj.Description
			}
		}
	}
	w ret
	
	/*
	for {
		s itemGroupID = $O(^DHCEPRSearh.FilterQueryI("IdxItemGroupID", itemGroupID))
		q:(itemGroupID = "")
		s rowID = $O(^DHCEPRSearh.FilterQueryI("IdxItemGroupID", itemGroupID,""))
		continue:(rowID = "")
		s obj = ##class(DHCEPRSearch.META.FilterQueryItem).%OpenId(rowID)

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
	*/
}

/// Debug: d ##class(DHCEPRSearch.web.eprajax.AjaxFilterQueryItem).GetFilterQueryItem("1","体","")
ClassMethod GetFilterQueryItem(AGroupID As %String, AFilterWord As %String, AAlreadyChecked As %String)
{
	q:(AGroupID = "") ""
	
	w "{""rows"":["
	
	s count = 0
		
		s rowID = ""
		for {
			s rowID = $O(^DHCEPRSearch.META.FilterQueryI("IdxItemGroupID", " "_AGroupID,rowID))
			//b "s"
			q:(rowID = "")
			s obj = ##class(DHCEPRSearch.META.FilterQueryItem).%OpenId(rowID)
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

/// Debug: d ##class(DHCEPRSearch.web.eprajax.AjaxFilterQueryItem).GetAllTreeNode("1")
ClassMethod GetAllTreeNode(AFQCategoryID As %String) As %String
{
	w "["
	s countSub = 0
	s subsequence = ""
	for {
		s subsequence = $o(^DHCEPRSearch.META.FQSubCateI("IdxSequence"," "_AFQCategoryID,subsequence))
		q:(subsequence="")
		s rowIDSub = ""
		for {
			s rowIDSub = $o(^DHCEPRSearch.META.FQSubCateI("IdxSequence"," "_AFQCategoryID,subsequence,rowIDSub))
			q:(rowIDSub="")
			s objSub = ##class(DHCEPRSearch.META.FQSubCategory).%OpenId(rowIDSub)
			s countSub =  countSub +1
			if (countSub>1) w ","
			w "{"
			w ..TrimEnter("""id"":"""_"SG_"_rowIDSub_""",")
			w ..TrimEnter("""text"":"""_objSub.Description_""",")
			w ..TrimEnter("""state"":""open"",")
			w """children"":["
			
			s countItem = 0
			s sequence = ""
			for {
				s sequence = $o(^DHCEPRSearch.META.FilterQueryI("IdxSequence"," "_rowIDSub,sequence))
				q:(sequence = "")
				s rowIDItem =""
				for {
					s rowIDItem = $o(^DHCEPRSearch.META.FilterQueryI("IdxSequence"," "_rowIDSub,sequence,rowIDItem))
					q:(rowIDItem ="")
					s objItem = ##class(DHCEPRSearch.META.FilterQueryItem).%OpenId(rowIDItem)
					
					s countItem = countItem +1
					if (countItem>1) w ","
					w "{"
					w ..TrimEnter("""id"":"""_objItem.ItemID_""",")
					w ..TrimEnter("""attributes"":{""groupName"":"""_objItem.ItemGroupName_"""},")
					//w """attributes"":{""GroupName"":"""_objItem.ItemGroupName_"""},"
					w ..TrimEnter("""text"":"""_objItem.ItemName_"""")
					w "}"
					
				}
			}			
			w "]}"
		}
	}
	w "]"
}

/// Debug: d ##class(DHCEPRSearch.web.eprajax.AjaxFilterQueryItem).GetAllTreeNodeByHos("1","2")
ClassMethod GetAllTreeNodeByHos(AFQCategoryID As %String, HosAreaID As %String) As %String
{
	w "["
	s countSub = 0
	s subsequence = ""
	for {
		s subsequence = $o(^DHCEPRSearch.META.FQSubCateI("IdxSequence"," "_AFQCategoryID,subsequence))
		q:(subsequence="")
		s rowIDSub = ""
		for {
			s rowIDSub = $o(^DHCEPRSearch.META.FQSubCateI("IdxSequence"," "_AFQCategoryID,subsequence,rowIDSub))
			q:(rowIDSub="")
			s objSub = ##class(DHCEPRSearch.META.FQSubCategory).%OpenId(rowIDSub)
			s countSub =  countSub +1
			if (countSub>1) w ","
			w "{"
			w ..TrimEnter("""id"":"""_"SG_"_rowIDSub_""",")
			w ..TrimEnter("""text"":"""_objSub.Description_""",")
			w ..TrimEnter("""state"":""open"",")
			w """children"":["
			
			s countItem = 0
			s sequence = ""
			for {
				s sequence = $o(^DHCEPRSearch.META.FilterQueryI("IdxSequence"," "_rowIDSub,sequence))
				q:(sequence = "")
				s rowIDItem =""
				for {
					s rowIDItem = $o(^DHCEPRSearch.META.FilterQueryI("IdxSequence"," "_rowIDSub,sequence,rowIDItem))
					q:(rowIDItem ="")
					s objItem = ##class(DHCEPRSearch.META.FilterQueryItem).%OpenId(rowIDItem)
					continue:(objItem="")
					continue:($G(^CTLOC(objItem.ItemID))="")
					q:($P(^CTLOC(objItem.ItemID),"^",22)'=HosAreaID)
					s countItem = countItem +1
					if (countItem>1) w ","
					w "{"
					w ..TrimEnter("""id"":"""_objItem.ItemID_""",")
					w ..TrimEnter("""attributes"":{""groupName"":"""_objItem.ItemGroupName_"""},")
					//w """attributes"":{""GroupName"":"""_objItem.ItemGroupName_"""},"
					w ..TrimEnter("""text"":"""_objItem.ItemName_"""")
					w "}"
					
				}
			}			
			w "]}"
		}
	}
	w "]"
}

}
