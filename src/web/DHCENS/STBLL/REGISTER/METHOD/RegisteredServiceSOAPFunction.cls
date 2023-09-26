Class web.DHCENS.STBLL.REGISTER.METHOD.RegisteredServiceSOAPFunction Extends (%RegisteredObject, %XML.Adaptor)
{

/// Input: 服务代码^方法代码^参数代码^功能描述^修改后的值^功能代码
ClassMethod UpdateRegisterSoapFunc(funcInfo As %String) As %String
{
	s $zt="err"
	s tSC = "0"
	s serviceCode=$p(funcInfo,"^",1)
	s methodCode=$p(funcInfo,"^",2)
	s parameterCode=$p(funcInfo,"^",3)
	s columndesc=$p(funcInfo,"^",4)
	s columnval=$p(funcInfo,"^",5)
	s oldFuncCode=$p(funcInfo,"^",6)
	
	s funcObj=##class(web.DHCENS.STBLL.REGISTER.MODEL.RegisteredServiceSOAPFunction).%New()
	if (columndesc="FunctionCode"){
		q:(columnval="") "-1^功能代码为空"
		s funcObj.FunctionCode=columnval
	}elseif (columndesc="FunctionDesc"){
		s funcObj.FunctionDesc=columnval
	}else{}
	s funcObj.ServiceCode=serviceCode
	s funcObj.MethodCode=methodCode
	s funcObj.ParameterCode=parameterCode
	s funcObj.UpdateDate=+$h
	s funcObj.UpdateTime=$p($h,",",2)
		
	s tSC=##class(web.DHCENS.STBLL.REGISTER.DAO.RegisteredServiceSOAPFunction).UpdateByObj(oldFuncCode,funcObj,.FunctionCode)
	if (tSC'=1){
		q tSC_"^"_$SYSTEM.Status.GetErrorText(tSC)
	}else{
	}
	q tSC
err
	q $ze
}

}
