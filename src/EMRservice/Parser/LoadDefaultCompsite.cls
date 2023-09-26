/// 名称:EMRservice.Parser.LoadDefaultCompsite
/// 描述:编辑器交互命令解析类
/// 编写者：Guozongtao
/// 编写日期: 2014-1-21
Class EMRservice.Parser.LoadDefaultCompsite Extends %RegisteredObject
{

Property action As %String;

Property DiseaseID As %String;

Property LocID As %String;

Property type As %String;

Property items As %ListOfDataTypes;

/// Creator：      guozongtao
/// CreatDate：    2014-1-21
/// Description:   命令反序列话
/// Table：        
/// Input：        Stream :命令信息 JSON格式{"params":{"action":"LOAD_DEFAULT_COMPOSITE","DiseaseID":"111","LocID":"A01","items":[{"BindKBBaseID":"160201"},{"BindKBBaseID":"160202"}]},"type":"action"}
/// Return：       函数返回值的说明
/// Others：       其它说明
/// Debug:         w ##Class(EMRservice.Parser.LoadDefaultCompsite).Test()
Method Deserialize(Stream As %GlobalBinaryStream)
{
	d:('Stream.AtEnd)
	s ch = Stream.Read(1)
	d ..PaserJson(Stream,ch)
	
	/*
	w ..action,!
	w ..type,!
	w ..DiseaseID,!
	w ..LocID,!
	For i=1:1:..items.Count()  Write ..items.GetAt(i),!
	*/
}

Method PaserJson(Stream As %GlobalBinaryStream, ch As %String)
{
	//s ch = Stream.Read(1)
	q:(Stream.AtEnd) 
	if (ch= "{")
	{
		s needNextElement = -1
		s ch = Stream.Read(1)
		while ('Stream.AtEnd) 
		{
		    q:((needNextElement = -1) && (ch ="}"))
		    s:(ch = "") ch =  Stream.Read(1)
		    s Name = ..parseName(Stream)
		    s value = ..parseValue("}",Stream)
	
		    if (Name="action")
		    {
			    s ..action=value
		    }
		    elseif(Name="DiseaseID")
		    {
			    s ..DiseaseID=value
		    }
		    elseif(Name="type")
		    {
			    s ..type=value
		    }
		    elseif(Name="items")
		    {
			    s ..items=value
		    }
		    elseif(Name="LocID")
		    {
			    s ..LocID=value
		    }
   		    s ch = Stream.Read(1)
	    }
	}
	q
}

Method parseArray(Stream As %GlobalBinaryStream) As %ListOfDataTypes
{
	s needNextElement = -1
	s ch = Stream.Read(1)
	s tmpjson=""
	while ('Stream.AtEnd)
	{
	   q:((needNextElement = -1) && (ch ="]"))
	   s:(ch = "") ch = Stream.Read(1)
	   s tmpjson=tmpjson_ch
	   s ch = Stream.Read(1)	
	}
	s tmpjson=$e(tmpjson,2,$l(tmpjson)-1) 
	s tmpjson=$tr(tmpjson,"""")
	S list=##class(%ListOfDataTypes).%New()
	for i=1:1:$l(tmpjson,"},{") {
		s tmpRow=$p(tmpjson,"},{",i)
		d list.Insert($p(tmpRow,":",2))
	}
	q list
}

Method parseName(Stream As %GlobalBinaryStream) As %String
{
    s name = ""
    while ('Stream.AtEnd )
    {
	    s ch = Stream.Read(1)
	    q:(ch = ":")
	    s name = name_ch
	}
	s name = $tr(name,"""","")
    q name
}

Method parseValue(endch As %String, Stream As %GlobalBinaryStream) As %String
{
	s ch = Stream.Read(1)
	q:(Stream.AtEnd)
	q:(ch = endch)
	s value = ""

	if (ch = "{")
	{
		d ..PaserJson(Stream,ch)
    }
	elseif (ch = "[")
	{
		s value=..parseArray(Stream)
	}else
	{
        while ('Stream.AtEnd )
        {
	        s ch = Stream.Read(1)
	        continue:((ch = "}") || (ch = "]"))
	        q:(ch = ",")
	        s value = value_ch
	    }
	    s value = $tr(value,"""","")
	}
	 q value
}

ClassMethod Test()
{
	s filename = "c:\LoadDefaultCompsite.txt"
	s isExisted = ##class(%File).Exists(filename) 
	If ('isExisted)
 	{
	 	Write !,"fliel is not exist!"
	 	quit
 	}
 	
 	s Stream =##class(%FileBinaryStream).%New()
	s Stream.Filename = filename

	s ActionObj=##Class(EMRservice.Parser.LoadDefaultCompsite).%New()
	
	d:('Stream.AtEnd) 
	d ActionObj.Deserialize(Stream)
	
	q
}

}
