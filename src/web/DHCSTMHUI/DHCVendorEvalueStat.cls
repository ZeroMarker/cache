Import sqluser

/// Descript:	供应商评价统计
/// Creater:	tsr
/// CreateDate:	2018-09-10
Class web.DHCSTMHUI.DHCVendorEvalueStat Extends (%RegisteredObject, StkTypeM) [ Not ProcedureBlock ]
{

Query QueryDetail(Params As %Text) As Query(ROWSPEC = "RowId,Vendor,VendorDesc,EvalIndex,VEIDesc,VEIWeight:%Float,Score:%Float,Remark,EvalDate,EachScore:%Float") [ SqlProc ]
{
}

ClassMethod QueryDetailExecute(ByRef qHandle As %Binary, Params As %Text) As %Status
{
	n (qHandle,Params)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	q:Sc'=0 $$$OK
	s StartDate=PJObj.%Get("StartDate")
	s EndDate=PJObj.%Get("EndDate")
	s pVendor=PJObj.%Get("Vendor")
	s pEvalIndex=PJObj.%Get("EvalIndex")
	s StartDate=..DH2L(StartDate)
	s EndDate=..DH2L(EndDate)

 	s SqlStr="SELECT %ID RowId,"
 	s SqlStr=SqlStr_"VE_APCVM_DR,"
 	s SqlStr=SqlStr_"VE_VEI_DR,"
 	s SqlStr=SqlStr_"VE_Score,"
 	s SqlStr=SqlStr_"VE_Remarks,"
 	s SqlStr=SqlStr_"VE_Date"
 	s SqlStr=SqlStr_" FROM DHC_VendorEvaluation"
 	s SqlStr=SqlStr_" WHERE VE_Date BETWEEN '"_StartDate_"' AND '"_EndDate_"'"
 	
 	s xrs=##class(%Library.ResultSet).%New()
 	d xrs.Prepare(SqlStr)
 	s xrs.RuntimeMode=0
 	s sc=xrs.Execute()
 	i $$$ISERR(sc) q $$$OK
 	while(xrs.Next())
 	{
	 	s RowId=xrs.Data("RowId")
	 	s Vendor=xrs.Data("VE_APCVM_DR")
	 	s EvalIndex=xrs.Data("VE_VEI_DR")
	 	s Score=xrs.Data("VE_Score")
	 	s Remark=xrs.Data("VE_Remarks")
	 	s EvalDate=xrs.Data("VE_Date")
	 	continue:(pVendor'="")&&(pVendor'=Vendor)
	 	continue:(pEvalIndex'="")&&(pEvalIndex'=EvalIndex)
	 	s EvalDate=..DL2H(EvalDate)
		s (VendorDesc,VEIDesc,VEIWeight)=""
 		s:Vendor'="" VendorDesc=$p(^APC("APCVM",Vendor),"^",3)
 		s:EvalIndex'="" VEIDesc=$p(^DHCVEI(EvalIndex),"^",2)
 		s:EvalIndex'="" VEIWeight=$p(^DHCVEI(EvalIndex),"^",3)
 		s:VEIWeight="" VEIWeight=1
 		s EachScore=Score*VEIWeight
 		d OutPutRow
 	}
 	d xrs.Close()
	Quit $$$OK
	
OutPutRow
	s Data=$lb(RowId,Vendor,VendorDesc,EvalIndex,VEIDesc,VEIWeight,Score,Remark,EvalDate,EachScore)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

}
