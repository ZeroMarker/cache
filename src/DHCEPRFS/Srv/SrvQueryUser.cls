/// Desc:用户表
/// Creator:Candy
Class DHCEPRFS.Srv.SrvQueryUser Extends %SOAP.WebService [ ClassType = "", ProcedureBlock ]
{

/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/epr/dhceprfsservice";

/// Name of the WebService.
Parameter SERVICENAME = "SrvQueryUser";

/// Desc: 增加用户
/// Input：Auser 用户信息
ClassMethod AddUser(Auser As DHCEPRFS.Entity.EQueryUser, ARoleID As %String) As %String [ WebMethod ]
{
	q ##Class(DHCEPRFS.BL.BLQueryUser).AddUser(Auser,ARoleID)
}

/// Desc:增加用户规则
/// Creator：candy
/// Input:ADisLoc 出院科室规则，ACategory 查看目录规则，ADate 查找日期规则，AMedNo 病案号规则，AUserID 用户ID
ClassMethod AddUserRule(ADisLoc As %ListOfDataTypes, ACategory As %ListOfDataTypes, ADate As %String, AMedNo As %String, AUserID As %String, ANoExpirationDate As %String = "") As %String [ WebMethod ]
{
	s result = -1
	s rollbackFlag = "false"
	q:(AUserID = "") result
	s:(ADate = $c(0)) ADate = ""
	s:(AMedNo = $c(0)) AMedNo = ""
	TSTART
	s $zt = "OnAddUserRuleErrorHandler"
	s delResult = ##Class(DHCEPRFS.BL.BLQueryUser).DeleLocByUserID(AUserID)
	if (delResult=-1)
	{
		TROLLBACK
		quit "-1"
	}
	if (delResult = 1)
	{
	   for i=1:1:ADisLoc.Count()
		{
			//Order^FileName
			s oneDisLoc=ADisLoc.GetAt(i)
			s DisLocID=$p(oneDisLoc,"|",1)
			s DisLocDesc=$p(oneDisLoc,"|",2)
		    s result = ##Class(DHCEPRFS.BL.BLQueryUser).AddUserLoc(DisLocID,DisLocDesc,AUserID,i)
		    if (result=-1)
		    {
				s rollbackFlag = "true"
				quit
			}
		} 
	} 
	if (rollbackFlag="true")
	{
		TROLLBACK
		quit "-1"
	}
	s result = ##Class(DHCEPRFS.BL.BLQueryUser).AddUserCategoryDetail(ACategory,AUserID)
	if (result=-1)
	{	
		TROLLBACK
		quit "-1"
	}
	
	s SDate = $p(ADate,"^",1)
	s EDate = $p(ADate,"^",2)
	s result = ##Class(DHCEPRFS.BL.BLQueryUser).AddUserDate(SDate,EDate,AUserID,ANoExpirationDate)
	if (result=-1)
	{
		TROLLBACK
		quit "-1"
	}

    s result = ##Class(DHCEPRFS.BL.BLQueryUser).AddUserMed(AMedNo,AUserID)
    if (result=-1)
    {
	    TROLLBACK
	    q "-1"
	}
	
	TCOMMIT
	q "0"

OnAddUserRuleErrorHandler
	TROLLBACK
	q "-1"
}

/// Desc:增加用户规则
/// Creator：candy
/// Input:ADisLoc 出院科室规则，ACategory 查看目录规则，ADate 查找日期规则，AMedNo 病案号规则，AUserID 用户ID
/// Update: 对usercode与password进行加密操作
ClassMethod AddUserRuleHIS(ADisLoc As %ListOfDataTypes, ACategory As %ListOfDataTypes, ADate As %String, AMedNo As %String, SSUserRowID As %String, SSUserPassword As %String, SSUserInitial As %String, SSUserName As %String, ARoleID As %String, AIsAvailable As %String, ANoExpirationDate As %String = "") As %String [ WebMethod ]
{
	s result = -1
	s rollbackFlag = "false"
	
	q:(SSUserRowID = "") result
	s:(ADate = $c(0)) ADate = ""
	s:(AMedNo = $c(0)) AMedNo = ""
	s:(ARoleID = $c(0)) ARoleID = ""
	s:(AIsAvailable = $c(0)) AIsAvailable = ""

	s SSUserInitial = SSUserInitial
	s SSUserPassword = SSUserPassword
	//查找QueryUser表看含有此ASSUserID
	s userID = ##Class(DHCEPRFS.BL.BLQueryUser).GetUserIDBySSUserID(SSUserRowID,SSUserPassword,SSUserInitial,SSUserName,ARoleID,AIsAvailable)
	TSTART
	s $zt = "OnAddUserRuleHISErrorHandler"
	
	s delResult = ##Class(DHCEPRFS.BL.BLQueryUser).DeleLocByUserID(userID)
	if (delResult=-1)
    {
	    TROLLBACK
	    q "-1"
	}
	if (delResult = 1)
	{
		for i=1:1:ADisLoc.Count()
		{
			//Order^FileName
			s oneDisLoc=ADisLoc.GetAt(i)
			s DisLocID=$p(oneDisLoc,"|",1)
			s DisLocDesc=$p(oneDisLoc,"|",2)
			
		    s result = ##Class(DHCEPRFS.BL.BLQueryUser).AddUserLoc(DisLocID,DisLocDesc,userID,i)
		    if (result=-1)
		   	{
				s rollbackFlag="true"
				quit	
			}
		} 
	} 
	if (rollbackFlag="true")
	{
		TROLLBACK
		quit "-1"
	}
	
	s result = ##Class(DHCEPRFS.BL.BLQueryUser).AddUserCategoryDetail(ACategory,userID)
	if (result=-1)
    {
	    TROLLBACK
	    q "-1"
	}
	s SDate = $p(ADate,"^",1)
	s EDate = $p(ADate,"^",2)
	s result = ##Class(DHCEPRFS.BL.BLQueryUser).AddUserDate(SDate,EDate,userID,ANoExpirationDate)
	if (result=-1)
    {
	    TROLLBACK
	    q "-1"
	}
    s result = ##Class(DHCEPRFS.BL.BLQueryUser).AddUserMed(AMedNo,userID)
    if (result=-1)
    {
	    TROLLBACK
	    q "-1"
	}
	TCOMMIT
	q "0"

OnAddUserRuleHISErrorHandler
	TROLLBACK
	q "-1"
}

ClassMethod SaveHISUser(SSUserRowID As %String, SSUserPassword As %String, SSUserInitial As %String, SSUserName As %String, ARoleID As %String, AIsAvailable As %String) As %String [ WebMethod ]
{
	q:(SSUserRowID = "") result
	s:(ARoleID = $c(0)) ARoleID = ""
	//查找QueryUser表看含有此ASSUserID
	s userID = ##Class(DHCEPRFS.BL.BLQueryUser).GetUserIDBySSUserID(SSUserRowID,SSUserPassword,SSUserInitial,SSUserName,ARoleID,AIsAvailable)
	q:(userID '= "") "1"
	q "-1"
}

/// Desc: 根据用户代码取用户信息
/// Creator：Candy
/// Input: ACode用户代码
ClassMethod GetUserByCode(ACode As %String) As DHCEPRFS.Entity.EQueryUser [ WebMethod ]
{
	q ##Class(DHCEPRFS.BL.BLQueryUser).GetUserByCode(ACode)
}

/// Desc:根据用户ID 返回数据加载规则
/// Creator：candy
/// Input: AUserID 用户ID
/// debug: w ##Class(DHCEPRFS.Srv.SrvQueryUser).GetDataLoadRuleByUserID(0)
ClassMethod GetDataLoadRuleByUserID(AUserID As %String) As DHCEPRFS.Entity.EQueryDataLoadRule [ WebMethod ]
{
	
	s obj = ##Class(DHCEPRFS.BL.BLQueryUser).GetDataLoadRuleByUserID(AUserID)
    q obj
}

/// Desc:返回临时用户数据
/// Creator：candy
ClassMethod GetAllUsers(AOnlyShowValid As %String = "Y") As %XML.DataSet [ WebMethod ]
{
	s obj = ##Class(%XML.DataSet).%New("DHCEPRFS.BL.BLQueryUser:GetUsers")
	d obj.SetArgs("TEMP", AOnlyShowValid)
	q obj
}

/// Desc:返回HIS用户数据
ClassMethod GetHISAllUsers() As %XML.DataSet [ WebMethod ]
{
	s obj = ##Class(%XML.DataSet).%New("DHCEPRFS.BL.BLQueryUser:GetUsers")
	d obj.SetArgs("HIS")
	q obj
}

/// Desc:删除用户
/// Creator：candy
/// Input:AUserID 用户ID
ClassMethod DeleUser(AUserID As %String) As %String [ WebMethod ]
{
	s result = -1
	q:((AUserID = "") ||(AUserID = $c(0))) result
	q:($d(^DHCEPRFS.META.QueryUserD(AUserID))<=0) result
	s sc = ##class(DHCEPRFS.META.QueryUser).%DeleteId(AUserID)
	s:($$$ISOK(sc)) result = 1
	q result
}

/// Desc: 根据角色ID获得权限
/// Creator：candy
/// Input:ARoleID 角色ID
/// Output:可用权限列表
ClassMethod GetFuncByUserID(AUserID As %String) As %XML.DataSet [ WebMethod ]
{
	s obj = ##Class(%XML.DataSet).%New("DHCEPRFS.BL.BLQueryUser:GetFuntionByUserID")
	d obj.SetArgs(AUserID)
	q obj
}

ClassMethod getSSGroup(argGroupName As %String) As %XML.DataSet [ WebMethod ]
{
	s result=##class(%XML.DataSet).%New()
	
	//注：Select出这两个字段的顺序不允许修改
	if ($d(argGroupName)=0)||(argGroupName="") 
	{
		s result=##class(%XML.DataSet).%New("DHCEPRFS.BL.BLQueryUser:GetAllSSGroup")
		d result.SetArgs()
	}
	else 
	{
		s result=##class(%XML.DataSet).%New("DHCEPRFS.BL.BLQueryUser:GetSSGroupByName")
		d result.SetArgs(argGroupName)
	}
	Quit result
}

ClassMethod getSSUser(argGroupName As %String, argUserName As %String) As %XML.DataSet [ WebMethod ]
{
	s result=##Class(%XML.DataSet).%New("DHCEPRFS.BL.BLQueryUser:GetHISUser")
	d result.SetArgs(argUserName,argGroupName,"","")
	q result
}

ClassMethod GetCTLoc(CTLocName As %String) As %XML.DataSet [ WebMethod ]
{
   s result=##Class(%XML.DataSet).%New()
   
   if ($D(CTLocName)=0)||(CTLocName="")
  	{
	  	s result=##class(%XML.DataSet).%New("DHCEPRFS.BL.BLQueryUser:GetAllCTLoc")
	  	d result.SetArgs()
	}
	else {
		s result=##class(%XML.DataSet).%New("DHCEPRFS.BL.BLQueryUser:GetCTLocByName")
		d result.SetArgs(CTLocName)
	}
	q result
}

ClassMethod GetCTLocUser(CTLocName As %String, CTLocUser As %String) As %XML.DataSet [ WebMethod ]
{
	s result=##Class(%XML.DataSet).%New("DHCEPRFS.BL.BLQueryUser:GetHISUser")
	d result.SetArgs("","",CTLocName,CTLocUser)
	q result
}

ClassMethod GetHISUserByUserName(AUserName As %String) As %XML.DataSet [ WebMethod ]
{
	s result=##Class(%XML.DataSet).%New("DHCEPRFS.BL.BLQueryUser:GetHISUser")
	d result.SetArgs(AUserName,"","","")
	q result
}

ClassMethod QueryTempUser(AUserCode As %String, AUserName As %String) As %XML.DataSet [ WebMethod ]
{
	s:(AUserCode = $c(0)) AUserCode = ""
	s:(AUserName = $c(0)) AUserName = ""
	
	if ((AUserCode = "") && (AUserName = ""))
	{
		s result = ##Class(%XML.DataSet).%New("DHCEPRFS.BL.BLQueryUser:GetUsers")
		d result.SetArgs()
		q result
	}
	else
	{	
		s result = ##Class(%XML.DataSet).%New("DHCEPRFS.BL.BLQueryUser:GetTempUser")
		d result.SetArgs(AUserCode,AUserName)
		q result
	}
}

/// Desc: 对加密的用户code与passwd判断是否合法并加密返回 2022-11-16 yangshun
/// debug: w ##class(DHCEPRFS.Srv.SrvQueryUser).CheckPass("11","+-")
ClassMethod CheckPass(initial As %Library.String, password As %Library.String) As %Library.String [ WebMethod ]
{
	s eprNameSpace = $ZUTIL(5)
	s dataNameSpace = ##class(DHCEPRFS.BL.BLSysOption).GetValueByName("MedDataNameSpace")  
	S dataNameSpace = $p($g(dataNameSpace),"^",1)
	i dataNameSpace="" {s dataNameSpace="MEDDATA"}
	
	
	s initial = ##class(DHCEPRFS.Util.Encryption).DecryptWithDay(initial)
	s password = ##class(DHCEPRFS.Util.Encryption).DecryptWithDay(password)
	s EnsembleLoginVersion = $zv
	if ((EnsembleLoginVersion[" 2010.") ||  (EnsembleLoginVersion[" 2015.") ||  (EnsembleLoginVersion[" 2016.") || (EnsembleLoginVersion["IRIS"))
	{
		s ertCode=##class(web.SSUser).IsValidUser(initial,password,1)
		if (ertCode >= 0)
 		{
			q ##class(DHCEPRFS.Util.Encryption).EncryptWithDay("100")	
		}
		elseif(ertCode= 62)
		{
			q ##class(DHCEPRFS.Util.Encryption).EncryptWithDay("1")
		}
		elseif(ertCode= 63)
		{
			q ##class(DHCEPRFS.Util.Encryption).EncryptWithDay("3")
		}
		else
		{
			q ##class(DHCEPRFS.Util.Encryption).EncryptWithDay("4")
		}
	}
	else
	{
       	//EnsembleLoginVersion="EnsembleOther"
		//EnsembleLoginVersion="NULL"
	   	d $ZUTIL(5,dataNameSpace)

       	s ertCode=$$select^MVBSSUSR(initial,password)
       	d $ZUTIL(5,eprNameSpace)
       	if (ertCode = 0)
 		{
			q ##class(DHCEPRFS.Util.Encryption).EncryptWithDay("100")	
		}
		elseif(ertCode= 62)
		{
			q ##class(DHCEPRFS.Util.Encryption).EncryptWithDay("1")	
		}
		elseif(ertCode= 63)
		{
			q ##class(DHCEPRFS.Util.Encryption).EncryptWithDay("3")
		}
		else
		{
			q ##class(DHCEPRFS.Util.Encryption).EncryptWithDay("4")
		}	
	}
}

ClassMethod GetTempUserCodeAuto() As %String [ WebMethod ]
{
	s userID = ##Class(DHCEPRFS.BL.BLQueryUser).GetTempUserCodeAuto()
	q userID
}

/// Desc:将字符串返回list
/// Creator:Candy
/// Input:AValue 串 AChar 分割符
ClassMethod GetListFromString(AValue As %String, AChar As %String, AFlag As %String = "Y") As %List
{
	s ret = ""
	s $zt="GetListFromStringErr"
	s:$g(AChar)="" AChar=","
	s tmpVal="",tmpRet=""
	for Ind=1:1:$length(AValue,AChar)
	{
		s tmpVal = $p(AValue,AChar,Ind)
		continue:($zcvt(AFlag,"U") = "Y")&&(tmpVal = "")
		s tmpRet = tmpRet_$lb(tmpVal)
	}
	s ret = tmpRet
	q ret
GetListFromStringErr
   	q ""
}

/// Desc:根据现有用户复制一个临时子用户
/// Creator:yangpeng	2016.5.6
/// Input:AQueryUserID 父UserID
/// Output: “” 成功，非空报错内容
/// Debug: w ##class(DHCEPRFS.Srv.SrvQueryUser).Copy2NewChildUser("128")
ClassMethod Copy2NewChildUser(AQueryUserID As %String) As %String [ WebMethod ]
{
	s ret=##class(DHCEPRFS.BL.BLQueryUser).Copy2NewChildUser(AQueryUserID)
	q ret
}

/// Desc:	查询用户下属的子用户
/// Creator:yangpeng	2016.5.11
/// Input：	AQueryUserID 用户ID
/// Debug：	do ##class(%ResultSet).RunQuery("DHCEPRFS.Srv.SrvQueryUser","GetChildUsers","87")
ClassMethod GetChildUsers(AQueryUserID As %String) As %XML.DataSet [ WebMethod ]
{
	s result=##Class(%XML.DataSet).%New("DHCEPRFS.BL.BLQueryUser:GetChildUsers")
	d result.SetArgs(AQueryUserID)
	q result
}

/// Desc:获取用户的角色名称
/// Creator:yangpeng	2016.5.17
/// Input:AQueryUserID 
/// Output: 角色名称
/// Debug: w ##class(DHCEPRFS.BL.BLQueryUser).GetUserRoleName("128")
ClassMethod GetUserRoleName(AQueryUserID As %String) As %String [ WebMethod ]
{
	s ret=##class(DHCEPRFS.BL.BLQueryUser).GetUserRoleName(AQueryUserID)
	q ret
}

/// Desc:获取院区信息
/// Creator:liushuang	2017.9.11
/// Output: 院区信息
/// Debug: w ##class(DHCEPRFS.BL.BLQueryUser).GetHospitalArea()
ClassMethod GetHospitalArea() As %XML.DataSet [ WebMethod ]
{
	s result=##Class(%XML.DataSet).%New("DHCEPRFS.BL.BLQueryUser:GetHospitalArea")
	d result.SetArgs()
	q result
}

/// Desc: 判断HIS用户是否在归档用户表中，若不存在则增加，并分配指定角色
ClassMethod CheckAndAddHISUser(AUserID As %String, ARoleName As %String) As %String [ WebMethod ]
{
	s:(AUserID = $c(0)) AUserID = ""
	s:(ARoleName = $c(0)) ARoleName = ""
	q ##Class(DHCEPRFS.BL.BLQueryUser).CheckAndAddHISUser(AUserID,ARoleName)
}

}
