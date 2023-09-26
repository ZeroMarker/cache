Class CIS.AN.COM.JSON
{

// 将Cache RegisteredObject/动态变量/对象转化为JSON字符串

/// Creator：      	邓体进
/// CreatDate：    	2022-04-28
/// Description： 	Cache对象转JSON
/// Table：        	%GlobalCharacterStream
/// Input:			Cache任何对象: %RegisteredObject/%Collection.AbstractIterator/Dynamic对象
/// Return：       	%GlobalCharacterStream
/// w ##class(CIS.AN.COM.JSON)ObjectToJSON(obj,stream)
ClassMethod ObjectToJSON(obj As %RegisteredObject, stream As %GlobalCharacterStream = "", fieldList = "") As %GlobalCharacterStream
{
	/* 测试用
	if (obj="")
	{
		
	set obj=##class(DHCCL.DTO.AN.OperInfo).%New()
	set operListObj=##class(DHCCL.DTO.AN.OperationList).%New()
	do obj.OperationDetail.Insert(operListObj)
	}
	*/
	if (obj="")
	{
		quit ""
	}
	if (stream="")
	{
		set stream=##class(%GlobalCharacterStream).%New()
	}
	if ($IsObject(obj)&&(obj.%IsA("%Collection.AbstractIterator")))
	{
		// %Collection对象,如%ArrayOfObjects/%ListOObjects/%ListOfDataTypes/%ArrayOfDataTypes
		quit ..CollectionToJSON(obj,stream,fieldList)
	}
	elseif ($IsObject(obj)&&((obj.%ClassName()="%DynamicObject")||(obj.%ClassName()="%DynamicArray")))
	{
		// 动态变量
		do stream.Write(obj.%ToJSON())
		quit stream
	}
	// 处理%RegisteredObject，即一般Model类
	
	set className=obj.%PackageName()_"."_obj.%ClassName()
	set split=""""
	set cdef = ##class(%Dictionary.ClassDefinition).%OpenId(className)
	set count = cdef.Properties.Count()
	
	do stream.Write("{")
	for i = 1:1:count 
	{
		set name=cdef.Properties.GetAt(i).Name
		if ((fieldList'="")&&(fieldList_";"'[name_";")) continue
		set type=cdef.Properties.GetAt(i).Type
		set collection=cdef.Properties.GetAt(i).Collection
		set value=$PROPERTY(obj, name)
	    if (value["%Library.RelationshipObject")
	    {
		    // 外键
		    continue
	    }
	    if ((value'=""))
	    {
			if (type="%Date")
		    {
			     set value=##class(web.DHCClinicCom).ConvertToDate(value)
		    }
		    elseif (type="%Time")
		    {
			     set value=##class(web.DHCClinicCom).ConvertToTime(value)
		    }
			if ($IsObject(value)&&(collection="list") && value.%IsA("%Collection.ListOfObj"))
			{
				if (i'=1)
			    {
				    do stream.Write(",")
			    }
				do stream.Write(split_name_split_":[")
				for j=1:1:value.Count()
				{
					set item=value.GetAt(j)
					if (j'=1)
					{
						do stream.Write(",")
					}
					set oneObjStr=..ObjectToJSON(item,"",fieldList).Read(1024*1024)
					do stream.Write(oneObjStr)
				}
				do stream.Write("]")
				continue
			}
			elseif ($IsObject(value)&&value.%IsA("%RegisteredObject"))
			{
				if (i'=1)
			    {
				    do stream.Write(",")
			    }
				do stream.Write(split_name_split_":")
				set oneObjStr=..ObjectToJSON(value).Read(1024*1024)
				do stream.Write(oneObjStr)
				continue
			}
	    }
	    if (i'=1)
	    {
		    do stream.Write(",")
	    }
		if ((type="%Float") || (type="%Integer"))
		{
			do stream.Write(""""_name_""":"_value)
		}
		else
		{
			set value=$zconvert(value,"O","JSON")
			do stream.Write(""""_name_""":"_""""_value_"""")
		}
	}
	do stream.Write("}")
	quit stream
}

// 不对外公开,不要调用

