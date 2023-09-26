/// 完成UKey与用户的关联
Class web.eprajax.logs.ImportUKey Extends %CSP.Page [ ClassType = "", Not ProcedureBlock ]
{

ClassMethod OnPage() As %Status
{
	set action = $Get(%request.Data("action", 1), "-1")		
	if (action="GetCTLoc")
	{
	    s DicCode = $Get(%request.Data("DicCode",1),"")
	    s DicQuery = $Get(%request.Data("DicQuery",1),"")
	    s start = $g(%request.Data("start",1),"0")
	    s limit = $g(%request.Data("limit",1),"12")	
	    //debugger;
	    //s ^CacheTemp("GetCTLoc")=DicCode_","_DicQuery_","_start_","_limit
		d ..DicList(DicCode,DicQuery,start,limit,"True",0,"","","")
		Quit $$$OK
	}	
	set userID = %session.Get("LOGON.USERID")
	if (userID = "")
	{
		w "sessionTimedOut"
		Quit $$$OK
	}
	if (action="PostForm")
	{
	    w "{success:true}"
		Quit $$$OK
	}
	// 获取开放数字签名科室列表
	if (action="GetEnableCTLoc")
	{
	    w ..GetEnableCTLoc()
		Quit $$$OK
	}

	if (action="addCTLoc")
	{
		s ctlocid=$Get(%request.Data("ctlocid", 1), "")
		w ..AddCTLoc(ctlocid)
		Quit $$$OK
	}
	if (action="delCTLoc")
	{
		s ctlocid=$Get(%request.Data("ctlocid", 1), "")
		w ..DelCTLoc(ctlocid)
		Quit $$$OK
	}		
	// 获取指定用户的关联信息
	if (action="GetUsrSignInfo")
	{
		w ..GetUsrSignInfo()
		Quit $$$OK
	}
	// 设置数字签名功能开关
	if (action="SetCA")
	{
		if ("Y"=##Class(CA.DigitalSignatureService).IsCAON())
		{
			d ##Class(CA.DigitalSignatureService).PowerOff()
			w "0"
		}
		else 
		{
			d ##Class(CA.DigitalSignatureService).PowerOn()
			w "1"			
		}

		Quit $$$OK
	}	
	
	set userName = $Get(%request.Data("userName", 1), "")
	set usrID = ##class(EPRmeta.Privilege.PowerUser).GetUserId(userName)
	
		
	if (usrID="")
	{
		w "无此用户"
		Quit $$$OK		
	}
	// 停用用户证书s
	set isDisuse = $Get(%request.Data("isDisuse", 1), "-1")
	if (action="Disuse")
	{
		s obj=##Class(CA.UsrSignatureInfo).GetInUseInfo(usrID)
	    if (obj'="")
	    {
		    s obj.InUse=0
		    d obj.%Save()
		    w "success"
		    Quit $$$OK	
	    }
	    else
	    {
		    w "该用户无关联的UKey"
		    Quit $$$OK	
		}
	}
	 
	set identityID = $Get(%request.Data("identityID", 1), "")
	set certificate = $Get(%request.Data("certificate", 1), "")
    set certificateNo = $Get(%request.Data("certificateNo", 1), "")  
	set CertificateSN = $Get(%request.Data("CertificateSN", 1), "")
	set uKeyNo = $Get(%request.Data("uKeyNo", 1), "")
	set signImage = $Get(%request.Data("signImage", 1), "")
	set UsrCertCode = $Get(%request.Data("UsrCertCode", 1), "")
    set CertName = $Get(%request.Data("CertName", 1), "")

    s errInfo =..CheckNessaryCertInfo(certificate,certificateNo,UsrCertCode)	
    if (errInfo'="")
	{
		w "UKey信息不完整"_" "_errInfo
		Quit $$$OK
	}
     
    s userID=##Class(CA.UsrSignatureInfo).GetUsrIdByKey(UsrCertCode)
    if (userID'="")
    {
	    if (userID'=usrID)
	    {
		    w "该UKey正在使用中"
		    Quit $$$OK
		}
		else
		{
			s obj=##Class(CA.UsrSignatureInfo).GetInUseInfo(usrID)
			//obj.IdentityID=identityID && 未启用
			//&& obj.SignImage=signImage
			if ((obj.CertificateNo=certificateNo)
			     & (obj.SignImage=signImage)
			   )
			{
				w "UKey已关联该用户，请勿再次关联"
				Quit $$$OK		
			}
		 
		}
	}
    s oldImage = ""
	// 停用用户使用的证书
	s obj=##Class(CA.UsrSignatureInfo).GetInUseInfo(usrID)
	if (obj'="")
	{
		s oldImage = obj.SignImage
		s obj.InUse=0
		d obj.%Save()
	}
    // 增加新证书记录
    s obj=##Class(CA.UsrSignatureInfo).%New()
	s obj.UsrID=usrID
	s obj.IdentityID=identityID
	s obj.Certificate=certificate
	s obj.CertificateNo=certificateNo
	s obj.CertificateSN=CertificateSN
	s obj.UKeyNo=uKeyNo
	//如果新图片为空,则使用旧图片
	if (signImage'="") { s obj.SignImage=signImage }
	else { s obj.SignImage=oldImage }
    s obj.UsrCertCode=UsrCertCode
	s obj.CertName=CertName
	s obj.CreateDate=$p($h, ",", 1)
	s obj.CreateTime=$p($h, ",", 2)
	s obj.InUse=1
    d obj.%Save()
    w "success"
	Quit $$$OK
}

// 获取满足查询条件的数据Json串

ClassMethod GetUsrSignInfo() As %String
{
	s result="" 
	s ctlocid=$Get(%request.Data("ctlocid", 1), "")
	s usrName=$Get(%request.Data("usrName", 1), "")
	s isUsed=$Get(%request.Data("isUsed", 1), "")
    s getType=$Get(%request.Data("getType", 1), "") // ctlocid, usrName, usrCertCode
	
	s ret=..RetrieveInfo(ctlocid, usrName, isUsed, getType)
	s count=$p(ret, "^",1)
	if ("0"'=count)
	{
		s result=$p(ret, "^",2)
	}
	//输出查询结果Json串
	s ret = "{"
		     _"success:true"
		     _",TotalCount:'"_count_"'"
		     _",data:["
		     _result
		     _"]"
	        _"}"
	q ret
}

/// 进行查询，返回总记录数^结果
/// w ##Class(web.eprajax.logs.ImportUKey).RetrieveInfo("", "0333", "1", "usrName")
/// w ##Class(web.eprajax.logs.ImportUKey).RetrieveInfo("6", "", "1", "ctlocid")
ClassMethod RetrieveInfo(ctlocid, userName, isUsed, getType As %String) As %String
{
	s result=""
	
	// 进行查询,如果已经输入用户名，则不取考虑科室的编号
	if (getType="usrName") || (getType="usrCertCode")
	{
		s usrID=""
		if (getType="usrName")
		{
			s usrID=##class(EPRmeta.Privilege.PowerUser).GetUserId(userName)
		}
		elseif (getType="usrCertCode")
		{
			s UsrCertCode = $Get(%request.Data("UsrCertCode", 1), "")
			q:UsrCertCode="" "0" 
			s usrID=##Class(CA.UsrSignatureInfo).GetUsrIdByKey(UsrCertCode)
		}
		q:usrID="" "0"
		if (""=userName) { s userName= $p(^SSU("SSUSR",usrID), "^", 1)	}
		
		// 用户真实姓名
		s name=$p(^SSU("SSUSR",usrID), "^", 2)	
        s certName=""
        if (..HasUKey(usrID)=1)
        {
	        s ukey="已关联"
	        s certName=##Class(CA.UsrSignatureInfo).GetCertName(usrID)
	    }
	    else
	    {
		    s ukey="未关联"
		}
		s ctlocName=""
		s ctlocid=$p(^SSU("SSUSR",usrID), "^", 4)
		s ctloc=$g(^CTLOC(ctlocid))
	    if (ctloc'="") {s ctlocName=$p(ctloc, "^", 1)}
	
		s result= 
		           "{CTLOC:'"_ctlocName
	               _"',usrName:'"_userName
	               _"',Name:'"_name
	               _"',isUsed:'"_ukey
	               _"',certName:'"_certName_"'}"
		q "1"_"^"_result
		
	}
	s count=0
	// 从科室的编号开始查询所有相关的用户
	s ctloc=^CTLOC(ctlocid)
	q:ctloc="" "0"
	s ctlocName=$p(ctloc, "^", 1)
    
	s RowID = 0
	for {
		s RowID = $o(^SSU("SSUSR",RowID))
		
		q:(RowID = "")
		s user = $g(^SSU("SSUSR",+RowID))
		s usrName = $p(user,"^",1)
		s Name = $p(user,"^",2)
		s CTPCPID = $p(user,"^",14)

		//根据资源表来判断用户科室  RB_Resource
		//^RB("RES",0,"CTPCP",{RES_CTPCP_DR},{RES_CTLOC_DR},{RES_RowID})
	 
		if ($d(^RB("RES",0,"CTPCP",+CTPCPID,ctlocid)))
		{		 
			 if (isUsed=0 || (..HasUKey(RowID)=+isUsed))
			 {
				if (result'="")
		    	{
				    s result=result_","
		    	}
		    	s certName=""
		        if (..HasUKey(RowID)=1)
                {
	                s ukey="已关联"
	                s certName=##Class(CA.UsrSignatureInfo).GetCertName(RowID)
	            }
	            else
	            {
		            s ukey="未关联"
		        } 				
				s json="{CTLOC:'"_ctlocName
	        	       _"',usrName:'"_usrName
	        	       _"',Name:'"_Name
	        	       _"',isUsed:'"_ukey
	        	       _"',certName:'"_certName_"'}"	
	       		s result=result_..FilterIlleaglChar(json)       		
				s count = count+1
			 }	
		}
	}		

	q count_"^"_result
}

/// Desc:	替换掉json串中的回车换行符号
ClassMethod FilterIlleaglChar(AJson As %String) As %String
{
	s AJson = $tr(AJson,$c(10),"")
	s AJson = $tr(AJson,$c(13),"")
	q AJson
}

ClassMethod HasUKey(usrID As %String) As %Integer
{
	s obj=##Class(CA.UsrSignatureInfo).GetInUseInfo(usrID)
	
	if (obj="")
	{
		q 2
	}
	else
	{
		q 1		    
	}
}

ClassMethod DelCTLoc(CTLocID As %String) As %String
{
	s tmpIDs=""
	s CACTLocIDs=##Class(CA.DigitalSignatureService).GetCACTLocIDs()
	for i=1:1:$l(CACTLocIDs,"^")
	{
		s id=$p(CACTLocIDs,"^",i)
		if (CTLocID'=id)
		{
			if (tmpIDs'="") { s tmpIDs=tmpIDs_"^"_id }
			else { s tmpIDs=id }
		}
	}
	d ##Class(CA.DigitalSignatureService).SetCACTLocIDs(tmpIDs)
	q ""
}

/// w ##Class(web.eprajax.logs.ImportUKey).AddCTLoc(2)
ClassMethod AddCTLoc(CTLocID As %String) As %String
{
	s CACTLocIDs=##Class(CA.DigitalSignatureService).GetCACTLocIDs()
	if ("ALL"=CACTLocIDs)||("NULL"=CACTLocIDs)||(""=CACTLocIDs)
	{
		d ##Class(CA.DigitalSignatureService).SetCACTLocIDs(CTLocID)
	}
	else
	{
		s isExist=0
		for i=1:1:$l(CACTLocIDs,"^")
	    {
		    s id=$p(CACTLocIDs,"^",i)
		    if (CTLocID=id)
		    {
			    s isExist=1
			    q 
			}
	    }
	    if (0=isExist)
	    {
		    d ##Class(CA.DigitalSignatureService).SetCACTLocIDs(CACTLocIDs_"^"_CTLocID)
	    }
	    else
	    {
		    q "该科室已经开放数字签名功能！"
		}
	}
	
	q ""
}

ClassMethod GetCTLocName(ctlocid As %String)
{
	s hisName=##class(EPRmeta.SysOption).GetOptionValueByName("HospitalName")
	s ctloc=^CTLOC(ctlocid)
	if ("YKYZLYY"=hisName)
	{
        s ctlocName=$p($p(ctloc, "^", 1), "-",2)
    }
	else
	{
		s ctlocName=$p(ctloc, "^", 1)
    }
    q ctlocName
}

/// w ##Class(web.eprajax.logs.ImportUKey).GetEnableCTLoc()
ClassMethod GetEnableCTLoc() As %String
{
	s result=""
	s CACTLocIDs=##Class(CA.DigitalSignatureService).GetCACTLocIDs()
	q:(""=CACTLocIDs)||("ALL"=CACTLocIDs)||("NULL"=CACTLocIDs) "{ success:true,TotalCount:0,data:[] }"
    
    s count=0
	for i=1:1:$l(CACTLocIDs,"^")
	{
		s ctlocid=$p(CACTLocIDs,"^",i)
		q:(""=ctlocid)

        s ctlocName=..GetCTLocName(ctlocid)
        s json="{locID:'"_ctlocid_"',locName:'"_ctlocName_"'}"
        if (""=result) 
        {
	        s result=..FilterIlleaglChar(json) 
        }
	    else
	    {
		    s result=result_","_json
		}
	    s count=(count+1)
	}
	//输出查询结果Json串
	s result= "{"
		       _"success:true"
		       _",TotalCount:'"_count_"'"
		       _",data:["
		       _..FilterIlleaglChar(result)
		       _"]"
	         _"}"
	q result
}

///  检查证书信息必须项
///  w ##Class(web.eprajax.logs.ImportUKey).CheckNessaryCertInfo(1,2,3)
///  w ##Class(web.eprajax.logs.ImportUKey).CheckNessaryCertInfo("",2,3)
///  w ##Class(web.eprajax.logs.ImportUKey).CheckNessaryCertInfo(1,"",3)
///  w ##Class(web.eprajax.logs.ImportUKey).CheckNessaryCertInfo(1,2,"")
ClassMethod CheckNessaryCertInfo(certificate, certificateNo, UsrCertCode) As %String
{
	s errInfo=""
	if (certificate="") 
	{
		s errInfo="缺少证书"
	}

	if (certificateNo="")
	{
		if (errInfo="")
		{
			s errInfo="缺少证书号"
		}
		else
		{
			s errInfo=errInfo_" "_"缺少证书号"
		}
	}
		
	if (UsrCertCode="") 
	{
		if (errInfo="")
		{
			s errInfo="缺少用户证书编码"
		}
		else
		{
			s errInfo=errInfo_" "_"缺少用户证书编码"
		}	
	}
	q errInfo
}

/// d ##Class(web.eprajax.logs.ImportUKey).DicList("S07","",0,12,"True",0,"","","")
/// modify by ncc 2012-08-09
ClassMethod DicList(ADicCode As %String, AItem As %String, AStartRow As %Integer, ARowCount As %Integer, CountFlag As %String, ByRef AResultCount As %String, ByRef SessionId As %String, AConditionCode As %String = "", ACondition As %String = "")
{
    //检查参数有效性
 	if (ADicCode=$C(0)) { s ADicCode= "" Quit ""}
 	if (AItem=$C(0)){ s AItem= ""}
 	if (AStartRow=$C(0)){ s AStartRow = 0 Quit ""}
 	if (ARowCount=$C(0)){ s ARowCount = 0 Quit ""} 
 	
   	S ASessionId=$I(^CacheTemp)
   	s SessionId=ASessionId
   	K ^CacheTempStdQuery(ASessionId)
   
   	//生成字典查询结果集，并存储在临时global中
   	s PageCount= ##class(EPRmeta.StdDictionary).SelectNewStdDicPageCount(ADicCode,AItem,AStartRow,ARowCount,ASessionId,AConditionCode,ACondition)
   	s AResultCount =PageCount
   	s TotalRowCount =  $G(^CacheTempStdQueryCount(ASessionId,"StdQueryDataCount"))
   	//取相应页码的结果
  	if (PageCount'=0)
  	{ 
  		//以AStartRow开始，查询ARowCount个数据到Result中，与下面的按页查询相区别
  		s Result = ##class(%ResultSet).%New("web.eprajax.logs.ImportUKey:GetDicInTurn")
    	d Result.Execute(ADicCode,AItem,AStartRow,ARowCount,ASessionId)
  	}
  	else
  	{
		s SessionId=0
		s Result = "" 
	}
 	
 	//构造json数据
 	s json = "["
 	while(Result.Next())
 	{
	 	s json = json_"{ID:'"_$g(Result.Data("ID"))_"',"
	 	s json = json_"DicAlias:'"_$g(Result.Data("DicAlias"))_"',"
	 	s json = json_"DicCode:'"_$g(Result.Data("DicCode"))_"',"
		s json = json_"DicDesc:'"_$g(Result.Data("DicDesc"))_"'},"	
	}
    s json = $e(json, 1, $l(json)-1)
	s json = json_"]"
	
	
	w "{TotalCount:'"_TotalRowCount_"',data:"_..FilterIlleaglChar(json)_"}"
}

Query GetDicInTurn(ADicCode As %String, AItem As %String, AStartRow As %Integer, ARowCount As %Integer, ASessionId As %String) As %Query(ROWSPEC = "ID:%String,DicAlias:%String,DicCode:%String,DicDesc:%String")
{
}

ClassMethod GetDicInTurnExecute(ByRef qHandle As %Binary, ADicCode As %String, AItem As %String, AStartRow As %Integer, ARowCount As %Integer, ASessionId As %String) As %Status
{
	s qHandle="1" 
    s SQLCODE=0 
    s %counter=0
    s ID=""
    s %ResultID=""
    
    if ($D(^CacheTempStdQuery(ASessionId)))
    {
	    if ($G(^CacheTempStdQuery(ASessionId))="True") 
	    {
		    s StartPageID= AStartRow
		    s LastPageId = AStartRow+ARowCount
            s PageNumCounter = 0 
            s PageKey= $O(^CacheTempStdQuery(ASessionId,""))
            While (PageKey '="")
	        {
		        s PageNumCounter = PageNumCounter + 1
	            if (PageNumCounter> StartPageID)&(PageNumCounter <= LastPageId)
	            {
		            s %ResultID(PageNumCounter-StartPageID)= $G(^CacheTempStdQuery(ASessionId,PageKey))	 
	            }
		
	            s PageKey= $O(^CacheTempStdQuery(ASessionId,PageKey)) 	
		    }
		    s qHandle=%ResultID
            q $$$OK
		}
	}
}

ClassMethod GetDicInTurnFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDicInTurnExecute ]
{
	s SQLCODE=0 
    s $ET="QUIT" 
    s %counter=%counter+1
    if $o(%ResultID(""),-1)<%counter 
    {
	    s Row = ""
	    s AtEnd=1
    }
    else 
    {
	    s Row=%ResultID(%counter)
	}
	q $$$OK
}

ClassMethod GetDicInTurnClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDicInTurnExecute ]
{
	s qHandle="" 
	q $$$OK
}

}
