Class EMRservice.Util.JArr Extends %ArrayOfDataTypes [ ProcedureBlock ]
{

Property Type As %String(DISPLAYLIST = ",Object,Array", SELECTIVITY = "33.3333%", TRUNCATE = 0, VALUELIST = ",Object,Array") [ InitialExpression = "Object" ];

ClassMethod Instance(AType As %String = "Object") As EMRservice.Util.JArr
{
	s o = ##class(EMRservice.Util.JArr).%New()
	s o.Type = AType
	q o
}

Method Put(key, value) As EMRservice.Util.JArr
{
	d $this.SetAt(value,key)
	q $this
}

Method Add(value) As EMRservice.Util.JArr
{
	s key = $this.Count() + 1
	d $this.SetAt(value,key)
	q $this
}

Method ToJson() As %String
{
	//Json对象或数组的开始标签
	if ($this.Type = "Array") 
	{	s ret = "[" }
	else
	{	s ret = "{"}
	
	
	s key = "",count = 0
	for {
		s value = $this.GetNext(.key)
		q:(key = "")
		
		s count = count + 1
		if (count > 1) {s ret = ret_","}
		
		if ($IsObject(value))
		{
			s str = value.ToJson()
			if ($this.Type = "Array")
			{
				s ret = ret_str
			}
			else
			{
				s ret = ret_""""_key_""":"_str
			}
		}
		else
		{
			s str = ##class(EMRservice.Util.String).EscapeJSON(value)
			if ($this.Type = "Array")
			{
				s ret = ret_""""_str_""""
			}
			else
			{
				s ret = ret_""""_key_""":"_""""_str_""""
			}
		}
	}
	
	//Json对象或数组的结束标签
	if ($this.Type = "Array") 
	{	s ret = ret_"]" }
	else
	{	s ret = ret_"}"}
	
	q ret
}

Method ToJsonStream() As %Stream
{
	s ret = ##class(%GlobalCharacterStream).%New()
	
	//Json对象或数组的开始标签
	if ($this.Type = "Array") 
	{	d ret.Write("[") }
	else
	{	d ret.Write("{")}
	
	
	s key = "",count = 0
	for {
		s value = $this.GetNext(.key)
		q:(key = "")
		
		//多个对象间的分割符
		s count = count + 1
		if (count > 1) {d ret.Write(",")}
		
		if ($IsObject(value))
		{
			s clsName = $ClassName(value)
			if (clsName = "EMRservice.Util.JArr")
			{
				// 处理数组对象 [{"key":"value"}]，stream字符流值为其中的 {"key":"value"}
				// 处理对象 {"key":"stream字符流"}
				s stream = value.ToJsonStream()
				if ($this.Type = "Array")
				{
					d ..AppendStream(.ret, .stream)
				}
				else
				{
					d ret.Write(""""_key_""":")
					d ..AppendStream(.ret, .stream)
				}
			}
			else 	
			{
				////(clsName = "%Library.GlobalCharacterStream")
				// 处理数组字符串 ["stream字符流"]
				// 处理对象字符串 {"key":"stream字符流"} 
				s stream = ##Class(EMRservice.Util.String).EscapeJsonStream(value)
				if ($this.Type = "Array")
				{
					d ret.Write("""")
					d ..AppendStream(.ret, .stream)
					d ret.Write("""")
				}
				else
				{
					d ret.Write(""""_key_""":"_"""")
					d ..AppendStream(.ret, .stream)
					d ret.Write("""")
				}
			}		
		}
		else
		{
			// 处理数组字符串 ["str字符串"]
			// 处理对象字符串 {"key":"str字符串"} 
			s str = ##class(EMRservice.Util.String).EscapeJSON(value)
			if ($this.Type = "Array")
			{
				d ret.Write(""""_str_"""")
			}
			else
			{
				d ret.Write(""""_key_""":"_""""_str_"""")
			}
		}
	}
	
	//Json对象或数组的结束标签
	if ($this.Type = "Array") 
	{	d ret.Write("]") }
	else
	{	d ret.Write("}")}
	
	q ret
}

Method ToUrlParam() As %String
{
	q:($this.Count()=0) ""
	
	s ret = ""
	
	s key = ""
	for {
		s value = $this.GetNext(.key)
		q:(key = "")
		
		if (ret '= "") {s ret = ret_"&"}
		s ret = ret_key_"="_value
	}
	
	q ret
}

ClassMethod AppendStream(ByRef toStream As %Stream, ByRef fromStream As %Stream)
{
	d fromStream.Rewind()
	while (fromStream.AtEnd = 0)
	{
		d toStream.Write(fromStream.Read(32000))
	}
}

Storage Custom
{
<Type>%Library.CompleteCustomStorage</Type>
}

}
