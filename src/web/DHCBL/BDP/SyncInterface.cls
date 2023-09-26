/// 医师资质接口类
/// 提供毒麻等权限接口	调用人员、手术接口
/// webservice：BDP.Interface.SyncInterface.cls
/// likefan 2021-04-02
Class web.DHCBL.BDP.SyncInterface Extends %RegisteredObject
{

/// 基础数据平台-李可凡
/// 2021-04-02
/// 第三方对医师的精神麻毒处方权限等进行授权和禁止状态变更时，把数据同步给基础数据平台
/// w ##class(web.DHCBL.BDP.SyncInterface).SavePermission("1810^DM^Y")
ClassMethod SavePermission(datastr As %String) As %String
{
	s CTPCPRowId=$p(datastr,"^",1)
	s PermissionCode=$p(datastr,"^",2)
	s CodeFlag=$p(datastr,"^",3)
	
	q:CTPCPRowId="" "-1^医护人员RowId不能为空"
	q:PermissionCode="" "-1^授权处方标识JS/DM不能为空"
	q:CodeFlag="" "-1^授权状态Y/N不能为空"
	
	q:'$d(^CTPCP(CTPCPRowId)) "-1^RowId无对应医护人员："_CTPCPRowId
	q:'((PermissionCode="DM")||(PermissionCode="JS")) "-1^授权代码只能是JS/DM"
	q:'((CodeFlag="Y")||(CodeFlag="N")) "-1^授权状态只能是Y或N"
	
	s result=""
	s obj=##class(User.CTCareProv).%OpenId(CTPCPRowId)
	s eobj=##class(web.Entity.CT.CTCareProv).%New()	//新数据
	s eobj.CTPCPCode=obj.CTPCPCode
	s eobj.CTPCPDesc=obj.CTPCPDesc
	s bobj=##class(web.Entity.CT.CTCareProv).%New()	//原数据
	s bobj.CTPCPCode=obj.CTPCPCode
	s bobj.CTPCPDesc=obj.CTPCPDesc
	if (PermissionCode="JS")	//精神类药物处方权
	{
		s eobj.CTPCPMentalFlag=CodeFlag
		s obj.CTPCPMentalFlag=eobj.CTPCPMentalFlag
	}
	if (PermissionCode="DM")	//毒麻处方权
	{
		s eobj.CTPCPHICApproved=CodeFlag
		s obj.CTPCPHICApproved=eobj.CTPCPHICApproved
	}
	s logJson=eobj.JsonS()
	s blogJson=bobj.JsonS()
	
	Ts
	s sc=obj.%Save()
	d obj.%Close()
	If $$$ISOK(sc)
	{
		Tc
		s id = obj.%Id()
		s result = "0^"_id
		d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLogForOther("CT_CareProv","User.CTCareProv","医护人员",id,eobj.CTPCPDesc,"U",logJson,blogJson,"1")
	}
	else
	{
		Tro
		s result = "-1^"_CTPCPRowId_"^"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)		//返回错误信息
	}
	q result
}

