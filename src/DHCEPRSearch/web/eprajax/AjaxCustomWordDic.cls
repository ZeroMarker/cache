Class DHCEPRSearch.web.eprajax.AjaxCustomWordDic Extends %CSP.Page [ ClassType = "", ProcedureBlock ]
{

ClassMethod OnPage() As %Status
{
	s userID = $Get(%request.Data("UserID",1),"-1")
	s ssGroupID = $Get(%request.Data("SSGroupID",1),"-1")
	s ctLocID = $Get(%request.Data("CTLocID",1),"-1")
	s inputWord = $Get(%request.Data("Word",1),"-1")
	s action = $Get(%request.Data("Action",1),"-1")
	
	if (action="addword")
	{
		d ..AddWord(inputWord,userID,ssGroupID,ctLocID)
	}
	
	Quit $$$OK
}

/// d ##class(DHCEPRSearch.web.eprajax.AjaxCustomWordDic).AddWord("OR")
ClassMethod AddWord(AInputWord As %String, AUserID As %String, ASSGroupID As %String, ACTLocID As %String) As %String
{
	s ret = ""
	s count = $l(AInputWord)
	s wordStart = $e(AInputWord,1)
	s wordEnd = $e(AInputWord,count)
	if (wordStart = """")||(wordStart = "'")
	{
		if (wordEnd = """")||(wordEnd = "'")
		{
			s InputWord = $e(AInputWord,2,count-1)
		}
		else
		{
			s InputWord = $e(AInputWord,2,count)
		}
	}
	else
	{
		if (wordEnd = """")||(wordEnd = "'")
		{
			s InputWord = $e(AInputWord,1,count-1)
		}
		else
		{
			s InputWord = $e(AInputWord,1,count)
		}
	}
	s length = $l(InputWord," ")
	for index = 1:1:length
	{
		s word = $p(InputWord," ",index)
		s result = ..UpdateWord(word)
		if (result '="-1")
		{
			s obj = ##Class(DHCEPRSearch.INST.CustomWordDicLog).%New()
			s obj.Word = word
			s obj.CTLocID = ACTLocID
			s obj.SSGroupID = ASSGroupID
			s obj.UserID= AUserID
			s obj.CustomWordDicID = result
			s obj.DateInput = $p($h,",",1)
			s obj.TimeInput = $p($h,",",2)
			
			s status = obj.%Save()
			if ($$$ISOK(status))
			{
				if (ret = "")
				{
					s ret= "1"
				}
				else
				{
					s ret = ret_"1"
				} 
			}
			else
			{
				if (ret = "")
				{
					s ret= "0"
				}
				else
				{
					s ret = ret_"0"
				}
			}
		}
		else
		{
			if (ret = "")
				{
					s ret= "0"
				}
				else
				{
					s ret = ret_"0"
				}
		}	
	}
	q ret
}

/// Debug:d ##class(DHCEPRSearch.web.eprajax.AjaxCustomWordDic).UpdateWord("OR")
ClassMethod UpdateWord(AInputWord As %String) As %String
{
	s result = "-1"
	s rowID = ""
	s rowID = $o(^DHCEPRSearch.META.CtmWordDicI("IdxWord"," "_AInputWord,rowID))
    if (rowID = "")
    {
	    s obj = ##Class(DHCEPRSearch.META.CustomWordDic).%New()
	    s obj.Word = AInputWord
	    s obj.IsAvailable = "Y"
	    s obj.DateInput = $p($h,",",1)
	    s obj.TimeInput = $p($h,",",2)
	    s obj.DateUpdate = $p($h,",",1)
	    s obj.TimeUpdate = $p($h,",",2)
	    s obj.WordFrequency = 1
	    	
	    s status = obj.%Save()
	    if ($$$ISOK(status))
	    {
		    s result = obj.%Id()
	    }
  	}
  	else
  	{
	  	s obj = ##Class(DHCEPRSearch.META.CustomWordDic).%OpenId(rowID)
	  	s obj.WordFrequency = obj.WordFrequency+1
	  	s obj.DateUpdate = $p($h,",",1)
	    s obj.TimeUpdate = $p($h,",",2)
	    	
	    s status = obj.%Save()
	    if ($$$ISOK(status))
	    {
		    s result = obj.%Id()
	    }
  	}
  	q result
}

}
