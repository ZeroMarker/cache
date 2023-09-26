Class EMRservice.Tools.PorgramMgr Extends %RegisteredObject [ ProcedureBlock ]
{

/// Desc:	校验患者签名相关的后台类方法
/// Debug:	d ##Class(EMRservice.Tools.PorgramMgr).CheckPatSign()
ClassMethod CheckPatSign()
{
	s m = ""
	
	//01 CA基础服务
	s m = m_$lb("CA.DigitalSignatureService|IsHandSignCAON:1|")
	s m = m_$lb("CA.ConfigCommon|GetValueByName:2|")
	
	//02 业务系统相关的类方法
	s m = m_$lb("EMRinstance.InstanceData||")
	s m = m_$lb("EMRinstance.PDF.AuditSignLog||")
	s m = m_$lb("EMRservice.Ajax.anySign||")
	s m = m_$lb("EMRservice.BL.BLPDFAuditSignLog|RegSignedPDF:6|")
	s m = m_$lb("EMRservice.SystemParameter|CAHandSign:1^CAHandSignVender:1^CAVersion:0^PDFLoadFormat:0|")
	
	s err = ""
	s count = $ll(m)
	for i = 1:1:count
	{
		s one = $lg(m,i)
		continue:(one = "")
		
		s clsName = $p(one,"|",1)
		s method = $p(one,"|",2)
		s property = $p(one,"|",3)
		s index = $p(one,"|",4)
		
		s sc = ..CheckMethod(clsName, method, property, index)
		if (sc = "1")
		{	w !,i_" ok "_one}
		else
		{	
			w !,i_" error "_one,!,"   "_$p(sc,"^",2)
			s err = err_$lb($p(sc,"^",2))
		}
	}
	s errCount = $LL(err)
	
	
	w !,!,"----------------- stat info -----------"
	w !,"totCount:"_count
	w !,"errCount:"_errCount
	w !,"errInfo:"
	
	for i = 1:1:errCount
	{
		w !, "    "_$lg(err, i)
	}
}

ClassMethod CheckMethod(clsName, methodList, propertyList, indexList) As %String
{
	s error = ""
	
	s isExist = ##class(%Dictionary.CompiledClass).%ExistsId(clsName)
	q:(isExist '= "1") "0^类不存在 "_clsName
	
	if (methodList '= "")
	{
		s count = $length(methodList,"^")
		for i = 1:1:count
		{
			s methodInfo = clsName_"||"_$p(methodList,"^",i)
			s methodID = $p(methodInfo,":",1)
			s paraCount = $p(methodInfo,":",2)
			s isExist = ##class(%Dictionary.CompiledMethod).%ExistsId(methodID)
			if (isExist '= "1") 
			{	s error = error_$lb("类方法不存在 "_methodID) }
			else
			{	
				if (paraCount '= "")
				{
					s count = $ll((##class(%Dictionary.CompiledMethod).%OpenId(methodID)).DefaultArgs)
					if (count '= paraCount) 
					{
						s error = error_$lb("类方法参数不一致 "_methodID_" 要求参数:"_paraCount_" 实际参数:"_count)
					}
				}
			}
		}
		if (error '= "")
		{
			q "0^"_$lts(error,"; ")
		}
	}
	
	if (propertyList '= "")
	{
		s error = ""
		s count = $length(propertyList,"^")
		for i = 1:1:count
		{
			s propID = clsName_"||"_$p(propertyList,"^",i)
			s isExist = ##class(%Dictionary.CompiledProperty).%ExistsId(propID)
			s:(isExist '= "1") error = error_$lb(propID)
		}
		if (error '= "")
		{
			q "0^类属性不存在 "_$lts(error,"; ")
		}
	}
	
	if (indexList '= "")
	{
		s error = ""
		s count = $length(indexList,"^")
		for i = 1:1:count
		{
			s indexID = clsName_"||"_$p(indexList,"^",i)
			s isExist = ##class(%Dictionary.CompiledIndex).%ExistsId(indexID)
			s:(isExist '= "1") error = error_$lb(indexID)
		}
		if (error '= "")
		{
			q "0^类索引不存在 "_$lts(error,"; ")
		}
	}
	
	q "1"
}

}
