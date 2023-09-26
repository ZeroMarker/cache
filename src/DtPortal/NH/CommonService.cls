/// 名称:DtPortal.NH.CommonService
/// 描述:护士长公共服务
/// 编写者：bmz
/// 编写日期: 2014-12-04
Class DtPortal.NH.CommonService Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Creator： bmz
/// CreatDate： 2014-2-4
/// Description: 护理质控描述信息
/// Input：	CheckId、CheckTyp
/// Return：
/// Debug：w ##class(DtPortal.NH.CommonService).getQuesDescPortal(397,"QUAL6")
ClassMethod getQuesDescPortal(CheckId As %String, CheckTyp As %String) As %String
{
	
	n (CheckId,CheckTyp)

	i (CheckTyp="NIGHTCHK")!(CheckTyp="DAYCHK")  d
	.s a=##class(Nur.CheckRoom).%OpenId(CheckId)
	.s CheckQuestion=a.CheckQuestion    //存在问题
	.s CheckMem=a.ReMark
	.s status=a.Status
	e  d
	.s b=##class(Nur.QualCheckRec).%OpenId(CheckId)
	.s CheckQuestion=b.CheckQuestion
	.s checkqual=b.CheckQual   //父表id
	.q:checkqual=""    //-------
	.s CheckMem=""
	.i checkqual'="" d
	..s chk=##class(DHCMGNUR.MgCheckWard).%OpenId(checkqual)
	..i chk'="" s CheckMem=chk.CheckMem   //备注
	.s status=b.Status
	i CheckQuestion'="" s CheckQuestion="问题:"_CheckQuestion_";"
	i CheckMem'="" s CheckMem="备注:"_CheckMem
	s ret=CheckQuestion_CheckMem_"^"_status
	s ret=$tr(ret,$C(13,10),"_n")
	q ret
}

