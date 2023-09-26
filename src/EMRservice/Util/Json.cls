Class EMRservice.Util.Json Extends %RegisteredObject [ ProcedureBlock ]
{

Property Data As EMRservice.Util.JArr;

Property JsonString As %String;

Property Char As %String;

Property Pos As %Integer;

Property Length As %Integer;

ClassMethod Instance(type As %String = "Object") As EMRservice.Util.Json
{
	s obj = ##class(EMRservice.Util.Json).%New()
	s:(type = "Array") obj.Type = "Array"
	q obj
}

ClassMethod FromJson(AString) As EMRservice.Util.JArr
{
	s obj = ##class(EMRservice.Util.Json).%New()
	s arr = obj.Deserialize(AString)
	q arr
}

Method Put(key, value) As EMRservice.Util.Json
{
	//b "s"
	if ($this.Data = "")
	{	s $this.Data = ##class(EMRservice.Util.JArr).%New()}
	
	d $this.Data.SetAt(value,key)
	q $this
}

Method Add(value) As EMRservice.Util.Json
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
	
	s $this.Char = $e($this.JsonString, $this.Pos, $this.Pos)
}

/// Desc: 解析json流数据为json对象
Method Deserialize(AString As %String) As EMRservice.Util.JArr
{
	s Json = ##Class(EMRservice.Util.JArr).%New() 
	
	s $this.JsonString = AString
	s $this.Pos = 0
	s $this.Char = ""
	s $this.Length = $L($this.JsonString)
	
	d ..Next()
    while('..AtEnd()) 
    {
	    if ($this.Char = "{")
	    {
		    s Json = ..parseObject()
		    s Json.Type = "Object"
		}
		elseif ($this.Char = "[")
		{
			s Json = ..parseArray()
			s Json.Type = "Array"
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
	
	//处理无效的空格
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
	s value = ""
	s isDoubleQuotStart = "1"
	
	//读取第一个双引号
	if ($this.Char '= """")
	{
		s value = value_$this.Char
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
			   s value = value_"\"
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
				   s value = value_""""
				   d ..Next()
			   	   continue
			   }
			   elseif ($this.Char = "n")
			   {
				   s isEscOn = 0
				   s value = value_$c(10)
				   d ..Next()
			   	   continue
			   }
			   elseif ($this.Char = "r")
			   {
				   s isEscOn = 0
				   s value = value_$c(13)				   
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
	   
	   s value = value_$this.Char
	   d ..Next()
	}
	
	 if ($this.Char = """")
	 {
		 d ..Next()
     }
     
     q value
}

/// 返回格式为key1key2....
Method ToUrlParam2() As %String
{
	q:($this.Data = "") ""
	q:($this.Data.Count() = 0) ""
	
	s ret = ""
	
	s key = ""
	for {
		s value = $this.Data.GetNext(.key)
		q:(key = "")
		
		s ret = ret_value
	}
	q ret
}

}
