Class web.DHCEQAddDepreNew Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// 每月定期执行一次计提折旧,单独建立一个任务
/// 因当月入库的下月计提,且当月即使报废也要计提折旧,
/// 故定义在每期第一天凌晨计提当月折旧
/// d ##Class(web.DHCEQAddDepreNew).MonthDepre()
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
		s Result= ##class(web.DHCEQAddDepreNew).GetMonthDepre(MonthStr,"",DepreTypeDR)
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
	.q:(##class(web.DHCEQMonthDepre).CheckNeedDepre(rowid,EquipTypeIDS,DepreFlag))=0   //modify by lmm 2018-12-12
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
		i ($o(^DHCEQMonthDepre(0,"SetMonth",depreSetID,Month,0))'="") q 0  //modify by lmm 2018-12-07
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
	s PLIST(22)="新财务制度补提折旧"   //modify by lmm 2018-12-07
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

}
