/// 名称:	EMRservice.BL.StreamDataTool
/// 描述:	Stream 解析类
/// 编写者：yejian
/// 编写日期: 2020-12-7
Class EMRservice.BL.StreamDataTool Extends (%RegisteredObject, %XML.Adaptor)
{

Property Stream As %GlobalBinaryStream;

Property Char As %String;

/// Creator：      yejain
/// CreatDate：    2020-12-7
/// Description:   模板\实例数据的流数据解析服务 (metadata,sctipts,PresentationData)
/// Table：        
/// Input：        Stream :模板数据流,实例数据流
/// Return：       节点流数据 (metadata,sctipts,PresentationData)
/// Others：       其它说明
/// Debug:         w ##Class(EMRservice.Parser.StreamData).Test()	
ClassMethod ParserStream(argstream As %GlobalBinaryStream, argStartlable As %String, argEndlable As %String, len As %String) As %GlobalBinaryStream
{

	s ReturnValue=##Class(%GlobalBinaryStream).%New()
		
	s templatestream=##Class(%GlobalBinaryStream).%New()
	d templatestream.CopyFrom(argstream)
	d templatestream.Rewind()

	s BegLocation=-1
	s EndLocation=-1
	
	s BegLocation = templatestream.FindAt("-1",argStartlable)
	s EndLocation = templatestream.FindAt(BegLocation,argEndlable)
	q:((BegLocation=-1)&&(EndLocation=-1)) ReturnValue
	
	s Readlen=EndLocation-BegLocation+len
	
	d templatestream.Rewind()
	d templatestream.MoveTo(BegLocation)
	
	if (Readlen>32000)
	{
		s tmplen=0
		s count=+Readlen\32000
		
		for i=1:1:count
		{	
			d ReturnValue.Write(templatestream.Read(32000))
			s tmplen=32000*i
		}
		s lastlen=+Readlen-tmplen
		d ReturnValue.Write(templatestream.Read(lastlen))
	}
	else
	{
		d ReturnValue.Write(templatestream.Read(Readlen))
	}
	
	q ReturnValue
}

/// Desc:       根据分隔符截取第一个数据
/// Creator:    yejain
/// CreateDate: 2020-12-7
/// Input:      argStream 源数据流
///            argSeparator 分隔符
/// Output:     argOutFirstStream 返回截取的第一个数据流
///            argOutLastStream 剩下的流数据 
/// Debug:         w ##Class(EMRservice.BL.StreamDataTool).Test1()
ClassMethod GetFirstParserStream(argStream As %GlobalBinaryStream, argSeparator As %String, ByRef argOutFirstStream As %GlobalBinaryStream) As %GlobalBinaryStream
{
	s lastStream = ##Class(%GlobalBinaryStream).%New()
	q:(argStream.Size <= 0) lastStream
	d argStream.Rewind()
	s begLocation = 1
	s intSize = argStream.Size
	s findLocation = argStream.FindAt("-1",argSeparator)
	s endLocation = $case(findLocation,-1:intSize,:findLocation-1)
	d argStream.Rewind()
	d argStream.MoveTo(begLocation)
	s totalLen = endLocation 
	s readLen = 32000
	if (totalLen>11)
	{
		d argStream.Read(11)
		s totalLen = totalLen-11
	}
	d argOutFirstStream.Write(argStream.Read(totalLen))
	s splitLocation = endLocation+ $l(argSeparator)
	d argStream.Read($l(argSeparator))
	//如果解析失败NULL。	
	if (intSize>6+splitLocation)
	{
		s readSize = intSize-2-splitLocation
		if (readSize > readLen) 
		{
			s count = readSize\readLen
			for i=1:1:count
			{	
				d argOutFirstStream.Write(argStream.Read(readLen))
			}
			s lastLen = readSize - (count*readLen)
			d lastStream.Write(argStream.Read(lastLen))	
		}
		else
		{
			 d lastStream.Write(argStream.Read(readSize))
		}	
	}
	q lastStream
}

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
	s isDoubleQuotStart = "1"
	
	//读取第一个双引号
	if ($this.Char '= """")
	{
		s value = value_..Char
		s isDoubleQuotStart = "0"
	}
	d ..Next()
	s isEscOn = 0
	while ('..Stream.AtEnd)
    {
	   if (..Char = "\")
	   {
		   if (isEscOn = 0)
		   {
			   s isEscOn = 1
			   d ..Next()
			   continue
		   }
		   else
		   {
			   s isEscOn = 0
			   s value = value_"\"
			   d ..Next()
			   continue
		   }
	   }
	   else
	   {
		   if (isEscOn = 1)
		   {
			   if (..Char = """")
			   {
				   s isEscOn = 0
				   s value = value_""""
				   d ..Next()
			   	   continue
			   }
			   elseif (..Char = "n")
			   {
				   s isEscOn = 0
				   s value = value_$c(10)
				   d ..Next()
			   	   continue
			   }
			   elseif (..Char = "r")
			   {
				   s isEscOn = 0
				   s value = value_$c(13)				   
				   d ..Next()
			   	   continue
			   }
		   }
	   }
	   q:(isDoubleQuotStart = "0")&&(..Char = ",")
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

/// w ##Class(EMR.ART.COM.Parser.Json).ArrayToJson(arr)
ClassMethod ArrayToJson(arr) As %String
{
	s ret = "{"
	
	s key = ""
	for {
		s value = arr.GetNext(.key)
		q:(key = "")
		
		s value = ##class(EMR.ART.COM.String).EscapeJSON(value)
		
		if (ret '= "{") {s ret = ret_","}
		s ret = ret_""""_key_""":"_""""_value_""""
	}
	
	s ret = ret_"}"
	q ret
}

/// d ##Class(EMR.ART.COM.Parser.Json).test()
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

/// w ##Class(EMRservice.BL.StreamDataTool).Test()
ClassMethod TestNew()
{
	
	s obj=##Class(TestSrv.TestTemplate).%OpenId(3)

    s metadata = ##Class(%FileCharacterStream).%New()	
	s metadata.Filename="d:\metadata.txt"
	d metadata.TranslateTableSet("UTF8")
	d metadata.CopyFrom(..ParserStream(obj.TestData,"<MetaData","</MetaData>","11"))
    d metadata.SaveStream()
    d metadata.%Close()

    s stritps = ##Class(%FileCharacterStream).%New()	
	s stritps.Filename="d:\stritps.txt"
	d stritps.TranslateTableSet("UTF8")
	d stritps.CopyFrom(..ParserStream(obj.TestData,"<Scripts>","</Scripts>","10"))
    d stritps.SaveStream()
    d stritps.%Close()
	
	s Presentation = ##Class(%FileCharacterStream).%New()	
	s Presentation.Filename="d:\PresentationData.txt"
	d Presentation.TranslateTableSet("UTF8")
	d Presentation.CopyFrom(..ParserStream(obj.TestData,"<PresentationData>","</PresentationData>","19"))
    d Presentation.SaveStream()
    d Presentation.%Close()
}

/// w ##Class(EMRservice.BL.StreamDataTool).Test1()
ClassMethod Test1()
{
	s argInData = ##Class(%GlobalBinaryStream).%New()
	d argInData.Write("{""params"":""72_16-----------------------------8eb5b37251gef<html><head></head></html>""}")
	s tmpInData = ##Class(%GlobalBinaryStream).%New()
	d tmpInData.CopyFrom(argInData)
	s separator = "-----------------------------8eb5b37251gef"

		s tmpData = ##Class(%GlobalBinaryStream).%New()
		s tmpInData = ..GetFirstParserStream(tmpInData,separator,.tmpData)
		d tmpData.OutputToDevice()
		d tmpInData.OutputToDevice()
		w !
}

}
