Class DHCCL.BLL.Query Extends %RegisteredObject
{

ClassMethod ToString(ByRef data As %String, queryName As %String, Arg...) As %Status
{
	k data
	set query=##class(%ResultSet).%New(queryName)
	set sc=query.Execute(Arg...)
	if ($System.Status.IsError(sc))
	{
		w $System.Status.GetErrorText(sc,"zh-cn")	
	}
	set rowCount=0,colCount=query.GetColumnCount()
	while(query.%Next())
	{
		set rowCount=rowCount+1
		for colIndex=1:1:colCount
		{
			set colName=query.GetColumnName(colIndex)
			set dataValue=query.Get(colName)
			set data(rowCount,colName)=dataValue
		}	
	}
	quit $$$OK
}

ClassMethod ToObjects(queryName As %String, Arg...) As %ListOfObjects
{
	set sc=..ToString(.data,queryName,Arg...)
	set result=##class(%ListOfObjects).%New()
	set rowIndex=0
	for
	{
		set rowIndex=$order(data(rowIndex))
		quit:(rowIndex="")
		set dataObject=##class(DHCCL.BLL.DataObject).%New()
		set node=""
		for
		{
			set node=$order(data(rowIndex,node))
			quit:(node="")
			set keyValuePair=##class(DHCCL.BLL.KeyValuePair).%New()
			set keyValuePair.Key=node
			set keyValuePair.Value=data(rowIndex,node)
			do dataObject.KeyValuePairs.Insert(keyValuePair)	
		}
		do result.Insert(dataObject)	
	}	
	quit result
}

/// w ##class(DHCCL.BLL.Query).ToObject("DHCAN.BLL.DataQuery:FindRecordPara","3","27")
ClassMethod ToObject(queryName As %String, Arg...) As DHCCL.BLL.DataObject
{
	set result=##class(DHCCL.BLL.DataObject).%New()
	
	set dataObjects=..ToObjects(queryName,Arg...)
	
	if (dataObjects.Size>=1)
	{
		set result=dataObjects.GetAt(1)	
	}
	
	quit result
}

}
