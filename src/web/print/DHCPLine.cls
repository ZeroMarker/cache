Class web.print.DHCPLine Extends (%RegisteredObject, %XML.Adaptor)
{

Property BeginX As %String(XMLPROJECTION = "ATTRIBUTE");

Property BeginY As %String(XMLPROJECTION = "ATTRIBUTE");

Property EndX As %String(XMLPROJECTION = "ATTRIBUTE");

Property EndY As %String(XMLPROJECTION = "ATTRIBUTE");

Method ShowItem(routine)
{
	Do routine.WriteLine(" w !,""lineData.push({""""beginx"""":"""""_($this.BeginX*##class(web.DHCPlatformPrint).#PT2PX)
	_""""",""""beginy"""":"""""_($this.BeginY*##class(web.DHCPlatformPrint).#PT2PX)
	_""""",""""endx"""":"""""_($this.EndX*##class(web.DHCPlatformPrint).#PT2PX)
	_""""",""""endy"""":"""""_($this.EndY*##class(web.DHCPlatformPrint).#PT2PX)
	_"""""})""")
}

}
