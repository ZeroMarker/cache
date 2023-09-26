Class web.DHCEQInit Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// 注意:初始化前请检查要初始化的设备的 DHC_EQDepreSet的累计折旧、累计月份，DHC_EQEquip的累计折旧，DHC_EQFunds的累计折旧
/// 初始化折旧
/// 入参：vDate,初始化折旧到该日期（格式为数字），即计算累计折旧 从入库日期开始至该日期。
/// 	  EquipTypeIDS,	初始化的类组串，其中类组间用","分割
/// 	  StoreLocDR	库房：要初始化的库房及其所管理的科室
/// 		DepreTypeDR	折旧类型，默认为主折旧，1
/// 		KeepDepreFee  是否保留原累计折旧 0或空，不保留 1保留 
/// 		MinEquipID   	开始设备ID  不传默认0
/// 		MaxEquipID   	结束设备ID  不传默认0
/// 		DepreMonthNum   补提折旧月数  不传默认0  所有的折旧都补提传999
/// 		AdjustFlag   是否写数据调整记录，记到新增数据调整中
/// 		InputFlag   是否只初始化导入的台帐，默认Y，只初时候导入的数据，改成N，就初始化所有的
/// 返回：初始化失败的条目，0为成功，大于0有失败的记录。
/// w ##Class(web.DHCEQMonthDepre).InitEquipDepre("2022-01-31")
ClassMethod InitEquipDepre(vDate As %Library.String = "", EquipTypeIDS As %Library.String = "", StoreLocDR As %Library.String = "", DepreTypeDR As %Library.String = "1", KeepDepreFee As %Library.String = "", MinEquipID As %Library.String = "0", MaxEquipID As %Library.String = "0", DepreMonthNum As %Library.String = "0", AdjustFlag As %Library.String = "", InputFlag As %Library.String = "")
{
	n result
	i DepreTypeDR="" s DepreTypeDR="1"
	s result=##Class(web.DHCEQMonthDepre).InitEquipDepre($zdh(vDate,3),EquipTypeIDS,StoreLocDR,DepreTypeDR,KeepDepreFee,MinEquipID,MaxEquipID,DepreMonthNum,AdjustFlag,InputFlag)
	s ^DHCEQInitTemp("InitDepre",$h)=result_"^"_vDate_"^"_EquipTypeIDS_"^"_StoreLocDR_"^"_DepreTypeDR_"^"_KeepDepreFee_"^"_MinEquipID_"^"_MaxEquipID_"^"_DepreMonthNum_"^"_AdjustFlag_"^"_InputFlag
	q result
}

/// 重新整理 2010-10-27
/// 根据系统现有数据对系统初始化月结：
/// 入参：IsCurMonth   0:上月  1:当月
/// 	  EquipTypeIDS 设备类组串，以","分割，为空表示全部初始化
/// 	  StoreLocDR	库房：要初始化的库房及其所管理的科室
/// w ##Class(web.DHCEQInit).InitReport(0)
ClassMethod InitReport(IsCurMonth, EquipTypeIDS As %Library.String = "", StoreLocDR As %Library.String = "")
{
	n result
	s result=##Class(web.DHCEQReport).InitReport(IsCurMonth,EquipTypeIDS,StoreLocDR)
	s ^DHCEQInitTemp("InitReport",$h)=result_"^"_IsCurMonth_"^"_EquipTypeIDS_"^"_StoreLocDR
	q result
}

/// czf 2022-02-15
/// 初始化快照
/// w ##Class(web.DHCEQInit).InitSnap(0)
ClassMethod InitSnap()
{
	n result
	s result=##Class(web.DHCEQSnapShot).Snap()
	s ^DHCEQInitTemp("InitSnap",$h)=result
	q result
}

/// 清除代码表中数据
ClassMethod ClearCodeData()
{
	k ^DHCEQCCode("DHCEQCGroupCTable")
	k ^DHCEQCCode("DHCEQCGroupEquipType")
}

