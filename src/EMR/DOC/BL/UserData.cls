/// 名称:	EMR.DOC.BL.UserData
/// 描述:	获取用户信息（用户级别）
/// 编写者：yejian
/// 编写日期: 2022-6-22
/// 产品组：电子病历产品组
Class EMR.DOC.BL.UserData Extends EMR.DOC.COM.ActionBase
{

/// Desc:       获取用户ID
/// Creator:    yejian
/// CreateDate: 2022-8-9
/// Table:		
/// Input: 		argUserInitials 用户工号, aProductCode 项目标识,，hospitalID：院区ID
/// Output:     1--合法, 0--非法
/// 				usage: w ##class(EMRmeta.PowerUser).IsLogonValid("00057",1)--1
///             在调用本方法前，需要先执行: k PLIST，以确保反复执行时结果的正确性
/// 			在Cache2010下BS程序在zn调用dhc-medsrc下$$select^MVBSSUSR来验证用户,会导致license不释放的问题  
/// Debug:      w ##Class(EMR.DOC.BL.UserData).GetUserId("YS01","1")
ClassMethod GetUserId(argUserInitials As %String, aProductCode As %String, AHospitalID As %String = "") As %String
{
	s strRes = ""
	q:(argUserInitials="") strRes
	&sql(select SSUSR_RowId into :id from SQLUser.SS_USER where SSUSR_Initials=:argUserInitials)
    
	s userPvId = $o(^CTPCP(0,"Code",$zcvt(argUserInitials,"U"),""))
    q:(userPvId = "") strRes
    q:($p(^CTPCP(userPvId,1),"^",9) '= "Y") strRes
	
	s showShareHospital = ##Class(EMR.DOC.BL.SysOption).GetOptionValueByName("showShareHospital",aProductCode,"N")
	if ((AHospitalID '= "")&&(showShareHospital = "N"))
	{
		q:(($d(^CTPCP(userPvId,"HOSP",0,"Hosp")) > 0)&&($o(^CTPCP(userPvId,"HOSP",0,"Hosp",AHospitalID,"")) = "")) strRes
	}
	
    s strRes = id
	q strRes
}

/// Desc:       获取用户级别信息
/// Creator:    yejian
/// CreateDate: 2020-12-7
/// Table:		
/// Input: 		aUserID:用户ID
/// Output:     成功：角色编码^角色名^角色等级， 失败 -1^失败信息 
/// debug:  	w ##Class(EMR.DOC.BL.UserData).GetUserDatalevel("10209")
ClassMethod GetUserDatalevel(aUserID As %String, aLangID As %String = "20") As %String
{
	s strRes = "-1^获取用户信息失败"
	q:(aUserID="") strRes
	s userPvId = $p($g(^SSU("SSUSR",aUserID)),"^",14)
	q:('$d(^CTPCP(userPvId,1))) strRes
	s userCarprvtpId = $p(^CTPCP(userPvId,1),"^",4)
	q:(userCarprvtpId = "") strRes
	q:(($p(^CTPCP(userPvId,1),"^",9) '= "Y")&&($p(^CTPCP(userPvId,1),"^",9) '= "true")) strRes
	q:('$d(^CT("CPT",userCarprvtpId))) strRes
	s userCarprvtpCode = $p($g(^CT("CPT",userCarprvtpId)),"^",1)
	q:(userCarprvtpCode = "") strRes
	s signRoleID = $o(^CF.EMR.DOC.SignRoleLinkCPTI("IdxCPTSignRole"," "_$zcvt(userCarprvtpCode,"U"),""))
	q:(signRoleID = "") strRes
	s objRole = ##class(CF.EMR.DOC.SignRole).%OpenId(signRoleID)
	q:(objRole="") strRes
	s levelName = ##Class(EMR.DOC.COM.Translation).GetTranByDesc("CF.EMR.DOC.SignRole","Description",objRole.Description,aLangID)
	q objRole.Name_"^"_levelName_"^"_objRole.RoleLevel
}

/// Desc:      标版取医生设置给患者的用户级别
/// Creator:	yejian
/// CreateDate:	2022-9-14
/// Input:	   AEpisodeID 就诊ID
///  		   AUserID  用户ID
///            ALocID 科室ID   
/// Output:    strRes 上级医师ID
/// Debug:     w ##Class(EMR.DOC.BL.UserData).GetUserLevelByEpisode("1","001","1")
ClassMethod GetUserLevelByEpisode(AEpisodeID As %String, AUserID As %String, ALocID As %String) As %String
{
	s strRes = ""
	q:(AEpisodeID = "")||(ALocID = "")||(AUserID = "") strRes
	
	q:(##class(%Dictionary.CompiledClass).%ExistsId("DHCDoc.Interface.Inside.Service") = "0") strRes
	q:(##class(%Dictionary.CompiledMethod).%ExistsId("DHCDoc.Interface.Inside.Service||GetAdmThreeCheckDoc") = "0") strRes
	
	//s docs = "[{""UserID"":""001"",""UserDesc"":""qq"",""Type"":""1"",""TypeDesc"":""管床医师""},{""UserID"":""002"",""UserDesc"":"""",""Type"":""2"",""TypeDesc"":""ee""}]"
	s docs = ##class(DHCDoc.Interface.Inside.Service).GetAdmThreeCheckDoc("",ALocID,AEpisodeID)
	q:(docs = "") strRes
	s userType = ""
	s objJson = ##class(%DynamicAbstractObject).%FromJSON(docs)
	set iter = objJson.%GetIterator()
	while iter.%GetNext(.key , .item ) {
        s jsonItem = item
		s type = jsonItem.Type
		s userId = jsonItem.UserID
		s:(AUserID = userId) userType = type
	}
	q:(userType = "") strRes
	if (userType = "1") 
	{
		s strRes = "Resident^住院医师^10"
	}
	elseif (userType = "2") 
	{
		s strRes = "Attending^主治医师^20"
	}
	elseif (userType = "3") 
	{
		s strRes = "Chief^主任医师^30"
	}
	q strRes
}

/// Desc:       判断输入的用户名和密码是否合法
/// Creator:    yejian
/// CreateDate: 2022-8-9
/// Table:		
/// Input: 		parUser: 用户名, parPasswd: 密码 aProductCode 项目标识,，hospitalID：院区ID
/// Output:     1--合法, 0--非法
/// 				usage: w ##class(EMRmeta.PowerUser).IsLogonValid("00057",1)--1
///             在调用本方法前，需要先执行: k PLIST，以确保反复执行时结果的正确性
/// 			在Cache2010下BS程序在zn调用dhc-medsrc下$$select^MVBSSUSR来验证用户,会导致license不释放的问题  
/// Debug:      w ##Class(EMR.DOC.BL.UserData).IsLogonValid("YS01","1") 
ClassMethod IsLogonValid(parUser As %String, parPasswd As %String, aProductCode As %String, hospitalID As %String = "") As %String
{
	s strRes = "0"
	//签名时校验密码，当配置“SIGN”时，与签名密码校验；否则与登录密码校验
	s jsonDefalte = {"LOGIN":"DEFAULT","SIGN":""}
	s signCheckWay = ##Class(EMR.DOC.BL.SysOption).GetOptionValueByName("signCheckPassword",aProductCode,{"LOGIN":"DEFAULT","SIGN":""})
	s objJson = ##class(%DynamicAbstractObject).%FromJSON(signCheckWay)
	//取默认验证类型
	s signType = $CASE(objJson.LOGIN,"DEFAULT":"LOGIN",:"SIGN")
	if (hospitalID'="")
	{
		s:(("^"_objJson.LOGIN_"^") [ ("^"_hospitalID_"^")) signType = "LOGIN"
		s:(("^"_objJson.SIGN_"^") [ ("^"_hospitalID_"^")) signType = "SIGN"
	}
	if (signType = "SIGN")
	{
		s userID = $o(^SSU("SSUSR",0,"SSUSR_Initials",$zcvt(parUser,"U"),""))
		s sureEncryPasswd = $p(^SSU("SSUSR",userID),"^",15)
		s noSureEncryPasswd = ##class(web.SSUser).Encrypt(parPasswd)
		s:(sureEncryPasswd = noSureEncryPasswd) strRes="1"
	}
	else
	{
		s valid=##class(web.SSUser).IsValidUser(parUser,parPasswd) 
		s:(valid>0) strRes ="1" 
	}
	q strRes
}

}
