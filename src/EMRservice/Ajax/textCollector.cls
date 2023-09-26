Class EMRservice.Ajax.textCollector Extends %CSP.Page
{

ClassMethod OnPage() As %Status
{
	s errInfo=""
	s $zt = "ErrorHandler"	
	
	s action = $Get(%request.Data("action",1),"")
 
	if (action = "GetTextByUsrID") 
	{	
		s usrID = $Get(%request.Data("usrID",1),"")
		s ret=..GetTextByUsrID(usrID)
		//s ret = "{""total"":""2"",""rows"":[{""id"":""1"",""category"":""1分类"",""summary"":""1摘要""},{""id"":""3"",""category"":""3分类"",""summary"":""2摘要""}]}"
		//s ^CacheTemp("textCollector")=ret	
		w ret
	}
	elseif (action = "getContent")
	{
		s rowID = $Get(%request.Data("rowID",1),"")
		w ..getContent(rowID)
	}
	elseif (action = "DelTextCollect")
	{
		s rowID = $Get(%request.Data("rowID",1),"")
		s obj=##Class(EMRinstance.TextCollector).%OpenId(rowID)
		s result=obj.%DeleteId(rowID)
		w ""
	}	
	elseif (action = "SaveTextCollect")
	{
		s id = $Get(%request.Data("id",1),"")
		s diseaseID = $Get(%request.Data("diseaseID",1),"")
		s categoryID = $Get(%request.Data("categoryID",1),"")
		s chapterID = $Get(%request.Data("chapterID",1),"")
		s summary = $Get(%request.Data("summary",1),"")
		s content = $Get(%request.Data("content",1),"")
		s usrID = "CTLOC"   //$Get(%request.Data("usrID",1),"CTLOC")
		d ..SaveTextCollect(id, diseaseID, categoryID, chapterID, summary, content, usrID)
		w ""
	}
	elseif (action = "GetDiseaseCategoryForCombo")
	{
		s ctloc=$Get(%request.Data("ctloc",1),"")
		w ..GetDiseaseCategoryForCombo(ctloc)
	}
	elseif (action = "GetDiseaseForGrd")
	{
		s ctloc=$Get(%request.Data("ctloc",1),"")
		w ..GetDiseaseForGrd(ctloc)
	}	
	elseif (action = "GetChapterForGrd")
	{
		s usrID=$Get(%request.Data("usrID",1),"")
		s ctloc=$Get(%request.Data("ctloc",1),"")
		w ..GetChapterForGrd(usrID, ctloc)
	}
	elseif (action = "GetChapterForCombox")
	{
		s usrID=$Get(%request.Data("usrID",1),"")
		s ctloc=$Get(%request.Data("ctloc",1),"")
		w ..GetChapterForCombox(usrID, ctloc)
	}	
	elseif (action = "GetText")
	{
		s DiseaseID=$Get(%request.Data("DiseaseID",1),"")
		s CategoryID=$Get(%request.Data("CategoryID",1),"")
		s ChapterID=$Get(%request.Data("ChapterID",1),"")		
		s UsrID=$Get(%request.Data("UsrID",1),"")
		s:($C(0)=UsrID) UsrID="CTLOC"
		s ret = ..GetText(DiseaseID, CategoryID, ChapterID, UsrID)
		//s ^CacheTemp("GetText")=DiseaseID_", "_CategoryID_", "_ChapterID_", "_UsrID
		w ret
	}
	elseif (action = "GetCategoryForGrd")
	{
		s diseaseID=$Get(%request.Data("diseaseID",1),"")

		w ..GetCategoryForGrd(diseaseID)
	}
		 	
	q $$$OK	
ErrorHandler
	w "{""Err"":"""_errInfo_"_"_$zerror_"""}"
	Quit $$$OK
}

/// d ##Class(EMRservice.Ajax.textCollector).SaveTextCollect("",167, 339, 5, "缺牙","缺牙","CTLOC")
/// d ##Class(EMRservice.Ajax.textCollector).SaveTextCollect("3",167, 339, 5, "缺牙","缺1牙","CTLOC")
ClassMethod SaveTextCollect(id, diseaseID, categoryID, chapterID, summary, content, usrID As %String)
{
	
	s obj=""
	if (id="")  //new
	{
		s seq=$O(^DHCEMRM.FreqTxt.TextCollectorI("IdxChapterSeq"," "_chapterID," "_diseaseID," "_categoryID," "_usrID,""),-1)	
		if (""=seq) { s seq=1 }
		else { s seq=seq+1 }		
		s obj=##Class(EMRmeta.FrequentText.TextCollector).%New()
		s obj.Summary=summary
		s obj.Content=content
		s obj.DiseaseID=diseaseID
		s obj.ChapterID=chapterID
		s obj.CategoryID=categoryID
		s obj.UsrID=usrID
		s obj.Sequence=seq	
	}
	else
	{
		//s ^CacheTemp("txt")=id_"-"_summary_"-"_content
		s obj=##Class(EMRmeta.FrequentText.TextCollector).%OpenId(id)
		s obj.Summary=summary
		s obj.Content=content		
	}

 	d obj.%Save()
}

/// w ##Class(EMRservice.Ajax.textCollector).GetText(167,339,1,1)
ClassMethod GetText(DiseaseID, CategoryID, ChapterID, UsrID As %String) As %String
{
	s ret=""
	s count=0
	//^DHCEMRM.FreqTxt.TextCollectorI
	//Index IdxDiseaseSeq On (DiseaseID, ChapterID, Sequence);
	s seq=""
	for {
		s seq=$O(^DHCEMRM.FreqTxt.TextCollectorI("IdxDiseaseSeq", " "_DiseaseID, " "_CategoryID, " "_ChapterID, " CTLOC", seq))
		q:(""=seq)
		s id=$O(^DHCEMRM.FreqTxt.TextCollectorI("IdxDiseaseSeq", " "_DiseaseID, " "_CategoryID, " "_ChapterID, " CTLOC", seq, ""))	
		
		s txt=##Class(EMRmeta.FrequentText.TextCollector).%OpenId(id)
		s item = "{""id"":"""_txt.%Id()_""""
		s item = item_",""summary"":"""_txt.Summary_""""
		s item = item_",""usrID"":"""_txt.UsrID_"""}"
		if ("" = ret) { s ret = item }
		else { s ret = ret_","_item }
		s count=count+1
	}
	
	if (UsrID'="")
	{
		s seq=""
		for {
			s seq=$O(^DHCEMRM.FreqTxt.TextCollectorI("IdxDiseaseSeq", " "_DiseaseID, " "_ChapterID, " "_UsrID, seq))
			q:(""=seq)
			s id=$O(^DHCEMRM.FreqTxt.TextCollectorI("IdxDiseaseSeq", " "_DiseaseID, " "_ChapterID, " "_UsrID, seq, ""))	
			w "id:"_id,!
		
			s txt=##Class(EMRmeta.FrequentText.TextCollector).%OpenId(id)
			s item = "{""id"":"""_txt.%Id()_""",""summary"":"""_txt.Summary_"""}"
			if ("" = ret) { s ret = item}
			else { s ret = ret_","_item }
			s count=count+1
		}		
	}
	
	q "{""total"":"""_count_""",""rows"":["_ret_"]}"
}

/// w ##Class(EMRservice.Ajax.textCollector).GetChapterForCombox("", "1")
ClassMethod GetChapterForCombox(UsrID, CTLocID As %String) As %String
{
	s ret=""
	s count=0
	s cSeq=""
	for {		 
		s cSeq=$O(^DHCEMRM.FreqTxt.ChapterI("IdxCTLocIDSeq", " "_CTLocID, cSeq))
		q:(cSeq="")
		s cID=$O(^DHCEMRM.FreqTxt.ChapterI("IdxCTLocIDSeq", " "_CTLocID, cSeq, ""))
		continue:(cID="") 
 
		s Chapter=##Class(EMRmeta.FrequentText.Chapter).%OpenId(cID)
		s item = "{""value"":"""_Chapter.%Id()_""",""text"":"""_Chapter.Name_"""}"
		if ("" = ret) { s ret = item}
		else { s ret = ret_","_item }

	}	
	q "["_ret_"]"
}

/// w ##Class(EMRservice.Ajax.textCollector).GetChapterForGrd("", "191")
ClassMethod GetChapterForGrd(UsrID, CTLocID As %String) As %String
{
	s ret=""
	s total=0
	s cSeq=""
	for {		 
		s cSeq=$O(^DHCEMRM.FreqTxt.ChapterI("IdxCTLocIDSeq", " "_CTLocID, cSeq))
		q:(cSeq="")
		s cID=$O(^DHCEMRM.FreqTxt.ChapterI("IdxCTLocIDSeq", " "_CTLocID, cSeq, ""))
		continue:(cID="") 
 
		s Chapter=##Class(EMRmeta.FrequentText.Chapter).%OpenId(cID)
		s item = "{""id"":"""_Chapter.%Id()_""",""name"":"""_Chapter.Name_"""}"
		if ("" = ret) { s ret = item}
		else { s ret = ret_","_item }
		s total=total+1
	}	
	q "{""total"":"""_total_""",""rows"":["_ret_"]}"
}

ClassMethod GetDiseaseForGrd(CTLocID As %String) As %String
{
	s total=0
	s result = ""
	s item=""
	s dSeq=""
	for {		
		s dSeq=$O(^DHCEMRM.FreqTxt.DiseaseI("IdxCTLocIDSeq", " "_CTLocID, dSeq))
		q:(dSeq="")
	  
		s dID=$O(^DHCEMRM.FreqTxt.DiseaseI("IdxCTLocIDSeq", " "_CTLocID, dSeq, ""))
		continue:(dID="") 
	 
		s disease = ##Class(EMRmeta.FrequentText.Disease).%OpenId(dID)
		s dName = disease.Name
 		//d GetCategory(dID, dName)
 	 
 		if (""=item) { s item = "{""id"":"""_dID_""",""name"":"""_dName_"""}" }
	 	if (""=result) { s result = item }
		else { s result = result_","_item }
		s total=total+1
		s item=""
	}	
 
	q "{""total"":"""_total_""",""rows"":["_result_"]}"
	
GetCategory(dID, dName)
	s item=""
	s cSeq = ""
	for {
		s cSeq=$O(^DHCEMRM.FreqTxt.CategoryI("IdxDiseaseIDSeq", " "_dID, cSeq))
		q:(cSeq="")

		s cID=$O(^DHCEMRM.FreqTxt.CategoryI("IdxDiseaseIDSeq", " "_dID, cSeq, ""))
		s cate = ##Class(EMRmeta.FrequentText.Category).%OpenId(cID)
		s ret="{""value"":"""_dID_"^"_cID_""",""text"":"""_cate.Name_""",""group"":"""_dName_"""}"
		if (item="")
		{
			s item=ret
		}
		else
		{
			s item=item_","_ret
		}			
	}

	q item
}

/// w ##Class(EMRservice.Ajax.textCollector).GetCategoryForGrd(167)
ClassMethod GetCategoryForGrd(diseaseID As %String) As %String
{
	s total=0
	s ret=""
	s cSeq = ""
	for {
		s cSeq=$O(^DHCEMRM.FreqTxt.CategoryI("IdxDiseaseIDSeq", " "_diseaseID, cSeq))
		q:(cSeq="")

		s cID=$O(^DHCEMRM.FreqTxt.CategoryI("IdxDiseaseIDSeq", " "_diseaseID, cSeq, ""))
		s cate = ##Class(EMRmeta.FrequentText.Category).%OpenId(cID)
		s item="{""id"":"""_cID_""",""name"":"""_cate.Name_"""}"
		if (ret="")
		{
			s ret=item
		}
		else
		{
			s ret=ret_","_item
		}		
		s total=total+1	
	}

	q "{""total"":"""_total_""",""rows"":["_ret_"]}"
}

/// w ##Class(EMRservice.Ajax.textCollector).GetDiseaseCategoryForCombo("191")
ClassMethod GetDiseaseCategoryForCombo(CTLocID As %String) As %String
{
	s result = ""
	s item=""
	s dSeq=""
	for {		
		s dSeq=$O(^DHCEMRM.FreqTxt.DiseaseI("IdxCTLocIDSeq", " "_CTLocID, dSeq))
		q:(dSeq="")
	  
		s dID=$O(^DHCEMRM.FreqTxt.DiseaseI("IdxCTLocIDSeq", " "_CTLocID, dSeq, ""))
		continue:(dID="") 
	 
		s disease = ##Class(EMRmeta.FrequentText.Disease).%OpenId(dID)
		s dName = disease.Name
 		d GetCategory(dID, dName)
 	 
 		if (""=item) { s item = "{""value"":"""_dID_""",""text"":"""_dName_"""}" }
	 	if (""=result) { s result = item }
		else { s result = result_","_item }
		
		 
	}	
	q "["_result_"]"
	
GetCategory(dID, dName)
	s item=""
	s cSeq = ""
	for {
		s cSeq=$O(^DHCEMRM.FreqTxt.CategoryI("IdxDiseaseIDSeq", " "_dID, cSeq))
		q:(cSeq="")

		s cID=$O(^DHCEMRM.FreqTxt.CategoryI("IdxDiseaseIDSeq", " "_dID, cSeq, ""))
		s cate = ##Class(EMRmeta.FrequentText.Category).%OpenId(cID)
		s ret="{""value"":"""_dID_"^"_cID_""",""text"":"""_cate.Name_""",""group"":"""_dName_"""}"
		if (item="")
		{
			s item=ret
		}
		else
		{
			s item=item_","_ret
		}			
	}

	q item
}

/// w ##Class(EMRservice.Ajax.textCollector).GetTextByUsrID(2062)
ClassMethod GetTextByUsrID(usrID As %String) As %String
{
	s ret=""
	s rowID=""	
	s total=0
	for {
		s rowID=$O(^DHCEMRI.TextCollectorI("IdxUsrID"," "_usrID,rowID))
		q:(rowID="")
		
		//s ret={""id"":""1"",""category"":""1分类"",""summary"":""1摘要""}
		s obj=##Class(EMRinstance.TextCollector).%OpenId(rowID)
		s txt="{""id"":"""_obj.%Id()_""",""category"":"""_$tr(obj.category,"""","""""")_""",""summary"":"""_$tr(obj.summary,"""","""""")_"""}"
		if (ret="") { s ret=txt }
		else { s ret=ret_","_txt }
		s total=total+1
	}		
	 
	//s ret = "{""total"":""2"",""rows"":[{""id"":""1"",""category"":""1分类"",""summary"":""1摘要""},{""id"":""3"",""category"":""3分类"",""summary"":""2摘要""}]}"
	q "{""total"":"""_total_""",""rows"":["_ret_"]}"
}

ClassMethod getContent(rowID As %String) As %String
{
	s obj=##Class(EMRmeta.FrequentText.TextCollector).%OpenId(rowID)
	q:(obj="") ""
	
	q obj.Content
}

}
