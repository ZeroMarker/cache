Class web.DHCEQAdjustData Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Add By DJ
/// 设备类组和类型分错数据调整：(不通用，需调整)
/// 首先将设备项修改正确,根据设备项上定义的设备类组及类型,
/// 相应调整验收单以及设备台帐的设备类组及类型
/// 入参：	StrartID:起始要调整的验收明细ID
/// 	 	EndID:终止要调整的验收明细ID
/// 
/// 下面执行代码为复兴医院执行情况，其他医院若需执行必须修改代码
ClassMethod AdjustEquipTypeByItem(StartID, EndID)
{
	s OCLRowID=StartID-1
	Set $ZT="EquipTypeByItemErr"
	TSTART
	f  s OCLRowID=$o(^DHCEQOpenCheckList(OCLRowID))  q:(OCLRowID="")||(OCLRowID>EndID)  d
	.s EquipTypeDR=$p($g(^DHCEQOpenCheckList(OCLRowID)),"^",3)
	.q:EquipTypeDR=1
	.s Name=$p($g(^DHCEQOpenCheckList(OCLRowID)),"^",2)
	.s OriginalFee=$p($g(^DHCEQOpenCheckList(OCLRowID)),"^",17)
	.q:(EquipTypeDR=2)&&(OriginalFee>=500)
	.q:(EquipTypeDR=3)&&(OriginalFee<500)
	.s ItemDR=$p($g(^DHCEQOpenCheckList(OCLRowID)),"^",9)
	.s OCRRowID=$p($g(^DHCEQOpenCheckList(OCLRowID)),"^",1)
	.i EquipTypeDR=2  d
	..&SQL(Select MI_RowID into :Find From SQLUSER.DHC_EQCMasterItem where MI_Desc=:Name and MI_EquipTypeDR=3)
	..i Find=""  d
	...&SQL(Insert Into SQLUSER.DHC_EQCMasterItem(MI_Desc, MI_Code, MI_EquipTypeDR, MI_CatDR, MI_StatCatDR, MI_UnitDR, MI_InvalidFlag) Select MI_Desc, MI_Code, 3, MI_CatDR, MI_StatCatDR, MI_UnitDR, MI_InvalidFlag From SQLUSER.DHC_EQCMasterItem Where MI_RowID=:ItemDR)
	...s Find=$G(%ROWID)
	.e  d
	..&SQL(Select MI_RowID into :Find From SQLUSER.DHC_EQCMasterItem where MI_Desc=:Name and MI_EquipTypeDR=2)
	..i Find=""  d
	...&SQL(Insert Into SQLUSER.DHC_EQCMasterItem(MI_Desc, MI_Code, MI_EquipTypeDR, MI_CatDR, MI_StatCatDR, MI_UnitDR, MI_InvalidFlag) Select MI_Desc, MI_Code, 2, MI_CatDR, MI_StatCatDR, MI_UnitDR, MI_InvalidFlag From SQLUSER.DHC_EQCMasterItem Where MI_RowID=:ItemDR)
	...s Find=$G(%ROWID)
	.i SQLCODE  d
	..TROLLBACK
	.i SQLCODE q:SQLCODE
	.s equiptype=$p($g(^DHCEQCCode("DHCEQCMasterItem",Find)),"^",3)
	.s statcat=$p($g(^DHCEQCCode("DHCEQCMasterItem",Find)),"^",5)
	.s cat=$p($g(^DHCEQCCode("DHCEQCMasterItem",Find)),"^",4)
	.&SQL(Update SQLUSER.DHC_EQOpenCheckList Set OCL_ItemDR=:Find, OCL_EquipTypeDR=:equiptype, OCL_StatCatDR=:statcat Where OCL_RowID=:OCLRowID)
	.i SQLCODE  d
	..TROLLBACK
	.i SQLCODE q:SQLCODE
	.&SQL(Update SQLUSER.DHC_EQOpenCheckRequest Set OCR_EquipTypeDR=:equiptype, OCR_StatCatDR=:statcat Where OCR_RowID=:OCRRowID)
	.i SQLCODE  d
	..TROLLBACK
	.i SQLCODE q:SQLCODE
	.&SQL(Update SQLUSER.DHC_EQEquip Set EQ_ItemDR=:Find, EQ_EquipTypeDR=:equiptype, EQ_StatCatDR=:statcat, EQ_Status=0, EQ_StockStatus=0 Where EQ_OpenCheckListDR=:OCLRowID)	/// Mozy0145	20141017
	.i SQLCODE d
	..TRollBack
	.i SQLCODE q:SQLCODE
	.w OCLRowID,!
	TCOMMIT
	q 
EquipTypeByItemErr
	Set ErrorMsg=$ZE	     //得到系统返回的错误消息
 	TROLLBACK		         //回滚事务
 	Quit "ERROR"_ErrorMsg    //返回错误消息 ;
}

