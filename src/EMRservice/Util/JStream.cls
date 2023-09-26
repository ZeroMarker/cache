Class EMRservice.Util.JStream Extends %RegisteredObject [ ProcedureBlock ]
{

Property Data As EMRservice.Util.JArr;

Property JsonString As %String;

Property JsonStream As %GlobalBinaryStream;

Property Char As %String;

Property Pos As %Integer;

Property PhasePos As %Integer;

Property Length As %Integer;

ClassMethod Instance(type As %String = "Object") As EMRservice.Util.JStream
{
	s obj = ##class(EMRservice.Util.JStream).%New()
	s:(type = "Array") obj.Type = "Array"
	s obj.JsonStream = ##Class(%GlobalBinaryStream).%New()
	q obj
}

ClassMethod FromJson(AString) As EMRservice.Util.JArr
{
	s obj = ##class(EMRservice.Util.JStream).%New()
	s arr = obj.Deserialize(AString)
	q arr
}

Method Put(key, value) As EMRservice.Util.JStream
{
	//b "s"
	if ($this.Data = "")
	{	s $this.Data = ##class(EMRservice.Util.JArr).%New()}
	
	d $this.Data.SetAt(value,key)
	q $this
}

Method Add(value) As EMRservice.Util.JStream
{
	//b "s"
	if ($this.Data = "")
	{	s $this.Data = ##class(EMRservice.Util.JArr).%New()}
	
	d $this.Data.Add(value)
	q $this
}

Method ToJson() As %String
{
	q:($this.Data = "") ""
	q:($this.Data.Count() = 0) ""
	
	q $this.Data.ToJson()
}

Method ToJsonStream() As %Stream
{
	q:($this.Data = "") ""
	q:($this.Data.Count() = 0) ""
	
	q $this.Data.ToJsonStream()
}

Method ToArray() As EMRservice.Util.JArr
{
	q:($this.Data = "") ##Class(EMRservice.Util.JArr).%New()
	q $this.Data
}

Method ToUrlParam() As %String
{
	q:($this.Data = "") ""
	q:($this.Data.Count() = 0) ""
	
	q $this.Data.ToUrlParam()
}

Method AtEnd() As %Boolean
{
	q $this.Pos > $this.Length
}

/// Desc: 移动流数据指针位置
Method Next()
{
	s $this.Pos = $this.Pos + 1
	if ($this.Pos > $this.Length)
	{
		s $this.Char = ""
		quit
	}
	
	s $this.PhasePos = $this.PhasePos + 1
	if ($this.PhasePos > 32000)
	{
		s $this.JsonString = $this.JsonStream.Read(32000)
		s $this.PhasePos = 1
	}
	
	s $this.Char = $e($this.JsonString, $this.PhasePos, $this.PhasePos)
}

/// Desc: 解析json流数据为json对象
Method Deserialize(AString As %String) As EMRservice.Util.JArr
{
	//b "s"
	
	s Json = ##Class(EMRservice.Util.JArr).%New() 
	
	if ($this.JsonStream = "")||($this.JsonStream.Size > 0)
	{
		s $this.JsonStream = ##Class(%GlobalBinaryStream).%New()
	}
	
	if ($IsObject(AString))
	{
		d $this.JsonStream.CopyFrom(AString)
		d $this.JsonStream.Rewind()
		s $this.JsonString = $this.JsonStream.Read(32000)
		s $this.Length = $this.JsonStream.Size
	}
	else
	{
		d $this.JsonStream.Write(AString)
		d $this.JsonStream.MoveTo(32000)
		s $this.JsonString = $e(AString,1,32000)	
		s $this.Length = $L(AString)
	}
	
	s $this.Pos = 0
	s $this.PhasePos = 0
	s $this.Char = ""
		
	d ..Next()
    while('..AtEnd()) 
    {
	    if ($this.Char = "{")
	    {
		    s Json = ..parseObject()
		}
		elseif ($this.Char = "[")
		{
			s Json = ..parseArray()
		}
		d ..Next()
	}
	
	s $this.Data = Json
	
	q Json
}

/// Desc:解析json对象
Method parseObject() As EMRservice.Util.JArr
{
	//b "s"
	
	s ObjJson = ##Class(EMRservice.Util.JArr).%New()
	s ObjJson.Type = "Object"
	
	s needNextElement = -1
	d ..Next()
	while ('..AtEnd()) 
	{
		//b "s"
	    q:((needNextElement = -1) && ($this.Char ="}"))
	    if (($this.Char = "")||($this.Char = " "))
	    {
		   d ..Next()
		}
		else
		{
		   s Name = ..parseName()
		   s value = ..parseValue("}")
		   d ObjJson.SetAt(value,Name)
		   if ($this.Char = "}")
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
    if ($this.Char = "}")
    {
	    d ..Next()
	}
    q ObjJson
}

/// Desc:解析josn数组
Method parseArray() As EMRservice.Util.JArr
{
	s ListValue = ##Class(EMRservice.Util.JArr).%New()
	s ListValue.Type = "Array"
	
	s needNextElement = -1
	d ..Next()
	while ('..AtEnd())
	{
	   //b "s"
	   q:((needNextElement = -1) && ($this.Char = "]"))
       if ($this.Char = "")
       {
	       d ..Next()
	   }
	   else
	   {
		   s value = ..parseValue("]") 
		   d ListValue.Add(value)
		   if ($this.Char = "]")
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
	if ($this.Char = "]")
	{
		d ..Next()
	}
	q ListValue
}

/// Desc:获取json键值对名称
Method parseName() As %String
{
    s name = ..parseNameString()
	//d:($this.Char = ":") ..Next()
	if ($this.Char = ":") 
	{
		d ..Next()
	}
	else
	{
		while ('..AtEnd())
		{
			//处理Key:之前的空格或其他无效字符，如 "key"   :"value"
			d ..Next()
			q:($this.Char = ":")
		}
		d ..Next()
	}
    q name
}

/// Desc:获取json键值对值
Method parseValue(endch As %String) As %String
{
	//b "s"
	
	s value = ""
	
	while ('..AtEnd())
	{
		if (($this.Char = "")||($this.Char = " "))
		{
			d ..Next()
			continue
		}
		quit
	}
	
	if ($this.Char = "{")
	{
		s value = ..parseObject()
	}
	elseif ($this.Char = "[")
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
Method parseNameString() As %String
{
	//b "s"
	s value = ""
	
	//读取第一个双引号
	d ..Next()
	
	while ('..AtEnd())
    {
	   q:($this.Char = """")
	   s value = value_$this.Char
	   d ..Next()
	}
	
	 if ($this.Char = """")
	 {
		 d ..Next()
     }
     
     q value
}

/// Desc:取值
Method parseString() As %String
{
	//b "s"
	//s value = ""
	s value = ##class(%GlobalBinaryStream).%New()
	s isDoubleQuotStart = "1"
	
	//读取第一个双引号
	if ($this.Char '= """")
	{
		//s value = value_$this.Char
		d value.Write($this.Char)
		s isDoubleQuotStart = "0"
	}
	d ..Next()
	
	s isEscOn = 0
	while ('..AtEnd())
    {
	   //b "s"
	   if ($this.Char = "\")
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
			   //s value = value_"\"
			   d value.Write("\")
			   d ..Next()
			   continue
		   }
	   }
	   else
	   {
		   if (isEscOn = 1)
		   {
			   if ($this.Char = """")
			   {
				   s isEscOn = 0
				   //s value = value_""""
				   d value.Write("""")
				   d ..Next()
			   	   continue
			   }
			   elseif ($this.Char = "n")
			   {
				   s isEscOn = 0
				   //s value = value_$c(10)
				   d value.Write($c(10))
				   d ..Next()
			   	   continue
			   }
			   elseif ($this.Char = "r")
			   {
				   s isEscOn = 0
				   //s value = value_$c(13)				   
				   d value.Write($c(13))
				   d ..Next()
			   	   continue
			   }
		   }
	   }
	   
	   
	   //q:(isDoubleQuotStart = "0")&&($this.Char = ",")
	   //q:($this.Char = """")
	   if (isDoubleQuotStart = "0")
	   {
		   //值不是以双引号开头时，结束符可以是 , } ]
		   q:($this.Char = ",")||($this.Char = "}")||($this.Char = "]")
	   }
	   else
	   {
		   //值以双引号开头时，结束符只能是双引号
		   q:($this.Char = """")
	   }
	   
	   //s value = value_$this.Char
	   d value.Write($this.Char)
	   d ..Next()
	}
	
	 if ($this.Char = """")
	 {
		 d ..Next()
     }
     
     //b //10001
     q value
}

}
