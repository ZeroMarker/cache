Import SQLUser

Include webimport

IncludeGenerator webimport

Class web.DHCEQMaintPart Extends %Library.RegisteredObject [ Not Abstract, ClassType = "", Not ProcedureBlock ]
{

//MTP_RowID	MTP_MaintDR	MTP_FittingsDR	MTP_QuantityNum	MTP_PriceFee	MTP_TotalFee	MTP_Remark

ClassMethod InsertMaintPart(itmjs As %Library.String = "", itmjsex As %Library.String = "", MaintDR, FittingsDR, QuantityNum, PriceFee, TotalFee, Remark, StoreRoomDR, FeeFlag)
{
	TSTART
 &sql(Insert into sqluser.DHC_EQMaintPart (MTP_MaintDR,MTP_FittingsDR,MTP_QuantityNum,MTP_PriceFee,MTP_TotalFee,MTP_Remark,MTP_StoreRoomDR,MTP_FeeFlag) values(:MaintDR,:FittingsDR,:QuantityNum,:PriceFee,:TotalFee,:Remark,:StoreRoomDR,:FeeFlag))
  s return=SQLCODE
  if SQLCODE'=0 {
	  TROLLBACK
  	  q return}
  //s MaintModeDR=##class(web.DHCEQMaint).GetMaintMode(MaintDR)
  S MaintRequestDR=##class(web.DHCEQMaintRequest).GetMaintRequest(MaintDR)
  //s FeeType=##class(web.DHCEQMaintPlan).GetFeeType("","",MaintModeDR)
	//if FeeType="1"
	//{
		s TotalFee=0
		//&sql(select sum(MTP_TotalFee) into :TotalFee from sqluser.DHC_EQMaintPart where MTP_MaintDR=:MaintDR)
		s TotalFee=##class(web.DHCEQMaint).GetTotalFee(MaintDR,2)
		;&sql(update sqluser.DHC_EQMaint set MT_TotalNum=:TotalFee where MT_RowID=:MaintDR)
		; s return=SQLCODE
  		;if SQLCODE'=0 
  		;{TROLLBACK
  		;q return} 
		i MaintRequestDR'=""{
			&sql(update sqluser.DHC_EQMaintRequest set MR_MaintFee=:TotalFee where MR_RowID=:MaintRequestDR)
			s return=SQLCODE
  			if SQLCODE'=0 
  			{TROLLBACK
  			q return}		
		//}
	}
  TCOMMIT
  q return
}

ClassMethod UpdateMaintPart(itmjs As %Library.String = "", itmjsex As %Library.String = "", RowID As %String, MaintDR, FittingsDR, QuantityNum, PriceFee, TotalFee, Remark, StoreRoomDR, FeeFlag)
{
	TSTART
 &sql(UPDATE sqluser.DHC_EQMaintPart set MTP_MaintDR=:MaintDR,MTP_FittingsDR=:FittingsDR,MTP_QuantityNum=:QuantityNum,MTP_PriceFee=:PriceFee,MTP_TotalFee=:TotalFee,MTP_Remark=:Remark,MTP_StoreRoomDR=:StoreRoomDR,MTP_FeeFlag=:FeeFlag Where MTP_RowID=:RowID)
  s return=SQLCODE
  i SQLCODE'=0 {
	  TROLLBACK
  	  q return}
  //s MaintModeDR=##class(web.DHCEQMaint).GetMaintMode(MaintDR)
  S MaintRequestDR=##class(web.DHCEQMaintRequest).GetMaintRequest(MaintDR)
  //s FeeType=##class(web.DHCEQMaintPlan).GetFeeType("","",MaintModeDR)
 	//if FeeType="1"
	//{
		s TotalFee=0
		//&sql(select sum(MTP_TotalFee) into :TotalFee from sqluser.DHC_EQMaintPart where MTP_MaintDR=:MaintDR)
		s TotalFee=##class(web.DHCEQMaint).GetTotalFee(MaintDR,2)
		;&sql(update sqluser.DHC_EQMaint set MT_TotalNum=:TotalFee where MT_RowID=:MaintDR)
		; s return=SQLCODE
  		;if SQLCODE'=0 
  		;{TROLLBACK
  		;q return} 
		i MaintRequestDR'=""{
			&sql(update sqluser.DHC_EQMaintRequest set MR_MaintFee=:TotalFee where MR_RowID=:MaintRequestDR)
			s return=SQLCODE
  			if SQLCODE'=0 
  			{TROLLBACK
  			q return}		
		//}
	}
  TCOMMIT
  q return
}

