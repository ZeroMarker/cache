Class web.DHCEQ.Stat.DHCEQMonthDepre Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// MZY0102	2296785		2021-11-24	补充参数及输出
/// modified by ZY0250 20200106  
/// 根据快照ID判断是否从预折旧表中出数据
/// Add By DJ  2016-01-29
/// 描述:获取当月折旧清单
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.Stat.DHCEQMonthDepre","MonthDepre","2021-10","","","2","","",85,202)
Query MonthDepre(pMonthStr As %String = "", pUseLocDR As %String = "", pEquipNo As %String = "", pEquipTypeDR As %String = "", pFundsTypeDR As %String = "", QXType As %String = "", CurGroupID As %String = "", CurLocID As %String = "", CurHospID As %String = "", pDepreTypeDR As %String = "1", pHosptailDR As %String = "", pInvalidFlag As %String = "Y", Remark As %String = "", pStatCatDR As %String = "", pLocGroupTypeDR As %String = "", pEquipTypeIDs As %String = "", pOriginDR As %String = "", pFundsTypeIDs As %String = "") As %Query(ROWSPEC = "TRowID:%String,TEQNo:%String,TEquipName:%String,TABCType:%String,TModel:%String,TStoreLoc:%String,TEquipType:%String,TStatCat:%String,TEquipCatCode:%String,TEquipCat:%String,TOriginalFee:%String,TLimitYearsNum:%String,TNetFee:%String,TDepreTotalFee:%String,TManuFactory:%String,TUnit:%String,TProvider:%String,TStatus:%String,TStockStatus:%String,TInvalidFlag:%String,TCode:%String,TLeaveFactoryNo:%String,TLeaveFactoryDate:%String,TPurposeType:%String,TOrigin:%String,TRemark:%String,TDepreMethod:%String,TStartDate:%String,TTransAssetDate:%String,TQuantityNum:%String,TOldEquipNo:%String,TBrand:%String,TOutLayType:%String,TFundsTypeDR:%String,TFundsType:%String,TFundsOriginalFee:%String,TFundsNetFee:%String,TFundsDepreTotal:%String,TMonth:%String,TLocType:%String,TStoreLocDR:%String,TEquipTypeDR:%String,TStatCatDR:%String,THospitalDR:%String,THospital:%String,TMonthType:%String,ExCode:%String,ExDesc:%String,TFinaceItemDR:%String,TFinaceItemCode:%String,TFinaceItem:%String,TFunctionCatDR:%String,TFunctionCatCode:%String,TFunctionCat:%String,TDepre:%String,TPrevFundsDepreTotal:%String,TReduDepre:%String,TSCRemark:%String,TLocGroupTypeDR:%String") [ SqlProc ]
{
}

