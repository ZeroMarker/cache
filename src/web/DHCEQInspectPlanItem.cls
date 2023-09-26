Import SQLUser

Include webimport

IncludeGenerator webimport

Class web.DHCEQInspectPlanItem Extends %Library.RegisteredObject [ Not Abstract, ClassType = "", Not ProcedureBlock ]
{

ClassMethod InsertInspectPlanItem(itmjs As %Library.String = "", itmjsex As %Library.String = "", InspectPlanDR As %String, InspectPartDR As %String, InspectItemDR As %String, Remark As %String)
{
 &sql(Insert into sqluser.DHC_EQInspectPlanItem (IPI_InspectPlanDR,IPI_InspectPartDR,IPI_InspectItemDR,IPI_Remark) values(:InspectPlanDR,:InspectPartDR,:InspectItemDR,:Remark))
  s return=SQLCODE
  i SQLCODE'=0 TROLLBACK
  q return
}

ClassMethod UpdateInspectPlanItem(itmjs As %Library.String = "", itmjsex As %Library.String = "", RowID As %String, InspectPlanDR As %String, InspectPartDR As %String, InspectItemDR As %String, Remark As %String)
{
 &sql(UPDATE sqluser.DHC_EQInspectPlanItem set IPI_InspectPlanDR=:InspectPlanDR,IPI_InspectPartDR=:InspectPartDR,IPI_InspectItemDR=:InspectItemDR,IPI_Remark=:Remark Where IPI_RowID=:RowID)
  s return=SQLCODE
  i SQLCODE'=0 TROLLBACK
  q return
}

ClassMethod DeleteInspectPlanItem(itmjs As %Library.String = "", itmjsex As %Library.String = "", RowID As %String)
{
 &sql(Delete from sqluser.DHC_EQInspectPlanItem Where IPI_RowID=:RowID)
  s return=SQLCODE
  i SQLCODE'=0 TROLLBACK
  q return
}

ClassMethod GetOneInspectPlanItem(itmjs As %Library.String = "", itmjsex As %Library.String = "", rowid)
{
	new result,resultex
	s (result,resultex)=""
	s result=^DHCEQInspectPlanItem(rowid)
	s resultex=resultex_"^"	;InspectPlanDR
	i $p(result,"^",1)'=""  d
	.s resultex=resultex_$p($g(^DHCEQInspectPlan($p(result,"^",1))),"^",1)
	s resultex=resultex_"^"	;InspectPartDR
	i $p(result,"^",2)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCPart",$p(result,"^",2))),"^",2)
	s resultex=resultex_"^"	;InspectItemDR
	i $p(result,"^",3)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCInspectItem",$p(result,"^",3))),"^",2)
	s result=##class(web.DHCEQCommon).Replace(result,$C(13,10),"\n")
	q result_resultex
}

Query GetInspectPlanItem(InspectPlanDR) As %SQLQuery(ROWSPEC = "TRowID:%String,TInspectPlanDR:%String,TInspectPartDR:%String,TInspectPart:%String,TInspectItemDR:%String,TInspectItem:%String,TRemark:%String")
{
SELECT IPI_RowID TRowID,
	   IPI_InspectPlanDR TInspectPlanDR,
	   IPI_InspectPartDR TInspectPartDR, 
	   IPI_InspectPartDR->P_Desc TInspectPart,
	   IPI_InspectItemDR TInspectItemDR,
	   IPI_InspectItemDR->II_Desc TInspectItem,
	   IPI_Remark TRemark
FROM sqluser.DHC_EQInspectPlanItem
where IPI_InspectPlanDR=:InspectPlanDR
}

//

}
