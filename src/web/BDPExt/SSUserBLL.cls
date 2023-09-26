Class web.BDPExt.SSUserBLL Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// update2020-02-11
/// Creator:陈莹
/// CreatDate:2017-2-10
/// Description:保存用户、医护人员和其他登陆科室、别名数据
/// Other:d ##class(web.BDPExt.SSUserBLL).SaveEntity(Ceobj)
ClassMethod SaveEntity(Ceobj As web.BDPExt.SSUserEntity) As %String
{
	n (Ceobj,%session)
	s $zt="ERROR"
	s ImportResult=""
	///用户默认值 
	s:Ceobj.SSUSRPassword="" Ceobj.SSUSRPassword="1"
	s:Ceobj.SSUSRPin="" Ceobj.SSUSRPin="1"
	s:Ceobj.SSUSRCTLANDR="" Ceobj.SSUSRCTLANDR=##class(web.DHCBL.CT.SSLanguage).GetDefault()
	s:Ceobj.CTPCPDateActiveFrom="" Ceobj.CTPCPDateActiveFrom=Ceobj.SSUSRDateFrom
	s:Ceobj.CTPCPActiveFlag="" Ceobj.CTPCPActiveFlag="Y"
	s Ceobj.SSUSRActive=Ceobj.CTPCPActiveFlag
	s:Ceobj.SSUSRActive="" Ceobj.SSUSRActive="Y"
	s:Ceobj.SSUSRChangeLocation="" Ceobj.SSUSRChangeLocation="Y"
	s:Ceobj.SSUSRPasswordChanged="" Ceobj.SSUSRPasswordChanged="Y"
	s:Ceobj.CTPCPOtherName="" Ceobj.CTPCPOtherName=##class(web.DHCBL.BDP.FunLib).GetPYCODE(Ceobj.SSUSRName)
	s:Ceobj.DataAlias="" Ceobj.DataAlias=##class(web.DHCBL.BDP.FunLib).GetPYCODE(Ceobj.DataAlias)
	
	s ssuserobj=##class(web.BDPExt.FunLib).TransObj(Ceobj,"web.Entity.CT.SSUser")
	s careprovobj=##class(web.BDPExt.FunLib).TransObj(Ceobj,"web.Entity.CT.CTCareProv")
	s otherLogLocobj=##class(web.BDPExt.FunLib).TransObj(Ceobj,"web.Entity.CT.SSUserOtherLogonLoc")
	s rbResourceobj=##class(web.BDPExt.FunLib).TransObj(Ceobj,"web.Entity.CT.RBResource")
	
	s CTPCPRowId1=$o(^CTPCP(0,"Code",$$ALPHAUP^SSUTIL4(Ceobj.SSUSRInitials),0))     ///已存在的医护人员跳过导入
	s SSUSRRowId=$o(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(Ceobj.SSUSRInitials),0))    ///已存在的用户跳过导入
	if ((CTPCPRowId1'="")||(SSUSRRowId'=""))
	{
		s ImportResult="用户/医护人员:该代码已存在"
	}
	if ImportResult'="" q ImportResult
			
	Ts	
	//保存用户同时保存医护人员
	if (Ceobj.Type["C")
	{
		//医护人员保存
		s careprovSaveResult=""	
		s careprovobj.CTPCPRowId1=""
		s careprovobj.CTPCPCode = Ceobj.SSUSRInitials
		s careprovobj.CTPCPDesc = Ceobj.SSUSRName
		s careprovobj.CTPCPCarPrvTpDR = Ceobj.CTPCPCarPrvTpDR
		///20170802  如果检索码为空，默认为描述的首拼
		s:careprovobj.CTPCPOtherName="" careprovobj.CTPCPOtherName=##class(web.DHCBL.BDP.FunLib).GetPYCODE(Ceobj.SSUSRName)
		
		s HospitalDesc=$p(Ceobj.SSUSRHospitalDR,"/",1)  //2020-06-05
		s HospId=""
		s:HospitalDesc'="" HospId=$o(^CT("HOSP",0,"Desc",$$ALPHAUP^SSUTIL4(HospitalDesc),0))	
		S careprovobj.LinkHospId=HospId
		s careprovSaveResult=##class(web.DHCBL.CT.CTCareProv).SaveEntity(careprovobj)
		s CTPCPRowId1=##class(web.BDPExt.FunLib).GetResultRowId(careprovSaveResult)
		//用户保存
		if (CTPCPRowId1'="")
		{
			///医护人员管制药品分类权限
			if (Ceobj.CTCareProvPHCPoison'="")
			{
				
				s PHCPoisonLen=$l(Ceobj.CTCareProvPHCPoison,"/")
				for PHCPoisoni=1:1:PHCPoisonLen
				{
					s PHCPoisonDesc=$p(Ceobj.CTCareProvPHCPoison,"/",PHCPoisoni)
					continue:PHCPoisonDesc=""
					k PHCPoisoneobj
					S PHCPoisoneobj=##class(web.Entity.CT.CTCareProvPHCPoison).%New()
					s PHCPoisoneobj.CPPParRef=CTPCPRowId1
					s PHCPoisoneobj.CPPPHCPoisonDR=$o(^PHCPO(0,"Desc",$$ALPHAUP^SSUTIL4(PHCPoisonDesc),0))
					s SaveResult= ##class(web.DHCBL.CT.CTCareProvPHCPoison).SaveEntity(PHCPoisoneobj)
					s CPPRowId=##class(web.BDPExt.FunLib).GetResultRowId(SaveResult)
					if (CPPRowId=""){
						s ImportResult="医护人员关联管制药品分类:"_SaveResult
							
					}
				}
			}
			///医护人员关联处方权
			if (Ceobj.CTCareProvPrescriptSet'="")
			{
				s PrescriptSetLen=$l(Ceobj.CTCareProvPrescriptSet,"/")
				for PrescriptSeti=1:1:PrescriptSetLen
				{
					s PrescriptSetDesc=$p(Ceobj.CTCareProvPrescriptSet,"/",PrescriptSeti)
					continue:PrescriptSetDesc=""
					k Prescriptobj
					S Prescriptobj=##class(web.Entity.CT.CTCareProvPrescriptSet).%New()
					s Prescriptobj.CPPSParRef=CTPCPRowId1
					if (PrescriptSetDesc["-")
					{
						s Prescriptobj.CPPSPrescriptSetDR=##class(web.DHCBL.CT.CTCareProvPrescriptSet).GetPrescriptIdByDesc2(PrescriptSetDesc)
					}
					else
					{
						s Prescriptobj.CPPSPrescriptSetDR=##class(web.DHCBL.CT.CTCareProvPrescriptSet).GetPrescriptIdByDesc(PrescriptSetDesc,HospId)
					}
					if (Prescriptobj.CPPSPrescriptSetDR'="")
					{
						s SaveResult= ##class(web.DHCBL.CT.CTCareProvPrescriptSet).SaveEntity(Prescriptobj)
						s CPPSRowId=##class(web.BDPExt.FunLib).GetResultRowId(SaveResult)
						if (CPPSRowId=""){
							s ImportResult="医护人员关联处方权:"_SaveResult
						}
					}
					
				}
			}
			
			///别名
			if (Ceobj.DataAlias'="")
			{
				s aliasLen=$l(Ceobj.DataAlias,"/")
				for i=1:1:aliasLen
				{
					s aliasSaveResult=##class(web.DHCBL.BDP.BDPAlias).Insert("CT_CareProv",$p(Ceobj.DataAlias,"/",i),CTPCPRowId1)
					if (aliasSaveResult=0){
						s ImportResult="医护人员别名:"_aliasSaveResult	
					}
				}
			}	
		
		}
		else
		{
			s ImportResult="医护人员:"_careprovSaveResult	
		}
		
	}
	//保存用户
	if (Ceobj.Type["U")
	{	
		;用户默认登录科室、安全组
		s CTLOCDesc=$p(Ceobj.DeptLoc,"/",1) 
		s HospitalDesc=$p(Ceobj.SSUSRHospitalDR,"/",1)
		s HospId=""
		s:HospitalDesc'="" HospId=$o(^CT("HOSP",0,"Desc",$$ALPHAUP^SSUTIL4(HospitalDesc),0))	
		s SSUSRDefaultDeptDR=##class(web.DHCBL.BDP.BDPDataImport).GetRowIdByDesc("CT_Loc",CTLOCDesc,HospId)  //$o(^CTLOC(0,"Desc",$$ALPHAUP^SSUTIL4(CTLOCDesc),0))
		s SSGRPDesc=$p(Ceobj.SSUSRGroup,"/",1)
		s SSGRPRowId=##class(web.DHCBL.BDP.BDPDataImport).GetRowIdByDesc("SS_Group",SSGRPDesc,HospId)
		if (CTLOCDesc="")||(SSUSRDefaultDeptDR="")||(SSGRPDesc="")||(SSGRPRowId="")||(HospitalDesc="")||(HospId="")
		{
			s ImportResult="用户:默认登录科室或安全组不存在"
		}
		else
		{
			s ssuserobj.SSUSRCareProvDR=CTPCPRowId1  //医护人员id	
			s ssuserobj.SSUSRRowId=""
			s ssuserobj.SSUSRDefaultDeptDR=SSUSRDefaultDeptDR
			s ssuserobj.SSUSRHospitalDR=HospId 
			s ssuserobj.SSUSRGroup=SSGRPRowId
			s SSUserSaveResult=##class(web.DHCBL.CT.SSUser).SaveEntity(ssuserobj)
			s SSUSRRowId=##class(web.BDPExt.FunLib).GetResultRowId(SSUserSaveResult)

			if (SSUSRRowId'="")
			{
				///用户别名
				if (Ceobj.DataAlias'="")
				{
					s aliasLen=$l(Ceobj.DataAlias,"/")
					for i=1:1:aliasLen
					{
						s aliasSaveResult=##class(web.DHCBL.BDP.BDPAlias).Insert("SS_User",$p(Ceobj.DataAlias,"/",i),SSUSRRowId)
						if (aliasSaveResult=0){
							s ImportResult="用户别名:"_aliasSaveResult	
						}
					}
				}

				///其他登录科室
				s otherLogLocobj.OTHLLParRef=SSUSRRowId
				s locLen=$l(Ceobj.DeptLoc,"/")
				s hospLen=$l(Ceobj.SSUSRHospitalDR,"/")
				if locLen>1
				{
					s flagOtherLogLoc=0
					s i=1
					for 
					{
						s i=i+1 q:((i>locLen)||(flagOtherLogLoc=1))
						s CTLOCDesc=$p(Ceobj.DeptLoc,"/",i) 
						if hospLen=1 s HospitalDesc=Ceobj.SSUSRHospitalDR
						else  s HospitalDesc=$p(Ceobj.SSUSRHospitalDR,"/",i)
						s HospId=""
						s:HospitalDesc'="" HospId=$o(^CT("HOSP",0,"Desc",$$ALPHAUP^SSUTIL4(HospitalDesc),0))
						s OTHLLCTLOCDR=##class(web.DHCBL.BDP.BDPDataImport).GetRowIdByDesc("CT_Loc",CTLOCDesc,HospId)
						s SSGRPDesc=$p(Ceobj.SSUSRGroup,"/",i)
						s SSGRPRowId=##class(web.DHCBL.BDP.BDPDataImport).GetRowIdByDesc("SS_Group",SSGRPDesc,HospId)
						if (CTLOCDesc="")||(OTHLLCTLOCDR="")||(SSGRPDesc="")||(SSGRPRowId="")||(HospitalDesc="")||(HospId="")
						{
							s ImportResult="其他登录科室:登录科室或安全组或医院不存在"
						}
						else
						{
							s otherLogLocobj.OTHLLRowId=""
							s otherLogLocobj.OTHLLCTLOCDR=OTHLLCTLOCDR
							s otherLogLocobj.OTHLLUserGroupDR=SSGRPRowId
							///2019-12-15  默认同步到资源表
							s flag=##class(web.DHCBL.CT.SSUserOtherLogonLoc).FormValidate(SSUSRRowId,"",OTHLLCTLOCDR,SSGRPRowId,+$h,"")  //调用重复验证
							if (flag=1)
							{
								s ImportResult="其他登录科室:存在重复数据"
								s flagOtherLogLoc=1
							}
							else
							{
								s otherLogLocSaveResult=##class(web.DHCBL.CT.SSUserOtherLogonLoc).SaveData(otherLogLocobj,"Y")
								s OTHLLRowId=##class(web.BDPExt.FunLib).GetResultRowId(otherLogLocSaveResult)		
								if (OTHLLRowId="")
								{
									s flagOtherLogLoc=1
									s ImportResult="其他登录科室:"_otherLogLocSaveResult				
								}
							}
						}
					}
				}
				
			}
			else
			{
				s ImportResult="用户:"_SSUserSaveResult	
			}
		}
	}

	//仅保存医护人员时要往资源表里插入数据
	if (Ceobj.Type="C")
	{
		if (CTPCPRowId1'="")
		{
			if Ceobj.DeptLoc'=""
			{
				///指定科室	rbResourceobj	
				s locLen=$l(Ceobj.DeptLoc,"/")	
				s hospLen=$l(Ceobj.SSUSRHospitalDR,"/")
				s flagrbResource=0
				s i=0
				for 
				{
					s i=i+1 q:((i>locLen)||(flagrbResource=1))
					s CTLOCDesc=$p(Ceobj.DeptLoc,"/",i) 
					if hospLen=1 s HospitalDesc=Ceobj.SSUSRHospitalDR
					else  s HospitalDesc=$p(Ceobj.SSUSRHospitalDR,"/",i)
					s HospId=""
					s:HospitalDesc'="" HospId=$o(^CT("HOSP",0,"Desc",$$ALPHAUP^SSUTIL4(HospitalDesc),0))
					s RESCTLOCDR=##class(web.DHCBL.BDP.BDPDataImport).GetRowIdByDesc("CT_Loc",CTLOCDesc,HospId)  //$o(^CTLOC(0,"Desc",$$ALPHAUP^SSUTIL4(CTLOCDesc),0))
					if (RESCTLOCDR=""){
							s ImportResult="医护人员指定科室:科室不存在"
					}else{
						s rbResourceobj.RESRowId1=""
						s rbResourceobj.RESCTLOCDR=RESCTLOCDR
						s rbResourceobj.RESCTPCPDR=CTPCPRowId1
						s rbResourceobj.RESScheduleRequired = "Y"   //单导医护人员，指定医护人员到科室需要排班应该为Y  20171010 	
						s rbResourceSaveResult=##class(web.DHCBL.CT.RBResource).SaveEntity(rbResourceobj)
						s RESRowId1=##class(web.BDPExt.FunLib).GetResultRowId(rbResourceSaveResult)	
	
						if (RESRowId1="")
						{
							s flagrbResource=1
							s ImportResult="医护人员指定科室:"_rbResourceSaveResult				
						}
					}
				}
			}
			if (Ceobj.SSUSRHospitalDR'="")
			{
				for Hospi=1:1:$L(Ceobj.SSUSRHospitalDR,"/")
				{
					s HospitalDesc=$p(Ceobj.SSUSRHospitalDR,"/",Hospi)
					continue:HospitalDesc=""
					s HospId=$o(^CT("HOSP",0,"Desc",$$ALPHAUP^SSUTIL4(HospitalDesc),0))
					s hospeobj=##class(web.Entity.CT.CTCareProvHospitals).%New()
					s hospeobj.HOSPRowId=""
					s hospeobj.HOSPHospitalDR=HospId
					s hospeobj.HOSPParRef=CTPCPRowId1
					D ##class(web.DHCBL.CT.CTCareProvHospitals).SaveEntity(hospeobj)
				}
			}		
		}else{
			s ImportResult="医护人员:"_careprovSaveResult	
		}
	} //C结束
	
		
	
	if (ImportResult="")
	{
		Tc
		if (Ceobj.Type="C"){
			s ImportResult="{success:'true',id:'"_CTPCPRowId1_"'}" 
		}else{
			s ImportResult="{success:'true',id:'"_SSUSRRowId_"'}" 
		}
	
	}
	else
	{
		Tro
		s ImportResult="{success:'false',info:'"_ImportResult_"'}" 
		s CTPCPRowId1=$o(^CTPCP("A"),-1)
		IF (CTPCPRowId1'="")&&(CTPCPRowId1>0)
		{
			if ($D(^CTPCP(CTPCPRowId1,"KEYW",0))>0)&&($G(^CTPCP(CTPCPRowId1,1))="") k ^CTPCP(CTPCPRowId1)
		}
	
		s SSUSRRowId=$o(^SSU("SSUSR","A"),-1)
		IF (SSUSRRowId'="")&&(SSUSRRowId>0)
		{
			if ($D(^SSU("SSUSR",SSUSRRowId))=10) k ^SSU("SSUSR",SSUSRRowId)
		}	
	}
	q ImportResult
ERROR
	q ImportResult
}

/// Creator:陈莹
/// CreatDate:20170330
/// Description:清除非管理员用户、医护人员和其他登陆科室
/// Other:d ##class(web.BDPExt.SSUserBLL).ClearData()
ClassMethod ClearData()
{
	n
	k ^CTPCP,^RB("RES"),^RBC("SER")
	s SSUSRRowId=0
	for  
	{	
		s SSUSRRowId=$o(^SSU("SSUSR",SSUSRRowId)) q:SSUSRRowId=""
		s SSUSRInitials=$p($g(^SSU("SSUSR",SSUSRRowId)),"^",1)  //Demo Group  demo
		s obj=##class(User.SSUser).%OpenId(SSUSRRowId)
		
		s firstLocID=$o(^CTLOC(0))
		s firstHospID=$o(^CT("HOSP",0))
		if firstLocID'="" s firstHospID=$p($g(^CTLOC(firstLocID)),"^",22)
		if $ZCVT(SSUSRInitials,"U")="DEMO"
		{
			d obj.SSUSRCareProvDRSetObjectId("")
			d obj.SSUSRHospitalDRSetObjectId(firstHospID)
			if firstLocID'="" d obj.SSUSRDefaultDeptDRSetObjectId(firstLocID)
			s sc=obj.%Save()
			s sub=0
			for 
			{
				s sub=$o(^SSU("SSUSR",SSUSRRowId,"OTHLL",sub)) q:sub=""
				s OTHLLRowId=SSUSRRowId_"||"_sub
				d ##class(User.SSUserOtherLogonLoc).%DeleteId(OTHLLRowId)
			}
			k ^SSU("SSUSR",SSUSRRowId,"OTHLL",0)
			k ^SSU("SSUSR",SSUSRRowId,"EXT")
			k ^SSU("SSUSR",SSUSRRowId,"EXTIMG")
		}
		else
		{
			s SSUSRAdmitted=$p($g(^SSU("SSUSR",SSUSRRowId)),"^",63)
			if SSUSRAdmitted="Y"
			{
				d obj.SSUSRCareProvDRSetObjectId("")
				d obj.SSUSRHospitalDRSetObjectId(firstHospID)
				d obj.SSUSRDefaultDeptDRSetObjectId(firstLocID)
				s sc=obj.%Save()
				s sub=0
				for 
				{
					s sub=$o(^SSU("SSUSR",SSUSRRowId,"OTHLL",sub)) q:sub=""
					s OTHLLRowId=SSUSRRowId_"||"_sub
					d ##class(User.SSUserOtherLogonLoc).%DeleteId(OTHLLRowId)
				}
				k ^SSU("SSUSR",SSUSRRowId,"OTHLL",0)
				k ^SSU("SSUSR",SSUSRRowId,"EXT")
				k ^SSU("SSUSR",SSUSRRowId,"EXTIMG")
			}
			else
			{
				s sc=##class(User.SSUser).%DeleteId(SSUSRRowId)
				
			}
			
		}
		
	}
}

/// 保存国家医保编码 8.4以后多院区加医院
/// 需配置第一列医院
/// LinkHospId 医院名称 DR $o(^CT("HOSP",0,"Desc",$$ALPHAUP^SSUTIL4(LinkHospId),0)) CT_Hospital
/// 基础数据-likefan
ClassMethod SaveSSUSRFreeText3(Ceobj As web.BDPExt.SSUserEntity) As %String
{
	n (Ceobj,%session)
	
	//考虑不同院区存在同工号情况
	s SSUSRRowId=0
	for
	{
		s SSUSRRowId=$o(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(Ceobj.SSUSRInitials),SSUSRRowId))
		q:SSUSRRowId=""
		s SSUSRHospitalDR=$p($g(^SSU("SSUSR",SSUSRRowId)),"^",98)      //医院DR
		q:(SSUSRHospitalDR=Ceobj.LinkHospId)
	}
	q:SSUSRRowId="" "找不到用户"
	
	s SSUSRName=$p($g(^SSU("SSUSR",SSUSRRowId)),"^",2)       //用户名
	q:SSUSRName'=Ceobj.SSUSRName "姓名与工号不匹配"
	
	s obj=##class(User.SSUser).%OpenId(SSUSRRowId)
	s obj.SSUSRFreeText3=Ceobj.SSUSRFreeText3
	s sc=obj.%Save()
	d obj.%Close()
	If $$$ISOK(sc)
	{
		s id = obj.%Id()
		q "{success:'true',id:'"_id_"'}"
	}
	else
	{
		q "保存失败^"_Ceobj.SSUSRInitials
	}
	q ""
}

}