/// 基础数据平台-likefan
/// 2021-07-06
/// 医师资质对医师的精神麻毒处方权限等进行授权和禁止状态变更时，把数据同步给基础数据平台
/// 8.4版本 管制药品分类权限
/// w ##class(web.DHCBL.BDP.SyncInterface).SavePermissionPHCPoison("")
ClassMethod SavePermissionPHCPoison(datastr As %String) As %String
{
	s result=""
	
	s CTPCPRowId=$p(datastr,"^",1)
	s PermissionCode=$p(datastr,"^",2)
	s CodeFlag=$p(datastr,"^",3)
	
	q:CTPCPRowId="" "-1^医护人员RowId不能为空"
	q:PermissionCode="" "-1^授权处方代码不能为空"
	q:CodeFlag="" "-1^授权状态Y/N不能为空"
	
	q:'$d(^CTPCP(CTPCPRowId)) "-1^RowId无对应医护人员："_CTPCPRowId
	s PHCPORowId=$o(^PHCPO(0,"Code",$$ALPHAUP^SSUTIL4(PermissionCode),0))
	q:(PHCPORowId="") "-1^授权处方代码错误"
	q:'((CodeFlag="Y")||(CodeFlag="N")) "-1^授权状态只能是Y或N"
	
	if (CodeFlag="Y")
	{
    	s eobj=##class(web.Entity.CT.CTCareProvPHCPoison).%New()
		s eobj.CPPParRef=CTPCPRowId
		s eobj.CPPPHCPoisonDR=PHCPORowId
	    s re=##class(web.DHCBL.CT.CTCareProvPHCPoison).SaveEntity(eobj)
	}
	else
	{
    	s CPPRowId=""
    	s CPPChildsub=0
		for
		{
			s CPPChildsub=$o(^CTPCP(CTPCPRowId,"CPP",CPPChildsub)) q:CPPChildsub=""
			s CPPPHCPoisonDR=$p($g(^CTPCP(CTPCPRowId,"CPP",CPPChildsub)),"^",1)
			if (CPPPHCPoisonDR=PHCPORowId) 
			{
				s CPPRowId=CTPCPRowId_"||"_CPPChildsub
				q
			}
		}
		s:CPPRowId'="" re=##class(web.DHCBL.CT.CTCareProvPHCPoison).DeleteData(CPPRowId)
		s:CPPRowId="" re="success:'true'"
	}
	
	if (re["success:'true'")||(re["该记录已经存在")
	{
		s result="0^"_CTPCPRowId
	}
	else
	{
		s result="-1^"_re
	}
	
	q result
}

/// His新增修改医师信息，调用医师资质接口，同步到医师资质系统
/// 基础数据平台-likefan
/// 2021-04-06
/// w ##class(web.DHCBL.BDP.SyncInterface).saveDoctor("1","A")
ClassMethod saveDoctor(doctorid As %String, AUflag As %String) As %String
{
	q:doctorid="" "-1^input error"
	q:'((AUflag="A")||(AUflag="U")) "-1^input error"
	s inputstr=""
	s (UserCode,UserName,UserLocRowId,UserLocName,UserGroupId,UserGroupName,UserCarPrvTp,UserUnit,UserDateFrom,UserDateTo,ActiveFlag,MentalFlag,HICApproved,ZysFlag)=""
	s UserId=0
	for
	{
		s UserId=$o(^SSU("SSUSR",0,"CTPCP",doctorid,UserId)) q:UserId=""
		q:((UserId'="")&&($d(^SSU("SSUSR",UserId))'=0))
	}
	q:UserId="" "-1^UserId is null"
    s obj = ##class(User.SSUser).%OpenId(UserId)
    s:obj.SSUSRDefaultDeptDR'="" UserLocRowId=obj.SSUSRDefaultDeptDR.%Id()	//登录科室id
    s:UserLocRowId'="" UserLocName=$p($g(^CTLOC(UserLocRowId)),"^",2) //登录科室名称
    s:obj.SSUSRGroup'="" UserGroupId=obj.SSUSRGroup.%Id()	//安全组id
    s:UserGroupId'="" UserGroupName=$p($g(^SSU("SSGRP",UserGroupId)),"^",1) //安全组名称
    s cobj = ##class(User.CTCareProv).%OpenId(doctorid)
    s UserCode = cobj.CTPCPCode		//工号
    s UserName = cobj.CTPCPDesc		//姓名
    s:cobj.CTPCPCarPrvTpDR'="" UserCarPrvTp = cobj.CTPCPCarPrvTpDR.%Id()
    s:UserCarPrvTp'="" UserCarPrvTp=$p($g(^CT("CPT",UserCarPrvTp)),"^",2) //人员类型
    s UserUnit = cobj.CTPCPUnit		//资格证书编号
	s:cobj.CTPCPDateActiveFrom'="" UserDateFrom=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(cobj.CTPCPDateActiveFrom)	//开始日期
	s:cobj.CTPCPDateActiveTo'="" UserDateTo=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(cobj.CTPCPDateActiveTo)		//结束日期
    s ActiveFlag = cobj.CTPCPActiveFlag		//激活标识
    s MentalFlag = cobj.CTPCPMentalFlag		//精神类药物处方权
    s HICApproved = cobj.CTPCPHICApproved	//毒麻处方权
    d obj.%Close()
	d cobj.%Close()
	s inputstr=AUflag_"^"_doctorid_"^"_UserCode_"^"_UserName_"^"_UserLocRowId_"^"_UserLocName_"^"_UserGroupId_"^"_UserGroupName_"^"_UserCarPrvTp_"^"_UserUnit_"^"_UserDateFrom_"^"_UserDateTo_"^"_ActiveFlag_"^"_MentalFlag_"^"_HICApproved
	//q inputstr
	try{
		//s reSync=##class(DoctorSyncImplService.DoctorSyncImplPort).%New().saveDoctor(inputstr)	//调用医师资质接口
		s Soap=##class(DoctorSyncImplService.DoctorSyncImplPort).%New()
		s Soap.Timeout=3 //设置超时时间3s
		s reSync=Soap.saveDoctor(inputstr)
		s ^templkfInterface("doctor","in")=inputstr
		s ^templkfInterface("doctor","out")=reSync
	}catch myvar{
		s reSync="-1^return error"
		}
	q reSync
}

/// His新增修改手术信息，调用医师资质接口，同步到医师资质系统
/// 基础数据平台-likefan
/// 2021-04-06
/// w ##class(web.DHCBL.BDP.SyncInterface).saveOperation("1","A")
ClassMethod saveOperation(operid As %String, AUflag As %String) As %String
{
	q:operid="" "-1^input error"
	q:'((AUflag="A")||(AUflag="U")||(AUflag="D")) "-1^input error"
	s inputstr=""
	s (opericd,operCode,operName,startdate,enddate,operLevel)=""
	if (AUflag="D")
	{
		s inputstr=operid_"^"_AUflag
	}
	else
	{
		s obj = ##class(User.ORCOperation).%OpenId(operid)
		q:'$IsObject(obj) "-1^data error"
		s opericd=obj.OPERICD10		//ICD编码
		s operCode=obj.OPERCode		//手术代码
		s operName=obj.OPERDesc		//手术名称
		s:obj.OPERDateActiveFrom'="" startdate=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(obj.OPERDateActiveFrom)		//开始日期
		s:obj.OPERActiveDateTo'="" enddate=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(obj.OPERActiveDateTo)			//结束日期
		s:obj.OPERDefaultCategoryDR'="" operLevel=obj.OPERDefaultCategoryDR.%Id()		//手术分级dr
		s:obj.OPERDefaultCategoryDR="" operLevel=""
		s:operLevel'="" operLevel=$p($g(^ORC("CATEG",operLevel)),"^",1)		//手术分级
		d obj.%Close()
		k obj
		s inputstr=operid_"^"_opericd_"^"_operCode_"^"_operName_"^"_startdate_"^"_enddate_"^"_operLevel_"^"_AUflag
	}
	//q inputstr
	try{
		//s reSync=##class(OperationSyncImplService.OperationSyncImplPort).%New().saveOperation(inputstr)
		s Soap=##class(OperationSyncImplService.OperationSyncImplPort).%New()
		s Soap.Timeout=3 //设置超时时间3s
		s reSync=Soap.saveOperation(inputstr)
		s ^templkfInterface("oper","in")=inputstr
		s ^templkfInterface("oper","out")=reSync
	}catch myvar{
		s reSync="-1^return error"
		}
	q reSync
}

/// 基础数据平台-李可凡
/// 2021-05-28
/// 医师资质对医师信息变更时，把数据同步给HIS（仅修改）
/// input：U^rowid(医护人员rowid)^UserCode^UserName^cardnum(身份证号)^email^phone^ActiveFlag(Y/N)
/// w ##class(web.DHCBL.BDP.SyncInterface).SaveHISDoctor("")
ClassMethod SaveHISDoctor(datastr As %String) As %String
{
	s AUFlag=$p(datastr,"^",1)			//修改标识
	q:AUFlag'="U" "-1^仅提供修改服务"
	s CTPCPRowId1=$p(datastr,"^",2)		//医护人员rowid
	q:CTPCPRowId1="" "-1^rowid不能为空"
	q:'$d(^CTPCP(CTPCPRowId1)) "rowid不存在："_CTPCPRowId1
	s CTPCPCode=$p(datastr,"^",3)		//工号
	q:CTPCPCode="" "-1^工号不能为空"
	s CTPCPDesc=$p(datastr,"^",4)		//姓名
	q:CTPCPDesc="" "-1^姓名不能为空"
	s CTPCPTextOne=$p(datastr,"^",5)	//身份证号
	s CTPCPEmail=$p(datastr,"^",6)		//邮箱
	s CTPCPMobilePhone=$p(datastr,"^",7)	//电话
	s CTPCPActiveFlag=$p(datastr,"^",8)		//激活标识
	q:(CTPCPActiveFlag'="Y")&&(CTPCPActiveFlag'="N") "-1^激活标识只能是Y/N"
	s result=""
	//记录新数据
	s eobj=##class(web.Entity.CT.CTCareProv).%New()
	s eobj.CTPCPRowId1=CTPCPRowId1
	s eobj.CTPCPCode=CTPCPCode
	s eobj.CTPCPDesc=CTPCPDesc
	s eobj.CTPCPTextOne=CTPCPTextOne
	s eobj.CTPCPEmail=CTPCPEmail
	s eobj.CTPCPMobilePhone=CTPCPMobilePhone
	s eobj.CTPCPActiveFlag=CTPCPActiveFlag
	s logJson=eobj.JsonS()	//新数据
	s obj=##class(User.CTCareProv).%OpenId(eobj.CTPCPRowId1)
	//记录原数据
	s bobj=##class(web.Entity.CT.CTCareProv).%New()
	s bobj.CTPCPRowId1=eobj.CTPCPRowId1
	s bobj.CTPCPCode=obj.CTPCPCode
	s bobj.CTPCPDesc=obj.CTPCPDesc
	s bobj.CTPCPTextOne=obj.CTPCPTextOne
	s bobj.CTPCPEmail=obj.CTPCPEmail
	s bobj.CTPCPMobilePhone=obj.CTPCPMobilePhone
	s bobj.CTPCPActiveFlag=obj.CTPCPActiveFlag
	s blogJson=bobj.JsonS()	//原数据
	//保存
	s obj.CTPCPCode=eobj.CTPCPCode
	s obj.CTPCPDesc=eobj.CTPCPDesc
	s obj.CTPCPTextOne=eobj.CTPCPTextOne
	s obj.CTPCPEmail=eobj.CTPCPEmail
	s obj.CTPCPMobilePhone=eobj.CTPCPMobilePhone
	s obj.CTPCPActiveFlag=eobj.CTPCPActiveFlag
	
	Ts
	s sc=obj.%Save()
	d obj.%Close()
	If $$$ISOK(sc)
	{
		Tc
		s id=obj.%Id()
		s result="0^"_id
		d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLogForOther("CT_CareProv","User.CTCareProv","医护人员",id,eobj.CTPCPDesc,"U",logJson,blogJson,"1")
		//同步修改用户的激活标识
		s SSUSRRowId=$o(^SSU("SSUSR",0,"CTPCP",id,0))
		if (SSUSRRowId'="")
		{
			s userobj=##class(User.SSUser).%OpenId(SSUSRRowId)
			s userobj.SSUSRActive=eobj.CTPCPActiveFlag
			s usc=userobj.%Save()
			d userobj.%Close()
		}
	}
	else
	{
		Tro
		s result="-1^"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
	}
	q result
}

}
