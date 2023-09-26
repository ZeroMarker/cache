IncludeGenerator %occInclude

Class ext.websys.Expression [ ClassType = datatype, ClientDataType = VARCHAR, OdbcType = VARCHAR, SqlCategory = STRING ]
{

ClassMethod Evaluate(eval As %String) As %String [ CodeMode = generator ]
{
	s %code=0
	///$$$I()
	$$$GENERATE(" s $zt=""expressionytrap""")
	$$$GENERATE(" k e")
	$$$GENERATE(" q:eval="""" """"")
	$$$GENERATE(" q @eval")
	$$$GENERATE("expressionytrap")
	$$$GENERATE(" s e=$ze")
	$$$GENERATE(" i $d(msg) d:msg msg.AddItem(""E"",""XEVALUATE"",$g(eval)_"" ""_$g(e)) ")
	$$$GENERATE(" q """"")
	q $$$OK
}

ClassMethod Execute(exp As %String) As %String [ CodeMode = generator ]
{
	s %code=0
	$$$GENERATE(" s $zt=""expressionztrap""")
	$$$GENERATE(" k e")
	$$$GENERATE(" i exp'="""" x exp")
	$$$GENERATE(" q """"")
	$$$GENERATE("expressionztrap")
	$$$GENERATE(" s e=$ze")
	$$$GENERATE(" i $d(msg) d:msg msg.AddItem(""E"",""XEVALUATE"",$g(exp)_"" ""_$g(e))")
	$$$GENERATE(" q """"")
	
	q $$$OK
}

}
