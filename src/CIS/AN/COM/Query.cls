/// Query处理类
Class CIS.AN.COM.Query Extends %RegisteredObject
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
        set dataObject=##class(CIS.AN.COM.DataObject).%New()
        set node=""
        for
        {
            set node=$order(data(rowIndex,node))
            quit:(node="")
            set keyValuePair=##class(CIS.AN.COM.KeyValuePair).%New()
            set keyValuePair.Key=node
            set keyValuePair.Value=data(rowIndex,node)
            do dataObject.KeyValuePairs.Insert(keyValuePair)    
        }
        do result.Insert(dataObject)    
    }   
    quit result
}

/// w ##class(CIS.AN.COM.Query).ToObject("CIS.AN.BL.DataQuery:FindRecordPara","3","27")
ClassMethod ToObject(queryName As %String, Arg...) As CIS.AN.COM.DataObject
{
    set result=##class(CIS.AN.COM.DataObject).%New()
    
    set dataObjects=..ToObjects(queryName,Arg...)
    
    if (dataObjects.Size>=1)
    {
        set result=dataObjects.GetAt(1) 
    }
    
    quit result
}

ClassMethod ToXml(queryName As %String, ByRef stream As %GlobalCharacterStream = "", args...) As %GlobalCharacterStream
{
    set query=##class(%ResultSet).%New(queryName)
    if (stream="")
    {
	    set stream=##class(%GlobalCharacterStream).%New()
    }
    set sc=query.Execute(args...)
    if ($System.Status.IsError(sc))
    {
        w $System.Status.GetErrorText(sc,"zh-cn") 
        quit  
    }
    set colCount=query.GetColumnCount()
    set tag="Row"
    while (query.Next()) 
    {
		do stream.Write("<"_tag_">")
		for i=1:1:colCount
		{
			set name=query.GetColumnName(i)
			set value=query.Get(name)
			do stream.Write("<"_name_">"_value_"</"_name_">")
		}
		d stream.Write("</"_tag_">")
	}
	
    q stream
}

ClassMethod ToJson(queryName As %String, ByRef stream As %GlobalCharacterStream = "", args...) As %GlobalCharacterStream
{
	    set query=##class(%ResultSet).%New(queryName)
    if (stream="")
    {
	    set stream=##class(%GlobalCharacterStream).%New()
    }
    set sc=query.Execute(args...)
    if ($System.Status.IsError(sc))
    {
        w $System.Status.GetErrorText(sc,"zh-cn")   
        quit
    }
    set colCount=query.GetColumnCount()
    d retStr.Write("[")
    set rowIndex=1
    
	while (rset.Next()) 
	{
		if rowIndex'=1 d stream.Write(",")
		do stream.Write("{")
		f i=1:1:colCount
		{
			s name=rset.GetColumnName(i)
			s value=rset.Get(name)
			i i=1 do stream.Write(""""_name_""":"""_value_"""")
			e  do stream.Write(","""_name_""":"""_value_"""")
		}
		do stream.Write("}")
		set rowIndex=rowIndex+1
	}
	do retStr.Write("]")
    // d retStr.OutputToDevice()
	
    quit stream
}

ClassMethod ToDynamicObject(queryName As %String, Arg...)
{
    set result={}
    
    set dataObjects=..ToDynamicObjects(queryName,Arg...)
    
    if (dataObjects.%Size()>=1)
    {
        set result=dataObjects.%Get(0)
    }
    
    quit result
}

ClassMethod ToDynamicObjects(queryName As %String, Arg...)
{
    set sc=..ToString(.data,queryName,Arg...)
    set result=[]
    set rowIndex=0
    for
    {
        set rowIndex=$order(data(rowIndex))
        quit:(rowIndex="")
        set dataObject={}
        set node=""
        for
        {
            set node=$order(data(rowIndex,node))
            quit:(node="")
            
            do dataObject.%Set(node,data(rowIndex,node))
        }
        do result.%Push(dataObject)    
    }   
    quit result
}

}
