Import CacheObject

Class CHSSWeb.TestStream Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

ClassMethod Test() As %String
{
		//objstream As CacheObject.BinaryStream
		//s objstream = ##class(CacheObject.BinaryStream).%New()
		Set p = ##class(TestPerson).%New()
    	Set p.Name = "Mo"
   		Do p.Memo.WriteLine("This is part one of a long memo")
  
    	// ...

    	Do p.Memo.WriteLine("This is part 10000 of a long memo")
    	s file = "D:\123.jpg"
    	///d p.ddd.FileRead(file)
	
    	Do p.%Save()

    	Do p.%Close()
}

ClassMethod Update() As %String
{
		//objstream As CacheObject.BinaryStream
		//s objstream = ##class(CacheObject.BinaryStream).%New()
		
		Set stream = ##class(%GlobalBinaryStream).%New()
		d stream.Read("D:\123.jpg")
		Do stream.SaveStream()
		d stream.FileWrite("D:\1234.jpg")
		
		q ""
		Set p = ##class(TestPerson).%OpenId(1)
    	w p.Name,!
    	s file = "D:\123.jpg"
    	s objstream = p.ddd
    	d p.ddd.Read(file)
	
    	Do p.%Save()
		d p.ddd.FileWrite("D:\1234.jpg")
    	Do p.%Close()
}

Storage Default
{
<Data name="TestStreamDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^CHSSWeb.TestStreamD</DataLocation>
<DefaultData>TestStreamDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSSWeb.TestStreamD</IdLocation>
<IndexLocation>^CHSSWeb.TestStreamI</IndexLocation>
<StreamLocation>^CHSSWeb.TestStreamS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
