Class web.DHCEQ.Tools.DataUpgrade Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

///  DHCEQCostAllot,DHCEQMessages 表的数据要从新处理
/// 如果索引字段有空，生成索引会出错:
/// w ##Class(web.DHCEQ.Tools.DataUpgrade).DHCEQUser()
ClassMethod DHCEQUser()
{
	d ##class(User.DHCEQAInStockList).%BuildIndices()
	d ##class(User.DHCEQAdjustDataList).%BuildIndices()
	
	&sql(update SQLUSER.DHC_EQApproveInfo set AI_Hold5='1')
	&sql(update SQLUSER.DHC_EQApproveInfo set AI_Hold5=null)
	d ##class(User.DHCEQApproveInfo).%BuildIndices()
	
	
	&sql(update SQLUSER.DHC_EQCApproveFlow set AF_Hold4='1')
	&sql(update SQLUSER.DHC_EQCApproveFlow set AF_Hold4=null)
	d ##class(User.DHCEQCApproveFlow).%BuildIndices()
	
	&sql(update SQLUSER.DHC_EQCApproveSet set AS_HospDR='1')
	&sql(update SQLUSER.DHC_EQCApproveSet set AS_HospDR=null)
	
	&sql(update SQLUSER.DHC_EQCConsumableItem set CI_RegistrationNo='1')
	&sql(update SQLUSER.DHC_EQCConsumableItem set CI_RegistrationNo=null)
	
	&sql(update SQLUSER.DHC_EQCEquipeCat set EC_Hold6='1')
	&sql(update SQLUSER.DHC_EQCEquipeCat set EC_Hold6=null)
	k ^DHCEQCCode("DHCEQCEquipeCat",0,"ExCode")
	d ##class(User.DHCEQCEquipeCat).%BuildIndices()
	
	&sql(update SQLUSER.DHC_EQCEvaluateType set ET_Hold5='1')
	&sql(update SQLUSER.DHC_EQCEvaluateType set ET_Hold5=null)
	
	&sql(update SQLUSER.DHC_EQCLocType set LT_Hold5='1')
	&sql(update SQLUSER.DHC_EQCLocType set LT_Hold5=null)
	
	&sql(update SQLUSER.DHC_EQCMaintItem set MI_Hold8='1')
	&sql(update SQLUSER.DHC_EQCMaintItem set MI_Hold8=null)
	
	&sql(update SQLUSER.DHC_EQCOrigin set O_EquipFlag='Y')
	&sql(update SQLUSER.DHC_EQCOrigin set O_EquipFlag=null)
	
	&sql(update SQLUSER.DHC_EQCPicSourceType set PST_Hold5='1')
	&sql(update SQLUSER.DHC_EQCPicSourceType set PST_Hold5=null)
	
	&sql(update SQLUSER.DHC_EQCServiceItem set SI_SingleFlag='Y')
	&sql(update SQLUSER.DHC_EQCServiceItem set SI_SingleFlag=null)
	
	&sql(update SQLUSER.DHC_EQCSysSet set SS_HospDR='Y')
	&sql(update SQLUSER.DHC_EQCSysSet set SS_HospDR=null)
	
	&sql(update SQLUSER.DHC_EQDisuseRequest set DR_MergeOrderFlag='Y')
	&sql(update SQLUSER.DHC_EQDisuseRequest set DR_MergeOrderFlag=null)
	
	//d ##class(User.DHCEQCostAllot).%BuildIndices()
	
	&sql(update SQLUSER.DHC_EQEquip set EQ_Hold15='1')
	&sql(update SQLUSER.DHC_EQEquip set EQ_Hold15=null)
	d ##class(User.DHCEQEquip).%BuildIndices()
	
	&sql(update SQLUSER.DHC_EQInventory set I_Hold10='1')
	&sql(update SQLUSER.DHC_EQInventory set I_Hold10=null)
	
	
	d ##class(User.DHCEQFunds).%BuildIndices()
	
	&sql(update SQLUSER.DHC_EQMMaintRequest set MR_DisuesdFlag='1')
	&sql(update SQLUSER.DHC_EQMMaintRequest set MR_DisuesdFlag=null)
	d ##class(User.DHCEQMMaintRequest).%BuildIndices()
	
	d ##class(User.DHCEQMaint).%BuildIndices()
	
	&sql(update SQLUSER.DHC_EQMaintPlan set MP_PlanNo='0')
	&sql(update SQLUSER.DHC_EQMaintPlan set MP_PlanNo=null)
	
	k ^DHCEQMessages(0,"BussID")
	k ^DHCEQMessages(0,"Status")
	d ##class(User.DHCEQMessages).%BuildIndices()
	
	&sql(update SQLUSER.DHC_EQMonthReportList set MRL_ReportType='0')
	d ##class(User.DHCEQMonthReportList).%BuildIndices()
	
	&sql(update SQLUSER.DHC_EQOpenCheckList set OCL_SourceType='0')	
	&sql(update SQLUSER.DHC_EQOpenCheckList set OCL_IsInstall='0')
	&sql(update SQLUSER.DHC_EQOpenCheckList set OCL_IsInstall=null)
	
	&sql(update SQLUSER.DHC_EQUseRecord set UR_Hold5='0')
	&sql(update SQLUSER.DHC_EQUseRecord set UR_Hold5=null)
	d ##class(User.DHCEQUseRecord).%BuildIndices()
	
	&sql(update SQLUSER.DHC_EQUseRecordStat set URS_TWorkLoadNum='0')
	&sql(update SQLUSER.DHC_EQUseRecordStat set URS_TWorkLoadNum=null)
	d ##class(User.DHCEQUseRecordStat).%BuildIndices()
	q "ok"
}

/// w ##Class(web.DHCEQ.Tools.DataUpgrade).AppendDHCEQCSysSet()
ClassMethod AppendDHCEQCSysSet()
{
	s (SQLCODE,total)=0
	s LCode=0
	f  s LCode=$o(^DHCEQCCodeStand("DHCEQCSysSet",0,"Code",LCode))  quit:LCode=""||SQLCODE'=0  d
	.q:$Data(^DHCEQCCode("DHCEQCSysSet",0,"Code",LCode))>0
	.s rowid=$o(^DHCEQCCodeStand("DHCEQCSysSet",0,"Code",LCode,0))
	.k PLIST
	.s PLIST(2)=LCode
	.s PLIST(3)=$p($g(^DHCEQCCodeStand("DHCEQCSysSet",rowid)),"^",2) //值
	.s PLIST(4)=$p($g(^DHCEQCCodeStand("DHCEQCSysSet",rowid)),"^",3) //描述
	.s PLIST(5)=$p($g(^DHCEQCCodeStand("DHCEQCSysSet",rowid)),"^",4) //备注
	.s PLIST(6)=$p($g(^DHCEQCCodeStand("DHCEQCSysSet",rowid)),"^",5)
	.s PLIST(7)=$p($g(^DHCEQCCodeStand("DHCEQCSysSet",rowid)),"^",6)
	.s PLIST(8)=$p($g(^DHCEQCCodeStand("DHCEQCSysSet",rowid)),"^",7)
	.s PLIST(9)=$p($g(^DHCEQCCodeStand("DHCEQCSysSet",rowid)),"^",8)
	.s PLIST(10)=$p($g(^DHCEQCCodeStand("DHCEQCSysSet",rowid)),"^",9)
	.&SQL(insert into SQLUser.DHC_EQCSysSet Values :PLIST())
	.s total=total+1
	q "增加"_total_"条记录!"
}

