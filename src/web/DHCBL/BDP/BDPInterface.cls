Class web.DHCBL.BDP.BDPInterface Extends %RegisteredObject [ ProcedureBlock ]
{

/// 描述：HR维护科室信息时，同步到HIS
/// 编写人：基础数据平台-李可凡
/// 编写日期：2020年2月7日
/// Input：CTLOCCode^CTLOCDesc^CTLOCType^CTLOCAddress^CTLOCDep^CTLOCHospital^CTLOCTelephone^CTLOCDateFrom^CTLOCDateTo
/// 科室代码，科室描述，科室类型，开始日期不能为空
/// w ##class(web.DHCBL.BDP.BDPInterface).SaveCTLoc("KESHI01^科室01^E^门诊楼一楼^门急诊科室^东华标准版数字化医院[总院]^0707007^2020-02-06^")
ClassMethod SaveCTLoc(datastr As %String) As %String
{
	s CTLOCCode=$p(datastr,"^",1)			//科室代码
	s CTLOCDesc=$p(datastr,"^",2)			//科室描述
	s CTLOCType=$p(datastr,"^",3)			//科室类型
	s CTLOCAddress=$p(datastr,"^",4)		//科室地址
	s CTLOCDep=$p(datastr,"^",5)			//科室部门组
	s CTLOCHospital=$p(datastr,"^",6)		//医院
	s CTLOCTelephone=$p(datastr,"^",7)		//科室电话
	s CTLOCDateFrom=$p(datastr,"^",8)		//开始日期
	s CTLOCDateTo=$p(datastr,"^",9)			//结束日期
	if ((CTLOCCode="")||(CTLOCDesc="")||(CTLOCType="")||(CTLOCDateFrom=""))
	{
		s re=..GetXMLResult("-1^科室代码/科室描述/科室类型/开始日期不能为空")
		q re 
	}
	if '((CTLOCType="W")||(CTLOCType="E")||(CTLOCType="DI")||(CTLOCType="D")||(CTLOCType="C")||(CTLOCType="O")||(CTLOCType="OP")||(CTLOCType="EM")||(CTLOCType="DS")||(CTLOCType="MR")||(CTLOCType="OR")||(CTLOCType="CL")||(CTLOCType="ADM"))
	{
		s re=..GetXMLResult("-1^科室类型只能是规定的值W,E,DI,D,C,O,OP,EM,DS,MR,OR,CL,ADM")
		q re 
	}
	if (CTLOCDateTo="")		//添加或修改科室
	{
		s eobj=##class(web.Entity.CT.CTLoc).%New()
		s eobj.CTLOCCode=CTLOCCode
		s eobj.CTLOCDesc=CTLOCDesc
		s eobj.CTLOCType=CTLOCType
		s eobj.CTLOCAddress=CTLOCAddress
		if (CTLOCDep'="")
		{
			s CTLOCDepDR=$o(^RBC("DEP",0,"Desc",$$ALPHAUP^SSUTIL4(CTLOCDep),0))
			q:CTLOCDepDR="" "-1^找不到科室部门组，请先在科室部门组界面维护数据"
			s eobj.CTLOCDepDR=CTLOCDepDR
		}
		if (CTLOCHospital'="")
		{
			s CTLOCHospitalDR=$o(^CT("HOSP",0,"Desc",$$ALPHAUP^SSUTIL4(CTLOCHospital),0))
			q:CTLOCHospitalDR="" "-1^找不到医院，请先在医院界面维护数据"
			s eobj.CTLOCHospitalDR=CTLOCHospitalDR
		}
		s eobj.CTLOCTelephone=CTLOCTelephone
		s eobj.CTLOCDateActiveFrom=CTLOCDateFrom
		
		s CTLOCRowID=$o(^CTLOC(0,"Code",$$ALPHAUP^SSUTIL4(eobj.CTLOCCode),0))
		if (CTLOCRowID="")		//添加科室
		{
			s obj=##class(User.CTLoc).%New()
		}
		else	//修改科室
		{
			s obj=##class(User.CTLoc).%OpenId(CTLOCRowID)
		    s bobj=##class(web.Entity.CT.CTLoc).%New()
		    s bobj.CTLOCRowID=CTLOCRowID
		    s bobj.CTLOCDesc=obj.CTLOCDesc
		    s bobj.CTLOCAddress=obj.CTLOCAddress.GetAt(1)
		    s bobj.CTLOCType=obj.CTLOCType 
		    s:obj.CTLOCDepDR'="" bobj.CTLOCDepDR=obj.CTLOCDepDR.%Id()
		    s:obj.CTLOCHospitalDR'="" bobj.CTLOCHospitalDR=obj.CTLOCHospitalDR.%Id()
		    s bobj.CTLOCDateActiveFrom=obj.CTLOCDateActiveFrom
		    s bobj.CTLOCContactName=obj.CTLOCContactName
		    s bobj.CTLOCTelephone=obj.CTLOCTelephone
		    if (bobj.CTLOCType="W")||(bobj.CTLOCType="EM")||(bobj.CTLOCType="OP")
		    {
		        if (eobj.CTLOCType'=bobj.CTLOCType)
		        {
		        	s str=##class(web.DHCBL.CT.CTLoc).UpdateCTLOCType(CTLOCRowID,eobj.CTLOCType)
		        	q:str'="" "-1^"_str
		        }
		    }
		    s blogJson=bobj.JsonS()
		}
		s obj.CTLOCCode=eobj.CTLOCCode
		s obj.CTLOCDesc=eobj.CTLOCDesc
		//s obj.CTLOCAddress=eobj.CTLOCAddress
		s AddressList=##class(%ListOfDataTypes).%New()
		d AddressList.Insert(eobj.CTLOCAddress)
		s obj.CTLOCAddress=AddressList		//修改地址
		s obj.CTLOCType=eobj.CTLOCType
		d obj.CTLOCDepDRSetObjectId(eobj.CTLOCDepDR)
		d obj.CTLOCHospitalDRSetObjectId(eobj.CTLOCHospitalDR)
		s obj.CTLOCDateActiveFrom=$zdh(eobj.CTLOCDateActiveFrom,3)
		s obj.CTLOCContactName=##class(web.DHCBL.BDP.FunLib).GetPYCODE(eobj.CTLOCDesc)		//拼音检索码
		s obj.CTLOCTelephone=eobj.CTLOCTelephone
		if (eobj.CTLOCType="W")
		{
		    s obj.CTLOCWardFlag="Y"
		}
		else
		{
		    s obj.CTLOCWardFlag="N"
		}
		Ts
		s sc=obj.%Save()
		d obj.%Close()
		If $$$ISOK(sc)
		{
			Tc
			s id=obj.%Id()
			s logJson=eobj.JsonS()
			d:CTLOCRowID="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLogForOther("CT_Loc","User.CTLoc","科室/病区",id,eobj.CTLOCDesc,"A",logJson,"","1")
			d:CTLOCRowID'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLogForOther("CT_Loc","User.CTLoc","科室/病区",id,eobj.CTLOCDesc,"U",logJson,blogJson,"1")
			//如果科室类型为ward,添加表PAC_Ward记录
			if (eobj.CTLOCType="W")||(eobj.CTLOCType="EM")||(eobj.CTLOCType="OP")
            {
                s:eobj.WARDSingleRoom="" eobj.WARDSingleRoom="N"
                s:eobj.WARDActive="" eobj.WARDActive="N"
                s:eobj.WARDViewLinkedRooms="" eobj.WARDViewLinkedRooms="N"
                s:eobj.WARDViewNextMostUrgent="" eobj.WARDViewNextMostUrgent="N"
                s:eobj.WARDBeforehand="" eobj.WARDBeforehand="N"
                s WARDRowID=$o(^PAWARD(0,"WARD_LocationDR",id,0))
                if (WARDRowID'="")
                {
                    s wobj = ##class(User.PACWard).%OpenId(WARDRowID)
                    s wobj.WARDSingleRoom = eobj.WARDSingleRoom
                    s wobj.WARDActive = eobj.WARDActive
                    s wobj.WARDViewLinkedRooms = eobj.WARDViewLinkedRooms
                    s wobj.WARDViewNextMostUrgent = eobj.WARDViewNextMostUrgent
                    s wobj.WARDInactiveDateFrom = eobj.CTLOCDateActiveFrom
                    s wobj.WARDBeforehand = eobj.WARDBeforehand
                    d wobj.%Save()
                    d wobj.%Close()
                }
            }
            
			q "0^保存成功！"
		}
		else
		{
			Trollback
			q "-1^保存失败！"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
		}
	}
	else	//停用科室
	{
		s CTLOCRowID=$o(^CTLOC(0,"Code",$$ALPHAUP^SSUTIL4(CTLOCCode),0))
		q:CTLOCRowID="" "-1^找不到该科室"
		s eobj=##class(web.Entity.CT.CTLoc).%New()
		s eobj.CTLOCDesc=CTLOCDesc
		s eobj.CTLOCDateActiveTo=CTLOCDateTo
		s obj=##class(User.CTLoc).%OpenId(CTLOCRowID)
		s bobj=##class(web.Entity.CT.CTLoc).%New()
	    s bobj.CTLOCDesc=obj.CTLOCDesc
	    s bobj.CTLOCDateActiveTo=obj.CTLOCDateActiveTo
		s obj.CTLOCDateActiveTo=$zdh(eobj.CTLOCDateActiveTo,3)
		Ts
		s sc=obj.%Save()
		d obj.%Close()
		If $$$ISOK(sc)
		{
			Tc
			s id=obj.%Id()
			s logJson=eobj.JsonS()
			s blogJson=bobj.JsonS()
			d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLogForOther("CT_Loc","User.CTLoc","科室/病区",id,eobj.CTLOCDesc,"U",logJson,blogJson,"1")
			q "0^停用成功！"
		}
		else
		{
			Trollback
			q "-1^停用失败！"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
		}
	}
}

/// 项目：重庆中医学生轮转科室同步
/// 描述：规培生维护轮转科室时，同步科室信息到HIS；若HIS没有该用户，则新增用户
/// 编写人：基础数据平台-李可凡
/// 编写日期：2020年1月4日
/// Input：工号^姓名^医护人员类型^资格证书编号^密码^科室代码^科室描述^安全组^开始日期^结束如期
/// 工号，姓名，密码，科室代码，科室描述，安全组，开始日期不能为空；日期格式为xxxx-xx-xx
/// w ##class(web.DHCBL.BDP.BDPInterface).SyncSSUserAndLogonLoc("JKCSV4^接口测试V4^学生^00014455^1^ZYMZ001^呼吸内科门诊^其他^2020-01-11^2020-03-01")
ClassMethod SyncSSUserAndLogonLoc(datastr As %String) As %String
{
	s UserCode=$p(datastr,"^",1)		//工号
	s UserName=$p(datastr,"^",2)		//姓名
	s UserCarPrvTp=$p(datastr,"^",3)	//医护人员类型
	s UserUnit=$p(datastr,"^",4)		//资格证书号
	s UserPassword=$p(datastr,"^",5)	//密码
	s UserLocCode=$p(datastr,"^",6)		//科室代码
	s UserLocDesc=$p(datastr,"^",7)		//科室描述
	s UserGroup=$p(datastr,"^",8)		//安全组
	s DateFrom=$p(datastr,"^",9)		//开始日期
	s DateTo=$p(datastr,"^",10)		//结束日期
	if ((UserCode="")||(UserName="")||(UserPassword="")||(UserLocCode="")||(UserLocDesc="")||(UserGroup="")||(DateFrom="")) 
	{
		s re=..GetXMLResult("-1^工号/姓名/密码/科室代码/科室描述/安全组/开始日期不能为空！")
		q re
	}
	s SSUSRRowId=$o(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(UserCode),0))
	s res="0^"
	if (SSUSRRowId="")
	{
		s UserStr=UserCode_"^"_UserName_"^"_UserGroup_"^"_UserCarPrvTp_"^"_UserUnit_"^"_UserPassword_"^"_DateFrom_"^"
		s res=..AddSSUser(UserStr)
	}
	if ($p(res,"^",1)="-1") 		//用户保存失败返回错误信息
	{
		s re=..GetXMLResult(res)
		q re
	}
	s LocStr=UserCode_"^"_UserName_"^"_UserLocCode_"^"_UserLocDesc_"^"_UserGroup_"^"_DateFrom_"^"_DateTo
	s result=..AddLogonLoc(LocStr)
	if ($p(res,"^",2)'="") 
	{
		s re=..GetXMLResult(result_"^用户新增成功！")
		q re
	}
	s re=..GetXMLResult(result)
	q re
}

/// 项目：重庆中医学生轮转科室同步
/// 描述：规培生注册信息时，同步基本信息到HIS用户
/// 编写人：基础数据平台-李可凡
/// 编写日期：2020年1月2日
/// Input：工号^姓名^安全组^医护人员类型^资格证书号^密码^开始日期^结束日期
/// (工号，姓名，安全组，开始日期不能为空；日期格式为xxxx-xx-xx)
/// (医护人员类型不为空，则同时新增关联医护人员，否则仅新增用户；资格证书号仅存到关联医护人员里)
/// w ##class(web.DHCBL.BDP.BDPInterface).AddSSUser("JKCSV1^接口测试V1^其他^学生^12321^1^2019-11-27^")
ClassMethod AddSSUser(datastr As %String) As %String
{
	s UserCode=$p(datastr,"^",1)		//工号
	s UserName=$p(datastr,"^",2)		//姓名
	s UserGroup=$p(datastr,"^",3)		//安全组
	s UserCarPrvTp=$p(datastr,"^",4)	//医护人员类型
	s UserUnit=$p(datastr,"^",5)		//资格证书号
	s UserPassword=$p(datastr,"^",6)	//密码
	s UserDateFrom=$p(datastr,"^",7)	//开始日期
	s UserDateTo=$p(datastr,"^",8)		//结束日期
	s SSUSRHospitalDR=2					//默认当地医院
	s SSUSRCTLANDR=20					//默认Chinese
	
	if ((UserCode="")||(UserName="")||(UserGroup="")||(UserPassword="")||(UserDateFrom="")) 
	{
		s re=..GetXMLResult("-1^工号/姓名/安全组/密码/开始日期不能为空！")
		q re
	}
	s SSUSRRowId=$o(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(UserCode),0))
	if (SSUSRRowId'="") 
	{
		s re=..GetXMLResult("-1^工号已存在！")
		q re
	}
	s UserCarPrvTpDR=""
	s:UserCarPrvTp'="" UserCarPrvTpDR=$o(^CT("CPT",0,"Desc",$$ALPHAUP^SSUTIL4(UserCarPrvTp),0))
	if (UserCarPrvTpDR="") 
	{
		s re=..GetXMLResult("-1^医护人员类型不存在！")
		q re
	}
	s SSUSRGroupDR=0
	for
	{
		s SSUSRGroupDR=$o(^SSU("SSGRP",SSUSRGroupDR)) q:SSUSRGroupDR=""
		s SSUSRGroup=$p($g(^SSU("SSGRP",SSUSRGroupDR)),"^",1)
		q:SSUSRGroup=UserGroup
	}
	if (SSUSRGroupDR="") 
	{
		s re=..GetXMLResult("-1^安全组不存在！")
		q re
	}
	s CTPCPRowId=""
	if (UserCarPrvTp'="")	//医护人员类型不为空，保存医护人员
	{
		s CTPCPRowId=$o(^CTPCP(0,"Code",$$ALPHAUP^SSUTIL4(UserCode),0))
		if (CTPCPRowId="")
		{
			s ecobj=##class(web.Entity.CT.CTCareProv).%New()
			s ecobj.CTPCPCode=UserCode
			s ecobj.CTPCPDesc=UserName
			s ecobj.CTPCPCarPrvTpDR=UserCarPrvTpDR
			s ecobj.CTPCPUnit=UserUnit
			s ecobj.CTPCPOtherName=##class(web.DHCBL.BDP.FunLib).GetPYCODE(UserName)
			s ecobj.CTPCPActiveFlag="Y"
			s ecobj.CTPCPDateActiveFrom=$zdh(UserDateFrom,3)
			s:UserDateTo'="" ecobj.CTPCPDateActiveTo=$zdh(UserDateTo,3)
			s ecobj.CTPCPUpdateDate=$p($h,",",1)
			s ecobj.CTPCPUpdateTime=$p($h,",",2)
			s ecobj.CTPCPUpdateUserDR=1
			
			s cobj=##class(User.CTCareProv).%New()
			s cobj.CTPCPCode=ecobj.CTPCPCode									//工号
			s cobj.CTPCPDesc=ecobj.CTPCPDesc									//姓名
			s cobj.CTPCPOtherName=ecobj.CTPCPOtherName							//拼音检索码
			d cobj.CTPCPCarPrvTpDRSetObjectId(ecobj.CTPCPCarPrvTpDR)			//医护人员类型
			s cobj.CTPCPActiveFlag=ecobj.CTPCPActiveFlag						//激活标识
			s cobj.CTPCPDateActiveFrom=ecobj.CTPCPDateActiveFrom				//开始日期
			s cobj.CTPCPDateActiveTo=ecobj.CTPCPDateActiveTo					//结束日期
			s cobj.CTPCPUpdateDate=ecobj.CTPCPUpdateDate						//修改日期
			s cobj.CTPCPUpdateTime=ecobj.CTPCPUpdateTime						//修改时间
			d cobj.CTPCPUpdateUserDRSetObjectId(ecobj.CTPCPUpdateUserDR)		//修改人
			Ts
			s scc=cobj.%Save()
			s clogJson=ecobj.JsonS()
			if $$$ISOK(scc)
			{
				Tc
				s idc=cobj.%Id()
				d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLogForOther("CT_CareProv","User.CTCareProv","医护人员",idc,ecobj.CTPCPDesc,"A",clogJson,"","1")
				s CTPCPRowId=idc
			}
			else
			{
				Trollback
				s re="-1^医护人员新增失败！"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(scc)
				s re=..GetXMLResult(re)
				q re
			}
		}
	}
	//保存用户信息
	s eobj=##class(web.Entity.CT.SSUser).%New()
	s eobj.SSUSRInitials=UserCode
	s eobj.SSUSRName=UserName
	s eobj.SSUSRGroup=SSUSRGroupDR
	s eobj.SSUSRPassword=UserPassword
	s eobj.SSUSRHospitalDR=SSUSRHospitalDR
	s eobj.SSUSRCareProvDR=CTPCPRowId
	s eobj.SSUSRDateFrom=$zdh(UserDateFrom,3)
	s:UserDateTo'="" eobj.SSUSRDateTo=$zdh(UserDateTo,3)
	s eobj.SSUSRActive="Y"
	s eobj.SSUSRCTLANDR=SSUSRCTLANDR
	s eobj.SSUSRChangeLocation="Y"
	
	s obj=##class(User.SSUser).%New()
	s obj.SSUSRInitials=eobj.SSUSRInitials 									//人事Id
    s obj.SSUSRName=eobj.SSUSRName 											//姓名
    d obj.SSUSRGroupSetObjectId(eobj.SSUSRGroup) 							//安全组
    s obj.SSUSRPassword=##Class(web.SSUser).Encrypt(eobj.SSUSRPassword)		//登陆密码
    d obj.SSUSRHospitalDRSetObjectId(eobj.SSUSRHospitalDR) 					//医院关联
    d obj.SSUSRCTLANDRSetObjectId(eobj.SSUSRCTLANDR) 						//默认语言
    d:eobj.SSUSRCareProvDR'="" obj.SSUSRCareProvDRSetObjectId(eobj.SSUSRCareProvDR)		//关联医护人员
    s obj.SSUSRDateFrom=eobj.SSUSRDateFrom									//生效日期
    s obj.SSUSRDateTo=eobj.SSUSRDateTo										//截止日期
    s obj.SSUSRActive=eobj.SSUSRActive										//激活标识
    s obj.SSUSRChangeLocation=eobj.SSUSRChangeLocation						//允许用户更改登陆科室
    Ts
    s sc=obj.%Save()
    if $$$ISOK(sc)
	{
		Tc
		s id=obj.%Id()
		s logJson=eobj.JsonS()
		d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLogForOther("SS_User","User.SSUser","用户",id,eobj.SSUSRName,"A",logJson,"","1")
		s re=..GetXMLResult("0^新增成功！")
		q re
	}
	else
	{
		Trollback
		s re="-1^用户新增失败！"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
		s re=..GetXMLResult(re)
		q re
	}
}

/// 项目：重庆中医学生轮转科室同步
/// 描述：规培生出院时，同步结束日期到HIS
/// 编写人：基础数据平台-李可凡
/// 编写日期：2020年1月4日
/// Input：工号^姓名^结束日期，都不能为空，日期格式为xxxx-xx-xx)
/// w ##class(web.DHCBL.BDP.BDPInterface).EndSSUser("JKCSV1^接口测试V1^2020-01-22")
ClassMethod EndSSUser(datastr As %String) As %String
{
	s UserCode=$p(datastr,"^",1)		//工号
	s UserName=$p(datastr,"^",2)		//姓名
	s UserDateTo=$p(datastr,"^",3)		//结束日期
	if ((UserCode="")||(UserName="")||(UserDateTo=""))
	{
		s re=..GetXMLResult("-1^工号/姓名/结束日期不能为空！")
		q re
	}
	s SSUSRRowId=$o(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(UserCode),0))
	if (SSUSRRowId="") 
	{
		s re=..GetXMLResult("-1^该用户不存在！")
		q re
	}
	
	s eobj=##class(web.Entity.CT.SSUser).%New()
	s eobj.SSUSRRowId=SSUSRRowId
	s eobj.SSUSRInitials=UserCode
	s eobj.SSUSRName=UserName
	s eobj.SSUSRDateTo=$zdh(UserDateTo,3)
	
	s obj=##class(User.SSUser).%OpenId(eobj.SSUSRRowId)
	s bobj=##class(web.Entity.CT.SSUser).%New()
	s bobj.SSUSRDateTo=obj.SSUSRDateTo
    s obj.SSUSRDateTo=eobj.SSUSRDateTo			//截止日期
    Ts
    s sc=obj.%Save()
    if $$$ISOK(sc)
	{
		Tc
		s id=obj.%Id()
		s logJson=eobj.JsonS()
		s blogJson=bobj.JsonS()
		d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLogForOther("SS_User","User.SSUser","用户",id,eobj.SSUSRName,"U",logJson,blogJson,1)
		s re=..GetXMLResult("0^停用成功！")
		q re
	}
	else
	{
		Trollback
		s re="-1^停用失败！"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
		s re=..GetXMLResult(re)
		q re
	}
}

/// 项目：重庆中医学生轮转科室同步
/// 描述：规培生维护轮转科室时，同步科室信息到HIS
/// 编写人：基础数据平台-李可凡
/// 编写日期：2020年1月4日
/// Input：工号^姓名^科室代码^科室描述^安全组^科室轮转开始日期^科室轮转结束如期
/// 工号，姓名，科室代码，科室描述，安全组，开始日期不能为空；日期格式为xxxx-xx-xx
/// w ##class(web.DHCBL.BDP.BDPInterface).AddLogonLoc("JKCSV4^接口测试V4^ZYMZ001^呼吸内科门诊^其他^2020-01-16^2020-01-31")
ClassMethod AddLogonLoc(datastr As %String) As %String
{
	s UserCode=$p(datastr,"^",1)		//工号
	s UserName=$p(datastr,"^",2)		//姓名
	s UserLocCode=$p(datastr,"^",3)		//科室代码
	s UserLocDesc=$p(datastr,"^",4)		//科室描述
	s UserGroup=$p(datastr,"^",5)		//安全组
	s LocDateFrom=$p(datastr,"^",6)		//开始日期
	s LocDateTo=$p(datastr,"^",7)		//结束日期
	
	if ((UserCode="")||(UserName="")||(UserLocCode="")||(UserLocDesc="")||(UserGroup="")||(LocDateFrom="")) 
	{
		s re=..GetXMLResult("-1^工号/姓名/科室代码/科室描述/安全组/开始日期不能为空！")
		q re
	}
	s SSUSRRowId=$o(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(UserCode),0))
	if (SSUSRRowId="") 
	{
		s re=..GetXMLResult("-1^该用户不存在！")
		q re
	}
	S LocRowId=$o(^CTLOC(0,"Code",$$ALPHAUP^SSUTIL4(UserLocCode),0))
	if (LocRowId="") 
	{
		s re=..GetXMLResult("-1^科室不存在！")
		q re
	}
	s OTHLLHospitalDR=$p($g(^CTLOC(LocRowId)),"^",22)		//取科室对应的医院
	s SSUSRGroupDR=0
	for
	{
		s SSUSRGroupDR=$o(^SSU("SSGRP",SSUSRGroupDR)) q:SSUSRGroupDR=""
		s SSUSRGroup=$p($g(^SSU("SSGRP",SSUSRGroupDR)),"^",1)
		q:SSUSRGroup=UserGroup
	}
	if (SSUSRGroupDR="") 
	{
		s re=..GetXMLResult("-1^安全组不存在！")
		q re
	}
	
	//判断其他登录科室是否存在
	s OTHLLChildsub=0
	for
	{
		s OTHLLChildsub=$o(^SSU("SSUSR",SSUSRRowId,"OTHLL",OTHLLChildsub)) q:OTHLLChildsub=""
		s OTHLLCTLocDR=$p($g(^SSU("SSUSR",SSUSRRowId,"OTHLL",OTHLLChildsub)),"^",1)	 	//科室DR
		s OTHLLUserGroupDR=$p($g(^SSU("SSUSR",SSUSRRowId,"OTHLL",OTHLLChildsub)),"^",2) //安全组DR
		s OTHLLEndDate=$p($g(^SSU("SSUSR",SSUSRRowId,"OTHLL",OTHLLChildsub)),"^",5) //结束日期
		q:((OTHLLCTLocDR=LocRowId)&&(OTHLLUserGroupDR=SSUSRGroupDR)&&(OTHLLEndDate=""))
	}
	if (OTHLLChildsub'="") 
	{
		s re=..GetXMLResult("-1^该科室已存在！")
		q re
	}
	
	s eoobj=##class(web.Entity.CT.SSUserOtherLogonLoc).%New()
	s eoobj.OTHLLParRef=SSUSRRowId
	s eoobj.OTHLLCTLOCDR=LocRowId
	s eoobj.OTHLLUserGroupDR=SSUSRGroupDR
	s eoobj.OTHLLHospitalDR=OTHLLHospitalDR
	s eoobj.OTHLLStartDate=$zdh(LocDateFrom,3)
	s:LocDateTo'="" eoobj.OTHLLEndDate=$zdh(LocDateTo,3)
	//添加其他登录科室
	s oobj=##class(User.SSUserOtherLogonLoc).%New(eoobj.OTHLLParRef)
	d oobj.OTHLLParRefSetObjectId(eoobj.OTHLLParRef)				//父表RowId
	d oobj.OTHLLCTLOCDRSetObjectId(eoobj.OTHLLCTLOCDR) 				//科室DR
	d oobj.OTHLLUserGroupDRSetObjectId(eoobj.OTHLLUserGroupDR) 		//安全组DR
	d oobj.OTHLLHospitalDRSetObjectId(eoobj.OTHLLHospitalDR) 		//医院DR
	s oobj.OTHLLStartDate=eoobj.OTHLLStartDate						//开始日期
	s oobj.OTHLLEndDate=eoobj.OTHLLEndDate							//结束日期
	Ts
	s sc=oobj.%Save()  //保存数据
	If $$$ISOK(sc)
	{
		TC
		s id = oobj.%Id()
		s logJson=eoobj.JsonS()
		d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLogForOther("SS_UserOtherLogonLoc","User.SSUserOtherLogonLoc","用户其他登录科室",id,UserLocDesc,"A",logJson,"","1")
		//保存指定科室
		s res=""
		s CTPCPDR=$o(^CTPCP(0,"Code",$$ALPHAUP^SSUTIL4(UserCode),0))
		if (CTPCPDR'="")
		{
			s res=##class(web.DHCBL.CT.CTCareProv).UpdateRBData(CTPCPDR,LocRowId,"Add",eoobj.OTHLLStartDate,eoobj.OTHLLEndDate)
		}
		if (res["success:'false'") 
		{
			s re=..GetXMLResult("0^科室保存成功！^指定科室保存失败！")
			q re
		}
		s re=..GetXMLResult("0^科室保存成功！")
		q re
	}
	else
	{
		TROLLBACK
		s re="-1^科室保存失败！"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
		s re=..GetXMLResult(re)
		q re
	}
}

/// 项目：重庆中医学生轮转科室同步
/// 描述：修改调整规培生出科日期时调用，同步该科室结束日期到HIS
/// 编写人：基础数据平台-李可凡
/// 编写日期：2020年1月4日
/// Input：工号^姓名^科室代码^科室描述^安全组^科室轮转结束如期，都不能为空；日期格式为xxxx-xx-xx
/// w ##class(web.DHCBL.BDP.BDPInterface).EndLogonLoc("JKCSV1^接口测试V1^ZYMZ001^呼吸内科门诊^其他^2030-12-12")
ClassMethod EndLogonLoc(datastr As %String) As %String
{
	s UserCode=$p(datastr,"^",1)		//工号
	s UserName=$p(datastr,"^",2)		//姓名
	s UserLocCode=$p(datastr,"^",3)		//科室代码
	s UserLocDesc=$p(datastr,"^",4)		//科室描述
	s UserGroup=$p(datastr,"^",5)		//安全组
	s LocDateTo=$p(datastr,"^",6)		//结束日期
	if ((UserCode="")||(UserName="")||(UserLocCode="")||(UserLocDesc="")||(UserGroup="")||(LocDateTo="")) 
	{
		s re=..GetXMLResult("-1^工号/姓名/安全组/科室代码/科室描述/结束日期不能为空！")
		q re
	}
	s SSUSRRowId=$o(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(UserCode),0))
	if (SSUSRRowId="") 
	{
		s re=..GetXMLResult("-1^该用户不存在！")
		q re
	}
	S LocRowId=$o(^CTLOC(0,"Code",$$ALPHAUP^SSUTIL4(UserLocCode),0))
	if (LocRowId="") 
	{
		s re=..GetXMLResult("-1^科室不存在！")
		q re
	}
	s SSUSRGroupDR=0
	for
	{
		s SSUSRGroupDR=$o(^SSU("SSGRP",SSUSRGroupDR)) q:SSUSRGroupDR=""
		s SSUSRGroup=$p($g(^SSU("SSGRP",SSUSRGroupDR)),"^",1)
		q:SSUSRGroup=UserGroup
	}
	if (SSUSRGroupDR="") 
	{
		s re=..GetXMLResult("-1^安全组不存在！")
		q re
	}
	
	s OTHLLChildsub=""
	for
	{
		s OTHLLChildsub=$o(^SSU("SSUSR",SSUSRRowId,"OTHLL",OTHLLChildsub),-1) q:(OTHLLChildsub=0||OTHLLChildsub="")
		s OTHLLCTLocDR=$p($g(^SSU("SSUSR",SSUSRRowId,"OTHLL",OTHLLChildsub)),"^",1)	 	//科室DR
		s OTHLLUserGroupDR=$p($g(^SSU("SSUSR",SSUSRRowId,"OTHLL",OTHLLChildsub)),"^",2) //安全组DR
		q:((OTHLLCTLocDR=LocRowId)&&(OTHLLUserGroupDR=SSUSRGroupDR))
	}
	if (OTHLLChildsub="") 
	{
		s re=..GetXMLResult("-1^找不到该科室！")
		q re
	}
	s OTHLLRowId=SSUSRRowId_"||"_OTHLLChildsub
	
	s eobj=##class(web.Entity.CT.SSUserOtherLogonLoc).%New()
	s eobj.OTHLLParRef=SSUSRRowId
	s eobj.OTHLLEndDate=$zdh(LocDateTo,3)
	
	s obj=##class(User.SSUserOtherLogonLoc).%OpenId(OTHLLRowId)
	s bobj=##class(web.Entity.CT.SSUserOtherLogonLoc).%New()
	s bobj.OTHLLParRef=SSUSRRowId
	s bobj.OTHLLEndDate=obj.OTHLLEndDate
	s obj.OTHLLEndDate=eobj.OTHLLEndDate		//结束日期
	Ts
	s sc=obj.%Save()  //保存数据
	If $$$ISOK(sc)
	{
		TC
		s id=obj.%Id()
		s logJson=eobj.JsonS()
		s blogJson=bobj.JsonS()
		d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLogForOther("SS_UserOtherLogonLoc","User.SSUserOtherLogonLoc","用户其他登录科室",id,UserLocDesc,"U",logJson,blogJson,1)
		s re=..GetXMLResult("0^科室停用成功！")
		q re
	}
	else
	{
		TROLLBACK
		s re="-1^科室停用失败！"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
		s re=..GetXMLResult(re)
		q re
	}
}

/// 描述：将返回值处理为XML格式
/// w ##class(web.DHCBL.BDP.BDPInterface).GetXMLResult("0^成功")
ClassMethod GetXMLResult(resultstr As %String) As %String
{
	s ResultCode=$p(resultstr,"^",1)
	s ResultContent=$p(resultstr,"^",2)
	s ResultContent=ResultContent_$p(resultstr,"^",3)
	q "<Response><Body><ResultCode>"_ResultCode_"</ResultCode><ResultContent>"_ResultContent_"</ResultContent></Body><Response/>"
}

/// chenying 
/// 2020-01-29
/// 批量同步用户数据给PACS组
/// rowid为用户rowid,不为空时 同步这一条人员；为空时同步所有人员数据
/// w ##class(web.DHCBL.BDP.BDPInterface).PACSUpdateSSUser("1")
/// w ##class(web.DHCBL.BDP.BDPInterface).PACSUpdateSSUser("")   //同步所有数据
ClassMethod PACSUpdateSSUser(rowid As %String) As %String
{
	s ret=""
	if rowid=""
	{
		s SSUSRRowId=0
		for  
		{
			s SSUSRRowId=$o(^SSU("SSUSR",SSUSRRowId)) q:SSUSRRowId=""
			s UserCode=$p($g(^SSU("SSUSR",SSUSRRowId)),"^",1)
			s UserName=$p($g(^SSU("SSUSR",SSUSRRowId)),"^",2)
			s LocCode=$p($g(^SSU("SSUSR",SSUSRRowId)),"^",4)     //登录科室DR
			s:LocCode'="" LocCode=$p($g(^CTLOC(LocCode)),"^",1) //登录科室代码
			s IsDisable="N"
			s SSUSRActive=$p($g(^SSU("SSUSR",SSUSRRowId)),"^",19)    //ACTIVE
			if SSUSRActive="N" s IsDisable="Y"
			s SSUSRDateTo=$p($g(^SSU("SSUSR",SSUSRRowId)),"^",97)  //结束日期
			if (SSUSRDateTo'="")&&(SSUSRDateTo<+$h) s IsDisable="Y"
			s ret=##Class(RISService.InvokeRISService).SyncDoctorInfo(LocCode, UserCode, UserName, IsDisable)
			if $p(ret,"^",1)'=0 w LocCode_","_UserCode_","_UserName_","_IsDisable,!
		}
	}
	else
	{
		s SSUSRRowId=rowid
		s UserCode=$p($g(^SSU("SSUSR",SSUSRRowId)),"^",1)
		s UserName=$p($g(^SSU("SSUSR",SSUSRRowId)),"^",2)
		s LocCode=$p($g(^SSU("SSUSR",SSUSRRowId)),"^",4)     //登录科室DR
		s:LocCode'="" LocCode=$p($g(^CTLOC(LocCode)),"^",1) //登录科室代码
		s IsDisable="N"
		s SSUSRActive=$p($g(^SSU("SSUSR",SSUSRRowId)),"^",19)    //ACTIVE
		if SSUSRActive="N" s IsDisable="Y"
		s SSUSRDateTo=$p($g(^SSU("SSUSR",SSUSRRowId)),"^",97)  //结束日期
		if (SSUSRDateTo'="")&&(SSUSRDateTo<+$h) s IsDisable="Y"
		try
		{
       		s ret=##Class(RISService.InvokeRISService).SyncDoctorInfo(LocCode, UserCode, UserName, IsDisable)
		
		}
		catch myvar
		{
			
		}
	}
	q ret
}

/// chenying 
/// 2020-01-29
/// 批量同步科室数据给PACS组
/// rowid为科室rowid,不为空时 同步这一条科室；为空时同步所有科室数据
/// w ##class(web.DHCBL.BDP.BDPInterface).PACSUpdateCTLoc("1")
/// w ##class(web.DHCBL.BDP.BDPInterface).PACSUpdateCTLoc("")   //同步所有有效数据
ClassMethod PACSUpdateCTLoc(rowid As %String) As %String
{
	s ret=""
	if rowid=""
	{
		s CTLOCRowID=0
        for  
        {
            s CTLOCRowID=$o(^CTLOC(CTLOCRowID)) q:CTLOCRowID=""
            s LocCode=$p($g(^CTLOC(CTLOCRowID)),"^",1)
            s LocName=$p($g(^CTLOC(CTLOCRowID)),"^",2)
            s Loctype="A"
            s CTLOCDateActiveTo=$p($g(^CTLOC(CTLOCRowID)),"^",25)    //截止日期
            continue:(CTLOCDateActiveTo'="")&&(CTLOCDateActiveTo<+$h)
			s ret=##Class(RISService.InvokeRISService).SyncDepartment(LocCode, LocName, Loctype)
			if $p(ret,"^",1)'=0 w LocCode_","_LocName_","_Loctype,!
		}
	}
	else
	{
		s CTLOCRowID=rowid
		s LocCode=$p($g(^CTLOC(CTLOCRowID)),"^",1)
        s LocName=$p($g(^CTLOC(CTLOCRowID)),"^",2)
        s Loctype="A"
        s CTLOCDateActiveTo=$p($g(^CTLOC(CTLOCRowID)),"^",25)    //截止日期
        try
		{
       		s ret=##Class(RISService.InvokeRISService).SyncDepartment(LocCode, LocName, Loctype)
		}
		catch myvar
		{
			
		}
	}
	q ret
}

/// chenying 
/// 2020-01-29
/// 批量同步医嘱项数据给PACS组
/// rowid不为空时 同步这一条医嘱；为空时同步所有医嘱数据
/// w ##class(web.DHCBL.BDP.BDPInterface).PACSUpdateARCIM("1||1")
/// w ##class(web.DHCBL.BDP.BDPInterface).PACSUpdateARCIM("") //同步所有有效数据
ClassMethod PACSUpdateARCIM(rowid As %String) As %String
{
	s ret=""
	if rowid=""
	{
		s ARCIMSubscript=0
		for
		{
			s ARCIMSubscript=$o(^ARCIM(ARCIMSubscript)) q:ARCIMSubscript=""
			s ARCIMVersion=0
			for 
			{
				s ARCIMVersion=$o(^ARCIM(ARCIMSubscript,ARCIMVersion)) q:ARCIMVersion=""
				s ARCIMRowId=ARCIMSubscript_"||"_ARCIMVersion
				s ARCIMEffDateTo=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,7)),"^",1)      ; 结束日期 
				CONTINUE:((ARCIMEffDateTo'="")&(ARCIMEffDateTo<+$h))
				s ARCIMItemCatDR=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",10)
				if ARCIMItemCatDR'=""
				{
					s ARCICDesc=$p($g(^ARC("IC",ARCIMItemCatDR)),"^",2)
					continue:(ARCICDesc="检查")||(ARCICDesc="病理")||(ARCICDesc="科室检查")||(ARCICDesc="心电")  //?过滤，
					s ORCATDesc=""
					s ORCATRowId=$p($g(^ARC("IC",ARCIMItemCatDR)),"^",8)
					s:ORCATRowId'="" ORCATDesc = $p($g(^OEC("ORCAT",ORCATRowId)),"^",2)
					if (ORCATDesc="检查") ///?过滤， 限制检查类医嘱才去调PACS接口 
					{
						s ret=..SyncPacsInfo(ARCIMRowId)
						if $p(ret,"^",1)'=0 w ARCIMRowId_","_$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",1)_","_$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,7)),"^",2),!
					}
				}
			}
		}
	}
	else
	{
		s ARCIMRowId=rowid
		s ret=..SyncPacsInfo(ARCIMRowId)
	}
	q ret
}

/// Creator:陈莹  
/// CreatDate:2017-05-16
/// Description:调用PACS组同步检查医嘱接口
/// Input:ArcimRowid(医嘱项rowid)
/// Return: 0^成功  -1^失败信息  -2^失败信息  ……
/// Other:w ##class(web.DHCBL.BDP.BDPInterface).SyncPacsInfo("1||1")
ClassMethod SyncPacsInfo(ArcimRowid) As %String
{
	q:ArcimRowid="" ""
	s Rtn=""
	s ARCIMSubscript=$p(ArcimRowid,"||",1)
	s ARCIMVersion=$p(ArcimRowid,"||",2)
	s ARCIMCode=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",1)
	s ARCIMDesc=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",2)
	s ARCIMItemCatDR=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",10)
	if (ARCIMItemCatDR="") q ""
	s (TARIRowId,ORCATRowId,ORCATCode,ORCATDesc,ARCICCode,ARCICDesc,TARISubCateCode,TARISubCateDesc,TARICode,TARIDesc,TARIPrice,TARIUOMDesc,OLTQty)=""
	s ARCICCode=$p($g(^ARC("IC",ARCIMItemCatDR)),"^",1)
	s ARCICDesc=$p($g(^ARC("IC",ARCIMItemCatDR)),"^",2)
	s ARCIMServMaterial=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,7)),"^",6)        ; 服务/材料
	q:(ARCICDesc="检查")||(ARCICDesc="病理")||(ARCICDesc="科室检查")||(ARCICDesc="心电") ""  //?过滤，限制医嘱子类不调PACS接口
	
	s ORCATRowId=$p($g(^ARC("IC",ARCIMItemCatDR)),"^",8) 
	s:ORCATRowId'="" ORCATCode = $p($g(^OEC("ORCAT",ORCATRowId)),"^",1)
	s:ORCATRowId'="" ORCATDesc = $p($g(^OEC("ORCAT",ORCATRowId)),"^",2)
	if (ORCATDesc="检查")  ///?过滤，限制检查类医嘱才去调PACS接口 
	{
		s TARIRowId=$o(^DHCOLT(0,"ARTTA",ArcimRowid,0))
		IF TARIRowId'=""
		{
			s startdate=$o(^DHCOLT(0,"ARTTA",ArcimRowid,TARIRowId,0))
			s OLTRowId=$o(^DHCOLT(0,"ARTTA",ArcimRowid,TARIRowId,startdate,0)) 
			s TARISubCate=$p($g(^DHCTARI(TARIRowId)),"^",4) ///收费项目子类
			s:TARISubCate'="" TARISubCateCode=$p($g(^DHCTarC("SC",TARISubCate)),"^",1)
			s:TARISubCate'="" TARISubCateDesc=$p($g(^DHCTarC("SC",TARISubCate)),"^",2)
			s TARICode=$p($g(^DHCTARI(TARIRowId)),"^",1)
			s TARIDesc=$p($g(^DHCTARI(TARIRowId)),"^",2)
			if $d(%session) s HOSPtalID=$g(%session.Data("LOGON.HOSPID"))
			else  s HOSPtalID=2              ///?设置取哪个医院的价格
			s priceinfo=##class(web.UDHCJFPRICE).GetItmPrice(TARIRowId,+$h,"","","",HOSPtalID)
			s TARIPrice=$p(priceinfo,"^",1)
			s TARIPrice=$tr(TARIPrice,$c(10),"")
			s TARIPrice=$tr(TARIPrice,$c(13),"")
			s TARIPrice=$tr(TARIPrice,$c(0),"")	
			if $e(TARIPrice,1)="." s TARIPrice="0"_TARIPrice
			s TARIUOM=$p($g(^DHCTARI(TARIRowId)),"^",3)
			s:TARIUOM'="" TARIUOMDesc=$p($g(^CT("UOM",TARIUOM)),"^",2)
			s OLTQty=$p($g(^DHCOLT(OLTRowId)),"^",3)
		}	
		//##Class(RISService.InvokeRISService).SyncStudyItem(大类代码,大类描述,子类代码,子类描述,项目代码,项目描述,收费子类代码,收费子类描述,收费项代码,收费项描述,价格,收费项单位,医嘱对应收费项目的数量)
		try
		{
			s Rtn=##Class(RISService.InvokeRISService).SyncStudyItem(ORCATCode,ORCATDesc,ARCICCode,ARCICDesc,ARCIMCode,ARCIMDesc,TARISubCateCode,TARISubCateDesc,TARICode,TARIDesc,TARIPrice,TARIUOMDesc,OLTQty)
		}
		catch myvar
		{
			
		}
	}
	q Rtn
}

/// 安徽省立医嘱项收费项价格 及关联的同步 2020-05-15
/// w ##class(web.DHCBL.BDP.BDPInterface).SyncDataToOld("A","TarItem",311565)  //收费项目
/// w ##class(web.DHCBL.BDP.BDPInterface)GetXMLDataByRowId("U","ArcItem","1||1")  //医嘱项
/// w ##class(web.DHCBL.BDP.BDPInterface).SyncDataToOld("U",""TarItemPrice","1||1")  //收费项价格
/// w ##class(web.DHCBL.BDP.BDPInterface).SyncDataToOld("U","ArcOrderLinktar","1")  ///医嘱项与收费性对照
/// w ##class(web.DHCBL.BDP.BDPInterface).SyncDataToOld("U","ArcItemExternalCode","1||1||1")  /外部代码
ClassMethod SyncDataToOld(type As %String, tablename As %String, DataRowId) As %String
{
	
	s dataxmlstr=##class(web.DHCBL.BDP.BDPInterface).GetXMLDataByRowId(type, tablename, DataRowId)
	
	s ret= ##class(BDPInterface.Service.BDPInterface.ServiceSoap).%New().SaveRecord(dataxmlstr,tablename)
	q ret
}

/// 巩义项目  医嘱项收费项价格 及关联的同步 2020-05-21
/// w ##class(web.DHCBL.BDP.BDPInterface).GYTest()
ClassMethod GYTest()
{
	
	//收费项目测试
	s str=##class(web.DHCBL.BDP.BDPInterface).GetXMLDataByRowId("A","TarItem","1")
	s ret= ##class(SynServiceByBaseService.SynServiceByBasePort).%New().syncTari(str)
	w "收费项目"_ret,!
	b ;1
	s str=##class(web.DHCBL.BDP.BDPInterface).GetXMLDataByRowId("A","TarItem","2")
	s ret= ##class(SynServiceByBaseService.SynServiceByBasePort).%New().syncTari(str)
	w "收费项目"_ret,!
	
	b ;2
	s str=##class(web.DHCBL.BDP.BDPInterface).GetXMLDataByRowId("A","TarItem","3")
	s ret= ##class(SynServiceByBaseService.SynServiceByBasePort).%New().syncTari(str)
	w "收费项目"_ret,!
	
	b ;3
	///b ;00
	//b ;1
	//收费项价格测试
	s str=##class(web.DHCBL.BDP.BDPInterface).GetXMLDataByRowId("A","TarItemPrice","1||6")
	s ret= ##class(SynServiceByBaseService.SynServiceByBasePort).%New().syncTarItemPrices(str)
	w "收费项价格"_ret,!
	
	s str=##class(web.DHCBL.BDP.BDPInterface).GetXMLDataByRowId("A","TarItemPrice","2||1")
	s ret= ##class(SynServiceByBaseService.SynServiceByBasePort).%New().syncTarItemPrices(str)
	w "收费项价格"_ret,!
	
	s str=##class(web.DHCBL.BDP.BDPInterface).GetXMLDataByRowId("A","TarItemPrice","3||1")
	s ret= ##class(SynServiceByBaseService.SynServiceByBasePort).%New().syncTarItemPrices(str)
	w "收费项价格"_ret,!
	b ;000
	//医嘱项测试
	s str=##class(web.DHCBL.BDP.BDPInterface).GetXMLDataByRowId("A","ArcItem","2||1")
	//B ;1
	s ret= ##class(SynServiceByBaseService.SynServiceByBasePort).%New().syncArc(str)
	w ret,!
	
	b ;4
	///医嘱项与收费项对照 测试
	s str=##class(web.DHCBL.BDP.BDPInterface).GetXMLDataByRowId("A","ArcOrderLinktar","2")
	s ret= ##class(SynServiceByBaseService.SynServiceByBasePort).%New().syncArcOrderLinktar(str)
	w "医嘱项与收费项对照"_ret,!
	
	///医嘱项与收费项对照 测试
	s str=##class(web.DHCBL.BDP.BDPInterface).GetXMLDataByRowId("A","ArcOrderLinktar","4")
	s ret= ##class(SynServiceByBaseService.SynServiceByBasePort).%New().syncArcOrderLinktar(str)
	w "医嘱项与收费项对照"_ret,!
	
	//外部代码 测试
	s str=##class(web.DHCBL.BDP.BDPInterface).GetXMLDataByRowId("A","ArcItemExternalCode","2||1||1")
	s ret= ##class(SynServiceByBaseService.SynServiceByBasePort).%New().syncArcItemExternalCode(str)
	w "外部代码"_ret,!
	
	q "over"
}

/// w ##class(web.DHCBL.BDP.BDPInterface).SaveAllArcimTari()
ClassMethod SaveAllArcimTari() As %String
{
	
	k ^tmpcy
	s TARIRowId=0
	for
	{
		s TARIRowId=$o(^DHCTARI(TARIRowId)) q:TARIRowId=""
		s id = TARIRowId
		if $g(^DHCTARI(id))="" continue  ///过滤空数据
		
		s ret= ##class(web.DHCBL.BDP.BDPInterface).SyncDataToOld("A","TarItem",TARIRowId)
		if ret'["推送成功" s ^tmpcy("TarItem",TARIRowId)=ret
		else  w "TarItem"_","_TARIRowId,!
		
		s TPTARIParRef=TARIRowId
		s TPChildSub=0
		for
		{
			s TPChildSub=$o(^DHCTARI(TARIRowId,"P",TPChildSub))  q:(TPChildSub="")
			s TPRowId=TARIRowId_"||"_TPChildSub
			s ret= ##class(web.DHCBL.BDP.BDPInterface).SyncDataToOld("A","TarItemPrice",TPRowId)
			if ret'["推送成功" s ^tmpcy("TarItemPrice",TPRowId)=ret
			else  w "TarItemPrice"_","_TPRowId,!
			
		}
	}
	S ARCIMSubscript=0
	for
	{
		s ARCIMSubscript=$o(^ARCIM(ARCIMSubscript))  q:ARCIMSubscript=""
		s ARCIMVersion=0
		for 
		{
			s ARCIMVersion=$o(^ARCIM(ARCIMSubscript,ARCIMVersion))  q:ARCIMVersion=""
			s ARCIMRowId=ARCIMSubscript_"||"_ARCIMVersion
			///只同步检查检验，根据医嘱大类过滤。
			s arcimitemcatdr=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",10)
			s arcimorcatdr="",ordercatdesc=""
			if arcimitemcatdr'=""  s arcimorcatdr=$p($g(^ARC("IC",arcimitemcatdr)),"^",8)
			s:arcimorcatdr'="" ordercatdesc=$p($g(^OEC("ORCAT",arcimorcatdr)),"^",2) //医嘱大类描述
			continue:(ordercatdesc'="检查")&&(ordercatdesc'="检验")
			s ret= ##class(web.DHCBL.BDP.BDPInterface).SyncDataToOld("A","ArcItem",ARCIMRowId)
			if ret'["推送成功" s ^tmpcy("ArcItem",ARCIMRowId)=ret
			else  w "ArcItem"_","_ARCIMRowId,!
			s EXTSub=""
			for
			{
				s EXTSub=$o(^ARCIM(ARCIMSubscript,ARCIMVersion,"EXT",EXTSub)) q:EXTSub=""
				s EXTRowId=ARCIMSubscript_"||"_ARCIMVersion_"||"_EXTSub
				s ret= ##class(web.DHCBL.BDP.BDPInterface).SyncDataToOld("A","ArcItemExternalCode",EXTRowId)
				if ret'["推送成功" s ^tmpcy("ArcItemExternalCode",EXTRowId)=ret
				else  w "ArcItemExternalCode"_","_EXTRowId,!
			}
			
			
			s olttariffdr=0
			for
			{
				s olttariffdr=$o(^DHCOLT(0,"ARTTA",ARCIMRowId,olttariffdr)) q:olttariffdr=""   
				s startdate=0
				for
				{
					s startdate=$o(^DHCOLT(0,"ARTTA",ARCIMRowId,olttariffdr,startdate)) q:startdate=""
					s associaterowid=0
					for
					{
						s associaterowid=$o(^DHCOLT(0,"ARTTA",ARCIMRowId,olttariffdr,startdate,associaterowid)) q:associaterowid=""
						s ret= ##class(web.DHCBL.BDP.BDPInterface).SyncDataToOld("A","ArcOrderLinktar",associaterowid)
						if ret'["推送成功" s ^tmpcy("ArcOrderLinktar",associaterowid)=ret
						else  w "ArcOrderLinktar"_","_associaterowid,!
					}
				}
			}
		}
		
	}
}

/// Creator:陈莹  
/// CreatDate:2020-05-15
/// Description:生成XML信息
/// Input: type  A:添加，U修改 
/// Return:XML信息
/// w ##class(web.DHCBL.BDP.BDPInterface).GetXMLDataByRowId("A","ArcItem","26||1")
ClassMethod GetXMLDataByRowId(type As %String, tablename As %String, DataRowId As %String)
{
	s xmlstr="<Request><Header><type>"_type_"</type><client></client></Header><Body>"
	q:DataRowId="" ""
	q:tablename="" ""
	if (tablename = "TarItem")
	{
		s xmlstr=xmlstr_"<TarItems>"
		s xmlstr=xmlstr_"<TarItem>"
		s HospId=##class(web.DHCBL.BDP.BDPDataExport).GetHospital("DHC_TarItem",DataRowId,"")  //医院id
		if HospId'=""
		{
			s xmlstr=xmlstr_"<org_code>"_$p($g(^CT("HOSP",HospId)),"^",1)_"</org_code>"
			s xmlstr=xmlstr_"<org_name>"_$p($g(^CT("HOSP",HospId)),"^",2)_"</org_name>"
		}
		s xmlstr=xmlstr_"<tari_row_id>"_DataRowId_"</tari_row_id>"
		s xmlstr=xmlstr_"<tari_code>"_$p($g(^DHCTARI(DataRowId)),"^",1)_"</tari_code>"
		s xmlstr=xmlstr_"<tari_desc>"_$p($g(^DHCTARI(DataRowId)),"^",2)_"</tari_desc>"
		
		s tariuom=$p($g(^DHCTARI(DataRowId)),"^",3)
		s:tariuom'="" xmlstr=xmlstr_"<tari_uom>"_$p($g(^CT("UOM",tariuom)),"^",2)_"</tari_uom>"
		
		s tarisubcate =$p($g(^DHCTARI(DataRowId)),"^",4) ///收费项目子类
		s:tarisubcate'="" xmlstr=xmlstr_"<tari_sub_cate>"_$p($g(^DHCTarC("SC",tarisubcate)),"^",2)_"</tari_sub_cate>"
		
		s taribilldr=""
		s:tarisubcate'="" taribilldr=$p($g(^DHCTarC("SC",tarisubcate)),"^",3)
		if taribilldr'=""
		{
			s taribilldr =$p($g(^DHCTarC("CC",taribilldr)),"^",2)
			s xmlstr=xmlstr_"<tari_bill_dr>"_taribilldr_"</tari_bill_dr>"  //收费项目大类
		}
		
		s tariacctcate=$p($g(^DHCTARI(DataRowId)),"^",5)
		s:tariacctcate'="" xmlstr=xmlstr_"<tari_acct_cate>"_$p($g(^DHCTarC("AC",tariacctcate)),"^",2)_"</tari_acct_cate>"
		
		s tarioutpatcate=$p($g(^DHCTARI(DataRowId)),"^",15)
		s:tarioutpatcate'="" xmlstr=xmlstr_"<tari_outpat_cate>"_$p($g(^DHCTarC("OC",tarioutpatcate)),"^",2)_"</tari_outpat_cate>"
		
		s tariemccate=$p($g(^DHCTARI(DataRowId)),"^",16)
		s:tariemccate'="" xmlstr=xmlstr_"<tari_emc_cate>"_$p($g(^DHCTarC("EC",tariemccate)),"^",2)_"</tari_emc_cate>"
		
		s tarimrcate=$p($g(^DHCTARI(DataRowId)),"^",6)
		s:tarimrcate'="" xmlstr=xmlstr_"<tari_mr_cate>"_$p($g(^DHCTarC("MC",tarimrcate)),"^",2)_"</tari_mr_cate>"
		
		s tariinpatcate=$p($g(^DHCTARI(DataRowId)),"^",14)
		s:tariinpatcate'="" xmlstr=xmlstr_"<tari_inpat_cate>"_$p($g(^DHCTarC("IC",tariinpatcate)),"^",2)_"</tari_inpat_cate>"
		
		s tariitemcatdr=$p($g(^DHCTARI(DataRowId)),"^",31) 
		s:tariitemcatdr'="" xmlstr=xmlstr_"<tari_item_cat_dr>"_$listget($g(^User.BDPItemCategoryD(tariitemcatdr)),2)_"</tari_item_cat_dr>"  //代码
		
		s tarimcnew=$p($g(^DHCTARI(DataRowId)),"^",30)
		s:tarimcnew'="" xmlstr=xmlstr_"<tari_mc_new>"_$p($g(^DHCTarC("MCNew",tarimcnew)),"^",2)_"</tari_mc_new>"
		
		s tariopercategorydr=$p($g(^DHCTARI(DataRowId)),"^",37)
		s:tariopercategorydr'="" xmlstr=xmlstr_"<tari_opercategory_dr>"_$p($g(^ORC("CATEG",tariopercategorydr)),"^",2)_"</tari_opercategory_dr>"
		
		
		s xmlstr=xmlstr_"<tari_special_flag>"_$p($g(^DHCTARI(DataRowId)),"^",17)_"</tari_special_flag>"
		s xmlstr=xmlstr_"<tari_active_flag>"_$p($g(^DHCTARI(DataRowId)),"^",7)_"</tari_active_flag>"
		s TARIStartDate =$p($g(^DHCTARI(DataRowId)),"^",11) ///开始日期
		s TARIEndDate = $p($g(^DHCTARI(DataRowId)),"^",12)
		
		s:TARIStartDate'="" TARIStartDate=$zd(TARIStartDate,3)
		s:TARIEndDate'="" TARIEndDate=$zd(TARIEndDate,3)
		
		s xmlstr=xmlstr_"<tari_start_date>"_TARIStartDate_"</tari_start_date>"
		s xmlstr=xmlstr_"<tari_end_date>"_TARIEndDate_"</tari_end_date>"
		s xmlstr=xmlstr_"<tari_external_code>"_$p($g(^DHCTARI(DataRowId)),"^",13)_"</tari_external_code>"
		s xmlstr=xmlstr_"<tari_insu_name>"_$p($g(^DHCTARI(DataRowId)),"^",18)_"</tari_insu_name>"
		s xmlstr=xmlstr_"<tari_eng_name>"_$p($g(^DHCTARI(DataRowId)),"^",19)_"</tari_eng_name>"
		s xmlstr=xmlstr_"<tari_charge_basis>"_$p($g(^DHCTARI(DataRowId)),"^",20)_"</tari_charge_basis>"	
		s xmlstr=xmlstr_"<tari_connote>"_$p($g(^DHCTARI(DataRowId)),"^",32)_"</tari_connote>"	
		s xmlstr=xmlstr_"<tari_remark>"_$p($g(^DHCTARI(DataRowId)),"^",33)_"</tari_remark>"
		s xmlstr=xmlstr_"<tari_exclude>"_$p($g(^DHCTARI(DataRowId)),"^",34)_"</tari_exclude>"
		s xmlstr=xmlstr_"<tari_insucode>"_$p($g(^DHCTARI(DataRowId)),"^",59)_"</tari_insucode>"
		s xmlstr=xmlstr_"<tari_manufacturerdr>"_$p($g(^DHCTARI(DataRowId)),"^",84)_"</tari_manufacturerdr>"
		s xmlstr=xmlstr_"</TarItem>"
		s xmlstr=xmlstr_"</TarItems>"
	}
	if (tablename = "TarItemPrice")
	{
		s xmlstr=xmlstr_"<TarItemPrices>"
		s xmlstr=xmlstr_"<TarItemPrice>"
		s TARIRowId=$p(DataRowId,"||",1)
		s TPChildSub=$p(DataRowId,"||",2)
		s xmlstr=xmlstr_"<tari_row_id>"_TARIRowId_"</tari_row_id>"
		
		s TPHospitalDR=$p($g(^DHCTARI(TARIRowId,"P",TPChildSub)),"^",16)
		if TPHospitalDR'="" s xmlstr=xmlstr_"<org_code>"_$p($g(^CT("HOSP",TPHospitalDR)),"^",1)_"</org_code>"
		if TPHospitalDR'="" s xmlstr=xmlstr_"<org_name>"_$p($g(^CT("HOSP",TPHospitalDR)),"^",2)_"</org_name>"
		s xmlstr=xmlstr_"<tari_code>"_$P($G(^DHCTARI(TARIRowId)),"^",1)_"</tari_code>"
		s xmlstr=xmlstr_"<tari_desc>"_$P($G(^DHCTARI(TARIRowId)),"^",2)_"</tari_desc>"
		s xmlstr=xmlstr_"<tp_price>"_$p($g(^DHCTARI(TARIRowId,"P",TPChildSub)),"^",5)_"</tp_price>"
		
		s TPUpdateUser=$p($g(^DHCTARI(TARIRowId,"P",TPChildSub)),"^",8)
		s:TPUpdateUser'="" TPUpdateUser=$p($g(^SSU("SSUSR",TPUpdateUser)),"^",1)
		s xmlstr=xmlstr_"<tp_updateuser>"_TPUpdateUser_"</tp_updateuser>"  //用户工号
		
		s tppatInstype=$p($g(^DHCTARI(TARIRowId,"P",TPChildSub)),"^",13)
		s:tppatInstype'="" xmlstr=xmlstr_"<tp_patins_type>"_$p($g(^PAC("ADMREA",tppatInstype)),"^",2)_"</tp_patins_type>"   //患者费别描述
		
		s xmlstr=xmlstr_"<tp_alter_price1>"_$p($g(^DHCTARI(TARIRowId,"P",TPChildSub)),"^",14)_"</tp_alter_price1>"
		s xmlstr=xmlstr_"<tp_alter_price2>"_$p($g(^DHCTARI(TARIRowId,"P",TPChildSub)),"^",15)_"</tp_alter_price2>"
		
		s TPStartDate=$p($g(^DHCTARI(TARIRowId,"P",TPChildSub)),"^",3)
		s TPEndDate=$p($g(^DHCTARI(TARIRowId,"P",TPChildSub)),"^",4)
		s:TPStartDate'="" TPStartDate=$zd(TPStartDate,3)
		s:TPEndDate'="" TPEndDate=$zd(TPEndDate,3)
		
		s xmlstr=xmlstr_"<tp_start_date>"_TPStartDate_"</tp_start_date>"
		s xmlstr=xmlstr_"<tp_end_date>"_TPEndDate_"</tp_end_date>"
		s xmlstr=xmlstr_"</TarItemPrice>"
		s xmlstr=xmlstr_"</TarItemPrices>"
		
		
	}
	if (tablename = "ArcItem")
	{
		s ARCIMSubscript=$p(DataRowId,"||",1)
		s ARCIMVersion=$p(DataRowId,"||",2)
		s xmlstr=xmlstr_"<ArcItems>"
		s xmlstr=xmlstr_"<ArcItem>"
		s HospId=##class(web.DHCBL.BDP.BDPDataExport).GetHospital("ARC_ItmMast",DataRowId,"")  //医院id
		if HospId'=""
		{
			s xmlstr=xmlstr_"<org_code>"_$p($g(^CT("HOSP",HospId)),"^",1)_"</org_code>"
			s xmlstr=xmlstr_"<org_name>"_$p($g(^CT("HOSP",HospId)),"^",2)_"</org_name>"
		}
		s arcimitemcatdr=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",10)
		s:arcimitemcatdr'="" xmlstr=xmlstr_"<arcim_itemcat_dr>"_$p($g(^ARC("IC",arcimitemcatdr)),"^",2)_"</arcim_itemcat_dr>"  //医嘱子类描述
		s:arcimitemcatdr="" xmlstr=xmlstr_"<arcim_itemcat_dr>"_"</arcim_itemcat_dr>"  //医嘱子类描述
		s arcimorcatdr=""
		if arcimitemcatdr'=""  s arcimorcatdr=$p($g(^ARC("IC",arcimitemcatdr)),"^",8)
		s:arcimorcatdr'="" xmlstr=xmlstr_"<arcim_orcat_dr>"_$p($g(^OEC("ORCAT",arcimorcatdr)),"^",2)_"</arcim_orcat_dr>"  //医嘱大类描述
		s:arcimorcatdr="" xmlstr=xmlstr_"<arcim_orcat_dr>"_"</arcim_orcat_dr>"  //医嘱大类描述
		s xmlstr=xmlstr_"<arcim_row_id>"_DataRowId_"</arcim_row_id>"
		s xmlstr=xmlstr_"<arcim_code>"_$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",1)_"</arcim_code>"
		s xmlstr=xmlstr_"<arcim_desc>"_$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",2)_"</arcim_desc>"
		
		s arcimbilldr=$P($p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",9),"||",1)
		s:arcimbilldr'="" xmlstr=xmlstr_"<arcim_bill_dr>"_$p($g(^ARCBG(arcimbilldr)),"^",2)_"</arcim_bill_dr>"
		s:arcimbilldr="" xmlstr=xmlstr_"<arcim_bill_dr>"_"</arcim_bill_dr>"
		
		s arcimbillsubdr=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",9)
		s xmlstr=xmlstr_"<arcim_bill_sub_dr>"_$P($g(^ARCBG($p(arcimbillsubdr,"||",1),"SG",$p(arcimbillsubdr,"||",2))),"^",2)_"</arcim_bill_sub_dr>"
		
		s arcimbilluomdr=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,8)),"^",14)
		s:arcimbilluomdr'="" xmlstr=xmlstr_"<arcim_bill_uomdr>"_$p($g(^CT("UOM",arcimbilluomdr)),"^",2)_"</arcim_bill_uomdr>"  //账单单位
		s:arcimbilluomdr="" xmlstr=xmlstr_"<arcim_bill_uomdr>"_"</arcim_bill_uomdr>"  //账单单位
		
		s xmlstr=xmlstr_"<arcim_order_onits_own>"_$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,7)),"^",13)_"</arcim_order_onits_own>"
		s xmlstr=xmlstr_"<arcim_allow_order_wostock_check>"_$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,8)),"^",11)_"</arcim_allow_order_wostock_check>"
		s xmlstr=xmlstr_"<arcim_sensitive>"_$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,9)),"^",18)_"</arcim_sensitive>"
		s xmlstr=xmlstr_"<arcim_oe_message>"_$g(^ARCIM(ARCIMSubscript,ARCIMVersion,"OEM",1))_"</arcim_oe_message>"
		
		s arcimservicegroupdr=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,8)),"^",7)
		s:arcimservicegroupdr'="" xmlstr=xmlstr_"<arcim_service_group_dr>"_$p($g(^RBC("SG",arcimservicegroupdr)),"^",2)_"</arcim_service_group_dr>"
		s:arcimservicegroupdr="" xmlstr=xmlstr_"<arcim_service_group_dr>"_"</arcim_service_group_dr>"

		s xmlstr=xmlstr_"<arcim_serv_material>"_$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,7)),"^",6)_"</arcim_serv_material>"
		
		s arcimderfeerulesdr=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,8)),"^",19)
		s:arcimderfeerulesdr'="" xmlstr=xmlstr_"<arcim_der_fee_rules_dr>"_$p($g(^ARC("DFR",arcimderfeerulesdr)),"^",2)_"</arcim_der_fee_rules_dr>"
		
		s xmlstr=xmlstr_"<arcim_chg_order_per_hour>"_$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,9)),"^",25)_"</arcim_chg_order_per_hour>"
		s xmlstr=xmlstr_"<arcim_deceased_patients_only>"_$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,9)),"^",29)_"</arcim_deceased_patients_only>"
		s xmlstr=xmlstr_"<arcim_display_cumulative>"_$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,9)),"^",23)_"</arcim_display_cumulative>"
		s xmlstr=xmlstr_"<arcim_use_odbc_forword>"_$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,9)),"^",6)_"</arcim_use_odbc_forword>"
		s xmlstr=xmlstr_"<arcim_restrict_em>"_$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,10)),"^",12)_"</arcim_restrict_em>"
		s xmlstr=xmlstr_"<arcim_restrict_ip>"_$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,10)),"^",13)_"</arcim_restrict_ip>"
		s xmlstr=xmlstr_"<arcim_restrict_op>"_$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,10)),"^",14)_"</arcim_restrict_op>"
		s xmlstr=xmlstr_"<arcim_restrict_hp>"_$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,10)),"^",15)_"</arcim_restrict_hp>"
		s xmlstr=xmlstr_"<arcim_sensitive_order>"_$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,9)),"^",22) _"</arcim_sensitive_order>"
		s xmlstr=xmlstr_"<arcim_def_sensitive>"_$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,9)),"^",41)_"</arcim_def_sensitive>"
		s xmlstr=xmlstr_"<arcim_abbrev>"_$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",3)_"</arcim_abbrev>"

		//是否扫码计费
		s xmlstr=xmlstr_"<arcim_scancodebilling>"_$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,10)),"^",22)_"</arcim_scancodebilling>"
		
		s xmlstr=xmlstr_"<arcim_servmaterial>"_$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,7)),"^",6)_"</arcim_servmaterial>"  ; 服务/材料
		s xmlstr=xmlstr_"<arcim_text1>"_$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,9)),"^",32)_"</arcim_text1>"
		s xmlstr=xmlstr_"<arcim_text2>"_$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,9)),"^",33)_"</arcim_text2>"
		s xmlstr=xmlstr_"<arcim_text3>"_$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,9)),"^",34)_"</arcim_text3>"
		s xmlstr=xmlstr_"<arcim_text4>"_$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,9)),"^",35)_"</arcim_text4>"
		s xmlstr=xmlstr_"<arcim_text5>"_$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,9)),"^",36)_"</arcim_text5>"
		
		s ARCIMEffDate=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",13)       ; 开始日期
		s:ARCIMEffDate'="" ARCIMEffDate=$p(ARCIMEffDate,"Z",1)
		s:ARCIMEffDate'="" ARCIMEffDate=$p(ARCIMEffDate,",",1)
		s ARCIMEffDateTo=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,7)),"^",1)      ; 结束日期 
		s:ARCIMEffDate'="" ARCIMEffDate =$zd(ARCIMEffDate,3)
		s:ARCIMEffDateTo'="" ARCIMEffDateTo=$zd(ARCIMEffDateTo,3)
		
		s xmlstr=xmlstr_"<arcim_start_date>"_ARCIMEffDate_"</arcim_start_date>"
		s xmlstr=xmlstr_"<arcim_end_date>"_ARCIMEffDateTo_"</arcim_end_date>"
		
		s xmlstr=xmlstr_"</ArcItem>"
		s xmlstr=xmlstr_"</ArcItems>"
		
	}
	if (tablename = "ArcOrderLinktar")  //医嘱项与收费项对照
	{
		s xmlstr=xmlstr_"<ArcOrderLinktars>"
		s xmlstr=xmlstr_"<ArcOrderLinktar>"
		s xmlstr=xmlstr_"<olt_qty>"_$p($g(^DHCOLT(DataRowId)),"^",3)_"</olt_qty>"
		s xmlstr=xmlstr_"<olt_basc_price_flag>"_$p($g(^DHCOLT(DataRowId)),"^",8)_"</olt_basc_price_flag>"
		s xmlstr=xmlstr_"<olt_bill_once_flag>"_$p($g(^DHCOLT(DataRowId)),"^",9)_"</olt_bill_once_flag>"
		s xmlstr=xmlstr_"<tari_row_id>"_$p($g(^DHCOLT(DataRowId)),"^",2)_"</tari_row_id>"	
		s tarirowid=$p($g(^DHCOLT(DataRowId)),"^",2)
		s xmlstr=xmlstr_"<tari_code>"_$P($G(^DHCTARI(tarirowid)),"^",1)_"</tari_code>"
		s xmlstr=xmlstr_"<arcim_row_id>"_$p($g(^DHCOLT(DataRowId)),"^",1)_"</arcim_row_id>"
		s arcimrowid=$p($g(^DHCOLT(DataRowId)),"^",1)
		s HospId=##class(web.DHCBL.BDP.BDPDataExport).GetHospital("ARC_ItmMast",arcimrowid,"")  //医院id
		if HospId'=""
		{
			s xmlstr=xmlstr_"<org_code>"_$p($g(^CT("HOSP",HospId)),"^",1)_"</org_code>"
			s xmlstr=xmlstr_"<org_name>"_$p($g(^CT("HOSP",HospId)),"^",2)_"</org_name>"
		}
		s arcimrowid=$p($g(^DHCOLT(DataRowId)),"^",1)
		s xmlstr=xmlstr_"<arcim_code>"_$p($g(^ARCIM($p(arcimrowid,"||",1),$p(arcimrowid,"||",2),1)),"^",1)_"</arcim_code>"
		s OLTStartDate=$p($g(^DHCOLT(DataRowId)),"^",4)
		s:OLTStartDate'="" OLTStartDate=$zd(OLTStartDate,3)
		s tarEndDate=$p($g(^DHCOLT(DataRowId)),"^",5)
		s:tarEndDate'="" tarEndDate=$zd(tarEndDate,3)
		s xmlstr=xmlstr_"<olt_start_date>"_OLTStartDate_"</olt_start_date>"
		s xmlstr=xmlstr_"<olt_end_date>"_tarEndDate_"</olt_end_date>"
		s xmlstr=xmlstr_"</ArcOrderLinktar>"	
		
		s xmlstr=xmlstr_"</ArcOrderLinktars>"
		
	}
	
	if (tablename = "ArcItemExternalCode")  //外部代码
	{
		s xmlstr=xmlstr_"<ArcItemExternalCodes>"
		s ARCIMSubscript=$p(DataRowId,"||",1)
		s ARCIMVersion=$p(DataRowId,"||",2)
		s EXTRowId=$p(DataRowId,"||",3)
		s xmlstr=xmlstr_"<ArcItemExternalCode>"
		s xmlstr=xmlstr_"<arcim_row_id>"_ARCIMSubscript_"||"_ARCIMVersion_"</arcim_row_id>"
		s HospId=##class(web.DHCBL.BDP.BDPDataExport).GetHospital("ARC_ItmMast",ARCIMSubscript_"||"_ARCIMVersion,"")  //医院id
		if HospId'=""
		{
			s xmlstr=xmlstr_"<org_code>"_$p($g(^CT("HOSP",HospId)),"^",1)_"</org_code>"
			s xmlstr=xmlstr_"<org_name>"_$p($g(^CT("HOSP",HospId)),"^",2)_"</org_name>"
		}
		s xmlstr=xmlstr_"<arcim_code>"_$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",1)_"</arcim_code>"
		s xmlstr=xmlstr_"<ext_code>"_$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,"EXT",EXTRowId)),"^",4)_"</ext_code>"
		s xmlstr=xmlstr_"<ext_desc>"_$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,"EXT",EXTRowId)),"^",6)_"</ext_desc>"
		
		s extctlocdr=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,"EXT",EXTRowId)),"^",8)
		s:extctlocdr'="" xmlstr=xmlstr_"<ext_ctlocdr>"_$p($g(^CTLOC(extctlocdr)),"^",2)_"</ext_ctlocdr>"
		
		s xmlstr=xmlstr_"<ext_default_receive>"_$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,"EXT",EXTRowId)),"^",10)_"</ext_default_receive>"
		s xmlstr=xmlstr_"<ext_default_send>"_$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,"EXT",EXTRowId)),"^",9)_"</ext_default_send>"
		s EXTDateFrom=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,"EXT",EXTRowId)),"^",1)
		s EXTDateTo=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,"EXT",EXTRowId)),"^",2)
		s:EXTDateFrom'="" EXTDateFrom=$zd(EXTDateFrom,3)
		s:EXTDateTo'="" EXTDateTo=$zd(EXTDateTo,3)
		
		s xmlstr=xmlstr_"<ext_start_date>"_EXTDateFrom_"</ext_start_date>"
		s xmlstr=xmlstr_"<ext_end_date>"_EXTDateTo_"</ext_end_date>"
		s xmlstr=xmlstr_"</ArcItemExternalCode>"	
		s xmlstr=xmlstr_"</ArcItemExternalCodes>"
	}	
	s xmlstr=xmlstr_"</Body></Request>"
	q xmlstr
}

