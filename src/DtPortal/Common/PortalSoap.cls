Class DtPortal.Common.PortalSoap Extends %RegisteredObject [ Not ProcedureBlock ]
{

// 调用同一用户的接口

ClassMethod InvokePortalUserSyncService(type, data) As %String
{
	set Soap=##Class(UserSyncServiceImpl.UserSyncServiceImplHttpSoap11Endpoint).%New()
	//取portal配置中的地址
	set soapIP=##Class(DtPortal.Common.PublicService).getValueByCode("PORTALIP")
	
	set str2=$p(Soap.Location,"//",2)
	set str3=$p(str2,"/",1)
	set str4=$p(str2,str3,2)
	
	if soapIP'=""
	{
		set Soap.Location="http://"_soapIP_str4
	}

	set SoapRtn=Soap.saveDataWithHis(type,data)
	q SoapRtn
}

/// d ##class(%ResultSet).RunQuery("DtPortal.Common.PortalSoap","getDeptBasicData")
Query getDeptBasicData() As DtPortal.Query(CONTAINID = 1, ROWSPEC = "deptCode:%String,deptName:%String,shortName:%String,superCode:%String,phone:%String,address:%String,deptType:%String,hospCode:%String,isActive:%String")
{
}

ClassMethod getDeptBasicDataExecute(ByRef QHandle As %Library.Binary) As %Library.Status
{
 	s repid=$I(^||CacheTemp) 
 	s ind=1 
 	s QHandle=$lb(0,repid,0)
 		set hosID=""
 		for
		{
				set hosID=$o(^CT("HOSP",hosID))
				quit:hosID=""
				
				set hosName=$p(^CT("HOSP",hosID),"^",2)	
				continue:hosName=""
				set:hosName["-" hosName=$p(hosName,"-",2)
 				set hostCode=$p(^CT("HOSP",hosID),"^",1)
 				set deptType="Hosp"
 				set superCode=0				
				;set shortName=$p($g(^CTLOC(locID)),"^",43)
				Set ^||CacheTemp(repid,ind)=$lb(hostCode,hosName,"","","","",deptType,"","true")
		        Set ind=ind+1				
		}
		
 	set locID=""
	for
		{
				set locID=$o(^CTLOC(locID))
				quit:locID=""
				
				set LocName=$p(^CTLOC(locID),"^",2)
				continue:LocName=""
				//set:LocName["-" LocName=$p(LocName,"-",2)		//去掉描述中的首拼
				set ActiveFlag=$p(^CTLOC(locID),"^",14)
				set isActive="false"
				if ActiveFlag'="N" set isActive="true"
				set deptCode=$p(^CTLOC(locID),"^",1)
      	  		set deptName=$p(^CTLOC(locID),"^",2)
 				;set:deptName["-" deptName=$p(deptName,"-",2)
 				set phone=$p(^CTLOC(locID),"^",40)
 				set address=$g(^CTLOC(locID,"ADDR",1))_$p($g(^CTLOC(locID)),"^",16)
 				set hospitalId=$p(^CTLOC(locID),"^",22)
 				set superCode=0
				set hospCode=""
 				if hospitalId'="" set superCode=$p(^CT("HOSP",hospitalId),"^",1) set hospCode=superCode					
				set shortName=$p($g(^CTLOC(locID)),"^",43)
				set deptType=$p($g(^CTLOC(locID)),"^",13) //科室类型
				if deptType="O" set deptType="Other"
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
				set wardID=""
				if deptType="W"
				{
					set wardID=$o(^PAWARD(0,"WARD_LocationDR",locID,""))
				}
				if deptType="EM" set deptType="E"
				set orgFlag="Y"
				Set ^||CacheTemp(repid,ind)=$lb(deptCode,deptName,shortName,superCode,phone,address,deptType,hospCode,isActive)
		        Set ind=ind+1				
		}
 	Set QHandle=$lb(0,repid,0) 
	Quit $$$OK
}

/// d ##class(%ResultSet).RunQuery("DtPortal.Common.PortalSoap","getDeptData")
Query getDeptData() As DtPortal.Query(CONTAINID = 1, ROWSPEC = "code:%String,deptCode:%String,rowId:%String,deptName:%String,superCode:%String,hospCode:%String,isActive:%String,wardID:%String")
{
}

ClassMethod getDeptDataExecute(ByRef QHandle As %Library.Binary) As %Library.Status
{
 	s repid=$I(^||CacheTemp) 
 	s ind=1 
 	s QHandle=$lb(0,repid,0)
 		set hosID=""
 		for
		{
				set hosID=$o(^CT("HOSP",hosID))
				quit:hosID=""
				
				set hosName=$p(^CT("HOSP",hosID),"^",2)	
				continue:hosName=""
				set:hosName["-" hosName=$p(hosName,"-",2)
 				set hostCode=$p(^CT("HOSP",hosID),"^",1)
 				set deptType="Hosp"
 				set superCode=0				
				;set shortName=$p($g(^CTLOC(locID)),"^",43)
				Set ^||CacheTemp(repid,ind)=$lb(hostCode,hostCode,hosID,hosName,"","","true","")
		        Set ind=ind+1				
		}
		
 	set locID=""
	for
		{
				set locID=$o(^CTLOC(locID))
				quit:locID=""
				
				set LocName=$p(^CTLOC(locID),"^",2)
				continue:LocName=""
				//set:LocName["-" LocName=$p(LocName,"-",2)		//去掉描述中的首拼
				set ActiveFlag=$p(^CTLOC(locID),"^",14)
				set isActive="false"
				if ActiveFlag'="N" set isActive="true"
				set deptCode=$p(^CTLOC(locID),"^",1)
      	  		set deptName=$p(^CTLOC(locID),"^",2)
 				;set:deptName["-" deptName=$p(deptName,"-",2)
 				set phone=$p(^CTLOC(locID),"^",40)
 				set address=$g(^CTLOC(locID,"ADDR",1))_$p($g(^CTLOC(locID)),"^",16)
 				set hospitalId=$p(^CTLOC(locID),"^",22)
 				set superCode=0
				set hospCode=""
 				if hospitalId'="" set superCode=$p(^CT("HOSP",hospitalId),"^",1) set hospCode=superCode					
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
				set wardID=""
				if deptType="W"
				{
					set wardID=$o(^PAWARD(0,"WARD_LocationDR",locID,""))
				}
				if deptType="EM" set deptType="E"
				set orgFlag="Y"
				Set ^||CacheTemp(repid,ind)=$lb(deptCode,deptCode,locID,deptName,superCode,hospCode,isActive,wardID)
		        Set ind=ind+1				
		}
 	Set QHandle=$lb(0,repid,0) 
	Quit $$$OK
}

/// d ##class(%ResultSet).RunQuery("DtPortal.Common.PortalSoap","getCTLOCData")
Query getCTLOCData() As DtPortal.Query(CONTAINID = 1, ROWSPEC = "deptCode:%String,locID:%String,deptName:%String,wardID:%String,deptType:%String,hospCode:%String,hospitalId:%String,admType:%String,departmentGroup:%String")
{
}

ClassMethod getCTLOCDataExecute(ByRef QHandle As %Library.Binary) As %Library.Status
{
 	s repid=$I(^||CacheTemp) 
 	s ind=1 
 	s QHandle=$lb(0,repid,0)
 	set locID=""
	for
		{
				set locID=$o(^CTLOC(locID))
				quit:locID=""
				
				set LocName=$p(^CTLOC(locID),"^",2)
				continue:LocName=""
				//set:LocName["-" LocName=$p(LocName,"-",2)		//去掉描述中的首拼
				set ActiveFlag=$p(^CTLOC(locID),"^",14)
				continue:ActiveFlag="N" 
				set deptCode=$p(^CTLOC(locID),"^",1)
      	  		set deptName=$p(^CTLOC(locID),"^",2)
 				set hospitalId=$p(^CTLOC(locID),"^",22)
				set hospCode=""
 				if hospitalId'="" set superCode=$p(^CT("HOSP",hospitalId),"^",1) set hospCode=superCode					
				set deptType=$p($g(^CTLOC(locID)),"^",13) //科室类型
				set admType=""    //就诊类型
				set departmentGroup=""  //部门组
				if deptType="E" {
					  //判断是否是急诊科室
					 set rowIdE=$o(^PAC("ADMLOC",0,"AdmType","E",locID,0))
					 IF rowIdE'="" set admType="E"
					  //判断是否是门诊科室
					 set rowIdO=$o(^PAC("ADMLOC",0,"AdmType","O",locID,0))
					 IF rowIdO'="" set admType="O"
					 set rowIdI=$o(^PAC("ADMLOC",0,"AdmType","I",locID,0))
					 IF rowIdI'="" set admType="I"
				}
				set wardID=""
				if deptType="W"
				{
					set wardID=$o(^PAWARD(0,"WARD_LocationDR",locID,""))
				}
				
				Set ^||CacheTemp(repid,ind)=$lb(deptCode,locID,deptName,wardID,deptType,hospCode,hospitalId,admType,departmentGroup)
		        Set ind=ind+1				
		}
 	Set QHandle=$lb(0,repid,0) 
	Quit $$$OK
}

/// d ##class(%ResultSet).RunQuery("DtPortal.Common.PortalSoap","getGroupData")
Query getGroupData() As DtPortal.Query(CONTAINID = 1, ROWSPEC = "gropID:%String,gropDesc:%String")
{
}

ClassMethod getGroupDataExecute(ByRef QHandle As %Library.Binary) As %Library.Status
{
 	s repid=$I(^||CacheTemp) 
 	s ind=1 
 	s QHandle=$lb(0,repid,0)
 	set gropID=0
    for
    {
	    set gropID=$o(^SSU("SSGRP",gropID))
	    quit:gropID=""
	    
	    set gropDesc=$p(^SSU("SSGRP",gropID),"^",1)
	  
		Set ^||CacheTemp(repid,ind)=$lb(gropID,gropDesc)
		Set ind=ind+1	
	  
	}
	Set QHandle=$lb(0,repid,0) 
	Quit $$$OK
}

/// d ##class(%ResultSet).RunQuery("DtPortal.Common.PortalSoap","getUserBasicData","Doctor")
/// /获取用户信息
Query getUserBasicData(roleType As %String) As DtPortal.Query(CONTAINID = 1, ROWSPEC = "userCode:%String,userName:%String,defaultdeptCode:%String,phone:%String,mobile:%String,email:%String,CTCarPrvTpCode:%String,hospCode:%String,password:%String,age:%String,birthday:%String,createDate,invalidDate:%String,endDate:%String,isActive:%String,title:%String,pinyin:%String,idcard:%String,CountryDesc:%String,nativeplace:%String,birthplace:%String,Nation:%String,PoliticalStatus:%String,xueli:%String,Education:%String,number:%String,SSUSRECertificateNo:%String,workdate:%String,hosportal:%String,bytiem:%String,adressnum:%String")
{
}

ClassMethod getUserBasicDataExecute(ByRef QHandle As %Library.Binary, roleType As %String) As %Library.Status
{
	n (QHandle,roleType)
 	s repid=$I(^||CacheTemp) 
 	s ind=1 
 	s QHandle=$lb(0,repid,0)
 	set userID=0
	for
		{
			set userID=$o(^SSU("SSUSR",userID))
			quit:userID=""
				
			set userCode=$P(^SSU("SSUSR",userID),"^",1) //用户code
			set userName=$P(^SSU("SSUSR",userID),"^",2) //用户名称
			set isActive=$p(^SSU("SSUSR",userID),"^",19) //是否激活
			if isActive="Y" set isActive="true" 
			else  set isActive="false" 
			//continue:isActive'="true"
			//continue:ActiveFlag'="Y"
			//set locID=$P(^SSU("SSUSR",userID),"^",4) //科室id
			set locID=..getLocByUser(userID,1)				//取全部科室,用*分割,默认科室第一位 程鹏修改
			set deptCode="0"
			//set:locID'="" deptCode=$p($g(^CTLOC(locID)),"^",1) //科室code
			set deptCode=..getLocByUser(userID,2)				//取全部科室,用*分割,默认科室第一位 程鹏修改
			;continue:(roleType'="")&&(("*"_roleCode_"*")'[("*"_roleType_"*"))
			set password=$p($g(^SSU("SSUSR",userID)),"^",3) //基础数据平台保存的密码
			set password=$replace(password,"""",$c(9813))
			;set password=$zcvt(password,"O","JSON")
			;set password=$replace(password,"\","\\")
			;w password,!
			;continue
			;set password=##class(web.Util.Encryption).MD5HexStr(password) //MD5加密
			s invalidDate=$p($g(^SSU("SSUSR",userID)),"^",96)
			set invalidDate=$zd(invalidDate,3)
 			s endDate=$p($g(^SSU("SSUSR",userID)),"^",97)
 			if endDate'="" set endDate=$zd(endDate,3)
 			Set DocID=$p($g(^SSU("SSUSR",+userID)),"^",14) //获取医护人员的id
 			set email=$p($g(^CTPCP(+DocID,3)),"^",8)
 			set mobile=$p($g(^CTPCP(+DocID,3)),"^",5)
 			set phone=$p($g(^CTPCP(+DocID,2)),"^",1)
 			
 			set defaultLoc=$p($g(^SSU("SSUSR",+userID)),"^",4)   //默认科室
			set hospId =""
			set hospCode=""
			set defaultdeptCode=""
			i defaultLoc'="" {
				set defaultdeptCode=$p($g(^CTLOC(defaultLoc)),"^",1)
				set hospId=$p($g(^CTLOC(defaultLoc)),"^",22)
				set hospCode=""
				i hospId'="" set hospCode=$p($g(^CT("HOSP",hospId)),"^",1)
			}
			set CTCarPrvTpCode=""
			set cptId=##class(DtPortal.Common.PublicService).GetDocIDByUserCode(userCode)
			set title=""
			set CTCarPrvTpCode=""
			i DocID'="" {
				set CTCarPrvTpId=$p($g(^CTPCP(DocID,1)),"^",4)
				if (CTCarPrvTpId'=""){
				 	set CTCarPrvTpCode=$p($g(^CT("CPT",CTCarPrvTpId)),"^",1)
				}
				set title=$p($g(^CTPCP(DocID,3)),"^",29)
			}
			
			set pinyin=$p($g(^CTPCP(+DocID,3)),"^",28)   ///拼音
			set idcard=$p(^SSU("SSUSR",userID),"^",122)  //身份证身份证号
			set CountryDR=$P($g(^SSU("SSUSR",userID,"EXT")),"^",2)  
			i CountryDR'="" set CountryDesc=$p($g(^CT("COU",CountryDR)),"^",2)  e  set CountryDesc=""  ////籍贯
			set nativeplace=""  ///户口住址
			set birthplace=""   ///出生地
			set NationDR=$P($g(^SSU("SSUSR",userID,"EXT")),"^",3)  
			i NationDR'="" set Nation=$p($g(^CT("NAT",NationDR)),"^",2)   e   set Nation=""   ///民族
			set PoliticalStatus=$P($g(^SSU("SSUSR",userID,"EXT")),"^",10)   //// 政治面貌 
			set xueli=""  //学历
			 

            set EducationDR=$P($g(^SSU("SSUSR",userID,"EXT")),"^",5)   
            i EducationDR'="" set Education=$p($g(^CT("EDU",EducationDR)),"^",3)  e  set Education=""  ////学位
			set number=""  //执业证书编码
			set SSUSRECertificateNo=$P($g(^SSU("SSUSR",userID,"EXT")),"^",9)  ///资格证书编码	
			set workdate=""   ///参加工作时间 
			set hosportal=""  //到院时间
			set bytiem=""   ///离退时间
			set adressnum=""  ///是否城镇户口

			
			Set ^||CacheTemp(repid,ind)=$lb(userCode,userName,defaultdeptCode,phone,mobile,email,CTCarPrvTpCode,hospCode,password,"","","",invalidDate,endDate,isActive,title,pinyin,idcard,CountryDesc,nativeplace,birthplace,Nation,PoliticalStatus,xueli,Education,number,SSUSRECertificateNo,workdate,hosportal,bytiem,adressnum)
		    Set ind=ind+1					
		}
 	Set QHandle=$lb(0,repid,0) 
	Quit $$$OK
}

/// d ##class(%ResultSet).RunQuery("DtPortal.Common.PortalSoap","getUserDetailedData","Doctor")
/// /获取用户信息
Query getUserDetailedData(roleType As %String) As DtPortal.Query(CONTAINID = 1, ROWSPEC = "code:%String,rowId:%String,userCode:%String,userName:%String,orgCode:%String,postCode:%String,isDefault:%String,othllRowId:%String,isUsable:%String")
{
}

ClassMethod getUserDetailedDataExecute(ByRef QHandle As %Library.Binary, roleType As %String) As %Library.Status
{
 	s repid=$I(^||CacheTemp) 
 	s ind=1 
 	s QHandle=$lb(0,repid,0)
 	set userID=0
	for
		{
			set userID=$o(^SSU("SSUSR",userID))
			quit:userID=""
				
			set userCode=$P(^SSU("SSUSR",userID),"^",1) //用户code
			set userName=$P(^SSU("SSUSR",userID),"^",2) //用户名称
			set defaultLoc=$p($g(^SSU("SSUSR",+userID)),"^",4)   //默认科室
			set defaultdeptCode=""
			set othllRowId=""
			i defaultLoc'="" {
				set defaultdeptCode=$p($g(^CTLOC(defaultLoc)),"^",1)
			}
			set GroupDesc=""
			set CTGroupDr = $p($g(^SSU("SSUSR",userID)),"^",5)
			set locID=$p($g(^SSU("SSUSR",userID)),"^",4)
			continue:locID=""
			set orgCode=$p(^CTLOC(locID),"^",1)
			set hospitalId=$p(^CTLOC(locID),"^",22)
		 	//set hostCode=$p(^CT("HOSP",hospitalId),"^",1)
			set:CTGroupDr'="" GroupDesc=$p($g(^SSU("SSGRP",CTGroupDr)),"^",1)
			set postCode=""
			if ((CTGroupDr'="")&&(locID'=""))
			{
		 		set postCode=GroupDesc
		 		Set ^||CacheTemp(repid,ind)=$lb(userCode,userID,userCode,userName,orgCode,postCode,"true","","true")
		 		Set ind=ind+1	
			}
			set sub=0
			for
			{
				set sub=$o(^SSU("SSUSR",userID,"OTHLL",sub))
				set isUsable="true"
				q:sub=""
				set CTLocDr=$p($g(^SSU("SSUSR",userID,"OTHLL",sub)),"^",1)
				continue:CTLocDr=""
				set CTGroupDr=$p($g(^SSU("SSUSR",userID,"OTHLL",sub)),"^",2) 
				continue:CTGroupDr=""
				set endDate=$p($g(^SSU("SSUSR",userID,"OTHLL",sub)),"^",5) 
				set:endDate'="" isUsable="false"
				set GroupDesc=$p($g(^SSU("SSGRP",CTGroupDr)),"^",1)
				set orgCode=$p(^CTLOC(CTLocDr),"^",1)
				set othllRowId=userID_"||"_sub
				Set ^||CacheTemp(repid,ind)=$lb(userCode,userID,userCode,userName,orgCode,GroupDesc,"false",othllRowId,isUsable)
		 		Set ind=ind+1	
			}		
		}
 	Set QHandle=$lb(0,repid,0) 
	Quit $$$OK
}

/// Creator：      chengpeng
/// CreatDate：    2019-03-27
/// Description：  获取用户角色串
/// Input：	      UserID 
/// Return： 	  角色穿(以"*分隔")
/// w ##class(DtPortal.Common.PortalSoap).getLocGroupJson("1")
ClassMethod getLocGroupJson(UserId)
{
	new (UserId)
	set return="[]"
	set $zt="getLocGroupJson"	
	quit:UserId="" return
 	
 	set jsonObj = ##class(DtPortal.Common.JsonObject).%New()
 	set retStr="["
 	
 	set GroupDesc=""
	set CTGroupDr = $p($g(^SSU("SSUSR",UserId)),"^",5)
	set locID=$p($g(^SSU("SSUSR",UserId)),"^",4)
	set orgCode=$p(^CTLOC(locID),"^",1)
	set hospitalId=$p(^CTLOC(locID),"^",22)
 	//set hostCode=$p(^CT("HOSP",hospitalId),"^",1)
	set:CTGroupDr'="" GroupDesc=$p($g(^SSU("SSGRP",CTGroupDr)),"^",1)
	
	if (CTGroupDr'=""&&locID'="")
	{
		;d jsonObj.Put("locID",locID)
 		d jsonObj.Put("orgCode",orgCode)
 		d jsonObj.Put("postCode",GroupDesc)
 	    ;d jsonObj.Put("hospitalID",hospitalId)
 	    
 		set strJson=jsonObj.Json()
 		set:retStr'="[" retStr=retStr_","_strJson
 		set:retStr="[" retStr=retStr_strJson
	}
 	
 	
	set sub=0
	for
	{
		set sub=$o(^SSU("SSUSR",UserId,"OTHLL",sub))
		q:sub=""
		set CTLocDr=$p($g(^SSU("SSUSR",UserId,"OTHLL",sub)),"^",1)
		continue:CTLocDr=""
		set CTGroupDr=$p($g(^SSU("SSUSR",UserId,"OTHLL",sub)),"^",2) 
		continue:CTGroupDr=""
		set GroupDesc=$p($g(^SSU("SSGRP",CTGroupDr)),"^",1)
		set hospitalId=$p(^CTLOC(CTLocDr),"^",22)
		set orgCode=$p(^CTLOC(CTLocDr),"^",1)
		set jsonObj = ##class(DtPortal.Common.JsonObject).%New()
		;d jsonObj.Put("locID",CTLocDr)
 		;d jsonObj.Put("groupID",CTGroupDr)
 		;d jsonObj.Put("hospitalID",hospitalId)
 		d jsonObj.Put("orgCode",orgCode)
 		d jsonObj.Put("postCode",GroupDesc)
 		set strJson=jsonObj.Json()
 		set:retStr'="[" retStr=retStr_","_strJson
 		set:retStr="[" retStr=retStr_strJson
		 	
	}
	set retStr=retStr_"]"
	quit retStr

getLocGroupJson
	q "[]"
}

/// Creator：      chengpeng
/// CreatDate：    2017-04-13
/// Description：  获取用户角色串
/// Input：	      UserID 
/// Return： 	  角色穿(以"*分隔")
/// w ##class(DtPortal.Common.PortalSoap).getUserType(0)
ClassMethod getUserType(UserId)
{
	new (UserId)
	set return=0
	set $zt="getUserType"	
	quit:UserId="" return
 	set Type=""
 	
 	set GroupDesc=""
	set CTGroupDr = $p($g(^SSU("SSUSR",UserId)),"^",5)
	set:CTGroupDr'="" GroupDesc=$p($g(^SSU("SSGRP",CTGroupDr)),"^",1)
	if CTGroupDr'="" d setType1
 	
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
getUserType
	q -1
}

/// Creator：      chengpeng
/// CreatDate：    2018-11-29
/// Description：  获取用户有权限的科室串
/// Input：	      UserID 
/// 		      type			1时返回ID串,2时返回code串
/// Return： 	  角色穿(以"*分隔")
/// w ##class(DtPortal.Common.PortalSoap).getLocByUser(4636)
ClassMethod getLocByUser(UserId, Type = 1)
{
	new (UserId,Type)
	set return=""
	set $zt="getLocByUser"
	k ^||TMPPortalGetLocByUser
	quit:UserId="" return
 	
 	set locCode=""
 	s locID=$p($g(^SSU("SSUSR",UserId)),"^",4)
 	s:locID'="" locCode=$p($g(^CTLOC(locID)),"^",1)
 	s:locID'="" ^||TMPPortalGetLocByUser(1,locID)=locCode			//默认科室排第一位
	set sub=0
	for
	{
		set sub=$o(^SSU("SSUSR",UserId,"OTHLL",sub))
		q:sub=""
		set subLocID=$p($g(^SSU("SSUSR",UserId,"OTHLL",sub)),"^",1)
		continue:+subLocID=0
		continue:subLocID=locID									//与默认科室相同退出
		s locCode=$p($g(^CTLOC(subLocID)),"^",1)
		s ^||TMPPortalGetLocByUser(2,subLocID)=locCode			//其他科室排在默认科室之后
			
	}
	
	set locIDStr="",locCodeStr=""
	set index=0
	for
	{
		set index=$o(^||TMPPortalGetLocByUser(index))
		quit:index=""
		
		set locID=""
		for
		{
			set locID=$o(^||TMPPortalGetLocByUser(index,locID))
			quit:locID=""
			
			set locCode=$g(^||TMPPortalGetLocByUser(index,locID))
			set:locIDStr'="" locIDStr=locIDStr_"*"_locID
			set:locIDStr="" locIDStr=locID
			
			set:locCodeStr'="" locCodeStr=locCodeStr_"*"_locCode
			set:locCodeStr="" locCodeStr=locCode
		}
	}
	k ^||TMPPortalGetLocByUser
	set return=locIDStr
	set:Type=2 return=locCodeStr
	quit return
getLocByUser
	quit -1
}

/// Creator：      yupeng
/// CreatDate：    2018-10-15
/// Description：  保存用户或科室
/// Input：	       data 
/// Return： 	   state，id
/// 科室：  d ##class(%ResultSet).RunQuery("DtPortal.Common.PortalSoap","getUserOrLoc","D^haha^haha^^ZS4040^^^E^^^^^^^^^^^")
/// 用户：  d ##class(%ResultSet).RunQuery("DtPortal.Common.PortalSoap","getUserOrLoc","U^haha^haha^AAAAoAAB9AAoFK0RLijutWNIugZELAbdp8jUey1+Ot0lt8Fe^ZS4040^1^^2018-10-17^2018-10-25^^^^^Demo Group^^^^^^^^^111^111")
Query getUserOrLoc(data As %String) As DtPortal.Query(CONTAINID = 1, ROWSPEC = "state:%String,id:%String")
{
}

ClassMethod getUserOrLocExecute(ByRef QHandle As %Library.Binary, data As %String) As %Library.Status
{

	s repid=$I(^||CacheTemp) 
 	s ind=1 
 	s QHandle=$lb(0,repid,0)
	s data1=$p(data,"^",1)
	if (data1="U"){
		s userName=$$ALPHAUP^SSUTIL4($p(data,"^",3))
		s Soap=##class(dhcservice.SynchronizeUserLoc).%New()
		s SoapRtn=Soap.Save("U",$e(data,3,$l(data)))
		s userId=""
		s userId=$o(^SSU("SSUSR",0,"SSUSR_Name",userName,userId)) q:userId=""
		s state=1,id=userId
		d getData
		}else{
		s locCode=$$ALPHAUP^SSUTIL4($p(data,"^",2))
		s Soap=##class(dhcservice.SynchronizeUserLoc).%New()
		s SoapRtn=Soap.Save("D",$e(data,3,$l(data)))
		s locId=""
		s locId=$o(^CTLOC(0,"Code",locCode,locId)) q:locId=""
		s state=1,id=locId
		d getData
		}
		
getData		
	Set ^||CacheTemp(repid,ind)=$lb(state,id)
	Set ind=ind+1					
 	Set QHandle=$lb(0,repid,0) 
	Quit $$$OK
}

// 

/// Creator：cyn
/// CreatDate： 2019-12-03
/// Description: 返回职称信息
/// Input：Type:CTCarPrvTp,医护人员;CTTitle,职称
///       增加用户职称表  
/// Return：CT_CarPrvTp,CT_Title:Code,Desc
/// d ##class(%ResultSet).RunQuery("DtPortal.Common.PortalSoap","getCTCarPrvTp","CTCarPrvTp")
Query getCTCarPrvTp(Type As %String) As DtPortal.Query(ROWSPEC = "CTCPTCode:%String,CTCPTDesc:%String,CTCPTInternalType:%String")
{
}

ClassMethod getCTCarPrvTpExecute(ByRef qHandle As %Binary, Type As %String) As %Status
{
	

 	Set repid=$I(^||CacheTemp)
    Set ind=1
    Set qHandle=$lb(0,repid,0)
	Set CTCPTRowId=""
	for
		{  
			if (Type="CTCarPrvTp") {
				Set CTCPTRowId=$o(^CT("CPT",CTCPTRowId))  
				Quit:CTCPTRowId=""
				Set CTCPTCode=$p(^CT("CPT",CTCPTRowId),"^",1)
				continue:CTCPTCode=""
				Set CTCPTDesc=$p(^CT("CPT",CTCPTRowId),"^",2)
				continue:CTCPTDesc=""
				Set CTCPTInternalType=$p(^CT("CPT",CTCPTRowId),"^",4)
			}
			;if Type="CTTitle" {
			else {
				Set CTCPTRowId=$o(^CT("TTL",CTCPTRowId))
				Quit:CTCPTRowId=""
				Set CTCPTCode=$p(^CT("TTL",CTCPTRowId),"^",1)
				continue:CTCPTCode=""
				Set CTCPTDesc=$p(^CT("TTL",CTCPTRowId),"^",2)
				continue:CTCPTDesc=""
				Set CTCPTInternalType=""

			}
	  		s Data=$lb(CTCPTCode,CTCPTDesc,CTCPTInternalType)
	  		s ^||CacheTemp(repid,ind)=Data
	  		s ind=ind+1
		}
	Set QHandle=$lb(0,repid,0) 
	Quit $$$OK
}

}
