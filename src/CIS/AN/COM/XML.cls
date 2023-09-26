Class CIS.AN.COM.XML
{

/// Creator：      	邓体进
/// CreatDate：    	2022-04-28
/// Description： 	Cache对象转XML
/// Table：        	%GlobalCharacterStream
/// Input:			Model类或动态变量 
///                 由Model类或动态变量组成的动态数组
///                 由Model类组成的%ListObject
///                 不支持所有类型的原因： XML可以用属性表示，也可以用子结点表示
/// Return：       	%GlobalCharacterStream
/// w ##class(CIS.AN.COM.XML).ObjectToXML(obj,stream)
ClassMethod ObjectToXML(obj As %RegisteredObject, tagName = "", stream As %GlobalCharacterStream = "", fieldList = "") As %GlobalCharacterStream
{
	if (stream="")
	{
		set stream=##class(%GlobalCharacterStream).%New()
	}
	if (..IsClass(obj,"%ListOfObjects"))
	{
		do ..ListOfObjectsToXML(obj,tagName,"",stream)
		quit stream
	}
	elseif (..IsClass(obj,"%ArrayOfObject"))
	{
		set key=""
		if (tagName'="") do stream.Write("<"_tagName_">")
		set isFirst=1
		For
		{
			s key=obj.Next(key)
			q:key=""
			if ((fieldList'="")&&(fieldList_";"'[key_";")) continue
			s value=obj.GetAt(key)
			do stream.Write("<"_key_">")
			do ..ObjectToXML(value,"",.stream)
			do stream.Write("</"_key_">")
	 	}
	 	if (tagName'="") do stream.Write("</"_tagName_">")
		quit stream
	}
	
	elseif (..IsClass(obj,"%ArrayOfDataTypes"))
	{
		set key=""
		if (tagName'="") do stream.Write("<"_tagName_">")
		set isFirst=1
		For
		{
			s key=obj.Next(key)
			q:key=""
			if ((fieldList'="")&&(fieldList_";"'[key_";")) continue
			s value=obj.GetAt(key)
			do stream.Write("<"_key_">")
			set value=$zconvert(value,"O","XML")
			do stream.Write("</"_value_">")
			do stream.Write("</"_key_">")
	 	}
	 	if (tagName'="") do stream.Write("</"_tagName_">")
	 	quit stream
	}
	elseif (..IsClass(obj,"%DynamicObject"))
	{
		;b // 动态变量
		do ..DynamicObjectToXML(obj,tagName,stream)
		quit stream
	}
	elseif (..IsClass(obj,"%DynamicObject")||..IsClass(obj,"%DynamicArray"))
	{
		b // 动态变量
		do ..DynamicArrayToXML(obj,tagName,"",stream)
		quit stream
	}
	elseif (..IsClass(obj,"%ListOfDataTypes"))
	{
		// XML无法表示这种结构["a","b"]????
		quit stream
		
		if (tagName'="") do stream.Write("<"_tagName_">")
		set list=obj
		for i=1:1:list.Count()
		{
			if (i'=1) do stream.Write(",")
			set itemObj=list.GetAt(i)
			do stream.Write(itemObj)
		}
		if (tagName'="") do stream.Write("<"_tagName_">")
	}
	// Model类
	set className=obj.%PackageName()_"."_obj.%ClassName()
	set split=""""
	set cdef = ##class(%Dictionary.ClassDefinition).%OpenId(className)
	set count = cdef.Properties.Count()
	if (stream="") set stream=##class(%GlobalCharacterStream).%New()
	if (tagName'="") do stream.Write("<"_tagName_">")
	for i = 1:1:count 
	{
		set name=cdef.Properties.GetAt(i).Name
		if ((fieldList'="")&&(fieldList_";"'[key_";")) continue
		set type=cdef.Properties.GetAt(i).Type
		set collection=cdef.Properties.GetAt(i).Collection
		set value=$PROPERTY(obj, name)
	    if (..IsClass(value,"%Library.RelationshipObject"))
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
		    elseif ((type="%String") || (type="%Float") || (type="%Integer")|| (type="%Text")|| (type="%Double")|| (type="%Decimal")|| (type="%Boolean"))
		    {
		    }
		    elseif (..IsClass(value,"%ListOfObjects"))
		    {
			    do ..ListOfObjectsToXML(value,name,name_"List",stream)
			    continue
		    }
			elseif (..IsClass(value,"%ListOfObjects"))
			{
                do stream.Write("<"_name_">")
				for j=1:1:value.Count()
				{
					set item=value.GetAt(j)
					set oneObjStr=..ObjectToXML(item).Read(1024*1024)
					do stream.Write(oneObjStr)
				}
				do stream.Write("</"_name_">")
				continue
			}
			elseif (..IsClass(value,"%RegisteredObject"))
			{
				set oneObjStr=..ObjectToXML(value,name,stream)
				continue
			}
	    }
	    
	    do stream.Write("<"_name_">")
	    
	    set value=$zconvert(value,"O","XML")
		do stream.Write(value)
		do stream.Write("</"_name_">")
		
	}
	if (tagName'="") do stream.Write("</"_tagName_">")
	quit stream
}

// 

// 如果是%String需要写入%GlobalCharacterStream

/// Creator：      	邓体进
/// CreatDate：    	2022-04-28
/// Description： 	%String或%XML.Node或%GlobalCharacterStream转化为%ArrayOfDataTypes
/// Table：        	%ArrayOfDataTypes
/// Input:			%String或%XML.Node或%GlobalCharacterStream 
/// Return：       	%ArrayOfDataTypes
/// w ##class(CIS.AN.COM.XML).XMLToListOfDataTypes(obj,stream)
ClassMethod XMLToListOfDataTypes(node As %XML.Node) As %ArrayOfDataTypes
{
	set dyObj=##class(%ArrayOfDataTypes).%New()
	if (node="")
	{
		quit ""
	}
	elseif ('$ISOBJECT(node))
	{
		// 字符串
		set stream=##class(%GlobalCharacterStream).%New()
		do stream.Write(node)
		quit ..XMLToListOfDataTypes(stream)
	}
	elseif (..IsClass(node,"%GlobalCharacterStream"))
	{
		// %GlobalCharacterStream
		set document=""
		set status=##class(%XML.Document).GetDocumentFromStream(node,.document)
		if (document="")
		{
			quit dyObj
		}
        set rootNode=document.GetDocumentElement()
        do rootNode.MoveToFirstChild()
        quit ..XMLToListOfDataTypes(rootNode)
	}
	// %XML.Node
	
	
	
	do
	{
		set name=node.QName
		do node.MoveToFirstChild()
		set value=node.NodeData
		
		
		if (node.HasChildNodes())
		{
			set array=dyObj.GetAt(name)
			if (array="")
			{
				set array=##class(%ListOfObjects).%New()
			}
			
			set subDyObj=..XMLToListOfDataTypes(node)
			do array.Insert(subDyObj)
			do dyObj.SetAt(name,array)
		}
		else
		{
			do dyObj.SetAt(value,name)
		}
		do node.MoveToParent()
	}
	while(node.MoveToNextSibling())
	return dyObj
}

/// Creator：      	邓体进
/// CreatDate：    	2022-04-28
/// Description： 	%String或%XML.Node或%GlobalCharacterStream转化为%DynamicObject
///                 Cache2016及以上版本可使用
/// Table：        	%ArrayOfDataTypes
/// Input:			%String或%XML.Node或%GlobalCharacterStream 
/// Return：       	%DynamicObject
/// w ##class(CIS.AN.COM.XML).XMLToListOfDataTypes(obj,stream)
ClassMethod XMLToDynamicObject(node As %XML.Node) As %DynamicObject
{
	if (node="")
	{
		quit ""
	}
	elseif ('$ISOBJECT(node))
	{
		// 字符串
		set stream=##class(%GlobalCharacterStream).%New()
		do stream.Write(node)
		quit ..XMLToDynamicObject(stream)
	}
	elseif (..IsClass(node,"%GlobalCharacterStream"))
	{
		// %GlobalCharacterStream
		set document=""
		set status=##class(%XML.Document).GetDocumentFromStream(node,.document)
        set rootNode=document.GetDocumentElement()
        do rootNode.MoveToFirstChild()
        quit ..XMLToDynamicObject(rootNode)
	}
	set dyObj={}
	
	do
	{
		set name=node.QName
		do node.MoveToFirstChild()
		set value=node.NodeData
		
		
		if (node.HasChildNodes())
		{
			set array=dyObj.%Get(name)
			if (array="")
			{
				set array=[]
			}
			
			set subDyObj=..XMLToDynamicObject(node)
			do array.%Push(subDyObj)
			do dyObj.%Set(name,array)
		}
		else
		{
			do dyObj.%Set(name,value)
		}
		do node.MoveToParent()
	}
	while(node.MoveToNextSibling())
	return dyObj
}

// 不公开，勿使用

ClassMethod DynamicArrayToXML(dyList, name, externalTagName = "", stream = "", fieldList = "") As %GlobalCharacterStream
{
	if (stream="")
	{
		set stream=##class(%GlobalCharacterStream).%New()
	}
	if (..IsClass(dyList,"%DynamicArray"))
	{
		if (externalTagName'="") do stream.Write("<"_externalTagName_">")
		for i=0:1:dyList.%Size()-1
		{
			set dyObj=dyList.%Get(i)
			do ..ObjectToXML(dyObj, name, .stream,fieldList)
		}
		if (externalTagName'="") do stream.Write("<"_externalTagName_">")
	}
	
	return stream
}

ClassMethod DynamicObjectToXML(dyObj, name, stream = "", fieldList = "") As %GlobalCharacterStream
{
	if (stream="")
	{
		set stream=##class(%GlobalCharacterStream).%New()
	}
	if (..IsClass(dyObj,"%DynamicArray"))
	{
		return ..DynamicArrayToXML(dyObj, name, stream,fieldList)
	}
	
	set iter = dyObj.%GetIterator()
	
	if (name'="") do stream.Write("<"_name_">")
	while iter.%GetNext(.key , .value ) 
	{
		if ((fieldList'="")&&(fieldList_";"'[key_";")) continue
		if ($isobject(value)&&(value.%ClassName()="%DynamicArray"))
		{
			for i=0:1:value.%Size()-1 {
				set itemObj=value.%Get(i)
				do ..DynamicArrayToXML(itemObj,key,.stream,fieldList)
		    }
		}
		else
		{
			do stream.Write("<"_key_">")
			set value=$zconvert(value,"O","XML")
			do stream.Write(value)
			do stream.Write("</"_key_">")
		}
	}
	if (name'="") do stream.Write("</"_name_">")
	return stream
}

ClassMethod ListOfObjectsToXML(list As %ListOfObjects, tagName = "", externalTagName = "", stream As %GlobalCharacterStream = "") As %GlobalCharacterStream
{
	if (stream="")
	{
		set stream=##class(%GlobalCharacterStream).%New()
	}
	
	if ('list.%IsA("%ListOfObjects")&&(list.%IsA("%Collection.ListOfObj")))
	{
		return stream
	}
	if (externalTagName'="") do stream.Write("<"_externalTagName_">")
	for i=1:1:list.Count()
	{
		set obj=list.GetAt(i)
		do ..ObjectToXML(obj,tagName,stream)
	}
	if (externalTagName'="") do stream.Write("</"_externalTagName_">")
	quit stream
}

ClassMethod IsClass(obj, className) As %Boolean
{
	if ($isobject(obj)&&(obj.%ClassName()=className))
	{
		quit $$$OK
	}
	quit 0
}

}