/// Creator：陈莹
/// CreatDate: 2020-05-14
/// Description：医嘱项外部代码信息保存
/// Input：数据InputStream
/// Return：
/// w ##class(web.DHCBL.BDP.BDPInterface).SaveArcItemExternalCode(stream)
ClassMethod SaveArcItemExternalCode(InputStream As %Stream.GlobalCharacter) As %String
{
	s tSC=##class(%XML.XPATH.Document).CreateFromStream(InputStream,.tDocument)
	s Tags="ArcItemExternalCodes",Tag="ArcItemExternalCode"   //医嘱项外部代码信息保存
	s returncode=0,ResultsRtn="",info=""
	s total= ..GetDataCount(InputStream,"/Request/Body/"_Tags,Tag)  //获取标签的个数
	if (total=0)||(total="")
	{
		s returncode=-1
		s info="数量为空"
		if ResultsRtn="" s ResultsRtn=info
		else  s ResultsRtn=ResultsRtn_info
	}
	else
	{
		s type=..GetFieldValue(InputStream,"/Request/Header/type")
		for counti=1:1:total	
		{
			k dataeobj
			s result=""
			s dataeobj=##class(web.Entity.CT.ARCItemExternalCodes).%New()
			//医院RowId
			s LinkHospId=..GetFieldValue(InputStream,"/Request/Body/"_Tags_"/"_Tag_"["_counti_"]/"_"org_code")  //医院代码	
			s:LinkHospId'="" LinkHospId=$o(^CT("HOSP",0,"Code",$$ALPHAUP^SSUTIL4(LinkHospId),0))
			///取对应的默认医院
			s LinkHospId= ##class(web.DHCBL.BDP.BDPMappingHOSP).GetDefHospIdByTableName("ARC_ItmMast",LinkHospId,+$h)
			
		    if (LinkHospId="")||(LinkHospId'>0)
			{
				s returncode=-1
				s info="医院ID为空"
				g errorret
			}
			//s dataeobj.EXTParRef=..GetFieldValue(InputStream,"/Request/Body/"_Tags_"/"_Tag_"["_counti_"]/"_"arcim_row_id") //医嘱项id
			s arcimcode=..GetFieldValue(InputStream,"/Request/Body/"_Tags_"/"_Tag_"["_counti_"]/"_"arcim_code") //医嘱项code
			if arcimcode=""
			{
				s returncode=-1
				s info="医嘱项代码为空"
				g errorret
			}
			s dataeobj.EXTParRef=##class(web.DHCBL.BDP.BDPDataImport).GetRowIdByCode("ARC_ItmMast",arcimcode,LinkHospId)
			if dataeobj.EXTParRef=""
			{
				s returncode=-1
				s info="医嘱项代码"_arcimcode_"找不到对应的id"
				g errorret
			}
			s dataeobj.EXTCode=..GetFieldValue(InputStream,"/Request/Body/"_Tags_"/"_Tag_"["_counti_"]/"_"ext_code")  //外部代码
			s dataeobj.EXTDesc=..GetFieldValue(InputStream,"/Request/Body/"_Tags_"/"_Tag_"["_counti_"]/"_"ext_desc")  //外部名称
			s dataeobj.EXTCTLOCDR=..GetFieldValue(InputStream,"/Request/Body/"_Tags_"/"_Tag_"["_counti_"]/"_"ext_ctlocdr")  //接收科室 描述
			//s:dataeobj.EXTCTLOCDR'="" dataeobj.EXTCTLOCDR=$o(^CTLOC(0,"Desc",$$ALPHAUP^SSUTIL4(dataeobj.EXTCTLOCDR),0))
			s:dataeobj.EXTCTLOCDR'="" dataeobj.EXTCTLOCDR=##class(web.DHCBL.BDP.BDPDataImport).GetRowIdByCode("CT_Loc",dataeobj.EXTCTLOCDR,LinkHospId)
			
			s dataeobj.EXTDefaultReceive=..GetFieldValue(InputStream,"/Request/Body/"_Tags_"/"_Tag_"["_counti_"]/"_"ext_default_receive")  //是否默认 Y/N
			s dataeobj.EXTDEfaultSend=..GetFieldValue(InputStream,"/Request/Body/"_Tags_"/"_Tag_"["_counti_"]/"_"ext_default_send")  //是否单独生成条码   Y/N
			s dataeobj.EXTDateFrom=..GetFieldValue(InputStream,"/Request/Body/"_Tags_"/"_Tag_"["_counti_"]/"_"ext_start_date")  //开始日期
			s dataeobj.EXTDateTo=..GetFieldValue(InputStream,"/Request/Body/"_Tags_"/"_Tag_"["_counti_"]/"_"ext_end_date")  //接收日期
			
			if type="A"
			{
				s result=##class(web.DHCBL.CT.ARCItemExternalCodes).SaveEntity(dataeobj)  //新增医嘱项外部代码
			}
			else  //修改
			{
				s dataeobj.EXTRowId=$o(^ARCIM(0,"ExtCode",$$ALPHAUP^SSUTIL4(dataeobj.EXTCode),$p(dataeobj.EXTParRef,"||",1),$p(dataeobj.EXTParRef,"||",2),0))
				if dataeobj.EXTRowId=""
				{
					s result="没找到对应的医嘱项外部代码"
				}
				else
				{
					s result=##class(web.DHCBL.CT.ARCItemExternalCodes).SaveEntity(dataeobj)
				}
				
			}
			if (result["success:true")||(result["success:'true'")||(result["'success':'true'")
			{
				
			}
			else
			{
				s returncode=-1
				s info="推送失败"
				s status=-1
				s msg="医嘱项外部代码保存失败"_result
				s Rtn="<Result><arcim_code>"_arcimcode_"</arcim_code><ext_code>"_dataeobj.EXTCode_"</ext_code><arcim_row_id>"_dataeobj.EXTParRef_"</arcim_row_id><status>"_status_"</status><msg>"_msg_"</msg></Result>"
				if ResultsRtn="" s ResultsRtn=Rtn
				else  s ResultsRtn=ResultsRtn_Rtn
			}
			
		}
		
	}
	s:info="" info="推送成功"
	s TotalRtn="<Response><return_code>"_returncode_"</return_code><return_desc>"_info_"</return_desc><Body><Results>"_ResultsRtn_"</Results></Body></Response>"
	q TotalRtn
errorret
	s TotalRtn="<Response><return_code>"_returncode_"</return_code><return_desc>"_info_"</return_desc><Body><Results>"_ResultsRtn_"</Results></Body></Response>"
	q TotalRtn
}

/// Creator：陈莹
/// CreatDate: 2020-05-14
/// Description：医嘱项与收费项对照信息保存
/// Input：数据InputStream
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// w ##class(web.DHCBL.BDP.BDPInterface).SaveArcOrderLinktar(stream)
ClassMethod SaveArcOrderLinktar(InputStream As %Stream.GlobalCharacter) As %String
{
	s tSC=##class(%XML.XPATH.Document).CreateFromStream(InputStream,.tDocument)
	s Tags="ArcOrderLinktars",Tag="ArcOrderLinktar"   //医嘱项与收费项对照
	s returncode=0,ResultsRtn="",info=""
	s total= ..GetDataCount(InputStream,"/Request/Body/"_Tags,Tag)  //获取标签的个数
	if (total=0)||(total="")
	{
		s returncode=-1
		s info="数量为空"
		if ResultsRtn="" s ResultsRtn=info
		else  s ResultsRtn=ResultsRtn_info
	}
	else
	{
		s type=..GetFieldValue(InputStream,"/Request/Header/type")
		for counti=1:1:total	
		{
			k dataeobj
			s result=""
			s dataeobj=##class(web.Entity.CT.DHCOrderLinkTar).%New()
			//医院RowId
			s LinkHospId=..GetFieldValue(InputStream,"/Request/Body/"_Tags_"/"_Tag_"["_counti_"]/"_"org_code")  //医院代码	
			s:LinkHospId'="" LinkHospId=$o(^CT("HOSP",0,"Code",$$ALPHAUP^SSUTIL4(LinkHospId),0))
			///取对应的默认医院
			s LinkHospId= ##class(web.DHCBL.BDP.BDPMappingHOSP).GetDefHospIdByTableName("ARC_ItmMast",LinkHospId,+$h)
			
		    if (LinkHospId="")||(LinkHospId'>0)
			{
				s returncode=-1
				s info="医院ID为空"
				g errorret
			}
			s arcimcode=..GetFieldValue(InputStream,"/Request/Body/"_Tags_"/"_Tag_"["_counti_"]/"_"arcim_code") //医嘱项code
			if arcimcode=""
			{
				s returncode=-1
				s info="医嘱项代码为空"
				g errorret
			}
			s dataeobj.OLTARCIMDR=##class(web.DHCBL.BDP.BDPDataImport).GetRowIdByCode("ARC_ItmMast",arcimcode,LinkHospId)
			if dataeobj.OLTARCIMDR=""
			{
				s returncode=-1
				s info="医嘱项代码"_arcimcode_"找不到对应的id"
				g errorret
			}
			s taricode=..GetFieldValue(InputStream,"/Request/Body/"_Tags_"/"_Tag_"["_counti_"]/"_"tari_code") //收费项code
			if taricode=""
			{
				s returncode=-1
				s info="收费项代码为空"
				g errorret
			}
			
			s dataeobj.OLTTariffDR=##class(web.DHCBL.BDP.BDPDataImport).GetRowIdByCode("DHC_TarItem",taricode,LinkHospId)
			if dataeobj.OLTTariffDR=""
			{
				s returncode=-1
				s info="收费项代码"_taricode_"找不到对应的id"
				g errorret
			}
			s dataeobj.OLTQty=..GetFieldValue(InputStream,"/Request/Body/"_Tags_"/"_Tag_"["_counti_"]/"_"olt_qty")  //数量
			s dataeobj.OLTBascPriceFlag=..GetFieldValue(InputStream,"/Request/Body/"_Tags_"/"_Tag_"["_counti_"]/"_"olt_basc_price_flag")  //基价模式
			s dataeobj.OLTBillOnceFlag=..GetFieldValue(InputStream,"/Request/Body/"_Tags_"/"_Tag_"["_counti_"]/"_"olt_bill_once_flag")  //多部位计价一次
			s dataeobj.OLTStartDate=..GetFieldValue(InputStream,"/Request/Body/"_Tags_"/"_Tag_"["_counti_"]/"_"olt_start_date")  //关联开始日期
			s dataeobj.OLTEndDate=..GetFieldValue(InputStream,"/Request/Body/"_Tags_"/"_Tag_"["_counti_"]/"_"olt_end_date")  //关联结束日期
			if type="A"
			{
				s result=##class(web.DHCBL.CT.DHCOrderLinkTar).SaveEntity(dataeobj,1)  //新增医嘱项与收费项对照
			}
			else  //修改
			{
				s OLTStartDate=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(dataeobj.OLTStartDate)
				s OLTRowId=$o(^DHCOLT(0,"ARTTA",dataeobj.OLTARCIMDR,dataeobj.OLTTariffDR,OLTStartDate,0))
				if OLTRowId=""
				{
					s result="没找到对应的医嘱项与收费项对照关系"
				}
				else
				{
					s dataeobj.OLTRowId=OLTRowId
					s result=##class(web.DHCBL.CT.DHCOrderLinkTar).SaveEntity(dataeobj)  //修改医嘱项与收费项对照
				}
				
			}
			if (result["success:true")||(result["success:'true'")||(result["'success':'true'")
			{
				
			}
			else
			{
				s returncode=-1
				s info="推送失败"
				s status=-1
				s msg="医嘱项与收费项对照保存失败"_result
				s Rtn="<Result><arcim_code>"_arcimcode_"</arcim_code><tari_code>"_taricode_"</tari_code><status>"_status_"</status><msg>"_msg_"</msg></Result>"
				if ResultsRtn="" s ResultsRtn=Rtn
				else  s ResultsRtn=ResultsRtn_Rtn
			}
			
		}
	}
	s:info="" info="保存成功"
	s TotalRtn="<Response><return_code>"_returncode_"</return_code><return_desc>"_info_"</return_desc><Body><Results>"_ResultsRtn_"</Results></Body></Response>"
	q TotalRtn
errorret
	s TotalRtn="<Response><return_code>"_returncode_"</return_code><return_desc>"_info_"</return_desc><Body><Results>"_ResultsRtn_"</Results></Body></Response>"
	q TotalRtn
}

/// Creator：陈莹
/// CreatDate: 2020-05-14
/// Description：收费项目价格信息保存
/// Input：数据,tablename:第三方的表名
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// w ##class(web.DHCBL.BDP.BDPInterface).SaveTarItemPrice(stream)
ClassMethod SaveTarItemPrice(InputStream As %Stream.GlobalCharacter) As %String
{
	s tSC=##class(%XML.XPATH.Document).CreateFromStream(InputStream,.tDocument)
	s Tags="TarItemPrices",Tag="TarItemPrice"   //收费项目价格
	s returncode=0,ResultsRtn="",info=""
	s total= ..GetDataCount(InputStream,"/Request/Body/"_Tags,Tag)  //获取TarItem标签的个数
	if (total=0)||(total="")
	{
		s returncode=-1
		s info="数量为空"
		if ResultsRtn="" s ResultsRtn=info
		else  s ResultsRtn=ResultsRtn_info
	}
	else
	{
		s type=..GetFieldValue(InputStream,"/Request/Header/type")
		for counti=1:1:total	
		{
			k dataeobj
			s dataeobj=##class(web.Entity.CT.DHCTarItemPrice).%New()
			//医院RowId
			s LinkHospId=..GetFieldValue(InputStream,"/Request/Body/"_Tags_"/"_Tag_"["_counti_"]/"_"org_code")  //医院代码	
			s:LinkHospId'="" LinkHospId=$o(^CT("HOSP",0,"Code",$$ALPHAUP^SSUTIL4(LinkHospId),0))
			///取对应的默认医院
			s LinkHospId= ##class(web.DHCBL.BDP.BDPMappingHOSP).GetDefHospIdByTableName("DHC_TarItemPrice",LinkHospId,+$h)
			
		    if (LinkHospId="")||(LinkHospId'>0)
			{
				s returncode=-1
				s info="医院ID为空"
				g errorret
			}
			s taricode=..GetFieldValue(InputStream,"/Request/Body/"_Tags_"/"_Tag_"["_counti_"]/"_"tari_code") //收费项代码
			s taridesc=..GetFieldValue(InputStream,"/Request/Body/"_Tags_"/"_Tag_"["_counti_"]/"_"tari_desc") //收费项描述
			//s dataeobj.TPTARIParRef=..GetFieldValue(InputStream,"/Request/Body/"_Tags_"/"_Tag_"["_counti_"]/"_"tari_row_id") //收费项rowid
			if taricode=""
			{
				s returncode=-1
				s info="收费项代码为空"
				g errorret
			}
			s dataeobj.TPTARIParRef=##class(web.DHCBL.BDP.BDPDataImport).GetRowIdByCode("DHC_TarItem",taricode,LinkHospId)
			if dataeobj.TPTARIParRef=""
			{
				s returncode=-1
				s info="收费项代码"_taricode_"找不到对应的id"
				g errorret
			}
			s dataeobj.TPPatInsType=..GetFieldValue(InputStream,"/Request/Body/"_Tags_"/"_Tag_"["_counti_"]/"_"tp_patins_type") //患者费别 描述
			//s:dataeobj.TPPatInsType'="" dataeobj.TPPatInsType=$o(^PAC("ADMREA",0,"Desc",$$ALPHAUP^SSUTIL4(dataeobj.TPPatInsType),0))
			s:dataeobj.TPPatInsType'="" dataeobj.TPPatInsType=##class(web.DHCBL.BDP.BDPDataImport).GetRowIdByDesc("PAC_AdmReason",dataeobj.TPPatInsType,LinkHospId)
			
			s dataeobj.TPPrice=..GetFieldValue(InputStream,"/Request/Body/"_Tags_"/"_Tag_"["_counti_"]/"_"tp_price")  //价格
			s dataeobj.TPStartDate=..GetFieldValue(InputStream,"/Request/Body/"_Tags_"/"_Tag_"["_counti_"]/"_"tp_start_date")  //开始日期
			s:dataeobj.TPStartDate="" dataeobj.TPStartDate=+$H+1
			s dataeobj.TPEndDate=..GetFieldValue(InputStream,"/Request/Body/"_Tags_"/"_Tag_"["_counti_"]/"_"tp_end_date")  //结束日期
			s dataeobj.TPAlterPrice1=..GetFieldValue(InputStream,"/Request/Body/"_Tags_"/"_Tag_"["_counti_"]/"_"tp_alter_price1")  //辅助价格1
			s dataeobj.TPAlterPrice2=..GetFieldValue(InputStream,"/Request/Body/"_Tags_"/"_Tag_"["_counti_"]/"_"tp_alter_price2")  //辅助价格2
			s dataeobj.TPHospitalDR=LinkHospId  //医院
			
			s dataeobj.TPUpdateUser=..GetFieldValue(InputStream,"/Request/Body/"_Tags_"/"_Tag_"["_counti_"]/"_"tp_updateuser")  ///人员工号
			s:dataeobj.TPUpdateUser'="" dataeobj.TPUpdateUser=$o(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(dataeobj.TPUpdateUser),0))
			
			
			s result=##class(web.DHCBL.CT.DHCTarItemPrice).SaveEntity(dataeobj)   //修改收费项目时 ，限制价格开始日期
			if (result["success:true")||(result["success:'true'")||(result["'success':'true'")
			{
				s status=0
				s msg="收费项价格保存成功"
				s Rtn="<Result><tari_code>"_taricode_"</tari_code><tari_desc>"_taridesc_"</tari_desc><tari_row_id>"_dataeobj.TPTARIParRef_"</tari_row_id><status>"_status_"</status><msg>"_msg_"</msg></Result>"
				if ResultsRtn="" s ResultsRtn=Rtn
				else  s ResultsRtn=ResultsRtn_Rtn
				
			}
			else
			{
				s returncode=-1
				s info="推送失败"
				s status=-1
				s msg="收费项价格保存失败"_result
				s Rtn="<Result><tari_code>"_taricode_"</tari_code><tari_desc>"_taridesc_"</tari_desc><tari_row_id>"_dataeobj.TPTARIParRef_"</tari_row_id><status>"_status_"</status><msg>"_msg_"</msg></Result>"
				if ResultsRtn="" s ResultsRtn=Rtn
				else  s ResultsRtn=ResultsRtn_Rtn
			}
		}
	}
	s:info="" info="保存成功"
	s TotalRtn="<Response><return_code>"_returncode_"</return_code><return_desc>"_info_"</return_desc><Body><Results>"_ResultsRtn_"</Results></Body></Response>"
	q TotalRtn
errorret
	s TotalRtn="<Response><return_code>"_returncode_"</return_code><return_desc>"_info_"</return_desc><Body><Results>"_ResultsRtn_"</Results></Body></Response>"
	q TotalRtn
}

/// 巩义项目  医嘱项收费项价格 及关联的同步 2020-05-21
/// w ##class(web.DHCBL.BDP.BDPInterface).SyncDataToPlatform("A","ArcItem","3214||1")
/// w ##class(web.DHCBL.BDP.BDPInterface).SyncDataToPlatform("A","TarItem","3175")
/// w ##class(web.DHCBL.BDP.BDPInterface).SyncDataToPlatform("A","ArcOrderLinktar","349")
/// w ##class(web.DHCBL.BDP.BDPInterface).SyncDataToPlatform("A","TarItemPrice","3175||1")
/// w ##class(web.DHCBL.BDP.BDPInterface).SyncDataToPlatform("A","ArcItem","7588||1")
ClassMethod SyncDataToPlatform(type As %String, tablename As %String, DataRowId) As %String
{
	q ""
	s str=##class(web.DHCBL.BDP.BDPInterface).GetXMLDataByRowId(type,tablename,DataRowId)
	if str="" q "-1^药品和物资数据不同步"
	s Soap= ##class(SynServiceByBaseService.SynServiceByBasePort).%New()
	s Soap.Timeout=5 //设置超时时间5s 2022-01-13
	if tablename="ArcItem" s ret= Soap.syncArc(str)
	if tablename="TarItem" s ret= Soap.syncTari(str)
	if tablename="TarItemPrice" s ret= Soap.syncTarItemPrices(str)
	if tablename="ArcOrderLinktar" s ret= Soap.syncArcOrderLinktar(str)
	if tablename="ArcItemExternalCode" s ret= Soap.syncArcItemExternalCode(str)
	//s ^tmpcy($p($H,",",2),tablename, DataRowId,"str")=str
	//s ^tmpcy($p($H,",",2),tablename, DataRowId,"ret")=ret
	q ret
}

/// 巩义项目 同步人民医院数据到基层his
/// 2020-06-17
ClassMethod SyncARCIMandTarItem()
{
	
	k ^tmpcy
	s taricount=0
	//d ##class(web.DHCBL.BDP.BDPInterface).SyncARCIMandTarItem()
	S TARIRowId=0
	for
	{
		s TARIRowId=$o(^DHCTARI(TARIRowId))  q:(TARIRowId="")
		
		s tarisubcate =$p($g(^DHCTARI(TARIRowId)),"^",4) ///收费项目子类
		s taricatedr=""
		s:tarisubcate'="" taricatedr=$p($g(^DHCTarC("SC",tarisubcate)),"^",3)
		if taricatedr'=""
		{
			s taricatedesc =$p($g(^DHCTarC("CC",tarisubcate)),"^",2)  //收费项目大类描述
			continue:(taricatedesc="西药费")||(taricatedesc="中成药费")||(taricatedesc="中草药费")||(taricatedesc="材料费")
		}
		s taricount=taricount+1
		//同步收费项
		s ret=##class(web.DHCBL.BDP.BDPInterface).SyncDataToPlatform("A","TarItem",TARIRowId)
		s ^tmpcy("TarItem",TARIRowId)=ret
		s TPChildSub=0
		for
		{
			s TPChildSub=$o(^DHCTARI(TARIRowId,"P",TPChildSub))  q:(TPChildSub="")
			s TPRowId=TARIRowId_"||"_TPChildSub

			//同步收费项价格
			s ret=##class(web.DHCBL.BDP.BDPInterface).SyncDataToPlatform("TarItemPrice",TPRowId)
			s ^tmpcy("TarItemPrice",TPRowId)=ret
		}
	}
	
	s arcimcount=0
	
	//循环所有医嘱项，同步医嘱项，医嘱项外部代码，医嘱项对应的收费项关联
	S ARCIMSubscript=0
	for
	{
		s ARCIMSubscript=$o(^ARCIM(ARCIMSubscript))  q:ARCIMSubscript=""
		CONTINUE:$D(^INCI(0,"ARCIM_DR",ARCIMSubscript))>0 //过滤掉关联了库存项的医嘱项
		s ARCIMVersion=0
		for 
		{
			s ARCIMVersion=$o(^ARCIM(ARCIMSubscript,ARCIMVersion))  q:ARCIMVersion=""
			s ARCIMRowId=ARCIMSubscript_"||"_ARCIMVersion
			
			s ARCIMItemCatDR=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",10)
			if ARCIMItemCatDR'=""
			{
				
				s ARCICOrderType=$p($g(^ARC("IC",ARCIMItemCatDR)),"^",7)
				if (ARCICOrderType'="R")&&(ARCICOrderType'="M")  //屏蔽药品和材料
				{
					
					s arcimorcatdr=""
					if ARCIMItemCatDR'=""  s arcimorcatdr=$p($g(^ARC("IC",ARCIMItemCatDR)),"^",8)
					s arcimorcatdrdesc=""
					s:arcimorcatdr'="" arcimorcatdrdesc=$p($g(^OEC("ORCAT",arcimorcatdr)),"^",2)
					if (arcimorcatdrdesc'="检查")&&(arcimorcatdrdesc'="检验") continue  //只同步医嘱大类为检查或检验的
					
					s arcimcount=arcimcount+1
					///同步医嘱项
					s ret= ##class(web.DHCBL.BDP.BDPInterface).SyncDataToPlatform("A","ArcItem",ARCIMRowId)
					s ^tmpcy("ArcItem",ARCIMRowId)=ret
					
					s extsub=0
					for
					{
						s extsub=$o(^ARCIM(ARCIMSubscript,ARCIMVersion,"EXT",extsub)) q:extsub=""
						s EXTRowId=ARCIMSubscript_"||"_ARCIMVersion_"||"_extsub
						//同步医嘱项外部代码
						s ret=##class(web.DHCBL.BDP.BDPInterface).SyncDataToPlatform("ArcItemExternalCode",EXTRowId)
						s ^tmpcy("ArcItemExternalCode",EXTRowId)=ret
						
					}
		
					///医嘱项对应的收费项关联
					s olttariffdr=0
					for
					{
						s olttariffdr=$o(^DHCOLT(0,"ARTTA",ARCIMRowId,olttariffdr)) q:olttariffdr="" 
						s startdate=0
						for
						{
							s startdate=$o(^DHCOLT(0,"ARTTA",ARCIMRowId,olttariffdr,startdate)) q:startdate=""
							s associaterowid=0
							for
							{
								s associaterowid=$o(^DHCOLT(0,"ARTTA",ARCIMRowId,olttariffdr,startdate,associaterowid)) q:associaterowid=""
								//同步医嘱项与收费项关联
								s ret=##class(web.DHCBL.BDP.BDPInterface).SyncDataToPlatform("ArcOrderLinktar",associaterowid)
								s ^tmpcy("ArcOrderLinktar",associaterowid)=ret
							}
						}
					}
				}
			}
		}
	}
	q taricount_"^"_arcimcount
	//zw ^tmpcy
}

/// Creator：陈莹
/// CreatDate: 2020-05-14
/// Description：医嘱项、收费项、医嘱项与收费项关联 信息新增 修改，不做删除
/// Input：数据
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// w ##class(web.DHCBL.BDP.BDPInterface).SaveArcItemAndTarItem(stream)
ClassMethod SaveArcItemAndTarItem(InputStream As %Stream.GlobalCharacter) As %String
{
	s tSC=##class(%XML.XPATH.Document).CreateFromStream(InputStream,.tDocument)
	s Tags="ArcItemAndTarItems",Tag="ArcItemAndTarItem"   //医嘱项、收费项、医嘱项与收费项关联
	s returncode=0,ResultsRtn="",info=""  //,Rtn=""
	s total= ..GetDataCount(InputStream,"/Request/Body/"_Tags,Tag)  //获取标签的个数
	if (total=0)||(total="")
	{
		s returncode=-1
		s info="数量为空"
		if ResultsRtn="" s ResultsRtn=info
		else  s ResultsRtn=ResultsRtn_info
	}
	else
	{
		s type=..GetFieldValue(InputStream,"/Request/Header/type")
		for counti=1:1:total	
		{
			k dataeobj
			s dataeobj=##class(web.Entity.CT.ARCItmMast).%New()
			//更新标志，是否更新医嘱项和收费项的部分dr指针，有些是需要在his里维护的,1时更新
			//目前涉及字段包括医嘱子分类、账单子组、收费项的7个分类
			s updateflag=..GetFieldValue(InputStream,"/Request/Body/"_Tags_"/"_Tag_"["_counti_"]/"_"updateflag")  //更新标志	
			
			//医院RowId
			s LinkHospId=..GetFieldValue(InputStream,"/Request/Body/"_Tags_"/"_Tag_"["_counti_"]/"_"org_code")  //医院代码	
			s:LinkHospId'="" LinkHospId=$o(^CT("HOSP",0,"Code",$$ALPHAUP^SSUTIL4(LinkHospId),0))
			///取对应的默认医院
			s LinkHospId= ##class(web.DHCBL.BDP.BDPMappingHOSP).GetDefHospIdByTableName("ARC_ItmMast",LinkHospId,+$h)
			if (LinkHospId="")||(LinkHospId'>0)
			{
				s returncode=-1
				s info="医院ID为空"
				g errorret
			}
			s arcimcode=..GetFieldValue(InputStream,"/Request/Body/"_Tags_"/"_Tag_"["_counti_"]/"_"arcim_code") //医嘱代码
			s dataeobj.ARCIMCode=arcimcode
			if (dataeobj.ARCIMCode="")
			{
				s returncode=-1
				s info="医嘱代码arcim_code不能为空"
				g errorret
			}
			
			s dataeobj.ARCIMRowId=##class(web.DHCBL.BDP.BDPDataImport).GetRowIdByCode("ARC_ItmMast",arcimcode,LinkHospId) //根据code获取rowid
			if (dataeobj.ARCIMRowId="")&&(type="U")
			{
				s returncode=-1
				s info="医嘱代码arcim_code不能修改"
				g errorret
			}
			
			s:dataeobj.ARCIMRowId'="" ARCIMSubscript=$p(dataeobj.ARCIMRowId,"||",1)
			s:dataeobj.ARCIMRowId'="" ARCIMVersion=$p(dataeobj.ARCIMRowId,"||",2)
			//医院
			s dataeobj.LinkHospId=LinkHospId
			s dataeobj.ARCIMDesc=..GetFieldValue(InputStream,"/Request/Body/"_Tags_"/"_Tag_"["_counti_"]/"_"arcim_desc") //医嘱描述
			if (dataeobj.ARCIMDesc="")
			{
				s returncode=-1
				s info="医嘱描述arcim_desc不能为空"
				g errorret
			}
			
			s dataeobj.ARCIMBillingUOMDR=..GetFieldValue(InputStream,"/Request/Body/"_Tags_"/"_Tag_"["_counti_"]/"_"arcim_bill_uomdr") //账单单位
			//s:dataeobj.ARCIMBillingUOMDR'="" dataeobj.ARCIMBillingUOMDR=$o(^CT("UOM",0,"Desc",$$UPPER^SSUTIL4(dataeobj.ARCIMBillingUOMDR),0))
			
			s:dataeobj.ARCIMBillingUOMDR'="" dataeobj.ARCIMBillingUOMDR=##class(web.DHCBL.BDP.BDPDataImport).GetRowIdByDesc("CT_UOM",dataeobj.ARCIMBillingUOMDR,LinkHospId)
			if (dataeobj.ARCIMBillingUOMDR="")
			{
				s returncode=-1
				s info="账单单位arcim_bill_uomdr不能为空"
				g errorret
			}
			s dataeobj.ARCIMItemCatDR=..GetFieldValue(InputStream,"/Request/Body/"_Tags_"/"_Tag_"["_counti_"]/"_"arcim_itemcat_dr") //医嘱子类代码
			//s:dataeobj.ARCIMItemCatDR'="" dataeobj.ARCIMItemCatDR=$o(^ARC("IC",0,"Code",$$ALPHAUP^SSUTIL4(dataeobj.ARCIMItemCatDR),0))
			s:dataeobj.ARCIMItemCatDR'="" dataeobj.ARCIMItemCatDR=##class(web.DHCBL.BDP.BDPDataImport).GetRowIdByDesc("ARC_ItemCat",dataeobj.ARCIMItemCatDR,LinkHospId)
			//20220811部分分类指针在修改的时候不更新
			if (dataeobj.ARCIMRowId'="")&&(type="U")&&(updateflag'=1)
			{
				s dataeobj.ARCIMItemCatDR=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",10)
			}
			
			if (dataeobj.ARCIMItemCatDR="")
			{
				s returncode=-1
				s info="医嘱子分类arcim_itemcat_dr不能为空"
				g errorret
			}
			s dataeobj.ARCIMBillSubDR=..GetFieldValue(InputStream,"/Request/Body/"_Tags_"/"_Tag_"["_counti_"]/"_"arcim_bill_sub_dr") //账单子组
			if dataeobj.ARCIMBillSubDR'=""
			{
				/*s parref=$o(^ARCBG("SG_Desc",$$ALPHAUP^SSUTIL4(dataeobj.ARCIMBillSubDR),0))
				if parref'=""
				{
					s sub=$o(^ARCBG("SG_Desc",$$ALPHAUP^SSUTIL4(dataeobj.ARCIMBillSubDR),parref,0))
					s dataeobj.ARCIMBillSubDR=parref_"||"_sub
				}*/
				s:dataeobj.ARCIMBillSubDR'="" dataeobj.ARCIMBillSubDR=##class(web.DHCBL.BDP.BDPDataImport).GetRowIdByDesc("ARC_BillSub",dataeobj.ARCIMBillSubDR,LinkHospId)
			
			}
			if (dataeobj.ARCIMRowId'="")&&(type="U")&&(updateflag'=1)
			{
				s dataeobj.ARCIMBillSubDR=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",9)
			}
			
			
			if (dataeobj.ARCIMBillSubDR="")
			{
				s returncode=-1
				s info="帐单组arcim_bill_sub_dr不能为空"
				g errorret
			}
			s dataeobj.ARCIMOrderOnItsOwn=..GetFieldValue(InputStream,"/Request/Body/"_Tags_"/"_Tag_"["_counti_"]/"_"arcim_order_onIts_own") //独立医嘱
			s:dataeobj.ARCIMOrderOnItsOwn="" dataeobj.ARCIMOrderOnItsOwn="N"
			s dataeobj.ARCIMAllowOrderWOStockCheck=..GetFieldValue(InputStream,"/Request/Body/"_Tags_"/"_Tag_"["_counti_"]/"_"arcim_allow_order_wostock_check") //无库存医嘱
			s:dataeobj.ARCIMAllowOrderWOStockCheck="" dataeobj.ARCIMAllowOrderWOStockCheck="N"  //空时默认为N
			s dataeobj.ARCIMSensitive=..GetFieldValue(InputStream,"/Request/Body/"_Tags_"/"_Tag_"["_counti_"]/"_"arcim_sensitive") //加急医嘱
			s dataeobj.ARCIMOEMessage=..GetFieldValue(InputStream,"/Request/Body/"_Tags_"/"_Tag_"["_counti_"]/"_"arcim_oe_message") //医嘱备注
			
			s dataeobj.ARCIMServiceGroupDR=..GetFieldValue(InputStream,"/Request/Body/"_Tags_"/"_Tag_"["_counti_"]/"_"arcim_service_group_dr") //服务组
			//s:dataeobj.ARCIMServiceGroupDR'="" dataeobj.ARCIMServiceGroupDR=$o(^RBC("SG",0,"Desc",$$ALPHAUP^SSUTIL4(dataeobj.ARCIMServiceGroupDR),0))
			s:dataeobj.ARCIMServiceGroupDR'="" dataeobj.ARCIMServiceGroupDR=##class(web.DHCBL.BDP.BDPDataImport).GetRowIdByDesc("RBC_ServiceGroup",dataeobj.ARCIMServiceGroupDR,LinkHospId)
			
			s dataeobj.ARCIMDerFeeRulesDR=..GetFieldValue(InputStream,"/Request/Body/"_Tags_"/"_Tag_"["_counti_"]/"_"arcim_der_fee_rules_dr") //费用标准
			s dataeobj.ARCIMChgOrderPerHour=..GetFieldValue(InputStream,"/Request/Body/"_Tags_"/"_Tag_"["_counti_"]/"_"arcim_chg_order_per_hour") //小时医嘱
			s dataeobj.ARCIMDeceasedPatientsOnly=..GetFieldValue(InputStream,"/Request/Body/"_Tags_"/"_Tag_"["_counti_"]/"_"arcim_deceased_patients_only") //限制为已故病人用
			s dataeobj.ARCIMDisplayCumulative=..GetFieldValue(InputStream,"/Request/Body/"_Tags_"/"_Tag_"["_counti_"]/"_"arcim_display_cumulative") //显示累计
			s dataeobj.ARCIMUseODBCforWord=..GetFieldValue(InputStream,"/Request/Body/"_Tags_"/"_Tag_"["_counti_"]/"_"arcim_use_odbc_forword") //使用ODBC模板
			s dataeobj.ARCIMRestrictEM=..GetFieldValue(InputStream,"/Request/Body/"_Tags_"/"_Tag_"["_counti_"]/"_"arcim_restrict_em") //限制为急诊病人用
			s dataeobj.ARCIMRestrictIP=..GetFieldValue(InputStream,"/Request/Body/"_Tags_"/"_Tag_"["_counti_"]/"_"arcim_restrict_ip") //限制为住院病人用
			s dataeobj.ARCIMRestrictOP=..GetFieldValue(InputStream,"/Request/Body/"_Tags_"/"_Tag_"["_counti_"]/"_"arcim_restrict_op") //限制为门诊病人用
			s dataeobj.ARCIMRestrictHP=..GetFieldValue(InputStream,"/Request/Body/"_Tags_"/"_Tag_"["_counti_"]/"_"arcim_restrict_hp") //限制为体检病人用
			s dataeobj.ARCIMSensitiveOrder=..GetFieldValue(InputStream,"/Request/Body/"_Tags_"/"_Tag_"["_counti_"]/"_"arcim_sensitive_order") //敏感医嘱
			s dataeobj.ARCIMAbbrev=..GetFieldValue(InputStream,"/Request/Body/"_Tags_"/"_Tag_"["_counti_"]/"_"arcim_abbrev") //医嘱缩写
			s dataeobj.ARCIMEffDate=..GetFieldValue(InputStream,"/Request/Body/"_Tags_"/"_Tag_"["_counti_"]/"_"arcim_start_date") //数据开始日期
			s dataeobj.ARCIMEffDateTo=..GetFieldValue(InputStream,"/Request/Body/"_Tags_"/"_Tag_"["_counti_"]/"_"arcim_end_date") //数据结束日期
			//是否扫码计费 20220805
			s dataeobj.ARCIMScanCodeBilling=..GetFieldValue(InputStream,"/Request/Body/"_Tags_"/"_Tag_"["_counti_"]/"_"arcim_scancodebilling") //是否扫码计费 20220805
			
			s dataeobj.ARCIMServMaterial=..GetFieldValue(InputStream,"/Request/Body/"_Tags_"/"_Tag_"["_counti_"]/"_"arcim_servmaterial") //服务/材料
			s dataeobj.ARCIMServMaterial=$case(dataeobj.ARCIMServMaterial,"材料":"M","服务":"S","S":"S","M":"M",:"")
			s dataeobj.ARCIMText1=..GetFieldValue(InputStream,"/Request/Body/"_Tags_"/"_Tag_"["_counti_"]/"_"arcim_text1")
			s dataeobj.ARCIMText2=..GetFieldValue(InputStream,"/Request/Body/"_Tags_"/"_Tag_"["_counti_"]/"_"arcim_text2")
			s dataeobj.ARCIMText3=..GetFieldValue(InputStream,"/Request/Body/"_Tags_"/"_Tag_"["_counti_"]/"_"arcim_text3")
			s dataeobj.ARCIMText4=..GetFieldValue(InputStream,"/Request/Body/"_Tags_"/"_Tag_"["_counti_"]/"_"arcim_text4")
			s dataeobj.ARCIMText5=..GetFieldValue(InputStream,"/Request/Body/"_Tags_"/"_Tag_"["_counti_"]/"_"arcim_text5")
			s result=##class(web.DHCBL.CT.ARCItmMast).SaveEntity(dataeobj)	
			if (result["success:true")||(result["success:'true'")||(result["'success':'true'")
			{
				s ARCIMRowId=##class(web.DHCBL.BDP.FunLib).GetResultRowId(result)
				s dataeobj.ARCIMRowId=ARCIMRowId
				//保存医院关联
				d ##class(web.DHCBL.CT.ARCItemHosp).AddARCItemHosp(ARCIMRowId_"^"_LinkHospId)
				
				
				k dataeobj
				s dataeobj=##class(web.Entity.CT.DHCTarItem).%New()
				s taricode=..GetFieldValue(InputStream,"/Request/Body/"_Tags_"/"_Tag_"["_counti_"]/"_"tari_code") //收费项代码
				s dataeobj.TARICode=taricode
				if (dataeobj.TARICode="")
				{
					s returncode=-1
					s info="收费项代码tari_code不能为空"
					g errorret
				}
				
				//收费项rowid
				s dataeobj.TARIRowId=##class(web.DHCBL.BDP.BDPDataImport).GetRowIdByCode("DHC_TarItem",taricode,LinkHospId)
				if (dataeobj.TARIRowId="")&&(type="U")
				{
					s returncode=-1
					s info="收费项代码tari_code不能修改"
					g errorret
				}
				//医院 
				s dataeobj.LinkHospId=LinkHospId
				
				
				s dataeobj.TARIDesc=..GetFieldValue(InputStream,"/Request/Body/"_Tags_"/"_Tag_"["_counti_"]/"_"tari_desc") //收费项描述
				if (dataeobj.TARIDesc="")
				{
					s returncode=-1
					s info="收费项描述tari_desc不能为空"
					g errorret
				}
				s dataeobj.TARIUOM=..GetFieldValue(InputStream,"/Request/Body/"_Tags_"/"_Tag_"["_counti_"]/"_"tari_uom") //单位代码
				//s:dataeobj.TARIUOM'="" dataeobj.TARIUOM=$o(^CT("UOM",0,"Desc",$$UPPER^SSUTIL4(dataeobj.TARIUOM),0))
				s:dataeobj.TARIUOM'="" dataeobj.TARIUOM=##class(web.DHCBL.BDP.BDPDataImport).GetRowIdByDesc("CT_UOM",dataeobj.TARIUOM,LinkHospId)
				if (dataeobj.TARIUOM="")
				{
					s returncode=-1
					s info="收费项单位tari_uom不能为空"
					g errorret
				}
				s dataeobj.TARISubCate=..GetFieldValue(InputStream,"/Request/Body/"_Tags_"/"_Tag_"["_counti_"]/"_"tari_sub_cate") //收费项目子类代码
				//s:dataeobj.TARISubCate'="" dataeobj.TARISubCate=$o(^DHCTarC("SC",0,"Desc",dataeobj.TARISubCate,0))
				s:dataeobj.TARISubCate'="" dataeobj.TARISubCate=##class(web.DHCBL.BDP.BDPDataImport).GetRowIdByDesc("DHC_TarSubCate",dataeobj.TARISubCate,LinkHospId)
				if (dataeobj.TARIRowId'="")&&(type="U")&&(updateflag'=1)
				{
					s dataeobj.TARISubCate=$p($g(^DHCTARI(dataeobj.TARIRowId)),"^",4)
				}
				if (dataeobj.TARISubCate="")
				{
					s returncode=-1
					s info="收费项目子类代码tari_sub_cate不能为空"
					g errorret
				}
				s dataeobj.TARIAcctCate=..GetFieldValue(InputStream,"/Request/Body/"_Tags_"/"_Tag_"["_counti_"]/"_"tari_acct_cate") //收费会计子类代码
				//s:dataeobj.TARIAcctCate'="" dataeobj.TARIAcctCate=$o(^DHCTarC("AC",0,"Desc",dataeobj.TARIAcctCate,0))
				s:dataeobj.TARIAcctCate'="" dataeobj.TARIAcctCate=##class(web.DHCBL.BDP.BDPDataImport).GetRowIdByDesc("DHC_TarAcctCate",dataeobj.TARIAcctCate,LinkHospId)
				if (dataeobj.TARIRowId'="")&&(type="U")&&(updateflag'=1)
				{
					s dataeobj.TARIAcctCate=$p($g(^DHCTARI(dataeobj.TARIRowId)),"^",5)
				}
				
				s dataeobj.TARIOutpatCate=..GetFieldValue(InputStream,"/Request/Body/"_Tags_"/"_Tag_"["_counti_"]/"_"tari_outpat_cate") //门诊费用子类代码
				//s:dataeobj.TARIOutpatCate'="" dataeobj.TARIOutpatCate=$o(^DHCTarC("OC",0,"Desc",dataeobj.TARIOutpatCate,0))
				s:dataeobj.TARIOutpatCate'="" dataeobj.TARIOutpatCate=##class(web.DHCBL.BDP.BDPDataImport).GetRowIdByDesc("DHC_TarOutpatCate",dataeobj.TARIOutpatCate,LinkHospId)
				if (dataeobj.TARIRowId'="")&&(type="U")&&(updateflag'=1)
				{
					s dataeobj.TARIOutpatCate=$p($g(^DHCTARI(dataeobj.TARIRowId)),"^",15)
				}
				s dataeobj.TARIEMCCate=..GetFieldValue(InputStream,"/Request/Body/"_Tags_"/"_Tag_"["_counti_"]/"_"tari_emc_cate") //经济核算子类代码
				//s:dataeobj.TARIEMCCate'="" dataeobj.TARIEMCCate=$o(^DHCTarC("EC",0,"Desc",dataeobj.TARIEMCCate,0))
				s:dataeobj.TARIEMCCate'="" dataeobj.TARIEMCCate=##class(web.DHCBL.BDP.BDPDataImport).GetRowIdByDesc("DHC_TarEMCCate",dataeobj.TARIEMCCate,LinkHospId)
				if (dataeobj.TARIRowId'="")&&(type="U")&&(updateflag'=1)
				{
					s dataeobj.TARIEMCCate=$p($g(^DHCTARI(dataeobj.TARIRowId)),"^",16)
				}
				s dataeobj.TARIMRCate=..GetFieldValue(InputStream,"/Request/Body/"_Tags_"/"_Tag_"["_counti_"]/"_"tari_mr_cate") //旧病案首页子类代码
				//s:dataeobj.TARIMRCate'="" dataeobj.TARIMRCate=$o(^DHCTarC("MC",0,"Desc",dataeobj.TARIMRCate,0))
				s:dataeobj.TARIMRCate'="" dataeobj.TARIMRCate=##class(web.DHCBL.BDP.BDPDataImport).GetRowIdByDesc("DHC_TarMRCate",dataeobj.TARIMRCate,LinkHospId)
				if (dataeobj.TARIRowId'="")&&(type="U")&&(updateflag'=1)
				{
					s dataeobj.TARIMRCate=$p($g(^DHCTARI(dataeobj.TARIRowId)),"^",6)
				}
				s dataeobj.TARISpecialFlag=..GetFieldValue(InputStream,"/Request/Body/"_Tags_"/"_Tag_"["_counti_"]/"_"tari_special_flag") //
				s dataeobj.TARIActiveFlag=..GetFieldValue(InputStream,"/Request/Body/"_Tags_"/"_Tag_"["_counti_"]/"_"tari_active_flag") //
				s dataeobj.TARIStartDate=..GetFieldValue(InputStream,"/Request/Body/"_Tags_"/"_Tag_"["_counti_"]/"_"tari_start_date") //
				s dataeobj.TARIEndDate=..GetFieldValue(InputStream,"/Request/Body/"_Tags_"/"_Tag_"["_counti_"]/"_"tari_end_date") //
				s dataeobj.TARIExternalCode=..GetFieldValue(InputStream,"/Request/Body/"_Tags_"/"_Tag_"["_counti_"]/"_"tari_external_code") //
				
				s dataeobj.TARIInpatCate=..GetFieldValue(InputStream,"/Request/Body/"_Tags_"/"_Tag_"["_counti_"]/"_"tari_inpat_cate") //
				//s:dataeobj.TARIInpatCate'="" dataeobj.TARIInpatCate=$o(^DHCTarC("IC",0,"Desc",dataeobj.TARIInpatCate,0))
				s:dataeobj.TARIInpatCate'="" dataeobj.TARIInpatCate=##class(web.DHCBL.BDP.BDPDataImport).GetRowIdByDesc("DHC_TarInpatCate",dataeobj.TARIInpatCate,LinkHospId)
				if (dataeobj.TARIRowId'="")&&(type="U")&&(updateflag'=1)
				{
					s dataeobj.TARIInpatCate=$p($g(^DHCTARI(dataeobj.TARIRowId)),"^",14)
				}
				s dataeobj.TARIInsuName=..GetFieldValue(InputStream,"/Request/Body/"_Tags_"/"_Tag_"["_counti_"]/"_"tari_insu_name") //
				s dataeobj.TARIEngName=..GetFieldValue(InputStream,"/Request/Body/"_Tags_"/"_Tag_"["_counti_"]/"_"tari_eng_name") //
				s dataeobj.TARIChargeBasis=..GetFieldValue(InputStream,"/Request/Body/"_Tags_"/"_Tag_"["_counti_"]/"_"tari_charge_basis") //
				
				s dataeobj.TARIItemCatDR=..GetFieldValue(InputStream,"/Request/Body/"_Tags_"/"_Tag_"["_counti_"]/"_"tari_item_cat_dr") //
				//s:dataeobj.TARIItemCatDR'="" dataeobj.TARIItemCatDR=$o(^User.BDPItemCategoryI("UniqueCodeIndex"," "_$ZCVT(dataeobj.TARIItemCatDR,"U"),0))
				s:dataeobj.TARIItemCatDR'="" dataeobj.TARIItemCatDR=##class(web.DHCBL.BDP.BDPDataImport).GetRowIdByDesc("BDP_ItemCategory",dataeobj.TARIItemCatDR,LinkHospId)
				
				s dataeobj.TARIMCNew=..GetFieldValue(InputStream,"/Request/Body/"_Tags_"/"_Tag_"["_counti_"]/"_"tari_mc_new") //
				//s:dataeobj.TARIMCNew'="" dataeobj.TARIMCNew=$o(^DHCTARMRCATENEW(0,"Desc",dataeobj.TARIMCNew,0))
				s:dataeobj.TARIMCNew'="" dataeobj.TARIMCNew=##class(web.DHCBL.BDP.BDPDataImport).GetRowIdByDesc("DHC_TarMCCateNew",dataeobj.TARIMCNew,LinkHospId)
				if (dataeobj.TARIRowId'="")&&(type="U")&&(updateflag'=1)
				{
					s dataeobj.TARIMCNew=$p($g(^DHCTARI(dataeobj.TARIRowId)),"^",30)
				}
				s dataeobj.TARIConnote=..GetFieldValue(InputStream,"/Request/Body/"_Tags_"/"_Tag_"["_counti_"]/"_"tari_connote") //
				s dataeobj.TARIRemark=..GetFieldValue(InputStream,"/Request/Body/"_Tags_"/"_Tag_"["_counti_"]/"_"tari_remark") //
				s dataeobj.TARIExclude=..GetFieldValue(InputStream,"/Request/Body/"_Tags_"/"_Tag_"["_counti_"]/"_"tari_exclude") //
				s dataeobj.TARIOPERCategoryDR=..GetFieldValue(InputStream,"/Request/Body/"_Tags_"/"_Tag_"["_counti_"]/"_"tari_opercategory_dr") //
				s:dataeobj.TARIOPERCategoryDR'="" dataeobj.TARIOPERCategoryDR=$o(^ORC("CATEG",0,"Code",$$ALPHAUP^SSUTIL4(dataeobj.TARIOPERCategoryDR),0))
				
				//国家医保编码
				s dataeobj.TARIInsuCode=..GetFieldValue(InputStream,"/Request/Body/"_Tags_"/"_Tag_"["_counti_"]/"_"tari_insucode") //国家医保编码
				//厂商名称
				s dataeobj.TARIManufacturerName=..GetFieldValue(InputStream,"/Request/Body/"_Tags_"/"_Tag_"["_counti_"]/"_"tari_manufacturerdr") //厂商名称
				//进口标志
				s dataeobj.TARIManufactorType=..GetFieldValue(InputStream,"/Request/Body/"_Tags_"/"_Tag_"["_counti_"]/"_"tari_manufactortype") //进口标志
				
				s result=##class(web.DHCBL.CT.DHCTarItem).SaveEntity(dataeobj)	
				if (result["success:true")||(result["success:'true'")||(result["'success':'true'")
				{
					s TARIRowId=##class(web.DHCBL.BDP.FunLib).GetResultRowId(result)
					//保存医院关联
					d ##class(web.DHCBL.BDP.BDPMappingHOSP).SaveHOSP("DHC_TarItem",TARIRowId,LinkHospId)
					
					s dataeobj.TARIRowId=TARIRowId

					k dataeobj
					s result=""
					s dataeobj=##class(web.Entity.CT.DHCOrderLinkTar).%New()
					s dataeobj.OLTARCIMDR=ARCIMRowId
					s dataeobj.OLTTariffDR=TARIRowId
					s dataeobj.OLTQty=..GetFieldValue(InputStream,"/Request/Body/"_Tags_"/"_Tag_"["_counti_"]/"_"olt_qty")  //数量
					if (dataeobj.OLTQty="")
					{
						s returncode=-1
						s info="关联数量olt_qty不能为空"
						g errorret
					}
					s dataeobj.OLTBascPriceFlag=..GetFieldValue(InputStream,"/Request/Body/"_Tags_"/"_Tag_"["_counti_"]/"_"olt_basc_price_flag")  //基价模式
					s dataeobj.OLTBillOnceFlag=..GetFieldValue(InputStream,"/Request/Body/"_Tags_"/"_Tag_"["_counti_"]/"_"olt_bill_once_flag")  //多部位计价一次
					s dataeobj.OLTStartDate=..GetFieldValue(InputStream,"/Request/Body/"_Tags_"/"_Tag_"["_counti_"]/"_"olt_start_date")  //关联开始日期
					s dataeobj.OLTEndDate=..GetFieldValue(InputStream,"/Request/Body/"_Tags_"/"_Tag_"["_counti_"]/"_"olt_end_date")  //关联结束日期
					if type="A"
					{
						s result=##class(web.DHCBL.CT.DHCOrderLinkTar).SaveEntity(dataeobj,1)  //新增医嘱项与收费项对照?确认入参
					}
					else  //修改
					{
						 //20220902如果不存在关联,U类型时将医嘱项和收费项关联上。
						if ($d(^DHCOLT(0,"ARTTA",dataeobj.OLTARCIMDR,dataeobj.OLTTariffDR))=0)
						{
							s result=##class(web.DHCBL.CT.DHCOrderLinkTar).SaveEntity(dataeobj,1)  //新增医嘱项与收费项对照?确认入参
						}
						else
						{
							
							s OLTRowId=""
							s OLTStartDate=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(dataeobj.OLTStartDate)
							s:OLTStartDate'="" OLTRowId=$o(^DHCOLT(0,"ARTTA",dataeobj.OLTARCIMDR,dataeobj.OLTTariffDR,OLTStartDate,0))
							if OLTRowId=""
							{
								s result="没找到对应的医嘱项与收费项对照关系"
							}
							else
							{
								s dataeobj.OLTRowId=OLTRowId
								s result=##class(web.DHCBL.CT.DHCOrderLinkTar).SaveEntity(dataeobj)  //修改医嘱项与收费项对照
							}
						}
						
					}
					if (result["success:true")||(result["success:'true'")||(result["'success':'true'")
					{
						s status=0
						s msg="医嘱项、收费项、医嘱项与收费项关联保存成功"
						s Rtn="<Result><arcim_code>"_arcimcode_"</arcim_code><arcim_row_id>"_ARCIMRowId_"</arcim_row_id><tari_code>"_taricode_"</tari_code><tari_row_id>"_TARIRowId_"</tari_row_id><status>"_status_"</status><msg>"_msg_"</msg></Result>"
						if ResultsRtn="" s ResultsRtn=Rtn
						else  s ResultsRtn=ResultsRtn_Rtn
					}
					else
					{
						s returncode=-1
						s info="推送失败"
						s status=-1
						s msg="医嘱项与收费项对照保存失败"_result
						s Rtn="<Result><arcim_code>"_arcimcode_"</arcim_code><tari_code>"_taricode_"</tari_code><status>"_status_"</status><msg>"_msg_"</msg></Result>"
						if ResultsRtn="" s ResultsRtn=Rtn
						else  s ResultsRtn=ResultsRtn_Rtn
					}
					
				}
				else
				{
					s returncode=-1
					s info="推送失败"
					s status=-1
					s msg="收费项保存失败"_result
					s Rtn="<Result><tari_code>"_taricode_"</tari_code><status>"_status_"</status><msg>"_info_"</msg></Result>"
					if ResultsRtn="" s ResultsRtn=Rtn
					else  s ResultsRtn=ResultsRtn_Rtn
				}
				
			}
			else
			{
				s returncode=-1
				s info="推送失败"
				s status=-1
				s msg="医嘱项保存失败"_result
				s Rtn="<Result><arcim_code>"_arcimcode_"</arcim_code><status>"_status_"</status><msg>"_msg_"</msg></Result>"
				if ResultsRtn="" s ResultsRtn=Rtn
				else  s ResultsRtn=ResultsRtn_Rtn
			}
		}
	}
	s:info="" info="保存成功"
	s TotalRtn="<Response><return_code>"_returncode_"</return_code><return_desc>"_info_"</return_desc><Body><Results>"_ResultsRtn_"</Results></Body></Response>"
	
	q TotalRtn
errorret
	s TotalRtn="<Response><return_code>"_returncode_"</return_code><return_desc>"_info_"</return_desc><Body><Results>"_ResultsRtn_"</Results></Body></Response>"
	q TotalRtn
}

/// His新增修改手术信息，调用医师资质接口，同步到医师资质系统
/// 基础数据平台-likefan
/// 2021-07-05
/// w ##class(web.DHCBL.BDP.BDPInterface).saveOperation("1","A")
ClassMethod saveOperation(operid As %String, AUflag As %String) As %String
{
	q:operid="" "-1^input error"
	q:'((AUflag="A")||(AUflag="U")||(AUflag="D")) "-1^input error"
	s inputstr=""
	s (operCode,operName,operLevel,startdate,enddate,operICD10,operType)=""
	
	s obj = ##class(User.ORCOperation).%OpenId(operid)
	q:'$IsObject(obj) "-1^data error"
	s operCode=obj.OPERCode		//手术代码
	s operName=obj.OPERDesc		//手术名称
	s:obj.OPERDefaultCategoryDR'="" operLevel=obj.OPERDefaultCategoryDR.%Id()		//手术分级dr
	s:operLevel'="" operLevel=$p($g(^ORC("CATEG",operLevel)),"^",1)		//手术分级1/2/3/4
	s:obj.OPERDateActiveFrom'="" startdate=$zd(obj.OPERDateActiveFrom,3)	//开始日期
	s:obj.OPERActiveDateTo'="" enddate=$zd(obj.OPERActiveDateTo,3)			//结束日期
	s operICD10=obj.OPERICD10		//手术icd
	// 手术扩展表
	s objextend=##class(User.ORCOperationExtend).%OpenId(operid)
	s operType=objextend.OPERType		//手术操作类别
	
	d obj.%Close()
	d objextend.%Close()
	k obj
	k objextend
	
	//s inputstr=operid_"^"_operCode_"^"_operName_"^"_operLevel_"^"_startdate_"^"_enddate_"^"_AUflag_"^"_operICD10_"^"_operType
	s inputstr="<Request><Header><SourceSystem>SYS0008</SourceSystem><MessageID></MessageID></Header><Body><SynOperDictRt>"
	s inputstr=inputstr_"<operId>"_operid_"</operId>"
	s inputstr=inputstr_"<operName>"_operName_"</operName>"
	s inputstr=inputstr_"<operLever>"_operLevel_"</operLever>"
	s inputstr=inputstr_"<status>"_AUflag_"</status>"
	s inputstr=inputstr_"<startDate>"_startdate_"</startDate>"
	s inputstr=inputstr_"<endDate>"_enddate_"</endDate>"
	s inputstr=inputstr_"<operIcd>"_operICD10_"</operIcd>"
	s inputstr=inputstr_"<operType>"_operType_"</operType>"
	s inputstr=inputstr_"<operCode>"_operCode_"</operCode>"
	s inputstr=inputstr_"</SynOperDictRt></Body></Request>"
	q inputstr
	
	//s reSync=##class(OperationSyncImplService.OperationSyncImplPort).%New().saveOperation(inputstr)	//调用平台组接口
	//q reSync
}

/// SavePermission方法测试
/// likefan
/// w ##class(web.DHCBL.BDP.BDPInterface).Test1("","")
ClassMethod Test1(code, flag) As %String
{
	set stream=##class(%Stream.GlobalCharacter).%New()
	s input="<Request><Header><MessageID/><SourceSystem></SourceSystem></Header><Body><SynDrugRt><phyNum>YS01</phyNum><permissionsNum>"_code_"</permissionsNum><Flag>"_flag_"</Flag><hospitalcode></hospitalcode></SynDrugRt></Body></Request>"
	d stream.Write(input) 
	set responseStream=..SavePermission(stream)
	q responseStream
	q ""
}

/// 基础数据平台-likefan
/// 2021-07-06
/// 医师资质对医师的精神麻毒处方权限等进行授权和禁止状态变更时，把数据同步给基础数据平台
/// w ##class(web.DHCBL.BDP.BDPInterface).SavePermission(^templkfinterface("inputStream"))
ClassMethod SavePermission(InputStream As %Stream.GlobalCharacter) As %String
{
	s result=""
	k ^TEMPPermission("inputdata")
	s result="<Response><Header><SourceSystem></SourceSystem><MessageID></MessageID></Header><Body>"
	
	set tSC=##class(%XML.XPATH.Document).CreateFromStream(InputStream,.tDocument)
	if $$$ISERR(tSC)
	{
		q "xml格式错误"
		s result=result_"<ResultCode>-1</ResultCode><ResultContent>xml格式错误</ResultContent>"
		s result=result_"</Body></Response>"
		q result
	}
	
	s ErrorMsg=""
	TS
	/////////////////循环///////////////////////
	s tSC=tDocument.EvaluateExpression("/Request/Body/UserDrugRt","UserCode",.tRes)
	s Cnt=tRes.Count()
	For tI=1:1:Cnt
	{
		Set tResult=tRes.GetAt(tI)  
		
		set UserCode=""  //医师工号
		s tSC2=tDocument.EvaluateExpression("/Request/Body/UserDrugRt/UserCode","text()",.tResult)
		if ($$$ISOK(tSC2)&&(tResult.GetAt(tI)'="")){
			set fieldValue=tResult.GetAt(tI).Value
			set UserCode=$tr(fieldValue,$c(0),"")
		}
		
		set ConDrugCode=""  //权限编码
		s tSC2=tDocument.EvaluateExpression("/Request/Body/UserDrugRt/ConDrugCode","text()",.tResult)
		if ($$$ISOK(tSC2)&&(tResult.GetAt(tI)'="")){
			set fieldValue=tResult.GetAt(tI).Value
			set ConDrugCode=$tr(fieldValue,$c(0),"")
		}
		
		set Flag=""  //授权/删除
		s tSC2=tDocument.EvaluateExpression("/Request/Body/UserDrugRt/Flag","text()",.tResult)
		if ($$$ISOK(tSC2)&&(tResult.GetAt(tI)'="")){
			set fieldValue=tResult.GetAt(tI).Value
			set Flag=$tr(fieldValue,$c(0),"")
		}
		
		s ^TEMPPermission("inputdata",tI)=UserCode_"^"_ConDrugCode_"^"_Flag
		
		if (UserCode="")||(ConDrugCode="")||(Flag="")
		{
			s ErrorMsg="入参不能为空"
			q
		}
		s CTPCPRowId1=$o(^CTPCP(0,"Code",$$ALPHAUP^SSUTIL4(UserCode),0))
		if (CTPCPRowId1="")
		{
			s ErrorMsg="未找到医师："_UserCode
			q
		}
		s PHCPORowId=$o(^PHCPO(0,"Code",$$ALPHAUP^SSUTIL4(ConDrugCode),0))
		if (PHCPORowId="")
		{
			s ErrorMsg="权限编码错误："_ConDrugCode
			q
		}
		if (Flag'="Y")&&(Flag'="N")
		{
			s ErrorMsg="状态代码错误："_Flag
			q
		}
		
		if (Flag="Y")
		{
	    	s eobj=##class(web.Entity.CT.CTCareProvPHCPoison).%New()
			s eobj.CPPParRef=CTPCPRowId1
			s eobj.CPPPHCPoisonDR=PHCPORowId
		    s re=##class(web.DHCBL.CT.CTCareProvPHCPoison).SaveEntity(eobj)
		}
		else
		{
	    	s CPPRowId=""
	    	s CPPChildsub=0
			for
			{
				s CPPChildsub=$o(^CTPCP(CTPCPRowId1,"CPP",CPPChildsub)) q:CPPChildsub=""
				s CPPPHCPoisonDR=$p($g(^CTPCP(CTPCPRowId1,"CPP",CPPChildsub)),"^",1)
				if (CPPPHCPoisonDR=PHCPORowId) 
				{
					s CPPRowId=CTPCPRowId1_"||"_CPPChildsub
					q
				}
			}
			s:CPPRowId'="" re=##class(web.DHCBL.CT.CTCareProvPHCPoison).DeleteData(CPPRowId)
			s:CPPRowId="" re="success:'true'"
		}
		if '((re["success:'true'")||(re["该记录已经存在"))
		{
			s ErrorMsg="保存失败："_re
			q
		}
	}
	
	if (ErrorMsg'="")
	{
		TRO
		s result=result_"<ResultCode>-1</ResultCode><ResultContent>"_ErrorMsg_"</ResultContent>"
	}
	else
	{
		TC
		s result=result_"<ResultCode>0</ResultCode><ResultContent>成功</ResultContent>"
	}
	
	s result=result_"</Body></Response>"
	q result
}

/// SavePrescriptSet方法测试
/// likefan
/// w ##class(web.DHCBL.BDP.BDPInterface).Test2("","","")
ClassMethod Test2(code, flag, hosp) As %String
{
	set stream=##class(%Stream.GlobalCharacter).%New()
	s input="<Request><Header><MessageID/><SourceSystem></SourceSystem></Header><Body><SynPresRt><phyNum>YS01</phyNum><permissionsNum>"_code_"</permissionsNum><Flag>"_flag_"</Flag><hospitalcode>"_hosp_"</hospitalcode></SynPresRt></Body></Request>"
	d stream.Write(input) 
	set responseStream=..SavePrescriptSet(stream)
	q responseStream
	q ""
}

/// 基础数据平台-likefan
/// 2021-07-06
/// 医师资质对医师的处方权进行授权和禁止状态变更时，把数据同步给基础数据平台
/// w ##class(web.DHCBL.BDP.BDPInterface).SavePrescriptSet(^templkfinterface("inputStream"))
ClassMethod SavePrescriptSet(InputStream As %Stream.GlobalCharacter) As %String
{
	s result=""
	k ^templkfinterface("inputdata")
	set tSC=##class(%XML.XPATH.Document).CreateFromStream(InputStream,.tDocument)
	s result="<Response><Header><SourceSystem></SourceSystem><MessageID></MessageID></Header><Body>"
	set phyNum=""  //医师工号
	s tSC=tDocument.EvaluateExpression("/Request/Body/SynPresRt/phyNum","text()",.tRes)
	if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){
		set fieldValue=tRes.GetAt(1).Value
		set phyNum=$tr(fieldValue,$c(0),"")
	}
	
	set permissionsNum=""  //权限编码
	s tSC=tDocument.EvaluateExpression("/Request/Body/SynPresRt/permissionsNum","text()",.tRes)
	if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){
		set fieldValue=tRes.GetAt(1).Value
		set permissionsNum=$tr(fieldValue,$c(0),"")
	}
	
	set Flag=""  //授权/删除
	s tSC=tDocument.EvaluateExpression("/Request/Body/SynPresRt/Flag","text()",.tRes)
	if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){
		set fieldValue=tRes.GetAt(1).Value
		set Flag=$tr(fieldValue,$c(0),"")
	}
	
	set hospitalcode=""  //院区编码
	s tSC=tDocument.EvaluateExpression("/Request/Body/SynPresRt/hospitalcode","text()",.tRes)
	if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){
		set fieldValue=tRes.GetAt(1).Value
		set hospitalcode=$tr(fieldValue,$c(0),"")
	}
	
	s ^templkfinterface("inputdata")=phyNum_"^"_permissionsNum_"^"_Flag_"^"_hospitalcode
	
	if (phyNum="")||(permissionsNum="")||(Flag="")||(hospitalcode="")
	{
		s result=result_"<ResultCode>-1</ResultCode><ResultContent>入参不能为空</ResultContent>"
		s result=result_"</Body></Response>"
		q result
	}
	s CTPCPRowId1=$o(^CTPCP(0,"Code",$$ALPHAUP^SSUTIL4(phyNum),0))
	if (CTPCPRowId1="")
	{
		s result=result_"<ResultCode>-1</ResultCode><ResultContent>未找到医师</ResultContent>"
		s result=result_"</Body></Response>"
		q result
	}
	s HospId=$o(^CT("HOSP",0,"Code",$$ALPHAUP^SSUTIL4(hospitalcode),0))
	if (HospId="")
	{
		s result=result_"<ResultCode>-1</ResultCode><ResultContent>院区编码错误</ResultContent>"
		s result=result_"</Body></Response>"
		q result
	}
	s PSRowId=..GetPrescriptIdByCode(permissionsNum,HospId)	//根据处方权代码获取处方权id
	if (PSRowId="")
	{
		s result=result_"<ResultCode>-1</ResultCode><ResultContent>权限编码错误</ResultContent>"
		s result=result_"</Body></Response>"
		q result
	}
	if (Flag'="Y")&&(Flag'="N")
	{
		s result=result_"<ResultCode>-1</ResultCode><ResultContent>状态代码错误</ResultContent>"
		s result=result_"</Body></Response>"
		q result
	}
	
	
	if (Flag="Y")
	{
    	s eobj=##class(web.Entity.CT.CTCareProvPrescriptSet).%New()
		s eobj.CPPSParRef=CTPCPRowId1
		s eobj.CPPSPrescriptSetDR=PSRowId
	    s re=##class(web.DHCBL.CT.CTCareProvPrescriptSet).SaveEntity(eobj)
	}
	else
	{
    	s CPPSRowId=""
    	s CPPSChildsub=0
		for
		{
			s CPPSChildsub=$o(^CTPCP(CTPCPRowId1,"CPPS",CPPSChildsub)) q:CPPSChildsub=""
			s CPPSPrescriptSetDR=$p($g(^CTPCP(CTPCPRowId1,"CPPS",CPPSChildsub)),"^",1)
			if (CPPSPrescriptSetDR=PSRowId)
			{
				s CPPSRowId=CTPCPRowId1_"||"_CPPSChildsub
				q
			}
		}
		s:CPPSRowId'="" re=##class(web.DHCBL.CT.CTCareProvPrescriptSet).DeleteData(CPPSRowId)
		s:CPPSRowId="" re="success:'true'"
	}
	
	if (re["success:'true'")||(re["该记录已经存在")
	{
		s result=result_"<ResultCode>0</ResultCode><ResultContent>成功</ResultContent>"
	}
	else
	{
		s result=result_"<ResultCode>-1</ResultCode><ResultContent>同步失败："_re_"</ResultContent>"
	}
	s result=result_"</Body></Response>"
	q result
}

/// Creator: likefan
/// CreatDate:2021-01-06
/// Description:根据处方权代码返回处方权id
/// input: 处方权代码，医院id
/// Return:处方权id
/// Other: w ##class(web.DHCBL.BDP.BDPInterface).GetPrescriptIdByCode("",2)
ClassMethod GetPrescriptIdByCode(code As %String, hospid As %String = "") As %String
{
	q:code="" ""
	s resultid=""
	s PSRowId=0
	for
	{
		s PSRowId=$o(^DHCPRESCRIPTSET(PSRowId)) q:PSRowId=""
		s PSCode=$p($g(^DHCPRESCRIPTSET(PSRowId)),"^",1)	//代码
		s PSDesc=$p($g(^DHCPRESCRIPTSET(PSRowId)),"^",2)	//描述
		s PSType=$p($g(^DHCPRESCRIPTSET(PSRowId)),"^",3)	//类型
		s PSActive=$p($g(^DHCPRESCRIPTSET(PSRowId)),"^",5)	//是否有效
		s PSHospDr=$p($g(^DHCPRESCRIPTSET(PSRowId)),"^",7)	//医院
		
		if (PSCode=code)&&(PSActive'="N")
		{
			if (hospid="")
			{
				s resultid=PSRowId
				q
			}
			else
			{
				if (PSHospDr=hospid)
				{
					s resultid=PSRowId
					q
				}
			}
		}
	}
	q resultid
}

/// Description：通过代码和医院id获取rowid 
/// Creator：陈莹
/// CreatDate: 2021-07-20
/// Input：代码，医院id
/// Return:RowId 
/// debug: w ##class(web.DHCBL.BDP.BDPInterface).GetRowIdByCode("ARC_ItmMast",Code,LinkHospId)
ClassMethod GetRowIdByCode(TableName As %String, Code As %String, HOSPID As %String = "") As %String
{
	s Rowid=""
	q:Code="" ""
	s Rowid=##class(web.DHCBL.BDP.BDPDataImport).GetRowIdByCode(TableName,Code,HOSPID)
	 /*if (TableName="DHC_TarItem")
	    {
		    s Rowid=$o(^DHCTARI(0,"Code",Code,0))
	    }
	    elseif (TableName="ARC_ItmMast")
	    {
		    s sub=0
			for
			{
				s sub=$O(^ARCIM(0,"Code",$$ALPHAUP^SSUTIL4(Code),sub)) q:sub=""
				s version=0
				for
				{
					s version=$O(^ARCIM(0,"Code",$$ALPHAUP^SSUTIL4(Code),sub,version)) q:version=""
					if ($p($g(^ARCIM(sub,version,1)),"^",1)=Code)
					{
						s Rowid=sub_"||"_version
					}
				}
			}
	    }*/
    q Rowid
}

/// Description：通过名称和医院id获取rowid 
/// Creator：陈莹
/// CreatDate: 2021-07-20
/// Input：名称，医院id
/// Return:RowId 
/// debug: w ##class(web.DHCBL.BDP.BDPInterface).GetRowIdByDesc("ARC_ItmMast",Desc,LinkHospId)
ClassMethod GetRowIdByDesc(TableName As %String, Desc As %String, HOSPID As %String = "") As %String
{
	s Rowid=""
	q:Desc="" ""
	s Rowid=##class(web.DHCBL.BDP.BDPDataImport).GetRowIdByDesc(TableName,Desc,HOSPID)
    q Rowid
}

/// 调试专用
/// w ##class(web.DHCBL.BDP.BDPInterface).Test()
ClassMethod Test()
{
    set stream=##class(%Stream.GlobalCharacter).%New()
    //do stream.Write("<Request><Header><type>A</type><client>qt</client></Header><Body><ArcItemAndTarItems><ArcItemAndTarItem><org_code>SCSDSRMYY</org_code><org_name>四川省第四人民医院</org_name><tari_code>101100039CY</tari_code><tari_desc>内镜用注射针(NET2522-C4)CY</tari_desc><tari_uom>根</tari_uom><tari_bill_dr>材料费</tari_bill_dr><tari_sub_cate>材料费</tari_sub_cate><tari_acct_cate>高值耗材收入</tari_acct_cate><tari_outpat_cate>材料费</tari_outpat_cate><tari_emc_cate>材料费</tari_emc_cate><tari_active_flag>Y</tari_active_flag><tari_start_date>2021-08-03</tari_start_date><tari_inpat_cate>材料费</tari_inpat_cate><tari_mc_new></tari_mc_new><arcim_orcat_dr>材料</arcim_orcat_dr><arcim_itemcat_dr>高值耗材</arcim_itemcat_dr><arcim_code>101100039CY</arcim_code><arcim_desc>内镜用注射针(NET2522-C4)CY</arcim_desc><arcim_bill_dr>材料费</arcim_bill_dr><arcim_bill_sub_dr>材料费</arcim_bill_sub_dr><arcim_bill_uomdr>根</arcim_bill_uomdr><arcim_order_onits_own>Y</arcim_order_onits_own><arcim_allow_order_wostock_check>Y</arcim_allow_order_wostock_check><arcim_start_date>2021-08-03</arcim_start_date><arcim_end_date>2021-08-03</arcim_end_date><olt_qty>1</olt_qty><olt_start_date>2021-08-03</olt_start_date></ArcItemAndTarItem></ArcItemAndTarItems></Body></Request>")
    //set ret=##class(web.DHCBL.BDP.BDPInterface).SaveArcItemAndTarItem(stream)
    //do stream.Write("<Request><Header><type>A</type><client>qt</client></Header><Body><TarItemPrices><TarItemPrice><org_code>SCSDSRMYY</org_code><org_name>四川省第四人民医院</org_name><tari_code>101100039CY</tari_code><tp_price>580.000</tp_price><tp_patins_type>自费</tp_patins_type><tp_start_date>2021-08-03</tp_start_date><tp_updateuser>012</tp_updateuser></TarItemPrice></TarItemPrices></Body></Request>")
    //set ret=##class(web.DHCBL.BDP.BDPInterface).SaveTarItemPrice(stream)
    do stream.Write("<Request><Header><type>A</type><client></client></Header><Body><ArcItemAndTarItems><ArcItemAndTarItem><org_code>DHSZHYYZY</org_code><org_name>香港大学深圳医院</org_name><tari_code>101100039</tari_code><tari_desc>内镜用注射针(NET2522-C4)</tari_desc><tari_uom>根</tari_uom><tari_bill_dr>材料费</tari_bill_dr><tari_sub_cate>材料费</tari_sub_cate><tari_acct_cate>材料费</tari_acct_cate><tari_outpat_cate>材料费</tari_outpat_cate><tari_emc_cate>材料费</tari_emc_cate><tari_mr_cate>材料费</tari_mr_cate><tari_special_flag>N</tari_special_flag><tari_active_flag>Y</tari_active_flag><tari_start_date>2022-05-13</tari_start_date><tari_end_date></tari_end_date><tari_external_code></tari_external_code><tari_inpat_cate>材料费</tari_inpat_cate><tari_insu_name></tari_insu_name><tari_eng_name></tari_eng_name><tari_charge_basis></tari_charge_basis><tari_item_cat_dr></tari_item_cat_dr><tari_mc_new>材料费</tari_mc_new><tari_connote></tari_connote><tari_opercategory_dr></tari_opercategory_dr><tari_exclude></tari_exclude><arcim_orcat_dr>材料</arcim_orcat_dr><arcim_itemcat_dr>高值耗材</arcim_itemcat_dr><arcim_code>101100039</arcim_code><arcim_desc>内镜用注射针(NET2522-C4)</arcim_desc><arcim_bill_dr>材料费</arcim_bill_dr><arcim_bill_sub_dr>材料费</arcim_bill_sub_dr><arcim_bill_uomdr>根</arcim_bill_uomdr><arcim_order_onits_own>Y</arcim_order_onits_own><arcim_allow_order_wostock_check>N</arcim_allow_order_wostock_check><arcim_sensitive></arcim_sensitive><arcim_oe_message></arcim_oe_message><arcim_service_group_dr></arcim_service_group_dr><arcim_serv_material>M</arcim_serv_material><arcim_der_fee_rules_dr></arcim_der_fee_rules_dr><arcim_chg_order_per_hour></arcim_chg_order_per_hour><arcim_deceased_patients_only></arcim_deceased_patients_only><arcim_display_cumulative></arcim_display_cumulative><arcim_use_odbc_forword></arcim_use_odbc_forword><arcim_restrict_em></arcim_restrict_em><arcim_restrict_ip></arcim_restrict_ip><arcim_restrict_op></arcim_restrict_op><arcim_restrict_hp></arcim_restrict_hp><arcim_sensitive_order></arcim_sensitive_order><arcim_abbrev></arcim_abbrev><arcim_start_date>2022-05-13</arcim_start_date><arcim_end_date></arcim_end_date><olt_qty>1</olt_qty><olt_basc_price_flag>N</olt_basc_price_flag><olt_bill_once_flag>N</olt_bill_once_flag><olt_start_date>2022-05-13</olt_start_date><olt_end_date></olt_end_date></ArcItemAndTarItem></ArcItemAndTarItems></Body></Request>")
    set ret=##class(web.DHCBL.BDP.BDPInterface).SaveArcItemAndTarItem(stream)
    //do stream.Write("<Request><Header><type>A</type><client></client></Header><Body><TarItemPrices><TarItemPrice><org_code>DHSZHYYZY</org_code><org_name>香港大学深圳医院</org_name><tari_code>101100039</tari_code><tari_desc>内镜用注射针(NET2522-C4)</tari_desc><tp_price>510.00</tp_price><tp_patins_type>自费</tp_patins_type><tp_alter_price1></tp_alter_price1><tp_alter_price2></tp_alter_price2><tp_start_date>2022-07-30</tp_start_date><tp_end_date></tp_end_date><tp_updateuser>10030</tp_updateuser></TarItemPrice></TarItemPrices></Body></Request>")
    //set ret=##class(web.DHCBL.BDP.BDPInterface).SaveTarItemPrice(stream)
    q ret
}

/// Creator：陈莹
/// CreatDate: 2020-05-14
/// Description：医嘱项信息保存
/// Input：数据,tablename:第三方的表名
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// w ##class(web.DHCBL.BDP.BDPInterface).SaveArcItem(stream)
ClassMethod SaveArcItem(InputStream As %Stream.GlobalCharacter) As %String
{
	s tSC=##class(%XML.XPATH.Document).CreateFromStream(InputStream,.tDocument)
	s Tags="ArcItems",Tag="ArcItem"   //医嘱项
	s returncode=0,ResultsRtn="",info=""  //,Rtn=""
	s total= ..GetDataCount(InputStream,"/Request/Body/"_Tags,Tag)  //获取标签的个数
	if (total=0)||(total="")
	{
		s returncode=-1
		s info="数量为空"
		if ResultsRtn="" s ResultsRtn=info
		else  s ResultsRtn=ResultsRtn_info
	}
	else
	{
		s type=..GetFieldValue(InputStream,"/Request/Header/type")
		for counti=1:1:total	
		{
			k dataeobj
			s dataeobj=##class(web.Entity.CT.ARCItmMast).%New()
			//医院RowId
			s LinkHospId=..GetFieldValue(InputStream,"/Request/Body/"_Tags_"/"_Tag_"["_counti_"]/"_"org_code")  //医院代码	
			s:LinkHospId'="" LinkHospId=$o(^CT("HOSP",0,"Code",$$ALPHAUP^SSUTIL4(LinkHospId),0))
			///取对应的默认医院
			s LinkHospId= ##class(web.DHCBL.BDP.BDPMappingHOSP).GetDefHospIdByTableName("ARC_ItmMast",LinkHospId,+$h)
			
		    if (LinkHospId="")||(LinkHospId'>0)
			{
				s returncode=-1
				s info="医院ID为空"
				g errorret
			}
			s dataeobj.LinkHospId=LinkHospId

			s arcimcode=..GetFieldValue(InputStream,"/Request/Body/"_Tags_"/"_Tag_"["_counti_"]/"_"arcim_code") //医嘱代码
			s dataeobj.ARCIMCode=arcimcode
			if dataeobj.ARCIMCode=""
			{
				s returncode=-1
				s info="医嘱项代码为空"
				g errorret
			}
			s dataeobj.ARCIMRowId=##class(web.DHCBL.BDP.BDPDataImport).GetRowIdByCode("ARC_ItmMast",arcimcode,LinkHospId)
			
			
			s dataeobj.ARCIMDesc=..GetFieldValue(InputStream,"/Request/Body/"_Tags_"/"_Tag_"["_counti_"]/"_"arcim_desc") //医嘱描述
			s dataeobj.ARCIMBillingUOMDR=..GetFieldValue(InputStream,"/Request/Body/"_Tags_"/"_Tag_"["_counti_"]/"_"arcim_bill_uomdr") //账单单位
			s:dataeobj.ARCIMBillingUOMDR'="" dataeobj.ARCIMBillingUOMDR=$o(^CT("UOM",0,"Desc",$$UPPER^SSUTIL4(dataeobj.ARCIMBillingUOMDR),0))
			
			s dataeobj.ARCIMItemCatDR=..GetFieldValue(InputStream,"/Request/Body/"_Tags_"/"_Tag_"["_counti_"]/"_"arcim_itemcat_dr") //医嘱子类代码
			s:dataeobj.ARCIMItemCatDR'="" dataeobj.ARCIMItemCatDR=$o(^ARC("IC",0,"Code",$$ALPHAUP^SSUTIL4(dataeobj.ARCIMItemCatDR),0))
				
			
			//药品
			s dataeobj.ARCIMPHCDFDR=..GetFieldValue(InputStream,"/Request/Body/"_Tags_"/"_Tag_"["_counti_"]/"_"phcd_code") //药物
			if dataeobj.ARCIMPHCDFDR'=""
			{
				s PHCDRowId=$o(^PHCD(0,"Code",$$ALPHAUP^SSUTIL4(dataeobj.ARCIMPHCDFDR),0))
				if PHCDRowId'="" s dataeobj.ARCIMPHCDFDR=PHCDRowId_"||1"
				
			}
			
			s dataeobj.ARCIMBillSubDR=..GetFieldValue(InputStream,"/Request/Body/"_Tags_"/"_Tag_"["_counti_"]/"_"arcim_bill_sub_dr") //账单子组
			if dataeobj.ARCIMBillSubDR'=""
			{
				s parref=$o(^ARCBG("SG_Desc",$$ALPHAUP^SSUTIL4(dataeobj.ARCIMBillSubDR),0))
				if parref'=""
				{
					s sub=$o(^ARCBG("SG_Desc",$$ALPHAUP^SSUTIL4(dataeobj.ARCIMBillSubDR),parref,0))
					s dataeobj.ARCIMBillSubDR=parref_"||"_sub
				}
			}
			s dataeobj.ARCIMOrderOnItsOwn=..GetFieldValue(InputStream,"/Request/Body/"_Tags_"/"_Tag_"["_counti_"]/"_"arcim_order_onits_own") //独立医嘱
			s dataeobj.ARCIMAllowOrderWOStockCheck=..GetFieldValue(InputStream,"/Request/Body/"_Tags_"/"_Tag_"["_counti_"]/"_"arcim_allow_order_wostock_check") //无库存医嘱
			s dataeobj.ARCIMSensitive=..GetFieldValue(InputStream,"/Request/Body/"_Tags_"/"_Tag_"["_counti_"]/"_"arcim_sensitive") //加急医嘱
			s dataeobj.ARCIMOEMessage=..GetFieldValue(InputStream,"/Request/Body/"_Tags_"/"_Tag_"["_counti_"]/"_"arcim_oe_message") //医嘱备注
			s dataeobj.ARCIMServiceGroupDR=..GetFieldValue(InputStream,"/Request/Body/"_Tags_"/"_Tag_"["_counti_"]/"_"arcim_service_group_dr") //服务组
			s:dataeobj.ARCIMServiceGroupDR'="" dataeobj.ARCIMServiceGroupDR=$o(^RBC("SG",0,"Desc",$$ALPHAUP^SSUTIL4(dataeobj.ARCIMServiceGroupDR),0))
			
			s dataeobj.ARCIMDerFeeRulesDR=..GetFieldValue(InputStream,"/Request/Body/"_Tags_"/"_Tag_"["_counti_"]/"_"arcim_der_fee_rules_dr") //费用标准
			s dataeobj.ARCIMChgOrderPerHour=..GetFieldValue(InputStream,"/Request/Body/"_Tags_"/"_Tag_"["_counti_"]/"_"arcim_chg_order_per_hour") //小时医嘱
			s dataeobj.ARCIMDeceasedPatientsOnly=..GetFieldValue(InputStream,"/Request/Body/"_Tags_"/"_Tag_"["_counti_"]/"_"arcim_deceased_patients_only") //限制为已故病人用
			s dataeobj.ARCIMDisplayCumulative=..GetFieldValue(InputStream,"/Request/Body/"_Tags_"/"_Tag_"["_counti_"]/"_"arcim_display_cumulative") //显示累计
			s dataeobj.ARCIMUseODBCforWord=..GetFieldValue(InputStream,"/Request/Body/"_Tags_"/"_Tag_"["_counti_"]/"_"arcim_use_odbc_forword") //使用ODBC模板
			s dataeobj.ARCIMRestrictEM=..GetFieldValue(InputStream,"/Request/Body/"_Tags_"/"_Tag_"["_counti_"]/"_"arcim_restrict_em") //限制为急诊病人用
			s dataeobj.ARCIMRestrictIP=..GetFieldValue(InputStream,"/Request/Body/"_Tags_"/"_Tag_"["_counti_"]/"_"arcim_restrict_ip") //限制为住院病人用
			s dataeobj.ARCIMRestrictOP=..GetFieldValue(InputStream,"/Request/Body/"_Tags_"/"_Tag_"["_counti_"]/"_"arcim_restrict_op") //限制为门诊病人用
			s dataeobj.ARCIMRestrictHP=..GetFieldValue(InputStream,"/Request/Body/"_Tags_"/"_Tag_"["_counti_"]/"_"arcim_restrict_hp") //限制为体检病人用
			s dataeobj.ARCIMSensitiveOrder=..GetFieldValue(InputStream,"/Request/Body/"_Tags_"/"_Tag_"["_counti_"]/"_"arcim_sensitive_order") //敏感医嘱
			s dataeobj.ARCIMAbbrev=..GetFieldValue(InputStream,"/Request/Body/"_Tags_"/"_Tag_"["_counti_"]/"_"arcim_abbrev") //医嘱缩写
			s dataeobj.ARCIMEffDate=..GetFieldValue(InputStream,"/Request/Body/"_Tags_"/"_Tag_"["_counti_"]/"_"arcim_start_date") //数据开始日期
			s dataeobj.ARCIMEffDateTo=..GetFieldValue(InputStream,"/Request/Body/"_Tags_"/"_Tag_"["_counti_"]/"_"arcim_end_date") //数据结束日期
			s dataeobj.ARCIMScanCodeBilling=..GetFieldValue(InputStream,"/Request/Body/"_Tags_"/"_Tag_"["_counti_"]/"_"arcim_scancodebilling") //是否扫码计费 20220805
			
			
			s dataeobj.ARCIMServMaterial=..GetFieldValue(InputStream,"/Request/Body/"_Tags_"/"_Tag_"["_counti_"]/"_"arcim_servmaterial") //服务/材料
			s dataeobj.ARCIMServMaterial=$case(dataeobj.ARCIMServMaterial,"材料":"M","服务":"S","S":"S","M":"M",:"")
			s dataeobj.ARCIMText1=..GetFieldValue(InputStream,"/Request/Body/"_Tags_"/"_Tag_"["_counti_"]/"_"arcim_text1")
			s dataeobj.ARCIMText2=..GetFieldValue(InputStream,"/Request/Body/"_Tags_"/"_Tag_"["_counti_"]/"_"arcim_text2")
			s dataeobj.ARCIMText3=..GetFieldValue(InputStream,"/Request/Body/"_Tags_"/"_Tag_"["_counti_"]/"_"arcim_text3")
			s dataeobj.ARCIMText4=..GetFieldValue(InputStream,"/Request/Body/"_Tags_"/"_Tag_"["_counti_"]/"_"arcim_text4")
			s dataeobj.ARCIMText5=..GetFieldValue(InputStream,"/Request/Body/"_Tags_"/"_Tag_"["_counti_"]/"_"arcim_text5")
			s result=##class(web.DHCBL.CT.ARCItmMast).SaveEntity(dataeobj)	
			if (result["success:true")||(result["success:'true'")||(result["'success':'true'")
			{
				s ARCIMRowId=##class(web.DHCBL.BDP.FunLib).GetResultRowId(result)
				s dataeobj.ARCIMRowId=ARCIMRowId
				/*
				///新增时默认关联 2020-07-10 新增医嘱项时默认关联人民医院
				if (type="A")
				{
					k hospdataeobj
					s hospdataeobj=##class(web.Entity.CT.ARCItemHosp).%New()
					
					s hospdataeobj.HOSPParRef=ARCIMRowId
					s hospdataeobj.HOSPHospitalDR=LinkHospId
					if hospdataeobj.TPHospitalDR=""
					{
						s returncode=-1
						s info="找不到对应的医院id"
						g errorret
						q
					}
					else
					{
						s hospresult=##class(web.DHCBL.CT.ARCItemHosp).SaveEntity(hospdataeobj)
						if (hospresult["success:true")||(hospresult["success:'true'")||(hospresult["'success':'true'")
						{
							
						}
						else
						{
							s returncode=-1
							s info="推送失败"
							s status=-1
							s msg="医嘱项医院授权给人民医院失败"_hospresult
							s Rtn="<Result><arcim_code>"_arcimcode_"</arcim_code><status>"_status_"</status><msg>"_msg_"</msg></Result>"
							if ResultsRtn="" s ResultsRtn=Rtn
							else  s ResultsRtn=ResultsRtn_Rtn
							q
						}
					}	
				}*/
				s status=0
				s msg="保存成功"
				s Rtn="<Result><arcim_code>"_dataeobj.ARCIMCode_"</arcim_code><arcim_row_id>"_dataeobj.ARCIMRowId_"</arcim_row_id><status>"_status_"</status><msg>"_msg_"</msg></Result>"
				if ResultsRtn="" s ResultsRtn=Rtn
				else  s ResultsRtn=ResultsRtn_Rtn
				
				
			}
			else
			{
				s returncode=-1
				s info="推送失败"
				s status=-1
				s msg="保存失败"_result
				s Rtn="<Result><arcim_code>"_dataeobj.ARCIMCode_"</arcim_code><arcim_row_id>"_dataeobj.ARCIMRowId_"</arcim_row_id><status>"_status_"</status><msg>"_msg_"</msg></Result>"
				if ResultsRtn="" s ResultsRtn=Rtn
				else  s ResultsRtn=ResultsRtn_Rtn
			}
		}
	}
	s:info="" info="保存成功"
	s TotalRtn="<Response><return_code>"_returncode_"</return_code><return_desc>"_info_"</return_desc><Body><Results>"_ResultsRtn_"</Results></Body></Response>"
	
	q TotalRtn
errorret
	s TotalRtn="<Response><return_code>"_returncode_"</return_code><return_desc>"_info_"</return_desc><Body><Results>"_ResultsRtn_"</Results></Body></Response>"
	q TotalRtn
}

/// Creator：陈莹
/// CreatDate: 2020-05-14
/// Description：收费项目信息保存
/// Input：数据,tablename:第三方的表名
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// w ..SaveTarItem(stream)
ClassMethod SaveTarItem(InputStream As %Stream.GlobalCharacter) As %String
{
	s tSC=##class(%XML.XPATH.Document).CreateFromStream(InputStream,.tDocument)
	s Tags="TarItems",Tag="TarItem"   //收费项目
	s returncode=0,ResultsRtn="",info=""
	s total= ..GetDataCount(InputStream,"/Request/Body/"_Tags,Tag)  //获取TarItem标签的个数
	if (total=0)||(total="")
	{
		s returncode=-1
		s info="数量为空"
		if ResultsRtn="" s ResultsRtn=info
		else  s ResultsRtn=ResultsRtn_info
	}
	else
	{
		s type=..GetFieldValue(InputStream,"/Request/Header/type")
		for counti=1:1:total	
		{
			k dataeobj
			s dataeobj=##class(web.Entity.CT.DHCTarItem).%New()
			//医院RowId
			s LinkHospId=..GetFieldValue(InputStream,"/Request/Body/"_Tags_"/"_Tag_"["_counti_"]/"_"org_code")  //医院代码	
			s:LinkHospId'="" LinkHospId=$o(^CT("HOSP",0,"Code",$$ALPHAUP^SSUTIL4(LinkHospId),0))
			///取对应的默认医院
			s LinkHospId= ##class(web.DHCBL.BDP.BDPMappingHOSP).GetDefHospIdByTableName("DHC_TarItem",LinkHospId,+$h)	
		    
		    if (LinkHospId="")||(LinkHospId'>0)
			{
				s returncode=-1
				s info="医院ID为空"
				g errorret
			}
			s dataeobj.LinkHospId=LinkHospId
		
			s taricode=..GetFieldValue(InputStream,"/Request/Body/"_Tags_"/"_Tag_"["_counti_"]/"_"tari_code") //收费项代码
			s dataeobj.TARICode=taricode
			if dataeobj.TARICode=""
			{
				s returncode=-1
				s info="收费项代码为空"
				g errorret
			}
			s dataeobj.TARIRowId=##class(web.DHCBL.BDP.BDPDataImport).GetRowIdByCode("DHC_TarItem",taricode,LinkHospId)
			s dataeobj.TARIDesc=..GetFieldValue(InputStream,"/Request/Body/"_Tags_"/"_Tag_"["_counti_"]/"_"tari_desc") //收费项描述
			s dataeobj.TARIUOM=..GetFieldValue(InputStream,"/Request/Body/"_Tags_"/"_Tag_"["_counti_"]/"_"tari_uom") //单位描述
			//s:dataeobj.TARIUOM'="" dataeobj.TARIUOM=$o(^CT("UOM",0,"Desc",$$UPPER^SSUTIL4(dataeobj.TARIUOM),0))
			s:dataeobj.TARIUOM'="" dataeobj.TARIUOM=##class(web.DHCBL.BDP.BDPDataImport).GetRowIdByDesc("CT_UOM",dataeobj.TARIUOM,LinkHospId)
			
			
			s dataeobj.TARISubCate=..GetFieldValue(InputStream,"/Request/Body/"_Tags_"/"_Tag_"["_counti_"]/"_"tari_sub_cate") //收费项目子类描述
			//s:dataeobj.TARISubCate'="" dataeobj.TARISubCate=$o(^DHCTarC("SC",0,"Desc",dataeobj.TARISubCate,0))
			s:dataeobj.TARISubCate'="" dataeobj.TARISubCate=##class(web.DHCBL.BDP.BDPDataImport).GetRowIdByDesc("DHC_TarSubCate",dataeobj.TARISubCate,LinkHospId)
				
			s dataeobj.TARIAcctCate=..GetFieldValue(InputStream,"/Request/Body/"_Tags_"/"_Tag_"["_counti_"]/"_"tari_acct_cate") //收费会计子类描述
			//s:dataeobj.TARIAcctCate'="" dataeobj.TARIAcctCate=$o(^DHCTarC("AC",0,"Desc",dataeobj.TARIAcctCate,0))
			s:dataeobj.TARIAcctCate'="" dataeobj.TARIAcctCate=##class(web.DHCBL.BDP.BDPDataImport).GetRowIdByDesc("DHC_TarAcctCate",dataeobj.TARIAcctCate,LinkHospId)
				
			s dataeobj.TARIOutpatCate=..GetFieldValue(InputStream,"/Request/Body/"_Tags_"/"_Tag_"["_counti_"]/"_"tari_outpat_cate") //门诊费用子类描述
			//s:dataeobj.TARIOutpatCate'="" dataeobj.TARIOutpatCate=$o(^DHCTarC("OC",0,"Desc",dataeobj.TARIOutpatCate,0))
			s:dataeobj.TARIOutpatCate'="" dataeobj.TARIOutpatCate=##class(web.DHCBL.BDP.BDPDataImport).GetRowIdByDesc("DHC_TarOutpatCate",dataeobj.TARIOutpatCate,LinkHospId)
				
			s dataeobj.TARIEMCCate=..GetFieldValue(InputStream,"/Request/Body/"_Tags_"/"_Tag_"["_counti_"]/"_"tari_emc_cate") //经济核算子类描述
			//s:dataeobj.TARIEMCCate'="" dataeobj.TARIEMCCate=$o(^DHCTarC("EC",0,"Desc",dataeobj.TARIEMCCate,0))
			s:dataeobj.TARIEMCCate'="" dataeobj.TARIEMCCate=##class(web.DHCBL.BDP.BDPDataImport).GetRowIdByDesc("DHC_TarEMCCate",dataeobj.TARIEMCCate,LinkHospId)
				
			s dataeobj.TARIMRCate=..GetFieldValue(InputStream,"/Request/Body/"_Tags_"/"_Tag_"["_counti_"]/"_"tari_mr_cate") //旧病案首页子类描述
			//s:dataeobj.TARIMRCate'="" dataeobj.TARIMRCate=$o(^DHCTarC("MC",0,"Desc",dataeobj.TARIMRCate,0))
			s:dataeobj.TARIMRCate'="" dataeobj.TARIMRCate=##class(web.DHCBL.BDP.BDPDataImport).GetRowIdByDesc("DHC_TarMRCate",dataeobj.TARIMRCate,LinkHospId)
				
			s dataeobj.TARISpecialFlag=..GetFieldValue(InputStream,"/Request/Body/"_Tags_"/"_Tag_"["_counti_"]/"_"tari_special_flag") //
			s dataeobj.TARIActiveFlag=..GetFieldValue(InputStream,"/Request/Body/"_Tags_"/"_Tag_"["_counti_"]/"_"tari_active_flag") //
			s dataeobj.TARIStartDate=..GetFieldValue(InputStream,"/Request/Body/"_Tags_"/"_Tag_"["_counti_"]/"_"tari_start_date") //
			s dataeobj.TARIEndDate=..GetFieldValue(InputStream,"/Request/Body/"_Tags_"/"_Tag_"["_counti_"]/"_"tari_end_date") //
			s dataeobj.TARIExternalCode=..GetFieldValue(InputStream,"/Request/Body/"_Tags_"/"_Tag_"["_counti_"]/"_"tari_external_code") //
			s dataeobj.TARIInpatCate=..GetFieldValue(InputStream,"/Request/Body/"_Tags_"/"_Tag_"["_counti_"]/"_"tari_inpat_cate") //
			//s:dataeobj.TARIInpatCate'="" dataeobj.TARIInpatCate=$o(^DHCTarC("IC",0,"Desc",dataeobj.TARIInpatCate,0))
			s:dataeobj.TARIInpatCate'="" dataeobj.TARIInpatCate=##class(web.DHCBL.BDP.BDPDataImport).GetRowIdByDesc("DHC_TarInpatCate",dataeobj.TARIInpatCate,LinkHospId)
				
			s dataeobj.TARIInsuName=..GetFieldValue(InputStream,"/Request/Body/"_Tags_"/"_Tag_"["_counti_"]/"_"tari_insu_name") //
			s dataeobj.TARIEngName=..GetFieldValue(InputStream,"/Request/Body/"_Tags_"/"_Tag_"["_counti_"]/"_"tari_eng_name") //
			s dataeobj.TARIChargeBasis=..GetFieldValue(InputStream,"/Request/Body/"_Tags_"/"_Tag_"["_counti_"]/"_"tari_charge_basis") //
			s dataeobj.TARIItemCatDR=..GetFieldValue(InputStream,"/Request/Body/"_Tags_"/"_Tag_"["_counti_"]/"_"tari_item_cat_dr") //
			//s:dataeobj.TARIItemCatDR'="" dataeobj.TARIItemCatDR=$o(^User.BDPItemCategoryI("UniqueCodeIndex"," "_$zcvt(dataeobj.TARIItemCatDR,"U"),0))
			s:dataeobj.TARIItemCatDR'="" dataeobj.TARIItemCatDR=##class(web.DHCBL.BDP.BDPDataImport).GetRowIdByDesc("BDP_ItemCategory",dataeobj.TARIItemCatDR,LinkHospId)
				
			s dataeobj.TARIMCNew=..GetFieldValue(InputStream,"/Request/Body/"_Tags_"/"_Tag_"["_counti_"]/"_"tari_mc_new") //
			//s:dataeobj.TARIMCNew'="" dataeobj.TARIMCNew=$o(^DHCTARMRCATENEW(0,"Desc",dataeobj.TARIMCNew,0))
			s:dataeobj.TARIMCNew'="" dataeobj.TARIMCNew=##class(web.DHCBL.BDP.BDPDataImport).GetRowIdByDesc("DHC_TarMCCateNew",dataeobj.TARIMCNew,LinkHospId)

			
			//?entity里有这个字段吗
			s dataeobj.TARIConnote=..GetFieldValue(InputStream,"/Request/Body/"_Tags_"/"_Tag_"["_counti_"]/"_"tari_connote") //
			s dataeobj.TARIOPERCategoryDR=..GetFieldValue(InputStream,"/Request/Body/"_Tags_"/"_Tag_"["_counti_"]/"_"tari_opercategory_dr") //
			s:dataeobj.TARIOPERCategoryDR'="" dataeobj.TARIOPERCategoryDR=$o(^ORC("CATEG",0,"Code",$$ALPHAUP^SSUTIL4(dataeobj.TARIOPERCategoryDR),0))
			
			s dataeobj.TARIExclude=..GetFieldValue(InputStream,"/Request/Body/"_Tags_"/"_Tag_"["_counti_"]/"_"tari_exclude") //
			//国家医保编码
			s dataeobj.TARIInsuCode=..GetFieldValue(InputStream,"/Request/Body/"_Tags_"/"_Tag_"["_counti_"]/"_"tari_insucode") //
			//厂家
			//s dataeobj.TARIManufacturerDR=..GetFieldValue(InputStream,"/Request/Body/"_Tags_"/"_Tag_"["_counti_"]/"_"tari_manufacturerdr") //厂商名称
					
			s result=##class(web.DHCBL.CT.DHCTarItem).SaveEntity(dataeobj)	
			if (result["success:true")||(result["success:'true'")||(result["'success':'true'")
			{
				s TARIRowId=##class(web.DHCBL.BDP.FunLib).GetResultRowId(result)
				s dataeobj.TARIRowId=TARIRowId
				
				s status=0
				s msg="收费项保存成功"
				s Rtn="<Result><tari_code>"_dataeobj.TARICode_"</tari_code><tari_row_id>"_dataeobj.TARIRowId_"</tari_row_id><status>"_status_"</status><msg>"_msg_"</msg></Result>"
				if ResultsRtn="" s ResultsRtn=Rtn
				else  s ResultsRtn=ResultsRtn_Rtn
			}
			else
			{
				s returncode=-1
				s info="推送失败"
				s status=-1
				s msg="收费项保存失败"_result
				s Rtn="<Result><tari_code>"_dataeobj.TARICode_"</tari_code><tari_row_id>"_dataeobj.TARIRowId_"</tari_row_id><status>"_status_"</status><msg>"_info_"</msg></Result>"
				if ResultsRtn="" s ResultsRtn=Rtn
				else  s ResultsRtn=ResultsRtn_Rtn
			}
		}
	}
	s:info="" info="保存成功"
	s TotalRtn="<Response><return_code>"_returncode_"</return_code><return_desc>"_info_"</return_desc><Body><Results>"_ResultsRtn_"</Results></Body></Response>"
	q TotalRtn
errorret
	s TotalRtn="<Response><return_code>"_returncode_"</return_code><return_desc>"_info_"</return_desc><Body><Results>"_ResultsRtn_"</Results></Body></Response>"
	q TotalRtn
}

/// Creator：陈莹
/// CreatDate: 2020-07-09
/// Description：医嘱项与医院关联授权表
/// Input：数据,tablename:第三方的表名
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// w ..SaveArcItemHosp(stream)
ClassMethod SaveArcItemHosp(InputStream As %Stream.GlobalCharacter) As %String
{
	s tSC=##class(%XML.XPATH.Document).CreateFromStream(InputStream,.tDocument)
	s Tags="ArcItemHosps",Tag="ArcItemHosp"   //医嘱项医院关联信息保存
	s returncode=0,ResultsRtn="",info=""
	s total= ..GetDataCount(InputStream,"/Request/Body/"_Tags,Tag)  //获取标签的个数
	if (total=0)||(total="")
	{
		s returncode=-1
		s info="数量为空"
		if ResultsRtn="" s ResultsRtn=info
		else  s ResultsRtn=ResultsRtn_info
	}
	else
	{
		s type=..GetFieldValue(InputStream,"/Request/Header/type")  //A,  D  
		for counti=1:1:total	
		{
			k dataeobj
			s result=""
			s dataeobj=##class(web.Entity.CT.ARCItemHosp).%New()
			//医院RowId
			s LinkHospId=..GetFieldValue(InputStream,"/Request/Body/"_Tags_"/"_Tag_"["_counti_"]/"_"org_code")  //医院代码	
			s:LinkHospId'="" LinkHospId=$o(^CT("HOSP",0,"Code",$$ALPHAUP^SSUTIL4(LinkHospId),0))
			///取对应的默认医院
			s LinkHospId= ##class(web.DHCBL.BDP.BDPMappingHOSP).GetDefHospIdByTableName("ARC_ItmMast",LinkHospId,+$h)	
		    
			if (LinkHospId="")||(LinkHospId'>0)
			{
				s returncode=-1
				s info="医院ID为空"
				g errorret
			}
			s arcimcode=..GetFieldValue(InputStream,"/Request/Body/"_Tags_"/"_Tag_"["_counti_"]/"_"arcim_code") //医嘱项code
			//医嘱项指针
			s dataeobj.HOSPParRef=##class(web.DHCBL.BDP.BDPDataImport).GetRowIdByCode("ARC_ItmMast",arcimcode,LinkHospId)
			if dataeobj.HOSPParRef=""
			{
				s returncode=-1
				s info="医嘱项代码"_arcimcode_"找不到对应的id"
				g errorret
			}
			s dataeobj.HOSPHospitalDR=LinkHospId  //医院
			s result=""
			s sub=$o(^ARCIM($p(dataeobj.HOSPParRef,"||",1),$p(dataeobj.HOSPParRef,"||",2),"HOSP",0,"Hosp",dataeobj.TPHospitalDR,0))
			if (type="U")||(type="A")  //新增或者修改
			{
				if sub'=""
				{
					s dataeobj.HOSPRowId=dataeobj.HOSPParRef_"||"_sub							
				}
				s result=##class(web.DHCBL.CT.ARCItemHosp).SaveEntity(dataeobj)
			}
			elseif (type="D")  //删除
			{
				if sub'=""
				{
					d ##class(web.DHCBL.CT.ARCItemHosp).DeleteData(dataeobj.HOSPParRef_"||"_sub)
				}
			}
			if (result["success:true")||(result["success:'true'")||(result["'success':'true'")
			{
				
			}
			else
			{
				s returncode=-1
				s info="推送失败"
				s status=-1
				s msg="医嘱项医院授权失败"_result
				s Rtn="<Result><arcim_code>"_arcimcode_"</arcim_code><status>"_status_"</status><msg>"_msg_"</msg></Result>"
				if ResultsRtn="" s ResultsRtn=Rtn
				else  s ResultsRtn=ResultsRtn_Rtn
			}
		}
		
	}
	s:info="" info="保存成功"
	s TotalRtn="<Response><return_code>"_returncode_"</return_code><return_desc>"_info_"</return_desc><Body><Results>"_ResultsRtn_"</Results></Body></Response>"
	
	q TotalRtn
errorret
	s TotalRtn="<Response><return_code>"_returncode_"</return_code><return_desc>"_info_"</return_desc><Body><Results>"_ResultsRtn_"</Results></Body></Response>"
	q TotalRtn
}

/// Creator：陈莹
/// CreatDate: 2020-05-14
/// 解析xml里的字段值
/// w ##class(web.DHCBL.BDP.BDPInterface).GetFieldValue(stream,"/Request/Body/"_Tags_"/"_Tag_"/"_"tari_code")
ClassMethod GetFieldValue(InputStream As %Stream.GlobalCharacter, XMLTag) As %String
{
	s value=""
	s tSC=##class(%XML.XPATH.Document).CreateFromStream(InputStream,.tDocument)	
	s tSC=tDocument.EvaluateExpression(XMLTag,"text()",.tRes)					
	if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
		s fieldValue=tRes.GetAt(1).Value
		s value=$tr(fieldValue,$c(0),"")
	}
	q value
}

/// Creator：陈莹
/// CreatDate: 2020-05-14
/// 解析xml里的标签的数量
/// w ##class(web.DHCBL.BDP.BDPInterface).GetDataCount(stream,"/Request/Body/TarItems","TarItem")
ClassMethod GetDataCount(InputStream As %Stream.GlobalCharacter, XMLTags As %String, Tag) As %String
{
	s count=""
	s tSC=##class(%XML.XPATH.Document).CreateFromStream(InputStream,.tDocument)	
	s tSC=tDocument.EvaluateExpression(XMLTags,"count("_Tag_")",.tRes)					
	if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
		s fieldValue=tRes.GetAt(1).Value
		s count=$tr(fieldValue,$c(0),"")
	}
	q count
}

/// Function:   修改安全组，将描述同步到代码
/// Creator:    chenying
/// CreateDate: 2022-10-17
/// TableName:  SS_Group
/// Debug:      w ##class(web.DHCBL.BDP.BDPInterface).UpdateGroupCode()
ClassMethod UpdateGroupCode()
{
	s SSGRPRowId=0
	for
	{
		s SSGRPRowId=$o(^SSU("SSGRP",SSGRPRowId)) q:SSGRPRowId=""
		s SSGRPDesc=$p($g(^SSU("SSGRP",SSGRPRowId)),"^",1)
		s obj=##class(User.SSGroup).%OpenId(SSGRPRowId)
		s obj.SSGRPCode ="G"_##class(web.DHCBL.BDP.FunLib).AddZEROToStr(SSGRPRowId,4)
		s sc=obj.%Save()
		d obj.%Close()
	}
	q ""
}

/// Function:   根据医院代码获取rowid
/// Creator:    chenying
/// CreateDate: 2022-10-25
/// TableName:  CT_Hospital
/// Debug:      w ##class(web.DHCBL.BDP.BDPInterface).GetRowIdByOrgCode("")
ClassMethod GetRowIdByOrgCode(code As %String) As %String
{
	q:code="" ""
	q:$$ALPHAUP^SSUTIL4(code)="" ""
	s rowid=$o(^CT("HOSP",0,"Code",$$ALPHAUP^SSUTIL4(code),0))
	q rowid
}

/// Function:   根据科室代码获取rowid
/// Creator:    chenying
/// CreateDate: 2022-10-25
/// TableName:  CT_Loc
/// Debug:      w ##class(web.DHCBL.BDP.BDPInterface).GetRowIdByBuCode("","")
ClassMethod GetRowIdByBuCode(code As %String, hospid As %String = "") As %String
{
	q:code="" ""
	q:$$ALPHAUP^SSUTIL4(code)="" ""
	s rowid=$o(^CTLOC(0,"Code",$$ALPHAUP^SSUTIL4(code),0))
	q rowid
}

/// Function:   根据角色代码获取rowid
/// Creator:    chenying
/// CreateDate: 2022-10-25
/// TableName:  SS_Group
/// Debug:      w ##class(web.DHCBL.BDP.BDPInterface).GetRowIdByRoleCode("Demo Group")
ClassMethod GetRowIdByRoleCode(code As %String) As %String
{
	q:code="" ""
	s rowid=$o(^SSU("SSGRP",0,"Code",code,0))
	q rowid
}

/// Function:   根据用户代码获取rowid
/// Creator:    chenying
/// CreateDate: 2022-10-25
/// TableName:  SS_User
/// Debug:      w ##class(web.DHCBL.BDP.BDPInterface).GetRowIdByUserCode("")
ClassMethod GetRowIdByUserCode(code As %String) As %String
{
	q:code="" ""
	q:$$ALPHAUP^SSUTIL4(code)="" ""
	s rowid=$o(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(code),0))
	q rowid
}

/// Function:   根据业务岗位编码获取科室rowid
/// Creator:    gss
/// CreateDate: 2023-02-17
/// TableName:  CT.BDP.CT.HOSPost
/// Debug:      w ##class(web.DHCBL.BDP.BDPInterface).GetLocIdByPostCode("01")
ClassMethod GetLocIdByPostCode(code As %String) As %String
{
	q:code="" ""
	s postid=$o(^CT.BDP.CT.HOSPostI("IndexCode"," "_$zconvert(code,"U"),0))
	q:postid="" ""
	s rowid= $listget($g(^CT.BDP.CT.HOSPostD(postid)),4) 	//业务单元代码-科室
	q rowid
}

/// Function:   根据业务岗位编码获取安全组rowid
/// Creator:    gss
/// CreateDate: 2023-02-17
/// TableName:  CT.BDP.CT.HOSPost、CT.BDP.CT.HOSPostRole
/// Debug:      w ##class(web.DHCBL.BDP.BDPInterface).GetGroupIdByPostCode("01")
ClassMethod GetGroupIdByPostCode(code As %String) As %String
{
	q:code="" ""
	s postid=$o(^CT.BDP.CT.HOSPostI("IndexCode"," "_$zconvert(code,"U"),0))
	q:postid="" ""
	s rowid=$o(^CT.BDP.CT.HOSPostRoleI("IndexPOSTROLE",1,0))
	q rowid
}

/// 1.需要在his里新增用户 UnifiedUserPlatform
/// 2更新安全组代码 +安全组界面+安全组数据  w ##class(web.DHCBL.BDP.BDPInterface).UpdateGroupCode()

}
