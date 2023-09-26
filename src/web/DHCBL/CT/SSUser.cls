Import SQLUser

Class web.DHCBL.CT.SSUser Extends %RegisteredObject [ ProcedureBlock ]
{

/// update20200521 
Parameter SQLTableName = "SS_User";

/// Creator：基础数据平台-李可凡
/// CreatDate: 2020年3月31日
/// Description：查询用户的内容，真分页
/// Table：User.SSUser
/// Other: w ##class(web.DHCBL.CT.SSUser).GetListPage("","","","","","","","","","","","","","","","","","0","20")
ClassMethod GetListPage(rowid, Initials, CPId, Name, SSUSRGroup, AdminGroupDR, DefaultDeptDR, CarPrvTpDR, SpecDR, communityid, SCTLOCDR, hosp, Active, treetype, category, sort, dir, start, limit, CareProvType, countryCodeYN, insurcode) As %String
{
	//获取授权Json
	s AuStr=##class(web.DHCBL.Authorize.SSUser).DHCGetDataByDefaultSession()
	;这地方加个方法---获取基本配置中未授权的情况下是否显示数据
	;假设未授权情况下默认全部显示数据
	
	//s AuHospStr=##class(web.DHCBL.Authorize.BDPHospitalAut).GetHospAutFlag()
	
	s AuSSUSRDeptDRStr=##class(web.DHCBL.Authorize.CTLoc).DHCGetDataByDefaultSession() //默认登录科室
	s AuSSUSRGroupDStr=##class(web.DHCBL.Authorize.SSGroup).DHCGetDataByDefaultSession() //安全组
	s AuSSUSRLANDRStr=##class(web.DHCBL.Authorize.SSLanguage).DHCGetDataByDefaultSession() //默认语言
	s AuSSUSRHospDRStr=##class(web.DHCBL.Authorize.CTHospital).DHCGetDataByDefaultSession() //关联医院
	s AuSSUSRProvDRStr=##class(web.DHCBL.Authorize.CTCareProv).DHCGetDataByDefaultSession() //医护人员
	s AuCTPCPPrvTpDRStr=##class(web.DHCBL.Authorize.CTCarPrvTp).DHCGetDataByDefaultSession() //医护人员类型
	s AuCTPCPSpecDRStr=##class(web.DHCBL.Authorize.CTSpec).DHCGetDataByDefaultSession() //医生专长
	
	s AuFlag=0
	if (AuStr="")||(AuStr["limited:0") s AuFlag=1
	
	s AuSSUSRDeptDRFlag=0
	if (AuSSUSRDeptDRStr="")||(AuSSUSRDeptDRStr["limited:0") s AuSSUSRDeptDRFlag=1
	s AuSSUSRGroupDFlag=0
	if (AuSSUSRGroupDStr="")||(AuSSUSRGroupDStr["limited:0") s AuSSUSRGroupDFlag=1
	s AuSSUSRLANDRFlag=0
	if (AuSSUSRLANDRStr="")||(AuSSUSRLANDRStr["limited:0") s AuSSUSRLANDRFlag=1
	s AuSSUSRHospDRFlag=0
	if (AuSSUSRHospDRStr="")||(AuSSUSRHospDRStr["limited:0") s AuSSUSRHospDRFlag=1
	s AuSSUSRProvDRFlag=0
	if (AuSSUSRProvDRStr="")||(AuSSUSRProvDRStr["limited:0") s AuSSUSRProvDRFlag=1
	s AuCTPCPPrvTpDRFlag=0
	if (AuCTPCPPrvTpDRStr="")||(AuCTPCPPrvTpDRStr["limited:0") s AuCTPCPPrvTpDRFlag=1
	s AuCTPCPSpecDRFlag=0
	if (AuCTPCPSpecDRStr="")||(AuCTPCPSpecDRStr["limited:0") s AuCTPCPSpecDRFlag=1
	
	if (rowid'="") //根据rowid返回该条记录
	{
		s (CTLOCDesc,SSGRPDesc,HOSPDesc,CTCPTDesc,CTPCPCode,CTPCPDesc,CTPCPId,CTPCPCarPrvTpDR,CTCPTDesc,CTPCPOtherName,CTPCPHICApproved,SSUSRHOSPerson)=""
		s SSUSRRowId=rowid
		s SSUSRInitials=$p($g(^SSU("SSUSR",SSUSRRowId)),"^",1)       //人事ID
		s SSUSRName=$p($g(^SSU("SSUSR",SSUSRRowId)),"^",2)       //用户名护
		s SSUSRDefaultDeptDR=$p($g(^SSU("SSUSR",SSUSRRowId)),"^",4)     //登录科室DR
		s:SSUSRDefaultDeptDR'="" CTLOCDesc=$p($g(^CTLOC(SSUSRDefaultDeptDR)),"^",2) //登录科室名称
		s SSUSRGroupD=$p($g(^SSU("SSUSR",SSUSRRowId)),"^",5)  //安全组DR
		s:SSUSRGroupD'="" SSGRPDesc=$p($g(^SSU("SSGRP",SSUSRGroupD)),"^",1) //安全组名称
		s SSUSRChangeLocation=$p($g(^SSU("SSUSR",SSUSRRowId)),"^",10)    //是否改变登录科室
		s SSUSRCareProvDR=$p($g(^SSU("SSUSR",SSUSRRowId)),"^",14)      //医护人员DR
		
		s SSUSRCTLANDR=$p($g(^SSU("SSUSR",SSUSRRowId)),"^",13)      //语言DR
		s:SSUSRCTLANDR'="" SSUSRCTLANDR=$p($g(^SS("LAN",SSUSRCTLANDR)),"^",2)      //语言
		
		s SSUSRActive=$p($g(^SSU("SSUSR",SSUSRRowId)),"^",19)      //是否激活
		s SSUSRLastUpdateUserDR=$p($g(^SSU("SSUSR",SSUSRRowId)),"^",75)    //更新人
		s:SSUSRLastUpdateUserDR'="" SSUSRLastUpdateUserDR=$p($g(^SSU("SSUSR",SSUSRLastUpdateUserDR)),"^",2)     //更新人
		s SSUSRLastUpdateDate=$p($g(^SSU("SSUSR",SSUSRRowId)),"^",76)    //最后更新日期
		s SSUSRDateFrom=$p($g(^SSU("SSUSR",SSUSRRowId)),"^",96)    //开始日期
		s SSUSRDateTo=$p($g(^SSU("SSUSR",SSUSRRowId)),"^",97)  //结束日期
		s:SSUSRLastUpdateDate'="" SSUSRLastUpdateDate=$zd(SSUSRLastUpdateDate,1) //
		s:SSUSRDateFrom'="" SSUSRDateFrom=$zd(SSUSRDateFrom,1) //转换日期格式
		s:SSUSRDateTo'="" SSUSRDateTo=$zd(SSUSRDateTo,1) //转换日期格式
		s SSUSRHospitalDR=$p($g(^SSU("SSUSR",SSUSRRowId)),"^",98)      //医院DR
		s:SSUSRHospitalDR'="" HOSPDesc=$p($g(^CT("HOSP",SSUSRHospitalDR)),"^",2) //医院名称
		s SSUSRAdmitted=$p($g(^SSU("SSUSR",SSUSRRowId)),"^",63) //管理员用户
		s SSUSRIgnoreCALogon=$p($g(^SSU("SSUSR",SSUSRRowId)),"^",127) //是否忽略CA登录控制
		s SSUSRFreeText1 =$p($g(^SSU("SSUSR",SSUSRRowId)),"^",122)  //身份证号
		s SSUSRFreeText2 =$p($g(^SSU("SSUSR",SSUSRRowId)),"^",123)  //性别dr
		s:SSUSRFreeText2'="" SSUSRFreeText2=$p($g(^CT("SEX",SSUSRFreeText2)),"^",2)  //性别描述
		s SSUSRFreeText3 =$p($g(^SSU("SSUSR",SSUSRRowId)),"^",124)  //国家医保代码
		s SSUSRMobile =$p($g(^SSU("SSUSR",SSUSRRowId)),"^",99)  //手机号
		s SSUSRPager =$p($g(^SSU("SSUSR",SSUSRRowId)),"^",100)  //办公室电话
		s SSUSREmail =$p($g(^SSU("SSUSR",SSUSRRowId)),"^",101)  //邮箱
		s SSUSRHOSPersonDR=$p($g(^SSU("SSUSR",SSUSRRowId)),"^",128) //人员标识码
		s:SSUSRHOSPersonDR'="" SSUSRHOSPerson=$listget($g(^CT.BDP.CT.HOSPersonD(SSUSRHOSPersonDR)),3)
		if SSUSRCareProvDR'=""
		{
			s CTPCPCode=$p($g(^CTPCP(SSUSRCareProvDR,1)),"^",1) //医护人员工号
			s CTPCPDesc=$p($g(^CTPCP(SSUSRCareProvDR,1)),"^",2) //医护人员姓名
			s CTPCPId=$p($g(^CTPCP(SSUSRCareProvDR,1)),"^",3) //医护人员标识码
			s CTPCPCarPrvTpDR=$p($g(^CTPCP(SSUSRCareProvDR,1)),"^",4)    //医护人员类型ID
			s CTPCPOtherName=$p($g(^CTPCP(SSUSRCareProvDR,3)),"^",28)  //拼音检索码
			s CTPCPHICApproved=$p($g(^CTPCP(SSUSRCareProvDR,3)),"^",31) 		//毒麻处方权
			s:CTPCPCarPrvTpDR'="" CTCPTDesc=$p($g(^CT("CPT",CTPCPCarPrvTpDR)),"^",2) //医护人员类型
		}
		
		s BDPInternalCode="",BDPInternalDesc="",BDPHospNationalCode="",BDPHospNationalDesc=""  
    	s resultStr=##class(web.DHCBL.BDP.BDPStandardCode).GetStandardCode("SS_User",SSUSRRowId)
    	s BDPInternalCode =$p($g(resultStr),"^",1)       
    	s BDPInternalDesc = $p($g(resultStr),"^",2)  
    	s BDPHospNationalCode=$p($g(resultStr),"^",3)         
    	s BDPHospNationalDesc = $p($g(resultStr),"^",4)	
		//d OutputRow
		w "{""data"":[" 
		w "{""SSUSRRowId"":"""_SSUSRRowId_""",""SSUSRInitials"":"""_SSUSRInitials_""",""CTPCPId"":"""_CTPCPId_""",""SSUSRName"":"""_SSUSRName_""",""SSUSRDefaultDeptDR"":"""_SSUSRDefaultDeptDR_""",""CTLOCDesc"":"""_CTLOCDesc_""",""SSUSRGroupD"":"""_SSUSRGroupD_""",""SSUSRCTLANDR"":"""_SSUSRCTLANDR_""",""SSGRPDesc"":"""_SSGRPDesc_""",""CTPCPCode"":"""_CTPCPCode_""",""CTPCPDesc"":"""_CTPCPDesc_""",""SSUSRCareProvDR"":"""_SSUSRCareProvDR_""",""CTPCPCarPrvTpDR"":"""_CTPCPCarPrvTpDR_""",""CTCPTDesc"":"""_CTCPTDesc_""",""CTPCPOtherName"":"""_CTPCPOtherName_""",""CTPCPHICApproved"":"""_CTPCPHICApproved_""",""SSUSRCTLANDR"":"""_SSUSRCTLANDR_""",""SSUSRChangeLocation"":"""_SSUSRChangeLocation_""",""SSUSRActive"":"""_SSUSRActive_""",""SSUSRLastUpdateUserDR"":"""_SSUSRLastUpdateUserDR_""",""SSUSRLastUpdateDate"":"""_SSUSRLastUpdateDate_""",""SSUSRDateFrom"":"""_SSUSRDateFrom_""",""SSUSRDateTo"":"""_SSUSRDateTo_""",""SSUSRHospitalDR"":"""_SSUSRHospitalDR_""",""HOSPDesc"":"""_HOSPDesc_""",""SSUSRAdmitted"":"""_SSUSRAdmitted_""",""SSUSRIgnoreCALogon"":"""_SSUSRIgnoreCALogon_""",""BDPInternalCode"":"""_BDPInternalCode_""",""BDPInternalDesc"":"""_BDPInternalDesc_""",""BDPHospNationalCode"":"""_BDPHospNationalCode_""",""BDPHospNationalDesc"":"""_BDPHospNationalDesc_""",""SSUSRFreeText3"":"""_SSUSRFreeText3_""",""SSUSRHOSPerson"":"""_SSUSRHOSPerson_"""}" 
 		w "],""total"":""1"",""success"":""true""}"
		
	}
	else
	{
		s (CTLOCDesc,SSGRPDesc,HOSPDesc,CTCPTDesc,CTPCPCode,CTPCPDesc,CTPCPId,CTPCPCarPrvTpDR,CTCPTDesc,CTPCPOtherName,CTPCPHICApproved,SSUSRHOSPerson)=""
		
		k ^TMPSSUSR
		s:Initials'="" Initials=$ZCONVERT(Initials,"U")
		s:CPId'="" CPId=$ZCONVERT(CPId,"U")
		s:Name'="" Name=$ZCONVERT(Name,"U")
		//if (treetype="SSUSRDefaultDeptDR")||(treetype="") s DefaultDeptDR=category
		//if (treetype="RESCTLOCDR") s SCTLOCDR=category
		//if (treetype="SSUSRGroup") s SSUSRGroup=category
		//if (treetype="CTPCPCarPrvTpDR") s CarPrvTpDR=category
		//if (treetype="CTPCPSpecDR") s SpecDR=category
		//if (treetype="SSUSRHospitalDR") s hosp=category
		s HospitalDRs = ##class(web.DHCBL.BDP.BDPGradeManage).GetCurrentHospital(communityid)
		
		s SSUSRRowId=0
		for  
		{
			
			s SSUSRRowId=$o(^SSU("SSUSR",SSUSRRowId)) q:SSUSRRowId=""
			s SSUSRInitials=$p($g(^SSU("SSUSR",SSUSRRowId)),"^",1)       //人事ID
			s SSUSRName=$p($g(^SSU("SSUSR",SSUSRRowId)),"^",2)       //用户名
			s SSUSRHospitalDR=$p($g(^SSU("SSUSR",SSUSRRowId)),"^",98) 	//医院
			s SSUSRDefaultDeptDR=$p($g(^SSU("SSUSR",SSUSRRowId)),"^",4)     //登录科室DR
			s SSUSRGroupD=$p($g(^SSU("SSUSR",SSUSRRowId)),"^",5)  //安全组DR
			s SSUSRCareProvDR=$p($g(^SSU("SSUSR",SSUSRRowId)),"^",14)      //医护人员DR
			s:SSUSRCareProvDR'="" CTPCPCarPrvTpDR=$p($g(^CTPCP(SSUSRCareProvDR,1)),"^",4)    //医护人员类型ID
			s:SSUSRCareProvDR="" CTPCPCarPrvTpDR=""
			s CTCPTInternalType=""
			s:CTPCPCarPrvTpDR'="" CTCPTInternalType=$p($g(^CT("CPT",CTPCPCarPrvTpDR)),"^",4)		//医护人员类型的类型
			s SSUSRFreeText3 =$p($g(^SSU("SSUSR",SSUSRRowId)),"^",124)  //国家医保代码
			s:SSUSRCareProvDR'="" CTPCPSpecDR=$p($g(^CTPCP(SSUSRCareProvDR,1)),"^",10)      //医护人员专长ID
			s:SSUSRCareProvDR="" CTPCPSpecDR=""
			s SSUSRCTLANDR=$p($g(^SSU("SSUSR",SSUSRRowId)),"^",13)      //语言DR		
			s strRowId = "{ID:"_SSUSRRowId_"}"
			s strHospitalID = "{ID:"_SSUSRHospitalDR_"}"
			
			s strDefaultDeptDR = "{ID:"_SSUSRDefaultDeptDR_"}"
			s strGroupD = "{ID:"_SSUSRGroupD_"}"
			s strCareProvDR = "{ID:"_SSUSRCareProvDR_"}"
			s strCarPrvTpDR = "{ID:"_CTPCPCarPrvTpDR_"}"
			s strSpecDR = "{ID:"_CTPCPSpecDR_"}"
			s strCTLANDR = "{ID:"_SSUSRCTLANDR_"}"
			i ((AuStr[strRowId)||(AuFlag=1))&&((AuSSUSRDeptDRStr[strDefaultDeptDR)||(AuSSUSRDeptDRFlag=1))&&((AuSSUSRGroupDStr[strGroupD)||(AuSSUSRGroupDFlag=1))&&((AuSSUSRLANDRStr[strCTLANDR)||(AuSSUSRLANDRFlag=1))&&((AuSSUSRProvDRStr[strCareProvDR)||(AuSSUSRProvDRFlag=1))&&((AuCTPCPPrvTpDRStr[strCarPrvTpDR)||(AuCTPCPPrvTpDRFlag=1))&&((AuCTPCPSpecDRStr[strSpecDR)||(AuCTPCPSpecDRFlag=1))&&((AuSSUSRHospDRStr[strHospitalID)||(AuSSUSRHospDRFlag=1))
			{
				///根据入参过滤数据开始,不匹配跳过执行下一条
				if ($ZCONVERT(SSUSRInitials,"U")'[Initials) continue
				//if (SSUSRHospitalDR'=hosp)&(hosp'="") continue
				if (hosp="0"){ //未定岗用户查询，查询没有关联医院的用户 20230223@gss
					continue:(SSUSRHospitalDR'="") 
				}else{
					s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag(..#SQLTableName,SSUSRRowId,hosp)
	  				continue:showflag="N"
	  			}
				if (CTPCPCarPrvTpDR'=CarPrvTpDR)&(CarPrvTpDR'="") continue
				if (CTPCPSpecDR'=SpecDR)&(SpecDR'="") continue
				
				if (DefaultDeptDR'="")||(SSUSRGroup'=""){
					//其他登陆科室表,根据科室和安全组过滤
					s Flag=0
					s ChildSub=0
					for {
						s ChildSub=$o(^SSU("SSUSR",SSUSRRowId,"OTHLL",ChildSub)) q:ChildSub=""
						s OTHLLCTLOCDR=$p($g(^SSU("SSUSR",SSUSRRowId,"OTHLL",ChildSub)),"^",1)  //登陆科室id
						s OTHLLUserGroupDR=$p($g(^SSU("SSUSR",SSUSRRowId,"OTHLL",ChildSub)),"^",2)  //安全组id	
						if ((OTHLLCTLOCDR=DefaultDeptDR)&(OTHLLUserGroupDR=SSUSRGroup))||((DefaultDeptDR="")&(OTHLLUserGroupDR=SSUSRGroup))||((OTHLLCTLOCDR=DefaultDeptDR)&(SSUSRGroup="")){
							s Flag=1
						}

					}
					if (((SSUSRGroupD'=SSUSRGroup)&(SSUSRGroup'=""))&(Flag'=1))||(((SSUSRDefaultDeptDR'=DefaultDeptDR)&(DefaultDeptDR'=""))&(Flag'=1))  continue
					
				}
				s careDrData=""
				if (SCTLOCDR'=""){
					//指定科室表数据过滤
					s RESRowId1=0
					for
					{
						s RESRowId1=$o(^RB("RES",0,"CTLOC",SCTLOCDR,RESRowId1)) q:RESRowId1="" 
						s RESCTPCPDR=$p($g(^RB("RES",RESRowId1)),"^",2)       //医护人员ID
						continue:RESCTPCPDR=""
						s careDrData = careDrData_",{ID:"_RESCTPCPDR_"}"
					}
				}
				s DSSUSRCareProvDR= "{ID:"_SSUSRCareProvDR_"}"
				if (careDrData'[DSSUSRCareProvDR)&(SCTLOCDR'="") continue
				
				//过滤国家医保代码、医生护士类型
				continue:(countryCodeYN="Y")&&(SSUSRFreeText3="")
				continue:(countryCodeYN="N")&&(SSUSRFreeText3'="")
				continue:(CareProvType'="")&&(CareProvType'="User")&&(CareProvType'=CTCPTInternalType)
				continue:(CareProvType="User")&&(SSUSRCareProvDR'="")
				continue:($ZCONVERT(SSUSRFreeText3,"U")'[$ZCONVERT(insurcode,"U"))
				
				///根据入参过滤数据结束
				
				S sortvalue=SSUSRRowId
				if (sort="SSUSRInitials")
				{
					s sortvalue="S"_##class(web.DHCBL.BDP.FunLib).GetPYCODE(SSUSRInitials)
				}
				if (sort="SSUSRName")
				{
					s sortvalue="S"_##class(web.DHCBL.BDP.FunLib).GetPYCODE(SSUSRName)
				}
				if (sort="CTCPTDesc")
				{
					if CTPCPCarPrvTpDR'=""
					{
						s CTCPTDesc=$p($g(^CT("CPT",CTPCPCarPrvTpDR)),"^",2) //医护人员类型
						s sortvalue="S"_##class(web.DHCBL.BDP.FunLib).GetPYCODE(CTCPTDesc)
					}
					else
					{
						s sortvalue="S0"
					}
				}
				s ^TMPSSUSR(0,sort,sortvalue,SSUSRRowId)=""
			}
		}
		
		//真分页计数
		s total=0
	    s start=start+1
		s CurrentCount=0
		w "{""data"":["
		
		s sortvalue=0,sdir=1   ///ASC,正序
		if (dir="DESC")   //倒序
		{
			s sortvalue="",sdir=-1
		}
		for  
		{			
			s sortvalue=$o(^TMPSSUSR(0,sort,sortvalue),sdir) q:sortvalue=""
			s SSUSRRowId=0
			if (dir="DESC") s SSUSRRowId=""
			for 
			{
				s SSUSRRowId=$o(^TMPSSUSR(0,sort,sortvalue,SSUSRRowId),sdir) q:(SSUSRRowId="")
				s id = SSUSRRowId
				s (CTLOCDesc,SSGRPDesc,HOSPDesc,CTCPTDesc,CTPCPCode,CTPCPDesc,CTPCPId,CTPCPCarPrvTpDR,CTCPTDesc,CTPCPOtherName,CTPCPHICApproved,SSUSRHOSPerson)=""
				s SSUSRInitials=$p($g(^SSU("SSUSR",SSUSRRowId)),"^",1)       //人事ID
				s SSUSRName=$p($g(^SSU("SSUSR",SSUSRRowId)),"^",2)       //用户名护
				s SSUSRDefaultDeptDR=$p($g(^SSU("SSUSR",SSUSRRowId)),"^",4)     //登录科室DR
				s:SSUSRDefaultDeptDR'="" CTLOCDesc=$p($g(^CTLOC(SSUSRDefaultDeptDR)),"^",2) //登录科室名称
				s SSUSRGroupD=$p($g(^SSU("SSUSR",SSUSRRowId)),"^",5)  //安全组DR
				s:SSUSRGroupD'="" SSGRPDesc=$p($g(^SSU("SSGRP",SSUSRGroupD)),"^",1) //安全组名称
				s SSUSRChangeLocation=$p($g(^SSU("SSUSR",SSUSRRowId)),"^",10)    //是否改变登录科室
				s SSUSRCareProvDR=$p($g(^SSU("SSUSR",SSUSRRowId)),"^",14)      //医护人员DR
				
				s SSUSRCTLANDR=$p($g(^SSU("SSUSR",SSUSRRowId)),"^",13)      //语言DR
				s:SSUSRCTLANDR'="" SSUSRCTLANDR=$p($g(^SS("LAN",SSUSRCTLANDR)),"^",2)      //语言
				
				s SSUSRActive=$p($g(^SSU("SSUSR",SSUSRRowId)),"^",19)      //是否激活
				s SSUSRLastUpdateUserDR=$p($g(^SSU("SSUSR",SSUSRRowId)),"^",75)    //更新人
				s:SSUSRLastUpdateUserDR'="" SSUSRLastUpdateUserDR=$p($g(^SSU("SSUSR",SSUSRLastUpdateUserDR)),"^",2)     //更新人
				s SSUSRLastUpdateDate=$p($g(^SSU("SSUSR",SSUSRRowId)),"^",76)    //最后更新日期
				s SSUSRDateFrom=$p($g(^SSU("SSUSR",SSUSRRowId)),"^",96)    //开始日期
				s SSUSRDateTo=$p($g(^SSU("SSUSR",SSUSRRowId)),"^",97)  //结束日期
				s:SSUSRLastUpdateDate'="" SSUSRLastUpdateDate=$zd(SSUSRLastUpdateDate,1) //
				s:SSUSRDateFrom'="" SSUSRDateFrom=$zd(SSUSRDateFrom,1) //转换日期格式
				s:SSUSRDateTo'="" SSUSRDateTo=$zd(SSUSRDateTo,1) //转换日期格式
				s SSUSRHospitalDR=$p($g(^SSU("SSUSR",SSUSRRowId)),"^",98)      //医院DR
				s:SSUSRHospitalDR'="" HOSPDesc=$p($g(^CT("HOSP",SSUSRHospitalDR)),"^",2) //医院名称
				s SSUSRAdmitted=$p($g(^SSU("SSUSR",SSUSRRowId)),"^",63) //管理员用户
				s SSUSRIgnoreCALogon=$p($g(^SSU("SSUSR",SSUSRRowId)),"^",127) //是否忽略CA登录控制
				s SSUSRFreeText1 =$p($g(^SSU("SSUSR",SSUSRRowId)),"^",122)  //身份证号
				s SSUSRFreeText2 =$p($g(^SSU("SSUSR",SSUSRRowId)),"^",123)  //性别dr
				s:SSUSRFreeText2'="" SSUSRFreeText2=$p($g(^CT("SEX",SSUSRFreeText2)),"^",2)  //性别描述
				s SSUSRFreeText3 =$p($g(^SSU("SSUSR",SSUSRRowId)),"^",124)  //国家医保代码
				s SSUSRMobile =$p($g(^SSU("SSUSR",SSUSRRowId)),"^",99)  //手机号
				s SSUSRPager =$p($g(^SSU("SSUSR",SSUSRRowId)),"^",100)  //办公室电话
				s SSUSREmail =$p($g(^SSU("SSUSR",SSUSRRowId)),"^",101)  //邮箱
				s SSUSRHOSPersonDR=$p($g(^SSU("SSUSR",SSUSRRowId)),"^",128) //人员标识码
				s:SSUSRHOSPersonDR'="" SSUSRHOSPerson=$listget($g(^CT.BDP.CT.HOSPersonD(SSUSRHOSPersonDR)),3)
				if SSUSRCareProvDR'=""
				{
					s CTPCPCode=$p($g(^CTPCP(SSUSRCareProvDR,1)),"^",1) //医护人员工号
					s CTPCPDesc=$p($g(^CTPCP(SSUSRCareProvDR,1)),"^",2) //医护人员姓名
					s CTPCPId=$p($g(^CTPCP(SSUSRCareProvDR,1)),"^",3) //医护人员标识码
					s CTPCPCarPrvTpDR=$p($g(^CTPCP(SSUSRCareProvDR,1)),"^",4)    //医护人员类型ID
					s CTPCPOtherName=$p($g(^CTPCP(SSUSRCareProvDR,3)),"^",28)  //拼音检索码
					s CTPCPHICApproved=$p($g(^CTPCP(SSUSRCareProvDR,3)),"^",31) 		//毒麻处方权
					s:CTPCPCarPrvTpDR'="" CTCPTDesc=$p($g(^CT("CPT",CTPCPCarPrvTpDR)),"^",2) //医护人员类型
				}
		
				s BDPInternalCode="",BDPInternalDesc="",BDPHospNationalCode="",BDPHospNationalDesc=""  
				s resultStr=##class(web.DHCBL.BDP.BDPStandardCode).GetStandardCode("SS_User",SSUSRRowId)
				s BDPInternalCode =$p($g(resultStr),"^",1)       
				s BDPInternalDesc = $p($g(resultStr),"^",2)  
				s BDPHospNationalCode=$p($g(resultStr),"^",3)         
				s BDPHospNationalDesc = $p($g(resultStr),"^",4)	

				if (Name'="")
	   			{
	    			;需要对描述或者别名进行检索      
	    			s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("SS_User",SSUSRRowId,SSUSRName,Name)
	   			}
	   			else
	   			{
	     			s AliasFlag= 1   
	   			}  
				
				
				s HospitalDR = "<"_SSUSRHospitalDR_">"
				
				i ($ZCONVERT(SSUSRInitials,"U")[Initials)&(($ZCONVERT(CTPCPId,"U")[CPId)||(CPId=""))&(AliasFlag=1)&((SSUSRActive=Active)||(Active=""))  //条件
				{
					if (communityid'="")
					{
						if (HospitalDRs[HospitalDR) //d OutputRow
						{
							s total=total+1
							if (total<start) continue
							if (total>(start+limit-1)) continue
							if CurrentCount'=0 w ","
            				s CurrentCount=CurrentCount+1
							w "{""SSUSRRowId"":"""_SSUSRRowId_""",""SSUSRInitials"":"""_SSUSRInitials_""",""CTPCPId"":"""_CTPCPId_""",""SSUSRName"":"""_SSUSRName_""",""SSUSRDefaultDeptDR"":"""_SSUSRDefaultDeptDR_""",""CTLOCDesc"":"""_CTLOCDesc_""",""SSUSRGroupD"":"""_SSUSRGroupD_""",""SSUSRCTLANDR"":"""_SSUSRCTLANDR_""",""SSGRPDesc"":"""_SSGRPDesc_""",""CTPCPCode"":"""_CTPCPCode_""",""CTPCPDesc"":"""_CTPCPDesc_""",""SSUSRCareProvDR"":"""_SSUSRCareProvDR_""",""CTPCPCarPrvTpDR"":"""_CTPCPCarPrvTpDR_""",""CTCPTDesc"":"""_CTCPTDesc_""",""CTPCPOtherName"":"""_CTPCPOtherName_""",""CTPCPHICApproved"":"""_CTPCPHICApproved_""",""SSUSRCTLANDR"":"""_SSUSRCTLANDR_""",""SSUSRChangeLocation"":"""_SSUSRChangeLocation_""",""SSUSRActive"":"""_SSUSRActive_""",""SSUSRLastUpdateUserDR"":"""_SSUSRLastUpdateUserDR_""",""SSUSRLastUpdateDate"":"""_SSUSRLastUpdateDate_""",""SSUSRDateFrom"":"""_SSUSRDateFrom_""",""SSUSRDateTo"":"""_SSUSRDateTo_""",""SSUSRHospitalDR"":"""_SSUSRHospitalDR_""",""HOSPDesc"":"""_HOSPDesc_""",""SSUSRAdmitted"":"""_SSUSRAdmitted_""",""SSUSRIgnoreCALogon"":"""_SSUSRIgnoreCALogon_""",""BDPInternalCode"":"""_BDPInternalCode_""",""BDPInternalDesc"":"""_BDPInternalDesc_""",""BDPHospNationalCode"":"""_BDPHospNationalCode_""",""BDPHospNationalDesc"":"""_BDPHospNationalDesc_""",""SSUSRFreeText3"":"""_SSUSRFreeText3_""",""SSUSRHOSPerson"":"""_SSUSRHOSPerson_"""}" 
						}
					}
					else{
						s total=total+1
						if (total<start) continue
						if (total>(start+limit-1)) continue
						//d OutputRow
						if CurrentCount'=0 w ","
            			s CurrentCount=CurrentCount+1
						w "{""SSUSRRowId"":"""_SSUSRRowId_""",""SSUSRInitials"":"""_SSUSRInitials_""",""CTPCPId"":"""_CTPCPId_""",""SSUSRName"":"""_SSUSRName_""",""SSUSRDefaultDeptDR"":"""_SSUSRDefaultDeptDR_""",""CTLOCDesc"":"""_CTLOCDesc_""",""SSUSRGroupD"":"""_SSUSRGroupD_""",""SSUSRCTLANDR"":"""_SSUSRCTLANDR_""",""SSGRPDesc"":"""_SSGRPDesc_""",""CTPCPCode"":"""_CTPCPCode_""",""CTPCPDesc"":"""_CTPCPDesc_""",""SSUSRCareProvDR"":"""_SSUSRCareProvDR_""",""CTPCPCarPrvTpDR"":"""_CTPCPCarPrvTpDR_""",""CTCPTDesc"":"""_CTCPTDesc_""",""CTPCPOtherName"":"""_CTPCPOtherName_""",""CTPCPHICApproved"":"""_CTPCPHICApproved_""",""SSUSRCTLANDR"":"""_SSUSRCTLANDR_""",""SSUSRChangeLocation"":"""_SSUSRChangeLocation_""",""SSUSRActive"":"""_SSUSRActive_""",""SSUSRLastUpdateUserDR"":"""_SSUSRLastUpdateUserDR_""",""SSUSRLastUpdateDate"":"""_SSUSRLastUpdateDate_""",""SSUSRDateFrom"":"""_SSUSRDateFrom_""",""SSUSRDateTo"":"""_SSUSRDateTo_""",""SSUSRHospitalDR"":"""_SSUSRHospitalDR_""",""HOSPDesc"":"""_HOSPDesc_""",""SSUSRAdmitted"":"""_SSUSRAdmitted_""",""SSUSRIgnoreCALogon"":"""_SSUSRIgnoreCALogon_""",""BDPInternalCode"":"""_BDPInternalCode_""",""BDPInternalDesc"":"""_BDPInternalDesc_""",""BDPHospNationalCode"":"""_BDPHospNationalCode_""",""BDPHospNationalDesc"":"""_BDPHospNationalDesc_""",""SSUSRFreeText3"":"""_SSUSRFreeText3_""",""SSUSRHOSPerson"":"""_SSUSRHOSPerson_"""}" 
					}
				}
			}
		}
		w "],""total"":"""_total_""",""success"":""true""}"
		k ^TMPSSUSR
	}
	q ""
}

/// Creator：蔡昊哲
/// CreatDate: 2013-4-27
/// Description：查询用户内容
/// Table：User.SSUser
/// Input：RowId1, Code, Desc, CTPCPCarPrvTpDR, ActiveFlag, InternalType
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.CT.SSUser","GetList","","","","","","","","","","","","","","","","SSUSRInitials","")
Query GetList(rowid, Initials, CPId, Name, SSUSRGroup, AdminGroupDR, DefaultDeptDR, CarPrvTpDR, SpecDR, communityid, SCTLOCDR, hosp, Active, treetype, category, sort, dir) As %Query(ROWSPEC = "SSUSRRowId,SSUSRInitials,CTPCPId,SSUSRName,SSUSRDefaultDeptDR,CTLOCDesc,SSUSRGroupD,SSUSRCTLANDR,SSGRPDesc,CTPCPCode,CTPCPDesc,SSUSRCareProvDR,CTPCPCarPrvTpDR,CTCPTDesc,CTPCPOtherName,CTPCPHICApproved,SSUSRCTLANDR,SSUSRChangeLocation,SSUSRActive,SSUSRLastUpdateUserDR,SSUSRLastUpdateDate,SSUSRDateFrom,SSUSRDateTo,SSUSRHospitalDR,HOSPDesc,SSUSRAdmitted,SSUSRIgnoreCALogon,BDPInternalCode,BDPInternalDesc,BDPHospNationalCode,BDPHospNationalDesc")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid, Initials, CPId, Name, SSUSRGroup, AdminGroupDR, DefaultDeptDR, CarPrvTpDR, SpecDR, communityid, SCTLOCDR, hosp, Active, treetype, category, sort, dir) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	//获取授权Json
	s AuStr=##class(web.DHCBL.Authorize.SSUser).DHCGetDataByDefaultSession()
	;这地方加个方法---获取基本配置中未授权的情况下是否显示数据
	;假设未授权情况下默认全部显示数据
	
	s AuHospStr=##class(web.DHCBL.Authorize.BDPHospitalAut).GetHospAutFlag()
	
	s AuSSUSRDeptDRStr=##class(web.DHCBL.Authorize.CTLoc).DHCGetDataByDefaultSession() //默认登录科室
	s AuSSUSRGroupDStr=##class(web.DHCBL.Authorize.SSGroup).DHCGetDataByDefaultSession() //安全组
	s AuSSUSRLANDRStr=##class(web.DHCBL.Authorize.SSLanguage).DHCGetDataByDefaultSession() //默认语言
	s AuSSUSRHospDRStr=##class(web.DHCBL.Authorize.CTHospital).DHCGetDataByDefaultSession() //关联医院
	s AuSSUSRProvDRStr=##class(web.DHCBL.Authorize.CTCareProv).DHCGetDataByDefaultSession() //医护人员
	s AuCTPCPPrvTpDRStr=##class(web.DHCBL.Authorize.CTCarPrvTp).DHCGetDataByDefaultSession() //医护人员类型
	s AuCTPCPSpecDRStr=##class(web.DHCBL.Authorize.CTSpec).DHCGetDataByDefaultSession() //医生专长
	
	s AuFlag=0
	if (AuStr="")||(AuStr["limited:0") s AuFlag=1
	
	s AuSSUSRDeptDRFlag=0
	if (AuSSUSRDeptDRStr="")||(AuSSUSRDeptDRStr["limited:0") s AuSSUSRDeptDRFlag=1
	s AuSSUSRGroupDFlag=0
	if (AuSSUSRGroupDStr="")||(AuSSUSRGroupDStr["limited:0") s AuSSUSRGroupDFlag=1
	s AuSSUSRLANDRFlag=0
	if (AuSSUSRLANDRStr="")||(AuSSUSRLANDRStr["limited:0") s AuSSUSRLANDRFlag=1
	s AuSSUSRHospDRFlag=0
	if (AuSSUSRHospDRStr="")||(AuSSUSRHospDRStr["limited:0") s AuSSUSRHospDRFlag=1
	s AuSSUSRProvDRFlag=0
	if (AuSSUSRProvDRStr="")||(AuSSUSRProvDRStr["limited:0") s AuSSUSRProvDRFlag=1
	s AuCTPCPPrvTpDRFlag=0
	if (AuCTPCPPrvTpDRStr="")||(AuCTPCPPrvTpDRStr["limited:0") s AuCTPCPPrvTpDRFlag=1
	s AuCTPCPSpecDRFlag=0
	if (AuCTPCPSpecDRStr="")||(AuCTPCPSpecDRStr["limited:0") s AuCTPCPSpecDRFlag=1
	
	if (rowid'="") //根据rowid返回该条记录
	{
		s (CTLOCDesc,SSGRPDesc,HOSPDesc,CTCPTDesc,CTPCPCode,CTPCPDesc,CTPCPId,CTPCPCarPrvTpDR,CTCPTDesc,CTPCPOtherName,CTPCPHICApproved)=""
		s SSUSRRowId=rowid
		s SSUSRInitials=$p($g(^SSU("SSUSR",SSUSRRowId)),"^",1)       //人事ID
		s SSUSRName=$p($g(^SSU("SSUSR",SSUSRRowId)),"^",2)       //用户名护
		s SSUSRDefaultDeptDR=$p($g(^SSU("SSUSR",SSUSRRowId)),"^",4)     //登录科室DR
		s:SSUSRDefaultDeptDR'="" CTLOCDesc=$p($g(^CTLOC(SSUSRDefaultDeptDR)),"^",2) //登录科室名称
		s SSUSRGroupD=$p($g(^SSU("SSUSR",SSUSRRowId)),"^",5)  //安全组DR
		s:SSUSRGroupD'="" SSGRPDesc=$p($g(^SSU("SSGRP",SSUSRGroupD)),"^",1) //安全组名称
		s SSUSRChangeLocation=$p($g(^SSU("SSUSR",SSUSRRowId)),"^",10)    //是否改变登录科室
		s SSUSRCareProvDR=$p($g(^SSU("SSUSR",SSUSRRowId)),"^",14)      //医护人员DR
		
		s SSUSRCTLANDR=$p($g(^SSU("SSUSR",SSUSRRowId)),"^",13)      //语言DR
		s:SSUSRCTLANDR'="" SSUSRCTLANDR=$p($g(^SS("LAN",SSUSRCTLANDR)),"^",2)      //语言
		
		s SSUSRActive=$p($g(^SSU("SSUSR",SSUSRRowId)),"^",19)      //是否激活
		s SSUSRLastUpdateUserDR=$p($g(^SSU("SSUSR",SSUSRRowId)),"^",75)    //更新人
		s:SSUSRLastUpdateUserDR'="" SSUSRLastUpdateUserDR=$p($g(^SSU("SSUSR",SSUSRLastUpdateUserDR)),"^",2)     //更新人
		s SSUSRLastUpdateDate=$p($g(^SSU("SSUSR",SSUSRRowId)),"^",76)    //最后更新日期
		s SSUSRDateFrom=$p($g(^SSU("SSUSR",SSUSRRowId)),"^",96)    //开始日期
		s SSUSRDateTo=$p($g(^SSU("SSUSR",SSUSRRowId)),"^",97)  //结束日期
		s:SSUSRLastUpdateDate'="" SSUSRLastUpdateDate=$zd(SSUSRLastUpdateDate,1) //
		s:SSUSRDateFrom'="" SSUSRDateFrom=$zd(SSUSRDateFrom,1) //转换日期格式
		s:SSUSRDateTo'="" SSUSRDateTo=$zd(SSUSRDateTo,1) //转换日期格式
		s SSUSRHospitalDR=$p($g(^SSU("SSUSR",SSUSRRowId)),"^",98)      //医院DR
		s:SSUSRHospitalDR'="" HOSPDesc=$p($g(^CT("HOSP",SSUSRHospitalDR)),"^",2) //医院名称
		s SSUSRAdmitted=$p($g(^SSU("SSUSR",SSUSRRowId)),"^",63) //管理员用户
		s SSUSRIgnoreCALogon=$p($g(^SSU("SSUSR",SSUSRRowId)),"^",127) //是否忽略CA登录控制
		s SSUSRFreeText1 =$p($g(^SSU("SSUSR",SSUSRRowId)),"^",122)  //身份证号
		s SSUSRFreeText2 =$p($g(^SSU("SSUSR",SSUSRRowId)),"^",123)  //性别dr
		s:SSUSRFreeText2'="" SSUSRFreeText2=$p($g(^CT("SEX",SSUSRFreeText2)),"^",2)  //性别描述
		s SSUSRFreeText3 =$p($g(^SSU("SSUSR",SSUSRRowId)),"^",124)  //电话
		s SSUSRMobile =$p($g(^SSU("SSUSR",SSUSRRowId)),"^",99)  //手机号
		s SSUSRPager =$p($g(^SSU("SSUSR",SSUSRRowId)),"^",100)  //办公室电话
		s SSUSREmail =$p($g(^SSU("SSUSR",SSUSRRowId)),"^",101)  //邮箱
		if SSUSRCareProvDR'=""
		{
			s CTPCPCode=$p($g(^CTPCP(SSUSRCareProvDR,1)),"^",1) //医护人员工号
			s CTPCPDesc=$p($g(^CTPCP(SSUSRCareProvDR,1)),"^",2) //医护人员姓名
			s CTPCPId=$p($g(^CTPCP(SSUSRCareProvDR,1)),"^",3) //医护人员标识码
			s CTPCPCarPrvTpDR=$p($g(^CTPCP(SSUSRCareProvDR,1)),"^",4)    //医护人员类型ID
			s CTPCPOtherName=$p($g(^CTPCP(SSUSRCareProvDR,3)),"^",28)  //拼音检索码
			s CTPCPHICApproved=$p($g(^CTPCP(SSUSRCareProvDR,3)),"^",31) 		//毒麻处方权
			s:CTPCPCarPrvTpDR'="" CTCPTDesc=$p($g(^CT("CPT",CTPCPCarPrvTpDR)),"^",2) //医护人员类型
		}
		
		s BDPInternalCode="",BDPInternalDesc="",BDPHospNationalCode="",BDPHospNationalDesc=""  
    	s resultStr=##class(web.DHCBL.BDP.BDPStandardCode).GetStandardCode("SS_User",SSUSRRowId)
    	s BDPInternalCode =$p($g(resultStr),"^",1)       
    	s BDPInternalDesc = $p($g(resultStr),"^",2)  
    	s BDPHospNationalCode=$p($g(resultStr),"^",3)         
    	s BDPHospNationalDesc = $p($g(resultStr),"^",4)	
		d OutputRow
	}
	else
	{
		s (CTLOCDesc,SSGRPDesc,HOSPDesc,CTCPTDesc,CTPCPCode,CTPCPDesc,CTPCPId,CTPCPCarPrvTpDR,CTCPTDesc,CTPCPOtherName,CTPCPHICApproved)=""
		
		k ^TMPSSUSR
		s:Initials'="" Initials=$ZCONVERT(Initials,"U")
		s:CPId'="" CPId=$ZCONVERT(CPId,"U")
		s:Name'="" Name=$ZCONVERT(Name,"U")
		if (treetype="SSUSRDefaultDeptDR")||(treetype="") s DefaultDeptDR=category
		if (treetype="RESCTLOCDR") s SCTLOCDR=category
		if (treetype="SSUSRGroup") s SSUSRGroup=category
		if (treetype="CTPCPCarPrvTpDR") s CarPrvTpDR=category
		if (treetype="CTPCPSpecDR") s SpecDR=category
		if (treetype="SSUSRHospitalDR") s hosp=category
		s HospitalDRs = ##class(web.DHCBL.BDP.BDPGradeManage).GetCurrentHospital(communityid)
		s SSUSRRowId=0
		for  
		{
			
			s SSUSRRowId=$o(^SSU("SSUSR",SSUSRRowId)) q:SSUSRRowId=""
			s SSUSRInitials=$p($g(^SSU("SSUSR",SSUSRRowId)),"^",1)       //人事ID
			s SSUSRName=$p($g(^SSU("SSUSR",SSUSRRowId)),"^",2)       //用户名
			s SSUSRHospitalDR=$p($g(^SSU("SSUSR",SSUSRRowId)),"^",98) 	//医院
			s SSUSRDefaultDeptDR=$p($g(^SSU("SSUSR",SSUSRRowId)),"^",4)     //登录科室DR
			s SSUSRGroupD=$p($g(^SSU("SSUSR",SSUSRRowId)),"^",5)  //安全组DR
			s SSUSRCareProvDR=$p($g(^SSU("SSUSR",SSUSRRowId)),"^",14)      //医护人员DR
			s:SSUSRCareProvDR'="" CTPCPCarPrvTpDR=$p($g(^CTPCP(SSUSRCareProvDR,1)),"^",4)    //医护人员类型ID
			s:SSUSRCareProvDR="" CTPCPCarPrvTpDR=""
			s:SSUSRCareProvDR'="" CTPCPSpecDR=$p($g(^CTPCP(SSUSRCareProvDR,1)),"^",10)      //医护人员专长ID
			s:SSUSRCareProvDR="" CTPCPSpecDR=""
			s SSUSRCTLANDR=$p($g(^SSU("SSUSR",SSUSRRowId)),"^",13)      //语言DR		
			s strRowId = "{ID:"_SSUSRRowId_"}"
			s strHospitalID = "{ID:"_SSUSRHospitalDR_"}"
			
			s strDefaultDeptDR = "{ID:"_SSUSRDefaultDeptDR_"}"
			s strGroupD = "{ID:"_SSUSRGroupD_"}"
			s strCareProvDR = "{ID:"_SSUSRCareProvDR_"}"
			s strCarPrvTpDR = "{ID:"_CTPCPCarPrvTpDR_"}"
			s strSpecDR = "{ID:"_CTPCPSpecDR_"}"
			s strCTLANDR = "{ID:"_SSUSRCTLANDR_"}"
			i ((AuHospStr[strHospitalID)||(AuHospStr=1)||(AuHospStr="off"))&&((AuStr[strRowId)||(AuFlag=1))&&((AuSSUSRDeptDRStr[strDefaultDeptDR)||(AuSSUSRDeptDRFlag=1))&&((AuSSUSRGroupDStr[strGroupD)||(AuSSUSRGroupDFlag=1))&&((AuSSUSRLANDRStr[strCTLANDR)||(AuSSUSRLANDRFlag=1))&&((AuSSUSRProvDRStr[strCareProvDR)||(AuSSUSRProvDRFlag=1))&&((AuCTPCPPrvTpDRStr[strCarPrvTpDR)||(AuCTPCPPrvTpDRFlag=1))&&((AuCTPCPSpecDRStr[strSpecDR)||(AuCTPCPSpecDRFlag=1))&&((AuSSUSRHospDRStr[strHospitalID)||(AuSSUSRHospDRFlag=1))
			{
				///根据入参过滤数据开始,不匹配跳过执行下一条
				if ($ZCONVERT(SSUSRInitials,"U")'[Initials) continue
				if (SSUSRHospitalDR'=hosp)&(hosp'="") continue
				if (CTPCPCarPrvTpDR'=CarPrvTpDR)&(CarPrvTpDR'="") continue
				if (CTPCPSpecDR'=SpecDR)&(SpecDR'="") continue
				
				if (DefaultDeptDR'="")||(SSUSRGroup'=""){
					//其他登陆科室表,根据科室和安全组过滤
					s Flag=0
					s ChildSub=0
					for {
						s ChildSub=$o(^SSU("SSUSR",SSUSRRowId,"OTHLL",ChildSub)) q:ChildSub=""
						s OTHLLCTLOCDR=$p($g(^SSU("SSUSR",SSUSRRowId,"OTHLL",ChildSub)),"^",1)  //登陆科室id
						s OTHLLUserGroupDR=$p($g(^SSU("SSUSR",SSUSRRowId,"OTHLL",ChildSub)),"^",2)  //安全组id	
						if ((OTHLLCTLOCDR=DefaultDeptDR)&(OTHLLUserGroupDR=SSUSRGroup))||((DefaultDeptDR="")&(OTHLLUserGroupDR=SSUSRGroup))||((OTHLLCTLOCDR=DefaultDeptDR)&(SSUSRGroup="")){
							s Flag=1
						}

					}
					if (((SSUSRGroupD'=SSUSRGroup)&(SSUSRGroup'=""))&(Flag'=1))||(((SSUSRDefaultDeptDR'=DefaultDeptDR)&(DefaultDeptDR'=""))&(Flag'=1))  continue
					
				}
				s careDrData=""
				if (SCTLOCDR'=""){
					//指定科室表数据过滤
					s RESRowId1=0
					for
					{
						s RESRowId1=$o(^RB("RES",0,"CTLOC",SCTLOCDR,RESRowId1)) q:RESRowId1="" 
						s RESCTPCPDR=$p($g(^RB("RES",RESRowId1)),"^",2)       //医护人员ID
						continue:RESCTPCPDR=""
						s careDrData = careDrData_",{ID:"_RESCTPCPDR_"}"
					}
				}
				s DSSUSRCareProvDR= "{ID:"_SSUSRCareProvDR_"}"
				if (careDrData'[DSSUSRCareProvDR)&(SCTLOCDR'="") continue
				///根据入参过滤数据结束
				
				S sortvalue=SSUSRRowId
				if (sort="SSUSRInitials")
				{
					s sortvalue="S"_##class(web.DHCBL.BDP.FunLib).GetPYCODE(SSUSRInitials)
				}
				if (sort="SSUSRName")
				{
					s sortvalue="S"_##class(web.DHCBL.BDP.FunLib).GetPYCODE(SSUSRName)
				}
				if (sort="CTCPTDesc")
				{
					if CTPCPCarPrvTpDR'=""
					{
						s CTCPTDesc=$p($g(^CT("CPT",CTPCPCarPrvTpDR)),"^",2) //医护人员类型
						s sortvalue="S"_##class(web.DHCBL.BDP.FunLib).GetPYCODE(CTCPTDesc)
					}
					else
					{
						s sortvalue="S0"
					}
				}
				s ^TMPSSUSR(0,sort,sortvalue,SSUSRRowId)=""
			}
		}
		s sortvalue=0,sdir=1   ///ASC,正序
		if (dir="DESC")   //倒序
		{
			s sortvalue="",sdir=-1
		}
		for  
		{			
			s sortvalue=$o(^TMPSSUSR(0,sort,sortvalue),sdir) q:sortvalue=""
			s SSUSRRowId=0
			if (dir="DESC") s SSUSRRowId=""
			for 
			{
				s SSUSRRowId=$o(^TMPSSUSR(0,sort,sortvalue,SSUSRRowId),sdir) q:(SSUSRRowId="")
				s id = SSUSRRowId
				s (CTLOCDesc,SSGRPDesc,HOSPDesc,CTCPTDesc,CTPCPCode,CTPCPDesc,CTPCPId,CTPCPCarPrvTpDR,CTCPTDesc,CTPCPOtherName,CTPCPHICApproved)=""
				s SSUSRInitials=$p($g(^SSU("SSUSR",SSUSRRowId)),"^",1)       //人事ID
				s SSUSRName=$p($g(^SSU("SSUSR",SSUSRRowId)),"^",2)       //用户名护
				s SSUSRDefaultDeptDR=$p($g(^SSU("SSUSR",SSUSRRowId)),"^",4)     //登录科室DR
				s:SSUSRDefaultDeptDR'="" CTLOCDesc=$p($g(^CTLOC(SSUSRDefaultDeptDR)),"^",2) //登录科室名称
				s SSUSRGroupD=$p($g(^SSU("SSUSR",SSUSRRowId)),"^",5)  //安全组DR
				s:SSUSRGroupD'="" SSGRPDesc=$p($g(^SSU("SSGRP",SSUSRGroupD)),"^",1) //安全组名称
				s SSUSRChangeLocation=$p($g(^SSU("SSUSR",SSUSRRowId)),"^",10)    //是否改变登录科室
				s SSUSRCareProvDR=$p($g(^SSU("SSUSR",SSUSRRowId)),"^",14)      //医护人员DR
				
				s SSUSRCTLANDR=$p($g(^SSU("SSUSR",SSUSRRowId)),"^",13)      //语言DR
				s:SSUSRCTLANDR'="" SSUSRCTLANDR=$p($g(^SS("LAN",SSUSRCTLANDR)),"^",2)      //语言
				
				s SSUSRActive=$p($g(^SSU("SSUSR",SSUSRRowId)),"^",19)      //是否激活
				s SSUSRLastUpdateUserDR=$p($g(^SSU("SSUSR",SSUSRRowId)),"^",75)    //更新人
				s:SSUSRLastUpdateUserDR'="" SSUSRLastUpdateUserDR=$p($g(^SSU("SSUSR",SSUSRLastUpdateUserDR)),"^",2)     //更新人
				s SSUSRLastUpdateDate=$p($g(^SSU("SSUSR",SSUSRRowId)),"^",76)    //最后更新日期
				s SSUSRDateFrom=$p($g(^SSU("SSUSR",SSUSRRowId)),"^",96)    //开始日期
				s SSUSRDateTo=$p($g(^SSU("SSUSR",SSUSRRowId)),"^",97)  //结束日期
				s:SSUSRLastUpdateDate'="" SSUSRLastUpdateDate=$zd(SSUSRLastUpdateDate,1) //
				s:SSUSRDateFrom'="" SSUSRDateFrom=$zd(SSUSRDateFrom,1) //转换日期格式
				s:SSUSRDateTo'="" SSUSRDateTo=$zd(SSUSRDateTo,1) //转换日期格式
				s SSUSRHospitalDR=$p($g(^SSU("SSUSR",SSUSRRowId)),"^",98)      //医院DR
				s:SSUSRHospitalDR'="" HOSPDesc=$p($g(^CT("HOSP",SSUSRHospitalDR)),"^",2) //医院名称
				s SSUSRAdmitted=$p($g(^SSU("SSUSR",SSUSRRowId)),"^",63) //管理员用户
				s SSUSRIgnoreCALogon=$p($g(^SSU("SSUSR",SSUSRRowId)),"^",127) //是否忽略CA登录控制
				s SSUSRFreeText1 =$p($g(^SSU("SSUSR",SSUSRRowId)),"^",122)  //身份证号
				s SSUSRFreeText2 =$p($g(^SSU("SSUSR",SSUSRRowId)),"^",123)  //性别dr
				s:SSUSRFreeText2'="" SSUSRFreeText2=$p($g(^CT("SEX",SSUSRFreeText2)),"^",2)  //性别描述
				s SSUSRFreeText3 =$p($g(^SSU("SSUSR",SSUSRRowId)),"^",124)  //电话
				s SSUSRMobile =$p($g(^SSU("SSUSR",SSUSRRowId)),"^",99)  //手机号
				s SSUSRPager =$p($g(^SSU("SSUSR",SSUSRRowId)),"^",100)  //办公室电话
				s SSUSREmail =$p($g(^SSU("SSUSR",SSUSRRowId)),"^",101)  //邮箱
				if SSUSRCareProvDR'=""
				{
					s CTPCPCode=$p($g(^CTPCP(SSUSRCareProvDR,1)),"^",1) //医护人员工号
					s CTPCPDesc=$p($g(^CTPCP(SSUSRCareProvDR,1)),"^",2) //医护人员姓名
					s CTPCPId=$p($g(^CTPCP(SSUSRCareProvDR,1)),"^",3) //医护人员标识码
					s CTPCPCarPrvTpDR=$p($g(^CTPCP(SSUSRCareProvDR,1)),"^",4)    //医护人员类型ID
					s CTPCPOtherName=$p($g(^CTPCP(SSUSRCareProvDR,3)),"^",28)  //拼音检索码
					s CTPCPHICApproved=$p($g(^CTPCP(SSUSRCareProvDR,3)),"^",31) 		//毒麻处方权
					s:CTPCPCarPrvTpDR'="" CTCPTDesc=$p($g(^CT("CPT",CTPCPCarPrvTpDR)),"^",2) //医护人员类型
				}
		
				s BDPInternalCode="",BDPInternalDesc="",BDPHospNationalCode="",BDPHospNationalDesc=""  
				s resultStr=##class(web.DHCBL.BDP.BDPStandardCode).GetStandardCode("SS_User",SSUSRRowId)
				s BDPInternalCode =$p($g(resultStr),"^",1)       
				s BDPInternalDesc = $p($g(resultStr),"^",2)  
				s BDPHospNationalCode=$p($g(resultStr),"^",3)         
				s BDPHospNationalDesc = $p($g(resultStr),"^",4)	

				if (Name'="")
	   			{
	    			;需要对描述或者别名进行检索      
	    			s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("SS_User",SSUSRRowId,SSUSRName,Name)
	   			}
	   			else
	   			{
	     			s AliasFlag= 1   
	   			}  
				
				
				s HospitalDR = "<"_SSUSRHospitalDR_">"
				
				i ($ZCONVERT(SSUSRInitials,"U")[Initials)&(($ZCONVERT(CTPCPId,"U")[CPId)||(CPId=""))&(AliasFlag=1)&((SSUSRActive=Active)||(Active=""))  //条件
				{
					if (communityid'="")
					{
						if (HospitalDRs[HospitalDR) d OutputRow
					}
					else{
						d OutputRow
					}
				}
			}
		} 	 
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    set Data=$lb(SSUSRRowId,SSUSRInitials,CTPCPId,SSUSRName,SSUSRDefaultDeptDR,CTLOCDesc,SSUSRGroupD,SSUSRCTLANDR,SSGRPDesc,CTPCPCode,CTPCPDesc,SSUSRCareProvDR,CTPCPCarPrvTpDR,CTCPTDesc,CTPCPOtherName,CTPCPHICApproved,SSUSRCTLANDR,SSUSRChangeLocation,SSUSRActive,SSUSRLastUpdateUserDR,SSUSRLastUpdateDate,SSUSRDateFrom,SSUSRDateTo,SSUSRHospitalDR,HOSPDesc,SSUSRAdmitted,SSUSRIgnoreCALogon,BDPInternalCode,BDPInternalDesc,BDPHospNationalCode,BDPHospNationalDesc)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	
	Set ind=$o(^CacheTemp(repid,ind))
	If ind=""
	{
		//if there are no more rows,finish fetching...
		Set AtEnd=1
		Set Row=""
	}
	Else
	{
		Set Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator:高姗姗
/// CreatDate:2015-3-27
/// Description:查询 用户 
/// Input:desc
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.CT.SSUser","GetDataForCmb1","","")
Query GetDataForCmb1(rowid As %String, desc As %String, hospid As %String = "") As %Query(ROWSPEC = "SSUSRRowId:%String,SSUSRInitials:%String,SSUSRName:%String")
{
}

ClassMethod GetDataForCmb1Execute(ByRef qHandle As %Binary, rowid As %String, desc As %String, hospid As %String = "") As %Status
{
	s repid=$I(^CacheTemp) ;取最大节点,避免和别人重复使用globals
	s ind=1
	if (rowid'="")
	{
		s SSUSRRowId=rowid
		s SSUSRInitials=$p($g(^SSU("SSUSR",SSUSRRowId)),"^",1)		//人事ID
		s SSUSRName=$p($g(^SSU("SSUSR",SSUSRRowId)),"^",2)       //用户名
		s SSUSRName=SSUSRInitials_"-"_SSUSRName
		d OutputRowCmb
	}
	else
	{

		s:desc'="" desc=$ZCONVERT(desc,"U")
		
		s AuStr=##class(web.DHCBL.Authorize.SSUser).DHCGetDataByDefaultSession()
		//s AuHospStr=##class(web.DHCBL.Authorize.BDPHospitalAut).GetHospAutFlag()
		
		s AuSSUSRDeptDRStr=##class(web.DHCBL.Authorize.CTLoc).DHCGetDataByDefaultSession() //默认登录科室
		s AuSSUSRGroupDStr=##class(web.DHCBL.Authorize.SSGroup).DHCGetDataByDefaultSession() //安全组
		s AuSSUSRLANDRStr=##class(web.DHCBL.Authorize.SSLanguage).DHCGetDataByDefaultSession() //默认语言
		s AuSSUSRHospDRStr=##class(web.DHCBL.Authorize.CTHospital).DHCGetDataByDefaultSession() //关联医院
		s AuSSUSRProvDRStr=##class(web.DHCBL.Authorize.CTCareProv).DHCGetDataByDefaultSession() //关联医护人员
		s AuCTPCPPrvTpDRStr=##class(web.DHCBL.Authorize.CTCarPrvTp).DHCGetDataByDefaultSession() //医护人员类型
		s AuCTPCPSpecDRStr=##class(web.DHCBL.Authorize.CTSpec).DHCGetDataByDefaultSession() //医生专长
	
		s AuFlag=0
		;未授权情况下，默认显示全部数据
		if (AuStr="")||(AuStr["limited:0") s AuFlag=1
		
		s AuSSUSRDeptDRFlag=0
		if (AuSSUSRDeptDRStr="")||(AuSSUSRDeptDRStr["limited:0") s AuSSUSRDeptDRFlag=1
		s AuSSUSRGroupDFlag=0
		if (AuSSUSRGroupDStr="")||(AuSSUSRGroupDStr["limited:0") s AuSSUSRGroupDFlag=1
		s AuSSUSRLANDRFlag=0
		if (AuSSUSRLANDRStr="")||(AuSSUSRLANDRStr["limited:0") s AuSSUSRLANDRFlag=1
		s AuSSUSRHospDRFlag=0
		if (AuSSUSRHospDRStr="")||(AuSSUSRHospDRStr["limited:0") s AuSSUSRHospDRFlag=1
		s AuSSUSRProvDRFlag=0
		if (AuSSUSRProvDRStr="")||(AuSSUSRProvDRStr["limited:0") s AuSSUSRProvDRFlag=1
		s AuCTPCPPrvTpDRFlag=0
		if (AuCTPCPPrvTpDRStr="")||(AuCTPCPPrvTpDRStr["limited:0") s AuCTPCPPrvTpDRFlag=1
		s AuCTPCPSpecDRFlag=0
		if (AuCTPCPSpecDRStr="")||(AuCTPCPSpecDRStr["limited:0") s AuCTPCPSpecDRFlag=1
		
		s SSUSRRowId=0
		for
		{
			s SSUSRRowId=$o(^SSU("SSUSR",SSUSRRowId)) q:SSUSRRowId="" 
			
			s SSUSRDefaultDeptDR=$p($g(^SSU("SSUSR",SSUSRRowId)),"^",4)     //登录科室DR
			s SSUSRGroupD=$p($g(^SSU("SSUSR",SSUSRRowId)),"^",5)  //安全组DR
			s SSUSRCareProvDR=$p($g(^SSU("SSUSR",SSUSRRowId)),"^",14)      //医护人员DR
			s:SSUSRCareProvDR'="" CTPCPCarPrvTpDR=$p($g(^CTPCP(SSUSRCareProvDR,1)),"^",4)    //医护人员类型ID
			s:SSUSRCareProvDR="" CTPCPCarPrvTpDR=""
			s:SSUSRCareProvDR'="" CTPCPSpecDR=$p($g(^CTPCP(SSUSRCareProvDR,1)),"^",10)      //医护人员专长ID
			s:SSUSRCareProvDR="" CTPCPSpecDR=""
			s SSUSRCTLANDR=$p($g(^SSU("SSUSR",SSUSRRowId)),"^",13)      //语言DR
			s SSUSRHospitalDR=$p($g(^SSU("SSUSR",SSUSRRowId)),"^",98)      //医院DR

			s strRowId="{ID:"_SSUSRRowId_"}"
			s strDefaultDeptDR = "{ID:"_SSUSRDefaultDeptDR_"}"
			s strGroupD = "{ID:"_SSUSRGroupD_"}"
			s strCareProvDR = "{ID:"_SSUSRCareProvDR_"}"
			s strCarPrvTpDR = "{ID:"_CTPCPCarPrvTpDR_"}"
			s strSpecDR = "{ID:"_CTPCPSpecDR_"}"
			s strCTLANDR = "{ID:"_SSUSRCTLANDR_"}"
			s strHospitalID = "{ID:"_SSUSRHospitalDR_"}"
			
			s SSUSRName=$p($g(^SSU("SSUSR",SSUSRRowId)),"^",2)       //用户名
			s SSUSRInitials=$p($g(^SSU("SSUSR",SSUSRRowId)),"^",1)		//人事ID
			s SSUSRName=SSUSRInitials_"-"_SSUSRName
			s SSUSRNameU=$ZCONVERT(SSUSRName,"U")
			s SSUSRActive=$p($g(^SSU("SSUSR",SSUSRRowId)),"^",19)      //是否激活
			s SSUSRDateFrom=$p($g(^SSU("SSUSR",SSUSRRowId)),"^",96)  //开始日期
			s SSUSRDateTo=$p($g(^SSU("SSUSR",SSUSRRowId)),"^",97)  //结束日期
			continue:SSUSRActive="N"
			continue:(SSUSRDateFrom'="")&&(SSUSRDateFrom>+$h)
			continue:(SSUSRDateTo'="")&&(SSUSRDateTo<+$h)
			
			if (hospid'="")
			{
				s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag(..#SQLTableName,SSUSRRowId,hospid)
  				continue:showflag="N"
			}

			//s PINYIN= ##class(web.DHCBL.BDP.FunLib).GetPYCODE($$ALPHAUP^SSUTIL4(SSUSRNameU))
			 if (desc'="")
   			{
    			;需要对描述或者别名进行检索      
    			s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("SS_User",SSUSRRowId,SSUSRName,desc)
   			}
   			else
   			{
     			s AliasFlag= 1   
   			}  
			i ((AuStr[strRowId)||(AuFlag=1))&&((AuSSUSRDeptDRStr[strDefaultDeptDR)||(AuSSUSRDeptDRFlag=1))&&((AuSSUSRGroupDStr[strGroupD)||(AuSSUSRGroupDFlag=1))&&((AuSSUSRLANDRStr[strCTLANDR)||(AuSSUSRLANDRFlag=1))&&((AuSSUSRProvDRStr[strCareProvDR)||(AuSSUSRProvDRFlag=1))&&((AuCTPCPPrvTpDRStr[strCarPrvTpDR)||(AuCTPCPPrvTpDRFlag=1))&&((AuCTPCPSpecDRStr[strSpecDR)||(AuCTPCPSpecDRFlag=1))&&((AuSSUSRHospDRStr[strHospitalID)||(AuSSUSRHospDRFlag=1))
			{
				i (AliasFlag=1) /*(SSUSRNameU[desc)||(PINYIN[desc)*/
				{
					d OutputRowCmb
				}
			}
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowCmb
    set Data=$lb(SSUSRRowId,SSUSRInitials,SSUSRName)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetDataForCmb1Fetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDataForCmb1Execute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	
	Set ind=$o(^CacheTemp(repid,ind))
	If ind=""
	{
		//if there are no more rows,finish fetching
		Set AtEnd=1
		Set Row=""
	}
	Else
	{
		Set Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetDataForCmb1Close(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDataForCmb1Execute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator：蔡昊哲
/// CreatDate: 2012-12-6
/// Description：获取修改时的记录
/// Table：User.SSUser
/// Other: w ##class(web.DHCBL.CT.SSUser).OpenData()
ClassMethod OpenData(id As %String) As %String
{
	s str=""	
	//获取用户
	s eobj = ##class(web.Entity.CT.SSUser).%New()
	s pobj = ##class(User.SSUser).%OpenId(id)
	s eobj.SSUSRRowId = id
	s eobj.SSUSRInitials = pobj.SSUSRInitials
	s eobj.SSUSRName = pobj.SSUSRName
	s eobj.SSUSRPassword ="******"
	s:pobj.SSUSRDefaultDeptDR'="" eobj.SSUSRDefaultDeptDR = pobj.SSUSRDefaultDeptDR.%Id()
	s:pobj.SSUSRGroup'="" eobj.SSUSRGroup = pobj.SSUSRGroup.%Id()
	s:pobj.SSUSRHospitalDR'="" eobj.SSUSRHospitalDR = pobj.SSUSRHospitalDR.%Id()	
	s:pobj.SSUSRCTLANDR'="" eobj.SSUSRCTLANDR = pobj.SSUSRCTLANDR.%Id()
	s:pobj.SSUSRCareProvDR'="" eobj.SSUSRCareProvDR = pobj.SSUSRCareProvDR.%Id()
	s eobj.SSUSRPin = "******"
	;s:pobj.SSUSRDateFrom'="" eobj.SSUSRDateFrom=$zd(pobj.SSUSRDateFrom)
	;s:pobj.SSUSRDateTo'="" eobj.SSUSRDateTo=$zd(pobj.SSUSRDateTo)
	s:pobj.SSUSRDateFrom'="" eobj.SSUSRDateFrom=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(pobj.SSUSRDateFrom)
	s:pobj.SSUSRDateTo'="" eobj.SSUSRDateTo=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(pobj.SSUSRDateTo)
	s:pobj.SSUSRDateTo="" eobj.SSUSRDateTo=""
	s:pobj.SSUSRActive="Y" eobj.SSUSRActive="true"
	s:pobj.SSUSRChangeLocation="Y" eobj.SSUSRChangeLocation="true"	
	s:pobj.SSUSRPasswordChanged="Y" eobj.SSUSRPasswordChanged="true"
	s:pobj.SSUSRAdmitted="Y" eobj.SSUSRAdmitted="true"	
	s:pobj.SSUSRIgnoreCALogon="Y" eobj.SSUSRIgnoreCALogon="true"
	s eobj.SSUSRFreeText1 =pobj.SSUSRFreeText1
	s eobj.SSUSRFreeText2 =pobj.SSUSRFreeText2
	s eobj.SSUSRFreeText3 =pobj.SSUSRFreeText3
	s eobj.SSUSRMobile =pobj.SSUSRMobile
	s eobj.SSUSRPager =pobj.SSUSRPager
	s eobj.SSUSREmail =pobj.SSUSREmail
	
	
		
	s str = eobj.JsonS()
	
	s str = "{data:["_str_"]}"
	q str
}

/// Creator：高姗姗
/// CreatDate: 2014-9-11
/// Description：获取修改时的记录
/// Table：User.SSUser
/// Other: w ##class(web.DHCBL.CT.SSUser).OpenAll("1161")
ClassMethod OpenAll(id As %String) As %String
{
	s str=""	
	//获取用户
	s eobj = ##class(web.Entity.CT.SSUser).%New()
	s pobj = ##class(User.SSUser).%OpenId(id)
	s eobj.SSUSRRowId = id
	s eobj.SSUSRInitials = pobj.SSUSRInitials
	s eobj.SSUSRName = pobj.SSUSRName
	s eobj.SSUSRPassword ="******"
	s:pobj.SSUSRDefaultDeptDR'="" eobj.SSUSRDefaultDeptDR = pobj.SSUSRDefaultDeptDR.%Id()
	s:pobj.SSUSRGroup'="" eobj.SSUSRGroup = pobj.SSUSRGroup.%Id()
	s:pobj.SSUSRHospitalDR'="" eobj.SSUSRHospitalDR = pobj.SSUSRHospitalDR.%Id()	
	s:pobj.SSUSRCTLANDR'="" eobj.SSUSRCTLANDR = pobj.SSUSRCTLANDR.%Id()
	s:pobj.SSUSRCareProvDR'="" eobj.SSUSRCareProvDR = pobj.SSUSRCareProvDR.%Id()
	s eobj.SSUSRPin = pobj.SSUSRName
	s:eobj.SSUSRPin'="" eobj.SSUSRPin = "******"
	s:pobj.SSUSRDateFrom'="" eobj.SSUSRDateFrom=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(pobj.SSUSRDateFrom)
	s:pobj.SSUSRDateTo'="" eobj.SSUSRDateTo=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(pobj.SSUSRDateTo)
	s:pobj.SSUSRDateTo="" eobj.SSUSRDateTo=""
	s:pobj.SSUSRActive="Y" eobj.SSUSRActive="true"
	s:pobj.SSUSRChangeLocation="Y" eobj.SSUSRChangeLocation="true"	
	s:pobj.SSUSRPasswordChanged="Y" eobj.SSUSRPasswordChanged="true"
	s:pobj.SSUSRAdmitted="Y" eobj.SSUSRAdmitted="true"	
	s:pobj.SSUSRIgnoreCALogon="Y" eobj.SSUSRIgnoreCALogon="true"
	s eobj.SSUSRFreeText1 =pobj.SSUSRFreeText1
	s eobj.SSUSRFreeText2 =pobj.SSUSRFreeText2
	s eobj.SSUSRFreeText3 =pobj.SSUSRFreeText3
	s eobj.SSUSRMobile =pobj.SSUSRMobile
	s eobj.SSUSRPager =pobj.SSUSRPager
	s eobj.SSUSREmail =pobj.SSUSREmail
	s:pobj.SSUSRDefRBDepartmentDR'="" eobj.SSUSRDefRBDepartmentDR = pobj.SSUSRDefRBDepartmentDR.%Id()
	s:pobj.SSUSRHOSPersonDR'="" eobj.SSUSRHOSPersonDR = pobj.SSUSRHOSPersonDR.%Id()
	s eobj.SSUSRSeqNo =pobj.SSUSRSeqNo
	s eobj.SSUSRPYCode =pobj.SSUSRPYCode
	s eobj.SSUSRWBCode =pobj.SSUSRWBCode
	s eobj.SSUSRMark =pobj.SSUSRMark
	s EnablePostLogon=""
	if (##class(web.DHCBL.BDP.FunLib).IsValidMethodName("BSP.SYS.SRV.StandardTypeItem","IsEnablePostLogon")){
		s EnablePostLogon=##class(BSP.SYS.SRV.StandardTypeItem).IsEnablePostLogon(id)
		s:EnablePostLogon="1" EnablePostLogon="true"
	}
	s eobj.EnablePostLogon =EnablePostLogon
					
	s str = eobj.JsonS()
	//获取医护人员
	s cstr=""
	if (eobj.SSUSRCareProvDR'="")
	{
		s ecobj = ##class(web.Entity.CT.CTCareProv).%New()
		s pcobj = ##class(User.CTCareProv).%OpenId(eobj.SSUSRCareProvDR)
		s ecobj.CTPCPRowId1 = eobj.SSUSRCareProvDR
		s ecobj.CTPCPCode = pcobj.CTPCPCode
		s ecobj.CTPCPOtherName = pcobj.CTPCPOtherName
		s ecobj.CTPCPUnit = pcobj.CTPCPUnit
		s:pcobj.CTPCPCarPrvTpDR'="" ecobj.CTPCPCarPrvTpDR = pcobj.CTPCPCarPrvTpDR.%Id()
		s ecobj.CTPCPSurgeon = pcobj.CTPCPSurgeon
		s:pcobj.CTPCPSpecDR'="" ecobj.CTPCPSpecDR = pcobj.CTPCPSpecDR.%Id()
		s ecobj.CTPCPActiveFlag = pcobj.CTPCPActiveFlag
		s ecobj.CTPCPDesc = pcobj.CTPCPDesc
		s ecobj.CTPCPId = pcobj.CTPCPId
		s ecobj.CTPCPTextOne = pcobj.CTPCPTextOne
		s ecobj.CTPCPTextTwo = pcobj.CTPCPTextTwo
		s ecobj.CTPCPHICApproved = pcobj.CTPCPHICApproved	
		s ecobj.CTPCPAnaesthetist = pcobj.CTPCPAnaesthetist	
		s ecobj.CTPCPSpecialistYN = pcobj.CTPCPSpecialistYN	
		;s:pcobj.CTPCPDateActiveTo'="" ecobj.CTPCPDateActiveTo = $zd(pcobj.CTPCPDateActiveTo,1)
		;s:pcobj.CTPCPDateActiveFrom'="" ecobj.CTPCPDateActiveFrom = $zd(pcobj.CTPCPDateActiveFrom,1)
		s:pcobj.CTPCPDateActiveTo'="" ecobj.CTPCPDateActiveTo = ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(pcobj.CTPCPDateActiveTo)
		s:pcobj.CTPCPDateActiveFrom'="" ecobj.CTPCPDateActiveFrom = ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(pcobj.CTPCPDateActiveFrom)
		s:ecobj.CTPCPHICApproved="Y" ecobj.CTPCPHICApproved="true"
		s:ecobj.CTPCPSurgeon="Y" ecobj.CTPCPSurgeon="true"
		s:ecobj.CTPCPActiveFlag="Y" ecobj.CTPCPActiveFlag="true"	
		s:ecobj.CTPCPAnaesthetist="Y" ecobj.CTPCPAnaesthetist="true"
		s:ecobj.CTPCPSpecialistYN="Y" ecobj.CTPCPSpecialistYN="true"
		s ecobj.CTPCPTelO = pcobj.CTPCPTelO  
		s ecobj.CTPCPTelH = pcobj.CTPCPTelH
		s ecobj.CTPCPTelOExt = pcobj.CTPCPTelOExt
		s ecobj.CTPCPMobilePhone = pcobj.CTPCPMobilePhone
		s ecobj.CTPCPEmail = pcobj.CTPCPEmail
		s ecobj.CTPCPFax = pcobj.CTPCPFax
		s:pcobj.CTPCPTitleDR'="" ecobj.CTPCPTitleDR = pcobj.CTPCPTitleDR.%Id()
		s ecobj.CTPCPMentalFlag = pcobj.CTPCPMentalFlag	
		s:ecobj.CTPCPMentalFlag="Y" ecobj.CTPCPMentalFlag="true"
		s cstr=ecobj.JsonS()
		s str=$e(str,1,$l(str)-1)  
		s cstr=$e(cstr,2,$l(cstr)) 
		s str = "{data:["_str_","_cstr_"]}"	
	}else{		
		s str = "{data:["_str_"]}"
	}			
	q str
}

/// Function:用于实现数据校验功能的方法
/// Creator:基础数据平台组 蔡昊哲 
/// CreateDate:2012-12-25    
/// w ##class(web.DHCBL.CT.SSUser).FormValidate("","")
ClassMethod FormValidate(id As %String, code As %String) As %String
{
	s flag=0
	
 	s idc=0
    s:$$ALPHAUP^SSUTIL4(code)'="" idc=$o(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(code),0))
    if ((id="")||((id'="")&&(idc'=id)))&&(idc>0) s flag=1  //返回重复标志
    
	q flag
}

/// Function:用于实现人员唯一标识码校验功能的方法
/// Creator:基础数据平台组 gaoshanshan 
/// CreateDate:2022-11-16
/// w ##class(web.DHCBL.CT.SSUser).FormValidatePerson("","1")
ClassMethod FormValidatePerson(id As %String, persondr As %String) As %String
{
	s flag=0
	
	s idc=0
    s:persondr'="" idc=$o(^SSU("SSUSR",0,"HOSPerson",persondr,0))
    if ((id="")||((id'="")&&(idc'=id)))&&(idc>0) s flag=1  //返回重复标志
    
	q flag
}

/// Creator：蔡昊哲
/// CreatDate: 2012-12-7
/// Description：保存修改用户维护的内容
/// Table：User.SSUser
/// Input：web.Entity.CT.SSUser 实体类
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
ClassMethod SaveEntity(eobj As web.Entity.CT.SSUser) As %String
{
	
	s result = ""
	if $IsObject(eobj)
	{
		s:eobj.SSUSRActive="" eobj.SSUSRActive="N"
	    s:eobj.SSUSRChangeLocation="" eobj.SSUSRChangeLocation="N"
	    s:eobj.SSUSRPasswordChanged="" eobj.SSUSRPasswordChanged="N"
	    s:eobj.SSUSRAdmitted="" eobj.SSUSRAdmitted="N"
	    s:eobj.SSUSRIgnoreCALogon="" eobj.SSUSRIgnoreCALogon="N"
	    
	    s:eobj.SSUSRDateFrom'="" eobj.SSUSRDateFrom=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.SSUSRDateFrom)
	  	s:eobj.SSUSRDateTo'="" eobj.SSUSRDateTo=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.SSUSRDateTo)   
		s:eobj.SSUSRDateFrom="" eobj.SSUSRDateFrom=+$h
		
		s USERID=""
	    s:$d(%session) USERID=$g(%session.Data("LOGON.USERID")) 
	    s eobj.SSUSRLastUpdateDate=+$h  ///系统最后更新日期
	    s eobj.SSUSRLastUpdateTime=$p($h,",",2)  ///系统最后更新时间
	    if (eobj.SSUSRLastUpdateUserDR="") s eobj.SSUSRLastUpdateUserDR=USERID  ///系统最新更新人
	    
	    s:eobj.SSUSRPYCode="" eobj.SSUSRPYCode=##class(web.DHCBL.BDP.FunLib).GetDBCCNCODE(eobj.SSUSRName,4)
		s:eobj.SSUSRWBCode="" eobj.SSUSRWBCode=##class(web.DHCBL.BDP.FunLib).GetSWBCODE(eobj.SSUSRName,1)
		s eobj.EnablePostLogon=$CASE(eobj.EnablePostLogon,"true":"1","Y":"1",:"0") //启用岗位登录

		s flag=..FormValidate(eobj.SSUSRRowId,eobj.SSUSRInitials)  //调用重复验证
		if (flag=1)
		{
			s result = "{success:'false',info:'该记录已经存在！'}"
		}
		elseif (..FormValidatePerson(eobj.SSUSRRowId,eobj.SSUSRHOSPersonDR)=1)
		{
			s result = "{success:'false',info:'该人员已被关联！'}"	
		}
		else
		{
			if (eobj.SSUSRRowId="")  //如果RowId未赋值则增加
			{
				s obj=##class(User.SSUser).%New()
				
				s eobj.SSUSRCreatedDate=+$h  ///系统创建日期
	            s eobj.SSUSRCreatedTime=$p($h,",",2)  ///系统创建时间
	            s:eobj.SSUSRCreatedByDR="" eobj.SSUSRCreatedByDR=USERID   ///系统创建人
	            s obj.SSUSRCreatedDate=eobj.SSUSRCreatedDate
	            s obj.SSUSRCreatedTime=eobj.SSUSRCreatedTime
	            d obj.SSUSRCreatedByDRSetObjectId(eobj.SSUSRCreatedByDR)
			}
			else  //如果RowId已赋值则修改
			{
				s obj=##class(User.SSUser).%OpenId(eobj.SSUSRRowId)
				s bobj = ##class(web.Entity.CT.SSUser).%New()
				s bobj.SSUSRRowId = eobj.SSUSRRowId
				s bobj.SSUSRInitials = obj.SSUSRInitials
				s bobj.SSUSRName = obj.SSUSRName
				s:obj.SSUSRDefaultDeptDR'="" bobj.SSUSRDefaultDeptDR = obj.SSUSRDefaultDeptDR.%Id()
				s:obj.SSUSRGroup'="" bobj.SSUSRGroup = obj.SSUSRGroup.%Id()	
				s:obj.SSUSRHospitalDR'="" bobj.SSUSRHospitalDR = obj.SSUSRHospitalDR.%Id()	
				s:obj.SSUSRCTLANDR'="" bobj.SSUSRCTLANDR = obj.SSUSRCTLANDR.%Id()
				s:obj.SSUSRCareProvDR'="" bobj.SSUSRCareProvDR = obj.SSUSRCareProvDR.%Id()

				s bobj.SSUSRDateFrom = obj.SSUSRDateFrom
				s bobj.SSUSRDateTo = obj.SSUSRDateTo
				s bobj.SSUSRActive = obj.SSUSRActive
				s bobj.SSUSRChangeLocation = obj.SSUSRChangeLocation
				s bobj.SSUSRPasswordChanged =obj.SSUSRPasswordChanged
				s bobj.SSUSRAdmitted =obj.SSUSRAdmitted
				s bobj.SSUSRIgnoreCALogon =obj.SSUSRIgnoreCALogon
				
				
				s bobj.SSUSRFreeText1 =obj.SSUSRFreeText1
				s bobj.SSUSRFreeText2 =obj.SSUSRFreeText2
				s bobj.SSUSRFreeText3 =obj.SSUSRFreeText3
				s bobj.SSUSRMobile =obj.SSUSRMobile
				s bobj.SSUSRPager =obj.SSUSRPager
				s bobj.SSUSREmail =obj.SSUSREmail	
				s:obj.SSUSRDefRBDepartmentDR'="" bobj.SSUSRDefRBDepartmentDR = obj.SSUSRDefRBDepartmentDR.%Id()		
				
				s bobj.SSUSRPassword="******"
				s bobj.SSUSRPin="******" 
				
				s:obj.SSUSRHOSPersonDR'="" bobj.SSUSRHOSPersonDR = obj.SSUSRHOSPersonDR.%Id()	
				s bobj.SSUSRSeqNo =obj.SSUSRSeqNo
				s bobj.SSUSRPYCode =obj.SSUSRPYCode
				s bobj.SSUSRWBCode =obj.SSUSRWBCode
				s bobj.SSUSRMark =obj.SSUSRMark	
				s:obj.SSUSRCreatedByDR'="" bobj.SSUSRCreatedByDR = obj.SSUSRCreatedByDR.%Id()
				s bobj.SSUSRCreatedDate =obj.SSUSRCreatedDate	
				s bobj.SSUSRCreatedTime =obj.SSUSRCreatedTime	
				s:obj.SSUSRLastUpdateUserDR'="" bobj.SSUSRLastUpdateUserDR = obj.SSUSRLastUpdateUserDR.%Id()
				s bobj.SSUSRLastUpdateDate =obj.SSUSRLastUpdateDate	
				s bobj.SSUSRLastUpdateTime =obj.SSUSRLastUpdateTime	
			}
	
			s obj.SSUSRInitials = eobj.SSUSRInitials
			s obj.SSUSRName = eobj.SSUSRName
			
			
			d obj.SSUSRDefaultDeptDRSetObjectId(eobj.SSUSRDefaultDeptDR)
			d obj.SSUSRGroupSetObjectId(eobj.SSUSRGroup)
			d obj.SSUSRHospitalDRSetObjectId(eobj.SSUSRHospitalDR)
			d obj.SSUSRCTLANDRSetObjectId(eobj.SSUSRCTLANDR)
			d obj.SSUSRCareProvDRSetObjectId(eobj.SSUSRCareProvDR)
			
			///2019-07-22
			if (eobj.SSUSRRowId="")
			{
				if eobj.SSUSRPassword'="" s eobj.SSUSRPassword = ##class(BSP.SYS.BL.SSUser).ToCacheBCrypt(eobj.SSUSRPassword)	
				if eobj.SSUSRPin'="" s eobj.SSUSRPin = ##Class(web.SSUser).Encrypt(eobj.SSUSRPin)
				s obj.SSUSRPassword = eobj.SSUSRPassword
				s obj.SSUSRPin = eobj.SSUSRPin	
			}
			else
			{
				if (eobj.SSUSRPassword'="******")
				{
					if eobj.SSUSRPassword'="" s eobj.SSUSRPassword = ##class(BSP.SYS.BL.SSUser).ToCacheBCrypt(eobj.SSUSRPassword)
					//gss 如果密码有修改，默认下次登录时强制用户改变密码
					if (obj.SSUSRPassword'=eobj.SSUSRPassword)  s eobj.SSUSRPasswordChanged = "Y"
					s obj.SSUSRPassword = eobj.SSUSRPassword	
				}
				if (eobj.SSUSRPin'="******")
				{
					if eobj.SSUSRPin'="" s eobj.SSUSRPin = ##Class(web.SSUser).Encrypt(eobj.SSUSRPin)	
					s obj.SSUSRPin = eobj.SSUSRPin
				}
			}
			
			
			s eobj.SSUSRPassword="******"
			s eobj.SSUSRPin="******" 
			
			s obj.SSUSRActive = eobj.SSUSRActive	
			s obj.SSUSRChangeLocation =eobj.SSUSRChangeLocation
			s obj.SSUSRPasswordChanged = eobj.SSUSRPasswordChanged
			s obj.SSUSRAdmitted =eobj.SSUSRAdmitted
			s obj.SSUSRIgnoreCALogon = eobj.SSUSRIgnoreCALogon	
			s obj.SSUSRDateFrom = eobj.SSUSRDateFrom
			s obj.SSUSRDateTo = eobj.SSUSRDateTo
			//2019-06-27
			s obj.SSUSRFreeText1 =eobj.SSUSRFreeText1
			s obj.SSUSRFreeText2 =eobj.SSUSRFreeText2
			s obj.SSUSRFreeText3 =eobj.SSUSRFreeText3
			s obj.SSUSRMobile =eobj.SSUSRMobile
			s obj.SSUSRPager =eobj.SSUSRPager
			s obj.SSUSREmail =eobj.SSUSREmail
			
			s obj.SSUSRLastUpdateDate= eobj.SSUSRLastUpdateDate
	    	s obj.SSUSRLastUpdateTime= eobj.SSUSRLastUpdateTime
	   	 	d obj.SSUSRLastUpdateUserDRSetObjectId(eobj.SSUSRLastUpdateUserDR)
			d obj.SSUSRDefRBDepartmentDRSetObjectId(eobj.SSUSRDefRBDepartmentDR)
			
			d obj.SSUSRHOSPersonDRSetObjectId(eobj.SSUSRHOSPersonDR)
			s obj.SSUSRSeqNo =eobj.SSUSRSeqNo
			s obj.SSUSRPYCode =eobj.SSUSRPYCode
			s obj.SSUSRWBCode =eobj.SSUSRWBCode
			s obj.SSUSRMark =eobj.SSUSRMark
			
			Ts
			s sc=obj.%Save()
			d obj.%Close()
			If $$$ISOK(sc){
				Tc
				s id = obj.%Id()
				///用户同步手机号/座机号/邮箱给医护人员20190730
				if (eobj.SSUSRCareProvDR'="")
				{
					if (eobj.SSUSRPager'="")||(eobj.SSUSRMobile'="")||(eobj.SSUSREmail'="")
					{
						s cpobj=##class(User.CTCareProv).%OpenId(eobj.SSUSRCareProvDR)
						if eobj.SSUSRPager'="" s cpobj.CTPCPTelO = eobj.SSUSRPager  
						if eobj.SSUSRMobile'="" s cpobj.CTPCPMobilePhone =eobj.SSUSRMobile
						if eobj.SSUSREmail'="" s cpobj.CTPCPEmail = eobj.SSUSREmail
						d cpobj.%Save()
					}
				}
				
				;同时指定科室
				if eobj.SSUSRRowId'=""
				{
					if (bobj.SSUSRDefaultDeptDR'="")&(eobj.SSUSRDefaultDeptDR'=bobj.SSUSRDefaultDeptDR)
					{
						D ##class(web.DHCBL.CT.CTCareProv).UpdateRBData(eobj.SSUSRCareProvDR,bobj.SSUSRDefaultDeptDR,"Update",bobj.SSUSRDateFrom,+$h)
																	
					}
					if (eobj.SSUSRDefaultDeptDR'="")&(eobj.SSUSRDefaultDeptDR'=bobj.SSUSRDefaultDeptDR)
					{
						D ##class(web.DHCBL.CT.CTCareProv).UpdateRBData(eobj.SSUSRCareProvDR,eobj.SSUSRDefaultDeptDR,"Add",+$h,eobj.SSUSRDateTo)	
					}
					
					if (eobj.SSUSRDateTo'=bobj.SSUSRDateTo)
					{
						D ##class(web.DHCBL.CT.CTCareProv).UpdateRBData(eobj.SSUSRCareProvDR,eobj.SSUSRDefaultDeptDR,"Update",eobj.SSUSRDateFrom,eobj.SSUSRDateTo)	
					}
				}
				else
				{
					
					if (eobj.SSUSRDefaultDeptDR'="")
					{
						D ##class(web.DHCBL.CT.CTCareProv).UpdateRBData(eobj.SSUSRCareProvDR,eobj.SSUSRDefaultDeptDR,"Add",eobj.SSUSRDateFrom,eobj.SSUSRDateTo)	
					}
				}
				s result = "{success:'true',id:'"_id_"'}"          //返回RowId
				
				///往PACS同步科室数据 2020-05-22
				s SyncPACSFlag=##class(web.DHCBL.BDP.BDPConfig).GetConfigValue("BDPSyncPACS")
				if (SyncPACSFlag="Y"){
					d ##class(web.DHCBL.BDP.BDPInterface).PACSUpdateSSUser(id)	
				}
				s PortalFlag=##class(web.DHCBL.BDP.BDPConfig).GetConfigValue("BDPUsePortal")
				if (PortalFlag="Y"){
					//update by程鹏 修改项目现在用的同步程序
					//update start
					s myobj=##class(%Dictionary.CompiledMethod).%OpenId("DtPortal.Configure.DataSync||SyncUserSoap")
					i $IsObject(myobj)
					{
						d ##class(DtPortal.Configure.DataSync).SyncUserSoap(id,1)	
					}
					//update end
				}
				
				//启用与禁用岗位登录方法
				if (##class(web.DHCBL.BDP.FunLib).IsValidMethodName("BSP.SYS.SRV.StandardTypeItem","SetPostLogon")){
					d ##class(BSP.SYS.SRV.StandardTypeItem).SetPostLogon(id, eobj.EnablePostLogon) //Flag 1开启，0禁用	
				}
				
				d:eobj.SSUSRRowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("SS_User","User.SSUser","用户",id,eobj.SSUSRName,"A",eobj,"",id)
				d:eobj.SSUSRRowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("SS_User","User.SSUser","用户",eobj.SSUSRRowId,eobj.SSUSRName,"U",eobj,bobj,id)
			}else{
				Trollback
				s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}" 
			}
		}		
	}
	else
	{
		s result = "{success:'false',errorinfo:'对象不存在'}"
	}
	q result
}

/// Creator:高姗姗
/// CreatDate: 2014-9-11
/// Description：保存修改用户-医护人员维护的内容
/// Table：User.SSUser
/// Input：web.Entity.CT.SSUser 实体类
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// Others:w ##class(web.DHCBL.CT.SSUser).SaveAll()
ClassMethod SaveAll(userStr As %String, provStr As %String) As %String
{
	s result = ""

	//用户信息
	s SSUSRRowId=$p(userStr,"^",1) //用户rowId
    s SSUSRInitials=$p(userStr,"^",2) //人事Id
    s SSUSRName=$p(userStr,"^",3) //姓名
    s collapse=$p(userStr,"^",4) //判断是否关联医护人员，false为关联
    s SSUSRDateFrom=$p(userStr,"^",5) //开始日期
    s SSUSRDateTo=$p(userStr,"^",6) //结束日期   
    s SSUSRDefaultDeptDR=$p(userStr,"^",7) //默认登陆科室 
    s SSUSRGroup=$p(userStr,"^",8) //安全组
    s SSUSRCareProvDR=$p(userStr,"^",9) //关联医护人员
    s SSUSRChangeLocation=$p(userStr,"^",10) //允许用户更改登陆科室
   	s SSUSRPassword=$p(userStr,"^",11) //登陆密码
    s SSUSRPin=$p(userStr,"^",12) //医嘱签名密码
    s SSUSRHospital=$p(userStr,"^",13) //医院关联
    		
    s SSUSRPasswordChanged=$p(userStr,"^",14) //下次登录时强制用户改变密码
    s SSUSRCTLANDR=$p(userStr,"^",15) //默认语言   
    s SSUSRActive=$p(userStr,"^",16) //是否激活
    s SSUSRAdmitted=$p(userStr,"^",17) //管理员用户
    s SSUSRIgnoreCALogon=$p(userStr,"^",18) //是否忽略CA登录控制
	//2019-06-27
	s SSUSRFreeText1=$p(userStr,"^",19)   //身份证号
	s SSUSRFreeText2=$p(userStr,"^",20)   //性别
	s SSUSRFreeText3=$p(userStr,"^",21)   //其他
	s SSUSRMobile=$p(userStr,"^",22)      //手机号
	s SSUSRPager=$p(userStr,"^",23)       //办公电话
	s SSUSREmail=$p(userStr,"^",24)       //邮箱
	s SSUSRDefRBDepartmentDR=$p(userStr,"^",25)       //行政科室
	s SSUSRHOSPersonDR=$p(userStr,"^",26)       //人员唯一标识码
	s SSUSRSeqNo=$p(userStr,"^",27)       //系统排序号
	s SSUSRPYCode=$p(userStr,"^",28)       //拼音码
	s SSUSRWBCode=$p(userStr,"^",29)       //五笔码
	s SSUSRMark=$p(userStr,"^",30)       //备注
	s EnablePostLogon=$p(userStr,"^",31)  //启用岗位登录
	s flag=..FormValidate(SSUSRRowId,SSUSRInitials)  //调用重复验证
	if (flag=1)
	{
		Quit "{success:'false',info:'该人事ID已经存在！'}"
	}
	if collapse="false"
    {
	    //医护人员信息
	    s ceobj = ##class(web.Entity.CT.CTCareProv).%New()
	    s ceobj.CTPCPRowId1=SSUSRCareProvDR //医护人员rowId
	    s ceobj.CTPCPCode=$p(provStr,"^",1) //工号  
	    if ceobj.CTPCPCode'=""
	    {
		    s flag=##class(web.DHCBL.CT.CTCareProv).FormValidate(ceobj.CTPCPRowId1,ceobj.CTPCPCode)  //调用重复验证
			if (flag=1)
			{
				s result = "{success:'false',errorinfo:'医护人员工号已经存在！'}"
				q result
			}
			s ceobj.CTPCPDesc=$p(provStr,"^",2) //姓名
		    s ceobj.CTPCPUnit=$p(provStr,"^",3) //医生资格证书号
		    s ceobj.CTPCPCarPrvTpDR=$p(provStr,"^",4) //医护人员类型
		    s ceobj.CTPCPHICApproved=$p(provStr,"^",5) //毒麻处方权
		    s ceobj.CTPCPDateActiveFrom=$p(SSUSRDateFrom,",",1) //$p(provStr,"^",6) //开始日期
		    s ceobj.CTPCPSurgeon=$p(provStr,"^",7) //是否外科医生
		    s ceobj.CTPCPActiveFlag=SSUSRActive  //$p(provStr,"^",8) //是否激活
		    s ceobj.CTPCPOtherName=$p(provStr,"^",9) //拼音检索码
		    s ceobj.CTPCPId=$p(provStr,"^",10) //标识码
		    s ceobj.CTPCPTextOne=$p(provStr,"^",11) //Text1
		    s ceobj.CTPCPTextTwo=$p(provStr,"^",12) //Text2
		    s ceobj.CTPCPSpecDR=$p(provStr,"^",13) //医生专长
		   
		    s ceobj.CTPCPDateActiveTo=SSUSRDateTo //$p(provStr,"^",14) //结束日期
		    s ceobj.CTPCPAnaesthetist=$p(provStr,"^",15) //是否麻醉师
		    s ceobj.CTPCPSpecialistYN=$p(provStr,"^",16) //是否专家
		    s ceobj.CTPCPTitleDR=$p(provStr,"^",17) //医护人员职称
		    s ceobj.CTPCPMentalFlag=$p(provStr,"^",18) //精神类药物处方权 20190614
		    
		    //保存医护人员医院关联，取科室的医院	20200528
		    s ceobj.LinkHospId=""
		    s:SSUSRDefaultDeptDR'="" ceobj.LinkHospId=$p($g(^CTLOC(SSUSRDefaultDeptDR)),"^",22)     //医院关联
		    
		    /*
		    s ceobj.CTPCPTelO=$p(provStr,"^",19) //办公电话
		    s ceobj.CTPCPMobilePhone=$p(provStr,"^",20) //移动电话
		    s ceobj.CTPCPEmail=$p(provStr,"^",21) //Email
		    s ceobj.CTPCPTelH=$p(provStr,"^",22) //家庭电话
		    s ceobj.CTPCPTelOExt=$p(provStr,"^",23) //电话分机
		    s ceobj.CTPCPFax=$p(provStr,"^",24) //传真
		   
			*/
		    s ceobj.CTPCPActiveFlag=$CASE(ceobj.CTPCPActiveFlag,"true":"Y","Y":"Y",:"N")
			s ceobj.CTPCPHICApproved=$CASE(ceobj.CTPCPHICApproved,"true":"Y","Y":"Y",:"N")
			s ceobj.CTPCPSpecialistYN=$CASE(ceobj.CTPCPSpecialistYN,"true":"Y","Y":"Y",:"N")
			s ceobj.CTPCPSurgeon=$CASE(ceobj.CTPCPSurgeon,"true":"Y","Y":"Y",:"")
			s ceobj.CTPCPAnaesthetist=$CASE(ceobj.CTPCPAnaesthetist,"true":"Y","Y":"Y",:"N")
			s ceobj.CTPCPMentalFlag=$CASE(ceobj.CTPCPMentalFlag,"true":"Y","Y":"Y",:"N")
			s str= ##class(web.DHCBL.CT.CTCareProv).SaveEntity(ceobj)
		    if str["success:'true'"
		    {
				if SSUSRCareProvDR="" s SSUSRCareProvDR=##class(web.DHCBL.BDP.FunLib).GetResultRowId(str)
		    }
		    else
		    {
			    q str
		    } 
	    }
    }
    else
    {
	    s SSUSRCareProvDR=""
	    
    }
    
    //保存修改用户  
	s eobj = ##class(web.Entity.CT.SSUser).%New()
	s eobj.SSUSRRowId=SSUSRRowId
    s eobj.SSUSRInitials = SSUSRInitials
	s eobj.SSUSRName = SSUSRName
	s eobj.SSUSRPassword = SSUSRPassword
	s eobj.SSUSRDefaultDeptDR=SSUSRDefaultDeptDR
	s eobj.SSUSRGroup=SSUSRGroup
	s eobj.SSUSRHospitalDR=SSUSRHospital
	s eobj.SSUSRCTLANDR=SSUSRCTLANDR
	s eobj.SSUSRCareProvDR=SSUSRCareProvDR
	s eobj.SSUSRPin = SSUSRPin
	s eobj.SSUSRActive=$CASE(SSUSRActive,"true":"Y","Y":"Y",:"")
	s eobj.SSUSRChangeLocation=$CASE(SSUSRChangeLocation,"true":"Y","Y":"Y",:"")
	s eobj.SSUSRPasswordChanged=$CASE(SSUSRPasswordChanged,"true":"Y","Y":"Y",:"")
	s eobj.SSUSRAdmitted=$CASE(SSUSRAdmitted,"true":"Y","Y":"Y",:"")
	s eobj.SSUSRIgnoreCALogon=$CASE(SSUSRIgnoreCALogon,"true":"Y","Y":"Y",:"")
	s eobj.SSUSRPasswordChanged=$CASE(SSUSRPasswordChanged,"true":"Y","Y":"Y",:"")
	s eobj.SSUSRDateFrom = SSUSRDateFrom
	s eobj.SSUSRDateTo =SSUSRDateTo
	s eobj.SSUSRFreeText1 =SSUSRFreeText1
	s eobj.SSUSRFreeText2 =SSUSRFreeText2
	s eobj.SSUSRFreeText3 =SSUSRFreeText3
	s eobj.SSUSRMobile =SSUSRMobile
	s eobj.SSUSRPager =SSUSRPager
	s eobj.SSUSREmail =SSUSREmail
	s eobj.SSUSRDefRBDepartmentDR =SSUSRDefRBDepartmentDR
	s eobj.SSUSRHOSPersonDR =SSUSRHOSPersonDR
	s eobj.SSUSRSeqNo =SSUSRSeqNo
	s eobj.SSUSRPYCode =SSUSRPYCode
	s eobj.SSUSRWBCode =SSUSRWBCode
	s eobj.SSUSRMark =SSUSRMark
	s eobj.EnablePostLogon=EnablePostLogon //启用岗位登录
	
	s result =##class(web.DHCBL.CT.SSUser).SaveEntity(eobj)  
	q result
}

/// Creator:蔡昊哲
/// CreatDate:2013-8-30
/// Description:删除限制
/// Return:1-被引用不可删除,0-未被引用可删除
/// w ##class(web.DHCBL.CT.SSUser).GetRefFlag("1192")
ClassMethod GetRefFlag(id As %String) As %String
{
	s return="",myInfo=""
	
	s SSUSRCareProvDR=$p($g(^SSU("SSUSR",id)),"^",14)
	if SSUSRCareProvDR'=""
	{
		if $d(^OEORDi(0,"DocStDate",SSUSRCareProvDR)) s myInfo=myInfo_"<医嘱表>"
		if $d(^OEORDi(0,"Consult",SSUSRCareProvDR)) s myInfo=myInfo_"<医嘱表>"
		i $d(^RB("RES",0,"CTPCP",SSUSRCareProvDR)) s myInfo=myInfo_"<资源表--医护人员关联科室>"  ; RBResource
    	i $d(^CTLOC(0,"CTPCP",SSUSRCareProvDR)) s myInfo=myInfo_"<医疗单元关联医护人员表>" ;DHCCTLocMedUnitCareProv	
	}
	s found4=0
	s CTLOCRowID=0
	f  s CTLOCRowID=$o(^CTLOC(CTLOCRowID)) q:CTLOCRowID=""  d
	.s CTLOCDepartmentHeadUserDR=$p($g(^CTLOC(CTLOCRowID)),"^",54)
	.i CTLOCDepartmentHeadUserDR=id s found4=1
	i (found4) s myInfo=myInfo_"<科室/病区表>" ;CTLoc
	
	//DHC_JFRcptGroupUser	2021-01-26	likefan
	s parref=0
	for
	{
		s parref=$o(^DHCJFRcptGroupSet(parref)) q:parref=""
		s childsub=0
		for
		{
			s childsub=$o(^DHCJFRcptGroupSet(parref,"Sub",childsub)) q:childsub=""
			s grpuserssusrdr=$p($g(^DHCJFRcptGroupSet(parref,"Sub",childsub)),"^",4)	//用户DR
			if (id=grpuserssusrdr)
			{
				s myInfo=myInfo_"<押金收据和发票人员设置表>"
				q
			}
		}
		q:myInfo["<押金收据和发票人员设置表>"
	}
	
	//2022-08-17
	//门诊预交金表 User.DHCAccPreDeposit
	s:$d(^DHCACDi("AccM",0,"User",id)) myInfo=myInfo_"<门诊预交金表>"
	//门诊发票表 User.DHCINVPRT
	s:$d(^DHCINVPRT(0,"User",id)) myInfo=myInfo_"<门诊发票表>"
	//住院预交金表 User.dhcsfprintdetail
	s:$d(^DHCSFPRINTDETAIL(0,"JkUser",id)) myInfo=myInfo_"<住院预交金表>"
	//住院发票表 User.DHCINVPRTZY
	s:$d(^DHCINVPRTZY(0,"USER",id)) myInfo=myInfo_"<住院发票表>"
    		
	i myInfo="" s return="0^未被引用可删除!"
 	else  s return="1^在"_myInfo_"里被引用,不能删除!"
 	q return
}

/// Creator:蔡昊哲
/// CreatDate:2013-8-30
/// Description:删除用户
/// Return:1-被引用不可删除,0-未被引用可删除
/// w ##class(web.DHCBL.CT.SSUser).Delete("1192")
ClassMethod Delete(id) As %String
{
	s result=""
	
	s re=##class(web.DHCBL.CT.SSUser).GetRefFlag(id)
	s RefFlag=$p(re,"^",1)
	if (RefFlag'=0)
	{
		s result= "{success:'false',info:'"_$p(re,"^",2)_"'}"
	}
	else
	{
		s eobj = ##class(web.Entity.CT.SSUser).%New()
		s pobj = ##class(User.SSUser).%OpenId(id)
		s eobj.SSUSRRowId = id
		s eobj.SSUSRInitials = pobj.SSUSRInitials
		s eobj.SSUSRName = pobj.SSUSRName
		s:pobj.SSUSRDefaultDeptDR'="" eobj.SSUSRDefaultDeptDR = pobj.SSUSRDefaultDeptDR.%Id()
		s:pobj.SSUSRGroup'="" eobj.SSUSRGroup = pobj.SSUSRGroup.%Id()	
		s:pobj.SSUSRHospitalDR'="" eobj.SSUSRHospitalDR = pobj.SSUSRHospitalDR.%Id()
		s:pobj.SSUSRCTLANDR'="" eobj.SSUSRCTLANDR = pobj.SSUSRCTLANDR.%Id()
		s:pobj.SSUSRCareProvDR'="" eobj.SSUSRCareProvDR = pobj.SSUSRCareProvDR.%Id()
		s eobj.SSUSRChangeLocation = pobj.SSUSRChangeLocation
		s eobj.SSUSRActive = pobj.SSUSRActive
		s eobj.SSUSRDateFrom = pobj.SSUSRDateFrom
		s eobj.SSUSRDateTo = pobj.SSUSRDateTo
		s eobj.SSUSRPasswordChanged = pobj.SSUSRPasswordChanged
		s eobj.SSUSRAdmitted = pobj.SSUSRAdmitted
		s eobj.SSUSRIgnoreCALogon = pobj.SSUSRIgnoreCALogon
		s sc=##class(User.SSUser).%DeleteId(id)
		if $$$ISOK(sc)
		{
			s result = "{success:'true',info:'删除成功！'}"	
			d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("SS_User","User.SSUser","用户",id,eobj.SSUSRName,"D",eobj,"",id)
		}
		else 
		{
			s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
			s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("用户","web.DHCBL.CT.SSUser","DeleteData",eobj)
			s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
		}
	}
	
	q result
}

/// Creator:高姗姗
/// CreatDate:2014-9-12
/// Description:删除用户同时删除医护人员
/// Return:成功返回success:'true'；失败返回success:'false'和失败原因
/// Others:d ##class(web.DHCBL.CT.SSUser).DeleteAll(1048)
ClassMethod DeleteAll(id) As %String
{
	s result=""
	//用户
	s re=##class(web.DHCBL.CT.SSUser).GetRefFlag(id)
	s RefFlag=$p(re,"^",1)
	if (RefFlag'=0){
		s result= "{success:'false',info:'"_$p(re,"^",2)_"'}"
	}
	else
	{
		s eobj = ##class(web.Entity.CT.SSUser).%New()
		s pobj = ##class(User.SSUser).%OpenId(id)
		s eobj.SSUSRRowId = id
		s eobj.SSUSRInitials=pobj.SSUSRInitials
		s eobj.SSUSRName = pobj.SSUSRName
		s:pobj.SSUSRDefaultDeptDR'="" eobj.SSUSRDefaultDeptDR = pobj.SSUSRDefaultDeptDR.%Id()
		s:pobj.SSUSRGroup'="" eobj.SSUSRGroup = pobj.SSUSRGroup.%Id()
		s:pobj.SSUSRHospitalDR'="" eobj.SSUSRHospitalDR = pobj.SSUSRHospitalDR.%Id()	
		s:pobj.SSUSRCTLANDR'="" eobj.SSUSRCTLANDR = pobj.SSUSRCTLANDR.%Id()
		s:pobj.SSUSRCareProvDR'="" eobj.SSUSRCareProvDR = pobj.SSUSRCareProvDR.%Id()
		s eobj.SSUSRChangeLocation = pobj.SSUSRChangeLocation
		s eobj.SSUSRActive = pobj.SSUSRActive
		s eobj.SSUSRDateFrom = pobj.SSUSRDateFrom
		s eobj.SSUSRDateTo = pobj.SSUSRDateTo
		s eobj.SSUSRPasswordChanged = pobj.SSUSRPasswordChanged
		s eobj.SSUSRAdmitted = pobj.SSUSRAdmitted
		s eobj.SSUSRIgnoreCALogon = pobj.SSUSRIgnoreCALogon
		s:pobj.SSUSRHOSPersonDR'="" eobj.SSUSRHOSPersonDR = pobj.SSUSRHOSPersonDR.%Id()
		s eobj.SSUSRSeqNo =pobj.SSUSRSeqNo
		s eobj.SSUSRPYCode =pobj.SSUSRPYCode
		s eobj.SSUSRWBCode =pobj.SSUSRWBCode
		s eobj.SSUSRMark =pobj.SSUSRMark
		s:pobj.SSUSRCreatedByDR'="" eobj.SSUSRCreatedByDR = pobj.SSUSRCreatedByDR.%Id()
		s eobj.SSUSRCreatedDate =pobj.SSUSRCreatedDate	
		s eobj.SSUSRCreatedTime =pobj.SSUSRCreatedTime	
		s:pobj.SSUSRLastUpdateUserDR'="" eobj.SSUSRLastUpdateUserDR = pobj.SSUSRLastUpdateUserDR.%Id()
		s eobj.SSUSRLastUpdateDate =pobj.SSUSRLastUpdateDate	
		s eobj.SSUSRLastUpdateTime =pobj.SSUSRLastUpdateTime	
		s CTPCPRowId=$p($g(^SSU("SSUSR",id)),"^",14)
		Tstart
		s sc=##class(User.SSUser).%DeleteId(id)
		if $$$ISOK(sc)
		{
			Tcommit
			s result = "{success:'true',info:'删除成功！'}"	
			d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("SS_User","User.SSUser","用户",id,eobj.SSUSRName,"D",eobj,"",id)
			//医护人员
			if (CTPCPRowId'=""){
				d ##class(web.DHCBL.CT.CTCareProv).DeleteData(CTPCPRowId)
			}
		}
		else 
		{
			Trollback
			s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
			s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("用户","web.DHCBL.CT.SSUser","DeleteAll",eobj)
			s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
		}
	}	
	q result
}

/// Creator:gss
/// CreatDate:2016-7-13
/// w ##class(web.DHCBL.CT.SSUser).GetTreeJson("TreeRoot","SSUSRDefaultDeptDR","0","20","ck")//SSUSRGroup/CTPCPCarPrvTpDR/CTPCPSpecDR
ClassMethod GetTreeJson(LastLevel As %String, Type As %String, start, limit, query, hospid As %String = "") As %String
{
	s:query'="" query=$ZCONVERT(query,"U")
	//输出菜单JSON串
	s myJsonStr=""
	
	s count=0
	s end=start+limit
	//登录科室||科室
	if ((Type="SSUSRDefaultDeptDR")||(Type="RESCTLOCDR")||(Type=""))
	{
		if (LastLevel="TreeRoot") s LastLevel=-100000000000000
		s AuStr=##class(web.DHCBL.Authorize.CTLoc).DHCGetDataByDefaultSession()
	    s AuHospStr=##class(web.DHCBL.Authorize.BDPHospitalAut).GetHospAutFlag()
	    
	    s AuRBCDepartmentGroupStr=##class(web.DHCBL.Authorize.RBCDepartmentGroup).DHCGetDataByDefaultSession()
	    s AuCTHospitalStr=##class(web.DHCBL.Authorize.CTHospital).DHCGetDataByDefaultSession()
	    
	    
	    ;这地方加个方法---获取基本配置中未授权的情况下是否显示数据
	    ;假设未授权情况下默认全部显示数据
	    s AuFlag=0
	    if (AuStr="")||(AuStr["limited:0") s AuFlag=1
	    s AuRBCDepartmentGroupFlag=0
	    if (AuRBCDepartmentGroupStr="")||(AuRBCDepartmentGroupStr["limited:0") s AuRBCDepartmentGroupFlag=1
	    s AuCTHospitalFlag=0
	    if (AuCTHospitalStr="")||(AuCTHospitalStr["limited:0") s AuCTHospitalFlag=1
		//输出菜单JSON串
		s myRowID=0
		for {
			s myRowID=$o(^CTLOC(myRowID)) 
			q:(myRowID="")
			s CTLOCRowID=myRowID
			s CTLOCHospitalDR=$p($g(^CTLOC(CTLOCRowID)),"^",22)     //医院
            s CTLOCDepDR=$p($g(^CTLOC(CTLOCRowID)),"^",19)      //科室部分组 
            s CTLOCDateActiveTo=$p($g(^CTLOC(CTLOCRowID)),"^",25)    //截止日期
            continue:(CTLOCDateActiveTo'="")&&(CTLOCDateActiveTo<+$h)
            continue:(hospid'="")&&(CTLOCHospitalDR'=hospid)	//20200520 likefan
            s strRowId = "{ID:"_CTLOCRowID_"}"
            s strCTLOCDepDR = "{ID:"_CTLOCDepDR_"}"
            s strHospitalID = "{ID:"_CTLOCHospitalDR_"}"

            i ((AuStr[strRowId)||(AuFlag=1))&&((AuRBCDepartmentGroupStr[strCTLOCDepDR)||(AuRBCDepartmentGroupFlag=1))&&((AuCTHospitalStr[strHospitalID)||(AuCTHospitalFlag=1))&&((AuHospStr="off")||(AuHospStr[strHospitalID)||(AuHospStr=1)) ;用来筛选授权数据，如果未授权情况下筛选无效
            {
				s myDesc=$p($g(^CTLOC(myRowID)),"^",2)
				s myDescU=$ZCONVERT(myDesc,"U")
				s PINYIN= ##class(web.DHCBL.BDP.FunLib).GetPYCODE(myDescU)
				if ((myDescU[query)||(PINYIN[query)){
					s count=count+1
					if ((count>start) & (count<=end)) || (end=0) {
						s:(myJsonStr'="") myJsonStr=myJsonStr_","
						s myJsonStr=myJsonStr_"{"
						s myJsonStr=myJsonStr_"""id"":"""_""_myRowID_""",""text"":"""_myDesc_""","
						s myJsonStr=myJsonStr_"""iconCls"":""icon-Loc"","
						s myJsonStr=myJsonStr_"""leaf"":true,"
						s myJsonStr=myJsonStr_"""expanded"":true"
						s myJsonStr=myJsonStr_"}"
					}
				}
            }
		}			
	}
	//安全组
	if ((Type="SSUSRGroup"))
	{
		if (LastLevel="TreeRoot") s LastLevel=-100000000000000
		///医院级授权串，2015-1-20
		//s AuHospStr=##class(web.DHCBL.Authorize.BDPHospitalAut).GetHospAutFlag()
		///基础数据授权
		s AuStr=##class(web.DHCBL.Authorize.SSGroup).DHCGetDataByDefaultSession()
		
		s AuFlag=0
		;未授权情况下，默认显示全部数据
		if (AuStr="")||(AuStr["limited:0") s AuFlag=1
		//输出菜单JSON串
		s myRowID=0
		for {
			s myRowID=$o(^SSU("SSGRP",myRowID)) 
			q:(myRowID="")
			
			s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag("SS_Group",myRowID,hospid)
	  	  	continue:showflag="N"
			
			s SSGRPRowId=myRowID
			/*
			s strHospRowId="",AuHospFlag=0 
			if (AuHospStr'="off")
			{
				s HOSPChildsub=0
				for
				{
					s HOSPChildsub=$o(^SSU("SSGRP",SSGRPRowId,"HOSP",HOSPChildsub)) q:(HOSPChildsub="")||(AuHospFlag=1)
					s CTHospitalDR=$g(^SSU("SSGRP",SSGRPRowId,"HOSP",HOSPChildsub))
					s strHospRowId="{ID:"_CTHospitalDR_"}"
					if (AuHospStr[strHospRowId) s AuHospFlag=1
				}
			}
			*/
			s strRowId="{ID:"_SSGRPRowId_"}"
			if ((AuStr[strRowId)||(AuFlag=1)) ;用来筛选授权数据
			{
				s myDesc=$p($g(^SSU("SSGRP",myRowID)),"^",1)
				continue:myDesc["停用"	//20200706	likefan
				s SSGRPActiveFlag =$p($g(^SSU("SSGRP",myRowID)),"^",151)
				continue:(SSGRPActiveFlag="N")
				s myDescU=$ZCONVERT(myDesc,"U")
				s PINYIN= ##class(web.DHCBL.BDP.FunLib).GetPYCODE(myDescU)
				if ((myDescU[query)||(PINYIN[query)){
					s count=count+1
					if ((count>start) & (count<=end)) || (end=0) {
						s:(myJsonStr'="") myJsonStr=myJsonStr_","
						s myJsonStr=myJsonStr_"{"
						s myJsonStr=myJsonStr_"""id"":"""_""_myRowID_""",""text"":"""_myDesc_""","
						s myJsonStr=myJsonStr_"""iconCls"":""icon-Group"","
						s myJsonStr=myJsonStr_"""leaf"":true,"
						s myJsonStr=myJsonStr_"""expanded"":true"
						s myJsonStr=myJsonStr_"}"
					}
				}
			}
		}			
	}
	//医护人员类型
	if ((Type="CTPCPCarPrvTpDR"))
	{
		if (LastLevel="TreeRoot") s LastLevel=-100000000000000

		//输出菜单JSON串
		s myRowID=0
		for {
			s myRowID=$o(^CT("CPT",myRowID)) 
			q:(myRowID="")
			s myDesc=$p($g(^CT("CPT",myRowID)),"^",2)
			s myDescU=$ZCONVERT(myDesc,"U")
			s PINYIN= ##class(web.DHCBL.BDP.FunLib).GetPYCODE(myDescU)
			if ((myDescU[query)||(PINYIN[query)){
				s count=count+1
				if ((count>start) & (count<=end)) || (end=0) {
					s:(myJsonStr'="") myJsonStr=myJsonStr_","
					s myJsonStr=myJsonStr_"{"
					s myJsonStr=myJsonStr_"""id"":"""_""_myRowID_""",""text"":"""_myDesc_""","
					s myJsonStr=myJsonStr_"""iconCls"":""icon-CarPrvTp"","
					s myJsonStr=myJsonStr_"""leaf"":true,"
					s myJsonStr=myJsonStr_"""expanded"":true"
					s myJsonStr=myJsonStr_"}"
				}
			}
		}			
	}
	//医生专长
	if ((Type="CTPCPSpecDR"))
	{
		if (LastLevel="TreeRoot") s LastLevel=-100000000000000

		//输出菜单JSON串
		s myRowID=0
		for {
			s myRowID=$o(^CT("SPC",myRowID)) 
			q:(myRowID="")
			s myDesc=$p($g(^CT("SPC",myRowID)),"^",2)
			s myDescU=$ZCONVERT(myDesc,"U")
			s PINYIN= ##class(web.DHCBL.BDP.FunLib).GetPYCODE(myDescU)
			if ((myDescU[query)||(PINYIN[query)){
				s count=count+1
				if ((count>start) & (count<=end)) || (end=0) {
					s:(myJsonStr'="") myJsonStr=myJsonStr_","
					s myJsonStr=myJsonStr_"{"
					s myJsonStr=myJsonStr_"""id"":"""_""_myRowID_""",""text"":"""_myDesc_""","
					s myJsonStr=myJsonStr_"""iconCls"":""icon-Spec"","
					s myJsonStr=myJsonStr_"""leaf"":true,"
					s myJsonStr=myJsonStr_"""expanded"":true"
					s myJsonStr=myJsonStr_"}"
				}
			}
		}			
	}	
	//医院
	if ((Type="SSUSRHospitalDR"))
	{
		if (LastLevel="TreeRoot") s LastLevel=-100000000000000

		//输出菜单JSON串
		s myRowID=0
		for {
			s myRowID=$o(^CT("HOSP",myRowID)) 
			q:(myRowID="")
			s myDesc=$p($g(^CT("HOSP",myRowID)),"^",2)
			s myDesc= ##class(web.DHCBL.BDP.FunLib).EvalJSON(myDesc)
			s myDescU=$ZCONVERT(myDesc,"U")
			s PINYIN= ##class(web.DHCBL.BDP.FunLib).GetPYCODE(myDescU)
			if ((myDescU[query)||(PINYIN[query)){
				s count=count+1
				if ((count>start) & (count<=end)) || (end=0) {
					s:(myJsonStr'="") myJsonStr=myJsonStr_","
					s myJsonStr=myJsonStr_"{"
					s myJsonStr=myJsonStr_"""id"":"""_""_myRowID_""",""text"":"""_myDesc_""","
					s myJsonStr=myJsonStr_"""iconCls"":""icon-Hospital"","
					s myJsonStr=myJsonStr_"""leaf"":true,"
					s myJsonStr=myJsonStr_"""expanded"":true"
					s myJsonStr=myJsonStr_"}"
				}
			}
		}			
	}
	
	s myJsonStr="{data:["_myJsonStr_"],totalCount:"_count_"}"
	q myJsonStr
}

/// Others:d ##class(web.DHCBL.CT.SSUser).GetColumnTree("","","高","","","","","","","")
/// zw ^TMP("ColumnTree","web.DHCBL.CT.SSUser","Loc")
/// zw ^TMP("ColumnTree","web.DHCBL.CT.SSUser","Hosp")
ClassMethod GetColumnTree(rowid, Initials, Name, Active, SSUSRGroup, DefaultDeptDR, CarPrvTpDR, SpecDR, SCTLOCDR, hosp, treetype, category) As %String
{
	k ^TMP("ColumnTree","web.DHCBL.CT.SSUser","Loc")
	k ^TMP("ColumnTree","web.DHCBL.CT.SSUser","Hosp")
	;获取用户关联科室
	//获取用户授权Json
	s AuUserStr=##class(web.DHCBL.Authorize.SSUser).DHCGetDataByDefaultSession()
	s AuUserHospStr=##class(web.DHCBL.Authorize.BDPHospitalAut).GetHospAutFlag()
	s AuSSUSRDeptDRStr=##class(web.DHCBL.Authorize.CTLoc).DHCGetDataByDefaultSession() //默认登录科室
	s AuSSUSRGroupDStr=##class(web.DHCBL.Authorize.SSGroup).DHCGetDataByDefaultSession() //安全组
	s AuSSUSRLANDRStr=##class(web.DHCBL.Authorize.SSLanguage).DHCGetDataByDefaultSession() //默认语言
	s AuSSUSRHospDRStr=##class(web.DHCBL.Authorize.CTHospital).DHCGetDataByDefaultSession() //关联医院
	s AuSSUSRProvDRStr=##class(web.DHCBL.Authorize.CTCareProv).DHCGetDataByDefaultSession() //医护人员
	s AuCTPCPPrvTpDRStr=##class(web.DHCBL.Authorize.CTCarPrvTp).DHCGetDataByDefaultSession() //医护人员类型
	s AuCTPCPSpecDRStr=##class(web.DHCBL.Authorize.CTSpec).DHCGetDataByDefaultSession() //医生专长
	s AuUserFlag=0
	if (AuUserStr="")||(AuUserStr["limited:0") s AuUserFlag=1
	s AuSSUSRDeptDRFlag=0
	if (AuSSUSRDeptDRStr="")||(AuSSUSRDeptDRStr["limited:0") s AuSSUSRDeptDRFlag=1
	s AuSSUSRGroupDFlag=0
	if (AuSSUSRGroupDStr="")||(AuSSUSRGroupDStr["limited:0") s AuSSUSRGroupDFlag=1
	s AuSSUSRLANDRFlag=0
	if (AuSSUSRLANDRStr="")||(AuSSUSRLANDRStr["limited:0") s AuSSUSRLANDRFlag=1
	s AuSSUSRHospDRFlag=0
	if (AuSSUSRHospDRStr="")||(AuSSUSRHospDRStr["limited:0") s AuSSUSRHospDRFlag=1
	s AuSSUSRProvDRFlag=0
	if (AuSSUSRProvDRStr="")||(AuSSUSRProvDRStr["limited:0") s AuSSUSRProvDRFlag=1
	s AuCTPCPPrvTpDRFlag=0
	if (AuCTPCPPrvTpDRStr="")||(AuCTPCPPrvTpDRStr["limited:0") s AuCTPCPPrvTpDRFlag=1
	s AuCTPCPSpecDRFlag=0
	if (AuCTPCPSpecDRStr="")||(AuCTPCPSpecDRStr["limited:0") s AuCTPCPSpecDRFlag=1
	
	s:Initials'="" Initials=$ZCONVERT(Initials,"U")
	s:Name'="" Name=$ZCONVERT(Name,"U")
	if (treetype="SSUSRDefaultDeptDR")||(treetype="") s DefaultDeptDR=category
	if (treetype="RESCTLOCDR") s SCTLOCDR=category
	if (treetype="SSUSRGroup") s SSUSRGroup=category
	if (treetype="CTPCPCarPrvTpDR") s CarPrvTpDR=category
	if (treetype="CTPCPSpecDR") s SpecDR=category
	if (treetype="SSUSRHospitalDR") s hosp=category
	s SSUSRRowId=0
	for  
	{	
		s SSUSRRowId=$o(^SSU("SSUSR",SSUSRRowId)) q:SSUSRRowId="" 
		
		s SSUSRHospitalDR=$p($g(^SSU("SSUSR",SSUSRRowId)),"^",98) 	//医院
		s SSUSRDefaultDeptDR=$p($g(^SSU("SSUSR",SSUSRRowId)),"^",4)     //登录科室DR
		s SSUSRGroupD=$p($g(^SSU("SSUSR",SSUSRRowId)),"^",5)  //安全组DR
		s SSUSRCareProvDR=$p($g(^SSU("SSUSR",SSUSRRowId)),"^",14)      //医护人员DR
		s:SSUSRCareProvDR'="" CTPCPCarPrvTpDR=$p($g(^CTPCP(SSUSRCareProvDR,1)),"^",4)    //医护人员类型ID
		s:SSUSRCareProvDR="" CTPCPCarPrvTpDR=""
		s:SSUSRCareProvDR'="" CTPCPSpecDR=$p($g(^CTPCP(SSUSRCareProvDR,1)),"^",10)      //医护人员专长ID
		s:SSUSRCareProvDR="" CTPCPSpecDR=""
		s SSUSRCTLANDR=$p($g(^SSU("SSUSR",SSUSRRowId)),"^",13)      //语言DR
			
		s strSSUSRRowId = "{ID:"_SSUSRRowId_"}"
		s strHospitalID = "{ID:"_SSUSRHospitalDR_"}"
		s strDefaultDeptDR = "{ID:"_SSUSRDefaultDeptDR_"}"
		s strGroupD = "{ID:"_SSUSRGroupD_"}"
		s strCareProvDR = "{ID:"_SSUSRCareProvDR_"}"
		s strCarPrvTpDR = "{ID:"_CTPCPCarPrvTpDR_"}"
		s strSpecDR = "{ID:"_CTPCPSpecDR_"}"
		s strCTLANDR = "{ID:"_SSUSRCTLANDR_"}"
		if ((AuUserHospStr[strHospitalID)||(AuUserHospStr=1))||((AuUserHospStr="off"))&&((AuUserStr[strSSUSRRowId)||(AuUserFlag=1))&&((AuSSUSRDeptDRStr[strDefaultDeptDR)||(AuSSUSRDeptDRFlag=1))&&((AuSSUSRGroupDStr[strGroupD)||(AuSSUSRGroupDFlag=1))&&((AuSSUSRLANDRStr[strCTLANDR)||(AuSSUSRLANDRFlag=1))&&((AuSSUSRProvDRStr[strCareProvDR)||(AuSSUSRProvDRFlag=1))&&((AuCTPCPPrvTpDRStr[strCarPrvTpDR)||(AuCTPCPPrvTpDRFlag=1))&&((AuCTPCPSpecDRStr[strSpecDR)||(AuCTPCPSpecDRFlag=1))&&((AuSSUSRHospDRStr[strHospitalID)||(AuSSUSRHospDRFlag=1)){

		s SSUSRInitials=$p($g(^SSU("SSUSR",SSUSRRowId)),"^",1)       //人事ID
		s SSUSRName=$p($g(^SSU("SSUSR",SSUSRRowId)),"^",2)       //用户名
		s PINYIN=""
		s:Name'="" PINYIN= ##class(web.DHCBL.BDP.FunLib).GetPYCODE(SSUSRName)
		s SSUSRDefaultDeptDR=$p($g(^SSU("SSUSR",SSUSRRowId)),"^",4)     //登录科室DR
		s SSUSRGroupD=$p($g(^SSU("SSUSR",SSUSRRowId)),"^",5)  //安全组DR
		s SSUSRCareProvDR=$p($g(^SSU("SSUSR",SSUSRRowId)),"^",14)      //医护人员DR
		s:SSUSRCareProvDR'="" CTPCPCarPrvTpDR=$p($g(^CTPCP(SSUSRCareProvDR,1)),"^",4)    //医护人员类型ID
		s:SSUSRCareProvDR="" CTPCPCarPrvTpDR=""
		s:SSUSRCareProvDR'="" CTPCPSpecDR=$p($g(^CTPCP(SSUSRCareProvDR,1)),"^",10)      //医护人员专长ID
		s:SSUSRCareProvDR="" CTPCPSpecDR=""
		s SSUSRActive=$p($g(^SSU("SSUSR",SSUSRRowId)),"^",19)      //是否激活
		s SSUSRHospitalDR=$p($g(^SSU("SSUSR",SSUSRRowId)),"^",98) 	//医院

		s ALIASText1=""
		s AliasRowId=0
		for{
			s AliasRowId=$o(^User.BDPAliasI("DataRef","SS_User",SSUSRRowId,AliasRowId))
			q:AliasRowId=""
  			S ALIASText=$LISTGET($g(^User.BDPAliasD(AliasRowId)),2)
			s ALIASText1=ALIASText1_"^"_$ZCONVERT(ALIASText,"U")
		}

		s Flag=0
		s ChildSub=0
		for {
			s ChildSub=$o(^SSU("SSUSR",SSUSRRowId,"OTHLL",ChildSub)) q:ChildSub=""
			s OTHLLCTLOCDR=$p($g(^SSU("SSUSR",SSUSRRowId,"OTHLL",ChildSub)),"^",1)  //登陆科室id
			s OTHLLUserGroupDR=$p($g(^SSU("SSUSR",SSUSRRowId,"OTHLL",ChildSub)),"^",2)  //安全组id	
			if ((OTHLLCTLOCDR=DefaultDeptDR)&(OTHLLUserGroupDR=SSUSRGroup))||((DefaultDeptDR="")&(OTHLLUserGroupDR=SSUSRGroup))||((OTHLLCTLOCDR=DefaultDeptDR)&(SSUSRGroup="")){
				s Flag=1
			}
		}
		s careDrData=""
		if (SCTLOCDR'=""){
			s RESRowId1=0
			for
			{
				s RESRowId1=$o(^RB("RES",0,"CTLOC",SCTLOCDR,RESRowId1)) q:RESRowId1="" 
				s RESCTPCPDR=$p($g(^RB("RES",RESRowId1)),"^",2)       //医护人员ID
				s careDrData = careDrData_",{ID:"_RESCTPCPDR_"}"
			}
		}
		s DSSUSRCareProvDR= "{ID:"_SSUSRCareProvDR_"}"
		i ($zcvt(SSUSRInitials,"U")[Initials)&((PINYIN[Name)||($zcvt(SSUSRName,"U")[Name)||(ALIASText1[Name))&((((SSUSRGroupD=SSUSRGroup)||(SSUSRGroup=""))&((SSUSRDefaultDeptDR=DefaultDeptDR)||(DefaultDeptDR="")))||(Flag=1) )&((CTPCPCarPrvTpDR=CarPrvTpDR)||(CarPrvTpDR=""))&((CTPCPSpecDR=SpecDR)||(SpecDR=""))&((careDrData[DSSUSRCareProvDR)||(SCTLOCDR=""))&((SSUSRHospitalDR=hosp)||(hosp=""))&((SSUSRActive=Active)||(Active=""))  //条件
		{
			if (SSUSRDefaultDeptDR=""){
				if ($d(^TMP("ColumnTree","web.DHCBL.CT.SSUser","Loc","0"))){
					s ^TMP("ColumnTree","web.DHCBL.CT.SSUser","Loc","0")=^TMP("ColumnTree","web.DHCBL.CT.SSUser","Loc","0")_"^"_SSUSRRowId
				}else{
					s ^TMP("ColumnTree","web.DHCBL.CT.SSUser","Loc","0")=SSUSRRowId
				}	
			}else{
				if ($d(^TMP("ColumnTree","web.DHCBL.CT.SSUser","Loc",SSUSRDefaultDeptDR))){
					s ^TMP("ColumnTree","web.DHCBL.CT.SSUser","Loc",SSUSRDefaultDeptDR)=^TMP("ColumnTree","web.DHCBL.CT.SSUser","Loc",SSUSRDefaultDeptDR)_"^"_SSUSRRowId
				}else{
					s ^TMP("ColumnTree","web.DHCBL.CT.SSUser","Loc",SSUSRDefaultDeptDR)=SSUSRRowId
				}	
			}		
		}
		}	
	} 
	if ($d(^TMP("ColumnTree","web.DHCBL.CT.SSUser","Loc","0"))=0){
		s ^TMP("ColumnTree","web.DHCBL.CT.SSUser","Loc","0")=""
	}
	;获取科室关联医院
	s CTLOCRowID=0
	for  
	{	
		s CTLOCRowID=$o(^TMP("ColumnTree","web.DHCBL.CT.SSUser","Loc",CTLOCRowID)) q:CTLOCRowID="" 
		s CTLOCHospitalDR=$p($g(^CTLOC(CTLOCRowID)),"^",22) 
		if (CTLOCHospitalDR=""){
			if ($d(^TMP("ColumnTree","web.DHCBL.CT.SSUser","Hosp","0"))){
				s ^TMP("ColumnTree","web.DHCBL.CT.SSUser","Hosp","0")=^TMP("ColumnTree","web.DHCBL.CT.SSUser","Hosp","0")_"^"_CTLOCRowID
			}else{
				s ^TMP("ColumnTree","web.DHCBL.CT.SSUser","Hosp","0")=CTLOCRowID
			}	
		}else{
			if ($d(^TMP("ColumnTree","web.DHCBL.CT.SSUser","Hosp",CTLOCHospitalDR))){
				s ^TMP("ColumnTree","web.DHCBL.CT.SSUser","Hosp",CTLOCHospitalDR)=^TMP("ColumnTree","web.DHCBL.CT.SSUser","Hosp",CTLOCHospitalDR)_"^"_CTLOCRowID
			}else{
				s ^TMP("ColumnTree","web.DHCBL.CT.SSUser","Hosp",CTLOCHospitalDR)=CTLOCRowID
			}	
		}
	}
	if ($d(^TMP("ColumnTree","web.DHCBL.CT.SSUser","Hosp","0"))=0){
		s ^TMP("ColumnTree","web.DHCBL.CT.SSUser","Hosp","0")=""
	}
}

/// Others:w ##class(web.DHCBL.CT.SSUser).GetListJson("root","","","demo","","","","","","","","default")
ClassMethod GetListJson(ParentID, rowid, Initials, Name, Active, SSUSRGroup, DefaultDeptDR, CarPrvTpDR, SpecDR, SCTLOCDR, hosp, treetype, category, sort) As %String
{
	d ..GetColumnTree(rowid, Initials, Name, Active, SSUSRGroup, DefaultDeptDR, CarPrvTpDR, SpecDR, SCTLOCDR, hosp, treetype, category)
	
	//获取医院授权Json
	s AuHospStr=##class(web.DHCBL.Authorize.CTHospital).DHCGetDataByDefaultSession()
	s AuHospFlag=0
	if AuHospStr="" s AuHospFlag=1 
	
	//获取科室授权Json
	s AuLocStr=##class(web.DHCBL.Authorize.CTLoc).DHCGetDataByDefaultSession()
	s AuLocHospStr=##class(web.DHCBL.Authorize.BDPHospitalAut).GetHospAutFlag()
	s AuRBCDepartmentGroupStr=##class(web.DHCBL.Authorize.RBCDepartmentGroup).DHCGetDataByDefaultSession()
	s AuCTHospitalStr=##class(web.DHCBL.Authorize.CTHospital).DHCGetDataByDefaultSession()
	s AuLocFlag=0
	if (AuLocStr="")||(AuLocStr["limited:0") s AuLocFlag=1
	s AuRBCDepartmentGroupFlag=0
	if (AuRBCDepartmentGroupStr="")||(AuRBCDepartmentGroupStr["limited:0") s AuRBCDepartmentGroupFlag=1
	s AuCTHospitalFlag=0
	if (AuCTHospitalStr="")||(AuCTHospitalStr["limited:0") s AuCTHospitalFlag=1
	
	
	s return ="["
	w "["
	;医院
	if (ParentID="root"){
		s i=0
		s HOSPRowId=0
		for  
		{	
			s HOSPRowId=$o(^TMP("ColumnTree","web.DHCBL.CT.SSUser","Hosp",HOSPRowId)) q:HOSPRowId="" 
			s strHOSPRowId = "{ID:"_HOSPRowId_"}"

			if (AuHospStr[strHOSPRowId)||(AuHospFlag=1){
				;用户条数
				s userCount=""
				s locs=^TMP("ColumnTree","web.DHCBL.CT.SSUser","Hosp",HOSPRowId)
				if (locs'=""){
					s locCount=$Length(locs,"^")
					for j=1:1:locCount
					{
						s CTLOCRowID=$p(locs,"^",j)
						s users=^TMP("ColumnTree","web.DHCBL.CT.SSUser","Loc",CTLOCRowID)
						s useCount=$Length(users,"^")
						s userCount=userCount+useCount
					}
				}
				s HOSPDesc=$p($g(^CT("HOSP",HOSPRowId)),"^",2)
				if (i=0){
					s return=return_"{SSUSRName:'"_HOSPDesc_"#"_userCount_"',id:'H"_HOSPRowId_"',uiProvider:'col',iconCls:'icon-Hospital'}" 
					w "{SSUSRName:'"_HOSPDesc_"#"_userCount_"',id:'H"_HOSPRowId_"',uiProvider:'col',iconCls:'icon-Hospital'}" 

				}else{
					s return=return_",{SSUSRName:'"_HOSPDesc_"#"_userCount_"',id:'H"_HOSPRowId_"',uiProvider:'col',iconCls:'icon-Hospital'}" 
					w ",{SSUSRName:'"_HOSPDesc_"#"_userCount_"',id:'H"_HOSPRowId_"',uiProvider:'col',iconCls:'icon-Hospital'}" 

				}
				s i=i+1
			}
		}
		if ((^TMP("ColumnTree","web.DHCBL.CT.SSUser","Hosp",0)'="")||(^TMP("ColumnTree","web.DHCBL.CT.SSUser","Loc",0)'="")){
			;用户条数
			s userCount=""
			s locs=^TMP("ColumnTree","web.DHCBL.CT.SSUser","Hosp",0)
			if (locs'=""){
				s locCount=$Length(locs,"^")
				for j=1:1:locCount
				{
					s CTLOCRowID=$p(locs,"^",j)
					s users=^TMP("ColumnTree","web.DHCBL.CT.SSUser","Loc",CTLOCRowID)
					s useCount=$Length(users,"^")
					s userCount=userCount+useCount
				}
			}
			if ($d(^TMP("ColumnTree","web.DHCBL.CT.SSUser","Loc",0))){
				s nusers=^TMP("ColumnTree","web.DHCBL.CT.SSUser","Loc",0)
				if (nusers'=""){
					s nuserCount=$Length(nusers,"^")
					s userCount=userCount+nuserCount
				}
			}
			if (return="["){
				s return=return_"{SSUSRName:'未关联医院#"_userCount_"',id:'H0',uiProvider:'col',iconCls:'icon-Hospital'}" 
				w "{SSUSRName:'未关联医院#"_userCount_"',id:'H0',uiProvider:'col',iconCls:'icon-Hospital'}" 

			}else{
				s return=return_",{SSUSRName:'未关联医院#"_userCount_"',id:'H0',uiProvider:'col',iconCls:'icon-Hospital'}" 
				w ",{SSUSRName:'未关联医院#"_userCount_"',id:'H0',uiProvider:'col',iconCls:'icon-Hospital'}" 

			}
			
		}
	}
	;科室
	if ($e(ParentID,1)="H"){
		s locStr=^TMP("ColumnTree","web.DHCBL.CT.SSUser","Hosp",$e(ParentID,2,$l(ParentID)))
		if (locStr'=""){
			s j=0
			s locLen=$Length(locStr,"^")
			for i=1:1:locLen
			{
				s CTLOCRowID=$p(locStr,"^",i)
				s CTLOCHospitalDR=$p($g(^CTLOC(CTLOCRowID)),"^",22) 	//医院
				s CTLOCDepDR=$p($g(^CTLOC(CTLOCRowID)),"^",19)		//科室部分组 
			
				s strCTLOCRowID = "{ID:"_CTLOCRowID_"}"
				s strCTLOCDepDR = "{ID:"_CTLOCDepDR_"}"
				s strHospitalID = "{ID:"_CTLOCHospitalDR_"}"

				if ((AuLocStr[strCTLOCRowID)||(AuLocFlag=1))&&((AuRBCDepartmentGroupStr[strCTLOCDepDR)||(AuRBCDepartmentGroupFlag=1))&&((AuCTHospitalStr[strHospitalID)||(AuCTHospitalFlag=1))&&((AuLocHospStr="off")||(AuLocHospStr[strHospitalID)||(AuLocHospStr=1)){
					;用户条数
					s userCount=""
					s users=^TMP("ColumnTree","web.DHCBL.CT.SSUser","Loc",CTLOCRowID)
					if (users'=""){
						s userCount=$Length(users,"^")
					}
					s CTLOCDesc=$p($g(^CTLOC(CTLOCRowID)),"^",2) 	
					if (j=0){
						s return=return_"{SSUSRName:'"_CTLOCDesc_"#"_userCount_"',id:'L"_CTLOCRowID_"',uiProvider:'col',iconCls:'icon-Loc'}" 
						w "{SSUSRName:'"_CTLOCDesc_"#"_userCount_"',id:'L"_CTLOCRowID_"',uiProvider:'col',iconCls:'icon-Loc'}" 

					}else{
						s return=return_",{SSUSRName:'"_CTLOCDesc_"#"_userCount_"',id:'L"_CTLOCRowID_"',uiProvider:'col',iconCls:'icon-Loc'}"  
						w ",{SSUSRName:'"_CTLOCDesc_"#"_userCount_"',id:'L"_CTLOCRowID_"',uiProvider:'col',iconCls:'icon-Loc'}"  

					}
					s j=j+1
				}
			}
		}
		if ($e(ParentID,2)="0"){
			if (^TMP("ColumnTree","web.DHCBL.CT.SSUser","Loc",0)'=""){
				;用户条数
				s userCount=""
				s users=^TMP("ColumnTree","web.DHCBL.CT.SSUser","Loc",0)
				if (users'=""){
					s userCount=$Length(users,"^")
				}
				if (return ="["){
					s return=return_"{SSUSRName:'未指定科室#"_userCount_"',id:'L0',uiProvider:'col',iconCls:'icon-Loc'}" 
					w "{SSUSRName:'未指定科室#"_userCount_"',id:'L0',uiProvider:'col',iconCls:'icon-Loc'}" 
				}else{
					s return=return_",{SSUSRName:'未指定科室#"_userCount_"',id:'L0',uiProvider:'col',iconCls:'icon-Loc'}" 
					w ",{SSUSRName:'未指定科室#"_userCount_"',id:'L0',uiProvider:'col',iconCls:'icon-Loc'}" 
				}
			}
		}
	}
	;用户 
	if ($e(ParentID,1)="L"){
		k ^TMP("BDPSortByParams","sort","web.DHCBL.CT.SSUser2")
		s userStr=^TMP("ColumnTree","web.DHCBL.CT.SSUser","Loc",$e(ParentID,2,$l(ParentID)))
		if (userStr'=""){
			s userLen=$Length(userStr,"^")
			for i=1:1:userLen
			{
				s SSUSRRowId=$p(userStr,"^",i)
				
					if (sort="SSUSRInitials"){
						s SSUSRInitials=$p($g(^SSU("SSUSR",SSUSRRowId)),"^",1)
						s PINYINInitials=##class(web.DHCBL.BDP.FunLib).GetPYCODE(SSUSRInitials)
						d ##class(web.DHCBL.BDP.BDPSortByParams).GetSortbyParams("web.DHCBL.CT.SSUser2",PINYINInitials,SSUSRRowId)  
					}
					if (sort="SSUSRName"){
						s SSUSRName=$p($g(^SSU("SSUSR",SSUSRRowId)),"^",2)
           				s PINYINName=##class(web.DHCBL.BDP.FunLib).GetPYCODE(SSUSRName)
           				d ##class(web.DHCBL.BDP.BDPSortByParams).GetSortbyParams("web.DHCBL.CT.SSUser2",PINYINName,SSUSRRowId)  
					}
					if (sort="default"){
						d ##class(web.DHCBL.BDP.BDPSortByParams).GetSortbyParams("web.DHCBL.CT.SSUser2",SSUSRRowId,SSUSRRowId)  
					}
				
			}
			 s PLIST = ##class(web.DHCBL.BDP.BDPSortByParams).GetSortDataIDS("web.DHCBL.CT.SSUser2")
			 s k=0
			 s methodname = "Count"
 			 s elements = $METHOD(PLIST,methodname)
          	 for i=1:1:elements
          	 {
            	s SSUSRRowId=$tr(PLIST.GetAt(i),"'","")
            	q:SSUSRRowId=""
				s SSUSRName=$p($g(^SSU("SSUSR",SSUSRRowId)),"^",2) 
				s SSUSRName=$tr(SSUSRName,$c(13,10),"")	
				s SSUSRInitials=$p($g(^SSU("SSUSR",SSUSRRowId)),"^",1)       //人事ID
				s SSUSRGroupD=$p($g(^SSU("SSUSR",SSUSRRowId)),"^",5)  //安全组DR
				s:SSUSRGroupD'="" SSGRPDesc=$p($g(^SSU("SSGRP",SSUSRGroupD)),"^",1) //安全组名称
				s:SSUSRGroupD="" SSGRPDesc=""
				s SSUSRCareProvDR=$p($g(^SSU("SSUSR",SSUSRRowId)),"^",14)      //医护人员DR
				s:SSUSRCareProvDR'="" CTPCPCode=$p($g(^CTPCP(SSUSRCareProvDR,1)),"^",1) //医护人员工号
				s:SSUSRCareProvDR="" CTPCPCode=""
				s:SSUSRCareProvDR'="" CTPCPDesc=$p($g(^CTPCP(SSUSRCareProvDR,1)),"^",2) //医护人员姓名
				s:SSUSRCareProvDR="" CTPCPDesc=""
				s:SSUSRCareProvDR'="" CTPCPCarPrvTpDR=$p($g(^CTPCP(SSUSRCareProvDR,1)),"^",4)    //医护人员类型ID
				s:SSUSRCareProvDR="" CTPCPCarPrvTpDR=""
				s:CTPCPCarPrvTpDR'="" CTCPTDesc=$p($g(^CT("CPT",CTPCPCarPrvTpDR)),"^",2) //医护人员类型
				s:CTPCPCarPrvTpDR="" CTCPTDesc=""
				s:SSUSRCareProvDR'="" CTPCPOtherName=$p($g(^CTPCP(SSUSRCareProvDR,3)),"^",28)  //拼音检索码
				s:SSUSRCareProvDR="" CTPCPOtherName=""
				s SSUSRActive=$p($g(^SSU("SSUSR",SSUSRRowId)),"^",19)      //是否激活
				s SSUSRDateFrom=$p($g(^SSU("SSUSR",SSUSRRowId)),"^",96)    //开始日期
				s SSUSRDateTo=$p($g(^SSU("SSUSR",SSUSRRowId)),"^",97)  //截止日期
				s:SSUSRDateFrom'="" SSUSRDateFrom=$zd(SSUSRDateFrom,1) //转换日期格式
				s:SSUSRDateTo'="" SSUSRDateTo=$zd(SSUSRDateTo,1) //转换日期格式
				
				if (k=0){
					s return=return_"{SSUSRName:'"_SSUSRName_"',id:'"_SSUSRRowId_"',SSUSRInitials:'"_SSUSRInitials_"',SSGRPDesc:'"_SSGRPDesc_"',SSUSRCareProvDR:'"_SSUSRCareProvDR_"',CTPCPCode:'"_CTPCPCode_"',CTPCPDesc:'"_CTPCPDesc_"',CTCPTDesc:'"_CTCPTDesc_"',CTPCPOtherName:'"_CTPCPOtherName_"',SSUSRActive:'"_SSUSRActive_"',SSUSRDateFrom:'"_SSUSRDateFrom_"',SSUSRDateTo:'"_SSUSRDateTo_"',uiProvider:'col',iconCls:'icon-CareProv',leaf:true}" 
					w "{SSUSRName:'"_SSUSRName_"',id:'"_SSUSRRowId_"',SSUSRInitials:'"_SSUSRInitials_"',SSGRPDesc:'"_SSGRPDesc_"',SSUSRCareProvDR:'"_SSUSRCareProvDR_"',CTPCPCode:'"_CTPCPCode_"',CTPCPDesc:'"_CTPCPDesc_"',CTCPTDesc:'"_CTCPTDesc_"',CTPCPOtherName:'"_CTPCPOtherName_"',SSUSRActive:'"_SSUSRActive_"',SSUSRDateFrom:'"_SSUSRDateFrom_"',SSUSRDateTo:'"_SSUSRDateTo_"',uiProvider:'col',iconCls:'icon-CareProv',leaf:true}" 

				}else{
					s return=return_",{SSUSRName:'"_SSUSRName_"',id:'"_SSUSRRowId_"',SSUSRInitials:'"_SSUSRInitials_"',SSGRPDesc:'"_SSGRPDesc_"',SSUSRCareProvDR:'"_SSUSRCareProvDR_"',CTPCPCode:'"_CTPCPCode_"',CTPCPDesc:'"_CTPCPDesc_"',CTCPTDesc:'"_CTCPTDesc_"',CTPCPOtherName:'"_CTPCPOtherName_"',SSUSRActive:'"_SSUSRActive_"',SSUSRDateFrom:'"_SSUSRDateFrom_"',SSUSRDateTo:'"_SSUSRDateTo_"',uiProvider:'col',iconCls:'icon-CareProv',leaf:true}"
					w ",{SSUSRName:'"_SSUSRName_"',id:'"_SSUSRRowId_"',SSUSRInitials:'"_SSUSRInitials_"',SSGRPDesc:'"_SSGRPDesc_"',SSUSRCareProvDR:'"_SSUSRCareProvDR_"',CTPCPCode:'"_CTPCPCode_"',CTPCPDesc:'"_CTPCPDesc_"',CTCPTDesc:'"_CTCPTDesc_"',CTPCPOtherName:'"_CTPCPOtherName_"',SSUSRActive:'"_SSUSRActive_"',SSUSRDateFrom:'"_SSUSRDateFrom_"',SSUSRDateTo:'"_SSUSRDateTo_"',uiProvider:'col',iconCls:'icon-CareProv',leaf:true}"

				}
				s k=k+1
			}
		}
	}	
	//s return=return_"]"
	//q return
	w "]"
}

/// 拖拽
ClassMethod DragNode(id, parentid) As %String
{
	s result=""
	s:parentid="0" parentid=""
	s:parentid="oot" parentid=""
	s obj=##class(User.SSUser).%OpenId(id)
	
	s bSSUSRName = obj.SSUSRName
	s:obj.SSUSRDefaultDeptDR'="" bSSUSRDefaultDeptDR = obj.SSUSRDefaultDeptDR.%Id()
	s:obj.SSUSRDefaultDeptDR="" bSSUSRDefaultDeptDR = ""
	s blogJson="{SSUSRRowId:"""_id_""",SSUSRDefaultDeptDR:"""_bSSUSRDefaultDeptDR_"""}"
	
	d:parentid="" obj.SSUSRDefaultDeptDRSetObjectId("")
	d:parentid'="" obj.SSUSRDefaultDeptDRSetObjectId(parentid)
	s logJson="{SSUSRRowId:"""_id_""",SSUSRDefaultDeptDR:"""_parentid_"""}"
		
	Ts	
	s sc=obj.%Save()
	d obj.%Close()
	If $$$ISOK(sc){
		Tc
		s id = obj.%Id()
		s result = "{success:'true',id:'"_id_"'}" //返回RowId
	    d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLogForOther("SS_User","User.SSUser","用户",id,bSSUSRName,"U",logJson,blogJson)
	}else{
		Trollback
		s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"   //返回错误信息
	}
	q result
}

/// Others:d ##class(web.DHCBL.CT.SSUser).GetColumnTree2("","","","","","","","","","","","","","RESCTLOCDR")
/// zw ^TMP("ColumnTree","web.DHCBL.CT.SSUser","Loc")
/// zw ^TMP("ColumnTree","web.DHCBL.CT.SSUser","Hosp")
ClassMethod GetColumnTree2(rowid, Initials, Name, Active, SSUSRGroup, DefaultDeptDR, CarPrvTpDR, SpecDR, SCTLOCDR, hosp, treetype, category, flagType) As %String
{
	k ^TMP("ColumnTree","User.SSUser")

	//获取用户授权Json
	;获取用户关联科室
	s AuUserStr=##class(web.DHCBL.Authorize.SSUser).DHCGetDataByDefaultSession()
	s AuUserHospStr=##class(web.DHCBL.Authorize.BDPHospitalAut).GetHospAutFlag()
	s AuSSUSRDeptDRStr=##class(web.DHCBL.Authorize.CTLoc).DHCGetDataByDefaultSession() //默认登录科室
	s AuSSUSRGroupDStr=##class(web.DHCBL.Authorize.SSGroup).DHCGetDataByDefaultSession() //安全组
	s AuSSUSRLANDRStr=##class(web.DHCBL.Authorize.SSLanguage).DHCGetDataByDefaultSession() //默认语言
	s AuSSUSRHospDRStr=##class(web.DHCBL.Authorize.CTHospital).DHCGetDataByDefaultSession() //关联医院
	s AuSSUSRProvDRStr=##class(web.DHCBL.Authorize.CTCareProv).DHCGetDataByDefaultSession() //医护人员
	s AuCTPCPPrvTpDRStr=##class(web.DHCBL.Authorize.CTCarPrvTp).DHCGetDataByDefaultSession() //医护人员类型
	s AuCTPCPSpecDRStr=##class(web.DHCBL.Authorize.CTSpec).DHCGetDataByDefaultSession() //医生专长
	s AuUserFlag=0
	if (AuUserStr="")||(AuUserStr["limited:0") s AuUserFlag=1
	s AuSSUSRDeptDRFlag=0
	if (AuSSUSRDeptDRStr="")||(AuSSUSRDeptDRStr["limited:0") s AuSSUSRDeptDRFlag=1
	s AuSSUSRGroupDFlag=0
	if (AuSSUSRGroupDStr="")||(AuSSUSRGroupDStr["limited:0") s AuSSUSRGroupDFlag=1
	s AuSSUSRLANDRFlag=0
	if (AuSSUSRLANDRStr="")||(AuSSUSRLANDRStr["limited:0") s AuSSUSRLANDRFlag=1
	s AuSSUSRHospDRFlag=0
	if (AuSSUSRHospDRStr="")||(AuSSUSRHospDRStr["limited:0") s AuSSUSRHospDRFlag=1
	s AuSSUSRProvDRFlag=0
	if (AuSSUSRProvDRStr="")||(AuSSUSRProvDRStr["limited:0") s AuSSUSRProvDRFlag=1
	s AuCTPCPPrvTpDRFlag=0
	if (AuCTPCPPrvTpDRStr="")||(AuCTPCPPrvTpDRStr["limited:0") s AuCTPCPPrvTpDRFlag=1
	s AuCTPCPSpecDRFlag=0
	if (AuCTPCPSpecDRStr="")||(AuCTPCPSpecDRStr["limited:0") s AuCTPCPSpecDRFlag=1
	
	s:Initials'="" Initials=$ZCONVERT(Initials,"U")
	s:Name'="" Name=$ZCONVERT(Name,"U")
	if (treetype="SSUSRDefaultDeptDR")||(treetype="") s DefaultDeptDR=category
	if (treetype="RESCTLOCDR") s SCTLOCDR=category
	if (treetype="SSUSRGroup") s SSUSRGroup=category
	if (treetype="CTPCPCarPrvTpDR") s CarPrvTpDR=category
	if (treetype="CTPCPSpecDR") s SpecDR=category
	if (treetype="SSUSRHospitalDR") s hosp=category
	s SSUSRRowId=0
	for  
	{	
		s SSUSRRowId=$o(^SSU("SSUSR",SSUSRRowId)) q:SSUSRRowId="" 
		
		s SSUSRHospitalDR=$p($g(^SSU("SSUSR",SSUSRRowId)),"^",98) 	//医院
		s SSUSRDefaultDeptDR=$p($g(^SSU("SSUSR",SSUSRRowId)),"^",4)     //登录科室DR
		s SSUSRGroupD=$p($g(^SSU("SSUSR",SSUSRRowId)),"^",5)  //安全组DR
		s SSUSRCareProvDR=$p($g(^SSU("SSUSR",SSUSRRowId)),"^",14)      //医护人员DR
		s:SSUSRCareProvDR'="" CTPCPCarPrvTpDR=$p($g(^CTPCP(SSUSRCareProvDR,1)),"^",4)    //医护人员类型ID
		s:SSUSRCareProvDR="" CTPCPCarPrvTpDR=""
		s:SSUSRCareProvDR'="" CTPCPSpecDR=$p($g(^CTPCP(SSUSRCareProvDR,1)),"^",10)      //医护人员专长ID
		s:SSUSRCareProvDR="" CTPCPSpecDR=""
		s SSUSRCTLANDR=$p($g(^SSU("SSUSR",SSUSRRowId)),"^",13)      //语言DR
			
		s strSSUSRRowId = "{ID:"_SSUSRRowId_"}"
		s strHospitalID = "{ID:"_SSUSRHospitalDR_"}"
		s strDefaultDeptDR = "{ID:"_SSUSRDefaultDeptDR_"}"
		s strGroupD = "{ID:"_SSUSRGroupD_"}"
		s strCareProvDR = "{ID:"_SSUSRCareProvDR_"}"
		s strCarPrvTpDR = "{ID:"_CTPCPCarPrvTpDR_"}"
		s strSpecDR = "{ID:"_CTPCPSpecDR_"}"
		s strCTLANDR = "{ID:"_SSUSRCTLANDR_"}"
		if ((AuUserHospStr[strHospitalID)||(AuUserHospStr=1))||((AuUserHospStr="off"))&&((AuUserStr[strSSUSRRowId)||(AuUserFlag=1))&&((AuSSUSRDeptDRStr[strDefaultDeptDR)||(AuSSUSRDeptDRFlag=1))&&((AuSSUSRGroupDStr[strGroupD)||(AuSSUSRGroupDFlag=1))&&((AuSSUSRLANDRStr[strCTLANDR)||(AuSSUSRLANDRFlag=1))&&((AuSSUSRProvDRStr[strCareProvDR)||(AuSSUSRProvDRFlag=1))&&((AuCTPCPPrvTpDRStr[strCarPrvTpDR)||(AuCTPCPPrvTpDRFlag=1))&&((AuCTPCPSpecDRStr[strSpecDR)||(AuCTPCPSpecDRFlag=1))&&((AuSSUSRHospDRStr[strHospitalID)||(AuSSUSRHospDRFlag=1)){

			s SSUSRInitials=$p($g(^SSU("SSUSR",SSUSRRowId)),"^",1)       //人事ID
			s SSUSRName=$p($g(^SSU("SSUSR",SSUSRRowId)),"^",2)       //用户名
			
			s SSUSRDefaultDeptDR=$p($g(^SSU("SSUSR",SSUSRRowId)),"^",4)     //登录科室DR
			s SSUSRGroupD=$p($g(^SSU("SSUSR",SSUSRRowId)),"^",5)  //安全组DR
			s SSUSRCareProvDR=$p($g(^SSU("SSUSR",SSUSRRowId)),"^",14)      //医护人员DR
			s:SSUSRCareProvDR'="" CTPCPCarPrvTpDR=$p($g(^CTPCP(SSUSRCareProvDR,1)),"^",4)    //医护人员类型ID
			s:SSUSRCareProvDR="" CTPCPCarPrvTpDR=""
			s:SSUSRCareProvDR'="" CTPCPSpecDR=$p($g(^CTPCP(SSUSRCareProvDR,1)),"^",10)      //医护人员专长ID
			s:SSUSRCareProvDR="" CTPCPSpecDR=""
			s SSUSRActive=$p($g(^SSU("SSUSR",SSUSRRowId)),"^",19)      //是否激活
			s SSUSRHospitalDR=$p($g(^SSU("SSUSR",SSUSRRowId)),"^",98) 	//医院
			/*
			s ALIASText1=""
			s AliasRowId=0
			for{
				s AliasRowId=$o(^User.BDPAliasI("DataRef","SS_User",SSUSRRowId,AliasRowId))
				q:AliasRowId=""
	  			S ALIASText=$LISTGET($g(^User.BDPAliasD(AliasRowId)),2)
				s ALIASText1=ALIASText1_"^"_$ZCONVERT(ALIASText,"U")
			}
			s PINYIN=""
			s:Name'="" PINYIN= ##class(web.DHCBL.BDP.FunLib).GetPYCODE(SSUSRName)
			*/
			 if (Name'="")
   			{
    			;需要对描述或者别名进行检索      
    			s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("SS_User",SSUSRRowId,SSUSRName,Name)
   			}
   			else
   			{
     			s AliasFlag= 1   
   			}  

			s Flag=0
			s ChildSub=0
			for {
				s ChildSub=$o(^SSU("SSUSR",SSUSRRowId,"OTHLL",ChildSub)) q:ChildSub=""
				s OTHLLCTLOCDR=$p($g(^SSU("SSUSR",SSUSRRowId,"OTHLL",ChildSub)),"^",1)  //登陆科室id
				s OTHLLUserGroupDR=$p($g(^SSU("SSUSR",SSUSRRowId,"OTHLL",ChildSub)),"^",2)  //安全组id	
				if ((OTHLLCTLOCDR=DefaultDeptDR)&(OTHLLUserGroupDR=SSUSRGroup))||((DefaultDeptDR="")&(OTHLLUserGroupDR=SSUSRGroup))||((OTHLLCTLOCDR=DefaultDeptDR)&(SSUSRGroup="")){
					s Flag=1
				}
			}
			s careDrData=""
			if (SCTLOCDR'=""){
				s RESRowId1=0
				for
				{
					s RESRowId1=$o(^RB("RES",0,"CTLOC",SCTLOCDR,RESRowId1)) q:RESRowId1="" 
					s RESCTPCPDR=$p($g(^RB("RES",RESRowId1)),"^",2)       //医护人员ID
					continue:RESCTPCPDR=""
					s careDrData = careDrData_",{ID:"_RESCTPCPDR_"}"
				}
			}
			s DSSUSRCareProvDR= "{ID:"_SSUSRCareProvDR_"}"
			i ($ZCONVERT(SSUSRInitials,"U")[Initials)&(AliasFlag=1) &((((SSUSRGroupD=SSUSRGroup)||(SSUSRGroup=""))&((SSUSRDefaultDeptDR=DefaultDeptDR)||(DefaultDeptDR="")))||(Flag=1) )&((CTPCPCarPrvTpDR=CarPrvTpDR)||(CarPrvTpDR=""))&((CTPCPSpecDR=SpecDR)||(SpecDR=""))&((careDrData[DSSUSRCareProvDR)||(SCTLOCDR=""))&((SSUSRHospitalDR=hosp)||(hosp=""))&((SSUSRActive=Active)||(Active=""))  //条件
			/*((PINYIN[Name)||($ZCONVERT(SSUSRName,"U")[Name)||(ALIASText1[Name))*/
			{
				;临时Global设置:默认登录科室-用户
				if (flagType["SSUSRDefaultDeptDR"){
					if (SSUSRDefaultDeptDR="") s SSUSRDefaultDeptDR=0
					if ($d(^TMP("ColumnTree","User.SSUser","SSUSRDefaultDeptDR",SSUSRDefaultDeptDR))){
						s ^TMP("ColumnTree","User.SSUser","SSUSRDefaultDeptDR",SSUSRDefaultDeptDR)=^TMP("ColumnTree","User.SSUser","SSUSRDefaultDeptDR",SSUSRDefaultDeptDR)_"^"_SSUSRRowId
					}else{
						s ^TMP("ColumnTree","User.SSUser","SSUSRDefaultDeptDR",SSUSRDefaultDeptDR)=SSUSRRowId
					}	
				}
				;临时Global设置:科室-用户
				if (flagType["RESCTLOCDR"){
					if ((SSUSRCareProvDR'="")&&($d(^RB("RES",0,"CTPCP",SSUSRCareProvDR))=0))||(SSUSRCareProvDR=""){ 
						if ($d(^TMP("ColumnTree","User.SSUser","RESCTLOCDR","0"))){
							s ^TMP("ColumnTree","User.SSUser","RESCTLOCDR","0")=^TMP("ColumnTree","User.SSUser","RESCTLOCDR","0")_"^"_SSUSRRowId
						}else{
							s ^TMP("ColumnTree","User.SSUser","RESCTLOCDR","0")=SSUSRRowId
						}
					}
					s RESCTLOCDR=0
					for
					{
						s RESCTLOCDR=$o(^RB("RES",0,"CTLOC",RESCTLOCDR)) q:RESCTLOCDR="" 
						s CTPCPDRData=""
						s RESRowId1=0
						for
						{
							s RESRowId1=$o(^RB("RES",0,"CTLOC",RESCTLOCDR,RESRowId1)) q:RESRowId1="" 
							s RESCTPCPDR=$p($g(^RB("RES",RESRowId1)),"^",2)
							continue:RESCTPCPDR=""
							s CTPCPDRData = CTPCPDRData_",{ID:"_RESCTPCPDR_"}"
						}
						if (CTPCPDRData[DSSUSRCareProvDR){
							if ($d(^TMP("ColumnTree","User.SSUser","RESCTLOCDR",RESCTLOCDR))){
								s ^TMP("ColumnTree","User.SSUser","RESCTLOCDR",RESCTLOCDR)=^TMP("ColumnTree","User.SSUser","RESCTLOCDR",RESCTLOCDR)_"^"_SSUSRRowId
							}else{
								s ^TMP("ColumnTree","User.SSUser","RESCTLOCDR",RESCTLOCDR)=SSUSRRowId
							}
						}
					}
				}
				;临时Global设置:安全组-用户
				if (flagType["SSUSRGroup"){
					if (SSUSRGroupD="") s SSUSRGroupD=0
					if ($d(^TMP("ColumnTree","User.SSUser","SSUSRGroup",SSUSRGroupD))){
						s ^TMP("ColumnTree","User.SSUser","SSUSRGroup",SSUSRGroupD)=^TMP("ColumnTree","User.SSUser","SSUSRGroup",SSUSRGroupD)_"^"_SSUSRRowId
					}else{
						s ^TMP("ColumnTree","User.SSUser","SSUSRGroup",SSUSRGroupD)=SSUSRRowId
					}	
				}
				;临时Global设置:医护人员类型-用户
				if (flagType="CTPCPCarPrvTpDR"){
					if (CTPCPCarPrvTpDR="") s CTPCPCarPrvTpDR=0
					if ($d(^TMP("ColumnTree","User.SSUser",flagType,CTPCPCarPrvTpDR))){
						s ^TMP("ColumnTree","User.SSUser",flagType,CTPCPCarPrvTpDR)=^TMP("ColumnTree","User.SSUser",flagType,CTPCPCarPrvTpDR)_"^"_SSUSRRowId
					}else{
						s ^TMP("ColumnTree","User.SSUser",flagType,CTPCPCarPrvTpDR)=SSUSRRowId
					}	
				}
				;临时Global设置:医生专长-用户
				if (flagType="CTPCPSpecDR"){
					if (CTPCPSpecDR="") s CTPCPSpecDR=0
					if ($d(^TMP("ColumnTree","User.SSUser",flagType,CTPCPSpecDR))){
						s ^TMP("ColumnTree","User.SSUser",flagType,CTPCPSpecDR)=^TMP("ColumnTree","User.SSUser",flagType,CTPCPSpecDR)_"^"_SSUSRRowId
					}else{
						s ^TMP("ColumnTree","User.SSUser",flagType,CTPCPSpecDR)=SSUSRRowId
					}	
				}
				;临时Global设置:医院-用户
				if (flagType="SSUSRHospitalDR"){
					if (SSUSRHospitalDR="") s SSUSRHospitalDR=0
					if ($d(^TMP("ColumnTree","User.SSUser",flagType,SSUSRHospitalDR))){
						s ^TMP("ColumnTree","User.SSUser",flagType,SSUSRHospitalDR)=^TMP("ColumnTree","User.SSUser",flagType,SSUSRHospitalDR)_"^"_SSUSRRowId
					}else{
						s ^TMP("ColumnTree","User.SSUser",flagType,SSUSRHospitalDR)=SSUSRRowId
					}	
				}
			}
		}	
	} 
	;临时Global设置:医院-默认登录科室
	if (flagType="HospitalSSUSRDefaultDeptDR"){
		s CTLOCRowID=0
		for  
		{	
			s CTLOCRowID=$o(^TMP("ColumnTree","User.SSUser","SSUSRDefaultDeptDR",CTLOCRowID)) q:CTLOCRowID="" 
			s CTLOCHospitalDR=$p($g(^CTLOC(CTLOCRowID)),"^",22) 
			if (CTLOCHospitalDR="") s CTLOCHospitalDR=0
			if ($d(^TMP("ColumnTree","User.SSUser",flagType,CTLOCHospitalDR))){
				s ^TMP("ColumnTree","User.SSUser",flagType,CTLOCHospitalDR)=^TMP("ColumnTree","User.SSUser",flagType,CTLOCHospitalDR)_"^"_CTLOCRowID
			}else{
				s ^TMP("ColumnTree","User.SSUser",flagType,CTLOCHospitalDR)=CTLOCRowID
			}	
		}
	}
	;临时Global设置:医院-科室
	if (flagType="HospitalRESCTLOCDR"){
		s CTLOCRowID=0
		for  
		{	
			s CTLOCRowID=$o(^TMP("ColumnTree","User.SSUser","RESCTLOCDR",CTLOCRowID)) q:CTLOCRowID="" 
			s CTLOCHospitalDR=$p($g(^CTLOC(CTLOCRowID)),"^",22) 
			if (CTLOCHospitalDR="") s CTLOCHospitalDR=0
			if ($d(^TMP("ColumnTree","User.SSUser",flagType,CTLOCHospitalDR))){
				s ^TMP("ColumnTree","User.SSUser",flagType,CTLOCHospitalDR)=^TMP("ColumnTree","User.SSUser",flagType,CTLOCHospitalDR)_"^"_CTLOCRowID
			}else{
				s ^TMP("ColumnTree","User.SSUser",flagType,CTLOCHospitalDR)=CTLOCRowID
			}	
		}
	}
	;临时Global设置:医院-安全组
	if (flagType="HospitalSSUSRGroup"){
		s SSGRPRowId=0
		for  
		{	
			s SSGRPRowId=$o(^TMP("ColumnTree","User.SSUser","SSUSRGroup",SSGRPRowId)) q:SSGRPRowId="" 
			if ($d(^SSU("SSGRP",SSGRPRowId,"HOSP"))=0){ 
				s CTHospitalDR=0
				if ($d(^TMP("ColumnTree","User.SSUser",flagType,CTHospitalDR))){
					s ^TMP("ColumnTree","User.SSUser",flagType,CTHospitalDR)=^TMP("ColumnTree","User.SSUser",flagType,CTHospitalDR)_"^"_SSGRPRowId
				}else{
					s ^TMP("ColumnTree","User.SSUser",flagType,CTHospitalDR)=SSGRPRowId
				}
			}
			s HOSPChildsub=0
			for
			{
				s HOSPChildsub=$o(^SSU("SSGRP",SSGRPRowId,"HOSP",HOSPChildsub)) q:HOSPChildsub=""
				s CTHospitalDR=$g(^SSU("SSGRP",SSGRPRowId,"HOSP",HOSPChildsub))
				
				if ($d(^TMP("ColumnTree","User.SSUser",flagType,CTHospitalDR))){
					s ^TMP("ColumnTree","User.SSUser",flagType,CTHospitalDR)=^TMP("ColumnTree","User.SSUser",flagType,CTHospitalDR)_"^"_SSGRPRowId
				}else{
					s ^TMP("ColumnTree","User.SSUser",flagType,CTHospitalDR)=SSGRPRowId
				}
			}
			
		}
	}
	;SSUSRDefaultDeptDR/RESCTLOCDR/SSUSRGroup
	if ($e(flagType,1,8)="Hospital"){
		if ($d(^TMP("ColumnTree","User.SSUser",$e(flagType,9,$l(flagType)),"0"))=0){
			s ^TMP("ColumnTree","User.SSUser",$e(flagType,9,$l(flagType)),"0")=""
		}
	}
	if ($d(^TMP("ColumnTree","User.SSUser",flagType,"0"))=0){
		s ^TMP("ColumnTree","User.SSUser",flagType,"0")=""
	}
}

/// 获取三级节点中的根节点：医院
ClassMethod GetHospitalNode(flagType As %String) As %String
{
	s i=0
	s HOSPRowId=0
			for  
			{	
				s HOSPRowId=$o(^TMP("ColumnTree","User.SSUser",flagType,HOSPRowId)) q:HOSPRowId="" 

				;用户条数
				s userCount=""
				s locs=^TMP("ColumnTree","User.SSUser",flagType,HOSPRowId)
				if (locs'=""){
					s locCount=$Length(locs,"^")
					for j=1:1:locCount
					{
						s CTLOCRowID=$p(locs,"^",j)
						s users=^TMP("ColumnTree","User.SSUser",$e(flagType,9,$l(flagType)),CTLOCRowID)
						s useCount=$Length(users,"^")
						s userCount=userCount+useCount
					}
				}
				s HOSPDesc=$p($g(^CT("HOSP",HOSPRowId)),"^",2)
				if (i=0){
					w "{SSUSRName:'"_HOSPDesc_"#"_userCount_"',id:'H"_HOSPRowId_"',uiProvider:'col',iconCls:'icon-Hospital'}" 
				}else{
					w ",{SSUSRName:'"_HOSPDesc_"#"_userCount_"',id:'H"_HOSPRowId_"',uiProvider:'col',iconCls:'icon-Hospital'}" 
				}
				s i=i+1
			}
			if ((^TMP("ColumnTree","User.SSUser",flagType,0)'="")||(^TMP("ColumnTree","User.SSUser",$e(flagType,9,$l(flagType)),0)'="")){
				;用户条数
				s userCount=""
				s locs=^TMP("ColumnTree","User.SSUser",flagType,0)
				if (locs'=""){
					s locCount=$Length(locs,"^")
					for j=1:1:locCount
					{
						s CTLOCRowID=$p(locs,"^",j)
						s users=^TMP("ColumnTree","User.SSUser",$e(flagType,9,$l(flagType)),CTLOCRowID)
						s useCount=$Length(users,"^")
						s userCount=userCount+useCount
					}
				}
				if ($d(^TMP("ColumnTree","User.SSUser",$e(flagType,9,$l(flagType)),0))){
					s nusers=^TMP("ColumnTree","User.SSUser",$e(flagType,9,$l(flagType)),0)
					if (nusers'=""){
						s nuserCount=$Length(nusers,"^")
						s userCount=userCount+nuserCount
					}
				}
				if (i=0){
					w "{SSUSRName:'未关联#"_userCount_"',id:'H0',uiProvider:'col',iconCls:'icon-Hospital'}" 
				}else{
					w ",{SSUSRName:'未关联#"_userCount_"',id:'H0',uiProvider:'col',iconCls:'icon-Hospital'}" 
				}
			}
}

/// 获取二级节点中的根节点：登录科室/科室/安全组/医护人员类型/医生专长/医院
ClassMethod GetParentNode(flagType As %String) As %String
{
	s j=0
	s RowId=0
		for  
		{	
			s RowId=$o(^TMP("ColumnTree","User.SSUser",flagType,RowId)) q:RowId="" 
			;用户条数
			s userCount=""
			s users=^TMP("ColumnTree","User.SSUser",flagType,RowId)
			s:users'="" userCount=$Length(users,"^")
			if ((flagType="SSUSRDefaultDeptDR")||(flagType="RESCTLOCDR")){
				s Desc=$p($g(^CTLOC(RowId)),"^",2) 
			}elseif(flagType="SSUSRGroup"){
				s Desc=$p($g(^SSU("SSGRP",RowId)),"^",1)
			}elseif(flagType="CTPCPCarPrvTpDR"){
				s Desc=$p($g(^CT("CPT",RowId)),"^",2)
			}elseif(flagType="CTPCPSpecDR"){
				s Desc=$p($g(^CT("SPC",RowId)),"^",2)
			}elseif(flagType="SSUSRHospitalDR"){
				s Desc=$p($g(^CT("HOSP",RowId)),"^",2)
			}
			if (j=0){
				w "{SSUSRName:'"_Desc_"#"_userCount_"',id:'L"_RowId_"',uiProvider:'col',iconCls:'icon-Loc'}" 
			}else{
				w ",{SSUSRName:'"_Desc_"#"_userCount_"',id:'L"_RowId_"',uiProvider:'col',iconCls:'icon-Loc'}" 

			}
			s j=j+1
		}
		if (^TMP("ColumnTree","User.SSUser",flagType,0)'=""){
			;用户条数
			s userCount=""
			s users=^TMP("ColumnTree","User.SSUser",flagType,0)
			if (users'="") s userCount=$Length(users,"^")
			if (j=0){
				w "{SSUSRName:'未关联#"_userCount_"',id:'L0',uiProvider:'col',iconCls:'icon-Loc'}" 
			}else{
				w ",{SSUSRName:'未关联#"_userCount_"',id:'L0',uiProvider:'col',iconCls:'icon-Loc'}" 
			}
		}
}

/// 树形界面 查询方法
/// Others:w ##class(web.DHCBL.CT.SSUser).GetListJson2("root","","","demo","","","","","","","","","","default","HospitalSSUSRDefaultDeptDR","")
ClassMethod GetListJson2(ParentID, rowid, Initials, Name, Active, SSUSRGroup, DefaultDeptDR, CarPrvTpDR, SpecDR, SCTLOCDR, hosp, treetype, category, sort, flagType, rebuild) As %String
{
	if ((ParentID="root")||(rebuild="Y")){
		d ..GetColumnTree2(rowid, Initials, Name, Active, SSUSRGroup, DefaultDeptDR, CarPrvTpDR, SpecDR, SCTLOCDR, hosp, treetype, category, flagType)
	}
	w "["
	if (ParentID="root"){
		if ($e(flagType,1,8)="Hospital"){
			;根节点：医院
			d ..GetHospitalNode(flagType)
		}else{
			;根节点：登录科室/科室/安全组/医护人员类型/医生专长/医院
			d ..GetParentNode(flagType)
		}	
	}
	if ($e(ParentID,1)="H"){
		;二级节点：登录科室/科室/安全组
		s locStr=^TMP("ColumnTree","User.SSUser",flagType,$e(ParentID,2,$l(ParentID)))
		s j=0
		if (locStr'=""){
			s locLen=$Length(locStr,"^")
			for i=1:1:locLen
			{
				s RowId=$p(locStr,"^",i)
				
				;用户条数
				s userCount=""
				s users=^TMP("ColumnTree","User.SSUser",$e(flagType,9,$l(ParentID)),RowId)
				if (users'="") s userCount=$Length(users,"^")
				if ((flagType="HospitalSSUSRDefaultDeptDR")||(flagType="HospitalRESCTLOCDR")){
					s Desc=$p($g(^CTLOC(RowId)),"^",2) 
				}elseif(flagType="HospitalSSUSRGroup"){
					s Desc=$p($g(^SSU("SSGRP",RowId)),"^",1)
				}		
				if (j=0){
					w "{SSUSRName:'"_Desc_"#"_userCount_"',id:'"_$e(ParentID,2,$l(ParentID))_"L"_RowId_"',uiProvider:'col',iconCls:'icon-Loc'}" 
				}else{
					w ",{SSUSRName:'"_Desc_"#"_userCount_"',id:'"_$e(ParentID,2,$l(ParentID))_"L"_RowId_"',uiProvider:'col',iconCls:'icon-Loc'}"  
				}
				s j=j+1
			}
		}
		if ($e(ParentID,2)="0"){
			if (^TMP("ColumnTree","User.SSUser",$e(flagType,9,$l(flagType)),0)'=""){
				;用户条数
				s userCount=""
				s users=^TMP("ColumnTree","User.SSUser",$e(flagType,9,$l(flagType)),0)
				if (users'="") s userCount=$Length(users,"^")
				if (j=0){
					w "{SSUSRName:'未关联#"_userCount_"',id:'"_$e(ParentID,2,$l(ParentID))_"L0',uiProvider:'col',iconCls:'icon-Loc'}" 
				}else{
					w ",{SSUSRName:'未关联#"_userCount_"',id:'"_$e(ParentID,2,$l(ParentID))_"L0',uiProvider:'col',iconCls:'icon-Loc'}" 
				}
			}
		}	
	}
	;叶子节点：用户 
	if (ParentID["L"){
		k ^TMP("BDPSortByParams","sort","web.DHCBL.CT.SSUser2")
		if ($e(flagType,1,8)="Hospital") s flagType=$e(flagType,9,$l(flagType))
		s userStr=^TMP("ColumnTree","User.SSUser",flagType,$p(ParentID,"L",2))
		if (userStr'=""){
			s userLen=$Length(userStr,"^")
			for i=1:1:userLen
			{
				s SSUSRRowId=$p(userStr,"^",i)
				q:($d(^SSU("SSUSR",SSUSRRowId))=0)
				
					if (sort="SSUSRInitials"){
						s SSUSRInitials=$p($g(^SSU("SSUSR",SSUSRRowId)),"^",1)
						s PINYINInitials=##class(web.DHCBL.BDP.FunLib).GetPYCODE(SSUSRInitials)
						d ##class(web.DHCBL.BDP.BDPSortByParams).GetSortbyParams("web.DHCBL.CT.SSUser2",PINYINInitials,SSUSRRowId)  
					}
					if (sort="SSUSRName"){
						s SSUSRName=$p($g(^SSU("SSUSR",SSUSRRowId)),"^",2)
           				s PINYINName=##class(web.DHCBL.BDP.FunLib).GetPYCODE(SSUSRName)
           				d ##class(web.DHCBL.BDP.BDPSortByParams).GetSortbyParams("web.DHCBL.CT.SSUser2",PINYINName,SSUSRRowId)  
					}
					if (sort="default"){
						d ##class(web.DHCBL.BDP.BDPSortByParams).GetSortbyParams("web.DHCBL.CT.SSUser2",SSUSRRowId,SSUSRRowId)  
					}
				
			}
			 s PLIST = ##class(web.DHCBL.BDP.BDPSortByParams).GetSortDataIDS("web.DHCBL.CT.SSUser2")
			 s k=0
			 s methodname = "Count"
 			 s elements = $METHOD(PLIST,methodname)
          	 for i=1:1:elements
          	 {
            	s SSUSRRowId=$tr(PLIST.GetAt(i),"'","")
            	q:SSUSRRowId=""
				s SSUSRName=$p($g(^SSU("SSUSR",SSUSRRowId)),"^",2) 
				s SSUSRName=$tr(SSUSRName,$c(13,10),"")	
				s SSUSRInitials=$p($g(^SSU("SSUSR",SSUSRRowId)),"^",1)       //人事ID
				s SSUSRInitials=$tr(SSUSRInitials,$c(13,10),"")	
				s SSUSRGroupD=$p($g(^SSU("SSUSR",SSUSRRowId)),"^",5)  //安全组DR
				s:SSUSRGroupD'="" SSGRPDesc=$p($g(^SSU("SSGRP",SSUSRGroupD)),"^",1) //安全组名称
				s:SSUSRGroupD="" SSGRPDesc=""
				s SSUSRCareProvDR=$p($g(^SSU("SSUSR",SSUSRRowId)),"^",14)      //医护人员DR
				s:SSUSRCareProvDR'="" CTPCPCode=$p($g(^CTPCP(SSUSRCareProvDR,1)),"^",1) //医护人员工号
				s:SSUSRCareProvDR="" CTPCPCode=""
				s:SSUSRCareProvDR'="" CTPCPDesc=$p($g(^CTPCP(SSUSRCareProvDR,1)),"^",2) //医护人员姓名
				s:SSUSRCareProvDR="" CTPCPDesc=""
				s:SSUSRCareProvDR'="" CTPCPCarPrvTpDR=$p($g(^CTPCP(SSUSRCareProvDR,1)),"^",4)    //医护人员类型ID
				s:SSUSRCareProvDR="" CTPCPCarPrvTpDR=""
				s:CTPCPCarPrvTpDR'="" CTCPTDesc=$p($g(^CT("CPT",CTPCPCarPrvTpDR)),"^",2) //医护人员类型
				s:CTPCPCarPrvTpDR="" CTCPTDesc=""
				s:SSUSRCareProvDR'="" CTPCPOtherName=$p($g(^CTPCP(SSUSRCareProvDR,3)),"^",28)  //拼音检索码
				s:SSUSRCareProvDR="" CTPCPOtherName=""
				s SSUSRActive=$p($g(^SSU("SSUSR",SSUSRRowId)),"^",19)      //是否激活
				s SSUSRDateFrom=$p($g(^SSU("SSUSR",SSUSRRowId)),"^",96)    //开始日期
				s SSUSRDateTo=$p($g(^SSU("SSUSR",SSUSRRowId)),"^",97)  //截止日期
				s:SSUSRDateFrom'="" SSUSRDateFrom=$zd(SSUSRDateFrom,1) //转换日期格式
				s:SSUSRDateTo'="" SSUSRDateTo=$zd(SSUSRDateTo,1) //转换日期格式
				
				if (k=0){
					w "{SSUSRName:'"_SSUSRName_"',id:'"_SSUSRRowId_"',SSUSRInitials:'"_SSUSRInitials_"',SSGRPDesc:'"_SSGRPDesc_"',SSUSRCareProvDR:'"_SSUSRCareProvDR_"',CTPCPCode:'"_CTPCPCode_"',CTPCPDesc:'"_CTPCPDesc_"',CTCPTDesc:'"_CTCPTDesc_"',CTPCPOtherName:'"_CTPCPOtherName_"',SSUSRActive:'"_SSUSRActive_"',SSUSRDateFrom:'"_SSUSRDateFrom_"',SSUSRDateTo:'"_SSUSRDateTo_"',uiProvider:'col',iconCls:'icon-CareProv',leaf:true}" 
				}else{
					w ",{SSUSRName:'"_SSUSRName_"',id:'"_SSUSRRowId_"',SSUSRInitials:'"_SSUSRInitials_"',SSGRPDesc:'"_SSGRPDesc_"',SSUSRCareProvDR:'"_SSUSRCareProvDR_"',CTPCPCode:'"_CTPCPCode_"',CTPCPDesc:'"_CTPCPDesc_"',CTCPTDesc:'"_CTCPTDesc_"',CTPCPOtherName:'"_CTPCPOtherName_"',SSUSRActive:'"_SSUSRActive_"',SSUSRDateFrom:'"_SSUSRDateFrom_"',SSUSRDateTo:'"_SSUSRDateTo_"',uiProvider:'col',iconCls:'icon-CareProv',leaf:true}"
				}
				s k=k+1
			}
		}
	}	
	w "]"
	Q ""
}

/// 拖拽
ClassMethod DragNode2(id, parentid, rule) As %String
{
	s result=""
	s:parentid="0" parentid=""
	s:parentid="oot" parentid=""
	
	s obj=##class(User.SSUser).%OpenId(id)
	s CTPCPRowId=$p($g(^SSU("SSUSR",id)),"^",14) 
	
	s bSSUSRName = obj.SSUSRName
	if (rule["SSUSRDefaultDeptDR"){
		s:obj.SSUSRDefaultDeptDR'="" bSSUSRDefaultDeptDR = obj.SSUSRDefaultDeptDR.%Id()
		s:obj.SSUSRDefaultDeptDR="" bSSUSRDefaultDeptDR = ""
		s blogJson="{SSUSRRowId:"""_id_""",SSUSRDefaultDeptDR:"""_bSSUSRDefaultDeptDR_"""}"
	
		d:parentid="" obj.SSUSRDefaultDeptDRSetObjectId("")
		d:parentid'="" obj.SSUSRDefaultDeptDRSetObjectId(parentid)
		s logJson="{SSUSRRowId:"""_id_""",SSUSRDefaultDeptDR:"""_parentid_"""}"
	}
	if (rule["RESCTLOCDR"){
		if (CTPCPRowId="") Quit "{success:'false',errorinfo:'该用户未关联医护人员'}"
		if (parentid'=""){
			s rbobj=##class(web.Entity.CT.RBResource).%New()
			s result =##class(web.DHCBL.CT.CTCareProv).UpdateRBData(CTPCPRowId,parentid,"Add",+$h,"")
			q result
		}else{
			s RESCTLOCDR=0
			for
			{  
				s RESCTLOCDR=$o(^RB("RES",0,"CTPCP",CTPCPRowId,RESCTLOCDR)) q:RESCTLOCDR=""  
				s RESRowId1=0
				for
				{
					s RESRowId1=$o(^RB("RES",0,"CTPCP",CTPCPRowId,RESCTLOCDR,RESRowId1)) q:RESRowId1=""  
					d ##class(web.DHCBL.CT.RBResource).DeleteData(RESRowId1)
				}
			}
		}	
	}
	if (rule["SSUSRGroup"){
		s:obj.SSUSRGroup'="" bSSUSRGroup = obj.SSUSRGroup.%Id()	
		s:obj.SSUSRGroup="" bSSUSRGroup = ""
		s blogJson="{SSUSRRowId:"""_id_""",SSUSRGroup:"""_bSSUSRGroup_"""}"
		
		d:parentid="" obj.SSUSRGroupSetObjectId("")
		d:parentid'="" obj.SSUSRGroupSetObjectId(parentid)
		s logJson="{SSUSRRowId:"""_id_""",SSUSRGroup:"""_parentid_"""}"
	}
	if (rule="SSUSRHospitalDR"){
		s:obj.SSUSRHospitalDR'="" bSSUSRHospital = obj.SSUSRHospitalDR.%Id()	
		s:obj.SSUSRHospitalDR="" bSSUSRHospital = ""
		s blogJson="{SSUSRRowId:"""_id_""",SSUSRHospitalDR:"""_bSSUSRHospital_"""}"
		
		d:parentid="" obj.SSUSRHospitalDRSetObjectId("")
		d:parentid'="" obj.SSUSRHospitalDRSetObjectId(parentid)
		s logJson="{SSUSRRowId:"""_id_""",SSUSRHospitalDR:"""_parentid_"""}"
	} 
	if (rule["CTPCP"){
		if (CTPCPRowId="") Quit "{success:'false',errorinfo:'该用户未关联医护人员'}"
		s cobj=##class(User.CTCareProv).%OpenId(CTPCPRowId)
		s bCTPCPDesc=cobj.CTPCPDesc
		
		if (rule="CTPCPCarPrvTpDR"){
			s:cobj.CTPCPCarPrvTpDR'="" bCTPCPCarPrvTpDR = cobj.CTPCPCarPrvTpDR.%Id()	
			s:cobj.CTPCPCarPrvTpDR="" bCTPCPCarPrvTpDR = ""
			s bclogJson="{CTPCPRowId:"""_CTPCPRowId_""",CTPCPCarPrvTpDR:"""_bCTPCPCarPrvTpDR_"""}"
		
			d:parentid="" cobj.CTPCPCarPrvTpDRSetObjectId("")
			d:parentid'="" cobj.CTPCPCarPrvTpDRSetObjectId(parentid)
			s clogJson="{CTPCPRowId:"""_CTPCPRowId_""",CTPCPCarPrvTpDR:"""_parentid_"""}"
		} 
		if (rule="CTPCPSpecDR"){
			s:cobj.CTPCPSpecDR'="" bCTPCPSpecDR = cobj.CTPCPSpecDR.%Id()
			s:cobj.CTPCPSpecDR="" bCTPCPSpecDR = ""	
			s bclogJson="{CTPCPRowId:"""_CTPCPRowId_""",CTPCPSpecDR:"""_bCTPCPSpecDR_"""}"
		
			d:parentid="" cobj.CTPCPSpecDRSetObjectId("")	
			d:parentid'="" cobj.CTPCPSpecDRSetObjectId(parentid)
			s clogJson="{CTPCPRowId:"""_CTPCPRowId_""",CTPCPSpecDR:"""_parentid_"""}"
		}
		s scc=cobj.%Save()
		d cobj.%Close()
		If $$$ISOK(scc)
		{
			s result = "{success:'true',id:'"_id_"'}" 
			d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLogForOther("CT_CareProv","User.CTCareProv","医护人员",CTPCPRowId,bCTPCPDesc,"U",clogJson,bclogJson)
		}else{
			s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"
		}
		q result
	}	
	
	Ts	
	s sc=obj.%Save()
	d obj.%Close()
	If $$$ISOK(sc)
	{
		Tc
		s id = obj.%Id()
		s result = "{success:'true',id:'"_id_"'}" //返回RowId
	    d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLogForOther("SS_User","User.SSUser","用户",id,bSSUSRName,"U",logJson,blogJson)
	}else{
		Trollback
		s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"   //返回错误信息
	}
	q result
}

/// Description：吉大三院 保存修改用户部分信息-同步集成平台
/// Table：User.SSUser
/// Input：用户rowid,人事ID、姓名、办公电话、医生资格证书号
/// Return：成功返回1；失败返回0
/// Others:w ##class(web.DHCBL.CT.SSUser).SyncData("1086","测试1","测试1","测试1","123")
ClassMethod SyncData(id, SSUSRInitials, SSUSRName, CTPCPUnit, CTPCPTelO) As %String
{
	s result = ""
	s flag=..FormValidate(id,SSUSRInitials)  //调用重复验证
	if (flag=1)
	{
		s result = 0 //"{success:'false',errorinfo:'该记录已经存在！'}"
	}
	else
	{
		if (id="")  //如果Id未赋值则增加
		{
			s obj=##class(User.SSUser).%New()
			s SSUSRCareProvDR=""
		}
		else
		{
			s obj=##class(User.SSUser).%OpenId(id)
			s SSUSRCareProvDR=$p($g(^SSU("SSUSR",id)),"^",14)
		}
		
		
		if SSUSRCareProvDR=""
		{
			s cobj=##class(User.CTCareProv).%New()
		}
		else
		{
			s cobj=##class(User.CTCareProv).%OpenId(SSUSRCareProvDR)		
		}
		s CTPCPCarPrvTpDR=$o(^CT("CPT",0))
		d cobj.CTPCPCarPrvTpDRSetObjectId(CTPCPCarPrvTpDR)
		s cobj.CTPCPCode = SSUSRInitials
		s cobj.CTPCPDesc = SSUSRName
		s cobj.CTPCPUnit = CTPCPUnit
		s cobj.CTPCPTelO = CTPCPTelO		
		s scc=cobj.%Save()		
		d cobj.%Close()
		If $$$ISOK(scc)
		{				
			s result = 1  
			s SSUSRCareProvDR=cobj.%Id()
			Ts	        		        	
			s obj.SSUSRInitials = SSUSRInitials
			s obj.SSUSRName = SSUSRName
			s obj.SSUSRPassword = ##class(BSP.SYS.BL.SSUser).ToCacheBCrypt("1")
			d obj.SSUSRCareProvDRSetObjectId(SSUSRCareProvDR)
			s SSUSRGroup=$o(^SSU("SSGRP",0))
			d obj.SSUSRGroupSetObjectId(SSUSRGroup)
		
			s sc = obj.%Save()
			d obj.%Close()
			If $$$ISOK(sc)
			{
				Tc					
				s result = 1     
			}
			else
			{
				Trollback
				s result = 0
			}
		}
		else
		{
			s result = 0
		}	
	}
	q result
}

/// Creator:高姗姗
/// CreatDate:2016-7-28
/// Description：用户新增同步PASC用户接口
/// w ##class(web.DHCBL.CT.SSUser).SyncUserInfo("","testeqq","testeqq","2","false")
ClassMethod SyncUserInfo(SSUSRRowId, SSUSRInitials, SSUSRName, SSUSRDefaultDeptDR, SSUSRActive) As %String
{
	s result=""
	s SyncPACSFlag=##class(web.DHCBL.BDP.BDPConfig).GetConfigValue("BDPUserSyncPACS")
	if (SyncPACSFlag="Y")
	{
		//安全组
    	s SSUSRGroup = ""
    	s BDPGroupFlag = ##class(web.DHCBL.BDP.BDPConfig).GetConfigValue("BDPGroup")
    	if (BDPGroupFlag="Y")
    	{
	    	s SSUSRGroup = ##class(web.DHCBL.BDP.BDPConfig).GetConfigValue("BDPSSUSRGroup")
	    }
	    else
	    {
		    s SSGRPRowId=0
			for
			{
				s SSGRPRowId=$o(^SSU("SSGRP",SSGRPRowId)) q:SSGRPRowId=""
				s SSGRPDesc=$p($g(^SSU("SSGRP",SSGRPRowId)),"^",1)
				if (SSGRPDesc="Technician Manager") s SSUSRGroup = SSGRPRowId
			}
		}
	    //登陆密码
	    s SSUSRPassword = "1"
	    s BDPUserPswFlag = ##class(web.DHCBL.BDP.BDPConfig).GetConfigValue("BDPIfUserPsw")
    	if (BDPUserPswFlag="Y"){
	    	s SSUSRPassword = ##class(web.DHCBL.BDP.BDPConfig).GetConfigValue("BDPUserPsw")
	    }
	    //医嘱签名密码
	    s SSUSRPin = ""
	    s BDPSignPswFlag = ##class(web.DHCBL.BDP.BDPConfig).GetConfigValue("BDPUserSignPswOpen")
    	if (BDPSignPswFlag="Y"){
	    	s SSUSRPin = ##class(web.DHCBL.BDP.BDPConfig).GetConfigValue("BDPUserSignPsw")
	    }
	    //默认语言
    	s SSUSRCTLANDR = $o(^SS("LAN",0,"Desc","CHINESE",0))
    	
    	s SSUSRDateFrom=$p($h,",",1) //生效日期
    	s str=SSUSRInitials_"^"_SSUSRDefaultDeptDR_"^"_SSUSRCTLANDR_"^"_+$H_"^"_SSUSRPassword_"^true^"_SSUSRName_"^"_SSUSRGroup_"^^^"_SSUSRPin_"^"_SSUSRActive_"^^false^"_SSUSRRowId_"^false"
    	s result= ##class(web.DHCBL.CT.SSUser).SaveAll(str,"")
	}
	q result
}

/// chenying
/// 2019-07-19
/// 恢复误删用户数据
/// D ##class(web.DHCBL.CT.SSUser).ResumeUser(6674,173)
ClassMethod ResumeUser(SSUSRRowId, SSUSRCareProvDR) As %String
{
	//global？
	s ^SSU("SSUSR",SSUSRRowId)="1230^尹熙^U&dDF1,""7k7k^64^105^^^Y^^Y^^^20^173^U&dDF1,""7k7k^^^^Y^^^^^^^^^^^^^^^^^^^^^^^^64853^^^^^^^^^^^^^^^^^^^^N^^^^N^^^^^^^^1^64965^^^^^^^^^^^^^^^^^^^^64766^^2^^^^^^^^^^^^^^^^^^^^^^^^^^^^" 
	//？如果医护人员rowid也不一样，需要执行
	//s $p(^SSU("SSUSR",SSUSRRowId),"^",14)=SSUSRCareProvDR 
	
	b ;确认恢复？
	s SSUSRInitials=$p($g(^SSU("SSUSR",SSUSRRowId)),"^",1)       //人事ID
	if SSUSRInitials="" q "工号为空"
	if $$ALPHAUP^SSUTIL4(SSUSRInitials)'="" s ^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(SSUSRInitials),SSUSRRowId)=SSUSRInitials
	
	s SSUSRName=$p($g(^SSU("SSUSR",SSUSRRowId)),"^",2)       //用户名
	if SSUSRName="" q "姓名为空"	
	if $$ALPHAUP^SSUTIL4(SSUSRName)'="" s ^SSU("SSUSR",0,"SSUSR_Name",$$ALPHAUP^SSUTIL4(SSUSRName),SSUSRRowId)=SSUSRName


	s SSUSRGroup=$p($g(^SSU("SSUSR",SSUSRRowId)),"^",5)   //安全组
	if SSUSRGroup="" q "安全组为空"
	if SSUSRGroup'="" s ^SSU("SSUSR",0,"Group",SSUSRGroup,SSUSRRowId)=""
	
	if SSUSRCareProvDR'="" s ^SSU("SSUSR",0,"CTPCP",SSUSRCareProvDR,SSUSRRowId)=""
	
	
	s SSUSRBiokey=$p($g(^SSU("SSUSR",SSUSRRowId)),"^",111)
	if $$ALPHAUP^SSUTIL4(SSUSRBiokey)'="" s ^SSU("SSUSR",0,"BioKey",$$ALPHAUP^SSUTIL4(SSUSRBiokey),SSUSRRowId)=""
}

/// Creator：李可凡
/// CreatDate: 2020年6月18日
/// Description：校验科室和安全组关系
/// Input:科室id，安全组id
/// Output:0:校验通过	1:校验不通过
/// debug：w ##class(web.DHCBL.CT.SSUser).IfHospDifferent(1,1)
ClassMethod IfHospDifferent(locid As %String, groupid As %String) As %String
{
	s flag=0
	if (locid'="")&&(groupid'="")
	{
		s hospid=$p($g(^CTLOC(locid)),"^",22)     //科室医院
		s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag("SS_Group",groupid,hospid)
	  	s:showflag="N" flag=1
	}
	q flag
}

/// 根据身份证号获取生日xxxx-xx-xx，仅用于校验通过的18位身份证号数据
/// 基础数据平台-likefan
/// 2020-10-30
/// table: User.SSUserExtend
/// w ##class(web.DHCBL.CT.SSUser).GetBirthdayByIdNo("")
ClassMethod GetBirthdayByIdNo(IDnumber)
{
	q:IDnumber="" ""
	q:$l(IDnumber)'=18 ""
	s y=$e(IDnumber,7,10)
	q:y<1841 ""
	s m=$e(IDnumber,11,12)
	s d=$e(IDnumber,13,14)
	s date=y_"-"_m_"-"_d
	q date
}

/// 标准接口：通过用户rowid返回国家医保编码
/// 基础数据-likefan
/// 2021-11-05
/// input: 用户rowid
/// output: 国家医保编码
/// w ##class(web.DHCBL.CT.SSUser).GetINSUCodeByUserId("1")
ClassMethod GetINSUCodeByUserId(id As %String) As %String
{
	q:id="" ""
	s INSUCode=$p($g(^SSU("SSUSR",id)),"^",124)  //国家医保代码
	q INSUCode
}

/// 标准接口：通过人员工号返回国家医保编码
/// 基础数据-likefan
/// 2021-11-05
/// input: 用户工号
/// output: 国家医保编码
/// w ##class(web.DHCBL.CT.SSUser).GetINSUCodeByUserCode("demo")
ClassMethod GetINSUCodeByUserCode(code As %String) As %String
{
	q:code="" ""
	s id=$o(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(code),0))
	q:id="" ""
	s INSUCode=$p($g(^SSU("SSUSR",id)),"^",124)  //国家医保代码
	q INSUCode
}

}
