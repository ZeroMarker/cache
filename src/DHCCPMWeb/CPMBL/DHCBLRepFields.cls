Class DHCCPMWeb.CPMBL.DHCBLRepFields Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

/// 把新的Field增加到数据库中
ClassMethod AddNewField(ERepFD As DHCCPMWeb.CPMSevice.entity.DHCERepFields) As %String
{
	n (ERepFD)
	s myrtn=""
	
	q myrtn
}

/// 删除Custom类型的Field
ClassMethod DELETE(RowID As %String) As %String
{
	n (RowID)
	s myrtn=""
	
	q myrtn
}

/// DTOTransObj
ClassMethod DTOTransObj(ERepFD As DHCCPMWeb.CPMSevice.entity.DHCERepFields) As DHCCPM.DHCRepFields
{
	;w ##class(DHCCPMWeb.CPMBL.DHCBLRepFields).DTOTransObj()
	n (ERepFD)
	s myrepfd=""
	
	s ERepFD.RowID=##class(DHCCPMWeb.CPMBL.DHCBLCommFunLib).TransNICPara(ERepFD.RowID)
	
	s myRowID=ERepFD.RowID
	if (myRowID'=""){
		s myrepfd=##class(DHCCPM.DHCRepFields).%OpenId(myRowID)
	}else{
		s myrepfd=##class(DHCCPM.DHCRepFields).%New()
	}
	
	s myrepfd.RFCaption=ERepFD.RFCaption
	s myrepfd.RFDataType=ERepFD.RFDataType
	s myrepfd.RFDefaultValue=ERepFD.RFDefaultValue
	s myrepfd.RFName=ERepFD.RFName
	s myrepfd.RFDescription=ERepFD.RFDescription
	s myrepfd.RFDisplayType=ERepFD.RFDisplayType
	s myrepfd.RFType=ERepFD.RFType
	
	q myrepfd
}

/// 得到一个新的Custom类型的Filed
ClassMethod GetNewField(RPRowID As %String) As DHCCPMWeb.CPMSevice.entity.DHCERepFields
{
	;s myfd=##class(DHCCPMWeb.CPMBL.DHCBLRepFields).GetNewField()
	n (RPRowID)
	
	s myobj=##class(DHCCPMWeb.CPMSevice.entity.DHCERepFields).%New()
	
	s myrtn=##class(DHCCPMWeb.CPMBL.DHCBLRepPanels).CheckCurSelRepPanel(RPRowID)
	q:(+myrtn) myobj
	
	s myIdx=$i(^DHCCPM.FDUnique)
	
	s myobj.RFCaption=       "自定义元素"_myIdx
	s myobj.RFDataType=      "string"
	s myobj.RFDefaultValue=  ""
	s myobj.RFName=          "Custom"_myIdx
	s myobj.RFDescription=   "自定义元素"
	s myobj.RFDisplayType=   ""
	s myobj.RFType=          "C"
	
	q myobj
}

/// 获得系统的数据列表
ClassMethod GetSysFields() As %List
{
	;w ##class(DHCCPMWeb.CPMBL.DHCBLRepFields).GetSysFields()
	n (ad)
	
	q myList
}

/// 把数据库中的对象转换为DTO
ClassMethod OBJTransDTO(RFRowID As %String) As DHCCPMWeb.CPMSevice.entity.DHCERepFields
{
	;w ##class().OBJTransDTO()
	n (RFRowID)
	s RFRowID=##class(DHCCPMWeb.CPMBL.DHCBLCommFunLib).TransNICPara(RFRowID)
	
	s myERFObj=##class(DHCCPMWeb.CPMSevice.entity.DHCERepFields).%New()
	q:(RFRowID="") myERFObj
	
	s myobj=##class(DHCCPM.DHCRepFields).%OpenId(RFRowID)
	
	s myERFObj.RFCaption=       myobj.RFCaption
	s myERFObj.RFDataType=      myobj.RFDataType
	s myERFObj.RFDefaultValue=  myobj.RFDefaultValue
	s myERFObj.RFName=          myobj.RFName
	s myERFObj.RFDescription=   myobj.RFDescription
	s myERFObj.RFDisplayType=   myobj.RFDisplayType
	s myERFObj.RFType=          myobj.RFType
	
	q myERFObj
}

}