ClassMethod MonthDepreExecute(ByRef qHandle As %Binary, pMonthStr As %String = "", pUseLocDR As %String = "", pEquipNo As %String = "", pEquipTypeDR As %String = "", pFundsTypeDR As %String = "", QXType As %String = "", CurGroupID As %String = "", CurLocID As %String = "", CurHospID As %String = "", pDepreTypeDR As %String = "1", pHosptailDR As %String = "", pInvalidFlag As %String = "Y", Remark As %String = "", pStatCatDR As %String = "", pLocGroupTypeDR As %String = "", pEquipTypeIDs As %String = "", pOriginDR As %String = "", pFundsTypeIDs As %String = "") As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	i pMonthStr="" QUIT $$$OK
 	s index=1
	i pEquipTypeIDs'="" s pEquipTypeIDs=","_pEquipTypeIDs_","
	i pFundsTypeIDs'="" s pFundsTypeIDs=","_pFundsTypeIDs_","
 	s AccountShapeFlag=+##class(web.DHCEQCommon).GetSysInfo("990057")
 	s SnapID=##Class(web.DHCEQSnapShot).GetSnapIDByMonth(pMonthStr)
	// MZY0102	2296785		2021-11-24
	s StartDate=##Class(web.DHCEQReport).GetReportDate(pMonthStr,"","")
	s EndDate=$p(StartDate,"^",2)
	s StartDate=$p(StartDate,"^",1)
	
 	s PrevSnapID=0	// MZY0113	2440180		2022-01-25
 	s RowID=0
 	i SnapID=""  d
 	.f  s RowID=$o(^DHCEQEquip(RowID))  q:RowID=""  d
 	..d ResetVariablesGetMonthDepre
 	..s EquipData=$g(^DHCEQEquip(RowID))
 	..q:(AccountShapeFlag=1)&&($p($g(^DHCEQEquip(RowID,"OtherInfo")),"^",16)'=1)
 	..d BuildDataList
 	e  d
	.s PrevSnapID=SnapID-1	;上月快照	 MZY0102	2296785		2021-11-24
 	.f  s RowID=$o(^DHCEQSnapShot(SnapID,"Equip",RowID))  q:RowID=""  d
 	..d ResetVariablesGetMonthDepre
 	..s EquipData=$g(^DHCEQSnapShot(SnapID,"Equip",RowID))
 	..q:(AccountShapeFlag=1)&&($p($g(^DHCEQSnapShot(SnapID,"Equip",RowID,"OtherInfo")),"^",16)'=1)
 	..d BuildDataList
	Quit $$$OK
	
BuildDataList	
	s TEquipTypeDR=$p(EquipData,"^",63)			//设备类组
	q:(pEquipTypeIDs'="")&&(pEquipTypeIDs'[(","_TEquipTypeDR_","))
 	q:(pEquipTypeDR'="")&&(pEquipTypeDR'=TEquipTypeDR)
 	q:(##Class(web.DHCEQCommon).EquipTypeIsIn(TEquipTypeDR,CurGroupID))
	s TStatus=$p(EquipData,"^",38)					//状态
	s TStockStatus=$p(EquipData,"^",60)			//库房状态
	q:$p(EquipData,"^",45)=""
	//只要当月有折旧信息的数据都输出,不管是否报废减少
	//报废,减少当月是否折旧可根据系统参数配置
	//q:((TStatus=0)&&(TStockStatus=0))	
	s TEQNo=$p(EquipData,"^",71)					//设备编号
	q:(pEquipNo'="")&&(TEQNo'=pEquipNo)
	s TInvalidFlag=$p(EquipData,"^",59)
	q:(pInvalidFlag="N")&((TStockStatus=3)||(TStatus=3)||(TInvalidFlag="Y"))
	
	s TRowID=RowID
	s TEquipName=$p(EquipData,"^",1)				//设备名称
	s TABCType=$p(EquipData,"^",2)					//ABCType
	s TModelDR=$p(EquipData,"^",3)					//规格型号
	s TStoreLocDR=$p(EquipData,"^",67)				//设备库房
	q:(1=(##class(web.DHCEQCommon).LocIsInEQ("",TStoreLocDR,CurLocID,CurGroupID,CurHospID)))
	s TStatCatDR=$p(EquipData,"^",75)				//设备类型
	q:(pStatCatDR'="")&&(TStatCatDR'=pStatCatDR)		// MZY0102	2296785		2021-11-24
	s TEquipCatDR=$p(EquipData,"^",4)				//设备分类
	s TOriginalFee=$p(EquipData,"^",27)	//设备原值
	s TLimitYearsNum=$p(EquipData,"^",31)			//使用年限
	s TNetFee=$p(EquipData,"^",28)		//净值
	s TDepreTotalFee=$p(EquipData,"^",35)	//累计折旧
	i TDepreTotalFee>=TOriginalFee  d
 	.s TDepreTotalFee= TOriginalFee
 	.s TNetFee=0
 	i TDepreTotalFee+TNetFee<TOriginalFee s TNetFee=TOriginalFee-TDepreTotalFee
	
	s TManuFactoryDR=$p(EquipData,"^",26)			//生产厂家
	s TUnitDR=$p(EquipData,"^",5)					//单位
	s TProviderDR=$p(EquipData,"^",25)				//供应商
	s TCode=$p(EquipData,"^",6)						//编码(拼音码)
	s TLeaveFactoryNo=$p(EquipData,"^",10)			//出厂编号
	s TLeaveFactoryDate=##class(web.DHCEQCommon).TransValueToPage($p(EquipData,"^",11),"date") 	//出厂日期
	s TPurposeTypeDR=$p(EquipData,"^",65)			//用途
	s TOriginDR=$p(EquipData,"^",20)				//来源
	q:(pOriginDR'="")&&(TOriginDR'=pOriginDR)
	
	s TRemark=$p(EquipData,"^",34)					//备注
	s TDepreMethodDR=$p(EquipData,"^",33)			//折旧方法
	s TStartDate=##class(web.DHCEQCommon).TransValueToPage($p(EquipData,"^",44),"date")  //启用日期
	s TTransAssetDate=##class(web.DHCEQCommon).TransValueToPage($p(EquipData,"^",45),"date")  	//转资日期
	//q:$p(EquipData,"^",45)<65714
	s TQuantityNum="1"
	s TOldEquipNo=$p(EquipData,"^",91)				//旧系统唯一号
	s TBrandDR=$p(EquipData,"^",94)					//品牌
	s TOutLayTypeDR=$p(EquipData,"^",95)			//经费来源
	s TMonth=pMonthStr																//年月
	;解析处理
	// MZY	2440180		2022-01-29
	s TModel=##Class(web.DHCEQCommon).GetTrakNameByID("model",TModelDR)	
	i SnapID>0 s TModel=$p($g(^DHCEQSnapShot(SnapID,"Equip",RowID,"EX")),"^",2)
	s TStoreLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept",TStoreLocDR)
	s TStoreLocCode=##Class(web.DHCEQCommon).GetTrakNameByID("deptcode",TStoreLocDR)
	s TEquipType=##Class(web.DHCEQCommon).GetTrakNameByID("equiptype",TEquipTypeDR)
	s TStatCat=##Class(web.DHCEQCommon).GetTrakNameByID("statcat",TStatCatDR)
	i TStatCatDR'="" s TSCRemark=$p($g(^DHCEQCCode("DHCEQCStatCat",TStatCatDR)),"^",3)	// MZY0102	2296785		2021-11-24
 	i TEquipCatDR'=""  d
 	.s TEquipCatCode=$p($g(^DHCEQCCode("DHCEQCEquipeCat",TEquipCatDR)),"^",1)
 	.s TEquipCat=$p($g(^DHCEQCCode("DHCEQCEquipeCat",TEquipCatDR)),"^",2)
	i TBrandDR'="" s TBrand=$p($g(^DHCEQCCode("DHCEQCBrand",TBrandDR)),"^",3)
	i TOutLayTypeDR'="" s TOutLayType=$p($g(^DHCEQCCode("DHCEQCOutLayType",TOutLayTypeDR)),"^",2)
	s TManuFactory=##Class(web.DHCEQCommon).GetTrakNameByID("manufacturer",TManuFactoryDR)
	s TUnit=##Class(web.DHCEQCommon).GetTrakNameByID("uom",TUnitDR)
	s TProvider=##Class(web.DHCEQCommon).GetTrakNameByID("prov",TProviderDR)
	s TOrigin=##Class(web.DHCEQCommon).GetTrakNameByID("origin",TOriginDR)
	i TDepreMethodDR'="" s TDepreMethod=$p($g(^DHCEQCCode("DHCEQCDepreMethod",TDepreMethodDR)),"^",2)
	i TPurposeTypeDR'="" s TPurposeType=$p($g(^DHCEQCCode("DHCEQCPurposeType",TPurposeTypeDR)),"^",2)
	
	;设备各种资金来源的原值,累计折旧,净值
	s FSnapID=0
	i SnapID'="" d
	.f  s FSnapID=$o(^DHCEQSnapShot(SnapID,"Funds",RowID,FSnapID))  q:FSnapID=""  d
	..s FundsDataList=$g(^DHCEQSnapShot(SnapID,"Funds",RowID,FSnapID))
	..d BuildFundsDataList
	e  d
	.///折旧完毕的是不会写预折旧表的 modified by ZY0258 20210408
	.s FSnapID=0
	.i '$Data(^DHCEQPreFunds(0,"Equip",RowID)) d
	..f  s FSnapID=$o(^DHCEQFunds(0,"Equip",RowID,FSnapID))  q:FSnapID=""  d
	...s FundsDataList=$g(^DHCEQFunds(FSnapID))
	...d BuildFundsDataList
	.e  d
	..f  s FSnapID=$o(^DHCEQPreFunds(0,"Equip",RowID,FSnapID))  q:FSnapID=""  d
	...s FundsDataList=$g(^DHCEQPreFunds(FSnapID))
	...d BuildFundsDataList
	
	q
	
BuildFundsDataList
	q:$p(FundsDataList,"^",10)'="N"
	s TFundsTypeDR=$p(FundsDataList,"^",2)
	;q:(pFundsTypeDR'="")&(pFundsTypeDR'=TFundsTypeDR)
        q:(pFundsTypeIDs'="")&&(pFundsTypeIDs'[(","_TFundsTypeDR_","))
	s TFundsType=$p($g(^DHCEQCCode("DHCEQCFundsType",TFundsTypeDR)),"^",2)
	s TFundsOriginalFee=+$p(FundsDataList,"^",3)
	q:+TFundsOriginalFee=0
	
	s TFinaceItemDR=$p(FundsDataList,"^",20)
	i TFinaceItemDR'="" d
	.s TFinaceItemCode=$p($g(^DHCEQCCode("DHCEQCFinaceItem",TFinaceItemDR)),"^",1)
	.s TFinaceItem=$p($g(^DHCEQCCode("DHCEQCFinaceItem",TFinaceItemDR)),"^",2)
	s TFunctionCatDR=$p(FundsDataList,"^",21)
	i TFunctionCatDR'="" d
	.s TFunctionCatCode=$p($g(^DHCEQCCode("DHCEQCFunctionCat",TFunctionCatDR)),"^",1)
	.s TFunctionCat=$p($g(^DHCEQCCode("DHCEQCFunctionCat",TFunctionCatDR)),"^",2)
	
	s TFundsDepreTotal=+$p(FundsDataList,"^",13)
	i TFundsDepreTotal>TFundsOriginalFee s TFundsDepreTotal=TFundsOriginalFee		//特例:某些医院存在累计折旧大于原值数据
	s TFundsNetFee=TFundsOriginalFee-TFundsDepreTotal
	i TFundsNetFee<0 s TFundsNetFee=0
	// MZY0102	2296785		2021-11-24
	s TPrevFundsDepreTotal=+$p($g(^DHCEQSnapShot(PrevSnapID,"Funds",RowID,FSnapID)),"^",13)	;上月累计折旧
	;统计减少累计折旧
	i ((TStockStatus=3)||(TStatus=3)||(TInvalidFlag="Y")) d
	.;无效设备
	.s TReduDepre=TFundsDepreTotal
	.s TFundsDepreTotal=""
	;调账
	s CARowid=""
	f  s CARowid=$o(^DHCEQChangeAccount(0,"Equip",RowID,CARowid)) q:CARowid=""  d
	.q:($P($G(^DHCEQChangeAccount(CARowid)),"^",22)<StartDate)||($P($G(^DHCEQChangeAccount(CARowid)),"^",22)>EndDate)
	.s FRowid=""
  	.f  s FRowid=$o(^DHCEQFunds(0,"SourceType",7,CARowid,TFundsTypeDR,FRowid)) q:FRowid=""  d
	..s CADepreTotal=+$p($g(^DHCEQFunds(FRowid)),"^",13)
	..s CADepreTotal=(-1)*CADepreTotal
	..s TReduDepre=TReduDepre+CADepreTotal
	;折旧数据
	
	s TDepreFlag=0	//判断是否有折旧
	s MDRowID=0
	i SnapID'="" d
	.f  s MDRowID=$order(^DHCEQMonthDepre(0,"EquipMonth",RowID,pMonthStr,MDRowID))  q:MDRowID=""  d
	..s MonthDepreDataList=$g(^DHCEQMonthDepre(MDRowID))
	..d BuildMonthDepreDataList
	e  d
	.f  s MDRowID=$order(^DHCEQPreMonthDepre(0,"EquipMonth",RowID,pMonthStr,MDRowID))  q:MDRowID=""  d
	..s MonthDepreDataList=$g(^DHCEQPreMonthDepre(MDRowID))
	..d BuildMonthDepreDataList
	
	//无折旧的数据直接输出
	i TDepreFlag=0 d
	.i ((TStockStatus=3)||(TStatus=3)||(TInvalidFlag="Y"))  d
	..;无效或报废设备无折旧则不出
	.e  d
	..d OutputRowGetMonthDepre
	q
BuildMonthDepreDataList
	s TDepreTypeDR= $p(MonthDepreDataList,"^",36)
	//判断当前的折旧类型.不同的折旧类型不会一起出.所以折旧类型是必填的参数
	q:pDepreTypeDR'=TDepreTypeDR
	q:($p(MonthDepreDataList,"^",21)'="")
	//s LocDR= $p($g(^DHCEQMonthDepre(MDRowID)),"^",33)
	;add by lmm 2018-12-14 	 MZY0102	2296785		2021-11-24
	s TMonthType="正常折旧"
	s TRemark= $p($g(^DHCEQMonthDepre(MDRowID)),"^",21)
	q:((Remark'="")&&(TRemark'="新财务制度补提折旧"))
	q:(Remark="")&&(TRemark="新财务制度补提折旧")
	i TRemark="新财务制度补提折旧" s TMonthType="补提折旧"
	//取当月折旧数据对应该资金来源分摊各科室的折旧费用
	
	s CADDR=0
	i SnapID'="" d
	.f  s CADDR=$o(^DHCEQCostAllotDetail(0,"SourceID",MDRowID,CADDR))  q:CADDR=""  d
	..s CADMonthDepreDataList=$g(^DHCEQCostAllotDetail(CADDR))
	..d BuildCostAllotDetailDataList
	e  d
	.f  s CADDR=$o(^DHCEQPreCostAllotDetail(0,"SourceID",MDRowID,CADDR))  q:CADDR=""  d
	..s CADMonthDepreDataList=$g(^DHCEQPreCostAllotDetail(CADDR))
	..d BuildCostAllotDetailDataList
	s TDepreFlag=1	///标记有折旧的数据直接输出
	q
BuildCostAllotDetailDataList
	q:+$p(CADMonthDepreDataList,"^",5)=0  //Modefied by zc0131 2023-03-08 折旧金额为0的过滤
	s CADFundsTypeDR=$p(CADMonthDepreDataList,"^",7)
	q:CADFundsTypeDR'=TFundsTypeDR
	///相同资金来源不同核算项目的数据需要区分开
	///add by zy 20190917
	s CADFinaceItemID=$p(CADMonthDepreDataList,"^",9)
	q:(CADFinaceItemID'="")&&(CADFinaceItemID'=TFinaceItemDR)
	s CADFunctionCatID=$p(CADMonthDepreDataList,"^",10)
	q:(CADFunctionCatID'="")&&(CADFunctionCatID'=TFunctionCatDR)
	
	s CADLocDR=$p(CADMonthDepreDataList,"^",3)
	s TDepre=$p(CADMonthDepreDataList,"^",5)
	;add by lmm 2020-03-15 lmm0063 用于存在折旧冲负时使用	MZY0102	2296785		2021-11-24
	s TFundsOriginalFee=$p(CADMonthDepreDataList,"^",6)
	s TFundsDepreTotal=$p(CADMonthDepreDataList,"^",8)
	s TFundsNetFee=TFundsOriginalFee-TFundsDepreTotal
	//分摊科室与资产科室不一致时,按照科室汇总,同一个编码都会+1,数量就会出现重复
	//因此把TNo设置成空.
	i (CADLocDR'=TStoreLocDR) d
	.s TStoreLocDR=CADLocDR
	.s TStoreLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept",TStoreLocDR)
	.//需要确定dcount() 是否把空也记个数
	.//s TNo=""
	.s TFundsOriginalFee=0
	.s TFundsDepreTotal=0
	.s TFundsNetFee=0
	i ((TStockStatus=3)||(TStatus=3)||(TInvalidFlag="Y"))  d	//无效或报废设备有折旧则按照资金来源出,(原值,净值,累计折旧都为0)
	.s TFundsOriginalFee=0
	.s TFundsDepreTotal=0
	.s TFundsNetFee=0
	d OutputRowGetMonthDepre
	q

OutputRowGetMonthDepre
	//判断科室查询条件
	q:(pUseLocDR'="")&&(TStoreLocDR'=pUseLocDR)
	//判断科室院区属性
	;s THospitalDR=$p($g(^CTLOC(TStoreLocDR)),"^",22)   //modify by jyp 2019-10-18 CTLOC调整
	s THospitalDR=##Class(web.DHCEQ.Plat.LIBCommon).GetHospitalByDeptID(TStoreLocDR)   //modify by jyp 2019-10-18 CTLOC调整
	q:(pHosptailDR'="")&&(THospitalDR'="")&&(pHosptailDR'=THospitalDR)
	// MZY0102	2296785		2021-11-24
	s THospital=$P($g(^CT("HOSP", +THospitalDR)),"^",2)
	i THospital="" s THospital="科室未配置院区"
	///取科室类型
	s LGRowID=$o(^DHCEQCCode("DHCEQCLocGroup",0,"Code","02",0))
	s LGTFind=""
	s TLocGroupTypeDR=""	// MZY0102	2296785		2021-11-24	参数处置
	s LGTCode=""
	f  s LGTCode=$o(^DHCEQCCode("DHCEQCLocGroupType",0,"GroupCode",LGRowID,LGTCode))  q:LGTCode=""  d
	.s LGTRowID=0
	.f  s LGTRowID=$o(^DHCEQCCode("DHCEQCLocGroupType",0,"GroupCode",LGRowID,LGTCode,LGTRowID))  q:(LGTRowID="")||(LGTFind'="")  d
	..i SnapID'=""  d
	...s LGTFind=$o(^DHCEQSnapShot(SnapID,"LocType",LGTRowID,TStoreLocDR,0))
	..e  d
	...s LGTFind=$o(^DHCEQCCode("DHCEQCLocType",0,"LocType",LGTRowID,TStoreLocDR,0))
	..q:LGTFind=""
	..s TLocType=$p($g(^DHCEQCCode("DHCEQCLocGroupType",LGTRowID)),"^",3)
	..s TLocGroupTypeDR=LGTRowID
	q:(pLocGroupTypeDR'="")&&(pLocGroupTypeDR'=TLocGroupTypeDR)
	i LGTFind="" s TLocType="未划分科室职能"
	
	// MZY0069	1737181		2021-02-18	修正折旧报表科室对照取值
	i TStoreLocDR'="" d
	.s ContrastID=$o(^DHCEQCCode("DHCEQCContrastInfo",0,"SYSID",1,TStoreLocDR,0))
	.q:(ContrastID="")||($p($g(^DHCEQCCode("DHCEQCContrastInfo",+ContrastID)),"^",16)="Y")
	.s TLocType=$p($g(^DHCEQCCode("DHCEQCContrastInfo",ContrastID)),"^",6)
	.s TStoreLoc=$p($g(^DHCEQCCode("DHCEQCContrastInfo",ContrastID)),"^",7)
	///add by ZY0265 20210526
	s DepreYearFee=##class(web.DHCEQ.Stat.DHCEQMonthDepre).GetDepreYearFee(RowID,$p(pMonthStr,"-",1),pDepreTypeDR,TFundsTypeDR,TFinaceItemDR,TFunctionCatDR)
	// MZY0102	2296785		2021-11-24
	Set Data=$lb(TRowID,TEQNo,TEquipName,TABCType,TModel,TStoreLoc,TEquipType,TStatCat,TEquipCatCode,TEquipCat,TOriginalFee,TLimitYearsNum,TNetFee,TDepreTotalFee,TManuFactory,TUnit,TProvider,TStatus,TStockStatus,TInvalidFlag,TCode,TLeaveFactoryNo,TLeaveFactoryDate,TPurposeType,TOrigin,TRemark,TDepreMethod,TStartDate,TTransAssetDate,TQuantityNum,TOldEquipNo,TBrand,TOutLayType,TFundsTypeDR,TFundsType,TFundsOriginalFee,TFundsNetFee,TFundsDepreTotal,TMonth,TLocType,TStoreLocDR,TEquipTypeDR,TStatCatDR,THospitalDR,THospital,TMonthType,ExCode,ExDesc,TFinaceItemDR,TFinaceItemCode,TFinaceItem,TFunctionCatDR,TFunctionCatCode,TFunctionCat,TDepre,TPrevFundsDepreTotal,TReduDepre,TSCRemark,TLocGroupTypeDR)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetMonthDepre
	// MZY0102	2296785		2021-11-24
	s (TRowID,TEQNo,TEquipName,TABCType,TModel,TStoreLoc,TEquipType,TStatCat,TEquipCatCode,TEquipCat,TOriginalFee,TLimitYearsNum,TNetFee,TDepreTotalFee,TManuFactory,TUnit,TProvider,TStatus,TStockStatus,TInvalidFlag,TCode,TLeaveFactoryNo,TLeaveFactoryDate,TPurposeType,TOrigin,TRemark,TDepreMethod,TStartDate,TTransAssetDate,TQuantityNum,TOldEquipNo,TBrand,TOutLayType,TFundsTypeDR,TFundsType,TFundsOriginalFee,TFundsNetFee,TFundsDepreTotal,TDepre,TMonth,TLocType,TStoreLocDR,TEquipTypeDR,TStatCatDR,TFinaceItemDR,TFinaceItemCode,TFinaceItem,TFunctionCatDR,TFunctionCatCode,TFunctionCat,TDepre,THospitalDR,THospital,TPrevFundsDepreTotal,TReduDepre,TSCRemark,TLocGroupTypeDR)=""
	quit
}

ClassMethod MonthDepreFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = MonthDepreExecute ]
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

ClassMethod MonthDepreClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = MonthDepreExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)

	Quit $$$OK
}

/// add by ZY0265 20210526
/// 统计当前年度资产已经折旧的累积金额
/// w ##class(web.DHCEQ.Stat.DHCEQMonthDepre).GetDepreYearFee(1,"2021",1,3,1,1)
ClassMethod GetDepreYearFee(vEquipID, vYear, vDepreTypeDR, vFundsTypeDR, vFinaceItemDR, vFunctionCatDR)
{
	new vMDRowID,vCADDR,vMonthDepreDataList,vCADMonthDepreDataList,vCADFinaceItemID,vCADFunctionCatID,DepreYear
	s DepreYear=0
	s MonthStr=(vYear-1)_"-12"
	f  s MonthStr=$order(^DHCEQMonthDepre(0,"EquipMonth",vEquipID,MonthStr))  q:MonthStr=""  d
	.q:($p(MonthStr,"-",1)'=vYear)
	.s vMDRowID=0
	.f  s vMDRowID=$order(^DHCEQMonthDepre(0,"EquipMonth",vEquipID,MonthStr,vMDRowID))  q:vMDRowID=""  d
	..s vMonthDepreDataList=$g(^DHCEQMonthDepre(vMDRowID))
	..//判断当前的折旧类型.不同的折旧类型不会一起出.所以折旧类型是必填的参数
	..q:vDepreTypeDR'=$p(vMonthDepreDataList,"^",36)
	..q:($p(vMonthDepreDataList,"^",21)'="")
	..//s LocDR= $p($g(^DHCEQMonthDepre(MDRowID)),"^",33)
	..//取当月折旧数据对应该资金来源分摊各科室的折旧费用
	..
	..s vCADDR=0
	..f  s vCADDR=$o(^DHCEQCostAllotDetail(0,"SourceID",vMDRowID,vCADDR))  q:vCADDR=""  d
	...s vCADMonthDepreDataList=$g(^DHCEQCostAllotDetail(vCADDR))
	...//s CADFundsTypeDR=$p(vCADMonthDepreDataList,"^",7)
	...q:$p(vCADMonthDepreDataList,"^",7)'=vFundsTypeDR
	...///相同资金来源不同核算项目的数据需要区分开
	...///add by zy 20190917
	...s vCADFinaceItemID=$p(vCADMonthDepreDataList,"^",9)
	...q:(vCADFinaceItemID'="")&&(vCADFinaceItemID'=vFinaceItemDR)
	...s vCADFunctionCatID=$p(vCADMonthDepreDataList,"^",10)
	...q:(vCADFunctionCatID'="")&&(vCADFunctionCatID'=vFunctionCatDR)
	...
	...//s CADLocDR=$p(vCADMonthDepreDataList,"^",3)
	...s Depre=$p(vCADMonthDepreDataList,"^",5)
	...s DepreYear=DepreYear+Depre
	
	q DepreYear
}

}
