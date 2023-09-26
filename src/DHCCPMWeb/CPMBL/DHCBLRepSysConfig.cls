/// DHCCPM.DHCRepSysConfig
/// 操作系统配置的业务类
Class DHCCPMWeb.CPMBL.DHCBLRepSysConfig Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

ClassMethod DTOTransObj(ERSCObj As DHCCPMWeb.CPMSevice.entity.DHCERepSysConfig) As DHCCPM.DHCRepSysConfig
{
	n (ERSCObj)
	s myobj=""
	
	s ERSCObj.RowID=##class(DHCCPMWeb.CPMBL.DHCBLCommFunLib).TransNICPara(ERSCObj.RowID)
	
	s myRowID=ERSCObj.RowID
	i (myRowID'=""){
		s myobj=##class(DHCCPM.DHCRepSysConfig).%OpenId(myRowID)
	}else{
		s myobj=##class(DHCCPM.DHCRepSysConfig).%New()
	}
	s myobj.RSCCacheDType=ERSCObj.RSCCacheDType
	s myobj.RSCNetDateType=ERSCObj.RSCNetDateType
	d myobj.RSCXMLData.Rewind()
	d myobj.RSCXMLData.CopyFrom(ERSCObj.RSCXMLData)
	
	q myobj
}

/// 获得系统配置对象
ClassMethod GetRepSysConfig() As DHCCPMWeb.CPMSevice.entity.DHCERepSysConfig
{
	;s mysc=##class(DHCCPMWeb.CPMBL.DHCBLRepSysConfig).GetRepSysConfig()
	n (ad)
	
	s myobj=""
	
	s myRowID=$o(^DHCCPM.DHCRepSysConfigD(0))
	s myRSCObj=..ObjTransDTO(myRowID)
	
	q myRSCObj
}

ClassMethod ObjTransDTO(RSRowID As %String) As DHCCPMWeb.CPMSevice.entity.DHCERepSysConfig
{
	n (RSRowID)
	s myobj=""
	s myobj=##class(DHCCPMWeb.CPMSevice.entity.DHCERepSysConfig).%New()
	
	if '$IsObject(myobj){
		Quit myobj
	}
	if RSRowID'=""{
		s RSCObj=##class(DHCCPM.DHCRepSysConfig).%OpenId(RSRowID)
	}else{
		s RSCObj=##class(DHCCPM.DHCRepSysConfig).%New()
	}
	s myobj.RowID=RSRowID
	s myobj.RSCCacheDType=RSCObj.RSCCacheDType
	s myobj.RSCNetDateType=RSCObj.RSCNetDateType
	d myobj.RSCXMLData.Rewind()
	d myobj.RSCXMLData.CopyFrom(RSCObj.RSCXMLData)
	
	q myobj
}

/// 更新报表系统配置
ClassMethod UPDATE(ERSC As DHCCPMWeb.CPMSevice.entity.DHCERepSysConfig) As %String
{
	n (ERSC)
	;s myrtn=##class(DHCCPMWeb.CPMBL.DHCBLRepSysConfig).UPDATE()
	s $ZT="ERROR^DHCSSERR"
	
	s myrtn=0
	
	TStart
	s myobj=..DTOTransObj(ERSC)
	
	s mysc=myobj.%Save()
	
	s myRowID=myobj.%Id()
	
	d myobj.%Close()
	
	If $$$ISERR(mysc) {
    	s myrtn=-104
    }
    
	if (+myrtn=0){
		tc
	}else{
		tro
	}
	
	q myrtn_"^"_myRowID
}

}