/// 2010-08-24 Add By DJ
/// 设备原值录入错误调整(可通用)
/// 涉及更新表:验收单,入库单,出库单,台账,生命周期表
/// EqNoIDs串以逗号分隔
/// RightFee：现在正确的原值
/// w ##Class(web.DHCEQAdjustData).AdjustOriginalFee("","")
ClassMethod AdjustOriginalFee(EqNoIDs, RightFee)
{
	i EqNoIDs="" q "没有需要修改的设备编号!"
	i RightFee="" q "未录入修改金额!"
	//检测修改金额是否数字
	i $fn(RightFee,"")'=RightFee q "修改金额不是数字"
	i RightFee<0 q "修改金额为负数!"
	s Len=$L(EqNoIDs,",")
	//检测录入设备编号是否存在
	s Error=""
	f i=1:1:Len
	{
		s CurNo=$p(EqNoIDs,",",i)
		i CurNo'=""
		{
			s CurRowID=$o(^DHCEQEquip(0,"No",CurNo,0))
			i CurRowID="" s Error=Error_CurNo_","
		}
	}
	i Error'=""
	{
		s Error=$e(Error,1,$L(Error)-1)
		q Error_"编号不存在!"
	}
	//更新数据
	Set $ZT="AdjustOriginalFee"
	TSTART
	s SQLCODE=0
	f i=1:1:Len
	{
		q:SQLCODE'=0
		s CurNo=$p(EqNoIDs,",",i)
		q:CurNo=""
		s CurRowID=$o(^DHCEQEquip(0,"No",CurNo,0))
		s InStockListDR=$p($g(^DHCEQEquip(CurRowID)),"^",70)
		s CurOriginalFee=$p($g(^DHCEQEquip(CurRowID)),"^",27)
		s CurNetFee=$p($g(^DHCEQEquip(CurRowID)),"^",28)
		s ChangeFee=RightFee-CurOriginalFee //调整变动金额
		s NetFee=CurNetFee+ChangeFee //调整后净值
		s OCLRowID=$p($g(^DHCEQEquip(CurRowID)),"^",77) //验收明细表(DHC_EQOpenCheckList)RowID
		//验收单
		i OCLRowID'=""
		{
			&SQL(Update SQLUSER.DHC_EQOpenCheckList Set OCL_OriginalFee=:RightFee Where OCL_RowID=:OCLRowID)
		}
		i SQLCODE
		{
			s Error="Update DHC_EQOpenCheckList Fail!"
			q
		}		
		//入库单
		i InStockListDR="" s InStockListDR=$o(^DHCEQInStockList(0,"Equip",CurRowID,0))
		i InStockListDR'=""
		{
			&SQL(Update SQLUSER.DHC_EQInStockList Set ISL_OriginalFee=:RightFee Where ISL_RowID=:InStockListDR)
		}
		i SQLCODE
		{
			s Error="Update DHC_EQInStockList Fail!"
			q
		}
		//单设备出库,退库情况
		s SMLRowID=0
		f  s SMLRowID=$o(^DHCEQStoreMoveList(0,"Equip",CurRowID,SMLRowID)) q:(SMLRowID="")||(SQLCODE'=0)  d
		.&SQL(Update SQLUSER.DHC_EQStoreMoveList Set SML_OriginalFee=:RightFee Where SML_RowID=:SMLRowID)
		i SQLCODE
		{
			s Error="Update (One Equip) DHC_EQStoreMoveList Fail!"
			q
		}
		//批量出库,退库情况
		i InStockListDR'=""  d
		.s SMLRowID=0
		.f  s SMLRowID=$o(^DHCEQStoreMoveList(0,"InStockList",InStockListDR,SMLRowID))  q:(SMLRowID="")||(SQLCODE'=0)  d
		..&SQL(Update SQLUSER.DHC_EQStoreMoveList Set SML_OriginalFee=:RightFee Where SML_RowID=:SMLRowID)
		i SQLCODE
		{
			s Error="Update (Batch Equip) DHC_EQStoreMoveList Fail!"
			q
		}
		//台账
		&SQL(Update SQLUSER.DHC_EQEquip Set EQ_OriginalFee=:RightFee, EQ_NetFee=:NetFee Where EQ_RowID=:CurRowID)
		i SQLCODE
		{
			s Error="Update DHC_EQEquip Fail!"
			q
		}
		//生命周期
		s ChangeDate=0
		f  s ChangeDate=$o(^DHCEQLifeInfo(0,"Equip",CurRowID,ChangeDate))  q:(ChangeDate="")||(SQLCODE'=0)  d
		.s LIRowID=0
		.f  s LIRowID=$o(^DHCEQLifeInfo(0,"Equip",CurRowID,ChangeDate,LIRowID))  q:(LIRowID="")||(SQLCODE'=0)  d
		..s LiFromOriginalFee=$p($g(^DHCEQLifeInfo(LIRowID)),"^",6)+ChangeFee
		..s LiFromNetFee=$p($g(^DHCEQLifeInfo(LIRowID)),"^",7)+ChangeFee
		..s LiToOriginalFee=$p($g(^DHCEQLifeInfo(LIRowID)),"^",11)+ChangeFee
		..s LiToNetFee=$p($g(^DHCEQLifeInfo(LIRowID)),"^",12)+ChangeFee
		..&SQL(Update SQLUSER.DHC_EQLifeInfo Set LI_FromOriginalFee=:LiFromOriginalFee, LI_FromNetFee=:LiFromNetFee, LI_ToOriginalFee=:LiToOriginalFee, LI_ToNetFee=:LiToNetFee Where LI_RowID=:LIRowID)
		..i SQLCODE s Error="Update DHC_EQLifeInfo Fail!"
	}
	i SQLCODE
	{
		TROLLBACK
		q Error
	}
	TCOMMIT
	q "Succeed!"
AdjustOriginalFee
	Set ErrorMsg=$ZE	     //得到系统返回的错误消息
 	TROLLBACK		         //回滚事务
 	Quit "ERROR"_ErrorMsg     //返回错误消息 ;
}

/// Add by Mozy  2010-8-11 (沈阳医大)(可通用)
/// w ##Class(web.DHCEQAdjustData).ChangeLoc("106","795")
/// FromLocDR:原科室	ToLocDR:更改后科室
/// 备注：如果老系统无"设备生命周期信息表",则可把"设备生命周期信息表"部分注释掉
ClassMethod ChangeLoc(FromLocDR, ToLocDR)
{
	Quit:(FromLocDR="")||(ToLocDR="") -1
	
	//Set $ZT="ChangeLocErr"
	
	TStart
	//&SQL(select M_RowID into :Rowid from DHC_EQCModel where M_Code=:Code and M_Desc=:Desc)
 	//if (Rowid'=""){}
	
	// 验收单
	&SQL(Update SQLUSER.DHC_EQOpenCheckList set OCL_UseLocDR=:ToLocDR where OCL_UseLocDR=:FromLocDR)
	if (SQLCODE'=0)&&(SQLCODE'=100)
 	{
	 	TROLLBACK
	 	Quit "验收单:"_SQLCODE
 	}
 	
 	// 入库单
 	&SQL(Update SQLUSER.DHC_EQInStock set IS_BuyLocDR=:ToLocDR where IS_BuyLocDR=:FromLocDR)
	if (SQLCODE'=0)&&(SQLCODE'=100)
 	{
	 	TROLLBACK
	 	Quit "入库单:"_SQLCODE
 	}
 	
 	// 转移单
 	&SQL(Update SQLUSER.DHC_EQStoreMove set SM_ToLocDR=:ToLocDR where SM_ToLocDR=:FromLocDR)
 	if (SQLCODE'=0)&&(SQLCODE'=100)
 	{
	 	TROLLBACK
	 	Quit "转移单:"_SQLCODE
 	}
 	&SQL(Update SQLUSER.DHC_EQStoreMove set SM_FromLocDR=:ToLocDR where SM_FromLocDR=:FromLocDR)
	if (SQLCODE'=0)&&(SQLCODE'=100)
 	{
	 	TROLLBACK
	 	Quit "转移单:"_SQLCODE
 	}
 	
 	// 设备表
 	&SQL(Update SQLUSER.DHC_EQEquip set EQ_UseLocDR=:ToLocDR where EQ_UseLocDR=:FromLocDR)
 	if (SQLCODE'=0)&&(SQLCODE'=100)
 	{
	 	TROLLBACK
	 	Quit "设备表:"_SQLCODE
 	}
 	&SQL(Update SQLUSER.DHC_EQEquip set EQ_StoreLocDR=:ToLocDR where EQ_StoreLocDR=:FromLocDR)
	if (SQLCODE'=0)&&(SQLCODE'=100)
 	{
	 	TROLLBACK
	 	Quit "设备表:"_SQLCODE
 	}
 	
 	// 设备变动表
 	&SQL(Update SQLUSER.DHC_EQChangeStock set CS_FromLocDR=:ToLocDR where CS_FromLocDR=:FromLocDR)
 	if (SQLCODE'=0)&&(SQLCODE'=100)
 	{
	 	TROLLBACK
	 	Quit "设备变动表:"_SQLCODE
 	}
 	&SQL(Update SQLUSER.DHC_EQChangeStock set CS_ToLocDR=:ToLocDR where CS_ToLocDR=:FromLocDR)
	if (SQLCODE'=0)&&(SQLCODE'=100)
 	{
	 	TROLLBACK
	 	Quit "设备变动表:"_SQLCODE
 	}
 	
 	// 设备追加款表
 	&SQL(Update SQLUSER.DHC_EQChangeAccount set CA_UseLocDR=:ToLocDR where CA_UseLocDR=:FromLocDR)
 	if (SQLCODE'=0)&&(SQLCODE'=100)
 	{
	 	TROLLBACK
	 	Quit "设备追加款表:"_SQLCODE
 	}
 	&SQL(Update SQLUSER.DHC_EQChangeAccount set CA_StoreLocDR=:ToLocDR where CA_StoreLocDR=:FromLocDR)
	if (SQLCODE'=0)&&(SQLCODE'=100)
 	{
	 	TROLLBACK
	 	Quit "设备追加款表:"_SQLCODE
 	}
 	
 	// 设备费用表
 	&SQL(Update SQLUSER.DHC_EQLifeFee set LF_UseLocDR=:ToLocDR where LF_UseLocDR=:FromLocDR)
 	if (SQLCODE'=0)&&(SQLCODE'=100)
 	{
	 	TROLLBACK
	 	Quit "设备费用表:"_SQLCODE
 	}
 	&SQL(Update SQLUSER.DHC_EQLifeFee set LF_ManagerLocDR=:ToLocDR where LF_ManagerLocDR=:FromLocDR)
	if (SQLCODE'=0)&&(SQLCODE'=100)
 	{
	 	TROLLBACK
	 	Quit "设备费用表:"_SQLCODE
 	}
 	
 	// 设备生命周期信息表
 	&SQL(Update SQLUSER.DHC_EQLifeInfo set LI_FromUseLocDR=:ToLocDR where LI_FromUseLocDR=:FromLocDR)
	if (SQLCODE'=0)&&(SQLCODE'=100)
 	{
	 	TROLLBACK
	 	Quit "设备生命周期信息表:"_SQLCODE
 	}
 	&SQL(Update SQLUSER.DHC_EQLifeInfo set LI_FromManagerLocDR=:ToLocDR where LI_FromManagerLocDR=:FromLocDR)
	if (SQLCODE'=0)&&(SQLCODE'=100)
 	{
	 	TROLLBACK
	 	Quit "设备生命周期信息表:"_SQLCODE
 	}
 	&SQL(Update SQLUSER.DHC_EQLifeInfo set LI_FromStoreLocDR=:ToLocDR where LI_FromStoreLocDR=:FromLocDR)
	if (SQLCODE'=0)&&(SQLCODE'=100)
 	{
	 	TROLLBACK
	 	Quit "设备生命周期信息表:"_SQLCODE
 	}
 	&SQL(Update SQLUSER.DHC_EQLifeInfo set LI_ToUseLocDR=:ToLocDR where LI_ToUseLocDR=:FromLocDR)
	if (SQLCODE'=0)&&(SQLCODE'=100)
 	{
	 	TROLLBACK
	 	Quit "设备生命周期信息表:"_SQLCODE
 	}
 	&SQL(Update SQLUSER.DHC_EQLifeInfo set LI_ToManagerLocDR=:ToLocDR where LI_ToManagerLocDR=:FromLocDR)
	if (SQLCODE'=0)&&(SQLCODE'=100)
 	{
	 	TROLLBACK
	 	Quit "设备生命周期信息表:"_SQLCODE
 	}
 	&SQL(Update SQLUSER.DHC_EQLifeInfo set LI_ToStoreLocDR=:ToLocDR where LI_ToStoreLocDR=:FromLocDR)
	if (SQLCODE'=0)&&(SQLCODE'=100)
 	{
	 	TROLLBACK
	 	Quit "设备生命周期信息表:"_SQLCODE
 	}
 	
 	TCommit
 	Quit "OK!!!"
 	
ChangeLocErr
	Set ErrorMsg=$ZE	     //得到系统返回的错误消息
	TRollBack
	Quit "ERROR"_ErrorMsg     //返回错误消息 ;
}

/// 创建：zy 2010-11-11  ZY0039
/// 根据设备生命周期信息修改设备启用日期
/// w ##Class(web.DHCEQTest).AdjustStartDate()
ClassMethod AdjustStartDate()
{
	;New StartDate,EQRowID,SQLCODE,SourceType
	Set $ZT="ERROR"
	TStart 
	s StartDate=""
	s SQLCODE=0
	s EQRowID=0
	f  s EQRowID=$o(^DHCEQEquip(EQRowID)) q:EQRowID=""||SQLCODE'=0  d
	.s LIChangeDate=0
	.s StartDate=""
	.f  s LIChangeDate=$o(^DHCEQLifeInfo(0,"Equip",EQRowID,LIChangeDate)) q:(LIChangeDate="")||(StartDate'="")  d
	..s LIRowID=0
	..f  s LIRowID=$o(^DHCEQLifeInfo(0,"Equip",EQRowID,LIChangeDate,LIRowID)) q:(LIRowID="")||(StartDate'="")  d
	...s SourceType=$p($g(^DHCEQLifeInfo(LIRowID)),"^",19)
	...i SourceType=22  s StartDate=LIChangeDate
	.i StartDate'="" d
	..&SQL(update SQLUser.DHC_EQEquip set EQ_StartDate=:StartDate where EQ_RowID=:EQRowID)
	
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE
	}
	TCOMMIT
 	q SQLCODE
ERROR
	TRollBack	
	Set ErrorMsg=$ZE	     //得到系统返回的错误消息
 	Quit "ERROR"_ErrorMsg     //返回错误消息 ;
}

/// Add By JDL 2011-3-30
/// 设备类组和类型分错数据调整：
/// 步骤：
/// 1.首先将设备项信息维护正确,
/// 2.调用该方法，根据设备项上定义的设备类组及类型,
/// 			  相应调整验收单以及设备台帐的设备类组及类型
/// 入参：	TargetItemDR:要调整的设备项DR/// 		
/// 		StrartID:起始要调整的验收明细ID
/// 	 	EndID:终止要调整的验收明细ID
/// 	 	ToItemDR:当且仅当需要将TargetItemDR设备项改为另一设备项时需要传递此参数
/// 返回："OK" 更新成功  其他：失败
/// w ##Class(web.DHCEQAdjustData).AdjustInfoByItem(48,1,100)
ClassMethod AdjustInfoByItem(TargetItemDR, StartID, EndID, ToItemDR As %Library.String = "")
{
	
	Set $ZT="ErrAdjustInfoByItem"
	
	if (TargetItemDR="") q "TargetItemDR is empty!"
	if (StartID<1) q "StartID need greater than 1"
	s OCLRowID=StartID-1	
	i ToItemDR'=""
	{
		s ItemDR=ToItemDR
	}
	else
	{
		s ItemDR=TargetItemDR
	}
	if '$d(^DHCEQCCode("DHCEQCMasterItem",TargetItemDR)) q "TargetItemDR is Invalid!"
	if (ToItemDR'="")&&('$d(^DHCEQCCode("DHCEQCMasterItem",ToItemDR))) q "ToItemDR is Invalid!"
	
	s ToEquipTypeDR=$p($g(^DHCEQCCode("DHCEQCMasterItem",ItemDR)),"^",3)
	s ToEquipCatDR=$p($g(^DHCEQCCode("DHCEQCMasterItem",ItemDR)),"^",4)
	s ToStatCatDR=$p($g(^DHCEQCCode("DHCEQCMasterItem",ItemDR)),"^",5)
	s Date=+$H
	s Time=$p($H,",",2)
	
		
	TSTART
	s SQLCODE=0
	f  s OCLRowID=$o(^DHCEQOpenCheckList(OCLRowID))  q:(OCLRowID="")||(OCLRowID>EndID)||(SQLCODE'=0)  d
	.q:TargetItemDR'=$p($g(^DHCEQOpenCheckList(OCLRowID)),"^",9)
	.
	.s EquipTypeDR=$p($g(^DHCEQOpenCheckList(OCLRowID)),"^",3)
	.s EquipCatDR=$p($g(^DHCEQOpenCheckList(OCLRowID)),"^",6)
	.s StatCatDR=$p($g(^DHCEQOpenCheckList(OCLRowID)),"^",28)
	.i ToItemDR'=""  d
	..&SQL(Update SQLUSER.DHC_EQOpenCheckList Set OCL_ItemDR=:ToItemDR, OCL_EquipTypeDR=:ToEquipTypeDR,OCL_EquiCatDR=:ToEquipCatDR, OCL_StatCatDR=:ToStatCatDR Where OCL_RowID=:OCLRowID)
	..q:SQLCODE
	..&SQL(Update SQLUSER.DHC_EQEquip Set EQ_ItemDR=:ToItemDR, EQ_EquipTypeDR=:ToEquipTypeDR,EQ_EquiCatDR=:ToEquipCatDR, EQ_StatCatDR=:ToStatCatDR Where EQ_OpenCheckListDR=:OCLRowID)	/// Mozy0145	20141017
	..
	.e  d
	..&SQL(Update SQLUSER.DHC_EQOpenCheckList Set OCL_EquipTypeDR=:ToEquipTypeDR,OCL_EquiCatDR=:ToEquipCatDR, OCL_StatCatDR=:ToStatCatDR Where OCL_RowID=:OCLRowID)
	..q:SQLCODE
	..&SQL(Update SQLUSER.DHC_EQEquip Set EQ_EquipTypeDR=:ToEquipTypeDR,EQ_EquiCatDR=:ToEquipCatDR, EQ_StatCatDR=:ToStatCatDR Where EQ_OpenCheckListDR=:OCLRowID)	/// Mozy0145	20141017
	.q:SQLCODE
	.;如果设备类组或设备类型有变动，则需要更新验收单
	.i ((EquipTypeDR'=ToEquipTypeDR)||(StatCatDR'=ToStatCatDR))  d
	..s OCRRowID=$p($g(^DHCEQOpenCheckList(OCLRowID)),"^",1)
	..&SQL(Update SQLUSER.DHC_EQOpenCheckRequest Set OCR_EquipTypeDR=:ToEquipTypeDR, OCR_StatCatDR=:ToStatCatDR Where OCR_RowID=:OCRRowID)
	..q:SQLCODE
	..;同时对调整数据在Global中进行记录
	..s EquipDR=0
	..f  s EquipDR=$o(^DHCEQEquip(0,"OpenCheckList",OCLRowID,EquipDR))  q:(EquipDR="")  d
	...s Status=$p($g(^DHCEQEquip(EquipDR)),"^",38)
	...s StockStatus=$p($g(^DHCEQEquip(EquipDR)),"^",60)
	...s InvalidFlag=$p($g(^DHCEQEquip(EquipDR)),"^",59)
	...s ^DHCEQAdjustData("EquipType",Date,Time,EquipDR)=EquipTypeDR_"^"_EquipCatDR_"^"_StatCatDR_"^"_ToEquipTypeDR_"^"_ToEquipCatDR_"^"_ToStatCatDR
	.
	.w OCLRowID,!
		
	i SQLCODE
	{
		TRollBack
		q SQLCODE
	}
	TCOMMIT
	q "OK" 
ErrAdjustInfoByItem
	Set ErrorMsg=$ZE	     //得到系统返回的错误消息
 	TROLLBACK		         //回滚事务
 	Quit "ERROR"_ErrorMsg    //返回错误消息 ;
}

/// 根据下一个月正确的累计折旧，调整当月的累计折旧值
/// w ##Class(web.DHCEQTest).AdjustReportDepre(2010,11)
ClassMethod AdjustReportDepre(Year, Month)
{
	s SQLCODE=0
	s EquipType=0
	s $ZT="ERRORAdjustReportDepre"
	TStart
	f  s EquipType=$o(^DHCEQMonthReportList(0,"TypeDate",EquipType)) q:((EquipType="")||(SQLCODE'=0))  d
	.s StatCat=0
	.f  s StatCat=$o(^DHCEQMonthReportList(0,"TypeDate",EquipType,Year,Month,StatCat)) q:((StatCat="")||(SQLCODE'=0))  d
	..s StoreLoc=0
	..f  s StoreLoc=$o(^DHCEQMonthReportList(0,"TypeDate",EquipType,Year,Month,StatCat,StoreLoc)) q:((StoreLoc="")||(SQLCODE'=0))  d
	...s RowID=0
	...f  s RowID=$o(^DHCEQMonthReportList(0,"TypeDate",EquipType,Year,Month,StatCat,StoreLoc,RowID)) q:((RowID="")||(SQLCODE'=0))  d
	....s Origin=$p($g(^DHCEQMonthReportList(RowID)),"^",26)
	....s Depre=$p($g(^DHCEQMonthReportList(RowID)),"^",29)
	....s NextTotalDepre=0
	....s NextDepre=0
	....s NextRowID=0
	....s NextYear=Year
	....s NextMonth=Month+1
	....i +NextMonth>12  d
	.....s NextYear=NextYear+1
	.....s NextMonth=1
	....f  s NextRowID=$o(^DHCEQMonthReportList(0,"TypeDate",EquipType,NextYear,NextMonth,StatCat,StoreLoc,NextRowID)) q:NextRowID=""  d
	.....q:(Origin'=$p($g(^DHCEQMonthReportList(NextRowID)),"^",26))
	.....s NextTotalDepre=$p($g(^DHCEQMonthReportList(NextRowID)),"^",28)
	.....s NextDepre=$p($g(^DHCEQMonthReportList(NextRowID)),"^",29)
	....s TotalDepre=NextTotalDepre-NextDepre
	....&SQL(Update SQLUSER.DHC_EQMonthReportList set MRL_TotalDepre=:TotalDepre where MRL_RowID=:RowID)
	
	i SQLCODE'="0" 
	{
		TRollBack
		q "Error SQLCODE:"_SQLCODE
	}
	TCommit
	q "OK"
ERRORAdjustReportDepre
	Set ErrorMsg=$ZE	     //得到系统返回的错误消息
 	TROLLBACK		         //回滚事务
 	Quit "ERRORAdjustReportDepre:"_ErrorMsg     //返回错误消息 ;
}

/// 根据快照中的数据 更新 月结报表中的 净值及累计折旧
/// w ##Class(web.DHCEQTest).MonthReportNetFeeBySnap(2010,10,13)
ClassMethod MonthReportNetFeeBySnap(Year, Month, SnapShotID, EquipTypeIDs As %Library.String = "")
{
	s Node="MonthReportNetFeeBySnap"
	k ^DHCEQTemp(Node,$j)
	w "SnapShot Date:"_##Class(web.DHCEQCommon).TransValueToPage(^DHCEQSnapShot(SnapShotID,"Begin"),"date"),!
	w "Continue input 'G',else input 'Q'"
	b
	
	;s $ZT="ErrMonthReportNetFeeBySnap"	
	TStart
 	s Date=+$H
	s Time=$p($H,",",2)
	i (Month<10)
	{
		s MonthStr=Year_"-0"_Month
	}
	else
	{
		s MonthStr=Year_"-"_Month
	}
	s StartDate=##Class(web.DHCEQReport).GetReportDate(MonthStr,"","")
	s EndDate=$p(StartDate,"^",2)
	s StartDate=$p(StartDate,"^",1)
	
		
	;整理数据,净值及累计折旧
	s rowid=0
	f  s rowid=$o(^DHCEQSnapShot(SnapShotID,"Equip",rowid)) q:(rowid="")  d
	.s gblData=$g(^DHCEQSnapShot(SnapShotID,"Equip",rowid))	
	.d FillMonthReportNetFeeBySnap
	
	&SQL(update SQLUSER.DHC_EQMonthReportList set mrl_totaldepre=0,mrl_NetFee=0 where mrl_year=:Year and mrl_month=:Month)
	i SQLCODE'=0
	{
		TRollBack
		q SQLCODE
	}
	///保存当月有业务数据变化的
	s SQLCODE=0
	s EquipType=0
	f  s EquipType=$o(^DHCEQTemp(Node,$J,Year,Month,EquipType)) q:((EquipType="")||(SQLCODE'=0))  d
	.q:##Class(web.DHCEQCommon).IdInIds(EquipType,EquipTypeIDs)=0
	.s Loc=0
	.f  s Loc=$o(^DHCEQTemp(Node,$J,Year,Month,EquipType,Loc)) q:((Loc="")||(SQLCODE'=0))  d
	..s StatCat=0
	..f  s StatCat=$o(^DHCEQTemp(Node,$J,Year,Month,EquipType,Loc,StatCat)) q:((StatCat="")||(SQLCODE'=0))  d
	...s Origin=""
	...f  s Origin=$o(^DHCEQTemp(Node,$J,Year,Month,EquipType,Loc,StatCat,Origin)) q:((Origin="")||(SQLCODE'=0))  d
	....s ListInfo=$g(^DHCEQTemp(Node,$J,Year,Month,EquipType,Loc,StatCat,Origin))
	....s DepreTotal=$p(ListInfo,"^",1)
	....s NetFee=$p(ListInfo,"^",2)
	....;w DepreTotal_"^"_NetFee,!
	....s MonthReportListID=0
	....s ListID=0
	....f  s ListID=$o(^DHCEQMonthReportList(0,"TypeDate",EquipType,Year,Month,StatCat,Loc,ListID)) q:ListID=""  d
	.....s ListInfo=$g(^DHCEQMonthReportList(ListID))
	.....q:Origin'=$p(ListInfo,"^",26)
	.....s MonthReportListID=ListID
	....k PLIST
	....s PLIST(29)=DepreTotal
	....s PLIST(34)=NetFee
	....;w MonthReportListID_"^"_DepreTotal_"^"_NetFee,!
	....i MonthReportListID=0  d
	.....s PLIST(28)=EquipType
	.....s PLIST(6) = StatCat
	.....s PLIST(27)=Origin
	.....s PLIST(4) = Loc
	.....
	.....s PLIST(2) = Year
	.....s PLIST(3) = Month
	.....s PLIST(5) = MonthStr	
	.....s PLIST(21) = StartDate
	.....s PLIST(22) = EndDate
	.....s PLIST(23) = Date
	.....s PLIST(24) = Time
	.....s PLIST(25) = User
	.....&SQL(Insert Into SQLUSER.DHC_EQMonthReportList Values :PLIST())
	.....i SQLCODE w SQLCODE
	....e  d
	.....&SQL(Update SQLUSER.DHC_EQMonthReportList Values :PLIST() where mrl_RowID=:MonthReportListID)
	
	k ^DHCEQTemp(Node,$j)
	
	i SQLCODE
	{
		TRollBack
		q SQLCODE
	}
	TCommit
	q SQLCODE
	
FillMonthReportNetFeeBySnap
	s StockStatus=$p(gblData,"^",60)
	s InvalidFlag=$p(gblData,"^",59)
	s Status=$p(gblData,"^",38)	
	s Loc=$p(gblData,"^",67)
	s EquipType=$p(gblData,"^",63)
	s Origin=$p(gblData,"^",20)
	i Origin="" s Origin=0
	s StatCat=$p(gblData,"^",75)
	s DepreTotal=$p(gblData,"^",35)
	s NetFee=$p(gblData,"^",28)
	;尚未入库不计
	i StockStatus=0 q
	;以下几种:无效的、报废的、减少出库的均不计入期末净值
	i ((InvalidFlag="Y")||(Status>2)||(StockStatus=3))
	{
		s NetFee=0
	}
	s ListInfo=$g(^DHCEQTemp(Node,$j,Year,Month,EquipType,Loc,StatCat,Origin))
	s DepreTotal=DepreTotal+$p(ListInfo,"^",1)
	s NetFee=NetFee+$p(ListInfo,"^",2)
	
	s ^DHCEQTemp(Node,$j,Year,Month,EquipType,Loc,StatCat,Origin)=DepreTotal_"^"_NetFee
	quit
ErrMonthReportNetFeeBySnap
	Set ErrorMsg=$ZE	     //得到系统返回的错误消息
 	TROLLBACK		         //回滚事务
 	Quit "ErrMonthReportNetFeeBySnap"_ErrorMsg     //返回错误消息 ;
}

/// 根据导入数据调整月报期末在用，期末在库数
/// Add By DJ 2011-04-18
/// w ##Class(web.DHCEQAdjustData).AdjustMonthReport(2011,3,79137,79757)
ClassMethod AdjustMonthReport(Year, Month, SRowID, ERowID)
{
	i (SRowID="")||(ERowID="") q "请输入起始RowID"
	i (Year="")||(Month="") q "请输入年份和月份"
	s YearMonth=Year_"-"_Month
	i Month<10 s YearMonth=Year_"-0"_Month
	s SEDate=##Class(web.DHCEQReport).GetReportDate(YearMonth,"","")
	s SQLCODE=0
	TSTART
	s RowID=SRowID-1
	f  s RowID=$o(^DHCEQEquip(RowID))  q:(RowID="")||(RowID>ERowID)||(SQLCODE'=0)  d
	.s EquipTypeDR=$p($g(^DHCEQEquip(RowID)),"^",63)
	.s StatCatDR=$p($g(^DHCEQEquip(RowID)),"^",75)
	.s OriginDR=$p($g(^DHCEQEquip(RowID)),"^",20)
	.s OriginalFee=$p($g(^DHCEQEquip(RowID)),"^",27)
	.s NetFee=$p($g(^DHCEQEquip(RowID)),"^",28)
	.s DepreTotalFee=$p($g(^DHCEQEquip(RowID)),"^",35)
	.s Status=$p($g(^DHCEQEquip(RowID)),"^",38)
	.s StoreLocDR=$p($g(^DHCEQEquip(RowID)),"^",67)
	.&SQL(Select MRL_RowID Into :Find From SQLUSER.DHC_EQMonthReportList Where MRL_Year=:Year and MRL_Month=:Month and MRL_EquipTypeDR=:EquipTypeDR and MRL_StatCatDR=:StatCatDR and MRL_Origin=:OriginDR and MRL_LocDR=:StoreLocDR)
	.i Find'=""  d
	..i Status=1  d
	...&SQL(Update SQLUSER.DHC_EQMonthReportList Set MRL_UsedEnd=MRL_UsedEnd+:OriginalFee, MRL_NetFee=MRL_NetFee+:NetFee, MRL_TotalDepre=MRL_TotalDepre+:DepreTotalFee Where MRL_RowID=:Find)
	..e  d
	...&SQL(Update SQLUSER.DHC_EQMonthReportList Set MRL_StockEnd=MRL_StockEnd+:OriginalFee, MRL_NetFee=MRL_NetFee+:NetFee, MRL_TotalDepre=MRL_TotalDepre+:DepreTotalFee Where MRL_RowID=:Find)
	.e  d
	..k PLIST
	..s PLIST(3)=Month //Month
	..s PLIST(2)=Year //Year
	..i Status=1  d
	...s PLIST(20)=OriginalFee
	..e  d
	...s PLIST(13)=OriginalFee
	..s PLIST(34)=NetFee
	..s PLIST(29)=DepreTotalFee
	..s PLIST(5)=YearMonth
	..s PLIST(6)=StatCatDR
	..s PLIST(28)=EquipTypeDR
	..s PLIST(4)=StoreLocDR
	..s PLIST(27)=OriginDR
	..s PLIST(21)=$P(SEDate,"^",1)
	..s PLIST(22)=$P(SEDate,"^",2)
	..&SQL(Insert Into SQLUSER.DHC_EQMonthReportList Values :PLIST())
	i SQLCODE
	{
		TROLLBACK
		q "失败!"
	}
	TCOMMIT
	q "成功!"
}

/// Add By DJ 2011-05-27
/// 描述:在设备转移时重复转移同一设备影响月报在用,在库数据
/// 参数说明:IDS        3861:1^3862      3861和3862表示转移明细RowID,冒号后表示重复数量若为空则按照明细数量计算
/// 		 YearMonth  表示需要调整的月报年月格式为YYYY-MM
ClassMethod UpdateMRUseStock(IDS, YearMonth)
{
	i (IDS="")||(YearMonth="") q "参数为空!"
	s Count=$L(IDS,"^")
	s SQLCODE=0
	TStart
	for i=1:1:Count
	{
		q:SQLCODE'=0
		s SMLRowID=$p($p(IDS,"^",i),":",1)
		s SMLQuantity=$p($p(IDS,"^",i),":",2)
		s SMRowID=$p($g(^DHCEQStoreMoveList(SMLRowID)),"^",1)
		s EquipTypeDR=$p($g(^DHCEQStoreMove(SMRowID)),"^",16)
		s StatCatDR=$p($g(^DHCEQStoreMove(SMRowID)),"^",17)
		s FromLocDR=$p($g(^DHCEQStoreMove(SMRowID)),"^",2)
		s ToLocDR=$p($g(^DHCEQStoreMove(SMRowID)),"^",3)
		s MoveType=$p($g(^DHCEQStoreMove(SMRowID)),"^",12)
		s EquipDR=$p($g(^DHCEQStoreMoveList(SMLRowID)),"^",2)
		s InStockListDR=$p($g(^DHCEQStoreMoveList(SMLRowID)),"^",4)
		i EquipDR'=""  d
		.s Origin=$p($g(^DHCEQEquip(EquipDR)),"^",20)
		e  d
		.s Origin=$p($g(^DHCEQInStock($p($g(^DHCEQInStockList(InStockListDR)),"^",1))),"^",15)
		s Quantity=$p($g(^DHCEQStoreMoveList(SMLRowID)),"^",8)
		i (SMLQuantity'="")&&(+SMLQuantity>+Quantity) s SQLCODE=SMLRowID_"修改数量大于实际数量!"
		q:SQLCODE'=0
		i (SMLQuantity'="") s Quantity=SMLQuantity
		s OriginalFee=$p($g(^DHCEQStoreMoveList(SMLRowID)),"^",7)
		s Amount=Quantity*OriginalFee
		i MoveType=0 //库房分配
		{
			&SQL(Update SQLUSER.DHC_EQMonthReportList Set MRL_StockEnd=MRL_StockEnd+:Amount,MRL_StockMoveOut=MRL_StockMoveOut-:Amount Where MRL_MonthStr=:YearMonth and MRL_EquipTypeDR=:EquipTypeDR and MRL_StatCatDR=:StatCatDR and MRL_Origin=:Origin and MRL_LocDR=:FromLocDR)
			i SQLCODE q:SQLCODE
			&SQL(Update SQLUSER.DHC_EQMonthReportList Set MRL_UsedEnd=MRL_UsedEnd-:Amount,MRL_UsedMoveIn=MRL_UsedMoveIn-:Amount Where MRL_MonthStr=:YearMonth and MRL_EquipTypeDR=:EquipTypeDR and MRL_StatCatDR=:StatCatDR and MRL_Origin=:Origin and MRL_LocDR=:ToLocDR)
		}
		i MoveType=1 //科室调拨
		{
			&SQL(Update SQLUSER.DHC_EQMonthReportList Set MRL_UsedEnd=MRL_UsedEnd+:Amount,MRL_UsedMoveOut=MRL_UsedMoveOut-:Amount Where MRL_MonthStr=:YearMonth and MRL_EquipTypeDR=:EquipTypeDR and MRL_StatCatDR=:StatCatDR and MRL_Origin=:Origin and MRL_LocDR=:FromLocDR)
			i SQLCODE q:SQLCODE
			&SQL(Update SQLUSER.DHC_EQMonthReportList Set MRL_UsedEnd=MRL_UsedEnd-:Amount,MRL_UsedMoveIn=MRL_UsedMoveIn-:Amount Where MRL_MonthStr=:YearMonth and MRL_EquipTypeDR=:EquipTypeDR and MRL_StatCatDR=:StatCatDR and MRL_Origin=:Origin and MRL_LocDR=:ToLocDR)
		}
		i MoveType=3 //科室退库
		{
			&SQL(Update SQLUSER.DHC_EQMonthReportList Set MRL_UsedEnd=MRL_UsedEnd+:Amount,MRL_UsedMoveOut=MRL_UsedMoveOut-:Amount Where MRL_MonthStr=:YearMonth and MRL_EquipTypeDR=:EquipTypeDR and MRL_StatCatDR=:StatCatDR and MRL_Origin=:Origin and MRL_LocDR=:FromLocDR)
			i SQLCODE q:SQLCODE
			&SQL(Update SQLUSER.DHC_EQMonthReportList Set MRL_StockEnd=MRL_StockEnd-:Amount,MRL_StockMoveIn=MRL_StockMoveIn-:Amount Where MRL_MonthStr=:YearMonth and MRL_EquipTypeDR=:EquipTypeDR and MRL_StatCatDR=:StatCatDR and MRL_Origin=:Origin and MRL_LocDR=:ToLocDR)
		}
	}
	i SQLCODE
	{
		TROLLBACK
		q "失败!"
	}
	TCOMMIT
	q "成功!"
}

/// 取消折旧至初始状态
/// w ##Class(web.DHCEQAdjustData).CancelDepreForInit("2011-06")
/// 兰州13条
/// select eq_depretotalfee,eq_netfee,eq_originalfee,eq_equiptypedr,eq_statcatdr,eq_originDR,eq_storeLocdr,* from dhc_eqequip where eq_netfee<0
ClassMethod CancelDepreForInit(PreDepreMonth)
{
	n RowID,DepreID,OriginalFee,NetFee,DepreFee,DepreTotalFee,DepreTotal,Years,Depre
	;删除DHC_EQCostAllotDetail,折旧分摊明细
	k ^DHCEQCostAllotDetail
	
	TStart
	
	;根据折旧表,倒推至初始导入数据时的累计折旧
	s SQLCODE=0
	s RowID=0
	f  s RowID=$o(^DHCEQEquip(RowID)) q:((RowID="")||(SQLCODE'=0))  d
	.s DepreID=0
	.s DepreFee=0
	.f  s DepreID=$o(^DHCEQMonthDepre(0,"Equip",RowID,DepreID)) q:((DepreID="")||(SQLCODE'=0))  d
	..s MDStatus=$p($g(^DHCEQMonthDepre(DepreID)),"^",20)	//DJ0136
	..q:MDStatus="3"
	..s DepreFee=DepreFee+$p($g(^DHCEQMonthDepre(DepreID)),"^",14)
	.
	.s Years=$p($g(^DHCEQEquip(RowID)),"^",31)
	.s OriginalFee=$p($g(^DHCEQEquip(RowID)),"^",27)
	.s NetFee=$p($g(^DHCEQEquip(RowID)),"^",28)
	.
	.;根据净值及折旧倒推原累计折旧，仅当折旧大于0时，需要倒推
	.i DepreFee>0  d
	..s NetFee=NetFee+DepreFee
	..s DepreTotalFee=OriginalFee-NetFee
	..;更新设备台帐的累计折旧以及净值
	..&SQL(Update SQLUSER.DHC_EQEquip Set EQ_DepreTotalFee=:DepreTotalFee,EQ_NetFee=:NetFee where EQ_RowID=:RowID)
	..q:SQLCODE'=0
	..;更新折旧设置的累计折旧及累计折旧月数	..
	..i Years>0  d
	...s DepreTotal=DepreTotalFee*(12*Years)/OriginalFee
	...s DepreTotal=##Class(web.DHCEQCommon).FormatNumber(DepreTotal,"",0)
	..e  d
	...s DepreTotal=1
	..&SQL(Update SQLUSER.DHC_EQDepreSet Set DS_DepreTotalFee=:DepreTotalFee,DS_DepreTotal=:DepreTotal,DS_PreDepreMonth=:PreDepreMonth where DS_EquipDR=:RowID and DS_MainFlag='Y')
	..q:SQLCODE'=0
	.e  d
	..;没有折旧信息时，根据台帐累计折旧信息，更新折旧设置
	..s DepreTotalFee=$p($g(^DHCEQEquip(RowID)),"^",35)
	..s DepreTotal=0
	..i DepreTotalFee>0  d
	...s DepreTotal=(DepreTotalFee*(12*Years))/OriginalFee
	...s DepreTotal=##Class(web.DHCEQCommon).FormatNumber(DepreTotal,"",0)
	..&SQL(Update SQLUSER.DHC_EQDepreSet Set DS_DepreTotalFee=:DepreTotalFee,DS_DepreTotal=:DepreTotal,DS_PreDepreMonth=:PreDepreMonth where DS_EquipDR=:RowID and DS_MainFlag='Y')
	
	
	i SQLCODE
	{
		TRollBack
		q SQLCODE
	}
	
	;删除DHC_EQMonthDepre
	k ^DHCEQMonthDepre
	;删除折旧对应的DHC_EQLifeInfo
	&SQL(Delete From SQLUSER.DHC_EQLifeInfo Where LI_SourceType='35')
	
	i SQLCODE
	{
		TRollBack
		q SQLCODE
	}
	TCommit
	q SQLCODE
ErrCancelDepreForInit
	Set ErrorMsg=$ZE	     //得到系统返回的错误消息
 	TROLLBACK		         //回滚事务
 	Quit "ErrCancelDepreForInit"_ErrorMsg     //返回错误消息 ;
}

/// 调整数据后用于检测
/// 检测刚导入数据的快照 与 最新数据调整后，比较累计折旧与净值是否一致。
/// w ##Class(web.DHCEQAdjustData).CheckEquipDepreTotal(1)
ClassMethod CheckEquipDepreTotal(SnapID)
{
	s RowID=0
	f  s RowID=$o(^DHCEQEquip(RowID)) q:((RowID=""))  d
	.s OriginalFee=$p($g(^DHCEQEquip(RowID)),"^",27)
	.s NetFee=$p($g(^DHCEQEquip(RowID)),"^",28)
	.s DepreTotalFee=$p($g(^DHCEQEquip(RowID)),"^",35)
	.q:'$d(^DHCEQSnapShot(SnapID,"Equip",RowID))
	.s SnapData=$g(^DHCEQSnapShot(SnapID,"Equip",RowID))
	.s SnapOriginalFee=$p(SnapData,"^",27)
	.s SnapNetFee=$p(SnapData,"^",28)
	.s SnapDepreTotalFee=$p(SnapData,"^",35)
	.
	.if ((NetFee'=SnapNetFee)||(DepreTotalFee'=SnapDepreTotalFee))  d
	..w "RowID:"_RowID_"  "_OriginalFee_"^"_NetFee_"^"_DepreTotalFee_" && "_SnapNetFee_"^"_SnapDepreTotalFee,!
}

/// ------------------------------------------------------
/// ZY0080 2011-09-27
/// 以下为调整数据 界面操作及导入调整数据相关程序
/// --------------------------------------------------------
/// --------------------------------------------------------
/// add by zy 2011-09-25 ZY0080
/// 数据调整类型
/// -----------------------------------------------------
ClassMethod AdjustTypeList(name, width, Type As %String = "") As %String
{
	;;下拉列表
	w ##class(web.DHCEQCommon).GetDefaultStyle(name,"")   //hisui改造 add wy 2019-10-28
	;w "<select name='"_name_"' id='"_name_"' style='width:"_width_"' HEIGHT=0>"
	i ((Type'="5")&&(Type'="6"))  d
	.w "<option value=></option>"
	i Type=""  d
	.w "<option value=1>调整数据</option>"
	.w "<option value=2>新增数据</option>"
	.w "<option value=3>删除数据</option>"
	.w "<option value=4>取消报废</option>"
	.;w "<option value=9>其他调整</option>"
	i Type="5"  d
	.w "<option value=5>设备合并</option>"	//2014-12-26 DJ0133
	i Type="6"  d
	.w "<option value=6>设备拆分</option>"	//2014-12-26 DJ0133
	w "</select>",!
}

/// add by zy 2011-09-25 ZY0080
/// 数据调整数据查询
Query AdjustDate(TypeDR As %String = "", BeginDate As %String = "", EndDate As %String = "", ReportFlag As %String = "", UserFlag As %String = "", RequestUser As %String = "") As %Query(ROWSPEC = "TRowID:%String,TType:%String,TReportFlag:%String,TDate:%String,TSQL:%String,TSourceFile:%String,TContent:%String,TRequestUser:%String,TUserDR:%String,TUser:%String,TRemark:%String,TStatus:%String,TDisplayFlag:%String,TUpdateUserDR:%String,TUpdateUser:%String,TUpdateDate:%String,TInvalidUserDR:%String,TInvalidUser:%String,TInvalidDate:%String,TInvalidReason:%String,THold1:%String,THold2:%String,THold3:%String,THold4:%String,THold5:%String,TRow:%String,TTypeDR:%String")
{
}

ClassMethod AdjustDateExecute(ByRef qHandle As %Binary, TypeDR As %String = "", BeginDate As %String = "", EndDate As %String = "", ReportFlag As %String = "", UserFlag As %String = "", RequestUser As %String = "") As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	Set TRow=0
	s UserFlag=##Class(web.DHCEQCommon).TransValueFromPage(UserFlag,"bool")
	s ReportFlag=##Class(web.DHCEQCommon).TransValueFromPage(ReportFlag,"bool")
	s SDate=##Class(web.DHCEQCommon).TransValueFromPage(BeginDate,"date")
	s EDate=##Class(web.DHCEQCommon).TransValueFromPage(EndDate,"date")	
	d BuildDataAdjustDate
	Quit $$$OK
BuildDataAdjustDate
	s rowid=0
	f  s rowid=$o(^DHCEQAdjustData(rowid))  quit:rowid=""  d
	.d ResetVariablesAdjustDate
	.s TRowID = rowid										//rowid
	.s TTypeDR=$p($g(^DHCEQAdjustData(rowid)),"^",1) 			//调整类型
	.quit:(TypeDR'="")&&(TTypeDR'=TypeDR)
	.s TType=$Case(TTypeDR,"1":"调整数据","2":"新增数据","3":"删除数据","4":"取消报废","5":"设备合并","6":"设备拆分","9":"其他调整",:"未定义")
	.s TReportFlag=$p($g(^DHCEQAdjustData(rowid)),"^",2) 	//描述
	.;s TReportFlag=##Class(web.DHCEQCommon).TransValueToPage(TReportFlag,"bool")
	.quit:(ReportFlag'="")&&(TReportFlag'=ReportFlag)
	.s TDate=$p($g(^DHCEQAdjustData(rowid)),"^",3) 			//日期
	.quit:(SDate'="")&&(TDate<SDate)
	.quit:(EDate'="")&&(TDate>EDate)
	.s TTime=$p($g(^DHCEQAdjustData(rowid)),"^",4) 			//时间
	.i ((TDate'="")&&(TTime'="")) d
	..s TDate=##Class(web.DHCEQCommon).TransValueToPage(TDate_","_TTime,"datetime")
	.e  d
	..s TDate=""
	.s TSQL=$p($g(^DHCEQAdjustData(rowid)),"^",5) 			//
	.s TSourceFile=$p($g(^DHCEQAdjustData(rowid)),"^",6)  	//
	.s TContent=$p($g(^DHCEQAdjustData(rowid)),"^",7)  		//
	.s TRequestUser=$p($g(^DHCEQAdjustData(rowid)),"^",8)  //
	.quit:(RequestUser'="")&&(TRequestUser'[RequestUser)
	.s TUserDR=$p($g(^DHCEQAdjustData(rowid)),"^",9)  		//
	.s TUser=##Class(web.DHCEQCommon).GetTrakNameByID("user",TUserDR)
	.s TRemark=$p($g(^DHCEQAdjustData(rowid)),"^",10)  		//
	.s TStatus=$p($g(^DHCEQAdjustData(rowid)),"^",11)  		//
	.i TStatus'="" s TStatus=$Case(TStatus,"0":"新增","1":"执行","2":"作废")
	.s TDisplayFlag=$p($g(^DHCEQAdjustData(rowid)),"^",12)
	.;s TDisplayFlag=##Class(web.DHCEQCommon).TransValueToPage(TDisplayFlag,"bool")
	.
	.s TUpdateUserDR=$p($g(^DHCEQAdjustData(rowid)),"^",13)
	.s TUpdateUser=##Class(web.DHCEQCommon).GetTrakNameByID("user",TUpdateUserDR)
	.s TUpdateDate=$p($g(^DHCEQAdjustData(rowid)),"^",14)
	.s TUpdateTime=$p($g(^DHCEQAdjustData(rowid)),"^",15)
	.s TUpdateDate=##Class(web.DHCEQCommon).TransValueToPage(TUpdateDate_","_TUpdateTime,"datetime")
	.s TInvalidUserDR=$p($g(^DHCEQAdjustData(rowid)),"^",16)
	.s TInvalidUser=##Class(web.DHCEQCommon).GetTrakNameByID("user",TInvalidUserDR)
	.s TInvalidDate=$p($g(^DHCEQAdjustData(rowid)),"^",17)
	.s TInvalidTime=$p($g(^DHCEQAdjustData(rowid)),"^",18)
	.s TInvalidDate=##Class(web.DHCEQCommon).TransValueToPage(TInvalidDate_","_TInvalidTime,"datetime")
	.s TInvalidReason=$p($g(^DHCEQAdjustData(rowid)),"^",19)
	.
	.s THold1=$p($g(^DHCEQAdjustData(rowid)),"^",20)
	.quit:((UserFlag="Y")&&(THold1'="0"))  //0,单台调整;1,批量调整
	.quit:((UserFlag="N")&&(THold1'="1"))
	.quit:((UserFlag="N")&&(TypeDR="")&&((TTypeDR=5)||(TTypeDR=6)))
	.s THold1=$Case(THold1,"0":"单台调整","1":"批量调整",:"未定义")
	.s THold2=$p($g(^DHCEQAdjustData(rowid)),"^",21)
	.s THold3=$p($g(^DHCEQAdjustData(rowid)),"^",22)
	.s THold4=$p($g(^DHCEQAdjustData(rowid)),"^",23)
	.s THold5=$p($g(^DHCEQAdjustData(rowid)),"^",24)
	.d OutputRowAdjustDate
	quit
OutputRowAdjustDate
	Set TRow=TRow+1
   	Set Data=$lb(TRowID,TType,TReportFlag,TDate,TSQL,TSourceFile,TContent,TRequestUser,TUserDR,TUser,TRemark,TStatus,TDisplayFlag,TUpdateUserDR,TUpdateUser,TUpdateDate,TInvalidUserDR,TInvalidUser,TInvalidDate,TInvalidReason,THold1,THold2,THold3,THold4,THold5,TRow,TTypeDR)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesAdjustDate
	Set (TRowID,TType,TReportFlag,TDate,TSQL,TSourceFile,TContent,TRequestUser,TUserDR,TUser,TRemark,TStatus,TDisplayFlag,TUpdateUserDR,TUpdateUser,TUpdateDate,TInvalidUserDR,TInvalidUser,TInvalidDate,TInvalidReason,THold1,THold2,THold3,THold4,THold5,TTypeDR)=""
	quit
}

ClassMethod AdjustDateFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = AdjustDateExecute ]
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

ClassMethod AdjustDateClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = AdjustDateExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)

	Quit $$$OK
}

/// add by zy 2011-09-25 ZY0080
/// 数据调整数据明细
/// modify by lmm 375323 添加入参：TRow
Query AdjustDateList(RowID) As %Query(ROWSPEC = "TRowID:%String,TEquipDR:%String,TEquip:%String,TFromLocDR:%String,TFromLoc:%String,TFromEquipTypeDR:%String,TFromEquipType:%String,TFromStatCatDR:%String,TFromStatCat:%String,TFromOriginDR:%String,TFromOrigin:%String,TFromInfo:%String,TToLocDR:%String,TToLoc:%String,TToEquipTypeDR:%String,TToEquipType:%String,TToStatCatDR:%String,TToStatCat:%String,TToOriginDR:%String,TToOrigin:%String,TToInfo:%String,TEQStatus:%String,TOriginalFee:%String,TDepreTotal:%String,TNetFee:%String,THold1:%String,THold2:%String,THold3:%String,THold4:%String,THold5:%String,THold6:%String,TNo:%String,TRow:%String")
{
}

ClassMethod AdjustDateListExecute(ByRef qHandle As %Binary, RowID) As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	if RowID="" Quit $$$OK
	d BuildDataAdjustDateList
	Quit $$$OK
BuildDataAdjustDateList
	s rowid=0
	s TRow=0   ///add by lmm 2017-05-19 375323
	f  s rowid=$Order(^DHCEQAdjustDataList(0,"AdjustData",RowID,rowid)) quit:rowid=""  d
	.d ResetVariablesAdjustDateList
	.s TRowID = rowid											//rowid
	.s TEquipDR=$p($g(^DHCEQAdjustDataList(rowid)),"^",2) 		//设备
	.if TEquipDR'="" s TEquip=$p($g(^DHCEQEquip(TEquipDR)),"^",1)
	.if TEquipDR'="" s TNo=$p($g(^DHCEQEquip(TEquipDR)),"^",71)
	.s TFromLocDR=$p($g(^DHCEQAdjustDataList(rowid)),"^",3) 	//原科室
	.s TFromLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept",TFromLocDR)
	.s TFromEquipTypeDR=$p($g(^DHCEQAdjustDataList(rowid)),"^",4) 	//原类组
	.s TFromEquipType=##Class(web.DHCEQCommon).GetTrakNameByID("equiptype",TFromEquipTypeDR)
	.s TFromStatCatDR=$p($g(^DHCEQAdjustDataList(rowid)),"^",5) 	//原类型
	.s TFromStatCat=##Class(web.DHCEQCommon).GetTrakNameByID("statcat",TFromStatCatDR)
	.s TFromOriginDR=$p($g(^DHCEQAdjustDataList(rowid)),"^",6) 	//原来源
	.if TFromOriginDR'="" s TFromOrigin=$p($g(^DHCEQCCode("DHCEQCOrigin",TFromOriginDR)),"^",2)
	.s TFromInfo=$p($g(^DHCEQAdjustDataList(rowid)),"^",7) 		//原其他信息
	.s TToLocDR=$p($g(^DHCEQAdjustDataList(rowid)),"^",8) 	//原科室
	.s TToLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept",TToLocDR)
	.s TToEquipTypeDR=$p($g(^DHCEQAdjustDataList(rowid)),"^",9) 	//原类组
	.s TToEquipType=##Class(web.DHCEQCommon).GetTrakNameByID("equiptype",TToEquipTypeDR)
	.s TToStatCatDR=$p($g(^DHCEQAdjustDataList(rowid)),"^",10) 	//原类型
	.s TToStatCat=##Class(web.DHCEQCommon).GetTrakNameByID("statcat",TToStatCatDR)
	.s TToOriginDR=$p($g(^DHCEQAdjustDataList(rowid)),"^",11) 	//原来源
	.i TToOriginDR'="" s TToOrigin=$p($g(^DHCEQCCode("DHCEQCOrigin",TToOriginDR)),"^",2)
	.s TToInfo=$p($g(^DHCEQAdjustDataList(rowid)),"^",12) 		//原其他信息
	.s TEQStatus=$p($g(^DHCEQAdjustDataList(rowid)),"^",13) 		//状态
	.s TEQStatus=##class(web.DHCEQEquip).GetEquipStatusDisplay(TEQStatus)
	.s TOriginalFee=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQAdjustDataList(rowid)),"^",14),"") 		//原值
	.s TDepreTotal=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQAdjustDataList(rowid)),"^",15),"") 		//累计折旧
	.s TNetFee=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQAdjustDataList(rowid)),"^",16),"") 		//净值
	.s THold1=$p($g(^DHCEQAdjustDataList(rowid)),"^",17)
	.s THold2=$p($g(^DHCEQAdjustDataList(rowid)),"^",18)
	.s THold3=$p($g(^DHCEQAdjustDataList(rowid)),"^",19)
	.s THold4=$p($g(^DHCEQAdjustDataList(rowid)),"^",20)
	.s THold5=$p($g(^DHCEQAdjustDataList(rowid)),"^",21)
	.s THold6=$p($g(^DHCEQAdjustDataList(rowid)),"^",22)
	.d OutputRowAdjustDateList
	quit
OutputRowAdjustDateList
	s TRow=TRow+1   ///add by lmm 2017-05-19 375323
    s Data=$lb(TRowID,TEquipDR,TEquip,TFromLocDR,TFromLoc,TFromEquipTypeDR,TFromEquipType,TFromStatCatDR,TFromStatCat,TFromOriginDR,TFromOrigin,TFromInfo,TToLocDR,TToLoc,TToEquipTypeDR,TToEquipType,TToStatCatDR,TToStatCat,TToOriginDR,TToOrigin,TToInfo,TEQStatus,TOriginalFee,TDepreTotal,TNetFee,THold1,THold2,THold3,THold4,THold5,THold6,TNo,TRow)  ///modify by lmm 2017-05-19 375323
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesAdjustDateList
	s (TRowID,TEquipDR,TEquip,TFromLocDR,TFromLoc,TFromEquipTypeDR,TFromEquipType,TFromStatCatDR,TFromStatCat,TFromOriginDR,TFromOrigin,TFromInfo,TToLocDR,TToLoc,TToEquipTypeDR,TToEquipType,TToStatCatDR,TToStatCat,TToOriginDR,TToOrigin,TToInfo,TEQStatus,TOriginalFee,TDepreTotal,TNetFee,THold1,THold2,THold3,THold4,THold5,THold6,TNo)=""
	quit
}

ClassMethod AdjustDateListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = AdjustDateListExecute ]
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

ClassMethod AdjustDateListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = AdjustDateListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)

	Quit $$$OK
}

/// add by zy 2011-09-25 ZY0080
/// 更新数据调整记录信息
/// 参数说明:
///         RowID,调整记录ID
///         Val,调整记录信息字符串
ClassMethod SaveAdjustData(RowID, Val, User As %String = "")
{
	new Date,Time
	k PLIST
	s Date=+$H
	s Time=$P($H,",",2)
	i User="" s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	s PLIST(2)=$P(Val,"^",1)
	s PLIST(3)=##class(web.DHCEQCommon).TransValueFromPage($P(Val,"^",2),"bool")	//reportFlag
	//s PLIST(4)=Date
	//s PLIST(5)=Time
	s PLIST(6)=$P(Val,"^",3)
	s PLIST(7)=$P(Val,"^",4)
	s PLIST(8)=$P(Val,"^",5)
	s PLIST(9)=$P(Val,"^",6)
	//s PLIST(10)=User
	s PLIST(11)=$P(Val,"^",7)
	s PLIST(12)="0"
	s PLIST(13)=##class(web.DHCEQCommon).TransValueFromPage($P(Val,"^",8),"bool")	//DisplayFlag
	s PLIST(14)=User
	s PLIST(15)=Date
	s PLIST(16)=Time
	//s PLIST(17)=InvalidUserDR
	//s PLIST(18)=InvalidDate
	//s PLIST(19)=InvalidTime
	//s PLIST(20)=InvalidReason
	s PLIST(21)=$P(Val,"^",9)
	s PLIST(22)=$P(Val,"^",10)
	s PLIST(23)=$P(Val,"^",11)
	s PLIST(24)=$P(Val,"^",12)
	s PLIST(25)=$P(Val,"^",13)
	if (RowID="")
	{
		&SQL(insert into sqluser.DHC_EQAdjustData values :PLIST())
	}
	else
	{
		&SQL(update sqluser.DHC_EQAdjustData values :PLIST() where AD_RowID=:RowID)
	}
	i SQLCODE q SQLCODE		//czf 2014955 2021-07-04
	s RowID=$G(%ROWID)
	q RowID
}

/// add by zy 2011-09-25 ZY0080
/// 更新数据调整记录信息
/// 参数说明:
///         RowID,调整记录明细ID
///         Val,调整记录明细信息字符串
///         Type,调整类型：0,存一条明细;1,存信息到临时global;2,从临时global中取数据存到表中
ClassMethod SaveAdjustDataList(RowID, Val, Type)
{
	new SQLCODE,AdjustDataDR,Index,TempVal,AdjustType
	
	s SQLCODE=0
	Set $ZT="SaveAdjustDataList"
	TSTART
	if Type="0"
	{
		k PLIST
		s AdjustDataDR=$P(Val,"^",1)
		s PLIST(2)=$P(Val,"^",1)   //ADL_AdjustDataDR
		
		s AdjustType=$p($g(^DHCEQAdjustData($P(Val,"^",1))),"^",1)
		
		s PLIST(3)=$P(Val,"^",2)   //ADL_EquipDR
		s PLIST(4)=$p($g(^DHCEQEquip($P(Val,"^",2))),"^",67)   //ADL_FromLocDR
		s PLIST(5)=$p($g(^DHCEQEquip($P(Val,"^",2))),"^",63)   //ADL_FromEquipTypeDR
		s PLIST(6)=$p($g(^DHCEQEquip($P(Val,"^",2))),"^",75)   //ADL_FromStatCatDR
		s PLIST(7)=$p($g(^DHCEQEquip($P(Val,"^",2))),"^",20)   //ADL_FromOriginDR
		s PLIST(8)=$P(Val,"^",3)   //ADL_FromInfo
		s PLIST(9)=$P(Val,"^",4)   //ADL_ToLocDR
		s PLIST(10)=$P(Val,"^",5)   //ADL_ToEquipTypeDR
		s PLIST(11)=$P(Val,"^",6)   //ADL_ToStatCatDR
		s PLIST(12)=$P(Val,"^",7)   //ADL_ToOriginDR
		s PLIST(13)=$P(Val,"^",8)   //ADL_ToInfo
		s PLIST(14)=$p($g(^DHCEQEquip($P(Val,"^",2))),"^",38)   //ADL_EQStatus
		s PLIST(15)=$p($g(^DHCEQEquip($P(Val,"^",2))),"^",27)   //ADL_OriginalFee
		s PLIST(16)=$p($g(^DHCEQEquip($P(Val,"^",2))),"^",35)   //ADL_DepreTotal
		s PLIST(17)=$p($g(^DHCEQEquip($P(Val,"^",2))),"^",28)   //ADL_NetFee
		s PLIST(18)=$P(Val,"^",9)   //ADL_Hold1
		s PLIST(19)=$P(Val,"^",10)   //ADL_Hold2
		s PLIST(20)=$P(Val,"^",11)   //ADL_Hold3
		s PLIST(21)=$P(Val,"^",12)   //ADL_Hold4
		s PLIST(22)=$P(Val,"^",13)   //ADL_Hold5
		s PLIST(23)=$P(Val,"^",14)   //ADL_Hold6
		
		if AdjustType=2  //新增数据
		{
			k PLIST(4)
			k PLIST(5)
			k PLIST(6)
			k PLIST(7)
			k PLIST(8)
		}
		elseif AdjustType=3   //删除
		{
			k PLIST(9)
			k PLIST(10)
			k PLIST(11)
			k PLIST(12)
			k PLIST(13)
		}
		elseif AdjustType=4   //取消报废
		{
			k PLIST(4)
			k PLIST(5)
			k PLIST(6)
			k PLIST(7)
			k PLIST(8)
		}
	
		if (RowID="")
		{
			&SQL(insert into sqluser.DHC_EQAdjustDataList values :PLIST())
		}
		else
		{
			&SQL(update sqluser.DHC_EQAdjustDataList values :PLIST() where ADL_RowID=:RowID)
		}
	}
	elseif Type="1" //批量导入要调整的数据时，先检测数据的合理性，同时存在临时global中
	{
		s Index=$order(^TEMPDHCEQ("DHCEQAdjustDataList",""),-1)
		s Index=Index+1
		s ^TEMPDHCEQ("DHCEQAdjustDataList",Index)=Val
	}
	elseif Type="2" //批量写入明细，从临时global中取数据
	{
		s Index=0
		for  set Index=$order(^TEMPDHCEQ("DHCEQAdjustDataList",Index)) q:(Index="")||(SQLCODE="")  d
		.s TempVal=$G(^TEMPDHCEQ("DHCEQAdjustDataList",Index))
		.quit:TempVal=""
		.s SQLCODE=##class(web.DHCEQAdjustData).SaveAdjustDataList("",TempVal,"0")
		k ^TEMPDHCEQ("DHCEQAdjustDataList")
	}
 	i SQLCODE
 	{
		TROLLBACK
		q SQLCODE
 	}
 	TCOMMIT
 	q SQLCODE
SaveAdjustDataList 
	Set ErrorMsg=$ZE	     //得到系统返回的错误消息
 	TROLLBACK		         //回滚事务
 	Quit "SaveAdjustDataList"_ErrorMsg     //返回错误消息 ;
}

/// add by zy 2011-09-25 ZY0080
/// 删除记录
/// 参数说明:
///         RowID,调整记录ID
/// w ##class(web.DHCEQAdjustData).ExecuteAdjustData("1")
ClassMethod DeleteAdjustData(RowID)
{
	new SQLCODE
	s SQLCODE=0
	Set $ZT="ERRORDelete"
	TSTART
	&SQL(delete from  sqluser.DHC_EQAdjustData  where AD_RowID=:RowID)
 	i SQLCODE
 	{
		TROLLBACK
		q SQLCODE
 	}
	&SQL(delete from  sqluser.DHC_EQAdjustDataList  where ADL_AdjustDataDR=:RowID)
	i SQLCODE=100 s SQLCODE=0
 	i SQLCODE
 	{
		TROLLBACK
		q SQLCODE
 	}
 	TCOMMIT
 	q SQLCODE
ERRORDelete 
	Set ErrorMsg=$ZE	     //得到系统返回的错误消息
 	TROLLBACK		         //回滚事务
 	Quit "ERRORDelete"_ErrorMsg     //返回错误消息 ;
}

/// add by zy 2011-09-25 ZY0080
/// 执行调整
/// 参数说明:
///         RowID,调整记录ID
/// w ##class(web.DHCEQAdjustData).ExecuteAdjustData("1")
ClassMethod ExecuteAdjustData(AdjustDataDR, User As %String = "")
{
	new Date,Time,AdjustType,SQLCODE,EquipDR
	if AdjustDataDR="" quit ""
	k EQPL,PLIST,LI
	Set $ZT="ERRORExecute"
	s Date=+$H
	s Time=$P($H,",",2)
	i User="" s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	
	s LI(16)=Date				//变动日期
	s LI(17)=Time				//变动时间
 	s LI(19)="O"				//生命周期类型
 	s LI(20)=61					//来源类型
 	s LI(22)=""					//来源辅助类型
 	s LI(27)=User				//更新人
 	s LI(28)=Date				//更新日期
 	s LI(29)=Time				//更新时间

	s SQLCODE=0
	TSTART
	s AdjustType=$p($g(^DHCEQAdjustData(AdjustDataDR)),"^",1)
	//Add By DJ 2014-12-26 DJ0133 合并数据是否存在主设备及合并设备是否类组,类型,科室,来源都一致
	s (HBOriginalFee,HBNetFee,HBDepreTotalFee,HBNetRemainFee)=""
	s MainEquipDR=""
	s TempID=$I(^DHCEQTemp("AdjustData",+$H))
	i AdjustType=5
	{
		d ##Class(web.DHCEQCommon).KillTempGlobalNew("AdjustData",TempID)
		s SQLCODE=..CheckHBEquip(AdjustDataDR,"")
		i SQLCODE
		{
			TROLLBACK
			q SQLCODE
		}
		s MainEquipDR=..CheckHBEquip(AdjustDataDR,"1")
	}
	//1:调整数据 2:新增数据 3:删除数据 4.取消报废 5.设备合并 6.拆分设备 9.其他调整
	
	s RowID=0
	for  set RowID=$Order(^DHCEQAdjustDataList(0,"AdjustData",AdjustDataDR,RowID)) quit:(RowID="")||(SQLCODE'=0)  d
	.k EQPL
	.s EquipDR=$p($g(^DHCEQAdjustDataList(RowID)),"^",2)
	.s LocDR=$p($g(^DHCEQEquip(EquipDR)),"^",19)
	.s StoreLocDR=$p($g(^DHCEQEquip(EquipDR)),"^",67)
	.s EquipTypeDR=$p($g(^DHCEQEquip(EquipDR)),"^",63)
	.s StatCatDR=$p($g(^DHCEQEquip(EquipDR)),"^",75)
	.s OriginDR=$p($g(^DHCEQEquip(EquipDR)),"^",20)
	.s Status=$p($g(^DHCEQEquip(EquipDR)),"^",38)
	.s OriginalFee=$p($g(^DHCEQEquip(EquipDR)),"^",27)
	.s DepreTotal=$p($g(^DHCEQEquip(EquipDR)),"^",35)
	.s NetFee=$p($g(^DHCEQEquip(EquipDR)),"^",28)
	.s NetRemainFee=$p($g(^DHCEQEquip(EquipDR)),"^",29)		//2014-12-26 DJ DJ0133
	.s FromLocDR=$p($g(^DHCEQAdjustDataList(RowID)),"^",3)
	.s FromEquipTypeDR=$p($g(^DHCEQAdjustDataList(RowID)),"^",4)
	.s FromStatCatDR=$p($g(^DHCEQAdjustDataList(RowID)),"^",5)
	.s FromOriginDR=$p($g(^DHCEQAdjustDataList(RowID)),"^",6)
	.s FromStatus=$p($g(^DHCEQAdjustDataList(RowID)),"^",13)
	.s FromOriginalFee=$p($g(^DHCEQAdjustDataList(RowID)),"^",14)
	.s FromDepreTotal=$p($g(^DHCEQAdjustDataList(RowID)),"^",15)
	.s FromNetFee=$p($g(^DHCEQAdjustDataList(RowID)),"^",16)
	.s FromNetRemainFee=$p($g(^DHCEQAdjustDataList(RowID)),"^",7)	//2014-12-26 DJ DJ0133
	.s vMainFlag=$p($g(^DHCEQAdjustDataList(RowID)),"^",17)		//2014-12-26 DJ DJ0133
	.i AdjustType=1 d
	..if (StoreLocDR'=FromLocDR)||(EquipTypeDR'=FromEquipTypeDR)||(StatCatDR'=FromStatCatDR)||(OriginDR'=FromOriginDR) s SQLCODE=-1000
	..if (Status'=FromStatus)||(OriginalFee'=FromOriginalFee)||(DepreTotal'=FromDepreTotal)||(NetFee'=FromNetFee) s SQLCODE=-1000
	.q:SQLCODE'=0
	.
	.s ToLocDR=$p($g(^DHCEQAdjustDataList(RowID)),"^",8)
	.s ToEquipTypeDR=$p($g(^DHCEQAdjustDataList(RowID)),"^",9)
	.s ToStatCatDR=$p($g(^DHCEQAdjustDataList(RowID)),"^",10)
	.s ToOriginDR=$p($g(^DHCEQAdjustDataList(RowID)),"^",11)
	.
	.i AdjustType=1 d
	..s EQPL(20)=ToLocDR		//科室
	..s EQPL(21)=ToOriginDR		//来源
	..s EQPL(56)=User  			//更新人
	..s EQPL(57)=+$H  			//更新日期
	..s EQPL(58)=$P($H,",",2)  	//更新时间
	..s EQPL(68)=ToLocDR		//库房
	..s EQPL(64)=ToEquipTypeDR	//类组
	..s EQPL(76)=ToStatCatDR	//类型
	.e  i AdjustType=3 d
	..s EQPL(60)="Y"			//无效标识
	.e  i AdjustType=4 d
	..s EQPL(39)="1"			//设备状态
	.i AdjustType=5  d
	..s EQPL(20)=ToLocDR		//科室     ;add by kdf begin 2018-03-13 需求号：552115 
	..s EQPL(21)=ToOriginDR		//来源
	..s EQPL(56)=User  			//更新人
	..s EQPL(57)=+$H  			//更新日期
	..s EQPL(58)=$P($H,",",2)  	//更新时间
	..s EQPL(68)=ToLocDR		//库房
	..s EQPL(64)=ToEquipTypeDR	//类组
	..s EQPL(76)=ToStatCatDR	//类型
	..&SQL(update sqluser.DHC_EQEquip values :EQPL() where EQ_RowID=:EquipDR) ;add by kdf end 2018-03-13 需求号：552115 
	..i (vMainFlag'="Y")  d
	...s HBOriginalFee=HBOriginalFee+FromOriginalFee
	...s HBNetFee=HBNetFee+FromNetFee
	...s HBDepreTotalFee=HBDepreTotalFee+FromDepreTotal
	...s HBNetRemainFee=HBNetRemainFee+FromNetRemainFee
	...s EQPL(60)="Y"
	...&SQL(update sqluser.DHC_EQEquip values :EQPL() where EQ_RowID=:EquipDR)
	.e  d
	..&SQL(update sqluser.DHC_EQEquip values :EQPL() where EQ_RowID=:EquipDR)
	.q:SQLCODE'=0
	.
	.s LI(2)=EquipDR
	.s LI(4)=FromLocDR   		//原使用科室 
	.s LI(5)=FromLocDR  		//原管理科室
	.s LI(6)=FromLocDR  		//原库房
	.s LI(7)=FromOriginalFee  	//原值
	.s LI(8)=FromNetFee  		//原净值
	.s LI(9)=ToLocDR  			//变动后使用科室 
 	.s LI(10)=ToLocDR 			//变动后管理科室
 	.s LI(11)=ToLocDR  			//变动后库房
 	.s LI(12)=FromOriginalFee  	//变动后原值
 	.s LI(13)=FromNetFee  		//变动后净值 
 	.s LI(21)=RowID 			//来源ID
 	.&SQL(Insert Into SQLUSER.DHC_EQLifeInfo Values :LI())
 	.//调整数据时记录当时设备的对应资金来源 2013-03-06 DJ DJ0116 begin
 	.q:SQLCODE'=0
 	.s FRowID=0
 	.f  s FRowID=$o(^DHCEQFunds("0","Equip",EquipDR,FRowID)) q:(FRowID="")||(SQLCODE'=0)  d
 	..s FPLIST(3)=$p($g(^DHCEQFunds(FRowID)),"^",2)		//FundsTypeDR
 	..s FundsTypeDR=$p($g(^DHCEQFunds(FRowID)),"^",2)	//2014-12-26 DJ DJ0133
 	..s FPLIST(4)=$p($g(^DHCEQFunds(FRowID)),"^",3)		//Fee
 	..s FundsFee=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQFunds(FRowID)),"^",3),"",2)		//2014-12-26 DJ DJ0133
 	..s FPLIST(7)="0"
 	..s FPLIST(8)=User
 	..s FPLIST(9)=Date
 	..s FPLIST(10)=Time
 	..s FPLIST(11)="N"
 	..s FPLIST(14)=$p($g(^DHCEQFunds(FRowID)),"^",13)	//DepreTotal
 	..s FundsDepreTotal=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQFunds(FRowID)),"^",13),"",2)	//2014-12-26 DJ DJ0133
 	..s FPLIST(15)="9"									//SourceType
 	..s FPLIST(16)=RowID								//SourceID
 	..&SQL(Insert Into SQLUSER.DHC_EQFunds Values :FPLIST())
 	..q:SQLCODE'=0
 	..i ((AdjustType=5)&&(vMainFlag'="Y"))  d  	//2014-12-26 DJ DJ0133
 	...s ^DHCEQTemp("AdjustData",+$H,TempID,AdjustDataDR,FundsTypeDR,1)=FundsFee+$g(^DHCEQTemp("AdjustData",+$H,TempID,AdjustDataDR,FundsTypeDR,1))
 	...s ^DHCEQTemp("AdjustData",+$H,TempID,AdjustDataDR,FundsTypeDR,2)=FundsDepreTotal+$g(^DHCEQTemp("AdjustData",+$H,TempID,AdjustDataDR,FundsTypeDR,2))
 	.//2013-03-06 DJ DJ0116 end
	
 	i SQLCODE
 	{
		TROLLBACK
		q SQLCODE
 	}
 	
 	//合并数据更新主设备及主设备资金来源 2014-12-26 DJ DJ0133
 	i AdjustType=5
 	{
	 	k HBEQPL,HBFPLIST
	 	s HBEQPL(28)=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQEquip(MainEquipDR)),"^",27),"",2)+##Class(web.DHCEQCommon).FormatNumber(HBOriginalFee,"",2)
	 	s HBEQPL(29)=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQEquip(MainEquipDR)),"^",28),"",2)+##Class(web.DHCEQCommon).FormatNumber(HBNetFee,"",2)
	 	s HBEQPL(36)=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQEquip(MainEquipDR)),"^",35),"",2)+##Class(web.DHCEQCommon).FormatNumber(HBDepreTotalFee,"",2)
	 	s HBEQPL(30)=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQEquip(MainEquipDR)),"^",29),"",2)+##Class(web.DHCEQCommon).FormatNumber(HBNetRemainFee,"",2)
	 	&SQL(Update SQLUSER.DHC_EQEquip values :HBEQPL() Where EQ_RowID=:MainEquipDR)
	 	i SQLCODE
	 	{
		 	TROLLBACK
		 	q SQLCODE
	 	}
	 	s DSRowID=$o(^DHCEQDepreSet(0,"EquipMain",MainEquipDR,"Y",0))
	 	&SQL(Update SQLUSER.DHC_EQDepreSet Set DS_DepreTotalFee=:HBEQPL(36) Where DS_RowID=:DSRowID)		//Add By DJ 2017-07-03 DJ0190 解决累计折旧重复计算问题
	 	s FTTypeDR=0
	 	f  s FTTypeDR=$o(^DHCEQTemp("AdjustData",+$H,TempID,AdjustDataDR,FTTypeDR))  q:(FTTypeDR="")||(SQLCODE'=0)  d
	 	.s FFee=$g(^DHCEQTemp("AdjustData",+$H,TempID,AdjustDataDR,FTTypeDR,1))
	 	.s FDepreTotal=$g(^DHCEQTemp("AdjustData",+$H,TempID,AdjustDataDR,FTTypeDR,2))
	 	.i $D(^DHCEQFunds("0","EquipType",MainEquipDR,FTTypeDR))  d
	 	..s FRowID=$o(^DHCEQFunds("0","EquipType",MainEquipDR,FTTypeDR,0))
	 	..&SQL(Update SQLUSER.DHC_EQFunds Set F_Fee=F_Fee+:FFee,F_DepreTotal=F_DepreTotal+:FDepreTotal Where F_RowID=:FRowID)
	 	.e  d
	 	..s HBFPLIST(2)=MainEquipDR
	 	..s HBFPLIST(3)=FTTypeDR
	 	..s HBFPLIST(4)=FFee
	 	..s HBFPLIST(7)="0"
	 	..s HBFPLIST(8)=User
	 	..s HBFPLIST(9)=Date
	 	..s HBFPLIST(10)=Time
	 	..s HBFPLIST(11)="N"
	 	..s HBFPLIST(14)=FDepreTotal
	 	..s HBFPLIST(15)="1"
	 	..s HBFPLIST(16)=MainEquipDR
	 	..&SQL(Insert Into SQLUSER.DHC_EQFunds Values :HBFPLIST())
	 	
	 	i SQLCODE
	 	{
		 	TROLLBACK
		 	q SQLCODE
	 	}
 	}
 	
	s PLIST(4)=Date
	s PLIST(5)=Time
	s PLIST(10)=User
	s PLIST(12)="1"
	&SQL(update sqluser.DHC_EQAdjustData values :PLIST() where AD_RowID=:AdjustDataDR)
		
 	i SQLCODE
 	{
		TROLLBACK
		q SQLCODE
 	}
 	TCOMMIT
 	q SQLCODE
ERRORExecute 
	Set ErrorMsg=$ZE	     //得到系统返回的错误消息
 	TROLLBACK		         //回滚事务
 	Quit "ERRORExecute"_ErrorMsg     //返回错误消息 ;
}

/// add by zy 2011-09-25 ZY0080
/// 撤销执行过的调整
/// 参数说明:
///         RowID,调整记录ID
///         InvalidReason,撤销原因
/// w ##class(web.DHCEQAdjustData).InvalidAdjustData("1","zuofeiyuanyin")
ClassMethod InvalidAdjustData(AdjustDataDR, InvalidReason As %String = "")
{
	new Date,Time,User,Type,SQLCODE
	if AdjustDataDR="" quit ""
	k EQPL,PLIST
	Set $ZT="ERRORInvalid"
	s Date=+$H
	s Time=$P($H,",",2)
	s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	s LI(16)=Date				//变动日期
	s LI(17)=Time				//变动时间
 	s LI(19)="O"				//生命周期类型
 	s LI(20)=61					//来源类型
 	s LI(22)=""					//来源辅助类型
 	s LI(27)=User				//更新人
 	s LI(28)=Date				//更新日期
 	s LI(29)=Time				//更新时间
	s SQLCODE=0
	TSTART
	s AdjustType=$p($g(^DHCEQAdjustData(AdjustDataDR)),"^",1)
			
	s RowID=0
	for  set RowID=$Order(^DHCEQAdjustDataList(0,"AdjustData",AdjustDataDR,RowID)) quit:(RowID="")||(SQLCODE'=0)  d
	.s EquipDR=$p($g(^DHCEQAdjustDataList(RowID)),"^",2)
	.s LocDR=$p($g(^DHCEQEquip(EquipDR)),"^",19)
	.s StoreLocDR=$p($g(^DHCEQEquip(EquipDR)),"^",67)
	.s EquipTypeDR=$p($g(^DHCEQEquip(EquipDR)),"^",63)
	.s StatCatDR=$p($g(^DHCEQEquip(EquipDR)),"^",75)
	.s OriginDR=$p($g(^DHCEQEquip(EquipDR)),"^",20)
	.s Status=$p($g(^DHCEQEquip(EquipDR)),"^",38)
	.s OriginalFee=$p($g(^DHCEQEquip(EquipDR)),"^",27)
	.s DepreTotal=$p($g(^DHCEQEquip(EquipDR)),"^",35)
	.s NetFee=$p($g(^DHCEQEquip(EquipDR)),"^",28)
	.
	.s FromLocDR=$p($g(^DHCEQAdjustDataList(RowID)),"^",3)
	.s FromEquipTypeDR=$p($g(^DHCEQAdjustDataList(RowID)),"^",4)
	.s FromStatCatDR=$p($g(^DHCEQAdjustDataList(RowID)),"^",5)
	.s FromOriginDR=$p($g(^DHCEQAdjustDataList(RowID)),"^",6)
	.s FromStatus=$p($g(^DHCEQAdjustDataList(RowID)),"^",13)
	.s FromOriginalFee=$p($g(^DHCEQAdjustDataList(RowID)),"^",14)
	.s FromDepreTotal=$p($g(^DHCEQAdjustDataList(RowID)),"^",15)
	.s FromNetFee=$p($g(^DHCEQAdjustDataList(RowID)),"^",16)
	.s ToLocDR=$p($g(^DHCEQAdjustDataList(RowID)),"^",8)
	.s ToEquipTypeDR=$p($g(^DHCEQAdjustDataList(RowID)),"^",9)
	.s ToStatCatDR=$p($g(^DHCEQAdjustDataList(RowID)),"^",10)
	.s ToOriginDR=$p($g(^DHCEQAdjustDataList(RowID)),"^",11)
	.i AdjustType=1 d
	..if (StoreLocDR'=ToLocDR)||(EquipTypeDR'=ToEquipTypeDR)||(StatCatDR'=ToStatCatDR)||(OriginDR'=ToOriginDR) s SQLCODE=-1000
	..if (Status'=FromStatus)||(OriginalFee'=FromOriginalFee)||(DepreTotal'=FromDepreTotal)||(NetFee'=FromNetFee) s SQLCODE=-1000
	.q:SQLCODE'=0
	.
	.i AdjustType=1 d
	..s EQPL(20)=FromLocDR		;科室
	..s EQPL(21)=FromOriginDR	;来源
	..s EQPL(28)=FromOriginalFee	;原值
	..s EQPL(29)=FromNetFee		;净值
	..s EQPL(36)=FromDepreTotal	;累计折旧
	..s EQPL(39)=FromStatus		;状态
	..s EQPL(56)=User  			;更新人
	..s EQPL(57)=+$H  			;更新日期
	..s EQPL(58)=$P($H,",",2)  	;更新时间
	..s EQPL(64)=FromEquipTypeDR	;类组
	..s EQPL(68)=FromLocDR		;库房
	..s EQPL(76)=FromStatCatDR	;类型
	.e  i AdjustType=3 d
	..s EQPL(60)="N"			//无效标识
	.e  i AdjustType=4 d
	..s EQPL(39)="3"			//设备原状态
	.&SQL(update sqluser.DHC_EQEquip values :EQPL() where EQ_RowID=:EquipDR)
	.q:SQLCODE'=0
	.
	.s LI(2)=EquipDR
	.s LI(4)=ToLocDR   			//原使用科室 
	.s LI(5)=ToLocDR  			//原管理科室
	.s LI(6)=ToLocDR  			//原库房
	.s LI(7)=FromOriginalFee  	//原值
	.s LI(8)=FromNetFee  		//原净值
	.s LI(9)=FromLocDR  		//变动后使用科室 
 	.s LI(10)=FromLocDR 		//变动后管理科室
 	.s LI(11)=FromLocDR  		//变动后库房
 	.s LI(12)=FromOriginalFee  	//变动后原值
 	.s LI(13)=FromNetFee  		//变动后净值 
 	.s LI(21)=RowID 			//来源ID
 	.&SQL(Insert Into SQLUSER.DHC_EQLifeInfo Values :LI())
	
 	i SQLCODE
 	{
		TROLLBACK
		q SQLCODE
 	}
	s PLIST(12)="2"
	s PLIST(17)=User
	s PLIST(18)=Date
	s PLIST(19)=Time
	s PLIST(20)=InvalidReason
	&SQL(update sqluser.DHC_EQAdjustData values :PLIST() where AD_RowID=:AdjustDataDR)
		
 	i SQLCODE
 	{
		TROLLBACK
		q SQLCODE
 	}
 	TCOMMIT
 	q SQLCODE
ERRORInvalid 
	Set ErrorMsg=$ZE	     //得到系统返回的错误消息
 	TROLLBACK		         //回滚事务
 	Quit "ERRORInvalid"_ErrorMsg     //返回错误消息 ;
}

/// add by zy 2011-09-25 ZY0080
ClassMethod GetAdjustData(RowID)
{
	new result,resultex,ImportFlag
	s ImportFlag="No"
	if RowID="" q ""
	s (result,resultex)=""
	s result= ^DHCEQAdjustData(RowID)
	s RowID=$Order(^DHCEQAdjustDataList(0,"AdjustData",RowID,0)) 	
	if RowID'="" s ImportFlag="Yes"
	
	s resultex=resultex_"^"	;Type
	i $p(result,"^",1)'=""  d
	.s resultex=resultex_$Case($p(result,"^",1),"1":"调整数据","2":"新增数据","3":"删除数据","4":"取消报废","9":"其他调整",:"未定义")
	i $p(result,"^",2)'=""  d ;ReportFlag
	.s $p(result,"^",2)=##class(web.DHCEQCommon).TransValueToPage($p(result,"^",2),"bool")
	i $p(result,"^",3)'=""  d
	.s $p(result,"^",3)=##class(web.DHCEQCommon).TransValueToPage($p(result,"^",3),"date")
	i $p(result,"^",4)'=""  d
	.s $p(result,"^",4)=##Class(web.DHCEQCommon).TransValueToPage($p(result,"^",4),"time")
	s resultex=resultex_"^"	;UserDR
	i $p(result,"^",9)'=""  d
	.s resultex=resultex_##class(web.DHCEQCommon).GetTrakNameByID("user",$p(result,"^",9))
	s resultex=resultex_"^"	;Status
	i $p(result,"^",11)'=""  d
	.s resultex=resultex_$Case($p(result,"^",11),"0":"新增","1":"执行","2":"作废")
	i $p(result,"^",12)'=""  d ;DisplayFlag
	.s $p(result,"^",12)=##class(web.DHCEQCommon).TransValueToPage($p(result,"^",12),"bool")
	s resultex=resultex_"^"	;UpdateUserDR
	i $p(result,"^",13)'=""  d
	.s resultex=resultex_##class(web.DHCEQCommon).GetTrakNameByID("user",$p(result,"^",13))
	i $p(result,"^",14)'=""  d
	.s $p(result,"^",14)=##class(web.DHCEQCommon).TransValueToPage($p(result,"^",14),"date")
	i $p(result,"^",15)'=""  d
	.s $p(result,"^",15)=##Class(web.DHCEQCommon).TransValueToPage($p(result,"^",15),"time")
	s resultex=resultex_"^"	;InvalidUserDR
	i $p(result,"^",16)'=""  d
	.s resultex=resultex_##class(web.DHCEQCommon).GetTrakNameByID("user",$p(result,"^",16))
	i $p(result,"^",17)'=""  d
	.s $p(result,"^",17)=##class(web.DHCEQCommon).TransValueToPage($p(result,"^",17),"date")
	i $p(result,"^",18)'=""  d
	.s $p(result,"^",18)=##Class(web.DHCEQCommon).TransValueToPage($p(result,"^",18),"time")
	s result=result_"^"_ImportFlag_resultex
	s result=##class(web.DHCEQCommon).Replace(result,$C(13,10),"\n")
	q result
}

/// add by zy 2011-09-25 ZY0080
/// w ##class(web.DHCEQAdjustData).GetAdjustDataList("","1")
ClassMethod GetAdjustDataList(RowID, AdjustDataDR)
{
	new result,resultex
	s (result,resultex)=""
	i AdjustDataDR'="" s RowID=$Order(^DHCEQAdjustDataList(0,"AdjustData",AdjustDataDR,0)) 	
	if RowID="" q ""
	s result= ^DHCEQAdjustDataList(RowID)
	s resultex=resultex_"^"	;EquipName
	i $p(result,"^",2)'=""  d
	.s resultex=resultex_$p($g(^DHCEQEquip($p(result,"^",2))),"^",1)
	s resultex=resultex_"^"	;FromLocDR
	i $p(result,"^",3)'=""  d
	.s resultex=resultex_##class(web.DHCEQCommon).GetTrakNameByID("dept",$p(result,"^",3))
	s resultex=resultex_"^"	;FromEquipTypeDR
	i $p(result,"^",4)'=""  d
	.s resultex=resultex_##class(web.DHCEQCommon).GetTrakNameByID("equiptype",$p(result,"^",4))
	s resultex=resultex_"^"	;FromStatCatDR
	i $p(result,"^",5)'=""  d
	.s resultex=resultex_##class(web.DHCEQCommon).GetTrakNameByID("statcat",$p(result,"^",5))
	s resultex=resultex_"^"	;FromOriginDR
	i $p(result,"^",6)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCOrigin",$p(result,"^",6))),"^",2)
	
	s resultex=resultex_"^"	;ToLocDR
	i $p(result,"^",8)'=""  d
	.s resultex=resultex_##class(web.DHCEQCommon).GetTrakNameByID("dept",$p(result,"^",8))
	s resultex=resultex_"^"	;ToEquipTypeDR
	i $p(result,"^",9)'=""  d
	.s resultex=resultex_##class(web.DHCEQCommon).GetTrakNameByID("equiptype",$p(result,"^",9))
	s resultex=resultex_"^"	;ToStatCatDR
	i $p(result,"^",10)'=""  d
	.s resultex=resultex_##class(web.DHCEQCommon).GetTrakNameByID("statcat",$p(result,"^",10))
	s resultex=resultex_"^"	;ToOriginDR
	i $p(result,"^",11)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCOrigin",$p(result,"^",11))),"^",2)
	s resultex=resultex_"^"	;EQStatus
	i $p(result,"^",13)'=""  d
	.s resultex=resultex_##class(web.DHCEQEquip).GetEquipStatusDisplay($p(result,"^",13))
	s $p(result,"^",14)=##Class(web.DHCEQCommon).FormatNumber($p(result,"^",14),"")
	s $p(result,"^",15)=##Class(web.DHCEQCommon).FormatNumber($p(result,"^",15),"")
	s $p(result,"^",16)=##Class(web.DHCEQCommon).FormatNumber($p(result,"^",16),"")
	s resultex=resultex_"^"	;EQNo
	i $p(result,"^",2)'=""  d
	.s resultex=resultex_$p($g(^DHCEQEquip($p(result,"^",2))),"^",71)
	s result=RowID_"^"_result_resultex
	s result=##class(web.DHCEQCommon).Replace(result,$C(13,10),"\n")
	q result
}

/// add by zy 2011-09-25 ZY0080
/// 删除数据
/// 参数说明:
/// 		type:0,导入数据到表中后删除临时global中的数据
/// 			 1,重新导入数据时，删除前一次导入的明细记录
ClassMethod KillTEMPEQ(type, RowID)
{
	new SQLOCDE
	s SQLOCDE=0
	if type="0"
	{
		k ^TEMPDHCEQ("DHCEQAdjustDataList")
	}
	elseif type="1"
	{
		&SQL(delete from  sqluser.DHC_EQAdjustDataList  where ADL_AdjustDataDR=:RowID)
	}
	q SQLOCDE
}

///  清理某月的折旧，以及月结
ClassMethod ClearMonthData(EquipTypeDR, DepreMonth, DepreDate)
{
	n StoreLoc
	s RowID=0
	for  set RowID=$Order(^DHCEQAdjustDataList(0,"AdjustData",AdjustDataDR,RowID)) quit:(RowID="")||(SQLCODE'=0)  d
	
	;subscript 2 { expression = "StoreEquipType"; }
	;subscript 3 { expression = {EQ_InvalidFlag}; }
	;subscript 4 { expression = {EQ_StockStatus}; }
	;subscript 5 { expression = {EQ_StoreLocDR}; }
	;subscript 6 { expression = {EQ_EquipTypeDR}; }
	;subscript 7 { expression = {EQ_RowID}; }
}

/// Add By DJ 2014-12-26 DJ0133
/// 描述:合并数据是否存在主设备及合并设备是否类组,类型,科室,来源都一致
ClassMethod CheckHBEquip(vRowID, vMainFlag As %String = "")
{
	
	s (FirstLocDR,FirstEquipTypeDR,FirstStatCatDR,FirstOrignDR,MEQRowID)=""
	s MEQCount=0
	s SQLCODE=0
	s RowID=0
	for  set RowID=$Order(^DHCEQAdjustDataList(0,"AdjustData",vRowID,RowID)) quit:(RowID="")||(SQLCODE'=0)  d
	.s EquipDR=$p($g(^DHCEQAdjustDataList(RowID)),"^",2)
	.s FromLocDR=$p($g(^DHCEQAdjustDataList(RowID)),"^",3)
	.s FromEquipTypeDR=$p($g(^DHCEQAdjustDataList(RowID)),"^",4)
	.s FromStatCatDR=$p($g(^DHCEQAdjustDataList(RowID)),"^",5)
	.s FromOriginDR=$p($g(^DHCEQAdjustDataList(RowID)),"^",6)
	.s FromStatus=$p($g(^DHCEQAdjustDataList(RowID)),"^",13)
	.s EQStatus=$p($g(^DHCEQEquip(EquipDR)),"^",38)
	.s InvalidFlag=$p($g(^DHCEQEquip(EquipDR)),"^",59)
	.s StockStatus=$p($g(^DHCEQEquip(EquipDR)),"^",60)
	.i InvalidFlag="Y" s SQLCODE="-1000"
	.q:SQLCODE'=0
	.i '((EQStatus<=2)&&(StockStatus=1)) s SQLCOCE="-1000"
	.q:SQLCODE'=0
	.s MEFlag=$p($g(^DHCEQAdjustDataList(RowID)),"^",17)
	.i MEFlag="Y"  d
	..s MEQRowID=EquipDR
	..s MEQCount=MEQCount+1
	.i MEQCount>1 s SQLCODE="-1003"
	.q:SQLCODE'=0
	.i FirstLocDR="" s FirstLocDR=FromLocDR
	.i FirstEquipTypeDR="" s FirstEquipTypeDR=FromEquipTypeDR
	.i FirstStatCatDR="" s FirstStatCatDR=FromStatCatDR
	.i FirstOrignDR="" s FirstOrignDR=FromOriginDR
	.i ((FirstLocDR'=FromLocDR)||(FirstEquipTypeDR'=FromEquipTypeDR)||(FirstStatCatDR'=FromStatCatDR)||(FirstOrignDR'=FromOriginDR)) s SQLCODE="-1002"
	
	i SQLCODE'=0 q SQLCODE
	i ((vMainFlag="")&&(MEQCount'=1)) q "-1001"
	i vMainFlag'="" q MEQRowID
	q SQLCODE
}

}
