Class web.BDP.sys.EntityBroker Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// 类方法执行
ClassMethod CMExecute(classname As %String, classmethod As %String, entityname As %String) As %String
{
	;n (classname, classmethod, arryvalue)
	
	d ..XecuteStr(.myMethod, .classname, .classmethod, 1, entityname)
	s rs=""
	
	i myMethod'=""{
		XECUTE myMethod
	}
	s ^TMPExtRequest("extEntityBroker.CMExecute",%session.SessionId)=myMethod
	q rs
}

/// String to execute to run the desired method.
/// [Previously private]
ClassMethod XecuteStr(ByRef code As %String, cls As %String, method As %String, wantreturnval As %Boolean, entityname As %String) As %String
{
	;n (code , cls , method , wantreturnval , arrayvlaue)
	;w (arryvalue("id"))
	If wantreturnval {
		Set code="Set rs=##class("_cls_")."_method_"("
	} Else {
		Set code="Do ##class("_cls_")."_method_"("
	}
	
	s mycminlist=..GetCMInParaList(cls,method)
	
	s myColLen=$l(mycminlist, ",")
	s:(mycminlist="") myColLen=0
	f myIdx=1:1:myColLen {
		s myColStr=$p(mycminlist,",",myIdx)
		s myParaName = $p(myColStr,":",1)
		s myParaType = $p(myColStr,":",2)
		If myIdx>1 Set code=code_","
		
		i myParaName'=""{
			;;;;;s myflag = ##class(web.DHCBL.DSS.ClassMetadata).IsValidMethodName(entityname,"MultiDataD")
			s myflag = $s(+$$$comMemberDefined(entityname,$$$cCLASSmethod,"MultiDataD"):1, 1:0)
			i ((entityname[myParaType)&&(myflag)){
				m rData = %request.Data
				s syseobjbroker = "syseobjbroker"_myIdx
				s xcode = "s syseobjbroker"_myIdx _"= $ZOBJCLASSMETHOD(entityname, ""MultiDataD"", .rData)"
				x xcode
				Set code=code_syseobjbroker
				k rData
			}else{
				Set code=code_""""_$g(%request.Data(myParaName,1))_""""
			}
		}
	}
	s code=code_")"
	
	Quit $$$OK
}

ClassMethod GetCMInParaList(ClassName As %String = "", ClassMethod As %String = "", ExpStr As %String) As %String
{
	;w ##class(ext.websys.Broker).GetCMInParaList("ext.websys.Menu","ShowBarJson","")
	;n (ClassName,ClassMethod, ExpStr)
	
	s myrtn=""
	
	q:((ClassName="")!(ClassMethod="")) myrtn
	
	s myIsVal=##class(websys.Conversions).IsValidClassName(ClassName)
	
	q:('myIsVal) myrtn
	s myIsVal=##class(websys.Conversions).IsValidMethodName(ClassName,ClassMethod)
	q:('myIsVal) myrtn
	
	s myCID=ClassName_"||"_ClassMethod
	s myobj=##class(%Dictionary.MethodDefinition).%OpenId(myCID)
	
	q:('$IsObject(myobj)) myrtn
	
	s myrtn=##class(DHCCPMWeb.CPMBL.DHCBLCommFunLib).ParseInParaByFormalSpec( myobj.FormalSpec)
	
	d myobj.%Close()
	
	q myrtn
}

}
