Class CIS.AN.BL.DataGrid Extends %RegisteredObject
{

/// w ##class("CIS.AN.BL.DataGrid").SaveDataGridSettings(^TMPYGB("SaveDataGridSettings"))
ClassMethod SaveDataGridSettings(dataPara As %String) As %String
{
	set $zt="Error"
	set ^TMPYGB("SaveDataGridSettings")=dataPara
	tstart
	set sc=##class(CIS.AN.COM.String).ToArray(dataPara,.array)
	m datagrid=array(1)
	;set DataModule=datagrid("DataModule")
	;set Element=datagrid("Element")
	;set SSGroup=datagrid("SSGroup")
	;set SSUser=datagrid("SSUser")
	;;set datagrid("RowId")=..GetDataGridID(DataModule,Element,SSGroup,SSUser)
	;if (datagrid("RowId")'="")  s re=..DeleteDataGridInfo(datagrid("RowId"))
	set saveResut=##class(CIS.AN.COM.DataService).SaveData(.datagrid)
	if ($p(saveResut,"^",1)'="S")
	{
		trollback
		quit saveResut	
	}
	set datagridId=$p(saveResut,"^",2)
	set colIndex=1
	for
	{
		set colIndex=$o(array(colIndex))
		quit:(colIndex="")
		kill datacolumn
		m datacolumn=array(colIndex)
		set datacolumn("DataGrid")=datagridId
		set saveResut=##class(CIS.AN.COM.DataService).SaveData(.datacolumn)
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

/// w ##class("CIS.AN.BL.DataGrid").GetDataGridID(4,"operlistBox",29,33)
ClassMethod GetDataGridID(moduleId As %String, elementId As %String, groupId As %String, userId As %String) As %String
{
	set gridId=""
	&sql(select Top 1 %ID into :gridId from CF_AN.DataGrid where DataModule=:moduleId and Element=:elementId and SSUser=:userId order by RowId desc)
	if ('##class(CF.AN.DataGrid).%ExistsId(gridId))
	{	
		&sql(select Top 1 %ID into :gridId from CF_AN.DataGrid where DataModule=:moduleId and Element=:elementId and SSGroup=:groupId order by RowId desc)	
		if ('##class(CF.AN.DataGrid).%ExistsId(gridId))
		{
			&sql(select Top 1 %ID into :gridId from CF_AN.DataGrid where DataModule=:moduleId and Element=:elementId and not Site is null order by RowId desc)	
		}
	}
	quit gridId
}

/// w ##class("CIS.AN.BL.DataGrid").GetDataGridID(3,29,33)
ClassMethod DeleteDataGridInfo(dataGrid As %String) As %String
{
	set gridId=""
	&sql(delete from CF_AN.DataColumn where DataGrid=:dataGrid)
	quit gridId
}

ClassMethod GetDataColumnID(DataGrid As %String, field As %String) As %String
{
	set gridId=""
	&sql(select Top 1 %ID into :DataColumnId from CF_AN.DataColumn where DataGrid=:DataGrid and Field=:field order by RowId desc)
	quit DataColumnId
}

/// w ##class(CIS.AN.BL.DataGrid).GetDataColumns(4,"operlistBox",29,33)
ClassMethod GetDataColumns(moduleId As %String, elementId As %String, groupId As %String, userId As %String, host As %String = "") As %String
{
	set datagridID=..GetDataGridID(moduleId,elementId,groupId,userId)
	b ;001
	&sql(declare columnCursor cursor for select %ID into :RowId from CF_AN.DataColumn where DataGrid=:datagridID)
	&sql(open columnCursor)
	set rowIndex=1,columnArr=""
	for
	{
		&sql(fetch columnCursor)
		quit:(SQLCODE'=0)
		set dataColumn=##class(CF.AN.DataColumn).%OpenId(RowId)
		set columnArr(RowId,"Align")=dataColumn.Align
		set columnArr(RowId,"DataGrid")=dataColumn.DataGrid
		set columnArr(RowId,"Editor")=""    //dataColumn.Editor
		set columnArr(RowId,"field")=dataColumn.Field
		set columnArr(RowId,"Formatter")=dataColumn.Formatter
		set columnArr(RowId,"Frozen")=dataColumn.Frozen
		set columnArr(RowId,"HAlign")=dataColumn.HAlign
		set columnArr(RowId,"hidden")=dataColumn.Hidden
		set columnArr(RowId,"Order")=dataColumn.Order
		set columnArr(RowId,"SeqNo")=dataColumn.SeqNo
		set columnArr(RowId,"sortable")=dataColumn.Sortable
		set columnArr(RowId,"Sorter")=dataColumn.Sorter
		set columnArr(RowId,"Styler")=dataColumn.Styler	
		set columnArr(RowId,"title")=dataColumn.Title
		set columnArr(RowId,"width")=dataColumn.Width
		set columnArr(RowId,"RowId")=RowId
	}
	&sql(close columnCursor)
	set result=##class(CIS.AN.COM.String).ToJson(.columnArr)
	quit result
}

/// w ##class("CIS.AN.BL.DataGrid").GetSaveState(4,"operlistBox",29,33)
ClassMethod GetSaveState(moduleId As %String, elementId As %String, groupId As %String, userId As %String) As %String
{
	set gridId="",StateRe=0
	&sql(select Top 1 %ID into :gridId from CF_AN.DataGrid where DataModule=:moduleId and Element=:elementId and SSUser=:userId order by RowId desc)
	if (gridId'="") set StateRe(1,"SSUser")="Y"     //用户保存
	set userId=""
	&sql(select Top 1 %ID into :gridId from CF_AN.DataGrid where DataModule=:moduleId and Element=:elementId and SSGroup=:groupId and SSUser=:userId order by RowId desc)	
	if (gridId'="") set StateRe(1,"SSGroup")="Y"    //安全组保存
	set groupId=""
	&sql(select Top 1 %ID into :gridId from CF_AN.DataGrid where DataModule=:moduleId and Element=:elementId and not Site is null and SSGroup=:groupId and SSUser=:userId order by RowId desc)	
	if (gridId'="") set StateRe(1,"Site")="Y"   //站点保存
	
	b ;009
	set result=##class(CIS.AN.COM.String).ToJson(.StateRe)
	quit result
}

}
