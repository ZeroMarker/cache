/// 手术麻醉模板
Class CIS.AN.BL.SheetTemplate Extends %RegisteredObject
{

/// Creator：        陈长青
/// CreatDate：      2020-7-2
/// Description：    保存模板数据
/// Table：          CF_AN.SheetTemplate, CF_AN.SheetTemplateData
/// Input:           
/// Return：         保存成功返回"S^"，保存失败返回"E^原因"
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.SheetTemplate","FindSheetTemplates","2")
ClassMethod SaveTemplateData(rowId As %String, templateCode As %String, templateDesc As %String, moduleID As %String, userId As %String, dataPara As %String) As %String
{
	set $zt="Error"
	tstart
	set template=""
	if (##class(CF.AN.SheetTemplate).%ExistsId(rowId))
	{
		set template=##class(CF.AN.SheetTemplate).%OpenId(rowId)	
	}
	else
	{
		set template=##class(CF.AN.SheetTemplate).%New()
		set template.CreateUser=userId
		set template.CreateDate=+$h
		set template.CreateTime=$p($h,",",2)	
	}
	set template.Code=templateCode
	set template.Description=templateDesc
	set template.DataModule=##class(CT.AN.DataModule).%OpenId(moduleID)
	set template.UpdateUser=userId
	set template.UpdateDate=+$h
	set template.UpdateTime=$p($h,",",2)
	set sc=template.%Save()
	if ($System.Status.IsError(sc))
	{
		trollback
		quit "E^"_$System.Status.GetErrorText(sc)	
	}
	
	kill dataArr
	set sc=##class(CIS.AN.COM.String).ToArray(dataPara,.dataArr)
	set dataIndex=0,saveResult="S^"
	set templateID=template.%Id()
	for
	{
		set dataIndex=$o(dataArr(dataIndex))
		quit:(dataIndex="")
		merge templateData=dataArr(dataIndex)
		set dataItem=$g(templateData("DataItem"))
		set templateDataID=..GetTemplateDataID(templateID,dataItem)
		set templateData("RowId")=templateDataID
		set templateData("SheetTemplate")=templateID
		set saveResult=##class(CIS.AN.COM.DataService).SaveData(.templateData)
		quit:($p(saveResult,"^",1)'="S")
	}
	if ($p(saveResult,"^",1)'="S")
	{
		trollback
		quit saveResult	
	}
	tcommit
	quit "S^"
Error
	trollback
	quit "E^"_$ze
}

/// Creator：        陈长青
/// CreatDate：      2020-7-2
/// Description：    查询手术麻醉模板
/// Table：          CF_AN.SheetTemplate
/// Input:           moduleID - 数据模块ID
/// Return：         ResultSet
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.SheetTemplate","FindSheetTemplates","2")
Query FindSheetTemplates(moduleID As %String, userId As %String = "") As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
SELECT RowId,Code,Description,DataModule,DataModule->Description As ModuleDesc,
	   %ODBCOUT(CreateDate)_" "_%ODBCOUT(CreateTime) As CreateDT,
	   %ODBCOUT(UpdateDate)_" "_%ODBCOUT(UpdateTime) As UpdateDT
       from CF_AN.SheetTemplate
	   where DataModule=:moduleID
	   and (CreateUser=:userId or UpdateUser=:userId or :userId is null)
}

/// Creator：        陈长青
/// CreatDate：      2020-7-2
/// Description：    查询手术麻醉模板数据
/// Table：          CF_AN.SheetTemplate
/// Input:           moduleID - 数据模块ID
/// Return：         ResultSet
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.SheetTemplate","FindTemplateDatas","2")
Query FindTemplateDatas(templateID As %String) As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
SELECT RowId,DataItem,DataValue,DataScore,SheetTemplate,SheetTemplate->Description As TemplateDesc,
	   %ODBCOUT(UpdateDate)_" "_%ODBCOUT(UpdateTime) As UpdateDT
       from CF_AN.SheetTemplateData
	   where SheetTemplate=:templateID
}

/// Creator：        陈长青
/// CreatDate：      2020-7-2
/// Description：    获取模板数据ID
/// Table：          CF_AN.SheetTemplateData
/// Input:           sheetTemplateID - 模板ID，dataItem - 数据项
/// Return：         模板数据ID字符串
/// w ##class(CIS.AN.BL.SheetTemplate).GetTemplateDataID("1","Temper")
ClassMethod GetTemplateDataID(sheetTemplateID As %String, dataItem As %String) As %String
{
	set templateDataID=""
	&sql(select %ID into :templateDataID from CF_AN.SheetTemplateData where SheetTemplate=:sheetTemplateID and DataItem=:dataItem)
	quit templateDataID
}

}
