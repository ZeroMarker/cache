Import sqluser

Class CHSSWeb.Pharmacy.PhaOrderItem Extends (%RegisteredObject, %XML.Adaptor) [ Inheritance = right, Not ProcedureBlock ]
{

/// creator:zhangyong
/// date:2011-11-04
/// description: 读取药品信息(窗体使用)
/// input:  input-库存项别名,StkGrpCode-类组代码,StkGrpType-类组类型,Locdr-Ctloc_rowid,NotUseFlag("N"或"Y"),QtyFlag("1"则只显示正库存),HospID(院区),Start,Limit 
/// output: String 
/// others:
ClassMethod GetPhaOrderItemForDialog(Input, StkGrpCode, StkGrpType, Locdr, NotUseFlag, QtyFlag, HospID, Start, Limit) As %Library.String
{
	SET resultString = ##class(CHSSWeb.Pharmacy.PhaOrderItem).GetPhaOrderItemInfo(Input, StkGrpCode, StkGrpType, Locdr, NotUseFlag, QtyFlag, HospID, Start, Limit)
	W resultString
	Q ""
}

/// Descript:	取符合条件的库存项信息
/// Creater:	zhangyong
/// CreateDate:	2010-11-04
/// Input:		input-库存项别名,StkGrpCode-类组代码,StkGrpType-类组类型,Locdr-Ctloc_rowid,NotUseFlag("N"或"Y"),QtyFlag("1"则只显示正库存),HospID,Start,Limit 
/// Output:		Return
/// Return：	
ClassMethod GetPhaOrderItemInfo(Input, StkGrpCode, StkGrpType, Locdr, NotUseFlag, QtyFlag, HospID, Start, Limit) As %Library.String
{
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = ""
	;类组代码
	IF StkGrpCode'="" 
	{
		s sqlStr = "select distinct A.INCA_INCI_DR from inc_alias AS A, INC_Itm B"
					_" where (A.inca_code like '%"_Input_"%' or A.inca_desc like '%"
					_Input_"%' or A.inca_text like '%"_Input_"%') AND A.INCA_INCI_DR = B.INCI_RowID "
					_"AND B.inci_incsc_dr IN (Select scgr_stkcat_dr from dhc_stkcatgrprelations "
					_"Where scgr_scg_parref->scg_code='"_StkGrpCode_"')"
	}
	ELSE  
	{
		;类组类型
		IF StkGrpType=""
		{
			S sqlStr = "Select distinct INCA_INCI_DR From inc_alias "
						_"where inca_code like '%"_Input_"%' or inca_desc like '%"_Input_"%' or inca_text like '%"_Input_"%'"
		}
		ELSE {
			S sqlStr = "select distinct A.INCA_INCI_DR from inc_alias AS A, INC_Itm B "
						_"where (A.inca_code like '%"_Input_"%' or A.inca_desc like '%"
						_Input_"%' or A.inca_text like '%"_Input_"%') AND A.INCA_INCI_DR = B.INCI_RowID "
						_"AND B.inci_incsc_dr IN (select scgr_stkcat_dr from dhc_stkcatgrprelations where scgr_scg_parref->scg_type='"_StkGrpType_"')"
		}
	} 
	d result.Prepare(sqlStr)
	d result.Execute()
	s count = 0
	s resultString = ""
	s end = Start+Limit
	s json = ##class(Code.JsonObj).%New()
	While(result.Next())
	{
		s TInci = result.Data("INCA_INCI_DR")
		Q:'$D(^INCI(TInci))
		;科室
		I Locdr'="" Q:'$D(^INCI("IL_LOC",Locdr,TInci))
		;是否使用
		I NotUseFlag'="" Q:NotUseFlag'=$P(^INCI(TInci,2),"^",9)
		;取当前库存量
		s stkQty = 0
		if Locdr '= "" d
		.s stkQty=##Class(CHSSWeb.DrugStorage.PhaInfoCommon).IL(TInci,Locdr,+$h)
		q:(QtyFlag="1")&(stkQty'>0)
		
		s count = count+1
		
		S InciDr= TInci
		S InciItem=$P(^INCI(InciDr,1),"^",3)                //编号
		S InciCode=$P(^INCI(InciDr,1),"^",1)				//代码
 		S InciDesc=$P(^INCI(InciDr,1),"^",2)				//名称
 		S Spec=##Class(CHSSWeb.DrugStorage.PhaInfoCommon).GetSpec("",InciDr)		//规格
 		S ManfStr=##Class(CHSSWeb.DrugStorage.PhaInfoCommon).GetManf(InciDr)		//厂家
 		S Manfdr=$P(ManfStr,"^",1)									//厂家ID
 		S ManfCode=$P(ManfStr,"^",2)									//厂家代码
 		S ManfName=$P(ManfStr,"^",3)									//厂家名称
 		S PuomStr=##Class(CHSSWeb.DrugStorage.PhaInfoCommon).GetIncPuom(InciDr)		//入库单位串
 		S PuomDr=$P(PuomStr,"^",1)									//入库单位ID
 		S PuomDesc=$P(PuomStr,"^",2)									//入库单位描述
 		S pRp=##Class(CHSSWeb.DrugStorage.PhaInfoCommon).GetInciLRp(InciDr,PuomDr,HospID)			//入库单位进价
 		S pSp=##Class(CHSSWeb.DrugStorage.PhaInfoCommon).GetPriceElse(InciDr,+$H,PuomDr,HospID)	//入库单位售价
 		S BuomStr=##Class(CHSSWeb.DrugStorage.PhaInfoCommon).GetIncBuom(InciDr)					//基本单位串
 		S BuomDr=$P(BuomStr,"^",1)									//基本单位ID
 		S BuomDesc=$P(BuomStr,"^",2)									//基本单位描述
 		S bRp=##Class(CHSSWeb.DrugStorage.PhaInfoCommon).GetInciLRp(InciDr,BuomDr,HospID)			//基本单位进价
 		S bSp=##Class(CHSSWeb.DrugStorage.PhaInfoCommon).GetPriceElse(InciDr,+$H,BuomDr,HospID)	//基本单位售价
 		S BillUomStr=##Class(CHSSWeb.DrugStorage.PhaInfoCommon).GetArcBuomByInc(InciDr)			//计价单位串
 		S BillUomDr=$P(BillUomStr,"^",1)								//计价单位ID
 		S BillUomDesc=$P(BillUomStr,"^",2)							//计价单位描述
 		S BillRp=##Class(CHSSWeb.DrugStorage.PhaInfoCommon).GetInciLRp(InciDr,BillUomDr,HospID)		//计价单位进价
 		S BillSp=##Class(CHSSWeb.DrugStorage.PhaInfoCommon).GetPriceElse(InciDr,+$H,BillUomDr,HospID)	//计价单位售价
 		S PhcFormStr=##Class(CHSSWeb.DrugStorage.PhaInfoCommon).GetForm(InciDr)					//剂型串
 		S PhcFormCode=$P(PhcFormStr,"^",1)							//剂型代码
 		S PhcFormDesc=$P(PhcFormStr,"^",2)							//剂型描述
 		S GoodName=##Class(CHSSWeb.DrugStorage.PhaInfoCommon).GetGoodName(InciDr)					//商品名
 		S GeneStr=##Class(CHSSWeb.DrugStorage.PhaInfoCommon).GetGene(InciDr)						//通用名
 		S GeneCode=$P(GeneStr,"^",1)									//通用名代码
 		S GeneName=$P(GeneStr,"^",2)									//通用名描述
 		S BuomQty = 0
 		if Locdr '= "" d
 		.S BuomQty=##Class(CHSSWeb.DrugStorage.PhaInfoCommon).IL(InciDr,Locdr,+$H)					//基本单位数量
 		S PFac=##Class(CHSSWeb.DrugStorage.PhaInfoCommon).UOMFac(PuomDr,BuomDr)
 		S PuomQty=0
 		I PFac'=0 S PuomQty=BuomQty/PFac								//入库单位数量
 		S BillFac=##Class(CHSSWeb.DrugStorage.PhaInfoCommon).UOMFac(PuomDr,BuomDr)
 		S BillUomQty=0
 		I BillFac'="" S BillUomQty=BuomQty/BillFac					//计价单位数量
 		S NotUseFlag=$P(^INCI(InciDr,2),"^",9)						//是否使用	
		
		s tmp=InciDr_"^"_InciItem_"^"_InciCode_"^"_InciDesc_"^"_Spec_"^"_ManfName_"^"_PuomDesc_"^"_pRp_"^"_pSp_"^"_PuomQty_"^"_BuomDesc_"^"_bRp_"^"_bSp_"^"_BuomQty_"^"_BillUomDesc_"^"_BillRp_"^"_BillSp_"^"_BillUomQty_"^"_PhcFormDesc_"^"_GoodName_"^"_GeneName_"^"_NotUseFlag
		
		i (count>Start)&(count<=end) d
		.d json.InsertRowData(tmp)
	}
	d result.Close()
	if count>0 d
	.s resultString = json.getJsonData("InciDr^InciItem^InciCode^InciDesc^Spec^ManfName^PuomDesc^pRp^pSp^PuomQty^BuomDesc^bRp^bSp^BuomQty^BillUomDesc^BillRp^BillSp^BillUomQty^PhcFormDesc^GoodName^GeneName^NotUseFlag",count)
	k json
	q resultString
}

}
