Class web.DHCBL.BDP.ClassDefine Extends %RegisteredObject [ Not ProcedureBlock ]
{

ClassMethod ObjectParameter(class As %String, parameter As %String, paraValue As %String = "") As %Status
{
	n (class, parameter, paraValue)
	;q:$$$ERROR("类不存在,不能定义参数")
	
	s classobj = ##class(%Dictionary.ClassDefinition).%OpenId(class)
	s paraobj = ##class(%Dictionary.ParameterDefinition).%New()
	s paraobj.Name= parameter
	s paraobj.Default = paraValue
	d classobj.Parameters.Insert(paraobj)
	d classobj.%Save()
	
	k classobj, paraobj
	
	QUIT $$$OK
}

}
