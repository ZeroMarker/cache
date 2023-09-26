Import SQLUser

Include webimport

IncludeGenerator webimport

Class web.DHCEQMaintPlanPart Extends %Library.RegisteredObject [ Not Abstract, ClassType = "", Not ProcedureBlock ]
{

//MPP_RowID	MPP_MaintPlanDR	MPP_FittingsDR	MPP_QuantityNum	MPP_PriceFee	MPP_TotalFee	MPP_Remark

ClassMethod InsertMaintPlanPart(itmjs As %Library.String = "", itmjsex As %Library.String = "", MaintPlanDR, FittingsDR, QuantityNum, PriceFee, TotalFee, Remark, FeeFlag)
{
	TSTART
 &sql(Insert into sqluser.DHC_EQMaintPlanPart (MPP_MaintPlanDR,MPP_FittingsDR,MPP_QuantityNum,MPP_PriceFee,MPP_TotalFee,MPP_Remark,MPP_FeeFlag) values(:MaintPlanDR,:FittingsDR,:QuantityNum,:PriceFee,:TotalFee,:Remark,:FeeFlag))
  s return=SQLCODE
  i SQLCODE'=0 {
	  TROLLBACK
  	  q return}
  //s MaintModeDR=##class(web.DHCEQMaintPlan).GetMaintMode(MaintPlanDR)
  //s FeeType=##class(web.DHCEQMaintPlan).GetFeeType("","",MaintModeDR)
	//if FeeType="1"
	//{
		s TotalFee=0
		//&sql(select sum(Mpp_TotalFee) into :TotalFee from sqluser.DHC_EQMaintPlanPart where Mpp_MaintPlanDR=:MaintPlanDR)
		s TotalFee=##class(web.DHCEQMaintPlan).GetTotalFee(MaintPlanDR,2)
		&sql(update sqluser.DHC_EQMaintPlan set MP_MaintFee=:TotalFee where MP_RowID=:MaintPlanDR)
		 s return=SQLCODE
  		if SQLCODE'=0 
  		{TROLLBACK
  		q return}		
	//}
	TCOMMIT
	q return
}

ClassMethod UpdateMaintPlanPart(itmjs As %Library.String = "", itmjsex As %Library.String = "", RowID As %String, MaintPlanDR, FittingsDR, QuantityNum, PriceFee, TotalFee, Remark, FeeFlag)
{
	TSTART
 &sql(UPDATE sqluser.DHC_EQMaintPlanPart set MPP_MaintPlanDR=:MaintPlanDR,MPP_FittingsDR=:FittingsDR,MPP_QuantityNum=:QuantityNum,MPP_PriceFee=:PriceFee,MPP_TotalFee=:TotalFee,MPP_Remark=:Remark,MPP_FeeFlag=:FeeFlag Where MPP_RowID=:RowID)
  s return=SQLCODE
  i SQLCODE'=0 {
	  TROLLBACK
      q return}
  //s MaintModeDR=##class(web.DHCEQMaintPlan).GetMaintMode(MaintPlanDR)
  //s FeeType=##class(web.DHCEQMaintPlan).GetFeeType("","",MaintModeDR)
	//if FeeType="1"
	//{
		s TotalFee=0
		//&sql(select sum(Mpp_TotalFee) into :TotalFee from sqluser.DHC_EQMaintPlanPart where Mpp_MaintPlanDR=:MaintPlanDR)
		s TotalFee=##class(web.DHCEQMaintPlan).GetTotalFee(MaintPlanDR,2)
		&sql(update sqluser.DHC_EQMaintPlan set MP_MaintFee=:TotalFee where MP_RowID=:MaintPlanDR)
		 s return=SQLCODE
  		if SQLCODE'=0 
  		{TROLLBACK
  		q return}		
	//}
	TCOMMIT
	q return
}

ClassMethod DeleteMaintPlanPart(itmjs As %Library.String = "", itmjsex As %Library.String = "", RowID As %String)
{
	TSTART
 &sql(Delete from sqluser.DHC_EQMaintPlanPart Where MPP_RowID=:RowID)
  s return=SQLCODE
  i SQLCODE'=0 {
	  TROLLBACK
      q return}
  //s MaintModeDR=##class(web.DHCEQMaintPlan).GetMaintMode(MaintPlanDR)
  //s FeeType=##class(web.DHCEQMaintPlan).GetFeeType("","",MaintModeDR)
	//if FeeType="1"
	//{
		s TotalFee=0
		//&sql(select sum(Mpp_TotalFee) into :TotalFee from sqluser.DHC_EQMaintPlanPart where Mpp_MaintPlanDR=:MaintPlanDR)
		s TotalFee=##class(web.DHCEQMaintPlan).GetTotalFee(MaintPlanDR)
		&sql(update sqluser.DHC_EQMaintPlan set MP_MaintFee=:TotalFee where MP_RowID=:MaintPlanDR)
		 s return=SQLCODE
  		if SQLCODE'=0 
  		{TROLLBACK
  		q return}		
	//}
	TCOMMIT
	q return
}

ClassMethod GetOneMaintPlanPart(itmjs As %Library.String = "", itmjsex As %Library.String = "", rowid)
{
	new result,resultex
	s (result,resultex)=""
	s result= ^DHCEQMaintPlanPart(rowid)
	s resultex=resultex_"^"	;MaintPlanDR
	i $p(result,"^",1)'=""  d
	.s resultex=resultex_$p($g(^DHCEQMaintPlan($p(result,"^",1))),"^",1)
	s resultex=resultex_"^"	;FittingsDR
	i $p(result,"^",2)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCFittings",$p(result,"^",2))),"^",2)
	s result=##class(web.DHCEQCommon).Replace(result,$C(13,10),"\n")
	q result_resultex
}

Query GetMaintPlanPart(MaintPlanDR) As %SQLQuery(ROWSPEC = "TRowID:%String,TMaintPlanDR:%String,TQuantityNum:%String,TPriceFee:%String,TTotalFee:%String,TFittingsDR:%String,TFittings:%String,TRemark:%String,TFeeFlag:%String")
{
SELECT MPP_RowID TRowID,
	   :MaintPlanDR TMaintPlanDR,
	   MPP_QuantityNum TQuantityNum, 
	   MPP_PriceFee TPriceFee,
	   MPP_TotalFee TTotalFee,
	   MPP_FittingsDR TFittingsDR,
	   MPP_FittingsDR->F_Desc TFittings,
	   MPP_Remark TRemark,
	   MPP_FeeFlag TFeeFlag
FROM sqluser.DHC_EQMaintPlanPart
where MPP_MaintPlanDR=:MaintPlanDR
}

}
