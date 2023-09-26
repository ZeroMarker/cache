Class web.DHCEQ.Plat.CTDepartment Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：      JYP
/// CreatDate：    2018-10-09
/// Description:   数据保存
/// Input：        data:前台获取字符串 field:value,filed:vale  Type:操作类型：（1：删除）,（2：新增）,（其他:保存）
/// Return：       ID或SQLCODE
/// modified by sjh SJH0038 2020-11-10 添加数据修改日志记录 
/// w ##Class(web.DHCEQ.Plat.CTDepartment).SaveData("{""DeptActiveFlag"":""Y"",""DeptCode"":""ZYYJ002"",""DeptDesc"":""CT室"",""DeptExDesc"":""CT室"",""DeptExID"":""1"",""DeptExType"":""1"",""DeptOrganizeID"":""2"",""DeptOrganizeType"":""1"",""DeptRowID"":""1""}",2)
ClassMethod SaveData(Data, Type As %String = "")
{
	k PLIST,RowID
	s JsonData = ##Class(web.DHCEQ.Plat.LIBCommon).StringToJson(Data)
    s Result=##Class(web.DHCEQ.Plat.LIBCommon).JsonToPlist("User.DHCEQCDepartment",JsonData,.PLIST)
	s RowID = JsonData.DeptRowID

	s $zt="ErrorSave"
	s TableName="DHC_EQCDepartment"
	s ClassName="User.DHCEQCDepartment"
	s CurUser=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))	
	s BussID=RowID	
	s DCRRowID=""
	s OldObj=##class(web.DHCEQ.Plat.JsonObject).%New()   //CZF0131 2021-01-20
	s NewObj=##class(web.DHCEQ.Plat.JsonObject).%New()   //CZF0131 2021-01-20
	TSTART
	
	if (Type="1")
	{
		s OldObject=##Class(User.DHCEQCDepartment).%OpenId(BussID)
		s OldObj=##Class(web.DHCEQ.Plat.LIBCommon).GetJsonTableRecord(OldObject)

		&SQL(update sqluser.DHC_EQCDepartment set Dept_InvalidFlag='Y' where Dept_RowID=:RowID)

		If SQLCODE
		{
			TROLLBACK
			Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-9012","部门删除失败!"_$g(%msg))
		}
	 	s Rtn=##class(web.DHCEQ.Plat.LIBCommon).SaveDataChangeLog(TableName,ClassName,BussID,"D","{""DeptInvalidFlag"":""Y""}",OldObj.%ToJSON(),CurUser,"")
	 	i Rtn
	 	{
		 	TRollback
		 	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-9201", "数据日志保存失败!")
		}
		TCommit
	 	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE, RowID)
	}
	ELSE
	{	
		s Code=PLIST(2)   //add hly 20190802
		s Name=PLIST(3)   //add hly 20190802
		Set PLIST(20) = "N"    ;U_Hold1
    	//if Type="2" s RowID=""	//modified by csj 2020-03-16 直接根据是否存在RowID判断新增或保存
    	Set PLIST(15) =##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	 	Set PLIST(16) =+$H				;U_CreateDate
	 	Set PLIST(17) =$Piece($H,",",2)	;U_CreateTime
    	if RowID'=""
    	{
	    	// MZY0021	1304171		2020-05-06 修正重复数据判断处理
	    	&SQL(select Dept_RowID into :tmpid from SQLUSER.DHC_EQCDepartment where :PLIST(8)=1 and Dept_OrganizeType=:PLIST(8) and Dept_OrganizeID=:PLIST(9) and Dept_ExType=:PLIST(11) and Dept_ExID=:PLIST(12) and Dept_RowID<>:RowID and Dept_InvalidFlag<>'Y')
			if tmpid'="" Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-9210", "该类型(医院)的关联科室已经存在!")
			&SQL(select Dept_RowID into :tmpid from SQLUSER.DHC_EQCDepartment where :PLIST(8)=2 and Dept_OrganizeType=:PLIST(8) and Dept_OrganizeID=:PLIST(9) and Dept_RowID<>:RowID and Dept_InvalidFlag<>'Y')
			if tmpid'="" Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-9210", "该类型的供应商已经存在!")
			
			Set BussID=RowID,OperateType="U"
			s OldObject=##Class(User.DHCEQCDepartment).%OpenId(BussID)
			s OldObj=##Class(web.DHCEQ.Plat.LIBCommon).GetJsonTableRecord(OldObject)
			&SQL(Update SQLUSER.DHC_EQCDepartment Values :PLIST() where Dept_RowID = :RowID)
		}
		else
		{
			// MZY0021	1304171		2020-05-06	修正重复数据判断处理
			&SQL(select Dept_RowID into :tmpid from SQLUSER.DHC_EQCDepartment where Dept_Code=:PLIST(2) and Dept_Desc=:PLIST(3) and Dept_InvalidFlag<>'Y')
			if tmpid'="" Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-9210", "该科室已经存在!  "_PLIST(3))
			&SQL(select Dept_RowID into :tmpid from SQLUSER.DHC_EQCDepartment where :PLIST(8)=1 and Dept_OrganizeType=:PLIST(8) and Dept_OrganizeID=:PLIST(9) and Dept_ExType=:PLIST(11) and Dept_ExID=:PLIST(12) and Dept_InvalidFlag<>'Y')
			if tmpid'="" Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-9210", "该类型(医院)的关联科室已经存在!")
			&SQL(select Dept_RowID into :tmpid from SQLUSER.DHC_EQCDepartment where :PLIST(8)=2 and Dept_OrganizeType=:PLIST(8) and Dept_OrganizeID=:PLIST(9) and Dept_InvalidFlag<>'Y')
			if tmpid'="" Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-9210", "该类型的供应商已经存在!")
	 		Set OperateType="A"
	 		&SQL(insert into sqluser.DHC_EQCDepartment values :PLIST())
	 		s RowID=$g(%ROWID)
		}
		
		if SQLCODE
		{
			TROLLBACK
			Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-9012","部门保存失败!错误信息:"_$g(%msg))
		}
		
		s BussID=RowID		//czf 20210126
		////Add by ZY2010 调用别名表的存储
		i RowID'=""
		{
			s AliasJsonData=##Class(web.DHCEQ.Plat.CTAlias).SaveData(Data,"DHCEQCDepartment",RowID,"PYCode",0)
			s AliasJsonData = ##Class(web.DHCEQ.Plat.LIBCommon).StringToJson(AliasJsonData)
			s SQLCODE=AliasJsonData.SQLCODE
			s AliasData=AliasJsonData.Data
		}
		i RowID'=""	//更新数据获取更新字段Json串
		{
			s key=""	//CZF0131 2020-01-20
			For
			{
				s value=JsonData.GetNext(.key)
				q:key=""
				i (value'=OldObj.%Get(key)) d NewObj.%Set(key,value)
			}
		}
		else			//插入数据
		{
			s NewObj=JsonData
		}
	
		i NewObj.%ToJSON()'="{}"	//本次未更新则不记录
		{
			s Rtn=##class(web.DHCEQ.Plat.LIBCommon).SaveDataChangeLog(TableName,ClassName,BussID,OperateType,NewObj.%ToJSON(),OldObj.%ToJSON(),CurUser,"")
			If Rtn
	 		{
		 		TRollback
		 		Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-9201","数据日志保存错误!")
			}
		}
	}
	TCOMMIT
	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,RowID)
	