/// Creator： pwc
/// CreatDate： 2016-11-11
/// Description: 读取表数据导入portal表
/// Input：	CheckId
/// Return：
/// Debug：w ##class(DtPortal.NH.CommonService).ImportPortal("61793")
ClassMethod ImportPortal(Id As %String) As %String
{
	n (Id)
	s value=""
	s string=""
	s common=""
	s sqlStr="SELECT NewValue,ClassName,OperateType FROM BDP_DataChangeLog WHERE ID='"_Id_"'"
	;s sqlStr=sqlStr_" group by NewValue"   
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	While(result.Next()){
    	s value = result.Data("NewValue")
    	s ClassName = result.Data("ClassName")
    	
    	//获取到操作的状态
    	s OperatorType = result.Data("OperateType")
    	if OperatorType = "U"{
	    	//更新
	    	s Status = "3"	
	    }elseif OperatorType = "A"{
		    //新增
		    s Status = "1"
		}else{
			//删除,目前基础平台没有在删除操作中调用该方法
			s Status = "2"
		}
    	
    	
    	Set Len = $l(value,",")	;返回值行数
   	 	For i=1:1:Len {
	   		Set Data = $p(value,",",i)
	   		Set DataValue = $p(Data,"""",2)
			if i=1{
				Set string=DataValue
			}else{
				Set string =string_"^"_DataValue
			}
		}
	}
	
	s common=""		//判断是科室还是用户表
	i ClassName="User.SSUser"{
		s common="U"
		s userCode=$p(string,"^",2)		//SSUSRInitials		ID
		s name=$p(string,"^",8)			//SSUSRName		Name
		s password=""		//$p(string,"^",6)		//SSUSRPassword		登录密码
		s defaultDeptDr=$p(string,"^",3)		//SSUSRDefaultDeptDR
		
		i defaultDeptDr=""{
			s defaultDeptCode=""
		}else{
			s defaultDeptCode=$p(^CTLOC(defaultDeptDr),"^",1)	//SSUSRDefaultDeptDR.CTLOCCode
		}
		
		
		
		s State="1" 		//
		s Email=""		//
		s InvalidDate=$p(string,"^",5)		//SSUSRDateFrom	生效日期
		s EegDate=$p(string,"^",12)			//SSUSRDateTo	截止日期
		s Type=""			
		s Mnemonics=##class(ext.util.String).ToChineseSpell(name)
		
		s SSUSRCareProvDR=$p(string,"^",11)							//SSUSRCareProvDR	关联医护人员1815
		i SSUSRCareProvDR=""{
			s HealthType=""
		}else{
			b ;SSUSRCareProvDR
			s CTPCPCarPrvTpDR=$p(^CTPCP($g(SSUSRCareProvDR),1),"^",4)
			i CTPCPCarPrvTpDR=""{
				s HealthType=""
			}else{
				s HealthType=$p(^CT("CPT",$g(CTPCPCarPrvTpDR)),"^",1)		//SSUSRCareProvDR.CTPCPCarPrvTpDR.CTCPTCode
			}
		}
		
		s IsExpert=""		//是否专家
		
		s SSUSRGroup=$p(string,"^",9)
		i SSUSRGroup="" {
			set GroupDesc=""
		}else{
			set GroupDesc=$p($g(^SSU("SSGRP",SSUSRGroup)),"^",1)
		}
		w GroupDesc,!
		//转换角色
		
		if GroupDesc["Demo Group"
		{
			//b ;Demo Group
			set stats=..isInType(10161,Type)
			set:stats'=-1 Type=stats	
		}
		if (GroupDesc["医师") && (GroupDesc'["主任")

		{ 	
			set stats=..isInType(13149,Type)
			set:stats'=-1 Type=stats
		}
		if (GroupDesc["住院护士") && (GroupDesc'["住院护士长")

		{
			set stats=..isInType(13503,Type)
			set:stats'=-1 Type=stats
		}
		if GroupDesc["护士长"
		{
			set stats=..isInType(13504,Type)
			set:stats'=-1 Type=stats
		}
		if GroupDesc["医务"
		{
			set stats=..isInType(13502,Type)
			set:stats'=-1 Type=stats
		
		}
		if GroupDesc["护理部"
		{
			set stats=..isInType(13147,Type)
			set:stats'=-1 Type=stats
			
		}
		if GroupDesc["住院医师（主任）"
		{	
			set stats=..isInType(13501,Type)
			set:stats'=-1 Type=stats
			
		}
		if GroupDesc["门诊办公室"
		{
			set stats=..isInType(19701,Type)
			set:stats'=-1 Type=stats
		}
		if (GroupDesc'["住院护士"&&GroupDesc'["Demo Group")&&(GroupDesc'["住院医师")&&(GroupDesc'["护士长")&&(GroupDesc'["医务")&&(GroupDesc'["护理部")&&(GroupDesc'["住院医师(主任)")&&(GroupDesc'["门诊办公室")
		{
			set stats=..isInType(0,Type)
			//b ;undefind
			set:stats'=-1 Type=stats
		}
	
		s Secgroup=""        //^SSU("SSGRP",$g(SSUSRGroup))		//SSUSRGroup.SSGRPDesc
		
		s Certificate=""
		s ISDrugRight=""		//是否有毒麻处方权
		s Number=""			
		s Ename=$p(string,"^",2)				//SSUSRInitials
		s Fname=""	
		s Company=""
  		s Position=""
		s Dleader=""
		s Cellphone=""
		s Landline=""
		s PasswordDate=""
		s string=userCode_"^"_name_"^"_password_"^"_defaultDeptCode_"^"_Status_"^"_Email_"^"_InvalidDate_"^"_EegDate_"^"_Type_"^"_Mnemonics_"^"_HealthType_"^"_IsExpert_"^"_Secgroup_"^"_Certificate_"^"_ISDrugRight_"^"_Number_"^"_Ename_"^"_Fname_"^"_Company_"^"_Position_"^"_Dleader_"^"_Cellphone_"^"_Landline_"^"_PasswordDate
	}
	
    i ClassName="User.CTLoc"{
		s common="D"
		s locCode=$p(string,"^",6)	//科室code
		s locDesc=$p(string,"^",12)	//科室描述
		s locLevel=""				//科室层级
		s Super=""					//
		s State="1"					//状态，1、新增；3、修改；2、删除
		s isLast=""					//
		s Type=$p(string,"^",20)	//科室状态
		
		s CTLOCDepDR=$p(string,"^",10)
		i CTLOCDepDR=""{
			s DGroup=""	
		}else{
			s DGroup=$p(^RBC("DEP",CTLOCDepDR),"^",1)
		}  
		
		s Classify=""		//
		s Address=$p(string,"^",1)		//科室地址
		s Phone=$p(string,"^",19)		//科室电话
		s Mnemonics=$p(string,"^",7)	//科室检索
		
		s CTLOCDateActiveFrom=$p(string,"^",8)
		i CTLOCDateActiveFrom=""{
			s startDate=""
		}else{
			s startDate=$zd(CTLOCDateActiveFrom,3)	//开始时间
		}  
		
		s CTLOCDateActiveTo=$p(string,"^",9)
		i CTLOCDateActiveTo=""{
			s endDate=""
		}else{
			s endDate=$zd(CTLOCDateActiveTo,3)		//结束时间
		}  
		
		s Storey=""	
		s Catalogue=""
		s Dept=""
		
		s string=locCode_"^"_locDesc_"^"_locLevel_"^"_Super_"^"_Status_"^"_isLast_"^"_Type_"^"_DGroup_"^"_Classify_"^"_Address_"^"_Phone_"^"_Mnemonics_"^"_startDate_"^"_endDate_"^"_Storey_"^"_Catalogue_"^"_Dept	
	} 
    
	kill ^SOAPDanPJ(1)
	s ^SOAPDanPJ(1)=common_"^"_string
	;Set Soap = ##class(UserSyncServiceImpl.UserSyncServiceImplHttpSoap11Endpoint).%New()
	;Set SoapRtn = Soap.saveData(common,string)
	w common,string,!
	Set SoapRtn = ##class(DtPortal.Common.PortalSoap).InvokePortalUserSyncService(common,string)
	;b ;UserSyncServiceImpl.UserSyncServiceImplHttpSoap11Endpoint
	q SoapRtn
}

/// 处理角色，如果角色串里已经有了，则不保存，如果没有则存入
/// 根据青医移植新增 DanPJ  2016-07-13
ClassMethod isInType(type, types)
{
	set return=-1
	quit:type="" return
	
	set return=1
	
	set leng=$p(types,"*")
	for index=1:1:leng
	{
		set indexType=$p(types,"*",index)
		continue:type'=indexType
		set return=-1
	}

	quit:return=-1 return
	
	if type=0
	{
		if types=""
		{
			set types=type
		}
	}else
	{
		if (types="")||(types=0)
		{
			set types=type
		}else
		{
			set types=types_"*"_type
		}
	}
	
	quit types
}

/// Creator： zhaoli
/// CreatDate： 2017-04-14
/// Description: 查询护士长所在病区
/// Input： UserCode ：用户工号
///               
///               NH00.00.01
/// Return： 报告病人信息
/// d ##class(%ResultSet).RunQuery("DtPortal.NH.CommonService","findWardByNH","21222")
Query findWardByNH(userCode As %String) As DtPortal.Query(ROWSPEC = "wardDesc:%String,wardId:%String")
{
}

ClassMethod findWardByNHExecute(ByRef qHandle As %Binary, userCode As %String) As %Status
{

    
 New (qHandle,userCode)
 Set repid=$I(^||CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind=1
	Quit:userCode="" $$$OK

	k ^||findWardByNH

	s userCode=$$ALPHAUP^SSUTIL4(userCode)
	s userId=$o(^SSU("SSUSR",0,"SSUSR_Initials",userCode,0))
	q:userId="" $$$OK

	s defaultWardId="",defaultWardDesc=""
	s defaultDept=$p($g(^SSU("SSUSR",userId)),"^",4) //增加默认登陆位置
	Quit:defaultDept="" $$$OK
	Set defaultWardId=$o(^PAWARD(0,"WARD_LocationDR",defaultDept,""))
	s wardId=defaultWardId
	i wardId'="" d
	.s wardDesc=$p(^PAWARD(wardId),"^",2)
	.i wardDesc'="" d
	..i wardDesc["-" s defaultWardDesc=$p(wardDesc,"-",2)
	.s:wardId'="" defaultWardId=wardId

	if defaultWardId'=""
	{
	s Data=$lb(defaultWardDesc,defaultWardId)
	  s ^||CacheTemp(repid,ind)=Data
	  s ind=ind+1
	}
	//取其他登录病区
	s sub=0 //从0后面开始取
	f  s sub=$o(^SSU("SSUSR",userId,"OTHLL",sub)) q:sub=""  d
	.s CTLocDr=$p($g(^SSU("SSUSR",userId,"OTHLL",sub)),"^",1)
	.q:+CTLocDr=0
	.s WardLocType=$P(^CTLOC(CTLocDr),"^",13)
	.q:WardLocType'="W"
	.s wardId=$o(^PAWARD(0,"WARD_LocationDR",CTLocDr,""))
	.q:wardId=""
	.q:defaultWardId=wardId
	.s wardDesc=$p(^PAWARD(wardId),"^",2)
	.i wardDesc'="" d
	..i wardDesc["-" s wardDesc=$p(wardDesc,"-",2)
	.s:wardId'="" ^||findWardByNH(wardId)=wardDesc



	s wardId=""
	for
	{
	s wardId=$o(^||findWardByNH(wardId))
	q:wardId=""
	s wardDesc=^||findWardByNH(wardId)
	s Data=$lb(wardDesc,wardId)
	  s ^||CacheTemp(repid,ind)=Data
	  s ind=ind+1
	}

	k ^||findWardByNH
	   q $$$OK
}

/// 根据在护士站维护的ARCMI获取ARCMIRowIds
/// DanPJ 2017-04-21
/// 入参：HIS中维护的ARCIMCode
/// 出参：ARCIM表中的RowIds串用"^"链接
/// w ##class(DtPortal.NH.CommonService).getARCIMRowIdsByItem("CXY")
ClassMethod getARCIMRowIdsByItem(Item)
{
	set ARCIMRowIds=""
	w Item,!
	if Item="" quit ARCIMRowIds
	set ROWId=$O(^Nur.ImageSetI("Code"," "_Item,""))
  	;set ARCIMCodeStr=$listget(^Nur.ImageSetD(ROWId),4)
  	s ARCIMCodeStr=##Class(DtPortal.Configure.arcim).getArcImID(Item,2)	//获取code
  	set ARCIMCodeLength=$length(ARCIMCodeStr,"^") 		//维护的ARCIMCode长度
  	for index=1:1:ARCIMCodeLength{
	 	set ARCIMCode=$p(ARCIMCodeStr,"^",index)
	 	set ARCIMRowId=""
		quit:ARCIMCode=""
		set rowidm=$o(^ARCIM(0,"Code",$$ALPHAUP^SSUTIL4(ARCIMCode),""))
 		quit:rowidm=""
 		set ARCIMRowId=rowidm_"||"_"1"
 		if ARCIMRowIds=""{
	 		set ARCIMRowIds=rowidm_"||"_"1"
	 	}else{
			set ARCIMRowIds=ARCIMRowIds_"^"_rowidm_"||"_"1"	
		}
	 } 
	quit ARCIMRowIds
}

/// 获取病区排班人数
/// w ##class(DtPortal.NH.CommonService).GetNurAtPost("1",+$h)
ClassMethod GetNurAtPost(wardId, Date = "") As %String
{
	quit:wardId="" 0
	if Date="" s Date=$zd(+$h,3)
	s AtPostNum=0
	///2 ext版护理版本  3 新版护理管理
	s $zt="GetNurAtPostErr"
	set NURMIS=+##Class(DtPortal.Common.PublicService).getValueByCode("NURMIS")
	if (NURMIS=2){
		set wardLocId=$p(^PAWARD(wardId),"^",5)
		q:wardLocId="" 0
		set:Date="" Date=+$h
		set:Date["-" Date=$zdh(Date)
		 
		set AJRowId="" f  s AJRowId = $O(^DHCMGNUR.MgNurArrangeJobI("AJWardDateIdx"," "_wardLocId," "_Date,AJRowId)) q:AJRowId=""  do
		.set AJObject = ##class(DHCMGNUR.MgNurArrangeJob).%OpenId(AJRowId)
		.q:'$IsObject(AJObject)
		.set AJNurse = AJObject.AJNurseDR
		.s AJTypes = AJObject.AJType
		.d AJObject.%Close()
		.set PersonRowId = $O(^DHCMGNUR.MgPersonsI("SSID"," "_AJNurse,"")) 
		.i PersonRowId'="" d
		..s a=^DHCMGNUR.MgPersonsD(PersonRowId)
		..s NurseName=$list(a,30)
		..s isPost=0
		..set AJTypes = AJObject.AJType
		..set AJJobInterval=AJObject.AJJobInterval
		..for i=1:1:$L(AJTypes,",") do
		...set AJType = $P(AJTypes,",",i)
		...q:AJType'="Post"
		...set isPost=1
		..q:isPost'=1
		..set AtPostNum=AtPostNum+1
	}elseif(NURMIS=3){
		
		Set rset = ##class(%ResultSet).%New("web.NurMgOutInterface:FindWardDateArgList")
		Do rset.Execute(wardId,$zd(Date,3))
	
		While (rset.Next()) {
			set ArgPost=rset.Data("ArgPost")		
			continue:ArgPost=""
			set AtPostNum=AtPostNum+1
			//set NurName=rset.Data("NurName")			//护士姓名
			//set ArgPost=rset.Data("ArgPost")			//班次类型  多个班次用 "「"分割
		}
	}
	q AtPostNum
GetNurAtPostErr
	q -1
}

}
