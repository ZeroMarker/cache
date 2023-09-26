/// 登录
Class DWR.LOG.BL.Login Extends %RegisteredObject
{

ClassMethod Logon(RtStream As %GlobalCharacterStream) As %GlobalCharacterStream
{
	set $ZT="LogonET"
	set pResponse=##Class(DWR.LOG.MSG.LoginRp).%New()

	set reader = ##class(%XML.Reader).%New()
	set sc=reader.OpenStream(RtStream)
	If $$$ISERR(sc) 
	{
		do Output("100","HIS接收到的入参数据格式有误"_sc)
	    Quit RpStream
	}
	Do reader.Correlate("Request","DWR.LOG.MSG.LoginRt")
	if (reader.Next(.pRequest,.sc))
	{   
	}
	if ('$IsObject(pRequest))
	{
		do Output("100","HIS接收到的入参数据格式有误")
	    Quit RpStream
	}
	
	
	set pResponse=..LogonVerify(pRequest)
	do Output(pResponse.ResultCode,pResponse.ResultContent)
	
	quit RpStream
	
Output(ResultCode,ResultContent)
	set RpStream=""
	set pResponse.ResultCode=ResultCode
	set pResponse.ResultContent=ResultContent
	set RtStream=##class(%GlobalCharacterStream).%New()
	do pResponse.XMLExportToStream(.RpStream,"Response")
	quit
LogonET
	set pResponse=##Class(DWR.LOG.MSG.LoginRp).%New()
	do Output("-100","HIS端错误："_$ZERROR)
	quit RpStream
}

ClassMethod LogonVerify(Rt As DWR.LOG.MSG.LoginRt) As DWR.LOG.MSG.LoginRp
{
	set $ZT="LogonVerifyET"
	set Rp=##Class(DWR.LOG.MSG.LoginRp).%New()
	set UserCode=Rt.UserCode
	set Password=Rt.Password
	if (UserCode="")
	{
		do OutputResult("101","用户名不能为空")
	    Quit Rp
	}
	if (Password="")
	{
		do OutputResult("102","密码不能为空")
	    Quit Rp
	}
	set UserCode=$ZConvert(UserCode,"U")
	set UserID=$order(^SSU("SSUSR",0,"SSUSR_Initials",UserCode,"0"))
	if (UserID="")
	{
		do OutputResult("103","无效的用户名")
	    Quit Rp
	}
	//set myPassword=$piece($get(^SSU("SSUSR",UserID)),"^",3)
	set UserID=##Class(web.SSUser).IsValidUser(UserCode,Password)
	if (+UserID'>0)
	{
		do OutputResult("104","密码错误")
	    Quit Rp
	}
	set DoctorID=$piece($get(^SSU("SSUSR",UserID)),"^",14)
	if (DoctorID="")
	{
		do OutputResult("105","不是医护人员，不能登录")
	    Quit Rp	
	}
	
	set UserDefaultDept=$piece($get(^SSU("SSUSR",UserID)),"^",4)
	set UserDefaultGroupID=$piece($get(^SSU("SSUSR",UserID)),"^",5)
	set UserHaveLogDept="F"    //是否有可以登录的科室
	if (UserDefaultDept'="")
	{
		do OutputDept(UserDefaultDept,UserDefaultGroupID)
	}
	set sub="0"
	while($order(^SSU("SSUSR",UserID,"OTHLL",sub))'="")
	{
		set sub=$order(^SSU("SSUSR",UserID,"OTHLL",sub))
		
		set DeptID=$piece($get(^SSU("SSUSR",UserID,"OTHLL",sub)),"^",1)
		set UserGroupID=$piece($get(^SSU("SSUSR",UserID,"OTHLL",sub)),"^",2)
		do OutputDept(DeptID,UserGroupID)
	}
	
	if (UserHaveLogDept'="T")
	{
		do OutputResult("106","用户没有可以登录的科室")
		quit Rp
	}
	
	do OutputResult("0","校验成功")
	quit Rp
	
OutputDept(DeptID,UserGroupID)
	set AdmLoc=$order(^PAC("ADMLOC",0,"AdmType","I",DeptID,"0"))
	if (AdmLoc'="")
	{
		set UserHaveLogDept="T"
		set DeptName=$piece($get(^CTLOC(DeptID)),"^",2)
		if (DeptName["-") set DeptName=$piece(DeptName,"-",2)
		set HospitalID=$piece($get(^CTLOC(DeptID)),"^",22)   //从科室表中取所属医院
		set HospitalName=""
		if (HospitalID'="") set HospitalName=$piece($get(^CT("HOSP",HospitalID)),"^",2)
		set UserGroupName=""
		if (UserGroupID'="") set UserGroupName=$piece($get(^SSU("SSGRP",UserGroupID)),"^",2)
		set RowObj=##Class(DWR.LOG.MSG.Department).%New()
		set RowObj.DepartmentID=DeptID
		set RowObj.DepartmentName=DeptName
		set RowObj.GroupID=UserGroupID
		set RowObj.GroupName=UserGroupName
		set RowObj.HospitalID=HospitalID
		set RowObj.HospitalName=HospitalName
		set sc=Rp.DepartmentList.Insert(RowObj)
		
		do RowObj.%Close()
	}
		
	quit

OutputResult(ResultCode,ResultContent)
	set Rp.ResultCode=ResultCode
	set Rp.ResultContent=ResultContent
	quit
LogonVerifyET
	set Rp=##Class(DWR.LOG.MSG.LoginRp).%New()
	do OutputResult("-100","HIS端错误："_$ZERROR)
	quit Rp
}

}
