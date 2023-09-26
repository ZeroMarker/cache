/// Desc:解析json串为json对象
/// Creaotr: yejian
/// Createdate: 2020-12-7
Class EMR.DOC.COM.Parser.Json Extends (%RegisteredObject, %XML.Adaptor)
{

Property Stream As %GlobalBinaryStream;

Property Char As %String;

/// Desc: 移动流数据指针位置
Method Next()
{
	s ..Char = ..Stream.Read(1)
}

/// Desc: 解析json流数据为json对象
Method Deserialize(AStream As %GlobalBinaryStream) As %ArrayOfDataTypes
{
	s Json = ##Class(%ArrayOfDataTypes).%New() 
	d ..Stream.CopyFrom(AStream)
	d ..Next()
    while('..Stream.AtEnd) 
    {
	    if (..Char = "{")
	    {
		    s Json = ..parseObject()
		}elseif (..Char = "[")
		{
			s Json = ..parseArray()
		}
		d ..Next()
	}
	q Json
}

/// Desc:解析json对象
Method parseObject() As %ArrayOfDataTypes
{
	s ObjJson = ##Class(%ArrayOfDataTypes).%New()
	s needNextElement = -1
	d ..Next()
	while ('..Stream.AtEnd) 
	{
	    q:((needNextElement = -1) && (..Char ="}"))
	    if ((..Char = "")||(..Char = " "))
	    {
		   d ..Next()
		}else
		{
		   s Name = ..parseName()
		   s value = ..parseValue("}")
		   d ObjJson.SetAt(value,Name)
		   if (..Char = "}")
		   {
		      q
		   }
		   else
		   {
			   d ..Next()
			   s needNextElement = 1
		   }	
		}
    }
    if (..Char = "}")
    {
	    d ..Next()
	}
    q ObjJson
}

/// Desc:解析josn数组
Method parseArray() As %ListOfDataTypes
{
	s ListValue = ##Class(%ListOfDataTypes).%New()
	s needNextElement = -1
	d ..Next()
	while ('..Stream.AtEnd)
	{
	   q:((needNextElement = -1) && (..Char = "]"))
       if (..Char = "")
       {
	       d ..Next()
	   }
	   else
	   {
		   s value = ..parseValue("]") 
		   d ListValue.Insert(value)
		   if (..Char = "]")
		   {
			   q
		   }
		   else
		   {
			   d ..Next()
			   s needNextElement = 1
		   }
	   }
	}
	if (..Char = "]")
	{
		d ..Next()
	}
	q ListValue
}

/// Desc:获取json键值对名称
Method parseName() As %String
{
    s name = ..parseString()
	d:(..Char = ":") ..Next()
    q name
}

/// Desc:获取json键值对值
Method parseValue(endch As %String) As %String
{
	s value = ""
	if ((..Char = "")||(..Char = " "))
	{
		d ..Next()
	}
	elseif (..Char = "{")
	{
		s value = ..parseObject()
	}
	elseif (..Char = "[")
	{
		s value = ..parseArray()
	}
	else
	{
		s value = ..parseString()
	}
	q value
}

/// Desc:取值
Method parseString() As %String
{
	s value = ""
	d ..Next()
	while ('..Stream.AtEnd)
    {
	   q:(..Char = """")
	   s value = value_..Char
	   d ..Next()
	 }
	 if (..Char = """")
	 {
		 d ..Next()
     }
     q value
}

/// d ##Class(EMRservice.Parser.Json).test()
ClassMethod test()
{
	s Stream =##class(%FileBinaryStream).%New()
	s Stream.Filename = "c:\1.txt"
	s obj = ##Class(EMRservice.Parser.Json).%New()
	s json = obj.Deserialize(Stream)
	
	w "params",json.GetAt("params"),!
	w "action",json.GetAt("params").GetAt("action"),!

	//w "DataBaseBindCode",json.GetAt("params").GetAt("items").GetAt(1).GetAt("DataBaseBindCode"),!
	//w "Code",json.GetAt("params").GetAt("items").GetAt(1).GetAt("Code"),!
	//w "DataBaseBindCode",json.GetAt("params").GetAt("items").GetAt(2).GetAt("DataBaseBindCode"),!
	//w "Code",json.GetAt("params").GetAt("items").GetAt(2).GetAt("Code"),!
	//w "type",json.GetAt("type"),!
}

}
