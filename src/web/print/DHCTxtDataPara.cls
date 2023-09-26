Class web.print.DHCTxtDataPara Extends (%RegisteredObject, %XML.Adaptor) [ LegacyInstanceContext ]
{

Property name As %String(XMLPROJECTION = "ATTRIBUTE");

Property xcol As %String(XMLPROJECTION = "ATTRIBUTE");

Property yrow As %String(XMLPROJECTION = "ATTRIBUTE");

Property fontsize As %String(XMLPROJECTION = "ATTRIBUTE");

Property fontbold As %Boolean(XMLPROJECTION = "ATTRIBUTE");

Property fontname As %String(XMLPROJECTION = "ATTRIBUTE");

Property defaultvalue As %String(MAXLEN = 500, XMLPROJECTION = "ATTRIBUTE");

Property printvalue As %String(MAXLEN = 500, XMLPROJECTION = "ATTRIBUTE");

Property isqrcode As %String(XMLPROJECTION = "ATTRIBUTE");

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
	if (fontname="C39P36DmTt"){
		Set fontsize = %this.fontsize/##class(web.DHCPlatformPrint).#PT2PX
	}
	s printvalue = %this.printvalue
	s defaultvalue = $tr(%this.defaultvalue,$c(0),$c(-1))
	Set defaultvalue = $replace(defaultvalue,"""","""""")
	if defaultvalue[" "{
		set defaultvalue = $replace(defaultvalue," ","&nbsp;")
		
	}
	
	if %this.isqrcode="true"{
		Do routine.WriteLine(" w "" <img style='top:"_top_"px;left:"_left_"px;width:"_width_"px;height:"_height_"px;' src='../scripts/dhctt/xmldesigner/img/qr.png'/>""")
	}else{
		Do routine.WriteLine(" w "" <label style='top:"_top_"px;left:"_left_"px; font-size:"_fontsize_";"_fontboldstr_"; font-family:"""""_fontname_""""";'>""_$Case($g(mData("""_name_""")),"""":"""_defaultvalue_""",:$g(mData("""_name_""")))_""</label>""")
	}
}

}
