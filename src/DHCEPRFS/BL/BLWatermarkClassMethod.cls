Class DHCEPRFS.BL.BLWatermarkClassMethod Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

ClassMethod Date(AUserID As %String) As %String
{
	q:(AUserID ="") ""
	s date = $zd($h,3)
	q date
}

/// debug:w ##class(DHCEPRFS.BL.BLWatermarkClassMethod).Empno(159)
ClassMethod Empno(AUserID As %String) As %String
{
	q:(AUserID ="") ""
	s userCode = ""
	if ($l(AUserID,"^")=1)
	{
		s userCode = ##class(DHCEPRFS.BL.HISInfo.BLHISInfo).GetUserCode(AUserID)
	}
	elseif ($l(AUserID,"^")=2)
	{
		s rowID = $p(AUserID,"^",2)
		s obj = ##class(DHCEPRFS.META.QueryUser).%OpenId(rowID)
		s userCode = obj.UserCode
		d obj.%Close()
	}
	q userCode
}

ClassMethod HospitalName(AUserID As %String) As %String
{
	q:(AUserID ="") ""
	s hospitalName = ##class(DHCEPRFS.BL.BLSysOption).GetValueByName("HospitalName")
	q hospitalName
}

ClassMethod HospitalFlag(AUserID As %String) As %String
{
	q:(AUserID ="") ""
	s hospitalFlag = ##class(DHCEPRFS.BL.BLSysOption).GetValueByName("HospitalFlag")
	q hospitalFlag
}

ClassMethod UserName(AUserID As %String) As %String
{
	q:(AUserID ="") ""
	s userName = ""
	if ($l(AUserID,"^")=1)
	{
		s userName = ##class(DHCEPRFS.BL.HISInfo.BLHISInfo).GetUserName(AUserID)
	}
	elseif ($l(AUserID,"^")=2)
	{
		s rowID = $p(AUserID,"^",2)
		s obj = ##class(DHCEPRFS.META.QueryUser).%OpenId(rowID)
		s userName = obj.UserName
		d obj.%Close()
	}
	q userName
}

ClassMethod Custom(AUserID As %String) As %String
{
	q:(AUserID ="") ""
	q "Custom"
}

ClassMethod IP(AUserID As %String) As %String
{
	q:(AUserID ="") ""
	q "IP"
}

}
