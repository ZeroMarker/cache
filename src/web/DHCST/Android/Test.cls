Class web.DHCST.Android.Test Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// creator:yunhaibao
/// createdate:20160922
/// description:药库pda测试用
/// input:批次id
/// w ##class(web.DHCST.Android.Test).InsertIncBatPack("5729||2||2")
/// 
ClassMethod InsertIncBatPack(inclb)
{
	s inci=+inclb
	s incich=$p(inclb,"||",2)
	s incilb=$p(inclb,"||",3)
	s locdr=$p(^INCI(inci,"IL",incich),"^",1)
	s puom=$p(^INCI(inci,3),"^",6)
	s incib=$p(^INCI(inci,"IL",incich,"LB",incilb),"^",1)
	s printflag=1
	s qty=100
	s parbarcode="987414997"
	s barcode="987414997"
	d ##class(web.DHCST.Android.UnPack).InsIncBatPack(inclb, barcode, puom, qty, parbarcode, locdr, printflag)
	q ""
}

/// w ##class(web.DHCST.Android.Test).TestExecute("web.DHCST.Android.UnPack","QueryIncBatPackList","102^987414997")
ClassMethod TestExecute(className As %String, methodName As %String, params = "", type = "") As %String
{
	s executestring="s returnstream=##class("_className_")."_methodName_"("
	s parametersNum=##class(web.DHCST.Android.Execute).GetParamCount(className,methodName)
	f i=1:1:parametersNum{
		s parameterName=##class(web.DHCST.Android.Execute).GetParamName(className,methodName,i)
		s parameterVal="" //$g(%request.Data(parameterName,1))
		s parameterVal=$p(params,"^",i)
		s executestring=executestring_""""_parameterVal_""""
		i i'=parametersNum s executestring=executestring_","
	}
	s executestring=executestring_")"
	x executestring
	q returnstream
}

/// 记录参数
/// w ##class(web.DHCST.Android.Execute).RemParams("web.DHCST.Android.Execute","RemParams")
ClassMethod RemParams(className, classMethod)
{
	
	s methodParameter=$G(^oddCOM(className,"m",classMethod,60))
	s parameterNum=$ll(methodParameter)
	s parameteri=""
	f parameteri=1:1:parameterNum {
		s parameter=$li(methodParameter,parameteri)
		s parameterName=$li(parameter,1)
		s parameterVal=$g(%request.Data(parameterName,1))
		b //2
	}
	q
}

}
