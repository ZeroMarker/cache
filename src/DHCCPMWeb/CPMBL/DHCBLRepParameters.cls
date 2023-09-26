Class DHCCPMWeb.CPMBL.DHCBLRepParameters Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

/// DTOTransObj
ClassMethod DTOTransObj(ERepPara As DHCCPMWeb.CPMSevice.entity.DHCERepParameters) As DHCCPM.DHCRepParameters
{
	;w ##class(DHCCPMWeb.CPMBL.DHCBLRepParameters).DTOTransObj()
	n (ERepPara)
	
	s myrepara=""
	s myRowID=ERepPara.RowID
	if (myRowID'=""){
		s myrepara=##class(DHCCPM.DHCRepParameters).%OpenId(myRowID)
	}else{
		s myrepara=##class(DHCCPM.DHCRepParameters).%New()
	}
	
	s myrepara.RPRCaption=ERepPara.RPRCaption
	s myrepara.RPRDefaultValue=ERepPara.RPRDefaultValue
	s myrepara.RPRName=ERepPara.RPRName
	s myrepara.RPRType=ERepPara.RPRType
	s myrepara.RPRValue=ERepPara.RPRValue
	
	q myrepara
}

/// 把数据库中的对象转换为DTO
ClassMethod OBJTransDTO()
{
}

}
