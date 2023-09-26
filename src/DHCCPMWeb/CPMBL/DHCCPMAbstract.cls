Class DHCCPMWeb.CPMBL.DHCCPMAbstract Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Property LName As %String(TRUNCATE = 1);

Method Test(Arg1 As %RegisteredObject) As %String
{
}

ClassMethod ListProperties() [ CodeMode = objectgenerator ]
{
	;w ##class(DHCCPMWeb.CPMBL.DHCCPMAbstract).ListProperties()
    b
    For i = 1:1:%compiledclass.Properties.Count() {
        Set prop = %compiledclass.Properties.GetAt(i).Name
        Do %code.WriteLine(" Write """ _ prop _ """,!")
    }
    Do %code.WriteLine(" Quit")
   	b
    Quit $$$OK
}

Method DDD()
{
	;s myobj=##class(DHCCPMWeb.CPMBL.DHCCPMAbstract).%New()
	;d ##class(DHCCPMWeb.CPMBL.DHCCPMAbstract).DDD()
    b
    For i = 1:1:%compiledclass.Properties.Count() {
        Set prop = %compiledclass.Properties.GetAt(i).Name
        Do %code.WriteLine(" Write """ _ prop _ """,!")
    }
    Do %code.WriteLine(" Quit")
   	b
    Quit $$$OK
}

}