ClassMethod DeleteMaintPart(itmjs As %Library.String = "", itmjsex As %Library.String = "", RowID As %String)
{
	TSTART
 &sql(Delete from sqluser.DHC_EQMaintPart Where MTP_RowID=:RowID)
  s return=SQLCODE
  i SQLCODE'=0 {
	  TROLLBACK
  	  q return}
  //s MaintModeDR=##class(web.DHCEQMaint).GetMaintMode(MaintDR)
  S MaintRequestDR=##class(web.DHCEQMaintRequest).GetMaintRequest(MaintDR)
  //s FeeType=##class(web.DHCEQMaintPlan).GetFeeType("","",MaintModeDR)
	//if FeeType="1"
	//{
		s TotalFee=0
		//&sql(select sum(MTP_TotalFee) into :TotalFee from sqluser.DHC_EQMaintPart where MTP_MaintDR=:MaintDR)
		s TotalFee=##class(web.DHCEQMaint).GetTotalFee(MaintDR,2)
		;&sql(update sqluser.DHC_EQMaint set MT_TotalNum=:TotalFee where MT_RowID=:MaintDR)
		; s return=SQLCODE
  		;if SQLCODE'=0 
  		;{TROLLBACK
  		;q return} 
		i MaintRequestDR'=""{
			&sql(update sqluser.DHC_EQMaintRequest set MR_MaintFee=:TotalFee where MR_RowID=:MaintRequestDR)
			s return=SQLCODE
  			if SQLCODE'=0 
  			{TROLLBACK
  			q return}		
		//}
	}
  TCOMMIT
  q return
}

ClassMethod GetOneMaintPart(itmjs As %Library.String = "", itmjsex As %Library.String = "", rowid)
{
	new result,resultex
	s (result,resultex)=""
	s result= ^DHCEQMaintPart(rowid)
	s resultex=resultex_"^"	;MaintDR
	i $p(result,"^",1)'=""  d
	.s resultex=resultex_$p($g(^DHCEQMaint($p(result,"^",1))),"^",1)
	s resultex=resultex_"^"	;FittingsDR
	i $p(result,"^",2)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCFittings",$p(result,"^",2))),"^",2)
	s resultex=resultex_"^"	;StoreRoomDR
	i $p(result,"^",7)'=""  d
	.s resultex=resultex_##class(web.DHCEQCommon).GetTrakNameByID("user",$p(result,"^",7))
	s result=##class(web.DHCEQCommon).Replace(result,$C(13,10),"\n")
	q result_resultex
}

Query GetMaintPart(MaintDR) As %SQLQuery(ROWSPEC = "TRowID:%String,TMaintDR:%String,TQuantityNum:%String,TPriceFee:%String,TTotalFee:%String,TFittingsDR:%String,TFittings:%String,TRemark:%String,TStoreRoomDR:%String,TFeeFlag:%String")
{
SELECT MTP_RowID TRowID,
	   :MaintDR TMaintDR,
	   MTP_QuantityNum TQuantityNum, 
	   MTP_PriceFee TPriceFee,
	   MTP_TotalFee TTotalFee,
	   MTP_FittingsDR TFittingsDR,
	   MTP_FittingsDR->F_Desc TFittings,
	   MTP_Remark TRemark,
	   MTP_StoreRoomDR TStoreRoomDR,
	   MTP_FeeFlag TFeeFlag
FROM sqluser.DHC_EQMaintPart
where MTP_MaintDR=:MaintDR
}

}
