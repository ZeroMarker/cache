Class CIS.AN.BL.SheetSettings Extends %RegisteredObject
{

/// w ##class("CIS.AN.BL.DataGrid").SaveDataGridSettings(^TMPYGB("SaveDataGridSettings"))
ClassMethod SaveSheetSettings(dataPara As %String) As %String
{
	set $zt="Error"
	set ^TMPYGB("SaveSheetSettings")=dataPara
	tstart
	set sc=##class(CIS.AN.COM.String).ToArray(dataPara,.array)
	kill sheetPermission
	m sheetPermission=array(1)
	;set DataModule=datagrid("DataModule")
	;set Element=datagrid("Element")
	;set SSGroup=datagrid("SSGroup")
	;set SSUser=datagrid("SSUser")
	;set datagrid("RowId")=..GetDataGridID(DataModule,Element,SSGroup,SSUser)
	set saveResut=##class(CIS.AN.COM.DataService).SaveData(.sheetPermission)
	if ($p(saveResut,"^",1)'="S")
	{
		trollback
		quit saveResut	
	}
	set sheetPermissionId=$p(saveResut,"^",2)
	set colIndex=1
	for
	{
		set colIndex=$o(array(colIndex))
		quit:(colIndex="")
		kill sheetElement
		m sheetElement=array(colIndex)
		set sheetElement("SheetPermission")=sheetPermissionId
		set saveResut=##class(CIS.AN.COM.DataService).SaveData(.sheetElement)
		quit:($p(saveResut,"^",1)'="S")
	}
	if ($p(saveResut,"^",1)'="S")
	{
		trollback
		quit saveResut	
	}
	tcommit
	quit "S^"
Error
	trollback
	quit "E^"_$ze
}

ClassMethod GetSheetPermissionID(moduleId As %String, groupId As %String, userId As %String) As %String
{
	set sheetPermissionId=""
	&sql(select Top 1 %ID into :sheetPermissionId from CF_AN.SheetPermission where DataModule=:moduleId and SSUser=:userId order by RowId desc)
	if ('##class(CF.AN.SheetPermission).%ExistsId(sheetPermissionId))
	{
		&sql(select Top 1 %ID into :sheetPermissionId from CF_AN.SheetPermission where DataModule=:moduleId and SSGroup=:groupId order by RowId desc)	
		if ('##class(CF.AN.SheetPermission).%ExistsId(sheetPermissionId))
		{
			&sql(select Top 1 %ID into :sheetPermissionId from CF_AN.SheetPermission where DataModule=:moduleId and not Site is null order by RowId desc)	
		}
	}
	quit sheetPermissionId
}

ClassMethod GetSheetElementID(sheetPermissionId As %String, elementID As %String) As %String
{
	set sheetElementId=""
	&sql(select Top 1 %ID into :sheetElementId from CF_AN.SheetElement where SheetPermission=:sheetPermissionId and ElementID=:elementID order by RowId desc)
	quit sheetElementId
}

/// w ##class(CIS.AN.BL.DataGrid).GetDataColumns(4,"operlistBox",29,33)
ClassMethod GetSheetElements(moduleId As %String, groupId As %String, userId As %String) As %String
{
	set sheetPermissionId=..GetSheetPermissionID(moduleId,groupId,userId)
	&sql(declare elementCursor cursor for select %ID into :RowId from CF_AN.SheetElement where SheetPermission=:sheetPermissionId)
	&sql(open elementCursor)
	set rowIndex=1,columnArr=""
	for
	{
		&sql(fetch elementCursor)
		quit:(SQLCODE'=0)
		set sheetElement=##class(CF.AN.SheetElement).%OpenId(RowId)
		set columnArr(RowId,"ControlType")=sheetElement.ControlType
		set columnArr(RowId,"ElementDesc")=sheetElement.ElementDesc
		set columnArr(RowId,"ElementID")=sheetElement.ElementID
		set columnArr(RowId,"Enable")=sheetElement.Enable
		set columnArr(RowId,"Required")=sheetElement.Required
		set columnArr(RowId,"SheetPermission")=sheetElement.SheetPermission.%Id()
		set columnArr(RowId,"Visible")=sheetElement.Visible
		set columnArr(RowId,"RowId")=RowId
	}
	&sql(close elementCursor)
	set result=##class(CIS.AN.COM.String).ToJson(.columnArr)
	quit result
}

}
