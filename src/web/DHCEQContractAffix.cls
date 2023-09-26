/// modified by ZY0221 202-04-14 修改厂家表字段指向问题
Class web.DHCEQContractAffix Extends %Persistent [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 13;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "CA_RowID";

Parameter SQLDESCRIPTION = "CA_RowID";

Parameter SQLROWID = "CA_RowID";

ClassMethod UpdateData(val, AppType)
{
	s CARowID=$p(val,"^",1)
	s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	s Date=+$H
	s Time=$P($H,",",2)
	TSTART
	if +AppType=0
	{
		s PLIST(2) = $p(val,"^",2)	;ContractListDR
 		s PLIST(3) = $p(val,"^",3)	;AffixDR
 		s PLIST(4) = $p(val,"^",4)	;AffixCatDR
 		s PLIST(5) = $p(val,"^",5)	;PartSpec
 		s PLIST(6) = $p(val,"^",6)	;PartModel
 		s PLIST(7) = $p(val,"^",7)	;ManuFactoryDR
 		s PLIST(8) = $p(val,"^",8)	;QuantityNum
 		s PLIST(9) = $p(val,"^",9)	;ReceiverDR
 		s PLIST(10) = $p(val,"^",10)	;LeaveFacNo
 		s PLIST(11) = $p(val,"^",11)	;LeaveDate
 		i $p(val,"^",11)'=""  s PLIST(11) = ##Class(web.DHCEQCommon).TransValueFromPage($p(val,"^",11),"date")	;LeaveDate
 		s PLIST(12) = $p(val,"^",12)	;PriceFee
 		s PLIST(13) = $p(val,"^",13)	;Remark
 		s PLIST(14) = $p(val,"^",14)	;CurrencyDR
 		if CARowID=""
 		{
	 		&SQL(insert into sqluser.DHC_EQContractAffix values :PLIST())
 		}
 		else
 		{
	 		&SQL(update sqluser.DHC_EQContractAffix values :PLIST() where CA_RowID=:CARowID)
 		}
	}
	if +AppType=2
	{
		&SQL(delete from sqluser.DHC_EQContractAffix where CA_RowID=:CARowID)
	}
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE
	}
	TCOMMIT
	s ID=$G(%ROWID)
	q ID
}

ClassMethod GetOneAffix(rowid)
{
	new result,resultex
	s (result,resultex)=""
	s result= ^DHCEQContractAffix(rowid)
	s resultex=resultex_"^"	;ContractListDR
	//i $p(result,"^",1)'=""  d
	//.s resultex=resultex_$p($g(^DHCEQContractList($p(result,"^",1))),"^",XX)
	s resultex=resultex_"^"	;AffixDR
	i $p(result,"^",2)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCAffix",$p(result,"^",2))),"^",2)
	s resultex=resultex_"^"	;AffixCatDR
	i $p(result,"^",3)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCAffixCat",$p(result,"^",3))),"^",2)
	s resultex=resultex_"^"	;ManuFactoryDR
	i $p(result,"^",6)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCManufacturer",$p(result,"^",6))),"^",1)
	s resultex=resultex_"^"	;ReceiverDR
	i $p(result,"^",8)'=""  d
	.s resultex=resultex_##Class(web.DHCEQCommon).GetTrakNameByID("user",$p(result,"^",8))
	s $p(result,"^",10)=##Class(web.DHCEQCommon).TransValueToPage($p(result,"^",10),"date")	;LeaveDate
	s resultex=resultex_"^"	;CurrencyDR
	i $p(result,"^",13)'=""  d
	.s resultex=resultex_##Class(web.DHCEQCommon).GetTrakNameByID("cur",$p(result,"^",13))
	s result=##class(web.DHCEQCommon).Replace(result,$C(13,10),"\n")
	q result_resultex
}

Query GetAffix(ContractListDR) As %SQLQuery(ROWSPEC = "TRowID:%String,TContractListDR:%String,TAffixDR:%String,TAffix:%String,TAffixCatDR:%String,TAffixCat:%String,TPartSpec:%String,TPartModel:%String,TManuFactoryDR:%String,TManuFactory:%String,TQuantityNum:%String,TReceiverDR:%String,TLeaveFacNo:%String,TLeaveDate:%String,TPriceFee:%String,TRemark:%String,TCurrencyDR")
{
SELECT CA_RowID TRowID,
	   :ContractListDR TContractListDR,
	   CA_AffixDR TAffixDR,
	   CA_AffixDR->A_Desc TAffix,
	   CA_AffixCatDR TAffixCatDR,
	   CA_AffixCatDR->AC_Desc TAffixCat,
	   CA_PartSpec TPartSpec,
	   CA_PartModel TPartModel,
	   CA_ManuFactoryDR TManuFactoryDR,
	   CA_ManuFactoryDR->V_Name TManuFactory,
	   CA_QuantityNum TQuantityNum,
	   CA_ReceiverDR TReceiverDR,
	   CA_LeaveFacNo TLeaveFacNo,
	   CA_LeaveDate TLeaveDate,
	   CA_PriceFee TPriceFee,
	   CA_Remark TRemark,
	   CA_CurrencyDR TCurrencyDR
FROM sqluser.DHC_EQContractAffix
where CA_ContractListDR=:ContractListDR
}

}