ClassMethod CollectionToJSON(obj As %Collection.AbstractIterator, stream As %GlobalCharacterStream = "", fieldList = "") As %GlobalCharacterStream
{
	if (stream="")
	{
		set stream=##class(%GlobalCharacterStream).%New()
	}
	if ($IsObject(obj)&&(obj.%ClassName()="%ListOfObjects"))
	{
		do stream.Write("[")
		set list=obj
		for i=1:1:list.Count()
		{
			if (i'=1) do stream.Write(",")
			set itemObj=list.GetAt(i)
			do ..ObjectToJSON(itemObj,stream)
		}
		do stream.Write("]")
	}
	if ($IsObject(obj)&&(obj.%ClassName()="%ListOfDataTypes"))
	{
		do stream.Write("[")
		set list=obj
		for i=1:1:list.Count()
		{
			if (i'=1) do stream.Write(",")
			set itemObj=list.GetAt(i)
			do stream.Write(itemObj)
		}
		do stream.Write("]")
	}
	elseif ($IsObject(obj)&&(obj.%ClassName()="%ArrayOfObjects"))
	{
		set key=""
		do stream.Write("{")
		set isFirst=1
		For
		{
			s key=obj.Next(key)
			q:key=""
			if ((fieldList'="")&&(fieldList_";"'[key_";")) continue
			s value=obj.GetAt(key)
			if ('isFirst) do stream.Write(",")
			do stream.Write(""""_key_""":")
			do ..ObjectToJSON(value,.stream)
			set isFirst=0
	 	}
	 	do stream.Write("}")
	}
	elseif ($IsObject(obj)&&((obj.%ClassName()="%ArrayOfDataTypes")))
	{
		set key=""
		do stream.Write("{")
		set isFirst=1
		For
		{
			s key=obj.Next(key)
			q:key=""
			if ((fieldList'="")&&(fieldList_";"'[key_";")) continue
			s value=obj.GetAt(key)
			if ('isFirst) do stream.Write(",")
			set value=$zconvert(value,"O","JSON")
			do stream.Write(""""_key_""":"""_value_"""")
			set isFirst=0
	 	}
	 	do stream.Write("}")
	}
	quit stream
}

/// Creator：      	邓体进
/// CreatDate：    	2022-04-28
/// Description： 	%Collection.AbstractIterator(%ArrayOfDataTypes/%ListOfDataTypes/%ListOfObjects/%ArrayOfObjects)对象转JSON
/// Table：        	%GlobalCharacterStream
/// Input:			Cache任何对象: %RegisteredObject/%Collection.AbstractIterator/Dynamic对象
/// Return：       	%DynamicAbstractObject
/// w ##class(CIS.AN.COM.JSON).CollectionToDynamicObject(obj)
ClassMethod CollectionToDynamicObject(cObj As %Collection.AbstractIterator) As %DynamicAbstractObject
{
	set jsonStr=..CollectionToJSON(cObj).Read(1024*1024)
	quit {}.%FromJSON(jsonStr)
}

/// Creator：      	邓体进
/// CreatDate：    	2022-04-28
/// Description： 	根据字段名称获取Cache对象的值
/// Table：        	%String
/// Input:			Cache任何对象: %RegisteredObject/%Collection.AbstractIterator/Dynamic对象
/// Return：       	%String
/// w ##class(CIS.AN.COM.JSON).GetValueByFieldName(obj,fieldName)
ClassMethod GetValueByFieldName(obj As %RegisteredObject, fieldName As %String) As %String
{
	if (obj="")
	{
		quit ""
	}
	if ($IsObject(obj)&&(obj.%IsA("%Collection.AbstractIterator")))
	{
		// %Collection对象,如%ArrayOfObjects/%ListOObjects/%ListOfDataTypes/%ArrayOfDataTypes
		quit obj.GetAt(fieldName)
	}
	elseif ($IsObject(obj)&&((obj.%ClassName()="%DynamicObject")||(obj.%ClassName()="%DynamicArray")))
	{
		// 动态变量
		quit obj.%Get(fieldName)
	}
	// 处理%RegisteredObject，即一般Model类
	
	set className=obj.%PackageName()_"."_obj.%ClassName()
	set split=""""
	set cdef = ##class(%Dictionary.ClassDefinition).%OpenId(className)
	set count = cdef.Properties.Count()
	
	set value=""
	for i = 1:1:count 
	{
		set name=cdef.Properties.GetAt(i).Name
		set type=cdef.Properties.GetAt(i).Type
		set collection=cdef.Properties.GetAt(i).Collection
		set value=$PROPERTY(obj, name)
	    if (value["%Library.RelationshipObject")
	    {
		    // 外键
		    continue
	    }
	    if ((value'=""))
	    {
			if (type="%Date")
		    {
			     set value=##class(web.DHCClinicCom).ConvertToDate(value)
		    }
		    elseif (type="%Time")
		    {
			     set value=##class(web.DHCClinicCom).ConvertToTime(value)
		    }
	    }
	    if (fieldName=name)
	    {
		    quit
	    }
	}
	quit value
}

}
