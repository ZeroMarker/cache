Class web.DHCBL.BDP.BDPBroker Extends %RegisteredObject
{

/// 类方法执行
ClassMethod CMExecute(classname As %String, classmethod As %String) As %String
{
	;n (classname, classmethod, arryvalue)
	
	d ##class(web.BDP.sys.Broker).XecuteStr(.myMethod, .classname, .classmethod, "")
	s rs=""
	
	i myMethod'=""{
		XECUTE myMethod
	}
	s ^TMPExtRequest("extBroker.CMExecute",%session.SessionId)=myMethod
	q rs
}

}