/// 备份数据到^DHCEQBakData的一个节点下面
/// 入参：Node节点名称，一般以日期为节点YYYYMMDD+说明
/// w  ##Class(web.DHCEQInit).BakEqData("Bak101013")
ClassMethod BakEqData(Node)
{
	n CurDate
	s CurDate=$zdt(+$H,8)
	
	;代码
	m ^DHCEQBakData(CurDate,Node,"CodeTable")=^DHCEQCCodeTable
	m ^DHCEQBakData(CurDate,Node,"Code")=^DHCEQCCode
	
	;设备台帐信息
	m ^DHCEQBakData(CurDate,Node,"Equip")=^DHCEQEquip
	m ^DHCEQBakData(CurDate,Node,"Affix")=^DHCEQAffix
	m ^DHCEQBakData(CurDate,Node,"Doc")=^DHCEQDoc
	m ^DHCEQBakData(CurDate,Node,"Picture")=^DHCEQPicture
	m ^DHCEQBakData(CurDate,Node,"ChangeAccount")=^DHCEQChangeAccount	
	m ^DHCEQBakData(CurDate,Node,"DepreSet")=^DHCEQDepreSet	
	m ^DHCEQBakData(CurDate,Node,"AppendFee")=^DHCEQAppendFee
	m ^DHCEQBakData(CurDate,Node,"AppendFile")=^DHCEQAppendFile
	m ^DHCEQBakData(CurDate,Node,"LifeFee")=^DHCEQLifeFee
	m ^DHCEQBakData(CurDate,Node,"ChangeInfo")=^DHCEQChangeInfo
	m ^DHCEQBakData(CurDate,Node,"LifeInfo")=^DHCEQLifeInfo
	m ^DHCEQBakData(CurDate,Node,"Funds")=^DHCEQFunds
	m ^DHCEQBakData(CurDate,Node,"DHCEQMark")=^DHCEQMark
	
	;库房管理
	m ^DHCEQBakData(CurDate,Node,"InStock")=^DHCEQInStock
	m ^DHCEQBakData(CurDate,Node,"InStockList")=^DHCEQInStockList
	m ^DHCEQBakData(CurDate,Node,"StoreMove")=^DHCEQStoreMove
	m ^DHCEQBakData(CurDate,Node,"StoreMoveList")=^DHCEQStoreMoveList
	m ^DHCEQBakData(CurDate,Node,"Return")=^DHCEQReturn
	m ^DHCEQBakData(CurDate,Node,"ReturnList")=^DHCEQReturnList
	m ^DHCEQBakData(CurDate,Node,"ChangeStock")=^DHCEQChangeStock	
	m ^DHCEQBakData(CurDate,Node,"Invoice")=^DHCEQInvoice
	m ^DHCEQBakData(CurDate,Node,"InvoiceUseMap")=^DHCEQInvoiceUseMap
	
	;审批信息
	m ^DHCEQBakData(CurDate,Node,"ApproveInfo")=^DHCEQApproveInfo
	m ^DHCEQBakData(CurDate,Node,"ApproveList")=^DHCEQApproveList
	
	;维修保养
	m ^DHCEQBakData(CurDate,Node,"Maint")=^DHCEQMaint
	m ^DHCEQBakData(CurDate,Node,"MaintPlan")=^DHCEQMaintPlan
	m ^DHCEQBakData(CurDate,Node,"MaintRequest")=^DHCEQMaintRequest
	m ^DHCEQBakData(CurDate,Node,"Inspect")=^DHCEQInspect
	m ^DHCEQBakData(CurDate,Node,"InspectPlan")=^DHCEQInspectPlan
	
	;验收报废
	m ^DHCEQBakData(CurDate,Node,"OpenCheckRequest")=^DHCEQOpenCheckRequest
	m ^DHCEQBakData(CurDate,Node,"OpenCheckList")=^DHCEQOpenCheckList
	m ^DHCEQBakData(CurDate,Node,"DisuseRequest")=^DHCEQDisuseRequest	
	m ^DHCEQBakData(CurDate,Node,"DisuseRequestList")=^DHCEQDisuseRequestList
	
	;使用折旧
	m ^DHCEQBakData(CurDate,Node,"CostAllot")=^DHCEQCostAllot
	m ^DHCEQBakData(CurDate,Node,"CostAllotList")=^DHCEQCostAllotList
	m ^DHCEQBakData(CurDate,Node,"UseRecord")=^DHCEQUseRecord
	m ^DHCEQBakData(CurDate,Node,"MonthDepre")=^DHCEQMonthDepre
	m ^DHCEQBakData(CurDate,Node,"CostAllotDetail")=^DHCEQCostAllotDetail
	
	m ^DHCEQBakData(CurDate,Node,"MonthReportList")=^DHCEQMonthReportList
	q "finish"
}

/// Add By DJ 2016-02-26
/// 描述:初始化配件月结
/// 入参：IsCurMonth   0:上月  1:当月
/// 	  EquipTypeIDS 设备类组串，以","分割，为空表示全部初始化
/// 	  StoreLocDR	库房：要初始化的库房及其所管理的科室
ClassMethod InitAccessoryReport(IsCurMonth, EquipTypeIDS As %Library.String = "", StoreLocDR As %Library.String = "")
{
	q ##Class(web.DHCEQAReport).InitAccessoryReport(IsCurMonth,EquipTypeIDS,StoreLocDR)
}

/// add by CZF 2020-03-04 CZF0105
/// 初始化科室
/// w ##Class(web.DHCEQInit).InitDepartment()
ClassMethod InitDepartment()
{
	//同步CT_Loc表信息至DHC_EQCDepartment
	&SQL(INSERT INTO SQLUSER.DHC_EQCDepartment(Dept_Code,Dept_Desc,Dept_LeaderUserDR,Dept_ContactsUserDR,Dept_OrganizeType,Dept_OrganizeID,Dept_DeptType,Dept_ExType,Dept_ExID,Dept_ExDesc,Dept_ActiveFlag,Dept_InvalidFlag) SELECT CTLOC_Code,CTLOC_Desc,'1','1','1',CTLOC_Hospital_DR,'1','1',CTLOC_RowID,CTLOC_Desc,'Y','N' FROM SQLUSER.CT_Loc)
	i SQLCODE q "初始化科室错误,SQLCODE="_SQLCODE_",错误信息:"_$g(%msg)
	
	q "success"
}

