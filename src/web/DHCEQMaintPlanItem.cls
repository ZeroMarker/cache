Import SQLUser

Include webimport

IncludeGenerator webimport

Class web.DHCEQMaintPlanItem Extends %Library.RegisteredObject [ Not Abstract, ClassType = "", Not ProcedureBlock ]
{

ClassMethod InsertMaintPlanItem(itmjs As %Library.String = "", itmjsex As %Library.String = "", MaintPlanDR As %String, MaintPartDR As %String, MaintItemDR As %String, Remark As %String)
{
 &sql(Insert into sqluser.DHC_EQMaintPlanItem (MPI_MaintPlanDR,MPI_MaintPartDR,MPI_MaintItemDR,MPI_Remark) values(:MaintPlanDR,:MaintPartDR,:MaintItemDR,:Remark))
  s return=SQLCODE
  i SQLCODE'=0 TROLLBACK
  q return
}

ClassMethod UpdateMaintPlanItem(itmjs As %Library.String = "", itmjsex As %Library.String = "", RowID As %String, MaintPlanDR As %String, MaintPartDR As %String, MaintItemDR As %String, Remark As %String)
{
 &sql(UPDATE sqluser.DHC_EQMaintPlanItem set MPI_MaintPlanDR=:MaintPlanDR,MPI_MaintPartDR=:MaintPartDR,MPI_MaintItemDR=:MaintItemDR,MPI_Remark=:Remark Where MPI_RowID=:RowID)
  s return=SQLCODE
  i SQLCODE'=0 TROLLBACK
  q return
}

ClassMethod DeleteMaintPlanItem(itmjs As %Library.String = "", itmjsex As %Library.String = "", RowID As %String)
{
 &sql(Delete from sqluser.DHC_EQMaintPlanItem Where MPI_RowID=:RowID)
  s return=SQLCODE
  i SQLCODE'=0 TROLLBACK
  q return
}

ClassMethod GetOneMaintPlanItem(itmjs As %Library.String = "", itmjsex As %Library.String = "", rowid)
{
	new result,resultex
	s (result,resultex)=""
	s result= ^DHCEQMaintPlanItem(rowid)
	s resultex=resultex_"^"	;MaintPlanDR
	i $p(result,"^",1)'=""  d
	.s resultex=resultex_$p($g(^DHCEQMaintPlan($p(result,"^",1))),"^",1)
	s resultex=resultex_"^"	;MaintPartDR
	i $p(result,"^",2)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCPart",$p(result,"^",2))),"^",2)
	s resultex=resultex_"^"	;MaintItemDR
	i $p(result,"^",3)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCMaintItem",$p(result,"^",3))),"^",2)
	s resultex=resultex_"^"	;MaintUserDR
	i $p(result,"^",4)'=""  d
	.s resultex=resultex_##class(DHCEQCommon).GetTrakNameByID("user",$p(result,"^",4))
	s result=##class(web.DHCEQCommon).Replace(result,$C(13,10),"\n")
	q result_resultex
}

Query GetMaintPlanItem(MaintPlanDR) As %SQLQuery(ROWSPEC = "TRowID:%String,TMaintPlanDR:%String,TMaintPartDR:%String,TMaintPart:%String,TMaintItemDR:%String,TMaintItem:%String,TRemark:%String")
{
SELECT MPI_RowID TRowID,
	   :MaintPlanDR TMaintPlanDR,
	   MPI_MaintPartDR TMaintPartDR, 
	   MPI_MaintPartDR->P_Desc TMaintPart,
	   MPI_MaintItemDR TMaintItemDR,
	   MPI_MaintItemDR->MI_Desc TMaintItem,
	   MPI_Remark TRemark
FROM sqluser.DHC_EQMaintPlanItem
where MPI_MaintPlanDR=:MaintPlanDR
}

}
