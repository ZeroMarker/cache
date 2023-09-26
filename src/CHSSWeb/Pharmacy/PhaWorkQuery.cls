Class CHSSWeb.Pharmacy.PhaWorkQuery Extends (%RegisteredObject, %XML.Adaptor) [ Inheritance = right, Not ProcedureBlock ]
{

/// creator:zhangyong
/// date:2011-11-1
/// description: 药师工作量统计查询
/// input:  StartDate(起始日期)  EndDate(结束日期)  PhaLoc(药房)  CFydr(发药人员)  Typ(类型)  Start  Limit 
/// output: String 
/// others:
ClassMethod PhaWorkQueryMaster(StartDate, EndDate, PhaLoc, CFydr, Type, Start, Limit) As %Library.String
{
	s StartDate = $zdh(StartDate, 3)
	s EndDate = $zdh(EndDate, 3)
	s PhaLoc = $ORDER(^DHCPHLOCi("LOC",PhaLoc,0))
	s json = ##class(Code.JsonObj).%New()
	s count = 0
	s resultString = ""
	
	s sqlStr1 = "SELECT '发药' AS TYPE_DESC, A.PHD_PHL_DR AS PhaLoc, A.PHD_PHP_PYDR as PHA_DR, count(DISTINCT A.PHD_ROWID) as SUM_COUNT, SUM(B.PHDI_PAYAMOUNT) AS SUM_AMOUNT "_
			   "FROM Dhc_phdispen A, Dhc_phdisitem B "_
			   "WHERE A.PHD_ROWID = B.PHDI_PHD_PARREF AND A.PHD_FYDATE BETWEEN "_StartDate_" AND "_EndDate_" "_
			   "AND A.PHD_PHL_DR = '"_PhaLoc_"' "_
			   "AND A.PHD_FYFLAG = '1' "
	s group1 = " GROUP BY A.PHD_PHL_DR, A.PHD_PHP_PYDR"
		
	s sqlStr2 = "SELECT '退药' AS TYPE_DESC, A.PHRET_PHL_DR AS PhaLoc, A.PHRET_PHP_DR as PHA_DR, count(DISTINCT a.phret_rowid) as SUM_COUNT, SUM(B.PHRTI_AMOUNT) AS SUM_AMOUNT "_
			"FROM dhc_phreturn A, dhc_phretitm B "_
			"WHERE A.PHRET_ROWID = B.PHRTI_PHRET_PARREF AND A.PHRET_dATE BETWEEN "_StartDate_" AND "_EndDate_" "_
			"AND A.PHRET_PHL_DR = '"_PhaLoc_"' "
	s group2 = " GROUP BY A.PHRET_PHL_DR, A.PHRET_PHP_DR"
	S sqlStr = ""
	
	IF (CFydr'="")
	{
		S sqlStr1 = sqlStr1_" AND A.PHD_PHP_PYDR = '"_CFydr_"' "_group1
		S sqlStr2 = sqlStr2_" AND A.PHRET_PHP_DR = '"_CFydr_"' "_group2
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
		s PhaName = $p(^DHCPHPER(result.Data("PHA_DR")),"^",2)
		s SumCount = result.Data("SUM_COUNT")
		s SumAmount = result.Data("SUM_AMOUNT")
		s tmp=RowNum_"^"_TypeDesc_"^"_PhaLoc_"^"_PhaName_"^"_SumCount_"^"_SumAmount
		s count = count+1
		i (count>Start)&(count<=end) d
		.d json.InsertRowData(tmp)
	}
	d result.Close()
	
	s resultString = json.getJsonData("RowNum^TypeDesc^PhaLoc^PhaName^Count^Amount",count)
	k json
	w resultString
	q resultString
}

}