/// w ##Class(web.DHCEQ.Tools.DataUpgrade).UpdateDHCEQCCode()
ClassMethod UpdateDHCEQCCode()
{
	m ^DHCEQCCodeTable=^DHCEQCCodeTableStand
	m ^DHCEQCCode("DHCEQCCounterType")=^DHCEQCCodeStand("DHCEQCCounterType")
	
	m ^DHCEQCCode("DHCEQCApproveType")=^DHCEQCCodeStand("DHCEQCApproveType")
	m ^DHCEQCCode("DHCEQCApproveSet")=^DHCEQCCodeStand("DHCEQCApproveSet")
	m ^DHCEQCCode("DHCEQCAction")=^DHCEQCCodeStand("DHCEQCAction")
	m ^DHCEQCCode("DHCEQCEmployeeType")=^DHCEQCCodeStand("DHCEQCEmployeeType")
	M ^DHCEQCCode("DHCEQCComponent")=^DHCEQCCodeStand("DHCEQCComponent")
	M ^DHCEQCCode("DHCEQCComponentItem")=^DHCEQCCodeStand("DHCEQCComponentItem")
	M ^DHCEQCCode("DHCEQCComponentSet")=^DHCEQCCodeStand("DHCEQCComponentSet")
	M ^DHCEQCCode("DHCEQCComponentSetItem")=^DHCEQCCodeStand("DHCEQCComponentSetItem")
	m ^DHCEQCCode("DHCEQCComponentZone")=^DHCEQCCodeStand("DHCEQCComponentZone")
	m ^DHCEQCCode("^DHCEQCTableData")=^DHCEQCCodeStand("DHCEQCTableData")
	m ^DHCEQCCode("^DHCEQCColumns")=^DHCEQCCodeStand("^DHCEQCColumns")
	m ^DHCEQCCode("DHCEQCTypeDefine")=^DHCEQCCodeStand("DHCEQCTypeDefine")
	m ^DHCEQCCode("DHCEQCEquipAttribute")=^DHCEQCCodeStand("DHCEQCEquipAttribute")
	m ^DHCEQCCode("DHCEQCBussType")=^DHCEQCCodeStand("DHCEQCBussType")
	m ^DHCEQCCode("DHCEQCBarDetail")=^DHCEQCCodeStand("DHCEQCBarDetail")
	m ^DHCEQCCode("DHCEQCBarDetailKey")=^DHCEQCCodeStand("DHCEQCBarDetailKey")
	m ^DHCEQCCode("DHCEQCBarInfo")=^DHCEQCCodeStand("DHCEQCBarInfo")
	m ^DHCEQCCode("DHCEQCBarSet")=^DHCEQCCodeStand("DHCEQCBarSet")
	m ^DHCEQCCode("DHCEQCPicType")=^DHCEQCCodeStand("DHCEQCPicType")
	m ^DHCEQCCode("DHCEQCPicSourceType")=^DHCEQCCodeStand("DHCEQCPicSourceType")
	
	m ^DHCEQCCode("DHCEQCChartsColorScheme")=^DHCEQCCodeStand("DHCEQCChartsColorScheme")
	m ^DHCEQCCode("DHCEQCChartsDefine")=^DHCEQCCodeStand("DHCEQCChartsDefine")
	m ^DHCEQCCode("DHCEQCElement")=^DHCEQCCodeStand("DHCEQCElement")
	m ^DHCEQCCode("DHCEQCElementCat")=^DHCEQCCodeStand("DHCEQCElementCat")
	m ^DHCEQCCode("DHCEQCElementGroup")=^DHCEQCCodeStand("DHCEQCElementGroup")
	m ^DHCEQCCode("DHCEQCElementValues")=^DHCEQCCodeStand("DHCEQCElementValues")
	m ^DHCEQCCode("DHCEQCFeeMode")=^DHCEQCCodeStand("DHCEQCFeeMode")
	m ^DHCEQCCode("DHCEQCIFBMode")=^DHCEQCCodeStand("DHCEQCIFBMode")
	m ^DHCEQCCode("DHCEQCMaintItemCat")=^DHCEQCCodeStand("DHCEQCMaintItemCat")
	m ^DHCEQCCode("DHCEQCPDABroadcast")=^DHCEQCCodeStand("DHCEQCPDABroadcast")
	m ^DHCEQCCode("DHCEQCPMTemplate")=^DHCEQCCodeStand("DHCEQCPMTemplate")
	m ^DHCEQCCode("DHCEQCPMTemplateList")=^DHCEQCCodeStand("DHCEQCPMTemplateList")
	m ^DHCEQCCode("DHCEQCPayCostType")=^DHCEQCCodeStand("DHCEQCPayCostType")
	m ^DHCEQCCode("DHCEQCPayMode")=^DHCEQCCodeStand("DHCEQCPayMode")
	m ^DHCEQCCode("DHCEQCPromptInfo")=^DHCEQCCodeStand("DHCEQCPromptInfo")
	m ^DHCEQCCode("DHCEQCTemplate")=^DHCEQCCodeStand("DHCEQCTemplate")
	m ^DHCEQCCode("DHCEQCTemplateList")=^DHCEQCCodeStand("DHCEQCTemplateList")
	m ^DHCEQCCode("DHCEQCTypeDefine")=^DHCEQCCodeStand("DHCEQCTypeDefine")
	m ^DHCEQCCode("DHCEQETNotAccessSC")=^DHCEQCCodeStand("DHCEQETNotAccessSC")
	m ^DHCEQCCode("DHCEQMCMaintItemNormalValues")=^DHCEQCCodeStand("DHCEQMCMaintItemNormalValues")
	m ^DHCEQCCode("DHCEQMCMaintItemValues")=^DHCEQCCodeStand("DHCEQMCMaintItemValues")
	m ^DHCEQCCode("DHCEQPCNoticeCat")=^DHCEQCCodeStand("DHCEQPCNoticeCat")
	m ^DHCEQCCode("DHCEQCRoleBuss")=^DHCEQCCodeStand("DHCEQCRoleBuss")
	
	&sql(update SQLUSER.DHC_EQCSysSet set SS_Value='0,1,3,4' where SS_Code='201001')
	&SQL(update SQLUser.DHC_EQPicture set PT_PicTypeDR=7 where PT_PicTypeDR=2)	
	
	&SQL(INSERT INTO SQLUser.DHC_EQCCounter (CNT_CounterNum,CNT_TypeDR,CNT_Length,CNT_Prefix,CNT_GroupFlag,CNT_Group) VALUES (0,25,4,'PS[Month]','Y','PS[Month]'))
	&SQL(INSERT INTO SQLUser.DHC_EQCCounter (CNT_CounterNum,CNT_TypeDR,CNT_Length,CNT_Prefix,CNT_GroupFlag,CNT_Group) VALUES (0,26,4,'[Date]','N',''))
	&SQL(INSERT INTO SQLUser.DHC_EQCCounter (CNT_CounterNum,CNT_TypeDR,CNT_Length,CNT_Prefix,CNT_GroupFlag,CNT_Group) VALUES (0,27,4,'HZ[Month]','Y','HZ[Month]'))
	&SQL(INSERT INTO SQLUser.DHC_EQCCounter (CNT_CounterNum,CNT_TypeDR,CNT_Length,CNT_Prefix,CNT_GroupFlag,CNT_Group) VALUES (0,28,4,'WH[Month]','Y','WH[Month]'))
	&SQL(INSERT INTO SQLUser.DHC_EQCCounter (CNT_CounterNum,CNT_TypeDR,CNT_Length,CNT_Prefix,CNT_GroupFlag,CNT_Group) VALUES (0,29,4,'PE[Month]','Y','PE[Month]'))
	&SQL(INSERT INTO SQLUser.DHC_EQCCounter (CNT_CounterNum,CNT_TypeDR,CNT_Length,CNT_Prefix,CNT_GroupFlag,CNT_Group) VALUES (0,30,4,'JD[Month]','Y','JD[Month]'))
	&SQL(INSERT INTO SQLUser.DHC_EQCCounter (CNT_CounterNum,CNT_TypeDR,CNT_Length,CNT_Prefix,CNT_GroupFlag,CNT_Group) VALUES (0,31,4,'[Month]','Y','[Month]'))
	&SQL(INSERT INTO SQLUser.DHC_EQCCounter (CNT_CounterNum,CNT_TypeDR,CNT_Length,CNT_Prefix,CNT_GroupFlag,CNT_Group) VALUES (0,32,4,'[Month]','Y','[Month]'))
	&SQL(INSERT INTO SQLUser.DHC_EQCCounter (CNT_CounterNum,CNT_TypeDR,CNT_Length,CNT_Prefix,CNT_GroupFlag,CNT_Group) VALUES (0,33,6,'','N',''))
	&SQL(INSERT INTO SQLUser.DHC_EQCCounter (CNT_CounterNum,CNT_TypeDR,CNT_Length,CNT_Prefix,CNT_GroupFlag,CNT_Group) VALUES (0,34,4,'S[Month]','Y','S[Month]'))
	&SQL(INSERT INTO SQLUser.DHC_EQCCounter (CNT_CounterNum,CNT_TypeDR,CNT_Length,CNT_Prefix,CNT_GroupFlag,CNT_Group) VALUES (0,35,4,'{EQNo}','Y','{EQNo}'))
	
	&SQL(INSERT INTO SQLUser.DHC_EQCApproveRole (AR_Code,AR_Desc,AR_InvalidFlag) VALUES (22,'配送员','N'))
	&SQL(INSERT INTO SQLUser.DHC_EQCApproveRole (AR_Code,AR_Desc,AR_InvalidFlag) VALUES (23,'租赁员','N'))
	&SQL(INSERT INTO SQLUser.DHC_EQCApproveRole (AR_Code,AR_Desc,AR_InvalidFlag) VALUES (24,'科室管理员','N'))
	&SQL(INSERT INTO SQLUser.DHC_EQCApproveRole (AR_Code,AR_Desc,AR_InvalidFlag) VALUES (25,'资质管理员','N'))
	
	q "更新完成"
	
	//设置安全组可访问图片类型、角色、属性
	//转移明细查询界面没有出来
	//维修明细查询界面有问题 数据中有EquipType为空的数据 query增加了Q过滤
	//Messages表的数据处理
	//&SQL(SELECT * FROM SQLUser.DHC_EQApproveInfo WHERE AI_ApproveTypeDR=14 AND AI_Hold5> 21)

	&SQL(UPDATE SQLUser.DHC_EQApproveInfo SET AI_Hold5=AI_ApproveRoleDR  WHERE AI_ApproveTypeDR=14 AND AI_ApproveRoleDR> 21)
	&SQL(UPDATE SQLUser.DHC_EQApproveInfo SET AI_ApproveRoleDR=NULL  WHERE AI_ApproveTypeDR=14 AND AI_Hold5> 21)
	
	
	;m ^DHCEQTemp("DHCEQCColSet")=^DHCEQCCode("DHCEQCColSet")
	;k ^DHCEQCCode("DHCEQCColSet")
	;m ^DHCEQCCode("DHCEQCApproveFlowAllow")=^DHCEQCCodeStand("DHCEQCApproveFlowAllow")
	;m ^DHCEQCCode("DHCEQCApproveAction")=^DHCEQCCodeStand("DHCEQCApproveAction")
}

/// w ##Class(web.DHCEQ.Tools.DataUpgrade).InsertDHCEQCFirmContrast()
ClassMethod InsertDHCEQCFirmContrast()
{
	s SQLCODE=0
	s FirmType=2
	s rowid=0
	f  s rowid=$Order(^DHCEQCCode("DHCEQCVendor",rowid))  q:rowid=""||SQLCODE'=0  Do
	.&SQL(Insert Into SQLUSER.DHC_EQCFirmContrast(FC_FirmType,FC_FirmDR,FC_InvalidFlag) Values (:FirmType,:rowid,'N'))
	.
	q SQLCODE
}

/// w ##Class(web.DHCEQ.Tools.DataUpgrade).UpdateDHCEQCManu()
ClassMethod UpdateDHCEQCManu()
{
	s rowid=0
	f  s rowid=$Order(^DHCEQOpenCheckList(rowid))  q:rowid=""  Do
	.s TManuFactoryDR=$p($g(^DHCEQOpenCheckList(rowid)),"^",15)
	.q:TManuFactoryDR=""
	.s NewRowID=##Class(web.DHCEQ.Tools.DataUpgrade).UpdateDHCEQCVendor(3,TManuFactoryDR)
	.i NewRowID>0 &SQL(update SQLUSER.DHC_EQOpenCheckList set OCL_ManuFactoryDR=:NewRowID where OCL_RowID=:rowid)
	w "DHC_EQOpenCheckList更新完成",!
	
	s rowid=0
	f  s rowid=$Order(^DHCEQInStockList(rowid))  q:rowid=""  Do
	.s TManuFactoryDR=$p($g(^DHCEQInStockList(rowid)),"^",6)
	.q:TManuFactoryDR=""
	.s NewRowID=##Class(web.DHCEQ.Tools.DataUpgrade).UpdateDHCEQCVendor(3,TManuFactoryDR)
	.i NewRowID>0 &SQL(update SQLUSER.DHC_EQInStockList set ISL_ManuFactoryDR=:NewRowID where ISL_RowID=:rowid)
	w "DHC_EQInStockList更新完成",!
	
	s rowid=0
	f  s rowid=$Order(^DHCEQStoreMoveList(rowid))  q:rowid=""  Do
	.s TManuFactoryDR=$p($g(^DHCEQStoreMoveList(rowid)),"^",6)
	.q:TManuFactoryDR=""
	.s NewRowID=##Class(web.DHCEQ.Tools.DataUpgrade).UpdateDHCEQCVendor(3,TManuFactoryDR)
	.i NewRowID>0 &SQL(update SQLUSER.DHC_EQStoreMoveList set SML_ManuFactoryDR=:NewRowID where SML_RowID=:rowid)
	w "DHC_EQStoreMoveList更新完成",!
	
	s rowid=0
	f  s rowid=$Order(^DHCEQEquip(rowid))  q:rowid=""  Do
	.s TManuFactoryDR=$p($g(^DHCEQEquip(rowid)),"^",26)
	.q:TManuFactoryDR=""
	.s NewRowID=##Class(web.DHCEQ.Tools.DataUpgrade).UpdateDHCEQCVendor(3,TManuFactoryDR)
	.i NewRowID>0 &SQL(update SQLUSER.DHC_EQEquip set EQ_ManuFactoryDR=:NewRowID where EQ_RowID=:rowid)
	w "DHC_EQEquip更新完成",!
	q "OK"
}

/// w ##Class(web.DHCEQ.Tools.DataUpgrade).UpdateDHCEQCVendor(3,1)
ClassMethod UpdateDHCEQCVendor(FirmType, SourceID)
{
	s SQLCODE=0
	i FirmType=3
	{
		s desc=$p($g(^DHCEQCCode("DHCEQCManufacturer",SourceID)),"^",1)
		s code=$p($g(^DHCEQCCode("DHCEQCManufacturer",SourceID)),"^",2)
	}
	elseif FirmType=4
	{
		s desc=$p($g(^DHCEQCCode("DHCEQCCService",SourceID)),"^",1)
		s code=$p($g(^DHCEQCCode("DHCEQCCService",SourceID)),"^",2)
	}
	i desc="" q ""
	s tmpid=""
 	&SQL(Select v_rowid into :tmpid from SQLUSER.DHC_EQCVendor where v_name=:desc and v_invalidflag='N')		//modified by CZF0105 begin
 	i tmpid'=""
	{
		s fctmpid=""
		&SQL(Select FC_rowid into :fctmpid from SQLUSER.DHC_EQCFirmContrast where fc_firmdr=:tmpid and fc_firmtype=:FirmType)
		i fctmpid'="" q tmpid
	}
		TStart
		k PLIST
		s PLIST(2) = code
	  	s PLIST(3) = desc
		s PLIST(12) = desc
		s PLIST(20) = "N"
		s PLIST(23) = FirmType
		
		if tmpid=""
		{
			&SQL(Insert Into SQLUSER.DHC_EQCVendor Values :PLIST())
		}
		else
		{
			s VHold3=$p($g(^DHCEQCCode("DHCEQCVendor",tmpid)),"^",22)
			i VHold3="" s PLIST(23)=FirmType
			e  s PLIST(23)=VHold3_","_FirmType
			&SQL(update SQLUSER.DHC_EQCVendor Values :PLIST() where V_RowID=:tmpid)
		}
		if SQLCODE
		{
			TRollBack
			q "插入DHC_EQCVendor失败: Code="_code_" Desc="_desc_" SQLCODE="_SQLCODE
		}
		s VRowID=$g(%ROWID)
		
		&SQL(Insert Into SQLUSER.DHC_EQCFirmContrast(FC_FirmType,FC_FirmDR,FC_InvalidFlag) Values (:FirmType,:VRowID,'N'))
		if SQLCODE
		{
			TRollBack
			q "插入DHC_EQCFirmContrast失败: Code="_code_" Desc="_desc_" SQLCODE="_SQLCODE
		}
		TCommit
		q VRowID
}

