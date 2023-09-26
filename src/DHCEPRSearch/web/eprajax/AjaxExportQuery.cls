Class DHCEPRSearch.web.eprajax.AjaxExportQuery Extends %CSP.Page [ ClassType = "", ProcedureBlock ]
{

ClassMethod OnPage() As %Status
{
	s userID = $Get(%request.Data("UserID",1),"-1")
	s action = $Get(%request.Data("Action",1),"-1")
	s exportID = $Get(%request.Data("ExportID",1),"-1")
	
	if (action="detail")
	{
		d ..DisplayDetail(exportID)
	}
	elseif (action = "update")
	{
		d ..Update(userID, exportID)	
	}
	elseif (action = "getmrepisodeids")
	{
		d ..GetMREpisodeIDS(userID)	
	}
	elseif (action = "remove")
	{
		d ..Remove(userID)	
	}
	else
	{
		d ..Display(userID)
	}
	
	Quit $$$OK
}

/// debug: w ##class(DHCEPRSearch.web.eprajax.AjaxExportQuery).Display(3)
ClassMethod Display(AUserID As %String) As %String
{
	w "{""rows"":["
	
	s count = 0
		
	s rowID = ""
	for {
		s rowID = $O(^DHCEPRSearch.INST.ExportQueryI("IdxUserID", " "_AUserID,rowID))
		q:(rowID = "")
		s obj = ##class(DHCEPRSearch.INST.ExportQuery).%OpenId(rowID)
		s exportDate = obj.ExportDate
		s exportTime = obj.ExportTime
		s disLocID = obj.DisLocID
		s disLocName = $P($g(^CTLOC(disLocID)),"^",1)
		s startDisDate = obj.StartDisDate
		s endDisDate = obj.EndDisDate
		
		s count = count + 1
		if (count > 1) w ","
		w "{"
		w ..TrimEnter("""exportID"":"""_rowID_""",")
		w ..TrimEnter("""exportDateTime"":"""_$zd(exportDate,3)_" "_$zt(exportTime,3)_""",")
		w ..TrimEnter("""disLocName"":"""_disLocName_""",")
		w ..TrimEnter("""startDisDate"":"""_$zd(startDisDate,3)_""",")
		w ..TrimEnter("""endDisDate"":"""_$zd(endDisDate,3)_"""")
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

/// debug: d ##class(DHCEPRSearch.web.eprajax.AjaxExportQuery).DisplayDetail(2)
ClassMethod DisplayDetail(AExportID As %String) As %String
{
	w "{""rows"":["
	
	s obj = ##class(DHCEPRSearch.INST.ExportQuery).%OpenId(AExportID)
	s xml = obj.ResultXMLStream
	s columns = obj.ResultColumns
	s columnsName = obj.ResultColumnsName
	s length = $l(columns,",")
	
	s sc = ##class(%XML.TextReader).ParseStream(xml,.reader)
	s rowCount = 0
	s columnCount = 0
	if ($$$ISOK(sc)) {
        while (reader.Read()) {
            if (reader.NodeType = "element") {
	            if (reader.Name = "ComplexQueryList")
	            {
		        	s rowCount = rowCount + 1  
		        	s columnCount = 0 
		        	if (rowCount > 1)
		        	{
			        	w ","	
			        }
		        }
		        elseif (reader.Name = "DefaultDataSet")
		        {
			    	continue    
			    }
			    else
			    {
				    s columnCount = columnCount + 1
				    if (columnCount = 1)
				    {
						w "{"    
					} 
					
					w """"_reader.Name_""":""" 
	            	//w !,reader.Name
			    }
            }
            elseif (reader.NodeType = "chars") {
	             if (columnCount = (length + 1))
	             {
		           	w reader.Value_"""" 
		         	w "}"	
	             }
	             else
	             {
   					w reader.Value_""","
		         }
	        	 //w !,reader.Value    
	        }
        }
    }
	w "],""total"":"_rowCount_"}"
}

ClassMethod Update(AUserID As %String, AExportID As %String) As %String
{
	//将之前的标记清空
	&sql(update DHCEPRSearch_INST.ExportQuery set Used = '' where UserID = :AUserID)
	//标记为当前导入过滤
	s obj = ##class(DHCEPRSearch.INST.ExportQuery).%OpenId(AExportID)
	s obj.Used = "Y"
	s status = obj.%Save()
	if ($$$ISOK(status))
	{
		w obj.%Id()
	}
	else
	{
		w ""
	}
}

/// debug: d ##class(DHCEPRSearch.web.eprajax.AjaxExportQuery).GetMREpisodeIDS(34)
ClassMethod GetMREpisodeIDS(AUserID As %String) As %String
{
	s rowID = ""
	s rowID = $o(^DHCEPRSearch.INST.ExportQueryI("IdxUserIDAndUsed"," "_AUserID," Y",rowID))
	q:(rowID = "") ""
	
	s obj = ##class(DHCEPRSearch.INST.ExportQuery).%OpenId(rowID)
	q:(obj = "") ""
	s MREpisodeIDS = obj.MREpisodeIDS
	
	s length = $l(MREpisodeIDS,"^")
	for index=1:1:length
	{
		if (index>1)
		{
			w " || "	
		}
		w "MREpisodeID:"_$p(MREpisodeIDS,"^",index)		
	}
}

ClassMethod Remove(AUserID As %String) As %String
{
	//将之前的标记清空
	&sql(update DHCEPRSearch_INST.ExportQuery set Used = '' where UserID = :AUserID)
	w "1"
}

}
