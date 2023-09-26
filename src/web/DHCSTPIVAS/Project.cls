Class web.DHCSTPIVAS.Project Extends %RegisteredObject
{

Parameter ProjectName = "PHA_PIVAS";

/// w ##class(web.DHCSTPIVAS.Project).Build()
ClassMethod Build()
{
	s cnt = 0
	s project = ..%New()
	
	s obj = ##class(%Studio.Project).%OpenId(..#ProjectName,0)
	if (obj = ""){
		s obj = ##class(%Studio.Project).%New()
		s obj.Name = ..#ProjectName
	}
	q:(obj = "") "处理工程失败"	

	d $system.OBJ.GetPackageList(.itmsArr, "web.DHCSTPIVAS")
	
	s itmName = ""
	for {
		s itmName = $o(itmsArr(itmName))
		q:(itmName = "")
		d obj.AddItem(itmName, "CLS")
		s cnt = cnt + 1
	}
	d obj.%Save()
	q "记录数:" _ cnt
}

}
