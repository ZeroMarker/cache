Class DHCEPRFS.web.eprajax.AjaxInterfaceTest Extends %CSP.Page [ ClassType = "", ProcedureBlock ]
{

ClassMethod OnPage() As %Status
{
	s actionType = $Get(%request.Data("ActionType",1),"")
	
	if (actionType = "getcsp")
	{
		do ..GetCSP()
	}

	Quit $$$OK
}

/// debug: d ##class(DHCEPRFS.web.eprajax.AjaxInterfaceTest).GetCSP()
ClassMethod GetCSP() As %String
{
	s pageInfoID = ""
	s pageInfoID = $o(^DHCEPRM.CentralizedPrintInfoD(""))
	
	w "["
	s count=0
	s rowID = ""
	for {
		s rowID = $o(^DHCEPRFS.META.CTItemTypeD(rowID))
		q:(rowID = "")
		s count = count + 1
		if (count > 1) 
	 	{	w ","}
		
		s obj = ##class(DHCEPRFS.META.CTItemType).%OpenId(rowID)
		w "{TypeCode:'"_obj.TypeCode_"',"
	 	w "TypeName:'"_obj.TypeName_"',"
	 	w "TypeDesc:'"_obj.TypeDesc_"',"
		w "CSPPath:'"_obj.CSPPath_"',"
		w "PageInfoID:'"_pageInfoID_"',"
	 	w "Sequence:'"_obj.Sequence_"'}"
	}
	
	w "]"
}

}