ErrorSave
	Set ErrorMsg=$ZE	     //得到系统返回的错误消息
 	TROLLBACK		         //回滚事务
 	Quit "ERRORSave"_ErrorMsg     //返回错误消息 ;
}

/// /Add by ZY2010 调用别名表的存储
/// 查询课程培训登记记录
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.Plat.CTDepartment","GetDepartmentData","","","","","","","","","","","","")
Query GetDepartmentData(Code As %String = "", Desc As %String = "", LeaderUserDR As %String = "", ContactsUserDR As %String = "", Telephone As %String = "", Address As %String = "", OrganizeType As %String = "", OrganizeID As %String = "", ExType As %String = "", ExID As %String = "", ExDesc As %String = "", ActiveFlag As %String = "", gHospId As %Library.String = "", BDPHospId As %Library.String = "") As %Query(ROWSPEC = "TRow:%String,TRowID:%String,TCode:%String,TDesc:%String,TLeaderUserDR:%String,TLeaderUserName:%String,TContactsUserDR:%String,TContactsUserName:%String,TTelephone:%String,TAddress:%String,TOrganizeType:%String,TOrganizeTypeDesc:%String,TOrganizeID:%String,TOrganize:%String,TExType:%String,TExTypeDesc:%String,TExID:%String,TExName:%String,TExDesc:%String,TActiveFlag:%String,TActiveFlagDesc:%String,TDateFrom:%String,TDateTo:%String,THold1:%String,THold2:%String,THold3:%String,THold4:%String,THold5:%String,ARowID:%String,AText:%String")
{
}

