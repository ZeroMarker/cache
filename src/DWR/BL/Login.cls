Class DWR.BL.Login Extends (%RegisteredObject, %XML.Adaptor)
{

/// w ##Class(DWR.BL.Login).Login(Param)
ClassMethod Login(Param As %String = "") As %String
{
	i Param="" s Param="<Request><userCode>doct</userCode><password>1</password><terminalId>terminalId</terminalId><padIP>padIP</padIP></Request>"
    s Param=$TR(Param,$C(10))
    s reader=##class(%XML.Reader).%New()
    s sc=reader.OpenString(Param)
    d reader.Correlate("Request","DWR.MSG.Request")
	While reader.Next(.request,.sc)
	{
	   s userCode=request.userCode
	   s userCode=$TR(userCode,$C(0))
	   s password=request.password
	   s password=$TR(password,$C(0))
	   s terminalId=request.terminalId
	   s terminalId=$TR(terminalId,$C(0))
	   s padIP=request.padIP
	   s padIP=$TR(padIP,$C(0))
	}
	q:$G(userCode)="" "201^用户名不能为空!"
	q:$G(password)="" "202^密码不能为空!"
	q:($G(userCode)="")&&($G(password)="")&&($G(terminalId)="")&&($G(padIP)="") "201^入参不完整!"

	s userCode=$ZConvert(userCode,"U")
	s userId=$order(^SSU("SSUSR",0,"SSUSR_Initials",userCode,"0"))
	q:userId="" "203^无效的用户名!"
	//s userId=##Class(web.SSUser).IsValidUser(userCode,password)
	s password=$$ENCR^SSUTIL2(password)
	s oldPassword=$P($G(^SSU("SSUSR",userId)),"^",3)
	q:password'=oldPassword "204^密码错误!"
	q:+userId'>0 "204^密码错误!"
	s userName=$P($G(^SSU("SSUSR",userId)),"^",2)
	s userName=$P(userName,"-")
	s doctorId=$P($G(^SSU("SSUSR",userId)),"^",14)
	q:+doctorId'>0 "205^不是医护人员,不能登录!"
	
	s defaultDeptId=$P($G(^SSU("SSUSR",userId)),"^",4)
	s deptTypeDr=$P($G(^CTLOC(defaultDeptId)),"^",19)
	i $O(^PAC("ADMLOC",0,"AdmType","I",defaultDeptId,""))="" s defaultDeptId=""
	//i deptTypeDr'=2 s defaultDeptId=""
	s defaultGroupId=$P($G(^SSU("SSUSR",userId)),"^",5)
	i defaultDeptId="" d
	.s otherId=0
	.f  s otherId=$O(^SSU("SSUSR",userId,"OTHLL",otherId)) q:(otherId="")||(defaultDeptId'="")  d
	..s defaultDeptId=$P($G(^SSU("SSUSR",userId,"OTHLL",otherId)),"^",1)
	..s deptTypeDr=$P($G(^CTLOC(defaultDeptId)),"^",19)
	..//i deptTypeDr'=2 s defaultDeptId=""
	..q:$O(^PAC("ADMLOC",0,"AdmType","I",defaultDeptId,""))=""
	..s defaultGroupId=$P($G(^SSU("SSUSR",userId,"OTHLL",otherId)),"^",2)
	q:defaultDeptId="" "206^用户没有可以登录的科室"
	
	s myObj=##class(DWR.Store.LoginInfo).%New()
	s myObj.userCode=userCode
	s myObj.userName=userName
	s myObj.defaultDeptId=defaultDeptId
	s defaultDeptName=$P($G(^CTLOC(defaultDeptId)),"^",2)
	i $P(defaultDeptName,"-",2)'="" s defaultDeptName=$P(defaultDeptName,"-",2)
	s myObj.defaultDeptName=defaultDeptName
	s hospitalId=$P($G(^CTLOC(defaultDeptId)),"^",22)
	s myObj.hospitalId=hospitalId
	i hospitalId'="" s hospitalName=$P($G(^CT("HOSP",hospitalId)),"^",2)
	s myObj.hospitalName=$G(hospitalName)
	s myObj.defaultGroupId=defaultGroupId
	i defaultGroupId'="" d
	.s defaultGroupName=$P($G(^SSU("SSGRP",defaultGroupId)),"^",1)
	.i $P(defaultGroupName,"-",2)'="" s defaultGroupName=$P(defaultGroupName,"-",2)
	s myObj.defaultGroupName=$G(defaultGroupName)
	s loginDate=$ZD(+$H,3)
	s myObj.loginDate=loginDate
	s loginTime=$ZT($P($H,",",2))
	s myObj.loginTime=loginTime
	s myObj.padIP=padIP
	s terminalId=$$ALPHAUP^SSUTIL4(terminalId)
	s myObj.terminalId=terminalId
	s loginNum=1
	s logId="" f  s logId=$O(^DWR.Store.LoginInfoI("logDateTerminal"," "_loginDate," "_$$ALPHAUP^SSUTIL4(terminalId),logId)) q:logId=""  d
	.s loginNum=loginNum+1
	s myObj.loginNum=loginNum	
	d myObj.%Save()
	d myObj.%Close()
	s myObj.loginDate=""
	s myObj.loginTime=""
	s myObj.padIP=""
	s myObj.terminalId=""
	s Xml=""
	s ret=myObj.XMLExportToString(.Xml,"LoginInfo")
	i ret=1 s retStr=Xml	
	q retStr
}

/// w ##Class(DWR.BL.Login).GetLoginDepartment(Param)
ClassMethod GetLoginDepartment(Param As %String = "") As %String
{
	i Param="" s Param="<Request><userCode>030414</userCode></Request>"
    s Param=$TR(Param,$C(10))
    s retStr=""
    s reader=##class(%XML.Reader).%New()
    s sc=reader.OpenString(Param)
    d reader.Correlate("Request","DWR.MSG.Request")
	While reader.Next(.request,.sc)
	{
	   s userCode=request.userCode
	   s userCode=$TR(userCode,$C(0))
	}
	q:$G(userCode)="" "201^用户名不能为空!"

	s userCode=$ZConvert(userCode,"U")
	s userId=$order(^SSU("SSUSR",0,"SSUSR_Initials",userCode,"0"))
	q:userId="" "203^无效的用户名!"
	s userName=$P($G(^SSU("SSUSR",userId)),"^",2)
	s userName=$P(userName,"-")		
	s defaultDeptId=$P($G(^SSU("SSUSR",userId)),"^",4)
	s defaultGroupId=$P($G(^SSU("SSUSR",userId)),"^",5)
	i defaultDeptId'="" d
	.s deptTypeDr=$P($G(^CTLOC(defaultDeptId)),"^",19)
	.//q:deptTypeDr'=2
	.q:$O(^PAC("ADMLOC",0,"AdmType","I",defaultDeptId,""))=""
	.s myObj=##class(DWR.MSG.DepartmentInfo).%New()
	.s myObj.departmentId=defaultDeptId
	.s departmentName=$P($G(^CTLOC(defaultDeptId)),"^",2)
	.i $P(departmentName,"-",2)'="" s departmentName=$P(departmentName,"-",2)
	.s myObj.departmentName=departmentName
	.s myObj.departmentNote=""
	.s Xml=""
	.s ret=myObj.XMLExportToString(.Xml,"DepartmentInfo")
	.d myObj.%Close()
	.i ret=1 s retStr=retStr_Xml
	s otherId=0
	f  s otherId=$O(^SSU("SSUSR",userId,"OTHLL",otherId)) q:otherId=""  d
	.s departmentId=$P($G(^SSU("SSUSR",userId,"OTHLL",otherId)),"^",1)
	.s deptTypeDr=$P($G(^CTLOC(departmentId)),"^",19)
	.q:$O(^PAC("ADMLOC",0,"AdmType","I",departmentId,""))=""
	.//q:deptTypeDr'=2
	.s groupId=$P($G(^SSU("SSUSR",userId,"OTHLL",otherId)),"^",2)
	.s myObj=##class(DWR.MSG.DepartmentInfo).%New()
	.s myObj.departmentId=departmentId
	.s departmentName=$P($G(^CTLOC(departmentId)),"^",2)
	.i $P(departmentName,"-",2)'="" s departmentName=$P(departmentName,"-",2)
	.s myObj.departmentName=departmentName
	.s myObj.groupId=groupId
	.s myObj.departmentNote=""
	.s Xml=""
	.s ret=myObj.XMLExportToString(.Xml,"DepartmentInfo")
	.d myObj.%Close()
	.i ret=1 s retStr=retStr_Xml
	q retStr
}

}
