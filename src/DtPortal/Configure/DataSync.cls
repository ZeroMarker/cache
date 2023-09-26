/// 名称: DtPortal.Configure.DataSync
/// 描述: 数据同步管理
/// 编写者：chengpeng
/// 编写日期:2017-04-12
/// 
Class DtPortal.Configure.DataSync Extends %RegisteredObject
{

/// Creator：     chengpeng
/// CreatDate：   2017-04-12
/// Description:  用户同步
/// Input：       aInput:  类型(D:科室/U用户)^范围(1:单个/2:批量)^ID(批量导入用户时为角色ID)
/// Input：       type  :  导入模式(1:页面导入/2:后台导入)
/// Return：      return>0:成功  return<=0:失败
/// 			  注意:当要导入的数据量大的时候建议后台导入,可以看到进度
/// w ##Class(DtPortal.Configure.DataSync).saveDataSync("D^1^291",2)	
/// w ##Class(DtPortal.Configure.DataSync).saveDataSync("U^1^70",2)	
/// w ##Class(DtPortal.Configure.DataSync).saveDataSync("D^2^",2)		//后台批量导入科室
/// w ##Class(DtPortal.Configure.DataSync).saveDataSync("U^2^1",2)	//后台批量导入全部用户
ClassMethod saveDataSync(aInput As %String, InportType As %String = "") As %String
{
	Set return=""
	set contNum=0
	set addOKNum=0
	set upDataOjNum=0
	set ErrNOLoc=""
	set ErrCode=""
	set ErrNoCode=""
	set ExceptionCode=""
	
	set ErrNOLocNum=0
	set ErrCodeNum=0
	set ErrNoCodeNum=0
	set ExceptionNum=0
	
	Set syncType=$p(aInput,"^",1)
	Set syncNum=$p(aInput,"^",2)
	Set selectValue=$p(aInput,"^",3)
	
	//因为8.0版本字符串最大字节为32760 8.2为3641140,所以要设置最大值,科室100条字节大约为13874,用户 100条字节大约为22096
	set soapMaxNum=100
	set LocNum=0
	set shouStr=""
	
	set soapData="["
	
	//同步科室
	if syncType="D"
	{
		if syncNum="1"
		{
			//先同步院区
			set HospJsonData=..getHospData()
			set soapData=soapData_HospJsonData
			set shouStr=soapData
			d soapData
			s soapData="[",shouStr=""
			
			set locID=selectValue
			set LocName=$p(^CTLOC(locID),"^",2)
			set:LocName["-" LocName=$p(LocName,"-",2)
			set jsonData=..getLocData(locID)
			set:soapData'="[" soapData=soapData_","_jsonData
			set:soapData="[" soapData=soapData_jsonData
			set shouStr=LocName
			d soapData
		}
		else
		{	
			//先同步院区
			set HospJsonData=..getHospData()
			set soapData=soapData_HospJsonData
			set shouStr=soapData
			d soapData
			s soapData="[",shouStr=""
			
			set locID=0
			for
			{
				set locID=$o(^CTLOC(locID))
				quit:locID=""
				
				set LocName=$p(^CTLOC(locID),"^",2)
				//set:LocName["-" LocName=$p(LocName,"-",2)		//去掉描述中的首拼
				set ActiveFlag=$p(^CTLOC(locID),"^",14)
				//continue:ActiveFlag'="Y"			//过滤未激活科室
				set jsonData=..getLocData(locID)
				set:soapData'="[" soapData=soapData_","_jsonData
				set:soapData="[" soapData=soapData_jsonData
				set LocNum=LocNum+1
				set num=LocNum/soapMaxNum
				if $l(num,".")=1
				{
					d soapData
					s soapData="[",shouStr=""
				}
				set:shouStr'="" shouStr=shouStr_"^"_LocName
				set:shouStr="" shouStr=LocName
			}
		}
	}else
	{
		if syncNum="1"
		{
			set userID=selectValue
			set code=$P(^SSU("SSUSR",userID),"^",1)
			set name=$P(^SSU("SSUSR",userID),"^",2)
			set jsonData=..getUserData(userID)
			set:soapData'="[" soapData=soapData_","_jsonData
			set:soapData="[" soapData=soapData_jsonData
			set shouStr=name
			d soapData
		}
		else
		{
			set roluID=selectValue			
			set userID=0
			for
			{
				set userID=$o(^SSU("SSUSR",userID))
				quit:userID=""
				
				set code=$P(^SSU("SSUSR",userID),"^",1)
				set name=$P(^SSU("SSUSR",userID),"^",2)
				if roluID'="ALL"
				{
					
					set isUserIrole=..isUserIrole(userID,roluID)
					continue:isUserIrole'=1
				}
				
				set ActiveFlag=$p(^SSU("SSUSR",userID),"^",19)
				continue:ActiveFlag'="Y"
				set jsonData=..getUserData(userID)
				set:soapData'="[" soapData=soapData_","_jsonData
				set:soapData="[" soapData=soapData_jsonData
				
				set LocNum=LocNum+1
				set num=LocNum/soapMaxNum

				if $l(num,".")=1
				{
					d soapData
					s soapData="[",shouStr=""
				}
				set:shouStr'="" shouStr=shouStr_"^"_name
				set:shouStr="" shouStr=name
				
			}
		}
	}
	set num=LocNum/soapMaxNum
	if $l(num,".")'=1
	{
		d soapData
		s soapData="[",shouStr=""
	}
	
	set ok1show="新增成功"_addOKNum_"条;"
	set ok2show="更新成功"_upDataOjNum_"条;"
	set ErrShow1="",ErrShow2="",ErrShow3="",ErrShow4=""
	set:ErrNOLocNum'=0 ErrShow1="失败,无用户科室"_ErrNOLocNum_"条:"_ErrNOLoc_";"
	set:ErrCodeNum'=0 ErrShow2="失败,用户Code有误"_ErrCodeNum_"条:"_ErrCode_";"
	set:ErrNoCodeNum'=0 ErrShow3="失败,无用户Code"_ErrNoCodeNum_"条:"_ErrNoCode_";"
	set:ExceptionNum'=0 ErrShow4="失败,异常数据"_ExceptionNum_"条:"_ExceptionCode_";"
	
	set:return="" return=ok1show_ok2show_ErrShow1_ErrShow2_ErrShow3_ErrShow4
	
	Quit """"_return_""""
	
soapData
	set soapData=soapData_"]"
	w:InportType=2 "----------推送的数据开始:----------",!
	w:InportType=2 shouStr,!
	w:InportType=2 "----------推送的数据结束:----------",!

	set soapReturn=""
	set soapReturn=..PortalSoap(syncType,soapData)
	w:InportType=2 "webservice返回值："_soapReturn,!
	if $l(soapReturn,"^")=6
	{
		set addOKNum=addOKNum+$p(soapReturn,"^",1)
		set upDataOjNum=upDataOjNum+$p(soapReturn,"^",2)
		set str1=$p(soapReturn,"^",3)
		set str2=$p(soapReturn,"^",4)
		set str3=$p(soapReturn,"^",5)
		set str4=$p(soapReturn,"^",6)
		
		set:str1'="" ErrNOLocNum=ErrNOLocNum+$l(str1,"*")
		set:str2'="" ErrCodeNum=ErrCodeNum+$l(str2,"*")
		set:str3'="" ErrNoCodeNum=ErrNoCodeNum+$l(str3,"*")
		set:str4'="" ExceptionNum=ExceptionNum+$l(str4,"*")

		set ErrNOLoc=ErrNOLoc_str1
		set ErrCode=ErrCode_str2
		set ErrNoCode=ErrNoCode_str3
		set ExceptionCode=ExceptionCode_str4
	}
	
	set:soapReturn=-1 return="webservice调用失败"
}

/// Creator：     chengpeng
/// CreatDate：   2017-04-12
/// Description:  调用webservice 推送数据
/// Input：       type   U:用户   D  科室
/// 			  data	 用户/科室数据 拼成的jsonArray数据格式
/// 			  
/// Return：      -1 webservice调用失败 其他参数
/// w ##Class(DtPortal.Configure.DataSync).getLocData(1)
ClassMethod PortalSoap(type As %String, data As %String) As %String
{


	quit:type="" return
	quit:data="" return
	Set $ZT="PortalSoapErr"

	Set Soap = ##class(DtPortal.Common.PortalSoap).%New()
	Set SoapRtn = Soap.InvokePortalUserSyncService(type,data)
	
	Quit SoapRtn
	
PortalSoapErr
	q -1
}

/// Creator：     chengpeng
/// CreatDate：   2017-04-12
/// Description:  获取院区json串
/// Return：      json数据
/// w ##Class(DtPortal.Configure.DataSync).getHospData()
ClassMethod getHospData() As %String
{
	Set return=""
	Set $ZT="getHospData"
	set hosID=""
	for
	{
			set hosID=$o(^CT("HOSP",hosID))
			quit:hosID=""
			
			set deptName=$p(^CT("HOSP",hosID),"^",2)	
			continue:deptName=""
			set:deptName["-" deptName=$p(deptName,"-",2)
			set deptCode=$p(^CT("HOSP",hosID),"^",1)
			set deptType="Hosp"
			set superCode=0				
			set jsonObj = ##class(DtPortal.Common.JsonObject).%New()
			d jsonObj.Put("deptCode",deptCode)
			d jsonObj.Put("deptName",deptName)
			d jsonObj.Put("shortName","")
			d jsonObj.Put("superCode",superCode)
			d jsonObj.Put("phone","")
			d jsonObj.Put("address","")
			d jsonObj.Put("rowid",hosID)
			d jsonObj.Put("wardID","")
			d jsonObj.Put("deptType",deptType)
			set HospStr=jsonObj.Json()	
			
			set:return'="" return=return_","_HospStr
			set:return="" return=HospStr
	}

	
	Quit return
	
getHospData
	q -1
}

/// Creator：     chengpeng
/// CreatDate：   2017-04-12
/// Description:  获取科室json串
/// Input：       locID 科室ID
/// Return：      json数据
/// w ##Class(DtPortal.Configure.DataSync).getLocData(1)
ClassMethod getLocData(locID As %String) As %String
{
	Set return=-1
	quit:locID="" return
	Set $ZT="getLocData"
	set ActiveFlag=$p(^CTLOC(locID),"^",14)
	//continue:ActiveFlag'="Y"			//过滤未激活科室
	set deptCode=$p(^CTLOC(locID),"^",1)
	set deptName=$p(^CTLOC(locID),"^",2)
	set:deptName["-" deptName=$p(deptName,"-",2)
	set phone=$p(^CTLOC(locID),"^",40)
	set address=$g(^CTLOC(locID,"ADDR",1))_$p($g(^CTLOC(locID)),"^",16)
	set hospitalId=$p(^CTLOC(locID),"^",22)
	set superCode=0
	if hospitalId'="" set superCode=$p(^CT("HOSP",hospitalId),"^",1)					
	set shortName=$p($g(^CTLOC(locID)),"^",43)
	set deptType=$p($g(^CTLOC(locID)),"^",13) //科室类型
	if deptType="O" set deptType="other"
	if deptType="E" {
		 set deptType="Other"
		  //判断是否是急诊科室
		 set rowIdE=$o(^PAC("ADMLOC",0,"AdmType","E",locID,0))
		 IF rowIdE'="" set deptType="E"
		  //判断是否是门诊科室
		 set rowIdO=$o(^PAC("ADMLOC",0,"AdmType","O",locID,0))
		 IF rowIdO'="" set deptType="O"
		 set rowIdI=$o(^PAC("ADMLOC",0,"AdmType","I",locID,0))
		 IF rowIdI'="" set deptType="I"
		   
		}
	if deptType="EM" set deptType="E"
	set orgFlag="Y"
	set wardID=""
	if deptType="W"
	{
		set wardID=$o(^PAWARD(0,"WARD_LocationDR",locID,""))
	}
	set jsonObj = ##class(DtPortal.Common.JsonObject).%New()
	d jsonObj.Put("deptCode",deptCode)
	d jsonObj.Put("deptName",deptName)
	d jsonObj.Put("shortName",shortName)
	d jsonObj.Put("superCode",superCode)
	d jsonObj.Put("phone",phone)
	d jsonObj.Put("address",address)
	d jsonObj.Put("rowid",locID)
	d jsonObj.Put("wardID",wardID)
	d jsonObj.Put("deptType",deptType)

	set LocStr=jsonObj.Json()
	
	Quit LocStr
	
getLocData
	q -1
}

/// Creator：     chengpeng
/// CreatDate：   2017-04-12
/// Description:  同步用户
/// Input：       UserID 用户ID
/// 			  status 状态:1 新增;2 删除;3  修改
/// Return：      return>0:成功  return<=0:失败
/// w ##Class(DtPortal.Configure.DataSync).getUserData("1")
ClassMethod getUserData(userID As %String) As %String
{

	Set return=-1
	quit:userID="" return
	Set $ZT="getUserDataErr"

	set userCode=$P(^SSU("SSUSR",userID),"^",1) //用户code
	set userName=$P(^SSU("SSUSR",userID),"^",2) //用户名称
	set isActive=$p(^SSU("SSUSR",userID),"^",19) //是否激活
	if isActive="Y" set isActive="true" else  set ActiveFlag="false" 
	//continue:ActiveFlag'="Y"
	//set locID=$P(^SSU("SSUSR",userID),"^",4) //科室id
	set locID=##class(DtPortal.Common.PortalSoap).getLocByUser(userID,1)				//取全部科室,用*分割,默认科室第一位 程鹏修改
	set deptCode="0"
	//set:locID'="" deptCode=$p($g(^CTLOC(locID)),"^",1) //科室code
	set deptCode=##class(DtPortal.Common.PortalSoap).getLocByUser(userID,2)				//取全部科室,用*分割,默认科室第一位 程鹏修改
			
	set roleCode=..getUserType(userID) //根据安全组生成角色code
	set password=$p($g(^SSU("SSUSR",userID)),"^",3) //基础数据平台保存的密码
	set password=$replace(password,"""",$c(9813))
	s invalidDate=$p($g(^SSU("SSUSR",userID)),"^",96)
	set invalidDate=$zd(invalidDate,3)
	s endDate=$p($g(^SSU("SSUSR",userID)),"^",97)
	if endDate'="" set endDate=$zd(endDate,3)
	Set DocID=$p($g(^SSU("SSUSR",+userID)),"^",14) //获取医护人员的id
	set email=$p($g(^CTPCP(+userID,3)),"^",8)
	set mobile=$p($g(^CTPCP(+userID,3)),"^",5)
	set phone=$p($g(^CTPCP(+userID,2)),"^",1)
	
	set jsonObj = ##class(DtPortal.Common.JsonObject).%New()
	d jsonObj.Put("userCode",userCode)
	d jsonObj.Put("userName",userName)
	d jsonObj.Put("password",password)
	d jsonObj.Put("deptCode",deptCode)
	d jsonObj.Put("phone",phone)
	d jsonObj.Put("mobile",mobile)
	d jsonObj.Put("email",email)
	d jsonObj.Put("invalidDate",invalidDate)
	d jsonObj.Put("endDate",endDate)
	d jsonObj.Put("isActive",isActive)
	d jsonObj.Put("roleCode",roleCode)
	d jsonObj.Put("userID",userID)

	set UserData=jsonObj.Json()
	Quit UserData

getUserDataErr
	q -1
}

/// Creator：      chengpeng
/// CreatDate：    2017-04-13
/// Description：  获取用户角色串
/// Input：	      UserID 
/// Return： 	  角色穿(以"*分隔")
/// w ##class(DtPortal.Configure.DataSync).getUserType(70)
ClassMethod getUserType(UserId)
{

	set return=0
		
	quit:UserId="" return
 	set Type=""
 	
 	set GroupDesc=""
	set CTGroupDr = $p($g(^SSU("SSUSR",UserId)),"^",5)
	set:CTGroupDr'="" GroupDesc=$p($g(^SSU("SSGRP",CTGroupDr)),"^",1)
	d setType1
 	
	
	set sub=0
	for
	{
		set sub=$o(^SSU("SSUSR",UserId,"OTHLL",sub))
		q:sub=""
		set CTLocDr=$p($g(^SSU("SSUSR",UserId,"OTHLL",sub)),"^",1)
		set CTGroupDr=$p($g(^SSU("SSUSR",UserId,"OTHLL",sub)),"^",2) 
		continue:CTGroupDr=""
		set GroupDesc=$p($g(^SSU("SSGRP",CTGroupDr)),"^",1)
		
		d setType1
		 	
	}
	if Type="" d getUser1
	quit Type
	
setType1
	set roleID=""
	for
	{
		set roleID=$o(^DtPortal.Configure.RoleGroupI("Item","IndexGroupID",CTGroupDr,roleID))
		quit:roleID=""
		
		Set Roleobj=##class(DtPortal.Configure.RoleGroup).%OpenId(roleID)
		continue:'$IsObject(Roleobj)
		continue:Roleobj.RoleIsActive="N"
		set PortalID=Roleobj.RoleCode
		continue:("*"_Type_"*")[("*"_PortalID_"*")
				
		if Type=""
		{
			set Type=PortalID
		}else
		{
			set Type=Type_"*"_PortalID
		}

	}
	q
	
getUser1

	set roleID=$o(^DtPortal.Configure.RoleGroupI("RoleCodeIndex"," USER",""))
	Set Roleobj=##class(DtPortal.Configure.RoleGroup).%OpenId(roleID)
	quit:'$IsObject(Roleobj) return
	quit:Roleobj.RoleIsActive="N" ""
	set PortalID=Roleobj.RoleCode
	set Type=PortalID
	q
}

/// Creator：     chengpeng
/// CreatDate：   2018-12-04
/// Description:  同步科室（用于基础数据平台调用）
/// Input：       locID 科室ID
/// Return：      return>0:成功  return<=0:失败
/// w ##class(DtPortal.Configure.DataSync).SyncLocSoap(1)
ClassMethod SyncLocSoap(locID As %String, type = 1) As %String
{
	Set $ZT="SyncLocSoap"
	set return=0
	set str="D^1^"_locID
	set ret=##Class(DtPortal.Configure.DataSync).saveDataSync(str,1)
	
	Quit ret
	
SyncLocSoap
	q -1
}

/// Creator：     chengpeng
/// CreatDate：   2018-12-04
/// Description:  同步用户（用于基础数据平台调用）
/// Input：       UserID 科室ID
/// Return：      return>0:成功  return<=0:失败
/// w ##class(DtPortal.Configure.DataSync).SyncUserSoap(1)
ClassMethod SyncUserSoap(UserID As %String, type = 1) As %String
{
	Set $ZT="SyncUserSoap"
	set return=0
	set str="U^1^"_UserID
	set ret=##Class(DtPortal.Configure.DataSync).saveDataSync(str,1)

	Quit ret
	
SyncUserSoap
	q -1
}

/// Creator：      chengpeng
/// CreatDate：    2017-01-03
/// Description：  处理同一用户平台Data数据,添入portal角色ID
/// Input：	      Data 
/// Return： 	  Data
/// w ##class(DtPortal.Configure.DataSync).addRoleToData("369^李兴旺^^感染二科^1^^2008-04-28^^^LXW^主任医师^Y^住院医师^^Y^^36               9^^^^^^")
ClassMethod addRoleToData(Data)
{
	set return=0
	
	set UserCode=$p(Data,"^",1)
	s UserCode=$$ALPHAUP^SSUTIL4(UserCode)
	s UserId=$o(^SSU("SSUSR",0,"SSUSR_Initials",UserCode,0))
	
	quit:UserId="" return
 	set Type=""
 	
 	set GroupDesc=""
	set CTGroupDr = $p($g(^SSU("SSUSR",UserId)),"^",5)
	set:CTGroupDr'="" GroupDesc=$p($g(^SSU("SSGRP",CTGroupDr)),"^",1)
	d setType
 	
	
	set sub=0
	for
	{
		set sub=$o(^SSU("SSUSR",UserId,"OTHLL",sub))
		q:sub=""
		set CTLocDr=$p($g(^SSU("SSUSR",UserId,"OTHLL",sub)),"^",1)
		set CTGroupDr=$p($g(^SSU("SSUSR",UserId,"OTHLL",sub)),"^",2) 
		continue:CTGroupDr=""
		set GroupDesc=$p($g(^SSU("SSGRP",CTGroupDr)),"^",1)
		
		d setType
		 	
	}
	if Type="" d getUser
	set $p(Data,"^",9)=Type
	set $p(Data,"^",1)=$tr($p(Data,"^",1),"-","")
	quit Data
	
setType
	set roleID=""
	for
	{
		set roleID=$o(^DtPortal.Configure.RoleGroupI("Item","IndexGroupID",CTGroupDr,roleID))
		quit:roleID=""
		
		Set Roleobj=##class(DtPortal.Configure.RoleGroup).%OpenId(roleID)
		continue:'$IsObject(Roleobj)
		continue:Roleobj.RoleIsActive="N"
		set PortalID=Roleobj.PortalID
		continue:("*"_Type_"*")[("*"_PortalID_"*")
				
		if Type=""
		{
			set Type=PortalID
		}else
		{
			set Type=Type_"*"_PortalID
		}

	}
	q
	
getUser	

	set roleID=$o(^DtPortal.Configure.RoleGroupI("RoleCodeIndex"," USER",""))
	Set Roleobj=##class(DtPortal.Configure.RoleGroup).%OpenId(roleID)
	quit:'$IsObject(Roleobj) return
	quit:Roleobj.RoleIsActive="N"
	set PortalID=Roleobj.PortalID
	set Type=PortalID
	q
}

/// Creator：      chengpeng
/// CreatDate：    2017-01-03
/// Description：  处理同一用户平台Data数据,添入portal角色ID
/// Input：	      Data 
/// Return： 	  Data
/// w ##class(DtPortal.Configure.DataSync).addRoleToData("369^李兴旺^^感染二科^1^^2008-04-28^^^LXW^主任医师^Y^住院医师^^Y^^36               9^^^^^^")
ClassMethod isUserIrole(UserId, roleID)
{

	set return=0
	
	quit:((UserId="")&&(roleID="")) return
	set groupIDStr=##Class(DtPortal.Configure.RoleGroupItem).qureyRoleGroup1(roleID)
	set groupIDStr="^"_groupIDStr_"^"
	set isInRole=0
	
 	set GroupDesc=""
	set CTGroupDr = $p($g(^SSU("SSUSR",UserId)),"^",5)
	set:CTGroupDr'="" CTGroupDr="^"_CTGroupDr_"^"
	set:groupIDStr[CTGroupDr isInRole=1
 	
	set sub=0
	for
	{
		set sub=$o(^SSU("SSUSR",UserId,"OTHLL",sub))
		q:sub=""
		set CTLocDr=$p($g(^SSU("SSUSR",UserId,"OTHLL",sub)),"^",1)
		set CTGroupDr=$p($g(^SSU("SSUSR",UserId,"OTHLL",sub)),"^",2) 
		continue:CTGroupDr=""
		set:CTGroupDr'="" CTGroupDr="^"_CTGroupDr_"^"
		set:groupIDStr[CTGroupDr isInRole=1	
	}

	q isInRole
}

/// Creator：      chengpeng
/// CreatDate：    2017-01-03
/// Description：  导出同一用户信息(加入portal角色后的数据)
/// Input：	      Data 
/// Return： 	  Data
/// w ##class(DtPortal.Configure.DataSync).ExportToText()
ClassMethod ExportToText()
{
	Set Count=0
	Set RowId=""
	set file = ##class(%File).%New("D:/UserNew.txt")
	do file.Open("WSN")
	for  {
		Set RowId = $O(^dhcsyncUserD(RowId)) 
		Quit:RowId=""
		Set Data = ##class(dhc.sync.web.User).GetUserData(RowId)
		set Data=..addRoleToData(Data)	//加入角色信息
		d file.WriteLine(Data)
		Set Count = Count+1
	}
	Do file.%Save()
	Set file=""
	Quit Count
}

/// Creator：      chengpeng
/// CreatDate：    2017-01-03
/// Description：  text
/// Input：	      Data 
/// Return： 	  Data
/// w ##class(DtPortal.Configure.DataSync).text()
ClassMethod text()
{
	
	set locID=""
	for
	{
		set locID=$o(^CTLOC(locID))
		quit:locID=""
		
		set code=$p(^CTLOC(locID),"^",1)
		
		set synclocID=$o(^dhcsyncLocI("syncLocIdx",code,""))
		w:synclocID="" locID,!
	}
	q ""
}

/// Creator：     chengpeng
/// CreatDate：   2017-04-16
/// Description:  导出用户默认登录科室
/// Return：      return>0:成功  return<=0:失败
/// w ##class(DtPortal.Configure.DataSync).outPutData()
ClassMethod outPutData() As %String
{
	set file="D:\UserLoc1.csv"
	set message = ##class(%FileCharacterStream).%New()
	set message.Filename = file
	set tSc=message.WriteLine("用户工号,用户姓名,默认登录科室")
	set count=0
	
	set UserID=0
	for
	{
		set UserID=$o(^SSU("SSUSR",UserID))
		quit:UserID=""
		
		set LocDesc=""
		set roleType=..getUserType(UserID)
		continue:roleType=""
		set userCode=$P(^SSU("SSUSR",UserID),"^",1)
		set userName=$P(^SSU("SSUSR",UserID),"^",2)
		set locID = $p($g(^SSU("SSUSR",UserID)),"^",4)
		
		set:locID'="" LocDesc=$p(^CTLOC(locID),"^",2)
		set:LocDesc["-" LocDesc=$p(LocDesc,"-",2)
		
		set wStr=userCode_","_userName_","_LocDesc
		set tSc=message.WriteLine(wStr)
		set count=count+1
		w count,!
	}
	
	set tSc=message.%Save()
	Quit tSc
}

/// Creator：     chengpeng
/// CreatDate：   2017-04-16
/// Description:  
/// Return：      return>0:成功  return<=0:失败
/// w ##class(DtPortal.Configure.DataSync).getUserLoc()
ClassMethod getUserLoc() As %String
{
	
	set file="D:\UserJLEnd1.csv"
	set message0 = ##class(%FileCharacterStream).%New()
	set message0.Filename = file
	set tSc=message0.WriteLine("用户名称,登录名称,科室,角色,登录时间,登出时间,登录ip")
	set count=0
	
	set filePath="D:\userJL1.csv"
	set message = ##class(%FileCharacterStream).%New()
	set message.Filename = filePath  

	while 'message.AtEnd {
		set record=message.ReadLine()
		set userName=$p(record,",",1)
		continue:userName="用户名称"
		set locDesc=""
		quit:userName=""
		set filePath2="D:\UserLoc1.csv"
		set message2 = ##class(%FileCharacterStream).%New()
		set message2.Filename = filePath2  
		while 'message2.AtEnd 
		{
			set record2=message2.ReadLine()
			set userName2=$p(record2,",",2)
			if userName=userName2
			{
				set locDesc=$p(record2,",",3)
				quit
			}
		}
		
		set wStr=$p(record,",",1)_","_$p(record,",",2)_","_locDesc_","_$p(record,",",4)_","_$p(record,",",5)_","_$p(record,",",6)_","_$p(record,",",7)
		set count=count+1
		w count_"  "_wStr,!
		set tSc=message0.WriteLine(wStr)
		
		
	}
	set tSc=message0.%Save()
	Quit tSc
}

/// Debug：w ##class(DtPortal.Configure.DataSync).test()
ClassMethod test() As DtPortal.OutPut
{

	#Dim ret As DtPortal.OutPut
	Set ret = ##class(DtPortal.OutPut).%New()
	
	set a=""
	for index=1:1:1000000
	{
		set b="1234567890"
		s a=a_b
		w index,!
	}
	
	Set ret.status = 1
	Set ret.errMSG = ""
	set ret.data="22"

		
	Quit ret
}

}
