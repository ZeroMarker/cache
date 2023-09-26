Class CHSSWeb.Pharmacy.OutSellPhaQuery Extends (%RegisteredObject, %XML.Adaptor) [ Inheritance = right, Not ProcedureBlock ]
{

/// creator:zhangyong
/// date:2011-11-1
/// description: 门诊药品销售统计查询
/// input:  StartDate(起始日期)  EndDate(结束日期)  PhaLoc(药房)  Typ(类型)  InciItem(药品编码) Start  Limit 
/// output: String 
/// others:
ClassMethod OutSellPhaMaster(StartDate, EndDate, PhaLoc, Type, InciItem, Start, Limit) As %Library.String
{
	s StartDate = $zdh(StartDate, 3)
	s EndDate = $zdh(EndDate, 3)
	s PhaLoc = $ORDER(^DHCPHLOCi("LOC",PhaLoc,0))
	s json = ##class(Code.JsonObj).%New()
	s count = 0
	s resultString = ""
	
	s sqlStr1 = "SELECT '发药' AS TYPE_DESC, A.PHD_PHL_DR AS PhaLoc, C.OEORI_ITMMast_dr AS ITEM, SUM(B.PHDI_QTY) AS SUM_QTY, SUM(B.PHDI_PAYAMOUNT) AS SUM_AMT "_
			   "FROM Dhc_phdispen A, Dhc_phdisitem B, OE_OrdItem C "_
			   "WHERE A.PHD_ROWID = B.PHDI_PHD_PARREF "_
			   "AND A.PHD_PRESCNO = C.OEORI_PrescNo "_
			   "AND B.PHDI_OEORI_DR = C.OEORI_ROWID "_
			   "AND A.PHD_FYDATE BETWEEN "_StartDate_" AND "_EndDate_" "_
			   "AND A.PHD_PHL_DR = '"_PhaLoc_"' "_
			   "AND A.PHD_FYFLAG = '1' "
	s group1 = "GROUP BY A.PHD_PHL_DR, C.OEORI_ITMMast_dr"
		
	s sqlStr2 = "SELECT '退药' AS TYPE_DESC, A.PHRET_PHL_DR AS PhaLoc, C.OEORI_ITMMast_dr AS ITEM, "_
			"SUM(B.PHRTI_RETQTY) AS SUM_QTY, -1 * SUM(B.PHRTI_AMOUNT) AS SUM_AMT "_
			"FROM dhc_phreturn A, dhc_phretitm B, OE_OrdItem C "_
			"WHERE A.PHRET_ROWID = B.PHRTI_PHRET_PARREF "_
			"AND B.PHRTI_OEORI_DR=C.OEORI_ROWID "_
			"AND A.PHRET_dATE BETWEEN "_StartDate_" AND "_EndDate_" "_
			"AND A.PHRET_PHL_DR = '"_PhaLoc_"' "
	s group2 = "GROUP BY A.PHRET_PHL_DR, C.OEORI_ITMMast_dr"
	S sqlStr = ""
	
	IF (InciItem'="")
	{
		S sqlStr1 = sqlStr1_" AND C.OEORI_ItmMast_DR = '"_InciItem_"' "_group1
		S sqlStr2 = sqlStr2_" AND C.OEORI_ItmMast_DR = '"_InciItem_"' "_group2
	}
	ELSE
	{
		S sqlStr1 = sqlStr1_group1
		S sqlStr2 = sqlStr2_group2
	}
	
	IF (Type="0"){
		S sqlStr= sqlStr1_" UNION ALL "_sqlStr2
	}
	ELSEIF Type="1"{
		S sqlStr= sqlStr1
	}
	ELSE{
		S sqlStr= sqlStr2
	}
	
	s result = ##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	s end = Start+Limit
	While(result.Next())
	{
		s RowNum = count + 1
		s TypeDesc = result.Data("TYPE_DESC")
		s PhaLoc = $P(^CTLOC($P(^DHCPHLOC(result.Data("PhaLoc")), "^", 1)),"^", 2)
		s DrugDr = result.Data("ITEM")
		s dispqty = result.Data("SUM_QTY")
		S INFO = ..GetPhaInfo(DrugDr, dispqty)
		S DrugCode = $P(INFO, "^",1)
		S DrugName = $P(INFO, "^",2)
		S DgSpecification = $P(INFO, "^",3)
		S DgTyperDesc = $P(INFO, "^",4)
		S Qty = $P(INFO, "^",5)
		S DrugUnit = $P(INFO, "^",6)
		s Amount = result.Data("SUM_AMT")
		s tmp=RowNum_"^"_TypeDesc_"^"_PhaLoc_"^"_DrugCode_"^"_DrugName_"^"_DgSpecification_"^"_DgTyperDesc_"^"_Qty_"^"_DrugUnit_"^"_Amount
		s count = count+1
		i (count>Start)&(count<=end) d
		.d json.InsertRowData(tmp)
	}
	d result.Close()
	
	s resultString = json.getJsonData("RowNum^TypeDesc^PhaLoc^DrugCode^DrugName^DgSpecification^DgTyperDesc^Qty^DrugUnit^Amount",count)
	k json
	w resultString
	q resultString
}

/// creator:zhangyong
/// date:2011-11-1
/// description: 取得药品信息
/// input:  DrugDr(药品RowID)  Dispqty(发药数量<小单位>)
/// output: String DrugCode^DrugName^DgSpecification^DgTyperDesc^Qty^DrugUnit
/// others:
ClassMethod GetPhaInfo(DrugDr, Dispqty) As %Library.String
{
	s Drug = ^ARCIM($P(DrugDr, "||",1),$P(DrugDr, "||",2),1)
	s DrugCode = $P(Drug, "^", 1)
	s DrugName = $P(Drug, "^", 2)
	s inci=""
	s inci=$o(^INCI(0,"ARCIM_DR",$P(DrugDr,"||",1),inci))
	q:inci=""
	s inci=$p(inci,$c(1),1)
	s DgSpecification = ##class(web.DHCOutPhDisp).GetPhgg(inci)
	s DgTyperDesc = $P(^ARC("IC", $P(Drug, "^", 10)),"^",2)
	s dispqty = Dispqty
		
	s itmmastid=$P(DrugDr, "||",1)
	s itmmastver=$P(DrugDr, "||",2)
	s phuomid=$p(^ARCIM(itmmastid,itmmastver,8),"^",14)
	q:phuomid=""
	s phuomid=$p(phuomid,$c(1),1)
	s phuomdesc=$p($g(^CT("UOM",phuomid)),"^",2)
	s basuom =+$p(^INCI(inci,1),"^",10)
	s basuomdesc=$p($g(^CT("UOM",basuom)),"^",2)
	s confac=1,conrow=""
	i basuom=phuomid s confac=1
	e  d
	.s conrow=$o(^CT("CTCF",0,"UOM",phuomid,basuom,conrow))
	.i conrow'="" s confac=+$p(^CT("CTCF",conrow),"^",3)
	s getnum=$p((dispqty/confac),".",1)
	i getnum=(dispqty/confac)  d
	.s DrugUnit=phuomdesc
	.s Qty=getnum
	e  d
	.s DrugUnit=basuomdesc
	.s Qty=dispqty
	s resultString = DrugCode_"^"_DrugName_"^"_DgSpecification_"^"_DgTyperDesc_"^"_Qty_"^"_DrugUnit
	q resultString
}

}