/// Add By DJ 2017-09-14
/// 描述:旧版DHCEQChangeInfo表记录生成DHCEQLifeInfo
/// Modified By QW 2018-04-27 
/// 增加报废记录生成。 根据ChangeType区分:05-调账,06-报废(旧系统只记录了调账和报废)
/// End By QW 2018-04-27 
/// w ##Class(web.DHCEQ.Tools.DataUpgrade).CreateLifeInfoByChangeInfo()
ClassMethod CreateLifeInfoByChangeInfo()
{
	TSTART
	s SQLCODE=0
	s CIRowID=0
	f  s CIRowID=$o(^DHCEQChangeInfo(CIRowID))  q:(CIRowID="")||(SQLCODE'=0)  d
	.s CARowID=$p($g(^DHCEQChangeInfo(CIRowID)),"^",6)	//DHCEQChangeAccount表对应sourceid
	.s ChangeType=$p($g(^DHCEQChangeInfo(CIRowID)),"^",3)
	.k LI
	.i ChangeType="5"  d  //调账
 	..s LI(2)=$p($g(^DHCEQChangeInfo(CIRowID)),"^",1)  //设备
	..s LI(4)=$p($g(^DHCEQChangeAccount(CARowID)),"^",29)   //原使用科室
	..s LI(5)=$p($g(^DHCEQChangeAccount(CARowID)),"^",29) //原管理科室
	..s LI(6)=$p($g(^DHCEQChangeAccount(CARowID)),"^",28)  //原库房
	..s LI(7)=$p($g(^DHCEQChangeAccount(CARowID)),"^",24)  //原值
	..s LI(8)=$p($g(^DHCEQChangeAccount(CARowID)),"^",25)  //原净值
	..s LI(14)=$p($g(^DHCEQChangeAccount(CARowID)),"^",8)  //变动原因
	..s LI(15)=$p($g(^DHCEQChangeAccount(CARowID)),"^",6)  //变动描述
	..s LI(16)=$p($g(^DHCEQChangeAccount(CARowID)),"^",13)	//变动日期
	..s LI(17)=$p($g(^DHCEQChangeAccount(CARowID)),"^",14)	//变动时间
	..s LI(19)="C"	//生命周期类型
	..s LI(20)=51	//来源类型
	..s LI(21)=CARowID	//来源ID
	..s LI(23)=$p($g(^DHCEQChangeAccount(CARowID)),"^",10)  //备注
	..s LI(27)=$p($g(^DHCEQChangeAccount(CARowID)),"^",21)	//更新人
	..s LI(28)=$p($g(^DHCEQChangeAccount(CARowID)),"^",22)	//更新日期
	..s LI(29)=$p($g(^DHCEQChangeAccount(CARowID)),"^",23)	//更新时间
	..s LI(9)=$p($g(^DHCEQChangeAccount(CARowID)),"^",29)   //变动后使用科室
	..s LI(10)=$p($g(^DHCEQChangeAccount(CARowID)),"^",29) //变动后管理科室
	..s LI(11)=$p($g(^DHCEQChangeAccount(CARowID)),"^",28)  //变动后库房
	..s LI(12)=$p($g(^DHCEQChangeAccount(CARowID)),"^",3)  //变动后原值
	..s LI(13)=$p($g(^DHCEQChangeAccount(CARowID)),"^",4)  //变动后净值
	..&sql(Insert Into SQLUSER.DHC_EQLifeInfo Values :LI())
	.;Modified By QW 2018-04-27 增加报废记录生成
	.i ChangeType="6"  d //报废
	..s DisuseType=$p($g(^DHCEQDisuseRequest(CARowID)),"^",6) //报废类型
	..i DisuseType'="" s LI(14)=$p($g(^DHCEQCCode("DHCEQCDisuseType",DisuseType)),"^",2)  //变动原因
	..s LI(15)=$p($g(^DHCEQDisuseRequest(CARowID)),"^",7)  //变动描述
	..s LI(16)=$p($g(^DHCEQDisuseRequest(CARowID)),"^",8)	//变动日期
	..s LI(19)="C"	//生命周期类型
	..s LI(20)=34	//来源类型
	..s LI(21)=CARowID	//来源ID - mainid
	..s LI(27)=$p($g(^DHCEQDisuseRequest(CARowID)),"^",20)	//更新人
	..s LI(28)=$p($g(^DHCEQDisuseRequest(CARowID)),"^",21)	//更新日期
	..s LI(29)=$p($g(^DHCEQDisuseRequest(CARowID)),"^",22)	//更新时间
	..s EquipDR=$p($g(^DHCEQChangeInfo(CIRowID)),"^",1)  //设备
	..if EquipDR'="" d
	...s LI(2)=EquipDR
	...s LI(4)=$p($g(^DHCEQEquip(EquipDR)),"^",19)   //原使用科室
	...s LI(5)=$p($g(^DHCEQEquip(EquipDR)),"^",17) //原管理科室
	...s LI(6)=$p($g(^DHCEQEquip(EquipDR)),"^",67)  //原库房
	...s LI(7)=$p($g(^DHCEQEquip(EquipDR)),"^",27)  //原值
	...s LI(8)=$p($g(^DHCEQEquip(EquipDR)),"^",28)  //原净值
	...s LI(9)=$p($g(^DHCEQEquip(EquipDR)),"^",19)   //变动后使用科室
	...s LI(10)=$p($g(^DHCEQEquip(EquipDR)),"^",17) //变动后管理科室
	...s LI(11)=$p($g(^DHCEQEquip(EquipDR)),"^",67)  //变动后库房
	...s LI(12)=$p($g(^DHCEQEquip(EquipDR)),"^",27)  //变动后原值
	...s LI(13)=$p($g(^DHCEQEquip(EquipDR)),"^",28)  //变动后净值
	...&sql(Insert Into SQLUSER.DHC_EQLifeInfo Values :LI())
	..e  d
	...s DRLRowID=0
	...f  s DRLRowID=$o(^DHCEQDisuseRequestList(0,"DisuseRequest",CARowID,DRLRowID)) q:(DRLRowID="")||(SQLCODE'=0)  d
	....s EquipID=$p($g(^DHCEQDisuseRequestList(DRLRowID)),"^",2)
	....q:EquipID=""
	....s LI(2)=EquipID
	....s LI(4)=$p($g(^DHCEQEquip(EquipID)),"^",19)   //原使用科室
	....s LI(5)=$p($g(^DHCEQEquip(EquipID)),"^",17) //原管理科室
	....s LI(6)=$p($g(^DHCEQEquip(EquipID)),"^",67)  //原库房
	....s LI(7)=$p($g(^DHCEQEquip(EquipID)),"^",27)  //原值
	....s LI(8)=$p($g(^DHCEQEquip(EquipID)),"^",28)  //原净值
	....s LI(9)=$p($g(^DHCEQEquip(EquipID)),"^",19)   //变动后使用科室
	....s LI(10)=$p($g(^DHCEQEquip(EquipID)),"^",17) //变动后管理科室
	....s LI(11)=$p($g(^DHCEQEquip(EquipID)),"^",67)  //变动后库房
	....s LI(12)=$p($g(^DHCEQEquip(EquipID)),"^",27)  //变动后原值
	....s LI(13)=$p($g(^DHCEQEquip(EquipID)),"^",28)  //变动后净值
	....&sql(Insert Into SQLUSER.DHC_EQLifeInfo Values :LI())
	.;End By QW 2018-04-27

	i SQLCODE
	{
		TROLLBACK
		q SQLCODE_"^操作失败!"
	}
	TCOMMIT
	q "同步成功"
}

/// Add By DJ  2017-09-14
/// 描述:旧版DepreSet表升级后补录信息
/// w ##Class(web.DHCEQ.Tools.DataUpgrade).UpdateDepreSetInfo()
ClassMethod UpdateDepreSetInfo()
{
	TSTART
	s SQLCODE=0
	s DSRowID=0
	f  s DSRowID=$o(^DHCEQDepreSet(DSRowID))  q:(DSRowID="")||(SQLCODE'=0)  d
	.s EQRowID=$p($g(^DHCEQDepreSet(DSRowID)),"^",1)
	.s MainFlag=$p($g(^DHCEQDepreSet(DSRowID)),"^",3)
	.q:MainFlag'="Y"
	.k PLIST, FPLIST
	.s PLIST(20)=1			//DepreTypeDR
	.s PLIST(21)=0			//SourceType
	.s PLIST(22)=EQRowID	//SourceID
	.s PLIST(23)=..GetTotalDepreMonth(EQRowID,DSRowID)			//DepreTotal
	.s PLIST(24)=$p($g(^DHCEQEquip(EQRowID)),"^",35)			//DepreTotalFee
	.s PLIST(25)=$p($g(^DHCEQEquip(EQRowID)),"^",31)			//Years
	.&SQL(Update SQLUSER.DHC_EQDepreSet Values :PLIST() where DS_RowID = :DSRowID)
	.q:SQLCODE'=0
	.;同步资金来源
	.s FPLIST(2)=EQRowID
	.s FPLIST(3)=1
	.s FPLIST(4)=$p($g(^DHCEQEquip(EQRowID)),"^",27)			//OriginalFee
	.s FPLIST(7)="0"
	.s FPLIST(9)=+$H
	.s FPLIST(10)=$p($H,",",2)
	.s FPLIST(11)="N"
	.s FPLIST(14)=$p($g(^DHCEQEquip(EQRowID)),"^",35)
	.s FPLIST(15)="1"		//2013-01-01 DJ DJ0110
	.s FPLIST(16)=EQRowID		//2013-01-01 DJ DJ0110
	.&SQL(Insert Into SQLUSER.DHC_EQFunds Values :FPLIST())
	
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE_"^同步失败!"
	}
	TCOMMIT
	q "同步成功"
}

/// Add By DJ 2017-09-14
/// 描述:旧版入库审核单据状态为3，新版入库审核单据状态为2
/// modified By QW20180502 入库单据处理完毕才能执行
ClassMethod UpdateInStockStatus()
{
	&SQL(Update SQLUSER.DHC_EQInStock Set IS_Status=2 Where IS_Status=3)
}

/// Add By DJ 2017-09-14
/// 描述:新版本折旧表增加折旧类型
ClassMethod UpdateMonthDepre()
{
	&SQL(Update SQLUSER.DHC_EQMonthDepre Set MD_DepreTypeDR=1)
}

/// Add By DJ 2017-09-14
/// 描述:转移单状态处理
/// 说明:旧版(0:新增1:提交2:出库审核3:入库审核9:管理审核)  新版(0:新增1:提交2:审核3:作废)
ClassMethod UpdateStoreMove()
{
	&SQL(Update SQLUSER.DHC_EQStoreMove Set SM_Status=2 where SM_Status=3)
	//管理审核单据是否为最终审核状态单据根据项目实际情况处理
	;&SQL(Update SQLUSER.DHC_EQStoreMove Set SM_Status=2 where SM_Status=9)
}

/// Add By DJ 2017-09-14
/// 描述:旧版验收单升级之后生成验收单号
/// w ##Class(web.DHCEQ.Tools.DataUpgrade).UpdateOpenCheckRequest()
ClassMethod UpdateOpenCheckRequest()
{
	//首先检查单据类型表中是否有验收单据,无则增加
	//INSERT INTO SQLUser.DHC_EQCCounterType(ct_desc,ct_tablename,ct_invalidflag) VALUES('验收单号','DHC_EQOpenCheckRequest','N')
	
	//检测是否有验收单据编码规则,无则增加
	//UPDATE SQLUser.DHC_EQCCounter SET CNT_CounterNum=0,cnt_typedr=14,cnt_length=6,cnt_prefix='[Date]' WHERE CNT_RowID=83
	
	//根据编码规则生成验收单号
	TSTART
	s SQLCODE=0
	s OCRRowID=0
	f  s OCRRowID=$o(^DHCEQOpenCheckRequest(OCRRowID))  q:(OCRRowID="")||(SQLCODE'=0)  d
	.s OCRDate=$p($g(^DHCEQOpenCheckRequest(OCRRowID)),"^",10)
	.s OCREquipTypeDR=$p($g(^DHCEQOpenCheckRequest(OCRRowID)),"^",2)
	.s OCRNo=##CLASS(web.DHCEQCCounter).GetNextNo("DHC_EQOpenCheckRequest",OCRDate,"1",OCREquipTypeDR)
	.&SQL(Update SQLUSER.DHC_EQOpenCheckRequest Set OCR_Hold1=:OCRNo Where OCR_RowID=:OCRRowID)
	
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE_"^操作失败!"
	}
	TCOMMIT
	q "同步成功!"
}

/// Add By DJ 2017-09-27
/// 描述:旧版本报废表记录单台处理
/// w ##Class(web.DHCEQ.Tools.DataUpgrade).UpdateDisuseRequest()
ClassMethod UpdateDisuseRequest()
{
	TSTART
	s SQLCODE=0
	s DRRowID=0
	f  s DRRowID=$o(^DHCEQDisuseRequest(DRRowID))  q:(DRRowID="")||(SQLCODE'=0)  d
	.s DREquipDR=$p($g(^DHCEQDisuseRequest(DRRowID)),"^",1)
	.s KindFlag=$p($g(^DHCEQDisuseRequest(DRRowID)),"^",44)
	.i (KindFlag=0||KindFlag="")&&(DREquipDR="")  d
	..s DRLRowID=$o(^DHCEQDisuseRequestList(0,"DisuseRequest",DRRowID,0))
	..s DRLEquipDR=$p($g(^DHCEQDisuseRequestList(DRLRowID)),"^",2)
	..&SQL(Update SQLUSER.DHC_EQDisuseRequest Set DR_EquipDR=:DRLEquipDR Where DR_RowID=:DRRowID)
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE_"^同步失败!"
	}
	TCOMMIT
	q "同步成功!"
}

/// Add By DJ 2017-10-24
/// 描述:根据旧系统生命周期生成退货明细记录对应设备ID串
/// vLifeType:vSourceType   C:23表示退货
/// d ##Class(web.DHCEQ.Tools.DataUpgrade).CreateReturnEQIDSByLI("C","23")
ClassMethod CreateReturnEQIDSByLI(vLifeType As %String = "", vSourceType As %String = "")
{
	i (vLifeType="")||(vSourceType="")  q "请输入正确的参数!"
	s LIRowID=0
	f  s LIRowID=$o(^DHCEQLifeInfo(LIRowID))  q:LIRowID=""  d
	.s LIEquipDR=$P($G(^DHCEQLifeInfo(LIRowID)),"^",1)
	.s LILifeType=$P($G(^DHCEQLifeInfo(LIRowID)),"^",18)
	.q:LILifeType'=vLifeType
	.s LISourceType=$P($G(^DHCEQLifeInfo(LIRowID)),"^",19)
	.q:LISourceType'=vSourceType
	.s LISourceID=$P($G(^DHCEQLifeInfo(LIRowID)),"^",20)
	.i '$D(^DHCEQReturnList(LISourceID,"EX","RowIDs"))  d
	..s ^DHCEQReturnList(LISourceID,"EX","RowIDs")=LIEquipDR
	.e  d
	..s ^DHCEQReturnList(LISourceID,"EX","RowIDs")=^DHCEQReturnList(LISourceID,"EX","RowIDs")_","_LIEquipDR
}

/*********************************************个性方法******************************************/
/// Add By DJ 2017-09-14
/// 描述:韶关项目获取设备已折月份
/// 特别说明:个性统计,其它项目慎用
ClassMethod GetTotalDepreMonth(EquipID, DepreSet)
{
	s Total=0
	&SQL(Select Count(MD_RowID) into :Total From SQLUSER.DHC_EQMonthDepre Where MD_EquipDR=:EquipID and MD_DepreSetDR=:DepreSet)
	i Total="" s Total=0
	q Total
}

/// Add By DJ 2017-09-14
/// 描述:附件供应商及发票号升级同步
/// w ##Class(web.DHCEQ.Tools.DataUpgrade).AffixProvider()
ClassMethod AffixProvider()
{
	TSTART
	s SQLCODE=0
	s rowid=0
	f  s rowid=$o(^DHCEQAffixInfo(rowid))  q:(rowid="")||(SQLCODE'=0)  d
	.s AffixStr=^DHCEQAffixInfo(rowid)
	.s ProviderDR=$p($g(^DHCEQAffixInfo(rowid)),"^",1)
	.s InvoiceNo=$p($g(^DHCEQAffixInfo(rowid)),"^",2)
	.k PLIST
	.i AffixStr'="^"  d
	..i ProviderDR'="" s PLIST(25)=ProviderDR
	..i InvoiceNo'="" s PLIST(29)=InvoiceNo		//Hold4
	..&SQL(Update SQLUSER.DHC_EQAffix Values :PLIST() where AF_RowID = :rowid)
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE_"^同步失败!"
	}
	TCOMMIT
	q "同步成功"
}

/// Add By DJ 2017-09-14
/// 描述:旧版本领用日期和报废日期位置变更
/// 旧版本:EQ_Hold4(EQ_OldLoc)领用日期79      新版本:EQ_ReciveDate104
/// 		 :EQ_Hold5报废日期80	  新版本:EQ_DisuseDate90
/// w ##Class(web.DHCEQ.Tools.DataUpgrade).UpdateEquipInfo()
ClassMethod UpdateEquipInfo()
{
	TSTART
	s SQLCODE=0
	s EQRowID=0
	f  s EQRowID=$o(^DHCEQEquip(EQRowID))  q:(EQRowID="")||(SQLCODE'=0)  d
	.s EQReciveDate=$p($g(^DHCEQEquip(EQRowID)),"^",79)
	.i EQReciveDate'="" s EQReciveDate=$ZDH(EQReciveDate,3)
	.s EQDisuseDate=$p($g(^DHCEQEquip(EQRowID)),"^",80)
	.k PLIST
	.s PLIST(90)=EQDisuseDate
	.s PLIST(104)=EQReciveDate
	.s PLIST(80)=""			//EQOldLoc
	.s PLIST(81)=""			//EQHold5
	.&SQL(Update SQLUSER.DHC_EQEquip Values :PLIST() Where EQ_RowID=:EQRowID)
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE_"^同步失败!"
	}
	TCOMMIT
	q "同步成功!"
}

/// Add By DJ 2017-09-14
/// 描述:旧版快照生成新版快照
/// 说明:韶关项目个性需求，其它项目执行时根据实际情况调整
ClassMethod UpdateSnapShot()
{
	s MonthStr=""
	f  s MonthStr=$o(^DHCEQDepreEquipYB(MonthStr))  q:MonthStr=""  d
	.s CurMonthDate=$ZDH(MonthStr_"-01",3)
	.;开始生成快照
	.s snapDate=CurMonthDate
	.s snapTime=$p($H,",",2)
	.s SnapID=$I(^DHCEQSnapShot(0,"SnapID"))
	.s ^DHCEQSnapShot(SnapID,"Begin")=snapDate_","_snapTime
	.s node="Equip"
	.s ^DHCEQSnapShot(SnapID,node,0,"Begin")=snapDate_","_snapTime
	.s EQRowID=0
	.f  s EQRowID=$o(^DHCEQDepreEquipYB(MonthStr,EQRowID))  q:EQRowID=""  d
	..;韶关特殊处理(过滤当月末登记的快照记录)
	..s TransassetDate=$p($g(^DHCEQDepreEquipYB(MonthStr,EQRowID)),"^",45)
	..q:(TransassetDate="")||(TransassetDate>=$ZDH(MonthStr_"-01",3))
	..s OldInfo=$g(^DHCEQDepreEquipYB(MonthStr,EQRowID))
	..s count=##Class(web.DHCEQEquip).GetGlobalLen()-$L(OldInfo,"^")
	..f i=count:-1:1  d
	...s OldInfo=OldInfo_"^"
	..s ^DHCEQSnapShot(SnapID,node,EQRowID)=OldInfo
	..s DisuseDate=$p($g(^DHCEQDepreEquipYB(MonthStr,EQRowID)),"^",80)
	..s ReciveDate=$p($g(^DHCEQDepreEquipYB(MonthStr,EQRowID)),"^",79)
	..s $p(^DHCEQSnapShot(SnapID,node,EQRowID),"^",89)=DisuseDate	//报废日期
	..s ^DHCEQSnapShot(SnapID,node,EQRowID,"OtherInfo")="^^^^^^^^^^^^^^^^"
	..i ReciveDate'=""  d
	...s $p(^DHCEQSnapShot(SnapID,node,EQRowID,"OtherInfo"),"^",8)=$ZD(ReciveDate,3)		//领用日期
	..s tmp=..UpgradeGetEquipByID(MonthStr,EQRowID)
	..s tmp=$PIECE(tmp,"^",##Class(web.DHCEQEquip).GetGlobalLen(),$l(tmp,"^"))
	..s ^DHCEQSnapShot(SnapID,node,EQRowID,"EX")=tmp
	..;资金来源快照(韶关项目特殊,旧系统无资金来源信息登记,因此全部登记为自有资金)
	..s node="Funds"
	..s FundsRowID=$o(^DHCEQFunds("0","Source","1",EQRowID,0))
	..s ^DHCEQSnapShot(SnapID,node,0,"Begin")=snapDate_","_snapTime
	..s ^DHCEQSnapShot(SnapID,node,EQRowID,FundsRowID)=$g(^DHCEQFunds(FundsRowID))
	..s $p(^DHCEQSnapShot(SnapID,node,EQRowID,FundsRowID),"^",3)=$p($g(^DHCEQDepreEquipYB(MonthStr,EQRowID)),"^",27)			//FundsFee
	..s $p(^DHCEQSnapShot(SnapID,node,EQRowID,FundsRowID),"^",13)=$p($g(^DHCEQDepreEquipYB(MonthStr,EQRowID)),"^",35)			//DepreTotal
	..s ^DHCEQSnapShot(SnapID,node,0,"End")=snapDate_","_snapTime
	..s node="Equip"
	.s ^DHCEQSnapShot(SnapID,node,0,"End")=snapDate_","_snapTime
	.;增加科室职能快照
	.s node="LocType"
	.s ^DHCEQSnapShot(SnapID,node,0,"Begin")=snapDate_","_snapTime
	.s LTRowID=0
	.f  s LTRowID=$o(^DHCEQCCode("DHCEQCLocType",LTRowID))  quit:LTRowID=""  d
	..s LTType=$p($g(^DHCEQCCode("DHCEQCLocType",LTRowID)),"^",1)
	..s LTLocDR=$p($g(^DHCEQCCode("DHCEQCLocType",LTRowID)),"^",2)	
	..s ^DHCEQSnapShot(SnapID,node,LTType,LTLocDR,LTRowID)=$g(^DHCEQCCode("DHCEQCLocType",LTRowID))
	.s ^DHCEQSnapShot(SnapID,node,0,"End")=snapDate_","_snapTime
	.s ^DHCEQSnapShot(SnapID,"End")=snapDate_","_snapTime
	
	q "快照生成结束!"
}

ClassMethod UpgradeGetEquipByID(MonthStr As %String = "", rowid As %Library.String = "")
{
	new result,resultex,i,count,EquipTechLevel
	s EquipTechLevel=""
	s (result,resultex)=""
	s result= ^DHCEQEquip(rowid)
	set count=##Class(web.DHCEQEquip).GetGlobalLen()-$l(result,"^")
	for i=count:-1:1 { s result=result_"^"}
	s resultex=resultex_"^"	;ModelDR
	i $p(result,"^",3)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCModel",$p(result,"^",3))),"^",2)
	s resultex=resultex_"^"	;EquiCatDR
	i $p(result,"^",4)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCEquipeCat",$p(result,"^",4))),"^",2)
	s resultex=resultex_"^"	;UnitDR
	i $p(result,"^",5)'=""  d
	.s resultex=resultex_##class(web.DHCEQCommon).GetTrakNameByID("uom",$p(result,"^",5))
	s resultex=resultex_"^"	;InstallLocDR
	i $p(result,"^",8)'=""  d
	.s resultex=resultex_##class(web.DHCEQCommon).GetTrakNameByID("dept",$p($g(^DHCEQDepreEquipYB(MonthStr,EQRowID)),"^",8))
	s $p(result,"^",9)=##class(web.DHCEQCommon).TransValueToPage($p(result,"^",9),"date")	;InstallDate	
	s $p(result,"^",11)=##class(web.DHCEQCommon).TransValueToPage($p(result,"^",11),"date")	;LeaveFactoryDate
	s $p(result,"^",12)=##class(web.DHCEQCommon).TransValueToPage($p(result,"^",12),"date")	;OpenCheckDate
	s $p(result,"^",13)=##class(web.DHCEQCommon).TransValueToPage($p(result,"^",13),"date")	;CheckDate
	s $p(result,"^",14)=##class(web.DHCEQCommon).TransValueToPage($p(result,"^",14),"date")	;MakeDate
	s $p(result,"^",15)=##class(web.DHCEQCommon).TransValueToPage($p(result,"^",15),"bool")	;ComputerFlag
	s resultex=resultex_"^"	;CountryDR
	i $p(result,"^",16)'=""  d
	.s resultex=resultex_##class(web.DHCEQCommon).GetTrakNameByID("cou",$p(result,"^",16))
	s resultex=resultex_"^"	;ManageLocDR
	i $p(result,"^",17)'=""  d
	.s resultex=resultex_##class(web.DHCEQCommon).GetTrakNameByID("dept",$p($g(^DHCEQDepreEquipYB(MonthStr,EQRowID)),"^",17))
	s resultex=resultex_"^"	;ManageLevelDR
	i $p(result,"^",18)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCManageLevel",$p(result,"^",18))),"^",2)
	s resultex=resultex_"^"	;UseLocDR
	i $p(result,"^",19)'=""  d
	.s resultex=resultex_##class(web.DHCEQCommon).GetTrakNameByID("dept",$p($g(^DHCEQDepreEquipYB(MonthStr,EQRowID)),"^",19))
	s resultex=resultex_"^"	;OriginDR
	i $p(result,"^",20)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCOrigin",$p(result,"^",20))),"^",2)
	s resultex=resultex_"^"	;FromDeptDR
	i $p(result,"^",21)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCFromToDept",$p(result,"^",21))),"^",2)
	s resultex=resultex_"^"	;ToDeptDR
	i $p(result,"^",22)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCFromToDept",$p(result,"^",22))),"^",2)
	s resultex=resultex_"^"	;BuyTypeDR
	i $p(result,"^",23)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCBuyType",$p(result,"^",23))),"^",2)
	s resultex=resultex_"^"	;ProviderDR
	i $p(result,"^",25)'=""  d
	.s resultex=resultex_##class(web.DHCEQCommon).GetTrakNameByID("prov",$p(result,"^",25))
	s resultex=resultex_"^"	;ManuFactoryDR
	i $p(result,"^",26)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCManufacturer",$p(result,"^",26))),"^",1)
	s $p(result,"^",27)=##Class(web.DHCEQCommon).FormatNumber($p(result,"^",27),"")
	s $p(result,"^",28)=##Class(web.DHCEQCommon).FormatNumber($p(result,"^",28),"")
	s $p(result,"^",29)=##Class(web.DHCEQCommon).FormatNumber($p(result,"^",29),"")
	s resultex=resultex_"^"	;GroupDR
	i $p(result,"^",30)'=""  d
	.s resultex=resultex_$p($g(^DHCEQGroup($p(result,"^",30))),"^",2)
	s resultex=resultex_"^"	;ContractListDR
	i $p(result,"^",32)'=""  d
	.s contractdr=$p($g(^DHCEQContractList($p(result,"^",32))),"^",1)	
	.s resultex=resultex_$p($g(^DHCEQContract(contractdr)),"^",1)
	.//s resultex=resultex_$p($g(^DHCEQContractList($p(result,"^",32))),"^",2)
	s resultex=resultex_"^"	;DepreMethodDR
	i $p(result,"^",33)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCDepreMethod",$p(result,"^",33))),"^",2)
	s $p(result,"^",35)=##Class(web.DHCEQCommon).FormatNumber($p(result,"^",35),"")
	s resultex=resultex_"^"	;WorkLoadUnitDR
	i $p(result,"^",37)'=""  d
	.s resultex=resultex_##class(web.DHCEQCommon).GetTrakNameByID("uom",$p(result,"^",37))
	s resultex=resultex_"^"	;ManageUserDR
	i $p(result,"^",39)'=""  d
	.s resultex=resultex_##class(web.DHCEQCommon).GetTrakNameByID("user",$p(result,"^",39))
	s resultex=resultex_"^"	;MaintUserDR
	i $p(result,"^",40)'=""  d
	.s resultex=resultex_##class(web.DHCEQCommon).GetTrakNameByID("user",$p(result,"^",40))
	s $p(result,"^",43)=##Class(web.DHCEQCommon).FormatNumber($p(result,"^",43),"")
	s $p(result,"^",44)=##class(web.DHCEQCommon).TransValueToPage($p(result,"^",44),"date")	;StartDate
	i $p(result,"^",45)'="" d //2009-09-19 党军 begin
	.s $p(result,"^",45)=##class(web.DHCEQCommon).TransValueToPage($p(result,"^",45),"date")	;TransAssetDate
	e  d
	.i $p(result,"^",70)'="" d
	..s ISRowID=$p($g(^DHCEQInStockList($p(result,"^",70))),"^",1)
	..s $p(result,"^",45)=##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQInStock(ISRowID)),"^",13),"date") //2009-09-19 党军 end
	s $p(result,"^",46)=##class(web.DHCEQCommon).TransValueToPage($p(result,"^",46),"bool")	;GuaranteeFlag
	s $p(result,"^",47)=##class(web.DHCEQCommon).TransValueToPage($p(result,"^",47),"bool")	;InputFlag
	s $p(result,"^",48)=##class(web.DHCEQCommon).TransValueToPage($p(result,"^",48),"bool")	;TestFlag
	s $p(result,"^",49)=##class(web.DHCEQCommon).TransValueToPage($p(result,"^",49),"bool")	;MedicalFlag
	s $p(result,"^",50)=##class(web.DHCEQCommon).TransValueToPage($p(result,"^",50),"date")	;GuaranteeStartDate
	s $p(result,"^",51)=##class(web.DHCEQCommon).TransValueToPage($p(result,"^",51),"date")	;GuaranteeEndDate
	s resultex=resultex_"^"	;AddUserDR
	i $p(result,"^",52)'=""  d
	.s resultex=resultex_##class(web.DHCEQCommon).GetTrakNameByID("user",$p(result,"^",52))
	s $p(result,"^",53)=##class(web.DHCEQCommon).TransValueToPage($p(result,"^",53),"date")	;AddDate
	s resultex=resultex_"^"	;UpdateUserDR
	i $p(result,"^",55)'=""  d
	.s resultex=resultex_##class(web.DHCEQCommon).GetTrakNameByID("user",$p(result,"^",55))
	s $p(result,"^",56)=##class(web.DHCEQCommon).TransValueToPage($p(result,"^",56),"date")	;UpdateDate
	///
	s $p(result,"^",62)=##class(web.DHCEQCommon).TransValueToPage($p(result,"^",62),"bool")	;UrgencyFlag
	s resultex=resultex_"^"	;EquipTypeDR
	i $p(result,"^",63)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCEquipType",$p($g(^DHCEQDepreEquipYB(MonthStr,EQRowID)),"^",63))),"^",2)
	s resultex=resultex_"^"	;PurchaseTypeDR
	i $p(result,"^",64)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCPurchaseType",$p(result,"^",64))),"^",2)
	s resultex=resultex_"^"	;PurposeTypeDR
	i $p(result,"^",65)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCPurposeType",$p(result,"^",65))),"^",2)
	s resultex=resultex_"^"	;KeeperDR
	i $p(result,"^",66)'=""  d
	.s resultex=resultex_##class(web.DHCEQCommon).GetTrakNameByID("user",$p(result,"^",66))
	s resultex=resultex_"^"	;StoreLocDR
	i $p(result,"^",67)'=""  d
	.s resultex=resultex_##class(web.DHCEQCommon).GetTrakNameByID("dept",$p($g(^DHCEQDepreEquipYB(MonthStr,EQRowID)),"^",67))
	s resultex=resultex_"^"	;ServiceDR
	i $p(result,"^",69)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCService",$p(result,"^",69))),"^",1)
	s resultex=resultex_"^"	;InStockListDR
	i $p(result,"^",70)'=""  d
	.s resultex=resultex_$p($g(^DHCEQInStockList($p(result,"^",70))),"^",1)
	
	///////
	//状态
	s resultex=resultex_"^"_##Class(web.DHCEQEquip).GetEquipStatusDisplay($p(result,"^",38))
	//加
	s resultex=resultex_"^"
	i $p(result,"^",24)'=""  d 
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCTechLevel",$p(result,"^",24))),"^",2)
	s resultex=resultex_"^"	;StatCatDR
	i $p(result,"^",75)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCStatCat",$p($g(^DHCEQDepreEquipYB(MonthStr,EQRowID)),"^",75))),"^",2)
	s resultex=resultex_"^"_##class(web.DHCEQEquip).GetInStockDate(rowid,0)
		
	//add by Mozy 2009-2-27
	s resultex=resultex_"^"	;EquipeCatCode
	i $p(result,"^",4)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCEquipeCat",$p($g(^DHCEQDepreEquipYB(MonthStr,EQRowID)),"^",4))),"^",1)
	///新增:2009-12-02 党军 begin DJ0035
	s $p(result,"^",80)=##class(web.DHCEQCommon).TransValueToPage($p(result,"^",80),"bool")		//Add By DJ 2017-01-20
	s $p(result,"^",81)=##class(web.DHCEQCommon).TransValueToPage($p(result,"^",81),"bool")
	s $p(result,"^",82)=##class(web.DHCEQCommon).TransValueToPage($p(result,"^",82),"bool")
	s $p(result,"^",83)=##class(web.DHCEQCommon).TransValueToPage($p(result,"^",83),"bool")
	///2009-12-02 党军 end DJ0035
	s $p(result,"^",93)=##Class(web.DHCEQChangeInfo).GetEquipUnusualStatus($p(result,"^",93))	/// 20150922  Mozy0166
	
	//add by jdl 2009-9-25  JDL0036
	//格式化金额为小数点两位
	i $p(result,"^",27)'="" s $p(result,"^",27)=##Class(web.DHCEQCommon).FormatNumber($p(result,"^",27),"")	;OriginalFee
	i $p(result,"^",28)'="" s $p(result,"^",28)=##Class(web.DHCEQCommon).FormatNumber($p(result,"^",28),"")	;NetFee
	i $p(result,"^",29)'="" s $p(result,"^",29)=##Class(web.DHCEQCommon).FormatNumber($p(result,"^",29),"")	;NetRemainFee
	i $p(result,"^",35)'="" s $p(result,"^",35)=##Class(web.DHCEQCommon).FormatNumber($p(result,"^",35),"")	;DepreTotalFee
	
	//Add By jdl 2010-12-16
	s resultex=resultex_"^"
	i $p(result,"^",72)'="" d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCLocation",$p(result,"^",72))),"^",2)
	///Add By DJ 2013-01-10
	s resultex=resultex_"^"_##Class(web.DHCEQCommon).GetHospitalDesc($p(result,"^",67))
	// 增加68码 Mozy0110
	Set (MIHold1,MIHold1Code,MIHold1Desc)=""
	Set resultex=resultex_"^"	;ItemDR
	If $Piece(result,"^",7)'=""  Do
	.;Add By DJ 2013-06-24 DJ0118
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCMasterItem",$p(result,"^",7))),"^",1)
	.Set MIHold1=$Piece($Get(^DHCEQCCode("DHCEQCMasterItem",$Piece(result,"^",7))),"^",10)
	.If MIHold1'="" Do
	..Set MIHold1Code=$Piece(^DHCEQCCode("DHCEQCTree",MIHold1),"^",2)
	..Set MIHold1Desc=$Piece(^DHCEQCCode("DHCEQCTree",MIHold1),"^",3)
	Set resultex=resultex_"^"_MIHold1_"^"_MIHold1Code_"^"_MIHold1Desc
	///Add By DJ 2013-12-11 DJ0122
	s resultex=resultex_"^"
	i $p(result,"^",94)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCBrand",$p(result,"^",94))),"^",3)
	s resultex=resultex_"^"_##Class(web.DHCEQEquip).GetFundsInfo(rowid) //2014-6-25 HZY
	
	Set resultex=resultex_"^"		;入库单号	Mozy0132	2014-6-25
	If $Piece(result,"^",70)'=""  Do
	.Set InStockDR = $Piece($Get(^DHCEQInStockList($Piece(result,"^",70))),"^",1)
	.Set resultex=resultex_$Piece($Get(^DHCEQInStock(InStockDR)),"^",14)

	s resultex=resultex_"^"
	i $p(result,"^",77)'=""  d
	.s resultex=resultex_$p($g(^DHCEQOpenCheckList($p(result,"^",77))),"^",1)
	
	//Add By DJ 2014-08-21 DJ0126
	s resultex=resultex_"^"_$p($g(^DHCEQEquip(rowid,"OtherInfo")),"^",1)
	s resultex=resultex_"^"_$p($g(^DHCEQEquip(rowid,"OtherInfo")),"^",2)
	s resultex=resultex_"^"_$p($g(^DHCEQEquip(rowid,"OtherInfo")),"^",3)
	s resultex=resultex_"^"_$p($g(^DHCEQEquip(rowid,"OtherInfo")),"^",4)
	s resultex=resultex_"^"_$p($g(^DHCEQEquip(rowid,"OtherInfo")),"^",5)
	s resultex=resultex_"^"_$p($g(^DHCEQEquip(rowid,"OtherInfo")),"^",6)
	s resultex=resultex_"^"_##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQEquip(rowid,"OtherInfo")),"^",7),"bool")
	s resultex=resultex_"^"_##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQEquip(rowid,"OtherInfo")),"^",8),"date")
	s resultex=resultex_"^"_$p($g(^DHCEQEquip(rowid,"OtherInfo")),"^",9)
	s resultex=resultex_"^"_$p($g(^DHCEQEquip(rowid,"OtherInfo")),"^",10)
	s resultex=resultex_"^"_$p($g(^DHCEQEquip(rowid,"OtherInfo")),"^",11)
	s resultex=resultex_"^"_$p($g(^DHCEQEquip(rowid,"OtherInfo")),"^",12)
	/// Mozy0145	20141017
	Set resultex=resultex_"^"_$Piece($Get(^DHCEQEquip(rowid,"OtherInfo")),"^",13)
	Set resultex=resultex_"^"_$Piece($Get(^DHCEQEquip(rowid,"OtherInfo")),"^",14)
	Set resultex=resultex_"^"_$Piece($Get(^DHCEQEquip(rowid,"OtherInfo")),"^",15)
	Set resultex=resultex_"^"_$Piece($Get(^DHCEQEquip(rowid,"OtherInfo")),"^",16)
	Set resultex=resultex_"^"_$Piece($Get(^DHCEQEquip(rowid,"OtherInfo")),"^",17)
	Set resultex=resultex_"^"	;UserDR
	If $Piece($Get(^DHCEQEquip(rowid,"OtherInfo")),"^",15)'=""  d
	.Set resultex=resultex_##class(web.DHCEQCommon).GetTrakNameByID("user",$Piece($Get(^DHCEQEquip(rowid,"OtherInfo")),"^",15))
	//modify BY:GBX 2014-12-02  维修费用合计
	Set resultex=resultex_"^"_##Class(web.DHCEQEquip).GetMaintTotleFee(rowid)
	//modify BY:GBX 2014-12-02
	
	s result=result_resultex
	//add by zy 20150610 ZY0128
	s result=result_"^"_##Class(web.DHCEQChangeAccount).GetAddDepreTotalNum(rowid)  //显示调账处增加的折旧月份数
	
	//20150630  Mozy0154
	Set result=result_"^"
	If $Piece(result,"^",95)'="" Do
	.Set result=result_$Piece($Get(^DHCEQCCode("DHCEQCExpenditures",$Piece(result,"^",95))),"^",2)
	Set result=result_"^"
	i $p(result,"^",86)'=""  d
	.s result=result_##class(web.DHCEQCommon).GetTrakNameByID("dept",$p(result,"^",86))
	s $p(result,"^",87) = $CASE($p(result,"^",87),"1":"借出",:"在库")
	
	s result=##class(web.DHCEQCommon).Replace(result,$C(13,10),"\n")
	q result
}

/// Add By QW 2018-04-28
/// 描述:旧版本报废表记录多批处理
/// w ##Class(web.DHCEQ.Tools.DataUpgrade).UpdateDisuseList()
ClassMethod UpdateDisuseList()
{
	k ^Tmp("DHCEQ","UpdateDisuseList","Disue","DRRowID")
	TSTART
	s SQLCODE=0
	s DRRowID=0
	f  s DRRowID=$o(^DHCEQDisuseRequest(DRRowID))  q:(DRRowID="")||(SQLCODE'=0)  d 
	.s (UseLocDR,EquipTypeDR,DRREquipDR)=""
	.s num=0
	.s QFlag=0
	.s DRLRowID=0
	.f  s DRLRowID=$o(^DHCEQDisuseRequestList(0,"DisuseRequest",DRRowID,DRLRowID)) q:(DRLRowID="")||(SQLCODE'=0)  d
	..s EquipDR=""
	..s EquipDR = $p($g(^DHCEQDisuseRequestList(DRLRowID)),"^",2)
	..q:EquipDR="" 
	..s num=num+1
	..&SQL(Update SQLUSER.DHC_EQDisuseRequest Set DR_EquipDR=:EquipDR Where DR_RowID=:DRRowID)
	..s UseLocDR = $p($g(^DHCEQEquip(EquipDR)),"^",67)
	..s EquipTypeDR = $p($g(^DHCEQEquip(EquipDR)),"^",63)
	..k PLISTMX
	..s PLISTMX(2) = DRRowID	
	..s PLISTMX(3) = "0"  	;SourceType
	..s PLISTMX(4) = EquipDR		;SourceID
	..s PLISTMX(5) = "1"		;Qty
	..s PLISTMX(6) = $p($g(^DHCEQDisuseRequestList(DRLRowID)),"^",3)  	;UseState
	..s PLISTMX(7) = $p($g(^DHCEQDisuseRequestList(DRLRowID)),"^",5)  	;DisuseReason
	..s PLISTMX(8) = $p($g(^DHCEQDisuseRequestList(DRLRowID)),"^",6)  	;DisuseDate
	..s PLISTMX(9) = $p($g(^DHCEQDisuseRequestList(DRLRowID)),"^",7)  	;Remark
	..&SQL(Insert Into SQLUSER.DHC_EQDisuseList Values :PLISTMX())
	..s DLRowID=$G(%ROWID)
	..&SQL(Update SQLUSER.DHC_EQDisuseRequestList Set DRL_Hold2=:DLRowID where DRL_RowID = :DRLRowID)
	..s QFlag=1
	.i num=0 d
	.. i $p($g(^DHCEQDisuseRequest(DRRowID)),"^",1)=""  d
	...&SQL(delete from  sqluser.DHC_EQDisuseRequest where DR_RowID =:DRRowID)
	..e  d
	...s ^Tmp("DHCEQ","UpdateDisuseList","Disue","DRRowID",DRRowID)=DRRowID
	...s DRREquipDR =  $p($g(^DHCEQDisuseRequest(DRRowID)),"^",1)
	...s UseLocDR = $p($g(^DHCEQEquip(DRREquipDR)),"^",67)
	...s EquipTypeDR = $p($g(^DHCEQEquip(DRREquipDR)),"^",63)
	...k PLISTMX
	...s PLISTMX(2) = DRRowID	
	...s PLISTMX(3) = "0"  	;SourceType
	...s PLISTMX(4) = DRREquipDR		;SourceID
	...s PLISTMX(5) = "1"		;Qty
	...s PLISTMX(9) = "根据主单补明细"
	...&SQL(Insert Into SQLUSER.DHC_EQDisuseList Values :PLISTMX())
	...s DLRowID=$G(%ROWID)
	...k PLISTMX
	...s PLISTMX(2) = DRRowID
	...s PLISTMX(3) = DRREquipDR	
	...s PLISTMX(8) = "根据主单补明细"
	...s PLISTMX(13) =DLRowID
	...&SQL(Insert Into SQLUSER.DHC_EQDisuseRequestList Values :PLISTMX())
	...s QFlag=1
	.q:QFlag=0
	.&SQL(Update SQLUSER.DHC_EQDisuseRequest (DR_UseLocDR,DR_EquipTypeDR,DR_KindFlag,DR_InvalidFlag) VALUES(:UseLocDR,:EquipTypeDR,'2','N') where DR_RowID = :DRRowID)
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE_"^同步失败!"
	}

	TCOMMIT
	q "同步成功!"
}

/// w ##Class(web.DHCEQ.Tools.DataUpgrade).DeleteInvalidDisus()
ClassMethod DeleteInvalidDisus()
{
	TSTART
	s SQLCODE=0
	s DRRowID=0
	f  s DRRowID=$o(^DHCEQDisuseRequestList(0,"DisuseRequest",DRRowID)) q:(DRRowID="")||(SQLCODE'=0)  d 
	.i '$D(^DHCEQDisuseRequest(DRRowID))  d
	..s DRLRowID=0
	..f  s DRLRowID=$o(^DHCEQDisuseRequestList(0,"DisuseRequest",DRRowID,DRLRowID)) q:(DRLRowID="")||(SQLCODE'=0)  d
	...&SQL(delete from  sqluser.DHC_EQDisuseRequestList where DRL_RowID=:DRLRowID)
	..k ^DHCEQDisuseRequestList(0,"DisuseRequest",DRRowID)
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE_"^1同步失败!"
	}	
	&SQL(delete from  sqluser.DHC_EQDisuseRequestList where DRL_EquipDR IS NULL) 
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE_"^3同步失败!"
	}
	&SQL(delete from  sqluser.DHC_EQDisuseRequestList where DRL_DisuseRequestDR IS NULL) 

	i SQLCODE
	{
		TROLLBACK
		q SQLCODE_"^4同步失败!"
	}
	TCOMMIT
	q "同步成功!"
}

/// Add By QW20180502 
/// 描述:旧版退货审核单据状态为3，新版退货审核单据状态为2
/// 退货单据处理完毕才能执行
ClassMethod UpdateReturnStatus()
{
	&SQL(Update SQLUSER.DHC_EQReturn SET R_Status=2 Where R_Status=3)
}

/// Add By DJ 2018-04-24
/// 描述:基础数据升级标准库存在数据项目库不存在数据以标准库为准
/// d ##Class(web.DHCEQ.Tools.UserClsCompare).UpdateBaseCode()
ClassMethod UpdateBaseCode()
{
	s BaseTable=""
	f  s BaseTable=$o(^DHCEQCCodeStand(BaseTable))  q:BaseTable=""  d
	.q:BaseTable="DHCEQCAction"
	.q:BaseTable="DHCEQCApproveFlowAllow"
	.q:BaseTable="DHCEQCRoleReqFields"
	.q:BaseTable="DHCEQCApproveAction"
	.q:BaseTable="DHCEQCApprFlowStepAction"
	.;q:BaseTable="DHCEQCLocGroup"
	.;q:BaseTable="DHCEQCLocGroupType"
	.q:BaseTable="DHCEQCLocType"
	.q:BaseTable="DHCEQCTableData"
	.q:BaseTable="DHCEQCColumns"
	.q:BaseTable="DHCEQCColSet"
	.q:$D(^TempDHCEQUserClsInfo("X","Table",BaseTable))
	.k ^DHCEQCCode(BaseTable)
	.M ^DHCEQCCode(BaseTable)=^DHCEQCCodeStand(BaseTable)
	
	k ^DHCEQCCodeTable
	M ^DHCEQCCodeTable=^DHCEQCCodeTableStand
}

/// Add By QW 2018-05-03
/// 描述:根据^DHCEQDataEx("DHCEQStoreMoveList","EquipID")记录设备id设置转移明细设备ID
/// d ##Class(web.DHCEQ.Tools.DataUpgrade).CreateStoreMoveEQIDS()
ClassMethod CreateStoreMoveEQIDS()
{
   new EQID,RowID
	
	s RowID=0
	f  s RowID=$o(^DHCEQStoreMoveList(RowID))  q:RowID=""  d
	.k ^DHCEQStoreMoveList(RowID,"EX","RowIDs")
	.s EQID=0
	.s EquipIDs=""
	.f  s EQID=$o(^DHCEQDataEx("DHCEQStoreMoveList","EquipID",RowID,EQID))  q:EQID=""  d
	..i EquipIDs=""   d
	...s EquipIDs=EQID
	..e  d
	...s EquipIDs=EquipIDs_","_EQID
	.s ^DHCEQStoreMoveList(RowID,"EX","RowIDs")=EquipIDs
}

/// Add By QW 2018-05-03
/// 描述:根据台账记录设置存放地点并设置台账LocationDR
/// d ##Class(web.DHCEQ.Tools.DataUpgrade).InsertLocation()
ClassMethod InsertLocation()
{
	k ^DHCEQCCode("DHCEQCLocation")
	s EquipID=0
	f  s EquipID=$o(^DHCEQEquip(EquipID))  q:EquipID=""  d
	.s (desc,LRowID)=""
	.s desc=$p($g(^DHCEQEquip(EquipID)),"^",72)
	.q:desc=""
	.&SQL(Select L_rowid into :LRowID from SQLUSER.DHC_EQCLocation where L_desc=:desc)
	.i LRowID="" d
	..&SQL(Insert into SQLUSER.DHC_EQCLocation(L_desc,L_invalidflag) values (:desc,'N'))
	..Set LRowID=$Get(%ROWID)
	.i LRowID'=""  d
	..&SQL(Update SQLUSER.DHC_EQEquip SET EQ_LocationDR=:LRowID WHERE EQ_RowID=:EquipID)
}

/// Add By QW 2018-05-03
/// 描述:根据^DHCEQDataEx("DHCEQStoreMoveList","EquipID")记录设备id设置转移明细设备ID
/// d ##Class(web.DHCEQ.Tools.DataUpgrade).SetStoreMoveLocation()
ClassMethod SetStoreMoveLocation()
{
	s RowID=0
	f  s RowID=$o(^DHCEQStoreMoveList(RowID))  q:RowID=""  d
	.s (Desc,LRowID)=""
	.s Desc=$p($g(^DHCEQStoreMoveList(RowID)),"^",12)
	.q:Desc=""
	.&SQL(Select L_rowid into :LRowID from SQLUSER.DHC_EQCLocation where L_desc=:Desc)
	.i LRowID="" d
	..&SQL(Insert into SQLUSER.DHC_EQCLocation(L_desc,L_invalidflag) values (:Desc,'N'))
	..Set LRowID=$Get(%ROWID)
	.i LRowID'=""  d
	..&SQL(Update SQLUSER.DHC_EQStoreMoveList SET SML_LocationDR=:LRowID WHERE SML_RowID=:RowID)
}

/// Add By QW 2018-05-04
/// 描述: 将老版验收单转移至新版表中同时未入库验收单生成入库前台账
/// d ##Class(web.DHCEQ.Tools.DataUpgrade).SetOpenCheck()
ClassMethod SetOpenCheck()
{
	k ^DHCEQOpenCheckRequest
	k ^DHCEQOpenCheckList
	s rowid=0
	s count=1
	for  s rowid=$O(^DHCEQOpenCheck(rowid)) q:rowid=""  d
	.s tmpid=$Piece($Get(^DHCEQOpenCheck(rowid)),"^",1)
	.s ^DHCEQOpenCheckRequest(0)=rowid-1
	.s ^DHCEQOpenCheckList(0)=tmpid-1
	.k PLIST
	.k PLISTMX
	.s (LocationDR,Location,OCLRowID,OCRRowID)=""
	.;DHC_EQOpenCheckRequest
	.s PLIST(2)="0"       ;CheckType
 	.s PLIST(3)=$Piece($Get(^DHCEQOpenCheck(rowid)),"^",47)  ;EquipTypeDR
 	.s PLIST(4)=$Piece($Get(^DHCEQOpenCheck(rowid)),"^",48)  ;PurchaseTypeDR
 	.s PLIST(5)=$Piece($Get(^DHCEQOpenCheck(rowid)),"^",49)  ;StatCatDR
 	.s PLIST(6)=$Piece($Get(^DHCEQOpenCheck(rowid)),"^",43)  ;Provider
 	.s PLIST(7)=$Piece($Get(^DHCEQCheckEquip(tmpid)),"^",41)  ;ProviderHandler
 	.s PLIST(8)=$Piece($Get(^DHCEQCheckEquip(tmpid)),"^",42)  ;ProviderTel
 	.s PLIST(9)=$Piece($Get(^DHCEQOpenCheck(rowid)),"^",41)  ;OriginDR
 	.s PLIST(10)=$Piece($Get(^DHCEQOpenCheck(rowid)),"^",42)  ;FromDeptDR
 	.s PLIST(11)=$Piece($Get(^DHCEQOpenCheck(rowid)),"^",39)  ;OpenCheckDate
 	.s PLIST(12)=$Piece($Get(^DHCEQCheckEquip(tmpid)),"^",13)   ;CheckDate
 	.s PLIST(13)=$Piece($Get(^DHCEQOpenCheck(rowid)),"^",8) ;PackageState
 	.s PLIST(14)=$Piece($Get(^DHCEQOpenCheck(rowid)),"^",5) ;ConfigState
 	.s PLIST(15)=$Piece($Get(^DHCEQOpenCheck(rowid)),"^",10) ;FileState
 	.s PLIST(17)=$Piece($Get(^DHCEQOpenCheck(rowid)),"^",7) ;RunningState
 	.s PLIST(21)=$Piece($Get(^DHCEQOpenCheck(rowid)),"^",9) ;Status
 	.s PLIST(23)= $Piece($Get(^DHCEQOpenCheck(rowid)),"^",14)  ;SubmitUserDR
 	.s PLIST(24)= $Piece($Get(^DHCEQOpenCheck(rowid)),"^",15)  ;SubmitDate
 	.s PLIST(25)= $Piece($Get(^DHCEQOpenCheck(rowid)),"^",16) ;SubmitTime
 	.s PLIST(26)= $Piece($Get(^DHCEQOpenCheck(rowid)),"^",17) ;AuditUserDR
 	.s PLIST(27)= $Piece($Get(^DHCEQOpenCheck(rowid)),"^",18) ;AuditDate
 	.s PLIST(28)= $Piece($Get(^DHCEQOpenCheck(rowid)),"^",19) ;AuditTime
 	.s PLIST(29)=$Piece($Get(^DHCEQOpenCheck(rowid)),"^",22) ;RejectReason
 	.s PLIST(30)=$Piece($Get(^DHCEQOpenCheck(rowid)),"^",23) ;RejectUserDR
 	.s PLIST(31)=$Piece($Get(^DHCEQOpenCheck(rowid)),"^",24) ;RejectDate
 	.s PLIST(32)=$Piece($Get(^DHCEQOpenCheck(rowid)),"^",25) ;RejectTime
 	.s PLIST(33)=$Piece($Get(^DHCEQOpenCheck(rowid)),"^",26) ;ApproveSetDR
 	.s PLIST(34)=$Piece($Get(^DHCEQOpenCheck(rowid)),"^",27) ;NextRoleDR
 	.s PLIST(35)=$Piece($Get(^DHCEQOpenCheck(rowid)),"^",28) ;NextFlowStep
 	.s PLIST(36)=$Piece($Get(^DHCEQOpenCheck(rowid)),"^",29) ;ApproveStatu
 	.s PLIST(37)=$Piece($Get(^DHCEQOpenCheck(rowid)),"^",30) ;ApproveRoleDR
 	.
 	.s PLIST(46)=$Piece($Get(^DHCEQCheckEquip(tmpid)),"^",59) ;InvalidFlag	
 	.s PLISTMX(3)=$Piece($Get(^DHCEQOpenCheck(rowid)),"^",31)  ;Name
 	.s PLISTMX(4)=$Piece($Get(^DHCEQOpenCheck(rowid)),"^",47)  ;EquipTypeDR
 	.s PLISTMX(5)=$Piece($Get(^DHCEQCheckEquip(tmpid)),"^",2)  ; ABCType
 	.s PLISTMX(6)=$Piece($Get(^DHCEQOpenCheck(rowid)),"^",32)  ; ModelDR
 	.s PLISTMX(7)=$Piece($Get(^DHCEQOpenCheck(rowid)),"^",33)  ; EquiCatDR
 	.s PLISTMX(8)=$Piece($Get(^DHCEQOpenCheck(rowid)),"^",34)  ; UnitDR
 	.s PLISTMX(9)=$Piece($Get(^DHCEQOpenCheck(rowid)),"^",35)  ; Code
 	.s PLISTMX(10)=$Piece($Get(^DHCEQOpenCheck(rowid)),"^",36)  ; ItemDR
 	.s PLISTMX(11)=$Piece($Get(^DHCEQCheckEquip(tmpid)),"^",13)  ; MakeDate
 	.s PLISTMX(12)=$Piece($Get(^DHCEQOpenCheck(rowid)),"^",40)  ; CountryDR
 	.s PLISTMX(13)=$Piece($Get(^DHCEQCheckEquip(tmpid)),"^",18)  ; ManageLevelDR
 	.s PLISTMX(14)=$Piece($Get(^DHCEQCheckEquip(tmpid)),"^",23)  ; BuyTypeDR
 	.s PLISTMX(15)=$Piece($Get(^DHCEQCheckEquip(tmpid)),"^",24)  ; EquipTechLevelDR
 	.s PLISTMX(16)=$Piece($Get(^DHCEQOpenCheck(rowid)),"^",44)  ; ManuFactoryDR
 	.s PLISTMX(17)=$Piece($Get(^DHCEQCheckEquip(tmpid)),"^",71)  ; Quantity
 	.s PLISTMX(18)=$Piece($Get(^DHCEQOpenCheck(rowid)),"^",45)  ; OriginalFee
 	.s PLISTMX(19)=$Piece($Get(^DHCEQOpenCheck(rowid)),"^",46)  ; NetRemainFee
 	.s PLISTMX(20)=$Piece($Get(^DHCEQCheckEquip(tmpid)),"^",31)  ;LimitYearsNum
 	.s PLISTMX(21)=$Piece($Get(^DHCEQCheckEquip(tmpid)),"^",33)  ;DepreMethodDR
 	.s PLISTMX(22)=$Piece($Get(^DHCEQCheckEquip(tmpid)),"^",58)  ;CurrencyDR
 	.s PLISTMX(23)=$Piece($Get(^DHCEQCheckEquip(tmpid)),"^",61) ;MemoryCode
 	.s PLISTMX(24)=$Piece($Get(^DHCEQOpenCheck(rowid)),"^",48)  ;PurchaseTypeDR
 	.s PLISTMX(25)=$Piece($Get(^DHCEQCheckEquip(tmpid)),"^",65)  ; PurposeTypeDR
 	.s PLISTMX(26)=$Piece($Get(^DHCEQCheckEquip(tmpid)),"^",69)  ; ServiceDR
 	.i $Piece($Get(^DHCEQCheckEquip(tmpid)),"^",72)'=""  d  ; ServiceHandler->LocationDR
 	..s Location=$Piece($Get(^DHCEQCheckEquip(tmpid)),"^",72)
 	..&SQL(select L_RowID into :LocationDR  from SQLUSER.DHC_EQCLocation where L_Desc=:Location)
 	..s PLISTMX(27)=LocationDR
 	.s PLISTMX(29)=$Piece($Get(^DHCEQOpenCheck(rowid)),"^",49)  ; StatCatDR
 	.s PLISTMX(30)=$Piece($Get(^DHCEQCheckEquip(tmpid)),"^",36)  ; DesignWorkLoadNum
 	.s PLISTMX(31)=$Piece($Get(^DHCEQCheckEquip(tmpid)),"^",37)  ; WorkLoadUnitDR
 	.s PLISTMX(32)=$Piece($Get(^DHCEQCheckEquip(tmpid)),"^",67)  ; StoreLocDR
 	.s PLISTMX(33)=$Piece($Get(^DHCEQOpenCheck(rowid)),"^",3)  ; ManageLocDR
 	.s PLISTMX(34)=$Piece($Get(^DHCEQOpenCheck(rowid)),"^",4)  ; UseLocDR
 	.s PLISTMX(35)=$Piece($Get(^DHCEQCheckEquip(tmpid)),"^",34)  ; Remark
 	.s PLISTMX(37)=$Piece($Get(^DHCEQOpenCheck(rowid)),"^",51)  ;ContractNo
 	.s PLISTMX(38)=$Piece($Get(^DHCEQCheckEquip(tmpid)),"^",32)  ; ContractListDR
 	.s PLISTMX(39)=$Piece($Get(^DHCEQCheckEquip(tmpid)),"^",49)  ; MedicalFlag
 	.s PLISTMX(41)=$Piece($Get(^DHCEQCheckEquip(tmpid)),"^",48)  ; TestFlag
 	.s PLISTMX(42)=$Piece($Get(^DHCEQCheckEquip(tmpid)),"^",62)  ; UrgencyFlag
 	.s PLISTMX(43)=$Piece($Get(^DHCEQCheckEquip(tmpid)),"^",46)  ; GuaranteeFlag
  	.s PLISTMX(44)=$Piece($Get(^DHCEQCheckEquip(tmpid)),"^",50)  ; GuaranteeStartDate
 	.s PLISTMX(45)=$Piece($Get(^DHCEQCheckEquip(tmpid)),"^",51)  ; GuaranteeEndDate
 	.s PLISTMX(46)=$Piece($Get(^DHCEQOpenCheck(rowid)),"^",39)  ; OpenCheckDate
 	.s PLISTMX(47)=$Piece($Get(^DHCEQCheckEquip(tmpid)),"^",13)  ; CheckDate
 	.s PLISTMX(48)=$Piece($Get(^DHCEQCheckEquip(tmpid)),"^",8)  ; InstallLocDR
 	.s PLISTMX(49)=$Piece($Get(^DHCEQCheckEquip(tmpid)),"^",9)  ; InstallDate
 	.s PLISTMX(50)=$Piece($Get(^DHCEQOpenCheck(rowid)),"^",38)  ; LeaveFactoryDate
	.s PLISTMX(51)=$Piece($Get(^DHCEQOpenCheck(rowid)),"^",20)  ; PackTypeDR 
	.s PLISTMX(52)=$Piece($Get(^DHCEQOpenCheck(rowid)),"^",21)  ; PackNum
	.s PLISTMX(53)=$Piece($Get(^DHCEQCheckEquip(tmpid)),"^",45)  ; TransAssetDate 
 	.s PLISTMX(64)="0" ;sourcetype
 	.s PLISTMX(65)=$Piece($Get(^DHCEQOpenCheck(rowid)),"^",36)
	.s PLISTMX(76)=$Piece($Get(^DHCEQOpenCheck(rowid)),"^",50)  //Hold6 招标编号
	.s PLISTMX(77)=$Piece($Get(^DHCEQCheckEquip(tmpid)),"^",73)  ; //Hold10 功率
	.s PLIST(38)=##CLASS(web.DHCEQCCounter).GetNextNo("DHC_EQOpenCheckRequest",PLIST(11),"1",PLIST(3))		//RequestHold1  存验收单号
	.&SQL(Insert Into SQLUSER.DHC_EQOpenCheckRequest Values :PLIST())
	.s OCRRowID=$G(%ROWID)
	.s PLISTMX(2)=OCRRowID 
	.&SQL(Insert Into SQLUSER.DHC_EQOpenCheckList Values :PLISTMX())
	.s oclrowid=$G(%ROWID)
	.s flag=$o(^DHCEQInStockList(0,"Source","2",rowid,0))
	.q:flag'=""
	.s ContractList=$P(^DHCEQOpenCheckList(oclrowid),"^",37)
	.s Quantity=$P(^DHCEQOpenCheckList(oclrowid),"^",16)
	.s combindata=oclrowid_"^"_ContractList_"^"_Quantity
	.s SQLCODE=##Class(web.DHCEQ.Tools.DataUpgrade).UpdateEquip(combindata)
}

/// Add By QW 2018-05-04
/// 补充ISL_SourceType和ISL_SourceID 
///     ISL_SourceType:1-设备项，2-验收
/// d ##Class(web.DHCEQ.Tools.DataUpgrade).AddSourceID()
ClassMethod AddSourceID()
{
	TSTART
	s rowid=0
	f  s rowid=$o(^DHCEQInStockList(rowid))  quit:rowid=""  d
	.s (CheckequipDR,itemDR,sourceid,sourcetype)=""
	.s CheckequipDR=$p($g(^DHCEQInStockList(rowid)),"^",2)
	.s itemDR=$p($g(^DHCEQInStockList(rowid)),"^",16)
	.w rowid_":"_CheckequipDR_"-"_itemDR,!
	.i itemDR'="" d
	..s sourcetype="1"
	..s sourceid=itemDR
	.i CheckequipDR'="" d
	..s sourcetype="2"
	..s sourceid=CheckequipDR
	.q:sourcetype=""
	.&SQL(UPDATE SQLUSER.DHC_EQInStockList (ISL_SourceType,ISL_SourceID) VALUES (:sourcetype,:sourceid)WHERE ISL_RowID=:rowid)
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE_"^操作失败!"
	}
	TCOMMIT
	q "同步成功"
}

/// Add By QW 2018-05-04
/// F_CheckListDR由主单改为明细
/// d ##Class(web.DHCEQ.Tools.DataUpgrade).SetFunds()
ClassMethod SetFunds()
{
	TSTART
	s rowid=0
	f  s rowid=$o(^DHCEQFunds(rowid))  quit:rowid=""  d
	.s OCRRowID=$p($g(^DHCEQFunds(rowid)),"^",4)
	.q:OCRRowID=""
	.s OCLRowID=$o(^DHCEQOpenCheckList(0,"OpenCheckRequest",OCRRowID,0))
	.&SQL(UPDATE SQLUSER.DHC_EQFunds  SET F_CheckListDR=:OCLRowID WHERE F_RowID=:rowid)
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE_"^操作失败!"
	}
	TCOMMIT
	q "同步成功"
}

/// Add By QW 2018-05-03
/// 描述:根据台账记录补充科室类型
/// d ##Class(web.DHCEQ.Tools.DataUpgrade).UpdateLocType()
ClassMethod UpdateLocType()
{
	s EquipID=0
	f  s EquipID=$o(^DHCEQEquip(EquipID))  q:EquipID=""  d
	.s LTID=""
	.s LocDR=$p($g(^DHCEQEquip(EquipID)),"^",67)
	.&SQL(Select LT_RowID into :LTID from SQLUSER.DHC_EQCLocType where LT_LocDR=:LocDR)
	.i LTID="" d
	..&SQL(Insert into SQLUSER.DHC_EQCLocType(LT_LocDR,LT_Type) values (:LocDR,'2'))
}

ClassMethod UpdateEquip(val As %Library.String = "")
{
 
	 new (val)
	 s Quantity=$p(val,"^",3)
	 s ContractListDR=$p(val,"^",2)
	 s oclrowid=$p(val,"^",1)
	 s ocrrowid=$p($g(^DHCEQOpenCheckList(oclrowid)),"^",1)
	 s User=1
	 s Date=+$H
 	 s Time=$P($H,",",2)
 	 s flag=0
	 s PI(2) = $p($g(^DHCEQOpenCheckList(oclrowid)),"^",2)	;Name
	 s PI(3) = $p($g(^DHCEQOpenCheckList(oclrowid)),"^",4)	;ABCType
	 s PI(4) = $p($g(^DHCEQOpenCheckList(oclrowid)),"^",5)	;ModelDR
 	 s PI(5) = $p($g(^DHCEQOpenCheckList(oclrowid)),"^",6)	;EquiCatDR
 	 s PI(6) = $p($g(^DHCEQOpenCheckList(oclrowid)),"^",7)	;UnitDR
 	 s PI(7) = $p($g(^DHCEQOpenCheckList(oclrowid)),"^",8) //Code 	 
 	 s PI(8) = $p($g(^DHCEQOpenCheckList(oclrowid)),"^",9) //ItemDR
 	 s PI(9) = $p($g(^DHCEQOpenCheckList(oclrowid)),"^",47) ;InstallLoc
 	 s PI(10) = $p($g(^DHCEQOpenCheckList(oclrowid)),"^",48) ;InstallDate
 	 s PI(12) = $p($g(^DHCEQOpenCheckList(oclrowid)),"^",49) ;LeaveFactoryDate
 	 s PI(13) = $p($g(^DHCEQOpenCheckRequest(ocrrowid)),"^",10) ;OpenCheckDate
 	 s PI(14) = $p($g(^DHCEQOpenCheckList(oclrowid)),"^",46) ;CheckDate
 	 s PI(15) = $p($g(^DHCEQOpenCheckList(oclrowid)),"^",10) ;MakeDate
 	 s PI(16) = $p($g(^DHCEQOpenCheckList(oclrowid)),"^",39) ;ComputerFlag  add by zy 20150901 zy0140
 	 s PI(17) = $p($g(^DHCEQOpenCheckList(oclrowid)),"^",11)	;CountryDR
 	 s PI(18) = $p($g(^DHCEQOpenCheckList(oclrowid)),"^",32)	;ManageLocDR
 	 s PI(19) = $p($g(^DHCEQOpenCheckList(oclrowid)),"^",12)	;ManageLevelDR
 	 s PI(21) = $p($g(^DHCEQOpenCheckRequest(ocrrowid)),"^",8)	;OriginDR
 	 s PI(22) = $p($g(^DHCEQOpenCheckRequest(ocrrowid)),"^",9)	;FromDeptDR
	 s PI(24) = $p($g(^DHCEQOpenCheckList(oclrowid)),"^",13)	;BuyTypeDR
 	 s PI(25) = $p($g(^DHCEQOpenCheckList(oclrowid)),"^",14)	;EquipTechLevelDR 
 	 s PI(26) = $p($g(^DHCEQOpenCheckRequest(ocrrowid)),"^",5)	;ProviderDR
 	 s PI(27) = $p($g(^DHCEQOpenCheckList(oclrowid)),"^",15)	;ManuFactoryDR
 	 s PI(28) = $p($g(^DHCEQOpenCheckList(oclrowid)),"^",17)	;OriginalFee
 	 If PI(3)=""
	 {
		 Set PI(3)="A"		;默认类
		 If PI(28)<80000 Set PI(3)="B"
		 If PI(28)<10000 Set PI(3)="C"
		 If PI(28)<1000 Set PI(3)="D"
	 }
 	 s PI(29) = $p($g(^DHCEQOpenCheckList(oclrowid)),"^",17)	;NetFee
	 s PI(30) = $p($g(^DHCEQOpenCheckList(oclrowid)),"^",18)  	;NetRemainFee
	 s PI(32) = $p($g(^DHCEQOpenCheckList(oclrowid)),"^",19) 	;LimitYearsNum
	 s PI(33) = $p($g(^DHCEQOpenCheckList(oclrowid)),"^",37)	;ContractListDR
	 s PI(34) = $p($g(^DHCEQOpenCheckList(oclrowid)),"^",20) 	;DepreMethod
	 s PI(35) = $p($g(^DHCEQOpenCheckRequest(ocrrowid)),"^",21)	;Remark
	 s PI(37) = $p($g(^DHCEQOpenCheckList(oclrowid)),"^",29) 	;DesignWorkLoadNum
	 s PI(38) = $p($g(^DHCEQOpenCheckList(oclrowid)),"^",30) 	;WorkLoadUnit
	 s PI(39)=0 ;Status
	 s PI(42) = $p($g(^DHCEQOpenCheckRequest(ocrrowid)),"^",6)	;ContactUser
 	 s PI(43) = $p($g(^DHCEQOpenCheckRequest(ocrrowid)),"^",7)	;ContactMode
	 s PI(47) = $p($g(^DHCEQOpenCheckList(oclrowid)),"^",42) ;GuaranteeFlag
 	 s PI(48) = "N"
 	 s PI(49) = $p($g(^DHCEQOpenCheckList(oclrowid)),"^",40) ;TestFlag
 	 s PI(50) = $p($g(^DHCEQOpenCheckList(oclrowid)),"^",38) ;MedicalFlag
 	 s PI(51) = $p($g(^DHCEQOpenCheckList(oclrowid)),"^",43) ;GuaranteeStartDate
	 s PI(52) = $p($g(^DHCEQOpenCheckList(oclrowid)),"^",44) ;GuaranteeEndDate
 	 s PI(53)=User
	 s PI(54)=Date
	 s PI(55)=Time
	 s PI(56)=User
	 s PI(57)=Date
	 s PI(58)=Time
	 s PI(59)= $p($g(^DHCEQOpenCheckList(oclrowid)),"^",21) ;Currency
	 s PI(60) = "N"
	 s PI(61) = "0"
 	 s PI(62) = $p($g(^DHCEQOpenCheckList(oclrowid)),"^",22) //MemeryCode
 	 s PI(63) = $p($g(^DHCEQOpenCheckList(oclrowid)),"^",41) //UrgencyFlag
 	 s PI(64) = $p($g(^DHCEQOpenCheckList(oclrowid)),"^",3) //EquipType
 	 s PI(65) = $p($g(^DHCEQOpenCheckList(oclrowid)),"^",23) //PurchaseTypeDR
 	 s PI(66) = $p($g(^DHCEQOpenCheckList(oclrowid)),"^",24) //PurposeTypeDR
 	 s PI(70) = $p($g(^DHCEQOpenCheckList(oclrowid)),"^",25) //ServiceDR 	 
 	 s PI(73) = $p($g(^DHCEQOpenCheckList(oclrowid)),"^",26) //LocationDR
 	 s PI(74) = $p($g(^DHCEQOpenCheckList(oclrowid)),"^",27) //GuaranteePeriodNum
 	 s PI(76) = $p($g(^DHCEQOpenCheckList(oclrowid)),"^",28) //StatCatDR
 	 s PI(77) = $Piece($Get(^DHCEQOpenCheckList(oclrowid)),"^",36) //ContractNo Mozy0051	2011-4-15
 	 s PI(78) = oclrowid //OpenCheckListRowid
 	 s PI(82)=$p($g(^DHCEQOpenCheckList(oclrowid)),"^",60) ;BenefitAnalyFlag
 	 s PI(83)=$p($g(^DHCEQOpenCheckList(oclrowid)),"^",61) ;CommonageFlag
 	 s PI(84)=$p($g(^DHCEQOpenCheckList(oclrowid)),"^",62) ;AutoCollectFlag
 	 s PI(85)=$p($g(^DHCEQOpenCheckList(oclrowid)),"^",65) ;WorkLoadPerMonth
 	 
 	 s PI(93)=$p($g(^DHCEQOpenCheckList(oclrowid)),"^",56) ;Hold2  //注册证号
 	 s PI(95)=$p($g(^DHCEQOpenCheckList(oclrowid)),"^",58)	;Hold4	//品牌	2013-12-11 DJ0122
 	 Set PI(96)=$Piece($Get(^DHCEQOpenCheckList(oclrowid)),"^",59)	;Hold5	//经费来源 20150630  Mozy0154
 	 s PI(109)=$p($g(^DHCEQOpenCheckList(oclrowid)),"^",66)  //ValueType
 	 s PI(110)=$p($g(^DHCEQOpenCheckList(oclrowid)),"^",67)  //DirectionsUse
 	 s PI(111)=$p($g(^DHCEQOpenCheckList(oclrowid)),"^",68)  //UserDR
 	 s PI(112)=$p($g(^DHCEQOpenCheckList(oclrowid)),"^",69)  //AccountShape
 	 s PI(113)=$p($g(^DHCEQOpenCheckList(oclrowid)),"^",70)  //ProjectNo
 	 s PI(91)=$p($g(^DHCEQOpenCheckList(oclrowid)),"^",71)   //凭证号
 	 s PI(103)=$p($g(^DHCEQOpenCheckList(oclrowid)),"^",72)  //EQRaditionFlag	放射标志
	 s PI(81)=$p($g(^DHCEQOpenCheckList(oclrowid)),"^",73) ;中医标志 Add By DJ 2017-01-20
	 s PI(99)=$p($g(^DHCEQOpenCheckList(oclrowid)),"^",76) ;
	 for j=1:1:Quantity
	 {
		 q:flag'=0
		 &sql(Insert Into sqluser.DHC_EQEquip values :PI())
		 w ocrrowid,SQLCODE,!
		 s flag=SQLCODE
		 q:flag'=0
	 	 s ID=$G(%ROWID)
		 s SQLCODE= ##CLASS(web.DHCEQEquip).UpdateEquipNo(ID,Date)
		 w SQLCODE_"^"_"ok",!
		 s flag=SQLCODE
	 }
	 q flag
}

/// d ##Class(web.DHCEQ.Tools.DataUpgrade).GenerateEquipByCheckList()
ClassMethod GenerateEquipByCheckList()
{
	TSTART
	set rowid=0
	s SQLFlag=""
	s flag=""
	f  s rowid=$o(^DHCEQOpenCheckList(rowid))   q:rowid=""  d
	.s flag=$o(^DHCEQInStockList(0,"Source","2",rowid,0))
	.q:flag'=""
	.q:(SQLFlag'="")&&(SQLFlag'=0)
	.s ContractList=$P(^DHCEQOpenCheckList(rowid),"^",37)
	.s Quantity=$P(^DHCEQOpenCheckList(rowid),"^",16)
	.s combindata=rowid_"^"_ContractList_"^"_Quantity
	.s SQLFlag=##Class(web.DHCEQ.Tools.DataUpgrade).UpdateEquip(combindata)
	i SQLFlag
	{
		TROLLBACK
		q SQLFlag_"^操作失败!"
	}
	TCOMMIT
	q "同步成功"
}

}