/// add by ZY0243 2020-09-18 
/// 初始化科室拼音码
/// w ##Class(web.DHCEQInit).InitAlias("DHC_EQCEquipeCat")
/// modified by czf 20210430
ClassMethod InitAlias(tablename)
{
	i tablename="" q "tablename is not null!"
	s SQLCODE=0
	s ErrID=0
	if tablename="DHC_EQCDepartment"
	{
		//同步DHC_EQCDepartment表名称的拼音码至DHC_EQCAlias
		s rowid=0
		f  s rowid=$o(^DHCEQCCode("DHCEQCDepartment",rowid)) q:(rowid="")||(SQLCODE'=0)  d
		.s locDesc=$p($g(^DHCEQCCode("DHCEQCDepartment",rowid)),"^",2)
		.s PYStr=##class(web.DHCEQCHanZiEncoding).GetEncoding(locDesc,4,"","U")
		.&SQL(INSERT INTO SQLUSER.DHC_EQCAlias(A_Text,A_Desc,A_SourceType,A_SourceID,A_InvalidFlag,A_Type) values (:PYStr,:PYStr,'DHCEQCDepartment',:rowid,'N','PYCode'))
		.i SQLCODE s ErrID=rowid
		.q:SQLCODE
		
		i SQLCODE q "同步科室拼音码错误,错误信息:"_$g(%msg)
	}
	elseif tablename="DHC_EQCEquipeCat"
	{
		//同步DHC_EQCDepartment表名称的拼音码至DHC_EQCAlias
		s rowid=0
		f  s rowid=$o(^DHCEQCCode("DHCEQCEquipeCat",rowid)) q:(rowid="")||(SQLCODE'=0)  d
		.s ECDesc=$p($g(^DHCEQCCode("DHCEQCEquipeCat",rowid)),"^",2)
		.s PYStr=##class(web.DHCEQCHanZiEncoding).GetEncoding(ECDesc,4,"","U")
		.&SQL(INSERT INTO SQLUSER.DHC_EQCAlias(A_Text,A_Desc,A_SourceType,A_SourceID,A_InvalidFlag,A_Type) values (:PYStr,:PYStr,'DHCEQCEquipeCat',:rowid,'N','PYCode'))
		.i SQLCODE s ErrID=rowid
		.q:SQLCODE
		
		i SQLCODE q "同步DHC_EQCEquipeCat拼音码错误,错误信息:"_$g(%msg)
	}
	elseif tablename="DHC_EQCUser"
	{
		//同步DHC_EQCUser表名称的拼音码至DHC_EQCAlias
		s rowid=0
		f  s rowid=$o(^DHCEQCCode("DHCEQCUser",rowid)) q:(rowid="")||(SQLCODE'=0)  d
		.s username=$p($g(^DHCEQCCode("DHCEQCUser",rowid)),"^",4)
		.s PYStr=##class(web.DHCEQCHanZiEncoding).GetEncoding(username,4,"","U")
		.&SQL(INSERT INTO SQLUSER.DHC_EQCAlias(A_Text,A_Desc,A_SourceType,A_SourceID,A_InvalidFlag,A_Type) values (:PYStr,:PYStr,'DHCEQCUser',:rowid,'N','PYCode'))
		.i SQLCODE s ErrID=rowid
		.q:SQLCODE
		
		i SQLCODE q "同步用户拼音码错误,错误信息:"_$g(%msg)
	}
	q "success"
}

/// 初始化人员
/// add by CZF 2020-03-04 CZF0105
/// w ##Class(web.DHCEQInit).InitDHCEQUser()
ClassMethod InitDHCEQUser()
{
	TSTART
	//同步SS_User表信息至DHC_EQCUser
	k ^DHCEQCCode("DHCEQCUser")
	&SQL(INSERT INTO SQLUSER.DHC_EQCUser (U_LoginName,U_LogoinPassword,U_Name,U_DefaultLocDR,U_GroupDR,U_ExType,U_ExID,U_ActiveFlag) SELECT SSUSR_Initials,SSUSR_Password,SSUSR_Name,SSUSR_DefaultDept_DR,SSUSR_Group,'1',SSUSR_RowId,'Y' FROM SQLUSER.SS_User)
	i SQLCODE
	{
		TROLLBACK
		q "同步DHC_EQCUser表错误，SQLCODE="_SQLCODE_",错误信息："_$g(%msg)
	}
	
	//更新组内用户表信息
	s SQLCODE=0
	s URowID=0
	f  s URowID=$o(^DHCEQCCode("DHCEQCUser",URowID))  q:(URowID="")||(SQLCODE'=0)  d
	.s UDeptDR=$p($g(^DHCEQCCode("DHCEQCUser",URowID)),"^",14)
	.q:UDeptDR=""
	.s NewDeptDR=$o(^DHCEQCCode("DHCEQCDepartment",0,"ExID","Y",1,UDeptDR,0))
	.q:NewDeptDR=""
	.// MZY0023	1306895		2020-05-08	补充关联用户的组织类型和组织
	.s OrganizeType=0
	.s OrganizeID=+$p($g(^CTLOC(UDeptDR)),"^",22)
	.i OrganizeID>0 s OrganizeType=1	;默认类型值取自DHC_EQCTypeDefine
	.&SQL(Update SQLUSER.DHC_EQCUser Set U_DefaultLocDR=:NewDeptDR,U_OrganizeType=:OrganizeType,U_OrganizeID=:OrganizeID Where U_RowID=:URowID)
	
	i SQLCODE
	{
		TROLLBACK
		q "更新组内用户表信息错误,SQLCODE="_SQLCODE_",错误信息："_$g(%msg)
	}
	
	TCOMMIT
	q "success"
}

/// add by lmm 2020-04-10
/// 描述：初始化台账ABC分类
/// 出参：台账初始化数量
/// modify by lmm 2020-04-13 增加事务 sqlcode不为0时跳出循环  过滤存在ABC分类设备
/// w ##Class(web.DHCEQInit).InitEquipABCCat()
ClassMethod InitEquipABCCat()
{
	s SQLCODE=0
	TSTART
	s ABCCat=##class(web.DHCEQCommon).GetSysInfo("201013")
	i ABCCat="" 
	{
		TROLLBACK
		q "201013参数未配置！"
	}
	s AType=$Piece(ABCCat,",",1)
	s BType=$Piece(ABCCat,",",2)
	s rowid=0
	f  s rowid=$o(^DHCEQEquip(rowid))  quit:(rowid="")||(SQLCODE'=0)  d
	.s TOringinalfee = $p(^DHCEQEquip(rowid),"^",27)
	.q:($p(^DHCEQEquip(rowid),"^",2)'="")
	.i TOringinalfee>=AType  d
	..s EQABCType="A"
	.e  i (TOringinalfee>=BType)&&(TOringinalfee<AType)  d
	..s EQABCType="B"
	.e  i (TOringinalfee<BType)  d
	..s EQABCType="C"
	.&sql(Update Sqluser.DHC_EQEquip set EQ_ABCType=:EQABCType where EQ_RowID=:rowid)
	
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE
	}
	
	TCOMMIT
	q "success"
}

/// add by czf 2021-04-30
/// 初始化人员拼音码
/// DHC_EQCUser
/// d ##Class(web.DHCEQInit).InitUserCode()
ClassMethod InitUserCode()
{
	s SQLCODE=0
	s URowID=0
	f  s URowID=$o(^DHCEQCCode("DHCEQCUser",URowID))  q:(URowID="")  d
	.s UserName=$p($g(^DHCEQCCode("DHCEQCUser",URowID)),"^",4)
	.s UserCode=##class(web.DHCEQCHanZiEncoding).GetEncoding(UserName,4,"","U")
	.&SQL(Update SQLUSER.DHC_EQCUser Set U_Code=:UserCode where U_RowID=:URowID)
	.
	q "success"
}

/// CZF0138 2021-05-27
/// 初始化表数据医院对照ID
/// w ##Class(web.DHCEQInit).InitBDPTableMap()
ClassMethod InitBDPTableMap(HospID)
{
	q:HospID="" "医院ID不能为空!"
	d ##Class(web.DHCEQ.Util.BDPCommonUtil).InitBDPMappingHosp("DHC_EQCEquipType","","",HospID)
	d ##Class(web.DHCEQ.Util.BDPCommonUtil).InitBDPMappingHosp("DHC_EQCMasterItem","","",HospID)
	d ##Class(web.DHCEQ.Util.BDPCommonUtil).InitBDPMappingHosp("DHC_EQCSysSet","","",HospID)
	d ##Class(web.DHCEQ.Util.BDPCommonUtil).InitBDPMappingHosp("DHC_EQCFinaceItem","","",HospID)
	d ##Class(web.DHCEQ.Util.BDPCommonUtil).InitBDPMappingHosp("DHC_EQCFunctionCat","","",HospID)
	d ##Class(web.DHCEQ.Util.BDPCommonUtil).InitBDPMappingHosp("DHC_EQCLocation","","",HospID)
	d ##Class(web.DHCEQ.Util.BDPCommonUtil).InitBDPMappingHosp("DHC_EQCApproveSet","","",HospID)
	q "sucess"
}

/// czf 2023-01-30
/// 获取初始化折旧、月报、快照操作信息
/// d ##class(%ResultSet).RunQuery("web.DHCEQInit","GetInitTaskInfo")
Query GetInitTaskInfo() As %Query(ROWSPEC = "TaskType:%String,ExeDate:%String,result:%String,InitDate:%String,EquipTypes:%String,StoreLoc:%String,DepreType:%String,KeepDepreFee:%String,MinEquipID:%String,MaxEquipID:%String,DepreMonthNum:%String,AdjustFlag:%String,InputFlag:%String,IsCurMonth:%String")
{
}

ClassMethod GetInitTaskInfoExecute(ByRef qHandle As %Binary) As %Status
{
 	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	//取初始化折旧结果信息
	s Date=""
	f  s Date=$o(^DHCEQInitTemp("InitDepre",Date)) q:Date=""  d
	.d ResetGetInitTaskInfo
	.s ExeDate=$zd($p(Date,",",1),3)_" "_$zt($p(Date,",",2),1)
	.s InitDepreInfo=$g(^DHCEQInitTemp("InitDepre",Date))
	.s result=$p(InitDepreInfo,"^",1)
	.i result=0 s result="执行成功!"
	.e  s result="有"_result_"条数据未初始化!"
	.s InitDate=$p(InitDepreInfo,"^",2)
	.s EquipTypeIDS=$p(InitDepreInfo,"^",3)
	.s etlen=$l(EquipTypeIDS,",")
	.f i=1:1:etlen d
	..s EquipTypeID=$p(EquipTypeIDS,",",i)
	..q:EquipTypeID=""
	..s EquipType=##class(web.DHCEQCommon).GetTrakNameByID("equiptype",EquipTypeID)
	..i EquipTypes'="" s EquipTypes=EquipTypes_","
	..s EquipTypes=EquipTypes_EquipType
	.s StoreLocDR=$p(InitDepreInfo,"^",4)
	.s StoreLoc=##class(web.DHCEQCommon).GetTrakNameByID("dept",StoreLocDR)
	.s DepreTypeDR=$p(InitDepreInfo,"^",5)
	.i DepreTypeDR'="" s DepreType=$p($g(^DHCEQCCode("DHCEQCDepreType",DepreTypeDR)),"^",2)
	.s KeepDepreFee=$p(InitDepreInfo,"^",6)
	.s KeepDepreFee=$case(KeepDepreFee,"1":"是",:"否")
	.s MinEquipID=$p(InitDepreInfo,"^",7)
	.s MaxEquipID=$p(InitDepreInfo,"^",8)
	.s DepreMonthNum=$p(InitDepreInfo,"^",9)
	.s AdjustFlag=$p(InitDepreInfo,"^",10)
	.s AdjustFlag=$case(AdjustFlag,"Y":"是",:"否")
	.s InputFlag=$p(InitDepreInfo,"^",11)
	.s InputFlag=$case(InputFlag,"Y":"是",:"否")
	.s TaskType="初始化折旧"
	.d OutputGetInitTaskInfo
	
	//初始化月报信息
	s Date=""
	f  s Date=$o(^DHCEQInitTemp("InitReport",Date)) q:Date=""  d
	.d ResetGetInitTaskInfo
	.s ExeDate=$zd($p(Date,",",1),3)_" "_$zt($p(Date,",",2),1)
	.s InitReportInfo=$g(^DHCEQInitTemp("InitReport",Date))
	.s result=$p(InitReportInfo,"^",1)
	.i result="Success" s result="执行成功!"
	.e  s result="执行失败!"_result
	.s IsCurMonth=$p(InitReportInfo,"^",2)
	.s IsCurMonth=$case(IsCurMonth,"0":"上月","1":"当月")
	.s EquipTypeIDS=$p(InitReportInfo,"^",3)
	.s etlen=$l(EquipTypeIDS,",")
	.f i=1:1:etlen d
	..s EquipTypeID=$p(EquipTypeIDS,",",i)
	..q:EquipTypeID=""
	..s EquipType=##class(web.DHCEQCommon).GetTrakNameByID("equiptype",EquipTypeID)
	..i EquipTypes'="" s EquipTypes=EquipTypes_","
	..s EquipTypes=EquipTypes_EquipType
	.s StoreLocDR=$p(InitReportInfo,"^",4)
	.s StoreLoc=##class(web.DHCEQCommon).GetTrakNameByID("dept",StoreLocDR)
	.s TaskType="初始化月报"
	.d OutputGetInitTaskInfo
	
	//初始化快照信息
	s Date=""
	f  s Date=$o(^DHCEQInitTemp("InitSnap",Date)) q:Date=""  d
	.d ResetGetInitTaskInfo
	.s ExeDate=$zd($p(Date,",",1),3)_" "_$zt($p(Date,",",2),1)
	.s InitSnapInfo=$g(^DHCEQInitTemp("InitSnap",Date))
	.s result=$p(InitSnapInfo,"^",1)
	.i result="0" s result="执行成功!"
	.e  s result="执行失败!"_result
	.s TaskType="初始化快照"
	.d OutputGetInitTaskInfo
	
	Quit $$$OK
OutputGetInitTaskInfo
	s Data=$lb(TaskType,ExeDate,result,InitDate,EquipTypes,StoreLoc,DepreType,KeepDepreFee,MinEquipID,MaxEquipID,DepreMonthNum,AdjustFlag,InputFlag,IsCurMonth)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetGetInitTaskInfo
	s (TaskType,InitDepreInfo,ExeDate,result,InitDate,EquipTypeIDS,EquipTypeID,EquipType,EquipTypes,StoreLocDR,StoreLoc,DepreTypeDR,DepreType,KeepDepreFee,MinEquipID,MaxEquipID,DepreMonthNum,AdjustFlag,InputFlag,IsCurMonth)=""
	quit
}

ClassMethod GetInitTaskInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetInitTaskInfoExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 		}
 	Else      {
 		Set Row=^CacheTemp(repid,ind)
 		}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetInitTaskInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetInitTaskInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// czf 2022-02-10
/// 获取初始化折旧操作信息
/// d ##class(%ResultSet).RunQuery("web.DHCEQInit","GetInitDepreInfo")
Query GetInitDepreInfo() As %Query(ROWSPEC = "ExeDate:%String,result:%String,InitDate:%String,EquipTypes:%String,StoreLoc:%String,DepreType:%String,KeepDepreFee:%String,MinEquipID:%String,MaxEquipID:%String,DepreMonthNum:%String,AdjustFlag:%String,InputFlag:%String")
{
}

ClassMethod GetInitDepreInfoExecute(ByRef qHandle As %Binary) As %Status
{
 	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s Date=""
	f  s Date=$o(^DHCEQInitTemp("InitDepre",Date)) q:Date=""  d
	.d ResetGetInitDepreInfo
	.s ExeDate=$zd($p(Date,",",1),3)_" "_$zt($p(Date,",",2),1)
	.s InitDepreInfo=$g(^DHCEQInitTemp("InitDepre",Date))
	.s result=$p(InitDepreInfo,"^",1)
	.i result=0 s result="执行成功!"
	.e  s result="有"_result_"条数据未初始化!"
	.s InitDate=$p(InitDepreInfo,"^",2)
	.s EquipTypeIDS=$p(InitDepreInfo,"^",3)
	.s etlen=$l(EquipTypeIDS,",")
	.f i=1:1:etlen d
	..s EquipTypeID=$p(EquipTypeIDS,",",i)
	..q:EquipTypeID=""
	..s EquipType=##class(web.DHCEQCommon).GetTrakNameByID("equiptype",EquipTypeID)
	..i EquipTypes'="" s EquipTypes=EquipTypes_","
	..s EquipTypes=EquipTypes_EquipType
	.s StoreLocDR=$p(InitDepreInfo,"^",4)
	.s StoreLoc=##class(web.DHCEQCommon).GetTrakNameByID("dept",StoreLocDR)
	.s DepreTypeDR=$p(InitDepreInfo,"^",5)
	.i DepreTypeDR'="" s DepreType=$p($g(^DHCEQCCode("DHCEQCDepreType",DepreTypeDR)),"^",2)
	.s KeepDepreFee=$p(InitDepreInfo,"^",6)
	.s KeepDepreFee=$case(KeepDepreFee,"1":"是",:"否")
	.s MinEquipID=$p(InitDepreInfo,"^",7)
	.s MaxEquipID=$p(InitDepreInfo,"^",8)
	.s DepreMonthNum=$p(InitDepreInfo,"^",9)
	.s AdjustFlag=$p(InitDepreInfo,"^",10)
	.s AdjustFlag=$case(AdjustFlag,"Y":"是",:"否")
	.s InputFlag=$p(InitDepreInfo,"^",11)
	.s InputFlag=$case(InputFlag,"Y":"是",:"否")
	.d OutputGetInitDepreInfo
	Quit $$$OK
OutputGetInitDepreInfo
	s Data=$lb(ExeDate,result,InitDate,EquipTypes,StoreLoc,DepreType,KeepDepreFee,MinEquipID,MaxEquipID,DepreMonthNum,AdjustFlag,InputFlag)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetGetInitDepreInfo
	s (InitDepreInfo,result,InitDate,EquipTypeIDS,etlen,EquipTypes,EquipType,StoreLocDR,StoreLoc,DepreTypeDR,DepreType,KeepDepreFee,MinEquipID,MaxEquipID,DepreMonthNum,AdjustFlag,InputFlag)=""
	quit
}

ClassMethod GetInitDepreInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetInitDepreInfoExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 		}
 	Else      {
 		Set Row=^CacheTemp(repid,ind)
 		}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetInitDepreInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetInitDepreInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// czf 2022-02-10
/// 获取初始化月报操作信息
/// d ##class(%ResultSet).RunQuery("web.DHCEQInit","GetInitReportInfo")
Query GetInitReportInfo() As %Query(ROWSPEC = "ExeDate:%String,result:%String,IsCurMonth:%String,EquipTypes:%String,StoreLoc:%String")
{
}

ClassMethod GetInitReportInfoExecute(ByRef qHandle As %Binary) As %Status
{
 	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s Date=""
	f  s Date=$o(^DHCEQInitTemp("InitReport",Date)) q:Date=""  d
	.d ResetGetInitReportInfo
	.s ExeDate=$zd($p(Date,",",1),3)_" "_$zt($p(Date,",",2),1)
	.s InitReportInfo=$g(^DHCEQInitTemp("InitReport",Date))
	.s result=$p(InitReportInfo,"^",1)
	.i result="Success" s result="执行成功!"
	.e  s result="执行失败!"_result
	.s IsCurMonth=$p(InitReportInfo,"^",2)
	.s IsCurMonth=$case(IsCurMonth,"0":"上月","1":"当月")
	.s EquipTypeIDS=$p(InitReportInfo,"^",3)
	.s etlen=$l(EquipTypeIDS,",")
	.f i=1:1:etlen d
	..s EquipTypeID=$p(EquipTypeIDS,",",i)
	..q:EquipTypeID=""
	..s EquipType=##class(web.DHCEQCommon).GetTrakNameByID("equiptype",EquipTypeID)
	..i EquipTypes'="" s EquipTypes=EquipTypes_","
	..s EquipTypes=EquipTypes_EquipType
	.s StoreLocDR=$p(InitReportInfo,"^",4)
	.s StoreLoc=##class(web.DHCEQCommon).GetTrakNameByID("dept",StoreLocDR)
	.d OutputGetInitReportInfo
	Quit $$$OK
OutputGetInitReportInfo
	s Data=$lb(ExeDate,result,IsCurMonth,EquipTypes,StoreLoc)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetGetInitReportInfo
	s (InitDepreInfo,result,IsCurMonth,EquipTypeIDS,etlen,EquipTypes,EquipType,StoreLocDR,StoreLoc)=""
	quit
}

ClassMethod GetInitReportInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetInitReportInfoExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 		}
 	Else      {
 		Set Row=^CacheTemp(repid,ind)
 		}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetInitReportInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetInitReportInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// czf 2022-02-10
/// 获取初始化快照操作信息
/// d ##class(%ResultSet).RunQuery("web.DHCEQInit","GetInitSnapInfo")
Query GetInitSnapInfo() As %Query(ROWSPEC = "ExeDate:%String,result:%String")
{
}

ClassMethod GetInitSnapInfoExecute(ByRef qHandle As %Binary) As %Status
{
 	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s Date=""
	f  s Date=$o(^DHCEQInitTemp("InitSnap",Date)) q:Date=""  d
	.d ResetGetInitSnapInfo
	.s ExeDate=$zd($p(Date,",",1),3)_" "_$zt($p(Date,",",2),1)
	.s InitSnapInfo=$g(^DHCEQInitTemp("InitSnap",Date))
	.s result=$p(InitSnapInfo,"^",1)
	.i result="0" s result="执行成功!"
	.e  s result="执行失败!"_result
	.d OutputGetInitSnapInfo
	Quit $$$OK
OutputGetInitSnapInfo
	s Data=$lb(ExeDate,result)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetGetInitSnapInfo
	s (InitSnapInfo,result)=""
	quit
}

ClassMethod GetInitSnapInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetInitSnapInfoExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 		}
 	Else      {
 		Set Row=^CacheTemp(repid,ind)
 		}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetInitSnapInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetInitSnapInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// modified  by ZY0298 2022-03-14
/// 初始化就把周期带入
/// add by ZY0293 2022-02-14
/// 手工折旧月结初始化上期月结周期
/// 入参：MonthStr,会计周期  YYYY-MM
/// 	  StartDate,	初始化会计开始日期（格式为数字）
/// 	  EndDate	初始化会计结束日期（格式为数字）
/// 	  SnapID	对应会计周期的快照ID
/// w ##Class(web.DHCEQInit).InitAccountPeriod("2022-01","66120","66150","7")
ClassMethod InitAccountPeriod(MonthStr, StartDate, EndDate, SnapID)
{
	s Year=$p(MonthStr,"-",1)
	s Month=$p(MonthStr,"-",2)
	s Date=+$H
	&SQL(INSERT INTO SQLUSER.DHC_EQAccountPeriod(AP_Year,AP_Month,AP_StartDate,AP_EndDate,AP_SnapID,AP_Date,AP_ReportStat,AP_DepreStat,AP_Remark,AP_InvalidFlag) values (:Year,:Month,:StartDate,:EndDate,:SnapID,:Date,'0','0','初始记录','N'))
	i SQLCODE q SQLCODE
	s APRowID=$g(%ROWID)
	s flag=0
	//汇总入库信息
	s EquipType=0
	f  s EquipType=$o(^DHCEQInStock(0,"TypeDate",EquipType)) q:EquipType=""||(flag'=0)  d
	.;q:##Class(web.DHCEQCommon).IdInIds(EquipType,EquipTypeIDs)=0
	.s BillDate=0
	.//入账时间可能是在入库之后的跨月,开始日期需要看所有入库单
	.//i AccountShape="1" s BillDate=0
	.f  s BillDate=$o(^DHCEQInStock(0,"TypeDate",EquipType,BillDate)) q:((BillDate="")||(BillDate>EndDate)||(flag'=0))  d
	..s rowid=0
	..f  s rowid=$o(^DHCEQInStock(0,"TypeDate",EquipType,BillDate,rowid)) q:(rowid="")||(flag'=0)  d
	...s ISInvalidFlag=$p($g(^DHCEQInStock(rowid)),"^",25)   //Add By CZF 2016-12-07 begin
	...q:ISInvalidFlag="Y"
	...s ISStatus=$p($g(^DHCEQInStock(rowid)),"^",10)
	...q:ISStatus'=2		//Add By CZF 2016-12-07 end
	...s ISNo=$p($g(^DHCEQInStock(rowid)),"^",14) //2011-07-22 DJ
	...q:ISNo="" //2011-07-22 DJ
	...//增加入账形式的参数，当AccountShape=1的时候只显示已经入账的入库单
	...//q:(AccountShape=1)&&(##Class(web.DHCEQAccountList).AccountFlag(rowid,SourceType,StartDate,EndDate)=0)
	...//modified by ZY0292 2022-01-27
	...s result=0
	...i APRowID'="" s result=##Class(web.DHCEQ.EM.BUSAccountPeriod).SaveDataList(APRowID,"21",rowid)
	...i $p(result,"^",1)'=0 s flag=1
	i flag'=0 q "入库业务对照写入失败."
	
	//汇总减少信息
	s EquipType=0
	f  s EquipType=$o(^DHCEQReturn(0,"TypeDate",EquipType)) q:EquipType=""||(flag'=0)  d
	.;q:##Class(web.DHCEQCommon).IdInIds(EquipType,EquipTypeIDs)=0
	.s OutType=0
	.f  s OutType=$o(^DHCEQReturn(0,"TypeDate",EquipType,OutType)) q:OutType=""||(flag'=0)  d
	..//增加入账形式的参数，退货业务的数据都是没有入账的，都不需要处理
	..//q:(OutType=1)&(AccountShape=1)
	..s OutTypeCode=$p($g(^DHCEQCCode("DHCEQCOutType",OutType)),"^",1)
	..s BillDate=0
	..
	..//入账时间可能是在入库之后的跨月,开始日期需要看所有入库单
	..//i AccountShape="1" s BillDate=0
	..
	..f  s BillDate=$o(^DHCEQReturn(0,"TypeDate",EquipType,OutType,BillDate)) q:((BillDate="")||(BillDate>EndDate))  d
	...s rowid=0
	...f  s rowid=$o(^DHCEQReturn(0,"TypeDate",EquipType,OutType,BillDate,rowid)) q:(rowid="")||(flag'=0)  d
	....s RInvalidFlag=$p($g(^DHCEQReturn(rowid)),"^",28)    //Add By CZF 2016-12-07 begin
	....q:RInvalidFlag="Y"
	....s RStatus=$p($g(^DHCEQReturn(rowid)),"^",13)
	....q:RStatus'=2		//Add By CZF 2016-12-07 end
	....//增加入账形式的参数，当AccountShape=1的时候只显示已经入账的入库单,同时减少类型不是退货的时候
	....//q:(AccountShape=1)&&(##Class(web.DHCEQAccountList).AccountFlag(rowid,SourceType,StartDate,EndDate)=0)
	...//modified by ZY0292 2022-01-27
	....s result=0
	....i APRowID'="" s result=##Class(web.DHCEQ.EM.BUSAccountPeriod).SaveDataList(APRowID,"23",rowid)
	....i $p(result,"^",1)'=0 s flag=1
	i flag'=0 q "退货业务对照写入失败."
	
	
	//汇总转移信息
	s EquipType=0
	f  s EquipType=$o(^DHCEQStoreMove(0,"TypeDate",EquipType)) q:EquipType=""||(flag'=0)  d
	.;q:##Class(web.DHCEQCommon).IdInIds(EquipType,EquipTypeIDs)=0
	.s BillDate=0
	.//入账时间可能是在入库之后的跨月,开始日期需要看所有入库单
	.//i AccountShape="1" s BillDate=0
	.f  s BillDate=$o(^DHCEQStoreMove(0,"TypeDate",EquipType,BillDate)) q:((BillDate="")||(BillDate>EndDate)||(flag'=0))  d
	..s rowid=0
	..f  s rowid=$o(^DHCEQStoreMove(0,"TypeDate",EquipType,BillDate,rowid)) q:(rowid="")||(flag'=0)  d
	...s SMInvalidFlag=$p($g(^DHCEQStoreMove(rowid)),"^",27)    //Add By CZF 2016-12-07 begin
	...q:SMInvalidFlag="Y"
	...s SMStatus=$p($g(^DHCEQStoreMove(rowid)),"^",13)
	...q:SMStatus'=2		//Add By CZF 2016-12-07 end
	...//增加入账形式的参数，当AccountShape=1的时候只显示已经入账的转移单
	...//q:(AccountShape=1)&&(##Class(web.DHCEQAccountList).AccountFlag(rowid,SourceType,StartDate,EndDate)=0)
	...//modified by ZY0292 2022-01-27
	...s result=0
	...i APRowID'="" s result=##Class(web.DHCEQ.EM.BUSAccountPeriod).SaveDataList(APRowID,"22",rowid)
	...q:$p(result,"^",1)'=0
	i flag'=0 q "转移业务对照写入失败."
	
	//汇总当期原值变动信息
	s EquipType=0
	f  s EquipType=$o(^DHCEQChangeAccount(0,"TypeDate",EquipType)) q:EquipType=""||(flag'=0)  d
	.;q:##Class(web.DHCEQCommon).IdInIds(EquipType,EquipTypeIDs)=0
	.s BillDate=0
	.f  s BillDate=$o(^DHCEQChangeAccount(0,"TypeDate",EquipType,BillDate)) q:((BillDate="")||(BillDate>EndDate)||(flag'=0))  d
	..s rowid=0
	..f  s rowid=$o(^DHCEQChangeAccount(0,"TypeDate",EquipType,BillDate,rowid)) q:((rowid="")||(flag'=0))  d
	...s CAStatus=$p($g(^DHCEQChangeAccount(rowid)),"^",11)    //Add By CZF 2016-12-07
	...q:CAStatus'=2
	...s EquipID=$p($g(^DHCEQChangeAccount(rowid)),"^",1)
	...q:$Piece($Get(^DHCEQEquip(EquipID,"OtherInfo")),"^",26)'=""	// Mozy0217  2018-11-01	过滤设备配置的调账	//modified by lmm 2020-12-30
	...//modified by ZY0292 2022-01-27
	...s result=0
	...i APRowID'="" s result=##Class(web.DHCEQ.EM.BUSAccountPeriod).SaveDataList(APRowID,"52",rowid)
	...i $p(result,"^",1)'=0 s flag=1
	i flag'=0 q "调账业务对照写入失败."
	
	
	//汇总当期设备报废信息
	s EquipType=0
	f  s EquipType=$o(^DHCEQDisuseRequest(0,"TypeDate",EquipType)) q:EquipType=""||(flag'=0)  d
	.;q:##Class(web.DHCEQCommon).IdInIds(EquipType,EquipTypeIDs)=0
	.s BillDate=0
	.f  s BillDate=$o(^DHCEQDisuseRequest(0,"TypeDate",EquipType,BillDate)) q:((BillDate="")||(BillDate>EndDate)||(flag'=0))  d
	..s rowid=0
	..f  s rowid=$o(^DHCEQDisuseRequest(0,"TypeDate",EquipType,BillDate,rowid)) q:((rowid="")||(flag'=0))  d
	...s DRInvalidFlag=$p($g(^DHCEQDisuseRequest(rowid)),"^",53)    //Add By CZF 2016-12-07 begin
	...q:DRInvalidFlag="Y"
	...s DRStatus=$p($g(^DHCEQDisuseRequest(rowid)),"^",10)
	...q:DRStatus'=2			//Add By CZF 2016-12-07 end
	...;Modified By JDL 2011-9-16 JDL0096
	...q:$p($g(^DHCEQDisuseRequest(rowid)),"^",10)'=2
	...s ListRowID=0
	...;Modified by JDL 2012-3-27 JDL0127 改用库房而非申请科室
	...s StoreLoc=$p($g(^DHCEQDisuseRequest(rowid)),"^",34)
	...f  s ListRowID=$o(^DHCEQDisuseRequestList(0,"DisuseRequest",rowid,ListRowID)) q:(ListRowID="")||(flag'=0)  d
	....s EquipID=$p($g(^DHCEQDisuseRequestList(ListRowID)),"^",2)
	....q:$Piece($Get(^DHCEQEquip(EquipID,"OtherInfo")),"^",26)'=""	// Mozy0217  2018-11-01	过滤设备配置的报废 //modified by lmm 2020-12-30
	....//modified by ZY0292 2022-01-27
	....s result=0
	....i APRowID'="" s result=##Class(web.DHCEQ.EM.BUSAccountPeriod).SaveDataList(APRowID,"34",rowid)
	....i $p(result,"^",1)'=0 s flag=1
	i flag'=0 q "报废业务对照写入失败."
	
	;Add by JDL 2011-6-22 JDL0086
	;汇总处理其他调整的数据,只取影响报表数据的
	s BillDate=StartDate-1	
	f  s BillDate=$o(^DHCEQAdjustData(0,"FlagDate","Y",BillDate)) q:((BillDate="")||(BillDate>EndDate)||(flag'=0))  d
	.s AdjustType=0
	.f  s AdjustType=$o(^DHCEQAdjustData(0,"FlagDate","Y",BillDate,AdjustType)) q:((AdjustType="")||(flag'=0))  d
	..s rowid=0
	..f  s rowid=$o(^DHCEQAdjustData(0,"FlagDate","Y",BillDate,AdjustType,rowid)) q:((rowid="")||(flag'=0))  d
	...s ADStatus=$p($g(^DHCEQAdjustData(rowid)),"^",11) /// add by zy 2011-09-25 ZY0080
	...quit:ADStatus'="1"
	...//modified by ZY0292 2022-01-27
	...s result=0
	...i APRowID'="" s result=##Class(web.DHCEQ.EM.BUSAccountPeriod).SaveDataList(APRowID,"99",rowid)
	...i $p(result,"^",1)'=0 s flag=1
	i flag'=0 q "数据调整记录业务对照写入失败."
	
	q flag
}

}
