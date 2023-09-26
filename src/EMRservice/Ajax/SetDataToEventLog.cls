Class EMRservice.Ajax.SetDataToEventLog Extends %CSP.Page
{

ClassMethod OnPage() As %Status
{
	s ModelName = $Get(%request.Data("ModelName",1),"")
	s ConditionAndContent = $Get(%request.Data("ConditionAndContent",1),"")
	s SecCode = $Get(%request.Data("SecCode",1),"")
	
	d ..SetDataToEventLog(ModelName,ConditionAndContent,SecCode)
	Quit $$$OK
}

/// d ##Class(EMRservice.Ajax.SetDataToEventLog).GetInPatListJSON(ModelName,Condition,Content,SecCode)
ClassMethod SetDataToEventLog(ModelName As %String, ConditionAndContent As %String, SecCode As %String)
{
	//s ^tempncc("0") = ModelName_"#"_ConditionAndContent_"#"_SecCode
	/*
	s Condition = ""
	s Content = ""
	
	s Condition = Condition_"{""patientID"":"""_$p(ConditionAndContent,"^",1)_""","
	s Condition = Condition_"""episodeID"":"""_$p(ConditionAndContent,"^",2)_""","
	s Condition = Condition_"""userName"":"""_$p(ConditionAndContent,"^",3)_""","
	s Condition = Condition_"""paramID"":"""_$p(ConditionAndContent,"^",4)_""","
	s Condition = Condition_"""paramPluginType"":"""_$p(ConditionAndContent,"^",5)_""","
	s Condition = Condition_"""paramChartItemType"":"""_$p(ConditionAndContent,"^",6)_""","
	s Condition = Condition_"""paramEmrDocId"":"""_$p(ConditionAndContent,"^",7)_""","
	s Condition = Condition_"""paramTemplateId"":"""_$p(ConditionAndContent,"^",8)_""","
	s Condition = Condition_"""paramCategoryId"":"""_$p(ConditionAndContent,"^",9)_""","
	s Condition = Condition_"""paramText"":"""_$p(ConditionAndContent,"^",10)_"""}"
	
	s Content = Condition
	*/
	s Systemdatetime = $HOROLOG
	s Systemdateint = $p(Systemdatetime,",",1)
	s Systemtimeint = $p(Systemdatetime,",",2)
	s actionDate = $zd(Systemdateint,3)
	s actionTime = $zt(Systemtimeint,3)
	s Condition = $e(ConditionAndContent,1,$l(ConditionAndContent)-1)
	s Condition = Condition_","
	s Condition = Condition_"""actionDate"":"""_actionDate_""","
	s Condition = Condition_"""actionTime"":"""_actionTime_"""}"
	
	s Content = Condition
	
	s ConditionsStream = ##class(%GlobalBinaryStream).%New()
	d ConditionsStream.Write(ConditionAndContent)
	s JsonObj = ##Class(EMRservice.Parser.Json).%New()
	s ConditionsJson = JsonObj.Deserialize(ConditionsStream)
	s ipAddress = ConditionsJson.GetAt("ipAddress")
	s userID = ConditionsJson.GetAt("userID")
    
	//s ^tempncc("1") = ModelName_"#"_Condition_"#"_Content_"#"_SecCode_"#"_ipAddress
	d ##Class(web.DHCEventLog).EventLog(ModelName,Condition,Content,SecCode,"Y",userID,ipAddress)
}

}
