/// 与CDSS同步用户、科室、用户与科室关联表信息
/// 基础数据平台-likefan
/// 2021年4月23日
Class web.DHCBL.BDP.CDSSInterface Extends %RegisteredObject [ ProcedureBlock ]
{

/// 调用CDSS接口同步科室信息
/// likefan	2021-04-23
/// input：科室id，修改前的代码，是否停用（1停用，0在用），共库标识:与CDSS共库时传"CommonLibrary"
/// output: CDSS接口返回信息
/// w ##class(web.DHCBL.BDP.CDSSInterface).CDSSCTLocSync("","","")
ClassMethod CDSSCTLocSync(locid As %String, oldcode As %String = "", useflag As %String = "", commonflag As %String = "") As %String
{
	s $zt="ERROR"
	s CDSSAutFlag=##class(web.DHCBL.BDP.BDPConfig).GetConfigValue("CDSSDataAut")
	q:CDSSAutFlag'="Y" "-1^未开启临床决策支持数据同步"
	q:locid="" ""
	s CTLOCRowID=locid
    s DeptCode=$p($g(^CTLOC(CTLOCRowID)),"^",1)		//科室代码
	s DeptName=$p($g(^CTLOC(CTLOCRowID)),"^",2)		//科室名称
	s DeptClass=$p($g(^CTLOC(CTLOCRowID)),"^",13)	//科室类型
	s DeptClass = $case(DeptClass,"W":"Ward","E":"Execute","DI":"Drug Injection","D":"Dispensing","C":"Cashier","O":"Other","OP":"Operating Theatre","EM":"Emergency","DS":"Day Surgery","MR":"Medical Records","OR":"OutPatient Consulting Room","CL":"Clinic","ADM":"Admission Point",:"")
	if (useflag'="")
	{
		s UseFlag=useflag
	}
	else
	{
		s UseFlag=0		//使用标记
		s CTLOCDateActiveFrom=$p($G(^CTLOC(CTLOCRowID)),"^",24)	//开始日期
		s CTLOCDateActiveTo=$p($g(^CTLOC(CTLOCRowID)),"^",25)	//结束日期
		s:(CTLOCDateActiveFrom>+$h)||((CTLOCDateActiveTo'="")&&(CTLOCDateActiveTo<+$h)) UseFlag=1	//无效
	}
	s CreateDate=$zdt($h,3)		//维护时间
	if $d(%session)
	{
		s CreateUserID=$Get(%session.Data("LOGON.USERID"))
		s:CreateUserID'="" CreateUserID=$p($g(^SSU("SSUSR",CreateUserID)),"^",1)
	}
	else
	{
		s CreateUserID=$p($g(^SSU("SSUSR",1)),"^",1)	//维护人员	demo
	}
	//w DeptCode_"^"_DeptName_"^"_DeptClass_"^"_UseFlag,!
	//q ""
	s CDSSStr="<Request><DeptDictInfo><Content><DeptCode>"_DeptCode_"</DeptCode><OldCode>"_oldcode_"</OldCode><DeptName>"_DeptName_"</DeptName><FatherCode></FatherCode><DeptClass>"_DeptClass_"</DeptClass><UseFlag>"_UseFlag_"</UseFlag><CreateDate>"_CreateDate_"</CreateDate><CreateUserID>"_CreateUserID_"</CreateUserID><Remarks></Remarks></Content></DeptDictInfo></Request>"
	//q CDSSStr
	s stream=##class(%Stream.GlobalCharacter).%New()
	d stream.Write(CDSSStr)
	if (commonflag="CommonLibrary")
	{
		s re=##class(web.CDSS.MachineLearning.UserAndDeptSynchronized).DHCServerInterface("DEPARTMENT_DICTIONARY_SYNCHRONIZATION",stream.Read())
	}
	else
	{
		s Soap=##class(InteplatformService.InteplatformServiceSoap).%New()
		s Soap.Timeout=3 //设置超时时间3s
		s re=Soap.DHCServerInterface("DEPARTMENT_DICTIONARY_SYNCHRONIZATION",stream.Read())
	}
	q re
ERROR
	Q "ERROR"
}

/// 调用CDSS接口同步用户信息，过滤无关联医护人员数据，过滤非医生护士数据
/// likefan	2021-04-23
/// input：用户id，修改前的代码，是否停用（1停用，0在用），共库标识:与CDSS共库时传"CommonLibrary"
/// output: CDSS接口返回信息
/// w ##class(web.DHCBL.BDP.CDSSInterface).CDSSUserSync("","")
ClassMethod CDSSUserSync(userid As %String, oldcode As %String = "", useflag As %String = "", commonflag As %String = "") As %String
{
	s $zt="ERROR"
	s CDSSAutFlag=##class(web.DHCBL.BDP.BDPConfig).GetConfigValue("CDSSDataAut")
	q:CDSSAutFlag'="Y" "-1^未开启临床决策支持数据同步"
	q:userid="" ""
	s SSUSRRowId=userid
	s SSUSRCareProvDR=$p($g(^SSU("SSUSR",SSUSRRowId)),"^",14)      //医护人员DR
	q:SSUSRCareProvDR="" "无关联医护人员"
	s UserRoles="9"
	s CTPCPCarPrvTpDR=$p($g(^CTPCP(SSUSRCareProvDR,1)),"^",4)    //医护人员类型ID
	s CTCPTInternalType=$p($g(^CT("CPT",CTPCPCarPrvTpDR)),"^",4)
	s:CTCPTInternalType="DOCTOR" UserRoles=0
	s:CTCPTInternalType="NURSE" UserRoles=1
	q:'((UserRoles=0)||(UserRoles=1)) "仅同步医生护士"
	s UserCode=$p($g(^SSU("SSUSR",SSUSRRowId)),"^",1)	//用户编码
	s UserName=$p($g(^SSU("SSUSR",SSUSRRowId)),"^",2)	//用户姓名
	s LoginName=""			//登录密码
	s UserJobTitle=""
	s CTPCPTitleDR=$p($g(^CTPCP(SSUSRCareProvDR,3)),"^",29)  //医护人员职称
	s:CTPCPTitleDR'="" UserJobTitle=$p($g(^CT("TTL",CTPCPTitleDR)),"^",2)
	s CreateDate=$zdt($h,3)		//维护时间
	if $d(%session)
	{
		s CreateUser=$Get(%session.Data("LOGON.USERID"))
		s:CreateUser'="" CreateUser=$p($g(^SSU("SSUSR",CreateUser)),"^",1)
	}
	else
	{
		s CreateUser=$p($g(^SSU("SSUSR",1)),"^",1)	//维护人员	demo
	}
	s SSUSRActive=$p($g(^SSU("SSUSR",SSUSRRowId)),"^",19)      //是否激活
	s:useflag'="" UseFlag=useflag
	s:useflag="" UseFlag=$case(SSUSRActive,"Y":"0",:"1")		//使用标记
	//w UserCode_"^"_UserName_"^"_UserRoles_"^"_UserJobTitle_"^"_UseFlag,!
	//q ""
	s CDSSStr="<Request><UserDictInfo><Content><UserCode>"_UserCode_"</UserCode><OldCode>"_oldcode_"</OldCode><UserName>"_UserName_"</UserName><FatherCode>"_UserCode_"</FatherCode><LoginName>"_LoginName_"</LoginName><UserRoles>"_UserRoles_"</UserRoles><UserJobTitle>"_UserJobTitle_"</UserJobTitle><CreateDate>"_CreateDate_"</CreateDate><CreateUser>"_CreateUser_"</CreateUser><UseFlag>"_UseFlag_"</UseFlag><Remarks></Remarks></Content></UserDictInfo></Request>"
	//q CDSSStr
	s stream=##class(%Stream.GlobalCharacter).%New()
	d stream.Write(CDSSStr)
	if (commonflag="CommonLibrary")
	{
		s re=##class(web.CDSS.MachineLearning.UserAndDeptSynchronized).DHCServerInterface("USER_DICTIONARY_SYNCHRONIZATION",stream.Read())
	}
	else
	{
		s Soap=##class(InteplatformService.InteplatformServiceSoap).%New()
		s Soap.Timeout=3 //设置超时时间3s
		s re=Soap.DHCServerInterface("USER_DICTIONARY_SYNCHRONIZATION",stream.Read())
	}
	q re
ERROR
	Q "ERROR"
}

/// 调用CDSS接口同步用户关联科室信息
/// likefan	2021-04-23
/// input：用户id或其他登录科室rowid，是否停用（1停用，0在用），共库标识:与CDSS共库时传"CommonLibrary"
/// output: CDSS接口返回信息
/// w ##class(web.DHCBL.BDP.CDSSInterface).CDSSUserLinkLocSync("","")
ClassMethod CDSSUserLinkLocSync(id As %String, useflag As %String = "", commonflag As %String = "") As %String
{
	s $zt="ERROR"
	s CDSSAutFlag=##class(web.DHCBL.BDP.BDPConfig).GetConfigValue("CDSSDataAut")
	q:CDSSAutFlag'="Y" "-1^未开启临床决策支持数据同步"
	q:id="" ""
	if (id["||")	//其他登录科室数据
	{
		s ChildSub=$p($g(id),"||",2)
		s ParRef=$p($g(id),"||",1)
		s UserCode=$p($g(^SSU("SSUSR",ParRef)),"^",1)		//用户编码
		s DeptCode=$p($g(^SSU("SSUSR",ParRef,"OTHLL",ChildSub)),"^",1)		//登录科室DR
		s:DeptCode'="" DeptCode=$p($g(^CTLOC(DeptCode)),"^",1)		//科室代码
		s StartTime=$p($g(^SSU("SSUSR",ParRef,"OTHLL",ChildSub)),"^",4)		//开始日期
		s EndTime=$p($g(^SSU("SSUSR",ParRef,"OTHLL",ChildSub)),"^",5)		//结束日期
		q:(UserCode="")||(DeptCode="") ""
	}
	else	//用户数据
	{
		s UserCode=$p($g(^SSU("SSUSR",id)),"^",1)		//用户编码
		s DeptCode=$p($g(^SSU("SSUSR",id)),"^",4)		//登录科室DR
		s:DeptCode'="" DeptCode=$p($g(^CTLOC(DeptCode)),"^",1)		//科室代码
		s StartTime=$p($g(^SSU("SSUSR",id)),"^",96)		//开始日期
		s EndTime=$p($g(^SSU("SSUSR",id)),"^",97)		//结束日期
		q:(UserCode="")||(DeptCode="") ""
	}
	if (useflag'="")
	{
		s UseFlag=useflag
	}
	else
	{
		s UseFlag=0
		s:(StartTime>+$h)||((EndTime'="")&&(EndTime<+$h)) UseFlag=1	//无效
	}
	s:StartTime'="" StartTime=$zd(StartTime,3)_" 00:00:00"
	s:EndTime'="" EndTime=$zd(EndTime,3)_" 00:00:00"
	s CreateDate=$zdt($h,3)		//维护时间
	if $d(%session)
	{
		s CreateUser=$Get(%session.Data("LOGON.USERID"))
		s:CreateUser'="" CreateUser=$p($g(^SSU("SSUSR",CreateUser)),"^",1)
	}
	else
	{
		s CreateUser=$p($g(^SSU("SSUSR",1)),"^",1)	//维护人员	demo
	}
	
	//w UserCode_"^"_DeptCode_"^"_StartTime_"^"_EndTime_"^"_CreateDate_"^"_CreateUser_"^"_UseFlag,!
	//q ""
	s CDSSStr="<Request><UserJoinDeptInfo><Content><UserCode>"_UserCode_"</UserCode><UserJoinDeptSeq></UserJoinDeptSeq><FatherCode>"_DeptCode_"</FatherCode><StartTime>"_StartTime_"</StartTime><EndTime>"_EndTime_"</EndTime><CreateDate>"_CreateDate_"</CreateDate><CreateUser>"_CreateUser_"</CreateUser><UseFlag>"_UseFlag_"</UseFlag><Remarks></Remarks></Content></UserJoinDeptInfo></Request>"
	//w CDSSStr,!
	s stream=##class(%Stream.GlobalCharacter).%New()
	d stream.Write(CDSSStr)
	if (commonflag="CommonLibrary")
	{
		s re=##class(web.CDSS.MachineLearning.UserAndDeptSynchronized).DHCServerInterface("USERJOINDEPT_DICTIONARY_SYNCHRONIZATION",stream.Read())
	}
	else
	{
		s Soap=##class(InteplatformService.InteplatformServiceSoap).%New()
		s Soap.Timeout=3 //设置超时时间3s
		s re=Soap.DHCServerInterface("USERJOINDEPT_DICTIONARY_SYNCHRONIZATION",stream.Read())
	}
	q re
ERROR
	Q "ERROR"
}

/// 批量同步人员、科室数据到CDSS
/// likefan 2021-04
/// input：表名SS_User/CT_Loc/UserJoinDept，共库标识:与CDSS共库时传"CommonLibrary"
/// output: "ok"
/// w ##class(web.DHCBL.BDP.CDSSInterface).UpdateAllData("SS_User")
/// w ##class(web.DHCBL.BDP.CDSSInterface).UpdateAllData("CT_Loc")
/// w ##class(web.DHCBL.BDP.CDSSInterface).UpdateAllData("UserJoinDept")	//用户与科室关联数据
ClassMethod UpdateAllData(table As %String = "", commonflag As %String = "") As %String
{
	s $zt="ERROR"
	s CDSSAutFlag=##class(web.DHCBL.BDP.BDPConfig).GetConfigValue("CDSSDataAut")
	q:CDSSAutFlag'="Y" "-1^未开启临床决策支持数据同步"
	s flag=0
	s:table="" flag=1	//批量同步三张表数据
	if (table="CT_Loc")||(flag=1)
	{
		s CTLOCRowID=0
		for  
		{
		    s CTLOCRowID=$o(^CTLOC(CTLOCRowID)) q:CTLOCRowID=""
		    d ..CDSSCTLocSync(CTLOCRowID,"","",commonflag)
		} 
	}
	if (table="SS_User")||(flag=1)
	{
		s SSUSRRowId=0
		for  
		{
			s SSUSRRowId=$o(^SSU("SSUSR",SSUSRRowId)) q:SSUSRRowId=""
			d ..CDSSUserSync(SSUSRRowId,"","",commonflag)
		}
	}
	if (table="UserJoinDept")||(flag=1)
	{
		s SSUSRRowId=0
		for  
		{
			s SSUSRRowId=$o(^SSU("SSUSR",SSUSRRowId)) q:SSUSRRowId=""
			s SSUSRDefaultDeptDR=$p($g(^SSU("SSUSR",SSUSRRowId)),"^",4)     //登录科室DR
			if (SSUSRDefaultDeptDR'="")
			{
				d ..CDSSUserLinkLocSync(SSUSRRowId,"",commonflag)
			}
			//同步其他登录科室数据
			s ChildSub=0
			for
			{
				s ChildSub=$o(^SSU("SSUSR",SSUSRRowId,"OTHLL",ChildSub)) q:ChildSub=""
				s OTHLLRowId=SSUSRRowId_"||"_ChildSub
				s OTHLLCTLOCDR=$p($g(^SSU("SSUSR",SSUSRRowId,"OTHLL",ChildSub)),"^",1)		//科室DR
				if (OTHLLCTLOCDR'="")
				{
					d ..CDSSUserLinkLocSync(OTHLLRowId,"",commonflag)
				}
			}
		}
	}
	q "ok"
ERROR
	Q "ERROR"
}

/// 调用CDSS接口同步院区信息
/// 陈莹 2022-05-06
/// input：str:类型（A,U)^rowid^原代码^原名称
/// output: CDSS接口返回信息
/// w ##class(web.DHCBL.BDP.CDSSInterface).CDSSSyncHospArea("A^2")
/// w ##class(web.DHCBL.BDP.CDSSInterface).CDSSSyncHospArea("U^2^DHYY^东华医院")
ClassMethod CDSSSyncHospArea(inputstr As %String) As %String
{
	s $zt="ERROR"
	s CDSSAutFlag=##class(web.DHCBL.BDP.BDPConfig).GetConfigValue("CDSSDataAut")
	q:CDSSAutFlag'="Y" "-1^未开启临床决策支持数据同步"
	s ret=""
	s Soap= ##class(InteplatformService.InteplatformServiceSoap).%New()
	s Soap.Timeout=3 //超时时间，单位秒
	s Type=$p(inputstr,"^",1)  //A-新增，U修改
	s HOSPRowId=$p(inputstr,"^",2)
	if HOSPRowId="" q ""
	s HOSPCode=$p($g(^CT("HOSP",HOSPRowId)),"^",1) // 医院代码
    s HOSPDesc=$p($g(^CT("HOSP",HOSPRowId)),"^",2) // 医院名称
	if (Type="A") //新增
	{
		s ret=Soap.AddHospArea(HOSPCode,HOSPDesc)
	}
	if (Type="U") //修改
	{
		s oldCode=$p(inputstr,"^",3)
		s oldDesc=$p(inputstr,"^",4)
		//原代码 新代码 新代码 新名称
		s ret=Soap.UpdateHospArea(oldCode,oldDesc,HOSPCode,HOSPDesc)
	}
	q ret
ERROR
	Q "ERROR"
}

/// 调用CDSS接口同步医嘱项信息
/// 陈莹 2022-05-06
/// input：str:类型（A,U)^rowid^原代码^原名称
/// output: CDSS接口返回信息
/// w ##class(web.DHCBL.BDP.CDSSInterface).CDSSSyncArcItmmast("A^17272||1")
/// w ##class(web.DHCBL.BDP.CDSSInterface).CDSSSyncArcItmmast("U^17269||1^YCX00002^字典对照同步测试")
ClassMethod CDSSSyncArcItmmast(inputstr As %String) As %String
{
	s $zt="ERROR"
	s CDSSAutFlag=##class(web.DHCBL.BDP.BDPConfig).GetConfigValue("CDSSDataAut")
	
	q:CDSSAutFlag'="Y" "-1^未开启临床决策支持数据同步"
	s ret=""
	s Soap= ##class(InteplatformService.InteplatformServiceSoap).%New()
	s Soap.Timeout=3 //超时时间，单位秒
	s Type=$p(inputstr,"^",1)  //A-新增，U修改
	s ARCIMRowId=$p(inputstr,"^",2)
	s ARCIMSubscript=$p(ARCIMRowId,"||",1)
	s ARCIMVersion=$p(ARCIMRowId,"||",2)
	if ARCIMSubscript="" q ""
	if ARCIMVersion="" q ""
	s ARCIMCode =$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",1)          ; 医嘱代码
	s ARCIMDesc=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",2)           ; 医嘱名称
	s ItemType=""
	s ARCICRowId=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",10)  //医嘱子类Dr	
	if ARCICRowId'=""
	{
		s ARCICDesc=$p($g(^ARC("IC",ARCICRowId)),"^",2)  //医嘱子类描述
		s ARCICOrderType=$p($g(^ARC("IC",ARCICRowId)),"^",7)
		s ARCICOrdCatDR=$p($g(^ARC("IC",ARCICRowId)),"^",8)  //医嘱大类Dr
		s:ARCICOrdCatDR'="" ARCICOrdCatDR=$p($g(^OEC("ORCAT",ARCICOrdCatDR)),"^",2) //获取医嘱大类描述
		
		//判断哪些分类的医嘱才调用接口
		if ((ARCICOrdCatDR="检查")||(ARCICOrdCatDR="一般检查"))
		{
			s ItemType="检查项目字典"
		}
		elseif ((ARCICOrdCatDR="护理")||(ARCICOrdCatDR="处置治疗"))
		{
			s ItemType="护理医嘱字典"
		}
		elseif ((ARCICOrdCatDR="西药")||((ARCICOrdCatDR["药")&&(ARCICOrderType="R")))
		{
			if (ARCICOrdCatDR="中草药")
			{
			s ItemType="中药字典"
			}
			else{
			s ItemType="药品字典"
			}
		}
		
		elseif ((ARCICOrdCatDR="检验")||(ARCICDesc["检验")||(ARCICOrderType="L")||(ARCICOrdCatDR="病理"))
		{
			s ItemType="检验医嘱"
		}
		elseif ((ARCICDesc["输血")||(ARCICOrdCatDR="治疗")) //治疗
		{
			s ItemType="输血品字典"
		}
		else
		{
			q ""
		}
	}
	else
	{
		q ""
	}
	if (Type="A") //新增
	{
		s Type=""
		s ret=Soap.AddIntData(ARCIMCode,ARCIMDesc,ItemType)
		
	}
	if (Type="U") //修改
	{
		s oldCode=$p(inputstr,"^",3)
		s oldDesc=$p(inputstr,"^",4)
		//b ;41
		s ret=Soap.UpdateIntData(oldCode,oldDesc,ARCIMCode,ARCIMDesc)
		//b ;42
	}
	q ret
ERROR
	Q "ERROR"
}

/// 调用CDSS接口同步医嘱项关联院区信息
/// 陈莹 2022-05-06
/// input：str:类型（A,U,D)^rowid^原医院id
/// output: CDSS接口返回信息
/// w ##class(web.DHCBL.BDP.CDSSInterface).CDSSSyncItemHosp("A^2||1||1")
/// w ##class(web.DHCBL.BDP.CDSSInterface).CDSSSyncItemHosp("U^2||1||1^2")
/// w ##class(web.DHCBL.BDP.CDSSInterface).CDSSSyncItemHosp("D^2||1||1")
ClassMethod CDSSSyncItemHosp(inputstr As %String) As %String
{
	s $zt="ERROR"
	s CDSSAutFlag=##class(web.DHCBL.BDP.BDPConfig).GetConfigValue("CDSSDataAut")
	q:CDSSAutFlag'="Y" "-1^未开启临床决策支持数据同步"
	s ret=""
	s Soap= ##class(InteplatformService.InteplatformServiceSoap).%New()
	s Soap.Timeout=3 //超时时间，单位秒
	s Type=$p(inputstr,"^",1)  //A-新增，U修改
	s HOSPRowId=$p(inputstr,"^",2)
	s ARCIMSubscript=$p(HOSPRowId,"||",1)
	s ARCIMVersion=$p(HOSPRowId,"||",2)
	s HOSPchildsub=$p(HOSPRowId,"||",3)
	if ARCIMSubscript="" q ""
	if ARCIMVersion="" q ""
	if HOSPchildsub="" q ""
	s ARCIMCode =$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",1)          ; 医嘱代码
	s ARCIMDesc=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",2)           ; 医嘱名称
	s HOSPHospitalDR=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,"HOSP",HOSPchildsub)),"^",1)
	Q:HOSPHospitalDR="" ""
	s HOSPDesc=##class(web.DHCBL.BDP.CDSSInterface).GetGroupHospDesc(HOSPHospitalDR,"ARC_ItmMast")
	if (Type="A") //新增
	{
		s Type=""
		s ret=Soap.OperateOrderConArea(ARCIMCode,ARCIMDesc,HOSPDesc,"A")
	}
	if (Type="U") //修改
	{
		s oldHOSPHospitalDR=$p(inputstr,"^",3)
		// 医嘱项代码 医嘱项名称 old医院名称 new医院名称
		s OldHOSPDesc=##class(web.DHCBL.BDP.CDSSInterface).GetGroupHospDesc(oldHOSPHospitalDR,"ARC_ItmMast")
		s ret=Soap.UpdateOrderConArea(ARCIMCode, ARCIMDesc,OldHOSPDesc,HOSPDesc)
	}
	if (Type="D")  //删除
	{
		s ret=Soap.OperateOrderConArea(ARCIMCode,ARCIMDesc,HOSPDesc,"D")
	}
	q ret
ERROR
	Q "ERROR"
}

/// Creator：陈莹
/// CreatDate: 2022-1-21
/// Description：获取同一个组内的医院名称
/// Input：医院id
/// d ##class(web.DHCBL.BDP.CDSSInterface).GetGroupHospDesc(2,"ARC_ItmMast")
/// d ##class(web.DHCBL.BDP.CDSSInterface).GetGroupHospDesc(2,"ARC_ItmMast")
ClassMethod GetGroupHospDesc(HOSPHospitalDR As %String, tablename As %String) As %String
{
	s HospStr=""
	//考虑8.4医院组
	s TableListID=$o(^User.BDPTableListI("NameIndex"," "_$ZCONVERT(tablename,"U"),0))	
	if TableListID=""  //update2020-06-12兼容没有登记的项目
	{
		if (HOSPHospitalDR'="") s HOSPHospitalDR=$p($g(^CT("HOSP",HOSPHospitalDR)),"^",2)
		if HospStr="" s HospStr=HOSPHospitalDR
		else  s HospStr=HospStr_"/"_HOSPHospitalDR
	}
	else
	{
		s DataType=$LISTGET($G(^User.BDPTableListD(TableListID)),10)
		if (DataType="A")||(DataType="") //如果类型是绝对私有、或者没有维护属性，则直接返回入参医院
		{
			if (HOSPHospitalDR'="") s HOSPHospitalDR=$p($g(^CT("HOSP",HOSPHospitalDR)),"^",2)
			if HospStr="" s HospStr=HOSPHospitalDR
			else  s HospStr=HospStr_"/"_HOSPHospitalDR
		}
		else
		{
			s date=+$h
			s defaultdr=$p($g(^CT("HOSP",HOSPHospitalDR)),"^",41)	//取默认医院
			if defaultdr="" s defaultdr=HOSPHospitalDR
			s ExceptionFlag=0
			//先判断是否是例外医院
			k ExceptionHosp
			s childsub=0
			for
			{
				s childsub=$o(^User.BDPTableListD(TableListID,"ChildExceptionHosp",childsub)) q:childsub=""
				s HospitalDR=$lg($g(^User.BDPTableListD(TableListID,"ChildExceptionHosp",childsub)),2)     //例外医院
				s ActiveFlag=$lg($g(^User.BDPTableListD(TableListID,"ChildExceptionHosp",childsub)),3)		//是否启用
				s ActiveFrom=$lg($g(^User.BDPTableListD(TableListID,"ChildExceptionHosp",childsub)),4)		//开始日期
				s ActiveTo=$lg($g(^User.BDPTableListD(TableListID,"ChildExceptionHosp",childsub)),5)		//结束日期
				if (ActiveFlag="Y")&&((ActiveFrom'="")&&(date>=ActiveFrom))&&((ActiveTo="")||(date<=ActiveTo))	//是例外医院，返回其本身
				{
					if HospitalDR=HOSPHospitalDR s ExceptionFlag=1   //入参医院为例外医院
					s ExceptionHosp(HospitalDR)=""
				}
			}
			if (ExceptionFlag=1)   //入参医院为例外医院，返回自己
			{
				if (HOSPHospitalDR'="") s HOSPHospitalDR=$p($g(^CT("HOSP",HOSPHospitalDR)),"^",2)
				if HospStr="" s HospStr=HOSPHospitalDR
				else  s HospStr=HospStr_"/"_HOSPHospitalDR
			}
			else
			{
				if HospStr="" s HospStr=$p($g(^CT("HOSP",HOSPHospitalDR)),"^",2)
				else  s HospStr=HospStr_"/"_$p($g(^CT("HOSP",HOSPHospitalDR)),"^",2)
				s HOSPRowId=0
				for
				{
					s HOSPRowId=$o(^CT("HOSP",HOSPRowId)) q:HOSPRowId=""
					s HOSPDateTo=$p($g(^CT("HOSP",HOSPRowId)),"^",10)
					continue:(HOSPDateTo'="")&&(HOSPDateTo<+$h)
					s HOSPDefaultHospitalDR=$p($g(^CT("HOSP",HOSPRowId)),"^",41)	//取默认医院
					if HOSPDefaultHospitalDR="" s HOSPDefaultHospitalDR=HOSPRowId
					if (HOSPDefaultHospitalDR=defaultdr)
					{
						if ($d(ExceptionHosp(HOSPRowId))=0)&&(HOSPHospitalDR'=HOSPRowId)
						{
							s Desc=""
							if (HOSPRowId'="") s Desc=$p($g(^CT("HOSP",HOSPRowId)),"^",2)
							if HospStr="" s HospStr=Desc
							else  s HospStr=HospStr_"/"_Desc
						}
						
					}
				}
			}
			
		}
	}
	q HospStr
}

/// Creator：陈莹
/// CreatDate: 2022-02-17
/// Description：同步 医嘱项关联医院 到 CDSS对接方字典关联院区表
/// d ##class(web.DHCBL.CT.ARCItemHosp).SyncARCItemHospToCDSS()
ClassMethod SyncARCItemHospToCDSS() As %String
{
	s HISSyncCDSSFlag=##class(web.DHCBL.BDP.BDPConfig).GetConfigValue("CDSSDataAut")
	if (HISSyncCDSSFlag="Y")
	{
		s ARCIMSubscript=0
	    for
	    {
	        s ARCIMSubscript=$o(^ARCIM(ARCIMSubscript)) q:(ARCIMSubscript="")
			s ARCIMVersion=0
			for 
			{
				s ARCIMVersion=$o(^ARCIM(ARCIMSubscript,ARCIMVersion)) q:(ARCIMVersion="")
				s childsub=0
				for 
				{
					s childsub=$o(^ARCIM(ARCIMSubscript,ARCIMVersion,"HOSP",childsub)) q:(childsub="")
					s HOSPHospitalDR=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,"HOSP",childsub)),"^",1)
					continue:(HOSPHospitalDR="")
					s Soap= ##class(InteplatformService.InteplatformServiceSoap).%New()
					s Soap.Timeout=3 //超时时间，单位秒
					s ARCIMCode =$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",1)          ; 医嘱代码
					s ARCIMDesc=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",2)           ; 医嘱名称
					s HOSPDesc=##class(web.DHCBL.BDP.CDSSInterface).GetGroupHospDesc(HOSPHospitalDR,"ARC_ItmMast")
					s ret=Soap.OperateOrderConArea(ARCIMCode,ARCIMDesc,HOSPDesc,"A")

				}
			}
	    }
	}
}

}