ClassMethod GetDepartmentDataExecute(ByRef qHandle As %Binary, Code As %String = "", Desc As %String = "", LeaderUserDR As %String = "", ContactsUserDR As %String = "", Telephone As %String = "", Address As %String = "", OrganizeType As %String = "", OrganizeID As %String = "", ExType As %String = "", ExID As %String = "", ExDesc As %String = "", ActiveFlag As %String = "", gHospId As %Library.String = "", BDPHospId As %Library.String = "") As %Status
{
	new repid, index, rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s TRow=0
	;获取院区Id(多院区) CZF0138
	s sHospID=##class(web.DHCEQ.Util.BDPCommonUtil).GetBDPHospId(BDPHospId,gHospId)
	
	s rowid=0
	f  s rowid=$o(^DHCEQCCode("DHCEQCDepartment",rowid)) quit:rowid=""  d
	.d ResetVariablesGetDepartmentData
	.s DeptRowID = rowid
	.q:(($p($g(^DHCEQCCode("DHCEQCDepartment",rowid)),"^",19))="Y")
	.s DeptCode = $p($g(^DHCEQCCode("DHCEQCDepartment",rowid)),"^",1)
	.q:(Code'="")&&(DeptCode'[Code)
	.s DeptDesc = $p($g(^DHCEQCCode("DHCEQCDepartment",rowid)),"^",2)
	.q:(Desc'="")&&(DeptDesc'[Desc)
	.s DeptLeaderUserDR = $p($g(^DHCEQCCode("DHCEQCDepartment",rowid)),"^",3)
	.q:(LeaderUserDR'="")&&(DeptLeaderUserDR'=LeaderUserDR)
	.i (DeptLeaderUserDR'="")  s DeptLeaderUser = $p($g(^DHCEQCCode("DHCEQCUser",DeptLeaderUserDR)),"^",4)
	.s DeptContactsUserDR = $p($g(^DHCEQCCode("DHCEQCDepartment",rowid)),"^",4)
	.q:(ContactsUserDR'="")&&(DeptContactsUserDR'=ContactsUserDR)
	.i (DeptContactsUserDR'="") s DeptContactsUser = $p($g(^DHCEQCCode("DHCEQCUser",DeptContactsUserDR)),"^",4)
	.s DeptTelephone = $p($g(^DHCEQCCode("DHCEQCDepartment",rowid)),"^",5)
	.q:(Telephone'="")&&(DeptTelephone'[Telephone)
	.s DeptAddress = $p($g(^DHCEQCCode("DHCEQCDepartment",rowid)),"^",6)
	.q:(Address'="")&&(DeptAddress'[Address)
	.s DeptOrganizeType = $p($g(^DHCEQCCode("DHCEQCDepartment",rowid)),"^",7)
	.q:(OrganizeType'="")&&(DeptOrganizeType'=OrganizeType)
	.s DeptOrganizeID = $p($g(^DHCEQCCode("DHCEQCDepartment",rowid)),"^",8)
	.q:(OrganizeID'="")&&(DeptOrganizeID'=OrganizeID)
	.;当前登录人是否有权限查看表数据 CZF0138
	.q:(DeptOrganizeType=1)&&(sHospID'="")&&(DeptOrganizeID'=sHospID)
	.i DeptOrganizeType=1 d
	..s DeptOrganizeTypeDesc="医院"
	..s DeptOrganize=$p($g(^CT("HOSP", +DeptOrganizeID)),"^",2)
	.else  if DeptOrganizeType=2 d
	..s DeptOrganizeTypeDesc="供应商"
	..s DeptOrganize=##class(web.DHCEQCommon).GetTrakNameByID("prov", DeptOrganizeID)
	.s DeptExType = $p($g(^DHCEQCCode("DHCEQCDepartment",rowid)),"^",10)
	.q:(ExType'="")&&(DeptExType'=ExType)
	.s DeptExTypeDesc = $CASE(DeptExType,"1":"DHC-HIS","":"")
	.s DeptExID = $p($g(^DHCEQCCode("DHCEQCDepartment",rowid)),"^",11)
	.q:(ExID'="")&&(DeptExID'=ExID)
	.i DeptExID'="" s DeptExName=##class(web.DHCEQCommon).GetSplitDataByFlag($p($g(^CTLOC(DeptExID)),"^",2),"-")
	.s DeptExDesc = $p($g(^DHCEQCCode("DHCEQCDepartment",rowid)),"^",12)
	.q:(ExDesc'="")&&(DeptExDesc'=ExDesc)
	.s DeptActiveFlag = $p($g(^DHCEQCCode("DHCEQCDepartment",rowid)),"^",13)
	.s DeptActiveFlagDesc = $CASE(DeptActiveFlag,"Y":"是","N":"否","":"")
	.q:(ActiveFlag'="")&&(DeptActiveFlag'=ActiveFlag)
	.s DeptDateFrom = $p($g(^DHCEQCCode("DHCEQCDepartment",rowid)),"^",17)
	.s DeptDateTo = $p($g(^DHCEQCCode("DHCEQCDepartment",rowid)),"^",18)
	.s DeptDateFrom=##class(web.DHCEQCommon).TransValueToPage(DeptDateFrom,"date")
	.s DeptDateTo=##class(web.DHCEQCommon).TransValueToPage(DeptDateTo,"date")
	.s DeptHold1 = $p($g(^DHCEQCCode("DHCEQCDepartment",rowid)),"^",20)
	.s DeptHold2 = $p($g(^DHCEQCCode("DHCEQCDepartment",rowid)),"^",21)
	.s DeptHold3 = $p($g(^DHCEQCCode("DHCEQCDepartment",rowid)),"^",22)
	.s DeptHold4 = $p($g(^DHCEQCCode("DHCEQCDepartment",rowid)),"^",23)
	.s DeptHold5 = $p($g(^DHCEQCCode("DHCEQCDepartment",rowid)),"^",24)
	.///add by ZY0210 增加别名表中拼音码的检索
	.s AText=""
	.s ARowID=##Class(web.DHCEQ.Plat.CTAlias).GetAlias("DHCEQCDepartment",rowid,"text","PYCode")
	.i ARowID'="" s AText=$p($g(^DHCEQCCode("DHCEQCAlias",ARowID)),"^",1)
	.d OutputRowGetDepartmentData
	
	Quit $$$OK
OutputRowGetDepartmentData
	Set TRow=TRow+1
	Set Data=$lb(TRow,DeptRowID,DeptCode,DeptDesc,DeptLeaderUserDR,DeptLeaderUser,DeptContactsUserDR,DeptContactsUser,DeptTelephone,DeptAddress,DeptOrganizeType,DeptOrganizeTypeDesc,DeptOrganizeID,DeptOrganize,DeptExType,DeptExTypeDesc,DeptExID,DeptExName,DeptExDesc,DeptActiveFlag,DeptActiveFlagDesc,DeptDateFrom,DeptDateTo,THold1,DeptHold2,DeptHold3,DeptHold4,DeptHold5,ARowID,AText)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	
	quit
ResetVariablesGetDepartmentData
	Set (DeptRowID,DeptCode,DeptDesc,DeptLeaderUserDR,DeptLeaderUser,DeptContactsUserDR,DeptContactsUser,DeptTelephone,DeptAddress,DeptOrganizeType,DeptOrganizeTypeDesc,DeptOrganizeID,DeptOrganize,DeptExType,DeptExTypeDesc,DeptExID,DeptExDesc,DeptActiveFlag,DeptActiveFlagDesc,DeptDateFrom,DeptDateTo,THold1,DeptHold2,DeptHold3,DeptHold4,DeptHold5,DeptExName,ARowID,AText)=""   /// modify by jyp 2019-02-19    modify hly 20190806
	quit
}

ClassMethod GetDepartmentDataFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDepartmentDataExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind=""
 	{
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else
 	{
 		Set Row=^CacheTemp(repid,ind)
 	}
	Set qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetDepartmentDataClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDepartmentDataExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// add  by csj 2020-03-13 
/// 描述：批量同步科室
/// 入参: 无
/// 返回：JSON字符串:{SQLCODE:"0",Data:Count} Count:更新数量
/// w ##class("web.DHCEQ.Plat.CTDepartment").SyncDeptBatch()
ClassMethod SyncDeptBatch()
{
	s (CTLocID,Count)=0
	f  s CTLocID = $o(^CTLOC(CTLocID)) q:CTLocID=""  d
	.s Rtn = ##class(web.DHCEQ.Plat.JsonObject).FromJSON(##class("web.DHCEQ.Plat.CTDepartment").SyncDeptSingle(CTLocID))	//CZF0131 2020-01-20
	.i Rtn.SQLCODE=0 s Count=Count+1
	q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("0",Count)
}

/// add  by csj 2020-03-13 
/// 描述：同步单一科室
/// 入参: CTLocID HIS科室ID
/// 返回：保存结果JSON字符串
/// w ##class("web.DHCEQ.Plat.CTDepartment").SyncDeptSingle()
ClassMethod SyncDeptSingle(CTLocID)
{
	s EQDeptObj=##class(web.DHCEQ.Plat.JsonObject).%New()   //CZF0131 2021-01-20
	s ExType=""
	&SQL(select TD_Value into:ExType from sqluser.DHC_EQCTypeDefine where TD_Name='ExType' and TD_Desc='DHC-HIS')
	s EQDeptID=$o(^DHCEQCCode("DHCEQCDepartment",0,"ExID","Y",ExType,CTLocID,0))
	i EQDeptID'="" s EQDeptObj.DeptRowID=EQDeptID
	s LocInfo = $g(^CTLOC(CTLocID))
	s EQDeptObj.DeptCode=$p(LocInfo,"^",1)	
	s EQDeptObj.DeptDesc=$p(LocInfo,"^",2)
	s EQDeptObj.DeptActiveFlag="Y"
	s (OrganizeType)=""
	&SQL(select TD_Value into:OrganizeType from sqluser.DHC_EQCTypeDefine where TD_Name='OrganizeType' and TD_Desc='医院')
	s EQDeptObj.DeptOrganizeType=OrganizeType	;$p(LocInfo,"^",1)
	s EQDeptObj.DeptOrganizeID=$p(LocInfo,"^",22)                     //%session.Get("LOGON.HOSPID") modified by wy 2020-8-21 bug WY0076 多院区科室同步院区ID取值问题
	s ExType=""
	&SQL(select TD_Value into:ExType from sqluser.DHC_EQCTypeDefine where TD_Name='ExType' and TD_Desc='DHC-HIS')
	s EQDeptObj.DeptExType=ExType	
	s EQDeptObj.DeptExID=CTLocID
	s EQDeptObj.DeptExDesc=EQDeptObj.DeptDesc
	
	s Rtnstr=##class(web.DHCEQ.Plat.CTDepartment).SaveData(EQDeptObj.%ToJSON(),2)
	
	//增加系统参数同步科室时同步科室类型为科室 czf 2021-04-21 begin 1878102
	s RtnObj=##class(web.DHCEQ.Plat.JsonObject).FromJSON(Rtnstr)
	s RtnCode=RtnObj.SQLCODE
	i RtnCode=0
	{
		s DeptRowID=RtnObj.Data
		s LocTypeFlag=##class(web.DHCEQCommon).GetSysInfo("990083")
		s LTRowID=$o(^DHCEQCCode("DHCEQCLocType",0,"LocType","2",DeptRowID,""))
		i (+LocTypeFlag)&&(LTRowID="")
		{
			&SQL(INSERT INTO SQLUSER.DHC_EQCLocType(LT_type,LT_LocDR) values ('2',:DeptRowID))
		}
		i SQLCODE q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,"科室类型同步错误")
	}
	q Rtnstr
	//czf 2021-04-21 end
}

/// add  by csj 2020-03-17
/// 描述：部门科室对照query
/// 入参： Code 科室代码,Desc 科室描述,DiffFlag 只显示差异
/// 输出列：TRow,TCTLocID,TEQDeptID,TEQDeptCode,TEQDeptName,TCTLocCode,TCTLocCodeDesc
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.Plat.CTDepartment","GetDepCTLocMapList","","","")
Query GetDepCTLocMapList(Code As %String = "", Desc As %String = "", DiffFlag As %String = "") As %Query(ROWSPEC = "TRow:%String,TCTLocID:%String,TEQDeptID:%String,TEQDeptCode:%String,TEQDeptName:%String,TCTLocCode:%String,TCTLocCodeDesc:%String")
{
}

ClassMethod GetDepCTLocMapListExecute(ByRef qHandle As %Binary, Code As %String = "", Desc As %String = "", DiffFlag As %String = "") As %Status
{
	new repid, index, rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s TRow=0
	
	s TCTLocID=0
	s ExType=""
	&SQL(select TD_Value into:ExType from sqluser.DHC_EQCTypeDefine where TD_Name='ExType' and TD_Desc='DHC-HIS')
	f  s TCTLocID = $o(^CTLOC(TCTLocID)) q:TCTLocID=""  d
	.d ResetVariablesGetDepCTLocMapList
	.s TEQDeptID=$o(^DHCEQCCode("DHCEQCDepartment",0,"ExID","Y",ExType,TCTLocID,0)) 
	.i TEQDeptID'="" d
	..s TEQDeptCode=$p($g(^DHCEQCCode("DHCEQCDepartment",TEQDeptID)),"^",1)
	..s TEQDeptName=##class(web.DHCEQCommon).GetSplitDataByFlag($p($g(^DHCEQCCode("DHCEQCDepartment",TEQDeptID)),"^",2),"-")
	.s CTLocInfo = $g(^CTLOC(TCTLocID))
	.s TCTLocCode=$p(CTLocInfo,"^",1)
	.q:(Code'="")&&((TCTLocCode'[Code))
	.s TCTLocCodeDesc=$p(CTLocInfo,"^",2)
	.q:(Desc'="")&&((TCTLocCodeDesc'[Desc))
	.q:(DiffFlag="Y")&&(TCTLocCode=TEQDeptCode)&&(TCTLocCodeDesc=TEQDeptName)
	.d OutputRowGetDepCTLocMapList
	
	Quit $$$OK
OutputRowGetDepCTLocMapList
	Set TRow=TRow+1
	Set Data=$lb(TRow,TCTLocID,TEQDeptID,TEQDeptCode,TEQDeptName,TCTLocCode,TCTLocCodeDesc)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	
	quit
ResetVariablesGetDepCTLocMapList
	Set (TEQDeptID,TEQDeptCode,TEQDeptName,TCTLocCode,TCTLocCodeDesc)=""   /// modify by jyp 2019-02-19    modify hly 20190806
	quit
}

ClassMethod GetDepCTLocMapListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDepCTLocMapListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind=""
 	{
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else
 	{
 		Set Row=^CacheTemp(repid,ind)
 	}
	Set qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetDepCTLocMapListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDepCTLocMapListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

}
