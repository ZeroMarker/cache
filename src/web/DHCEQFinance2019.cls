Class web.DHCEQFinance2019 Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Add By DJ 2018-12-29
/// 根据调整设备项生成调整数据单及明细记录
/// 说明:^DHCEQUpdate("MasterItem")在导入数据的调整设备项处生成
ClassMethod CreateAdjustData(vEquipTypeDRs As %String = "")
{
	TSTART
	s Count=0
	s SQLCODE=0
	//生成调整数据总单
	&SQL(INSERT INTO SQLUser.DHC_EQAdjustData(ad_type,ad_reportflag,ad_sql,ad_sourcefile,ad_content,ad_requestuser,ad_status,ad_displayflag,ad_hold1) VALUES(1,'Y','无','医院提供','2019年新财务制度','财务科',0,'Y',1))
	s ADRowID=$Get(%ROWID)
	//根据调整设备项生成调整数据明细
	s EQRowID=0
	f  s EQRowID=$o(^DHCEQEquip(EQRowID))  q:(EQRowID="")||(SQLCODE'=0)  d
	.s EQItemDR=$p($g(^DHCEQEquip(EQRowID)),"^",7)
	.i EQItemDR="" s SQLCODE="-9999"
	.q:SQLCODE'=0
	.q:'$D(^DHCEQUpdate("MasterItem",EQItemDR))
	.s Flag=0
	.s EQInvalidFlag=$p($g(^DHCEQEquip(EQRowID)),"^",59)
	.i EQInvalidFlag="Y" s Flag=1
	.s EQStatus=$p($g(^DHCEQEquip(EQRowID)),"^",38)
	.i EQStatus>2 s Flag=1
	.s EQStockStatus=$p($g(^DHCEQEquip(EQRowID)),"^",60)
	.i EQStockStatus=3 s Flag=1
	.s NewETRowID=$p($g(^DHCEQUpdate("MasterItem",EQItemDR)),"^",4)
	.q:((vEquipTypeDRs'="")&&((","_vEquipTypeDRs_",")'[(","_NewETRowID_",")))
	.s NewSCRowID=$p($g(^DHCEQUpdate("MasterItem",EQItemDR)),"^",5)
	.s NewECRowID=$p($g(^DHCEQUpdate("MasterItem",EQItemDR)),"^",6)
	.s NewLimitYears=$p($g(^DHCEQCCode("DHCEQCStatCat",NewSCRowID)),"^",9)
	.i Flag=0  d
	..//有效设备更新台帐分类及年限
	..&SQL(Update SQLUSER.DHC_EQEquip Set EQ_EquiCatDR=:NewECRowID,EQ_LimitYearsNum=:NewLimitYears Where EQ_RowID=:EQRowID)
	..q:SQLCODE'=0
	..//有效设备
	..&SQL(INSERT INTO SQLUser.DHC_EQAdjustDataList(adl_adjustdatadr,adl_equipdr,adl_fromlocdr,adl_fromequiptypedr,adl_fromstatcatdr,adl_fromorigindr,adl_tolocdr,adl_toequiptypedr,adl_tostatcatdr,adl_toorigindr,adl_eqstatus,adl_originalfee,adl_depretotal,adl_netfee) SELECT :ADRowID,eq_rowid,eq_storelocdr,eq_equiptypedr,eq_statcatdr,eq_origindr,eq_storelocdr,:NewETRowID,:NewSCRowID,eq_origindr,eq_status,eq_originalfee,eq_depretotalfee,eq_netfee FROM SQLUser.DHC_EQEquip WHERE EQ_RowID=:EQRowID)
	..s Count=Count+1
	.e  d
	..//无效设备暂不做处理
	..;&SQL(Update SQLUSER.DHC_EQEquip Set EQ_EquipTypeDR=:NewETRowID,EQ_StatCatDR=:NewSCRowID,EQ_EquiCatDR=:NewECRowID,EQ_LimitYearsNum=:NewLimitYears Where EQ_RowID=:EQRowID)
	
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE
	}
	TCOMMIT
	q SQLCODE_"[总记录数为:"_Count_"]"
}

/// 每月定期执行一次计提折旧,单独建立一个任务
/// 因当月入库的下月计提,且当月即使报废也要计提折旧,
/// 故定义在每期第一天凌晨计提当月折旧
/// d ##Class(web.DHCEQFinance2019).MonthDepre()
ClassMethod MonthDepre(DepreTypeDR As %Library.String = "1")
{
	;Modified By JDL 20150811  ZX0024 调整为月末计提折旧。每天执行该任务,若是最后一天,则执行折旧任务
		s Date=$H ;
		s Node="MonthDepre"
		i DepreTypeDR'=1 s Node="MonthDepre"_DepreTypeDR
		s Result=""
		s ^DHCEQLog("Job",Node,Date,"Begin")=$H ;
		;获取当前日期所属会计周期的月份
		s MonthStr=##Class(web.DHCEQReport).GetReportMonthByDate($H)
		s Result= ##class(web.DHCEQFinance2019).GetMonthDepre(MonthStr,"",DepreTypeDR)
		s ^DHCEQLog("Job",Node,Date,"Result")=Result
		s ^DHCEQLog("Job",Node,Date,"End")=$H
}

/// 提取设备的月度折旧
/// 返回值：返回计提出错和折旧未正确设置的设备条数。
/// w ##class(web.DHCEQMonthDepre).GetMonthDepre("2010-08")
/// 
/// 该月应提折旧的设备明细
/// select eq_originalfee,eq_netfee,eq_netremainfee,eq_instocklistdr->isl_instockdr->is_billauditdate,eq_invalidflag,eq_stockstatus,eq_status,eq_depremethoddr,eq_limityearsnum, * from dhc_eqequip 
/// where eq_invalidflag='No' and eq_status<>'报废' and eq_stockstatus<>'出库' and eq_stockstatus<>'新增' and eq_netfee>0 and eq_instocklistdr->isl_instockdr->is_billauditdate<'9/1/2010'
/// 该月应提折旧在折旧表中未提的记录
/// select eq_originalfee,eq_netfee,eq_netremainfee,eq_instocklistdr->isl_instockdr->is_billauditdate,eq_invalidflag,eq_stockstatus,eq_status,eq_depremethoddr,eq_limityearsnum, * from dhc_eqequip 
/// where eq_invalidflag='No' and eq_status<>'报废' and eq_stockstatus<>'出库' and eq_stockstatus<>'新增' and eq_netfee>0 and eq_instocklistdr->isl_instockdr->is_billauditdate<'9/1/2010' and eq_rowid not in (select md_equipdr from dhc_eqmonthdepre where md_depremonth='2010-12')
/// w ##class(web.DHCEQMonthDepre).GenerateMonthDepre(rowid, DepreMonth, +$H, DepreTypeDR, "N", "0", "")
/// w ##class(web.DHCEQMonthDepre).GenerateMonthDepre(160, "2010-12", +$H, 1, "N", "0", "")
ClassMethod GetMonthDepre(DepreMonth As %Library.String = "", EquipTypeIDS As %Library.String = "", DepreTypeDR As %Library.String = "1")
{
	new (DepreMonth,EquipTypeIDS,DepreTypeDR)
	//自动执行的时候设置执行日期为每月的25号到月底间执行
	if DepreMonth=""  d
	.s CurDate=$ZD($H,3)
	.s DepreMonth=$p(CurDate,"-",1,2)

	//modified by zy 2013-06-04 zy0107
	//增加参数判断折旧是否包含预报废设备，直接取EQ_Hold8字段的值来判断
	s DepreFlag=##class(web.DHCEQCommon).GetSysInfo("990021")
	i EquipTypeIDS'="" s EquipTypeIDS=","_EquipTypeIDS_","
	s Times=$o(^DHCEQLog(0,"MonthDepreLog",DepreMonth,DepreTypeDR,""),-1)
	s Times=Times+1
	s ^DHCEQLog(0,"MonthDepreLog",DepreMonth,DepreTypeDR,Times,"Begin")=$H
	
	s errCount=0
	s rowid=0
	f  s rowid=$o(^DHCEQEquip(rowid))  q:rowid=""  d
	.q:(##class(web.DHCEQFinance2019).CheckNeedDepre(rowid,EquipTypeIDS,DepreFlag))=0   //modify by lmm 2018-12-12
	.;add by jdl 增加一种折旧设置,用于计算科室成本,仅在用时提取 2011-8-1 JDL0088
	.q:(DepreTypeDR=2)&&(+$p(^DHCEQEquip(rowid),"^",38)'=1)
	.;计提折旧
	.s result=..GenerateMonthDepre(rowid, DepreMonth, +$H, DepreTypeDR, "N", "0", "")
	.
	.s node="Success"
	.i result'=0  d
	..s node="Error"
	..s errCount=errCount+1
	.s ^DHCEQTemp("MonthDepreLog",DepreMonth,node,rowid,DepreTypeDR)=$H_"^"_result
	.
	.s ^DHCEQLog(0,"MonthDepreLog",DepreMonth,DepreTypeDR,Times,node,rowid)=$H_"^"_result
	s ^DHCEQLog(0,"MonthDepreLog",DepreMonth,DepreTypeDR,Times,"End")=$H
	q errCount
}

/// 生成一个设备在月度折旧
/// EquipID:设备id
/// Month：折旧月份格式（2006-06）
/// DepreMonthDate：折旧月份日期，格式为数字  
/// DepreTypeDR：1固定的系统主折旧  其他对应的折旧类型ID
/// UseTrans: 使用事务 "Y" "N"
/// DepreType 0:正常按月计提1:设备报废一次性计提2:设备附件报废一次性计提附件未计提值
/// AffixID: 附件ID，用于附件报废时，一次性计提附件未提折旧
/// DepreDate：计提日期
/// DepreTime：计提时间
/// 返回值：result:0 成功  	
/// 		-1001(没有对应的折旧设置)；-1002(设置的折旧方法无效)；-1003(设置的折旧年限或折旧率无效)
/// 		-1004插入月度折旧失败;-1005更新折旧设置失败;-1006更新设备台帐失败
/// 		-1007插入生命周期信息失败；-1008插入折旧分摊信息失败
ClassMethod GenerateMonthDepre(EquipID, Month, DepreMonthDate, DepreTypeDR, UseTrans, DepreType, AffixID)
{
	s User=1 // ##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	
	n (User,EquipID,Month,DepreMonthDate ,DepreTypeDR, UseTrans, DepreType, AffixID)
	;获取设备折旧设置信息
	s vDate=Month_"-01"
	s vDate=$zdh(vDate,3)	
	s DepreSetInfo=..GetDepreSetInfo(EquipID, vDate, DepreTypeDR,"0")
	s FundsDepreInfo=$p(DepreSetInfo,"&",2)
	s DepreSetInfo=$p(DepreSetInfo,"&",1)
	i DepreSetInfo<0 q DepreSetInfo
	
	s depreSetID=$p(DepreSetInfo,"^",2)
	s mainFlag="N"
	i DepreTypeDR =1 s mainFlag="Y"
	i depreSetID="" q "-1001"
	s depreMethodType=$p(DepreSetInfo,"^",5)
	s depreMethodDR=$p(DepreSetInfo,"^",6)
	s years=$p(DepreSetInfo,"^",7)
	s rate=$p(DepreSetInfo,"^",8)
	s depreTotal=$p(DepreSetInfo,"^",9)
	s depreTotalFee=$p(DepreSetInfo,"^",10)		//累计折旧总费用
	s depreFee=$p(DepreSetInfo,"^",3)
	;DepreMonths折旧月份不为1，不需折旧
	i $p(DepreSetInfo,"^",4)'=1 q 0	;DepreMonths
	s curDate=+$H
	s curTime=$P($H,",",2)
	
	s originalFee=$p($g(^DHCEQEquip(EquipID)),"^",27)		//原值
	s netFee=$p($g(^DHCEQEquip(EquipID)),"^",28)			//净值
	s netRemainFee=$p($g(^DHCEQEquip(EquipID)),"^",29)	//净残值
	//设备报废一次性计提
	i (DepreType=1)
	{
		//当折旧方法为平均年限法时计提
		i (depreMethodType=1) s depreFee=originalFee-netRemainFee-depreTotalFee
		i depreFee<0 s depreFee=0		
	}
	elseif ((DepreType=2))	//报废附件一次性计提
	{
		//当折旧方法为平均年限法时计提
		i (depreMethodType=1)	s depreFee=##class(web.DHCEQMonthDepre).GetAffixDepreAmount(AffixID,years,depreTotal)
	}
	else   //正常计提
	{
		//当月尚未计提才计提
		i ($o(^DHCEQMonthDepre(0,"SetMonth",depreSetID,Month,0))'="") q 0  
	}
	i depreFee>0 
	{
		s depreFee=$Number(depreFee,2)
	}
	else
	{
		q depreFee
	}
	
	//获取当月工作量
	s totalworkload=##class(web.DHCEQMonthDepre).GetTotalWorkLoad(EquipID,Month)
	//准备折旧数据
	s PLIST(2)=EquipID
	s PLIST(3)=depreSetID
	s PLIST(4)=mainFlag
	s PLIST(5)=depreMethodDR
	s PLIST(6)=originalFee
	s PLIST(7)=Month
	s PLIST(8)=$p(^DHCEQEquip(EquipID),"^",36) // 工作总量
	s PLIST(9)=$p(^DHCEQEquip(EquipID),"^",37) //单位
	s PLIST(10)=years
	s depreTotal=depreTotal+1
	s PLIST(11)=depreTotal //总折旧月份
	//s PLIST(12)=
	s depreTotalFee=depreTotalFee+depreFee
	s PLIST(13)=depreTotalFee
	s PLIST(14)=totalworkload
	s PLIST(15)=depreFee
	
	;Modified by jdl 增加一种折旧设置 2011-8-1 JDL0088
	;s PLIST(18)=netFee //$p(result,"^",28) //设备净值
	s PLIST(18)=originalFee-depreTotalFee
	
	s PLIST(19)=netRemainFee //设备净残值
	s PLIST(20)="N"
	s PLIST(21)="1" //状态
	s PLIST(22)="新财务制度补提折旧"   //modify by lmm 2018-12-07  补提折旧备注
	//s PLIST(23)=User
	s PLIST(24)=curDate
	s PLIST(25)=curTime
	//s PLIST(26)=User
	s PLIST(27)=curDate
	s PLIST(28)=curTime
	//s PLIST(29)=User
	s PLIST(30)=curDate
	s PLIST(31)=curTime
	s PLIST(32)=DepreType
	s PLIST(33)=AffixID
	
	s PLIST(34)=$p(^DHCEQEquip(EquipID),"^",67)	///StoreLocDR
	s PLIST(35)=$p(^DHCEQEquip(EquipID),"^",82)	///CommonFlag共用标志
	//s PLIST(36)= 	///AllotType分摊方式
	s PLIST(37)=DepreTypeDR		///DepreTypeDR折旧类型(主折旧、修购基金、核算折旧等)
	s PLIST(38)=rate			///DepreRate折旧率
	s PLIST(39)=$p(^DHCEQEquip(EquipID),"^",17)	///ManageLocDR管理部门
	
	//开始事务
	i UseTrans="Y"	{TSTART}
	//生成月度折旧
	&SQL(Insert Into SQLUSER.DHC_EQMonthDepre Values :PLIST())
	i SQLCODE 
	{
		i UseTrans="Y"	{TROLLBACK}
		q -1004
	}
	s MonthDepreDR=$G(%ROWID)
	//更新折旧设置表中的上次折旧月份
	&SQL(update sqluser.DHC_EQDepreSet set DS_PreDepreMonth=:Month,DS_DepreTotal=:depreTotal,DS_DepreTotalFee=:depreTotalFee where DS_RowID=:depreSetID)
	i SQLCODE 
	{
		i UseTrans="Y"	{TROLLBACK}
		q "-1005"
	}
	s FTRowID=0
	s CADError=0
	k CAD
	;FundsID_"^"_FundsType_"^"_FundsDepreFee_"^"_FundsDepreTotalFee
	;资金折旧信息,没有资金折旧信息的,则将折旧信息均记录在自有资金上
	s SelfFundsType=##class(web.DHCEQCommon).GetSysInfo("990015")
	s NewFundsDepreInfo=FundsDepreInfo
	i NewFundsDepreInfo=""  d
	.s NewFundsDepreInfo="^"_SelfFundsType_"^"_depreFee_"^^"_originalFee
	s Len=$l(NewFundsDepreInfo,"#")
	;获取共用分摊设置ID
	s CostRowID=""	
	i $p(^DHCEQEquip(EquipID),"^",82)="Y"  d
	.s CostRowID=$o(^DHCEQCostAllot(0,"EquipType",EquipID,1,0))
	;折旧分摊
	s CAD(2)=1
	s CAD(3)=MonthDepreDR
	
	for i=1:1:Len  q:(CADError'=0)  d
	.;FundsID_"^"_FundsType_"^"_FundsDepreFee_"^"_FundsDepreTotalFee_"^"_FundsFee
	.s FundsInfo=$p(NewFundsDepreInfo,"#",i)
	.s FTRowID=$p(FundsInfo,"^",2)
	.s FundsDepreFee=$p(FundsInfo,"^",3)
	.s FundsDepreTotalFee=$p(FundsInfo,"^",4)		//Add By DJ 2015-11-18
	.s FundsFee=$p(FundsInfo,"^",5)
	.s RemainFundsDepreFee=FundsDepreFee
	.
	.s CAD(7)=FundsFee
	.s CAD(8)=FTRowID
	.s CAD(9)=FundsDepreTotalFee		//Add By DJ 2015-11-18
	.s CostListCount=0
	.;为共用设备，且存在折旧分摊设置
	.i CostRowID'=""  d
	..s CostListID=0
	..f  s CostListID=$o(^DHCEQCostAllotList(0,"CostAllotDR",CostRowID,CostListID)) q:(CostListID="")||(CADError'=0)  d
	...s CostListCount=CostListCount+1
	...s CostType=$p($g(^DHCEQCostAllot(CostRowID)),"^",14)		//Add By DJ 2016-08-11 begin
	...s CostValueCount=$p($g(^DHCEQCostAllot(CostRowID)),"^",16)	//分摊总和
	...s CostLoc=$p($g(^DHCEQCostAllotList(CostListID)),"^",2)
	...i CostType=0  d
	....s CostRate=$p($g(^DHCEQCostAllotList(CostListID)),"^",3)
	...e  d
	....s CostValue=$p($g(^DHCEQCostAllotList(CostListID)),"^",5)
	....s CostRate=$fn((CostValue/CostValueCount)*100,"",2)		//Add By DJ 2016-08-11 end
	...s CAD(4)=CostLoc
	...s CAD(5)=CostRate
	...;非最后一条的,直接按比例计算，否则取剩余资金折旧
	...i $o(^DHCEQCostAllotList(0,"CostAllotDR",CostRowID,CostListID))'=""  d
	....s CAD(6)=##Class(web.DHCEQCommon).FormatNumber((FundsDepreFee*(CostRate/100)),"",2)
	....s RemainFundsDepreFee=RemainFundsDepreFee-CAD(6)
	...e  d
	....s CAD(6)=RemainFundsDepreFee
	...q:CAD(6)'>0
	...&SQL(Insert Into SQLUSER.DHC_EQCostAllotDetail Values :CAD())
	...i SQLCODE s CADError=1
	.;1.非共用设备 2无分摊设置 3.有分摊折旧设置却无分摊明细的
	.;以上3种直接计入各资金来源对应的折旧中
	.i CostListCount=0  d
	..s CAD(4)=$p(^DHCEQEquip(EquipID),"^",67)
	..s CAD(6)=##Class(web.DHCEQCommon).FormatNumber((FundsDepreFee),"",2)
	..&SQL(Insert Into SQLUSER.DHC_EQCostAllotDetail Values :CAD())
	..i SQLCODE s CADError=1
		
	;"插入折旧分摊明细失败"
	i CADError'=0
	{
		i UseTrans="Y"	{TROLLBACK}
		q -1008
	}
	
	i (mainFlag="Y")
	{
		/****************************************************************/  //2009-08-10 党军 begin DJ0023
		s LI(2)=EquipID  //设备
		s LI(4)=$p($g(^DHCEQEquip(EquipID)),"^",19)   //原使用科室
		s LI(5)=$p($g(^DHCEQEquip(EquipID)),"^",17) //原管理科室
		s LI(6)=$p($g(^DHCEQEquip(EquipID)),"^",67)  //原库房
		s LI(7)=originalFee  //原值
		s LI(8)=netFee  //原净值
		s LI(16)=curDate	//变动日期
		s LI(17)=curTime	//变动时间
		s LI(18)=depreFee //折旧费用 //2009-08-13 党军
		s LI(19)="P"	//生命周期类型
		s LI(20)=35	//来源类型
		s LI(21)=MonthDepreDR	//来源ID
		//s LI(27)=User	//更新人
		s LI(28)=curDate	//更新日期
		s LI(29)=curTime	//更新时间
		
		//更新设备的净值、累计折旧
		s hasdepreflag="N"
		s netFee=netFee-depreFee
		i netFee<netRemainFee s netFee=netRemainFee
		i netFee'>netRemainFee s hasdepreflag="Y"
		
		&SQL(update sqluser.DHC_EQEquip set EQ_NetFee=:netFee,EQ_DepreTotalFee=:depreTotalFee,EQ_HasDepreFlag=:hasdepreflag where EQ_RowID=:EquipID)
		i SQLCODE 
		{
			i UseTrans="Y"	{TROLLBACK}
			q "-1006"
		}
		/***************************************************************/
		s LI(9)=$p($g(^DHCEQEquip(LI(2))),"^",19)   //变动后使用科室
		s LI(10)=$p($g(^DHCEQEquip(LI(2))),"^",17) //变动后管理科室
		s LI(11)=$p($g(^DHCEQEquip(LI(2))),"^",67)  //变动后库房
		s LI(12)=originalFee  //变动后原值
		s LI(13)=netFee  //变动后净值
		&sql(Insert Into SQLUSER.DHC_EQLifeInfo Values :LI())
		i SQLCODE
		{
			i UseTrans="Y" {TRollBack}
			q "-1007"
		}
		
	}
	;modified by zy 2013-07-30 zy0108
	;有其他折旧类型的秀还DHCEQFundsDepreInfo中的累计折旧;
	;更新资金来源对应的累计折旧
	i FundsDepreInfo'=""
	{
		s Len=$l(FundsDepreInfo,"#")
		for i=1:1:Len
		{
			;FundsID_"^"_FundsType_"^"_FundsDepreFee_"^"_FundsDepreTotalFee
			s FundsInfo=$p(FundsDepreInfo,"#",i)
			s FundsID=$p(FundsInfo,"^",1)
			s FundsDepreFee=$p(FundsInfo,"^",3)
			s FundsDepreTotalFee=$p(FundsInfo,"^",4)
			
			//modify by lmm 2018-01-31 LMM0033
			i DepreTypeDR'="1" d
			.s FundsDepreInfoID=$o(^DHCEQFundsDepreInfo(0,"DepreTypeFunds",DepreTypeDR,FundsID,""))
			.i FundsDepreInfoID'=""  d
			..&SQL(update sqluser.DHC_EQFundsDepreInfo set FD_DepreTotalFee=:FundsDepreTotalFee where FD_RowID=:FundsDepreInfoID)
			.e  d
			..&SQL(insert into sqluser.DHC_EQFundsDepreInfo set FD_FundsDR=:FundsID,FD_DepreTypeDR=:DepreTypeDR,FD_DepreTotalFee=:FundsDepreTotalFee)
			e  d
			.&SQL(update sqluser.DHC_EQFunds set F_DepreTotal=:FundsDepreTotalFee where F_RowID=:FundsID)
			i SQLCODE s errCount=errCount+1
		}
	}
	;Mozy0089	2012-10-17
	Set SQLCODE=##Class(web.DHCEQBusinessCommon).GetBillInfoStr(10, MonthDepreDR)
	If SQLCODE
	{
		If UseTrans="Y" {TRollBack}
		Quit "-1007"
	}
	i UseTrans="Y" {TCOMMIT}
	q 0
}

/// Add by JDL 2011-2-22
/// 根据设备ID及折旧类型获取折旧信息
/// 入参：	EquipID:设备ID
/// 			vDate：要折旧的日期
/// 			DepreTypeDR：折旧类型，1为系统主折旧，其他为其他的折旧
/// 			TotalFlag：0:取vDate当月折旧，1:取vDate以前所有折旧(主要用于初始化折旧数据用)
/// 返回值：正确返回：0^DepreSetID^DepreFee^DepreMonths^DepreMethodType^DepreMethodDR^Years^Rate^DepreTotal^DepreTotalFee
/// 		失败返回如下：
/// 		-1001(没有对应的折旧设置)；
/// 		-1002(设置的折旧方法无效)；
/// 		-1003(设置的折旧年限或折旧率无效)
/// 			
ClassMethod GetDepreSetInfo(EquipID, vDate As %Library.String = "", DepreTypeDR As %Library.String = "1", TotalFlag As %Library.String = "0")
{
	n (EquipID,vDate,DepreTypeDR,TotalFlag)
	;n DepreSetID,DepreMethodDR,DepreMethodType
	//modified by czf 20170828
	//增加参数判断折旧日期以转资日期还是启用日期为准
	s DepreDateFlag=##class(web.DHCEQCommon).GetSysInfo("990061")
	;取该设备的对应的相应的折旧设置
	s DepreSetID=$o(^DHCEQDepreSet(0,"Source",DepreTypeDR,0,EquipID,0))
	;没有相应的折旧设置
	i DepreSetID="" q -1001
	
	;获取折旧方法信息
	s DepreMethodDR=$p($g(^DHCEQDepreSet(DepreSetID)),"^",2)
	i DepreMethodDR="" q -1002
	s DepreMethodType=+$p($g(^DHCEQCCode("DHCEQCDepreMethod",DepreMethodDR)),"^",1)
	s DepreTotal=$p($g(^DHCEQDepreSet(DepreSetID)),"^",22)
	s DepreTotalFee=$p($g(^DHCEQDepreSet(DepreSetID)),"^",23)
	s Years=$p($g(^DHCEQDepreSet(DepreSetID)),"^",24)
	s MainFlag=$p($g(^DHCEQDepreSet(DepreSetID)),"^",3)  //add by lmm 2018-01-10	
	s Rate=""
	
	s FundsDepreInfo=""
	
	;初始化，恢复累计折旧为0
	i TotalFlag="1"
	{
		s DepreTotal=0
		s DepreTotalFee=0
	}
	
	;获取设备原值信息
	s OriginalFee = $p($g(^DHCEQEquip(EquipID)),"^",27)
	s NetRemainFee = $p($g(^DHCEQEquip(EquipID)),"^",29)
	i DepreDateFlag=1
	{
		s StartDate=$P(^DHCEQEquip(EquipID),"^",44)	///启用日期  modified by czf 20170828
	}
	elseif (DepreDateFlag="0")||(DepreDateFlag="")	
	{
		s StartDate=$P(^DHCEQEquip(EquipID),"^",45)	///转资日期  modified by czf 2010828
	}
	s UsedMonths=##Class(web.DHCEQMonthDepre).GetMonthDiffrent(StartDate,vDate)
	
	if TotalFlag="0"
	{
		s DepreMonths=1
	}
	else
	{
		s DepreMonths=UsedMonths
	}
	
	s DepreFee=0
	s HasDepreFlag="N"
	
	;获取剩余需要计提的净值
	s DepreNetFee=OriginalFee-NetRemainFee-DepreTotalFee
	;计提完成的返回折旧费0
	i DepreNetFee'>0 q 0_"^"_DepreSetID_"^"_DepreFee_"^0"
	
	;Modified By JDL 20150811 ZX0024 计算折旧月份时，无形资产因入库当月计提，应增加一个月
	s EquipTypeDR=","_$p($g(^DHCEQEquip(EquipID)),"^",63)_","  //add by zx 2015-04-28 昆医附一无形资产折旧
	s WXEquipTypeDRs=","_##class(web.DHCEQCommon).GetSysInfo("990023")_","
	if WXEquipTypeDRs[EquipTypeDR 
	{
		s UsedMonths=UsedMonths+1
		i TotalFlag'="0"
		{
			s DepreMonths=UsedMonths
		}
	}
	;折旧月份比入库月份大,才计算折旧金额,即入库下月才开始计提
	if UsedMonths>0
	{
		if DepreMethodType=1
		{
			;1:平均年限法
			;设置的使用年限无效
			i +Years'>0 q -1003
			//add by zy 20150610 ZY0128  //增加的折旧月份数
			s AddDepreMonths=+##Class(web.DHCEQChangeAccount).GetAddDepreTotalNum(EquipID)
			s Months=12*Years-DepreTotal+AddDepreMonths
			;s Months=12*Years-DepreTotal
			
			i Months<1 s Months=1			
			
			i DepreMonths>Months s DepreMonths=Months
			s DepreFee=DepreNetFee*DepreMonths/Months
			i DepreFee>DepreNetFee s DepreFee=DepreNetFee			
		}
		elseif DepreMethodType="2" 
		{
			;2:不计提折旧
			;s DepreFee=0
			s DepreMonths=0
		}
		elseif DepreMethodType="3" 
		{
			;3:根据折旧率计提			
			;获取对应的折旧率			
			i UsedMonths>0
			{
				s DetailID=0
				f  s DetailID=$o(^DHCEQDepreSetDetail(0,"DepreSet",DepreSetID,DetailID))  quit:((DetailID="")||(Rate'=""))  d
				.s FromYear=$p($g(^DHCEQDepreSetDetail(DetailID)),"^",3)
				.q:(UsedMonths<(FromYear*12))
				.s ToYear=$p($g(^DHCEQDepreSetDetail(DetailID)),"^",4)
				.q:(UsedMonths>(ToYear*12))&&(ToYear'="")
				.s Rate=$p($g(^DHCEQDepreSetDetail(DetailID)),"^",5)
			}
			;折旧率设置无效
			i Rate="" q -1003
			
			s DepreFee=OriginalFee*Rate*DepreMonths/100
			i DepreFee>DepreNetFee
			{
				s DepreFee=DepreNetFee
				s DepreMonths=DepreFee\(OriginalFee*Rate/100)
				i (DepreFee#(OriginalFee*Rate/100))'=0 s DepreMonths=1+DepreMonths 
			}			
		}
		elseif DepreMethodType="4" 
		{
			;4:一次性计提
			s DepreMonths=1
			s DepreFee=DepreNetFee
		}
		else
		{
			//设置的折旧方法无效
			q -1002
		}
	}
		
	i DepreFee>0
	{
		s DepreFee=$Number(DepreFee,2)
		i +DepreFee=+DepreNetFee s HasDepreFlag="Y"
		d GetFundsInfo
	}
	else
	{
		s DepreFee=0
		s DepreFee=$Number(DepreFee,2)		
	}
	
	
	q 0_"^"_DepreSetID_"^"_DepreFee_"^"_DepreMonths_"^"_DepreMethodType_"^"_DepreMethodDR_"^"_Years_"^"_Rate_"^"_DepreTotal_"^"_DepreTotalFee_"^"_MainFlag_"&"_FundsDepreInfo
GetFundsInfo
	s FundsID=0
	s RemainDepreFee=DepreFee
	f  s FundsID=$o(^DHCEQFunds(0,"Source",1,EquipID,FundsID)) q:(FundsID="")  d
	.q:$p(^DHCEQFunds(FundsID),"^",10)="Y"		;F_InvalidFlag
	.q:$p(^DHCEQFunds(FundsID),"^",6)="2"		;F_OperFlag
	.s FundsType=$p(^DHCEQFunds(FundsID),"^",2)
	.;i FundsType="" s FundsType=SelfFundsType
	.s FundsFee=+$p($g(^DHCEQFunds(FundsID)),"^",3)
	.s FundsDepreTotalFee=+$p($g(^DHCEQFunds(FundsID)),"^",13)
	.
	.;add by zy 2013-07-30 zy0108
	.;有其他折旧类型的取DHCEQFundsDepreInfo中的记录;
	.i MainFlag'="Y" d
	..s FundsDepreInfoID=$o(^DHCEQFundsDepreInfo(0,"DepreTypeFunds",DepreTypeDR,FundsID,0))
	..i FundsDepreInfoID'="" s FundsDepreTotalFee=+$p($g(^DHCEQFundsDepreInfo(FundsDepreInfoID)),"^",3)
	..i FundsDepreInfoID="" s FundsDepreTotalFee=0  //add by lmm 2018-02-08 LMM0033	
	.
	.;初始化,恢复该资金累计折旧金额为0
	.i TotalFlag="1"  d
	..s FundsDepreTotalFee=0
	.
	.;Modified by JDL 2012-3-8 JDL0121  处理资金来源分配折旧不准确的问题
	.s FundsNetFee=FundsFee-FundsDepreTotalFee
	.i FundsNetFee<0 s FundsNetFee=0
	.
	.;最后一个资金来源时,取剩余折旧额,作为该资金来源的折旧金额
	.i $o(^DHCEQFunds(0,"Source",1,EquipID,FundsID))=""  d
	..s FundsDepreFee=RemainDepreFee
	.e  d
	..i DepreMethodType=1  d
	...;平均年限法
	...i HasDepreFlag="Y"  d
	....s FundsDepreFee=FundsNetFee		;Modified by JDL 2012-3-8 JDL0121
	...e  d
	....s FundsDepreFee=FundsNetFee*DepreMonths/Months	;Modified by JDL 2012-3-8 JDL0121
	..e  i DepreMethodType=2  d
	...;不计提折旧
	..e  i DepreMethodType=3  d
	...;3:根据折旧率计提
	...i HasDepreFlag="Y"  d
	....s FundsDepreFee=FundsNetFee		;Modified by JDL 2012-3-8 JDL0121
	...e  d
	....s FundsDepreFee=FundsFee*DepreMonths*Rate/100
	..e  i DepreMethodType=4  d
	...;4:一次性计提
	...s FundsDepreFee=FundsFee
	.s FundsDepreFee=$Number(FundsDepreFee,2) 
	.s RemainDepreFee=RemainDepreFee-FundsDepreFee
	.s FundsDepreTotalFee=FundsDepreTotalFee+FundsDepreFee
	.i FundsDepreInfo'="" s FundsDepreInfo=FundsDepreInfo_"#"
	.s FundsDepreInfo=FundsDepreInfo_FundsID_"^"_FundsType_"^"_FundsDepreFee_"^"_FundsDepreTotalFee_"^"_FundsFee
	
	q
}

/// modified by zy zy 2013-06-04 zy0107
/// 增加参数判断折旧是否包含预报废设备，直接取EQ_Hold8字段的值来判断
/// 检测设备是否在本次折旧范围
/// 入参：EquipID	设备ID
/// 		 EquipTypeIDS：设备类组
/// 		 DepreFlag：预报废设备折旧标识:0:计提;1:不计提
/// 返回：1要折旧
/// 		 0不折旧
/// w ##Class(web.DHCEQMonthDepre).CheckNeedDepre(2,"","0")
ClassMethod CheckNeedDepre(EquipID, EquipTypeIDS, DepreFlag As %Library.String = "")
{
	n EquipType,EQStatus,DisuseDate
	//Add By DJ 2016-01-28 begin
	s DepreBussIDs=","_##class(web.DHCEQCommon).GetSysInfo("990041")_","
	s EQStatus=+$p(^DHCEQEquip(EquipID),"^",38)
	s EQStockStatus=+$p(^DHCEQEquip(EquipID),"^",60)
	i ((EQStatus=0)&&(EQStockStatus=0)) q 0   //验收设备不计提折旧
	//modified by czf 20170828
	//增加参数判断折旧日期以转资日期还是启用日期为准
	s DepreDateFlag=##class(web.DHCEQCommon).GetSysInfo("990061")
	i DepreDateFlag=1
	{
		i ((EQStatus=0)&&(EQStockStatus=1)) q 0   //在库设备不计提折旧    //modified by czf 20170828
	}
	else
	{
		i ($p(^DHCEQEquip(EquipID),"^",45)="") q 0   //未入账设备不计提折旧    //Mozy	2017-10-12 464480
	}
	s EQInvalidFlag=$p(^DHCEQEquip(EquipID),"^",59)
	//退货,减少--1当月退货不提，4当月减少不提
	//Modify DJ  2017-12-08
	i EQStockStatus=3
	{
		i ((DepreBussIDs[",1,")&&(DepreBussIDs[",4,")) q 0
		i '$D(^DHCEQLifeInfo(0,"EquipSourceDate",EquipID,23)) q 0
		s LIDate=$o(^DHCEQLifeInfo(0,"EquipSourceDate",EquipID,23,""),-1)
		i 0=##Class(web.DHCEQReport).IsCurReportMonth(LIDate) q 0
		i ((DepreBussIDs[",1,")||(DepreBussIDs[",4,"))		//1当月退货不提，4当月减少不提
		{
			s LIRowID=$o(^DHCEQLifeInfo(0,"EquipSourceDate",EquipID,23,LIDate,0))
			s LISourceID=$p($g(^DHCEQLifeInfo(LIRowID)),"^",20)
			s RRowID=$p($g(^DHCEQReturnList(LISourceID)),"^",1)
			s ReturnTypeDR=$p($g(^DHCEQReturn(RRowID)),"^",17)
			s ReturnTypeCode=$p($g(^DHCEQCCode("DHCEQCOutType",ReturnTypeDR)),"^",1)
			i (DepreBussIDs[",1,")&&(ReturnTypeCode="TH") q 0
			i (DepreBussIDs[",4,")&&(ReturnTypeCode'="TH") q 0
		}
	}
	//报废---3当月报废不提
	i EQStatus=3
	{
		i (DepreBussIDs[",3,") q 0
		s DisuseDate=$p(^DHCEQEquip(EquipID),"^",89)
		//i '$D(^DHCEQLifeInfo(0,"EquipSourceDate",EquipID,34)) q 0
		//s LIDate=$o(^DHCEQLifeInfo(0,"EquipSourceDate",EquipID,34,""),-1)
		i 0=##Class(web.DHCEQReport).IsCurReportMonth(DisuseDate) q 0
	}
	//数据调整--2当月删除数据类型的数据调整不提
	i EQInvalidFlag="Y"
	{
		i (DepreBussIDs[",2,") q 0
		s ADFlag=0
		i '$D(^DHCEQLifeInfo(0,"EquipSourceDate",EquipID,61)) q 0
		s LIDate=0
		f  s LIDate=$o(^DHCEQLifeInfo(0,"EquipSourceDate",EquipID,61,LIDate))  q:(LIDate="")||(ADFlag'=0)  d
		.q:##Class(web.DHCEQReport).IsCurReportMonth(LIDate)=0
		.s LIRowID=0
		.f  s LIRowID=$o(^DHCEQLifeInfo(0,"EquipSourceDate",EquipID,61,LIDate,LIRowID))  q:(LIRowID="")||(ADFlag'=0)  d
		..s LISourceID=$p($g(^DHCEQLifeInfo(LIRowID)),"^",20)
		..s ADRowID=$p($g(^DHCEQAdjustDataList(LISourceID)),"^",1)
		..s ADType=$p($g(^DHCEQAdjustData(ADRowID)),"^",1)
		..q:ADType'=3   //删除数据
		..s ADReportFlag=$p($g(^DHCEQAdjustData(ADRowID)),"^",2)    //modified by czf 2017-05-25 是否影响报表
		..q:ADReportFlag'="Y"
		..s ADFlag=1
		
		q ADFlag
	}
	;过滤掉类组
	s EquipType=$p(^DHCEQEquip(EquipID),"^",63) 
	i (EquipTypeIDS'="")&&(EquipTypeIDS'[(","_EquipType_",")) q 0
	
	//add by lmm 2018-12-29 begin   补提折旧过滤无形资产
	s WXEquipTypeDRs=","_##class(web.DHCEQCommon).GetSysInfo("990023")_","
	i (WXEquipTypeDRs'="")&&(WXEquipTypeDRs[(","_EquipType_",")) q 0

	//add by lmm 2018-12-29 end

	;过滤掉不计提的??
	;s GuaranteeFlag=$p(^DHCEQEquip(rowid),"^",46)
	;q:GuaranteeFlag="N"
	//modified by zy 2013-06-04 zy0107
	//增加参数判断折旧是否包含预报废设备，直接取EQ_Hold8字段的值来判断
	//midified by zy 2015-7-1 ZY0134 
	i (DepreFlag=1)&($p(^DHCEQEquip(EquipID),"^",93)="2")
	{
		;根据系统参数，预报废是否计提折旧，如不计提，则不提
		;待确定 预报废当月是否计提
		q 0
	}
	/*
	;报废状态的过滤
	i (+$p(^DHCEQEquip(EquipID),"^",38))>2 q 0
	
	//modified by zy 2013-06-04 zy0107
	//增加参数判断折旧是否包含预报废设备，直接取EQ_Hold8字段的值来判断
	i (DepreFlag=1)&($p(^DHCEQEquip(EquipID),"^",93)="Y") q 0
	*/
	
	q 1
}

/// add by lmm 2019-01-02
/// 描述：财务制度调整，数据调整体现在1月期初
/// MonthReportType  1：衔接报表 2： 1月月报
/// d ##Class(web.DHCEQFinance2019).MonthReport(2)
ClassMethod MonthReport(MonthReportType)
{
	s Date=$H
	s Node="MonthReport"
	s Result=""
	s ^DHCEQLog("Job",Node,Date,"Begin")=$H
	;取前一天所属的会计月份
	s ReportDate=+Date-1  
	s MonthStr=##Class(web.DHCEQReport).GetReportMonthByDate(ReportDate)
	
	//实物月报
	s Result= ##class(web.DHCEQFinance2019).SaveMonthReport(MonthStr,"","","0",MonthReportType)  //modify by lmm 2019-01-03  增加月报类型参数
	//财务月报
	//s Result= ##class(web.DHCEQReport).SaveMonthReport(MonthStr,"","","1")
	s ^DHCEQLog("Job",Node,Date,"Result")=Result
	s ^DHCEQLog("Job",Node,Date,"End")=$H
}

/// w ##Class(web.DHCEQFinance2019).SaveMonthReport()
ClassMethod SaveMonthReport(MonthStr, EquipTypeIDs As %Library.String = "", FundsTypeDR As %String = "", AccountShape As %String = "0", MonthReportType)
{
	new StartDate,EndDate,Year,Month,User
	i MonthStr="" q 0

	s StartDate=##Class(web.DHCEQReport).GetReportDate(MonthStr,"","")
	s EndDate=$p(StartDate,"^",2)
	s StartDate=$p(StartDate,"^",1)
	;s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	s User=1
	
	s Year=+$p(MonthStr,"-",1)
	s Month=+$p(MonthStr,"-",2)
	d ##Class(web.DHCEQFinance2019).FillStatListInfo(User, Year, Month, StartDate, EndDate,EquipTypeIDs,FundsTypeDR,AccountShape,MonthReportType) //modify by lmm 2019-01-03
	
	
	q ##Class(web.DHCEQFinance2019).SaveMonthReportList(User, Year, Month, StartDate, EndDate, MonthStr,EquipTypeIDs,AccountShape,MonthReportType) //modify by lmm 2019-01-03
}

/// ----------------------------------
/// Modified by jdl 2011-12-28 JDL0107
/// 
/// ----------------------------------
/// 创建：jdl 2009-08-4 JDL0021
/// 描述：根据起始终止日期汇总当月月结数据记录在^DHCEQTemp("MonthReport","List",User,$J,Year,Month)
/// 访问表:无
/// 输入：User:操作员
/// 	  Year:年
/// 	  Month:月
/// 	  StartDate:开始日期
/// 	  EndDate:结束日期
/// 	  EquipTypeIDs:类组Ids
/// 输出：无
/// 返回：成功返回空，否则返回出错信息
/// 备注：
/// w ##Class(web.DHCEQReport).FillStatListInfo(1,"2017","08",64496,64526,"1","","1")
ClassMethod FillStatListInfo(User, Year, Month, StartDate, EndDate, EquipTypeIDs As %Library.String = "", FundsTypeDR As %String = "", AccountShape As %String = "0", MonthReportType)
{
	new PreYear,PreMonth,Loc,StatCat,BillDate,type,tmpfee,StoreLoc,listInfo
 	new StockBegin,StockIn,StockReturn,StockReduce,StockMoveOut,StockMoveIn,StockEnd,UsedBegin,UsedIn,UsedReturn,UsedMoveIn,UsedMoveOut,Disused,UsedEnd,TotalEnd
 	new ChangeAccount,Origin,EquipType
 	;折旧总额,当月折旧,在库报废,库房转移(入),库房转移(出)
 	new TotalDepre,Depre,StockDisused,StoreMoveIn,StoreMoveOut 
 	new StockStatus,MonthDepreID,MonthStr
 	new ListRowID,OutType,OutTypeCode,EquipID,InStockListID
 	new NetFee
 	
 	;Add by JDL 2011-6-22 JDL0086
 	new StockChangeAccount,UsedReduce,StockOther,UsedOther
 	new AdjustType
 	
 	;Add by JDL 2011-12-28 JDL0107
 	new FundsType,SelfFundsType,FundsID,RemainOriginalFee,RemainDepreTotal,RemainNetFee,FundsFee
 	new SourceType,SourceID
 	;Add By DJ 2015-01-21 DJ0135
 	new StockCATotalDepre,UsedCATotalDepre
 	
 	s SelfFundsType=##class(web.DHCEQCommon).GetSysInfo("990015")
	
	k ^DHCEQTemp("MonthReport","List",User,$J,Year,Month)
	;s ^DHCEQTemp("jdl")=User_","_ Year_","_ Month_","_ StartDate_","_ EndDate_","_ EquipTypeIDs_","_ FundsTypeDR	
	if (Month=1)
	{	s PreYear=Year-1
		s PreMonth=12}
	else
	{	s PreYear=Year
		s PreMonth=Month-1}
	
	;0:验收明细 1:设备 2:附件 3:入库明细 4:转移明细 5:退货明细 6:报废明细 7:调账明细
	s SourceType="3"
	//汇总入库信息
	s EquipType=0
	f  s EquipType=$o(^DHCEQInStock(0,"TypeDate",EquipType)) q:EquipType=""  d
	.q:##Class(web.DHCEQCommon).IdInIds(EquipType,EquipTypeIDs)=0
	.s BillDate=StartDate-1
	.//入账时间可能是在入库之后的跨月,开始日期需要看所有入库单
	.i AccountShape="1" s BillDate=0
	.f  s BillDate=$o(^DHCEQInStock(0,"TypeDate",EquipType,BillDate)) q:((BillDate="")||(BillDate>EndDate))  d
	..s rowid=0
	..f  s rowid=$o(^DHCEQInStock(0,"TypeDate",EquipType,BillDate,rowid)) q:(rowid="")  d
	...s ISInvalidFlag=$p($g(^DHCEQInStock(rowid)),"^",25)   //Add By CZF 2016-12-07 begin
	...q:ISInvalidFlag="Y"
	...s ISStatus=$p($g(^DHCEQInStock(rowid)),"^",10)
	...q:ISStatus'=2		//Add By CZF 2016-12-07 end
	...s ISNo=$p($g(^DHCEQInStock(rowid)),"^",14) //2011-07-22 DJ
	...q:ISNo="" //2011-07-22 DJ
	...//增加入账形式的参数，当AccountShape=1的时候只显示已经入账的入库单
	...q:(AccountShape=1)&(##Class(web.DHCEQAccountList).AccountFlag(rowid,SourceType,StartDate,EndDate)=0)
	...s StoreLoc=$p($g(^DHCEQInStock(rowid)),"^",2)
	...s Origin=$p($g(^DHCEQInStock(rowid)),"^",15)
	...s ListRowID=0
	...d InitStatInfoVariant
	...f  s ListRowID=$o(^DHCEQInStockList(0,"InStock",rowid,ListRowID)) q:(ListRowID="")  d
	....q:$p($g(^DHCEQInStockList(ListRowID)),"^",22)'=""	// Mozy0217  2018-11-01	过滤设备配置的入库明细
	....s StatCat=$p($g(^DHCEQInStockList(ListRowID)),"^",17)
	....i StatCat="" s StatCat=$p($g(^DHCEQInStock(rowid)),"^",21)
	....
	....s SourceID=ListRowID
	....s RemainOriginalFee=($p($g(^DHCEQInStockList(ListRowID)),"^",7)*$p($g(^DHCEQInStockList(ListRowID)),"^",8))
	....d SplitFunds
	
	s SourceType="5"
	//汇总减少信息
	s EquipType=0
	f  s EquipType=$o(^DHCEQReturn(0,"TypeDate",EquipType)) q:EquipType=""  d
	.q:##Class(web.DHCEQCommon).IdInIds(EquipType,EquipTypeIDs)=0
	.s OutType=0
	.f  s OutType=$o(^DHCEQReturn(0,"TypeDate",EquipType,OutType)) q:OutType=""  d
	..//增加入账形式的参数，退货业务的数据都是没有入账的，都不需要处理
	..q:(OutType=1)&(AccountShape=1)
	..s OutTypeCode=$p($g(^DHCEQCCode("DHCEQCOutType",OutType)),"^",1)
	..s BillDate=StartDate-1
	..
	..//入账时间可能是在入库之后的跨月,开始日期需要看所有入库单
	..i AccountShape="1" s BillDate=0
	..
	..f  s BillDate=$o(^DHCEQReturn(0,"TypeDate",EquipType,OutType,BillDate)) q:((BillDate="")||(BillDate>EndDate))  d
	...s rowid=0
	...f  s rowid=$o(^DHCEQReturn(0,"TypeDate",EquipType,OutType,BillDate,rowid)) q:(rowid="")  d
	....s RInvalidFlag=$p($g(^DHCEQReturn(rowid)),"^",28)    //Add By CZF 2016-12-07 begin
	....q:RInvalidFlag="Y"
	....s RStatus=$p($g(^DHCEQReturn(rowid)),"^",13)
	....q:RStatus'=2		//Add By CZF 2016-12-07 end
	....//增加入账形式的参数，当AccountShape=1的时候只显示已经入账的入库单,同时减少类型不是退货的时候
	....q:(AccountShape=1)&(##Class(web.DHCEQAccountList).AccountFlag(rowid,SourceType,StartDate,EndDate)=0)
	....;当期减少金额
	....s StoreLoc=$p($g(^DHCEQReturn(rowid)),"^",2)
	....s ListRowID=0
	....d InitStatInfoVariant
	....f  s ListRowID=$o(^DHCEQReturnList(0,"Return",rowid,ListRowID)) q:(ListRowID="")  d
	.....q:($p($g(^DHCEQReturnList(ListRowID)),"^",12)'="")		// Mozy0217  2018-11-01	过滤设备配置的退货明细
	.....s EquipID=$p($g(^DHCEQReturnList(ListRowID)),"^",4)
	.....s InStockListID=$p($g(^DHCEQReturnList(ListRowID)),"^",3)
	.....d GetStatOtherInfo
	.....
	.....s SourceID=ListRowID
	.....s RemainOriginalFee=($p($g(^DHCEQReturnList(ListRowID)),"^",5)*$p($g(^DHCEQReturnList(ListRowID)),"^",6))
	.....d SplitFunds
	
	s SourceType="4"
	//汇总转移信息
	s EquipType=0
	f  s EquipType=$o(^DHCEQStoreMove(0,"TypeDate",EquipType)) q:EquipType=""  d
	.q:##Class(web.DHCEQCommon).IdInIds(EquipType,EquipTypeIDs)=0
	.s BillDate=StartDate-1
	.//入账时间可能是在入库之后的跨月,开始日期需要看所有入库单
	.i AccountShape="1" s BillDate=0
	.f  s BillDate=$o(^DHCEQStoreMove(0,"TypeDate",EquipType,BillDate)) q:((BillDate="")||(BillDate>EndDate))  d
	..s rowid=0
	..f  s rowid=$o(^DHCEQStoreMove(0,"TypeDate",EquipType,BillDate,rowid)) q:(rowid="")  d
	...s SMInvalidFlag=$p($g(^DHCEQStoreMove(rowid)),"^",27)    //Add By CZF 2016-12-07 begin
	...q:SMInvalidFlag="Y"
	...s SMStatus=$p($g(^DHCEQStoreMove(rowid)),"^",13)
	...q:SMStatus'=2		//Add By CZF 2016-12-07 end
	...//增加入账形式的参数，当AccountShape=1的时候只显示已经入账的转移单
	...q:(AccountShape=1)&(##Class(web.DHCEQAccountList).AccountFlag(rowid,SourceType,StartDate,EndDate)=0)
	...s ListRowID=0
	...d InitStatInfoVariant
	...f  s ListRowID=$o(^DHCEQStoreMoveList(0,"StoreMove",rowid,ListRowID)) q:(ListRowID="")  d
	....q:$p($g(^DHCEQStoreMoveList(ListRowID)),"^",15)'="" // Mozy0217  2018-11-01	过滤设备配置的转移明细
	....s EquipID=$p($g(^DHCEQStoreMoveList(ListRowID)),"^",2)
	....s InStockListID=$p($g(^DHCEQStoreMoveList(ListRowID)),"^",4)
	....d GetStatOtherInfo
	....
	....s SourceID=ListRowID
	....s RemainOriginalFee=$p($g(^DHCEQStoreMoveList(ListRowID)),"^",7)*$p($g(^DHCEQStoreMoveList(ListRowID)),"^",8)
	....d SplitFunds
	
	s SourceType="7"
	//汇总当期原值变动信息
	s EquipType=0
	f  s EquipType=$o(^DHCEQChangeAccount(0,"TypeDate",EquipType)) q:EquipType=""  d
	.q:##Class(web.DHCEQCommon).IdInIds(EquipType,EquipTypeIDs)=0
	.s BillDate=StartDate-1
	.f  s BillDate=$o(^DHCEQChangeAccount(0,"TypeDate",EquipType,BillDate)) q:((BillDate="")||(BillDate>EndDate))  d
	..s rowid=0
	..f  s rowid=$o(^DHCEQChangeAccount(0,"TypeDate",EquipType,BillDate,rowid)) q:((rowid=""))  d
	...s CAStatus=$p($g(^DHCEQChangeAccount(rowid)),"^",11)    //Add By CZF 2016-12-07
	...q:CAStatus'=2
	...s EquipID=$p($g(^DHCEQChangeAccount(rowid)),"^",1)
	...q:$Piece($Get(^DHCEQEquip(EquipID,"OtherInfo")),"^",26)'=""	// Mozy0217  2018-11-01	过滤设备配置的调账
	...d InitStatInfoVariant
	...d GetStatOtherInfo
	...
	...s SourceID=rowid
	...s RemainOriginalFee=$p($g(^DHCEQChangeAccount(rowid)),"^",2)
	...d SplitFunds
	
	
	s SourceType="6"
	//汇总当期设备报废信息
	s EquipType=0
	f  s EquipType=$o(^DHCEQDisuseRequest(0,"TypeDate",EquipType)) q:EquipType=""  d
	.q:##Class(web.DHCEQCommon).IdInIds(EquipType,EquipTypeIDs)=0
	.s BillDate=StartDate-1
	.f  s BillDate=$o(^DHCEQDisuseRequest(0,"TypeDate",EquipType,BillDate)) q:((BillDate="")||(BillDate>EndDate))  d
	..s rowid=0
	..f  s rowid=$o(^DHCEQDisuseRequest(0,"TypeDate",EquipType,BillDate,rowid)) q:((rowid=""))  d
	...s DRInvalidFlag=$p($g(^DHCEQDisuseRequest(rowid)),"^",53)    //Add By CZF 2016-12-07 begin
	...q:DRInvalidFlag="Y"
	...s DRStatus=$p($g(^DHCEQDisuseRequest(rowid)),"^",10)
	...q:DRStatus'=2			//Add By CZF 2016-12-07 end
	...;Modified By JDL 2011-9-16 JDL0096
	...q:$p($g(^DHCEQDisuseRequest(rowid)),"^",10)'=2
	...s ListRowID=0
	...;Modified by JDL 2012-3-27 JDL0127 改用库房而非申请科室
	...s StoreLoc=$p($g(^DHCEQDisuseRequest(rowid)),"^",34)
	...f  s ListRowID=$o(^DHCEQDisuseRequestList(0,"DisuseRequest",rowid,ListRowID)) q:(ListRowID="")  d
	....d InitStatInfoVariant
	....s EquipID=$p($g(^DHCEQDisuseRequestList(ListRowID)),"^",2)
	....q:$Piece($Get(^DHCEQEquip(EquipID,"OtherInfo")),"^",26)'=""	// Mozy0217  2018-11-01	过滤设备配置的报废
	....d GetStatOtherInfo
	....
	....s SourceID=ListRowID
	....s RemainOriginalFee=$p($g(^DHCEQEquip(EquipID)),"^",27)
	....d SplitFunds
	
	s SourceType="1"
	//汇总当期设备折旧信息
	s StockStatus=0
	i Month<10
	{	s MonthStr=Year_"-0"_Month}
	else
	{	s MonthStr=Year_"-"_Month}
	f  s StockStatus=$o(^DHCEQEquip(0,"StoreEquipType","N",StockStatus)) q:StockStatus=""  d
	.;过滤尚未入库的
	.q:StockStatus="0"
	.
	.;Modified by JDL 2012-3-19 JDL0123
	.;月结中折旧应计算在折旧科室，而并非月末设备所在科室,并应记录净值
	.s StoreLocDR=0
	.f  s StoreLocDR=$o(^DHCEQEquip(0,"StoreEquipType","N",StockStatus,StoreLocDR)) q:StoreLocDR=""  d
	..
	..s EquipType=0
	..f  s EquipType=$o(^DHCEQEquip(0,"StoreEquipType","N",StockStatus,StoreLocDR,EquipType)) q:EquipType=""  d
	...q:##Class(web.DHCEQCommon).IdInIds(EquipType,EquipTypeIDs)=0
	...s rowid=0
	...f  s rowid=$o(^DHCEQEquip(0,"StoreEquipType","N",StockStatus,StoreLocDR,EquipType,rowid)) q:rowid=""  d
	....d InitStatInfoVariant
	....s EquipID=rowid
	....q:$Piece($Get(^DHCEQEquip(EquipID,"OtherInfo")),"^",26)'=""	// Mozy0217  2018-11-01	过滤设备配置的折旧
	....;Modified by JDL 2012-3-19 JDL0123 净值取设备台帐中对应的科室
	....s StoreLoc=StoreLocDR
	....
	....d GetStatOtherInfo
	....;非报废,非无效,非退货减少 才取期末净值
	....i (($p(^DHCEQEquip(rowid),"^",38)'=3)&&($p(^DHCEQEquip(rowid),"^",59)'="Y")&&(StockStatus'="3"))  d
	.....s SourceID=rowid
	.....s RemainOriginalFee=$p($g(^DHCEQEquip(EquipID)),"^",27)
	.....s RemainDepreTotal=$p(^DHCEQEquip(EquipID),"^",35)
	.....s RemainNetFee=$p(^DHCEQEquip(EquipID),"^",28)
	.....d SplitFunds
	....;Modified by JDL JDL0111	修正错误	月结统计中净值计算有误
	....s NetFee=0
	....s MonthDepreID=0
	....f  s MonthDepreID=$o(^DHCEQMonthDepre(0,"EquipMonth",EquipID,MonthStr,MonthDepreID)) q:MonthDepreID=""  d
	.....q:$p(^DHCEQMonthDepre(MonthDepreID),"^",3)'="Y"
	.....s MDStatus=$p($g(^DHCEQMonthDepre(MonthDepreID)),"^",20)	//DJ0136
	.....q:MDStatus="3"
	.....;折旧分摊
	.....s CADRowID=0
	.....s CADFlag=0
	.....s CADDepreFee=0
	.....;Modified By JDL 2011-9-16 JDL0096
	.....f  s CADRowID=$o(^DHCEQCostAllotDetail(0,"SourceID",MonthDepreID,CADRowID)) q:CADRowID=""  d
	......s CADFlag=CADFlag+1
	......s FundsType=$p($g(^DHCEQCostAllotDetail(CADRowID)),"^",7)
	......i FundsType="" s FundsType=SelfFundsType
	......q:(FundsTypeDR'="")&&(FundsType'=FundsTypeDR)
	......s Depre=+$p($g(^DHCEQCostAllotDetail(CADRowID)),"^",5)
	......;Modified by JDL 2012-3-19 JDL0123 取折旧分配明细中对应的科室
	......s StoreLoc=$p($g(^DHCEQCostAllotDetail(CADRowID)),"^",3)
	......
	......d AddStatListInfoNew
	.....i CADFlag=0  d
	......q:(FundsTypeDR'="")&&(SelfFundsFlag'=FundsTypeDR)
	......s Depre=$p(^DHCEQMonthDepre(MonthDepreID),"^",14)
	......;Modified by JDL 2012-3-19 JDL0123 取折旧表中对应的科室
	......s StoreLoc=$p(^DHCEQMonthDepre(MonthDepreID),"^",33)
	......
	......d AddStatListInfoNew
	
	;Modified By JDL 2012-3-22 JDL0126
	s SourceType="9"
	;Add by JDL 2011-6-22 JDL0086
	;汇总处理其他调整的数据,只取影响报表数据的
	s BillDate=StartDate-1	
	f  s BillDate=$o(^DHCEQAdjustData(0,"FlagDate","Y",BillDate)) q:((BillDate="")||(BillDate>EndDate))  d
	.s AdjustType=0
	.f  s AdjustType=$o(^DHCEQAdjustData(0,"FlagDate","Y",BillDate,AdjustType)) q:((AdjustType=""))  d
	..s rowid=0
	..f  s rowid=$o(^DHCEQAdjustData(0,"FlagDate","Y",BillDate,AdjustType,rowid)) q:((rowid=""))  d
	...s ADStatus=$p($g(^DHCEQAdjustData(rowid)),"^",11) /// add by zy 2011-09-25 ZY0080
	...quit:ADStatus'="1"
	...;add by lmm 2019-01-03 begin  1月月报过滤财务制度调整数据
	...s ADContent=""
	...s ADContent=$p($g(^DHCEQAdjustData(rowid)),"^",7)
	...q:(MonthReportType=2)&&(ADContent="2019年新财务制度")
	...;add by lmm 2019-01-03 end
	...s ListRowID=0
	...f  s ListRowID=$o(^DHCEQAdjustDataList(0,"AdjustData",rowid,ListRowID)) q:((ListRowID=""))  d
	....d InitStatInfoVariant
	....s EquipID=$p($g(^DHCEQAdjustDataList(ListRowID)),"^",2)
	....q:$Piece($Get(^DHCEQEquip(EquipID,"OtherInfo")),"^",26)'=""	// Mozy0217  2018-11-01	过滤设备配置的数据调整统计
	....;Modified By JDL 2012-3-22 JDL0126
	....s SourceID=ListRowID
	....s RemainOriginalFee=$p($g(^DHCEQAdjustDataList(ListRowID)),"^",14)
	....s RemainDepreTotal=$p($g(^DHCEQAdjustDataList(ListRowID)),"^",15)
	....d SplitFunds
	....
	....;Modified By DJ0114 2013-2-26 调整数据重复计算
	....q
	....
	....;1:调整数据 2:新增数据 3:删除数据 4.取消报废 9.其他调整
	....;从From减少数据
	....i (AdjustType="1")||(AdjustType="3")  d
	.....s EquipType=$p($g(^DHCEQAdjustDataList(ListRowID)),"^",4)  //2012-02-01 DJ0103
	.....s StoreLoc=$p($g(^DHCEQAdjustDataList(ListRowID)),"^",3) //2012-02-01 DJ0103
	.....s StatCat=$p($g(^DHCEQAdjustDataList(ListRowID)),"^",5)
	.....s Origin=$p($g(^DHCEQAdjustDataList(ListRowID)),"^",6)
	.....i $p($g(^DHCEQAdjustDataList(ListRowID)),"^",13)="1"  d
	......s UsedOther=-$p($g(^DHCEQAdjustDataList(ListRowID)),"^",14)  
	......s StockOther=0
	.....e  d
	......s UsedOther=0
	......s StockOther=-$p($g(^DHCEQAdjustDataList(ListRowID)),"^",14)   
	.....d AddStatListInfoNew
	....;从To增加数据
	....i (AdjustType="1")||(AdjustType="2")||(AdjustType="4")  d
	.....s EquipType=$p($g(^DHCEQAdjustDataList(ListRowID)),"^",9) //2012-02-01 DJ0103
	.....s StoreLoc=$p($g(^DHCEQAdjustDataList(ListRowID)),"^",8) //2012-02-01 DJ0103
	.....s StatCat=$p($g(^DHCEQAdjustDataList(ListRowID)),"^",10)
	.....s Origin=$p($g(^DHCEQAdjustDataList(ListRowID)),"^",11)
	.....i $p($g(^DHCEQAdjustDataList(ListRowID)),"^",13)="1"  d
	......s UsedOther=$p($g(^DHCEQAdjustDataList(ListRowID)),"^",14)   
	......s StockOther=0
	.....e  d
	......s UsedOther=0
	......s StockOther=$p($g(^DHCEQAdjustDataList(ListRowID)),"^",14)  
	.....d AddStatListInfoNew
		
	////取当月没有数据，但是上月有的作为本期的期初和期末
	s EquipType=0
	f  s EquipType=$o(^DHCEQMonthReportList(0,"TypeDate",EquipType)) q:EquipType=""  d
	.q:##Class(web.DHCEQCommon).IdInIds(EquipType,EquipTypeIDs)=0
	.s StatCat=0
	.;add by lmm 2019-01-04  衔接月报日期为 2019-00，以此生成1月月报
	.i (MonthReportType=2)  d
	..s PreYear="2019"
	..s PreMonth="00"
	.f  s StatCat=$o(^DHCEQMonthReportList(0,"TypeDate",EquipType,PreYear,PreMonth,StatCat)) q:StatCat=""  d
	..s Loc=0
	..f  s Loc=$o(^DHCEQMonthReportList(0,"TypeDate",EquipType,PreYear,PreMonth,StatCat,Loc)) q:Loc=""  d
	...s rowid=0
	...f  s rowid=$o(^DHCEQMonthReportList(0,"TypeDate",EquipType,PreYear,PreMonth,StatCat,Loc,rowid)) q:rowid=""  d
	....s listInfo=$g(^DHCEQMonthReportList(rowid))
	....//增加入账形式的参数与报表类型的判断
	....s ReportType=+$p(listInfo,"^",46)
	....q:((AccountShape=1)&&(AccountShape'=ReportType))
	....q:((AccountShape=0)&&(ReportType'=0)&&(ReportType'=""))
	....
	....s Origin=$p(listInfo,"^",26)			///Hold1原值变动 Hold2-->Origin    Used by DT
	....i Origin="" s Origin=0
	....s EquipType=$p(listInfo,"^",27)
	....s FundsType=$p(listInfo,"^",38)
	....i FundsType="" s FundsType=SelfFundsType
	....i FundsType="" s FundsType=0
	....q:$g(^DHCEQTemp("MonthReport","List",User,$J,Year,Month,EquipType,Loc,StatCat,Origin,FundsType))'=""
	....d InitStatInfoVariant
	....s StoreLoc=Loc
	....d AddStatListInfoNew
		
	quit

AddStatListInfoNew
	;Modified by jdl 2011-3-31 jdl0076
	s (StockBegin,UsedBegin)=0
	
	i FundsType="" s FundsType=SelfFundsType
	i FundsType="" s FundsType=0
	i (FundsTypeDR'="")&&(FundsType'=FundsTypeDR) q
	
	i Origin="" s Origin=0
	s listInfo=$g(^DHCEQTemp("MonthReport","List",User,$J,Year,Month,EquipType,StoreLoc,StatCat,Origin,FundsType))
	s StockEnd=StockBegin+StockIn-StockMoveOut-StockReturn-StockReduce+StockMoveIn
	;增加 库房转移(入),库房转移(出)
	s StockEnd=StockEnd+StoreMoveIn-StoreMoveOut
	s UsedEnd=UsedBegin+UsedIn-UsedReturn+UsedMoveIn-UsedMoveOut-Disused+ChangeAccount
	
	;Add by JDL 2011-6-22 JDL0086
	s StockEnd=StockEnd-StockDisused+StockChangeAccount+StockOther
	s UsedEnd=UsedEnd-UsedReduce+UsedOther
	
	
	;b //AddStatListInfoNew
	if listInfo=""
	{
		
		s TotalDepre=0
		s preRowId=0
		f  s preRowId=$o(^DHCEQMonthReportList(0,"TypeDate",EquipType,PreYear,PreMonth,StatCat,StoreLoc,preRowId)) q:preRowId=""  d
		.q:(Origin'=$p($g(^DHCEQMonthReportList(preRowId)),"^",26))
		.q:(EquipType'=$p($g(^DHCEQMonthReportList(preRowId)),"^",27))
		.q:(FundsType'=$p($g(^DHCEQMonthReportList(preRowId)),"^",38))
		.////增加入账形式的参数与报表类型的判断
		.s preMRLAccountShape=+$p($g(^DHCEQMonthReportList(preRowId)),"^",46)
		.q:(AccountShape=1)&&(AccountShape'=preMRLAccountShape)
		.q:(AccountShape=0)&&(preMRLAccountShape'="")&&(preMRLAccountShape'=0)
		.s StockBegin=+StockBegin+$p($g(^DHCEQMonthReportList(preRowId)),"^",12)	///在库 上月期末为本月期初
		.s UsedBegin=+UsedBegin+$p($g(^DHCEQMonthReportList(preRowId)),"^",19)	///在用 上月期末为本月期初
		.s StockEnd=+StockEnd+StockBegin
		.s UsedEnd=+UsedEnd+UsedBegin
		.;累计折旧取上期累计折旧+本期折旧
		.s TotalDepre=+$p($g(^DHCEQMonthReportList(preRowId)),"^",28)
		s TotalDepre=+Depre+TotalDepre 
		;Modified by JDL 2011-6-22 JDL0086
		s listInfo=StockBegin_"^"_StockIn_"^"_StockReturn_"^"_StockReduce_"^"_StockMoveOut_"^"_StockMoveIn_"^"_StockEnd_"^"_UsedBegin_"^"_UsedIn_"^"_UsedReturn_"^"_UsedMoveIn_"^"_UsedMoveOut_"^"_Disused_"^"_UsedEnd_"^"_ChangeAccount_"^"_TotalDepre_"^"_Depre_"^"_StockDisused_"^"_StoreMoveIn_"^"_StoreMoveOut_"^"_NetFee_"^"_StockChangeAccount_"^"_UsedReduce_"^"_StockOther_"^"_UsedOther_"^"_StockCATotalDepre_"^"_UsedCATotalDepre
		
	}
	else
	{
		s $p(listInfo,"^",1)=+$p(listInfo,"^",1)+StockBegin 
		s $p(listInfo,"^",2)=+$p(listInfo,"^",2)+StockIn
		s $p(listInfo,"^",3)=+$p(listInfo,"^",3)+StockReturn
		s $p(listInfo,"^",4)=+$p(listInfo,"^",4)+StockReduce
		s $p(listInfo,"^",5)=+$p(listInfo,"^",5)+StockMoveOut
		s $p(listInfo,"^",6)=+$p(listInfo,"^",6)+StockMoveIn
		s $p(listInfo,"^",7)=+$p(listInfo,"^",7)+StockEnd
		
		s $p(listInfo,"^",8)=+$p(listInfo,"^",8)+UsedBegin
		s $p(listInfo,"^",9)=+$p(listInfo,"^",9)+UsedIn
		s $p(listInfo,"^",10)=+$p(listInfo,"^",10)+UsedReturn
		s $p(listInfo,"^",11)=+$p(listInfo,"^",11)+UsedMoveIn
		s $p(listInfo,"^",12)=+$p(listInfo,"^",12)+UsedMoveOut
		s $p(listInfo,"^",13)=+$p(listInfo,"^",13)+Disused
		s $p(listInfo,"^",14)=+$p(listInfo,"^",14)+UsedEnd
		
		s $p(listInfo,"^",15)=+$p(listInfo,"^",15)+ChangeAccount
		
		;增加 库房转移(入),库房转移(出)
		;Modified By JDL 2013-5-27 JDL0132 调整数据中 新增及减少 需要计算累计折旧，即如果有累计折旧变动，需在funds里有。
		;
		i SourceType=9
		{
			s $p(listInfo,"^",16)=+$p(listInfo,"^",16)+DepreTotal		;TotalDepre
		}
		else
		{
			s $p(listInfo,"^",16)=+$p(listInfo,"^",16)+Depre		;TotalDepre
		}
			
		s $p(listInfo,"^",17)=+$p(listInfo,"^",17)+Depre
		s $p(listInfo,"^",18)=+$p(listInfo,"^",18)+StockDisused
		s $p(listInfo,"^",19)=+$p(listInfo,"^",19)+StoreMoveIn
		s $p(listInfo,"^",20)=+$p(listInfo,"^",20)+StoreMoveOut
		s $p(listInfo,"^",21)=+$p(listInfo,"^",21)+NetFee
		
		;Add by JDL 2011-6-22 JDL0086
		s $p(listInfo,"^",22)=+$p(listInfo,"^",22)+StockChangeAccount
		s $p(listInfo,"^",23)=+$p(listInfo,"^",23)+UsedReduce
		s $p(listInfo,"^",24)=+$p(listInfo,"^",24)+StockOther
		s $p(listInfo,"^",25)=+$p(listInfo,"^",25)+UsedOther
		;Add By DJ 2015-01-21 DJ0135
		s $p(listInfo,"^",26)=+$p(listInfo,"^",26)+StockCATotalDepre
		s $p(listInfo,"^",27)=+$p(listInfo,"^",27)+UsedCATotalDepre
	}
	s ^DHCEQTemp("MonthReport","List",User,$J,Year,Month,EquipType,StoreLoc,StatCat,Origin,FundsType)=listInfo
	quit
InitStatInfoVariant
	s (StockBegin,StockIn,StockReturn,StockReduce,StockMoveOut,StockMoveIn,StockEnd,UsedBegin,UsedIn,UsedReturn,UsedMoveIn,UsedMoveOut,Disused,UsedEnd,TotalEnd,ChangeAccount)=0
	s (TotalDepre,Depre,StockDisused,StoreMoveIn,StoreMoveOut)=0	   
	s NetFee=0
	;Add by JDL 2011-6-22 JDL0086
	s (StockChangeAccount,UsedReduce,StockOther,UsedOther)=0
	
	s (RemainOriginalFee,RemainDepreTotal,RemainNetFee,FundsFee)=0
	;Add By DJ 2015-01-21 DJ0135
	s (StockCATotalDepre,UsedCATotalDepre)=0
	q
GetStatOtherInfo	;根据InStockListID和EquipID获取信息:StatCat,Origin
	i EquipID'=""  d
	.s Origin=$p($g(^DHCEQEquip(EquipID)),"^",20)
	.s StatCat=$p($g(^DHCEQEquip(EquipID)),"^",75)
	e  d
	.s Origin=$p($g(^DHCEQInStock($p($g(^DHCEQInStockList(InStockListID)),"^",1))),"^",15)
	.;Mozy0077	2012-2-21	从设备表中获取设备类型
	.Set StatCat= ##class(web.DHCEQStoreMoveNew).GetEquipTypeByInStockList(InStockListID)
	.If StatCat'="" Do
	..Set StatCat=$Piece(StatCat,"^",2)
	.Else  Do
	..s StatCat=$p($g(^DHCEQInStockList(InStockListID)),"^",17)
	..i StatCat="" s StatCat=$p($g(^DHCEQInStock($p($g(^DHCEQInStockList(InStockListID)),"^",1))),"^",21)
	q
SplitFunds
	s FundsID=0
	f  s FundsID=$o(^DHCEQFunds(0,"Source",SourceType,SourceID,FundsID)) q:(FundsID="")  d
	.q:$p(^DHCEQFunds(FundsID),"^",10)="Y"		;F_InvalidFlag
	.q:$p(^DHCEQFunds(FundsID),"^",6)="2"		;F_OperFlag
	.s FundsType=$p(^DHCEQFunds(FundsID),"^",2)
	.i FundsType="" s FundsType=SelfFundsType
	.s FundsFee=+$p($g(^DHCEQFunds(FundsID)),"^",3)
	.s DepreTotalFundsFee=+$p($g(^DHCEQFunds(FundsID)),"^",13)	//DJ0135
	.s RemainOriginalFee=RemainOriginalFee-FundsFee
	.;根据设备获取 净值等信息
	.i SourceType="1"  d
	..s DepreTotal=$p($g(^DHCEQFunds(FundsID)),"^",13)
	..s RemainDepreTotal=RemainDepreTotal-DepreTotal
	..s NetFee=FundsFee-DepreTotal
	..;Modified by JDL 2012-1-17 JDL0112 修改调账相关程序 净值不能小于0
	..i NetFee<0 s NetFee=0
	..s RemainNetFee=RemainNetFee-NetFee
	.d AddFundsInfo

	;如果有剩余金额,则记在系统参数设置中的默认 资金来源中
	i RemainOriginalFee'=0  d
	.s FundsType=SelfFundsType
	.s FundsFee=RemainOriginalFee
	.i SourceType="1"  d
	..s NetFee=RemainNetFee
	..s DepreTotal=RemainDepreTotal
	.;Modified By JDL 2012-3-22 JDL0126 调整数据时,要根据情况处理累计折旧
	.i SourceType="9"  d
	..s DepreTotal=RemainDepreTotal
	.d AddFundsInfo
	
	q
AddFundsInfo
	i SourceType="1"  d
	.;获取当前的净值信息   原值(根据期初和变动计算)、累计折旧(上期累计+本期折旧)
	.
	else  if SourceType="3"  d
	.;当期入库金额
	.s StockIn=FundsFee
	else  if SourceType="4"  d
	.;当期转移
	.;0:库房分配|1:科室间调配|2:报废转废品库|3:科室退库|4:库房转移
	.if $p($g(^DHCEQStoreMove(rowid)),"^",12)="0"  d
	..s StoreLoc=$p($g(^DHCEQStoreMove(rowid)),"^",2)
	..s StockMoveOut=FundsFee
	..s UsedIn=0
	..d AddStatListInfoNew
	..s StoreLoc=$p($g(^DHCEQStoreMove(rowid)),"^",3)
	..s StockMoveOut=0
	..s UsedIn=FundsFee
	.e  i $p($g(^DHCEQStoreMove(rowid)),"^",12)="1"  d
	..s StoreLoc=$p($g(^DHCEQStoreMove(rowid)),"^",2)
	..s UsedMoveOut=FundsFee
	..s UsedMoveIn=0
	..d AddStatListInfoNew
	..s StoreLoc=$p($g(^DHCEQStoreMove(rowid)),"^",3)
	..s UsedMoveOut=0
	..s UsedMoveIn=FundsFee
	.e  i $p($g(^DHCEQStoreMove(rowid)),"^",12)="3"  d
	..s StoreLoc=$p($g(^DHCEQStoreMove(rowid)),"^",2)
	..s UsedReturn=FundsFee
	..s StockMoveIn=0
	..d AddStatListInfoNew
	..s StoreLoc=$p($g(^DHCEQStoreMove(rowid)),"^",3)
	..s UsedReturn=0
	..s StockMoveIn=FundsFee
	.e  i $p($g(^DHCEQStoreMove(rowid)),"^",12)="4"  d
	..s StoreLoc=$p($g(^DHCEQStoreMove(rowid)),"^",2)
	..s StoreMoveIn=0
	..s StoreMoveOut=FundsFee
	..d AddStatListInfoNew
	..s StoreLoc=$p($g(^DHCEQStoreMove(rowid)),"^",3)
	..s StoreMoveIn=FundsFee
	..s StoreMoveOut=0
	else  if SourceType="5"  d
	.;当期退货及减少
	.i OutTypeCode="TH" d
	..s StockReturn=FundsFee	;退货费用
	.e  d
	..;根据减少单是否有使用科室,来区分是在库减少、在用减少
	..i $p($g(^DHCEQReturn(rowid)),"^",24)="" d
	...s StockReduce=FundsFee	;其他减少费用
	..e  d
	...s StoreLoc=$p($g(^DHCEQReturn(rowid)),"^",24)
	...s UsedReduce=FundsFee	;其他减少费用
	else  if SourceType="6"  d
	.;当期报废的
	.;Hold1区分在库的和在用的
	.//midified by zy 2015-7-1 ZY0134 
	.//修改设备状态为0:在库|1:启用|2:停用|3:报废|4:其他,根据设备的状态来判断记录在库或在用
	.//i ($p($g(^DHCEQDisuseRequestList(ListRowID)),"^",11)="1")||($p($g(^DHCEQDisuseRequestList(ListRowID)),"^",11)="2")  d
	.i $p($g(^DHCEQDisuseRequestList(ListRowID)),"^",11)'="0"  d
	..s Disused=FundsFee
	.e  d
	..s StockDisused=FundsFee	;报废为在库的
	else  if SourceType="7"  d
	.;当期调账的
	.;Hold1区分在库的和在用的调账
	.//midified by zy 2015-7-1 ZY0134 
	.//修改设备状态为0:在库|1:启用|2:停用|3:报废|4:其他,根据设备的状态来判断记录在库或在用
	.i ($p($g(^DHCEQChangeAccount(rowid)),"^",32)'="0")  d
	..s ChangeAccount=FundsFee
	..s UsedCATotalDepre=DepreTotalFundsFee		//DJ0135
	.e  d
	..s StockChangeAccount=FundsFee
	..s StockCATotalDepre=DepreTotalFundsFee		//DJ0135
	.s StoreLoc=$p($g(^DHCEQChangeAccount(rowid)),"^",28)
	else  if SourceType="9"  d
	.;Modified By JDL 2012-3-22 JDL0126 调整数据时,要根据情况处理原值及累计折旧
	.;当期后台调整的数据
	.;1:调整数据 2:新增数据 3:删除数据 4.取消报废 9.其他调整
	.;从From减少数据
	.i (AdjustType="1")||(AdjustType="3")  d
	..s EquipType=$p($g(^DHCEQAdjustDataList(ListRowID)),"^",4)  //2012-02-01 DJ0103
	..s StoreLoc=$p($g(^DHCEQAdjustDataList(ListRowID)),"^",3) //2012-02-01 DJ0103
	..s StatCat=$p($g(^DHCEQAdjustDataList(ListRowID)),"^",5)
	..s Origin=$p($g(^DHCEQAdjustDataList(ListRowID)),"^",6)
	..;调整数据 累计折旧减少
	..s DepreTotal=-DepreTotal
	..i (AdjustType="3") s DepreTotal=0
	..//midified by zy 2015-7-1 ZY0134 
	..//修改设备状态为0:在库|1:启用|2:停用|3:报废|4:其他,根据设备的状态来判断记录在库或在用
	..i $p($g(^DHCEQAdjustDataList(ListRowID)),"^",13)'="0"  d
	...s UsedOther=-FundsFee  
	...s StockOther=0
	..e  d
	...s UsedOther=0
	...s StockOther=-FundsFee  
	..d AddStatListInfoNew
	.;从To增加数据
	.i (AdjustType="1")||(AdjustType="2")||(AdjustType="4")  d
	..s EquipType=$p($g(^DHCEQAdjustDataList(ListRowID)),"^",9) //2012-02-01 DJ0103
	..s StoreLoc=$p($g(^DHCEQAdjustDataList(ListRowID)),"^",8) //2012-02-01 DJ0103
	..s StatCat=$p($g(^DHCEQAdjustDataList(ListRowID)),"^",10)
	..s Origin=$p($g(^DHCEQAdjustDataList(ListRowID)),"^",11)
	..i (AdjustType="4") s DepreTotal=0
	..//midified by zy 2015-7-1 ZY0134 
	..//修改设备状态为0:在库|1:启用|2:停用|3:报废|4:其他,根据设备的状态来判断记录在库或在用
	..i $p($g(^DHCEQAdjustDataList(ListRowID)),"^",13)'="0"  d
	...s UsedOther=FundsFee  
	...s StockOther=0
	..e  d
	...s UsedOther=0
	...s StockOther=FundsFee  
	..d AddStatListInfoNew
	s DepreTotal=0
	if SourceType'="9" d AddStatListInfoNew
	q
}

/// 保存StatList
ClassMethod SaveMonthReportList(User, Year, Month, StartDate, EndDate, MonthStr, EquipTypeIDs As %Library.String = "", AccountShape As %Library.String = "0", MonthReportType)
{
	new EquipType,Loc,StatCat,Origin,listInfo,PreYear,PreMonth
	new Date,Time
 	new FundsType
 	
 	s Date=+$H
	s Time=$p($H,",",2)
	
	k PLIST
	if (MonthReportType=1)
	{
		s PLIST(2) = "2019"    //modify by lmm 2019-01-03 衔接月报生成日期
		s PLIST(3) = "00"      //modify by lmm 2019-01-03
		s PLIST(5) = "2019新财务制度" //modify by lmm 2019-01-03
	}
	if (MonthReportType=2)
	{
		s PLIST(2) = Year       //modify by lmm 2019-01-03   1月月报生成日期
		s PLIST(3) = Month      //modify by lmm 2019-01-03
		s PLIST(5) = MonthStr   //modify by lmm 2019-01-03
	}
	
	///s PLIST(4) = Loc
	///s PLIST(6) = StatCat
	
	s PLIST(21) = StartDate
	s PLIST(22) = EndDate
	s PLIST(23) = Date
	s PLIST(24) = Time
	s PLIST(25) = User
	s PLIST(47) =AccountShape	//MRL_ReportType  0，实物月结;1，财务月结
	
	Set $ZT="ETSaveMonthReportList"
	TStart
	s SQLCODE=0
	///保存当月有业务数据变化的
	s EquipType=0
	f  s EquipType=$o(^DHCEQTemp("MonthReport","List",User,$J,Year,Month,EquipType)) q:((EquipType="")||(SQLCODE'=0))  d
	.//q:$d(^DHCEQMonthReportList(0,"YearMonth",Year,Month,EquipType))
	.q:$d(^DHCEQMonthReportList(0,"ReportType",+AccountShape,Year,Month,EquipType))
	.q:##Class(web.DHCEQCommon).IdInIds(EquipType,EquipTypeIDs)=0
	.s Loc=0
	.f  s Loc=$o(^DHCEQTemp("MonthReport","List",User,$J,Year,Month,EquipType,Loc)) q:((Loc="")||(SQLCODE'=0))  d
	..s StatCat=0
	..f  s StatCat=$o(^DHCEQTemp("MonthReport","List",User,$J,Year,Month,EquipType,Loc,StatCat)) q:((StatCat="")||(SQLCODE'=0))  d
	...s Origin=""
	...f  s Origin=$o(^DHCEQTemp("MonthReport","List",User,$J,Year,Month,EquipType,Loc,StatCat,Origin)) q:((Origin="")||(SQLCODE'=0))  d
	....
	....;Modified by jdl 2011-12-28 JDL0107
	....s FundsType=""
	....f  s FundsType=$o(^DHCEQTemp("MonthReport","List",User,$J,Year,Month,EquipType,Loc,StatCat,Origin,FundsType)) q:((FundsType="")||(SQLCODE'=0))  d
	.....s listInfo=$g(^DHCEQTemp("MonthReport","List",User,$J,Year,Month,EquipType,Loc,StatCat,Origin,FundsType))
	.....s PLIST(4) = Loc
	.....s PLIST(6) = StatCat
	.....f i=1:1:14 d
	......s PLIST(6+i) = $p(listInfo,"^",i)
	.....s PLIST(26)=$p(listInfo,"^",15)		///原值变动
	.....s PLIST(27)=Origin		///来源
	.....s PLIST(28)=EquipType	///类组
	.....s PLIST(39)=FundsType	///类组
	.....;Modified by JDL 2011-6-22 JDL0086
	.....f i=16:1:25 d
	......s PLIST(13+i) = $p(listInfo,"^",i)
	.....;Add By DJ 2015-01-21 DJ0135
	.....f i=26:1:27 d
	......s PLIST(14+i) = $p(listInfo,"^",i)
	.....&SQL(Insert Into SQLUSER.DHC_EQMonthReportList Values :PLIST())
	.....q:SQLCODE'=0 
	
	i SQLCODE'=0
	{	TRollBack}
	else
	{	TCommit}
	q SQLCODE
	
ETSaveMonthReportList
	TRollBack	
	Set ErrorMsg=$ZE	     //得到系统返回的错误消息
 	Quit "-1^"_ErrorMsg     //返回错误消息 ;
}

/// Add By QW 2019-01-02 bug:QW0022 新增业务检测 
/// 检查业务单是否有尚未审核单据:(输出有未审核的业务单据类型及数量)
/// 输出参数:"业务1:未审核数,业务2:未审核数……"
/// w ##Class(web.DHCEQFinance2019).CheckBusiness()
ClassMethod CheckBusiness()
{
	new OpenCheckNum,InStockNum,StoreMoveNum,DisuseNum,ReturnNum,InventoryNum
	new MaintRequestNum,BuyRequestNum,BuyPlanNum,IFBNum,ContractNum,MaintRequestDR,RentNum,result
	s (OpenCheckNum,InStockNum,StoreMoveNum,DisuseNum,ReturnNum,InventoryNum)=0
	s (MaintRequestNum,BuyRequestNum,BuyPlanNum,IFBNum,ContractNum,RentNum)=0
	//验收
	s CheckType=""
	For  Set CheckType=$Order(^DHCEQOpenCheckRequest(0,"Status",CheckType))  Quit:CheckType=""  Do
	.s EquipTypeDR=0
	.For  Set EquipTypeDR=$Order(^DHCEQOpenCheckRequest(0,"Status",CheckType,EquipTypeDR))  Quit:EquipTypeDR=""  Do
	..s Status=""
	..For  Set Status=$Order(^DHCEQOpenCheckRequest(0,"Status",CheckType,EquipTypeDR,Status))  Quit:((Status="")||(Status=2))  Do
	...s OCRRowID=0
	...For  Set OCRRowID=$Order(^DHCEQOpenCheckRequest(0,"Status",CheckType,EquipTypeDR,Status,OCRRowID))  Quit:OCRRowID=""  Do
	....q:$p($g(^DHCEQOpenCheckRequest(OCRRowID)),"^",45)="Y"
	....s OpenCheckNum=OpenCheckNum+1
	//入库
	s InStockDR=0
	f  s InStockDR=$o(^DHCEQInStock(InStockDR))  quit:InStockDR=""  d
	.q:$p($g(^DHCEQInStock(InStockDR)),"^",10)>1  //Modified  By QW 2019-01-14bug:QW0026
	.q:$p($g(^DHCEQInStock(InStockDR)),"^",25)="Y"
	.s InStockNum=InStockNum+1
	//转移
	s Status=""
	f  s Status=$o(^DHCEQStoreMove(0,"StatusFromLoc",Status)) q:((Status="")||(Status=2))  d
	.s FromLocDR=0
	.f  s FromLocDR=$o(^DHCEQStoreMove(0,"StatusFromLoc",Status,FromLocDR)) q:FromLocDR=""  d
	..s StoreMoveDR=0
	..f  s StoreMoveDR=$o(^DHCEQStoreMove(0,"StatusFromLoc",Status,FromLocDR,StoreMoveDR)) q:StoreMoveDR=""  d
	...q:$p($g(^DHCEQStoreMove(StoreMoveDR)),"^",27)="Y"
	...s StoreMoveNum=StoreMoveNum+1
	//报废
	s Status=""
	f  s Status=$o(^DHCEQDisuseRequest(0,"Status",Status)) q:((Status="")||(Status=2))  d
	.s DisuseDR=0
	.f  s DisuseDR=$o(^DHCEQDisuseRequest(0,"Status",Status,DisuseDR)) q:DisuseDR=""  d
	..q:$p($g(^DHCEQDisuseRequest(DisuseDR)),"^",53)="Y"
	..s DisuseNum=DisuseNum+1
	//减少
	s Status=""
	f  s Status=$o(^DHCEQReturn(0,"StatusReturnLoc",Status))  quit:((Status="")||(Status=2))  d
	.s ReturnLocDR=0
	.f  s ReturnLocDR=$o(^DHCEQReturn(0,"StatusReturnLoc",Status,ReturnLocDR))  quit:ReturnLocDR=""  d
	..s ReturnDR=0
	..f  s ReturnDR=$o(^DHCEQReturn(0,"StatusReturnLoc",Status,ReturnLocDR,ReturnDR))  quit:ReturnDR=""  d
	...q:$p($g(^DHCEQReturn(ReturnDR)),"^",28)="Y"
	...s ReturnNum=ReturnNum+1
	//采购申请
	s Status=""
	for  s Status=$o(^DHCEQBuyRequest(0,"Status",Status)) quit:((Status="")||(Status=2))  d
	.s BuyRequestDR=0
	.for  s BuyRequestDR=$o(^DHCEQBuyRequest(0,"Status",Status,BuyRequestDR)) quit:BuyRequestDR=""  d
	..q:$p($g(^DHCEQBuyRequest(BuyRequestDR)),"^",45)="Y"
	..s BuyRequestNum=BuyRequestNum+1
	//采购计划
	s Status=""
    For  Set Status=$Order(^DHCEQBuyPlan(0,"Status",Status))   Quit:((Status="")||(Status=2))  Do
	.s BuyPlanDR=0
	. For  Set BuyPlanDR=$Order(^DHCEQBuyPlan(0,"Status",Status,BuyPlanDR)) Quit:BuyPlanDR=""  Do
	..q:$p($g(^DHCEQBuyPlan(BuyPlanDR)),"^",46)="Y"
	..s BuyPlanNum=BuyPlanNum+1
	//招标
	Set IFBDR=0
	For  Set IFBDR=$Order(^DHCEQIFB(IFBDR))  Quit:IFBDR=""  Do
	.q:$Piece($Get(^DHCEQIFB(IFBDR)),"^",43)=2
	.s IFBNum=IFBNum+1
	//采购合同
	s Status=""
	f  s Status=$o(^DHCEQContract(0,"Status",Status)) q:((Status="")||(Status=2))  d
	.s ContractDR=0
	.f  s ContractDR=$o(^DHCEQContract(0,"Status",Status,ContractDR)) q:ContractDR=""  d
	..s ContractNum=ContractNum+1
	//维修
	s Status=""
	For  Set Status=$Order(^DHCEQMMaintRequest(0,"Status",Status))  Quit:((Status="")||(Status=2))  Do
	.Set MaintRequestDR=0	
	.For  Set MaintRequestDR=$Order(^DHCEQMMaintRequest(0,"Status",Status,MaintRequestDR))  Quit:MaintRequestDR=""  Do
	..q:$p($g(^DHCEQMMaintRequest(MaintRequestDR)),"^",57)="Y"
	..s MaintRequestNum=MaintRequestNum+1
	//租赁
	s Status=""
	For  Set Status=$Order(^DHCEQRent(0,"Status",Status))  Quit:((Status="")||(Status=2))  Do
	.Set RentDR=0	 
	.For  Set RentDR=$Order(^DHCEQRent(0,"Status",Status,RentDR))  Quit:RentDR=""  Do
	..s RentNum=RentNum+1
	
	//盘点
	s InventoryDR=0
	f  s InventoryDR=$o(^DHCEQInventory(InventoryDR))  quit:InventoryDR=""  d
	.q:$p($g(^DHCEQInventory(InventoryDR)),"^",10)=2
	.s InventoryNum=InventoryNum+1
	s result="验收:"_OpenCheckNum_"^入库:"_InStockNum_"^转移:"_StoreMoveNum_"^报废:"_DisuseNum_"^减少:"_ReturnNum
	s result=result_"^"_"采购申请:"_BuyRequestNum_"^"_"采购计划:"_BuyPlanNum_"^"_"招标:"_IFBNum_"^"_"采购合同:"_ContractNum
	s result=result_"^"_"维修:"_MaintRequestNum_"^"_"租赁:"_RentNum_"^"_"盘点:"_InventoryNum
	q result
}

/// Add By QW 2019-01-04  bug:QW0023 新增业务调整 
/// 更新尚未审核业务单据: 输出更新的业务单据类型、数量。类组不同单据的单号
/// 参数：Types更新业务类型串,支持：11:"开箱验收",21:"入库",22:"转移",23:"减少",34:"报废
/// w ##Class(web.DHCEQFinance2019).UpdateBusiness("11,21,22,23,34")
ClassMethod UpdateBusiness(Types As %Library.String = "")
{
	new (Types)
	Set $ZT="ERRORSave"
	s result=""
	s flag=0
	if (Types="") s Types="11,21,22,23,34"   //Types为空更细所有业务
	s errorcode=""
	TStart
	s Len=$l(Types,",")
	for i=1:1:Len  q:(flag'=0)  d
	.s Type=$p(Types,",",i)
	.q:Type=""
	.s errorcode=##Class(web.DHCEQFinance2019).UpdateBusinessByID(Type)
	.s flag=$p(errorcode,"&",1)
	.s result=result_"$$"_errorcode
	if flag  
	{	
		TRollBack
		q flag
	}
	 TCommit
	 q result
ERRORSave 
	Set ErrorMsg=$ZE	     //得到系统返回的错误消息
 	TROLLBACK		         //回滚事务
 	Quit "ERRORSave"_ErrorMsg     //返回错误消息 ;
}

/// Add By QW 2019-01-04  bug:QW0023 根据Type调整对应业务
ClassMethod UpdateBusinessByID(Type As %Library.String = "")
{
	new (Type)
	K PLIST,PLISTMX
	s (OpenCheckNum,InStockNum,StoreMoveNum,DisuseNum,ReturnNum)=0

	s BussNo="多类组单据"
	s Code=""
	s EquipTypeDRs=""
	s Flag=0
	if Type=11  //验收
	{        //Modified by QW20180108 QW0024 修改变量 
		//验收
		s CheckType=""
		For  Set CheckType=$Order(^DHCEQOpenCheckRequest(0,"Status",CheckType))  Quit:((CheckType="")||(Flag'=0))  Do
		.s TypeDR=0
		.For  Set TypeDR=$Order(^DHCEQOpenCheckRequest(0,"Status",CheckType,TypeDR))  Quit:((TypeDR="")||(Flag'=0))  Do
		..s Status=""
		..For  Set Status=$Order(^DHCEQOpenCheckRequest(0,"Status",CheckType,TypeDR,Status))  Quit:((Status="")||(Status=2)||(Flag'=0))  Do
		...s BussID=0
		...For  Set BussID=$Order(^DHCEQOpenCheckRequest(0,"Status",CheckType,TypeDR,Status,BussID))  Quit:(BussID=""||(Flag'=0))  Do
		....q:$p($g(^DHCEQOpenCheckRequest(BussID)),"^",45)="Y"
		....d ResetVariables  //add by QW20180108 QW0024  
		....d UpdateOpenCheck
		....s OpenCheckNum=OpenCheckNum+1
		q Flag_"&"_"验收修改数量:"_OpenCheckNum
	}elseif Type=21  //入库
	{
		s BussNo="入库多类组单据:"
		//入库
		s BussID=0
		f  s BussID=$o(^DHCEQInStock(BussID))  quit:((BussID="")||(Flag'=0))  d
		.q:$p($g(^DHCEQInStock(BussID)),"^",10)>1  //Modified  By QW 2019-01-14bug:QW0026
		.q:$p($g(^DHCEQInStock(BussID)),"^",25)="Y"
		.d ResetVariables //add by QW20180108 QW0024 
		.d UpdateInStock
		.i Length>1 s BussNo=BussNo_"^"_$p($g(^DHCEQInStock(BussID)),"^",14)
		.s InStockNum=InStockNum+1
		q Flag_"&"_BussNo_"&"_"修改数量:"_InStockNum
	}elseif Type=22  //转移
	{
		s BussNo="转移多类组单据:"
		//转移
		s Status=""
		f  s Status=$o(^DHCEQStoreMove(0,"StatusFromLoc",Status)) q:((Status="")||(Status=2)||(Flag'=0))  d
		.s FromLocDR=0
		.f  s FromLocDR=$o(^DHCEQStoreMove(0,"StatusFromLoc",Status,FromLocDR)) q:((FromLocDR="")||(Flag'=0))  d
		..s BussID=0
		..f  s BussID=$o(^DHCEQStoreMove(0,"StatusFromLoc",Status,FromLocDR,BussID)) q:((BussID="")||(Flag'=0))  d
		...q:$p($g(^DHCEQStoreMove(BussID)),"^",27)="Y"
		...d ResetVariables //add by QW20180108 QW0024 
		...d UpDateStoreMoVe
		...i Length>1 d  s BussNo=BussNo_"^"_$p($g(^DHCEQStoreMove(BussID)),"^",1)
		...s StoreMoveNum=StoreMoveNum+1
		q Flag_"&"_BussNo_"&"_"修改数量:"_StoreMoveNum
	
	}elseif Type=23  //减少
	{
		//减少
		s BussNo="减少多类组单据:"
		s Status=""
		f  s Status=$o(^DHCEQReturn(0,"StatusReturnLoc",Status))  quit:((Status="")||(Status=2)||(Flag'=0))  d
		.s ReturnLocDR=0
		.f  s ReturnLocDR=$o(^DHCEQReturn(0,"StatusReturnLoc",Status,ReturnLocDR))  quit:((ReturnLocDR="")||(Flag'=0))  d
		..s BussID=0
		..f  s BussID=$o(^DHCEQReturn(0,"StatusReturnLoc",Status,ReturnLocDR,BussID))  quit:((BussID="")||(Flag'=0))  d
		...q:$p($g(^DHCEQReturn(BussID)),"^",28)="Y"
		...d ResetVariables //add by QW20180108 QW0024 
		...d UpdateReturn
		...i Length>1 s BussNo=BussNo_"^"_$p($g(^DHCEQReturn(BussID)),"^",1)
		...s ReturnNum=ReturnNum+1
		q Flag_"&"_BussNo_"&"_"修改数量:"_ReturnNum
	}elseif Type=31  //维修
	{
		
	}elseif Type=34  //报废
	{
			//报废
		s BussNo="报废多类组单据:"
		s Status=""
		f  s Status=$o(^DHCEQDisuseRequest(0,"Status",Status)) q:((Status="")||(Status=2)||(Flag'=0))  d
		.s BussID=0
		.f  s BussID=$o(^DHCEQDisuseRequest(0,"Status",Status,BussID)) q:((BussID="")||(Flag'=0))  d
		..q:$p($g(^DHCEQDisuseRequest(BussID)),"^",53)="Y"
		..d ResetVariables //add by QW20180108 QW0024 
		..d UpDateDiuse
		..i Length>1 s BussNo=BussNo_"^"_$p($g(^DHCEQDisuseRequest(BussID)),"^",33)
		..s DisuseNum=DisuseNum+1
		
		q Flag_"&"_BussNo_"&"_"修改数量:"_DisuseNum
	}
	
UpdateOpenCheck
		s EquipTypeDRs=""
		s BussListID=$o(^DHCEQOpenCheckList(0,"OpenCheckRequest",BussID,0))
		s ItemID=$p($g(^DHCEQOpenCheckList(BussListID)),"^", 9)
		q:ItemID=""
		d GetItemInfo
		s PLIST(3)=EquipTypeDR
		s PLIST(5)=StatcatDR

		s PLISTMX(4)=EquipTypeDR
		s PLISTMX(20)=LimitYearsNum
		s PLISTMX(29)=StatcatDR
		&SQL(Update SQLUSER.DHC_EQOpenCheckRequest Values :PLIST() where OCR_RowID=:BussID)
	 	if SQLCODE
	 	{
		 	s Flag=SQLCODE
	 	}
	 	&SQL(Update SQLUSER.DHC_EQOpenCheckList Values :PLISTMX() where OCL_OpenCheckRequestDR=:BussListID)
	 	if SQLCODE
	 	{
			s Flag=SQLCODE
		}
		q
UpdateInStock
		s EquipTypeDRs=""
		s BussListID=0 
		f  s BussListID=$o(^DHCEQInStockList(0,"InStock",BussID,BussListID))  quit:BussListID=""  d
		.s ItemID=$p($g(^DHCEQInStockList(BussListID)),"^",16)
		.q:ItemID=""
		.d GetItemInfo
		.s PLISTMX(16)= LimitYearsNum 	;TUserYearsNum
		.s PLISTMX(18)= StatcatDR
		.&SQL(update sqluser.DHC_EQInStockList values :PLISTMX() where ISL_RowID=:BussListID)
		.i SQLCODE s Flag=SQLCODE
		i Flag'=0  q Flag
		s PLIST(21) = EquipTypeDR	;EquipTypeDR
 		;s PLIST(22) = ""	;StatCatDR 根据版本确定是否修改
 		s Length=$l(EquipTypeDRs,",")
		&SQL(update sqluser.DHC_EQInStock values :PLIST() where IS_RowID=:BussID)
		i SQLCODE
		{
		  s Flag=SQLCODE
		}
		q
UpDateStoreMoVe
		s EquipTypeDRs=""
		s BussListID=0
		for  s BussListID=$o(^DHCEQStoreMoveList(0,"StoreMove",BussID,BussListID))   quit:BussListID=""  d
		.s EquipIDs=^DHCEQStoreMoveList(BussListID,"EX","RowIDs")
		.s Len=$l(EquipIDs,",")
		.for i=1:1:Len  d
		..s EquipID=$p(EquipIDs,",",i)
		..q:EquipID=""
		..s ItemID=$p($g(^DHCEQEquip(EquipID)),"^",7)
		..q:ItemID=""
		..d GetItemInfo 
		s PLIST(17) = EquipTypeDR	;EquipTypeDR
		;s PLIST(18) = StatcatDR ;StatCatDR 根据版本确定是否修改
		s Length=$l(EquipTypeDRs,",")
		&SQL(update sqluser.DHC_EQStoreMove values :PLIST() where SM_RowID=:BussID)
		i SQLCODE
		{
			s Flag=SQLCODE
		}
		q
UpdateReturn
		s EquipTypeDRs=""
		s BussListID=0
		for  s BussListID=$o(^DHCEQReturnList(0,"Return",BussID,BussListID)) quit:BussListID=""  d
		.s EquipIDs=^DHCEQReturnList(BussListID,"EX","RowIDs")
		.s Len=$l(EquipIDs,",")
		.for i=1:1:Len  d
		..s EquipID=$p(EquipIDs,",",i)
		..q:EquipID=""
		..s ItemID=$p($g(^DHCEQEquip(EquipID)),"^",7)
		..q:ItemID=""
		..d GetItemInfo 
		s PLIST(16) = EquipTypeDR	;EquipTypeDR
 		;s PLIST(17) = StatcatDR	;StatCatDR
 		s Length=$l(EquipTypeDRs,",")
 		&SQL(update sqluser.DHC_EQReturn values :PLIST() where R_RowID=:BussID)
		i SQLCODE
 		{
			s Flag=SQLCODE
 		} 
 		q
UpDateDiuse
		s EquipTypeDRs=""
		s KindFlag=$P(^DHCEQDisuseRequest(BussID),"^",44)
		if KindFlag=0  d
		.s EquipID=$P(^DHCEQDisuseRequest(BussID),"^",1)
		.q:EquipID=""
		.s ItemID=$p($g(^DHCEQEquip(EquipID)),"^",7)
		.q:ItemID=""
		.d GetItemInfo 
		else  if KindFlag=1  d
		.s EquipIDs=$g(^DHCEQDisuseRequest(BussID,"EX"))
		.s Len=$l(EquipIDs,",")
		.for i=1:1:Len  d
		..s EquipID=$p(EquipIDs,",",i)
		..q:EquipID=""
		..s ItemID=$p($g(^DHCEQEquip(EquipID)),"^",7)
		..q:ItemID=""
		..d GetItemInfo
		else  d
		.;多批
		.f  s BussListID=$o(^DHCEQDisuseList(0,"Request",BussID,BussListID))  quit:BussListID=""  d
		..i $p(^DHCEQDisuseList(BussListID),"^",2)=0  d
		...s EquipID=$P(^DHCEQDisuseList(BussListID),"^",3)
		...q:EquipID=""
		...s ItemID=$p($g(^DHCEQEquip(EquipID)),"^",7)
		...q:ItemID=""
		...d GetItemInfo
		..e  d
		...s EquipIDs=$g(^DHCEQDisuseList(BussListID,"EX"))
		...s Len=$l(EquipIDs,",")
		...for i=1:1:Len  d
		....s EquipID=$p(EquipIDs,",",i)
		....q:EquipID=""
		....s ItemID=$p($g(^DHCEQEquip(EquipID)),"^",7)
		....q:ItemID=""
		....d GetItemInfo
		if KindFlag'=2 s PLIST(43) = LimitYearsNum	;LimitYears
 		s PLIST(44) = EquipTypeDR	;EquipTypeDR
 		s Length=$l(EquipTypeDRs,",")
 		&SQL(Update SQLUSER.DHC_EQDisuseRequest Values :PLIST() where DR_RowID = :BussID)
 		i SQLCODE
 		{
			s Flag=SQLCODE
 		} 
 		q
GetItemInfo

		s EquipTypeDR=$p($g(^DHCEQCCode("DHCEQCMasterItem",ItemID)),"^",3)
		i EquipTypeDRs="" d
		.s EquipTypeDRs=EquipTypeDR
		e  d 
		.i EquipTypeDRs'[EquipTypeDR  s EquipTypeDRs=EquipTypeDRs_","_EquipTypeDR
		s StatcatDR=$p($g(^DHCEQCCode("DHCEQCMasterItem",ItemID)),"^",5)
		if StatcatDR'="" s LimitYearsNum=$p($g(^DHCEQCCode("DHCEQCStatCat",StatcatDR)),"^",9)
		q
ResetVariables
	//add by QW20180108 QW0024 
	s (ItemID,EquipTypeDR,StatcatDR,LimitYearsNum)=""
	s (BussListID,KindFlag,EquipIDs,EquipID,BussNo)=""
}

/// Add By QW 2019-01-14  bug:QW0025  比较设备项与业务单据类组是否一致
/// 参数：Type-11:"开箱验收",21:"入库",BussListID-单据明细id
/// 返回值:0 一致;1 不一致
/// w ##Class(web.DHCEQFinance2019).BussFilter("11")
ClassMethod BussFilter(Type As %Library.String = "", BussListID As %Library.String = "")
{
	new (Type,BussListID)
	s BussID=""
	s Flag=0
	if Type=11  //验收
	{        
		s ItemID=$p($g(^DHCEQOpenCheckList(BussListID)),"^", 9)
		s BussID=$p($g(^DHCEQOpenCheckList(BussListID)),"^", 1)
		s OldEquipTypeDR=$p($g(^DHCEQOpenCheckRequest(BussID)),"^",2) 

	}elseif Type=21  //入库
	{
		s ItemID=$p($g(^DHCEQInStockList(BussListID)),"^",16)
		s BussID=$p($g(^DHCEQInStockList(BussListID)),"^", 1)
		s OldEquipTypeDR=$p($g(^DHCEQInStock(BussID)),"^",20)
	}
		s NewEquipTypeDR=$p($g(^DHCEQCCode("DHCEQCMasterItem",ItemID)),"^",3)
	if NewEquipTypeDR'=OldEquipTypeDR s Flag=1
	q Flag
}

}
