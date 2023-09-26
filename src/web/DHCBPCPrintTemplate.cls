/// 血透打印模板业务类
Class web.DHCBPCPrintTemplate Extends (%RegisteredObject, %CSP.Page)
{

ClassMethod OnPage() As %Status
{
	s action = $g(%request.Data("Action", 1), "")
	
	if (action="SavePrintTemplate")
	{
		s RowId=$g(%request.Data("RowId", 1), "")
		s DataModule=$g(%request.Data("DataModule", 1), "")
		s JSONData=$g(%request.Data("JSONData", 1), "")
		s UpdateUser=$g(%request.Data("UpdateUser", 1), "")
		s result=..SavePrintTemplate(RowId, DataModule, JSONData, UpdateUser)
		w result
	}
	elseif (action="SaveJScriptData")
	{
		s RowId=$g(%request.Data("RowId", 1), "")
		s JScriptData=$g(%request.Data("JScriptData", 1), "")
		s result=..SaveJScriptData(RowId, JScriptData)
		w result
	}
	else 
	{
		w "无参数"
	}
	Quit $$$OK
}

/// Creator：      	陈长青
/// CreatDate：    	2020-1-13
/// Description： 	获取打印模板
/// Table：        	DHC_BPC_PrintTemplate
/// Input:			moduleId:模块ID
/// Return：       	打印模板JSON字符串
/// Debug:			w ##class(web.DHCBPCPrintTemplate).GetPrintTemplate(1)
ClassMethod GetPrintTemplate(moduleId As %String) As %String
{
	quit:'##class(User.DHCBPCModule).%ExistsId(moduleId) "E^模块ID错误"
	set templateId=""
	set splitChar=$char(2)
	&sql(select TOP 1 RowId into :templateId from SQLUser.DHC_BPC_PrintTemplate where DataModule=:moduleId order by RowId Desc)
	quit:templateId="" ""
	set template=##class(User.DHCBPCPrintTemplate).%OpenId(templateId)
	quit templateId_splitChar_template.JSONData
}

/// Creator：      	李杰
/// CreatDate：    	2022年3月28日
/// Description： 	获取模板JS脚本数据
/// Table：        	User.DHCBPCPrintTemplate
/// Input:			moduleId:模块ID
/// Return：       	打印模板JS脚本
/// Debug:			w ##class(web.DHCBPCPrintTemplate).GetJScriptData("103")
ClassMethod GetJScriptData(moduleId As %String) As %String
{
	quit:'##class(User.DHCBPCModule).%ExistsId(moduleId) "E^模块ID错误"
	set templateId=""
	&sql(select TOP 1 RowId into :templateId from SQLUser.DHC_BPC_PrintTemplate where DataModule=:moduleId order by RowId Desc)
	quit:templateId="" $SYSTEM.Encryption.Base64Encode("function OnLoaded(){}")
	set template=##class(User.DHCBPCPrintTemplate).%OpenId(templateId)
	set jsData=template.JScriptData.Read(100000)
	quit:jsData="" $SYSTEM.Encryption.Base64Encode("function OnLoaded(){}")
	quit jsData
}

/// Creator：      	李杰
/// CreatDate：    	2020年6月11日
/// Description： 	保存打印模板
/// Table：        	DHC_BPC_PrintTemplate
/// Input:			moduleId:模块ID,sheetDataStr:模板json字符串
/// Return：       	保存结果
/// Debug:			
ClassMethod SavePrintTemplate(templateId, moduleId, sheetDataStr, updateUser) As %String
{
	set jsonStr=##class(web.DHCBPCPrintTemplate).GetSheetDataStr(sheetDataStr)
	quit:'##class(User.DHCBPCModule).%ExistsId(moduleId) "E^模块ID错误"
	
	set obj=##class(User.DHCBPCPrintTemplate).%New()
	if (##class(User.DHCBPCPrintTemplate).%ExistsId(templateId))
	{
		set obj=##class(User.DHCBPCPrintTemplate).%OpenId(templateId)
	}
	set obj.DataModule=##class(User.DHCBPCModule).%OpenId(moduleId)
	set obj.JSONData=jsonStr
	set obj.UpdateUser=updateUser
	set obj.UpdateDate=+$h
	set obj.UpdateTime=$piece($h,",",2)
	set status=obj.%Save()
	quit:('$System.Status.IsOK(status)) "E^"_$System.Status.GetErrorText(status)
	
	quit "S^"_obj.%Id()
}

ClassMethod SaveJScriptData(templateId, JScriptData) As %String
{
	quit:'##class(User.DHCBPCPrintTemplate).%ExistsId(templateId) "E^模块ID错误"
	
	set obj=##class(User.DHCBPCPrintTemplate).%OpenId(templateId)
	if (JScriptData["CharacterStream") do obj.JScriptData.CopyFrom(JScriptData)
	else  do obj.JScriptData.Write(JScriptData)
	set status=obj.%Save()
	quit:('$System.Status.IsOK(status)) "E^"_$System.Status.GetErrorText(status)
	
	quit "S^"_obj.%Id()
}

ClassMethod GetSheetDataStr(sheetDataStr) As %String
{
	set result=""
	quit:sheetDataStr="" ""
	 
	try
	{
		if ($f(sheetDataStr, "CharacterStream")>1)
		{
			set stream=##class(%GlobalCharacterStream).%New()
			do stream.CopyFrom(sheetDataStr)
			do stream.Rewind()
			while(stream.AtEnd=0)
			{
				set len=10000
				set result=result_stream.Read(.len)	
			}
		}
		else
		{
			set result=sheetDataStr
		}
	}
	catch
	{
		set result=sheetDataStr
	}
	quit result
}

}
