/// BDP.SSUserInterface
/// Function: 科室用户管理保存数据增加调用Portal接口同步科室用户信息
/// Creator:  sunfengchao
/// CreateDate:2019-04-21
Class BDP.SSUserInterface Extends %SOAP.WebService [ ProcedureBlock ]
{

/// WebService 的名称.
Parameter SERVICENAME = "SSUserInterface";

/// TODO:将此更改为实际 SOAP namespace.
/// WebService 的 SOAP Namespace
Parameter NAMESPACE = "http://tempuri.org";

/// 引用类的 Namespace 将在 WSDL 中使用.
Parameter USECLASSNAMESPACES = 1;

/// Function:   同步用户的数据接口 
/// Creator:    sunfengchao
/// CreateDate: 2018-08-20
/// TableName:  SS_User  
/// Debug:      w ##class(BDP.SSUserInterface).%New().SaveSSUserData(^Tempuumtest201906300("inputStream"))
Method SaveSSUserData(InputStream As %GlobalCharacterStream) As %String [ WebMethod ]
{
     s resultstr=""
     s result=""
     s resultstr="<Response><Header><SourceSystem>SYS0001</SourceSystem><MessageID/></Header><Body><data>"    
     set tSC=##class(%XML.XPATH.Document).CreateFromStream(InputStream,.tDocument)   
     
     set OperateType=""  // 推送类型
     s tSC=tDocument.EvaluateExpression("/Request/Body/type","text()",.tRes) 
     if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        set OperateType=$tr(fieldValue,$c(0),"")   
    }  
  
    s tSC=tDocument.EvaluateExpression("/Request/Body/data/user","userCode",.tRes)  
    s Cnt=tRes.Count()     
    For tI=1:1:Cnt
    { 
       Set tResult=tRes.GetAt(tI)  
        
     s Age="" // 年龄
     s tSC2=tDocument.EvaluateExpression("/Request/Body/data/user/age","text()",.tResult) 
     if ($$$ISOK(tSC2)&&(tResult.GetAt(tI)'="")){                 
        set fieldValue=tResult.GetAt(tI).Value
        set Age=$tr(fieldValue,$c(0),"")   
    } 
     s Birthday="" //生日
     s tSC2=tDocument.EvaluateExpression("/Request/Body/data/user/birthday","text()",.tResult) 
     if ($$$ISOK(tSC2)&&(tResult.GetAt(tI)'="")){                 
        set fieldValue=tResult.GetAt(tI).Value
        set Birthday=$tr(fieldValue,$c(0),"")   
    } 
     s CreateDate=""
     s tSC2=tDocument.EvaluateExpression("/Request/Body/data/user/createDate","text()",.tResult)  // 创建日期  
     if ($$$ISOK(tSC2)&&(tResult.GetAt(tI)'="")){                 
        set fieldValue=tResult.GetAt(tI).Value
        set CreateDate =$tr(fieldValue,$c(0),"") 
     }  
    s Email="" //  email   邮箱地址
    s tSC2=tDocument.EvaluateExpression("/Request/Body/data/user/email","text()",.tResult) 
    if ($$$ISOK(tSC2)&&(tResult.GetAt(tI)'="")){                 
        set fieldValue=tResult.GetAt(tI).Value
        set Email=$tr(fieldValue,$c(0),"")   
    }  
     s EndDate ="" // 失效日期
     s tSC2=tDocument.EvaluateExpression("/Request/Body/data/user/endDate","text()",.tResult) 
     if ($$$ISOK(tSC2)&&(tResult.GetAt(tI)'="")){                 
        set fieldValue=tResult.GetAt(tI).Value
        set EndDate=$tr(fieldValue,$c(0),"")   
    }  
     s IinvalidDate="" //  invalidDate 生效日期  
     s tSC2=tDocument.EvaluateExpression("/Request/Body/data/user/invalidDate","text()",.tResult) 
     if ($$$ISOK(tSC2)&&(tResult.GetAt(tI)'="")){                 
        set fieldValue=tResult.GetAt(tI).Value
        set IinvalidDate=$tr(fieldValue,$c(0),"")   
    } 
    s IsActive="" //   是否激活
    s tSC2=tDocument.EvaluateExpression("/Request/Body/data/user/isActive","text()",.tResult) 
    if ($$$ISOK(tSC2)&&(tResult.GetAt(tI)'="")){                 
        set fieldValue=tResult.GetAt(tI).Value
        set IsActive=$tr(fieldValue,$c(0),"")   
        s:IsActive="true" IsActive="Y"
        s:IsActive="false" IsActive="N"
    }  
     s Mobile=""  // 手机号码
     s tSC2=tDocument.EvaluateExpression("/Request/Body/data/user/mobile","text()",.tResult) 
     if ($$$ISOK(tSC2)&&(tResult.GetAt(tI)'="")){                 
        set fieldValue=tResult.GetAt(tI).Value
        set Mobile=$tr(fieldValue,$c(0),"")   
     }   
    
    s DefaultLOCDR=""
    s OrgStr=""  //  科室   对应 orgCode 
    s PostStr=""    ; 安全组 的数据串
    s tSCA=tDocument.EvaluateExpression("/Request/Body/data/user/orgRole/user","orgCode",.tRes)  
    s ACnt=tRes.Count()
    For tA=1:1:ACnt
    {
        Set tResult=tRes.GetAt(tA) 
        s tSCA=tDocument.EvaluateExpression("/Request/Body/data/user/orgRole/user/orgCode","text()",.tResult)   //  科室
        s OrgCode=""
        s GroupDesc=""
        if ($$$ISOK(tSCA)&&(tResult.GetAt(tA)'="")){                 
        set fieldValue=tResult.GetAt(tA).Value
        s OrgCode=$tr(fieldValue,$c(0),"")
        /// 安全组
        s tSCA=tDocument.EvaluateExpression("/Request/Body/data/user/orgRole/user/postCode","text()",.tResult) 
        if ($$$ISOK(tSCA)&&(tResult.GetAt(tA)'="")){                 
            set fieldValue=tResult.GetAt(tA).Value 
            s GroupDesc=fieldValue 
        } 
        
        s Hospital="" 
        s tSC2=tDocument.EvaluateExpression("/Request/Body/data/user/orgRole/user/hospital","text()",.tResult)  // hospital    所属院区编码
        if ($$$ISOK(tSC2)&&(tResult.GetAt(tI)'="")){                 
            set fieldValue=tResult.GetAt(tI).Value
            set Hospital =$tr(fieldValue,$c(0),"")
            //2020-08-01	likefan
            s ctlocid=""
            s:OrgCode'="" ctlocid=$o(^CTLOC(0,"Code",$$ALPHAUP^SSUTIL4(OrgCode),0))
            s:ctlocid'="" Hospital=$p($g(^CTLOC(ctlocid)),"^",22)     //医院dr
            s:Hospital'="" Hospital=$p($g(^CT("HOSP",Hospital)),"^",1)     //医院代码
        }   
      
        /// 其他登录科室 的 id   <orgPostId>3</orgPostId> 
        s orgPostId=""
        s tSCA=tDocument.EvaluateExpression("/Request/Body/data/user/orgRole/user/orgPostId","text()",.tResult) 
        if ($$$ISOK(tSCA)&&(tResult.GetAt(tA)'="")){                 
            set fieldValue=tResult.GetAt(tA).Value 
            s orgPostId=fieldValue 
        }  
        ; isMainOrg 是否默认登录科室
        s isMainOrg="" 
        s tSCA=tDocument.EvaluateExpression("/Request/Body/data/user/orgRole/user/isMainOrg","text()",.tResult) 
        if ($$$ISOK(tSCA)&&(tResult.GetAt(tA)'="")){                 
            set fieldValue=tResult.GetAt(tA).Value
            s isMainOrg=$tr(fieldValue,$c(0),"")
            if (isMainOrg="true")
            {
                 s DefaultLOCDR=OrgCode_"#"_GroupDesc_"#"_Hospital
            }
            if (isMainOrg="false")
            {
                    /// 其他登录科室 的  启停状态 
                    s status=""
                    s tSCA=tDocument.EvaluateExpression("/Request/Body/data/user/orgRole/user/status","text()",.tResult) 
                    if ($$$ISOK(tSCA)&&(tResult.GetAt(tA)'="")){                 
                    set fieldValue=tResult.GetAt(tA).Value 
                    s status=fieldValue 
                }
                
                 if (OrgCode'="")
                 {
                     if (OrgStr="") s OrgStr=OrgCode_"*"_orgPostId_"*"_status_"*"_Hospital
                     else  set OrgStr =OrgStr_"#"_OrgCode_"*"_orgPostId_"*"_status_"*"_Hospital
                 } 
                 
                 if (GroupDesc'="")
                 {
                     if (PostStr="") s PostStr=GroupDesc
                     else  set PostStr =PostStr_"#"_GroupDesc 
                 }
            }
        }
       
    }   
   } 
  
     s Phone=""   // 固定电话
     s tSC2=tDocument.EvaluateExpression("/Request/Body/data/user/phone","text()",.tResult) 
     if ($$$ISOK(tSC2)&&(tResult.GetAt(tI)'="")){                 
        set fieldValue=tResult.GetAt(tI).Value
        set Phone=$tr(fieldValue,$c(0),"")   
    } 
   
    s Remark="" /// 备注
    s tSC2=tDocument.EvaluateExpression("/Request/Body/data/user/remark","text()",.tResult) 
    if ($$$ISOK(tSC2)&&(tResult.GetAt(tI)'="")){                 
        set fieldValue=tResult.GetAt(tI).Value
        set Remark=$tr(fieldValue,$c(0),"")    
    }   
    
     s UserId="" //  用户的主键id
     s tSC2=tDocument.EvaluateExpression("/Request/Body/data/user/userId","text()",.tResult) 
     if ($$$ISOK(tSC2)&&(tResult.GetAt(tI)'="")){                 
        set fieldValue=tResult.GetAt(tI).Value
        set UserId=$tr(fieldValue,$c(0),"")   
    } 
        
     s UserCode=""   //用户编码
     s tSC2=tDocument.EvaluateExpression("/Request/Body/data/user/userCode","text()",.tResult) 
     if ($$$ISOK(tSC2)&&(tResult.GetAt(tI)'="")){                 
        set fieldValue=tResult.GetAt(tI).Value
        set UserCode=$tr(fieldValue,$c(0),"")   
    } 
       
     s UserName=""   // 用户姓名
     s tSC2=tDocument.EvaluateExpression("/Request/Body/data/user/userName","text()",.tResult) 
     if ($$$ISOK(tSC2)&&(tResult.GetAt(tI)'="")){                 
        set fieldValue=tResult.GetAt(tI).Value
        set UserName=$tr(fieldValue,$c(0),"")   
    } 
    
    s CptCode=""  /// 医护人员类型
    s tSC2=tDocument.EvaluateExpression("/Request/Body/data/user/cptCode","text()",.tResult) 
    if ($$$ISOK(tSC2)&&(tResult.GetAt(tI)'="")){                 
        set fieldValue=tResult.GetAt(tI).Value
        set CptCode =$tr(fieldValue,$c(0),"")  
    }  
    s IDCard="" // 身份证号 
    s tSC2=tDocument.EvaluateExpression("/Request/Body/data/user/IDCard","text()",.tResult) 
    if ($$$ISOK(tSC2)&&(tResult.GetAt(tI)'="")){                 
        set fieldValue=tResult.GetAt(tI).Value
        set IDCard =$tr(fieldValue,$c(0),"")  
    }  
    s educationCode="" //学历  
    s tSC2=tDocument.EvaluateExpression("/Request/Body/data/user/educationCode","text()",.tResult) 
    if ($$$ISOK(tSC2)&&(tResult.GetAt(tI)'="")){                 
        set fieldValue=tResult.GetAt(tI).Value
        set educationCode =$tr(fieldValue,$c(0),"")
        set:educationCode'="" educationCode=$o(^CT("EDU",0,"Code",$$ALPHAUP^SSUTIL4(educationCode),0))
    }  
    s nationCode="" //民族
    s tSC2=tDocument.EvaluateExpression("/Request/Body/data/user/nationCode","text()",.tResult) 
    if ($$$ISOK(tSC2)&&(tResult.GetAt(tI)'="")){                 
        set fieldValue=tResult.GetAt(tI).Value
        set nationCode =$tr(fieldValue,$c(0),"")  
        set:nationCode'="" nationCode=$o(^CT("NAT",0,"Code",$$ALPHAUP^SSUTIL4(nationCode),0))
    }  
    s SSUSREImg="" // 头像
    
    s UserStr=UserId_"^"_UserCode_"^"_UserName_"^"_Phone_"^"_Age_"^"_Mobile_"^"_Email_"^"_Birthday_"^"_IinvalidDate_"^"_EndDate_"^"_IsActive_"^"_Remark_"^^"_CreateDate_"^"_DefaultLOCDR_"^"_OrgStr_"^"_PostStr_"^"_CptCode_"^"_IDCard_"^"_educationCode_"^"_nationCode_"^"_SSUSREImg
    
    //同步数据信息   
    if (OperateType="delete") /// 删除 
    { 
       if (UserId'="")
       {  
         if (##class(User.SSUser).%ExistsId(UserId)=1)  // 用户存在 
         {
             //s ret= ##class(web.DHCBL.CT.SSUser).DeleteAll(UserId)
             s ret=..EndData(UserId)	//改为停用
             if (ret["true") /// 数据删除成功
             { 
                 s result=result_"<user><ResultCode>0</ResultCode><ResultContent>成功</ResultContent><userId>"_UserId_"</userId>"_"<userCode>"_UserCode_"</userCode></user>"  
                 s resultstr=resultstr_result  
             }
             else /// 删除失败
             {  
                 s ErrorInfo=$e($p(ret,"info:'",2),1,*-2) 
                 if ErrorInfo["<" s ErrorInfo=$tr(ErrorInfo,"<","")
                 if ErrorInfo[">" s ErrorInfo=$tr(ErrorInfo,">","")
                 if ErrorInfo["--" s ErrorInfo=$tr(ErrorInfo,"--","") 
                 s result=result_"<user><ResultCode>-1</ResultCode><ResultContent>0^"_ErrorInfo_"</ResultContent><userId>"_UserId_"</userId>"_"<userCode>"_UserCode_"</userCode></user>"  
                 s resultstr=resultstr_result 
             }
         }
         else  //用户 不存在
         {
                s ErrorInfo="用户不存在,删除失败"
                s result=result_"<user><ResultCode>-1</ResultCode><ResultContent>0^"_ErrorInfo_"</ResultContent><userId>"_UserId_"</userId>"_"<userCode>"_UserCode_"</userCode></user>"  
                s resultstr=resultstr_result
         }
       } 
    }
    elseif ((OperateType="add")||(OperateType="update")) // 数据保存
    {   
         s result=..SaveHISUserData(UserStr) 
         s resultstr=resultstr_result 
     }
    }
   s resultstr=resultstr_"</data></Body></Response>"
   q resultstr
}

/// 截止用户数据
/// 基础数据平台-likefan
/// 2022-08-15
/// w ##class(BDP.SSUserInterface).EndData("11444")
ClassMethod EndData(id As %String) As %String
{
	q:id="" ""
	s result=""
	if $d(^SSU("SSUSR",id))
	{
		s obj = ##class(User.SSUser).%OpenId(id)
		//新数据
		s eobj = ##class(web.Entity.CT.SSUser).%New()
		s eobj.SSUSRRowId=id
		s eobj.SSUSRInitials=obj.SSUSRInitials
		s eobj.SSUSRName=obj.SSUSRName
		s eobj.SSUSRDateTo=+$h
		s eobj.SSUSRActive="N"
		
		//旧数据
		s pobj = ##class(web.Entity.CT.SSUser).%New()
		s pobj.SSUSRRowId=id
		s pobj.SSUSRInitials=obj.SSUSRInitials
		s pobj.SSUSRName=obj.SSUSRName
		s pobj.SSUSRDateTo=obj.SSUSRDateTo
		s pobj.SSUSRActive=obj.SSUSRActive
		
		//保存数据
		s obj.SSUSRDateTo=eobj.SSUSRDateTo
		s obj.SSUSRActive=eobj.SSUSRActive
		TS
		s sc=obj.%Save()
		d obj.%Close()
		if (sc=1)
		{
			TC
			s id=obj.%Id()
			s result="{success:'true',id:'"_id_"'}"
			s logJson=eobj.JsonS()
			s blogJson=pobj.JsonS()
			d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLogForOther("SS_User","User.SSUser","用户",id,eobj.SSUSRName,"U",logJson,blogJson,"1")
			//停用医护人员
			s CTPCPRowId=$p($g(^SSU("SSUSR",id)),"^",14)
			d:CTPCPRowId'="" ..EndCareProvData(CTPCPRowId)
		}
		else
		{
			TRO
			s result="{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"
		}
	}
	else
	{
		s result= "{success:'false',info:'用户不存在'}"	
	}
	q result
}

/// 截止医护人员数据
/// 基础数据平台-likefan
/// 2022-08-15
/// w ##class(BDP.SSUserInterface).EndCareProvData("1144")
ClassMethod EndCareProvData(id As %String) As %String
{
	q:id="" ""
	s result=""
	if $d(^CTPCP(id))
	{
		s obj = ##class(User.CTCareProv).%OpenId(id)
		//新数据
		s eobj = ##class(web.Entity.CT.CTCareProv).%New()
		s eobj.CTPCPRowId1=id
		s eobj.CTPCPCode=obj.CTPCPCode
		s eobj.CTPCPDesc=obj.CTPCPDesc
		s eobj.CTPCPDateActiveTo=+$h
		s eobj.CTPCPActiveFlag="N"
		
		//旧数据
		s pobj = ##class(web.Entity.CT.CTCareProv).%New()
		s pobj.CTPCPRowId1=id
		s pobj.CTPCPCode=obj.CTPCPCode
		s pobj.CTPCPDesc=obj.CTPCPDesc
		s pobj.CTPCPDateActiveTo=obj.CTPCPDateActiveTo
		s pobj.CTPCPActiveFlag=obj.CTPCPActiveFlag
		
		//保存数据
		s obj.CTPCPDateActiveTo=eobj.CTPCPDateActiveTo
		s obj.CTPCPActiveFlag=eobj.CTPCPActiveFlag
		TS
		s sc=obj.%Save()
		d obj.%Close()
		if (sc=1)
		{
			TC
			s id=obj.%Id()
			s result="{success:'true',id:'"_id_"'}"
			s logJson=eobj.JsonS()
			s blogJson=pobj.JsonS()
			d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLogForOther("CT_CareProv","User.CTCareProv","医护人员",id,eobj.CTPCPDesc,"U",logJson,blogJson,"1")
		}
		else
		{
			TRO
			s result="{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"
		}
	}
	else
	{
		s result= "{success:'false',info:'医护人员不存在'}"	
	}
	q result
}

/// Function:   获取安全组id
/// CreateDate: 2020-02-01
/// Creator:    sunfengchao
/// Other:      w ##class(web.DHCBL.BDP.Interface).GetSSGroupRowId("Demo Group")
ClassMethod GetSSGroupRowId(desc As %String) As %String
{
    q:desc="" ""
    s result="" 
    s rowid=0
    for
    {
        s rowid=$o(^SSU("SSGRP",rowid)) q:rowid="" 
        s SSGRPDesc=$p($g(^SSU("SSGRP",rowid)),"^",1)
        i (desc=SSGRPDesc)
        {
            s result=rowid
            q 
        } 
    } 
    q result
}

/// Function:   保存用户和医护人员数据
/// CreateDate: 2019-05-31
/// Creator:    sunfengchao
/// Desctription:-1 : 该人事ID已经存在 
/// w ##class(BDP.SSUserInterface).SaveHISUserData(^TMPUserStr)
ClassMethod SaveHISUserData(UserStr As %String) As %String
{
    //s ^TMPUserStr=UserStr
    s result="" 
    s UserId=$p(UserStr,"^",1)                         /// User id
    s UserCode =$p(UserStr,"^",2)                      // 工号
    s UserName =$p(UserStr,"^",3)                       // 用户姓名
    s Phone =$p(UserStr,"^",4)                         //  手机号码
    s Age =$p(UserStr,"^",5)                         //   年龄
    s Mobile =$p(UserStr,"^",6)                     // 移动电话  
    s Email =$p(UserStr,"^",7)                      // Email
    s Birthday =$p(UserStr,"^",8)                    // 出生日期
    s IinvalidDate =$p(UserStr,"^",9)               //  开始日期
    s EndDate =$p(UserStr,"^",10)                     // 截止日期
    s IsActive   =$p(UserStr,"^",11)               // 是否有效
    s Remark =$p(UserStr,"^",12)                     // 备注 
    s CreateDate= $p(UserStr,"^",14)            //  修改日期 
    s DefaultLOCDRStr= $p(UserStr,"^",15)            //  默认登录的 科室 和安全组
    s OherLoginStr= $p(UserStr,"^",16)       // 其他登录科室的的科室 
    s PostStr=$p(UserStr,"^",17)             // 其他登录科室的安全组 、其他登录科室id
    s CTPCPCarPrvTpDR= $p(UserStr,"^",18)     //  医护人员类型  
    s IDCard= $p(UserStr,"^",19)            // 身份证
    s educationCode=$p(UserStr,"^",20)     // 学历 
    s nationCode= $p(UserStr,"^",21)     //   民族
    s SSUSREImg=$p(UserStr,"^",22)     // 头像
    s SSUSRRowId= UserId   
 
    s SSUserID=""  
    if (SSUSRRowId="")
    { 
        s obj=##class(User.SSUser).%New()  
        s SSUSRPassword= ##Class(web.SSUser).Encrypt("1")  //   给定一个初始密码  1
        s SSUSRPasswordChanged="Y" // 下次登录时强制用户改变密码
        s SSUSRChangeLocation="Y" //允许用户更改登录科室
    }
    else
    {
        s myobj=##class(%Dictionary.CompiledMethod).%OpenId("web.DHCBL.CT.SSUser||FormValidate") 
        if ($IsObject(myobj))
        {
             s flag=##class(web.DHCBL.CT.SSUser).FormValidate(UserId,UserCode)  //调用重复验证 
             d myobj.%Close()
        }
        else
        {
            s myobj2=##class(%Dictionary.CompiledMethod).%OpenId("web.DHCBL.CT.SSUser||Validate") 
            if ($IsObject(myobj2))
            {
                  s flag=##class(web.DHCBL.CT.SSUser).FormValidate(UserId,UserCode)  //调用重复验证 
                  d myobj2.%Close()  
            }
        } 
        
        if (flag=1)
        {
           s result= -1_"^该人事ID已经存在"
           s result=..ResultOut(result,UserCode,"")
           q result
        } 
        s obj=##class(User.SSUser).%OpenId(SSUSRRowId) 
        s SSUSRPassword=obj.SSUSRPassword // 密码为原数据 
        s SSUSRPasswordChanged=obj.SSUSRPasswordChanged // 
        s bSSUSRDefaultDeptDR=""
        s:obj.SSUSRDefaultDeptDR'="" bSSUSRDefaultDeptDR = obj.SSUSRDefaultDeptDR.%Id()
        s bSSUSRDateFrom=obj.SSUSRDateFrom
        s SSUSRChangeLocation=obj.SSUSRChangeLocation
    }    
    if (obj) 
    {     
             ; 用户信息的保存操作
            s obj.SSUSRInitials = UserCode
            s obj.SSUSRName = UserName  
            if IsActive="Y" s obj.SSUSRActive = "Y" 
            else  s obj.SSUSRActive = "N" 
            if IinvalidDate'=""  s obj.SSUSRDateFrom = ##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(IinvalidDate) 
            s:IinvalidDate="" obj.SSUSRDateFrom = +$h
            if EndDate'="" s obj.SSUSRDateTo = ##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(EndDate)  
            s DefaultLOCDR=""   // 登录科室
            s SSUSRGroupDR=""
            if DefaultLOCDRStr'=""
            {
                s DefaultLOCDR=$p(DefaultLOCDRStr,"#",1)
                s SSUSRGroupDR=$p(DefaultLOCDRStr,"#",2)
                s SSUSRHospital=""
                s Hospital= $p(DefaultLOCDRStr,"#",3)                // 医院编码 
                s:Hospital'="" SSUSRHospital=$O(^CT("HOSP",0,"Code",$$ALPHAUP^SSUTIL4(Hospital),0))   
                s:DefaultLOCDR'="" DefaultLOCDR=$o(^CTLOC(0,"Code",$$ALPHAUP^SSUTIL4(DefaultLOCDR),0))  
                s:SSUSRGroupDR'="" SSUSRGroupDR= ..GetSSGroupRowId(SSUSRGroupDR) 
                s:(Hospital="")&&(DefaultLOCDR'="") SSUSRHospital=$p($g(^CTLOC(DefaultLOCDR)),"^",22)     //取科室的医院
            } 
           d obj.SSUSRDefaultDeptDRSetObjectId(DefaultLOCDR) 
           d obj.SSUSRGroupSetObjectId(SSUSRGroupDR) /// 所在安全组  
           d obj.SSUSRHospitalDRSetObjectId(SSUSRHospital) // 默认 医院 
           s obj.SSUSRPassword= SSUSRPassword 
           s CareProvRowId=$o(^CTPCP(0,"Code",$$ALPHAUP^SSUTIL4(UserCode),0)) /// 医护人员关联dr
           d:CareProvRowId'="" obj.SSUSRCareProvDRSetObjectId(CareProvRowId) 
           s obj.SSUSRPasswordChanged=SSUSRPasswordChanged  // 下次登录时强制用户改变密码 
           s obj.SSUSRMobile = Mobile /// 手机号 
           s obj.SSUSRPager =Phone  // 固定号 --- 办公电话 
           s obj.SSUSREmail =Email  // 邮箱  
           s obj.SSUSRFreeText1= IDCard  // 身份证号 
           s obj.SSUSRAdmitted = "N"	//管理员用户
           s obj.SSUSRChangeLocation = SSUSRChangeLocation	//允许用户更改登录科室
           TSTART
           s sc=obj.%Save()     
           if ($$$ISOK(sc))
            {
                TCOMMIT 
                s SSUserID=obj.%Id()  
                ; 用户扩展表
                s SSUserExtendObj=##class(User.SSUserExtend).%OpenId(SSUserID)
                if (SSUserExtendObj)
                {
                    d SSUserExtendObj.SSUSREEducationDRSetObjectId(educationCode) //文化水平
                    d SSUserExtendObj.SSUSRENationDRSetObjectId(nationCode) // 民族
                    s SSUserExtendObj.SSUSREImg=SSUSREImg // 头像 
                    d SSUserExtendObj.%Save()
                }
                 
                //保存医护人员医院关联	2020-08-01	likefan
                if (CareProvRowId'="")
                {
	                //DefaultLOCDR
	                s SSUSRHospital=""
	                s:DefaultLOCDR'="" SSUSRHospital=$p($g(^CTLOC(DefaultLOCDR)),"^",22)     //医院
	                if (SSUSRHospital'="")
	                {
		                s hospeobj=##class(web.Entity.CT.CTCareProvHospitals).%New()
						s hospeobj.HOSPRowId=""
						s hospeobj.HOSPHospitalDR=SSUSRHospital
						s hospeobj.HOSPParRef=CareProvRowId
						D ##class(web.DHCBL.CT.CTCareProvHospitals).SaveEntity(hospeobj)
		            }
	            }
                ;同时指定科室
				if (SSUSRRowId'="")
				{
					if (CareProvRowId'="")&&(DefaultLOCDR'="")
					{
						if (bSSUSRDefaultDeptDR'="")&&(bSSUSRDefaultDeptDR'=DefaultLOCDR)	//科室有变化
						{
							//停用原指定科室
							D ##class(web.DHCBL.CT.CTCareProv).UpdateRBData(CareProvRowId,bSSUSRDefaultDeptDR,"Update",bSSUSRDateFrom,+$h)
							//新增指定科室
							D ##class(web.DHCBL.CT.CTCareProv).UpdateRBData(CareProvRowId,DefaultLOCDR,"Add",+$h,"")
						}
					}
				}
				else
				{
					if (CareProvRowId'="")&&(DefaultLOCDR'="")
					{
						D ##class(web.DHCBL.CT.CTCareProv).UpdateRBData(CareProvRowId,DefaultLOCDR,"Add",+$h,"")	
					}
				}
                
                ;; 登录科室^安全组^医院^开始日期^结束日期  OherLoginStr   PostStr
                k CTLocArr
                k CTGroupArr
                k CTLgonIdArr
                k PostCodeArr // 安全组
                k OrgCodeArr
                k EndDateArr
                k HospArr 
                s len=$length(OherLoginStr,"#") 
                if (OherLoginStr'="") // 科室 orgcode
                { 
                    for i=1:1:len
                    {
                        s DefaultLOCDR=""
                        s LocCodeStr=$p(OherLoginStr,"#",i) 
                        s LocCode=$p(LocCodeStr,"*",1) 
                        s OtherLogonId=$p(LocCodeStr,"*",2) // 其他登录科室id
                        s status=$p(LocCodeStr,"*",3) // 其他登录科室 启停状态 flag
                        s AHospital=$p(LocCodeStr,"*",4) // 其他登陆科室 所属医院 
                        s:AHospital'="" AHospital=$O(^CT("HOSP",0,"Code",$$ALPHAUP^SSUTIL4(AHospital),0))   
                        if status="true"  s EndDate="" 
                        else  s EndDate=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(+$H)
                        s:LocCode'="" DefaultLOCDR=$o(^CTLOC(0,"Code",$$ALPHAUP^SSUTIL4(LocCode),0)) 
                        s OrgCodeArr(i)= LocCode  
                        s CTLocArr(i)=DefaultLOCDR
                        s CTLgonIdArr(i)=OtherLogonId
                        s EndDateArr(i)=EndDate 
                        s HospArr(i)=AHospital
                    }
                }
                if (PostStr'="") /// 安全组
                { 
                    for j=1:1:len
                    {
                         s SSUSRGroupDR=$p(PostStr,"#",j) 
                         s PostCodeArr(j)= SSUSRGroupDR  
                         s:SSUSRGroupDR'="" SSUSRGroupDR= ..GetSSGroupRowId(SSUSRGroupDR) 
                         s CTGroupArr(j)=SSUSRGroupDR
                    } 
                }
                s UserOtherLoginStr=""
                if (OherLoginStr'=""){
                    for k=1:1:len
                    { 
                    
                       if ((CTLgonIdArr(k)="0")||(CTLgonIdArr(k)="")) 
                       {
                           s IinvalidDate=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(+$H)
                           s EndDateArr(k)=""
                       }
                       else  
                       {
                          
                       }
                       if (UserOtherLoginStr="")
                        {
                            s UserOtherLoginStr=CTLocArr(k)_"^"_CTGroupArr(k)_"^"_HospArr(i)_"^"_IinvalidDate_"^"_EndDateArr(k)_"^"_CTLgonIdArr(k)
                        }
                        else
                        {
                            s UserOtherLoginStr=UserOtherLoginStr_"*"_CTLocArr(k)_"^"_CTGroupArr(k)_"^"_HospArr(i)_"^"_IinvalidDate_"^"_EndDateArr(k)_"^"_CTLgonIdArr(k)
                        } 
                    }
                }
                s OutOtherStr="" 
                if (UserOtherLoginStr'=""){ 
                    s OtherSC= ..SaveAllForPortal(SSUserID,UserOtherLoginStr) 
                    s OutOtherStr=""
                    for m=1:1:$l(OtherSC,"^")
                    {
                        s OutOtherStr= OutOtherStr_"#"_OrgCodeArr(m)_"^"_PostCodeArr(m)_"^"_$P(OtherSC,"^",m)
                    }
                } 
                s result=1_"^数据保存成功"
                s result=..ResultOut(result,UserCode,SSUserID,OutOtherStr)
             }
             else
             {
                 TROLLBACK
                 s result= -1_"^数据保存失败:"_$system.OBJ.DisplayError(sc)  // "数据保存失败"
                 s result=..ResultOut(result,UserCode,"")
             } 
      }  
    else
    {
      s result=-1_"^对象不存在"
      s result=..ResultOut(result,UserCode,"")
    } 
    q result
}

/// Function:用户保存时返回xml格式的数据 Entity 类要继承 %XML.Adaptor
/// Creator: sunfengchao
/// CreateDate:2020-02-20
/// Others:  w ##class(BDP.SSUserInterface).ResultOut("1^AA","22a","11","CSKS002^ZZYS^1#CSKS004^ZZAS^3")
ClassMethod ResultOut(result As %String, UserCode As %String, SSUserID As %String, LogonStr As %String = "") As %String
{
    s status=0 
    s errMSG=""
    s MainObj=##class(web.Entity.CT.ExecuteStatus).%New() 
    if ($P(result,"^",1) =1) 
    {
        s status=1
        s MainObj.ResultCode=0
        s MainObj.ResultContent="成功"  // 成功
    }
   if ($P(result,"^",1)=-1) 
   {
       s MainObj.ResultCode= -1 
       s MainObj.ResultContent=result
   }  
   s eobj=##class(web.Entity.CT.CTSSUser).%New()
   s eobj.userCode=UserCode
   if (SSUserID'="") s eobj.userId=SSUserID 
   d eobj.XMLExportToString(.XML2)
   s MainObj.user= eobj
   d MainObj.XMLExportToString(.XML) 
   if (XML["<user>") s XML=$replace(XML,"<user>","")
   if (XML["<ExecuteStatus>") s XML=$replace(XML,"<ExecuteStatus>","")
   if (XML["</ExecuteStatus>") s XML=$replace(XML,"</ExecuteStatus>","")  
   if (XML["</user>") s XML=$replace(XML,"</user>","") 
   s XML=XML_"<orgRoleList>" 
  
  s OtherLocXML=""
  // s LogonStr= "CSKS002^ZZYS^1#CSKS004^ZZAS^3"
   if (LogonStr'="")
   { 
       for i=1:1:$l(LogonStr,"#") 
       { 
           s LocStr=$p(LogonStr,"#",i)
           s orgCode=$p(LocStr,"^",1)
           continue:orgCode=""
           s postCode=$p(LocStr,"^",2)
           s LocId=$p(LocStr,"^",3)
               
           if OtherLocXML=""
           {
                s OtherLocXML="<orgRole><orgCode>"_orgCode_"</orgCode><postCode>"_postCode_"</postCode><orgPostId>"_LocId_"</orgPostId></orgRole>"   
           }
           else
           {
                 s OtherLocXML=OtherLocXML_"<orgRole><orgCode>"_orgCode_"</orgCode><postCode>"_postCode_"</postCode><orgPostId>"_LocId_"</orgPostId></orgRole>"  
           } 
       } 
   }  
   s Qresult="<user>" 
   s Qresult=Qresult_XML_OtherLocXML_"</orgRoleList></user>" 
   q Qresult
}

/// Function: 测试 
/// w ##class(BDP.SSUserInterface).Test4()
ClassMethod Test4()
{
    ///日期格式YYYY-MM-DD
  set stream=##class(%GlobalCharacterStream).%New()  
  do stream.Write("<Request><Body><data><user><age>0</age><birthday/><cptCode>231</cptCode><createDate>2020-05-06</createDate><email>0243@liferay.com</email><endDate/><invalidDate/><isActive>true</isActive><mobile/><orgRole><user><hospital>Org36</hospital><isDirectorDoctor>false</isDirectorDoctor><isMainOrg>true</isMainOrg><orgCode>360004</orgCode><orgName>脊柱外科病区</orgName><orgPostId>0</orgPostId><postCode>Demo Group</postCode><status>true</status></user></orgRole><phone/><remark/><sex/><userCode>0243</userCode><userId>11888</userId><userName>胡歌</userName></user></data><type>delete</type></Body><Header><MessageID/><SourceSystem>SYS0008</SourceSystem></Header></Request>") 
  set responseStream=##class(BDP.SSUserInterface).%New().SaveSSUserData(stream)
  q responseStream
}

/// Function: 获取安全组信息
/// Creator:  sunfengchao
/// CreateDate:2019-5-31
///  d ##class(%ResultSet).RunQuery("BDP.SSUserInterface","getGroupData")
Query getGroupData() As websys.Query(CONTAINID = 1, ROWSPEC = "postID:%String,postDesc:%String")
{
}

ClassMethod getGroupDataExecute(ByRef qHandle As %Library.Binary) As %Library.Status
{
    s repid=$I(^CacheTemp)
    s ind=1
    set postID=0
    for
    {
        set postID=$o(^SSU("SSGRP",postID))
        quit:postID=""   
        set postDesc=$p(^SSU("SSGRP",postID),"^",1)  
        d DictGroupOutput  
    } 
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
DictGroupOutput
    set Data=$lb(postID,postDesc)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

/// Function:   保存科室信息    
/// Creator:    sunfengchao
/// CreateDate: 2019-06-30
/// Debug:      w ##class().SaveLOCInfo()
Method SaveLOCInfo(InputStream As %GlobalCharacterStream) As %String [ WebMethod ]
{
     s resultstr=""
     s result="" 
     s resultstr="<Response><Header><SourceSystem>SYS0001</SourceSystem><MessageID/></Header><Body><data>"   
     set tSC=##class(%XML.XPATH.Document).CreateFromStream(InputStream,.tDocument)   
     set OperateType=""  // 推送类型
     s tSC=tDocument.EvaluateExpression("/Request/Body/type","text()",.tRes) 
     if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        set OperateType=$tr(fieldValue,$c(0),"")   
    }    
    s CTLocList=""  //  科室  列表数据  
    s tSC=tDocument.EvaluateExpression("/Request/Body/data/org","address",.tRes)  
    s Cnt=tRes.Count() 
    For tI=1:1:Cnt
    { 
       Set tResult=tRes.GetAt(tI)  
       s tSC2=tDocument.EvaluateExpression("/Request/Body/data/org/orgCode","text()",.tResult)   //  
       if ($$$ISOK(tSC2)&&(tResult.GetAt(tI)'="")){                 
            set fieldValue=tResult.GetAt(tI).Value
            s OrgCode=$tr(fieldValue,$c(0),"")
       }  
        
     /// hospital    所属院区编码 
     s hospital=""  
     s tSC2=tDocument.EvaluateExpression("/Request/Body/data/org/hospital","text()",.tResult) 
     if ($$$ISOK(tSC2)&&(tResult.GetAt(tI)'="")){                 
        set fieldValue=tResult.GetAt(tI).Value
        set hospital=$tr(fieldValue,$c(0),"")   
    }  
    
     /// orgId   组织id    String  type为“add”时，orgId为空，其余为第三方组织id
     s orgId=""  
     s tSC2=tDocument.EvaluateExpression("/Request/Body/data/org/orgId","text()",.tResult) 
     if ($$$ISOK(tSC2)&&(tResult.GetAt(tI)'="")){                 
        set fieldValue=tResult.GetAt(tI).Value
        set orgId=$tr(fieldValue,$c(0),"")   
    }  
     //  orgCode 组织编码
     s orgCode=""
     s tSC2=tDocument.EvaluateExpression("/Request/Body/data/org/orgCode","text()",.tResult)  // 创建日期  
     if ($$$ISOK(tSC2)&&(tResult.GetAt(tI)'="")){                 
        set fieldValue=tResult.GetAt(tI).Value
        set orgCode =$tr(fieldValue,$c(0),"") 
     }  
    s orgName="" //    组织描述
    s tSC2=tDocument.EvaluateExpression("/Request/Body/data/org/orgName","text()",.tResult) 
    if ($$$ISOK(tSC2)&&(tResult.GetAt(tI)'="")){                 
        set fieldValue=tResult.GetAt(tI).Value
        set orgName=$tr(fieldValue,$c(0),"")    
    }  
     s deptType ="" //   组织类型
     s tSC2=tDocument.EvaluateExpression("/Request/Body/data/org/deptType","text()",.tResult) 
     if ($$$ISOK(tSC2)&&(tResult.GetAt(tI)'="")){                 
        set fieldValue=tResult.GetAt(tI).Value
        set deptType=$tr(fieldValue,$c(0),"")   
    }  
     s parentOrgCode="" //      父组织编码
     s tSC2=tDocument.EvaluateExpression("/Request/Body/data/org/parentOrgCode","text()",.tResult) 
     if ($$$ISOK(tSC2)&&(tResult.GetAt(tI)'="")){                 
        set fieldValue=tResult.GetAt(tI).Value
        set parentOrgCode=$tr(fieldValue,$c(0),"")   
    } 
    s phone="" //  联系方式
    s tSC2=tDocument.EvaluateExpression("/Request/Body/data/org/phone","text()",.tResult) 
    if ($$$ISOK(tSC2)&&(tResult.GetAt(tI)'="")){                 
        set fieldValue=tResult.GetAt(tI).Value
        set phone=$tr(fieldValue,$c(0),"")    
    }  
     s address=""  // 地址
     s tSC2=tDocument.EvaluateExpression("/Request/Body/data/org/address","text()",.tResult) 
     if ($$$ISOK(tSC2)&&(tResult.GetAt(tI)'="")){                 
        set fieldValue=tResult.GetAt(tI).Value
        set address=$tr(fieldValue,$c(0),"")   
     }   
    s isActive=""  /// 是否激活
    s tSC2=tDocument.EvaluateExpression("/Request/Body/data/org/isActive","text()",.tResult)  
    if ($$$ISOK(tSC2)&&(tResult.GetAt(tI)'="")){                 
        set fieldValue=tResult.GetAt(tI).Value
        set isActive =$tr(fieldValue,$c(0),"") 
        s:isActive="true" isActive="Y"
        s:isActive="false" isActive="N"
    }  
    s CTLOCStr=orgId_"^"_hospital_"^"_orgCode_"^"_orgName_"^"_deptType_"^"_parentOrgCode_"^"_phone_"^"_address_"^"_isActive 
    
      //同步数据信息              
    if (OperateType="delete") /// 删除 
    {    
       if (orgId'="")
       {  
         s result=##class(web.DHCBL.CT.CTLoc).DeleteData(orgId) 
         if (result["true") /// 数据删除成功
         {
             s result="<org>" 
             s result=result_"<ResultCode>0</ResultCode><ResultContent>成功</ResultContent>"
             s result=result_"<orgId>"_orgId_"</orgId>"_"<orgCode>"_orgCode_"</orgCode></org>"   
         }
         else /// 删除失败
         { 
         
            /// 统一平台 传删除科室的时候，his要是判断有关联不能删除，就给处理成停用，返回信息就是：“科室有关联不能删除但已停用” 
         
            if (result["表里被引用") // 判断是否被引用
            {
                s CTLocObj=##class(User.CTLoc).%OpenId(orgId)
                if (CTLocObj)
                {
                    s CTLocObj.CTLOCDateActiveTo=+$H
                    s CTLocObjSc=CTLocObj.%Save()
                    if (CTLocObjSc=1)
                    {
                        s result="<org>"
                        s result=result_"<ResultCode>0</ResultCode><ResultContent>成功,科室有关联不能删除但已停用</ResultContent>"
                        s result=result_"<orgId>"_orgId_"</orgId><orgCode>"_orgCode_"</orgCode></org>"   
                    }
                }
            } 
            else
            { 
                 s result="<org>"
                 s result=result_"<ResultCode>-1</ResultCode><ResultContent>-1^删除失败</ResultContent>"
                 s result=result_"<orgId>"_orgId_"</orgId><orgCode>"_orgCode_"</orgCode></org>"  
            } 
         } 
       }
       else
       {
            s result="<org>"
            s result=result_"<ResultCode>-1</ResultCode><ResultContent>-1^id为空</ResultContent>"
            s result=result_"<orgId>"_orgId_"</orgId><orgCode>"_orgCode_"</orgCode></org>"      
       }
       s resultstr=resultstr_result 
    }
     elseif ((OperateType="add")||(OperateType="update")) // 数据保存
     {    
         if ((deptType="Hosp")) // 院区数据保存
         {    
            s HospStr = orgId_"^"_orgCode_"^"_orgName
            s result=..SaveHospData(HospStr) 
            s resultstr=resultstr_result
         }
         else
         {
            s result=..SaveLOCData(CTLOCStr) 
            s resultstr=resultstr_result
         }
     } 
    }
   s resultstr=resultstr_"</data></Body></Response>"
   q resultstr
}

/// Function: 医院修改
/// CraetDate:2020-02-11
/// Creator:  sunfengchao
/// w ##class(BDP.SSUserInterface).SaveHospData("^13^重庆人民医院(分院区)")
ClassMethod SaveHospData(HospStr As %String) As %String
{
    s orgId=$P(HospStr,"^",1)
    s orgCode=$P(HospStr,"^",2)
    s orgName=$P(HospStr,"^",3)
    if (orgId="") s obj=##class(User.CTHospital).%New()
    else  s obj=##class(User.CTHospital).%OpenId(orgId)
    s obj.HOSPCode = orgCode               
    s obj.HOSPDesc= orgName           
    if (orgId="")
    {   
       s obj.HOSPDateFrom = +$H
       s obj.HOSPDateTo=""
    }
    else
    {
       s obj.HOSPDateFrom = $p($g(^CT("HOSP",orgId)),"^",1)
       s obj.HOSPDateTo=$p($g(^CT("HOSP",orgId)),"^",2)
    }                 
    Tstart
    s sc=obj.%Save()
    do obj.%Close()
    if $$$ISOK(sc)
    {
        Tcommit
        s id = obj.%Id() 
        s result="<org>"
        s result=result_"<status>1</status><errMSG>0</errMSG>"
        s result=result_"<orgId>"_id_"</orgId>"_"<orgCode>"_orgCode_"</orgCode></org>"                   
    }
    else
    {
        Trollback
        s result="<org>"
        s result=result_"<status>0</status><errMSG>-1^数据保存失败:"_$system.OBJ.DisplayError(sc)_"</errMSG>"
        s result=result_"<orgId></orgId><orgCode>"_orgCode_"</orgCode></org>"    
    }
    q result
}

/// Function: 保存科室信息
/// CreateDate:2020-01-12
/// Creator:  sunfengchao
/// Others:   w ##class(BDP.SSUserInterface).ModifyUserPassword("t9^UUU111")
ClassMethod SaveLOCData(CTLOCStr As %String) As %String
{
 
    s orgId=$P(CTLOCStr,"^",1)
    s hospital=$P(CTLOCStr,"^",2)
    s orgCode=$P(CTLOCStr,"^",3)
    s orgName=$P(CTLOCStr,"^",4)
    s deptType=$P(CTLOCStr,"^",5)
    s parentOrgCode=$P(CTLOCStr,"^",6) /// 部门组
    s phone=$P(CTLOCStr,"^",7)
    s address=$P(CTLOCStr,"^",8)
    s isActive=$P(CTLOCStr,"^",9)   
    s myobj=##class(%Dictionary.CompiledMethod).%OpenId("web.DHCBL.CT.CTLoc||FormValidate") 
    if ($IsObject(myobj))
    {
        s flag=##class(web.DHCBL.CT.CTLoc).FormValidate(orgId,orgCode,orgName)  //调用重复验证
        d myobj.%Close()
    }
    else
    {
        s myobj2=##class(%Dictionary.CompiledMethod).%OpenId("web.DHCBL.CT.CTLoc||Validate") 
        if ($IsObject(myobj2))
        {
            s flag=##class(web.DHCBL.CT.CTLoc).Validate(orgId,orgCode,orgName)  //调用重复验证
            d myobj2.%Close() 
        }
    } 
    if (flag=1)
    {  
         s result="<org>"
         s result=result_"<ResultCode>-1</ResultCode><ResultContent>-1^数据保存失败:科室代码或科室描述重复</ResultContent>"
         s result=result_"<orgId></orgId><orgCode>"_orgCode_"</orgCode></org>"   
    }
    else
    {   
        if (deptType="I") 
        {
            s deptType="E"
        }
        elseif (deptType="O")
        {
             s deptType="E" 
        }
        elseif (deptType="E") 
        {
            s deptType="EM"
        }
       elseif (deptType="Other") 
       {
           s deptType="O"
       }
       elseif (deptType="other") 
       {
           s deptType="O"
       }
       else
       {
          // s deptType=deptType
       }  
        if (orgId="")
        {
            s obj= ##class(User.CTLoc).%New()
        }
        else
        {
            s obj = ##class(User.CTLoc).%OpenId(orgId)
        }   
        s obj.CTLOCCode = orgCode
        s obj.CTLOCDesc = orgName   
        s obj.CTLOCType= deptType  
        s AddressList=##class(%ListOfDataTypes).%New()
        do AddressList.Insert(address)
        s obj.CTLOCAddress = AddressList      
        if (isActive="true")||(isActive="Y")
        {
            s isActive="Y"
            s obj.CTLOCDateActiveTo=""
        }
        if (isActive="false")||(isActive="N")
        {
            s isActive="N"
            s obj.CTLOCDateActiveTo=+$H // 非激活 加结束日期
        }
        s obj.CTLOCActiveFlag=isActive 
        s CTLOCHospitalDR=""
        s:hospital'="" CTLOCHospitalDR=$o(^CT("HOSP",0,"Code",$$ALPHAUP^SSUTIL4(hospital),0))
        d obj.CTLOCHospitalDRSetObjectId(CTLOCHospitalDR)  
        s obj.CTLOCTelephone=phone
        // 科室部门组
        if (+parentOrgCode'=0)
        {
            s parentOrgCode=$o(^RBC("DEP",0,"Code",$$ALPHAUP^SSUTIL4(parentOrgCode),0))
            d obj.CTLOCDepDRSetObjectId(parentOrgCode)   
        } 
        TSTART
        s sc= obj.%Save() 
        if (sc=1)
        {
             TCOMMIT
             s result=1_"^数据保存成功"
             s id=obj.%Id()
             s result="<org>"
             s result=result_"<ResultCode>0</ResultCode><ResultContent>成功</ResultContent>"
             s result=result_"<orgId>"_id_"</orgId>"_"<orgCode>"_orgCode_"</orgCode></org>"   
         }
         else
         {
             TROLLBACK
             s result="<org>"
             s result=result_"<ResultCode>-1</ResultCode><ResultContent>-1^数据保存失败:"_$system.OBJ.DisplayError(sc)_"</ResultContent>"
             s result=result_"<orgId></orgId><orgCode>"_orgCode_"</orgCode></org>"   
         }       
    }  
    q result
}

/// Function:  安全组信息查询
/// CreateDate:2020-01-12
/// Creator:  sunfengchao
/// Others:   w ##class(BDP.SSUserInterface).getGroupData()
ClassMethod getGroupData() As %String
{
    s result=""
    set postID=0
    for
    {
        set postID=$o(^SSU("SSGRP",postID))
        quit:postID=""   
        set postDesc=$p(^SSU("SSGRP",postID),"^",1) 
        s eobj=##class(web.Entity.CT.CTSSGroup).%New()
        s eobj.postID=postID
        s eobj.postDesc=postDesc 
        d eobj.XMLExportToString(.XML)
        s result=result_XML
    } 
  q result
}

/// FunctionL:用户密码修改
/// CreateDate:2020-01-12
/// Creator:  sunfengchao
/// Others:   w ##class(BDP.SSUserInterface).ModifyUserPassword("t9^UUU111")
Method ModifyUserPassword(DataStr As %String) As %String [ WebMethod ]
{
    s result="{status:'-1'}"
    q:DataStr="" "{status:'-1',errMSG:'参数为空'}"
    s UserCode=$P(DataStr,"^",1)     // 工号
    q:UserCode="" "{status:'-1',errMSG:'工号为空'}"
    s Password =$P(DataStr,"^",2)     // 密码
    s SSUserID=""
    s SSUserID=$o(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(UserCode),0))
    q:SSUserID="" "{status:'-1',errMSG:'员工不存在'}"
    s obj=##class(User.SSUser).%OpenId(SSUserID)
    if (obj)
    {
        s obj.SSUSRPassword=Password
        TSTART
        s sc=obj.%Save()
        if (sc=1)
        {
            TCOMMIT
            s result="{status:'1'}" 
        }
        else
        {
            TROLLBACK
            s result="{status:'-1'}"
        }
    }
    q result
}

/// Function: 提供给Portal组 调用  
/// CreateDate:2020-02-22
/// Creator:  sunfengchao
/// w ##class(BDP.ChargeInterfaceService).SaveAllForPortal("11887","263^18^^2020-03-05^^0")
ClassMethod SaveAllForPortal(rowid As %String, locstr As %String) As %String
{
    s idstr=""
    s result=""
    s startDateExist=##class(web.DHCBL.BDP.FindTableStructure).PropertyExistOrNot("User.SSUserOtherLogonLoc","OTHLLStartDate")
    s endDateExist=##class(web.DHCBL.BDP.FindTableStructure).PropertyExistOrNot("User.SSUserOtherLogonLoc","OTHLLEndDate")
    if (locstr'=""){
        s loclength=$Length(locstr,"*")
        for i=1:1:loclength
        {
            s loc=$p(locstr,"*",i)
            s OTHLLParRef = rowid
            s OTHLLCTLOCDR = $p(loc,"^",1)
            s OTHLLUserGroupDR = $p(loc,"^",2)
            s OTHLLHospitalDR = $p(loc,"^",3) // 医院 
           // s:OTHLLCTLOCDR'="" OTHLLHospitalDR=$p($g(^CTLOC(OTHLLCTLOCDR)),"^",22)
          //  s:OTHLLCTLOCDR="" OTHLLHospitalDR=""
            s OTHLLStartDate = $p(loc,"^",4)
            s OTHLLEndDate = $p(loc,"^",5)
            s OTHLLRowId = $p(loc,"^",6) 
            ;s:OTHLLStartDate="" OTHLLStartDate=+$h //界面开始日期非必填
            
            //校验其他登录科室	20200922	likefan
            s StartDate=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(OTHLLStartDate)
            s EndDate=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(OTHLLEndDate)
            s:OTHLLRowId=0 OTHLLRowId=""
            s Validateflag=##class(web.DHCBL.CT.SSUserOtherLogonLoc).FormValidate(OTHLLParRef,OTHLLRowId,OTHLLCTLOCDR,OTHLLUserGroupDR,StartDate,EndDate)
            continue:Validateflag=1
            
            if ((OTHLLRowId="")||(OTHLLRowId=0))
            {
                s obj=##class(User.SSUserOtherLogonLoc).%New(rowid)  
            }
            else
            {
                s obj=##class(User.SSUserOtherLogonLoc).%OpenId(OTHLLRowId)
                s:obj.OTHLLCTLOCDR'="" bOTHLLCTLOCDR = obj.OTHLLCTLOCDR.%Id()
                s:obj.OTHLLCTLOCDR="" bOTHLLCTLOCDR = ""
                s:obj.OTHLLUserGroupDR'="" bOTHLLUserGroupDR = obj.OTHLLUserGroupDR.%Id()
                s:obj.OTHLLUserGroupDR="" bOTHLLUserGroupDR = ""
                s:obj.OTHLLHospitalDR'="" bOTHLLHospitalDR = obj.OTHLLHospitalDR.%Id()
                s:obj.OTHLLHospitalDR="" bOTHLLHospitalDR = ""
                if ((startDateExist'=0) && (endDateExist'=0)){
                    s bOTHLLStartDate = obj.OTHLLStartDate
                    s bOTHLLEndDate = obj.OTHLLEndDate
                    s blogJson="{OTHLLParRef:"""_OTHLLParRef_""",OTHLLCTLOCDR:"""_bOTHLLCTLOCDR_""",OTHLLUserGroupDR:"""_bOTHLLUserGroupDR_""",OTHLLHospitalDR:"""_bOTHLLHospitalDR_""",OTHLLStartDate:"""_bOTHLLStartDate_""",OTHLLEndDate:"""_bOTHLLEndDate_""",OTHLLRowId:"""_OTHLLRowId_"""}"
                }
                else{
                    s blogJson="{OTHLLParRef:"""_OTHLLParRef_""",OTHLLCTLOCDR:"""_bOTHLLCTLOCDR_""",OTHLLUserGroupDR:"""_bOTHLLUserGroupDR_""",OTHLLHospitalDR:"""_bOTHLLHospitalDR_""",OTHLLRowId:"""_OTHLLRowId_"""}" 
                }
                
            }
            d obj.OTHLLParRefSetObjectId(OTHLLParRef)
            d obj.OTHLLCTLOCDRSetObjectId(OTHLLCTLOCDR)
            d obj.OTHLLUserGroupDRSetObjectId(OTHLLUserGroupDR)
            d obj.OTHLLHospitalDRSetObjectId(OTHLLHospitalDR)
            s:OTHLLCTLOCDR'="" CTLOCDesc=$p($g(^CTLOC(OTHLLCTLOCDR)),"^",2)
            s:OTHLLCTLOCDR="" CTLOCDesc=""
            if ((startDateExist'=0) && (endDateExist'=0))
            {
                if OTHLLStartDate'=""
                { 
                    s obj.OTHLLStartDate = ##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(OTHLLStartDate)
                }
                else
                {
                    s obj.OTHLLStartDate=""
                }
                if OTHLLEndDate'=""
                { 
                    s obj.OTHLLEndDate = ##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(OTHLLEndDate)
                }
                else
                {
                    s obj.OTHLLEndDate=""
                }
                s logJson="{OTHLLParRef:"""_OTHLLParRef_""",OTHLLCTLOCDR:"""_OTHLLCTLOCDR_""",OTHLLUserGroupDR:"""_OTHLLUserGroupDR_""",OTHLLHospitalDR:"""_OTHLLHospitalDR_""",OTHLLStartDate:"""_obj.OTHLLStartDate_""",OTHLLEndDate:"""_obj.OTHLLEndDate_""",OTHLLRowId:"""_OTHLLRowId_"""}"
            }
            else
            {
                s logJson="{OTHLLParRef:"""_OTHLLParRef_""",OTHLLCTLOCDR:"""_OTHLLCTLOCDR_""",OTHLLUserGroupDR:"""_OTHLLUserGroupDR_""",OTHLLHospitalDR:"""_OTHLLHospitalDR_""",OTHLLRowId:"""_OTHLLRowId_"""}"
            }
            ;同时指定科室
            s SSUSRCareProvDR=$p($g(^SSU("SSUSR",rowid)),"^",14) 
            if (SSUSRCareProvDR'=""){
                s CTPCPActiveFlag=$p($g(^CTPCP(SSUSRCareProvDR,1)),"^",9)
                if (CTPCPActiveFlag="Y"){
                    s CTPCPCarPrvTpDR=$p($g(^CTPCP(SSUSRCareProvDR,1)),"^",4) 
                    s:CTPCPCarPrvTpDR'="" CTCPTInternalType=$p($g(^CT("CPT",CTPCPCarPrvTpDR)),"^",4)
                    s:CTPCPCarPrvTpDR="" CTCPTInternalType=""
                    if ((CTCPTInternalType="NURSE")||(CTCPTInternalType="DOCTOR"))
                    {  
                        if ((OTHLLRowId'="")&(OTHLLRowId'=0))
                        { 
                            s ParRef=$p($g(OTHLLRowId),"||",1)  
                            s ChildSub=$p($g(OTHLLRowId),"||",2) 
                            s bCTLOCDR=$p($g(^SSU("SSUSR",ParRef,"OTHLL",ChildSub)),"^",1)
                            if ((bCTLOCDR'="")&(OTHLLCTLOCDR'=bCTLOCDR)){
                                s brid=$o(^RB("RES",0,"CTPCP",SSUSRCareProvDR,bCTLOCDR,0))
                                if (brid'=""){
                                    s robj=##class(User.RBResource).%OpenId(brid) 
                                    s rbeobj=##class(web.Entity.CT.RBResource).%New()
                                    s rbeobj.RESRowId1=brid
                                    s rbeobj.RESCTPCPDR=SSUSRCareProvDR
                                    s rbeobj.RESCTLOCDR=bCTLOCDR
                                    s rbeobj.RESDateActiveTo=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml($p($h,",",1))
                                    
                                    s rbeobj.RESAdmittingRights=robj.RESAdmittingRights
                                    s rbeobj.RESScheduleRequired=robj.RESScheduleRequired
                                    s rbeobj.RESMRRequest=robj.RESMRRequest
                                    s rbeobj.RESDateActiveFrom=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(robj.RESDateActiveFrom)
                                    d ##class(web.DHCBL.CT.RBResource).SaveEntity(rbeobj)   
                                }                       
                            }
                        }
                        if (OTHLLCTLOCDR'=""){ 
                            s rbeobj=##class(web.Entity.CT.RBResource).%New()
                            s rid=$o(^RB("RES",0,"CTPCP",SSUSRCareProvDR,OTHLLCTLOCDR,0))
                            s rbeobj.RESRowId1=rid
                            s rbeobj.RESCTPCPDR=SSUSRCareProvDR
                            s rbeobj.RESCTLOCDR=OTHLLCTLOCDR
                            if (rid'=""){
                                s robj=##class(User.RBResource).%OpenId(rid)
                                s rbeobj.RESDateActiveTo=""
                                s rbeobj.RESAdmittingRights=robj.RESAdmittingRights
                                s rbeobj.RESScheduleRequired=robj.RESScheduleRequired
                                s rbeobj.RESMRRequest=robj.RESMRRequest
                            }else{
                                s rbeobj.RESAdmittingRights="Y"
                                s rbeobj.RESScheduleRequired="Y"
                                s rbeobj.RESMRRequest="Y"
                            }
                            i OTHLLStartDate=""
                            {s rbeobj.RESDateActiveFrom = ""}          
                            else
                            {s rbeobj.RESDateActiveFrom = OTHLLStartDate}
                            d ##class(web.DHCBL.CT.RBResource).SaveEntity(rbeobj)
                        }   
                    }
                }
            }

            s sc=obj.%Save()
            d obj.%Close()
            If $$$ISOK(sc){
                s id = obj.%Id()
                if (idstr="") s idstr=id
                else  s idstr=idstr_"^"_id
                s result = "{success:'true',id:'"_id_"'}"    
                
                //保存医护人员医院关联	2020-08-01	likefan
                s SSUSRCareProvDR=$p($g(^SSU("SSUSR",OTHLLParRef)),"^",14)      //医护人员DR
                if (SSUSRCareProvDR'="")
                {
	                s HOSPHospitalDR=""
	                s:OTHLLCTLOCDR'="" HOSPHospitalDR=$p($g(^CTLOC(OTHLLCTLOCDR)),"^",22)     //医院
	                if (HOSPHospitalDR'="")
	                {
		                s hospeobj=##class(web.Entity.CT.CTCareProvHospitals).%New()
						s hospeobj.HOSPRowId=""
						s hospeobj.HOSPHospitalDR=HOSPHospitalDR
						s hospeobj.HOSPParRef=SSUSRCareProvDR
						D ##class(web.DHCBL.CT.CTCareProvHospitals).SaveEntity(hospeobj)
		            }
	            }
                
                d:OTHLLRowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLogForOther("SS_UserOtherLogonLoc","User.SSUserOtherLogonLoc","其他登录科室",id,CTLOCDesc,"A",logJson)
                d:((OTHLLRowId'="")&(OTHLLRowId'=0)) ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLogForOther("SS_UserOtherLogonLoc","User.SSUserOtherLogonLoc","其他登录科室",OTHLLRowId,CTLOCDesc,"U",logJson,blogJson)
            }
            else{
                s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"
                s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("其他登录科室","web.DHCBL.CT.SSUserOtherLogonLoc","SaveAll",logJson)
                s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc) 
                s idstr=idstr
            }   
        }
         
        //update by程鹏 新增项目现在用的同步程序，用户新增安全组，同步角色到portal
        //update start
        s PortalFlag=##class(web.DHCBL.BDP.BDPConfig).GetConfigValue("BDPUsePortal")
        if (PortalFlag="Y"){
            try{
                if (##class(web.DHCBL.BDP.BDPDataChangeLog).IsValidClassName("DtPortal.Configure.DataSync")=1){
                    if (##class(web.DHCBL.BDP.BDPDataChangeLog).IsValidMethodName("DtPortal.Configure.DataSync","SyncUserSoap")=1){
                        d ##class(DtPortal.Configure.DataSync).SyncUserSoap(rowid,1)
                    }
                }
            
            }catch myvar{
                ;myvar.Name 会显示报错信息

                if (result="<SYNTAX>")
                {
                    s result="{success:'false',info:'Please conform to the Portal condition'}" 
                    s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("Portal用户","web.DHCBL.CT.SSUserOtherLogonLoc","SaveAll",rowid_"+"_locstr)
                    s ^ERRORLOGINFO(logid)="Please conform to the Portal condition" 
                }   
            }
        }
        //update end
        q idstr
    }
}

///  w ##class(BDP.SSUserInterface).Test1()
ClassMethod Test1()
{
  ///日期格式YYYY-MM-DD
  set stream=##class(%GlobalCharacterStream).%New()  
  do stream.Write("<Request><Body><data><user><age>0</age><birthday/><cptCode>233</cptCode><createDate>2020-09-22</createDate><email/><endDate/><invalidDate>2020-09-22</invalidDate><isActive>true</isActive><mobile/><orgRole><user><hospital>SLSYY</hospital><isDirectorDoctor>false</isDirectorDoctor><isMainOrg>true</isMainOrg><orgCode>PortalTest</orgCode><orgName>Portal测试</orgName><orgPostId>0</orgPostId><postCode>住院医师</postCode><status>true</status></user></orgRole><phone/><remark/><sex/><userCode>PortalTest5</userCode><userId>11914<userId/><userName>Portal测试5</userName></user></data><type>add</type></Body><Header><MessageID/><SourceSystem>SYS0001</SourceSystem></Header></Request>")  
  set responseStream=##class(BDP.SSUserInterface).%New().SaveSSUserDataForPortal(stream)
  q responseStream
}

/// Function:   同步用户的数据接口 ,同时生成用户和医护人员
/// Creator:    sunfengchao
/// CreateDate: 2018-08-20
/// TableName:  SS_User  
/// Debug:      w ##class(BDP.SSUserInterface).%New().SaveSSUserDataForPortal()
Method SaveSSUserDataForPortal(InputStream As %GlobalCharacterStream) As %String [ WebMethod ]
{
     s resultstr=""
     s result=""
     s resultstr="<Response><Header><SourceSystem>SYS0001</SourceSystem><MessageID/></Header><Body><data>"     
     set tSC=##class(%XML.XPATH.Document).CreateFromStream(InputStream,.tDocument)   
     
     set OperateType=""  // 推送类型
     s tSC=tDocument.EvaluateExpression("/Request/Body/type","text()",.tRes) 
     if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        set OperateType=$tr(fieldValue,$c(0),"")   
    }  
  
    s tSC=tDocument.EvaluateExpression("/Request/Body/data/user","userCode",.tRes)  
    s Cnt=tRes.Count()     
    For tI=1:1:Cnt
    { 
       Set tResult=tRes.GetAt(tI)  
        
     s Age="" // 年龄
     s tSC2=tDocument.EvaluateExpression("/Request/Body/data/user/age","text()",.tResult) 
     if ($$$ISOK(tSC2)&&(tResult.GetAt(tI)'="")){                 
        set fieldValue=tResult.GetAt(tI).Value
        set Age=$tr(fieldValue,$c(0),"")   
    } 
     s Birthday="" //生日
     s tSC2=tDocument.EvaluateExpression("/Request/Body/data/user/birthday","text()",.tResult) 
     if ($$$ISOK(tSC2)&&(tResult.GetAt(tI)'="")){                 
        set fieldValue=tResult.GetAt(tI).Value
        set Birthday=$tr(fieldValue,$c(0),"")   
    } 
     s CreateDate=""
     s tSC2=tDocument.EvaluateExpression("/Request/Body/data/user/createDate","text()",.tResult)  // 创建日期  
     if ($$$ISOK(tSC2)&&(tResult.GetAt(tI)'="")){                 
        set fieldValue=tResult.GetAt(tI).Value
        set CreateDate =$tr(fieldValue,$c(0),"") 
     }  
    s Email="" //  email   邮箱地址
    s tSC2=tDocument.EvaluateExpression("/Request/Body/data/user/email","text()",.tResult) 
    if ($$$ISOK(tSC2)&&(tResult.GetAt(tI)'="")){                 
        set fieldValue=tResult.GetAt(tI).Value
        set Email=$tr(fieldValue,$c(0),"")   
    }  
     s EndDate ="" // 失效日期
     s tSC2=tDocument.EvaluateExpression("/Request/Body/data/user/endDate","text()",.tResult) 
     if ($$$ISOK(tSC2)&&(tResult.GetAt(tI)'="")){                 
        set fieldValue=tResult.GetAt(tI).Value
        set EndDate=$tr(fieldValue,$c(0),"")   
    }  
     s IinvalidDate="" //  invalidDate 生效日期  
     s tSC2=tDocument.EvaluateExpression("/Request/Body/data/user/invalidDate","text()",.tResult) 
     if ($$$ISOK(tSC2)&&(tResult.GetAt(tI)'="")){                 
        set fieldValue=tResult.GetAt(tI).Value
        set IinvalidDate=$tr(fieldValue,$c(0),"")   
    } 
    s IsActive="" //   是否激活
    s tSC2=tDocument.EvaluateExpression("/Request/Body/data/user/isActive","text()",.tResult) 
    if ($$$ISOK(tSC2)&&(tResult.GetAt(tI)'="")){                 
        set fieldValue=tResult.GetAt(tI).Value
        set IsActive=$tr(fieldValue,$c(0),"")   
        s:IsActive="true" IsActive="Y"
        s:IsActive="false" IsActive="N"
    }  
     s Mobile=""  // 手机号码
     s tSC2=tDocument.EvaluateExpression("/Request/Body/data/user/mobile","text()",.tResult) 
     if ($$$ISOK(tSC2)&&(tResult.GetAt(tI)'="")){                 
        set fieldValue=tResult.GetAt(tI).Value
        set Mobile=$tr(fieldValue,$c(0),"")   
     }   
    s Hospital="" 
    s tSC2=tDocument.EvaluateExpression("/Request/Body/data/user/hospital","text()",.tResult)  // hospital    所属院区编码
    if ($$$ISOK(tSC2)&&(tResult.GetAt(tI)'="")){                 
        set fieldValue=tResult.GetAt(tI).Value
        set Hospital =$tr(fieldValue,$c(0),"") 
    }    
    s DefaultLOCDR=""
    s OrgStr=""  //  科室   对应 orgCode 
    s PostStr=""    ; 安全组 的数据串
    s tSCA=tDocument.EvaluateExpression("/Request/Body/data/user/orgRole/user","orgCode",.tRes)  
    s ACnt=tRes.Count()
    For tA=1:1:ACnt
    {
        Set tResult=tRes.GetAt(tA) 
        s tSCA=tDocument.EvaluateExpression("/Request/Body/data/user/orgRole/user/orgCode","text()",.tResult)   //  科室
        s OrgCode=""
        s GroupDesc=""
        if ($$$ISOK(tSCA)&&(tResult.GetAt(tA)'="")){                 
        set fieldValue=tResult.GetAt(tA).Value
        s OrgCode=$tr(fieldValue,$c(0),"")
        /// 安全组
        s tSCA=tDocument.EvaluateExpression("/Request/Body/data/user/orgRole/user/postCode","text()",.tResult) 
        if ($$$ISOK(tSCA)&&(tResult.GetAt(tA)'="")){                 
            set fieldValue=tResult.GetAt(tA).Value 
            s GroupDesc=fieldValue 
        } 
      
        /// 其他登录科室 的 id   <orgPostId>3</orgPostId> 
        s orgPostId=""
        s tSCA=tDocument.EvaluateExpression("/Request/Body/data/user/orgRole/user/orgPostId","text()",.tResult) 
        if ($$$ISOK(tSCA)&&(tResult.GetAt(tA)'="")){                 
            set fieldValue=tResult.GetAt(tA).Value 
            s orgPostId=fieldValue 
        }  
        ; isMainOrg 是否默认登录科室
        s isMainOrg="" 
        s tSCA=tDocument.EvaluateExpression("/Request/Body/data/user/orgRole/user/isMainOrg","text()",.tResult) 
        if ($$$ISOK(tSCA)&&(tResult.GetAt(tA)'="")){                 
            set fieldValue=tResult.GetAt(tA).Value
            s isMainOrg=$tr(fieldValue,$c(0),"")
            if (isMainOrg="true")
            {
                 s DefaultLOCDR=OrgCode_"#"_GroupDesc
            }
            if (isMainOrg="false")
            {
                /// 其他登录科室 的  启停状态 
                s status=""
                s tSCA=tDocument.EvaluateExpression("/Request/Body/data/user/orgRole/user/status","text()",.tResult) 
                if ($$$ISOK(tSCA)&&(tResult.GetAt(tA)'=""))
                {                 
                set fieldValue=tResult.GetAt(tA).Value 
                s status=fieldValue 
                }
                
                 if (OrgCode'="")
                 {
                     if (OrgStr="") s OrgStr=OrgCode_"*"_orgPostId_"*"_status
                     else  set OrgStr =OrgStr_"#"_OrgCode_"*"_orgPostId_"*"_status
                 } 
                 
                 if (GroupDesc'="")
                 {
                     if (PostStr="") s PostStr=GroupDesc
                     else  set PostStr =PostStr_"#"_GroupDesc 
                 }
            }
        }
       
    }   
   } 
  
     s Phone=""   // 固定电话
     s tSC2=tDocument.EvaluateExpression("/Request/Body/data/user/phone","text()",.tResult) 
     if ($$$ISOK(tSC2)&&(tResult.GetAt(tI)'="")){                 
        set fieldValue=tResult.GetAt(tI).Value
        set Phone=$tr(fieldValue,$c(0),"")   
    } 
   
    s Remark="" /// 备注
    s tSC2=tDocument.EvaluateExpression("/Request/Body/data/user/remark","text()",.tResult) 
    if ($$$ISOK(tSC2)&&(tResult.GetAt(tI)'="")){                 
        set fieldValue=tResult.GetAt(tI).Value
        set Remark=$tr(fieldValue,$c(0),"")    
    }   
    
     s UserId="" //  用户的主键id
     s tSC2=tDocument.EvaluateExpression("/Request/Body/data/user/userId","text()",.tResult) 
     if ($$$ISOK(tSC2)&&(tResult.GetAt(tI)'="")){                 
        set fieldValue=tResult.GetAt(tI).Value
        set UserId=$tr(fieldValue,$c(0),"")   
    } 
        
     s UserCode=""   //用户编码
     s tSC2=tDocument.EvaluateExpression("/Request/Body/data/user/userCode","text()",.tResult) 
     if ($$$ISOK(tSC2)&&(tResult.GetAt(tI)'="")){                 
        set fieldValue=tResult.GetAt(tI).Value
        set UserCode=$tr(fieldValue,$c(0),"")   
    } 
       
     s UserName=""   // 用户姓名
     s tSC2=tDocument.EvaluateExpression("/Request/Body/data/user/userName","text()",.tResult) 
     if ($$$ISOK(tSC2)&&(tResult.GetAt(tI)'="")){                 
        set fieldValue=tResult.GetAt(tI).Value
        set UserName=$tr(fieldValue,$c(0),"")   
    } 
    
    s CptCode=""  /// 医护人员类型
    s tSC2=tDocument.EvaluateExpression("/Request/Body/data/user/cptCode","text()",.tResult) 
    if ($$$ISOK(tSC2)&&(tResult.GetAt(tI)'="")){                 
        set fieldValue=tResult.GetAt(tI).Value
        set CptCode =$tr(fieldValue,$c(0),"")  
    }  
       
    s UserStr=UserId_"^"_UserCode_"^"_UserName_"^"_Phone_"^"_Age_"^"_Mobile_"^"_Email_"^"_Birthday_"^"_IinvalidDate_"^"_EndDate_"^"_IsActive_"^"_Remark_"^"_Hospital_"^"_CreateDate_"^"_DefaultLOCDR_"^"_OrgStr_"^"_PostStr_"^"_CptCode
    
    //同步数据信息   
    if (OperateType="delete") /// 删除 
    { 
       if (UserId'="")
       { 
         if (##class(User.SSUser).%ExistsId(UserId)=1)  // 用户存在 
         { 
             s ret= ##class(web.DHCBL.CT.SSUser).DeleteAll(UserId)
             if (ret["true") /// 数据删除成功
             { 
                 s result=result_"<user><ResultCode>0</ResultCode><ResultContent>成功</ResultContent><userId>"_UserId_"</userId>"_"<userCode>"_UserCode_"</userCode></user>"  
                 //s result=result_"<user><status>1</status><errMSG>0</errMSG><userId>"_UserId_"</userId>"_"<userCode>"_UserCode_"</userCode></user>"  
                 s resultstr=resultstr_result  
             }
             else /// 删除失败
             {  
                 s ErrorInfo=$e($p(ret,"info:'",2),1,*-2) 
                 if ErrorInfo["<" s ErrorInfo=$tr(ErrorInfo,"<","")
                 if ErrorInfo[">" s ErrorInfo=$tr(ErrorInfo,">","")
                 if ErrorInfo["--" s ErrorInfo=$tr(ErrorInfo,"--","") 
                 //s result=result_"<user><status>-1</status><errMSG>0^"_ErrorInfo_"</errMSG><userId>"_UserId_"</userId>"_"<userCode>"_UserCode_"</userCode></user>"  
                 s result=result_"<user><ResultCode>-1</ResultCode><ResultContent>0^"_ErrorInfo_"</ResultContent><userId>"_UserId_"</userId>"_"<userCode>"_UserCode_"</userCode></user>"  
                 s resultstr=resultstr_result 
             }
           } 
         }
         else  //用户 不存在
         {
                s ErrorInfo="用户不存在,删除失败"
                s result=result_"<user><ResultCode>-1</ResultCode><ResultContent>0^"_ErrorInfo_"</ResultContent><userId>"_UserId_"</userId>"_"<userCode>"_UserCode_"</userCode></user>"  
                s resultstr=resultstr_result
         }
    }
    elseif ((OperateType="add")||(OperateType="update")) // 数据保存
    {   
         s result=..SaveHISUserDataForPortal(UserStr) 
         s resultstr=resultstr_result 
     }
    } 
   s resultstr=resultstr_"</data></Body></Response>"
   q resultstr
}

/// Function:   保存用户和医护人员数据
/// CreateDate: 2019-05-31
/// Creator:    sunfengchao
/// Desctription:-1 : 该人事ID已经存在 
ClassMethod SaveHISUserDataForPortal(UserStr As %String) As %String
{
    //s ^TMPUserStr=UserStr
    s result="" 
    s UserId=$p(UserStr,"^",1)                         /// User id
    s UserCode =$p(UserStr,"^",2)                      // 工号
    s UserName =$p(UserStr,"^",3)                       // 用户姓名
    s Phone =$p(UserStr,"^",4)                         //  手机号码
    s Age =$p(UserStr,"^",5)                         //   年龄
    s Mobile =$p(UserStr,"^",6)                        //  移动电话  
    s Email =$p(UserStr,"^",7)                      // Email
    s Birthday =$p(UserStr,"^",8)                    // 出生日期
    s IinvalidDate =$p(UserStr,"^",9)               //  开始日期
    s EndDate =$p(UserStr,"^",10)                     // 截止日期
    s IsActive   =$p(UserStr,"^",11)               // 是否有效
    s Remark =$p(UserStr,"^",12)                     // 备注
    s Hospital= $p(UserStr,"^",13)                     // 医院编码 
    s CreateDate= $p(UserStr,"^",14)            //  修改日期 
    s DefaultLOCDRStr= $p(UserStr,"^",15)            //  默认登录的 科室 和安全组
    s OherLoginStr= $p(UserStr,"^",16)       // 其他登录科室的的科室 
    s PostStr=$p(UserStr,"^",17)             // 其他登录科室的安全组 、其他登录科室id
    s CTPCPCarPrvTpDR= $p(UserStr,"^",18)     //  医护人员类型 
    s SSUSRHospital=""
    s:Hospital'="" SSUSRHospital=$O(^CT("HOSP",0,"Code",Hospital,0))  
    s SSUSRRowId= UserId    
    s SSUserID=""  
    if (SSUSRRowId="")
    { 
        s obj=##class(User.SSUser).%New()  
        s SSUSRPassword= ##Class(web.SSUser).Encrypt("1")  //   给定一个初始密码  1
    }
    else
    {
        s myobj=##class(%Dictionary.CompiledMethod).%OpenId("web.DHCBL.CT.SSUser||FormValidate") 
        if ($IsObject(myobj))
        {
             s flag=##class(web.DHCBL.CT.SSUser).FormValidate(UserId,UserCode)  //调用重复验证 
             d myobj.%Close()
        }
        else
        {
            s myobj2=##class(%Dictionary.CompiledMethod).%OpenId("web.DHCBL.CT.SSUser||Validate") 
            if ($IsObject(myobj2))
            {
                  s flag=##class(web.DHCBL.CT.SSUser).FormValidate(UserId,UserCode)  //调用重复验证 
                  d myobj2.%Close()  
            }
        } 
        
        if (flag=1)
        {
           s result= -1_"^该人事ID已经存在"
           s result=..ResultOut(result,UserCode,"")
           q result
        } 
        s obj=##class(User.SSUser).%OpenId(SSUSRRowId)  
        s SSUSRPassword=obj.SSUSRPassword // 密码为原数据
    }    
    if (obj) 
    {      ; 用户信息的保存操作
        s obj.SSUSRInitials = UserCode
        s obj.SSUSRName = UserName 
        d:SSUSRHospital'="" obj.SSUSRHospitalDRSetObjectId(SSUSRHospital)
        d:SSUSRHospital="" obj.SSUSRHospitalDRSetObjectId("") 
        if IsActive="Y" s obj.SSUSRActive = "Y" 
        else  s obj.SSUSRActive = "N" 
        if IinvalidDate'=""  s obj.SSUSRDateFrom = ##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(IinvalidDate) 
        if EndDate'="" s obj.SSUSRDateTo = ##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(EndDate)
        s:SSUSRRowId="" obj.SSUSRChangeLocation = "Y"	//允许用户更改登录科室
         // 登录科室
        s DefaultLOCDR=""
        s SSUSRGroupDR=""
        if DefaultLOCDRStr'=""
        {
            s DefaultLOCDR=$p(DefaultLOCDRStr,"#",1)
            s SSUSRGroupDR=$p(DefaultLOCDRStr,"#",2)
            s:DefaultLOCDR'="" DefaultLOCDR=$o(^CTLOC(0,"Code",$$ALPHAUP^SSUTIL4(DefaultLOCDR),0))  
            s:SSUSRGroupDR'="" SSUSRGroupDR= ..GetSSGroupRowId(SSUSRGroupDR) 
        } 
        d obj.SSUSRDefaultDeptDRSetObjectId(DefaultLOCDR) 
        d obj.SSUSRGroupSetObjectId(SSUSRGroupDR) /// 所在安全组  
        s obj.SSUSRPassword= SSUSRPassword 
        ;新增数据时 需要先保存医护人员再保存用户
        ;修改数据时则没顺序要求 
        s CareProvID=""
        if (CTPCPCarPrvTpDR'="")
        {    
            if (SSUSRRowId'="") s CareProvID=$p($g(^SSU("SSUSR",SSUSRRowId)),"^",14)  
            if (CareProvID="")
            {
                s CTObj=##class(User.CTCareProv).%New()  
            }
            else
            {
                s CTObj=##class(User.CTCareProv).%OpenId(CareProvID)   
            } 
            if (CTObj)
            {
                 s CTObj.CTPCPCode=  UserCode
                 s CTObj.CTPCPDesc= UserName
                 s CTPCPOtherName =##class(web.DHCBL.BDP.FunLib).GetPYCODE(UserName)
                 s CTObj.CTPCPOtherName=CTPCPOtherName
                 s CTObj.CTPCPEmail = Email    
                 s CTObj.CTPCPTelO =  Phone 
                 s CTObj.CTPCPMobilePhone =  Mobile
                 //20200922
                 if IsActive="Y" s CTObj.CTPCPActiveFlag = "Y" 
       			 else  s CTObj.CTPCPActiveFlag = "N" 
       			 
                 i IinvalidDate'=""  s CTObj.CTPCPDateActiveFrom = ##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(IinvalidDate) 
                 i EndDate'="" s CTObj.CTPCPDateActiveTo= ##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(EndDate)
                 
                 ;CTPCPCarPrvTpDR 医护人员类型 找id
                
                 s:CTPCPCarPrvTpDR'="" CTPCPCarPrvTpDR=$o(^CT("CPT",0,"Code",$zcvt(CTPCPCarPrvTpDR,"U"),0))
                 d CTObj.CTPCPCarPrvTpDRSetObjectId(CTPCPCarPrvTpDR)  
                 s CTObj.CTPCPUpdateDate=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(CreateDate) // 修改日期 
                 TSTART   
                 s sc2=CTObj.%Save()
                 if ($$$ISOK(sc2))
                 {
                     TCOMMIT 
                     s CareProvRowId=CTObj.%Id()     
                     d:CareProvRowId'="" obj.SSUSRCareProvDRSetObjectId(CareProvRowId) 
                     if CareProvID="" /// 增加 默认科室 对应的 指定科室  2020-4-14
                     { 
                        if (DefaultLOCDR'="")
                        {        
                            s iobj=##class(User.RBResource).%New()
                            s iobj.RESCode = CTObj.CTPCPCode 
                            s iobj.RESDesc = CTObj.CTPCPDesc
                            d iobj.RESCTLOCDRSetObjectId(DefaultLOCDR)
                            d iobj.RESCTPCPDRSetObjectId(CareProvRowId)
                            s iobj.RESAdmittingRights="Y"
                            s iobj.RESMRRequest = "N"    
                            s isc=iobj.%Save() 
                            d iobj.%Close()  
                         }
                         else
                         {
                            s CTLOCDR=0
                            for  
                            {               
                                s CTLOCDR=$o(^RB("RES",0,"CTPCP",CareProvID,CTLOCDR)) q:CTLOCDR=""
                                s iid=$o(^RB("RES",0,"CTPCP",CareProvID,CTLOCDR,0))
                                s iobj=##class(User.RBResource).%OpenId(iid)
                                s iobj.RESDesc = eobj.CTPCPDesc
                                s isc=iobj.%Save()
                                d iobj.%Close() 
                            }   
                         } 
                   }
                     
                 }
                 else
                 {
                     TROLLBACK
                     s result =-1_"^数据保存失败:"_ $system.OBJ.DisplayError(sc2) 
                     s result=..ResultOut(result,UserCode,"")
                 } 
            }  
         } 
          
             TSTART
             s sc=obj.%Save()   
             
             if ($$$ISOK(sc))
             {
                TCOMMIT 
                s SSUserID=obj.%Id()  
                ;; 登录科室^安全组^医院^开始日期^结束日期  OherLoginStr   PostStr
                k CTLocArr
                k CTGroupArr
                k CTLgonIdArr
                k PostCodeArr // 安全组
                k OrgCodeArr
                k EndDateArr
                s len=$length(OherLoginStr,"#") 
                if (OherLoginStr'="") // 科室 orgcode
                { 
                    for i=1:1:len
                    {
                        s DefaultLOCDR=""
                        s LocCodeStr=$p(OherLoginStr,"#",i) 
                        s LocCode=$p(LocCodeStr,"*",1) 
                        s OtherLogonId=$p(LocCodeStr,"*",2) // 其他登录科室id
                        s status=$p(LocCodeStr,"*",3) // 其他登录科室 启停状态 flag
                        if status="true"  s EndDate="" 
                        else  s EndDate=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(+$H)
                        s:LocCode'="" DefaultLOCDR=$o(^CTLOC(0,"Code",$$ALPHAUP^SSUTIL4(LocCode),0)) 
                        s OrgCodeArr(i)= LocCode  
                        s CTLocArr(i)=DefaultLOCDR
                        s CTLgonIdArr(i)=OtherLogonId
                        s EndDateArr(i)=EndDate 
                    }
                }
                if (PostStr'="") /// 安全组
                { 
                    for j=1:1:len
                    {
                         s SSUSRGroupDR=$p(PostStr,"#",j) 
                         s PostCodeArr(j)= SSUSRGroupDR  
                         s:SSUSRGroupDR'="" SSUSRGroupDR= ..GetSSGroupRowId(SSUSRGroupDR) 
                         s CTGroupArr(j)=SSUSRGroupDR
                    } 
                }
                s UserOtherLoginStr=""
                if (OherLoginStr'=""){
                    for k=1:1:len
                    { 
                    
                       if ((CTLgonIdArr(k)="0")||(CTLgonIdArr(k)="")) 
                       {
                           s IinvalidDate=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(+$H)
                           s EndDateArr(k)=""
                       }
                       else  
                       {
                          
                       }
                       if (UserOtherLoginStr="")
                        {
                            s UserOtherLoginStr=CTLocArr(k)_"^"_CTGroupArr(k)_"^^"_IinvalidDate_"^"_EndDateArr(k)_"^"_CTLgonIdArr(k)
                        }
                        else
                        {
                            s UserOtherLoginStr=UserOtherLoginStr_"*"_CTLocArr(k)_"^"_CTGroupArr(k)_"^^"_IinvalidDate_"^"_EndDateArr(k)_"^"_CTLgonIdArr(k)
                        } 
                    }
                }
                s OutOtherStr="" 
                if (UserOtherLoginStr'=""){ 
                    s OtherSC= ..SaveAllForPortal(SSUserID,UserOtherLoginStr) 
                    s OutOtherStr=""
                    for m=1:1:$l(OtherSC,"^")
                    {
                        s OutOtherStr= OutOtherStr_"#"_OrgCodeArr(m)_"^"_PostCodeArr(m)_"^"_$P(OtherSC,"^",m)
                    }
                } 
                s result=1_"^数据保存成功"
                s result=..ResultOut(result,UserCode,SSUserID,OutOtherStr)
             }
             else
             {
                 TROLLBACK
                 s result= -1_"^数据保存失败:"_$system.OBJ.DisplayError(sc)  // "数据保存失败"
                 s result=..ResultOut(result,UserCode,"")
             } 
      }  
    else
    {
      s result=-1_"^对象不存在"
      s result=..ResultOut(result,UserCode,"")
    } 
    q result
}

/// Function:用户保存时返回xml格式的数据 Entity 类要继承 %XML.Adaptor
/// Creator: sunfengchao
/// CreateDate:2020-02-20
/// Others:  w ##class(BDP.SSUserInterface).ResultOut("1^AA","22a","11","CSKS002^ZZYS^1#CSKS004^ZZAS^3")
ClassMethod ResultOutForPortal(result As %String, UserCode As %String, SSUserID As %String, LogonStr As %String = "") As %String
{
    s status=0 
    s errMSG=""
    s MainObj=##class(web.Entity.CT.ExecuteStatusForPortal).%New() 
    if ($P(result,"^",1) =1) 
    {
        s status=1
        s MainObj.status=1
        s MainObj.errMSG="1"
    }
   if ($P(result,"^",1)=-1) 
   {
       s MainObj.status=0
       s MainObj.errMSG=result
   }  
   s eobj=##class(web.Entity.CT.CTSSUser).%New()
   s eobj.userCode=UserCode
   if (SSUserID'="") s eobj.userId=SSUserID 
   d eobj.XMLExportToString(.XML2)
   s MainObj.user= eobj
   d MainObj.XMLExportToString(.XML) 
   if (XML["<user>") s XML=$replace(XML,"<user>","")
   if (XML["<ExecuteStatus>") s XML=$replace(XML,"<ExecuteStatus>","")
   if (XML["</ExecuteStatus>") s XML=$replace(XML,"</ExecuteStatus>","")  
   if (XML["</user>") s XML=$replace(XML,"</user>","") 
   s XML=XML_"<orgRoleList>" 
  
  s OtherLocXML=""
  // s LogonStr= "CSKS002^ZZYS^1#CSKS004^ZZAS^3"
   if (LogonStr'="")
   { 
       for i=1:1:$l(LogonStr,"#") 
       { 
           s LocStr=$p(LogonStr,"#",i)
           s orgCode=$p(LocStr,"^",1)
           continue:orgCode=""
           s postCode=$p(LocStr,"^",2)
           s LocId=$p(LocStr,"^",3)
               
           if OtherLocXML=""
           {
                s OtherLocXML="<orgRole><orgCode>"_orgCode_"</orgCode><postCode>"_postCode_"</postCode><orgPostId>"_LocId_"</orgPostId></orgRole>"   
           }
           else
           {
                 s OtherLocXML=OtherLocXML_"<orgRole><orgCode>"_orgCode_"</orgCode><postCode>"_postCode_"</postCode><orgPostId>"_LocId_"</orgPostId></orgRole>"  
           } 
       } 
   }  
   s Qresult="<user>" 
   s Qresult=Qresult_XML_OtherLocXML_"</orgRoleList></user>" 
   q Qresult
}

}
