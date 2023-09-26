Class CIS.AN.BL.PrintTemplate Extends (%RegisteredObject, %CSP.Page)
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
/// Table：        	CT_AN.PrintTemplate
/// Input:			moduleId:模块ID
/// Return：       	打印模板JSON字符串
/// Debug:			w ##class(CIS.AN.BL.PrintTemplate).GetPrintTemplate("90")
ClassMethod GetPrintTemplate(moduleId As %String) As %String
{
	quit:'##class(CT.AN.DataModule).%ExistsId(moduleId) "E^模块ID错误"
	set templateId=""
	set splitChar=$char(2)
	&sql(select TOP 1 RowId into :templateId from CT_AN.PrintTemplate where DataModule=:moduleId order by RowId Desc)
	quit:templateId="" ""
	set template=##class(CT.AN.PrintTemplate).%OpenId(templateId)
	set jsonData=template.JSONData
	if (jsonData["CharacterStream") set jsonData=template.JSONDataStream.Read(100000)
	quit templateId_splitChar_jsonData
}

/// Creator：      	李杰
/// CreatDate：    	2022年3月28日
/// Description： 	获取模板JS脚本数据
/// Table：        	CT_AN.PrintTemplate
/// Input:			moduleId:模块ID
/// Return：       	打印模板JS脚本
/// Debug:			w ##class(CIS.AN.BL.PrintTemplate).GetJScriptData("103")
ClassMethod GetJScriptData(moduleId As %String) As %String
{
	quit:'##class(CT.AN.DataModule).%ExistsId(moduleId) "E^模块ID错误"
	set templateId=""
	&sql(select TOP 1 RowId into :templateId from CT_AN.PrintTemplate where DataModule=:moduleId order by RowId Desc)
	quit:templateId="" $SYSTEM.Encryption.Base64Encode("function OnLoaded(){}")
	set template=##class(CT.AN.PrintTemplate).%OpenId(templateId)
	set jsData=template.JScriptData.Read(100000)
	quit:jsData="" $SYSTEM.Encryption.Base64Encode("function OnLoaded(){}")
	quit jsData
}

/// Creator：      	李杰
/// CreatDate：    	2020年6月11日
/// Description： 	保存打印模板
/// Table：        	CT_AN.PrintTemplate
/// Input:			moduleId:模块ID,sheetDataStr:模板json字符串
/// Return：       	保存结果
/// Debug:			
ClassMethod SavePrintTemplate(templateId, moduleId, sheetDataStr, updateUser) As %String
{
	set jsonStr=##class(CIS.AN.BL.PrintTemplate).GetSheetDataStr(sheetDataStr)
	quit:'##class(CT.AN.DataModule).%ExistsId(moduleId) "E^模块ID错误"
	
	set obj=##class(CT.AN.PrintTemplate).%New()
	if (##class(CT.AN.PrintTemplate).%ExistsId(templateId))
	{
		set obj=##class(CT.AN.PrintTemplate).%OpenId(templateId)
		set ^tmpSavePrintTemplate(moduleId,+$h,$p($h,",",2))=obj.JSONData
	}
	
	set obj.DataModule=##class(CT.AN.DataModule).%OpenId(moduleId)
	set obj.JSONData=jsonStr
	set obj.UpdateUser=updateUser
	set obj.UpdateDate=+$h
	set obj.UpdateTime=$piece($h,",",2)
	if (sheetDataStr["CharacterStream") do obj.JSONDataStream.CopyFrom(sheetDataStr)
	else  do obj.JSONDataStream.Write(sheetDataStr)
	set status=obj.%Save()
	quit:('$System.Status.IsOK(status)) "E^"_$System.Status.GetErrorText(status)
	
	quit "S^"_obj.%Id()
}

ClassMethod SaveJScriptData(templateId, JScriptData) As %String
{
	quit:'##class(CT.AN.PrintTemplate).%ExistsId(templateId) "E^模块ID错误"
	
	set obj=##class(CT.AN.PrintTemplate).%OpenId(templateId)
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

/// do ##class(CIS.AN.BL.PrintTemplate).GetValue()
ClassMethod GetValue(opsID, code) As %String
{
	quit $g(^tmpSaveValue)
}

/// do ##class(CIS.AN.BL.PrintTemplate).SetValue()
ClassMethod SaveValue(opsID, code, value, userID) As %String
{
	set ^tmpSaveValue=value
	quit "S^"
}

}
