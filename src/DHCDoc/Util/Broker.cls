Class DHCDoc.Util.Broker Extends %CSP.Page
{

ClassMethod OnPreHTTP() As %Boolean
{
    d ##Class(websys.SessionEvents).SessionExpired()
	Q 1
}

ClassMethod OnPage() As %Status
{
	s ClassName=$g(%request.Data("ClassName",1))
	s MethodName=$g(%request.Data("MethodName",1))
	s QueryName=$g(%request.Data("QueryName",1))
	if MethodName'=""{
		s retObj=..RunClassMethod(ClassName, MethodName)
	}elseif (QueryName'=""){
		s DataType=$g(%request.Data("DataType",1))
		s retObj=..RunQuery(ClassName, QueryName, DataType)
	}
	Q ..OutputToDevice(retObj)
}

ClassMethod RunClassMethod(ClassName, MethodName)
{
	s obj=##class(%Dictionary.MethodDefinition).%OpenId(ClassName_"||"_MethodName,0)
	s FormalSpec=obj.FormalSpec
	s ArgCnt=$L(FormalSpec,",")
	if ArgCnt{
		if $D(%request.Data("P1")){
			for i=1:1:ArgCnt{
				s Args($I(Args))=$G(%request.Data("P"_i,1))
			}
		}else{
			for i=1:1:ArgCnt{
				s OneFormalSpec=$P(FormalSpec,",",i)
				continue:OneFormalSpec=""
				s ArgName=$TR($P($P(OneFormalSpec,":",1),"=",1)," ")
				s Args($I(Args))=$G(%request.Data(ArgName,1))
			}
		}
	}
	Q $ClassMethod(ClassName,MethodName,Args...)
}

ClassMethod RunQuery(ClassName, QueryName, DataType = "")
{
	s rs=##class(%ResultSet).%New(ClassName_":"_QueryName)
	s ArgCnt=rs.GetParamCount()
	if ArgCnt{
		if $D(%request.Data("P1")){
			for i=1:1:ArgCnt{
				s Args($I(Args))=$G(%request.Data("P"_i,1))
			}
		}else{
			for i=1:1:ArgCnt{
				s Args($I(Args))=$G(%request.Data(rs.GetParamName(i),1))
			}
		}
	}
	s retObj=##class(DHCDoc.Util.QueryToJSON).%New(ClassName,QueryName,Args...)
	s DataType=$ZCVT(DataType,"U")
	if (DataType="GRID"){
		Q retObj.ToGrid()
	}
	if (DataType="JQGRID"){
		Q retObj.ToJQGrid()
	}
	Q retObj.ToArray()
}

ClassMethod OutputToDevice(retObj)
{
	if $IsObject(retObj){
		s Class=$ClassName(retObj)
		if ..ExsitMethod(Class, "%ToJSON"){
			s stream=##class(%GlobalCharacterStream).%New()
			d retObj.%ToJSON(.stream)
			d stream.OutputToDevice()
		}elseif ..ExsitMethod(Class, "OutputToDevice"){
			d retObj.OutputToDevice()
		}elseif ..ExsitMethod(Class, "XMLExportToStream"){
			d retObj.XMLExportToStream(.stream,"Response")
			d stream.OutputToDevice()
		}
	}else{
		w retObj
	}
	Q $$$OK
}

ClassMethod ExsitMethod(ClassName, MethodName)
{
	Q:(ClassName="")||(MethodName="") 0
	s ret=##class(%Dictionary.MethodDefinition).%ExistsId(ClassName_"||"_MethodName)
	if 'ret{
		s cm=##class(%Dictionary.ClassDefinition).%OpenId(ClassName)
		s Supers=cm.Super
		for i=1:1:$L(Supers,","){
			s ret=..ExsitMethod($P(Supers,",",i), MethodName)
			Q:ret
		}
	}
	Q ret
}

}
