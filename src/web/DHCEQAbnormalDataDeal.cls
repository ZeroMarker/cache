Class web.DHCEQAbnormalDataDeal Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Add By DJ 2016-08-08
/// 描述:检测单据是否可以作废
/// 入参:vBussType   1:表示验收    2:表示入库  3.转移   4.合同
/// 		vBussRowID	总单RowID
/// 返回值:"0"表示可以作废     "-1^作废原因"表示不可以作废及原因
/// w ##Class(web.DHCEQAbnormalDataDeal).CheckBussCancelFlag(1,34)
ClassMethod CheckBussCancelFlag(vBussType, vBussRowID)
{
	s ReturnFlag=0,ISNo="",SMNo="",ISNos="",SMNos="",OCRNos="",AISNo="",AISNos="",AMSNo="",AMSNos=""	// MZY0109	2384432		2021-12-23
	i (vBussType="")||(vBussRowID="") q "-1^作废单据不存在!"
	s CurMonth=##Class(web.DHCEQReport).GetReportMonthByDate(+$H)
	//(验收作废)检测单据是否已经审核,是否已经无效,是否当月单据等
	i vBussType=1  d
	.s BussStatus=$p($g(^DHCEQOpenCheckRequest(vBussRowID)),"^",20)
	.s BussInvalidFlag=$p($g(^DHCEQOpenCheckRequest(vBussRowID)),"^",45)
	.s BussAuditDate=$p($g(^DHCEQOpenCheckRequest(vBussRowID)),"^",26)
	.s AuditMonth=##Class(web.DHCEQReport).GetReportMonthByDate(BussAuditDate)
	.i (BussStatus'=2)||(BussInvalidFlag="Y") s ReturnFlag="-1^验收单未审核或已无效"
	.q:+ReturnFlag'=0
	.i CurMonth'=AuditMonth s ReturnFlag="-1^不是当月验收单据不能处理"
	.q:+ReturnFlag'=0
	.s OCLRowID=$o(^DHCEQOpenCheckList(0,"OpenCheckRequest",vBussRowID,0))
	.i OCLRowID="" s ReturnFlag="-1^验收明细单不存在!"
	.q:+ReturnFlag'=0
	.s ISLRowID=0
	.f  s ISLRowID=$o(^DHCEQInStockList(0,"Source",2,OCLRowID,ISLRowID))  q:(ISLRowID="")||(+ReturnFlag'=0)  d
	..s ISRowID=$p($g(^DHCEQInStockList(ISLRowID)),"^",1)
	..q:ISRowID=""
	..s ISStatus=$p($g(^DHCEQInStock(ISRowID)),"^",10)
	..s ISInvalidFlag=$p($g(^DHCEQInStock(ISRowID)),"^",25)
	..s ISAuditDate=$p($g(^DHCEQInStock(ISRowID)),"^",13)
	..s AuditMonth=##Class(web.DHCEQReport).GetReportMonthByDate(ISAuditDate)
	..q:ISInvalidFlag="Y"
	..i ISStatus'=2 s ReturnFlag="-1^入库单未审核!"
	..q:+ReturnFlag'=0
	..i CurMonth'=AuditMonth s ReturnFlag="-1^不是当月入库单据不能处理"
	..q:+ReturnFlag'=0
	..s ISNo=$p($g(^DHCEQInStock(ISRowID)),"^",14)	//czf 1959109
	..i ISNos="" s ISNos=ISNo
	..e  i ('##Class(web.DHCEQCommon).IdInIds(ISNo,ISNos)) s ISNos=ISNos_","_ISNo
	..s ISLRowIDs=""
	..s ISMXRowID=0
	..f  s ISMXRowID=$o(^DHCEQInStockList(0,"InStock",ISRowID,ISMXRowID))  q:(ISMXRowID="")||(+ReturnFlag'=0)  d
	...s ISLRowIDs=ISLRowIDs_ISMXRowID_","
	..i ISLRowIDs'="" s ISLRowIDs=","_ISLRowIDs
	..;i ISLRowIDs'=(","_ISLRowID_",") s ReturnFlag="-1^入库单存在多条明细"		Mozy	2019-5-13	896229	可以批量作废入库单
	..
	..q:+ReturnFlag'=0
	..d CheckStoreMoveByISL
	.q:+ReturnFlag'=0
	.;检测对应设备是否存在相关业务
	.s EQRowID=0
	.f  s EQRowID=$o(^DHCEQEquip(0,"OpenCheckList",OCLRowID,EQRowID))  q:(EQRowID="")||(+ReturnFlag'=0)  d
	..s EQInStockListDR=$p($g(^DHCEQEquip(EQRowID)),"^",70)
	..i EQInStockListDR'=""  d
	...s ISLRowIDs=","_EQInStockListDR_","
	...d CheckStoreMoveByEq
	..q:+ReturnFlag'=0
	..s ReturnFlag=..CheckEquipBuss(EQRowID,"01,02,03,04,05,06,07,08,09,10")
	
	//(入库作废)检测单据是否已经审核,是否已经无效,是否当月单据等
	i vBussType=2  d
	.s BussStatus=$p($g(^DHCEQInStock(vBussRowID)),"^",10)
	.s BussInvalidFlag=$p($g(^DHCEQInStock(vBussRowID)),"^",25)
	.s BussAuditDate=$p($g(^DHCEQInStock(vBussRowID)),"^",13)
	.s AuditMonth=##Class(web.DHCEQReport).GetReportMonthByDate(BussAuditDate)
	.i (BussStatus'=2)||(BussInvalidFlag="Y") s ReturnFlag="-1^入库单未审核或已无效"
	.q:+ReturnFlag'=0
	.i CurMonth'=AuditMonth s ReturnFlag="-1^不是当月入库单据不能处理"
	.q:+ReturnFlag'=0
	.///modified by zy 20190424  变量名称错误
	.s ISNo=$p($g(^DHCEQInStock(vBussRowID)),"^",14)	//792478 czf 20181229
	.;获取入库单所有明细RowID串
	.s ISLRowIDs=""
	.s ISLRowID=0
	.f  s ISLRowID=$o(^DHCEQInStockList(0,"InStock",vBussRowID,ISLRowID))  q:(ISLRowID="")||(+ReturnFlag'=0)  d
	..s ISLRowIDs=ISLRowIDs_ISLRowID_","
	.i ISLRowIDs'="" s ISLRowIDs=","_ISLRowIDs
	.;检测对应设备是否存在相关业务
	.s ISLRowID=0
	.f  s ISLRowID=$o(^DHCEQInStockList(0,"InStock",vBussRowID,ISLRowID))  q:(ISLRowID="")||(+ReturnFlag'=0)  d
	..d CheckStoreMoveByISL
	..q:+ReturnFlag'=0
	..s EQStoreLocDR=0
	..f  s EQStoreLocDR=$o(^DHCEQEquip(0,"InStockList",ISLRowID,EQStoreLocDR))  q:(EQStoreLocDR="")||(+ReturnFlag'=0)  d
	...s EQRowID=0
	...f  s EQRowID=$o(^DHCEQEquip(0,"InStockList",ISLRowID,EQStoreLocDR,EQRowID))  q:(EQRowID="")||(+ReturnFlag'=0)  d
	....d CheckStoreMoveByEq
	....q:+ReturnFlag'=0
	....s ReturnFlag=..CheckEquipBuss(EQRowID,"01,02,03,04,05,06,07,08,09,10")
	
	//i ReturnFlag=0 s ReturnFlag=ReturnFlag_"^^"_ISNos_"^"_SMNos	// MZY0101	2293692		2021-11-22
	
	i vBussType=3  d		//add by czf 2019-12-16 CZF0051
	.s BussStatus=$p($g(^DHCEQStoreMove(vBussRowID)),"^",13)
	.s BussInvalidFlag=$p($g(^DHCEQStoreMove(vBussRowID)),"^",27)
	.s BussAuditDate=$p($g(^DHCEQStoreMove(vBussRowID)),"^",10)
	.s AuditMonth=##Class(web.DHCEQReport).GetReportMonthByDate(BussAuditDate)
	.i (BussStatus'=2)||(BussInvalidFlag="Y") s ReturnFlag="-1^转移单未审核或已无效"
	.q:+ReturnFlag'=0
	.i CurMonth'=AuditMonth s ReturnFlag="-1^不是当月转移单据不能处理"
	.q:+ReturnFlag'=0
	.;检测对应设备是否存在相关业务
	.s SMLRowID=0
	.f  s SMLRowID=$o(^DHCEQStoreMoveList(0,"StoreMove",vBussRowID,SMLRowID))  q:(SMLRowID="")||(+ReturnFlag'=0)  d
	..s EQRowIDs=$g(^DHCEQStoreMoveList(SMLRowID,"EX","RowIDs"))
	..s EQLength=$l(EQRowIDs,",")
	..f i=1:1:EQLength d
	...s EQRowID=$p(EQRowIDs,",",i)
	...s LIReturnFlag=$o(^DHCEQLifeInfo(0,"EquipSourceDate",EQRowID,22,BussAuditDate,""),-1)
	...;i LIReturnFlag'=""  d
	....;s LISourceID=$p($g(^DHCEQLifeInfo(LIReturnFlag)),"^",20)
	....;i SMLRowID'=LISourceID s ReturnFlag="-1^存在其他转移业务"
	...q:+ReturnFlag'=0
	...s ReturnFlag=..CheckEquipBuss(EQRowID,"01,02,03,04,05,06,07,08,09,10",vBussType, vBussRowID)
	
	i vBussType=4  d		//add by czf CZF0055 2020-02-20 bengin
	.s BussStatus=$p($g(^DHCEQContract(vBussRowID)),"^",24)
	.s BussAuditDate=$p($g(^DHCEQContract(vBussRowID)),"^",33)
	.i (BussStatus'=2) s ReturnFlag="-1^合同未审核"
	.q:+ReturnFlag'=0
	.s CLRowID=0
	.f  s CLRowID=$o(^DHCEQContractList(0,"Contract",vBussRowID,CLRowID)) q:(CLRowID="")||(+ReturnFlag'=0)  d
	..// MZY0109	2384432		2021-12-23		配件合同
	..i $p($g(^DHCEQContractList(CLRowID)),"^",5)=6 d
	...Do CheckDataByAISL
	..// MZY0101	2293692		2021-11-22		验收后补合同
	..else  if $p($g(^DHCEQContractList(CLRowID)),"^",5)=7 d
	...s OCLRowID=$p($g(^DHCEQContractList(CLRowID)),"^",17)
	...s OCRRowID=$p($g(^DHCEQOpenCheckList(OCLRowID)),"^",1)
	...q:$p($g(^DHCEQOpenCheckRequest(OCRRowID)),"^",45)'="N"
	...s OCRStatus=$p($g(^DHCEQOpenCheckRequest(OCRRowID)),"^",20)
	...s OCRNos=$p($g(^DHCEQOpenCheckRequest(OCRRowID)),"^",37)
	...s OCRInvalidFlag=$p($g(^DHCEQOpenCheckRequest(OCRRowID)),"^",45)
	...q:OCRInvalidFlag'="N"
	...Do CheckDataByOCL
	..e  d
	...s OCRCount=0
	...s OCLMXRowID=0
	...f  s OCLMXRowID=$o(^DHCEQOpenCheckList(0,"Source",1,CLRowID,OCLMXRowID)) q:(OCLMXRowID="")||(+ReturnFlag'=0)  d
	....s OCRRowID=$p($g(^DHCEQOpenCheckList(OCLMXRowID)),"^",1)
	....q:$p($g(^DHCEQOpenCheckRequest(OCRRowID)),"^",45)'="N"
	....s OCRCount=OCRCount+1
	....i OCRCount>1 s ReturnFlag="-1^验收单存在多条明细"
	....q:+ReturnFlag'=0
	...s OCLRowID=0
	...f  s OCLRowID=$o(^DHCEQOpenCheckList(0,"Source",1,CLRowID,OCLRowID)) q:(OCLRowID="")||(+ReturnFlag'=0)  d
	....s OCRRowID=$p($g(^DHCEQOpenCheckList(OCLRowID)),"^",1)
	....s OCRStatus=$p($g(^DHCEQOpenCheckRequest(OCRRowID)),"^",20)
	....s OCRRequestNo=$p($g(^DHCEQOpenCheckRequest(OCRRowID)),"^",37)
	....s OCRInvalidFlag=$p($g(^DHCEQOpenCheckRequest(OCRRowID)),"^",45)
	....q:OCRInvalidFlag'="N"
	....s OCRNo=$p($g(^DHCEQOpenCheckRequest(OCRRowID)),"^",37)	//czf 2286940 2021-11-18
	....i OCRNos="" s OCRNos=OCRNo
	....e  i ('##Class(web.DHCEQCommon).IdInIds(OCRNo,OCRNos)) s OCRNos=OCRNos_","_OCRNo
	....;i OCRStatus'=2 s ReturnFlag="-1^验收单"_OCRRequestNo_"未审核!"
	....;q:+ReturnFlag'=0
	....Do CheckDataByOCL
	
	i ReturnFlag=0 s ReturnFlag=ReturnFlag_"^^"_ISNos_"^"_SMNos_"^"_OCRNos_"^"_AISNos_"^"_AMSNos	// MZY0109	2384432		2021-12-23
	
	q ReturnFlag
	
CheckDataByOCL
	s ISLRowID=0
	f  s ISLRowID=$o(^DHCEQInStockList(0,"Source",2,OCLRowID,ISLRowID))  q:(ISLRowID="")||(+ReturnFlag'=0)  d
	.s ISRowID=$p($g(^DHCEQInStockList(ISLRowID)),"^",1)
	.q:ISRowID=""
	.s ISStatus=$p($g(^DHCEQInStock(ISRowID)),"^",10)
	.s ISInvalidFlag=$p($g(^DHCEQInStock(ISRowID)),"^",25)
	.s ISAuditDate=$p($g(^DHCEQInStock(ISRowID)),"^",13)
	.s AuditMonth=##Class(web.DHCEQReport).GetReportMonthByDate(ISAuditDate)
	.q:ISInvalidFlag="Y"
	.i ISStatus'=2 s ReturnFlag="-1^入库单未审核!"
	.q:+ReturnFlag'=0
	.i CurMonth'=AuditMonth s ReturnFlag="-1^不是当月入库单据不能处理"
	.q:+ReturnFlag'=0
	.s ISNo=$p($g(^DHCEQInStock(ISRowID)),"^",14)	//czf 2286940 2021-11-18
	.i ISNos="" s ISNos=ISNo
	.e  i ('##Class(web.DHCEQCommon).IdInIds(ISNo,ISNos)) s ISNos=ISNos_","_ISNo
	.s ISLRowIDs=""
	.s ISMXRowID=0
	.f  s ISMXRowID=$o(^DHCEQInStockList(0,"InStock",ISRowID,ISMXRowID))  q:(ISMXRowID="")||(+ReturnFlag'=0)  d
	..s ISLRowIDs=ISLRowIDs_ISMXRowID_","
	.i ISLRowIDs'="" s ISLRowIDs=","_ISLRowIDs
	.i ISLRowIDs'=(","_ISLRowID_",") s ReturnFlag="-1^入库单存在多条明细"
	.q:+ReturnFlag'=0
	.d CheckStoreMoveByISL
	q:+ReturnFlag'=0
	;检测对应设备是否存在相关业务
	s EQRowID=0
	f  s EQRowID=$o(^DHCEQEquip(0,"OpenCheckList",OCLRowID,EQRowID))  q:(EQRowID="")||(+ReturnFlag'=0)  d
	.s EQInStockListDR=$p($g(^DHCEQEquip(EQRowID)),"^",70)
	.i EQInStockListDR'=""  d
	..s ISLRowIDs=","_EQInStockListDR_","
	..d CheckStoreMoveByEq
	.q:+ReturnFlag'=0
	.s ReturnFlag=..CheckEquipBuss(EQRowID,"01,02,03,04,05,06,07,08,09,10")		//add by czf CZF0055 2020-02-20 end
	q
CheckStoreMoveByISL
	;根据入库明细检测转移单一对一判断
	s ISSMLRowID=0
	f  s ISSMLRowID=$o(^DHCEQStoreMoveList(0,"InStockList",ISLRowID,ISSMLRowID))  q:(ISSMLRowID="")||(+ReturnFlag'=0)  d
	.s SMRowID=$p($g(^DHCEQStoreMoveList(ISSMLRowID)),"^",1)
	.s SMInvalidFlag=$p($g(^DHCEQStoreMove(SMRowID)),"^",27)
	.q:SMInvalidFlag="Y"
	.s SMNo=$p($g(^DHCEQStoreMove(SMRowID)),"^",1)	//czf 1959109
	.i SMNos="" s SMNos=SMNo
	.e  i ('##Class(web.DHCEQCommon).IdInIds(SMNo,SMNos)) s SMNos=SMNos_","_SMNo
	.s SMLRowID=0
	.f  s SMLRowID=$o(^DHCEQStoreMoveList(0,"StoreMove",SMRowID,SMLRowID))  q:(SMLRowID="")||(+ReturnFlag'=0)  d
	..s SMInStockDR=$p($g(^DHCEQStoreMoveList(SMLRowID)),"^",4)
	..s SMEquipDR=$p($g(^DHCEQStoreMoveList(SMLRowID)),"^",2)
	..i SMInStockDR="" s SMInStockDR=$p($g(^DHCEQEquip(SMEquipDR)),"^",70)
	..i ISLRowIDs'[(","_SMInStockDR_",") s ReturnFlag="-1^转移单存在多条明细"
	q
CheckStoreMoveByEq	
	;根据设备RowID检测转移单一对一判断
	s EQSMLRowID=0
	f  s EQSMLRowID=$o(^DHCEQStoreMoveList(0,"Equip",EQRowID,EQSMLRowID))  q:(EQSMLRowID="")||(+ReturnFlag'=0)  d
	.s SMRowID=$p($g(^DHCEQStoreMoveList(EQSMLRowID)),"^",1)
	.s SMInvalidFlag=$p($g(^DHCEQStoreMove(SMRowID)),"^",27)
	.q:SMInvalidFlag="Y"
	.s SMNo=$p($g(^DHCEQStoreMove(SMRowID)),"^",1)	//czf 1959109
	.i SMNos="" s SMNos=SMNo
	.e  i ('##Class(web.DHCEQCommon).IdInIds(SMNo,SMNos)) s SMNos=SMNos_","_SMNo
	.s SMLRowID=0
	.f  s SMLRowID=$o(^DHCEQStoreMoveList(0,"StoreMove",SMRowID,SMLRowID))  q:(SMLRowID="")||(+ReturnFlag'=0)  d
	..s SMInStockDR=$p($g(^DHCEQStoreMoveList(SMLRowID)),"^",4)
	..s SMEquipDR=$p($g(^DHCEQStoreMoveList(SMLRowID)),"^",2)
	..i SMInStockDR="" s SMInStockDR=$p($g(^DHCEQEquip(SMEquipDR)),"^",70)
	..i ISLRowIDs'[(","_SMInStockDR_",") s ReturnFlag="-1^转移单存在多条明细"
	q
CheckDataByAISL
	// MZY0109	2384432		2021-12-23
	s AISLRowID=0
	f  s AISLRowID=$O(^DHCEQAInStockList(AISLRowID)) q:(AISLRowID="")||(+ReturnFlag'=0)  d
	.q:CLRowID'=$p($g(^DHCEQAInStockList(AISLRowID)),"^",25)		;AISLHold5
	.s AISRowID=$p($g(^DHCEQAInStockList(AISLRowID)),"^",1)
	.q:AISRowID=""
	.s AISNo=$p($g(^DHCEQAInStock(AISRowID)),"^",6)
	.s AISStatus=$p($g(^DHCEQAInStock(AISRowID)),"^",16)
	.s AISAuditDate=$p($g(^DHCEQAInStock(AISRowID)),"^",24)
	.s AuditMonth=##Class(web.DHCEQReport).GetReportMonthByDate(AISAuditDate)
	.i AISStatus<2 s ReturnFlag="-1^配件入库单["_AISNo_"]未审核!"
	.q:+ReturnFlag'=0
	.i CurMonth'=AuditMonth s ReturnFlag="-1^["_AISNo_"]不是当月入库单据不能处理"
	.q:+ReturnFlag'=0
	.i AISNos="" s AISNos=AISNo
	.e  i ('##Class(web.DHCEQCommon).IdInIds(AISNo,AISNos)) s AISNos=AISNos_","_AISNo
	.
	.s AISLRowIDs=","
	.s AISMXRowID=0
	.f  s AISMXRowID=$o(^DHCEQAInStockList(0,"AInStock",AISRowID,AISMXRowID)) q:(AISMXRowID="")  d
	..s AISLRowIDs=AISLRowIDs_AISMXRowID_","
	.i AISLRowIDs'=(","_AISLRowID_",") s ReturnFlag="-1^入库单存在多条明细"
	.q:+ReturnFlag'=0
	.d CheckAMoveStockByAISL
	.q:+ReturnFlag'=0
	.
	.s ASDRowID=0
	.f  s ASDRowID=$o(^DHCEQAStockDetail(0,"AInStockList",AISLRowID,ASDRowID)) q:(ASDRowID="")||(+ReturnFlag'=0)  d
	..s ARLRowID=0
	..f  s ARLRowID=$o(^DHCEQAReduceList(ARLRowID)) q:(ARLRowID="")||(+ReturnFlag'=0)  d
	...q:$p($g(^DHCEQAReduceList(ARLRowID)),"^",5)'=ASDRowID
	...s ARRowID=$p($g(^DHCEQAReduceList(ARLRowID)),"^",1)
	...i $p($g(^DHCEQAReduce(ARRowID)),"^",23)'=3 s ReturnFlag="-1^存在配件退货减少业务"
	
	q
CheckAMoveStockByAISL
	s ASMLRowID=0
	f  s ASMLRowID=$o(^DHCEQAMoveStockList(0,"InStockList",AISLRowID,ASMLRowID)) q:(ASMLRowID="")||(+ReturnFlag'=0)  d
	.s AMSRowID=$p($g(^DHCEQAMoveStockList(ASMLRowID)),"^",1)
	.s AMSNo=$p($g(^DHCEQAMoveStockList(ASMLRowID)),"^",1)
	.s AMSStatus=$p($g(^DHCEQAMoveStockList(ASMLRowID)),"^",28)
	.i AMSStatus<2 s ReturnFlag="-1^配件出库单["_AMSNo_"]未审核!"
	.q:+ReturnFlag'=0
	.i AMSNos="" s AMSNos=AMSNo
	.e  i ('##Class(web.DHCEQCommon).IdInIds(AMSNo,AMSNos)) s AMSNos=AMSNos_","_AMSNo
	.
	.s AMSLRowIDs=","
	.s AMSMXRowID=0
	.f  s AMSMXRowID=$o(^DHCEQAMoveStockList(0,"MoveStock",AMSRowID,AMSMXRowID)) q:(AMSMXRowID="")  d
	..s AMSLRowIDs=AMSLRowIDs_AMSMXRowID_","
	.i AMSLRowIDs'=(","_ASMLRowID_",") s ReturnFlag="-1^转移单存在多条明细"
	
	q
}

/// Add By DJ 2016-08-08
/// 描述:检测设备是否存在相关业务
/// 入参:vEquipDR设备RowID
/// 		vBussTypeIDs表示"01,02,03,04"（折旧01,调账02,调整数据03,维修04,减少05,报废06,退货07,保养08,检查09,租赁10）
/// 返回值:0表示不存在相关业务,"-1^原因"存在相关业务
/// w ##class(web.DHCEQAbnormalDataDeal).CheckEquipBuss("28052","01,02,03,04,05,06,07,08,09,10","","")
ClassMethod CheckEquipBuss(vEquipDR, vBussTypeIDS, vBussType As %String = "", vBussRowID As %String = "")
{
	s Find=0
	s CurMonth=##Class(web.DHCEQReport).GetReportMonthByDate(+$H)
	i vEquipDR="" q "-1^设备不能为空"
	s EQInvalidFlag=$p($g(^DHCEQEquip(vEquipDR)),"^",59)
	i EQInvalidFlag="Y" q "-1^相关设备已无效"
	s EQStatus=$p($g(^DHCEQEquip(vEquipDR)),"^",38)
	i EQStatus="3" q "-1^相关设备已报废"
	s EQStockStatus=$p($g(^DHCEQEquip(vEquipDR)),"^",60)
	i EQStockStatus="3" q "-1^设备已销帐"
	s EQInStockListDR=$p($g(^DHCEQEquip(vEquipDR)),"^",70)
	i vBussTypeIDS'="" s vBussTypeIDS=","_vBussTypeIDS_","
	i (vBussTypeIDS[",01,")&&($D(^DHCEQMonthDepre(0,"Equip",vEquipDR)))
	{
		i (vBussType=3)&&(vBussRowID'="")
		{
			s BussAuditDate=$p($g(^DHCEQStoreMove(vBussRowID)),"^",10)
			s BussMonth=$p($zd(BussAuditDate,3),"-",1,2)
			i CurMonth=BussMonth q 0	//转移发生在当前月可以作废转移单，非当前月存在折旧记录不可作废 czf 2023-03-02
			e  q "-1^存在折旧记录"
		}
	 	q "-1^存在折旧记录"
	}	
	i (vBussTypeIDS[",02,")&&($D(^DHCEQChangeAccount(0,"Equip",vEquipDR))) q "-1^存在调账记录"
	i (vBussTypeIDS[",03,")&&($D(^DHCEQAdjustDataList(0,"Equip",vEquipDR))) q "-1^存在调整数据记录"
	i (vBussTypeIDS[",04,")
	{
		s MRRowID=0
		f  s MRRowID=$o(^DHCEQMMaintRequest(MRRowID))  q:(MRRowID="")||(+Find'=0)   d
		.s MRAddDate=$p($g(^DHCEQMMaintRequest(MRRowID)),"^",43)
		.s AddDateMonth=##Class(web.DHCEQReport).GetReportMonthByDate(MRAddDate)
		.q:AddDateMonth'=CurMonth
		.s MRInvalidFlag=$p($g(^DHCEQMMaintRequest(MRRowID)),"^",57)
		.q:MRInvalidFlag="Y"		
		.s MRSourceType=$p($g(^DHCEQMMaintRequest(MRRowID)),"^",63)
		.s MRObjDR=$p($g(^DHCEQMMaintRequest(MRRowID)),"^",5)
		.s MRStatus=$p($g(^DHCEQMMaintRequest(MRRowID)),"^",41)
		.i (MRObjDR'="")&&(MRSourceType=1)  d
		..s EquipDR=$p($g(^DHCEQMExObj(MRObjDR)),"^",5)
		..q:EquipDR'=vEquipDR
		..s Find="-1^存在维修记录"
	}
	i +Find'=0 q Find
	
	i (vBussTypeIDS[",05,")||(vBussTypeIDS[",07,")
	{
		s RLRowID=0
		f  s RLRowID=$o(^DHCEQReturnList(0,"Equip",vEquipDR,RLRowID))  q:(RLRowID="")||(+Find'=0)  d
		.s RRowID=$p($g(^DHCEQReturnList(RLRowID)),"^",1)
		.q:RRowID=""
		.s RInvalidFlag=$p($g(^DHCEQReturn(RRowID)),"^",28)
		.q:RInvalidFlag="Y"
		.s RReturnType=$p($g(^DHCEQReturn(RRowID)),"^",37)
		.i RReturnType'="" s RReturnType=$p($g(^DHCEQCCode("DHCEQCOutType",RReturnType)),"^",1)
		.i (vBussTypeIDS[",07,")&&(RReturnType="TH")  d
		..s Find="-1^存在退货记录"
		.e  d
		..s Find="-1^存在减少记录"
		
		i +Find'=0 q Find
		
		i EQInStockListDR'=""  d
		.s RLRowID=0
		.f  s RLRowID=$o(^DHCEQReturnList(0,"InStockList",EQInStockListDR,RLRowID))  q:(RLRowID="")||(+Find'=0)  d
		..s RLRowIDs=$g(^DHCEQReturnList(RLRowID,"EX","RowIDs"))
		..q:(","_RLRowIDs_",")'[(","_vEquipDR_",")
		..s RRowID=$p($g(^DHCEQReturnList(RLRowID)),"^",1)
		..q:RRowID=""
		..s RInvalidFlag=$p($g(^DHCEQReturn(RRowID)),"^",28)
		..q:RInvalidFlag="Y"
		..s RReturnType=$p($g(^DHCEQReturn(RRowID)),"^",37)
		..i RReturnType'="" s RReturnType=$p($g(^DHCEQCCode("DHCEQCOutType",RReturnType)),"^",1)
		..i (vBussTypeIDS[",07,")&&(RReturnType="TH")  d
		...s Find="-1^存在退货记录"
		..e  d
		...s Find="-1^存在减少记录"
	}
	i +Find'=0 q Find
	
	i (vBussTypeIDS[",06,")
	{
		s DRRowID=$o(^DHCEQDisuseRequest(0,"Equip",vEquipDR,0))
		i DRRowID=""  d
		.s DRLRowID=$o(^DHCEQDisuseRequestList(0,"EquipDR",vEquipDR,0))
		.i DRLRowID'=""  d
		..s DRRowID=$p($g(^DHCEQDisuseRequestList(DRLRowID)),"^",1)
		.e  d
		..s DLRowID=$o(^DHCEQDisuseList(0,"Source",0,vEquipDR,0))
		..i DLRowID'=""  d
		...s DRRowID=$p($g(^DHCEQDisuseList(DLRowID)),"^",1)
		
		i DRRowID'=""
		{
			s DRInvalidFlag=$p($g(^DHCEQDisuseRequest(DRRowID)),"^",53)
			i DRInvalidFlag'="Y" q "-1^存在报废记录"
		}
		s DRRowID=0
		f  s DRRowID=$o(^DHCEQDisuseRequest(DRRowID))  q:(DRRowID="")||(+Find'=0)  d
		.s DRInvalidFlag=$p($g(^DHCEQDisuseRequest(DRRowID)),"^",53)
		.q:DRInvalidFlag="Y"
		.s DRKindFlag=$p($g(^DHCEQDisuseRequest(DRRowID)),"^",44)
		.q:DRKindFlag="0"
		.s DRAddDate=$p($g(^DHCEQDisuseRequest(DRRowID)),"^",12)
		.s AddDateMonth=##Class(web.DHCEQReport).GetReportMonthByDate(DRAddDate)
		.q:AddDateMonth'=CurMonth
		.i DRKindFlag="1"  d	//单批多台
		..s DRRowIDs=$g(^DHCEQDisuseRequest(DRRowID,"EX"))			//Modify DJ 2016-11-30
		..i (","_DRRowIDs_",")[(","_vEquipDR_",") s Find="-1^存在报废记录"
		.q:+Find'=0
		.i DRKindFlag="2"  d	//多批多台
		..s DLRowID=0
		..f  s DLRowID=$o(^DHCEQDisuseList(0,"Request",DRRowID,DLRowID))  q:(DLRowID="")||(+Find'=0)  d
		...s DLSourceType=$p($g(^DHCEQDisuseList(DLRowID)),"^",2)
		...q:DLSourceType'="1"
		...s DLRowIDs=$g(^DHCEQDisuseList(DLRowID,"EX"))
		...i (","_DLRowIDs_",")[(","_vEquipDR_",") s Find="-1^存在报废记录"
	}
	i +Find'=0 q Find
	
	i (vBussTypeIDS[",08,")&&($D(^DHCEQMaint(0,"Equip",1,vEquipDR))) q "-1^存在保养记录"
	i (vBussTypeIDS[",09,")&&($D(^DHCEQMaint(0,"Equip",2,vEquipDR))) q "-1^存在检查记录"
	i (vBussTypeIDS[",10,")&&($D(^DHCEQRent(0,"Equip",vEquipDR))) q "-1^存在租赁记录"
	
	q 0
}

/// Add By DJ 2016-08-08
/// vBussType:		1-验收单	2-入库单	3-转移单	4-合同
/// vBussRowID:业务主单ID
/// 描述:作废单据处理
ClassMethod CancelBuss(vBussType, vBussRowID)
{
	s CheckFlag=..CheckBussCancelFlag(vBussType,vBussRowID)
	i +CheckFlag'=0 q CheckFlag
	s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	s Date=+$H
	s Time=$p($H,",",2)
	s SQLCODE=0
	TSTART
	//验收删除
	i vBussType=1
	{
		&SQL(Update SQLUSER.DHC_EQOpenCheckRequest Set OCR_Status=3,OCR_CancelUser=:User,OCR_CancelDate=:Date,OCR_CancelTime=:Time,OCR_InvalidFlag='Y' Where OCR_RowID=:vBussRowID)
		i SQLCODE
		{
			TROLLBACK
			q SQLCODE
		}
		s OCLRowID=$o(^DHCEQOpenCheckList(0,"OpenCheckRequest",vBussRowID,0))		//add by czf 20020-06-03 begin 1348148
		s OCLSourceType=$p($g(^DHCEQOpenCheckList(OCLRowID)),"^",63)
	 	s OCLSourceID=$p($g(^DHCEQOpenCheckList(OCLRowID)),"^",64)
		s OCLNum=$p($g(^DHCEQOpenCheckList(OCLRowID)),"^",16)
		s SQLCODE=##Class(web.DHCEQOpenCheckRequest).SourceUpdate(OCLSourceType,OCLSourceID,OCLNum,2)
		i SQLCODE=100 s SQLCODE=0		//czf 2022-04-21
		if SQLCODE
		{
			TROLLBACK
			q SQLCODE
		}				//add by czf 20020-06-03 end 1348148
		/*s ISLRowID=$o(^DHCEQInStockList(0,"Source",2,OCLRowID,""),-1)
		s ISRowID=""
		i ISLRowID'=""
		{
			s ISRowID=$p($g(^DHCEQInStockList(ISLRowID)),"^",1)
			s ISInvalidFlag=$p($g(^DHCEQInStock(ISRowID)),"^",25)
			i ISInvalidFlag'="Y"
			{
				&SQL(Update SQLUSER.DHC_EQInStock Set IS_Status=3,IS_CancelUser=:User,IS_CancelDate=:Date,IS_CancelTime=:Time,IS_InvalidFlag='Y' Where IS_RowID=:ISRowID)
				i SQLCODE
				{
					TROLLBACK
					q SQLCODE
				}
				//根据入库记录删除转移单
				d CancelStoreMoveByISL
			}
		}*/
		// Mozy	2019-5-13	896229
		s ISLRowID=0
		f  s ISLRowID=$o(^DHCEQInStockList(0,"Source",2,OCLRowID,ISLRowID)) q:(ISLRowID="")||(SQLCODE'=0)  d
		.s ISRowID=$p($g(^DHCEQInStockList(ISLRowID)),"^",1)
		.q:$p($g(^DHCEQInStock(ISRowID)),"^",25)'="N"
		.&SQL(Update SQLUSER.DHC_EQInStock Set IS_Status=3,IS_CancelUser=:User,IS_CancelDate=:Date,IS_CancelTime=:Time,IS_InvalidFlag='Y' Where IS_RowID=:ISRowID)
		.q:SQLCODE'=0
		.//根据入库记录删除转移单
		.d CancelStoreMoveByISL
		i SQLCODE
		{
			TROLLBACK
			q SQLCODE
		}
		&SQL(Update SQLUSER.DHC_EQEquip Set EQ_InvalidFlag='Y' Where EQ_OpenCheckListDR=:OCLRowID)
		i SQLCODE=100 s SQLCODE=0	//czf 2022-04-25
		i SQLCODE
		{
			TROLLBACK
			q SQLCODE
		}
		//根据设备记录删除转移单
		s EQRowID=0
		f  s EQRowID=$o(^DHCEQEquip(0,"OpenCheckList",OCLRowID,EQRowID))  q:(EQRowID="")||(SQLCODE'=0)  d
		.d CancelStoreMoveByEq
	}		
	//入库删除
	i vBussType=2
	{
		&SQL(Update SQLUSER.DHC_EQInStock Set IS_Status=3,IS_CancelUser=:User,IS_CancelDate=:Date,IS_CancelTime=:Time,IS_InvalidFlag='Y',IS_Hold1='Y' Where IS_RowID=:vBussRowID)	//用Hold1区分该操作是入库单作废，用于入库过滤 1379458
		i SQLCODE
		{
			TROLLBACK
			q SQLCODE
		}
		s ISLRowID=0
		f  s ISLRowID=$o(^DHCEQInStockList(0,"InStock",vBussRowID,ISLRowID))  q:(ISLRowID="")||(SQLCODE'=0)  d
		.s ISLSourceType=$p($g(^DHCEQInStockList(ISLRowID)),"^",18)
		.s ISLSourceID=$p($g(^DHCEQInStockList(ISLRowID)),"^",19)
		.s OCRRowID=$p($g(^DHCEQOpenCheckList(ISLSourceID)),"^",1)
		.;i ISLSourceType=2  d 	//modified by czf 2020-06-03 begin 作废入库单时不作废验收单
		..;&SQL(Update SQLUSER.DHC_EQOpenCheckRequest Set OCR_Status=3,OCR_CancelUser=:User,OCR_CancelDate=:Date,OCR_CancelTime=:Time,OCR_InvalidFlag='Y' Where OCR_RowID=:OCRRowID)
		.;q:SQLCODE'=0		//modified by czf 2020-06-03 end 1348151
		.;&SQL(Update SQLUSER.DHC_EQEquip Set EQ_StockStatus=0,EQ_Status=0 Where EQ_InStockListDR=:ISLRowID)		//作废入库单时设备恢复为未入库状态 czf 2020-06-24 1379458
		.;q:SQLCODE'=0
		.;删除对应入库明细的资金来源记录,add by wy 2022-8-1 2755311 
		.s fundsRowID=0
		.f  s fundsRowID=$o(^DHCEQFunds("0","Source",3,ISLSourceID,fundsRowID))  q:(fundsRowID="")||(SQLCODE'=0)  d
		..&SQL(Update SQLUSER.DHC_EQFunds Set F_InvalidFlag='Y' where F_RowID=:fundsRowID )
		.q:SQLCODE'=0
		.;根据入库记录删除转移单
		.d CancelStoreMoveByISL
		.q:SQLCODE'=0
		.s EQStoreLocDR=0
		.f  s EQStoreLocDR=$o(^DHCEQEquip(0,"InStockList",ISLRowID,EQStoreLocDR))  q:(EQStoreLocDR="")||(SQLCODE'=0)  d
		..s EQRowID=0
		..f  s EQRowID=$o(^DHCEQEquip(0,"InStockList",ISLRowID,EQStoreLocDR,EQRowID))  q:(EQRowID="")||(SQLCODE'=0)  d
		...;删除对应入库明细设备的资金来源记录 add by wy 2022-8-1 2755311 
		...s fundsRowID=0
		...f  s fundsRowID=$o(^DHCEQFunds("0","Source",1,EQRowID,fundsRowID))  q:(fundsRowID="")||(SQLCODE'=0)  d
		....&SQL(Update SQLUSER.DHC_EQFunds Set F_InvalidFlag='Y' where F_RowID=:fundsRowID )
		...d CancelStoreMoveByEq
		.q:SQLCODE'=0
		.&SQL(Update SQLUSER.DHC_EQEquip Set EQ_StockStatus=0,EQ_Status=0,EQ_StoreLocDR=NULL,EQ_UseLocDR=NULL,EQ_TransAssetDate=NULL,EQ_StartDate=NULL Where EQ_InStockListDR=:ISLRowID) //还原设备信息 czf 2020-07-21
		.q:SQLCODE'=0
	}
	//转移删除
	i vBussType=3	//add by czf  2019-12-16 CZF0051
	{
		&SQL(Update SQLUSER.DHC_EQStoreMove Set SM_Status=3,SM_CancelUser=:User,SM_CancelDate=:Date,SM_CancelTime=:Time,SM_InvalidFlag='Y' Where SM_RowID=:vBussRowID)
		i SQLCODE
		{
			TROLLBACK
			q SQLCODE
		}
		s FromLoc=$p($g(^DHCEQStoreMove(vBussRowID)),"^",2)
		s MoveType =$p($g(^DHCEQStoreMove(vBussRowID)),"^",12)
		s SMLRowID=""
		f  s SMLRowID=$o(^DHCEQStoreMoveList(0,"StoreMove",vBussRowID,SMLRowID))  q:(SMLRowID="")||(SQLCODE'=0)  d
		.s EQRowIDs=$g(^DHCEQStoreMoveList(SMLRowID,"EX","RowIDs"))
		.s EQLength=$l(EQRowIDs,",")
		.f i=1:1:EQLength d
		..s EQRowID=$p(EQRowIDs,",",i)
		..k EQPL
		..s EQPL(20)=FromLoc	;UseLoc
		..s EQPL(61)=1  		;0:新增|1:入库|2:转移出库|3:出库
		..s EQPL(68)=FromLoc	;库房
		..i MoveType="0" d		;出库
		...s EQPL(20)=""
		...s EQPL(39)=0			;状态
		...s EQPL(45)=""		;启用日期
		...s EQPL(104)=""		;领用日期
		..i MoveType="3" d		;退库
		...s EQPL(39)=1
		...s EQPL(104)=$p(^DHCEQEquip(EQRowID),"^",44)
		..&SQL(Update SQLUSER.DHC_EQEquip values :EQPL() Where EQ_RowID=:EQRowID)
		..q:SQLCODE'=0
        ..&SQL(Update SQLUSER.DHC_EQLifeInfo Set LI_UpdateUserDR=:User,LI_UpdateDate=:Date,LI_UpdateTime=:Time,LI_Hold2='Y' Where LI_SourceType=22 and LI_SourceID=:SMLRowID and LI_EquipDR=:EQRowID)	 //add by wy 2020-4-1 需求1249940
		..q:SQLCODE'=0
	}
	//合同作废 add by CZF0055 2020-02-20 begin
	i vBussType=4
	{
		&SQL(Update SQLUSER.DHC_EQContract set CT_Status=3,CT_RefuseUserDR=:User,CT_RefuseDate=:Date,CT_RefuseTime=:Time Where CT_RowID=:vBussRowID)
		i SQLCODE
		{
			TROLLBACK
			q SQLCODE
		}
		s CLRowID=0
		f  s CLRowID=$o(^DHCEQContractList(0,"Contract",vBussRowID,CLRowID)) q:(CLRowID="")||(SQLCODE'=0)  d
		.// MZY0109	2384432		2021-12-23		配件合同
		.i $p($g(^DHCEQContractList(CLRowID)),"^",5)=6 d
		..s AISLRowID=0
		..f  s AISLRowID=$O(^DHCEQAInStockList(AISLRowID)) q:(AISLRowID="")||(SQLCODE'=0)  d
		...q:CLRowID'=$p($g(^DHCEQAInStockList(AISLRowID)),"^",25)		;AISLHold5
		...s AISRowID=$p($g(^DHCEQAInStockList(AISLRowID)),"^",1)
		...q:$p($g(^DHCEQAInStock(AISRowID)),"^",16)'=2
		...&SQL(Update SQLUSER.DHC_EQAInStock Set AIS_Status=3,AIS_RejectUserDR=:User,AIS_RejectDate=:Date,AIS_RejectTime=:Time Where AIS_RowID=:AISRowID)
		...q:SQLCODE
		...s ASMLRowID=0
		...f  s ASMLRowID=$o(^DHCEQAMoveStockList(0,"InStockList",AISLRowID,ASMLRowID)) q:(ASMLRowID="")||(SQLCODE'=0)  d
		....s AMSRowID=$p($g(^DHCEQAMoveStockList(ASMLRowID)),"^",1)
		....q:$p($g(^DHCEQAMoveStock(AMSRowID)),"^",28)'=2
		....&SQL(Update SQLUSER.DHC_EQAMoveStock Set AMS_Status=3,AMS_RejectUserDR=:User,AMS_RejectDate=:Date,AMS_RejectTime=:Time Where AMS_RowID=:AMSRowID)
		...q:SQLCODE
		...
		...s StoreASDR=""	; 库房的库存
		...s ASDRowID=0
		...f  s ASDRowID=$o(^DHCEQAStockDetail(0,"AInStockList",AISLRowID,ASDRowID)) q:(ASDRowID="")||(SQLCODE'=0)  d
		....s ASDStatus=$p($g(^DHCEQAStockDetail(ASDRowID)),"^",12)
		....q:ASDStatus>1
		....s ASDStock=$p($g(^DHCEQAStockDetail(ASDRowID)),"^",17)
		....q:ASDStock=0
		....&SQL(Update SQLUSER.DHC_EQAStockDetail Set ASD_Stock=0,ASD_Status=2 Where ASD_RowID=:ASDRowID)
		....q:SQLCODE
		....
		....s ASRowID=$p($g(^DHCEQAStockDetail(ASDRowID)),"^",21)
		....s FinalBPrice=$p($g(^DHCEQAStock(ASRowID)),"^",7)
		....s Amount=$p($g(^DHCEQAStock(ASRowID)),"^",9)
		....s ASStock=$p($g(^DHCEQAStock(ASRowID)),"^",10)
		....;s AISLPrice=$p($g(^DHCEQAInStockList(AISLRowID)),"^",8)
		....;s AISLQuantityNum=$p($g(^DHCEQAInStockList(AISLRowID)),"^",9)
		....;s AISLAmount=$p($g(^DHCEQAInStockList(AISLRowID)),"^",10)
		....;s StoreASDR=ASRowID
		....s ASStock=ASStock-ASDStock
		....s Amount=Amount-(FinalBPrice*ASDStock)
		....&SQL(Update SQLUSER.DHC_EQAStock Set AS_Stock=:ASStock,AS_Amount=:Amount Where AS_RowID=:ASRowID)
		.
		.e  d
		..s OCLRowID=0
		..f  s OCLRowID=$o(^DHCEQOpenCheckList(0,"Source",1,CLRowID,OCLRowID)) q:(OCLRowID="")||(SQLCODE'=0)  d
		...s OCRRowID=$p($g(^DHCEQOpenCheckList(OCLRowID)),"^",1)
		...s OCRStatus=$p($g(^DHCEQOpenCheckRequest(OCRRowID)),"^",20)
		...s OCRInvalidFlag=$p($g(^DHCEQOpenCheckRequest(OCRRowID)),"^",45)
		...q:OCRInvalidFlag'="N"
		...&SQL(Update SQLUSER.DHC_EQOpenCheckRequest Set OCR_Status=3,OCR_CancelUser=:User,OCR_CancelDate=:Date,OCR_CancelTime=:Time,OCR_InvalidFlag='Y' Where OCR_RowID=:OCRRowID)
		...q:SQLCODE
		...s ISLRowID=0
		...f  s ISLRowID=$o(^DHCEQInStockList(0,"Source",2,OCLRowID,ISLRowID))  q:(ISLRowID="")||(SQLCODE'=0)  d
		....s ISRowID=$p($g(^DHCEQInStockList(ISLRowID)),"^",1)
		....q:ISRowID=""
		....s ISInvalidFlag=$p($g(^DHCEQInStock(ISRowID)),"^",25)
		....q:ISInvalidFlag="Y"
		....&SQL(Update SQLUSER.DHC_EQInStock Set IS_Status=3,IS_CancelUser=:User,IS_CancelDate=:Date,IS_CancelTime=:Time,IS_InvalidFlag='Y' Where IS_RowID=:ISRowID)
		....q:SQLCODE
		....;根据入库记录删除转移单
		....d CancelStoreMoveByISL
		...;无效设备记录
		...&SQL(Update SQLUSER.DHC_EQEquip Set EQ_InvalidFlag='Y' Where EQ_OpenCheckListDR=:OCLRowID)
		...i SQLCODE=100 s SQLCODE=0
		...q:SQLCODE
		...;根据设备记录删除转移单
		...s EQRowID=0
		...f  s EQRowID=$o(^DHCEQEquip(0,"OpenCheckList",OCLRowID,EQRowID))  q:(EQRowID="")||(SQLCODE'=0)  d
		....d CancelStoreMoveByEq
	}
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE
	}
	TCOMMIT
	q SQLCODE
CancelStoreMoveByISL
	//根据入库记录删除转移单
	s SMLRowID=0
	f  s SMLRowID=$o(^DHCEQStoreMoveList(0,"InStockList",ISLRowID,SMLRowID))  q:(SMLRowID="")||(SQLCODE'=0)  d
	.s SMRowID=$p($g(^DHCEQStoreMoveList(SMLRowID)),"^",1)
	.s SMInvalidFlag=$p($g(^DHCEQStoreMove(SMRowID)),"^",27)
	.q:SMInvalidFlag="Y"
	.&SQL(Update SQLUSER.DHC_EQStoreMove Set SM_Status=3,SM_CancelUser=:User,SM_CancelDate=:Date,SM_CancelTime=:Time,SM_InvalidFlag='Y' Where SM_RowID=:SMRowID)
	.&SQL(Update SQLUSER.DHC_EQLifeInfo Set LI_UpdateUserDR=:User,LI_UpdateDate=:Date,LI_UpdateTime=:Time,LI_Hold2='Y' Where LI_SourceType=22 and LI_SourceID=:SMLRowID)  //add by wy 2020-4-1 需求1249940

	q
CancelStoreMoveByEq
	//根据设备记录删除转移单
	s SMLRowID=0
	f  s SMLRowID=$o(^DHCEQStoreMoveList(0,"Equip",EQRowID,SMLRowID))  q:(SMLRowID="")||(SQLCODE'=0)  d
	.s SMRowID=$p($g(^DHCEQStoreMoveList(SMLRowID)),"^",1)
	.s SMInvalidFlag=$p($g(^DHCEQStoreMove(SMRowID)),"^",27)
	.q:SMInvalidFlag="Y"
	.&SQL(Update SQLUSER.DHC_EQStoreMove Set SM_Status=3,SM_CancelUser=:User,SM_CancelDate=:Date,SM_CancelTime=:Time,SM_InvalidFlag='Y' Where SM_RowID=:SMRowID)
    .&SQL(Update SQLUSER.DHC_EQLifeInfo Set LI_UpdateUserDR=:User,LI_UpdateDate=:Date,LI_UpdateTime=:Time,LI_Hold2='Y' Where LI_SourceType=22 and LI_SourceID=:SMLRowID and LI_EquipDR=:EQRowID)	//add by wy 2020-4-1 需求1249940
    q
}

}
