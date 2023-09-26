Class DHCWL.VerManagement.SetProVerNow Extends %RegisteredObject [ Not ProcedureBlock ]
{

//d ##class(DHCWL.VerManagement.SetProVerNow).SetProVerNow()

ClassMethod SetProVerNow() As %String
{
  Set rset = ##class(%ResultSet).%New("%ClassDefinition:SubclassOf")
  Set columns = rset.GetColumnCount()
  Set sc = rset.Execute("DHCWL.VerManagement.VerData")
  While (rset.Next())
	{
      s ProName=rset.GetData(1)
      s nameStr="s VM=##class("_ProName_").%New()"
      x nameStr
      d VM.GetPubVersion()
      s name=$p(^TMPDHCWL("VM",1),"^",1)
      s code=$p(^TMPDHCWL("VM",1),"^",2)
      i '$d(^DHCWL.VerManagement.VerDataI("Code"," "_code," "_name)) d
      .x nameStr
      .d VM.Insert() 
	}                       
 Do rset.Close()
  q 1
}

}
