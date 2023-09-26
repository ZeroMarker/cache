Class web.print.DHCPICDataPara Extends (%RegisteredObject, %XML.Adaptor) [ LegacyInstanceContext ]
{

Property name As %String(XMLPROJECTION = "ATTRIBUTE");

Property xcol As %String(XMLPROJECTION = "ATTRIBUTE");

Property yrow As %String(XMLPROJECTION = "ATTRIBUTE");

Property fontsize As %String(XMLPROJECTION = "ATTRIBUTE");

Property fontbold As %Boolean(XMLPROJECTION = "ATTRIBUTE");

Property fontname As %String(XMLPROJECTION = "ATTRIBUTE");

Property defaultvalue As %String(MAXLEN = 500, XMLPROJECTION = "ATTRIBUTE");

Property printvalue As %String(MAXLEN = 500, XMLPROJECTION = "ATTRIBUTE");

Property width As %String(XMLPROJECTION = "ATTRIBUTE");

Property height As %String(XMLPROJECTION = "ATTRIBUTE");

Method ShowItem(routine)
{
	s name = %this.name
	s top = %this.yrow*##class(web.DHCPlatformPrint).#PT2PX
	s left = %this.xcol*##class(web.DHCPlatformPrint).#PT2PX
	s fontsize = %this.fontsize_"pt"
	s fontbold = %this.fontbold
	if fontbold=1{
		s fontboldstr = "font-weight:900;"
	}else{
		s fontboldstr = "" ;"font-weight:600;"
	}
	s width=%this.width*##class(web.DHCPlatformPrint).#PT2PX
	s height=%this.height*##class(web.DHCPlatformPrint).#PT2PX
	s fontname = %this.fontname
	s printvalue = %this.printvalue
	s defaultvalue = $tr(%this.defaultvalue,$c(0),$c(-1))
	Do routine.WriteLine(" w "" <img style='top:"_top_"px;left:"_left_"px;width:"_width_";height:"_height_"' src='""_$g(mData("""_name_"""),"""_(defaultvalue)_""")_""'/> "" ")
}

}
